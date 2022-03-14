Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2EF4D8602
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 14:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241793AbiCNNex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 09:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241808AbiCNNev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 09:34:51 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6114226549;
        Mon, 14 Mar 2022 06:33:36 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q11so13527402pln.11;
        Mon, 14 Mar 2022 06:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DAuSBfeLpiTRO6SZRb/v3UzbKgj2YbHpow+Ky+sb0Nc=;
        b=Nd4wKXMNFV/CTh0rPlWQcWIgJkUAE851xZhgVe3OcRwcZu1czXppIgfWpt1xH1lFix
         LYffdkYsVTeOPm7YzGTPTaNIT6LtNQMkOdO9BBWqY0hvBLb/AaAqCeWlr1PVxTokLjZk
         iEfPTMP/Vk0MB+Kh+FUr5L9CE/hXQWYDMkBM76r3gnBBxOa6aFJvtWjn2ucSJz33GPSm
         x5u4Sa9cQLtdfyJzBvgT9zLeyf+udHb77e7XkiBV9wRGshoWrjCX9ANVN+yjR3DLna4Z
         iswnza09nvaN+8StCgBlvvxtcOvT9MeiiwB9PuYPteXu+2ypelUcDGtFYyJ6uUv29XZx
         pdIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DAuSBfeLpiTRO6SZRb/v3UzbKgj2YbHpow+Ky+sb0Nc=;
        b=L9nMl7VUhhPjBMLR4UE1MgVFWOnU1z7eYzhNR1sR3fPn0iDiCuOwnYm5XGrJMQ4Aor
         bR8KYjPWkyhqN4Johmse6RrDG4PeVnkybF+mf1NLQb6EtVkCJi/WszufNI1rhNzOhk8s
         BhC7CQS/XWzF4L1V4J/EQtrmJrateTmxQxDWSEMKAVjk13lbqjJF7Ph17Lgb7JLr2JjL
         LCBAJvWmP2zrPVelIaDx8OXdPIXeVy7hc59vIZ8FeXjACfk0pQwn+27DwepfeRDq3yaG
         7aHIjflcK+0VXQfiDAGtUZGlsc+R5B1YWDOASDhdXkzhdzZVUCz+c0944gnc1q58eCgo
         1CXg==
X-Gm-Message-State: AOAM530fun/QIm29Jc0R9Q8kfFbrrolA0qtQ9t349esXgLiVSdSmhPhM
        suhOyqGlgSElbviJMroZjzY=
X-Google-Smtp-Source: ABdhPJwam+ABYsMM9CB9+S5gWaVLT5msi5eAqHqh963gQAaS4LUm1AVe2VCUgeyherlBmW5T0IfSXg==
X-Received: by 2002:a17:902:b597:b0:151:e24e:a61e with SMTP id a23-20020a170902b59700b00151e24ea61emr23737070pls.66.1647264815836;
        Mon, 14 Mar 2022 06:33:35 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id j13-20020a056a00130d00b004f1025a4361sm22118722pfu.202.2022.03.14.06.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 06:33:35 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
Subject: [PATCH net-next 3/3] net: ipgre: add skb drop reasons to gre_rcv()
Date:   Mon, 14 Mar 2022 21:33:12 +0800
Message-Id: <20220314133312.336653-4-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314133312.336653-1-imagedong@tencent.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
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

Replace kfree_skb() used in gre_rcv() with kfree_skb_reason(). With
previous patch, we can tell that no tunnel device is found when
PACKET_NEXT is returned by erspan_rcv() or ipgre_rcv().

In this commit, following new drop reasons are added:

SKB_DROP_REASON_GRE_CSUM
SKB_DROP_REASON_GRE_NOTUNNEL

Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Reviewed-by: Biao Jiang <benbjiang@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     |  2 ++
 include/trace/events/skb.h |  2 ++
 net/ipv4/ip_gre.c          | 28 ++++++++++++++++++----------
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 5edb704af5bb..4f5e58e717ee 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -448,6 +448,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_GRE_NOHANDLER,	/* no handler found (version not
 					 * supported?)
 					 */
+	SKB_DROP_REASON_GRE_CSUM,	/* GRE csum error */
+	SKB_DROP_REASON_GRE_NOTUNNEL,	/* no tunnel device found */
 	SKB_DROP_REASON_MAX,
 };
 
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index f2bcffdc4bae..e8f95c96cf9d 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -63,6 +63,8 @@
 	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
 	EM(SKB_DROP_REASON_GRE_VERSION, GRE_VERSION)		\
 	EM(SKB_DROP_REASON_GRE_NOHANDLER, GRE_NOHANDLER)	\
+	EM(SKB_DROP_REASON_GRE_CSUM, GRE_CSUM)			\
+	EM(SKB_DROP_REASON_GRE_NOTUNNEL, GRE_NOTUNNEL)		\
 	EMe(SKB_DROP_REASON_MAX, MAX)
 
 #undef EM
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b1579d8374fd..b989239e4abc 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -421,9 +421,10 @@ static int ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
 
 static int gre_rcv(struct sk_buff *skb)
 {
+	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct tnl_ptk_info tpi;
 	bool csum_err = false;
-	int hdr_len;
+	int hdr_len, ret;
 
 #ifdef CONFIG_NET_IPGRE_BROADCAST
 	if (ipv4_is_multicast(ip_hdr(skb)->daddr)) {
@@ -438,19 +439,26 @@ static int gre_rcv(struct sk_buff *skb)
 		goto drop;
 
 	if (unlikely(tpi.proto == htons(ETH_P_ERSPAN) ||
-		     tpi.proto == htons(ETH_P_ERSPAN2))) {
-		if (erspan_rcv(skb, &tpi, hdr_len) == PACKET_RCVD)
-			return 0;
-		goto out;
-	}
+		     tpi.proto == htons(ETH_P_ERSPAN2)))
+		ret = erspan_rcv(skb, &tpi, hdr_len);
+	else
+		ret = ipgre_rcv(skb, &tpi, hdr_len);
 
-	if (ipgre_rcv(skb, &tpi, hdr_len) == PACKET_RCVD)
+	switch (ret) {
+	case PACKET_NEXT:
+		reason = SKB_DROP_REASON_GRE_NOTUNNEL;
+		break;
+	case PACKET_RCVD:
 		return 0;
-
-out:
+	case PACKET_REJECT:
+		reason = SKB_DROP_REASON_NOMEM;
+		break;
+	}
 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
 drop:
-	kfree_skb(skb);
+	if (csum_err)
+		reason = SKB_DROP_REASON_GRE_CSUM;
+	kfree_skb_reason(skb, reason);
 	return 0;
 }
 
-- 
2.35.1

