Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D5A26162
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 12:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbfEVKG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 06:06:59 -0400
Received: from mail-eopbgr810058.outbound.protection.outlook.com ([40.107.81.58]:11310
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728424AbfEVKG7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 06:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector1-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rX18qGluAjpxM1daLsr76kdNOUBKhTLa0+6B0Mh2FiY=;
 b=WeRnJLXzG6w6TgIMuC3C3kBOQYURb7Zq8cR4lWeZC6K+T+Dvq7ZD5R/hv4W9enHAZ7x/4SWtmAfkgYEH7M22P2rEqvwHY1phaMZ7EOsXRW5/B2ZaJEoBJjsXDu10ikwfs/pfjq2k5700HrUIrmakPhhCpZN3w+XUeHAGkZkRVtA=
Received: from BYAPR03MB4773.namprd03.prod.outlook.com (20.179.92.152) by
 BYAPR03MB4152.namprd03.prod.outlook.com (20.177.184.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Wed, 22 May 2019 10:06:56 +0000
Received: from BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9]) by BYAPR03MB4773.namprd03.prod.outlook.com
 ([fe80::e484:f15c:c415:5ff9%7]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 10:06:56 +0000
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: stmmac: move reset gpio parse & request to
 stmmac_mdio_register
Thread-Topic: [PATCH] net: stmmac: move reset gpio parse & request to
 stmmac_mdio_register
Thread-Index: AQHVEIYW+OFyF9L5KEiO6GGfPTpjTw==
Date:   Wed, 22 May 2019 10:06:56 +0000
Message-ID: <20190522175752.0cdfe19d@xhacker.debian>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [124.74.246.114]
x-clientproxiedby: TY2PR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:404:f6::26) To BYAPR03MB4773.namprd03.prod.outlook.com
 (2603:10b6:a03:134::24)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jisheng.Zhang@synaptics.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de1886d9-3ed1-4630-c37f-08d6de9d38cd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:BYAPR03MB4152;
x-ms-traffictypediagnostic: BYAPR03MB4152:
x-microsoft-antispam-prvs: <BYAPR03MB4152E05BA999778BA56FFD28ED000@BYAPR03MB4152.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(39860400002)(346002)(396003)(376002)(199004)(189003)(53936002)(14454004)(72206003)(6506007)(486006)(81166006)(71190400001)(71200400001)(6512007)(9686003)(386003)(8676002)(81156014)(478600001)(476003)(8936002)(110136005)(50226002)(6116002)(99286004)(25786009)(54906003)(6486002)(68736007)(6436002)(52116002)(102836004)(4326008)(3846002)(66066001)(66556008)(64756008)(66446008)(256004)(66946007)(66476007)(316002)(14444005)(305945005)(7736002)(186003)(1076003)(86362001)(5660300002)(73956011)(26005)(2906002)(39210200001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR03MB4152;H:BYAPR03MB4773.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: synaptics.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: h0Q0+ABRPQBIishFE/Rrcg33EbMVzr4nxEp0RnWwfl5q6Drrxtw0SYXmpnUOhCw/BKUMZ4pP99HPaGMxyvb80BVepC/8yxKXJc64IiYB+Eo4bvf8R+b/jI+4auP67yrC+tsHGwNV+lymbFBWXaNUKc5UPqP+t2v0wpwzPpQ/1Tgzf8RUIPLtbtTYpPIFjOiq+9L0a/MjSuLkkP9YireAPTHMEWWzlZ3dJL4zjg633IMDqofKObbr5owa0CytG5VcWsCDEGdqzU33aAyfqn4b54XStMlFzxTitjQyfBT3A/U9iTrNKrC4vERT4PK/PUWMucrmStNnTKK3Aa3SikTorkrFTYZqJi4pJIwrWFFuYS8WFnIzHUAXz7M90PD8ZMIOp3N8ztcfTNZpqC9QK2acJ88/Ww2k3F7WmneHwzyhoa8=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14835D012B0BE24989EE140AC858F16C@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de1886d9-3ed1-4630-c37f-08d6de9d38cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 10:06:56.8273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB4152
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the reset gpio dt parse and request to stmmac_mdio_register(),
thus makes the mdio code straightforward.

This patch also replace stack var mdio_bus_data with data to simplify
the code.

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 58 ++++++++-----------
 1 file changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/ne=
t/ethernet/stmicro/stmmac/stmmac_mdio.c
index 093a223fe408..7d1562ec1149 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -250,28 +250,7 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 	struct stmmac_mdio_bus_data *data =3D priv->plat->mdio_bus_data;
=20
 #ifdef CONFIG_OF
-	if (priv->device->of_node) {
-		if (data->reset_gpio < 0) {
-			struct device_node *np =3D priv->device->of_node;
-
-			if (!np)
-				return 0;
-
-			data->reset_gpio =3D of_get_named_gpio(np,
-						"snps,reset-gpio", 0);
-			if (data->reset_gpio < 0)
-				return 0;
-
-			data->active_low =3D of_property_read_bool(np,
-						"snps,reset-active-low");
-			of_property_read_u32_array(np,
-				"snps,reset-delays-us", data->delays, 3);
-
-			if (devm_gpio_request(priv->device, data->reset_gpio,
-					      "mdio-reset"))
-				return 0;
-		}
-
+	if (gpio_is_valid(data->reset_gpio)) {
 		gpio_direction_output(data->reset_gpio,
 				      data->active_low ? 1 : 0);
 		if (data->delays[0])
@@ -313,24 +292,38 @@ int stmmac_mdio_register(struct net_device *ndev)
 	int err =3D 0;
 	struct mii_bus *new_bus;
 	struct stmmac_priv *priv =3D netdev_priv(ndev);
-	struct stmmac_mdio_bus_data *mdio_bus_data =3D priv->plat->mdio_bus_data;
+	struct stmmac_mdio_bus_data *data =3D priv->plat->mdio_bus_data;
 	struct device_node *mdio_node =3D priv->plat->mdio_node;
 	struct device *dev =3D ndev->dev.parent;
 	int addr, found, max_addr;
=20
-	if (!mdio_bus_data)
+	if (!data)
 		return 0;
=20
 	new_bus =3D mdiobus_alloc();
 	if (!new_bus)
 		return -ENOMEM;
=20
-	if (mdio_bus_data->irqs)
-		memcpy(new_bus->irq, mdio_bus_data->irqs, sizeof(new_bus->irq));
+	if (data->irqs)
+		memcpy(new_bus->irq, data->irqs, sizeof(new_bus->irq));
=20
 #ifdef CONFIG_OF
-	if (priv->device->of_node)
-		mdio_bus_data->reset_gpio =3D -1;
+	if (priv->device->of_node) {
+		struct device_node *np =3D priv->device->of_node;
+
+		data->reset_gpio =3D of_get_named_gpio(np, "snps,reset-gpio", 0);
+		if (gpio_is_valid(data->reset_gpio)) {
+			data->active_low =3D of_property_read_bool(np,
+						"snps,reset-active-low");
+			of_property_read_u32_array(np,
+				"snps,reset-delays-us", data->delays, 3);
+
+			devm_gpio_request(priv->device, data->reset_gpio,
+					  "mdio-reset");
+		}
+	} else {
+		data->reset_gpio =3D -1;
+	}
 #endif
=20
 	new_bus->name =3D "stmmac";
@@ -356,7 +349,7 @@ int stmmac_mdio_register(struct net_device *ndev)
 	snprintf(new_bus->id, MII_BUS_ID_SIZE, "%s-%x",
 		 new_bus->name, priv->plat->bus_id);
 	new_bus->priv =3D ndev;
-	new_bus->phy_mask =3D mdio_bus_data->phy_mask;
+	new_bus->phy_mask =3D data->phy_mask;
 	new_bus->parent =3D priv->device;
=20
 	err =3D of_mdiobus_register(new_bus, mdio_node);
@@ -379,10 +372,9 @@ int stmmac_mdio_register(struct net_device *ndev)
 		 * If an IRQ was provided to be assigned after
 		 * the bus probe, do it here.
 		 */
-		if (!mdio_bus_data->irqs &&
-		    (mdio_bus_data->probed_phy_irq > 0)) {
-			new_bus->irq[addr] =3D mdio_bus_data->probed_phy_irq;
-			phydev->irq =3D mdio_bus_data->probed_phy_irq;
+		if (!data->irqs && (data->probed_phy_irq > 0)) {
+			new_bus->irq[addr] =3D data->probed_phy_irq;
+			phydev->irq =3D data->probed_phy_irq;
 		}
=20
 		/*
--=20
2.20.1

