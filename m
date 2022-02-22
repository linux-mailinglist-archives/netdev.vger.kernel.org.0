Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2854BEFBD
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239362AbiBVCxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:53:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239327AbiBVCxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:53:17 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7898125C70
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:52:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TPYcOEJoN+JBWFn9Ouou3Juz8H+qPqyLC6NYFFeR9/Lt0LRVNs/NPAUEIey+NpxJe8S0dElFCAtvSsNQC6Kernvx9VyPAV/4n/pi8XMgK9oeOumzqaBCo53gC6LnTBZNgjscSJbYHcFkreyxFJUl/F5VnpBa0dWyELK008a6fcVj40h13EjDxs2VpSDVwcc7Arud2FpBVsSPHSfwMpgF/RE096AHD0JjUIpwqzT5s/wkPGsdTSjXACyM+t20xfuvqQ0yRtf8p3q1MXnjOidjvbIvArY+scIqrFEtwYYvvaQkMa7hrwtzwyTwXojl8Aij07t3D1nTCIG8p4xEQtgoKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2esf111GtPrgylCZ29AWW/U6CAr1xnDY7ueoVOsBtvo=;
 b=nMnJ2kqMoBnxS4D2JALe9Y+jgGaMFgMY5fMhSpr7hAJhE3WryGpZmRHbePSUGj8x4nqdl2buY14C16Qtv6HSh3wjEtn6g7h8j7NQv9sxd8YiHQwRCQYd68tZdNIAKQxXnswSlWpYo1wWQCFCW9Z7qiY9xibOXW5GIaKEJJSC26ukKIgXwwrQddofpO2Gnlm856xlWRTaZax2f1GdR6/hzqjYHH11WbX+9S4v0rvH47bQ/SG4HqYCCCeTgjy1bOBkwY3zV3zDD54x9Ke+hrUJ1mzmNPoULHfdfOaRAgLlXgVQ2+1SBkzUvg+L5FwTKQdKF16KSitC0Fq1pxKF9i2fRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=networkplumber.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2esf111GtPrgylCZ29AWW/U6CAr1xnDY7ueoVOsBtvo=;
 b=hLgSHFcDrzYyhdKOBH4hjrbj1luarJkZJEpvU8O1Rth+k89Ncyj9Mr5E0Amj6n/AbElcHhF72ZZfxDsNk3ApE+AgjPBdoXk7nY0KcuHsz+vfrAJwgXKCs7f49Wipdd975weO5vU+zKgRL1WgOMw8IFTA0dHKuY6SWOfz97cOkATz1QDpL+v3J3F59Eo7yE7+BmqwMi2M09FD5D53ReAiwjTx+VP3nlZ1jUI9GdssDnjZi5tWKVIdXFbezdC8f/F0SInOgs6kZQl3Xy2S1gEed71c9MFUHeWlroutalqDUO+e1yGfVrPlAIeVJLpRk7/jZR9QCwKenj9IYK/h1OnHVA==
Received: from BN9PR03CA0894.namprd03.prod.outlook.com (2603:10b6:408:13c::29)
 by DM6PR12MB4138.namprd12.prod.outlook.com (2603:10b6:5:220::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.23; Tue, 22 Feb
 2022 02:52:51 +0000
Received: from BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13c:cafe::d1) by BN9PR03CA0894.outlook.office365.com
 (2603:10b6:408:13c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.19 via Frontend
 Transport; Tue, 22 Feb 2022 02:52:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT023.mail.protection.outlook.com (10.13.177.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 02:52:50 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 02:52:49 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 21 Feb 2022
 18:52:48 -0800
Received: from localhost.localdomain (10.127.8.13) by mail.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 21 Feb 2022 18:52:48 -0800
From:   Roopa Prabhu <roopa@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <nikolay@cumulusnetworks.com>, <idosch@nvidia.com>,
        <dsahern@gmail.com>, <bpoirier@nvidia.com>
Subject: [PATCH net-next v2 01/12] vxlan: move to its own directory
Date:   Tue, 22 Feb 2022 02:52:19 +0000
Message-ID: <20220222025230.2119189-2-roopa@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220222025230.2119189-1-roopa@nvidia.com>
References: <20220222025230.2119189-1-roopa@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 45a170b7-16b9-4833-d7d3-08d9f5ae6a67
X-MS-TrafficTypeDiagnostic: DM6PR12MB4138:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4138B22ADFDDD74E426BB628CB3B9@DM6PR12MB4138.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5UJJCfvpBNulwkj5irr1XwuF0BtAYJx1ov/5jltbeAJnNKVk5/V63mtiueXhMDejBRqoOr589DQzHhVL+HuDkClHugdYTVi3mqq1qUnOa/AA5CHDgsRff2JEEkUJ+PNoOZi65Revxq0VCbqDxGfA2KEOu1rH2gkVPXkNfdym7dZAQ+bfQYK+QwZguxbSt50uYkfQfYZVb56qRjqYfDNCjtj2Aop2A77ENsPHxKfA7Kg1gkse8WQfu1SBh+eFG5jkzpr7di8GEwq4DUAJ9hCdtheyTP0nyxPE6XiyJIHMJpC1rIMZd9hZnufn2uXDb8JsQ2eYxcFd5FtVdVWiWkLwxliyNsZJSq+/51vKOsTO9WKxPWZ6M6tTyEaBCUM78/rfT+z1RoGi091mhdMdXI6XB1lO0OgIJu/YhhR9DLnCXsn4Ka7yFc42us+RmHyeqCCQxfnXG2HW9rnvc8GuuuzqxWzEc97XUsfCqibe+dYfgPF+EnlGmfi2SK3ZhuO5qZoy2M67VfoqV+NE+aHdb+tbjELVFvm2AmAhVeVz/xcF1BJuOvdSX7rV+ECQjFbJY0svvy4OSqMiEQe57hKkDcrOxNtEPlvV3fweBh9U433mnoUrPY4EZ0cnAXq70lkpfKlQG8SWdlgX0l/WP3gwqcWI/a0pzs4b/moCd4YO5uwcFc4OIlEGJCf/Ke70DlNUcMdPEaydlXGrrooUWPPEKPEe4A==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8676002)(4326008)(70586007)(1076003)(26005)(186003)(82310400004)(70206006)(2616005)(107886003)(508600001)(81166007)(316002)(356005)(86362001)(426003)(83380400001)(2906002)(54906003)(40460700003)(110136005)(8936002)(47076005)(36860700001)(5660300002)(36756003)(6666004)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 02:52:50.6065
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45a170b7-16b9-4833-d7d3-08d9f5ae6a67
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4138
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vxlan.c has grown too long. This patch moves
it to its own directory. subsequent patches add new
functionality in new files.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
---
 drivers/net/Makefile                        | 2 +-
 drivers/net/vxlan/Makefile                  | 7 +++++++
 drivers/net/{vxlan.c => vxlan/vxlan_core.c} | 0
 3 files changed, 8 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (100%)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 50b23e71065f..3f1192d3c52d 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -31,7 +31,7 @@ obj-$(CONFIG_TUN) += tun.o
 obj-$(CONFIG_TAP) += tap.o
 obj-$(CONFIG_VETH) += veth.o
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
-obj-$(CONFIG_VXLAN) += vxlan.o
+obj-$(CONFIG_VXLAN) += vxlan/
 obj-$(CONFIG_GENEVE) += geneve.o
 obj-$(CONFIG_BAREUDP) += bareudp.o
 obj-$(CONFIG_GTP) += gtp.o
diff --git a/drivers/net/vxlan/Makefile b/drivers/net/vxlan/Makefile
new file mode 100644
index 000000000000..567266133593
--- /dev/null
+++ b/drivers/net/vxlan/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the vxlan driver
+#
+
+obj-$(CONFIG_VXLAN) += vxlan.o
+
+vxlan-objs := vxlan_core.o
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan/vxlan_core.c
similarity index 100%
rename from drivers/net/vxlan.c
rename to drivers/net/vxlan/vxlan_core.c
-- 
2.25.1

