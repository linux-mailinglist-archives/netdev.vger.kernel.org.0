Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCB82F4AD1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbhAML6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 06:58:18 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:39618 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbhAML6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 06:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610539097; x=1642075097;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=kyI6fnFUneAqkE2szMtIRF09ZE7CRfZRtPfxT1qCXGU=;
  b=aL9QuOwHhODO9+TEIVQAmVci8aydDzjyQB2czYPYDSHkWaEHhCnukDap
   VspWyzCELPjYGcB5edZUUDtQCsnpV44vbcRPJylATVtEBXDEbrmzhxYaR
   b/BOJRSeJXpJQuJKuEyxzvSd16TLvqsOCPaINwl61VBYlL9mC9nStDFrq
   p8om1+396rYJFKp973NiwUz4+HRMJZ6EE//iZktCUBpsQxqBWolLQIiC4
   S7ggbwVdFj8p9GtpuNkerpLsTNC+Ikqed1pFVNFycvgc2yu34on4TeBSV
   63CJnNGk4AK8TIgN3t48o78jtlwrUMus+GTDL+07z+Zom3v1wC3+M43xy
   Q==;
IronPort-SDR: vCxkMK+dtOB/z5fs4QsD2tZlEB9zjnFuQ9mZoshtXtQOLKVMUFbHaFGxv5r2rgAzt/ND1vE2j1
 BNQf36qRhCSYcXSi7fa1ooeNimMIpT9kHhkQy4O4dex25iSHAo/pAbzP20gCKg3jOpgb6UWXGU
 6li8OyIXOMxR7DuyyPoxYD92HDmzU7L7/eSOPcTHz+qkHL+vdUwP/fP8mw7WKk+rW+Dw9XhaUk
 jZgdO7X5k+s3Kk9I7+vE+T9z0LBdLHereyVg5DW3LQ0lJTJ29yrscnnt17QU+MqcoazUghR/y9
 kGI=
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="105823816"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2021 04:57:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 04:57:01 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 13 Jan 2021 04:56:59 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v2 1/2] net: phy: Add 100 base-x mode
Date:   Wed, 13 Jan 2021 12:56:25 +0100
Message-ID: <20210113115626.17381-2-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
References: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparx-5 supports this mode and it is missing in the PHY core.

Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 Documentation/networking/phy.rst | 5 +++++
 include/linux/phy.h              | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/Documentation/networking/phy.rst b/Documentation/networking/phy.rst
index b2f7ec794bc8..399f17976a6c 100644
--- a/Documentation/networking/phy.rst
+++ b/Documentation/networking/phy.rst
@@ -286,6 +286,11 @@ Some of the interface modes are described below:
     Note: due to legacy usage, some 10GBASE-R usage incorrectly makes
     use of this definition.
 
+``PHY_INTERFACE_MODE_100BASEX``
+    This defines IEEE 802.3 Clause 24.  The link operates at a fixed data
+    rate of 125Mpbs using a 4B/5B encoding scheme, resulting in an underlying
+    data rate of 100Mpbs.
+
 Pause frames / flow control
 ===========================
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9effb511acde..24fcc6456a9e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -104,6 +104,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_MOCA: Multimedia over Coax
  * @PHY_INTERFACE_MODE_QSGMII: Quad SGMII
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
+ * @PHY_INTERFACE_MODE_100BASEX: 100 BaseX
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
@@ -135,6 +136,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_MOCA,
 	PHY_INTERFACE_MODE_QSGMII,
 	PHY_INTERFACE_MODE_TRGMII,
+	PHY_INTERFACE_MODE_100BASEX,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
 	PHY_INTERFACE_MODE_RXAUI,
@@ -217,6 +219,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "usxgmii";
 	case PHY_INTERFACE_MODE_10GKR:
 		return "10gbase-kr";
+	case PHY_INTERFACE_MODE_100BASEX:
+		return "100base-x";
 	default:
 		return "unknown";
 	}
-- 
2.17.1

