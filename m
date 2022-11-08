Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D88A1621A7C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 18:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiKHR01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 12:26:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234479AbiKHR0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 12:26:22 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8070B1180B
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 09:26:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5ZpO2ItYyJEueLvYhTBgybOWcQFqM9TFro/XGdvRhiTYCyifIByjOZhYI0D9D7CDwFTs2+N5kU2lJVpL8+gCxpB+B1cgrXlUS2an6DdoPkgnL4LaEvgW/18jCKes8QJrIrs9ABZPXFA8vEGO57Tdo534y8EXL4zegaMO0Bs7vI8MBgD/zefdJfB9+/LqMvXjzIsOsmTLw0NcqO75Ded7jW+XA4LGi7vCVeLhvszEHUuB6LN7xt+3U4ZaTlCFGbdIa8rKq26dm3CckJR0MFruWzjma/nPvU1xiD7c5JaqoXwfjBPkz3ktItTqNU7fCeosHj8lsVV4h60F/c1Pubvvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ur1v9i8cztku5khQmXg6iBWzYmQurLqOvhdyp37bJSo=;
 b=SgD9UfsqSJP3YrFYtCzJ/l/B5qfVEeR9QN7KDbtJ1g0UrVY34lcgk7TKNbwxhMles5RDmvOc0A8o+48Fzkn/eIbUQmrk4atJvCtRmzBT9F2VhWLFWoZoNtvmy/xmRGjOAZ9z+s4gr2bVyDiEPPnNF1kc9fToycoMwMOZXRdwdl/J9hkj1f/vk/0z7un5I8G47oA6BFGsJbtSUM1NayietvMLTQyMdll01MYzyl16Cfcz5n/koqFAoiuD9WKyN7VgHT+Lp3twnVRlV+K5fCXG4EwcJZH9tW9U+FBO4U04rho75wWxRI5Izsuh11JumtzGbIXldkOkxmSagud45HjNkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ur1v9i8cztku5khQmXg6iBWzYmQurLqOvhdyp37bJSo=;
 b=CXMvRy1DsyAhIVwMHyyVXxC1rECw7N9p9qnaJlZth3A33a7smFrL40SIohI65JHSrxIjGSJlGfySwLOF9Th7QYnliJ7cDQMNMpZI1Ll5YubnKjMuRAsIr0f9tKIHsgY5vvoDSc1m8d9rIUWsGR7DslhaTbfglG9+pHIR/4qmhvM=
Received: from MW4PR02CA0020.namprd02.prod.outlook.com (2603:10b6:303:16d::26)
 by BL0PR12MB4898.namprd12.prod.outlook.com (2603:10b6:208:1c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 17:26:18 +0000
Received: from CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:16d:cafe::96) by MW4PR02CA0020.outlook.office365.com
 (2603:10b6:303:16d::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27 via Frontend
 Transport; Tue, 8 Nov 2022 17:26:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT047.mail.protection.outlook.com (10.13.174.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Tue, 8 Nov 2022 17:26:18 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 11:26:14 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Tue, 8 Nov
 2022 09:26:13 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31 via Frontend
 Transport; Tue, 8 Nov 2022 11:26:12 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 02/11] sfc: add start and stop methods to channels
Date:   Tue, 8 Nov 2022 17:24:43 +0000
Message-ID: <3a03be683b481c05be76c3d91ebff0b53d2f3b6b.1667923490.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1667923490.git.ecree.xilinx@gmail.com>
References: <cover.1667923490.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT047:EE_|BL0PR12MB4898:EE_
X-MS-Office365-Filtering-Correlation-Id: a0c25df4-3806-438b-095b-08dac1ae58e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YoPBgmaSHERZpjcRcUoDdxB0i5mrMrBnvDGMMitVufT2udlo9vYjHEpbp4Up8ORUaxJ29V/ev+aLp0/WYM7MNOf+aUELBh+XsKccOKtzzGHEp1krE3XO0ziPaOSThLpj4C6Hq+SAWb/OHBCs4d/OlitCgtRK4hhY2JfiK0ieeomCTd5e+KSf+IIerGEfev7c4sNhG5Map2V0YaKijIJMf+ZHE25NWPgldDTI1zHOlTAJpgyJYUfLx5/PkeBiK3rpr7MXBBHORAIDC5S9+iNXZGmwn6GyJX087i22e5qxIfXWZRHw5NNBXV/E7mqYNPh3yQehBr88BSY+0a/7fyMjZ7kDOhiAtVq6NrTp8epXVw2gcs2LzrDpFR4cakoN+GH/TpBbkdCIw72TpsmfofxEQGme9lZKm6UqSn5B17F0tucX5kzYxPi+FFmraUEqoZrrQ2i6SGhdT2V2pO7Ns4j14MmulEtJNGJTP3r9R4JwGkM9pJTiKScgaZewRmlb0sZH1gaJKN8Uu4aFHSffVFac3CXXVnbYJhLaYU/tjJqRO5aKBjC+3kjYpFsSoUpQDvLxH0xyO1Qhsl1WlOahkRflC+pZLVvLXzag9hxl1SywYb69RKYxVLmxRJzbQkWIy2/1WfaUSfRn9eVLpI2OS6mXLsCYmVPxoEH+miILIM8C8LKK4EH3GccaPfqvDtJmnhKXhtJpLREXMIZUPzFBq/XOSBm5D66ckNjMCoqGXsjZju/TBiOHWXw9IYROjlO4TbkteX1LuP0M/avOFCKrSqMVSmSUie+Dw53ybAxInfqPZVRKcNeyIIsjml0g1TadB8fkpkS2zP+K0MRZFQAx+BXS3w==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(46966006)(36840700001)(40470700004)(6636002)(82740400003)(316002)(9686003)(54906003)(86362001)(40460700003)(55446002)(478600001)(110136005)(186003)(426003)(83380400001)(6666004)(336012)(36860700001)(82310400005)(36756003)(47076005)(26005)(8936002)(5660300002)(41300700001)(70206006)(70586007)(8676002)(2876002)(4326008)(356005)(81166007)(40480700001)(2906002)(448954002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 17:26:18.4619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a0c25df4-3806-438b-095b-08dac1ae58e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4898
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

The TC extra channel needs to do extra work in efx_{start,stop}_channels()
 to start/stop MAE counter streaming from the hardware.  Add callbacks for
 it to implement.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/efx_channels.c | 9 ++++++++-
 drivers/net/ethernet/sfc/net_driver.h   | 4 ++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index aaa381743bca..fcea3ea809d7 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -1119,6 +1119,8 @@ void efx_start_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 
 	efx_for_each_channel_rev(channel, efx) {
+		if (channel->type->start)
+			channel->type->start(channel);
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
 			efx_init_tx_queue(tx_queue);
 			atomic_inc(&efx->active_queues);
@@ -1143,8 +1145,13 @@ void efx_stop_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 	int rc = 0;
 
-	/* Stop RX refill */
+	/* Stop special channels and RX refill.
+	 * The channel's stop has to be called first, since it might wait
+	 * for a sentinel RX to indicate the channel has fully drained.
+	 */
 	efx_for_each_channel(channel, efx) {
+		if (channel->type->stop)
+			channel->type->stop(channel);
 		efx_for_each_channel_rx_queue(rx_queue, channel)
 			rx_queue->refill_enabled = false;
 	}
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index efb867b6556a..b3d413896230 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -585,6 +585,8 @@ struct efx_msi_context {
  * struct efx_channel_type - distinguishes traffic and extra channels
  * @handle_no_channel: Handle failure to allocate an extra channel
  * @pre_probe: Set up extra state prior to initialisation
+ * @start: called early in efx_start_channels()
+ * @stop: called early in efx_stop_channels()
  * @post_remove: Tear down extra state after finalisation, if allocated.
  *	May be called on channels that have not been probed.
  * @get_name: Generate the channel's name (used for its IRQ handler)
@@ -601,6 +603,8 @@ struct efx_msi_context {
 struct efx_channel_type {
 	void (*handle_no_channel)(struct efx_nic *);
 	int (*pre_probe)(struct efx_channel *);
+	int (*start)(struct efx_channel *);
+	void (*stop)(struct efx_channel *);
 	void (*post_remove)(struct efx_channel *);
 	void (*get_name)(struct efx_channel *, char *buf, size_t len);
 	struct efx_channel *(*copy)(const struct efx_channel *);
