Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D8E51EC22
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiEHINC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiEHIM6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:12:58 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F074E08F
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Apx0kdKaRPeBu5cAV9/1Umhp7zAKkNCZOfogRzp9cg6h78dhXPCu7JQ1l8fKdzMrUsSVquaCVJQ0NP2VDEPtN7+zMWBwf41VhPvnVGmEJs281Vjh6lPF68BtJ/H3mXu20TTMPDTXd5jLKUR5lvQVJ5BFt0VwLo73ky1H8wswshPwqq6SoxMnf/HEX2jzVzwbgFgj2TD62n3NkidOICSVTZ/6MCFhfeAvYynV85sb0dr+sa6p5SkwVEdZT71MQqkFCqvi3XAxbAJhC0SYYSpbyKBpRWfFkbR3O8VdJY7Sh5/YH7Gsi5oYkY+5lAm2+D+h2AHUYEhdhwthTjEiVynu9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XC8jLS7vWUkEQq8eqNRYCxiiZ8r/1YdUAMV3Eiw86+8=;
 b=LC/S+Pg18WBx7kDbBosnhrBSh4PD63ailB1YcuJ4EQKvZT61aQ6S1dF+5FQ+SJbLx8WQgGvvoqMbHJP0WwrJRENLeUDNJZ7is4vFwjLZ/g2fYOADKs7ZlxTR0zid5+0OvxTLWYg4/CPtGogmdmnHAuQMJBe4pKcLQQ06KdmOcJCWkQjEufHV+9IWbsTHZVlSb/Hg2yJUXRnVLPp1FjVjmKpLKDAb/nFeogDyYJZrHnfqIOiZTWox/4d9fhSFB6QzQRpf+LIjHSPAD6PlroDCkCgAwaUurtlmx5pWBfp4D9D3x/QkPevKnJ4zw8AZ2x+m6q1m2TsWlNAP6ZADjj2aGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XC8jLS7vWUkEQq8eqNRYCxiiZ8r/1YdUAMV3Eiw86+8=;
 b=X910JdIwMB+yPiE/9B6+3iQ/uV5f+N7aa2ykeqCv5RP+1avpeGuAk4zwE51F2J7DGwIdlclOCqAdxjkucgeET28cMV8OiYq3UiDK0sgrviSaopykunckekw8A5jU7ORCzDc0zCyag9wiU8eejnz8qLbdwZ/0tjtvd0ulWWeSkRfcuSM/k1Lb4/Um6tG3tW7f/4TJI4uVcKr7ntbxjtINS0lQU49wOv25h4BX3vVvfEMLboS2m0VrBi12843ZihJs5zzDIhWwA7PiB0kIDjNzm8W4ZqlBjpSCSNAe/rCPN7umZqciqIuSy4eQpwSsAlHgkjhznI+nJPmYmriEp9YkLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:07 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:07 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum: Move handling of VRF events to router code
Date:   Sun,  8 May 2022 11:08:16 +0300
Message-Id: <20220508080823.32154-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0164.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::27) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e5c8e65-91c1-4194-9026-08da30ca0608
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB60964B92105A4634DC9A9145B2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aAlLXCJX+6SAyP4iv25hKpWzzwvkc6CLeR5azT/5fxFgY8+LIjY70i8wFYPuCHd9/Ud7oNBnEnYLcEc+fsQUfaaSNUkFlE8LnptzbWcV5wImLSMQsfF1FDIS1rNQrK65Ow+QGo78XE1Rfmfnecm8jj2GXOFROlVnVrKnQdQ7cQ5EVaQuNX6VY2yR0TC13rgklMSv6YSVi6E0UJkeSOY+/2tIeicW/rbrGfnCVwolokeY4RvmPl7hZK+NFXP+i1gUcBimCRjdUiucQLsOW8P4E4xES5ERqyPJplgac5GrNv4DMHlBCiREnnTRtlntUsDtO1kSXTyi7XTgk8pJoYGjvweKxG+6x43jjvX47VZSe0oBeiuIa9PrmGp5x3OzrwyFl1HwAdW+9emN6iniAfhYl0HFcxLsbyyhwQThlZL2x/Jeb5UcBXvui2WEWHy4AZMu9x6O5FZBRzCufbfZ29fywQsBtoT5ZahIBO7b2h1Im0KGo9v5If2SU5n9MKm0RB+mVf3umKoG8d1g4UGijMxn1BRxC03Ov7Brr6t3IBWG6bqek7LKuXc3rQhzaNl3G0ufnmaKlL/6TLRBQ17pOVoHSGGMhBgqSTGvWiWpm+Gp95DaL0FMByJEViDjQNeBrtsYzT2EblOEPFkmvyc0xO8KIQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b7BUPe+OAmiqYMPGikXV0Je/qFHnNA80AKcWIzidMz6akYrwNjit9tDHU4/w?=
 =?us-ascii?Q?ZXRHx0FjfPqBxhjb5+LOfXZc7G0itk5akAwqxSdoHfe+PxJILAiwOXp/n4dR?=
 =?us-ascii?Q?v/upXOOtSKNsdbnJdcZmg+Azcc/bbrfmHmRApoWseBGFpjpBs17+5yPI3xA7?=
 =?us-ascii?Q?z6fv4GyOo672I0wut9Fo5+S3S7rezNliL+Exj1P7q7RW7K5894MC3GX0godi?=
 =?us-ascii?Q?aNf17x7YKPfPX9L3ZHMEYngI4/jG2WFCpcRmIPJAMSirQxa4uzDtJXIvJd/s?=
 =?us-ascii?Q?MFMOfyfsE5FBG2Di+u2kObEp5shgzcnt1mnG7jDcC8Uvsdc52MHN8O6yffSm?=
 =?us-ascii?Q?e28LBhxOSSHdQ7he+gP/lwTDD4qBWvxf1Nihvvy2KtGUQf8unmzcOLYshBp2?=
 =?us-ascii?Q?Mcv/T5to9Nlnf8u1rXyo3XwrTCIMGtUzpuT+pywG3Zjnhvq1F/s5+bzHp08n?=
 =?us-ascii?Q?SfuJkJRF84bhbwlxLsgG8ECJFf0xwoCoSR+dJ27NRZ70jmccXCd3lHj6W49I?=
 =?us-ascii?Q?17DN2VOjqXbCDePK0UeOpchvcLrUlxscmDpYTnf9OVqB34c0E4JTgvd6k3bd?=
 =?us-ascii?Q?vnyUi7DlWAeq6KQnoagKJ87O1hD2vE99IJB4msMYQPy5F3JpSlT4PoQbSTsc?=
 =?us-ascii?Q?NJItJ6Tx6iHkV+d9rqssBWXsVGPWySG4n30B+SYssXX6kQ605eoui0BjjdI7?=
 =?us-ascii?Q?LUSN5ggfhOj6oh55vwQ6Mas4M3gQk6t4nyPI9nc432iJiotjBo7veSegc2C8?=
 =?us-ascii?Q?kAk0cnRd/oyUL6H9mRk8gJ9cD/lrv6fC0bQEaiKeqXDDDizYyWm8vlmhJksk?=
 =?us-ascii?Q?tM7ZTXZpho3NqV30BUgL/sz5AiKSBstfhP0plPXxQ2Yi1XazwiEBGOP8I+Lr?=
 =?us-ascii?Q?oFwlWpLorVzVZCqho8oxZTQWNrFIePrIUk2IN3TKD5N+gSK0mVmM0jZZ9Ia4?=
 =?us-ascii?Q?Cx25Pz0zDX/o9an/4NGvEtlc764+VEINxYHoa2A4CqozKSqfbJzw2dei7xrl?=
 =?us-ascii?Q?M3krpQ6EpQoZcWxr1W9X9qVUm0dTqnlETrM4xLvUsOSO649DdY6vqhb4u9n+?=
 =?us-ascii?Q?07kdwtw8itDfbFAzsEYx6R2AM2VEjXhrpUXcXC0YrxELJECWIBU7JqcWaCYV?=
 =?us-ascii?Q?utMJfSyPhIIN4IZbtO4+p0MPzlYofHTg5TroT2/FERzJLLZcyh2X0cfNwvb7?=
 =?us-ascii?Q?F69LJwR7FPke4UuXkvaYdFp5dkOKfOfdT9MmP8ziDgcqvIt4c0ZyOP3TdR5H?=
 =?us-ascii?Q?HnzPxb24XyKSzx4Q3OKYHUzKZm7jJzxUgRvVYt3i1auKMbo9px2zT0uQSfv6?=
 =?us-ascii?Q?5KUx0aDPk4NpdMihgshe3qknUlyz1jP/UmeOdjyGtBMUUhvLZOPMLTk7bq0w?=
 =?us-ascii?Q?aWMq9Dsa84PD58dOkG9uLV/QhrsIq7K9LwC1XL8GaGgp6z1wKwtTsCXAbkmP?=
 =?us-ascii?Q?d2xKpjp2gODn3nIn/ie6u2AtDus8WOT8G05Plf6WVnisCTDyIyGtVM++b0qk?=
 =?us-ascii?Q?2QF228YCyACZzmgFwfXvrZPAVi9wD0mB0YwlBQvmdeh0nai1EMUD92IF5ydg?=
 =?us-ascii?Q?Pt8cPFHIq6gFugov02HFR2lTCwQPF0yKbYfnmX8k862Moe9UO+iwD8S5Wyet?=
 =?us-ascii?Q?QD71GLvBye/OCuZ/yYN2d4ZMfagFs7iJ1s5GuMdoDFmYH65UyXOhAajHmfoq?=
 =?us-ascii?Q?cdD/6kWrkk3CTb10zKBptLkO9fMfn2NQIiroSkL7zq+ybNoEhh0e/n9dpfr1?=
 =?us-ascii?Q?LOCqdHtVxA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5c8e65-91c1-4194-9026-08da30ca0608
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:07.0972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wk3TE67ULKVj2UmApoZUyGVdO/dzbM7pp3qxBCLx7jIjG6DtXZ91MJTJR/a4/GZg5UUF93Nj+uJvhkY2SWUFQQ==
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

Events involving VRF, as L3 concern, are handled in the router code, by the
helper mlxsw_sp_netdevice_vrf_event(). The handler is currently invoked
from the centralized dispatcher in spectrum.c. Instead, move the call to
the newly-introduced router-specific notifier handler.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 11 -----------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h |  2 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c  | 18 ++++++++++++++++--
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 12fd846a778f..867c1f3810e6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4936,15 +4936,6 @@ static int mlxsw_sp_netdevice_macvlan_event(struct net_device *macvlan_dev,
 	return 0;
 }
 
-static bool mlxsw_sp_is_vrf_event(unsigned long event, void *ptr)
-{
-	struct netdev_notifier_changeupper_info *info = ptr;
-
-	if (event != NETDEV_PRECHANGEUPPER && event != NETDEV_CHANGEUPPER)
-		return false;
-	return netif_is_l3_master(info->upper_dev);
-}
-
 static int mlxsw_sp_netdevice_vxlan_event(struct mlxsw_sp *mlxsw_sp,
 					  struct net_device *dev,
 					  unsigned long event, void *ptr)
@@ -5055,8 +5046,6 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 						       event, ptr);
 	else if (mlxsw_sp_netdevice_event_is_router(event))
 		err = mlxsw_sp_netdevice_router_port_event(dev, event, ptr);
-	else if (mlxsw_sp_is_vrf_event(event, ptr))
-		err = mlxsw_sp_netdevice_vrf_event(dev, event, ptr);
 	else if (mlxsw_sp_port_dev_check(dev))
 		err = mlxsw_sp_netdevice_port_event(dev, dev, event, ptr);
 	else if (netif_is_lag_master(dev))
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 2ad29ae1c640..a20e2a1b8569 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -726,8 +726,6 @@ int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
 				  unsigned long event, void *ptr);
 int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
 				   unsigned long event, void *ptr);
-int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
-				 struct netdev_notifier_changeupper_info *info);
 bool mlxsw_sp_netdev_is_ipip_ol(const struct mlxsw_sp *mlxsw_sp,
 				const struct net_device *dev);
 bool mlxsw_sp_netdev_is_ipip_ul(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3fcb848836f0..fa4d9bf7da75 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9476,8 +9476,18 @@ static void mlxsw_sp_port_vrf_leave(struct mlxsw_sp *mlxsw_sp,
 	__mlxsw_sp_inetaddr_event(mlxsw_sp, l3_dev, NETDEV_DOWN, NULL);
 }
 
-int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
-				 struct netdev_notifier_changeupper_info *info)
+static bool mlxsw_sp_is_vrf_event(unsigned long event, void *ptr)
+{
+	struct netdev_notifier_changeupper_info *info = ptr;
+
+	if (event != NETDEV_PRECHANGEUPPER && event != NETDEV_CHANGEUPPER)
+		return false;
+	return netif_is_l3_master(info->upper_dev);
+}
+
+static int
+mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
+			     struct netdev_notifier_changeupper_info *info)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_lower_get(l3_dev);
 	int err = 0;
@@ -9511,8 +9521,12 @@ int mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
 					   unsigned long event, void *ptr)
 {
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	int err = 0;
 
+	if (mlxsw_sp_is_vrf_event(event, ptr))
+		err = mlxsw_sp_netdevice_vrf_event(dev, event, ptr);
+
 	return notifier_from_errno(err);
 }
 
-- 
2.35.1

