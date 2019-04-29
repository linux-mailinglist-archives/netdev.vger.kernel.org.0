Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 471AAEB71
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 22:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729402AbfD2UOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 16:14:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51965 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729389AbfD2UOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 16:14:25 -0400
Received: by mail-wm1-f68.google.com with SMTP id 4so905829wmf.1
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 13:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rlvSpMWmvttRAfZM67VaQnwQ1rlcCLNlg9KTleGKjzU=;
        b=D11o1vRX7b1UMcDymDNLQwgCQ6COAxTnk3axGk86dr6mWyjb1rzgr9GHrYmv4/nBGl
         JoUBdrJrXeEmWyBkasHBr7DKStgM88sUVu1ztj3olXwAp1im3rCvJkz5CzqkIcoRHKBR
         Pc9k0bp29amhIcoX4bOt7/1Wo19lT+Vick5DindcLo2DGnndHc7mDsc2l82j6pf0iXTW
         4FeGiiJ6mHx+eRqy3nELL2EgY5IN/Uk+81raa/B9/tGOSR/7jTDLcyqs7yNHc1Vjt2VJ
         vtJpMEjvOk8PU8LCy8St1cN0HCKdJknCZmZeOzK8sOKdViZzFLwfZ26VN+/OVMJgZEip
         vpXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rlvSpMWmvttRAfZM67VaQnwQ1rlcCLNlg9KTleGKjzU=;
        b=METYo7ykwxlwiHFsXyGxPZjIoPaKZanBQdagJurQNxvZJjbmAf3cyV71bAcg44oRDM
         0dHuT3OYR6Bujl/lwPmOj2qgVeqOr1otKBxC8k7ycNA/tygWsJLtMclmxICCfN/1r++B
         Jo2xip4F9edq+hrSNKqfwqb3C1QP4kWTtg9FvU2q2loAAg2NJgKVGOlu1buMGd2aLDMS
         K6sGv4P9w4gQIpiKpNBF5LmOGQTX20JAhFS8cp9bw2B1gJ/++PKnFQBhPM6MXI1b1Hmz
         SdRuwj3fdQ2eBn49fOwYupJjPbrmbrptTOBfM1tWvjhk7kA3l8G8is0CxaIaIsUVsb4r
         lEPA==
X-Gm-Message-State: APjAAAX7DR77AuILdFJIAr5owaxEE3neth3JhLBAx/UPMFVPGg+4hNHx
        VmtgdbE2/ckEU1aaZFwvi6CYafnct8s=
X-Google-Smtp-Source: APXvYqyeHz0eJ/N3KbWT0A3PmNiYDkU2/woqfuR4NOFOg54SbHjMXx9sDrLO9WhirAJLcu9pymIWjA==
X-Received: by 2002:a1c:1941:: with SMTP id 62mr534000wmz.100.1556568863709;
        Mon, 29 Apr 2019 13:14:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:2492:3326:fa98:92d1? (p200300EA8BD4570024923326FA9892D1.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:2492:3326:fa98:92d1])
        by smtp.googlemail.com with ESMTPSA id e6sm26265662wrc.96.2019.04.29.13.14.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 13:14:23 -0700 (PDT)
Subject: [PATCH net-next 2/2] net: phy: improve phy_set_sym_pause and
 phy_set_asym_pause
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
Message-ID: <f5521d12-bc72-8ed7-eeda-888185c6cee6@gmail.com>
Date:   Mon, 29 Apr 2019 22:14:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should consider what is supported, and we shouldn't mess with
phydev->supported. In addition make sure that phy_set_sym_pause()
clears the asym pause bit in phydev->advertising.
In phy_set_sym_pause() use the same mechanism as in
phy_set_asym_pause() to restart autoneg if needed.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 544b98b34..eb430f2a8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2054,13 +2054,24 @@ EXPORT_SYMBOL(phy_support_asym_pause);
 void phy_set_sym_pause(struct phy_device *phydev, bool rx, bool tx,
 		       bool autoneg)
 {
-	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->supported);
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
+	bool sym_pause_supported;
+
+	sym_pause_supported = linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+						phydev->supported);
+
+	linkmode_copy(oldadv, phydev->advertising);
 
-	if (rx && tx && autoneg)
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Pause_BIT, phydev->advertising);
+	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			   phydev->advertising);
+
+	if (rx && tx && autoneg && sym_pause_supported)
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-				 phydev->supported);
+				 phydev->advertising);
 
-	linkmode_copy(phydev->advertising, phydev->supported);
+	if (!linkmode_equal(oldadv, phydev->advertising) && phydev->autoneg)
+		phy_start_aneg(phydev);
 }
 EXPORT_SYMBOL(phy_set_sym_pause);
 
@@ -2078,6 +2089,11 @@ EXPORT_SYMBOL(phy_set_sym_pause);
 void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
 {
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
+	bool asym_pause_supported;
+
+	asym_pause_supported =
+		linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				  phydev->supported);
 
 	linkmode_copy(oldadv, phydev->advertising);
 
@@ -2086,14 +2102,14 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
 	linkmode_clear_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 			   phydev->advertising);
 
-	if (rx) {
+	if (rx && asym_pause_supported) {
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 				 phydev->advertising);
 		linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 				 phydev->advertising);
 	}
 
-	if (tx)
+	if (tx && asym_pause_supported)
 		linkmode_change_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 				    phydev->advertising);
 
-- 
2.21.0


