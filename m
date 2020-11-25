Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 117802C4480
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 16:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731864AbgKYPwj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 10:52:39 -0500
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:64386
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731364AbgKYPwj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 10:52:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDxiS3ajPTyPtSUz0FOKlrysswLXlJ57n/x0FTBu83bjjhwNVokGLTnn/7QX7ESxBxoi1IO/QOiQ4cN1TgVoe5Wa6SXFRgb9vUHCS4CC3bE8891VtS+GijbCY+5qdDdiaSK4douH/P9sPhhEH6r414yktFRV0zT8Du/sYLxEhPUftkUPLxkYendoanmN0r4GldiWvhYmeTNgJHu4W2JVl9UGSiRxofk4JZHkeZPPUMqCWJbdZXrUumPql0XNWQrBmQoYa3WcYlUM2n4anFRwM7Un/wlp57o03/6j3EyFJ9DQBs3TIhNzeXXWd0vBRH/5t4e3HLwTAntHCDVTov0Cmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dz9GrxQ2qV2a5xtYHJIHrteHPsiKjMrYjCo+NsMov10=;
 b=IGXRvHodUvINvh/sgvvFSMJIEsF60/5zCtlJ6i56s2DD1hySoxZZKBaD5+KiftfpGJjvhLN5Wa45mUG0GN4Q5ZdzaYfCp7z6UIjdeqEcqmuWFGaWHBpgJamCUYxZ9MoOF2HRKrEga4K5QZuutnXOEVHIxqbc08Dam3j4nQJRBM1cGprXpjF4SAUwsZuedqcfOvrjJKZD0csXR4S9pE/pU5q0ik7vS7oLx/k66ak1JgIZAvosWzWaoDd1LAkeykVkl8jJkU4HyWyVRGr2zgVLr8Aj4r7ZQi2PVHYiWUHwChODDk1Z873GaHMNKLiYv/Cu9msFREfAeJ1ZPlc0d9y8OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dz9GrxQ2qV2a5xtYHJIHrteHPsiKjMrYjCo+NsMov10=;
 b=VKuz99a3o27M10ECEmOUlcCQxYx/QEixhU6jfaCuWX5d6V5L1afE2teLVLPtybvj/oRZEhxI/Kj4RofY1riE19574gcyV58AwRej6GHNb9/chjVxKLWG+M6qKYHcAFuxOwlFc7SYQ+LJRCFijz6riL947N/s8FWZmVRlao6EW+o=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR04MB4112.eurprd04.prod.outlook.com (2603:10a6:803:45::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Wed, 25 Nov
 2020 15:52:33 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Wed, 25 Nov 2020
 15:52:33 +0000
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
Thread-Index: AQHWwb82V4rZvSFht06Jb/xRZf8LCanXw3EAgAE+V3A=
Date:   Wed, 25 Nov 2020 15:52:33 +0000
Message-ID: <VI1PR04MB5807F77BA161E9BB7729C2B6F2FA0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1606150838.git.camelia.groza@nxp.com>
 <e53e361d320cb901b0d9b9b82e6c16a04fbe6f86.1606150838.git.camelia.groza@nxp.com>
 <20201124205040.GA19977@ranger.igk.intel.com>
In-Reply-To: <20201124205040.GA19977@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: de527dc0-1691-47ad-b35b-08d8915a1f82
x-ms-traffictypediagnostic: VI1PR04MB4112:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB41127A799153FAC7589F0B5DF2FA0@VI1PR04MB4112.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SM6JLLJTF7/diK6kObpx/YTG7tEHsdhokQswAV5EYasdoSW8ApcdKN9ksmePfycUWtmDzxDF9Uv7uD41e2UhBuwzcXLfEGB3YnVOfFsdleZZKYHAj+ctYQvtSZYgEDxTvXpdHcsjhc/9Kxc4vBOLpAzMGb6WeIOYAyfarAE7o1cJvpyVuahXJAsQXwZfn+OlZD26QWNpFPDFgMFSqcqLqfQfzznC4iMdlTdzztA+XRW0etDuyzHtT+QPDQfuNVc+cNFSH3mr+RlEUJF9abpn3tTDw1ZM8okl3mWJROeKSWHjfxiuB5MX/ztjNefSHp4w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(76116006)(53546011)(55016002)(71200400001)(6916009)(54906003)(66946007)(478600001)(52536014)(4326008)(8676002)(316002)(8936002)(7696005)(5660300002)(9686003)(2906002)(66476007)(64756008)(66446008)(186003)(6506007)(66556008)(33656002)(26005)(86362001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SXxDgCr+dV+X2UPbogYi5pZh37ZOigZlo8t/p0UxXKfAdZkUNeucEQpUT/dH?=
 =?us-ascii?Q?UNE1y9NpL6dO5DI0SsEdgIzN6VXE40+HV/iPT0zpIvqL44V+qBGDwtj8IUfR?=
 =?us-ascii?Q?XO7WH91YgznjNFueQFuk6jsOZXJl7sB9RZhLW+kjvyPs8ZK09qZKsCjCUG6E?=
 =?us-ascii?Q?azqKa0+qwMgLHfOP99QwQ26c4y1GueGZQcNibrfNaLb5UeC6pSNY95DQnrpt?=
 =?us-ascii?Q?BuT8taEdJLE8cmkK6ZbZzqwp591KPVcPdmWVC1QrQxsaJgzuq55qo1C4QmnH?=
 =?us-ascii?Q?02RXqKCH30qvFsOHPk1YxIgpiEN2phA4nMmQ6DDCiMQuC09zph6nf/t1k7nm?=
 =?us-ascii?Q?nQl7q/FsC94/gvC2ajaDTreakajKZRCR0m2Fb5o92ofnmy3WretuRPnV7Hel?=
 =?us-ascii?Q?GoVL5YWJW4D7bucGxxopPTcvzmnBPC2D0a+PX9kmBqXobBoDr+7WWQrXFIoJ?=
 =?us-ascii?Q?/AaVj4/mBChnPIK6IEK+jlV7PRFlrBdXwrfOsQW35Wk9bEFR/ZO8TvtgZz3A?=
 =?us-ascii?Q?LR0BG/M2NEC52iMFBEVbBEDqMX+sNcCev3bSFpMS/AP8HkCEgHnyW663Verg?=
 =?us-ascii?Q?L5mp4V5glLaCz87FvFUaC3QpU8vGX1h2bSG2lTZioSlVSmSL8ABrarJTE5rO?=
 =?us-ascii?Q?/wrHOzr3BDzSMddAyW8cPM5vPKuVbWRmjFYOFo60WNV1xuB35zpSSkDBK0tH?=
 =?us-ascii?Q?1h2FYWSMv8tT5rf2DG51s7S01T1F1EvxBHCrm9DRwxCFZCmn/yM1Yb5c3Pve?=
 =?us-ascii?Q?YXWS96SZ3QhL7oCIzy5lp4V4bxy8ofw4BOhgETVQIhv+zoi94Zca347xHasw?=
 =?us-ascii?Q?kZnPQj5+SbVHQlet0JwD9M/Ta0nZGCyn4Am2cvJBiYyMtHbHDgjAWvV2AJWK?=
 =?us-ascii?Q?jW1c/EG08PE1kTvNnHIH4GtGNNXJVqvv9UsFSlrSSkGhn1pVyDfTeBN9sMAx?=
 =?us-ascii?Q?BspsGLnh0h1L7YCEff/f7Mh6+a4Tov4Fv632FdQNqXQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de527dc0-1691-47ad-b35b-08d8915a1f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2020 15:52:33.3419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XNTZZcdWcFzC2+t9g+qibs5m13r244C0dNSUt6JmUv9GtWuKirxH8LI4y7XASrdTgaeuh9+/TgvMOv4aPVsBNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4112
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, November 24, 2020 22:51
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v4 7/7] dpaa_eth: implement the A050385
> erratum workaround for XDP
>=20
> On Mon, Nov 23, 2020 at 07:36:25PM +0200, Camelia Groza wrote:
> > For XDP TX, even tough we start out with correctly aligned buffers, the
> > XDP program might change the data's alignment. For REDIRECT, we have no
> > control over the alignment either.
> >
> > Create a new workaround for xdp_frame structures to verify the erratum
> > conditions and move the data to a fresh buffer if necessary. Create a n=
ew
> > xdp_frame for managing the new buffer and free the old one using the
> XDP
> > API.
> >
> > Due to alignment constraints, all frames have a 256 byte headroom that
> > is offered fully to XDP under the erratum. If the XDP program uses all
> > of it, the data needs to be move to make room for the xdpf backpointer.
>=20
> Out of curiosity, wouldn't it be easier to decrease the headroom that is
> given to xdp rather doing to full copy of a buffer in case you miss a few
> bytes on headroom?

First of all, I'm not sure if offering less than XDP_PACKET_HEADROOM to XDP=
 programs is allowed. Second, we require the data to be strictly aligned un=
der this erratum. This first condition would be broken even if we reduce th=
e size of the offered headroom.

> >
> > Disable the metadata support since the information can be lost.
> >
> > Acked-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
> > Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
> > ---
> >  drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 82
> +++++++++++++++++++++++++-
> >  1 file changed, 79 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > index 149b549..d8fc19d 100644
> > --- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
> > @@ -2170,6 +2170,52 @@ static int dpaa_a050385_wa_skb(struct
> net_device *net_dev, struct sk_buff **s)
> >
> >  	return 0;
> >  }
> > +
> > +static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
> > +				struct xdp_frame **init_xdpf)
> > +{
> > +	struct xdp_frame *new_xdpf, *xdpf =3D *init_xdpf;
> > +	void *new_buff;
> > +	struct page *p;
> > +
> > +	/* Check the data alignment and make sure the headroom is large
> > +	 * enough to store the xdpf backpointer. Use an aligned headroom
> > +	 * value.
> > +	 *
> > +	 * Due to alignment constraints, we give XDP access to the full 256
> > +	 * byte frame headroom. If the XDP program uses all of it, copy the
> > +	 * data to a new buffer and make room for storing the backpointer.
> > +	 */
> > +	if (PTR_IS_ALIGNED(xdpf->data, DPAA_A050385_ALIGN) &&
> > +	    xdpf->headroom >=3D priv->tx_headroom) {
> > +		xdpf->headroom =3D priv->tx_headroom;
> > +		return 0;
> > +	}
> > +
> > +	p =3D dev_alloc_pages(0);
> > +	if (unlikely(!p))
> > +		return -ENOMEM;
> > +
> > +	/* Copy the data to the new buffer at a properly aligned offset */
> > +	new_buff =3D page_address(p);
> > +	memcpy(new_buff + priv->tx_headroom, xdpf->data, xdpf->len);
> > +
> > +	/* Create an XDP frame around the new buffer in a similar fashion
> > +	 * to xdp_convert_buff_to_frame.
> > +	 */
> > +	new_xdpf =3D new_buff;
> > +	new_xdpf->data =3D new_buff + priv->tx_headroom;
> > +	new_xdpf->len =3D xdpf->len;
> > +	new_xdpf->headroom =3D priv->tx_headroom;
>=20
> What if ptr was not aligned so you got here but tx_headroom was less than
> xdpf->headroom? Shouldn't you choose the bigger one? Aren't you shrinking
> the headroom for this case.

Yes, I am shrinking the headroom. At this point, the headroom's content isn=
't relevant anymore (this path is executed when transmitting the frame afte=
r TX or REDIRECT). What is important is the data's alignment, and it is dic=
tated by the headroom's (fd's offset) size.

> > +	new_xdpf->frame_sz =3D DPAA_BP_RAW_SIZE;
> > +	new_xdpf->mem.type =3D MEM_TYPE_PAGE_ORDER0;
> > +
> > +	/* Release the initial buffer */
> > +	xdp_return_frame_rx_napi(xdpf);
> > +
> > +	*init_xdpf =3D new_xdpf;
> > +	return 0;
> > +}
> >  #endif
> >
> >  static netdev_tx_t
> > @@ -2406,6 +2452,15 @@ static int dpaa_xdp_xmit_frame(struct
> net_device *net_dev,
> >  	percpu_priv =3D this_cpu_ptr(priv->percpu_priv);
> >  	percpu_stats =3D &percpu_priv->stats;
> >
> > +#ifdef CONFIG_DPAA_ERRATUM_A050385
> > +	if (unlikely(fman_has_errata_a050385())) {
> > +		if (dpaa_a050385_wa_xdpf(priv, &xdpf)) {
> > +			err =3D -ENOMEM;
> > +			goto out_error;
> > +		}
> > +	}
> > +#endif
> > +
> >  	if (xdpf->headroom < DPAA_TX_PRIV_DATA_SIZE) {
> >  		err =3D -EINVAL;
> >  		goto out_error;
> > @@ -2479,6 +2534,20 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> struct qm_fd *fd, void *vaddr,
> >  	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> >  	xdp.rxq =3D &dpaa_fq->xdp_rxq;
> >
> > +	/* We reserve a fixed headroom of 256 bytes under the erratum and
> we
> > +	 * offer it all to XDP programs to use. If no room is left for the
> > +	 * xdpf backpointer on TX, we will need to copy the data.
> > +	 * Disable metadata support since data realignments might be
> required
> > +	 * and the information can be lost.
> > +	 */
> > +#ifdef CONFIG_DPAA_ERRATUM_A050385
> > +	if (unlikely(fman_has_errata_a050385())) {
> > +		xdp_set_data_meta_invalid(&xdp);
> > +		xdp.data_hard_start =3D vaddr;
> > +		xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > +	}
> > +#endif
> > +
> >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> >
> >  	/* Update the length and the offset of the FD */
> > @@ -2486,7 +2555,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv *priv,
> struct qm_fd *fd, void *vaddr,
> >
> >  	switch (xdp_act) {
> >  	case XDP_PASS:
> > -		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> > +		*xdp_meta_len =3D xdp_data_meta_unsupported(&xdp) ? 0 :
> > +				xdp.data - xdp.data_meta;
>=20
> You could consider surrounding this with ifdef and keep the old version i=
n
> the else branch so that old case is not hurt with that additional branch
> that you're introducing with that ternary operator.

Sure, I'll do that. Thanks.

> >  		break;
> >  	case XDP_TX:
> >  		/* We can access the full headroom when sending the frame
> > @@ -3188,10 +3258,16 @@ static u16 dpaa_get_headroom(struct
> dpaa_buffer_layout *bl,
> >  	 */
> >  	headroom =3D (u16)(bl[port].priv_data_size + DPAA_HWA_SIZE);
> >
> > -	if (port =3D=3D RX)
> > +	if (port =3D=3D RX) {
> > +#ifdef CONFIG_DPAA_ERRATUM_A050385
> > +		if (unlikely(fman_has_errata_a050385()))
> > +			headroom =3D XDP_PACKET_HEADROOM;
> > +#endif
> > +
> >  		return ALIGN(headroom,
> DPAA_FD_RX_DATA_ALIGNMENT);
> > -	else
> > +	} else {
> >  		return ALIGN(headroom, DPAA_FD_DATA_ALIGNMENT);
> > +	}
> >  }
> >
> >  static int dpaa_eth_probe(struct platform_device *pdev)
> > --
> > 1.9.1
> >
