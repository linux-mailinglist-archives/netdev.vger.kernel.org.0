Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED9D4706CE
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhLJRTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:19:08 -0500
Received: from mail-db8eur05on2067.outbound.protection.outlook.com ([40.107.20.67]:8929
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244243AbhLJRTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 12:19:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S//DZs0LDrgz5F19+DhtV4qbqOGrAtvTGQPkSWMZaxWkwhLZhp6wYUqvBA2Bul4UPj8jD0NkBLubomO1Nnj3IB+xSiMKJPovoH44/fCF6GP49hnCkyQSWoMyI9LVWfGhzwOnZh8emOxaVVBSSvRggjSvqFLY+eme7DEJ2gfSNUruVNJ55qETiSJYuMKu7Wxmk1TgHmQ1AXxuc9CFiEh7dPt6e/ARQpblPsKRiuT4eOAiXCyilwLRIXmtinpsqT6hVDskeFuuagJJe1h4XGk0tbQ3cFCuCP9SkoHl/1gKOdsFiRvum4PuCfi/1tAjFAW3Yo7CIZ9aZPpEeZqZL7KrpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rxM2X6xhP/NpkwE6sgwzPz/QK3o/z1lNmGl4Cx7HrTY=;
 b=Kl4Wn9abRd+CxjBM+3lFyz7Nmh6AUgv00gfErZc9dczWsuluGQ+/dHXBV7sEMCp+2vQMOxUpmlqWRYlligC5Swh2w9KxQFFHQ6UHYtFTSG60S1Pal+pIR4ST8afBHJr5zOa+4Vc/r3dQ/t8K+h8JxIjzlz/g1CfUugsWO5lRUBKxcgK+WeJBPu1w3ITIs9ulvvHx/htwUr//V5I/IAKgqwunbalpMnHpy15srs6nvtxQa5TyxS9yyVBMTs/KEZXUc9ibCtTNhMw/477xIiR3OZK9aL5TT1E1XPQZ+LuZqRdafj3LfyR5qZ02EMglSNHh4L3N9VzUSGlS7SuU3f92uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rxM2X6xhP/NpkwE6sgwzPz/QK3o/z1lNmGl4Cx7HrTY=;
 b=mnHz0ME6Rc+kSps3LcAslgh/LXKgmGBDrOq31hG+euQDhsOBYCSz+as2xzS6mgXmIPeYW7WmRMY+5CNaJdW69VJIcKRK7VS+bC3ANhyn7aLCbEHUrPiWQjAWtyqt7e8RS7CviEqBS15cuVxWzqNvCXbcmi4JotHdX8C45WNBTpw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB6014.eurprd04.prod.outlook.com (2603:10a6:803:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Fri, 10 Dec
 2021 17:15:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 17:15:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Topic: [RFC PATCH v2 net-next 0/4] DSA master state tracking
Thread-Index: AQHX7SPAys/vPXh1a06w39SkUSlBS6wrFFcAgADg3gCAAAJAgIAAAVQA
Date:   Fri, 10 Dec 2021 17:15:30 +0000
Message-ID: <20211210171530.xh7lajqsvct7dd3r@skbuf>
References: <20211209173927.4179375-1-vladimir.oltean@nxp.com>
 <61b2cb93.1c69fb81.2192a.3ef3@mx.google.com>
 <20211210170242.bckpdm2qa6lchbde@skbuf>
 <61b38a18.1c69fb81.95975.8545@mx.google.com>
In-Reply-To: <61b38a18.1c69fb81.95975.8545@mx.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0bfd7672-1229-4908-ef0d-08d9bc00ab2e
x-ms-traffictypediagnostic: VI1PR04MB6014:EE_
x-microsoft-antispam-prvs: <VI1PR04MB60148F3BAB8224E7DA077FA6E0719@VI1PR04MB6014.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AnXiDAgt91N3LIqdK9rE/SiPZsaeRD7K3qB7Wr5XugL7y8DeHKFaaQIqwA56GXOX7LiE4hQgF9KPySTPH4+v13dIGeRk+8r1b10rhEkipxin4kHYCeIiPELMU1zY1fNtqRNdYKsnHEmmlbegHpZ8OKZpRKyKOK4FT/jM01My9qmITJrIqdYg1MfLRVPp8dPff48zS+as6JHbOMsuCMwKB5HCucshoIxisqBQclPa50WaJj0D38RTuumhrli+ShuJKmPDEJ7jH2qrrOdoh+neKm59Tbcsd9EkPKK/xXjLrZk6T4Xl7YDeMSp9xd5MYJxPn7YRw5U3oIu+pAOqUozo3IqJhEVt8cBOvbMbLkyn5F/6ks+E7/kyq69MWoG67UwALqIGVrTsdO/SoFnPUk6MU1aDO+jOaIu/llKUBiThnCzHMacGINxgjNbAQBZSitaqSpEhmJb+s6gzKM8bJHPAwxLiLdJWkjKyZip+GRm1KdaJpt5vFtcmde0TcF1q/MuAU6g5CgYNfM7K6yK6ygl1S/86dkjTlZXExEa6yAgBJiwPuxQnpoI1U8BnZtY8a4n/GhO462TnMaSwem+Ov+umAw7Sybu6JJs7Dz86kGZ/F62H/HG5BDp4UoOnvyLwmS0vuUXHiIJvzwtjiDi/j0wdnOvHgSJvE6ZtIcfHCi4cjGSDzEwOtWk/4quPCcNcGJZIL9+2+ahFzGoaPPjWFYHRsWlL1GA3TlBo8tfltiZVbSjA1RnXKqPybhQbctoFKNSWcsrbiNvPGYqzZKLXNIhWKTsA99jTF/Kp7HIdXcG73cE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(38100700002)(44832011)(64756008)(8936002)(66476007)(66446008)(26005)(5660300002)(186003)(122000001)(8676002)(6506007)(66556008)(6916009)(508600001)(4326008)(66946007)(9686003)(1076003)(54906003)(33716001)(38070700005)(71200400001)(316002)(6512007)(2906002)(76116006)(83380400001)(966005)(6486002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?h3gcDttGgvOSxAdWaQWuKqOiIjahqLqyrTLvtU3/lziUoHIKyFL4cTry6uuA?=
 =?us-ascii?Q?MH5C6coPWAhUGelQeuDBhh2yZMDsD5O56TcO24NwsY1zWZUAy1leWQ2sipTk?=
 =?us-ascii?Q?bPRq0GHG/OUoW1+Gf5OeEoOKaKW34kAJ2iwaQI1xcGbqLOQk87VluP1DxCyO?=
 =?us-ascii?Q?yy4UpYbg9tmu5ESC6LTl1K5YnBBMiGtEptui1RTlE4sUvuw45x+WVsabCbcx?=
 =?us-ascii?Q?9uSnvlKkLu8RwnpLjCdgCNya2Dr26UtMX1dCpQAd3LgOTywkBR53dsgqNMJt?=
 =?us-ascii?Q?RS4LDzbl7GvvgJDy1lyw9eV+4cPqZ4QeCKVLe2hFpZi06D01HoAqChP/tbzd?=
 =?us-ascii?Q?TO4kvPWlkwJx6GT3TFln+wtl1HEtI7QVIhm5Pzvq1cGMS2Ru4FntWKLJtGO0?=
 =?us-ascii?Q?ZQk0kYbheM2+n/o8RdGF1RVYm/5lYLPt5meDvwC6oH+5T3WLwjHWnY9sbYvE?=
 =?us-ascii?Q?eDTiW3OVRWIJF69aVJAlPQt43onPzvkz3Uo6tfIl1DqtIIcc5Oocdu5AVALC?=
 =?us-ascii?Q?bLCx9llzu/LcZZJWUjkWjzRiJG0uIVpk4DaNF+b31FhUnDntZe4N7+yT2mdC?=
 =?us-ascii?Q?vu/lZL7WRltXoGUAbGaQbAA8DyV0/Qg3H5MDrfoNfulT+tbSsmtflX6zrON9?=
 =?us-ascii?Q?fcpNaT3zXIiGs1uVfS2BKneeHBF82Qm1gXsfQ6cwcX9bV3+BcY013sfd3CHe?=
 =?us-ascii?Q?ao+kgt6dHvj9xJsvusCKh72rRmoolJkyfpy6Y/2NUPHDJFzjwrEkPGt0InHg?=
 =?us-ascii?Q?MYmV3z+fh45fZBSOX8FaNTzNZt3cG9GFArsu/igKb9sFsoJ8/XUH9GbSC4Cu?=
 =?us-ascii?Q?95JGeBUOAsFcgxNB9VSEZmIqW7obBr8Gwr1rw+c+p+HEPmx1EnnXS1a9LSly?=
 =?us-ascii?Q?0s4psKo9xuOKz5Rlze+l3oV2xafE8ncRL+zFDtOYMFxI4mxd6Erf94jhxywF?=
 =?us-ascii?Q?lc9WbBGhL9KWdahcCXV9QqyRk9boWt3SvJx+62KTQrD4FddQ4x+MC4JnYtxk?=
 =?us-ascii?Q?s/bRLpmMwgHaA8vnzFGgoIV0KNLOEMvod8L9Pyh8Ku7H2sLvsNqkFHHbyOFk?=
 =?us-ascii?Q?acX4fvj6tYCosBkjm4CLsdTws22Ua6MS1e3n5L8/CJBVPVZ1/8QSSViiNJo7?=
 =?us-ascii?Q?OEplDTa/DFceyigwaMyyZBrUgo36QO3gLXOUqucj2rWWBbDLq9HJd+YUKFt9?=
 =?us-ascii?Q?9JEDvZc1Kn6/PZ5NG71Q5Spp/u1YwECH6kO7vnzvJymT+AYzYgpNLIs/Svi5?=
 =?us-ascii?Q?ZkOwWOeHjdCFcAJYj1yxrGPaAnbEZgejXdTyWQkN5p+l5lFcyJ7LRbkoZV63?=
 =?us-ascii?Q?GD3lR+04Sx2ht9cPI/E+66WJXQ/ePFf4akRc0P0x25AlFQhSlz/3VVHBzpgU?=
 =?us-ascii?Q?bPl28ilWvVGCQq8qtcM5n6tXXePd7Ft/Ubtp05N/tjqa98EGFO7V55aOeIDd?=
 =?us-ascii?Q?u5qAp8BGmIaxGOoN1Lt5gGJDn/RzqEgEkdpVjQw13fWk4JyaMEWrKnbmU9eM?=
 =?us-ascii?Q?nxpi0QQwD2gQsHhDmO25zFMSPydpoZdP112iBa6RyeEiODQIlOBYH9WIfsJ6?=
 =?us-ascii?Q?PdQNkgVWaYfkeBeP1QCt4W9N8sbY5X/omhKnkEkAoDLLXA1DY8ZH/ZAh/iEE?=
 =?us-ascii?Q?4AZ2cZU20TY+DnmaG+Fvk30=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A7FD3B10123F864A87E59B22F6A0A9E5@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bfd7672-1229-4908-ef0d-08d9bc00ab2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 17:15:30.6387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ep7saeAR2o1subn+RE1NO14XAMEhepWx5mdSlV5T25GleAnPCfaZFMTefvoSd5GfNRkXZuy0gT6utCFzh2jrUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6014
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 06:10:45PM +0100, Ansuel Smith wrote:
> On Fri, Dec 10, 2021 at 05:02:42PM +0000, Vladimir Oltean wrote:
> > On Fri, Dec 10, 2021 at 04:37:52AM +0100, Ansuel Smith wrote:
> > > On Thu, Dec 09, 2021 at 07:39:23PM +0200, Vladimir Oltean wrote:
> > > > This patch set is provided solely for review purposes (therefore no=
t to
> > > > be applied anywhere) and for Ansuel to test whether they resolve th=
e
> > > > slowdown reported here:
> > > > https://patchwork.kernel.org/project/netdevbpf/cover/20211207145942=
.7444-1-ansuelsmth@gmail.com/
> > > >=20
> > > > The patches posted here are mainly to offer a consistent
> > > > "master_state_change" chain of events to switches, without duplicat=
es,
> > > > and always starting with operational=3Dtrue and ending with
> > > > operational=3Dfalse. This way, drivers should know when they can pe=
rform
> > > > Ethernet-based register access, and need not care about more than t=
hat.
> > > >=20
> > > > Changes in v2:
> > > > - dropped some useless patches
> > > > - also check master operstate.
> > > >=20
> > > > Vladimir Oltean (4):
> > > >   net: dsa: provide switch operations for tracking the master state
> > > >   net: dsa: stop updating master MTU from master.c
> > > >   net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown=
}
> > > >   net: dsa: replay master state events in
> > > >     dsa_tree_{setup,teardown}_master
> > > >=20
> > > >  include/net/dsa.h  | 11 +++++++
> > > >  net/dsa/dsa2.c     | 80 ++++++++++++++++++++++++++++++++++++++++++=
+---
> > > >  net/dsa/dsa_priv.h | 13 ++++++++
> > > >  net/dsa/master.c   | 29 ++---------------
> > > >  net/dsa/slave.c    | 27 ++++++++++++++++
> > > >  net/dsa/switch.c   | 15 +++++++++
> > > >  6 files changed, 145 insertions(+), 30 deletions(-)
> > > >=20
> > > > --=20
> > > > 2.25.1
> > > >=20
> > >=20
> > > Hi, I tested this v2 and I still have 2 ethernet mdio failing on init=
.
> > > I don't think we have other way to track this. Am I wrong?
> > >=20
> > > All works correctly with this and promisc_on_master.
> > > If you have other test, feel free to send me other stuff to test.
> > >=20
> > > (I'm starting to think the fail is caused by some delay that the swit=
ch
> > > require to actually start accepting packet or from the reinit? But I'=
m
> > > not sure... don't know if you notice something from the pcap)
> >=20
> > I've opened the pcap just now. The Ethernet MDIO packets are
> > non-standard. When the DSA master receives them, it expects the first 6
> > octets to be the MAC DA, because that's the format of an Ethernet frame=
.
> > But the packets have this other format, according to your own writing:
> >=20
> > /* Specific define for in-band MDIO read/write with Ethernet packet */
> > #define QCA_HDR_MDIO_SEQ_LEN           4 /* 4 byte for the seq */
> > #define QCA_HDR_MDIO_COMMAND_LEN       4 /* 4 byte for the command */
> > #define QCA_HDR_MDIO_DATA1_LEN         4 /* First 4 byte for the mdio d=
ata */
> > #define QCA_HDR_MDIO_HEADER_LEN        (QCA_HDR_MDIO_SEQ_LEN + \
> >                                        QCA_HDR_MDIO_COMMAND_LEN + \
> >                                        QCA_HDR_MDIO_DATA1_LEN)
> >=20
> > #define QCA_HDR_MDIO_DATA2_LEN         12 /* Other 12 byte for the mdio=
 data */
> > #define QCA_HDR_MDIO_PADDING_LEN       34 /* Padding to reach the min E=
thernet packet */
> >=20
> > The first 6 octets change like crazy in your pcap. Definitely can't add
> > that to the RX filter of the DSA master.
> >=20
> > So yes, promisc_on_master is precisely what you need, it exists for
> > situations like this.
> >=20
> > Considering this, I guess it works?
>=20
> Yes it works! We can totally accept 2 mdio timeout out of a good way to
> track the master port. It's probably related to other stuff like switch
> delay or other.
>=20
> Wonder the next step is wait for this to be accepted and then I can
> propose a v3 of my patch? Or net-next is closed now and I should just
> send v3 RFC saying it does depend on this?

Wait a minute, I don't think I understood your previous reply.
With promisc_on_master, is there or is there not any timeout?
My understanding was this: DSA tells you when the master is up and
operational. That information is correct, except it isn't sufficient and
you don't see the replies back. Later during boot, you have some init
scripts triggered by user space that create a bridge interface and put
the switch ports under the bridge. The bridge puts the switch interfaces
in promiscuous mode, because that's what bridges do. Then DSA propagates
the promiscuous mode from the switch ports to the DSA master, and once
the master is promiscuous, the Ethernet MDIO starts working too.
Now, with promisc_on_master set, the DSA master is already promiscuous
by the time DSA tells you that it's up and running. Hence your message
that "All works correctly with this and promisc_on_master."
What did I misunderstand?=
