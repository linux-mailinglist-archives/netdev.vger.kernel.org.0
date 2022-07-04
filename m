Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B25564D8A
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiGDGM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiGDGMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:12:54 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E81389A
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:12:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm1YoNLE+vALjxIPPJJuDu3fOq19oaXNNbhKfwKB4xcgnMzRJaTQvQ/a8qkOX3Gb2WBwNygCzjXWD4N0NVoYjBhMTsSja9snftDWkHJaWI7at7UjvSDLWbIvEh/KElV8Vu4XUaEkqPdD46iD1iPqmb+jlwr8CBUEP1yeuXn/WXWZdHRPQUjg+IXldSQZ2qT8MZ8yWzH04WbP7ylhZwcqv0Cdm2uPieunBHjXy+pOzDkehlQH2pgv3MdXdxyil/3T+KtRxJh1/P0dUnv49bplOyRGzjJbI1jqwUW9ZDuD2YiC9xdPWzIngu7j123Ge6ahKE6dXWFa5oJts1IRI6dFtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGEcwcSrpolqdFVBIbSjxH8B9CgrO1AW7jwAHE12ftQ=;
 b=SDbfsZLxwasVuwFv97WVz1gK2qtEMqpkn7AhUwmJiXBJ2t+Bf7f1FQrYyO85u446lQtxyJfr8pNmhiekLc064n0CnFxDldUKeVUZ3JjYVeiUjLtizC+wC2NQAR5+/RmRUmadV9No+IS+0yIdCi1G28tLCL31+ojeG3dbNoN7EoAAD4fql1OCqaa1TH5tCpW+9HNzQz0Ib85CZE6DkQl87rgcewAWxltPQwWvLVEZkiaNua8cIgu7m3zjYEmQMM5qojoavBDVaYcw7AjLBkfiPk+NbQG1ShF0bAYc8JgCRlLkYNfrC8Ofk6DQmK0Lb9jFoD6/Bi3iv61AIthGL+CbNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGEcwcSrpolqdFVBIbSjxH8B9CgrO1AW7jwAHE12ftQ=;
 b=FLLIXd06wXthKkKv0xUp60gn2sADNAOgH0pchEefIORcbK77ArgVO/e0RKBbu5wSNKe7ukbDz0aL5cENFwhowJ/+W6yaYlCLkxqewz2QEgtWhzFhaKGAUoRaNK6qKAebdzingHCWIefcJibk67E76v0BYWvmjQKObza9vlIpu38oZojxtQsOqSL1JoMsLayh8esRrQLxPP33i06KAk7tjxDRgewdQBsOZtzZAqfyPKLQKLmISQ4GGFvDqmdSmKq171Z0N4iVboLuAqE2XBfatrsOLhOCQbneBbXOWtNvlUHKuIsXnt6XtgaXiXSXBuZFwCSuM5aslHlnuudBi3ds6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:12:50 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:12:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 01/13] mlxsw: Configure egress VID for unicast FDB entries
Date:   Mon,  4 Jul 2022 09:11:27 +0300
Message-Id: <20220704061139.1208770-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0177.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::34) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 738f7ff5-3b7d-40a5-3a8d-08da5d843967
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M+h9k6pO8i2rZH8zYzrHi2f0/LjiDr7rT0RCP61hRPwkzWXY2CcIdH2XFtNM3QHSXh2J/HzlUuXHoIAjzPKOogJltbjp0LSBjr9GWtH8Md+MX04Guw0GodBOO3EenqTGpONrzCHfNwiEa9KZIgvMF3JQO2XPeABoUxPmQmzc2NdXPGNui4Cqj+sIfWhgDGZ0SKWAZy1RYEFG7ywF8I9QEX2POtlaENMHe8cQA6MCjXt/r5XfCohwlrUbNp7bCh7TW2yNfEp+AZnKh7B4psTxSqmV0EIpCdl+xRUUj0VaMo8zv1HQN6TSWVIb+9Rkxy69o47GgC07WcbjOMSW0rITf3j4h3KLkGrH8lodRmvwMEwNXnuyaAL1bocEFuh/ZTvgGmtdqA5BGedvVp9v64kYWHOBVkBDkX45CeuU+pk6JtEP/rYYAhH9YOEWd1KdADGfnFzBm/yEB7/gey484bvPs+6IH2F2m1oPilXnsQVtI6E+qeTlbl5dR/hkzY0PdChBmv90yU1UsaAnN8FziN7DvaLZSrIZLmKUkIEIfVF11pHjvQayhJp2RZPoGTveeXWh7dT5jxo37RjDozVtHBbEJpMCnFV7cfFp3gdk6v05eqhOvL2VfpUULt6P3YY4xhk7WJ73dy7fMa7lCqYOV7+515+5MgzOGe7oppB7vBm0sCVC8AaU3awlIHmFKD2WyAzItHRGSym/sqOhJR2Gb0U1eWVsPzZuGNJ30SkS9aSbWB9mi0DQr3tWWhmCIeGK7NP4M22135NFy8V0k+VwcEQCYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(6506007)(6512007)(4326008)(2616005)(8676002)(66946007)(26005)(66476007)(66556008)(6486002)(6916009)(86362001)(41300700001)(316002)(38100700002)(186003)(1076003)(107886003)(66574015)(83380400001)(478600001)(2906002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+x9teoFuIWg6UlPq0SYJJzbSyGqPZlLEuPWZeWZp8imaRE9DQ6tXI2BFVq1t?=
 =?us-ascii?Q?q2nq+yv2D/c6vUrnIoq4laOmFci7QCG2jL5DNS5r20u5h3Ezq03Fjc5fs6+k?=
 =?us-ascii?Q?PRPax996EZSXgHMzNUu2oklA0Wad9JV3H1WskKGCHBcrZl1UB7cY7JENMM5s?=
 =?us-ascii?Q?fwwLClvZLMsLjGmb/7+bGbfT6uPEkycujdU4rgBpQepqyLSqk4Klr+Cd/FNd?=
 =?us-ascii?Q?v1movvfetRbm9JCt3AAbFcEq0NsAKXJ+X/6NQoFSEuv1pmu4vkoM6Z/DWRg7?=
 =?us-ascii?Q?QAs95C5dQmfRkSfTb5FxkJdhRQ9Wp60/TJYHpVbBJyATUnQQuvJKmPdK/OAX?=
 =?us-ascii?Q?wcrpu7u+onfJW0aCeTpzrJUdHbIpvwicvSH1OOfMYXhLzb2ajJfA0KKx+N3T?=
 =?us-ascii?Q?uEovv9J80H11ksZkbff9WUZHi9kRqP9Z548iBeaZyg98vAPyPAb9OB2JonJt?=
 =?us-ascii?Q?/eV4IM9YJKEB5j+SPhonmZ/YS4bba/F4c8TiHoPCOEbm1JluYCQRb8B0gfcA?=
 =?us-ascii?Q?FwZIojGBXAus4ORkAYrHH1TM3u4s5URBDAmckIzJCw06npd8MUaX+bVZslYh?=
 =?us-ascii?Q?z8lbQ6MUuNyCtzyRIjOVGfXeai3t2K8EpQQbTa4EJCHM4p3Jk8jaUQff0IZN?=
 =?us-ascii?Q?XoMn0D3rZBdWqGpk0Xp0tA8RNlxpdz+vxHJ9IcySDjXq6LAOQVFPqlU1oHYK?=
 =?us-ascii?Q?kVt0FjvVosI7S9B/yHco/zpj25cGzwFD0i5LvW3iNRAwyYGWAWoGEj3QmSRW?=
 =?us-ascii?Q?cemOdJ6F45zr4ZcE84I+uHxvbKrl7fpAPA7LTAfqcpYGNNlZVXe/VimRI9Bx?=
 =?us-ascii?Q?Euy6dGnckXONZRevscHRIEV1S4lU/U+Rf4QT8Yf2JvBiIglFj4fZn27mdav2?=
 =?us-ascii?Q?Ht4on3sWnINTa3039v+7k+Vgfmeh90BqKj+WFFWu5jK4PhsbN/6tN129rf90?=
 =?us-ascii?Q?XYRJF8Ra6IoHuN7ZTvjvQ+n1CfH9HzKS9AqU7rgccxmuBpo1l54NFNFDaz+P?=
 =?us-ascii?Q?4halTAivqjeZMlGrO0abXzFse+7yDYbjoFp6gc6IuzKXETE63/CMM1hjHW6I?=
 =?us-ascii?Q?XKsXwKtHQZeyBdY/Nri4jQ838wkJZjawv2GCUc9n/BmVmbDtMmaCxZPZEKLn?=
 =?us-ascii?Q?BdfaZOs13lWNII5XJWnIa7cQVpbGFy/4/3z8C9vJJG11te6lmkOEHRMgIyoe?=
 =?us-ascii?Q?PCO5ge+Ox7raemA5iLx0kV7Q7rRXFeDAyUCadA+LwO6ntlU7vnk875Ta3Jfl?=
 =?us-ascii?Q?UiNaa8oSDLhn50Ew6aBhLK6Y7RjD7im2E43BxBWVgMGFSgPTvF3KUsTBvE/q?=
 =?us-ascii?Q?IiQzIN+fDZfhC58V992hSeJOPUuPJO91u9c3G2pDcykuLCmcdQQw0she0A1M?=
 =?us-ascii?Q?udZekk09v6nKkk2E1p5/34o2AcM50JcxMFg+wI4GKEe78qE8BlG0PghiCeBa?=
 =?us-ascii?Q?1GI0QkSygksgsGUexx4SCTE6CjGIF2a4b3f7G+0SwQNwYaMl6ZvE5iPDQqcY?=
 =?us-ascii?Q?ympUfV8bzJG8l3JDNLq1N7vFTNYGcHAYlX6vd5YT1vjGxeajEAwe/f+CMdOw?=
 =?us-ascii?Q?qUumtlkR4XSa2tibMULmT1gRdNR9pAiWHqYmYfVO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738f7ff5-3b7d-40a5-3a8d-08da5d843967
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:12:50.7433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8y7FNPwdeFqG3T1WO99HaMS4wRP0CsdghoJCnSsXFvYUyZLsoZ+k3Tq3sMqHcI+Hp/LRVi9Ss8VT9tfGnut2cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Using unified bridge model, firmware no longer configures the egress VID
"under the hood" and moves this responsibility to software.

For layer 2, this means that software needs to determine the egress VID
for both unicast (i.e., FDB) and multicast (i.e., MDB and flooding) flows.

Unicast FDB records and unicast LAG FDB records have new fields - "set_vid"
and "vid", set them. For records which point to router port, do not set
these fields.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  5 +++-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 24 ++++++++++---------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 022b2168f3a5..b0b5806a22ed 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -380,7 +380,7 @@ static inline void mlxsw_reg_sfd_rec_pack(char *payload, int rec_index,
 
 static inline void mlxsw_reg_sfd_uc_pack(char *payload, int rec_index,
 					 enum mlxsw_reg_sfd_rec_policy policy,
-					 const char *mac, u16 fid_vid,
+					 const char *mac, u16 fid_vid, u16 vid,
 					 enum mlxsw_reg_sfd_rec_action action,
 					 u16 local_port)
 {
@@ -389,6 +389,8 @@ static inline void mlxsw_reg_sfd_uc_pack(char *payload, int rec_index,
 	mlxsw_reg_sfd_rec_policy_set(payload, rec_index, policy);
 	mlxsw_reg_sfd_uc_sub_port_set(payload, rec_index, 0);
 	mlxsw_reg_sfd_uc_fid_vid_set(payload, rec_index, fid_vid);
+	mlxsw_reg_sfd_uc_set_vid_set(payload, rec_index, vid ? true : false);
+	mlxsw_reg_sfd_uc_vid_set(payload, rec_index, vid);
 	mlxsw_reg_sfd_uc_system_port_set(payload, rec_index, local_port);
 }
 
@@ -454,6 +456,7 @@ mlxsw_reg_sfd_uc_lag_pack(char *payload, int rec_index,
 	mlxsw_reg_sfd_rec_policy_set(payload, rec_index, policy);
 	mlxsw_reg_sfd_uc_lag_sub_port_set(payload, rec_index, 0);
 	mlxsw_reg_sfd_uc_lag_fid_vid_set(payload, rec_index, fid_vid);
+	mlxsw_reg_sfd_uc_lag_set_vid_set(payload, rec_index, true);
 	mlxsw_reg_sfd_uc_lag_lag_vid_set(payload, rec_index, lag_vid);
 	mlxsw_reg_sfd_uc_lag_lag_id_set(payload, rec_index, lag_id);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 7cabe6e8edeb..fd8f9be2d401 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1681,7 +1681,8 @@ static int mlxsw_sp_port_fdb_tunnel_uc_op(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int __mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u16 local_port,
-				     const char *mac, u16 fid, bool adding,
+				     const char *mac, u16 fid, u16 vid,
+				     bool adding,
 				     enum mlxsw_reg_sfd_rec_action action,
 				     enum mlxsw_reg_sfd_rec_policy policy)
 {
@@ -1694,7 +1695,8 @@ static int __mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 		return -ENOMEM;
 
 	mlxsw_reg_sfd_pack(sfd_pl, mlxsw_sp_sfd_op(adding), 0);
-	mlxsw_reg_sfd_uc_pack(sfd_pl, 0, policy, mac, fid, action, local_port);
+	mlxsw_reg_sfd_uc_pack(sfd_pl, 0, policy, mac, fid, vid, action,
+			      local_port);
 	num_rec = mlxsw_reg_sfd_num_rec_get(sfd_pl);
 	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfd), sfd_pl);
 	if (err)
@@ -1709,18 +1711,18 @@ static int __mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u16 local_port,
 }
 
 static int mlxsw_sp_port_fdb_uc_op(struct mlxsw_sp *mlxsw_sp, u16 local_port,
-				   const char *mac, u16 fid, bool adding,
-				   bool dynamic)
+				   const char *mac, u16 fid, u16 vid,
+				   bool adding, bool dynamic)
 {
-	return __mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid, adding,
-					 MLXSW_REG_SFD_REC_ACTION_NOP,
+	return __mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid, vid,
+					 adding, MLXSW_REG_SFD_REC_ACTION_NOP,
 					 mlxsw_sp_sfd_rec_policy(dynamic));
 }
 
 int mlxsw_sp_rif_fdb_op(struct mlxsw_sp *mlxsw_sp, const char *mac, u16 fid,
 			bool adding)
 {
-	return __mlxsw_sp_port_fdb_uc_op(mlxsw_sp, 0, mac, fid, adding,
+	return __mlxsw_sp_port_fdb_uc_op(mlxsw_sp, 0, mac, fid, 0, adding,
 					 MLXSW_REG_SFD_REC_ACTION_FORWARD_IP_ROUTER,
 					 MLXSW_REG_SFD_REC_POLICY_STATIC_ENTRY);
 }
@@ -1782,7 +1784,7 @@ mlxsw_sp_port_fdb_set(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (!bridge_port->lagged)
 		return mlxsw_sp_port_fdb_uc_op(mlxsw_sp,
 					       bridge_port->system_port,
-					       fdb_info->addr, fid_index,
+					       fdb_info->addr, fid_index, vid,
 					       adding, false);
 	else
 		return mlxsw_sp_port_fdb_uc_lag_op(mlxsw_sp,
@@ -2906,10 +2908,9 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_bridge_device *bridge_device;
 	struct mlxsw_sp_bridge_port *bridge_port;
 	struct mlxsw_sp_port *mlxsw_sp_port;
+	u16 local_port, vid, fid, evid = 0;
 	enum switchdev_notifier_type type;
 	char mac[ETH_ALEN];
-	u16 local_port;
-	u16 vid, fid;
 	bool do_notification = true;
 	int err;
 
@@ -2940,9 +2941,10 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 
 	bridge_device = bridge_port->bridge_device;
 	vid = bridge_device->vlan_enabled ? mlxsw_sp_port_vlan->vid : 0;
+	evid = mlxsw_sp_port_vlan->vid;
 
 do_fdb_op:
-	err = mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid,
+	err = mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid, evid,
 				      adding, true);
 	if (err) {
 		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to set FDB entry\n");
-- 
2.36.1

