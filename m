Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56FB31E8B30
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 00:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgE2WUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 18:20:52 -0400
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:8322
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbgE2WUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 18:20:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXrWPr1mHScRFzI++0JpG3aJpo5XpE6CKnCogZsNdtOG+jZtFCl2U6PKrFGj49PDJNDXuniT6zaSWUQ4urTifCOupuzeBZMeOBamzo7PB8KDczrWA3V2koZitIykXzHXmUUeJQERGH4CN6rupeoRI9Cd8D1cWWG11LYWa3+Wa69O8KWjzIPfA0y18FJqo0vFzwYikAJrN9Un4o1ey1OhNmkBrXVj8GLrkIXHiekjAjijADaGbzA/Z195FZCDcLzKyskCQ3KhKC7VCj4IeN0e83IBcLtWqxz8ZpTYFx4bxd/9Wn5O3y+xbHsgrvYh6MOfw5YkCuPuefARutKAd78e1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDx7I1tX7R0oexTB9y5TXJn8aBKPWYsj695+Q1nt9Vg=;
 b=BoVAnR+t6q3TvXLp8LotjBSJFYTwDVENVVfsb10PSAqUDN0gdbUaxlEcRJOaSg5Srg0BTWv4CS1IxnhMYq/8y4NhzQdbC3koEjpcxcoY6RMcVWf0WIaJ32W1DIJ/pw/xJSBVbTi2PJXNAtvXfSCqEzMOdCx8s2Fa+VlM0iBdT1mstbQRNNc2cxQQJQQRi8RGTk+Zz0vaEAVWQySBjc4KbwIUcxWSLBTScYAM+I+UEv3Stdg99gQ+ufyxAI5t68XPmfLB2hN/rin+y2o32IKlhIYFQGHSyY4tajBCzYyFNw7vxGefJ+QYHZgbNkoXVxKePKxuOUiUe3G2knSpaai7BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sDx7I1tX7R0oexTB9y5TXJn8aBKPWYsj695+Q1nt9Vg=;
 b=oGKLqclM/rcXZ9pgkXnfZYuL73C+c3NWojZBOJyHbZEC66UydKRBZcduKK9BRa+tcH2c3w4dhY2JjBX+Es/iwlHVL5T0yu1l9dqVifvVX6E1sdH4qUqMLt5+v5ibaBkzl84uS4TmeweLoyaRtBt4x0WeyC9vw1Y/L5HDLXeURrs=
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 (2603:10a6:803:16::14) by VI1PR0402MB3326.eurprd04.prod.outlook.com
 (2603:10a6:803:8::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Fri, 29 May
 2020 22:20:47 +0000
Received: from VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0]) by VI1PR0402MB3871.eurprd04.prod.outlook.com
 ([fe80::e5d7:ec32:1cfe:71f0%7]) with mapi id 15.20.3021.030; Fri, 29 May 2020
 22:20:47 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Thread-Topic: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames
 based on VLAN prio
Thread-Index: AQHWNeDcv8exh059skO/bWrzCNqeMqi/kCcAgAAFHJCAAAbLAIAABjnQ
Date:   Fri, 29 May 2020 22:20:47 +0000
Message-ID: <VI1PR0402MB38715BFD2DAB1A70B1F0F6B8E08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
References: <20200529174345.27537-1-ioana.ciornei@nxp.com>
        <20200529174345.27537-3-ioana.ciornei@nxp.com>
        <20200529141310.55facd7e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <VI1PR0402MB38715651664B9BF2D002DBDDE08F0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200529145546.0afa3471@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529145546.0afa3471@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.25.147.193]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7326fc44-b85c-48f8-ec85-08d8041e8986
x-ms-traffictypediagnostic: VI1PR0402MB3326:
x-microsoft-antispam-prvs: <VI1PR0402MB3326F287CF49FFF1DAD6EC54E08F0@VI1PR0402MB3326.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0peF+gqP8dnqF94GfnGfRa+YlWH0iZPXMCcglLy+/YDbIiIyrposLGbyKNCT1b0P6H5ttx9qHN0rVWTehMIJ0cJTBbd99iGNbd2SAZiW00wIQSUs/LX1ZUoZ+J+74JiCGPqEvMrpRWLASpLmXOcyYLcRUXygJd7VAaiwz4u5bvlajIxpWXKEI4fzX+CNAz2J3k0N4z3QzEUjc0NeLKpqN90z/T1NlaHGFS2eI0W2xhzXxPqRJcjEvIUjwnZbaeoMiKbvwZamuc1aT2/aEO2Nyzy2O8GmoJolfNQb3AULvAEL+1X2KwQZuSNxkW//IDDc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3871.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(376002)(39860400002)(346002)(136003)(26005)(52536014)(54906003)(86362001)(2906002)(33656002)(76116006)(66556008)(66446008)(66946007)(6916009)(7696005)(83380400001)(6506007)(4326008)(64756008)(66476007)(186003)(8936002)(8676002)(71200400001)(478600001)(9686003)(55016002)(5660300002)(44832011)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Z6+dFOx2+CdkiK/b2AgdrAyuHJZWOn2N4XekjppszZ5kmsLfqRX9l87a+VAGxtFKqbcWHf6tLMtcRUZxk6sOGzxio5N+IGp401TvdSMQPD7YqUg1ddUK9288kvg0TtCw7hmLic1U7kbP23eRPS+xDevu9gIaE2rBYRzElu9ITp+u5TF3G67mXqkDK6/isqWwORjfEYDZtKKx6qUhtXmU6zFeVAVOTAJqYnQlA1tUgalB07gVmeP9PRaW0S/bH/f1UT0YMnoA5vN2f/6UmTO3agxk89M1K8RpSdH7VG8h1PFd1A0gLnKhrySce9pLu3DwwpVp2S33MKqyU7vXT92OHCKCVIq4YQEUv6umSr0zob0awPOtUQTaat7nsOp7qR2R5KkCcMDRmVEbccxm973MtWCVmMJ5WJYk0a1Mi3stPBduXAN6RtiWCjGevi6lWI2edAUFaX/eWxpe+PkwdRRShhTSecr5M1YSVsO6dVY58hbDMY8D/ym18qWicYzD/oRF
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7326fc44-b85c-48f8-ec85-08d8041e8986
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 22:20:47.3947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AZg99ghj/meZc5XN3HW7szXGNbEEclTr4Gus9+fJam+qzYwQNKLjUSbbTSbapFe8OxXQeHvWPqzjF6CXOqBaMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress frames=
 based
> on VLAN prio
>=20
> On Fri, 29 May 2020 21:41:38 +0000 Ioana Ciornei wrote:
> > > Subject: Re: [PATCH net-next v3 2/7] dpaa2-eth: Distribute ingress
> > > frames based on VLAN prio
> > >
> > > On Fri, 29 May 2020 20:43:40 +0300 Ioana Ciornei wrote:
> > > > From: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > > >
> > > > Configure static ingress classification based on VLAN PCP field.
> > > > If the DPNI doesn't have enough traffic classes to accommodate all
> > > > priority levels, the lowest ones end up on TC 0 (default on miss).
> > > >
> > > > Signed-off-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
> > > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > > ---
> > > > Changes in v3:
> > > >  - revert to explicitly cast mask to u16 * to not get into
> > > >    sparse warnings
> > >
> > > Doesn't seem to have worked:
> > >
> > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22: warning:
> > > incorrect type in assignment (different base types)
> > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    expec=
ted
> > > unsigned short [usertype]
> > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2761:22:    got
> restricted
> > > __be16 [usertype]
> > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29: warning:
> > > incorrect type in assignment (different base types)
> > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    expec=
ted
> > > unsigned short [usertype]
> > > ../drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2780:29:    got
> restricted
> > > __be16 [usertype]
> >
> > I don't' know what I am missing but I am not seeing these.
>=20
> $ sparse --version
> 0.6.1
> $ gcc --version
> gcc (GCC) 10.0.1 20200504 (prerelease)
>=20
> Build with W=3D1 C=3D1

Thanks, after an update of sparse I got these.

Fixed locally but I think it's better to wait maybe until my next morning t=
o send a new version.. maybe there is any other feedback that's needs to be=
 addressed.

Ioana=20
