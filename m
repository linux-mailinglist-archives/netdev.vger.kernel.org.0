Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52DE202C27
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgFUTVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 15:21:13 -0400
Received: from mail-vi1eur05on2045.outbound.protection.outlook.com ([40.107.21.45]:48961
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729942AbgFUTVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 15:21:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jubGHTMUeY4VkNdCGL1oFF+zHyHypj3DPlpFlj2LQffSsddrPoMJqH9PDIBK7gyhJnN1me887mppmdX1Hpdh7C0b8jrp6DmzcOYJ97kLI5TLEkY+lLaH5eV2gEafi2daw+LpwsfWHDyMd3Z0ShqtbAYTH2hfUOnXQQlFf/r1fvI19QezLyKhqXK/u7xi6u9hnWn1WLh7uEQu312lR+beKtfj5CLa9ccAkcMGvEiwglJ/nl90WhBE/EL0vhroBWjUlyAS17cSGFQ/aV9kL83LIPdeNtlKU8wtg1IbcBHv2NKeC7HpUR+ONtOq6Yq1ey4ZmRihzZ8Fmk+xQzwrmNJ81g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FT1s6t1jO4KhOQ/gzlVQKz6byx+3LWjjdaf3Ugiw95Q=;
 b=A1YXm4RbiloEwKdfdnwbZ+jga1JbPxhfz3yhkZK8EfY+REEPHtCjnB1aykc2KNzoLaKQ9u/ssuNTs7cC2H2fSwVfzlL4CteydLA3ciGNcwOdAAq6MMQ77itJy/fjC8fPANnSh0cbDD7fYdqf/xuwFgZ0R0vAa/Exe8SZB7qEYvv2zpbuPfyk/ywkgJhNuhMSVYFjWyiTx/sjF1JtoCuV1wy/EdHlx6D+1fxNsLJebhWLUjTQrlIakZDYgiRKChHxk1D1WH5PWBVY0OC6x58MXD+ahFEe8aibC+86jBvXX12uLdqjfDIp+2oNVk84y3tfulEWNzBtAmIcYRkhhu6QQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FT1s6t1jO4KhOQ/gzlVQKz6byx+3LWjjdaf3Ugiw95Q=;
 b=Ww35cOmkO0/h6KmsdwRg24yZbl2VaLd5WmjuKAHeaIYjkKo6BZuSIiN5A94FakdC82G2vJ04+B9hXMCeIlPzgIWOPnnHukMIKCFy0AgjmEE6ZfofcBadpF1yI5qJ8SAVi8G4lp9U6IV8fjDZhrvyuHdqM8yDV/b5idSjkj9IAd8=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3760.eurprd04.prod.outlook.com
 (2603:10a6:803:23::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Sun, 21 Jun
 2020 19:21:08 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3109.026; Sun, 21 Jun 2020
 19:21:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
Subject: RE: [PATCH net-next v2 0/5] net: phy: add Lynx PCS MDIO module
Thread-Topic: [PATCH net-next v2 0/5] net: phy: add Lynx PCS MDIO module
Thread-Index: AQHWR7sls0YTCmyy4kaE3RVI7kO2DqjjOE2AgAA3IZA=
Date:   Sun, 21 Jun 2020 19:21:07 +0000
Message-ID: <VI1PR0402MB3871F57E22774625FA9A0C0EE0960@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200621110005.23306-1-ioana.ciornei@nxp.com>
 <20200621155153.GC338481@lunn.ch>
In-Reply-To: <20200621155153.GC338481@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.56.128]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 27e6605d-fcb5-4101-3831-08d81618405f
x-ms-traffictypediagnostic: VI1PR0402MB3760:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3760F0823ECEF4615D659C00E0960@VI1PR0402MB3760.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04410E544A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dicSmhhRXeHxHbHmRXWo0FQvo1z9c+3PFly/UjwPHBbcwCLi4m1DwFM37TCdk3SzFx1juoH7xE5QPJ9/my8zt3G+73LivabY+MU8wWprwKFyOFg9e6KyKIZ8U9eQr5Hy+3qzLrQalwurJDF++tisqjSPb19NBmOg88Vf/puSJ2gFyyJFQOgsX8BCB232jiT3mo47RKGDW3eJm8ksNxnoYRbLfnIA9T4SHqZtFNRWrkpfIOML92Lq5rE0b6SZ7qVEycNekgtEs0UMiNtsUfMHh4BRA7X3lDtuaQO4r9/g4dITgUqvJ9YDQ+j6cfz+mOsl
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39850400004)(376002)(346002)(478600001)(5660300002)(76116006)(8936002)(66946007)(8676002)(52536014)(66476007)(66556008)(64756008)(66446008)(316002)(54906003)(44832011)(9686003)(4326008)(86362001)(33656002)(26005)(186003)(83380400001)(7696005)(6916009)(71200400001)(55016002)(4744005)(6506007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: c8jHmIods5p8eYcUhZbPi5AWzTQyED9iI+TlnXyr5NZwVIkR2zFX3B/BzpzzDXqYj+6PBwbfbxGLwuLrNhbiyyIoSeuQkPa188xg/A1Elv7it1b+pmhUIh7c0AzQEe3GBnLt+wP68SlRTRbVWkCmvT4ih4DABCu9XSh2e7Cx4ZRikJEEfp0Jh8nhqHOqYYEsmdNeVRQkIzmzQ7nBHk6yJz57E5JJ56GD6LmJSY8ASvzZ9x0dbHyYGuHA30W3Rk5dWwvcg8V3rfKR6DHScbxDkC4z6k4CCWRTrJaVmh3h7OknmDDPGIOrUJdqAMKAgusNnqVIP3H7U0CWp6MgF2t2kegqonjfrNIZg5Wj7vvanVYFA1zkORyEKZnip5wh+TCCMrTIpk42paDsAagzicEKZj4jeILk9NZPIB2LdevFgl6qFne/z98KyhAoKyW0vTCPqqhoYCLf8E5vIX8gG9T5cUJFeYjdkxdZZze1ETTSeNM=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e6605d-fcb5-4101-3831-08d81618405f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jun 2020 19:21:08.3875
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B7TcU7YvFLPjVhTQydgti+LDylw2QaPMNzUkEVWsIZM4a6JEAqgfcEpttjs7RbZz7jP1UmvuQrLobqhiQ75FkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next v2 0/5] net: phy: add Lynx PCS MDIO module
>=20
> Hi Ioana
>=20
> I will be submitting a patchset soon which does as Russell requested, mov=
ing
> drivers into subdirectories.
>=20
> As part of that, i rename mdio-xpcs to pcs-xpcs, and change its Kconfig s=
ymbol
> to PCS_XPCS. It would be nice if you could follow this new naming, so all=
 i need
> to do is a move.
>=20
> Thanks
> 	Andrew

Sure, I will change the file to be named pcs-lynx.c and the Kconfig accordi=
ngly.
Should I wait for you to send the patch moving xpcs to another folder?

Ioana

