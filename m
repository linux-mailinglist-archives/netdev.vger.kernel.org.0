Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467E5290CAA
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 22:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393579AbgJPUSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 16:18:17 -0400
Received: from mail-eopbgr50040.outbound.protection.outlook.com ([40.107.5.40]:27048
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2393400AbgJPUSQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 16:18:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dWxbyFqx9hS/bwet3Xq8X1MZWWeJ6vEDYho7h75C2adX0TTmB/+knu83IJYJnj8sghjd3u2hKZcQBcKUlNQAewfD6RKsp17cK5fMKH3nWXiLAb/DN9WaC3rqv5dFADGX43R9xhUiOtN7Gg4i2OvlXD8Ls+dfQoUBM9A2oLjfnt8HdXEAm+sbGhD7Pocbo5b0U9BC+BZFrhq8ieM/OOAQl8Fydz+0ww7HIiduoHXqj3rC3S8/UkEFmmKxtQ/BKozbupy5VZaGbzVqvFzsBXN9qxFdDT7rxcnT3TrhR1v1b2T3RP4SZvgUJyGAtSRDDKdrJCi+pYE5J+wO/BngWSy8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8uHdWK/jK8D/+LBAALDUlMsWoXEunJeuDjQMzokaDE=;
 b=buQxXMa0Stt4YlpjNbsY1sRZA06u49FxHOxohVZyTHepfsP1JFdoqPuWJqr8KMHW/zHtRE/Lz6oVMtr3qPEyiNkzNdu6S1bCpNYzhGMP7F3yE6jAyLcOV6hfeo8TI1DfKFtyN/wYkEmU9ZiY7enCMF2ZEv8tjpxp4ff2JhfB36HIxYGB7JYZ50+QcCUEzraYp5F3gT7L0jOHnFwY1WJ5BCUQ2iYYsGE7xWj2N6MA97z41FXXrE6Vmmz/cWpo3Py8OfqpTuO8u65MJABj37Rx7Re4D4YP1ugLfKK+xMHOtr9gIWR5QfMg4GUp3BXQis4mcgBU8S/xK+Scx3tOEzCoeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8uHdWK/jK8D/+LBAALDUlMsWoXEunJeuDjQMzokaDE=;
 b=mNNYHLGKJlQ5jgMixyzHliHpmgVAlN9FqgFthESvo7ET6xi5oJeHGNgRm7e/c3OeDcucXZN+C8kQHW8NSG3gHqqxaX4bTmguX9IHf7viuUOrPJ/n5OWI3fJz+vYSddeSpYH5mf9HIL3j9s26TzHacJfUUld0HtoV5Zkj2eQkAdE=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4815.eurprd04.prod.outlook.com (2603:10a6:803:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Fri, 16 Oct
 2020 20:18:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Fri, 16 Oct 2020
 20:18:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Maxim Kochetkov <fido_max@inbox.ru>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/1] net: dsa: seville: the packet buffer is 2
 megabits, not megabytes
Thread-Topic: [PATCH v3 1/1] net: dsa: seville: the packet buffer is 2
 megabits, not megabytes
Thread-Index: AQHWo6CCXdoFskMuCkKZq2JZ5okkA6maq6qA
Date:   Fri, 16 Oct 2020 20:18:09 +0000
Message-ID: <20201016201807.azgmtmjwbcvqlmi2@skbuf>
References: <20201016094155.532088-1-fido_max@inbox.ru>
In-Reply-To: <20201016094155.532088-1-fido_max@inbox.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: inbox.ru; dkim=none (message not signed)
 header.d=none;inbox.ru; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7ce6f051-0cec-49b2-8c4e-08d87210999f
x-ms-traffictypediagnostic: VI1PR04MB4815:
x-microsoft-antispam-prvs: <VI1PR04MB481539C836BDEF4919FCE86FE0030@VI1PR04MB4815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ot4fErEJPXLDqbEKkVpG/jgjbauyFdXmMNhUljWm5VoIwMVvPqjbXi+1agRv2HGggixmJxpg5Fu1DLInUSjx3Qd6cADmTdBaVpPwUjd2O3B9NKC0JNG9AuPOddfEUm42mwSu/TqvDhsfv5D66vFIPIvb82fPTUJrZwRO7SE4gS3JsFSCe/+ah4blUb0XZYTnBEEGnRFZRXP0RsgDfjSp+CBq2+fX94psbn6qktMsHBNIyT2nRilZjy58nwtExRTfqcn+80uUDlZHlL/MwRmTaZloB4tpzr2vffiikf61GM2gN4+rW5BU4YoHTmk8367pZSmUBb04jxDzZ/J2/TjIfm9oUUX50XHjgF12JVEVdyJL9kLbFKDesHO8NDFaku0f7oEWGRsK4ukSrslJaqje4A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(346002)(136003)(366004)(396003)(39860400002)(66476007)(44832011)(316002)(64756008)(71200400001)(5660300002)(9686003)(6486002)(8676002)(4744005)(6916009)(26005)(2906002)(6506007)(8936002)(4326008)(66446008)(1076003)(6512007)(66556008)(76116006)(33716001)(478600001)(966005)(86362001)(54906003)(186003)(66946007)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 7lv/m9R8VVrucJJ8oTQwD2XmA+4UGCw6HWDRQfe/7+/9KL5+CYAMDRYEgl4p8OHnXign7EyVmz4T16itWHSJHZvkZi5qUdV7BJS06TbmwHysMtO9XDc9jaNOs4rC2hSrWORIAqneV0a4XyO5fqCSEZiBhEFh2kGrcgXLhGJgVDVUvze9OjkqbNi1aL6GiFmCmA+7ZPboQ2t7lxH3ZDvmyt+tzPDqHGCpmeb4HT1iMiEj+u/SCj4tl9krllo6A0CVQC9j1Hq3+f0qXfTWkmJUOIohy2qKU7ZrnPaENsNLfJ7Jq6l5kBfrL9Qai2rYIZP3nAOlAu2cCokT24b///LwxPtfpN/7o1rR24gChzjkVhepKE0EU5ulc5UDAh7aE/Gqd1V/luTZPhzJmqOWpwg9/atk/sg5my/4SlnQGWFg0BFb1dR5piFhCrv2fg6gh3stymb/Z5ElNus6K5lTTTi07DWOS0EmvM15Jauba90ca3jGSydmUUD8EJmsQwdCtonxlJSmL1xtufJWF0Y2TzTjBEojnP4U3IGZrwhrBig9E7yQbMokD+3Nkn4lNvqAiVv9X6qIzEFmnU1S/yZlFdk6MkgVrWfu+f6xp7hdBlnbOzuL1W0B/PqYovEbtlBJtfG8sA18gVHGeJNaYRRCtOspGg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6A783C770BB267418A61859FCAC9CE13@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce6f051-0cec-49b2-8c4e-08d87210999f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2020 20:18:09.4848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FV++PlsC7atT4FXSR08fdZZz5AAUgpgEtPKeBC7jKXEtzLTyxDFaJWvUYq7jujY54s0rhV5A+A9t/o4MDw0Hrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4815
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 12:41:55PM +0300, Maxim Kochetkov wrote:
> The VSC9953 Seville switch has 2 megabits of buffer split into 4360
> words of 60 bytes each. 2048 * 1024 is 2 megabytes instead of 2 megabits.
> 2 megabits is (2048 / 8) * 1024 =3D 256 * 1024.
>=20
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Fixes: a63ed92d217f ("net: dsa: seville: fix buffer size of the queue sys=
tem")
> ---

Maxim, networking maintainers apply patches on the master branch of one
of the 2 trees:
- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git if
  it's a new feature
- https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git if it's
  a bug fix

Your patch applies to neither of these trees.=
