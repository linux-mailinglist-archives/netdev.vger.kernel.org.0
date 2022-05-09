Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ECF35204FF
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240439AbiEITM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240404AbiEITMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:12:53 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89B02C4F51
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:08:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so182376pju.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 12:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aFBfcNcwAbGF/DTqoRVJfp+d5dgsrm0osd9T3/yAeF4=;
        b=M1GY3FHSQCSEfoaUyeFPHYf7YZmDrFg2adpCpQtP8MnUkADXBqBtE6tIiZtdj1rcPv
         tE5Z8Q9FqqS5Rv2KoKMRgBq1Ivf0fRbKn2XtaMlwdPiVY6s7Cc81BK1X0eJV3TyhGxRD
         cfNrCfqaxXEz/b+R5V1EfLbPh0X77lXWpiCegLnQKJcRLKlIdX8dngkZDWpx3ZpHrsYl
         lp0d8o0vTUYVf/e/OPHaFPkluHs1oVGgOeF9cz+N3LFgzGOMYp2LmiCgWkOzfCIqdVH0
         qYpPXI65ghM8Mw+O9MCiqKmLKjdASgkbyETlJ7JvSXMeOKwXZ2WwQKWE6rSZIhUHHYd6
         JBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aFBfcNcwAbGF/DTqoRVJfp+d5dgsrm0osd9T3/yAeF4=;
        b=uQAbUkBJj1yxiYw5tL+4nLH1JhDNOfhIfM2B7wDOOfG3zshtYhJ2ha4bT4WOaFmVmF
         KV8OWKeWOMmCRbtKSM22RLIAhc2LRqQi4tUcr8WppMO3dNoJtcgvKHfj/eXlU3meV3da
         qG4VRhAM4Aq8srR50BhuV2AJ0oYKhRrQ60HCjAGrY83aczbU9RYC1kKbnXUYTkRqyoUI
         Am9rhuSOaQzue8j9VYRJzVq2aqFnuH3dWZinOudOrh65D5rS+tiZldUUbwseZ3fkRZRE
         SR+/BCQgHcPbgur2DW2Ox5wXbCFConkgTD9/9eRzAuyNP9gzuW1oEwwoWwNELKGQQJKP
         vTAw==
X-Gm-Message-State: AOAM530BcUlwpkqBGHOBt4BKCLvUdJKw+vaGe08x1nQCnGoyYsS1ODUv
        Rp+G/Hjxt1kHJ4hyDj/urTY=
X-Google-Smtp-Source: ABdhPJzywUH1E2k8OHwDt+EjSB+FvW9Neqz9XTIhlsP8KbEk69RrMZA5j0qVRX9Q3RwsfjLi908/fw==
X-Received: by 2002:a17:90b:3649:b0:1db:a201:5373 with SMTP id nh9-20020a17090b364900b001dba2015373mr19380820pjb.175.1652123338413;
        Mon, 09 May 2022 12:08:58 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id a6-20020aa79706000000b0050dc7628174sm9032631pfg.78.2022.05.09.12.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 12:08:58 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/4] net: add CONFIG_DEBUG_NET
Date:   Mon,  9 May 2022 12:08:49 -0700
Message-Id: <20220509190851.1107955-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509190851.1107955-1-eric.dumazet@gmail.com>
References: <20220509190851.1107955-1-eric.dumazet@gmail.com>
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

From: Eric Dumazet <edumazet@google.com>

This config option enables network debugging checks.

This patch adds DEBUG_NET_WARN_ON_ONCE(cond)
Note that this is not a replacement for WARN_ON_ONCE(cond)
as (cond) is not evaluated if CONFIG_DEBUG_NET is not set.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/net_debug.h | 6 ++++++
 net/Kconfig.debug       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/net_debug.h b/include/net/net_debug.h
index d8769ee7bced92decf126fe6c521db75e458565c..f972ed3766a157f3f4de958fb6d4789dffc2923c 100644
--- a/include/net/net_debug.h
+++ b/include/net/net_debug.h
@@ -156,4 +156,10 @@ do {								\
 #endif
 
 
+#if defined(CONFIG_DEBUG_NET)
+#define DEBUG_NET_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)
+#else
+#define DEBUG_NET_WARN_ON_ONCE(cond) BUILD_BUG_ON_INVALID(cond)
+#endif
+
 #endif	/* _LINUX_NET_DEBUG_H */
diff --git a/net/Kconfig.debug b/net/Kconfig.debug
index 2f50611df858911cf5190a361e4e9316e543ed3a..a5781cf63b16b32e5360df1ca26a753b6505d81f 100644
--- a/net/Kconfig.debug
+++ b/net/Kconfig.debug
@@ -17,3 +17,10 @@ config NET_NS_REFCNT_TRACKER
 	help
 	  Enable debugging feature to track netns references.
 	  This adds memory and cpu costs.
+
+config DEBUG_NET
+	bool "Add generic networking debug"
+	depends on DEBUG_KERNEL
+	help
+	  Enable extra sanity checks in networking.
+	  This is mostly used by fuzzers, but is safe to select.
-- 
2.36.0.512.ge40c2bad7a-goog

