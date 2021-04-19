Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0128363A8E
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 06:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhDSE3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 00:29:09 -0400
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:34390
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231942AbhDSE3D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 00:29:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BTJIE8SqJwtaoCpf01O7IjUoR+Pmxc/ulMNpW+HkBz4cUubaJu2VCQGdfi0lYzxgb6JvZQIXYuzZ+8k/W5h+Pot07HLjLbmKr0wCFrQSdC3l/67W7jmsQeO7P+tJ+NjATWHsbTvSuxUfrDVycuwuznLJ/3QC/+hW2iTSXhLBsSgTbCvgwLsfVfALwVfaZwzlFosljScRnrN4M1jsHuzwVrezK1UUQ1DVYeiTKbza1+ZL6FDHqzRZ5V73xud+4kZ34eYj40fsxPC4HixM1lFHOvbzpqpBgjdn0bA/RJ8xMmM0xvJkCHnSHw4sv/xlpiiVPfgMrt/ICYgDErkGOFZAAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bb4Vb9T9lwRDMMjfym8FVkfdzjCyJOFIBDrxsipoKg=;
 b=obf1yfXuOtuHMDGqEhATMGrS+KgFfOM3AGWUFxNfMtoIHqLDjk5qbLGtQP91hBtxcAAbjhTYdoyRNKw380HC21SoUJ6PtKl617+WW1Ac9Flvkd1pi9SNplEFSQgDzi4iXMh5stVEC1pJIaGrUcMHrOUmGM1zEieC03T8Jgvipd8lrqzXZ8byOs7MfIHN8fMUau5h5KvDrt3VOCmHadb9YtDqE22AYoGFkNQSZYFE2jaaleXLP5L+ntszxIP+Kq2Q0AbN3jy/Vw30r6aR8KHAC1c7mWTT3TKFdlcPt2zWINFxh3Do95STCElECH3p1GdKZkafAImtUWuK0ukdhf9+yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1bb4Vb9T9lwRDMMjfym8FVkfdzjCyJOFIBDrxsipoKg=;
 b=ICMBNZiP0RPlOxdgGFHGj2dQvhedynpguwpYOU8trqiJnrls9olVXsCvmNy+vwKiLaKtuieXeDyKwBFYMRSx90pof7fVU7Jp3r5iycbZcaxa9aCwUs5RX6FRomAYI1X0rMxeUQtTowEkUhL57l5oBK/C8N7mf3Rpt1FRRNePEN8=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oss.nxp.com;
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com (2603:10a6:20b:b9::10)
 by AM6PR04MB4406.eurprd04.prod.outlook.com (2603:10a6:20b:22::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Mon, 19 Apr
 2021 04:28:28 +0000
Received: from AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18]) by AM6PR04MB6053.eurprd04.prod.outlook.com
 ([fe80::b034:690:56aa:7b18%4]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 04:28:28 +0000
From:   "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
To:     gregkh@linuxfoundation.org, rafael@kernel.org,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net, tony@atomide.com,
        geert+renesas@glider.be, mturquette@baylibre.com, sboyd@kernel.org,
        vkoul@kernel.org, peter.ujfalusi@gmail.com, a.hajda@samsung.com,
        narmstrong@baylibre.com, robert.foss@linaro.org, airlied@linux.ie,
        daniel@ffwll.ch, khilman@baylibre.com, tomba@kernel.org,
        jyri.sarha@iki.fi, joro@8bytes.org, will@kernel.org,
        mchehab@kernel.org, ulf.hansson@linaro.org,
        adrian.hunter@intel.com, kishon@ti.com, kuba@kernel.org,
        linus.walleij@linaro.org, Roy.Pledge@nxp.com, leoyang.li@nxp.com,
        ssantosh@kernel.org, matthias.bgg@gmail.com, edubezval@gmail.com,
        j-keerthy@ti.com, balbi@kernel.org, linux@prisktech.co.nz,
        stern@rowland.harvard.edu, wim@linux-watchdog.org,
        linux@roeck-us.net
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-clk@vger.kernel.org, dmaengine@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-gpio@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-staging@lists.linux.dev,
        linux-mediatek@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org
Subject: [RFC v1 PATCH 2/3] caam: add defer probe when the caam driver cannot identify SoC
Date:   Mon, 19 Apr 2021 12:27:21 +0800
Message-Id: <20210419042722.27554-3-alice.guo@oss.nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210419042722.27554-1-alice.guo@oss.nxp.com>
References: <20210419042722.27554-1-alice.guo@oss.nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: AM0PR02CA0207.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::14) To AM6PR04MB6053.eurprd04.prod.outlook.com
 (2603:10a6:20b:b9::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from nxf55104-OptiPlex-7060.ap.freescale.net (119.31.174.71) by AM0PR02CA0207.eurprd02.prod.outlook.com (2603:10a6:20b:28f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Mon, 19 Apr 2021 04:28:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 724ca91f-ed40-4bee-6ae6-08d902eb943e
X-MS-TrafficTypeDiagnostic: AM6PR04MB4406:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR04MB4406FFE107BA611E7348AD01A3499@AM6PR04MB4406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZjIj9iYfBc8vdFbj9+Zn+7Dp6l2xCkfbOMiOd5JChxZbN/O3F7ZnKCnzttUMiwzMKwyYxOBdFHrgvgD2Xe8F/UHv3AwarhDFhafWYA471feJx7tvgaO44kfkEWvbRW/yCyCyb5xeSn7bXkl+IFGuP2y157VTEwVVYZTxwEOHbkqPN8UmF4CksmKb26NHf0z3YYOPUUNMIlfBTjvwDT7GhPjZ1IKpbxBMjlO4nrMdU9aKKMILpmi8Act8FvvlVXYhzaTCYU38ZuY6LoSTC03UADthBX4R+ODJF/9VeOQTHp40pJOYEwpp2Y9O7WHnVTnmLB91Rzd/hMEUlxjy91z7m6h8kGNxcywl3HQt1LS/1p2QCCNb0b9LNTyvhIXIeMV6eq17BnHOgl2IKuu7Oiv5AxDzovksRwjdvMkfzvewm7J86aB20eP1ybVdOZzeLtUgO839wytCU0JdMtxNSjwFkMEUx2a6UF4aEXBFVlvthhcHq8Hg94sjMHZdTHMeKYzP/vU+72yQYy+LAWeHaIeO3MAMcvPI865oQRhslkloJlo14fmBqexnUQdkgGIefSZ9abnmllu+M2mu1B7VeHAi4JjjHo5c3LhD6IQu/YXy+h8c7KOt2PmVqS6eD2i+fIuFjcuMG23ZaAyQwOCdJmSFuP19kijVZU9KR9b5h+GvdPU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6053.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(396003)(39860400002)(376002)(186003)(7366002)(7406005)(6666004)(2906002)(8936002)(2616005)(26005)(5660300002)(8676002)(86362001)(38350700002)(7416002)(38100700002)(16526019)(316002)(956004)(1076003)(66556008)(4326008)(6486002)(6512007)(478600001)(4744005)(6506007)(921005)(66946007)(52116002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?S+SMSURjWXIKveQ2mSZeVbB0aRQLAacMJmgFr3gi8z7IcERjnI1+Ap7FZG2i?=
 =?us-ascii?Q?67Jlmva+wcOYNAK4pJnVduC/zBdjKfe2Y61gDSRcQSEPq++ZNwJF94x2IRqH?=
 =?us-ascii?Q?adHj/FzXjlYvlpvrAzFGNC6CH3Oot6+H1q8jvvNew52P1rsTlcP/FntzBGsw?=
 =?us-ascii?Q?ZUhX7C63xn3KO2P0x5/5m4c3PIjguWzC4N8TRn1kq4Y8oO3tU8TFb3cayJCO?=
 =?us-ascii?Q?Dv8C+cd8MHLaAfvFDS1ZVQ4E8daGQvFfMASpKqEByrYZW6kLI0knbwQlW6yo?=
 =?us-ascii?Q?uQ/OXG6C6LnH4axSfZ8WVVw9TGOk8JK7hjhSTZnNuCoKzRlNZK3qgKg0jyZg?=
 =?us-ascii?Q?VIBAAmvS8wr93+9+NManQQ/LUweRS4cwVOLj9P+4YqPD5B0yWk+mPp28WwrC?=
 =?us-ascii?Q?HlT2qST10V/nn8FCzD7OoHVerCFhE9Eculd80T+i9GpSHvGtlxpHPzg8hYe+?=
 =?us-ascii?Q?Bx5A+bFr3TdiJ6bCLs32ENCpOtdQLQ1r49lh+6HEkbXvMm8v77RVt9FnQqsG?=
 =?us-ascii?Q?AKRhLyzDqo/y2N1pc5tfqCAMvwQe7wuPT2uDikWt7a1pHR7xOWPnzsIOY9aM?=
 =?us-ascii?Q?t67VKRGR9y/fiJlO9fRo+SsM6lNd01Wd6wmqxsg5Z+vUZVq7NTVDOHHUrQ8m?=
 =?us-ascii?Q?S5F3iZZMU3V+d39ZdRud/faNzI8M3Jzcq6juufv4wIjcv2LVX+TUg0VINyCf?=
 =?us-ascii?Q?1pcFuwwa5inibE2ZexoVKF9fpMXSVl5bE4Q9DLNjQuJ9nagmToIT1dDyMElx?=
 =?us-ascii?Q?a8xXva0LqZGz+l5GRxJeVpJOpzBitJkrON8x4TVwtspoBx/1E4697VrNGVUk?=
 =?us-ascii?Q?MrkPHiHltdX34JMQCXmhj6OtY3IE3hhyGSLnUNO8VgIhYlwDVtpTHGnNVJm9?=
 =?us-ascii?Q?y4o/U0TPe6a5jB+uYD0l5HOrCd9jWXfL3s3O+pMeNDbmFs4Czq118nXRW2sk?=
 =?us-ascii?Q?bFxkRB/GygPZkx7XbZGuaL2+Bxna/qyVtZOwG6+SBBely6ZiAsmWHUgiSspr?=
 =?us-ascii?Q?9uWLgjRVbObc8qClATUI6Jxpvw8icNfZkxhusCnRENfFN0w3Impf09Tso6Xk?=
 =?us-ascii?Q?vESSJ1bAPy5u5Oyrw+je82luTRtW+UqExOFztt7d043DNkSycUWujEk2D/aZ?=
 =?us-ascii?Q?9KK5gxk3p3IDHzNfa5VKJrJ6ikaPwE6CKOw6P89z1blH70plZWR7sCFP+zB3?=
 =?us-ascii?Q?PsziVAIuDI8XtWyzlqXpilP4sop/v6qpb2+7oN+0lsf98oO06xYXuQ+UiPIx?=
 =?us-ascii?Q?yCBmBrDAfKbremTDh2fNU3F0KdMTVCzoKTsT7jhe0M4uzPGfhSjjyWErycPk?=
 =?us-ascii?Q?KAsBmJj1eUtIWJ+ZxckWHRoy?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724ca91f-ed40-4bee-6ae6-08d902eb943e
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6053.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2021 04:28:28.1801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eKNFGQKKV8ae94+mHMJkcNLZADkRUC1l42gCa/eQ0RoO3DOcU7XWPoUKz7GZYHvi7hB815JMctxKH21FyhhFpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4406
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Guo <alice.guo@nxp.com>

When imx8_soc_info_driver uses module_platform_driver() to regitser
itself, the caam driver cannot identify the SoC in the machine because
the SoC driver is probed later, so that add return -EPROBE_DEFER.

Signed-off-by: Alice Guo <alice.guo@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ca0361b2dbb0..d08f8cc4131f 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -635,6 +635,9 @@ static int caam_probe(struct platform_device *pdev)
 	nprop = pdev->dev.of_node;
 
 	imx_soc_match = soc_device_match(caam_imx_soc_table);
+	if (IS_ERR(imx_soc_match))
+		return PTR_ERR(imx_soc_match);
+
 	caam_imx = (bool)imx_soc_match;
 
 	if (imx_soc_match) {
-- 
2.17.1

