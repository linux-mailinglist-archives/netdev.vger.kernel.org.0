Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F2656B8A
	for <lists+netdev@lfdr.de>; Tue, 27 Dec 2022 15:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbiL0OIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Dec 2022 09:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbiL0OGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Dec 2022 09:06:05 -0500
Received: from mail-oo1-xc2a.google.com (mail-oo1-xc2a.google.com [IPv6:2607:f8b0:4864:20::c2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034552F3
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 06:06:01 -0800 (PST)
Received: by mail-oo1-xc2a.google.com with SMTP id 187-20020a4a09c4000000b004d8f3cb09f5so480661ooa.6
        for <netdev@vger.kernel.org>; Tue, 27 Dec 2022 06:06:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Pom8OQw8JaBhzmLN8gMTu8hbhxOCDcRGdrKAk6esY5I=;
        b=oV4KH7EKNLX2xCSe5Y7x2s5vYiFC7v2iEz07DqdQDZobCdtK9VF9fVvOPzhG/fjo6/
         sdWV0DGKL9+LhX0FbjeCGv3705HhXSULAyW9/wmyVM2A70T4Mgitmc3v67872S4QbXAo
         xoNEteEevC9mFBZvD8zNf+HXJGherjZuP/Igvt08Yhz/HABmtwvEVdm+3WuuGfd4Lm+0
         RhkY17Gfp617xklEyCZDLOJESe4bOI4lpoTZUEYodprwZvBtm//rJyyOuyJ23j9xDtOW
         z4HFeCO086qbZmNX/wv+GNJ+WhSjYg5LtjPzlN9232sssR7jLt9FCcdS4XVHqbpEHZN1
         OZ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pom8OQw8JaBhzmLN8gMTu8hbhxOCDcRGdrKAk6esY5I=;
        b=hg7KsrrJcSIVj5P9soTop2QAdZH1FF+UJvc75co0PY0SvSRCuYoJebuJD1mM2gKfn9
         PbbJUMFlKq/MBfCQBm9xYkMXk/eW065G8hpqmjIN1VGjl3FHV1asV1tqJl8zvH90zBrJ
         9O92lUInT4+zfOdyRQ3Nd7Dsx5iI7SuWsZkc/xHx2Hyfbvx3Ogr3hj4a7SVGcukdW3/c
         MfOdmuYxKTe697lG5tZUBMD1BXkq1yrt8OZ5wjgmr3Q3ou224s5+E75BdUykz0OSMxWN
         eXj802TG7ppk5Tn9WuAbrIXR9+S7tJ6+bjNsZK5FC3Hm8pPBWmalBMPD1wABeyzFL6ph
         pgPA==
X-Gm-Message-State: AFqh2kpFpp7WpL9cgJ0XTG7dkx1CCUq3mbewMlHhRbezwZovwZ7ORgdP
        +dVRjndsPyG/27eZcjB9AOP2DDjGkLUeO/SI
X-Google-Smtp-Source: AMrXdXu0BnH4jWBFT5jk5iXU+oEdMNy5AJUmkHYXw97g8LfKPg9P3lbDUwVD2ddE72VuLXiF3K22Sg==
X-Received: by 2002:a4a:ead2:0:b0:4a3:6701:52e0 with SMTP id s18-20020a4aead2000000b004a3670152e0mr10925270ooh.9.1672149959919;
        Tue, 27 Dec 2022 06:05:59 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:e4b6:5a8e:5e17:7db3])
        by smtp.gmail.com with ESMTPSA id a32-20020a4a98a3000000b004a3543fbfbbsm5235343ooj.14.2022.12.27.06.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 06:05:59 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, Pedro Tammela <pctammela@mojatatu.com>,
        Rudi Heitbaum <rudi@heitbaum.com>
Subject: [PATCH] net/sched: fix retpoline wrapper compilation on configs without tc filters
Date:   Tue, 27 Dec 2022 11:04:59 -0300
Message-Id: <20221227140459.3836710-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rudi reports a compilation failure on x86_64 when CONFIG_NET_CLS or
CONFIG_NET_CLS_ACT is not set but CONFIG_RETPOLINE is set.
A misplaced '#endif' was causing the issue.

Fixes: 7f0e810220e2 ("net/sched: add retpoline wrapper for tc")

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 include/net/tc_wrapper.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
index ceed2fc089ff..d323fffb839a 100644
--- a/include/net/tc_wrapper.h
+++ b/include/net/tc_wrapper.h
@@ -216,6 +216,8 @@ static inline int tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	return tp->classify(skb, tp, res);
 }
 
+#endif /* CONFIG_NET_CLS */
+
 static inline void tc_wrapper_init(void)
 {
 #ifdef CONFIG_X86
@@ -224,8 +226,6 @@ static inline void tc_wrapper_init(void)
 #endif
 }
 
-#endif /* CONFIG_NET_CLS */
-
 #else
 
 #define TC_INDIRECT_SCOPE static
-- 
2.34.1

