Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FBC6A4B99
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbjB0Tvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjB0Tvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:51:45 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636CB2885C;
        Mon, 27 Feb 2023 11:51:40 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id EE4323200094;
        Mon, 27 Feb 2023 14:51:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 27 Feb 2023 14:51:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1677527498; x=1677613898; bh=gB
        Fdud0U0/x2N3GtbhHj2ToHCT4bsmtEl3upzYm7cgE=; b=RSZLtxSSnnabLFxjX9
        7seENV5tpnz+8y96rl2FUH3cUjsZy+Uuy7BLFtImRR79+uEAn42MkwmEAWjA+0YW
        Wt4LeL3YULW45KoquooeoMpUAvJjiZ+DbVtxZfY2NokW5wxpeRtbd3k7fcI3zdTd
        21CHy5j67/mH8BNTkm4enhqGwyS+E39M9v3e+V7EjSTKmkP3vI4NeM4kzc5G5RR9
        /OXv+ATLO3YZio2Z/TySOLN4Yyrvi80KBsOnV0LQSZwp8Qb50RPOFq2f4ZeUcQld
        2+ctfgodm0aF7EwtzioY1Gz5qBWw8FPbf44qIotLRWsG73mMJzK7Ablk+fhDfV6O
        6ruw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1677527498; x=1677613898; bh=gBFdud0U0/x2N
        3GtbhHj2ToHCT4bsmtEl3upzYm7cgE=; b=sYDu8x/cAom0vpBgEy+QrnEmIaBP+
        OevzV6NuOMdDz7RaRoMpATMXpnO/PQNDkUdae/IL8tO1AwUMBHTaHg3rRqka8CAo
        YTdwe5KYhcpGo6iO8xHyUiwBs30un5Ne5eAdMve5pZjGxQM19D7EHR0F00xF+/By
        wq//RtupuuoHwNrl+yNMu4ntYxYHD1LNc9GGYAzS6PtVqIDls5DaxJpR5Z17iB0d
        x+m6jtjyBBZpxRDit9fWcCn/T4NjDsocyKef9B0mAvprYdTuhtnNjRp1+14Dm11e
        tqsRYI6+REJF1QS5169WG8SDcW+pvvgvJkW5mpSeAtdJYBVYUKkO0TkiQ==
X-ME-Sender: <xms:ygn9Y_KFhTQ5XbpcLeIL0opCQWfCJWOXe6fHrvjlSIQ5MFq0kSX5Bg>
    <xme:ygn9YzKQP_J3xWfcd1rHn5L-3qooo3vLs7Jdk5pf4edpiw13RW8dzyeHPObgndHyr
    5JIQUmFp-DZfhrTNA>
X-ME-Received: <xmr:ygn9Y3upFYJp0Pp3SmMNYUFjHwqQ4M2V3hT4tGypLUP8CLozGXV4Y-bXPfA09XRG4vwX3F7tJe1pE-FMD_mKMRZq0l69upn3LBWSvCR8ZjL16A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:ygn9Y4YXxQUu2UjX58OHebzoa3ptctJvrWV9L7uABepVbs9wAhWhAw>
    <xmx:ygn9Y2Ys2acIUt4Uhu6a09GiDiwwdzlut2epfUMxjEO_MWhCrJKbWA>
    <xmx:ygn9Y8AnSngj114TF-brP_hv92O5ncD4yAQzAFVc6TSYckt0jMqslA>
    <xmx:ygn9Y-6KVQpUynQDdjvGakmI3Dndcn2D4ZEWDweiidXC4XjRfcNn1w>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Feb 2023 14:51:37 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     kuba@kernel.org, edumazet@google.com,
        willemdebruijn.kernel@gmail.com, davem@davemloft.net,
        pabeni@redhat.com, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 1/8] ip: frags: Return actual error codes from ip_check_defrag()
Date:   Mon, 27 Feb 2023 12:51:03 -0700
Message-Id: <bf4afe3484836972f94c1b7738845ba69d7008f5.1677526810.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677526810.git.dxu@dxuuu.xyz>
References: <cover.1677526810.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once we wrap ip_check_defrag() in a kfunc, it may be useful for progs to
know the exact error condition ip_check_defrag() encountered.

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 drivers/net/macvlan.c  |  2 +-
 net/ipv4/ip_fragment.c | 13 ++++++++-----
 net/packet/af_packet.c |  2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 99a971929c8e..b8310e13d7e1 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -456,7 +456,7 @@ static rx_handler_result_t macvlan_handle_frame(struct sk_buff **pskb)
 		unsigned int hash;
 
 		skb = ip_check_defrag(dev_net(skb->dev), skb, IP_DEFRAG_MACVLAN);
-		if (!skb)
+		if (IS_ERR(skb))
 			return RX_HANDLER_CONSUMED;
 		*pskb = skb;
 		eth = eth_hdr(skb);
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index 69c00ffdcf3e..959d2c4260ea 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -514,6 +514,7 @@ struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user)
 	struct iphdr iph;
 	int netoff;
 	u32 len;
+	int err;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return skb;
@@ -535,15 +536,17 @@ struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user)
 		if (skb) {
 			if (!pskb_may_pull(skb, netoff + iph.ihl * 4)) {
 				kfree_skb(skb);
-				return NULL;
+				return ERR_PTR(-ENOMEM);
 			}
-			if (pskb_trim_rcsum(skb, netoff + len)) {
+			err = pskb_trim_rcsum(skb, netoff + len);
+			if (err) {
 				kfree_skb(skb);
-				return NULL;
+				return ERR_PTR(err);
 			}
 			memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
-			if (ip_defrag(net, skb, user))
-				return NULL;
+			err = ip_defrag(net, skb, user);
+			if (err)
+				return ERR_PTR(err);
 			skb_clear_hash(skb);
 		}
 	}
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index d4e76e2ae153..1ef94828c8da 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1470,7 +1470,7 @@ static int packet_rcv_fanout(struct sk_buff *skb, struct net_device *dev,
 
 	if (fanout_has_flag(f, PACKET_FANOUT_FLAG_DEFRAG)) {
 		skb = ip_check_defrag(net, skb, IP_DEFRAG_AF_PACKET);
-		if (!skb)
+		if (IS_ERR(skb))
 			return 0;
 	}
 	switch (f->type) {
-- 
2.39.1

