Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A628754F4D3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 12:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381535AbiFQKGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 06:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381527AbiFQKGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 06:06:05 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A368169B49;
        Fri, 17 Jun 2022 03:06:04 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id z14so3703315pgh.0;
        Fri, 17 Jun 2022 03:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=toFzfxDcNAOLYWQB4b127Zf224IUbbcInL430hwlC3I=;
        b=m/K/ZcQRryr4Xlr0v5REGMR30LJwzC3O2GyiCJp08cqaWP1Y0T54zISfmUVzBjRJt3
         /SKm2oKX5hi5JnVgpK+7azQzzFgG60oXsGQEUZhUnE8urkg+1yhq5B+eYXkz/9ZxhD2U
         FzRuGLTOMRZOpYBRXXuZKqNcFpLkZLcfEHN/gvo8iRWkXvTy6+vKye74zXOpSuDyQu9k
         BCsOgO+tQgAiba0xv2X/n9sl85XQKDHv+Le578OWBwZmeglM+ZoSue9RpdOwCxXv6VWF
         lRLopjiaCiPqFZCBU9fG9YLshapwxMU/2OWVOJLFhSl/QbzSkL89LNf55qFsq8n7I077
         Ba8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=toFzfxDcNAOLYWQB4b127Zf224IUbbcInL430hwlC3I=;
        b=cnTHTL/33UKnnzAjgtJ2zG7eL/veQonwyh5BQL8riI219Yt8H0SqLwX/TcORuPyZXP
         +/0i9eLqlV1C4rigSphGOew9HgbWx4WW/kYkwb2KAJU0aqfxwgO72hXPZ0t+ghvIrQeR
         ft6rpGGtNSC4g0bP0J9jVM0aEAEUVCLpMl0uD335wh5oKvmvYzX7nmx7Pdu98NXfzFIn
         GX6L1IEg/zLNRXkQaJPGX4kQJsj5FTpMdXD+DYXHEHHPRQRoY4+VkXg25EEcuMmCFrxm
         RZYXuuT9E2lhXMRmj6vBzrgN/xoiAmrjFbOBFw8vLiK1c5FBiIAVJFuRBojeN/xayBEB
         jQhQ==
X-Gm-Message-State: AJIora+v+S6CjbFx54wOTdnKLv1En61O2etwonhIigyzi1OyCwfRUG1t
        WNdOs4suZA2wdQashJ4ibA4=
X-Google-Smtp-Source: AGRyM1uYaxI5XhllOVt2OFUzd4dcRE3gABnJZUQV1e5tLsQ+Kf6ppgHA+qzSuAuFslUsZq+R1101sQ==
X-Received: by 2002:a63:a749:0:b0:40c:57e0:86c0 with SMTP id w9-20020a63a749000000b0040c57e086c0mr1422414pgo.265.1655460364127;
        Fri, 17 Jun 2022 03:06:04 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.10])
        by smtp.gmail.com with ESMTPSA id h10-20020a170902f7ca00b001621ce92196sm3126210plw.86.2022.06.17.03.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 03:06:03 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     edumazet@google.com
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, imagedong@tencent.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Hao Peng <flyingpeng@tencent.com>
Subject: [PATCH net-next v4 2/8] net: skb: introduce __skb_queue_purge_reason()
Date:   Fri, 17 Jun 2022 18:05:08 +0800
Message-Id: <20220617100514.7230-3-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220617100514.7230-1-imagedong@tencent.com>
References: <20220617100514.7230-1-imagedong@tencent.com>
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

Introduce __skb_queue_purge_reason() to empty a skb list with drop
reason and make __skb_queue_purge() an inline call to it.

Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 include/linux/skbuff.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 82edf0359ab3..8d5445c3d3e7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3020,18 +3020,24 @@ static inline int skb_orphan_frags_rx(struct sk_buff *skb, gfp_t gfp_mask)
 }
 
 /**
- *	__skb_queue_purge - empty a list
+ *	__skb_queue_purge_reason - empty a list with specific drop reason
  *	@list: list to empty
+ *	@reason: drop reason
  *
  *	Delete all buffers on an &sk_buff list. Each buffer is removed from
  *	the list and one reference dropped. This function does not take the
  *	list lock and the caller must hold the relevant locks to use it.
  */
-static inline void __skb_queue_purge(struct sk_buff_head *list)
+static inline void __skb_queue_purge_reason(struct sk_buff_head *list,
+					    enum skb_drop_reason reason)
 {
 	struct sk_buff *skb;
 	while ((skb = __skb_dequeue(list)) != NULL)
-		kfree_skb(skb);
+		kfree_skb_reason(skb, reason);
+}
+static inline void __skb_queue_purge(struct sk_buff_head *list)
+{
+	__skb_queue_purge_reason(list, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 void skb_queue_purge(struct sk_buff_head *list);
 
-- 
2.36.1

