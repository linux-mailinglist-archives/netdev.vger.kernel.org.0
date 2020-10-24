Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B570297CBC
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 16:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761905AbgJXOKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Oct 2020 10:10:02 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:11232
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755692AbgJXOKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Oct 2020 10:10:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hEjoFvrzZhCE/APuqMf2hoTlYbsWyQesw74os7/8ecB3oSV+fdlZ/j7hhq3MKrWRZw/IrWHROLTQ1oAz8UjJgUc9McKmUOhLao8kBi4CZUhVOQ/qP0kBBSOkmIKKrkSl4JPjqRYaEnl5fQSmluXy4f32qZXIS1QsEaaizN4bQwEtaoJNBDlbkmSBx7W+QcS2jtPWrsBsgw/TlWxYIZgiR5Z/KIyIlEmq/dvyOkw3fjZO+5aLx0124Pd1pIiDaLo0QsPIo1uPMLR48tlct9sKfFOs3viX1PCCF98oA6aaJTTGyqoEXjx+wzoiQinTfb2Ry4JhpZs8bKLBJ+v+oqjbGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03NrHPKkKak8mZNn1IjOK324ODYG1N7kM0lWks7besE=;
 b=Ym+loN0Yzqd/umOCEpQAqwMBVoWJpXVfUTWyBDWZFIkhc0jx5a6tKTqNeTraMMo4el/mblo7BUQ2zvNfkM2l8ROFSbj1MPIwCMWzFN2DUGidm3UjyNrbk+5LW1HYzBgyL2GdAyvYpu5IRw6cdjC6Ui8wuLuxPJp+vrqXtOdlKjCIsfEXtmKTdnZlZrrBaN3V32suVtLa8ZmYBXcBCYYNFEhGIgs1nc9rZM0+2nJRZxiZV9LNDIBYzRRS5VR9NEOoD0lQTnyBenugHflpq1bRwgSj92KLMa8wHUZ3/r5lyA55kJFDBaBUD5wrB8aYlzGpzLZAIM3l8EOeoNouuZMDdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03NrHPKkKak8mZNn1IjOK324ODYG1N7kM0lWks7besE=;
 b=p9qqidoF+QvGMU/7dS0W6XqQBV+97Ayy7c6MtWAUs1TrcEFdt7IuF+RA8R21yLbO+fscK5QaPCdRZ5VzUpZoo+gBwGKAwVjvjQHdK7O/d64eKLuikP6TOeGdT2rkpGGv9EKPYUM5uQeXEaBAc7UF3WCqjpHb8aT11EVdOieNask=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB5885.eurprd04.prod.outlook.com
 (2603:10a6:803:e1::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Sat, 24 Oct
 2020 14:09:54 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3499.019; Sat, 24 Oct 2020
 14:09:54 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Dan Murphy <dmurphy@ti.com>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Mathias Kresin <dev@kresin.me>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Michael Walle <michael@walle.cc>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Willy Liu <willy.liu@realtek.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [RFC net-next 0/5] net: phy: add support for shared interrupts
Thread-Topic: [RFC net-next 0/5] net: phy: add support for shared interrupts
Thread-Index: AQHWqf897amgBiGDU0S3g6psdVpuFqmmyrGA
Date:   Sat, 24 Oct 2020 14:09:54 +0000
Message-ID: <20201024140953.rwmkc4ldpruz7cqn@skbuf>
References: <20201024121412.10070-1-ioana.ciornei@nxp.com>
In-Reply-To: <20201024121412.10070-1-ioana.ciornei@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 04640639-0855-447a-20ea-08d878267b67
x-ms-traffictypediagnostic: VI1PR04MB5885:
x-microsoft-antispam-prvs: <VI1PR04MB588573A38041708CBF2BF33AE01B0@VI1PR04MB5885.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U1+lNVjbjH1sdgfm7cMfpVzJJDmSxgi/QW5Vapgz4DZ+gD4D0B8kipg+NZhLMW0UhnSd2vrZf9YvifofYsTKIEqbtX7Jou+MDJP2SIlFBheWD9YTvUvJm9xec6p3PwKuaNyrHH05qo88/JYBWrcurcEbGDuHRBUX5NetqTxTt9dj0keQzkKcVTuw0IRMdvjPvPvU8nJP7rZKG5gHPogQYE6C6umCz6PGC79n0Oa7LUvP8Y/CAkRoaeJMHL3fYkJzciLoYcKNlozPUIqGvT+ZCIJJ52B0Ei3EoEP1L8wydhOr0Y1gYDJOWNhmtDgUMXyLzjliBwTd2EiikH6q4KxD8lk/qrGqJtB/NO692aE6Ia5lThZm5kGHgxUQH0cP4vEYaOArMdU47X0gitOBG0YiOA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(136003)(39860400002)(376002)(396003)(366004)(346002)(91956017)(66556008)(2906002)(86362001)(44832011)(83380400001)(1076003)(4326008)(5660300002)(8676002)(76116006)(966005)(66946007)(478600001)(6486002)(4744005)(26005)(8936002)(64756008)(66476007)(54906003)(186003)(66446008)(71200400001)(110136005)(6506007)(6512007)(316002)(9686003)(7406005)(7416002)(33716001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: iGD05MuiUf96lJ5BF4V0lETZS+YXlSHxzav/5EvpZ4eXNC6Rrs6qXhL1wxkcpNy+QtArrZuqWkenYRxNJZMAjdMHQtCwHwg7xZmCTZDFCPbAEZP3Dh+Xku9pi4TvVttSS4TaUN/q5QFR6CIQLePy8BOs8qyYk8nqjaW6RSIqdlfx6gJfcrpAQjqm2n1fKG1tEQeyOTyszjnEYC1YAN2m7zGPK301oMvggikyRIzVWlhU2RLNo2Bwk4D8AfNXge7E5iFXpMjrDOWax4vP8dxyXrkjNfC96mBwr0XGEq3EF3EeYK1X+33iUAWg7xreQDtKMNefAU7yDMAe5XFayaBdqAs/4bXif5b4b35r0f/eVQq9SwpzSa6kAqH2wL5eEDLEfO/rB8QUA6WDav/1aho+8O4SjowR/KDlRAmJrktrZvQj9U8X6AWhRTPlj3CvnOa5gZS8FvWjcyt8n+vclMMugmKkD4tB8FHkGGwRS8ndXZswSGIlOLRO+Y79KWFFWXNyzlRU3PQf41ubuHnKFrYWyP+PbijgPB+srtKNi9pxHAPDosbkuYzYEGvl/Car2/5I4v55hm+MVJIMCCmCLVGmZ8lBkZIIylL20O0Kz5AS9X9McRP+fjqZ8mii/POmYUiecy/vKRXN6IojprE43A0Fqg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2EBD8EDA8BE49D489B6F4F6EEEA1FE8D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04640639-0855-447a-20ea-08d878267b67
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2020 14:09:54.6322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvQD8qLydsUAS5GsArwV3lKkPd4Z7OPfmIFgt4hPHfHN364eIKnc4DleKvE3N0NjQlou/DDhZqeQXHo/XqX8Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5885
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 24, 2020 at 03:14:07PM +0300, Ioana Ciornei wrote:

> This RFC just contains the patches for phylib and a single driver -
> Atheros. The rest can be found on my Github branch here: TODO
> They will be submitted as a multi-part series once the merge window
> closes.
>=20

It seems that I forgot to add a link to the Github branch. Here it is:

https://github.com/IoanaCiornei/linux/commits/phylib-shared-irq=
