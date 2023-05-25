Return-Path: <netdev+bounces-5347-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F42710E84
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D21D1C20EEE
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD07B156E7;
	Thu, 25 May 2023 14:46:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C99B33D7;
	Thu, 25 May 2023 14:46:45 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021016.outbound.protection.outlook.com [52.101.57.16])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D0D101;
	Thu, 25 May 2023 07:46:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I/1Jjt9871b9/TMJEcK1Lmb3h/vGNkfzpPTEGyaZcdNqYeavUsSyFlpADJmxrepZlwJPWxueKSS6zipK1q8CCbsL21m4+P1diJFFSH+NY48BZoy6c8SwZ1eLoz3KqQxTEsh8V5BdEbN0uB+e1S0UPD0QnEhW+bCZIQGvTqQnF5pBWJCkrSRe77g2lSvl+hf5R0V7qa+b8XqYP0Nr6Ax1UfrscGjFOBi/ITvLQpRoI2/f5olvpforY1Y7+YTZiL3SV2hTEvtXpsE1I0BJkHEjxOnSw1rrIcw5m+9w7Bu3gd8W0TQKdUZLEsILxoO0CeZcF8nJgKTW2H8qOkcRrc+T2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRUCZpjnFnOnApuDqeJNhSX2Uh6NsYv1b0NApdnnaxs=;
 b=Yo8W2sG74FIFIYZuyGTrMKVnu7CDKGDq/B8+tFp6R847MbUNK2JF0vRo2YkXPxr4gNXG7K+qjAsQkcbnyEsY9QQT4YZdnPN11Dxcadg1Oxyp6kFBis6ZUvkdjH/tUGrN2oA4CsFufjWwQq4GJ9Yqs2IeRONbmNlW1O1Zy9InIG9A1/UlfmzCv8FQyKEv3oSfHmnqxyIuW4gIw3wcQmVulDPUBwYgb42NCNUtG1CHRsVkmT1wwDSe1c86FApxlDX8UuKTkOQEmrWFofiR1xNDh3dVYTZjIxuSFE2OxbCtuqc6U9JIe2WFulnmHwYe6Bxjyww/ldC+MXUGG/PmYQ0vtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRUCZpjnFnOnApuDqeJNhSX2Uh6NsYv1b0NApdnnaxs=;
 b=eC9/wlDiI1bxQgyoAcG2BU67YLHvP2/n5QlKh+K/JNNgImZCBAV9SHMM/3AqvfS+b6Rxb128Xm2QlR5V5dfPeVjnaQQFqlpxfslm5mhs6f5LyAyYBEh/PrIJu6BDARs8t/fRThkG7XLHKurtnc5EDfqjyR18KWalMTkcVY1WMwE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by DM4PR21MB3371.namprd21.prod.outlook.com (2603:10b6:8:6f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.6; Thu, 25 May 2023 14:46:40 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::9d99:e955:81ed:40e0]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::9d99:e955:81ed:40e0%3]) with mapi id 15.20.6455.004; Thu, 25 May 2023
 14:46:40 +0000
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
Subject: [PATCH V2,net] net: mana: Fix perf regression: remove rx_cqes, tx_cqes counters
Date: Thu, 25 May 2023 07:46:30 -0700
Message-Id: <1685025990-14598-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4P220CA0014.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::19) To BY5PR21MB1443.namprd21.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|DM4PR21MB3371:EE_
X-MS-Office365-Filtering-Correlation-Id: e6ab3d83-c2f9-4c9f-62de-08db5d2ed911
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iV+jarIYV9zCc81joaAMY6N/DrJTVqJ7YZG+Ce/s1qOL8AnAUfGPRyhWo5uZVI6oZgxRa4oUjxyeKTXy1B63HGUJVz0GhNfFLbK2FLunR0+Nn8nSludb0u97TirlNzPuJe+jHp4MX7fVmksorNf9iDZ2u1eeHpJAq7gbTjbLk/pVP8bLWzpG7ekRdNvOwMIqneD1aKbIiP2hfc8MvAwZuBiNBMO4xu0T6cw7n2U+2WyzKVfLJTPS2nWD9cRdgLiMPv5AsAbwF7+sJGm+qfK0EmS6GoCveBa7Q40tz/z5JO/cuDiLgR7Rj/GpHFnYT68xS/v+UNorjDPTKhpeBJWDOoNYso4a9Xd42jOxJsgYi35mXE4+fnaq9h+Ft8sShTHRoMGBcXd8zqkVyy5DWX70hHpCyw1zflMETHogF1cSOu6rK5zAxOGB/Vbk6Yp6mmNMiZx8rBR1psqaHFUG+Hr/KL9wcyZdKX52L7pWPw6FgSiwc2gCk+ptiXyyzFKr5T+i8sA6OGnxe4XKZcOCNAtp9+mRpd0B+1cQrqKUxW+tYgbuqeSmoUqNiCz+p+4ZQ2JXSIPjBgQKUj75Ln1XJoDKlvlcg6VmwhnDgi5BWq02k09oZYRV17BHomGf+qkb0k95lIPJlRrgHRJNmyOctyZw3x85tWLB0F8BK2aOC3PpBg0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(451199021)(38350700002)(38100700002)(478600001)(82960400001)(82950400001)(10290500003)(66946007)(66476007)(4326008)(6666004)(66556008)(83380400001)(6486002)(52116002)(786003)(316002)(41300700001)(2616005)(7846003)(5660300002)(8676002)(7416002)(186003)(8936002)(36756003)(6512007)(2906002)(26005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zKerivsJdcN+2vCFJ6JwUvomkZ6sPCPAjmlg/Sf0M0M+vCvCBDlfQYT1xgsv?=
 =?us-ascii?Q?5ubp6YqdHj/a0ZbpR6aYlqgJZmeVbb8808msKF2r1dvjHBmgue77C2RVIKRY?=
 =?us-ascii?Q?u13dZWfFCMGtMAbKgjB8VqbXroSMP8vTwbmrT6oSQHFd2ZcBVrmhm0M8Xk85?=
 =?us-ascii?Q?CP7UAzRYpV4/ftNKOtI0BmSHYbZFKzWthI5oX2szJBJT6OUT33Gf4cJAR2bt?=
 =?us-ascii?Q?0ykwYQbYX8fFSTvBEw/mJHJbmVLSZlObd3Plf2JQkY0cBLjXMyDq4G94bwHU?=
 =?us-ascii?Q?pYpdtcJm2lDrzrFtyHNOARD83Y8Lq18W6XXiVt2hBzlbwSv9py0c+hwEjI3k?=
 =?us-ascii?Q?tXqvte/6nOnXjsfbLQKV0uRpmjYhRAOpJqOKMl3yO2SwfrNUEkzjCy+FJbEK?=
 =?us-ascii?Q?om634q8XiU1xdownqSbB2SXEPViU7ULGqOKLYiqEi4Fqvc+dgfP5enQPA2zh?=
 =?us-ascii?Q?2GAae5aufGSaOnT/0pNv2kTxc57BSer5+DxbO+aU+8fiemryLCaao5OTMNoy?=
 =?us-ascii?Q?ORbXLCJKtY6uihnzRSjDc/f90WWwZ+XJFbyNaTzqkyCcyrksD4BPyCV9X6DG?=
 =?us-ascii?Q?yZPzoKlWvcusocubNqLr3se9mxVa4soOlObEQ3csnfj1QXywUphy7ZH8TJLv?=
 =?us-ascii?Q?J5R3idWNMorUCgpoOVCTqUD+0bJt4qWX4U43okpzQrGxwBY9sbj3JEEPUa18?=
 =?us-ascii?Q?sepUhKY6lTYEZJhRz7Nos2z/oQ+2gzTQBvjnK+YPRJoLG2R/WNWcm/CMtN1A?=
 =?us-ascii?Q?BTNUtQ6cDj6cX6x+ll+SJXl4jhDMbDeyKPstPgq+NK6KRFrijlB2jW2rX0qt?=
 =?us-ascii?Q?Z/l9KsZFt8DHNCxxztkety67h/NSzC/J/Ruw6Izr9/yTiMq3cssMdgzJhc1P?=
 =?us-ascii?Q?dNQqyu2mLCUDdcXzaBOA/K+LNQVS47Co+VOZ7m4oEjRKvHBVqKS6wqwt5mXZ?=
 =?us-ascii?Q?eeMZiJ0tIGRVX3gXs8cey3uyI7B/xbBEMJmZAzPzOSnv9vFnFT92/CFwXxH3?=
 =?us-ascii?Q?+qwClBf8WIWVzgVz1BIFcjnF0wryUFYlXTCaA9FfBqOdSpQ7+PE0z0TU/4ZV?=
 =?us-ascii?Q?eOKaix57VQf3QIIjdsGBqYt2lJsMHmIFXSK8ObuvlnI09EHVPC+GkUEXVNCz?=
 =?us-ascii?Q?fN5YKrMLzFbviCcLjqpgW3N1kEQnoREXyejatyGMveIcBUBYbLYItieqnwaA?=
 =?us-ascii?Q?XmVxeLSIHlBysie/0sDIIUISELvm03lnrFi5uMCPWVgLIoP5k98QcZSDb+VC?=
 =?us-ascii?Q?QHM25Ff7lVv9cJDfNaAOd8zgrZ824UNqSYeiSAWekFish2693B6aFDPAQDBH?=
 =?us-ascii?Q?qSCkLX9JWaCZrl/gWxamFVqahgTECKWWRQQjqlszxNHCVDz54y8ATaBqDHCH?=
 =?us-ascii?Q?1jyPFv9iCWR1mGLfSV4xjVCL4MM+htv1bQd4VP/eM4zn1QPXe4OO7CIHBAPi?=
 =?us-ascii?Q?b9vWCf9m1AwadUOWQ2TZEpEpmbptrChM+M2rAN+5Hiwr6A2GBE5VfQQxB22U?=
 =?us-ascii?Q?ue4ZpkNe9TcIv4pIlk2zheYY6HJcKRBmWptPN3FVBpyXIY3si/XntAKWhmlw?=
 =?us-ascii?Q?SjjjYjvE7P5WAeHETWTLPYXrYzBuu5+mifS3IwJ8?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6ab3d83-c2f9-4c9f-62de-08db5d2ed911
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 14:46:39.7988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1mnzUaq569KaF2z9efan2imAYE+hhbNDW0wy9+9OG8OMsknQwoWyWz+HAWG4RBFzeqtNqlpcHymw9MCLwHJ8Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3371
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


