Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF87B1B3967
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 09:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgDVHvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 03:51:51 -0400
Received: from mail-db8eur05on2044.outbound.protection.outlook.com ([40.107.20.44]:6173
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725786AbgDVHvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 03:51:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZhDkFIB60ssBF/3hAknkhHUqBxopw9Vy8KqHi3tmiVaT5uS3js6yYBN1NBoNISRR2bJR3oFO8Ii32V2iaW8aIsKQyibOiGu1aEMtEY+BHPC93Yund9zL8RGHDn5GiNCeYLPLQ7ggsPvAoYXLr+fyzt5feG2DARAfzZTTTGp1zbRGIqqKscR03k5cuP43dENbmxOt/IE9fSqUhvP/NiCuve4RCJ9TBxQP3gO521CtD5GSLCqffDMfMAxoiKhEE2N2lx7lOTqix2C17S7oa1lLNm1hvSDQy/8bUlW2KB9QtR1DuyQZKs7rTfdlhqSnYFlcp9rWkL6BKmkKmMIZYp8nZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pmO4vw+sJNudh9a9z5PbZD5Oh2S3aUTBbmnkTOuZ9A=;
 b=djoFbrMoNKSzO+B4R5OfdRLD1WZjdaGkE/ss3YnSgxCl68KJ6rZbe9N9dnT3lI+0sDi054hY4urlUOFRUc0mR9L8hiAXvro4BXdc+qRJ+geqvwqJYl4rbq3uSjOSjOxBhz4nLCfexEYL7Txze9v6AfXx+GHoA+4viz6SeT+pehkfpAqirmbo80CDevxC+zkqtYiyMQXM3u49rtWqPP8VoH5Qk0dJ4QTLhkARB1LSPMNbDqzQbS19VNW29q1Jg0UiRJjX1hA45n2dfVkuRFxVecU/yw/AjNl6sxY6Vj3ULDH9JUcZ+xIYjbHObTx9xLMaFlxgr5TelQG5urF6p48/cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2pmO4vw+sJNudh9a9z5PbZD5Oh2S3aUTBbmnkTOuZ9A=;
 b=OIhDuh5SHtk3QodbIhgKwapgs0wpN8aXyETr3zDV68yQk9Qw1pjTZLBxHRIoz8q5z5SiLagxrVvS0lP4Hj0RmJ25Gc+ltUIjMCS9TbF9XNSKDVJB0ozrtENr2jOR/KyKT2QyHI6514RFROglztBLF98EnYPyvRL8bCRK6YiBQDo=
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com (2603:10a6:10:113::21)
 by DB8PR04MB7130.eurprd04.prod.outlook.com (2603:10a6:10:123::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 22 Apr
 2020 07:51:46 +0000
Received: from DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d]) by DB8PR04MB6828.eurprd04.prod.outlook.com
 ([fe80::58e6:c037:d476:da0d%8]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 07:51:46 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in .ndo_xdp_xmit
Thread-Topic: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in
 .ndo_xdp_xmit
Thread-Index: AQHWF/CxxvxMQFGarE6TYAS6knCRDKiEut8AgAAHhzA=
Date:   Wed, 22 Apr 2020 07:51:46 +0000
Message-ID: <DB8PR04MB6828FCFAC2B6755E046B0B05E0D20@DB8PR04MB6828.eurprd04.prod.outlook.com>
References: <20200421152154.10965-1-ioana.ciornei@nxp.com>
        <20200421152154.10965-5-ioana.ciornei@nxp.com>
 <20200422091226.774b0dd7@carbon>
In-Reply-To: <20200422091226.774b0dd7@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [188.25.102.96]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9acf0c08-d37b-4c4d-bc7d-08d7e6920206
x-ms-traffictypediagnostic: DB8PR04MB7130:
x-microsoft-antispam-prvs: <DB8PR04MB713025A5C81BA46C178989DCE0D20@DB8PR04MB7130.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 03818C953D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6828.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(52536014)(5660300002)(81156014)(6506007)(66946007)(66476007)(66446008)(6916009)(66556008)(86362001)(4326008)(76116006)(71200400001)(33656002)(8936002)(8676002)(54906003)(55016002)(316002)(478600001)(2906002)(186003)(64756008)(9686003)(26005)(7696005)(44832011)(142923001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sb7qjqjB3ghV1SRvGW7ZkeQdUirVWsxLwC5lSFE5c9HVUbN/idOWoXrOkLqB4bTNyP7/TevFy36nx2LPkzR4pgsGzHI1YoF1PS1exhmZXOVwAiDLaxzWxSnL2oYqULs2sOYO+NRAKA6g8DKRggE0lKvfqWeDxW2Mh137b/FEbdZKBbHX9QKgC4uCY4facrm5U/iyhVxr9/Ajxmw+OB7pw9xBRJNA8juym7fjyGGNrJJ2DQ+JIFM344kn2KWuAie9HTL4vVuPMboVr19oOuVFWcpLLG03gDt9cWf3c3kpuKd7QDbDSzKU76ol45DS0Is8Z7KSKUiRDjx0WkHh5Ip4dDVtN51funEGpNBR3ZGCgMjUApdMJM9qwaZ7UoXEI+/Jw6cX4naQErI+bg3ToYMil6AKeiJqp/8FDW0UBuAfTj8Hkgc6Onoeb5pqGGPkh59Nx4I9iOsnZYzBi9jpY91UJFoQW1kRFa3pdrxDvoikzSKyfYv00kzD0yrXGFblKcWm
x-ms-exchange-antispam-messagedata: gfAT64mCdsuFdeu+nC7eC2TrIFn5ocujfSkMXw39vT47g/21bw+XRaUGP+PKmiQXgcNiTrV7ZNNvjANInWVSQR6Sm+9uHX3fDdJ5r41PZvRsEvAvSbqIcEVdXmgxNtt/S2PkqCj/Q37GVYlOjiSZyQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acf0c08-d37b-4c4d-bc7d-08d7e6920206
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2020 07:51:46.8221
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: atwELJ0+DY+XK5Va8/LATdiYSEuPisPyomYSzbPYJCGGEN2YfhiiHjj5hDVGZbicgwVg5nZhp38FqUQsOIl94A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next 4/4] dpaa2-eth: use bulk enqueue in
> .ndo_xdp_xmit
>=20
> On Tue, 21 Apr 2020 18:21:54 +0300
> Ioana Ciornei <ioana.ciornei@nxp.com> wrote:
>=20
> > Take advantage of the bulk enqueue feature in .ndo_xdp_xmit.
> > We cannot use the XDP_XMIT_FLUSH since the architecture is not capable
> > to store all the frames dequeued in a NAPI cycle so we instead are
> > enqueueing all the frames received in a ndo_xdp_xmit call right away.
> >
> > After setting up all FDs for the xdp_frames received, enqueue multiple
> > frames at a time until all are sent or the maximum number of retries
> > is hit.
> >
> > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > ---
> >  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 60
> > ++++++++++---------
> >  1 file changed, 32 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > index 9a0432cd893c..08b4efad46fd 100644
> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> > @@ -1933,12 +1933,12 @@ static int dpaa2_eth_xdp_xmit(struct net_device
> *net_dev, int n,
> >  			      struct xdp_frame **frames, u32 flags)  {
> >  	struct dpaa2_eth_priv *priv =3D netdev_priv(net_dev);
> > +	int total_enqueued =3D 0, retries =3D 0, enqueued;
> >  	struct dpaa2_eth_drv_stats *percpu_extras;
> >  	struct rtnl_link_stats64 *percpu_stats;
> > +	int num_fds, i, err, max_retries;
> >  	struct dpaa2_eth_fq *fq;
> > -	struct dpaa2_fd fd;
> > -	int drops =3D 0;
> > -	int i, err;
> > +	struct dpaa2_fd *fds;
> >
> >  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
> >  		return -EINVAL;
> > @@ -1946,41 +1946,45 @@ static int dpaa2_eth_xdp_xmit(struct net_device
> *net_dev, int n,
> >  	if (!netif_running(net_dev))
> >  		return -ENETDOWN;
> >
> > +	/* create the array of frame descriptors */
> > +	fds =3D kcalloc(n, sizeof(*fds), GFP_ATOMIC);
>=20
> I don't like that you have an allocation on the transmit fast-path.
>=20
> There are a number of ways you can avoid this.
>=20
> Option (1) Given we know that (currently) devmap will max bulk 16 xdp_fra=
mes,
> we can have a call-stack local array with struct dpaa2_fd, that contains =
16
> elements, sizeof(struct dpaa2_fd)=3D=3D32 bytes times 16 is
> 512 bytes, so it might be acceptable.  (And add code to alloc if n > 16, =
to be
> compatible with someone increasing max bulk in devmap).
>=20

I didn't know about the 16 max xdp_frames . Thanks.

> Option (2) extend struct dpaa2_eth_priv with an array of 16 struct dpaa2_=
fd's,
> that can be used as fds storage.

I have more of a noob question here before proceeding with one of the two o=
ptions.

The ndo_xdp_xmit() callback can be called concurrently from multiple softir=
q contexts, right?

If the above is true, then I think the dpaa2_eth_ch_xdp is the right struct=
 to place the array of 16 FDs.

Also, is there any caveat to just use DEV_MAP_BULK_SIZE when declaring the =
array?

Ioana

>=20
> > +	if (!fds)
> > +		return -ENOMEM;
> > +
>=20
> [...]
> > +	kfree(fds);
>=20
>=20

