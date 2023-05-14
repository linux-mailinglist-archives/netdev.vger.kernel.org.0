Return-Path: <netdev+bounces-2438-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B12E701F55
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 21:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A7BB281084
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 19:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FDECBA4A;
	Sun, 14 May 2023 19:52:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DB6BA43
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 19:52:36 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EB1CE
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:34 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3f392680773so42404191cf.0
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 12:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684093953; x=1686685953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vdIVSmwHdSdIoPV9cJkDHS/vbOe/GpuUMWjNVM1MTLQ=;
        b=dB8tqdEheOK20x4a8S0r2kI3GVVyD/xsd/yJ/hGSoJJWzi7glQtqARBgi6xc90XwKr
         qd5XvNdgjxdmZV5GYW5evLkcn7lFfWuAM2bz3eDPp3Xbztl9wjwTTAErglzbaQqNWS8L
         587vR5d1PHTuIUInfdYgE+MyGU7de7DKKrFPf1cmR8YyCuRBgS7U3+JvGoFh/ghvAxNV
         x5IZT+o/UKSCSY31KKiHbeXXyJmXhUesAmZY4S+bCVHao0ALrBrhCwLcYzbdO5wb63gI
         RPRpKTf+JacpH29w2H7Vq0zkqzhe2rJGScWfseKWRSWY2Edan5mKGiFrhqkNpQ4BRhk3
         p/Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684093953; x=1686685953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vdIVSmwHdSdIoPV9cJkDHS/vbOe/GpuUMWjNVM1MTLQ=;
        b=IcoWXd9+e+Oadel+Q2gwt1mxQ0U/xH85wYDaH/UANFPLx5DhS/CRUt7QqhXeeDJKBs
         0OvvxG2WlHPLba37ax5zFrkHD1PkCn9ns4jTa8pmvSlC7hlAzPOcunEED3kZmXadYrxL
         g2JlHri+GtINsYuN8g+z9mzpV6k6gGtplS7GlcJP0IGviI7EjB2Z2Ffy5E1lEwbg+H9l
         pGi89cGo+Bm+IQmaLaw5P/bnLV3ED1EiZgxsGX0KKlnGj8EPijYmSPG1GyhFbOSp3J+N
         pgjT0B85eKScD/OZoYMDGHh/81voO0Maa97pXgR4PXIjPkgjLioyDVAW7xw0JZHKDABD
         3BMw==
X-Gm-Message-State: AC+VfDxxQlVX2NlOY6WIRuEtvH9gxHy/onPLym3Qx76bSXdMqNE49/X/
	cQD/1SonYieqpmlKVcQTfqPG0XLtH2tHfA==
X-Google-Smtp-Source: ACHHUZ6hfZaLmHw42Cxrg23lP/GifBvqpkt8XkSoz6wBF6keOZqgotlpnnoYwnjYfhgm2bFPHoK4hA==
X-Received: by 2002:a05:622a:64d:b0:3ef:370b:e7e with SMTP id a13-20020a05622a064d00b003ef370b0e7emr51586486qtb.40.1684093953345;
        Sun, 14 May 2023 12:52:33 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id fa11-20020a05622a4ccb00b003f517e1fed2sm1069444qtb.15.2023.05.14.12.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 12:52:32 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	tipc-discussion@lists.sourceforge.net
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jon Maloy <jmaloy@redhat.com>,
	Tung Nguyen <tung.q.nguyen@dektech.com.au>
Subject: [PATCHv3 net 2/3] tipc: do not update mtu if msg_max is too small in mtu negotiation
Date: Sun, 14 May 2023 15:52:28 -0400
Message-Id: <af76d0f05a2421016bcef3ec0c605d64c1966bd5.1684093873.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1684093873.git.lucien.xin@gmail.com>
References: <cover.1684093873.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When doing link mtu negotiation, a malicious peer may send Activate msg
with a very small mtu, e.g. 4 in Shuang's testing, without checking for
the minimum mtu, l->mtu will be set to 4 in tipc_link_proto_rcv(), then
n->links[bearer_id].mtu is set to 4294967228, which is a overflow of
'4 - INT_H_SIZE - EMSG_OVERHEAD' in tipc_link_mss().

With tipc_link.mtu = 4, tipc_link_xmit() kept printing the warning:

 tipc: Too large msg, purging xmit list 1 5 0 40 4!
 tipc: Too large msg, purging xmit list 1 15 0 60 4!

And with tipc_link_entry.mtu 4294967228, a huge skb was allocated in
named_distribute(), and when purging it in tipc_link_xmit(), a crash
was even caused:

  general protection fault, probably for non-canonical address 0x2100001011000dd: 0000 [#1] PREEMPT SMP PTI
  CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 6.3.0.neta #19
  RIP: 0010:kfree_skb_list_reason+0x7e/0x1f0
  Call Trace:
   <IRQ>
   skb_release_data+0xf9/0x1d0
   kfree_skb_reason+0x40/0x100
   tipc_link_xmit+0x57a/0x740 [tipc]
   tipc_node_xmit+0x16c/0x5c0 [tipc]
   tipc_named_node_up+0x27f/0x2c0 [tipc]
   tipc_node_write_unlock+0x149/0x170 [tipc]
   tipc_rcv+0x608/0x740 [tipc]
   tipc_udp_recv+0xdc/0x1f0 [tipc]
   udp_queue_rcv_one_skb+0x33e/0x620
   udp_unicast_rcv_skb.isra.72+0x75/0x90
   __udp4_lib_rcv+0x56d/0xc20
   ip_protocol_deliver_rcu+0x100/0x2d0

This patch fixes it by checking the new mtu against tipc_bearer_min_mtu(),
and not updating mtu if it is too small.

Fixes: ed193ece2649 ("tipc: simplify link mtu negotiation")
Reported-by: Shuang Li <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
---
v2:
- do the msg_max check against the min MTU early, as Tung suggested.
v3:
- move the change history under ---, as Tung suggested.
---
 net/tipc/link.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index b3ce24823f50..2eff1c7949cb 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2200,7 +2200,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	struct tipc_msg *hdr = buf_msg(skb);
 	struct tipc_gap_ack_blks *ga = NULL;
 	bool reply = msg_probe(hdr), retransmitted = false;
-	u32 dlen = msg_data_sz(hdr), glen = 0;
+	u32 dlen = msg_data_sz(hdr), glen = 0, msg_max;
 	u16 peers_snd_nxt =  msg_next_sent(hdr);
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
@@ -2239,6 +2239,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	switch (mtyp) {
 	case RESET_MSG:
 	case ACTIVATE_MSG:
+		msg_max = msg_max_pkt(hdr);
+		if (msg_max < tipc_bearer_min_mtu(l->net, l->bearer_id))
+			break;
 		/* Complete own link name with peer's interface name */
 		if_name =  strrchr(l->name, ':') + 1;
 		if (sizeof(l->name) - (if_name - l->name) <= TIPC_MAX_IF_NAME)
@@ -2283,8 +2286,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 		l->peer_session = msg_session(hdr);
 		l->in_session = true;
 		l->peer_bearer_id = msg_bearer_id(hdr);
-		if (l->mtu > msg_max_pkt(hdr))
-			l->mtu = msg_max_pkt(hdr);
+		if (l->mtu > msg_max)
+			l->mtu = msg_max;
 		break;
 
 	case STATE_MSG:
-- 
2.39.1


