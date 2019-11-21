Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 975B2105999
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 19:33:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfKUSdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 13:33:47 -0500
Received: from mail-eopbgr150053.outbound.protection.outlook.com ([40.107.15.53]:61982
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726541AbfKUSdq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 13:33:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqPLy95twvTQvxk3Tr5f5SxZ3iJZum00vwhHbvsrXDFKUGUO84CerCo+fQB34aM9kik2OB7Vk7pyytKoI3DgcJzyrgV9UnkuJn6loCAdqp0+a6mNoo6lPQpuPBfsVeGR4lszcrHw2KhuDHWBowMoTrsyPnnGPyfezFYxfni7Z9OQ/er88d9aITdD5/82ntdEPxi1hmhlsDVLCGnR/9p+EQz1g+/xmb886rUoRU6RfnzK5jTEEF1HP010HXLkiSSdzd51/J5WGZDNOy9xn/sHEXtX61435FSfAqgDTxcZDGlVbvKf0BpWVw+3FfQ9ojw00IhKtilrwYuC0E90oug1EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arKGob4EKNjYMRQwY0jzHi+N1H7JTTHUt4l742LVkcA=;
 b=ASCtYiDYy634LQ/s0dKkRl9CMHUL0VTxk/VpwcLRHtRs9yrDpjFwM0B8Ub3n/SKk7bVC2i7WuK76mQEGuRDBJ19S+d8yPTWMjybdY8WpO3kLv9Drl1lm4dWYLmoB5oFUaxYe2Bla18jDu9XPHOJGsOIaPer3jMdiWyI4oDuojAqxBtImRFOSAmmUaUkIQJnXoK772OhHDe66+Jxnez5D/y/KJUYtvszQqsa6v5fE6248JlaevMZNNqItzgm709YOJ6yu6NjZkxI22WYu7+xjWzU3T4NoXp+UBcMeFtBqVt81nkdikQcDt9DWjFzdhHMnCxIKAc7zjj/LhDHQkw8KBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=arKGob4EKNjYMRQwY0jzHi+N1H7JTTHUt4l742LVkcA=;
 b=kccdTz/KbKZCL8IJhni76XpRWHiFzwcAMTjpitaylfx3SEKu+mNidWGnS6sn3M/WIaOKV4+yYGAMItpgQHXzOUxpWWi7BurFBiufcrh1m9n2Y2D9lKPW7pQhd4X19rsVxtn2M8QBsknsBQHrboze0wLqLREQSQMgDG+GFZYSQhA=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3679.eurprd04.prod.outlook.com (52.134.13.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Thu, 21 Nov 2019 18:33:41 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661%11]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 18:33:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2] net: sfp: soft status and control support
Thread-Topic: [PATCH net-next v2] net: sfp: soft status and control support
Thread-Index: AQHVn55B+2XHK4O/1UyEg1IaXClvUKeVxsjwgAAJ6ICAAB+UsA==
Date:   Thu, 21 Nov 2019 18:33:41 +0000
Message-ID: <VI1PR0402MB28007002CABED79C95DC093DE04E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
 <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
 <20191121162309.GZ25745@shell.armlinux.org.uk>
In-Reply-To: <20191121162309.GZ25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc5776e1-fbd8-4e0b-a8c9-08d76eb15544
x-ms-traffictypediagnostic: VI1PR0402MB3679:
x-microsoft-antispam-prvs: <VI1PR0402MB367954F2F17AFBF34722D3C5E04E0@VI1PR0402MB3679.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(189003)(199004)(14454004)(6916009)(54906003)(7736002)(66066001)(99286004)(86362001)(316002)(305945005)(508600001)(74316002)(25786009)(102836004)(66946007)(4744005)(66446008)(76116006)(6506007)(26005)(5660300002)(229853002)(66556008)(66476007)(9686003)(4326008)(186003)(64756008)(71190400001)(71200400001)(55016002)(6436002)(11346002)(52536014)(446003)(2906002)(7696005)(6116002)(8936002)(3846002)(76176011)(44832011)(6246003)(33656002)(8676002)(81156014)(81166006)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3679;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8XUq0Ei3nkkXtEkRrzVPWI6fdRaCDPa+ca/iIfXowk2RtE+w4ZdccOt73xnKvu4uqNC9mWfYDeVZxZbAUm6om0ly4NV5S5rSj8o7HOntydfkCnMaAY81F281a9F6/H26wuNZadgrwn1IZHOxAmlC+bsEDnm7qvlMzOJd5EmPHSKySSruLYUoeYyWhNIbrBkjBJFd11KBb9+H5wmzu2ICmpmLOM7fPTR/VRNutwMv1iM2dcrFnZYlN190JviDO/yqIl3IkRqDuNXd3lBBOZr68gmgddlTOMibn4SZFMQdMMA417wQywBvecexFrHDsmU+n4hnCieLxk7b5aM7ozCwvDP6E4EWmdpnJJvChuT5pZ74QRmUQ1hNAaxNSek1/2HVdKtf8oF7Xd7MizA4CMlhQliuFQPfoSnaC78zKYYUowKuYMggTBF9UAobd/8ftuZy
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5776e1-fbd8-4e0b-a8c9-08d76eb15544
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 18:33:41.3904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LVSjfAPmAJgCJlWAzWw7JBqJpA8/9zPQcvJNcNcJzmXI3gZY09mwF2SGFzRsm83JPe1H6aisvYqNea9Ja9trxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3679
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Subject: Re: [PATCH net-next v2] net: sfp: soft status and control suppor=
t
>=20
> On Thu, Nov 21, 2019 at 03:51:07PM +0000, Ioana Ciornei wrote:
> > > Subject: [PATCH net-next v2] net: sfp: soft status and control
> > > support
> > >
> > > Add support for the soft status and control register, which allows
> > > TX_FAULT and RX_LOS to be monitored and TX_DISABLE to be set.  We
> > > make use of this when the board does not support GPIOs for these
> signals.
> >
> > Hi Russell,
> >
> > With this addition, shouldn't the following print be removed?
> >
> > [    2.967583] sfp sfp-mac4: No tx_disable pin: SFP modules will always=
 be
> emitting.
>=20
> No, because modules do not have to provide the soft controls.
>=20

I understand that the soft controls are optional but can't we read
byte 93 (Enhanced Options) and see if bit 6 (Optional soft TX_DISABLE contr=
ol)
is set or not (ie the soft TX_DISABLE is implemented)?

Ioana

