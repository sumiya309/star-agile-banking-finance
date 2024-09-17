resource "aws_instance" "test-server" {
  ami           = "ami-0e86e20dae9224db8"  # Replace with your AMI
  instance_type = "t2.micro"
  key_name      = "jenkins-sum"
  vpc_security_group_ids = ["sg-0791326bb027a9835"]

  tags = {
    Name = "test-server"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./jenkins-sum.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'wait to start the instance'"
    ]
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > inventory"
  }

  provisioner "local-exec" {
    command = "ansible-playbook /var/lib/jenkins/workspace/Banking-Finance/terraform-files/ansibleplaybook.yml"
  }
}
