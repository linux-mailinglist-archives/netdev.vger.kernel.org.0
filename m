Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C4351EC26
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbiEHIN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiEHINU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:13:20 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE3AE0B1
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTYACDWL7hMYLyy8+n4s7Af/pbaZUO7VoUEMnK1rx6Xt/PPbMWjQHG+ZQvOaW8ewtV6EBHf/OFlZQL40HiljfEvC2tYuK+Agklk7iwrIsI9hA+LLscorbYxr16+5FqJs3mgWjQs/xbyMYdKQUS7aL5jqY7isY+EwzHo7ZCTT6KgZdt4KfYP0kLoWYpNc1PBt29GmHIdkhXHE5MrgU9jpSNe3A+zIeB+4cSr8vLu1tLU/EJEAFMO4rbe8LU2OslWDfGx3BhwqyaOg+uCOQwMa10AxHhgIxMlDIOESBjd6PgO8kg7h+7uOi2erufmu/6kXRLt/14XqDB8KDIDpwGBo6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7q9m6c75RHPNOorrwrn2OF0pxoIMpxsUAa7qdawX314=;
 b=n6pXgW3rk87eaGRu9pzE3eyViAJ0ZgNYurj6NOKUgmW9l9ytkme0shTcdHntwpmskXDlDdGkO3CXWW9QOWlrow9GrB1PVoWvJQUTTFc5EbKKfGadKMSu06VTLjCcsMRNt1u3eJZy5JyGuOEi8fi5yYvKrHVnpnoKKs2rUuiJz4hJZIuDV6d73NR65XXPFSBAeBjkx1df+sWllvecodCD9sUTOfgSs4tbQMgmvENIdzclaH4yI9aqjJtVQhySms5tW/NijCCrwooEhcf39Si0wqlZyoda/zQS8DsUWO8+bFFE5TxlfrGUY1wm40n/uNVKxpTv5Y2kEym7pSvXSR2HiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7q9m6c75RHPNOorrwrn2OF0pxoIMpxsUAa7qdawX314=;
 b=CumDFLtqygLbmSyRR6KS9Aa2MEverBvSArSbOYT+LZMqACb4gSXFowoUjYvgijsvXI0nGU7x0F0/cZlV1N25RtoKwPF4a2C8DvcDrqT73u0upB7tUp8b4WajvdIFxQ9r6RNNHycn1FlmhAS5qphhPxYNbu0TUCiB/x3kUH01+iuH0gIsxGi21T3ZaifxPjpyDBrZj+3KXis+k0g55M5GkuP2raBaZiNBFVwNr7LXAJvoaY1QjgWdTxUCeiY7oatzgHIXeoxhD7zPOO+6qrQS7hQ8RS6bS1S7WUAjiA4ZuJv8wDYOlsjEIhQmR87oTpCjTJOu3zNHIELdCBzTNCP5ag==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:27 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:27 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: spectrum: Move handling of tunnel events to router code
Date:   Sun,  8 May 2022 11:08:19 +0300
Message-Id: <20220508080823.32154-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0179.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501::18)
 To DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 705689eb-37fc-4542-8ed5-08da30ca124d
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60960AA3F6177DE5F66576EAB2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+lkLTK/Q2w8H586CGbwtlVLCDhObTrEGqKZfNZ9eUkR6Vg2obLskHXPcy/yFr27LyL/wZ0hnLaEz2LGQqs/8twUqsa3ZzLDayVplhOIoMAntVnzISMBdWuuN7LZdWGwfiOunJizUAPbHyFXA6JpkxDaeGiTocEqRv2SRx+QiaF0B5doqE7ep5Vyt8frPp2M75Th6IYeKos+bhe8Wkoz290qzHeaxAO/J5BVtyr3f1DwBotCuta6aKjOrSyoW4PcrEAWQFHX4lGKAH9y3i0pnm4635RK2KatHfDIvtodQM0eJGiWabZwcjqHKcokDDZ9Kwf35KJs29OEfY1RiuYUwZob7wE0edG2n1/Xio3XcUe+mIg+pctTPiLEBVwkqBNNVWEXCXF7Uea34lDYEaVEP1JdwraVchAc3vMsaUdThAJNh2JhP4SzTgbKMgiJw0WA2EKgaQTtek21lPK9P/h58eHjMdGeAlfYeptVBUiOXvreI+YxwnWj/UBff5o2EomCorOmDNXBCM0D1F+nuCpxO5k/P0/51yuh2Gtn1zQ3agjgksIPFGUnDPIxlRANbyP0DetZSAu2i/0jPqa6FLVbSTtfq+6f25RomJLruXt/RacHm0ZFRizBUzuSuDMSfwmIOrNiSd5KJKO1yeQ5iJSxsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ymQ1sq/cOw+qPfG0DljRf30r9DWyKQ0IhaIeO+l3c1BFytzyuncJg4iDP803?=
 =?us-ascii?Q?3lgxZBaEFdlxyUVEblkCU1EMNpGJdA+Clp818dk34HayY8Km5Htet41KYFcQ?=
 =?us-ascii?Q?IQ9DBt28NgIHeNIfZtmXwXOXsi9Qan7aVRhBEn66HdIeqCASMkRc7Mnbj2di?=
 =?us-ascii?Q?ZnoRQ+dT3MwVMCDiCU9w4au9g8jGbE91GRdfYcphQOlYhtSe48ztPV7ADKdC?=
 =?us-ascii?Q?oNfpaYib0574+9V5jkIUqt5kDl1SV0bmoXeTXleOnI8QqXLWErTTnMHg8i1H?=
 =?us-ascii?Q?XybO+ChaerOJUJw+F/lWY0aQZjJIcGyDEm+m6JqULJuU+G7Qs9M9uEzTWb8Z?=
 =?us-ascii?Q?pcL9cLjBj21APQUc2d7nhjLEdN2kANvuK++/vFErQ7WX/8od5MPq9bnkMvq2?=
 =?us-ascii?Q?+/zHrNh5dqSA9eVZ5UpU0mEbLtK9LE9Dx6CWQae0cFRVRs0Op/ccIqbTRefF?=
 =?us-ascii?Q?FQhBC7itLp7WIfK3Pcy33UhauKNgjcseSx/UF/1ZoC3lydnCI4WFkfEvLIBG?=
 =?us-ascii?Q?Vmi9Jh6Z2UwoMsw6OUquTa0l2vh6nTdmOu3JDqPVNHO1KSe1ly4H8/8UAGUE?=
 =?us-ascii?Q?IL6kH8oOngyZerHupW36ldPJJUYR9Ctnusi4bQFWNMBfoZ0u8YiBZAETrFmq?=
 =?us-ascii?Q?/LAb2kJgVcbbp76QGlxjRkyg9Zg8deXZE/8GWLnhLQQT8OWTUG8EkKIoPbKs?=
 =?us-ascii?Q?5kcSTjq42A6Vc1GsavbL+OUoh2kEtMAshQp3ddA/zimmYP8F95iVLevRobey?=
 =?us-ascii?Q?88qQbE3Dxm0buUsaZ8bByCsdbR0Xt656JWy2Vf8fzEfMn3+F2glgkAe+AaK+?=
 =?us-ascii?Q?vHSGWLDMk4tOqNhcYmCms1ba2bC3ar7MNLCoyvGOtONRDfMfJTg9LKIYq49d?=
 =?us-ascii?Q?+D8TmRELr/Mgpg5oiPKuJm625p2fYJFqGrRw5yZBWCsH6xX+Q1XBgBKnpWKh?=
 =?us-ascii?Q?+XKPxuSnQI6BPU13psXKFgxLWv6ytOCB/zl5CxGzN6PIMxpni+qT4wFR5O7Y?=
 =?us-ascii?Q?n9yzGLtLDo8L8jxDJTbBx3bnFLrURbtMOv+mYcu28QGZ6dfNV5sxumhLsPiG?=
 =?us-ascii?Q?kGqagVwKLMjA++9hhiYrrDl8yvNnX8iMN7xC9ydBX+xuHhrbbqiGcjUDOXpS?=
 =?us-ascii?Q?/Quc2/l9IqNP5YGbxBPhvVmQgDy+Npo85LebqRQoTpm43zKXgmDit9O5Wyq4?=
 =?us-ascii?Q?ohoRnWwSd20mgTxBaayJCvLQngvBuhGEO6zlXQVqvCI4HaOfOxmc3DKXK+YL?=
 =?us-ascii?Q?NQQLbm4HKyY/OlxQjRg7KeAfTINExx0mvhF1t3qPdSo7XVxbw3dlUssF3gkg?=
 =?us-ascii?Q?b4sAGv5V5/xq8XPTGlftaXoT7NtvXMJn/NZ1aU475Np5Hg0PIP82QpWtrBn1?=
 =?us-ascii?Q?gCXSirgf/zrGGt98mani4eYemitPkJ2a8y5J7HZfY4WZbz/jyT9/PHfKlpm2?=
 =?us-ascii?Q?m7gUJyABTrJ0WgCR0DqkW6bimLKomUck0rk4fYejECf52qrfVpm1XxUUegQH?=
 =?us-ascii?Q?m7X5+f2U9HeuORW45Htvc6VlhbU25UrnCf9INA0pfBGzSf0sxk+LoT1aZRp+?=
 =?us-ascii?Q?teCLanjAUMCDkbWiTa+gUV4X8byyPJwWYHY91hq8EdxS5Tmxh1tqUHBSZaTi?=
 =?us-ascii?Q?TQ3mjRMMZJ1St/wlN0la59RvHjO6ypBUovIziDWVrIINJYy+Xnp7BqHaCgkd?=
 =?us-ascii?Q?OzVyWZdY3QtOfMAA2Z5nvYSQqUkzfi8vTh9HaJynAIcoH3HNRGdGQ1YjAwJ4?=
 =?us-ascii?Q?Q1mytu/ISQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 705689eb-37fc-4542-8ed5-08da30ca124d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:27.5883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXoWb6XcmWSyGWYCM4ePvkJ106i/bmxCT7VFSWJCi8PXetOW/uIZX0NfIiO0A58GPzv+nklm6SY/xZpvsVSouA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6096
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

The events related to IPIP tunnels are handled by the router code. Move the
handling from the central dispatcher in spectrum.c to the new notifier
handler in the router module.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  6 -----
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 13 ----------
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 24 ++++++++++++-------
 3 files changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index afc03ba93826..5ced3df92aab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5022,12 +5022,6 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 
 	if (netif_is_vxlan(dev))
 		err = mlxsw_sp_netdevice_vxlan_event(mlxsw_sp, dev, event, ptr);
-	if (mlxsw_sp_netdev_is_ipip_ol(mlxsw_sp, dev))
-		err = mlxsw_sp_netdevice_ipip_ol_event(mlxsw_sp, dev,
-						       event, ptr);
-	else if (mlxsw_sp_netdev_is_ipip_ul(mlxsw_sp, dev))
-		err = mlxsw_sp_netdevice_ipip_ul_event(mlxsw_sp, dev,
-						       event, ptr);
 	else if (mlxsw_sp_port_dev_check(dev))
 		err = mlxsw_sp_netdevice_port_event(dev, dev, event, ptr);
 	else if (netif_is_lag_master(dev))
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 983195ee881e..a60d2bbd3aa6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -724,19 +724,6 @@ int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr);
 int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
 				   unsigned long event, void *ptr);
-bool mlxsw_sp_netdev_is_ipip_ol(const struct mlxsw_sp *mlxsw_sp,
-				const struct net_device *dev);
-bool mlxsw_sp_netdev_is_ipip_ul(struct mlxsw_sp *mlxsw_sp,
-				const struct net_device *dev);
-int mlxsw_sp_netdevice_ipip_ol_event(struct mlxsw_sp *mlxsw_sp,
-				     struct net_device *l3_dev,
-				     unsigned long event,
-				     struct netdev_notifier_info *info);
-int
-mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
-				 struct net_device *l3_dev,
-				 unsigned long event,
-				 struct netdev_notifier_info *info);
 int
 mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
 			       struct net_device *l3_dev,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index d5a8307aecb3..54e19e988c01 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1530,8 +1530,8 @@ static bool mlxsw_sp_netdev_ipip_type(const struct mlxsw_sp *mlxsw_sp,
 	return false;
 }
 
-bool mlxsw_sp_netdev_is_ipip_ol(const struct mlxsw_sp *mlxsw_sp,
-				const struct net_device *dev)
+static bool mlxsw_sp_netdev_is_ipip_ol(const struct mlxsw_sp *mlxsw_sp,
+				       const struct net_device *dev)
 {
 	return mlxsw_sp_netdev_ipip_type(mlxsw_sp, dev, NULL);
 }
@@ -1575,8 +1575,8 @@ mlxsw_sp_ipip_entry_find_by_ul_dev(const struct mlxsw_sp *mlxsw_sp,
 	return NULL;
 }
 
-bool mlxsw_sp_netdev_is_ipip_ul(struct mlxsw_sp *mlxsw_sp,
-				const struct net_device *dev)
+static bool mlxsw_sp_netdev_is_ipip_ul(struct mlxsw_sp *mlxsw_sp,
+				       const struct net_device *dev)
 {
 	bool is_ipip_ul;
 
@@ -1960,10 +1960,10 @@ static void mlxsw_sp_ipip_demote_tunnel_by_ul_netdev(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-int mlxsw_sp_netdevice_ipip_ol_event(struct mlxsw_sp *mlxsw_sp,
-				     struct net_device *ol_dev,
-				     unsigned long event,
-				     struct netdev_notifier_info *info)
+static int mlxsw_sp_netdevice_ipip_ol_event(struct mlxsw_sp *mlxsw_sp,
+					    struct net_device *ol_dev,
+					    unsigned long event,
+					    struct netdev_notifier_info *info)
 {
 	struct netdev_notifier_changeupper_info *chup;
 	struct netlink_ext_ack *extack;
@@ -2038,7 +2038,7 @@ __mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-int
+static int
 mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 				 struct net_device *ul_dev,
 				 unsigned long event,
@@ -9569,6 +9569,12 @@ static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
 	if (mlxsw_sp_is_offload_xstats_event(event))
 		err = mlxsw_sp_netdevice_offload_xstats_cmd(mlxsw_sp, dev,
 							    event, ptr);
+	else if (mlxsw_sp_netdev_is_ipip_ol(mlxsw_sp, dev))
+		err = mlxsw_sp_netdevice_ipip_ol_event(mlxsw_sp, dev,
+						       event, ptr);
+	else if (mlxsw_sp_netdev_is_ipip_ul(mlxsw_sp, dev))
+		err = mlxsw_sp_netdevice_ipip_ul_event(mlxsw_sp, dev,
+						       event, ptr);
 	else if (mlxsw_sp_is_router_event(event))
 		err = mlxsw_sp_netdevice_router_port_event(dev, event, ptr);
 	else if (mlxsw_sp_is_vrf_event(event, ptr))
-- 
2.35.1

