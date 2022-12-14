Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC57D64D361
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiLNX2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbiLNX2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:28:03 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2DE3B9FF;
        Wed, 14 Dec 2022 15:26:07 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 3697C32008FF;
        Wed, 14 Dec 2022 18:26:06 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 14 Dec 2022 18:26:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1671060365; x=1671146765; bh=zX
        M0VhlCciX8F/i6KXAGG0kiwhCDpeRhU1M+a6/y414=; b=QAz90bISldXoMkbDut
        O6BP+qovTz0JRF8nw6ZqC82EAec+qLHrfd0V1PBGZSOPN2FKC+/uwB37Oi/4XcD/
        c6GtmKrA8CXBp2hdUWCyi18rKgfT9n+R0mgEvcv+vUAMOCMTiRXcee211MCdZlhv
        4i9F9/2aoL1/8pppDmpMpc/xjNJxsfuKpwsandLTN7G/kGB7MYrhF+B9MXHKViz9
        fHDtJTwAK3KpadTK02ubYecuPk5TSZkYSoxuR5CxFWUGmQMMbnlsVs+AyaEaojUf
        TRoMpuElUVQP9CvQY9L2Oo9msep1Q6A1l/D2fW91zVvMcQLgdBcsuTWGKShQOVU6
        JqJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1671060365; x=1671146765; bh=zXM0VhlCciX8F
        /i6KXAGG0kiwhCDpeRhU1M+a6/y414=; b=L5TwVjkUGMM+MIORXLq7Py8MuNRDx
        LxXLyrTqwsx5teMAoBH2G4L22AC0MQkTzOlh+wuh+bARDcyvaHvJ0ULHvspfkN/x
        cH4SpzWTjBtyg4hcWtpOZuEiwJlB5W831slPn061IxX3Zkb95jXO5kX9NEh3joFg
        KQix3/AZbpJLmCcIRJ72fXxzy2fPWzHRi144eXGTMDdUHynpebQ+zjnhuOaVk1Mf
        TeiUQBoIkssQwKP+lOZwdwiilyhZlD0fVHpqkt96Asa4OU6ViyqITN786834egis
        YFql6TRxBTSTYl7eXcRb9osdqr2sar5xoq6SZNeFHS5klE7O5Yb2ruqBQ==
X-ME-Sender: <xms:jVuaY4RVF_FqapBuY6brlmv4ImnaYm0SkHQUkDrtqrvJ4KwTlX9p1A>
    <xme:jVuaY1wdajM-xiqNsQ4J6248YviFSx3unMH30XQMHvye0u7GrlBCXBb9de_rbv5jl
    TH3j2gUTsolqoSvTg>
X-ME-Received: <xmr:jVuaY12Avwq6ilsU2b3W2YHz9g55DfjpoAbszZVnmk-tcwvI16tZWC7AcebdW6qZCwEEKaMHbprkbTqLyIGer_zBRaHV8BvH25rJZYWUaH8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeggddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenfg
    hrlhcuvffnffculdejtddmnecujfgurhephffvvefufffkofgjfhgggfestdekredtredt
    tdenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqeenuc
    ggtffrrghtthgvrhhnpefgfefggeejhfduieekvdeuteffleeifeeuvdfhheejleejjeek
    gfffgefhtddtteenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfh
    hrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:jVuaY8ChfOHLKEmdVeB8HBiilfhrWMgaN5RoZ_t2NX1ZNjoq8MOkyA>
    <xmx:jVuaYxgjp9Tj_1J4QSWrxPrF8KnW1cN_Knj5QC10IfXJOFhHZIAfoQ>
    <xmx:jVuaY4oduF-UxdOeAjqWJ4NMdbSITTHSuAyKTK1U3Rs0bDl1NNfVtw>
    <xmx:jVuaY4Oy_aEMdfx61ZqwhhhAqWy68gns_TDC05mpPKg1dDK_vk1nUA>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Dec 2022 18:26:04 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     ppenkov@aviatrix.com, dbird@aviatrix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next 1/6] ip: frags: Return actual error codes from ip_check_defrag()
Date:   Wed, 14 Dec 2022 16:25:28 -0700
Message-Id: <cc96452ecae8a1934b0f96a73272e18c78ae5f90.1671049840.git.dxu@dxuuu.xyz>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1671049840.git.dxu@dxuuu.xyz>
References: <cover.1671049840.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
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
 net/ipv4/ip_fragment.c | 11 ++++++-----
 net/packet/af_packet.c |  2 +-
 3 files changed, 8 insertions(+), 7 deletions(-)

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
index 69c00ffdcf3e..7406c6b6376d 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -514,6 +514,7 @@ struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user)
 	struct iphdr iph;
 	int netoff;
 	u32 len;
+	int err;
 
 	if (skb->protocol != htons(ETH_P_IP))
 		return skb;
@@ -535,15 +536,15 @@ struct sk_buff *ip_check_defrag(struct net *net, struct sk_buff *skb, u32 user)
 		if (skb) {
 			if (!pskb_may_pull(skb, netoff + iph.ihl * 4)) {
 				kfree_skb(skb);
-				return NULL;
+				return ERR_PTR(-ENOMEM);
 			}
-			if (pskb_trim_rcsum(skb, netoff + len)) {
+			if ((err = pskb_trim_rcsum(skb, netoff + len))) {
 				kfree_skb(skb);
-				return NULL;
+				return ERR_PTR(err);
 			}
 			memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
-			if (ip_defrag(net, skb, user))
-				return NULL;
+			if ((err = ip_defrag(net, skb, user)))
+				return ERR_PTR(err);
 			skb_clear_hash(skb);
 		}
 	}
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 41c4ccc3a5d6..cf706f98448e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1472,7 +1472,7 @@ static int packet_rcv_fanout(struct sk_buff *skb, struct net_device *dev,
 
 	if (fanout_has_flag(f, PACKET_FANOUT_FLAG_DEFRAG)) {
 		skb = ip_check_defrag(net, skb, IP_DEFRAG_AF_PACKET);
-		if (!skb)
+		if (IS_ERR(skb))
 			return 0;
 	}
 	switch (f->type) {
-- 
2.39.0

