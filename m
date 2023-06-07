Return-Path: <netdev+bounces-9052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78B50726C96
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EFC52815BC
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F31019BC5;
	Wed,  7 Jun 2023 20:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F0819BAB;
	Wed,  7 Jun 2023 20:34:45 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020018.outbound.protection.outlook.com [52.101.61.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934C61BFF;
	Wed,  7 Jun 2023 13:34:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6diA1MpIdwH30Sj1gGFsvhoeJC1BBFlqYFjo+f5RBntrWWm5R2lRUvzcTUpVSdNJx6kpsKfTHSJYMUx8GObAiAwriv5r6tbuZxJRbCAPyj8frQZmoJT+8mxo+fMI94+W6lldNvIZY/RWZRp2vpBX5G2TJtgtdUa8e2ZMWmfeVAiVKf2oi+AMS6ku8yMvmzIRXQ53h0YJR03YIdA+gaw58vP3EF9uuIm+GcjrMheXHMvNfV0h7Pzp5hWpKUnvvzfVuDxofrtQSE+uUEil45IUJ+k+Fe28wKvrNBdK5PW44iUwVejZ1vPU8bdT/FGdCpf1bu1eX2xlU7/z+BTD+BYKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q65oAac/4CkSujD77p+jm27aO2fBUlyIW/TMumQxvO4=;
 b=nsGVTJGXaLKFAho4AbHj5GSv2DNiJgHgTQ7BvF2T9pyA6qPvmRlqSuBXSsK+LEdCCOhFbxgj3GrfJH+kojyXubUfSVqyCIL0ErOHV4Oc8xk9FoSJDFzn+dA74Q+UjunmtpM4neqhioEmAZYNGOJbMfiFf9m/uubIAVtLAopb3Lek0/xBuhjbU1CJ0Z9QUAvgQU0G/UZyjzsbbLwtxqDFYvP6Wwtc83uucrgPnvhJYrPxMDThrC7dCYFN/E5r4CLbyqluaOmV8Ye6OBTl+Yuhm8EZzsZnkJfx/QXoemsdwQNNGkCKcP7NKKm50EWz9Gk161M1FQFX77r1B2Yt4z5WUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q65oAac/4CkSujD77p+jm27aO2fBUlyIW/TMumQxvO4=;
 b=ebCJiIydqb+flXrzodtSwEJiAyDe0aTAKNH0MZ32vYmfPZ1j1qWiutTkDiFuBwxwJIA511HF8KniPXJnH5DQrJzyQPZBiM0Flo5ircRV9eTNPOCH+Xd6sbmaY+Q53IEpknhYaMyl5K77//9IcD/m+BcxOS1CBVWlVRimfkNSdoo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by DM4PR21MB3704.namprd21.prod.outlook.com (2603:10b6:8:a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.2; Wed, 7 Jun
 2023 20:34:29 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4%6]) with mapi id 15.20.6500.004; Wed, 7 Jun 2023
 20:34:29 +0000
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
Date: Wed,  7 Jun 2023 13:34:02 -0700
Message-Id: <1686170042-10610-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MWH0EPF00056D12.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:15) To BY5PR21MB1443.namprd21.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|DM4PR21MB3704:EE_
X-MS-Office365-Filtering-Correlation-Id: c7c99da4-c9f9-4768-e694-08db67969740
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cFDCKkUWp7KukHtRtz04YjFY9k73LlKEoeFTwdrO/K8/yS8ht6xBH9RH/lJeQb7kQ8bWWftKoJho5xDPfmShaNlNSClo3wLB/YdmHFUUFNR5WYZJJ7mwOwXbll5WIzhRAePeS9eLEVh5k+JZ76E1hsHvQsXHWjjj9i5eSTTrYE3WJwEgrHhKLlgNxcKniWNND5s4LDWe36Cfi4XX/wrSZdpO5b9YaRUmVVyZ4OugX1xrtAcaVVX6JBDcFkfnFK4VxozrXtLrRi0jWF4DCpZSp/YLTMYF77SxKkcP845IyKDgiimjTrv5TLSoPpO2NwH2l9Zc50dXej/CSKa/tmU1UAwKAuKz8TkMwp/EXeubrffjkwuepsMcMxfWQ4Q8s5IBJqnXTfXXYs8tq6k4hPBlF/OFUNOYigD1hppDd6UvTGuddmsJadwc8eALKkuHct5yhNbR1RMVBaDHQuKEwbCJ3d9oc6UkQTlUy/JYJCGmBgFGSpkud0kWZdgBltGXE6DXPx6WaNMbeWZ8bKeYloDnmE+jLwijqojnieVRfI6CAIY8MuQb5BCXvtG5SZVwZNRAPQqajD2V/4sRqneqzYcLIqfKNs3+7NzkeWjXGQqk10Ho6RWYVoJXRWNhCk7pGvHg9vkRjUGXq1/AKKUSgy1W/gCC2aOQrovyeVm2aEoOVGQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(451199021)(316002)(8676002)(66556008)(66476007)(66946007)(7416002)(8936002)(5660300002)(4326008)(41300700001)(186003)(2906002)(478600001)(10290500003)(82960400001)(38100700002)(26005)(82950400001)(6512007)(6506007)(38350700002)(36756003)(52116002)(6486002)(7846003)(83380400001)(2616005)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?POMak4qMIRDUdklu9KDF1hQIFi1iyBUdhAY/8kjOqMKzEpIRzWXwSyC1pjJ1?=
 =?us-ascii?Q?6pI7DS7kn1auxSRlKODnaTBaNMZmaCbWqKoqNGwstc2qutZ1GQpHWcb2Ya2W?=
 =?us-ascii?Q?s25Y+ZKbo9fU1//zBRLWW5J24yDjLzAr7G3G3dcKtdAKoitv6LuYQBgDYvUW?=
 =?us-ascii?Q?jfXE4i6B5yZW61m7qOM6l7XhK+nC/AkXS8S0iWBeyZ4PCK3PcecSwbjDbwVH?=
 =?us-ascii?Q?bGE8OC3LHoiRnyj3iurYo6tF1UCNVfQE/cy/iOn9e8F2wwVIs9pqylbSpnox?=
 =?us-ascii?Q?czxmwHPcQ5aFdtRNn+f5NZbvTrPxlBRBI1bkWeDIxW73PCdTMSygqMuYr/Qs?=
 =?us-ascii?Q?uadGkbPvdYUi3yHCKrPna/yY6KEB8LMupmO96hsoQNrrrXnKj2D2kS5MISav?=
 =?us-ascii?Q?RB+3KdVm42TS1KNHR7qvBMjvr/AqC3Zex3pZfmXpE/ZHhYgoOgJtwyH/RFO8?=
 =?us-ascii?Q?m6pgX1bT39p0RssarR3jhHV0fYOjL075DOK0r5s0S4ERYqldHU4TPdREVvQn?=
 =?us-ascii?Q?gARU0aOps78K/e/D2qVVXurqZH/kv+LT3hXXgTOtpJZrhVWF//Lhc/xnwTEI?=
 =?us-ascii?Q?7zeTOhj6t2WVbMjjs/r8Xrmc4gjc+VQnLZuxEQ32C5Wjeb2d/7qocBW6m88P?=
 =?us-ascii?Q?SOowJm7WOXwRq39Sv2SbzAP9QytB9kOZSaSVVP+qoVf8d4aQW1iUw9eqd3Da?=
 =?us-ascii?Q?cXY1qPLlW6XItGxosSGXrSVXLLIOBvj8uGnR9pUonCBz3i9C8iIhLJdkE2cL?=
 =?us-ascii?Q?Zf/ab2Yq/8wrpinahEUPDNVf/C4bPUzNZRmy2YVKk7gbAKk8mtA22xK37FW3?=
 =?us-ascii?Q?LGmxEmWb0kV8VQNJsoQOS9uvqNDIAS4E/mnO1T12I5rd/CBehnBDEk1FJCGn?=
 =?us-ascii?Q?C6FYxGkxD/XKQOgzHxSck+yH4uaJKlp3i4wqlye8fLGV16zG9kN+5TsEhdcd?=
 =?us-ascii?Q?UX320T1Bt+f2C/HvlpTrZd5ITvZaEqY8/N/Y2AWW6tmI+7aFHBl7IFb+r9bz?=
 =?us-ascii?Q?Z2BotUnMjyVkRpifDVsLmebumcPKcq+MiE38Yo2yIBLrPqbBx4lC8UhQeZ47?=
 =?us-ascii?Q?0gqy69XAgHxLdv/6GnfRLAaMGaEICS/+Zsw53LhblOdrnGnH/IiXr9FtZNcJ?=
 =?us-ascii?Q?EruxxWNQ26Y46qRi6OJJJ3RvJTQO6eQ/Nm6jgeYI1jAIbaSJHLnQ6Uj0vIWd?=
 =?us-ascii?Q?9NhsfeoFc3LBHET7Eag9Af+xO49Abb23XXReiJB0gSo6kRrbWwp3VHeg8ICm?=
 =?us-ascii?Q?88avdPWYl2ZpVr3Oz2M4rqEcs23LW7oTSS1t4h7aNgoCJnp6a1x+MQbpRNwY?=
 =?us-ascii?Q?p7QRYdwGjIjR72JHnoKYK04e5XBihfCoVwAKdT78fujJQ5k80Sj06ZPIQ6Pr?=
 =?us-ascii?Q?CrDgqmQXVeUjHob1FMweYY9Jg/+hKqlTlxHcZU5tlK+Iff6GWqMM7SbKWBbA?=
 =?us-ascii?Q?UcpoxEtsZC3kMVca3qi+6iTgJ1wJhIuaZeftY0BeOIVlaiTmnagyA0JCIou2?=
 =?us-ascii?Q?FfBLQtn7/DnRu9cZ22N0bz1R1kDipCT7TAFxah1lwXjSQzP4vtgLgGArxhdm?=
 =?us-ascii?Q?zA1K1iriYXeeBYXFR19OXhwlUOSJ1sDMyZcSrelO?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7c99da4-c9f9-4768-e694-08db67969740
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 20:34:29.1485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tiPAq7MD+2eDzDUYmrSuHjm/IgzqiMshWPSAUaHdHq7A+UP4eluljQJBxwvt/j4sUfeRC59FTzYa39ZMiZii8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR21MB3704
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


