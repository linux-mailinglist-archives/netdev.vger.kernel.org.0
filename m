Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72255531ED8
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 00:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiEWWva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 18:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231754AbiEWWv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 18:51:29 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150073.outbound.protection.outlook.com [40.107.15.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F48010FCA
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 15:51:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhNkXDy7R3IwqXJi+1tGhhdZy5LqHCLKsiUbP19y6tGPGmCsGl6ZkZWwLrLlQAiL/LCN6hnTlsKCKIMhNZvaqBfsUVs7O5MES368wJK3bhV8Y0vJyLziMHilNiKxC8LbzL0f05q/OnatOU21cjAYRf9+SmUwsG8IDT8TYR5K3KjezzeA3vJqPIf5HwsUyuJ0cA+redL/t1///9KdLV/YJy+6L1nCdkxITklleNlCAzQLuqY03koLlrb60VKI4quTPb3tesAAlLXYYFP8M5lRAZsS//jPaEDDwoFkI4h5CrkoTTjVaPE/tamUKdSCEuap29cRiqaKJA3SQR0WeAYayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9pJ+0wFr6GPrIo6F8adq1RjH5dKoNngxIQwBl1V98PY=;
 b=avY7vWCcUAbWxkImdPlR4W0Vy7hC2SQouuhuEqMSWmNrw+DGEaN6WmQcA2UyDjsmZgOU1lTeCQiWDuk6v1thd1oMuxfDXRAlA8N5BbAbmtPlQtnka5UYopEKszHQ++8yboRIEgT9qdb1ttn2Y0E0OK8mjwi1e172HcuT7vVyeU1yQW4cQcPQCc5+c4/MjGeMGoDol1lthcW1ZC0l2G2DtFKP6moi86GaayI3p13Eok79XphYsDoEJFTGNbkPxPOHYxm2a3Tqtc5zExgfmoi/lNI3gYsijOrWcPMOrWQLuUwtoEayGdxcZmV3oPqbpX4Ixf/a1rfFnqmnZfHHw03nOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9pJ+0wFr6GPrIo6F8adq1RjH5dKoNngxIQwBl1V98PY=;
 b=oIe88BQV21aHP0+y57gSbF+4PTR7i/eGYAjK8+XikgtoNVjtpyV7V0UezDqj7VylnM8JKxWHATKt/XCgU7IQDUnqCkQs//NrX9kSaKzPvUvPbqF1tl1BDTewHZyBfvHyMcXxPeiAnKFaU+aAxzDrETd3COUeF6thBf+aw0I18zs=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7528.eurprd04.prod.outlook.com (2603:10a6:20b:297::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Mon, 23 May
 2022 22:51:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 22:51:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
Thread-Topic: [RFC PATCH net-next 00/12] DSA changes for multiple CPU ports
 (part 3)
Thread-Index: AQHYbpHhcTgY7maLhUesX4/147l5la0tAdyAgAAQPwA=
Date:   Mon, 23 May 2022 22:51:23 +0000
Message-ID: <20220523225122.fvghlj5b7e6z2nxr@skbuf>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <3d6a78b5-1570-5c6d-8f81-465fc2c9c9a8@gmail.com>
In-Reply-To: <3d6a78b5-1570-5c6d-8f81-465fc2c9c9a8@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e067b9ce-c2da-4969-9916-08da3d0ec308
x-ms-traffictypediagnostic: AS8PR04MB7528:EE_
x-microsoft-antispam-prvs: <AS8PR04MB7528F135B8FCAC520F1870ECE0D49@AS8PR04MB7528.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z6at+v4giN1sbBSNWVwKoB9k7s2tpyGXpx0Yk0V1ebSCTEG0b1A4mMfS4eji6mZ7P8oDcacyfK/AwaH0gw86BFMyiStPoemxsjwbTR4kHwvp3y2XZnqzP76I5wNdXwKcwGxxKtDiFGQPf4zXw0VzZGRhk2BxbvN4AlhuT+Rb71dBxIfMDBjJdDvp9HdjaVWKQwSOeUs/jqQr3yCG2ZpciHR3IucyvvExvtBI3hJJL7M+0S2BiKAs4tDXUk81bP21x0oIxwdMVG3wttzws2hiLkD6B0igb8sWj7IhZCDzqlfo8OVAtjEMVu5HK34R3Y4IHeQBE6NisYotNRr0zzone42gTybzjiaizpKGKRBr4YCKN/eTfbP8AX9vOav1kFmUP1bcExgTm+1inMxpWspo/N+rakLXDh9fVP2pXpCrWkZeMNcN8j8+3K/blnbwrJutS/DJDllEqCkygR4iy7/g5RPvYAL3Y48fMzIhqfbYj0IVNxiJB0RLv5NViNvswax9YLXtd/ZzrrXv3mZHWey6Bz3ohx404SpWemY56saR4CzZV/jPXKkug89GyC4jrzAsx/mCjocS0fq6xi34PuDnhgWvodRr8b7QIr9FEJUhLJCPgJnUKTQdszzjteLFVYVV2Y20lX+rbSgIJNpJgk8kynxPVeoD1N9mh6i4XpVngGytdaIUAzjJIx4jyX549wdnPSbL2utAlMZm2g4xPloT0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38070700005)(122000001)(76116006)(8676002)(54906003)(6916009)(38100700002)(91956017)(86362001)(2906002)(316002)(33716001)(71200400001)(4326008)(9686003)(26005)(66476007)(66556008)(64756008)(66446008)(6512007)(6506007)(6486002)(66946007)(5660300002)(8936002)(508600001)(7416002)(186003)(1076003)(4744005)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?2IlQXCejR7NLK6h8vn+BP2SevIdfwJ+TbvZGufd2pMe22Htur031D/dx?=
 =?Windows-1252?Q?gX6DGdNQOkX40lyqbA1sRfgqUGXqOw5yTETe1SOYjFzNjXUg6mKS85WT?=
 =?Windows-1252?Q?oYVCqsANc9HKhJcBAQW/L9RHY1uxZ7l3qpwf2vyW2xegAuclQNxrxLC/?=
 =?Windows-1252?Q?Uv/aiJxryDXnAqy8Wwd4kKmEpggn/IR3hqCIS4JrMeonbKA6V6bqgClD?=
 =?Windows-1252?Q?5T1iI9cwDZTZWCq6cRokqJnAIf0pxcG3E5wh8HRXJeNUfB429E3ph6SX?=
 =?Windows-1252?Q?dfIg5UV/cS+ObFRhFSwilbgCwa2apbyZTwnn5PBdd0uHKQiTwwVrfhNF?=
 =?Windows-1252?Q?HYU1lcHSd/Gq6ZuVnBRGG+WDP5ezkbvAxaCHNJcngh82Xnaf1Q1JGZ8j?=
 =?Windows-1252?Q?b2OXQrD/fSPOCgmrguIUPRuIT3t2FOHt8mBSJwBoa1hQAyi0C73jHty3?=
 =?Windows-1252?Q?U6T6+MDWAkzAy1Lyk/FlLadBmYtrykDpHQ1fNOOfmJnY+6P4LDs0ptTG?=
 =?Windows-1252?Q?5H2zo1LXDDPbqNlIEcsU7GFS93PUCtX5bV2aPnYc45BjE1xCPdqvVtoI?=
 =?Windows-1252?Q?fX/CQ5PkzZ/TQ5AxNFxswkrRf3DYmYZjYLcj+Gt9Nh9LX8oE3S3qH+2M?=
 =?Windows-1252?Q?nXXEFgrgNqlPevauufYJvlTgXqIzlQI13PfNOMcdR4P7H+sFNj03CFeS?=
 =?Windows-1252?Q?AFalXf7f6VFdUKvDPX4TvLyTq25oo0RUfNpkqbYf2ekmD1LTgD37TgCn?=
 =?Windows-1252?Q?bB53kuydEbruGZqVBbTK6BXQphR2p/9fszaG2e/6QrfwB405qUxeN6VD?=
 =?Windows-1252?Q?lRXw6o+HLf31XSq1ewMkocrR44bbErTI9fWLOfujpvbpBMJ85w9wey3a?=
 =?Windows-1252?Q?tQJbp752TPbx4eb9+d6A5ZqpeMQhA/EZ5p/9hZ1gNV5g7mJLln3vmvIT?=
 =?Windows-1252?Q?qFTJwLL8SBpGm/atZ1uEZKWrqwgecOmbwxhvXZYExxtPCE8veKv3HA9A?=
 =?Windows-1252?Q?NiYj+mm0X/TdISD7U484E5u3TCTKGPw8iWJTGpJunwlPYdvegNr+FNUa?=
 =?Windows-1252?Q?VlBT0welhNKxtxk9i1JLh1sPLEjVznkbVyKHXFaWWAGqpRaZn7hfsF/u?=
 =?Windows-1252?Q?J6C7lVVReyikLdW0pzsgBhbn+Q/gDqx0HObxEuU/JFkdJob6orP3GdIO?=
 =?Windows-1252?Q?iq9kMrXcitDLClA5B5cH0DNIpzdYKIWykQQSIzYzsI5E7RdmZB662SVV?=
 =?Windows-1252?Q?t0x5AdwMLhLAgMl0vBZlx40creAU4wLDwcomaiNUY4BvhVrpHSaJGvLk?=
 =?Windows-1252?Q?CE7uh9mOSD8a0Ajya67hOY38/r8C+Bp5M+qOFWD9iv3lvmWtHn74SIVy?=
 =?Windows-1252?Q?TMAu34loYqmBuKKtyW+DrguX070EbvmDe6jc9xJnV/JZ8UrLCD70/mxe?=
 =?Windows-1252?Q?Zh4VZXHLBsUS+xJKHMPrN8cR+h9QCGK6dQvAyPDp6KS8SDsR7phkMrOB?=
 =?Windows-1252?Q?cbgp6kQptjyDvipbzEVwHGGzdKvQDK5cnq3OCLIuxXhBlmJy7hZ6aQQv?=
 =?Windows-1252?Q?GNu0Tlavy/4LiCRtvHBoWQIVqdSxP99dvB7TcrF4pwkROxrFt3fQOI2N?=
 =?Windows-1252?Q?H8IqumuzzYz9z1Iv+L3mB4KUxcgGDxMcRU6d3Tp4K9xfTY3TRgpQlgwv?=
 =?Windows-1252?Q?5LLAkNcW9D2jirrcNPSmxSiaZebjXbAisK6vsOYKpncivphbJW5C52n+?=
 =?Windows-1252?Q?1IIeEHM/Gr6GqwbREfapjSsdwwqU8yRfIdtFsNTdogxp9Y6QEObeLyND?=
 =?Windows-1252?Q?ueBr+wfKCvbycot+bCstPykYh52g7mJ3OipdGzZlAtcauzHdkpbKJQSz?=
 =?Windows-1252?Q?9ehh1baAGtATvV/k0d5fO/ffzsK+O0XPxUs=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <944EB755375AE7458BC8FDCB7218BC87@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e067b9ce-c2da-4969-9916-08da3d0ec308
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 22:51:23.6834
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kxuH5xttkEY/Tin69JSP17HfQEwqJtmxFwr37JDReOESU5plB9MOx6fxl7CEtPjh/OzmW82Bm2SmnQZG43D6EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7528
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 02:53:13PM -0700, Florian Fainelli wrote:
> This looks pretty good to me and did not blow up with bcm_sf2 not
> implementing port_change_master, so far so good.

Well, what did you expect? :)

Do you want the iproute2 patch as well, do you intend to add support for
multiple CPU ports on Starfighter?=
