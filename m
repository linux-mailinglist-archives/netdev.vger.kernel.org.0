Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9798B230F3C
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbgG1Q2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:28:36 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:6222
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731118AbgG1Q2f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 12:28:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKXkhhtSr7djWKbn49OpfWCVqB2Q/6fTVx0Fs6k3+jSlrPOGxZQslZcTcetkzQZqXEb0s87jkD/xD8UPvc8f73LKF4nORIlhfTKddDLmlsgxxeEpXLVNo4FgqCERwn0WEOi9FqY/U4pyQK4KTq82K8xdrbi2yJc+wURRXwFZ2DR55JY057jfeSRncfg6hVqBeF8vlWPNNKvEM0aJ2Cx3p32k0no62LT8pgPQ1IcRsazzX+EZ7cMRULiFgWiZ7L6AIO5xyANzWIJJu2+4Hy/8bexPEK1SflXzYeDFy4PmebLFxLeD8Ji5h+5Vq+y/yNDAJDRslpMwtgAc2z37s46nAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27fuGuOU20C55pw7iRiaciceT0DAn91/SuU0K7RqUw4=;
 b=mKseRgtVOFFgYf+aI/eXhs1/hVQfaA01/bBdrdB+e1hYKU3w35on4YApSEnQYRCsVAkV1h3nNFoNyg2T+PSWHg+SDnSu0YefNzsiaODW+KUM/ldiPCujlp/AaTuzfa+GgC6Oq4/zCW3RPdJFpW1WsphJqLjIOOhj/X9gNKVO1MJWqhqsyakL0Hk9QAMFTgb3mi8hI+z5zgy+o9127T4IhtJG4eVihnGe5VH4cj1xkQbN9F3bV6ieqloxvYIdXucwuVmbyq3kTeId3zrvVEcgqLR/20kq5XzkQ1CiSRjtFtxzmmbjvteFW8SqdR4C0u/qJ/cPDXzci+p1Ngx3717d4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=27fuGuOU20C55pw7iRiaciceT0DAn91/SuU0K7RqUw4=;
 b=UbeKgFvl+nS7PZiLjeFjLIe+ppPrStbQandMx7LIQACXCv229eKHpwwi3wHubXE0fK2BioFoU2l9LFNDSHne0lBRM1tBmgi/JPPHhI0mN9l386F/lIEr2GTM9kT2p16WiQvk+hXVfZQIKAR94ZdF+rJnwsRK9tOQtLAq2rX6pXI=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR04MB7197.eurprd04.prod.outlook.com
 (2603:10a6:800:129::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 16:28:31 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::d4df:67d5:c1f7:fba%4]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 16:28:31 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: RE: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Thread-Topic: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
Thread-Index: AQHWZFcvtAOghcV2G02sokHxIysjYqkdIC3ggAAJrgCAAAT68A==
Date:   Tue, 28 Jul 2020 16:28:31 +0000
Message-ID: <VI1PR0402MB38714D71435CC4DF99AE5A20E0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200727204731.1705418-1-andrew@lunn.ch>
 <VI1PR0402MB3871906F6381418258CC7AEBE0730@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200728160802.GI1705504@lunn.ch>
In-Reply-To: <20200728160802.GI1705504@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.95.40]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5918140c-22c9-4fe1-c59d-08d833134468
x-ms-traffictypediagnostic: VI1PR04MB7197:
x-microsoft-antispam-prvs: <VI1PR04MB71975924B7E1F46F02E28A09E0730@VI1PR04MB7197.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 78Clofcuf24ObyuU8HWcSevSuvSJ3gfYmKQfnTnhuNcy2+/m9jRtXohT8rnJLKKNchzl65enZnnrdwg1AuSC/xFqpT4A7fvap3j5vkHmEItZuBiosrzZ2wgRt2XMkZxB5tsyFH7GzZfHwdHzToUSs+oa4csABx/tnRWnHmknU65+Dngrnflg/3bARyGFhj7AYpdJbQFdKylSsg6w9r1aYz+83oosJBp6/xGKyqwj6516ecxoYN7NqilcuLRuntVHh8F+VZfX35u7bWhV1dM/Z+qZQ9zRAFx2zS1Ga12P8Lt+DWz3/bjl7KvZvdGCoj1K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(316002)(66556008)(64756008)(86362001)(33656002)(9686003)(55016002)(44832011)(52536014)(66476007)(66446008)(54906003)(5660300002)(26005)(71200400001)(8676002)(2906002)(83380400001)(76116006)(7696005)(4326008)(66946007)(8936002)(478600001)(6506007)(6916009)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: rMPBzYJp0vGn/lcWA+KZ6cyvXHtFmj1xp6bcmfa2c65Arj+OlnxpBUadtiVJecuAeXDMTreijYUxz/PL3w7roH48+y61mo9v8iyt5b1r80vzN9QGeglruEQDO6mswaaNSPMQK00J3Jl0M5H4UxLO0wtX9XI8ncgtT9NtGYYPqtDxIIUjhBtHJbsSbLsps1ynbppzFePycwiE33nIts8Rm6PMfvZE15fSSQrRWkTiQI6AmIqrR59UpjB2RqXdbuUBIhNFAzHpcBe5DLKVZ4H8Tyths5qj0YNnSG3G9TrU2MdPjcA0rkkCmc1S/O7K1+gD6QZLnswj46HVhFaVEF6q4FG+b/u8mH31WvIg/I70BN07gRRTUFIYqCqyS6H6ntzpN7LGjUIKQr+iaYjU2vWLcmGv0bpq4lSzqLi2Bvc8W5l3oCjENwAWdZN6zJnnYNXEBUec7oHTf1vBUyu7B1aTO1Qu6IBWW+Gasw3j+/lsyUM=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5918140c-22c9-4fe1-c59d-08d833134468
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 16:28:31.6888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ardykiZlzsfeKRBhf0Dc3V/5Y+OZ07CD8GGtbkPvEH9UwlZJSrpWwawoznOOhBiiWw5ZWC7m1ZzfHAqr1t045A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7197
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH RFC net-next 0/3] Restructure drivers/net/phy
>=20
> > I think that the MAINTAINERS file should also be updated to mention
> > the new path to the drivers. Just did a quick grep after 'drivers/net/p=
hy':
> > F:      drivers/net/phy/adin.c
> > F:      drivers/net/phy/mdio-xgene.c
> > F:      drivers/net/phy/
> > F:      drivers/net/phy/marvell10g.c
> > F:      drivers/net/phy/mdio-mvusb.c
> > F:      drivers/net/phy/dp83640*
> > F:      drivers/net/phy/phylink.c
> > F:      drivers/net/phy/sfp*
> > F:      drivers/net/phy/mdio-xpcs.c
>=20
> Hi Ioana
>=20
> Thanks, I will take care of that.
>=20
> > Other than that, the new 'drivers/net/phy/phy/' path is somewhat
> > repetitive but unfortunately I do not have another better suggestion.
>=20
> Me neither.
>=20
> I wonder if we are looking at the wrong part of the patch.
> drivers/net/X/phy/
> drivers/net/X/mdio/
> drivers/net/X/pcs/
>=20
> Question is, what would X be?
>=20
>    Andrew

It may not be a popular suggestion but can't we take the drivers/net/phy,
drivers/net/pcs and drivers/net/mdio route?

Ioana



