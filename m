Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAA54FF26D
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234019AbiDMIqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiDMIqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:18 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8627750447;
        Wed, 13 Apr 2022 01:43:57 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id j8so1350986pll.11;
        Wed, 13 Apr 2022 01:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/WNILOdnKVUcQWRps0HdDCOJ2Ayw4wZcEI2cZi5xPjA=;
        b=En4zjQhdSiB0UMqHwU7grNsvnTv94MzrlMNTZCz0VLP2sZZN/cXkBzbeKpoi24nrUS
         6sJo4MpCqBLa9P37patLwBt/Fa4mw5UU4LA3y+vHqnrHKRVEApR24/HItSzYnSPaEL/w
         E+z80EzdxF68OIY7ESQI5iCKBa++y6RCGaldeRvdgkLYbupd5LuWjUs/FiJWqCgesYux
         5YwUmP0SH4rNFBT5OALUyaB0wFqLtH00QioNGPxnouPbEJwCHZmNVRb8bDKqScPkyMJb
         CDj920k6LwCSPuGs1AxB4jYp9yQPkJSx3QvPq/ea+gt6nCPvkywwV5TCnHdAvWok0pGL
         HQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/WNILOdnKVUcQWRps0HdDCOJ2Ayw4wZcEI2cZi5xPjA=;
        b=2Mdss6QKHXEWqVjRoE88Sxnfl6yWxm0CZQ11KXzEqBy5qiq3Dtaizsd4L8St3k1tk/
         XFUEOFsNHkCLXcfsalKhnknyF6xbwThpt87P6zem/Ci+igNsNWrqg0OQ6Y692RjS9+It
         u8C87DGyp5W4LOdU0euBbZ1BbiPXcES0b70A7Doh46I0RVv0INYQLPcVoVtIAxuUxNnu
         0A5Ctb8Nyx23Ifyy2NsFPMOEcxLtgbzwqfmtbneGDXtIwjkJXvchec/ajdc5u0cGVLkV
         0q67X+AZnhssmIcT9IUvFa0X9I9loJmCrNyYQBAciXB288kUxITW6dYxuRDkjQkb9sIw
         4ycA==
X-Gm-Message-State: AOAM531FpfBFTAVJcxs0ZJFPq2bLvvzEueAFTN2QGv0Xwo0bYKhamInW
        Af2UdTgnAD5OdSLB4q8UaOhlZ/VtsmY=
X-Google-Smtp-Source: ABdhPJy9BDgQBpeVXDbGKV1+S82yXRVfb2x4Rxx4IgVLBs9XktLF7OduwJvhB5vzsmlhZkes0HHegw==
X-Received: by 2002:a17:902:ce8a:b0:158:7b10:980b with SMTP id f10-20020a170902ce8a00b001587b10980bmr10220024plg.122.1649839437125;
        Wed, 13 Apr 2022 01:43:57 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:43:56 -0700 (PDT)
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
Subject: [PATCH net-next 2/9] net: ipv4: add skb drop reasons to ip_error()
Date:   Wed, 13 Apr 2022 16:15:53 +0800
Message-Id: <20220413081600.187339-3-imagedong@tencent.com>
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

Eventually, I find out the handler function for inputting route lookup
fail: ip_error().

The drop reasons we used in ip_error() are almost corresponding to
IPSTATS_MIB_*, and following new reasons are introduced:

SKB_DROP_REASON_IP_INADDRERRORS
SKB_DROP_REASON_IP_INNOROUTES

Isn't the name SKB_DROP_REASON_IP_HOSTUNREACH and
SKB_DROP_REASON_IP_NETUNREACH more accurate? To make them corresponding
to IPSTATS_MIB_*, we keep their name still.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 include/linux/skbuff.h     | 6 ++++++
 include/trace/events/skb.h | 2 ++
 net/ipv4/route.c           | 6 +++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0cbd6ada957c..886e83ac4b70 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -447,6 +447,12 @@ enum skb_drop_reason {
 					 * 2211, such as a broadcasts
 					 * ICMP_TIMESTAMP
 					 */
+	SKB_DROP_REASON_IP_INADDRERRORS,	/* host unreachable, corresponding
+						 * to IPSTATS_MIB_INADDRERRORS
+						 */
+	SKB_DROP_REASON_IP_INNOROUTES,	/* network unreachable, corresponding
+					 * to IPSTATS_MIB_INADDRERRORS
+					 */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 42647114fffe..0acac7e5a019 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -63,6 +63,8 @@
 	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
 	EM(SKB_DROP_REASON_ICMP_CSUM, ICMP_CSUM)		\
 	EM(SKB_DROP_REASON_INVALID_PROTO, INVALID_PROTO)	\
+	EM(SKB_DROP_REASON_IP_INADDRERRORS, IP_INADDRERRORS)	\
+	EM(SKB_DROP_REASON_IP_INNOROUTES, IP_INNOROUTES)	\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 98c6f3429593..0b581ee5c000 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -945,6 +945,7 @@ static int ip_error(struct sk_buff *skb)
 	struct inet_peer *peer;
 	unsigned long now;
 	struct net *net;
+	SKB_DR(reason);
 	bool send;
 	int code;
 
@@ -964,10 +965,12 @@ static int ip_error(struct sk_buff *skb)
 	if (!IN_DEV_FORWARD(in_dev)) {
 		switch (rt->dst.error) {
 		case EHOSTUNREACH:
+			SKB_DR_SET(reason, IP_INADDRERRORS);
 			__IP_INC_STATS(net, IPSTATS_MIB_INADDRERRORS);
 			break;
 
 		case ENETUNREACH:
+			SKB_DR_SET(reason, IP_INNOROUTES);
 			__IP_INC_STATS(net, IPSTATS_MIB_INNOROUTES);
 			break;
 		}
@@ -983,6 +986,7 @@ static int ip_error(struct sk_buff *skb)
 		break;
 	case ENETUNREACH:
 		code = ICMP_NET_UNREACH;
+		SKB_DR_SET(reason, IP_INNOROUTES);
 		__IP_INC_STATS(net, IPSTATS_MIB_INNOROUTES);
 		break;
 	case EACCES:
@@ -1009,7 +1013,7 @@ static int ip_error(struct sk_buff *skb)
 	if (send)
 		icmp_send(skb, ICMP_DEST_UNREACH, code, 0);
 
-out:	kfree_skb(skb);
+out:	kfree_skb_reason(skb, reason);
 	return 0;
 }
 
-- 
2.35.1

