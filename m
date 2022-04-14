Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1D500DEC
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 14:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiDNMsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 08:48:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241889AbiDNMr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 08:47:28 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D220C90270;
        Thu, 14 Apr 2022 05:45:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=Q89LmOY4QsQwqDUIV/jiE3VXQh22TbF6MoKNt2t/lbY=; b=Y604GdzeZvrieynRAz3bmrTjl9
        OUtJvuqb0RUPm1Qod0VyHNsNkJJ3FEzHzva8XTvqyi1oFEhjGBTcbUhydSuofO9sXioNXYXXUEmtw
        IGMBWoleyc0I4g6OTxrX6U10YrdV734RwH+JqCOJIBxk79AED2nAJqLos4EP8ufaWwwkHTc5cYiaA
        MILjYXzCZXbEJK5xh9b8h/Kbb+MfEk/VTn3WivVL4KqpNy20kiEMrO1TDOwjlWUHCJlg9MXT9FFmE
        /Y9Aa3gOHUIlyuy2GjTyfXtZl62J3M35TRE2Y0/vJomIaH/sxFBySnewQKTFIT6+7aA8ojUBxkMbI
        SzhTheyjRKCpdPsFIlM6SM8RiVd/p3ZAcRezXPnYB12DQo8YdHv+DTbPhgcJFI0WIB7DqWGRxW9/P
        WF0dGEzdcl2oYyACSlOhD52mZZaa/KdLhsQX+d7MqP4tjPR9rZ8Y5NZxgkvVkRgqDSrMsQ4AR0Mrq
        OK/oCzKKm/5BxB8YvKb+psouKamIqdxZLScIJ+OkBH9zArk1yrUx+5YR1OEjZaateCXYbonmVk+/2
        d2hwVLh0IyBR5wHdzb7wgE8Z5k6GHxoqDll6JZ4e43xQufc+8ow5Eh0qHpfbHSIqmx5wHbjEh/7bW
        bi8LWVNqH31oLZkZgR0TC3hxUVODXDDqf3myvVde0=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org
Cc:     David Kahurani <k.kahurani@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        lucho@ionkov.net, netdev@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        David Howells <dhowells@redhat.com>, Greg Kurz <groug@kaod.org>
Subject: Re: 9p fs-cache tests/benchmark (was: 9p fscache Duplicate cookie detected)
Date:   Thu, 14 Apr 2022 14:44:53 +0200
Message-ID: <2551609.RCmPuZc3Qn@silver>
In-Reply-To: <YlX/XRWwQ7eQntLr@codewreck.org>
References: <CAAZOf26g-L2nSV-Siw6mwWQv1nv6on8c0fWqB4bKmX73QAFzow@mail.gmail.com>
 <3119964.Qa6D4ExsIi@silver> <YlX/XRWwQ7eQntLr@codewreck.org>
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

On Mittwoch, 13. April 2022 00:38:21 CEST asmadeus@codewreck.org wrote:
> Christian Schoenebeck wrote on Mon, Apr 11, 2022 at 03:41:45PM +0200:
> > I get more convinced that it's a bug on Linux kernel side. When guest is
> > booted I always immediately get a read("/var/log/wtmp") = EBADF error on
> > guest. And the 9p command sequence sent to QEMU 9p server were:
> 
> Yes, I'm not pointing fingers, just trying to understand :)

Don't worry, that was not my impression, nor was it my intention either. I'm 
jut trying to interpret what I'm seeing here.

> > ...
> > v9fs_clunk tag 0 id 120 fid 568
> > v9fs_walk tag 0 id 110 fid 1 newfid 568 nwnames 1
> > v9fs_rerror tag 0 id 110 err 2
> > v9fs_walk tag 0 id 110 fid 26 newfid 568 nwnames 1
> > v9fs_rerror tag 0 id 110 err 2
> > v9fs_readlink tag 0 id 22 fid 474
> > v9fs_readlink_return tag 0 id 22 name /run
> > v9fs_readlink tag 0 id 22 fid 474
> > v9fs_readlink_return tag 0 id 22 name /run
> > v9fs_readlink tag 0 id 22 fid 474
> > v9fs_readlink_return tag 0 id 22 name /run
> > v9fs_readlink tag 0 id 22 fid 474
> > v9fs_readlink_return tag 0 id 22 name /run
> > v9fs_walk tag 0 id 110 fid 633 newfid 568 nwnames 1
> > v9fs_rerror tag 0 id 110 err 2
> > v9fs_walk tag 0 id 110 fid 875 newfid 568 nwnames 0
> > v9fs_walk_return tag 0 id 110 nwnames 0 qids (nil)
> > v9fs_open tag 0 id 12 fid 568 mode 32769
> > v9fs_open_return tag 0 id 12 qid={type 0 version 0 path 820297} iounit
> > 507904 v9fs_walk tag 0 id 110 fid 875 newfid 900 nwnames 0
> > v9fs_walk_return tag 0 id 110 nwnames 0 qids (nil)
> > v9fs_open tag 0 id 12 fid 900 mode 2
> > v9fs_open_return tag 0 id 12 qid={type 0 version 0 path 820297} iounit
> > 507904 v9fs_lock tag 0 id 52 fid 568 type 1 start 0 length 0
> > v9fs_lock_return tag 0 id 52 status 0
> > v9fs_xattrwalk tag 0 id 30 fid 568 newfid 901 name security.capability
> > v9fs_rerror tag 0 id 30 err 95
> > v9fs_read tag 0 id 116 fid 568 off 192512 max_count 256
> > 
> > So guest opens /var/log/wtmp with fid=568 mode=32769, which is write-only
> > mode, and then it tries to read that fid 568, which eventually causes the
> > read() call on host to error with EBADF. Which makes sense, as the file
> > was
> > opened in write-only mode, hence read() is not possible with that file
> > descriptor.
> 
> Oh! That's something we can work on. the vfs code has different caches
> for read only and read-write fids, perhaps the new netfs code just used
> the wrong one somewhere. I'll have a look.
> 
> > The other things I noticed when looking at the 9p command sequence above:
> > there is a Twalk on fid 568 before, which is not clunked before reusing
> > fid
> > 568 with Topen later. And before that Twalk on fid 568 there is a Tclunk
> > on
> > fid 568, but apparently that fid was not used before.
> 
> This one though is just weird, I don't see where linux would make up a fid
> to clunk like this... Could messages be ordered a bit weird through
> multithreading?
> e.g. thread 1 opens, thread 2 clunks almost immediately afterwards, and
> would be printed the other way around?

Yeah, something like that was also my guess.

> Should still be serialized through the virtio ring buffer so I don't
> believe what I'm saying myself... It might be worth digging further as
> well.
> 
> > > Perhaps backing filesystem dependant? qemu version? virtfs access
> > > options?
> > 
> > I tried with different hardware and different file systems (ext4, btrfs),
> > same misbehaviours.
> > 
> > QEMU is latest git version. I also tried several different QEMU versions,
> > same thing.
> > 
> > QEMU command line used:
> > 
> > ~/git/qemu/build/qemu-system-x86_64 \
> > -machine pc,accel=kvm,usb=off,dump-guest-core=off -m 16384 \
> > -smp 8,sockets=8,cores=1,threads=1 -rtc base=utc -boot strict=on \
> > -kernel ~/vm/bullseye/boot/vmlinuz \
> > -initrd ~/vm/bullseye/boot/initrd.img \
> > -append 'root=fsRoot rw rootfstype=9p
> > rootflags=trans=virtio,version=9p2000.L,msize=4186112,cache=loose
> > console=ttyS0' \ -fsdev
> > local,security_model=mapped,multidevs=remap,id=fsdev-fs0,path=$HOME/vm/bu
> > llseye/ \ -device virtio-9p-pci,id=fs0,fsdev=fsdev-fs0,mount_tag=fsRoot \
> > -sandbox
> > on,obsolete=deny,elevateprivileges=deny,spawn=deny,resourcecontrol=deny \
> > -nographic
> > 
> > Important for reproducing this issue:
> >   * cache=loose
> >   * -smp N (with N>1)
> >   * Guest booted with Linux kernel containing commit eb497943fa21
> >   
> >     (uname >= 5.16)
> > 
> > I'm pretty sure that you can reproduce this issue with the QEMU 9p rootfs
> > setup HOWTO linked before.
> 
> Yes, I'm not sure why I can't reproduce... All my computers are pretty
> slow but the conditions should be met.
> I'll try again with a command line closer to what you just gave here.

I'm not surprised that you could not reproduce the EBADF errors yet. To make 
this more clear, as for the git client errors: I have like 200+ git 
repositories checked out on that test VM, and only about 5 of them trigger 
EBADF errors on 'git pull'. But those few repositories reproduce the EBADF 
errors reliably here.

In other words: these EBADF errors only seem to trigger under certain 
circumstances, so it requires quite a bunch of test material to get a 
reproducer.

Like I said though, with the Bullseye installation I immediately get EBADF 
errors already when booting, whereas with a Buster VM it boots without errors.

> > > It's all extremely slow though... like the final checkout counting files
> > > at less than 10/s
> > 
> > It is VERY slow. And the weird thing is that cache=loose got much slower
> > than cache=mmap. My worst case expactation would be cache=loose at least
> > not performing worse than cache=mmap.
> 
> Yes, some profiling is also in order, it didn't use to be that slow so
> it must not be reusing previously open fids as it should have or
> something..

If somebody has some more ideas what I can try/test, let me know. However ATM 
I won't be able to review the netfs and vfs code to actually find the cause of 
these issues.

Best regards,
Christian Schoenebeck


