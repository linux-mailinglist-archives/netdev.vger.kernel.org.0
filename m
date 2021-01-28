Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F75306DE5
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhA1Gp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:45:57 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29386 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhA1Gpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:45:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816345; x=1643352345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j/e1p2gsEB8o2rRUpYQVXH49RlsT9/hWpFHmWN2Et/8=;
  b=raTpV+aInsAxp1fGG4JdKrm/JNLGaVoyv406fIAUDRZaPPe7FY4pzum0
   LYceiKDnVz+T8iNcyz1Om6RbAKDrXcBIZg3CAJGJFz1ofR9sQnipei2qr
   sWAnJou9Xc8cB0GlSipNzEopX26tUVMb/pH3peFlYQ6xXbcFWAER5kyBv
   gLAfrpGl6nqoOAxKH+AlIKFv65GwidibEDWIwqCCyz54atCHiS4e8hi5f
   sGDzGfxrqRVkWmwhJ+k9cOoa7vGD3gZQ8Lm8+zNgdw8HOCLfy9idmjITe
   NQBruPrtmeuByZ6ofHYHiSs+AmvK0MqJHwKx+Exd2ApcpBqP1/pFtzwI/
   g==;
IronPort-SDR: 0CMhMKY16TsvN74qMHpq0D+HtmOsehNdVj8naJB7jzCCz1YsUK9DKEzJzZDcYCHYbeO1/59Wyx
 hjHUjxuzuDsmlZHlGpV+z9tk4mySSrx+nWrlNmmOOWoLX470bT72nKATotOWTdkxG/ze/9BFmt
 epR1J/rJC5Vfw6yQVq7L1nerHIUsUy2E6WEmwkYO6V3bKjKKgrGUi+eUOUMBi+KfNlGdzpjcOa
 bq3mrk9YKEqNYEgXmxC1X4aHJg86zuTcncyX/XY4kee5edK26f1K4JGr17G/BVxNxtZf0109Eh
 28g=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="104520545"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:31 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:30 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:25 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 4/8] net: dsa: microchip: add support for phylink management
Date:   Thu, 28 Jan 2021 12:11:08 +0530
Message-ID: <20210128064112.372883-5-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support for phylink_validate() and reused KSZ commmon API for
phylink_mac_link_down() operation

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 40 ++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 41f7f5f8f435..b38735e36aef 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -327,6 +327,44 @@ static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
 	return FR_MAX_SIZE;
 }
 
+static void lan937x_phylink_validate(struct dsa_switch *ds, int port,
+				     unsigned long *supported,
+			  struct phylink_link_state *state)
+{
+	struct ksz_device *dev = ds->priv;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII ||
+		state->interface == PHY_INTERFACE_MODE_RMII ||
+		state->interface == PHY_INTERFACE_MODE_MII ||
+		lan937x_is_internal_tx_phy_port(dev, port)) {
+		phylink_set(mask, 10baseT_Half);
+		phylink_set(mask, 10baseT_Full);
+		phylink_set(mask, 100baseT_Half);
+		phylink_set(mask, 100baseT_Full);
+		phylink_set(mask, Autoneg);
+		phylink_set_port_modes(mask);
+		phylink_set(mask, Pause);
+		phylink_set(mask, Asym_Pause);
+	}
+	/*  For RGMII & SGMII interfaces */
+	if (phy_interface_mode_is_rgmii(state->interface) ||
+	    state->interface == PHY_INTERFACE_MODE_SGMII) {
+		phylink_set(mask, 1000baseT_Full);
+	}
+	/* For T1 PHY */
+	if (lan937x_is_internal_t1_phy_port(dev, port)) {
+		phylink_set(mask, 100baseT_Full);
+		phylink_set_port_modes(mask);
+	}
+
+	bitmap_and(supported, supported, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	bitmap_and(state->advertising, state->advertising, mask,
+		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
 const struct dsa_switch_ops lan937x_switch_ops = {
 	.get_tag_protocol	= lan937x_get_tag_protocol,
 	.setup			= lan937x_setup,
@@ -339,6 +377,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_fast_age		= ksz_port_fast_age,
 	.port_max_mtu		= lan937x_get_max_mtu,
 	.port_change_mtu	= lan937x_change_mtu,
+	.phylink_validate	= lan937x_phylink_validate,
+	.phylink_mac_link_down	= ksz_mac_link_down,
 };
 
 int lan937x_switch_register(struct ksz_device *dev)
-- 
2.25.1

