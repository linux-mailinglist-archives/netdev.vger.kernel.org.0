Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB072033C6
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgFVJnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:43:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgFVJlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:41:36 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F59C061798
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:35 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l11so15971662wru.0
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GfxRtzTQEG/5B2vcAI0+WR3x7R55kmvGCSrvKLTEK2Q=;
        b=A0YsIPLNyYjq0ssEvXKicqSfckLBHv0GVryALC9d+AV98+m0KCKKpxY0AwyeTaC/SV
         4ewNSwSYjUQsP4yxHm8UWF9gryWmZ5NreLHL6eNRWjMmIjJRCWiNutTjs4Dj5nQbR/al
         xKYExJnhmZzF3ijNBmLN0+9cPyr9XfVrG4iIqj5hbRDxQ5onbhon50y62e0SSGhWhkuw
         rmocxlBQDpuSpCL4KghX633TaDScTSjnEqyd5R5g43WJlC81zN4EIN3Bn8mQId8I8MeF
         8+2wsc96b1npN8idQoXobDeawhU/GfrNBYEANPkdYosOat1y3XLGX18/UsW4P4z0HqDS
         YNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GfxRtzTQEG/5B2vcAI0+WR3x7R55kmvGCSrvKLTEK2Q=;
        b=h9FYAUCffR1sWq0Az9jRy8gT7eekkJs41xy5v/kQLKUwYEz4lciUrRZQmUbSK832bQ
         2FV3NzliCpz6ngQrWc4/tOo/VrW2NJPpKcixIs9V2pcdfUWkEo1nbxmCyveq1E28SFiy
         oxrSn4L/U+3HijBHbKS5U0pgnsF4V5WI+Ytt6lJ1ADrUkPIuA7yehtsgmXHqQkgQlGTF
         t0Jxq/V05aaSPRGDHqKOJZ7z89JJBRf6/Gn/mpKCyNy4YhYEWeDVRZEhbIfTeMraRGcA
         79tyvNjnCW1/E8FNBkv77sR2ovqL0bnVVIk2l56SruqPO1D4qH5VT1aTfmPAhzggTnvr
         HM+Q==
X-Gm-Message-State: AOAM531ma7Z27U10rGc6+7Q03fqZivMJxUrQ9060eBB5Id7dIqwUeiH4
        DbmgjS5HGwpYsrG2HE1nwh2oSQ==
X-Google-Smtp-Source: ABdhPJwe0PlqLfQqK/nfnfTmRDAPWRDDBJzvm26MZsgDYSHOQIM+GwOvMWfHdMQjezh7QNqFssNhEA==
X-Received: by 2002:a5d:4bd2:: with SMTP id l18mr400661wrt.119.1592818894547;
        Mon, 22 Jun 2020 02:41:34 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id j24sm14392652wrd.43.2020.06.22.02.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 02:41:34 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 07/15] net: phy: split out the PHY driver request out of phy_device_create()
Date:   Mon, 22 Jun 2020 11:37:36 +0200
Message-Id: <20200622093744.13685-8-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200622093744.13685-1-brgl@bgdev.pl>
References: <20200622093744.13685-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Move the code requesting the PHY driver module out of phy_device_create()
into a separate helper. This will be later reused when we delay the
module loading.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/phy/phy_device.c | 71 ++++++++++++++++++++----------------
 1 file changed, 39 insertions(+), 32 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f6985db08340..8037a9663a85 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -558,7 +558,7 @@ static const struct device_type mdio_bus_phy_type = {
 	.pm = MDIO_BUS_PHY_PM_OPS,
 };
 
-static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
+static int phy_do_request_driver_module(struct phy_device *dev, u32 phy_id)
 {
 	int ret;
 
@@ -578,6 +578,40 @@ static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 	return 0;
 }
 
+static int phy_request_driver_module(struct phy_device *phydev)
+{
+	int ret;
+
+	/* Request the appropriate module unconditionally; don't
+	 * bother trying to do so only if it isn't already loaded,
+	 * because that gets complicated. A hotplug event would have
+	 * done an unconditional modprobe anyway.
+	 * We don't do normal hotplug because it won't work for MDIO
+	 * -- because it relies on the device staying around for long
+	 * enough for the driver to get loaded. With MDIO, the NIC
+	 * driver will get bored and give up as soon as it finds that
+	 * there's no driver _already_ loaded.
+	 */
+	if (phydev->is_c45) {
+		const int num_ids = ARRAY_SIZE(phydev->c45_ids.device_ids);
+		int i;
+
+		for (i = 1; i < num_ids; i++) {
+			if (phydev->c45_ids.device_ids[i] == 0xffffffff)
+				continue;
+
+			ret = phy_do_request_driver_module(phydev,
+						phydev->c45_ids.device_ids[i]);
+			if (ret)
+				break;
+		}
+	} else {
+		ret = phy_do_request_driver_module(phydev, phydev->phy_id);
+	}
+
+	return ret;
+}
+
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids)
@@ -622,38 +656,11 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 
 	mutex_init(&dev->lock);
 	INIT_DELAYED_WORK(&dev->state_queue, phy_state_machine);
+	device_initialize(&mdiodev->dev);
 
-	/* Request the appropriate module unconditionally; don't
-	 * bother trying to do so only if it isn't already loaded,
-	 * because that gets complicated. A hotplug event would have
-	 * done an unconditional modprobe anyway.
-	 * We don't do normal hotplug because it won't work for MDIO
-	 * -- because it relies on the device staying around for long
-	 * enough for the driver to get loaded. With MDIO, the NIC
-	 * driver will get bored and give up as soon as it finds that
-	 * there's no driver _already_ loaded.
-	 */
-	if (is_c45 && c45_ids) {
-		const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
-		int i;
-
-		for (i = 1; i < num_ids; i++) {
-			if (c45_ids->device_ids[i] == 0xffffffff)
-				continue;
-
-			ret = phy_request_driver_module(dev,
-						c45_ids->device_ids[i]);
-			if (ret)
-				break;
-		}
-	} else {
-		ret = phy_request_driver_module(dev, phy_id);
-	}
-
-	if (!ret) {
-		device_initialize(&mdiodev->dev);
-	} else {
-		kfree(dev);
+	ret = phy_request_driver_module(dev);
+	if (ret) {
+		phy_device_free(dev);
 		dev = ERR_PTR(ret);
 	}
 
-- 
2.26.1

