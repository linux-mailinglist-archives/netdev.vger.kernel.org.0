Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CA763BB1D
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 19:37:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbfFJRho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 13:37:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37914 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387948AbfFJRho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 13:37:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so180273wmj.3
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 10:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=x1/Z1gbyY9Ep7K9uslx9ZgJWVC+nkHq8dgy0pRf2wlI=;
        b=QmX3I20tsSra6HRCrvHjqBMzO95BcEt81X7LhFX/03WMmG+0BFFRe2efX9SyJ753jn
         xhLgZJZwHB4QfaVktkolR9uNryACb47D+fQZ563fJJgrL7UVIYIVQOF0oIH8n2be35YI
         9XKt+CDdEaYS+mDyQ1QsaFjBuHxb2pUIqpzQQERJCI4YYD2fE02B7F7RoV9Fj/JiVJID
         2htxEJocAb8ow7TuBQ9CZY90XVLF5JB81QnP2CfJL16mqX4OwPrUhOrVWtKU9ffhbcla
         PCm//Ju/OYVVC9nGqyUXVwWJzfPiAruAG9YjHoj+e7bkkpCvUM66x7nt8pKsb5/qRho3
         gsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=x1/Z1gbyY9Ep7K9uslx9ZgJWVC+nkHq8dgy0pRf2wlI=;
        b=ThkIrmFWsWd/xuYNefs9f9pqsW+LyUjmlekMijRFNWdYZmbBoahJwWg9WEOxgkQPTF
         ODoJRZ3E1XpieVFXxqq8Hv0VDMVvJmr02vOpHtxtnKucF5QvrfsMCVNbPgpABaFnNAIL
         zDWwPtpfvLPMlxea9P4nEh+xDdr6gbmBsqCkVKmCCblrtR56gbT8BPTWg6KI1i3cSnfn
         K/CivfU1E+nSxgdAAHY577z/2A2Jk8sVLqOPI0q/pe0y63ZkPSpz8asO3UlDKaDu2BLJ
         iY9vU9xZErrKfaueSAULz0coUkkIpsifxUgUvrkOPxH6jDC9FvJ/PrEAeZJ7n6r+yQVo
         synw==
X-Gm-Message-State: APjAAAUHCf8ixlq5jQ/i0M1+1W26chNMrYYGfjyETBAYGYgzxo/A+fP6
        8HET4kUd1y+O+3YCaPJm9KofuPXp
X-Google-Smtp-Source: APXvYqwI2XpbeJmnvLYTBB3JKw8TByqyrQBFm7DSLzfFdqDtbAVcSyTMOsMJs/LOhswJ0u5pEVrgIA==
X-Received: by 2002:a7b:c933:: with SMTP id h19mr15110290wml.52.1560188261942;
        Mon, 10 Jun 2019 10:37:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:8cc:c330:790b:34f7? (p200300EA8BF3BD0008CCC330790B34F7.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:8cc:c330:790b:34f7])
        by smtp.googlemail.com with ESMTPSA id y38sm19621680wrd.41.2019.06.10.10.37.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 10:37:41 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH RFC] net: phy: add state PERM_FAIL
Message-ID: <8e4cd03b-2c0a-ada9-c44d-2b5f5bd4f148@gmail.com>
Date:   Mon, 10 Jun 2019 19:37:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This RFC patch is a follow-up to discussion [0]. In cases like missing
PHY firmware we may want to keep the PHY from being brought up, but
still allow MDIO access. Setting state PERM_FAIL in the probe or
config_init callback allows to achieve this.

[0] https://marc.info/?t=155973142200002&r=1&w=2

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy.c | 10 ++++++++--
 include/linux/phy.h   |  5 +++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index d91507650..889437512 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -44,6 +44,7 @@ static const char *phy_state_to_str(enum phy_state st)
 	PHY_STATE_STR(RUNNING)
 	PHY_STATE_STR(NOLINK)
 	PHY_STATE_STR(HALTED)
+	PHY_STATE_STR(PERM_FAIL)
 	}
 
 	return NULL;
@@ -744,7 +745,8 @@ static void phy_error(struct phy_device *phydev)
 	WARN_ON(1);
 
 	mutex_lock(&phydev->lock);
-	phydev->state = PHY_HALTED;
+	if (phydev->state != PHY_PERM_FAIL)
+		phydev->state = PHY_HALTED;
 	mutex_unlock(&phydev->lock);
 
 	phy_trigger_machine(phydev);
@@ -897,7 +899,10 @@ void phy_start(struct phy_device *phydev)
 {
 	mutex_lock(&phydev->lock);
 
-	if (phydev->state != PHY_READY && phydev->state != PHY_HALTED) {
+	if (phydev->state == PHY_PERM_FAIL) {
+		phydev_warn(phydev, "Can't start PHY because it's in state PERM_FAIL\n");
+		goto out;
+	} else if (phydev->state != PHY_READY && phydev->state != PHY_HALTED) {
 		WARN(1, "called from state %s\n",
 		     phy_state_to_str(phydev->state));
 		goto out;
@@ -934,6 +939,7 @@ void phy_state_machine(struct work_struct *work)
 	switch (phydev->state) {
 	case PHY_DOWN:
 	case PHY_READY:
+	case PHY_PERM_FAIL:
 		break;
 	case PHY_UP:
 		needs_aneg = true;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index d0af7d37f..7f47b6605 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -300,11 +300,16 @@ struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr);
  * HALTED: PHY is up, but no polling or interrupts are done. Or
  * PHY is in an error state.
  * - phy_start moves to UP
+ *
+ * PERM_FAIL: A permanent failure was detected and PHY isn't allowed to be
+ * brought up. Still we don't want to fail in probe to allow MDIO access
+ * to the PHY, e.g. to load missing firmware.
  */
 enum phy_state {
 	PHY_DOWN = 0,
 	PHY_READY,
 	PHY_HALTED,
+	PHY_PERM_FAIL,
 	PHY_UP,
 	PHY_RUNNING,
 	PHY_NOLINK,
-- 
2.21.0

