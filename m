Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A714C49DD3D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 10:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbiA0JDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 04:03:35 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:49601
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238164AbiA0JDd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 04:03:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3GDYUEQuB4r5n9zxF9tqxG61X8O72taum8dCFqf8QFqWIylXVL69Mn3/9QsztLdYsmUqAQasEx2sQW+2py1Rm3b/46IfPdRhn10bODrjS5bGNgtiN434lbyMne80Ut0BHsErwPr0DxlkzJP4Y8XiuXm5vB7R0hr69GCz+2YYRfMSeV+ixx/6kAgGYqTuzAOAcHDUmYSY5Wo9LclF5ooJJHnrBIQ05eP46OPqs0O8T602J7ZJ09FAP+yJVAsl9FIF63D2m/2VRi2KZTKQipRjzfL0eMHlUUgxvxQAlZ4pxJBVs9fDMlKjUfcsWrN202wyuvMob88Xe48fKesGnzVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CWq4NZCVa60N93b6wJVJFqiAQ9zTFsW/zXW9Iq2zfGg=;
 b=NgtJrayx/a8WhMwsnoTN1xAx9spfFrut+L07MYO71jtDRNx/NysyTQsd5RJpNHuwIZoZO9BDl7wgVejIR0na7lukAne/WE4iJcWzHDpecF1+J0Tn8DB4JIL5PivvB5S1cYBJDgoaY5HFnK8AJ94yiyByO9jev+zHdfGky+A2a72WIG+DoFCpgoZZERmlk755COWBv5K3pWUpbI1tsBCwzixJYASeMPEHvSbPIiMCwF1CuBUoBJHxIOT+pZfsDRgXOWq6xBAhcj19DkQZN/VCpPnEu6SbzlLnQ2BuMEohUTek7+lJ15Tv3eZmoMy0xr1giX38tGY6aG1oXdDTxmctKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CWq4NZCVa60N93b6wJVJFqiAQ9zTFsW/zXW9Iq2zfGg=;
 b=Ya9rGNAFCATmoSPQb7aON1bjI/dpYkDS6XOulnCiAERN0Ed5Fuaff01S/tzFhnzxLQjidzN+fpwyZ8003ihDagTFtwD63+QzRAndCZUd3GLe9andv911uewTi9U+9jpFf59ryOKOL/MyVm1obmjZ1R0S1gEB9e+qxe2exls1M12vfOrQNOXiPPernKj3UIFzTyJA5LVftgHUblX0HCYcRVi+olodhlfPPwxVnsqGLoT3/Zn/n+43F0zEmCbiSG4920zfELRGc0PINJvUMC2MjrE/OLNhVItUo+fXZwv4pvtUtwz8DC4J/WdIDB+LWY9Q2kvLvwDf0x6aF5/201xvoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3527.namprd12.prod.outlook.com (2603:10b6:a03:13c::12)
 by BN9PR12MB5355.namprd12.prod.outlook.com (2603:10b6:408:104::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Thu, 27 Jan
 2022 09:03:32 +0000
Received: from BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561]) by BYAPR12MB3527.namprd12.prod.outlook.com
 ([fe80::3dfb:4df1:dcf1:4561%5]) with mapi id 15.20.4909.019; Thu, 27 Jan 2022
 09:03:32 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/7] mlxsw: core: Consolidate trap groups to a single event group
Date:   Thu, 27 Jan 2022 11:02:24 +0200
Message-Id: <20220127090226.283442-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220127090226.283442-1-idosch@nvidia.com>
References: <20220127090226.283442-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0262.eurprd08.prod.outlook.com
 (2603:10a6:803:dc::35) To BYAPR12MB3527.namprd12.prod.outlook.com
 (2603:10b6:a03:13c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5af92773-de4e-4da6-b580-08d9e173e47c
X-MS-TrafficTypeDiagnostic: BN9PR12MB5355:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB53555F47DA5A8610BB4D7E7EB2219@BN9PR12MB5355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQWn/jE4H72VAK9/6rClXyynfkaHCKv9OFd7+1ZhLOzSC5dWDXvUxXoeGCas+faBE0vP7ZvvpAN7SX3p0WIkb/mPjwDoaPQ2XVd0YH64OqT9s5NkGh0cwwqIq+JqcTuivscIFGE5SJNTYqKHN4HLsJjm3W+Y/s3u+IHHM5Du9DSRJ6d2FqqBHGimivxxwVFAxv9t7l2g5DS01/t97tGONYhauf10BwpRWCw8p15tFuDuQS5X+lFdN91eXHR4xkXyrFgm0tVUqXSfhNtRweDpSmtLVHSOWaEYW+5z5LBn9DKqaNExSeP+v1wpgd42F/alGnIjqqKzcBhcDfHzhHfEJ2dhkSwdGQ5TQJ22nsM7+y5RdR0A2h6crUuAfA70BevkbCjw3M++uvcThrWQ+Ps/apc//2s+fWTsz70ue4wfYqA4vs5GU/lMflN48ZAV2gqMZE1DUKbeeCcEbHityInvLBbrgYL9X6O/nCmM4imh+ikL5jcM1Xi5op5CC/KjOcu5LzGOc/0eYAwwJGk8lnxa+H7l4B5aRpWJqOcDXzlagqB1gY358iMb/8vLezUUi0FeQ+7svtPQEVl2gNII/94oGaqsPnFETW0rPExOizNy4WWquW0GwsShfluuGnphK9l29k+dNzAumdx9Girnpe7m5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3527.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(2616005)(6916009)(4326008)(8676002)(316002)(6486002)(66946007)(26005)(186003)(86362001)(1076003)(66476007)(107886003)(508600001)(8936002)(6666004)(66556008)(5660300002)(83380400001)(6506007)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FA3EyFVTZEbPEXKRnHPldAaFtRxHmO84L+ydeLHiWB94Qh7khRc0ODBLuZKl?=
 =?us-ascii?Q?S9NgrSOBQ+AgY/br+DJbURL73aOaQUxqeFeWrVYECZKsaxdxULMG2JEy2f+X?=
 =?us-ascii?Q?5nLKA0qh609QX5AF5g46vNyvO++ELi3bfyuWA+gGVVzJl+5L9dc2fH7Ulj6F?=
 =?us-ascii?Q?Du2cbpLD2MRTqw6hM9SphkAI867MtsxBpqgs3vmDkJf7tCI0tQ2Wr8dzsMlW?=
 =?us-ascii?Q?0AfSg1VQuy63s4qRVtk8trEkPkqYET9Bcqwd61eUBPjKDTyQT5ODbzYYc/Pp?=
 =?us-ascii?Q?FrX8ihqzRwXr6xmeVUj8gBt6CkfbeM0NhQPyR4vnK8sWT3XBcs162F6r23VH?=
 =?us-ascii?Q?CCym7iYsNVVio2YLDe+7kd0I0We4LDQCBm6ELwL6FJXsJheff1Um0RKrEu8M?=
 =?us-ascii?Q?mZUv0HiDlcmbeTpZCri+eb/h+1aL2wl1FFBM3aqlM5E1mftILiyoDqqmXfLJ?=
 =?us-ascii?Q?SWOaqNH+DkIBCU3pChTSXFgN47fvpzVgOQTqM/vzHY75kM5Z2DTFcOXywngL?=
 =?us-ascii?Q?3gM8e4KdA+jGh8SnfKIsRhr//a18oGrxDY2/8S2dBPb3HHbhH7zOfZkFe7qW?=
 =?us-ascii?Q?Um1GM2WPsk/Bc2U41dWKYE8og+rV+RaMjrXgw8NG7DSxzz79v199pPkIz7sc?=
 =?us-ascii?Q?CGAilUxBquq31s6McawbDlaCNBtrCFEIiL3C2+qtVHlWqGOwwsSNMpMCL0QI?=
 =?us-ascii?Q?2CoKzImtMKxpJkju6Mt+P/ODMC33HOr+NwLy+L2V0RcWI/fuC7nvOnDB50Km?=
 =?us-ascii?Q?2Hw3On8M3+iVFxIXhRHphBie0OllylZxTAFhCyCZ3QIpU8kf3YOeAkT4G9lb?=
 =?us-ascii?Q?9VkXqPiv4FaEKlKg7735XXFQMnunAHB5XxsUHhNFf/WctpxeRsFNOnQZJ9Lm?=
 =?us-ascii?Q?+PLe9dHoEdzNbIKyW7VI6ksXbLdFz7SWRmEALhNdwpHCv0ISgpvTydS6YkLU?=
 =?us-ascii?Q?DxnoG3NRmdH1zLn2BMrTSuTH16CFlnBU46YasfrAj302KxaugtLVLRlu42c1?=
 =?us-ascii?Q?AOV0NjgaFRsFhbjUiwGfD1L8G3zMGXqsShS12MYa3ZEQlwrgIOmFej3QIiJo?=
 =?us-ascii?Q?zGOgfbDq6khbZJEWIi4h68lW6B1YMOz1RhFqf+HiJlTDd8Qmcf3Bex8Ai+6I?=
 =?us-ascii?Q?SxJnyMHDKyDq15CLlMaKK9G8sE4qZSP6rQ5bi57ZhN3sty7YhfizSX/gO07y?=
 =?us-ascii?Q?AnXKYF+OxEI4uBAM6/n1915muj5XzbgOE8ZvC9BamKopww3/79nymYnXZrOE?=
 =?us-ascii?Q?ly2ze7vNftp45D+b8De2xGCgp8QdKMpjXrk0Td8yU91JqKiUpljJE6zzb/tS?=
 =?us-ascii?Q?6UV8sCaw2ds1FjUDdTJT2ihA2XMlVOrNp3XczNlwZil2JrkmUDcipyJCgpYH?=
 =?us-ascii?Q?1gCc4GKZgotwqSKg+C0ljdt5iVMc4WoYbZKfBt3DGSDLWwgL8ichSc+ereJp?=
 =?us-ascii?Q?SAMdp6yG93EBVNkcm3bJFfcPWTozXZzlA/CN8Bw9Y8Rlfh+UKeHhan6ZU6KA?=
 =?us-ascii?Q?bRiuTpZFMOe6UsoYB7jCAq0NLMvuDp2rAbIN6LouOXZghGhy0RW0ceVx+9K1?=
 =?us-ascii?Q?ID9obh0nQVtolw/hatPbPviZK8ZnMCDfiZ6fxX4w0k3pJCNIH5gULJZya0d8?=
 =?us-ascii?Q?07d2wT67sPomf22lmrikJeg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af92773-de4e-4da6-b580-08d9e173e47c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3527.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2022 09:03:32.2689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/JqUf5HNljVqrd9faW2mPxPHC3rdQe2OKLvUzhFU9pz1GyCfxIsvG5GGONQh2Cuw8sssE+sHnksDDgTIiUfJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5355
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

For event traps which are used in core, avoid having a separate trap
group for each event. Instead of that introduce a single core event trap
group and use it for all event traps.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 6 ++----
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 3 +++
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 4 +---
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 0c2e0d42f894..f45df5fbdcc0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -214,9 +214,7 @@ struct mlxsw_event_listener_item {
 
 static const u8 mlxsw_core_trap_groups[] = {
 	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
-	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
-	MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
-	MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
+	MLXSW_REG_HTGT_TRAP_GROUP_CORE_EVENT,
 };
 
 static int mlxsw_core_trap_groups_set(struct mlxsw_core *mlxsw_core)
@@ -1725,7 +1723,7 @@ static void mlxsw_core_health_listener_func(const struct mlxsw_reg_info *reg,
 }
 
 static const struct mlxsw_listener mlxsw_core_health_listener =
-	MLXSW_EVENTL(mlxsw_core_health_listener_func, MFDE, MFDE);
+	MLXSW_CORE_EVENTL(mlxsw_core_health_listener_func, MFDE);
 
 static int
 mlxsw_core_health_fw_fatal_dump_fatal_cause(const char *mfde_pl,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e6973a7236e1..6d304092f4e7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -163,6 +163,9 @@ struct mlxsw_listener {
 		.enabled_on_register = true,					\
 	}
 
+#define MLXSW_CORE_EVENTL(_func, _trap_id)		\
+	MLXSW_EVENTL(_func, _trap_id, CORE_EVENT)
+
 int mlxsw_core_rx_listener_register(struct mlxsw_core *mlxsw_core,
 				    const struct mlxsw_rx_listener *rxl,
 				    void *priv, bool enabled);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 4e3de2846205..6ea4bf87be0b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -825,7 +825,7 @@ mlxsw_env_mtwe_listener_func(const struct mlxsw_reg_info *reg, char *mtwe_pl,
 }
 
 static const struct mlxsw_listener mlxsw_env_temp_warn_listener =
-	MLXSW_EVENTL(mlxsw_env_mtwe_listener_func, MTWE, MTWE);
+	MLXSW_CORE_EVENTL(mlxsw_env_mtwe_listener_func, MTWE);
 
 static int mlxsw_env_temp_warn_event_register(struct mlxsw_core *mlxsw_core)
 {
@@ -915,7 +915,7 @@ mlxsw_env_pmpe_listener_func(const struct mlxsw_reg_info *reg, char *pmpe_pl,
 }
 
 static const struct mlxsw_listener mlxsw_env_module_plug_listener =
-	MLXSW_EVENTL(mlxsw_env_pmpe_listener_func, PMPE, PMPE);
+	MLXSW_CORE_EVENTL(mlxsw_env_pmpe_listener_func, PMPE);
 
 static int
 mlxsw_env_module_plug_event_register(struct mlxsw_core *mlxsw_core)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index aba5db4bc780..eebd0479b2bc 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -6141,9 +6141,7 @@ MLXSW_ITEM32(reg, htgt, type, 0x00, 8, 4);
 
 enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_EMAD,
-	MLXSW_REG_HTGT_TRAP_GROUP_MFDE,
-	MLXSW_REG_HTGT_TRAP_GROUP_MTWE,
-	MLXSW_REG_HTGT_TRAP_GROUP_PMPE,
+	MLXSW_REG_HTGT_TRAP_GROUP_CORE_EVENT,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_STP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LACP,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_LLDP,
-- 
2.33.1

