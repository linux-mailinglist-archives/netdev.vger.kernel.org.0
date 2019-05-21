Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E705425423
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 17:36:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfEUPg6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 21 May 2019 11:36:58 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44276 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfEUPgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 11:36:55 -0400
Received: by mail-lj1-f194.google.com with SMTP id e13so16239309ljl.11
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 08:36:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xHcmjVDAiLTnPECUNX89YGAM+as77xb3JfSt8ueMttg=;
        b=ZkwQuH6EsmcmnIK2jvbhTc55//aVTIUAaQ6cXlFxe0QAVXIJDwhafBlAf+X1NG6UDM
         9UabpayRpn8JS9wDkD1Vpg9AS2uim9p7eC7DbNLjKcRPro4gNKIux0P3X4VEPITw1Hz+
         TUzQqrFUd/msIpzIAMF3unLYXfE3L/Dvk3ohbe1ra1mVNcT2cmVThx3/hVeJckaETd5m
         zLTdN+gdgGB2DMoCOHYG3Vn2X215/XuMu9SnyR/Q7JG9XBmLeENkUvCiFRkvkT8wOhG5
         mLS8vqhazGGQGvTfvjeELe0yKHEaKRLeBhQdh8/ZuU2VjyJCRl6ESYhgKP3dKGvbEE0t
         JaEA==
X-Gm-Message-State: APjAAAW48OzRfBq7/PZk6XUQolVlVYDiPB73D+29sgG5OvqoJGXOs6VX
        LS8WGhZb47ju4Vp4ZGUX/0+NgLg2CRL6qb54LUkaXg==
X-Google-Smtp-Source: APXvYqxId1+Y+bq1lPj/Yok6ty2jTLWDK5G0XffsUKbymfGbxMl73FDP+m7u8QVhacYIjtFI63q52PwI7BY03+/Ek5A=
X-Received: by 2002:a2e:8741:: with SMTP id q1mr19418098ljj.97.1558453013827;
 Tue, 21 May 2019 08:36:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190518004639.20648-1-mcroce@redhat.com> <CAGnkfhxt=nq-JV+D5Rrquvn8BVOjHswEJmuVVZE78p9HvAg9qQ@mail.gmail.com>
 <20190520133830.1ac11fc8@cakuba.netronome.com> <dfb6cf40-81f4-237e-9a43-646077e020f7@iogearbox.net>
In-Reply-To: <dfb6cf40-81f4-237e-9a43-646077e020f7@iogearbox.net>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Tue, 21 May 2019 17:36:17 +0200
Message-ID: <CAGnkfhxZPXUvBemRxAFfoq+y-UmtdQH=dvnyeLBJQo43U2=sTg@mail.gmail.com>
Subject: Re: [PATCH 1/5] samples/bpf: fix test_lru_dist build
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 5:21 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 05/20/2019 10:38 PM, Jakub Kicinski wrote:
> > On Mon, 20 May 2019 19:46:27 +0200, Matteo Croce wrote:
> >> On Sat, May 18, 2019 at 2:46 AM Matteo Croce <mcroce@redhat.com> wrote:
> >>>
> >>> Fix the following error by removing a duplicate struct definition:
> >>
> >> Hi all,
> >>
> >> I forget to send a cover letter for this series, but basically what I
> >> wanted to say is that while patches 1-3 are very straightforward,
> >> patches 4-5 are a bit rough and I accept suggstions to make a cleaner
> >> work.
> >
> > samples depend on headers being locally installed:
> >
> > make headers_install
> >
> > Are you intending to change that?
>
> +1, Matteo, could you elaborate?
>
> On latest bpf tree, everything compiles just fine:
>
> [root@linux bpf]# make headers_install
> [root@linux bpf]# make -C samples/bpf/
> make: Entering directory '/home/darkstar/trees/bpf/samples/bpf'
> make -C ../../ /home/darkstar/trees/bpf/samples/bpf/ BPF_SAMPLES_PATH=/home/darkstar/trees/bpf/samples/bpf
> make[1]: Entering directory '/home/darkstar/trees/bpf'
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND  objtool
> make -C /home/darkstar/trees/bpf/samples/bpf/../../tools/lib/bpf/ RM='rm -rf' LDFLAGS= srctree=/home/darkstar/trees/bpf/samples/bpf/../../ O=
>   HOSTCC  /home/darkstar/trees/bpf/samples/bpf/test_lru_dist
>   HOSTCC  /home/darkstar/trees/bpf/samples/bpf/sock_example
>

Hi all,

I have kernel-headers installed from master, but yet the samples fail to build:

matteo@turbo:~/src/linux/samples/bpf$ rpm -q kernel-headers
kernel-headers-5.2.0_rc1-38.x86_64

matteo@turbo:~/src/linux/samples/bpf$ git describe HEAD
v5.2-rc1-97-g5bdd9ad875b6

matteo@turbo:~/src/linux/samples/bpf$ make
make -C ../../ /home/matteo/src/linux/samples/bpf/
BPF_SAMPLES_PATH=/home/matteo/src/linux/samples/bpf
make[1]: Entering directory '/home/matteo/src/linux'
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
make -C /home/matteo/src/linux/samples/bpf/../../tools/lib/bpf/ RM='rm
-rf' LDFLAGS= srctree=/home/matteo/src/linux/samples/bpf/../../ O=
  HOSTCC  /home/matteo/src/linux/samples/bpf/test_lru_dist
/home/matteo/src/linux/samples/bpf/test_lru_dist.c:39:8: error:
redefinition of ‘struct list_head’
   39 | struct list_head {
      |        ^~~~~~~~~
In file included from /home/matteo/src/linux/samples/bpf/test_lru_dist.c:9:
./tools/include/linux/types.h:69:8: note: originally defined here
   69 | struct list_head {
      |        ^~~~~~~~~
make[2]: *** [scripts/Makefile.host:90:
/home/matteo/src/linux/samples/bpf/test_lru_dist] Error 1
make[1]: *** [Makefile:1762: /home/matteo/src/linux/samples/bpf/] Error 2
make[1]: Leaving directory '/home/matteo/src/linux'
make: *** [Makefile:231: all] Error 2

Am I missing something obvious?


Regards,


--
Matteo Croce
per aspera ad upstream
