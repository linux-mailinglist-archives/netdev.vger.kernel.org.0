Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06BC46BD70
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbhLGOX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:23:59 -0500
Received: from mail-vi1eur05on2093.outbound.protection.outlook.com ([40.107.21.93]:61504
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236656AbhLGOX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 09:23:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jqxkrtIMCe9QAoXvThXuQ3b7W/iIQnf04iGSuqaBQFQRBTOSW9YfYkDlHhcFIG109gxF7p+6YoQZFh+FlHHN5yJ8XtmJDgKV38oVg5odjRyUbeX8zK6QUVxErhw8siFtha3nsuJQnE36MxQn4XzjCbO3wn5Z2iNmUprlYpMzvYd8zQ8YwLrxz4KNXAbEkm94a0avZD3yrE77Cj+xUQqbWDydOHQBI8PKNbrFC0mYjkDpjUanRkMNaqnT8Bn+BgcnTHhm/Ggq/qyn1l3q+LT/m/H4nIwfwheqrDhXRMCetMheEJSPIdJZrw+XGDxiLE4OzAtKHcpbnBwcOay3zKBZQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5H6TSBAg/MJB7Ww9FPeIJn9zTS5XnbwHC6j3UKHppwg=;
 b=mJGcfDMqJDxus0aA1tavmFJYN1yOI+rX8oEh6BwxSIzqfVH5wxMW1p/duh26vHe4eZRuWt64S4QCJu1vywHvYnFuJ2evMHIfqe8xqiXPwOBLjeg5iIIaV4QeS19Mve31TfjUc8NbNreKGbMh/SZMOtrA0W+MZd17GOb1QtPVMu8yChg/cW8fGdAF/Zca/p5uLrjK9XJCHs72kyjAoPOr8ibWTcXmnkPGfv22X8i8unvGM7IsxK6l99861JrgHBPBXGsMokIVMeQfvg3hwXgatqwE9kSTDM1rnX9bwlvgz9ESjR1ZvqSmKACbsA8UxpRYJe8ON9FCdpBwi9I+J4KdZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5H6TSBAg/MJB7Ww9FPeIJn9zTS5XnbwHC6j3UKHppwg=;
 b=P11F4jURaOeftaQeF8XpZhKs78qPky9ThAwzfkwpMmDqTqbhpm7HYZUN8DXH3Ys43b4t5/b8hIsVW5bUSfnvJ+C3iU01T3oNwP/RZXiKtB5s5wWzh72WGnB5vrlnmq0pAeADwVX3258r6KTb87uErhTlD4I5gs/PoSwkdYvBkaLgntN8aeyanMwa03q15zKKc6EP8jT7+LlxSE6iI9V2NtTKv77S4YgfV8P5pM8D1Bx+6xZXgHIUMSavE9EfYYvD2RzXOxkZj4rpDz4Ocw33KImoIZj+2sKCL81PC8/W81mAkOJMhYpNSA2X+ofZoWQYRc4Pphp7UCLpx5EzxJZD8A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
 by PR1PR06MB6058.eurprd06.prod.outlook.com (2603:10a6:102:9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 14:20:25 +0000
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15]) by PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15%2]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 14:20:25 +0000
From:   Louis Amas <louis.amas@eho.link>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>
Cc:     Louis Amas <louis.amas@eho.link>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH v4 net 1/1] net: mvpp2: fix XDP rx queues registering
Date:   Tue,  7 Dec 2021 15:20:16 +0100
Message-Id: <20211207142017.900582-1-louis.amas@eho.link>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0034.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:2f::21) To PAXPR06MB7517.eurprd06.prod.outlook.com
 (2603:10a6:102:12e::18)
MIME-Version: 1.0
Received: from las.edt.fr.ehocorp.admin (2a10:d780:2:103:41d8:a7c8:4528:9720) by MR1P264CA0034.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:2f::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Tue, 7 Dec 2021 14:20:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e4288bc3-e3a9-40f6-b0e9-08d9b98cb61b
X-MS-TrafficTypeDiagnostic: PR1PR06MB6058:EE_
X-Microsoft-Antispam-PRVS: <PR1PR06MB6058A3840B92294AE913605EEA6E9@PR1PR06MB6058.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9rrTKGD0duk47QG+02X7qyR5nb5dZO34vUmhm39n2VUe5CYRfaY3EhHyMPCnV1M6w5s4m3tuyQglHnBFLYc3wr0DRsX4CcJqoGMWJSZKCyDp8msEO3BPOYawIkIywhlDl8dXd9VNjOWgUZ+nuQ3K8ZYHW/3wufmIL3W9y2Lmn7yne0zaPjckOIufvCCcJizFV7Wn12c4V/jD6bjbt0pdriaP1QohSLBwX1cLHiQ7HfEks1X6fy6obvqUCADpP/cOazH5D06ZMjhexFvOSSb9OKbjdgLRMCImT+Wz8ybcmI2CcuMaGtCmWCSEh0I30DZsvBCUYI9X2GqSnS7gZ3lzcuMrwowxneWG+0yzRX3Nr27m7C6wrWu2lFn/ExpV2+jz2Ezo5loBkPyJXn51DoHas/Bx5cWW9GNdGIsVI669GxNxMKa1xYDzAWe4GBA89cCn6oDAyODDbySRF0p2SrSHIFd8h72tphP/5tqFmUxuRPT6cbsm04Zj81wOiq+qbhjs6xLiaURWZhDRrUVCRMn31fIgMRaEDb88xmITOg4bZ7udpyPGwrDFp/zTDIZc5CX9ovjsEBAsoBF/Bx4VD5AoTYO8ibqEpVPmv2ZUrdD60vQsJ61kwwTHuqGrFMg2vA5EglZpIG9r8pGVjoecaI1H1uxoidNBp+9pvmuCXS3SAvmmnU6rmS4jIkKUOuqmN9vk1wHpjg5PHk/y8WT0crbhFps7TnN8+GulRcrXu0GXqj1TsY8MR9+0DL9bnFZ9wvP21SgKNofy8j7lOlPz54hyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR06MB7517.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(136003)(346002)(396003)(366004)(7416002)(38100700002)(6486002)(66556008)(66476007)(4326008)(6666004)(6506007)(6512007)(186003)(52116002)(921005)(508600001)(66946007)(966005)(5660300002)(8676002)(110136005)(2906002)(36756003)(86362001)(1076003)(316002)(44832011)(2616005)(83380400001)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pp1sbaLMojNg+3LCUsJRASh2mpGFVRhpcUKgO3ht2iP6i89IzLE2XXf8w1W0?=
 =?us-ascii?Q?iKop3GCeaMAc5nle3C/Hm8NCSCtirKKS3tmlpofB3EDkJM3PTeZ/u4nhrkxp?=
 =?us-ascii?Q?PoGruemNK8DKwiomQJ7qc5kVUyjUbgdjSYyOqUgSS6wx2AOfFXg3RT7DQVGq?=
 =?us-ascii?Q?V/oBRu9KxJOFEx+umc8755FzBoeUOy9yq/AEubI+cdSE7b15IQ5HDxUbAnxI?=
 =?us-ascii?Q?AP0+M3eOepZaWeE+N0UAs02KoE+Rhg8hR0LsHmmu+shW7ALrQXN1+rOIWh5O?=
 =?us-ascii?Q?ydsHALNpDxeAWpeET75PHU4uCuw/tO5FSRBOa/ZBG36GssJrYrvUsjx5fHWx?=
 =?us-ascii?Q?eGTz8mfKTKWJZvl7kMOqCwCz8hTSRUHSLTuFIyVtWW+Fg1kSdS7LTzxSBKGv?=
 =?us-ascii?Q?xE0C2iz/R63Wp/dk6PhPOKGn+GXtKO+7iqosAg95hRsM26FIIFopQUWtacF2?=
 =?us-ascii?Q?6zeIHtTD7/EDbZaI5+KdUJG9PNN0LMPD3zkwHoeylHgGRZEMuNuqHBJmtMA0?=
 =?us-ascii?Q?kTs0nbAbIXFSdW6B6pFKH+kLKPeBf6nPf/dNJkyUzahpiZR9KwPbHr2HUSvu?=
 =?us-ascii?Q?hE5OtwY1vNZl78vDdMN7CoieMSjXI3Ej7TMyZnugQ12meneR4f8RlP802+4W?=
 =?us-ascii?Q?ryCC0ym7lwnTROQQTSx1mm3ocRvRyo6fK0F1zSXJdg6u1RaF02a5+xc9CQBi?=
 =?us-ascii?Q?+5a4DrSlQZzwp5ybg+lX99UjxL0530oFPD65OFwkFm0NKEBd/91ACBxYHPUL?=
 =?us-ascii?Q?dirN6/xQR6u6WhkX1EVM7rv6kHviYh5xWBnmXDMchog4q3yw0DP8p+TIgt8J?=
 =?us-ascii?Q?bySgv7ma18SYl3YhMs8poprVE5mge6lq3bDXZYnULn0ZhpJWqg23QzwQ+tCp?=
 =?us-ascii?Q?0p97t27KjZEYUbcSdyN0q7pyvFq+ljsCNr5wV2XU4V5FCVjPxnkN9Yj8MM/q?=
 =?us-ascii?Q?aKb1oueZeb+E70fJLV0X5QQAdYKtYRARSO9TsEGSv97E7gJ9Et1+roE3C/A8?=
 =?us-ascii?Q?N1MjN4BzwEFoZu/J3JQnfg+aLpw00gpjbXXCJ7NMhDEBv5zbmvQ0182X5W85?=
 =?us-ascii?Q?VTBR1TpZ/qcl2KiYGVFmu3cCvyNhEbHm+MSaZiq6hq7MPRsM9yqSsYNkUOpm?=
 =?us-ascii?Q?pDVRoTg6VQ+LsRlpk/hc7FfmJ6jMO/0y5OwMXdG4tUs2IxAQZTNPvACAPmw6?=
 =?us-ascii?Q?aSWHkjK7K6U/uz23VprAmoSx93ptCP8BdnGvymBHxGtdpt0Fnmd3iZAz1m1S?=
 =?us-ascii?Q?Kr9amt5nXUabJnkfzzDJEvySBaCtVdFrzAA0Xl4jpBuDAGLsySyiSU7SFbbW?=
 =?us-ascii?Q?soOqe3Yz6TMm+jhK4/RY48lMDUG644i0zmkp5KN2muoovz6Hra8eJ51ExONS?=
 =?us-ascii?Q?HNd2qrEBM1v3ge+0f79hTy/iuTKV3yDVUZFQyKNLlEJ2yrX6+2I4Wj+8QzG1?=
 =?us-ascii?Q?+Y9uAVHqwEXfgp05TOz723FhueSH80n06zeb7EL2fyxo4emDnkW4mJCU4okp?=
 =?us-ascii?Q?N7WejEP5ZT08l8leGzqQLFxfIv/GzTuQq2/iV9dAX10TpVYGCa15+dyg/QFC?=
 =?us-ascii?Q?j/sLesgHs7XBVpda2OMGCtxiqVhe3e1SwnVrXhL9/Owcj5+eT/qvfQpbZBbZ?=
 =?us-ascii?Q?UPTMaZzZ5qFtOHlhJbPFP1JRj7YwhDD0ss2zGYN8KxDh4TZANOTEIiCbuXPZ?=
 =?us-ascii?Q?vCBEgx3Hfhu1DWKkSJp6CwSXViI=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: e4288bc3-e3a9-40f6-b0e9-08d9b98cb61b
X-MS-Exchange-CrossTenant-AuthSource: PAXPR06MB7517.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 14:20:25.2300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Twg/nqxtut+ghhaq/5lN0lLMMzGkEw/t4O99TOsD87wwJf+64R8/qqQ4vrdUaIgrcPqjrv8z+RZisfngmVwmfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR06MB6058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The registration of XDP queue information is incorrect because the
RX queue id we use is invalid. When port->id == 0 it appears to works
as expected yet it's no longer the case when port->id != 0.

The problem arised while using a recent kernel version on the
MACCHIATOBin. This board has several ports:
 * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
 * eth2 is a 1Gbps interface with port->id != 0.

Code from xdp-tutorial (more specifically advanced03-AF_XDP) was used
to test packet capture and injection on all these interfaces. The XDP
kernel was simplified to:

	SEC("xdp_sock")
	int xdp_sock_prog(struct xdp_md *ctx)
	{
		int index = ctx->rx_queue_index;

		/* A set entry here means that the correspnding queue_id
		* has an active AF_XDP socket bound to it. */
		if (bpf_map_lookup_elem(&xsks_map, &index))
			return bpf_redirect_map(&xsks_map, index, 0);

		return XDP_PASS;
	}

Starting the program using:

	./af_xdp_user -d DEV

Gives the following result:

 * eth0 : ok
 * eth1 : ok
 * eth2 : no capture, no injection

Investigating the issue shows that XDP rx queues for eth2 are wrong:
XDP expects their id to be in the range [0..3] but we found them to be
in the range [32..35].

Trying to force rx queue ids using:

	./af_xdp_user -d eth2 -Q 32

fails as expected (we shall not have more than 4 queues).

When we register the XDP rx queue information (using
xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell it to use
rxq->id as the queue id. This value is computed as:

	rxq->id = port->id * max_rxq_count + queue_id

where max_rxq_count depends on the device version. In the MACCHIATOBin
case, this value is 32, meaning that rx queues on eth2 are numbered
from 32 to 35 - there are four of them.

Clearly, this is not the per-port queue id that XDP is expecting:
it wants a value in the range [0..3]. It shall directly use queue_id
which is stored in rxq->logic_rxq -- so let's use that value instead.

rxq->id is left untouched ; its value is indeed valid but it should
not be used in this context.

This is consistent with the remaining part of the code in
mvpp2_rxq_init().

With this change, packet capture is working as expected on all the
MACCHIATOBin ports.

Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
Signed-off-by: Louis Amas <louis.amas@eho.link>
---

Patch history

v1 : original submission [1]
v2 : commit message rework (no change in the patch) [2]
v3 : commit message rework (no change in the patch) + added Acked-by [3]
v4 : (this version) fix mail corruption by malevolent SMTP + rebase on net/master

[1] https://lore.kernel.org/bpf/20211109103101.92382-1-louis.amas@eho.link/
[2] https://lore.kernel.org/bpf/20211110144104.241589-1-louis.amas@eho.link/
[3] https://lore.kernel.org/bpf/20211206172220.602024-1-louis.amas@eho.link/

 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 6480696c979b..6da8a595026b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2960,11 +2960,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
 	if (priv->percpu_pools) {
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id, 0);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->logic_rxq, 0);
 		if (err < 0)
 			goto err_free_dma;
 
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id, 0);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->logic_rxq, 0);
 		if (err < 0)
 			goto err_unregister_rxq_short;
 
-- 
2.25.1

