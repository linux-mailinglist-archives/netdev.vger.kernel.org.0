Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588354FF9DA
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 17:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236312AbiDMPVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 11:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234843AbiDMPVG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 11:21:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694D52E0BA
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 08:18:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y/tw6kXden7B0nTAcDJgGTBPTaZgQN6ZLQr04IJiDo3llWCNOLxUgRI9N9VFqAinYepq8nQe+reK7+4SMXUVlwR1/6vtQMeE3LxHdSUAKcq4nCG6flD4J2dPBfdM8lb99VKI9zb1sYxtM5zN1lbqx4/GfP/FPy/NQjPCtQRWE0q49F5EtDBmDv+JgM6Y9KBt5s2YmUOKYcTiy3DJuZK1Y5dHy+7oMns6srQgjgAI64M3foz79mnZC6xR9NbzO7TCk0EtlhNd/xigIvvs550RT6QzAoRjdD2iL2pcewRybhn27ZLXLN9o5pkkiByA8ytEvlJ9Mat+uAq0SQFEE0OOvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4hZ/ymCJss9L5uLxpzJW36xJQXg3386X7Olz/KXUPkk=;
 b=B5NmGUron9Omn3p5wQHxJR0vyyaBrYojqS4E3iMJV6HR18nbtp6lpaKB7j/JPylg52I0xMdwOtfq4SNAu7ZTlpiBjl2GoOku10qx/9mFRptva1SCMOwuAYcMaM1toKF4jVj283z4oVzhzFJ+/LqHZSVG170Pdtq+92En3EXGglQvtX9jX+4FTM8ZvKlges0kJjhlpyDg/L8l0oIasXTGIuTfwG4/cwrDD5vBzFTnL9YYdJy+4vmOlrI+4B32e2nELrib8TwiireN5SPbwq0DVTWmcSU7sO5D/z+eeNF1v8Qh+Z38+RJbQAdYyqFrBUZjj3xEGNj6p0WLfdnltHOj8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4hZ/ymCJss9L5uLxpzJW36xJQXg3386X7Olz/KXUPkk=;
 b=EPWtkXOCmkTDloAlXcKTHG2F98+Ap57rbTzciNAh6azgSnDnhbll8gcP3z/Ym1roBUo0rlpZ50Qxw/dzZIHX2+sKv+GaFKlx8e+Ukl7kdDKhCrrD8Lb1nqeBqDrMVyEv5guu0qRHgzHCjTPJvyIl1U6nixeLdHoEIaIkhlI4I9QtwRODt6Cvi26Wo61Ymb/zAt5bYlyQOktGxChtrrze2RvFd3ccRNWpTNpWTvSpx9WeTb/7t7hj3KQ67vdqiHnPs6zOIAhtWaOljtDj/AR8oloCtX0wcZx3EmLivn+jQNjOjd5as8zq3qedDRryxIZGfKuapNsoW+UnLKrzFjWdWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by MN2PR12MB3885.namprd12.prod.outlook.com (2603:10b6:208:16c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 15:18:41 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Wed, 13 Apr 2022
 15:18:41 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, vadimp@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/9] mlxsw: core_hwmon: Introduce slot parameter in hwmon interfaces
Date:   Wed, 13 Apr 2022 18:17:29 +0300
Message-Id: <20220413151733.2738867-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220413151733.2738867-1-idosch@nvidia.com>
References: <20220413151733.2738867-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0066.eurprd04.prod.outlook.com
 (2603:10a6:802:2::37) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 26c649a3-327f-4460-d0d5-08da1d60e489
X-MS-TrafficTypeDiagnostic: MN2PR12MB3885:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB3885EACA31C64792E9FEEE32B2EC9@MN2PR12MB3885.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VV6Dnq3kaaqpgrFgf/BF7haqf/iHAk/brFJniONElPZXYVa8p72fIHn70z2NBB+VnrvoxH1KyKNy6KUewQCent24nfJel00QwHptM2JmazvQ0HzrDPxT06J+v+lkAsokHm0ui7huN43SnMDuErZbo1354R469G2/jzCKWSL4zu6LGjCll8jorjwmhjivOFpcW0ppK0y3iBnubK0U8JOj2rIs8oBH85ygXZLP6TY88CM+JRKnfvZU1noBThS8LUWYCcXE/toldOJHMieTZU2Bp3Sot84uySbjswS/je+TRAz3oYYNjNuwz2HSNGn94etRAXO4koCOqFUZN0oLiF4yKRwWpC4r4HtL/5kITOYcFwl3F0l1UkxiIZsCobOjSfKhFG4oUkYwX+D3ti/3InK9nFD3CxOabTmHsJVAjjpSlyXiwnlNK3ZUzCNfgU49li0hMc0Fgo19lohYrz+1NQuLQ1wIWHgzCc5Jib0/IJpgGlk34LGMxquaT8cmvjacds4mG9xUKVLGpcl8cTK/oVLrAX7opqJOKCorOq6mPir+/NQdFVkFvwDsMl36RjaTVDaE5P2NAk8cbxzQMB8jhPoRaBEvkfYR0WSz7ilI+g6r3mme9KdBO+os7SH380dbMLUqIE5l9M2G4U7rmbBOVGKU+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(66556008)(66946007)(36756003)(2906002)(316002)(6916009)(4326008)(8676002)(83380400001)(86362001)(508600001)(38100700002)(5660300002)(8936002)(26005)(6506007)(186003)(6666004)(2616005)(107886003)(6512007)(1076003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+HT98XlJwLte6STIzU8nXVPFIKrpHxSKAKj+5kh2z/egZXOX8eWXo/3Bigw6?=
 =?us-ascii?Q?sMWUeflGmlkQpa/pSFOBlX/N0kgYchKucVsEc2P1MN0P9r9UgQhnjGhjMQ70?=
 =?us-ascii?Q?gNQ7qRkDCNpy+sYOFfBxAyytnAALyhVJRwAy0hfwCgSiLA7+oBJEON/dEqDL?=
 =?us-ascii?Q?AQZATN8FFDcdMN44PDLI+sPdj1d6td18WWVbRYIBUXWiJhSfUbllIIrStwDX?=
 =?us-ascii?Q?lcWb7u0CA7qfpJ86iAPt+oPl3WQz8sGpx6RGDTLuMK93kDcSWuPEBqKH8Axt?=
 =?us-ascii?Q?OvUHA6pEZVw8ZaTlvMx3HzbWy9rzkzVtNVsuGXk6mSQ/j7YXaBDE36tC9m5f?=
 =?us-ascii?Q?/iyudG/AzhhAnTMBcD1teF1sSYI8ZmBLjSkaISa//ynD6yodWl5bZLjtDXFq?=
 =?us-ascii?Q?1Gfmj0G9NgjwaK55WHvGPqaxd0J1mRb0JkXus7RbGx4jaXHylM1hdfsP4WYq?=
 =?us-ascii?Q?lZkkM5Ui6v4TxjU8vNTw63NJrHc1TmfaWeZyO1Hd6mCG9UVfWdyt6LKSZWBn?=
 =?us-ascii?Q?g4zy1sb/XlnetJBvxsgZthTOHlMPV1tqlWb/r6mtX080UAf9WD9CjlyWT+Hi?=
 =?us-ascii?Q?pnpjEtGzTosXLpjB78bD++82kzOaatQvNvAV6usKZOi6xUaKiIccLgNkgFiE?=
 =?us-ascii?Q?9p4T+kI6EnMDWfDZKgVW4sx+lfJPACusWIHwmCesZeUYeqdtT162v3qkciNj?=
 =?us-ascii?Q?IgIY9BrnUJpPFVwTVsAvquab114rQsYCl1H7gY6HAJ0REo4bMyWrC92KIXre?=
 =?us-ascii?Q?m5fwdxg62UYQ0kT3nBIdiEpii0bBdY6lithGOJR8mMSXZnpwnxwL5LlIfEgj?=
 =?us-ascii?Q?MxMCh/TDukHbg2FCSW69H2bOI3f5llA/GZS5cGmJVo4Q33NZK8SrW67AHR+g?=
 =?us-ascii?Q?kPsIjIUdXVM4QY440c3SvXXo7HUd85SASLYfmPQRrJ6YAmBYWP527806+ukH?=
 =?us-ascii?Q?U2beuZlRD+/2KdO+1TlIzwHeMt59vLsk4kzW9MCDPFj7Kf0DJiifFjRo3XCV?=
 =?us-ascii?Q?Q3eNigbzTYXpZXujePyZpCzH6oyRd/1VpcsMYJR4B8gUKkUZTP6GaZJTs+Jt?=
 =?us-ascii?Q?McSqVEkN14zgZ0sZWrHnZrS3LiqzgkVZWQDGTK9nyve+KRRx2JHMwNilKLTo?=
 =?us-ascii?Q?41d7QFAoQc8ePnJUTGPwIMVmisiGDHbV4I9dUXmwFmEq1OYYM/ag7FLkieMi?=
 =?us-ascii?Q?QGKjwBi6gw4wOL0B2mO77R3F4eJxPFtbekH9GEC8qfKMzQ1ymgjcPLQ9r89d?=
 =?us-ascii?Q?AHqZOyMT8RtfkyNAMH5+0EUsGmH/BKETuwSc4io4TWd1Jrty/VIly/Ll3EYT?=
 =?us-ascii?Q?dbtQ0d2mYqND/k3DKSbEDp8nKGCmTO3oYQXcQrGEXk644feaNm9Ic+ATI8qx?=
 =?us-ascii?Q?Ago5xaWyjStpbBTfqF9MF1uWumJostS/UwP1r/En29wRi7iCaVSOOMOFvvrX?=
 =?us-ascii?Q?x08wSCNeH1xP4UqmWCJxVVz+tjflIhKjQgWL3xr2db7rBabzYAqfyKiI5/Ut?=
 =?us-ascii?Q?y2BzZQDvkPHCSMfsSafJ0CrFr4WelqorjhicML7vyS/OMYSPwNfqMPc9c0xx?=
 =?us-ascii?Q?PbQDVKjAb6ycAcdJYVGOqixAM3unmOHDbB8OQAqPW4vIZS9z1g3Pq/w32avx?=
 =?us-ascii?Q?NWkbEockovxYhT4NZiAFVfseFmxV02RNfWoA6rX7uzUqw4rsncbinUrd7o+L?=
 =?us-ascii?Q?tl8y7Jg5mitPcouVgAV3abX9+jtSGKksllMbBRhkdmBTXE8GSLlF6C6pwyaQ?=
 =?us-ascii?Q?wDLnb63EWQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 26c649a3-327f-4460-d0d5-08da1d60e489
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 15:18:41.6680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jRp4z7I8LyAW3yPtVzauQfScOaFXUkRDF5tuqxR7Mt9l2xvVzN+BY9ad/W6sNNmfHGUlZ5IkKSovpR/EQW1DtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3885
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

Add 'slot' parameter to 'mlxsw_hwmon_dev' structure. Use this parameter
in mlxsw_reg_mtmp_pack(), mlxsw_reg_mtbr_pack(), mlxsw_reg_mgpir_pack()
and mlxsw_reg_mtmp_slot_index_set() routines.
For main board it'll always be zero, for line cards it'll be set to
the physical slot number in modular systems.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  | 30 ++++++++++++-------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index d35aa135beed..fff6f248d6f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -50,6 +50,7 @@ struct mlxsw_hwmon_dev {
 	unsigned int attrs_count;
 	u8 sensor_count;
 	u8 module_sensor_max;
+	u8 slot_index;
 };
 
 struct mlxsw_hwmon {
@@ -72,7 +73,8 @@ static ssize_t mlxsw_hwmon_temp_show(struct device *dev,
 
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon_dev->module_sensor_max);
-	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, mlxsw_hwmon_dev->slot_index, index, false,
+			    false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
@@ -96,7 +98,8 @@ static ssize_t mlxsw_hwmon_temp_max_show(struct device *dev,
 
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon_dev->module_sensor_max);
-	mlxsw_reg_mtmp_pack(mtmp_pl, 0, index, false, false);
+	mlxsw_reg_mtmp_pack(mtmp_pl, mlxsw_hwmon_dev->slot_index, index, false,
+			    false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err) {
 		dev_err(mlxsw_hwmon->bus_info->dev, "Failed to query temp sensor\n");
@@ -128,6 +131,7 @@ static ssize_t mlxsw_hwmon_temp_rst_store(struct device *dev,
 	index = mlxsw_hwmon_get_attr_index(mlxsw_hwmon_attr->type_index,
 					   mlxsw_hwmon_dev->module_sensor_max);
 
+	mlxsw_reg_mtmp_slot_index_set(mtmp_pl, mlxsw_hwmon_dev->slot_index);
 	mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, index);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
 	if (err)
@@ -245,7 +249,7 @@ static int mlxsw_hwmon_module_temp_get(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
-	mlxsw_reg_mtmp_pack(mtmp_pl, 0,
+	mlxsw_reg_mtmp_pack(mtmp_pl, mlxsw_hwmon_dev->slot_index,
 			    MLXSW_REG_MTMP_MODULE_INDEX_MIN + module, false,
 			    false);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp), mtmp_pl);
@@ -285,8 +289,8 @@ static ssize_t mlxsw_hwmon_module_temp_fault_show(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
-	mlxsw_reg_mtbr_pack(mtbr_pl, 0, MLXSW_REG_MTBR_BASE_MODULE_INDEX + module,
-			    1);
+	mlxsw_reg_mtbr_pack(mtbr_pl, mlxsw_hwmon_dev->slot_index,
+			    MLXSW_REG_MTBR_BASE_MODULE_INDEX + module, 1);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtbr), mtbr_pl);
 	if (err) {
 		dev_err(dev, "Failed to query module temperature sensor\n");
@@ -326,7 +330,8 @@ static int mlxsw_hwmon_module_temp_critical_get(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
-	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, 0,
+	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core,
+						   mlxsw_hwmon_dev->slot_index,
 						   module, SFP_TEMP_HIGH_WARN,
 						   p_temp);
 	if (err) {
@@ -362,7 +367,8 @@ static int mlxsw_hwmon_module_temp_emergency_get(struct device *dev,
 	int err;
 
 	module = mlxsw_hwmon_attr->type_index - mlxsw_hwmon_dev->sensor_count;
-	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core, 0,
+	err = mlxsw_env_module_temp_thresholds_get(mlxsw_hwmon->core,
+						   mlxsw_hwmon_dev->slot_index,
 						   module, SFP_TEMP_HIGH_ALARM,
 						   p_temp);
 	if (err) {
@@ -609,6 +615,8 @@ static int mlxsw_hwmon_temp_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 	for (i = 0; i < mlxsw_hwmon_dev->sensor_count; i++) {
 		char mtmp_pl[MLXSW_REG_MTMP_LEN] = {0};
 
+		mlxsw_reg_mtmp_slot_index_set(mtmp_pl,
+					      mlxsw_hwmon_dev->slot_index);
 		mlxsw_reg_mtmp_sensor_index_set(mtmp_pl, i);
 		err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mtmp),
 				      mtmp_pl);
@@ -678,7 +686,7 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 	u8 module_sensor_max;
 	int i, err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	mlxsw_reg_mgpir_pack(mgpir_pl, mlxsw_hwmon_dev->slot_index);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
@@ -730,7 +738,7 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 	u8 gbox_num;
 	int err;
 
-	mlxsw_reg_mgpir_pack(mgpir_pl, 0);
+	mlxsw_reg_mgpir_pack(mgpir_pl, mlxsw_hwmon_dev->slot_index);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
 		return err;
@@ -746,7 +754,8 @@ static int mlxsw_hwmon_gearbox_init(struct mlxsw_hwmon_dev *mlxsw_hwmon_dev)
 	while (index < max_index) {
 		sensor_index = index % mlxsw_hwmon_dev->module_sensor_max +
 			       MLXSW_REG_MTMP_GBOX_INDEX_MIN;
-		mlxsw_reg_mtmp_pack(mtmp_pl, 0, sensor_index, true, true);
+		mlxsw_reg_mtmp_pack(mtmp_pl, mlxsw_hwmon_dev->slot_index,
+				    sensor_index, true, true);
 		err = mlxsw_reg_write(mlxsw_hwmon->core,
 				      MLXSW_REG(mtmp), mtmp_pl);
 		if (err) {
@@ -797,6 +806,7 @@ int mlxsw_hwmon_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_hwmon->core = mlxsw_core;
 	mlxsw_hwmon->bus_info = mlxsw_bus_info;
 	mlxsw_hwmon->line_cards[0].hwmon = mlxsw_hwmon;
+	mlxsw_hwmon->line_cards[0].slot_index = 0;
 
 	err = mlxsw_hwmon_temp_init(&mlxsw_hwmon->line_cards[0]);
 	if (err)
-- 
2.33.1

