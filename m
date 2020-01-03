Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A5712FA35
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 17:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbgACQVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 11:21:16 -0500
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:12609
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727701AbgACQVQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 11:21:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VeOZlkUPu6puqBBrLT7BIgZO+dbwPz01sTzu/ex9Mg4bmzKDOAT1rmdndmSKYjG/Nzp4e0WLqMnXOB7dOT3MjPBbfjwtmwWQPf9pSenquXUQA+WrCD35Zz7MsZeadPlL0RJyIg7f4Po7CGKoKKkR/V0Ad6IN50qFTVWJ/JbN/kKtZ6FOcm1w5W+mVeutBuumOFd42MGzsnCndGV/5LdOzRs/osMCuksOyNfNaKC6Re7SJVwntIy6QmCiCmqVJ8fTqShPWOSDU38rhErrzhHm7GgW0sp+pMy2VGT9aS/BLHAEN4Q87xd+LYzbbLVHRMHmJ3IPJm3IQPizLyiEB/MLgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sD+8TgLXXgg7hpgI+xdM7yFg+uRH1CXsfwt8NlmEgjI=;
 b=nsecV4Xr+L/sH0lU94aPunHAP+Z7v21mLuAn5Av3PkY2abXTxad0yPJoWHTYwgMwaUaUGIyhgk7F5EhX8JpyRJFYNZxRJp0PksVzOShr7dFci/tJ6yMDAGOIf65av6aILNLXbtL0lwds8+eNdaBSSezFs5ATZx5JjHevUaGVFX7GAmZeVPlbxqXA1aYzXsX/uDgDtTo8nlZCECP7P/oR7VVG2jPO6viPpikrZ+1HsPSgb63jXgOjgM1A5JU+hflZedzMmosEawSlhsX1JNxDolXYuYdObhx60YJQFzprqkyioqkFIg4ZccGJWzh92KpFmi+y/N4fm67nTYhQt92iSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sD+8TgLXXgg7hpgI+xdM7yFg+uRH1CXsfwt8NlmEgjI=;
 b=mwvN2PadRVgCbMEiUGHsIxIvSCoQwRBc3fy95fziYo63e6D0ntewp793pEWPHKX74iUc/7sKekRqv0DAVkwDNml/yswJeSgBYa9JSypOv6RGyq4u1q9kIJUFnmBIf6Gle8X+YHxgpecRVL5XfPu7GXlQ5dS7Hw3FT+1Wy0p0sTg=
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com (52.133.243.85) by
 DB8PR04MB6524.eurprd04.prod.outlook.com (20.179.248.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 3 Jan 2020 16:21:09 +0000
Received: from DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3]) by DB8PR04MB6985.eurprd04.prod.outlook.com
 ([fe80::c181:4a83:14f2:27e3%6]) with mapi id 15.20.2602.012; Fri, 3 Jan 2020
 16:21:09 +0000
From:   "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Subject: RE: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Topic: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Thread-Index: AQHVtoABZZFXn6n8UUGKWfe6RtVAuKfBtnoAgAAR9oCABd2qgIAQ9D0AgAAopQCAAAQgAIAAJ5UAgAANzwCAAAvMgIAAKI7w
Date:   Fri, 3 Jan 2020 16:21:09 +0000
Message-ID: <DB8PR04MB6985AD897CC0159E324DF992EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
References: <1576768881-24971-1-git-send-email-madalin.bucur@oss.nxp.com>
 <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191223120730.GO25745@shell.armlinux.org.uk>
 <DB8PR04MB69858081021729EC70216BE3EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103092718.GB25745@shell.armlinux.org.uk>
 <20200103094204.GA18808@shell.armlinux.org.uk>
 <DB8PR04MB698591AAC029ADE9F7FFF69BEC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
 <20200103125310.GE25745@shell.armlinux.org.uk>
 <20200103133523.GA22988@lunn.ch>
In-Reply-To: <20200103133523.GA22988@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@oss.nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 351468e3-8b28-4f85-519f-08d79068f11a
x-ms-traffictypediagnostic: DB8PR04MB6524:|DB8PR04MB6524:
x-ms-exchange-sharedmailbox-routingagent-processed: True
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB6524687DB1BC200FF1CD9705AD230@DB8PR04MB6524.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0271483E06
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(13464003)(199004)(189003)(7696005)(2906002)(86362001)(55016002)(71200400001)(9686003)(186003)(6506007)(53546011)(5660300002)(26005)(478600001)(316002)(66946007)(4326008)(66556008)(52536014)(33656002)(8936002)(54906003)(110136005)(66446008)(8676002)(76116006)(64756008)(81166006)(81156014)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR04MB6524;H:DB8PR04MB6985.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:0;MX:1;
received-spf: None (protection.outlook.com: oss.nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nQKBoLONJQFUNUoSpclrjpqIpQzMox5BOvT5XBdPZi9IXgVTfsEuvFxMvzpyydUqBKj14/I8wSarcC58JoQQhViIrEFXlgc57CgBH9LlP3+SLHrBHbbu/TWQ+6COykwiM96WLO+zq/Kgch373P4iUNaGw4IVg6wrNTJSUFR3WsYoEr3GMFUd3MuHWVgtYjiGiwT4R8wpKo1kAKj83YGmsiJXEOKSu4Cfphe2pEdgrp4tAQZ/vL+tl/AyxVJXMWORFIBilTt8rBd3vdlgsv9aKnX1M7F2IsDdal6uccSaUM6/2yKkze3zDQL+meuIz/eooktz0c6FYAuI2/FN/YWVTPIaNA8g1Cd5dkhGRV3wKWJLaMoqAIQP8gf7uBleud6xrs7lFkSRbuU93UdYeX2ewmYJd0AwNV6GYglrlRWTi7gllRt12QQTx64+xQAIZe+wcr/clBoVSrp38avt2eg4h9HGABlXD3UgTrFgzBfkTov0JUxUGJfXbu0c2+w1oOIR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 351468e3-8b28-4f85-519f-08d79068f11a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2020 16:21:09.0792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kWKK0o7WwuFHlLGe7c+Tv7hQ9weIYuCwOL6YJd67TCMET/XHeLWnNKGApGPUGg4TzcF54gh4P0Py7C0gesqPNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6524
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, January 3, 2020 3:35 PM
> To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>;
> devicetree@vger.kernel.org; davem@davemloft.net; netdev@vger.kernel.org;
> f.fainelli@gmail.com; hkallweit1@gmail.com; shawnguo@kernel.org
> Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
>=20
> > What I might be willing to accept is if we were to introduce
> > XFI_10GBASER, XFI_10GBASEW, XFI_10GFC, XFI_G709 and their SFI
> > counterparts - but, there would remain one HUGE problem with that,
> > which is the total lack of specification of the board characteristics
> > required to achieve XFI electrical compliance.
>=20
> Hi Russell
>=20
> The four RGMII variants are precedents for mixing protocol and
> 'electrical' properties, in terms of clock delays. But having four
> RGMII variants has been a pain point, implementations getting it
> wrong, etc.

I always thought that a separate property would of simplified code a lot,
there are things to be done for RGMII and one ends up with ugly code:

        /* check RGMII support */
        if (iface =3D=3D PHY_INTERFACE_MODE_RGMII ||
            iface =3D=3D PHY_INTERFACE_MODE_RGMII_ID ||
            iface =3D=3D PHY_INTERFACE_MODE_RGMII_RXID ||
            iface =3D=3D PHY_INTERFACE_MODE_RGMII_TXID)

That's the reason I've commented on the recent patch set, that maybe it's
time to stop and fix this mess properly, provided that we find a better
solution.

> So i would avoid mixing them in one property. I would prefer we keep
> phy-mode as a protocol property, and we define additional DT
> properties to describe the electrical parts of the SERDES interface.
>=20
> Madalin, what electrical properties do you actually need in DT?  I
> guess you need to know if it is using XFI or SFI. But that is only the
> start. Do you want to place all the other properties in DT as well, or
> are they in a board specific firmware blobs, and you just need to know
> if you should use the XFI blob or the SFI blob?

I do not have other electrical propertied to set. Nor do I have a different
blob to load. We're using u-boot as a a bootloader. It supports SFI as a
valid mode for a long time now:

commit d11e9347461cff9ce89e6e65764f73fad0f19c6f
Author: Stefan Roese <sr@denx.de>
Date:   Thu Feb 23 11:58:26 2017 +0100

    net: include/phy.h: Add new PHY interface modes

    This patch adds the new PHY interface modes XAUI, RXAUI and SFI that wi=
ll
    be used by the PPv2.2 support in the Marvell mvpp2 ethernet driver.

    Signed-off-by: Stefan Roese <sr@denx.de>
    Cc: Stefan Chulski <stefanc@marvell.com>
    Cc: Kostya Porotchkin <kostap@marvell.com>
    Cc: Nadav Haklai <nadavh@marvell.com>
    Acked-by: Joe Hershberger <joe.hershberger@ni.com>

There are many things pushed down to u-boot so the Linux driver has less
work to do, that's one of the reasons there is little left there. Ideally
this dependency should be removed but then we'd need to make a clearer
distinction. As you've noticed, currently I don't even need to distinguish
XFI from SFI because for basic scenarios the code does the same thing.
Problem is, if I select a common denominator now, and later I need to
make this distinction, I'll need to update device trees, code, etc. Just
like "xgmii" was just fine as a placeholder until recently. I'd rather use
a correct description now.

> We can probably define a vendor neutral DT property for XFI vs SFI,
> but i expect all the other electrical properties are going to be
> vendor specific.
>=20
>        Andrew
