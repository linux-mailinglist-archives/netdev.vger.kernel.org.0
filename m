Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4475A29CD52
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbgJ1BiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:21 -0400
Received: from mail.eaton.com ([192.104.67.6]:10600 "EHLO loutcimsva01.etn.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833008AbgJ0X2t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:28:49 -0400
Received: from loutcimsva01.etn.com (loutcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C75E29608E;
        Tue, 27 Oct 2020 19:28:47 -0400 (EDT)
Received: from loutcimsva01.etn.com (loutcimsva01.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AF54B96084;
        Tue, 27 Oct 2020 19:28:47 -0400 (EDT)
Received: from SIMTCSGWY02.napa.ad.etn.com (simtcsgwy02.napa.ad.etn.com [151.110.126.185])
        by loutcimsva01.etn.com (Postfix) with ESMTPS;
        Tue, 27 Oct 2020 19:28:47 -0400 (EDT)
Received: from SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) by
 SIMTCSGWY02.napa.ad.etn.com (151.110.126.185) with Microsoft SMTP Server
 (TLS) id 14.3.468.0; Tue, 27 Oct 2020 19:28:47 -0400
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 SIMTCSHUB01.napa.ad.etn.com (151.110.40.174) with Microsoft SMTP Server (TLS)
 id 14.3.468.0; Tue, 27 Oct 2020 19:28:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Tue, 27 Oct 2020 19:28:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bor1IhHiNL50i+elNe5G5+VhI3JwwT7ZTEhnCnQyxZ57OdFHa8w7qnFw7zUka1zZgjuJ21AIFIR3bT8M095jkEUKqhwYWSKyBVZwD/BgtUKhxtgM/Ru+IaF8G0qaekubB25SAxCdon8aHHFzZk+Xi0ALv8HiybX0/vWJrf4I2RaLaefPPuQy3mqEgefmSq02R9xbJuj21mpOecJ9qsQJzliyaBV8QE5JEEGV+7681pwV+ahN7OOsVI3V/WPjdJ9Q/HaKMbU7hSAq8Yvlh+in7xDjJtxCLt6ZUfxUeHtK6gAyGiNejpt1S1Uc4YQ3Yi+uS2vhcvbPAbamfro2iMy7zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xF17dwkllGT/Mtu6hQ4o/wuju3UzJy4IBAmrdxPPt4=;
 b=g58WMkoOE2Uh3ZTCkTdwPrM4eLd8phmUoPrnOWBzrAstaXaDp8XQmVIVomHNO8lqH3I9GVd0hVcNTKUlo1Ykx7GlMFq68a5+A8U5M1FmnqQPprzDubd9Z3wr/CuKXEeX7BBYzU2gp8ezQjlj1qpMRaT0YZtfhJTOra5+21baN5CEnZVZIiZZUZzvnxkyPvwJ89ib8llGMoa88kprlaj0sCH02sAvmZUHZwxwnFB4Wy1xlPcMzZpUMquaeyhZlox29ATuiZD05b/vLzeQdiHJrDaUJhIFxCGJn0PH/szWlo3b+qXU9p4/pUf0lNDjOTL83ZVVNCn0HZbh/YuYHwwLTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2xF17dwkllGT/Mtu6hQ4o/wuju3UzJy4IBAmrdxPPt4=;
 b=3B2MwBf4wI3qYaZJyG/fyxX7+Es8Hnv6+bB4ONtw//PnzTMZexa7wa7lKdxQJ5S4sYl/DpAn3yQFGNWBce2CZ6kPwWlOdqNmHkT0bxokcGN4r9AuTLJuTZ6uQA0Z0Zkxioa5JdXuJsbE48N7+rnnNQwfp75A+gQRVSDyLImklkU=
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 (2603:10b6:910:6d::13) by CY4PR17MB1942.namprd17.prod.outlook.com
 (2603:10b6:903:94::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.22; Tue, 27 Oct
 2020 23:28:45 +0000
Received: from CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45]) by CY4PR1701MB1878.namprd17.prod.outlook.com
 ([fe80::a5a5:a48b:7577:6b45%6]) with mapi id 15.20.3477.028; Tue, 27 Oct 2020
 23:28:45 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
CC:     "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: [PATCH net 3/4] net:phy: add phy_device_reset_status() support
Thread-Topic: [PATCH net 3/4] net:phy: add phy_device_reset_status() support
Thread-Index: AdasuOiSt1LtmTDZRYe4uOkfybAg5g==
Date:   Tue, 27 Oct 2020 23:28:45 +0000
Message-ID: <CY4PR1701MB1878D8AA63E4EBB99759B838DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3043eff9-c6de-4008-3eb8-08d87ad00cbb
x-ms-traffictypediagnostic: CY4PR17MB1942:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR17MB1942B9986DA3E475195E5941DF160@CY4PR17MB1942.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vWX5ryOb3l0zqtvBNm1c/9mMstyXUZ3A56+xkuKur/jSZL81tXTjeVkZ8DbHu9V8FouCDHUjCuZPHWRelNdAAfX5JD5xOA1n1nLDYNALoFN2Efts+T0xCas1ZFsMuu7HS1Qkc7pbALP14wTNfHsFJP29XNgl9qYxtqXxOwu8PQkQ+Y2/GjIzd2/uLKGaTuw2pyaoE+Wui9ddZoFnloYdiwOkHJkMwv6bIFcDOcS3+4WBcqav8Bqw/a5H1HjFxHHSj2visKTA41shJwbmmz8cZHFHT+OqnTSmeAWnkpbTDdXFz4v5f6/WT9Yqj+Nd9Uir6FNPZOYVx1OiDbAPRL5iQNyq9guikWwAzT7hilNnKwUYRkiojJMPvsAUXBLxcXvT
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1701MB1878.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(366004)(396003)(346002)(6506007)(8676002)(8936002)(107886003)(9686003)(2906002)(86362001)(4326008)(64756008)(66946007)(33656002)(478600001)(52536014)(66476007)(76116006)(66556008)(5660300002)(66446008)(71200400001)(316002)(186003)(26005)(110136005)(7696005)(55016002)(7416002)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: niuFLwkeDnFt+8T6PXrO6YlfjVV8VzUAXS2wDT3YtRIM90dqavzTgh08CrEhGTVghIehN37V7zD+nSApsDCZGBa967XcNvUz63ERMzVSZGlwjnjxirHjVv2W/JehB7vhGJyZLmRtGBA2GstRBYH9NiNPISZnbDfPrhVqgplmasfmHfsCRkqE6nRyvQ77Yu+kL0GC10bqOKYjYdQzgQGBSnMO6/+MkmKPTG9JzkvWwCT+dQivbWtvh2SxCbcKMLTxR8N/nj8SfaECB1q4FD2Q85jB27jw9Ddtlb5EJiBHt08WVA9ppZCfXFriOtAdC0Z+MYo99HddeuUY8SNtvza2IUxaamxlGqv00+FCY/LOzEMMqeNOgR2PQ8Nc1TeRTwCvJSjVeK1OBbihkaOtC2MAgq4WFtdchPgse5KB3Hjdkb98NJrqqbqXTQ8i5UiNYA6ZGht300LV+U8wPzWbwgQL6QnTpxHZnXOOZpwsT1ZRi+Gs44r4UQEiQHbUHQziMNP4IZ53ZagVV6Mt/DMbHlu5G800Pf/5z4jpUnj7e8wdiR4pmi29F2RFQf3yFbYHJh1TBhjkGl5Y7A1gsm9abzOsJDdeMhrroT+1lrHVPNzRxTsQ9TGyZ4V+1du3R+HgD6GsOczguNJ5qGYnpn9w6RJkNg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1701MB1878.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3043eff9-c6de-4008-3eb8-08d87ad00cbb
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2020 23:28:45.6690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1NAvu84SxBuXepveAzBXO/23Exh1V3IjYjq+/mqbPrjG6Y0zgF7EYqaf/URjbwcYa0WKk1KEsZ0tYRG4IM9apA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR17MB1942
X-TM-SNTS-SMTP: 01680F9E10CBCEEDA1E8B9F07AE6C20FE2694DF2975BCF9EDA2C7A1164F06DD02002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25752.003
X-TM-AS-Result: No--0.002-10.0-31-10
X-imss-scan-details: No--0.002-10.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25752.003
X-TMASE-Result: 10--0.002000-10.000000
X-TMASE-MatchedRID: FPI5UUlJimYLKp8CjzhvwI4uBIdoKfjuGbJMFqqIm9z5+tteD5RzhWdC
        uMvHMJPkRS3ViuUTjLV8q/y2sEd/cxqiBXdxPfouUfqR39ZbIlV6i696PjRPiGOMyb1Ixq8Vcij
        MZrr2iZ2t2gtuWr1Lmnq/3tVeyVFpcsoJIwqzxXeVyEX4i+SWUzFcf92WG8u/HWtVZN0asTjSJJ
        cbp1Y+W5kHZe8cKrzGlPyKFBMd+6EA7bU4vrpHXJ4CIKY/Hg3A3QfwsVk0UbsIoUKaF27lxUKz0
        sNazEatRhpU7Wv03uoDNFBOFpTnHAW6ZO6oUvn8cmK/NoJiuXqaXDYKW5+Xos4oWmjb3qqd36F+
        vn+817by0hjwIReQdC6/7KD1s/Je3FO0vr0KV10Sx+ezCQyTIh3gfQXsasLHnqg/VrSZEiM=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=EF=BB=BFSubject: [PATCH net 3/4] net:phy: add phy_device_reset_status() su=
pport

Description: add support to query the status of the reset line of an MDIO=20
device.=20

Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
---
 drivers/net/phy/mdio_device.c | 18 ++++++++++++++++++
 include/linux/mdio.h          |  1 +
 include/linux/phy.h           |  5 +++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/phy/mdio_device.c b/drivers/net/phy/mdio_device.c
index 0837319a52d7..4909feb57027 100644
--- a/drivers/net/phy/mdio_device.c
+++ b/drivers/net/phy/mdio_device.c
@@ -136,6 +136,24 @@ void mdio_device_reset(struct mdio_device *mdiodev, in=
t value)
 }
 EXPORT_SYMBOL(mdio_device_reset);
=20
+/**
+ * mdio_device_reset_status - returns the reset status of an MDIO device
+ *
+ * Returns >0 if the reset line is asserted, 0 if it is not asserted
+   and <0 on error.
+ */
+int mdio_device_reset_status(struct mdio_device *mdiodev)
+{
+	if (mdiodev->reset_gpio)
+		return gpiod_get_value_cansleep(mdiodev->reset_gpio);
+
+	if (mdiodev->reset_ctrl)
+		return reset_control_status(mdiodev->reset_ctrl);
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(mdio_device_reset_status);
+
 /**
  * mdio_probe - probe an MDIO device
  * @dev: device to probe
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index dbd69b3d170b..179c5bdd90e8 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -92,6 +92,7 @@ struct mdio_device *mdio_device_create(struct mii_bus *bu=
s, int addr);
 int mdio_device_register(struct mdio_device *mdiodev);
 void mdio_device_remove(struct mdio_device *mdiodev);
 void mdio_device_reset(struct mdio_device *mdiodev, int value);
+int mdio_device_reset_status(struct mdio_device *mdiodev);
 int mdio_driver_register(struct mdio_driver *drv);
 void mdio_driver_unregister(struct mdio_driver *drv);
 int mdio_device_bus_match(struct device *dev, struct device_driver *drv);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..e12b90db9852 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1461,6 +1461,11 @@ static inline void phy_device_reset(struct phy_devic=
e *phydev, int value)
 	mdio_device_reset(&phydev->mdio, value);
 }
=20
+static inline int phy_device_reset_status(struct phy_device *phydev)
+{
+	return mdio_device_reset_status(&phydev->mdio);
+}
+
 #define phydev_err(_phydev, format, args...)	\
 	dev_err(&_phydev->mdio.dev, format, ##args)
=20
--=20
2.17.1



-----------------------------
Eaton Industries Manufacturing GmbH ~ Registered place of business: Route d=
e la Longeraie 7, 1110, Morges, Switzerland=20

-----------------------------

