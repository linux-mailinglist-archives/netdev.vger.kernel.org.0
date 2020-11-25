Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55172C4464
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgKYPtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:49:51 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:15968
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730318AbgKYPtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:49:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nyMn3tb4nO6FrZH81b2UTYZ1ay6H+No6/3wR2e8un5EQ+j/eqCBE6ENEUV6vr09GiEZLcb3a0RMmufUBX/GK1Pp22286vwdUzOwWeXQWd5EwizLACfhGNeLVpq9KOTLh94mP2x3ROdvNsVnal/0DAv0ZTduK8hjjoch96/3aBRjN8VzJYcSRxUItq7KvB5FViNuBDwDOdZbR9ejzlzcWTjixJccknsDR7meIC0FQzWHuEGYwjC7Gma+UwfkOmdFTVyPhieuZW0wmf+Rtgom6lP7LHyu1qvFibViYGGtjZNeXRhM3ygpyyZfdisyq8MHtwY0Pfn27JF8OxsJG6ORkhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85tswAw/XY5UF9HtE/+8QXifcLXSH7/S2ZQHRUzS+Vo=;
 b=UGK0PZMk+uRCZxAkp3JaOphHjzfQOis6BfSMmZdQtFEzq6blf1PDPcrm+PMfBk5b4zoGhQE+IzyjGDQpxDLzNK6fWgFX9I1/eMUjW6DDPi/Y3m+Dot7ao4D/PrJj4NaZSQx6BOPM9YbG9fvm+na7wm6EbAdY3YrJwVEMu4YTNPfRthuvUXEvsVrf03uh0Yq29fBDb+oVx+vtZvSyLny7MoN3qtbJgKgGC3H1CFy7iFx4bIfopdbMAIhQzy96DgOdDFv8ZSn9pIPUX/0fdkXBOvh4AkKQ3OGaO6B4YeegizVrhgYIMkOriksmzdbpQCbDvHgJMmJskV9wy2Rmom3xDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85tswAw/XY5UF9HtE/+8QXifcLXSH7/S2ZQHRUzS+Vo=;
 b=q+PKa6s5O5ESRa9hMyZTu7P+lv7QQNFyV4sUKi5PDdOuY/SxazojsX5zOoiHwqgs4vnmUCfrsqVfgXcWTAdf3nYFXDc1+JPlmuf52nYQ/9ZQ/eSQ1nntl9Zew85Au1w+/M7G1GluJg+VTo0xXeOZFlkyd633iRYrq9vxYtzblLs=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6464.eurprd04.prod.outlook.com (2603:10a6:803:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Wed, 25 Nov
 2020 15:49:45 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Wed, 25 Nov 2020
 15:49:45 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
Thread-Topic: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
Thread-Index: AQHWwb81iW4HPpJqH0qKrje1nVOayKnXsxEAgAFOQYA=
Date:   Wed, 25 Nov 2020 15:49:45 +0000
Message-ID: <VI1PR04MB5807BAB32C7B43C752C7B662F2FA0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <6491d6ba855c7e736383e7f603321fe7184681bc.1606150838.git.camelia.groza@nxp.com>
 <20201124195204.GC12808@ranger.igk.intel.com>
In-Reply-To: <20201124195204.GC12808@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: f8a4933b-1c66-468b-e18a-08d89159bb76
x-ms-traffictypediagnostic: VE1PR04MB6464:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB64640745ABBB4229B064837FF2FA0@VE1PR04MB6464.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JQc1DSHE76/dc8OvzytYoyH/ZtJgtFAyNZ0+Dd1LXLQeAindAhk8U2vO8iXjiGLsKVqNYPZlIAtgzQEvDlpODhiX02NJ9pOY67sK11cxmAoz0KZ4iRhTzJZiea/LBGalIVAzctnRrPiHrBYV3DO9rsbC/j3C4mi2LnEioL1uZt9fQwjZpo7JUDjDK8uciSunrLmpC9F/HtBhNBlderYdaEkGr0LZK1cd0viW1QWVZdAfJpjxqdpIXV4U4cR565qvP70StVZfJ89MCZ+Bl4hYer//z6E/pIrT//6TarR/KkD7eDxuIUQQ2qGLtSwtTX8GUk/wmJg7dhk23XZwkBbPxA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(86362001)(4326008)(6916009)(478600001)(9686003)(55016002)(52536014)(316002)(8676002)(8936002)(6506007)(76116006)(83380400001)(53546011)(5660300002)(33656002)(66946007)(7696005)(66476007)(71200400001)(64756008)(66446008)(66556008)(54906003)(186003)(26005)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3MGjWFTo2ZU4ZCbR+6IHQrwcQ4g4vXbB58RIWmkzQuvRnOVXKbWbfP8VNGD5?=
 =?us-ascii?Q?oxaj53vYINp7mouOJZGI3dsmCF80XB6dfvGKkeyxKaWarL1KJ8RD47kNLNK0?=
 =?us-ascii?Q?RL4fd7kEbk+iqkXPpwfBVYT2hx8TsNTonHlZhJfWRr8yCnLAX3maQF7JQii1?=
 =?us-ascii?Q?8wgJhUrDbx88D65828294x9uvAYry9tTCCTZJEjkjOuNgwxtwu2KyDtwCcu2?=
 =?us-ascii?Q?gCaeSACvYmxx/DNiXK/Cu1egQimy4PQ3F6wOovAZgd1qCZ6LBv6IQsHiCrzk?=
 =?us-ascii?Q?9q/+N/VUUdsktm6BLvQf1xtUdFzywsuGJnkT+JlhfBGt6l5Y7d38RkXpwVIr?=
 =?us-ascii?Q?nTGW9nNZPK6I/yDyCO8Hy2qC5zFJnrsxJcj8SOZMrhAQIhIF1X+1Z29mvYBM?=
 =?us-ascii?Q?C6B5AffagbpfSe2eJJqYV5PJECih+SDCBpJ43un+uvaXhYZ0BQvhF0XJHdnt?=
 =?us-ascii?Q?f+En+I99x6oceqdZ+nUBm28g1prd2mLfB/s9keiK51cVojF6kgMuxBuD3ZfE?=
 =?us-ascii?Q?pS0CcwFYDjXmJ6amVSQx3EDXvIEdbzrISChcZDfB5ejfwWRiAzCXad47RaDs?=
 =?us-ascii?Q?x7Awz1mwbEc3eGSUWJJ85jN9LFT6vo5GiQfBRcD4HBx54ub6BtIxaWScf0O2?=
 =?us-ascii?Q?Ca1wawdO6wXpea6qYnmWvfpm9esVHAWi6HhWxQFYSirsBVpq1nB/7L09FadV?=
 =?us-ascii?Q?tkmVsBEV7EwkHWJhuAGda3HrdfKfgIbVxIrynpFAWtNdOhl2o/luLDMI+Q0j?=
 =?us-ascii?Q?y7YMuzeF7rierO1wF3Nlsf53OhlMS1/k539Suty4KNcaF2jEz6EAf7ve0KVk?=
 =?us-ascii?Q?wD+1Fdexvwvwmzf0V7qDJrDz/4ZjRHbrMcljklKb8YYvElJkHxBqe9xfrFiR?=
 =?us-ascii?Q?BQCUVWLnc3wT4hKJWdS1s484KtOqOfmPF7v7t1ctphIO46g5EVtIfuiYtOMY?=
 =?us-ascii?Q?rs71e0izfJf03WOWOJb3il/yfJeCqsQDNqWNUUWrQ7A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8a4933b-1c66-468b-e18a-08d89159bb76
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 15:49:45.5452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +ONCjTy4Ri8TikOxVHV9PYP1oHu+EZCRhZ6Ki4qcxnnNq0MBxOfGGZqyIjTKYGgx04JLKjkicabZhFCIZ9v2qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6464
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, November 24, 2020 21:52
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 4/7] dpaa_eth: add XDP_TX support
>=20
> On Mon, Nov 23, 2020 at 07:36:22PM +0200, Camelia Groza wrote:
> > Use an xdp_frame structure for managing the frame. Store a backpointer
> to
> > the structure at the start of the buffer before enqueueing for cleanup
> > on TX confirmation. Reserve DPAA_TX_PRIV_DATA_SIZE bytes from the
> frame
> > size shared with the XDP program for this purpose. Use the XDP
> > API for freeing the buffer when it returns to the driver on the TX
> > confirmation path.
> >
> > The frame queues are shared with the netstack.
>=20
> Can you also provide the info from cover letter about locklessness (is
> that even a word?) in here?

Sure.

> One question below and:
>=20
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>=20
> >
> > This approach will be reused for XDP REDIRECT.
> >
> > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > ---
> > Changes in v4:
> > - call xdp_rxq_info_is_reg() before unregistering
> > - minor cleanups (remove unneeded variable, print error code)
> > - add more details in the commit message
> > - did not call qman_destroy_fq() in case of xdp_rxq_info_reg() failure
> > since it would lead to a double free of the fq resources
> >
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 128
> ++++++++++++++++++++++++-
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.h |   2 +
> >  2 files changed, 125 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index ee076f4..0deffcc 100644
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
> > +			dev_err(dev, "xdp_rxq_info_reg() =3D %d\n", err);
> > +			return err;
> > +		}
> > +
> > +		err =3D xdp_rxq_info_reg_mem_model(&dpaa_fq->xdp_rxq,
> > +						 MEM_TYPE_PAGE_ORDER0,
> NULL);
> > +		if (err) {
> > +			dev_err(dev, "xdp_rxq_info_reg_mem_model() =3D
> %d\n", err);
> > +			xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > +			return err;
> > +		}
> > +	}
> > +
> >  	return 0;
> >  }
> >
> > @@ -1159,6 +1177,11 @@ static int dpaa_fq_free_entry(struct device
> *dev, struct qman_fq *fq)
> >  		}
> >  	}
> >
> > +	if ((dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_DEFAULT ||
> > +	     dpaa_fq->fq_type =3D=3D FQ_TYPE_RX_PCD) &&
> > +	    xdp_rxq_info_is_reg(&dpaa_fq->xdp_rxq))
> > +		xdp_rxq_info_unreg(&dpaa_fq->xdp_rxq);
> > +
> >  	qman_destroy_fq(fq);
> >  	list_del(&dpaa_fq->list);
> >
> > @@ -1625,6 +1648,9 @@ static int dpaa_eth_refill_bpools(struct dpaa_pri=
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
> > @@ -1664,13 +1690,21 @@ static struct sk_buff
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
> > +		xdp_return_frame(swbp->xdpf);
> > +		return NULL;
> > +	}
> > +
> >  	/* DMA unmapping is required before accessing the HW provided
> info */
> >  	if (ts && priv->tx_tstamp &&
> >  	    skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> > @@ -2350,11 +2384,76 @@ static enum qman_cb_dqrr_result
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
>=20
> Not sure if I asked that.  What is the purpose for including the headroom
> in frame being set? I would expect to take into account only frame from
> xdpf->data.

The xdpf headroom becomes the fd's offset, the area before the data where t=
he backpointers for cleanup are stored. This area isn't sent out with the f=
rame.

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
> > @@ -2370,7 +2469,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
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
> > @@ -2381,6 +2481,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> struct qm_fd *fd, void *vaddr,
> >  	case XDP_PASS:
> >  		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> >  		break;
> > +	case XDP_TX:
> > +		/* We can access the full headroom when sending the frame
> > +		 * back out
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
> > @@ -2415,6 +2531,7 @@ static enum qman_cb_dqrr_result
> rx_default_dqrr(struct qman_portal *portal,
> >  	u32 fd_status, hash_offset;
> >  	struct qm_sg_entry *sgt;
> >  	struct dpaa_bp *dpaa_bp;
> > +	struct dpaa_fq *dpaa_fq;
> >  	struct dpaa_priv *priv;
> >  	struct sk_buff *skb;
> >  	int *count_ptr;
> > @@ -2423,9 +2540,10 @@ static enum qman_cb_dqrr_result
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
> > @@ -2494,7 +2612,7 @@ static enum qman_cb_dqrr_result
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
