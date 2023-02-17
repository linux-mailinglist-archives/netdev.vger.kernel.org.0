Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA5D69A46B
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 04:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjBQDkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 22:40:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjBQDkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 22:40:01 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56083B857;
        Thu, 16 Feb 2023 19:40:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JidHVTilbipzgri+4b94ACMPKfvTLRPwNMkSkG1dwC73HC/Q8A/PC6GOjcDs/uY95FzoO5hKydcVGBtmPJt4GqRkZvX0f2l5P63Xs8fJ6JpL4g/hAGj+nM+IeWSCkrbXm+azpIUMh2jdj0BdH7lJg8TIAKxWXGQOSD9VQqm49GQH0X4G2TiaRtSaUX3GA0FaQgZFzIY8QyMmfMmaRJN/zIczcdPgNIDIouJma3HAFXyFEIZY+PkITO+rHLyDXlN6wcWstPYJjGfimqX5j5Mk8dX+sYPQCkpqr/CWBIG17mwQAhOXT7XnkCT9M/Ojn+pxQ0+gPt1aUFs7JP9xKuFkXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DP6KBrTCW9IDFLyQlWF4wk7iQ5RxjbmtDNxyDYA5wjw=;
 b=eicg4OBZ3Ax2U7TK/OkfB66LFxerzeoNKxPbnC3F9+O4Ot/wp5GrUjM2RXmN4JKp0XkcBhZiRrmo72zWLhHgse/3KB39/FGeXu/0vamXmsWPQCkmhnTEvnrvkVpRBM11LOTBGwmgSLqwe1AqyY3HytBUXmy1r6U1uzUuReVMtNco7NyuwMnW9CmtM1kUAnQBoNoBkCPsbNwJdMlgXzNWQVOWt8+82yJXpgb1+3vONTpY/9PDLyy8758oa/9MbrAbr6ZsF/z/eXwvfZQ4LbNZNrwXkaEjV6pP73y7t4hD+JXQJrh7vjihovaWWBA5vXoX5G7YVQR5YjNY4y+ksJejpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DP6KBrTCW9IDFLyQlWF4wk7iQ5RxjbmtDNxyDYA5wjw=;
 b=IHz4PltutqPF5z+aCwOmEsZ0y6fERkpw/zwN5F8cRBjMspr++z86KJIBtx/zOMYfE3QuAhYyzMuZ61fcRpT5e1fhc3krvoelYXg8wXkP6apY25IooG+oUL0ZeicQgJr8mJAXzWRBjAw5PwuAstExuHfdjNGBAl+LfyQljT4l4apWb8M70U+aOXAGr0ZaW+4GLYPbRQN3sU9T/OILPOeRsUTtadv447Jmdok0SORhVsowjm659/nT3fMOHRKtUF62HheyR1FDPku/wX4+WRXQ43dwGl8C5A9EzCClvQkS2T6Bs1IrUpaba2zcFXiA2OfeN24aasiour9Cj1WnMgnUVA==
Received: from MW4PR04CA0119.namprd04.prod.outlook.com (2603:10b6:303:83::34)
 by IA0PR12MB7724.namprd12.prod.outlook.com (2603:10b6:208:430::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Fri, 17 Feb
 2023 03:39:58 +0000
Received: from CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::f2) by MW4PR04CA0119.outlook.office365.com
 (2603:10b6:303:83::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Fri, 17 Feb 2023 03:39:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT084.mail.protection.outlook.com (10.13.174.194) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Fri, 17 Feb 2023 03:39:57 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:52 -0800
Received: from nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 19:39:48 -0800
From:   Gavin Li <gavinl@nvidia.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <roopa@nvidia.com>,
        <eng.alaamohamedsoliman.am@gmail.com>, <bigeasy@linutronix.de>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gavi@nvidia.com>, <roid@nvidia.com>, <maord@nvidia.com>,
        <saeedm@nvidia.com>
Subject: [PATCH net-next v3 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Date:   Fri, 17 Feb 2023 05:39:22 +0200
Message-ID: <20230217033925.160195-3-gavinl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230217033925.160195-1-gavinl@nvidia.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT084:EE_|IA0PR12MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: a91eb9c2-064d-4c2d-6826-08db1098a437
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hq+Z86nQ7zBpxJsIOpBMdqFEuXwrJBtHYCBCMTLgNWxpAtOLpA9netv0bbgkU0+iL2WZ+l7vV9ZtJGsbfBi99EPFn5TPnOsUZyDY71hQJfIeNoHnknyr63btnGVlEqz06NVwrDWpF2II5jjqZJulttbKkzqRfI4aQUgpr72TUCHC354ENXO9DbdKapjfDi/2+uIzXbL84gwkM57niEuIzIohWf4kR8PXLq56+su09aRYTAHIUDvlGPmeGBJfGSEOb9/ZHsaBbNUl4Rrb9LgYvWkhp+YVzoIfJLpm7gr5dSM6/eETZ9xlJGFkJzKEjMDFm55IpvBbU4eZWdxrOnV+iwyDO0/DrYiU2/qYe+qoQz56r6xI63GfQG26UzNV2gGH7uealAsw3o54F+/cMsH0Pe9SVEmVenWJH34ry227vyfcZebCE12MLEkdoxOv+fQ3Q8j4jyYiVXlnPCmA86dsg3KGNomMxPvi0jSvuX4kZ1OlpOukv3UYsD3KkvnwyPnRt4NQbuz7pxKC8dVN9NobsvaskAnq/lrbHsAkwr+MzCrBUdl7Dvzd9KAuwezDCT9AZelpyn8rvz5RFptyW4/mGL7rcLWh8nvaEQ98TF1itrV6F2k+t9zOdmY77C8BMq5qnflvVcAzKjHLBA7Kco2tny2CKKEREhTtqV5/l/c2PGizN1OjTAAeHzR3ZjJbha1gCjupsg1p5g8SiLkGxvrdYw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(346002)(451199018)(36840700001)(46966006)(40470700004)(36860700001)(7636003)(82740400003)(2906002)(82310400005)(47076005)(83380400001)(426003)(336012)(2616005)(86362001)(478600001)(107886003)(36756003)(6666004)(5660300002)(356005)(6286002)(41300700001)(186003)(55016003)(7696005)(4326008)(70206006)(110136005)(70586007)(1076003)(54906003)(316002)(40480700001)(40460700003)(8676002)(26005)(8936002)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 03:39:57.8287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a91eb9c2-064d-4c2d-6826-08db1098a437
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT084.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7724
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan_build_gbp_hdr will be used by other modules to build gbp option in
vxlan header according to gbp flags.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Gavi Teitz <gavi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 19 -------------------
 include/net/vxlan.h            | 19 +++++++++++++++++++
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 86967277ab97..13faab36b3e1 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2140,25 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 	return false;
 }
 
-static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
-{
-	struct vxlanhdr_gbp *gbp;
-
-	if (!md->gbp)
-		return;
-
-	gbp = (struct vxlanhdr_gbp *)vxh;
-	vxh->vx_flags |= VXLAN_HF_GBP;
-
-	if (md->gbp & VXLAN_GBP_DONT_LEARN)
-		gbp->dont_learn = 1;
-
-	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
-		gbp->policy_applied = 1;
-
-	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
-}
-
 static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
 {
 	struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index bca5b01af247..b6d419fa7ab1 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -566,4 +566,23 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
 	return true;
 }
 
+static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct vxlan_metadata *md)
+{
+	struct vxlanhdr_gbp *gbp;
+
+	if (!md->gbp)
+		return;
+
+	gbp = (struct vxlanhdr_gbp *)vxh;
+	vxh->vx_flags |= VXLAN_HF_GBP;
+
+	if (md->gbp & VXLAN_GBP_DONT_LEARN)
+		gbp->dont_learn = 1;
+
+	if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
+		gbp->policy_applied = 1;
+
+	gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
+}
+
 #endif
-- 
2.31.1

