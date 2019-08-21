Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 985219709C
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 05:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbfHUD50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 23:57:26 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:19562
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726463AbfHUD5Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 23:57:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipS2dhJzZMEn7EB9d6hoaCVwRJjxg9d6Duz9g5ehwv2AOnhTH7mueX7NokvgVEAQ3/Gj6NFgoe7/fMy0jafYmhoVrXT8PRWmDWDjt9f54+xqpM2ldMWPMK0tbVTH+M3bRgS3JPJ8oJ9yte/AU9usM+ejGlJn1EnM6ocQQzq4/SZp6J+3pFgZX44qsUPs6PciIvt6I+FctlxbH73YjHGgveO/qNb5keBYnyO6LHSbfX7RgQVC+W5rOYksLAuNwRSotyDGRGkAD1UIxuIJ/a6EY3IMNcVQ8kpyBkSYqHxmM2aTMjbchAXjPGfuhbAwEn0RG6IkiRC08HdSUWlQ7s7PrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W28qRkjGL70oU211JfV2hFRYXayER2o2uojgjk1VkjE=;
 b=iWkaBJOEMDOfNjNIoQczVDvoXctYkjU3A2EU6Kd2fdnKxjEpe+Fo1cfF58Q65wSDQGCICcO8vXTon+0pX4uVy+hr9FVFqxnqBZCk47+i42n4lNyuTT0e9t7ZcRIYqPBJuBqIjFpiFLkkUdUDgChjoJnwUVIxIlDsJF6ApgXtNeRdEA6aa9PncDZAicVwFLJCMT9D5XC2ly0Mspk7llz4UeRQqdTVYIOSXY6HwKdAwueQiYIc6jNd5eVx7o+PEASA4CaOV2JPEa5Fznq31kEtf8TfoWvudHCBI6tMhfboR50EXl6WwVQ098gOFMZwsL0qMjfvIZdq2Gp5Orr5Jh3kKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W28qRkjGL70oU211JfV2hFRYXayER2o2uojgjk1VkjE=;
 b=jSV4OHWTHDTDOcNoJ69A4jOaSwWxEsF9t4SaryQDJKrLPWMU/Rr8CCtfM3V8Aduo0LRxKFSLmA2wwZtWtF1s9nckIdPO0wuQs9CML7fzYU/vZBtw09OiB1/2/cXePogg7ooWqxDma9I8s7HmhDi+TZ8iyTDsyES1bm9xlK3IeY4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5089.eurprd05.prod.outlook.com (20.177.41.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 21 Aug 2019 03:57:19 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::216f:f548:1db0:41ea%6]) with mapi id 15.20.2178.020; Wed, 21 Aug 2019
 03:57:19 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cjia <cjia@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Topic: [PATCH v2 0/2] Simplify mtty driver and mdev core
Thread-Index: AQHVTfNxjgfwJJG2ZUiuOAmKCwQvf6bx3uKAgAWJU4CAAcVCEIAABCsAgAAWVtCAABCDgIAAzoewgAAqE4CAAECFQIAAFWyAgAAGbNCAABfqAIAAErcwgAjpulCAAJkHAIAACiGAgACnvZA=
Date:   Wed, 21 Aug 2019 03:57:19 +0000
Message-ID: <AM0PR05MB48660532A1A063FF1BD5E4AED1AA0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190802065905.45239-1-parav@mellanox.com>
        <20190808141255.45236-1-parav@mellanox.com>     <20190808170247.1fc2c4c4@x1.home>
        <77ffb1f8-e050-fdf5-e306-0a81614f7a88@nvidia.com>
        <AM0PR05MB4866993536C0C8ACEA2F92DBD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813085246.1d642ae5@x1.home>
        <AM0PR05MB48663579A340E6597B3D01BCD1D20@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190813111149.027c6a3c@x1.home>
        <AM0PR05MB4866D40F8EBB382C78193C91D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814100135.1f60aa42.cohuck@redhat.com>
        <AM0PR05MB4866ABFDDD9DDCBC01F6CA90D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814150911.296da78c.cohuck@redhat.com>
        <AM0PR05MB48666CCDFE985A25F42A0259D1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190814085746.26b5f2a3@x1.home>
        <AM0PR05MB4866148ABA3C4E48E73E95FCD1AD0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <AM0PR05MB48668B6221E477A873688CDBD1AB0@AM0PR05MB4866.eurprd05.prod.outlook.com>
        <20190820111904.75515f58@x1.home> <20190820195519.47d6fd6a.cohuck@redhat.com>
In-Reply-To: <20190820195519.47d6fd6a.cohuck@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.188]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0456287-cccd-4ab9-44d0-08d725ebaa0c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB5089;
x-ms-traffictypediagnostic: AM0PR05MB5089:
x-ld-processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5089923390469B8269A15F38D1AA0@AM0PR05MB5089.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(199004)(189003)(13464003)(8676002)(81156014)(102836004)(55236004)(81166006)(8936002)(33656002)(14444005)(478600001)(3846002)(186003)(256004)(76176011)(7696005)(26005)(52536014)(66066001)(71200400001)(9456002)(71190400001)(5660300002)(54906003)(53936002)(86362001)(446003)(99286004)(9686003)(110136005)(14454004)(66446008)(6246003)(66556008)(66476007)(64756008)(4326008)(66946007)(316002)(6116002)(476003)(6436002)(7736002)(6506007)(25786009)(53546011)(2906002)(76116006)(74316002)(486006)(11346002)(229853002)(55016002)(305945005)(414714003)(473944003)(357404004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5089;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uHV77799Bu7orky52weKFu5Rce8u3fsC/TiPpHIQvD6MQbR27xYAsDS3QzORFmFyRWGTXhk+H1GYb7XTOOd5Y2YKvuCbiDQbbKOFdGJ+9ZB9XKEZkuz5wLtglF7xpPMs+Uux+urwZBu4oEWYHQMJ4oXUkBppPIpSnOxeCcTztZLkSpZac+nZvQZqXmy1bHDm/PGmYU3KJ1UeeTjrz1WnOZ89tx6pVaL8oTainZ6qhI8AGK5lp8gzXJbcQiHg4hZ64QVyllrBQjM6jEDDtUHFQkUyo6vKL1YC8EYKCU0LwfdsQo9/hATULfTdsnT309cYCwQNopSFFZa4RAdTndNUbwlgPurYl/Zt3v/ZDl+P2mK92p6DKNMzDy0lTEaKtkZFk9RJqYLF285EyXU2Xrub3vxpjGrCRsYU5yjGmVVZYdU=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0456287-cccd-4ab9-44d0-08d725ebaa0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 03:57:19.4308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6U/IJWC/BWzUbGPurpf/eNj6UVxYPo1OZjQ4UiLreNQnS9+/zdOYMghZeQN60PdjrbZOwBgqPtk68FMjwt0lTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5089
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Cornelia Huck <cohuck@redhat.com>
> Sent: Tuesday, August 20, 2019 11:25 PM
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Parav Pandit <parav@mellanox.com>; Jiri Pirko <jiri@mellanox.com>;
> David S . Miller <davem@davemloft.net>; Kirti Wankhede
> <kwankhede@nvidia.com>; kvm@vger.kernel.org; linux-
> kernel@vger.kernel.org; cjia <cjia@nvidia.com>; netdev@vger.kernel.org
> Subject: Re: [PATCH v2 0/2] Simplify mtty driver and mdev core
>=20
> On Tue, 20 Aug 2019 11:19:04 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
>=20
> > What about an alias based on the uuid?  For example, we use 160-bit
> > sha1s daily with git (uuids are only 128-bit), but we generally don't
> > reference git commits with the full 20 character string.  Generally 12
> > characters is recommended to avoid ambiguity.  Could mdev
> > automatically create an abbreviated sha1 alias for the device?  If so,
> > how many characters should we use and what do we do on collision?  The
> > colliding device could add enough alias characters to disambiguate (we
> > likely couldn't re-alias the existing device to disambiguate, but I'm
> > not sure it matters, userspace has sysfs to associate aliases).  Ex.
> >
> > UUID=3D$(uuidgen)
> > ALIAS=3D$(echo $UUID | sha1sum | colrm 13)
> >
> > Since there seems to be some prefix overhead, as I ask about above in
> > how many characters we actually have to work with in IFNAMESZ, maybe
> > we start with 8 characters (matching your "index" namespace) and
> > expand as necessary for disambiguation.  If we can eliminate overhead
> > in IFNAMESZ, let's start with 12.  Thanks,
> >
> > Alex
>=20
> I really like that idea, and it seems the best option proposed yet, as we=
 don't
> need to create a secondary identifier.
User setting this alias at mdev creation time and exposed via sysfs as read=
 only attribute works.
Exposing that as
const char *mdev_alias(struct mdev_device *dev) to vendor drivers..

