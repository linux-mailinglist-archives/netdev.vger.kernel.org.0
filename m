Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2409186A68
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404252AbfHHTGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 15:06:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55685 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404145AbfHHTGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:06:05 -0400
Received: by mail-wm1-f67.google.com with SMTP id f72so3391928wmf.5
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+tMOhOmXls774N7m1qJZZAHzqMZCbx+XYZSvgO3LpiI=;
        b=tK40TN9kTgn74/4XKwvHqoabg336PFRmN1GtOHLcBCqtYdxdnjAACPDLAQG6uGtIFB
         401ENH41z0XV7zIdGKgrYbXq5vSNj1HioEIDCsRAAWH+4/9y1O96jIQ3uMoo//CjSmw7
         kZgibSzWKgwjcm1BAmwwXSKce9ykp8MCTyDxFNW0nS0g1WI2SaI9qGauSg+8qv3+X2lO
         mL6D4nfTYBDnou0zJWtVcFdmJ45M1u76fnevh/o0LEqJTQXcggUb0bO2EenvTYC67vpb
         NJ9tK7FtgFSFirgLFxJNqZsBolTG8GhAjduyixiBIv7sPGQd914i4iKYKnsM1CI9PIjn
         Q6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+tMOhOmXls774N7m1qJZZAHzqMZCbx+XYZSvgO3LpiI=;
        b=PDI1AYG6UaNBGnGK41vbeNS97pLAw7ASVbYMBBmUbvX9Sxz+HNEewTjGhUYd0D8WiY
         QZkNFMjHy0gWun18p0Eq/w75IQJb0/6RpK5aBZVbpzCZhXElH4/SfJ8K0M/nLQFMNlUa
         2zUCwXi26bPjPHC6hPdJD5rarTjGEUGI3jCfTfh2NyJVCdnRc1C5GXJ4s/Bm3zUs6cvF
         +gTcdiurWfdvtB3fgFJdlrLWJhYmDAya1HvzotlNDaUYXu9qDT1rp8U5VHr48NUgL1a8
         tp+DRJygQLtxCwBHdVVtLpWswUOkB6cv1fpKRQukJvFPHFKgOA5Yl4GiRpUD7bOuuBJZ
         NctQ==
X-Gm-Message-State: APjAAAVF40TcZ3cPENiD5xEB7uOQvnk+meVhyx8yUYZZIRKDFVyWj+Xr
        EXdB4Y2wJYGAYzj6Xjvxcr29Ofvw
X-Google-Smtp-Source: APXvYqy+p1ukQwP2DFqLmAJ/X1ago0IlBchcnmF1oa85hdJMIveiisXRhU0NThmT+zXRKzLwz/Ncqg==
X-Received: by 2002:a7b:c7d8:: with SMTP id z24mr6198406wmk.10.1565291161951;
        Thu, 08 Aug 2019 12:06:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf? (p200300EA8F2F3200EC8A8637BF5F7FAF.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:ec8a:8637:bf5f:7faf])
        by smtp.googlemail.com with ESMTPSA id c1sm212987943wrh.1.2019.08.08.12.06.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Aug 2019 12:06:01 -0700 (PDT)
Subject: [PATCH net-next 1/3] net: phy: prepare phylib to deal with PHY's
 extending Clause 22
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
Message-ID: <214bedc0-4ae0-b15f-e03c-173f17527417@gmail.com>
Date:   Thu, 8 Aug 2019 21:03:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ddbf28b9-f32e-7399-10a6-27b79ca0aaf9@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The integrated PHY in 2.5Gbps chip RTL8125 is the first (known to me)
PHY that uses standard Clause 22 for all modes up to 1Gbps and adds
2.5Gbps control using vendor-specific registers. To use phylib for
the standard part little extensions are needed:
- Move most of genphy_config_aneg to a new function
  __genphy_config_aneg that takes a parameter whether restarting
  auto-negotiation is needed (depending on whether content of
  vendor-specific advertisement register changed).
- Don't clear phydev->lp_advertising in genphy_read_status so that
  we can set non-C22 mode flags before.

Basically both changes mimic the behavior of the equivalent Clause 45
functions.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 35 +++++++++++++++--------------------
 include/linux/phy.h          |  8 +++++++-
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7ddd91df9..bd7e7db8c 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1571,11 +1571,9 @@ static int genphy_config_advert(struct phy_device *phydev)
 	/* Only allow advertising what this PHY supports */
 	linkmode_and(phydev->advertising, phydev->advertising,
 		     phydev->supported);
-	if (!ethtool_convert_link_mode_to_legacy_u32(&advertise,
-						     phydev->advertising))
-		phydev_warn(phydev, "PHY advertising (%*pb) more modes than genphy supports, some modes not advertised.\n",
-			    __ETHTOOL_LINK_MODE_MASK_NBITS,
-			    phydev->advertising);
+
+	ethtool_convert_link_mode_to_legacy_u32(&advertise,
+						phydev->advertising);
 
 	/* Setup standard advertisement */
 	err = phy_modify_changed(phydev, MII_ADVERTISE,
@@ -1681,18 +1679,20 @@ int genphy_restart_aneg(struct phy_device *phydev)
 EXPORT_SYMBOL(genphy_restart_aneg);
 
 /**
- * genphy_config_aneg - restart auto-negotiation or write BMCR
+ * __genphy_config_aneg - restart auto-negotiation or write BMCR
  * @phydev: target phy_device struct
+ * @changed: whether autoneg is requested
  *
  * Description: If auto-negotiation is enabled, we configure the
  *   advertising, and then restart auto-negotiation.  If it is not
  *   enabled, then we write the BMCR.
  */
-int genphy_config_aneg(struct phy_device *phydev)
+int __genphy_config_aneg(struct phy_device *phydev, bool changed)
 {
-	int err, changed;
+	int err;
 
-	changed = genphy_config_eee_advert(phydev);
+	if (genphy_config_eee_advert(phydev))
+		changed = true;
 
 	if (AUTONEG_ENABLE != phydev->autoneg)
 		return genphy_setup_forced(phydev);
@@ -1700,10 +1700,10 @@ int genphy_config_aneg(struct phy_device *phydev)
 	err = genphy_config_advert(phydev);
 	if (err < 0) /* error */
 		return err;
+	else if (err)
+		changed = true;
 
-	changed |= err;
-
-	if (changed == 0) {
+	if (!changed) {
 		/* Advertisement hasn't changed, but maybe aneg was never on to
 		 * begin with?  Or maybe phy was isolated?
 		 */
@@ -1713,18 +1713,15 @@ int genphy_config_aneg(struct phy_device *phydev)
 			return ctl;
 
 		if (!(ctl & BMCR_ANENABLE) || (ctl & BMCR_ISOLATE))
-			changed = 1; /* do restart aneg */
+			changed = true; /* do restart aneg */
 	}
 
 	/* Only restart aneg if we are advertising something different
 	 * than we were before.
 	 */
-	if (changed > 0)
-		return genphy_restart_aneg(phydev);
-
-	return 0;
+	return changed ? genphy_restart_aneg(phydev) : 0;
 }
-EXPORT_SYMBOL(genphy_config_aneg);
+EXPORT_SYMBOL(__genphy_config_aneg);
 
 /**
  * genphy_aneg_done - return auto-negotiation status
@@ -1811,8 +1808,6 @@ int genphy_read_status(struct phy_device *phydev)
 	phydev->pause = 0;
 	phydev->asym_pause = 0;
 
-	linkmode_zero(phydev->lp_advertising);
-
 	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
 		if (phydev->is_gigabit_capable) {
 			lpagb = phy_read(phydev, MII_STAT1000);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 462b90b73..7117825ee 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1069,7 +1069,7 @@ int genphy_read_abilities(struct phy_device *phydev);
 int genphy_setup_forced(struct phy_device *phydev);
 int genphy_restart_aneg(struct phy_device *phydev);
 int genphy_config_eee_advert(struct phy_device *phydev);
-int genphy_config_aneg(struct phy_device *phydev);
+int __genphy_config_aneg(struct phy_device *phydev, bool changed);
 int genphy_aneg_done(struct phy_device *phydev);
 int genphy_update_link(struct phy_device *phydev);
 int genphy_read_status(struct phy_device *phydev);
@@ -1077,6 +1077,12 @@ int genphy_suspend(struct phy_device *phydev);
 int genphy_resume(struct phy_device *phydev);
 int genphy_loopback(struct phy_device *phydev, bool enable);
 int genphy_soft_reset(struct phy_device *phydev);
+
+static inline int genphy_config_aneg(struct phy_device *phydev)
+{
+	return __genphy_config_aneg(phydev, false);
+}
+
 static inline int genphy_no_soft_reset(struct phy_device *phydev)
 {
 	return 0;
-- 
2.22.0


