Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF854FBF82
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347460AbiDKOuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244701AbiDKOt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:49:56 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2060.outbound.protection.outlook.com [40.107.236.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401EB21E2D
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:47:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONZRTJ2f7W3YaocoG2hfkAb2gLz6I8g/CNc3ycscYcXiqy8Cgq+OKAH/+tcjnvxl1FZgkPmvxnkJ3+zDZPv3YPo01/Ae1QntYanucR7GtbDVTo54rCnkYA8RAnNkTUzyiAeL0YM/lkFGavxGxxluCQimMal0KIF3kKTtFWA1IUpytINtJI6oAuj2ccQkHnFw4Kh0fnuclgHJHOdKMwpFvib6+6ILyDhwW9ksP9De7lM9R39l9QRaH0JONruNHNppZqtMIzdbejtLes3mPe9ATD4zF8k14PROborCPSRmttxFOXIMiGUJbjLo8LpVi2bjJQVArLAVE8o+4WqzrS/RJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2t5MfWKzcdtLfFvM9kL9EJiEe7n7F8MNzFoZiC4vBXo=;
 b=l3NAZFd4B/koDnk+eK83R81emKQn4hJaSAThxHisfZTQy0/QZgwK4/ibl+FX5h1TArH+O8/7gwAjy9sN9OuwnHw4YnnplynIshyEHpVno76hNqVtBN3qrB1YFL4NoDHaT21TuQNvVAY/cRFpBEPVA7SaXm90BbzHpR6JSX98JVr6cLdE3fWfmoMkfzhIu8Bv3yLH6yhw9vvEoho1629E4XI8LjN68/zZmDblFyHL63a8OOvjBYjczI5X1bKsU/tXOw/ga27OcCQjfPkTKJn/pmf071VrcXOhzlIi1WIKYgsXBui+ewnpbENDptnw34s8d6i3utbDP7ZFDN/DImKNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2t5MfWKzcdtLfFvM9kL9EJiEe7n7F8MNzFoZiC4vBXo=;
 b=WgAlymLo1fQBK3jzdrjSsbH1amprwLhzWIy88WmFM1ut01n5csRZR+Z4Rpi3AeohiD95PoG7+InB22QJNC6yQL7eehXtKTGwBPDPp8w/RaX2iRiW3sO6qh8vsk6sb9Fqzl8HK4pCW5+6X3wSVjFjPR6/Mwm5U4/hubWAucjff8PRmInhuRI1HNyTiBkRQweDsuMsFGTVjU38JhasuPJ8H7NbFI1iMMY3sC38Ui5qQOxbUjwWHjhYoFxa5WSHPyDVC3oWeXVKXftb6H6GfLqkyOmwKn2KdITdVTaRvqRrl5166FkWuEhc9Se9gfXPXF/RI/0w6Xwbu7uCw0nW7zTPpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1430.namprd12.prod.outlook.com (2603:10b6:903:3e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:47:40 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:47:40 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/8] mlxsw: reg: Extend MTBR register with new slot number field
Date:   Mon, 11 Apr 2022 17:46:51 +0300
Message-Id: <20220411144657.2655752-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0358.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::34) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6bab2b0d-cca2-4ee4-98a4-08da1bca3a5c
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1430D128408F509D9397B41EB2EA9@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjEnFTxegh0jipGFyTbFNJjt+oB2tE+Fb0idAFysLAszj11nodnZNY+nG/fW6FwdyJSXP4h4MKtowfm3Ul2wAys4fWLJqOIp+1NNyn6w/7O+2j7d71IKNbdcmsJSq9tr2MhJsZgBbUgXlIU/7yRcUMxC5lcR88SfWa8mGteRY7jFnAlsY1PMGOysTsAD+f53/YMyl7rOPt+L4A28TTmtdV27u80G+6T476oMTVbUqcdwkLqEsKqMfbgCtzurNquQVZEYYo4oWMFG/Kpnd9VPEl/5pLgjcpxeROK5hQAiLwYf/hl7XV2CpNR39+LCd8ATcVPLROAn50W7tKjuFuaMB7+Lne4y69oPyc+XdW680GpqN1L8HipU2loYzOh0ASiW2B52zvxvz3ceRjNSQR6H5rswwbTg54bEC0YCA680Wexsiv9DAxW9x7HfekIl0+nrsb0vXfbqD5kjU9e5FMT6dzLD7dFXa+Auull3+cYGep1gH9gf7qOX+7CyXjJaOagL0KCXmYtpc+cqSYOaZMmdC3TOok7CtoX4Ao/Thp56em1GAAoNO6A+p7BZwZKXM7NmFJ+YwVVm+AhNRDkgzk0koguKm0EdLI4VcrEXaLh0q6rdtt84bG4No/xTOn9MJWdEWkrfijr0kSt8AuXGrUy19w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(66946007)(66556008)(6486002)(66476007)(107886003)(6512007)(2616005)(1076003)(186003)(26005)(6506007)(6666004)(36756003)(38100700002)(2906002)(83380400001)(86362001)(4326008)(8676002)(6916009)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tPoKdcov8rhIYM4oy0SD6bwZQWc42zTqIceOC0gyTReL91pXzedCe0Nc7m/k?=
 =?us-ascii?Q?xdy1md/6r1ny1HEzHdDkk/G/z5/XvTPrTHAkpOcub2EssIX/KQwTQy8RLU5K?=
 =?us-ascii?Q?llNPdgrUndp4csepj/eK1eLcK2rTo0LH+rzNlj1ATQ/bWkOcnrOSghuhzYoz?=
 =?us-ascii?Q?kCg3x1DuFMTAe83UfTlYbw7lcBS4aN5Fmx9DvdiQqaLrqAxWs4d9YRaSpkNO?=
 =?us-ascii?Q?i6Ra+BwQdRCgnoSQKFI+pOf0M4uHvhhUm+V6RupVbM0rc4b1Eyl2Rm1ykeg/?=
 =?us-ascii?Q?MXtJDDR++RhbsJW3mC9U29h8WGrQwVOFn4AzY1njd8syHM3jf2jvMSNZYmOj?=
 =?us-ascii?Q?Omvpm0ZBwPyUvVsKlIK8jncM+7XLkZe8+hAbdegIHGc1wa9yZIv2sutJS72r?=
 =?us-ascii?Q?lC0183D/DHBWeTC57Xx0mUSz0fQ6ParKa4K1jijbVOF9Kgjzoz/uQ3trPDM8?=
 =?us-ascii?Q?/Pi7tfEMLET4dPjoBZUbO37jfIrtekIJsOPL4HkrSBYFwDRB6e6TCX0T/aSr?=
 =?us-ascii?Q?UwIdE9cgBmuVP/D0XE7Ra3rrQyZ2ZFOVQrMhAFp+2ms7y3PqY9nPZW4rsEvK?=
 =?us-ascii?Q?/WWg5noa1Vqe5m+U0fnmiMmBVRnIfSiQuKxoxquZL9CfmlS9B/Ek+93hegeg?=
 =?us-ascii?Q?avXcmZ8lCI6vCWR6YXNRqeZ8/ssHPvTkA4vYq83u36hSpm8kjh70M9a8ayW1?=
 =?us-ascii?Q?FsJxgyYypbG/wWzFIVi60VmkpjZOdZT7qVOHgx/sw11BltwkGyiVHp8TLwYN?=
 =?us-ascii?Q?y7iHLNyMbLfKmEUKWfrKSrytwyf5Q+rpKEb1cNmypUGOvNR//XWhrnURYLaM?=
 =?us-ascii?Q?OShpczsd97V4hRemkbQwFx6wF+HsoPoAWTMxzCox+NwLwjD+h/RuVCaWHMDy?=
 =?us-ascii?Q?okbylL4IA1QOCd0HJfgQbjhtr/wUMd6BIOphLWOvCe92URLGg735LGA/Lfrv?=
 =?us-ascii?Q?TfVAvNerRuwkxTlfJVywDLTnbriR0ZlMIpVteDpUTgD0LR25jcqHrRp/C8O1?=
 =?us-ascii?Q?Vrun5m4yMfru57zL5BI/5QnVesa/dklCaHgUkieYAdDf3tNIhtRfCMDK0OrR?=
 =?us-ascii?Q?OqXi+4QAJbchPT9Ee7ltTM9LEkEPLi9bIK8iBOo9HOIsjEzYXXQEi7BROlXE?=
 =?us-ascii?Q?IweqWFW/dJQFD8kj5hP4n8J7mODyZEwcZ1BrkwpZXm5VAEZhU7YidvadNENT?=
 =?us-ascii?Q?zdaeRGtIS4FzMweZDFv4a2FqC2b/+d8C1zH2hh2y3TmxXPrNHP7+KuPYS4iu?=
 =?us-ascii?Q?+u8QHa/mpmF0+TWOGZO56/qfbzi+6zRNoCeXeStbTeZTxPEZQ3rg+JbzmEw4?=
 =?us-ascii?Q?oTOOeseNhqYUvZ8kzslo8NkvAeSEr48tGcsAWAJoFKm53ykluN+qnU2KkiSW?=
 =?us-ascii?Q?/CJ9qCiis92Zhh51xaP6tplAGTsKn12p7dHvkBdxL5sRdcqmhhLFIKMt8/Aj?=
 =?us-ascii?Q?CvI74L+lyaZO6RMUYryWAQaj8gky516D35AGelppbWGTxqDJEGJZZRdMxcNA?=
 =?us-ascii?Q?7o97DvezUS3wXE8o4hE5GMN76tv2fM7z+TSgdHEMgMTBVKKtL4t7ORc1+jTw?=
 =?us-ascii?Q?M2fEz9gHflHt2NfO0gGswPitC+pFpgu3JBRFlwV1/fzjlgzIuCjQfZPvmenT?=
 =?us-ascii?Q?QyPpow+fdmfYS2SNbtz9gnrFMdARqLMyj55dNtLLHlOwNJy62yPX6YIhbN7g?=
 =?us-ascii?Q?43U2SIw2czvPN5wEk/8dtAd4ZZUQ+Oy0ZfLXA4Wfu969M9zsZJ7Jzp3wHSqw?=
 =?us-ascii?Q?KP6GpKZWmA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bab2b0d-cca2-4ee4-98a4-08da1bca3a5c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:47:40.3930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w3d8Mer6QIWdWxKPc37gaRi9YOlRROwRkikrKr14Fy0uj0boO0YB5TiXhgVXSfGlFj6vSZ0L4vOPf0TAo4gyLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Extend MTBR (Management Temperature Bulk Register) with new field
specifying the slot number. The purpose of this field is to support
access to MTBR register for reading temperature sensors on modular
system. For non-modular systems the 'sensor_index' uniquely identifies
the cage sensors. For modular systems the sensors are identified by two
indexes:
- 'slot_index', specifying the slot number, where line card is located;
- 'sensor_index', specifying cage sensor within the line card.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c   |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c |  4 ++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h        | 11 +++++++++--
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 3103fef43955..0c1306db7315 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -660,8 +660,8 @@ static int mlxsw_env_module_has_temp_sensor(struct mlxsw_core *mlxsw_core,
 	u16 temp;
 	int err;
 
-	mlxsw_reg_mtbr_pack(mtbr_pl, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
-			    1);
+	mlxsw_reg_mtbr_pack(mtbr_pl, 0,
+			    MLXSW_REG_MTBR_BASE_MODULE_INDEX + module, 1);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mtbr), mtbr_pl);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 71ca3b561e62..f4bc711a16cf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -271,8 +271,8 @@ static ssize_t mlxsw_hwmon_module_temp_fault_show(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
-	mlxsw_reg_mtbr_pack(mtbr_pl, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
-			    1);
+	mlxsw_reg_mtbr_pack(mtbr_pl, 0,
+			    MLXSW_REG_MTBR_BASE_MODULE_INDEX + module, 1);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtbr), mtbr_pl);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature sensor\n");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5de77d6e08ba..958df69cccb5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9887,6 +9887,12 @@ MLXSW_ITEM_BIT_ARRAY(reg, mtwe, sensor_warning, 0x0, 0x10, 1);
 
 MLXSW_REG_DEFINE(mtbr, MLXSW_REG_MTBR_ID, MLXSW_REG_MTBR_LEN);
 
+/* reg_mtbr_slot_index
+ * Slot index (0: Main board).
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mtbr, slot_index, 0x00, 16, 4);
+
 /* reg_mtbr_base_sensor_index
  * Base sensors index to access (0 - ASIC sensor, 1-63 - ambient sensors,
  * 64-127 are mapped to the SFP+/QSFP modules sequentially).
@@ -9919,10 +9925,11 @@ MLXSW_ITEM32_INDEXED(reg, mtbr, rec_max_temp, MLXSW_REG_MTBR_BASE_LEN, 16,
 MLXSW_ITEM32_INDEXED(reg, mtbr, rec_temp, MLXSW_REG_MTBR_BASE_LEN, 0, 16,
 		     MLXSW_REG_MTBR_REC_LEN, 0x00, false);
 
-static inline void mlxsw_reg_mtbr_pack(char *payload, u16 base_sensor_index,
-				       u8 num_rec)
+static inline void mlxsw_reg_mtbr_pack(char *payload, u8 slot_index,
+				       u16 base_sensor_index, u8 num_rec)
 {
 	MLXSW_REG_ZERO(mtbr, payload);
+	mlxsw_reg_mtbr_slot_index_set(payload, slot_index);
 	mlxsw_reg_mtbr_base_sensor_index_set(payload, base_sensor_index);
 	mlxsw_reg_mtbr_num_rec_set(payload, num_rec);
 }
-- 
2.33.1

