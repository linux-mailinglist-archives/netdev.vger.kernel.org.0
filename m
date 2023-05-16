Return-Path: <netdev+bounces-3016-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8845E705080
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:23:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43FA6280FE4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 14:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D78328C13;
	Tue, 16 May 2023 14:23:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8462771D
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 14:23:46 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD82E44
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:23:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba81b24c1a5so1692556276.3
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 07:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684247024; x=1686839024;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WxxVS85yV6hdEo6iskBnjsgf2L8wkqChxCWJ99ICchM=;
        b=6mYBrUNkyc8ypwVbcSJKIklrunenjCM4cmEzWifC27C8zWAQTjeqQKdt/pYQ48rvvr
         2VHv1cqBC/ckIyos7n8lexVW3GrRxMVdhJmtYfIASik6zOwlK2wDiiKV5pHM2pokxoHW
         MWe7fAlBkYNKQspZ56I0FlnOeQ+TMVu4Q9l8e3Ef3XEeJqtmis0D8rBEkDkL6Ajt2Toj
         a5PCqHD1dqjrBVwLoLZ1LYnhqiMFZiA5e2UWpswEEMlqK42gg8c3PsyS85zk0QBGnlcG
         tP1PfXWBEbhhTtxC1zoHTYVKazcNLvm+j2K5eh2tFjTlSNQRAUyk3x6PhUR6GVFnvooY
         TQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684247024; x=1686839024;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WxxVS85yV6hdEo6iskBnjsgf2L8wkqChxCWJ99ICchM=;
        b=LdCfO68w2U0zuwwnKlMmyfCSccakxfFCF9OVF/3UIjaCZUTgSkzq4Om8vQKj4S0jpc
         lhibIYsnnpXUfE1REga9yRw/SRjp8wUZZQl4ZkL7goLS6YSILTVSFR+A/aaNPVmwEY9+
         l6LPVYAbTrgHtegzDTUqaD2HEj8qXvhMQGUH5gqslaAAzcUPaGk9VNlXudOQypEGVeGs
         VV5rW8U/uXyynVmRcxYV+jteJohGQuBJRK6iPS9DSkX7XSx5HO2Q/IjmO0Lvgd1HlxI+
         1B+7v9hgdY0/vWv3RrMqjF8Uu4nzm+JC2JuJAaN2/iMj/iOemP2WILoQmifNg4sOU7TI
         dy7g==
X-Gm-Message-State: AC+VfDyx5U9L9NR2LxxbFxquMKISk2DFb7ZYh9M3oFbwDTWyVd5GbGXa
	y5cTb2yJ/ovOtrmyMGs4AydMRv4IWqri7w==
X-Google-Smtp-Source: ACHHUZ5D4cgZTy+sRsGdCQ2rikZ7VWnnLZThhbjSnoVGn4zlfnuHKp09qPWfi42F8+XpKr4Zk4HM5RwqmlWjIw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:5e54:0:b0:ba6:c041:e9ae with SMTP id
 s81-20020a255e54000000b00ba6c041e9aemr10875073ybb.13.1684247024013; Tue, 16
 May 2023 07:23:44 -0700 (PDT)
Date: Tue, 16 May 2023 14:23:42 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230516142342.2915501-1-edumazet@google.com>
Subject: [PATCH net] vlan: fix a potential uninit-value in vlan_dev_hard_start_xmit()
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

syzbot triggered the following splat [1], sending an empty message
through pppoe_sendmsg().

When VLAN_FLAG_REORDER_HDR flag is set, vlan_dev_hard_header()
does not push extra bytes for the VLAN header, because vlan is offloaded.

Unfortunately vlan_dev_hard_start_xmit() first reads veth->h_vlan_proto
before testing (vlan->flags & VLAN_FLAG_REORDER_HDR).

We need to swap the two conditions.

[1]
BUG: KMSAN: uninit-value in vlan_dev_hard_start_xmit+0x171/0x7f0 net/8021q/vlan_dev.c:111
vlan_dev_hard_start_xmit+0x171/0x7f0 net/8021q/vlan_dev.c:111
__netdev_start_xmit include/linux/netdevice.h:4883 [inline]
netdev_start_xmit include/linux/netdevice.h:4897 [inline]
xmit_one net/core/dev.c:3580 [inline]
dev_hard_start_xmit+0x253/0xa20 net/core/dev.c:3596
__dev_queue_xmit+0x3c7f/0x5ac0 net/core/dev.c:4246
dev_queue_xmit include/linux/netdevice.h:3053 [inline]
pppoe_sendmsg+0xa93/0xb80 drivers/net/ppp/pppoe.c:900
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
__sys_sendmmsg+0x411/0xa50 net/socket.c:2641
__do_sys_sendmmsg net/socket.c:2670 [inline]
__se_sys_sendmmsg net/socket.c:2667 [inline]
__x64_sys_sendmmsg+0xbc/0x120 net/socket.c:2667
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Uninit was created at:
slab_post_alloc_hook+0x12d/0xb60 mm/slab.h:774
slab_alloc_node mm/slub.c:3452 [inline]
kmem_cache_alloc_node+0x543/0xab0 mm/slub.c:3497
kmalloc_reserve+0x148/0x470 net/core/skbuff.c:520
__alloc_skb+0x3a7/0x850 net/core/skbuff.c:606
alloc_skb include/linux/skbuff.h:1277 [inline]
sock_wmalloc+0xfe/0x1a0 net/core/sock.c:2583
pppoe_sendmsg+0x3af/0xb80 drivers/net/ppp/pppoe.c:867
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
____sys_sendmsg+0xa24/0xe40 net/socket.c:2501
___sys_sendmsg+0x2a1/0x3f0 net/socket.c:2555
__sys_sendmmsg+0x411/0xa50 net/socket.c:2641
__do_sys_sendmmsg net/socket.c:2670 [inline]
__se_sys_sendmmsg net/socket.c:2667 [inline]
__x64_sys_sendmmsg+0xbc/0x120 net/socket.c:2667
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd

CPU: 0 PID: 29770 Comm: syz-executor.0 Not tainted 6.3.0-rc6-syzkaller-gc478e5b17829 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/8021q/vlan_dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 870e4935d6e6e117eec652b6867fc4c53b94350c..b90781b9ece6402664552295e1f07b2fd97c2465 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -109,8 +109,8 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 	 * NOTE: THIS ASSUMES DIX ETHERNET, SPECIFICALLY NOT SUPPORTING
 	 * OTHER THINGS LIKE FDDI/TokenRing/802.3 SNAPs...
 	 */
-	if (veth->h_vlan_proto != vlan->vlan_proto ||
-	    vlan->flags & VLAN_FLAG_REORDER_HDR) {
+	if (vlan->flags & VLAN_FLAG_REORDER_HDR ||
+	    veth->h_vlan_proto != vlan->vlan_proto) {
 		u16 vlan_tci;
 		vlan_tci = vlan->vlan_id;
 		vlan_tci |= vlan_dev_get_egress_qos_mask(dev, skb->priority);
-- 
2.40.1.606.ga4b1b128d6-goog


