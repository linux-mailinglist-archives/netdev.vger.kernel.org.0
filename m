Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2DE9504
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 03:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfJ3CaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 22:30:18 -0400
Received: from mail-eopbgr40070.outbound.protection.outlook.com ([40.107.4.70]:15430
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfJ3CaR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 22:30:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a7iHYbaG6OkeqdGILJFsGxlNggPQESoYEdeb0kT5+lOiwGfvMtVa2zOOKaf30u+oS4K+RBnCp6oF1pWttZdt0ypxG1Wbwp+rK2jbRScNalyTeFIUgUIn76pTOjxEAgSTKHLpLbJIRn5CLvy+Ph8FbFDxPDCZO6+IR97oBxDniR5S9kKmOCo2Fd6+o2nLzhys3Ed+PRPZOMFfp3m66JP0K4jE1WMvHPEz/Al0iXkpOvxqTKJHW41TBGCRQSMMEHXBNy0MLCZR45rpDrbMBnvbvBfaO4cC6AV18+u4B2PCxMdaEr9BdKqIOTE8Wu1OTJwQ8XyU2eGWXHSM6jffZw2akg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBIuaQ66R88bTHOiNRMlNsK6qEH1p4U4NrXV9PTU20U=;
 b=Ud+AREHZOXQvrLZkEibHDHNV80w8cV1iPGU+qpklbXGSw1N7/uG56wXJtf5VnWIzRoY9p3ntkhu0wXiSfJtRkHRNxW+diAuA7nZ0QGoQBrjIeJr3eW9BgsHsm+XM7zvznHNQzWKNLUkVR5130QfKw+w3SWU4gZw1n0LbMkifjJI/YuE6yJokYEfvDXg7rBWOn0Ae4tjTrlDGjwtqcpVokanrfKvheHLr3uauuZd1vzOPD2nAJYP3oPwGY2onvnbQe0AMabOkfFt6ReKg6TryS6/br2oviKsECdLSf6yzX5UInFjcHGv9WN/FG0NOPcZ1g5ahYHwN5bfUTKZ5gEdTRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KBIuaQ66R88bTHOiNRMlNsK6qEH1p4U4NrXV9PTU20U=;
 b=bfVWrMCrRfRaE+wkpXT0kjDkOqMhf/Hh8QNGALPkx+7hESXWIQ7cowj6n46JXz0WH+fehbFwIVS2Z2zfbazWg2+JKnEbufYGtUEHZMNN1za3qfN+UTMyFUnIgDqaP/SjAK9BvMOFXAtDjSr+W129ubqWD0wXQFtnibNvjME1AUI=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4529.eurprd05.prod.outlook.com (52.133.52.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 02:30:12 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::64b2:6eb4:f000:3432%7]) with mapi id 15.20.2387.028; Wed, 30 Oct 2019
 02:30:12 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>
CC:     Yuval Avnery <yuvalav@mellanox.com>, Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 0/9] devlink vdev
Thread-Topic: [PATCH net-next 0/9] devlink vdev
Thread-Index: AQHViQAzNybbKwGptUuLvXy+Vpqae6dollkAgAAG1ACAAC80gIAAIN8AgAAsrICAAl1MAIAGbagAgACbb3A=
Date:   Wed, 30 Oct 2019 02:30:12 +0000
Message-ID: <AM0PR05MB48669FDC1776B7BB0BB1A41ED1600@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
        <20191023120046.0f53b744@cakuba.netronome.com>
        <20191023192512.GA2414@nanopsycho>
        <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
        <9f3974a1-95e9-a482-3dcd-0b23246d9ab7@mellanox.com>
        <20191023195141.48775df1@cakuba.hsd1.ca.comcast.net>
        <20191025145808.GA20298@C02YVCJELVCG.dhcp.broadcom.net>
 <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191029100810.66b1695a@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [2605:6000:ec82:1c00:6dc9:f7cb:99b:a6d6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 11fdf54a-dbc1-4046-d30e-08d75ce11725
x-ms-traffictypediagnostic: AM0PR05MB4529:|AM0PR05MB4529:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB45294EF13FFACABB61E88B75D1600@AM0PR05MB4529.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(13464003)(14444005)(256004)(229853002)(8676002)(71190400001)(6246003)(52536014)(81156014)(476003)(5660300002)(478600001)(486006)(7736002)(74316002)(81166006)(2906002)(305945005)(71200400001)(8936002)(6116002)(25786009)(4326008)(53546011)(102836004)(66446008)(86362001)(66946007)(66556008)(66476007)(64756008)(6436002)(6506007)(76116006)(7696005)(99286004)(54906003)(76176011)(55016002)(14454004)(9686003)(46003)(11346002)(446003)(33656002)(110136005)(316002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4529;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZPhPZsQSIUCKPuM18JSjx55LviB9OoZKHDfDUaMn/vCjUUnR112aICRt4hRRRnq2gAK9cZUbV9+Ok3u0c3uRoeidDsyZAEFj7YKcrSLepITxYvSVMEDwogw8N6s9TtNpTrGuGIaj+p6sSlNkdpWlhR/4UL6H+tUeCONwKb5RtOWo6SO58aa8ZejKtABqdjCwOEqgrgYSHDXE+SvMNhXGM+ibtGoPk7v5rmsE0P/UU/ran9KNpgqjS9v4NSe93KSKb9tLZ3crcS9DvM9ZwU+NvBhuV0CljqBIE0wPcalhy7lTdfL6oTqCnWrc7wqP20FhLIL3hZjGZmI4qNoj24J+KmbodXU1TyRlHYo+WQVTBP/UGfyroYDy/LmW4Gd1b8gYC9uatCvTmstIJiV/mwowEQY6HCSAZHuF5bMi7GWHq9z/qMI/cpBo4s2KHkQFR2f3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11fdf54a-dbc1-4046-d30e-08d75ce11725
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 02:30:12.1106
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2cQJg6H+VoFeCT9FgmyWIP4+dnADJOLI7iPbZwH8+qBjpBm/DxYGIszJW9VkcG5VB/4CC6Lv4RsV9uxSlHzfbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4529
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Jakub Kicinski
> Sent: Tuesday, October 29, 2019 12:08 PM
> To: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> Cc: Yuval Avnery <yuvalav@mellanox.com>; Jiri Pirko <jiri@resnulli.us>;
> netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed Mahameed
> <saeedm@mellanox.com>; leon@kernel.org; davem@davemloft.net;
> shuah@kernel.org; Daniel Jurgens <danielj@mellanox.com>; Michael Chan
> <michael.chan@broadcom.com>
> Subject: Re: [PATCH net-next 0/9] devlink vdev
>=20
> On Fri, 25 Oct 2019 10:58:08 -0400, Andy Gospodarek wrote:
> > Thanks, Jakub, I'm happy to chime in based on our deployment experience=
.
> > We definitely understand the desire to be able to configure properties
> > of devices on the SmartNIC (the kind with general purpose cores not
> > the kind with only flow offload) from the server side.
>=20
> Thanks!
>=20
> > In addition to addressing NVMe devices, I'd also like to be be able to
> > create virtual or real serial ports as well as there is an interest in
> > *sometimes* being able to gain direct access to the SmartNIC console
> > not just a shell via ssh.  So my point is that there are multiple use-c=
ases.
>=20
> Shelling into a NIC is the ultimate API backdoor. IMO we should try to av=
oid
> that as much as possible.
>=20
> > Arm are also _extremely_ interested in developing a method to enable
> > some form of SmartNIC discovery method and while lots of ideas have
> > been thrown around, discovery via devlink is a reasonable option.  So
> > while doing all this will be much more work than simply handling this
> > case where we set the peer or local MAC for a vdev, I think it will be
> > worth it to make this more usable for all^W more types of devices.  I
> > also agree that not everything on the other side of the wire should be
> > a port.
> >
> > So if we agree that addressing this device as a PCIe device then it
> > feels like we would be better served to query device capabilities and
> > depending on what capabilities exist we would be able to configure
> > properties for those.  In an ideal world, I could query a device using
> > devlink ('devlink info'?) and it would show me different devices that
> > are available for configuration on the SmartNIC and would also give me
> > a way to address them.  So while I like the idea of being able to
> > address and set parameters as shown in patch 05 of this series, I
> > would like to see a bit more flexibility to define what type of device
> > is available and how it might be configured.
>=20
> We shall see how this develops. For now sounds pretty high level.
> If the NIC needs to expose many "devices" that are independently controll=
ed
> we should probably look at re-using the standard device model and not
> reinvent the wheel.
> If we need to configure particular aspects and resource allocation, we ca=
n
> add dedicated APIs as needed.
>=20
> What I definitely want to avoid is adding a catch-all API with unclear
> semantics which will become the SmartNIC dumping ground.
>=20
What part is unclear in API? Can you be specific?
Subdev is not a dumping ground and so the devlink port is not a dumping gro=
und either.
Having a more well defined object such as subdev with covers more than just=
 port attribute (instead of devlink port) doesn't make it a dumping ground.

As I explained in previous email, subdev is intended to have attributes of =
the device (PF/VF/mdev).
Additionally as Andy described, resources will be linked to such subdev.

Keep in mind that this is anyway useful without smartnic usecase too immedi=
ately.

> > So if we took the devlink info command as an example (whether its the
> > proper place for this or not), it could look _like_ this:
> >
> > $ devlink dev info pci/0000:03:00.0
> > pci/0000:03:00.0:
> >   driver foo
> >   serial_number 8675309
> >   versions:
> > [...]
> >   capabilities:
> >       storage 0
> >       console 1
> >       mdev 1024
> >       [something else] [limit]
> >
> > (Additionally rather than putting this as part of 'info' the device
> > capabilities and limits could be part of the 'resource' section and
> > frankly may make more sense if this is part of that.)
> >
> > and then those capabilities would be something that could be set using
> > the 'vdev' or whatever-it-is-named interface:
> >
> > # devlink vdev show pci/0000:03:00.0
> > pci/0000:03:00.0/console/0: speed 115200 device /dev/ttySNIC0
>=20
> The speed in this console example makes no sense to me.
>=20
> The patches as they stand are about the peer side/other side of the port.=
 So
> which side of the serial device is the speed set on? One can just read th=
e
> speed from /dev/ttySNIC0. And link that serial device to the appropriate
> parent via sysfs. This is pure wheel reinvention.
>=20
> > pci/0000:03:00.0/mdev/0: hw_addr 02:00:00:00:00:00 [...]
> > pci/0000:03:00.0/mdev/1023: hw_addr 02:00:00:00:03:ff
> >
> > # devlink vdev set pci/0000:03:00.0/mdev/0 hw_addr 00:22:33:44:55:00
> >
> > Since these Arm/RISC-V based SmartNICs are going to be used in a
> > variety of different ways and will have a variety of different
> > personalities (not just different SKUs that vendors will offer but
> > different ways in which these will be deployed), I think it's critical
> > that we consider more than just the mdev/representer case from the star=
t.
