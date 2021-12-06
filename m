Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B902C46A126
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 17:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351177AbhLFQYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 11:24:36 -0500
Received: from mail-am6eur05on2095.outbound.protection.outlook.com ([40.107.22.95]:20928
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1350944AbhLFQYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 11:24:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0y2FDWpXyCVK154YKymdd2YdaNgLWGCvJ75ZuDMNcIeoEruKIkBbQaampQMA3fHWH6c4Vk9zns+eBQQL+8bX24NvR8Yfczy1FYTdM6um2rcSi8LsLRqHWuVucvUNS4Hwh5xIlWz0uTKiu6nQV8nn7gFP9I5birO62mniQvNyCUfnGzGtjRPPOr5PWFmEReNr+4ByrcTNB+oorHgQ11AcswzGYW3cb2GJYjJk4lub79BKk2leSBWFpOC10d8Y+7BF05yLagxmacE8K/UNexYsVOBr9hOnkoYIhiPVkxqBpbpnKrn0DayHpjS7n2J1ITukTaCQg3o2n2Jgqrru6WEaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNAXJJjnziwLEKLokpTmjUt/54eSXEh0wG7gLMddFs4=;
 b=kQgoOFrmZXwDRRIYLAhW+GaZSldSB2DMRjtMX7kpy5Jjr4fyjtnrrIV3GW44+BQ2+cVdksUPt50Xnvws91mcYtTugS5MWsNA/oDQoWp6haLo96P/3PQEHOJ8giLkhMHYVuEguKjFwfHaiXgBOpnUKkiP6RtHTY3e4fdZjgugcSC8nzgiKiPWG3bS6yueykwV3qeJaqNXvqzmGRg+WgQXbV2N80qdoTwgiTA8owhLTGgTNoWDdq0hTFXxJh3+X1GCxj7U05v6CW0QgUXd32wlb7FqcSu14q02jIpXbRk4GmL2nNaBbDlDeu/bC5nc/95YUCiwDV8L4fb6Y3Kp2bUkpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNAXJJjnziwLEKLokpTmjUt/54eSXEh0wG7gLMddFs4=;
 b=G11xOS11pkawA9uvSPhRESHErxlxFFmwNOVh85gr1byndzOFi8FsqXN+l+l3Jo6Vi8nFBdP95MK20Tnoyn7A1c/X3OBbt/snpeK69NcGn7YT82FDvcfXGR7s1keXH4rbNsUaFe6ZMg8I3CNjsWHaq/OWvHC0XYfqXlh0q0WF513aAFdfDcidJu/vsT7Mb9sDW1cvHJPPTGHrHYJrCp/PXzag8cdOgIN+v2evVg0sCXVj3fAlCJolfcgBzOq1QO6bwgvqouXGqEBxDZEPJXLJbe20lJJVq2uUnp6YxiHyKdco24ikqazb9Mk84L44lvd4jE9S+8VQufaFcZEs30q9nQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
 by PAXPR06MB7422.eurprd06.prod.outlook.com (2603:10a6:102:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Mon, 6 Dec
 2021 16:20:59 +0000
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15]) by PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15%2]) with mapi id 15.20.4755.021; Mon, 6 Dec 2021
 16:20:59 +0000
From:   Louis Amas <louis.amas@eho.link>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Matteo Croce <mcroce@microsoft.com>
Cc:     Louis Amas <louis.amas@eho.link>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH RESEND 1/1] net: mvpp2: fix XDP rx queues registering
Date:   Mon,  6 Dec 2021 17:20:50 +0100
Message-Id: <20211206162051.565724-1-louis.amas@eho.link>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0060.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:31::24) To PAXPR06MB7517.eurprd06.prod.outlook.com
 (2603:10a6:102:12e::18)
MIME-Version: 1.0
Received: from las.edt.fr.ehocorp.admin (185.233.32.222) by MR2P264CA0060.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:31::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Mon, 6 Dec 2021 16:20:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a252f34-4457-4c8d-328a-08d9b8d4635b
X-MS-TrafficTypeDiagnostic: PAXPR06MB7422:EE_
X-Microsoft-Antispam-PRVS: <PAXPR06MB7422054DED0C54AAA0219EC3EA6D9@PAXPR06MB7422.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qffnLdj11sUY8ECzlNNuRa59cU/ZFfEmYDTxmqZXtfSFPbkENvEiUov1/NJYfqQ/H1d2koF6b7IWUWq+OzLlrE+VJohJw/D1H//D/8FUpdika7BMu0zTavwGidsKP1oFT+XMr69lhi2mhsSnilgHLPPZ6IxcyR1ZgMhsbUxJ7NnVkLbe4Sc0Gf8KCMzdHEDQdYR/iCq3sbyiDaJKO/q59enNQcw9hfOFtLMqtEH97gcK7Bbu4vo7aUmXeLF4Bdc/Dv7ZhDJn6DJWP2J027Z/+uyJ4AVoEAdkOhm87/pDBnjfKaJKl1kFbzTzaGJ9ktJcF4C5Pqj4g2WuqauR/A5R+HNWQN0AmV9uxvT9eGGwDpdfs8j1v1qm63RRfU5utz5uAI3Ff6h7HuVMI2ZC1pShBPLuXyqBsVcSqyzC4evYDrl/fsz7zjvWHgmlujSLTjTLbd2GYzq6PqKOb3+4K77HUqY0yS3HMP4Zdd06ASEnGCNYnrHugvbtxZnIfFLHGTdNVzRoySuDtD8E20Ch97CZtJkM0/2Ef4WUWcrGPEiQIDWTEMdDPSeHqH4SKnSu10ehNhnx1bv33RqG01IGeUXsHKxEAnIVPch8aOQU5HTtgNgEHuFtrkG4B33P2+TiCp7B6ypFvYlI7RLhSssknsr4uyn+tpHqT0H3QhnVZ0V4vowDIFTe6A+TrU2jzMeDNEnALD9qnb/6cY/OL4Skjdp9wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR06MB7517.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39830400003)(376002)(346002)(366004)(38350700002)(7416002)(110136005)(38100700002)(956004)(2616005)(8676002)(316002)(44832011)(83380400001)(36756003)(52116002)(6486002)(508600001)(6666004)(26005)(86362001)(66476007)(66556008)(1076003)(6506007)(66946007)(54906003)(186003)(5660300002)(45080400002)(2906002)(8936002)(6512007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7wzaIPYcOuTuSNOTVeCMwiN27LXlYGP2CO52UhcrGSHEW991stsluHaJkVjU?=
 =?us-ascii?Q?z7Dp6m30NXHDRpvtdu44xmLBezLDTbYBWkdM6BNHubPXR07OTPj3o+WXFcYY?=
 =?us-ascii?Q?CTzEL9QaBsGPz3C6cjo+z9fVJd+aAfpcxu7yTKy4ZVOsSoGklfrMn1bC4kPD?=
 =?us-ascii?Q?Dlak+9xy0l//2TfUphIYyUeLPgP4z6z7/bLIyOc17/1V5kqPw+uc7NXqEVK2?=
 =?us-ascii?Q?oYE/c9nyrVOMVOQcUt9wHgQpfiq46zgNGrI8Z0vQPirhWSf5hYKdBK8diTTc?=
 =?us-ascii?Q?RgK55p8d+GpB/6FsYmuEBj6en18DNlFq828tEchXhGenSSVhWzgDNohpf1Tg?=
 =?us-ascii?Q?Tx5gpO1n6T4yfASYjinnAwloF7H6ThFAmTlUoH62U2WcTJOoetBj04JdYklH?=
 =?us-ascii?Q?NCj7eHPbfGuiKbfXr7yRJzCa/ME63y8mvsbQDWF1BHkFej+4DRUiTc8UdwYb?=
 =?us-ascii?Q?MD2qFCNwvyyYgCKcQwyXMpwxDXzr3wyWTDkBlKTw5e98WTGoYSDJh+JbAJi/?=
 =?us-ascii?Q?axXx2/YBmAv6c1CkurX2gcDp5hbHj4jxj9yhuxa1u6tt4fk+gezh3JLQTjmF?=
 =?us-ascii?Q?2txHsBrTRWmMdN9Phomm9IxcfVUcqulahQz5cJdO6ckEaaDS1iP7NFWioJG9?=
 =?us-ascii?Q?xZrAyImwJte6XRGW13uH5WM+d5Je431hPU093NdR0U6vcuxgLXh3ORjHnC3+?=
 =?us-ascii?Q?nPDVHcptLa6wu/MzEXXoNbc4/iPqCb9dkBBUCojm9EhYX8+CUn2dqYp1g+zI?=
 =?us-ascii?Q?PkGg8+HPpIUUipYLGFKC4yADlxn0y3QkcGC2RDRhLSFTsRkXsM6P9tc/mJ1R?=
 =?us-ascii?Q?Br9HUH8MIegukJMO2gx7s4+ZqK+YB4ocY8ajp2Km3LveylWdW7CP4HLDPMKh?=
 =?us-ascii?Q?ypbVDi2OlKJtUraoGca12/ChOzRzVtK3NwgCm2ZK0ebBANesOkNOyu82BHbI?=
 =?us-ascii?Q?gw9jTEYqetWXEb4sVbRTuZ/j1zPYE6C263akY72CVaT7DZIIbVjZJqNJQ2DJ?=
 =?us-ascii?Q?fVSeh7oN/jYiWZYbbLytqV7FJmUjc1vLWPQ/RpMdy2/9T/4x6gTidxyJFLnq?=
 =?us-ascii?Q?OIF1M+BqDX58JKt/h2v/qOv4my9kph/FtV7qFQuJ8/7ZNCtAFQ46sUmOoO12?=
 =?us-ascii?Q?0nrDy5h3laXPE62WHXPOKY1/wiREitbYYf4aFrcePaJg3lEepmoF6pwW/44h?=
 =?us-ascii?Q?4vsztlVFMklSqzaJYCSdb63GChcvqErTdESYjJhnM6GinZa7ZrChjcHoBOfz?=
 =?us-ascii?Q?m/Qg5N3jJD/iAA2quKM9CV0SLrXYkPd6lAgMWSe5qvZefUh6Z5xT7aPzXz1D?=
 =?us-ascii?Q?ydBA913QtXiXvR+doqn1YhvLo7ryAKZuFD+svAR8wXQ2/gB1FIhzdPCBcmLt?=
 =?us-ascii?Q?syTvXT82JgZ09WMQeU28w2b8aVEHt+wo7atA8m8/6l35UGEBEdPtWrehJWj2?=
 =?us-ascii?Q?BTYKKqV7CqE5zgBIJ6HUrzX++o8HX7Ru+HDveb3bXEIMSwOb/cZk26WnHlfq?=
 =?us-ascii?Q?6HIeaHjUZEMBTQ8O0mneBfGafIVCxs07X7SZOOkPFHBCWucjC3N4lGaMqssu?=
 =?us-ascii?Q?4lY8xFXGaTqeS2aAXNm3ohisniceFo+AXgkCq7dnejAjGzOSUNS3ZsfoSTWi?=
 =?us-ascii?Q?+cIMULg2AHKbJsNs5pmeCVk=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a252f34-4457-4c8d-328a-08d9b8d4635b
X-MS-Exchange-CrossTenant-AuthSource: PAXPR06MB7517.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2021 16:20:59.0329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hqzP2mXziM0X2CA9tp80vMQodUU0GEyungBWKZPO+D1Y2iftMhEzU0U8QEWww9zdZ/BJjWP7pOskeYsSpM7iiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR06MB7422
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The registration of XDP queue information is incorrect because the
RX queue id we use is invalid. When port->id =3D=3D 0 it appears to works
as expected yet it's no longer the case when port->id !=3D 0.

When we register the XDP rx queue information (using
xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell them to use
rxq->id as the queue id. This value iscomputed as:
rxq->id =3D port->id * max_rxq_count + queue_id

where max_rxq_count depends on the device version. In the MB case,
this value is 32, meaning that rx queues on eth2 are numbered from
32 to 35 - there are four of them.

Clearly, this is not the per-port queue id that XDP is expecting:
it wants a value in the range [0..3]. It shall directly use queue_id
which is stored in rxq->logic_rxq -- so let's use that value instead.

This is consistent with the remaining part of the code in
mvpp2_rxq_init().

Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
Signed-off-by: Louis Amas <louis.amas@eho.link>
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/=
ethernet/marvell/mvpp2/mvpp2_main.c
index 6480696c979b..6da8a595026b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2960,11 +2960,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
        mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);

        if (priv->percpu_pools) {
-               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rx=
q->id, 0);
+               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rx=
q->logic_rxq, 0);
                if (err < 0)
                        goto err_free_dma;

-               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq=
->id, 0);
+               err =3D xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq=
->logic_rxq, 0);
                if (err < 0)
                        goto err_unregister_rxq_short;

--
2.25.1


[eho.link event] <https://www.linkedin.com/company/eho.link/>
