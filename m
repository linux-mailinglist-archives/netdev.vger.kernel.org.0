Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97889372C2D
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 16:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhEDOhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 10:37:33 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:1347
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231316AbhEDOhc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 10:37:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BO4Tof2ph3Z0h6auBIU8rq/DL0J/HzjyqYPbT+SPD8C93xqoLRPMjQBDKAt1D59TlCI1TpOTHI9fmDFl+w+5pAQju+gP5gU2IoprIkiRSJc/pcHTyO370NyNcqBi7Q8xwh7pMC1hwRcle+n5c73jfPlOjCjz0LC9kYwuLZBO7ovSAVtr9S/jJBLVOm40sj6ZjEzXHIn9xy8PBNOnz2yCKmEn1FD6Pu9H6NjFDqKtW26xOkdq7FYDX6vpsYuMrMnhDkwECwjnot/ZJ5dD7eIc+SzRC2Lg0+KRX8uD0Z6cpbr5iBq+1Jp+nkFd6iv8Dyoyjoy13FreBac5WNB7xHTDZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gymCQqz87OhwqB4Dg1suFAkIMnas3GbD+WsBN4yJTTM=;
 b=D7exX779hQyYsBuCBhCHlynELacFTaneR+u2CfIMAtuWZztS23DfgH6uVlGv16/5fQb1BM6lyCG6xFuje2e+6bntYGAGdTOB+DpLE5NY5e1b01EwtO1UHbOAqEtVcIhu2zuQbJFoTOr1Nn0D9CAoHUheEuU7agaRQBKK7g7IoyxgrNZ+R/s+YwdVw2AwH6qUVoXP0LixwNRI936qNOl1UC8mQOMdzt7TRHxdNgJ/q5S9tr+lbtCPsrGZkddgsvGED1eu98bybdrKIYpJum+pHCAdYYUTkfLpTPUCZtTqrzZQuDkwZsavoFuXnhzOW+d6061BDF0o3SfAwzzBBu/8FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gymCQqz87OhwqB4Dg1suFAkIMnas3GbD+WsBN4yJTTM=;
 b=PIaBBskVnWJbOC9KRdE2C+wbsWuG2wuqi+/pF7gXos29NutOTBTxHoAhNwFzAddQZIc+nEeFTvXI1flH8ZV77RJxb/MUzn6QBXmIolSYCN+PL91K8xzd/og7d/rr4heN6BGwFUCA7l1V5Vur9n7TtTTs9FATUQshEsSNMAfV4CY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Tue, 4 May
 2021 14:36:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 14:36:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Colin Foster <colin.foster@in-advantage.com>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "supporter:OCELOT ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:OCELOT ETHERNET SWITCH DRIVER" <netdev@vger.kernel.org>
Subject: Re: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Thread-Topic: [RFC PATCH vN net-next 2/2] net: mscc: ocelot: add support for
 VSC75XX SPI control
Thread-Index: AQHXQKP/w6NmRV8LhkOQoP6VPcP45arTQY4AgAAH3ACAAA+UgIAAC3uA
Date:   Tue, 4 May 2021 14:36:34 +0000
Message-ID: <20210504143633.gju4sgjntihndpy6@skbuf>
References: <20210504051130.1207550-1-colin.foster@in-advantage.com>
 <20210504051130.1207550-2-colin.foster@in-advantage.com>
 <YJE+prMCIMiQm26Z@lunn.ch> <20210504125942.nx5b6j2cy34qyyhm@skbuf>
 <YJFST3Q13Kp/Eqa1@piout.net>
In-Reply-To: <YJFST3Q13Kp/Eqa1@piout.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.127.41.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed5d19f1-7894-4ffd-a792-08d90f0a0475
x-ms-traffictypediagnostic: VI1PR04MB5854:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5854B5DF7DB50759DFF69C3EE05A9@VI1PR04MB5854.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxKDylaJIHDlfQPLOe9lKNJKqZy8VSmKFvWwzaZdrQ0BTNQp69Wp9M0eHmaiJFzb0ICia+xWyknWA3TfR2sYeJOLdJFWBI7T3JRBnB4qvxUWkYh6lI7UENHPiOktn3ICKXLgcLBLJmd3g9216gLxPzSaX8nyjUzucKE+mM3ecVCO8evZPf+n18YJPD16AmMkoPvRPCq3Q9uxTfjbdracnIZMlWnILHwG+/zkR+i6A1xvpDAUzUNLmztmxYdIGz1voBMS8L+tlSw+Ms3J9DIiNRMwb+NK9uTlgFK4E7Hfjs+/VXljAPoMeg+byzu+rbTZLZYbrWjJbW5F3ZJ2Oy8ATXszCt23MXua9k0vvO8RHy0lLprM4xWQ9pr8FkGvSYubqxayYM3LDPhQX0vA37/eENfVWLtx8Fopahe4ZdTTC1Q+xhJ3YSDW8+9095KaJ/AGjachh/FZEp2RdsiVAl7FJgX6wKR+a+iHiyCzXipxuH3IvePLJwBxyZdZJSMSq8PRtCBjHyO8uGbFZh+WT5wq8J1GgXz89qHrVmAPFI5UpnNJJ4dX9XYscRz8Wh1xF7BndR2HpeKK4+gX9Xphtj8lSGHVUfL5mrLrz8PvOa44hZw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(396003)(346002)(366004)(136003)(39850400004)(376002)(6916009)(26005)(186003)(6506007)(8936002)(2906002)(66556008)(6512007)(33716001)(5660300002)(44832011)(86362001)(64756008)(76116006)(66446008)(6486002)(71200400001)(66476007)(91956017)(7416002)(9686003)(38100700002)(66946007)(1076003)(478600001)(83380400001)(8676002)(316002)(4326008)(54906003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?zLSznDMVpZBGy7QUMrVpSYFuvHHj2cepWZXjhpTI9cDP1IwsFepILa+wI6bB?=
 =?us-ascii?Q?gL/wqd6CJ0iPY7AGoc7wDBcmBTil1gbl0Ghd2GZNV4pPKpKSbDmro8e6DcMc?=
 =?us-ascii?Q?7JsEPYSzd9ur0D2qzkUQY88iKx2YpJu444Gtz0Xn4VUvxs7Gu8nsHlm+jaIz?=
 =?us-ascii?Q?NFSMq25S2BF+eu2hHEhcI9g4w+BItvlDBqL+9wgzXUlYRXds6WyxPTfC98gf?=
 =?us-ascii?Q?UWUESKnVDFxki58wEQK9GI6hh8WqqaTdHoY+7eclEsXEJwBuuB4X8sgCWyPH?=
 =?us-ascii?Q?7+ETcdimTsIccX/iXQ+HMyD02CqYdj2DuE7uu2i926igd86QKvnhG8KpyL92?=
 =?us-ascii?Q?EZHytHM73oLtGAAlm1HWlivd8wGogB4SHUfT6RArAeqIt59jm60cuhTSZOc+?=
 =?us-ascii?Q?Lfb0bJyXP3g+csrPuh2EqySrA5kpfg1rTjqViqyWBNeZEwWZEmtzS+fMUsal?=
 =?us-ascii?Q?UQPACacgugfg3q1d3ic8PPyg5eRl3T55aOABk2pRh3Igta0hZycNrWH7FsKW?=
 =?us-ascii?Q?p1fknBrjvYUFbEhiG2G/069ryoMgWSupq9n/xlvyBIXeWhIQx8ntxe961QJe?=
 =?us-ascii?Q?TwtM4Wx58kwouLW3RX2zQnhkrkGwHVW2zxvBSYWLswgthOxQ1IqpM0hA1Swk?=
 =?us-ascii?Q?zVnezWBv6Mn38XBwa5YyCaOnqoJ7YCUDFbetyKo96t6W3aQ1eD3ZPbuIxY/V?=
 =?us-ascii?Q?6t6Fq0ELWCKavACWeST5+i5TYMHs18q5khXlzSH0e+quyu+6spqEunXaz9E1?=
 =?us-ascii?Q?APtNYzMHMCwi42vc5Vj1JU+68SzgimDHqFsR1JhVf5alDMPcYFJ+tWGC2WwX?=
 =?us-ascii?Q?QPoCtGF0sm6anau+051UcjPYVQgPTqn8I4A563+BdUReejtd/XmpiS+YGHRs?=
 =?us-ascii?Q?i15KkTTGXxfwzSjaYZRDxnQkKJ/4hUWrZZblb8tVUWugWHGkxIBoUeRPHC67?=
 =?us-ascii?Q?IDmeEcujTvlF5YAuegCpv26X7XJmcHFavIW4ytkKEBBf4lqTWrxTORSRxVth?=
 =?us-ascii?Q?xtJIPsKXqLRmE8GkD//6VIyNfTKJnPFZ+Ljri0uKGQec81RNGkbevQQBb/ZN?=
 =?us-ascii?Q?TtgFFwoFmftDwXIDdsMqN+f5F6Ubcqb9iBwdZnQ+ZYXbsHeyeMTOGCvf+r8X?=
 =?us-ascii?Q?iY5Ee06zPqYEjU8Z2Rs1jjKXIXPdPPsZg1pocUsTK4DrHUkULyyECFhYhDve?=
 =?us-ascii?Q?m8vEaPV88nQqqB7JJ8UzCDaJXXe+6N1jrlAGq2YOBamJwLFA7P3Ujy5PIPxI?=
 =?us-ascii?Q?QE8qhEq2eAJa1GQhRcDA03tD/zYRejHw24hVEauQysyeVHSlHEijdSWbGnWd?=
 =?us-ascii?Q?nvOCn3WHke1m81zkFDo2BJh8?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <78776726A1DC1644A2756BBC809027F1@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed5d19f1-7894-4ffd-a792-08d90f0a0475
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2021 14:36:34.6636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FThTSoe2jnC9V90Fuz5K8oUiiWygJcZmzKKNoQlUxqsYNgu0vWmUh0WSRkSv4XPGlpUqDk1FHRAdpBq01sVCHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 03:55:27PM +0200, Alexandre Belloni wrote:
> On 04/05/2021 12:59:43+0000, Vladimir Oltean wrote:
> > > > +static void vsc7512_phylink_validate(struct ocelot *ocelot, int po=
rt,
> > > > +				     unsigned long *supported,
> > > > +				     struct phylink_link_state *state)
> > > > +{
> > > > +	struct ocelot_port *ocelot_port =3D ocelot->ports[port];
> > > > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) =3D {
> > > > +		0,
> > > > +	};
> > >=20
> > > This function seems out of place. Why would SPI access change what th=
e
> > > ports are capable of doing? Please split this up into more
> > > patches. Keep the focus of this patch as being adding SPI support.
> >=20
> > What is going on is that this is just the way in which the drivers are
> > structured. Colin is not really "adding SPI support" to any of the
> > existing DSA switches that are supported (VSC9953, VSC9959) as much as
> > "adding support for a new switch which happens to be controlled over
> > SPI" (VSC7512).
>=20
> Note that this should not only be about vsc7512 as the whole ocelot
> family (vsc7511, vsc7512, vsc7513 and vsc7514) can be connected over
> spi. Also, they can all be used in a DSA configuration, over PCIe, just
> like Felix.

I see. From the Linux device driver model's perspective, a SPI driver
for VSC7512 is still different than an MMIO driver for the same hardware
is, and that is working a bit against us. I don't know much about regmap
for SPI, specifically how are the protocol buffers constructed, and if
it's easy or not to have a driver-specified hook in which the memory
address for the SPI reads and writes is divided by 4. If I understand
correctly, that's about the only major difference between a VSC7512
driver for SPI vs MMIO, and would allow reusing the same regmaps as e.g.
the ones in drivers/net/ethernet/ocelot_vsc7514.c. Avoiding duplication
for the rest could be handled with a lot of EXPORT_SYMBOL, although
right now, I am not sure that is quite mandated yet. I know that the
hardware is capable of a lot more flexibility than what the Linux
drivers currently make of, but let's not think of overly complex ways of
managing that entire complexity space unless somebody actually needs it.

As to phylink, I had some old patches converting ocelot to phylink in
the blind, but given the fact that I don't have any vsc7514 board and I
was relying on Horatiu to test them, those patches didn't land anywhere
and would be quite obsolete now.
I don't know how similar VSC7512 (Colin's chip) and VSC7514 (the chip
supported by the switchdev ocelot) are in terms of hardware interfaces.
If the answer is "not very", then this is a bit of a moot point, but if
they are, then ocelot might first have to be converted to phylink, and
then its symbols exported such that DSA can use them too.

What Colin appears to be doing differently to all other Ocelot/Felix
drivers is that he has a single devm_regmap_init_spi() in felix_spi_probe.
Whereas everyone else uses a separate devm_regmap_init_mmio() per each
memory region, tucked away in ocelot_regmap_init(). I still haven't
completely understood why that is, but this is the reason why he needs
the "offset" passed to all I/O accessors: since he uses a single regmap,
the offset is what accesses one memory region or another in his case.

I see Colin uses some regmap accesses in order to set up the SPI bus
interface:

felix_spi_probe
-> felix_spi_init_bus

before the ocelot hardware library is up and running, which is at this
point:

felix_spi_probe
-> dsa_register_switch
   -> felix_setup
      -> ocelot_init

I suspect that if Colin could defer his felix_spi_init_bus work until
some later point, such as until vsc7512_reset, then he could preserve
the existing code structure, with one regmap per register region as
opposed to a single regmap.

By the way, I am not opposed to more refactoring being done to the felix
driver itself, for example if ocelot_init needs to be done before
dsa_register_switch, I'm in favor of that if it's helpful. There is a
comment on top of felix_setup() which is no longer true, it reads:

/* Hardware initialization done here so that we can allocate structures wit=
h
 * devm without fear of dsa_register_switch returning -EPROBE_DEFER and cau=
sing
 * us to allocate structures twice (leak memory) and map PCI memory twice
 * (which will not work).
 */

What was actually wrong there has been solved in the meantime by commit
b4024c9e5c57 ("felix: Fix initialization of ioremap resources"). So now
there isn't any problem with EPROBE_DEFER, we can initialize the regmap
anywhere.=
