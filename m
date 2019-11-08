Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84A7DF5377
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKHSXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:23:48 -0500
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:31300
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726445AbfKHSXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 13:23:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAXgF4KqK7sdxfdFzQum+JKthQaJofxaJn/oEL3UmWnrQXQ7Coxsql0br0qy3cIxl6pfXvah5wfjxg6KrBWp4a+yIqKApGeUCbgC4jIk2G5pCKDgAKlZtd+S/sKQSAuu/PXBJFzT0PmwGw+hOUNF3I1ryZwPsrBlxFtrWrhRUxfxQ4LJIlbB/HhTtEIX1yIYIzYY0bq9HH/SfPzY14kWQfX6BjLGMGT+hFhusGKHKLqpQ1ZlE7Yi3755P0GDu/wCh9evNngSth0LwkFta2rpEGa76gVII5X+erQaADV2yHPjjjz4DQEV7YnfG9/rR8rlptnI90jbbgfOL0kO5qafOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keoD8SLI4MH+tSgpDKrZFIdzWHTqUzNAFRxBZtBoTyw=;
 b=XWQIVrryyKg+JxlvP0MWJquU+v3iXXlyrMdA2ERcS9P2/NFgDSzuyBv21HKPbLbDqcrJRljeYqKiHqspiiIDIcqr/YgK5oVYhmPQxCGBdtQVa4sl0cK88xKOwicw1o+qPXKmrF5ZuhUYqqSR6B/IPWS8WogICzmLCAcWNBwFdtiDFAGARD9MgZEAPVH3AuX3zTGgFyD8CIJJL6lN355h+J7QedLcNtzA7l1lo78eT5ox/kLdf/re6Pi2R/snTOHPEqzJfdThHZN0FoyzD04NhOseQt2PNQNLnBCtVN0eSNE2mXTyT/lgrCke0XoyPcPcDHQyEwUSm8T/S6dKmEkY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=keoD8SLI4MH+tSgpDKrZFIdzWHTqUzNAFRxBZtBoTyw=;
 b=JdW7b9J20THu2Smc7daT+Hnp8t+GhjfTI0NzBzTu6sQ7i0WXt3pH259cVkJCUCA8ADNzhpreAhRp3L02K1qB2FfiLViAqoeve0MZap1uxyO+MP6+ehArkYQ94QOY2qo/2Y6myzIUan2e2TapwZ9XzwoEUQHPDOcLDhHHMzZkQQ8=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5025.eurprd05.prod.outlook.com (52.134.89.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 18:23:44 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::e5c2:b650:f89:12d4%7]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 18:23:44 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Topic: [PATCH net-next 12/19] devlink: Introduce mdev port flavour
Thread-Index: AQHVlYW+5ckj7/tyDUu1ocZ3bBFvo6eAK5wAgAAEe2CAAEmKAIAAA1+ggAAOHACAAAFAIIAAe3YAgABjcxCAAA2tgIAAAeXAgAAZ84CAAALlcA==
Date:   Fri, 8 Nov 2019 18:23:44 +0000
Message-ID: <AM0PR05MB48667057857062CB24DD57D2D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20191107153836.29c09400@cakuba.netronome.com>
 <AM0PR05MB4866963BE7BA1EE0831C9624D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107201750.6ac54aed@cakuba>
 <AM0PR05MB4866BEC2A2B586AA72BAA9ABD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191107212024.61926e11@cakuba>
 <AM0PR05MB4866C0798EA5746EE23F2D2BD17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108094646.GB6990@nanopsycho>
 <AM0PR05MB4866969D18877C7AAD19D236D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108163139.GQ6990@nanopsycho>
 <AM0PR05MB48669A9AE494CCCE8E07C367D17B0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108181119.GT6990@nanopsycho>
In-Reply-To: <20191108181119.GT6990@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc1375a5-51fa-4ea9-a006-08d76478ca29
x-ms-traffictypediagnostic: AM0PR05MB5025:|AM0PR05MB5025:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB5025E010FC3B27D4BD4B97A3D17B0@AM0PR05MB5025.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(376002)(396003)(346002)(189003)(199004)(13464003)(33656002)(55016002)(229853002)(478600001)(186003)(14454004)(25786009)(8936002)(6916009)(4326008)(66066001)(99286004)(6116002)(7416002)(316002)(2906002)(3846002)(26005)(256004)(7736002)(81156014)(66476007)(11346002)(476003)(76176011)(8676002)(86362001)(66446008)(52536014)(54906003)(76116006)(66946007)(5660300002)(6506007)(66556008)(74316002)(81166006)(102836004)(6246003)(9686003)(7696005)(446003)(71190400001)(6436002)(305945005)(71200400001)(486006)(64756008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5025;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pK7Sd5k6DL2NftNV1Ka/rlEK7NM2j+pleVjb7a2KIi6pVZpYIqeCevnnPK8BnmWKijMyCsOcO+CnO/cLD6WbpwM1e8cyEBJQxPYjVLCragCJ4eD802Ik+Hep1JlTvz9ZvFyEnFswLQTwkcVL9zyIwG36SVPfEXLexzphuMe/WN42yFfBQ19dLxDN7gJIMY4lO/LocjKSeQpyRJcclKRyoSjLTvJ5SRQFTAClakkyP6VmDGt6zERaqNC+J+mJ0DNxepCkuJ/Czu20RcidpAqABRQc11If4m6NfkX2GuZ2HxVVLUCFBLVNwg2C+0i2EzxrYxO/7wBQo+hwYcz4elLb44bXZ/gVwmGUjcD0wXKEJqnBGU8MDk8ZFM/2WAcagDROM+Rfiv7a68HLVDvDHsA6bgLG6g0g9E0nP5zPqzQfQAExioK+lM+KtKRd8B9TU9Fs
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc1375a5-51fa-4ea9-a006-08d76478ca29
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 18:23:44.6153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQzxfY7P5FluriHtvcSjtja6Mr/y4UKlS8Lc/1Fuml/sbNOadEUSEiVFJCZyE3QmEwY0gvV6ISNwhnGCmVQU4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5025
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>

[..]
> Well, I don't really need those in the phys_port_name, mainly simply beca=
use
> they would not fit. However, I believe that you should fillup the PF/VF d=
evlink
> netlink attrs.
>=20
> Note that we are not talking here about the actual mdev, but rather
> devlink_port associated with this mdev. And devlink port should have this=
 info.
>=20
>=20
> >
> >> >What in hypothetical case, mdev is not on top of PCI...
> >>
> >> Okay, let's go hypothetical. In that case, it is going to be on top
> >> of something else, wouldn't it?
> >Yes, it will be. But just because it is on top of something, doesn't mea=
n we
> include the whole parent dev, its bridge, its rc hierarchy here.
> >There should be a need.
> >It was needed in PF/VF case due to overlapping numbers of VFs via single
> devlink instance. You probably missed my reply to Jakub.
>=20
> Sure. Again, I don't really care about having that in phys_port_name.
> But please fillup the attrs.
>=20
Ah ok. but than that would be optional attribute?
Because you can have non pci based mdev, though it doesn't exist today alon=
g with devlink to my knowledge.
