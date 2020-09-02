Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98D25B51A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgIBUKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:10:50 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:4271 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgIBUKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 16:10:48 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4ffc440000>; Thu, 03 Sep 2020 04:10:44 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Wed, 02 Sep 2020 13:10:44 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Wed, 02 Sep 2020 13:10:44 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 2 Sep
 2020 20:10:44 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 2 Sep 2020 20:10:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTda+TBp9rYoVHlmhCHt5wwlpURFSN8LqC2hveZhRVm7lLkwTLOK3dlolbjdx1uEaCjIxEhN7RXnFtf1E1OjTjlvcdeQ9L/s4vLIsxN+ltZHc3Ab7m31SzKLhofnfcCwEEPSpdw2Lunf015u2v9JAlhhKknc6UzWQdPKDZbKCjTDoNS/sIYgP8dwC+OtNKlSWEHZO+XJE8Qd3glx8hx1C5BwkQEf9jFmaAkFE6aaqdCz053e+lJBURpoTMqEWvx/wVNVrDkCRLp2BXqN/571r7YpMHfiHONXzR+SHFOjM/yUPewJI4JunCVvkJCwYr44Yq7l1bChuYi6GVRRlKtzBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=md+KyN3Hgn/S3pIi0GQvETy41pmCf7ORhkn4ZmBAuR4=;
 b=E4WFGBPzt7ieMVe8onTUv4fO7rpRgdFRXWJmTnovrIKLjuDD7I60IWuNDaKziYVEMFJge2vxMmt1vXPYzCz1/I273w2xnQQpPr9Rb3kwkJanbOB30XbVekjWCs7Mke1V29eC/rGUX8qr8MkZO3plF1zhHC/TA3gp6BYjT5Rr9CCjDBM8Kw4nGogsCmWlsRr1+uEa5TNV5+f6YDmdAfbuz8/YNzTUc3pfL8/pKdyu3xco/dHYGFsMzLlDisSamncy7sns1nZKBEihTdyLa10BqpBB3dByrBlm0/L14x6yTugzQEhDfaGKZFGswo8nZlgDV6XUxKV6gpBlq8y4En9Pzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3078.namprd12.prod.outlook.com (2603:10b6:a03:a8::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 2 Sep
 2020 20:10:41 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 20:10:41 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "Jiri Pirko" <jiri@resnulli.us>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Roi Dayan" <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAANgrgIAAsB0AgAUMOQCAAAZkMIAACfwAgADMOwCAAHEaAIAAP1eAgAB7/gCAAA5/gIAAPFKA
Date:   Wed, 2 Sep 2020 20:10:41 +0000
Message-ID: <BY5PR12MB43220EDF182C941FD38653E5DC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901081906.GE3794@nanopsycho.orion>
        <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200901091742.GF3794@nanopsycho.orion>
        <20200901142840.25b6b58f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43228D0A9B1EF43C061A5A3BDC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200902080011.GI3794@nanopsycho.orion>
 <20200902082358.6b0c69b1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432234108C8D89170E267BB1DC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB432234108C8D89170E267BB1DC2F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2bc0e9fe-834a-4fe8-8c62-08d84f7c447d
x-ms-traffictypediagnostic: BYAPR12MB3078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3078CC5B8E2EC166D83B44DEDC2F0@BYAPR12MB3078.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /bSXiGIEu2sUQLNq8aEQW2LQ9L2rYSeXWZVCkffAa4xE7b7rJgOs4a+RHjS74EjEjZu/TI5t7iErFXFIhO/kuBZ68AJ9VGa2xV5zJZHVFvLUCsEG3OlIg+jVZL74q+VxX5FUGPpBzNjMdsefNKRi1MeCyreeTtBMzM6EFWshaJ8MJoGoTxmhOIwH2jJQwZCHCernGJeUDDn1+Todnu70H/fLrnyRl4sIF9jQCSkqx6nrMkbSnPNnXRohnq2LWlUnd97+q3tmZUsiSDjeKcC0r59wv/7oWn4Hs+hzr/xRTg+0m7KPFfWtno1pEyqI1rug
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39850400004)(33656002)(8936002)(4326008)(66476007)(66446008)(71200400001)(66556008)(26005)(66946007)(5660300002)(55236004)(478600001)(52536014)(86362001)(107886003)(186003)(64756008)(316002)(2906002)(54906003)(8676002)(110136005)(9686003)(2940100002)(83380400001)(55016002)(6506007)(76116006)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NTGR4LFOPGFS3Z8wpLuti2gPp6shq/P/IqsxvCnoe65dqyiN0nKEpeqmHlAG0ANIczdGN7/Ky8zS3gF1OSdmLfB+MPYat0Crv7UiQS+Uqx4UyoGR+W2JWLSIW9d3UbajfHtdVsOFm9ODmuVhFaMB6objzg7P0aHopQNzioprSG0xk3UEyhLr0xQreVVwY3g4muY8fi22vzCjgHR1z5enOnfOAp2BKrxECOHVNFlvVZY3jVW2oKw88z6ZrAbf1CCRju0lCnEV97XBI33RvcJuQ7bQ9+bocXoLeTHaBYq/uPNwW7uAzz+svlJDn2r6mKM44bjRQ/DsyoLKwYpqrqI8869tBowSoiWIGa5F+bYPMPVwoEJrJ5QOdgT+EMp8OLXZaN6SDSf4eZCjiN3B+IO5T4o76MHz6zPru/Yk7jhDO9UvS4Q2jJfACpeR4uou06iwu0HhSQ9ktAkz+i1WZ2x20iqMdl85InXuFX/A5DCcGsWnziIVIKMJtqzp13WD9lIF2BwcLt1NwR0ybUf9OapFUJuKnUNFheEJEA6V4mfcHLlqho8Vndai7b1g81Zf8/p/Z9PBeIuVSlTzB+l4FayKB/dewuVf21jkhZaNH/o5pEcQsfgjiiYkV68/W2CCtZFulCklfdtyoro23PMJVwdO5Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bc0e9fe-834a-4fe8-8c62-08d84f7c447d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 20:10:41.5482
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mQYBuSvGO/5M7XHj+Er0wGuvgeohCE35JorHoU3T4A6OEqJPh7dKmb/2AllBzdpJ04QfFxiZGPgzx7fZUGrYAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3078
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599077444; bh=md+KyN3Hgn/S3pIi0GQvETy41pmCf7ORhkn4ZmBAuR4=;
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
        b=Y2AsIso6QrtxSYT+gVKSLXpVn+alZ+TwOnlo7TjzVDWjdQFT1YgSLh1GP9X0GjG/4
         Oq70i/kl4ARnWgMJYElfLRRlQpa6nYiB7Woupp0sHcWINNbfpnziNnYBWlkNgD9Ifw
         IvseSy+1Y3nnA1paCT7M5p6QCIV0MNzNqs9Pl8fd0iTG5FQEmAhu3HAwWaLOHG8UfQ
         tuOO2puJe155pNi6XX/3NmTvvACUDW2a0SRyQB+T/lBjYWBzpkf29eDlDZbVUL3vfk
         dYJCdk1+hIIhjWT1xQD3g9g1Eo4YCbVIk2C2aocMKcUHLhJ764sFha/G0HCcL/36ty
         5eYCq/zUk1osw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Parav Pandit <parav@nvidia.com>
> Sent: Wednesday, September 2, 2020 9:49 PM
>=20
> Hi Jakub,
>=20
> > From: Jakub Kicinski <kuba@kernel.org>
> > Sent: Wednesday, September 2, 2020 8:54 PM
> >
> > On Wed, 2 Sep 2020 10:00:11 +0200 Jiri Pirko wrote:
> > >>> I didn't quite get the fact that you want to not show controller
> > >>> ID on the local port, initially.
> > >> Mainly to not_break current users.
> > >
> > > You don't have to take it to the name, unless "external" flag is set.
> > >
> > > But I don't really see the point of showing !external, cause such
> > > controller number would be always 0. Jakub, why do you think it is
> > > needed?
> >
> > It may seem reasonable for a smartNIC where there are only two
> > controllers, and all you really need is that external flag.
> >
With only an external flag how shall we differentiate more than one externa=
l controllers?

This is the example of on a single physical smartnic device which is servin=
g two hosts.
Each external host has one controller (c1, c2).
Each controller consist of two PCI PFs. (marked with external =3D true)
Devlink instance is service the local controller too.

cnum =3D controller number.
external =3D true/false describes if its external port or local.

Below naming scheme enables one or more controllers, one or more PFs to be =
managed by individual devlink instance per controller or one devlink instan=
ce for all controller without any ambiguity.
Does this look good?

$ devlink port show
pci/0000:00:08.0/0: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0 exte=
rnal false
pci/0000:00:08.0/1: type eth netdev enp0s8f0_c1pf0 flavour pcipf pfnum 0 cn=
um 1 external true

pci/0000:00:08.1/0: type eth netdev enp0s8f1_pf1 flavour pcipf pfnum 1 exte=
rnal false
pci/0000:00:08.1/1: type eth netdev enp0s8f1_c1pf1 flavour pcipf pfnum 1 cn=
um 1 external true

pci/0000:00:08.2/0: type eth netdev enp0s8f2_pf0 flavour pcipf pfnum 0 exte=
rnal false
pci/0000:00:08.2/1: type eth netdev enp0s8f2_c2pf0 flavour pcipf pfnum 0 cn=
um 2 external true

pci/0000:00:08.3/0: type eth netdev enp0s8f3_pf1 flavour pcipf pfnum 1 exte=
rnal false
pci/0000:00:08.3/1: type eth netdev enp0s8f3_c2pf1 flavour pcipf pfnum 1 cn=
um 2 external true

> > In a general case when users are trying to figure out the topology not
> > knowing which controller they are sitting at looks like a serious limit=
ation.
> >
> > Example - multi-host system and you want to know which controller you
> > are to run power cycle from the BMC side.
> >
Did you mean a controller inside the host itself (not in smrtnic) needs to =
know what is its controller identifier?

> > We won't be able to change that because it'd change the names for you.
>=20
> Is BMC controller running devlink instance?
> How the power outlet and devlink instance are connected?
> Can you please provide the example to understand the relation?

