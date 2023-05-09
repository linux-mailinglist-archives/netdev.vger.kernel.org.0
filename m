Return-Path: <netdev+bounces-1170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 758936FC7C1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC686281129
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A9B0182BC;
	Tue,  9 May 2023 13:19:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874A3182AE
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:19:04 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B0C1BE4
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:19:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b8f46dc51bdso12752610276.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 06:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683638342; x=1686230342;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zcDLJjD+xErZe10CJAjjRbsBCbBOcSySl03HFJFeYLU=;
        b=BGGPs2la3Kga/FcqcyYLsvpVALGPbHslOLwcDrhEIvvhxxICKuu2TgIOXTN9HUYkYE
         GM+C3u7VhJM3NTerk9tIL9LJRF7IuLkqi9xYVOZZUe8IQptkB380DIqRNO04psCB0/rp
         pN8gFsGQCPqWLBXqmaGYqk75fVyiQrxdZcdM/U798osKwyENwgU+5KQIpvd5F3keXx0q
         scgHGpTwFlDqowARXsLuSIIpMeIHIljDV9NZ9VWzIj5Len6hpRkTD8tvfyFP4tVhC3jJ
         VZq1j++4Jid6IQi075OXdNUPiXVJJeAthijbrYPX6GFozLARaYMY5NllANwgbBTRGVxT
         EIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683638342; x=1686230342;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zcDLJjD+xErZe10CJAjjRbsBCbBOcSySl03HFJFeYLU=;
        b=GjF6a4ViNWL5n+RCW4cVkn65Xy3kQtAkSpV36dktXnal3fAUurr+TxGq3Zc/V7Is4c
         itnvwVj0mXYL2dP8hywvZU+KQa10kJJzRzlqpRTJrNVruB2i2e3gceNOynCugPyUNEzF
         QVqrqtq2IgWgPA6lDieR4GlxttJ/HGFf4SPtD3QcWFbDhhdsK1/jEWvpki4Y2xY0+1yK
         lFTc9kazA3Li1wJkwcP0njkzoo7moqa8DCWHHMscXbfaqe0tgHTqcjQD+XFUYSO/8BRD
         p5ntKCGXMnL+DVjKznx/wN+ERsVrXEYKo8+vx6A6irHHZeTiZdcrSLIxvL8ukclBN2Fz
         fKXw==
X-Gm-Message-State: AC+VfDwd2BVdCxPDwwWVMRemHlzZX2HMMrWtX9tT7vxfWnLBbjbw1xlr
	vTkD57Xtd4Lr8Udkzfq2o20JNTqZGn2OiA==
X-Google-Smtp-Source: ACHHUZ4EqTq5njvi7+UTnvlArUCzzPn7lsWM2F7gKC5oRoQE+2n/ZLpNtvvmzzEVGyMdTIJu0v27HwD/b+L+5A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1021:b0:ba1:b908:364c with SMTP
 id x1-20020a056902102100b00ba1b908364cmr8824076ybt.12.1683638341776; Tue, 09
 May 2023 06:19:01 -0700 (PDT)
Date: Tue,  9 May 2023 13:18:57 +0000
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.521.gf1e218fcd8-goog
Message-ID: <20230509131857.2947439-1-edumazet@google.com>
Subject: [PATCH net] net: add vlan_get_protocol_and_depth() helper
From: Eric Dumazet <edumazet@google.com>
To: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, eric.dumazet@gmail.com, 
	Eric Dumazet <edumazet@google.com>, syzbot <syzkaller@googlegroups.com>, 
	"=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Before blamed commit, pskb_may_pull() was used instead
of skb_header_pointer() in __vlan_get_protocol() and friends.

Few callers depended on skb->head being populated with MAC header,
syzbot caught one of them (skb_mac_gso_segment())

Add vlan_get_protocol_and_depth() to make the intent clearer
and use it where sensible.

This is a more generic fix than commit e9d3f80935b6
("net/af_packet: make sure to pull mac header") which was
dealing with a similar issue.

kernel BUG at include/linux/skbuff.h:2655 !
invalid opcode: 0000 [#1] SMP KASAN
CPU: 0 PID: 1441 Comm: syz-executor199 Not tainted 6.1.24-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 04/14/2023
RIP: 0010:__skb_pull include/linux/skbuff.h:2655 [inline]
RIP: 0010:skb_mac_gso_segment+0x68f/0x6a0 net/core/gro.c:136
Code: fd 48 8b 5c 24 10 44 89 6b 70 48 c7 c7 c0 ae 0d 86 44 89 e6 e8 a1 91 =
d0 00 48 c7 c7 00 af 0d 86 48 89 de 31 d2 e8 d1 4a e9 ff <0f> 0b 66 2e 0f 1=
f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41
RSP: 0018:ffffc90001bd7520 EFLAGS: 00010286
RAX: ffffffff8469736a RBX: ffff88810f31dac0 RCX: ffff888115a18b00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc90001bd75e8 R08: ffffffff84697183 R09: fffff5200037adf9
R10: 0000000000000000 R11: dffffc0000000001 R12: 0000000000000012
R13: 000000000000fee5 R14: 0000000000005865 R15: 000000000000fed7
FS: 000055555633f300(0000) GS:ffff8881f6a00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000000 CR3: 0000000116fea000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
[<ffffffff847018dd>] __skb_gso_segment+0x32d/0x4c0 net/core/dev.c:3419
[<ffffffff8470398a>] skb_gso_segment include/linux/netdevice.h:4819 [inline=
]
[<ffffffff8470398a>] validate_xmit_skb+0x3aa/0xee0 net/core/dev.c:3725
[<ffffffff84707042>] __dev_queue_xmit+0x1332/0x3300 net/core/dev.c:4313
[<ffffffff851a9ec7>] dev_queue_xmit+0x17/0x20 include/linux/netdevice.h:302=
9
[<ffffffff851b4a82>] packet_snd net/packet/af_packet.c:3111 [inline]
[<ffffffff851b4a82>] packet_sendmsg+0x49d2/0x6470 net/packet/af_packet.c:31=
42
[<ffffffff84669a12>] sock_sendmsg_nosec net/socket.c:716 [inline]
[<ffffffff84669a12>] sock_sendmsg net/socket.c:736 [inline]
[<ffffffff84669a12>] __sys_sendto+0x472/0x5f0 net/socket.c:2139
[<ffffffff84669c75>] __do_sys_sendto net/socket.c:2151 [inline]
[<ffffffff84669c75>] __se_sys_sendto net/socket.c:2147 [inline]
[<ffffffff84669c75>] __x64_sys_sendto+0xe5/0x100 net/socket.c:2147
[<ffffffff8551d40f>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
[<ffffffff8551d40f>] do_syscall_64+0x2f/0x50 arch/x86/entry/common.c:80
[<ffffffff85600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 469aceddfa3e ("vlan: consolidate VLAN parsing code and limit max par=
sing depth")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Cc: Willem de Bruijn <willemb@google.com>
---
 drivers/net/tap.c       |  4 ++--
 include/linux/if_vlan.h | 17 +++++++++++++++++
 net/bridge/br_forward.c |  2 +-
 net/core/dev.c          |  2 +-
 net/packet/af_packet.c  |  6 ++----
 5 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ce993cc75bf3106cd7fe71ab9d4188c6ac09af27..d30d730ed5a71b8cc31880acc0f=
82d4b0f65f739 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -742,7 +742,7 @@ static ssize_t tap_get_user(struct tap_queue *q, void *=
msg_control,
=20
 	/* Move network header to the right position for VLAN tagged packets */
 	if (eth_type_vlan(skb->protocol) &&
-	    __vlan_get_protocol(skb, skb->protocol, &depth) !=3D 0)
+	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) !=3D 0)
 		skb_set_network_header(skb, depth);
=20
 	/* copy skb_ubuf_info for callback when skb has no error */
@@ -1197,7 +1197,7 @@ static int tap_get_user_xdp(struct tap_queue *q, stru=
ct xdp_buff *xdp)
=20
 	/* Move network header to the right position for VLAN tagged packets */
 	if (eth_type_vlan(skb->protocol) &&
-	    __vlan_get_protocol(skb, skb->protocol, &depth) !=3D 0)
+	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) !=3D 0)
 		skb_set_network_header(skb, depth);
=20
 	rcu_read_lock();
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 0f40f379d75cb1e80aaff132842a8d1b968ad087..6ba71957851e22829ec9f18cd29=
bea2d92dfa583 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -637,6 +637,23 @@ static inline __be16 vlan_get_protocol(const struct sk=
_buff *skb)
 	return __vlan_get_protocol(skb, skb->protocol, NULL);
 }
=20
+/* This version of __vlan_get_protocol() also pulls mac header in skb->hea=
d */
+static inline __be16 vlan_get_protocol_and_depth(struct sk_buff *skb,
+						 __be16 type, int *depth)
+{
+	int maclen;
+
+	type =3D __vlan_get_protocol(skb, type, &maclen);
+
+	if (type) {
+		if (!pskb_may_pull(skb, maclen))
+			type =3D 0;
+		else if (depth)
+			*depth =3D maclen;
+	}
+	return type;
+}
+
 /* A getter for the SKB protocol field which will handle VLAN tags consist=
ently
  * whether VLAN acceleration is enabled or not.
  */
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 57744704ff692ae4dd573ec025cf29935785900e..84d6dd5e5b1a23a2fddad3e0573=
ebf7b1924204c 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -42,7 +42,7 @@ int br_dev_queue_push_xmit(struct net *net, struct sock *=
sk, struct sk_buff *skb
 	    eth_type_vlan(skb->protocol)) {
 		int depth;
=20
-		if (!__vlan_get_protocol(skb, skb->protocol, &depth))
+		if (!vlan_get_protocol_and_depth(skb, skb->protocol, &depth))
 			goto drop;
=20
 		skb_set_network_header(skb, depth);
diff --git a/net/core/dev.c b/net/core/dev.c
index 735096d42c1d13999597a882370ca439e9389e24..b3c13e0419356b943e90b1f46dd=
7e035c6ec1a9c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3335,7 +3335,7 @@ __be16 skb_network_protocol(struct sk_buff *skb, int =
*depth)
 		type =3D eth->h_proto;
 	}
=20
-	return __vlan_get_protocol(skb, type, depth);
+	return vlan_get_protocol_and_depth(skb, type, depth);
 }
=20
 /* openvswitch calls this on rx path, so we need a different check.
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 640d94e34635b51709d51be27635d23b3c184d0c..94c6a1ffa459aab491d92fb4fd9=
6d58fb0e00094 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1934,10 +1934,8 @@ static void packet_parse_headers(struct sk_buff *skb=
, struct socket *sock)
 	/* Move network header to the right position for VLAN tagged packets */
 	if (likely(skb->dev->type =3D=3D ARPHRD_ETHER) &&
 	    eth_type_vlan(skb->protocol) &&
-	    __vlan_get_protocol(skb, skb->protocol, &depth) !=3D 0) {
-		if (pskb_may_pull(skb, depth))
-			skb_set_network_header(skb, depth);
-	}
+	    vlan_get_protocol_and_depth(skb, skb->protocol, &depth) !=3D 0)
+		skb_set_network_header(skb, depth);
=20
 	skb_probe_transport_header(skb);
 }
--=20
2.40.1.521.gf1e218fcd8-goog


