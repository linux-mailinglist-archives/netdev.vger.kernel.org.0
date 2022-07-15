Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 359705769A2
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbiGOWHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbiGOWGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:06:42 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2079.outbound.protection.outlook.com [40.107.20.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D251B904D1;
        Fri, 15 Jul 2022 15:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euLGPJFhtX7x/Xz1NyFDuD+vaqKpI+x9bIK1DdnTdP63KbnVXqMyWHbqcQwzxEPGEO+0rGmN4dkQIxuBU78gp/ifQe6t2SvX+lz/dKmEC2aWvmtwSS3m9Q/HHj4bRmoUneqwtStEYAe2lxYbCgTY+280Rpw9STOxnyhd6RefHVHMF8d1HpGmWH92bMm5uDCZ/UxelIgbUWPe8gCz5MQ5fS70ZmAdt4rZ0pk+eb1ekOLhfkg5ndOPy2n9LbAL5YRZxFsPZwMTaN4FKrjS4bqO83YMRWTTQ9EjsE84Ddyzj7t5VmwiQBfisMWNT416bXli7iHf6+8/NZWaS5sfo4zckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDBqgQMlNpG+Izo17B4XkBJl6cjZRtIKufy0jFsSqSw=;
 b=GCy39p8epUnH4b9Ax8ESnK0VrIG8i4UhNDzrrd7vjPktJZ5ehMraWDYxBp+OaeG9HA963mC7tOIApcl+9Zj2J8Kwq+oxamzWr/rxuyKi9dcaBYEayKv6MSiXttt2PGeN9gJGlBZroHBPr87PEKwDhS/5/diEFsIx7L7ud43nr3VC9KDTrrqa2sz0rfYWyyBjuQxBmCZmlcNAiAnLWCbnY5PMxH5Y1s+zmF8UEvFfDe6NAy5SWOmAZ7i/aqZl+qA20UkYV4/LiyYDzvc+Vvov5rITcFNSXWY6+8FLS/AQnhBM+Tv09ZXgWJQPPIkB7ZsH8db/hIouDARCDDcpzOhTog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDBqgQMlNpG+Izo17B4XkBJl6cjZRtIKufy0jFsSqSw=;
 b=ye4KAkXzyaavVD9XTvG6BwWdKmeETMDzVTbemwF/RlSfI/nHnq3ylUkYFSJ69Jynvm0nuG5g5N5V4hNTT0lNSeKmY91tRROay2qbCik6fRnXpueq502TFbWk+3GKsRlXdJn8HMLpngw+LkqDouAT8Qo2p1bmxUVT7DQE8OE9dMA5uc8SkQ1xnSGrZKI5OLei1V5J+fyFqBf1F0Ea8mIYoY6mP/WCzoQuxavBCHwrF2xQz7QdiVltZ3jJj3fA/1EHOP21KmLWV4lq/NmpxAxRlczFkJiSydXZt2hMZePNyEWO5NE1Twv1a2qiLEHC01huiSt8fQTwz3sbByKTYz/MqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by HE1PR03MB2857.eurprd03.prod.outlook.com (2603:10a6:7:5f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 22:01:54 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:01:54 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 44/47] arm64: dts: ls1046a: Add serdes bindings
Date:   Fri, 15 Jul 2022 17:59:51 -0400
Message-Id: <20220715215954.1449214-45-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1a80fd86-61d7-4ebd-e632-08da66ada12c
X-MS-TrafficTypeDiagnostic: HE1PR03MB2857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NgMZ1cO8szdcaopUGgrR/M7AjUQORhsmPvidRblEHDS0pu1YP18qH6J9HTKjQE8SgnbCItKOqec4MOAdV/7nkLBnwwx7XQfcFqlB9cfM4tfHwENPY7ESWe3YroTmLsUpyb9CkXgaG+GsgmM6CPqqKUdQMaS00ZltXXc2RKf4EGYl22RVEO9xUNEsDjCw1FD6AoKyM1CKqizYEGSbeBj6hwUm+sFTxNJ9A7c+QkUj4AX/OE5wv5ARbLDGrIGYkPQUq3OsElPZIaEo3smmYONjirC+TjF2LIKZ8UOdffY1vXd2KFJqMAB8rzFNA+dMdrkPjFDHL0H84el8JKmrcaFr1MT7qepqJadw3J6J+JRt3y8TetcvfJhkc3ZryMWuWR3FTney4oqdnD9A/Xu0Wil+TqbbQ+gQ0ZKNQZHhfkTr2PVrvmoFL0/UiqttyAhjx/3Rt5WBIM5HyWEE36g8ASl/glf8a4ajIhe6UHfnDbmcbC7g1AapWMA4JjF3m+xV1+oZrVIchjLjOmJGCgwUuHDvt7fwQ1hElkegMA7sGveNOwoYC9kZmPcX2PtRgnA04kCdEHGwXIYVkNAM4y+NBBOK5X4k/r81nul1K+pXEy7dz6aLSzSYUheWaiDofLb6cWNR6zTQ30O18QB9i5xBxbujEf8LJjjGXIrrOQpePmoPGfuytL5SfXLxVnBKsFOLKX6jUKLiiypsggkBeYkdRL5GB2LBJPmSH3TahHlcf341x2Wrc7PnLnyXM5Jqd6mT4Q0QHTkvDD27X2rcZXrRMyaCvX/aJOKpNwQdPwLdhOPHdgDB7inic9vBEhdIjCAsThuEtwhekjiM9zzjPPWa2bmIvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(39850400004)(396003)(366004)(346002)(136003)(316002)(54906003)(38100700002)(2616005)(186003)(36756003)(2906002)(6506007)(38350700002)(26005)(1076003)(86362001)(110136005)(5660300002)(6666004)(6512007)(66476007)(4326008)(8676002)(7416002)(44832011)(66556008)(52116002)(83380400001)(8936002)(66946007)(478600001)(6486002)(41300700001)(21314003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?AQXlbxxT8lcqsJ0HOUL5sPsOJLLl1wS/ppPEb89e9NWO4oJSsQrJ0YVHszGb?=
 =?us-ascii?Q?vu+V8a+z8c0CWdKplV3/uLW8vPD7iMxfSFIfohBGMwMRsSUgszNRWtcwQP/0?=
 =?us-ascii?Q?ecCfdtZWVy06n8aQqDiI/C+/Gh0RR1wFKR5ManUocuqYbMMETkM0YO+RFuzE?=
 =?us-ascii?Q?so783gcb780mCoRYaCrL3EC+L0YLeXE85/9ps+LcFj0ZA4MNzBuec4PtNH72?=
 =?us-ascii?Q?iTXv1PKWu7f5+ccp3a1/MkBF6y/5jH+WWiqyRdYDGz3+bZpEbq9GoS8eCov4?=
 =?us-ascii?Q?r/lC4Zs6kSlMCdIrWYT/JVLnEIgLHEaegU6gEJhLa6Q+V9Bfrgqsf+jdpm8p?=
 =?us-ascii?Q?XWJF5xR8Mh3EQ/RG3zFvJMF0yys6TsQ1nQoMg1oEsnAXayXL398j5DH3IwZ4?=
 =?us-ascii?Q?KDWQjBmI5HgiNx372QqB8bVFGSQMYSJ8/dixUfQ4M6VnE6yVd6AnTWvxqBHn?=
 =?us-ascii?Q?wc5DZ7v8QUm5WEUoIq0EqmDAi5ZJI09kSwIaqG0xRzcU54ixbcpanN23Q7Wf?=
 =?us-ascii?Q?amF0PUnnyJy6FGvCbYr1i7X8tZpdJbii2DSLKIv7Tlyl+uhNsKk9iVDioCXb?=
 =?us-ascii?Q?YmE4JWt1bxfyifY1aKBnX0mZUbmWD4DPVNDzNa7rweyY9bOPRkJ134U4sCyV?=
 =?us-ascii?Q?4fbzePh+nWEB8eD7h+nTuKXjMeOdFuGPgzOhd7PdeJuSWID824LtMeAtahwp?=
 =?us-ascii?Q?S4lUylJIjC/5Rvvr+UC90Uws6/9rrd9qVYfyu0Pps/TbBdcHjXuUGQ6bsaEg?=
 =?us-ascii?Q?WqtT6+ameigCuhnBaXbP63/78isLjMvLp9E0hngiu2nKCL1XJ3asrokXUGZB?=
 =?us-ascii?Q?LCwdm8Ckr5cM22QcMBXUbCRCkUsBUJK7zdRkSY59Fp64Wjw1v1igfneavU82?=
 =?us-ascii?Q?ID7na2f2+oruD0OwWagxx60qw/Ns+DP0kfyhCKCPhk01hnOZj/HjD25z7dXG?=
 =?us-ascii?Q?4NCNRVorUCP4Lne1dogFYdObQ2WcbHlZ4OAFmGsZ512qwgcOjQ9PoMRvHZK8?=
 =?us-ascii?Q?hf10kKtJUZ/jiJKkDwkYXwVDSlhzKmNyq5G1ol2DvK4T061+q8hqoqP9onlg?=
 =?us-ascii?Q?x6Tde02L9XTIn5VceuDkb0QnxUFsw1wM+0We2W3gztES2zJckaS/GXsO4SMy?=
 =?us-ascii?Q?Qz/Hr71wW3w96ARLHlcWEx88aYVbKhadNTusAAzQtwy5xWjMDm0tXWUtQqaW?=
 =?us-ascii?Q?kGNKoS3nBajmhWyLSN195zbqOOT8OkiREUNyiC+1S5mkdwCHwLS3pwrEQMPE?=
 =?us-ascii?Q?CaHmZ+udFeRgwyso5xlLO216otWW5TBM/kLuRReWhY1w87Y+FNmpxbsq0DxW?=
 =?us-ascii?Q?TgxpQAGOgCoauRwoPTAKLLUDiwT/JkYEvgDiySAVWdmQmerlH9GXnf0zDrWJ?=
 =?us-ascii?Q?ImmT9hOeifanJCTapzkF5wVii+VsrZOWdDQZe3OCyMMdOAUBOTt08QmYgJu7?=
 =?us-ascii?Q?IfJqsaMM1Kucfs5UEciDlZZu+/G+KKiHa/fuI4VgVMH+q+s3Tr/8uvEsWioA?=
 =?us-ascii?Q?Jway7KnHllSZRui4mSsF2+QO3qVzeAJcfnihHesBcmew9LcD1Wl2r5Tqa+Kw?=
 =?us-ascii?Q?aoCBfwaC+tZCtgBXhoLXXO5e21L6ENWNGyFeYiyu3ICs+x4PlVAF4BFPureu?=
 =?us-ascii?Q?fw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a80fd86-61d7-4ebd-e632-08da66ada12c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:01:54.6733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5aTP9iAET8B9ZrjqDfEVTcanUWa5c8neODiTL7aavuxFmdBHfdoU46s0sArlrESX2lG6LaN4WyGasW8qNrfiOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR03MB2857
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds bindings for the SerDes devices. They are disabled by default
to prevent any breakage on existing boards.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- Describe modes in device tree

Changes in v2:
- Use one phy cell for SerDes1, since no lanes can be grouped
- Disable SerDes by default to prevent breaking boards inadvertently.

 .../arm64/boot/dts/freescale/fsl-ls1046a.dtsi | 179 ++++++++++++++++++
 1 file changed, 179 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
index 0085e83adf65..0b3765cad383 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a.dtsi
@@ -413,6 +413,185 @@ bportals: bman-portals@508000000 {
 			ranges = <0x0 0x5 0x08000000 0x8000000>;
 		};
 
+		/*
+		 * XXX: For SerDes1, lane A uses pins SD1_RX3_P/N! That is, the
+		 * lane numbers and pin numbers are _reversed_. In addition,
+		 * the PCCR documentation is _inconsistent_ in its usage of
+		 * these terms!
+		 *
+		 * PCCR "Lane 0" refers to...
+		 * ==== =====================
+		 *    0 Lane A
+		 *    2 Lane A
+		 *    8 Lane A
+		 *    9 Lane A
+		 *    B Lane D!
+		 */
+		serdes1: phy@1ea0000 {
+			#clock-cells = <1>;
+			#phy-cells = <1>;
+			compatible = "fsl,ls1046a-serdes", "fsl,lynx-10g";
+			reg = <0x0 0x1ea0000 0x0 0x2000>;
+			status = "disabled";
+
+			pccr-0 {
+				fsl,pccr = <0x0>;
+
+				/* PCIe.1 x1 */
+				pcie-0 {
+					fsl,index = <0>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <1>;
+					fsl,proto = "pcie";
+				};
+			};
+
+			pccr-8 {
+				fsl,pccr = <0x8>;
+
+				/* SGMII.6 */
+				sgmii-0 {
+					fsl,index = <0>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <0>;
+					fsl,proto = "sgmii";
+				};
+
+				/* SGMII.5 */
+				sgmii-1 {
+					fsl,index = <1>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <1>;
+					fsl,proto = "sgmii25";
+				};
+
+				/* SGMII.10 */
+				sgmii-2 {
+					fsl,index = <2>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <2>;
+					fsl,proto = "sgmii25";
+				};
+
+				/* SGMII.9 */
+				sgmii-3 {
+					fsl,index = <3>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <3>;
+					fsl,proto = "sgmii25";
+				};
+			};
+
+			pccr-9 {
+				fsl,pccr = <0x9>;
+
+				/* QSGMII.6,5,10,1 */
+				qsgmii-1 {
+					fsl,index = <1>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <1>;
+					fsl,proto = "qsgmii";
+				};
+			};
+
+			pccr-b {
+				fsl,pccr = <0xb>;
+
+				/* XFI.10 */
+				xfi-0 {
+					fsl,index = <0>;
+					fsl,cfg = <0x2>;
+					fsl,first-lane = <2>;
+					fsl,proto = "xfi";
+				};
+
+				/* XFI.9 */
+				xfi-1 {
+					fsl,index = <1>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <3>;
+					fsl,proto = "xfi";
+				};
+			};
+		};
+
+		serdes2: phy@1eb0000 {
+			#clock-cells = <1>;
+			#phy-cells = <2>;
+			compatible = "fsl,ls1046a-serdes", "fsl,lynx-10g";
+			reg = <0x0 0x1eb0000 0x0 0x2000>;
+			status = "disabled";
+
+			pccr-0 {
+				fsl,pccr = <0>;
+
+				pcie-0 {
+					fsl,index = <0>;
+					fsl,proto = "pcie";
+
+					/* PCIe.1 x1 */
+					cfg-1 {
+						fsl,cfg = <0x1>;
+						fsl,first-lane = <1>;
+					};
+
+					/* PCIe.1 x4 */
+					cfg-3 {
+						fsl,cfg = <0x3>;
+						fsl,first-lane = <0>;
+						fsl,last-lane = <3>;
+					};
+				};
+
+				pcie-2 {
+					fsl,index = <2>;
+					fsl,proto = "pcie";
+
+					/* PCIe.2 x1 */
+					cfg-1 {
+						fsl,cfg = <0x1>;
+						fsl,first-lane = <2>;
+					};
+
+					/* PCIe.3 x2 */
+					cfg-2 {
+						fsl,cfg = <0x2>;
+						fsl,first-lane = <2>;
+						fsl,last-lane = <3>;
+					};
+
+					/* PCIe.3 x1 */
+					cfg-3 {
+						fsl,cfg = <0x3>;
+						fsl,first-lane = <3>;
+					};
+				};
+			};
+
+			pccr-2 {
+				fsl,pccr = <0x2>;
+
+				sata-0 {
+					fsl,index = <0>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <3>;
+					fsl,proto = "sata";
+				};
+			};
+
+			pccr-8 {
+				fsl,pccr = <0x8>;
+
+				/* SGMII.2 */
+				sgmii-1 {
+					fsl,index = <1>;
+					fsl,cfg = <0x1>;
+					fsl,first-lane = <1>;
+					fsl,proto = "sgmii";
+				};
+			};
+		};
+
 		dcfg: dcfg@1ee0000 {
 			compatible = "fsl,ls1046a-dcfg", "syscon";
 			reg = <0x0 0x1ee0000 0x0 0x1000>;
-- 
2.35.1.1320.gc452695387.dirty

