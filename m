Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D69252740B
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 22:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbiENUoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 16:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiENUoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 16:44:44 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00066.outbound.protection.outlook.com [40.107.0.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717C215830;
        Sat, 14 May 2022 13:44:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kt1I6otUAbZBiLD3caRm4WuEueSnXnZI0nARej78CAHaZc186aUopdrrCuDIBvR24oornDdJXFVDrinC8W/cjg0ZfS7jJ6cmQiR982HBETxB9MnyggHu9qfUPfEHlzcxvGzc3Vm0LF+sgZ8M/STVVuV2VLPOtpWu8MksFUzMQOXfTwqkkJkGx5aOs8ugtHyuEcb/lC0+7WsWNTSPum8plVnS7rk7X5CSLbp9lGWr0Izas/yRabylx/bJHjNyiKUco/EbGGetvCbQPYZGKvAgMwSOai4n6xmcqvsb2e527bg2bRx+FmLy8DkVdUjsbe8CY770R2QMd9SsBxbOCQl5Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R1g7wID6Sc2mK7YMJYbM1BecWALRnBubJA+gfDr75to=;
 b=g9GdX+mvALUETWSJPbmKHqxN2j+HLfjTP1RmxLJPjrL+eRbzRSIurByA8SGuYV7UjArbDxexRtXRRZozO+eY/i0qx3CAH0gMzCydr+P88i29DmlS2LwUHs0yY4qgKTjxDO0vCf2Srf2uipiKRLcMX5aX/w1Xxvisl27qwVCoMtsG3dHB9ZDRKZ9i3ETESR5T+pjh/xYhujyPscHBVYXHgXHbsybw9Qsp+7KY5W7kN1sn1usFfdE/9HrQYE9gdH5pQtK+Vn58RO0WgJKPuYk8YWhUx6Mv+c3xDI6VhvKgwZprBtuLYZoCUTnJJnYHlbC251RCr9XK6TbVn9wud2Cigw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1g7wID6Sc2mK7YMJYbM1BecWALRnBubJA+gfDr75to=;
 b=BowUv/bxkpkoid6zg2pKeq0icCksB6T5ewaYBG72/Vl/P4oEdxGosGEbwkG/YmnD/39odFrPHsV007gK2iOaJjH+GgYQY4emnTnkot7BNDSXppjKN74gKv8MgLB3USsyAUspyLCfcWaI6HNjniwR12o/FX6wVijPci0a/nACjIY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB6488.eurprd04.prod.outlook.com (2603:10a6:20b:f8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Sat, 14 May
 2022 20:44:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Sat, 14 May 2022
 20:44:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Thread-Topic: [PATCH net-next v2 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Thread-Index: AQHYZ6RGlKcgyxwN1kCT6B//Bf0Qza0e15IA
Date:   Sat, 14 May 2022 20:44:38 +0000
Message-ID: <20220514204438.urxot42jfazwnjlz@skbuf>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-2-maxime.chevallier@bootlin.com>
In-Reply-To: <20220514150656.122108-2-maxime.chevallier@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4ec06c6-d558-48a7-feb2-08da35ea9086
x-ms-traffictypediagnostic: AM6PR04MB6488:EE_
x-microsoft-antispam-prvs: <AM6PR04MB648840BC8D1AEF5A9CA8088CE0CD9@AM6PR04MB6488.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ppCndhX44dBphPDbFJgb8Ao28zwip3SXJGryR+0eoXalLZlAqrWa1gKYKh5ukUHSwGyvmBfrgBvwMP11kdHzW3E7fJhUyyCydAeBc69eVWt/9wh7ocEAOsdzzEvkEsyR78m7wG8BMJm8vL51MauCbn1nffUxYo67joNSWgHAVxtUrlEXgX6czMjCBAQTjmTqZAp77gS3Uz15vn3xCbtu72EesIOnXyxJcBqmx11QUpzNd1WZhSnyOp7MoUk4lgq6faesqGSTzkY+J35Ry+6/U0cDKL8U02MM1p603qdgNlkUQzYLDHfaxiyNg4vv6JyYY5mxpPVbCsVcfx0qqSkadCWmLNknr6kEZFIBWuIA2Eown1gBT5f9bWqMC1x3dY83BtExzCvR5eQ4KilDwycMDrVqIhcOzu/0Zh95pD5NWIZzCQpCLq4OYzNlzKZ6NeZOrqDB6jWmjr3RxJ8aqHnRtiOn2C4HFBD8WSu0RET0arChp2+BmcW08cUn1+RAQFKH3zLl1eHBVFduVepS2RV4q7yVBEchP544bVD599igpYaF+NVJN5CbjYX503l9c2XXOnx1EMlVfW+LqZRXKBmkkDsREshMmKoLL0LR1ZqnbfmMvlVN6hj6Gbc2EAOVRDd3jll3bhT/7RHe06GN5LEPd1/0cg1+F/BNJ15CcE+hP2PTfkMx70OcdX7jFCTf/SL48YClDxj2WCXXplAOWcptLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(122000001)(6512007)(26005)(71200400001)(9686003)(508600001)(33716001)(6486002)(6916009)(54906003)(86362001)(7416002)(6506007)(44832011)(38100700002)(8936002)(38070700005)(2906002)(64756008)(316002)(5660300002)(186003)(66476007)(66946007)(66556008)(83380400001)(76116006)(66446008)(4326008)(8676002)(1076003)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FMt78RxmT+lekX5l3fY3wpfIOBghkrz1bsRVpsggJiknZspcRjt0ImKG5f8/?=
 =?us-ascii?Q?vQKP/3/45yYyz2OjLKn6wXek4z2dCDREp3m/oCeCYW1Vv32Ta0FzJWMNS/5s?=
 =?us-ascii?Q?pmWjCD61XJTJ7ytxdgnqGb5rbEwWMadntO4Fdyi1u/OVVDKYQV9YQgRVkErw?=
 =?us-ascii?Q?qPAoLbVAgBApqF9x6Rb9ff5Sa6eLxGEzD9aBHy3c7JtVknmQGnRaNjBoAVau?=
 =?us-ascii?Q?eA2mWNvBXxpnh5JDk7u05Q3LqBZ92EVS2g8vGcPxfVxPZJI5rZJ5RqnlQTwF?=
 =?us-ascii?Q?AxHXpWfAlGMprUUSPL+tFcR91oHJYqv4JI02OWbRxl4jcExLvXcIGXY43ggH?=
 =?us-ascii?Q?aNrhfRuIVURXkVJVwUK5Qt0TSw+1Qn4DNi88tAZmca1/DnefET2qH2QWfvGS?=
 =?us-ascii?Q?j5eNI+xR9OpW3qvBIDqxxOymaQkV3tWtlmDOCxHRhp52WaUlst0lDGtGJqk9?=
 =?us-ascii?Q?u/tpZUy4FT0XAcqRPszv4VhZBWK+yT/pHgq6msVNZOpe2aM9+ySswfs53rIb?=
 =?us-ascii?Q?Jhpyea/gg5O6WlIQocwTevwHk/BhD91HTgvbqOpGjJfFMIwCZuCOt+2ONNGq?=
 =?us-ascii?Q?mE11OJ/7PJfpjXINpXSGrFB90Ycocwgg7z1CNw37c4P3/W4MgAxJA98hguG0?=
 =?us-ascii?Q?L6hCileIvcZVUdLGFhSo/eQ6Kzk9oKGUiu1Jr88RkfsT32f6JKZr4SYeNDW1?=
 =?us-ascii?Q?0YnRYh0T6f1gHIgSaEOF0cCKXQBh9q/1R2KD4Se/hR7hNmIk0cd8aOnr/Tuj?=
 =?us-ascii?Q?ZusTKF3q0Sg6ZrxPaypYFgVa4DbM0NQLfDp2PRHitQMsWedlorWwk3ubZ77c?=
 =?us-ascii?Q?4CLQ1bhuqyYiLrhXS9cGk3CIHycYBmTaHQUfzVuBDIHc+vI0vqKGDiL8PH4r?=
 =?us-ascii?Q?ZpDcs2hJL1j0hX7ApDmqaL1QNnjDCFs4G3eqhIcnyNlXTuO7j8JEpzc5nYKK?=
 =?us-ascii?Q?cgZL2kkxopMsXVrq8fLQV8MIKDEHGBH6RwCpzcO18igTyyxAAxISzscxdtiH?=
 =?us-ascii?Q?gdznVqzMk3XXXaqQs4XRVSr9OGSUF1xqXpz9dbOz5DfXJKVvT780ykxDpigq?=
 =?us-ascii?Q?KwMCfWAQKoKMSxq6QiieMWZGOEx70TqB3wA53zkp8in03cdSimYJdpvxymVH?=
 =?us-ascii?Q?8iHfl5+SZovjGCpbgiaN3C6HnlM+6QAVGr8d5OODD9kUysP2vRI8pluMSfyJ?=
 =?us-ascii?Q?VDtODPxYgJ+gf3DhNGSUC/bHAxYLG5+XL/mXgpm5c8oob++45IkH7fy8wStc?=
 =?us-ascii?Q?tkvft3Z7BUiwKTPIgGwybR0KbHaVx4QmByMaPVOa2F2AynIMRlkkVKiEbyVN?=
 =?us-ascii?Q?FcnDoZoOMeMpIfTTt9SxZTUHWQkKzGKUhSqdJ3Ph03utA2rp+LTaXrJk1lQN?=
 =?us-ascii?Q?doclc6d5650lkiEkspN/ouvS5BP/3Rne8GjH23Cw/03vIjBsZ3NrNyAF28jO?=
 =?us-ascii?Q?w8ZyqHpnJZrisq5ZQxNUs5oiP1+QC/K9fDnMvmyY3bZVis2Y1oBV81f9GuXa?=
 =?us-ascii?Q?nvJs8iqVmiOg1gUY3ZV5+VeEJWnpgVwMROOWmIAv9eGHoDSXqXUwB6WCe+z5?=
 =?us-ascii?Q?vQ1hU8Mbo1V+e/VgLlHq/LIu4R6v+SDvZk7igFxGOeAlz7KTaa6MZXjxEU7O?=
 =?us-ascii?Q?twBSXX9RzZoIp9qSjm6BKjT0sv8MSULXGe8FwxhdX+sAWBqs2/EPqDsHl98x?=
 =?us-ascii?Q?mW2CVZoc3MdxCk0AXxohNP/NFbG+hOn3GQEzSApWMzHxxpSPD8Kuxi/R6sqU?=
 =?us-ascii?Q?wYjJQwp9gd5z3PA7/3SMkaT+tvUqswg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B6BC28F2D0AFD944BF956A8027393EAB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4ec06c6-d558-48a7-feb2-08da35ea9086
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2022 20:44:38.9575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R8t/JYc3IFzz+MQ69/bPDLWbl9sZ81KgRcfGTUfySCWZsyeMZoZA52c1cF3rntpvmUHYWB5YDcux/VtA9UTaKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6488
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 14, 2022 at 05:06:52PM +0200, Maxime Chevallier wrote:
> +/* locking is handled by the caller */
> +static int ipqess_rx_buf_alloc_napi(struct ipqess_rx_ring *rx_ring)
> +{
> +	struct ipqess_buf *buf =3D &rx_ring->buf[rx_ring->head];
> +
> +	buf->skb =3D napi_alloc_skb(&rx_ring->napi_rx, IPQESS_RX_HEAD_BUFF_SIZE=
);
> +	if (!buf->skb)
> +		return -ENOMEM;
> +
> +	return ipqess_rx_buf_prepare(buf, rx_ring);
> +}
> +
> +static int ipqess_rx_buf_alloc(struct ipqess_rx_ring *rx_ring)
> +{
> +	struct ipqess_buf *buf =3D &rx_ring->buf[rx_ring->head];
> +
> +	buf->skb =3D netdev_alloc_skb_ip_align(rx_ring->ess->netdev,
> +					     IPQESS_RX_HEAD_BUFF_SIZE);
> +
> +	if (!buf->skb)
> +		return -ENOMEM;
> +
> +	return ipqess_rx_buf_prepare(buf, rx_ring);
> +}
> +
> +static void ipqess_refill_work(struct work_struct *work)
> +{
> +	struct ipqess_rx_ring_refill *rx_refill =3D container_of(work,
> +		struct ipqess_rx_ring_refill, refill_work);
> +	struct ipqess_rx_ring *rx_ring =3D rx_refill->rx_ring;
> +	int refill =3D 0;
> +
> +	/* don't let this loop by accident. */
> +	while (atomic_dec_and_test(&rx_ring->refill_count)) {
> +		napi_disable(&rx_ring->napi_rx);
> +		if (ipqess_rx_buf_alloc(rx_ring)) {
> +			refill++;
> +			dev_dbg(rx_ring->ppdev,
> +				"Not all buffers were reallocated");
> +		}
> +		napi_enable(&rx_ring->napi_rx);
> +	}
> +
> +	if (atomic_add_return(refill, &rx_ring->refill_count))
> +		schedule_work(&rx_refill->refill_work);
> +}
> +
> +static int ipqess_rx_poll(struct ipqess_rx_ring *rx_ring, int budget)
> +{

> +	while (done < budget) {

> +		num_desc +=3D atomic_xchg(&rx_ring->refill_count, 0);
> +		while (num_desc) {
> +			if (ipqess_rx_buf_alloc_napi(rx_ring)) {
> +				num_desc =3D atomic_add_return(num_desc,
> +							     &rx_ring->refill_count);
> +				if (num_desc >=3D ((4 * IPQESS_RX_RING_SIZE + 6) / 7))

DIV_ROUND_UP(IPQESS_RX_RING_SIZE * 4, 7)
Also, why this number?

> +					schedule_work(&rx_ring->ess->rx_refill[rx_ring->ring_id].refill_wor=
k);
> +				break;
> +			}
> +			num_desc--;
> +		}
> +	}
> +
> +	ipqess_w32(rx_ring->ess, IPQESS_REG_RX_SW_CONS_IDX_Q(rx_ring->idx),
> +		   rx_ring_tail);
> +	rx_ring->tail =3D rx_ring_tail;
> +
> +	return done;
> +}

> +static void ipqess_rx_ring_free(struct ipqess *ess)
> +{
> +	int i;
> +
> +	for (i =3D 0; i < IPQESS_NETDEV_QUEUES; i++) {
> +		int j;
> +
> +		atomic_set(&ess->rx_ring[i].refill_count, 0);
> +		cancel_work_sync(&ess->rx_refill[i].refill_work);

When refill_work is currently scheduled and executing the while loop,
will refill_count underflow due to the possibility of calling
atomic_dec_and_test(0)?

> +
> +		for (j =3D 0; j < IPQESS_RX_RING_SIZE; j++) {
> +			dma_unmap_single(&ess->pdev->dev,
> +					 ess->rx_ring[i].buf[j].dma,
> +					 ess->rx_ring[i].buf[j].length,
> +					 DMA_FROM_DEVICE);
> +			dev_kfree_skb_any(ess->rx_ring[i].buf[j].skb);
> +		}
> +	}
> +}=
