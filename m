Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61526417E4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 00:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436692AbfFKWGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 18:06:16 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:35322 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405693AbfFKWGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 18:06:15 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x5BM6Cpf012446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jun 2019 16:06:12 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x5BM6BUB043560
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 11 Jun 2019 16:06:11 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: phy: Add more 1000BaseX support detection
Date:   Tue, 11 Jun 2019 16:06:09 -0600
Message-Id: <1560290769-11858-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit "net: phy: Add detection of 1000BaseX link mode support" added
support for not filtering out 1000BaseX mode from the PHY's supported
modes in genphy_config_init, but we have to make a similar change in
genphy_read_abilities in order to actually detect it as a supported mode
in the first place. Add this in.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/phy/phy_device.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 03c885e..5387890 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1984,6 +1984,8 @@ int genphy_read_abilities(struct phy_device *phydev)
 				 phydev->supported, val & ESTATUS_1000_TFULL);
 		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
 				 phydev->supported, val & ESTATUS_1000_THALF);
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				 phydev->supported, val & ESTATUS_1000_XFULL);
 	}
 
 	return 0;
-- 
1.8.3.1

