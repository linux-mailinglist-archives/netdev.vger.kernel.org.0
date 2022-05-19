Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E8452D677
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239995AbiESOw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239987AbiESOw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:52:26 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50058.outbound.protection.outlook.com [40.107.5.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789565A5B2;
        Thu, 19 May 2022 07:52:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnJbj+X6M6dqFiTgWRgWvnX7reJixUW5kJyi8R2ee7U42BK7jymLJF56hfV74aOKwtWJc7mVVSAleWxmnwLwJ3k32ZPW6g+q7UBSyx+/dCx/DcsSbvAvYIEpwhMSpzPcKDIjlUrvT8Cj807YSgSUidFkv5mBrED9GOtMMGs5q4VF54Y6MyILPlj3u+z0rRcnaKvXmPUgoVgMMR5VG80W9InJ4EOQoWJhrPw2g4lQuCS8zelLWpgowNR78EHRyWeJQiQHalR0pHIbIJ/vt4/MFjx4EVqGmp/xcrpWLpm+2xgia+Drw/vFjQUnMibp2ekXLeq7EsWgMV5PC84whpFHXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqOX3fY1B0mTSj2O61s4UX3i8tiNuk1jhZYPnCbl6aM=;
 b=ZMHpzuK3wVykN55fLB6MOh59rGNaNNbQuJwG/3RH9au3ES63X5zm20k1/pi5iZMbBY3OHJFegOv/RdrPkHlB3oCLjB8gPP5uSgsou4jvkssrFVF8JV1F46V4F7uRX5rGYYzhJb5wdFFCR/pr3fwJ2wfkcoTNFmXvsvjWrV+gtKzI8x2v9bx03mhsHuFykTUiRcjWCpkyBvIU9dl0Sh2Ekz4Oi3F6ntbB6gO7TRTFa1xMYUsjw74fh1O85zA99xlpWQ20SKiq7iWLf43YPN5uSFYe7L9gB0LVW05kHmMnzZoDFF9rPGJ1hA+v/on947cd8yVeVGj3rDvJn60As8uhFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqOX3fY1B0mTSj2O61s4UX3i8tiNuk1jhZYPnCbl6aM=;
 b=AE3BzbX2G3/hQ1uVrK3g0nwgD+a4DGqgpiivDOJvQwI6dbwaujHpjpDkRFM/xijMaNco0jAfWBPOo1QvZGc/rHXOqNB3PWCMAAWFgctfs3QO4iBGEgPuHSRC7ARYBrICyCRZkDiXck/Xp+9kUiUTUQJoxRfjgYOsLhrbcvgFlpI=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR0402MB3317.eurprd04.prod.outlook.com (2603:10a6:209:a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Thu, 19 May
 2022 14:52:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Thu, 19 May 2022
 14:52:22 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
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
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Topic: [PATCH net-next v2 2/5] net: dsa: add out-of-band tagging
 protocol
Thread-Index: AQHYZ6RHhg5iGg0Rm0uC0ArSy8F0MK0e99AAgAOw5ACAA6gZgA==
Date:   Thu, 19 May 2022 14:52:22 +0000
Message-ID: <20220519145221.odisjsmjojrpuutp@skbuf>
References: <20220514150656.122108-1-maxime.chevallier@bootlin.com>
 <20220514150656.122108-3-maxime.chevallier@bootlin.com>
 <20220514224002.vvmd43lnjkbsw2g3@skbuf> <20220517090156.3fde5a8f@pc-20.home>
In-Reply-To: <20220517090156.3fde5a8f@pc-20.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d3a334c-f45b-4cdf-1e99-08da39a72e6c
x-ms-traffictypediagnostic: AM6PR0402MB3317:EE_
x-microsoft-antispam-prvs: <AM6PR0402MB3317F14675AC7460A04AA4E2E0D09@AM6PR0402MB3317.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gMJ+8W9oq8aYeJP/pdZf464ZX10fAsppKcMbUeHGoLjzqAXaUpYwBgk4/OCjD6f+aegJrlQItkTm6VSRcYOolV7MGwf3lc+q43x/qw3gooAa87kZDIY/mPvMpVSLz5PY9n+QRZywPG4r5BisbKKk2kXyEaCcJjKH+z16fiJHxyQr+cP3H1aSf98q/WQYR8f5bu4np/7lg7FMvfTSANQRrXmKwIdsjF11Gn0jF656/1RmxQPK2DyhlJN5rf8C328KzfRybrKeL+6ZWnyiQf3wDiOT2mavU52VBPAlwwjDH9Pqb0gsG0ic37SxeUZbdEhlpzt+fGbyCYkrgd8/cjLNbOZAYdGsI4ypR9gp4jAP9MzuHZq/5fy5eCBsmMxqxuqqV2YTp7xV+6f+WJ7AP1v8k+gl9p5JaMiKXNFrAJwbGELfgu3emq6sHSSQhphIch7uGAmG3TPmuNKFCNA/NHLJeODwsXx8GLQ27VriIEBKM9a4ZM3IvQDYBEecx3oH5WNLJGtV8nMtyks7+5aEryf2roi95LRkkFplYVWEmqj2wpUGTBfOItubmoft8xpuE7gaFljo4r79AMJmqXiwpW3MYWSHWPPI49VsCSvYCl6baUAlLmhxagczFmhb+GEcjw0QPnjaOU40YYVwyWVjwsYftfJNj9rlhroYDYp2WGwyV2vqwXhDDV2ETtyYEaLrtY6e9ehuWAvf4Ju0Noyzpdp1aA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(76116006)(6512007)(91956017)(9686003)(66556008)(66946007)(2906002)(8676002)(4326008)(83380400001)(86362001)(6916009)(38070700005)(26005)(3716004)(64756008)(66446008)(122000001)(54906003)(5660300002)(508600001)(38100700002)(1076003)(8936002)(66476007)(6486002)(186003)(44832011)(7416002)(71200400001)(33716001)(316002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HJOW0Ijq906ZIFt+L7wSmHvIhK5dX5+HdoSXOf4bLFDHaUz8ADCRvp5wmIuv?=
 =?us-ascii?Q?izJVi9HzW3rM3x388LTZk2NnvLmPjhsSaFNL8nkHEZKSWiA4Nr85indEIhrJ?=
 =?us-ascii?Q?RBuD0ozFkv7gccVYcl7L9p9H7IBdJY7+5O5YZJFk2TLD5W+IWtu0xXUznjhk?=
 =?us-ascii?Q?yT6Mdl0G76GMHApyL9YbuBBADDFE3BM98KmyHvBV25/5nell2F+S/uMM5LyY?=
 =?us-ascii?Q?hC7ESqlGlN1/VSVw6VR6HJswo5kmQ7I5n3vQM5LZu3Iy5QzqJmRe3QTGG5Rf?=
 =?us-ascii?Q?Cj6oP/qLFH07SXmPQlgODL24kf9XNLbSdXwmtDr/VXurO+GNby8CrtSJWLAC?=
 =?us-ascii?Q?NuHm3obfidXVuy2SUWAfDzTFkYf7vatVixREbXujOAtKKK2QQtACUOSY8n3G?=
 =?us-ascii?Q?5AsK+4b99msamrzsqF3hmOb+8X9UZMyOqjh7cuxK+b4bkHCNCG+4Ie7Kj0rR?=
 =?us-ascii?Q?iGya88JHqPf6BxJKhcM4bPSHGUmcYyCLMEoqtJaCpKlzdasYkvnldXelZBzF?=
 =?us-ascii?Q?waLXN6l3U57EMj2Dyw4hyVAND9/GI9+rgJ23b/1j9RccjDeNUv5C3t9Mst0A?=
 =?us-ascii?Q?K+Q9siPCBR4y3tKtD66XjVUQZSidtBY4Ggz+ydHo2tCu2DkyKwYW8Snzw94p?=
 =?us-ascii?Q?TVfReTKzg0YQz301+tMfpPFLpSdTtGke0nMn8kEAZd241G+hMwYBxsZVZ1aJ?=
 =?us-ascii?Q?gAJdWunhOGKACQ4lKXbIBQV6iPs0x0sbfV90XJietKmzpNufg63vsdXRop6G?=
 =?us-ascii?Q?njbLytJ9bb7LNi34KgBVQpCk0A1Sil8RSfr8JL4T71JBiGrnYOsyqxYSfHk1?=
 =?us-ascii?Q?tzyN6Nqvv41EoAuqG5lPNBbLw6B3qEs/+SHUlBWmVQRmn6Nbbv3YOU6GQFgM?=
 =?us-ascii?Q?5AjKxk7wfn97X+FdzpqryXJgHyQQ+/fH8BzhOhffR6iPyOqUkwtb7ICTkMpU?=
 =?us-ascii?Q?g65+V7iHgSlaAj1N0FKiXWTr0JO/cbJ9Klo/6vzkFqe1SuRAdU8Kj3DoQMxT?=
 =?us-ascii?Q?22KEC7E65FO6X6curfG60jrpRtIWL8Jbklf8TXxKkMXvWT+XHOqLxU51tN79?=
 =?us-ascii?Q?nxjxgcVFeXuYy8V9IYxpWrIY+pQYYkKhlxDBI9RHClRRXjmNBtozIxz6XcDU?=
 =?us-ascii?Q?MwnrVxVrYaReuDjwNAdTxuibETE+MoQP8K73V1k0Jx0VWdHahKgtuufwKsqB?=
 =?us-ascii?Q?3MHV1KQ/Uun5gR7qMaw2BH3tEupLtpzKwl6gWdqvU7E/HGKdh7/cevqWQQ4y?=
 =?us-ascii?Q?MQUI3S1VhxRY6TM0tX75lTrOCncIST2zPKbtP3D/K9li75bTXk2e6IjA41xo?=
 =?us-ascii?Q?B5riZj4xf4ogvvgVCanbZMZgHDk3vL9XayW96VMcmwJoL06HGjNTm0kea0Yg?=
 =?us-ascii?Q?IXjWh+cuogJWnQYlXHFra/IvJNJ87lihHf3J19ZjGA3fH9uChoQJO+ZCxqu2?=
 =?us-ascii?Q?4R1DAY68q1Ix7XjLs1Rzkakc/n+ILizAmqBWckO4AElrWlZUOs2A/Oz1BXLp?=
 =?us-ascii?Q?Ysq5ELW/UAmPd4QZuSdic0J8lF219hB2kPHcD1orlh/FulIBzSwF5pToRTzm?=
 =?us-ascii?Q?W4R+yPyglOttwlTU1IcPdGy9m7elH4w4fG4EaI+KJkx69WU4ujxWr2B5TFHw?=
 =?us-ascii?Q?3RgZNbS5nx1tHibLBqLPoU34b7sVGTppfvUoMmcAxgnrYY+yLGMHoHxMnXEK?=
 =?us-ascii?Q?oYQqzAE3diNeMMefg8CFP2R5Uin1IExq1sRk0iPIHwcEVEpVeJFKjlk5wIec?=
 =?us-ascii?Q?eK9OXk6WFT72WTTHiojMNDEqqNTw7FI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <29EA15EF18553F4D9B6FAD828A53FD5E@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d3a334c-f45b-4cdf-1e99-08da39a72e6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 14:52:22.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: srg9/0bXX/gQIv3/npuK1O2D4pzsyuZcMl1rG4W0DC4dGYrpVFbzEtogDP1vlMFvexbaIaJWvfUmAjx0iECRxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3317
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 17, 2022 at 09:01:56AM +0200, Maxime Chevallier wrote:
> Hi Vlad,
>=20
> On Sat, 14 May 2022 22:40:03 +0000
> Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>=20
> > On Sat, May 14, 2022 at 05:06:53PM +0200, Maxime Chevallier wrote:
> > > This tagging protocol is designed for the situation where the link
> > > between the MAC and the Switch is designed such that the Destination
> > > Port, which is usually embedded in some part of the Ethernet
> > > Header, is sent out-of-band, and isn't present at all in the
> > > Ethernet frame.
> > >=20
> > > This can happen when the MAC and Switch are tightly integrated on an
> > > SoC, as is the case with the Qualcomm IPQ4019 for example, where
> > > the DSA tag is inserted directly into the DMA descriptors. In that
> > > case, the MAC driver is responsible for sending the tag to the
> > > switch using the out-of-band medium. To do so, the MAC driver needs
> > > to have the information of the destination port for that skb.
> > >=20
> > > This out-of-band tagging protocol is using the very beggining of
> > > the skb headroom to store the tag. The drawback of this approch is
> > > that the headroom isn't initialized upon allocating it, therefore
> > > we have a chance that the garbage data that lies there at
> > > allocation time actually ressembles a valid oob tag. This is only
> > > problematic if we are sending/receiving traffic on the master port,
> > > which isn't a valid DSA use-case from the beggining. When dealing
> > > from traffic to/from a slave port, then the oob tag will be
> > > initialized properly by the tagger or the mac driver through the
> > > use of the dsa_oob_tag_push() call.
> > >=20
> > > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> > > --- =20
> >=20
> > Why put the DSA pseudo-header at skb->head rather than push it using
> > skb_push()? I thought you were going to check for the presence of a
> > DSA header using something like skb->mac_len =3D=3D ETH_HLEN + tag len,
> > but right now it sounds like treating garbage in the headroom as a
> > valid DSA tag is indeed a potential problem. If you can't sort that
> > out using information from the header offsets alone, maybe an skb
> > extension is required?
>=20
> Indeed, I thought of that, the main reason is that pushing/poping in
> itself is not enough, you also have to move the whole mac_header to
> leave room for the tag, and then re-set it in it's original location.
> There's nothing wrong with this, but it looked a bit cumbersome just to
> insert a dummy tag that gets removed rightaway. Does that make sense ?

You're thinking about inserting a header before the EtherType. But what
has been said was to _prepend_ a header, i.e. put it before the Ethernet
MAC DA. That way you don't need to move the Ethernet header.

But anyway, too much talk for mostly nothing, see below.

> But yes I would really like to get a way to know wether the tag is
> there or not, I'll dig a bit more to see if I can find a way to get
> this info from the various skb offsets in a reliable way.

Without an skb extension, this seems like an impossible task to me
(which should also answer Florian's request for feedback on the proposal
to share skb->cb with GRO, the qdisc, and whomever else there might be
in the path between the DSA master and the switch).=
