Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A074AA730
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 07:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238491AbiBEGrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 01:47:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiBEGrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 01:47:47 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19A8C061346;
        Fri,  4 Feb 2022 22:47:43 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id e6so6984693pfc.7;
        Fri, 04 Feb 2022 22:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=FCcXnFe+AjDLJWHmF/M/9s62o5qLgGSOORd9vpKd/v4=;
        b=JVp1WoeFWk2sg9YssMpSZiyjxY7guelYiPtHdZgPaqpz2BNVY/Z7syt4nDNbUkv7ga
         HuW+LXnA4oVmkJ8QraA5INWrpTPLnRWkg54p0MPhvhD86LZMyCd+SaEKVv6mxSZK0ec7
         JozKoKariZ+A23A0hjoEJ+TcGuiMS+A9DnBJgP7y1l8OoiqVJqDpf/b44hLlh3Shs4KY
         OlpOWAMfvzjxVSgiCP6ItTN8G9j4e7afQdXr8huptEr1PqXpql6HIQXH4B0U261IJLK3
         DcFG69HyocXH/b1UXkecfuywfbcXMS3qgnmc4iKqeVxzlwIMC2vEJq7ESunq0HufLlCQ
         Qybg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FCcXnFe+AjDLJWHmF/M/9s62o5qLgGSOORd9vpKd/v4=;
        b=A0yrjnLxLvIDNc0ldMAkVnW7k2HvGrWIK1UBMOSb9vrJQNKGx2kwTQTsDl/rwfitvw
         IceE33PmnGpAzP+tPbytSF+cEidgoxYHS9t8HsyjVX80B5RO5M8TMaCaSCJCwDzwtY81
         psdJ3ezezSkcKbhux/G6qODzXMmX9mHqdQfD8EiAFy5rWO/wuMohgGOyFFjw79uv3kfo
         zD+3+20R8USHf6FkSpXxqUnqTgn5JuRByHRo11hWLYhJ+EvtxGlH+PGLIappputzSBTJ
         mSpAGUxTaWb54JRZ74Jr3XxdUqXjyf4T7TOa8ETpVBbruflSLLsmJ5QLCs+AG4P0geWt
         ZBgw==
X-Gm-Message-State: AOAM5302hrussa5lwYdU229Kj1W/w7F0XLmx+GQX5Vt1CQw58TpfJ3gm
        ZtEGMJ8/McoQ7mGQO84p9vo=
X-Google-Smtp-Source: ABdhPJyOmL7EE5vRNAoEwnCmzFSGS6hXIwn08o0tG4frEhx91YUIlsKZxgtNtMxlQiEr8iP1js/93g==
X-Received: by 2002:a63:27c4:: with SMTP id n187mr2049424pgn.504.1644043662372;
        Fri, 04 Feb 2022 22:47:42 -0800 (PST)
Received: from localhost.localdomain ([2405:201:2003:b021:6001:8ce1:3e29:705e])
        by smtp.gmail.com with ESMTPSA id nu15sm1706233pjb.5.2022.02.04.22.47.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Feb 2022 22:47:42 -0800 (PST)
From:   Raag Jadav <raagjadav@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Raag Jadav <raagjadav@gmail.com>
Subject: [PATCH] net: phy: mscc: enable MAC SerDes autonegotiation
Date:   Sat,  5 Feb 2022 12:14:52 +0530
Message-Id: <1644043492-31307-1-git-send-email-raagjadav@gmail.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable MAC SerDes autonegotiation to distinguish between
1000BASE-X, SGMII and QSGMII MAC.

Signed-off-by: Raag Jadav <raagjadav@gmail.com>
---
 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index a50235f..366db14 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -195,6 +195,8 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_PCS_CTRL	  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index ebfeeb3..6db43a5 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1685,6 +1685,25 @@ static int vsc8574_config_host_serdes(struct phy_device *phydev)
 			   PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
 }
 
+static int vsc85xx_config_inband_aneg(struct phy_device *phydev, bool enabled)
+{
+	int rc;
+	u16 reg_val = 0;
+
+	if (enabled)
+		reg_val = MSCC_PHY_SERDES_ANEG;
+
+	mutex_lock(&phydev->lock);
+
+	rc = phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
+			      MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
+			      reg_val);
+
+	mutex_unlock(&phydev->lock);
+
+	return rc;
+}
+
 static int vsc8584_config_init(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531 = phydev->priv;
@@ -1772,6 +1791,11 @@ static int vsc8584_config_init(struct phy_device *phydev)
 					      VSC8572_RGMII_TX_DELAY_MASK);
 		if (ret)
 			return ret;
+	} else {
+		/* Enable clause 37 */
+		ret = vsc85xx_config_inband_aneg(phydev, true);
+		if (ret)
+			return ret;
 	}
 
 	ret = genphy_soft_reset(phydev);
-- 
2.7.4

