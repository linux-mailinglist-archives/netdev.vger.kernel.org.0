Return-Path: <netdev+bounces-9017-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C1F8726906
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:38:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 907641C20F1B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7461E182D5;
	Wed,  7 Jun 2023 18:38:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB246118;
	Wed,  7 Jun 2023 18:38:31 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020026.outbound.protection.outlook.com [52.101.61.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F671FE6;
	Wed,  7 Jun 2023 11:38:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4pgrC+itCjxe8wrylx4dxZmIhfo8YQr3Be0eosYA9drd5uiS7qU5OEfIGdyAnZrwF1pG8X6Bcpah81N2Q04SQKAVWZvVmhE44oribc7GYstN3lKpo5Zb9qCkjrVrS5v8oxTWMdl3A3TeDhjaZT4QNvh5AYBKLy44HNS9MuH65QP4NMe2f3POmA68HcK+tAUX8WTgZ4BHLUdnP1JbQu56o/ytkOF+XCzfxDf16X7aYpXk9BHV/TJsUoS4QRuGJ/pWKJ19ZqIW47c/zfm7urxRi1OPy426J1OSFTzIySKoaH8QX0byZlsAp//NZjITltPmIL/FxB4dDVzBW2yFt5LfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mmw8990CJhY0WaUzIbMhHZ0Zta1yPla0O+alsHiL0Ao=;
 b=Kh3QETH86xh/peT8VrB0X46I0FemLRQTbLBYDWOADVDj7sqmFZDfsixDa+NDuDla84kHNHCLf3I0n+U23ejQ3mZmSJsqL3EwQCE+TEm9wGYAmchEmkIoA7AoUxkEYVg6mC8+TBrYI6Xl5EE5DNTaMs0xau9X7PfG2tZ/FVBt/xN9TkBNzJei7KHZoCjj2qtcQCWGPSSY1sKVcvIkzk7+bOuXh6LrSsOTVYrX+6lmFSXwCA4q+oFq1Sg11yZBUwpgniYA9BLn65IXyex1os5xthKBYr4LLJ7kzclG5kgdiksSwUzg1ZzsC+EDWNJeaW7sE+5d97iOuRfrn1LfRnB6Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mmw8990CJhY0WaUzIbMhHZ0Zta1yPla0O+alsHiL0Ao=;
 b=YizCf07N3anGNNnW4fxkqiDRjpYWIsJwb0atE1V5jar9d4hidu6F07sxC83W1chGhpCgAPM6OBNrNCkJYog2VPoxW66n6RyMc69PgCI/xN7EhWgC3XuJX3ozEXtugRjdxKEhiJyki50JI3lajgoamNGz/S1kBGTnfQ4kItxrINc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from BY5PR21MB1443.namprd21.prod.outlook.com (2603:10b6:a03:21f::18)
 by LV2PR21MB3373.namprd21.prod.outlook.com (2603:10b6:408:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.7; Wed, 7 Jun
 2023 18:38:07 +0000
Received: from BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4]) by BY5PR21MB1443.namprd21.prod.outlook.com
 ([fe80::4eff:a209:efda:81d4%6]) with mapi id 15.20.6500.004; Wed, 7 Jun 2023
 18:38:07 +0000
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
Subject: [PATCH net-next] net: mana: Add support for vlan tagging
Date: Wed,  7 Jun 2023 11:37:38 -0700
Message-Id: <1686163058-25469-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0051.namprd04.prod.outlook.com
 (2603:10b6:303:6a::26) To BY5PR21MB1443.namprd21.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: BY5PR21MB1443:EE_|LV2PR21MB3373:EE_
X-MS-Office365-Filtering-Correlation-Id: 68115893-f600-49c9-0cfa-08db678655d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QztGZbFy6W/3BPy1JTRaQHA/eDlj/OZ7B/9ATexXuDk05xEsuWPozH7suZoL+k3ja+DIWnUnlhWkybnBew207le4OQarv2ijsRsgmueSrZdGePsRnR5ccuYKoVeDcF6Lk91NK1+/E3cGWG8cOvSh4iSFtBSzJu78JNFxx+yndTqtbExdjfaAKZ1DcZZCyrg7Tbxh5ohVUloLRB1VnHO/S8We/AlTaiPL4MuNuZXhY6v6Hf4iKosZ6DtQ7z4jb2ANGqVCaCB+yQlgMKoOW6G2bvD1FcZ0M1EEiaE3JCqgnN1d2NJACWi+nZWXBERHQ/jegKWkpilEZIMpY6oNofAFarqRVwM1gYdF01nmaFZEKhwuVFeBH274KdWkuAg6zKZJbiwBeUsvjP1w96ihnnHyks6T1b5HlebkRi/baOytd2NVokMb397q+bHdykQsZTBgBu37zyOuBmQ3EgrSKWx7MpmwmYAdg0iQfBvg7W6deZWweM0oEvg2wHDUHWfpOT0gNlZqmZE6GSkQuI/2/JVYV3t7fP9AZs9LQeCWSn9bGS55v/C1zKkRAQSdVaRVEzSzZqSxeTZQTA4WdXIjm9I45+l1TFziiVnCSkMB2A488gPviiephXm0Hr6XyGxZisdTslM23C/0tCcRbqCMs2/sc3h67+g9iD394HwGylFXqiA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR21MB1443.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(8676002)(4326008)(66556008)(66476007)(8936002)(66946007)(5660300002)(7416002)(316002)(41300700001)(2906002)(10290500003)(478600001)(82960400001)(82950400001)(38100700002)(6512007)(6506007)(186003)(26005)(38350700002)(36756003)(6486002)(52116002)(7846003)(2616005)(83380400001)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?USf2LsrnZaqyCo+Cbf+lbOReK89t3jpniAQYKbCl+Jz7Q09auPWRu+VfxW8o?=
 =?us-ascii?Q?XWgSjM2AoJcpX1PCzP0+JPVO/Ep2o+Fn2G270hXfbEpeEk9lKajr8dFgu79O?=
 =?us-ascii?Q?IplwVi1ZUUFpcbW0l7UT84BKxCPXzvxV9U8ch8bUJllqCBNCO6OOxQA1ouwb?=
 =?us-ascii?Q?/mPR9qf3RxiKMHRctlsHM0Rn8mpla77IPce2im65LBv5NpoEWszf0HNfMcnS?=
 =?us-ascii?Q?QQReRhXfGSGvfqOFJOJvxfUFUS5WxrTeFmh/qBfU5GOJ6xUWnvyvVw8Qm8Bh?=
 =?us-ascii?Q?ecBbVDZpN7+/DMZuKyRlm8vMmv9FxCb+0zZwlI4Gawyr8VoeOnIjF4/mUqsC?=
 =?us-ascii?Q?IB9MDwiHmsKU0zG5UfBx/CWASprwsWPLizjNOGiQbMLqV7Ll4YCb04b+/JyP?=
 =?us-ascii?Q?zkqBJ8UJNdQJ3/68B8a0cfJrBPgShsRFT+GxC1QqbD/VplphYAs5V2VmyqT1?=
 =?us-ascii?Q?elCyk4Ptqgv+UYsZ588jKOI6QHWyL66ib3AH4ARv6YWKr3kSOnds8RVl46Dv?=
 =?us-ascii?Q?q2lVCva0tnuD3pQel0A809Pl6SgmiGi5EOrBssK7HgrU4Lq9cru4MCzCNJ3I?=
 =?us-ascii?Q?KC2GHeTAJM1lzAPkp0hSba7T3xSbOXQM3bdknA025bRUgB9oEO0l4d2LO2IT?=
 =?us-ascii?Q?h/YsclkPL43abrysDDraxuHoRBbLgQBYhSnQ3X3kYLuRYpc2PLkyhaFMPcCc?=
 =?us-ascii?Q?Zlx4x1gu4fQZA/JOQJt6Z3DUSCSCQZcy08Fot7ZiyiXaR8paFy8ngSCQc2aB?=
 =?us-ascii?Q?vxtSGZnp8P5fz6QrTc+JqpQDCVfDXrrq+j6EkHsEYBownWuXHcst4KgflG5p?=
 =?us-ascii?Q?MXDHGZYehLyZU/xVmIaT2W+UHEiQ35usgZ0YuaCGg/GbdYxkxelBfFfLynAB?=
 =?us-ascii?Q?pSwX9mszgAtH+SHknUAmLuzwty1iXWauqrIDAQcXg1g9kvMxWLVkqBPsj6AK?=
 =?us-ascii?Q?V/r4Aa/yUPFLw1RDM6/taU0eLZZ7Z4qJzl5dQ+MsbkIpbjPNFsN4QxAWoCES?=
 =?us-ascii?Q?Q8Ovkhy1lCPaIZHz3EUHtoVzxYnHP1ohN1RmmnbHeexQ1HzA4hXxr6ORzNWL?=
 =?us-ascii?Q?qKBtHaurRY0zGjlCyrr56sxxA05U0O1ZMsw9gbSWJkiKpI832WkWLKkiJ7xN?=
 =?us-ascii?Q?3RG5QGIepnndTViswgaoF62aFiwzR7CCCSy0+pC1zVFTga8B1Mhqk3MFQ3bD?=
 =?us-ascii?Q?qv1OG1C7xZLxssl/jj0M96UNIfj16vy3cdpZcpuK34ESq2ZL38PHIZEbAh76?=
 =?us-ascii?Q?1dVO17zzP8MRLa4d6fGx/HJdVT/7XohofJLdlbj9mGowWBOa7pK0GiAxExmt?=
 =?us-ascii?Q?8vVIM/WdqDhiacZajdwWRCfzihzBlBqbg5sv/M3fLQ+N6OobHkiCl5pOeH43?=
 =?us-ascii?Q?7whzCygZgl+hS+Phu6HMWjADGikqj5YE/1tApfOf7rYyUgxhoZSzbC8crqOk?=
 =?us-ascii?Q?R71pAUFE1X6kklFRz/auu+Xxsy/Dx74bq9xFiNRfRJ2I5N5WrnUXAQC13Ytx?=
 =?us-ascii?Q?jYDyF+bkohWRYl3M/niLG6OBRtLNyz3ly02/G25uhCDT+CcnmLDXNKRYdyiK?=
 =?us-ascii?Q?RJGEOn+idY84ysWMA6wUw88VOjeNZ921YBwkjyKS?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68115893-f600-49c9-0cfa-08db678655d5
X-MS-Exchange-CrossTenant-AuthSource: BY5PR21MB1443.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2023 18:38:06.9632
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nZUxHTzahHGIwuOoKPxDJU4uOK1s+Uuc/NThys6oMy7mNdol+0gei2B5NA/Ry2/xc/IbV410wyueOaQkV387bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3373
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To support vlan, use MANA_LONG_PKT_FMT if vlan tag is present in TX
skb. Then extract the vlan tag from the skb struct or the frame, and
save it to tx_oob for the NIC to transmit.

For RX, extract the vlan tag from CQE and put it into skb.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 36 +++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index d907727c7b7a..1d76ac66908c 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -179,6 +179,31 @@ netdev_tx_t mana_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		pkg.tx_oob.s_oob.short_vp_offset = txq->vp_offset;
 	}
 
+	/* When using AF_PACKET we need to move VLAN header from
+	 * the frame to the SKB struct to allow the NIC to xmit
+	 * the 802.1Q packet.
+	 */
+	if (skb->protocol == htons(ETH_P_8021Q)) {
+		u16 vlan_tci;
+
+		skb_reset_mac_header(skb);
+		if (eth_type_vlan(eth_hdr(skb)->h_proto)) {
+			if (unlikely(__skb_vlan_pop(skb, &vlan_tci)))
+				goto tx_drop_count;
+
+			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
+					       vlan_tci);
+		}
+	}
+
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
@@ -1457,6 +1482,12 @@ static void mana_rx_skb(void *buf_va, struct mana_rxcomp_oob *cqe,
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
@@ -2451,8 +2482,9 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
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


