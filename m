Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5999930059C
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 15:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbhAVOhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 09:37:18 -0500
Received: from mail.eaton.com ([192.104.67.6]:10500 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728810AbhAVOgm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 09:36:42 -0500
Received: from mail.eaton.com (simtcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 28EDC960C3;
        Fri, 22 Jan 2021 09:35:41 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611326141;
        bh=R2zHmX5/NiL6WCxfs6TaceDHiNspxfniXOh6eGlV4CQ=; h=From:To:Date;
        b=KeIJAdRuXECjMpawxwr3DS7u6S3DVG6dkMhU9DAOuu3pYyvRn+DgRdQ/lEBOgAHzA
         edSIhNG/9FD1C8CF5EqjzwEGcORpwMUaifBQFQze9n/rtB+34aSLIV+FHukp4vNeaP
         RGcxNdsMB6VbHZuy1iB0lTb1hISIgZ/vNYAmCORMb8dHKhYloX+6Xas9fA/gs9nHnp
         hNNVkN9NwtOc+Mz5eEqB39j4enJpVZHY83UPBTrDOznND5Ju1Z6BjRUN4gWXv6BpT0
         QvsFmnG9G6D6GX7NpNZ+gKBnO1LukKNLse6eD4Xg/ANxckpOrsh7HJ0/MmiYZmXuQF
         uy+zEdEANXiUw==
Received: from mail.eaton.com (simtcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD403960BD;
        Fri, 22 Jan 2021 09:35:38 -0500 (EST)
Received: from SIMTCSGWY04.napa.ad.etn.com (simtcsgwy04.napa.ad.etn.com [151.110.126.121])
        by mail.eaton.com (Postfix) with ESMTPS;
        Fri, 22 Jan 2021 09:35:38 -0500 (EST)
Received: from localhost (151.110.234.147) by SIMTCSGWY04.napa.ad.etn.com
 (151.110.126.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 22 Jan 2021
 09:35:37 -0500
From:   Laurent Badel <laurentbadel@eaton.com>
To:     <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, <linux-pm@vger.kernel.org>
CC:     Laurent Badel <laurentbadel@eaton.com>
Subject: [PATCH net 1/1] net: phy: Reconfigure PHY interrupt in mdio_bus_phy_restore()
Date:   Fri, 22 Jan 2021 15:35:24 +0100
Message-ID: <20210122143524.14516-2-laurentbadel@eaton.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210122143524.14516-1-laurentbadel@eaton.com>
References: <20210122143524.14516-1-laurentbadel@eaton.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-SNTS-SMTP: FE70FC713CB97F6DAD8BEDAB0A1D68EFAE1D5103F39DC3EE98EE31318D8342EB2002:8
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25928.000
X-TM-AS-Result: No--2.003-7.0-31-10
X-imss-scan-details: No--2.003-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25928.000
X-TMASE-Result: 10--2.002600-10.000000
X-TMASE-MatchedRID: VIW3LEg1l16YizZS4XBb3/RUId35VCIe+ahnrHhmAJRGM2uNXRqsUvsY
        8bNjl3gGPMs0cdM/lphnRutsGMyuGPI1YbpS1+avqJSK+HSPY+9lRzZAkKRGDVIxScKXZnK0QBz
        oPKhLasiPqQJ9fQR1zrcPaeb4aji83nEpDU+5f9ko19GoN4WoGEyWLwjUVKFuA8FfY2Fm0lMIyT
        NFi0TCbVYJIpN1DYJ5vqEhop8TGnRYF3qW3Je6+19QXM0Jj/jaf1tdYMcH2nI1pZREe8ejp8uoR
        xHHrkLVNN00X0JwCr1AKfTbEPjR+peTN2GaEP5Hz9DvVzrxOJm0hbFWy4EqU4pebMSk1UmKlmXP
        gyQocYp5E1G2nFNyeETBf0diyKhk8g9TaEI7TXx+3BndfXUhXQ==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFSome PHY (e.g. SMSC LAN87xx) clear their interrupt mask on softwar=
e
reset. This breaks the ethernet interface on resuming from hibernation,
if the PHY is running in interrupt mode, so reconfigure interrupts
after the software reset in mdio_bus_phy_restore().

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/phy_device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 80c2e646c093..5070eed55447 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -324,6 +324,15 @@ static int mdio_bus_phy_restore(struct device *dev)
 	if (ret < 0)
 		return ret;
=20
+	if (phydev->drv->config_intr && phy_interrupt_is_valid(phydev))
+	{
+		/* Some PHYs (e.g. SMSC LAN8720) clear their
+		 * interrupt mask on software reset.
+		 */
+		phy_free_interrupt(phydev);
+		phy_request_interrupt(phydev);
+	}
+
 	if (phydev->attached_dev && phydev->adjust_link)
 		phy_start_machine(phydev);
=20
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

