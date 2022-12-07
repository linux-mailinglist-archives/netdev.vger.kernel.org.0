Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEAC64575B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbiLGKRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbiLGKQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:16:44 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2043.outbound.protection.outlook.com [40.107.243.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E15127CE9;
        Wed,  7 Dec 2022 02:16:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cZvjUsbUFLGPYifgJU8+oIH+Ey65s42WTFV5B1uyBttgQ21jHCMBJfuxbaTRFhhSlA+ovQ60+Zc/vxWNJ05MZ8V5jhxCxb9e9QSOzpiyqRkVQbV3GwJls+ZlkfQJOdEFi16dNjXLP0z1eOc4vpkLvcNGQSgh/CXNByxPa5/Vmxgcu1TfC+yBjbpjFqQh3a89hukn+cPr4+lI4BuEvlOdkhEqteXLf4RXdN5EexiAStS2AxZ/aFz3ZwCqOYHWY97gS6s6O4dnzvq1xn+heZB4M1YsdFzhWqBuX/4ZQ8xDtpKfobaI4KeNIpnsTgWJAzHOVWW82XQFpTtjM2oDXmmWEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gt7dhv2pW/5/6dT3CxspJemJ1HsRAi5H2KOA1MsgmkE=;
 b=a2SNo6OGlHfI+3cUfXU8ISOROEi6e6JnRgam7vzp/L+qCmRiFEOXxBa9UbBkB+rDTHuJTWgfrd9Oe0VBB1iLOBOcAgscwR1qrsjK/35wa6fgwD8kpa5rDQvM4r/5pfQG4FWodw9mTVM7THiU+2cIQtA4s5RDOtptw/z54wvjHxIh/YL4/uBXgB14V4Y/zvFXI3r88V5rioNRJHMIrDSI8kGOm9hMhSbsZ5XIgQOR8Usg9oS41o/ZuDvx9znvcuevxwKurRSpCgVYzh9+54TNN1bOK0F+sPLrLsXArgBrzgYonO8WX9YDfBTEEaLf3CF/u+QTkY8i4ebCiZPvSx02cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gt7dhv2pW/5/6dT3CxspJemJ1HsRAi5H2KOA1MsgmkE=;
 b=rdCz2sw1KSCAF4NFmPrmsSm+RNxwyCVwTKKLls1k0Wg+G/RYXC9KibxatjKSDFlSP3DonhZ6IpFZeT6AvFvWl8O4LPwhEgOIylyTzUE71Z1CzAnjhO807RZGlpaSMzCLllcl6tCXL5hvMdRAURBZMez3HSndk/MaIpWoY1l0JURh5htEgixaFnnUkUvJR7LvGZOJGEZQ9Rng3sa4BVf3l8cb2PoBAcqRIp58lzF+QlMfQF9JShrCadHEEU0ZZ6Rd31LVTotyeIzu0cadO6PxjK8tsNO3yAJcbZSjDTt3h+kgPLoey1n6+guUHSnBho1FzuEOmqUU3r1Hu7xOY/XS3Q==
Received: from DS7PR03CA0060.namprd03.prod.outlook.com (2603:10b6:5:3b5::35)
 by SJ0PR12MB5661.namprd12.prod.outlook.com (2603:10b6:a03:422::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 10:16:40 +0000
Received: from DS1PEPF0000E641.namprd02.prod.outlook.com
 (2603:10b6:5:3b5:cafe::ca) by DS7PR03CA0060.outlook.office365.com
 (2603:10b6:5:3b5::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 10:16:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DS1PEPF0000E641.mail.protection.outlook.com (10.167.17.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Wed, 7 Dec 2022 10:16:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 7 Dec 2022
 02:16:29 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 7 Dec 2022 02:16:29 -0800
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Wed, 7 Dec
 2022 02:16:26 -0800
From:   <ehakim@nvidia.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <raeds@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <sd@queasysnail.net>, <atenart@kernel.org>, <jiri@resnulli.us>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net] macsec: add missing attribute validation for offload
Date:   Wed, 7 Dec 2022 12:16:18 +0200
Message-ID: <20221207101618.989-1-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E641:EE_|SJ0PR12MB5661:EE_
X-MS-Office365-Filtering-Correlation-Id: 93cebb62-54ae-49f7-8f22-08dad83c21a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hWlge+WZTGtzML2mf+nUsgI47HzAhzrSA3e8K/gKGt9GVMqPHV5UO+rqpbQrsty2xkmLww0MRd59a1q/OY2RZzENV0xGx+PDTuOEjxyHJQzVAKmCj+XOXb876yF2BruzMXJK/PlFZLuKWNXdJqlbAjXruUbBRlSkbaACx0W7MPq0y+ZjU9z7ZHK7OeBzLQB4BMCH4R0InSVTG3by8AUM0ePj2SC0d7QORP8s/aggl5JK5xN+ZsqSe0i3Jcrj0FgMFHFAfuxaZzezlyInpUqAIFISiXl2oFJiCXXV5QzNLowdwac5bOuXAfW8gEh+eIqkSquzdhSPjr2EwU17wHVLZNzyfDLP6mT5x9136zPs4EcYBvmWIl9R77AT20prYQv7EKwbMFl350KzltmvJQtIEv9qcay9Kqc067npt3iro9OsfwHSPgOnKGUShjRfrqUoSEK1In6wBprOlJsq1oeRUc8S2Z+DZnGMz+5Z/W9Pb12gg88Jw1aRjACmV+NOBbbnCSCp4QEstK4Jw4ZmyvyptV7WcUYIOMJuhATtIQWCmkA4ZjWcgEdoctyJEzjoDkwFlBWnlmXRNR7yG1luE2JoOoeWvSIt8TM10PflIERXCasMg9MEfuG8SAzSfuyNHZqlFOLThpeBMlTsz7MWlXpmsXmaePIqx4qBB1dgII9rw/Y1r1yqrmO5X3l8spGMM/lneGdFHA6P9e29LV+DnYYVgw==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(396003)(136003)(451199015)(36840700001)(46966006)(40470700004)(47076005)(426003)(86362001)(82740400003)(7696005)(478600001)(40460700003)(40480700001)(36756003)(8936002)(2616005)(36860700001)(1076003)(82310400005)(336012)(186003)(7636003)(4744005)(356005)(6666004)(4326008)(107886003)(8676002)(5660300002)(26005)(70206006)(41300700001)(2906002)(70586007)(316002)(2876002)(6916009)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 10:16:39.9337
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93cebb62-54ae-49f7-8f22-08dad83c21a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E641.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5661
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emeel Hakim <ehakim@nvidia.com>

Add missing attribute validation for IFLA_MACSEC_OFFLOAD
to the netlink policy.

Fixes: 791bb3fcafce ("net: macsec: add support for specifying offload upon link creation")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index f41f67b583db..2fbac51b9b19 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3698,6 +3698,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
 	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_OFFLOAD] = { .type = NLA_U8 },
 };
 
 static void macsec_free_netdev(struct net_device *dev)
-- 
2.21.3

