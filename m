Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6281A434A2A
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhJTLi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:38:57 -0400
Received: from mail-eopbgr130045.outbound.protection.outlook.com ([40.107.13.45]:17770
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230168AbhJTLiz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:38:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IXWwhyCzDw53wF+a8BRNpexpOInQipUa1fuUJlWxUGwLZ+fBi98sb+RU1QGAoDrDRyiay38nbLfMMZx6CtF/rOoOEe3ryJiIwPFyFID8GiuucoP3rJ/5Czg0J/lc25Qlqm89tI4QW/TwctqR4vw2KDZDdWfPEZLMEaEujxmtltIveID0w6De41CimAh+u4m0+wB9SVXaNfoohHKfL3u5Y8Xlykbww2uog3V/XrCM0TH/3Cjod8/mSEPo7gGEWhPxJnLgthB3qWhGQcDDM6yJltRMAuISkBKbr4omAqfA0xZLJgs5ib60wS8pUPk+NJit/igoz7PG+uzjMxEGPwN3fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A8Vd/jBOFsd86DVejRlEa87vQLB3umTV1r/F9VTTiG4=;
 b=M/Z0eMauVQek+XiLkzleQ8B7AJH0206iful8+jzrkRiABNOPbjYaCiEYMk2sH/jxss1hABK7vS4t3sjDWmJUKCEco93YVkjD865sZT6w8sP1EagLq9wJfl6mmsNvm2KAZVkH+9oH+OoEhrKDGEEwx+4W3IQjYFpaCtLOewVexsQAwbz9ltPUUIBCJXtIAFcsA9WjLzjCRbJ7wl5oaCvt1V5vxS3GoQowVxMYIahIq3EUlsDIQYsSTTjbrUe81wYiESuLLscPnVtI2PXE00FS1I3/Tp/SPOlIkZliayXBtvhnejSeb9rc+ceRttkoBqwJCTN5VcWlz5eEH0S7Jt2miw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8Vd/jBOFsd86DVejRlEa87vQLB3umTV1r/F9VTTiG4=;
 b=XZMdjkeDerXRxrzMde4cMWhgjUFVNqHbUxhDjlsI8OLo9Fe3LkisRh9eud1jgiuKonXv10tZcdafYKLDZFZ1gw7YaxaDUZ03Md4SLVeBOodbg9dE9CD1x7Ht9qTRXkYAXZ6OnOyFbOwJaZlw0CBU7z++ZxDRcUidp4TmvWweDAE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4685.eurprd04.prod.outlook.com (2603:10a6:803:70::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 11:36:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 11:36:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH devicetree 3/3] arm64: dts: lx2160abluebox3: update RGMII delays for sja1105 switch
Date:   Wed, 20 Oct 2021 14:36:13 +0300
Message-Id: <20211020113613.815210-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020113613.815210-1-vladimir.oltean@nxp.com>
References: <20211020113613.815210-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0036.eurprd03.prod.outlook.com
 (2603:10a6:208:14::49) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0036.eurprd03.prod.outlook.com (2603:10a6:208:14::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Wed, 20 Oct 2021 11:36:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e382236e-71e1-44cc-5a23-08d993bdde9d
X-MS-TrafficTypeDiagnostic: VI1PR04MB4685:
X-Microsoft-Antispam-PRVS: <VI1PR04MB46859DFD13C36E1634B0D311E0BE9@VI1PR04MB4685.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMyvV2aIzXAyAtwgm1a+Lq1wGbIDsx3HDHBBABONnW42PDmLOk1md9bM/QpPYHthk1JU+9ARikDgPocLa7DeMPhqkH1jvKpp5bdnleu5BJi8B+aSdJy2JJcd6lastWCyirj9YhW5TRx1LaHwqw02y5zNWHpVupMFD1jWXoUJgDEr3koZBBsE1nDqCaTS0G2k1N4eC51b9CdRs8wMHvNVvtFr7WO+lt87hmjKpCo2znhq3n4Z/l4TL420k+0z9NZ67C4GZ2D72EtIS99jEAeoHEHoif8cOf8PvrzDkvg0tYS0HOkH36/hKVc1cGHFU7Mm4ni0/bFRmFDMGakKYz1+aOVcPeIvByNG2L3ArRQ4hF/aB47nA6U8KhJhGU21ZV5DaJxxh/BqrO+aFAgBneZ1Ucynwxi16ILPOqqD+KofPtYxTRfYtrPO7DswVaMY1WHPvANxHxwBNrafnF2O/OmnG98ONj72YWNzu6XyYgDU8TjuATprBJG+D9uMzRIv6jpAojgPGWDvU2N90SjafSt2SUcLNhsTpL4OuRbGw7gWS2C1fEnTY5G7SArsGtZx8NmsIckbkBghlg64HKGkwjmXnOZpkhZdL9hBuKJyWP/HzsO9bqBHwwL8+1XjzD345cdP12aZU3JrlWYOPSuC1li/Gzq3oyiZClKIrdvfqFlStusWphiRSgOWrj+42RkEmJL0Y+4JGERTtfEUcp2JxFP6RA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(8676002)(4326008)(6512007)(956004)(66946007)(2906002)(44832011)(186003)(8936002)(2616005)(86362001)(5660300002)(316002)(6506007)(52116002)(508600001)(26005)(38100700002)(38350700002)(6486002)(54906003)(1076003)(6666004)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mYZi5M8sKRvWZrZ57xcKu5sBBqp8cDUtuFnj2UpMtGsQHgoFlSJJdDIgloWp?=
 =?us-ascii?Q?5uNPuSXN2JSDhAUfqxEDSHvMLSPa2xUWjnGtokWvtvFiNLsPEfsCMXxAsR03?=
 =?us-ascii?Q?BLjLzrZPav3uCYEpDPVoCkkKW5X1Y6eR2gezcvZSQ8ab7sG4cRpWAJWcX0hx?=
 =?us-ascii?Q?lIYTOqqnPJbTu8Jyp+LwPq2X+q/n6S4fdA/0IKWZWPvJNUETueb+IgfYDFkp?=
 =?us-ascii?Q?WVSkhqTjm1PZxiR1cwj/PD2RDjj1NMckkboAHHk9fJp2Qz0d7Qyf9BrUGg7w?=
 =?us-ascii?Q?KYgZwwlNf+pOZuthCw+o+7am7oCLwFUvRbXsNsKFlESbG2LCgNmTEdRY11+C?=
 =?us-ascii?Q?KhLcosIeciG8A8r0Kxxva7mWucva/J2Y9wgEh9M4HDKDd7CYpScmopyHrEjQ?=
 =?us-ascii?Q?ncDoYjevijMw6WXnrhovvnjWk2kESjrmculgGCoLSdC3Tk9jCZbbbPLDxq0L?=
 =?us-ascii?Q?F5UJ1TLOxaxnDSYfQQVKt8Otc36UXKZkC58luqeJQoHnOHBWeFK3gY6mgRLC?=
 =?us-ascii?Q?WgDIoymH2Ii29fhDvmjPHvL/O508AmLxkPFarQzBMmrbowpYTyrUpMyye7s0?=
 =?us-ascii?Q?qJFeW9V73Of3pDhSbwtrOJ8VOObWPNQGON/3L4Cs6nS3nxfPU6tVFhBrhWXV?=
 =?us-ascii?Q?AcOqz5Z/VjANc95PPQDigX89eFuRDU0ftGC4isQluyB1xk2l4E8laf9KrrCO?=
 =?us-ascii?Q?c6jnZEnMR6bLxkAxJY+jGgRZ4fTglavkrTDr3RY0YiBwz1RWnN8wFpD9eX5Z?=
 =?us-ascii?Q?fWGuNo70bPQ5S/YmcGMxX0vPznVlYpDBZaryrwI99a1bMbYuvoUvtFuwYu9L?=
 =?us-ascii?Q?EVUye5+T+uuUbxDFlEvVn5wvsmkDlrSNE0JOsW0N/dhitF6bx5RW4n+ryeU9?=
 =?us-ascii?Q?sRE8mn9v1QkwdGz7oqNRxWn4ymVus2aY4QIHDJ2S6G09hF+1QazdIeU48wOP?=
 =?us-ascii?Q?HehSRSHX7CneUg4Xdac9gzmuzBrdULNqELg3FDYOJXz17r143z1BwkXghYIF?=
 =?us-ascii?Q?UR/m1CeLAF1mKdiN/YI16z2wV7A1MoxtBo0GeFSM9ZzcSKmSkHtlEk5KLTG/?=
 =?us-ascii?Q?D0kFHvW32UfXQ/wtlic/iHwZjaMwYDN3ESQ2zwtwkgKrefaGfVUTqFZcckM5?=
 =?us-ascii?Q?8eW4cHEd4Nsq+Qapar0iDbkOn6qPH2i8YyuLnHBW4zshpI9PPz48vTENTcnL?=
 =?us-ascii?Q?RjQJ2nwaKP7lZ+ZKBMg4zlAssvBCDq2gDIctPI55BU/b9yiswtbNagt87ytx?=
 =?us-ascii?Q?ZY8edWsji0GZ2pvMXM15AHL33hmCx8smzFy+yku0yvrh9hHcD7gzrfh9ZU6c?=
 =?us-ascii?Q?uKO6wspIqpp5BeQhWoBlmuvVvT8hPRzowga2BFT8RBFR9ctgB7QOMwp7zZ6Z?=
 =?us-ascii?Q?6ll95znGbCN9O2QJVDrUZa845uJt7LifNEpYQfz4EBqWpmGP/q95WPsy30Ys?=
 =?us-ascii?Q?ZxE/Mu1n7U5UzDVFRvsIpjiyNMBOkhL2EczC+BUx0ho7CSeGtpQj3DobmnQN?=
 =?us-ascii?Q?TTpbqkbOqOe7ZZRhlAb+P5GstjKZXooLNxcb9BLGuE0IBOAVF9Ut/qhAK9lj?=
 =?us-ascii?Q?P6XExD7Yoa6HJoMCMG/T4r7k0zSTO69WNIGThTskP40mgwEI3X1YhP0u7col?=
 =?us-ascii?Q?KDguZ73pxCQSfqqsV9I2FSo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e382236e-71e1-44cc-5a23-08d993bdde9d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 11:36:34.4680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lboe29NJp4OucI2ko/fCJh90ior1TTGJuFqPVLNS861349wJ7uRyZO3r0cL2haZn2dgrURaet7GkYyWqhZ8ZMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4685
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the new behavior, the sja1105 driver expects there to be explicit
RGMII delays present on the fixed-link ports, otherwise it will complain
that it falls back to legacy behavior, which is to apply RGMII delays
incorrectly derived from the phy-mode string.

In this case, the legacy behavior of the driver is to apply both RX and
TX delays. To preserve that, add explicit 2 nanosecond delays, which are
identical with what the driver used to add (a 90 degree phase shift).
The delays from the phy-mode are ignored by new kernels (it's still
RGMII as long as it's "rgmii*" something), and the explicit
{rx,tx}-internal-delay-ps properties are ignored by old kernels, so the
change works both ways.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
index b21be03da0af..042c486bdda2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-bluebox3.dts
@@ -386,6 +386,8 @@ port@2 {
 				reg = <2>;
 				ethernet = <&dpmac17>;
 				phy-mode = "rgmii-id";
+				rx-internal-delay-ps = <2000>;
+				tx-internal-delay-ps = <2000>;
 
 				fixed-link {
 					speed = <1000>;
@@ -529,6 +531,8 @@ port@2 {
 				reg = <2>;
 				ethernet = <&dpmac18>;
 				phy-mode = "rgmii-id";
+				rx-internal-delay-ps = <2000>;
+				tx-internal-delay-ps = <2000>;
 
 				fixed-link {
 					speed = <1000>;
-- 
2.25.1

