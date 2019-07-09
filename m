Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DBF663BD3
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfGITVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:21:54 -0400
Received: from mail-eopbgr80044.outbound.protection.outlook.com ([40.107.8.44]:25473
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726133AbfGITVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 15:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VA2/BF00EFFdgaFChCkXi68lehQILk3dVqNFgCXiTfs=;
 b=Z/jhG6wuzcc9PNUNC8JStSK5tChYwvdQ5eO/I8/ZOxVTbcaUJmP8/g2QonIwF6IZc4vyDmnAPEn7x8Vf3602BYPB/nENejbVLiB95XxB2XBfMfHeYSdrZrbgqyMuJlXLN/+iqN6LpEKXAH5Wio+8my0juDXif5V99Rt9kO0si/8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6225.eurprd05.prod.outlook.com (20.178.114.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Tue, 9 Jul 2019 19:21:47 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 19:21:47 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     David Miller <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Thread-Topic: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports and
 attributes
Thread-Index: AQHVNg1tsiPOY/l61Umq9TRaQKUK/6bBxXIAgAAKVoCAAMo5AIAAC+kAgAADrXA=
Date:   Tue, 9 Jul 2019 19:21:47 +0000
Message-ID: <AM0PR05MB4866F357E2116E1073E60BB2D1F10@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190708224012.0280846c@cakuba.netronome.com>
        <20190709061711.GH2282@nanopsycho.orion>
        <20190709112058.7ffe61d3@cakuba.netronome.com>
 <20190709.120336.1987683013901804676.davem@davemloft.net>
In-Reply-To: <20190709.120336.1987683013901804676.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [49.207.52.95]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4a36b30-2d03-4709-c17d-08d704a2afcc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB6225;
x-ms-traffictypediagnostic: AM0PR05MB6225:
x-microsoft-antispam-prvs: <AM0PR05MB6225D891ABFED2312783CEC8D1F10@AM0PR05MB6225.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(39860400002)(366004)(346002)(13464003)(52314003)(189003)(199004)(81156014)(478600001)(66476007)(486006)(2906002)(81166006)(8676002)(76116006)(52536014)(5660300002)(9686003)(305945005)(7736002)(66556008)(14454004)(55016002)(66446008)(25786009)(11346002)(8936002)(446003)(74316002)(476003)(64756008)(73956011)(26005)(107886003)(229853002)(316002)(110136005)(6116002)(71190400001)(53936002)(86362001)(66946007)(3846002)(186003)(102836004)(66066001)(6506007)(99286004)(6436002)(7696005)(71200400001)(4326008)(256004)(68736007)(76176011)(54906003)(6246003)(2501003)(53546011)(33656002)(55236004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6225;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wv2eLkrio4ngT0sm6YVW4BAdzo5TTiALcHGPUUDBW9LaROfoRbiHxgo+q+CofJ5Y1gbyzwG/nsiHQ2LamObYNqUILHgVLp89qmRMjPVnxWAQNmC6JWzyk5g+gNMRI6EvtmgvIf9ldjYq9SowIvXKY7ZZgxIOr58KJStdd/RTxo7PIEe5g4sd6+QREMw20Pv7u7CEqUkNFK17pSWJFCV6JHy9FL2k7vsv/RGNp2YfRB4PczRJmpsfa7hj2+EXnN4LGIL4KuSPa9k3VhFDRVktBKccY2xw6hyW94SM07yCJrCA1kV+VJMPGbRqfwnYtBdEeajTPrhsNnGSBywmM1T+VY0jmO4toIhoqBkI7iCO49CuUthkFdNWmT158ayyxED+KnFQXfUHbs99WUHlkv68YC9xQemn6H0d8V4FwPBhnNE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4a36b30-2d03-4709-c17d-08d704a2afcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 19:21:47.5669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

> -----Original Message-----
> From: David Miller <davem@davemloft.net>
> Sent: Wednesday, July 10, 2019 12:34 AM
> To: jakub.kicinski@netronome.com
> Cc: jiri@resnulli.us; Parav Pandit <parav@mellanox.com>;
> netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed Mahameed
> <saeedm@mellanox.com>
> Subject: Re: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports =
and
> attributes
>=20
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Tue, 9 Jul 2019 11:20:58 -0700
>=20
> > On Tue, 9 Jul 2019 08:17:11 +0200, Jiri Pirko wrote:
> >> >But I'll leave it to Jiri and Dave to decide if its worth a respin
> >> >:) Functionally I think this is okay.
> >>
> >> I'm happy with the set as it is right now.
> >
> > To be clear, I am happy enough as well. Hence the review tag.
>=20
> Series applied, thanks everyone.
>=20
> >> Anyway, if you want your concerns to be addresses, you should write
> >> them to the appropriate code. This list is hard to follow.
> >
> > Sorry, I was trying to be concise.
>=20
> Jiri et al., if Jakub put forth the time and effort to make the list and =
give you
> feedback you can put forth the effort to go through the list and address =
his
> feedback with follow-up patches.  You cannot dictate how people give
> feedback to your changes, thank you.

I will be happy to write follow up patches.
mostly in kernel 5.4, I will be adding mdev (mediated device) port flavour =
as discussed in past.
I will possibly write up follow up patch or two before posting them or have=
 it in that series, as it will extend this devlink code further.
