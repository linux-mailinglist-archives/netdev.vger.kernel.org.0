Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7306946BDD0
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:35:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237938AbhLGOif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:38:35 -0500
Received: from mail-eopbgr130092.outbound.protection.outlook.com ([40.107.13.92]:19421
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237928AbhLGOie (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 09:38:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nbtoTK1bCDrZC92mdStl91HWLSTLBPEwnXbpQ0BF3Z+kzEnHneJCEmmd7xKN3JkbHjkkRjZxbbJ0SocTdQbReqSBdNZEzuiba7eanGTyDRyr9MZ03gammvX4rZ87uRYlOPO5wFBmsJIQnW0wRpDc1AMmeyWmd/olbcEkzNCPbtLnj16pmiXmiQlDIG/e1uQ1G5nOksnyYU9vxPgKl1UsRy+T7eqndkV59hY/3nPkDPATzD+5fMYSdBSSThvN3P2AF64gY9GOJ4/NlRjwFHzv0Ik2KX5OXiLCMUoxW9gL2VvmjOwIJsZkawzQ95KpYfVQf2OnwEZDKGbwf8Z1mg35Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yxrce/ZuYO/eNkyyPClonfv20H3bm9Bye2GnxXvVsCY=;
 b=KrEuxUBHvcSKBICeJOhP1/XJlfMGfZXWVErdkM1U9NdROCHG0lXqOS4XY5JpyoqCl8cWXntrhN2PyinQMV1s+9HCyexZqmKFXZ7Dz2Eu7tP62q1ZxyP5G5giQ5tXsuRGIrCt6KATEZH7AtVf1EvAgg0QLa8lqbkISdyw/L4dFpR0zLGcT/Wb9BJbZeQBdmy6Xec0l+xB3bcrSZBLXawokwon8GfyZn/lVMqgb9/dtIbiLh2UlyDnWM9ffBif8h0lBb0YroU1EVc7rH1LVDMHxniPjdzvJP6MbtIum3sgA3tGk/P4krapgaDMANd6DKBhxENFjnHnnQgyDLIz/FiPXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yxrce/ZuYO/eNkyyPClonfv20H3bm9Bye2GnxXvVsCY=;
 b=VR1JjRWSE8SDl/qh+d3xc6whUJzdYbq6RtCDzQuDMPZuu94Kr8B3LxPQ+e5GOmeKrVj+n0Oib/cSgv94nA8Sejug4XlahnzEC287oxle7csPBJ+krx2wsLRW75xXfze43RhTK4/ENJYSQDz12z/EEl2Z0xzeKb0F6cjoRt1LJKIXIgrWY8qz7AQysVWYvDbfiOOI4h2fupEznDC7yKA8FJLgVAYIC2VRd8ZUkkvYdPA76l9sG3L5kfQrisfdUMV+q6e69Bfz2WXICIPFVVxz3ImidIsywiQlWiKrjKy5jTfZhr+HWJeOoXRcPuEdfkN2+IMstwSEZC/iUsc752n0lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com (2603:10a6:102:12e::18)
 by PR1PR06MB6075.eurprd06.prod.outlook.com (2603:10a6:102:10::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Tue, 7 Dec
 2021 14:35:01 +0000
Received: from PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15]) by PAXPR06MB7517.eurprd06.prod.outlook.com
 ([fe80::42c:a94b:d533:ca15%2]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 14:35:01 +0000
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
Cc:     Louis Amas <louis.amas@eho.link>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH v5 net 1/1] net: mvpp2: fix XDP rx queues registering
Date:   Tue,  7 Dec 2021 15:34:22 +0100
Message-Id: <20211207143423.916334-1-louis.amas@eho.link>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0093.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:3f::21) To PAXPR06MB7517.eurprd06.prod.outlook.com
 (2603:10a6:102:12e::18)
MIME-Version: 1.0
Received: from las.office.fr.ehocorp.admin (2a10:d780:2:104:4176:3f4a:58e:7624) by MR1P264CA0093.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3f::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Tue, 7 Dec 2021 14:35:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 24a5dce0-aa07-418a-788e-08d9b98ec02b
X-MS-TrafficTypeDiagnostic: PR1PR06MB6075:EE_
X-Microsoft-Antispam-PRVS: <PR1PR06MB60753DB2FB055414C79F225AEA6E9@PR1PR06MB6075.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bdKfHsxB+MmrEek9o9TgQjo5NEJjYbkH0SoCh1jfOVpGpNvZTCeqL13qmDe91wt3enB1y0+dMjg6L64gMgIgQujC83Ud9cOMxkPPXxiv2kFDViJqv6U0eHcb1b5PmEVyiGQ6mY+FfCj2ObPBBUyZbQaw984Nwu9uKWsPCCpdnrkrvNnvj1unvvSQDPGa7x4ZgH96uicdWBhJpV8xGRwiaEl2dypYCaUdVEimD38lu4kg+HGEMCSqpJeDbVchL5Sy5osCJ4QmSVe7CLmOPHXUe8ZfOKe5i7EbT58HiyqJaWyPh+i3j47Bpuw5FH8Qf/BFMziKx/97HbhW9tociiF1ncnGWlsmh/zNx7waRvFeRRzZdCeDMGJoEDFx0Hnv9n25NORKZLAXw/1tp6oWqI95OGDBYSwaNNxwb44Uh/PE0+vNmPIPIwZSAW+cG7EYfkNrUWJywfwIdcKuZZ3vHpKpNeVIq73Pw8HzKyeZrpWsLp6mzs5QnO3iqT8h2JI9BSUrkzzQTAK4vm+uMaF2WmQQUSVriq/infWqSwbUkZ0SYLWBxxTADFX2SMujE8vlGqBjck5j8D5loE8QX/YqEL/UNHsVUz6kRHEO+G+sjuXzUljzm0ywbtukEZTmZ40dxmyPiESgO3x+XJlhICYmDqDwbWUwsmwnRVifDqpugrKkgvIzn6shLsZtdDWByxgNauZZYgFu41Aw7E8A9whduRRKW2Q75uXzPq6dhc91FGiflhI6l0rj8G7Zq1bdJuwvVPjGcpmCjLZSJ/dSZSi1FBfA+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR06MB7517.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(346002)(136003)(396003)(366004)(376002)(921005)(38100700002)(8936002)(86362001)(54906003)(110136005)(44832011)(6666004)(7416002)(5660300002)(2616005)(316002)(966005)(6512007)(6506007)(508600001)(52116002)(83380400001)(66476007)(4326008)(1076003)(66556008)(6486002)(36756003)(8676002)(2906002)(66946007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6TFNvQNlfKdSwgOka/NjZRYuDA6UF52xlk6V0dZetpUfz3JVV9+Sr0PngNB0?=
 =?us-ascii?Q?6BikgYSch23NA51lLbYskik9HO7/CF2/5AdRrhQW1BO0kZesQlH6Bt+HWkCl?=
 =?us-ascii?Q?T4FMku9Mp6EFaOfOtGEzbsdnwzMyGw7+ZWXAdrWSSmB5zFZ686XbdnK8625V?=
 =?us-ascii?Q?WKJ3ljxysESG1+mko3Lwsfgwsk0suKsvJjQ/MH2YUrtEoVdGNkROLzdj4Cs4?=
 =?us-ascii?Q?6bTu2//cxiceZHFlb7Cj8PQkKReMyEXUsi4OxCj7elahIPGGf63i4KWkhxpS?=
 =?us-ascii?Q?O2VJbj5MaZ9jeDgTQ1sRHJW//uUVgh7IJVCqgjPtOuiEjf9lTFpR1zJasvaG?=
 =?us-ascii?Q?zMROK6NnGu/xvAVDxrxgfXPSwVrGmpZBI5ljpFNbHZXVPxqzmRZtPsJw3UD6?=
 =?us-ascii?Q?orx/xK230d3Bpn7qa7y7o7t0csYdM9GdKFG/P2dvXGkcNWgCt+iRNBa5APad?=
 =?us-ascii?Q?T6/ZCiYwp6ZBmf4SiJ2t55/aLOH5+SeuRQBcJ8ABTLTUo4Sl5ReAMR6DSVKC?=
 =?us-ascii?Q?1sAkIRHsTuMCH15ZuB/7G4wxLR/W2N4qN//HOcxrIrTe5K2ZL9T9m9Dytssj?=
 =?us-ascii?Q?s945i9AB4RPYSk78qRDIRTpFeuuvy3xfi3R1G5+8jND25bd3s1OD2e23GdJW?=
 =?us-ascii?Q?jcEt8+Ypk1jnrtJ20KhEsMyQj+5kefHRh00/RBs1u/CqAqs1mApKjeEhtUNB?=
 =?us-ascii?Q?/lpvax7IW4dYDHCBKKht5Re18C3Ja2glhWvIOOo7EAP+nfCl+zFqBhJW9cHD?=
 =?us-ascii?Q?LG04cIDaE9sSl9S436PU8cAxvC6Sd9CjtB0IIng97Ltx0HmsIXd5t+08Sm9W?=
 =?us-ascii?Q?Gy7RI6rL+h2Z/h6X8hhV5yPSeNq8QFL/fJKwXRl47Iu3RUH8YIKhIjZomGjF?=
 =?us-ascii?Q?u3ezHl7Q4v3ZNuBiu9vqajjL1IeM8VSqPA59mu/o+ucvZNbi+TilHcXQD4vZ?=
 =?us-ascii?Q?nVBjj/o6YmexvDVmNxs0T73Y8nkk0hc6QO4+jtNTgGlIto0eOy1qCl4gH8Ru?=
 =?us-ascii?Q?MO8IEYgbU6f7FVPTytxnhq/yM6KL/Y1aqLR9KhuoetlGW72M/bak79lRpPab?=
 =?us-ascii?Q?dVzFsQtUgkZTjp5PjgvFeq6WBjWkLXM/VEFgbLYDAP37s4KHLnRIuTc6idQW?=
 =?us-ascii?Q?8NIwuizIAjPvIx/BwUW26uOliJTHquMFySB7EiScC0y27kLO2GYLxc2INbm8?=
 =?us-ascii?Q?MqWsmCAL8rsmP/buyJ+WkvjQ2yyH9OyAFlrcB6FhAaBFu70gxTkxhFaYt/YC?=
 =?us-ascii?Q?CeyAr4KRDJufjsL17r1QVIt2SdAegJEW21LRhLm4Eqz8eJEhcaKQkZzmfAiC?=
 =?us-ascii?Q?9r39bQcSnZqWdVZaSANOOGvzKolM9VCDtljbaIsPEEIDskh5F1JldYD89PcB?=
 =?us-ascii?Q?WWVniSKx5h7G/ctqmPCXUtumpKnnE2myaaNx7H+TSfw/3iCIMBDCZRIdTnnD?=
 =?us-ascii?Q?3rvxrJw7cPVOmgQJpgdfZMIS7G8fs6uCp5np171O1uOTfkZp/D8C2brxECm3?=
 =?us-ascii?Q?XFWguc5eqvJ25h2/hrC1FrqI5iWNlT+ZrMOxOBC/8/D7YzNgWN/lpilRAgqg?=
 =?us-ascii?Q?j1QggYwfIY2KU91/xBW6zFx2pthd1Y2x7NIwZA2lX6vRnxCr1qHOYVDk1gQe?=
 =?us-ascii?Q?9iF/JoYAkfnHn3ET8SGzsclv8b+vNhHqxWGyF3bYrzoRAgH846l/VZMkTqmA?=
 =?us-ascii?Q?pC0lqQ=3D=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a5dce0-aa07-418a-788e-08d9b98ec02b
X-MS-Exchange-CrossTenant-AuthSource: PAXPR06MB7517.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 14:35:01.1369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pExKrdVm4hKraOaO7ZGz6VO4qTbPMMhgwfiLLnju27m56jlnoamEo+6rLyd2MHokrPCvRi/hs8279eqJ6snVhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR1PR06MB6075
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
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
---

Patch history

v1 : original submission [1]
v2 : commit message rework (no change in the patch) [2]
v3 : commit message rework (no change in the patch) + added Acked-by [3]
v4 : fix mail corruption by malevolent SMTP + rebase on net/master
v5 : (this version) add tags back

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

