Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD27D44D7E7
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbhKKOPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:15:47 -0500
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:36175
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231739AbhKKOPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:15:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sb4nU5h9hXLUAasDOtwu8RAPbbLfW8krAHZElKQVZpVo738Bv5zKfBJYJcZ42CXbKIvMfXUPy44OnrE7JL2LzOoKnpl2M4faSnwZpIhRYK/XskPtuM5HIK9bqlTUKNTgkQEmhE0b9aEvBL4Bfjq7JeD6CWJppvZBYGlEq+AGIOTWyZPNGohffHXp9ZEagThlEbn4tMEFXYVRoxD2hgjU6Qbn9xiKtQ/w+ANtV9wysnXJIqmxM94A2CeveLRuZXxZBETYYOpZPkkhbIMWpnVJrok7WSRBSHnzJNv3AyJOmOIFnUvQeIIt2kZHIOZ52lrjxwFR4bfl0iCM1PvTl0c62g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=muueK6Eni8VzZuqrfhFfIZ34GWQEpeRpVP+30RnBtkI=;
 b=VJoT9nU9i53AUypCyLrbFoLkUgRa+KnBPuN30JvNqJgDNsc2xWCA45ujqgbnXk+w+Uk+obPlPSmpLWlOzviMB1xiFLef3V5mK+09VDciV6I1aBPAqjfD0ja6SXVplFOdOPPnP4HsKsiYXC03JJ0Xlx/GgqCTDEIw2oSA8LI+jFjdod2t4WQthtufT2478W9oi/RQZFl2+nJReKjnv1pfNM6LLvMGyMb8w6jHsl/WAriExoBCSCmX2sPjwJzDcvbtF9i9RCwdEENIuQT5kCVPvF/xbsFFC5vTTNsgcgoktMZ9H/lMuqto3QQ4Z1q5I/tILl4fQLM4nmOL4vLMGHxfUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=muueK6Eni8VzZuqrfhFfIZ34GWQEpeRpVP+30RnBtkI=;
 b=OhYtD94mct0Q9OtklErXABYiRuvy3E7q/mNMsnJRHdw4cA5cittHce5uPrCfAlJK9aEK+LqBC8fbmH428pStrCzzoApYUAuY4fHIPTUbwFueunWv5opVLVSOWvWSsiRyNGWJsQacPxPMrvLvc+Vh0F8Fqbfml5dghy/WHyykRaU=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Thu, 11 Nov
 2021 14:12:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 14:12:55 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Is it ok for switch TCAMs to depend on the bridge state?
Thread-Topic: Is it ok for switch TCAMs to depend on the bridge state?
Thread-Index: AQHXz9lSx2h62F19RUufp+eb+7u3yav3+6cAgAZJ+ACAAB/EgIAAB1oA
Date:   Thu, 11 Nov 2021 14:12:55 +0000
Message-ID: <20211111141254.jxcaluemybjll5mi@skbuf>
References: <20211102110352.ac4kqrwqvk37wjg7@skbuf>
 <YYe9jLd5AAurVoLW@shredder> <20211111115254.6w64bcvx5iyhnz7e@skbuf>
 <YY0eu2CatR9DDTQY@shredder>
In-Reply-To: <YY0eu2CatR9DDTQY@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 066918b4-c518-4dc1-aad4-08d9a51d5b6b
x-ms-traffictypediagnostic: VI1PR04MB5342:
x-microsoft-antispam-prvs: <VI1PR04MB53423549B74E3DD1FA2F4A02E0949@VI1PR04MB5342.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mWXTScA9Qkhuzm7q5R3al+9tr5KDuPFX31cBY2ed7ZIF1hen/tQBeWSpqywo9q4+X0Puw5eLy3FcP6l4R/XLgGKrEG3EKgw1mSJubXviFdjzFemxYVZi53x3f82+7IbOP4y0yDsU+VhE/xHAVvSMZAf97iTCrp6AVRsZ82Yd+M65UNkntPzAXOZjI/EFAc0v2uYFGKZ1kftLpffnTYLB4jjL+qHCGifBzW307nzG6MCWbl/iBZdnJNFISWP17Z7PQRePPRQJvZB5qE5aM15l1efrEAyE+t6KxjZ1dp7S+5l4XHlQ5rZTi+ERyXUV3AOYdCck9nrYuyGcQqTz8/0gVGKvkMK8EV2orJZfpvx2p4DbBdqbVOYzXUtRJwuR1hMjjgMXAxUrOcjktCPlwnV6Bt1rii82jvT/yL4YOHYaMx+gzX4YWFVeZObkYwL611a6IXab/5pdEeCtglXQPCCR1C0Ep8l3sGram+Z0mBELqxNWYHaE27qyILSCBYAalWRtTGgO9q9TPst4smkvC6aLQ/q9Mcdz+vxTNJYEl29JL26NUkwuODirxe9KCEEZnd6c3q5WaD6PS58v3o4I8V6pHWLb2Xyq8/DJ0PQGic4yAp101qab+kfRQzCNHQOUCHH6XsSNx540zMt/QsCuArNlXf+odLc8die2ODsn9pNZXq8FvfpJ/3TKw0H1ZJLcCLPSnf/1ACPJ28nuTa9sEYFVEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(8676002)(1076003)(66556008)(6506007)(6512007)(66476007)(6486002)(2906002)(9686003)(6916009)(66946007)(54906003)(71200400001)(66446008)(316002)(64756008)(5660300002)(38070700005)(8936002)(26005)(38100700002)(76116006)(508600001)(33716001)(86362001)(122000001)(186003)(83380400001)(4326008)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tAf6Wm+T+NY9+aUmGEoC41Q1TnF/+NhlM2bw8WRaJPCTsQYFUgHE1LXzQigN?=
 =?us-ascii?Q?segEUmlKS84abyLuioBFMhTkjhIEmLtfEwCfGTbFBe0q22plX3VLpzVsX9b+?=
 =?us-ascii?Q?y8tjvQQPTxethjiXDkcC+iMQjvlstDMNydZBV9EfRXKgZmunbvLb2Nl2/CIS?=
 =?us-ascii?Q?9QHLNyRRfJIrM0D7UDqW8Ux6RwPdXmhTOHam+YxsFdKiqUKBUL3QXRlQB0/K?=
 =?us-ascii?Q?FB4OrqYnxnwGf0hKV8splWtph1IcdKViyR3inaynG6W2o55V9SOUYLXDwI9N?=
 =?us-ascii?Q?SsuYsVrsbL78XPjRv+VGzbF2kQXRisjQYX6dM/a5JbReni2jNFcemp2nNqll?=
 =?us-ascii?Q?aADnq5AD8ASNTQsEyrbsRLcIxRteOp2yqgIc6F4V7soCW/Ob7yblLgPc/ga0?=
 =?us-ascii?Q?ANWDcYmflro9F6GNRZS8gGlMq4nIf67Z0OAi6DPhVngN5ZR7RcmhYM4FoOgL?=
 =?us-ascii?Q?Cx0DZQZSD8J1K8oloON6RXPRcLPvwfOQr5zchLbY5yrhANMlPSwPeYyihpcB?=
 =?us-ascii?Q?x/35lk6cFKWz74l5tzCokCwsTA7RQTYJiXKsB48XT9jsO5V1c0TwMppduhdB?=
 =?us-ascii?Q?IwWeWFO+GL1JIdcMA/eLRNhVFBm074QkErAmxpFivx443TpVpb7A6AjizrTq?=
 =?us-ascii?Q?4XwGkQhHHE+/pdHRNwQKqI6FbOF6bFr9H18BqXy0Mz1WhtM4FnOiH0POmOQz?=
 =?us-ascii?Q?oO2pS0adVtfn1Z0Guod8cIXI/B8o+k//O4TwXULqV/X/+Bh8FR6S0aMNdnkU?=
 =?us-ascii?Q?EHe2B0qFOx5PxsF+7kWQgWrrJvcSCNuNH9bFTXDf0XiRBpbyeaBI/CfK1Df4?=
 =?us-ascii?Q?5mbibxdZ5A610TIsSHxb9sV/XNawkcfGvJPhXoPa1Z1GRBBl4D+h7JVbIumn?=
 =?us-ascii?Q?8tWlvIKPae36XLwiHe0gssviJN2Wa1JIU05AcmHK6a0W4w/Ss0cYGU0j0tGA?=
 =?us-ascii?Q?Wxnuujyquw3PNTz6AqGN2N8AFkK6WegefUaTlSN9kGHHoOM1gWUj06O4uahO?=
 =?us-ascii?Q?A4HKJIKAJQYShrV2zBz4eN6JPV9Pv2sq6JSm7pn7ElV+zCLYJFjpVy+MtZ4p?=
 =?us-ascii?Q?42bf3eCS9tE5Cw95PujosxeLALakVPvg4ME9Mjq7hycwi0Z9OLKZaqaR+tnK?=
 =?us-ascii?Q?msVlJPKfgBa8LKpTEJjzOEIcpbnEHOCpUXVsO9UHIRuWfq+sbhZdJkY1brHL?=
 =?us-ascii?Q?cUx7u3uVWXv23YDpVkuSoS9KAlyBiCaNWE8rtay6/6b8UAxuUO0rMUrRpLOA?=
 =?us-ascii?Q?XdGoRZ4MbSAZONDeRPSYJMEA+daXlMnkKF02OYh99S/hVkMlxvdi7x5C7tYr?=
 =?us-ascii?Q?wDydq5OyKRmdSbkrdWKW5FP5YbS8P1CuF003phRRmoHeAPg9k86WUvY7a/Hp?=
 =?us-ascii?Q?sO8iW1DRQ41hORyK4GfLb/OQzp1/zAg8mqW+F+8TgiNVFOLvAoNot+2TZThA?=
 =?us-ascii?Q?hkj7/GzBLGqC3oKaOENYJK4K8COzq2/qgAE7/8d0oHx1dQOUizXciifKM/Gt?=
 =?us-ascii?Q?Qtsr+oDdmJy0oLijram9lR/rNqCe+57TDMkGXPjxXcAqE4fHAl009bkNFUYH?=
 =?us-ascii?Q?xVLzNo1pcoGTIA7j0c24KtiVFmkoGHhydVQQsW4hGa6Ey1vMmQZ+lY5oXT1U?=
 =?us-ascii?Q?CaafvF5gd5bp+6WAPV58fEw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6DD67ADE2D55874F8AAF4239DDBBDCD7@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 066918b4-c518-4dc1-aad4-08d9a51d5b6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 14:12:55.4494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BF+iBEf90Q3Jk8BuynB2MP4Aru3CmEe6miA8GUS2OZkjTRkXi9fb5Lrykl7Lyy/wttPXr9FGXt6+T23xu49eZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 03:46:35PM +0200, Ido Schimmel wrote:
> On Thu, Nov 11, 2021 at 11:52:55AM +0000, Vladimir Oltean wrote:
> > On Sun, Nov 07, 2021 at 01:50:36PM +0200, Ido Schimmel wrote:
> > > On Tue, Nov 02, 2021 at 11:03:53AM +0000, Vladimir Oltean wrote:
> > > > I've been reviewing a patch set which offloads to hardware some
> > > > tc-flower filters with some TSN-specific actions (ingress policing)=
.
> > > > The keys of those offloaded tc-flower filters are not arbitrary, th=
ey
> > > > are the destination MAC address and VLAN ID of the frames, which is
> > > > relevant because these TSN policers are actually coupled with the
> > > > bridging service in hardware. So the premise of that patch set was =
that
> > > > the user would first need to add static FDB entries to the bridge w=
ith
> > > > the same key as the tc-flower key, before the tc-flower filters wou=
ld be
> > > > accepted for offloading.
> > >=20
> > > [...]
> > >=20
> > > > I don't have a clear picture in my mind about what is wrong. An air=
plane
> > > > viewer might argue that the TCAM should be completely separate from=
 the
> > > > bridging service, but I'm not completely sure that this can be achi=
eved
> > > > in the aforementioned case with VLAN rewriting on ingress and on eg=
ress,
> > > > it would seem more natural for these features to operate on the
> > > > classified VLAN (which again, depends on VLAN awareness being turne=
d on).
> > > > Alternatively, one might argue that the deletion of a bridge interf=
ace
> > > > should be vetoed, and so should the removal of a port from a bridge=
.
> > > > But that is quite complicated, and doesn't answer questions such as
> > > > "what should you do when you reboot".
> > > > Alternatively, one might say that letting the user remove TCAM
> > > > dependencies from the bridging service is fine, but the driver shou=
ld
> > > > have a way to also unoffload the tc-flower keys as long as the
> > > > requirements are not satisfied. I think this is also difficult to
> > > > implement.
> > >=20
> > > Regarding the question in the subject ("Is it ok for switch TCAMs to
> > > depend on the bridge state?"), I believe the answer is yes because th=
ere
> > > is no way to avoid it and effectively it is already happening.
> > >=20
> > > To add to your examples and Jakub's, this is also how "ERSPAN" works =
in
> > > mlxsw. User space installs some flower filter with a mirror action
> > > towards a gretap netdev, but the HW does not do the forwarding toward=
s
> > > the destination.
> >=20
> > I don't understand this part. By "forwarding" you mean "mirroring" here=
,
>=20
> Yes
>=20
> > and the "destination" is the gretap interface which is offloaded?
>=20
> No. See more below
>=20
> >=20
> > > Instead, it relies on the SW to tell it which headers
> > > (i.e., Eth, IP, GRE) to put on the mirrored packet and tell it from
> > > which port the packet should egress. When we have a bridge in the
> > > forwarding path, it means that the offload state of the filter is
> > > affected by FDB updates.
> >=20
> > Here you're saying that the gretap interface whose local IP address is
> > the IP address of a bridge interface that is offloaded by mlxsw, and th=
e
> > precise egress port is determined by the bridge's FDB? But since you
> > don't support bridging with foreign interfaces, why would the mirred
> > rule ever become unoffloaded?
> >=20
> > I'm afraid that I don't understand this case very well.
>=20
> In software, when you mirror to a gretap via act_mirred, the packet is
> cloned and transmitted through the gretap netdev. This netdev will then
> put a GRE header on the packet, specifying that the next protocol is
> Ethernet. It will then put an IP header on the packet with the
> configured source and destination IPs and route the packet towards its
> destination.
>=20
> It is possible that routing will determine that the encapsulated packet
> should be transmitted via a bridge. In which case, the packet will also
> do an FDB lookup in the bridge before determining the egress port.
>=20
> In hardware, we don't have a representation for the gretap device.
> Instead, the hardware is kept very simple and requires the driver to
> tell it:
>=20
> a. Via which port to mirror the packet
> b. Which headers to encapsulate the packet with
>=20
> So the "offload-ability" of the filter is conditioned on software being
> able to determine the correct path, which can change with time following
> FDB/routes/etc updates.

Understood now. So it depends upon a lot more things than just the
bridge state, also IP routes. I thought you were giving an example
related strictly to the bridge. Now it makes more sense. Thanks.=
