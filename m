Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D34C61FB5C
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232815AbiKGR24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbiKGR2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:28:53 -0500
Received: from EUR03-VI1-obe.outbound.protection.outlook.com (mail-vi1eur03on2072.outbound.protection.outlook.com [40.107.103.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2027720BE1;
        Mon,  7 Nov 2022 09:28:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ov+aK6TbNa4g0Iqvx6Dvk+gv/RznmUFNOzupJs5Mc0o0n1RPoRqWaKWEuWPV2QQhy8e9nz1DDxzx6R1GlBeCXyXeOuHh69gfhBqYrYaB16x3bK1kZPgtoLlZvWEzk/sjX7Md8Q5hCDnvKcsLKovhUZv7r81dQwbDKBh6MDCCwXCer50sFsV0wOJUBfFVI68xL4k0uYStOSMojcvDk7eb3AWdqOutqnPdFlMtcFKAf1MKPs+sdOZ0IDWGeyIPNyeS8iuW7eene81QXKVr5K4Ncd/D9Y8GF0RGvFa2+Lo1RyAuY+Z0kxt7iaPkpS9M4fxcdIZTserW/psZNXUyCUnvvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdapoQITEGgzGZ0OINc/UgCMmmitXIWLxy4BWQXkYBU=;
 b=a/oJZPy2mnW8YXHRkIUIL0rNwXe4h/USe2AL/hILv2jNgRzdTn1S1MEF5GIOlCi1EsCucs7zJ1aeVJMAdFCWgczhQF7lx/RN5P6/qLp0Ojdk71BGPhB8b9QcJ4ZYOejLJ48hopp3qnl/RiDyjqFH08mju6JILy2kVNnQnIRWXwOeGoxDQM9zMKSy0TUBzo+5FZpVlk6gtOCi+RBueNR8GmXlVNDpYeWuNOqB8FK04QQGSYZJshLbjyZwqsww9Odu2rJf7jRHTBynJ8wlCj8hAX6Q5HmEesnx1sUp9eECCJWv1OjzOmXHN4p9rgKFkHpRZx+yQ4w4hC7cJclmMObzCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdapoQITEGgzGZ0OINc/UgCMmmitXIWLxy4BWQXkYBU=;
 b=NQH0ul4D0FGR0xQvHkucLGXcygeA0zb8GWFGcnqk/VTubGmvDwWyNYMWARNw+MsufYGmbn2spi/3s/AxSPDhIU3aShZvK1c9gAgXThscZK2NBHZfJdqh2kaxY9TlEeL3l4maE8nis/QN0/9Ma11Jg1WvzIxWypd69b640RA7Jt4=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9277.eurprd04.prod.outlook.com (2603:10a6:102:2b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 17:28:47 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::4a73:29eb:28e3:f66d%7]) with mapi id 15.20.5791.024; Mon, 7 Nov 2022
 17:28:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
Subject: Re: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v8 3/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHY8HTAfetHoGxM5E6HcRPQNrr8s64vpgIAgAOw8wCAAFjYgIAADBEA
Date:   Mon, 7 Nov 2022 17:28:46 +0000
Message-ID: <20221107172846.y5nmi3plzd4wemmv@skbuf>
References: <20221104174151.439008-1-maxime.chevallier@bootlin.com>
 <20221104174151.439008-4-maxime.chevallier@bootlin.com>
 <20221104200530.3bbe18c6@kernel.org> <20221107112736.mbdfflh6z37sijwg@skbuf>
 <20221107084535.61317862@kernel.org>
In-Reply-To: <20221107084535.61317862@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR04MB5136:EE_|PAXPR04MB9277:EE_
x-ms-office365-filtering-correlation-id: 1d62d219-2105-45c9-5c93-08dac0e586e1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BBWMG/hWLO5z/86qR7vap+iuJu+pWkMb5ePoZx8AJNTxSuNX6HymBnxGR2mJVO8aRc26C1weJjmTz0L1pClNzhg8xNQEGrdEdzEr/VJdgT/27UdaeW1CA5ms+NWqO+UIVD4mYlWqNcYxv+460eYzIzTscZVwUJGQT+4MLsJvqIDo2BXeUxH0W533pL4VyGeu0z7cIUOdkEoIcseKnk7Et4qX+3AVs9TLMrRSSXFRasqn3dpb25jSirRgY3onDeJtSQ6lXmRw17p7Vo69DASiN0XA+BvsbmTBTkTfaihMxN2q5fq7ygCUSng6X05gE+TFD+ZNfQ/nkSj0rnBQmsDhxmH+2F7HZ0Ipcn+BRG1cb3TA0PPOkG8xfIyISuFFIviGTQ4ktN8ZSPfDnkssu6hiSXJZ+fU1fRJGRjbSx7DybnLWfKI8TegLsRrx+Qwp1G8J9M3dFooIZYd9mKh7EYvIzmm9hF23qfoSqPFO0o1xvk3iDqsFQJogKBNMUBY9uvXqeYqBjbezvy97C7WKEp3n/mwMDHPTVoSJPPzT0fijj9uyE6p6oBP/xUPKVWcbVzEvk7BhtxerUX4EcIv3/AMRkJX6wAYOPEI4ARkc+RRhBOv9Csv9AH4mmid9giA/P3Z6gpEy3iv8vCNu+UK8BpgUnO3PC4LGnKqPI/E+OcFmuxTU2JrjErYI1BNNAaKbTY3oA4RkvrtZ20O5hZY+G4DKBbjkd/VoEiY+LCe+EvxtB8nKmYI2q+B2jd4z1lXQqQSwUyZ/uS0p/mHy4JpRaFTvcbtaeSPh3tvNHrWCrsXZbGuHRKUMhp7mmhzPOkrFJjrHUFW8No2Ti2l6q6soLPeyhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(451199015)(8936002)(5660300002)(7416002)(66899015)(122000001)(38100700002)(44832011)(41300700001)(83380400001)(91956017)(6506007)(66476007)(2906002)(66446008)(33716001)(76116006)(8676002)(64756008)(66556008)(4326008)(66946007)(71200400001)(9686003)(6916009)(26005)(316002)(6512007)(54906003)(86362001)(6486002)(966005)(478600001)(1076003)(186003)(38070700005)(10944003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M+lvH5ATQYndjT5pJ+nUwm2+Z3nQaDVtOmIhnrKR8ad2MaqrwuPGH+MHLNzc?=
 =?us-ascii?Q?CDXRFCoNS7p1KFq6zop/JGzuYaNzxKXsZ8lajbvsfc4K6NkaOKI/Ikh3yse4?=
 =?us-ascii?Q?H394Y6hjszVO/Gzm2Jck8qaBDQq7R7O02Lg+FVnyT7bC3mv7/OJi8mt1wpr6?=
 =?us-ascii?Q?vGiHw8E1N683Fokj4boCNjvi6FLx7pend1ZfQtw3Hv53oz89hamCqyaTELQT?=
 =?us-ascii?Q?QrBtrjfL8A0KEIkU7JwG8NPQMq6uc4XewGIa9ey9DnmguL2arj0JYZBgBGF6?=
 =?us-ascii?Q?h+n7cbPI/l5lSQQbvp6SekaiB2cePES9AD3sVj2Fo9k3lAHPrTKMLfi2ELpl?=
 =?us-ascii?Q?/nYJ8it944oO4pH4eR+2YbvsC2x6gCnJoTU/Bo1xPxu1Z9zDNLZ5rtFKLzHm?=
 =?us-ascii?Q?weytl84RHl4mM/794KF5SyvRiUTLRnEjYVyzfP5nSVEBTot6CgHJI9SxA79F?=
 =?us-ascii?Q?HjD4lewEEOeJuk38G/hXpISTRFSc+fe/emRi5vvlpN1h3kh9C7kpGpo2s2Bx?=
 =?us-ascii?Q?Aa8oG+dFxVCtkyq8bT0AtMsqlVh6OYDHhXW8QaXQNlCbhRhNLgbTwoxi59PK?=
 =?us-ascii?Q?YfNMd20yOKEmMFAEhLFzoDvzELxWLhMmjgKBmxuGHU+CNZoQDhRYaYT/YGHS?=
 =?us-ascii?Q?UGdQdxLEFp33zNuz4x8n9tYg5vwcjQDfpmGVOII/8ig6XC5F6X4Z8l4vODrl?=
 =?us-ascii?Q?JN+HPwes78TlfyVuprAsE8ZVAqJSNUnnQdAq6hbyldeCvxSTNM1OqcndE2Db?=
 =?us-ascii?Q?c0cXbv0PVoCCkT7ite6TeQCHGDBsBIR5ilYg01MsENFIA2K3yXjoWnm7dEQ+?=
 =?us-ascii?Q?390dpuekpL6rjc/iVygGlgCdTXZmg+WSoEnGHLcpnrNK269leLjLlJaqSaoi?=
 =?us-ascii?Q?Htl68XdRpeQHuyWBNKH4flbAKy9SnhrDdUjNRx5dGPzUc82xsUT2FNVB6s9S?=
 =?us-ascii?Q?C+ahXTmSAEIyt5yQPvhwgjsJWdtkLsepOHaETMfeB/pKHehWxvXCMoxReARg?=
 =?us-ascii?Q?Fak1cQfRREgD8NYZxU9Vf94kdRc6HGy+OeE3cHcYAeg5bEWmuyNxAX8F3J2T?=
 =?us-ascii?Q?E1tPuTrE/Ds33pkTHWJBqMzKriD6ejRSu8IvEeBAW97ZUJbJi05NFZHIRXJ0?=
 =?us-ascii?Q?aYWn2bKdTFibYp8LK/6QR/0xJVzxTMEEx2NPdO12tnk5kSDYrUfjD2JDRdmF?=
 =?us-ascii?Q?QJInvErBw1EDrZZA231vpIj9guE8d0/zqwZRfUn3tyXIZtM+V/OQhxWsdm+o?=
 =?us-ascii?Q?S1NaIuZTZDwxcIwjMKZ8KvxQxGXD9qB9hQ/UGelR0J2Au/KtFtY5QbJek6YH?=
 =?us-ascii?Q?a9bl3Nmyah6TSZbgjeCWKxNmOH+pBQ0HVSB5sSzdanSX1WNDTb5FvCakmH3B?=
 =?us-ascii?Q?RYekJphgFybqWwZon1XnK2M2f5BqtLiBf/j3fPWWL8JaUhU6nhizaWioas6m?=
 =?us-ascii?Q?wVmr2KH9ObEVMrVZulLkDDOjfgIAq4yv24EvPaG39Bfkn1xXWLPYm549gNoJ?=
 =?us-ascii?Q?Vw+x1sQGkfowyJxjf96yMS67Uz1zpHDNoW5JwyS4TjTBYvXvPWqInmIW7sK7?=
 =?us-ascii?Q?8SCD7laOiRlOAuF/jG8WVSIdiTfIRbDRg3XUcn5vwXNwLKTCJK1F5AAhPsa6?=
 =?us-ascii?Q?FA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <345130CF8C17714E822774AAD3F7CD7E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d62d219-2105-45c9-5c93-08dac0e586e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 17:28:46.8994
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +u10ytAlDuY3TFWl2WbpQvlBzhiLTS/tXcuDAOZbYN7CfRXr6JtITCYSfH8bIeXNlWtIm7NNPvmgymrxUVEmrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9277
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 08:45:35AM -0800, Jakub Kicinski wrote:
> On Mon, 7 Nov 2022 11:27:37 +0000 Vladimir Oltean wrote:
> > Since this is the model that skb extensions propose and not something
> > that Maxime invented for this series, I presume that's not such a big
> > deal?
>=20
> It's not a generic "do whatever you want" with it feature. The more
> people use it the less possible it is to have it disabled in a host-
> -centric kernel.=20

We were talking about "the model" being "the model where you allocate
the extension for each packet", no?

> > What's more, couldn't this specific limitation of skb extensions
> > be addressed in a punctual way, via one-time calls to __skb_ext_alloc()
> > and fast path calls to __skb_ext_set()?
>=20
> Are you suggesting we add refcounting to the skb ext?

idk, is it such a big offence? :)

Actually my previous paragraph on which you replied with an apparently
unrelated comment was saying that I think we're okay with allocating an
skb extension for each packet, if that's what the skb extension usage
model proposes.

> > I'm unfamiliar to the concept of destination cache entries and even mor=
e
> > so to the concept of struct dst_entry * carrying metadata. I suppose th=
e
> > latter were introduced for lack of space in struct sk_buff, to carry
> > metadata between layers that aren't L3/L4 (where normal dst_entry struc=
ts
> > are used)? What makes metadata dst's preferable to skb extensions?
>=20
> It's much less invasive.

Don't get me wrong, I don't oppose a dst_metadata solution as long as I
think that I understand it and that I can maintain/extend it as needed
going forward (which I clearly think I do about skb extensions, they
seem simple to use to the naive reader). No need to get territorial
about it, better to arm yourself with a bit of patience.

>=20
> > The latter are more general; AFAIK they can be used between any layer
> > and any other layer, like for example between RX and TX in the
> > forwarding path.
>=20
> You can't be using lower-dev / upper-dev metadata across forwarding,
> how would that ever work?

What makes metadata dst's preferable to skb extensions?
           ~~~~~~~~~~~~                 ~~~~~~~~~~~~~~
           former                       latter

I said: "The latter [aka skb extensions, not metadata dst's] are more gener=
al".
I did not say that you can use metadata dst's across forwarding, quite
the opposite.

>=20
> > Side note, I am not exactly clear what are the lifetime
> > guarantees of a metadata dst entry, and if DSA's use would be 100% safe
> > (DSA is kind of L3, since it has an ETH_P_XDSA packet_type handler, not
> > an rx_handler).
>=20
> It's just a refcounted object. I presume the DSA uppers can't get
> spawned before the lower is spawned already?

By lifetime guarantees, I actually meant: what is the latest point
during the RX path that skb_dst() will still point to the metadata dst,
and not get replaced with the real destination cache entry?

I think we're okay, because although DSA presents itself as an L3
protocol in the RX path, the 'real' L3 protocol handler will surely not
have run earlier than DSA, due to how eth_type_trans() was patched to
return ETH_P_XDSA.

Or I might be reading things completely wrong. Again, I have no
experience with destination cache entry structures or their metadata
carrying kind. Or with skb extensions, for that matter, other than
noticing that they exist.

>=20
> > More importantly, what happens if a DSA switch is used together with a
> > SRIOV-capable DSA master which already uses METADATA_HW_PORT_MUX for
> > PF-VF communication? (if I understood the commit message of 3fcece12bc1=
b
> > ("net: store port/representator id in metadata_dst") correctly)
>=20
> Let's be clear that the OOB metadata model only works if both upper and=20
> lower are aware of the metadata. In fact they are pretty tightly bound.
> So chances of a mismatch are extremely low and theorizing about them is
> academic.

Legally I'm not allowed to say too much, but let's say I've heard about
something which makes the above not theoretical. Anyway, let's assume
it's not a concern.

>=20
> In general, I'm not sure if pretending this is DSA is not an unnecessary
> complication which will end up hurting both ends of the equation.

This is a valid point. We've refused wacky "not DSA, not switchdev"
hardware before:
https://lore.kernel.org/netdev/20201125232459.378-1-lukma@denx.de/
There's also the option of doing what I did with ocelot/felix: a common
switch lib and 2 distinct front-ends, one switchdev and one DSA.

Not a lot of people seem to be willing to put that effort in, though.
The imx28 patch set was eventually abandoned. I though I'd try a
different approach this time. Idk, maybe it's a waste of time.=
