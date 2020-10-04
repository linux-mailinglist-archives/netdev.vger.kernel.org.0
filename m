Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4638B282D9F
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 22:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgJDU7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 16:59:50 -0400
Received: from mail-am6eur05on2084.outbound.protection.outlook.com ([40.107.22.84]:48225
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726313AbgJDU7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 16:59:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9+wDbtJCH3c2Q9iIjd/+W7U8a85HEZu8HM/VAUsuUeRkAwQjygogj6qlwK7FDMBTQtxUECbm/eRosQ9bZ/pWC7qBMsPCr3uz+0ui+qtvoag6V/1YHxWIKpCHL7m5NjSp6yB1f2xIAOmmW9M0xa+eAu3B/MaHKp15w8bubzvJvZZadyhje0X5MuwlDy/IznTbTqeUgmPUXiKT9rMlC8/9ponD8m4cCsY9uuQcNNkkmpUDPnwlOdpiSbNGo5Ri7ZP2gfO4HXlWOR+0+qj22CsnbTyjBAQLi7lkw5Chzi5iV7yBodNfcmIMKN1hiZ5bIMvygDteDpg+IbuNbXWTIoyyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r21jUEnmAJO41UlKgsUn2H/XpNsH+bImLPNrDxay50=;
 b=USscZcJv8BOSKGd+lKHwPlIr1j2QbvR3Fv9U2FNIFznKopj8UFGEw9v8dym8XkKdf7lgleBmCbH8RMf0ErhOFMYEOa5yMlA1NY9L0MyuYJ3qEH+VZOlW/+IhuuzYHK9DgYjZkseRx3UmLYucYBsJwvVTgNnfXTIHL6TEoMCPmPYusZ43XnOgrWQiBwJi6hvNAYw+GfthiEg0lpEdPMaqxYpAFqN02VXB2bTs/4JEFxT+1f+jZv0/bldkca0e9gG8iIAEJDkWZdonZF/a1SkNnFSEOQVZAaPxTvKScMmAJh7h3JLQfkjwJaYxi+n8faIln2XvC0JSuZlb41+MFCGUoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r21jUEnmAJO41UlKgsUn2H/XpNsH+bImLPNrDxay50=;
 b=NYHLzpjKdxd8tc9nP0NKC25Ucuaja0PbOX6ryniETlAIchhOSv3fDxHZNMViBOthF2cEwxSw/B0hliSSLCCxBiWSN/d2Ozc9liQFiUBDMWLPaqrsjTZOHrylJYq77//wE2Mydk0lu/nEYu6nyTdHUW80gXCkXd5j5xIioCCe8Jg=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5342.eurprd04.prod.outlook.com (2603:10a6:803:46::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.37; Sun, 4 Oct
 2020 20:59:44 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.042; Sun, 4 Oct 2020
 20:59:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jonathan McDowell <noodles@earth.li>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH net-next] net: dsa: propagate switchdev vlan_filtering
 prepare phase to drivers
Thread-Topic: [PATCH net-next] net: dsa: propagate switchdev vlan_filtering
 prepare phase to drivers
Thread-Index: AQHWmQhdNPfPSG6bx0yiNWnWxHbqy6mH8ICA
Date:   Sun, 4 Oct 2020 20:59:44 +0000
Message-ID: <20201004205943.rfblrsivuf47d2m6@skbuf>
References: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
In-Reply-To: <20201002220646.3826555-1-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.229.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 43306a73-d7d2-4fd9-d66b-08d868a86c02
x-ms-traffictypediagnostic: VI1PR04MB5342:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5342C3D76459DC766FB13C9FE00F0@VI1PR04MB5342.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xrCI/Kidmy7lnQxum2PeXN1F1uK8sreDuQ3K328cfFoBOQTceZsdWNKDfnUDWB6mSDFYPlxAhITbu8Fj2BRXvyg7JlvSesw0gQoKZHPgOdVd1ZU/OkSU2yw28IJ01Qq7xj+gaHg1LRHUf894VR3OMyAZ2jtLyxP3vAvujK292+fOCL7KcMdj3N73js9ggz39dAe92pao2jiB0WZZETEa69XDzEUTtGTW+B9JnEiZxl4RNF134uNUi7NEWoBpJhGOKhgtp+GvyWpTlP2Zpr71AH/jmnSdXWVcHniiHkHxLlcIR14KUIRrKgAM5OIViUjcLBoY0Ntha8Tv5eX8K5JbDw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(376002)(396003)(136003)(346002)(366004)(39860400002)(8676002)(7416002)(66556008)(64756008)(66446008)(2906002)(5660300002)(91956017)(76116006)(66476007)(86362001)(9686003)(6512007)(6506007)(478600001)(6486002)(26005)(1076003)(8936002)(316002)(66946007)(71200400001)(83380400001)(54906003)(110136005)(4326008)(44832011)(186003)(33716001)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 2W2EIMJyuZjWO52nGtK0vOb7rM/tgJWvBzQIOAxdLsWpnEq9iuck1ZDJYXa2c5jk4vQFdteBHIoR/MKDz745W3tKkwi80acFSn+5T7RYIhxe9N2HBhkzolsAih4MptMxwQwAgzCJhhyrj2hKvUxVDGLINh6Jt5G1M4FojANVDcT0tSG77473KHMbCmaRwWlFsnYYFgWk7dGPwFG+S+evqWfgZRXX1NR24P8zR3lESb4nE6LjexsFDssT//WxyU229ZxOwc+poBDqhBPM9atxKmJq1ZOr2QeTgCpd/yrLIFgQ7NpEYTUeBfBfuMyXFxWVWn1e0VNsX7GLrKXLvZfRDzSxYPLWyJWLLXbTHcH1FMAi3Y6dFeLi5IdKUZKXS8SSWwxeqB7op9IZFlmihD4ead4OdO8Rc+fFAih8qr1rsxZaLLXqurF919prAHQXbNSrIIFS/S2YcN81288kvdT0ONBcGhFa0SfL5dTSIK8EezneHpSnjCC1UZwxqS+FGzkOm8+W3tqGQeHpBryaMzGdSmF42tW//Ft7jKhodEjLecoYaShkKmG8E5CaNizNuJg6VXDzc/vwoJqxOp9+54cFyP5kP0+8Cbp8fUrF2XXfJfuhUw0LBHnhxA0rCRRiZIEvCbptBqTzqAarc1F9Tjvt4w==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B7E12567FA97C148908514D237598C0B@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43306a73-d7d2-4fd9-d66b-08d868a86c02
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2020 20:59:44.8065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: By1ATEMDUUFESrgA+47n7xeFBk9kEQM+4MGBY/96Td+RtkzQ5G/RUwfXoz/Rx/nIFnZjktUWPLsYV5swAC/XXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5342
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 01:06:46AM +0300, Vladimir Oltean wrote:
[...]
> ---
> The API for this one was chosen to be different than the one for
> .port_vlan_add and .port_vlan_prepare because
> (a) the list of dsa_switch_ops is growing bigger but in this case there
>     is no justification for it. For example there are some drivers that
>     don't do anything in .port_vlan_prepare, and likewise, they may not
>     need to do anything in .port_vlan_filtering_prepare either
> (b) the DSA API should be as close as possible to the switchdev API
>     except when there's a strong reason for that not to be the case. In
>     this situation, I don't see why it would be different.

I understand that this new function prototype is not to everyone's
taste?=
