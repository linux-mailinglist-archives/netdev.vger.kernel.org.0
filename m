Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B5B628108
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 14:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237478AbiKNNQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 08:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237299AbiKNNQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 08:16:27 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B3F14D00
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 05:16:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpWxX+RGFJhCc1hABYOnSv3H91WtarPkI7hP+NexIfRAilBwRQZX7Wj0CSqdkWkrUYzUtkAkSsaYBxopo8/Vc95DB7lwo+n/I/lsUqdSXwW10ynYTRzzo1PuphhzSNdL15RMpjApVdHptIVIfXdIFKP2bIVOSOJI/VD61cm399BWDF3id1B1de1t0uNTB8BUlAUCNlSG65MkQH15+5Ij7/OFAc81ANNNxL+Eeo+CwxFtcgJdk6HhlWBA5bWRRToEjyl9/ea5bnh3WVOhf7YWvcTFCxklF12wb+SdNEF3VSxMSopmfvJZigQ0hZw1O/85kQVDcUfPj7bdH5iyDEwBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ur1v9i8cztku5khQmXg6iBWzYmQurLqOvhdyp37bJSo=;
 b=Eigr10zdmi26R7MEuf1f/noQzmcJjtBFDO7Cksw1ErqNqcccEserMgX6k80aMQLJZdoSmFj//1ilK+uhYa67svU2U2DxMzyomnATtdOdCyDSuE4MsDN71tnIYw21RkamZgAYFA7dstrwL4nSo1efXCIpaKT6TGMFksiedIpK+2Xi/Aq6Mzfc3jrKWNLPGYpKkHmn397oCHwC+EUPQsC/FBi/EkLLU6FBLVV4z723pq7KsqiHSQLfzG1ZUsffFRG+iQGZh6bLBPgDbrYJuqObKIMLqJTyWKt/9DCDuJvDrT/yvYzQ9V96F6367c4ioOWn1vGvlMlyaj3oj6yaXDTuWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ur1v9i8cztku5khQmXg6iBWzYmQurLqOvhdyp37bJSo=;
 b=Bvw2AHZwlGwSbZveHHIrubkstoe0PibFrGinNdV4lJKjBJxlbDIkafE+PC8egEhhE8YOpvtzL3injICYDjlFbp1BZVPgWbvvtIcZ3FutmIF93DfvfwZdalZakt9raj2cR8mkT/NSTh5lYDSrlcM58y9vfhvkOK7/XJ2MVgXEmfs=
Received: from MW4P223CA0028.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::33)
 by SA0PR12MB4430.namprd12.prod.outlook.com (2603:10b6:806:70::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 13:16:21 +0000
Received: from CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::d6) by MW4P223CA0028.outlook.office365.com
 (2603:10b6:303:80::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17 via Frontend
 Transport; Mon, 14 Nov 2022 13:16:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT007.mail.protection.outlook.com (10.13.174.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.12 via Frontend Transport; Mon, 14 Nov 2022 13:16:20 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 07:16:19 -0600
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 14 Nov
 2022 05:16:18 -0800
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34 via Frontend
 Transport; Mon, 14 Nov 2022 07:16:17 -0600
From:   <edward.cree@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 03/12] sfc: add start and stop methods to channels
Date:   Mon, 14 Nov 2022 13:15:52 +0000
Message-ID: <acfbf08f90b4c85c245fbabdd5ebb0eb530d18ca.1668430870.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1668430870.git.ecree.xilinx@gmail.com>
References: <cover.1668430870.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT007:EE_|SA0PR12MB4430:EE_
X-MS-Office365-Filtering-Correlation-Id: 27ea10ab-6653-4608-0503-08dac6426bf0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yavFjnucHMigI5nw3TybbPFNrF4mL+DTpMzf0GgDS5eRPXCCkVZ4vy+PAWRqeAn5oiUou5x4L4BFoOQIHnS9IGOlTSz8+O/133h4rMRufTFbRLtKjNdrR1fsBmajzEDaUGMH/2bdg2czNkTnc7WpigAu1Tcr03/8xkDXwtJjD0RGFiupCXOB0qVrrU2BFWFKEvGQN6w6+9WhuoTmu6ZymkElAu0sljiG5gtw5dcMnOkydBJTbbdGdQh7kCFnlCOhPC9XXkVdrFIMqnrlW7DLw/4kIBsps7pSS+JopDfvs/cI3UUOhw8J19Z9MnF8Mr7TQzMYA7CKcJqRvfDBgf4p8ePVbMIw1HFwV9jCpOvil137r8RVNMZoM5uX8qwSrqSpTspqmRtEoTFa24SgbrIX48unM9zqc8JoEZmJujmtVchN6fM05sM/Ml9kgcEBy/yidhnYH4kLA9j0H00dinT1VLOpXqm0/U62LKcg3L5ESPmiTQaiLF1VyMnvJdNZYDaiUyo2YtFeP0C3toMjxZ1I8FWM7+GqOLTcEakwfs0XWVh4VJESo9hJqIaDeg0U8L1ed3ByK79Z7p/MqfIfBg3sT+B9vLXZMh6qeTVpSTo2yoBZ37eWqtVBrvTFIKp9mUnEVmJQGYnBeDD/yKSft4K2l1+vTy0Jw9pKXhrivlIQNweVLWYktH1rJ/EGASQLv3cNHIj7E8jkCM+b9TMxlHAgHaKdawrWAgJ1yN266N2j0cFjIQIv2/p2cWAjCt3BawYoiJ9TzK8zBO5RDVuZXYGUHWgbDxK/2YrqUYnE80sbjARxATsboTcEQiBfnIqSL6+SEhv43TyXO/FkdeId8r0VhQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(86362001)(55446002)(40480700001)(2876002)(356005)(82740400003)(81166007)(83380400001)(2906002)(36860700001)(316002)(70206006)(6636002)(478600001)(186003)(336012)(110136005)(6666004)(47076005)(426003)(54906003)(70586007)(40460700003)(5660300002)(8676002)(41300700001)(4326008)(8936002)(9686003)(26005)(82310400005)(448954002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 13:16:20.5661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 27ea10ab-6653-4608-0503-08dac6426bf0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT007.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4430
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
