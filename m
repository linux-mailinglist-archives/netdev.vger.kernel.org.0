Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E39F2C26CB
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387856AbgKXNGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:06:23 -0500
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:61006
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387839AbgKXNGR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 08:06:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HB3sYbhfzP5yYijRzg6NtdC0as/OuueU42WQjYliqTv9iGlKb5axAFz8xjKXhYmq7ysrFHteiaBgA6lhGQRhIxa7crm6IROpkbSS0T2I4ZooOaDRuEv15hDjEhKIsx+EYB+usb/XGGww/u4FMZPPbarW5UqDcYMDnYZsSYtfvlQbJlr/eTd0Ps7t3hVmSXkgFOil8T4ma4b6mnVi7CvnkgYdU++HXOzoul5uGsi3MSZqcdx3pusGl+4LOsfjpkgaQiOXOxNLakl2MQqmHvKwd0zRHOgEshyyBgFyC6fY4ej6hD4opzeKLqD9x8jeWhWr8y9anCHaufdN7ifppgXomA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhPE7PHdKrt6yoJvqA4Hjvp1wYW00Lmo1qECV81jaD4=;
 b=KgckKWOLFyx/+sMP6xUxxWXFkgaMLVNpBxuGrrXKVpAO1Zf+KRdDBk0Nx1Rkm79NZGvR8pNF69zbWTT9+ESoSpmrPR1mMLzX3PByzZDPEhB9W12x/zXVCsOBzVBcZ1ZxWWflsifOPqDtg0QydhqC6gjehxCNx7J5XSSybsYPb2wdCpApdOxMIlwqyBPxx4bXocBfhVLMR8rugOH37MBi/Ri+j95hD2WsP3DKrVhSDCMNAB+bw7kMgxGFFYO7Q1QedR8A2YkYcNTaNx/Z16MjP6jfpxzfZCUFZTuu/ioLjqubCL7DrRM76LtNjZyMPNHIxgSxxN4fnDwlCNiYzCWjBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhPE7PHdKrt6yoJvqA4Hjvp1wYW00Lmo1qECV81jaD4=;
 b=PX0OEXUqJXjTDr5of+cGYAPnVRwk+CvIzpvBlMXx9aUWfhlmy7wou5EnpbMp242GBzNXGntafRtAtVjCTCbruXKnQhCVBZy+ZNDTTGNA2biEJf+SEHNQI+3bsBvp37DaxQjZikfU3LexvJC3YcOmGIBOn/hLUldwWo86mQ/ppqc=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VI1PR0401MB2430.eurprd04.prod.outlook.com (2603:10a6:800:2b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 24 Nov
 2020 13:06:10 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::45b9:4:f092:6cb6%3]) with mapi id 15.20.3589.024; Tue, 24 Nov 2020
 13:06:09 +0000
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
Thread-Index: AQHWvpEwdu5a75WTZUGsTgQMlE9GsKnQIGgAgAE+gICABPEZgIAA8pJA
Date:   Tue, 24 Nov 2020 13:06:09 +0000
Message-ID: <VI1PR04MB5807F31980912EE063F00BF0F2FB0@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <cover.1605802951.git.camelia.groza@nxp.com>
 <aa8bbb5c404f57fdb7915eb236305a177800becb.1605802951.git.camelia.groza@nxp.com>
 <20201119235034.GA24983@ranger.igk.intel.com>
 <VI1PR04MB5807F56500D25ECD20657618F2FF0@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <20201123221829.GC11618@ranger.igk.intel.com>
In-Reply-To: <20201123221829.GC11618@ranger.igk.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [82.78.148.61]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 43626296-d6d8-400c-6e07-08d89079b67a
x-ms-traffictypediagnostic: VI1PR0401MB2430:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0401MB24304A9D396EED3F3A426AE9F2FB0@VI1PR0401MB2430.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: De6Hh+1f8Kjncx600BvM/nTt+CdLPn/bW6W6yq+s7UQafiFOgMcerqyLDBPatNZgIRsuv+8igE4A60sLq7zah/V8SDLBo1cBMv34rHsN+Xyn4xeeapZqIPcewyarPRkRldno3bL9D67WTCvcALWgU9m9QBRRVsuKyNb73Xgl+++DyhgoryHdgHe6o0whmeWu6nxChn29G2+Z4tDXdm8ChJx3ham8i4C8NagFRVK9CtYUJutm169T1pmfNoTV2IiO7VA9ID5tqwJw034FWqcWDaYHP7RKMFz3M3gu51p+juEfaMhblkk7q23u1F0x/Idc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(376002)(136003)(6506007)(26005)(76116006)(2906002)(5660300002)(66556008)(9686003)(86362001)(478600001)(55016002)(64756008)(66476007)(7696005)(66446008)(33656002)(66946007)(53546011)(52536014)(186003)(6916009)(54906003)(316002)(71200400001)(8936002)(4326008)(8676002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jybKugz8EF/9v0dssXdilZ/QseRFwUZfuUfp/ueCQKDfdYzbtuTqUgbQ9VhB?=
 =?us-ascii?Q?eCGmUoRK5aP7nZIJ3hL7ROde5rEiEbi2mVYAvtYpTHBrl44P1FUJ/2PyzGsQ?=
 =?us-ascii?Q?rlPu2EoMyinz1HKtJ/TMMgMapvPUDrVT6cZd/9gP1Ma8tzSgfi366kW745QU?=
 =?us-ascii?Q?MkIM1v0chDDmrvcSg5RK/WQ7IU5JezUMFGGXwRUhNXOUCshIoTfDM8N00gP4?=
 =?us-ascii?Q?2Vmzm8IzxnDOmMvd5/Ju8NM6yn8/7/MjTJwNjUHQBdTTU31zOkeZs4wMfuOR?=
 =?us-ascii?Q?dP4J6zYkpsv6qcIfVjWazQE2BjGMcqqpHLyFeHF31joR51lhg03KXmC1nX8U?=
 =?us-ascii?Q?czdLir2xzFFH9raPdBBW4ZPA93nu+EAhcxhr5+rEZoSSC3nI+PEII8Sdp0yq?=
 =?us-ascii?Q?+WoonU71hLXZ16jVOSsog1Ci+odIl7InFM1JjwA/TIuvtHJU6fa72ILsZGnv?=
 =?us-ascii?Q?Yof51/JPSlGhpCgp9FKhaslCu/sPIoy/NYueHmvtlkvazVwM01S5Ibl+ejMD?=
 =?us-ascii?Q?XBygpBn5CR8SBmhvIeM3GYaYUbpVMILYoL3+op70HJwT/psKcBPlcImaBjh6?=
 =?us-ascii?Q?BDbCDSUUF03I5UD1ye2//XqAMlnr2I3pKXDk/djFX/zszJS3i3akBAvrTw/O?=
 =?us-ascii?Q?FjslrYfksMY5YG8vuE5QN9Vkm+sx3zky5wR+IZASGV0Pw9tYP/x5bGg/HYu7?=
 =?us-ascii?Q?xdND/dOPsgOt0kC9qlTk24md+5htlx+Gbc+ok/8V/YMSpDAohu5TKyEsy5Nu?=
 =?us-ascii?Q?F6QwJoYZcPrawBFyMj1K6rckALAdeIZ3XibjPF9zWZdMsO3eOC407oRueVDM?=
 =?us-ascii?Q?JVYgX4lIsRF7htRqwImdszY8qxDjzOkjnFexK5lamGcRHvtaZ1jN4rTcOe76?=
 =?us-ascii?Q?v2CySE4TU8/JPoeCNDJm3fZ/cqdztKPF2IcsXQNyl63F2Qi+4sJ7E2WEEmKj?=
 =?us-ascii?Q?FCJS61nc7WTbLbT5cMYDwsMs6xcTdJzoUfFnMTFN9E0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43626296-d6d8-400c-6e07-08d89079b67a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2020 13:06:09.8595
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bv5fyOctYwY4KarTG5RHY3V43d/bvP8RKTxugYF1le9y4oHcB1Fld92nzcldZoDbyJ6DkKTlvgF8R9mr7M2nyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2430
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Sent: Tuesday, November 24, 2020 00:18
> To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> davem@davemloft.net; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> netdev@vger.kernel.org
> Subject: Re: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
>=20
> On Fri, Nov 20, 2020 at 06:54:42PM +0000, Camelia Alexandra Groza wrote:
> > > -----Original Message-----
> > > From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > Sent: Friday, November 20, 2020 01:51
> > > To: Camelia Alexandra Groza <camelia.groza@nxp.com>
> > > Cc: kuba@kernel.org; brouer@redhat.com; saeed@kernel.org;
> > > davem@davemloft.net; Madalin Bucur (OSS)
> > > <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>;
> > > netdev@vger.kernel.org
> > > Subject: Re: [PATCH net-next v3 4/7] dpaa_eth: add XDP_TX support
> > >
> > > On Thu, Nov 19, 2020 at 06:29:33PM +0200, Camelia Groza wrote:
> > > > Use an xdp_frame structure for managing the frame. Store a
> backpointer
> > > to
> > > > the structure at the start of the buffer before enqueueing. Use the=
 XDP
> > > > API for freeing the buffer when it returns to the driver on the TX
> > > > confirmation path.
> > >
>=20
> [...]
>=20
> > > >  static u32 dpaa_run_xdp(struct dpaa_priv *priv, struct qm_fd *fd, =
void
> > > *vaddr,
> > > > -			unsigned int *xdp_meta_len)
> > > > +			struct dpaa_fq *dpaa_fq, unsigned int
> > > *xdp_meta_len)
> > > >  {
> > > >  	ssize_t fd_off =3D qm_fd_get_offset(fd);
> > > >  	struct bpf_prog *xdp_prog;
> > > > +	struct xdp_frame *xdpf;
> > > >  	struct xdp_buff xdp;
> > > >  	u32 xdp_act;
> > > >
> > > > @@ -2370,7 +2470,8 @@ static u32 dpaa_run_xdp(struct dpaa_priv
> *priv,
> > > struct qm_fd *fd, void *vaddr,
> > > >  	xdp.data_meta =3D xdp.data;
> > > >  	xdp.data_hard_start =3D xdp.data - XDP_PACKET_HEADROOM;
> > > >  	xdp.data_end =3D xdp.data + qm_fd_get_length(fd);
> > > > -	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > > > +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> > > > +	xdp.rxq =3D &dpaa_fq->xdp_rxq;
> > > >
> > > >  	xdp_act =3D bpf_prog_run_xdp(xdp_prog, &xdp);
> > > >
> > > > @@ -2381,6 +2482,22 @@ static u32 dpaa_run_xdp(struct dpaa_priv
> *priv,
> > > struct qm_fd *fd, void *vaddr,
> > > >  	case XDP_PASS:
> > > >  		*xdp_meta_len =3D xdp.data - xdp.data_meta;
> > > >  		break;
> > > > +	case XDP_TX:
> > > > +		/* We can access the full headroom when sending the frame
> > > > +		 * back out
> > >
> > > And normally why a piece of headroom is taken away? I probably should
> > > have
> > > started from the basic XDP support patch, but if you don't mind, plea=
se
> > > explain it a bit.
> >
> > I mentioned we require DPAA_TX_PRIV_DATA_SIZE bytes at the start of
> the buffer in order to make sure we have enough space for our private inf=
o.
>=20
> What is your private info?

The dpaa_eth_swbp struct from the first patch. It's the xdp_frame reference=
 mentioned in the patch description, stored for cleanup on confirmation. We=
 also store a skb reference for non-XDP use cases.

> >
> > When setting up the xdp_buff, this area is reserved from the frame size
> exposed to the XDP program.
> >  -	xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> >  +	xdp.frame_sz =3D DPAA_BP_RAW_SIZE - DPAA_TX_PRIV_DATA_SIZE;
> >
> > After the XDP_TX verdict, we're sure that DPAA_TX_PRIV_DATA_SIZE
> bytes at the start of the buffer are free and we can use the full headroo=
m
> how it suits us, hence the increase of the frame size back to
> DPAA_BP_RAW_SIZE.
>=20
> Not at the *end* of the buffer?

No, we store this information at the start of the buffer, before the XDP_PA=
CKET_HEADROOM.
=20
> >
> > Thanks for all your feedback.
> >
> > > > +		 */
> > > > +		xdp.data_hard_start =3D vaddr;
> > > > +		xdp.frame_sz =3D DPAA_BP_RAW_SIZE;
> > > > +		xdpf =3D xdp_convert_buff_to_frame(&xdp);
> > > > +		if (unlikely(!xdpf)) {
> > > > +			free_pages((unsigned long)vaddr, 0);
> > > > +			break;
> > > > +		}
> > > > +
> > > > +		if (dpaa_xdp_xmit_frame(priv->net_dev, xdpf))
> > > > +			xdp_return_frame_rx_napi(xdpf);
> > > > +
> > > > +		break;
> > > >  	default:
> > > >  		bpf_warn_invalid_xdp_action(xdp_act);
> > > >  		fallthrough;
> > > > @@ -2415,6 +2532,7 @@ static enum qman_cb_dqrr_result
