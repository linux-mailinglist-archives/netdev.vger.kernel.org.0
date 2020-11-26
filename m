Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2278A2C585C
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391416AbgKZPfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731552AbgKZPfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 10:35:13 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DB2C0613D4;
        Thu, 26 Nov 2020 07:35:13 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id n137so1944696pfd.3;
        Thu, 26 Nov 2020 07:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hlu3v+ZFJOSkIPaRs/ikcCBt9YqRCc7L3x2QFe+kevY=;
        b=rKRfOh+eodDYnH1rgBvoBHPJmuz0A1hhdXjxxyIFYgBezcTeXKHiUQPnPF2mn0EdAq
         fmYZ9B4jum9FhUXYqAd8VoZCRy7jTZSDNNBxSI6rXVwY6WLsmp4MGtaI9LLZAUs/IJjK
         HCNZYwa8KOA6dgQCSksaIigeOJ0uQBfyEmZfj4AF/bQorqJtLZsDFc0nbnIMYCafj7/W
         k4ItVoV0has0JYebVsnSsWdzR4tzyy1Ku4Y5j+odzA0CHiim8FscR9NB0pcUv7h+QPnV
         pJZBLbNLrdMXu+fzpxuQzeJvE0DsZ4zvlEKVmlVzSO0NxxCkjthy1Z/Rry3B+1PZWwoR
         gdrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hlu3v+ZFJOSkIPaRs/ikcCBt9YqRCc7L3x2QFe+kevY=;
        b=BQza2rfQzHgIiExS6Fd+glksrOG523+bDYW082sWCKKdSRXqerivXJFJI5QDpHoQbd
         4MptfXiUcZirrCNfvliflQdDiYpf7Lgzbt7pE/CVAVYMTM+Z4cPb+Hyj8Y498f6Opwwc
         9/JSx7NKZNjFi1h0IMxDEGtDn2moARfVezlRN4EOwa5eiszmID12/FD748l7StW2ONCr
         N5fHmbIQqWMlLyFkI4upTQ8FJFjQIJ5uBzq7we1IHwmsGbt9HjljlUcHoNM9kTMU3VJv
         DL+g4/YNnek09CP0n8SNzg/4UgMzb8CjDXAWB57znvpS89V533kOk4PjXD0jjthKnmTm
         aVAg==
X-Gm-Message-State: AOAM530vYbgVbKV2zM3oINnKbkn3NuH1AI7Fn+q6Hey0OVuYaooO2xn7
        mkak39+CDd6X33Qmf92w227CrqhTmf8=
X-Google-Smtp-Source: ABdhPJx5IMqTGO49naTZkLoLYrSW4kmnK1pxbor17shzOO5yqhgBFdGZzUBhUJykdH35TpHZL9FKrw==
X-Received: by 2002:a17:90b:3753:: with SMTP id ne19mr4197437pjb.148.1606404912911;
        Thu, 26 Nov 2020 07:35:12 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id g6sm6506481pjd.3.2020.11.26.07.35.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Nov 2020 07:35:12 -0800 (PST)
From:   bongsu.jeon2@gmail.com
X-Google-Original-From: bongsu.jeon@samsung.com
To:     krzk@kernel.org, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next 2/3] nfc: s3fwrn5: reduce the EN_WAIT_TIME
Date:   Fri, 27 Nov 2020 00:33:38 +0900
Message-Id: <1606404819-30647-2-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606404819-30647-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

The delay of 20ms is enough to enable and
wake up the Samsung's nfc chip.

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

