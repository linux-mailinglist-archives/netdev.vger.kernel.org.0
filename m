Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98DD525A489
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 06:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIBE0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 00:26:20 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:9004 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgIBE0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 00:26:18 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4f1ee70000>; Wed, 02 Sep 2020 12:26:15 +0800
Received: from HKMAIL104.nvidia.com ([10.18.16.13])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 21:26:15 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Tue, 01 Sep 2020 21:26:15 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Sep
 2020 04:26:15 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Sep 2020 04:26:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kE/tDQLbH8JzZ2CCmOsAo3xmd0inR29bcA7KDYUJKDleDFF9kRGuZN1/S+NeNEhhiLYq70OgwZ7+lwOrnHTRZgpFSdPiTMqOV1+NwC1wvc/ybHcuC8rO/Xw+YqUislrskbMZk383WbEPUY/zt9cCtxpts5sppR/wBRvShzXe87nr84diT+tAPQP/KFoFtEIkWdkh2tc/bK3p1u4QQPLSNeJyDVxb4l8DiZsN5fnXpQhy3pz/qH7uNtbozuy1N8zqFu2e0fj5u/spBrPh5UvF1mu04GD+w9RoLZAmXr+ZgMcVoqIvDQhesvN5p8JvYZiuyPZhRDzWaVIcrmOR0xjv3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jkhSvwZp4VT5ZjFnPHMvJ+UcsdheTOPEYW5c4YwFOik=;
 b=NEQvgnhGfRqfArYdu5g1I2iylA2m2oMfSFnFjC5KiVBQRXBjespbz3o8Aeoq7WLOxtKi1G1Sy8QVDtCTqWaSR/ex3RA2Wgde/cki+gLloBxrq7plZPaGeUTO9WTiTXWR/6bfd+bLrE8TAN2HNVqnI6waWVuGBMpI0M1is/pGODahwi5Ewk0jBdH4YRb+/PBIfUtvHba7uaGFAgKwd+/cHCPDiGRmwY2q0F+CSdjZKm9LeJJGuNOqd47cACdeWX9AknDVJ4Uv66qpcKtKvLMir/mCB+65E/z+L4LCIzs78XszfQrMB1Tm+fij+zMclFSSU5940dnPea1Q6idmGIx3vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4065.namprd12.prod.outlook.com (2603:10b6:a03:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Wed, 2 Sep
 2020 04:26:13 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 04:26:13 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAANgrgIAAsB0AgAUMOQCAAAZkMIAACfwAgADMOwCAAHEaAA==
Date:   Wed, 2 Sep 2020 04:26:12 +0000
Message-ID: <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
 <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d0842606-ecc8-4cb6-6e5a-08d84ef8537b
x-ms-traffictypediagnostic: BY5PR12MB4065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB40658F486F3C6C9BAE3061B0DC2F0@BY5PR12MB4065.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: suu6egvPjQJfZOq3jS23m992Iu19tI2r0hWCzHrFTAYbnq/0crm3SN76DZDVpuyNQ+THrRsE1NSNN7lV1IukSdhf2ZZrBD/vOXpHikT0DX3hZAtTV1QXshuJVfpOExLQM8YQ5TGpVILdSBEpZw9FCR9S6FW7VKj+T2bx0hTwTwigv4BZPDj9vSlIWbxZQ8HB27jZvwV2f1tmjUS22XHcupwshxESzHTKmtcd3yxqlbolrOm5qA2HF77J579FLzmtfjuylHm5LxcrahqtviE3/40MmDVsALL3DDmabZ6q0hdBqIpOnpBEehrCtw8TFT8lCnCpNmZb1vCYdHE1zDhVbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(54906003)(66446008)(26005)(8936002)(71200400001)(8676002)(110136005)(316002)(107886003)(66946007)(6506007)(86362001)(55236004)(55016002)(2906002)(66556008)(7696005)(5660300002)(478600001)(4326008)(33656002)(52536014)(76116006)(186003)(64756008)(9686003)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: YcIHVEoppOe1khBkXJfvRmEQUyCTzObJAbD//pLJ4mSn3XLrsFBuTctPP7JOZSNPk53Ffj0NyoL7PgjHT8ZnYr71Zk7OUMuItV65L2FdsgYMbhtmGQCtMAQyaZJwfSRuHn6CI0nk5rCZSQQmCGalppFwiCBPkEJSicGKDzQb73pYQzUktrmRuMFtXRup6wZoZMdkKNGJXUAD2bFb7Vd0ERHDZXdDahT/uU7TWI1OMKEzTXSY52Se0lxS0Qg3H1dWpmJzqKkXdSLF3KKxw2PmZDhb99zLqdo/BsUO1Pj1DuV77sBq4IahAj7eCEegDP/7CiW5G/ASxGdngyVMJkCYblG7nQYCMtgrmrc2q6ZHcyYuyZbb5fon+e7nmHRYrNnwBvHg2Hxt1Rn23ApKdRfevEwqW6CmHwisoDkwBUfv/waudVhE6xpuFDRKatg+pjkawGv6k084TorM58Qw/cI3dYhoKRf+ycxe2Ifu7wlmrw8CQHE67tzFkY954p6ZaZlu+WoFaPJS9U4blNu2ytoDgHrjw/ygT5VPj6xzv4ogy3su81sC347eE+Xt264GRuo+z2fk/wjDQ6HuqoemsI5/todpl4pNm9QLAilVuWX5UYuceTZM2rUQ0EaebLu5A+eZSKDp/MBfMx0tnxo6tSwxSA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0842606-ecc8-4cb6-6e5a-08d84ef8537b
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 04:26:13.0945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kq4rscrVVD9IXF21GULIMLhv/uOP5Pbcx6yQuQkGGO8r+juHxHdaPqVC3RiqybNxYy4sVeYdtqjkVGI6jIGObw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4065
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599020775; bh=jkhSvwZp4VT5ZjFnPHMvJ+UcsdheTOPEYW5c4YwFOik=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=YpnybURWskIhCgzEuhEaqTraYPhO8y2cYcdNTeJttYk+PFJzveIhmE3N/+1Fq5U+z
         irC0pZINX28tWTo0hLrqc90krREV3eGkVRr7EvY76RR/V1OqfpG/8rDJMalvBgAKDP
         dejdqmaF2sR9mXMAP/o7XzUwMCArYIuRJ0JiAVSsO17CemD9HyuIPJtTWrFBn4AqIc
         9dP3HxWJO/oDp7tZJgb807ih3TyHtYXcf+/nj1ephCrWjb9iPcQu2Qbk7mQ92PDLoS
         1xuLYsqAAJbLY8HwjAzAGDXtx+6+ZiE41m56zREv6RLv8rwf8Z6t8+A0+jM+3ONYpU
         SexDlN6rQnaRg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, September 2, 2020 2:59 AM
>=20
> On Tue, 1 Sep 2020 11:17:42 +0200 Jiri Pirko wrote:
> > >> The external PFs need to have an extra attribute with "external
> > >> enumeration" what would be used for the representor netdev name as w=
ell.
> > >>
> > >> pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
> > >> pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf
> > >> pfnum 0
> > >> pci/0000:00:08.0/2: type eth netdev enp0s8f0_e0pf0 flavour pcipf
> > >> extnum 0 pfnum 0
> > >
> > >How about a prefix of "ec" instead of "e", like?
> > >pci/0000:00:08.0/2: type eth netdev enp0s8f0_ec0pf0 flavour pcipf
> > >ecnum 0 pfnum 0
> >
> > Yeah, looks fine to me. Jakub?
>=20
> I don't like that local port doesn't have the controller ID.
>=20
Adding controller ID to local port will change name for all non smartnic de=
ployments that affects current vast user base :-(

> Whether PCI port is external or not is best described by a the peer relat=
ion.

How about adding an attribute something like below in addition to controlle=
r id.

$ devlink port show
pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 ecnu=
m 0 external true splitable false
                                                                           =
                                                                         ^^=
^^^^^^^^^

> Failing that, at the very least "external" should be a separate attribute=
/flag from
> the controller ID.
>
Ok. Looks fine to me.

Jiri?

> I didn't quite get the fact that you want to not show controller ID on th=
e local
> port, initially.
Mainly to not_break current users.
