Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4E203A51
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 17:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgFVPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 11:08:41 -0400
Received: from mail-eopbgr10088.outbound.protection.outlook.com ([40.107.1.88]:3166
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728070AbgFVPIl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 11:08:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXtgm9ckzYPIk1ZGy+XVb+K77KApevxIz9GyCw6EL0Ijp8PcQdOtj5IOPLSrWIBKKueXxwJS0GWmewB6VHNOzt3pF4watLS8gZBhqgTCClsNo2DE/wnJVy1YN5orCNB/LjxM+jckDIM5LHtP2IV5ho6ioZ9oDtlwWycg+4KaHWQ0O5ZHNQ31L/786dG2xi5vWGiI1v/U418Zy7sQ2VkRVWQRuFPUcKBvko3lqKsxjmYtC5LYzPosAE/iRsLvQrIgzcpynrsbFW3zYiQ3l9YyXMarOVIMgl7ajCtKs2HPh2pFZf14gQFzuwVsQqqFnucPuLzLZcwjGpVRxMh+0bumaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLvjArFfes3MGz/Bmb7zBxxAZ50O7eGjBqSgkaUXRP0=;
 b=HPxIB1WUulpvZZdkVU+uu2cIMYqZsrcYzXnd8M9phXD3BHu0Disdisr/TBI0yMeAWvYbYr4rrcwzDrLovFDev0MiD9GFyt60q07/YcJF+p+G+mZmNT3tUEGSREel4LolbGZu5z4ptBT4cNMaVt88ZWS+DD3UC4B2nrOFaVgjA/Ri3kw11VKWKYw/5rsjBCse1fkAtteKPWtpe6T1p17yBWqww9nj+pKZuKx0dKKiUvmMKvr+Ok26464rG0T46e6VMmK433HX3L6N/uYWapblBPOr8N8TiI6cI8n6cpQ4YoP4wNXvM58BcerbNfhvmmgBoqDMkvhoNoxRyYU+LZrSXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lLvjArFfes3MGz/Bmb7zBxxAZ50O7eGjBqSgkaUXRP0=;
 b=Fj0FpYCNgi3YAExc7kW0bA7UMYKReuFeuf5h4v8R23cLFQPZbZnuy7qzdgpOywMgmO/Mt7SmaKbSFpqVANdSp6CXt4f/AJHJFHOgI8YIs/YDyeVLkiEix0bfWyc1te9pnLNYZZATpKCU8GQ8pNhYVlcmdwUz2Et5vtc27DcTPL4=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by AM6PR04MB6325.eurprd04.prod.outlook.com (2603:10a6:20b:bc::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Mon, 22 Jun
 2020 15:08:36 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::8576:ca02:4334:31a3]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::8576:ca02:4334:31a3%5]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 15:08:36 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florinel Iordache <florinel.iordache@nxp.com>
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 4/7] net: phy: add backplane kr driver support
Thread-Topic: [PATCH net-next v3 4/7] net: phy: add backplane kr driver
 support
Thread-Index: AQHWSJoP3RwMZ7Se1EqsHw8WDK+NGKjksHoAgAAIWpA=
Date:   Mon, 22 Jun 2020 15:08:36 +0000
Message-ID: <AM6PR04MB397677E90EFBD9749D01B061EC970@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
 <1592832924-31733-5-git-send-email-florinel.iordache@nxp.com>
 <20200622142430.GP279339@lunn.ch>
In-Reply-To: <20200622142430.GP279339@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [86.127.220.45]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c3e7b1bd-e807-489b-63cc-08d816be237c
x-ms-traffictypediagnostic: AM6PR04MB6325:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB6325CD55DD5963D765CFA412AD970@AM6PR04MB6325.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0442E569BC
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J4sUZDWMsIO570svvjlLImWhMPKpgfCuBbs47umkDv4ydvX9qfi6BDCWNxVUF6Jkz5jgiNHGKCWmYBlY2LwRyL/KrAVNOVtSv/yOi5v+G1KhxB8HR0PfgFLS7Stj/n/38a+BfbY0lfjNEpNPW0Fdnd9qbyqfOQwByC9/+3Bs7L6X3EzN3O7JiDbWh1Jeu/Tc3+5QUYOxItTzpB46NUodQD4R3c3DchcsEe6V70kIJzuOGUv+vN31V/E4Tw5zMaCWdNP5OMlPcrf+QGntSF+FwskvHeMkp4zlNZcpYGNRiIkQRTMDHf0fbaCYB42m3oP+/veEZzUhi+nzMav1BCuc2Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(6506007)(110136005)(83380400001)(54906003)(53546011)(26005)(8676002)(7416002)(7696005)(316002)(2906002)(55016002)(9686003)(52536014)(186003)(478600001)(5660300002)(4326008)(71200400001)(66946007)(76116006)(64756008)(66556008)(8936002)(86362001)(66446008)(33656002)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: N49+JdfIs/ee67oXri8sMxJvjpxorxPPQDh/O2TFQbASEIAD8ApZQwpGi2ngAwHMFGNI5KP4wQiOf58+UHzh9+IXVkxG7VAWg8cyWfy2yIFU5ZmpzPeBzNjcvxJpBfrtAqoBOttQHefU+UZjV2QIb39QcldcXLwXbsjis9eBOM05bhsOmtDt0pBN/d5X0a7HhR0hVsjgkWFRc3cLKgxexMqE8jTE/4PTZUhAsfjfUKOqErGWCPFYBbVbAuEWKEYuJwttf5T0iFFEeVv1izhureTf1TBa8y+hyVYLZhiD7rG5lOiUqFlXvsHCW+5m88HQRm7CDqJyljsC+Pp9rfKDX5gEPsa7fpnOGDGxULEowUtBnZMiEfVN/eDs2+KleYObM8a1Wbgqoy++CllTLFkgCh3USqtQJO6Ofp88UgBQ26Z8S6FvzZz8qLr+xOuELt+2HMXkPp6ufdvyT+pa5cF+aN20ej7fJbJhF6slNgRkU+w=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e7b1bd-e807-489b-63cc-08d816be237c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2020 15:08:36.7037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AyIlyg8/HkFayMHJRX4KpUWOYJFME5BtXkabnzMBh7fEnLUgWn8ojEPNV5xpd/t3tX3Yuy1dRauGt7EpNX+4PA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6325
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
> Subject: Re: [PATCH net-next v3 4/7] net: phy: add backplane kr driver
> support
>=20
> On Mon, Jun 22, 2020 at 04:35:21PM +0300, Florinel Iordache wrote:
> > Add support for backplane kr generic driver including link training
> > (ieee802.3ap/ba) and fixed equalization algorithm
>=20
> Hi Florinel
>=20
> This is still a PHY device. I don't remember any discussions which
> resolved the issues of if at the end of the backplane there is another
> PHY.
>=20
> It makes little sense to repost this code until we have this problem
> discussed and a way forward decided on. It fits into the discussion
> Russell and Ioana are having about representing PCS drivers. Please
> contribute to that.
>=20
> 	Andrew

Hi Andrew, the reasons behind this selection:

- the PCS that is controlled by the backplane driver belongs to the PHY
layer so the representation as a PHY device is legitimate
- the PHY driver provides the state machine that is required, not using
this representation backplane would need to add a separate, duplicate
state machine
- the limitation, that only one PHY layer entity can be managed by the
PHYLib, is a known limitation that always existed, is not introduced by
the backplane support; the unsupported scenario with a backplane connection
to a PHY entity that needs to be managed relates to that limitation and
a solution for it should not be added through the backplane support
- afaik, Russell and Ioana are discussing the PCS representation in the
context of PHYLink, this submission is using PHYLib. If we are to discuss
about the PCS representation, it's the problem of the simplistic "one devic=
e
in the PHY layer" issue that needs to be addressed to have a proper PCS
representation at all times.

Madalin
