Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9055288F6
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 17:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245358AbiEPPfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 11:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245377AbiEPPfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 11:35:04 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4463C70F
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 08:35:02 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s14so14785278plk.8
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 08:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nQV1lOCa8nRCkjiSZ70mDrFzaNeJ1vTjfkm8nCwmL+8=;
        b=f9K8VUa725wNysQcyiHZdMJx4Ks6OegGjN8Qrej9M3MTEMRt/9EGTN5GBp3Ve3Flgz
         c44tmafcmA9h1EkS2OZqYck+mMQcT2eOrmSPWFrtJv+aQhUovw/QD5A5+WYIFJZwDwAO
         +JRuY4nde1drcxCFFmYkyD1jot2YONBfk0rj9NSWwDNn1LQ+7NffOX6LRibvOKo7yCGz
         4YVRvk6TKam209w8kXcZeft/Niwfn95Q03ZbdKlQVs7ztS7FEqkZ/EKcaG1OBjk1lcuE
         7H09JfFDBdF4VBkbYwGPrvjSmBraUFr6BMwWAT73N7pfCS36rwWw8K0oHDirIamX/rR4
         i2BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nQV1lOCa8nRCkjiSZ70mDrFzaNeJ1vTjfkm8nCwmL+8=;
        b=hRWSq7vtY/Yt2sGbMjnHn7ZvOHlWQKekdRnwJ75x90CeyJxFmx8LUC/97WmoMVXbNH
         Z4be77V+kCbx9Ztjjtlu20bSQk+Saxlk/mE/a07v6ru4tdoSJVzmUHe1AF8oZhuJRfev
         RuCWkc3ih4VA+PFbgjTmkPXNgbc7c4Ad7af/P6tDtGMJ84Y/AjvTobMgUiBStVEd6W+W
         VFmSrYYN7galt12vlzbCz+qSQ3wssOYIdEDw21HTn8vYSP4DIkMXbba/bbJwO4CXU7nn
         qx7O7DI9WJBjNrtzw6EnnBJOk+CyU6ZPkPtUdgvZy04YXBNqC0gA2rRdrjJw+tRkTdsU
         ywNA==
X-Gm-Message-State: AOAM532myArWLy1GKxXSc8ot4p+adVe4H0GBXns4a+1gwvX1s65/9jnT
        eOqfOcs7qfXDaRvTkoyCI38=
X-Google-Smtp-Source: ABdhPJwVXa06JYVqCreKyXtLwtOwDkTAK813Ba4yEtkr6veAQndgbGDLo0F6Z3BPsStzJGUW/9fwPQ==
X-Received: by 2002:a17:902:eb90:b0:15e:b55f:d9c5 with SMTP id q16-20020a170902eb9000b0015eb55fd9c5mr18314037plg.33.1652715301963;
        Mon, 16 May 2022 08:35:01 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:62e3:4412:6223:32c2])
        by smtp.gmail.com with ESMTPSA id r8-20020a170902ea4800b001618f5186f1sm1547635plg.80.2022.05.16.08.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 08:35:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH iproute2] iplink: remove GSO_MAX_SIZE definition
Date:   Mon, 16 May 2022 08:34:57 -0700
Message-Id: <20220516153457.3086137-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
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

David removed the check using GSO_MAX_SIZE
in commit f1d18e2e6ec5 ("Update kernel headers").

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 ip/iplink.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/ip/iplink.c b/ip/iplink.c
index fbdf542ae92bf1b9a7cb60f6916347870709cb48..c64721bc6bceb57ede26209269e79853fb997aa1 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -35,9 +35,6 @@
 
 #define IPLINK_IOCTL_COMPAT	1
 
-#ifndef GSO_MAX_SIZE
-#define GSO_MAX_SIZE		65536
-#endif
 #ifndef GSO_MAX_SEGS
 #define GSO_MAX_SEGS		65535
 #endif
-- 
2.36.0.550.gb090851708-goog

