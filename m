Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB08B4FF275
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiDMIqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiDMIqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F45E50065;
        Wed, 13 Apr 2022 01:43:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso897413pjv.0;
        Wed, 13 Apr 2022 01:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TjCHnWvl8314BhFvZchJFv9nGn+6Q04JfjDjral41gY=;
        b=cuC34s3QX+NGa/jd5bEQk/CusqHzpL4LfM+Vr+iVdL3ofwFP9iJrGp1YRLkNEV6quh
         TWC5pkh8J8wu84JYWV+g+gTLIG+xHJFkibo+3QXI48gaozhONnFAhMeSOZNOdDC/k+tB
         YZfzKgP8iYR65v4Sb2cERt2+YPpYsm6FoxSXiIuiYuKD3/QYpZJ+VdxwVXVUDpAQBpEA
         w/RMSSIm4T6gauVxzrJa+4UfMt3aKgMvOOSJaf40hkrURb4GLDtkk5B7GFZWki/0eBCd
         r9/y4Tc9LnWv3xSjxcazBEZnUvGYehUT92rVNNz0tn1TIOKM5AHd4y626R1RmS90IdpB
         9DoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TjCHnWvl8314BhFvZchJFv9nGn+6Q04JfjDjral41gY=;
        b=gwtudifP0w0Miq/xQczRg1U3aKcOiI2h6cYGJZsXcocH7+PUPNmGJOWfizcU7U5Dpd
         ttp0lXcJJ1l/WjIPxdiNdpzylo7izoJ4CbyltXGClWyRgPesP1xt4XTbEyeliIL3/eZC
         FknY8ynJpOhXnjkSEylPOEwDId84m0XcXhCCGtPJPdAv0ZO6GdFcEHv2iCHmqZQMNvVT
         sW6e377qL58c8H+M3Q8LiDm+8p0UVi2aVqNMPIU0cX7AFLKWwKXrGCl0CNwkILwSETfC
         UP/rkocBF1CXXirEo/YgQurI0smPIGxnVTC6iwkPEpKb23yuX5LJbXZLwWoZQAfIgpFs
         LkSg==
X-Gm-Message-State: AOAM5329tOhlpyOgOAd0trvK0uttdahnBveREQAyPcn1OdSjgG8jP87E
        K+pdBhslci6xn2DAMY9srjc=
X-Google-Smtp-Source: ABdhPJx2SA8KHzlAA6LuVC8RBDF9+4OXOIS80+Ua1E1Af8cUa5OrW7bik6gDEnHUFyse5JRFv9/8Vg==
X-Received: by 2002:a17:90a:a78d:b0:1bc:d11c:ad40 with SMTP id f13-20020a17090aa78d00b001bcd11cad40mr9526152pjq.246.1649839432713;
        Wed, 13 Apr 2022 01:43:52 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.43.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:43:52 -0700 (PDT)
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
Subject: [PATCH net-next 1/9] skb: add some helpers for skb drop reasons
Date:   Wed, 13 Apr 2022 16:15:52 +0800
Message-Id: <20220413081600.187339-2-imagedong@tencent.com>
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

In order to simply the definition and assignment for
'enum skb_drop_reason', introduce some helpers.

SKB_DR() is used to define a variable of type 'enum skb_drop_reason'
with the 'SKB_DROP_REASON_NOT_SPECIFIED' initial value.

SKB_DR_SET() is used to set the value of the variable. Seems it is
a little useless? But it makes the code shorter.

SKB_DR_OR() is used to set the value of the variable if it is not set
yet, which means its value is SKB_DROP_REASON_NOT_SPECIFIED.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 include/linux/skbuff.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9b81ba497665..0cbd6ada957c 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -450,6 +450,18 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_MAX,
 };
 
+#define SKB_DR_INIT(name, reason)				\
+	enum skb_drop_reason name = SKB_DROP_REASON_##reason
+#define SKB_DR(name)						\
+	SKB_DR_INIT(name, NOT_SPECIFIED)
+#define SKB_DR_SET(name, reason)				\
+	(name = SKB_DROP_REASON_##reason)
+#define SKB_DR_OR(name, reason)					\
+	do {							\
+		if (name == SKB_DROP_REASON_NOT_SPECIFIED)	\
+			SKB_DR_SET(name, reason);		\
+	} while (0)
+
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
  * buffers which do not start on a page boundary.
-- 
2.35.1

