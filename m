Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A75E56867B
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 13:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiGFLMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 07:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGFLMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 07:12:45 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30052.outbound.protection.outlook.com [40.107.3.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9078527CEF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 04:12:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZMlyAnQF5dUkY0lBcbvhWY9qY+z7w9shO5sNFAxXMmjIGWzvs6F90AWZRbg372S2j/AUxZMsmyaiTShw2YM4sRInyhUUTdeDtzgvjTKOCL4282smu2B/eOwT9+yKNGkYV3l//zMgS8pjNr7Ld9BaV5z+C+GLE/InF4US5UvGVlYs5WY7Z//M0It6fNl3u6iQ9Ej8y/erlHy56YkcdYvSWpMGVuIEh4v4xtmUO5gzcoP5idTKj/Prc4bhwQA4a3fPbP2DmzNZkAJAv7JkngxP4lUSKXby929rkhHB+92ilodB6yF++bL/igi4HHpLLHSVueiKqiu/CoO5qrVCeHfzrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jsQQJFdVEr8TAxyz5L+bicAwizWK5FChH08cbeECGY4=;
 b=iXBoSSBvqUokg69Q1jcG3VjqxyGUVfnp7wfzgYLDIUmFKpHsEhBpkhWkXa59z8bLbtcK2YX7zO62yHhFTxMARndDkzmUcCvui3VItFMMBDrIC2LQpD+JAV3k9HigE/mzQES4pd+ynNs+dV81hmNjiX3xBRPAMbdDAUGUZtGUOERLVn5SAFeEqtnYQomiuKxbDhfA5qTjDPjeKxnPrbUA2D/MrVNdIqyR45j4wDsrL5r8R22eTr0juLm8G7MNCh6VXczE3OcL1h3AuLwQddXtXUmQ5TK5g0Anv0bF7jaIwvv/rzRdORLl6Mijo7yohQd+TD62njZX/HaDyMnmTzJmzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsQQJFdVEr8TAxyz5L+bicAwizWK5FChH08cbeECGY4=;
 b=DFlJIGSxbeNazO7boTp8MZcwZKQ/pE0PCvrPBMJUp1Iwuotxzcgc7Yurb835pTgBpftq7LoCDOksriDxRhT8CY3hzcyDD4qmabrdin9PvIclKtxZQsws/NBFlkhCcWDVaXNugeQFGP7ZusQgnmMUxbf3Cw9V8VoYN9lcC1ugQX0=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB6609.eurprd04.prod.outlook.com (2603:10a6:208:16c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Wed, 6 Jul
 2022 11:12:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 11:12:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Arun.Ramadoss@microchip.com" <Arun.Ramadoss@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "linux@rempel-privat.de" <linux@rempel-privat.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hauke@hauke-m.de" <hauke@hauke-m.de>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>,
        "Woojung.Huh@microchip.com" <Woojung.Huh@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJUlP4ikIJ+Lb0SIV36lnP8Hwa1xK40AgAAF5IA=
Date:   Wed, 6 Jul 2022 11:12:40 +0000
Message-ID: <20220706111239.n6sjggkebyrsu6x3@skbuf>
References: <20220705173114.2004386-1-vladimir.oltean@nxp.com>
 <20220705173114.2004386-4-vladimir.oltean@nxp.com>
 <e681971641d53b830a7aeafb9e88a3ac059915c5.camel@microchip.com>
In-Reply-To: <e681971641d53b830a7aeafb9e88a3ac059915c5.camel@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5a390f43-5ac7-43f6-749c-08da5f407149
x-ms-traffictypediagnostic: AM0PR04MB6609:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MGhRs6B4bDdzdbT2+UOgVKDXxUBFTKaA9uLzjvNmEN61+hKuqt4UmqQzFDHaYSzr59emf+UjdhCtGyAs3pBMykt9EO2nHH0mTrF43LBPODcXbFRIF5Xbcn2onkBo2ZnFbAz02EHnoK2Kp9t67oFMB6nQqhxTh6zvrS0/tydPZw6HFyKGQr7kN5AHMK6qEew8e4xbPRTZD8xMO05AYXJMKsS0yY4yHw9Gz2DHd7p9UxrdJsBoWkRQzAu5U1tMohm5aNZf15J0wnpL2HOQUIAGU95D6Junw1fFGHncb2fGoVnxpNdHwY8Dmv6VeZD/jaung0gkpuYPDqhvW8Meg4Xlib3TatTJIV9inYRzB/YEnLmf8rogR9k/FZfULi5DyXrwhxsxGwPlFhfvNk28rKrPVZp0hBQT0Nn1iScmJnd1UqXkP962j1wLGFfqDtsMBQOlzGf1Bflbpiy246VmaIhoUSrlOdpC3cUV4wnEIlQwZIIBIQqciKshTQYxKtDkYnVsnloFhkne9SKUjTxFgOlpMD2FVHAeBlMeDsrqbJ4tGZ88O3wYc7ccR3LpqPFC3RYd6lXzX8Edc9lvv85/pMvnLJLrp1YdLXo1j2SR/T5vd1IPv7qDfbGmJr4JLUGQwLekv512vlsIhFmINbJx9MHZjSH0b02DDi4AA3lVzqtjzaHBz2vDxVcgV1sWqQMSjfLAhe5Sv/R/y/tO1X9efkUGI2cOX2zXmFwAG4depHUkTkOTz9r3rjM8Ko3G58cQKre28pjgZp8R3RLw+OVGmpscKUx4GLyuVJhIqN0azL4RUpASvQIMCg7SwQ/L7Gguj7vK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(39860400002)(396003)(136003)(346002)(376002)(41300700001)(38070700005)(122000001)(1076003)(5660300002)(44832011)(6512007)(26005)(9686003)(6506007)(71200400001)(8936002)(478600001)(66476007)(7416002)(186003)(83380400001)(2906002)(91956017)(86362001)(38100700002)(6916009)(66556008)(54906003)(8676002)(33716001)(64756008)(66446008)(316002)(4326008)(66946007)(6486002)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kpvNsPD7Ks9G0RKbcG7hzEs5zwHiw17NTXWGRmwf4+DIAjleGkQEvDyj8luA?=
 =?us-ascii?Q?NV3HuVgSINNCCRmNMUg1KQsuJk3QbinJm8tiBSrWycyUjMP+ugW6Osm29aBG?=
 =?us-ascii?Q?MslXln+ci0+/0DIdgxLa3hYTGvBh+VJ/XFdaxpu0y1FDj8XADmNMObj7jFn0?=
 =?us-ascii?Q?MDt/Hzmf3vi5nw3JV0vYhujX3MM6METY9uNFwKUPShtxPfHNWo3kuql+Zlu4?=
 =?us-ascii?Q?+PKQ15vHB3j2XLjcSOyn8LLduddDmNTxit/FgOpyzJxqcUS0DnkmKamvcWtf?=
 =?us-ascii?Q?97wjwTc0lNRLKl7mMtB+KaMvwEmzQap0p+0W6S4xMQnKc0bC2noVr7GiIRNe?=
 =?us-ascii?Q?SerXOwn19VMTkvjIaK46zGMlgH6Z40xOmKOofEf3aLPcdGbfBFeS/8PMjN4M?=
 =?us-ascii?Q?Ftt+NUiuwS+Q7eaBlHD/D07+aktemZ3oNHqrBpU/Kj/X84o/Vp0L6kLeD4JS?=
 =?us-ascii?Q?0T1sBFyRBGPQ5mwvNfG+Pm0gbuTjUZYS9LEUAeKnia/DO2xZ+npn/BUzV2CK?=
 =?us-ascii?Q?KI0lRv7aispS8e0QXDCqgGWI++E0KgngmCQfS+UGKG78EWD78CrT8WxnNj8e?=
 =?us-ascii?Q?QZt3pLKMTtv5hBg/ymDdA4NXfTzEVh+dx2pmnhU7hGYudu/XnB7rUznWNcnv?=
 =?us-ascii?Q?r6+rEgSukMszdwwkRi8UIb2fiBe3m+0VRi27cVs5dqDmRBgkvRU0hD3aqxy1?=
 =?us-ascii?Q?EYiJB6gCtlF7UdisaQk1E/zDwpKX6o28cNVa4hUE/XUqPy6+79d9LTTc0Fdc?=
 =?us-ascii?Q?ZVI7JzfhD0+6+UMAuqhLGH2U/PF35gRq1S6jy3XcNR8/jIaNiUFVrhNK/v1V?=
 =?us-ascii?Q?q2637eXQVvmvcK2aoKSJo+pP6UlcKlAAwJP9vyeiM4IN2UpPLNZN7j4VvLLD?=
 =?us-ascii?Q?Qyc3vMTgOtwX2GZ7ilgvGZ4ExksXBnBs2J3gHCmH5K1V2U3CuWZBfbbaEzjb?=
 =?us-ascii?Q?uye5GikBeS8QmPLwLO1JCMs2JrwtpSDnYDciVOvVfioNiwYCK/7GqsK98rIw?=
 =?us-ascii?Q?ow/1cpx3icyGS0UNG6dy3y2LpugFIrvgUEKxSAqw3r3YMVHiZwTFZdYNh7aQ?=
 =?us-ascii?Q?cJaJ4goyA5IpehxQGosKEjkgF3Yj3931aljFAi6yFmDkTlCp3IqWMjJMZ6SX?=
 =?us-ascii?Q?iTZ5a+lQL5LASMa+ILJxsqB+5K8AmGnswzmQT116obBynPNsvT4FmeRF/oOj?=
 =?us-ascii?Q?NmG/K/KbelekkUjkx/94cy5C4CSNZMFY8d08KCVvZvky9wNVrodnk65A2TCd?=
 =?us-ascii?Q?IoidcrCMprFu9rcr8Uopt81Kpw20da/MJE6sFUKNgakp4iXu8xnjxGXTCvwJ?=
 =?us-ascii?Q?l0Bx1K+cvatNM328XdD/o9ARxVPUU0DTeztv92CFRgC28/bFRSCohirgBfHU?=
 =?us-ascii?Q?3puL0ua1e11RCIyfJMcMBhSIUG27dPIkAK311xb034maomUN1/nxSaSPaHw+?=
 =?us-ascii?Q?EMv3/2mN++yDHgnbBMc+9m20AZuWvM1Ena1ew3OxGQZs52oTYPXa2IcDfiIL?=
 =?us-ascii?Q?Ummt8iwiPaKF5t8D2j/BfOTdBjKm4CNciILgqXF4xgbbrYRjVkppszbNBs6F?=
 =?us-ascii?Q?orI4q6WbEpEUQFa4qXBFOLeoVuAtv3JsP8S+FOTc42nOF0aYUG+lsYYWValQ?=
 =?us-ascii?Q?5A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C4F0969431C7944182BD46F360BBC356@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a390f43-5ac7-43f6-749c-08da5f407149
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2022 11:12:40.9062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9YEMOZlevJVDUrQKXkKWdNIGgnxTdyQPKFJZ25nyWHoJKezghDZCeD0qPnlt6EGWuC44J3CTSRJewYaltSWUAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6609
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Wed, Jul 06, 2022 at 10:51:34AM +0000, Arun.Ramadoss@microchip.com wrote=
:
> Hi Vladimir,
>=20
> On Tue, 2022-07-05 at 20:31 +0300, Vladimir Oltean wrote:
> > - For ksz9477, REG_PORT_DEFAULT_VID seems to be only modified by the
> >   bridge VLAN add/del handlers, so there is no logic to update it on
> >   VLAN awareness change. I don't know exactly how the switch behaves
> >   after ksz9477_port_vlan_filtering() is called with "false".
> >   If packets are classified to the REG_PORT_DEFAULT_VID, then it is
> >   broken. Similar thing can be said for KSZ8.
>=20
> When ksz9477_port_vlan_filtering is set to false, then it clears the
> 802.1Q vlan enable bit in the switch. So the packets are not classified
> based on vlan tag. Only if the vlan bit is set, packets are classified
> based on pvid.

So bit 7 of the global Switch Lookup Engine Control 0 Register says:

802.1Q VLAN Enable
This is the master enable for VLAN forwarding and filtering. Note that the
VLAN Table must be set up before VLAN mode is enabled.
1 =3D VLAN mode enabled
0 =3D VLAN mode disabled

I'm not completely clear, personally, from the chosen wording.

More interesting is the definition for the Port Control 1 Register,
where it says

Port VLAN Membership
Each bit corresponds to a device port. This feature does not utilize VLAN
tags or the VLAN Table, and is unrelated to tag-based VLAN functions. Also
refer to bit 1 in the Queue Management Control 0 Register.
Bit 0 is for port 1
Bit 1 is for port 2, etc.
1 =3D Frames may be forwarded to the corresponding port
0 =3D Frames are blocked from being forwarded to corresponding port

So you may be right, if the VLAN mode is disabled, the packet is
forwarded within the "port VLAN". It would be good to check,
nonetheless.

> > In any case, see commit 8b6836d82470 ("net: dsa: mv88e6xxx: keep the
> > pvid at 0 when VLAN-unaware") for an example of how to deal with the
> > problem, and test pvid_change() in
> > tools/testing/selftests/drivers/net/dsa/bridge_vlan_unaware.sh for
> > how
> > to check whether the driver behaves correctly. I don't have the
> > hardware
> > to test any changes.
>=20
> I can test it and report the observation. But I haven't run the
> selftests before. I looked in the scripts today, but couldn't find out
> how to compile it as part of kernel and program it to the target &
> test. I infer that, this scripts should be run on target (I have
> SAMA5D3 + KSZ9477) with 4 switch ports. Can you guide me on testing
> this.

To be honest I've no idea how to run the kselftests "correctly" either,
I just rsync -avr tools/testing/selftests/ root@<board-ip>:selftests/,
then install the packages I need (running the selftest usually shows
what those are), then run the test itself:

$ cd selftests/drivers/net/dsa/ocelot
$ ./bridge_vlan_unaware.sh lan1 lan2 lan3 lan4

The topology for most of these selftests is pretty standard. There are 2
host interfaces $h1 and $h2 (the first and the last one), and 2 switch
interfaces $swp1 and $swp2 (the middle 2). There is supposed to be a
loopback cable between $h1 and $swp1, and a cable between $swp2 and $h2.
The $h1 and $h2 can be any physical Ethernet interfaces, $swp1 and $swp2
need to be switchdev.=
