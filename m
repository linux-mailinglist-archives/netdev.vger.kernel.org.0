Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBEC74C82D2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 06:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbiCAFGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 00:06:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiCAFGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 00:06:15 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F2E75C02
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 21:04:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hr2PpQhGMLTnnyJRizTh90t2z16Ne3iNUhSlPcYdDzo8yLQmK+1QjMctEZ8EHptnUjn9UXx7yt+mIp3qNJpYrQkb9RAnQtMPp/R0Yyogg8khfn4W2R/C8HZMeJcH5DfF0/SyjXukEc3HEESGMNFdCkfKDtZfPunA8xPvHL1GkCDATWPpTTDWZ1Dr9nlXyEZVWGEtiFQvcG6qVcGwuhjIlyzXKahacjFPm5uTPSIGIfYnjKKpc/zSVyDQSrU3vaNtUmujjl9Edq5lZxdUGxacswS22TOYlAcX1WkbABb0P3wto/6ZfPEPavymt0M1VmPyDUgDWXXpy7EE1S3gkJvwMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MgEAz2kTMQr8grpBFKaWJtHcY7t5mEEEsgUpOtw9Xkc=;
 b=amXr58VtsORM/FT5UZLtNSDU91ViCUHlzMsS4hQTHI33B7wn66Fn1qUJ+5Sc9jR4uB0AzkYqH0n3yxXzQLKswJOnUaYCbfU7G2gp9mSi6bVbKIgcwwhjeepQoasatyvNVKvqBuELuZCAQor1fv6kx2tzb7qlVNPRVZbEPvQTIHtWktsCtoRbzB/JVSqg8a+roh+8Ruh6dSUm7zNg6sXVNdojlQf6WXu/JRd01sJ/o/BliMFiDHyG1w7ixDyiZDrFeOZeAI7RykiIuyKRCnGFG98B+YURuAELAlK3fS0h48JGZEjrxEu9YwiDLeFeBIurFqRFZ7yiGvL63AdM0r7Oog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MgEAz2kTMQr8grpBFKaWJtHcY7t5mEEEsgUpOtw9Xkc=;
 b=ctAB+Z4DdIwyOAQJOjyWURtTWL8vBLtkTpy82JTPIxYVbcA2MglZUTSWZpXSECNBGbjU0OGoPE+mupUoekP0HHlh0LcejxFN971EG9lroKvQtqHm79iWLrwytTmY1eIjTSjRHOWe1mNc5/gSMr99ePQR4t+pZ2YxBXT8nQ2VAvdIX3UsW6N0SVC+JIn7lY2zXw0s7eJWafNUSXHAvwFptwDXi1MrX96QOkYCf6+uneXvCwhEt6U7XaUgHTxrh54t+seG4ygdaEN7HfczdAwNOXCqV4LegZQHNVyp7YGjQ1AtPTMKSbHvBbTIkvGbe4pSYU1vihxpKBlsVtaVZYxc6Q==
Received: from DM5PR07CA0113.namprd07.prod.outlook.com (2603:10b6:4:ae::42) by
 MN0PR12MB5884.namprd12.prod.outlook.com (2603:10b6:208:37c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5017.22; Tue, 1 Mar 2022 05:04:48 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ae:cafe::14) by DM5PR07CA0113.outlook.office365.com
 (2603:10b6:4:ae::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23 via Frontend
 Transport; Tue, 1 Mar 2022 05:04:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Tue, 1 Mar 2022 05:04:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 1 Mar
 2022 05:04:42 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 28 Feb 2022
 21:04:41 -0800
Received: from localhost.localdomain (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 28 Feb 2022 21:04:41 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v3 02/12] vxlan_core: fix build warnings in vxlan_xmit_one
Date:   Tue, 1 Mar 2022 05:04:29 +0000
Message-ID: <20220301050439.31785-3-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301050439.31785-1-roopa@nvidia.com>
References: <20220301050439.31785-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: df193b5c-12e1-4931-f0df-08d9fb410255
X-MS-TrafficTypeDiagnostic: MN0PR12MB5884:EE_
X-Microsoft-Antispam-PRVS: <MN0PR12MB58845FEB9793E7FFCC0DCAADCB029@MN0PR12MB5884.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bpj1SoPswIq3iUJOPsCN+0VX87Vke4EDm+DQrmwpPsaAoUkZe9cGF8bm9A+aoYNIUdouw4jdhJ04YPC9voqhJ6zFC+wqfVBC+vT3o1ZIo39SRqhzBauFWvjlyUkNwWEBvPlhtDXIddXO4D9pppC4rejeri5NDzYRdgP0HC3YuMqv16wSG1AZthG0cylLnolPZb9oFZ1nFRrn/QctoIEgPxartjRzSi+TxpA8JcBpNkq0zM8LOD27kO70wBC7bMQznquQrggFNkseB8f724s7Gaz/iodA1B5aFY2fv/oUWOMn7Udjg44xBeEAnwAovFflmw1Lgro3HTTcC6KLPqQMA+F+JQr3FJiYcFnXUlOpcTFahrhTxg/zyTqJZAJ0wzVylwns1Al7AgwzTzv71bnmB2lSiPEAAfOobz9MhfNTjcS6uMjgsmSGwkonaXIrEyP+Iy4/fwIgju6fXT/UfNlJykAC/++lf0RjRoDaZym2xyi1mMTxmIlQwD0k1cGnPu9HsxmDapK1CQeopRhbTBn4sooUhaOxuy1c+TkzkuCBU5vBHkQba1IfbcyTuXSZPBbtIBcSFtfW+5BqQ9d/cDkC97Zgq7Un5RGOsx87BD02SKWSON1nTcF2uxqRAHgFo2YrkPZkNoElFDiQd1GiCu5ehHKvRRS7Vy0EoIzkmi54Gucnan76j6+GmcVZPd/m+05NlRbcXKr7m9z4tyauiheZ4Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(36860700001)(6666004)(508600001)(36756003)(8936002)(47076005)(4326008)(70586007)(40460700003)(8676002)(70206006)(186003)(5660300002)(2616005)(336012)(426003)(26005)(86362001)(81166007)(356005)(82310400004)(83380400001)(107886003)(54906003)(316002)(1076003)(2906002)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 05:04:47.9174
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: df193b5c-12e1-4931-f0df-08d9fb410255
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5884
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the below build warnings reported by kernel test robot:
   - initialize vni in vxlan_xmit_one
   - wrap label in ipv6 enabled checks in vxlan_xmit_one

warnings:
static
   drivers/net/vxlan/vxlan_core.c:2437:14: warning: variable 'label' set
but not used [-Wunused-but-set-variable]
           __be32 vni, label;
                       ^

>> drivers/net/vxlan/vxlan_core.c:2483:7: warning: variable 'vni' is
used uninitialized whenever 'if' condition is true
[-Wsometimes-uninitialized]

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/vxlan/vxlan_core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index d0dc90d3dac2..a852582e6615 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2603,13 +2603,16 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	struct vxlan_metadata *md = &_md;
 	__be16 src_port = 0, dst_port;
 	struct dst_entry *ndst = NULL;
-	__be32 vni, label;
 	__u8 tos, ttl;
 	int ifindex;
 	int err;
 	u32 flags = vxlan->cfg.flags;
 	bool udp_sum = false;
 	bool xnet = !net_eq(vxlan->net, dev_net(vxlan->dev));
+	__be32 vni = 0;
+#if IS_ENABLED(CONFIG_IPV6)
+	__be32 label;
+#endif
 
 	info = skb_tunnel_info(skb);
 
@@ -2647,7 +2650,9 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM_TX);
 		else
 			udp_sum = !(flags & VXLAN_F_UDP_ZERO_CSUM6_TX);
+#if IS_ENABLED(CONFIG_IPV6)
 		label = vxlan->cfg.label;
+#endif
 	} else {
 		if (!info) {
 			WARN_ONCE(1, "%s: Missing encapsulation instructions\n",
@@ -2674,7 +2679,9 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		}
 		ttl = info->key.ttl;
 		tos = info->key.tos;
+#if IS_ENABLED(CONFIG_IPV6)
 		label = info->key.label;
+#endif
 		udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
 	}
 	src_port = udp_flow_src_port(dev_net(dev), skb, vxlan->cfg.port_min,
-- 
2.25.1

