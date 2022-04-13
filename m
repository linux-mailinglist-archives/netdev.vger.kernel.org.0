Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEAC4FF39C
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234484AbiDMJg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbiDMJg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:36:27 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38B1C54199;
        Wed, 13 Apr 2022 02:34:01 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b15so1496613pfm.5;
        Wed, 13 Apr 2022 02:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJyC9faBxeD5dt69fcdS3xPg12cvBbSXq5CLmwRGfIQ=;
        b=Rxj6JbXGfpQYRiebK8FO12yU3ffiQCC4vmHHJAXIXJ1+lvKqRm2FQj56sxka1YNoJt
         Rbg6NAdZa/OjsMW2KXfx/u/eCEWGcJha56b+f0o1R607RDiGmnBpnwK7cHpcT8picWcW
         67Ly+SxIRs7hsSj8jrz+UAY7xps4jZRWuDrqvh48slHaeUwt7YKn5GJluwV8BN8mNM/J
         +LYwIqOUBezMJzmozUUkzl2NnImW0/yWIna6Ck8gQ6jG1UQzq8NX3YojFycCKThL+7B/
         IFTtf5xlm+6TVFg4Zz8QyuY7zGdI4RHPKfiPWT5LAlipxwxdwhJy6dWuJOcY/CxSDspG
         z19g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wJyC9faBxeD5dt69fcdS3xPg12cvBbSXq5CLmwRGfIQ=;
        b=Oe3agULkOwWXH1QX9K0SDTkx/IamNSgBBEEddIKxPRDCVYZiFX36w0mmWKp7VD3Op/
         ZZMzRyLDq0K9KKQsGmdK3JLTY2CyyHPI+MwI3WmBshAKXCWJ9ZemLULx9t1GGQNVy/fR
         dQslifJ4t+8nVf6ULxau3jjyfGEh9WcUCtkyDw5UMN1CBtHbhjFGFy12PSidybN/zCs2
         h64ziJt3iemTpHey9KjQpmgsaVOR5ff0eAHETFxJNHNgtcsOlCkQ1LxhqMaESvcW5gjl
         zd/WTgc429nxdls9yUa+Alm5oJuq0R/fzAUt1bRKXIUQg38OHcl39VXjy6hb0RE3niaY
         hw8Q==
X-Gm-Message-State: AOAM533L6QyI/NtMKy2FnmypvpT1ilAJKyVMJbtcAOdVEu/TPcQpxxJq
        VnhAZAWTMW8n7sHx5D300hg=
X-Google-Smtp-Source: ABdhPJyUGAiiEI9PqBPTbXZTU5A73S9WybFNDAAPL+x+O3xTRujlPFK0WSWU52Y2IqkhU1LQPxWdkw==
X-Received: by 2002:a63:e20:0:b0:385:fe08:52f9 with SMTP id d32-20020a630e20000000b00385fe0852f9mr34376466pgl.99.1649842440615;
        Wed, 13 Apr 2022 02:34:00 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id 197-20020a6305ce000000b0039da7039aa6sm3328607pgf.25.2022.04.13.02.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:34:00 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] wl18xx: debugfs: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
Date:   Wed, 13 Apr 2022 09:33:56 +0000
Message-Id: <20220413093356.2538192-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Minghao Chi <chi.minghao@zte.com.cn>

Using pm_runtime_resume_and_get is more appropriate
for simplifing code

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/ti/wl18xx/debugfs.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 2f921a44f1e2..80fbf740fe6d 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -264,11 +264,9 @@ static ssize_t radar_detection_write(struct file *file,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl18xx_cmd_radar_detection_debug(wl, channel);
 	if (ret < 0)
@@ -306,11 +304,9 @@ static ssize_t dynamic_fw_traces_write(struct file *file,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	ret = wl18xx_acx_dynamic_fw_traces(wl);
 	if (ret < 0)
@@ -368,11 +364,9 @@ static ssize_t radar_debug_mode_write(struct file *file,
 	if (unlikely(wl->state != WLCORE_STATE_ON))
 		goto out;
 
-	ret = pm_runtime_get_sync(wl->dev);
-	if (ret < 0) {
-		pm_runtime_put_noidle(wl->dev);
+	ret = pm_runtime_resume_and_get(wl->dev);
+	if (ret < 0)
 		goto out;
-	}
 
 	wl12xx_for_each_wlvif_ap(wl, wlvif) {
 		wlcore_cmd_generic_cfg(wl, wlvif,
-- 
2.25.1


