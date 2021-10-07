Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6B3424FB4
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240326AbhJGJIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:08:42 -0400
Received: from mail-db8eur05on2064.outbound.protection.outlook.com ([40.107.20.64]:3201
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232604AbhJGJIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 05:08:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NpHK+J+ac3jtRswvKHHkr7K/9Oadz2VWLGuS7o4PaHt4wpM42i10dhhVsOVVdK/h5ihTClmJMfoBLD5vM/a0ULyN6HalTlGTzjG+ALOstrmov4ddwqoarMZ1CmTEAm8qmgKI/JvGIWdjVcHbHJRgWmwvk8IoYjJzElOcsp+/rbozhsVnpRkpruXPCW/4sJwa1oFxt8SrC0VFhVWxSBC0BYHqHT9b5wtGTGr6pbfltL437Bw35cWgTwWfZ0ow9Zkgw6Zs3u5C5984ExQfrmY8Fav2QSrENKu+x+KCsec7csYYJjVCUUnLtpgUT2m3opziw+o8KZ17EbIQpoHMyIZxlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dTJHOhwjvunk4OSvDRi+gSyYdcX0BYGN3d9evs1qQH8=;
 b=PGga4D7R+eg3uWZsVH+ErW6Jj0ZIkfGsMNo9gH28haB04+6saVCLhpNCfML31B2fcKyKHwY4LljSJOczHOYtkJeF5+benG5AWS+fpSq3/lpnSGL9CGmkrFO2ob8aNm+q+AXq+21FZsM96G9I2+Z0mpgMnbIB1ptibKqghUBkn46N4v4XxBhYd3Q7fDCGQh1kaLhJGWGUo8y+l5lnNeSTO+O0LirrIn4t3Iw9Kk6anaoWeIHZKm+xG5zaxs9nhtBHufsTuTjYWX2P9KNnltiDywAoPYM8lzdqcCK2NMJ0CwOgcjgJozUd7dBlhl3DnqH2vHro9Xs31ZzDKg02HS9SrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dTJHOhwjvunk4OSvDRi+gSyYdcX0BYGN3d9evs1qQH8=;
 b=beQBQbOZgQQTGD2WfTit8d1pHsbJTERjpR5xf5AwcNCbmMu+30QVCHS93qvaP+ig8gIef1QoS/2C4EpBRS1Ekk0fWRFDfQtiQTReNly1R4Um3ZEr5Tqvpi6EHSsOECQcfPhRBc5cnpuTaKmvMpM2zczLiO1AsxgMjFsfCHLxMJY=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM0PR04MB4273.eurprd04.prod.outlook.com (2603:10a6:208:67::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Thu, 7 Oct
 2021 09:06:45 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::78be:5e5b:c0d7:7b9c%6]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 09:06:45 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: RE: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Topic: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Index: AQHXuu66y32LWmROBUCgcDqaC5R/VqvHKlPwgAALuACAAAMi0A==
Date:   Thu, 7 Oct 2021 09:06:45 +0000
Message-ID: <AM9PR04MB839713B0831C74BDFE0F1CEB96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
 <20211006201308.2492890-3-ioana.ciornei@nxp.com>
 <AM9PR04MB83979C1C47471719E6688B0F96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
 <20211007083307.6alnxej5qx5ys62k@skbuf>
In-Reply-To: <20211007083307.6alnxej5qx5ys62k@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc104ed0-cbed-4f4b-50b6-08d98971c985
x-ms-traffictypediagnostic: AM0PR04MB4273:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB4273EE52DF9634C2EE02ADF896B19@AM0PR04MB4273.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eOnGaUD6AVvFqtjxVTqf6n5kEQqW7kPe7WctGgkVp6HIgBuVXZEJbk1crgInsjudPZ0qdaH3ghUU/EasXB84EGF3m84xOlG86DZvV/558uDon80tYeqQzLA51tqd1f83aK+J9NOgtG423vLPncAlQjGODAMIGkYMQoKPmAakbUnsVAXqo5IUj2igO7XHNLTtFfYYkDTVUcJy4TF/c984/w7l/RbNhHUuYet8jq3fpeXQyNyyotBH4Q3zXl2wgsZAoM7PVyKRSUN9bhGl2ONhisEALbYkc6sIlWWuwmUj5ZGRzMRPRgZf/BRRBeTqE0KVIYuO/4XJKevN+G/nvXAG9eoUiZSrCI9F+YSKVaC0B0fS97RgXxQovXJ3wOPwF1KcJcvJgdguLJuV/qR168TK7ymr0V8AMdCYoUmWgMhoSeu6giuzA85p8hSy7gHIRedMZiD7EAfesaOEfqeMHvn7ZAvg0J2lmm5DVeiCbe/m7KaWZBqX0iW9ZoQBNRqciOi/Bi6MpF7YQgUseS8sD1HUyKRPBi8Gg+B/Bg6+RivGiTUBDn1Vls8WTlILJ/iU0OwQgK31e1Zr8ovH8oIoYuIxaKQ93QxDOU0aqI1i2HZUbTetldvF1Wno57JcwnMk06ZswHZ1vqlz0pq2SroJ+xv3nVM6o1ofAYKNCSvl0VS11+rk9YluvbGS7wmgHq2B7j5UhXuG+OW8eSrYA1tj+4YsRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(7696005)(53546011)(6506007)(54906003)(71200400001)(316002)(8936002)(6862004)(83380400001)(44832011)(186003)(26005)(33656002)(8676002)(38070700005)(6636002)(2906002)(122000001)(4326008)(5660300002)(38100700002)(9686003)(508600001)(55016002)(52536014)(76116006)(66446008)(66946007)(66476007)(66556008)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?KulEM5KFdFDHKD9vIxbETzsn+6KUX7xiyaL7ITIhgC1/6pynxPOL5NWvB99B?=
 =?us-ascii?Q?2gR/+dbxb4s0xjCx7KBhqy9wbkBC0htzDmXyZS5c1cuMfTuh9447/upM6Ym1?=
 =?us-ascii?Q?D3fLkJ1pdyo10VkSBsmEV/ARhgDd69NSUaIHswrjZEyAwSBF47LngfSnyer6?=
 =?us-ascii?Q?obVDJ9HtmVBRu4gJGmiHBqXxnUu9gPb52GzzGPqKu98Vgr5icIS+LmA3h4DT?=
 =?us-ascii?Q?ARiCuR/3kkpr2Tiun3txqZlMC5YPQoYgoozN0tQ2JfT8xdGancMlvLD/Cuf/?=
 =?us-ascii?Q?Yvof86qcKwehV0e5tDlqD3X/4/gmJupJgbe4ynogk7jjM05Ce/8oheRB96hp?=
 =?us-ascii?Q?jNN/N2SDxx9enaUzlrk8CagaO+Eg1MoYJT98qmzMkBMoB1PYH4w/BKU1rMLy?=
 =?us-ascii?Q?YAJY0ST8igWCXntScGU0rjiIflPTHfrrl4OvsPGeNAAA+Vxde+/4xbWgrL++?=
 =?us-ascii?Q?txEd+n6Ggp/jU5tZB5bLp3wxJ0PZx4MuVuXbxbVsYn2jIkmr/wTzSr8I8XRA?=
 =?us-ascii?Q?ibSdM3nCOH15cI/K0rMj5EBQ/U09DhUXbcCuxY9i9mLUOMgEY04GsC1krz+c?=
 =?us-ascii?Q?xJZttmdctfkJrJIV/r+LaYNkg63DzIE7mkBkkUyXYkB6FsEjkjlCB4sCYKbW?=
 =?us-ascii?Q?DFj80/+L7UrY+DFkdb5u0MPC6mi4F4eg4DceRXt4xmyHm60pUCyLopFkcWiF?=
 =?us-ascii?Q?F1KHhi9ecUlVMBSBywa7gWedBaf91kAQ5vBaY4NyJqrtHdte944tusyalQyd?=
 =?us-ascii?Q?QkChVkPVa74ugwXgutJKk3jHep6I+UoTP69q+jCUbVSlI7ycEP5JWhcTyder?=
 =?us-ascii?Q?EYjhYDJC/gA1VH9Yeni0osn2FZNJhGJQGIOtpT3iIdD1nDn8tmKzLF4c+gzN?=
 =?us-ascii?Q?sc4rLO5OEBEMzFT2Q3mex2aUsJNPU+7YLpu+J69PH/Mia+KCZjj/yMZuU5Fk?=
 =?us-ascii?Q?+WXwUeBPcFsbERVgaWb5u6zOiVV1z5xPUoAVRSsTfp/xwVL+gvJ+aGtA03dT?=
 =?us-ascii?Q?NyknhM8akJkwYeLIAwRFfnKhkt61bTPgH4VQ5ggQxOgpKx+0eSQChBDATfDz?=
 =?us-ascii?Q?n/etWiP3YYiV1Y0clJPKoLsH7hU4Vk+69ONVQPT8JnUCmh0W0MjKoH1HgEJR?=
 =?us-ascii?Q?0Cj5belTZGGgj3kMWaC/qO2R6AdsEhgZZ8P2P56GpAm3I19wQuYn+bHXWAkO?=
 =?us-ascii?Q?CMgA5cs1hZWquHJCB9AkrS+6AC43T4OVyxiZiAhppkwTwePx/t4XeaUDx7fW?=
 =?us-ascii?Q?bhzPg+1C5ZtpXAQbmNdw5Bq2MKir/r6iyzlUyulyMQvhjEbL2vPcGRv75+EL?=
 =?us-ascii?Q?PT0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc104ed0-cbed-4f4b-50b6-08d98971c985
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 09:06:45.3807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eDTimayHtZcvGb0knERAVKoR17UGGSVhaEQoZr/knIuqSYKjRfbSRveBBX0FPt2851cTsw/deD6Ml/REyIynzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4273
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> Sent: Thursday, October 7, 2021 11:33 AM
> To: Claudiu Manoil <claudiu.manoil@nxp.com>
> Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> Vladimir Oltean <vladimir.oltean@nxp.com>
> Subject: Re: [PATCH net-next 2/2] net: enetc: add support for software TS=
O
>=20
> On Thu, Oct 07, 2021 at 07:59:25AM +0000, Claudiu Manoil wrote:
> > > -----Original Message-----
> > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > Sent: Wednesday, October 6, 2021 11:13 PM
> > [...]
> > > +static int enetc_map_tx_tso_buffs(struct enetc_bdr *tx_ring, struct
> > > sk_buff *skb)
> > > +{
> > > +	int hdr_len, total_len, data_len;
> > > +	struct enetc_tx_swbd *tx_swbd;
> > > +	union enetc_tx_bd *txbd;
> > > +	struct tso_t tso;
> > > +	__wsum csum, csum2;
> > > +	int count =3D 0, pos;
> > > +	int err, i;
> > > +
> > > +	/* Check that we have enough BDs for this skb */
> > > +	if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
> > > +		if (net_ratelimit())
> > > +			netdev_err(tx_ring->ndev, "Not enough BDs for TSO!\n");
> > > +		return 0;
> > > +	}
> > > +
> >
> > On this path, in case the interface is congested, you will drop the pac=
ket in the driver,
> > and the stack will think transmission was successful and will continue =
to deliver skbs
> > to the driver. Is this the right thing to do?
> >
>=20
> Good point. I should have mimicked the non-GSO code path when
> congestion occurs and stop the subqueue.
>=20
> For symmetry I'll also move this check outside of the
> enetc_map_tx_tso_buffs() to get the code looking somewhat like this:
>=20
>=20
> 	if (skb_is_gso(skb)) {
> 		if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
> 			netif_stop_subqueue(ndev, tx_ring->index);
> 			return NETDEV_TX_BUSY;
> 		}
>=20
> 		enetc_lock_mdio();
> 		count =3D enetc_map_tx_tso_buffs(tx_ring, skb);
> 		enetc_unlock_mdio();
> 	} else {
> 		if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
> 			if (unlikely(skb_linearize(skb)))
> 				goto drop_packet_err;
>=20

Ok for handling congestion, the idea is good, but now another issue emerges=
.
The ENETC_MAX_SKB_FRAGS check is due to a hardware limitation. Enetc cannot
handle more than 15 chained buffer descriptors for transmission (i.e. 13 fr=
ags + 1
for the linear part + 1 optional extension BD). This limitation is specifie=
d in the
hardware manual now (after I've hit it during development).
So you should add this check on the TSO processing path too, but adapted to=
 that
case, of course, since skb_linearize() would not work with TSO.

Thanks.
