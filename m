Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C331B648F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbgDWTfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbgDWTfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:35:39 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745EDC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:35:39 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t63so7756967wmt.3
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eDAtPijhSrs76CNWOwIulZGXzdOaO4o0eOmiiHP2RT8=;
        b=hehvpdQJK4kII4zYely2Ll7b7ib/F0n1TqihyoJv7Zu/oYxcajHun33M8Lq6D5p+AE
         7yA5XifZWz+QJyDBWBo8+3ov+UTSFQuAvPMQc5ExZU9s1aQWSF8bttP3qwAm/DKLXjTp
         l4T106UFSDySBxjY2nTOGz0G4ou1wJ1rtue0J771u18rIBz1yDVNpZa7JzDNhSKCKoEI
         iXuv/L430h/CMdd1V93A6RSfXUS79DoP1wXMvNyS8+0d47yThWwta3+tyagphr3+Hrx9
         evNVlG40bpClwvWTIecgcZ4WSpyK8zbFsfyRG22WA1nTBjb2tVWj7TinVlgupCb7gCx4
         Lduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eDAtPijhSrs76CNWOwIulZGXzdOaO4o0eOmiiHP2RT8=;
        b=O+PhTFJ9VP73PfNOo/E/lbvjKiqbsatLZXJkDyfILbROchbOY/GFFqEAu852UblD6q
         EIwex5VemDYjF3s4dwXlITUF4tbB6+rxU5wa1YWBT4hXrLQRkPmLkTzcj4rhE6cnbwcL
         M6qQV5we+OzD4TuLWYxef3I4wv2/dFq7N0lW3x45BJ5V+HwZkLmLD1qHk3DlCIPOM98r
         98l0D19Y3XLyvF5ebjN1/+Xj6u1V2TntycoawP1HBsckXy1AA02VmRhvKOPTjciLVUHD
         0yWQwcn9f8yhxOdowJRSwiPTYJP/maSwsQOo0dS61I/iRHfgMw8K0j5HWL186n8EW8aV
         kmxA==
X-Gm-Message-State: AGi0PuZ1u/uyDfbXLpuGZt+0W+g1Er4DXvUoPf82YFtMWzMmgq72vgAk
        lVoLgI0iw/uaVqqQ62tPNbYsuixw
X-Google-Smtp-Source: APiQypK9mpUBDu60FA2TOkcplHvI++AK1kY+xWrETnQVmUZCKmwb2yTWgn8mP3Xzhsf5Cos004+RNg==
X-Received: by 2002:adf:edcc:: with SMTP id v12mr6784557wro.317.1587670537887;
        Thu, 23 Apr 2020 12:35:37 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:c569:21dc:2ec:9a23? (p200300EA8F296000C56921DC02EC9A23.dip0.t-ipconnect.de. [2003:ea:8f29:6000:c569:21dc:2ec:9a23])
        by smtp.googlemail.com with ESMTPSA id 74sm5407142wrk.30.2020.04.23.12.35.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 12:35:37 -0700 (PDT)
Subject: [PATCH net-next 2/3] net: phy: remove genphy_no_soft_reset
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
Message-ID: <5a6bac65-ae8e-0231-ac23-1a079c14fd3b@gmail.com>
Date:   Thu, 23 Apr 2020 21:35:36 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <705e2fc1-5220-d5a8-e880-5ff04e528ded@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
we don't need genphy_no_soft_reset() any longer. Not setting
callback soft_reset results in a no-op now.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/cortina.c    | 1 -
 drivers/net/phy/marvell10g.c | 2 --
 drivers/net/phy/phy-c45.c    | 1 -
 drivers/net/phy/phy_device.c | 1 -
 drivers/net/phy/teranetics.c | 1 -
 include/linux/phy.h          | 4 ----
 6 files changed, 10 deletions(-)

diff --git a/drivers/net/phy/cortina.c b/drivers/net/phy/cortina.c
index 856cdc36a..aac51362c 100644
--- a/drivers/net/phy/cortina.c
+++ b/drivers/net/phy/cortina.c
@@ -82,7 +82,6 @@ static struct phy_driver cortina_driver[] = {
 	.features       = PHY_10GBIT_FEATURES,
 	.config_aneg	= gen10g_config_aneg,
 	.read_status	= cortina_read_status,
-	.soft_reset	= genphy_no_soft_reset,
 	.probe		= cortina_probe,
 },
 };
diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
index 95e3f4644..80cbc77ff 100644
--- a/drivers/net/phy/marvell10g.c
+++ b/drivers/net/phy/marvell10g.c
@@ -727,7 +727,6 @@ static struct phy_driver mv3310_drivers[] = {
 		.phy_id_mask	= MARVELL_PHY_ID_MASK,
 		.name		= "mv88x3310",
 		.get_features	= mv3310_get_features,
-		.soft_reset	= genphy_no_soft_reset,
 		.config_init	= mv3310_config_init,
 		.probe		= mv3310_probe,
 		.suspend	= mv3310_suspend,
@@ -745,7 +744,6 @@ static struct phy_driver mv3310_drivers[] = {
 		.probe		= mv3310_probe,
 		.suspend	= mv3310_suspend,
 		.resume		= mv3310_resume,
-		.soft_reset	= genphy_no_soft_reset,
 		.config_init	= mv3310_config_init,
 		.config_aneg	= mv3310_config_aneg,
 		.aneg_done	= mv3310_aneg_done,
diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 67ba47ae5..defe09d94 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -564,6 +564,5 @@ struct phy_driver genphy_c45_driver = {
 	.phy_id         = 0xffffffff,
 	.phy_id_mask    = 0xffffffff,
 	.name           = "Generic Clause 45 PHY",
-	.soft_reset	= genphy_no_soft_reset,
 	.read_status    = genphy_c45_read_status,
 };
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 206d98502..c8f8fd990 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2630,7 +2630,6 @@ static struct phy_driver genphy_driver = {
 	.phy_id		= 0xffffffff,
 	.phy_id_mask	= 0xffffffff,
 	.name		= "Generic PHY",
-	.soft_reset	= genphy_no_soft_reset,
 	.get_features	= genphy_read_abilities,
 	.suspend	= genphy_suspend,
 	.resume		= genphy_resume,
diff --git a/drivers/net/phy/teranetics.c b/drivers/net/phy/teranetics.c
index beb054b93..8057ea8db 100644
--- a/drivers/net/phy/teranetics.c
+++ b/drivers/net/phy/teranetics.c
@@ -78,7 +78,6 @@ static struct phy_driver teranetics_driver[] = {
 	.phy_id_mask	= 0xffffffff,
 	.name		= "Teranetics TN2020",
 	.features       = PHY_10GBIT_FEATURES,
-	.soft_reset	= genphy_no_soft_reset,
 	.aneg_done	= teranetics_aneg_done,
 	.config_aneg    = gen10g_config_aneg,
 	.read_status	= teranetics_read_status,
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3941a6bcb..e2bfb9240 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1251,10 +1251,6 @@ static inline int genphy_config_aneg(struct phy_device *phydev)
 	return __genphy_config_aneg(phydev, false);
 }
 
-static inline int genphy_no_soft_reset(struct phy_device *phydev)
-{
-	return 0;
-}
 static inline int genphy_no_ack_interrupt(struct phy_device *phydev)
 {
 	return 0;
-- 
2.26.2


