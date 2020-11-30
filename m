Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1C02C83C1
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgK3MDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbgK3MDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:03:14 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2B1C0613CF;
        Mon, 30 Nov 2020 04:02:49 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so10277096pfu.1;
        Mon, 30 Nov 2020 04:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Hlu3v+ZFJOSkIPaRs/ikcCBt9YqRCc7L3x2QFe+kevY=;
        b=X7TJxOUVStq0aYMXo56iVGChzK97jthX3WKRB3TJEdnWe0UNNbhFbeT33zeCXSk/5K
         QWYRc2h5MLuNjshDlRCIxrEKTlENF6/G8VMY4Zfz5hP/fRankxzbhx/12Mg4JC9x6OD3
         svg8AbojYWU4jRU5Xer63Y3qn7HKnvfkS49m3jrkR04qyqDC6alAwvp6YzzWuOMXI0FN
         7PqG0+xIYasvWXJrVFVm0DXqu1L4W1UudEshpSeJGgApVmnpyO7Vlodk6f3nlPHMpANZ
         0fnbncL/Nt/U8AEhie6X1lVx6ECQfRUeRpgTdBk6HBFzXxpXBXjt/TxVtTgxJMnmgHJW
         ClNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Hlu3v+ZFJOSkIPaRs/ikcCBt9YqRCc7L3x2QFe+kevY=;
        b=ueRXIi4hsRLTa8yzju/I+oijBIB4S+Umm3Rq1vJy7Nuhg0CJ5Vcj1ZVgBTa7hO42sq
         mdfSiO6YbifWtZPeKPUSkZ4dpYvkZ2MycNdK3ki2s45gSv5W3V5dhw911LKC1LywE+7Z
         ak9bl+lghz1x5u27J6ycSkal1cH3/a/tsmNrURUvVCUSrx26NlmJCxo0D3L7/dCopZaQ
         Ix66Wau4ZVNKViU2a0dB+DdyWX+5pYBKYI8cUHAr3TYmnOzaVxSpH5RLJSVdDq6hhav5
         srqgS2XY8WTkg2h7KSQ/HWDidl3bTDDtHdC7wbaGfnrnjWAOEE7esT+8vmFmamG4jygL
         fOuw==
X-Gm-Message-State: AOAM532gTDzor5In63EL6boWwGMyTglZsh6CsMAn9FJrq3FvATfb4FkE
        MNwcRWnDm9v+Ex05uDca6p3vRhWBJLU=
X-Google-Smtp-Source: ABdhPJxVjfr4ZJSerSeBSzVuIwupCdXcbfDHqqe8dbotpgNpJvQ1sHZycjiWgr+fPbQ6LYTGoiDCFQ==
X-Received: by 2002:a62:2cc3:0:b029:197:dda8:476a with SMTP id s186-20020a622cc30000b0290197dda8476amr17836923pfs.37.1606737768884;
        Mon, 30 Nov 2020 04:02:48 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id cu4sm2938023pjb.18.2020.11.30.04.02.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 30 Nov 2020 04:02:47 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next 2/4] nfc: s3fwrn5: reduce the EN_WAIT_TIME
Date:   Mon, 30 Nov 2020 21:02:30 +0900
Message-Id: <1606737750-29537-1-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
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

