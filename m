Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89834F75E0
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241001AbiDGGYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241006AbiDGGYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:24:05 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CEF817335C;
        Wed,  6 Apr 2022 23:22:06 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gt4so4678468pjb.4;
        Wed, 06 Apr 2022 23:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//KZ6YHhys1mLVWKPMFh1+e7V9mc1xx+r9/4L0Awq3M=;
        b=JCzxspGLnoO/gWqkguN6ckSzcjztc5fY16WYZoRzyWFIzDhL8KXlOFWDM9MR42vo7/
         RJbAlNWFPg4ema/EFN29NAn4CWgYNmBkaIemdYU+IgnyyqNdj/pDuK9f6DOD10GpX6JY
         YBs70AZekvg1GEY1CC8MN1nXz3uAWTc1XnG1Mu2aVRqoxCM5O3Nom5ZTX+Qo9wSGVAhJ
         itxWLNyXP8uJ1T1XJUNGvHj52Kai6wHlVAMbfgQY0ylfNr7D/1PU8Gc1uLR0/OTm/thq
         HZd/y9gIxdxKc50M/dRXUUBx/vLf0IeOATfKwH/tgGzTraVaawElhBOk8erC4RdwL7ha
         fLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//KZ6YHhys1mLVWKPMFh1+e7V9mc1xx+r9/4L0Awq3M=;
        b=q2VjfOlgNjaYUoml4V2MJ0VSj4EhGsyMeGiDsxR1cq+pRN3J7L8wnT4XGrSqQMiTPc
         bNht+VH5WlDqYOp324akygWS4fEhSfyzPnx6jgO7j9yo3MPkUMJab358pfxslBoiQPRU
         8el8LK+FOfh+8WsqhJis4M0aD+LHZjqba6mpfeDZUlMweiDobQOxcaTzIZM2bNDlMM4B
         JiqPtD4hR35BOYNTwDngP+eDRKOErKdhA9fBMcPoEb2tToRpL/idruQ9sJTJS1lAArrO
         z4r5rd0dQh4rVYrtr0zQGGrv+TO0++gjfc2Mt12ISLmfzNAa8pb8f6Im5ExoHGqqQVym
         h29w==
X-Gm-Message-State: AOAM532USsXkcGL7wkRQZGC1UsnD7eR3HBZeEwolvhHfabLCexcINAV6
        d1vVMRALGGOO1VxPKOCO0bM=
X-Google-Smtp-Source: ABdhPJx2bs5VWR00T+NLUxXxO3g8V338nWdiIp9YK8U6oNn5LdkhOw84v3lt0p7hlZMlwFYDSnm4HA==
X-Received: by 2002:a17:903:244b:b0:154:2cb2:86d with SMTP id l11-20020a170903244b00b001542cb2086dmr12160340pls.123.1649312526024;
        Wed, 06 Apr 2022 23:22:06 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.gmail.com with ESMTPSA id k92-20020a17090a4ce500b001ca69b5c034sm7522829pjh.46.2022.04.06.23.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 23:22:05 -0700 (PDT)
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
Subject: [PATCH RESEND net-next v5 2/4] net: skb: rename SKB_DROP_REASON_PTYPE_ABSENT
Date:   Thu,  7 Apr 2022 14:20:50 +0800
Message-Id: <20220407062052.15907-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407062052.15907-1-imagedong@tencent.com>
References: <20220407062052.15907-1-imagedong@tencent.com>
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

