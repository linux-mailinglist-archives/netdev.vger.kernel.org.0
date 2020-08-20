Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDD124B9FA
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 13:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgHTL5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 07:57:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25500 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730477AbgHTKAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:00:42 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K9xhxA015087;
        Thu, 20 Aug 2020 03:00:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=P/MfP1iatemiM3JaELHP21Kvm0d9U5mJjVFa/OckK1E=;
 b=JYyop6Xh0nLZBqtIaWKprOTPdY8M0/LSx0yzLOd60iI8VtqvdWh3O9iScRwrpiOulm1A
 UwxvLgWJWlz2QADMJRDrcxgJ4nPzCXk8WH1HscBvtwTo7kLGZx7tu7uASh55Y7LPMx+b
 F/EAYfZ5QAER/nXjcJHxXIWpak/weX+lkhe4hXrVONNUVCGTjtfbY7togrfy+CmZgko6
 NJ5v1aTSWFpgPU7V/u55UjfwOVNrB+XZbfbWnoDHXw49aifyX41yRnB07T2/r8iY7MSU
 jFCH+i+Rtzgvs8nhjSZS/IX6qSlUhIxMQOAOHuBdEer6IlMNrR3xKrHnT9eHovkTMKuV dA== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3304fhvs01-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 03:00:24 -0700
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 20 Aug
 2020 03:00:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by SC-EXCH02.marvell.com (10.93.176.82) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 20 Aug 2020 03:00:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjFMaAGFi6+jGWHnZwGBHG5XHuRMLm8I52rMEea8s4XWVFDigHAcCovYk1BlwJb2QzdkZCVU/HMB2v1NXVJVrAnGtKD7N75daXCaHclO9lxTSDw+fjzob7MFAgX8DWcoQk0AnRrs/c1YD4q5HW3KUFZDuNKheEYUNt/85i3tzp/ddlzLUAj7zxptSB22TgB59yC71qsb6E8V/C3KPZCxu1JlC8q54NSFNEVOrYixNh2Mj07kY+t0K/za/HqIwLa7CDQjEBtYEVF8Q2+EyD2DjqSt6RtNor0i9GcQsIeX9qILTQH+StJk4Fe0Mmhn9LCusX6aOsKQLP0/YZop7Nt2DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/MfP1iatemiM3JaELHP21Kvm0d9U5mJjVFa/OckK1E=;
 b=EFsTtawXhXK/34lwJliMDtgLeovnYhzy5swVeiXvNTCRgnCIUkCJHIjHjRGAB0EBfy/OJ8IHxD0stL9jMCmS4nNvAtct2lrul320qTOYKRy7RI9blIueBLn14ilrRryeRgAzpzmRB44zYv737yvCjUGLppKClOGRFxW28OMwzmKN4ElVNv9hk1QWaEocgjUG5Z8YK7gTWWBZfxC2UY/NA/IOBB16fZZQeZlTe7mNaSHS6ko89bUkkZTAm+DPhpFUwGqXMEcicgRD/LJ4rKQTVAq0bMzDXN5jLmp7vPLFUwRGTS/gWt1mqDK9EpiVvQ2nONR0CLBP8PC49kb/BI9lvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/MfP1iatemiM3JaELHP21Kvm0d9U5mJjVFa/OckK1E=;
 b=OyjXcUdWjvd7JISGiXDRaDp2OnYfvZb2FOaznyWTjp47zeTyIZEJmxZUqpenCbrHJuT5OdmMYQBI+HmPoqvZKqrOf38RvDKh5128SHpF8vq5x1fwxmT23RDmT5wNK5OcpGXc6AmHVe7nAWRlSsksUwcG+dxx2FUVB3ocNNiOHzU=
Received: from BN6PR18MB1587.namprd18.prod.outlook.com (2603:10b6:404:129::18)
 by BN8PR18MB2721.namprd18.prod.outlook.com (2603:10b6:408:a4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16; Thu, 20 Aug
 2020 10:00:21 +0000
Received: from BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::c4c4:97de:3cc1:6fcd]) by BN6PR18MB1587.namprd18.prod.outlook.com
 ([fe80::c4c4:97de:3cc1:6fcd%11]) with mapi id 15.20.3283.028; Thu, 20 Aug
 2020 10:00:21 +0000
From:   Mickey Rachamim <mickeyr@marvell.com>
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Jonathan McDowell <noodles@earth.li>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: RE: [EXT] Re: [net-next v4 1/6] net: marvell: prestera: Add driver
 for Prestera family ASIC devices
Thread-Topic: [EXT] Re: [net-next v4 1/6] net: marvell: prestera: Add driver
 for Prestera family ASIC devices
Thread-Index: AQHWcj2Z7ghqmC8NyEeNZq3OYcL+5alAtCGAgAAHRVA=
Date:   Thu, 20 Aug 2020 10:00:21 +0000
Message-ID: <BN6PR18MB1587EB225C6B80BF35A44EBFBA5A0@BN6PR18MB1587.namprd18.prod.outlook.com>
References: <20200727122242.32337-1-vadym.kochan@plvision.eu>
 <20200727122242.32337-2-vadym.kochan@plvision.eu>
 <20200813080322.GH21409@earth.li> <20200814082054.GD17795@plvision.eu>
 <20200814120536.GA26106@earth.li> <20200814122744.GF17795@plvision.eu>
 <20200814131815.GA2238071@lunn.ch> <20200820083131.GA28129@plvision.eu>
In-Reply-To: <20200820083131.GA28129@plvision.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [89.139.88.218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 42e979da-23ae-4444-7647-08d844efd9c1
x-ms-traffictypediagnostic: BN8PR18MB2721:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BN8PR18MB2721FCE265189A780364D302BA5A0@BN8PR18MB2721.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Oh1wX/T/CaRFxewj6NWKhuT9ZLdZzKqZXhp1/gPeVEdGMp/Xax+XGNsfJpgLfQLJqmkDrWlP48xZUSomtzDX57Ad9dvPb/V+GUpdFwj4BNQH1CKzcbaek0BzSKwyFNl1kVrJ2c96NmaaBMqfk8H9lMyVAUPD2Dg/p0jLUto9Mu7JvgZ831r9rmexnNOJNvXHbcXewybooP4z0QUha8lAkAdCmwriwJ0OIOgFkxFFZI29qDraskcshmxQcaUXHufSYU323Kq2gKwbPkt/Lm9UcxN8tSeuEwYCibLkdz8MwrzDJxZ/Bfcy3oZRk+dceW3nw7SobjYpuDUfXOwryjccvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR18MB1587.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(346002)(136003)(39860400002)(66556008)(66476007)(66946007)(71200400001)(64756008)(76116006)(8676002)(33656002)(8936002)(7696005)(478600001)(66446008)(52536014)(316002)(83380400001)(86362001)(4326008)(26005)(6506007)(9686003)(2906002)(7416002)(186003)(5660300002)(54906003)(110136005)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 6Rwlgl+Q23Sqn0py9ZiWe66HJUHb8R3uFmGvgL/GwZyu37QhJcIqAdsupdcuh6IVMmg2/7VeLGaXNntej326ngYvgSj3LUnXWriywWkILWDlyGtrkA28NTQAP2OT1EBqgHlNtKRinI+7k+VONhIsYHBY1tYNHOIt5Agi26ckDzO+eoxnn+oBTXGrcWJ/UuqzUzIhUg+mgSB93DcHzapsXPfbV0HhEBoC/KwgudNapPsAOCmXcY3EhlAkeXCXP4aSszkdVlyf6HNG0g3xYeMABf4Zqc1JOxzzKzmHNFiXzJg1PaJykpeTe2W0dBh6JpFLRXdKImIhcirgojbxpvTFh+pG1M3CcfUSzDRldbbEMV0mNbSCufCBVL7717uLG93SQayKjcGQSr/dXsBPnHKf8X9eH4kKJIl9h/xOUzske2sckRqQLjihFICnqG8gv5LVcceGKrt5/IIZmTFuJHWmjEQPFJxJgdW/tk1bYTLvgjlXXRrHs1KQag9PZOKKFKgYDCUhQL3ookdchW36ob+nbxgywYGSd6sapHBjlorwL5rYgmlE0UBC3Gnzot93hyt11DXjiROCC8SeLJVaO2vlbhRheWc4CG/getb0SMi/DrXX/os4Al8PpLybSiSMUuLQbOKAGXvV8uLTXDPwIqKOUQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR18MB1587.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e979da-23ae-4444-7647-08d844efd9c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 10:00:21.1963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EYTFGwK/ZIsHaMrQWsS8wmq7LBFGC3QK9UJ69Em+fODvp+xLUdgk4GQirWcC/u09SbUgMnuqReNZ9Xw8mqRiZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR18MB2721
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_02:2020-08-19,2020-08-20 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

External Email

Hi Andrew,=20
My name is Mickey and I'm the SW group manager in Marvell working on the Sw=
itchdev drivers for the Prestera Switching family.
In addition to Vadym's reply, please have my comments inline;

On Fri, Aug 14, 2020 at 03:18:15PM +0200, Andrew Lunn wrote:
> > > > > Currently
> > > > >=20
> > > > >     compatible =3D "marvell,prestera"
> > > > >=20
> > > > > is used as default, so may be
> > > > >=20
> > > > > you mean to support few matching including particular silicon too=
, like ?
> > > > >=20
> > > > >=20
> > > > >     compatible =3D "marvell,prestera"
> > > > >     compatible =3D "marvell,prestera-ac3x"
> > > > >=20
> > > > > Would you please give an example ?
> > > >=20
> > > > AFAICT "Prestera" is the general name for the Marvell=20
> > > > enterprise/data-centre silicon, comparable to the "LinkStreet"
> > > > designation for their lower end switching. The mv88e* drivers do=20
> > > > not mention LinkStreet in their compatible strings at all,=20
> > > > choosing instead to refer to chip IDs (I see mv88e6085, mv88e6190 +=
 mv88e6250).
> > > >=20
> > > > I do not have enough familiarity with the Prestera range to be=20
> > > > able to tell what commonality there is between the different=20
> > > > versions (it appears you need an NDA to get hold of the=20
> > > > programming references), but even just looking at your driver and=20
> > > > the vendor code for the BobCat it seems that AlleyCat3 uses an=20
> > > > extended DSA header format, and requires a firmware with message=20
> > > > based access, in comparison to the BobCat which uses register pokin=
g.
> > > >=20
> > > > Based on that I'd recommend not using the bare "marvell,prestera"
> > > > compatible string, but instead something more specific.
> > > > "marvell,prestera-ac3x" seems like a suitable choice, assuming=20
> > > > that's how these chips are named/generally referred to.
> > > >=20
> > > > Also I'd expand your Kconfig information to actually include=20
> > > > "Marvell Prestera 98DX326x" as that's the only supported chip range=
 at present.
> > > >=20
> > >=20
> > > Yes, Prestera covers more range of devices. But it is planning to=20
> > > cover other devices too, and currently there is no device-specific=20
> > > DTS properties which are used in this version, but only the generic=20
> > > one - since only the MAC address node.
> > >=20
> > > I mean that if there will be other Prestera devices supported then=20
> > > it will require to extend the DTS matching string in the driver just=
=20
> > > to support the same generic DTS properties for new device.
> > >=20
> > > Anyway I will rise and discuss this question.
> >=20
> > Hi Vadym
> >=20
> > Lets start with how mv88e6xxx does this. The switches have ID=20
> > registers. Once you have read the ID registers, you know what device=20
> > you have, and you can select device specific code as needed. However,=20
> > these ID registers are in three different locations, depending on the=20
> > chip family. So the compatible string is all about where to read the=20
> > ID from, not about what specific chip is. So most device tree bindings=
=20
> > say "marvell,mv88e6085", but the 6390 family use "marvell,mv88e6190"
> > for example.
> >=20
> > This naming scheme is actually odd compared to others. And that=20
> > oddness causes confusion. But it avoids a few problems. If you have=20
> > per chip compatible strings, what do you do when it conflicts with the=
=20
> > ID registers. If from day 1 you validate the compatible string against=
=20
> > the ID register and fail the probe if it is incorrect, you are O.K.=20
> > But if you decide to add this validation later, you are going to find=20
> > a number of device tree blobs which have the wrong compatible string.=20
> > Do you fail the probe on boards which have worked?
> >=20
> > So what to do with this driver?
> >=20
> > Does the prestera have ID registers? Are you using them in the driver?
> >=20
>=20
> ASIC device specific handling is serviced by the firmware, current driver=
's logic does not have PP specific code and relies on the FW ABI which is P=
P-generic, and it looks like this how it should work for boards with other =
ASICs, of course these boards should follow the Marvell's Switchdev board d=
esign.
>=20

All Marvell Prestera (DX) devices are all based on CPSS SDK. This is one SD=
K=20
and one build procedure that enables the Prestera driver to support all dev=
ices.=20
This unified support enables us (and our customers) to have one SW=20
implementation that will support variety of Prestera devices in same build/=
real-time=20
execution.=20
This approach also lead us with the implementation of the Prestera Switchde=
v drivers.
As having detailed familiarity (20Y) with Marvell Prestera old/current/futu=
re devices -=20
this approach will be kept strictly also on the future.

> > Marvell is not particularly good at backwards compatibility. Does your=
=20
> > compatible string give you enough wiggle room you can easily introduce=
=20
> > another compatible string in order to find the ID registers when they=20
> > move?
> >=20
> > 	Andrew

