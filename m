Return-Path: <netdev+bounces-10783-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 675C57304C4
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:18:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9077C1C20D58
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:18:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFE5111A6;
	Wed, 14 Jun 2023 16:18:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE931119B
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:18:07 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3472117
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:18:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-bc505a8dd60so894852276.2
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 09:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686759484; x=1689351484;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5NEFh3sQPH8jITgatDHbbfLpxmu3UNfkB6U2cctIdG4=;
        b=TVyvwO7G9ITiSc/zcL6ChE9V/79j5tAmuu07Wn2u6xSUFK3C2UZmejdXGvvSFZf0EP
         tCUK++ewGfa7vWKxj/r6HqOtfZUsnnU+380g3x3jODzXx9yPyo44MqKMChMqQkY/qrgA
         EgOjzFsZ8I0ljduUrFnYT+eOuZ4n7qVew5d2mGC7vuN/tZ1pA1Tu8zTJobo8F3SD9J1p
         ERlB6yihM1JnTy7ko8KHC+SOzbFl62Hf4cRmI4ZT3CNKlU4edMvmZzp+j/q7FaGXbAZp
         1Jtz5e8Xzny7X1aFEKpsG5fem5bi8eVXb4e5sGQuu7fCpyVUABue5jLUlpAZ5M/ALEw2
         jgoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686759484; x=1689351484;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5NEFh3sQPH8jITgatDHbbfLpxmu3UNfkB6U2cctIdG4=;
        b=BtOFqpe3j08KbLo1AvQ4jXQOywYXVG8/+M2jyNFBYaBF5rmcLt93hkr1RzMLU82Wif
         dU3J8u57aTbVrGmHfQYirPK/0zjF2gpVc7mMZvxj6oi1JKV759reeOtjsJyo9+otXXHb
         AhQhR1icXk/9FQZe9ZRpkFlgU1q9pVk8mUMurFM6LFVzUjRomhpnKLcPeh/gORWuqqHe
         bv3cVNEw8MGyPidgRC91EfFbNN57vI+5oyJolfvr4/bVUbPLlJB+gBdDOiANhgfxRFmx
         xVhNlhMjn49ynFHUzSJ4gStfVTc8qBY2wjoJPrpb6OLz9Os2a6cHyUfMOVSuxkehNzgj
         ig0Q==
X-Gm-Message-State: AC+VfDyLR/XKRd7TMEryPDaYDRfpamqtz/bDgssAivGAK4xKCJltzuu0
	BgXCgzOeknRF0cRt7zEQqf8vlYq47yzYuQ==
X-Google-Smtp-Source: ACHHUZ475FBNHPbM4JC3OgdeWVq9qr2IfEVo3AAKRjeCp/x0UPPe41gsbMdV+gIU2mc5uKSAs2O7zfrFMklQkQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:dc5:0:b0:bce:5d6f:87a with SMTP id
 188-20020a250dc5000000b00bce5d6f087amr327437ybn.1.1686759484213; Wed, 14 Jun
 2023 09:18:04 -0700 (PDT)
Date: Wed, 14 Jun 2023 16:18:02 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Message-ID: <20230614161802.2715468-1-edumazet@google.com>
Subject: [PATCH net] net: lapbether: only support ethernet devices
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>, 
	Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

It probbaly makes no sense to support arbitrary network devices
for lapbether.

syzbot reported:

skbuff: skb_under_panic: text:ffff80008934c100 len:44 put:40 head:ffff0000d18dd200 data:ffff0000d18dd1ea tail:0x16 end:0x140 dev:bond1
kernel BUG at net/core/skbuff.c:200 !
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 5643 Comm: dhcpcd Not tainted 6.4.0-rc5-syzkaller-g4641cff8e810 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/25/2023
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : skb_panic net/core/skbuff.c:196 [inline]
pc : skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
lr : skb_panic net/core/skbuff.c:196 [inline]
lr : skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
sp : ffff8000973b7260
x29: ffff8000973b7270 x28: ffff8000973b7360 x27: dfff800000000000
x26: ffff0000d85d8150 x25: 0000000000000016 x24: ffff0000d18dd1ea
x23: ffff0000d18dd200 x22: 000000000000002c x21: 0000000000000140
x20: 0000000000000028 x19: ffff80008934c100 x18: ffff8000973b68a0
x17: 0000000000000000 x16: ffff80008a43bfbc x15: 0000000000000202
x14: 0000000000000000 x13: 0000000000000001 x12: 0000000000000001
x11: 0000000000000201 x10: 0000000000000000 x9 : f22f7eb937cced00
x8 : f22f7eb937cced00 x7 : 0000000000000001 x6 : 0000000000000001
x5 : ffff8000973b6b78 x4 : ffff80008df9ee80 x3 : ffff8000805974f4
x2 : 0000000000000001 x1 : 0000000100000201 x0 : 0000000000000086
Call trace:
skb_panic net/core/skbuff.c:196 [inline]
skb_under_panic+0x13c/0x140 net/core/skbuff.c:210
skb_push+0xf0/0x108 net/core/skbuff.c:2409
ip6gre_header+0xbc/0x738 net/ipv6/ip6_gre.c:1383
dev_hard_header include/linux/netdevice.h:3137 [inline]
lapbeth_data_transmit+0x1c4/0x298 drivers/net/wan/lapbether.c:257
lapb_data_transmit+0x8c/0xb0 net/lapb/lapb_iface.c:447
lapb_transmit_buffer+0x178/0x204 net/lapb/lapb_out.c:149
lapb_send_control+0x220/0x320 net/lapb/lapb_subr.c:251
lapb_establish_data_link+0x94/0xec
lapb_device_event+0x348/0x4e0
notifier_call_chain+0x1a4/0x510 kernel/notifier.c:93
raw_notifier_call_chain+0x3c/0x50 kernel/notifier.c:461
__dev_notify_flags+0x2bc/0x544
dev_change_flags+0xd0/0x15c net/core/dev.c:8643
devinet_ioctl+0x858/0x17e4 net/ipv4/devinet.c:1150
inet_ioctl+0x2ac/0x4d8 net/ipv4/af_inet.c:979
sock_do_ioctl+0x134/0x2dc net/socket.c:1201
sock_ioctl+0x4ec/0x858 net/socket.c:1318
vfs_ioctl fs/ioctl.c:51 [inline]
__do_sys_ioctl fs/ioctl.c:870 [inline]
__se_sys_ioctl fs/ioctl.c:856 [inline]
__arm64_sys_ioctl+0x14c/0x1c8 fs/ioctl.c:856
__invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
invoke_syscall+0x98/0x2c0 arch/arm64/kernel/syscall.c:52
el0_svc_common+0x138/0x244 arch/arm64/kernel/syscall.c:142
do_el0_svc+0x64/0x198 arch/arm64/kernel/syscall.c:191
el0_svc+0x4c/0x160 arch/arm64/kernel/entry-common.c:647
el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:665
el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:591
Code: aa1803e6 aa1903e7 a90023f5 947730f5 (d4210000)

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Martin Schiller <ms@dev.tdt.de>
---
 drivers/net/wan/lapbether.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index d62a904d2e422d7e48cf67cba829df0568e99b01..56326f38fe8a30f45e88cdce7efd43e18041e52a 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -384,6 +384,9 @@ static int lapbeth_new_device(struct net_device *dev)
 
 	ASSERT_RTNL();
 
+	if (dev->type != ARPHRD_ETHER)
+		return -EINVAL;
+
 	ndev = alloc_netdev(sizeof(*lapbeth), "lapb%d", NET_NAME_UNKNOWN,
 			    lapbeth_setup);
 	if (!ndev)
-- 
2.41.0.162.gfafddb0af9-goog


