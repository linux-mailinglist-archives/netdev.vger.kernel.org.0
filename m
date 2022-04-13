Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C904A4FF27B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiDMIrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234095AbiDMIql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:41 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A439ABC16;
        Wed, 13 Apr 2022 01:44:19 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so5612959pjb.2;
        Wed, 13 Apr 2022 01:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=b14oDzmADLnQU0iBJxS2XBsLb3tdT7kefJ5hMiFLNcI=;
        b=hI+f1rG27+qJMi49u/tnSWDrnWOUHvZJCtMugo7el9sl7sH6yGt45i6ip4XrgOT3Hq
         qpKvSxvExKDpSIOR5/mKF+/f/r/c8IELVw21Q/dIxnDbv8QXzgmrEVUj1xGg30jBiGC8
         MR28i8h6h8NRhNJaWzuKt1Hitn0ceGeQSad0DxhlX5j+IYyAOfUBWrQvT80OwHw7JhWr
         t7lNyF95h21M49VBFGXGa9zaQA/NaoeJH2OpCU+WJhHUUKNAOle5kaeSc9fuvxqlRzk9
         CQG+ovzQ8mNkFFFbqAQsl/osG5W4bC3IHMPtTC3rh4IYXnTQGc0DYrCRhDDJNyAtjsWF
         AN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b14oDzmADLnQU0iBJxS2XBsLb3tdT7kefJ5hMiFLNcI=;
        b=3cYjm9JA8NvjQGugoX9efXHYHynO5i+aBRK38crqCeGRCX9TmCUvNbh9s9HzuVwo7A
         xrYwTbQUd7kB2T9If7iGhDxTLPkRdSTreFOxkTPFuiUpL30uQI4qFP0MIVTwosa9UCjX
         86E39azAgQ+d1A2QcKxG8nnZA2vJpmVIn4w+E3+QwtyYka89ZTsL2fq5/s5wfbzoFkLI
         biixwoZPRxLX120m9TKtzmPrmaVVWLzxZeNt21zjzR4IUaoXST1maSWSRbeLKdXrPibi
         wnejY9VbrEiklbTVh8QtOYPULYrOltIbQhDp6n4BLjXeAt8us2/pru/qaJ3iVcOmv9FV
         8f+Q==
X-Gm-Message-State: AOAM532MPrbkEIu2iM6OwVRaWujrINVNIZhZHTWpEjb7QT5lvH7+lo9x
        s8jyfGUwCVrgR+2RKhCZ9bc=
X-Google-Smtp-Source: ABdhPJwRUcYPIeZqzrrcSKdRmAml0um0S/cgQN1UijpYsiiP+gASuihj5Uk6CoS8CA+PmoufOE4g7w==
X-Received: by 2002:a17:902:c2d8:b0:154:2946:4ff with SMTP id c24-20020a170902c2d800b00154294604ffmr41555931pla.99.1649839459225;
        Wed, 13 Apr 2022 01:44:19 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:44:18 -0700 (PDT)
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
Subject: [PATCH net-next 7/9] net: ipv6: add skb drop reasons to TLV parse
Date:   Wed, 13 Apr 2022 16:15:58 +0800
Message-Id: <20220413081600.187339-8-imagedong@tencent.com>
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

Replace kfree_skb() used in TLV encoded option header parsing with
kfree_skb_reason(). Following functions are involved:

ip6_parse_tlv()
ipv6_hop_ra()
ipv6_hop_ioam()
ipv6_hop_jumbo()
ipv6_hop_calipso()
ipv6_dest_hao()

Most skb drops during this process are regarded as 'InHdrErrors',
as 'IPSTATS_MIB_INHDRERRORS' is used when ip6_parse_tlv() fails,
which make we use 'SKB_DROP_REASON_IP_INHDR' correspondingly.

However, 'IP_INHDR' is a relatively general reason. Therefore, we
can use other reasons with higher priority in some cases. For example,
'SKB_DROP_REASON_UNHANDLED_PROTO' is used for unknown TLV options.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 net/ipv6/exthdrs.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 31318ee62d29..e670cf2fe85d 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -90,12 +90,13 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
 			break;
 		fallthrough;
 	case 2: /* send ICMP PARM PROB regardless and drop packet */
-		icmpv6_param_prob(skb, ICMPV6_UNK_OPTION, optoff);
+		icmpv6_param_prob_reason(skb, ICMPV6_UNK_OPTION, optoff,
+					 SKB_DROP_REASON_UNHANDLED_PROTO);
 		return false;
 	}
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_UNHANDLED_PROTO);
 	return false;
 }
 
@@ -218,7 +219,7 @@ static bool ip6_parse_tlv(bool hopbyhop,
 	if (len == 0)
 		return true;
 bad:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
 	return false;
 }
 
@@ -232,6 +233,7 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
 	struct ipv6_destopt_hao *hao;
 	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
+	SKB_DR(reason);
 	int ret;
 
 	if (opt->dsthao) {
@@ -246,19 +248,23 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
 	if (hao->length != 16) {
 		net_dbg_ratelimited("hao invalid option length = %d\n",
 				    hao->length);
+		SKB_DR_SET(reason, IP_INHDR);
 		goto discard;
 	}
 
 	if (!(ipv6_addr_type(&hao->addr) & IPV6_ADDR_UNICAST)) {
 		net_dbg_ratelimited("hao is not an unicast addr: %pI6\n",
 				    &hao->addr);
+		SKB_DR_SET(reason, INVALID_PROTO);
 		goto discard;
 	}
 
 	ret = xfrm6_input_addr(skb, (xfrm_address_t *)&ipv6h->daddr,
 			       (xfrm_address_t *)&hao->addr, IPPROTO_DSTOPTS);
-	if (unlikely(ret < 0))
+	if (unlikely(ret < 0)) {
+		SKB_DR_SET(reason, XFRM_POLICY);
 		goto discard;
+	}
 
 	if (skb_cloned(skb)) {
 		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
@@ -281,7 +287,7 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
 	return true;
 
  discard:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return false;
 }
 #endif
@@ -934,7 +940,7 @@ static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
 	}
 	net_dbg_ratelimited("ipv6_hop_ra: wrong RA length %d\n",
 			    nh[optoff + 1]);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
 	return false;
 }
 
@@ -988,7 +994,7 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 	return true;
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
 	return false;
 }
 
@@ -997,26 +1003,32 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
+	SKB_DR(reason);
 	u32 pkt_len;
 
 	if (nh[optoff + 1] != 4 || (optoff & 3) != 2) {
 		net_dbg_ratelimited("ipv6_hop_jumbo: wrong jumbo opt length/alignment %d\n",
 				    nh[optoff+1]);
+		SKB_DR_SET(reason, IP_INHDR);
 		goto drop;
 	}
 
 	pkt_len = ntohl(*(__be32 *)(nh + optoff + 2));
 	if (pkt_len <= IPV6_MAXPLEN) {
-		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+2);
+		icmpv6_param_prob_reason(skb, ICMPV6_HDR_FIELD, optoff + 2,
+					 SKB_DROP_REASON_IP_INHDR);
 		return false;
 	}
 	if (ipv6_hdr(skb)->payload_len) {
-		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
+		icmpv6_param_prob_reason(skb, ICMPV6_HDR_FIELD, optoff,
+					 SKB_DROP_REASON_IP_INHDR);
 		return false;
 	}
 
-	if (pkt_len > skb->len - sizeof(struct ipv6hdr))
+	if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
+		SKB_DR_SET(reason, PKT_TOO_SMALL);
 		goto drop;
+	}
 
 	if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
 		goto drop;
@@ -1025,7 +1037,7 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
 	return true;
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 	return false;
 }
 
@@ -1047,7 +1059,7 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
 	return true;
 
 drop:
-	kfree_skb(skb);
+	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
 	return false;
 }
 
-- 
2.35.1

