Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3228A13AF80
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgANQfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:35:16 -0500
Received: from mail-co1nam11on2077.outbound.protection.outlook.com ([40.107.220.77]:26846
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726121AbgANQfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jan 2020 11:35:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=og/sJVTjWvfoUtFZP+cMVNGYtsMGzUPj4lrJidIFGNhRvdFy6Dr0JDAfs0W+UDKpE4VIVlRe0IILjvXm4gWLtAFKgbXGaWzxFSn0ECqwX9wnaxrjArutvID0wOAydpyKjZ5iTeL6FDmaLdcMmpkTayGbpqNDbYOlhiM4BIB3Oh/yb6X9qaRG9sxNIEW3+kG0dCEs+ZVbg4iSpBwzEoMLaRTXFY8pHP3ADKNrXlivX+bVWpIXzybXVynE/4P97FKiwgwF8e57H1wxs5iugfmkIhfOYa0n+EYFwQXKv1r468x3r4bhQUc0ZhIUFDLs/dqRe6tiMuqJix8WaM3bIYpp6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgz312am7MaRHYCNrNoXkNXLtsHLMC/XUJpgaiaVzpc=;
 b=TZp8kncARdo3pWYFsoMe2N2O02RAnjHCA7p5aAOSROon7RLZemf9qu1Wvo/D5NosiIZwgjOsTHtE+yre6OVnnBmH7oKCgl6MJwhQzjG/sRXjbo1F5/ENP5XS4OMVHhrPIcX5OpaGJERnQkqmiQoDk6uVTsoZ4FVWi1PjyqfM2V/T64cuR/55xH92Kmjopcmoj61jIg1KI+PJOIBRJ0ClFXCCmwb6GwlvusHFpHK0MToIc3OdExlkPHDLGheGtQgB3StRa94hqE0StIkemyv1MrPOF66iUg3g/MbMWaj7qAdtVI7XC9Pu2M4tSOTABb/926k0nRmKdxa7sqIc5GzR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pgz312am7MaRHYCNrNoXkNXLtsHLMC/XUJpgaiaVzpc=;
 b=YCUX91NGXsPKytaepPXaTEb4+WzPbruJ6Z9levuF8zQ6yeKT91FNS6wmr+Fa/lLJRalz7bZwu++QkWoV1WDXL3kXR92Rm63L0gced6IgvcgJj93sK/tg1SObWQAeegHGWzqoEH3SET+McglcfiowzGXDELGGlVg5ey5nKsjDJxk=
Received: from CH2PR02MB7000.namprd02.prod.outlook.com (20.180.9.216) by
 CH2PR02MB6392.namprd02.prod.outlook.com (52.132.231.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Tue, 14 Jan 2020 16:35:10 +0000
Received: from CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899]) by CH2PR02MB7000.namprd02.prod.outlook.com
 ([fe80::969:436f:b4b8:4899%7]) with mapi id 15.20.2623.015; Tue, 14 Jan 2020
 16:35:10 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andre Przywara <andre.przywara@arm.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Michal Simek <michals@xilinx.com>,
        Robert Hancock <hancock@sedsystems.ca>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 11/14] net: axienet: Upgrade descriptors to hold 64-bit
 addresses
Thread-Topic: [PATCH 11/14] net: axienet: Upgrade descriptors to hold 64-bit
 addresses
Thread-Index: AQHVx6y8LFLk+WjjxkeK+UfQtIoIvKfqW/hw
Date:   Tue, 14 Jan 2020 16:35:10 +0000
Message-ID: <CH2PR02MB7000DB66215C84721CD999C1C7340@CH2PR02MB7000.namprd02.prod.outlook.com>
References: <20200110115415.75683-1-andre.przywara@arm.com>
 <20200110115415.75683-12-andre.przywara@arm.com>
In-Reply-To: <20200110115415.75683-12-andre.przywara@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=radheys@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dfc66033-0ffa-4a8e-24b7-08d7990fb946
x-ms-traffictypediagnostic: CH2PR02MB6392:|CH2PR02MB6392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR02MB6392D43152B07EA1ED441394C7340@CH2PR02MB6392.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(199004)(189003)(5660300002)(30864003)(66946007)(66476007)(64756008)(66446008)(76116006)(66556008)(52536014)(7696005)(6506007)(26005)(53546011)(86362001)(2906002)(33656002)(186003)(8936002)(71200400001)(9686003)(8676002)(110136005)(54906003)(81156014)(81166006)(478600001)(316002)(55016002)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR02MB6392;H:CH2PR02MB7000.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gVTNyexOPRlq6hIckAoYHgoHHmDTygs8SWiK3HY2ziUsq94sKVuThyJ4a+5hjCzZQB5fzXvmc+LpnoWHYnOwbrBpsJQhdg4rlvEX08ZRwirCv2MTTFJ5tYiiUpsw6SVUKG2AKxEOtG/hzM8o3EMJtRkdkedokIS7uprKTXrZpbXoxDACnHOuqznvjtkS5anFPQwiIfjajbI51+9ZOJMo+GhEjAm7i3G9Bb18V5VMgyJmOIWg0crEYrsbVMXDlppI+tNjFAlvpzpp7aNjokRNAiB0P1EcnhtuvnLWLuwNcLf4SS/8Zhh6Cwymrid8A86+ICzr5dQK/z8oVG+g9s/N08cd1HmWAh+bK0I+8HndVI9FtSikyo6CXxxfQdHclkoRJaifz8yvnqFVFMswlCR77Ib1x+Pkmm9K6Ki4A1AB3A171QWCnSuh2hDy9iG/3iC1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfc66033-0ffa-4a8e-24b7-08d7990fb946
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 16:35:10.6184
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hisEOeOUFomfk0Xz8O39UaPlhulf9qDrTKWIYLsUBPli11J0thj8Iq/VrI8285WqIF5yyfbnu5vjyI7l5cnR+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6392
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
> Subject: [PATCH 11/14] net: axienet: Upgrade descriptors to hold 64-bit
> addresses
>=20
> Newer revisions of the AXI DMA IP (>=3D v7.1) support 64-bit addresses,
> both for the descriptors itself, as well as for the buffers they are
> pointing to.
> This is realised by adding "MSB" words for the next and phys pointer
> right behind the existing address word, now named "LSB". These MSB words
> live in formerly reserved areas of the descriptor.
>=20
> If the hardware supports it, write both words when setting an address.
> The buffer address is handled by two wrapper functions, the two
> occasions where we set the next pointers are open coded.
>=20
> For now this is guarded by a flag which we don't set yet.
>=20
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet.h  |   9 +-
>  .../net/ethernet/xilinx/xilinx_axienet_main.c | 109 ++++++++++++------
>  2 files changed, 81 insertions(+), 37 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> index 2dacfc85b3ba..4aea4c23d3bb 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet.h
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet.h
> @@ -335,6 +335,7 @@
>  #define XAE_FEATURE_PARTIAL_TX_CSUM	(1 << 1)
>  #define XAE_FEATURE_FULL_RX_CSUM	(1 << 2)
>  #define XAE_FEATURE_FULL_TX_CSUM	(1 << 3)
> +#define XAE_FEATURE_DMA_64BIT		(1 << 4)
>=20
>  #define XAE_NO_CSUM_OFFLOAD		0
>=20
> @@ -347,9 +348,9 @@
>  /**
>   * struct axidma_bd - Axi Dma buffer descriptor layout
>   * @next:         MM2S/S2MM Next Descriptor Pointer
> - * @reserved1:    Reserved and not used
> + * @next_msb:     MM2S/S2MM Next Descriptor Pointer (high 32 bits)
>   * @phys:         MM2S/S2MM Buffer Address
> - * @reserved2:    Reserved and not used
> + * @phys_msb:     MM2S/S2MM Buffer Address (high 32 bits)
>   * @reserved3:    Reserved and not used
>   * @reserved4:    Reserved and not used
>   * @cntrl:        MM2S/S2MM Control value
> @@ -362,9 +363,9 @@
>   */
>  struct axidma_bd {
>  	u32 next;	/* Physical address of next buffer descriptor */
> -	u32 reserved1;
> +	u32 next_msb;	/* high 32 bits for IP >=3D v7.1, reserved on older IP */
>  	u32 phys;
> -	u32 reserved2;
> +	u32 phys_msb; 	/* for IP >=3D v7.1, reserved for older IP */
>  	u32 reserved3;
>  	u32 reserved4;
>  	u32 cntrl;
> diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> index bbdda4b0c677..133f088d797e 100644
> --- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> +++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
> @@ -153,6 +153,25 @@ static void axienet_dma_out_addr(struct axienet_loca=
l
> *lp, off_t reg,
>  	axienet_dma_out32(lp, reg, lower_32_bits(addr));
>  }
>=20
> +static void desc_set_phys_addr(struct axienet_local *lp, dma_addr_t addr=
,
> +			       struct axidma_bd *desc)
> +{
> +	desc->phys =3D lower_32_bits(addr);
> +	if (lp->features & XAE_FEATURE_DMA_64BIT)

Instead of set/get_phys_addr API, we can use writeq to update msb bits.
The previous IP version marks msb bits as reserved, and are used in
future IP version.  We can have two dma write functions that are selected
in probe dependending on IP version(new compatible string).  In this way
we can get rid of runtime lp->features check in each IO.=20

> +		desc->phys_msb =3D upper_32_bits(addr);
> +}
> +
> +static dma_addr_t desc_get_phys_addr(struct axienet_local *lp,
> +				     struct axidma_bd *desc)
> +{
> +	dma_addr_t ret =3D desc->phys;
> +
> +	if (lp->features & XAE_FEATURE_DMA_64BIT)
> +		ret |=3D (dma_addr_t)desc->phys_msb << 32;
> +
> +	return ret;
> +}
> +
>  /**
>   * axienet_dma_bd_release - Release buffer descriptor rings
>   * @ndev:	Pointer to the net_device structure
> @@ -176,6 +195,8 @@ static void axienet_dma_bd_release(struct net_device
> *ndev)
>  		return;
>=20
>  	for (i =3D 0; i < lp->rx_bd_num; i++) {
> +		dma_addr_t phys;
> +
>  		/* A NULL skb means this descriptor has not been initialised
>  		 * at all.
>  		 */
> @@ -188,9 +209,11 @@ static void axienet_dma_bd_release(struct net_device
> *ndev)
>  		 * descriptor size, after it had been successfully allocated.
>  		 * So a non-zero value in there means we need to unmap it.
>  		 */
> -		if (lp->rx_bd_v[i].cntrl)
> -			dma_unmap_single(ndev->dev.parent, lp-
> >rx_bd_v[i].phys,
> +		if (lp->rx_bd_v[i].cntrl) {
> +			phys =3D desc_get_phys_addr(lp, &lp->rx_bd_v[i]);
> +			dma_unmap_single(ndev->dev.parent, phys,
>  					 lp->max_frm_size,
> DMA_FROM_DEVICE);
> +		}
>  	}
>=20
>  	dma_free_coherent(ndev->dev.parent,
> @@ -235,29 +258,36 @@ static int axienet_dma_bd_init(struct net_device
> *ndev)
>  		goto out;
>=20
>  	for (i =3D 0; i < lp->tx_bd_num; i++) {
> -		lp->tx_bd_v[i].next =3D lp->tx_bd_p +
> -				      sizeof(*lp->tx_bd_v) *
> -				      ((i + 1) % lp->tx_bd_num);
> +		dma_addr_t addr =3D lp->tx_bd_p +
> +				  sizeof(*lp->tx_bd_v) *
> +				  ((i + 1) % lp->tx_bd_num);
> +
> +		lp->tx_bd_v[i].next =3D lower_32_bits(addr);
> +		if (lp->features & XAE_FEATURE_DMA_64BIT)
> +			lp->tx_bd_v[i].next_msb =3D upper_32_bits(addr);
>  	}
>=20
>  	for (i =3D 0; i < lp->rx_bd_num; i++) {
> -		lp->rx_bd_v[i].next =3D lp->rx_bd_p +
> -				      sizeof(*lp->rx_bd_v) *
> -				      ((i + 1) % lp->rx_bd_num);
> +		dma_addr_t addr;
> +
> +		addr =3D lp->rx_bd_p + sizeof(*lp->rx_bd_v) *
> +			((i + 1) % lp->rx_bd_num);
> +		lp->rx_bd_v[i].next =3D lower_32_bits(addr);
> +		if (lp->features & XAE_FEATURE_DMA_64BIT)
> +			lp->rx_bd_v[i].next_msb =3D upper_32_bits(addr);
>=20
>  		skb =3D netdev_alloc_skb_ip_align(ndev, lp->max_frm_size);
>  		if (!skb)
>  			goto out;
>=20
>  		lp->rx_bd_v[i].skb =3D skb;
> -		lp->rx_bd_v[i].phys =3D dma_map_single(ndev->dev.parent,
> -						     skb->data,
> -						     lp->max_frm_size,
> -						     DMA_FROM_DEVICE);
> -		if (dma_mapping_error(ndev->dev.parent, lp->rx_bd_v[i].phys))
> {
> +		addr =3D dma_map_single(ndev->dev.parent, skb->data,
> +				      lp->max_frm_size, DMA_FROM_DEVICE);
> +		if (dma_mapping_error(ndev->dev.parent, addr)) {
>  			dev_kfree_skb(skb);
>  			goto out;
>  		}
> +		desc_set_phys_addr(lp, addr, &lp->rx_bd_v[i]);
>=20
>  		lp->rx_bd_v[i].cntrl =3D lp->max_frm_size;
>  	}
> @@ -565,6 +595,7 @@ static int axienet_free_tx_chain(struct net_device
> *ndev, u32 first_bd,
>  	struct axienet_local *lp =3D netdev_priv(ndev);
>  	int max_bds =3D (nr_bds !=3D -1) ? nr_bds : lp->tx_bd_num;
>  	struct axidma_bd *cur_p;
> +	dma_addr_t phys;
>  	unsigned int status;
>  	int i;
>=20
> @@ -578,7 +609,8 @@ static int axienet_free_tx_chain(struct net_device
> *ndev, u32 first_bd,
>  		if (nr_bds =3D=3D -1 && !(status &
> XAXIDMA_BD_STS_COMPLETE_MASK))
>  			break;
>=20
> -		dma_unmap_single(ndev->dev.parent, cur_p->phys,
> +		phys =3D desc_get_phys_addr(lp, cur_p);
> +		dma_unmap_single(ndev->dev.parent, phys,
>  				(cur_p->cntrl &
> XAXIDMA_BD_CTRL_LENGTH_MASK),
>  				DMA_TO_DEVICE);
>=20
> @@ -676,7 +708,7 @@ axienet_start_xmit(struct sk_buff *skb, struct
> net_device *ndev)
>  	u32 csum_start_off;
>  	u32 csum_index_off;
>  	skb_frag_t *frag;
> -	dma_addr_t tail_p;
> +	dma_addr_t tail_p, phys;
>  	struct axienet_local *lp =3D netdev_priv(ndev);
>  	struct axidma_bd *cur_p;
>  	u32 orig_tail_ptr =3D lp->tx_bd_tail;
> @@ -715,10 +747,11 @@ axienet_start_xmit(struct sk_buff *skb, struct
> net_device *ndev)
>  		cur_p->app0 |=3D 2; /* Tx Full Checksum Offload Enabled */
>  	}
>=20
> -	cur_p->phys =3D dma_map_single(ndev->dev.parent, skb->data,
> -				     skb_headlen(skb), DMA_TO_DEVICE);
> -	if (dma_mapping_error(ndev->dev.parent, cur_p->phys))
> +	phys =3D dma_map_single(ndev->dev.parent, skb->data,
> +			      skb_headlen(skb), DMA_TO_DEVICE);
> +	if (dma_mapping_error(ndev->dev.parent, phys))
>  		return NETDEV_TX_BUSY;
> +	desc_set_phys_addr(lp, phys, cur_p);
>  	cur_p->cntrl =3D skb_headlen(skb) | XAXIDMA_BD_CTRL_TXSOF_MASK;
>=20
>  	for (ii =3D 0; ii < num_frag; ii++) {
> @@ -726,17 +759,18 @@ axienet_start_xmit(struct sk_buff *skb, struct
> net_device *ndev)
>  			lp->tx_bd_tail =3D 0;
>  		cur_p =3D &lp->tx_bd_v[lp->tx_bd_tail];
>  		frag =3D &skb_shinfo(skb)->frags[ii];
> -		cur_p->phys =3D dma_map_single(ndev->dev.parent,
> -					     skb_frag_address(frag),
> -					     skb_frag_size(frag),
> -					     DMA_TO_DEVICE);
> -		if (dma_mapping_error(ndev->dev.parent, cur_p->phys)) {
> +		phys =3D dma_map_single(ndev->dev.parent,
> +				      skb_frag_address(frag),
> +				      skb_frag_size(frag),
> +				      DMA_TO_DEVICE);
> +		if (dma_mapping_error(ndev->dev.parent, phys)) {
>  			axienet_free_tx_chain(ndev, orig_tail_ptr, ii + 1,
>  					      NULL);
>  			lp->tx_bd_tail =3D orig_tail_ptr;
>=20
>  			return NETDEV_TX_BUSY;
>  		}
> +		desc_set_phys_addr(lp, phys, cur_p);
>  		cur_p->cntrl =3D skb_frag_size(frag);
>  	}
>=20
> @@ -775,10 +809,12 @@ static void axienet_recv(struct net_device *ndev)
>  	cur_p =3D &lp->rx_bd_v[lp->rx_bd_ci];
>=20
>  	while ((cur_p->status & XAXIDMA_BD_STS_COMPLETE_MASK)) {
> +		dma_addr_t phys;
> +
>  		tail_p =3D lp->rx_bd_p + sizeof(*lp->rx_bd_v) * lp->rx_bd_ci;
>=20
> -		dma_unmap_single(ndev->dev.parent, cur_p->phys,
> -				 lp->max_frm_size,
> +		phys =3D desc_get_phys_addr(lp, cur_p);
> +		dma_unmap_single(ndev->dev.parent, phys, lp->max_frm_size,
>  				 DMA_FROM_DEVICE);
>=20
>  		skb =3D cur_p->skb;
> @@ -814,13 +850,14 @@ static void axienet_recv(struct net_device *ndev)
>  		if (!new_skb)
>  			return;
>=20
> -		cur_p->phys =3D dma_map_single(ndev->dev.parent, new_skb-
> >data,
> -					     lp->max_frm_size,
> -					     DMA_FROM_DEVICE);
> -		if (dma_mapping_error(ndev->dev.parent, cur_p->phys)) {
> +		phys =3D dma_map_single(ndev->dev.parent, new_skb->data,
> +				      lp->max_frm_size,
> +				      DMA_FROM_DEVICE);
> +		if (dma_mapping_error(ndev->dev.parent, phys)) {
>  			dev_kfree_skb(new_skb);
>  			return;
>  		}
> +		desc_set_phys_addr(lp, phys, cur_p);
>=20
>  		cur_p->cntrl =3D lp->max_frm_size;
>  		cur_p->status =3D 0;
> @@ -865,7 +902,8 @@ static irqreturn_t axienet_tx_irq(int irq, void *_nde=
v)
>  		return IRQ_NONE;
>  	if (status & XAXIDMA_IRQ_ERROR_MASK) {
>  		dev_err(&ndev->dev, "DMA Tx error 0x%x\n", status);
> -		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
> +		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
> +			(lp->tx_bd_v[lp->tx_bd_ci]).phys_msb,
>  			(lp->tx_bd_v[lp->tx_bd_ci]).phys);
>=20
>  		cr =3D axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
> @@ -914,7 +952,8 @@ static irqreturn_t axienet_rx_irq(int irq, void *_nde=
v)
>  		return IRQ_NONE;
>  	if (status & XAXIDMA_IRQ_ERROR_MASK) {
>  		dev_err(&ndev->dev, "DMA Rx error 0x%x\n", status);
> -		dev_err(&ndev->dev, "Current BD is at: 0x%x\n",
> +		dev_err(&ndev->dev, "Current BD is at: 0x%x%08x\n",
> +			(lp->rx_bd_v[lp->rx_bd_ci]).phys_msb,
>  			(lp->rx_bd_v[lp->rx_bd_ci]).phys);
>=20
>  		cr =3D axienet_dma_in32(lp, XAXIDMA_TX_CR_OFFSET);
> @@ -1622,14 +1661,18 @@ static void axienet_dma_err_handler(unsigned long
> data)
>=20
>  	for (i =3D 0; i < lp->tx_bd_num; i++) {
>  		cur_p =3D &lp->tx_bd_v[i];
> -		if (cur_p->cntrl)
> -			dma_unmap_single(ndev->dev.parent, cur_p->phys,
> +		if (cur_p->cntrl) {
> +			dma_addr_t addr =3D desc_get_phys_addr(lp, cur_p);
> +
> +			dma_unmap_single(ndev->dev.parent, addr,
>  					 (cur_p->cntrl &
>  					  XAXIDMA_BD_CTRL_LENGTH_MASK),
>  					 DMA_TO_DEVICE);
> +		}
>  		if (cur_p->skb)
>  			dev_kfree_skb_irq(cur_p->skb);
>  		cur_p->phys =3D 0;
> +		cur_p->phys_msb =3D 0;
>  		cur_p->cntrl =3D 0;
>  		cur_p->status =3D 0;
>  		cur_p->app0 =3D 0;
> --
> 2.17.1

