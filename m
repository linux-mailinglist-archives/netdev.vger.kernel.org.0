Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC30276267
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 22:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgIWUp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 16:45:56 -0400
Received: from mail-vi1eur05on2040.outbound.protection.outlook.com ([40.107.21.40]:12001
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726134AbgIWUpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 16:45:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UbVEkh6/0XhOHnRqiRT1p+KO2FvmNvz2knwRaMxAnO0ZdWyz3Rmkv9D34k6KeH0Ib6Q3d/KU9Zl1oHa1ZEaIBJKpOW5iADlzj455I+ERhecr3Q5gLJ2I5GUrk6C6OYHKrtFFN99BLN8i+/e8QJBULqwITkvXDiyb4xU+FQDwumAwxbUS2Zk44VJvgb2LvgLCykNU/s/q1edDYdnqR7ZvfaO0l6gmfyU4pUgShqQd//0hTMTRxnr0dgjflwsNvcC4LWs9hKZH6UTztO0z4EZZB4PGvOlE6hGZVG7zn5efem2HOoRIIK112hj4nsLHQYVid7cKJXtUKI8aRgI4jQAZXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdyO/tAoWLB+4vmk0LZmvlf0rkSOVUZhzaMQM2IqSwk=;
 b=iohEp5PTsuLRgrSyY01mPN/+Ig5dJn0J15/dPPtJsZAJwtkuqsDMhFPtx4DzhJqDRzXrZfW+OCMEP2/ypvjPmE63p1AhvTKTK0N9QxnZX/BC2vgIdIHC7EC+dZWGPt6ZZc7TSXFTN31XYV3eGxjOVwWJ6LhmDUPM9+OUgVOgM5aWF72CKtwWPOWrrfardsCak5DTc1SuJunp55SnjszLEDtq7gCHHkd1ud0yQDTQs0uy9IKBIPvtVxoHrgcVYvXXF9XO3aFoV17NfCwzzjCg2CKUFXzu0fxNEWoGnDEa5/9sCr53uExhPXnQwrLHD9n8kxu9DSw6xkzrb3aetJ56gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdyO/tAoWLB+4vmk0LZmvlf0rkSOVUZhzaMQM2IqSwk=;
 b=hO9fjPfHyHoeUAgASpK1g/oKxAB7RsknjITc9vKImNQmZSml/5z6/SBdGJGY3Pq9yE+x7gU19mtKlVr1Bo+JGuMOTbmOfYVd1wP6Wu7TjuMtorrMbh8L5iyp83j9FNUHaFi+1Sw4hYQC2IMKHaVwzNraltNFA4ermRIqnaerVcg=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4222.eurprd04.prod.outlook.com (2603:10a6:803:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Wed, 23 Sep
 2020 20:45:49 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.020; Wed, 23 Sep 2020
 20:45:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Y.b. Lu" <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Thread-Topic: [PATCH net-next] net: mscc: ocelot: always pass skb clone to
 ocelot_port_add_txtstamp_skb
Thread-Index: AQHWkZwgfSWJjFtWWU2aMSGYdOEjdal2p0AAgAAEDoCAAAOhAIAAAuEA
Date:   Wed, 23 Sep 2020 20:45:48 +0000
Message-ID: <20200923204548.k2f44gjl7s4dwoim@skbuf>
References: <20200923112420.2147806-1-vladimir.oltean@nxp.com>
 <20200923200800.t7y47fagvgffw4ya@soft-dev3.localdomain>
 <20200923202231.vr5ll2yu4gztqzwj@skbuf>
 <20200923203530.lenv5jedwmtefwqu@soft-dev3.localdomain>
In-Reply-To: <20200923203530.lenv5jedwmtefwqu@soft-dev3.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: microchip.com; dkim=none (message not signed)
 header.d=none;microchip.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.217.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bf83fe14-5cf7-4017-4410-08d86001a73c
x-ms-traffictypediagnostic: VI1PR04MB4222:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB4222100DEFEC0E985872984FE0380@VI1PR04MB4222.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hWJZoEmnsDD8MY1bFiVEOTRe1uFiVQxZKr2enP9Ww6LFbm8AYIqv8WoBtZKXhZ8R0apl16OGb9RwCayJWGq2GfVcC2ehXelde337W+cGoPCwEy0vp8V9YQLkd3P1XmTWmT1uma1tXpQFP+gEX7yOaFG+7YhoRLJVnfG/SohF+wWead1uoZFpB01iP3zJu+zTeTPuGhqnhJD+X9bVXFBOzaviN0yCXfJyeiBzZXtcSPujWHGSgfpKC7NhU4Z6l7JMz6I0Vh2USUouuE5ZFHxiHv8yJ8VY7EpNzppowI4dkZ67mXhZozw3JPuKMhYWqhBnAxq9XAWvOFQ1wriNjFTo7Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(6486002)(66946007)(1076003)(186003)(26005)(4326008)(6512007)(33716001)(6506007)(83380400001)(71200400001)(54906003)(9686003)(6916009)(316002)(76116006)(5660300002)(8676002)(8936002)(86362001)(478600001)(7416002)(91956017)(66556008)(44832011)(2906002)(66446008)(66476007)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TE4SZUi9xUd8OK8nRFyie3BLjbfglUog8pLNHQUZzRnc1w4J0vWo+ijubsyqX1S1++2E5OHJA+sjgU8YZDkwkwv+1PHcGUhhgN1DOiqiI7iGKIEB3A10z0tA/SoFe6qJ5PZEcbBcofppeCOrw68W92zCPIoonPpW8x6AQYnwRcS8GDLcyRjVmaC67QBBNwBf6kwcIoSu7Z6BOZUGvpvnWnFtwTBUBxtK3ZPhWDw5GgFpiib7anmwXl4ORtfoOl6zyPIFLCkuzXAS0o/9osS6hux+zZzqYnS9dIQTB0mprGuhmmNtKqTHDX/5kiSTgv9dqcc4oglf4pnWL/L/ym237oeXd0UW5cml6VoXhuprByOj9u8tq0Umke+50SIU+3r71b8M6YWXrmpHXJw2t2bnJwaWdPAwuBSzb63EG/2egYdc3+d9HQatuhHWmElwoFO8CK3ORcmKDo/gO9FMdQFU39IgIpo9gSZDBiyUIRwBoBPGCYtMpCAqK5pKd3LlHQo/ACusFDXAxxBayPcrMkbA/+TJRyZUdqM1CIJxxSiRSaj99VVVrHiZQuO27a7lI8HCkoAD6Go1um+9C8WxQsQ1vJJI8qbt8JW7xWKRFh3OoEz95ffw71rtmvyzkGXDmBFHp6kXKu2qq1OXeWirGX3SjA==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <953FCED5699B104CB187B509EDA03567@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf83fe14-5cf7-4017-4410-08d86001a73c
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2020 20:45:48.8734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DMp2F3z0TcVc0vx8c2H0cBPDdlm7K0CyRKTxrTZj/dw1Re9fa/lyZSesv4O9bfrXEp2oMKDqrRRxLKWQ5eaPzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4222
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 10:35:30PM +0200, Horatiu Vultur wrote:
> The 09/23/2020 20:22, Vladimir Oltean wrote:
> > On Wed, Sep 23, 2020 at 10:08:00PM +0200, Horatiu Vultur wrote:
> > > The 09/23/2020 14:24, Vladimir Oltean wrote:
> > > > +               if (ocelot_port->ptp_cmd =3D=3D IFH_REW_OP_TWO_STEP=
_PTP) {
> > > > +                       struct sk_buff *clone;
> > > > +
> > > > +                       clone =3D skb_clone_sk(skb);
> > > > +                       if (!clone) {
> > > > +                               kfree_skb(skb);
> > > > +                               return NETDEV_TX_OK;
> > >
> > > Why do you return NETDEV_TX_OK?
> > > Because the frame is not sent yet.
> >
> > I suppose I _could_ increment the tx_dropped counters, if that's what
> > you mean.
>
> Yeah, something like that I was thinking.
>
> Also I am just thinking, not sure if it is correct but, can you return
> NETDEV_TX_BUSY and not free the skb?
>

Do you have a use case for NETDEV_TX_BUSY instead of plain dropping the
skb, some situation where it would be better?

I admit I haven't tested this particular code path, but my intuition
tells me that under OOM, the last thing you need is some networking
driver just trying and trying again to send a packet.

Documentation/networking/driver.rst:

1) The ndo_start_xmit method must not return NETDEV_TX_BUSY under
   any normal circumstances.  It is considered a hard error unless
   there is no way your device can tell ahead of time when it's
   transmit function will become busy.

Looking up the uses of NETDEV_TX_BUSY, I see pretty much only congestion
type of events.

Thanks,
-Vladimir=
