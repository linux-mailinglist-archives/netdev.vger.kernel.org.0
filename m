Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C43668DC9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbjAMGaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239506AbjAMG1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:27:10 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D1E6B18C;
        Thu, 12 Jan 2023 22:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=zn2TAaVu38FIU65k7/MT4xLZlbVRoRB8asSaJE0SHvU=; b=fnW6I1OjxCV/+qCsEUVt/I2ltx
        pVazaxhtTWwOIFpuSgV6S/wrRsGO0a/JL9Td5f60CfSJn6rTXQrpT7rBZgWhpR1xWyE0Qgwb3e5Zy
        4xYHJNUH36rYOUlCEJc2GhFeezJZ9AunFCAdE9DOQH7vpp7WH6nP+ijWR7nX8lLuXuyAS3ijRmg7R
        N/W1AmVs/dORBf3sC4X6YxUxqheUzey81JPGw+OvSRgvvpFrFD097CgP86vfGOsIcx6qaVl9TOX3v
        LtdFkCrdEDDEoYkoG3xniDxe0zLInwtaWTr/4pr7zm63OFXIpgGRxp+awTDCHrO/CuJ7EvBvDGGdC
        +Le7Nwsg==;
Received: from [2001:4bb8:181:656b:9509:7d20:8d39:f895] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGDUl-000m83-Hp; Fri, 13 Jan 2023 06:24:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
Subject: [PATCH 21/22] drivers: platform: remove is_sh_early_platform_device
Date:   Fri, 13 Jan 2023 07:23:38 +0100
Message-Id: <20230113062339.1909087-22-hch@lst.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230113062339.1909087-1-hch@lst.de>
References: <20230113062339.1909087-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This was used as a hack for sh-architecture device initialization, and
with sh gone now, only the stub that always returns 0 is left.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/clocksource/sh_cmt.c    |  8 ++------
 drivers/clocksource/sh_mtu2.c   |  8 ++------
 drivers/clocksource/sh_tmu.c    |  9 ++-------
 include/linux/platform_device.h | 12 ------------
 4 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/clocksource/sh_cmt.c b/drivers/clocksource/sh_cmt.c
index 7fed3529bbaf82..4f6d7d40c9fcb1 100644
--- a/drivers/clocksource/sh_cmt.c
+++ b/drivers/clocksource/sh_cmt.c
@@ -1109,10 +1109,8 @@ static int sh_cmt_probe(struct platform_device *pdev)
 	struct sh_cmt_device *cmt = platform_get_drvdata(pdev);
 	int ret;
 
-	if (!is_sh_early_platform_device(pdev)) {
-		pm_runtime_set_active(&pdev->dev);
-		pm_runtime_enable(&pdev->dev);
-	}
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
 
 	if (cmt) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
@@ -1129,8 +1127,6 @@ static int sh_cmt_probe(struct platform_device *pdev)
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
-	if (is_sh_early_platform_device(pdev))
-		return 0;
 
  out:
 	if (cmt->has_clockevent || cmt->has_clocksource)
diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
index e81e978513f80e..97ac2929e424be 100644
--- a/drivers/clocksource/sh_mtu2.c
+++ b/drivers/clocksource/sh_mtu2.c
@@ -448,10 +448,8 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 	struct sh_mtu2_device *mtu = platform_get_drvdata(pdev);
 	int ret;
 
-	if (!is_sh_early_platform_device(pdev)) {
-		pm_runtime_set_active(&pdev->dev);
-		pm_runtime_enable(&pdev->dev);
-	}
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
 
 	if (mtu) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
@@ -468,8 +466,6 @@ static int sh_mtu2_probe(struct platform_device *pdev)
 		pm_runtime_idle(&pdev->dev);
 		return ret;
 	}
-	if (is_sh_early_platform_device(pdev))
-		return 0;
 
  out:
 	if (mtu->has_clockevent)
diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
index 596e9146ad54e9..940378d38dd523 100644
--- a/drivers/clocksource/sh_tmu.c
+++ b/drivers/clocksource/sh_tmu.c
@@ -595,10 +595,8 @@ static int sh_tmu_probe(struct platform_device *pdev)
 	struct sh_tmu_device *tmu = platform_get_drvdata(pdev);
 	int ret;
 
-	if (!is_sh_early_platform_device(pdev)) {
-		pm_runtime_set_active(&pdev->dev);
-		pm_runtime_enable(&pdev->dev);
-	}
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
 
 	if (tmu) {
 		dev_info(&pdev->dev, "kept as earlytimer\n");
@@ -616,9 +614,6 @@ static int sh_tmu_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (is_sh_early_platform_device(pdev))
-		return 0;
-
  out:
 	if (tmu->has_clockevent || tmu->has_clocksource)
 		pm_runtime_irq_safe(&pdev->dev);
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index b0d5a253156ece..894939a74dd20f 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -352,18 +352,6 @@ extern int platform_pm_restore(struct device *dev);
 #define USE_PLATFORM_PM_SLEEP_OPS
 #endif
 
-#ifndef CONFIG_SUPERH
-/*
- * REVISIT: This stub is needed for all non-SuperH users of early platform
- * drivers. It should go away once we introduce the new platform_device-based
- * early driver framework.
- */
-static inline int is_sh_early_platform_device(struct platform_device *pdev)
-{
-	return 0;
-}
-#endif /* CONFIG_SUPERH */
-
 /* For now only SuperH uses it */
 void early_platform_cleanup(void);
 
-- 
2.39.0

