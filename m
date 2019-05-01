Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7C010D82
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 21:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbfEATyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 15:54:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37103 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbfEATyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 15:54:36 -0400
Received: by mail-wm1-f66.google.com with SMTP id y5so340535wma.2
        for <netdev@vger.kernel.org>; Wed, 01 May 2019 12:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=d3jpl+C5JEaZs2FB/XOPhQr31wXtOxs2vYCvGqm4U/o=;
        b=C+4Rg72UwhZfdPVWw4JMlXswROfy4+NxYlX4Npc5ISj9pzZiEabmzresyxume6gvG4
         Pzyo3DptUKS+q1Tcn63glTDwt4X2uIzI72Zyr6v/qJUf5ABjzW0VW61Vh7JM+DmoYe5j
         j13nG3hq1CFx7/gsvZtEdrhiPsdkYg9D3nhJkBdnQb41fQzukUoCRC9aMqAz9tQhK7mg
         dnxbEg1QvUdGFTdQbdgnpbg6iYLWKJpFhwK+1cc94ARGh0jEd/otCbNqsS8W6MOS0596
         V2Pl/GZgmqIMh1bqUXWTL2H6JvVn9N16WPjpcuWczoaEj09PvwV+2svIbDF2i5f4wxQd
         O3Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=d3jpl+C5JEaZs2FB/XOPhQr31wXtOxs2vYCvGqm4U/o=;
        b=FDBPY9y6EBxcolVjNV9y/0r4ApVZYgYL76XYVFJrMQppZThi10wgBi9DgaQD8uuRKM
         vfc4Y5Vzi9HBbqF/CZ1EUbFkw/SKzVOHUQLTBDktlHqZSpURtGPNiIDKyEDGVG/PvPbe
         I48/X2WjqeF1pystcnhE3HQYOag5rWyi2en6yLyU1ESt3RLlNnlLgYd72YLP2NPQMXIy
         Uxdw7q3ZuvctyhG+z1x3xuEwdFJN9D9Bbd19sepz4w8H9c0WFDf6OEbuXp3/DOJN/G9p
         PTyVq2lQWAhdAdCiy80atIVYKDu/d6YI3WCYm8cUE23HgBpDjxAdpHCWbPHBQclCjoKp
         4IGQ==
X-Gm-Message-State: APjAAAVZqQ6kA1xrJ03/46SErBxoVoAbCUvJcPEFLcKQsWo7SlLvza/H
        6mS4UyrIkTDLYTUIZZnUSKPbBwfPD2I=
X-Google-Smtp-Source: APXvYqzrJStnVUI2fTc4uaGesG2cRsZ1AMefsqPukPu4cjzSLMJCG3vSIIRbB3tvtW93CUFfSYZ/6g==
X-Received: by 2002:a1c:44d7:: with SMTP id r206mr7339493wma.129.1556740474280;
        Wed, 01 May 2019 12:54:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:a160:62e9:d01f:fc0a? (p200300EA8BD45700A16062E9D01FFC0A.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:a160:62e9:d01f:fc0a])
        by smtp.googlemail.com with ESMTPSA id s18sm5258331wmc.41.2019.05.01.12.54.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 12:54:33 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net] net: phy: fix phy_validate_pause
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <9d05d207-d6f2-5771-5cf4-6d8342a4fb30@gmail.com>
Date:   Wed, 1 May 2019 21:54:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have valid scenarios where ETHTOOL_LINK_MODE_Pause_BIT doesn't
need to be supported. Therefore extend the first check to check
for rx_pause being set.

See also phy_set_asym_pause:
rx=0 and tx=1: advertise asym pause only
rx=0 and tx=0: stop advertising both pause modes

The fixed commit isn't wrong, it's just the one that introduced the
linkmode bitmaps.

Fixes: 3c1bcc8614db ("net: ethernet: Convert phydev advertize and supported from u32 to link mode")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/phy_device.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 544b98b34..7764a8c30 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2116,11 +2116,14 @@ bool phy_validate_pause(struct phy_device *phydev,
 			struct ethtool_pauseparam *pp)
 {
 	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
-			       phydev->supported) ||
-	    (!linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
-				phydev->supported) &&
-	     pp->rx_pause != pp->tx_pause))
+			       phydev->supported) && pp->rx_pause)
 		return false;
+
+	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+			       phydev->supported) &&
+	    pp->rx_pause != pp->tx_pause)
+		return false;
+
 	return true;
 }
 EXPORT_SYMBOL(phy_validate_pause);
-- 
2.21.0

