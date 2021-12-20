Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D6147A809
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhLTK5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:57:21 -0500
Received: from mail-bn8nam12on2078.outbound.protection.outlook.com ([40.107.237.78]:61921
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229782AbhLTK5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 05:57:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpKL2FCJXUx94GK4gtBxz/X5DNV6ER0+DF4WhgC6hRvlk5wNk7IvfijBk/b8d9PXCDewlmGNJY5i8AWxwQ/OJn9106PGTDW3W/XDDMSwL7VO5NLJ6W/VNjQ/x4CHrHlnyLb3uuvicFlYaGlCQv1r12mxirsorWILS/5OTD30ulACCNk3B8huvij/q/daaBbb9JELxjqCsbce5gwI1s0wxTkxSD+LvUvkx161BW1j6DNWUB3DXYLuMedxQZXuu4JbND5n/4Bey5WlobhWV9ntrpHavFfmrsxLeEyx0WQ17/SKckON9yU1aCmtYXubcRLlyPaEcNdlQrzQY8nnwxJD6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x/mDhe8F1J0hdJqv5MYuJfVW31FN5pbJLzczV/29BxA=;
 b=gDBRttDRLIAc+hRRGIziheoPe1aDFobwcDgSwko/xoKsXYg+rKzNwUajHnjkfLeLU9EK9VXLqkWJGnDlsiBRp36ZgAvy798ZShC+uSCMnRJqlPn3aULIWc8tZyq0euFTd7GuhI3zUk4sWyH2gBxo7AEJG8+CFH5mKx5Ik4QVyDjArQXgdUJrwjK4rtbyOvRUBxTrpIeiiGD62XIzzsJsvqvXeh8UVnI66Vi3iMo8KvanF8TnV6KrowPG2ACLfj2iTcs7SIJtMkiZo3I51dundgWlABM/VXR7cVEbmJCZYKuYU1IPxn7haZ5OrFCs8b73yWSROvQ3K9iMVv5A+hulBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x/mDhe8F1J0hdJqv5MYuJfVW31FN5pbJLzczV/29BxA=;
 b=OVaur//UUch38kxkQHfW+WCtq4Rl0EKwFSJyvj/7/UrHnl8FK4/yZtzjHMEGVzQQISBp53lYZEpjBNFjbYXM28rf/WkMcwkweUxekfKTNjE7n/z0dwrAslFBfs+z7Y/05N8yHlUfA1IS5bo+y4j15638ZkbhPiblpHoJptOW1MAeTsod7a4DIKCzgpWAzlccNapkYsSrIBhev7vQKmIXe+A1f87UnCYC1BP5fzi0pyEJHyc8dSscVtS32vmljnSAOp8v+TDbQO8cFGJ8d7jx6noI7js205T2sYcqxosnMBhq2A/o+1c7+2GlygdU/VJhm2J7cPkDzyiYq64Ch0DPxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB4760.namprd12.prod.outlook.com (2603:10b6:a03:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 10:57:16 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 10:57:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/4] mlxsw: core: Extend devlink health reporter with new events and parameters
Date:   Mon, 20 Dec 2021 12:56:14 +0200
Message-Id: <20211220105614.68622-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220105614.68622-1-idosch@nvidia.com>
References: <20211220105614.68622-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0077.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::17) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1af72aa-a6a6-4d99-113c-08d9c3a77c67
X-MS-TrafficTypeDiagnostic: BYAPR12MB4760:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB476064CD713CE4677BECC534B27B9@BYAPR12MB4760.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N3MUSKAmR1ZgrN+02LMouCaHfQaL1gVrd4n9TFo5Wtbjx2UqGmvjJc4uZpAjr7yGh1/IJPaVVHkbbvCDaQiXeTmHQCh5WoxetcgIOoDLfBijGwS0w+yNmrtpoP58DY2pYW9x/J1umoT8dka/WXXHJTNkBn2XB7QtyIeuHSASet8gyWnkmAX6ADeOIblBSn86/SpQfwC56WrI+9Jdj/py6al/czbgT/TEzhN42ZSZ412FwUl26yhXvEx9RUJrwwaCHU62et/aeYfZhujKNAQulqNnjq/iH6WvWOVIZxn2IzaYmTYTNMcfm8h5sKqt6+EBFG1rGEXCuf8W+x5MAOnqwnge1JRNPMkUjEysBGur79vX/Stld2jf1OUotfqYk0YVe/53v41JqXvDB5w1wNe/9ASCITX9TXDx0+R913k862h6kDYe2x7JTOQWTOvxhUZFh02G8h6VHpZO46EDKSX9LWTld/K+kUmd0vKdPOa+bQyv0XOp37Xjwoxzza11zz7yJumV4KcOTehOAYdpti/wMu7aU+syfCtRdJH5o40csI17p0im47Z5v5dyep8/3IKfvVa3eXWsKnG/w63raXuxVRRhbl77fvmpcmNRfy0wfvbI86RVrMQ9FHXmu0GihtDDYityihphLx9nP6BNVrSsOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(4326008)(8936002)(107886003)(6916009)(66946007)(26005)(316002)(86362001)(38100700002)(66556008)(66476007)(6512007)(2906002)(508600001)(8676002)(6486002)(2616005)(83380400001)(6506007)(5660300002)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H4gMTM0OkHEdujeiPYjbW0AGwwI/Z1nYaL4JOxmZKLO9mHJWs86fZoqqYBvA?=
 =?us-ascii?Q?eGCqgJV7tXo/jeD5L+m7CHMTKIBs5v07MEXMzMg4IbYNmTN1ujskT1uMAAEk?=
 =?us-ascii?Q?2E2uGoF3GkqitRbrk4TCf6W4mpOlDaGoeZu9cQ/g++D+EHYxlaEGvHcWYCMV?=
 =?us-ascii?Q?0Ce1iPKG1C5kw9STA/nRf+PQgRsXCBV8MNzY4T1mvrdOH9yk0StzYtt97Kvs?=
 =?us-ascii?Q?fB8NiahcfCjcbisx5luikAJnUs53C6YPKoY3IFfVZakKOW8cGdaRL6e7ZT0Q?=
 =?us-ascii?Q?+IhC2xb235oT3+3SxiIiKiAH4VwVccwNzqkd85hrE9zxBl9LUSccw509hFTf?=
 =?us-ascii?Q?cQQCVOUkSQlSH4+yae4qZz4ch2Jlgo+y6nDOyZyF6gis6zmxFZeDiUvef94u?=
 =?us-ascii?Q?SsniZES2G4xT/sMkG4cB7HSdY2Rjw5nXhvQRL/9pEnuH93hmCWm1Bey/BIAH?=
 =?us-ascii?Q?FReAk9QCtunHx1UrrfYukKhgvzE5y+jvPboKxPGx1FVOYqccRNay97rhIJCf?=
 =?us-ascii?Q?U6sjoQrjIEinVNRRECR2mNciLD5aBxuGcSvgB+LVfQAEGwFHb1DsSC2NwvYR?=
 =?us-ascii?Q?EWMGwmLmIFm266YNiKVuzrbX42g16/Qmm38dyA5w3Yutme4wBi/h18DHgp2o?=
 =?us-ascii?Q?3s9bO9/N6U1ZkU1B5Lzloo+/8KSiHuFAoXkszlbdPE74M5D2muPc4VMjP8lJ?=
 =?us-ascii?Q?xqEFBf8M5LE4fgwgXYrVWFAAwRjqasCDW8COmSvTW+Al0o/3g33z4rovEWNz?=
 =?us-ascii?Q?4y6TR0ykAcZYQaLeh+YxXIO1ZaHTPwpKE5/Ugk3L8NT5Nwg4djJlxYxIvADV?=
 =?us-ascii?Q?Zs1r3yKtQYqnaR5DjITpvr/KaNDFYfjQCf9r38RLvDUWd5aJEMzhpgOjFYnA?=
 =?us-ascii?Q?5qD7c8V83OolFp7nnVxpYm+ec1uS7Vk7TQE4X9LZU5Bka1FiXFzHOl7FMyuR?=
 =?us-ascii?Q?WokrmS4QJJXHSqIqKGL06FEOPQf9SrUgH90RLXZBFTewPMaYq5ApX2RIBO2I?=
 =?us-ascii?Q?G/wJ6n0MsRnR0wYMsUCKMmNdgMMvuqcHApVmMydAC98Ah+S8ebycHpxUVfbP?=
 =?us-ascii?Q?udyY2Kq1P8RDAGoVseARO+Z0q5U+JUPFWknNnye5l4S8etoYWSC5y50z9Lmj?=
 =?us-ascii?Q?OwQYR38ernSfDO3rFPh9gnMiO0LMjqWDbOxNGRkqdEW7X7DXSL/9ffMzqyCC?=
 =?us-ascii?Q?sSXQEamQkcW5peSTCmUrgILV7RrRC3oHwHH9+EsiDkZqro9flEJGz3yx+NBh?=
 =?us-ascii?Q?9B1v6q7BeZ8dvDp+8X0ONrAGfmJBd3r74rr9UI+jXvR/tnRvqiCXuiGO2w/r?=
 =?us-ascii?Q?lLohizhFovBlDobVR83e1FE4IbVTxrvbUegF8oAT/J6BAlPONBQcMs/XWnON?=
 =?us-ascii?Q?WxuJnPqJvtcPJY5TRzNjfu8xL0V5EH8xMff0mX55NdEsyEKpD7x8EVtZuwQP?=
 =?us-ascii?Q?9wsJ2Cx93RO1FZxRLBadlzcnRIJKR3pTJp/eJNKnJRCMvoGvue//3/Xg0QOk?=
 =?us-ascii?Q?vY7vouHf/Dy2JWir5Bb83iC+YO8L4rBGoNfAxIMB0iCRKY6bCLDRFkqkMPqH?=
 =?us-ascii?Q?U+qRsZ4pPq8OER3jQ72wUj/tmsQ6RULw+T77uUtIpb9ah0M+aIYQ1kJXSMLv?=
 =?us-ascii?Q?1WK+oaWk9rwXPRbOyJtjRHY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1af72aa-a6a6-4d99-113c-08d9c3a77c67
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:57:16.6688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0sVa+vxHFXQ+4aWbshy+DpY11jtRA2PvdpkW4i0wThRv8EtPcjXehuOHRHhsN8Js9r0BAnulBEVsYRFJT1IW3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4760
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Extend the devlink health reporter registered by mlxsw to report new
health events and their related parameters. These are meant to aid in
debugging of hardware / firmware issues.

Beside the test event ('MLXSW_REG_MFDE_EVENT_ID_TEST') that is triggered
following the devlink health 'test' sub-command, the new events are used
to report the triggering of asserts in firmware code
('MLXSW_REG_MFDE_EVENT_ID_FW_ASSERT') and hardware issues
('MLXSW_REG_MFDE_EVENT_ID_FATAL_CAUSE').

Each event is accompanied with a severity parameter and per-event
parameters that are meant to help root cause the detected issue.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 131 +++++++++++++++++++++
 1 file changed, 131 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index d9f12d9cd0ff..866b9357939b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1708,12 +1708,93 @@ static void mlxsw_core_health_listener_func(const struct mlxsw_reg_info *reg,
 static const struct mlxsw_listener mlxsw_core_health_listener =
 	MLXSW_EVENTL(mlxsw_core_health_listener_func, MFDE, MFDE);
 
+static int
+mlxsw_core_health_fw_fatal_dump_fatal_cause(const char *mfde_pl,
+					    struct devlink_fmsg *fmsg)
+{
+	u32 val, tile_v;
+	int err;
+
+	val = mlxsw_reg_mfde_fatal_cause_id_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "cause_id", val);
+	if (err)
+		return err;
+	tile_v = mlxsw_reg_mfde_fatal_cause_tile_v_get(mfde_pl);
+	if (tile_v) {
+		val = mlxsw_reg_mfde_fatal_cause_tile_index_get(mfde_pl);
+		err = devlink_fmsg_u8_pair_put(fmsg, "tile_index", val);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int
+mlxsw_core_health_fw_fatal_dump_fw_assert(const char *mfde_pl,
+					  struct devlink_fmsg *fmsg)
+{
+	u32 val, tile_v;
+	int err;
+
+	val = mlxsw_reg_mfde_fw_assert_var0_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "var0", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_fw_assert_var1_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "var1", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_fw_assert_var2_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "var2", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_fw_assert_var3_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "var3", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_fw_assert_var4_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "var4", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_fw_assert_existptr_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "existptr", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_fw_assert_callra_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "callra", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_fw_assert_oe_get(mfde_pl);
+	err = devlink_fmsg_bool_pair_put(fmsg, "old_event", val);
+	if (err)
+		return err;
+	tile_v = mlxsw_reg_mfde_fw_assert_tile_v_get(mfde_pl);
+	if (tile_v) {
+		val = mlxsw_reg_mfde_fw_assert_tile_index_get(mfde_pl);
+		err = devlink_fmsg_u8_pair_put(fmsg, "tile_index", val);
+		if (err)
+			return err;
+	}
+	val = mlxsw_reg_mfde_fw_assert_ext_synd_get(mfde_pl);
+	err = devlink_fmsg_u32_pair_put(fmsg, "ext_synd", val);
+	if (err)
+		return err;
+
+	return 0;
+}
+
 static int
 mlxsw_core_health_fw_fatal_dump_kvd_im_stop(const char *mfde_pl,
 					    struct devlink_fmsg *fmsg)
 {
 	u32 val;
+	int err;
 
+	val = mlxsw_reg_mfde_kvd_im_stop_oe_get(mfde_pl);
+	err = devlink_fmsg_bool_pair_put(fmsg, "old_event", val);
+	if (err)
+		return err;
 	val = mlxsw_reg_mfde_kvd_im_stop_pipes_mask_get(mfde_pl);
 	return devlink_fmsg_u32_pair_put(fmsg, "pipes_mask", val);
 }
@@ -1727,6 +1808,10 @@ mlxsw_core_health_fw_fatal_dump_crspace_to(const char *mfde_pl,
 
 	val = mlxsw_reg_mfde_crspace_to_log_address_get(mfde_pl);
 	err = devlink_fmsg_u32_pair_put(fmsg, "log_address", val);
+	if (err)
+		return err;
+	val = mlxsw_reg_mfde_crspace_to_oe_get(mfde_pl);
+	err = devlink_fmsg_bool_pair_put(fmsg, "old_event", val);
 	if (err)
 		return err;
 	val = mlxsw_reg_mfde_crspace_to_log_id_get(mfde_pl);
@@ -1774,6 +1859,15 @@ static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *repor
 	case MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP:
 		val_str = "KVD insertion machine stopped";
 		break;
+	case MLXSW_REG_MFDE_EVENT_ID_TEST:
+		val_str = "Test";
+		break;
+	case MLXSW_REG_MFDE_EVENT_ID_FW_ASSERT:
+		val_str = "FW assert";
+		break;
+	case MLXSW_REG_MFDE_EVENT_ID_FATAL_CAUSE:
+		val_str = "Fatal cause";
+		break;
 	default:
 		val_str = NULL;
 	}
@@ -1782,6 +1876,38 @@ static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *repor
 		if (err)
 			return err;
 	}
+
+	err = devlink_fmsg_arr_pair_nest_end(fmsg);
+	if (err)
+		return err;
+
+	err = devlink_fmsg_arr_pair_nest_start(fmsg, "severity");
+	if (err)
+		return err;
+
+	val = mlxsw_reg_mfde_severity_get(mfde_pl);
+	err = devlink_fmsg_u8_pair_put(fmsg, "id", val);
+	if (err)
+		return err;
+	switch (val) {
+	case MLXSW_REG_MFDE_SEVERITY_FATL:
+		val_str = "Fatal";
+		break;
+	case MLXSW_REG_MFDE_SEVERITY_NRML:
+		val_str = "Normal";
+		break;
+	case MLXSW_REG_MFDE_SEVERITY_INTR:
+		val_str = "Debug";
+		break;
+	default:
+		val_str = NULL;
+	}
+	if (val_str) {
+		err = devlink_fmsg_string_pair_put(fmsg, "desc", val_str);
+		if (err)
+			return err;
+	}
+
 	err = devlink_fmsg_arr_pair_nest_end(fmsg);
 	if (err)
 		return err;
@@ -1840,6 +1966,11 @@ static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *repor
 	case MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP:
 		return mlxsw_core_health_fw_fatal_dump_kvd_im_stop(mfde_pl,
 								   fmsg);
+	case MLXSW_REG_MFDE_EVENT_ID_FW_ASSERT:
+		return mlxsw_core_health_fw_fatal_dump_fw_assert(mfde_pl, fmsg);
+	case MLXSW_REG_MFDE_EVENT_ID_FATAL_CAUSE:
+		return mlxsw_core_health_fw_fatal_dump_fatal_cause(mfde_pl,
+								   fmsg);
 	}
 
 	return 0;
-- 
2.33.1

