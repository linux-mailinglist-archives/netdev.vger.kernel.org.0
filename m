Return-Path: <netdev+bounces-5173-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 942CD70FFF1
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 23:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2324E1C20C93
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 21:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D6022632;
	Wed, 24 May 2023 21:23:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE68200B0;
	Wed, 24 May 2023 21:23:21 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020016.outbound.protection.outlook.com [52.101.61.16])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2138A1A1;
	Wed, 24 May 2023 14:23:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf1hayWDjbjF60GVI6qFm9CGEb3pVXFfKPmftZTZQkwccbrD2t4OT/PF2HnERIY8s7SpT5H39dWEF1E8Xzsoc0s3y8i3+zfsssjP0APMTGVtFlbYkpZksonPGZT7Lwup9GNwB1D9WRTQ3iwCFQ8a14AElosGMz91sSZFPhtc8kLh2Ta73XcOraZJguxyzxrkHF/VzbT7pIArTwM+tiTUAJubutKAG4oYhII/zFehvW9/HZWC68cUrAUTTI/3ssQgiuQfTEwkwfttwb34o8OaDk4ygDO/MBeAmfA+qOt6xWviEP7OoxlsEXKfi96xEhmbWwkD+SYfuKrOP6J+oXppnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQUXBrJuL2icVYk256lcv+PFN07oTOo1dWrKmdJPeeo=;
 b=d3DqcbSLTENfeBXG5+I4PSAIsOtdjtav4Bc3+8AZWFGFnlElYhzwHchohAwbY46psY9wo67DSRw/5PuVrJRM3Co2H/8Abd7vErFQb15GJEb42Ha9ocpVrf+nvmIY9MHohFsSRHYiMMvlmc4Y5z8IvsfEAzSvgqfpYXrVphdc7WMdF0Q07m6A9Ahpuro1pXcbo/60Q/s5DGokRCjDPTlVlnEbAo98e+FSAXFofELOw7bKS3eDw/Y9Ac7c7xQWAFwHA2y6UtOS/acOqKhQSrOiY8RbS56v3GID5HmgdomRG8j1gsueXlG9/Lxn2IunYGTZaW5irDxoy+oIksoyUAurbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQUXBrJuL2icVYk256lcv+PFN07oTOo1dWrKmdJPeeo=;
 b=h8K1cknG6gp7mxJ6ZA4gCvxfIMRTzG7lECExSrjuJvKCKFRw22tydTGgQ0zjhUG4TFeSvzNe2ITMLix+oHvbGhUauehLWCpWyGyMuHl+3Ur6EZzjWzVkSaeEuiEvHmwKhebN2GTcOpx/UzZNRespNnu74gVBLYwiMXGBwHtKaN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by LV2PR21MB3372.namprd21.prod.outlook.com (2603:10b6:408:14e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.7; Wed, 24 May
 2023 21:23:15 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::9d99:e955:81ed:40e0]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::9d99:e955:81ed:40e0%3]) with mapi id 15.20.6455.004; Wed, 24 May 2023
 21:23:15 +0000
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
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH net] net: mana: Fix perf regression: remove rx_cqes, tx_cqes counters
Date: Wed, 24 May 2023 14:22:00 -0700
Message-Id: <1684963320-25282-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0153.namprd03.prod.outlook.com
 (2603:10b6:303:8d::8) To BY5PR21MB1443.namprd21.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|LV2PR21MB3372:EE_
X-MS-Office365-Filtering-Correlation-Id: 58fe12df-51d2-40fd-6156-08db5c9d15fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	6DTNh3rn4VEKn8NTdnElaeK4A+sOnlvk+NsankMbwR/OXn3V/+j+kDS1QhGS0FVUK2/lOqGlQhsuE5ypk6kC044fzNqdQ2RTcLP+wxRX9L5JWXgVpjiRImyYBOTsAXQKcBufMqt31m8O1HHCbKj9dWvQMUBmwbvfRMjnwCp6XP58g3rYGxzTwrMZOnCiq7Jr+c6ITp+Te1yNuMv5/XRGm0RVTQfsAALRZe1LSn1ZorQLA0DVcJnLYptVMSuMs8BXKF54cN9uhklXW7zLsemIcTNI1AyMmPAsJUN9dWtHqpGbmQiWjFwUyY2esCRXr+IhhXfnJJQVM2uFKwDWiAr5zafIvIv/YswIPK2XnBdkOIZ08CCNyYs/7s5KyX4SJzU0T9I9IEMYKNNFhryWnlehx7ZTjARqRk0e2aOXOh4F20usMIZt3tybZwXr/cDY27inuxYGxnEDrQ89kYJMLgqsKmxz5bAm8AeGJRQ4zRfM8bXk1nf/LmhacjptpEkc13u2eYx2S8nRzXv/013H2/bPpPAACeem6aCgDaEwbnxsJV5wChMJzxXQSJNgcxUhH9Nl/FdHhIosgyDUDS9z2CoJnZUKOKA5dUZBiSVSI3GIJ/mYglNBv/C6nLstWeyzfMaSoc9XSCrZOuZY1ekFYy0WCNB/D6xFAKP+YezCleLRyKU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(39860400002)(366004)(396003)(346002)(451199021)(36756003)(316002)(8676002)(786003)(82960400001)(82950400001)(7416002)(38350700002)(8936002)(38100700002)(41300700001)(66476007)(66556008)(10290500003)(66946007)(52116002)(4326008)(83380400001)(2906002)(478600001)(6486002)(186003)(5660300002)(6666004)(6506007)(6512007)(7846003)(2616005)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pSGGD9UfmTCRHd6ZhU0o+23sU9O4ksuKmO5VFvm+EPBaL6zHuZSB8gKRfWQL?=
 =?us-ascii?Q?GKkHsrC/K0SAg3YfIpZOh1+mPkZMDCV6+XDxJtVJX+wFLE7Qnhpsfe7wzhSh?=
 =?us-ascii?Q?y9ZfX8vAWV7eaiqs2yR2G7T/qRQc7l/6FoswsnnGylHlD2IhP9Z9eTyLqhOV?=
 =?us-ascii?Q?fIbgre30lxqftQSDcvlPrNn4r7PLoBopklrfVNpEOqYYOmY7W/Q9HCwObLat?=
 =?us-ascii?Q?AJlRmYncZOTPow3CrGeEHUZFoijyv6yMM0bthLd8wkpMpLg1vOVkSBud/hul?=
 =?us-ascii?Q?/XQXz0Ok0rKMsS39xHaHyu5QY3CKgHdFJ27YNxkgw3eMoHuPLWap4946Y1s9?=
 =?us-ascii?Q?srFiAo++d+WDAaixeYbmiR5dESaF70CUJDugMivvt8SeNWstvSpuP5qQ8vB7?=
 =?us-ascii?Q?SHZv5OIQGsHx3za4+zj1my6b2KBsAT6cWtIYQ1KY4ofZg1dH3UEAk8ZGULfY?=
 =?us-ascii?Q?8Xpr/epnsErNhIG7oLUC7R14isWGyMuoH9iMVaSBwcWfk7BagDFKXV6wCU9w?=
 =?us-ascii?Q?mCnagJuhUB8J8D8OC8uhG0Rl69kafuqkazqamWuf78A1qnoL4v298dXSfe11?=
 =?us-ascii?Q?SFRx2TxsC7JVMq/b6WVOgP7CTv6XqmMGGyjN8QsuAWthPeSngrTFqj80IVVN?=
 =?us-ascii?Q?6JNwpfBSAb9WVPue3jU1iM76KPc9S94CSmNUs+mbq/a7TRucDWq+hCa2o2yi?=
 =?us-ascii?Q?pbkyWxFwXbSfANUZCGmtuHQKrNWm+SdOcaHuMn8vhPOvCpShJDBDYOxyh5Kz?=
 =?us-ascii?Q?yzMty//N8zrSwIrCfL0uwCA7BPYMmdKdDTAZF4jw9nyOUSypgFZklK9Njoji?=
 =?us-ascii?Q?VqWcVQydBBtw77crg4rerJSppKeNw1/hOXTlalAgSzZjNERH1JggLStAVO5/?=
 =?us-ascii?Q?+XmOHPmj06wUHS115ZFv/9gPv0qVZhswfHg3tT3YcHZ21XSNFDd1VHM7H+2y?=
 =?us-ascii?Q?kACR8tjKVGLCf/rGJVw3Fjo2Aj4v3FPt5eolJac2JpjQQJuP9x2AtWjGuLTs?=
 =?us-ascii?Q?dVDabQI9gO40Nc7jB9Xsv7ZE4oBwXBzCB/HYCBa+R8tcWINdCo8Tj1bguTGA?=
 =?us-ascii?Q?D6ziAJL+QI1G8Bs78QnfXreDwRtwQHoxGOY5ZbJi8dqsauaF8xtxezYjOGvI?=
 =?us-ascii?Q?1Pv7LMywnSQL2cdDWqblNAOJ3iR/uGXIvXz3OltDnpIJTAvjarSmV61yuL6t?=
 =?us-ascii?Q?rVtfj92d4jUbmo/gaP9LXF2zFWYrNu49qltlHiylRZNf6pjZamXsz8VF5heN?=
 =?us-ascii?Q?egn2Nz/2drTLKMpS40eq1tqwMyDQiLC6Dk2XmtFo5Tq4q+ZQRqLhqFic0j0B?=
 =?us-ascii?Q?f1g+L39ykdXLwT2/e25eBLmYoaA2bz6/UYZzlNXsuPYnGfnIh46//EABZvw7?=
 =?us-ascii?Q?QV6CjGIS9e8Rbv3Crz/Bn3Pks8NetlwQ1m//WICt20e1uxVWRuHxdsI52Mb0?=
 =?us-ascii?Q?Z189k3yxk0H5zja4odqiwBvo56wOtS+iKxKz4Lc7dbWhe8jj9xogDG0DUsNi?=
 =?us-ascii?Q?cSdptG7aaXmt8YLFUG9TbBZiCoqrYLw72RMkN0de+UiYO8NsQx3O8t2u0M4o?=
 =?us-ascii?Q?c4UfmMnhxaY5HrqzeiF4wxCp2nl9DUWbhme0TVtR?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58fe12df-51d2-40fd-6156-08db5c9d15fb
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 21:23:15.4233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: akulSX95wjKMst2Bow0OxO7UTLpLsW4qNrAxbDkfAjQfw54ZtZYuuCgoxvWK5RHHafef+oY31+732KOeAIbjzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3372
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


