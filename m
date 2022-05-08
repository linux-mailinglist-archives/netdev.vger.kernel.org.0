Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBF051EC27
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 10:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbiEHINh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 04:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbiEHINf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 04:13:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E945E09D
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 01:09:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MhWiTGhEa1lFFGDIWNSNKrnKNy6lEDodhhRNBElqa+oTzNf/WjiLsSSXm8mv+r5sOWhMNU7Imf9mDu3MhkcFxg1ApbqMW6jNVGfVlb0+wMaVYFyAOGIpgcd30JYSMvbD3SwZVr+AMiRxcccA6VCtt3GX99z8fjrsEEmabUvP5eNbiOiUP2T3j5DrE1gP7iUSQhA8Rilly1YJFEIkyHmCJI1HTEDBoBoJjtxgNLY4ul7V6rICnJEjkvCDJkWeoewLFCRhxKpZztsI/7Yeet8CRu9XsYDtHxnXexoSee/UKLqFeSL+tbcwMsg5Q7naWv9BBlODgqdGfzNyRUfnA3+prA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aB5xebPJNdd532NpZhztzcxe8bfyJXlMk9dl3HzCUJY=;
 b=kgLWmJdrOUB7jio5/qdRXgKHefSnfMwQz5y9HeIslNhoed7DHXzOI6Gthpc95mXMtFYHmEMqt5UU5vhxHAByX68KeHV00RIXbzzbZGT0XPxYOcDvxsAm2QFFZn+NNwhbt8R1gICdkkDIaxCONU4rZy83yPpnmO6oXwPR//D1T8OHw3iZ9bcziB3BtuWjpJGmz15T9wF0EHsB3BkAgyjKmNXt55aI+VfzGFLJ55f8VaFkN39Rkx++j1FpCNqOUXNt6ylrID85KRdCWEHynpoQeTngEWaioP3gVh4os/Mwg7SwpmIg5Ai34B5xFVdklWbUmFLE5f6K3iRkWybXOqUSXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aB5xebPJNdd532NpZhztzcxe8bfyJXlMk9dl3HzCUJY=;
 b=bAJbE2Kx8OY2D4J1hXxGTIRbKatYkUX78INehdslGaFV0x37yRdfyyb6uCfMSGCNhhhfHEnC7ZVLRNz/wGEYY7Xd69J8ULpoRTCU6AAh9M9ul+rw0Wq/867A+IdjeylGcEf8gGVe7sOgHRG3xrMalI3Zdkb2kLc1nNg0aKhioCI0Ypj+j8d9WkKDcGanhuMD64oiAXEoJseU6wYTfqSx5D/Fg1rtcKEetctE1e5tCYVz6uOih0SNL+A8Q9eWawljm7V7m61V/wjZDl7hA6KyURZdCnTV6BPjPuflr0s4EH0mcn5A0BCqIkmzHyqRjD8agi9hoSTTs2bCM36nSZns3A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DS7PR12MB6096.namprd12.prod.outlook.com (2603:10b6:8:9b::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5227.22; Sun, 8 May 2022 08:09:43 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::45b7:af36:457d:7331%7]) with mapi id 15.20.5227.023; Sun, 8 May 2022
 08:09:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: spectrum_router: Take router lock in router notifier handler
Date:   Sun,  8 May 2022 11:08:21 +0300
Message-Id: <20220508080823.32154-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220508080823.32154-1-idosch@nvidia.com>
References: <20220508080823.32154-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0108.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::24) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f0f15ac-07c0-4512-bb3d-08da30ca1b8a
X-MS-TrafficTypeDiagnostic: DS7PR12MB6096:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6096751E93CC176023AEA975B2C79@DS7PR12MB6096.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hcHGYQAmDFsQfD0NrgP2VzXlnqlyg6lNzBeObkkbBL/s+MdqAr5jr6SjB6qnn64nuvwUbypdpdr3PbduDJEUvoqmc5JMah7S2v+sjhvO3l0OOTTK8tWq6glShBvWWucK4CbgXenj9uAn8xQfd+dW1wim04p+IDGMOEA6XNhSwcf9Ix/bBCn5diKJ46ljtrsEkvtQ3Y6cgjRgheF7+kp2hGzsY1yCG5M2nSA29J3sIa8wlJD0nCbHqBgQFkXP85XVizdqYhYeGYQ9EjoEUtQbuybsmjrihuNYt0A/sLFVDAizBFnOOf00GyF5vNOCNxaX2ALMOBNkQo+sBLrVa7WQswOMqahZbPCKfxSrf4/OtuIUkjFV+pteRBO6r+Yr+BmWnJq1ZwrNwM924IHwXbzxAvPVXED58dder/tXUvewCzpCbXIWANxE9ycAt9ZeZ3/znVc9y7HjS7786Gkf7q3USvvtJPZ6ChOXRrAbEhRe7P7oIJShF71yyU7bqwL3FvC55+e698L7wrlbpEZguRfdmfjBeDLqWjW+RPf7DGhnaZQoEE/neC5lTOMbJpzmiXF+V6BTGqoCnCU7k14iqZuQXz7DsXdR4hT6UdQ5whtH0E291Wgq9bpk5kvDVbYyU5V+4Bg9OCZ+UbZc9TDnkKRtAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(6916009)(2616005)(36756003)(316002)(6666004)(83380400001)(66574015)(186003)(107886003)(8936002)(86362001)(4326008)(26005)(66476007)(66556008)(6512007)(8676002)(66946007)(38100700002)(508600001)(2906002)(6486002)(5660300002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aM033I5+c+KAQ6+VS/n1xg5APkbiVaB/jhc1DQL8MUFGL2nG2X/2xeWeEWns?=
 =?us-ascii?Q?YtZOaUhctXYvi7cIBgdt83QjdBZ5/Qt5cXnMFQzZkMyGNuEbYveo/GIJVzt9?=
 =?us-ascii?Q?qwKNksDy3lJYv9KgjMiZ+d7FYIFP1Cqy98jzqnLPRiyUQpvKRKkdZFLMv/zD?=
 =?us-ascii?Q?8Mvax4mAMxZxx9scMUD3zXlcTNcXMypG7FnlfiSW36uP9UdG2WmSmzkNxqbN?=
 =?us-ascii?Q?DEkkcmgkKSV+kJ+DG3wBPLbDj60zENN+u7hVeqkc1LqK7ek5vQ4XRRxx7j6t?=
 =?us-ascii?Q?6QuyV16eSK/YIhc9fflc4eOF1TYcy4t3TU+lAgYk+Irg/9cUZ2Sfa1fuo1n8?=
 =?us-ascii?Q?MgsFqdgdterNd+Q5wGVw3vFx+y891jvf1xZFleZ5BOOrLcr0jB7ml1m0u99+?=
 =?us-ascii?Q?Nq5dYbp/cU7RiK/3MN0H9rfYsyg0eRRN7yOj7h0vzpGJgemj1I98ukun0XPU?=
 =?us-ascii?Q?78lDNfn643gAJdAZA16RZ3Q7WvHBw00YxOQc5lG0ZGdrAOUvdFzpLKlslTE1?=
 =?us-ascii?Q?NwcAP2ff59wKnZ7itIRxpdk7drkab+k39K+nYDNKgWVTPYX8J6YgiCN66BYf?=
 =?us-ascii?Q?0IULHe+0UJHM/il2xQzrA1CM3+rEfVyp7Fg82jHQ6nQwWJPKaHCSVLEjd9cr?=
 =?us-ascii?Q?dsZkP6vSyS+7r2DduwfkHtHbilhjV6Mc32y8tH9BAQBh/wRQmP+f9SRxvRF8?=
 =?us-ascii?Q?pHcQSnD7FzGkoXvbyL11jtwCcAIye5cJn7Vecqkz5XCpjAe/hjnaHKOVnhIZ?=
 =?us-ascii?Q?mc9fnGbA4puyng/UaU8Mx9U0BQJPrG7USHqiA2ittCta2Kr1gg5beYv+AokB?=
 =?us-ascii?Q?X6IQAle/ciX2+upvikJsqPN9/fpLolFWnMsTPJYK6898xqlb4BNDo/psmP/d?=
 =?us-ascii?Q?qcdTgJ0dBm4MWNXRgdJESoeVyUSjgUcYYLbM0+zYrcOztAUWezxijndUeSwG?=
 =?us-ascii?Q?61plS4RkaO3pFFBNTHAgzbrnS7Q5yACbYP3H6CaY5j5loWMSdpP0dThdXzc8?=
 =?us-ascii?Q?zT6VoLK3HNgp/QCLygGOH8r6nvb9YcT1EMdkpDqF0KNG5i7rNLTI8ABouQzd?=
 =?us-ascii?Q?XMX8Vg2HgsWA34gLiaRKHf30MIs/pCPAF81q2qgUNYK6lAT7kVM5dR+C3fi4?=
 =?us-ascii?Q?9n4vepmprPe/+gE/tmVPManz4Wm6yhR59GTwCxmeonk+4T1eVFLIXJeufLrZ?=
 =?us-ascii?Q?xGA1+c57Ao18CQu1H9aZGhmRHg0fuD2/RaCLYwMX2Uiu/z0wkf4IhnNJTuxL?=
 =?us-ascii?Q?Bi7fXlDo+1241OqEEDZYHg9Io6j8HW23nD/dNUCpC+OVIiQBSQJgoeVZQzr4?=
 =?us-ascii?Q?x7NYgghbJbeVHgMFk7IACrEkcI9iHHErrKbZPJultnJPVEiWsLGbUeDCMVS1?=
 =?us-ascii?Q?431BTI4r0jqyRcGoymG5asgRNp+cnN0pNXQI6icxXFezN+35hpJSjrEhHmB1?=
 =?us-ascii?Q?dquF7TKoYGmahFXGtQ9OMjQ0WA12y168XIJ1MVurIxD8KCdJ/nnxIT9XutdS?=
 =?us-ascii?Q?fgOjOaQTd4eqo71FqR29/1s4SUfZS/G4d/gckuux0Jy2EeLxKqBHRlOi9QXz?=
 =?us-ascii?Q?bjxBi+7s5Nm/fXC/Kt6MrDJH428Ec+HH7ExNTAq5Ua/jLVVnY5QjQSLi0B8v?=
 =?us-ascii?Q?zX53wehKc/lQSlAPvnPj17WYgGrK53HNaQBXLMZ95zQGTyml5RclVzQGfIO5?=
 =?us-ascii?Q?c+WITujvRejdPGUW9qVs3QMrwYSpSEc7HSk1kIiYkm3yu2bencpMAlRDlxS4?=
 =?us-ascii?Q?Ywe+VdW62g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f0f15ac-07c0-4512-bb3d-08da30ca1b8a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2022 08:09:43.2605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ++O6AShlXU7qAe/gJjuWz65rQebUDZtP7M+ITlQ+Jq/tuiyTbWDIaGka6qBwilubatmwBvu0i4ElSgQNF9BJ6Q==
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

For notifications that the router needs to handle, router lock is taken.
Further, at least to determine whether an event is related to a tunnel
underlay, router lock also needs to be taken. Due to this, the router lock
is always taken for each unhandled event, and also for some handled events,
even if they are not related to underlay. Thus each event implies at least
one router lock, sometimes two.

Instead of deferring the locking to the leaf handlers, take the lock in the
router notifier handler always. This simplifies thinking about the locking
state, and in some cases saves one lock cycle.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 47 ++++++-------------
 1 file changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 54e19e988c01..9dbb573d53ea 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1578,13 +1578,7 @@ mlxsw_sp_ipip_entry_find_by_ul_dev(const struct mlxsw_sp *mlxsw_sp,
 static bool mlxsw_sp_netdev_is_ipip_ul(struct mlxsw_sp *mlxsw_sp,
 				       const struct net_device *dev)
 {
-	bool is_ipip_ul;
-
-	mutex_lock(&mlxsw_sp->router->lock);
-	is_ipip_ul = mlxsw_sp_ipip_entry_find_by_ul_dev(mlxsw_sp, dev, NULL);
-	mutex_unlock(&mlxsw_sp->router->lock);
-
-	return is_ipip_ul;
+	return mlxsw_sp_ipip_entry_find_by_ul_dev(mlxsw_sp, dev, NULL);
 }
 
 static bool mlxsw_sp_netdevice_ipip_can_offload(struct mlxsw_sp *mlxsw_sp,
@@ -1969,7 +1963,6 @@ static int mlxsw_sp_netdevice_ipip_ol_event(struct mlxsw_sp *mlxsw_sp,
 	struct netlink_ext_ack *extack;
 	int err = 0;
 
-	mutex_lock(&mlxsw_sp->router->lock);
 	switch (event) {
 	case NETDEV_REGISTER:
 		err = mlxsw_sp_netdevice_ipip_ol_reg_event(mlxsw_sp, ol_dev);
@@ -2000,7 +1993,6 @@ static int mlxsw_sp_netdevice_ipip_ol_event(struct mlxsw_sp *mlxsw_sp,
 		err = mlxsw_sp_netdevice_ipip_ol_update_mtu(mlxsw_sp, ol_dev);
 		break;
 	}
-	mutex_unlock(&mlxsw_sp->router->lock);
 	return err;
 }
 
@@ -2045,9 +2037,8 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 				 struct netdev_notifier_info *info)
 {
 	struct mlxsw_sp_ipip_entry *ipip_entry = NULL;
-	int err = 0;
+	int err;
 
-	mutex_lock(&mlxsw_sp->router->lock);
 	while ((ipip_entry = mlxsw_sp_ipip_entry_find_by_ul_dev(mlxsw_sp,
 								ul_dev,
 								ipip_entry))) {
@@ -2060,7 +2051,7 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 		if (err) {
 			mlxsw_sp_ipip_demote_tunnel_by_ul_netdev(mlxsw_sp,
 								 ul_dev);
-			break;
+			return err;
 		}
 
 		if (demote_this) {
@@ -2077,9 +2068,8 @@ mlxsw_sp_netdevice_ipip_ul_event(struct mlxsw_sp *mlxsw_sp,
 			ipip_entry = prev;
 		}
 	}
-	mutex_unlock(&mlxsw_sp->router->lock);
 
-	return err;
+	return 0;
 }
 
 int mlxsw_sp_router_nve_promote_decap(struct mlxsw_sp *mlxsw_sp, u32 ul_tb_id,
@@ -9427,15 +9417,12 @@ mlxsw_sp_netdevice_offload_xstats_cmd(struct mlxsw_sp *mlxsw_sp,
 				      struct netdev_notifier_offload_xstats_info *info)
 {
 	struct mlxsw_sp_rif *rif;
-	int err = 0;
 
-	mutex_lock(&mlxsw_sp->router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
-	if (rif)
-		err = mlxsw_sp_router_port_offload_xstats_cmd(rif, event, info);
-	mutex_unlock(&mlxsw_sp->router->lock);
+	if (!rif)
+		return 0;
 
-	return err;
+	return mlxsw_sp_router_port_offload_xstats_cmd(rif, event, info);
 }
 
 static bool mlxsw_sp_is_router_event(unsigned long event)
@@ -9456,33 +9443,27 @@ static int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
 	struct mlxsw_sp *mlxsw_sp;
 	struct mlxsw_sp_rif *rif;
-	int err = 0;
 
 	mlxsw_sp = mlxsw_sp_lower_get(dev);
 	if (!mlxsw_sp)
 		return 0;
 
-	mutex_lock(&mlxsw_sp->router->lock);
 	rif = mlxsw_sp_rif_find_by_dev(mlxsw_sp, dev);
 	if (!rif)
-		goto out;
+		return 0;
 
 	switch (event) {
 	case NETDEV_CHANGEMTU:
 	case NETDEV_CHANGEADDR:
-		err = mlxsw_sp_router_port_change_event(mlxsw_sp, rif, extack);
-		break;
+		return mlxsw_sp_router_port_change_event(mlxsw_sp, rif, extack);
 	case NETDEV_PRE_CHANGEADDR:
-		err = mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
-		break;
+		return mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
 	default:
 		WARN_ON_ONCE(1);
 		break;
 	}
 
-out:
-	mutex_unlock(&mlxsw_sp->router->lock);
-	return err;
+	return 0;
 }
 
 static int mlxsw_sp_port_vrf_join(struct mlxsw_sp *mlxsw_sp,
@@ -9535,7 +9516,6 @@ mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 	if (!mlxsw_sp || netif_is_macvlan(l3_dev))
 		return 0;
 
-	mutex_lock(&mlxsw_sp->router->lock);
 	switch (event) {
 	case NETDEV_PRECHANGEUPPER:
 		break;
@@ -9550,7 +9530,6 @@ mlxsw_sp_netdevice_vrf_event(struct net_device *l3_dev, unsigned long event,
 		}
 		break;
 	}
-	mutex_unlock(&mlxsw_sp->router->lock);
 
 	return err;
 }
@@ -9566,6 +9545,8 @@ static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
 	router = container_of(nb, struct mlxsw_sp_router, netdevice_nb);
 	mlxsw_sp = router->mlxsw_sp;
 
+	mutex_lock(&mlxsw_sp->router->lock);
+
 	if (mlxsw_sp_is_offload_xstats_event(event))
 		err = mlxsw_sp_netdevice_offload_xstats_cmd(mlxsw_sp, dev,
 							    event, ptr);
@@ -9580,6 +9561,8 @@ static int mlxsw_sp_router_netdevice_event(struct notifier_block *nb,
 	else if (mlxsw_sp_is_vrf_event(event, ptr))
 		err = mlxsw_sp_netdevice_vrf_event(dev, event, ptr);
 
+	mutex_unlock(&mlxsw_sp->router->lock);
+
 	return notifier_from_errno(err);
 }
 
-- 
2.35.1

