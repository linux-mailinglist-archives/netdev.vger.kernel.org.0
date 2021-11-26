Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC4245F33E
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237250AbhKZSAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 13:00:12 -0500
Received: from mail-eopbgr150082.outbound.protection.outlook.com ([40.107.15.82]:61825
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229703AbhKZR6L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:58:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i6Un5fdV+xiHeJxQ0fA6+14Pmb8en7hsNru1jCzrj68zmv06/eQ60NzODDKzspYs+gIE74fDRAQD01OJ3mqmtaGRTXi0s5IrGYZB1hInB4pJRJOA9+V8HCTHFtmQMi8VVqmkbumsUEn+chdnuAkBiev7D6pRo5uvOHt0u4Ns7RzvMIczeIRYmiIZl3wiC7MJf53oNbg4tQ9i8FniOBPa4LoeztnfD3Xcc11q7dqzUf0EBRy/8KZc4ac02s29TKnhRDLkC0Cw6wIiKxjlFGnEctRqx8T57BcOpYondkRsJLcTlV5kHhiYy/d7oOZipI9DaPDFANRdV1cTND7KzoLdCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zXl7hfjZH7O9ri665pLpIc7LNdXLQQ38WCf2TVyZ2VY=;
 b=f7RUJ22kTEApI9BvFrQPajnsZj7ETwrk+WDQnNm7sLMZ3+NnBUkbgBDQJS/dtpRvEtSNQy1i1btREoyIgCSMBwl8fMTLE6HSc3MAOGm5wqObAYHRdnBL9xu91lH+Js8RT1LRzSqgxMM3f1Q+ySz256EUbNEdvKFnnT7Q9BRHnCHUB4QzGO6FuNQc9N8Zk8cC2GaE/VQ1rPydk+OyH27d7EPTXtilLHRMEYxr/igfp6tUM5TqVnjOM0g6OCHwBrD+fMDzNnxjIh/lUeVSBdfGrqWHDWN0UUDt5t3rnlcSd94tEWpR86eofctbAj6Rop8g/Tl1FfTfrc5jRfiijkJKDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zXl7hfjZH7O9ri665pLpIc7LNdXLQQ38WCf2TVyZ2VY=;
 b=TJzyMGX1AlTgbJmNa9mGnaXivWC8pNlxMRU+hZfs1QuCvTl2W4IGpEHSwQgbAUvqTwWBZV//6tZyDQwrJSb8ptZR3rpK8dmmTnbdrAMsNPYsbcywwQxYuG1fYxks23EpZ4DoOPAAmmLVLrM9tE0SsatdukkGe4VDoDM8KFPw/Lo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Fri, 26 Nov
 2021 17:54:55 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:54:55 +0000
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
Subject: Re: [PATCH net-next v3 3/4] net: ocelot: pre-compute injection frame
 header content
Thread-Topic: [PATCH net-next v3 3/4] net: ocelot: pre-compute injection frame
 header content
Thread-Index: AQHX4urzVknAwsBStk6zM4b4mUP8MawWF5kA
Date:   Fri, 26 Nov 2021 17:54:55 +0000
Message-ID: <20211126175454.7md7bauojqlt7kvw@skbuf>
References: <20211126172739.329098-1-clement.leger@bootlin.com>
 <20211126172739.329098-4-clement.leger@bootlin.com>
In-Reply-To: <20211126172739.329098-4-clement.leger@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 23b6749f-8963-4071-0c85-08d9b105dafe
x-ms-traffictypediagnostic: VI1PR04MB4816:
x-microsoft-antispam-prvs: <VI1PR04MB481605AC87A06C0967C4F3B7E0639@VI1PR04MB4816.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Iq5NQCara9qcTf14FOt0x9QnniuX7HKXMl+wtlVo3fPzgqrCj+Ok0Hv6qZ41DgO6jmVy6mv4cAGtZPeBwvaqjITAax0AXWan56UpWF88Dq7KK1JIjEyoi9O4eV3ML8IPWvnxa8dkzoRzovYZNId49rEY/wOqyh5uXEZeA1WKMOegJd+vTGWkoxvrCImc5h4Wxe44Xf4j2CyhBhNXX0n9WGX/jEAvTpQoxvYfWWG8dea+JTz8aJWEVYnv3pjhqCsVF8+Pvv6wWMhDaL7bcd3xlTNSwqB6dGTWWMDDr/X5/aODvoSImI9eTO9xOl+HlbRFj9ArCWoSkbUNso0VI7QxL5QQPvLYaLlitYRz6KdarbumrCaw0tgxVYWxBQOYC+t6X6WsyT/p/k0AEQNPVCQw4R3wBsiXcoiFPqfSwEq2cI3nb1kbD4PzBGXAowlWQh74b06QI9/q0pUGRbvOLwXuG0HSR+l7JDKG3GPKd7wBLTMVYSGUW0+K4pcncM6gBphwgLhAcrA0EpxrXucRS/OW6De8BLADXeZVyIYSlFkt7+PSxQ9jGOWLNMvdn7cvpk3p4D81ZTgWOLZrLraiymxHniA2uoNtvCQp4TQvaKzEDTs0rlncxpOebgneQmBNCtQkvQ9fdBGe6esEmfkEoXvWeo+2/3LVE8keKtBvj5m3AunydAGwECWjmqarlNO77r0QyeshkHP69RbJKvmyszGq8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(86362001)(66574015)(6486002)(6506007)(76116006)(91956017)(66946007)(66476007)(64756008)(66556008)(316002)(66446008)(38100700002)(5660300002)(122000001)(8676002)(33716001)(1076003)(38070700005)(8936002)(2906002)(186003)(26005)(6512007)(54906003)(7416002)(44832011)(9686003)(71200400001)(6916009)(508600001)(4326008)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?I80yShKGo9ursyf4leODnqzXvdUsNrV2efWhkORb3EmduOhnHOtsQXPYK0?=
 =?iso-8859-1?Q?fTIn1fzbbeb0De1g+sF3+sNa2+GxFPmfgtglp8nqmdDLTaYym7K6Q8Sy+a?=
 =?iso-8859-1?Q?Tzwd0OinjmzAJ7PgOMvGdNNWW5+q1RpCvFfJNPofjL8XMFG7S4JPyrykcX?=
 =?iso-8859-1?Q?ZU+tXeONhEZKYD7lc/0QjUQgRe8qTSQOM1WYMySZ05+YCytGr8vDceGP5i?=
 =?iso-8859-1?Q?7xxlUj6Gw/wr9Yh/UNmirODPF06OD5bv/qUoGjr4vJvVvs+H/w3za+FKms?=
 =?iso-8859-1?Q?/PkvjSSXTZq9VtxFciMvi5KFCiHfdQWqw3WxhRVCSyX/bk/F/nMFwBKSED?=
 =?iso-8859-1?Q?8nfJS1Asc8EbuaypBVAY+DGk3hUWTWek1oennmDtdbngA382KsUrNRscd9?=
 =?iso-8859-1?Q?CvqY1YvL/SflzGQwZ0XRGVNenkgGZUiqhIabVDQGFqX8O/JXRkUOX51u3s?=
 =?iso-8859-1?Q?nCwEfT8aIgiYXSlA//MVhQEWdfSCv21X3JTa5girAbU6XXq3fFLIL0LFBw?=
 =?iso-8859-1?Q?ha1a51CfHk+uyZF6IS4TQim1xiNMWffomXoDmGajR9XFldhbLit0oH2i5V?=
 =?iso-8859-1?Q?h/LK3FFOAlQP6aFSpha1JCmFdftGzWZtT96ESkftrtSbOktl0/AZsBlDQD?=
 =?iso-8859-1?Q?RLnfV4KaMuVwdxvkY9k2aAejf6GPjwlnW8cvdTG8HQ1f/8Hkhak07/5xLi?=
 =?iso-8859-1?Q?1s59WG4rSznjbWFwZEvuo4IBzWP4UkoCSnfHSoSo5iRg7mf4xqPPsqp4ir?=
 =?iso-8859-1?Q?sJrKG3QPbf3bGYC4+T4JlOm2rfDy0wp4DDMDbWMh6xeWHRSPwcvvSG2pbY?=
 =?iso-8859-1?Q?poDTE90hV1GwF8RaO4rxEKmnC6VLAJEAlAu0XQ7o2TggPrcKGzUwwp/A7m?=
 =?iso-8859-1?Q?DsGKNhDy5CCJIyizvrwnSsTOhKZpoE1tV4aSREBW49zAYa/mi1i6hnO7Ai?=
 =?iso-8859-1?Q?M2fypaU7UofrE6pMq/OsWthyyuSh+WN5455cVewxMk2YBFe81n/qWqtQdA?=
 =?iso-8859-1?Q?+6cO4xAH1sbdfdvn64du+iP6ZSES52FMTeOUxgizTaZd5z6VXPARUmlb0u?=
 =?iso-8859-1?Q?St27b1NTBL5OXEbsrEgAaGXhXKv0fk94EH/T5BORTr6CZ3pn/hcqXxaRhI?=
 =?iso-8859-1?Q?UWWBIPiov3j/sn5vY0hmaKW43TbySXdItAZGb+Xjr5qpleR+b00j6Jc9pw?=
 =?iso-8859-1?Q?o/1Pdm/LaiV/em0o54B87fNW9/4Pw6aqw4fEblAtvZDnbFeGlrt22sBEio?=
 =?iso-8859-1?Q?nCaJYpCtC28PbJdR51Bu76HZSG77ZQN63tP370l2iz99I010RWhs7OWN5T?=
 =?iso-8859-1?Q?3B5SKqYYgyydeEHNyz060NDvjEIyEczLF5+beVLZ2pmhzt/QHFpIJQ+toX?=
 =?iso-8859-1?Q?sqMdp3IaTyoidol6aSabYDNBeyR4/hA5xfxCwmIRm7yoNyx4322rFJAI/q?=
 =?iso-8859-1?Q?XKJS5AiIuGp4o8rUk0PwUAOr1bm9xdNhYP15pTSoTdPRiVr9sI7NQsK+kY?=
 =?iso-8859-1?Q?7Scxm69MIx8jWC5n4OhWKLhtCGaCCNIleB2VHOHwwkGf2DVgCOedidHJ4i?=
 =?iso-8859-1?Q?EFtZpk0u9D1tAE7iQIY0Oo5R7BEoH1bn7CL3WtssqpuvZi/EzezSX842vi?=
 =?iso-8859-1?Q?B+JlPdI0J/RacfNGCTvdtRyPIsRp4uLE1zJz8Qll9hOlviJ8b1tTwQ6yCA?=
 =?iso-8859-1?Q?AewY8Pbp6NgYdFRQjA4=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F7C5557F8C6AAA4195C5E620A0621FFA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23b6749f-8963-4071-0c85-08d9b105dafe
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 17:54:55.6011
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TGf7fLYCxp3JP2TV0851rlPmb2KtYC6hnNVlUeiII2zxGjzR4UjsGpYC14H3b4Hk8L1w/+eQBf/s7pbchTuaoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 06:27:38PM +0100, Cl=E9ment L=E9ger wrote:
> IFH preparation can take quite some time on slow processors (up to 5% in
> a iperf3 test for instance). In order to reduce the cost of this
> preparation, pre-compute IFH since most of the parameters are fixed per
> port. Only rew_op and vlan tag will be set when sending if different
> than 0. This allows to remove entirely the calls to packing() with basic
> usage. In the same time, export this function that will be used by FDMA.
>=20
> Signed-off-by: Cl=E9ment L=E9ger <clement.leger@bootlin.com>
> ---

If you would move this injection frame header template into struct
ocelot_port_private instead of struct ocelot_port, I would not have
anything against it. Because struct ocelot_port is common with DSA,
whereas struct ocelot_port_private isn't.

Also, as things stand, all switch drivers call ocelot_init_port, but not
all supported switches have the same IFH format. See seville_xmit() ->
seville_ifh_set_dest(). So even though DSA does not use this for
anything, it wouldn't even contain valid information even if it wanted
to. So maybe you can move this initialization to some place isolated to
vsc7514.=
