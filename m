Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1195C45F684
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 22:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbhKZVhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 16:37:43 -0500
Received: from mail-eopbgr130053.outbound.protection.outlook.com ([40.107.13.53]:20705
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237385AbhKZVfm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 16:35:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g4IJJ/JEx93Wq9NuDoa6c9K8uHNilEap6Xozd0w42ab0JMJFwCWr09xQXmBhyBFO1VeP9/jKdkDPVTLdVrgHogq4y8lQVgIHsL7lpKXBgUVEfKjRllSHI4KUU269rd0p8hWQOmhspK4eDTnaUUyrFLWGokzz2VYQNYx+J8qEqjEjfnd8fWXCB8HbM5Wm6uGYjHuzfoqL4dYUJEkuU5MZBPAUH0ka5kCyR6Fjef9K5kUifWak580JX2a2kikdouJggpTGklVw5hL25pMVQvOT+zHTF6qfc3FpWr5b4HMtJUA11ibP5TddZSLQg4wm0Da5aumlF0kV2kp4IxoLBfIepA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTl0GNk91v0WRALhKvTtrRpYSvPf5crZ+sN9L34SxJw=;
 b=TU1xupiJIa0nnbsH9xsZ1EoW75rSXdWboot5QTwZD47ffwPFvToUVesef1Aevqv54DwRB37RlLiEVsXcXsGG4VIGd2PSxs6IXiiEFkPEMxO2LHb7VyW2Boi/sM/z+yEPHXYhe/E3I1D73LwfL+ZqpkAlZcjtrB1mexnMhUVoYlMZeaH5pOa7zON6Te4mw+Xgkbh4eM5yt97qqV+fGKUCrzw+1an8rCYh8q4ULLfJU+PPwOSQz5Zq61+QxcPVGBUE60iKQ7ldktfgiHQEUaa8dMntk5ot+4z/nkj8Rbr/KVtEOLWsR7PuqsNiZBtQKghpyNIfdBKvPwXJWHPXWMMkaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTl0GNk91v0WRALhKvTtrRpYSvPf5crZ+sN9L34SxJw=;
 b=ECPUStoIVoy9nr7H/VlFj7ENkEIU9M+/ljosr7da79ZKVJL6sAKkOpdzYvlS/v2gbKdQAS507FNP3wR3F1CjIr0lFR4tw7cQykta56PfSIMrkw6dYeciKipi30DNoCq87PawvxJRFCr3SGQW97W+vdRz3dHLKmw4I4k3WYuSkag=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4688.eurprd04.prod.outlook.com (2603:10a6:803:6a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 26 Nov
 2021 21:32:26 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 21:32:26 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Colin Foster <colin.foster@in-advantage.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared
 mscc-miim driver for indirect MDIO access
Thread-Topic: [PATCH v2 net-next 3/3] net: dsa: ocelot: felix: utilize shared
 mscc-miim driver for indirect MDIO access
Thread-Index: AQHX4jjkQZBGgXEJxkWfdqMtJqFeg6wU/PsAgAE+jQCAABo7gA==
Date:   Fri, 26 Nov 2021 21:32:26 +0000
Message-ID: <20211126213225.okrskqm26lgprxrk@skbuf>
References: <20211125201301.3748513-1-colin.foster@in-advantage.com>
 <20211125201301.3748513-4-colin.foster@in-advantage.com>
 <20211126005824.cu4oz64hlxgogr4q@skbuf> <20211126195832.GA3778508@euler>
In-Reply-To: <20211126195832.GA3778508@euler>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 595d376f-1261-4c80-efec-08d9b1243e0f
x-ms-traffictypediagnostic: VI1PR04MB4688:
x-microsoft-antispam-prvs: <VI1PR04MB4688244C46FFB86DD33F665CE0639@VI1PR04MB4688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VBbuKmELVaQnbiNWAkp+eoLEhjCGUjYprCAUzCehpVerw6RxY/y8A7A4RmQuEMPew6Ig4/0/4N85fvqzK+lhWbHvm7+AB9c3PKnjxTgZ2gBnoBFs6Ub6k/Pou7x0E7dStf3KM6zBQq37+v6J3kbef6NVMXVlRg9pPPy/RN3SKfxlgf/lm2iQCKj/8UHf7TfsrRd2XFGM1c87qETZLe0PJAywN0SxHN62enxuFJrC6l1CkisW0TgjlGTAwUP7xcl8ijWeqDDyA/odzz2Krf6TqqOLYD3a8cFnU4zRjeKBsyNfjcNul3R6EtBy32rTfODJq8qi0DQpO/+hSxowFe6Ni+pM3CxUJk6O/no+2oFpd7FGXFhfLx5h40KUDEyc6OcYwEK9b9otNKpX2vPQWFtrJwrys4Y/sxdHkGvES/N6eIualQ6Q14ewkG3kWbPkc+/Y2wBUujtQ4OyMl2Yt2v0Pr6pTTacePPaNnl6zrMJnmdgdbwgOciaodDnz83ueKl9+9hoHef3hbNqRD+Nifc0eljslqgH1hLzzOaLG8sL+MZF4OjSyx3ujPf7uSrh9qeEt6irYhsO/1Jc5hi8eMNvUNCHyiJhibamnBiyLsGhBBqlwzQGJVXalkEtyaEicxgC0ZGhG5UL4XZ561k+wiHMuVENUIyIx77eAEiluRjd6iXc4r2ODiqtp5JEh0Q/dFmS+tZ1o9qcJXzgUK9ijw9h9IQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6916009)(6486002)(1076003)(186003)(4326008)(8936002)(8676002)(76116006)(9686003)(6512007)(71200400001)(66946007)(2906002)(66446008)(64756008)(44832011)(6506007)(66476007)(86362001)(66556008)(5660300002)(316002)(122000001)(54906003)(26005)(91956017)(33716001)(83380400001)(38070700005)(7416002)(508600001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ACK0Z0L8+lesrPGWIqHdtky8V+4g7M6loonyEe82ZefSaqMYhwtzdGBEg6pp?=
 =?us-ascii?Q?VSOC1KXAlz2382oa37bbrEvVhl1+Z0odZgzRMyjZtV604vXSydQNzv45m/jQ?=
 =?us-ascii?Q?Uj2dd4CsS+FQxHe4gZEzd1JcsM2w9tu67Co5jEksDgnzM6l1BqjELASqWRpT?=
 =?us-ascii?Q?RUEbwpOoX80QOMYOqTDK2XX43bRBa4rHPiEPKwN7aB0DVF5iLVt+vuDeSRkC?=
 =?us-ascii?Q?8UheG6RZfavruiHQ0J2qDD2OJ8KZoDRYOrO1HvQcwviDxZaFxyx/vaZMuF9j?=
 =?us-ascii?Q?+c2iaI7CcJZwOqgtgwF/WNM2aZhEOeq4aVqCCG6Ymr7g/lydmB2/Ux2VYUv2?=
 =?us-ascii?Q?2JbHb0BS2KDc630yWOJd6EoNst9YRHjV3SnD6bkYGG3+qq31KLVAfLKDFrwJ?=
 =?us-ascii?Q?JgqONj0do2jUZdNVFJPhekyvACOOlFfsgNzvNGS52c/JRETopGiOSRmqvn5o?=
 =?us-ascii?Q?/2rkFmUbbu3BRL0rl4ervzMchn2rWxsh33p9BlX9NS4stNmgihAIxkvZOC88?=
 =?us-ascii?Q?tsMGB3l3tg0C1q82w+hE6UQgiGBV+cTHdESLHDtsSJX5CLl3pJe95Rleanbb?=
 =?us-ascii?Q?S1PGuZPtp/7GrQ5xwMMgk4eEVwH9dA4aWD+b2VLAsh4REnfOMJAw6R40iG96?=
 =?us-ascii?Q?VsdpWnoNIggvkwiJeH0AkSFN42eskRlvKJQb6zTDYdKJcIhRSnh+Mme1rCnN?=
 =?us-ascii?Q?QqOyBqSNoVqoAMCeVxCk/zbPtHQvYBADQAkE2MXEpaY8M1vhkeWnHCq63H7r?=
 =?us-ascii?Q?f6DD9I0hiZKak+KZbo0ELjxBuKh7NCp66Ay0N//PuuydrvS6HBavyf0QBERQ?=
 =?us-ascii?Q?e0BNWo7+rkPLgZTrSp7d0hd+AJTQDt+T6+1LcVp3IRKWIwe3cHBsjUH78mob?=
 =?us-ascii?Q?dN8Ehld/I0bhCYMFJkM01A6uPmoHx3eOdfB2lk6RIDeY7p0ytiw7R5KvXUvv?=
 =?us-ascii?Q?TjcthN/pAli643I4jy96S+SKdBFXelC22B4FNlOr6prOJid29A+3aYxNQtas?=
 =?us-ascii?Q?u40HUF+Ri81bEE6P4w7hC8FB4Bx0yVZrgGXaWNBs2NrgOeX6Te4kJb9GwnlX?=
 =?us-ascii?Q?cNRLnqWDJ5Sz7QF90bKJzbcThhWIBBPiZqjOkthS/c8/1J8/4HwHqIPawnt9?=
 =?us-ascii?Q?cj8gQdyyv91mZ9JRL/Y+LxsFGrZFFZDJcw+syHv+k3z+nc0YpqXr5PAn+IbX?=
 =?us-ascii?Q?gO5K0rs4aFuncuYlVm3Iks6aLNGy+yGwuf7BEU7XJkUPR1s8vFm99OYfPlnA?=
 =?us-ascii?Q?tbAi3+MULOpc+aQYxCOQ83cLzidiCOk2lXJaD+6A7nGBBnUEH7DfPags+ga/?=
 =?us-ascii?Q?uZN/PIC6f5JGjagRsV8vmHzcmGBeaDFj4Q47Ja5YuiWE4LgmxK6f2VbhvD0D?=
 =?us-ascii?Q?3aRSrt3MfhyrIX9/Sq/Oe0/njiYY/w0NUhKnPjwHdMLQE8F9c3aLf7P/TAAn?=
 =?us-ascii?Q?InXkfz7Kl86QaQRk6vqDXVAYn7rkY/SZ85qUZgAJxeJEWcIqBOwWcijY8N67?=
 =?us-ascii?Q?V82mlnMOWoUQcHFyAdJsDfk1wJgtR+ADaAhxPtm6hbgEzd3Yuc0dZmXLSBHC?=
 =?us-ascii?Q?N7jvHLC7GRm7ls6KoP1SyWQjCa19rjdnymX9dUjQFl2lZLHhDepiqPKRmGFl?=
 =?us-ascii?Q?B3Ik3qHxHxrt+9zguRrlP+c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <38B8A3029EF94042912AFFBE1C13A849@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 595d376f-1261-4c80-efec-08d9b1243e0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 21:32:26.6427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7JjcyFwyO/w0MJ9oOcPAJlo08NF4zUN2ZRAGrGWpKzhcltSdGKRw+diMkiEhaZ8WPyNgvMC6DDoKv7cE94Wduw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 11:58:32AM -0800, Colin Foster wrote:
> Hi Vladimir,
>
> On Fri, Nov 26, 2021 at 12:58:25AM +0000, Vladimir Oltean wrote:
> > On Thu, Nov 25, 2021 at 12:13:01PM -0800, Colin Foster wrote:
> > > Switch to a shared MDIO access implementation by way of the mdio-mscc=
-miim
> > > driver.
> > >
> > > Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> > > ---
> >
> > I'm sorry, I still wasn't able to boot the T1040RDB to test these, it
> > looks like it's bricked or something. I'll try to do more debugging
> > tomorrow.
>
> No rush - I clearly have a couple things yet to work out. I appreciate
> your time!

The T1040RDB is now unbricked. Now it hangs during early kernel boot here:

[    0.010255] clocksource: timebase mult[1aaaaaab] shift[24] registered
[    0.019577] Console: colour dummy device 80x25
[    0.024016] pid_max: default: 32768 minimum: 301
[    0.028796] Mount-cache hash table entries: 8192 (order: 4, 65536 bytes,=
 linear)
[    0.036163] Mountpoint-cache hash table entries: 8192 (order: 4, 65536 b=
ytes, linear)
[    0.045211] e500 family performance monitor hardware support registered
[    0.051891] rcu: Hierarchical SRCU implementation.
[    0.057791] smp: Bringing up secondary CPUs ...

At this pace, I hope we'll have something by the end of the year, because
then I'll need the space in the living room for the Christmas tree :D

> > > -	ret =3D regmap_read(miim->regs, MSCC_MIIM_REG_DATA, &val);
> > > -
> > > +	ret =3D regmap_read(miim->regs,
> > > +			  MSCC_MIIM_REG_DATA + miim->mii_status_offset, &val);
> >
> > I'd be tempted to create one separate regmap for DEVCPU_MIIM which
> > starts precisely at 0x8700AC, and therefore does not need adjustment
> > with an offset here. What do you think?
>
> I've gone back and forth on this.
>
> My current decision is to bring around those offset variables. I
> understand it is clunky - and ends up bleeding into several drivers
> (pinctrl, miim, possibly some others I haven't gotten to yet...) I'll be
> the first to say I don't like this architecture.
>
> The benefit of this is we don't have several "micro-regmaps" running
> around, overlapping.
>
> On the other hand, maybe smaller regmaps wouldn't be the worst thing. It
> might make debugging pinctrl easier if I have
> sys/kernel/debug/regmap/spi0.0-ocelot_spi-devcpu-gcb-gpio insetead of
> just sys/kernel/debug/regmap/spi0.0-ocelot_spi-devcpu-gcb.
>
>
> So while my initial thought was "don't make extra regmaps when they
> aren't needed" I'm now thinking "make extra regmaps for drivers when
> they make sense." It would also make behavior consistent with how the
> full VSC7514 driver acts.

Yeah, micro-regmaps aren't the worst thing. That prize would probably go
to the T1040RDB for the pains it's putting me through.

> The last option I haven't put much consideration toward would be to
> move some of the decision making to the device tree. The main ocelot
> driver appears to leave a lot of these addresses out. For instance
> Documentation/devicetree/bindings/pinctrl/mscc,ocelot-pinctrl.txt.
> That added DT complexity could remove needs for lines like this:
> > > +			     ocelot->map[GCB][GCB_MIIM_MII_STATUS & REG_MASK],
> But that would probably impose DT changes on Seville and Felix, which is
> the last thing I want to do.

The thing with putting the targets in the device tree is that you're
inflicting yourself unnecessary pain. Take a look at
Documentation/devicetree/bindings/net/mscc-ocelot.txt, and notice that
they mark the "ptp" target as optional because it wasn't needed when
they first published the device tree, and now they need to maintain
compatibility with those old blobs. To me that is one of the sillier
reasons why you would not support PTP, because you don't know where your
registers are. And that document is not even up to date, it hasn't been
updated when VCAP ES0, IS1, IS2 were added. I don't think that Horatiu
even bothered to maintain backwards compatibility when he initially
added tc-flower offload for VCAP IS2, and as a result, I did not bother
either when extending it for the S0 and S1 targets. At some point
afterwards, the Microchip people even stopped complaining and just went
along with it. (the story is pretty much told from memory, I'm sorry if
I mixed up some facts). It's pretty messy, and that's what you get for
creating these micro-maps of registers spread through the guts of the
SoC and then a separate reg-name for each. When we worked on the device
tree for LS1028A and then T1040, it was very much a conscious decision
for the driver to have a single, big register map and split it up pretty
much in whichever way it wants to. In fact I think we wouldn't be
having the discussion about how to split things right now if we didn't
have that flexibility.

> So at the end of the day, I'm now leaning toward creating a new, smaller
> regmap space. It will be a proper subset of the GCB regmap. This would be
> applied here to mdio-mscc-miim, but also the pinctrl-ocelot (GCB:GPIO) an=
d
> pinctrl-microchip-sgpio (GCB:SIO_CTRL) drivers as well for the 7512_spi
> driver. I don't know of a better way to get the base address than the
> code I referenced above. But I think that is probably the design I
> dislike the least.

An offset is not all that bad TBH. I just felt like I should bring it up.
It's up to you.

> > >  	if (ret < 0) {
> > >  		WARN_ONCE(1, "mscc miim read data reg error %d\n", ret);
> > >  		goto out;
> > > @@ -134,7 +140,9 @@ static int mscc_miim_write(struct mii_bus *bus, i=
nt mii_id,
> > >  	if (ret < 0)
> > >  		goto out;
> > >
> > > -	ret =3D regmap_write(miim->regs, MSCC_MIIM_REG_CMD, MSCC_MIIM_CMD_V=
LD |
> > > +	ret =3D regmap_write(miim->regs,
> > > +			   MSCC_MIIM_REG_CMD + miim->mii_status_offset,
> > > +			   MSCC_MIIM_CMD_VLD |
> > >  			   (mii_id << MSCC_MIIM_CMD_PHYAD_SHIFT) |
> > >  			   (regnum << MSCC_MIIM_CMD_REGAD_SHIFT) |
> > >  			   (value << MSCC_MIIM_CMD_WRDATA_SHIFT) |
> > > @@ -149,16 +157,19 @@ static int mscc_miim_write(struct mii_bus *bus,=
 int mii_id,
> > >  static int mscc_miim_reset(struct mii_bus *bus)
> > >  {
> > >  	struct mscc_miim_dev *miim =3D bus->priv;
> > > +	int offset =3D miim->phy_reset_offset;
> > >  	int ret;
> > >
> > >  	if (miim->phy_regs) {
> > > -		ret =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0);
> > > +		ret =3D regmap_write(miim->phy_regs,
> > > +				   MSCC_PHY_REG_PHY_CFG + offset, 0);
> > >  		if (ret < 0) {
> > >  			WARN_ONCE(1, "mscc reset set error %d\n", ret);
> > >  			return ret;
> > >  		}
> > >
> > > -		ret =3D regmap_write(miim->phy_regs, MSCC_PHY_REG_PHY_CFG, 0x1ff);
> > > +		ret =3D regmap_write(miim->phy_regs,
> > > +				   MSCC_PHY_REG_PHY_CFG + offset, 0x1ff);
> > >  		if (ret < 0) {
> > >  			WARN_ONCE(1, "mscc reset clear error %d\n", ret);
> > >  			return ret;
> > > @@ -176,8 +187,9 @@ static const struct regmap_config mscc_miim_regma=
p_config =3D {
> > >  	.reg_stride	=3D 4,
> > >  };
> > >
> > > -static int mscc_miim_setup(struct device *dev, struct mii_bus **pbus=
,
> > > -			   struct regmap *mii_regmap, struct regmap *phy_regmap)
> > > +int mscc_miim_setup(struct device *dev, struct mii_bus **pbus, const=
 char *name,
> > > +		    struct regmap *mii_regmap, int status_offset,
> > > +		    struct regmap *phy_regmap, int reset_offset)
> > >  {
> > >  	struct mscc_miim_dev *miim;
> > >  	struct mii_bus *bus;
> > > @@ -186,7 +198,7 @@ static int mscc_miim_setup(struct device *dev, st=
ruct mii_bus **pbus,
> > >  	if (!bus)
> > >  		return -ENOMEM;
> > >
> > > -	bus->name =3D "mscc_miim";
> > > +	bus->name =3D name;
> > >  	bus->read =3D mscc_miim_read;
> > >  	bus->write =3D mscc_miim_write;
> > >  	bus->reset =3D mscc_miim_reset;
> > > @@ -198,10 +210,15 @@ static int mscc_miim_setup(struct device *dev, =
struct mii_bus **pbus,
> > >  	*pbus =3D bus;
> > >
> > >  	miim->regs =3D mii_regmap;
> > > +	miim->mii_status_offset =3D status_offset;
> > >  	miim->phy_regs =3D phy_regmap;
> > > +	miim->phy_reset_offset =3D reset_offset;
> >
> > The reset_offset is unused. Will vsc7514_spi need it?
>
> Yes, the SPI driver currently uses the phy_regs regmap to reset the phys
> when registering the bus. I suppose it isn't necessary to expose that
> for Seville right now, since Seville didn't do resetting of the phys at
> this point.

Correct. One at a time.

> > > +	GCB_PHY_PHY_CFG,
> >
> > This appears extraneous, you are still using MSCC_PHY_REG_PHY_CFG.
>
> This is related to the comment above. They're both artifacts of the
> vsc7512_spi driver and aren't currently used in Seville. For the 7512
> this would get defined as 0x00f0 inside vsc7512_gcb_regmap. As suggested
> way above, it sounds like the direction (for vsc7512_spi) is to create
> two additional regmaps.
> One that would be GCB:MIIM. Then mdio-mscc-miim.c could refer to
> GCB:MIIM:MII_CMD by way of the internal MSCC_MIIM_REG_CMD macro, as an
> example.
>
> The same would go for MSCC_PHY_REG_PHY_CFG. If the driver is to reset
> the phys during initialization, a regmap at GCB:PHY could be passed in.
> Then the offsets MSCC_PHY_REG_PHY_CFG and MSCC_PHY_REG_PHY_STATUS could
> be referenced.

This could work.

> So to summarize these changes for v3:
> * Create new regmaps instead of offset variables

Optional.

> * Don't expose phy_regmap in mscc_miim_setup yet?
> * Don't create GCB_PHY_PHY_CFG yet?

Yes please.=
