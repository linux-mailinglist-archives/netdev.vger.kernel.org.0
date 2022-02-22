Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3EBF4BFFF9
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbiBVRS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiBVRS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:28 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55796163D68
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:17:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nw16YTS2NSCT4ZyecFC8y9vU3MAwHOv9VJjhYyl9dn0/j3/esx+nER0NUvm42aCQmvUU8oz5SPTj6uSQTpybKs7SK6g6P0YWr0GKclxcpVGR7+K3LVHbkVZr5aVBpDYSgmSE8z1BNDyfLl/uwMfthGk7kR3ako5My9QNiey1Tq14YTfnVW3CZLDq5ln/vMBuN8XyeawJe+i+znMg9GXBIRZ6plslWEgAY/BtOSY7hSmPcOfYEDYD4qdn37PMnEPwtvtQI3F6MxQVfrtMCpWr5MmEKAIv0Ikere4z05eADnsLEaSvTanWgEvOhpjwF/qJCrQjaXegMNhQBlB/y9RW9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTW4INtH4kjhLj4AvV2RGcberBnMKO8QMQ13Q6FTTYg=;
 b=l9qgtxyoRnIOQidBuW4MozkfPKYS2Hankh/m5ybhCPAlP9yWFbgUP3brfuIazkSGuT7jDr6Ix4iLpM41niovNCiknvYBiSK68hHJ3puOKE7hW5/B3oo2zb8fxJXhX2Lt6cyZ4Ljwoe7035Z+SjFowSJf2H8eKM7CKRCCcUfJQ36Pmbp7eiIEPQ/+K94mNN9MmT4Va+hbXPuC7y1q3XSDKPn4ySDixh0R1u0pOypT22KaGGsAh+SLBIHHXD3CZpCxFn23Wns5ozNGqsHPIyBoyZ/xeNX1yzYedsrd2hCkNOwFliC8UC/H3u5ht7u663mlv7/WgZll8mG0FGk8zAMpoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTW4INtH4kjhLj4AvV2RGcberBnMKO8QMQ13Q6FTTYg=;
 b=PiJ68YzF4gatChrt/HSoiKJuQDiU4stzPqmmd3dnE9AeF2INlo0225fwqGn9e9aOlSwtkwjxzahCDcBGUyacc6cuK+MSbE3IcGp1AKk3pdu596VXsDcuXYJEx5+XAR0wFDemVcGTv8ymzBYYfG9kubgP3sIzbYjAk/OR18oyBMw5LBc5MUiY968XKZPwqbx2UCob22oKEUQj0Gh5V0jj2cfAGeHk8F7iHL90h+jYngJe9cgwA+8wjWZEK78RTiVt+aXQUwIUpWBnKMnKN1DYeHTPTPVBfBsouZpvUriROYsfdg75XRuiVss3RWv2I81W/Mmv2ZvWGKTusWhj6DaJDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 17:17:58 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:17:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/12] mlxsw: core_hwmon: Fix variable names for hwmon attributes
Date:   Tue, 22 Feb 2022 19:16:55 +0200
Message-Id: <20220222171703.499645-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0174.eurprd07.prod.outlook.com
 (2603:10a6:802:3e::22) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd9e4a24-92c4-4fdc-d550-08d9f6274534
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5214EF6EF3AB0FF01479AA50B23B9@DM4PR12MB5214.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: auiMfIQgpknQLoYrcHx9szrtuBcbDMKBBe4Z7PhFRXstNq8mLCtcKQ/azvGpvdBtPnODeMJ/1n8W0YtheEoE+CQNMz7si7CuMuC/u0I0xZyVgBV12jDT53KSR1GmoYt4RdDoN1U25e4DWWWBorcNBdqifkW3a+oz9hBDlyZ0geWlCijSGclVe6kOdatZPzVbowUf0m9AIodGWr2eBWBe0xXoIU2dJ0izh+2c6Zokr2btpMP0CWUXxseOl+vQ6xqnV4LRVw9+XXZ7dgZWpPY8vIE3DmzOt8fgK9vwtJ0ojj89wYkPrLQVrWsCnR5RlPV3OZsKYgdsISNn+pZufqal+dunLDZ00Jl+/+73Z0TnZauQDwdQ+ZsaYtywfO4B/3CDnWZEn6lZMo++wov3W+OLRJwSmukhL7Gq/NOyIA+/a1sHo02FKxcXP/vjdnEuJfMDo/y/KkruPjxfyU1cmAp3FqH8PRrBvbK5K6uaI95Qh+CAgYkBnrJcW9j8TAJOmagMq84ceegmhO2CS/2+lL/Bi8x9BtbxY/spvRaGCOYpXiou3+Lueu4eP/sVskyoWhggRyw28C9kAJoh8LTLC48OGLx057trEETTsxbE8PT70WubzqH8c52MoTvq03bq0RWxRjV+JFBC5eYBxDXoDDR0Dw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(6916009)(316002)(66556008)(107886003)(2906002)(2616005)(5660300002)(1076003)(8676002)(66476007)(6506007)(36756003)(6512007)(6486002)(508600001)(38100700002)(8936002)(66946007)(86362001)(26005)(4326008)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8wh/LPwIzopnAk22Bqbu1xjvp1RCjVZB7q7JfyamCXxVXdNkkd52s8doyQdt?=
 =?us-ascii?Q?s9z7ayBxy3nbsz129ubNpBeDPa3ul1ZlkmK6Rkdqod4gPZNyA5Bext9rqHNx?=
 =?us-ascii?Q?pEtHi7sdkYA8zKAJGKU79xliPBex5rlO3XHSBKq9Pe8cDLJ15lVN7gveKZfK?=
 =?us-ascii?Q?XFb+Fg51b58eOvSLFqLLTkWgkq6/Q6vZOH3HgpWO5sJ9VnoSnUZxPyOPsI9l?=
 =?us-ascii?Q?MwzvnuVT5fS0HwaiN3+rZzVB99fTEwIhy/zYuPsbX1eLVOE0wVsL/EoIUwyI?=
 =?us-ascii?Q?NWNWxlTEIrfu0PLZVjKjlOVwVJGe7HiRTqxIodg872IPYxXx2G8Oc8MGvC8A?=
 =?us-ascii?Q?kkYur8xaSNhB5eSt6DNiPWVvbpxYc3zW39ezIqr6RRGql11g2YjfFUYazm46?=
 =?us-ascii?Q?TVzPjWSRmRmZsYYsRiPsfVeHQVPF+qLmsucsx0wrC1CTAt6kOJd2XyT2SdbA?=
 =?us-ascii?Q?QlGT8VMLZQGGxnLclpGeqZOq4QhxEdHt6fBKFxCKsJIwo2Po7lRI+H/HLaKn?=
 =?us-ascii?Q?4nggyzv947oWsILJTV1ncScJ8H+uIZd8n+jrnVgxXh7R08tWMbxnBzr/+6it?=
 =?us-ascii?Q?BhjoqNI6j4q+HFQtcpqSTEnSxmn1H4QaG2ULVapDoQu3Y1M5HzLTblBuX0a4?=
 =?us-ascii?Q?GXLsbMklQdlbYmneDvh7DX6BFOx1xwqmL2RaWRuRqQOZoacLiGao5ebt4X4T?=
 =?us-ascii?Q?FmMOW0j6+D5wFYbRqrApOjC82X5oboD93rB3c0Ie9hcg5CqcXPWKjkdpdATz?=
 =?us-ascii?Q?hyzttR/JEXdrAv85LZmKMGztSG7PU3BijwHMjZLcGWaV2L+HoPdVfBrc0D+K?=
 =?us-ascii?Q?TmPXTekCUeCPe2maURpSRjp2OmpyEUvV4EHzE5VCcAXwFsxQylNfKZyWj4LR?=
 =?us-ascii?Q?ag5lbfysh/tsPJV18AD1veOginaVEHZX5/GaU/azhl9qJ84X41Mx3zHVPQ2e?=
 =?us-ascii?Q?QpEIB2zu+Rftflicr1ynalo/+DPY3WfCcRZYw6VQkzDjDJPoUAkEZGGe7TYq?=
 =?us-ascii?Q?Hrn8wZZ3eJrob5JhC1tdeSCN21MmXNFqL2Ih1XSQ5OMNpRVUNxX/vVgK5QkV?=
 =?us-ascii?Q?SwHR3y2mkhbSUWy7l23dBxhN/sEFbEDSvNMjncZuN02YitjfO1DKUIWxw9Ga?=
 =?us-ascii?Q?kxHxQ2+dg76dXofCWmxE6HLNZ2FD+AHALoG3HPa8MPP7ZlJQ68gpEZaNxq0Q?=
 =?us-ascii?Q?SB4k5ULo8ApKwW0SXBkyWIr5a7+V4mYxwr1FTV/MNVIyeNX1tJ4D/aJO5JzY?=
 =?us-ascii?Q?mk8CRMaQJjanxgsIb3ObzSzqZ0oEjvpW+9oyPdg06UTpBZI1EMMnpQJksG4I?=
 =?us-ascii?Q?pnLqFsI8lG2+Icl7V8ZuS/ldM9z+fWG8owb4l8QqqqvC0VD66oQUxyEwZL4/?=
 =?us-ascii?Q?msndnNQn0la3s7o/WyiFOtz8Xc8LF5CtAJtUZYOhW8Ru60nbXAfAKhX9IvqR?=
 =?us-ascii?Q?7FvqsWWCYh6ZdNtjluCM9wNx7eANfCjZ9M1Wdo6UJWgKh3sKpvCQrEF1TGZM?=
 =?us-ascii?Q?gSI+aeUsOmmGSey6GM4hmO1D/lxFYZ9wUdGnNqxMaIxQNTSMivmYSmGqtqHb?=
 =?us-ascii?Q?HpwNjXARC9bXN6vu1ZFEZI7EZbOOn66lbwom2jW1XKC0xMioaxr3+2WR/UWp?=
 =?us-ascii?Q?p15HgzLu0meW6Rit4JdRrcY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9e4a24-92c4-4fdc-d550-08d9f6274534
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:17:58.1444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k1cCwvIVwj6DyA3T30Iy4n2FaQJSAUarJuOoTekz3xEdref/TRAV9ttTRcLitSsessOfet1HFP0XCadICjjIjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
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

Replace all local variables 'mlwsw_hwmon_attr' by 'mlxsw_hwmon_attr'.
All variable prefixes should start with 'mlxsw' according to the naming
convention, so 'mlwsw' is changed to 'mlxsw'.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 76 +++++++++----------
 1 file changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index d41afdfbd085..3788d02b5244 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -57,14 +57,14 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int temp, index;
 	int err;
 
-	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
+	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon->module_sensor_max);
 	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
@@ -80,14 +80,14 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	int temp_max, index;
 	int err;
 
-	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
+	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon->module_sensor_max);
 	mlxsw_reg_mtmp_pack(mtmp_pl, index, false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
@@ -103,9 +103,9 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t len)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
 	unsigned long val;
 	int index;
@@ -117,7 +117,7 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 	if (val != 1)
 		return -EINVAL;
 
-	index = mlxsw_hwmon_get_attr_index(mlwsw_hwmon_attr->type_index,
+	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon->module_sensor_max);
 
 	mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, index);
@@ -138,13 +138,13 @@ static ssize_t mlxsw_hwmon_fan_rpm_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mfsm_pl[MLXSW_REG_MFSM_LEN];
 	int err;
 
-	mlxsw_reg_mfsm_pack(mfsm_pl, mlwsw_hwmon_attr->type_index);
+	mlxsw_reg_mfsm_pack(mfsm_pl, mlxsw_hwmon_attr->type_index);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mfsm), mfsm_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query fan\n");
@@ -157,9 +157,9 @@ static ssize_t mlxsw_hwmon_fan_fault_show(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char fore_pl[MLXSW_REG_FORE_LEN];
 	bool fault;
 	int err;
@@ -169,7 +169,7 @@ static ssize_t mlxsw_hwmon_fan_fault_show(struct device *dev,
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query fan\n");
 		return err;
 	}
-	mlxsw_reg_fore_unpack(fore_pl, mlwsw_hwmon_attr->type_index, &fault);
+	mlxsw_reg_fore_unpack(fore_pl, mlxsw_hwmon_attr->type_index, &fault);
 
 	return sprintf(buf, "%u\n", fault);
 }
@@ -178,13 +178,13 @@ static ssize_t mlxsw_hwmon_pwm_show(struct device *dev,
 				    struct device_attribute *attr,
 				    char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mfsc_pl[MLXSW_REG_MFSC_LEN];
 	int err;
 
-	mlxsw_reg_mfsc_pack(mfsc_pl, mlwsw_hwmon_attr->type_index, 0);
+	mlxsw_reg_mfsc_pack(mfsc_pl, mlxsw_hwmon_attr->type_index, 0);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mfsc), mfsc_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query PWM\n");
@@ -198,9 +198,9 @@ static ssize_t mlxsw_hwmon_pwm_store(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t len)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mfsc_pl[MLXSW_REG_MFSC_LEN];
 	unsigned long val;
 	int err;
@@ -211,7 +211,7 @@ static ssize_t mlxsw_hwmon_pwm_store(struct device *dev,
 	if (val > 255)
 		return -EINVAL;
 
-	mlxsw_reg_mfsc_pack(mfsc_pl, mlwsw_hwmon_attr->type_index, val);
+	mlxsw_reg_mfsc_pack(mfsc_pl, mlxsw_hwmon_attr->type_index, val);
 	err = mlxsw_reg_write(mlxsw_hwmon->core, MLXSW_REG(mfsc), mfsc_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to write PWM\n");
@@ -224,14 +224,14 @@ static int mlxsw_hwmon_module_temp_get(struct device *dev,
 				       struct device_attribute *attr,
 				       int *p_temp)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mtmp_pl[MLXSW_REG_MTMP_LEN];
 	u8 module;
 	int err;
 
-	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
 	mlxsw_reg_mtmp_pack(mtmp_pl, MLXSW_REG_MTMP_MODULE_INDEX_MIN + module,
 			    false, false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
@@ -261,15 +261,15 @@ static ssize_t mlxsw_hwmon_module_temp_fault_show(struct device *dev,
 						  struct device_attribute *attr,
 						  char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	char mtbr_pl[MLXSW_REG_MTBR_LEN] = {0};
 	u8 module, fault;
 	u16 temp;
 	int err;
 
-	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
 	mlxsw_reg_mtbr_pack(mtbr_pl, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
 			    1);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtbr), mtbr_pl);
@@ -303,13 +303,13 @@ static int mlxsw_hwmon_module_temp_critical_get(struct device *dev,
 						struct device_attribute *attr,
 						int *p_temp)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	u8 module;
 	int err;
 
-	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
 	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, module,
 						   SFP_TEMP_HIGH_WARN, p_temp);
 	if (err) {
@@ -337,13 +337,13 @@ static int mlxsw_hwmon_module_temp_emergency_get(struct device *dev,
 						 struct device_attribute *attr,
 						 int *p_temp)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
 	u8 module;
 	int err;
 
-	module = mlwsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
+	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon->sensor_count;
 	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, module,
 						   SFP_TEMP_HIGH_ALARM, p_temp);
 	if (err) {
@@ -373,11 +373,11 @@ mlxsw_hwmon_module_temp_label_show(struct device *dev,
 				   struct device_attribute *attr,
 				   char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
 
 	return sprintf(buf, "front panel %03u\n",
-		       mlwsw_hwmon_attr->type_index);
+		       mlxsw_hwmon_attr->type_index);
 }
 
 static ssize_t
@@ -385,10 +385,10 @@ mlxsw_hwmon_gbox_temp_label_show(struct device *dev,
 				 struct device_attribute *attr,
 				 char *buf)
 {
-	struct mlxsw_hwmon_attr *mlwsw_hwmon_attr =
+	struct mlxsw_hwmon_attr *mlxsw_hwmon_attr =
 			container_of(attr, struct mlxsw_hwmon_attr, dev_attr);
-	struct mlxsw_hwmon *mlxsw_hwmon = mlwsw_hwmon_attr->hwmon;
-	int index = mlwsw_hwmon_attr->type_index -
+	struct mlxsw_hwmon *mlxsw_hwmon = mlxsw_hwmon_attr->hwmon;
+	int index = mlxsw_hwmon_attr->type_index -
 		    mlxsw_hwmon->module_sensor_max + 1;
 
 	return sprintf(buf, "gearbox %03u\n", index);
-- 
2.33.1

