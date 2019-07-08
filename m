Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48C5461A0C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 06:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbfGHEet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 00:34:49 -0400
Received: from mail-eopbgr00082.outbound.protection.outlook.com ([40.107.0.82]:55040
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727341AbfGHEet (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jul 2019 00:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8IEFy0j/cvJPEg2lpWlXPbKH2DmHJMxuzF2m8WC1cI=;
 b=LuYC+Hzq+zicV2AcqsUFWy5dJH+HCzN9UAieIPy4mJuuWRQ3zUweFv1L9Y+7bphSIhwsXxEJXuObK6YQTOXwqonnJieBKuaAbHi5ieBqbpYmd5MbvC+qE02GSzubBTTziUT5Wy0/PvTnRhhPK5n/3K321eh+kgtSwzX9r/+Udh0=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4739.eurprd05.prod.outlook.com (52.133.54.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Mon, 8 Jul 2019 04:34:44 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 04:34:44 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
Subject: RE: [PATCH net-next v4 1/4] devlink: Refactor physical port
 attributes
Thread-Topic: [PATCH net-next v4 1/4] devlink: Refactor physical port
 attributes
Thread-Index: AQHVNCgCbOZkfu9kn0+tEYjsZEs6lKa/kWcAgACTJsA=
Date:   Mon, 8 Jul 2019 04:34:43 +0000
Message-ID: <AM0PR05MB4866E4C5F2173BB44E5CC772D1F60@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706182350.11929-1-parav@mellanox.com>
 <20190706182350.11929-2-parav@mellanox.com>
 <20190707194750.GA2306@nanopsycho.orion>
In-Reply-To: <20190707194750.GA2306@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.16.209]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b8befe4-df22-4853-ec65-08d7035d99c1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4739;
x-ms-traffictypediagnostic: AM0PR05MB4739:
x-microsoft-antispam-prvs: <AM0PR05MB4739AAE9C0B254FB2251F010D1F60@AM0PR05MB4739.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39860400002)(346002)(366004)(136003)(13464003)(199004)(189003)(25786009)(11346002)(14454004)(9686003)(476003)(486006)(256004)(4326008)(71200400001)(71190400001)(6116002)(446003)(78486014)(3846002)(102836004)(53546011)(6506007)(4744005)(186003)(7736002)(86362001)(68736007)(316002)(26005)(5660300002)(55236004)(33656002)(76116006)(73956011)(66946007)(74316002)(66476007)(66556008)(64756008)(66446008)(6436002)(52536014)(7696005)(76176011)(9456002)(8676002)(99286004)(55016002)(54906003)(2906002)(305945005)(81166006)(81156014)(8936002)(6916009)(229853002)(66066001)(478600001)(6246003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4739;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YZddzfKK6k79E8FEUwLJiWm4S25sfecpMKvB41inWbWQlpJteJgyIiOR3mNLhoqfg2GyurT3sIfquKqay2Mu4MNULl8rXgcT94K2qTLSIEmZlfPTU86N1yb8M2ZPGyNlBKt9d/VQ23ula4jvBI+fSbKw3HzD3IQwvHUDijTzJUI3Ri9v4ADdhF3M+N9o/wC8z3EKHpC3B3pTgOzQr9ZlhmrNP4GF86Vac3TO3Wc/JI0jgnkRbg0y+99S0NLob85qHEB5NhpkLp3kpz0wX7nBc2GYW7/+/Osoa5ItrysVC0WouliuEtU98DXj16YWKDWYulEEiyCKJWJA4OX7PzYvrxGccjKS9WlOvYHOrfSQRTShcHtRb1V/5k/Hgn1k/5mWjcnnhwhSmhFlJB+B3+K8trmZIcz5jijEJZpa821RvIY=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b8befe4-df22-4853-ec65-08d7035d99c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 04:34:44.0280
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4739
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Monday, July 8, 2019 1:18 AM
> To: Parav Pandit <parav@mellanox.com>
> Cc: netdev@vger.kernel.org; Jiri Pirko <jiri@mellanox.com>; Saeed
> Mahameed <saeedm@mellanox.com>; jakub.kicinski@netronome.com
> Subject: Re: [PATCH net-next v4 1/4] devlink: Refactor physical port
> attributes
>=20
> Sat, Jul 06, 2019 at 08:23:47PM CEST, parav@mellanox.com wrote:
> >To support additional devlink port flavours and to support few common
> >and few different port attributes, make following changes.
> >
> >1. Move physical port attributes to a different structure 2. Return
> >such attritubes in netlink response only for physical ports (PHYSICAL,
> >CPU and DSA)
>=20
> 2 changes, 2 patches please.
Done in v5.
