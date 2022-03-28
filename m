Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFC344E8D52
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 06:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238035AbiC1E37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 00:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238029AbiC1E3y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 00:29:54 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DB2BCF;
        Sun, 27 Mar 2022 21:28:14 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id n7-20020a17090aab8700b001c6aa871860so14283712pjq.2;
        Sun, 27 Mar 2022 21:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//KZ6YHhys1mLVWKPMFh1+e7V9mc1xx+r9/4L0Awq3M=;
        b=cu5jt85mwMd8bjy3VdrAjlyqA9vXNc5JIWncUH2FX+K6qnECjxq/KwLpB6WAVyPKyQ
         fGlrsbjmB9zshvtk3Xqy9xscQF3+PA4Ndp670mxv5VxU3ydqc7XJio2PpDYG1J8CEwKt
         qw5oYInJ5jfZMVus5CCn6BGbnugkHx9K4ca+YinSAqFCYxPbEpaG7xCXK+dcTrCjryTK
         2GXMT3Q9H6r/sGfYvcWu58/67LjjIcOVE/bizVRGFUSFoKu4LnqjY/jzFv6FCDJ1Msaj
         cisjQE7k+DeXIeFbQ3q+UHzYzrQexJfJN5ikmlwHYNdJhyaJjlIZY7kJM1xgO2GRs9r1
         9FOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//KZ6YHhys1mLVWKPMFh1+e7V9mc1xx+r9/4L0Awq3M=;
        b=WstA5S1vlLYIE+W7thVPdGSl64y9ae7MV+JuqaMFj0hUj7OowkPDVFis7N96yIuk2O
         BjWg46u/wrVlcgn2Bdw+yAnhkJtAWrtvOetvJJauWYmSgP0mH8z9zOovrtVvtCEEmiRK
         rcufHlZfxseZd1ZSNTBkIP8sZi3p4fe8/vFDssv5VJo6fA/ZQLFlwFuCTfcuPhYsqeZO
         5evFSjZ8olS7TYaMmZVuA73qYqzuW5CCKByaCX6GTSDjclPCvgAcGaql/07Pope9AWF0
         mL5yWJE4mX3YKkmPbi4+GEqCbr0/+JEV35+wWkTOaLFkXrdahd6STr2FoQj3sQ0zeKNI
         QUDA==
X-Gm-Message-State: AOAM532qTxCI/JwI3jt7L2jl/q+qg+t5TCTM0w9G+7e0YvVIcCoZDoih
        gBgoociKnqzmmTCe5BCQ5kc=
X-Google-Smtp-Source: ABdhPJzPEQqmXQ00pmmZFv0cby/raM+OKnQekcJe8hkiA7Ti2V1brXbTnCBAmKv+WlBYiAQksXMqyA==
X-Received: by 2002:a17:902:d48a:b0:154:7a1b:5f2b with SMTP id c10-20020a170902d48a00b001547a1b5f2bmr23967091plg.52.1648441694087;
        Sun, 27 Mar 2022 21:28:14 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id o27-20020a63731b000000b0038232af858esm11317715pgc.65.2022.03.27.21.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 21:28:13 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, xeb@mail.ru,
        davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
Subject: [PATCH net-next v5 2/4] net: skb: rename SKB_DROP_REASON_PTYPE_ABSENT
Date:   Mon, 28 Mar 2022 12:27:35 +0800
Message-Id: <20220328042737.118812-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220328042737.118812-1-imagedong@tencent.com>
References: <20220328042737.118812-1-imagedong@tencent.com>
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

As David Ahern suggested, the reasons for skb drops should be more
general and not be code based.

Therefore, rename SKB_DROP_REASON_PTYPE_ABSENT to
SKB_DROP_REASON_UNHANDLED_PROTO, which is used for the cases of no
L3 protocol handler, no L4 protocol handler, version extensions, etc.

From previous discussion, now we have the aim to make these reasons
more abstract and users based, avoiding code based.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h     | 8 +++-----
 include/trace/events/skb.h | 2 +-
 net/core/dev.c             | 8 +++-----
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 26538ceb4b01..10ba07892c46 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -408,11 +408,9 @@ enum skb_drop_reason {
 					 */
 	SKB_DROP_REASON_XDP,		/* dropped by XDP in input path */
 	SKB_DROP_REASON_TC_INGRESS,	/* dropped in TC ingress HOOK */
-	SKB_DROP_REASON_PTYPE_ABSENT,	/* not packet_type found to handle
-					 * the skb. For an etner packet,
-					 * this means that L3 protocol is
-					 * not supported
-					 */
+	SKB_DROP_REASON_UNHANDLED_PROTO,	/* protocol not implemented
+						 * or not supported
+						 */
 	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum computation
 					 * error
 					 */
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index e1670e1e4934..85abd7cbd221 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -50,7 +50,7 @@
 	EM(SKB_DROP_REASON_CPU_BACKLOG, CPU_BACKLOG)		\
 	EM(SKB_DROP_REASON_XDP, XDP)				\
 	EM(SKB_DROP_REASON_TC_INGRESS, TC_INGRESS)		\
-	EM(SKB_DROP_REASON_PTYPE_ABSENT, PTYPE_ABSENT)		\
+	EM(SKB_DROP_REASON_UNHANDLED_PROTO, UNHANDLED_PROTO)	\
 	EM(SKB_DROP_REASON_SKB_CSUM, SKB_CSUM)			\
 	EM(SKB_DROP_REASON_SKB_GSO_SEG, SKB_GSO_SEG)		\
 	EM(SKB_DROP_REASON_SKB_UCOPY_FAULT, SKB_UCOPY_FAULT)	\
diff --git a/net/core/dev.c b/net/core/dev.c
index 75bab5b0dbae..d73b35e6aae4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5359,13 +5359,11 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 		*ppt_prev = pt_prev;
 	} else {
 drop:
-		if (!deliver_exact) {
+		if (!deliver_exact)
 			dev_core_stats_rx_dropped_inc(skb->dev);
-			kfree_skb_reason(skb, SKB_DROP_REASON_PTYPE_ABSENT);
-		} else {
+		else
 			dev_core_stats_rx_nohandler_inc(skb->dev);
-			kfree_skb(skb);
-		}
+		kfree_skb_reason(skb, SKB_DROP_REASON_UNHANDLED_PROTO);
 		/* Jamal, now you will not able to escape explaining
 		 * me how you were going to use this. :-)
 		 */
-- 
2.35.1

