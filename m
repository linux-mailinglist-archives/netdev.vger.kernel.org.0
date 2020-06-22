Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65A42039BA
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 16:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgFVOj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 10:39:58 -0400
Received: from mail-eopbgr130082.outbound.protection.outlook.com ([40.107.13.82]:61695
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728293AbgFVOj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 10:39:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NtbgFHYlXsR5VYu1z/9q5tePuZd5gq1tZ0iCiRzlpQab6oeb8LuZTUPQWacQXUhkfQwJb57UnSjTYsx6wVbSKey5lhV6cFBQnNjF2BZbNUx5zuviC/SBnYs70vRrO5V0I3NQdkYx8PBiy4uP0wDKQ5eIf8QCRl8I2lEzkmLBul03sv+Y8Pig9jgdx0kOQDSeXDy1BTcln4AVYoCrrzpPXCnXBmzJcM6VU99KRzpxKJjeauaJZVahSrfiD0Zb3SAuoITJtwAZcxDEylp9P+ZQnehQLV4RnYTX/gIeMZX7M17v/WqYoaWqWgiiVVt5rNcJW2mSpntQe/PQIzAkWAUOPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOTQVPXwol0zHMvVRQAoD5aRK9P8+99oA6rYC5GuLjA=;
 b=UyAi2RaT/ueGQZ0ulHYDAyLeDX53hTgcA6MOuJ97b7XPHGQWwpw5NuFllxbjn5IgC13Exox5F7qyGG0ItX2ANja7uIDfAbROZOEEiAjcEITPzWqRLhktA20K/fWGI3cfCa0m7qrVehjHXOpFIvq1NIL9wYjzOaivlV0AcbCmEIeqrjHq14+HmcGmkl1Ub748pWpgqwsxlzNl+f6eJFX52w31FsMzkNkfUwS2fuSXuCrsjXd7KvOlpPTQodd6IAQshML68sWFn4RtgpnJU2eQjynJcAUMMjmPmN7DAZJVcd1LSIA2wG+DpN1Ru+xHsC+2pkulHPvDC4JydtlIwLnkKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nOTQVPXwol0zHMvVRQAoD5aRK9P8+99oA6rYC5GuLjA=;
 b=ahjrcgB1Q9CfvAPLgGmLpcrl7dNlL/kM/fnJQO4+d73SEkuKGuunhYntgEBqV4SM8Pq8N388/G69fenIs3VrnDJhndYYW+phVfN37SAdMtGPsq64dAZ5grEPNo2wZfntjHbjQQlzkLdeWaD3ehkgxblZbsug494Ixw8lKDIECI8=
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB6148.eurprd04.prod.outlook.com (2603:10a6:208:13e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Mon, 22 Jun
 2020 14:39:54 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 14:39:54 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: RE: [EXT] Re: [PATCH net-next v3 4/7] net: phy: add backplane kr
 driver support
Thread-Topic: [EXT] Re: [PATCH net-next v3 4/7] net: phy: add backplane kr
 driver support
Thread-Index: AQHWSJoOSv10qY8hR027u6Fzd8TnaKjksHoAgAAAoSA=
Date:   Mon, 22 Jun 2020 14:39:54 +0000
Message-ID: <AM0PR04MB5443DAF865284ADE78423C64FB970@AM0PR04MB5443.eurprd04.prod.outlook.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
 <20200622142430.GP279339@lunn.ch>
In-Reply-To: <20200622142430.GP279339@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [86.126.7.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 41b08e4c-6f24-4e9a-98fe-08d816ba20e0
x-ms-traffictypediagnostic: AM0PR04MB6148:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR04MB61483BA6C05C9798EE8AE544FB970@AM0PR04MB6148.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: br6dpLhfTX3pCuz8bnyTjSnMzgwhh3qfejuPYLExIQpqFySPIakAK9Zn+MAf6iVkTzKm4Hoq42VjogvnS7Ggjn/8OVh18T2GN+zB+CykSenMW2KZ0jL4NUdyhYLLGQVcAzYTbF+Av/o5/bLSOsmBmiR/UjMf1REsunP4STGg9buOJ/KrN0+yVnE/u9mbAefSJmwTuVYrd2dLPCUzjGRAmnncY23wVsLAg+ZOaBkBlTh49AuwymhqWBlBBy7lvvrwM84e6vIKJrpZLO+k/MXBut+pXkPvKpU7s7QbyIlcGhWwaDVYf2kBan9Qf/oQwceSRfNQ2LlleTccgtUBagS42A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(346002)(376002)(39860400002)(136003)(71200400001)(86362001)(8936002)(8676002)(186003)(54906003)(52536014)(76116006)(5660300002)(4326008)(66476007)(66556008)(64756008)(66946007)(66446008)(55016002)(33656002)(9686003)(44832011)(478600001)(6506007)(2906002)(53546011)(316002)(26005)(83380400001)(6916009)(7696005)(7416002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: kfxViY0Hk/te4CPsx86SG1+3xSTU/FTN7IYBc5/1W9nVVbv39OpopDIBApUKENNebNrELnhV5m0+pzuBtZeCoAtbFYjGmyBNi+kvDju6FC+OM4Xu6LYG3M18qkmOwM+VMAeWuQVN6xR2evcqYYaBSq9kjiIx0VQ5w+4dadMkrmESwVnKFRaJcnrQkzE3SFwyap8fyxqdgVge5CdOTSJNq2H+zro98q3Bujeh/nou2wJsdu+K7zFoFQjiYYQYd8HR95KcepQ4h7zN8RXfCnVjzn/3f28t3fOo8trNJoLidL39UWe5lezSftMaSvoarDyjj+fhGKipFGDKysaOfl6CRCb7wnj1qCWzm6wQBtxpkyXOkrg5Fsb4CFkCOBmZEJDJrfs5BkYyFcQ8oRPYGe7UfxTjOCIZOITIbvuOIGnPN3J/+71+k3oOLfsroOHf9hqHi7vqGRVrENs2C8YoNqedIfmbQHTrY7C91g7t7U+glgI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41b08e4c-6f24-4e9a-98fe-08d816ba20e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 14:39:54.2524
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cytMhCl7TVhCUoy1/fYWT7NRF3OPO9+p8Cb5uBX1yLfSs4g+ellYjPtsvyrouScjzvg7laIH+6G5Wd+bEyAd5TP+47LS6Mwc26TcErWloXs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6148
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, June 22, 2020 5:25 PM
> To: Florinel Iordache <florinel.iordache@nxp.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; f.fainelli@gmail.com;
> hkallweit1@gmail.com; linux@armlinux.org.uk; devicetree@vger.kernel.org;
> linux-doc@vger.kernel.org; robh+dt@kernel.org; mark.rutland@arm.com;
> kuba@kernel.org; corbet@lwn.net; shawnguo@kernel.org; Leo Li
> <leoyang.li@nxp.com>; Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> Ioana Ciornei <ioana.ciornei@nxp.com>; linux-kernel@vger.kernel.org
> Subject: [EXT] Re: [PATCH net-next v3 4/7] net: phy: add backplane kr dri=
ver
> support
>=20
> Caution: EXT Email
>=20
> On Mon, Jun 22, 2020 at 04:35:21PM +0300, Florinel Iordache wrote:
> > Add support for backplane kr generic driver including link training
> > (ieee802.3ap/ba) and fixed equalization algorithm
>=20
> Hi Florinel
>=20
> This is still a PHY device. I don't remember any discussions which resolv=
ed the
> issues of if at the end of the backplane there is another PHY.
>=20
> It makes little sense to repost this code until we have this problem disc=
ussed and
> a way forward decided on. It fits into the discussion Russell and Ioana a=
re having
> about representing PCS drivers. Please contribute to that.
>=20
>         Andrew

Hi Andrew,

Yes, you are right: we decided to send only support for DPAA1 using current=
 approach as a PHY device
(as mentioned in cover-letter), until PCS representation will be fully clar=
ified.
The entire DPAA2 support was removed for now, together with phylink changes=
.
DPAA1 maintainer (Madalin Bucur) agrees with current representation as a PH=
Y device for DPAA1.
So we would like to have some discussions around this approach for DPAA1 on=
ly, as it seems suitable for us.

Regards,
Florinel.
