Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F1A94C13
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:54:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbfHSRwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:52:54 -0400
Received: from mail-eopbgr40072.outbound.protection.outlook.com ([40.107.4.72]:35234
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727794AbfHSRww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 13:52:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZRywXzuj0LBXUcBr97pU1WJ8kFZJqnPofB1CnkOTmX94MPcWWUBRj19r5G4f8Hfs6aGNeUbB1oqg4iyVjwWE7NW0UBe7M//4WVlqITWoaLXWzMu5UuB1rzgg7Q6Bl92X09HwAKIXqwV413vpBIJNeARIJ/BmPf9R7lCHXKXnxHa1Tog/8Tnw8kagZHgrk4F9fxcUW345/hXT4sGOq/tdY7ruE/ZUvo3SHviphBZYLbPb5ETBPkY4e0t/GEFetf58SsAzVSoAVzE8BU8y0u73pJXATqdOS+6bXgBIKCr8iHJaIu21pPscFB4bhpexOwRQAONob3kfpqzxxYU8Kng/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9JU3siwp8FCtQAAtIWxn64c4z0DknyZnT0iBJcck1M=;
 b=NFCCa6Gvn6oNlzC0BW8tYy7Ubxz+LuVkTbm1BigkNrRRSIPM7euonMgjW52fnfGSf18V4+ZHIns+42MEHLRZh4G+JJh/tBXJgAUngF27KaJdwdYmb3gsQsZ9wbk1dYQHO1/hUHE6LYf4r0AzWVs+GERsA+v1TbXOacxQRj7vG5Mip4Jl8iivE0siXeiJztSGUJkiT2v/ZEvywf3vx6EsrtVpF0dq8HxAY5ZyhQGxky2gDpdWbLX2k0RSxE9m2qygysWIBiTPFQ00Hf6qrgRXaDxN+rL9Rp4lnKKmqs/q0Qk+M8Jrsf9NwpT7+S7Lc8bXUE59JBQooTPfsA/KaE2PBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R9JU3siwp8FCtQAAtIWxn64c4z0DknyZnT0iBJcck1M=;
 b=FWYltUebw6WU74WdP1Pp6oBsAasg2x2kCqUqZ1hftfs9KxdjkWwpicwT+ViaylI6bFi3glWAZ0LmtOS+zkpaPLvceyfzUkTv8Cck5htbe0JzDVaNjUexPS5AaMvn5aMkHZVyrw5yeo7RSkhv9JWoUl4U6rbfsRNp4CYOeK04eUc=
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com (10.172.248.19) by
 DB6PR0402MB2710.eurprd04.prod.outlook.com (10.172.245.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 17:52:48 +0000
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90]) by DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90%2]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 17:52:48 +0000
From:   Marco Hartmann <marco.hartmann@nxp.com>
To:     Marco Hartmann <marco.hartmann@nxp.com>,
        Christian Herber <christian.herber@nxp.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next 1/1] Add genphy_c45_config_aneg() function to
 phy-c45.c
Thread-Topic: [PATCH net-next 1/1] Add genphy_c45_config_aneg() function to
 phy-c45.c
Thread-Index: AQHVVrbpfZ9KYVWYg0SQSycjaz4AZg==
Date:   Mon, 19 Aug 2019 17:52:48 +0000
Message-ID: <1566237157-9054-2-git-send-email-marco.hartmann@nxp.com>
References: <1566237157-9054-1-git-send-email-marco.hartmann@nxp.com>
In-Reply-To: <1566237157-9054-1-git-send-email-marco.hartmann@nxp.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM4PR0202CA0024.eurprd02.prod.outlook.com
 (2603:10a6:200:89::34) To DB6PR0402MB2936.eurprd04.prod.outlook.com
 (2603:10a6:4:9a::19)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=marco.hartmann@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4498171-5a54-40e7-9d7f-08d724ce0bf8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0402MB2710;
x-ms-traffictypediagnostic: DB6PR0402MB2710:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB27109836302AD32F12387A3D8CA80@DB6PR0402MB2710.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(136003)(376002)(189003)(199004)(71190400001)(86362001)(81156014)(66556008)(66446008)(478600001)(386003)(53936002)(64756008)(66476007)(3846002)(81166006)(6506007)(110136005)(55236004)(6512007)(8676002)(36756003)(6486002)(14444005)(14454004)(316002)(486006)(102836004)(66946007)(6116002)(25786009)(476003)(446003)(26005)(11346002)(6436002)(2616005)(5660300002)(44832011)(256004)(71200400001)(2906002)(186003)(52116002)(2501003)(7736002)(305945005)(76176011)(50226002)(66066001)(2201001)(8936002)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0402MB2710;H:DB6PR0402MB2936.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GBYKWeYDTtpUJ77om61ePACPVIRmp9jHo4pABydtFy4LYwWzrkED+v8X/Z8n0Sik84RYbexQhLX+YK45Tyh9iC9FOmKqpoPd14No8kct5HHfDRrZh9kzyaWLE7c2sLki2GZQx77TnNXICUmAxnBbV9M8RTFzCzxY/E2A7e8pQ0yFtVEzk7uPq4kIsVZRCFWzEMlHndKx2i6HzqSdxJCl83JcQHA06ySb7TkjaoGwTad7Z4EAyDeJotpCGTv55U4ItM7Si4blG2XP/FrQKi6m3nyew6MoehuyyjNLpHEpRhRxR5S2PiTGEjXWtfb5rUgdsuyCrEzi0hExjLQeC0Mn/JGT95W9QLZ3CYcjo1q2hrHUOwnMIbRWZQH1b1oVbBC+EyorWJk4CS2h8oT6NY2OV3PWZnk2MJwrUZv8NMDZbKA=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <4BB33B82D6E92A42A268F0AF05044B64@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4498171-5a54-40e7-9d7f-08d724ce0bf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 17:52:48.0509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K7XDbB7B6zfYV7eMXwajUch9A8nFNmVFwWcqd6i9MUqRrbuV+AVrMsmUx9teVpi7im8N/asKYo1M2cQsW/pKyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2710
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

and call it from phy_config_aneg().

commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from
calling genphy_config_aneg") introduced a check that aborts
phy_config_aneg() if the phy is a C45 phy.
This causes phy_state_machine() to call phy_error() so that the phy
ends up in PHY_HALTED state.

Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
(analogous to the C22 case) so that the state machine can run
correctly.

genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
in drivers/net/phy/marvell10g.c, excluding vendor specific
configurations for 1000BaseT.

Fixes: 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from
calling genphy_config_aneg")

Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
---
 drivers/net/phy/phy-c45.c | 26 ++++++++++++++++++++++++++
 drivers/net/phy/phy.c     |  2 +-
 include/linux/phy.h       |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index b9d4145781ca..fa9062fd9122 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -509,6 +509,32 @@ int genphy_c45_read_status(struct phy_device *phydev)
 }
 EXPORT_SYMBOL_GPL(genphy_c45_read_status);
=20
+/**
+ * genphy_c45_config_aneg - restart auto-negotiation or forced setup
+ * @phydev: target phy_device struct
+ *
+ * Description: If auto-negotiation is enabled, we configure the
+ *   advertising, and then restart auto-negotiation.  If it is not
+ *   enabled, then we force a configuration.
+ */
+int genphy_c45_config_aneg(struct phy_device *phydev)
+{
+	int ret;
+	bool changed =3D false;
+
+	if (phydev->autoneg =3D=3D AUTONEG_DISABLE)
+		return genphy_c45_pma_setup_forced(phydev);
+
+	ret =3D genphy_c45_an_config_aneg(phydev);
+	if (ret < 0)
+		return ret;
+	if (ret > 0)
+		changed =3D true;
+
+	return genphy_c45_check_and_restart_aneg(phydev, changed);
+}
+EXPORT_SYMBOL_GPL(genphy_c45_config_aneg);
+
 /* The gen10g_* functions are the old Clause 45 stub */
=20
 int gen10g_config_aneg(struct phy_device *phydev)
diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index f3adea9ef400..74c4e15ebe52 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -507,7 +507,7 @@ static int phy_config_aneg(struct phy_device *phydev)
 	 * allowed to call genphy_config_aneg()
 	 */
 	if (phydev->is_c45 && !(phydev->c45_ids.devices_in_package & BIT(0)))
-		return -EOPNOTSUPP;
+		return genphy_c45_config_aneg(phydev);
=20
 	return genphy_config_aneg(phydev);
 }
diff --git a/include/linux/phy.h b/include/linux/phy.h
index d26779f1fb6b..a7ecbe0e55aa 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1117,6 +1117,7 @@ int genphy_c45_an_disable_aneg(struct phy_device *phy=
dev);
 int genphy_c45_read_mdix(struct phy_device *phydev);
 int genphy_c45_pma_read_abilities(struct phy_device *phydev);
 int genphy_c45_read_status(struct phy_device *phydev);
+int genphy_c45_config_aneg(struct phy_device *phydev);
=20
 /* The gen10g_* functions are the old Clause 45 stub */
 int gen10g_config_aneg(struct phy_device *phydev);
--=20
2.7.4

