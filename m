Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6191185373
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:11:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388972AbfHGTL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:11:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50462 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbfHGTL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:11:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so1115919wml.0
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 12:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=QGcp4Z37Rc777Y2+z6GYZGFbXSg1BtttO3ewxgOVXoM=;
        b=kfvzy6BLxOfM4RcGBgKxXEB4uGXLkInDL0JwicTFyFGZdidvLhTfSxZ9OEKxasVMJq
         KmhVd3Zx5wpFfGwCuiviGmHsugrbFR5RhWjk7VsZXtDsnd7b7fy2K8JZ7pGlDvQP3InZ
         LBnuq2AWivJO2kWpD/IRQRjPaBRwf/EYP+3wvIJA3UKb1iC4JnNPc9mSGENkltu1NxEW
         1KHi4jzCbdt1kvvUwGVMR3GBtjRoZZ1nZvfFZb7H5lBZ8+7GfZLsb7TSIKDQYGc5Bz9X
         db9ngwjF3Bcp5008D4z2l/e54xLROs5RJsAuLl/45hVmwqPZ6W9opAJSjYQJYSC1C0n8
         Dltg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=QGcp4Z37Rc777Y2+z6GYZGFbXSg1BtttO3ewxgOVXoM=;
        b=uhjuPFFogPXS81MkIU4VnVhoCTZYgF6Gt16izN8DIfnloibuo100cjTzb0BWv5n2QG
         SorEyMJNBknghXXJoIrWtRMWSAHcESwarI2RJ4GjNqB6EhQC2IFoFuKeybTTbb4X4BpE
         7RDkJvDoO3MR7RgE/e+5/yfwZon0dsxetlsyMGYvEY74wd3FlNiKXB5LWrc60NCKSkAS
         worOcxOkPDvQ3yvebPhD5bKb5QPzeG4u7d2e3nmZ4rfrpytrD2GebgcwipqNK5sqgVU6
         RUBKqPqTAAYd3wAP/g9XsCA/kyuBa2tgGsvqiQhn3gSlEYoF/oCkWeYrfQRfSmzYWHoW
         +iIw==
X-Gm-Message-State: APjAAAV49eI5THh10ESgQZ9JjEnmViXoV1w7avphWfruicSYcdP5L3TH
        BgLvlC1Hlcerdht99DUeHNczw2Ai
X-Google-Smtp-Source: APXvYqzcBSRywjz4mLswvavdCc4Q2IM1Ph2zTe5lamMnRInjvi0gGTUX6lOP2fiIUMD15blAgy1A6g==
X-Received: by 2002:a1c:1f4e:: with SMTP id f75mr1209031wmf.137.1565205085557;
        Wed, 07 Aug 2019 12:11:25 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:c422:a07f:e697:f900? (p200300EA8F2F3200C422A07FE697F900.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:c422:a07f:e697:f900])
        by smtp.googlemail.com with ESMTPSA id g7sm1679282wmg.8.2019.08.07.12.11.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:11:25 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RFC] net: phy: add support for clause 37 auto-negotiation
Message-ID: <e9fafe30-598a-ca9d-3959-c388b7e707c9@gmail.com>
Date:   Wed, 7 Aug 2019 21:11:18 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for clause 37 1000Base-X auto-negotiation.
It's compile-tested only as I don't have fiber equipment.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 139 +++++++++++++++++++++++++++++++++++
 include/linux/phy.h          |   5 ++
 2 files changed, 144 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 7ddd91df9..f24e3e7e5 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1617,6 +1617,40 @@ static int genphy_config_advert(struct phy_device *phydev)
 	return changed;
 }
 
+/**
+ * genphy_c37_config_advert - sanitize and advertise auto-negotiation parameters
+ * @phydev: target phy_device struct
+ *
+ * Description: Writes MII_ADVERTISE with the appropriate values,
+ *   after sanitizing the values to make sure we only advertise
+ *   what is supported.  Returns < 0 on error, 0 if the PHY's advertisement
+ *   hasn't changed, and > 0 if it has changed. This function is intended
+ *   for Clause 37 1000Base-X mode.
+ */
+static int genphy_c37_config_advert(struct phy_device *phydev)
+{
+	u16 adv = 0;
+
+	/* Only allow advertising what this PHY supports */
+	linkmode_and(phydev->advertising, phydev->advertising,
+		     phydev->supported);
+
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+			      phydev->advertising))
+		adv |= ADVERTISE_1000XFULL;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+			      phydev->advertising))
+		adv |= ADVERTISE_1000XPAUSE;
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			      phydev->advertising))
+		adv |= ADVERTISE_1000XPSE_ASYM;
+
+	return phy_modify_changed(phydev, MII_ADVERTISE,
+				  ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
+				  ADVERTISE_1000XHALF | ADVERTISE_1000XPSE_ASYM,
+				  adv);
+}
+
 /**
  * genphy_config_eee_advert - disable unwanted eee mode advertisement
  * @phydev: target phy_device struct
@@ -1726,6 +1760,54 @@ int genphy_config_aneg(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_config_aneg);
 
+/**
+ * genphy_c37_config_aneg - restart auto-negotiation or write BMCR
+ * @phydev: target phy_device struct
+ *
+ * Description: If auto-negotiation is enabled, we configure the
+ *   advertising, and then restart auto-negotiation.  If it is not
+ *   enabled, then we write the BMCR. This function is intended
+ *   for use with Clause 37 1000Base-X mode.
+ */
+int genphy_c37_config_aneg(struct phy_device *phydev)
+{
+	int err, changed;
+
+	if (AUTONEG_ENABLE != phydev->autoneg)
+		return genphy_setup_forced(phydev);
+
+	err = phy_modify(phydev, MII_BMCR, BMCR_SPEED1000 | BMCR_SPEED100,
+			 BMCR_SPEED1000);
+	if (err)
+		return err;
+
+	changed = genphy_c37_config_advert(phydev);
+	if (changed < 0) /* error */
+		return changed;
+
+	if (!changed) {
+		/* Advertisement hasn't changed, but maybe aneg was never on to
+		 * begin with?  Or maybe phy was isolated?
+		 */
+		int ctl = phy_read(phydev, MII_BMCR);
+
+		if (ctl < 0)
+			return ctl;
+
+		if (!(ctl & BMCR_ANENABLE) || (ctl & BMCR_ISOLATE))
+			changed = 1; /* do restart aneg */
+	}
+
+	/* Only restart aneg if we are advertising something different
+	 * than we were before.
+	 */
+	if (changed > 0)
+		return genphy_restart_aneg(phydev);
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_c37_config_aneg);
+
 /**
  * genphy_aneg_done - return auto-negotiation status
  * @phydev: target phy_device struct
@@ -1864,6 +1946,63 @@ int genphy_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_read_status);
 
+/**
+ * genphy_c37_read_status - check the link status and update current link state
+ * @phydev: target phy_device struct
+ *
+ * Description: Check the link, then figure out the current state
+ *   by comparing what we advertise with what the link partner
+ *   advertises. This function is for Clause 37 1000Base-X mode.
+ */
+int genphy_c37_read_status(struct phy_device *phydev)
+{
+	int lpa, err, old_link = phydev->link;
+
+	/* Update the link, but return if there was an error */
+	err = genphy_update_link(phydev);
+	if (err)
+		return err;
+
+	/* why bother the PHY if nothing can have changed */
+	if (phydev->autoneg == AUTONEG_ENABLE && old_link && phydev->link)
+		return 0;
+
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->pause = 0;
+	phydev->asym_pause = 0;
+
+	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
+		lpa = phy_read(phydev, MII_LPA);
+		if (lpa < 0)
+			return lpa;
+
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+				 phydev->lp_advertising, lpa & LPA_LPACK);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				 phydev->lp_advertising, lpa & LPA_1000XFULL);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+				 phydev->lp_advertising, lpa & LPA_1000XPAUSE);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				 phydev->lp_advertising,
+				 lpa & LPA_1000XPAUSE_ASYM);
+
+		phy_resolve_aneg_linkmode(phydev);
+	} else if (phydev->autoneg == AUTONEG_DISABLE) {
+		int bmcr = phy_read(phydev, MII_BMCR);
+
+		if (bmcr < 0)
+			return bmcr;
+
+		if (bmcr & BMCR_FULLDPLX)
+			phydev->duplex = DUPLEX_FULL;
+		else
+			phydev->duplex = DUPLEX_HALF;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_c37_read_status);
+
 /**
  * genphy_soft_reset - software reset the PHY via BMCR_RESET bit
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 462b90b73..36cbdfe84 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1077,6 +1077,11 @@ int genphy_suspend(struct phy_device *phydev);
 int genphy_resume(struct phy_device *phydev);
 int genphy_loopback(struct phy_device *phydev, bool enable);
 int genphy_soft_reset(struct phy_device *phydev);
+
+/* Clause 37 */
+int genphy_c37_aneg_done(struct phy_device *phydev);
+int genphy_c37_read_status(struct phy_device *phydev);
+
 static inline int genphy_no_soft_reset(struct phy_device *phydev)
 {
 	return 0;
-- 
2.22.0

