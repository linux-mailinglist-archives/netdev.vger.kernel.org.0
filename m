Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327394C82D3
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbiCAFGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232512AbiCAFGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:14 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2048.outbound.protection.outlook.com [40.107.102.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABEC75622
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+mhgJryRwHP9uandtyTGEVHZsZldXYqEDYFmIkv0/+46u8xvRxHPbc2rzW3+++F0HWom2yPAU1x2HLjTWdvwJMDE8l7452X5FBTzZiHTLXpl73e02V3kdjwDfoYxrimojaOe11BOg1WMcmEC5mtZSFmuBFis72xfH5m+Pk6lU+NasZn7pCx+ggULBpX50BCSx/55tejbwo3TFMBuuyKdiTMhJM/C7dCUmmraRMF31C8IGRUHo63J8n/uo6MktOCZYZsBQHvIVk6m6kUBjJ3h07D9S+aLRCfOHxQLFCkNchf5E66UPZhLuNl8xm4ktWI0cmtJDEHJDn92jLMB5vAag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p5vcIoAUV3yT/oJouUBIuGUFnVz5P+RRWhxmvwu2iJk=;
 b=cScvDLd0M+plpL9UvqGXarr8dsFyKUXoUt94Rbb+dmngPQXnqWMIrSJREyp2CaRBb4pKx/gk0vM33QUG8Hs2Qn3K7dpfPEjlWer7OuXZ7Kb6CGxskrGSGba+yeyn+B0hDFOXC3ryLzd2xCBtJm8HM8++FGKOy62AiDSh8pNjezFWb/Hs7fOlr3GKolu/sbXZj3cnDKX5u6Hn6qqk2I68LHZXj3MyQE7+CCaWB8sH4iS2jaW83F2GBj/1t3OsjkwvDvKKjlKHmQxO/2/9MKaUVJhLswnFAnQeR24Tk8X0ie0IJQ68ypDm/GgEtF+tH8QiWspYia9tYkgW+6JBPpIpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p5vcIoAUV3yT/oJouUBIuGUFnVz5P+RRWhxmvwu2iJk=;
 b=ZqxcgiLLRSXDGRzSzvptqa9DOQHMT9tUpDRwT9c7jkDfH1Jz/N9VLZCflMdVqRN5mMmClQI62J4nbizCgC26pbW0CYf5LH7nmBLsayrYBlocRs7TSqH/qsHebrZ/WAlJIopnD4+riYa8IWsGqzy0YWR+st+uoZ402RSHp1V9TAjttgGWePIufbleN2QuFH8Ql5cQog73DP8kp/ara98VTK+HA2sz90NtwBjAASRyPHlBJbVUpDbXoRQ75vwYKfihGRmIVDi0CfzQTo0YX1WGJOQ0gfDoDv1Lbmd8osHXYuASRsH2Y9GaRfMB1ZKb12NFCeHGpadsmubO3RIKUvuUgA==
Received: from MWHPR17CA0088.namprd17.prod.outlook.com (2603:10b6:300:c2::26)
 by MN2PR12MB3918.namprd12.prod.outlook.com (2603:10b6:208:162::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Tue, 1 Mar
 2022 05:04:46 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:c2:cafe::80) by MWHPR17CA0088.outlook.office365.com
 (2603:10b6:300:c2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:45 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:44 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:43 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:43 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 05/12] vxlan_core: make multicast helper take rip and ifindex explicitly
Date:   Tue, 1 Mar 2022 05:04:32 +0000
Message-ID: <20220301050439.31785-6-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 982d7734-9616-467f-3c7a-08d9fb4100d3
X-MS-TrafficTypeDiagnostic: MN2PR12MB3918:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB39183F486FC42C1C048B4D49CB029@MN2PR12MB3918.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRSRZNWtlJrXIFCahX/qJu1u3560HL4q2QbyG+35D4WK+M5d2RNuOVlfPiG5eq1BiCK21KTAIHwFoYlferF3ndjK552GxNfB9HVK5zX6MBRvKY/WrjQq5k12ZkVIhiUHVGFfVrcikfRxaUTEq9raGCJyCfXD3LMgwpJxPZ/UlvKAsyp1AkeuHuAZN9g1hs+7mbHYx5oiZJjnLj+DFm2CmGm1ofGX3ruiY21CjCMMT2ZN3XxvLGXudS5tQ42slxciDzGCX0dM++qx81spQrMVwkBdrAYszzuO7bmVez86MPUHZHeRLeqS/ANNMmW2N67R+r7RTnUfqxv0KyxMhVpx5kCcIUXSyWLs5uHoSYhMdGBDjwNWyd4sOy+pFDmEqoKKpFh4YYNwakGY/JkE0SgqEBJkiY5dn21WHv/Xmp+veF2hXuU7yJ2hHbrr9owgARxj7tdprjK6gViEf42NdtOXWs0hzU2WoCHnVwWEwoFRIwtB8z4IWluccQ1EzxZ326rTNzEizwZkpfPek9NASKjv5sgDKwkBmXT8X48NKdaxg3w6W1FQMBWxxujsOCbFJvcd4AeJFBaN5FEz+uXBXfLApxunOpmwpKYV3zdSJd3LHgz8FFrkV1sbw4Cm7XkD4aqO31CnQh4VSLPdZn1lkGtnUEAW42QcNrI0m6SENkTOsw5Sj30I3FxhKezPGgWMxdWvspAGr5/pfmGirPHiOHY1yA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(81166007)(107886003)(508600001)(82310400004)(40460700003)(5660300002)(110136005)(26005)(36860700001)(47076005)(83380400001)(6666004)(36756003)(2906002)(1076003)(70206006)(2616005)(4326008)(8676002)(70586007)(186003)(336012)(426003)(316002)(54906003)(86362001)(8936002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:45.3831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 982d7734-9616-467f-3c7a-08d9fb4100d3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3918
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

