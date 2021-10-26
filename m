Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1325243B7A5
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 18:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237555AbhJZQ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 12:56:52 -0400
Received: from mail-db8eur05on2050.outbound.protection.outlook.com ([40.107.20.50]:2123
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236295AbhJZQ4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 12:56:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7nj+0VJA8uEy73x2uMDkrJ/xFsr/gEXjpS8+R7hWgtyqdc4FAg+F3lhfJ/ywXgt5m0za5txiJdw1ZbX5vGRq26Eaph9k/12+Qq5g4V12aZExoMzsg2eO8rm9L2n/wAU3UFN84tfT2bF0VN2PVMM+2dLPmGEkY5x+DQ/aAgI39gJUroWwPz11hEn+p8vjSPRYYlsLqX8vD2Uoa1cohPRfkoW/0gIBQHdloezZpIOW8nc1oVx5n2mkMbZngRe9mTCkenjvTT/JGAUM7pLnWVbMAU+3yJDa8EvgObwFAXrnnYCKq6fyxnj9kjipDmN24NCySNI/CVLgx9An53vS7/z7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6FztYIDxBUg3nTwJpolkqU0wJBepB8ByrECApt+q+c=;
 b=eac/qP9XBRJt2KaIhfqHNSWMrXjkcIAEVpIB9MkSewqSGJc01JRMQ4aYXEfxYQ7uVvlB9r3kn+YC/ZD7TFgVXp7XF9LXlJHz2wOWiHxIYT9KRve7iUstweyKMLVUjbY0RTK/Kd53kGl+2TCtVK/cKEtGBzB7g5LPArxIyYOZOfWIAEAAfgJ66DHofbqk5lSohKqUHUQ81nb6qjHguskPKI61IG7tpxGQSNBFjRm7CSV9XT9FECWhz+ElbR1n99z01aHf8DPyHYLQap7zOtoqFqzBl3qHRrhYQ8dgIxNGbk8YYiMN/H9pNHmBt1mMcNmOUxN+45cx/qFkWZ3SrDRoLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6FztYIDxBUg3nTwJpolkqU0wJBepB8ByrECApt+q+c=;
 b=CmHFxcfTMpJLjbCYJT6r2+/XKz4/2vK2XZcMNBb0CMO4HXnKify8JurvIkT2vxSWAHAM2Lu34XmXN6BXZZ6WoHdpH9eGC2HwYtHXcr4Dmn25BvNryzacxKSg0LN33GU1wCLploLc316E643JcaXwFWr7J4EVqmnv9DvNqV7DJFE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 16:54:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Tue, 26 Oct 2021
 16:54:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Thread-Topic: [RFC PATCH net-next 00/15] Synchronous feedback on FDB add/del
 from switchdev to the bridge
Thread-Index: AQHXye8TuHIQFfcKx02oYjeM7kf+xavlF9qAgAAMn4CAAA9DgIAATKgA
Date:   Tue, 26 Oct 2021 16:54:25 +0000
Message-ID: <20211026165424.djjy5xludtcqyqj2@skbuf>
References: <20211025222415.983883-1-vladimir.oltean@nxp.com>
 <531e75e8-d5d1-407b-d665-aec2a66bf432@nvidia.com>
 <20211026112525.glv7n2fk27sjqubj@skbuf>
 <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
In-Reply-To: <1d9c3666-4b29-17e6-1b65-8c64c5eed726@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84f6b7a9-5c7c-4af5-7158-08d998a14459
x-ms-traffictypediagnostic: VI1PR0401MB2688:
x-microsoft-antispam-prvs: <VI1PR0401MB2688E9D54575E72106B8FE07E0849@VI1PR0401MB2688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UpqkH9C7xSlSk8WmJbCLilJtN9zKSu0mXhZ5UeXmm9V5f9KurwzgMFuGT6z94DfXxGLlIAw8dKvGfSnt4iwXwVTg3HJpgKsj2APZ9a66gGxQOPlPJesMwneImuoNzaFwZe3x8VDVON2Sioqe1GEAXh+LhFl+OpE6UdIUjcxnsygzrkmnebBS09gJPRmi6E/X2MnU2tCXYCw5UtXlCPmYrFc/Q/iyImx/D0xpv5GTSEYUfC8sY+MM3jrG4Mr97c1ePPNmJcdELrQkfedQxI0hQ63ac+FM9W2kfKIs5h+lYukPPDH149gcwzJweyr47HFI4sThpyPPLr4oEYiyWCNGIP7gLybTOqKX+dIfp7orTs99P6+ipfiGrYXIeTqPTSxc6M0zRHUoek9G/H+g+bi/FYm0iJGTCxJCTRWUvmX8Kc8gq4q4ZDtm/BBM2hruGj5a4b1FsGJeNewmOpBznvgWc2gcjsEjxK8anti994IaWXY4sdU+/inUHdOZUSjFMONB605Q9jGAKPUNZEQ3WxuqLE1UbJRqU0DJGDqm8j+jyOwHQy7HLy2EZRozrVyFl3c2s3CzpZUWUAtqRDMAsiMa9O0yR6NE4gVtMdlpqdzvkoyQYWkb0C2dRi8a4a+TfL92gUX8qb+2LHoK+YKJ1qTSt9f09L0gfg6T2MHIYIulKllSl7RMWq4fDoYJwXRdwYYjy4MNMZJ4wdpUn59cfykrgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(4326008)(9686003)(316002)(66556008)(33716001)(76116006)(7416002)(1076003)(54906003)(8676002)(86362001)(44832011)(186003)(6486002)(66476007)(71200400001)(2906002)(122000001)(66946007)(26005)(508600001)(53546011)(6506007)(38100700002)(38070700005)(6512007)(5660300002)(6916009)(64756008)(8936002)(66446008)(91956017)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Dx3UCP+s5/G/SAim3TVsCFyI7CGAD2LXhwm0rWTAvN16V909rIEZfxAKzCmk?=
 =?us-ascii?Q?Xq9E4LeWCGjtvJRjxUxlJ8Nxd/rGkXGwP15NUfmKvvtA96xflcV6dYl9Pvm+?=
 =?us-ascii?Q?AbUeQbDmcVG4VnI0JEv3pHkDAumgP+8+tDUwHX5iYko6w2U8IjwpxLCV08Ei?=
 =?us-ascii?Q?4elgQAyUdaUGDC8dN5kOkhANEbAjLQNCfzUjXZHTB51nron9fyeJycJrdcm9?=
 =?us-ascii?Q?LOG3+2BJOc8ebiQcj9EhV393Hlk+q5+X2wfLunx37hjpBfL8DEqxrnzq97bQ?=
 =?us-ascii?Q?WlvtbBKND3nI6W/zhuWkWkwxSP0DGbPV+F7yYyKS+gnV/TTUGsSHlsKOEPAN?=
 =?us-ascii?Q?YJKifzajSqPFT19jgo3fKDRSCLw9Adiaqr+oKqhrTrN0BD+hRH/EEBnpZFTL?=
 =?us-ascii?Q?hmURDzXMzu6lqz204np0dycI6CKqFSpSYbz2BLjrSl9avL5aldNfGCwxNMz6?=
 =?us-ascii?Q?0Bn/14iYy8KRE2CBtNcPbuHWlbxVSNdL25eIKvdMGNEOvTwteFJjVkXHi/E/?=
 =?us-ascii?Q?gJQ0ojsjo93aGVj2aIZaRBqaeaZVq3yjh0U0VLuAhRHtSCypIt/aOHF42dEt?=
 =?us-ascii?Q?Ey+R43spVPJy7HDe7Ol7jb1MnE+mtpI3tt9pkpze6yGOmK7mn/7LC9jISLkd?=
 =?us-ascii?Q?RdnibsFNIDrmvQPif60TxDG5tGcfGCeJS08RDs6kTF4EjyrHusNxFWcTjn3L?=
 =?us-ascii?Q?u0kFrZMi39CtKNgFdmTzHNXV+XEMz4SEmWXBbn1bQsoi9axnBAxHVf2NjZme?=
 =?us-ascii?Q?p3BFE2WF8kNL/0tDwEGWblfcrj4jdWq4plxmSAAbP9In1+l3N1TR3By7BMbF?=
 =?us-ascii?Q?zdbTnwQptNxKjP7BXtgdDV/lG5OQPGKUjRkXU4oe0b/lAq+5Uf7y+Z3vw2DN?=
 =?us-ascii?Q?LewuLqbCcRHgXd2w+h7oPAzGcPIsP8l1G8U6Lc/tNcE/YDtxNsuxSBnZGs4G?=
 =?us-ascii?Q?OO4X11/Ft4kJKT8dRINSHHrWtkw7ZCADEKYEhJUK6j40uaLrWi3tWaVWWeOK?=
 =?us-ascii?Q?e5YElRCfuyQPdHvR3eDX6cloDGfxB5rjQXaHRIHLF629BHAi55/y3/qcZDao?=
 =?us-ascii?Q?JCx7E5Tw3pHD/4JgWlbvDLbvFlMWSOyhWjCPLrVjBEPngF6WRfP2EK1yE/Kp?=
 =?us-ascii?Q?crwmqWI3A3UR4RJdMLm2qjVpHF4hHoWloD4smZtYVyxwVoh+t4/9d/TfPX7/?=
 =?us-ascii?Q?t4yny1Z7bp2HsqwYbVH43HhGgTx51RCSqCSdcv40lokPIS+07RfM5vWqUd9I?=
 =?us-ascii?Q?PjlQMj4T10JFeiICdhjGN99NcDezzcH5kb/JTounmT1aBeLTGWKenipspeeD?=
 =?us-ascii?Q?I11wqT+aqfsUgn/d5CQCsfD7qFNkXw6gL9WaLcrhXkvrtW7yBuT3fJHwsLBE?=
 =?us-ascii?Q?2eFMkoa9ONYTLznor5y9CAnkcQXDJ8oOPVFE6yl90Aj33tZdI+ImGdZD0cHX?=
 =?us-ascii?Q?edCQsyMFmDGsj8+97HbBu55M9f1tHixU8aEBDZ7nMZbPPhJqL9eC2oRdDcw6?=
 =?us-ascii?Q?CA6yLDjXopzR3f2Li+RMxwshersJZBsEQdkTclruFw2HwOcB+aa7Q1EMFe0E?=
 =?us-ascii?Q?+H+peXADJlnhX0Us6b1qb4S9ucmNepj6LrF9T1MNPfHQQjZJeZ1Y1QCwa6Mg?=
 =?us-ascii?Q?h1CZjJ45EeNcHe9667Fdlg4fYkQYFnJb61mtK1Ja2k3M?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62797A394D13314B94282662E009A45C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f6b7a9-5c7c-4af5-7158-08d998a14459
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 16:54:25.2365
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUOZSaru2nWdBjYfCPBPkdyDFATueeMXSG/upnamMzbuKmRCkw2/OKqR+aeqlxMM6aJKYedzhrqIop+KLFGmjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 03:20:03PM +0300, Nikolay Aleksandrov wrote:
> On 26/10/2021 14:25, Vladimir Oltean wrote:
> > On Tue, Oct 26, 2021 at 01:40:15PM +0300, Nikolay Aleksandrov wrote:
> >> Hi,
> >> Interesting way to work around the asynchronous notifiers. :) I went o=
ver
> >> the patch-set and given that we'll have to support and maintain this f=
ragile
> >> solution (e.g. playing with locking, possible races with fdb changes e=
tc) I'm
> >> inclined to go with Ido's previous proposition to convert the hash_loc=
k into a mutex
> >> with delayed learning from the fast-path to get a sleepable context wh=
ere we can
> >> use synchronous switchdev calls and get feedback immediately.
> >=20
> > Delayed learning means that we'll receive a sequence of packets like th=
is:
> >=20
> >             br0--------\
> >           /    \        \
> >          /      \        \
> >         /        \        \
> >      swp0         swp1    swp2
> >       |            |        |
> >    station A   station B  station C
> >=20
> > station A sends request to B, station B sends reply to A.
> > Since the learning of station A's MAC SA races with the reply sent by
> > station B, it now becomes theoretically possible for the reply packet t=
o
> > be flooded to station C as well, right? And that was not possible befor=
e
> > (at least assuming an ageing time longer than the round-trip time of th=
ese packets).
> >=20
> > And that will happen regardless of whether switchdev is used or not.
> > I don't want to outright dismiss this (maybe I don't fully understand
> > this either), but it seems like a pretty heavy-handed change.
> >=20
>=20
> It will depending on lock contention, I plan to add a fast/uncontended ca=
se with
> trylock from fast-path and if that fails then queue the fdb, but yes - in=
 general

I wonder why mutex_trylock has this comment?

 * This function must not be used in interrupt context. The
 * mutex must be released by the same task that acquired it.

> you are correct that the traffic could get flooded in the queue case befo=
re the delayed
> learning processes the entry, it's a trade off if we want sleepable learn=
ing context.
> Ido noted privately that's usually how hw acts anyway, also if people wan=
t guarantees
> that the reply won't get flooded there are other methods to achieve that =
(ucast flood
> disable, firewall rules etc).

Not all hardware is like that, the switches I'm working with, which
perform autonomous learning, all complete the learning process for a
frame strictly before they start the forwarding process. The software
bridge also behaves like that. My only concern is that we might start
building on top of some fundamental bridge changes like these, which
might risk a revert a few months down the line, when somebody notices
and comes with a use case where that is not acceptable.

> Today the reply could get flooded if the entry can't be programmed
> as well, e.g. the atomic allocation might fail and we'll flood it again, =
granted it's much less likely
> but still there haven't been any such guarantees. I think it's generally =
a good improvement and
> will simplify a lot of processing complexity. We can bite the bullet and =
get the underlying delayed
> infrastructure correct once now, then the locking rules and other use cas=
es would be easier to enforce
> and reason about in the future.

You're the maintainer, I certainly won't complain if we go down this path.
It would be nice if br->lock can also be transformed into a mutex, it
would make all of switchdev much simpler.=
