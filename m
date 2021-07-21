Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DC33D0D8F
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 13:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbhGUKpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 06:45:12 -0400
Received: from mail-eopbgr60073.outbound.protection.outlook.com ([40.107.6.73]:21728
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238141AbhGUJc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 05:32:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwqFTnTKrm0kij+6t/+0HzCAhtknaXM5VAq7cehh678eSaxdkKSBVCa33/Et1NbvqPEqexH4w16sdBtsoSTRHIXyIJvATd0zzhWlsB8VBxwYdct9IERWFYiYoI1oauJZjWMYdHt6Bps/ZIwehgsCRbTVLHlagsYVyGUT6a+a+4NTxR5xUwED5EmTbRawpGxp8me7xDYufqvqbwmiWu8GsF0mlwYwK1Flu/mwSif7bp1wF+AWrrwQFqmCGCzuhYoRudCZYQ1AKJmrpkAQLTo0nSoi22lKBNnDfP1TCuPpM4/GWKpBKQcTmGy3pbm5G1NyyP1TQz5WjaVuLXRoTiYqHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgtGxeyUcrhHwgZ30kb4K94aKLFiSjxyvU60PG1rr+s=;
 b=ftUeHBVgRURtOyO35yvorVMDAyZEKJoNifGM094OZ+avSZNkvFGqnjLnt5etJDbQwBYN2iAzd4LuxBUNDvUQif/hXLplr8ZN0i8uRZNmVnnB8pUfwlg6eMX0zDoMZccdMoz9ijP9+VpZfIQG5qcdt3GUfTHLmxJ/CDIF2KUL4aKeoCRm3dR1KDkb4/Uu/jXQkaho0f4X3yo4A9Mnsg1qLHFgJ3SW1uzGflV0HjxvHN4eg+ypeINV21Ihtpug31DsqenNSMkclWCuE7/92Btzq3OWzCA3LrjRoqzxGJhUGL/9a5StmwaAcBporSz8recB7P+IkXgpyCDw4Qlm6VQfoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mgtGxeyUcrhHwgZ30kb4K94aKLFiSjxyvU60PG1rr+s=;
 b=P71oi8gfsWjnyLs7Rvs/MJstxER8N1G7rxevjnTJwQNDIJFRv5zLFRJMDGPbxwEf5ETfiMbWqWFNL8KLsP187bPtH5clvoLe1oMGcU1JSKQ5E8+yO5YBy1kQdjHdQCLUSPSaZtcGwHKlTu6L4284svXs7Xd9qHqMRry0YfZxCKc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7480.eurprd04.prod.outlook.com (2603:10a6:10:1a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.23; Wed, 21 Jul
 2021 10:12:05 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.034; Wed, 21 Jul 2021
 10:12:05 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH net-next 2/2] ARM: dts: imx6qdl: move phy properties into phy device node
Date:   Wed, 21 Jul 2021 18:12:20 +0800
Message-Id: <20210721101220.22781-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210721101220.22781-1-qiangqing.zhang@nxp.com>
References: <20210721101220.22781-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0195.apcprd04.prod.outlook.com
 (2603:1096:4:14::33) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0195.apcprd04.prod.outlook.com (2603:1096:4:14::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Wed, 21 Jul 2021 10:12:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ec402709-641e-40e9-6118-08d94c2ffdb5
X-MS-TrafficTypeDiagnostic: DBAPR04MB7480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB74804F9EA2643CE44491BCBAE6E39@DBAPR04MB7480.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:159;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bhbh/5qH+MgP4C9Y80hRStZuDGjPPs0pDMBVy57GTtUJm/7VDrMXewn5kqYARPRziTsYQ82er3hPexBB9qA+Whm5nSUqakn2KxC5LtvGdUFC7j2RGTnBcIHdAbvdI7gy+df2W9erRPuJM8j6hfLbSaos72XLEc9tsDi6SegneGhQ7IWPqohrLXUHXNniic0L5vh2QHF7OK3uzttmgEPw//32uOUG7hJ+BUP19MGvWOTDrpUSAMGzO7DmKykmuY3ojAtY+dKgb8ONoyWSsmed0FQP3ZyI2CNgFF3Y9SI6SkMtfozWrkBleKmBRNQJmo4tZX+yZ85LDGmvy7mRQLzZmFF51jrcoNXVLL9LC/6cbO6iKIQFDMqexPPq+WXDQ1jgGXR3r3Z86HG81clPkTyEemGfcMpuDEofuSH1lcklk/gwDVH3jtXnthp04W+PU6mQfTJUiz8NAerV7CSKbtWDY+7hK+GAyln+DTYVeChK62RiDQlIJvTaHZk+y9sf+JnmoaYeT5xbDuQVRrZ7F6AAlRhfe1AKsSqC21bINiCN+kLvtyouEe+dd2EScA6dVfVhPE6IDtIIQEf1/sUNQdGtgSLV/HDvd5nQB6kGHEe0+og5n84zf3QBXEj5GKw2kKvU/o5U/RdSW/diF6Hr/pyvq23Ezl47T0fD49dsCBE/tXKH/TmGWq8n+fS5WOAXR05eE/ZnDRKfhYqVGwfinvppuRsi102ICeS7fMXTzmiPDrk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(136003)(396003)(39860400002)(1076003)(4326008)(186003)(66476007)(66946007)(5660300002)(6486002)(8676002)(478600001)(7416002)(2906002)(26005)(52116002)(83380400001)(6506007)(86362001)(38350700002)(6666004)(8936002)(38100700002)(2616005)(6512007)(36756003)(956004)(316002)(66556008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j4r3+ZS2bpar/At68dMUgCRYwLCl2ECGbBrZ1ybC7fafkVqBZNOY1z8vL/Se?=
 =?us-ascii?Q?0pNzW9LsgxmlWX9z5jyirKFHSdG0BrQDyHHQUgTRYrJBU0aDyy5+PrLiKyS2?=
 =?us-ascii?Q?n9PQ5gm93+SwevHMbycUje6uzf+rvSVnRvD3zCuc4nKjG1YzNhVW3ibj7KTb?=
 =?us-ascii?Q?jNtgWarx81SsIq3xn4XzeZUHv435j3K2OPt/lkbWZWhuJRtFPKaesRxhWie7?=
 =?us-ascii?Q?SAEFSYKvtunGGKxsHYXMXH+QgpbBGedXmgbzwmkZWR7TkPjazK1bcZvvC6ga?=
 =?us-ascii?Q?wodPeFdpUxCSyPLnLa0+e7OEvIydQEXKBchc/FwLUq/D3TA16E3ca/KobVse?=
 =?us-ascii?Q?9h/P4sHRqwokfyV+Rs737EL+gaRd7+Z+r/n3Um7zlhy8MBkQ8Dn4LynQLTin?=
 =?us-ascii?Q?YzZV/Qlo1J4yGXR4Z3owmCQVd6a/b4UqsVDLDLe3Gqisc72M1hzjz9rgiyL8?=
 =?us-ascii?Q?OWHgovAog1/dokB/fgn2IoGcwg58yQUw+DnfmmVylXdBFkr3KZXLrJKZRpLx?=
 =?us-ascii?Q?PBsn89xvGqNVRmrk/2kcDBrXQO4JWYZLVRcslkFaHrK9AkykHkYlgLx3NN1n?=
 =?us-ascii?Q?isiLSgwqpuniQBTOgJzRUsptwW471TjrdKU0ngHavdxQz7YKnaFpxID2C7e0?=
 =?us-ascii?Q?eq0z0YdRKnMQiGasGHm0YJP9V7GJZEyQL7jLV9nZJY5UFI0P+tTbzEUC+KXK?=
 =?us-ascii?Q?gG46LKqNgjTQV8ITzUNFhTgt/00rMDihFL/VI0aP4XafvQapPaROlrzEg6EN?=
 =?us-ascii?Q?AekNgDUZrw/JMbKp92svBM7VbfmegBedRqCi7sASD0wE6YQMbIVVwx55I6m3?=
 =?us-ascii?Q?K4WHMOABTlh89L7PPLY9UqHNtHDAG++NrTty9fTDgypddazESvES9W1Idjlt?=
 =?us-ascii?Q?VxIdSQdCXRdqvNZpLfMZENUuiSaubaGyL/wLPmzu22CPbUf0iFJyfIJ9Nvgy?=
 =?us-ascii?Q?f0F6Fbs2AdovxbI8lSTTJ8fK9ru33QE3U7zYSA7DdkA8+nwBsvgkba9iYcAh?=
 =?us-ascii?Q?52xw7Y1T+lm3WwzAzWq8htCANKVVImtuLO9RamtY4Vm7gMmhXnv0myxqg5+w?=
 =?us-ascii?Q?h8+zw2qXdZsGu3IxW6FMIFKtlkgMxOCGmmkpJ2W7SMi7YhvfcKtbF12ZJZ8/?=
 =?us-ascii?Q?imJwcNGkaG/2g3+iKBwBn6NhOQbmn8XHGlbZhNEXiOKwCOXo7QOItqaRSg59?=
 =?us-ascii?Q?IkEyTjrZZ28aaFCml8+RWyV2xbQ34VeA8Ho/AVgtYJxpZ8wyen7nT2HeAdIO?=
 =?us-ascii?Q?hs/Ui8Qy0KqUYzH342hIwnHEuz/DHzrGbFNdSA7E9Ht+Ix4lMgb6GU4RCzY8?=
 =?us-ascii?Q?HMqlS7RwV7LyRu8EFfDKh6n0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec402709-641e-40e9-6118-08d94c2ffdb5
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2021 10:12:05.6667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGqqODsUGc1M9UheJ5UoHGXfxPepKkv8glBnfMhT2jzTI98iKSwgRFD9gIAF36g+uYEwy5VUDr9XUZQKJyzGqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7480
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes issues found by dtbs_check:
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/fsl,fec.yaml

According to the Micrel PHY dt-binding:
Documentation/devicetree/bindings/net/micrel-ksz90x1.txt,
Add clock delay in an Ethernet OF device node is deprecated, so move
these properties to PHY OF device node.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 arch/arm/boot/dts/imx6q-novena.dts           | 34 +++++++++++++-------
 arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi | 18 ++++++++---
 arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi     | 34 +++++++++++++-------
 arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi | 34 +++++++++++++-------
 arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi    | 34 +++++++++++++-------
 arch/arm/boot/dts/imx6qdl-sabrelite.dtsi     | 34 +++++++++++++-------
 6 files changed, 124 insertions(+), 64 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-novena.dts b/arch/arm/boot/dts/imx6q-novena.dts
index 52e3567d1859..225cf6b7a7a4 100644
--- a/arch/arm/boot/dts/imx6q-novena.dts
+++ b/arch/arm/boot/dts/imx6q-novena.dts
@@ -222,20 +222,30 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet_novena>;
 	phy-mode = "rgmii";
+	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio3 23 GPIO_ACTIVE_LOW>;
-	rxc-skew-ps = <3000>;
-	rxdv-skew-ps = <0>;
-	txc-skew-ps = <3000>;
-	txen-skew-ps = <0>;
-	rxd0-skew-ps = <0>;
-	rxd1-skew-ps = <0>;
-	rxd2-skew-ps = <0>;
-	rxd3-skew-ps = <0>;
-	txd0-skew-ps = <3000>;
-	txd1-skew-ps = <3000>;
-	txd2-skew-ps = <3000>;
-	txd3-skew-ps = <3000>;
 	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			rxc-skew-ps = <3000>;
+			rxdv-skew-ps = <0>;
+			txc-skew-ps = <3000>;
+			txen-skew-ps = <0>;
+			rxd0-skew-ps = <0>;
+			rxd1-skew-ps = <0>;
+			rxd2-skew-ps = <0>;
+			rxd3-skew-ps = <0>;
+			txd0-skew-ps = <3000>;
+			txd1-skew-ps = <3000>;
+			txd2-skew-ps = <3000>;
+			txd3-skew-ps = <3000>;
+		};
+	};
 };
 
 &hdmi {
diff --git a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
index ead7ba27e105..563bf9d44fe0 100644
--- a/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-aristainetos2.dtsi
@@ -316,12 +316,22 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio7 18 GPIO_ACTIVE_LOW>;
-	txd0-skew-ps = <0>;
-	txd1-skew-ps = <0>;
-	txd2-skew-ps = <0>;
-	txd3-skew-ps = <0>;
 	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			txd0-skew-ps = <0>;
+			txd1-skew-ps = <0>;
+			txd2-skew-ps = <0>;
+			txd3-skew-ps = <0>;
+		};
+	};
 };
 
 &gpmi {
diff --git a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
index d526f01a2c52..ac34709e9741 100644
--- a/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nit6xlite.dtsi
@@ -190,23 +190,33 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
-	txen-skew-ps = <0>;
-	txc-skew-ps = <3000>;
-	rxdv-skew-ps = <0>;
-	rxc-skew-ps = <3000>;
-	rxd0-skew-ps = <0>;
-	rxd1-skew-ps = <0>;
-	rxd2-skew-ps = <0>;
-	rxd3-skew-ps = <0>;
-	txd0-skew-ps = <0>;
-	txd1-skew-ps = <0>;
-	txd2-skew-ps = <0>;
-	txd3-skew-ps = <0>;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
 	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			txen-skew-ps = <0>;
+			txc-skew-ps = <3000>;
+			rxdv-skew-ps = <0>;
+			rxc-skew-ps = <3000>;
+			rxd0-skew-ps = <0>;
+			rxd1-skew-ps = <0>;
+			rxd2-skew-ps = <0>;
+			rxd3-skew-ps = <0>;
+			txd0-skew-ps = <0>;
+			txd1-skew-ps = <0>;
+			txd2-skew-ps = <0>;
+			txd3-skew-ps = <0>;
+		};
+	};
 };
 
 &hdmi {
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
index a0917823c244..c96f4d7e1e0d 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6_max.dtsi
@@ -332,23 +332,33 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
-	txen-skew-ps = <0>;
-	txc-skew-ps = <3000>;
-	rxdv-skew-ps = <0>;
-	rxc-skew-ps = <3000>;
-	rxd0-skew-ps = <0>;
-	rxd1-skew-ps = <0>;
-	rxd2-skew-ps = <0>;
-	rxd3-skew-ps = <0>;
-	txd0-skew-ps = <0>;
-	txd1-skew-ps = <0>;
-	txd2-skew-ps = <0>;
-	txd3-skew-ps = <0>;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
 	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			txen-skew-ps = <0>;
+			txc-skew-ps = <3000>;
+			rxdv-skew-ps = <0>;
+			rxc-skew-ps = <3000>;
+			rxd0-skew-ps = <0>;
+			rxd1-skew-ps = <0>;
+			rxd2-skew-ps = <0>;
+			rxd3-skew-ps = <0>;
+			txd0-skew-ps = <0>;
+			txd1-skew-ps = <0>;
+			txd2-skew-ps = <0>;
+			txd3-skew-ps = <0>;
+		};
+	};
 };
 
 &hdmi {
diff --git a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
index 1243677b5f97..49da30d7510c 100644
--- a/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-nitrogen6x.dtsi
@@ -265,23 +265,33 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
-	txen-skew-ps = <0>;
-	txc-skew-ps = <3000>;
-	rxdv-skew-ps = <0>;
-	rxc-skew-ps = <3000>;
-	rxd0-skew-ps = <0>;
-	rxd1-skew-ps = <0>;
-	rxd2-skew-ps = <0>;
-	rxd3-skew-ps = <0>;
-	txd0-skew-ps = <0>;
-	txd1-skew-ps = <0>;
-	txd2-skew-ps = <0>;
-	txd3-skew-ps = <0>;
 	interrupts-extended = <&gpio1 6 IRQ_TYPE_LEVEL_HIGH>,
 			      <&intc 0 119 IRQ_TYPE_LEVEL_HIGH>;
 	fsl,err006687-workaround-present;
 	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			txen-skew-ps = <0>;
+			txc-skew-ps = <3000>;
+			rxdv-skew-ps = <0>;
+			rxc-skew-ps = <3000>;
+			rxd0-skew-ps = <0>;
+			rxd1-skew-ps = <0>;
+			rxd2-skew-ps = <0>;
+			rxd3-skew-ps = <0>;
+			txd0-skew-ps = <0>;
+			txd1-skew-ps = <0>;
+			txd2-skew-ps = <0>;
+			txd3-skew-ps = <0>;
+		};
+	};
 };
 
 &hdmi {
diff --git a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
index fdc3aa9d544d..eb9a0b104f1c 100644
--- a/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabrelite.dtsi
@@ -324,20 +324,30 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_enet>;
 	phy-mode = "rgmii";
+	phy-handle = <&ethphy>;
 	phy-reset-gpios = <&gpio3 23 GPIO_ACTIVE_LOW>;
-	txen-skew-ps = <0>;
-	txc-skew-ps = <3000>;
-	rxdv-skew-ps = <0>;
-	rxc-skew-ps = <3000>;
-	rxd0-skew-ps = <0>;
-	rxd1-skew-ps = <0>;
-	rxd2-skew-ps = <0>;
-	rxd3-skew-ps = <0>;
-	txd0-skew-ps = <0>;
-	txd1-skew-ps = <0>;
-	txd2-skew-ps = <0>;
-	txd3-skew-ps = <0>;
 	status = "okay";
+
+	mdio {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ethphy: ethernet-phy {
+			compatible = "ethernet-phy-ieee802.3-c22";
+			txen-skew-ps = <0>;
+			txc-skew-ps = <3000>;
+			rxdv-skew-ps = <0>;
+			rxc-skew-ps = <3000>;
+			rxd0-skew-ps = <0>;
+			rxd1-skew-ps = <0>;
+			rxd2-skew-ps = <0>;
+			rxd3-skew-ps = <0>;
+			txd0-skew-ps = <0>;
+			txd1-skew-ps = <0>;
+			txd2-skew-ps = <0>;
+			txd3-skew-ps = <0>;
+		};
+	};
 };
 
 &hdmi {
-- 
2.17.1

