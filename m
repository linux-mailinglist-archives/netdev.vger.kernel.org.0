Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C663A2C6AAE
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 18:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732050AbgK0RfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 12:35:07 -0500
Received: from mail-eopbgr20073.outbound.protection.outlook.com ([40.107.2.73]:54658
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731761AbgK0RfG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 12:35:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d46/KwfR1OGU9xLrJyoq+6PMWJvuLeJ0Nh6DJKTUDek5EjBXk8w1hsS/5yurMFa5oShjDTKRvhOSvFEMjFGrKqsRYiNKhsNfBSk1Or+JhvnPlpdEBtSLAN7+9mcr8JJFENbjhdIjYgCwE+v8xjWNbylxuF496feliVXtcRDG1hU3caPtXudApU5WeKxeGh5mp0lzK5A6BsciQmNpCQT1Ty3eRFYo8zM142Y/sWJMzLubr0SxZ6AxFLsogcPMAzBdJPCwvCxZmE82QqbxuxNdDygDguXCegicrINqVeiHo11auRXTSK2qCWafJ6Zxk2peXhAjA1p+u+dE3PJsqEIgZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3o5x/2tuG1/+PBHyVE3Cp8tkHZo76gtLSqMPUq76WM=;
 b=nYRbHYxkqcRkX8WVADI5Iu6z49i00t2j0vz1cNrX4ayGG/WKjQlNQIabGeTpQBNJnyy3T8zECEeBpCEVJgt/Puc1RgKh1HSk73ltARAthrI83tiz2gfscVVaEo1JDUiWMBNMkNy3zUy0O+txYii3CcpWoaJhEbewKkANhXTb5x2i0j3Ze2DuMW7c8HiQOKwobOJOvkcgrukzV6GJxV4o+oKC/f3zChMKlW0rgTZoRTg1lX9I3RWroAtGRXNs7x1KSIBPQBpd7mVRdoyDkMcLRhZmQUBJkBsdwLdO6uSN6v3mX3saMYzd6iapKWhK1m0xZ9TDqmB9qVafHcw1wKDvaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3o5x/2tuG1/+PBHyVE3Cp8tkHZo76gtLSqMPUq76WM=;
 b=iq/YJo6ANB7ZnDHKY2r48LGHD/vlfn2XbWHEZ6FBY2p3t6n+eW5mSVONSJygowKgUOVsykBbLiuRYMZJBopkc/gO6EJgmhv9OCxeIWYAfhNNBP3JmKv+4TI6xAkZzjOs6paQG0ayuSHrV8VCyJFYTzzRv758hS7J0I93/ZOXL4M=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0402MB3456.eurprd04.prod.outlook.com (2603:10a6:803:7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22; Fri, 27 Nov
 2020 17:35:00 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 17:35:00 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 7/7] dpaa_eth: implement the A050385 erratum
 workaround for XDP
Thread-Topic: [PATCH net-next v4 7/7] dpaa_eth: implement the A050385 erratum
 workaround for XDP
Thread-Index: AQHWwb82V4rZvSFht06Jb/xRZf8LCanXw3EAgAE+V3CAAxJCgIAAJBSg
Date:   Fri, 27 Nov 2020 17:35:00 +0000
Message-ID: <VI1PR04MB58074A3E3A8BC5A3695086A8F2F80@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <e53e361d320cb901b0d9b9b82e6c16a04fbe6f86.1606150838.git.camelia.groza@nxp.com>
 <20201124205040.GA19977@ranger.igk.intel.com>
 <VI1PR04MB5807F77BA161E9BB7729C2B6F2FA0@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <20201127144411.GC26825@ranger.igk.intel.com>
In-Reply-To: <20201127144411.GC26825@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9d98bbfb-1381-45c3-c944-08d892fac442
x-ms-traffictypediagnostic: VI1PR0402MB3456:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB34560E6BB4C466029BFB4B1CF2F80@VI1PR0402MB3456.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oUQcMJFWu+UiI+Bq9GEl9bSOv/Yv+BpNo0KYvmMpLhyo9pcW5RWPMpcRgICCrOgRJnTAla2zqjcaUCIRDBph+r98be8fyV337L8KOLgeqREwAy+dUMSSnEh2wwcrV+A620eOTg6gCZfCIIDbMLCMmKsFqOq7Hcdty0pjI50Rss9meaVLAf90+iLiLWLV8kCA77OqxwhH2rqShAnE7o0tLgoIBFauJdS3zXOgEoXrwvCkXQWvRCqe/X2hsRmC0AvOgN7/ZeiM42oAe2MAyVA7jaLvSxmxHFIHLJ2KklgYTF5p4XBnNiSZdksRUO97YcZf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(376002)(39860400002)(396003)(2906002)(71200400001)(8936002)(7696005)(54906003)(6506007)(53546011)(9686003)(55016002)(316002)(478600001)(26005)(6916009)(52536014)(8676002)(33656002)(186003)(66946007)(76116006)(66446008)(64756008)(66556008)(83380400001)(66476007)(5660300002)(86362001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1c/umnJFA2iqO1oP6JToLKLh1z8j2DAjA3RkQEZFs/SIzS79tF8R2yf0QOxQ?=
 =?us-ascii?Q?+Rhio0FalXI+FZsq6NGaz4uPBbkXBmW2bw8XGINF9100vlPCHlBGhvi0cvlK?=
 =?us-ascii?Q?QTnKdONjch+m81KRqryWJ1oZshEQHqnsAaci82ah8hsk+Ntd4WkFI7dVps3j?=
 =?us-ascii?Q?4kJ8uxTD2rCnqj0aT59aFGxpqjo35r4TlBCAZh9EvtSTEmGW1I2PBtBD+HMg?=
 =?us-ascii?Q?ewi8m8My43Az4jqHYYRbf4co2GYXqsRQFMaPd7zA5VXwIwBll36YSXLc5iUk?=
 =?us-ascii?Q?gVZqANm/XUY77Y5NtInc1U1UqDUa3TgSTL50JJvbe3b7RVd/sFmfeSBdphaK?=
 =?us-ascii?Q?bgkA70+2DlZCsQNpXcZ/CnGKhnPxLyUhCBt1lK/DZhieLh50qwiCcjF4vxOS?=
 =?us-ascii?Q?Bs2pPn0NWY4bzoM9VPDBI+hXw0rjjwxFGWlaTBrxK8k5vEWqFYXqPpPBwH8d?=
 =?us-ascii?Q?lu3C4tjde82ZfbMSP9mkQoyqkh6RT3grekYIaYLE/IyumoEk7SgWzLOlmhsN?=
 =?us-ascii?Q?rgdQufjnV8Uo8Dae533klPckhK8f8TxEb9D4TpchRwnxCju1BEU6OS4UbSRn?=
 =?us-ascii?Q?1mkOi2o5QGQLKQlVzvEr7olYLsPkUudjWAAAMKcKVVgEAsHUAoY8EQLCFpzx?=
 =?us-ascii?Q?KLK6LaDrMS+gJlLvLDdPUNEE12LrZp65U9udUEZBCfA44upHnkuZF17kE4Vd?=
 =?us-ascii?Q?IieCTLwwYGlk7GjIie/AZ25Euy9SxlVxs/v8TFuFbp9v/+R8dWvj1rkPQK8c?=
 =?us-ascii?Q?JrTsrzyBT18/rjssS9q0mBvDGgyO5UyGTsCHl0eObZ9dRrzWkrLMvSR6LwZN?=
 =?us-ascii?Q?J/iOmdAGAC+n0BusWBjbSMATMBm3MFsfy8f8Dw7LvaHT9ieQqhf8hVhK5VLF?=
 =?us-ascii?Q?3wlMCDtjlbDL1I8fGWYLyABsk/gXdeFmC1AIqjZsYOSCXsMZ25j5kPrL3y5Z?=
 =?us-ascii?Q?17PxqhGgnakA2zAnk1CYyESn2FKVdUkActgpqvPTqRk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d98bbfb-1381-45c3-c944-08d892fac442
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Nov 2020 17:35:00.3266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SpdCCnek102QGhryNnI3i/9jOiLiW3dZ8VwIQLOWwN6/rVtfNAJE35NRnpk7CiXRBWNXnOcxPA+m2yKKxFYOog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3456
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Friday, November 27, 2020 16:44
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 7/7] dpaa_eth: implement the A050385
> erratum workaround for XDP
>=20
> On Wed, Nov 25, 2020 at 03:52:33PM +0000, Camelia Alexandra Groza wrote:
> > > -----Original Message-----
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Sent: Tuesday, November 24, 2020 22:51
> > > To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > > Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> > > davem@davemloft.net; Madalin Bucur (OSS)
> > > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next v4 7/7] dpaa_eth: implement the A050385
> > > erratum workaround for XDP
> > >
> > > On Mon, Nov 23, 2020 at 07:36:25PM +0200, Camelia Groza wrote:
> > > > For XDP TX, even tough we start out with correctly aligned buffers,=
 the
> > > > XDP program might change the data's alignment. For REDIRECT, we
> have no
> > > > control over the alignment either.
> > > >
> > > > Create a new workaround for xdp_frame structures to verify the
> erratum
> > > > conditions and move the data to a fresh buffer if necessary. Create=
 a
> new
> > > > xdp_frame for managing the new buffer and free the old one using th=
e
> > > XDP
> > > > API.
> > > >
> > > > Due to alignment constraints, all frames have a 256 byte headroom t=
hat
> > > > is offered fully to XDP under the erratum. If the XDP program uses =
all
> > > > of it, the data needs to be move to make room for the xdpf
> backpointer.
> > >
> > > Out of curiosity, wouldn't it be easier to decrease the headroom that=
 is
> > > given to xdp rather doing to full copy of a buffer in case you miss a=
 few
> > > bytes on headroom?
> >
> > First of all, I'm not sure if offering less than XDP_PACKET_HEADROOM to
> XDP programs is allowed. Second, we require the data to be strictly align=
ed
> under this erratum. This first condition would be broken even if we reduc=
e
> the size of the offered headroom.
> >
> > > >
> > > > Disable the metadata support since the information can be lost.
> > > >
> > > > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > > > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > > > ---
> > > >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 82
> > > +++++++++++++++++++++++++-
> > > >  1 file changed, 79 insertions(+), 3 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > index 149b549..d8fc19d 100644
> > > > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > > > @@ -2170,6 +2170,52 @@ static int dpaa_a050385_wa_skb(struct
> > > net_device *net_dev, struct sk_buff **s)
> > > >
> > > >  	return 0;
> > > >  }
> > > > +
> > > > +static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
> > > > +				struct xdp_frame **init_xdpf)
> > > > +{
> > > > +	struct xdp_frame *new_xdpf, *xdpf =3D *init_xdpf;
> > > > +	void *new_buff;
> > > > +	struct page *p;
> > > > +
> > > > +	/* Check the data alignment and make sure the headroom is large
> > > > +	 * enough to store the xdpf backpointer. Use an aligned headroom
> > > > +	 * value.
> > > > +	 *
> > > > +	 * Due to alignment constraints, we give XDP access to the full 2=
56
> > > > +	 * byte frame headroom. If the XDP program uses all of it, copy t=
he
> > > > +	 * data to a new buffer and make room for storing the backpointer=
.
> > > > +	 */
> > > > +	if (PTR_IS_ALIGNED(xdpf->data, DPAA_A050385_ALIGN) &&
> > > > +	    xdpf->headroom >=3D priv->tx_headroom) {
> > > > +		xdpf->headroom =3D priv->tx_headroom;
> > > > +		return 0;
> > > > +	}
> > > > +
> > > > +	p =3D dev_alloc_pages(0);
> > > > +	if (unlikely(!p))
> > > > +		return -ENOMEM;
> > > > +
> > > > +	/* Copy the data to the new buffer at a properly aligned offset *=
/
> > > > +	new_buff =3D page_address(p);
> > > > +	memcpy(new_buff + priv->tx_headroom, xdpf->data, xdpf->len);
> > > > +
> > > > +	/* Create an XDP frame around the new buffer in a similar fashion
> > > > +	 * to xdp_convert_buff_to_frame.
> > > > +	 */
> > > > +	new_xdpf =3D new_buff;
> > > > +	new_xdpf->data =3D new_buff + priv->tx_headroom;
> > > > +	new_xdpf->len =3D xdpf->len;
> > > > +	new_xdpf->headroom =3D priv->tx_headroom;
> > >
> > > What if ptr was not aligned so you got here but tx_headroom was less
> than
> > > xdpf->headroom? Shouldn't you choose the bigger one? Aren't you
> shrinking
> > > the headroom for this case.
> >
> > Yes, I am shrinking the headroom. At this point, the headroom's content
> isn't relevant anymore (this path is executed when transmitting the frame
> after TX or REDIRECT). What is important is the data's alignment, and it =
is
> dictated by the headroom's (fd's offset) size.
>=20
> So would it be possible to do a memmove within the existing buffer under
> some circumstances and then have this current logic as a worst case
> scenario? Majority of XDP progs won't consume all of the XDP headroom so =
I
> think it's something worth pursuing.
>=20
> Please also tell us the performance impact of that workaround. Grabbing
> new page followed by memcpy is expensive.

Yes, using memmove() might be an optimization if enough headroom is availab=
le to shift the data. Thanks for the suggestion. I can send this in separat=
ely as an optimization if you don't think is a blocker and if there aren't =
any other comments on v5.

I don't have numbers to share at the moment for the performance impact.

> >
> > > > +	new_xdpf->frame_sz =3D DPAA_BP_RAW_SIZE;
> > > > +	new_xdpf->mem.type =3D MEM_TYPE_PAGE_ORDER0;
> > > > +
> > > > +	/* Release the initial buffer */
> > > > +	xdp_return_frame_rx_napi(xdpf);
> > > > +
> > > > +	*init_xdpf =3D new_xdpf;
> > > > +	return 0;
> > > > +}
> > > >  #endif
> > > >
> > > >  static netdev_tx_t
> > > > @@ -2406,6 +2452,15 @@ static int dpaa_xdp_xmit_frame(struct
> > > net_device *net_dev,
> > > >  	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
> > > >  	percpu_stats =3D &percpu_priv->stats;
> > > >
> > > > +#ifdef CONFIG_DPAA_ERRATUM_A050385
> > > > +	if (unlikely(fman_has_errata_a050385())) {
> > > > +		if (dpaa_a050385_wa_xdpf(priv, &xdpf)) {
> > > > +			err =3D -ENOMEM;
> > > > +			goto out_error;
> > > > +		}
> > > > +	}
> > > > +#endif
> > > > +
> > > >  	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
> > > >  		err =3D -EINVAL;
> > > >  		goto out_error;
> > > > @@ -2479,6 +2534,20 @@ static u32 dpaa_run_xdp(struct dpaa_priv
> *priv,
> > > struct qm_fd *fd, void *vaddr,
> > > >  	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> > > >  	xdp.rxq =3D &dpaa_fq->xdp_rxq;
> > > >
> > > > +	/* We reserve a fixed headroom of 256 bytes under the erratum and
> > > we
> > > > +	 * offer it all to XDP programs to use. If no room is left for th=
e
> > > > +	 * xdpf backpointer on TX, we will need to copy the data.
> > > > +	 * Disable metadata support since data realignments might be
> > > required
> > > > +	 * and the information can be lost.
> > > > +	 */
> > > > +#ifdef CONFIG_DPAA_ERRATUM_A050385
> > > > +	if (unlikely(fman_has_errata_a050385())) {
> > > > +		xdp_set_data_meta_invalid(&xdp);
> > > > +		xdp.data_hard_start =3D vaddr;
> > > > +		xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > > > +	}
> > > > +#endif
> > > > +
> > > >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >
> > > >  	/* Update the length and the offset of the FD */
> > > > @@ -2486,7 +2555,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv
> *priv,
> > > struct qm_fd *fd, void *vaddr,
> > > >
> > > >  	switch (xdp_act) {
> > > >  	case XDP_PASS:
> > > > -		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> > > > +		*xdp_meta_len =3D xdp_data_meta_unsupported(&xdp) ? 0 :
> > > > +				xdp.data - xdp.data_meta;
> > >
> > > You could consider surrounding this with ifdef and keep the old versi=
on in
> > > the else branch so that old case is not hurt with that additional bra=
nch
> > > that you're introducing with that ternary operator.
> >
> > Sure, I'll do that. Thanks.
> >
> > > >  		break;
> > > >  	case XDP_TX:
> > > >  		/* We can access the full headroom when sending the frame
> > > > @@ -3188,10 +3258,16 @@ static u16 dpaa_get_headroom(struct
> > > dpaa_buffer_layout *bl,
> > > >  	 */
> > > >  	headroom =3D (u16)(bl[port].priv_data_size + DPAA_HWA_SIZE);
> > > >
> > > > -	if (port =3D=3D RX)
> > > > +	if (port =3D=3D RX) {
> > > > +#ifdef CONFIG_DPAA_ERRATUM_A050385
> > > > +		if (unlikely(fman_has_errata_a050385()))
> > > > +			headroom =3D XDP_PACKET_HEADROOM;
> > > > +#endif
> > > > +
> > > >  		return ALIGN(headroom,
> > > DPAA_FD_RX_DATA_ALIGNMENT);
> > > > -	else
> > > > +	} else {
> > > >  		return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
> > > > +	}
> > > >  }
> > > >
> > > >  static int dpaa_eth_probe(struct platform_device *pdev)
> > > > --
> > > > 1.9.1
> > > >
