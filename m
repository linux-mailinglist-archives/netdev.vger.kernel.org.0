Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6756E43FB7A
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbhJ2LiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:38:21 -0400
Received: from mail-vi1eur05on2040.outbound.protection.outlook.com ([40.107.21.40]:24448
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231912AbhJ2LiQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:38:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YoUg8BnLzWtNY6lC2s0/p1jlEmwTvjadAWk6EZjrXXzFjOxVnZPyCX4Rh+xkGOvlSOxPumZsc+cQvnH2CSruap7KUQ80I638ncr1rHGxmR/1RcVsxnmHYBhmi5bE2td7XUb7FRMqC/zO72T/7ybsdl1mXwVzPp+ecvbrp6ncbuVR0PHeEI2EvQ99soWE5gOltMGPE3pkTnE49KBvr55x9tqofeJfUmchQwN9ZfO55cjZoSz2kAGMSx3z9WjnrTGOGR1vb1coECLPXyLaKeScAB/BhBAVHgUY/5woBPo63/je7vaAUL8DuqU3P1qXLJTO9zQV5Pa/2IHSszgB0Ur59g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NvFgVrcW+lTV2TklYtwZHDSBg58kXx2MU7cBlyRaKRg=;
 b=RhyiVYQ8cy/IN0C/+g2qzxptjajjkF101eq5j0K+QxfaN6GisyhewPMjM3W/1GkjOlKl64LD6qHjuMq64yFPb9LEA4VsOYPcBTdGdbs+4BENbQezMT0WgMUUCdNu5zzgNFLPKeTh3UDNXMYNYzn2sEKTCpT8lJ0FwFbGKwT4Lv+VqDC5NC3ig9J9sIxcgNPfXe7NZiXRu+1RDg0wcnMZyyLs4uBOzT5LQg9v/iwWcP5QnUEERkxmSmwqNJMN/ZzfetqfCY6CGSCvAOUqPlMKcHMW6O8JNzkwalAlqPbyaK1ruka6mLXcYX9ICEtOUcgL8KlvrBCBatkxvR/AEyDfVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NvFgVrcW+lTV2TklYtwZHDSBg58kXx2MU7cBlyRaKRg=;
 b=gKnOr4WryHe1qLnpXh6EHDcAazcV0/YmZ6IYEcc+Xv2CB4Hre6GBZhGXub6xsUniSWGGFPcFj3XdmjqJxkCdqhQWLye3cgcvz81xUylDjPJEeNvJLqSEbyLqrugpIZZq7IDf4OHaFbLNKv2E/YEAxptyT75CoHyp1fwie7gbS+c=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6015.eurprd04.prod.outlook.com (2603:10a6:803:d8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 29 Oct
 2021 11:35:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Fri, 29 Oct 2021
 11:35:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Topic: [PATCH 1/3] net: ocelot: add support to get mac from device-tree
Thread-Index: AQHXzALaBu1tOZHr/E6Z7NAaubhTaKvoceaAgAACkQCAAAIaAIAABFaAgAADtgCAAQB3gIAAWxyA
Date:   Fri, 29 Oct 2021 11:35:43 +0000
Message-ID: <20211029113543.nhqwatylx4nrviei@skbuf>
References: <20211028134932.658167-1-clement.leger@bootlin.com>
 <20211028134932.658167-2-clement.leger@bootlin.com>
 <20211028140611.m7whuwrzqxp2t53f@skbuf> <20211028161522.6b711bb2@xps-bootlin>
 <20211028142254.mbm7gczhhb4h5g3n@skbuf> <20211028163825.7ccb1dea@xps-bootlin>
 <20211028145142.xjgd3u2xz7kpijtl@skbuf> <20211029080937.152f1876@fixe.home>
In-Reply-To: <20211029080937.152f1876@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66c2f72b-e826-4d73-d726-08d99ad03e64
x-ms-traffictypediagnostic: VI1PR04MB6015:
x-microsoft-antispam-prvs: <VI1PR04MB601516B6E7A8E53196848910E0879@VI1PR04MB6015.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BeDdKiVZy8FTjQwme6Dhq8SeYSWvKQ1vzI9KAcgdzo6QqIjMwxzX8F8vVRxCNnCzfWWjuOWiz+H7vIXcgn+KxJo81uVN9/8ARKUAht5iTHiYATk8iz/KCEbzq/+ahC6ZxIBDjRzfWPk21LJq5V7YyDlP5xijmXwDVfNj0xnoSXhGlUrRK8eZjqcF51+9RLlCpEC5AAuZY3Ss/td+qWfYZSF7T00mp2AAnIynl58/OQupxweP2K4abdN4wjUU95MKgY/rAsdHVUh13TKP49s5cOmo7mT9bjQphosxTMGBnsKHgQOXG89I5i0gsEE+a+Av65S+7gBeIvtTbG8pjbLMcVCP9B3x81XFu2B/AKN9Z6zXFQOCvWRGMgc1UBed0SkICYxgoA5GBKxUZ1jMNgL+wDzkHQGBxaK8frz4nY5N7pWuK0l6j588VByv716mRJRTHQTmoWZYeeYlYua8eeWFIctnX2Dx/IuOUJ5mXEgxBEBSel9ABj0JCbEhQ4i83wQGKjCA17DYpHu7Jjl2639coE/XkZYM2o5U9YQkPUP+umexPQMuyNZibzlLfuN3wqtMxf8p7S60RN/IaN6JDjP5k3mOopeFcLAWmAI7bz6P4D7UThXOCp3/0kPbGMDNACNKm5GNnmdntpvqKUguqqqr6Rna/12WQp5PJd1nR96O8ekeJ+1j+DHFj+N6Fj0+JEbc4fxGyK+RbMTUYANrahZr3pUXao4rgI1NiKhVA1gBWuKTNac0qeHt5w1upiqszx3qbuXyLu7It6X609Ass5WtMK19uwir8wQ5yk1P/A3p10Y=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66574015)(2906002)(71200400001)(1076003)(316002)(44832011)(66946007)(38100700002)(8676002)(76116006)(66476007)(6486002)(54906003)(186003)(6506007)(66446008)(966005)(38070700005)(5660300002)(64756008)(9686003)(4326008)(122000001)(86362001)(83380400001)(6916009)(8936002)(33716001)(508600001)(6512007)(66556008)(91956017)(26005)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hCBQiEM0JTbihTGEc5WwFQvXoLcbZm5fd5Bt/5pWIGHWXCAzNSyPshEduh?=
 =?iso-8859-1?Q?TUARyH5im6UVLbemMUxMrD5Hb0Mn0RSuTtiXhYc3fcmtl3FdL+d2ehCoUI?=
 =?iso-8859-1?Q?gzm2oLXS37vKAmFJ79g/irERT70bgJgdI5y0cWho8QOnsjMNg6p+Gg2mL6?=
 =?iso-8859-1?Q?Hu2kKIRgpH0FxQg7dxUwAGveN0G3rQIt1p6N8XuQhyjDzpydRUDdrx54Nj?=
 =?iso-8859-1?Q?6tnW3AB2zhy+S4M3OzSojv4xBg6zJnEZMrwqlVwXgslmS5DZdekzo3LGXV?=
 =?iso-8859-1?Q?YLmtlM7oADwhHbvBBm/GC/RqXscFO5RJ8CDss0GoB7wFWKNhkgreHTnJHY?=
 =?iso-8859-1?Q?55IIt8MEVOTLSOvYIYgC07BugwXf/lrLLmdHTVlANoJxDqo06gjM82n5VA?=
 =?iso-8859-1?Q?oIcfMn6QS0t+OQGHBBzWVfqUJL/v++PCWteGj67AzXPh/7foAStebwwPye?=
 =?iso-8859-1?Q?smMx72t80bXLQo4ddHSY6/y2ZvTSlxNilMJmYpfuEuwUA94UJbV5qFjXwX?=
 =?iso-8859-1?Q?BINzKT3vAy5FZdPd12ADwcXagnkJ2OLVHWywOd0Ksf3rKI7HIsOpW9Ni6e?=
 =?iso-8859-1?Q?qeBvtA1ru2VhwyMPhQ/9Gj06BhpLqShfuQRHaCd6Re6Yg1NpRCAtrVtlBO?=
 =?iso-8859-1?Q?Fb77Z8P7ZHqWrxrxpjuJzfPzYbHU/Dr1D4oRLoqG6Zd63xzcWmNhnUSsee?=
 =?iso-8859-1?Q?d0/AEuM/K3768PncSMCaa1VgSNSKx87+NcNLEMtx52PEW16UZLPRs2l5OK?=
 =?iso-8859-1?Q?ddnyj2gZv51Bb7r3W4yKiZVgSTCxLJqG08SCVPy5mMCCChm3BejA8fhrpt?=
 =?iso-8859-1?Q?Z3GJySKaep95N/xcnSzh+n2gSvFw7XXx+efx3MZKyK8+Wv0DiGUewQpiPy?=
 =?iso-8859-1?Q?KaRthBeXWbfZcB61ZewRo7Cuef94QxwfeAy/vW9T6ebcsOC93iRJDDh/tj?=
 =?iso-8859-1?Q?/ucDez7qZfzg+/Dx/BP3nSaZlkPeAxRgqFNNoopKbuq6MJVh8YfzE6K0tR?=
 =?iso-8859-1?Q?gaLPm7bHeEtBohrNOKfR57mo5RHfd7+iysHE82UEKYP0yaVNuwVmXD65y2?=
 =?iso-8859-1?Q?r6sB9lmy8Ia5yVqXYMddQr6q2HShP3BfmaKbSjGGY0eXHmGL99mwNnpSwm?=
 =?iso-8859-1?Q?aL3awlELxeSWB49OBk03CAyshOjFKs9nkbZ68Y/fajBfjBzEfK7V2dblD5?=
 =?iso-8859-1?Q?I3kWsrOdslp0AJ4qFA6TTzKX0lT3zNsYrwUGwsKEfzdeZfMOFE1Iovvyqa?=
 =?iso-8859-1?Q?TurEHAljyKTloKy4UW0koe3CNt+Gy/FMuMqiOPF+1qbFw9jIaFymqF4NvF?=
 =?iso-8859-1?Q?mLQv1Ih9VbzsdikftWufnTH5JTRFO3eJu6BYhIjCoQA82/PmRq/dVjlS8Z?=
 =?iso-8859-1?Q?m1GX7SsJ+9AXzoibgq5CySkSG3uQKmZJQj13PtW3aiOKaQigw0T+2NQEbd?=
 =?iso-8859-1?Q?o5y/znLkMXdnT4vr86vaWn3ruQ40BwcaT9DrZM/ekfHluwOtuigTqyEORu?=
 =?iso-8859-1?Q?imgfugkImoLUPukZ7sSBZRDBY5YR478KFnefWdfIVQMbC06dAtFQsBx8S9?=
 =?iso-8859-1?Q?RJ8gcb3vWq/U/ZsSeGxpM61Tatv/hbZUYSBCb7gz0ILTe5Lxm2vs7ApUF9?=
 =?iso-8859-1?Q?f7Mh6aPDAcB+xwU7Vip//L1K/4YPahyyki6nkfsE7r4qHrs2TlDq7MPVFB?=
 =?iso-8859-1?Q?9Ru96iCFt/BlIhJRRv8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F9C8AC4C28E57643B5A68BCF44BD0446@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c2f72b-e826-4d73-d726-08d99ad03e64
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 11:35:43.9717
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJR7mlitWlWNYXIr0Aq3Gg3XoSQY4Hypjb04EBHApYeYJiTbC68bFKGY10aPUy4nSSN8t1Hg8AW67HQFRNHDpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6015
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 08:09:37AM +0200, Cl=E9ment L=E9ger wrote:
> Le Thu, 28 Oct 2021 14:51:43 +0000,
> Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
>
> > On Thu, Oct 28, 2021 at 04:38:25PM +0200, Cl=E9ment L=E9ger wrote:
> > > Le Thu, 28 Oct 2021 14:22:55 +0000,
> > > Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
> > >
> > > > On Thu, Oct 28, 2021 at 04:15:22PM +0200, Cl=E9ment L=E9ger wrote:
> > > > > Le Thu, 28 Oct 2021 14:06:12 +0000,
> > > > > Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
> > > > >
> > > > > > On Thu, Oct 28, 2021 at 03:49:30PM +0200, Cl=E9ment L=E9ger
> > > > > > wrote:
> > > > > > > Add support to get mac from device-tree using
> > > > > > > of_get_mac_address.
> > > > > > >
> > > > > > > Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> > > > > > > ---
> > > > > > >  drivers/net/ethernet/mscc/ocelot_vsc7514.c | 5 ++++-
> > > > > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
> > > > > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c index
> > > > > > > d51f799e4e86..c39118e5b3ee 100644 ---
> > > > > > > a/drivers/net/ethernet/mscc/ocelot_vsc7514.c +++
> > > > > > > b/drivers/net/ethernet/mscc/ocelot_vsc7514.c @@ -526,7
> > > > > > > +526,10 @@ static int ocelot_chip_init(struct ocelot
> > > > > > > *ocelot, const struct ocelot_ops *ops)
> > > > > > > ocelot_pll5_init(ocelot);
> > > > > > > -	eth_random_addr(ocelot->base_mac);
> > > > > > > +	ret =3D of_get_mac_address(ocelot->dev->of_node,
> > > > > > > ocelot->base_mac);
> > > > > >
> > > > > > Why not per port? This is pretty strange, I think.
> > > > >
> > > > > Hi Vladimir,
> > > > >
> > > > > Currently, all ports share the same base mac address (5 first
> > > > > bytes). The final mac address per port is computed in
> > > > > ocelot_probe_port by adding the port number as the last byte of
> > > > > the mac_address provided.
> > > > >
> > > > > Cl=E9ment
> > > >
> > > > Yes, I know that, but that's not my point.
> > > > Every switch port should be pretty much compliant with
> > > > ethernet-controller.yaml, if it could inherit that it would be
> > > > even better. And since mac-address is an ethernet-controller.yaml
> > > > property, it is pretty much non-obvious at all that you put the
> > > > mac-address property directly under the switch, and manually add
> > > > 0, 1, 2, 3 etc to it. My request was to parse the mac-address
> > > > property of each port. Like this:
> > > >
> > > > base_mac =3D random;
> > > >
> > > > for_each_port() {
> > > > 	err =3D of_get_mac_address(port_dn, &port_mac);
> > > > 	if (err)
> > > > 		port_mac =3D base_mac + port;
> > > > }
> > >
> > > Ok indeed. So I will parse each port for a mac-address property. Do
> > > you also want a fallback to use the switch base mac if not
> > > specified in port or should I keep the use of a default random mac
> > > as the base address anyway ?
> >
> > Isn't the pseudocode I posted above explicit enough? Sorry...
> > Keep doing what the driver is doing right now, with an optional
> > mac-address override per port.
> > Why would we read the mac-address property of the switch? Which other
> > switch driver does that? Are there device trees in circulation where
> > this is being done?
>
> BTW, this is actually done on sparx5 switch driver.

Highly inconsistent, but true. I'm saying that because
Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml says
that "mac-address" should be under "switch", but then proceeds to put it
under "port@64" in the example.

Most likely not caught during review, I'm not sure if this could be
considered good practice.

> > > > > > > +	if (ret)
> > > > > > > +		eth_random_addr(ocelot->base_mac);
> > > > > > > +
> > > > > > >  	ocelot->base_mac[5] &=3D 0xf0;
> > > > > > >
> > > > > > >  	return 0;
> > > > > > > --
> > > > > > > 2.33.0
> > > > > >
> > > >
> >
>
>
>
> --
> Cl=E9ment L=E9ger,
> Embedded Linux and Kernel engineer at Bootlin
> https://bootlin.com/=
