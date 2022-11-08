Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5164F620DAC
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbiKHKsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:48:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233930AbiKHKs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:48:27 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F32B1DC
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:48:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f51GLZb7wgpRtZPHYhteKXxWwmFObEBza9OtSt8uxgdn8TW1W2rLN6EkhndYe5K4Gnk9+ni7Lc4/DbZUBpTR54BJoyAm/nkTfNnQeLBISaJ8sJ98xxpm5MQuGdWgU3JlHEbAkRHcmlg6nnPYhDxQer7YDUChYaUeD/G4UehCvH8bF1cZNb+Q/YrT8VIySRJarm+6aeUDS4JemWqmnsfC8xGrSxQM9dELoaTIB/c0tcbYzcS4oBKoq5/9TA041dShrhA1cMfdxegiZ6M/3Unfi+UncL2ZuglRzJ229A4wdE+wU9u1u1jG6YJjfd0hvga8TaEIlkfKscfZTltB6/ulmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AtE7u9MQDSIbAqLf032Zj0aue9ZFrFmS/MZfZeVQBBA=;
 b=DI6VmgmP2cnXrTYnhidZ+aBw++SmRn47zYBBHzHSq8vjjIYGRRX1ssooxwhPY6QHGD1Z/t9Z7MxQXKsS2nkIlTp+9WH7873MyYTA7LJdgg6/C+4d5QQnj31G8nBmiVSiXDZbZnew6NtXa7JAMKE9xd+jh/oNU23+/mqhClrrkAdK8caP90A8NrlBu7f7PCw+h2EpaqdobFMtgDFYk9B0TZ4nw5h8cr5u2fcjYEA+eorOk3B7UsTGQy7Bb/cUe+Rx8efcoR11sW2hN2+nCX06yzugjXAZWF0Tgczauu3EJMXjm+bZqHEHrpQ9w6VXLSj/TZupMzOO/fIwEwwHQJ217Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AtE7u9MQDSIbAqLf032Zj0aue9ZFrFmS/MZfZeVQBBA=;
 b=pEtS0mq8blvFkk+9WPVzZRJGsYAd4QHwWTbS8r7Y9PZp0J68BRTE4jhYrQTcdyqN692RSnCXkRwl0UeG6l590PtX8l5VMvdliQVbSo2iKymuuTBDPOrioAhmhpe0KqzHWvIpcZS67x00Hi3In73XSZOZtQQymIPmWZlclC0HYjyyyG/DHDhnHtkaeJ1QX51YKQsyb1oYEoGA/P2PDbxH1XZTY8WrHEQ2UIx8gGZcg5GqFB2Zk/FnE4mqX3Y3AJIpIee8K0BK4DiStTAwNpwJcjnmFdubpFAJcT547qQuHkoaFz0DkIATt1w4f5emA4mhEkfwCvgs+4xBwQfcCpUA6g==
Received: from BN0PR08CA0027.namprd08.prod.outlook.com (2603:10b6:408:142::25)
 by DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 10:48:22 +0000
Received: from BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:142:cafe::27) by BN0PR08CA0027.outlook.office365.com
 (2603:10b6:408:142::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 10:48:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT093.mail.protection.outlook.com (10.13.177.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 10:48:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 8 Nov 2022
 02:48:07 -0800
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Tue, 8 Nov 2022 02:48:04 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, <netdev@vger.kernel.org>
CC:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>,
        <mlxsw@nvidia.com>
Subject: [PATCH net-next 08/15] mlxsw: spectrum_switchdev: Prepare for locked FDB notifications
Date:   Tue, 8 Nov 2022 11:47:14 +0100
Message-ID: <41dd6cd6fd24a0a47e4085ccf534e5cdea8b33a4.1667902754.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
References: <cover.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT093:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e5ebffe-a19d-4fc1-d3f1-08dac176c1a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: U2SA4/DNfe5eSAQax5IrfE4qJojXSdRZkTHh31jSxSwiIlpsfq7UXS9m3tQIj7KePNabbMMor9C9AEUjWGuOkGdNone+8iqaSKJMyKnw8Icv9LiVwE2ikSSdpGDfKNy4hC9GJVTKRF0aLyh+XyfxR0tsMWyN878xiXR6vpxP8ZxRnz5bAPWXfiQWSQKgEgUaHAJ2WbF/xpe3OX4PyZUb7W44KhyqnhMoWmvI02zDRCWeXHSs7B/nhJgsu3Cnr8+aSDN+30S5UcIQmuUaslyGNGIgtAJK4KD850+eO3omixLwVqW42XZsW7SOVS5Zut6RYU4fYpdHvi8CDBJeAT9klWINBuTh+1GR+Tl9O2vLH4KuVqGLFG1X/YY0rgG9kQwS+UsJGxio4SjQc5vDFufD+OUrpKF8ZbIOBNpIb8FRYTH8cJSTKjQAyvlQxR4OyVu+VNYlAn+sSH5eMkAcu2wYkxngaYxprmfCVGzYrn+EdwDrIdaEpLCdTB1vbqa1Vn3NzJ+RAdMjAbGNBm1rEr/EP4WNGXZhxNVDaVQY3ABhPMob080roZRd6653a2Q/mrHRhDG46kTPUxVa9eFyCEHnLi7Y8SGTu5ofndzOdIwjez2pcNiEbfBusuYt87mKeKbi1EefpF7FdFye4OLz6FhWFLIuiDdYKwPrwpe2JliyWnSpUMWVSSXuCJBgqamxAkvPVvxFpfNgYc8+tSkT6fsGpbh2umIOZfDXNK8mVRoeatsNfE0/ivNckeuTYKYMebhCvV4qzgQ+Q979JtQUgqWpfg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(39860400002)(136003)(451199015)(36840700001)(46966006)(40470700004)(36756003)(356005)(82740400003)(7636003)(86362001)(83380400001)(40480700001)(40460700003)(2906002)(15650500001)(186003)(336012)(26005)(16526019)(6666004)(426003)(107886003)(47076005)(7696005)(36860700001)(70206006)(316002)(4326008)(8676002)(2616005)(54906003)(110136005)(82310400005)(70586007)(8936002)(478600001)(5660300002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:48:22.3396
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e5ebffe-a19d-4fc1-d3f1-08dac176c1a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT093.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696
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

Subsequent patches will need to report locked FDB entries to the bridge
driver. Prepare for that by adding a 'locked' argument to
mlxsw_sp_fdb_call_notifiers() according to which the 'locked' bit is set
in the FDB notification info. For now, always pass 'false'.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 4efccd942fb8..0fbefa43f9b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2888,13 +2888,14 @@ static void mlxsw_sp_fdb_nve_call_notifiers(struct net_device *dev,
 static void
 mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
 			    const char *mac, u16 vid,
-			    struct net_device *dev, bool offloaded)
+			    struct net_device *dev, bool offloaded, bool locked)
 {
 	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = mac;
 	info.vid = vid;
 	info.offloaded = offloaded;
+	info.locked = locked;
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
 }
 
@@ -2952,7 +2953,8 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	if (!do_notification)
 		return;
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE : SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding,
+				    false);
 
 	return;
 
@@ -3015,7 +3017,8 @@ static void mlxsw_sp_fdb_notify_mac_lag_process(struct mlxsw_sp *mlxsw_sp,
 	if (!do_notification)
 		return;
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE : SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding,
+				    false);
 
 	return;
 
@@ -3122,7 +3125,7 @@ static void mlxsw_sp_fdb_notify_mac_uc_tunnel_process(struct mlxsw_sp *mlxsw_sp,
 
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE :
 			SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, nve_dev, adding);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, nve_dev, adding, false);
 
 	mlxsw_sp_fid_put(fid);
 
@@ -3264,7 +3267,7 @@ mlxsw_sp_switchdev_bridge_vxlan_fdb_event(struct mlxsw_sp *mlxsw_sp,
 					 &vxlan_fdb_info.info, NULL);
 		mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
 					    vxlan_fdb_info.eth_addr,
-					    fdb_info->vid, dev, true);
+					    fdb_info->vid, dev, true, false);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		err = mlxsw_sp_port_fdb_tunnel_uc_op(mlxsw_sp,
@@ -3359,7 +3362,7 @@ static void mlxsw_sp_switchdev_bridge_fdb_event_work(struct work_struct *work)
 			break;
 		mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
 					    fdb_info->addr,
-					    fdb_info->vid, dev, true);
+					    fdb_info->vid, dev, true, false);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = &switchdev_work->fdb_info;
@@ -3443,7 +3446,8 @@ mlxsw_sp_switchdev_vxlan_fdb_add(struct mlxsw_sp *mlxsw_sp,
 	call_switchdev_notifiers(SWITCHDEV_VXLAN_FDB_OFFLOADED, dev,
 				 &vxlan_fdb_info->info, NULL);
 	mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				    vxlan_fdb_info->eth_addr, vid, dev, true);
+				    vxlan_fdb_info->eth_addr, vid, dev, true,
+				    false);
 
 	mlxsw_sp_fid_put(fid);
 
@@ -3493,7 +3497,8 @@ mlxsw_sp_switchdev_vxlan_fdb_del(struct mlxsw_sp *mlxsw_sp,
 				       false, false);
 	vid = bridge_device->ops->fid_vid(bridge_device, fid);
 	mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				    vxlan_fdb_info->eth_addr, vid, dev, false);
+				    vxlan_fdb_info->eth_addr, vid, dev, false,
+				    false);
 
 	mlxsw_sp_fid_put(fid);
 }
-- 
2.35.3

