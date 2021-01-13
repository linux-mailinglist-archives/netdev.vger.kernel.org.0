Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6182E2F4AD3
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 13:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727450AbhAML60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 06:58:26 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:22207 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbhAML60 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 06:58:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610539105; x=1642075105;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=KO1w7xRaJxa2Jb3V9ESyr8eR3uoe0LjjTbeTHnAaXg0=;
  b=UOytp/BeKE9rPm8wxUheeDwujyu2XMKSO1pmDvRhsz8kEXoTQoBMnstS
   D7lKMea2iZnlAXlfyFXHZVZEDXnFfhki9Ri8POUFce01OJRBpjMWJYJZO
   HG2P59jPmx6Pene8r07h2EndtMKixyoH13m9uY3wThTwZeB1k6lw/Tehz
   wzj7RdgBhzt34tTzlQ4DwKYNNX9a5sCwPmR6xdRaWt0FbkwGJSFm8Knic
   upH14lHbuMkS085fuh9GNktS3TPq8/omnvRLqo+AtGACt7559hs2pfZG8
   80znmVTf1M7ZDWVTv4I2hgjjjPqMBGHdHXuyYuueqHfms1M8l+gK2yAV2
   Q==;
IronPort-SDR: U8DT2wDzGcGwYDdYV3NOgOsY/3Gc7mPYhl1+1pwWzDm9FP/ZQ9DevX+kwVGQ8M/FAQkgdZiCWM
 1rJjk78s4EgHiFnmv81tGbPULuv8xy4q1WOAvPDLWGv6jBtHsGlbPdCEIhGTar0GaQIkNYNYl7
 Q96aI2iObx8wf6BsRubFcWJ9d8hdPp/5dum3sXY+6zIfSURFzcF3jhFNbi8P334XgcADPDCMka
 uJX8ZA5Juu17rYKSRBMv1mpKvD3B1/ahdhwbZ4+6Y8IbRHOG6YRcn6dAREfn19sGd6zqmjzG/m
 axA=
X-IronPort-AV: E=Sophos;i="5.79,344,1602572400"; 
   d="scan'208";a="102726014"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jan 2021 04:57:09 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 13 Jan 2021 04:57:09 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 13 Jan 2021 04:57:07 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH net-next v2 2/2] sfp: add support for 100 base-x SFPs
Date:   Wed, 13 Jan 2021 12:56:26 +0100
Message-ID: <20210113115626.17381-3-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
References: <20210113115626.17381-1-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for 100Base-FX, 100Base-LX, 100Base-PX and 100Base-BX10 modules
This is needed for Sparx-5 switch.

Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/sfp-bus.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index cdfa0a190962..3c67ad9951ab 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -265,6 +265,12 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	    br_min <= 1300 && br_max >= 1200)
 		phylink_set(modes, 1000baseX_Full);
 
+	/* 100Base-FX, 100Base-LX, 100Base-PX, 100Base-BX10 */
+	if (id->base.e100_base_fx || id->base.e100_base_lx)
+		phylink_set(modes, 100baseFX_Full);
+	if ((id->base.e_base_px || id->base.e_base_bx10) && br_nom == 100)
+		phylink_set(modes, 100baseFX_Full);
+
 	/* For active or passive cables, select the link modes
 	 * based on the bit rates and the cable compliance bytes.
 	 */
@@ -389,6 +395,9 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 	if (phylink_test(link_modes, 1000baseX_Full))
 		return PHY_INTERFACE_MODE_1000BASEX;
 
+	if (phylink_test(link_modes, 100baseFX_Full))
+		return PHY_INTERFACE_MODE_100BASEX;
+
 	dev_warn(bus->sfp_dev, "Unable to ascertain link mode\n");
 
 	return PHY_INTERFACE_MODE_NA;
-- 
2.17.1

