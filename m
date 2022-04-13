Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A3C4FF279
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234152AbiDMIrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbiDMIql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:41 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366BCB03;
        Wed, 13 Apr 2022 01:44:15 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id i184so706675pgc.2;
        Wed, 13 Apr 2022 01:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MVbrPBlxN8h17y1KsP/PN+Nejk6/bRtqjvJZhHhRwMs=;
        b=XJHs72Fp3OyZEueuBD6LQUSPFpvkPqZAPZs4YzL9ZahWRvFn2XFuf+b3JRw8N2yESm
         +RhBGRoqZ2DjwNid4WdcR5uwBa8AgkCfyzj/iBhtbKd/3D/C9h9c8LbYh0aKVfPRypPP
         dhJyL5TVlhDrNiwJlAkrCDqBKCyzel8TxKA/c84DM7g5/x9gGfoIEBtEnH1x4SroLaBo
         +mqnXBVuwHUXWH7BsO4vqV+s/o6tOquoRqa8Lic2TuN866Vz0EdDYIgUDhVx3KYJQYFZ
         12w3hMRzWL2k5GLMyBa1FGpQ2ZCtE6Bk/mVk/uvOltT5FcMNo41nh50sjowHa5j462/D
         fYGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MVbrPBlxN8h17y1KsP/PN+Nejk6/bRtqjvJZhHhRwMs=;
        b=u8ne8Vnqm/MkbNg4bMvYL3TRcZVC+J11yxRWYAv4mEe5JrEfGmFdiinm9qx7PKvfef
         7mCtoeD567Fa+RR7kaZPLKyvgj2rutCVqrmyg6WPiZQ07pHlH8L939vTkoEupwuW6CrJ
         zdQT+QQkeVwJWsIGH0VCPtcKDd4omX6i1+EDCT7zi6P8KTk1bbNaaQVHb2zxL8w5RTR8
         OTPFDqj5p7MS5zttLVeyYTZwU+IeotvaiEQt2Li0FJDG4UGnIH2JV0EquSQuqRJ+cG09
         Feqk8mY7UNrZrYu1G39jQwj92BB9wQQ8/RPaDU+yJPtya4aqgaT8A1xK8j1eTFmOzdr7
         Su/g==
X-Gm-Message-State: AOAM533+gULWxjxbnoodqxxpdCU0gqa/m/GvZGY/x9h9Dz7D8ctIrnKG
        qvNr2+yaAUCxx+Z7bWwhJw8=
X-Google-Smtp-Source: ABdhPJwUM1suuPOtUWt4lxBcbo++OrJB9f5Qc59Wfi9t5epfJ/wuwAkZ/Uc9i9ENyN1/uSd9EF36RA==
X-Received: by 2002:a63:bd49:0:b0:39d:a2d3:94a2 with SMTP id d9-20020a63bd49000000b0039da2d394a2mr4495387pgp.242.1649839454726;
        Wed, 13 Apr 2022 01:44:14 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:44:14 -0700 (PDT)
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
Subject: [PATCH net-next 6/9] net: ipv6: remove redundant statistics in ipv6_hop_jumbo()
Date:   Wed, 13 Apr 2022 16:15:57 +0800
Message-Id: <20220413081600.187339-7-imagedong@tencent.com>
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

There are two call chains for ipv6_hop_jumbo(). The first one is:

ipv6_destopt_rcv() -> ip6_parse_tlv() -> ipv6_hop_jumbo()

On this call chain, the drop statistics will be done in
ipv6_destopt_rcv() with 'IPSTATS_MIB_INHDRERRORS' if ipv6_hop_jumbo()
returns false.

The second call chain is:

ip6_rcv_core() -> ipv6_parse_hopopts() -> ip6_parse_tlv()

And the drop statistics will also be done in ip6_rcv_core() with
'IPSTATS_MIB_INHDRERRORS' if ipv6_hop_jumbo() returns false.

Therefore, the statistics in ipv6_hop_jumbo() is redundant, which
means the drop is counted twice. The statistics in ipv6_hop_jumbo()
is almost the same as the outside, except the
'IPSTATS_MIB_INTRUNCATEDPKTS', which seems that we have to ignore it.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 net/ipv6/exthdrs.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 658d5eabaf7e..31318ee62d29 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -997,33 +997,26 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
 {
 	const unsigned char *nh = skb_network_header(skb);
-	struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
-	struct net *net = ipv6_skb_net(skb);
 	u32 pkt_len;
 
 	if (nh[optoff + 1] != 4 || (optoff & 3) != 2) {
 		net_dbg_ratelimited("ipv6_hop_jumbo: wrong jumbo opt length/alignment %d\n",
 				    nh[optoff+1]);
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 		goto drop;
 	}
 
 	pkt_len = ntohl(*(__be32 *)(nh + optoff + 2));
 	if (pkt_len <= IPV6_MAXPLEN) {
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+2);
 		return false;
 	}
 	if (ipv6_hdr(skb)->payload_len) {
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
 		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
 		return false;
 	}
 
-	if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
-		__IP6_INC_STATS(net, idev, IPSTATS_MIB_INTRUNCATEDPKTS);
+	if (pkt_len > skb->len - sizeof(struct ipv6hdr))
 		goto drop;
-	}
 
 	if (pskb_trim_rcsum(skb, pkt_len + sizeof(struct ipv6hdr)))
 		goto drop;
-- 
2.35.1

