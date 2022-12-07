Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCBD6459F1
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiLGMia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:38:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiLGMiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:38:17 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FC4D41994
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:38:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZLycuj9ry8AMBR+RcMshHUSOoiPezrOFoI87vwV9iqre3EgdJiCX8Ng9BCzc5POdM1zLrmGWKeDJ7tEY9lqjHyIA//ETMAVpwXCZpXriXfkoKYhBdFyFZH8L6HaR/9DxYC0bLp4c+PoIQI9ihNxTomIFNQSk25Dafd09GH63usZHUg3A+21KGXG5UOeSlfq1dOsppukKhPevWRMn84o0Z4rXDGu2xUvM/yaOmWaNRGPYK1uFw7s0UvRec3bJ+kzygtXPkEnJ4jF0e+QiZ1GSYHPc8aFRCV5Cu7hF7+9QgwjWrACLYPD6wrKhYN4va5B2y2iWJmYeIfr1rnbeH29wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=17Npepg1bUcAXlI9pPU09/Cgxk/JdEOJ9Lpe0N/261k=;
 b=jOKjJB3janZd2rJ0Gom7YBjyfUKrel+1Dg6bo2IFINvga849NpkJJFN3OWID1foKVT5xJHXuCSobUIiU790gOzlPTIhGVCBuQIOMf5IftBZsqpYoXSfaN9Mcb5JxYTIva2VGD1gtO17MGzjeA66KqqKD/MaPM7chxdd3EKEUphNZLkukTbm9IVSlBSoPIYQtsEr2p4aSE21kR1wToVeXmFzC3b3CZiBBdMG9bc2GO6tKkA+ciU8zkPspQwKZaR0TBkBCSlf77DY6sPmpQpp2Rt1Lxk/f4Ljdkw39DiveDzCJNOhu9oDxzN8jZzsRKj4hwL6D9g3rUrz4IMej0J2rdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=17Npepg1bUcAXlI9pPU09/Cgxk/JdEOJ9Lpe0N/261k=;
 b=U6ZRMy8HaEE5LGrsnFZXHV15hUavecOHqCxblBH1lL1vyb1R1AjN+yAK+pP5rscS7Qax6AWrsST++m0FvHjdX/932KrtSckQP6Brz7PLBmGe1Mzw1FeAmbx57eFoRz6PWx0eVDD1MIY6k+A+bEm0MH1qVxF+TGesMad5jiisgisyG0yjl/hBmYpcoaQJzNVQRA0nzLg1WxjdXKiOrY8hlIaOPMkkhXqg69ywNe2z9FE9JaDuuwlPMMUDax34QG59Eawa9W4107TpkDfd/CncrJ1c88leP+673TbaQyr26susC4tVjud0YVQtZwetyO6nxOZ3dlrqBdoK1t0CMyuwTw==
Received: from DM6PR02CA0073.namprd02.prod.outlook.com (2603:10b6:5:1f4::14)
 by SJ1PR12MB6099.namprd12.prod.outlook.com (2603:10b6:a03:45e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Wed, 7 Dec
 2022 12:38:00 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1f4:cafe::7a) by DM6PR02CA0073.outlook.office365.com
 (2603:10b6:5:1f4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 12:38:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14 via Frontend Transport; Wed, 7 Dec 2022 12:38:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 04:37:50 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 04:37:47 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
        "Amit Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net 4/6] mlxsw: spectrum_ipip: Rename Spectrum-2 ip6gre operations
Date:   Wed, 7 Dec 2022 13:36:45 +0100
Message-ID: <e9124467cf6f4fad66b6c0e13638ae04951aa27d.1670414573.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1670414573.git.petrm@nvidia.com>
References: <cover.1670414573.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT054:EE_|SJ1PR12MB6099:EE_
X-MS-Office365-Filtering-Correlation-Id: 87a98d66-8811-4e08-6cde-08dad84fe055
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lKh4V/vGXkQD9HdXJ2cskPNPwPF5YAKTPWrkIAguziVqIBp7EAMTM4kl2naQm1JSaZ16oPJTIlKIzOv5kxKpVsWcRkzLHOlWl9vi6cCnHdk70ZDaKBh829YoVpmuUs0aIYNrliHAv8mGj799hKHE2xT904VBMuXDYRrQWBorlncfaV1a3SB6ndOKIsMMPkC05D+Hst7RXswrrCENK9LnWZFRxnf4uxuxdALbfy5eB0EekRcHjHcAHNex1hUxpd74gs7hayQ+46pCtlk5rsIxBVh9PsAlfeN5cgd9Xdr/8xwuXNMywHSmUY0BtUXHkzHJMZHOEE3/iCU58WCS1cKY/CvSxbfvq07sCaDVqbiUIowVL8PNJcY85xf3I4qCNJfT0MnzIKre51KCpa4+hBHPIUmRj2xkkGeyS7zlFur6s9Kva7YIUqz7g8MGAw53IoJrXw51jvyxcuHH9E8zkcw30P6PWGiZTCIERuQpsNhgkeTZ11q9jh54mJU/MuFticwuMn7KZWctTAjHRgN83Awc1Qt1Q1E63Zbnq0zPHtHO4xhHNQPuRtFQlJBnF8Hlt4jSIjnSx/vlK/2dbjvwVfoSrFZol3ojrVvO+sqFvOVjBSQMSter4Ighi2FxGdNF4waoM95k1NoFD6RWfJpivm8J2EjAZbo3eh/uidA6A+qFcxy4DhnFIoUQ5qaAWKCiOThbtG3gU2mFP6H6QLFhe8zKs1vGMt6bw+ALAKOBLdY5vhY=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(7636003)(4326008)(356005)(41300700001)(2906002)(40460700003)(8936002)(478600001)(36860700001)(83380400001)(86362001)(70206006)(54906003)(110136005)(82740400003)(70586007)(2616005)(5660300002)(316002)(40480700001)(82310400005)(47076005)(336012)(107886003)(16526019)(26005)(8676002)(186003)(7696005)(426003)(32563001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 12:38:00.2494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a98d66-8811-4e08-6cde-08dad84fe055
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6099
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

There are two main differences between Spectrum-1 and newer ASICs in
terms of IP-in-IP support:

1. In Spectrum-1, RIFs representing ip6gre tunnels require two entries
   in the RIF table.

2. In Spectrum-2 and newer ASICs, packets ingress the underlay (during
   encapsulation) and egress the underlay (during decapsulation) via a
   special generic loopback RIF.

The first difference was handled in previous patches by adding the
'double_rif_entry' field to the Spectrum-1 operations structure of
ip6gre RIFs. The second difference is handled during RIF creation, by
only creating a generic loopback RIF in Spectrum-2 and newer ASICs.

Therefore, the ip6gre operations can be shared between Spectrum-1 and
newer ASIC in a similar fashion to how the ipgre operations are shared.

Rename the operations to not be Spectrum-2 specific and move them
earlier in the file so that they could later be used for Spectrum-1.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 94 +++++++++----------
 1 file changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 7ed4b64fecc7..fd421fbfc71b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -429,28 +429,8 @@ mlxsw_sp1_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
 	WARN_ON_ONCE(1);
 }
 
-static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
-	.dev_type = ARPHRD_IP6GRE,
-	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
-	.inc_parsing_depth = true,
-	.double_rif_entry = true,
-	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
-	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
-	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
-	.can_offload = mlxsw_sp1_ipip_can_offload_gre6,
-	.ol_loopback_config = mlxsw_sp1_ipip_ol_loopback_config_gre6,
-	.ol_netdev_change = mlxsw_sp1_ipip_ol_netdev_change_gre6,
-	.rem_ip_addr_set = mlxsw_sp1_ipip_rem_addr_set_gre6,
-	.rem_ip_addr_unset = mlxsw_sp1_ipip_rem_addr_unset_gre6,
-};
-
-const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
-	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
-	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
-};
-
 static struct mlxsw_sp_ipip_parms
-mlxsw_sp2_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
+mlxsw_sp_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
 {
 	struct __ip6_tnl_parm parms = mlxsw_sp_ipip_netdev_parms6(ol_dev);
 
@@ -465,9 +445,9 @@ mlxsw_sp2_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
 }
 
 static int
-mlxsw_sp2_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
-				   struct mlxsw_sp_ipip_entry *ipip_entry,
-				   bool force, char *ratr_pl)
+mlxsw_sp_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
+				  struct mlxsw_sp_ipip_entry *ipip_entry,
+				  bool force, char *ratr_pl)
 {
 	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
 	enum mlxsw_reg_ratr_op op;
@@ -483,9 +463,9 @@ mlxsw_sp2_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 }
 
 static int
-mlxsw_sp2_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_ipip_entry *ipip_entry,
-				 u32 tunnel_index)
+mlxsw_sp_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_ipip_entry *ipip_entry,
+				u32 tunnel_index)
 {
 	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
 	u16 ul_rif_id = mlxsw_sp_ipip_lb_ul_rif_id(ipip_entry->ol_lb);
@@ -520,8 +500,8 @@ mlxsw_sp2_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rtdp), rtdp_pl);
 }
 
-static bool mlxsw_sp2_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
-					    const struct net_device *ol_dev)
+static bool mlxsw_sp_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
+					   const struct net_device *ol_dev)
 {
 	struct __ip6_tnl_parm tparm = mlxsw_sp_ipip_netdev_parms6(ol_dev);
 	bool inherit_tos = tparm.flags & IP6_TNL_F_USE_ORIG_TCLASS;
@@ -535,8 +515,8 @@ static bool mlxsw_sp2_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
 }
 
 static struct mlxsw_sp_rif_ipip_lb_config
-mlxsw_sp2_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
-				       const struct net_device *ol_dev)
+mlxsw_sp_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				      const struct net_device *ol_dev)
 {
 	struct __ip6_tnl_parm parms = mlxsw_sp_ipip_netdev_parms6(ol_dev);
 	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
@@ -554,20 +534,20 @@ mlxsw_sp2_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int
-mlxsw_sp2_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
-				     struct mlxsw_sp_ipip_entry *ipip_entry,
-				     struct netlink_ext_ack *extack)
+mlxsw_sp_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_ipip_entry *ipip_entry,
+				    struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_ipip_parms new_parms;
 
-	new_parms = mlxsw_sp2_ipip_netdev_parms_init_gre6(ipip_entry->ol_dev);
+	new_parms = mlxsw_sp_ipip_netdev_parms_init_gre6(ipip_entry->ol_dev);
 	return mlxsw_sp_ipip_ol_netdev_change_gre(mlxsw_sp, ipip_entry,
 						  &new_parms, extack);
 }
 
 static int
-mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
-				 struct mlxsw_sp_ipip_entry *ipip_entry)
+mlxsw_sp_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_ipip_entry *ipip_entry)
 {
 	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp,
 						 &ipip_entry->parms.daddr.addr6,
@@ -575,24 +555,44 @@ mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void
-mlxsw_sp2_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
-				   const struct mlxsw_sp_ipip_entry *ipip_entry)
+mlxsw_sp_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
+				  const struct mlxsw_sp_ipip_entry *ipip_entry)
 {
 	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &ipip_entry->parms.daddr.addr6);
 }
 
+static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
+	.dev_type = ARPHRD_IP6GRE,
+	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
+	.inc_parsing_depth = true,
+	.double_rif_entry = true,
+	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
+	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
+	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
+	.can_offload = mlxsw_sp1_ipip_can_offload_gre6,
+	.ol_loopback_config = mlxsw_sp1_ipip_ol_loopback_config_gre6,
+	.ol_netdev_change = mlxsw_sp1_ipip_ol_netdev_change_gre6,
+	.rem_ip_addr_set = mlxsw_sp1_ipip_rem_addr_set_gre6,
+	.rem_ip_addr_unset = mlxsw_sp1_ipip_rem_addr_unset_gre6,
+};
+
+const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
+	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
+	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
+};
+
 static const struct mlxsw_sp_ipip_ops mlxsw_sp2_ipip_gre6_ops = {
 	.dev_type = ARPHRD_IP6GRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
 	.inc_parsing_depth = true,
-	.parms_init = mlxsw_sp2_ipip_netdev_parms_init_gre6,
-	.nexthop_update = mlxsw_sp2_ipip_nexthop_update_gre6,
-	.decap_config = mlxsw_sp2_ipip_decap_config_gre6,
-	.can_offload = mlxsw_sp2_ipip_can_offload_gre6,
-	.ol_loopback_config = mlxsw_sp2_ipip_ol_loopback_config_gre6,
-	.ol_netdev_change = mlxsw_sp2_ipip_ol_netdev_change_gre6,
-	.rem_ip_addr_set = mlxsw_sp2_ipip_rem_addr_set_gre6,
-	.rem_ip_addr_unset = mlxsw_sp2_ipip_rem_addr_unset_gre6,
+	.parms_init = mlxsw_sp_ipip_netdev_parms_init_gre6,
+	.nexthop_update = mlxsw_sp_ipip_nexthop_update_gre6,
+	.decap_config = mlxsw_sp_ipip_decap_config_gre6,
+	.can_offload = mlxsw_sp_ipip_can_offload_gre6,
+	.ol_loopback_config = mlxsw_sp_ipip_ol_loopback_config_gre6,
+	.ol_netdev_change = mlxsw_sp_ipip_ol_netdev_change_gre6,
+	.rem_ip_addr_set = mlxsw_sp_ipip_rem_addr_set_gre6,
+	.rem_ip_addr_unset = mlxsw_sp_ipip_rem_addr_unset_gre6,
 };
 
 const struct mlxsw_sp_ipip_ops *mlxsw_sp2_ipip_ops_arr[] = {
-- 
2.35.3

