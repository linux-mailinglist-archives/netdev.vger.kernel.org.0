Return-Path: <netdev+bounces-9532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E125729A4A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17FCA28191C
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278DA134C9;
	Fri,  9 Jun 2023 12:47:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACE7D30B;
	Fri,  9 Jun 2023 12:47:32 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020018.outbound.protection.outlook.com [52.101.61.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F9022136;
	Fri,  9 Jun 2023 05:47:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KARYcr+kxKs9b18YepAhMJnpqOxunRj24pJUXq8iGXDFSzrscV7swD1lDkn/sWsER9YGKDHgnT3V+efgEYVig7NMOBQW5PfWzVATZGpbk7eF3U4Jab0CBGddW/17+N0TKc31dQRD9UPQKorX6wehgTikt9kGczqtGZ8hWaQ07G9f5Ifihg9PnWLmwig8Z8qR2ianwtsyVTrJZjrXZ5WH55aQW0Mi8BqJufYR5iNfxlOgSA+nfS+uNek/uwKkagMjfiHeGk4yTPIMM4Magt2Aecymlobly6CQLTQMLG+tgOYxOO9kJ8cvjL8QrnR3b+7FYcAIwkmY9wHcRkVYOufcwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q65oAac/4CkSujD77p+jm27aO2fBUlyIW/TMumQxvO4=;
 b=lxiKdBgmeFIWXpT3FY9GpFrO3jyaozinO/1NSB/OVK5IGQ7ZmEoRzU9iaC/n7pqPXGvQ87LiMhxIAQCAk3TK6yrKLEdmpt2MW/zjVp8U6e1oYaGlnFrQjbLcSii9NK74qZ/fejmlCEU3MPyyNgOKkQ6Vl3RN9Uy8ppG8tJoq1Fq9ISD8BSwI0v6Slz3b3KOBxaUYHR3kUHNrQ4r75FZujAHQG1mbfAr3SAsuh92gK8u8Mewfu6M4F0ekjUa0/WGrvXBxJVf93UuSU5QwXaJTlPna1J19WdNte8BhZx613JTWdgTSpj4BmGERPaFZ7h7+oRcF/RnKxYzMQmwxQavo9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q65oAac/4CkSujD77p+jm27aO2fBUlyIW/TMumQxvO4=;
 b=YoFiJ2Oqzg03amzIrXTuGEFxLTOJ3KUpbhc/6vjVgwsvrr9U0twhNq1rvn2ezGiP22nbBdzFB+gepDP4XW7rdPH+M7rj57qz52nYNqTNF+cjc8GZx7Dt2zRSpPAUagEIEcBsxvql2Du3HGbdpmxzBnyoSqdUAhhSByewp8ohSCc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by DM4PR21MB3056.namprd21.prod.outlook.com (2603:10b6:8:5c::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.6; Fri, 9 Jun 2023 12:47:28 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4%6]) with mapi id 15.20.6500.016; Fri, 9 Jun 2023
 12:47:27 +0000
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
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next,V2] net: mana: Add support for vlan tagging
Date: Fri,  9 Jun 2023 05:47:17 -0700
Message-Id: <1686314837-14042-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0086.namprd04.prod.outlook.com
 (2603:10b6:303:6b::31) To BY5PR21MB1443.namprd21.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|DM4PR21MB3056:EE_
X-MS-Office365-Filtering-Correlation-Id: 94488e2b-4259-4a12-7994-08db68e7ada3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CePopvVD3k4GKOKb9mDzCJ5nbEzGGc6Q6bDIyS1CTH7CZ0ZRFbRO0TvwmOVcAFKL06bprqGUThv4QG8h8CnHln6/lFr8rt+YUk/neu2ltge0B0nYHPKT37hH4ar2D63hGLwUMGTw2br1rrW1eJflujwWRBMoLcdV0jxzwu77c+qHETUypDN+Vap6Em+RVQZkj/v2Y7tJPgI4DI4lzebs6H3zOg5aU0j7wewhN8I5QnaN1kTbwTXPi3Z/HxbI/8TrsXtgsr81vutqyMeZrIidleJYbJDgGlMmNxNwVmNNfPGC9+0t7P7poYntAhwqPAKE+TvNquUIucWe0jyI9/n2yAKrCqiDrX9bIZlzXC6T7TOZYoX2BNRekkymkYhlmN0696QjSDmoGZDFRF1rFJSAk1/q3MGwVnTrpM0fDzR/WCj1IyUDMjEK6TqYx74yigspw4VWylJr6cVAIghWy+Pg472EO4UuY0tBfFa+uzVhXWX818/XzpA+LKy+kd0uU2VFpSrp+OwZkVajRZh20cPdr/zPM2geOXhGkvW65sEcFEkNsQlV4OSyq/H58etqrHwnp9zgtARoq6d3UG6HadUiF/YGEJQHBCpTD33xZNRMqdpir1nGjVYOpRs6JXAbpN/PoElq+NbQPqzGX1pDetfckAcDYM9bjCsXzornKs5S8F4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(451199021)(66946007)(36756003)(7416002)(5660300002)(2906002)(6666004)(7846003)(6486002)(186003)(6512007)(83380400001)(52116002)(26005)(6506007)(82950400001)(478600001)(38350700002)(82960400001)(10290500003)(41300700001)(316002)(66556008)(2616005)(38100700002)(66476007)(4326008)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5+2gyRh2pA5hCg8ywYCUn9d7a21UEDTTz32wRkugP9Dw61Bv7yPijmdRZKMd?=
 =?us-ascii?Q?M6gAMLdHHvj5AUNfnPqx73Sp1+zlaMApqlA9RBXJr5oOtps/SSmCNYsAeEPd?=
 =?us-ascii?Q?iy7w6XXwBZX4am6sddB2OB/ubUSQBGG4TWZsIMOeXF13PsdQ6jAAy7QNbC9c?=
 =?us-ascii?Q?fYqREOJUD0bRfCM4Ju+bIsryE9HC2oy+y4ixyPBd1iI8cbcWolakyGhtVLq5?=
 =?us-ascii?Q?Y55tSZM/Wh27xI+dDPUBfRDTNQnyyqh+TDJzk5oVsyw7rnHx3AgIatHI3Jxb?=
 =?us-ascii?Q?tQbvY6B+YLDjNJzr5jOWpxdfQcngZBLkbovdlG8mjh5nuP4JrN6lZHXLkFxO?=
 =?us-ascii?Q?P6O7mAHcazqV6f67KG92Wp/d9oWPNB4oeRV2EQeUouJPlxm2ikKGhbzXZmbf?=
 =?us-ascii?Q?+LBWqDUeAtSxlOCczC/Ih6YIXtM50C8pkClXa+0xZaS6IdTa80pTnDR3PSIG?=
 =?us-ascii?Q?GpFz6RG8MqnEY+CFYUWzshdZBIrrUo5qFkdpGTJ/ZrNAcRuwphDj219DUMzb?=
 =?us-ascii?Q?pttm/QDy/AqpeSFeCpskPwCNwrKEARBp2yxjrwcRW1fT4bFICUW/H+5fO65J?=
 =?us-ascii?Q?zrpOZRikrVQXLi1wdmO/IysOSMDLTChPBpIXtX9Uw/NGBSWdyWILDx6u2jZW?=
 =?us-ascii?Q?xtbMsUz7gqirV91vzlrQ69RNK5pSLcjngpnoNwczReu6/zlYk3werL7rOFtP?=
 =?us-ascii?Q?LH6GmJH6Vfs64jrQr/2ZpgO9wfLM0MqunFb0GujQ1GN+3gwxtU3UyrvO/7zW?=
 =?us-ascii?Q?GtLbMM36Wc+ZrhmzLchipXrCNpUUZdC3w02ZoC00kHaf7v2kbzoXJFHvTnKV?=
 =?us-ascii?Q?nJF1r9bsfqyrJT0kFcENYT2zP+XqrJzDuGDBaaEzeXnIlPD2E2Uy1tGdgYrN?=
 =?us-ascii?Q?/EgkrJnhiuF5bD+Jh9RspLvYWyR1vpIED+0CN88yDJftpgmSXojOzvvHieFV?=
 =?us-ascii?Q?tWFaZgYVeOMxjWfN1fe/nZPzGahk9QY+mIv0N74NCDr5P+NpwVyLIZNA9rKj?=
 =?us-ascii?Q?f1Y9/jM52RS26cMaa7q3gayMK37AAICvMxvJ36bOGJYG3jUhDevAG0VxoYWg?=
 =?us-ascii?Q?lwtY/HMW0g1t+A8FdQu4j0PSrT2ZqF6lQnD7Lx+RmC9qGwASNK0eAgZXVa4Z?=
 =?us-ascii?Q?rSVeaA/C9B/wiUvGJnet1wJ72C/YYrdTOGNLHiJDXhK8PyN6P7XnRJ74ux7v?=
 =?us-ascii?Q?oyiI6z/Ji+GtqTBFxoqkReCRgRzqrXREpGSxm4/DI+gAWtOilSKmh0ZefFGt?=
 =?us-ascii?Q?w1k45DJtNkPNR8eJu3iRPs18xfgX5yVXIv2mU9FY3cHPArGmO524FkbxZ05C?=
 =?us-ascii?Q?wK8lrkkOAx6CGt4APGz3OlxPusPSwb22evOKYV7yv11nQS4uEd18ADHMq/HV?=
 =?us-ascii?Q?dI/K46+z3uQxA3YZgTE8loCice1LkZtRDBdl9cyXH94/E8WNbfaBLUgll4Mt?=
 =?us-ascii?Q?ZMl013aGtl9ZyEVAYL/oWphvmyMq6itFlGuh5zXL53NAbmF8UPobsxUQecWa?=
 =?us-ascii?Q?siZlMTwahnV/T+FMvJM45XS2dyZN2JlIuudVhMs2CHIWpkS39OzCBXUguVhR?=
 =?us-ascii?Q?D6NbiDzfkpZfaWdyxQ6ZFHW+lHFtn4MLXIPzynUL?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94488e2b-4259-4a12-7994-08db68e7ada3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 12:47:26.7101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5Ion2XW9DPzD4nJCtDZ8DNK3yYXbx/BW1DYRV/hKyywG8WAZRAvy6Xt5zJ1oFEr4Oa/iVHuuZF+mNEqFa8ZRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3056
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To support vlan, use MANA_LONG_PKT_FMT if vlan tag is present in TX
skb. Then extract the vlan tag from the skb struct, and save it to
tx_oob for the NIC to transmit. For vlan tags on the payload, they
are accepted by the NIC too.

For RX, extract the vlan tag from CQE and put it into skb.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
V2:
Removed the code that extracts inband tag, because our NIC accepts
inband tags too.

---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d907727c7b7a..cd4d5ceb9f2d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -179,6 +179,14 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		pkg.tx_oob.s_oob.short_vp_offset = txq->vp_offset;
 	}
 
+	if (skb_vlan_tag_present(skb)) {
+		pkt_fmt = MANA_LONG_PKT_FMT;
+		pkg.tx_oob.l_oob.inject_vlan_pri_tag = 1;
+		pkg.tx_oob.l_oob.pcp = skb_vlan_tag_get_prio(skb);
+		pkg.tx_oob.l_oob.dei = skb_vlan_tag_get_cfi(skb);
+		pkg.tx_oob.l_oob.vlan_id = skb_vlan_tag_get_id(skb);
+	}
+
 	pkg.tx_oob.s_oob.pkt_fmt = pkt_fmt;
 
 	if (pkt_fmt == MANA_SHORT_PKT_FMT) {
@@ -1457,6 +1465,12 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
 			skb_set_hash(skb, hash_value, PKT_HASH_TYPE_L3);
 	}
 
+	if (cqe->rx_vlantag_present) {
+		u16 vlan_tci = cqe->rx_vlan_id;
+
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vlan_tci);
+	}
+
 	u64_stats_update_begin(&rx_stats->syncp);
 	rx_stats->packets++;
 	rx_stats->bytes += pkt_len;
@@ -2451,8 +2465,9 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	ndev->hw_features |= NETIF_F_RXCSUM;
 	ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
 	ndev->hw_features |= NETIF_F_RXHASH;
-	ndev->features = ndev->hw_features;
-	ndev->vlan_features = 0;
+	ndev->features = ndev->hw_features | NETIF_F_HW_VLAN_CTAG_TX |
+			 NETIF_F_HW_VLAN_CTAG_RX;
+	ndev->vlan_features = ndev->features;
 	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
 			     NETDEV_XDP_ACT_NDO_XMIT;
 
-- 
2.25.1


