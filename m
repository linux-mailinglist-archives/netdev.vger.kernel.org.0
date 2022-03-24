Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47A224E5D9F
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 04:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347993AbiCXDls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 23:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344213AbiCXDlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 23:41:47 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70080.outbound.protection.outlook.com [40.107.7.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B984B95A07;
        Wed, 23 Mar 2022 20:40:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bImFBWiKY3muOG8KM2/e6PXHQ8+KqbTEuGxaPLhVJ5/XoKnqkgdAqvdGVvEnULhehzC4BWaXPNdsES6ECtjUnHaRMX2cp1JeGClHXwkza+YEFI1bKBi72naRLMMjsAINAE6xVnhydWhVIYE5JU6gxiPfk9Ca45LW0iTQgK5tF4EIXOVgQzNfye+9Im6N1+7urAuZsr2u2wyFAjIISZp8f0Lc8+4eoUXARX9+4Ta/RFscwin456/I0aPNIh/b+VEzRZoX+QmBaHUmNu58J1l0omLoqznuF7XDXUznOlD1nLHP9qP3Yk0pUn5gL4DTwTRPU5U+qw4I9/sXNUbghr7PdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y25jljgF+eFRyrDVj+0N9Qg4w/5oJpinBWz0UowCUVM=;
 b=K1Rb0KJ8mZO/cHIXrFm69m5MSFSVCxe9QRX6ibxZyAxZ/YMzQAYzidrQiCn21zFs6ruGRIxTDnqbARI+/WurLScwHxqxs0Bpo12gMOEfNgzRZN+5GhhCePP4jdOPlmUajgLU5hxmkJzRDig1XyZHq2QRRHhY3bBo9Uy/1wzPC05KCU//sMdzUKuqMjeM6js3YFqPRhVDNuZM0aFZwYjw3EFMuyvvM0imvM1LItdiGy+UU/lJalgWF942x+m1S9xHrQMN0dfeMC0cozx/yrvTKGfrhZc0qsc/z33SeNTbOwW0gm1McXTVTYcix5mDH5I+6MZNFsxjJzmgSJ4ssc7uzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y25jljgF+eFRyrDVj+0N9Qg4w/5oJpinBWz0UowCUVM=;
 b=HqIiwFJitg0FyJ1vRRnrEIGrppwQb9MlhxmRIKSkNlPTSfXYmNpkOuChDaKPeS684knuClAuAuleqOT6sZVH74wJNccnOI9mwnnrYnaHm3ao6JHKIoWTrhlztr+FaF450lJb0S5YhLxh6kDCOCtixBIpKeQ+WU9fdfd8sUdQs40=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com (2603:10a6:10:358::11)
 by DBAPR04MB7223.eurprd04.prod.outlook.com (2603:10a6:10:1a4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Thu, 24 Mar
 2022 03:40:12 +0000
Received: from DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff]) by DU0PR04MB9417.eurprd04.prod.outlook.com
 ([fe80::1d8b:d8d8:ca2b:efff%3]) with mapi id 15.20.5102.018; Thu, 24 Mar 2022
 03:40:12 +0000
From:   "Peng Fan (OSS)" <peng.fan@oss.nxp.com>
To:     ulf.hansson@linaro.org, robh+dt@kernel.org, krzk+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, qiangqing.zhang@nxp.com
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: [PATCH 0/4] dt-bindings: imx: add nvmem property
Date:   Thu, 24 Mar 2022 12:20:20 +0800
Message-Id: <20220324042024.26813-1-peng.fan@oss.nxp.com>
X-Mailer: git-send-email 2.35.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0172.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::28) To DU0PR04MB9417.eurprd04.prod.outlook.com
 (2603:10a6:10:358::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f13699b-0f84-4915-577b-08da0d480026
X-MS-TrafficTypeDiagnostic: DBAPR04MB7223:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7223B7B20679EAAB309A2DB8C9199@DBAPR04MB7223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WG7WfdxcE/IqwGZjn6JpkDx1Ck35bhUT089jRKyVle+aZDa06PLWNBP8ETGWKNzCL2+6Vu9aiugNqd02pngTlo5XJeybpXzC8A5FTQMygAL3av7fM+f6mRsCC/kuFX5r+K5RZjr/fOryVqS7CXnR93qYYq+czOD/jqS3HDnN4tyIEGvAPTJVdsXKYlxbokKQ860UUavbQLvuERMXDbxUvHGIeFZ9au/3zb0KDjhE93hkNerOPOfLrdCzF/ult9/taGZgslKZnWJhOUsJOCAW35R77xA2SSyd9O9rkioB7IDtoVjXic0jfsEYP71JBFIVach/ziGPKLdz3TOZRqblz4js5iBHfDAljrdhZQ8135kxF5ZHU4coknPYNsvC8N0N8ItgaVP+V6kT5nCTzDqGEsUKkOUJ7bkCEUDNiIrVWDQYpQn/UmU4wIE0te3GGuTMZHp6ShKk+8Mvc/VZIkD9Ks9blQ/vpuLobvEqHZhM2UOkdFrAnK4RKejfn64U9xWsLHAuq1fD2drv3HqqKiRZ9lGI3xbEAF8lUXG4tSsi57i0RlDwp1KBfqLNZ4DPiTtQRZepr6UVnt5FQg9gA+CfW48G1pfTMT/zul54P3ghxg5yFswAmj0uYq3nVYo+sT/LUlh+Sw0lO5m4oiSeiqMrGfbGb59dN7SeQ3UQStf6iPGXZBlu2wTfpcVRSEMNBGL3mk8ZBTUKe3g6ujt0AP3+C5et04knKMN8/Esgltf3bxs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR04MB9417.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(6486002)(1076003)(52116002)(6506007)(6512007)(26005)(2616005)(186003)(316002)(8676002)(4326008)(66946007)(6666004)(66556008)(66476007)(83380400001)(921005)(38350700002)(8936002)(2906002)(7416002)(5660300002)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xUXERlizuBTqJyGjurUVka52Ywqqh5Mueyaq5dh+kcYtdUybqOWvbSzmtaWE?=
 =?us-ascii?Q?43dPcuhmId9NTZBzaeABy6Zcpbr0MVJEDolh6ylVt4GNT8xRtd7CP85fQp2Y?=
 =?us-ascii?Q?mxCVlgi5Wc+xA9FIEff7vfFJ7f/iSPDWrfOkHHUYl1Lq3kYWR6iqUh23LzJQ?=
 =?us-ascii?Q?xZUJ5jwnzjwHPszz2Rz4Y+l08N36VHRNKYWbN17ui0Ncz68sk3eQ74YiqiYr?=
 =?us-ascii?Q?ukPAHzHI3+EGeTqrDQ0k1GDksVHyk0CiXgh4o5EDKv2i6Dio4+8CRy4QqS7t?=
 =?us-ascii?Q?xuqEk0Qu2BQlkM1Q23FWYS4i4KiUB/RdLl5/6b5YGlUVOXfttYNAEBpUFW3b?=
 =?us-ascii?Q?v2dYjyvQECWd+lnTaoTIIWA4K9wdcApmXi9HoJPiypfAxavrZiXr58gD7Cie?=
 =?us-ascii?Q?f1LuUY9eLX/Y435hZwJ3dgdOL/XdCjTOvw9AqkKuX43GE+cNTSDVlt6b0bM0?=
 =?us-ascii?Q?2UxxlgEnRVBM390nUrVwac1++7ofRSSuxvaINllQwNEQUqp/nh2QKqkrlExf?=
 =?us-ascii?Q?UqJyVrUQI0gyvJCaQ6uD3LlVwuadoQX3km4J9cvz2Rk8d5d4hBwFpGMoqkTb?=
 =?us-ascii?Q?LWZ6Qi9k4JAdz81L7Uwwzn5P061L/ZP424SwxXlq+8QGN6Aqz//TYCsPEI8W?=
 =?us-ascii?Q?yB7yYd551hT4JAhO0+wP76gpoWEtCgcKJasOih3GK5WlBPQ1OrGHk9jotzGv?=
 =?us-ascii?Q?K8u5c5cULtmwzf0El06AOLHRNiwWW9Li81lvAdEtn2u48+b4iHybeVW6tjUh?=
 =?us-ascii?Q?4LOW6n9/Lpq4egxChIt3nqBZLGzVufa4vaU7c/PyXhS0JNxGdN9ZBSspBIrB?=
 =?us-ascii?Q?W712FKatAKl5eOLqSqgraS9SN1Yu0EsJxFbPLA2g+SB3emAlxGsXlJP5O1O9?=
 =?us-ascii?Q?xs1iGoTm3dXESUD3AlknhfKine/+n6vNdZUwOy38mH9MM9ARonGSpRsg5rpY?=
 =?us-ascii?Q?kVtPEAmHvb2GcgV7DhoDl58P8MTmfu4jJo9XBXEmZ1yxI8Uk0vcTLrBgWDCM?=
 =?us-ascii?Q?cKsEIwcCxiVl72JloX8n/lEVqev0QdBbSLbHKMSMY7q8ix5fZdNXdQ9cSfcG?=
 =?us-ascii?Q?IFHNWbsW96H2o3C/zprNCD4yLIv/dOomANoxDF7td+5wFsCAdSNiKu7Qu1BK?=
 =?us-ascii?Q?uAuuk9oUkX2rljVYiCTiU5tbrzmPbCbGqvB4YEaqaSPP+bDj9RvDamaOkf0Z?=
 =?us-ascii?Q?0b3ODWes4/x+sYk++twCGv4SsAb5UnFz0BrghnqxrPurayj7/K/nhvmJcNR9?=
 =?us-ascii?Q?qkum9p/XB93PjT5UFiIWbNFddMFgcdt6KJtBhJ2dpJek61XRsXbngJBqn9YZ?=
 =?us-ascii?Q?a4/kvZpounSsO8CHs9pBNqlt3yYDaYOgpZ/X60C61SgbEJTgUeEzcB+G87uX?=
 =?us-ascii?Q?WUxIlvFt/IhzwZ/fNRNrspSnvb2BxsWGVrHY7YsHrIsm4GS/1JahiGbnCiQl?=
 =?us-ascii?Q?+OCXFuOFepz4VIO4lSu+IkP8pMVubIbtwVr74bjPUeJ/h2fwrrvZ9L9kLlFU?=
 =?us-ascii?Q?uhOyntzNvCiPJCzp9gwJukRxk7Uf1pjdCyC9EVtVkX/LiiwECSV2vG0hNvTK?=
 =?us-ascii?Q?xjPwi/4LQRXUyAa/d6Baob5uAHprw5BaiuY2ZR/2przHA3f7sVEqYmTxLpri?=
 =?us-ascii?Q?mD7l/qgkhVSeqOzP2ZbiFelH6MiNflq61p458Knx2pP8WlrQcy2kufqIHQfH?=
 =?us-ascii?Q?EQeUfi/Lk/3EadWzMN75fwZ2fAMWgx+opvPt30yknGG9OvtBCzAqSsjMYkno?=
 =?us-ascii?Q?nMMFQJSVVw=3D=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f13699b-0f84-4915-577b-08da0d480026
X-MS-Exchange-CrossTenant-AuthSource: DU0PR04MB9417.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 03:40:12.0790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LV7N4iIQ38fkDGOyOvVwAUXkgH5T/K6pLYjZkRaacHFxzEKeLrQtDGyA2fyJMPlPwteHBVqLX6KUi1N7m1JhYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7223
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Fan <peng.fan@nxp.com>

To i.MX SoC, there are many variants, such as i.MX8M Plus which
feature 4 A53, GPU, VPU, SDHC, FLEXCAN, FEC, eQOS and etc.
But i.MX8M Plus has many parts, one part may not have FLEXCAN,
the other part may not have eQOS or GPU.
But we use one device tree to support i.MX8MP including its parts,
then we need update device tree to mark the disabled IP status "disabled".

In NXP U-Boot, we hardcoded node path and runtime update device tree
status in U-Boot according to fuse value. But this method is not
scalable and need encoding all the node paths that needs check.

By introducing nvmem property for each node that needs runtime update
status property accoridng fuse value, we could use one Bootloader
code piece to support all i.MX SoCs.

The drawback is we need nvmem property for all the nodes which maybe
fused out.

Rob:
  I only include limited node bindings in this patchset, and not
  include device tree patch. Just wanna to see whether you
  agree this approach. If you agree, I'll later post device tree
  part and other dt-bindings update, such as MU, USB and etc.

  Thanks.

Example as below:

			flexcan1: can@308c0000 {
				....
				nvmem-cells = <&flexcan_disabled>;
				nvmem-cell-names = "disabled";
			};

			flexcan2: can@308d0000 {
				....
				nvmem-cells = <&flexcan_disabled>;
				nvmem-cell-names = "disabled";
			};

			ocotp: efuse@30350000 {
				compatible = "fsl,imx8mp-ocotp", "fsl,imx8mm-ocotp", "syscon";
				reg = <0x30350000 0x10000>;
				clocks = <&clk IMX8MP_CLK_OCOTP_ROOT>;
				/* For nvmem subnodes */
				#address-cells = <1>;
				#size-cells = <1>;

				m7_disabled: m7@10 {
					reg = <0x10 4>;
					bits = <21 1>;
				};

				g1_disabled: g1@10 {
					reg = <0x10 4>;
					bits = <24 1>;
				};

				g2_disabled: g2@10 {
					reg = <0x10 4>;
					bits = <25 1>;
				};

				can_disabled: can@10 {
					reg = <0x10 4>;
					bits = <28 1>;
				};

				canfd_disabled: canfd@10 {
					reg = <0x10 4>;
					bits = <29 1>;
				};

				vc8000e_disabled: vc8000e@10 {
					reg = <0x10 4>;
					bits = <30 1>;
				};

				isp1_disabled: isp1@10 {
					reg = <0x14 4>;
					bits = <0 1>;
				};

				isp2_disabled: isp2@10 {
					reg = <0x14 4>;
					bits = <1 1>;
				};

				dewrap_disabled: dewrap@10 {
					reg = <0x14 4>;
					bits = <2 1>;
				};

				npu_disabled: dewrap@10 {
					reg = <0x14 4>;
					bits = <3 1>;
				};

				dsp_disabled: dewrap@10 {
					reg = <0x14 4>;
					bits = <4 1>;
				};

				asrc_disabled: dewrap@10 {
					reg = <0x14 4>;
					bits = <5 1>;
				};

				gpu2d_disabled: gpu2d@10 {
					reg = <0x14 4>;
					bits = <6 1>;
				};

				gpu3d_disabled: gpu3d@10 {
					reg = <0x14 4>;
					bits = <7 1>;
				};

				usb1_disabled: usb1@10 {
					reg = <0x14 4>;
					bits = <8 1>;
				};

				usb2_disabled: usb2@10 {
					reg = <0x14 4>;
					bits = <9 1>;
				};

				pcie1_disabled: pcie1@10 {
					reg = <0x14 4>;
					bits = <11 1>;
				};

				enet1_disabled: enet1@10 {
					reg = <0x14 4>;
					bits = <13 1>;
				};

				enet2_disabled: enet2@10 {
					reg = <0x14 4>;
					bits = <14 1>;
				};

				csi1_disabled: csi1@10 {
					reg = <0x14 4>;
					bits = <15 1>;
				};

				csi2_disabled: csi1@10 {
					reg = <0x14 4>;
					bits = <16 1>;
				};

				dsi1_disabled: dsi1@10 {
					reg = <0x14 4>;
					bits = <17 1>;
				};

				lvds1_disabled: lvds1@10 {
					reg = <0x14 4>;
					bits = <19 1>;
				};

				lvds2_disabled: lvds1@10 {
					reg = <0x14 4>;
					bits = <19 1>;
				};

				eth_mac1: mac-address@90 {
					reg = <0x90 6>;
				};

				eth_mac2: mac-address@96 {
					reg = <0x96 6>;
				};

			};


Peng Fan (4):
  dt-bindings: can: fsl,flexcan: introduce nvmem property
  dt-bindings: net: fsl,fec: introduce nvmem property
  dt-bindings: mmc: imx-esdhc: introduce nvmem property
  dt-bindings: net: imx-dwmac: introduce nvmem property

 Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml | 9 +++++++++
 .../devicetree/bindings/net/can/fsl,flexcan.yaml         | 9 +++++++++
 Documentation/devicetree/bindings/net/fsl,fec.yaml       | 9 +++++++++
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml | 9 +++++++++
 4 files changed, 36 insertions(+)

-- 
2.35.1

