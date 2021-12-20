Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B823747A806
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 11:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhLTK45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 05:56:57 -0500
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:1601
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229759AbhLTK44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Dec 2021 05:56:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mVxs8JC5g/QcUzqEKvrpRjW8HGsp2qDsB4YGP83d98Cm+tfeebOiCK1lkMwAXSIXm4bEQWkxkMjje8seS2ZcPOJo+Dlj0voo0s2+uE2evqkWbFXOdiSQL73FmTH1zg4Lm4XWSQmOFxNTJd1gvMaX9AwDKCgJRUv8q9F84C5yyWYhso3rRgKLwh9TBBZVd/XNYIzEHOg9UrH0e4cKhg6AC9UJZBIakhTXxhn0U3PleYDhAGkLQvT/4kJgtgmCVt75Eb6OCtaXmvGKtAL5LmXlDXWFXhVVkDXZnOpbCQDPylONMWHC0TbEQtQcz1wX6jinFB4w4812Aj8Cewauzrn2VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u/zvAlQSIorcOwNhLBkXpSAmKJd7UZi8+nq/huLiOaA=;
 b=lQhcuqNx1xc6nGrNP/m54+7w9gPbddhkrn1o9+F1uw5WqHncst0DrPcsn7VYNxIH6SjvIZ/AGqULjzm4Ad7PSf6SJT+QeqB+xTkIsRrB6hz3AL7aRlruHFWpzw8uJOh+fsXIvIXfT7cOVxAf8Vf/DWZARkFp9o6mUsTZfvMrrgaQ6LWrXAasNhxqrSOi7uLrxEuXwy4bSZTw5zn16Sm/F03WsxLmTbdg7xD2mvkDYA7+VY+SjxhoyVtNeMX+ZSoSQxl1POO9+SWUXpdgwcEWsp/U1en/6sjJlcQNrhTsO7JyasUeiDu9abpsJlgkoe8Uc1EwLGN+QIwgvQK5uac2mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u/zvAlQSIorcOwNhLBkXpSAmKJd7UZi8+nq/huLiOaA=;
 b=MRklcaHjz5J5cfdJUF7CQjTfR9YOO3x3wudFZ0ZrwFIpHTegCmtaJwQEKyMB7JX0o5nwWVv5v2kVmfq7KhJDJLSVdST6SfG+Ufpnsmy8XNoC+qVY/OqN7lteDqaDldHVnPYN1MlwXyw5EALu4ui4Sy+iHV/AwGiNITQz7C3PiePGTqJd5blKDYB6wweiGa1FbR5hpaLcm/2mMjaOOz4IcxkSqutLUYfqnEEfpwGjCpk31zyvamMab2qegYhYMM5dlwXIyGhWTdqIjs7btJ+iZhT14EAW1s/3tr4KN6lfDRdpwKX4kOD3aKd25F6ghzt6HNS07mnrKoAxCYJw+2XI1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB4757.namprd12.prod.outlook.com (2603:10b6:a03:97::32)
 by BYAPR12MB4760.namprd12.prod.outlook.com (2603:10b6:a03:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.20; Mon, 20 Dec
 2021 10:56:55 +0000
Received: from BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b]) by BYAPR12MB4757.namprd12.prod.outlook.com
 ([fe80::398b:d0f7:22f:5d2b%3]) with mapi id 15.20.4801.020; Mon, 20 Dec 2021
 10:56:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/4] mlxsw: Fix naming convention of MFDE fields
Date:   Mon, 20 Dec 2021 12:56:11 +0200
Message-Id: <20211220105614.68622-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211220105614.68622-1-idosch@nvidia.com>
References: <20211220105614.68622-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0024.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::11) To BYAPR12MB4757.namprd12.prod.outlook.com
 (2603:10b6:a03:97::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4925dd88-92e3-497f-7bab-08d9c3a76fae
X-MS-TrafficTypeDiagnostic: BYAPR12MB4760:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4760890D67564E5F136E4250B27B9@BYAPR12MB4760.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mg5jOiMBhHAiu8Gieekmzwg5ttywKdWgcsK+Xx5EIpK0mzrMMKObQPtsuqSYeGAZWWQz2+6Dgc3cSwI3LDv+mq5sTMSFoBYGu6QXvg4hOactws+wYbcgfM1sbzfItiylaaJdciSDKJVEHkPAqdFVG09QJUq7Cm84SqrZmOgHXL6+m/4aKsRvwalV++GJk8aSVvtl+XFi5Pm3eitpe9unIaCig2WFZmNmWozKzKXtUOe7aSC97gJi4NeFEuERwZWvTtIOVaeUAGvP0j1kDNryOedXD1rfOKh1DWoP18rxMkuMj9RHcDkoQePs0lXBFICM4s+7Qeo3sFRTe0bBq5l0JriNt+HlVwUTG9GqOxIubz814hudhftqoQ02HlU1+PCZOSOrztFPmau4qCVY7Fo++A7UERvQ1kDk9OPByj9MNd8uMD4UAsdyFTu7gKmKXLI55ePBnMRNYVGkrYOv5X0edSDOo16PVi2ZHcZlrYB2iS1edmpHUOrjWA4vyB2KkQW04yORoNHHkqynHpcIHjxZQT8aZYM0ZB9Z6jdaDTvIu8tkURy6IOtuzeSky0LtjWzv+cMBhmmp8cSNUKnkOQgvTgwffspyBP/yIEnv2+Rj6CjfFB5hFgl3PGkBagKnt/hdrjojY3WBOEeXcw2MN8IsA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(4326008)(8936002)(107886003)(6916009)(66946007)(26005)(316002)(86362001)(38100700002)(66556008)(66476007)(6512007)(2906002)(6666004)(508600001)(8676002)(6486002)(2616005)(83380400001)(6506007)(5660300002)(36756003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wX0DwZYfVMMTLuga+qlSTtmCXtxXMmFpR5XUdHwQWmoAGEe4CS+u3sfDpic2?=
 =?us-ascii?Q?u1qakBJJdMCYSnKja6kuCTNGW2ikZwcxbMDZd6YmWszoGzUVmc0PfWMsQtji?=
 =?us-ascii?Q?O1pCFWr4RlJEVmgSPTLaV0pHp7T4QMDRQe6iS2LQzdNiiytToo7Z+GEDK1TF?=
 =?us-ascii?Q?oi8OSJcyurpAlJZjOphhqp7X/5jwFxmH/hffqudGS4dUiztJf1HrKwt4+9ru?=
 =?us-ascii?Q?0Vj+XaogxMqhZHPgwp3ZhPuJT1D+khYfifsgVK+BVcwgLdj7LV4Nikz1Sk8X?=
 =?us-ascii?Q?JIiiHmSp0BOvcuh686Etlg0/mdtcWLPzLssdDyNeT2MXtGCmZshWUGmowa/6?=
 =?us-ascii?Q?LYDWTq6no6yG9xYBJT912O8LT7PKsjbu3J5x/NROncoODR4ghA09aLWfQwzj?=
 =?us-ascii?Q?57dOEiTBhA5tsZGbuEXiQaDVz5NTT3Gcsw+Gso/YCK6QDJbVONUa2ZzxPi+Y?=
 =?us-ascii?Q?xldTJfYThj5tC/wDyNERUED5iN/uzpRuIzP/WIFmzcOo4P8m7b20/N7i8NOm?=
 =?us-ascii?Q?mo7Mtagfp7XepzHVpZS8sfGBtil3T6fRs1+7wyVEVXG7kg8U8+SLC6JVzlgq?=
 =?us-ascii?Q?gNqAQGgpigjDdXaEmaXWrZltH5H1bYIx4xH+DLaYOiv8QtSX03cTFuNsWD8+?=
 =?us-ascii?Q?SQcFJX2flRabuiLUjM/EknWKrE5cUPMQFTEWr4spd43ZaVWsx6Tov+wdXX8G?=
 =?us-ascii?Q?8YmSMV9m9LpfyQZmb52XlL4pO/xFJpR2tn4J7t21Y/5e8Nx4FHe+HOWTW/eY?=
 =?us-ascii?Q?ccJI7Ee5gIj2SR5IP/VfkUVHajvdIn39SxbnIJyCrGTt59hnInHWeJzsEUhL?=
 =?us-ascii?Q?a6rbZ+HITM16PxxCJ26iMMZl3dIG23w9iGAmu2ReFYUe8YUUSToe7Mpsrpr4?=
 =?us-ascii?Q?RWBqBgb20LUa/JCnc+skU5hRyCu6UWxIPsNAGoDxrjmaye2gEn7UXDS/buMf?=
 =?us-ascii?Q?d/zvzjxc2guRwUCaPuRpkj9d8pzfWak0ydtEi2yxcX1NCWaLIs9C4pmWY/nD?=
 =?us-ascii?Q?FT2GEPPzO+p8Dr/X4+beNlZh8o6g4Gje+ACmF4ztFewDO/KRmN4kkyL0++y7?=
 =?us-ascii?Q?r5Q+kdy0tteiVg1t/D1LFHUjGYevznKk/9ZgHj093z11y915KKA9LQ4+h35+?=
 =?us-ascii?Q?OtyDQz8TGIcqa3q3j4G3pD3NprtClNuLzx6WZ1s972cxs1jw39v6cPIOMwFa?=
 =?us-ascii?Q?J6wSWfmyE37ZuCtJxE9WcGlVo0ON3QgR51hsec1lFJ8qEkFkx0G73I99Casx?=
 =?us-ascii?Q?yZEBAQhuvvXcA0AMwQSZhQWWUUex12e27GaR3i7PFzFkiDIU1kWq5BFFJF9r?=
 =?us-ascii?Q?O1N/roiMtVY6QwtGxtKhlRFL0G/7wFEab8x1aJ6y2nIVeBYSrrlCBT38LDCc?=
 =?us-ascii?Q?g6xRFVOlBTulh5nOFs41Sj9eq92/sbHzu8AAp+4s5WzsO1rQ+PRxxBY5FEKj?=
 =?us-ascii?Q?PuHIz3wxhdc57Z/h36U7/JwAjU24h6XUdGo+Xx85v0h2uJAz0hIfOJy9LjQM?=
 =?us-ascii?Q?1pKkhC6gITukDcPXNT/3XMvS1t1ib2RUDKHj1A/4EW7nKmVPx86YTagQa8vQ?=
 =?us-ascii?Q?sf1sX0T1qr33exPzHiKJYLfRCqw2KIpyGTCVVTRxqCAT/8gqgVxdumxgERT8?=
 =?us-ascii?Q?ce1LVvHXvmiHUMIZPhvrCS8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4925dd88-92e3-497f-7bab-08d9c3a76fae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2021 10:56:55.1858
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7pjIWt8ccuXEHxQ13bRbHWDEfgRWEbLWdG1Hg81/U/Rx8ErUZmpzwt1GbTW4XfdoWdbzOXl6VbKgo+jveRmHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4760
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, the MFDE register field names are using the convention:
reg_mfde_<NAME_OF_FIELD>, and do not consider the name of the MFDE
event.

Fix the field names so they fit the more accurate convention:
reg_mfde_<NAME_OF_EVENT>_<NAME_OF_FIELD>.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c |  8 ++++----
 drivers/net/ethernet/mellanox/mlxsw/reg.h  | 19 ++++++++-----------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 7e89d5980d5e..e1d4056f9eea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1801,20 +1801,20 @@ static int mlxsw_core_health_fw_fatal_dump(struct devlink_health_reporter *repor
 		return err;
 
 	if (event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO) {
-		val = mlxsw_reg_mfde_log_address_get(mfde_pl);
+		val = mlxsw_reg_mfde_crspace_to_log_address_get(mfde_pl);
 		err = devlink_fmsg_u32_pair_put(fmsg, "log_address", val);
 		if (err)
 			return err;
-		val = mlxsw_reg_mfde_log_id_get(mfde_pl);
+		val = mlxsw_reg_mfde_crspace_to_log_id_get(mfde_pl);
 		err = devlink_fmsg_u8_pair_put(fmsg, "log_irisc_id", val);
 		if (err)
 			return err;
-		val = mlxsw_reg_mfde_log_ip_get(mfde_pl);
+		val = mlxsw_reg_mfde_crspace_to_log_ip_get(mfde_pl);
 		err = devlink_fmsg_u64_pair_put(fmsg, "log_ip", val);
 		if (err)
 			return err;
 	} else if (event_id == MLXSW_REG_MFDE_EVENT_ID_KVD_IM_STOP) {
-		val = mlxsw_reg_mfde_pipes_mask_get(mfde_pl);
+		val = mlxsw_reg_mfde_kvd_im_stop_pipes_mask_get(mfde_pl);
 		err = devlink_fmsg_u32_pair_put(fmsg, "pipes_mask", val);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index f748b537bdab..ed0767cc71c2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -11372,32 +11372,29 @@ MLXSW_ITEM32(reg, mfde, command_type, 0x04, 24, 2);
  */
 MLXSW_ITEM32(reg, mfde, reg_attr_id, 0x04, 0, 16);
 
-/* reg_mfde_log_address
+/* reg_mfde_crspace_to_log_address
  * crspace address accessed, which resulted in timeout.
- * Valid in case event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO
  * Access: RO
  */
-MLXSW_ITEM32(reg, mfde, log_address, 0x10, 0, 32);
+MLXSW_ITEM32(reg, mfde, crspace_to_log_address, 0x10, 0, 32);
 
-/* reg_mfde_log_id
+/* reg_mfde_crspace_to_log_id
  * Which irisc triggered the timeout.
- * Valid in case event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO
  * Access: RO
  */
-MLXSW_ITEM32(reg, mfde, log_id, 0x14, 0, 4);
+MLXSW_ITEM32(reg, mfde, crspace_to_log_id, 0x14, 0, 4);
 
-/* reg_mfde_log_ip
+/* reg_mfde_crspace_to_log_ip
  * IP (instruction pointer) that triggered the timeout.
- * Valid in case event_id == MLXSW_REG_MFDE_EVENT_ID_CRSPACE_TO
  * Access: RO
  */
-MLXSW_ITEM64(reg, mfde, log_ip, 0x18, 0, 64);
+MLXSW_ITEM64(reg, mfde, crspace_to_log_ip, 0x18, 0, 64);
 
-/* reg_mfde_pipes_mask
+/* reg_mfde_kvd_im_stop_pipes_mask
  * Bit per kvh pipe.
  * Access: RO
  */
-MLXSW_ITEM32(reg, mfde, pipes_mask, 0x10, 0, 16);
+MLXSW_ITEM32(reg, mfde, kvd_im_stop_pipes_mask, 0x10, 0, 16);
 
 /* TNGCR - Tunneling NVE General Configuration Register
  * ----------------------------------------------------
-- 
2.33.1

