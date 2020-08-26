Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42BB25263E
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 06:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725786AbgHZE1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 00:27:43 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:3553 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbgHZE1m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 00:27:42 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f45e4bb0000>; Wed, 26 Aug 2020 12:27:39 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Tue, 25 Aug 2020 21:27:39 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Tue, 25 Aug 2020 21:27:39 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 26 Aug
 2020 04:27:38 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 26 Aug 2020 04:27:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bFnKn7qLXrr85DcrvDW6dSV8S6RrxeI7AariZByiAfy9CdsZC5783/sPN/YvRnXrDQdHE51C46dBb8Mu5GCBsKIp/zwDmB2QrpbD/d3vwICXPZsgnmpTZhO/1rukVgrvhbF4zV1Nv8Z5Bgk9D6dbFFhRtzEUM6iQX5iWk025UCEXdAH9aZ+/0HxER1M40ZSrGywZz30Kb7MkWS45AmEeO8YbMdEKSFZXMsvGVX9n2cXPAh1Rt/x4NQwKaCLuFgXDTLEPbGG7w74FUqx0aKF+/6a6h7LiQ59Fjmoewiw+pwzmEez6jMwI8WlhZUY9zuszcKYeV93ikcHfvjcI+/q9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9uM3NgFvh+dXUVf4iXoWVZ9oo3d4aGWTFUiqIgkQ79c=;
 b=andI4/9SEntVHfnGZ/Hosbiwc6sOtf6GkiKu+e96bEPZoin0qH+5yCvVcVsHlWqQes0mum59G+jYneVe/9UJatyEWzvmn98znpNb8w6qCVXhSnYMgFFnZJihYkzlsxd3Q4ny0hT1PFNM2RbfXrjlHP0hZnvZQx2taSD9uSSUg13dIAbcEsGds5zV1zW0Vcfk5sNSXnRfCslx6BfsDlReujB/C1rSpDJMymRm3dnGJ35txJdRu71DQZfpG99iHWVp5SN1eWdg03CQMmwJVbQHigBEBPnzT9emuKc86eRR86fCxYbBM5srY4WP79C7S/gVEWMOc5F61KHpuq6oOogwZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4065.namprd12.prod.outlook.com (2603:10b6:a03:202::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Wed, 26 Aug
 2020 04:27:36 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3305.031; Wed, 26 Aug 2020
 04:27:36 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Parav Pandit <parav@mellanox.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdA=
Date:   Wed, 26 Aug 2020 04:27:35 +0000
Message-ID: <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
 <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48477dfc-0fd7-4af3-3772-08d849785c03
x-ms-traffictypediagnostic: BY5PR12MB4065:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4065131158590FE1A1AD8021DC540@BY5PR12MB4065.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1x7ZoYP1RQw7+KfbHtSpL+sY7tO9FPTcEkhNZzI1/RyRkjTSQtEEAi9xpVzuZGGZjy0TeeQlmEI9LwmH63JeP/Pao1CyCQrwQ945UYA2UHeJC494Eegw9x9qT+2nqt48IerZtjw1jR44FASU1VT03knYYRXWEmkjAnDWN/OhNf9WWeovCUFzU189IyJ7Z6is4GdluM4VMzdkA5szamFuseKsIUlRo6J9aPZRp2HMdhhx0S3RuIcfWjnAoBIKwMSpR+HCqfTUNM+z8cEhe4nJZKUIo5750rRmOb6M09fJJ5CnNeIFyIFJe2uF3M47tsmtN4qBnUyzieLu+VtWZtKrNQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(4326008)(55016002)(316002)(7696005)(9686003)(86362001)(186003)(71200400001)(83380400001)(33656002)(107886003)(52536014)(26005)(76116006)(66946007)(66446008)(66476007)(64756008)(66556008)(5660300002)(8936002)(110136005)(6506007)(2906002)(54906003)(55236004)(478600001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: oQgdFJjHRV4PeZ81/Bhg4DwpFNlPydFTTVu+quyAAdVFA7n6rT+8nbYEbvn1EYEcXRwXjmRu0OR3fkxL+Qui7utiPrlh1L0T9vL3lGHuXFeeiwMHvOfkocbNh8ENAZGClsbaNZd6a4zjQ9xiaA+V98X3XVCQK05UDZh37UhzgLAZI1TZ2Bx5WZQC+Gsrdm3o9LovY823NErShR31FDIKIWz2CV+GwW/AkgBN8ZrEVPLmuAIrOAYE+SYthjQfK9gaoB9tJ6iSGoPsKkX2+OsbxsvI+GXzsVCBSyYeGNmc2+TCq/9BeaJ6j0dhxxYXR/hCQjx3VLmqygOmAauDitRaomuPtbsQcgccsJzZtkdrxN9UKjTI5+Kl8AWirfDhDCBjARrPORjBiQ5dc7oVE33KpaL9fTtpJfXjAQgZmDdsmet7beubqGF6Fu+GjC0HG4MXc8e5PhRr3r8WldYqUKKRqFllf1xsK0A772TBVpbUVOd/LH1DsdtcKeeJxY/goqnvb9lf0IGPIAZEqCgsx79lktUpybP31KoiDooSty0FHarIzlY6OeLOh8CoFu8XOdQ8lu84ynd5tmZZ6eCddOrwcItJRXrd2XxY1OK4X11jeW/gdMezCn0Xe5r/VyCUCJvcUUskddqsw3qm9mEsSWuVcw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48477dfc-0fd7-4af3-3772-08d849785c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2020 04:27:35.9581
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fBtuijGEW3hOssvf9BMh12rbYE1bxDfU3m0jx+tvVoCKNAR/zLRTFqLZHwznuiQE+AR0AJoFqs/q81JdLvVLxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4065
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598416059; bh=9uM3NgFvh+dXUVf4iXoWVZ9oo3d4aGWTFUiqIgkQ79c=;
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
        b=KsJAyMSI+d0uB34sjcsmDevPMKcAHoRlGKWIjC0Hpn3sVHC9zmzCFC9MTwg/QFYLd
         RTp2wrLPZpFHpR9TP1ipYQjM1Dd/zqdbRlyi2n1k1b+0spAubiwPCqPwO/bNKBCusT
         Xu50nPx9ri3JPI4Mil7DoHjwkmzbr1Au7fHVuDTx2VvOmVTljgBjRX4RYw6Ge2OPli
         xKsQHeP38UbWxbRd/CLCvSqEj8lD90Y31gEPTq2g6VYl0+djvkB33bmZghoiORgWGy
         CuGTXZPMFgOcaIcbQWqlEBncpnRMKH1Fb5GUvzhjEZbvSU7MiHgBLRK9O5dceLYEjP
         9d4l/cdz8Vnew==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Jakub Kicinski
> Sent: Wednesday, August 26, 2020 6:02 AM
>=20
> On Tue, 25 Aug 2020 16:58:38 +0300 Parav Pandit wrote:
> > A devlink port may be for a controller consist of PCI device.
> > A devlink instance holds ports of two types of controllers.
> > (1) controller discovered on same system where eswitch resides This is
> > the case where PCI PF/VF of a controller and devlink eswitch instance
> > both are located on a single system.
> > (2) controller located on other system.
> > This is the case where a controller is located in one system and its
> > devlink eswitch ports are located in a different system. In this case
> > devlink instance of the eswitch only have access to ports of the
> > controller.
> >
> > When a devlink eswitch instance serves the devlink ports of both
> > controllers together, PCI PF/VF numbers may overlap.
> > Due to this a unique phys_port_name cannot be constructed.
>=20
> This description is clear as mud to me. Is it just me? Can someone unders=
tand
> this?

I would like to improve this description.
Do you have an input to describe these two different controllers, each has =
same PF and VF numbers?

$ devlink port show looks like below without a controller annotation.
pci/0000:00:08.0/0: type eth netdev eth5 flavour physical
pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
                                                                           =
                        ^^^^^^^



