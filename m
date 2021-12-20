Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96FD847A807
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:57:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhLTK5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:57:04 -0500
Received: from mail-bn8nam12on2086.outbound.protection.outlook.com ([40.107.237.86]:30177
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229782AbhLTK5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 05:57:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JeoG8neYYKBHgNkqhS8MMjIMMJ0ZOPAO6YVD2LD+SfVBBc+OCDBviN17VJ4R75OyxrMZEfSCTMDN5wtFT9nj+vhac2Z76uGhLezDZCl+SqM+okep05eE6nI7Pfivikw8RgWc1jrjJhkRtwKIMKNulXZcSMVn7Jqzal2kudScVQJVaKHCmwNNHrF+Ib9ZsKyLLrNI+6siCCuOsrKrO77GKJTfrFuwzYw1xrp7CMb/3homFwSmljot+zp9UzOqXcnbm3qfu8kEmmVSfcRrH59DeFCrUn5dK4jrmnQDfgbXeTgHFyrN2PlC8jATxH4aGfDqVwnndmB2ctRJ62QJq1d8XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTe+dT5bzm9TvNG/vtErsb7Dn8buZEPSbWUIRDHEKCw=;
 b=Oo8lDEO+i8VlmZtcHaTYAytMwnDzpWaQoKAQ7rlsXGufgvgyDSny4zCUzB3F1saiHykhqrWK7ed+J96R+LbAPkE60EB0kVkKg/m13DusHVZd19IDQKcSirCD2Wjy6euKm78xlugAQ6M9N8FhLodvyOeFNsGrRc2pCWOxr1liUjR6D7jxHM86+nTFDkw8lDWyI0NYpNO5W8nPV1si0U/FtVCesOK4VreLHZ0Pfik1SWHm8sif5yI/vzp3jdcGlqt7LhtnT8rlJaN8UPwA5NvZ4nbdD7b6GFnjQdbuB3XlBBCEA3gfBQsMtIhQjY2t5W2ZzRQQ4wZis4uoW7H8k1TX4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oTe+dT5bzm9TvNG/vtErsb7Dn8buZEPSbWUIRDHEKCw=;
 b=HsjnOx9Mpbd9ykmKjvuwNYUM+nwwPFlsaCUBq0OOZoW06RYY6yN0yez9YHoV+34QYK7j8sN8tBfPB+oEPoGYlCUtvfX7tBAPrpfaLlZU8DTr3hB2awL66dQHZhOoUuSWQMF96vDuJf/QtuXN7w+OV/ejiwLb/I1IFP2YGu5C+TFVD9ayFbc+tA0VIDe2gMTmeNr4G0FWrqzHbM/q5ETQKobbCbhKikZUpZycbdzFXTAsjnys/dslHA8o7Stsf04ydkONS1ttBu+MIFELGVF3DwsAaq9oJPqEDhakM2pIG5mB7QILUGjTYy/8KdcQLGW+B/yAU9pk1X5qvVLbNhYbzA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB4760.namprd12.prod.outlook.com (2603:10b6:a03:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 10:57:02 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 10:57:02 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/4] mlxsw: core: Convert a series of if statements to switch case
Date:   Mon, 20 Dec 2021 12:56:12 +0200
Message-Id: <20211220105614.68622-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220105614.68622-1-idosch@nvidia.com>
References: <20211220105614.68622-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0010.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2e::15) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 535eea2e-8622-48aa-c0ab-08d9c3a773f4
X-MS-TrafficTypeDiagnostic: BYAPR12MB4760:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4760E4EE6D979CCDAD1ADFB5B27B9@BYAPR12MB4760.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2uZZUb5cq17CAho6efQSoZaSK/sCmpZOxX1y5fx79avioaozTsjBRZ7sMGYWOUnp2BaERB5uaECAd1npaj/NEnwApLtucHn3Z0hm4v0wmcY8Ba1AXjLAczbAjj5ISBFSnRTTyYKpdtuLcmoEjVGhqFNyCtX8XpXMAPusnNXm/KlxRWL6WW+SX4lCNTfk6hf3jI7x518yMWeKzjY6pEIRHMZ5kaHSXRxueToKe5tJ6Epb8A+vr4z00FHXbCcnHv6z+Wt9oFHKdWp6J4SfMT6WF2KT7vKnOdQsDDIoyuOPkFzDgyVOlJvcTgpJWcY2txIqfHZJezaq60UwkSAB1Ou5f+JlYNEcIaW+FE7dglFB5xatwjlkmUceFEN/Z/EFUbQphssl/I6U2R6FNO09ssRiUWN/u5J1UwwJRHJarRPMoi9k8/PnNK6ga4rZzlTeZWCWcn1UhzuvfnVYyEcaqP4S7HDq+UgWhmFZlpxhFchQkZ56bZn0MT06DlnoOsfE0cJ1XQfPn4ofgOPZEUwgkT1LF6vmalCTeAmQR99YDioA81YZYQoOJxdb78/ibcRgpKZAMGzNQqu30ilN/VEkFDNuggXDicUung8i/uDRnCTbZMPF3f+kFgZPZW56RaYSX6bYNt4x70GqS/ke6TRoJ31emA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(4326008)(8936002)(107886003)(6916009)(66946007)(26005)(316002)(86362001)(38100700002)(66556008)(66476007)(6512007)(2906002)(6666004)(508600001)(8676002)(6486002)(2616005)(83380400001)(6506007)(5660300002)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CUX56mNqxDhccudleFqL45PAXuY4/uh9xqgocN5BYUeYp6hBtIH2JQBiUT2V?=
 =?us-ascii?Q?3gKCwm325GmxwveyEyh23rYfbs7Q1Ns5+e02UaMZLW3ruznkcnemLl9BtlEz?=
 =?us-ascii?Q?dwBUoVjdMuZMvfWgYcKaagSaveScwP9HXPwmWnHgDARLOZsQQt2qZPTWdfb6?=
 =?us-ascii?Q?i7Fp+s6uszFHfiq04vtUvLsI1fntE7ouvuhFy32oPLg5kBPf+NHXgqBx4bex?=
 =?us-ascii?Q?HN1M5WPf0ADy9KrnZeP/+op/J/z3Up+6wODcRx0oaDE9jKA2a45xFCRqkCrw?=
 =?us-ascii?Q?FUZW3rJhfVTl86sxohJEoqRhwaqaeuHES/LZuSr3Dgz8Kvdo3NK3tziMLoJI?=
 =?us-ascii?Q?YFN9OTDp1dekjMoQQIfknVe0t6x5pFHNk9JItv2XE8M8u3OZ/5H88fFrnZ/r?=
 =?us-ascii?Q?eZ0Myb12VTihrF+rtIuUqly9bzfItd5CuPssG89DBtkKU19vsuyT7k2Wa71M?=
 =?us-ascii?Q?uvy++nYZ1mmn5TKnQwd4SgohGlLqSD9HSzFrC2CARgWHUykrAsrek3q2Pzvl?=
 =?us-ascii?Q?8I4/uzJEBFXMLLGHIYU0rUIBIaChua9/YvSnu2KAgjGZ6sx7cIqjO61LhHZ+?=
 =?us-ascii?Q?mXMc7LVRTIOx65FZ8g07lQtznp0TFPjDVtz4zjgZ0pa2ilgbgo1pGfrPRLqE?=
 =?us-ascii?Q?/0kK9CwVsausyAzx/r4nbSoRG2CbVla7+YDOgGrjZh3QvM3UEsgxr2Sd8RUE?=
 =?us-ascii?Q?igX/HvAhpsvU8+w2NMbZWdRCum+iEmeiJ2epvp/TouPD6lXzIxpOkeumxo3M?=
 =?us-ascii?Q?8sozxW2HYKKTbJqQLuEbMOFkaEZlq27W2xob9WYh4S1cAPlra0Z4ga+HiI4H?=
 =?us-ascii?Q?YMsr/gnlNanKMWft5/4IaKvz6ocl9APwqHPUswpIkQiXSXDKlUJLGXqOYZ9V?=
 =?us-ascii?Q?+Sk9A6zwV0bbRdyJnAEm6ijs75TJ8tAXyY9qrwN4TxNRcZDvmJUcDlXHsTML?=
 =?us-ascii?Q?FvJheihHSmA0jdyMwIhihAA/scoBDEeLHW7MZDicQL/jOdn9x/3W0vmeJFl+?=
 =?us-ascii?Q?ce15Pb7xmDSr7/0G6Vf7vkdhCiwssSHbIjuJR2Vz9xkEVH9ZPUPMzUqXWinH?=
 =?us-ascii?Q?UpSUyhk16bs5gd2USm39bcR0T1CTBMpuPMz8KgBLh/+Ek6PwxnRFeOae4u65?=
 =?us-ascii?Q?Pt7ba6GEIqFxBXyWXV+OcL7CNaSHS2f8vSzAQf960uQ0j6D1a0HNeeVLiAax?=
 =?us-ascii?Q?kyiv6m2c2XtPJx7dEoSV94ON8STeiGXhlL+N/lAMeXFEIqGM2BlTrq0551pL?=
 =?us-ascii?Q?rCZnG2ZPUYWY0gxwPLsuU7Lq4rf92Lxz82KZhukBoCKY9vIWlLfCDw8LapNJ?=
 =?us-ascii?Q?qxXxAbdGzoYcq/iUmlTCkpNwP5xM/P09KttNbAiGC92LoZ41rXsoWEh5KPB8?=
 =?us-ascii?Q?7I9FfTyvFGV5tX6qvQ6DCK1vxiRwZwkYCsJVRD7VgslwH+j1TxJDxdyV8CRS?=
 =?us-ascii?Q?xVbYlEPtUkxvO+YyypMQhAdWN+b3iQ28QZTQqg8benBGxoeBVKtfP+8Kl5tX?=
 =?us-ascii?Q?pApFRRjYUkEr9D3cUA9lu+U/2vLFAmzywlHTzfDg4TJISEO5H69PBA4RfWDw?=
 =?us-ascii?Q?A4YoPwCCL0P0rR5xv79NF4cMPSAAg+3kmQFAWgHTv0G1SrXUxUphfl0GvH70?=
 =?us-ascii?Q?dB/bP0mRZZkmpHIvrJPRIKU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 535eea2e-8622-48aa-c0ab-08d9c3a773f4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:57:02.4041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1sfV/cR7GwZsxjqKCVhvg5aP15kKCU8nz5uU0d9GztoKwk1hv28Gnh6dZ+VKcyFb16TStXOy2vUkC4N5UCec8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4760
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Convert a series of if statements that handle different events to a
switch case statement. Encapsulate the per-event code in different
functions to simplify the code.

This is a preparation for subsequent patches that will add more events
that need to be handled.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 58 +++++++++++++++-------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e1d4056f9eea..d9f12d9cd0ff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1708,6 +1708,39 @@ static void mlxsw_core_health_listener_func(const struct mlxsw_reg_info *reg,
 static const struct mlxsw_listener mlxsw_core_health_listener =
 	MLXSW_EVENTL(mlxsw_core_health_listener_func, MFDE, MFDE);
 
+static int
+mlxsw_core_health_fw_fatal_dump_kvd_im_stop(const char *mfde_pl,
+					    struct devlink_fmsg *fmsg)
+{
+	u32 val;
+
+	val = mlxsw_reg_mfde_kvd_im_stop_pipes_mask_get(mfde_pl);
+	return devlink_fmsg_u32_pair_put(fmsg, "pipes_mask", val);
+}
+
+static int
+mlxsw_core_health_fw_fatal_dump_crspace_to(const char *mfde_pl,
+					   struct devlink_fmsg *fmsg)
+{
+	u32 val;
+	int err;
+
+	val = mlxsw_reg_mfde_crspace_to_log_address_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "log_address", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_crspace_to_log_id_get(mfde_pl);
+	err = devlink_fmsg_u8_pair_put(fmsg, "log_irisc_id", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_crspace_to_log_ip_get(mfde_pl);
+	err = devlink_fmsg_u64_pair_put(fmsg, "log_ip", val);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *reporter,
 					   struct devlink_fmsg *fmsg, void *priv_ctx,
 					   struct netlink_ext_ack *extack)
@@ -1800,24 +1833,13 @@ static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *repor
 	if (err)
 		return err;
 
-	if (event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO) {
-		val = mlxsw_reg_mfde_crspace_to_log_address_get(mfde_pl);
-		err = devlink_fmsg_u32_pair_put(fmsg, "log_address", val);
-		if (err)
-			return err;
-		val = mlxsw_reg_mfde_crspace_to_log_id_get(mfde_pl);
-		err = devlink_fmsg_u8_pair_put(fmsg, "log_irisc_id", val);
-		if (err)
-			return err;
-		val = mlxsw_reg_mfde_crspace_to_log_ip_get(mfde_pl);
-		err = devlink_fmsg_u64_pair_put(fmsg, "log_ip", val);
-		if (err)
-			return err;
-	} else if (event_id == MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP) {
-		val = mlxsw_reg_mfde_kvd_im_stop_pipes_mask_get(mfde_pl);
-		err = devlink_fmsg_u32_pair_put(fmsg, "pipes_mask", val);
-		if (err)
-			return err;
+	switch (event_id) {
+	case MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO:
+		return mlxsw_core_health_fw_fatal_dump_crspace_to(mfde_pl,
+								  fmsg);
+	case MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP:
+		return mlxsw_core_health_fw_fatal_dump_kvd_im_stop(mfde_pl,
+								   fmsg);
 	}
 
 	return 0;
-- 
2.33.1

