Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 164E0427DF5
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 00:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231492AbhJIWsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 18:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhJIWs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 18:48:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F811C061570;
        Sat,  9 Oct 2021 15:46:31 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v18so51338456edc.11;
        Sat, 09 Oct 2021 15:46:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TIVh7aXnS7WMSRSGvwGkaRzozu+hXv97EwwaZX+jHdM=;
        b=oOKr/atM5nzowrWmteaojYmoF9a2R1w+9ahIVJwRX8vsfYT7X/e38DpWfyH9BrkZU3
         wYg5z3Nrkfmum1nFJO561lLL5D2cE8oc4NbYhCfC+P47Z+93r86lh0n46FiIb6m8q3fd
         C4CbhZiKVHHLFBhWtsSVtE43EPPYymUY1XUmhlYU9pqH5oLPWd5bSNxjiIeBqiZotB5J
         /QAa1+0GAeK3/pjC4R0oq1th71+D9UyVTlr4EcjxRY7XY4f6BceU+uM+u6Z9E00NP10i
         Qe4NIFDpW39P7YMwvqJ0P/NwqI3k+4y7/D7bizr6YQKHQnfNjkT0uXIGec8xW3iu3BF/
         hB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TIVh7aXnS7WMSRSGvwGkaRzozu+hXv97EwwaZX+jHdM=;
        b=eQcqLLl4hUj9n3QATC1w93Iz82Q4heKWUr7R1cwjJNknKdBchtYQmpIbXl4f3qleed
         m01Vpi9okYa92VHEi1Qm7qRAazUGhAEkbxGSRS6e5PhdJUq2quBBl5wcBPJ1FthxFjMz
         tgO6zByQIV8CIby1S4vCWwqXMEw9mGFfwkXvgPkr5b3N7P8oMHt0wtn6ewYEmUV9xQ4L
         R5vqZrLoxEZ0TPImdTEd6haC4lIUsYV5II6kqTzgjCSIFv5eCNvEQfE2OCQon9snIUvg
         tq2f/qMybsvuRUmfSLNjs2jZWm/Rq3Ljdq1tEGs23inGOXM31YymWNoNxTDtytaABZU/
         zc4A==
X-Gm-Message-State: AOAM532Hh/xuI6lIZXIUerHYS8M2esjq5Ty55h5ujoWV2lLRzLcPLEN0
        N8xrIEbPFe2+ZbP+l6nvHnkhfyyxuYk=
X-Google-Smtp-Source: ABdhPJwHcNfkxX7jOEY3jv2oKG4zEYhOvCUGI6QCq2lb1Er1t7gs91TPLkk/8N65aDu5TvdD5YLEyw==
X-Received: by 2002:a05:6402:410:: with SMTP id q16mr27405080edv.286.1633819589525;
        Sat, 09 Oct 2021 15:46:29 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id l13sm1727115eds.92.2021.10.09.15.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 15:46:29 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 2/4] net: phy: at803x: add DAC amplitude fix for 8327 phy
Date:   Sun, 10 Oct 2021 00:46:16 +0200
Message-Id: <20211009224618.4988-2-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211009224618.4988-1-ansuelsmth@gmail.com>
References: <20211009224618.4988-1-ansuelsmth@gmail.com>
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

Fixes: b4df02b562f4 ("net: phy: at803x: add support for qca 8327 A variant internal phy")
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

