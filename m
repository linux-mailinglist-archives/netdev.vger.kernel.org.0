Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA72B425008
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 11:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbhJGJ25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 05:28:57 -0400
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:32352
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240638AbhJGJ2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 05:28:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OK+EoPQDUNb48DmShImDbWWcmVLJmQaZeJT3xPHnmHKzwOhHg9NkDtUG1P7BbEQ86/G5gR08ETlUR4ASfuLFW4QbBQJL2iR2ds8wygymVw4tDO8M1qzxX8jKzUdxczqkxxH+AMJiPy+6ZI2cWw0mPo9UkHjO9czp7sOkbOgsU4optP2RQEGzWDyB5bTwyC+Fy3BFffgzDDY0EEjk5vEswYlYBEXoCA2L1e3O49zf/PETCl4j5IrALItK2lHyaQEmRg9rvC/bUfUe9wiv2WHElaa4JSHFBm5A3dDdOlBsB8LbF5FWI6Cb6NDVpbhZoAM/lA1QuMsqooE19DfG5fbrHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxM7cRFira5TgCoeSTWX94jOLGD3kdyuh2/kaw9mwQ8=;
 b=U7lUVRE9rR4JJUDDjTlfTdyz1IZKRo4hFXevwL8u7NirNE8kPZNVYmgQO5p8nVJetTmx5F5CQYQUyuZ+sarq7O0Glxz+otTQ5lNkC8bIR42CdhTVmn1ZK8ag3Y5krvs1/E7Fuj656P0vFpBWwT6UGByiclKmwTvU6gcWIHDNpeJAX3HNvW15dxdGRfdOPq8Q1TdVBAIWDpiY4KeF81UTkEu/uoYnvQ9IMEdx/ug1cf1xYjZw3gVqBpJhxDNzvTzxt/VYDKERlgHRR7ZL4ti48LEQ0W/p3jpvjlaryEJKAYUo27kjraj/WsX0EiREsBF8heMDYXDcyJdlagDUzQShag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sxM7cRFira5TgCoeSTWX94jOLGD3kdyuh2/kaw9mwQ8=;
 b=KCjbZ2Tt/FMe9etA7Qd/fevnz9SVfG1ukMHkhcaE9KhmVLrlqr3yokLo9yAHYLeI0fJggsxJJ7lcezCcA6hRYJrp8Z8fBpPh5SOf/KRolNNbjU03FuuJCFLCuWPPusVBZ5Hdadp/38qbooaKYxKyitP/9VehjqNla5O2esuj4sU=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB4211.eurprd04.prod.outlook.com
 (2603:10a6:208:5b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 09:26:56 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::6476:5ddb:7bf2:e726%8]) with mapi id 15.20.4566.023; Thu, 7 Oct 2021
 09:26:56 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Topic: [PATCH net-next 2/2] net: enetc: add support for software TSO
Thread-Index: AQHXuu664Nbids09pUWK+2m6R9okf6vHLKCAgAAJaoCAAAlmgIAABaKA
Date:   Thu, 7 Oct 2021 09:26:56 +0000
Message-ID: <20211007092655.xzvf76pjzkjwteiz@skbuf>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
 <20211006201308.2492890-3-ioana.ciornei@nxp.com>
 <AM9PR04MB83979C1C47471719E6688B0F96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
 <20211007083307.6alnxej5qx5ys62k@skbuf>
 <AM9PR04MB839713B0831C74BDFE0F1CEB96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB839713B0831C74BDFE0F1CEB96B19@AM9PR04MB8397.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e0392c7-82f3-49a3-b09b-08d989749b77
x-ms-traffictypediagnostic: AM0PR04MB4211:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB42112202431DEC0F4B7A701CE0B19@AM0PR04MB4211.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M9rpfc+GraxTGmEKPxO+nxQH8/BhcaYze8EqYb7wJaebrmkd0egtU4T9XokuDe3GuT5Dc+b0lJ8pXcJ9HgWnnSaXBtyKcdFRyg4NK1p3sddtRD1sJdYWYddQwCuoYX/rq+1Ae689gm/iphBwOchUaTKokm3XgCr0hVRDUyI2O2uqKE20XJcnMKpMrg9tioiilVyv3+9SFk2BbacJiB3I0QLQt1RLte4zID/7tPchTUYZe0gc9a1zzkx+y5ZhMHNhZYppWf6zR2qy4PokvdCQz/3qSPjrIvBxeKi91y8IgGNcMFfQYnj2ZJHFmyY9ExL0Xg1T0+KzIDsvLziieUI7bHgBEwgJz0KuRmFzHqXbJhnR0wRRB4TNfix78EbpQG9oGloL4kLt+y7VBInRuE/+p3ipvuK0+hyKb7aMuvWga1t4c5cxztJjJiEGwsfKJ/gnHM5S84yAD4DH1HYI50DYlddhFee3g20zT4nlxrMvOmLuREDAbHilhMwvkSwtgCXCl7qjeYHDFQoMnoy+sHPhRn0COSYuxnwHV2sJ7wECq6jySpmvnKe7TaH5aRu6Wc8qWlFXfE4WqAwADfw3JhyTdMbyvKdhchL1j8jEmlWuKx8MmYTTkHqkK6PHXEjABfP2egwGuSzBMACvtjtqnd97nxHGje9ePm5ZqhDjLK3PNLfBOVn/VLz5VHXaWZ7Wxd156lKJxxh8eRMjh2p9cG4+CA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(33716001)(8936002)(186003)(6506007)(26005)(44832011)(2906002)(9686003)(91956017)(53546011)(6486002)(66556008)(76116006)(66476007)(64756008)(66446008)(122000001)(86362001)(508600001)(66946007)(83380400001)(6512007)(6862004)(6636002)(8676002)(71200400001)(4326008)(1076003)(54906003)(316002)(38100700002)(5660300002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HDRRFPhVrct3/J19LfgqQTEjyWAgbJOzXDxLJgKG18WHrWJzP8pr+jUUTM4O?=
 =?us-ascii?Q?vPtGihYxaO6wodbdaEfDR85zfu1S9GwVtq29l1Duq5MtPpe5UP4xIJmhy050?=
 =?us-ascii?Q?2bTZFB07aGa6mDt3uTl2TKGHIlK0tHNsnup4cv2y2Cu7XHHpNxOfdhDzd/pd?=
 =?us-ascii?Q?sQ0mY1CEutczLVGxpqhEOsZIUk8Jt25zrqJT4f0BKZuCvu2XBwGl1oW8oYCd?=
 =?us-ascii?Q?dedsnO8cwOFh1aP4q/svbfngAYIFy378lGE5XbB8jO/3t0FGqD+GOjVt060o?=
 =?us-ascii?Q?1bW1ZH0FYuw5F38rZr21R+EUifOfETNrzX5kxp0YrxG4XmbrLnk8npAPCD1C?=
 =?us-ascii?Q?azzyDG/qH5kB0/BzRy+hSGCY8riLc7VVbrOzDWmHQ0Gu1C6seP9sJyrqF9vD?=
 =?us-ascii?Q?MCnPF1vYSrn0KQET72nhDZM3zoHMNHOgamH0F2Dg9gXvQLYsw+GK8KCIe5mo?=
 =?us-ascii?Q?brF+CXa89D0gDCQAo4+DIJJQz4bsXGJeWl/sGwa8lfGkG7r9VktA5hlGHUbP?=
 =?us-ascii?Q?wtP9givfC9ogXA/2VjUwzCVzxYCv1JBIHQPtuuTY1t4268dNR7cdyTexTsTy?=
 =?us-ascii?Q?/BRRT7RpzwbQ7VRXO1LmebnXED7scRULNvT/ojb3/A7R8hTgoJk1OSbmS6VV?=
 =?us-ascii?Q?cl1IlEeQCo0ZpjdmqhBPjpMForH1oXwaDvTlWjYIbe4VYFDjAFK2mle0T2uv?=
 =?us-ascii?Q?a7fCPlhqam6MCiUmmrmD3AUm/d9BUCUsG6zvzbGvL0j07fz4ynriaNGFScAD?=
 =?us-ascii?Q?Emq43inXh5ygfsmUI6ad21wYA151xAjjlCW2055c6JJjl5yHPPuHSXvB+HoN?=
 =?us-ascii?Q?RWNFfwMCQ/l6klFhiNJ+yiRdU4IQTsUCYfJ9C5uK90RZovQvMDSAesYx4Ex2?=
 =?us-ascii?Q?+LdowzHhg11Wt4j1SjOnWmEoAAqiitRy8dVLMpYMVXBqLOB9c5NPnsR4hDkI?=
 =?us-ascii?Q?Panbn0/1VNvkdMia0pSF8PUpzrwZ/8NpeksZElEwbkNmIHnOgzYDw6hJi7KA?=
 =?us-ascii?Q?TZr90mmxoxda1bQqQICJnRl8dmFWIMU09n3HXl2zxfTNWQBLJnKRUkhjgRTf?=
 =?us-ascii?Q?RnMOF/FojfFh43CjoaUzMpdDvrPuobOEVz627PF12zzlregd8IZFJnrERsK0?=
 =?us-ascii?Q?dvOrUUEfqjGM1BWmC5p3Z1WQ4DVBaZj457WNNeCO9UQL46KeVh47a/uM1Vbt?=
 =?us-ascii?Q?5lgdCUNsx008jvoOfBlGaqNN/sRQMF8XY8fieMxeASAfeqw0uSW/FTZQW5Z0?=
 =?us-ascii?Q?NHFEIdKcUcJvOPibdYy9hDhCYLpusA6uDrfyXX2U5j3f3MBfcRra3pkjXrIt?=
 =?us-ascii?Q?fc/EZgDjo0yt/kbQMbORHvhd?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12D642CB4836ED478A9B3BF09A79E610@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e0392c7-82f3-49a3-b09b-08d989749b77
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 09:26:56.5390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oBCmRptNykZs7wLIJA18CvMB2hQI5AKj6YCa5kn3IfmdBIuCkPz/lTME6gIErOfgb0fIKLYCa410wP6zpiDKtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4211
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 09:06:45AM +0000, Claudiu Manoil wrote:
> > -----Original Message-----
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > Sent: Thursday, October 7, 2021 11:33 AM
> > To: Claudiu Manoil <claudiu.manoil@nxp.com>
> > Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> > Vladimir Oltean <vladimir.oltean@nxp.com>
> > Subject: Re: [PATCH net-next 2/2] net: enetc: add support for software =
TSO
> >=20
> > On Thu, Oct 07, 2021 at 07:59:25AM +0000, Claudiu Manoil wrote:
> > > > -----Original Message-----
> > > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > Sent: Wednesday, October 6, 2021 11:13 PM
> > > [...]
> > > > +static int enetc_map_tx_tso_buffs(struct enetc_bdr *tx_ring, struc=
t
> > > > sk_buff *skb)
> > > > +{
> > > > +	int hdr_len, total_len, data_len;
> > > > +	struct enetc_tx_swbd *tx_swbd;
> > > > +	union enetc_tx_bd *txbd;
> > > > +	struct tso_t tso;
> > > > +	__wsum csum, csum2;
> > > > +	int count =3D 0, pos;
> > > > +	int err, i;
> > > > +
> > > > +	/* Check that we have enough BDs for this skb */
> > > > +	if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
> > > > +		if (net_ratelimit())
> > > > +			netdev_err(tx_ring->ndev, "Not enough BDs for TSO!\n");
> > > > +		return 0;
> > > > +	}
> > > > +
> > >
> > > On this path, in case the interface is congested, you will drop the p=
acket in the driver,
> > > and the stack will think transmission was successful and will continu=
e to deliver skbs
> > > to the driver. Is this the right thing to do?
> > >
> >=20
> > Good point. I should have mimicked the non-GSO code path when
> > congestion occurs and stop the subqueue.
> >=20
> > For symmetry I'll also move this check outside of the
> > enetc_map_tx_tso_buffs() to get the code looking somewhat like this:
> >=20
> >=20
> > 	if (skb_is_gso(skb)) {
> > 		if (enetc_bd_unused(tx_ring) < tso_count_descs(skb)) {
> > 			netif_stop_subqueue(ndev, tx_ring->index);
> > 			return NETDEV_TX_BUSY;
> > 		}
> >=20
> > 		enetc_lock_mdio();
> > 		count =3D enetc_map_tx_tso_buffs(tx_ring, skb);
> > 		enetc_unlock_mdio();G
> > 	} else {
> > 		if (unlikely(skb_shinfo(skb)->nr_frags > ENETC_MAX_SKB_FRAGS))
> > 			if (unlikely(skb_linearize(skb)))
> > 				goto drop_packet_err;
> >=20
>=20
> Ok for handling congestion, the idea is good, but now another issue emerg=
es.
> The ENETC_MAX_SKB_FRAGS check is due to a hardware limitation. Enetc cann=
ot
> handle more than 15 chained buffer descriptors for transmission (i.e. 13 =
frags + 1
> for the linear part + 1 optional extension BD). This limitation is specif=
ied in the
> hardware manual now (after I've hit it during development).

On the TSO processing case this is way less likely to happen since the
resulted segment would have to need 15 chained BDs, not the entire skb.
At a maximum, I have seen one frame needing 4-5 BDs: 1 for the header,
1 extention BD in case of VLAN and 1-3 for the data part.

> So you should add this check on the TSO processing path too, but adapted =
to that
> case, of course, since skb_linearize() would not work with TSO.
>=20

Anyhow, I'll add this check directly in the while loop which creates the
chain of BDs for a frame, since that is the only time that I know how
many BDs are needed for a resulted frame.

Thanks.=
