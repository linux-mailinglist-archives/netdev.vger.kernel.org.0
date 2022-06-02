Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C066D53BC51
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbiFBQTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236857AbiFBQTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:19:06 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7547466AE2
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 09:19:05 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o17so4907725pla.6
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 09:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v7haQdok9coGoBH/EHypawu9uqZLEMnEJgP66s9Q60I=;
        b=CQK+hsqS4vLpYpgAptw5ioqzbrtyt8l5SOIQYZJBdFLvCgd4I/JVHBa3y29wvwRLxW
         B805u0CyEWeLuI9uIu3vH1PI468ElW5EX2sttHDZVM/uOm+dhoCHuuleFIJbFlvK1Mpu
         xohU40qoWmlQvC30QJYg3awDYU6lu7nFXCLwq+RBUkiWP5Ags1TM9wVGeVKm0XzgU4F1
         M+ZLq2jgKupgFgQyY5nJS2WsLR7/a1Pg1/xsElgb7aQqH2iKbEjK5vDgSxa1qLaibViw
         BTP7ODfbcYb/tr3zCMjyaGp5uWEjF4h30u9isPsApYOrgAwuyfT+jPS0SYXMKtcE+vfP
         YcPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v7haQdok9coGoBH/EHypawu9uqZLEMnEJgP66s9Q60I=;
        b=RbyKM7T3MOgDV7N7qn8vr1lKAz0/ZwjTVmwDk2tPc61FSBDyvV4xakegtXKt8/a6+H
         Cz9t3tRrquvLxW/pCcGwZ+p5+yeCe86kNb69d40VvO4kq0Sk3rYKUoF2DRYqbONZTirL
         hkaWR9ok1SWFxxdADcm1CrManMlYCGA8H2oYsf7iAzsLD4Lr2NoYdZucVmofMpUDmA9e
         Bym3mIoxVWDDTOtWMjmKpxuVp7eZadux4Q+Urr8HkQNiG7T3+iuz0umezkyEbclBmPkC
         lWot5tshaadRhPRiqBlJjK6Sjkd2AVoU6MClyryVXeZfOk5nA0kM+Yk92fGpt2lDmoQW
         NIiA==
X-Gm-Message-State: AOAM532YVhF1ykrUgKbse0HgVIWtSvevAlDJUy0d5MDP2lSnHLgsoL3O
        QUEY5ZAfqsjbDh6IWhV9+6g=
X-Google-Smtp-Source: ABdhPJxJY3cwNwAD39WreA6COGbrBESyxLkjp6O864VSUtjcboU87avq5sIjNW47HwlENyIOsP79qg==
X-Received: by 2002:a17:90b:4a8c:b0:1e2:f378:631d with SMTP id lp12-20020a17090b4a8c00b001e2f378631dmr6058116pjb.58.1654186745035;
        Thu, 02 Jun 2022 09:19:05 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:1ff3:6bf6:224:48f2])
        by smtp.gmail.com with ESMTPSA id u25-20020a62ed19000000b00518895f0dabsm3751072pfh.59.2022.06.02.09.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 09:19:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net 1/3] net: CONFIG_DEBUG_NET depends on CONFIG_NET
Date:   Thu,  2 Jun 2022 09:18:57 -0700
Message-Id: <20220602161859.2546399-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220602161859.2546399-1-eric.dumazet@gmail.com>
References: <20220602161859.2546399-1-eric.dumazet@gmail.com>
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

It makes little sense to debug networking stacks
if networking is not compiled in.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/Kconfig.debug | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/Kconfig.debug b/net/Kconfig.debug
index a5781cf63b16b32e5360df1ca26a753b6505d81f..e6ae11cc2fb7cb90e6a0c063d2135ee1839c3ead 100644
--- a/net/Kconfig.debug
+++ b/net/Kconfig.debug
@@ -20,7 +20,7 @@ config NET_NS_REFCNT_TRACKER
 
 config DEBUG_NET
 	bool "Add generic networking debug"
-	depends on DEBUG_KERNEL
+	depends on DEBUG_KERNEL && NET
 	help
 	  Enable extra sanity checks in networking.
 	  This is mostly used by fuzzers, but is safe to select.
-- 
2.36.1.255.ge46751e96f-goog

