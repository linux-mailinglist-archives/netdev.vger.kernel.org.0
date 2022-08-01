Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FD3586E8C
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 18:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiHAQ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 12:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231195AbiHAQ3r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 12:29:47 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150085.outbound.protection.outlook.com [40.107.15.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085102A71C;
        Mon,  1 Aug 2022 09:29:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RoYxiw9GiRCDIcIwmCsw4KgHelHMemfJDBpX23tSCi2QIr1apqdiogeJ1P9Ek5uFwm3hoocWIMxpC34tQaIn6V2Z53WOeJecrapg0TLWeljJm2gdnDbfODjsIVg0fbimvHoINKunT6KVarAeV7fxoxe8+qpenWCayF8VwBE1DHbtXngn5H7wrRmAYsWzdulW24J9TKV/BftAv+aRQpWSVie+zUy+Y0Uojwm71cPvyI1wyCDVrZPI9hdRHLgR5k2lrfNMZYnZvX//5I/ZEM0ShKWos+K/xQlMkq64tkVa4JqSkw96vwsCAqvFjjJb6Vhd5sI6cLKQzPqN6v2YMNAtDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=27sBLZNO10xZt6IgHEF4bfxLMTlHXz3A/Anto6cbj20=;
 b=JUbrtVHyt6ff7bfyg/mLJfLssw7emAryaTcqBcs4NNwpGgMeGbT87JkKCcL4R2Oe2nBMDLUxQDTahMW1sgjw9AW6hJ2ZVcG9t0zt0ClNQjxgn2VJOICLYbJ2ZTU+pUlktDpMf5+rcDKsW/JSLQsuv6NN6gi7cbZml480GvGUG7kSzM/TQMR3UX6kL26fuKeEJp2Y515V1ePDawiAwJwxaUttaX1ApcKlbcwEOftje0dCm0CjtamsfbZ4GxYzQ59soeUyOG6eJyp8aAPL75owVvkohlTLvQPoWR33lzHMo7VNFNu3fiRYPcCx+lWvtpLE6D5GlTKiLe0ZrmvdKXoJZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27sBLZNO10xZt6IgHEF4bfxLMTlHXz3A/Anto6cbj20=;
 b=IRQoY+XHOsf7hfcCavffIoaxtFTpsNB1SPnQhpYI+4wTtdC0J0ZLYc/k0dv9oLNg/mpnwnS8thLTujEKctYHiLdqsB5NUM/5gy1goq2PltTSI30e/fFG45SH8JpFu0d3pra7acciQ6MDnc1MZDZyJvZCUIAcYNDVTSXA53gYGMw=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8451.eurprd04.prod.outlook.com (2603:10a6:20b:347::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 16:29:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 16:29:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, Rob Herring <robh+dt@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
        Marcin Wojtas <mw@semihalf.com>
Subject: Re: [PATCH net-next] dt-bindings: net: dsa: make phylink bindings
 required for CPU/DSA ports
Thread-Topic: [PATCH net-next] dt-bindings: net: dsa: make phylink bindings
 required for CPU/DSA ports
Thread-Index: AQHYpO5KV3yQ89oQIE2j8F+yYzUtGa2aPA0AgAAB5YA=
Date:   Mon, 1 Aug 2022 16:29:43 +0000
Message-ID: <20220801162943.guvqrjcb34gsnrdk@skbuf>
References: <20220731150006.2841795-1-vladimir.oltean@nxp.com>
 <20220801092256.3e05c12e@kernel.org>
In-Reply-To: <20220801092256.3e05c12e@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 357387b6-6ea6-4f5c-0192-08da73db0a8a
x-ms-traffictypediagnostic: AS8PR04MB8451:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: z5mHH68TwuaDyBOqyq4xgHGZnkDdtZtAjT+VXlU/4rsZoxei+eza/7bPDnD3eBHBDHksrQDPPoK+D87eRUcMcK3ZV5M8xL4nMdNQLd3rUME7wtH/8BTtHhmqQdsr6otZzd8FeP2A1LM3y1+e6e9WQnhsly9DgOkfem7maAt/L8WY+aHaJd8XiFtVXGLQrYm2lEarbypHd9oQjVWLdafjCE7Td/UxWvdtRQ2GOWocae36OjwjM9R6G+wJbi32m6umhdU3B4HTuj+K1iIsOgu3abOP9ZG7MGTP7904QvpEH9T3u//cj4pPs3AzSrl52s7mc/jzh/ILNy+8HfJmy4uaFrKVJqkWC5T/Or0+quelATodMAIQf6i8xvat3nr38CoxA70E0vmrxsi13s6dBH+rFrgYrSEdAyZ9YPnRGcStS8WCvDNdC6JSu4A41Z4cfu059M/Sq3NdzQC8i3aNq9VdmVUmjsDZzn94fj/nyhHoi3a3mDCxoTbPqno1IZMAfd/FIpql4fRB5pfnaP8hvHNfxT+qVXDp5+YPZiuboqhcqiS6S5JbfZdc9BLp2jCM1O6xzpvy4xcafNoWepD32UY1v7rnAsNzkZykpZwxhv7XqRy0taahqDqU+qhmKKH3WjXxFl9uE3ka/SwlogPkKzSeNFEKNTl7gAFlR2URIdFosQkI79tEBevUBeqouSAK0PM7XIV86wX+ZhB5+pN7YbeI6QNdWbR543HCsThNJXVk0tn8ZK2I6CigglPQPkIECJAf9uZq/vtSubG3BNUOqtxdzTivrAQNrXcNYfoHaFwSFdlIDwoRCiqIMEYQc36vrC4HlyNUUl0/UgtLC+0MhuaBNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(136003)(396003)(376002)(346002)(7416002)(7406005)(33716001)(122000001)(5660300002)(71200400001)(91956017)(316002)(110136005)(478600001)(44832011)(4744005)(8936002)(66446008)(66946007)(64756008)(76116006)(66556008)(6486002)(966005)(4326008)(8676002)(54906003)(66476007)(26005)(9686003)(6512007)(1076003)(186003)(6506007)(41300700001)(2906002)(38070700005)(83380400001)(38100700002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?/Xm4pIDNdxG09lxDx3MrZL9/KZy2o/V+jANeWcDbN9fHfrkfQmB0mY9q?=
 =?Windows-1252?Q?Ugiy4ZoPRKa+gud7ohqMXO7I9chwPCYHBUK2ECSlnCjovjQaBM0Iqg5X?=
 =?Windows-1252?Q?w5EM0WWeWU/6V+CLhQp9uKdsKCNeJpQwQZmo/yPXvpxUC/PWCnmYbb3c?=
 =?Windows-1252?Q?S51ozgx33SjYSoc32Fr4+DyZjhIvwAjZ506+M5MT+KioS3ByufiVSoSu?=
 =?Windows-1252?Q?UWrEw/aV5DEhXgKklNxQjfEr51Az0tMwAapG8lp4v2cyTJDPn8xxsUHG?=
 =?Windows-1252?Q?j2tULjOqgyHdDweps1O3qlVKeIwSJwxboAyoesUkoCUKMtqOraImrIcs?=
 =?Windows-1252?Q?HMoKp+fXqcrt6I5N/9eJgLSsrvUuk0CI0O6zYZ4eZCI3xLhQtdEKKwhx?=
 =?Windows-1252?Q?+2mmV/32iqCFjnC/3FV/fdz4KFyiDhy24t0KNUNVra2++Sdymj8GgDbL?=
 =?Windows-1252?Q?wd3na33lrBHkuiLEQMM6co0+Cix6Iwjlz8elp+WC29mDHa4YOWsI6oCL?=
 =?Windows-1252?Q?zQ/jgMUfgGlF/8AGV3qlKDaHawe7Pl2YwUojJKQF+xW2mmEKZ0PSElmD?=
 =?Windows-1252?Q?WSz1xFurSNZ3+V92P+9e0ArpvQRYqQ6ij5cnUXDCOqgy0InsLBB7GRzz?=
 =?Windows-1252?Q?+1dvBt4zdFkyOypHVby8cPGxGGaMFKEjDw7totvOwW+QOeBv/vwg5Cjx?=
 =?Windows-1252?Q?QhcCKGFVwEoOPsJxfHJ/ZhIUdN1BiqL5RKBLH7UVnMecEppOA8kmWNyG?=
 =?Windows-1252?Q?ccpo3MIYxpbyZvDZw2UM4quGiaE5isFeFy99dQD6H5ADpAyWFb2UPf+h?=
 =?Windows-1252?Q?WZ/t4WlGTXRh4jqdZ16cKIBLAWt70p2uBmkeTovbTf0ukIqOm2W4Qeb5?=
 =?Windows-1252?Q?xIPDZVSUPzA1/bBBhvbz7exNroxPZX0HSRfhdNbAebynSBTGLJx6mIqi?=
 =?Windows-1252?Q?UqlFqqq93dB4cwCSlRnwVrbYoIIvaLQPa1D/JObtUWFSOIn59PHoRkSH?=
 =?Windows-1252?Q?BP9FL32zwV/13+DaJ8du7aCuOj0t+wLw2acMRHHvN4cT7ZXHEthhWvua?=
 =?Windows-1252?Q?QM1IFjsdL/EcKsOh5p54xch23xJDF9dN2EZGfQVNsrXg4QniH1d5GkAA?=
 =?Windows-1252?Q?R8ifKV/583+pIdN+gVXN4hC7xCbE0j9HH06sqTVtebnSvN+ZNCO4ASFQ?=
 =?Windows-1252?Q?4NWMULEA0YLJhI+u5omnyjLhrK06vwFun2y0Dz1mDGly5CU/osotUqTZ?=
 =?Windows-1252?Q?Le/UnLNiGQq8hKcYAgb9TTuEGKygiIGbxiBUPsrQA+iJgs3YlULEMA9k?=
 =?Windows-1252?Q?gIMcJyfq54XHaA+n3nidw91wio1leYNxWQrE6MLiVfBEahI878qrMS5F?=
 =?Windows-1252?Q?UBDz1OQ2znKGmQpLt3WstsJi27Lvk/SZPcFL3FJ3ceWQW0D7YQlhWYf2?=
 =?Windows-1252?Q?ebGZPOCWMFliJDqyu/GF+1ZydBMCLumm/1ZrE8nrgg16/7/fGbvXKoU+?=
 =?Windows-1252?Q?mSUyfLhzF4MYQ2zwvKNtKU37USB/AP+8MexpWePlTPRK2/A/jQ4Yvb2A?=
 =?Windows-1252?Q?/g6ZAbW+Q8zbve7SDGoWit6ACyenvFfesLSh/AmnZYkV/LGsEOb9cv35?=
 =?Windows-1252?Q?AXZjEpugDwfyXMy5hujvroqmBD00QkotXhpuNXchKjfCqKG2lovUZRK6?=
 =?Windows-1252?Q?NFb/wtU83p/R0r0kQVa0cF2YWl0Gxgc6NUaS3vfB0FVjXwekVqjTCA?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <3FF1E1615266364C824E173DE872171C@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 357387b6-6ea6-4f5c-0192-08da73db0a8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 16:29:43.7726
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /4FrofybZ/S6KCkKXmwP2ca1dC1kC8DTjT4zhi3cL6OjesCk8g6SygeGSP4lrL9tZgF8RO1yvDIzrPSERYKseA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8451
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 09:22:56AM -0700, Jakub Kicinski wrote:
> If I'm reading
>=20
> https://lore.kernel.org/r/CAL_JsqKZ6cEny_xD8LUMQUR6AQ0q7JKZMmdP-9MUZxzzNx=
Z3JQ@mail.gmail.com/
>=20
> correctly - the warnings are expected but there needs to be a change=20
> to properties, so CR? (FWIW I'd lean towards allowing it still, even
> tho net-next got closed. Assuming v2 can get posted and acked today.)

I can post the v2 of this patch today with Rob's indications and the
correct indentation spotted by yamllint. I'm not going to fix the newly
introduced warnings in drivers' examples - I don't know how, for one thing,
that's hardware specific knowledge.

Rob, given that you've said DSA shouldn't validate the DT and then
reconsidered, I'd appreciate if you could leave some acks on patches 1
and 4 of that series, which deal with the kernel side of things, rather
than the dt-schema.=
