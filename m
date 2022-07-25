Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7884657FA97
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiGYH4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiGYH4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:56:49 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2059.outbound.protection.outlook.com [40.107.101.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83FBFD135
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 00:56:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leTkxv7g/iu4Ex9qVs9FZUcjFZ9MSZevUKRS8MzuZnbPb9jp2Tm42gegb+PtvHw1Jn6CAs7v3vAkjp+PVdj1803xZg+EuYuvjgsc14+k6i1oeVSB5Bd2uEO3XZFUKUj7vrHLfuo25K+Ec88EQx6OTRtD4nDpyn/gJ/fECmnQc0Br63m1HcyaZ8RtCmnYzVv2nBxdvj6bRjV0PWciGS3xQoVXUxx25YOIrRU2NSqLqAxJ8kzYGVgLdeVn7XhuBfcteh4w/7NtNkqy2SA+50caEj69KlZ1zZ0XhGXTshzFsZqizw7ZF+97iT4fUzzh6SMJ2B2aYILErBNJpTWw4cCZWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PrlUJtx5NAaFaCw8XMbeUWUI6sI00Er2AjzC0yUB0VM=;
 b=jJ0E3Hmy6J7oUf0BOEVBIc1VUqi3yb3oBm9vltVrYuHAjheVjfb6dPSrkE8wSa4oHRDtnneAOrX7U6JKfqcBAptoWLHY2uk1QF/zmRe1j58Jy90WFb4OCggg2YhzoZ3z8IyqP5MEZbzIy4uqPWlUpnoIdhAws8r7j2TabFZNManVXDEr47ULExG3itGWcrrKoKDKT6DDlGFAq9ANyDvaHTWty/Cbs0G+f4qsXcX07LR9RZ4uca1OiG5PEdf7CZqTBL9o12zX+Jt2cCtWD6vkP/pHc16n1CqP4uF9zXaZV6xu7SjYKqTxB9nND0BIOnZKSWYxt2ZcDCzgSy9kkLWpoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PrlUJtx5NAaFaCw8XMbeUWUI6sI00Er2AjzC0yUB0VM=;
 b=Tc1E4FDy9cEsRFZE+oihftRrQEdeEqXPK047Ciod1mQDDG6dhtgrDgRnLccbDfEBcMZE+XMooralSz9BScGaDp9oHsKSwgnVHuHuUwgpELi7L+eXL4WjXP+k0vUCOURi6PvUhoVqfIVaurnk156U+44zGqr3Yp+Dz/ynoPs9GZs=
Received: from DM6PR03CA0055.namprd03.prod.outlook.com (2603:10b6:5:100::32)
 by CH2PR12MB4939.namprd12.prod.outlook.com (2603:10b6:610:61::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 07:56:46 +0000
Received: from DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::bd) by DM6PR03CA0055.outlook.office365.com
 (2603:10b6:5:100::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23 via Frontend
 Transport; Mon, 25 Jul 2022 07:56:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT047.mail.protection.outlook.com (10.13.172.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Mon, 25 Jul 2022 07:56:45 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 25 Jul
 2022 02:56:45 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 25 Jul
 2022 02:56:44 -0500
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 02:56:43 -0500
From:   <alejandro.lucero-palau@amd.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, <ecree.xilinx@gmail.com>,
        Alejandro Lucero <alucerop@xilinx.com>,
        Alejandro Lucero <alejandro.lucero-palau@amd.com>
Subject: [PATCH net] sfc: disable softirqs for ptp TX
Date:   Mon, 25 Jul 2022 09:56:35 +0200
Message-ID: <20220725075635.11685-1-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50d17b6a-e480-4a6c-112c-08da6e133877
X-MS-TrafficTypeDiagnostic: CH2PR12MB4939:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TQQv20lJbS+/scDWITt+4ONLnXLXTigBHX0Uzk7DJ2CH7GnMq3AFr7mF2finPeY6xSMLlHXOXYjF+m2EK+62Cn5kO0/KepD92b8KZbTIyntEhhS0cIUszfiRr2yMrjCtyTvmU32voiuoBVUokWVo6nJ55V/50pHpRbJaByvLrll46R3FikF79hRuY5n3hGS+TqnzKxy1xl9ZdhwXB5191ZdDiJHqcz1Ujvk7YIS2Yd+kcwlzzL3QfnOBfD+9cN4cFfTfrJwCafRBQ3Mo3LRH/SvbjLtfHDmhCs4YacWRkHX6flf1kxeIcFJDu48veu7jxKDwihVlphYHz4pWyr4A2lywN359QJWQNY0isl/jA+nDcxtpiTGq7cuX/Xv08j6LvJP7vcv86sD4rfHL6WYqLHW2Bdgj6QHveoJ3iywt9mRc6LQRHKzYVjIauhfr7SRXe/awDF1+pHYmjIBgaL+ybDqSZT9H51qdP+8JQg5aeKoQ2VMh5iU+JD/o+Me0zq14eK1IiWmXDOwJdxgZxOyiYsZp8VXdv4b+ZNdaZ7rAfiKhz1q/XYpxS9HGPjFA/HYYM+LvOzAeQU32phBwTf7Rz49q6MPc7EhYkqWC6mTmedE2CPA0q8FDojqhO0HYFeSpuHqAJdSffcwWVm5o3+568FevRssM7+eaNnWLbmjAdCtdRm8r1HEJXoDB3RZBA9RntWU8tWoriwX8JdOFlGLXosEYL9O/enYo4vyz0xY8Si6YnxURVTtGa8SR5zvWQc9vfPA18Hlgzac2SKU9XLGnE8/4KAU3RlbffLC5Vk+UQLz6HvIjU6RHOpQ7AztdN0G9n77vhHpvNIsOy4uD3p5pLw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(376002)(39860400002)(40470700004)(36840700001)(46966006)(82740400003)(356005)(478600001)(81166007)(86362001)(41300700001)(426003)(26005)(6666004)(110136005)(6636002)(316002)(54906003)(47076005)(1076003)(336012)(186003)(2616005)(40480700001)(70206006)(70586007)(8676002)(82310400005)(4326008)(5660300002)(8936002)(40460700003)(36860700001)(83380400001)(36756003)(2876002)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 07:56:45.6014
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d17b6a-e480-4a6c-112c-08da6e133877
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4939
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alucerop@xilinx.com>

Sending a PTP packet can imply to use the normal TX driver datapath but
invoked from the driver's ptp worker. The kernel generic TX code
disables softirqs and preemption before calling specific driver TX code,
but the ptp worker does not. Although current ptp driver functionality
does not require it, there are several reasons for doing so:

   1) The invoked code is always executed with softirqs disabled for non
      PTP packets.
   2) Better if a ptp packet transmission is not interrupted by softirq
      handling which could lead to high latencies.
   3) netdev_xmit_more used by the TX code requires preemption to be
      disabled.

Indeed a solution for dealing with kernel preemption state based on static
kernel configuration is not possible since the introduction of dynamic
preemption level configuration at boot time using the static calls
functionality.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/ptp.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index 4625f85acab2..10ad0b93d283 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1100,7 +1100,29 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 
 	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
+		/* This code invokes normal driver TX code which is always
+		 * protected from softirqs when called from generic TX code,
+		 * which in turn disables preemption. Look at __dev_queue_xmit
+		 * which uses rcu_read_lock_bh disabling preemption for RCU
+		 * plus disabling softirqs. We do not need RCU reader
+		 * protection here.
+		 *
+		 * Although it is theoretically safe for current PTP TX/RX code
+		 * running without disabling softirqs, there are three good
+		 * reasond for doing so:
+		 *
+		 *      1) The code invoked is mainly implemented for non-PTP
+		 *         packets and it is always executed with softirqs
+		 *         disabled.
+		 *      2) This being a single PTP packet, better to not
+		 *         interrupt its processing by softirqs which can lead
+		 *         to high latencies.
+		 *      3) netdev_xmit_more checks preemption is disabled and
+		 *         triggers a BUG_ON if not.
+		 */
+		local_bh_disable();
 		efx_enqueue_skb(tx_queue, skb);
+		local_bh_enable();
 	} else {
 		WARN_ONCE(1, "PTP channel has no timestamped tx queue\n");
 		dev_kfree_skb_any(skb);
-- 
2.17.1

