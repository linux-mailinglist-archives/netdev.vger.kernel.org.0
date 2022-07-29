Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2D9585503
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 20:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbiG2Seu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 14:34:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238523AbiG2Set (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 14:34:49 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D99D04F693
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 11:34:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X9e0fA+F/zt/TNlZQIQ5djdHZqtmNVEwxQzsgnMpiR/lKDWgEKvrIlgPLpH0RqDNd3wgi0tbYmYJbHYJuKX/7GyOekyEXVvZnNffKbJNdaYt5MM1bbEXQ0PYm5JnxE35OsSVmVPgW2fxcxbYA7wyWUCszHwUFAuNQ5wh0QiQnUvp99UwyO+Yjyaef9noZPcGeukGrmENPV4Smlhrp0sJg5ujaZdlz8UZLKIodsA8rEasC2L89SaD2QTjliY7mbYkVU9coetgVqSIxj6lxaNRMCO1tPFy5n4CPbxIZpN5jT5/Kp5Ok2tYSu+hnJiciRhqcIXUkifLYQXAErPvPNXFbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3fhoGTyqdY754iob5s00wes9MyvgOJTT77eG6ekVmIA=;
 b=f3aZKBzsap06tg4VnzI1XvAfPcfa34Jlxmcy1PTolAisf6oiNwoeb5i7fyTNFDxcA/7Xgm0Pwk6YHNl1bDV2bngB3ZnsmQdJRL3rNTKJ8QRDKMxsZit9o2dOrr+oN6Ie0oDzfZo7oGWz15DiXvSSGB2ptgBi0qP5bvlb2m50tXwgy19bjcC24o8/4XAF5LjjyQ/y0hMhK+w7vMcNc9Cg5hKzWvq84CH9bVhyQJugdfyDQ48lDzlP1u02R8EYCpnxXXv8bh9S3n6eKfGFJaF7wmdNInUP2F5F7+JH2rgOwD26euWj27JCiRgRpGyFLUB6R5Pr3VsQ98P+pC2r2J7zRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3fhoGTyqdY754iob5s00wes9MyvgOJTT77eG6ekVmIA=;
 b=bpbl6zhB1x4Neo5pG9LCaLkc3vkvCdLbXmO4jbEhFUS9jV0ZmqkSuB/v69IZ4vRpvtZqLJDlrNUBNP+V7ZoCmjf/Ltt00r57S2IslM2a8ia/B5LxL0236q/EsYTzrAMNzPA0UQpM1u3dW2ywedcLi5+qPBV45oKy1aZ7dVzrl7g=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7733.eurprd04.prod.outlook.com (2603:10a6:20b:288::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Fri, 29 Jul
 2022 18:34:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.011; Fri, 29 Jul 2022
 18:34:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Marcin Wojtas <mw@semihalf.com>
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
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
Subject: Re: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Topic: [PATCH v2 net-next 4/4] net: dsa: validate that DT nodes of
 shared ports have the properties they need
Thread-Index: AQHYo04nl4JHZbxuek2HktTJEcy9Ma2VotIAgAAKUAA=
Date:   Fri, 29 Jul 2022 18:34:45 +0000
Message-ID: <20220729183444.jzr3eoj6xdumezwu@skbuf>
References: <20220729132119.1191227-1-vladimir.oltean@nxp.com>
 <20220729132119.1191227-5-vladimir.oltean@nxp.com>
 <CAPv3WKe7BVS3cjPws69Zi=XqBE3UkgQM1yLKJgmphiQO_n8Jgw@mail.gmail.com>
In-Reply-To: <CAPv3WKe7BVS3cjPws69Zi=XqBE3UkgQM1yLKJgmphiQO_n8Jgw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2a27ee3e-7bf6-4954-17cf-08da7191028c
x-ms-traffictypediagnostic: AS8PR04MB7733:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wNVxb4kYcte+ouAt/ZNMsxTizdKPnteAEwjU+2qIJlrXudMfVM/P8Ce6bcM7StYGASqaK7Wz0FCxLZfdwNY/AtLfqXcGJiyqgUM6LKRG6+U93CE3sazkrerYKo/qA1quhjXSd2N9EehYef1gPb+WvvIoto7nbTA71CEZU9/eDK6T4+7j6VoBhNkwQzBI7X6qOe833xBGg6VkLX2K+mVgbUkaxUMG1JxJ+8cqDoLR6YBj9yuLI8k/+NrCAimze8AWJA+fx0j53dDSyKU9P4yyb6Z+mG23PvJKXUgBR1HWb8iKic1dqTEMByBN3o6EugEnNSgd7NXIzKe8USFOp54fABG5NK6/RmeQYxOzqjVi6uBzfh2f6pHA2/pBUBrmrPwznCzXXj1YkVOT6O/ZDxoqA9W47yYge+NpDA+KQRPxfjLM8+rfHUWjPmT1s/fSJj260L8Wac5gjcnCZCsxMiOPDaBlxOxaH6TWi3SAdQMiIZJ40IuN8jduFGspDU25LA2/CY6nGuBdw1PUOboGEVSsHPk5m3sWE72ct0+0HBsXsuc38x+JIaX0LuAtPP4RzDO6UDCIKNKblwTKDuZwujVYqfBLLFc5fbrYpAKkipHUtkVm9KcH5mQpi94QCJ1pXBi+YKkFhiw6kYr+p+rD9GBkqavzXV47PEEQm00DYOOv/PgzmM/bPEngTGuKYC4/tW7GyOiltCt/1OkGZQltEqu9vkaaX/MD4r5DoO00y/G+HT4SPttekNMNJhZawX27euXraqBFKe19HCUzYad4RjPc7HW5MCWAXMV7+zAcs8wN6Lw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(136003)(396003)(376002)(366004)(39860400002)(346002)(6512007)(26005)(1076003)(6506007)(83380400001)(186003)(38070700005)(38100700002)(9686003)(122000001)(66556008)(8676002)(4326008)(64756008)(66946007)(76116006)(44832011)(66446008)(2906002)(91956017)(5660300002)(7416002)(7406005)(71200400001)(8936002)(41300700001)(66476007)(478600001)(316002)(6916009)(54906003)(15650500001)(6486002)(86362001)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?Pxy8/Yh4asPsARlYTUtBC0iRJJYT5FANAFhOiAG359zSLZtEf85c8wls?=
 =?Windows-1252?Q?H+Ly6YF4//mVhhxGjf4kSQjMYOGRJpvZ/Dvm9ckIK8HX5y0oH2p9430A?=
 =?Windows-1252?Q?xAjMbmfoke79mihAbaz7uIQgARg3OSDUFFscVwyDrDOPSVLVnBAySDbY?=
 =?Windows-1252?Q?19xWaWs2Es4v8oxDBzRDkvP9nKaR7C/M/hdnKwm5KnG3Adq1bmxENek7?=
 =?Windows-1252?Q?vF17uZSGiAF2ucGVhQJbQM6exflSoKO5/G5M9x9Pf1cC+pJykr3XcINE?=
 =?Windows-1252?Q?FS2+prTbTWREDgTJXu8mxLYCI8RnZ4q7+j9+GqMYVrZ8bUtlfYWT3qvK?=
 =?Windows-1252?Q?8CiCX1v79jDdeXsI+y1JQ6fVS5YNcuusgAsf57NimjzzYMH6Mr2Da3fD?=
 =?Windows-1252?Q?EjSOB0LpfsNFvI1Hx45GvwNzr8FzFgElW1JtpdHV/zGhpt6IdbU13nhg?=
 =?Windows-1252?Q?BiJmO0+U2yj+z7+HZue0qM0zWlsowol6oANRSohM78yuXvWK4diKvXbE?=
 =?Windows-1252?Q?YCNjBKo8QVMhtaXfa3qc7DrgbV7rWalE9tXYNhunok9P4zsr4ane+bBY?=
 =?Windows-1252?Q?lxGYoZqKdywSPblx3gTtcQLSdvuO15+yytlDfMgm8RECYOv2QDk5EyMl?=
 =?Windows-1252?Q?8RjvxnpIFUPBkpfYaA9UAw+wmjITjpYUgxc4aMgXp0p5bsMR62yWyz6u?=
 =?Windows-1252?Q?HlM8vQ4FZp4Ngkkxp7LSHJ2iCFbpG0SZhyWK6doD1fF0SgRMak9lVike?=
 =?Windows-1252?Q?fTF1Op+3Axcc2W2F0vhCD3wRWRutsPtz+IEIR/uOdr7VjgzU0KhQIrp0?=
 =?Windows-1252?Q?vA3njmgwJCeq9UX3Ddy6xUA2YHfH+wn5fDYnjyp6ASJBJMu7xNOMSur6?=
 =?Windows-1252?Q?EnFWVSl0WFsojK0EjLA5C57J6YG2yt9JM31SG2tNsAKyEyIBw2oYMZ5j?=
 =?Windows-1252?Q?Q+jBsT+IndRdBWy3iOYXPxO9zvA0otA14hrTmfnlVA/dgNEjjB5Ehs3m?=
 =?Windows-1252?Q?BOTrZhyhU+fJGlwE5xYrADlcrz2xUWC6UhghxLp/qAsG05MCJYXCRb8G?=
 =?Windows-1252?Q?521E3ympG0T3ItwbmSkT+Z6WYI/B5Tsh6akHynX5DYOi7hqt4apVE7TB?=
 =?Windows-1252?Q?tYa9MF+WHDlTGdXWO/m11SkNNhYKhDr3X4I/2S2dRkAxIC94aYPwvxBg?=
 =?Windows-1252?Q?p9s22v6W6HY4O+kFftaJAgzG35OZNVNEuZYYSgm4HYlNm71vChy4ouT7?=
 =?Windows-1252?Q?q1G6y7GN15FzvN7HmBu1oZS27xkhGDq3g4PYzjtsKA9ph/DJBXFriuNI?=
 =?Windows-1252?Q?8/94NJKpXiy8XSfJJQBHKSUkd13e689YOIFFaPU3zKsjS7KrqSe/e8C7?=
 =?Windows-1252?Q?XebHXvIBd0t+/1unElyQNBoXV4P5fTdzY3y2/nXZW3F/3vTmupgYc2hm?=
 =?Windows-1252?Q?TvAWUqRy9YFAu4/qokNjdeg9s+l3dNMKrkjAHpXy7PEyvwFLGyU41and?=
 =?Windows-1252?Q?QdHKZA7CaW07BZmqDZ84yJqwEI0Kq5k/B4IGCdxVMDLzYos59pYnxxrY?=
 =?Windows-1252?Q?uteB2njkeLzisqabyGzHgjJ4154GB9fihfprsmRRiGpo0MejtxrafHxb?=
 =?Windows-1252?Q?RBodLOhZGDxNw5wA4r+hCTLcIALIDeKufHy4GQZ/j6G6T/ey7bnLhjBH?=
 =?Windows-1252?Q?jWttqRtVvg4oEbTtE5DveSqgDCBdPjJvm1FIY4Laxu+avLF7cwSTXA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <1D92E848505E3146AFDB676A385BE14A@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a27ee3e-7bf6-4954-17cf-08da7191028c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2022 18:34:45.3122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ox078bvAzZDY4cZYg4n/K9vJ4nSDwt6Gylv2S+uI8hnPQHMkOd7TOhP8R0oRg+91QxuGDkGyViK6IA8euaJLvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7733
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 07:57:50PM +0200, Marcin Wojtas wrote:
> I'm ok with enforcing the phylink usage and updating the binding
> description, so the CPU / DSA ports have a proper full description of
> the link. What I find problematic is including the drivers' related
> ifdefs and compat strings in the subsystem's generic code. With this
> change, if someone adds a new driver (or extends the existing ones),
> they will have to add the string in the driver AND net/dsa...

I chuckled when I read this. You must have missed:

 * If you are considering expanding this table for newly introduced switche=
s,
 * think again. It is OK to remove switches from this table if there aren't=
 DT
 * blobs in circulation which rely on defaulting the shared ports.

The #ifdef's are there such that the compatible array is smaller on a
kernel when those drivers are compiled out.

> How about the following scenario:
> - Remove allow/blocklist from this patch and validate the description
> always (no opt out).

We're validating the description always. We're opting a fixed number of
switches out of _enforcing_ it, number which will not increase.
That's why the people here are copied, to state if they're ok with being
in one camp or the other.

> For an agreed timeframe (1 year? 2 LTS releases?)
> it wouldn't cause the switch probe to fail, but instead of
> dev_warn/dev_err, there should be a big fat WARN_ON(). Spoiled bootlog
> will encourage users to update the device trees.

The intention is _not_ to fail probing for drivers with incomplete
bindings, neither now nor after 1 year or 2 LTS releases.

The intention is to not allow drivers which didn't have any such DT
blobs, or awareness of the feature, to gain any parasitic users.
The DSA core currently allows it. If planets align just the right way,
those ports might even work by accident, until they don't.

> - After the deadline, the switch probe should start failing with
> improper description and everyone will have to use phylink.

Not applicable after the explanation above, I think. At least, it's not
my goal to fail drivers. If individual maintainers want to do so,
they're free to do it from my side.

> - Announce the binding change and start updating DT binding
> description schema (adding the validation on that level too).
> ?

The announcement is here, what else are you thinking of?=
