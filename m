Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5D82D2B7
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:14:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfE2AOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:14:25 -0400
Received: from nwk-aaemail-lapp02.apple.com ([17.151.62.67]:47348 "EHLO
        nwk-aaemail-lapp02.apple.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726601AbfE2AOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 20:14:25 -0400
X-Greylist: delayed 709 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2019 20:14:24 EDT
Received: from pps.filterd (nwk-aaemail-lapp02.apple.com [127.0.0.1])
        by nwk-aaemail-lapp02.apple.com (8.16.0.27/8.16.0.27) with SMTP id x4T025Wx053937;
        Tue, 28 May 2019 17:14:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=mime-version :
 content-transfer-encoding : content-type : sender : date : from : to : cc
 : subject : message-id : references : in-reply-to; s=20180706;
 bh=mlS5ZzekEJ39UpgabZfv6Ff30qV+lw2LFwOP+OP+Ez0=;
 b=Bcx7FrvKvYcmbQkilNpmi6VkjEc+86+v4YW9G7kfp8+SLAGdQKFcz17eae85vcPJX1a6
 8epLXitglwe+zyVoV5aOgNrQpjRSjaBFIgJpONHHy4Hu+jev58h6UoNMEusCXaXm8mSq
 DXwswnuasY74ePUc/v08z6UG6RsNmFLRXSUjmc3Pqv9JeR+zzoRzEjGLwoyAXuNqY7cG
 P5s3H3j6XXr3P8cmYpGCxk9p6ibqQWYrOM4ncy540sqzVXY6XWdrN+SdqBJFnzKHphFB
 cS0Nvu4x/s2TRHcYyVuSXPcjFno+fXFoQTJh24+s+OV9EBo/Avl5qb3XBJ/qe35hB0U8 WQ== 
Received: from ma1-mtap-s01.corp.apple.com (ma1-mtap-s01.corp.apple.com [17.40.76.5])
        by nwk-aaemail-lapp02.apple.com with ESMTP id 2sq29hy18k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 28 May 2019 17:14:22 -0700
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; CHARSET=US-ASCII
Received: from nwk-mmpp-sz09.apple.com
 (nwk-mmpp-sz09.apple.com [17.128.115.80]) by ma1-mtap-s01.corp.apple.com
 (Oracle Communications Messaging Server 8.0.2.3.20181024 64bit (built Oct 24
 2018)) with ESMTPS id <0PS8004GHONXGX90@ma1-mtap-s01.corp.apple.com>; Tue,
 28 May 2019 17:14:22 -0700 (PDT)
Received: from process_milters-daemon.nwk-mmpp-sz09.apple.com by
 nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) id <0PS800A00O3HOJ00@nwk-mmpp-sz09.apple.com>; Tue,
 28 May 2019 17:14:21 -0700 (PDT)
X-Va-A: 
X-Va-T-CD: 7e5a4a8cbd5d1b3a9de5dc9e235184f7
X-Va-E-CD: 748c4f445ad7729d7bf6e012c1ea3ad2
X-Va-R-CD: 11dab6803828ff7c58567785e3570130
X-Va-CD: 0
X-Va-ID: 5020abea-da93-4123-ad99-b10880aa929b
X-V-A:  
X-V-T-CD: 7e5a4a8cbd5d1b3a9de5dc9e235184f7
X-V-E-CD: 748c4f445ad7729d7bf6e012c1ea3ad2
X-V-R-CD: 11dab6803828ff7c58567785e3570130
X-V-CD: 0
X-V-ID: 0cfcaa3a-90b8-4405-9dea-9410ba026076
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,,
 definitions=2019-05-28_11:,, signatures=0
Received: from localhost ([17.192.155.217]) by nwk-mmpp-sz09.apple.com
 (Oracle Communications Messaging Server 8.0.2.4.20190507 64bit (built May  7
 2019)) with ESMTPSA id <0PS80002EONXZ490@nwk-mmpp-sz09.apple.com>; Tue,
 28 May 2019 17:14:21 -0700 (PDT)
Date:   Tue, 28 May 2019 17:14:21 -0700
From:   Christoph Paasch <cpaasch@apple.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: Re: [PATCH v4.14.x] net: erspan: fix use-after-free
Message-id: <20190529001421.GB49807@MacBook-Pro-64.local>
References: <20190529000113.49334-1-cpaasch@apple.com>
 <20190529000744.GA12783@kroah.com>
In-reply-to: <20190529000744.GA12783@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/05/19 - 17:07:44, Greg KH wrote:
> On Tue, May 28, 2019 at 05:01:13PM -0700, Christoph Paasch wrote:
> > When building the erspan header for either v1 or v2, the eth_hdr()
> > does not point to the right inner packet's eth_hdr,
> > causing kasan report use-after-free and slab-out-of-bouds read.
> > 
> > The patch fixes the following syzkaller issues:
> > [1] BUG: KASAN: slab-out-of-bounds in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
> > [2] BUG: KASAN: slab-out-of-bounds in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> > [3] BUG: KASAN: use-after-free in erspan_xmit+0x22d4/0x2430 net/ipv4/ip_gre.c:735
> > [4] BUG: KASAN: use-after-free in erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> > 
> > [2] CPU: 0 PID: 3654 Comm: syzkaller377964 Not tainted 4.15.0-rc9+ #185
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:17 [inline]
> >  dump_stack+0x194/0x257 lib/dump_stack.c:53
> >  print_address_description+0x73/0x250 mm/kasan/report.c:252
> >  kasan_report_error mm/kasan/report.c:351 [inline]
> >  kasan_report+0x25b/0x340 mm/kasan/report.c:409
> >  __asan_report_load_n_noabort+0xf/0x20 mm/kasan/report.c:440
> >  erspan_build_header+0x3bf/0x3d0 net/ipv4/ip_gre.c:698
> >  erspan_xmit+0x3b8/0x13b0 net/ipv4/ip_gre.c:740
> >  __netdev_start_xmit include/linux/netdevice.h:4042 [inline]
> >  netdev_start_xmit include/linux/netdevice.h:4051 [inline]
> >  packet_direct_xmit+0x315/0x6b0 net/packet/af_packet.c:266
> >  packet_snd net/packet/af_packet.c:2943 [inline]
> >  packet_sendmsg+0x3aed/0x60b0 net/packet/af_packet.c:2968
> >  sock_sendmsg_nosec net/socket.c:638 [inline]
> >  sock_sendmsg+0xca/0x110 net/socket.c:648
> >  SYSC_sendto+0x361/0x5c0 net/socket.c:1729
> >  SyS_sendto+0x40/0x50 net/socket.c:1697
> >  do_syscall_32_irqs_on arch/x86/entry/common.c:327 [inline]
> >  do_fast_syscall_32+0x3ee/0xf9d arch/x86/entry/common.c:389
> >  entry_SYSENTER_compat+0x54/0x63 arch/x86/entry/entry_64_compat.S:129
> > RIP: 0023:0xf7fcfc79
> > RSP: 002b:00000000ffc6976c EFLAGS: 00000286 ORIG_RAX: 0000000000000171
> > RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 0000000020011000
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020008000
> > RBP: 000000000000001c R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > 
> > Commit b423d13c08a6 ("net: erspan: fix use-after-free") fixed the
> > use-after-free. The root-cause change (commit 84e54fe0a5ea ("gre:
> > introduce native tunnel support for ERSPAN")) made it into 4.14.
> > 
> > Thus, the fix needs to be backported to 4.14 as well.
> > 
> > Fixes: 84e54fe0a5ea ("gre: introduce native tunnel support for ERSPAN")
> > Cc: William Tu <u9012063@gmail.com>
> > Signed-off-by: Christoph Paasch <cpaasch@apple.com>
> > ---
> > 
> > Notes:
> >     This should *only* go into 4.14.
> 
> What is the git commit id of this patch in Linus's tree?

It is b423d13c08a6 ("net: erspan: fix use-after-free").

The cherry-pick to 4.14 does not work though, which is why I sent this patch
here.


Christoph


