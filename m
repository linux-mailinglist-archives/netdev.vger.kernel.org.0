Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE525517776
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 21:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383663AbiEBTe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 15:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380401AbiEBTeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 15:34:25 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2066.outbound.protection.outlook.com [40.107.92.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC0A62CE
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 12:30:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+LWpYV5S7bEStFUUJgG8VGk7FupgPlVuaZZsuTKIVEXSKXh/L9jg2m97YI4U9qlpOD8J4/Oepw/1rzLUBfxW2gRjjNAii18+YrSJ4mhEjnxvQV6swxb9jO2diPgVxEQcWqNBdz35j8N8Msc737vAznbWUfTg3uYiU8nTI4CqC1ez5smKaPI1qSvmOpMiCQst4bxOXZRRx0mqGxrTECF/yYD8MtIBZW1B+clc1q96Aq8zMX6mQyJTT3Ugv3h1kvd5/k6L/A44l7kIMiT3I6wGnUqhUgA7DoLJAB0XRZBE+FwWMKEHPC/5QRpRRevUmRgFWF5RzRch952cKrH7Z68/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlxthkIQ8AMvawXNj9OmkoYCOyB8We4jU5BXpX73vKc=;
 b=aexoFfUhRdF/gc+U/sKB92bGucywuOrMMCIldFiuq8UD2zjDvWfrURYjtvv6cYGghvgSwdi/cG2PgWvMUDCpnxSNtekHmOX4qfEm0hdXkIRfvuUaPHkezBNo+YYSxoNlp1fsxwzrzDblX4A6/CQQCzlD3UwjABoCeCSnLZ5P6EoynNB+McC09GI0nTTMagZX8mjl/3c4m/7spohwZzUSQGsuFtyxLOimlsYvkaelPLir1MUYb4UdepeEGhdSkKA1btNV6BxVt1m7kJy2KBHzADmzddxXBHb5HOLSYHTZMoNQwuWsFAkoFX6Scv5UacQKH2aDUJlLxbQH1enFC54gqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AlxthkIQ8AMvawXNj9OmkoYCOyB8We4jU5BXpX73vKc=;
 b=s/Jns7+A8P/58veNT+I7J1dqBIYq410AhJ0YeI6JUGfn8raJu298HqqflbQ3VMEs9TFJ480BtbVPBygVD517u5FFlbsuoQ9qXnORWSqAS8c7SZMDGBdDI/AfoAP328nSmES6mltdU4y+wb2bJzGRPpUVfh46Cwv/w7YUY/T7xXc=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by DM5PR02MB2681.namprd02.prod.outlook.com (2603:10b6:3:10b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.17; Mon, 2 May
 2022 19:30:52 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::94f0:32be:367b:1798%6]) with mapi id 15.20.5186.028; Mon, 2 May 2022
 19:30:51 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Robert Hancock <robert.hancock@calian.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Michal Simek <michals@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Harini Katakam <harinik@xilinx.com>
Subject: RE: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Topic: [PATCH net-next] net: axienet: Use NAPI for TX completion path
Thread-Index: AQHYXBiXQ4HEYWr9E0iASNxJEYHZsa0LuqhA
Date:   Mon, 2 May 2022 19:30:51 +0000
Message-ID: <SA1PR02MB856018755A47967B5842A4C4C7C19@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <20220429222835.3641895-1-robert.hancock@calian.com>
In-Reply-To: <20220429222835.3641895-1-robert.hancock@calian.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1b43538a-d3aa-4279-da19-08da2c7244b2
x-ms-traffictypediagnostic: DM5PR02MB2681:EE_
x-microsoft-antispam-prvs: <DM5PR02MB2681E4F7BC2AFCF8F5649145C7C19@DM5PR02MB2681.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7HJ4EqWK40gpQI3AquZ8EMwugLajnOUDoiEZNs8SNxIZdkgI9K2nO4W+wv9XBPW5EkKPxvEcQeWseN5rBCyLGqg/zvsj4VjjJ7cwcIk9bvHcCFKUgcZ94GD4BzSmBgClEgYrlY19QqdxImDDeoSOS31tvnEGutsQJL7lLPXGDQC3S44pABUicX+5mcDunZxQcRIUj9o042YEm6mHiX7COBsfZ8WSlM0DoeO+9Ze369yNIXQ1evUs034x1OYiLiyVb+34+ptlp8Nq6kCUnFtHJSvtlDB/EqIoB8hwtVSMPMGgNtXfgllyYfeJEx3Lsex6wjsc7lSN4vkarzzAntTC5aaaVKXw2uqMjM7Tts5f7oOj3dgTjvTok4gIaJ4gqd0YtgA1erwZfyi4qfTpA0O5Z7aOMiVGPq9LOoMjPPPX/ySyotdBCfGUCSBNa3eGDLtaDwh4X1FbSv14GqSLURjlKlzr1yqLOrtfx14w8hRVj2dwjYkcsdgW1ZYmVQpr1miEf5PUrh7wuNtimakWklxcbxx3NdKikmlz98pgjtRTR5j0Nq+0JpcfM5k0ejQeo8JGeJN5yQmc/DGJ4OXZ6yvjdBa47u9htvcewGpz9YewI1KjhELljyJ4Na+tFAyCuby5yfD28uvfpI6NjQ8tCPkVmNm2RNr1J+5j5vynOdaCJzzVIxuyHl+h0p6TtPvU5B+7iXNv2VqnFfhr9lHeYDVVBID/AA7LnzEKBZ5p17e6GvA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(2906002)(64756008)(86362001)(66476007)(66446008)(66556008)(66946007)(52536014)(71200400001)(316002)(8936002)(33656002)(5660300002)(122000001)(38070700005)(38100700002)(76116006)(508600001)(54906003)(110136005)(83380400001)(186003)(6506007)(9686003)(107886003)(55016003)(53546011)(7696005)(375104004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CONZzYiT4KGMmEfpMwWHPqqIZYziB3pS4E0q4azraI5OD4VlMmPMi/06DCaV?=
 =?us-ascii?Q?pzxx312/1St4plbluurvdBBst20GeRwPc9bDsw71KwPzCNthR3ZmFK2iMB9L?=
 =?us-ascii?Q?A+pMTM8wQa8oWY/yBdYr7/ICzyGPoqSexSat+tKstau2T62pMoA55joP2vTH?=
 =?us-ascii?Q?2LdYQkKvRom65C4+uT1Fm0Y8wUtZ5SpknetGSgqihDBP4gLGYHOVi3T31or9?=
 =?us-ascii?Q?vIN0BGHTgso7+g8bf6+PR3U35/aCG1TyZSgrFvHujs7iFs80ivxo6AD6MmeN?=
 =?us-ascii?Q?ZxVUe/DEOLtjwbcJ0CV0ldfuCzrBO/vIJPJlc0biPXKk/3hJmrHOh0fzkwLX?=
 =?us-ascii?Q?InAeiWMUoXvOJ1oPGQ9gbDICNfodkvsiEoCkUYcobvysvrVc4sK4zFI8ej1e?=
 =?us-ascii?Q?OxpkHf4w1mu4dcWxpxyps1Vsdz7YwE7G998r4fgOjm/7hagf141XDfFpdTBV?=
 =?us-ascii?Q?3Zg99/ZrDVySnm9u9AHJBxh5+LH0NCqeY8HjLUSVB0gHTQCenkJ9y4Vfz8Is?=
 =?us-ascii?Q?dZnX9ceiNciK2J4oFzSNWFLjWOV/97DJXWdhFpWmGc02bQi1HkwzmqiBresN?=
 =?us-ascii?Q?zoU6Ci/APDPye4MljH+JN7ODLRqXsQjuY+QOb+pjIp83vVO7hztqKrg3/Qxs?=
 =?us-ascii?Q?n5P2+NJh2ijnnL3L3TVwo0qD1J07VnjJmPcjNfBrBFpSa5fVl/6qTpFZ1aBv?=
 =?us-ascii?Q?huC6QTzd8JBUje3ql9J9i/+a+sfWmytI+Rz6Ic6tPWs74VYtPC+kOD6CpG6G?=
 =?us-ascii?Q?IHq8rKjSFH4eTY57zahp8eiI3dY6AO/AnBCGvP2x29b6WwCeRf4CashCbCQs?=
 =?us-ascii?Q?D7pV1UWEXb9NiTO8ucK4Fkg/Xe0L9AtGMFqSDPYoDKj/LA6odUV2hYClLjQB?=
 =?us-ascii?Q?Go8CT28V24j++VE7xGOxika1afU118N+obMqFDHkyQrbKMs049O9gui0pnhl?=
 =?us-ascii?Q?bSoUmKyx4/hGSpKedQJArh+WxtWhgj01IOuGQxJpWzU4NffMb0zPmsJDq9+C?=
 =?us-ascii?Q?tyIecOLCGmgxqeW0Gbic83BPHbm/6sapgEZ2QF2CtktHBZkAPT2tz+nWOVk5?=
 =?us-ascii?Q?Ltjt26mOEBFf/6P9yn/0CNP7FvO3GPmppPpLXfaO5bV6ReDWXkNmshFFGG3k?=
 =?us-ascii?Q?n8ICpdbw1Yb5n/W5C/Kiwf5hzM97+spXVvx81rDprpUkzCeAdPjsx5XsHbN+?=
 =?us-ascii?Q?JPf4kU9cJttb8bOlj6JX5TbjjLMQVyhSshhG04N9o+tCsQtlg5kGnSi5K9Wx?=
 =?us-ascii?Q?HhM5PxTyehjUiRvQA25y3tE6u7ykQpLbaVhxkJ8z04AB7S3m91MJ0hprsR3X?=
 =?us-ascii?Q?+CKL4RP4iI/EehM2BfEnBFv2IC6qC24+HOmZq48q6yXLlIGiIAuj20CTAsnN?=
 =?us-ascii?Q?yTVm/KhmwAeMclUwt0FDKcXavnQhiGQp+MvZik5u9/QDUcepHumFSo9Tq8Tr?=
 =?us-ascii?Q?O/DAPqCMny1GDk9ngrIHYxDNoBgfz9WPoEMjVzG7ONk7tp9Q0Ouk5zIatjE5?=
 =?us-ascii?Q?oUHyM7IhRK1AnT6L6r809KJTZEChnJf5mYUG57l9kIEu+yTvSxNe6AzyTD6u?=
 =?us-ascii?Q?hKLfCcDRvUzErAXHIXNxuyycpad7vrdMjm1NYUbZkaep5CZ6PBK3wd2+A3GR?=
 =?us-ascii?Q?LDJs/RO2zEzril8pzxHvPJ3XMqli0MAFHCxh7Wls6QYBZRsnXqrjbhT+2cYg?=
 =?us-ascii?Q?mEX+mEEX5+0JWXlP01LnFcICmdjuENJTFd7i32TQi8ZkinJ8cwI/qEnHrTjl?=
 =?us-ascii?Q?j295CszGnrIrV9b+jFO+O9A335ziEhOJhkSSx0U4gpSIM/plQnpVDFHR+p+D?=
x-ms-exchange-antispam-messagedata-1: Rs8vSIJZQG3c0g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b43538a-d3aa-4279-da19-08da2c7244b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 19:30:51.6343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sHqBQauuWUhTfSvTWQRcMR4EKZD0hKj4pwsDwccmMsFG+7qkSf9LGV/JEduzk0b1rUNjYzgps6WDF1WmGY0kaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR02MB2681
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Robert Hancock <robert.hancock@calian.com>
> Sent: Saturday, April 30, 2022 3:59 AM
> To: netdev@vger.kernel.org
> Cc: Radhey Shyam Pandey <radheys@xilinx.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; Michal Simek
> <michals@xilinx.com>; linux-arm-kernel@lists.infradead.org; Robert Hancoc=
k
> <robert.hancock@calian.com>
> Subject: [PATCH net-next] net: axienet: Use NAPI for TX completion path
>=20
> This driver was using the TX IRQ handler to perform all TX completion
> tasks. Under heavy TX network load, this can cause significant irqs-off
> latencies (found to be in the hundreds of microseconds using ftrace).
> This can cause other issues, such as overrunning serial UART FIFOs when
> using high baud rates with limited UART FIFO sizes.
>=20
> Switch to using the NAPI poll handler to perform the TX completion work
> to get this out of hard IRQ context and avoid the IRQ latency impact.

Thanks for the patch. I assume for simulating heavy network load we
are using netperf/iperf. Do we have some details on the benchmark
before and after adding TX NAPI? I want to see the impact on
throughput.

>=20
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  |  2 +
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 56 ++++++++++++-------
>  2 files changed, 37 insertions(+), 21 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index d5c1e5c4a508..6e58d034fe90 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -397,6 +397,7 @@ struct axidma_bd {
>   * @regs:	Base address for the axienet_local device address space
>   * @dma_regs:	Base address for the axidma device address space
>   * @rx_dma_cr:  Nominal content of RX DMA control register
> + * @tx_dma_cr:  Nominal content of TX DMA control register
>   * @dma_err_task: Work structure to process Axi DMA errors
>   * @tx_irq:	Axidma TX IRQ number
>   * @rx_irq:	Axidma RX IRQ number
> @@ -454,6 +455,7 @@ struct axienet_local {
>  	void __iomem *dma_regs;
>=20
>  	u32 rx_dma_cr;
> +	u32 tx_dma_cr;
>=20
>  	struct work_struct dma_err_task;
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index d6fc3f7acdf0..a52e616275e4 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -254,8 +254,6 @@ static u32 axienet_usec_to_timer(struct axienet_local
> *lp, u32 coalesce_usec)
>   */
>  static void axienet_dma_start(struct axienet_local *lp)
>  {
> -	u32 tx_cr;
> -
>  	/* Start updating the Rx channel control register */
>  	lp->rx_dma_cr =3D (lp->coalesce_count_rx <<
> XAXIDMA_COALESCE_SHIFT) |
>  			XAXIDMA_IRQ_IOC_MASK |
> XAXIDMA_IRQ_ERROR_MASK;
> @@ -269,16 +267,16 @@ static void axienet_dma_start(struct axienet_local
> *lp)
>  	axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp->rx_dma_cr);
>=20
>  	/* Start updating the Tx channel control register */
> -	tx_cr =3D (lp->coalesce_count_tx << XAXIDMA_COALESCE_SHIFT) |
> -		XAXIDMA_IRQ_IOC_MASK | XAXIDMA_IRQ_ERROR_MASK;
> +	lp->tx_dma_cr =3D (lp->coalesce_count_tx <<
> XAXIDMA_COALESCE_SHIFT) |
> +			XAXIDMA_IRQ_IOC_MASK |
> XAXIDMA_IRQ_ERROR_MASK;
>  	/* Only set interrupt delay timer if not generating an interrupt on
>  	 * the first TX packet. Otherwise leave at 0 to disable delay interrupt=
.
>  	 */
>  	if (lp->coalesce_count_tx > 1)
> -		tx_cr |=3D (axienet_usec_to_timer(lp, lp->coalesce_usec_tx)
> -				<< XAXIDMA_DELAY_SHIFT) |
> -			 XAXIDMA_IRQ_DELAY_MASK;
> -	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
> +		lp->tx_dma_cr |=3D (axienet_usec_to_timer(lp, lp-
> >coalesce_usec_tx)
> +					<< XAXIDMA_DELAY_SHIFT) |
> +				 XAXIDMA_IRQ_DELAY_MASK;
> +	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
>=20
>  	/* Populate the tail pointer and bring the Rx Axi DMA engine out of
>  	 * halted state. This will make the Rx side ready for reception.
> @@ -294,8 +292,8 @@ static void axienet_dma_start(struct axienet_local *l=
p)
>  	 * tail pointer register that the Tx channel will start transmitting.
>  	 */
>  	axienet_dma_out_addr(lp, XAXIDMA_TX_CDESC_OFFSET, lp-
> >tx_bd_p);
> -	tx_cr |=3D XAXIDMA_CR_RUNSTOP_MASK;
> -	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, tx_cr);
> +	lp->tx_dma_cr |=3D XAXIDMA_CR_RUNSTOP_MASK;
> +	axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp->tx_dma_cr);
>  }
>=20
>  /**
> @@ -671,13 +669,14 @@ static int axienet_device_reset(struct net_device
> *ndev)
>   * @nr_bds:	Number of descriptors to clean up, can be -1 if unknown.
>   * @sizep:	Pointer to a u32 filled with the total sum of all bytes
>   * 		in all cleaned-up descriptors. Ignored if NULL.
> + * @budget:	NAPI budget (use 0 when not called from NAPI poll)
>   *
>   * Would either be called after a successful transmit operation, or afte=
r
>   * there was an error when setting up the chain.
>   * Returns the number of descriptors handled.
>   */
>  static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
> -				 int nr_bds, u32 *sizep)
> +				 int nr_bds, u32 *sizep, int budget)
>  {
>  	struct axienet_local *lp =3D netdev_priv(ndev);
>  	struct axidma_bd *cur_p;
> @@ -707,7 +706,7 @@ static int axienet_free_tx_chain(struct net_device
> *ndev, u32 first_bd,
>  				 DMA_TO_DEVICE);
>=20
>  		if (cur_p->skb && (status &
> XAXIDMA_BD_STS_COMPLETE_MASK))
> -			dev_consume_skb_irq(cur_p->skb);
> +			napi_consume_skb(cur_p->skb, budget);
>=20
>  		cur_p->app0 =3D 0;
>  		cur_p->app1 =3D 0;
> @@ -756,20 +755,24 @@ static inline int axienet_check_tx_bd_space(struct
> axienet_local *lp,
>   * axienet_start_xmit_done - Invoked once a transmit is completed by the
>   * Axi DMA Tx channel.
>   * @ndev:	Pointer to the net_device structure
> + * @budget:	NAPI budget
>   *
> - * This function is invoked from the Axi DMA Tx isr to notify the comple=
tion
> + * This function is invoked from the NAPI processing to notify the compl=
etion
>   * of transmit operation. It clears fields in the corresponding Tx BDs a=
nd
>   * unmaps the corresponding buffer so that CPU can regain ownership of t=
he
>   * buffer. It finally invokes "netif_wake_queue" to restart transmission=
 if
>   * required.
>   */
> -static void axienet_start_xmit_done(struct net_device *ndev)
> +static void axienet_start_xmit_done(struct net_device *ndev, int budget)
>  {
>  	struct axienet_local *lp =3D netdev_priv(ndev);
>  	u32 packets =3D 0;
>  	u32 size =3D 0;
>=20
> -	packets =3D axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size);
> +	packets =3D axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size, budget=
);
> +
> +	if (!packets)
> +		return;
>=20
>  	lp->tx_bd_ci +=3D packets;
>  	if (lp->tx_bd_ci >=3D lp->tx_bd_num)
> @@ -865,7 +868,7 @@ axienet_start_xmit(struct sk_buff *skb, struct
> net_device *ndev)
>  				netdev_err(ndev, "TX DMA mapping error\n");
>  			ndev->stats.tx_dropped++;
>  			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
> -					      NULL);
> +					      NULL, 0);
>  			lp->tx_bd_tail =3D orig_tail_ptr;
>=20
>  			return NETDEV_TX_OK;
> @@ -899,9 +902,9 @@ axienet_start_xmit(struct sk_buff *skb, struct
> net_device *ndev)
>  }
>=20
>  /**
> - * axienet_poll - Triggered by RX ISR to complete the received BD proces=
sing.
> + * axienet_poll - Triggered by RX/TX ISR to complete the BD processing.
>   * @napi:	Pointer to NAPI structure.
> - * @budget:	Max number of packets to process.
> + * @budget:	Max number of RX packets to process.
>   *
>   * Return: Number of RX packets processed.
>   */
> @@ -916,6 +919,8 @@ static int axienet_poll(struct napi_struct *napi, int
> budget)
>  	struct sk_buff *skb, *new_skb;
>  	struct axienet_local *lp =3D container_of(napi, struct axienet_local,
> napi);
>=20
> +	axienet_start_xmit_done(lp->ndev, budget);
> +
>  	cur_p =3D &lp->rx_bd_v[lp->rx_bd_ci];
>=20
>  	while (packets < budget && (cur_p->status &
> XAXIDMA_BD_STS_COMPLETE_MASK)) {
> @@ -1001,11 +1006,12 @@ static int axienet_poll(struct napi_struct *napi,=
 int
> budget)
>  		axienet_dma_out_addr(lp, XAXIDMA_RX_TDESC_OFFSET,
> tail_p);
>=20
>  	if (packets < budget && napi_complete_done(napi, packets)) {
> -		/* Re-enable RX completion interrupts. This should
> -		 * cause an immediate interrupt if any RX packets are
> +		/* Re-enable RX/TX completion interrupts. This should
> +		 * cause an immediate interrupt if any RX/TX packets are
>  		 * already pending.
>  		 */
>  		axienet_dma_out32(lp, XAXIDMA_RX_CR_OFFSET, lp-
> >rx_dma_cr);
> +		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, lp-
> >tx_dma_cr);
>  	}
>  	return packets;
>  }
> @@ -1040,7 +1046,15 @@ static irqreturn_t axienet_tx_irq(int irq, void
> *_ndev)
>  			   (lp->tx_bd_v[lp->tx_bd_ci]).phys);
>  		schedule_work(&lp->dma_err_task);
>  	} else {
> -		axienet_start_xmit_done(lp->ndev);
> +		/* Disable further TX completion interrupts and schedule
> +		 * NAPI to handle the completions.
> +		 */
> +		u32 cr =3D lp->tx_dma_cr;
> +
> +		cr &=3D ~(XAXIDMA_IRQ_IOC_MASK |
> XAXIDMA_IRQ_DELAY_MASK);
> +		axienet_dma_out32(lp, XAXIDMA_TX_CR_OFFSET, cr);
> +
> +		napi_schedule(&lp->napi);
>  	}
>=20
>  	return IRQ_HANDLED;
> --
> 2.31.1

