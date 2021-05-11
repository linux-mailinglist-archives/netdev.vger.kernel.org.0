Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A6A37B137
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 00:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhEKWB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 18:01:56 -0400
Received: from mout.gmx.net ([212.227.17.22]:54817 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhEKWBz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 18:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1620770433;
        bh=Ezf3+4/5WESk8OkhoMsaJlcqfc3Htg1LJN1RDH+6u1k=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=gN58ZNyDm+TQF5yCreJxdhLCIZVdkhlvj5FtoQNH7RyqlhZzdxcmqgsNCeWzUridt
         b99U8Q9lMRwpG8k7PHLKiTo9jCkd0gjvASj+6NaadIDwEdQylsG9svo+6GbbRQU7kg
         Jq1TnSGbRz912Kw2AssFZYj4M5TLQNVX42vCve/w=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [89.247.255.239] ([89.247.255.239]) by web-mail.gmx.net
 (3c-app-gmx-bap63.server.lan [172.19.172.133]) (via HTTP); Wed, 12 May 2021
 00:00:33 +0200
MIME-Version: 1.0
Message-ID: <trinity-10aeed49-cb96-47d9-818e-b938913e6fce-1620770433273@3c-app-gmx-bap63>
From:   Norbert Slusarek <nslusarek@gmx.net>
To:     oss-security@lists.openwall.com
Cc:     netdev@vger.kernel.org, socketcan@hartkopp.net, mkl@pengutronix.de,
        alex.popov@linux.com, linux-can@vger.kernel.org,
        seth.arnold@canonical.com, steve.beattie@canonical.com,
        cascardo@canonical.com
Subject: Linux kernel: net/can/isotp: race condition leads to local
 privilege escalation
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 12 May 2021 00:00:33 +0200
Importance: normal
Sensitivity: Normal
X-Priority: 3
X-Provags-ID: V03:K1:sTuBeu26LFRf9uFTz8G/CIAspz4RlbypygBf7W0g+BG51Z19YdJL6eE3XgacocgX9E5hQ
 e+dDjOA3/EkoXbJo5U6DalUUgrJ/kNxwXEsEOWU2QRHdiHbiMjbcvVvwrPla846b1D8+4ac8P23p
 VluC8Dj1X56VtiIrUSCjRJqg3wGcdnWwu9zf//JlGtKXDulxThX6x5nwCiA42RHaxNOmEz+u7stB
 CqIoWZnqXndk1VKnRDpWzNfE/EOA1IOLk0AX64ombKQ+FPkYkORLBs4wRGX0gtuk5+Yh/OF8QiKa
 lQ=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:eHrAPSba1PY=:uLosab/yJfOjF8kNOcEO8F
 JusYW6oNwA+VO55rLhhXgjWHAPSp/KZKaM0RzQ8N6amlXs346TFYDAqNXUJgHRNzcLSb/Hng7
 4YIDTtQBeAyYsrDMiBrj/8WBQrFk1WDB+TOU3wNQDjxxDfRrOe+bJpL5OfEqMd4xHjSBdKj9A
 rV+lYKoNgQPDtrxSQE5nUNcvRA+V3bXdbfv4mwpkrj3O2cr+9/bIXXxDsZSjviq7WWGi7/u19
 MzMXUu91TgT8+/A7yw6rJ3x7mPR9KLBTN7ZNAFpV6p1a7xREINc67Bo+lbcQ1PZurDVIZHEaC
 Dz41Y601DfmsdwfcmKQZBp8QI6Eyj404tvSY37dFHZ0B2RXCGI2EP/KlS2ERTuXJG8EvIBUa4
 dpCfnnNvCwbjGYMm7famU+BODbXX6pfbS2XHnLi9Z9+9yZyzvnJkOO0r9yzlJI+Qt6OsoNcuB
 vkJQ4kHHRvwo80LKeeLGe1hMAAVlfOX/ZSRfsYYw3Nx0ZqAtpb33OBcJ3NkJmSvvOs9+ED0lG
 AJgbJdNSSLNsbNa+v3A+mliBPzVqLj2tyuvdZwlnqglQ9nevR/KqhnMwvGGnH7i60RXTkFxT1
 u7qU+6zgdUmcwJUH6B5Z+ae4doK+qsu/qCcIFLhXNGu7aPgjXggEgYfOqNLIXnt836UBPPodl
 dath8Yt1ZXLbqEIFqyMgptvehlPILsaEzTvkIDxff52LHMFkDVZAymHzDt1jLK0H53976d9Xz
 X3fMae4pX+LUais4xPvS4qlmNethvylnjVJau+IUr/E6bjuLeSdsei8NAJcB2Kt0YFHhoQPR8
 bGYG16TRBxukpeWRnFHOheUItanLBhycf47dL/mBL92AVAgob5pTUY0Ofyvns3a1SGWYvUpCt
 8ngmbKQ2PfVnNfScwcYSnaI67lw8vhsQzYn6ECcv9y4dQxtVHDrd2Yy0uQcbVI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A race condition in the CAN ISOTP networking protocol was discovered which
allows forbidden changing of socket members after binding the socket.

In particular, the lack of locking behavior in isotp_setsockopt() makes it
feasible to assign the flag CAN_ISOTP_SF_BROADCAST to the socket, despite having
previously registered a can receiver. After closing the isotp socket, the can
receiver will still be registered and use-after-free's can be triggered in
isotp_rcv() on the freed isotp_sock structure.
This leads to arbitrary kernel execution by overwriting the sk_error_report()
pointer, which can be misused in order to execute a user-controlled ROP chain to
gain root privileges.

The vulnerability was introduced with the introduction of SF_BROADCAST support
in commit 921ca574cd38 ("can: isotp: add SF_BROADCAST support for functional
addressing") in 5.11-rc1.
In fact, commit 323a391a220c ("can: isotp: isotp_setsockopt():
block setsockopt on bound sockets") did not effectively prevent isotp_setsockopt()
from modifying socket members before isotp_bind().

The requested CVE ID will be revealed along with further exploitation details
as a response to this notice on 13th May of 2021.

Credits: Norbert Slusarek

*** exploit log ***

Adjusted to work with openSUSE Tumbleweed.

noprivs@suse:~/expl> uname -a
Linux suse 5.12.0-1-default #1 SMP Mon Apr 26 04:25:46 UTC 2021 (5d43652) x86_64 x86_64 x86_64 GNU/Linux
noprivs@suse:~/expl> ./lpe
[+] entering setsockopt
[+] entering bind
[+] left bind with ret = 0
[+] left setsockopt with flags = 838
[+] race condition hit, closing and spraying socket
[+] sending msg to run softirq with isotp_rcv()
[+] check sudo su for root rights
noprivs@suse:~/expl> sudo su
suse:/home/noprivs/expl # id
uid=0(root) gid=0(root) groups=0(root)
suse:/home/noprivs/expl # cat /root/check
high school student living in germany looking for an internship in info sec.
if interested please reach out to nslusarek@gmx.net.

Regards,
Norbert Slusarek
