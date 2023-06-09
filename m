Return-Path: <netdev+bounces-9637-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1664472A14F
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0AA6F1C210C7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:34:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E95920998;
	Fri,  9 Jun 2023 17:33:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2461D2BE
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 17:33:11 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ED8E4E
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:33:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+gSEJNwJeGgDWvUFDB157wusKUqKy02yScP0nZ8EW/8xxrc6MQBIyBNep/uJMKCuFtZeRL+YxRUBWYTnYowCj9mV0F9ygHbOvtJHA7HHMNe0lD6adFAYKetD0ohWo0pEpxYjxqunPTnv/39hrlGfEYtm3/cwNDiVZSOMIQxeM8S6vuTJqfejGI6X1z0qxF1Ea2Hq7cRp14r9ukkX/GWna7mOEvbDIM5Uiyc7beNmCGDG005kZVCckKHknGRrPcIykDZEfJsoIEUtOgOgbS+/JY+1MULB32IyZLizVlg9zcrtviI61pt9t+dtRiESOWQTn3q95qNgvA7HibYaU4jZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=znSle8ZeQqoeJ0g/dVApBx9v9mojPt9UGXfq2/KVAd8=;
 b=LJEhcvB06ejSOYYZGCeeUTFIQDYCl3SAc6YVxPijGVtzU5wDBMX1woRYJaIDyei0PYS751fw3/60pyCVqzppJ9a7Sihp/o0wG7LGyIfVqMFzzbJbpIjHNGxnKN5PMI0saTZP5OvFJXlVxIKsmQhzttkGs0OHhnWQK/4GqQ6+W9uyv6lOqZ/jsNlPYIIvLqCj4CHfceWTv7QSyS6ZMytmiqQAdxH6qWhOCS96IeM2YMf4fvzRUgHEmu8FPBQrvf8j60J/fBDwQ5eGLvWnpkrdV1SnFCPgH8N+Tk11yiYxaYe6r51dvLpYvwk9H0KXsxzAgfTVuY1GeqWjxtoBi+SpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=znSle8ZeQqoeJ0g/dVApBx9v9mojPt9UGXfq2/KVAd8=;
 b=rMu0rYZJZ4jIKF2CaFewhp0wPKybBPSC0elRy0tkIZziMsmUkrAyp/zy6i8RI44vwZ0yB3dExKW6DERLftEUxH55Rkae0DqmodlkU/e87/qydGn1IvYDGZeLu0k1bRZj1oFhdctKf7Fuz4datAaxYEUl/dNT9lUoU49zHRx7OFz8H6jiuWmJTaujzv/HZRiRglT/KbOEHNpt4jLOC4l83JcnsOcOTVrzey73JfL5UdVYZX8tUG3+OdNssh8NQGm+PXGwI6a8rjoAKYFaMKfSK2fwljBWD3L5ghi8BSC/olzbQsCbxbBFWskrv8/1JOAk80AvgliSRAGp7kwcESMPHw==
Received: from DS7P222CA0024.NAMP222.PROD.OUTLOOK.COM (2603:10b6:8:2e::13) by
 SN7PR12MB7369.namprd12.prod.outlook.com (2603:10b6:806:298::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Fri, 9 Jun
 2023 17:33:08 +0000
Received: from CY4PEPF0000EE35.namprd05.prod.outlook.com
 (2603:10b6:8:2e:cafe::38) by DS7P222CA0024.outlook.office365.com
 (2603:10b6:8:2e::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.26 via Frontend
 Transport; Fri, 9 Jun 2023 17:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000EE35.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.13 via Frontend Transport; Fri, 9 Jun 2023 17:33:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 9 Jun 2023
 10:32:51 -0700
Received: from yaviefel.vdiclient.nvidia.com (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 9 Jun 2023 10:32:48 -0700
From: Petr Machata <petrm@nvidia.com>
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <netdev@vger.kernel.org>
CC: Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, "Amit
 Cohen" <amcohen@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: spectrum_router: Use the available router pointer for netevent handling
Date: Fri, 9 Jun 2023 19:32:09 +0200
Message-ID: <ce43bcc7dd96b7d1db2d55ee47ea14023f873698.1686330239.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686330238.git.petrm@nvidia.com>
References: <cover.1686330238.git.petrm@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE35:EE_|SN7PR12MB7369:EE_
X-MS-Office365-Filtering-Correlation-Id: ecd26828-4422-4332-2d84-08db690f9692
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XZyjwMNw6RNKV36P57fVLhpXSFgGCrW4ieVZ3YY6EbK41+n7YqOqYSPHHfzryrHwHj3xQfYauVhwQMHFMoWc0MHtzETv4zg4jfVGLvHUHqfJOewZ0nvdAHw5P8H2m2F62S+ISkES7zQh+2MXyw9qcoODHYb9CVRWH55OmHY2NIgjEG2eRo/HI1MUrs6EvSnlV3opxJg790R3QDWUbUD4WgxOYxeDkT5e8K7hFj3vhBi+U6lwWIPSCR+FiQQpQYP/QLTVg562psNwFp5q+EYtJ+GkTNElychwixXL+vdNZWazaP9OongPSvHFT/VmXVwgcK72KNkUZJeAekzDJFZRPTpDv8c9s+BmqdAx8THSY11mVFq7rxymz/QGljub2OPWqyQkTYyBfLn0BdJIvDXMYK0D4tBiS3rALyjzpvOkFGQlo4rhnRHoZpQM/h0Q2XOc+a9PBD6yk7/k+F2bK/TQ2G/trA8NbWqIwrDTu3xOVsj3mIqBXd5K7wrt9wYPAN07wZoSwGYi6UdQktTDBMlNiAlNCi8cOveyE1TTSsqKbLoiprB7mPZB34tRGGp8Rt7e1Lp/sRS2zaCHj4czmwXY40Lr1401tih75vQxK7Uf/y4xySL18ufX8BN9KelN3mpA8Dx/eJ8Qh8JrMad52eokehSdFHNJQ/OfgRjaURZsLgFSS9xPPNocgQGDoD7/3qYL8c393aRBLMGwDRe8PBhSuzV1G3gWT4u3wrB5P14JIr4icAsu5aIGddyVggBYjJ7u8EIAT4R1LkVekXYyZWcxmQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(136003)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(110136005)(2616005)(54906003)(8676002)(8936002)(70206006)(2906002)(70586007)(4326008)(5660300002)(316002)(41300700001)(478600001)(40460700003)(82740400003)(107886003)(6666004)(7696005)(36860700001)(186003)(356005)(7636003)(40480700001)(26005)(83380400001)(66574015)(336012)(36756003)(86362001)(426003)(47076005)(16526019)(82310400005)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 17:33:07.3239
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ecd26828-4422-4332-2d84-08db690f9692
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE35.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7369
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This code handles NETEVENT_DELAY_PROBE_TIME_UPDATE, which is invoked every
time the delay_probe_time changes. mlxsw router currently only maintains
one timer, so the last delay_probe_time set wins.

Currently, mlxsw uses mlxsw_sp_port_lower_dev_hold() to find a reference to
the router. This is no longer necessary. But as a side effect, this makes
sure that only updates to "interesting netdevices" (ones that have a
physical netdevice lower) are projected.

Retain that side effect by calling mlxsw_sp_port_dev_lower_find_rcu() and
punting if there is none. Then just proceed using the router pointer that's
already at hand in the helper.

Note that previously, the code took and put a reference of the netdevice.
Because the mlxsw_sp pointer is now obtained from the notifier block, the
port pointer (non-) NULL-ness is all that's relevant, and the reference
does not need to be taken anymore.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Amit Cohen <amcohen@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 7b1877c116ed..9d34fc846b93 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2766,13 +2766,22 @@ static int mlxsw_sp_router_schedule_work(struct net *net,
 	return NOTIFY_DONE;
 }
 
+static bool mlxsw_sp_dev_lower_is_port(struct net_device *dev)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port;
+
+	rcu_read_lock();
+	mlxsw_sp_port = mlxsw_sp_port_dev_lower_find_rcu(dev);
+	rcu_read_unlock();
+	return !!mlxsw_sp_port;
+}
+
 static int mlxsw_sp_router_netevent_event(struct notifier_block *nb,
 					  unsigned long event, void *ptr)
 {
 	struct mlxsw_sp_netevent_work *net_work;
 	struct mlxsw_sp_port *mlxsw_sp_port;
 	struct mlxsw_sp_router *router;
-	struct mlxsw_sp *mlxsw_sp;
 	unsigned long interval;
 	struct neigh_parms *p;
 	struct neighbour *n;
@@ -2791,15 +2800,11 @@ static int mlxsw_sp_router_netevent_event(struct notifier_block *nb,
 		/* We are in atomic context and can't take RTNL mutex,
 		 * so use RCU variant to walk the device chain.
 		 */
-		mlxsw_sp_port = mlxsw_sp_port_lower_dev_hold(p->dev);
-		if (!mlxsw_sp_port)
+		if (!mlxsw_sp_dev_lower_is_port(p->dev))
 			return NOTIFY_DONE;
 
-		mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 		interval = jiffies_to_msecs(NEIGH_VAR(p, DELAY_PROBE_TIME));
-		mlxsw_sp->router->neighs_update.interval = interval;
-
-		mlxsw_sp_port_dev_put(mlxsw_sp_port);
+		router->neighs_update.interval = interval;
 		break;
 	case NETEVENT_NEIGH_UPDATE:
 		n = ptr;
-- 
2.40.1


