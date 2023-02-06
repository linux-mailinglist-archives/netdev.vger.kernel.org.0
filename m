Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84EE68B984
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 11:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjBFKJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 05:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjBFKJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 05:09:22 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on0621.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0c::621])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CDB712F2D;
        Mon,  6 Feb 2023 02:09:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oNxxTIN365YiKfH2k3Vra052jzWBYvR/LUur4FLOWpNBVbweF8c/3CUkQkyUjUuK8kuq/eV/noR8Pvf2podEgH5gJaf1jCfMEu7r9kZLi1hlXG4V2GODTCSlzqJywhcQ+063C+OhqBYEm1Se/FK1Jv39elQcfiQxoE4lhrYaq93ohCBFi9xgyqgRXrM0mVIb9s60PFiLpPX1DTMAGvaS8lpcCyNQLqvXwX7fGYc3Lcoft6zlD2iT/NDxRkgWkkRL33VpvUnnrm8dcugt8ldTne0qhRZk4pc3Ng/+cqzxbayoWqeJ1KFMnDzDvgUCnrrEpWtFGvnqQ7SXlbHc6vecLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOfkyJL3+6nEMBTw8M4VCm+QBKnjE07QI9vC7MKDIvQ=;
 b=JEsqWMmJnrgeXvuMFvZHEVdjFOkaZZbYLuAAD+oLbIU/puJNy04H0B8KW4jhsJtyVeXnwu0oq6G9Rm3HU8yxFWCGgCXqv0084Q+OZxKRkypMLQ+Jafugj+i8lOi/VnBwHvr0yVTTriJQkWxMvnJqJgrLozs/F4uaHqJDMNvlrOMXdKW7+o9JzkkgD6jE+HLA1GSGp04quZDxar+k7KoZn1fB0Y5nLjmw4zFFadnbQlTSKU79ZgGFpDkg2o6m+JVYn4odXvtvB7+rm9y7quY1nzOE1n1ITKmseavc93IiGWMzDIWcBVUFMiFW3xG5TRHH25sWarewrkH7qtyodx6xeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOfkyJL3+6nEMBTw8M4VCm+QBKnjE07QI9vC7MKDIvQ=;
 b=irtWD1HPX2gCYD8FvNH2KXnlp36+t+RjbilZAE1eOZS3dvOrf8ldw7KRhB8ULmXwxLBhkViAkCxgrOud7Rg0KuQWwClvo9/r9GZQxAiXege1S+hSzwTHwII6bwyVdLvYNRBMj9xpEFmZJMWITAnT+BhfBzvUEvbhERDqfb3BnEA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7813.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 10:09:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Mon, 6 Feb 2023
 10:09:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 04/11] net: enetc: continue NAPI processing on frames with RX errors
Date:   Mon,  6 Feb 2023 12:08:30 +0200
Message-Id: <20230206100837.451300-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230206100837.451300-1-vladimir.oltean@nxp.com>
References: <20230206100837.451300-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4PR10CA0019.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::19) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7813:EE_
X-MS-Office365-Filtering-Correlation-Id: ec6f63fc-ca7f-4c93-2e31-08db082a2cbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WMu69A56U3KUK9bATiQXR/5zcpTmbB5G3e9kT+r+6scA+RZ2vDiWbRWE+F9uVNljQPzs9b931MDdo+JnXg/wZJeF1xKmQXUTgclIjMDiB1yOlvJT5JUCKrUgN3ujf+WG6ANxPPZD5/9/Mg+ioFaUxSkUBKA4JQSM2sy9qY4dZYPlse8ivD5kYjmEu4jm+QkQiGEI4xnu5vVoT21FVld+7GgvXbwDhEke+DFe9pACUAWurA41Z81BC8nyC45vjDGg6hOiIqj7OTEMozjPNmlEjUiv9/Avk7jQCrXtxHixD8SbTsTJQRoxVOWpaD0HUVXfSBiK7hE0Qhm1zDF6Hdhe6uAc/+c9OFaB/b0uPV//OktQa3fYZVP1SgYhB8MaZgpPDdi+nn1VpW11YtoUkagY2oZMPJrvoQHh192Kz3GoX+Qu40n9mmpuU25IX9LLg+VgL//dDwziSrneHttR/XVcU9rcXBoUoI3/+HzCOougBCV6TjQl2ux6iKZE11XJzmj3o96GGvyNyXB+nTLI27qvAi7PQWauLurkTYlXn9RRqY79I2u1ntCidPhUmwuxLmWG0DvX9Yslwv2HFVslG4Fl8B29aIWHDztkZOH4SYckDXmp5qGD0K03HuF1dJH2Xl4jowubNu2NIUUGO5jcMRATMs8vt1zNH3wY6VUk5lA330qAaP/4z7V/z1mA1XsuhgnX95gPn+DeHJl6L5vgr2apRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(451199018)(86362001)(2906002)(36756003)(83380400001)(52116002)(6506007)(1076003)(6512007)(2616005)(186003)(26005)(478600001)(6666004)(6486002)(5660300002)(8936002)(7416002)(38350700002)(41300700001)(38100700002)(44832011)(54906003)(66476007)(8676002)(6916009)(66946007)(4326008)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KBn2D2/m1hmoxzjxF5n2Fc9mVx2o6MhuoDkqiagxmpeao8AHiLDYchydir71?=
 =?us-ascii?Q?dh+HaU06JU7681gx2sMNoyRjFUFPjY0DmoGw+0SLaJOpnISj+YBKV7xQHnsi?=
 =?us-ascii?Q?ZpZJDsR5qHiTQ3rIH8s/EdYN2wYRu+Q0vyOMlbLUEIluOcUojyLJLc06+/RJ?=
 =?us-ascii?Q?ZvMq0utZqvtmIAfEPwQFgR+7lmzcFoW9hmRu2/3YsdSIHgVb32vE3ugE7diM?=
 =?us-ascii?Q?6vayUFtvgx7/bIiLPgZWzlNWhvWvasvr3GqtXQm1K77Ox4+kCjs7ffs02cWu?=
 =?us-ascii?Q?oiy3fIgy4tHJ2dlmg0ceSo3KTA3ILW/TR+1AAJAElZ4PEdpdvg5hkcP997uE?=
 =?us-ascii?Q?zG675pN+XJx0f7HapT0/4y93ED/oWRqWdF3aqTJsK1SUf4Mv7KxpMnLeaNVT?=
 =?us-ascii?Q?qc84E2iPhkvZ+bIZhlLopD+Rwcg5WMpdNrhJU3iC0Qd/2FsIENuV0nIQyKBG?=
 =?us-ascii?Q?SrOfNlzwA/ZOhDG/B3WxjnPa5WGMcEjbbMZJItyasrFqv6U+6UG5ZtfASdDs?=
 =?us-ascii?Q?PnenHWbpdYP8hGPhYcIZ/Lg1H2LTAQYPmjdd3RyOyQmBM1F5IZy9V3nTivlk?=
 =?us-ascii?Q?0IsUu9bQGIBQsbUqXE3HFQ6/rnBEXfqvC8bwetPC8hQsLIcSxexgtuqJo2uv?=
 =?us-ascii?Q?lXpnvxI2oaCZx6TXQCNlQik6dvFz7uBEG5HV908bVvNgaTL/5vyyge6KEPX0?=
 =?us-ascii?Q?SUx7jIAHx1srkypAlRWt9RXZs8MLD8TS5i2lqlnQ73b3T7sCuiTOsnnLga53?=
 =?us-ascii?Q?lXTpimOJTTg2GQnraNn38a2T5NWA1MRF9J6QP+cyEYxZVom3dp5XQ6JaPwrq?=
 =?us-ascii?Q?lIWwSemUBuqdVxgLPK0jqwszEftfzYL0P/s0ckOZ8fHAuEr+IyK2BkWydl6j?=
 =?us-ascii?Q?mYghtOb40YJCDDH6DXvMz96i0ZXCAzfboi1cTl//C1y0CqNMW1GVesZBcQhQ?=
 =?us-ascii?Q?dN7BpTmGCHJUlnGfu3IWww/rGaxl3vllDo7d1Oj67/o3laMeNXNyVs5cyL1t?=
 =?us-ascii?Q?Q7AKc1sUXaC25AgE/zcVGAHxafKzA8bsnp6HPTWrYROyuWEtfXo9UF6dKAtL?=
 =?us-ascii?Q?fLtFjwF+Ff3xaFTp+HeFpezp8ke6WLMGWoPztDVMy/fO8r3E1uf+446Wuw+4?=
 =?us-ascii?Q?u9RMHCUv3Z4sk4mYv0fM5BRMZISyRTqglTtjrTOCoiJ+NdpB7HFrGR+qVBE/?=
 =?us-ascii?Q?+p2Ov4D9Hv3/ysbQsZ3nTn82rqgLhggfxGwBNzYmdMnJJ5Cnh0MFjtfNwDsN?=
 =?us-ascii?Q?LLYUM/P0WFtxTi6HC11Vhx6iTz0NeuFUf0NPGiakyikr+D0OWr1UohYMOyh4?=
 =?us-ascii?Q?H/JHRGy75a4rrBd9Pg10nbpcSabpCYJlOI9VLiOSysYn1tK4Zu7LBpAD5Fd/?=
 =?us-ascii?Q?jD1W8NBxwUFpSaLODtcZ01c9DOy1XxVHscAEk4oReBKpmvyrEil2GueLMUEP?=
 =?us-ascii?Q?/FwqMvJaQFDgIpwLtymwn7KTCeqz3xydj95qw9UUbWCZQci5tppVxqtCR8gK?=
 =?us-ascii?Q?mjTzTRF9pFSk4WH2Jjg8CcTo3x/jDsmWQrNWLWutlTNgGyFoUTnUO/fBMysb?=
 =?us-ascii?Q?cHsMfEw0qzPl8M4JogEZga+6SL301+TSv+EaIXdFM4bfugSgihDT7Z2/yYne?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec6f63fc-ca7f-4c93-2e31-08db082a2cbe
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 10:09:03.9272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yZfFGnEnR8RrDyiaKsowEjrxdmUBpY2/wW7t2De1tusfygCIZkCo2BEUZFdYu7Ab4iVcZVlfUwtp8HM3K8Jcsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7813
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we see frames with RX errors, consume them, mark their buffers for
refill, and go through the rest of the ring until the NAPI budget is
done. Right now we exit and ask the softirq to be rescheduled.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 4a81a23539fb..37d6ad0576e5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1121,12 +1121,14 @@ static void enetc_add_rx_buff_to_skb(struct enetc_bdr *rx_ring, int i,
 
 static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 					      u32 bd_status,
-					      union enetc_rx_bd **rxbd, int *i)
+					      union enetc_rx_bd **rxbd, int *i,
+					      int *buffs_missing)
 {
 	if (likely(!(bd_status & ENETC_RXBD_LSTATUS(ENETC_RXBD_ERR_MASK))))
 		return false;
 
 	enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
+	(*buffs_missing)++;
 	enetc_rxbd_next(rx_ring, rxbd, i);
 
 	while (!(bd_status & ENETC_RXBD_LSTATUS_F)) {
@@ -1134,6 +1136,7 @@ static bool enetc_check_bd_errors_and_consume(struct enetc_bdr *rx_ring,
 		bd_status = le32_to_cpu((*rxbd)->r.lstatus);
 
 		enetc_put_rx_buff(rx_ring, &rx_ring->rx_swbd[*i]);
+		(*buffs_missing)++;
 		enetc_rxbd_next(rx_ring, rxbd, i);
 	}
 
@@ -1215,8 +1218,9 @@ static int enetc_clean_rx_ring(struct enetc_bdr *rx_ring,
 		dma_rmb(); /* for reading other rxbd fields */
 
 		if (enetc_check_bd_errors_and_consume(rx_ring, bd_status,
-						      &rxbd, &i))
-			break;
+						      &rxbd, &i,
+						      &buffs_missing))
+			continue;
 
 		skb = enetc_build_skb(rx_ring, bd_status, &rxbd, &i,
 				      &buffs_missing, ENETC_RXB_DMA_SIZE);
@@ -1549,8 +1553,9 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		dma_rmb(); /* for reading other rxbd fields */
 
 		if (enetc_check_bd_errors_and_consume(rx_ring, bd_status,
-						      &rxbd, &i))
-			break;
+						      &rxbd, &i,
+						      &buffs_missing))
+			continue;
 
 		orig_rxbd = rxbd;
 		orig_buffs_missing = buffs_missing;
-- 
2.34.1

