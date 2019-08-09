Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9411882D4
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406765AbfHISpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:45:34 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42094 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfHISpd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:45:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id b16so2415025wrq.9
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 11:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JlzXuMB0ojGNmWrguCBaCHIMu+x/Uzany0ljcwd6ibM=;
        b=oMGPjj28VfaRblBy2Wzeoic56a4lZmiXNZslM1bjM3U727/TUtutQgyaiq/Vg3OWoL
         /5Pd3HH5uKe3NharWqGkywjeCGTaz7WRtaKbsv/Pz0+jOIbFGJDf8P85EeqwcrlygYIZ
         6BbOco5j17cba4r4vv3n+hEZVMp0IQAHNLeJsmKl1pW30PrpymuaSFCH+4TlcPhUrMgr
         hEG870K8sqQe4ce3dOhsoH+v/oUyOcmuBLiW5/c1Sb2NjC4W6F8BVqOdMl1qtShGrs59
         VgPmrqJ6T8GktRSJMnw68vjF4UsqH9eWWtu2Vo44sXm1ZuQAtvdEYlr4bu4OKT5GNvMj
         GbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JlzXuMB0ojGNmWrguCBaCHIMu+x/Uzany0ljcwd6ibM=;
        b=VRKdM19Vz5w1ZZRqDowPYUwaGxURWS/bb1Lfa3klYnirffUQoQ69XGQmRwdfXl6WaS
         64LdOtrkRZVuEHIn8uQJd1gSzmaBP7bxL0AW/+xXiDCddBR7GVBaWD6bfh9VpoM3Emoa
         dDf0PQVi4BOOS43lbYbp6+hJ3xt0crDRqCL6iwrTsTA5ZV6iQ+l5QQkeHj7YV4CiFGdi
         O8WCQ2eDtiMkrgSi1i78AGN09cFHERFGNYgUMpVGXCdci1C5lVUpE7O15bxc0ykRz7LW
         5VanJ6qPgjH59UBLiEYzMvlhEaXEfJESXpX/4UC3dVJRPLDhJNn+ghh6eOPe8PXTSQS0
         EMRg==
X-Gm-Message-State: APjAAAVPFwrO841UW8NFNZF7CmMM3GUidc3Cv8IL71jvjZ3xiRYpH7et
        LG6ZTUGZ65CgFFWUOGAMBoL/ZZfq
X-Google-Smtp-Source: APXvYqwgcL7EeWjFcvumIfC2eW3cs4afrNbCOqP76Thv5qJKDME7kCyXeS42TP36XC53ICq8fTEkYQ==
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr24036181wra.328.1565376330158;
        Fri, 09 Aug 2019 11:45:30 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id k124sm9628925wmk.47.2019.08.09.11.45.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 11:45:29 -0700 (PDT)
Subject: [PATCH net-next v2 2/4] net: phy: prepare phylib to deal with PHY's
 extending Clause 22
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
Message-ID: <8c5e499d-7952-0920-339b-82e799c3358f@gmail.com>
Date:   Fri, 9 Aug 2019 20:43:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
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
 drivers/net/phy/phy_device.c | 27 ++++++++++++---------------
 include/linux/phy.h          |  8 +++++++-
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a70a98dc9..b039632de 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1671,18 +1671,20 @@ int genphy_restart_aneg(struct phy_device *phydev)
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
@@ -1690,10 +1692,10 @@ int genphy_config_aneg(struct phy_device *phydev)
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
@@ -1703,18 +1705,15 @@ int genphy_config_aneg(struct phy_device *phydev)
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
@@ -1801,8 +1800,6 @@ int genphy_read_status(struct phy_device *phydev)
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


