Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B752057E41B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235590AbiGVQHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:07:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiGVQGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:06:43 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27E95743D3
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 09:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GKZDnWSQ0QOvGcUNvLEW1mEAr6OgTVkzDTIo0+aaAdrtTmImcDVUwiADt/j5bZjLKmeIHn4ajKH+ikdVr+bsefLX+2Q+NTulKUvAF2dizDE2adT5xEf5BH6sXbEJu9TI1elSw4PVEWkEWb981vW1V6MCXs7i8TJaW49AvILxC+oJukODT1FHGJxgqmhDDCYV5HJuPWazpaInxWmZkikPAT2Xj3BRv4CQgy4WkMxtbWu+BBnWSO5D2LY/1Af+ZOHw/5x5KsWk9we2emUWBs5lSeNmEzzKuO4ZZGdyEW4XV6i5wW2VWilUYAXAki5EktGupbORZCigMvf/saRW8YZxJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xuqc+Lf64Hn/oPjP8pSIxUUDUNv5luH9YeJK07ihjhc=;
 b=DiVQmo6iZa8rG/aRgILCn2SvR47vG7rWb4c5qJHszfMzVMsgLKztlEbfN8/7QxtD+QlA2YCwlcduCKK82jIbd9/stVR00SGXjHwkaFgbNDntmWXnJDyFMaRUeYH0TPFzPP4eiuhLP+8yLd8xR1jRB0ff5XrN9LsJEvNpE5KoU2orsMKTjIgjqZ1BHCWvTt3YlfoajIRFsEJP/V1dZoaB5MqlCJs3bxAfsqyE8n80Gvb7O6oAahBXJFe2Arlu9c4tZDdXK7gOC9I55xKBOADjl3+jDDJovCHL5BdybtV2n7mWLSAOuhmLTl5vb4cOqR/0dOs8v2K04RQPXGEf6q9LJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xuqc+Lf64Hn/oPjP8pSIxUUDUNv5luH9YeJK07ihjhc=;
 b=GfmON1jK8ix/YO+SH1JjyRVKE5cmHfvV9cxvY4XmXbBsWHRJshpb+GoCG1TsnFb3v+2QjkfQ9grVYM0hrjDgzXR2WnFyXghxBQ5KMACM93MqpdHpptTGLc7g+APn82Ef9FtTz1SqCOTLsH3AE6zNreuOfXtY0vU4PzvejUJ5IBejbk1rrOqH0G1qIuoPrNC+/oxJ6VH4fQmkNxK7JRmKUyKgwDpvbF94gKmi/D78tbmE0ThfifK0XKH/3WiL0rhUVi197HcfCmOW+YP49PCXGzzb2wWPdvHk0aYQAClA5pjfSr9QsfuKvahk0L5hJ+ZLptXkr81FrEXB08O3Zn0emw==
Received: from DS7PR03CA0215.namprd03.prod.outlook.com (2603:10b6:5:3ba::10)
 by PH0PR12MB5645.namprd12.prod.outlook.com (2603:10b6:510:140::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 16:06:34 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::49) by DS7PR03CA0215.outlook.office365.com
 (2603:10b6:5:3ba::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Fri, 22 Jul 2022 16:06:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Fri, 22 Jul 2022 16:06:34 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 11:06:33 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 22 Jul
 2022 09:06:33 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 22 Jul 2022 11:06:32 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 14/14] sfc: implement ethtool get/set RX ring size for EF100 reps
Date:   Fri, 22 Jul 2022 17:04:23 +0100
Message-ID: <d33faed3a9dc3926f3dbc7f8186dc89c6a35eb57.1658497661.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658497661.git.ecree.xilinx@gmail.com>
References: <cover.1658497661.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0054aca8-f4f7-4155-01a2-08da6bfc2643
X-MS-TrafficTypeDiagnostic: PH0PR12MB5645:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GZRW3BzEknx0qJJnh2m4+GOD78JPXmm8G8BJrKgbUzqq09Lz6A/Ksg9R/wplMS63bNodE9wQQpyaUVBUodYkZGaBbXWIO1A1Jzl48GqGONXAspYd6jBq/A/L5ooS6TCfO8+VvAT7MHmGy3HitauWux6EE74Cbg0+MXUWcdBD1Tg0D6RdndgjRAzBJbceXppdAayIFdt6WUrlCSSocQxgbT0R7xyYv50RqLhbSyM+egSjTtGA60YsOjW4oIgYyEwVLqmgbLK8nljeKm0eug2jsW/v6lh1deEvK+83ATtCLlgN354Z6j7bCJMiBR9NZB/jfbz8MTGBiHeIdT145xDYAdfeO28EVcxi0Ct84Xhyds/Izdwp0pBBXU084DOU5/c3rfeLiIp6Mk18Kta1ESW/bwaa+keROzf7Fqvt7bPm0I5Il5UO+Buwab1Z/OI/uTXoX5JvBOa0HNjG7oRPTm42pOJYpV+3R50ybr2SmjkAewworP1nZd2yMA5L0CAaRUJvgfdpa4Ul6qVTfmFFYtvy/Sfr1/ciYMUVJKpebYYhvqJbWn+6X5PMgYOOkKftgvPyZpQ4I3rYPjIcUyxClmWXZgBgpdRXqUDmOk9GLRn6jUJmSRH07sOVI+5c/QT2BlV0BJDmLFlRHFVnuuU0kmK/qMA0kz/ga4ymlp1QUmlA2wG3u1qLS6PokVcynaDheKHFBv6NnsWq1bx8Mdx5XHmLMEE1NUFmL5Jowe2hzd4O3OcSZ+B89zKHb4/ChpG+x/jJr44VLw6961Pud8y55ds4hprhWghVn+k3wm1xIXYj6ucUvQOjFXqGkO1e2OT8Yc9g9vaP3R3g/jddtHjEhnNbtA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(40470700004)(36840700001)(46966006)(110136005)(82740400003)(316002)(54906003)(356005)(83170400001)(81166007)(36756003)(40460700003)(41300700001)(6666004)(55446002)(47076005)(336012)(186003)(82310400005)(40480700001)(26005)(9686003)(36860700001)(5660300002)(8676002)(2906002)(2876002)(478600001)(8936002)(70586007)(70206006)(4326008)(42882007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2022 16:06:34.3265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0054aca8-f4f7-4155-01a2-08da6bfc2643
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5645
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
