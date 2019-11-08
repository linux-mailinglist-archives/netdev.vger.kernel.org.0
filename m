Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8E22F5321
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfKHSAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:00:31 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:32461
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfKHSAa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 13:00:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nkL+vjWGZznlw3UAjBWWL4GrcyIOrO+zCKO/1YAaEjrBELcRMBGfktZSCatljrKNtGBxso27zjVqnGyONHwOHXMplveCGI8TbNhQJG9Asx/DhesOkIvREzQkSQRUfZBAiH5ueKqao5Riz3CoTmQbJwwkGGZeh/U1nuprsTx5BLMXEMtGL5wEf/MA2UYQFnX0wAGDWw9BfO/B7hORNTcKAQvAV/+5JInw/XCYA2n1mmy7BFVCAqGtDCiBOo360LocG6I35/lTHOVoXFhdB6ttU7ULH9mdv1sNmBeM7CWFKHTqWG7NxYwulGmg1+HvQzukPH25HOVWzGRdjEOMzoN5Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwObUWIWqS0uNvAHbatztmg+6fc6AclIO3esSOc1Yx4=;
 b=BpKfVPdwF5rZbBaxchr4bm5O/iTkDUOTUqNkOr9MYcvV362Gv35ZWKHAgTVMbBAI5viK3SeLUfIHrKMh8W3nBvkEwGpOgB/x0IIIglEe3qBNEDG2VnY/tj6wvbSstRrLfysIgVEmnwo54qTZxyUwKZBF1S55c2KKX+PTnZOyTZ5lQqPPXKOhDmArOPbQiAFBToiLt6Ig3BhAG/dzFfJBwv564+LqfxhUqgih9d49ow+S6UnaY/nLsD2jWCR27cG3IDR9QjKoyhLlPegzuq+05P0ES0ahjibHgzuNA/2GjgsexCKHx68J1VXOeRBEfY5K/3CoI49rLZ5tCVbPaTeeXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hwObUWIWqS0uNvAHbatztmg+6fc6AclIO3esSOc1Yx4=;
 b=euOHBQauSpxS4riczu8uZOtqTQhknGZGypmVMaHVIrGJzOZ8vhbavuD5fgSo3TmYZigpzOezQnbOWPW3J6k0piS/Ux4JVoHHrUJvBQbaSHwHFweDqe59KzYgzbNXMLuSlFeYGq+pdogdvSuC73lBsE2rWwtZuga93Z28DbPx3wA=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB6596.eurprd05.prod.outlook.com (20.178.117.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 18:00:26 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:00:26 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Yuval Avnery <yuvalav@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        Daniel Jurgens <danielj@mellanox.com>,
        "andrew.gospodarek@broadcom.com" <andrew.gospodarek@broadcom.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: RE: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Thread-Topic: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Thread-Index: AQHVllBB2/zEJqwON0qPJYQ0F3Add6eBj3XQ
Date:   Fri, 8 Nov 2019 18:00:26 +0000
Message-ID: <AM0PR05MB48663DAB2C9B5359DB15BB89D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
 <1573229926-30040-5-git-send-email-yuvalav@mellanox.com>
In-Reply-To: <1573229926-30040-5-git-send-email-yuvalav@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 348ce686-9a13-4120-ce02-08d7647588d8
x-ms-traffictypediagnostic: AM0PR05MB6596:|AM0PR05MB6596:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB659638C1D040A910E029D02FD17B0@AM0PR05MB6596.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(189003)(13464003)(199004)(229853002)(55016002)(5660300002)(86362001)(6436002)(9686003)(305945005)(110136005)(7736002)(256004)(71200400001)(6246003)(107886003)(6116002)(3846002)(66066001)(14454004)(71190400001)(33656002)(52536014)(478600001)(2501003)(4326008)(54906003)(81156014)(25786009)(99286004)(81166006)(76116006)(66946007)(486006)(316002)(7696005)(6506007)(53546011)(26005)(186003)(102836004)(8676002)(11346002)(476003)(66446008)(64756008)(66556008)(446003)(74316002)(2906002)(76176011)(66476007)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB6596;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T4N5mF4/pLtqUuUVYK4s8THvZMumUnO2RhRazuareWGjAIaoIyMdG8LIG2Lws3Tp2yvwrgOYHc+pPWpG0UksnpPa2v/b50p41frLgO4AIcXDIRomFTf+vqY2GTNOcSDoPMTMpOwAfNbieZz0jjrcpMoOfLAss39KpWeEfXA1ACC4L+IJzdaJRVki3WINqXxNjWaTFlN2uZ+pWKH4UfppTEM/eDKPtt2zKX+w8VbbZv9yOtBLcJngVXFuCY/mO3t6hKoCqmrkYgdjiH15g+uOEohB7msFpbYoBBAQVNX4SdajucLcIfBSljtC0hVMxrEzvH6/WD+wSwZZtBISmTGtA6gaO6UUA6DuARhHvWV2ikp1kALUYnEUGtGiMGbfi7LDivv1H458EebkOKqqbMh/f3uQeZUWb/D5P1dbJAvfWoHwIGRF7/Ywb/lBQnzReWUR
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 348ce686-9a13-4120-ce02-08d7647588d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:00:26.4666
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5JN3m07th5Vc96g6PFkQcrJNs7L0VsSYwn8Kl2PvPY/h1sHGALbop4JIHrSB1NptWmqox/EY6mBrbJCz/iprzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6596
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> Behalf Of Yuval Avnery
> Sent: Friday, November 8, 2019 10:19 AM
> To: netdev@vger.kernel.org
> Cc: Jiri Pirko <jiri@mellanox.com>; Saeed Mahameed
> <saeedm@mellanox.com>; leon@kernel.org; davem@davemloft.net;
> jakub.kicinski@netronome.com; shuah@kernel.org; Daniel Jurgens
> <danielj@mellanox.com>; Parav Pandit <parav@mellanox.com>;
> andrew.gospodarek@broadcom.com; michael.chan@broadcom.com; Yuval
> Avnery <yuvalav@mellanox.com>
> Subject: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
>=20
> Allow privileged user to get the HW address of a subdev.
>=20
> Example:
>=20
> $ devlink subdev show pci/0000:03:00.0/1
> pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr
> 00:23:35:af:35:34
>=20
> $ devlink subdev show pci/0000:03:00.0/1 -pj {
>     "subdev": {
>         "pci/0000:03:00.0/1": {
>             "flavour": "pcivf",
>             "pf": 0,
>             "vf": 0,
>             "port_index": 1,
>             "hw_addr": "00:23:35:af:35:34"
I prefer this to be 'address' to match to 'ip link set address LLADDR'.
That will make it consistent with rest of the iproute2/ip tool.
So that users don't have to remember one mor keyword for the 'address'.
