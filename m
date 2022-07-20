Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF7457BDCB
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiGTSbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233028AbiGTSbE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:04 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CF6670E63
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:31:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTGtIsVQfEbwG++8G5npj/A5f+9WXUhxDYXYKOA9nSw9z87CczRuiZfI0Z6NDarEdyI2YL45B3OCTbwn98CS63ZPA3QNNwtqKZwRwYxBfiA+FcXJoAcMN23j9Z5zKwmAm+5Um0aM4UHvb7ksBQNe5hSysUK/5jn0BH3RMWi81Ek4LIQEPnuMrFnLteHP6gD47fbKilPKOnJLK2IRfWYc2FiPrOFTnm6Koq+0rvu32q3uSOmdpMe9oPVACkQlD0ZgJNl6sjqxwRjt9DxiE8/fGbCGm0O7myZ1JzK26A45DbSSAVX1J4F1fBVuvwtP5xkGH5NhWaxlxuU1hcsbhst56w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=NRjhpB94yf3jNIeOrvzv1MwsCDbqDwoNNIY5j1MwLbTbeUBM0rXRkd4fu2kLhu1DChrTZqcNpocOSVQ3tILs3hwbxtvN7Q+3ye5WlO9eBwD2j4GQtRB4nd+EE5YmYlwZ7ujxYVEaVSfFjJ/8HX40gNDAJankMEF1MltsW89rZuNpqiKvs5l9IAdhSsso3eXS5K5s8+dATxj/CbZsUbpRZFFxxJ4eVna883+3uO0u7BBULzBQMbZXyNt7o0QcNXDdZhQ+1K1uz4vX2NoinoUrJIjZ6BdtewXwa+kYrjCZRiJn6V3r3CsUV3eu4Gnxk46azyF9Lsx6wwiyta/cNFUCJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uTjytkjfFiBdG4JuZj3x7e/V21dEXahuIUI5YVeL3Vw=;
 b=12xfbHfpSg1fK8+K9qVQNb35I6UXKZl/AFPz8Vc3G20GR7Kx+uPJ3H5jo1WAzDfAvVKS5WnPtEmmW3N9AHcgNN4wtqNQo/qFjVd6pc3LVGYgpu+qoQ3f9f8v5oWO2ev0Llay1VrRxvZFLQkuY05GZHHwDdWIUUB8WcU9Yf1FsEHKAyhjDvy0Z6mnVo8Wdd7XapySZcx0kAuLwAv0DhKg0GLHPZI+vBo9rQqfVN/cV37Yh9YuS38Wswi0lVCMNiKUk5Jh6KwiCzF59YBwcr7ebtSSksR9G9VbmtjHQ23xr7p6I+GKi+BUSFhT9Di0vLJPQkIMwmbfKSETofAHF3amxQ==
Received: from MW4PR03CA0010.namprd03.prod.outlook.com (2603:10b6:303:8f::15)
 by CH2PR12MB5561.namprd12.prod.outlook.com (2603:10b6:610:69::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.20; Wed, 20 Jul
 2022 18:31:01 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::4a) by MW4PR03CA0010.outlook.office365.com
 (2603:10b6:303:8f::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Wed, 20 Jul 2022 18:31:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:31:00 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:30:57 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:30:56 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net-next 4/9] sfc: add basic ethtool ops to ef100 reps
Date:   Wed, 20 Jul 2022 19:29:30 +0100
Message-ID: <77192426118d089e6b9e7b3e800d05b23a89fc96.1658341691.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658341691.git.ecree.xilinx@gmail.com>
References: <cover.1658341691.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c0adc1d-df6b-4243-8f13-08da6a7dfef4
X-MS-TrafficTypeDiagnostic: CH2PR12MB5561:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wHo9JUHVGkqiSHmkJVJf1KwNerHduCixbkOVbd4g0qhRPUcuwgmW+gmt7fPCVNNWjlm9dIX5Dxgvn7Xrzpt9Ynsxk4EczFMKhF/ch9MeNUr7CXNjRqnuvsMZgLYPPaeS1uCVsr5lVKztJCSX51R1J5Wy27x+bNm96eAeM665WIQXUcOLkEMzxcYKEXHdtOZQKntJ+La8Fuk59hW8JgkKYuEug/8sTmpBvjVnS6VRcEQ4MM4TipLzPLvH2Q2GLG3dksmqEotCTHRvfUbMErTLOivDcIXR4ukG2cellsuV005Cp62bojfNSEYMG5TL/xKlbl9ynyRg3NSfdSxmMA7+vYHm5MFyR68BvO7hWbbO3WHvhAOkiQWdcW6h4VYrlJRF2GjlHksz0chCXpTBiSneKV/2OdZdz8juiv87tQODUyMGkRluslbk03kwEBPkBfofhJwlcl1xuNv+cFNmHsahkzbFCT/2j+QSHM8pXxSd1gBSjezJcerI14exWXe8vpkPW9KCtgkprOtaGGXRhxp+YzpQEEv6Lvwfe68RPHjXiLq6+cjmLsNkrCNCzuEtVrUX1j2aQbAfSGC4RMIBvaBKGUFBpZq5zMJwQ8xC0dp1qg1m8EFFXlxvAWZitlQXQOxDbx0Gbtq8O7aQ1gI3SfmV7JgZRgXO2Cjl6Y5E2fbXlEZtxv1vtBhmz2Y2jRu07L1EFFVKkARUNv5O92cogvbh2JykHq/UycXvB2WBFy3Nsaz80wdNy8MiaCcJaQb/XCrNMPlT7Lj5TwJOQjsj2fmWjwzZNYzN4HeTHtu393/0dqiqjj6kbLqHhwqqR5pzdiQD5URSR6odEi+k6gneUp41Ng==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(39860400002)(136003)(376002)(36840700001)(40470700004)(46966006)(40460700003)(336012)(110136005)(4326008)(356005)(47076005)(42882007)(82740400003)(26005)(82310400005)(186003)(54906003)(316002)(81166007)(8676002)(9686003)(5660300002)(478600001)(83170400001)(36860700001)(8936002)(41300700001)(2906002)(6666004)(40480700001)(70586007)(36756003)(55446002)(2876002)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:31:00.5368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c0adc1d-df6b-4243-8f13-08da6a7dfef4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5561
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index f10c25d6f134..1121bf162b2f 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -12,6 +12,8 @@
 #include "ef100_rep.h"
 #include "ef100_nic.h"
 
+#define EFX_EF100_REP_DRIVER	"efx_ef100_rep"
+
 static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv)
 {
 	efv->parent = efx;
@@ -26,7 +28,31 @@ static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv)
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
 };
 
+static void efx_ef100_rep_get_drvinfo(struct net_device *dev,
+				      struct ethtool_drvinfo *drvinfo)
+{
+	strscpy(drvinfo->driver, EFX_EF100_REP_DRIVER, sizeof(drvinfo->driver));
+}
+
+static u32 efx_ef100_rep_ethtool_get_msglevel(struct net_device *net_dev)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	return efv->msg_enable;
+}
+
+static void efx_ef100_rep_ethtool_set_msglevel(struct net_device *net_dev,
+					       u32 msg_enable)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	efv->msg_enable = msg_enable;
+}
+
 static const struct ethtool_ops efx_ef100_rep_ethtool_ops = {
+	.get_drvinfo		= efx_ef100_rep_get_drvinfo,
+	.get_msglevel		= efx_ef100_rep_ethtool_get_msglevel,
+	.set_msglevel		= efx_ef100_rep_ethtool_set_msglevel,
 };
 
 static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
