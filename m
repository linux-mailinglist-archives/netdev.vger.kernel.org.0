Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE62248C9ED
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241553AbiALRin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:38:43 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:7777 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241160AbiALRi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:38:26 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CGTfCv011851;
        Wed, 12 Jan 2022 12:38:03 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2056.outbound.protection.outlook.com [104.47.61.56])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj2j2g1b4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 12:38:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnqL2aDjJt+9E+JXy/To6PSHt0XJE0FjaQv2h1u4s5Q45/yvup5fRSEdqDyPuOW3rK765tATTgOO91k0lx7u90LIqdyUZuVOr2zPoQacnI+UBH/KHgmz8mx6nrvF98fAw1z+jX4ZPsWDaW9f42zWoYFBVR/Sc7X3A0QpXfWgeHtMfwm42dsVDssvdU4EyWclADAFcUn9Zdvy/PatraZEXxXPUyu/blLXmyYvnHmipFY4+m/3nwJGeJpexGnQ1YEBVPvw23hGxT6cUslMcL/WyAYl0CX/I1I6csOPvvh8/029dVnK6S0X8gfk0S7g/0Ju1AMFQIR+9lrzRXn7EDYtig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7l1BjpEmKjjb01dQCnUrTbR43RSa+9MhabIjNqzQ7F8=;
 b=T3D1bkxtDPtG165R7kQdZSiqQvdIzY28Orc7+HUvTtjCsefaF7JBOiZtsATf41GQ1fKYt1VCT9T63/NPMUaoWq0Y/FRyAHJTgdITYTOJMDE/BhuAruOIo89I5jlpHaf99FY/wXpHKYgqJ4/4WSngSpbuktjucWVQdH9taUfJt3YsuS+vx/kAEcoyEeA4LwGi2sZ3kFJOc+R4iYTfSzq5Zl4ZEJ96DJhayEto1T5b+y3Vs8V8zp/ayYc7wOcpyLy++5wU0SWFGYIGhwXf6tqsJkxMe4+IYc4AIrDHEDrLz0kFFUXn/IdSxKkFIPr0W5gnOC2JIytPUPpjkampQ0V6Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7l1BjpEmKjjb01dQCnUrTbR43RSa+9MhabIjNqzQ7F8=;
 b=kqdSvi46l5vIMnpMiCN1DjeDslQkc8m2SnVrChLjQQjePWysbqes4Vu6HW2ZKBJO/jxb9CgAIHts4Fc63bhT5ftFETTHnA1NbRjovbBQmxO8WQ+hE0E8sfL8b50UF+fbHvtRtYBCFTwj2PRF8Uvy7poBGTPawU4KDfMKP/NUfKE=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT3PR01MB5490.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:62::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 17:38:01 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 17:38:01 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        michal.simek@xilinx.com, ariane.keller@tik.ee.ethz.ch,
        daniel@iogearbox.net, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net v2 6/9] net: axienet: Fix TX ring slot available check
Date:   Wed, 12 Jan 2022 11:36:57 -0600
Message-Id: <20220112173700.873002-7-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220112173700.873002-1-robert.hancock@calian.com>
References: <20220112173700.873002-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR05CA0061.namprd05.prod.outlook.com
 (2603:10b6:102:2::29) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d9337f6-9654-4696-9bbf-08d9d5f247b3
X-MS-TrafficTypeDiagnostic: YT3PR01MB5490:EE_
X-Microsoft-Antispam-PRVS: <YT3PR01MB5490DBB000E5D7C1A40C1812EC529@YT3PR01MB5490.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VVzP9vBIdXzBk6ENtmH3TqZz2VxiRs4MQBVMf3QMAueUEWFO+NTlI2Z0PZjcoxpbEpIDma7ULAAApUJqxzTHVp2IUbYv/uupGyC8IfPPCt1vF0mPvxSr9F0uv4Q5F395mzFDGB0CgEQi50Rm0xylRuQybfQ4LWrGcasJ8W/nT53DMHPvoRgJAogifZFMeT0iWsK6YBuAPEIY3j5+C6vmZJJtPzttQs7iz91d7+aTwLY3srt2WHqymZES2UN4fxkNQziPjrhYLfZIp4aKa2pmpYIrTlDOB2/70b6MGoGhHubKK6KU3cVt8kixMq+D2h7fgzaZ2ZL6FSD9mFG3gXJGiDROpzlpKhrzAbs137xlapkOK6cP7WimwTQUFuj1BiRaGrxpZ6vSEF6kD8sjhcfyT2q4/fOanlJ7Ic/0mgsDXAy8LF25tRRsT5mjhIYkLrjRkiqklKVmd8U3PkK0UnWa2AmQCxK7+aHwaa3aGHuz/RUq8+scKxP6r9XkiHp85bHGewjCGkkU6VLxGWWhYaZ4jBXgePH4lutiGCnBzuwz6Si0hQoatlBIkOi1xT4ScXJTk3itbOLO/plGtwgumBOrSsy4VPTH69FIaGjAOX7Y1OWgIo5pAhN+N+SMn+VWf2UrLjhy+koUK8Q9D29XSOn93IwR3/bwrxpW9bgkz/qtLL8JiFo7lq0eVx5IV1hOSA+N63eZYdiZdi7t8vzkr4gXVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(66946007)(66556008)(38350700002)(2906002)(26005)(508600001)(6666004)(83380400001)(66476007)(38100700002)(52116002)(5660300002)(4326008)(86362001)(6512007)(8936002)(8676002)(44832011)(6486002)(36756003)(6916009)(6506007)(107886003)(2616005)(316002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?juGhKSLv4XMY9iljPt8sH2vDxOrUXQRwx+x9aBgbxzBNFDvXxtpcFXpcG5lh?=
 =?us-ascii?Q?ABwvJgYtGgvocPs+dmK1WimDlCJVPHWm3Jqro6HS8V/MeH8KclS/HTJsMMNV?=
 =?us-ascii?Q?te9SRLxoL82seHfGIkyRn3DH4cFg9S6SH7yrGcrql8P2GkOpIDSWSEhZd2Ip?=
 =?us-ascii?Q?AM3ItWDmiEmIKy520Lg328EZwPsyNW2EJiiuA1maorTO6gYb+v7jMUJrCvCe?=
 =?us-ascii?Q?7hSAyUNeSeJ7xDDvl73krH4LrT87qnvBD5H7YRfUzKZRMTaInpPAltx86oM9?=
 =?us-ascii?Q?zUcponchMdMEDk2QRECW0wkNi8lAmUAz3COwfD8lUFyfZAIZqfXAR6A55gVI?=
 =?us-ascii?Q?mWVgbDq8yNqu86heH6RPWw6CyjnSDwlVkUNYCXyoLtGIfan4zlFyHCVZrZkL?=
 =?us-ascii?Q?T2ajdwEVnpw2kZgsfyQxck4X5Q/fPnp5YDk6IfsLqxhu171bow1yaSDj5V8X?=
 =?us-ascii?Q?UyT197zg6XPL8ZY4X1qE8WTfFyS8OHzD9DIzeagueJBDy0M5mI0YkcXsUk1Z?=
 =?us-ascii?Q?fLCNkNyaZIo+1jkY5RXGXr7+tICdIS+JfLPahkvLFeUwa7DYmU5bmb91/yRn?=
 =?us-ascii?Q?LWEy0MFwcu76Kh/O1XHJy2yRs+zuZdruffacVy/7F0Yu8NRGsixau1j3nH0w?=
 =?us-ascii?Q?iL8GzmmNdTWtVklmTVqMeCB6+Cc8EpTN6p8JRrsHiaSAZcKuGpJi5yW1RGXN?=
 =?us-ascii?Q?dIb7ohJ/gBpu0zFp72dBJPJOLaMfC58zPY2vii849maYtmkMwuSlg/7vSABr?=
 =?us-ascii?Q?dmrGH9ukKF+wrIjZBki/j4T6msnvTch9qG3M2UUHXZmYWw0otzXuYVLI5+y+?=
 =?us-ascii?Q?d9Bpc+RY6QAGIYGYBd05MmFEsyLFk7DXhYqADgwD0+9rEJ8hoj+n5Wp0R47s?=
 =?us-ascii?Q?tKdGk+9hAA1x/S2RpjgxXyEUT7SmHTCUezphvUlGOpv+GYUXsiC27Y6cwL2I?=
 =?us-ascii?Q?vEuI7kzoA5dvbj88TbVF59Be8dA2/ssIVKSEypZ1TPhPLWFukciVoB/Xd5s0?=
 =?us-ascii?Q?zU5p7+mtr2QzFEPzg7ZubRX9j1Y9mLEdp/sHHPnb9nq44egrMhvkfbWJXy+1?=
 =?us-ascii?Q?nAj9OuvHsy34to/dduPbw8CLXGA1Tth9aO9vB9LD6v2ap+rSAjD6kIXAZKap?=
 =?us-ascii?Q?BWtj+dymJkx3Sy68pcOAiJUuUQ07/q3z2pujS2gyhjS0YLoguQZFYamcT3Mn?=
 =?us-ascii?Q?uPhkRfdjlJXCvpIngZ52A2dLRy/SPKyR9+BayZcgcsA141Km/nbqUqFjoGGI?=
 =?us-ascii?Q?0RxO32NVaFT8qW822ALbAPReVgp+ajvXbd31LuH0Rx/7/Ke1wBGUMRPVbYsT?=
 =?us-ascii?Q?NDR8WblOz8h3pMn09orjPb5hY3BHEWT4XmmgFJNewobbjSPJ+0341LI3ql8o?=
 =?us-ascii?Q?mcrKONvwOgJ93MfZLZWgl0bATvGPZQcPVNKTh6YPcUm6EHy2lhaBTXQSKClL?=
 =?us-ascii?Q?X1U4K11N0BgEE19rr3Ku7pR2oG+6dPHPwSQyfwJzulcp2iBd3ViIIUcWQiiF?=
 =?us-ascii?Q?dEf1HQjGMDzdBe7Pid7BIqGTTPrS5wfOWRweD9lSwXlS+VIZshaiycvwiw6/?=
 =?us-ascii?Q?6Ft4GVvsiyY5BOz+wlCw83WSkY7gX4CSkj8mU06x1qNeXwaIXPxwxGqPC1Td?=
 =?us-ascii?Q?9kOfZPjlZuWQPovitaEz6f+kWNQxQHqPqvfPA3SunnXXlqmFBa8J9AyaBrXS?=
 =?us-ascii?Q?Oj4pcP/yY6tW4In9j0eMySKgHHY=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d9337f6-9654-4696-9bbf-08d9d5f247b3
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2022 17:38:01.2796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Qq2awboLV68KizjucBEzZF09iFGcf8u5ptToVsvRJI1r7KyGwpbrmT4jqpAvSjzShNh2VWEnDpLADQVQKs93vCykTzbaxNrT/vtdrKxzWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT3PR01MB5490
X-Proofpoint-GUID: 2dB9fALVW2mGQzLYz8SmiIf_VTDakN-7
X-Proofpoint-ORIG-GUID: 2dB9fALVW2mGQzLYz8SmiIf_VTDakN-7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_05,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 malwarescore=0 bulkscore=0 priorityscore=1501 mlxlogscore=681
 lowpriorityscore=0 spamscore=0 phishscore=0 adultscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The check for whether a TX ring slot was available was incorrect,
since a slot which had been loaded with transmit data but the device had
not started transmitting would be treated as available, potentially
causing non-transmitted slots to be overwritten. The control field in
the descriptor should be checked, rather than the status field (which may
only be updated when the device completes the entry).

Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 8a60219d3bfb..ee8d656200b8 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -643,7 +643,6 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		if (cur_p->skb && (status & XAXIDMA_BD_STS_COMPLETE_MASK))
 			dev_consume_skb_irq(cur_p->skb);
 
-		cur_p->cntrl = 0;
 		cur_p->app0 = 0;
 		cur_p->app1 = 0;
 		cur_p->app2 = 0;
@@ -651,6 +650,7 @@ static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
 		cur_p->skb = NULL;
 		/* ensure our transmit path and device don't prematurely see status cleared */
 		wmb();
+		cur_p->cntrl = 0;
 		cur_p->status = 0;
 
 		if (sizep)
@@ -713,7 +713,7 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
 	/* Ensure we see all descriptor updates from device or TX IRQ path */
 	rmb();
 	cur_p = &lp->tx_bd_v[(lp->tx_bd_tail + num_frag) % lp->tx_bd_num];
-	if (cur_p->status & XAXIDMA_BD_STS_ALL_MASK)
+	if (cur_p->cntrl)
 		return NETDEV_TX_BUSY;
 	return 0;
 }
-- 
2.31.1

