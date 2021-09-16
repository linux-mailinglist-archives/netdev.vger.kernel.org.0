Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B210E40D970
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238970AbhIPMFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238964AbhIPMFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 08:05:34 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49397C061766
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:14 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p29so17539727lfa.11
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 05:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XXKmfRFVey/uw+NSWuGju096WFCN34iuJIeJ4gsgCr8=;
        b=Rb1NN0rmmk11kc50N3WTOEI546nP9b9WbJCv3Lt5QmMrvMH+JPa06HuhXor0dUoA8i
         ugSpe4whvO1Yr5gvfFdfNxtJLw9/cCIvnaD06U2dzp+xDX6058ooetaLN+Nlkc7PRlEf
         i++8Wu/J7nhyxlMD+o6SZodk/h0mf0/4UY97AcgQrh03LV7tV7h7aZ3nWkI1Fiu5t7/y
         c/DLNm6vQvgc/ve85EMLLsI/ByZO92pT8kXp5VGktuPKNcN2R8cwkt99rU+jBgqK53BP
         QAzkIBiofzMcc1PsL9Nupjt7kkH0Bfx9oie6hJj5pNV610PNwumKJ9seQMcoRCg5B+4R
         hijA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XXKmfRFVey/uw+NSWuGju096WFCN34iuJIeJ4gsgCr8=;
        b=6rgNsJ7m2+t3ocoEFZk04bO+G9K1KBUu3eloEI/Trn9EMwrRIfuT7/smXhK2F5afCe
         HijEVovZELM+SRs83FeqOFnKjEWStYdWnaw9Gj5pk3rc1XEomjzrKt2YUAUWRYtzLZRS
         Qe3G+XGNnE0VfZIZuTbsNZF51rYKaO6PgfEksbNTs3yUlaeUWy+4waRXuDWdAyA90Sm9
         PxJ1mnda2zinjQnte1+TIL13tPQGUkTXyCUwESbAD+8N6LOXTIvBwmuOAMBzvA8u5xG+
         qIFCQysiEfL/NXhjmH1pcMOs97rMRZILYS/U/aCwSbU2mC7pnuMW8X3uU2WrUgMcgWO9
         z5MQ==
X-Gm-Message-State: AOAM533QW7msvYWb73a0VtJbAEmh4VKv8VQYZYb2tRe9+VKBTXTWbSU3
        exA2UgMF3SDIOo5y3wCBCXA=
X-Google-Smtp-Source: ABdhPJx3nLXIFoo1AnVhg83GSSOZUrZq7i3ZCfBcBrdyklS2ZtFI8p5hSuUrPAlJILZRh8Y12HaGTQ==
X-Received: by 2002:ac2:5a02:: with SMTP id q2mr855988lfn.285.1631793852475;
        Thu, 16 Sep 2021 05:04:12 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id h8sm243010lfk.227.2021.09.16.05.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 05:04:12 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH net-next 4/4] net: dsa: b53: Drop unused "cpu_port" field
Date:   Thu, 16 Sep 2021 14:03:54 +0200
Message-Id: <20210916120354.20338-5-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210916120354.20338-1-zajec5@gmail.com>
References: <20210916120354.20338-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

It's set but never used anymore.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 28 ----------------------------
 drivers/net/dsa/b53/b53_priv.h   |  1 -
 2 files changed, 29 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 13f337a102ba..06279ba64cc8 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2300,7 +2300,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 2,
 		.arl_buckets = 1024,
 		.imp_port = 5,
-		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
 	{
@@ -2311,7 +2310,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 2,
 		.arl_buckets = 1024,
 		.imp_port = 5,
-		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
 	{
@@ -2322,7 +2320,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2336,7 +2333,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2350,7 +2346,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2364,7 +2359,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2379,7 +2373,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_buckets = 1024,
 		.vta_regs = B53_VTA_REGS,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
 		.jumbo_size_reg = B53_JUMBO_MAX_SIZE,
@@ -2392,7 +2385,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2406,7 +2398,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2420,7 +2411,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_63XX,
 		.duplex_reg = B53_DUPLEX_STAT_63XX,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK_63XX,
@@ -2434,7 +2424,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2448,7 +2437,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2462,7 +2450,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2476,7 +2463,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2490,7 +2476,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2504,7 +2489,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2518,7 +2502,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2533,7 +2516,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 256,
 		.imp_port = 8,
-		.cpu_port = 8, /* TODO: ports 4, 5, 8 */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2547,7 +2529,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2561,7 +2542,6 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 256,
 		.imp_port = 8,
-		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2587,7 +2567,6 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->vta_regs[2] = chip->vta_regs[2];
 			dev->jumbo_pm_reg = chip->jumbo_pm_reg;
 			dev->imp_port = chip->imp_port;
-			dev->cpu_port = chip->cpu_port;
 			dev->num_vlans = chip->vlans;
 			dev->num_arl_bins = chip->arl_bins;
 			dev->num_arl_buckets = chip->arl_buckets;
@@ -2619,13 +2598,6 @@ static int b53_switch_init(struct b53_device *dev)
 			break;
 #endif
 		}
-	} else if (dev->chip_id == BCM53115_DEVICE_ID) {
-		u64 strap_value;
-
-		b53_read48(dev, B53_STAT_PAGE, B53_STRAP_VALUE, &strap_value);
-		/* use second IMP port if GMII is enabled */
-		if (strap_value & SV_GMII_CTRL_115)
-			dev->cpu_port = 5;
 	}
 
 	dev->num_ports = fls(dev->enabled_ports);
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 5d068acf7cf8..5be8fe000037 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -124,7 +124,6 @@ struct b53_device {
 	/* used ports mask */
 	u16 enabled_ports;
 	unsigned int imp_port;
-	unsigned int cpu_port;
 
 	/* connect specific data */
 	u8 current_page;
-- 
2.26.2

