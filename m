Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1DD197408
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 07:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728642AbgC3FpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 01:45:00 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:43470
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728489AbgC3FoQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 01:44:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO/zxxA9h+OUlxowcctCaCpe9ImMk7orpgFdAZYLTaXJqPxb2lUFflINSl6zLTE/gk8k4LvRcAr1vVYkpoxuOzI1XB5kEgEm9g5whNDm86GN22Nq9Nex76JWMQunOI8L6OtqYJjsnG+eqKFH+NVsRsFYrXg/k0O6z7dXJAaWZJt2nhwcrGD0w2JGJ4fEAHleXLgip7TsTMBDaFmtMNJtS0ygY+KtQOLgGORoJvdig3bI4eo67WeMKEv7v+ppk1jci2yn5o5AmSP9XJNkfQ3s3B3J2Jq/fAszpyJlxDmZ1H5J1uMB8kAlKSeFe85BDRCVxxsAIOLpdIZHqkObsv0Dug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC1yDsg2znOkTFzr3iiN5qQA8e+KkwwlS8W/yers4X8=;
 b=EqjzmhqDj/C7Uns2GfxwEviEkrXUrNpMRxMR7YH3HpZYhRlPkcefkFM9aMpPI+iPzPK2wBwan0adbi9XSdQ2q0Pite/ckYPquPcJ3tIqa+le2BdRk4WRKGjSWqBuHib2K9T8OISp0pLf2bKVDh/sZywnL7Bhmd35RYvJS84znLxo1joLjRxTNctcKTLcW6ug7L83B0+OrKPvZRegkRbwe0by7uE8SOQWm47aX8Nf/pNysQXzWv21+Ju9UXKLx4FZXKnLBmLEmzVlqRt0YSv6vMgagUWcZoRPtLMMiCWvNwGHasLa/qFLYpT8I82jmGkviGN2GJRFd4OBSTQ7wgo5sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xC1yDsg2znOkTFzr3iiN5qQA8e+KkwwlS8W/yers4X8=;
 b=JB9Rg7+JBfXLmG0QPnxG4SNeiKwrG3TriStdAxRZATgpT+tOaeQRVWGtzLpouf9PT8v09XIZOFxAbVQ1OOZKlRJ362gt3krC5yZDy963UoZTCQnBM505FA7bLRF9rKzt33AfqCE0WzViF5EpkWAAKlo4hPW2UvGmSIZC+xuJwTE=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6508.eurprd04.prod.outlook.com (20.179.248.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 05:43:35 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::a523:58cc:b584:2c2%6]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 05:43:35 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Florinel Iordache <florinel.iordache@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
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
Subject: RE: [EXT] Re: [PATCH net-next 2/9] dt-bindings: net: add backplane dt
 bindings
Thread-Topic: [EXT] Re: [PATCH net-next 2/9] dt-bindings: net: add backplane
 dt bindings
Thread-Index: AQHWA3W3jF7aogLlGUecGp366aweTahboFSAgADpoACAAAfzgIAABHgAgAAe0oCAA+xYoA==
Date:   Mon, 30 Mar 2020 05:43:35 +0000
Message-ID: <DB8PR04MB6985BA5D411AD5F9456F833BECCB0@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
 <20200327010411.GM3819@lunn.ch>
 <AM0PR04MB5443185A1236F621B9EC9873FBCC0@AM0PR04MB5443.eurprd04.prod.outlook.com>
 <20200327152849.GP25745@shell.armlinux.org.uk>
 <20200327154448.GK11004@lunn.ch>
 <20200327173507.GQ25745@shell.armlinux.org.uk>
In-Reply-To: <20200327173507.GQ25745@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [79.115.171.113]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 63239714-41f0-4ba4-80d5-08d7d46d49ed
x-ms-traffictypediagnostic: DB8PR04MB6508:|DB8PR04MB6508:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6508BC21DD478A6A67B46F95ADCB0@DB8PR04MB6508.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0358535363
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6985.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(316002)(54906003)(5660300002)(110136005)(478600001)(86362001)(52536014)(186003)(66946007)(66476007)(64756008)(76116006)(26005)(66556008)(66446008)(71200400001)(2906002)(33656002)(7416002)(8676002)(7696005)(55016002)(9686003)(81166006)(81156014)(8936002)(53546011)(6506007)(4326008);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gj13wxUyLTS08Pk1bARBAltkbgMmkaEFUxrW2vxvEXts3ZWkvhQFx4deHxJNB5UWn+Yp7byRA2FvXury35ZUZCbf/Q3Y98e9O/3+qHkkLP+HvriCZh9L5M1E96sw5k0m9+1RjYUTyfjkfQODlgR+mhozuEhEoHDxRBZSbwAzuM4MpAhgA4RnX2q+3gWSyGPt7tf4MGRbIxBWsn8nGsEkR2c+zNsIMNLcNqC1NnCPAF/nNWaPKyD/xJQ7L3cRLQp0N2Z54XLMv9yAEQ6rk2g3U3ZDACJIesJDDqoTcToAG1JPC4bVqyBzJE2EOqv3qDTTjvNEr1jtLhMOakgi+BnuApJ1Wf8vPFAKU/vhtIMAljp9hzsXpAHnHz+69LMYH+IpMYwRGRPZojRfjk6rdkFlyHYwdEF/JWeS0B7tEsmLlKCfHTJy/7ZTEIqCYO1/TYY2
x-ms-exchange-antispam-messagedata: E54TVxGGpW6ksi6DG4UAohG2OCvXrk6T2OCNYrUSBZ+9Oefngtbbm7N9d8F/NlDn6qTKn1pVUkqZec90IEABvxm+eI4i51RKeFd2KnsbptWh9b7opCEHrmR+eARwT750+d+E3Qu5TaX700tGdjwBKw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63239714-41f0-4ba4-80d5-08d7d46d49ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2020 05:43:35.1198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F7x/544+boVcrNKAIImd+B4q0WVS2HKKhGS41a8sBxtiodlJSBaItfocs+5Rw14mJVQFkHEcc8rnijwxyUAtLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6508
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Russell King - ARM Linux admin
> Sent: Friday, March 27, 2020 7:35 PM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Florinel Iordache <florinel.iordache@nxp.com>; davem@davemloft.net;
> netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> devicetree@vger.kernel.org; linux-doc@vger.kernel.org; robh+dt@kernel.org=
;
> mark.rutland@arm.com; kuba@kernel.org; corbet@lwn.net;
> shawnguo@kernel.org; Leo Li <leoyang.li@nxp.com>; Madalin Bucur (OSS)
> <madalin.bucur@oss.nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; linux=
-
> kernel@vger.kernel.org
> Subject: Re: [EXT] Re: [PATCH net-next 2/9] dt-bindings: net: add
> backplane dt bindings
>=20
> On Fri, Mar 27, 2020 at 04:44:48PM +0100, Andrew Lunn wrote:
> > > What worries me is the situation which I've been working on, where
> > > we want access to the PCS PHYs, and we can't have the PCS PHYs
> > > represented as a phylib PHY because we may have a copper PHY behind
> > > the PCS PHY, and we want to be talking to the copper PHY in the
> > > first instance (the PCS PHY effectivel ybecomes a slave to the
> > > copper PHY.)
> >
> > I guess we need to clarify what KR actually means. If we have a
> > backplane with a MAC on each end, i think modelling it as a PHY could
> > work.
> >
> > If however, we have a MAC connected to a backplane, and on the end of
> > the backplane is a traditional PHY, or an SFP cage, we have problems.
> > As your point out, we cannot have two PHYs in a chain for one MAC.
> >
> > But i agree with Russell. We need a general solution of how we deal
> > with PCSs.
>=20
> What really worries me is that we may be driving the same hardware
> with two different approaches/drivers for two different applications
> which isn't going to work out very well in the long run.

The same HW can be used in multiple ways here so having different drivers
for these modes is not really an issue, you won't be able to use it both
in backplane and non-backplane mode at the same time.

Besides the (oversimplifying) model used in SW, there is no constraint
to have just one independently manageable entity belonging to the PHY
layer. Nowadays there are complex configurable PCS/PMA units, retimers,
single chip PHYs that can function also in backplane mode, and so on.
All these require a rethinking of the one PHY per interface, tied to a
MDIO bus model we use today. The DPAA 1 already make use of the MDIO bus
infrastructure to manage the PCS devices in the SoC, without an issue
related to the PHYlib one PHY assumption.

One risk I see here is that we may abandon PHYlib before we give it a
chance to adapt to the new complexity of the HW and roll something new
just to do away with the required work in understanding its inner workings.
This could even be fine but it creates a no return point for drivers that
will use a new infrastructure we put in place (i.e. no backporting).

Madalin
