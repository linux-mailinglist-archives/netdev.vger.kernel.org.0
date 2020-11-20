Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6E02BB49A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbgKTSyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:54:50 -0500
Received: from mail-vi1eur05on2079.outbound.protection.outlook.com ([40.107.21.79]:41185
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732124AbgKTSyt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:54:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvUcWZu6tR9U5IYZ00e3/8PhdCxoTsUQnN/JhKnKDKnpvGplqmlSD66KAWz3th8J6TEVKjS/I8jn5htH1azNPGNVhmB7eMZxLc1FcCtNQq9rUqphy++B+u3nwEPwiSX7YAKN7cT2dXsXqiVi13SmqHrt9Wr4d6wKnJyYrxzlT2ibRvgzUhUdG412vazheqiY//pbDwsOQFdEXmOWDKH5hz2JVT5lzSz9ikwl9DgLX5yZyJ9Tg3w882QbfUqJJdJzLA4ASNqA4giT0tW7IEGmIwmI8oYpztzCXQjSUaqkwISIpWG/TuloUqzZ2C+VPh5/i1WStYa3dq6h28Y1qz9pyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3YxWIRfRcbujRa0HzYs/RG9NKaiRbPm+dfSihICKd0=;
 b=kvjRGAHQP28Tc76JNybVo0Ug7/dWq+NJBVk1Q4n/KGLKt7ccCI5eZ/J6JFsOh/me/ZIR6508i2CJXJM6cLogstuJ90awo/LHolNaMcPetT3tpwboagw9R9W9A4vkzSzNhlFnB1LUkkht+u39eVdMEa43xbI/4DZwgpbaViu7n7mh4x3hf8REncQM+Luvc3WscLeh+q8y4JC96nleNKvPZ+YBSZ044P1LkhqqOmaKHN+VvFS75/Thh0x8QiqqsG47uKUuE2oAeZ15l+ZxueKJlv9YpOVD/omHFelLjhQia+6991xUux0HPBXHXzO8IBK3kyMyT8tJYtS6kuAnaAjIiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O3YxWIRfRcbujRa0HzYs/RG9NKaiRbPm+dfSihICKd0=;
 b=bTqQuv1BKOe5uD5y5koZ4RZJ9wFLkjC3B64IqXOW5vwEO1fAXJzHcTpk8SdJOwjAnpyfeddCbtvF24vIeIKvQUyUHdbvvj0zvTq34DokLEuLKGIMCqDfkUKF/tc37vwGyokB6zg1bqGmN4dgB7sEA1CUK/4qilsEiptMKd9vnag=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4109.eurprd04.prod.outlook.com (2603:10a6:803:46::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Fri, 20 Nov
 2020 18:54:43 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Fri, 20 Nov 2020
 18:54:42 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
Thread-Topic: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
Thread-Index: AQHWvpEwdu5a75WTZUGsTgQMlE9GsKnQIGgAgAE+gIA=
Date:   Fri, 20 Nov 2020 18:54:42 +0000
Message-ID: <VI1PR04MB5807F56500D25ECD20657618F2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
 <aa8bbb5c404f57fdb7915eb236305a177800becb.1605802951.git.camelia.groza@nxp.com>
 <20201119235034.GA24983@ranger.igk.intel.com>
In-Reply-To: <20201119235034.GA24983@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2564e4f8-9565-4842-6e30-08d88d85bdf3
x-ms-traffictypediagnostic: VI1PR04MB4109:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB41095E933519B5B29979250DF2FF0@VI1PR04MB4109.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TVSSSV9QtkB1kr2UNX8/NYMD0V/6daiyjhJtMTJ9gHJvW07Oc97otNTbik3pRN3ekvHgr5CrCFBccwU3syVr6CYInUCjqDZxxubwDBrRuYP20rfYHH7elP5b+/uWle8DJsmurJ7UO1bZEv2l6PHGZw8X+g/iCGHr0X47lG6obcQg6eCMH2Rv2c2QfdIJKmwWgRg7g2jzTja/LlH857Y3mA93iB6Ce0afqT9fxQBTzkML3QAFWMO8aPLXzmIryITT4b+O+gxUwSFULNl5dFPrM7HIS4vuJe7QP8SVnRI0n7lEK1Esyd1/Ixr2U2pHIJtDBoz2a/wUX0TFStdO7DnhDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(346002)(39840400004)(396003)(55016002)(9686003)(83380400001)(64756008)(478600001)(5660300002)(76116006)(52536014)(53546011)(66556008)(66476007)(66446008)(6506007)(26005)(186003)(66946007)(7696005)(6916009)(8936002)(8676002)(86362001)(30864003)(2906002)(33656002)(4326008)(54906003)(316002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ql0IG1LFSp5oSmEmczY7Ybkxqr/NW/ORoUVopxp+d6QMR9E3NG8rx8OID2ubcQa4suKvYbkJZIuEl+8FI9WcDO+ZnVlST/BqCkyZIH76nJsaIv6sGnFWbiCyI7plTgXgtKe1YRHMmgKO1orU+h8Ne/L1YtYObEZtPC/Qun73IWnFuvRtFuOjY9eRDRaSSFYPOclKgmtIlcz+jkdGl0eVEIJ2dJzPmlD52Iyx3L4FtPrXh6Cf1zsmhuiKHBXk9bDYYHTxgyJrgbEo8mxI+3h+PjhnhIupoDc3X0msPNqIcbDri3cT3qAJD54UdTI39BsqwSWYZ77x3y7gGur9QIr/3UWg31BijVVFJ5ugwTy2C1XvQ/Ws9hcQEgiU93/w7KskHe+4jyqxBBs+IsPKrVv6QMGk4b0ZG4ohs3BB80yI2Q+xiqTlhRCpr554uDEN9SM7oO6qLs+jdwP28V3dj1Q5dAQOKLee2mCeUXAFN0hAlHNWa2AenIV/J/1WPoCUyZQM5uzbrzqbzNj8jCInA6a6GxTYba5xkqVx55j+tfQVnlb3lr5DeH/tgLXIvPpxXx0C/S9n9pExVLAEbgjRdyosXsE65Aw3LMUPvuAcbSuB3ogZ0ij3ixgSJwUD4e5UeVp6T043x4PAJ8X63pr8VhimJqmlg1YOUp/tYEN+Msz/Lfr/3NT8hr3TL4hN034f0qUsy/5xBfNXWo63rKEWnM7hVrttwFfrX9ma17kIO8XZSizMraAGr5+np/mguttr9eHQsNKQ4hRM7wjX9bUanV4ybaYzweJzYp6zJMhFLz38Om4VQ07fNN87t8K41FxKWB4IjB8xspl297gCgev94kIF3+2j0lVwms/G7gL7Wu0B1CpM6CNAZi/sskT3HLYN6YVvzUcYOG8+2vKc9GStBlVW6Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2564e4f8-9565-4842-6e30-08d88d85bdf3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2020 18:54:42.8959
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NHscngWrqLFDGsd6zqVgwyvk8t069QGDVjOxgJboG2jY4lODqvjDPYbI+jnBKi8bkZLAP62YQCgrI4Al3bu9ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Friday, November 20, 2020 01:51
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
>=20
> On Thu, Nov 19, 2020 at 06:29:33PM +0200, Camelia Groza wrote:
> > Use an xdp_frame structure for managing the frame. Store a backpointer
> to
> > the structure at the start of the buffer before enqueueing. Use the XDP
> > API for freeing the buffer when it returns to the driver on the TX
> > confirmation path.
>=20
> Completion path?

The DPAA terminology uses confirmation instead of completion, but the meani=
ng is similar. The dpaa.rst documentation has more details.

> >
> > This approach will be reused for XDP REDIRECT.
> >
> > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 129
> ++++++++++++++++++++++++-
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> >  2 files changed, 126 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 242ed45..cd5f4f6 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -1130,6 +1130,24 @@ static int dpaa_fq_init(struct dpaa_fq *dpaa_fq,
> bool td_enable)
> >
> >  	dpaa_fq->fqid =3D qman_fq_fqid(fq);
> >
> > +	if (dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_DEFAULT ||
> > +	    dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_PCD) {
> > +		err =3D xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq-
> >net_dev,
> > +				       dpaa_fq->fqid);
> > +		if (err) {
> > +			dev_err(dev, "xdp_rxq_info_reg failed\n");
>=20
> Print out the err?

I'll add the err in the next version.

> Also, shouldn't you call qman_destroy_fq() for these error paths?

Yes, for the point of undoing all configurations on the queue. The entire p=
robe is aborted if things fail at this point, so everything is cleaned eith=
er way. I'll fix this in the next version.

> > +			return err;
> > +		}
> > +
> > +		err =3D xdp_rxq_info_reg_mem_model(&dpaa_fq->xdp_rxq,
> > +						 MEM_TYPE_PAGE_ORDER0,
> NULL);
> > +		if (err) {
> > +			dev_err(dev, "xdp_rxq_info_reg_mem_model
> failed\n");
> > +			xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > +			return err;
> > +		}
> > +	}
> > +
> >  	return 0;
> >  }
> >
> > @@ -1159,6 +1177,10 @@ static int dpaa_fq_free_entry(struct device
> *dev, struct qman_fq *fq)
> >  		}
> >  	}
> >
> > +	if (dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_DEFAULT ||
> > +	    dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_PCD)
>=20
> You should call xdp_rxq_info_is_reg() before the unregister below.

I'll add it.

> > +		xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > +
> >  	qman_destroy_fq(fq);
> >  	list_del(&dpaa_fq->list);
> >
> > @@ -1625,6 +1647,9 @@ static int dpaa_eth_refill_bpools(struct dpaa_pri=
v
> *priv)
> >   *
> >   * Return the skb backpointer, since for S/G frames the buffer contain=
ing it
> >   * gets freed here.
> > + *
> > + * No skb backpointer is set when transmitting XDP frames. Cleanup the
> buffer
> > + * and return NULL in this case.
> >   */
> >  static struct sk_buff *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv=
,
> >  					  const struct qm_fd *fd, bool ts)
> > @@ -1636,6 +1661,7 @@ static struct sk_buff *dpaa_cleanup_tx_fd(const
> struct dpaa_priv *priv,
> >  	void *vaddr =3D phys_to_virt(addr);
> >  	const struct qm_sg_entry *sgt;
> >  	struct dpaa_eth_swbp *swbp;
> > +	struct xdp_frame *xdpf;
>=20
> This local variable feels a bit unnecessary.

Sure, I'll remove it.

> >  	struct sk_buff *skb;
> >  	u64 ns;
> >  	int i;
> > @@ -1664,13 +1690,22 @@ static struct sk_buff
> *dpaa_cleanup_tx_fd(const struct dpaa_priv *priv,
> >  		}
> >  	} else {
> >  		dma_unmap_single(priv->tx_dma_dev, addr,
> > -				 priv->tx_headroom +
> qm_fd_get_length(fd),
> > +				 qm_fd_get_offset(fd) +
> qm_fd_get_length(fd),
> >  				 dma_dir);
> >  	}
> >
> >  	swbp =3D (struct dpaa_eth_swbp *)vaddr;
> >  	skb =3D swbp->skb;
> >
> > +	/* No skb backpointer is set when running XDP. An xdp_frame
> > +	 * backpointer is saved instead.
> > +	 */
> > +	if (!skb) {
> > +		xdpf =3D swbp->xdpf;
> > +		xdp_return_frame(xdpf);
> > +		return NULL;
> > +	}
> > +
> >  	/* DMA unmapping is required before accessing the HW provided
> info */
> >  	if (ts && priv->tx_tstamp &&
> >  	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > @@ -2350,11 +2385,76 @@ static enum qman_cb_dqrr_result
> rx_error_dqrr(struct qman_portal *portal,
> >  	return qman_cb_dqrr_consume;
> >  }
> >
> > +static int dpaa_xdp_xmit_frame(struct net_device *net_dev,
> > +			       struct xdp_frame *xdpf)
> > +{
> > +	struct dpaa_priv *priv =3D netdev_priv(net_dev);
> > +	struct rtnl_link_stats64 *percpu_stats;
> > +	struct dpaa_percpu_priv *percpu_priv;
> > +	struct dpaa_eth_swbp *swbp;
> > +	struct netdev_queue *txq;
> > +	void *buff_start;
> > +	struct qm_fd fd;
> > +	dma_addr_t addr;
> > +	int err;
> > +
> > +	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
> > +	percpu_stats =3D &percpu_priv->stats;
> > +
> > +	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
>=20
> Could you shed some light on DPAA_TX_PRIV_DATA_SIZE usage?

We store information at the start of egress buffers that we use on the conf=
irmation path for cleanup. DPAA_TX_PRIV_DATA_SIZE is the size of this reser=
ved area. We require buffers to have at least this mush space available at =
the start before transmitting them.

> > +		err =3D -EINVAL;
> > +		goto out_error;
> > +	}
> > +
> > +	buff_start =3D xdpf->data - xdpf->headroom;
> > +
> > +	/* Leave empty the skb backpointer at the start of the buffer.
> > +	 * Save the XDP frame for easy cleanup on confirmation.
> > +	 */
> > +	swbp =3D (struct dpaa_eth_swbp *)buff_start;
> > +	swbp->skb =3D NULL;
> > +	swbp->xdpf =3D xdpf;
> > +
> > +	qm_fd_clear_fd(&fd);
> > +	fd.bpid =3D FSL_DPAA_BPID_INV;
> > +	fd.cmd |=3D cpu_to_be32(FM_FD_CMD_FCO);
> > +	qm_fd_set_contig(&fd, xdpf->headroom, xdpf->len);
> > +
> > +	addr =3D dma_map_single(priv->tx_dma_dev, buff_start,
> > +			      xdpf->headroom + xdpf->len,
> > +			      DMA_TO_DEVICE);
> > +	if (unlikely(dma_mapping_error(priv->tx_dma_dev, addr))) {
> > +		err =3D -EINVAL;
> > +		goto out_error;
> > +	}
> > +
> > +	qm_fd_addr_set64(&fd, addr);
> > +
> > +	/* Bump the trans_start */
> > +	txq =3D netdev_get_tx_queue(net_dev, smp_processor_id());
> > +	txq->trans_start =3D jiffies;
> > +
> > +	err =3D dpaa_xmit(priv, percpu_stats, smp_processor_id(), &fd);
>=20
> So it looks like you don't provide the XDP Tx resources and you share the
> netstack's Tx queues with XDP, if I'm reading this right.
>=20
> Please mention it/explain in the cover letter or commit message of this
> patch. Furthermore, I don't see any locking happenning over here?

Yes, that's correct, we don't have dedicated Tx queues for XDP, we share th=
em with the netstack.

We don't need locking at this level. We are a LLTX driver so we don't take =
the netif_tx_lock. I'll mention this in the cover letter.

> > +	if (err) {
> > +		dma_unmap_single(priv->tx_dma_dev, addr,
> > +				 qm_fd_get_offset(&fd) +
> qm_fd_get_length(&fd),
> > +				 DMA_TO_DEVICE);
> > +		goto out_error;
> > +	}
> > +
> > +	return 0;
> > +
> > +out_error:
> > +	percpu_stats->tx_errors++;
> > +	return err;
> > +}
> > +
> >  static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, void
> *vaddr,
> > -			unsigned int *xdp_meta_len)
> > +			struct dpaa_fq *dpaa_fq, unsigned int
> *xdp_meta_len)
> >  {
> >  	ssize_t fd_off =3D qm_fd_get_offset(fd);
> >  	struct bpf_prog *xdp_prog;
> > +	struct xdp_frame *xdpf;
> >  	struct xdp_buff xdp;
> >  	u32 xdp_act;
> >
> > @@ -2370,7 +2470,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> struct qm_fd *fd, void *vaddr,
> >  	xdp.data_meta =3D xdp.data;
> >  	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> >  	xdp.data_end =3D xdp.data + qm_fd_get_length(fd);
> > -	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> > +	xdp.rxq =3D &dpaa_fq->xdp_rxq;
> >
> >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> >
> > @@ -2381,6 +2482,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> struct qm_fd *fd, void *vaddr,
> >  	case XDP_PASS:
> >  		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> >  		break;
> > +	case XDP_TX:
> > +		/* We can access the full headroom when sending the frame
> > +		 * back out
>=20
> And normally why a piece of headroom is taken away? I probably should
> have
> started from the basic XDP support patch, but if you don't mind, please
> explain it a bit.

I mentioned we require DPAA_TX_PRIV_DATA_SIZE bytes at the start of the buf=
fer in order to make sure we have enough space for our private info.

When setting up the xdp_buff, this area is reserved from the frame size exp=
osed to the XDP program.
 -	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
 +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;

After the XDP_TX verdict, we're sure that DPAA_TX_PRIV_DATA_SIZE bytes at t=
he start of the buffer are free and we can use the full headroom how it sui=
ts us, hence the increase of the frame size back to DPAA_BP_RAW_SIZE.

Thanks for all your feedback.

> > +		 */
> > +		xdp.data_hard_start =3D vaddr;
> > +		xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > +		xdpf =3D xdp_convert_buff_to_frame(&xdp);
> > +		if (unlikely(!xdpf)) {
> > +			free_pages((unsigned long)vaddr, 0);
> > +			break;
> > +		}
> > +
> > +		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
> > +			xdp_return_frame_rx_napi(xdpf);
> > +
> > +		break;
> >  	default:
> >  		bpf_warn_invalid_xdp_action(xdp_act);
> >  		fallthrough;
> > @@ -2415,6 +2532,7 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
> >  	u32 fd_status, hash_offset;
> >  	struct qm_sg_entry *sgt;
> >  	struct dpaa_bp *dpaa_bp;
> > +	struct dpaa_fq *dpaa_fq;
> >  	struct dpaa_priv *priv;
> >  	struct sk_buff *skb;
> >  	int *count_ptr;
> > @@ -2423,9 +2541,10 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
> >  	u32 hash;
> >  	u64 ns;
> >
> > +	dpaa_fq =3D container_of(fq, struct dpaa_fq, fq_base);
> >  	fd_status =3D be32_to_cpu(fd->status);
> >  	fd_format =3D qm_fd_get_format(fd);
> > -	net_dev =3D ((struct dpaa_fq *)fq)->net_dev;
> > +	net_dev =3D dpaa_fq->net_dev;
> >  	priv =3D netdev_priv(net_dev);
> >  	dpaa_bp =3D dpaa_bpid2pool(dq->fd.bpid);
> >  	if (!dpaa_bp)
> > @@ -2494,7 +2613,7 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
> >
> >  	if (likely(fd_format =3D=3D qm_fd_contig)) {
> >  		xdp_act =3D dpaa_run_xdp(priv, (struct qm_fd *)fd, vaddr,
> > -				       &xdp_meta_len);
> > +				       dpaa_fq, &xdp_meta_len);
> >  		if (xdp_act !=3D XDP_PASS) {
> >  			percpu_stats->rx_packets++;
> >  			percpu_stats->rx_bytes +=3D qm_fd_get_length(fd);
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > index 94e8613..5c8d52a 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.h
> > @@ -68,6 +68,7 @@ struct dpaa_fq {
> >  	u16 channel;
> >  	u8 wq;
> >  	enum dpaa_fq_type fq_type;
> > +	struct xdp_rxq_info xdp_rxq;
> >  };
> >
> >  struct dpaa_fq_cbs {
> > @@ -150,6 +151,7 @@ struct dpaa_buffer_layout {
> >   */
> >  struct dpaa_eth_swbp {
> >  	struct sk_buff *skb;
> > +	struct xdp_frame *xdpf;
> >  };
> >
> >  struct dpaa_priv {
> > --
> > 1.9.1
> >
