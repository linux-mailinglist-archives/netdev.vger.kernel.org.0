Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE72D105A37
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKUTOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:14:06 -0500
Received: from mail-db3eur04hn2058.outbound.protection.outlook.com ([52.101.138.58]:44166
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726563AbfKUTOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 14:14:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fytafEVS+qdpCJi8ZOYAXxA0H6OYw/Y+aPVc6+MOsbO2IhuXgb68YPe6F+gXGO8PXxPLZLoye7fjUoRGg2ubkd/o1vTziVMzzuikqblq5zt4cFaXVtQahuaXiKG8dBzEHI+vXeySjdm97VhXSMcakYR8KTS2NKyYqPnhQQRFxO0LnZNY8vggN915Kyjm7laELrNzoNEdYFnFkNQ5rVDcB7SHOzsE/RGI/povBPxG2DX14NiowkIymQ1YThci5CZGmrv0jbXsD8DITIUpZHD5zxhw3fajwqH2h7QBDVlcxk+76SFv0g/pn745grUEupfga+ye0e5rGg8Ed/d+58UoDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCJWAwdhRRHQcDamVd2+3j3JzYdQUHOOTB54J/h2YY4=;
 b=cAraCnCDHpGUgUDEL9r8ArH2tUA6PdKPeah1abFlp4j6RSBONifBr66Rj7SOigHzFy/NEYUjr6AjOeBu77NCNdzwdwn853gYk10P2/l32409aZlfKN3ub0zztKA+rhueDZG0nbRBAZZg6vfwZ/j9+ZVCRUuwfU1jSAqN9XSO1cno0Xg2y/We4TxLzpr9XjDfaKkYS+nqenqKpvcNtDNnWMO0Y7YGQFTwcunoQdvtwotzln0Nn5VNu3iPmkI54sk5VLvzQLxkkPjLqMtU2nVRpV3A+mP5toa5xWDhLoBh7Lf9O2SO3S/GOgFVpok3b4OfWOzuB2Cd2nc+LVDY42WHqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GCJWAwdhRRHQcDamVd2+3j3JzYdQUHOOTB54J/h2YY4=;
 b=dY2hABe/fpQHW4d5oKFdZiYLkP6hs45T1gOtkvWpqjWe3W5B9XR5tkuhXKEr5qTYc/OtrBZNMAFXtZ3pK27AF9mVpOL1z83/u/EXeq5B7uFDGJ54W4r4ymJ8aLE+xaMDtWFNWdfqLfWzc1qXmop3KKam0aq5c1yXdYmzFFxw/CE=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3552.eurprd04.prod.outlook.com (52.134.4.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.26; Thu, 21 Nov 2019 19:14:02 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::5cc0:798:7cb8:9661%11]) with mapi id 15.20.2474.019; Thu, 21 Nov 2019
 19:14:02 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2] net: sfp: soft status and control support
Thread-Topic: [PATCH net-next v2] net: sfp: soft status and control support
Thread-Index: AQHVn55B+2XHK4O/1UyEg1IaXClvUKeVxsjwgAAJ6ICAAB+UsIAACtWAgAAAKrA=
Date:   Thu, 21 Nov 2019 19:14:01 +0000
Message-ID: <VI1PR0402MB280036234DA7E153F0C48A97E04E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
 <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
 <20191121162309.GZ25745@shell.armlinux.org.uk>
 <VI1PR0402MB28007002CABED79C95DC093DE04E0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20191121185457.GA25745@shell.armlinux.org.uk>
In-Reply-To: <20191121185457.GA25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cabff7a2-8704-4564-e82b-08d76eb6f80b
x-ms-traffictypediagnostic: VI1PR0402MB3552:
x-microsoft-antispam-prvs: <VI1PR0402MB3552A46155C739B348D4818EE04E0@VI1PR0402MB3552.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0228DDDDD7
x-forefront-antispam-report: SFV:SPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(346002)(376002)(39860400002)(52314003)(189003)(199004)(7736002)(3846002)(81166006)(54906003)(81156014)(6916009)(229853002)(2906002)(33656002)(7696005)(76176011)(71200400001)(256004)(508600001)(305945005)(186003)(86362001)(102836004)(26005)(6506007)(6246003)(11346002)(446003)(66476007)(14454004)(76116006)(71190400001)(6116002)(44832011)(66066001)(74316002)(99286004)(316002)(8676002)(66446008)(66556008)(4326008)(66946007)(64756008)(5660300002)(55016002)(52536014)(9686003)(25786009)(6436002)(8936002)(989001);DIR:OUT;SFP:1501;SCL:6;SRVR:VI1PR0402MB3552;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qHKprKlHftKmWsocTjElAPD3ZKyszioN5yhBixLTTSYpvsd5QUe2QzN1j2minC/j8xdX8Fq5k3ljoTQepyiFJpop4+i8n3QGqRI+7Gkfy1y16ZEvIUl0wE4P8AP2oiK9JbSk08mjfsRd4/pyjvTb9T2Knl6N/YBd7b9BIYu7s31UUuLfDUj5CsZLIYgu3mdPORqOs0rFhcwfPU7GbhL0o3K1uvqe3cnhkkUQCJ3yw3XR2b78a1k10/SyVhpSz+9ZcYAnnjtj9QDGmqQ/FyUjXq4AHMGMJfFjKTS+Zdamnl2MOgogLfKOwHl5QgUZohSAXRQgsWk2lwLdIg0FzYkO+QyXsShp1TKgOoJArYjQRcrac6STJsF88zUGWeMYKft8z3+SS6X9rTks0Qyg1NDqBxxXEpMWR66o7cxhhGM7v1zrBkNY3NNSBozCJF+I+Yceh1EpJjrSBIRcT6xwduUMhJsSWLcyEVj/gCJ/Ac22AMGJDd5P/E+BngMxTcqPh19DEUtD5BP0gb204HIoeCZJJKpwdI5hMzfKnrXJcG6fftJGorJ9z31So9AMw7SyJEDIosIf4D89xcT2mHTCVstQANrE3fGc52rqNzrjHC808d+Ro/lwY7kkZJDjWqfH3b53fxZoVUFgLq/13LCoV+PgQvfX4kVvGcXreS8G12RqYT/wArTipK0z7tyVEs4J2agUpVxc0HomfIGgHtYL5LLucA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cabff7a2-8704-4564-e82b-08d76eb6f80b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2019 19:14:02.0317
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 97skI6c3NQb0ouM4OTzEpN2fCbGfbnC3AmOazkNtAyJLoSzVuzj07qrzDj1IzFU/efCTWLaLvjqu0qC5ZwX/MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next v2] net: sfp: soft status and control suppor=
t
>=20
> On Thu, Nov 21, 2019 at 06:33:41PM +0000, Ioana Ciornei wrote:
> >
> > > Subject: Re: [PATCH net-next v2] net: sfp: soft status and control
> > > support
> > >
> > > On Thu, Nov 21, 2019 at 03:51:07PM +0000, Ioana Ciornei wrote:
> > > > > Subject: [PATCH net-next v2] net: sfp: soft status and control
> > > > > support
> > > > >
> > > > > Add support for the soft status and control register, which
> > > > > allows TX_FAULT and RX_LOS to be monitored and TX_DISABLE to be
> > > > > set.  We make use of this when the board does not support GPIOs
> > > > > for these
> > > signals.
> > > >
> > > > Hi Russell,
> > > >
> > > > With this addition, shouldn't the following print be removed?
> > > >
> > > > [    2.967583] sfp sfp-mac4: No tx_disable pin: SFP modules will al=
ways be
> > > emitting.
> > >
> > > No, because modules do not have to provide the soft controls.
> > >
> >
> > I understand that the soft controls are optional but can't we read
> > byte 93 (Enhanced Options) and see if bit 6 (Optional soft TX_DISABLE
> > control) is set or not (ie the soft TX_DISABLE is implemented)?
>=20
> At cage initialisation time, when we don't know whether there's a module
> present or not?
>=20

I was not suggesting to keep the print exactly in place.
Anyway, it was merely a curiosity because it can be a misleading info in so=
me situations.

Ioana

