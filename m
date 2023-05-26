Return-Path: <netdev+bounces-5741-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 385547129C2
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D85511C210E7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2473B271F3;
	Fri, 26 May 2023 15:39:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09503848B;
	Fri, 26 May 2023 15:39:14 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2121.outbound.protection.outlook.com [40.107.92.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA95F7;
	Fri, 26 May 2023 08:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gj2Ex4MuyDqinYCingp9LOot2y9kr+sVknl8iir8lARn4CbTzdqO1tAIuuZcN950NFGuBF/7U2r6of7a57fB2vuEui+JJ01CaOc46tpQLdcumhMV21LDMXFeMxtNCt53OzTbZ0ioGwzcLjBdvVMBzQ7u1NHwEa+vfw1j4S9s+Ke5C76BGhB74KDxfgpZzmY2fv4dayEYWch8OajgQpSSNNWsIWzqhyRdfccTjRLG65S9qawWK4omAVz2+4PlGdfqCcTwl7kx+PcPXU3vmxZHIrANqxD3JQ7UbeR9nbGRVvW2YLOxKAh/mZbU7uYduZ4o0mHD9OU4yNOa4JxtZIZ9aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noDpS20b/QNn9KFgul8WRoxfEL4Swpgm7ZEQn7Kq2/Y=;
 b=FBBq08y74za4CNhBTpL42J4qOpeYxJEwRUqDkW1cnPPHVkc9aO27aLEKMkxTEByZznHa7wY0UqnL3K1E7mRfNAc1iRWkttqCHpYTjEBmiU+BvU/rYqk4DfEh/sUCagAvos4rf3oHzAK769OPvpavabAvM6K9RObpLkaQXdPtbaUZCeR/xJ2eVRcQlxjBeaGRwiCvyZfX2BMILOM3HpwRai6EG9P5s2GfWs0uAoxrxw0pskOHfnDmxUfzqQ2tVi5Z7zufIig4ZT65xO2D7P0GmbLY3f/Y68b6PO3LaaGtnpeJUJkwdIOuYX8d3HlW5m3iwOnt8LdfP72Kr+9199BJ6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noDpS20b/QNn9KFgul8WRoxfEL4Swpgm7ZEQn7Kq2/Y=;
 b=aVGod2UDBL/397WoX/EV5WnAoU62R2vPq2dawgfur8HWIo/tpr69IH33cVh0BbJigDZJs6u1QIhJrTdqlHdqud9l+uQ2n49jbbJY63lDFmWqEn1dKSUFgIgc+W7i4GTYJi6F1HQb9iGR9H2spBHQOf/aFY8k9brH4QtBL6PfSCE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by DS7PR21MB3342.namprd21.prod.outlook.com (2603:10b6:8:81::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.7; Fri, 26 May
 2023 15:39:10 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::9d99:e955:81ed:40e0]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::9d99:e955:81ed:40e0%3]) with mapi id 15.20.6455.012; Fri, 26 May 2023
 15:39:10 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org
Cc: haiyangz@microsoft.com,
	decui@microsoft.com,
	kys@microsoft.com,
	paulros@microsoft.com,
	olaf@aepfle.de,
	vkuznets@redhat.com,
	davem@davemloft.net,
	wei.liu@kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	leon@kernel.org,
	longli@microsoft.com,
	ssengar@linux.microsoft.com,
	linux-rdma@vger.kernel.org,
	daniel@iogearbox.net,
	john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	ast@kernel.org,
	sharmaajay@microsoft.com,
	hawk@kernel.org,
	tglx@linutronix.de,
	shradhagupta@linux.microsoft.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH V3,net] net: mana: Fix perf regression: remove rx_cqes, tx_cqes counters
Date: Fri, 26 May 2023 08:38:57 -0700
Message-Id: <1685115537-31675-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:303:b9::31) To BY5PR21MB1443.namprd21.prod.outlook.com
 (2603:10b6:a03:21f::18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Sender: LKML haiyangz <lkmlhyz@microsoft.com>
X-MS-Exchange-MessageSentRepresentingType: 2
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|DS7PR21MB3342:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a6e5571-2a4d-43bd-a3eb-08db5dff5918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	93Bzok04MrJ+OhqNiObC1UG4q6gwfLjnWZQwI9O+DxmL07KDyH+LdYnWtfAYQlR9T1uNN6q1kqhZ/RWDWOrXMAqdX+cZnqZ0s1HEcOlCcjzvhpItUIwhgntUm+oV2XwGciFCSoUoud2qzSCDKNp8u+Tk3yj/e1TyzdC2tAm2X18KmYy7Osx32MQytVHUJfhvIuEnKkdvdKtcHL4Wu9oY7OV8+TULsYJzepILhDo3TXWvBGOPrEI36bxv/k+91jQBnRe3nwQDc3WIGeEQYi3nTXTSnnjevXULHj3JeVkVWChL18fViML7rSorsAK5i4wLcnwvk2OIgZqr43QJ5jGnolUUkKe0bK7QQRE7xujnuTZhBkzDgidsRnzel3YoDV/YibX/RyftcTCIjz6xhn2PlzGBeoCK/i/LXmsiNSMCTZN+qd9H0wlZ8GO4biYOT0eVDjB/hfQT+23Zmj44TeNpke+a10vhMwTD0VD512Zte2X1iH1+B/POwwjmypHBfumTJokCnbxsYtmz2fgcXZdfAfrdzF873h2OdL2ybUSJsDB6c5FA0ynzLvQk5wwf5BiI/KCKPZbKj0S7/+XAbX4n+b4WUMfSoqqxu/dxhMlgQ4/bwyDQDqLYUw3RbdUlSGWA7zJJf+Pt2YVwfO1hTQypxvepa4gYpwDuIcDmT8iPmtk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(366004)(451199021)(2906002)(7416002)(5660300002)(8936002)(8676002)(6666004)(41300700001)(52116002)(786003)(66556008)(316002)(66946007)(478600001)(36756003)(7846003)(4326008)(10290500003)(6486002)(66476007)(6506007)(6512007)(26005)(2616005)(38100700002)(38350700002)(186003)(83380400001)(82950400001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DYumfTT94XYg2qo766ESjPh38KDmua2GWSqNAI01FfNwnYiQqJPDxNHlX9oF?=
 =?us-ascii?Q?CK/anTYIbAyoypy3UUgKias9WGvRx1QxKq2JVpd8OWhoM6KQmKw49nN1yU49?=
 =?us-ascii?Q?R73/PepMVMcbCWBsUNaHAhmw/gQSRHWD2VnwEnpUZ76M1gPcuG+SmXQfMDT2?=
 =?us-ascii?Q?98Ri+dNsDFa8SCIW3hduZmriD0SCG8pFhLixoKGDD7YQfMBsdqlWREEdUefd?=
 =?us-ascii?Q?KTiVOFDJf6P8qSdZOw+F85IwasMLNt/8Wk+furzAuwtN5TOGU5pAln8BqqG4?=
 =?us-ascii?Q?DOtnn7wyuv5PbtnkBpGOIygoVLH/cf5pY4Y38Jr77dlv2drbRETbEmB1+nsB?=
 =?us-ascii?Q?CVMnffIGyRyFTcUX72Yo9Hhf/5g50tYSwYguinZV7gSeRgxJZ4zneBaFPm7d?=
 =?us-ascii?Q?cIXNk07PLQU1bWw36LZelKLfHQN7gJ+iP8yPLUZrUkSqo8LtCNN3v3IiIc2J?=
 =?us-ascii?Q?GCf3r2mGMTucToOhHs5fQQ+8oVOzocYmChx6J6ElqoZowPEXi4rH5xdiY+yN?=
 =?us-ascii?Q?51FCD6tYbR0fJunZbi5VptoQYEEsxwgo+cv5O8mwfXw821HIVLXtpT+SMUcP?=
 =?us-ascii?Q?J4F1idyByz0ywK8rl1rDb6v1iOuvsElhSU3f4xVQ/MuQ2mVPrC7OaJTPuxLH?=
 =?us-ascii?Q?h/QCRnXLIkoYJE1HUIbFTML7bJp7auWMMn5pp/s3vcWJaTvrwdEbTJ/p1Il1?=
 =?us-ascii?Q?rbMMo+D+deE2UHklsIN/R8QmRIKBf8auxYd36VZ7T+QkujWsvsqsrLbf2jLE?=
 =?us-ascii?Q?gB7ORJRqjO6nxYmLJu5VmdDWJys+TdxqFcp5TLKZD2S2lvXrgZlC2GKe9Kqg?=
 =?us-ascii?Q?sbOwzSGBDaOOkUA6TJf50Q6MCb4FwopJZLQlBOJPDvovPq0MbN0H+QcHCmdr?=
 =?us-ascii?Q?QoG1SWRv5X84a6MvkMXEHBvuQ0j84tQ+lX2UKcX8/LL53tNg7/u3oIJk8DaK?=
 =?us-ascii?Q?Lccb/xkZeoVqHLn5o3rCErkBMXbHOTHfOAH7C+sR7td1OYvFUh63RUv4IXt6?=
 =?us-ascii?Q?QPMVjTL+kLZr5pkWLXxJQnj5eSWAmd5bK8nCbXZFixKjWXZr38NmCkHYl9bE?=
 =?us-ascii?Q?8vf4L1ftdFBgnnLxBituYEF89RFoUfrwquAHh4DKsQcGu55YZt+UmnGhO9XR?=
 =?us-ascii?Q?og5aKh007HDIfS4R6mmk64C7VwPKL+O6V22WAB55EBRAkmOpF8moayjInAH7?=
 =?us-ascii?Q?M3gEBLkLnVGyfljYnxawKTRbdlhE0WLyFI6XeUDlE64/WqIL4hmx4nmIZ7ol?=
 =?us-ascii?Q?kKt4cW54bAQ4jlSk094BDupOwpB+dDgzT9tfQpEH3EiAMRCF9pUSV5kgBQ+C?=
 =?us-ascii?Q?Da2m9I0hUlw/KhqCb4SlhVQs4ZrMIYBQf50tuzt+bj/m8c4JXniEeMTxGGX+?=
 =?us-ascii?Q?2wQ16aFuM07AJW6JKHxF/qabT6HUs3PXlBK7DB1hccMWPSIM/FwLxOTUjsn4?=
 =?us-ascii?Q?dKdJyCb6VOIKbrnI6hmlsVJOzk3O2tjujXWx9qTF9Y91LQBffwEUBYsByjYK?=
 =?us-ascii?Q?Tr9FPyAgkNuhMhdr64+wJ46oRblWkggRYAw4KFXNrp9nv0unZH2autpqei2c?=
 =?us-ascii?Q?mTtHBnDTX2IupCgmWYDDGxdA8Fo+7ozywIVwdzkw?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a6e5571-2a4d-43bd-a3eb-08db5dff5918
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 15:39:09.8931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 36Svb70nlQF0RXRAk+nE7wAPC9x/0MFZ8oOTm8r7agFHeRIaCTwQRpUaBDt3oaaR58A2JevwpAQr/W9i4UO7Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3342
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The apc->eth_stats.rx_cqes is one per NIC (vport), and it's on the
frequent and parallel code path of all queues. So, r/w into this
single shared variable by many threads on different CPUs creates a
lot caching and memory overhead, hence perf regression. And, it's
not accurate due to the high volume concurrent r/w.

For example, a workload is iperf with 128 threads, and with RPS
enabled. We saw perf regression of 25% with the previous patch
adding the counters. And this patch eliminates the regression.

Since the error path of mana_poll_rx_cq() already has warnings, so
keeping the counter and convert it to a per-queue variable is not
necessary. So, just remove this counter from this high frequency
code path.

Also, remove the tx_cqes counter for the same reason. We have
warnings & other counters for errors on that path, and don't need
to count every normal cqe processing.

Cc: stable@vger.kernel.org
Fixes: bd7fc6e1957c ("net: mana: Add new MANA VF performance counters for easier troubleshooting")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>

---
V3:
	Add test example as suggested by Jakub Kicinski.
V2:
	Same as V1, except adding more Cc's.
---
 drivers/net/ethernet/microsoft/mana/mana_en.c      | 10 ----------
 drivers/net/ethernet/microsoft/mana/mana_ethtool.c |  2 --
 include/net/mana/mana.h                            |  2 --
 3 files changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 06d6292e09b3..d907727c7b7a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1279,8 +1279,6 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 	if (comp_read < 1)
 		return;
 
-	apc->eth_stats.tx_cqes = comp_read;
-
 	for (i = 0; i < comp_read; i++) {
 		struct mana_tx_comp_oob *cqe_oob;
 
@@ -1363,8 +1361,6 @@ static void mana_poll_tx_cq(struct mana_cq *cq)
 		WARN_ON_ONCE(1);
 
 	cq->work_done = pkt_transmitted;
-
-	apc->eth_stats.tx_cqes -= pkt_transmitted;
 }
 
 static void mana_post_pkt_rxq(struct mana_rxq *rxq)
@@ -1626,15 +1622,11 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 {
 	struct gdma_comp *comp = cq->gdma_comp_buf;
 	struct mana_rxq *rxq = cq->rxq;
-	struct mana_port_context *apc;
 	int comp_read, i;
 
-	apc = netdev_priv(rxq->ndev);
-
 	comp_read = mana_gd_poll_cq(cq->gdma_cq, comp, CQE_POLLING_BUFFER);
 	WARN_ON_ONCE(comp_read > CQE_POLLING_BUFFER);
 
-	apc->eth_stats.rx_cqes = comp_read;
 	rxq->xdp_flush = false;
 
 	for (i = 0; i < comp_read; i++) {
@@ -1646,8 +1638,6 @@ static void mana_poll_rx_cq(struct mana_cq *cq)
 			return;
 
 		mana_process_rx_cqe(rxq, cq, &comp[i]);
-
-		apc->eth_stats.rx_cqes--;
 	}
 
 	if (rxq->xdp_flush)
diff --git a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
index a64c81410dc1..0dc78679f620 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_ethtool.c
@@ -13,11 +13,9 @@ static const struct {
 } mana_eth_stats[] = {
 	{"stop_queue", offsetof(struct mana_ethtool_stats, stop_queue)},
 	{"wake_queue", offsetof(struct mana_ethtool_stats, wake_queue)},
-	{"tx_cqes", offsetof(struct mana_ethtool_stats, tx_cqes)},
 	{"tx_cq_err", offsetof(struct mana_ethtool_stats, tx_cqe_err)},
 	{"tx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
 					tx_cqe_unknown_type)},
-	{"rx_cqes", offsetof(struct mana_ethtool_stats, rx_cqes)},
 	{"rx_coalesced_err", offsetof(struct mana_ethtool_stats,
 					rx_coalesced_err)},
 	{"rx_cqe_unknown_type", offsetof(struct mana_ethtool_stats,
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index cd386aa7c7cc..9eef19972845 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -347,10 +347,8 @@ struct mana_tx_qp {
 struct mana_ethtool_stats {
 	u64 stop_queue;
 	u64 wake_queue;
-	u64 tx_cqes;
 	u64 tx_cqe_err;
 	u64 tx_cqe_unknown_type;
-	u64 rx_cqes;
 	u64 rx_coalesced_err;
 	u64 rx_cqe_unknown_type;
 };
-- 
2.25.1


