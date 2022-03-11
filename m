Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7729E4D6AB3
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiCKWsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiCKWsW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:48:22 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2085.outbound.protection.outlook.com [40.107.20.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C2E281E19;
        Fri, 11 Mar 2022 14:23:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VEVbLh/mEXG1fDbWdJMN8g0Rq3VFqvXGFYRZZ0oOIAV5LHulurPoxV2mZ3kKdY6Foqr3A7BPGaw76Vu3Gz8kIfOpJGu831lJ1iPakg58DgfdJ3Ukj+Igpz3tScIFBubS3JZjzafqpehL8BhQSes0psuXcy3RDRT3L4VXXFklnvytKJr4DAnWbpwhJwh/jDvP5PSrApsltZoRMA5bGB6OlnvL+yuRjvDtgs/MYcya96qhLOBrSXVclbYUoSOVAUdCh3+oKiJCNGkhDUVHOJ7bGjch9OkJLBUDQO/e4HJhk8O6PO9TqvZ5Chm7xFVKMlDTDWYN7hPn06oofJq5eezk2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AcNc2SO9xRUU7VlVpmBa+ApToBqgbbOMxmjlP29mpSw=;
 b=jlL8hCvly3cclWCtpCjq2yY1VZmPwl7wuBRre6O+cGmbJS6klo3NMvBkNi7n9jr9j/5lZzJ2fw372fiN1Uf0FZj1hJf4eU97lne6tM+yDV2gaLyq8xN4a5qlTCYf63rhRkbRyOGtGDUKcvdp0IWSy11eQGunSJa5U4jdKIsyFUfTN6Wl6WK9LMlUtYtXG3gmnvJmw0loLs2QUBOOcCHkN4d9+MU5APBk9UC56PEVIAuRfduaOE7gOnwhFEnS1UAZWUGZ1OmKEF45qMux0ptWUhFgP3VidGzPKVlyBKE6D5hjjZimlONDMbs+Q3z6DZQKhWEOZLU2//g3kQc/rUHy2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AcNc2SO9xRUU7VlVpmBa+ApToBqgbbOMxmjlP29mpSw=;
 b=hcqO6cwYCs2PmSU2dCc6Z4vIk5YWPeKrmPe6sELRpkpC2bR6Xa9At2dUw/2Is1YU93/t0NDD/lk1NH81QwNSefr7rqGMnuPbOUyO+0yIB6AnVcnXVqWptSQi4myLIANQ/1M+u0hhH5kaF5lDWtMfYJRU+V8GhfHHKRfDN1P6xck=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by DB7PR04MB4713.eurprd04.prod.outlook.com (2603:10a6:10:17::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.17; Fri, 11 Mar
 2022 21:23:38 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%8]) with mapi id 15.20.5061.025; Fri, 11 Mar 2022
 21:23:38 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v5 8/8] arch: arm64: dts: lx2160a: describe the SerDes block #1
Date:   Fri, 11 Mar 2022 23:22:28 +0200
Message-Id: <20220311212228.3918494-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
References: <20220311212228.3918494-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P194CA0057.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::34) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38836161-2786-4b13-8c27-08da03a568a3
X-MS-TrafficTypeDiagnostic: DB7PR04MB4713:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB47137A5A6B0F425DAE6A3E4EE00C9@DB7PR04MB4713.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qoCLbi6zOnJYwldnxt5r9V0i0Fm1TEuTkKHcnq1mGh2x8cQh/E0pwbCR/UQfvJFuVVhF5zUDWZaCrg2ReYw9KKnWIuear7twy1Ui4SjONCY2Ij7weBvMiMjPlw/rNcd4ACUKZrmdyL7Ji3HQM7gxURMh65bnvrilJoX7AlTCTgVsp9Gwg1ZNETG23nflk/sNUlCk2/hrHRrz4qOjhqoCBghgb/cFE/iZBbc/GgIaHfKTZR1EFhrPTprs+UeopLzaghoGt3SenND0+o9UFSJIe7nLgyBH5xX6qcEm5b8KlwheVfmBLRgmfUa6K4b7wPGkSuaHGjpZ2a2wUybkznIjs4S/IYmvBWyQ8d1DcysO8WPfmmlfp5V0I8YsiuP1aRLPidy0WKuOjXaqn9VHJyEYynInSwqmGr1tTnu1zH+HjJWtwtQwkgIsy4zSd1jWN2BkKSi4sZJ7VWWkeELGl8h0sDdQCqyzYXFNVjBhcYYbcZxiEXvWolAKvvd6FAwK0cFRKC7B1Wd3L/ZM7ui3O5JaUPvS8Mo8Uyx4b3AiIn6Q1lNqdgX5+rtiKqrVbXUE5rUCCcuLJDU9lZrpRiyrPSTtwaPM53nj6nDSrCAP9pJmm7CDO3T3wx0xyAssAHqmlN5tIbDiC+8Gq8Y6J530oWjg9vgPKR7UfNnuKm7jvo7evUU8hHc40DDA0P8F8WMgjNi6LcbyNhjS0Xa+mHf3KNHDiti8vsuvrnbV1vMT79ioBsI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(8936002)(7416002)(38350700002)(44832011)(8676002)(6666004)(66556008)(38100700002)(5660300002)(4326008)(66946007)(36756003)(6512007)(6506007)(52116002)(186003)(2906002)(2616005)(26005)(6486002)(86362001)(498600001)(83380400001)(1076003)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TS9C3sbkW5sfoVTV0M7tzjwSfZSbU0DAjcRJx4MoNNcF9bQHkVZ3GE8Qxvfa?=
 =?us-ascii?Q?egQi+3y6q1qrt0bU3LkiGBl/mIdwv+IRlo4LrZaCJH0GxhKHuUIw3oKLeH7y?=
 =?us-ascii?Q?vySNC2cXT0XdtecdFQLhN/n71j/xtajF2/uC3ebA4IlNlbDfFcoE9XVDmOPd?=
 =?us-ascii?Q?pCyXS5ohdAdvGMrs0yHwV2kNpEmmCSeq2+GUgwfWnyy/HqlDu/VWzCmnihmH?=
 =?us-ascii?Q?y3AanLtRCQiA3QbKURzQ7LznZAN/bfdBnVcT+RiiEIQUG2LR+SlzxsTG3ntb?=
 =?us-ascii?Q?EoZH5gqeagr/c44RCJkzDUyNkbpJxvDGsj0DAQ/HT0H0AOY7WR6lU5CilnUM?=
 =?us-ascii?Q?LcX2BgN3HfJn463G7yCu37PEOGpZfxzG7fbbTqaareQmaLOQL6jgFQe0sET/?=
 =?us-ascii?Q?v8V2YRiACE0Y08ICvKAA796w+8RnaV3+5nzHVwoqC1VKMbJT5DPelq1JOTKS?=
 =?us-ascii?Q?wHBkIAx8O9Rp0E1GN9k9Jj/jro87iguH+2UErVXtB/i5+46Q+/bAkmPTsdXX?=
 =?us-ascii?Q?tbHNUFUrBSITA6W3ns/aZx45YvV44XxrN+njZl1xc+V05F8PAcDvEd4Vsqv3?=
 =?us-ascii?Q?Ypc8b2K6bkeG1sd0qLfi+kFHEcBhC18TagK1gGcRtMFLiWALd7Y7yN2VDuiL?=
 =?us-ascii?Q?IYCWOUpI68WQGfT4wsZEl8Nl8ofvUjHF/RRi7enM3itOifE6UfoA6MmbGS4z?=
 =?us-ascii?Q?0qS8Wh49dmXYIcdyLjn6TLn/n24Y8UaQ+QI6D3Cgu3fNg0VOhMgNuBcZJDdr?=
 =?us-ascii?Q?tczwylkygJzq2QihtGUDYvz1OIRBZEQjY1FBOSvzMPvIgZnTYRkRQLnkgzOr?=
 =?us-ascii?Q?2YvkDzLhqYsqa968nAVKTaM2sKTe4btur45Ukcv2muhL8I2brhXGvk4B9Sjh?=
 =?us-ascii?Q?t3yCKW0WtfbWYguwP5AdSw7r6A3mM0Tx69TwCqUWR21ogFJEP/0WO+lZR6Py?=
 =?us-ascii?Q?Oa3x3mDZerVrazF7HFqUEBWkq7qg95wHSkEvyo2+zf+YFUbNKnW6HvS2qsoJ?=
 =?us-ascii?Q?4+CcUhehkjKEDnq8SUdIz574E5Muf2EDjLj/j6vI0O1TXWvqRcte8K2yGTXS?=
 =?us-ascii?Q?9yEOb2geZOluNOo0KVVIZgKPwtNJIp9xC2fXczIgO8xz2wz7PkWkhuKZhlOv?=
 =?us-ascii?Q?mOqfEPTjOYpis2tvdM2awDOhXofufE7vdsDorI1WBvBon5D6yJNcr8Stk81k?=
 =?us-ascii?Q?ROflEAy/y9u7xD0zAtV1Nb2jt+vrw3T6vT8L+OzJpWAtRH+NEORetyJdXw8+?=
 =?us-ascii?Q?XnyqdXnnn+C/fCaVMDWrLLiUg8d7gYHfLeWSrzTsWCkKtLvrxwysNjUMQypZ?=
 =?us-ascii?Q?Ydjsa4WXTO4pZNNyIxEGql4RkAp/Yy5mtUatlpXscdQDhmCxtoiF5QwbRI2+?=
 =?us-ascii?Q?YC9Nz9LCpz1UWgLTiAyC/WLro2ki7Ogc8n/qtBb3B7VgzfIyIwKjDV5nUYM0?=
 =?us-ascii?Q?KLFjHVHlCTiGQbPYKjWzM04bXmkubXfVFTxT1BaNO0xvLvGQlC8H3v8ivmRf?=
 =?us-ascii?Q?z5KirxeACDisv2YfGO5SEEI/RouHMGCGFSe9g0LBOC1P01FkcwVKi/iM7J00?=
 =?us-ascii?Q?bIitqI0CEwzoE2nzcs3kgrsvkBYhK+yBXk9CXqXvH8Shmi5fG9Q2NmvyVjoj?=
 =?us-ascii?Q?yf8g6jQ+W1J2ms7tCxYS08I=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38836161-2786-4b13-8c27-08da03a568a3
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 21:23:38.8257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcTsnTwMdkmCqWvVcHm1s+8eD1u2XHBfYeiMDhRTk6EtCR7mYIuP1zSILeYw8OSopbM8MVJRJpbTwUTq7OR4Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4713
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the SerDes block #1 using the generic phys infrastructure. This
way, the ethernet nodes can each reference their serdes lanes
individually using the 'phys' dts property.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- none
Changes in v4:
	- 8/8: remove the DT nodes for each lane and the lane id in the
	  phys phandle
Changes in v5:
	- none

 arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi | 4 ++++
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi              | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
index 17f8e733972a..41702e7386e3 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -63,21 +63,25 @@ sfp3: sfp-3 {
 &dpmac7 {
 	sfp = <&sfp0>;
 	managed = "in-band-status";
+	phys = <&serdes_1 3>;
 };
 
 &dpmac8 {
 	sfp = <&sfp1>;
 	managed = "in-band-status";
+	phys = <&serdes_1 2>;
 };
 
 &dpmac9 {
 	sfp = <&sfp2>;
 	managed = "in-band-status";
+	phys = <&serdes_1 1>;
 };
 
 &dpmac10 {
 	sfp = <&sfp3>;
 	managed = "in-band-status";
+	phys = <&serdes_1 0>;
 };
 
 &emdio2 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 7032505f5ef3..92a881302708 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -612,6 +612,12 @@ soc {
 		ranges;
 		dma-ranges = <0x0 0x0 0x0 0x0 0x10000 0x00000000>;
 
+		serdes_1: phy@1ea0000 {
+			compatible = "fsl,lynx-28g";
+			reg = <0x0 0x1ea0000 0x0 0x1e30>;
+			#phy-cells = <1>;
+		};
+
 		crypto: crypto@8000000 {
 			compatible = "fsl,sec-v5.0", "fsl,sec-v4.0";
 			fsl,sec-era = <10>;
-- 
2.33.1

