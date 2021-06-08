Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3193239EC97
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbhFHDDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:03:35 -0400
Received: from mail-eopbgr30074.outbound.protection.outlook.com ([40.107.3.74]:43425
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231393AbhFHDDe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 23:03:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAAxGPYRnvh/dt38WTh3gDzRQie9GKUN981cRH3DS1e+AWhcBO/r2V0Q6di6Tjy5qcgIbgCD4IQzJsWC4yPYu7gjiP50Yo3mcgXbeeN4uxK+kE69nk/aT7gRFfdH+yzMKkfvNVoasUOJo1BbdVKtCdQ5wGSxpyJgJlm6nH5Jfct+YWVSyFLRmUZ9x8yD6TAoVskqmCPOxmLdd9FWk68F8xOD+M81CFWaQ72pxPh9hO8eNEqLuufo2D7ubpFRlTjdH6FYlTIBHqUXqd5D8b6SKGVu0qxhxGGMYf7Hl0eGeiY81jP2VDCOIRh/f3YNNYEtNTcSUwC7WFrBXcjaYKz3hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uybfxS5nmvyuPdoUS1ib3fB5t0WM31xUyjA49eJmzKM=;
 b=OO72qODhiWbMErcK2yk+QNFrjBeJWrFfvDOkpbGlb6ANL+MEul2SXHloKud1uCiS2XrOm1pBTdhHteypj9B0MNNb8FLGMplfDR3eSjiS/PonHPBG4pMhYOcQD35aqgbpWAAFsDm7WD2+ptDzhX2oiWZ8xXBzoYKIWZL8AJHdS6ixjsnZcIv0iFRq0fiy3RpXNgJquwoG8TPfQ7nCotkiXvHl28Jvm+yMu3s7oRwWW0L4fAUjyi1aU9F7wklAGft2EUyU45CcTa3ShyHpEeF0tw6kv0LIk1YkZbdlY4L1wO+HzmWQhpMOpvE4RwwfdBElRu8IiObpl4lp8bc20uF0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uybfxS5nmvyuPdoUS1ib3fB5t0WM31xUyjA49eJmzKM=;
 b=rGsV6LUKjDeXXZYdv7PIhDWPdr+55H730fqeQHK1sNJb1/RG5eGyQUv+DHISJhdNyPhW3R6EGQjq4xE6+gUb4tiWZlyMj+Fl79rRYia4D9K+VC7RWZC9CQ59QSm0h4mS9/JJ/eZD0KiBdc6ZgoP9PrXYg6PrggtAOiDOJleNdFc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2904.eurprd04.prod.outlook.com (2603:10a6:4:9c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.26; Tue, 8 Jun
 2021 03:01:40 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4195.030; Tue, 8 Jun 2021
 03:01:40 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        f.fainelli@gmail.com, Jisheng.Zhang@synaptics.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 3/4] net: phy: realtek: add dt property to disable ALDPS mode
Date:   Tue,  8 Jun 2021 11:00:33 +0800
Message-Id: <20210608030034.3113-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
References: <20210608030034.3113-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0151.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Tue, 8 Jun 2021 03:01:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7132483-25ec-4b61-4e5b-08d92a29bcba
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2904:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB290473BB22A55AE6537826A1E6379@DB6PR0402MB2904.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0A/kU4u5FkFKWaQ6dvFiX7JYZHVl/uhPFdnAwHV7zXCv0oEE1j4Th2bg6U8OCr747gCV4dTnBFgPc1HCOnIzhctA6taoM//5YUO1jbO/ckfWg3BYof+InQVgvnTUNjOtQC3dl5cLS/aMOOFPupO0gW5ieEPjQ/sk6pghxj1DjaY6EvOUpt4E+WUCc2ymkJBhkd5HhB7Bpk5/5RkZUDgrzMS8L+8OLNSNonZcvBRefeFXvYvhgKoGeez7KPWuGxUb5SEHaemjFvoSrKE1mn6jBJW5NTYmlcvv38748iTWICyj8wcU7xrIwLeEcHLKPauLiTXPm3/3JY1+3PS+G+mKwHtJSfc+lNmUWSSo9Sk57NRt8kOw3u7ssuDfhS0cXmransBvLpJ8gBOtcScSNgfTNUQkyTFwE6Lfu1NAwZ4WHKNWUzPd/I9laxRvmTpAzAgQnK1klAdO9j/7S5myeVJODGvjv7daJ0/wJNfeM2oBWb5UcCEe2ypV1Ty8N54DTJ/QaZr3xh1T8m1n74wbBAND1zR7WNvS5Czlh1eevyKyMMvcMS9jL/iYajAvicUaZE8D7lL4kawFVa4NOdUCQHdaZpjWZxxdaTTXyQI3qTeeHAAqG5Y/UKX51c4hWuMYv+/nmOcsJC2KtQ/o9zQTCzKGVhXBHzhxFLhZDgdbxdG6f2P2LcLt3Tvd1jijySgAMqqY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(39860400002)(366004)(376002)(83380400001)(6666004)(38350700002)(86362001)(7416002)(6486002)(52116002)(16526019)(6512007)(6506007)(38100700002)(4326008)(2906002)(66476007)(66556008)(8936002)(956004)(316002)(66946007)(5660300002)(8676002)(186003)(26005)(2616005)(1076003)(478600001)(36756003)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pJRD85xmb7FrkqbP+16UB7JJTJHclLI294FYwuhuuIIoK4I8X3+Jx+TZETNl?=
 =?us-ascii?Q?HM0S63aVmfa2nG1kYwZxr5noWr8AU/dB457JVkt9ffnoFdBcnzcOLyxT2fFP?=
 =?us-ascii?Q?uFx7zKJvG3sJebkFAqKQN96pN+bup/wgHCuj9+dPMjU5jl/SY/2onupwMQE+?=
 =?us-ascii?Q?iwR2xrNYO8wZDbIeoV24CbCfiPcacGSRFxuj8iB9TZHygy7sWU1Wk8JI1VpK?=
 =?us-ascii?Q?l/f87B6cIQnJhVxDQtHHY7X4XRtFMFm3ACcEu1rr42q/w+/C7wNhV+keOgDn?=
 =?us-ascii?Q?O7zkJqLScubt1mAL3izBIPy3ajl938e8KkLoDU4eUXI2D8sdChEfXC2azGSi?=
 =?us-ascii?Q?zvKEtj2msWBWdo4qjxLiSxnjAv6pKzt3oj343CZW+nZpaNgQTdc5zo2XxZSX?=
 =?us-ascii?Q?1vjJlrj0eyboSOGqgYqdm01706l84VV1nWwNQazpvRxYWO6QFHBaiPAVWck/?=
 =?us-ascii?Q?T++CuSET1HdcATsnd5FlVJ/wLvJT8HzUfDaExBChUCYtDlQcr910BityX3v+?=
 =?us-ascii?Q?KbUp+Sx/BLUDMzcSPkiOpRPWxjeQaYaXBx9rl0dHkF3lX/HbTZm+VFu14vpc?=
 =?us-ascii?Q?7DkErftbuRTSQZTIE3mOmm55iM2tTxt+1H8GigtlV4jRAUYwZNKDuZNm7/xU?=
 =?us-ascii?Q?Mk3Z2TxrOFlx5yk0xgu1d7GioCcwlmok1JCOJhoFyDaDQONoj22Fsl3RCX1r?=
 =?us-ascii?Q?dw/0n9gNesYTAqI9nSqQ3gbE846+EhqBjn7Cm2/HFpt0B+67OY87ZwABLyrJ?=
 =?us-ascii?Q?j2a9omZjZ4XhI8s+nywVIuc3W4XA4eWQGyp572gchkVdOFMjhGH1GXezSirz?=
 =?us-ascii?Q?DJbQPQcJPexG+XLsiFNLaGuU/BHaEuTaRc+4WO2bpDRKCxs+zzufWa9vhMpa?=
 =?us-ascii?Q?/PCgLPVBRT9dJhocGVGCLHKvq0ATG1ZSI7jlAppnCL0YkdUYXjkKNJOsmk34?=
 =?us-ascii?Q?zOK6WNudS6ohtUdMobLFPZqL0pxZNkFEsbNDLDgUHEJq0iM99Qk/fk+9iwpg?=
 =?us-ascii?Q?pimmSDLndrabehoa/EhZha2bdDwV8Mo1QFGcWY7qr0CMBw+JsuCG+XL7TGr0?=
 =?us-ascii?Q?TSagKe+JtnPIi7Tkk4bKLXz+YP3leYJ1X/r2BsUg7p6XOCKHNXiH1dgwhAbQ?=
 =?us-ascii?Q?5gtV+6VECs6Otd/N8qsaHxj4SCK7i5c6IDChuX8obHG+Jk7aXEE5kU1EAUYl?=
 =?us-ascii?Q?AnJNGB34oaIyBl1NRJJlPO82c3at6qJFr2TKVIbhEsw+hLfVnAtx488yWom+?=
 =?us-ascii?Q?6BggoPacnCr7VcimkChmGsr06HwwcUMCTl1C5vkRg4jxnxl5e0713AFDqvWY?=
 =?us-ascii?Q?Ww23iwgTgfB7VFhcz/c67a5x?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7132483-25ec-4b61-4e5b-08d92a29bcba
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 03:01:39.9770
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q5BgrND1J6E3ntdx0DMyuHADsTLMVv1wS1z7Eai+C9jbRcvXgpHQTpWmCBdkS/B6IypDGEy9DMfeeckDPQNKhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2904
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

