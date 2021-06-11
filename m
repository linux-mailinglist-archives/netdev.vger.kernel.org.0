Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C253A427E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 14:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhFKM5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 08:57:16 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36544 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231691AbhFKM5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 08:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623416114; x=1654952114;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OfWnwH1Dn3KlOhkGvla/AbXSuETpsXr9bzDPCtdygMA=;
  b=K4AYN0SecCSlIiM0ES1VZ1BUZ1G132t0xt0cO4RzXRSpjBmSHGw7KaC+
   O54fznfyCKD8yFV0qESKy6lrhQXaxBEeGYK1ihO/8Xp0pj/DVePKA3Ueh
   zaaoMtrHzu4lopiRYX0b12u36ZJQyNUPaVRtOPBkyJpxZ1YIS7m5LvHoL
   rw3ScJEJnvydKYEyJrki6l6PaHoVqNQMlEV+Kc3MkmCh+wzrwJMuTzRbl
   U1SRBrlsNjSRAI595kaEfE8rIlbtYgGgoR/JuYfTEzVF+lta7yfPhfAer
   7gRsU2Zm/47w3tOm62PVTjP1dMQheyWisP04npLLQg8geWpZ3pC+pFsU1
   Q==;
IronPort-SDR: ABhgUrNcA1VGb6gS3LPJwSnAdU/9kXmZHdQLQytcCEvZ+HeB+f2DiFBi/P0SUvK+AKRMyvSaSy
 fMcrLM+LLsqltJlg59/lwuMCcROjGSfNr21kxibXQVgI9W/j54d8yAn0xaWcfYU11GIn1Xev6c
 MFnUKhoeaUGAlskYOgEDq5bWJlWbkw5Q7HH//C7haS4vta6ia/v7lMht3RePksvNwGC1OsPDwc
 N2pNOhUJMEkOU6YPklu7DI9oGfQ2fqZS4cWnPeIfMoGihy+QJLpwFaXpQ8Z9mBPkYjDvSllv/4
 WvE=
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="131631342"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Jun 2021 05:55:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 05:55:12 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 11 Jun 2021 05:55:10 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>
Subject: [PATCH net-next 4/4] net: phylink: Add 25G BASE-R support
Date:   Fri, 11 Jun 2021 14:54:53 +0200
Message-ID: <20210611125453.313308-5-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210611125453.313308-1-steen.hegelund@microchip.com>
References: <20210611125453.313308-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 25gbase-r interface type and speed to phylink.
This is needed for the Sparx5 switch.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
---
 drivers/net/phy/phylink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 96d8e88b4e46..b1b9bb30d5b5 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -311,6 +311,11 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
 			phylink_set(pl->supported, 5000baseT_Full);
 			break;
 
+		case PHY_INTERFACE_MODE_25GBASER:
+			phylink_set(pl->supported, 25000baseCR_Full);
+			phylink_set(pl->supported, 25000baseKR_Full);
+			phylink_set(pl->supported, 25000baseSR_Full);
+			fallthrough;
 		case PHY_INTERFACE_MODE_USXGMII:
 		case PHY_INTERFACE_MODE_10GKR:
 		case PHY_INTERFACE_MODE_10GBASER:
-- 
2.32.0

