Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6524511604
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 13:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiD0K4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 06:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiD0K4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 06:56:37 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2046.outbound.protection.outlook.com [40.107.21.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A083A749E
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 03:32:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7sP8PpM5Gqnkqu85ANxc3y+5Yg1Z5dU68zJYB+7ve8jw7sWLSUR6ZoQs1SKWrq6VWKBSv4l+BAFXFvcm2w7Pmr2uULfkkqqGdFmjcj5M+v0aJ2F+N3LuLgYEcC+SydAja1H/SnLXFJORDcdD6yF2OodsaxIMjBVJi9dp1TpWnYwcGTLshMa0J+VAemH+H3z1keElGFFGvcqL8D0E0nVwBbgCUyjPBkN16Nq5U94F586OQejIx+4w5DW40EY+qHGamxvPftzmb/eP/y0FTDkKWgwqPSeGFe6mhhuYe6GUyf1Bw1VtQZszzZCuU8tdx0y5OKHN9SURuw/1E1AmDl8Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SHhXRYRaxjNoLV9EJ7qtiSoGREqNoFqhEUpoGMfKXHY=;
 b=gniZidn1gFQ14FptBu5c7YxBGo4ZmMd1LCbhwIQiPo+BdTSMANEyU0n1OZywj8bIKQsEPXiVo6Sfq/Bt+LzD6QyMI/Wsh7WaFkgzMa36XfAaTbm85rjEQRZE9qA544yJCUt2r0Z7KYdMADbA1A8QJbqvI3gfz9eyOFGNEoeDj5yd4IlwMGZp90ep3LMl3ps1CAD6VelP33SDScMRZ2lUMe97HPIBHfK7wGRzjozrAOeZ6nERFzDvEhaftBXXvxIY2eDvHyJ/Nea1teRB/Ht2WC2jLHHxmPMhzgxOxxVs0cGmjwkP03Hz1eYp6a/cWsd1w4+I4krT08NtrmME3qwlYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHhXRYRaxjNoLV9EJ7qtiSoGREqNoFqhEUpoGMfKXHY=;
 b=FqGqtV6wZ5llfc6hiJIHUxryK4+QmgidSl3ZGkck6bI8ZqEAVl2E7XfhR6Duq+54EUZz7/z/axDqq7lOQX+C+OHbaxbgmiMxYYfm2CJKtqjMxo7Wl4cqqAMEEnzPBtmq88mDqG6vd7+OzUuc/nF3xM+u3m9p/1QKEAg8EsdHfdk=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9490.eurprd04.prod.outlook.com (2603:10a6:102:2c2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Wed, 27 Apr
 2022 10:32:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.031; Wed, 27 Apr 2022
 10:32:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hans Schultz <schultz.hans@gmail.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform
 FDB isolation
Thread-Topic: [PATCH v2 net-next 07/10] net: dsa: request drivers to perform
 FDB isolation
Thread-Index: AQHYKilM1SMl98R0uUaOWdZX65QhHa0CqMaAgAAUSYCAAHZWgIAAnJEAgAAf0IA=
Date:   Wed, 27 Apr 2022 10:32:11 +0000
Message-ID: <20220427103209.luyfereepqaha7dw@skbuf>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
 <20220225092225.594851-8-vladimir.oltean@nxp.com> <867d7bga78.fsf@gmail.com>
 <YmgaX4On/2j3lJf/@lunn.ch> <20220426231755.7yhvabefzbyiaj4o@skbuf>
 <86ilquapl1.fsf@gmail.com>
In-Reply-To: <86ilquapl1.fsf@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86b1e63e-540f-4010-0162-08da28393090
x-ms-traffictypediagnostic: PAXPR04MB9490:EE_
x-microsoft-antispam-prvs: <PAXPR04MB9490616326A58A87F86CA539E0FA9@PAXPR04MB9490.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q0TDdh8gJaRRVetBlnY4fmLpSTHdiXsRlXORS8awHbOdBzBz0EYZQ8v4xQ2yvfuG7hIlO9q7F2bNg06dY7xIpAaTmHCaUy0EdKt9L5K3Nd2qEQaf/Vy/egFD1SwUmNCJP/x5zIc75X+Zt6NMQ++5MNqja4fWLlzO33sADm4OuuMyg5HlGXx9xG0xTuZ35vxkhGbR2hT4oROtyKRCfwr2c/IuHAopMkR1OaoyGed9Y6G/O5jvuerHDTxlTqxLYqZg4kjqp9TLtzMrdaiNXpYcmogkf/4lpHFvyRz9NIZG94qSMNjUtjvOT2FgDPyt9Y+hc/f7xGU5WJFfhyNdNlU7SaFiYUQZAzKHKIsUAKVE4VwHZOFzO/riTdjO6n+ubidrY+xjhezAap8AhAidvXOYCSXqX6xQwgXJ0gjaprCQXh+udoAjItercHqjCgeS0Wbg0oXSO0IZVtWBa//BDejglIEuvFFoAGrmZ4sq2ZVwM0HpdY0BygoWwbZM4YdvEQZWed0QlCkjTktYo9s796Jg7UFYrn70mzetpW1hYfguEoltPVxBiSfKneRGjn7ZaMep/agJicrl02tWoxQ97k7zQNYF3FJiNT8eJInz16WSxVEjsFB14BNLieqrL9THsdghDU12ewUI8PlytIe9A/V4ynBCk7KYpaOOYnyNvXJ18+Kwrms45G13EJc9dWt/3cGbd5E+vE+kmykxEcyUNxTNyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(7416002)(2906002)(38100700002)(44832011)(38070700005)(8676002)(4326008)(122000001)(5660300002)(8936002)(64756008)(76116006)(83380400001)(9686003)(26005)(66556008)(66476007)(66446008)(66946007)(6512007)(508600001)(6486002)(54906003)(186003)(6916009)(316002)(1076003)(71200400001)(86362001)(33716001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?5UmdbBC4BVv1PMXYH/XKPAEPCaNBUFCpSePKAn7DkNr4/8v1s6oxMucW?=
 =?Windows-1252?Q?WfHFcMPSio8KunRxBw2GTNHUdgo+2QfLpi7Oy+CVI5z8FIw9kJ142KX3?=
 =?Windows-1252?Q?MMihsNo9CPdKlU6UTPR7bzN50Vxat1LPAxfpK5j6sDvoe7QOOq6YlzlZ?=
 =?Windows-1252?Q?iw+xdXwi4Cdyul+XRV10bMRbAgKHs6zuUWOyUWf/2T6mvTZ1DP9o0JRK?=
 =?Windows-1252?Q?KBBqgIuOnFwmvykdT5VgCXo4ACUbfX/TOPA4M604hnfX2GuRcEKnb/gP?=
 =?Windows-1252?Q?fZl8jVtg0WxA0gCUa0qBiWA2B8BEyNEimk6vFFWxoqmjKPDb2pTL5Ypq?=
 =?Windows-1252?Q?Kt2L4u7SbHwh+EqJRT10gRVt/KOHmi2JrlqfkOX1mMpKJ6WPfqgaiUZA?=
 =?Windows-1252?Q?68ciNXMKDaYhnVqzTLgxC5f4zevE/mBGJMr8pHOK/GmaO4BCJ+h3cbUp?=
 =?Windows-1252?Q?+Q1v1iJWp2j6r6uX02gfreuKmCJ0YkOy7OTkpE/E07ttduqMsGDFYFaQ?=
 =?Windows-1252?Q?5mCrGY9XwxZAk/QbYQe8dQl9yf38q+Bbdvt52TbuKT6opnfy/hlCjk8e?=
 =?Windows-1252?Q?xQ70GQPWe42H2fY9xJBcicoH9LjG6yFeHhmkTnUiNQ+M4eel9qiZsh9J?=
 =?Windows-1252?Q?DUFmbMmh2sUq3oP7ljJbSdu+V0sBUr/m0Jjc0gu2E/D2aig77kUpHd9F?=
 =?Windows-1252?Q?sxcJ1NXi4L7T4B1d7klJiZUftH6uMdCBJNRPPXthkY9+kvmlE7Hkmh6c?=
 =?Windows-1252?Q?6mn7fCCkMaHwWGecocA54DBUCj3HC3YPtP+/iO3gcNPx24RRyNy6PLq5?=
 =?Windows-1252?Q?tyCGh1xzhJr/OEigq8lvWsFbRX6PITLjoRT/MgROxJh1WIQpeEDBUg9R?=
 =?Windows-1252?Q?iYX78fXjgWZVx0x4iJiOcmQKPTn9CTmfh+tnvjd7u4njWBqjmfxFA+em?=
 =?Windows-1252?Q?9mjVjDcJ48pH5njF+pCkXzglYNrm2TSIH1GI2PKUUSXof2++LYQL5xZW?=
 =?Windows-1252?Q?IzKN2c37HC+B09h9sy1nHs3FMhzNsqegkT1k6M+7va1iSon4pjVz5yOs?=
 =?Windows-1252?Q?XJPD0r/giCfQjB205uYzhmXZA6bpL4ojHZnmaYx59mPiznXKl4HOGBNs?=
 =?Windows-1252?Q?5o+AL6ANPLWDdP40kbMlnqmCgrVi2d9xp9S6q4KYkSFednEIHnHwf3DE?=
 =?Windows-1252?Q?GrHh+uknFlekl2ZrSXG0XFr7n2oaJR2jdnZiPGJZ4q/3Z39WXalAP9ok?=
 =?Windows-1252?Q?aYANjROCZ2hr0c5mTHQ7o6ZGcn2kbAZBGjNkwsX3BeL4SEipERwpQD3Z?=
 =?Windows-1252?Q?VZvILqWNDQ1OLCBgvDSLT2b0sF+M5HQ922dkPq92bOpGsmaYgDkKSqcA?=
 =?Windows-1252?Q?Mif2pi7waqCi9Rwkt4RV8idkWup2/fWi2M5ZeB2EfJ4wESFvSmoWEBDL?=
 =?Windows-1252?Q?Piu3/jP9T8u+1AkksF2EAGcVb48bGvajWrRvkvxhYNAheTzf1mOGeOpO?=
 =?Windows-1252?Q?vToMSp+8DkuFiKwHDdBeaxhHZp/aj/jT58QUqc+/A//U8QeJrpd+Dmj7?=
 =?Windows-1252?Q?qS5cmJ/b3tbeRfKAMuRVdka4PdvtzABYN4bSppMDWnQFsU+k62rKreqd?=
 =?Windows-1252?Q?cU3lhJwyDmcwlnMeAkO+Qt9yCllAgFdop8jARSd4CEbjIyzhOIh9DtlM?=
 =?Windows-1252?Q?4BLTV5V65X+NgOCJwz9Kh8sXofVtKkKSU8eZCFDKJxx8AHJCPgfKs5XU?=
 =?Windows-1252?Q?vx7eTMP6c5k2JR4mfK2Je0/9RKV2U9mtWdRAupSVn5aC9aqLjTKDq0HZ?=
 =?Windows-1252?Q?+Y+gh5NB3onB9YZS9YmNXMwEwsmkBCU4s5xRRmvySi8h3Nj1n+yJrRpz?=
 =?Windows-1252?Q?uAx1Tt2eZQ+sgFu64lXaFI4cvU0JJ+5M+2c=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <E0C14C7514D47047A1E2E48B74EF6782@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86b1e63e-540f-4010-0162-08da28393090
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2022 10:32:11.7462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QPnmfhH5UsxLDWcUkZslIXHR07CLMxqFcnoACxZ4PIDlxd+zeZeHCOBbzm1j/RrMnGbxriNQdhCyskF1QJJxEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9490
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 10:38:18AM +0200, Hans Schultz wrote:
> > But we surely wouldn't pass _all_ parameters of port_fdb_add through
> > some giant struct args_of_port_fdb_add, would we?  Not ds, port, db,
> > just what is naturally grouped together as an FDB entry: addr, vid,
> > maybe your new static/dynamic thing.
> >
> > If we group the addr and vid in port_fdb_add into a structure that
> > represents an FDB entry, what do we do about those in port_fdb_del?
> > Group those as well, maybe for consistency?
>=20
> I think the 'old' interface that several other functions use should have
> one struct... e.g. port, addr and vid. But somehow it would be good to
> have something more dynamic. There could be two layer of structs, but
> generally i think that for these op functions now in relation to fdb
> should only have structs as parameters in a logical way that is
> expandable and thus future oriented.

As a disadvantage to your proposal, such a change would not only modify
the port_fdb_add prototype of these functions once again, but it would
also modify the way in which they *access* their arguments (instead of
accessing "addr" they now need to access "fdb->addr" for example).

You can argue that this would be the change to end all changes, but what
if we then need to add more unrelated arguments to port_fdb_add, like an
"extack". You still need to modify the prototypes for all drivers again.
I think it's a non-goal, you may disagree.

> Something else to consider is what do switchcore drivers that don't use
> 'include/net/dsa.h' do and why?

They tend to copy-paste bad coding patterns from each other. The
SWITCHDEV_FDB_ADD_TO_DEVICE and SWITCHDEV_FDB_DEL_TO_DEVICE handlers are
quite a big mess, but that's a story for another time.

Otherwise, generally speaking, they have access from the atomic notifier
to the struct switchdev_notifier_fdb_info *fdb_info, then they allocate
a work item on a private work queue, copy the stuff from this notifier
object that they find relevant, and use that private structure from the
deferred context.

DSA does basically the same thing, except for the fact that the hardware
access is abstracted behind an indirect call to port_fdb_add().

> > Restated: do we want to treat the "static/dynamic" info as a property o=
f
> > an FDB entry (i.e. a member of the structure), or as the way in which a
> > certain FDB entry can be added to hardware (case in which it is relevan=
t
> > only to _add and to _dump)?  After all, an FDB entry for {addr, vid}
> > learned statically, and another FDB entry for the same {addr, vid} but
> > learned dynamically, are fundamentally the same object.
>=20
> I cannot answer for the workings of all switchcores, but for my sake I
> use a debug tool to show the age of a dynamic entry in the ATU, so I
> don't think that it has much relevance outside of that.
>=20
> > And if we don't go with a big struct args_of_port_fdb_add (which would
> > be silly if we did), who guarantees that the argument list of port_fdb_=
add
> > won't grow in the future anyway? Like in the example I just gave above,
> > where "static/dynamic" doesn't fully appear to group naturally with
> > "addr" and "vid", and would probably still be a separate boolean,
> > rendering the whole point moot.
> >
> > And even grouping only those last 2 together is maybe debatable due to
> > practical reasons - where do we declare this small structure? We have a
> > struct switchdev_notifier_fdb_info with some more stuff that we
> > deliberately do not want to expose, and {addr, vid} are all that remain=
.
> >
> > Although maybe there are benefits to having a small {addr, vid} structu=
re
> > defined somewhere publicly, too, and referenced consistently by driver
> > code. Like for example to avoid bad patterns from proliferating.
> > Currently we have "const unsigned char *addr, u16 vid", so on a 64 bit
> > machine, this is a pointer plus an unsigned short, 10 bytes, padded up
> > by the compiler, maybe to 16. But the Ethernet addresses are 6 bytes,
> > those are shorter than the pointer itself, so on a 64-bit machine,
> > having "unsigned char addr[ETH_ALEN], u16 vid" makes a lot more space,
> > saves some real memory.
>=20
> I see that there is definitions for 64bit mac addresses out there, which
> might also be needed to be supported at some point?

I don't know about 64-bit MAC addresses, do you have more information?

> > Anyway, I'm side tracking. If you want to make changes, propose a
> > patch, but come up with a more real argument than "reducing churn"
> > (while effectively producing churn).
>=20
> Unfortunately I don't have the time to make such a patch suggestion for
> some time to come as I also have other patch sets coming up, and I
> should study a bit what your patch set with the dsa_db is about also, so
> maybe I must just add the bool to port_fdb_add() for now.

Yeah, I should update the DSA documentation with clear info about that,
it's just the commit messages for now.

> > To give you a counter example, phylink_mac_config() used to have the
> > opposite problem, the arguments were all neatly packed into a struct
> > phylink_link_state, but as the kerneldocs from include/linux/phylink.h
> > put it, not all members of that structure were guaranteed to contain
> > valid values. So there were bugs due to people not realizing this, and
> > consequently, phylink_mac_link_up() took the opposite approach, of
> > explicitly passing all known parameters of the resolved link state as
> > individual arguments. Now there are 10 arguments to that function, but
> > somehow at least this appears to have worked better, in the sense that
> > there isn't an explanatory note saying what's valid and what isn't.
>=20
> Yes, I can see the danger of it, but something like phylink is also
> different as it is more hardware related, which has a slower development
> cycle than feature/protocol stuff.

My advice is just add what you need to add. The prototype changes for
port_fdb_add took place in:

2022-02-25 c26933639b54 ("net: dsa: request drivers to perform FDB isolatio=
n")
2017-08-06 1b6dd556c304 ("net: dsa: Remove prepare phase for FDB")
2017-08-06 6c2c1dcb185f ("net: dsa: Change DSA slave FDB API to be switchde=
v independent")
2016-04-06 8497aa618dd6 ("net: dsa: make the FDB add function return void")
2015-10-08 1f36faf26943 ("net: dsa: push prepare phase in port_fdb_add")
2015-08-10 2a778e1b5899 ("net: dsa: change FDB routines prototypes")
2015-08-06 55045ddded0f ("net: dsa: add support for switchdev FDB objects")
2015-03-26 339d82626d22 ("net: dsa: Add basic framework to support ndo_fdb =
functions")

As you can see, those aren't a lot of changes. I'm happy to see new
development in this area, but there was a long period of stability,
which is likely to continue.

Also, if you study the phylink code, you'll notice that it does't have
"a slower development cycle", quite the contrary, it is even aggressively
converting drivers to make use of new API, and marking unconverted drivers
as deprecated/legacy.=
