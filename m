Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB5D551079A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 20:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352986AbiDZS4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 14:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242681AbiDZS4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 14:56:07 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60059.outbound.protection.outlook.com [40.107.6.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87296155705;
        Tue, 26 Apr 2022 11:52:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrAT1E2Ij8aIO2jgHU9LvTHo/jJOHtM9CIRNhBexUsfo1zYuktCmXhTNJDUY4Djx0pPybht2q+94kGXmsSxh8godDubTshPUl9h03PEkdJIeUPHTd4eHgrH1RA6b0cmYiyKja+k9IUvbqZfRktkJ/z4ktXSlzjnfTUZI80OK3Rywz/OjF+Iw1H3w4R7s6jzGKPgVH0lIaYbzh7F9pvQrUmNqrCJ10xb6J/LtcK47SOmtpcojO9H/GQ2unQSJXApuwII8LGeANdh2nqvA+Hi7jrpO+/wr39m6ir01sdhaW7KPTpLOE/UhW2TZ6eRCFUoXk2/5PDOid45o7+o9tHUhZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cm1m75CmUPqWdLDnTw0mB6cxZ14uU1rajRzy+OHfU9A=;
 b=YQIieeeCrA7jZB2qhgR2AWq3aKvpszulI8viB87U1aOPGwGTin24KqXBLcLTe4O+jiD3aJ8xy+xS6tPVK/2XmX+EYuyXuaUOJ1sB6rGKDK5Yerss0itl6zzMXABiLXtkyx9nAddu0kjAwNZK5UCILXaC0PkWFCuV5hwWNZrpC1cJc0jrVLXohNX0P15Fj5qJ53gCF3ITdEN5nxt+/h17Wp5SxOLItjQUlQRW+KNWn60RZbr/iepEflf0cU3wSWgMm2iF/EtZmChI5qDpeSOJNcS3HqTcVJLfyTjBOlipqUm8D4qVaoWQ9XaLsegOUHIIATsnNZG8npmuwmGm6+ptww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cm1m75CmUPqWdLDnTw0mB6cxZ14uU1rajRzy+OHfU9A=;
 b=Dk8swRra+GYFuwtxwJQp82+TzHJIgZvwLQm5BCJKoFJH6fXL4k6jlIWC5LEZyg6K8xVQQT97+mf+Z20t7jmWr0xDlggttQYSMIpOtfoyihOdw9Q/WrFGV19X8YekFT7oTMsxFY6OtiLCLSGCd5gDMiMCGJswTkGv/3v7o3w0EWE=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21; Tue, 26 Apr
 2022 18:52:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::8ed:49e7:d2e7:c55e%3]) with mapi id 15.20.5164.031; Tue, 26 Apr 2022
 18:52:54 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next 2/5] net: dsa: add out-of-band tagging protocol
Thread-Topic: [PATCH net-next 2/5] net: dsa: add out-of-band tagging protocol
Thread-Index: AQHYVnM+RQlQO9gSFE+zv5gsBtvmv6z8QKEAgAX9ngCAAFKFgA==
Date:   Tue, 26 Apr 2022 18:52:54 +0000
Message-ID: <20220426185253.jiqfljymrwvyfteo@skbuf>
References: <20220422180305.301882-1-maxime.chevallier@bootlin.com>
 <20220422180305.301882-3-maxime.chevallier@bootlin.com>
 <68c4710d-013e-85e0-154d-413f4e13b27e@gmail.com>
 <20220426155732.223e0446@pc-19.home>
In-Reply-To: <20220426155732.223e0446@pc-19.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6b4486c-a566-44cd-f5c1-08da27b5f92f
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_
x-microsoft-antispam-prvs: <PAXPR04MB91850A890D1074F95057F838E0FB9@PAXPR04MB9185.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uY8Y9h+ZkEqwysnIbAm2S99a4QzxJlLaHc2t6u4xRQ3I+vYMTSuKAO1sKsCSdWrdaeU8zA45fsipYIQDBIZAxBh2rjUPGkP+KN9zucg/XVYwRqELOU356F7jtrib+VA3jKJeZ6ThHLglMQp5nrdLn8aeCYBvkhw6NwVRkeN7JzClijmG9+2X0y00GnVEdhYCbqs1+IxQh3y2veWUCtgazX0HIiSbHsLwcATj8FhBI+wzm1V4KqkKPm1YsLF5qonkEuHNCI3Lxr3Mu9n5c3HHDL3CR6UYbU20kn46aEKbwvc3sNOKZlFVlrTHmCVQvBZX97V00VwstRJsgEyJ5Snmpd5MXYH65nDtbB8Vw98n4xDHQifyvd6S2F2VTSO89jHs9P7q8KabsYSYQx7H7aYYfmmLePHs4A9mBt3UtEFlbhdPjrpY4vI9RW5FofJMmNER7Z7dlbcz7N+T8XH92sO85FrXRUwOvWNyTJqX3LbhSIazDC1Urhy7kKxPxvVjsPbe5DccLpuJ1krCWuMDYPE1uLNYoeftAAE4WjK7pKWigEXnDHpbCpEFQmX1+FtUovcW03Av/qjpb99FM6CqUSQyRnpfHDnObpxV35qqwqgpKXMHFPGad3J1Mecu3O5FyJo2mwNUgi4xpXYZbMQ2xacpE2JyZ4BOHx1Natoc59FSLgyJ6/1VmZ9I52Fb3ORHwkt1TQDCXE3lfVO75SBAxo2HAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(508600001)(33716001)(6486002)(4326008)(1076003)(186003)(26005)(54906003)(44832011)(91956017)(66946007)(83380400001)(76116006)(66446008)(66476007)(66556008)(64756008)(8676002)(38100700002)(9686003)(71200400001)(5660300002)(8936002)(38070700005)(7416002)(6916009)(2906002)(3716004)(122000001)(316002)(6506007)(86362001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rj2fPCJY+OwcKkiuR6lg6jf9tDLJzo64RQUgsgwjeK6Mp2sTM9RU/gCrNJ8z?=
 =?us-ascii?Q?rvYBLcpgT2zei49M6rGLOB7xL4tXqM/7z/7foxmjEzqRGeIoY1TccfsIX+kz?=
 =?us-ascii?Q?CTHjnbJy3dBGsg4su1fbU3HBxRfaiu6okhOpb4HV/fLhzlgBoM2xAkCkvPng?=
 =?us-ascii?Q?aN4a6rIRRGznUrTfvYO+19dDmruLAREdRai7W21FXM1a5y3FrlfeboTv+jlV?=
 =?us-ascii?Q?8+GGAxGaDczi+1PWIHVuKVaJCzxgV01zAz10e2DUaDg6UH6TuipEsKKCJ8nU?=
 =?us-ascii?Q?24X/3xnAG24DT9nXh3aQYogZ2QrKAyrgvInrFEM0RCoMiopAxSaNWG8LAfHp?=
 =?us-ascii?Q?EjTBqPMbfOQ5Hdwqek0fVuGZNTWJ8Jj6HMDQfOJGuwflSojSclwcfq3oIIrZ?=
 =?us-ascii?Q?INomkOJGm8xgRkgIlEnsr/vnTkh5DNd2vzs+WZyxcMBcrMQuFVHntNqEdloP?=
 =?us-ascii?Q?+LUWn7z9ApWJRDPSGjvNBU5zn/yd2O9Yb0LaWc3FdC8dzKZ2UhRiAjprzmhr?=
 =?us-ascii?Q?2Hc5NxUYVtRg+SpjUAbRTKEqfp0m5R/TewmvcVoMRz7c06KuSfkbBXkPjajC?=
 =?us-ascii?Q?7j6lagmpSZUwQ7ZQcbu4UejnZP+TUeroFoWXfI8xLqt0Rzf4Mxsnuny1cGR0?=
 =?us-ascii?Q?NFbcFLUGh2hyqs+Q/hiWuJzFeSSmZSehEIxNrwHqkiNTaFOj+lkZt9LqXdmA?=
 =?us-ascii?Q?S5H3g7wiWPvNAOjiyj0E57LweijCKAIDl5U3Fb0PT3kRze6fnvQAyBgiP/XX?=
 =?us-ascii?Q?tS8RvPMe2pl0TT3w7b3f/dvRRnTM8ZFL9fLcr3I8K4lxA3GupxaLpZMUOygt?=
 =?us-ascii?Q?zntMOnohEFKIHh1k8QzeZzaMGZMvptAg4sdVq7EgHJ/9TNj3v14bIUazDIfX?=
 =?us-ascii?Q?all1m424ch2dkyqA4xEyTvaqgc2XFZxFYHLPnZ7MUeJ46gQihGNLpjrdbmyJ?=
 =?us-ascii?Q?aWHeR1mXWFnIceyNiAx7QDR3LuQWV+HslNrVEJTUJ44+YyI4B51GOpdPm/QG?=
 =?us-ascii?Q?j/jrIryVxvOs3nvayLSMxl91dc4CZx1II5/Dl9D0RnVWjI4zYKyRbzxcGcSO?=
 =?us-ascii?Q?TBJiQM2jVz1EnQrHZpOhFB0ZrSjNFMItSCHn36z64AmqpExsgbVDtsplJj0l?=
 =?us-ascii?Q?22aL/bjolJgX/VlwGIkRnb3kRyveIPYf/hQJjRoUdlM17IC/NXlKBKjZRibX?=
 =?us-ascii?Q?VpOKUP8PBrp/SXbi3SK0TPCzhFL/+ncrGWing+EqNL0fr/s8g+cXSk3AuIB4?=
 =?us-ascii?Q?TlA9LXFbzCQXRiytTDEm1/XCqJ0Nb+Nwg7vjotDSvd3NmSRtXpHV7+EYX6BQ?=
 =?us-ascii?Q?HHcgVblWJMFZqyTl1rTa0uwDDs7i8x8ZVwcSKzHGgJrwDXIlAtYM0Iiv1r4e?=
 =?us-ascii?Q?t/lv+kcKBzGp94UQ2LxSJ67XN5l/bWJbg7MzOdtmbiMGcs2h0PHRCHbnmrpi?=
 =?us-ascii?Q?m6g0ncEW+/BW0msIGLufGkxDIUGWlfI0ULZaypkQGBEJsdFcOqUQmQFoQxx9?=
 =?us-ascii?Q?5ny0KVT7BKP48W/q9VQF60AbYNf7cBR13zXw4Dy3+qzn7Owe04sfXqzxW+DQ?=
 =?us-ascii?Q?hpWmhO7jpPnrMZbOie8NEtF9eRHzYevUewUq8AWjtHgsZstRF14gwK7kLh6S?=
 =?us-ascii?Q?7o7EofZJnAVQmIIgHgfRpHjJP2CPQ6MfWwrCrIHOYwv2a16uw5GZAXP24ucq?=
 =?us-ascii?Q?XcUA/l8qwkq3WRNC+/XF1gWCo5UXRW+43ibecilB4UpFeQL/dk5wkDjkf0XB?=
 =?us-ascii?Q?4QnAbbHPb5FOq20NJ/SOw6SegQHiLC8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D50C3449C63F824CB53D60F2D62D3542@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6b4486c-a566-44cd-f5c1-08da27b5f92f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2022 18:52:54.8486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y5J7dQENiscKKSsAySTUlwyd6P3kOaT/syVy8RoqB1Wegxz3M0jUzSI5OoJVto+luM54bT8qDr87zYvafJ73eA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9185
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

On Tue, Apr 26, 2022 at 03:57:32PM +0200, Maxime Chevallier wrote:
> > First off, I am not a big fan of expanding skb::shared_info because
> > it is sensitive to cache line sizes and is critical for performance
> > at much higher speeds, I would expect Eric and Jakub to not be
> > terribly happy about it.
>=20
> No problem, I'm testing with the skb->cb approach as you suggested and
> see how it goes.
>=20
> > The Broadcom systemport (bcmsysport.c) has a mode where it can
> > extract the Broadcom tag and put it in front of the actual packet
> > contents which appears to be very similar here. From there on, you
> > can have two strategies:
> >=20
> > - have the Ethernet controller mangle the packet contents such that
> > the QCA tag is located in front of the actual Ethernet frame and
> > create a new tagging protocol variant for QCA, similar to the
> > TAG_BRCM versus TAG_BRCM_PREPEND
> >=20
> > - provide the necessary information for the tagger to work using an
> > out of band mechanism, which is what you have done, in which case,
> > maybe you can use skb->cb[] instead of using skb::shared_info?
>=20
> One of the reason why I chose the second is to support possible future
> cases where another controller would face a similar situation, and also
> make use of the out-of-band tagger.
>=20
> I understand that it's not very elegant in the sense that this breaks
> the nice tagging model we have, but adding/removing data before the
> payload also seems convoluted to achieve the same thing :) It seems
> that this approach comes with a bit of an overhead since it implies
> mangling the skb a bit, but I've yet to test this myself.
>=20
> That's actually what I wanted your opinion on, it also seems like
> Andrew likes the idea of putting the tag ahead of the frame to stick
> with the actual model.
>=20
> I don't have strong feelings myself on the way of doing this, I'm
> looking for an approach that is efficient but yet easily maintainable.

The skb->cb is not free to use for passing data between the DSA master
and the switch driver. There's the qdisc layer on TX, GRO on RX, maybe
others, and these mangle that memory region. So that would make it a -1
for skb->cb, and a +1 from my side for making the DSA master driver push
a fake prepended header, and consuming it "as usual" from the DSA
tagging protocol driver. That, plus the hope that I'll be long dead by
the time we'd need to find a solution that scales to more switches
designed like this :)

I'll take a closer look at your patches a bit later too, probably not today=
,
don't wait for my feedback if you think you're otherwise ready to repost.=
