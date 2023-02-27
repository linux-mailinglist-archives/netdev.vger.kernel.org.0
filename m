Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E99A6A4BA2
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjB0Twf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:52:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230373AbjB0Twb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:52:31 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7356629404;
        Mon, 27 Feb 2023 11:52:03 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8CA9E320085B;
        Mon, 27 Feb 2023 14:52:02 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 27 Feb 2023 14:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1677527522; x=1677613922; bh=n5
        tZMMg11TOco/li89LY2FO0tLfTaFl2pcXo+bm3FBc=; b=fxb51F2M+L08SuW336
        BI5i3C1CBNe4+uMtuv5gMqdG1NIvlmsUfqlZhS5rvTXU8T60ipLEaJqjod/bu66+
        OHlpAsYS+KvVk4L2toVhSg8gCYIpP5QgJWDXHPQ1TvbCSHIIo5BvYA5ySLLj2UTD
        88II+U1gS9zE0eeV9KNph7LZNaBSG53240eydWdZdZyXR/RyGTVF6jUUN6Liulzz
        7LHgmIGXYyHO5bosf9rX5Eu0CfhXMzx4ix0gn8t/K1K4L/hegyuOQrmrjbgpUts0
        pBB4pRPfZpikbn8AlVIcoLW9B5OL+Xdw1Dgo20bW+wKkbr2k9V3uTyoMq3Gvc2Pp
        WwZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1677527522; x=1677613922; bh=n5tZMMg11TOco
        /li89LY2FO0tLfTaFl2pcXo+bm3FBc=; b=s2kFawmVBtB4k54CZ/h/txnrv9owU
        XislZ3yArXAawhcKAB857z/pb92fvtSgdqwGrkvvMrJvZHFsIXJdI0HckEKEiCwn
        omiZ6NYk6IpLRir/+NZQiCqlMJB5TPaCZzaBbnTa527vm9jxYv4tzMC3Y96oybQ+
        7NLdjEY6TPQBA37yVUdDuzAe55jrVk4ktsekZzBjd+VJ/UbRuecsvwqf/kh10+Bv
        9KJn4GJVp/N6NiWrpln2KX6LM1YKKlWI8SUJ4Ua52+DLCOCiJF8PyTvnycCG5BMQ
        H+p7wCj4ME2WH1xTyGtnbVLkiGeWljeL02wZX76tlNBVBACew8bCNsgwg==
X-ME-Sender: <xms:4gn9Y45WvLk2QpXOvSC5jD1CeYe5vQAUgocFLR1cVgTegNkzZ-97lA>
    <xme:4gn9Y56K0oFpbtET_I0GLiud-0xt1k5_UOhI004Zpq4-UMjCFfO4KI5uhJ1CTEuVD
    r2MV9d8sedd3zP3ag>
X-ME-Received: <xmr:4gn9Y3dRNzQUjrwVAUgM_h040uDPLVFBvEVsPIQX5ILB8l6o9NhYJga22_juGzdZqA-7VHtpclgRThjlu0T2rcYFGRLeeH7EiEdETlGke0KrYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeltddguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhephf
    fvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgrnhhivghlucgiuhcu
    oegugihusegugihuuhhurdighiiiqeenucggtffrrghtthgvrhhnpefgfefggeejhfduie
    ekvdeuteffleeifeeuvdfhheejleejjeekgfffgefhtddtteenucevlhhushhtvghrufhi
    iigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:4gn9Y9IFVn9_NUsvcv6C4AGYJnQ-bRG6dG-VagpY62C_jdCdwQmFrg>
    <xmx:4gn9Y8LqtjaFLsVqDDaoMJkf7E7Eh6d5FODI2UA6DVw36_ERyeWjsA>
    <xmx:4gn9Y-zcispLgHQkaZVDbnlz16Sud2ce_44NnRFLN4G2Vp1HC_2DpQ>
    <xmx:4gn9Y097RMXcD7m--x3PbA-fxirIZWD1LEJjCFPXR3cDtGxJN32MOQ>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Feb 2023 14:52:01 -0500 (EST)
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        dsahern@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 4/8] net: ipv6: Factor ipv6_frag_rcv() to take netns and user
Date:   Mon, 27 Feb 2023 12:51:06 -0700
Message-Id: <2928ca6d91690f04f59759bb330e01fcf3f061a7.1677526810.git.dxu@dxuuu.xyz>
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

Factor _ipv6_frag_rcv() out of ipv6_frag_rcv() such that the former
takes a netns and user field.

We do this so that the BPF interface for ipv6 defrag can have the same
semantics as ipv4 defrag (see ip_check_defrag()).

Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
---
 include/net/ipv6.h    |  1 +
 net/ipv6/reassembly.c | 16 +++++++++++-----
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 7332296eca44..9bbdf82ca6c0 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1238,6 +1238,7 @@ int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 extern const struct proto_ops inet6_stream_ops;
 extern const struct proto_ops inet6_dgram_ops;
 extern const struct proto_ops inet6_sockraw_ops;
+int _ipv6_frag_rcv(struct net *net, struct sk_buff *skb, u32 user);
 
 struct group_source_req;
 struct group_filter;
diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 5bc8a28e67f9..5100430eb982 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -81,13 +81,13 @@ static void ip6_frag_expire(struct timer_list *t)
 }
 
 static struct frag_queue *
-fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif)
+fq_find(struct net *net, __be32 id, const struct ipv6hdr *hdr, int iif, u32 user)
 {
 	struct frag_v6_compare_key key = {
 		.id = id,
 		.saddr = hdr->saddr,
 		.daddr = hdr->daddr,
-		.user = IP6_DEFRAG_LOCAL_DELIVER,
+		.user = user,
 		.iif = iif,
 	};
 	struct inet_frag_queue *q;
@@ -324,12 +324,11 @@ static int ip6_frag_reasm(struct frag_queue *fq, struct sk_buff *skb,
 	return -1;
 }
 
-static int ipv6_frag_rcv(struct sk_buff *skb)
+int _ipv6_frag_rcv(struct net *net, struct sk_buff *skb, u32 user)
 {
 	struct frag_hdr *fhdr;
 	struct frag_queue *fq;
 	const struct ipv6hdr *hdr = ipv6_hdr(skb);
-	struct net *net = dev_net(skb_dst(skb)->dev);
 	u8 nexthdr;
 	int iif;
 
@@ -377,7 +376,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	}
 
 	iif = skb->dev ? skb->dev->ifindex : 0;
-	fq = fq_find(net, fhdr->identification, hdr, iif);
+	fq = fq_find(net, fhdr->identification, hdr, iif, user);
 	if (fq) {
 		u32 prob_offset = 0;
 		int ret;
@@ -410,6 +409,13 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	return -1;
 }
 
+static int ipv6_frag_rcv(struct sk_buff *skb)
+{
+	struct net *net = dev_net(skb_dst(skb)->dev);
+
+	return _ipv6_frag_rcv(net, skb, IP6_DEFRAG_LOCAL_DELIVER);
+}
+
 static const struct inet6_protocol frag_protocol = {
 	.handler	=	ipv6_frag_rcv,
 	.flags		=	INET6_PROTO_NOPOLICY,
-- 
2.39.1

