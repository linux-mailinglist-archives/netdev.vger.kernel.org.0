Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097E9583266
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236612AbiG0Sv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236062AbiG0Su7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:50:59 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2052.outbound.protection.outlook.com [40.107.102.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278E76A493
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:47:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7E3QbotiEQ1qqKy04pkPrfPeCKV6m2y3dF/r7Pro4GxnznUxEmzTgCu9gxARljzu3wN5OHkskVRxJ4S32H8UFG9h0wKjtVlvtONvyk7yBiZPjTEMhJ/kPDLJGSTr2UVHTMMdYhiYE5TYd/ygQNQVuEiPM63EnJjrOepjDl7ZU0NvR+l69nIkfRVMaz8EECZKkk5DJgrhDdAIuNgRCrkebUAwTJ38OST8GqidDbB+6YRzbkG9jvc2Ietj+8jQwVN4tSFBCCeRCdeV4KgZOrUw3ueKnGBK74ZWsETa2SE+7LIS1ZUYCDY6VFRd0wbaYlUq+z3qYEYRbmRtW/ZsIKSgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuqc+Lf64Hn/oPjP8pSIxUUDUNv5luH9YeJK07ihjhc=;
 b=LAOkbGvvTiwMKK8fhtTzGfcxsflBt8brigqkeqQ0PIkwVNWav0w8DFkLUfMs2EOYh6zRSYcudyhvcWoD9q9b2gaOSJwci++m0eTWQvXYoKTYA1I/594yVf5D1VyIGnx54hvzHEpWQYyfUKPfSVNB2CGYmzwWRIs2fcRHKoOlZgpyNMCINblJG0MFxHIiiqHjJGT8LqDL9HImw1GtaHPmABdJYE7oD5y9lNAsgPzuV+VMiUVEaNh6b6LofJOQXbU6Q06hbrTVTCJI9hpBzlFbLMrMpjZvSUZkhMxDiNvcuWqDMytX9Igz+iJQAqep0n8hOHkdy5U4ZSLrr312kmEurA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuqc+Lf64Hn/oPjP8pSIxUUDUNv5luH9YeJK07ihjhc=;
 b=2htBdN1BcHGG4YjdPnU9WLaX36RN47tE/vKMHNvtrgqJKr+xgpCzlQFVeWBlyCs91aXeLt3Ly5M83TnY+ihwEirNZfpdQQ6T2S47S0Y3Wgu2ZfCakHs8ViSnRxBr78VNKb19nWrkLt33I2LlpC/4ylcIcEqYVR7f9XmWKi2q6hYMcwOC4nuCVhc86ez6cs3SlaiwjQYpYIw8g1W8zdxMstgrJTNCIsNcDp69lgQ5LFqsMqRCo9zb7+Ou85muCoZRFay0d6EkwnS9Jk69utfz0IC1Qk874Un2vbRZWTRggJU14iIoxZdOmWAL8NsEOGB9fIrY092+rzftOUGlE48heg==
Received: from MW4PR04CA0320.namprd04.prod.outlook.com (2603:10b6:303:82::25)
 by BN6PR12MB1217.namprd12.prod.outlook.com (2603:10b6:404:20::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 17:47:10 +0000
Received: from CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:82:cafe::7a) by MW4PR04CA0320.outlook.office365.com
 (2603:10b6:303:82::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10 via Frontend
 Transport; Wed, 27 Jul 2022 17:47:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT044.mail.protection.outlook.com (10.13.175.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:47:09 +0000
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 27 Jul
 2022 12:47:09 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 27 Jul 2022 12:47:08 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next v2 14/14] sfc: implement ethtool get/set RX ring size for EF100 reps
Date:   Wed, 27 Jul 2022 18:46:04 +0100
Message-ID: <3199c8294baedae03a6ab3429abb28b2213d1f25.1658943678.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658943677.git.ecree.xilinx@gmail.com>
References: <cover.1658943677.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 904cd08e-2ebd-4f9a-9acf-08da6ff807d4
X-MS-TrafficTypeDiagnostic: BN6PR12MB1217:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8JxEC1ko5XtlmTk2AyyWXOKo2oJ2d6Q6CE3MPDQmyRkr+gUO9aZNwgE2i9n0KjCtaV/sAm5QYj91CWvcdDEvD7ld4NpnAJDxelbA792TrICVwAYZzLjrOjZ056RCfNYAbZXz5rCx1E4TPk1UfhTrpnQuMvFMjqdhnYeZFHMPXUDAN8mFJyFIJwpGxoNUbJaIMGXj7f5iXQCYS2uYb8VeuWzkhG5riMKRFOu6hgaV71DFuuW9y1BUzoZphscJvacDsnAWJZKgSsaUXoZNzxTUIJYcq7VRV6m98fr8v/8RwiEYEu+GlCaYCeaW5yHDwLnX7ZYp1whjhslJeRuoZwvxXsoNT7cZzwqvU1oT78VjfU8TyVAP5l/l4X6cbr9UxJN0OfXgw8phg7r8Z/AXvppJFAIwaeNRdsiFROV9OltSQH+AZQKajjqwYF/4QtTpWqqVqR7ILrNbC057TZlybsUGwXqwhnuDDpQYFtmemxvgZdot1JcSuoWesuf6hhYr7vEQDbpgy2kY+XmOiroEsoKI3zm+ehIDD3RlFq2QBD4649cb470m/lQ3LmYgrjduw7jrh9LmupO/+oaOQzh5ZK+2clrESgbu76pV0HiHmE+PutcBZVgVp6z/CLaMoazL512laj6PHII1nwPp9pnuT8CqYKVOhvhVkmkMQtyzSD/0B2IYJWAUJNHi8RpGwoUJkDoRqEtioNkBKHPp8nohVhBX0Xdh4Z9LmiSHZqeoQVhHA2ltRVcJkeu+Y6IInh0d3VgktwgYcVKjZ5uTU3enosGZOTAiobNjyWYSA2Y7JfKQ0zdyAc/zFqhNFREs0/lApVcjE0hJDKo2fVD4OGx3ZZiibg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(346002)(376002)(46966006)(40470700004)(36840700001)(356005)(82740400003)(316002)(83170400001)(81166007)(55446002)(36756003)(478600001)(41300700001)(6666004)(54906003)(110136005)(9686003)(47076005)(336012)(26005)(4326008)(40480700001)(82310400005)(2876002)(2906002)(42882007)(40460700003)(186003)(5660300002)(8936002)(70586007)(8676002)(70206006)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:47:09.8417
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 904cd08e-2ebd-4f9a-9acf-08da6ff807d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1217
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
index 58365a4c7c6a..efbe7d482d7b 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.c
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -178,10 +178,37 @@ static void efx_ef100_rep_ethtool_set_msglevel(struct net_device *net_dev,
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
