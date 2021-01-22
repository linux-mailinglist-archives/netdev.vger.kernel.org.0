Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C45B63005B1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 15:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbhAVOlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 09:41:13 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728768AbhAVOgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 09:36:20 -0500
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCED38C066;
        Fri, 22 Jan 2021 09:35:33 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611326134;
        bh=3k3sl6w4gcZONFPtT+kouYEWEs1FWTrE6BMEwckECc4=; h=From:To:Date;
        b=TlMa9HBq+avcRtZh1a/co40iC4x4wnqRyw6Fjn4gpol3Va78akmfgXoHTP1efTgcx
         XHrpIzUOGCxOPuNw8aSOHkkVuZij9LLJbpVNE71AXWeOsDB162oYp/3uMms4M43xo7
         jkPkY8t+eiIbliIlbH4LvWKXJU51v6BM5fUVt9McfBJAx88/TXqvosU88ZBQxwSpms
         Wett0zogJ1e5MKWQ1CL/Y7Z5etBXfxh0kqBwCmVk92CCqZz/eQXcgUsj79y9UCwYkm
         rpxkLdqi73IPHdwknKc1NSGPHJe4dmPJmVlkByAsXi2EPo+j6NuISA7aM4iHSKRKa9
         cDxyCRQXt2BIw==
Received: from mail.eaton.com (loutcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D77E78C060;
        Fri, 22 Jan 2021 09:35:33 -0500 (EST)
Received: from SIMTCSGWY02.napa.ad.etn.com (simtcsgwy02.napa.ad.etn.com [151.110.126.185])
        by mail.eaton.com (Postfix) with ESMTPS;
        Fri, 22 Jan 2021 09:35:33 -0500 (EST)
Received: from localhost (151.110.234.147) by SIMTCSGWY02.napa.ad.etn.com
 (151.110.126.205) with Microsoft SMTP Server id 14.3.487.0; Fri, 22 Jan 2021
 09:35:32 -0500
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
Subject: [PATCH net 0/1] net: phy: Fix interrupt mask loss on resume from hibernation
Date:   Fri, 22 Jan 2021 15:35:23 +0100
Message-ID: <20210122143524.14516-1-laurentbadel@eaton.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-SNTS-SMTP: 9F905500186904FA98F60E47D2E9F1CC109379FB2E84CA0EA01407A9590434152002:8
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25928.000
X-TM-AS-Result: No--2.810-7.0-31-10
X-imss-scan-details: No--2.810-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25928.000
X-TMASE-Result: 10--2.809800-10.000000
X-TMASE-MatchedRID: wwSHOPa+JnqYizZS4XBb3/RUId35VCIe52mltlE2n8gOkJQR4QWbsAqF
        Q57e8A/UPMs0cdM/lpgTR6MsfJbuqySKeTIQJ1bzAoNa2r+Edw1zNCdGumZsSQVR/cvm2iZc6+p
        bA1zmYaPelAkRK3cdNnMqLmx/Omp1eKZAID3hHVZxoP7A9oFi1m7BSyDZmAnxkYldHqNEW7hPpj
        LRqc8GlgKBj7ifFO2PeNGXg3cZsw84qGaEI/i7xoph1hAtvKZNqWaMWrxmYY47fXZ8qCOriW1ql
        Po7VBvTKrauXd3MZDWhi+hYp33nSkWUKZ0u+0Z9E5td4VFXe4MEnJ5n81Q7U5tzWlqb9TvmuDnX
        PAyUv3UErgEwN1mFU4lZTBjWIIMDzri1V1TY3DaFF9DZjWSNOFPyQiE5roUu6GWzRR7WyHT5eN4
        j1iCTD8cE0+/e1WoP
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFSome PHYs such as SMSC LAN87xx clear the interrupt mask register o=
n
software reset. Since mdio_bus_phy_restore() calls phy_init_hw() which
does a software reset of the PHY, these PHYs will lose their interrupt=20
mask configuration on resuming from hibernation.

I initially reconfigured only the PHY interrupt mask using=20
phydev->config_intr(), which worked fine with PM_DEBUG/test_resume, but
there seems to be an issue when resuming from a real hibernation, by which
the interrupt type is not set appropriately (in this case=20
IRQ_TYPE_LEVEL_LOW). Calling irq_set_irq_type() directly from sysfs=20
restored the PHY functionality immediately suggesting that everything is
otherwise well configured. Therefore this patch suggests freeing and
re-requesting the interrupt, to guarantee proper interrupt configuration.

Laurent Badel (1):
  net: phy: Reconfigure PHY interrupt in mdio_bus_phy_restore()

 drivers/net/phy/phy_device.c | 9 +++++++++
 1 file changed, 9 insertions(+)

--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

