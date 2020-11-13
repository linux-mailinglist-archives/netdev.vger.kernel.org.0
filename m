Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237CC2B1710
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgKMIRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:17:04 -0500
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:25697
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726248AbgKMIRD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 03:17:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXM18WYsfciJet3kublvLWcDsPuRpRYi5papN+NgrMYZ1qYirTs62xPH7oqvyKpmLteA0h2FPuoYKv+56ahlFcTtZihxNkIlxVVqnXWgcoK89vSbeYEeAGQ3O4F/Q9fdZN9VtedJLaog/f6jTqBUzYzwiKJ2U+9ejDKoCTdYvLopQN5BxlK51+DH9ZBAz6/JvPqzq1mF4Xd2zOoXXg4wT9rRi8KtmcNdJUagDby/lANdvFpQS+KEwOzGh1CUaTPFH19Q8GN0Lc0GGXWWyKIkcfefR7FL/Y5n4F9ZXNXG7zszc+xKIvLcDTp06oYxWcbD0QF1xvvtlgLwIDbX3L4z0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B36kUpsT1XGshMpNH+jMbyLkC7GkQN7YecbbGQB7Jlg=;
 b=n0SNcSKTixqibQWjLGE06HQ34Rf/nUGLBks9yfsx1+DPYUB9jznhcCZCONJIZ4WNmDU/s5pPaIS8LJ1o90zncUYtbA2uW1tqFZJhijABmaAdVTOYjQcRPVw0O/8W6pR/CDQlXBKjLOZ89GT47kRUFKGqFmkN2tKiwmOeQLx5nxdFIecIV5ZpQlcDxbz7w+6dM0P0lwKyVNQ31sw9i3YBkdyJmu7u8XatNHies9Y8yQQCPPkg63E30ZemVn56EXpq3IiNxtcAHpOLjLXP526WjbwOJG9P5dGA2Cy0aCA+sIb83R0GxDdlaXaXeqih6+rRuTqIz476sUoKEN0LEylY9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B36kUpsT1XGshMpNH+jMbyLkC7GkQN7YecbbGQB7Jlg=;
 b=drl0YGefMrUum16ddWM+v45oMRo9/0jaCxzKsQdk2NMYsYaEoRD+xIt2ta6fLLPdsbnXvw/ohHbiIDy1LXxf1G4svn01EWt+ZMC4u7G9k5hef+gUdTE3GapMWFiqvmQQISL1po6RWKVUabK4M5wWLf9sKEIXN3lIWq2NijFBGU4=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3471.eurprd04.prod.outlook.com
 (2603:10a6:803:7::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 13 Nov
 2020 08:17:00 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::607d:cbc4:9191:b324%5]) with mapi id 15.20.3541.026; Fri, 13 Nov 2020
 08:17:00 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andre Edich <andre.edich@microchip.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Kavya Sree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Marek Vasut <marex@denx.de>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Robert Hancock <robert.hancock@calian.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: Re: [PATCH net-next 00/18] net: phy: add support for shared
 interrupts (part 2)
Thread-Topic: [PATCH net-next 00/18] net: phy: add support for shared
 interrupts (part 2)
Thread-Index: AQHWuQyiAkFa4kS3oU2qm8ThTy4Kp6nFVKQAgABj+YA=
Date:   Fri, 13 Nov 2020 08:17:00 +0000
Message-ID: <20201113081659.kkifu6dwxq3gxtpm@skbuf>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
 <20201112181910.6e23c0fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112181910.6e23c0fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8be7ef3a-41d7-49be-af77-08d887ac7ed8
x-ms-traffictypediagnostic: VI1PR0402MB3471:
x-microsoft-antispam-prvs: <VI1PR0402MB34713C9859F6023DF282D1E5E0E60@VI1PR0402MB3471.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cj/HRhZIPuf6y7o6xC/ugs0ZedrjAs8ZIFESg+BfU97mDxB78yC9zT2dJVumJRMfYMbEQEU84yGY2IoL4kCir32GqR2gD/cbXcJbiDrzqm+cl7zwBGxISzlSQpB5+kbsR0JS6xL73vi0KvrX+MEGyEhr64mjfPiL831AKhErl6shSs2rPKVVX9CcyJLDU60pAfkRhrcT3Vry39cbNj956xSFFHs0RZzDzKmH+9JbkaLtEl+0T9xSxHmK9LSCv0ZiJ9nYMzxHztEgUjrePKEkCK07OR1p4Ilo815CIOgLQdmWsOG5dgozyE+G/Bo3drbhnQIdqVL8V4+EgG2oOO478w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(2906002)(478600001)(26005)(8676002)(5660300002)(6506007)(83380400001)(86362001)(6512007)(9686003)(316002)(44832011)(6916009)(6486002)(71200400001)(7416002)(1076003)(186003)(54906003)(4744005)(66946007)(33716001)(64756008)(66556008)(8936002)(66476007)(4326008)(76116006)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: T87DVwItNln+r/oQ8BdqiYLcFNcmfoH3aKsMmiYB9Zj+sVlxH0jJijgtLlSA0d2DG3o1NrbILLmL6icJjz2F8dIeJSRgQ6DeBptjfOE8xc4ZiD0+1+hfHrv+uSWTb9wVFp1dhXysuDT0m6QfreP/05DgEaTGB6p3KwsaVrZvqjXMp31i62HhFLVc//hJ9Vs2wYpAvB7sPnNI+4LsB5nTN5r+M+WhRe9TF/hSOfBmdmtcXL6OUmG0foFLJKJsgqvHW2JFbbc79Kvuvai0QlHIV2RSZ0yM+iqXQBeb03YvaMUmY3jR0Fr98m1KtlDa4JxVTXmhVEqAIfPbSuoMUugCOUjQ8/cslziqEdgYP7NOshcKx7RFrfvhYWIf1jlx/91nDAiG990sYLyuuG4y2AXhN61YGkMyTcnBeHrOJPpxLX9RiYmyQJWigCfurha3X7RX0gFFxesf52igV638yCUUnQMeKzPSgPMrMUz+hvmdKZlyXuIpcwefOwa5r9Lja0qHQLOXtNo5uvKXnFBQIc8N7HF+kBksI4H6nk/1pZw1GwBNLiGKXnoE3WGhfsiBXJ/nyfrvVxJchFdTk5aWcrjOEnAyiKXTl0V5Yya8qtk6PyPAiTZF28PtDLI1ljRLuK95t46Hs/09blUX48GeeqVJ7Vzy9FUMjiL1xqxuJetJkbRjwyVHSQASQHwsKIKfso8C/bw2ZmfFOpk0voKsGnfV4gxwRzyVR8S5g0sXv60yvaDQBsxSYBNMcXpMvyZZ1Bq4r3xzaLEBAslg968w6Qd4TVbedYbeFoC9a0UPitMNtmGeYO4UyW6XBopvAm44RP4F6Yu7AJOZ6Bsd7U9aegBDeuqGSTnSB2FSwXtzv12DJMmpnnF8VGQr1Ncd5WxZjjTOTlSl6cS3BkCQRM5M9j6vzw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <396E2A3D7B38C940A23A4FEBD5602DA8@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3871.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be7ef3a-41d7-49be-af77-08d887ac7ed8
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 08:17:00.3870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TBPd2xEsbdcfkuZyGbeWo7iyOh1982sKYu43eGU/PPwTVT065cjkpGmtVesTG8/xlmfvWt39hzpOT+uD85gLng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3471
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 06:19:10PM -0800, Jakub Kicinski wrote:
> On Thu, 12 Nov 2020 17:54:55 +0200 Ioana Ciornei wrote:
> > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> >=20
> > This patch set aims to actually add support for shared interrupts in
> > phylib and not only for multi-PHY devices. While we are at it,
> > streamline the interrupt handling in phylib.
>=20
> Ioana, would you mind resending? Looks like the kernel.org patchwork
> instance is way less reliable at piecing series together :(

No problem, I'll resend.

So from now on we'll be using the kernel.org patchwork only, right?  I
am asking this because from what I can tell the ozlabs patchwork was not
updated in the last days.

Ioana=
