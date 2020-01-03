Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1045012F2D1
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 03:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgACCCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 21:02:55 -0500
Received: from mail-eopbgr50085.outbound.protection.outlook.com ([40.107.5.85]:53059
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbgACCCz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jan 2020 21:02:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RkSksOLlmVYja0gHYTMDbaIZSjVIAsAwIyz4CL/zz1c5+A+Rc+Lx+9bf4I39AfxMRHuT49GJ9pcspaTn03P6jWBL2Y0ukUgEF3lUPmOVOJprcYuw4O4L1G0kqk26TSvoC0WQR8VSdBPIvAVWTIYnoSaGynF9qKMT2MA0GKB4eaHEnLMdorn857NoC10vXpGQRWr9faoUZI+IP+YmQUqCNhVgveO6wma4XEqUWDGytoRc98kf/+EkYJpJQl8p/1QCsqVIGCbHBMN2Q688yTKWkQlutiMZumj4IVHa9yPzXnY61dnyS6Q8SayK4ggJnbLo4p2J28sPrEF+XhCMnqWKVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YorcgK45xAtWMb6zgWM+8LsGYdSj5Dv2WJDi9VkktM4=;
 b=bbRduMoOiKBYLBFtAGB2d3nSQnGBqhKryChoKUTYmGEC5ZS424LoqdgwtEppTktnG93pPNdPy/G0vzHr6j/fmH/mVx801TKY+yvQqnBlViKrUdjxQDJzaREJIZuL+5dp2e+OF+dc4UAF0YX1vTSXmhjAPLVscLpQRABI+lvbM6djee7qrfLsZzxsrQP7WRkb3WvrM6X+PqLJ6dsSOPQZO2yGAPiglRXza0I2hw8alh87mdetmk/Zl+CNY095tM9F5aRunya9ePndxuU1efE702A2vliGh+7VvlKMoQapn/W6is5vkgOZtcNjwNnX/7ctlkc/ATfHx+zDeFQxvZxdNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YorcgK45xAtWMb6zgWM+8LsGYdSj5Dv2WJDi9VkktM4=;
 b=Zj0SMD0Xodp+Zyjypcky4iSLnnq+0z0JcQr5FybqFg06JMrS0Yr49EEYjapRqrZ4fLT18gG0C5ogRAHK+Y+5rFoX3crHLGC8NFGk/rmNs2IYZZ5COBNs/0oVIwnhdI5P9nDT0cUgB8z5Jeqez+/eizV9YCWVo3CBIconmX5hhMI=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3872.eurprd04.prod.outlook.com (52.134.17.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.10; Fri, 3 Jan 2020 02:02:50 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::18c:4d15:c3ab:afa6%7]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 02:02:50 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>
Subject: RE: [EXT] Re: [PATCH net] net: freescale: fec: Fix ethtool -d runtime
 PM
Thread-Topic: [EXT] Re: [PATCH net] net: freescale: fec: Fix ethtool -d
 runtime PM
Thread-Index: AQHVwc/wufMFt4O9PUCHGbJyLpNohqfYHw8AgAAONHA=
Date:   Fri, 3 Jan 2020 02:02:50 +0000
Message-ID: <VI1PR0402MB36006DE84ECA9E5EA742CAFCFF230@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <20200102143334.27613-1-andrew@lunn.ch>
 <8658c955-eaac-f6d9-5fbe-b8542e26d141@gmail.com>
 <20200103010134.GC27690@lunn.ch>
In-Reply-To: <20200103010134.GC27690@lunn.ch>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.67]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0bac9756-4dda-443d-5b67-08d78ff10968
x-ms-traffictypediagnostic: VI1PR0402MB3872:|VI1PR0402MB3872:
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-microsoft-antispam-prvs: <VI1PR0402MB3872B6AF1A4FD660A2C0216FFF230@VI1PR0402MB3872.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(23433003)(199004)(189003)(186003)(64756008)(26005)(76116006)(55016002)(2906002)(66446008)(66556008)(81166006)(478600001)(66946007)(66476007)(4326008)(81156014)(8676002)(8936002)(6506007)(7696005)(5660300002)(110136005)(316002)(54906003)(33656002)(86362001)(52536014)(71200400001)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3872;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: b2w69XsYjiMBro5kTInroqYsa2zRIxnAnBspqX3mSgjIyWJ4nS8YMgU6WxXCGSglS5Vif57IkNzmEaLkKelgft/WAiHvkcuczh79JOR4+9G4RPzL8SNRg+YUnTBIhf2PSY2m43RWXW7LDevy/Ffg87bPoIzesa/1eofXFBN3vsZ9wl9+S0mBQUrtKRkrC5vrZxdSBRXHQqBJ4hyvcAxYNH+RbhBH1dX3u6dw9C2KsGdq7BaExUPEyGTbS0l/KYjPvvuIHayVQw+4xfMcrr0QbTImMKGRaGZ68PXn9IAsemsiq4RpRrZVNFbQJR9In05T8qJmF+ijiZQRQNQKtO1B/SWpqnEuLq7nTM+qOsd8i0tgi/QXevln+83qaLmdQE8CImURhMar/2VHvsovkgnyr0FMsbxlUKqqqQezRJkvC6K9BG8mOqjeSIBPV5OGmLmqzMoiS5mGRBv/I7x90Yeg86NKDWeQX3nAXAlxeZrDOu9Do0eg3NOszbAYrxeYQmw7
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bac9756-4dda-443d-5b67-08d78ff10968
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 02:02:50.2529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vUjKaGLP+p6/j6XBq4VRQyYd1f3bE67HYdwk/w+uZjqaapGz/f71XI1YYXI98oVpcRYBeyjEuu2QlZXSB4VhxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3872
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch> Sent: Friday, January 3, 2020 9:02 AM
> > This fix will do, but you should consider implementing
> > ethtool_ops::begin and ethtool_ops::end to make sure this condition is
> > resolved for all ethtool operations.
> >
> > For instance the following looks possibly problematic too:
> > fec_enet_set_coalesce -> fec_enet_itr_coal_set
>=20
> Hi Florian
>=20
> I did a quick test of all the ethtool operations which the driver support=
s,
> including setting coalescing. I did not exhaustively try all possible coa=
lescing
> settings, but the ones i did try did not provoke a data abort.
The original design is that driver power off clocks when net interface is d=
own,
use ethtool to dump registers are not allowed. Only .get_regs/ .get/set_coa=
lesce
are allowed when the net interface is up by checking netif_running(ndev).

If there have requirement to access registers when net interface is down st=
atus,
It is better to change the common code to enhance ethtool_ops callbacks usa=
ge
to support ethtool_ops::begin and ethtool_ops::end for all net drivers.

>=20
> Still, it would make sense to implement begin and end, but only for net-n=
ext.
>=20
>         Andrew
