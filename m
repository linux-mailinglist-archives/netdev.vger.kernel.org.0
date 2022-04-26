Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C4510C85
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 01:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356031AbiDZXVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 19:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356023AbiDZXVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 19:21:09 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2086.outbound.protection.outlook.com [40.107.21.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06EA27FE1
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 16:17:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8qSnmHWeFawdbhxij1ifELyub7cbwqusY4CdudXC2KTlq49wtN7/VxZ+ka8yYk0dZwLWmapufpNLcJ9YA1FjI6zhRekzPBdz+BevK9rZMuTXOElcRbpsMWHkrd26jHhovHvIPr+hpHWKI2isQXq47yFiWHO+TRQSOiU1Kvyyx7IIrkURNMa9Ppx50/Dp97Ir8MU47ObIjBKMZA3FotIIoRv+cFNP1VF3GpPAr4D4vgJws6Ght0a9LJD/44NQG2Nugg0sR3ofCbC3McfMjPKDLC0vfxmvcI3KlCAagcixpuSo9nLSuDg9BMkVRW2AYB6A/WhD3XEbvQTSDTWmo6PNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZGmYeW6Y5733rDrQtHQnlTqlTHi/ff58ByaBLWEcUS4=;
 b=nqRR/2kiuNuwttSntCizgo8xt66bjsuzAoKB5fYxzBZ4RSdxYfyy8cttPOESTz8CyqIfbjyg3J/0OnJRBNW3bAt8B3EZnXg9cPWRulYbFD34OpQ6GSJzavP/Aqxx4FRgUWUQTpJysf8S4LEw+ce4SFiyAmhKW6cXZKp8wcjPdDQyBsqoaK5rDx5Kff/nApze8UJDKLrFivs0ZYfLgzfLKJQ4YTx4mRWUzRAfjboHV3ZdPDkqJKUfVUeOYvMWZPSSiXjbBLLGRMuxxodJawYRQmkfgJZXbgHKLlK9cjwd42YkJnR3kmTVtar2RS4+SUtjkQ2hmQFSbweO6NEq0d5Tdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZGmYeW6Y5733rDrQtHQnlTqlTHi/ff58ByaBLWEcUS4=;
 b=pT+Sn6C9N3X6fVpV9ac2idhtrq65sB0hdimivNbifJpEreziJGyhykhGgsW2Jk117DfqtzdH2B1fdmMaMbahYQaT3IOEOngBGylUpqBI2qaFsJr/R8wnhHNJMS/WgGsEsgICSwnH3XcyOdM8s626Bd9PbgCGjeWUsj77u8cHIQY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4108.eurprd04.prod.outlook.com (2603:10a6:5:21::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Tue, 26 Apr
 2022 23:17:57 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.031; Tue, 26 Apr 2022
 23:17:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Hans Schultz <schultz.hans@gmail.com>,
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
Thread-Index: AQHYKilM1SMl98R0uUaOWdZX65QhHa0CqMaAgAAUSYCAAHZWgA==
Date:   Tue, 26 Apr 2022 23:17:56 +0000
Message-ID: <20220426231755.7yhvabefzbyiaj4o@skbuf>
References: <20220225092225.594851-1-vladimir.oltean@nxp.com>
 <20220225092225.594851-8-vladimir.oltean@nxp.com> <867d7bga78.fsf@gmail.com>
 <YmgaX4On/2j3lJf/@lunn.ch>
In-Reply-To: <YmgaX4On/2j3lJf/@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43097ad5-3316-4d99-35e0-08da27daff7c
x-ms-traffictypediagnostic: DB7PR04MB4108:EE_
x-microsoft-antispam-prvs: <DB7PR04MB41083F724D0DE82848E8C081E0FB9@DB7PR04MB4108.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +QmEWPAnT1EtfB0P5Q/PCAUnAJHvKmUp3jNE39qwA5NSN2P308pddUSClVjzr4TfQ1IBlDNXnebJrKqZjG366mADocW19IVCuRPD1ByO6wMJ3xOcCRyRVGYW7VGQbWktgDKTFEXysNt1pwpWmoi0s15nxiCAuIltjb7kGhBZLVFLX47m4WfgPdWJvYOb/W89AF5PJ/zT6Iob1Vdnq6ubpjci2yvBH1KPy1zuwOxrGhKyMgvNZ6bs26dbeV2EyTf9a1Pz2LJWVwN8v/mxAGEPABaOtEG5YvFosOYzq9X5MrHssaV+94eWBjWkNf+bMQXapTWgOi76DxavrmeSle7CTgFb36V0LLsyMQSic7neTBVlyx6isg1BEXXtzU6wNnvS6532/u0Vxn4k4nYltiJ1tZc+FiGMFiMjLkFpyqJJj/Hj2Hs5vn+byd785DPP7qhknnv1c2PaeK4YDSpKF7G5Gvij2qC4EJX7D9wzaxFKS+/OxMQ6E+qKIzRiFWrxxpg+Iz96g8jd+aO9eMG3T6WyfLBZ8s3wZ3OByIbFAumM2MqaYjcYwxm5pMVEsXrAl4J5fM7ON4Z9xY39jwd7n4K3Bit9hc+BmN62lKgT9qHS2phCnESlKDgrBSrKqRctNTmxZw6XWNvYN5JYJVPmLjXoYh28xgZrubX+15f9mExEDulwyCrDwcszV77YCti3Rh0RsCKFvIdEoYQEqT4A+nm08Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(44832011)(8936002)(7416002)(4326008)(83380400001)(6916009)(66946007)(8676002)(2906002)(6486002)(86362001)(316002)(508600001)(122000001)(38070700005)(38100700002)(5660300002)(64756008)(66556008)(66446008)(66476007)(1076003)(186003)(54906003)(66574015)(76116006)(71200400001)(91956017)(26005)(6506007)(33716001)(9686003)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?FOpBcy9HOBbNZ4v77fWGiZBGH4u4/Tt/kVGPgU0ttBwyj2Q2+HWJx286?=
 =?Windows-1252?Q?uuh57tXpxdKw/csFTaU2GaTJZxkSAvjHf1qbsZ32CELq4N5Cfxm+jg1p?=
 =?Windows-1252?Q?XdudX4hFKa2J2ITu78/PdKKOPKy/TXp9BZ19uv01bOjwyGgAlJoP9NjX?=
 =?Windows-1252?Q?RqUGVT+kp0BYq+Fwmxe2wVl4yyuqETPigiPWTwVYUa9bqpmOmHKzlkio?=
 =?Windows-1252?Q?6QWxKlg3hTUYEZ77sGMsAq3SEzkiXp9znWxnwl4Pz/c0GozfuoMsTFGU?=
 =?Windows-1252?Q?AiuQD8gDf+flqFP2i3+HDCdA2PR//zg9Jxuzncu3JXaxCRDDM57Gb9DH?=
 =?Windows-1252?Q?YL179D4YAhcTMKw6O30akBeVJFXQzR8EhEUvxaLrPujAW0ecA2CQkURp?=
 =?Windows-1252?Q?PU/PFEHUJ651tkhhSy69iUPchDWdwIp7ppFe1Pk/gxBfSsYV1zMcU5Ju?=
 =?Windows-1252?Q?Ym1e6Fj91V/0vro569gRj+K0Bycip7QQeq2FF/ni2X1oLk6RSxcBeAhn?=
 =?Windows-1252?Q?91dm8MB58cNfq6KiCuyNJ0WkTFAY6l/Y3LH12Bqx0oLlqYXVzCyAtTGO?=
 =?Windows-1252?Q?cTg2UazOOzK1eOergTwmP5kjalnQR+Wy2q3w3RW8J9Uyw3z75mo9bWHW?=
 =?Windows-1252?Q?CJP/HuCrSHXFuQRGWcY54GprpEjaQEr8yKFamLcDLIzjstqztF1cFXYn?=
 =?Windows-1252?Q?iAHBZnfO1hXGBiKpNrksI3coL7TGQnuKRpoCKenaAdO/97oBt4EZN559?=
 =?Windows-1252?Q?fIVP83OBzZOkmgWdtWdei+LV9yyqhW6owMU54mLS1G43NdZDAoJJVpg8?=
 =?Windows-1252?Q?trF0fiqJSCbmaaH/qEig0QT8hZPgL8GyPxmABsD0w3UBzF5jHnvlM+T7?=
 =?Windows-1252?Q?9HeANdMYScapMOqUebzhbhndlOVohOINiHUtAA9uXN89eycyxlLrz2JW?=
 =?Windows-1252?Q?jlybgSlfLsRewqhrYNgFNobOX7a8X3c6jEDf81ME6CbnDD/TUuEX9CF6?=
 =?Windows-1252?Q?8FHCiPHXYy6sDZtbPF/EhD1y2ix0pfXoyvZJYFzCLDbPKPur1pfYTRgr?=
 =?Windows-1252?Q?m8F9XpruvSc3wYHuj55R/jKM0j8+Yix3rjQTcjIDOGG9+RTGMUSXcGYG?=
 =?Windows-1252?Q?x9rub4AgbMNOCj8EK5KsR1eR6yvzuuhttcn9kqFTA2xe+T9p/fF0DFV0?=
 =?Windows-1252?Q?nN9ZNeAHdUVkNrAydgbsngpoMn3iaF6gtKvRmN0hlGMxcDTm985BAACz?=
 =?Windows-1252?Q?pmp0CKStJB0DQAxgrOF/zVDvRu/N68RggsrOLDmWEYJtr4o29mOFpHiS?=
 =?Windows-1252?Q?LhcFqnjZ7ILvIeBmMmjwo20lduSAfNckvMq03vKBBUlpn/Iflf0uMRNM?=
 =?Windows-1252?Q?d4BVbvtjkHRdBT6Wz4+tC1sai2nhtMX0rn6vt5aaPIivMmUnEgrpE9Ww?=
 =?Windows-1252?Q?Pbos5pdxVZu2/H7RKD1u6Q+h3PpEi6+Ln7cgNgYoDmOLxDQ6DtZuoLk+?=
 =?Windows-1252?Q?qGr1EHua25oSXMbAW2wSrZcQWd/R0OPa3nn1i7BOK3uSH4ikMnzrsdsb?=
 =?Windows-1252?Q?aKVuDMHMfIZY1Hqme5VkwEHa/FWbpWcnBnZbzCfxPFAEZJ5t//DPKGwQ?=
 =?Windows-1252?Q?NTuYNwJA06pWvQegpsYY07qTvNF41IaVM6BpuAWDrt/jYpWjo3nZACp6?=
 =?Windows-1252?Q?gTQGatYV6u6xLZXMlRSYWBggI698JryqJbvbtU7XtL43fB7T6R+Hhb27?=
 =?Windows-1252?Q?ZWB1qw58k9mDLdKi+oO1RcoAz/wz7ZedsRZHmCT8I3UcVgDHOKsGvq4W?=
 =?Windows-1252?Q?f7tew6iHa51xo4aHrVRABkyarsHNyvd4QLMdtv69HHyQyCMV13e2RZ7x?=
 =?Windows-1252?Q?dy0xvjYIImGNmzKSR1/HtKMVyNb3HswU3g8=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <CC9C180BB931544F9DCEA72F8F4AE3FE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43097ad5-3316-4d99-35e0-08da27daff7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 23:17:56.7155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mgBMzG+ZDOXC7kOjyIs+tn+k+NewecwiTdW7SqRIz/+0LZJBYSmK9hr0Y19B8r6zp692IT5BuJSXidykuCbNCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 06:14:23PM +0200, Andrew Lunn wrote:
> > > @@ -941,23 +965,29 @@ struct dsa_switch_ops {
> > >  	 * Forwarding database
> > >  	 */
> > >  	int	(*port_fdb_add)(struct dsa_switch *ds, int port,
> > > -				const unsigned char *addr, u16 vid);
> > > +				const unsigned char *addr, u16 vid,
> > > +				struct dsa_db db);
> >=20
> > Hi! Wouldn't it be better to have a struct that has all the functions
> > parameters in one instead of adding further parameters to these
> > functions?
> >=20
> > I am asking because I am also needing to add a parameter to
> > port_fdb_add(), and it would be more future oriented to have a single
> > function parameter as a struct, so that it is easier to add parameters
> > to these functions without hav=EDng to change the prototype of the
> > function every time.
>=20
> Hi Hans
>=20
> Please trim the text to only what is relevant when replying. It is
> easy to miss comments when having to Page Down, Page Down, Page down,
> to find comments.
>=20
>    Andrew

Agreed, had to scroll too much.

Hans, what extra argument do you want to add to port_fdb_add?
A static/dynamic, I suppose, similar to what exists in port_fdb_dump?

But we surely wouldn't pass _all_ parameters of port_fdb_add through
some giant struct args_of_port_fdb_add, would we?  Not ds, port, db,
just what is naturally grouped together as an FDB entry: addr, vid,
maybe your new static/dynamic thing.

If we group the addr and vid in port_fdb_add into a structure that
represents an FDB entry, what do we do about those in port_fdb_del?
Group those as well, maybe for consistency?

Same question for port_fdb_dump and its dsa_fdb_dump_cb_t: would you
change it for uniformity, or would you keep it the way it is to reduce
the churn? I mean it's a perfectly viable candidate for argument
grouping, but your stated goal _is_ to reduce churn.

But if we add the static/dynamic boolean to this structure, does it make
sense on deletion? And if it doesn't, why have we changed the prototype
of port_fdb_del to include it?

Restated: do we want to treat the "static/dynamic" info as a property of
an FDB entry (i.e. a member of the structure), or as the way in which a
certain FDB entry can be added to hardware (case in which it is relevant
only to _add and to _dump)?  After all, an FDB entry for {addr, vid}
learned statically, and another FDB entry for the same {addr, vid} but
learned dynamically, are fundamentally the same object.

And if we don't go with a big struct args_of_port_fdb_add (which would
be silly if we did), who guarantees that the argument list of port_fdb_add
won't grow in the future anyway? Like in the example I just gave above,
where "static/dynamic" doesn't fully appear to group naturally with
"addr" and "vid", and would probably still be a separate boolean,
rendering the whole point moot.

And even grouping only those last 2 together is maybe debatable due to
practical reasons - where do we declare this small structure? We have a
struct switchdev_notifier_fdb_info with some more stuff that we
deliberately do not want to expose, and {addr, vid} are all that remain.

Although maybe there are benefits to having a small {addr, vid} structure
defined somewhere publicly, too, and referenced consistently by driver
code. Like for example to avoid bad patterns from proliferating.
Currently we have "const unsigned char *addr, u16 vid", so on a 64 bit
machine, this is a pointer plus an unsigned short, 10 bytes, padded up
by the compiler, maybe to 16. But the Ethernet addresses are 6 bytes,
those are shorter than the pointer itself, so on a 64-bit machine,
having "unsigned char addr[ETH_ALEN], u16 vid" makes a lot more space,
saves some real memory.

Anyway, I'm side tracking. If you want to make changes, propose a
patch, but come up with a more real argument than "reducing churn"
(while effectively producing churn).

To give you a counter example, phylink_mac_config() used to have the
opposite problem, the arguments were all neatly packed into a struct
phylink_link_state, but as the kerneldocs from include/linux/phylink.h
put it, not all members of that structure were guaranteed to contain
valid values. So there were bugs due to people not realizing this, and
consequently, phylink_mac_link_up() took the opposite approach, of
explicitly passing all known parameters of the resolved link state as
individual arguments. Now there are 10 arguments to that function, but
somehow at least this appears to have worked better, in the sense that
there isn't an explanatory note saying what's valid and what isn't.=
