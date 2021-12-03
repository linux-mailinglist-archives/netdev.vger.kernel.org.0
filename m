Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BEA546763C
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 12:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380413AbhLCL1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 06:27:19 -0500
Received: from mail-db8eur05on2058.outbound.protection.outlook.com ([40.107.20.58]:43712
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1380408AbhLCL1R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 06:27:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hFb7IYnSKazoSWR6GyjS2nzTTspkngVQo12nc/UtW9rWWhFiT3/LWn7UXefJohX7Kw8CtrRXbhCeaZzOxIQKOj0OL0ejm99SMqh+8/KMCrU+/Z/G66ERRJuyg1gL73w2M3+U/9l1o0T9aqGDX+bLPsO07Fg8SuoQkRnNuUyO5PPGW+r/nG+5O0h6OMQbcL/PHc2RvzHE7cIWerMK3mhf86JGM9JJaxq/VS+vaMr2hNZuLftdTbXqj0m6v/bcW83q7Y8LBh57caEd672VuVy7zZFboIIh7CQ4+OjVbi05XHKLD3voAvo/IaGorLhz908feLttvwNPgv1iEVqkvfFj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IVOqssj1qCGoawqOLtGXCqbsdRd6p/bWYw8eo04Gau4=;
 b=Cok6Ke47d88u7hDST0mqKDNgeWaPy5n4c6xR59Zx2JwPVutQFcLLtC+HLAOHB3Vc2lqmert9DXVNMQp/LQ8TQkj69jdRFrFvv09JKlvEfDXqexx4N8bJhBQzvcXmovJokCrlvBEFN4dSZ/B9IdPMXzxTpICvGtK6R1ds9dUB3qPK9b7sCh00v/D1f17ZC5ipsurzVCA9FJbOGu1oVaPMfro3kj2AAG5DiC/6k9YYlrsu9mTx8PMhEioAUpA+QwIMsnYhN3Azqjl4hs82nTmyzqqYTrV24rmSWpG8Oz4TsjEh823wPrAfA15u0fxhuUChxY10vgtIzEV4sxwsKP15Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IVOqssj1qCGoawqOLtGXCqbsdRd6p/bWYw8eo04Gau4=;
 b=r3oLqLj5apeYItEbuvR5ZlIdQJjsjgdAxfrwy7O8VsAH0XAgFhDa4FKKFrd31P5F9zbSE8rDfS6pxXvYc8659nTz3dQRfCN1vxnY3Lg7lIXYhxwTHW8Gl7zCtXwTGsOoaaODZgrzx0cs/PERbnTFQJSrWDrH7tdoDUUUYuLq46M=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3837.eurprd04.prod.outlook.com (2603:10a6:803:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Fri, 3 Dec
 2021 11:23:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::796e:38c:5706:b802%3]) with mapi id 15.20.4755.016; Fri, 3 Dec 2021
 11:23:44 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Denis Kirjanov <dkirjanov@suse.de>,
        Julian Wiedmann <jwi@linux.ibm.com>
Subject: Re: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Thread-Topic: [PATCH net-next v3 4/4] net: ocelot: add FDMA support
Thread-Index: AQHX4ur0oKFzimZda0eyFp+wSrHWQKwXeIeAgAK1KwCAAJzpAIACm2wAgANEmIA=
Date:   Fri, 3 Dec 2021 11:23:44 +0000
Message-ID: <20211203112343.m6bhc723szcgcupm@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-5-clement.leger@bootlin.com>
 <20211127145805.75qh2vim7c5m5hjd@skbuf> <20211129091902.0112eb17@fixe.home>
 <20211129174038.gptbivgmbqzrrgtz@skbuf> <20211201102926.3eacd95e@fixe.home>
In-Reply-To: <20211201102926.3eacd95e@fixe.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e838a567-0195-4910-7596-08d9b64f5e27
x-ms-traffictypediagnostic: VI1PR0402MB3837:
x-microsoft-antispam-prvs: <VI1PR0402MB383793A49F26CCB545FE437BE06A9@VI1PR0402MB3837.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t66U6srxbmQPTuPhWTyY9nzDDjs730AuVqGTtmir/7DstnduFeqPaa0kn+C4U2Slxpcqa2nhD2ucpBQ2ovHvpqtKS023UlEgwDhtFNR3FWGr1lxu/pfifN4uboBDPEOG+vxQvUcb20XvmzjdqWvAv0K+bnJ7wq2AqOaSfgBQ4QK8st63sPd6GfPnQ1YgREyL8m7ONEyPzNgCB+E5WedXaEGctamRf/wUHoPyt5+yYTOu3WW5g0ryXFw8OD7HiS467tdD/MV2CZTQ/jiG9W7Zo1aLaG5qCObywi1HdPjUFchK57GDtHGiDLBoMbXx+UPLMYD0bsfXizSECIPTVrj34Ar9ThyqZ266SGZyY70w6dPrZ0G43DY0Fy1HnMDMvp8/DBCpphxemBUIPaAs7goQbWNCQKHg+KmslDQ/K/lPsmzUsSDsCRxG7jLz9KmggV5jrHGKLWE9EefiPLuzbg11gYIdrJ+MdPXwUrlBixvsH2+JoeFWzDp1J9aVDzO/a6b9O/jfz5ducHbLnRL0dA2DCSO7p8uEmzfMsBuIRultuYuUdNKMQsYieu6OW9b7l+o58Ofpe6A67LxZUx2T1JwowLXPwvEHU18JYBA810DW0tscpm4KEeYyKwDgy6hJ0uCOr4dWtQGdZnRzx1rU4ugl3/6QKPRyM4Pq0MEEf2Ax8yXNxGKSD0SmokYciGGG62gOGDn7T270w+u/mNRSrRu35Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(366004)(44832011)(8676002)(83380400001)(91956017)(66476007)(64756008)(9686003)(6512007)(508600001)(5660300002)(186003)(86362001)(66446008)(38070700005)(66946007)(66556008)(4326008)(71200400001)(7416002)(6506007)(38100700002)(8936002)(66574015)(6486002)(1076003)(122000001)(2906002)(6916009)(33716001)(54906003)(76116006)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?1U824sYU6IDbY/jbz2k2Y2KBG0uPwCmhn5O5jQbUPr+23SR/mwwq1PyRCq?=
 =?iso-8859-1?Q?I/nf3piipix+kq+uIesAZgAhjz6Ht2YWdTnBtDJXVnCf4xqHYB+OX2Aawb?=
 =?iso-8859-1?Q?LoiSt/A0T+Qu3cr//FF7+y2/Pc1Xylf3NvtlPz5dn8gCwaTHFvgWvN/2xz?=
 =?iso-8859-1?Q?swDdTxEGepGCLLhoheA/tyZfI88LvlCCGYPzNHsyb+0mEhpz7D0rohUgxP?=
 =?iso-8859-1?Q?7yY5O2l/kiqltpp/TpyvTfJSkcRIV7wPtrFu6rpKlYq94WjiH6izPKcG4j?=
 =?iso-8859-1?Q?m7bKNmFytQCH1XFN/xeMtsH7EYf7ZreWqwoPkbH6k5YLnB2ecsEa2QSAvN?=
 =?iso-8859-1?Q?Pgs0fYGYvo4HSpy/mxvGVzIuAwiuDUvTxKwDBrm7LKGzWOfL1X7d0UvEXH?=
 =?iso-8859-1?Q?UZuZD9wu5sB0h8CKTaZril2VVS81Wg1gvSx+C0JMhJht1vO6PU8sIksBAZ?=
 =?iso-8859-1?Q?xa3bodvVTp6B2iHbQXaYcVhspprPcbnktb3P1rFWpvmfmEYkoQuX0XNu+s?=
 =?iso-8859-1?Q?PcwZW7f6lYyZPJWFQr7pt1hZ9pp4WtoXQGzDyoBlz6bE4X0mWpdw6sQjyV?=
 =?iso-8859-1?Q?Qmk5rh19qEtOf5OpSYJzI5ipw+7uGTrdDGtYQUANmACz047MSOiJ2FRSGa?=
 =?iso-8859-1?Q?KUEA5I9wSKLx/GlUeyK9Oz3kAyLrLDNwFqbSD6cMeN2RzlbrfarwJg+tJl?=
 =?iso-8859-1?Q?y4NkzZV68CFA9q9s8ntcrYO/PbO5yHewTffSmqzU5ATfP7NFjClGYhCNDw?=
 =?iso-8859-1?Q?/1pfZd2lgVNnccK8Y+2aMd8ZzPiKl3xk6bMpC2fIQ55S9l63P3EdffAg6j?=
 =?iso-8859-1?Q?69GhqPzjELGay61NKNwCvYgMiZQXFL3D7DtaABbC+kfSHq+wXCmCtumfpN?=
 =?iso-8859-1?Q?r1U/OQW+ue0hJ4n6kvehflOtntN8gssNeeYpMCgFYufwmQSbxt50CM2SFz?=
 =?iso-8859-1?Q?vsCfxp/aschliv8A7W4jEYh/TttoXTNAMRw0DanScgeEJRsMR/L5Y1oEuD?=
 =?iso-8859-1?Q?K0JFImChyRnBmD8UmXRivyQpAjOQ5+lFwCdRjSO1o7dcdLGZ0fDbRSuYXt?=
 =?iso-8859-1?Q?QgMWjrQWFJvmgJ2LUZ80fJubICvKmTfxcwxnvKm5pZe+2rj/p1VcCB9e9m?=
 =?iso-8859-1?Q?Ov9esGxqCFMyr+FpjUMfZdzOicZ5DkH30RUsu0Jd0L6DOHjHS19BCMgaPj?=
 =?iso-8859-1?Q?j2fytln2/3uVCZMCROEVcFC04NlKcyRUGF+0cCsik1HDQzxhBiWdA6ybrR?=
 =?iso-8859-1?Q?cYW4Tb8TU4S63fZl0JP8Oc4DtdWJO5C8GzGUj3v7NuHYhfxYEP1jd9AYbQ?=
 =?iso-8859-1?Q?GXk3iTRPg10EGAEwnqrHVtG05sYyBABHzZNhr5TV+UJoaK1cF1nZFnn8Yk?=
 =?iso-8859-1?Q?4SXYx7NvGxyM2QQnh4dK6ZBy5Amh1FK3Pb2awKd8/K3oVAXa9qYSH2g+vK?=
 =?iso-8859-1?Q?83NKPXg+HpDHgp/m1Wassbi1Ni5TDkmmeCj+tHIOtKOvriFDH1l72awV5M?=
 =?iso-8859-1?Q?RY+WIfruV+tAbAGVJik6lltE1TFg9wFR4h98WGvTuVofClfZ360RDZQFbS?=
 =?iso-8859-1?Q?gs11+GY1OCEYUcMCQK0AOFpFX5MqMzlJXCqPCTaBu8zvVAy4rI/U+C0W9m?=
 =?iso-8859-1?Q?OyBIE1OAKiqsVLjs8xEaF/ocW5yyM3oP2ZwPbuMaGWuZikKznGyt0DCRPH?=
 =?iso-8859-1?Q?6soDNY1+TC7kpairyn4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <EF1717BEA2E474499DD193695182EB44@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e838a567-0195-4910-7596-08d9b64f5e27
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 11:23:44.7326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dkATGaFn3QGLNADdgpBHxnj/xhIkzguavSzFwv5FPt0Q9QY9IOsERvqR0JKo11EDJpToZp6ahiVKo4izeqruRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3837
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 01, 2021 at 10:29:26AM +0100, Cl=E9ment L=E9ger wrote:
> Le Mon, 29 Nov 2021 17:40:39 +0000,
> Vladimir Oltean <vladimir.oltean@nxp.com> a =E9crit :
>
> > On Mon, Nov 29, 2021 at 09:19:02AM +0100, Cl=E9ment L=E9ger wrote:
> > > > I'm not sure why you're letting the hardware grind to a halt first,
> > > > before refilling? I think since the CPU is the bottleneck anyway, y=
ou
> > > > can stop the extraction channel at any time you want to refill.
> > > > A constant stream of less data might be better than a bursty one.
> > > > Or maybe I'm misunderstanding some of the details of the hardware.
> > >
> > > Indeed, I can stop the extraction channel but that does not seems a
> > > good idea to stop the channel in a steady state. At least that's what=
 I
> > > thought since it will make the receive "window" non predictable. Not
> > > sure how well it will play with various protocol but I will try
> > > implementing the refill we talked previously (ie when there an
> > > available threshold is reached).
> > (...)
> > > > I don't understand why you restart the injection channel from the T=
X
> > > > confirmation interrupt. It raised the interrupt to tell you that it=
 hit
> > > > a NULL LLP because there's nothing left to send. If you restart it =
now and
> > > > no other transmission has happened in the meantime, won't it stop a=
gain?
> > >
> > > Actually, it is only restarted if there is some pending packets to
> > > send. With this hardware, packets can't be added while the FDMA is
> > > running and it must be stopped everytime we want to add a packet to t=
he
> > > list. To avoid that, in the TX path, if the FDMA is stopped, we set t=
he
> > > llp of the packet to NULL and start the chan. However, if the FDMA TX
> > > channel is running, we don't stop it, we simply add the next packets =
to
> > > the ring. However, the FDMA will stop on the previous NULL LLP. So wh=
en
> > > we hit a LLP, we might not be at the end of the list. This is why the
> > > next check verifies if we hit a NULL LLP and if there is still some
> > > packet to send.
> >
> > Oh, is that so? That would be pretty odd if the hardware is so dumb tha=
t
> > it doesn't detect changes made to an LLP on the go.
> >
> > The manual has this to say, and I'm not sure how to interpret it:
> >
> > | It is possible to update an active channels LLP pointer and pointers =
in
> > | the DCB chains. Before changing pointers software must schedule the
> > | channel for disabling (by writing FDMA_CH_DISABLE.CH_DISABLE[ch]) and
> > | then wait for the channel to set FDMA_CH_SAFE.CH_SAFE[ch]. When the
> > | pointer update is complete, soft must re-activate the channel by sett=
ing
> > | FDMA_CH_ACTIVATE.CH_ACTIVATE[ch]. Setting activate will cancel the
> > | deactivate-request, or if the channel has disabled itself in the
> > | meantime, it will re activate the channel.
> >
> > So it is possible to update an active channel's LLP pointer, but not
> > while it's active? Thank you very much!
>
> In the manual, this is also stated that:
>
> | The FDMA does not reload the current DCB when re- activated,
> | so if the LLP-field of the current DCB is modified, then software must
> | also modify FDMA_DCB_LLP[ch].
>
> The FDMA present on the next generation (sparx5) is *almost* the same
> but a new RELOAD register has been added and allows adding a DCB at the
> end of the linked list without stopping the FDMA, and then simply hit
> the RELOAD register to restart it if needed. Unfortunately, this is not
> the case for the ocelot one.
>
> >
> > If true, this will severely limit the termination performance one is
> > able to obtain with this switch, even with a faster CPU and PCIe.

Sadly I don't have the time or hardware to dig deeper into this, so I'll
have to trust you, even if it sounds like a severe limitation.

> > > > > +void ocelot_fdma_netdev_init(struct ocelot_fdma *fdma, struct ne=
t_device *dev)
> > > > > +{
> > > > > +	dev->needed_headroom =3D OCELOT_TAG_LEN;
> > > > > +	dev->needed_tailroom =3D ETH_FCS_LEN;
> > > >
> > > > The needed_headroom is in no way specific to FDMA, right? Why aren'=
t you
> > > > doing it for manual register-based injection too? (in a separate pa=
tch ofc)
> > >
> > > Actually, If I switch to page based ring, This won't be useful anymor=
e
> > > because the header will be written directly in the page and not anymo=
re
> > > directly in the skb header.
> >
> > I don't understand this comment. You set up the needed headroom and
> > tailroom netdev variables to avoid reallocation on TX, not for RX.
> > And you use half page buffers for RX, not for TX.
>
> Ok, so indeed, I don't think it is needed for the register-based
> injection since the IFH is computed on the stack and pushed word by
> word into the fifo separately from the skb data. In the case of the
> FDMA, it is read from the start of the DCB DATAL adress so this is why
> this is needed. I could also put the IFH in a separate DCB and then
> split the data in a next DCB using SOF/EOF flags but I'm not sure it
> will be beneficial from a performance point of view. I could try that
> since the CPU is slow, it might be better in some case to let the FDMA
> handle this instead of usign the CPU to increase the SKB size and
> linearize it.
>
> >
> > > > I can't help but think how painful it is that with a CPU as slow as
> > > > yours, insult over injury, you also need to check for each packet
> > > > whether the device tree had defined the "fdma" region or not, becau=
se
> > > > you practically keep two traffic I/O implementations due to that so=
le
> > > > reason. I think for the ocelot switchdev driver, which is strictly =
for
> > > > MIPS CPUs embedded within the device, it should be fine to introduc=
e a
> > > > static key here (search for static_branch_likely in the kernel).
> > >
> > > I thinked about it *but* did not wanted to add a key since it would b=
e
> > > global. However, we could consider that there is always only one
> > > instance of the driver and indeed a static key is an option.
> > > Unfortunately, I'm not sure this will yield any noticeable performanc=
e
> > > improvement.
> >
> > What is the concern with a static key in this driver, exactly?
>
> Only that the static key will be global but this driver does not have
> anything global. If you have no concern about that, I'm ok to add one.

I don't see a downside to this, do you? Even if we get support for a
PCIe ocelot driver later on, we don't know how that is going to look, if
it's going to reuse the exact same xmit function, etc.=
