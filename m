Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0E212AB2D
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 10:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfLZJRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 04:17:02 -0500
Received: from mail-eopbgr150071.outbound.protection.outlook.com ([40.107.15.71]:11233
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725878AbfLZJRC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 04:17:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2uAsw9cdnJ06bc1dQLbUjKcqXJSegsOvgJxGyaSC/Ap+AZAgWmavuYvyxJBVILoSeMGt+sbvHd81uNxJvGJK6C3y+Xg0YID+yydrxt5pg3vGGQASVakczqb9xoJ/9l7cO+HZQYNSbaS0ErbnwqMDXHlyMlaB5ppCOr5NV47FxCh1eyywkAcGtvtuLhSqN638n/NFFY0FSN7y3UZZe2OYryAoslKDK8Z9H4Zd955u8tk7XsAgssUSp1dwrJ+xFVbi9tJhH6Ll200tnJkYYRpVbsx82/63R4gecgs7UCSCjUU3CR1qbAS3+LjhE+QAimm/ADsIIcoe3lPLaBwIx7whA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbeQzVKohwJaJrR0BhAYt64InSvP5+OLstJFiYkspJI=;
 b=fl9E45bLu3uWOTg8TLn2qpIopFkDITdKeh+pEg3gLt6alOeT6NdMykaGusp0JmkNr46JZkCvP3bGXQ0LQ0M/aMjn3W+5bzxpANqrG1oYDqUejf+JHORGDoJI+rJ2bN8Bl83hs5XgK4hd0NYsYTFgH8j4S1LFjxOxjWuuMZpzszaCJjOkpKMjBx9yj1QNQNHVbBBqCj03oZr4Hj9eSLU4kyM1t0wGWiduowFgPOeMNbc5ssOlBwdTQ5kK5vWUvptsIVjx3cjPDPgq+H7UQgudTgg9X0wBQI3FYoh5SMsNGjOv7xhyAcHALvRg58/FldLw2k30eKv3mpFCJSGMHCaN3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbeQzVKohwJaJrR0BhAYt64InSvP5+OLstJFiYkspJI=;
 b=DlkaExPeJThST6pJJCbRe/14KUltnMSMvte1aQOpY5AYifNGPLVpB/aP841Y+dpVDb1AUSMf2FraU5pK/LJDZciV3vgJM3iijM5c0O5uJpdC43/V7/dBAbawl1h4DvGgWLK1C7rp8ql0BYeX5GjZF1q7Oiqrua6OMlWIy/fQbOg=
Received: from DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) by
 DB6PR0502MB3096.eurprd05.prod.outlook.com (10.172.246.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Thu, 26 Dec 2019 09:16:57 +0000
Received: from DB6PR0502MB3048.eurprd05.prod.outlook.com
 ([fe80::a59c:7d1d:5fc2:d6a2]) by DB6PR0502MB3048.eurprd05.prod.outlook.com
 ([fe80::a59c:7d1d:5fc2:d6a2%7]) with mapi id 15.20.2559.017; Thu, 26 Dec 2019
 09:16:57 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        mlxsw <mlxsw@mellanox.com>,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH net] net/mlxfw: Fix out-of-memory error in mfa2 flash
 burning
Thread-Topic: [PATCH net] net/mlxfw: Fix out-of-memory error in mfa2 flash
 burning
Thread-Index: AQHVu8hdUHavQ7lbTkqyxTPd5rn+zqfMIt6A
Date:   Thu, 26 Dec 2019 09:16:57 +0000
Message-ID: <20191226091655.GA35898@splinter>
References: <20191226084156.9561-1-leon@kernel.org>
In-Reply-To: <20191226084156.9561-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR0102CA0019.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:14::32) To DB6PR0502MB3048.eurprd05.prod.outlook.com
 (2603:10a6:4:9e::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idosch@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1ff1c1e8-2103-4a57-763f-08d789e45b24
x-ms-traffictypediagnostic: DB6PR0502MB3096:|DB6PR0502MB3096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3096270B48B7A5106104D21FBF2B0@DB6PR0502MB3096.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02638D901B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(136003)(366004)(346002)(39860400002)(396003)(376002)(199004)(189003)(316002)(186003)(33656002)(71200400001)(6916009)(52116002)(478600001)(33716001)(107886003)(4326008)(86362001)(66946007)(8676002)(54906003)(8936002)(4744005)(81166006)(66556008)(66446008)(81156014)(5660300002)(66476007)(6512007)(9686003)(1076003)(6506007)(2906002)(64756008)(26005)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3096;H:DB6PR0502MB3048.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w5IKpjCSS0i/JJDFGOTKWOvTPLgo3/dbfi4vEgNsGZFLJIAxwGsilUROkJtZfE4XZ03J6Y/W8+z+Xt5TA7x6YVpWnkOwu5U8v8Syerl7odGkgxQVphdtvX6OVb/arheMwwjBIJk8Aye6E8CsVUdjKWM+iJ4S3RbxiVhxNIQM2XmN0p3qZSLO2am1UrfC59JKb3Qfm+YtBSZ4uP3BgRaWaASJP27BLiPhcstTIao9yiC9+g/7kC/N2n4A4GXIHalCHV3jOaG2rUwOgAVZcy8BP9KJ9bGS7VY23E0Kmwa37pBLNsQVk87ZzByu/zBk2Gg9RSry7i3GAEBT7I7ku6jQdYtbn9jv5BNsscvuGG4Zu3S0cnJb8KJGHTdpRZMa/yHeLCln69yEPMMN2pqdYiT5b/SSB3uMHxrR/wCDiwxKoSed3n/8S0FV5kchDj4v5Oht
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C268B815F288248882A945C8D263C84@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ff1c1e8-2103-4a57-763f-08d789e45b24
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Dec 2019 09:16:57.4078
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XLFN6t3G9ock8iIBi4kO6TY9EcsJhwWCIwGo/BLwa6RpnEgJtpaYRC3aKtBEAPDaU63yMP02HpSSecwo7/8VOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 10:41:56AM +0200, Leon Romanovsky wrote:
> From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
>=20
> The burning process requires to perform internal allocations of large
> chunks of memory. This memory doesn't need to be contiguous and can be
> safely allocated by vzalloc() instead of kzalloc(). This patch changes
> such allocation to avoid possible out-of-memory failure.
>=20
> Fixes: 410ed13cae39 ("Add the mlxfw module for Mellanox firmware flash pr=
ocess")
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> Reviewed-by: Aya Levin <ayal@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Tested-by: Ido Schimmel <idosch@mellanox.com>
