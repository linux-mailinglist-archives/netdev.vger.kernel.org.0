Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FD449D683
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbiA0ACw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiA0ACw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:02:52 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C4EDC06161C;
        Wed, 26 Jan 2022 16:02:52 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so5816168pjj.4;
        Wed, 26 Jan 2022 16:02:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uhtxGNruvdH3i7k2VNLM4qeEKspJ0wckxHvh+jvFDF8=;
        b=O3EQT1SxpLbWN7OrrUTMxkJ0kU7WjzZ44oso57NQYNPCif5Uz6XpWmdRymQj4u5MLR
         yizKXLVIBsgN4PqxayTW5Zp6Pecn9vLISqCvTTSPuN0/wXHYT/qCbbJu/KOsKoG8/WLx
         4ZS4thftEi9mQE0DCXeakMv9h5qreBDFgd6Ts3Dzx3/oiBr4y+m0oJQhLNunRWI0Qdn9
         nrQ3+xnxmvvW7zNGT1+O4gkNPCG/5hOXoLCvvOw6XbJZWF4uUAO3R5FZfktNSn3IbRmF
         x/LquQVKoOddT0fDuo5fSakqF5UFgsyguF8SW/FdOMY6zGgA6G13mXL9uTjI3gbnUgY+
         4dZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uhtxGNruvdH3i7k2VNLM4qeEKspJ0wckxHvh+jvFDF8=;
        b=mEPeAtgtbnjwfYFVJy5GgMhZCvtLuOqsGOXEoW+NuCytQLMAce6yVCYi8sM3Jt7cJc
         2gj0xGS0iEfdUCUlKIpYEB27hL8FAuheYl7Y+993alXjr/VaC/ML5vKa5f5X/6tsDBf9
         L5Dyj0Kbtjckjg73/1Ar4l+m5sk8zNKZqAGW/NBsGjxGHP4wdj+/dQRWHyhU0vBB0XJz
         j92PHPZfXqONQOLmV1Xg0rUqY2QioeeWYHf+BNEZQE1DQr2p51VusCrK8iZPwTKeN5ix
         5jGdOmtp5wL2nD8/0zuJG4SRtazDNsHMUc+4Eice7Ziw+SDKsGRiFbjVczz3iFGiGCtm
         dtcg==
X-Gm-Message-State: AOAM5325NWiOW7vyStkfwB4me/jsNX0oyPBDB1+mLU9Nv8slcMP3O7kd
        jqLg0lnQbXONa4JERV/667Y=
X-Google-Smtp-Source: ABdhPJxzb107VU9W/hlkdDWORd5qgIOCUyrHPOQeQpw10iZgtSu6EJxIHj1nafAI9KMj/EhFDmErIg==
X-Received: by 2002:a17:90a:1784:: with SMTP id q4mr11333932pja.3.1643241771504;
        Wed, 26 Jan 2022 16:02:51 -0800 (PST)
Received: from localhost.localdomain (192.243.120.23.16clouds.com. [192.243.120.23])
        by smtp.gmail.com with ESMTPSA id t15sm9602147pgc.49.2022.01.26.16.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:02:51 -0800 (PST)
From:   davidcomponentone@gmail.com
To:     richardcochran@gmail.com
Cc:     davidcomponentone@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] ptp: replace snprintf with sysfs_emit
Date:   Thu, 27 Jan 2022 08:02:36 +0800
Message-Id: <e4fa9680b8b939901adcf91123ab1778a0a7a38d.1643182187.git.yang.guang5@zte.com.cn>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yang Guang <yang.guang5@zte.com.cn>

coccinelle report:
./drivers/ptp/ptp_sysfs.c:17:8-16:
WARNING: use scnprintf or sprintf
./drivers/ptp/ptp_sysfs.c:390:8-16:
WARNING: use scnprintf or sprintf

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
Signed-off-by: David Yang <davidcomponentone@gmail.com>
---
 drivers/ptp/ptp_sysfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 41b92dc2f011..9233bfedeb17 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -14,7 +14,7 @@ static ssize_t clock_name_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
 {
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
-	return snprintf(page, PAGE_SIZE-1, "%s\n", ptp->info->name);
+	return sysfs_emit(page, "%s\n", ptp->info->name);
 }
 static DEVICE_ATTR_RO(clock_name);
 
@@ -387,7 +387,7 @@ static ssize_t ptp_pin_show(struct device *dev, struct device_attribute *attr,
 
 	mutex_unlock(&ptp->pincfg_mux);
 
-	return snprintf(page, PAGE_SIZE, "%u %u\n", func, chan);
+	return sysfs_emit(page, "%u %u\n", func, chan);
 }
 
 static ssize_t ptp_pin_store(struct device *dev, struct device_attribute *attr,
-- 
2.30.2

