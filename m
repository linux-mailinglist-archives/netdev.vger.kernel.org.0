Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F294FF282
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbiDMIrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234103AbiDMIq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:56 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE0F340D9;
        Wed, 13 Apr 2022 01:44:24 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q19so1180413pgm.6;
        Wed, 13 Apr 2022 01:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C1EWK9eoSuI/9QQ/ZExq3hXbMv6fm1L8pBD1vk2oFeY=;
        b=A3ObKFOxl+0/AdK6Yu014z7zSB1v0SxjLRHcyy9i9VFwliZvTtzPwVlwD/rozFZ7ru
         HGR/Nv2GU3Uru0f9FdjJZfhEV/BvO74JLc3oe7usbkHyQLdxGsM4In++pCessoUJZ5YY
         NyS58xtquQCon4krYZLbr0xvf2w3eer1U7eidcYVMxH2P5s5niwNm8E1iLUYN9ctJDxr
         olpM2UX0sLWcrwuFgMnUkuhBBit6mY1SYqyLbk5y3O9Y+f+D6WogUKQnDPYSgDJ/ZvTt
         ZKNI0HWYDEA7UjGO2wTD1L3RF+d4otUicX93ZBEakZrkea41BBtNOyC+nP/GO1EC5xam
         T/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C1EWK9eoSuI/9QQ/ZExq3hXbMv6fm1L8pBD1vk2oFeY=;
        b=R8Or/QAopY5FjFcxtrSgAsAm2pu5TxTBzQ4vFPTiUkZWqTt6/A065IWnctdR++nNDl
         E/iy3h6YegFmGkbAE7qnrZT4119fAXwCvirx/zuMsB/yQVcSzxYRrTheC1BKUU/gTdJv
         nAzamf/Q9fBFgG3hrJYm0DC5aQD6mMiTF4/7AI+cmcPaV3aI38mNztfx3Bzmks4wXwtB
         +/Dng7qW8vHaXKMuQ7uQUtdlheThLNIu/v5S6XpHOtcdI5beP1BrRjrCUpmqTB7BlHvr
         VE6EuuIPGDVps0wk6Y4J5d/yUFFy6pb493wnsnjgNnEWO2LK2LT1lQyv64WN7Y3DWdBY
         Az/A==
X-Gm-Message-State: AOAM530nxIs/VO7+zv1vfkm2PGJn++VYp0ceU69z6kJKNKKtWnXFNjHL
        paws4RPyWYUSOmucn43woWg=
X-Google-Smtp-Source: ABdhPJwNrvCsBiuZrgYEZtLt4IyLJj7imWGi1XpO3h/5S1QQqlHK8fnSKx/djmMh/1rhPopkcATzNw==
X-Received: by 2002:a63:5061:0:b0:39c:d0da:677b with SMTP id q33-20020a635061000000b0039cd0da677bmr24063625pgl.599.1649839463724;
        Wed, 13 Apr 2022 01:44:23 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:44:23 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 8/9] net: ipv6: add skb drop reasons to ip6_rcv_core()
Date:   Wed, 13 Apr 2022 16:15:59 +0800
Message-Id: <20220413081600.187339-9-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413081600.187339-1-imagedong@tencent.com>
References: <20220413081600.187339-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() used in ip6_rcv_core() with kfree_skb_reason().
No new drop reasons are added.

Seems now we use 'SKB_DROP_REASON_IP_INHDR' for too many case during
ipv6 header parse or check, just like what 'IPSTATS_MIB_INHDRERRORS'
do. Will it be too general and hard to know what happened?

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 net/ipv6/ip6_input.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index b4880c7c84eb..1b925ecb26e9 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -145,13 +145,14 @@ static void ip6_list_rcv_finish(struct net *net, struct sock *sk,
 static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 				    struct net *net)
 {
+	enum skb_drop_reason reason;
 	const struct ipv6hdr *hdr;
 	u32 pkt_len;
 	struct inet6_dev *idev;
 
 	if (skb->pkt_type == PACKET_OTHERHOST) {
 		dev_core_stats_rx_otherhost_dropped_inc(skb->dev);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_OTHERHOST);
 		return NULL;
 	}
 
@@ -161,9 +162,12 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 
 	__IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_IN, skb->len);
 
+	SKB_DR_SET(reason, NOT_SPECIFIED);
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL ||
 	    !idev || unlikely(idev->cnf.disable_ipv6)) {
 		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
+		if (unlikely(idev->cnf.disable_ipv6))
+			SKB_DR_SET(reason, IPV6DISABLED);
 		goto drop;
 	}
 
@@ -187,8 +191,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 
 	hdr = ipv6_hdr(skb);
 
-	if (hdr->version != 6)
+	if (hdr->version != 6) {
+		SKB_DR_SET(reason, UNHANDLED_PROTO);
 		goto err;
+	}
 
 	__IP6_ADD_STATS(net, idev,
 			IPSTATS_MIB_NOECTPKTS +
@@ -226,8 +232,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	if (!ipv6_addr_is_multicast(&hdr->daddr) &&
 	    (skb->pkt_type == PACKET_BROADCAST ||
 	     skb->pkt_type == PACKET_MULTICAST) &&
-	    idev->cnf.drop_unicast_in_l2_multicast)
+	    idev->cnf.drop_unicast_in_l2_multicast) {
+		SKB_DR_SET(reason, UNICAST_IN_L2_MULTICAST);
 		goto err;
+	}
 
 	/* RFC4291 2.7
 	 * Nodes must not originate a packet to a multicast address whose scope
@@ -256,12 +264,11 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 		if (pkt_len + sizeof(struct ipv6hdr) > skb->len) {
 			__IP6_INC_STATS(net,
 					idev, IPSTATS_MIB_INTRUNCATEDPKTS);
+			SKB_DR_SET(reason, PKT_TOO_SMALL);
 			goto drop;
 		}
-		if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr))) {
-			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
-			goto drop;
-		}
+		if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
+			goto err;
 		hdr = ipv6_hdr(skb);
 	}
 
@@ -282,9 +289,10 @@ static struct sk_buff *ip6_rcv_core(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 err:
 	__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
+	SKB_DR_OR(reason, IP_INHDR);
 drop:
 	rcu_read_unlock();
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return NULL;
 }
 
-- 
2.35.1

