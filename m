Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D0C4FBD96
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 15:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346659AbiDKNqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 09:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346664AbiDKNqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 09:46:47 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2B74BF5D;
        Mon, 11 Apr 2022 06:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=K7iqjzEKodptiKfvuoGAMKfPEDKK9H4ydTx0zlRIMKY=; b=qcK9XJ8Q2+wciYd8XEvPaxKZnp
        UwQgcpEJ7ZkTnx+UrI37FNE0fCsVoqAWvkDeSDv9dZKFVuPS/MjQ6ShGeOgPZam/2qLZ3GMuyYecG
        /kiXOq6dLZIC9TX74OsTLuMw6D/bBqCn6Qe/4za6at/biJANLw7M5/3wGfKVDWAHJH0bLomI/B2G5
        T505keIvdngq7ChrVG6p8l3xIoOCy224mEs6xVnzQVgkcYJleaCJmi/pE9C/3ZkeSBy+3q6aD/L+P
        lx9RTKE0O5E0nk6SF/DJKQ6X8O29U4l5GnRF+pFb2emmZpWalwtFWuWpQAbdy3ii4v+8R39z3Z0Qc
        3AIGVmHrh+0h0r59nuOWsUFBq/ZJBKV/xYhj7NgWUcYAvhRr2X7p3w0kbhLcn2jPQPAUBzCZ6w6mN
        +FK0cgvJ1CIwVcYOjcIWg+Y6MaC+zIg8G5aFZiKuvZm4O+6bqo0WdwUK0PMR/ALvVKEJjW/08zmui
        Yj7wlw+y2FKuRKchgUJE28ourWKJnfggV3IcrMGfLVuoFJllRgMUw73U/qKpICZp4ADZN9PVqUcTU
        V82Nu1C4+hgBcFz5qZDAvF7Tj+98MPLBDPAnXmLWaOoS/P2U04Vc5Abr7GzeZyyWd0Ewy05tIdjEI
        SJR/vXXb5TVHXPkGF3an3AHefyZQ4MxER1Mnbb37s=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
Date:   Mon, 11 Apr 2022 15:41:45 +0200
Message-ID: <3119964.Qa6D4ExsIi@silver>
In-Reply-To: <YlNgN5f1KnT1walD@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <1966295.VQPMLLWD4E@silver> <YlNgN5f1KnT1walD@codewreck.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Montag, 11. April 2022 00:54:47 CEST asmadeus@codewreck.org wrote:
> Thanks for keeping it up!
> 
> Christian Schoenebeck wrote on Sun, Apr 10, 2022 at 06:18:38PM +0200:
> > > I used git-bisect to identify the commit that broke 9p behaviour, and it
> > > is
> > > indeed this one:
> > > 
> > > commit eb497943fa215897f2f60fd28aa6fe52da27ca6c (HEAD, refs/bisect/bad)
> > > Author: David Howells <dhowells@redhat.com>
> > > Date:   Tue Nov 2 08:29:55 2021 +0000
> > > 
> > >     9p: Convert to using the netfs helper lib to do reads and caching
> 
> Yes, quite a few things changed with that.
> 
> > I looked into the errors I get, and as far as I can see it, all
> > misbehaviours that I see, boil down to "Bad file descriptor" (EBADF)
> > errors being the originating cause.
> > 
> > The easiest misbehaviours on the guest system I can look into, are errors
> 
> > with the git client. For instance 'git fetch origin' fails this way:
> FWIW I didn't report but did try to reproduce, on my machines (tried a
> couple) booting on a small alpine rootfs over 9p works, and I tried some
> git clone/git fetch of variying sizes of local repo (tmpfs in VM -> 9p
> mount of tmpfs on host) to no avail.

I get more convinced that it's a bug on Linux kernel side. When guest is
booted I always immediately get a read("/var/log/wtmp") = EBADF error on
guest. And the 9p command sequence sent to QEMU 9p server were:

...
v9fs_clunk tag 0 id 120 fid 568
v9fs_walk tag 0 id 110 fid 1 newfid 568 nwnames 1
v9fs_rerror tag 0 id 110 err 2
v9fs_walk tag 0 id 110 fid 26 newfid 568 nwnames 1
v9fs_rerror tag 0 id 110 err 2
v9fs_readlink tag 0 id 22 fid 474
v9fs_readlink_return tag 0 id 22 name /run
v9fs_readlink tag 0 id 22 fid 474
v9fs_readlink_return tag 0 id 22 name /run
v9fs_readlink tag 0 id 22 fid 474
v9fs_readlink_return tag 0 id 22 name /run
v9fs_readlink tag 0 id 22 fid 474
v9fs_readlink_return tag 0 id 22 name /run
v9fs_walk tag 0 id 110 fid 633 newfid 568 nwnames 1
v9fs_rerror tag 0 id 110 err 2
v9fs_walk tag 0 id 110 fid 875 newfid 568 nwnames 0
v9fs_walk_return tag 0 id 110 nwnames 0 qids (nil)
v9fs_open tag 0 id 12 fid 568 mode 32769
v9fs_open_return tag 0 id 12 qid={type 0 version 0 path 820297} iounit 507904
v9fs_walk tag 0 id 110 fid 875 newfid 900 nwnames 0
v9fs_walk_return tag 0 id 110 nwnames 0 qids (nil)
v9fs_open tag 0 id 12 fid 900 mode 2
v9fs_open_return tag 0 id 12 qid={type 0 version 0 path 820297} iounit 507904
v9fs_lock tag 0 id 52 fid 568 type 1 start 0 length 0
v9fs_lock_return tag 0 id 52 status 0
v9fs_xattrwalk tag 0 id 30 fid 568 newfid 901 name security.capability
v9fs_rerror tag 0 id 30 err 95
v9fs_read tag 0 id 116 fid 568 off 192512 max_count 256

So guest opens /var/log/wtmp with fid=568 mode=32769, which is write-only
mode, and then it tries to read that fid 568, which eventually causes the
read() call on host to error with EBADF. Which makes sense, as the file was
opened in write-only mode, hence read() is not possible with that file
descriptor.

The other things I noticed when looking at the 9p command sequence above:
there is a Twalk on fid 568 before, which is not clunked before reusing fid
568 with Topen later. And before that Twalk on fid 568 there is a Tclunk on
fid 568, but apparently that fid was not used before.

> Perhaps backing filesystem dependant? qemu version? virtfs access options?

I tried with different hardware and different file systems (ext4, btrfs), same
misbehaviours.

QEMU is latest git version. I also tried several different QEMU versions, same
thing.

QEMU command line used:

~/git/qemu/build/qemu-system-x86_64 \
-machine pc,accel=kvm,usb=off,dump-guest-core=off -m 16384 \
-smp 8,sockets=8,cores=1,threads=1 -rtc base=utc -boot strict=on \
-kernel ~/vm/bullseye/boot/vmlinuz \
-initrd ~/vm/bullseye/boot/initrd.img \
-append 'root=fsRoot rw rootfstype=9p rootflags=trans=virtio,version=9p2000.L,msize=4186112,cache=loose console=ttyS0' \
-fsdev local,security_model=mapped,multidevs=remap,id=fsdev-fs0,path=$HOME/vm/bullseye/ \
-device virtio-9p-pci,id=fs0,fsdev=fsdev-fs0,mount_tag=fsRoot \
-sandbox on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny \
-nographic

Important for reproducing this issue:

  * cache=loose
  * -smp N (with N>1)
  * Guest booted with Linux kernel containing commit eb497943fa21
    (uname >= 5.16)

I'm pretty sure that you can reproduce this issue with the QEMU 9p rootfs
setup HOWTO linked before.

> It's all extremely slow though... like the final checkout counting files
> at less than 10/s

It is VERY slow. And the weird thing is that cache=loose got much slower than
cache=mmap. My worst case expactation would be cache=loose at least not
performing worse than cache=mmap.

Best regards,
Christian Schoenebeck


