Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475FA2625A4
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgIIDG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:06:27 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:26433 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbgIIDGZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 23:06:25 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f5846ad0000>; Wed, 09 Sep 2020 11:06:21 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 20:06:21 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Tue, 08 Sep 2020 20:06:21 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 03:06:21 +0000
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 9 Sep 2020 03:06:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=joVO9sZqfwrnWsjx6zQXTo7GNofqNXv0Wm87SNjS0Ep5/Wd0Zf9PNqsDf7L62RK8xlG4NfxIbKIY7VS14+5aniZQqbfHXmXOaZBAw8bqylXfDxwwP4nPLSEpbJTTh4Oli6DWSZmkglP0p0sqtWmjBhpRZshIdlmlc9a6F+rsd5u3xks56U5EIH5e9fIVZQpOWD5XRZvwzVAkXuG2Kzh2UbCDNp0aOGf/ycy9TOfhP4WU9yz4v7hWrQOrLk8E0vnKYnDkFtwwPtTy4qdCR+9xYEhubrPUZIKWL/gzQEcQMjyIEjlVoF17c8DXO84Ha2Rbh7ILJagWdnBHnJdGlX7UzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aGxUYgWTZjcciy+ySxkejYCZXrwiMUgfj+zy3KwoW+U=;
 b=fcfo6G4hPfMId21eeF8D9FL75E/LU01+cL608sdhU9t3R8f7vlyEHm+PxH6UcHmAM49+Kj7afMaH8yYecqPJ/exsrfBaB8HyV1FmtIRnLpX96Ku1fdMMT3ciQrCl89QcfHIJD1hyHUaUgBXEHTbEePZbAPR6D4gIplnOD9iN2JABjwXtqgMVHDeM5dI/mvlors6WKR2a+W2QaFXeVSWb5wB+1PDXfRXxAIVIRhsqloJvj4sQM2qFI8lYnhDAOFrhfckjk+aY7v2IYB2TFj1AUQS8LLzmCZNicAJx2i2vg1+QjRdZNYZ43OxPi5EhYQ8jJlOLx8EQW/njT3TD8kq+BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB4330.namprd12.prod.outlook.com (2603:10b6:5:21d::20)
 by DM5PR12MB1371.namprd12.prod.outlook.com (2603:10b6:3:78::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Wed, 9 Sep
 2020 03:06:18 +0000
Received: from DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::579:e5d8:892a:daf7]) by DM6PR12MB4330.namprd12.prod.outlook.com
 ([fe80::579:e5d8:892a:daf7%4]) with mapi id 15.20.3348.019; Wed, 9 Sep 2020
 03:06:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Parav Pandit <parav@mellanox.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v2 5/6] devlink: Introduce controller number
Thread-Topic: [PATCH net-next v2 5/6] devlink: Introduce controller number
Thread-Index: AQHWhe5uNj7zQDjmCU64g7VJX7eGM6lfFd8AgACIyXA=
Date:   Wed, 9 Sep 2020 03:06:18 +0000
Message-ID: <DM6PR12MB4330602B6E0B5C4A9C2A0592DC260@DM6PR12MB4330.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200908144241.21673-1-parav@mellanox.com>
        <20200908144241.21673-6-parav@mellanox.com>
 <20200908115006.3b9ba943@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200908115006.3b9ba943@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1f8b8b2e-60c2-47e6-7521-08d8546d52c1
x-ms-traffictypediagnostic: DM5PR12MB1371:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR12MB1371CEAB05CA90E854A8F533DC260@DM5PR12MB1371.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VD1uvB9UkQIwFdp3+ymCNEALThlA3H4ycwkPRs426o0QfaMqDJMZi3TBWuREwHEojzQTzJdr4McI1utIX0BCHzy5HEJ5DvNLJQ0nw9Jahw2z1eIyQostVragOh6bmTRgsY6auX9rseh9hMCgWO/xp4NJ5cTu+qi/Del4xncAGBpLkLiOB/0dJLIbMq3XHM+PQh7+Mymi2hroLMjUvjYE3OXGoSuRApDQdxP7xOUXQ15xCX/cpumUhWaRbg7QYqyeW3KebWgUGEpLaGkBziqD9aAiomhwm3zvioV3YYK2dr8gxvtQ7sqmWzS5zSBvOdAgBejpQQMxCqcG9HFNrET3ew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(186003)(8676002)(26005)(2906002)(8936002)(33656002)(4326008)(52536014)(86362001)(66446008)(66556008)(64756008)(66476007)(76116006)(66946007)(9686003)(7696005)(478600001)(316002)(110136005)(55016002)(54906003)(55236004)(5660300002)(71200400001)(6506007)(107886003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: TZZ99AfQq0xthju3WjyYg2e1kwfexTMqdHgolYpmpMt+Cv37xESeK/2YsSIfLuTnPn+oVWhY+emeE6CPApcdj1w2/GVBm4L/bLDaCYFdZsqcViuvR4TWhV8Yd60To1zQVuNmK+C0oyX9xfFWzwCAAEeS7gi5QZ5v+pyVvmFcBSRO+JKYBRsyWu4vKfGXmXqQ9z9exHOZCRH7BegghQqoiblC9gCUlzgAwNdYJS+k7CqM8glEBZEGoplWBsJnuySz02msh+ubHuMVJ7MiHX+fMg96sHaMFi7RPJgvJWmWgnqI3zfT35llGkw7nB+PC1dTLSnwjA0+iJQsRRc1UrBFuxS5SFiUsqlHzq3g9Ohgn9bG4mNRH/PluJdhCOGhGahkhJ2hC5lCbwqRrjI6t+0XctTKAtudnRGUYj2jPK2ex8wmB2DDnKbfMxnRAYrcbzd6V/oJUCburpzPLRks/9zojGH/A6T2LNBnicZY0YpyBP57aX6pX2Ig+/0k+XX80ABh5904Ob1t7FLCFB4vvgJ3iVhNxxS7lH8/bjN3ABsBfjkVqZ+IFAOprLJtTXHmtO4PhZsFyiTW3fLdtY1uVxDEV+tMihDodpHsjVDvhB0lcH5n5/6b0UPMiW6S+71MRvlFIuTBi7j5oy/jnk1jsy5YOQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f8b8b2e-60c2-47e6-7521-08d8546d52c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2020 03:06:18.8538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LE2kZNG1XFljEFUuR6xY5rCHtSPfkhKZq2tampCtUaFz9dBigtMeDGhP+PpgHDHJkyO6vdIrukjF00r67nKEaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1371
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599620781; bh=aGxUYgWTZjcciy+ySxkejYCZXrwiMUgfj+zy3KwoW+U=;
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
        b=kQH5Y1FUrBkcE8fncMYiD2wjGdeqdvkzi0uW4mFmnTUU3z4ActDLrhzwpVZrR3/Ts
         FYMuI/DjT6uTU6Hy2d9dKrVATxlbvLPokNcz9+8+InVlUSbsEJsi6K4YK9nRXIRQX9
         cELRZwv+7aY7vOeTFNnQTKy2NLXZZc5qsiLoBj+cZW73uQQNRMus9dCqT7+ONhcGs+
         N4gBcjpks36Pze0zs/OZklmrnxBIekjUI93xW823h25hwyvelsWMbWKv7YcmaAvO87
         YKhDfuJD9X1xxtzMqRnGGtAPKjUX0wpkzI2LWIfXuSqhyILwoPiMImjHyAAsoPMEY9
         iz8D6EgGH2nlg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, September 9, 2020 12:20 AM
>=20
> Humm?
>=20
> > A devlink instance holds ports of two types of controllers.
> > (1) controller discovered on same system where eswitch resides This is
> > the case where PCI PF/VF of a controller and devlink eswitch instance
> > both are located on a single system.
> > (2) controller located on external host system.
> > This is the case where a controller is located in one system and its
> > devlink eswitch ports are located in a different system.
> >
> > When a devlink eswitch instance serves the devlink ports of both
> > controllers together, PCI PF/VF numbers may overlap.
> > Due to this a unique phys_port_name cannot be constructed.
> >
> > For example in below such system controller-A and controller-B, each
> > has PCI PF pf0 whose eswitch ports are present in controller-A.
> > These results in phys_port_name as "pf0" for both.
> > Similar problem exists for VFs and upcoming Sub functions.
> >
> > An example view of two controller systems:
> >
> >                 -----------------------------------------------------
> >                 |                                                   |
> >                 |           --------- ---------                     |
> > -------------   |           | vf(s) | | sf(s) |                     |
> > | server    |   | -------   ----/---- ---/-----  -------            |
> > | pci rc    |=3D=3D=3D=3D=3D| pf0 |______/________/        | pf1 |     =
       |
> > | connection|   | -------                        -------            |
> > -------------   |     | controller-B (no eswitch) (controller num=3D1)|
> >                 ------|----------------------------------------------
> >                 (internal wire)
> >                       |
> >                 -----------------------------------------------------
> >                 |  devlink eswitch ports and reps                   |
> >                 |  ---------------------------------------------    |
> >                 |  |ctrl-A | ctrl-B | ctrl-A | ctrl-B | ctrl-B |    |
> >                 |  |pf0    | pf0    | pf0vfN | pf0vfN | pf0sfN |    |
> >                 |  ---------------------------------------------    |
>=20
>                                        ^^^^^^^^
>=20
> ctrl-A doesn't have VFs, but sfs below.
>
Right. Instead of showing too many overlapping devices in both controllers,=
 picked sf ports.
=20
> pf1 reprs are not listed.
>
It was hard to cover replicate same topology as that of pf0, so It is omitt=
ed.
I guess I should put that note to avoid this confusion.
=20
> Perhaps it'd be clearer if controllers where not interleaved?
Yes, Jiri also pointed out to get rid of naming A and B and use numbers.
Little older diagram got it. :-(

>=20
> >                 |                                                   |
> >                 |           ---------                               |
> >                 |           | sf(s) |                               |
> >                 | -------   ---/-----    -------                    |
> >                 | | pf0 |_____/          | pf1 |                    |
> >                 | -------                -------                    |
> >                 |                                                   |
> >                 |  local controller-A (eswitch) (controller num=3D0)  |
> >                 -----------------------------------------------------
