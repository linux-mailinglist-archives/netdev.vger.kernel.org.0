Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B11B2F165F
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730744AbhAKNJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:09:11 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:61231 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730693AbhAKNJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 08:09:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610370546; x=1641906546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=XZInnv4rahRaiEGnE72fke2xIfQouNcxrqo3yUet0yA=;
  b=Vx/RByMhi1tbGMYyvwn6OFLx7lE6NYnxyQTOJqqonl+VGWWEfRKieXKQ
   0b9NC/noPVMzmeTadPzaf0mXWQkV+IAkZC622NfTNaM3rFjItAW369JgW
   ZRh7jJYoDSgl1Bdn5d7dVaZyIIcEPsuv+a2IHWQ5nUOyRxvpBHSGN7MJX
   3zJQ1WyG84Ffp5FPlrsYvLXM3IVZy75j9W+LLk2L90SCf0BXxaSE5t6a/
   KQyuQYqrBSWC7ZO/Fhpf+XcGD2GKwsA98/+79UGtsxdGh2SoC4eJ5ouWb
   04NSVbaMUnUYEvMLxnBjP4ptNhBMItSuk06tzgbhZ7FhZgIz+1fGMcmmc
   g==;
IronPort-SDR: SnQNRKgKhSoV3/4TiRKrPNXv926H3UAYr0VFezKlfoVjX3OiS48WZtFN9g5L9wJm1PTCCWvT1n
 GVkC6teIBdCqxawBm5P7fdiKInJy2/5Ad1Gfc5LvVd1YESRQewjcc6tzWytieWVfDqkUV7OU8A
 m33NROd8H9HPMrlqS0imWxUnFziNCxWu/ZE8ZwcVOOBvR1PDFKVkwKqzwUUxT4d6sJrRREbjvA
 yz8sG77x20r3AFz/5Vj7cXbF8yi0f3aZk/1fpEXTNdUaZpHCvGkuHcEYGAT3pVThebjjP2umqI
 iIk=
X-IronPort-AV: E=Sophos;i="5.79,338,1602572400"; 
   d="scan'208";a="104983674"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jan 2021 06:07:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 06:07:49 -0700
Received: from soft-dev2.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 11 Jan 2021 06:07:47 -0700
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: [PATCH v1 2/2] sfp: add support for 100 base-x SFPs
Date:   Mon, 11 Jan 2021 14:06:57 +0100
Message-ID: <20210111130657.10703-3-bjarni.jonasson@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
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
index 58014feedf6c..b2a9ee3dd28e 100644
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
@@ -385,6 +391,9 @@ phy_interface_t sfp_select_interface(struct sfp_bus *bus,
 	if (phylink_test(link_modes, 1000baseX_Full))
 		return PHY_INTERFACE_MODE_1000BASEX;
 
+	if (phylink_test(link_modes, 100baseFX_Full))
+		return PHY_INTERFACE_MODE_100BASEX;
+
 	dev_warn(bus->sfp_dev, "Unable to ascertain link mode\n");
 
 	return PHY_INTERFACE_MODE_NA;
-- 
2.17.1

