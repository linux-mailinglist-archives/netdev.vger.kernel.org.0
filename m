Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9DD35D638
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 06:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhDMEDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 00:03:43 -0400
Received: from mail-dm6nam08on2066.outbound.protection.outlook.com ([40.107.102.66]:54817
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229379AbhDMEDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 00:03:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/MdXqcZm0WcMm7OYFnBO65JEDHEuE3nbn/fYFeiEcqUGgrx6PxmrrdwG9QN008xL1KITy2xKmK9/rOpZEKsmnqvszgFo8ZMfHYYAXAlxR1ldwSMeWwnKEAPthn6hIzRinvuyLq0As7Mtumufl+3RVrn4COMvJEwrl9HnjNi6rn56Ecj1yL2ie9o3WVTjWzxJjm9oRisxAxpekPuKZOBwLkHoxppq7hFt2JoBBZm6bWzvGyFXa9OsE7i+9QeijJ8SfqfIXy3s9tGPE1VnxdlOvJUyAJUQ8D020LGlNF1SHFfxKnItwCwPY9dDRn42xltHYJsAhBm06diJFWeSkzvdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4UH4y6+Llv4LNGM4s0gIH0MeWU2RobA+eNts67Ok3A=;
 b=c9Ey299u7zaMb3adr/UFAMlpyJfVS/h+qsyDfI6X4Y1QwS41alB8kpr/Z2Bz+/mTtdoq9dvi0XfA31vh60y6i3wjkhsdqnMD9fJb1vuNBSsM8RkZQOyZMRxW1UiaP4m/f1PDoAwVLJ6js6ecTZsV2+BAiYRnbhEhtw1m4qmBrWjv/t/lCvd9IO/QrznlCa2Xj0GHo430JW6itHcc2R669O8ANO04D7xfdALEkmJb0AtNVz5TiBaay96f4/tRIxCH2tmL5UWmwkoHkGU7AJCAYBp+nowB/XcMU4qfduhcnOZbtaHR1OF2UiIF+G2lNN5C6Jsx3WANVlvPuprLeW+uXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/4UH4y6+Llv4LNGM4s0gIH0MeWU2RobA+eNts67Ok3A=;
 b=jV30PztVD7bT11/YF2g4ZXe7z5e37m3zG9t3FlKQsivix9/VnimasjdwjQtBOj5FIsCAdOZ1oJo2nkXV6lfWa7Ex1jKxhGKO49gsfnXmhQjlg1iba7qEYXL5tsSBiraN/QAxun4IRz8NCXYdSDMNxURCD7edvgPEyNiiT8Za8rEzXql8gxh5GDwFGxUMMMbDfdH0sznTpO3vfb+ML3Hs+JZ7w1KzHyKLodJUDdPXOnatk6wLHwYGeMLs18UZAJuiutNQalgTPdbUm4LrStjOIeZc1ijnClgHxhXtUx2U8BkmQKNvRsLNISdDB3d2FIpLFi/bHnqXdS7w6JV1Ll2kTw==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB2616.namprd12.prod.outlook.com (2603:10b6:a03:66::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 04:03:22 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 04:03:22 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Lacombe, John S" <john.s.lacombe@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>
Subject: RE: [PATCH v4 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v4 05/23] ice: Add devlink params support
Thread-Index: AQHXKygnOko9SmU6R0GbDW2iBlZsF6qpJjuAgABk9YCAAB40gIAHVsKAgABDgiCAAJmb0A==
Date:   Tue, 13 Apr 2021 04:03:22 +0000
Message-ID: <BY5PR12MB43227272611385CA1D8E4F97DC4F9@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210406210125.241-1-shiraz.saleem@intel.com>
 <20210406210125.241-6-shiraz.saleem@intel.com>
 <20210407145705.GA499950@nvidia.com>
 <e516fa3940984b0cb0134364b923fc8e@intel.com>
 <20210407224631.GI282464@nvidia.com>
 <c5a38fcf137e49c0af0bfa6edd3ec605@intel.com>
 <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43221FA2A6295C9CF23C798DDC709@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbc87baf-005f-4579-a2a2-08d8fe311465
x-ms-traffictypediagnostic: BYAPR12MB2616:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB2616BF9EEE48DBCCF5745D1ADC4F9@BYAPR12MB2616.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6wZ6vEnCigpBqtr8On6wPCXigx6ZluphUIKfomQkuyo4YofC1yJE5AVFBi8CXyhcWrFFPNCSF57o4HMaaQJgcV++jzxILkSlOjkgS10cr99IuV9qIuUqN3Pb2nZGB/756cdMUKRuzNg7DzeACvmTqHfVmotynL8AvztsBUsjMS7U3oeG69dAzw8Rc1yv2RRzDfgob2bLrkzqZah0qmdHzPycS3WykvVHz0koRbDHjAihKtAZIlq6BxJi5PZCw4+pKAmxo+Fvmqfvnl/9UqWxk3sWltOeFZEClhdCvM6YKMCC/DMmfSwqJKxMA2ZJzpqaMs01g2FmhuPgAgbSoRDCakQSVSPYMu/Tq2xspSTO1lzfWloQpRYSTR18xDGy/BQ+xF9dbAyYF3SJhI8AgfxlbojfAIpqXXFfH60QvTXECMd8l7MacFNb93RCn2VWBLDHzn/Rh1NwdgR7cCaFpkb+ufSHgxGkjKY0/JoYgjlVGQoDsOzd0txWZrF67xR9gI2RMvDn/AuGkyETxQSpkACk3nCXgfWh5DY5TDkyU+OpBwH2ZmmAUc4K0SQO+0QM1AH4FP0iSNXXjf/l4W984i5l3+r9ZjfrqR/nUeUPesSt30c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(64756008)(9686003)(66556008)(33656002)(83380400001)(6506007)(8936002)(66476007)(66946007)(478600001)(26005)(86362001)(53546011)(186003)(110136005)(122000001)(54906003)(38100700002)(2906002)(55016002)(71200400001)(76116006)(66446008)(5660300002)(52536014)(7416002)(7696005)(6636002)(8676002)(316002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?wpQSWKwlF6f0fYfH3t5SlbIbFn7jV8jezRSwNbxCfa1dKvrFVvs9y60975Uq?=
 =?us-ascii?Q?snSI0c8ak3ksvvYtSsLRwNenK7P7BD6FQJFpH47MFBkxvFDP9Jv21MsqxOtT?=
 =?us-ascii?Q?94UITxGyvdrdbe0Cgx4J7OWMC7oZZBapFBjdpl5V6hZR+4dzKPmx3ZIJhFbM?=
 =?us-ascii?Q?iNVGHkNbm/Es/mY5pKKDJ1doUldzp+fSUFvVRHoWAVXjxtc4Ie+UDfubaIHu?=
 =?us-ascii?Q?+Ro5q0ltij5zLelNVCPjptpoKW8nX+MVVki7hNiJu92ucMMS5m5pUfvH/t/+?=
 =?us-ascii?Q?0y6Fn148ZYh0byGeecn6OYdmrgJy2UQ8V2GBwkbtTJtA0AyiVNKh03j9kFZ2?=
 =?us-ascii?Q?QXm6Yg6bZHkiwXst/QNVVHGThG+j/cO3CfFPsU07qGe+cZ4fexcLeK1z0n3c?=
 =?us-ascii?Q?clJRZajZuwmu0ZchUA0068s5qJ6OA3/ed9EuHre+xOw2CM6fZgdsnFPneqPS?=
 =?us-ascii?Q?GQleMmDUKpeLXORfpTaxYjXaYD7vwQHWzHYXsBCnFj4KsunnwbLqpR7xY9VW?=
 =?us-ascii?Q?DNsV1S4VYO4Pm/J326T5li3OvbE1kRedUj9fOA3m7dhn4S/46DTV8N8wLKDQ?=
 =?us-ascii?Q?H9NjMyZC+EZt+2AYbjkWkXYpfbRxkNLLrnG6z2Dr2Ocs7sa0+y31dPTW7BZk?=
 =?us-ascii?Q?pV1pEH/HgDZx3ofhNNn6g38uiJiWp9sGqEbe+VAErR1pBBWkVV5ofNtU9OR9?=
 =?us-ascii?Q?R7CR7yTKiBi2jaDV9Y11LsHmRhTpBKfCVh0R5m/Qyelk9UYVeXl9If5wkdTA?=
 =?us-ascii?Q?a+svJJYiIM2rE407N4J1ReUg+na1BmSCBbvG3G9GNrIpjGaDulzVvn48JKcH?=
 =?us-ascii?Q?wPBBkSkPFR9R7altV1CkmaTUlH2mHzOV/FzXsehVC5Z/SaSOq+Je7dBWW/mG?=
 =?us-ascii?Q?9mQhd6KoydmOp42MealDW++9XJRXLqmoAQJuErTuW1/Jpy+LjwKzkdNgia3n?=
 =?us-ascii?Q?s0uZOYrn5ycrzbsFcOavf98twOu/7JsJA9IPV888m2546orzjbEjWds44mOd?=
 =?us-ascii?Q?KZtWkX5zG6K8GxtethwDMv05HLtFem48F9VTapv/Lhjaa8N4ZaR1hQYZlv1k?=
 =?us-ascii?Q?PEYz3TLpazAtd0+hLQVkGZQnE8VQ6DHYb6CfJP5QstY4ccO1mwrIKowYOCtL?=
 =?us-ascii?Q?Q3tZ8awLVoBzEUWgj/OVvTyf7NpCp5dojaLiNyg8Nn5F3d0KLDv0qcEQT+eI?=
 =?us-ascii?Q?tKGgPhS2BUE17QIoHYMm3jMxBkar+vHVTttpUkqpJtxNmXJuRxc2bg+9k4cv?=
 =?us-ascii?Q?pR755tjt17Z1dvafHhkbdnIJLvrztOSAxtJpAjv4fADd6r/b26XN6aoSLKbQ?=
 =?us-ascii?Q?1RiLkhx3loftwK0IaJ53ijIA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbc87baf-005f-4579-a2a2-08d8fe311465
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 04:03:22.0957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +XxkGDqHArWkDbEjTz0lA1TFFvkziD15Zyczy/BJp7ud1qX3FqQMONdYgTj7QynpXXhD7ucAC8hf5rKHfZxQBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2616
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Parav Pandit <parav@nvidia.com>
> Sent: Tuesday, April 13, 2021 12:38 AM
>=20
> > From: Saleem, Shiraz <shiraz.saleem@intel.com>
> > Sent: Monday, April 12, 2021 8:21 PM
> >
> > > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> > >
> > > On Wed, Apr 07, 2021 at 08:58:25PM +0000, Saleem, Shiraz wrote:
> > > > > Subject: Re: [PATCH v4 05/23] ice: Add devlink params support
> > > > >
> > > > > On Tue, Apr 06, 2021 at 04:01:07PM -0500, Shiraz Saleem wrote:
> > > > > > Add a new generic runtime devlink parameter 'rdma_protocol'
> > > > > > and use it in ice PCI driver. Configuration changes result in
> > > > > > unplugging the auxiliary RDMA device and re-plugging it with
> > > > > > updated values for irdma auxiiary driver to consume at
> > > > > > drv.probe()
> > > > > >
> > > > > > Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > > > > >  .../networking/devlink/devlink-params.rst          |  6 ++
> > > > > >  Documentation/networking/devlink/ice.rst           | 13 +++
> > > > > >  drivers/net/ethernet/intel/ice/ice_devlink.c       | 92
> > > +++++++++++++++++++++-
> > > > > >  drivers/net/ethernet/intel/ice/ice_devlink.h       |  5 ++
> > > > > >  drivers/net/ethernet/intel/ice/ice_main.c          |  2 +
> > > > > >  include/net/devlink.h                              |  4 +
> > > > > >  net/core/devlink.c                                 |  5 ++
> > > > > >  7 files changed, 125 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git
> > > > > > a/Documentation/networking/devlink/devlink-params.rst
> > > > > > b/Documentation/networking/devlink/devlink-params.rst
> > > > > > index 54c9f10..0b454c3 100644
> > > > > > +++ b/Documentation/networking/devlink/devlink-params.rst
> > > > > > @@ -114,3 +114,9 @@ own name.
> > > > > >         will NACK any attempt of other host to reset the
> > > > > > device. This
> > parameter
> > > > > >         is useful for setups where a device is shared by
> > > > > > different hosts,
> > such
> > > > > >         as multi-host setup.
> > > > > > +   * - ``rdma_protocol``
> > > > > > +     - string
> > > > > > +     - Selects the RDMA protocol selected for multi-protocol d=
evices.
> > > > > > +        - ``iwarp`` iWARP
> > > > > > +	- ``roce`` RoCE
> > > > > > +	- ``ib`` Infiniband
> > > > >
> > > > > I'm still not sure this belongs in devlink.
> > > >
> > > > I believe you suggested we use devlink for protocol switch.
> > >
> > > Yes, devlink is the right place, but selecting a *single* protocol
> > > doesn't seem right, or general enough.
> > >
> > > Parav is talking about generic ways to customize the aux devices
> > > created and that would seem to serve the same function as this.
> >
> > Is there an RFC or something posted for us to look at?
> I do not have polished RFC content ready yet.
> But coping the full config sequence snippet from the internal draft (chan=
ged
> for ice example) here as I like to discuss with you in this context.
>=20
> # (1) show auxiliary device types supported by a given devlink device.
> # applies to pci pf,vf,sf. (in general at devlink instance).
> $ devlink dev auxdev show pci/0000:06.00.0
> pci/0000:06.00.0:
>   current:
>     roce eth
>   new:
>   supported:
>     roce eth iwarp
>=20
> # (2) enable iwarp and ethernet type of aux devices and disable roce.
> $ devlink dev auxdev set pci/0000:06:00.0 roce off iwarp on
>=20
> # (3) now see which aux devices will be enable on next reload.
> $ devlink dev auxdev show pci/0000:06:00.0
> pci/0000:06:00.0:
>   current:
>     roce eth
>   new:
>     eth iwarp
>   supported:
>     roce eth iwarp
>=20
> # (4) now reload the device and see which aux devices are created.
> At this point driver undergoes reconfig for removal of roce and adding iw=
arp.
> $ devlink reload pci/0000:06:00.0
>=20
> # (5) verify which are the aux devices now activated.
> $ devlink dev auxdev show pci/0000:06:00.0
> pci/0000:06:00.0:
>   current:
>     roce eth
This was copy paste error from my command #1.
It should be "roce eth" should be "iwarp eth".
This is because in step #3, iwarp was enabled.

>   new:
>   supported:
>     roce eth iwarp
>=20
> Above 'new' section is only shown when its set. (similar to devlink resou=
rce).
> In command two vendor driver can fail the call when iwarp and roce both
> enabled by user.
> mlx5_core doesn't have iwarp, but its vdpa type of device. And for other
> cases we just want to enable roce disabling eth and vdpa.
