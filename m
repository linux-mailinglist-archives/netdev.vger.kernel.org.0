Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C389A51EC23
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiEHINO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiEHINJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:13:09 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA75E08A
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C97/qSZ9iZOboVYCZySMXEreQEPC1JWNNRgCNTJilnR0IfcmgtYH8RYxmwEfL1AFpNU5ezpCvrMNnu5TqAgLekGVLz0akfkpmvFOhXGymFkdlMGTWO2SmDAogA1tvDe63Hb9yca0xjc8RWi2S4YHL3Mv5lhKqXg2q3qCMOdP9ANs2XlIui/8yAG6mpaEwRShT8GTjaNsGB7j9pxj6qrlTBEprIfQh01yCUulTYDoDuPoEs8TgSp29YR1WFZf6CBFl8ICQC/zQivUFON2qlMHo9TSLhpjxLoDomGD9/xcFq1mSv47M9d/3s1cCSnE+jcVSUm4sPnLuLnLcbWcUACw/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lnU0jGIjEtPGg/UgsfQwZXNXjPmrrESynaKWePbtAKA=;
 b=N571YsRUwDTznovrRL4BH1Om1gDonPnNPlsVw4pzxIu2taYobxzGVl6+kFbiTXZMjBZ/t2UsMcU9zzHrOHeFYCvX6U6cgJuIdNcuky4QWft3wk+AjgsNT/j2X1CHmPnefWVR0uOaMJjLx1OYsPXZNzZAyFu7iXdua503jSY6d/2fBYjwFecTxh57UbXM7li9wddF1GTw0bOkSDA+/yvFc9jGJTdP0OYZ+2fit8XbaUkdSl6qW811dBFlroedYcfDL2Ht8Rpe8h+PUVdyE2wGEQdaw4G0FUKiZ7GUNXcbf+XbGXv+23RRDekkLC9O6ictepsI+hTDT5w4glkld81EAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lnU0jGIjEtPGg/UgsfQwZXNXjPmrrESynaKWePbtAKA=;
 b=i8NDZZNg/tUHHEpi5lRT/CzJQbFZ/2ofO7GUqCipysn6NhqVq/CzJgCFmLAz1npZ1pHjpOnXVn2kt8gYdwizaXVa7nYPnrY1d9ybrm83fdfr7pbUsmk4HhuLm7mLzfN2Q52HGNHF+3JDhKhZ18ew4IXZ6MU4v0LWqumi7F1/VeFFOKkoisWsNR/uRjTFifMs+8zZXe2JomUVlEKP6BGL0pAbgOV0U7eufMTrjjGnPtwpfPvmlEADiA2yF2CDLbJnr87ETEtCekGVhLojKjnOuxk7PZ02+MY4Lh3X88Kk1uVUgCbng2qy8u1LmJqDr3yjJN+ZSmJG08cH5hmxaMEWAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:18 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:18 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/10] mlxsw: spectrum: Move handling of router events to router code
Date:   Sun,  8 May 2022 11:08:18 +0300
Message-Id: <20220508080823.32154-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0111.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:50::11) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25357648-f23f-4e0e-9fa5-08da30ca0d00
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB609677D59B95B9E0E7176123B2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bz26kCkOVTfuvKQf1BVHB2jK8Qy7S9XmANSDom3nBpCHbFdIiKF5kvRUjQuq3t4FN184vGRwXRaa3qp+/hEQKPGNkalTlwNXwCOBD0ij6mJSBygtXHMk/U9GIBend+O9lSVmVGAYOMMHn9vgJrRa08OYVUqoSYfG2dVV2fMnN4gpL1p78G6qwGOz0AxIXPo7jH6VHeW92V017V28lC8e0kpEiCwURDaJb0HRjj829/jti3dz8fPZTZTjGK+5t9yN89UmeoT1IqgsOXBjivwlNy3J3BpkV5y6E5h5BfSXu2RhVL2Tw03J7DbrQLEOIA7Yb85/H1wxBtOthO5R8CC0LHVoQ0QlzV1N2cCHRIbRzgm3MeZs6AHkAIFaeEwp63ZfA2cDav4J3tgZ68NqvlLwqq2IKAPMoj9St+GAtHhi+l0R3XojsPIovSm5+VEgFBvxLlHO02Xqq95bepl1P5eJFNPl7D3M44olQrzWlujVYxdYLMLz2+Hx2UO6QmTASxufTO1t5Y8+R44bodqusGXJTDrntwmLU97RPpx75QjzkGrVfOoc87ZUlbhxsrsjYBA3LbpH1vIxFXct7tI12AcW1n8UIqCpmWHjNmmX3nfHVSF7m9QZ1FvtKzF/NE074qFlxDz3Gd7tUKiwUpZRphLUuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w7PryPbwLqE+uypRU4i9Io3LKGqZKiOMeSvpeRy5GkjUMEYKAtIIVcraJoUD?=
 =?us-ascii?Q?dr1hXfXRt4QCMFvXccQlms5yCjuu8QieGNdZlb1GDbH3DLdJXlxY1UIUyxzV?=
 =?us-ascii?Q?xVDhGFty9AT781yrWNezU+125QjBQTaiXdWO3GR8eilrQetfVQ76k5wuY9sd?=
 =?us-ascii?Q?WtAnpCleyWKPgj/qUrwWQ407BuphoN5m1LBXqs1l6yT+Ko8LXQgjL47hddnE?=
 =?us-ascii?Q?Ai/QkeCziLZhrb2sCPq9M+hulQzMVDtTuFBFDMD1AcmhVeGfIqusZU6VgRUK?=
 =?us-ascii?Q?PwbKsSZTCgCcrGYdn0d2vp6+gudRqc0nZCO0Eu4vkl0+WRCt154pS6Zpwz3r?=
 =?us-ascii?Q?gb+7/mks4Wqk7YuNBICUvM0hG3i3/ke2g0Rm60WyBCdTgGuGGNW54NuF1YLd?=
 =?us-ascii?Q?3zsidwKFgYpo9OhSYhSFdlYcNy9kEHRWbV5i1+Jzxhi7kVSrAuO1L31oAYUT?=
 =?us-ascii?Q?EelbclBWrQ2AWBu5qDCRNLPsvlZ/cL3x10N0N1KilkaMI4CIKLpQU+3m1UwK?=
 =?us-ascii?Q?4jmKBN07dkf9nsZ0g7OKa5MdFZkG1WxQDukt8GFIzQzV8QG4jfoNU3GexLPU?=
 =?us-ascii?Q?FZQl0qlwGpg+xnOTqve1rG4B7eiYFoJblhekt7f25Lz7yQ9lDsy7l5HN+p+U?=
 =?us-ascii?Q?O4X4e4/iF26f9mn2j/iAtUDmMfSzBTFVhsZcwUALu0x+tbxakNvk5SnbaIAD?=
 =?us-ascii?Q?eP+MnTXbIhF81zaWhb12iIKq6VCq7hwQgP9Roz5mbweAcnz1JR0guxusaIAe?=
 =?us-ascii?Q?LzjRsEAp/TrYi9wdzRbDKIvAHRwZVIuULjHR/hFbYBgrnp4MZ6Mqsy0jJvj4?=
 =?us-ascii?Q?G1Kypy6arCmfMvg3BI/Plg3AM2vBPjAPilBMamp6R3Oh1+rZAlI2HGy5dTzZ?=
 =?us-ascii?Q?pCTc2VYu2IHDyzbzb8Tne5U8cU8nkGxPdTnNGpoNxXN3WKQnNiMi1J/8iJ35?=
 =?us-ascii?Q?Alm8vlVcGTbYTR3pfHHxSa+pf3F6aE1xkJJyCQ4caNH1akkajFOezFs3F6mm?=
 =?us-ascii?Q?AxPHBHefn0iEuvOqeeZk2gV8jBd6IOWxcs5IozZ7LvZ1uvriPEz6kLiQ1fEs?=
 =?us-ascii?Q?RirjaPkL2KpxCqBUoDID7J3j92evEeWFvx1HbWGpLu+JAPk4rxN8R9xku2Bs?=
 =?us-ascii?Q?8rRIkMkG5wVvZokocqB5kHVp0FIzz9BdwH06Dw0kxByb6LsksVYTPYhIxFE2?=
 =?us-ascii?Q?ZwxW8H5Qf55DuI2up6uwx0D4Jmju6RvbRz7QVBZ5gbFlt+PYl7vIitGkaBJ5?=
 =?us-ascii?Q?7JWmM/Sn93JKBh3ziUyicNEG3dhDg+ukL3+u8R8xPQNr0Wu7X0mdyhzNMLaA?=
 =?us-ascii?Q?zVtnjkaPsjGjaLcjM9Yr6eKhWteLuhio5DFxs3+fm5tsJ8O7N+0wBqLwqOXu?=
 =?us-ascii?Q?AYnkiWA/yae3GqievHZhSVL4iZh9Ri7SOkzruoYfxeJ7ELUanf8jUwKKV0Uh?=
 =?us-ascii?Q?BknqeRFEuynTSqFwQe1Y6wgETNGsxs8k4WpijxAOSxihUhBu56uCdxWItx0+?=
 =?us-ascii?Q?K0FocrmPwYZtVT/eBWrEaGf/7nTjwyc9ZkL7EYGd6Vm5TN4ulctT9nopuu+Y?=
 =?us-ascii?Q?ep9OLeTPeJsDxaoVWExZk/sZ8VcsvmrlKMPhs1VeSWJ5rK4cDRt3Wd9GT3cX?=
 =?us-ascii?Q?+K43lN1gUUSWnHiXoUOgV3puCEY/Q0Mgh5CQv+KIWFA8p8W/bWFdadRZb/+n?=
 =?us-ascii?Q?bzm9r2Lm0Mfeg8JwaLDTZ3eMXVPHnG2GrWWlaQPfCOihNHTMRdcdP+GHVjmW?=
 =?us-ascii?Q?JXJqbp2WGQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25357648-f23f-4e0e-9fa5-08da30ca0d00
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:18.7268
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7B2WbLevWeiAng5n3sO2fU2RtoP/t02B6lLxR4OCIbacKppYqVgznnRAoBszn63B/L/TuerIl+CoNjqvgBI7zA==
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

The events NETDEV_PRE_CHANGEADDR, NETDEV_CHANGEADDR and NETDEV_CHANGEMTU
have implications for in-ASIC router interface objects, and as such are
handled in the router module. Move the handling from the central dispatcher
in spectrum.c to the new notifier handler in the router module.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 14 --------------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h |  2 --
 .../ethernet/mellanox/mlxsw/spectrum_router.c  | 18 ++++++++++++++++--
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 367b9b6e040a..afc03ba93826 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -5004,18 +5004,6 @@ static int mlxsw_sp_netdevice_vxlan_event(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static bool mlxsw_sp_netdevice_event_is_router(unsigned long event)
-{
-	switch (event) {
-	case NETDEV_PRE_CHANGEADDR:
-	case NETDEV_CHANGEADDR:
-	case NETDEV_CHANGEMTU:
-		return true;
-	default:
-		return false;
-	}
-}
-
 static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 				    unsigned long event, void *ptr)
 {
@@ -5040,8 +5028,6 @@ static int mlxsw_sp_netdevice_event(struct notifier_block *nb,
 	else if (mlxsw_sp_netdev_is_ipip_ul(mlxsw_sp, dev))
 		err = mlxsw_sp_netdevice_ipip_ul_event(mlxsw_sp, dev,
 						       event, ptr);
-	else if (mlxsw_sp_netdevice_event_is_router(event))
-		err = mlxsw_sp_netdevice_router_port_event(dev, event, ptr);
 	else if (mlxsw_sp_port_dev_check(dev))
 		err = mlxsw_sp_netdevice_port_event(dev, dev, event, ptr);
 	else if (netif_is_lag_master(dev))
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index a20e2a1b8569..983195ee881e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -718,8 +718,6 @@ union mlxsw_sp_l3addr {
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 			 struct netlink_ext_ack *extack);
 void mlxsw_sp_router_fini(struct mlxsw_sp *mlxsw_sp);
-int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
-					 unsigned long event, void *ptr);
 void mlxsw_sp_rif_macvlan_del(struct mlxsw_sp *mlxsw_sp,
 			      const struct net_device *macvlan_dev);
 int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 01f10200aeaa..d5a8307aecb3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9438,8 +9438,20 @@ mlxsw_sp_netdevice_offload_xstats_cmd(struct mlxsw_sp *mlxsw_sp,
 	return err;
 }
 
-int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
-					 unsigned long event, void *ptr)
+static bool mlxsw_sp_is_router_event(unsigned long event)
+{
+	switch (event) {
+	case NETDEV_PRE_CHANGEADDR:
+	case NETDEV_CHANGEADDR:
+	case NETDEV_CHANGEMTU:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
+						unsigned long event, void *ptr)
 {
 	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
 	struct mlxsw_sp *mlxsw_sp;
@@ -9557,6 +9569,8 @@ static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
 	if (mlxsw_sp_is_offload_xstats_event(event))
 		err = mlxsw_sp_netdevice_offload_xstats_cmd(mlxsw_sp, dev,
 							    event, ptr);
+	else if (mlxsw_sp_is_router_event(event))
+		err = mlxsw_sp_netdevice_router_port_event(dev, event, ptr);
 	else if (mlxsw_sp_is_vrf_event(event, ptr))
 		err = mlxsw_sp_netdevice_vrf_event(dev, event, ptr);
 
-- 
2.35.1

