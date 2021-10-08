Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99591426118
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242208AbhJHAZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241951AbhJHAY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:24:58 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C70C061570;
        Thu,  7 Oct 2021 17:23:03 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id g8so29580644edt.7;
        Thu, 07 Oct 2021 17:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HGh5+iB2TULH7hahZSPDz2mxWTqZ/+fE5LlYJVBSwbg=;
        b=fcdEXW33eOPWvxKwPt8Pk4VYbAUe0dimY8gvmOIutI7hCMyRGRwoO6NUgqrF+94JMl
         gHdpW8lmS+d4CSRZ9mRZQn7FbDB4usBE4W+M6PgBeWwG+FMiuA39u2LThzsBjZ7hO4dm
         Y7XgqPtkNRU3ekyaZZXohjwW653ivv55P5VPcNSIzytBrVaQRp6zkOCfroqX++oyYTGw
         ZsOH0oyaxtD9EhMA3hjg4m5EmZ0i30DTWzzaZyoGRKhjbBbqcSDU1njmP+ArRFyb9bKP
         NkvwpxXlu/aJbb5pTnDqhDdimxDhqe5JH1OMZtXuFoWeIJJ5OLJm6oi8CVst4PchjLjc
         RCvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HGh5+iB2TULH7hahZSPDz2mxWTqZ/+fE5LlYJVBSwbg=;
        b=B08BglOQ/qK6JF/zNmEpdUmFvhZsDIn7H4CZ5Bbj30Z9bUBqsWgTsQg8ppTUeuTzNh
         bqB7iuCIscH5Y+IfdM1eDiTuj/2fi7P2SYe6MiM1SjtlYe5faEn8rQeIPo0mUsFLG7pJ
         p40zO9roy18Oc80LLqA8L6Xnz5aPEZw9I7uTh0GiEtabCK8ozFAtzIkgwTimCTEDWqTr
         MLYFY6Wg0J9CXR5scTbx9TfZ9bvonUz83Ff3HV5ZLMUvEK//w6VjoTjmQzAIYw17s7KG
         l+Ij6/ASQyFlp0YJce3gksOfu/iZItxICSfr2jvwc2FuAHBtfjhCTdOBxUr+H5ou6MXu
         OJYA==
X-Gm-Message-State: AOAM532nH32fE2EQQQBP6lFMLyWBmGxBvcA150Q+pCjSSs+XtymXNp4W
        ajJ8/C0eXNe7grLjmmLVM6gV4FfpaYw=
X-Google-Smtp-Source: ABdhPJxTzCQQIzNG11JvLDWDYuYmWIyDfZdRwMF4seNbFnt6v8JWJpWL+1Nj0NzfogdLRRtrtnRzyQ==
X-Received: by 2002:a17:906:1ed7:: with SMTP id m23mr131987ejj.558.1633652582065;
        Thu, 07 Oct 2021 17:23:02 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:01 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net PATCH v2 02/15] drivers: net: phy: at803x: add DAC amplitude fix for 8327 phy
Date:   Fri,  8 Oct 2021 02:22:12 +0200
Message-Id: <20211008002225.2426-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QCA8327 internal phy require DAC amplitude adjustement set to +6% with
100m speed. Also add additional define to report a change of the same
reg in QCA8337. (different scope it does set 1000m voltage)
Add link_change_notify function to set the proper amplitude adjustement
on PHY_RUNNING state and disable on any other state.

Fixes: c6bcec0d6928 ("net: phy: at803x: add support for qca 8327 A variant internal phy")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/phy/at803x.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index c6c87b82c95c..5208ea8fdd69 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -87,6 +87,8 @@
 #define AT803X_PSSR_MR_AN_COMPLETE		0x0200
 
 #define AT803X_DEBUG_REG_0			0x00
+#define QCA8327_DEBUG_MANU_CTRL_EN		BIT(2)
+#define QCA8337_DEBUG_MANU_CTRL_EN		GENMASK(3, 2)
 #define AT803X_DEBUG_RX_CLK_DLY_EN		BIT(15)
 
 #define AT803X_DEBUG_REG_5			0x05
@@ -1314,9 +1316,37 @@ static int qca83xx_config_init(struct phy_device *phydev)
 		break;
 	}
 
+	/* QCA8327 require DAC amplitude adjustment for 100m set to +6%.
+	 * Disable on init and enable only with 100m speed following
+	 * qca original source code.
+	 */
+	if (phydev->drv->phy_id == QCA8327_A_PHY_ID ||
+	    phydev->drv->phy_id == QCA8327_B_PHY_ID)
+		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
+
 	return 0;
 }
 
+static void qca83xx_link_change_notify(struct phy_device *phydev)
+{
+	/* QCA8337 doesn't require DAC Amplitude adjustement */
+	if (phydev->drv->phy_id == QCA8337_PHY_ID)
+		return;
+
+	/* Set DAC Amplitude adjustment to +6% for 100m on link running */
+	if (phydev->state == PHY_RUNNING) {
+		if (phydev->speed == SPEED_100)
+			at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+					      QCA8327_DEBUG_MANU_CTRL_EN,
+					      QCA8327_DEBUG_MANU_CTRL_EN);
+	} else {
+		/* Reset DAC Amplitude adjustment */
+		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
+				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
+	}
+}
+
 static int qca83xx_resume(struct phy_device *phydev)
 {
 	int ret, val;
@@ -1471,6 +1501,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id_mask		= QCA8K_PHY_ID_MASK,
 	.name			= "Qualcomm Atheros 8337 internal PHY",
 	/* PHY_GBIT_FEATURES */
+	.link_change_notify	= qca83xx_link_change_notify,
 	.probe			= at803x_probe,
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
@@ -1486,6 +1517,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id_mask		= QCA8K_PHY_ID_MASK,
 	.name			= "Qualcomm Atheros 8327-A internal PHY",
 	/* PHY_GBIT_FEATURES */
+	.link_change_notify	= qca83xx_link_change_notify,
 	.probe			= at803x_probe,
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
@@ -1501,6 +1533,7 @@ static struct phy_driver at803x_driver[] = {
 	.phy_id_mask		= QCA8K_PHY_ID_MASK,
 	.name			= "Qualcomm Atheros 8327-B internal PHY",
 	/* PHY_GBIT_FEATURES */
+	.link_change_notify	= qca83xx_link_change_notify,
 	.probe			= at803x_probe,
 	.flags			= PHY_IS_INTERNAL,
 	.config_init		= qca83xx_config_init,
-- 
2.32.0

