Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77540424B85
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231135AbhJGBKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:10:17 -0400
Received: from mail-eopbgr140071.outbound.protection.outlook.com ([40.107.14.71]:50922
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230252AbhJGBKQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:10:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mn71PKOzu4UXxmMPRnlteZ4YWmNvsa7vWD0+opGesworYf9w8crsFZjUKNK+ppulb172frEAiOjpwTWJFV0qEfl3YethfM4umVJ/E4wKUW55lD9uAdUSMikulSNcvzSqov9V4Kh52tJtSBLmsAvT6KZadSpvNeXn6pKyGtj43rEztAnaD2Y2DHBCOWb7eQS7wKUvRHgfSqXLTPkgoEMgILbtv0lhNymLMYqqioZZtfNy/OaqR6NmCpRZmgAI4ABwqGFeawBPjUFXgSCdL5m7z9NqV6yuorFQzEMfm82LfcR0wooWXRP1TrcHPHfbsPV10iD1arF3YHk7pgp9cwFlJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iX8lmeqn+zLhARZPDs327RekDsPOUkd50ci44zJqRao=;
 b=OYMPwX/Jb0qXYti6kMmvp8UzI91cF+3w1hryilZKvr8VvTPJb0+GT6QtiFax/6aR2zSDoXvKiSuspNjQF5FrhKivvtqAenvAiumIZWACUONuCQz3YH3nE6nkpm67kBZuAmqtsOBfqh0efCCI5vbs3kUxKywE6fHdzfFvwbCYstlCMhN4J2FqPxvtD7nADPG7V3/+PA3f9a90BrBC9ZT1QwFBldsfi5jUz2G8FXHPlrxOujrjqAWrCmSDt5BH81g/8iAJbneaBme4J54kMV10I+5lC29Ghe7mme9j1T6icYbZSRe7MSvfLzN0MeCWV91M8qGVhp84884WxrJVI4pFow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iX8lmeqn+zLhARZPDs327RekDsPOUkd50ci44zJqRao=;
 b=eS389LGyVRWPkHQtIJIcuTIOOQaeEnNCh8jrjIdE/GJSiFzYSypTYNAT7yDUuG3x0LkUzqNL6c1fRwuF7AfKhyifJA24vTAYusicJFppT8xFhRYfThqxiYn6EJ+Rt5+lBP/hFXLzyro7BP+ElS7ym4Sg1/R8Y65ATUZkNR2yrW8=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5294.eurprd04.prod.outlook.com (2603:10a6:803:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Thu, 7 Oct
 2021 01:08:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4566.022; Thu, 7 Oct 2021
 01:08:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     =?Windows-1252?Q?Alvin_=8Aipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: DSA: some questions regarding TX forwarding offload
Thread-Topic: DSA: some questions regarding TX forwarding offload
Thread-Index: AQHXucaemV05T+14+0C6ajjHlibfJavEL5CAgAEWxwCAAXW+AA==
Date:   Thu, 7 Oct 2021 01:08:21 +0000
Message-ID: <20211007010820.kkj3yqnmdrh4nvo4@skbuf>
References: <04d700b6-a4f7-b108-e711-d400ef01cc2e@bang-olufsen.dk>
 <20211005101253.sqvsvk53k34atjwt@skbuf>
 <fdd15403-47b5-fcb5-6fec-870347a8480d@gmail.com>
In-Reply-To: <fdd15403-47b5-fcb5-6fec-870347a8480d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14b54eb9-d716-477d-0a40-08d9892ef491
x-ms-traffictypediagnostic: VI1PR04MB5294:
x-microsoft-antispam-prvs: <VI1PR04MB529446C8691795C3082CA64EE0B19@VI1PR04MB5294.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U3X9FpiLplsyVVLQy1D5IWEr+x/+hdMu5Xv3x06e9JG7Srhk1nSCPXc91uJoDIfqzSeKFzKjy0eBizlRg5xU9Ha0W5IN3aQVusxE89IK5kYMvOnmm9uYFPOVyJpElQiTsHjJEHICocuN+yiuRaqOxtgAGrufeOUYfD+Mcs2wOW/xoEop0jItYmg8FTz0Z+hdMLeBLRrK7ybGa2JR4IHvQhrbZIdErnNky4gsfp9E9sr8M8v5NazP35MwBm/h0RebJ/7f6BAyi17LDznIrdFR5sugac8b3bV5YyG6J5+dXkEOnhJ3AeF7ptpaInV0F7Qv0oYdrfIdUBq2wPynkgBwla+sZJBeCm3HXKbwi72Wgr6kB6asrkCtr+pWo3ls8dtZSnpd8MR6b8L51rUK8V+KTXdWajF7+x6bECXGWmL7gWNSWWHPcBS4fVLQMVAym9YmhgdRrKGiYrPEDjZPxAqnFhuNKj2PErKuw5qIULEG/tX24VbKXZfSn5bCG62I46P2DBN3vm10XdwUtdoC69aXXlnPIwY8MyCicGO/m7ultcyWccIorXjtN8qeFXo7pu5JHoEKe/URx3V7dFyG2gfPgzdV0GuFJPd9xdDLdH3khrVWpxrFoofmVxSMJ42FpYnFagaAsGoh9yUyoLi7Go0f9a/tYDl3KWpjpFMWCEh7/a9Fj1UtMIcojzvHczNRC34nkG4mkZxER3HAJJVz8qPRZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(66476007)(64756008)(66946007)(2906002)(66446008)(54906003)(66556008)(5660300002)(71200400001)(91956017)(76116006)(316002)(8936002)(83380400001)(38100700002)(53546011)(8676002)(6512007)(122000001)(6486002)(9686003)(33716001)(6506007)(6916009)(86362001)(44832011)(1076003)(4326008)(186003)(26005)(38070700005)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?hNDBqpODKr77X0qnAXRQriUO9xiBMgXDIsUTRYwbeREKlDgOl/uDStf4?=
 =?Windows-1252?Q?HAh0NLiuswQpEb2rLtw3Jm+5oaDpgvp0m5ZjZKj7Zzun0KNsQqrcd2xq?=
 =?Windows-1252?Q?5g2gIAQrYCHnfPsOwVYW90896Ho4LoiLIdHm/HlBWs+ecR9CdnoFnhaD?=
 =?Windows-1252?Q?E3jVU5HrEanO60BskmZn0v3LMgHeoT5dA7yPXFf0Ju5em1LcSK/P9cOa?=
 =?Windows-1252?Q?HMc7l+nkUe9uWJpRhfkaskSMHrAUBm6nAwQwORgvHzk7e+IqTOxEQ96d?=
 =?Windows-1252?Q?r7ks8KBRT4XHDyTBlEJbx0MqbdZx3PBMwIrJO1KsElzaQYZr/PHclyQW?=
 =?Windows-1252?Q?kCPAutzYW70YDLiti8GQLXMQQqQJzUOed+IRC8e4/esjr0OeVv84mt5k?=
 =?Windows-1252?Q?lVRlHCS8WeNtVg83SL+FmP3bDrvW6X8Ts16lF1490A5PO2K7vll3Ka2t?=
 =?Windows-1252?Q?iWLrbE97h4kRUSI4ZgJEsdm+X8JqAZUY7+76YHL9XZij2FWX/ZoSjF6Q?=
 =?Windows-1252?Q?xTZJC2GAc6jMQHxJdYTRWYBhmTXMhl9a2/epijAbrUU3r6A7h2hNrlyp?=
 =?Windows-1252?Q?tXOt/sOi6/GGKj2u2AIhI5AtrLPtEzzq5SumNpgiYff0cmlR9lq/6rDw?=
 =?Windows-1252?Q?AJNhv+co8+9vHWAxx3azeaCXc24Ce/Z4x+ERGsXOO5cHG5Nf6CVnNOcd?=
 =?Windows-1252?Q?VnRvZbW/pOn+X1CBnK56rySJHoYPof9HtHPvNKAyghhAhgJbhP+ja1u8?=
 =?Windows-1252?Q?CsMDLq1HBZXCivNISIT6hJi0f7ikrm6ChInUseW+c932P9dsO/RSlQPw?=
 =?Windows-1252?Q?xV0rtD7WErPYZuqq1AwVC0y4/bblJUo1Uw2BxYdeqOyonFKQjCR1yf18?=
 =?Windows-1252?Q?BbgaC2mJ5UM+xAlq/acIgZqv/pfa9smK66LUSXMbDnJkt2LveuIeCpS0?=
 =?Windows-1252?Q?Q5zX6qs01Ty4R2jHY8bMhwPIgbIGW4v8nY6MVk0KDabFrKKRH99IBM1g?=
 =?Windows-1252?Q?67ZnSBAqngsXmWr32c8ckQaSKc2jgZ0Q7lIV0ad8VFgKjWQhOu+7wtUG?=
 =?Windows-1252?Q?nx9MulZiTnND8iOIt7vARJvmsHFXYGf2mXZJdgCqycL3+94Ji6eub0qg?=
 =?Windows-1252?Q?qzNgZnbS89XtZZECZFlDyxhf0N7y94Jhi/eMFPX98NslOpAtDaLDs7Bz?=
 =?Windows-1252?Q?2PX1c9yQ3eJ2/8FHaqoFQt1M/95ckzdSS1nTo8rYFIsVgOGsBAL5K2xj?=
 =?Windows-1252?Q?xe+64blEt+5UkOA5m58E4RdU3T9Yw2zVe0miieRnd66OG4vpqYNSLHIP?=
 =?Windows-1252?Q?A+cbnEyqgLkxeAFJJ2G4ZkSGfEpWLGonS0BkxWJa5RT1TN53P/QGGEDc?=
 =?Windows-1252?Q?yEYCFDvvc82RSJ/mPzZ+jmgMu4y224dorMyaFSgtxVHrBgfH+CRC4EfV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <2106254E7EB32042BA3368CA459491CB@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b54eb9-d716-477d-0a40-08d9892ef491
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2021 01:08:21.2933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mQLyHt4YJvS7/Rw/yAZUrI1XK4Wt96+e3jwB12gdgCS2ZCplk/LlOoyh5iWMdDO7eYyX9GRz/NuIfUVuEvmoJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 07:50:40PM -0700, Florian Fainelli wrote:
> On 10/5/2021 3:12 AM, Vladimir Oltean wrote:
> > I don't want to answer any of these questions until I understand how
> > does your hardware intend the FID and FID_EN bits from the DSA header t=
o
> > be used. The FID only has 2 bits, so it is clear to me that it doesn't
> > have the same understanding of the term as mv88e6xxx, if the Realtek
> > switch has up to 4 FIDs while Marvell up to 4K.
> >=20
> > You should ask yourself not only how to prevent leakage, but also the
> > flip side, how should I pass the packet to the switch in such a way tha=
t
> > it will learn its MAC SA in the right FID, assuming that you go with FD=
B
> > isolation first and figure that out. Once that question is answered, yo=
u
> > can in premise specify an allowance port mask which is larger than
> > needed (the entire mask of user ports) and the switch should only
> > forward it towards the ports belonging to the same FID, which are
> > roughly equivalent with the ports under a specific bridge. You can
> > create a mapping between a FID and dp->bridge_num. Makes sense or am I
> > completely off?
>=20
> Sorry for sort of hijacking this discussion.
>=20
> Broadcom switches do not have FIDs however using Alvin's topology, and gi=
ven
> the existing bridge support in b53, it also does not look like there is
> leaking from one bridge to other because of the port matrix configuration
> which is enforced in addition to the VLAN membership.

I don't think we're using the word "leaking" in quite the same way.
TX forwarding offload implies calling brcm_tag_xmit_ll(). How would the
port matrix configuration and VLAN membership help you? The CPU port
(ingress for this packet) should be in the forwarding matrix of all
other ports, and in all VLAN IDs. If you blindly put a port mask for
this packet that targets all user ports, it should reach all user ports
no questions asked, regardless of the bridge they're under.

Alvin's case was discussing the idea of allowing all user ports to be
candidates for destinations of this packet. Hoping that the FDB lookup
would come in and further restrict those candidates to only the ones
belonging to, say, br0. Leaking is possible if you don't have FDB
isolation between br0 and br1, because to the hardware, it's all a
single VLAN, just with a stick between one user port and the other
pretending to be a fence.

> However based on what I see in tag_dsa.c for the transmit case with
> skb->offload_fwd_mark, I would have to dig into the bridge's members
> in order to construct a bitmask of ports to provide to tag_brcm.c, so
> that does not really get me anywhere, does it?

And even then it wouldn't be correct. Not just the flooded packets come
with skb->offload_fwd_mark =3D true, all packets coming from the bridge
do, even the unicast ones. So the destination port mask needs to be a
subset of the ports under dp->bridge_dev.

But forget about using the destination port mask as a bitmap with more
than one bit set, and figuring out for each packet how to set it. This
mechanism wasn't created for that use case, that would require so much
rework in the network stack that it isn't even funny.

Simple question: what do Broadcom switches do if you throw a packet at
them which has no DSA tag? Forward it as usual, like sja1105, or flat
out drop, like Marvell?

> Those switches also always do double VLAN tag (802.1ad) normalization wit=
hin
> their data path whenever VLAN is globally enabled within the switch,

I don't know what is double VLAN tag normalization, sorry. Is it
something like "if an outer tag TPID is present, classify the packet to
the outer VID, else if an inner tag TPID is present, classify to the
inner VID, else to the port-based default"? I'm not sure that is helpful
either in general or in this particular case.

> so in premise you could achieve the same isolation by reserving one of
> the outer VLAN tags per bridge, enabling IVL and hope that the FDB is
> looked

Hope? Well, is it or is it not? It's a bit of a pointless exercise if it is=
n't.

> including the outer and inner VLAN tags and not just the inner VLAN
> tag.

So I expect that if you encapsulate packets from the host in an outer
VLAN tag, the FDB will be looked up in that outer VLAN. That is exactly
what is needed in the case of VLAN-unaware bridging with proper FDB
isolation. The outer VLAN should have a value equal to the private pvid
configured on the ingress of the user ports that are under the
VLAN-unaware bridge, and all should in fact be well.
But in the case of VLAN-aware bridging, you want the switch to look up
the FDB in the same VLAN ID that the user port would classify it in,
were it to receive that same packet on ingress. So encapsulating it
wouldn't do it any good.

> If we don't have a FID concept, and not all switches do, how we can still
> support tx forwarding offload here?

Yes, sja1105 does not have a FID concept indeed. And it barely even has
a DSA tag.

If you don't have the concept of a FID, one thing I can tell you from
the get-go is that multiple VLAN-aware bridges will be broken, because
they don't have proper isolation at the level of FDB lookups among them.
So you should simply deny that configuration and operate with a single
VLAN-aware bridge, or multiple VLAN-unaware ones.

To isolate VLAN-unaware bridges between each other you can just crop
some VLANs from the 4K VID space (as many as the number of bridges you
want to support) and use them as private pvid on all ports, as well as
the encapsulating outer VLAN ID on xmit.

But anyway, here's something I don't understand: is there any field in
the Broadcom xmit DSA tag where you tell the switch in which VLAN should
the packet be processed? If there isn't, and the only mechanism by which
the switch classifies a packet to a VLAN on the IMP port is simply by
looking at the 802.1Q header; and yet it only looks at the 802.1Q header
if VLAN awareness is turned on, then bad luck, because VLAN awareness is
a global setting. So you turn it on for the IMP port =3D> you turn it on
for all user ports as well =3D> bye bye FDB isolation between VLAN-unaware
bridges, because bye-bye VLAN-unaware bridges.

So I just hope there is a way to inject a packet into a given VLAN
through your IMP port that does not involve turning VLAN awareness on
globally. If that is not the case, well, I don't know. Can we have a
more complete picture of the Broadcom tag other than what tag_brcm.c
sets today?=
