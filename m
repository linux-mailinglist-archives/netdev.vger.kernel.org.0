Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422174BEFB3
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbiBVCxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbiBVCxT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:19 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3F225C70
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qa+QXSS7SG3CyU4hH9EGMtlBmEKLAoPPWL3aeR3JpyP6q/AMOBcaRAWj390E1o2Yn4bQ1+fgu8YRnMXd6q46KTLXWvmVuGSKZ9LT9G0FrN+PHAcgRP4Mn+vahpirZbPeRAsOnVhsWISznDPEgRHXjI4EnpmW8tJJttlZpb/j7jiDlk7vF8WAqUGF2KE7Vq6RnjO5vonhtyqzdTp14IUK0ASz/WHuPgSAOr6itbK7GfxJ8m3TK0u4s/nsiEe8KtXWipRBp/Fu2aY5mueOk/2at2A0a7amaS76qJygiWc9Vp7Sdavw/glGj/ao9ObADbDEkPHm2CsSX5Df71ngKlaMiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M0UcotvqnOF7rrGpgVPOWrOzyGiBTzwvcayRF3Ps7BY=;
 b=ljjCiaQIKfP5hRA1pn2giTHCc3ODuxGyqtGspYcKcrlCeNOujQe6URuyIAxA4kjY2kK73tVJlrI4yLMulErFbZMIgf4/Mn1zYpXLkmkTTIY7UrWmIYzsPFtQDvBrPite8oHCPA0ye0JwoA7pccAIENlKXwuKHwPwqvKbnHAgRztIuekxHVy4paxelEJjcaPcd8ZRhmVA30SXF4GJ/KOu9eW0QhNK5inBUvNWQzFGeU7y95xj5rHG3v/q8ej23fu77Skjux11lnq4Q3JHh5+T4bMWPZlSGGjJa+jMZDUn0etltyG4gIv2/JoFWWCws5Cs8Nh3kssoEm1u4pB9p4pwBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M0UcotvqnOF7rrGpgVPOWrOzyGiBTzwvcayRF3Ps7BY=;
 b=nA/OQdh3yrmc82bGFK7vFiscsI5OK15ZRqoyX2vf659LxpgOlLrSREyCEg6jTFKW8Ntnm1Yk3bFAXLU732Y2GLRLcxQbWEI7GXrK+mPI6Q2IbnXCqOL9mNaz3J9oylWwkbkJGIuVvhofu3BYXytXtNKC3m8jOgmdpYVou1UIc8uSqyKMbTVjSyZh/jsJimMWvMc+vCHAKk6fzl9A4yq5USTQgCGc7hkUM9X7Fzgk4+wsW2aVNwkGWoIuQRwJekyqBpgyIC+3zvrcQEwwSzCiRzKeqXtOd6oluFwWnvzst/zIRPyj5pdvLKJkKbcI0rfJ7hoXNH8aHGvb5NSErbRftQ==
Received: from DS7PR05CA0066.namprd05.prod.outlook.com (2603:10b6:8:57::11) by
 DM4PR12MB5745.namprd12.prod.outlook.com (2603:10b6:8:5c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.17; Tue, 22 Feb 2022 02:52:53 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:57:cafe::f2) by DS7PR05CA0066.outlook.office365.com
 (2603:10b6:8:57::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.8 via Frontend
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
 2022 02:52:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:52 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:52 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 06/12] vxlan_core: add helper vxlan_vni_in_use
Date:   Tue, 22 Feb 2022 02:52:24 +0000
Message-ID: <20220222025230.2119189-7-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 059d8313-32b5-4223-1c49-08d9f5ae6c4a
X-MS-TrafficTypeDiagnostic: DM4PR12MB5745:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB57456F7FF447208B489C2766CB3B9@DM4PR12MB5745.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uzSYoAwffxy5/HcEeRwxMUvtnO9rGNheeHtw+R7fnri1bIkylW80G3eBbHHxsZBfCEj92z7saV9OjSpMNNIC3z4yh5KiMVVVLJJSKqPaCVltIqbZgh5NEvNihBhVEIDG3WLD9+L84N2TKCEB+BIikQCtXI+Sgs0agoPTNhhsm0lLcTD4pME/y54Ygi4KkeTofcY8o0YSka7Vi67S9EZKwIiGY1PU5BwzadXGuBy1uAoWgr+3+J5DDp57sWRUQXUeKUoCuoUG3n4bT92BRtwptlt/M2P69Vx2qAvMfTawwEqWUl1U9VT+bdY5/z73uR3XItYFnB1isaeV2bJ+xL8E+/131NOsm/v9huUdieP4WDfZa7zqnWWVU0GDMkBkX0GVaLqD2srpFtvcn7rrguvklM1KOXXaXD3d6d5EstG0DELi+XUjRDbUI+YTbsHR3Cw/vuu1lSVyDwHdhRkbYJXdwL0F9a/rOiqFj6eM/577ZHYxC6kGznFLiKdxLL/hOwUZGqmasnhZT4cDastC3BJyaUX+xaDTEBoXal95qTwNj6yPCUvC6Vn+fu9E0NAimT3Fx1vSQXJBxNcXaL3v9X2esLr4x+x2UH71vUvd1XX1sn2tEy4v937/PkRmRPoL+RyR/uHGLFYmVokzMSZUJrC5mJw7tnv6a/lOvIc8SozQlYSGdNYCKXVoD4jooaeEZKdU9JRXcz72dItCG2Q4KuU3sA==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(5660300002)(8936002)(186003)(26005)(426003)(336012)(81166007)(2616005)(356005)(1076003)(70586007)(82310400004)(107886003)(8676002)(4326008)(6666004)(508600001)(47076005)(54906003)(36756003)(110136005)(70206006)(83380400001)(36860700001)(86362001)(40460700003)(2906002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:53.8296
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 059d8313-32b5-4223-1c49-08d9f5ae6c4a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5745
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

more users in follow up patches

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 46 +++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index df8ef919216c..8c193d47c1e4 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -3554,13 +3554,38 @@ static int vxlan_sock_add(struct vxlan_dev *vxlan)
 	return ret;
 }
 
+static int vxlan_vni_in_use(struct net *src_net, struct vxlan_dev *vxlan,
+			    struct vxlan_config *conf, __be32 vni)
+{
+	struct vxlan_net *vn = net_generic(src_net, vxlan_net_id);
+	struct vxlan_dev *tmp;
+
+	list_for_each_entry(tmp, &vn->vxlan_list, next) {
+		if (tmp == vxlan)
+			continue;
+		if (tmp->cfg.vni != vni)
+			continue;
+		if (tmp->cfg.dst_port != conf->dst_port)
+			continue;
+		if ((tmp->cfg.flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)) !=
+		    (conf->flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)))
+			continue;
+
+		if ((conf->flags & VXLAN_F_IPV6_LINKLOCAL) &&
+		    tmp->cfg.remote_ifindex != conf->remote_ifindex)
+			continue;
+
+		return -EEXIST;
+	}
+
+	return 0;
+}
+
 static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
 				 struct net_device **lower,
 				 struct vxlan_dev *old,
 				 struct netlink_ext_ack *extack)
 {
-	struct vxlan_net *vn = net_generic(src_net, vxlan_net_id);
-	struct vxlan_dev *tmp;
 	bool use_ipv6 = false;
 
 	if (conf->flags & VXLAN_F_GPE) {
@@ -3693,22 +3718,7 @@ static int vxlan_config_validate(struct net *src_net, struct vxlan_config *conf,
 	if (!conf->age_interval)
 		conf->age_interval = FDB_AGE_DEFAULT;
 
-	list_for_each_entry(tmp, &vn->vxlan_list, next) {
-		if (tmp == old)
-			continue;
-
-		if (tmp->cfg.vni != conf->vni)
-			continue;
-		if (tmp->cfg.dst_port != conf->dst_port)
-			continue;
-		if ((tmp->cfg.flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)) !=
-		    (conf->flags & (VXLAN_F_RCV_FLAGS | VXLAN_F_IPV6)))
-			continue;
-
-		if ((conf->flags & VXLAN_F_IPV6_LINKLOCAL) &&
-		    tmp->cfg.remote_ifindex != conf->remote_ifindex)
-			continue;
-
+	if (vxlan_vni_in_use(src_net, old, conf, conf->vni)) {
 		NL_SET_ERR_MSG(extack,
 			       "A VXLAN device with the specified VNI already exists");
 		return -EEXIST;
-- 
2.25.1

