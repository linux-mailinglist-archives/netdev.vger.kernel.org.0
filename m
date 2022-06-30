Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0D85614E9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbiF3IYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:24:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiF3IX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:23:29 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF46D167CE
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:23:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FoXAfrzHXDtD6c7ZjXH/8kM8EecR75OFAAa8FF+5aodHmSNyue+G63ifXyrJSfLanrIU62+A/x/L6F1yzSmW08sH8zU8rYgZgBTtZbKQHoeruJnfftLBOOumygGuKJlYFNhCZ3p8TdDqsxzAPVaXson1P8ugaRA6pjQfOTk/d6XCzykpdeJ1rXZYTMxRTBMwEEM07s6oBrtZCBcUCuSn/Mq7QPcXfMN6bJEm2dhhHIb1RwsD95yTREwDOF7KkdkqaY40/B8uGF1wwwOu/AbIF0ta3P3Bcx9pVEUeIAz1a6oMeWHso0N1EyNEQZLTBWeC0HAwMrmXhosJxSOkstR6Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQym9MuCMZDH1Ey1FDTEGrPZo8yYW3DMtaoNBfIDIDU=;
 b=U3QJa+nNUfbnP21ZWrKpbiY4EdAWtLHxrv4g6tdYXnP7vejIL+CM+eD4dNI9X9qxuo4PpvNW8WC2hhemn/V6gN+Pv+3sUZsuyLrmK3J9bgzEJxahKnb2pu5fh97g5DkfTcvmOo9duJ0b0b6nhtyFLgX47qjdm7ruIi22owHnhqov78mt2nMPQcW7DBJjho2axXE4otYgVkGoB+bta8PJdtb7GHl1wUqFycpQu+lNXfPkkwqoC1cZRK1CtL9akAL9bY6WBUUijg3RPMlP9oKQ5A6OF4U8/tipYr2flxgGHuLPbWBV4BqavkAGqjfKKz/PT1Opc/B3uoH97d5vG1VmeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YQym9MuCMZDH1Ey1FDTEGrPZo8yYW3DMtaoNBfIDIDU=;
 b=QJrnv3S2aVYI3CDBFZiWD50VE54dND7G+8Zxy2l9RWKqeHQAWHwYE+kCUkW2a7V3O2W652BnKlVxbVSWVKyIRL43DYegKS9Dy4Va/D9o6Luv07zKwYGfvZHq6m9XF4D8v5Nza7QHvHQ1tqk/DNzl16U0DRzp8Hi5cKjm7+aDd55Sg1p1v+tglDtcIgTfaYivZHSyuUuU7yyP2911PNnUv9WeSK48Sa0SsWccbMRmiHoBksd6AHiBFf4LknZ8DFBnXU0NxXOTtf03KmFjfxpvH8oJ35NhorOtXaNmh5BgIxvPFMmDmTcFAK03zKCkqOmnkSlJvU4hIW1XWuzc2WOfbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:23:22 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:23:22 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/13] mlxsw: Configure egress VID for unicast FDB entries
Date:   Thu, 30 Jun 2022 11:22:45 +0300
Message-Id: <20220630082257.903759-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0211.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae6636a3-728f-4a6a-95e1-08da5a71cb90
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PKDDtFtML7r9IWwxY+5rg8qEchjahUhGe4iroP6cuVg1qzAQpMFabUAvL3y/ND1S2LvctWqA6ITenvwSWCeQl4BB3g3xRr1DkARE0e2Ax9KNZyVS0ygIyH9HBZzE1j3+GE8eSF5VoPKPa2dpal6F6CND4efXtgg+SeDKK/YBdXypsZNj5hupbCnrNi3RHoPPdpC7HoQXCJBR8HWHSv5NhRTGeEQDlP6jsTvqAcL+dgykaoZTrNMb5FOsFLHASa3AiKSyLe5WK1nn1FyNGDEcZoEh9EMvsJAVaXEtiWTYT+w2/8H+dymXINvKitiUskO6ePoOz5INUFFsP8/z8VCeRMkO9ze6D3qO9PMFrZsx81lAYXqYTkYR15IvozsyaYeJg/QyskzGul4YTF9l6w6yNtBqXFtIFLs8nepNq8GRXBOTJwEhpAq88LKdugIT4Sjd19jXMeq+NKYfk15urAZwOwLPFfC77KRWak2jmbAfKGAPk0W8d/rpMONmscZ4jwsT7AW/fOoPfU61TnXaOSjXX7J0r6ZkQuSX9+gO/a6krW0jeFj1sS0JbxeU55Ya4JaohlbAfEN3dP/4eH3JvmJvCdo1oiw/OCAmQrdHPgfRmzhZwf6w7Rt8EOsSBgUsNIxqn90stHoWu/8MLe6Kxoyf9r5D152H0iwYPH4IFT/wW+T57YTTe4fKLuFn09qQHuXWIt5NtCLqEteRZUGpO2r63wW7XGECSzZ5JSzNMXnJJ0JpdwVW9KAG3xUD4HIb9jl+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(6666004)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003)(66574015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CT7tjwrmhxv05/Yyut5SFKzizEAjI/SF+J9Ipt+9qmD37+YD6KTC5QlmzOf1?=
 =?us-ascii?Q?d4wjW1q9Mq3gehTO42/wfM4uJ4OjV+Z2jHDHdCFzcK3HNj5LGXWCi1av18XU?=
 =?us-ascii?Q?pzyhy9GQygAb/5vvaxOjb32PRyNUbqfNG3J4jwGnBbHb2yh9vPjgP/h37Gjp?=
 =?us-ascii?Q?sER0jqTIPjrpiaLpbl42RUBpQkYpDWFmZIVIZBoSYQjrHL8dX+zfIOKKF/pR?=
 =?us-ascii?Q?wauFnwEVbWNByqy5RH5mfseTRsHxWcgZmA7sbDMedWrelL/chG5vnxaume30?=
 =?us-ascii?Q?LDlks1ciJ9GQro9Mqw/myJMLC52bywMeiN6EG6G0Z08HR0Ldz2MgggDqpFfz?=
 =?us-ascii?Q?b1U7klXNlsg0gQxolX4PEVeayqh/pDrstIFote3BtOXNCcCubf29Llepkr0D?=
 =?us-ascii?Q?VCFvhsGFPVamDuWvDurZZahZNeobSdDEO/bw+R8E03QCcgHltuxT39FqIsC6?=
 =?us-ascii?Q?fXT6TUdLhrbPyjWjf/oSy5bkcSOYfxzxoSgWf6slO8m5Q1jmDWuuVVf3M3PX?=
 =?us-ascii?Q?1M+JGljoQdhfWKasAEgUzojHrskEYdiiuvHDTeWD7/7Jpj0MBesxq2EBYWqA?=
 =?us-ascii?Q?UfGmdyDakqUfm2h6KM8nj8sm246mwMsbcekg35qt9NDQOKLpx5n1mJSaVWwF?=
 =?us-ascii?Q?aUCOzFWEE4V6/xErd2Sdbz+icKCcrJ/K12a37PZ3++1N7z5pob6QLcC0Aj0I?=
 =?us-ascii?Q?9wLa3fWeJFjVYwEa5VwBuukkypcdif4KhgGW0tjfujcoOowXEu8iwS0UYtgJ?=
 =?us-ascii?Q?jSsCzQdK85uFG3tI12G/dI2Fs7FR5JMSjdahhF+31ejW4H0RHCcznoCruVcb?=
 =?us-ascii?Q?5qZf0wNf8scKLerA/f0LOrxVQbe8X383ya7I0ouHzs1JMddeJVm/GfdYd02U?=
 =?us-ascii?Q?grDM64l/WXfiCyxNk0UvKvjBqu6885k0PTywoj06QjvFPF4GwTPMxeV91qLn?=
 =?us-ascii?Q?HfMTprCqTAk3CRU9P319uT7Q0YHoopuGzsN7MN9EjL6NW+EZlHCK6gJIxyVm?=
 =?us-ascii?Q?LE92cozxge5hp2FXTen/IZJ6/HCsCN9WN5iDtHCGEe33UgszOhNPqF5b1Pbf?=
 =?us-ascii?Q?T8d3MT/T3XSKtfxm/1K8AVAA9rp1PSmdVYMcWO59nRKprDNUDrugevd0DlxE?=
 =?us-ascii?Q?reXgUK/5mv0jmfLTP32SBocNjBLEm+tJ/t2jSPiQlhLSmPRhXF7BboNhNiic?=
 =?us-ascii?Q?A0E5KWZj9ZSm3nJcbCt9kH27e4CynR/wwZXzxM5/KP/uC9mCDGhR/NxWAVN/?=
 =?us-ascii?Q?zA7J5cvWmOUzQfbJIeX2tmUuSv8LC9RbrBS/Q4KeZzxxGZZVrKuIGtv50SME?=
 =?us-ascii?Q?cZ2NOz4cVtgl2eHzK+VPdkiaqh4MtTU4iw5TDADgRLCjqJ6LUxUfYZv2NuFz?=
 =?us-ascii?Q?zFOxWdJaD/nsAMlhilx2YqfUsjaILy0KrFr3znAxQUUDNm+EpLttvQhfslSb?=
 =?us-ascii?Q?NKhRsV1Dlo1uSUQqXO9N8dx2oRe0jKpis6cRhYfQbd6bBISAbe5/GdwihJ2h?=
 =?us-ascii?Q?GyHWTSCkIO4xa0U+IFU/Mg1hCVCZ8OCw0++gmRqnL1r6YmZw+hbiiESkR9++?=
 =?us-ascii?Q?/AmhRQh3KC3PWP2WqlLc5kEPWT1O4Q9Z8ik0FTF3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae6636a3-728f-4a6a-95e1-08da5a71cb90
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:23:22.0494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kT31gteBEAapZ9vOu+cqolbUTP4zw5DaPNKUEcYbfbgPUA2bW2q7HTIUTxK+PKJrDO/ufN+CnmAYyPx/Usblig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |  5 ++++-
 .../mellanox/mlxsw/spectrum_switchdev.c       | 20 ++++++++++---------
 2 files changed, 15 insertions(+), 10 deletions(-)

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
index 7cabe6e8edeb..cacbfd8de1fa 100644
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
@@ -2943,7 +2945,7 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 
 do_fdb_op:
 	err = mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid,
-				      adding, true);
+				      mlxsw_sp_port_vlan->vid, adding, true);
 	if (err) {
 		dev_err_ratelimited(mlxsw_sp->bus_info->dev, "Failed to set FDB entry\n");
 		return;
-- 
2.36.1

