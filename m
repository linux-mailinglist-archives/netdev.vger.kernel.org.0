Return-Path: <netdev+bounces-604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1AD36F873A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8EFB281075
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72839C2F2;
	Fri,  5 May 2023 17:06:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 640D55383
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 17:06:23 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C99F150FC
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:06:21 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-559c416b024so20170657b3.1
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 10:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683306380; x=1685898380;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lryx7FL3JAVQjOy1vZdjMycw4SKcifAaryvsy4QaREQ=;
        b=kY1yh/+amfPnmqoleTBFJ+VeksIFLW6oo6rQCMlwsa+9hfYWuOr2aE3nEMf//Vrww6
         ASfY3/DWY+cykyqs7Gmm+P3eVX/bD1ryfJ8iN9+GlbXZbePM7XYfi6Hqb3xMBpD2IJFS
         is81wbsErPIVnuMuUGQA7lo+IOMDErV1lrPRD1BzbsK94dufwow80zOkahVg4chYphSo
         CeW1hgBYI//DxkbMGpAlzbFi2VbLV8XD64g94f4TKhg6ZVOl99MBtHXG7sXClAQujnAI
         jg3zmNaNT2oVXb+sAYwp3F8mZ3Ert2jlYFS6EJEwiT/QxDmtJpIgOHHN3MbJWkcBDME6
         YOgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683306380; x=1685898380;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lryx7FL3JAVQjOy1vZdjMycw4SKcifAaryvsy4QaREQ=;
        b=CKpnGPuFmWPMQHL0vG2lkstS0nFI8rb7k/T0Xgs64dpzxqRiIwgiOF6jZ35bDIY80S
         8YXPyFoMRhBR6IfjYXrlN08tY8rnSwMo8x+fj99skOwcAeejBky5WWsqzv5eQCzm0xvn
         MWwKh2SLt6TyblREjq13dtLOKrehd/Ye+Fi5V4qoEd5lWnIR/mZbjalFMIcNcAtjf42c
         EdIEeTBthI6RHto+HsEbVUcyvtl3+M1kWItB44j+MMX1dr/ybwR9eXd6SuegvCzjo4oT
         EK5hcCF4z45LuhFdVey7AS7HGf03jAhgC74IZnbPujkcdEse9yLTgArhXqhiHJTFmbrd
         Z2xQ==
X-Gm-Message-State: AC+VfDxbrszEo5bQSglujIHwExIm9CgP/twHBfoVnWKc6zSrHxOhDscI
	wOtk8zke7e0cBZEAG246S8kLAseyaCb5VA==
X-Google-Smtp-Source: ACHHUZ5/KrP2EODDgP7hxi0+z4L8M4AxYP66DLwZhSDrXY15rTjnE2JivvLDkLxpXCFjAtSEgqwpWFJ0UwPKJw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:ca50:0:b0:55d:95b7:39da with SMTP id
 y16-20020a81ca50000000b0055d95b739damr1288084ywk.7.1683306380723; Fri, 05 May
 2023 10:06:20 -0700 (PDT)
Date: Fri,  5 May 2023 17:06:18 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230505170618.650544-1-edumazet@google.com>
Subject: [PATCH net] net: skb_partial_csum_set() fix against transport header
 magic value
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>, 
	Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

skb->transport_header uses the special 0xFFFF value
to mark if the transport header was set or not.

We must prevent callers to accidentaly set skb->transport_header
to 0xFFFF. Note that only fuzzers can possibly do this today.

syzbot reported:

WARNING: CPU: 0 PID: 2340 at include/linux/skbuff.h:2847 skb_transport_offset include/linux/skbuff.h:2956 [inline]
WARNING: CPU: 0 PID: 2340 at include/linux/skbuff.h:2847 virtio_net_hdr_to_skb+0xbcc/0x10c0 include/linux/virtio_net.h:103
Modules linked in:
CPU: 0 PID: 2340 Comm: syz-executor.0 Not tainted 6.3.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/14/2023
RIP: 0010:skb_transport_header include/linux/skbuff.h:2847 [inline]
RIP: 0010:skb_transport_offset include/linux/skbuff.h:2956 [inline]
RIP: 0010:virtio_net_hdr_to_skb+0xbcc/0x10c0 include/linux/virtio_net.h:103
Code: 41 39 df 0f 82 c3 04 00 00 48 8b 7c 24 10 44 89 e6 e8 08 6e 59 ff 48 85 c0 74 54 e8 ce 36 7e fc e9 37 f8 ff ff e8 c4 36 7e fc <0f> 0b e9 93 f8 ff ff 44 89 f7 44 89 e6 e8 32 38 7e fc 45 39 e6 0f
RSP: 0018:ffffc90004497880 EFLAGS: 00010293
RAX: ffffffff84fea55c RBX: 000000000000ffff RCX: ffff888120be2100
RDX: 0000000000000000 RSI: 000000000000ffff RDI: 000000000000ffff
RBP: ffffc90004497990 R08: ffffffff84fe9de5 R09: 0000000000000034
R10: ffffea00048ebd80 R11: 0000000000000034 R12: ffff88811dc2d9c8
R13: dffffc0000000000 R14: ffff88811dc2d9ae R15: 1ffff11023b85b35
FS: 00007f9211a59700(0000) GS:ffff8881f6c00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200002c0 CR3: 00000001215a5000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
packet_snd net/packet/af_packet.c:3076 [inline]
packet_sendmsg+0x4590/0x61a0 net/packet/af_packet.c:3115
sock_sendmsg_nosec net/socket.c:724 [inline]
sock_sendmsg net/socket.c:747 [inline]
__sys_sendto+0x472/0x630 net/socket.c:2144
__do_sys_sendto net/socket.c:2156 [inline]
__se_sys_sendto net/socket.c:2152 [inline]
__x64_sys_sendto+0xe5/0x100 net/socket.c:2152
do_syscall_x64 arch/x86/entry/common.c:50 [inline]
do_syscall_64+0x2f/0x50 arch/x86/entry/common.c:80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f9210c8c169
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9211a59168 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f9210dabf80 RCX: 00007f9210c8c169
RDX: 000000000000ffed RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 00007f9210ce7ca1 R08: 0000000020000540 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffe135d65cf R14: 00007f9211a59300 R15: 0000000000022000

Fixes: 66e4c8d95008 ("net: warn if transport header was not set")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 26a586007d8b1ae39ab7a09eecf8575e04dadfeb..515ec5cdc79c1da535e490b4341397e34ce1b5fb 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5298,7 +5298,7 @@ bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off)
 	u32 csum_end = (u32)start + (u32)off + sizeof(__sum16);
 	u32 csum_start = skb_headroom(skb) + (u32)start;
 
-	if (unlikely(csum_start > U16_MAX || csum_end > skb_headlen(skb))) {
+	if (unlikely(csum_start >= U16_MAX || csum_end > skb_headlen(skb))) {
 		net_warn_ratelimited("bad partial csum: csum=%u/%u headroom=%u headlen=%u\n",
 				     start, off, skb_headroom(skb), skb_headlen(skb));
 		return false;
@@ -5306,7 +5306,7 @@ bool skb_partial_csum_set(struct sk_buff *skb, u16 start, u16 off)
 	skb->ip_summed = CHECKSUM_PARTIAL;
 	skb->csum_start = csum_start;
 	skb->csum_offset = off;
-	skb_set_transport_header(skb, start);
+	skb->transport_header = csum_start;
 	return true;
 }
 EXPORT_SYMBOL_GPL(skb_partial_csum_set);
-- 
2.40.1.521.gf1e218fcd8-goog


