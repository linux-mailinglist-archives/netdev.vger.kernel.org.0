Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1E958325A
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236337AbiG0SuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236317AbiG0SuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:02 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EC7128A82
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:46:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g13HpdyE1tiT43ihjrxt9lr+NvQPca/Bnqgf84AbnwHKDHSE4Wwk1jI8EZvhTcO0WcKptELg4ww/nIExJfPWeicJJTWD4E4SPGwy16efbGU5AFFZU8wKpgkXRbiQQXDJkOUPrnFFK//9/hf4DcKcfM6xfCjWgM7FbjAnlpmlSC9kO+vjpqQIK4RnKwb39FjYN+9DHB2MA4hQ7g3DLQGuVyNGF7RZ1O1nhs1lgzLFGdDMpSdWkqeiBRoIJCUA84LVRsv2rjNj4FRdSG3xjoTeomQkpNrra5IM6Wsy/5rzt++OiFdS7uF0FJxRu9c1S1V9u5iac7u0djzpSDJ7VQav3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nf49AhWBjnE/r+5jl7yktB0YkFTItVCPHNLkkT+ld/k=;
 b=mvYZGGRujyP/r6PHgavnk/ECOjOd9LYZUw2y9aoRGqb6xbuC+IhM2Hdbak1nNR8fMyYdSgNMOlSxB7Hywz7FmbQd7sexyzA6w0S0PexU+jMHqFLJyTZVx3dAppzD9CKnLwK8krztHuhXq/g4HJZGXwpTTXTXjZXzGMHdv+Qa/AqLY1A/FX2LIYzBKiptlWfUhPMoerjuEhJmU03W2SObrv0MSfS9wyDDgFnvyo14hB6gHyqxjhbt2Eix7shzFoV2cAbhWlyTRliyoZJQv0ZoM1c3RrGCNO0T9TcLBZ60HEDZH6uUcXJUCGB+dnVuRSO/1RizknncQthDJrWU6Rh14w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nf49AhWBjnE/r+5jl7yktB0YkFTItVCPHNLkkT+ld/k=;
 b=OLWn05Qmica5AA2FF1EusbShnFasXkZdBmm4wQD1eE1ofeL3tvvuCKHdH5fVyCuRU0hN1CmHw3j7TqX6t9CRXjd0edAIxbFNGtgduJ9xF4+6mMFIJzyWwi3NhLba4JKc7DmMydmzLSdZ9orc8jwl+linQS+4nsBjyUkBCiN7jEYL0ZTdXgCmjMIepFyWXrCAqsZkCRfykgF+nVBNnlVu1ZAjzi850Sd0d4EC54th/tyu343zaiC/1G2qa5B4ZOo7KgmQIKi2e0BFCfNuwJMByvvSU5uXg/0Yi29MZKJFilVzabV1Pe+jFJdmLhUdRQDiIsUt6nAosPdL0DcFGO2pvw==
Received: from MW4PR03CA0058.namprd03.prod.outlook.com (2603:10b6:303:8e::33)
 by SA0PR12MB4463.namprd12.prod.outlook.com (2603:10b6:806:92::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 17:46:41 +0000
Received: from CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::75) by MW4PR03CA0058.outlook.office365.com
 (2603:10b6:303:8e::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Wed, 27 Jul 2022 17:46:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT064.mail.protection.outlook.com (10.13.175.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:46:40 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:39 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:46:38 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:46:37 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 01/14] sfc: plumb ef100 representor stats
Date:   Wed, 27 Jul 2022 18:45:51 +0100
Message-ID: <5eadfecafd18dd354c327b5715a645fc3d853291.1658943677.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9251fe38-96a6-4a66-fe47-08da6ff7f616
X-MS-TrafficTypeDiagnostic: SA0PR12MB4463:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sSnZHqrSaniESAHEZ2gAUhYNDo1QwrM9l86cNQWMpXHYwo+/cWOfc1AEN4ME3mdt1UC4sWRKEDruhmsaG73Vt0drIllj+lcGwrD56L/ApN52XEFIh0iERMxt+KOKfG7aRE2eKDgtsfP7R2j0pF9Np0BmP9YqgiugNMe7qdQBRn4XWwmHDEOhsmW+NR3gqWtowjwaclYzNCZFJNSjNKl7ZKpqgjfKvR7dmrX+29XD5mUsSWXvRAkALYJf8GGtH0scZ378oLPnlZ4mR8a1eNufanSQoEkfpgODWvlL1tt1BnJpdDrFZkV6NB3UfZj0yAfy7ZBuVpMfkrNcny3QRLCczBglaQDMywT1Ovo3i4xTgdCehOyxqhPqSxpXZK4+LUZpNo/jf60k6tJwsIVIsa7YYg0A14sa4uD2pMWHDMXnLoN3bwxc6pFYUmVzRg7cOLopv6twvIQQ4zYvQj0DrnVxQyACPrDChFKerp4HuzBiDp9mfB25Llt0CTsjITikdzfVUhaibJ9r1yBFvdOtqu+zcVjdCNSAKBNX8xomIAteEvQA9TkpQuHDms9opXvrKoHVJSpGNXhBvvp4AGjVgqyY0RPanptrw7pu0dm/F40fGMvtV+BN1mQPLHLZPD3Wa8s3muhatNG8q1qa/GT2kxCdGllHjPuIQdsWesSP9w+UhhyZwz/00niyS0exIJSmr2U+n14ITcTJVQPEjTSTxOokJuLcfau8LmJk0fkEd0zDk5jkPijKerZiYLtj95+2dsy+/ttbv7WCL6JysO/GY7AXSVTuFrIddaRfiN55NsnqH2PLJ+1ail4C3KpesoncaewBPhw+6trzD8YcpVEF1rWj2A==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(376002)(346002)(39860400002)(46966006)(40470700004)(36840700001)(186003)(47076005)(36860700001)(478600001)(8936002)(40480700001)(5660300002)(26005)(9686003)(6666004)(336012)(55446002)(2906002)(4326008)(40460700003)(42882007)(70206006)(82310400005)(356005)(82740400003)(41300700001)(83170400001)(81166007)(110136005)(316002)(36756003)(2876002)(8676002)(70586007)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:46:40.0935
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9251fe38-96a6-4a66-fe47-08da6ff7f616
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4463
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

Implement .ndo_get_stats64() method to read values out of struct
 efx_rep_sw_stats.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
index d07539f091b8..102071ed051b 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -79,10 +79,24 @@ static int efx_ef100_rep_get_phys_port_name(struct net_device *dev,
 	return 0;
 }
 
+static void efx_ef100_rep_get_stats64(struct net_device *dev,
+				      struct rtnl_link_stats64 *stats)
+{
+	struct efx_rep *efv = netdev_priv(dev);
+
+	stats->rx_packets = atomic64_read(&efv->stats.rx_packets);
+	stats->tx_packets = atomic64_read(&efv->stats.tx_packets);
+	stats->rx_bytes = atomic64_read(&efv->stats.rx_bytes);
+	stats->tx_bytes = atomic64_read(&efv->stats.tx_bytes);
+	stats->rx_dropped = atomic64_read(&efv->stats.rx_dropped);
+	stats->tx_errors = atomic64_read(&efv->stats.tx_errors);
+}
+
 static const struct net_device_ops efx_ef100_rep_netdev_ops = {
 	.ndo_start_xmit		= efx_ef100_rep_xmit,
 	.ndo_get_port_parent_id	= efx_ef100_rep_get_port_parent_id,
 	.ndo_get_phys_port_name	= efx_ef100_rep_get_phys_port_name,
+	.ndo_get_stats64	= efx_ef100_rep_get_stats64,
 };
 
 static void efx_ef100_rep_get_drvinfo(struct net_device *dev,
