Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3A9585416
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 19:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238229AbiG2RBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238186AbiG2RBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 13:01:12 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60081.outbound.protection.outlook.com [40.107.6.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCD5114D
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 10:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JvzEUQbvw1FCNwlovQgCdcdOetfQ3g30dfz1oNcCIZtXiHrH79oCFIv08ZYRUbEfAv13h45Hg+Yd+2jpvOM/bPP47HYKUdab2vKCteaPyzfUUylSdcKUglrvUgWspfqKTAtp3lEual67pY9kXghcmr9u38D3h+MNYOO1wNYV0fpYnGgkpu9kfXIUcUtSHHVOny3A1mixINmQQIaq9XtpRbWp5bMkXTJLDVr/ELEH9f9xf5ZfeZH5LrbOslVErBQzXU08XSSoQ2a6rPMTUiiR/4Mz1CPlhCxnzUMzHR9rqyKB14fghmsJHSRr19OaiDEUlQP9YvpcT7mSw3ukFJsp+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bEzLqFR8XIRwgY2dFtp8WAokLzgJQ5/y+mjI9p+7qQ4=;
 b=Z/W9boL4/Nroh2U/BQL3Aezpqc26ful3/sj5HyovRcct081lSXc8SUNjkNuAqMzZ2ijdQyC7z5SwL8hFyK7drH9/JNDZgsqpB9maoG/K7b7CnrGOxuL7NnviLyeblf9zQzrW7dn0f4ndkdau3ScEAcy8/w7MBjsrKcpWbaDX59Yce8KMvt+RzQuo54eALiCZ8jLeF5T1ROd0W6vxU65dfxZ4B4qWJp/yF3V2bSinKZJQbsUu1jARiVsAORZ9dP5iit3IEFIjL8GPVgz+EtXRBLfiKCrTQwbof6l8JYofP9/bruT0WZOQN0BvY7gwHGYHnuCJ202VrvfBnfSVrgJPOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bEzLqFR8XIRwgY2dFtp8WAokLzgJQ5/y+mjI9p+7qQ4=;
 b=OfKodmoifyPUxf+uUT62Jnb9T3GVP1fgxJVb4aeMMmSP8kJSDO6j4YSRaXQvMbnVgJX6oclekmz5SfafuKCWrmddU/K0wpiwtXINJqlWMU2mVBTuWBrErOBxinByynCSSoL5apyuJvjY1+I7cV2iQw8xUNZ25ODw0psDmCrV7lY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8126.eurprd04.prod.outlook.com (2603:10a6:102:1bc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Fri, 29 Jul
 2022 17:01:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 17:01:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mans Rullgard <mans@mansr.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        =?Windows-1252?Q?Alvin_=8Aipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Dembicki <paweldembicki@gmail.com>,
        =?Windows-1252?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        =?Windows-1252?Q?Marek_Beh=FAn?= <kabel@kernel.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Frank Rowand <frowand.list@gmail.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Topic: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Index: AQHYo04nl4JHZbxuek2HktTJEcy9Ma2ViEaAgAAKtIA=
Date:   Fri, 29 Jul 2022 17:01:08 +0000
Message-ID: <20220729170107.h4ariyl5rvhcrhq3@skbuf>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com>
 <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
In-Reply-To: <CAL_JsqJJBDC9_RbJwUSs5Q-OjWJDSA=8GTXyfZ4LdYijB-AqqA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c2b7ff8-9983-4c17-ca08-08da7183eeca
x-ms-traffictypediagnostic: PAXPR04MB8126:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zQiTX4Xw6taSQ+0L4dLlE/j2/4hILC9lHaA1403YPMXHURBI2jjHNYST93Gm95035+4Hjn6GqWeMD2lX7Kb1NymaGN6FH0qoFeKos7Ortw62F+6WcZeDyoBqOe6fVC2yt2GuwgMvKbhkpYVzyufdY39qVredlWyADPf4h60BZAiVCYW+ueZSXy5NzcvJ8f2icofiMbpMHaHDYKOTW4uTN9tvy0b0FqOSpb5j2t2p6lup5Y3Ri6YwiLZABkfoPT/wlZgB7rLNDpR5bVFd5WcLOvyJV8s4T5tx1XXv/QQAR9jyzuFYchtks82w6IKwG29EdPQw10E5Yh64/UDaSvnrJQM6+Bfb2H0hWs2mtqOg1XmLo9d+Kd38ZUq1Ve8QFiCBZoySmYCCLd3Zxyzt0TKMRSFUVXCRKbmxNyEtawqJgS3UAuO1Wz+PM+I8IFaUhbM9ZK9t3JsrHm64NY7PHYBbGWktTT6+qgkddXVX8LzN9AGCte4cUfoiIwimT7HP9/1LFteRZXaVYb0HPTHw/Px5d/p8ZYMcZWc3Q6Mu2vhBs9v9HXVJSF01WbXVx7aZFKe0Mgjy2QkUpqfl7GRs1IwNZIhL6lxcbW1KF+T4Wu6tRJjpj6I6ILPs81tMPPa88yuM69ALCYCpfES1hEvw3t34YIrj/0DlA1SP8uQ6AC4rINLQKHglJXH05f3V+qtJhIyhDVRtQLA77/Fm023Lgv6jO4X5z/ItMoX+1J9e4aspIrXrybOmzWymEMgjZuemBUyA/eoXeuKQyKFng9dlqSb6vargp75IcoVzMMi6fHyEDpQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(8936002)(86362001)(186003)(54906003)(316002)(76116006)(5660300002)(7406005)(64756008)(71200400001)(7416002)(6486002)(478600001)(8676002)(66946007)(66556008)(66446008)(66476007)(91956017)(44832011)(4326008)(26005)(38070700005)(6512007)(9686003)(83380400001)(6506007)(41300700001)(2906002)(15650500001)(38100700002)(1076003)(122000001)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Ewm+q80BRJYSZvtpqK8O5Nl/CrU4qDziO7yhaL00R5I1danWG5OCP+ZP?=
 =?Windows-1252?Q?aorlK2D7UsBe2ivXAKMeTAuV4LwDr8iZ4SZCFpu5hNkOESjMMxLTZDse?=
 =?Windows-1252?Q?oNyBiTgpB74pQrqjaWCnr75QR+jh0M0q565TEHGaPrGuiMEHk4cZ4wOH?=
 =?Windows-1252?Q?62UEAlfOaiYnY3PGv0HQxvcfxCtmWBop2tLv4cLo4J+s2raC/dPjkxW6?=
 =?Windows-1252?Q?krO3YQNGADoSHzo+2U/pBYMIGUeQqR1qS2/Hgq2Ck7izbfTQoMkPJo6d?=
 =?Windows-1252?Q?8ofmQV/FIJahglEWsKSA0ulVUNPAWnQB4NrCtMM68wF12pfUFyYS/q5T?=
 =?Windows-1252?Q?CzXHo5uo47uZsU0EkjrGTuokqz3WsJG1v2C5Ib0YPM2iPL1O6XtwOQ2e?=
 =?Windows-1252?Q?35OzZgMCLdozASOxmUb0veRRk6xPvy4tcx6Zps0s8WMo0Vc19U6APvTn?=
 =?Windows-1252?Q?5CTiBRyTfF0AppZ5Sg0Dyu2G1baBq/qWu98BsPrD+4kMpvuXKr6/cA42?=
 =?Windows-1252?Q?k1TLDuxF8rX/AlV1u2TMJCmL3t/VpY/05EGg4VTnvw/8F6+WTnS1kL7y?=
 =?Windows-1252?Q?JrqHeYkMWejSQPhQS3uGaue1u5KmmOd3wOOupwVAVNp2m0beuQVvSVA0?=
 =?Windows-1252?Q?E7gypETHuOlHe4iVffXEHqbwPXkBLf8ppWa31IF/wIT8Y+QLbZMqYJGK?=
 =?Windows-1252?Q?sApCwp1cnaBlDkW1ArHEOxRlkdy6Mzeu5i11j6bohi7y0JCcp+K+tH9S?=
 =?Windows-1252?Q?xe+zOhrUStfYZGYSjwtwIpgHZv55ggWwfRyCt6fAhkl7Cp7kTkMAR8De?=
 =?Windows-1252?Q?bYqaqUqylXP7cwuBJD7zBN+GHYzp8mbpcsnhNI3cCZaCHwbR2NdSDPP3?=
 =?Windows-1252?Q?YYTYRyHyJf7WB+x7AbJTls/mWpYjAkbyUgoGvoKR0tJR3K56PBNlzC5S?=
 =?Windows-1252?Q?zariWRSCt3PtzvNXPd7gsgZ6H9yLjZe1lCNFFR5jYTWeYHAQNuZio2L6?=
 =?Windows-1252?Q?sN+iXWuEanFsu8OzW+vZ60oHJR79Zs3HyPxC3suViAYQwAQcLUDZmuEY?=
 =?Windows-1252?Q?yqpGfQ8Q86+ze+tjQB17qxT4vs5vU1DZdMSbjGEiMEYKY2207g2FWRJM?=
 =?Windows-1252?Q?+O53cLwoYnEFcw0yUqGEr4cr3D/BFkcvnOkZaM/qhE6cjbu9UeFuqOMO?=
 =?Windows-1252?Q?Sn+PHXBLlT3Zwg7oPYPdBGHDOmNhAyoIXAG7TV7fre8T6Cgy/MMPq0f+?=
 =?Windows-1252?Q?3Q5qVvQNpwtLX1w419VGlNeypOcq+aPBhTnEUwUBl+5Z68nB5WFWKHtb?=
 =?Windows-1252?Q?LH3YT0S8FTIAKae7Zo/qeOzVaGRP8WDwvlsVs0N9B3t+qjkiwF+ZAcwh?=
 =?Windows-1252?Q?eQLil6XYbP1iBuSA95gxk9u4IVbsWBAJ7QtHz9bAXkauEiCM1P8sl5/g?=
 =?Windows-1252?Q?hY+oyZ99f5XKvxKJCDCSUEttq75tzfxkdc4lrWC5Gh8KRRav/ll5nHpM?=
 =?Windows-1252?Q?26iFMRUvmzXHQqB3U8ZVIS2oF16J0tPLpJE4xlTVpPVQzHyA94lZqvEC?=
 =?Windows-1252?Q?va2OXQahljZ3SsERvlUxb1ahW4gcUcVRNo0Ab/GQVon7Nhq2Y5kM4Dsb?=
 =?Windows-1252?Q?MEgMNEhdxCCdX99Vx3rvqyaxzQYcxYjmOFq+A6GUUr8iTP6bgx/ww4vs?=
 =?Windows-1252?Q?vaFtNY0onr0rX+JMh5OJyI/hEoQvZuIk49st7f9Avdsu5USVdOWHrQ?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <08A63F185AD32045921EFA8272F5962B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2b7ff8-9983-4c17-ca08-08da7183eeca
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 17:01:08.6955
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: W4/FxBABy0yyL+xD65B9wFX0erBlYLJjIXrue51GnrSoJkGG55+eho4dnbKwBPC4KnT8wi5mTzXv6aTUA52PoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8126
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 10:22:49AM -0600, Rob Herring wrote:
> It's not the kernel's job to validate the DT. If it was, it does a
> horrible job.

I'm surprised by you saying this.

The situation is as follows: phylink parses the fwnode it's given, and
errors out if it can't find everything it needs. See phylink_parse_mode()
and phylink_parse_fixedlink(). This is a matter of fact - if you start
parsing stuff, you'll eventually need to treat the case where what
you're searching for isn't there, or isn't realistic.

DSA is a common framework used by multiple drivers, and it wasn't always
integrated with phylink. The DT nodes of some ports will lack what
phylink needs, but these ports don't really need phylink to work, it's
optional, they work without it too. However if we begin the process of
registering them with phylink and we let phylink fail, this process is
irreversible and the ports don't work anymore.

So what DSA currently does (even before this patch set) is it
pre-validates that phylink has what it needs, and skips phylink if it
doesn't. It's only that it doesn't name it this way, and it doesn't
print anything.

Being a common framework, new drivers opt into this behavior willy-nilly.
I am adding a table of compatible strings of old drivers where the
behavior is retained. For new drivers, we fail them in DSA rather than
in phylink, this is true. Maybe this is what you disagree with?
We do this as a matter of practicality - we already need to predetermine
whether phylink has a chance of working, and if we find something missing,
we know it won't. Seems illogical to let phylink go through the same
parsing again.

As for the lousy job, I can't contradict you...

> Is the schema providing this validation? If not, you need to add it.

No, it's not. I can also look into providing a patch that statically
validates this. But I'm afraid, with all due respect, that not many
people take the YAML validator too seriously? With the volume of output
it even throws, it would be even hard to detect something new, you'd
need to know to search for it. Most of the DSA drivers aren't even
converted to YAML, and it is precisely the biggest offenders that
aren't. And even if the schema says a property is required but the code
begs to differ, and a future DT blob gets to enter production based on
undocumented behavior, who's right?=
