Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A734550845C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350999AbiDTJFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350895AbiDTJFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:05:07 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C6211A1A;
        Wed, 20 Apr 2022 02:02:21 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id t26so517094qtn.6;
        Wed, 20 Apr 2022 02:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vhnMKMxxIM9MnocI8Shooov6cZtMqxGrmupXbZBhm/0=;
        b=OXDxiTAZ1XfAGZy22k4cScKoop5HZXc+hLnYSQnHSX3KEsYJFyJorBqmh5r8M5dugp
         YzQ062hbdOd6JwBmQqMExHVz4Mu3tDqTaRd6a81G+o0+MW2OLMb1WLkIuKhJ6sn6rk72
         5xpV4zcLOLgfVhxzhzpU+tmEO/w7cNkxBosPgGN7zI/UkyhpgBgeA3GORRgh63NsgCAw
         f5epmo3hDsvGQBOLvXjblA48U34yMCeeD8Drj1zN7ZCOxO/I34qmKCw6L8UnErm8O5bY
         CphSxgUunyKYKQOuFcr1EMQiU9/RJH+m7Zaf9jDRVJhdVW0+oxCABX/7z47zWGyhtv1R
         EDKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vhnMKMxxIM9MnocI8Shooov6cZtMqxGrmupXbZBhm/0=;
        b=dLAEU8cReW2XNOeTife6YIMWks+7QUUkL9DuFP1TObhPJqLP7CYdcIu6l6iEy5IqGc
         OZysZeTxkISvzm1YqN8LX2m1Aou8AcP/uRfokCCxXmHfmnV98r8PWx7KE0rrsDtkFnyp
         GhuQv7svi1efCaWK+aypjDa8i/h7aJkuwCJ0GLNct/8aa4ivpK1FSB5qmDIqtXHa2n48
         RwGqWTiQMdLcZ+wUvW3Kf4nLuqaG2IH8bxQEOY93v25dki7UWCVaqBNjCrm9H3qmEePA
         nS4rBz8UC1c6yTrx/hp7FzwUA0Z5X1AjElj8H37Eo1mCT2U95Lc8mg5NABA4PgKQyeNN
         hF1A==
X-Gm-Message-State: AOAM530CUo+L9IE6idK8W/GEhb56Lg/vWjZ6oZh1/LrEoRoZfF/Wais0
        mzu7s0ukBUUvdy9Cee+uysY=
X-Google-Smtp-Source: ABdhPJzOX0QSEHG5ihv0TOKi3KOKVVVMZ+l8OPlk+L5RekhOftbIDGdhL6y8tvCE0Xxevur3ro+QQw==
X-Received: by 2002:ac8:58c9:0:b0:2f2:67d:9a87 with SMTP id u9-20020ac858c9000000b002f2067d9a87mr6579979qta.407.1650445340749;
        Wed, 20 Apr 2022 02:02:20 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id a4-20020ac85b84000000b002f340e3c703sm633800qta.41.2022.04.20.02.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 02:02:20 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wl12xx: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 20 Apr 2022 09:02:14 +0000
Message-Id: <20220420090214.2588618-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
pm_runtime_put_noidle. This change is just to simplify the code, no
actual functional changes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/ti/wlcore/tx.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index e20e18cd04ae..7bd3ce2f0804 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -855,11 +855,9 @@ void wl1271_tx_work(struct work_struct *work)
 	int ret;
 
 	mutex_lock(&wl->mutex);
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wlcore_tx_work_locked(wl);
 	if (ret < 0) {
-- 
2.25.1

