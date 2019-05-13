Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6EA1BD2D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 20:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726728AbfEMSbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 14:31:03 -0400
Received: from mail-eopbgr60045.outbound.protection.outlook.com ([40.107.6.45]:33755
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725928AbfEMSbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 14:31:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nk8jaHYGsSWK1eIH8yAc0z2BL1JDFaYNAzM5F8bywak=;
 b=RmrhatQna84j7UeCcOw7N4BxYZ21KK9t5Tr6DKmr5kCzBhskx07Jj7Nbx5vmCOWAoZy9xA7KH3FGND95UrhrLWjfIBFk6wo0Pj5RN9MwJ7PGKZJf9xW9+wzYZqoNiHi02LKE++hrUFwRluK8pyhpn7s4vcDoNf5wpUzOSjoDN6w=
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (10.171.182.144) by
 VI1PR05MB5981.eurprd05.prod.outlook.com (20.178.127.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 18:30:58 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::711b:c0d6:eece:f044]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::711b:c0d6:eece:f044%5]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 18:30:58 +0000
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     David Miller <davem@davemloft.net>,
        "g@mellanox.com" <g@mellanox.com>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Annoying gcc / rdma / networking warnings
Thread-Topic: Annoying gcc / rdma / networking warnings
Thread-Index: AQHVCBnqId2qpywf80SpyVwZsFlKM6ZoQWSAgAAjEYCAAP9VgA==
Date:   Mon, 13 May 2019 18:30:58 +0000
Message-ID: <20190513183053.GI7948@mellanox.com>
References: <CAHk-=whbuwm5FbkPSfftZ3oHMWw43ZNFXqvW1b6KFMEj5wBipA@mail.gmail.com>
 <20190513011131.GA7948@mellanox.com>
 <20190512.201701.1918995863082655897.davem@davemloft.net>
In-Reply-To: <20190512.201701.1918995863082655897.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: YTOPR0101CA0062.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:14::39) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:4d::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [156.34.49.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea7b320a-c8a5-4e0c-e7d9-08d6d7d12454
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5981;
x-ms-traffictypediagnostic: VI1PR05MB5981:
x-microsoft-antispam-prvs: <VI1PR05MB5981F771F889C0DD98308273CF0F0@VI1PR05MB5981.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(396003)(39860400002)(366004)(199004)(189003)(66066001)(66446008)(86362001)(66556008)(66476007)(256004)(64756008)(14444005)(14454004)(478600001)(66946007)(316002)(110136005)(54906003)(68736007)(102836004)(8936002)(6246003)(386003)(6506007)(99286004)(8676002)(52116002)(6436002)(486006)(7736002)(6486002)(11346002)(446003)(476003)(4326008)(71190400001)(71200400001)(2616005)(53936002)(186003)(305945005)(26005)(81156014)(81166006)(76176011)(6512007)(2501003)(3846002)(6116002)(25786009)(33656002)(1076003)(36756003)(73956011)(6636002)(2906002)(5660300002)(229853002)(781001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5981;H:VI1PR05MB4141.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: eahiYIZS4Pibe0y6pyATzi6IVnzolXzbshzcbIEwq5zmxHQQexrjcNSHEaqsU1bfrMXGLq+eeb2VANJ8Los7hW6yMtk3NEFumJQtCsbdzFTNNJu8IkuKuIiM02agnzE1LPhED+IaZ/uRXgK1viMRunTVXY6pOAPjF387fQ1AFi/6k+xGcHchceuWTdVOGeP/F40MSDe3cADVJ1gaO03Z3qJ/6LmWRf+wIcuySqzjRMfhfjfb6LGlTgJlFzwKkolyVtp+NZ+bYF1iAP0J8gPIIxT/nDe2wuI/g03QKCMO9T9whUfe4HIvHsJBaA6aGrgNROawIqz5IeuCLO2TaJfevA/dRbvf5oUtc7yE7XxwgDY6eZtZJIk55G0ggiH7MM3sbrZk2rTpJPCZK5HR6UE2pCg1kPGanKNzWVi+gFHsf50=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93EB29960ADB1A469EF8B5521F803208@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea7b320a-c8a5-4e0c-e7d9-08d6d7d12454
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 18:30:58.2248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5981
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 12, 2019 at 08:17:01PM -0700, David Miller wrote:
> From: Jason Gunthorpe <jgg@mellanox.com>
> Date: Mon, 13 May 2019 01:11:42 +0000
>=20
> > I think the specific sockaddr types should only ever be used if we
> > *know* the sa_family is that type. If the sa_family is not known then
> > it should be sockaddr or sockaddr_storage. Otherwise things get very
> > confusing.
> >=20
> > When using sockaddr_storage code always has the cast to sockaddr
> > anyhow, as it is not a union, so this jaunty cast is not out of place
> > in sockets code.
>=20
> From what I can see, each and every call side of these helpers like
> rdma_gid2ip() et al. redefine this union type over and over and over
> again in the local function.

Yes, the repeated union is very ugly and could be consolidated - or
should just use sockaddr_storage in the first place.

> It seems that if we just defined it explicitly in one place, like
> include/rdma/ib_addr.h, then we could have tdma_gid2ip(), addr_resolve(),
> and rdma_resolve_ip() take that type explcitily.

I pulled on this thread for a while and the number of places that
would need to convert to use a global 'union rdma_sockaddr_inet'
started to become pretty silly and weird. I eventually reached a point
where I had to cast a sockaddr * to the union - which is something
that makes no sense and I gave up.

So, I think this feels simpler to follow the usual sockaddr_storage
pattern and only use the union to declare the initial storage. Then
everything else just uses the sockaddr * plus casts..

Jason
