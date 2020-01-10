Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 539CF1375CA
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 19:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728698AbgAJSFC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 13:05:02 -0500
Received: from mail-eopbgr700066.outbound.protection.outlook.com ([40.107.70.66]:42785
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727856AbgAJSFA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 13:05:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsnpDjrUkxAqlYyYsOz1BoqTfgNOc9V2OsVpuTqcEhcBaK+syAmErDBesOe7pfsi5Zz1L6q6ADuve/yhdeoBmfKPxaI7p6Umcq9lIXuI/IGoctKvOnzyhU6eLFdDaTPhhBw2oz+WHJAkHOgR+Y5g8Az3Z5UEJbmMk4vEDsVNyuOAma6SgkM7Bebi+8aWKaoZgq3Kth1fEPQl0hGs9cgIxM/ViBs4HcpBZ7InyFWTS7jM7Q3RWkSDSFqMJyxdC/jvPF6nL0WhgAD2pdnbVCn8zY4eBwGCaR9OexhWAWx8u1mWV1M6z+FYO5tgHWnbuZp4sLbCdBofRyR8b8Sm9Bv3Og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yPPa3JLLa4I/H4Qu9wp7czG/Kk1JExm4W1OpBFiIxE=;
 b=Z2QOyfMJb4LwdtPDjDhRZtTyQKDTLLTJ/F+uYnDG3xkE3Io4uG/87PMXGl6vecs6xGFhgLMF4xOlx7WJqeWAGk5c8hdaws+yf7oJ2fImWNSAFpzUaqy+6T3qmL9S0rldpMjSS8DUzwSrsVv94Ze8nxAv2UnS+RmqzBBBHF2ayomfKIc23DZujp/Rqkbacm3BiBJNs1JqI+3sh6KqCVt9cwajd3+UGiYn9QHC5lg+ychyEgkS+PZRRPi7Z0tpyrTrgSnvxuQgKmkMoWHbEOggotjQKAtFOF7gc3pS2ORff2iNraB4n0Ylao3F7MlxPwNwODDHG2D0STn9lr/pGw3TqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yPPa3JLLa4I/H4Qu9wp7czG/Kk1JExm4W1OpBFiIxE=;
 b=UFCJfzYrVHKXX1yvYlHRqVh3ccVYk9HrCmhMGYIHHPCaG/hFZPFnkxNUOkUj+DEQD8OKvVW3wIzYWZa4IhHY3ELmnn3UIKQnAiO0vVii43eynTwjyxsBpkWaaO9T04mcth7CB5qweJlZ0fV/ah7T7kmw5ecsgxjImTG34HkEJMk=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6760.namprd02.prod.outlook.com (10.141.156.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.9; Fri, 10 Jan 2020 18:04:57 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.013; Fri, 10 Jan 2020
 18:04:57 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 05/14] net: axienet: Factor out TX descriptor chain
 cleanup
Thread-Topic: [PATCH 05/14] net: axienet: Factor out TX descriptor chain
 cleanup
Thread-Index: AQHVx6y4/M+QpndI/06Wqu2OHMXL/6fkL3TQ
Date:   Fri, 10 Jan 2020 18:04:57 +0000
Message-ID: <CH2PR02MB70003A0D500B9A78697FC311C7380@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-6-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-6-andre.przywara@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [183.83.136.244]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c607d19e-82b1-44ec-d02f-08d795f79a35
x-ms-traffictypediagnostic: CH2PR02MB6760:|CH2PR02MB6760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6760AED6AC77B252D5C2A215C7380@CH2PR02MB6760.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(199004)(189003)(13464003)(54906003)(110136005)(26005)(8676002)(86362001)(81166006)(81156014)(186003)(66446008)(478600001)(7696005)(6506007)(2906002)(316002)(8936002)(53546011)(71200400001)(64756008)(66556008)(4326008)(52536014)(33656002)(55016002)(66476007)(5660300002)(76116006)(66946007)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6760;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t2enkk7V2Z05goohCRPryr2KrDs/VydFR8BmlxXpEKXVpVQp5qz8cxB+nKJTnd78KUIWGgIY8xyZfgvZKp/xG7kKA4r6GjIw+QvlkJ3vC4utNlhtr2WJ5QXePdYYLfGSGMgqSygYWPeYduqf/6DGJ+5Aq4LGWm1T7v2eoVzoJLSlhMC/ymwkCXGgRrgnRFqGZ1Y1JsWZNyJME95Zu3yPbH0QU/5rJvSnn+JxPlL7rjKTp2K66HpyzNjyMMO1uG2WuJFnF/tflYxjW3/VMBu7Jf5i0B1P5fWo7lexnBf9EctySbdbHj/6Ygl6peVzT2HfrdRaQ5TLPWawdA4oZDWSRWSB8fdpj6IiM9R0EJMLBCUB4Sk+SMDnWri1uU6i3+Wx3VKs4AqmaaZZTRcwcLEhn2whbnOVHRynAxRjW1FY3lGqLp/yK82EnxjfvjKivk1BZz13N+JeZnGZ7FvxC227fM8Zd7a6iUR85JFkINtjeQpr5JI4sOi3nqMnCJ46o7hm
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c607d19e-82b1-44ec-d02f-08d795f79a35
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 18:04:57.2056
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bYjkePUNeHIOFPlPuefjyac8pU+MWZcuPsz2hZHd7TA6JLH0ufwjpiLtOHcroi1XkEvnRvTjYoGnQwItyV6qCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andre Przywara <andre.przywara@arm.com>
> Sent: Friday, January 10, 2020 5:24 PM
> To: David S . Miller <davem@davemloft.net>; Radhey Shyam Pandey
> <radheys@xilinx.com>
> Cc: Michal Simek <michals@xilinx.com>; Robert Hancock
> <hancock@sedsystems.ca>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: [PATCH 05/14] net: axienet: Factor out TX descriptor chain clean=
up
>=20
> Factor out the code that cleans up a number of connected TX descriptors,
> as we will need it to properly roll back a failed _xmit() call.
> There are subtle differences between cleaning up a successfully sent
> chain (unknown number of involved descriptors, total data size needed)
> and a chain that was about to set up (number of descriptors known), so
> cater for those variations with some extra parameters.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 75 ++++++++++++-------
>  1 file changed, 50 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index ec5d01adc1d5..82abe2b0f16a 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -543,33 +543,37 @@ static int axienet_device_reset(struct net_device
> *ndev)
>  	return 0;
>  }
>=20
> -/**
> - * axienet_start_xmit_done - Invoked once a transmit is completed by the
> - * Axi DMA Tx channel.
> - * @ndev:	Pointer to the net_device structure
> - *
> - * This function is invoked from the Axi DMA Tx isr to notify the comple=
tion
> - * of transmit operation. It clears fields in the corresponding Tx BDs a=
nd
> - * unmaps the corresponding buffer so that CPU can regain ownership of
> the
> - * buffer. It finally invokes "netif_wake_queue" to restart transmission=
 if
> - * required.
> +/* Clean up a series of linked TX descriptors. Would either be called
> + * after a successful transmit operation, or after there was an error
> + * when setting up the chain.
> + * Returns the number of descriptors handled.
>   */
> -static void axienet_start_xmit_done(struct net_device *ndev)

To be consistent we can add the doxygen function description.
The rest looks good. Feel free to add:
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>

> +static int axienet_free_tx_chain(struct net_device *ndev, u32 first_bd,
> +				 int nr_bds, u32 *sizep)
>  {
> -	u32 size =3D 0;
> -	u32 packets =3D 0;
>  	struct axienet_local *lp =3D netdev_priv(ndev);
> +	int max_bds =3D (nr_bds !=3D -1) ? nr_bds : lp->tx_bd_num;
>  	struct axidma_bd *cur_p;
> -	unsigned int status =3D 0;
> +	unsigned int status;
> +	int i;
> +
> +	for (i =3D 0; i < max_bds; i++) {
> +		cur_p =3D &lp->tx_bd_v[(first_bd + i) % lp->tx_bd_num];
> +		status =3D cur_p->status;
> +
> +		/* If no number is given, clean up *all* descriptors that have
> +		 * been completed by the MAC.
> +		 */
> +		if (nr_bds =3D=3D -1 && !(status &
> XAXIDMA_BD_STS_COMPLETE_MASK))
> +			break;
>=20
> -	cur_p =3D &lp->tx_bd_v[lp->tx_bd_ci];
> -	status =3D cur_p->status;
> -	while (status & XAXIDMA_BD_STS_COMPLETE_MASK) {
>  		dma_unmap_single(ndev->dev.parent, cur_p->phys,
>  				(cur_p->cntrl &
> XAXIDMA_BD_CTRL_LENGTH_MASK),
>  				DMA_TO_DEVICE);
> -		if (cur_p->skb)
> +
> +		if (cur_p->skb && (status &
> XAXIDMA_BD_STS_COMPLETE_MASK))
>  			dev_consume_skb_irq(cur_p->skb);
> +
>  		cur_p->cntrl =3D 0;
>  		cur_p->app0 =3D 0;
>  		cur_p->app1 =3D 0;
> @@ -578,15 +582,36 @@ static void axienet_start_xmit_done(struct
> net_device *ndev)
>  		cur_p->status =3D 0;
>  		cur_p->skb =3D NULL;
>=20
> -		size +=3D status & XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
> -		packets++;
> -
> -		if (++lp->tx_bd_ci >=3D lp->tx_bd_num)
> -			lp->tx_bd_ci =3D 0;
> -		cur_p =3D &lp->tx_bd_v[lp->tx_bd_ci];
> -		status =3D cur_p->status;
> +		if (sizep)
> +			*sizep +=3D status &
> XAXIDMA_BD_STS_ACTUAL_LEN_MASK;
>  	}
>=20
> +	return i;
> +}
> +
> +/**
> + * axienet_start_xmit_done - Invoked once a transmit is completed by the
> + * Axi DMA Tx channel.
> + * @ndev:	Pointer to the net_device structure
> + *
> + * This function is invoked from the Axi DMA Tx isr to notify the comple=
tion
> + * of transmit operation. It clears fields in the corresponding Tx BDs a=
nd
> + * unmaps the corresponding buffer so that CPU can regain ownership of
> the
> + * buffer. It finally invokes "netif_wake_queue" to restart transmission=
 if
> + * required.
> + */
> +static void axienet_start_xmit_done(struct net_device *ndev)
> +{
> +	u32 size =3D 0;
> +	u32 packets =3D 0;
> +	struct axienet_local *lp =3D netdev_priv(ndev);
> +
> +	packets =3D axienet_free_tx_chain(ndev, lp->tx_bd_ci, -1, &size);
> +
> +	lp->tx_bd_ci +=3D packets;
> +	if (lp->tx_bd_ci >=3D lp->tx_bd_num)
> +		lp->tx_bd_ci -=3D lp->tx_bd_num;
> +
>  	ndev->stats.tx_packets +=3D packets;
>  	ndev->stats.tx_bytes +=3D size;
>=20
> --
> 2.17.1

