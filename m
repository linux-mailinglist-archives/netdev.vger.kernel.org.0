Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598AD6F2479
	for <lists+netdev@lfdr.de>; Sat, 29 Apr 2023 13:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjD2Lgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Apr 2023 07:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjD2Lgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Apr 2023 07:36:51 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1841FD3;
        Sat, 29 Apr 2023 04:36:49 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C163B3200934;
        Sat, 29 Apr 2023 07:36:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 29 Apr 2023 07:36:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682768205; x=1682854605; bh=tYxLDE/+NL6+i
        0F583lhsE64zKkXx1jZ5RKcON+Jwss=; b=jt8vHqhEOdVJ1b8goC7I5VamaH5F0
        ORl8FeZv3DJ0d7vGyNW5g0SHJNDU964NKr3dmC72lJfPr95YXc0xF6ansCzgYJ7X
        5ZKVW5DBLx4ZGstvAAq9GHEsABbB4LiZNwiXD/q3lvwOC1nhETIwjNUHMKJXzaX6
        zCThxViKDP4xC0tHwZQ7ZtW0vm7IE432/bH4nDDumjjB0EQwwZUBAN4bDOGGkbqC
        agrdyHMJ9n8RIvK2b4JnZhzIBP/qMfuQpzLkS8oOwa5uXZYObfXrPUEQYAEKQbvM
        ieVd2PObc9t6TNkdJ/VkNoNdpESrucangcN3l3RdvgOgUDa68gQkU11Xg==
X-ME-Sender: <xms:TQFNZI2QxV-zuKEPNHKSOKMUnbtu20rS4DjhNnq30bGH65WzU_WAoA>
    <xme:TQFNZDFW7xblLyawiF05ufznf_bNNuV6WH6zv-wN1VmxRITX4lU5j0fJFiLqrkiAF
    U-Ht2f-pSyvtlk>
X-ME-Received: <xmr:TQFNZA4R5LU_MBsEuR-nD12MSDPQCgfLYvwmtQs5z18l-aB9raGMlXZ2GRloGRwxjLiG5pLqR_2AEWK1E8H-UyuJdqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedvtddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgoufhushhpvggtthffohhmrghinhculdegledmne
    cujfgurhepfffhvfevuffkfhggtggujgesmhdtreertddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepieffkeduledvheduteeikeefiedtgeevueeugeegveevkeeugeehtdfhjeel
    ffeknecuffhomhgrihhnpehgihhthhhusgdrtghomhdpshihiihkrghllhgvrhdrrghpph
    hsphhothdrtghomhdpghhoohhglhgvrghpihhsrdgtohhmpdhkvghrnhgvlhdrohhrghen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:TQFNZB1DOXv5kwfrXbXqGf-GHX1y0s5In9mCmffw4a_t67LAUexDjg>
    <xmx:TQFNZLFlrSrGlhlVKmmGX_V-Zfmj6HNWBoQ1zVdDSxH3rns2eh5MxA>
    <xmx:TQFNZK_uQ7NfTorHJLO3Jd7lYerWRddJcPAsp8pIZ1sDVsDpPh5EmQ>
    <xmx:TQFNZA4znOcp9syTi00M1ZtsmPmg712jgU4d45pjXzTKAhsZYXMWdA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 29 Apr 2023 07:36:44 -0400 (EDT)
Date:   Sat, 29 Apr 2023 14:36:40 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     syzbot <syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [net?] KMSAN: uninit-value in ethnl_set_linkmodes (2)
Message-ID: <ZE0BSJfjlJNE0WgI@shredder>
References: <0000000000009ff60505e2fab2e6@google.com>
 <0000000000004bb41105fa70f361@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Jq196jzPdknnmoKN"
Content-Disposition: inline
In-Reply-To: <0000000000004bb41105fa70f361@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Jq196jzPdknnmoKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 28, 2023 at 08:11:48PM -0700, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    81af97bdef5e printk: Export console trace point for kcsan/..
> git tree:       https://github.com/google/kmsan.git master
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=10d4b844280000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=ee7e125556b25104
> dashboard link: https://syzkaller.appspot.com/bug?extid=ef6edd9f1baaa54d6235
> compiler:       Debian clang version 15.0.7, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1543bf0c280000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=158f4664280000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/00b0f311889c/disk-81af97bd.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a3291e9cce5a/vmlinux-81af97bd.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/09b5e66af8b4/bzImage-81af97bd.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com
> 
> =====================================================
> BUG: KMSAN: uninit-value in ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
> BUG: KMSAN: uninit-value in ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
>  ethnl_update_linkmodes net/ethtool/linkmodes.c:273 [inline]
>  ethnl_set_linkmodes+0x190b/0x19d0 net/ethtool/linkmodes.c:333
>  ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
>  genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg net/socket.c:747 [inline]
>  ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
>  __sys_sendmsg net/socket.c:2584 [inline]
>  __do_sys_sendmsg net/socket.c:2593 [inline]
>  __se_sys_sendmsg net/socket.c:2591 [inline]
>  __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Uninit was stored to memory at:
>  tun_get_link_ksettings+0x37/0x60 drivers/net/tun.c:3544
>  __ethtool_get_link_ksettings+0x17b/0x260 net/ethtool/ioctl.c:441
>  ethnl_set_linkmodes+0xee/0x19d0 net/ethtool/linkmodes.c:327
>  ethnl_default_set_doit+0x88d/0xde0 net/ethtool/netlink.c:640
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:968 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:1048 [inline]
>  genl_rcv_msg+0x141a/0x14c0 net/netlink/genetlink.c:1065
>  netlink_rcv_skb+0x3f8/0x750 net/netlink/af_netlink.c:2577
>  genl_rcv+0x40/0x60 net/netlink/genetlink.c:1076
>  netlink_unicast_kernel net/netlink/af_netlink.c:1339 [inline]
>  netlink_unicast+0xf41/0x1270 net/netlink/af_netlink.c:1365
>  netlink_sendmsg+0x127d/0x1430 net/netlink/af_netlink.c:1942
>  sock_sendmsg_nosec net/socket.c:724 [inline]
>  sock_sendmsg net/socket.c:747 [inline]
>  ____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
>  ___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
>  __sys_sendmsg net/socket.c:2584 [inline]
>  __do_sys_sendmsg net/socket.c:2593 [inline]
>  __se_sys_sendmsg net/socket.c:2591 [inline]
>  __x64_sys_sendmsg+0x36b/0x540 net/socket.c:2591
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Uninit was stored to memory at:
>  tun_set_link_ksettings+0x37/0x60 drivers/net/tun.c:3553
>  ethtool_set_link_ksettings+0x600/0x690 net/ethtool/ioctl.c:609
>  __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
>  dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078
>  dev_ioctl+0xb07/0x1270 net/core/dev_ioctl.c:524
>  sock_do_ioctl+0x295/0x540 net/socket.c:1213
>  sock_ioctl+0x729/0xd90 net/socket.c:1316
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl+0x222/0x400 fs/ioctl.c:856
>  __x64_sys_ioctl+0x96/0xe0 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Local variable link_ksettings created at:
>  ethtool_set_link_ksettings+0x54/0x690 net/ethtool/ioctl.c:577
>  __dev_ethtool net/ethtool/ioctl.c:3024 [inline]
>  dev_ethtool+0x1db9/0x2a70 net/ethtool/ioctl.c:3078
> 
> CPU: 1 PID: 4952 Comm: syz-executor743 Not tainted 6.3.0-syzkaller-g81af97bdef5e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
> =====================================================
> 
> 
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.

The problem seems to be that 'struct ethtool_link_ksettings::lanes' is
not initialized in load_link_ksettings_from_user(). We can zero it
there, but a more robust approach would be to initialize the structure
in ethtool_set_link_ksettings().

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git main

--Jq196jzPdknnmoKN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-fix.patch"

From 409e045251b2b08871072e2697dc195450ef378a Mon Sep 17 00:00:00 2001
From: Ido Schimmel <idosch@nvidia.com>
Date: Sat, 29 Apr 2023 14:18:05 +0300
Subject: [PATCH] fix

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 59adc4e6e9ee..6bb778e10461 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -574,8 +574,8 @@ static int ethtool_get_link_ksettings(struct net_device *dev,
 static int ethtool_set_link_ksettings(struct net_device *dev,
 				      void __user *useraddr)
 {
+	struct ethtool_link_ksettings link_ksettings = {};
 	int err;
-	struct ethtool_link_ksettings link_ksettings;
 
 	ASSERT_RTNL();
 
-- 
2.40.0


--Jq196jzPdknnmoKN--
