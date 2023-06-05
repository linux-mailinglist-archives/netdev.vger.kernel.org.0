Return-Path: <netdev+bounces-8189-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A358723091
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:59:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCF851C20D13
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:59:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7888924EAD;
	Mon,  5 Jun 2023 19:59:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69780DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:59:44 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2079.outbound.protection.outlook.com [40.107.100.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA32D3;
	Mon,  5 Jun 2023 12:59:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBS464XwyYvZFnRjT4ll+0S7UWN/OdNRlhG7foqv8KWahscWfvNAWRzzqpj4dz4uX2Af3IbV7ZulVfItP7d76EWV+g/mQh9+MAeHscx/v2huj6UMJdjtJgRC/h/ErFPQauGc6ji7rncNniJrGtWX6JcI7X4lko+TyY2wL9OLmBAOT8CRj/4w7CbqgKKQBRQTHwbYyv4h7GzN5KP3BNkTuuXGJmStA/5znVZWtQZL2pqrMeh1Uw/baFn60VhMjArRg2ja7HAyAMjD4g7WmsRaLMK6XJ2GLl0jtSmHqOysFynTLp3kmXSTF1dLribQLo0sJQiGHyBMUPGvvo++zGz32A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L1YSNEKKCaM1/LOi+xmBL9ZcJ/SN9aiZhbHUPlQlpdM=;
 b=LxFNlLbAV1YgEijStTEvspo14Ph0OWXc+raUtWDf83fpy9dvPsweq+k+wRW1akXfZxOFVOw2ScyUEiyUTtdXXHFXnEqVWl4kH/wAQS9Gzv51WQl54OcFM6mTPAAtgN9QfcJ5Ai658Y81UQI4s+zjeNg67fCCYPY0qc/TPgRStqaT5cpEenrP5GXYAP51UA/ILy2vy/ppqlXCWoezhB/CBhK30BvcMcDKuEv7/G6+2TzJlDrIFkXgSttwrmPirnsNRL2PiJ7QZopx+SGKs7EMfUhgpWW5QYhJeNqs/qJf5HggXk/OpifoMyu34H0u2xv2EssVfPS+Lphp9kFnRUFZMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1YSNEKKCaM1/LOi+xmBL9ZcJ/SN9aiZhbHUPlQlpdM=;
 b=sasTUF7BD9MqTwzpht7hKxDzwVRFLXTqQC7AjCirYDfesF9lo8k+Z1M7Wu5zHfVZtV58s6U5XjbdvollxrnpylFAk9vDWYnOEZk8ieNrixUuyHUYm4vcAG/+s1ekoLGeYLbv40oHDr+Cg4zp1jy0Jrr256O/zPgX3ssEkFAg+ZU=
Received: from MW4P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::12)
 by PH8PR12MB6697.namprd12.prod.outlook.com (2603:10b6:510:1cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Mon, 5 Jun
 2023 19:59:40 +0000
Received: from CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::c9) by MW4P220CA0007.outlook.office365.com
 (2603:10b6:303:115::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33 via Frontend
 Transport; Mon, 5 Jun 2023 19:59:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT012.mail.protection.outlook.com (10.13.175.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.33 via Frontend Transport; Mon, 5 Jun 2023 19:59:39 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Jun
 2023 14:59:37 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <alvaro.karsz@solid-run.com>,
	<pabeni@redhat.com>, <kuba@kernel.org>, <edumazet@google.com>,
	<davem@davemloft.net>, <xuanzhuo@linux.alibaba.com>, <jasowang@redhat.com>,
	<mst@redhat.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>, <allen.hubbe@amd.com>
Subject: [PATCH net] virtio_net: use control_buf for coalesce params
Date: Mon, 5 Jun 2023 12:59:25 -0700
Message-ID: <20230605195925.51625-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT012:EE_|PH8PR12MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: d048661a-0ffb-425b-12ea-08db65ff6572
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uSjMzTkvGu6DrRyOqb5hfDiyVJOCL20OKaI3ORWFQXiMJktOlphd2G7y0xQwv5yfipisdd0Lz/4KQYIbiU7WthuhVCqpx9u6R4VV2GrLP2rD5rCHLfBH9t0QTd8UCdf8BPonWu5XDAvMHWvcQL3lATDSBZ1iVUKRvu2h4TX37a9x4uQgistdpaW6SketzNjhGH8Bs7GJRnediPW2UGpzdhLe+dlzmxbfHlWOspEGThf/LTlTGEgX7cShpL3zzqQB2Tq1p2cJRts5k8aydEMWIU5AlG9M9cAgi8kQ2RRpVFKLwHC/n80KWu4oyea5jP66gqq+AkeIK8MZFGJ04lCkjPL/qtZP+lkB3jiGzAoFytSLjU89qEMdWp+yMnm7xa8qSBFuJHMC1juMnc7f370Ae2eDwklJskWOCz0V5esudiXv+QZa3WD77MAwkBXox30CCX0QeFvJG43ULXZougpcSoi9kuU328zcIAqEpI5e7sD6qRmV9FDbhyZ3JH9LIWXTbJsf+WIhb9eA4pQjpxp3t0+IaFoLhWjoq3jji726omRjEuqTfqLdUgaWNkCN3IVUh6bOqTZzaEALXGPUHSjyqdYI2mCsYYjrzQvTEq54MgUwBw5npI7nd8RavNVi+FyuS+CVCXSg+vnv4/2pJvngyyvYdMyK+ZEXv5muupoRgVOTRUltuky1eBdCJFJhkFGFj/+5HcKTHFP0clZOQBTFnQ0JSXlcGE9RPtwkXTwY5ou9Kbtqd6GlNPVHZY/lIOfcxMYFOUcMkcnXrr1RLXEO5fFbJa5rvzobs1n9jTQAoSc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(1076003)(8676002)(40460700003)(186003)(41300700001)(16526019)(36756003)(921005)(4326008)(356005)(70586007)(81166007)(70206006)(86362001)(40480700001)(26005)(478600001)(316002)(82740400003)(5660300002)(83380400001)(47076005)(44832011)(7416002)(426003)(336012)(36860700001)(2906002)(2616005)(110136005)(54906003)(8936002)(6666004)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 19:59:39.4691
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d048661a-0ffb-425b-12ea-08db65ff6572
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6697
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Commit 699b045a8e43 ("net: virtio_net: notifications coalescing
support") added coalescing command support for virtio_net. However,
the coalesce commands are using buffers on the stack, which is causing
the device to see DMA errors. There should also be a complaint from
check_for_stack() in debug_dma_map_xyz(). Fix this by adding and using
coalesce params from the control_buf struct, which aligns with other
commands.

Fixes: 699b045a8e43 ("net: virtio_net: notifications coalescing support")
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Allen Hubbe <allen.hubbe@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/net/virtio_net.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 56ca1d270304..486b5849033d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -205,6 +205,8 @@ struct control_buf {
 	__virtio16 vid;
 	__virtio64 offloads;
 	struct virtio_net_ctrl_rss rss;
+	struct virtio_net_ctrl_coal_tx coal_tx;
+	struct virtio_net_ctrl_coal_rx coal_rx;
 };
 
 struct virtnet_info {
@@ -2934,12 +2936,10 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 				       struct ethtool_coalesce *ec)
 {
 	struct scatterlist sgs_tx, sgs_rx;
-	struct virtio_net_ctrl_coal_tx coal_tx;
-	struct virtio_net_ctrl_coal_rx coal_rx;
 
-	coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
-	coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
-	sg_init_one(&sgs_tx, &coal_tx, sizeof(coal_tx));
+	vi->ctrl->coal_tx.tx_usecs = cpu_to_le32(ec->tx_coalesce_usecs);
+	vi->ctrl->coal_tx.tx_max_packets = cpu_to_le32(ec->tx_max_coalesced_frames);
+	sg_init_one(&sgs_tx, &vi->ctrl->coal_tx, sizeof(vi->ctrl->coal_tx));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
 				  VIRTIO_NET_CTRL_NOTF_COAL_TX_SET,
@@ -2950,9 +2950,9 @@ static int virtnet_send_notf_coal_cmds(struct virtnet_info *vi,
 	vi->tx_usecs = ec->tx_coalesce_usecs;
 	vi->tx_max_packets = ec->tx_max_coalesced_frames;
 
-	coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
-	coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
-	sg_init_one(&sgs_rx, &coal_rx, sizeof(coal_rx));
+	vi->ctrl->coal_rx.rx_usecs = cpu_to_le32(ec->rx_coalesce_usecs);
+	vi->ctrl->coal_rx.rx_max_packets = cpu_to_le32(ec->rx_max_coalesced_frames);
+	sg_init_one(&sgs_rx, &vi->ctrl->coal_rx, sizeof(vi->ctrl->coal_rx));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_NOTF_COAL,
 				  VIRTIO_NET_CTRL_NOTF_COAL_RX_SET,
-- 
2.17.1


