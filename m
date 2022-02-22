Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A41F4BEFAF
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbiBVCxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239365AbiBVCxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:20 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD7C25C77
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2pU7Y+/MvrXm169TEkzSHOFRxLVxmZVhRF42z9NbzDe6hi/hu5lGiS4MuASPEVy2tcCAWObJqFoyf/ei+JzIz38DOX81poHmWA+ah5PuFlazb6RtR58o1K7yVq0eTfnz0gsSx1wyO4YGJpdyQL6EVUDB1i4+5TlVqpGXaijxhYR7Ux4U4ybCfXtQbODWivY7/NHgJ59J96vQta+FFNUMzLgh12g8WqCss5bZCCh3aAMX7RRLT2jQpkCNplbF1T3nXfKWmxMqmuzbXj2dtKcVmU+MnwAtQOtrP3CECaFckPpIjW+s+x4tDhDsVpMW3ASi+8HEY1a2vZJcrt7b4CeAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5vcIoAUV3yT/oJouUBIuGUFnVz5P+RRWhxmvwu2iJk=;
 b=LtooZmq2+mdV3ebrd2p7Vx6/K+sMbVoWpAM2JRh49U+PiKcTTKBQcxqbMQLgU5R7Py6keWz0OknjfefGyuRFwGNWMlF/jkuZVXJgj8BEpyOfyr3HpiyQBK2lKP+XveR4Mv0+puWQK2AX/9mBHvaqrY9cRasHLzGax/vXktuPXL47yb3k69fytEOKgPckVCpZWd98iwnGxs3zLkxDsF8rgDdBzkuZRPy/OI7P1YgGGnSmqgmbQ/YvEfaw9LjSyooJhiVfxAmqi59yBc9MyuIX/utynL+gpbwtCW36TORDfIN7qblq7l3soluK0u+is+t6L5tTVwO1OQ6N+Up7kFCMwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5vcIoAUV3yT/oJouUBIuGUFnVz5P+RRWhxmvwu2iJk=;
 b=GhAkxSmD6l0WeZoBVfcVsFzr9DRDo2wi/dDAhw9hQ4tVKiKx2z+ZKBb4V8fcnTfxi45kDBnB8aZu2tFZB01T9Uwu/99s4X4ZOi9gx0RSD8QPP6eMlOxSksJpKmstfqC3GUFAwbZ+/K/jKV+6s8zuEQPZNkX01yvJgGFT7IVtj1/fklXCODPcwnTw9SmkTkUDs8yXYzMHHK43/EpXqgCbfK2u+17gm7DF5RkTRxWT15rpCXS0DQPGrh+tAGhV4NcMH21ddGuCTDIAj00m95ondLBDbFSHfbbFc4NQ+8Vf1/Mw+I8xEtrVjd5SF6bOqvWFXJl/WnPDanQAPcNawVoS7g==
Received: from DS7PR05CA0072.namprd05.prod.outlook.com (2603:10b6:8:57::7) by
 DM5PR12MB1803.namprd12.prod.outlook.com (2603:10b6:3:10d::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.17; Tue, 22 Feb 2022 02:52:53 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::33) by DS7PR05CA0072.outlook.office365.com
 (2603:10b6:8:57::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.7 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:53 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:52 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:51 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:51 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 05/12] vxlan_core: make multicast helper take rip and ifindex explicitly
Date:   Tue, 22 Feb 2022 02:52:23 +0000
Message-ID: <20220222025230.2119189-6-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b762b59b-690c-4f83-d2b3-08d9f5ae6bfd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1803:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1803F5DB7F866FDDA8AFD893CB3B9@DM5PR12MB1803.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hf6v5HSSmWmwr7HdMpMf6RnaZlaX6smcFbDyOYvw51pUPWbHOsY6X7/OSi8nZxBjcphlQEsifrU8frDb9B3kL6RLft8yMJGw3iO9UPTm/p5/swQE5uT5apBxj/lxJmQVe4sGNf6NHjojPMTTUHHMYXJg89H4dFNZW0+A8b10zvcOHoyoLtMI1ck0KS1KMr1b457zAcKlRC0RBtfiiIw53tPqDEnIlE5KBrvGjj2HSD+7l3Y6uIt/uvZL86SFQJbVPiKKwPEhi2BEshcNhkZe+o9ju0zkvL4t9Fbr01Iz37ICFHX1wThW/p8C1PTqbJsjXEz3HqcM92MQAjoHdQhXq4+fEslCYNIY+OTZKnjcV9nQG+7G8le+eRoubv/mpqFG8Op5gQOjw2I3OC6Ad9tntmafXpkVlCo45QqZm63Qo/xaCpGibct3h5W0VpAw4+u+JcQz4LzTYnGQPu3NTwdcQaubwTHMFkyYJ/3KS5cUIlOCb9X5MrZF4UJ6zyFMHOe/fTpy74Jia3nz41CGdmNnSlfIOhgx3ZZcMT2FVFIB5KX4VU80CeB48P5idgwLe3XfSAscVlofcAFEDCx9cei8EWRm8T4p4NFBrKquMngH3tunJuz7fbDYSLutqhkGJULjT/hqcf4NQ8fuubVwIy/faZC8zW5ON17/tNYTXxFCC3K2rhICs9JnTCCbPWEL+FuASNsP19QqXZyemDPRoHSaZQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8676002)(4326008)(70586007)(1076003)(26005)(186003)(82310400004)(70206006)(2616005)(107886003)(508600001)(81166007)(316002)(356005)(86362001)(426003)(83380400001)(2906002)(54906003)(40460700003)(110136005)(8936002)(47076005)(36860700001)(5660300002)(36756003)(6666004)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:53.3297
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b762b59b-690c-4f83-d2b3-08d9f5ae6bfd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1803
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes multicast helpers to take rip and ifindex as input.
This is needed in future patches where rip can come from a pervni
structure while the ifindex can come from the vxlan device.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 37 +++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 2e0fc43769cb..df8ef919216c 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1446,8 +1446,11 @@ static bool vxlan_snoop(struct net_device *dev,
 }
 
 /* See if multicast group is already in use by other ID */
-static bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev)
+static bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev,
+			     union vxlan_addr *rip, int rifindex)
 {
+	union vxlan_addr *ip = (rip ? : &dev->default_dst.remote_ip);
+	int ifindex = (rifindex ? : dev->default_dst.remote_ifindex);
 	struct vxlan_dev *vxlan;
 	struct vxlan_sock *sock4;
 #if IS_ENABLED(CONFIG_IPV6)
@@ -1482,11 +1485,10 @@ static bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev)
 #endif
 
 		if (!vxlan_addr_equal(&vxlan->default_dst.remote_ip,
-				      &dev->default_dst.remote_ip))
+				      ip))
 			continue;
 
-		if (vxlan->default_dst.remote_ifindex !=
-		    dev->default_dst.remote_ifindex)
+		if (vxlan->default_dst.remote_ifindex != ifindex)
 			continue;
 
 		return true;
@@ -1546,12 +1548,13 @@ static void vxlan_sock_release(struct vxlan_dev *vxlan)
 /* Update multicast group membership when first VNI on
  * multicast address is brought up
  */
-static int vxlan_igmp_join(struct vxlan_dev *vxlan)
+static int vxlan_igmp_join(struct vxlan_dev *vxlan, union vxlan_addr *rip,
+			   int rifindex)
 {
-	struct sock *sk;
-	union vxlan_addr *ip = &vxlan->default_dst.remote_ip;
-	int ifindex = vxlan->default_dst.remote_ifindex;
+	union vxlan_addr *ip = (rip ? : &vxlan->default_dst.remote_ip);
+	int ifindex = (rifindex ? : vxlan->default_dst.remote_ifindex);
 	int ret = -EINVAL;
+	struct sock *sk;
 
 	if (ip->sa.sa_family == AF_INET) {
 		struct vxlan_sock *sock4 = rtnl_dereference(vxlan->vn4_sock);
@@ -1579,13 +1582,13 @@ static int vxlan_igmp_join(struct vxlan_dev *vxlan)
 	return ret;
 }
 
-/* Inverse of vxlan_igmp_join when last VNI is brought down */
-static int vxlan_igmp_leave(struct vxlan_dev *vxlan)
+static int vxlan_igmp_leave(struct vxlan_dev *vxlan, union vxlan_addr *rip,
+			    int rifindex)
 {
-	struct sock *sk;
-	union vxlan_addr *ip = &vxlan->default_dst.remote_ip;
-	int ifindex = vxlan->default_dst.remote_ifindex;
+	union vxlan_addr *ip = (rip ? : &vxlan->default_dst.remote_ip);
+	int ifindex = (rifindex ? : vxlan->default_dst.remote_ifindex);
 	int ret = -EINVAL;
+	struct sock *sk;
 
 	if (ip->sa.sa_family == AF_INET) {
 		struct vxlan_sock *sock4 = rtnl_dereference(vxlan->vn4_sock);
@@ -3024,7 +3027,8 @@ static int vxlan_open(struct net_device *dev)
 		return ret;
 
 	if (vxlan_addr_multicast(&vxlan->default_dst.remote_ip)) {
-		ret = vxlan_igmp_join(vxlan);
+		ret = vxlan_igmp_join(vxlan, &vxlan->default_dst.remote_ip,
+				      vxlan->default_dst.remote_ifindex);
 		if (ret == -EADDRINUSE)
 			ret = 0;
 		if (ret) {
@@ -3071,8 +3075,9 @@ static int vxlan_stop(struct net_device *dev)
 	int ret = 0;
 
 	if (vxlan_addr_multicast(&vxlan->default_dst.remote_ip) &&
-	    !vxlan_group_used(vn, vxlan))
-		ret = vxlan_igmp_leave(vxlan);
+	    !vxlan_group_used(vn, vxlan, NULL, 0))
+		ret = vxlan_igmp_leave(vxlan, &vxlan->default_dst.remote_ip,
+				       vxlan->default_dst.remote_ifindex);
 
 	del_timer_sync(&vxlan->age_timer);
 
-- 
2.25.1

