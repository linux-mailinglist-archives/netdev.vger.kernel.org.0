Return-Path: <netdev+bounces-8650-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F887250F9
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 01:57:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C9F231C20BE0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 23:57:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE73034D6E;
	Tue,  6 Jun 2023 23:57:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD76E7E4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 23:57:55 +0000 (UTC)
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2121.outbound.protection.outlook.com [40.107.113.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B8E11A;
	Tue,  6 Jun 2023 16:57:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LjZqo1iKQz0Xc9ShzHvpHsbXd66eeQUzg/mSxuNVWXOH48jl+6CdPvq8x1EMclxd/FtTXdgKOsy+DhqDTY/pvOWYlUNs6oHwb8q4R3RORkPuvTRLX+b7z0rKNw7C6OcoQn2MUnLvGHmhZnOssilvlPd5MaPd1rvv/qenu9O3Dxz8UuRxRSMh1RvtikJqj49yNVhoq1Ez9ormeDeScE+dPBnC8pR0ZD6rKITY61VPbvsU+2h7ROODJwE/peJ30xa1FkqYbP+Oy2EB9XCHkXOUBmJWt/ZChDHqQAxgzZOEy5X12nefL69Z5fvJJ7ucnM4MefgBwFwuMEVbudWqe4PYpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BK2DE6z1iCc1nhIgRWo+daJQYX8L9/ByU1FdAJX32nc=;
 b=eg7vMqeekq5HNcg6jf5zC+LSnGtP0dBjfgc4p9hsZRYcDLLn2EiBsnaZTl2cXBbg9qWv5W6/j10zsuYkywhcKWJXHAs/MWY8LfccPeY7Ei1YWMrGKu76yZb/cguL/mk0G4Dmg5fJSfSLSILmGkEjdiCmgv+PhiimjwOSaVZsRGelwg+7kbr8m8UGG81ZOoImJ6tpxtQP9MAJKOX+xtVu17pTu94tchbyISUK2ItAfqHwAiTiX/m2HmWb0Y8ITBx4iuMHvKbD4MeiOcSHtMMWpJGqGsD9WZ+uDZfIn66s+wiRd/oKHhzq56ZvlgTD+5kBQt3DGNtKN2e81oA8sclaNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BK2DE6z1iCc1nhIgRWo+daJQYX8L9/ByU1FdAJX32nc=;
 b=Gj8VNBWdWWelA8arQqFxPaaOXlwMzqUDhbxtpru+AqOBNbvRhj89uD2GoCeVomuNYoi4wvWdaMO4wxJIVPY3SnVAa4oye1XHLWVAfZOOwdP8e3bXvyi3D8apy7MvJ23JmvwCnEjdNqmbuT9Q5WP3u0XtW3Xo8s9LjNfYZURIC54=
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 (2603:1096:404:8028::13) by TYAPR01MB5404.jpnprd01.prod.outlook.com
 (2603:1096:404:8030::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 23:57:50 +0000
Received: from TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1]) by TYBPR01MB5341.jpnprd01.prod.outlook.com
 ([fe80::711d:f870:2e08:b6e1%3]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 23:57:50 +0000
From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: "s.shtylyov@omp.ru" <s.shtylyov@omp.ru>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-renesas-soc@vger.kernel.org" <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/2] net: renesas: rswitch: Use hardware pause
 features
Thread-Topic: [PATCH net-next v2 2/2] net: renesas: rswitch: Use hardware
 pause features
Thread-Index: AQHZmFS79DoiVT5Vgkyv7LZ1N2TEja9+DzqAgABkkOA=
Date: Tue, 6 Jun 2023 23:57:50 +0000
Message-ID:
 <TYBPR01MB5341534AB8479C3AC0510259D852A@TYBPR01MB5341.jpnprd01.prod.outlook.com>
References: <20230606085558.1708766-1-yoshihiro.shimoda.uh@renesas.com>
 <20230606085558.1708766-3-yoshihiro.shimoda.uh@renesas.com>
 <ZH9y13KXF128Dgbf@boxer>
In-Reply-To: <ZH9y13KXF128Dgbf@boxer>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYBPR01MB5341:EE_|TYAPR01MB5404:EE_
x-ms-office365-filtering-correlation-id: f2b72f6d-f7b6-4f58-74ef-08db66e9d5fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 GDXsPnp40wXmTkBEZHzDYBMt7ZgHoRDYdmh+LJ14onqcn8SQkv8uMSirFnq+LM/+0kh32Z0gGkIjgC+IsFzyrXzYALGo9Ph6TvVCL7ftP+zEGaqoLY/NVoRxa13PpObDo+fBzw+9IqGTjBXfF6XPxtvbmUdVo+nhmxHFk+HaAs0PKqnAyV6qHiWaL8bjkb4SwbJXsGPss+I1L9w2T4IHmN0k7Dw+3aRGvdXnredVnaBfYR0JTOjwyPLs0CQVgQafV1xDXx99UkKabrry7Z1em/5CzaHvgjgMGDja5Yv6ODaSsZ7hZytcLAFAwv2q4Lno0Mu+muVOWkgmhcMv2vgQfL1W6hR+yhbmI0jnmzRIvbGZ6Hra4Ndinay0JLRs4wjAAcOyDvcMcWgTLNpscwFhSAwOPw5JAUIXhbw/EjOTLoikfWU+jd5uXjIdMsAqVwKumAXyUF29jGek4LIh2QrzWvgeNGPhcqVrfHEYJeYIQflDpWjlP+VJ2uybwCGcUAjGlVPxiaJ8P9rRQMYo8+3j6FG+3LjfCevZXpg4EjyiQq/VUd1h8aoaMCubwJakFJhCYbunrIgEx1/eJJciWySvZvS++elsNExm18rvua22Gdf1pkVmnErZZRcS2+Wjm3vA
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYBPR01MB5341.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(316002)(7696005)(41300700001)(83380400001)(86362001)(38070700005)(6506007)(9686003)(186003)(2906002)(33656002)(122000001)(38100700002)(55016003)(5660300002)(52536014)(8676002)(8936002)(66946007)(66556008)(66476007)(66446008)(64756008)(76116006)(54906003)(478600001)(71200400001)(4326008)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?wWHUt4enCS4rHKKxiwOhpQ8mFLD2m+3c7xjWIbZv5uCZ+sIuAYdhtB8/dmMu?=
 =?us-ascii?Q?ezsNnwgGgw21LVR+RvETi10uN+tRUDm9toFpYA4PIGVp9/Nb+EHOyqM5CgXZ?=
 =?us-ascii?Q?fdQTA4Z288R8+ZoA09VkcY5Ql+FGYkmNDUIpmmeNR6LtN1ZVXi4VyFTrcIzg?=
 =?us-ascii?Q?ZGzKUZyaXXmNe4+ec68cxEWcenWQW5uRMki+4kDHTSJEKSTHZXku4PB/ZF/8?=
 =?us-ascii?Q?TVzjl6I5JmUSjp51r2zTZ2VURHlrbv7/Wn67T/JfsXC2LV6yW//SVPP6pY3+?=
 =?us-ascii?Q?aW4EBIBva+YC5ReC0k72lD89oFJ8fqhdtn/m73RC75dFBk5fEVU8IhesslGs?=
 =?us-ascii?Q?gvdhi25ai2ysLU7sYxSGHIzLh9fkWAV34tQhlpr8oVzv5MEpyyhoqfDgj+a5?=
 =?us-ascii?Q?1EeGpfIblQnLeNfsjq/D1vgWakGHxmj+XTukDHCrM3uECBDf4od5sNh+hLGO?=
 =?us-ascii?Q?GnLOT8DvAu5S+n0rsa1UTN/i5fM9+Y/mo8IqQU/Uq2B7JLZ7nkfwnxgOH62u?=
 =?us-ascii?Q?wNhuldjHtiTYxlM6vtW4inDwhVXZD9MBbRQyeRbxfsNN/9OC5DZG2tDuquhX?=
 =?us-ascii?Q?3wReUu+QcYGo0+URlJQJuDDcPQExirVMrnVwwjieRi0GNxe7PIZ07UqtcXUo?=
 =?us-ascii?Q?0mPQvc+R+NWYEfbADY+D51q+L95VfOmcyo4XcYP2sAttsUMl0wL3beyM/gRl?=
 =?us-ascii?Q?vvgpHfMWiV5w+XMcAmM8RTutIR6hnK/exb5KoJea65/AIwlzmDkv+3JNp3iE?=
 =?us-ascii?Q?OJe4r+lFlJO/to7FxF3ksySCKfxgsoLgb+PlyodyfP+K3Nbip2izWScn5DxT?=
 =?us-ascii?Q?6R5PyLZaL3Jk1R5YgIRV8trOwBmy1G9lq7D2Vl310DQ6XWDVZw0g69zjdpTw?=
 =?us-ascii?Q?yoimoR+RGH5KQMhpFhF6KmnGmAY8zj+eOdzrlrVd/sWXoVMz9HT8f2h5Q0a/?=
 =?us-ascii?Q?8Pki6QnRzl7FLUFakbNU6BZhwVGpHNJ/GN8QdWIA0uTR88BdNI3jgO6h6ZRG?=
 =?us-ascii?Q?xVV2DbulhZ0o98wmGIN1NPKtKh6YBd2D52ymAa0qiZIHMAGxACufJCUCIuCP?=
 =?us-ascii?Q?FTpathz4nEieq16uiiV9ls7GbrRF2xY2uS5pi5Se4sA7/jF6igwme8FMOGKV?=
 =?us-ascii?Q?WfcsRUg4fklhYuhNGk663uWZg2HL/N8vePJhF+uRx+euVmr5wjpPdvPxHRql?=
 =?us-ascii?Q?9dlMwSgkJF2QVvgnAcwbiBTogDakb0+D3c5BuIIY8eEIOBklx6Z/lqW0pi8u?=
 =?us-ascii?Q?z3pLNDNcmP6y+1Qx1ZuojkfWwALyPVj8TlMlzA6lWPHh9X7K0c8mAsucXr4I?=
 =?us-ascii?Q?qUhFQsWAKB3OrItAkzlyumas/UW+LG/jeEBldkTqFIhdSRmiwvsguimmB2TW?=
 =?us-ascii?Q?lq7nrhOoA7ICiyve2Aocd9AwX5AkwBYjJ/TASK9t7Vc+w/rlkNQfGWmciRbg?=
 =?us-ascii?Q?CjM681V5s1PtSWdh6O9b76uR83Ctzx4gp4zmlLfUBUXPuQZvdNneLbSN0la7?=
 =?us-ascii?Q?4Fs1uhTiYuHydNF6TGLrp2prLsKqrhIkFsqIJtqjCX3wtlQx9u9kTmPFMOvX?=
 =?us-ascii?Q?Q5JNQFB/9FJ4PfhpIq9VrFlpMfLtsFrPSOYm0ArWCkyiGUYdUaxSqbcRP1DD?=
 =?us-ascii?Q?iEiWXSCrEC7h9p6ELDsbIm0uo32DZcgPmw6C/Sd1XQOZmzusEWaAHt8QvPu+?=
 =?us-ascii?Q?bZYT6Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYBPR01MB5341.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b72f6d-f7b6-4f58-74ef-08db66e9d5fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 23:57:50.6162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W/E3C5lwACUeyuYcblXI4FOz6Kvd+1pT0dzwpFWfH6lbnu14NZ5LpxMKXXKEUSPr00klGswHSwGeDa+45XyxnY46YkmmdLpplkvZ9oi1yaA2kiw/aLHIWqEcHD8tTmeW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5404
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Maciej,

> From: Maciej Fijalkowski, Sent: Wednesday, June 7, 2023 2:55 AM
>=20
> On Tue, Jun 06, 2023 at 05:55:58PM +0900, Yoshihiro Shimoda wrote:
> > Use "per priority pause" feature of GWCA and "global pause" feature of
> > COMA instead of "global rate limiter" of GWCA. Otherwise TX performance
> > will be low when we use multiple ports at the same time.
>=20
> does it mean that global pause feature is completely useless?

The global rate limiter is useless, not global pause. I'll revise this
description on v2.

> >
> > Note that these features are not related to the ethernet PAUSE frame.
> >
> > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > ---
> >  drivers/net/ethernet/renesas/rswitch.c | 36 ++++++++++----------------
> >  drivers/net/ethernet/renesas/rswitch.h |  6 +++++
> >  2 files changed, 20 insertions(+), 22 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ether=
net/renesas/rswitch.c
> > index 7bb0a6d594a0..84f62c77eb8f 100644
> > --- a/drivers/net/ethernet/renesas/rswitch.c
> > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > @@ -90,6 +90,11 @@ static int rswitch_bpool_config(struct rswitch_priva=
te *priv)
> >  	return rswitch_reg_wait(priv->addr, CABPIRM, CABPIRM_BPR, CABPIRM_BPR=
);
> >  }
> >
> > +static void rswitch_coma_init(struct rswitch_private *priv)
> > +{
> > +	iowrite32(CABPPFLC_INIT_VALUE, priv->addr + CABPPFLC0);
> > +}
> > +
> >  /* R-Switch-2 block (TOP) */
> >  static void rswitch_top_init(struct rswitch_private *priv)
> >  {
> > @@ -156,24 +161,6 @@ static int rswitch_gwca_axi_ram_reset(struct rswit=
ch_private *priv)
> >  	return rswitch_reg_wait(priv->addr, GWARIRM, GWARIRM_ARR, GWARIRM_ARR=
);
> >  }
> >
> > -static void rswitch_gwca_set_rate_limit(struct rswitch_private *priv, =
int rate)
> > -{
> > -	u32 gwgrlulc, gwgrlc;
> > -
> > -	switch (rate) {
> > -	case 1000:
> > -		gwgrlulc =3D 0x0000005f;
> > -		gwgrlc =3D 0x00010260;
> > -		break;
> > -	default:
> > -		dev_err(&priv->pdev->dev, "%s: This rate is not supported (%d)\n", _=
_func__, rate);
> > -		return;
> > -	}
> > -
> > -	iowrite32(gwgrlulc, priv->addr + GWGRLULC);
> > -	iowrite32(gwgrlc, priv->addr + GWGRLC);
> > -}
> > -
> >  static bool rswitch_is_any_data_irq(struct rswitch_private *priv, u32 =
*dis, bool tx)
> >  {
> >  	u32 *mask =3D tx ? priv->gwca.tx_irq_bits : priv->gwca.rx_irq_bits;
> > @@ -402,7 +389,7 @@ static int rswitch_gwca_queue_format(struct net_dev=
ice *ndev,
> >  	linkfix->die_dt =3D DT_LINKFIX;
> >  	rswitch_desc_set_dptr(linkfix, gq->ring_dma);
> >
> > -	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DQT : 0) | GWDCC_EDE,
> > +	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DCP(GWCA_IPV_NUM) | GWDCC_=
DQT : 0) | GWDCC_EDE,
> >  		  priv->addr + GWDCC_OFFS(gq->index));
> >
> >  	return 0;
> > @@ -500,7 +487,8 @@ static int rswitch_gwca_queue_ext_ts_format(struct =
net_device *ndev,
> >  	linkfix->die_dt =3D DT_LINKFIX;
> >  	rswitch_desc_set_dptr(linkfix, gq->ring_dma);
> >
> > -	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DQT : 0) | GWDCC_ETS | GWD=
CC_EDE,
> > +	iowrite32(GWDCC_BALR | (gq->dir_tx ? GWDCC_DCP(GWCA_IPV_NUM) | GWDCC_=
DQT : 0) |
> > +		  GWDCC_ETS | GWDCC_EDE,
> >  		  priv->addr + GWDCC_OFFS(gq->index));
> >
> >  	return 0;
> > @@ -649,7 +637,8 @@ static int rswitch_gwca_hw_init(struct rswitch_priv=
ate *priv)
> >  	iowrite32(lower_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + G=
WTDCAC10);
> >  	iowrite32(upper_32_bits(priv->gwca.ts_queue.ring_dma), priv->addr + G=
WTDCAC00);
> >  	iowrite32(GWCA_TS_IRQ_BIT, priv->addr + GWTSDCC0);
> > -	rswitch_gwca_set_rate_limit(priv, priv->gwca.speed);
> > +
> > +	iowrite32(GWTPC_PPPL(GWCA_IPV_NUM), priv->addr + GWTPC0);
> >
> >  	for (i =3D 0; i < RSWITCH_NUM_PORTS; i++) {
> >  		err =3D rswitch_rxdmac_init(priv, i);
> > @@ -1502,7 +1491,8 @@ static netdev_tx_t rswitch_start_xmit(struct sk_b=
uff *skb, struct net_device *nd
> >  	rswitch_desc_set_dptr(&desc->desc, dma_addr);
> >  	desc->desc.info_ds =3D cpu_to_le16(skb->len);
> >
> > -	desc->info1 =3D cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) | INFO1_=
FMT);
> > +	desc->info1 =3D cpu_to_le64(INFO1_DV(BIT(rdev->etha->index)) |
> > +				  INFO1_IPV(GWCA_IPV_NUM) | INFO1_FMT);
> >  	if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) {
> >  		struct rswitch_gwca_ts_info *ts_info;
> >
> > @@ -1772,6 +1762,8 @@ static int rswitch_init(struct rswitch_private *p=
riv)
> >  	if (err < 0)
> >  		return err;
> >
> > +	rswitch_coma_init(priv);
> > +
> >  	err =3D rswitch_gwca_linkfix_alloc(priv);
> >  	if (err < 0)
> >  		return -ENOMEM;
> > diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ether=
net/renesas/rswitch.h
> > index b3e0411b408e..08dadd28001e 100644
> > --- a/drivers/net/ethernet/renesas/rswitch.h
> > +++ b/drivers/net/ethernet/renesas/rswitch.h
> > @@ -48,6 +48,7 @@
> >  #define GWCA_NUM_IRQS		8
> >  #define GWCA_INDEX		0
> >  #define AGENT_INDEX_GWCA	3
> > +#define GWCA_IPV_NUM		0
> >  #define GWRO			RSWITCH_GWCA0_OFFSET
> >
> >  #define GWCA_TS_IRQ_RESOURCE_NAME	"gwca0_rxts0"
> > @@ -768,11 +769,13 @@ enum rswitch_gwca_mode {
> >  #define GWARIRM_ARR		BIT(1)
> >
> >  #define GWDCC_BALR		BIT(24)
> > +#define GWDCC_DCP(prio)		(((prio) & 0x07) << 16)
>=20
> I'd be glad to see defines for magic numbers above.

I'll add defines about 0x07 and 16 on v2.

Best regards,
Yoshihiro Shimoda

> >  #define GWDCC_DQT		BIT(11)
> >  #define GWDCC_ETS		BIT(9)
> >  #define GWDCC_EDE		BIT(8)
> >
> >  #define GWTRC(queue)		(GWTRC0 + (queue) / 32 * 4)
> > +#define GWTPC_PPPL(ipv)		BIT(ipv)
> >  #define GWDCC_OFFS(queue)	(GWDCC0 + (queue) * 4)
> >
> >  #define GWDIS(i)		(GWDIS0 + (i) * 0x10)
> > @@ -789,6 +792,8 @@ enum rswitch_gwca_mode {
> >  #define CABPIRM_BPIOG		BIT(0)
> >  #define CABPIRM_BPR		BIT(1)
> >
> > +#define CABPPFLC_INIT_VALUE	0x00800080
> > +
> >  /* MFWD */
> >  #define FWPC0_LTHTA		BIT(0)
> >  #define FWPC0_IP4UE		BIT(3)
> > @@ -863,6 +868,7 @@ enum DIE_DT {
> >
> >  /* For transmission */
> >  #define INFO1_TSUN(val)		((u64)(val) << 8ULL)
> > +#define INFO1_IPV(prio)		((u64)(prio) << 28ULL)
> >  #define INFO1_CSD0(index)	((u64)(index) << 32ULL)
> >  #define INFO1_CSD1(index)	((u64)(index) << 40ULL)
> >  #define INFO1_DV(port_vector)	((u64)(port_vector) << 48ULL)
> > --
> > 2.25.1
> >
> >

