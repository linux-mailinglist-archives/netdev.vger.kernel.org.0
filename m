Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444BB2D0F8F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 12:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgLGLiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 06:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgLGLiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 06:38:52 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDA4C061A4F;
        Mon,  7 Dec 2020 03:38:50 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id f9so9028820pfc.11;
        Mon, 07 Dec 2020 03:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XxtvTDPqeKzw9+arch/biJr3gHkzLW6Sc6rv2JJ52og=;
        b=GnXaRsOBlcVJUCF6XZaheOLdwpQ1sHcjNRiMo5X3Gzh+1LK7Xr6QxnnivrArLZf39L
         ni/jLzLcicSny/FaLremq2uY3Cv+6NAmidBRI+2q2COxMqajrmk4vObo9uPXKyj5kF/d
         S6Ipmec4HHEyozpu5QqOzl+P24iAkqZ4maHllbT4oNlgqINEc7y5tkX9KglbCS3De04f
         2elj0ztJRz7Z7gpoiFh5ZB2IPKNyPF88dRWAjqNUp/XeKsugCkIM78hxWJ+tt2W7Kpdg
         EfbbQUAc/spsk3Cw9MASuAR84NnUU6XoqkyhATEn/udNappWmOyMeebJmI5Yf16u/IuG
         IMCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XxtvTDPqeKzw9+arch/biJr3gHkzLW6Sc6rv2JJ52og=;
        b=AQ3p4R/3eH4PCWm7ZQ/DwR7IZE4ZnafZQ6Knxnzh5EaqjQTPr7ZPxaf1GNfLVsRtfc
         Uj9W2+hKvTDI0J23D0jUUSVmykkdwn4hcxufpgTk29rNKX54NcNVaXgotrsBW6z7FxqI
         EYYaXNFW8/fplrCKu5RkteU52RTG30S8vsJkg17SUlm7RaDGaypYdyLNAeqSaHT66YiB
         8AZZ6XKZssh8qyYhEKvAvuYQ+BfUvz/GRBccrgccsIsAcGqv622Or0J7j5u2uU0slKzE
         mj0qZIJmWMj457jlIVaTcFeWjLqMDg2eSRgcdAOxrn1fiBh+sTEc9LowlGmdAVfvosyF
         UGDA==
X-Gm-Message-State: AOAM533yo7BjBIW9TIc5krkbCBSls/qkcHvS6BOcor/VqH3jqer+wrAd
        JcXYXKpJ97mgot5gp1NvGPM=
X-Google-Smtp-Source: ABdhPJxKgvPb+FJSDg5yPGAALaN/5kFXVqrSWJzfpR/lSjPFM6sHEN5a2k0MdSFj9/7Vu8Ig9YJhrg==
X-Received: by 2002:a17:902:b7c3:b029:da:74c3:427 with SMTP id v3-20020a170902b7c3b02900da74c30427mr16073149plz.38.1607341130166;
        Mon, 07 Dec 2020 03:38:50 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id w191sm10219436pfd.145.2020.12.07.03.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:38:49 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] nfc: s3fwrn5: Change irqflags
Date:   Mon,  7 Dec 2020 20:38:27 +0900
Message-Id: <20201207113827.2902-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

change irqflags from IRQF_TRIGGER_HIGH to IRQF_TRIGGER_RISING for stable
Samsung's nfc interrupt handling.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index e1bdde105f24..016f6b6df849 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -213,7 +213,7 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 		return ret;
 
 	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
-		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_RISING | IRQF_ONESHOT,
 		S3FWRN5_I2C_DRIVER_NAME, phy);
 	if (ret)
 		s3fwrn5_remove(phy->common.ndev);
-- 
2.17.1

