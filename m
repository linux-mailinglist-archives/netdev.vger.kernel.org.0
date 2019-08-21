Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB129977AB
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 13:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbfHULBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 07:01:30 -0400
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:17415
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfHULB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 07:01:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ef0FTbP1xipACDjvKc0h5oatxzq9+XZlEYxLOR3+LA5eTEqmeVSvIGvlzAle3xMYZcwZRIcASIHO9tto5zdw8c2s7JnBVwIK/4CfqOpFMviA/lsFiLIYhoNQkpAhFpSJltupWLezyzUjKf41Sd9FcpsLcvfuOGSBKthWNMVzsM46UQ4YBFBWDlCpHKVLNe9ok2gEpDLPjK+qNqJoCWFtoeQw/K2DN5jiBXOYrFfRkiJ0d71EGfVmwhBFsr5B8qmqKk32dvyk9Gn7xKHNmV08/jakFJyLuG0zuzadqGW4EE3kcQWnWU5FuzsxEBvfU/EuWeT6qglwxKtj0Zd7M88AHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TSkfeiTQmRDE7PvC668ZhQkKc9HMgNcYPyNDWyb9rE=;
 b=jvars5obAaVz/WYnhbA09mUYx//E21oNjU9mmh32DZpiNJZg+iXqBIP/e+fqBirIQQuebXq1tdDEoJiWQltXMMN7Pk9puoX2PA0GNVn2RQTbZq/TFw6pFmQ9qIZaushQfX0Q5lGhTroMIWM4FMkceKL5BKtlXcBoTA6kTJGzPoAK/GI2uuqxlExmAeLdqbNlGyJWOaOMtvbgAi+fab6Tn2xzc9waD0C+YNdUxLfzuJK+3Jvjx8sHwoClVgIr1LpXcyJdDPlskhNDNQQiDTjo3zVW482S5vCt00H/PTj+x+Cno2mRFEbotg+D/6STEZ9EoEW25i6+l0K42oXYTFLlfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TSkfeiTQmRDE7PvC668ZhQkKc9HMgNcYPyNDWyb9rE=;
 b=muIvEPwln4jHRlQU3UcrDjs7P3Pub+vGPzF8X1Z0C3Cr30JBSbTE8f28a3G7zVUJsY2gojWDBpjDk7DDpgJRL+ikMXtaPLCqFXRrcW41uw+2iY+TdnnHzj+63xK51UMWJq6F6icalrEXdgNDoU73gv5HWaMgrqWL+St+iOLI8Ww=
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com (10.172.248.19) by
 DB6PR0402MB2789.eurprd04.prod.outlook.com (10.172.245.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 11:00:46 +0000
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90]) by DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90%2]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 11:00:46 +0000
From:   Marco Hartmann <marco.hartmann@nxp.com>
To:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marco Hartmann <marco.hartmann@nxp.com>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH v2 net] Add genphy_c45_config_aneg() function to phy-c45.c
Thread-Topic: [PATCH v2 net] Add genphy_c45_config_aneg() function to
 phy-c45.c
Thread-Index: AQHVWA+vyzqZh0jaqEeC/2XCAuPAwQ==
Date:   Wed, 21 Aug 2019 11:00:46 +0000
Message-ID: <1566385208-23523-1-git-send-email-marco.hartmann@nxp.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR04CA0022.eurprd04.prod.outlook.com
 (2603:10a6:208:122::35) To DB6PR0402MB2936.eurprd04.prod.outlook.com
 (2603:10a6:4:9a::19)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=marco.hartmann@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5000d28-b5a8-4a05-ebf9-08d72626d196
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0402MB2789;
x-ms-traffictypediagnostic: DB6PR0402MB2789:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB2789A524C7DBCA69D5BD47E98CAA0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(366004)(376002)(346002)(396003)(136003)(189003)(199004)(64756008)(71200400001)(6512007)(486006)(71190400001)(52116002)(476003)(2616005)(3846002)(316002)(110136005)(7736002)(478600001)(6636002)(102836004)(6116002)(2501003)(53936002)(26005)(6436002)(2906002)(66556008)(44832011)(2201001)(6486002)(305945005)(55236004)(6506007)(99286004)(5660300002)(386003)(256004)(14444005)(81156014)(8676002)(66066001)(81166006)(14454004)(25786009)(66446008)(186003)(50226002)(36756003)(86362001)(66946007)(8936002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0402MB2789;H:DB6PR0402MB2936.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TWXpq/+jk7X8LhH6aQVuXFIuHzPtabaVNYssrjAMQfQGvtv5Jo6pi1FxwE/rg3decITc+QQU6Ndv7zgou0NZUXiwFlJDX1OMipwpubP1vABhY59rIDUual1KPLvqxq+n+yt0136R1qYkbmtMrRBNVFFvHiHMpMh0hRSDBXBSK5UoKrkOtT3HB1XTkfW9+haA1YkM+JdpCntvcBgnc2DgbU9rHBP4m18ogf7nECqXk6egqHzRoQV/VZCulY8Tg4EWvaEHOHmUV1MOJbdjGCNtoyiw7viQaP0zn+y3nhDvcJk9u2ySWOk7wQ0eIPE/68BwsKBkkuffL3Qr8yIYGiNQ/e58hfELGf5ONKGy3NEE9wzC4f9uB7Hsx2p1Spl4GAkMsKnq5SemSGGfZTgMLQeTgJvgsw6VBe9G7u4OUuJ9HMw=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <46A97D2268DB7C44A9D949A4337247ED@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5000d28-b5a8-4a05-ebf9-08d72626d196
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 11:00:46.5125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ksdBB8sgM+NXFs80X9pt98Y5Kjxa8nGm1KHctx0fK+oIzg6jLfycWIM1yG3NL7BHB6TVqzfyNBcfeyKKQkxyEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2789
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 34786005eca3 ("net: phy: prevent PHYs w/o Clause 22 regs from callin=
g
genphy_config_aneg") introduced a check that aborts phy_config_aneg()
if the phy is a C45 phy.
This causes phy_state_machine() to call phy_error() so that the phy
ends up in PHY_HALTED state.

Instead of returning -EOPNOTSUPP, call genphy_c45_config_aneg()
(analogous to the C22 case) so that the state machine can run
correctly.

genphy_c45_config_aneg() closely resembles mv3310_config_aneg()
in drivers/net/phy/marvell10g.c, excluding vendor specific
configurations for 1000BaseT.

Fixes: 22b56e827093 ("net: phy: replace genphy_10g_driver with genphy_c45_d=
river")

Signed-off-by: Marco Hartmann <marco.hartmann@nxp.com>
---
Changes in v2:
- corrected commit message
- reordered variables
---
---
 drivers/net/phy/phy-c45.c | 26 ++++++++++++++++++++++++++
 drivers/net/phy/phy.c     |  2 +-
 include/linux/phy.h       |  1 +
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
index 58bb25e4af10..7935593debb1 100644
--- a/drivers/net/phy/phy-c45.c
+++ b/drivers/net/phy/phy-c45.c
@@ -523,6 +523,32 @@ int genphy_c45_read_status(struct phy_device *phydev)
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
+	bool changed =3D false;
+	int ret;
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

