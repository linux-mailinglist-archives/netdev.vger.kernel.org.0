Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BECF60C3
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 18:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKIRpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 12:45:45 -0500
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:3302
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726204AbfKIRpo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 12:45:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UDkIFD23o9Q2ZzY6jkyZwav9MUOLGc7qPGk3UH1bbqUye63YBiR73GReSbOGTPHz/4tk1TBntnYrpJ8FyWTFN2n7yFB1qPpPzQkStzWdPmDzYZcMV8ya3Xa3L5gFBzs57D2rCSGaYSC+wYJK7UIbKrt36PDvGv9aFqTTs9oUdROnsvm8I4dfePegme9EhqFZ22hlnHOH3iX9XD9UdEYXTbzopf1riFAyTO5wqpB4d6xT4IvE4ZAOQUD6R69yxtG2aq8guIZQWrDz3+rDEy7XffnsgIqXUtJc1bSbHOllWZMOs8nmfn5JylU6HXtP+igguOXSNKA2SEHe57732a+jGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9l9UwnVT/yDjAjwXa/KzaTusRJlVnmjVi9kSPkdZqM=;
 b=ffZ879Bei/GE5t/IAxz3sFA2coYoMX7cet+cpWEbGj5hggN/vdEuZZZyjvFOi7qr+oh230FE8qPIT57Ygk1xxf6sOXJ6cXdVN1R0e6fVOnmGhCHkZKZb8eV7e9/g6uWgDXrC1dE3KlBIEDjGxrYFbZ0PQezgQVazGYRI4D24n35Y3Rk4qflO3pIuMNr3DbTZnMDaJQKfTiwnRWpZyae0e+wVjGY91c9NGGJerAS43ITJ1bX/Nn27Rm8182IpPNh6YNmqquOIQtLM1ZOYm8xnkXWL8EerBBXdYofThaCdfrmel3244Byij8LATeTJJ7Ds8F24JSWNjFE9SMMcgu2VvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9l9UwnVT/yDjAjwXa/KzaTusRJlVnmjVi9kSPkdZqM=;
 b=mNu7uNLAKgxf82dYQuJfzhvn3P5P+McHwnSrGZTnUSVA4eat9WvMB1nlSYAjtsNLdEkrziogv94FTUkQzIulR4yiwAnbc5b8g4TZEhMTnkai7U/fDYwSFsMJOVDYpUZjimzDpWuDBQs6lmqH5NdJwdPRSqKyCba5ggjIdBXoSDc=
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com (20.177.197.210) by
 AM6PR05MB5318.eurprd05.prod.outlook.com (20.177.191.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Sat, 9 Nov 2019 17:45:01 +0000
Received: from AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::2c8b:72fb:19e2:ff34]) by AM6PR05MB5142.eurprd05.prod.outlook.com
 ([fe80::2c8b:72fb:19e2:ff34%4]) with mapi id 15.20.2430.023; Sat, 9 Nov 2019
 17:45:01 +0000
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     Parav Pandit <parav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Thread-Topic: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Thread-Index: AQHVllBEjaulcda5Yki5oMDisUeEGKeBkCsAgAGMhGA=
Date:   Sat, 9 Nov 2019 17:45:00 +0000
Message-ID: <AM6PR05MB5142FEFE41F0B06B7E61FEC5C57A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
 <1573229926-30040-5-git-send-email-yuvalav@mellanox.com>
 <AM0PR05MB48663DAB2C9B5359DB15BB89D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
In-Reply-To: <AM0PR05MB48663DAB2C9B5359DB15BB89D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yuvalav@mellanox.com; 
x-originating-ip: [70.66.202.183]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3335b4bd-e842-4a6f-2144-08d7653c8ba6
x-ms-traffictypediagnostic: AM6PR05MB5318:|AM6PR05MB5318:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB5318509218C8E1E5B365734BC57A0@AM6PR05MB5318.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 021670B4D2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(39850400004)(366004)(376002)(396003)(189003)(199004)(13464003)(9686003)(229853002)(478600001)(14454004)(6436002)(8676002)(316002)(256004)(81156014)(55016002)(81166006)(3846002)(6116002)(6246003)(54906003)(86362001)(26005)(8936002)(186003)(7736002)(53546011)(4326008)(52536014)(476003)(76116006)(2501003)(486006)(99286004)(74316002)(66556008)(64756008)(66446008)(2906002)(33656002)(71190400001)(71200400001)(102836004)(76176011)(66476007)(25786009)(66066001)(6506007)(66946007)(7696005)(5660300002)(11346002)(305945005)(110136005)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5318;H:AM6PR05MB5142.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KbMCA3d9cOzcqlS5RZ8Xnb21oT4Y0O9xt8gfTTRbnPqeduYPd3ke9/YTDEtF5FP9xmtwoc6gWB41pEiPB9UlRYzNeQWMe147F2Kp/gEC2w0T4FXgsahNGG5TyBqqyp5c5evOoqs4H4oqPqkK3q4Lar2OlQ70751VLnD1WOGUma7yQrHwoSSVKVScdLOMOHmHRVRs/iaCvrJQXw3oVREwmV7rCVDv3w58DAM0B8l2IAsOFTbIR5Unfq15d3eL5ift2Wp8TEhAhha+ibV98sZtpodv7tRrP/WAuTiY79qCjoEJ6uMDBn5uy0amgNDACwO1Ui8RhlO+g73ghwnHKTX6mYLQr83+EuC7bmUDLS5K58K1Gfa/EURM5uplpqxh/SifiwhegcauI4tCVdb23KmVStlYt2atGPsuJt9fYarsl67ZUDASpre5R7Ch5xIsMnWI
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3335b4bd-e842-4a6f-2144-08d7653c8ba6
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2019 17:45:01.0019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fpnCXCGPCk9/VQtomWjCbjnJRsib7kkRluit4heC5S7c3ICofKXS82L3av0Mxh2eB8Rpbpcf/P3Qwc4Iox30/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5318
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Parav Pandit
> Sent: Friday, November 8, 2019 10:00 AM
> To: Yuval Avnery <yuvalav@mellanox.com>; netdev@vger.kernel.org
> Cc: Jiri Pirko <jiri@mellanox.com>; Saeed Mahameed
> <saeedm@mellanox.com>; leon@kernel.org; davem@davemloft.net;
> jakub.kicinski@netronome.com; shuah@kernel.org; Daniel Jurgens
> <danielj@mellanox.com>; andrew.gospodarek@broadcom.com;
> michael.chan@broadcom.com; Yuval Avnery <yuvalav@mellanox.com>
> Subject: RE: [PATCH net-next v2 04/10] devlink: Support subdev HW address
> get
>=20
>=20
>=20
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On
> > Behalf Of Yuval Avnery
> > Sent: Friday, November 8, 2019 10:19 AM
> > To: netdev@vger.kernel.org
> > Cc: Jiri Pirko <jiri@mellanox.com>; Saeed Mahameed
> > <saeedm@mellanox.com>; leon@kernel.org; davem@davemloft.net;
> > jakub.kicinski@netronome.com; shuah@kernel.org; Daniel Jurgens
> > <danielj@mellanox.com>; Parav Pandit <parav@mellanox.com>;
> > andrew.gospodarek@broadcom.com; michael.chan@broadcom.com;
> Yuval
> > Avnery <yuvalav@mellanox.com>
> > Subject: [PATCH net-next v2 04/10] devlink: Support subdev HW address
> > get
> >
> > Allow privileged user to get the HW address of a subdev.
> >
> > Example:
> >
> > $ devlink subdev show pci/0000:03:00.0/1
> > pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr
> > 00:23:35:af:35:34
> >
> > $ devlink subdev show pci/0000:03:00.0/1 -pj {
> >     "subdev": {
> >         "pci/0000:03:00.0/1": {
> >             "flavour": "pcivf",
> >             "pf": 0,
> >             "vf": 0,
> >             "port_index": 1,
> >             "hw_addr": "00:23:35:af:35:34"
> I prefer this to be 'address' to match to 'ip link set address LLADDR'.
> That will make it consistent with rest of the iproute2/ip tool.
> So that users don't have to remember one mor keyword for the 'address'.
I think hw_addr is more accurate, and consistency doesn't exist here anyway=
.
We already have "ip link set vf set mac"
Address is not specific enough and can also mean IP address, while hw_addr
covers both ETH and IB

