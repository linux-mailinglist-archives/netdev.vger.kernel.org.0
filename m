Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E10173D90
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 17:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgB1Quo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 11:50:44 -0500
Received: from mail-eopbgr70135.outbound.protection.outlook.com ([40.107.7.135]:25030
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726857AbgB1Qun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 11:50:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWQ2mSEaX49sQW3WXGZczjdFwSUYq2RgGTO2GJqVFpgGhmcVsuFlFNkLwU+aQGol0hTOjK/li2osGw1hGRTyy8aozZZJ4DIsKeFoGSYyARNzzx84pKzRII5V9Ht0esg5egYJu77x6S1IdUy60VnvUEadVtyycFZQPhdDSwlTQTGJp8ccRGThXr3IqeZIE3eiOxCSEkNz1rH8EmyED4/NS7bcObJdschIP1iUZpCxVIW3CRze7faaq2aOvYmgh0/+MMqD20KxLW5jP0eGDY5TD1gyqdc5o90zVMlS32ZQxVEg5W6Kb4C06hkUso9JCkf7eab4anvdbHQ7KNvXymQH6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kd4KSFABL8IoFAR0aGk0+bt0lmJIVKI0jjM3ig3Igf8=;
 b=l/vTewu9XPvHzmC9I1axFvsOOBmgSHnsPl8acvvpqF9y8VhdkrAFbHtSgnVx77D4gw5vX3XZnMGsHfaJyXcfYeNJuTtWCcAWhy+FhKFdqYde0WkfE4KyTBzx1Dl6VMELvPekXqhBs0oECu4EQW9AM+TvOlqmrjukET5+N5nNnKEnQi6I2MxyRnNUKMNJ3O1v4XYgBu2wlM8aNYY2+2ZQVI9ufeL2DY4JahY1+NbD491d7UsP53ohwgPzBr+Zy8BptJ+k5Qfl0l/gqL/H3rwpTC0XCz74RaQer7gMnlJn1II2TsnuF4OdvSakvqMbUZkx73QvBH4VLw3NIj7vyelLUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kd4KSFABL8IoFAR0aGk0+bt0lmJIVKI0jjM3ig3Igf8=;
 b=wlq5oCvp7ItLo02dx0anP+nl76q+wlUl+mxmqR9jZEeJiOFHpBQLzCf9UcY64htj6qDPAh8RDSWQPgJrMcrUkAws3bWU6wfdUfafzGBKGJJKHIgSsBD7ujNYCskeuQeJqfEs3DBXzGajpeTZ7TgjHPuTw7QK2OXe1vwu4Kzq6yg=
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (10.165.195.138) by
 VI1P190MB0271.EURP190.PROD.OUTLOOK.COM (10.165.190.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.22; Fri, 28 Feb 2020 16:50:37 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::a587:f64e:cbb8:af96%4]) with mapi id 15.20.2772.012; Fri, 28 Feb 2020
 16:50:37 +0000
Received: from plvision.eu (217.20.186.93) by AM6PR0202CA0068.eurprd02.prod.outlook.com (2603:10a6:20b:3a::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15 via Frontend Transport; Fri, 28 Feb 2020 16:50:36 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>
Subject: Re: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Thread-Topic: [RFC net-next 0/3] net: marvell: prestera: Add Switchdev driver
 for Prestera family ASIC device 98DX326x (AC3x)
Thread-Index: AQHV6/jy7mjUjxYwxkS7hliqOPvXRagrqJaAgAUt1AA=
Date:   Fri, 28 Feb 2020 16:50:37 +0000
Message-ID: <20200228165028.GA8409@plvision.eu>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
 <1810583047af2d41d2521960f7a39f768748f2cb.camel@alliedtelesis.co.nz>
In-Reply-To: <1810583047af2d41d2521960f7a39f768748f2cb.camel@alliedtelesis.co.nz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0202CA0068.eurprd02.prod.outlook.com
 (2603:10a6:20b:3a::45) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vadym.kochan@plvision.eu; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.20.186.93]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd8a5b65-1dff-4f60-d238-08d7bc6e5622
x-ms-traffictypediagnostic: VI1P190MB0271:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1P190MB0271C08EF1AFA81B2DD4403C95E80@VI1P190MB0271.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0327618309
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39830400003)(376002)(396003)(346002)(136003)(189003)(199004)(54906003)(316002)(2616005)(66946007)(33656002)(8676002)(186003)(66446008)(81166006)(5660300002)(66556008)(64756008)(44832011)(7696005)(16526019)(26005)(36756003)(8936002)(52116002)(81156014)(956004)(66476007)(508600001)(55016002)(107886003)(8886007)(6916009)(2906002)(1076003)(4326008)(71200400001)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1P190MB0271;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: plvision.eu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N7iUymqcmgnMmPP4CNs955GUGXtrYjBlAIfoP2C2Qqk9u51+AYoF3Fh/xGp72cNVazkCCLgyukFL/G/hvCQ0dhB3MLl4YmTH58KTbGDSB5Se/VkA6en8aJnQdvVlgOQDljE3miMbL5Tf+nmh7QXBNuz/OuqjO6MHrEzx6x1JxgFO9z9jH3hzfWqLdBMfqkwaZUCG4xCqDxYGuWnvZzNIEO8tGJRF9WJA462rBq772Q/nvROgkpE98nCDR1sevT1LXxTDKdoMhBi+LD0q/OtiTM70Z7/yVePczx4e2oiXCOI9IXcqzeuxFuGnrxJxYfBTXlJU2RZdBXaAQPVyXmjLOvYPPFJ+WWXfB1hyhhPYC+d9WUqUUZW5M4OfJBBHEXYh/BAbAqwJ4JgsgunURpZxUKM5m00fk2toR5+T3RPcSoOgVssBPIX/mB6cd7BysbSS
x-ms-exchange-antispam-messagedata: nHqpgxzlWpzxNhZcOsa5phyvgsDRVDvlS0rhX5yCDVEjxfveh815CZjxJsSJeGKsSye/jSJ1yR7fHJ8IR04+7u40rgdCgIuV3mJDdA+nht1cALAEwhLikvAkF/JdGpdOc+uATPx7RD2ojPjx2MAc0A==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CC503871D04B454EB24D6C0EE494E006@EURP190.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8a5b65-1dff-4f60-d238-08d7bc6e5622
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2020 16:50:37.6090
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7YFHApc9ObC3CDSkIvpaxVNoILg/X1aNo3AK9Ej6FI5qQjeluLwJBfUnKQ7Yyn5SpKa59u+RIlLUXygo5j/ubYFbU1dZbjguiwVMNoh/Oxk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0271
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chris,

On Tue, Feb 25, 2020 at 10:45:09PM +0000, Chris Packham wrote:
> Hi Vadym,
>=20
> On Tue, 2020-02-25 at 16:30 +0000, Vadym Kochan wrote:
> > Marvell Prestera 98DX326x integrates up to 24 ports of 1GbE with 8
> > ports of 10GbE uplinks or 2 ports of 40Gbps stacking for a largely
> > wireless SMB deployment.
> >=20
> > Prestera Switchdev is a firmware based driver which operates via PCI
> > bus. The driver is split into 2 modules:
> >=20
> >     - prestera_sw.ko - main generic Switchdev Prestera ASIC related log=
ic.
> >=20
> >     - prestera_pci.ko - bus specific code which also implements firmwar=
e
> >                         loading and low-level messaging protocol betwee=
n
> >                         firmware and the switchdev driver.
> >=20
> > This driver implementation includes only L1 & basic L2 support.
> >=20
> > The core Prestera switching logic is implemented in prestera.c, there i=
s
> > an intermediate hw layer between core logic and firmware. It is
> > implemented in prestera_hw.c, the purpose of it is to encapsulate hw
> > related logic, in future there is a plan to support more devices with
> > different HW related configurations.
>=20
> Very excited by this patch series. We have some custom designs using
> the AC3x. I'm in the process of getting the board dtses ready for
> submitting upstream.=20
>=20
> Please feel free to add me to the Cc list for future versions of this
> patch set (and releated ones).
>=20
> I'll also look to see what we can do to test on our hardware platforms.
>=20

Sure. I will add you to CC's list. Please note that you need to make
sure that your board design follows Marvell Design Guide for switchdev
solution.

> >=20
> > The firmware has to be loaded each time device is reset. The driver is
> > loading it from:
> >=20
> >     /lib/firmware/marvell/prestera_fw_img.bin
> >=20
> > The firmware image version is located within internal header and consis=
ts
> > of 3 numbers - MAJOR.MINOR.PATCH. Additionally, driver has hard-coded
> > minimum supported firmware version which it can work with:
> >=20
> >     MAJOR - reflects the support on ABI level between driver and loaded
> >             firmware, this number should be the same for driver and
> >             loaded firmware.
> >=20
> >     MINOR - this is the minimal supported version between driver and th=
e
> >             firmware.
> >=20
> >     PATCH - indicates only fixes, firmware ABI is not changed.
> >=20
> > The firmware image will be submitted to the linux-firmware after the
> > driver is accepted.
> >=20
> > The following Switchdev features are supported:
> >=20
> >     - VLAN-aware bridge offloading
> >     - VLAN-unaware bridge offloading
> >     - FDB offloading (learning, ageing)
> >     - Switchport configuration
> >=20
> > CPU RX/TX support will be provided in the next contribution.
> >=20
> > Vadym Kochan (3):
> >   net: marvell: prestera: Add Switchdev driver for Prestera family ASIC
> >     device 98DX325x (AC3x)
> >   net: marvell: prestera: Add PCI interface support
> >   dt-bindings: marvell,prestera: Add address mapping for Prestera
> >     Switchdev PCIe driver
> >=20
> >  .../bindings/net/marvell,prestera.txt         |   13 +
> >  drivers/net/ethernet/marvell/Kconfig          |    1 +
> >  drivers/net/ethernet/marvell/Makefile         |    1 +
> >  drivers/net/ethernet/marvell/prestera/Kconfig |   24 +
> >  .../net/ethernet/marvell/prestera/Makefile    |    5 +
> >  .../net/ethernet/marvell/prestera/prestera.c  | 1502 +++++++++++++++++
> >  .../net/ethernet/marvell/prestera/prestera.h  |  244 +++
> >  .../marvell/prestera/prestera_drv_ver.h       |   23 +
> >  .../ethernet/marvell/prestera/prestera_hw.c   | 1094 ++++++++++++
> >  .../ethernet/marvell/prestera/prestera_hw.h   |  159 ++
> >  .../ethernet/marvell/prestera/prestera_pci.c  |  840 +++++++++
> >  .../marvell/prestera/prestera_switchdev.c     | 1217 +++++++++++++
> >  12 files changed, 5123 insertions(+)
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/Kconfig
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/Makefile
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_drv_=
ver.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_hw.h
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_pci.=
c
> >  create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_swit=
chdev.c
> >=20

Regards,
Vadym Kochan
