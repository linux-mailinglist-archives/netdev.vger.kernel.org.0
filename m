Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49061E81
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730805AbfGHMe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:34:26 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35554 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfGHMe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:34:26 -0400
Received: by mail-pl1-f195.google.com with SMTP id w24so8205012plp.2;
        Mon, 08 Jul 2019 05:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ArpUmrHHBFx5bD0LIxUTdEY5clgZRpqyjNAxZpDPt5s=;
        b=FLDb3RQjrqS80g8SocCGkpBtBUhLrL7LVWoDIB6S6KXskaCiwggA6DhRzp0XSuDEWP
         CBPWkzbnLLzASSpFC9ot5cTmcTTFgEnJE7nT0wUxihFgorgAaLB7AOUvMGrAr13WQadh
         AtpXKAUCIRStRTuI5HyyqxpwKrmtd5DgaQ0xQHkRJ2hMBA7j7RjXBkMufSOJ1WMX19gj
         bUCf6clIk/vZekzJfs1IibS1gcvXNyZWW/AwOzzJpOCVzqictDRN7ILc0cWZIoe4zwqs
         2wwLALPcmH+1HnlZ/Yj2eLwb0Ih5YLJWnFbDT47VxUUT4zw6JSOqlgGgQGi9lYezS7IS
         yg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ArpUmrHHBFx5bD0LIxUTdEY5clgZRpqyjNAxZpDPt5s=;
        b=Zx9exd1gjPW1W82kKTGjBQTggI+UR9pxPxlR/M2UOhxtlbiy9QlAeA4nrh29wvlYtA
         PeKW87xFGZJyeliwmKdNXAVfvTUuBhjXbKEG8yK05G9ACOTMC9+NRSkRwZq4RTBebYlg
         Ja/Y1wE8AVy2UeNHrvZNSBAlybUjiiamIIoppHmaDHMftSKYR5Qv+OaEj7X0LqdwKs86
         reDB6dLjPM9uXukCM41ueoYZ63Xuv72mmEm3+yYqMXQ5xg1peCELztXsFWj8LF4S03bh
         vUHxo3B9o9tc2Pf40H49yqgaikaw7WezBX1BjnF7V9QJfwGFNC2A6tDYbBNEE/HXMVg8
         +cxg==
X-Gm-Message-State: APjAAAUH0vuy6oFldSRZOBvf5asKtEza3bCHZuNjYkueYjVdNMDr4ewz
        JfSLBJ7WhKijGi+wmsBPzE2kyinXKkM=
X-Google-Smtp-Source: APXvYqx/0oIpfjHn1PzBLCg3X+/OP7H+bK32tmaheN9gUhk+d1xkmbYrjC0WvI7tHEpk88OM6QlKMw==
X-Received: by 2002:a17:902:ac1:: with SMTP id 59mr24777149plp.168.1562589265440;
        Mon, 08 Jul 2019 05:34:25 -0700 (PDT)
Received: from hfq-skylake.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.googlemail.com with ESMTPSA id q19sm20679649pfc.62.2019.07.08.05.34.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 05:34:25 -0700 (PDT)
From:   Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Fuqian Huang <huangfq.daxian@gmail.com>
Subject: [PATCH 14/14] net: phy: Make use of linkmode_mod_bit helper
Date:   Mon,  8 Jul 2019 20:34:17 +0800
Message-Id: <20190708123417.12265-1-huangfq.daxian@gmail.com>
X-Mailer: git-send-email 2.11.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linkmode_mod_bit is introduced as a helper function to set/clear
bits in a linkmode.
Replace the if else code structure with a call to the helper
linkmode_mod_bit.

Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
---
 drivers/net/phy/phy.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index e8885429293a..75b8e5aff747 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -297,12 +297,8 @@ int phy_ethtool_sset(struct phy_device *phydev, struct ethtool_cmd *cmd)
 
 	linkmode_copy(phydev->advertising, advertising);
 
-	if (AUTONEG_ENABLE == cmd->autoneg)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-				 phydev->advertising);
-	else
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-				   phydev->advertising);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 phydev->advertising, AUTONEG_ENABLE == cmd->autoneg);
 
 	phydev->duplex = cmd->duplex;
 
@@ -352,12 +348,8 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
 
 	linkmode_copy(phydev->advertising, advertising);
 
-	if (autoneg == AUTONEG_ENABLE)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-				 phydev->advertising);
-	else
-		linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
-				   phydev->advertising);
+	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			 phydev->advertising, autoneg == AUTONEG_ENABLE);
 
 	phydev->duplex = duplex;
 
-- 
2.11.0

