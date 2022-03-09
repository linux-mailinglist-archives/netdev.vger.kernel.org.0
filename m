Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 828AC4D3116
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 15:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiCIOjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 09:39:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233589AbiCIOja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 09:39:30 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130073.outbound.protection.outlook.com [40.107.13.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40262125503;
        Wed,  9 Mar 2022 06:38:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BVBmGFrY9Iv0JH8VQtrEU4Bgs3fRH0Mza1auqwz6aM7IN+n5PAoEjyoZLzNohTv6zSrdDMJhglC6clgy98KZg9uUo/ZJIw20ZsP3LzE42+ccEoZqQk1CI/uke2Dqg17D1JH9QB+S+u2VQbzxtB9IHp07vmW62LTkAY7oa13raeYrVcotrrounYkYIqKcphujpwgHblf9sLOGUO3ldYMnJvYDrPYTQm+TH//SruXvL0AwD5kb17kHfguxkfuzCAkM6EqDxNO4oGSqUneXC1lY89W3FrvFG5zaXjo51QGlO25MuEnTrBMYqStUtvbFEqbPRHaPlal9BzQW9PnD7MkzEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KDJuJOQYZuQiqqYX7wmpg2yiv9R5YEZtpkfB1ZsDr5c=;
 b=QTA3yl/1a+gOOqNrzRjM26mTxAESMMnUf3BDly4Haw/5jxs50QTv2XXICfTaL2b/WY1jJtsIMUXmyt9ZTqDkBKEYnjPVQNcJXwa3Gr6KzSKnhcZdVj/QbiSCbntJ4k7ExkwS+0I6L56wpfpoIic6IG8X13/JIg0Tgbddi1a++OnrJAQrO6wppqeffPvmWIXud0tPm7XjAqT5j5FxnDg7wax/UQKnkfiofqQoJFFHEncdKDaRaqcqMoVWM9wP2uBhmWqHjJhno+nNmB9bYwLBwgjRWLdHijvJHtbIwY7ITQ4beJ4ltNN0bqLpYY0GohDV9Fe862ZGTWlzEOr7tLG/qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KDJuJOQYZuQiqqYX7wmpg2yiv9R5YEZtpkfB1ZsDr5c=;
 b=UgsKhRcPlXUu8T43d6bht9mIwtt/ZqNfdp/ZIpmhITRvXhJwxYUOljusVn0zREvxWfHBKgzDrIPgpGcX+nKUlujr/+1v0vfIZfAZEMZ8HJt6gxTrB31Iw7PV+DlzzYLCSp28JXmUGbnUXBmkS2ITXwpunosZgLpjgAs/14ye2Do=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by VI1PR04MB6223.eurprd04.prod.outlook.com (2603:10a6:803:fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Wed, 9 Mar
 2022 14:38:25 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 14:38:25 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 8/8] arch: arm64: dts: lx2160a: describe the SerDes block #1
Date:   Wed,  9 Mar 2022 16:37:51 +0200
Message-Id: <20220309143751.3362678-9-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
References: <20220309143751.3362678-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0187.eurprd02.prod.outlook.com
 (2603:10a6:20b:28e::24) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 93f1b9cd-a9bd-449c-d75f-08da01da77a5
X-MS-TrafficTypeDiagnostic: VI1PR04MB6223:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB622328505FDBC875A15BA879E00A9@VI1PR04MB6223.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7PrxvXwtLYMFrlXvx4rbSZ+NGTbBTUQ9lwherUtTLcSmqPn9UxuEwsmbZyXcJxYEtvQBFKJnoviS/yhhL51zgTr3VR6L13Ol7LYdmn5HSqrUmYdRuWfHcZMa48AxsDxCfFC63RpWZYKSHj3EPe59coIHglwjWzUgInjWv/lnNo4LeULMIuNtwHbucCqKdbowZlUY7+7T7QvkTwvoOnCs/gbNi+4M26wMeeiZVXMtkYt1x2aFGmaKxp6RukwE7TOTQM7OemfXfo3y18DGBec7NM5yAJgoFauLmCSReAN/m0W+fFgP03S974B2Hrr+tRkONyMgcosRSw2XUtC6kLUxlbHpx8jKEfx84rfsbB9GPZuulpMA4kBy7gTW+BSFESSJs95oR5PCkBadWF6ya799lR9RdYozYDRslv7ACYNQp3upE7zHW07Md92igpU0E4hMYILkrOKdVwiyMpk09OE6oAPy5fb+tPwGF03MaSd0khXtaSaCd5xBMPyH+2CLI57f/G5EytSIVCJ+LOycbxrv/VotXnRdj/ik6XLcM5j0FFB2iKazTfDdD5dcyp26MyYGy8CIN/kSzRhu+9OB2sgm6DMUl4CD7n6qBygtvC4glEibI3vkfmhOR6KEJZ6b6S4rnaQf/t38XknAfD3Py9UKgSEuqtdVrbLhhS6kFKxZ0QQ/cFAUVxRAZ8KWN8vPOKUSRbF0r9B4mfXW5zSLuwD4D2UPU4sAQIL6qwPMv7krOCQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(6512007)(86362001)(44832011)(52116002)(36756003)(66476007)(66556008)(8936002)(66946007)(8676002)(26005)(5660300002)(498600001)(2906002)(4326008)(6666004)(83380400001)(38350700002)(38100700002)(6486002)(2616005)(1076003)(186003)(17413003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PSPzYMf1qPT0wzo29nb1EC62V6eXzRCjtIS9AwrMTtjHjrEuzobVU+5LdJND?=
 =?us-ascii?Q?l3JsqtjZ098zDH8aCajZvxttn9fOz4NL2mEr88cqghehi3/+Ll9C9qPo8NGq?=
 =?us-ascii?Q?3u9nwIiJa3sbQXutxS1Z2v4sbgkzCpUkhhhY6Et3AsZEd3Trckh+JotMG100?=
 =?us-ascii?Q?4aM03WwuMNme1hqqVjeoiu/0j/B8auN5SMkhKDWdMGNSY66O/I6PM9IZWxUh?=
 =?us-ascii?Q?L0+vmQOuXTip7RsxI3BtZSbuLMZwc4CQgMnqTMEoO6lUe3P/m7OYmzrb+bJL?=
 =?us-ascii?Q?w2njHwAJTcjWVPd8N6ctp51QVUJ0aMkFuC8YsNEm1QSv8Dzp3NSROhHIUDBu?=
 =?us-ascii?Q?YTX5G3/dQfR4mtl0kkbjXZIKfxSh6whfpR8gIfYbBELAxbc1krXLO0m3zYnl?=
 =?us-ascii?Q?81iHqtEZAG0BhJmdXZsf+Ncv+/u4PUVvGrZEtwN3Kfnof8q/LJID5PhWIYPq?=
 =?us-ascii?Q?aTAmjOzQLMGdDW9UW6RwUnLGqLfZxOECz+V4Zy3iHr2FTlThj7SAQZWFjL6+?=
 =?us-ascii?Q?jEoyH2vWH34Ffs0l3wuRUB8YeubuRv5QqUIF4OA70v6NBH0Ln82NmALQMhb7?=
 =?us-ascii?Q?q9pJIHcYy7Ql4EctADLne4k/hp4s37r4KAPpboGGrPXYiuJBz9069WvXzBU4?=
 =?us-ascii?Q?eHNixYc3GYLbFgWO5tAsut/sXeF+APTeYrBkMrB7XuZGJgEh4EdQrklwdzv4?=
 =?us-ascii?Q?21LYXxpdwkJDq03J8PvvNXqNS3MLp7jKED25t762tXLhNv87a3XejEZHBVHd?=
 =?us-ascii?Q?CIj9GE3WOHNGdAYLN+nvsyS6Z3JJRypOaxlIxodye/CsHfYkUCtJur0GLY0s?=
 =?us-ascii?Q?20f38pG8LndTW2Dbsok5jHSfZwE7Ki6Asf2+uFerhxyRNJtwpN6+Gx7aey6G?=
 =?us-ascii?Q?B11KPG4+ApYhq2i4TXGNN992rqAosEAo0F3+XADhKy1dtmzKfoeNaBuPlnDU?=
 =?us-ascii?Q?dyKBAAGRVNgEx4PSfmR+w0FZHhxlKNZ+JCZJlbx85q0Vv3gmcX4Beyw4Apc/?=
 =?us-ascii?Q?wYGiuaexoOGOVhcmgO46qkyPDtnrkSYSsWKeEJB4IrZh+blWkZML14DZvaci?=
 =?us-ascii?Q?yyN0MOrvUf51Cuv0lr9HqyXbtTVxmaoz7N3hyHjZGoEt/f9NIPBO/fbcFxBK?=
 =?us-ascii?Q?MConK1sNuMjNC8F9+poNrG/RECkvIsnan1YTlwoDR6CMhVK9nYMmFloLQjrC?=
 =?us-ascii?Q?4kqvF9iJaexyrHxyRGy5RIrt1i0aFZFWtX3aWl2a/lARO8ojgyXI4mW8Q9A0?=
 =?us-ascii?Q?5Bb+/uy3JJmYKtL8Nw61IcSpP4Hbxof276y2pCyQhEN8f/qyWSKFa+6QxGc4?=
 =?us-ascii?Q?hDG2mWm8Bk/ybl1sstpxOxENAi8ILq9T78MCmpskz2qaaMU0D/wKMcwJgWxG?=
 =?us-ascii?Q?+WwTRd7tf1KEbGt9l1jr9SfIeiyeGQ98/RP9rAIXhd6Utp69UefzHpu8VpJB?=
 =?us-ascii?Q?3ty4Tebrc+pkTZsiOh2u3tPArH6atZsGFvbmjguPUYMNFC+k/1LgHj+dmjpJ?=
 =?us-ascii?Q?AVDub49D3JJmWULhKQVm9qen4a38V0Xo6WLoJaDOe0t87hKYZh7jMXfTDSTE?=
 =?us-ascii?Q?zGgfjRCRJ+10aKySKMt5xrYJjq9czLnUIsAAA/9aD+rzC52aIN1ThRzkLJDE?=
 =?us-ascii?Q?Iyigul4OnSpTewcbpqVGX4A=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f1b9cd-a9bd-449c-d75f-08da01da77a5
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 14:38:24.9139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0NmQnAo02NdaFz/eAY/6ZixXDieuVgbnIFa2Yd0I6wzo+bvM6x2+wuk1lrImrB6AIFGi7MpaHFA2MtODaRu/wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6223
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
 .../freescale/fsl-lx2160a-clearfog-itx.dtsi   |  4 ++
 .../arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 41 +++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
index 17f8e733972a..14a6334adff2 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a-clearfog-itx.dtsi
@@ -63,21 +63,25 @@ sfp3: sfp-3 {
 &dpmac7 {
 	sfp = <&sfp0>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_d>;
 };
 
 &dpmac8 {
 	sfp = <&sfp1>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_c>;
 };
 
 &dpmac9 {
 	sfp = <&sfp2>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_b>;
 };
 
 &dpmac10 {
 	sfp = <&sfp3>;
 	managed = "in-band-status";
+	phys = <&serdes1_lane_a>;
 };
 
 &emdio2 {
diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 7032505f5ef3..04f29c086512 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -612,6 +612,47 @@ soc {
 		ranges;
 		dma-ranges = <0x0 0x0 0x0 0x0 0x10000 0x00000000>;
 
+		serdes_1: serdes_phy@1ea0000 {
+			compatible = "fsl,lynx-28g";
+			reg = <0x00 0x1ea0000 0x0 0x1e30>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+			#phy-cells = <1>;
+
+			serdes1_lane_a: phy@0 {
+				reg = <0>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_b: phy@1 {
+				reg = <1>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_c: phy@2 {
+				reg = <2>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_d: phy@3 {
+				reg = <3>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_e: phy@4 {
+				reg = <4>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_f: phy@5 {
+				reg = <5>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_g: phy@6 {
+				reg = <6>;
+				#phy-cells = <0>;
+			};
+			serdes1_lane_h: phy@7 {
+				reg = <7>;
+				#phy-cells = <0>;
+			};
+		};
+
 		crypto: crypto@8000000 {
 			compatible = "fsl,sec-v5.0", "fsl,sec-v4.0";
 			fsl,sec-era = <10>;
-- 
2.33.1

