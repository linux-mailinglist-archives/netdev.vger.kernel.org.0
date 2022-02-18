Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180254BC11B
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 21:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239265AbiBRUWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 15:22:44 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239261AbiBRUWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 15:22:43 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70084.outbound.protection.outlook.com [40.107.7.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEBF4AE37
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 12:22:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOT8Lf1Dsq7nkRoQjXU41Q+Cu1gh1cukBpf5Lp8oSV/+H2OCLuuGBCJU92r8ASnByB3uDqGGznD0Z0tSaZgBizDMN8W9rc4wv1vTYTi+NK3j25mZQojglKu6CaBDA+XlvvljdcOOgX/t3zeW8+OQ+KdpOU3V8/AMVVZ1xZliQgP4xtvqcnSkHj1IYCWoqyWkd95s3S1Z/b77ONXSWDTH0HnqDeH43hBg66Y504Jz8uUbezxu+8z+0sb0HzxWzMCZge81AzXLVRFFzrcYSGIqlL0sKTBFypd93aXILtcCPw9T8McFvir/DCboM0erW8UbJZ4+JXyRzQ1HI87gF+uF5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U8gwebwWnaf4zcyTs05JmJNzE7PDeAk3ahdomKkX7tE=;
 b=VFA2V0w78Z8fVj9H6A3tXLuR7UyZqzbnxACNs82JfJlZtcITm7FvTVneRPkRlrYib9YLOJLHdW84tEBVj5x1UC2r8Qb8Qozx09Poez3kT94QOJjFakyNgo3ZMPEclb5/ey//VZ5mYjIsoU2IXJ83aF194Mf4dM9V+7EdhXleF3qTzZdFUWLa5QU78qOZggHZRs/l9tir1iDIL353z/YYtG4Pwmb4o2OJD3bTV/CEOav1Q3T8cF7pGnK31IWxmmMqv2Dcuqv37CvGgiwMK+8p+YqW2w69065i65N5seCT1mAZl1RD8t40+CK+wAmYmhONGw3fZZu7Uk+Zad57yci09w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U8gwebwWnaf4zcyTs05JmJNzE7PDeAk3ahdomKkX7tE=;
 b=nejBLVDOGM6SXDnwxc+nth1iMSjrrs8NvEIZEIHnoZFN2APkiCRPG9OxDbZGO2ZC2a8r5nQLKZq7uPqE1OtGyNCOqbriJAJIYXnCRlvtvhUjZ4ClFRDPrE09JxptnAHjacAgk2sqOrIq8QPF4m+8jkxCLXzOeoKdeIHGYx62nUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com (2603:10a6:803:e0::10)
 by DB7PR04MB4378.eurprd04.prod.outlook.com (2603:10a6:5:30::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Fri, 18 Feb
 2022 20:22:22 +0000
Received: from VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45]) by VI1PR04MB5903.eurprd04.prod.outlook.com
 ([fe80::18c5:5edc:a2c2:4e45%6]) with mapi id 15.20.4995.022; Fri, 18 Feb 2022
 20:22:21 +0000
From:   Radu Bulie <radu-andrei.bulie@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, ioana.ciornei@nxp.com, yangbo.lu@nxp.com,
        richardcochran@gmail.com, Radu Bulie <radu-andrei.bulie@nxp.com>
Subject: [PATCH net-next v3 1/2] dpaa2-eth: Update dpni_get_single_step_cfg command
Date:   Fri, 18 Feb 2022 22:22:00 +0200
Message-Id: <20220218202201.11111-2-radu-andrei.bulie@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220218202201.11111-1-radu-andrei.bulie@nxp.com>
References: <20220218202201.11111-1-radu-andrei.bulie@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5903.eurprd04.prod.outlook.com
 (2603:10a6:803:e0::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c73cc969-8ce3-4eb4-2f0e-08d9f31c5dfd
X-MS-TrafficTypeDiagnostic: DB7PR04MB4378:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB437842CF20883B8D00CAE84EB0379@DB7PR04MB4378.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4n7+EG1spx1gjSOvcMa3qdBuDVODLFbfCtPpG1DV0FL6XRjAh0//gVJeW+2vLJf+bqL1sRe6XmkaYE2BuiblxNQesqC+vypXnpe6gYeqO5RPQEV1nn6QCqAwtULkWZYRHA5N3EmxRzRs6J9/prdCK45SEFU5+2odRyFDBD++wfCuMYDlB9qL8y4kcU7Z3NIvSdVzvGXRuX+le8zKIv9gLbEJ588vxXc7pU9mdzPVf9HzWsm2eDN6aSunjjtzKF2vMDI+UhCSCrM5au2rfyv0wvGvnCC3mzvRMgoH349OaZLPPQpWOyE24IgazNWvNTDthDqyGfuTfCPoGFi++GO9xuIVWnNb1Xk8l33DcOcLKdwzBathc6YX8ClBtPLwHv109vbdd5cAUqvtx2DXSEYTQ9UfkQjjj2IG8IAeUuOLZfpvad/JdIfBS1g4ASGVGkKEZZ+TNQaZ5rNPv9U+WuBJID809RR17RH0r9xc3y9PSX+h3hXk6Yas0ZPZCY/mrpRVQgWZfNHqamcLberDZRvgDvb2SJ+XYk+l9UFZ83MF76Qcn5jQ6Dde6PRSITkgXprMm1DaKnbAjz5Q4mPk8GRg5ioZ9pjKWMpatA0m5bRf4bbUbDLgF/ARU5F2uHCRj5Fd+pDiLRQhgTg4wBuGaYmhlFWlJ/mdRhsWsVQlitMmY1rwJGfC9PniQBoUMj9e63AU5jQitv3nimCLgNssnvhcyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5903.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(8676002)(508600001)(66946007)(186003)(6506007)(66476007)(5660300002)(4326008)(2906002)(86362001)(66556008)(36756003)(1076003)(316002)(2616005)(26005)(83380400001)(6486002)(38100700002)(15650500001)(52116002)(6666004)(8936002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?deNldV04MJ/pp5/8VN9Y0MTSGuCX8kq0q6KY90M8H4Q9jfqvf98IjouWGWW9?=
 =?us-ascii?Q?+DNxaHr+A0SpzMKVjsdXo6BI2ZHyNMhc0BE5DHLe7/a6MWFVyTkqkV//iQ5S?=
 =?us-ascii?Q?O5DySzUvVPGRXLmsDcfmshI2dq9/BBQiDo/EnlF0Wx/mrcwI0sbHwqDEB5ZP?=
 =?us-ascii?Q?dKHm1JRh1tXDyEgXFJokby3Z9pGdYxRY//TMceko1p2El+UM+WLy3gdFrKnJ?=
 =?us-ascii?Q?2zwN9C4D5wlt3CVevdWCZRLr+8t1qzJHzANucd9t23sjODXIg0HprqK1ezvZ?=
 =?us-ascii?Q?5mUjqO0FulMCAymxYpFocuwWMp3+Xa/XxUbFPEnGIYx5hk8apjKndyISTAHo?=
 =?us-ascii?Q?SD6IKe5oVVSv5wIhPUVLMwTQWB9yrTVlrGdbMrkXUwS3XWra2PbdkITFjwWQ?=
 =?us-ascii?Q?AACpLwUCeTN6fEI1o76D5JNJ9vRKZzisFKi9sgtFZYHp33F7mPL+Egs8FnA1?=
 =?us-ascii?Q?lT+qNLDFaPItT9vSdp6KfDiOc+Gq65MdNKuPZopprW8uoyhfwh7v4c+D05Y5?=
 =?us-ascii?Q?g1edESdRG2RfUJHKRMvJgZ341spY3KRFLJnU6dG8sffCDvz7PlYkaNhNeo5a?=
 =?us-ascii?Q?BhMS5J0osxlYFoBsO9QtH7Cw8dR/vBqiemkDvD5u6G+v4gvYWz5N8SMkHsqJ?=
 =?us-ascii?Q?GvgEyJgS4QhM0S+GDeBVDJEJ5GxXsQZlLvZM8voVvIr1I7SYtzioZ1hVBDZ9?=
 =?us-ascii?Q?RKQweO/NMkrFzRVMnHK5RBlCCaCuTvmSw/sbVydIXXBkRqcWaewwlNhC03o9?=
 =?us-ascii?Q?a4U+DSy3ETlh/A/1/jAToB6GVZUhwm6bLK+NeiqtW+0U1qIo1XJfgiK2iakv?=
 =?us-ascii?Q?afB5mvi1rfAoEO4a7JyFmSIt0eFMwwKDettGSyHflwdDgYLFuGuK0Js2Owck?=
 =?us-ascii?Q?MRBMHs6BFJw76bKb5uJ6TmN5y8evByI4reNoC0Gv6gjdnZ7So5y5p+ZRKP/f?=
 =?us-ascii?Q?5HZguW5gvNYS6Z1dFvX/4B3kGrQ9b2ye97O0Yh4j0lwjtxxJ1mUYxUfgspjV?=
 =?us-ascii?Q?h6GEEeQfn37tYnqTx/3Td2qNc/UUUibxnC2Lq0dez30F2fNAw+Wn8nNg5Jhl?=
 =?us-ascii?Q?w3B7B3PCw4rSQvECFXnfCfDub0xadnRhw+A9Wyf0SKwQ+wYT4a51y281FxK0?=
 =?us-ascii?Q?OANB/G8fbqcUUjIV+wO0m7c7l6X2707BEos1RwBdfbFs9GY4dq8HRIfXWrkd?=
 =?us-ascii?Q?ITtQr/dhFcqh0wceB8uvG1Ow20pMCtQwGnRZu1pQscwUABPyW+MVYhtt3d6H?=
 =?us-ascii?Q?NeLo8KSF81ofeLOmRqCb4FjSttnqoqo7d0+NOOqGh7wvyXR47acw3mnQQM18?=
 =?us-ascii?Q?v34q9abo0ZBO2xst9QlUuwhiZn4r5Yfzb6N8jp0C49G+IzOLsY/htO3MTfk+?=
 =?us-ascii?Q?Uo7PVpyflsLJr1QcEO8Gg2y87qcjyZlFxrtyLJWEBKIZqwud4+sO0sqBoIp4?=
 =?us-ascii?Q?7FV8VBQUJXi6OEJR27OixSYS8ZLqYozeqbAjU/lPZ0Zay+2VIYW5U6MH+kKA?=
 =?us-ascii?Q?3cNBfzIUMkcEOLjW+u3WE64e1YejsdjikfTv128gilDQm7r4wNv+cwqUVxFX?=
 =?us-ascii?Q?fFKB9njMYFN1lbnjLVZ+4m/t4AMzhZZ7ekAlEz+A9nFb7eitvOYjp4DgjCKl?=
 =?us-ascii?Q?KsP0GLjIOHO24IYREAldMBxlUAfYByYbaEYbuKOmrYV1zOTGhO2BrgH9VmUB?=
 =?us-ascii?Q?I/F4Eg=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c73cc969-8ce3-4eb4-2f0e-08d9f31c5dfd
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5903.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 20:22:21.2705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +zijAYPdYrkcYnMU7k/YSzCOxUqe6BKj2k2ryf+UEOGiiG3NWzbUhC9Lgkjy1OmhNg12qkQ8c9B6d1kIj2qh1oguRMeqjcx48f/ixlu5Gq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4378
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dpni_get_single_step_cfg is an MC firmware command used for
retrieving the contents of SINGLE_STEP 1588 register available
in a DPMAC.

This patch adds a new version of this command that returns as an extra
argument the physical base address of the aforementioned register.
The address will be used to directly modify the contents of the
SINGLE_STEP register instead of invoking the MC command
dpni_set_single_step_cgf. The former approach introduced huge delays on
the TX datapath when one step PTP events were transmitted. This led to low
throughput and high latencies observed in the PTP correction field.

Signed-off-by: Radu Bulie <radu-andrei.bulie@nxp.com>
---
Changes in v2:
 - none
Changes in v3:
 - none

 drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h | 6 +++++-
 drivers/net/ethernet/freescale/dpaa2/dpni.c     | 2 ++
 drivers/net/ethernet/freescale/dpaa2/dpni.h     | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
index 9f80bdfeedec..828f538097af 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni-cmd.h
@@ -98,7 +98,7 @@
 #define DPNI_CMDID_GET_LINK_CFG				DPNI_CMD(0x278)
 
 #define DPNI_CMDID_SET_SINGLE_STEP_CFG			DPNI_CMD(0x279)
-#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD(0x27a)
+#define DPNI_CMDID_GET_SINGLE_STEP_CFG			DPNI_CMD_V2(0x27a)
 
 /* Macros for accessing command fields smaller than 1byte */
 #define DPNI_MASK(field)	\
@@ -658,12 +658,16 @@ struct dpni_cmd_single_step_cfg {
 	__le16 flags;
 	__le16 offset;
 	__le32 peer_delay;
+	__le32 ptp_onestep_reg_base;
+	__le32 pad0;
 };
 
 struct dpni_rsp_single_step_cfg {
 	__le16 flags;
 	__le16 offset;
 	__le32 peer_delay;
+	__le32 ptp_onestep_reg_base;
+	__le32 pad0;
 };
 
 struct dpni_cmd_enable_vlan_filter {
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.c b/drivers/net/ethernet/freescale/dpaa2/dpni.c
index d6afada99fb6..6c3b36f20fb8 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.c
@@ -2136,6 +2136,8 @@ int dpni_get_single_step_cfg(struct fsl_mc_io *mc_io,
 	ptp_cfg->ch_update = dpni_get_field(le16_to_cpu(rsp_params->flags),
 					    PTP_CH_UPDATE) ? 1 : 0;
 	ptp_cfg->peer_delay = le32_to_cpu(rsp_params->peer_delay);
+	ptp_cfg->ptp_onestep_reg_base =
+				  le32_to_cpu(rsp_params->ptp_onestep_reg_base);
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpni.h b/drivers/net/ethernet/freescale/dpaa2/dpni.h
index 7de0562bbf59..6fffd519aa00 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpni.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpni.h
@@ -1074,12 +1074,18 @@ int dpni_set_tx_shaping(struct fsl_mc_io *mc_io,
  * @peer_delay:	For peer-to-peer transparent clocks add this value to the
  *		correction field in addition to the transient time update.
  *		The value expresses nanoseconds.
+ * @ptp_onestep_reg_base: 1588 SINGLE_STEP register base address. This address
+ *			  is used to update directly the register contents.
+ *			  User has to create an address mapping for it.
+ *
+ *
  */
 struct dpni_single_step_cfg {
 	u8	en;
 	u8	ch_update;
 	u16	offset;
 	u32	peer_delay;
+	u32	ptp_onestep_reg_base;
 };
 
 int dpni_set_single_step_cfg(struct fsl_mc_io *mc_io,
-- 
2.17.1

