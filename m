Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06F294BCEEB
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 15:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235720AbiBTOGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 09:06:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243936AbiBTOGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 09:06:19 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E836335877
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 06:05:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWbbuKog/qfeqDwubqUpya1qlkOh3NmqMbgzRpKOmOcmMkdPf81Ox/989PE6vSv6dQefoRbXfierlHNaJcXMeGbv/QBhdo0hh5qn0IKXhsmyUnKMkctfwD4xByHRGzzYqjzvdDfxe7R9UXFyE6VasHWU0mxszlKLrN3D+HlTI/jzsIgr87hxt/KQI/PCSTlTVIe1PZpPL0LQ7vd0nNFsiOp2Q95ChyCTtPuZUR05p7Ru7jUsNDVEse4Xz4CVmpU0Wi3EoGlTyi0lsw2cBgf5yB5Bc7uGmL6Ie7SlmF+WokoXqHkSrtukHaOrKDjUU5pRhZzrXmQfSGhW3jssK7krsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9v3fUfqKm5sjK0UQKwu0KK7jjOnUKs3wLcPhNkb/8F0=;
 b=lSuJAZwfQtLLWSmTkqCj5fJxpSlYCNTCmp6fAAbbmHsAZb5XHZhTecoGLMAagsttDJFkxSysE5Nu3ZMgnofSNGWbufjm9PMfki5F3aU+5HKNR+yuREuOvl6oZUBOeZyveqgunDvRZVsxPuVksBcu4nxSajvhtsBuPSMlgWyqH7X+cQp5uKi1P5hx4+PHULdwy8sPG4DJrDUdIaCz8yKSJlr9nI3GZ07jvk7MrVDwCOVMBsPrsx4fD6D2TZtxK29GEeNFm+Zs/RaX9zXxnKAfT6JcKen2vRgJpcUXhwAOo2CHfhIPXC2tJMS3M0D0SJ4p8Bgyo8untiOFe+hnEQ/bqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v3fUfqKm5sjK0UQKwu0KK7jjOnUKs3wLcPhNkb/8F0=;
 b=t8caJFSUquQiGPO0rdg0u0iljzoinKrlfkxaUUFdRi3JJ1cNOZQ2Ct5/Sr0kZ3BokaWiZ/TZpw+jEw0eIOS2uB4B0dk4T75HzInLNoY8euRFVRgCXAFII5fHo+k8kd8V+HqTVy7iG+/X/3sVd47sikB6tULDM/SdgG2FRsPvkRIw6AeCuWJClVA1N8rCtW9wNwI4KhcvtPNkcl1JtzTrFwv+isx1D+3KBr40TBsiY/UstoEQG6hq8735UTInA83UUO4Dhn7dzCZfeaOizBN1MhlrOz3HwUTWxZKvIv1i1CJCD8NNRTr5sa4ELAuAxtmSFBG23Cx49BT5RpaWHbw4yQ==
Received: from BN9PR03CA0113.namprd03.prod.outlook.com (2603:10b6:408:fd::28)
 by DS7PR12MB5981.namprd12.prod.outlook.com (2603:10b6:8:7c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26; Sun, 20 Feb
 2022 14:05:49 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::9f) by BN9PR03CA0113.outlook.office365.com
 (2603:10b6:408:fd::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sun, 20 Feb 2022 14:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 14:05:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 14:05:34 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 06:05:33 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Sun, 20 Feb 2022 06:05:32 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>
Subject: [PATCH net-next 04/12] vxlan_core: make multicast helper take rip and ifindex explicitly
Date:   Sun, 20 Feb 2022 14:03:57 +0000
Message-ID: <20220220140405.1646839-5-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220220140405.1646839-1-roopa@nvidia.com>
References: <20220220140405.1646839-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42968630-c3e8-46e2-43f9-08d9f47a18db
X-MS-TrafficTypeDiagnostic: DS7PR12MB5981:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB5981E117E2E6BD97C3E5683DCB399@DS7PR12MB5981.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iSBInLssGMPpXeC8HX9mJMIqKfbbHRa7VCgllAqLd/q4wLTVnNqgCmDW3paMDBv1eJqZpSzs3Fcmnxw7l91mh7DIsTdjLQS6kLE86P3YwOP1S2K1pNRHc9QbZtYAcKm3l3wrQXBTy8AD20xlQSpp+KV8/hKDUq957zgrCzl3M6KfJ7bFrBiSfDW28VzjzYwm5V9vtQyEtI6rLi4auLKcOoqjgMpxBWhbcuu6al+ftIYLHMV1hdBJ5xFQ70lhWrjHLcb3Ea+TXEaxxUcilOeLhvhRg/hBsAZY+sOxWj2i8Wqv2XKMkutPVKCadi4KKyIxJTyhWxWcd/B2ZkELEW60V3d5QTXcs2sEdxMO50vG66kkh6OVE1kSoTYei5gKjxQtMtdIeyT6c9sRBFSc2eFdSnL2R2eroNdigKzaWsMH3YedN9tSyRqq4HxNOLnYZshl8lvO3y910nqZ/bEcmvlCEIFLF9o/VGfMM8m7sAzwS2KrlqdXdfWtzJBXGeepclYBAL8Nj0lpNNQHQtSylmb4+aU3J36naAM8crC6fnvrZK7KzfzQ3suOGLHfPwBkw929Q1gTkm0AyPr27ebNcmwEM7TyIs47vjU7WQo9xtHFT4lmprVSmo2MGuSiYuP+J6x5/b1Uw8p+8cDu3adoHl9SQnFEFe2JsH4PppkuQLwZhd7AmA/l3RWwPlDVI/iu2LFW8F3V+o601GZ0tLtJYKv2uQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(356005)(4326008)(70586007)(70206006)(26005)(186003)(8676002)(2616005)(81166007)(1076003)(8936002)(54906003)(2906002)(110136005)(36756003)(5660300002)(40460700003)(316002)(36860700001)(83380400001)(47076005)(86362001)(426003)(336012)(6666004)(508600001)(82310400004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 14:05:48.6721
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42968630-c3e8-46e2-43f9-08d9f47a18db
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5981
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index c4e76c5c3b9e..3f3e606c3c7d 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1445,8 +1445,11 @@ static bool vxlan_snoop(struct net_device *dev,
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
@@ -1481,11 +1484,10 @@ static bool vxlan_group_used(struct vxlan_net *vn, struct vxlan_dev *dev)
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
@@ -1545,12 +1547,13 @@ static void vxlan_sock_release(struct vxlan_dev *vxlan)
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
@@ -1578,13 +1581,13 @@ static int vxlan_igmp_join(struct vxlan_dev *vxlan)
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
@@ -3016,7 +3019,8 @@ static int vxlan_open(struct net_device *dev)
 		return ret;
 
 	if (vxlan_addr_multicast(&vxlan->default_dst.remote_ip)) {
-		ret = vxlan_igmp_join(vxlan);
+		ret = vxlan_igmp_join(vxlan, &vxlan->default_dst.remote_ip,
+				      vxlan->default_dst.remote_ifindex);
 		if (ret == -EADDRINUSE)
 			ret = 0;
 		if (ret) {
@@ -3063,8 +3067,9 @@ static int vxlan_stop(struct net_device *dev)
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

