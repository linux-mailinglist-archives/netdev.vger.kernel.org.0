Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2064441C8
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 13:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhKCMqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 08:46:01 -0400
Received: from mail-eopbgr140042.outbound.protection.outlook.com ([40.107.14.42]:52781
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230304AbhKCMqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 08:46:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BR4DFSoyCeY0xpUHErlWi8uv2YRPS9JAddlcE3Xt9qPIX6oL2z+sUbqsxfU5Rm1OmWIUQySiTizu1rfbHOIY4cK+kDZl0kzZvzVKlququjefBn4u843vODPwqHz8niIUjyGRnUDO+TXpuLwFd/kRr+SYmQHIgUz79FlyxsQ038nvAoPpYd8k8AwL2nZr5xRd68a69AsWjPa7bdyn3O7ZLtuzlFtKvF+MUi2agUjrNj134QsZwaRDXkggmx2yEf00bVlimrtFMB0rwiw2gPsopVEOQ7to7uEeE40GF/jp7A0EUE9IF0cRHDYstjDzovoXrE0gnfLs/ntO6nwH/hW8Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qqXlm5W7PTNw+6E/k/OVqyeT8t3AHWRsQzym8I4zMjc=;
 b=eTHWdKKZz1h7D6r0GahqnTShLosNikkuOntAIwvtQsLUOucesObHSkVtoYTNU/c2HmbDXk3VndDURkV2/t76X7av1K5fx2apssbNlERpwgKmzgOU1aONB7S3eIfNvOpV8G4Kka6MCDgQFkOqPtIuKOse5Cz24SHR4IVtMOJHS4DrHFuDRSxHSHEmP5MVVGnBrpbFoDLO/z2NZfUb4e+pSFdtyRxeKk/CgXmdlQW1MX9Zuy9iUXjvCqmZWXvyG6Of/WDohds3rpTxmayXdkPm+dY0G4xWvap9hemsTrw0Q/VGeQ2UM2NvCLUwq9OH4jgSYKOk9AD8SIBUvAJZ4qQ5Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqXlm5W7PTNw+6E/k/OVqyeT8t3AHWRsQzym8I4zMjc=;
 b=XHn0mD9lpDgCTuXU45sbZ0jpExAqnWT54qM3E6fpNzEEHntioW6Gg6seNWsh1nCM3kKyuNTq79e1f6Mi9vShQuyHPzUtR3gUCRzlk7khq0oAMsDEv3TB/ZL5koCRNr9UxSiaEXmprBLBaln+ZBFnAXq3glqG6ydAxYPxdIL737g=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5135.eurprd04.prod.outlook.com (2603:10a6:803:62::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.18; Wed, 3 Nov
 2021 12:43:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 12:43:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 6/6] net: ocelot: add jumbo frame support for FDMA
Thread-Topic: [PATCH v2 6/6] net: ocelot: add jumbo frame support for FDMA
Thread-Index: AQHX0JQO6O94IOHXckmYdYvOxLwYAqvxv5mA
Date:   Wed, 3 Nov 2021 12:43:20 +0000
Message-ID: <20211103124319.e7th7khpsybs7zjd@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
 <20211103091943.3878621-7-clement.leger@bootlin.com>
In-Reply-To: <20211103091943.3878621-7-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b38dd26-8a52-4aef-c90e-08d99ec7844e
x-ms-traffictypediagnostic: VI1PR04MB5135:
x-microsoft-antispam-prvs: <VI1PR04MB51359D1EF60900B1BC4A2B88E08C9@VI1PR04MB5135.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1201;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wADENNe6se2EHoAmGkq7SKbJaBLuzY00rKPklkJ9/VNcagBpT8ky0hOXDkeKXuUzq7ijEu+MQQzxZX1pmF4nDnTUC20s1SdaQS/wt4+a4ZWYUL/zGEDwObEprGvGxklGci/xNAKve/vvsHKHlcsdTaTKexdEWTb0ZMy4EUSVYSAWsbBJYAeTIT0Hc1CoEiZXgb/uS3MAadLso31kI3Vxle8LRXQROwDZxY5hIY8gpavHz9+NdtK54lbTsdT6Swtv7NaWyKc8K52DOlfWQv7e8ym5UafOZ1UknYSo5d+hMXtn1RKzksy1cED9V/pp1ow+oVUyLy+QifETX92QILrwXGYF4lkDccZwuKpdfbM7TzYUdBwFCGl4r8L0pSdk7IPYfyE3yS9u7Y/OYEdxgJ68Ze4GWBWpWjCXi2ztMSMm0ygVp1tjK5yar3MGJeqsObR/MMUHqIKPadW3arns891QhgwWtZ73cRNB2jForuQ7PBcKYrN3v1iEa98B2FCZgYKBbvJa8gvm03pMziYYVocljqbE2UZD4mtmaiYbUrSKbb1lkbt1Gw0TQbgvasfHkx0QwbmdSqWO/VxHhs0YH4hVGCeZ9kiksJ4Z2ZlP44Ga1l8dAV4G8uPV9VHrtcHnbppCYCeIfCN61YUzN/K76f3hE2DmaiTeX/zWW4nH+zKFM5hsc3xkBvk86d9jto7AK4F6cBk4RowmUIx2gmQKGv2HaA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4326008)(44832011)(9686003)(6512007)(6916009)(316002)(5660300002)(1076003)(186003)(54906003)(6486002)(33716001)(91956017)(8936002)(122000001)(2906002)(66476007)(7416002)(508600001)(66574015)(64756008)(38070700005)(66556008)(6506007)(8676002)(38100700002)(26005)(66946007)(76116006)(86362001)(66446008)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?cruk+EXdXCmiIWxG869Yuw8A8XmFfARs/kAZSB5zrAAyj7ddldcJIZCWu9?=
 =?iso-8859-1?Q?dBmK8j7AVQXb1vZjqJwfgNmN2xTiWZTmlXYNEafjJy2JLHj/oAaOo8w2R1?=
 =?iso-8859-1?Q?sToDEBJukpAkswYqLuJH2kv89egA6Iz1HSR29z+DTZcyVcfEYnvtRG1Okj?=
 =?iso-8859-1?Q?gGBS0tUMghiwfijPd58Zyd4Q5P0PTWlAKiE+drWTDWxEEQJ6Oy4V+7L3Fo?=
 =?iso-8859-1?Q?jYIo3qMuONAo4bsPV/57qNx/IrCNwi6uYO/bmR5KUej8GB9KbnupqxcQBC?=
 =?iso-8859-1?Q?3jYM/ygcvKUeSnFff0pcrhGYBFId088sfUkd4fzYbSBZzsRZ+5NAF1vcRX?=
 =?iso-8859-1?Q?FTiRGHDIvZ27bCK6X9Ej7p14RUxV1Sv25Ruq0unfJCRiWviNvbg39GxRhc?=
 =?iso-8859-1?Q?kujnC+SmzDNQUut6SyPZXUqpwgrrg1eQYpnebcjlp+/vCjoE1JHZnDMDCw?=
 =?iso-8859-1?Q?EVWuIJxGcM4aLeMdM0d0gHOgvW8UsWs3cFUom1R39M97fwCjz0Ag26/hyi?=
 =?iso-8859-1?Q?XIWzTKqHILxlUp2vQlYutsOe/s0FmfG0dWWuvugp87k+65pneB0T0kF2Z6?=
 =?iso-8859-1?Q?i+X8WdU64m7I+6FlW72IGxBD+nWAr9RlvonUS8PLfmETlJjMiwYcgDJBCK?=
 =?iso-8859-1?Q?DP0myLwgiWjk/mznuVkzbIae0U4BPfLR24woEpNfXGCqC7d6+9U9K0GUYM?=
 =?iso-8859-1?Q?klXFZYVeI9YFTuax+8cxaJ3NjdyUjq1rM4wXlb7ZPqJ+iwWBQeWlqFL+z2?=
 =?iso-8859-1?Q?/YVK6r+BPTkEvkN96hqlZsOnDKP+tcwfZK/zZQIxm+Pw5M9zVRO9+OhJyG?=
 =?iso-8859-1?Q?m+jd+vWJDxm93dZX9iKqGiM9Sb39YA7oSog5N06iUlFKS6o0On4HXx7GdJ?=
 =?iso-8859-1?Q?kY6iOt9yQEo3iLQnqqlNKy6g+Bfn+edH3w2AWN+GslUEaFQESywBhqO3j3?=
 =?iso-8859-1?Q?FKnFW7/87f9XdYzv4Nk/vh9Bw4XEPhjEG6mIBB4akwtyl+fN6NlXtzJwhU?=
 =?iso-8859-1?Q?7NAWmMbB557f2ixbcpQSSqAFjEZoqFzkunPIkPq1YguYWluRiheTNrRnc/?=
 =?iso-8859-1?Q?wt4sVBF4b/2OML9YDItyVrnuMQQkt/AHtRpPLTT5BjZ6s+x0TZ27QqUX5x?=
 =?iso-8859-1?Q?d22O4qSNG2+ajTCUDKQTaq1LEj5fL4c4HxmvwI6swOA0VFZoQY3fAH7TYW?=
 =?iso-8859-1?Q?cHKuvIib+G2N0TDkVvaT6F5tWlmmYA1FxmxTUMYWNMmkkwSx/DGVZno1KI?=
 =?iso-8859-1?Q?nuA/v7i6+MfmKOLLSDQeEUIVTHjXjWLd9iOoNW4atYPg+o+19yZwumHJEA?=
 =?iso-8859-1?Q?xrRQbP2joDvC4+Prsfph3NyTTqctJb5F7aPFC64H8jYblznGaLoZr4fewt?=
 =?iso-8859-1?Q?2ddyp7XABmXOPBlGPMhm09Xr+bbyYbv5wSWZUpYBZM01E6SRay0Y2e13m8?=
 =?iso-8859-1?Q?6iZ2L9zLpDtcy2pzuQEwWs38hPrj/85iahQFUPlpY/UMA4zS1WTDQHYTHx?=
 =?iso-8859-1?Q?4LTSGJDDpM2yWZemEp/L30WT6Z5LDkuDfdrh4riy3lKdlannbVDu7RB2YL?=
 =?iso-8859-1?Q?1eqnEAYFOXeSJ0TRgVjrTP7vXbYOpwuEX9LY+7fQOwo05ZPsxHePps/v3F?=
 =?iso-8859-1?Q?ICfRZJm/dnq8aramEkrY902l8QmnacC9WcYAnZIqHtBOxOZOfQMAC/OgHT?=
 =?iso-8859-1?Q?K810CioZl+EVdhsdH0T9X9bCXwGRwbsc88RjzISc?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <A16CAB12C317E4449D144CB6850560DA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b38dd26-8a52-4aef-c90e-08d99ec7844e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 12:43:20.4132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5stsX60B9ObrR+RYC9vsS0kN4hLWYGMMFOfmJuGqLQarJ0DYamLvAmc5Agx7qOkWbidVBYrL3n6LIiSlNve4Fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5135
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 03, 2021 at 10:19:43AM +0100, Cl=E9ment L=E9ger wrote:
> When using the FDMA, using jumbo frames can lead to a large performance
> improvement. When changing the MTU, the RX buffer size must be
> increased to be large enough to receive jumbo frame. Since the FDMA is
> shared amongst all interfaces, all the ports must be down before
> changing the MTU. Buffers are sized to accept the maximum MTU supported
> by each port.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---

Instead of draining buffers and refilling with a different size, which
impacts the user experience, can you not just use scatter/gather RX
processing for frames larger than the fixed buffer size, like a normal
driver would?

>  drivers/net/ethernet/mscc/ocelot_fdma.c | 61 +++++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_fdma.h |  1 +
>  drivers/net/ethernet/mscc/ocelot_net.c  |  7 +++
>  3 files changed, 69 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.c b/drivers/net/ethern=
et/mscc/ocelot_fdma.c
> index d8cdf022bbee..bee1a310caa6 100644
> --- a/drivers/net/ethernet/mscc/ocelot_fdma.c
> +++ b/drivers/net/ethernet/mscc/ocelot_fdma.c
> @@ -530,6 +530,67 @@ static void fdma_free_skbs_list(struct ocelot_fdma *=
fdma,
>  	}
>  }
> =20
> +int ocelot_fdma_change_mtu(struct net_device *dev, int new_mtu)
> +{
> +	struct ocelot_port_private *priv =3D netdev_priv(dev);
> +	struct ocelot_port *port =3D &priv->port;
> +	struct ocelot *ocelot =3D port->ocelot;
> +	struct ocelot_fdma *fdma =3D ocelot->fdma;
> +	struct ocelot_fdma_dcb *dcb, *dcb_temp;
> +	struct list_head tmp =3D LIST_HEAD_INIT(tmp);
> +	size_t old_rx_buf_size =3D fdma->rx_buf_size;
> +	bool all_ports_down =3D true;
> +	u8 port_num;
> +
> +	/* The FDMA RX list is shared amongst all the port, get the max MTU fro=
m
> +	 * all of them
> +	 */
> +	for (port_num =3D 0; port_num < ocelot->num_phys_ports; port_num++) {
> +		port =3D ocelot->ports[port_num];
> +		if (!port)
> +			continue;
> +
> +		priv =3D container_of(port, struct ocelot_port_private, port);
> +
> +		if (READ_ONCE(priv->dev->mtu) > new_mtu)
> +			new_mtu =3D READ_ONCE(priv->dev->mtu);
> +
> +		/* All ports must be down to change the RX buffer length */
> +		if (netif_running(priv->dev))
> +			all_ports_down =3D false;
> +	}
> +
> +	fdma->rx_buf_size =3D fdma_rx_compute_buffer_size(new_mtu);
> +	if (fdma->rx_buf_size =3D=3D old_rx_buf_size)
> +		return 0;
> +
> +	if (!all_ports_down)
> +		return -EBUSY;
> +
> +	priv =3D netdev_priv(dev);
> +
> +	fdma_stop_channel(fdma, MSCC_FDMA_INJ_CHAN);
> +
> +	/* Discard all pending RX software and hardware descriptor */
> +	fdma_free_skbs_list(fdma, &fdma->rx_hw, DMA_FROM_DEVICE);
> +	fdma_free_skbs_list(fdma, &fdma->rx_sw, DMA_FROM_DEVICE);
> +
> +	/* Move all DCBs to a temporary list that will be injected in sw list *=
/
> +	if (!list_empty(&fdma->rx_hw))
> +		list_splice_tail_init(&fdma->rx_hw, &tmp);
> +	if (!list_empty(&fdma->rx_sw))
> +		list_splice_tail_init(&fdma->rx_sw, &tmp);
> +
> +	list_for_each_entry_safe(dcb, dcb_temp, &tmp, node) {
> +		list_del(&dcb->node);
> +		ocelot_fdma_rx_add_dcb_sw(fdma, dcb);
> +	}
> +
> +	ocelot_fdma_rx_refill(fdma);
> +
> +	return 0;
> +}
> +
>  static int fdma_init_tx(struct ocelot_fdma *fdma)
>  {
>  	int i;
> diff --git a/drivers/net/ethernet/mscc/ocelot_fdma.h b/drivers/net/ethern=
et/mscc/ocelot_fdma.h
> index 6c5c5872abf5..74514a0b291a 100644
> --- a/drivers/net/ethernet/mscc/ocelot_fdma.h
> +++ b/drivers/net/ethernet/mscc/ocelot_fdma.h
> @@ -55,5 +55,6 @@ int ocelot_fdma_start(struct ocelot_fdma *fdma);
>  int ocelot_fdma_stop(struct ocelot_fdma *fdma);
>  int ocelot_fdma_inject_frame(struct ocelot_fdma *fdma, int port, u32 rew=
_op,
>  			     struct sk_buff *skb, struct net_device *dev);
> +int ocelot_fdma_change_mtu(struct net_device *dev, int new_mtu);
> =20
>  #endif
> diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/etherne=
t/mscc/ocelot_net.c
> index 3971b810c5b4..d5e88d7b15c7 100644
> --- a/drivers/net/ethernet/mscc/ocelot_net.c
> +++ b/drivers/net/ethernet/mscc/ocelot_net.c
> @@ -492,6 +492,13 @@ static int ocelot_change_mtu(struct net_device *dev,=
 int new_mtu)
>  	struct ocelot_port_private *priv =3D netdev_priv(dev);
>  	struct ocelot_port *ocelot_port =3D &priv->port;
>  	struct ocelot *ocelot =3D ocelot_port->ocelot;
> +	int ret;
> +
> +	if (ocelot->fdma) {
> +		ret =3D ocelot_fdma_change_mtu(dev, new_mtu);
> +		if (ret)
> +			return ret;
> +	}
> =20
>  	ocelot_port_set_maxlen(ocelot, priv->chip_port, new_mtu);
>  	WRITE_ONCE(dev->mtu, new_mtu);
> --=20
> 2.33.0
>=
