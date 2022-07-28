Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE90058467B
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 21:34:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232852AbiG1S7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbiG1S67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:58:59 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5BC76470
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 11:58:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQhKEdRo9mCDC8SXYrWrQirTHxettkM6gPzp95NL7LYDbFCg3O8hR+t7cFUkUh7H3QZrmlVyThsewmH+ik4uXvhbbAe3pXdu1nMlI0zN2AjZ3jDeNGO/EJxF7h366s1oz2Dw7X8nL5fcdGb/LHc554hMk50Uk38RR97Ahw3CapZ3UE0I2OWJl1mTVKxdfGQ2kXYhL4KsXdchiTz//P+lGQ+xjIpPobqcJnTcXbJdhFPJRY4b3kgKCyYIVveLE2v0l35FffA5gTfR8KwRPziswurayhJLGRJyfvKjAL7tBfO8rcBp0CsE3IQfXMGAABmERFo58sooE5UmaoMoaikekg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oUvhpgeqo4K+PG3bnTrXMeliTjFrNCpCxb8Dlw5WRWM=;
 b=YMuSn2FIIbqZ6FDO3lG+YBcoIH17e8mUUSj0bMV63ae46lIDE5l775Esm54fFo3Ejve6lB/hu5zWnCLQwNhyKyLUhKjbP19Z8n30W/HhmBB9Zyn0wH/rqUnIb1G64Lb7E6wNLduwmtf+sf0nIaKWvedKOz0SWTaja0Qraxs9PdL9vEysTa05jI1l88/dP/HogY5ZFprDS7/3+2NHPP3BuG9eyFS/+vbFWpR/4HmSYVXBXyrACh0j4PHm947F4Z7orQBCkeZSr7cNRtbZ+3fbNvR0S/st3POPSXiMqEXdKVSn8Yxk5Bp9sty34J20voNx6o2bULeI2UvbEjnKClLy8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oUvhpgeqo4K+PG3bnTrXMeliTjFrNCpCxb8Dlw5WRWM=;
 b=PH1ZEGCjSyeZ3ul99nCEr9x5xt03NY557GarQdRYaOhedogGrnSm6DD8o6A4uk9Nk6dWkXVSQrEdaYY4L26BClixZw21B9Z8iuKFMZax1BzG/k6yH/J6MFIR/lAPAjLy81HrKUPejz7YgZV8ilyaUj5qe9aTK969aWrXZCL39/bacmHgXQdOLveuYvuQu9X/F6iyoS706t/i8ziVNMULyO7kKOq1dKXNo6orU7B3wO3sS9ErZkMjV16/SmxjdhXpb1zfBVefcd/Z31RIixIbZCkdKr7SCsEZNRWF+PGuqjbmnMeIYlLux0vjdwI+2fHhIhURTfl/oaubAw9xPhRf1g==
Received: from BN1PR12CA0006.namprd12.prod.outlook.com (2603:10b6:408:e1::11)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.20; Thu, 28 Jul
 2022 18:58:51 +0000
Received: from BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e1:cafe::72) by BN1PR12CA0006.outlook.office365.com
 (2603:10b6:408:e1::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Thu, 28 Jul 2022 18:58:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT020.mail.protection.outlook.com (10.13.176.223) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 18:58:51 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 13:58:50 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Thu, 28 Jul
 2022 11:58:49 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Thu, 28 Jul 2022 13:58:48 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v3 10/10] sfc: implement ethtool get/set RX ring size for EF100 reps
Date:   Thu, 28 Jul 2022 19:57:52 +0100
Message-ID: <294be9ed0dd09b800f764a7801ae929169009def.1659034549.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1659034549.git.ecree.xilinx@gmail.com>
References: <cover.1659034549.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1cf0c11f-3b80-4bf7-97f7-08da70cb35ec
X-MS-TrafficTypeDiagnostic: PH8PR12MB6794:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NvXFzfrqAkh6YNvN8vKjGuhRM9z/H8MzXDtTvqieRmVcYd3ME1FL+NQkbHYehNAvE9TEd7Ov+bsPmxK+9j0FZtfzU8ToB8wI2SDI4aZKJ/UWtqd5A7Kk8l1zXtK2NQr3L+ChH6FN+j8isTKdljOI4P3y3JYiGOhMwx3WjeXipv6wZz0yNqcTtV0df7SKUb5PCYUcNBVZwVYyMndZUCoMQBeMDJLx9ETSzcQSjuhBBs6ksHhQCI++WvUtdu0Nmsh2zpBOgwUnYVfTrvN8fJ2kFdokQgWxLZynCbGE5BmOa7TEptzThzxCqodZ9oJqJYpmjQK8hFtcONTUyGQRC4mkkNGSABvicomVj2TB7U7ntRlS0OT1WU5ckR8P74mgNgQeKdhr8jjeCJk3F+dJjSc+EciIEBy3EVe2hhiKeyUCMCoLqr36/NTcDxiKm8738Q94uq5pI15M0+xKICRJy445ypXgYBRTnrlJotn4I1HfMPTljG78qsHYdqjrMNYJ1ixHUtdtBGSPyUVKfQvOD5EusKy3o8Mzrt/nm7S9a1mMxhfieM+vrWadkDk+TtecTa4vRJzblSiglFOhYXin9PJc9T5b7ML+s/1KWjQq386y0YrKFh4SkjBDkFBrnBzOKJHn0nBFEfKMq0cNvigz/ai6ubNsv2FsB4pH4O1KZF9yirZQXjODxWCrmVCByrXckCwG6XThpVN01ze5JBqKRYjPl8AVPeBHQwZ6/ia0CBH27grr9PqaPgmHdaE/tKhXh2iwvBkQrXgegqe7+PaA3AOtZMqy3mIwyQECG+JNO2nqWMeF1NhtmVPvp+a8RFtNEMyPHBWtzkQy4ZvFGZS4zvAz2A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(346002)(396003)(136003)(36840700001)(46966006)(40470700004)(81166007)(83170400001)(40460700003)(8936002)(6666004)(5660300002)(316002)(2876002)(36756003)(356005)(70586007)(8676002)(4326008)(40480700001)(82740400003)(2906002)(478600001)(186003)(55446002)(36860700001)(82310400005)(47076005)(336012)(110136005)(42882007)(70206006)(26005)(54906003)(41300700001)(9686003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:58:51.0935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cf0c11f-3b80-4bf7-97f7-08da70cb35ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794
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

It's not truly a ring, but the maximum length of the list of queued RX
 SKBs is analogous to an RX ring size, so use that API to configure it.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index eac932710c63..73ae4656a6e7 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -150,10 +150,37 @@ static void efx_ef100_rep_ethtool_set_msglevel(struct net_device *net_dev,
 	efv->msg_enable = msg_enable;
 }
 
+static void efx_ef100_rep_ethtool_get_ringparam(struct net_device *net_dev,
+						struct ethtool_ringparam *ring,
+						struct kernel_ethtool_ringparam *kring,
+						struct netlink_ext_ack *ext_ack)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	ring->rx_max_pending = U32_MAX;
+	ring->rx_pending = efv->rx_pring_size;
+}
+
+static int efx_ef100_rep_ethtool_set_ringparam(struct net_device *net_dev,
+					       struct ethtool_ringparam *ring,
+					       struct kernel_ethtool_ringparam *kring,
+					       struct netlink_ext_ack *ext_ack)
+{
+	struct efx_rep *efv = netdev_priv(net_dev);
+
+	if (ring->rx_mini_pending || ring->rx_jumbo_pending || ring->tx_pending)
+		return -EINVAL;
+
+	efv->rx_pring_size = ring->rx_pending;
+	return 0;
+}
+
 static const struct ethtool_ops efx_ef100_rep_ethtool_ops = {
 	.get_drvinfo		= efx_ef100_rep_get_drvinfo,
 	.get_msglevel		= efx_ef100_rep_ethtool_get_msglevel,
 	.set_msglevel		= efx_ef100_rep_ethtool_set_msglevel,
+	.get_ringparam		= efx_ef100_rep_ethtool_get_ringparam,
+	.set_ringparam		= efx_ef100_rep_ethtool_set_ringparam,
 };
 
 static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
