Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D7039ECE6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231380AbhFHDSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:18:07 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:10751
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231322AbhFHDSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:18:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nUp25OgV+hWflJe5qD2l/tM2SbikOILwPww6IZ8MzUTIUXjk6sKFZEJYWlIzAbtNjBgBhg/7CEn+93fR1+YtSkV/BT43KHD409+FT3NFzK++qiPJHNIThDnYxZt0+hmN28VRKsRTKc5Rc0I2s/KK8+94UYddSCGuVpSFtE29OnnYCpPIB5pz4thOvHJBOHixeCsNAxGHfEgBJVLdnx7BrgIVgwhZHb+HL7ox0hXuXh/pmzBVy8tXD2msijF864ymBAtPFy6UoVs3yd+wolyXui054YvkybpBkkK/x7WtEhL0PE5pZZ6/oeYRyiTLsOliCBM+2xdaKD4gf4vq2JUzXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uybfxS5nmvyuPdoUS1ib3fB5t0WM31xUyjA49eJmzKM=;
 b=MPOwb/PqLyijgSwpOsL9mlC5R3/obLI7pMq5CfFqvXFvLJJWuWXnKLQoxEfL6Lx9D93a2la/mlv/VS08cD0IdTU2YO+cyUKAup77UdywSqnbDdSIOKK8Zw2OXk7G2z8SqfZ0DgHPesudOc4D8B0XDaHVlAxR5Pl0GCXh8T3M7l+/Ct+/SHs2HA7k1QIdVxsG0Fnqoama+FUpBylSNzMLFKSz7gYpXxbs747pUCRw7VCYaJJmv1+dseHEKk3tsngfnLTa4rYwG4QKvhSti4ZOSACtGm+niVGxklUQDoCuT1p6btPbuagKZaRxocSPcIrRCkiIKhlAPhY7kagDgX77lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uybfxS5nmvyuPdoUS1ib3fB5t0WM31xUyjA49eJmzKM=;
 b=EXTpOyvMKlIG1NnCTcdJ3aKk2mnvK6RwaA8EVkv+YAPnoDiNvS4tURBLLT+eUGKw9gNq3HS2aY8IAcwbvKE0aJ7mb7bGpqNkj+6+zNRI51swUHC36amTmCHjmq993Q/P7v+9neb/UJ4E6p++IYU33gKM66GAb5XSfmbm376/kuQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6139.eurprd04.prod.outlook.com (2603:10a6:10:ca::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Tue, 8 Jun
 2021 03:16:11 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:16:11 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 net-next 3/4] net: phy: realtek: add dt property to enable ALDPS mode
Date:   Tue,  8 Jun 2021 11:15:34 +0800
Message-Id: <20210608031535.3651-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
References: <20210608031535.3651-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24 via Frontend Transport; Tue, 8 Jun 2021 03:16:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 338dfcca-561b-416f-4c25-08d92a2bc440
X-MS-TrafficTypeDiagnostic: DBBPR04MB6139:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB6139DB3FDE86CCE93DF1E435E6379@DBBPR04MB6139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OZh5AYoVrT+ioqV7htnAl5eEEZqdnqdHCJePBbVmIkisaBhLRh0rVjYPK/0XeP7oeXsGUjhtZ7auC1x4avODYvwWIms1sFU2DbSqHtDPO5KDqZ1Skokc5opmb3gxZeRjq4H92kfuFN4A1OLCJjJoZ/q0pKkB7p3ECuTAdbooD1BD8mKY3ZjXYSKj4yQPXTB4hgdolph2+iMzcSr4T3EohmD33j5KNLW8Z+D/VgWLCsyaLXAoiuDYHxNrzZ6ESR4pb+jY+3xYLCiZ2aqaQsSM5rOrZ/sJ7kBXBq8uA6qKNM5p5zTeykzrWK8dd6Vb1C6O8AaIyOid25qV7JxwH4wf6z7Z43XhbuyZy6CKeD8SGbPhnt/grUlwsVzPIaJufEIVFttfWKD1+1C66IGbcgiqQ4dWQn6srBdxIzxstoXTPFCPsZ7cGTKnMJ56xCfqzjl48M+uk8r7yttyTIlGzWxVHEPzGEVas3XEd+W3Zthy1WOa3IjJSyQtRQ1EqO7bcWIf80WvCVUw+uubdh0zadJoMM+OdgXSyTzcgoZUxDm5cLeuUeaqfwkB3FhUW7g94Xf5ikHhV6cw2SyeEfUCAuc9NNPy/3eT36PPU0JWdfKlyeTKhXKslMkgZFaAIZHzmw/Lky6sOVE98HDkG9UpZ9J76p39ljDz7cMK9Xv/psLc5rws4y4vHh5+g1kgwMSXPTI5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(66476007)(66556008)(8676002)(5660300002)(66946007)(38100700002)(83380400001)(38350700002)(36756003)(6666004)(1076003)(8936002)(6506007)(6512007)(86362001)(52116002)(16526019)(6486002)(26005)(7416002)(186003)(956004)(4326008)(2906002)(478600001)(316002)(2616005)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VJFRLLuA0+Hi8+k+ctHy8h+bjCHkZZQDGt8t4iEQ6XjfUAuHofcRwi/mIq+z?=
 =?us-ascii?Q?4kLR8S7TyxKFnQxkUGFBRiTlEkUmUwCwt9OKvoH6aMx1/UOjW8XEzD/6ZYWq?=
 =?us-ascii?Q?mgTv7c903XYDKVFPt/2OBMgYK2Lz55fM2lp9S4q6r8pAoMld0g8UHgWc74C8?=
 =?us-ascii?Q?5O+RQ/f1ShfF00+sdseTKIvYYBi9QNsW11vSfqK0s1HS1iIgi7utAgYgelWL?=
 =?us-ascii?Q?xV9Xj8cAK1SGl3mJ0oYu9UCzxOMvxY90C4HgOqEhLiPBFlRU1BFQpxuSRr8G?=
 =?us-ascii?Q?pvTtAsuDf83y/bS2ZnGkF8sWmd5K3P90SPIuj9v4+0GcIgOvemhljjJfMTtI?=
 =?us-ascii?Q?yvjURidDk98+TOvQvmJslBvR/pR3uUWh5NFlGEaGgjpl49QSsYxvKz5muZyB?=
 =?us-ascii?Q?whR3cfQM9N0lFS8+6B9/ogLOAZO0Z1V2juAvWvvUQJ4uqQ1Muym5cX6iCGGZ?=
 =?us-ascii?Q?6WUIoqp9QhO9bVUZoJZrKMKUSvLbTp+oqKU6haOp4ejdEkSo+3qD8MK5U66U?=
 =?us-ascii?Q?iFSOO0q1KLXCOEeyXRIXo8X5VPgdmuEJhP2Z2zWQsQQ4s+HiInXfTbKIu97t?=
 =?us-ascii?Q?Vt8alphCRQ4PljAnyB/JLwehQsKwjKpyT+MTJBvQVyr2rn2bvw8691Z4RKI9?=
 =?us-ascii?Q?7BzREyi7SqvoaKCnfc3Wg6BiSoNNkkBbOIBZfp3UdQTVmYLRImgLm63QhPy1?=
 =?us-ascii?Q?sI/YhFJdMTWyKz9d4Bu/R9qEf8KaPmRQamkxWBiKXuzIXDN06MZq6hAvfELy?=
 =?us-ascii?Q?EOg2gNRH/20DLrYwaMRkd9BkfIwlqw65s55myG4FOqVHBkMPuCqivKDdaMNc?=
 =?us-ascii?Q?IdK7ZQgLgCmIODK1pvnMAzfQzIifRBbI5eionQg3gm2oJcqhi/96BadRn6aB?=
 =?us-ascii?Q?YlYsU2sRSyV4N/eqgfQPesV1SgIQGUt4ByGUxu99YvVYdqq4nt/RDk5GrUYH?=
 =?us-ascii?Q?Y5BQdZz3YuCqr6+cEqGu80NIArwicoY2BZx+9ww1NHiJPadoZaGgkizo2vVY?=
 =?us-ascii?Q?KyJ1gZfR/YHl/hlQfMGy4Dxapq4b4cMEc8FV6DpfJopGiU4kM43my+GVe84b?=
 =?us-ascii?Q?ikMFgbITRQojJ886EqrQqGBkLtQqUUK50wRyko7lzYXs5Y2gPZHZjJjIHM4Y?=
 =?us-ascii?Q?xuxz3x4JQZ7Uvr4X9ptUCCkLjNR5/7Orw7uXYLdnccTCdLKFD86O3b7AQ7hF?=
 =?us-ascii?Q?yWE0GMslxfT/ff7NmVT0NxkJHpNyZ4h8z9xUA8d09SHS2EZ2QrMpWd68xMRq?=
 =?us-ascii?Q?VaqsnhDV53lU16CaUfba24Cak6LSKiMDKoNfdI0RDVcRGhxTe0EZnKee/Ek8?=
 =?us-ascii?Q?LHOelkaWSquKAn/AwDzMq5wA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 338dfcca-561b-416f-4c25-08d92a2bc440
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:16:11.5956
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJZPEUGVDQKced3hyQxeV9TOtcnv4ZYxUapUZWy2QALhMUniQwsUajgmAWwGU5YPampX5WDglY/YoMT4OxyH/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If enable Advance Link Down Power Saving (ALDPS) mode, it will change
crystal/clock behavior, which cause RXC clock stop for dozens to hundreds
of miliseconds. This is comfirmed by Realtek engineer. For some MACs, it
needs RXC clock to support RX logic, after this patch, PHY can generate
continuous RXC clock during auto-negotiation.

ALDPS default is disabled after hardware reset, it's more reasonable to
add a property to enable this feature, since ALDPS would introduce side effect.
This patch adds dt property "realtek,aldps-enable" to enable ALDPS mode
per users' requirement.

Jisheng Zhang enables this feature, changes the default behavior. Since
mine patch breaks the rule that new implementation should not break
existing design, so Cc'ed let him know to see if it can be accepted.

Cc: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/realtek.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index ca258f2a9613..79dc55bb4091 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -76,6 +76,7 @@ MODULE_AUTHOR("Johnson Leung");
 MODULE_LICENSE("GPL");
 
 struct rtl821x_priv {
+	u16 phycr1;
 	u16 phycr2;
 };
 
@@ -98,6 +99,14 @@ static int rtl821x_probe(struct phy_device *phydev)
 	if (!priv)
 		return -ENOMEM;
 
+	priv->phycr1 = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR1);
+	if (priv->phycr1 < 0)
+		return priv->phycr1;
+
+	priv->phycr1 &= (RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF);
+	if (of_property_read_bool(dev->of_node, "realtek,aldps-enable"))
+		priv->phycr1 |= RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF;
+
 	priv->phycr2 = phy_read_paged(phydev, 0xa43, RTL8211F_PHYCR2);
 	if (priv->phycr2 < 0)
 		return priv->phycr2;
@@ -324,11 +333,16 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 	struct rtl821x_priv *priv = phydev->priv;
 	struct device *dev = &phydev->mdio.dev;
 	u16 val_txdly, val_rxdly;
-	u16 val;
 	int ret;
 
-	val = RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_XTAL_OFF;
-	phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1, val, val);
+	ret = phy_modify_paged_changed(phydev, 0xa43, RTL8211F_PHYCR1,
+				       RTL8211F_ALDPS_PLL_OFF | RTL8211F_ALDPS_ENABLE | RTL8211F_ALDPS_XTAL_OFF,
+				       priv->phycr1);
+	if (ret < 0) {
+		dev_err(dev, "aldps mode  configuration failed: %pe\n",
+			ERR_PTR(ret));
+		return ret;
+	}
 
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
-- 
2.17.1

