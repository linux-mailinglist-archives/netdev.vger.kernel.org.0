Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5638D2CA45C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 14:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391312AbgLANvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:51:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387587AbgLANvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:51:41 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13EEC0613D6;
        Tue,  1 Dec 2020 05:51:16 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id o7so133917pjj.2;
        Tue, 01 Dec 2020 05:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vFAjt0Td72sO7ptEv+X075oaFipYTY8EyRS2yMR9YTM=;
        b=tJk6GaJhp51YrKMI15gFZm38aA0AEa/hBp+GQfP2sExI/CDMRLAjgeDI6kuU4YEA9T
         60cA8skJlYb/xRFbzO0HCmuEhu6lKuBS/o0ewaD8/4N47Vkmvi6UuPCMxdv76H/fa/St
         uRruhVohiKLmIZmahyfka3aLUBDjtxzf8jcBuWueGdmJ7hl3eZkuteG3ydlqBHXYiwog
         m2xXFrCQKMJ4lc5JTuS7htol4sTV/Uw2XIDTs5AiavwQeVTuMk6PE8EVlnEo1GS1szE2
         bv9SGJY4yg56FeOhxLIOTFoE5LfCMjPEbD7/fz3aUVgEKwhgo/UokhWsgoZspauAvBVZ
         Un2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vFAjt0Td72sO7ptEv+X075oaFipYTY8EyRS2yMR9YTM=;
        b=MxKb8CghFe3gq6tlt11ghgxsuZrvzJrka8xiQStN/hzXaWkpi+Oo8NfNjQ0VLkb9Yp
         KUdafdjZ7gDbqUq3DxAvboSXETjJFS1JfeU6Nh/mWjJNHT9CTEj7jnyf2I7nK1TK+/wh
         p8v+d6z1yAAWlPSMMZa610kY4cweUT9aqL7UilZVZ2va1iNfXXSTC0gNCai8+WSh6Iot
         Bqbc86bHmZkuSh+i/f0YCzabm0eudVr0ovRzk37l7AFaPJsJEI4yp3FQlWkjCTFMN/c9
         w3gEV4j0dpZFkEAS3V6tJdrBR3RzJDHJGo9f0Ms8ztOtWhdskkW0650xB/ydmgVhlXfH
         2/Hg==
X-Gm-Message-State: AOAM530J1D2FI/shuGGzNJGK6gngm3+M2ecEMTjSK/jK862nQYspMnKB
        VJH6qwlSJ9FOibHRTUwIcZvRC6Z4eZ4=
X-Google-Smtp-Source: ABdhPJwCr4UyKRdvt7pr28Ar1SSeym3Vk1swLm90oaHyk2ngvN/57V4Dps2eegHakDn9Pj/y98cSvg==
X-Received: by 2002:a17:90a:68c3:: with SMTP id q3mr2817394pjj.135.1606830671522;
        Tue, 01 Dec 2020 05:51:11 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id z22sm3134111pfn.153.2020.12.01.05.51.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Dec 2020 05:51:10 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v4 net-next 2/4] nfc: s3fwrn5: reduce the EN_WAIT_TIME
Date:   Tue,  1 Dec 2020 22:50:26 +0900
Message-Id: <1606830628-10236-3-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

The delay of 20ms is enough to enable and
wake up the Samsung's nfc chip.

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index ae26594..9a64eea 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -19,7 +19,7 @@
 
 #define S3FWRN5_I2C_DRIVER_NAME "s3fwrn5_i2c"
 
-#define S3FWRN5_EN_WAIT_TIME 150
+#define S3FWRN5_EN_WAIT_TIME 20
 
 struct s3fwrn5_i2c_phy {
 	struct i2c_client *i2c_dev;
@@ -40,7 +40,7 @@ static void s3fwrn5_i2c_set_wake(void *phy_id, bool wake)
 
 	mutex_lock(&phy->mutex);
 	gpio_set_value(phy->gpio_fw_wake, wake);
-	msleep(S3FWRN5_EN_WAIT_TIME/2);
+	msleep(S3FWRN5_EN_WAIT_TIME);
 	mutex_unlock(&phy->mutex);
 }
 
@@ -63,7 +63,7 @@ static void s3fwrn5_i2c_set_mode(void *phy_id, enum s3fwrn5_mode mode)
 	if (mode != S3FWRN5_MODE_COLD) {
 		msleep(S3FWRN5_EN_WAIT_TIME);
 		gpio_set_value(phy->gpio_en, 0);
-		msleep(S3FWRN5_EN_WAIT_TIME/2);
+		msleep(S3FWRN5_EN_WAIT_TIME);
 	}
 
 	phy->irq_skip = true;
-- 
1.9.1

