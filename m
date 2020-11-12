Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805AD2B01E7
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 10:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbgKLJW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 04:22:58 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:55687 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgKLJW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 04:22:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1605172977; x=1636708977;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+JTRV2q9tjsQXJcXhR4dxoogVQsm9aXgdlyZQHFOqzo=;
  b=qj1dZ/BEv5F3YfPzre7BJaNsd08xNJgWUWU7/LPqohinLaOTKX/K5ds4
   aoQuvER697Z+WFQNzD4y7vQcoSTm1QRDjbMtFxpTUVvFbihyTeMNIBNjM
   6YQXWCuMdtEsJtfI7WvQw4DITS7m6waG/kQiRIErC8aUO7LJCUq88WYQr
   3ZnDHNeD/mtuOnt3s+e1byS9qVeedorNrHat418tAr+75aL6j8zlLk/UM
   I4yE0YtgPL3lWBpqRbDyssF2kN3a2yfkgW3gwEHNE+RNY4UbEIhAMOBw0
   ILDz/oQvniD190Geym9x9O7yJW387GvE4wexCAMNCssUCecgV/ZIP4IBR
   w==;
IronPort-SDR: lz3H42wmJfVNwz4Rzl4/GTf7x/Vj9QmL6nrw3FtZthK4heS2MeRHe2AawmhvGet3lOP/YjAeMa
 cVBfZiMnNJbWbg2Auj4HUrrFL1h+kwcOXHWpWB+ptlIe7k6OEm3tkbeLRDm+u3mqt+wvfFztkR
 6EuLJnwlxc/zkNSABkj390i5cjcAS1RIUpjg00KZBL+8Gmch2vV9zOWPJemMAnAbzRwpcsVppt
 l65LmKU9V9UXuHO+X6TGywbptokhmATiht2kFLQv4CZvtdXl408X5qToCK0cDC/QLRzDdd/pTd
 TCQ=
X-IronPort-AV: E=Sophos;i="5.77,471,1596524400"; 
   d="scan'208";a="103195325"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Nov 2020 02:22:56 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 02:22:56 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 12 Nov 2020 02:22:54 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Bryan Whitehead <Bryan.Whitehead@microchip.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        John Haechten <John.Haechten@microchip.com>,
        Netdev List <netdev@vger.kernel.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] net: phy: mscc: Add PTP support for 2 more VSC PHYs
Date:   Thu, 12 Nov 2020 10:22:50 +0100
Message-ID: <20201112092250.914079-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add VSC8572 and VSC8574 in the PTP configuration
as they also support PTP.

The relevant datasheets can be found here:
  - VSC8572: https://www.microchip.com/wwwproducts/en/VSC8572
  - VSC8574: https://www.microchip.com/wwwproducts/en/VSC8574

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/phy/mscc/mscc_ptp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
index b97ee79f3cdf..f0537299c441 100644
--- a/drivers/net/phy/mscc/mscc_ptp.c
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -1510,6 +1510,8 @@ void vsc8584_config_ts_intr(struct phy_device *phydev)
 int vsc8584_ptp_init(struct phy_device *phydev)
 {
 	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
+	case PHY_ID_VSC8572:
+	case PHY_ID_VSC8574:
 	case PHY_ID_VSC8575:
 	case PHY_ID_VSC8582:
 	case PHY_ID_VSC8584:
--
2.29.2

