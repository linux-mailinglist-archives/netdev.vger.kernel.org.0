Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C7447C4D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 09:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237105AbhKHI4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 03:56:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:50785 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236594AbhKHI4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 03:56:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10161"; a="219390271"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="219390271"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 00:53:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="581399115"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Nov 2021 00:53:21 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 00:53:21 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 8 Nov 2021 00:53:21 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 8 Nov 2021 00:53:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOfnj+ZApD26iMt5vut/T2gzj8s5Y0QAeHgCXiLnB/bhVlb/Am/I00vIewjcqEToWMhptALZU3f3eZy4pTb0Nz2gtK0DRM85hyH1pRjn2MGG2S5zkyE6GkZKWC8bjjm80mIAmR+PHnnIi60jzowBWzxtqJ+DquE0h129SKKzJd3UwUcmnwsC2gVimhgA71teBPtQJfMwMyY36FLTudBpe2em31pW9cYvdV1V2snONgzCPyjQCVgTMxlUk3bY9RsbOEzr6Jd3BNx/U+1n1iXXID49cj3GiIIydFS7Rtoa8kMX022bSDWLbwWD8mJXCfbxuzVCKSEVXV8aI9MWwVCauw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QGIOop6anO0nlwluRiC7d5ny1MPisTsFSJ+6Lq8Kyfg=;
 b=NC4pPfOonMkSextXWu25MjIYbgwIwQbnT/enpHfXplURszieECConSdHPC260MKUkXuSFI7cNVsEOzyNNO3Go0P+7vT+jlI1EPadmzcQFA5dG6G8QnHEIytPRvRC6prG1Hu5Doj1iseObVAQc4PfoqT4IBLMxQMfRJhuBjQT7Vv/yPLaHP8dUQL2gGnS0S22jRnbOILx6VeJZA6n+zIEfwHvyv7h7u0lDHWE4c7dS334WnNiU2jus7U/7PDimJYfkH8EjSY/TLm7Td0VBU474fgOaFGv1ar8yYBHzjgrflpZ2/qC5K8YKzB4s09hWCxVNPRL15coblPI/fprojYbgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QGIOop6anO0nlwluRiC7d5ny1MPisTsFSJ+6Lq8Kyfg=;
 b=ULuQARbxTgR9LBTwDNqC8SEBcqRSPQEDVx3imQPA/sGf8eBh/ahP5cGsGvNGBkaUeyy6GO++JnAIqvXFfPgUQa+KKS2C6uTeASkK+d53BI4cBRw6NUy3m8aYdYm9/90P4dAsJjlFtaNL2dlT/SOQf5upR2dyZGWEC0EEsrg0KP8=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5340.namprd11.prod.outlook.com (2603:10b6:408:119::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.15; Mon, 8 Nov
 2021 08:53:20 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%9]) with mapi id 15.20.4669.016; Mon, 8 Nov 2021
 08:53:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: RE: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Topic: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Index: AQHXxNiiQv8W8p5Om0G/XtAgyw28t6vaqNQAgAALEQCAABqsAIAAIxaAgACddQCAAIzwAIAAI26AgAAjuICAANCqAIAAzO+AgAWtdwCAACFWgIAAB8YAgAGYuJeAE/f4kA==
Date:   Mon, 8 Nov 2021 08:53:20 +0000
Message-ID: <BN9PR11MB5433ACFD8418D888F9E1BCAE8C919@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
 <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
In-Reply-To: <20211026151851.GW2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1163a44f-1eed-4988-f09b-08d9a29536b9
x-ms-traffictypediagnostic: BN9PR11MB5340:
x-microsoft-antispam-prvs: <BN9PR11MB534089EB131FA0C488735DE88C919@BN9PR11MB5340.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B8vTE9uJ2F/jLS+16gOw660mNW0z+BtFtiLNaXR1b+gfgTuM4aE8tUByL6LV1F9WoBXDgPyTGsmr7ae6fHavRC0MZg3SeXM58wzhYe6Zx40BeTrrJarYHZ5xcuNyDYUGwY6kVJoduwVre6wCSXQ5Ppq2cqs+ErRAV7YWZ8biZUySnKsTY+vxpwfFK/Xi32BzaAj8iP6/R2pJuLyau8Cs3qcVMNO7K2DDVIMhZzFvzK9WuoNdfNQDsBOZOF/jdGlY1RK5kA907gF/r8HIaMOt3Titb6u5zFXOPlV4J67dPQDsP0fKMWUSQPjTt+RHgVt8CRfxizHy2FIPDJcGv/fIL0UQSInNpe7+blz3TplumTjPVo9TDY0f7R0YTUtNWkD1YzUQH66NXBXHRfLrPaekW9tlZXRNXH7ki5yQzYKyloQ6BfgiHk6lCMqmjM5LuDP6Lf+xCk1rklyOCOZdK4B4qVxayN9lkjw96jy5MCC3TxZBuTia+IIr0OaqF2XUUevx8S+Zagszebpz9pXzSODYJ571wvOFnQWJzmpAPjTPcUjGYFj0MQNW6hLOEMrG2ieB7gy0FynvtYZWaspSPRC0GKiabSN2CHTHUSr2vewwVCMKN7SbbYg224/zGbnfBiRYF4SHCbRvY6A+He/f7nb8n0oFG+7KJGb3iPp0KngceiRPYJuWaSQ03g99/oTi4rGdfAHVaLWkB+3zjVXkizPEr7m4Sgs02GN7D09RlE7EcUzYrDdAfiGEb3ZysYQ4CO2mc5DNcpG9wjPhlIdrMi3V1IgxUBy/saQ10oJYszL78D4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(38070700005)(55016002)(110136005)(6506007)(82960400001)(7696005)(66446008)(9686003)(5660300002)(8676002)(38100700002)(122000001)(8936002)(52536014)(316002)(54906003)(64756008)(186003)(26005)(508600001)(66946007)(76116006)(66556008)(66476007)(86362001)(7416002)(2906002)(4326008)(83380400001)(33656002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YHgvEWZ7aHBUHK1HZKWPSOp5goI1CBF6gwJ8Qtyb61/f1A1oVLIFD47aet2+?=
 =?us-ascii?Q?IzLzJWX2/V8NnGuJY0dQakpw6uOmZ0TZLPVs+ihJzPggfIc7Kgdu2JjoIuSU?=
 =?us-ascii?Q?wT95cKH7dVCvQ7nKDTcEU22zwaSSrIfxu1TddShyZ60C96EDByuoCod0Vl+u?=
 =?us-ascii?Q?fcnRG11gWQwz7tkZKPK3FBVhBAj4jizyd5jVf+DMOIqbf8R7R51malcRxmUd?=
 =?us-ascii?Q?62Ai5yC0VGqjoAC7dzmlxEMOLEsAG6Q4JFTAFj1mFnIuEycKB9lqGpeebT4G?=
 =?us-ascii?Q?sINNwJBpkwkxdimgXXxGtCBPa+ucBPmoFxqHHmydRnyalcMpAxEKtE/SqYw3?=
 =?us-ascii?Q?WW5z6hnDwJzknJfXpDw/9YQl+3hxk8xGhYtXOgoKcoerO+iZNYP3QAQmeEpI?=
 =?us-ascii?Q?DEPhzFe9Z+KP+d49wk/xbhnu3R72Vm18NSUelMNl9AvBmdZC8SYCigJ3oDSM?=
 =?us-ascii?Q?Wb+3CcP6BFOS9ZDGA+E0NFeaVckap4/LwqZHNXE/5Zhx7mf1rkndRG2ulUpz?=
 =?us-ascii?Q?diTd9SlF3LoJ4/xdYWI8FJbGZGZcVHeSDvp5yMlQf+Jx1fkuxszR422hyJQg?=
 =?us-ascii?Q?p39wO4MT4uTCWGRpHdvuCHTybl73XZ0oI3cRvIlWlwdvzTGADalkIKBcC+22?=
 =?us-ascii?Q?XCgdpPUmm5LiepjW6Z2Wc9X1vpobk5HnkUPG6BiKqNFQ9KhVGdJOroLGTIv2?=
 =?us-ascii?Q?zDGpEquzO/51NWK3umgjLwMIWbogLe2l+mLk8jHuEPbBX6Mjf6uk42KiYeYd?=
 =?us-ascii?Q?sXACu1HXfrcJnuARCcKL0I94b7VkX1g2Z0DXjrs/gwUcUAK+K2UJpJKPajFz?=
 =?us-ascii?Q?98ZDJXeNlPW4FMt1BenvhAdAXEYsl663SkgEk9tfjpGyqn8l7J6cPqhn/YpT?=
 =?us-ascii?Q?rvZxGTE8m2FgL/HSdBXP0oR7QSCUPLiLKtjnW406/k9zENW8Kms2dCFL+jlM?=
 =?us-ascii?Q?T+0P98Q2cptOU5dBZnDbYBNzv9g4lZa+W5oDBCC398tb6QZVCQS0vuvPeBpb?=
 =?us-ascii?Q?vdhGRVxx7oZ322Y06iTBbKII5t2bmCafVAg38MHNFnl+9UHluym74iAM8ZpW?=
 =?us-ascii?Q?vIDQpINQjXYlLSKwtYh+I2GbI2xoQ5IdzFJawOGr4HOsCKamLuC2lbcJ0Qvw?=
 =?us-ascii?Q?M6pdVRQNM0xeQUUbtF8Sf2VQu5o0Ytwfl2tJ/MxI8B6/owG1KogP2Q81z0/G?=
 =?us-ascii?Q?4GGn68vD/pzxqGrLe+SvEH6gqsYbRi+g7FJJZQP+hnqwvIXn9XQ/kPUmCwDt?=
 =?us-ascii?Q?6F9RqRafbnmhmEJ11vEKmCJILTPe51vZhheeEZmNGU6Etz8m75pu50DycIrb?=
 =?us-ascii?Q?dIM4a9Ke/4ezPnbBhX+5d1kZ3VHwnvw6gdG5rNR5DL1GCcDfYZ79d8RPGMy0?=
 =?us-ascii?Q?4E1qrmBJ9jik1oBitfbXqjs6woev5xdjHpr1gKqDVQoX6Zf3fC2nkY5DbtQH?=
 =?us-ascii?Q?brWuUBPeHDZL1BDX9dKsyoAkUDs5RPs4jy18fdEFSIZZT6+cuxcAIPnKXyRW?=
 =?us-ascii?Q?5AmPQ+pJnQVlzdYpFpm2hzDTgYWRmCQtZj6eW4YmpHLa3vXDBxGlxIr67Z2m?=
 =?us-ascii?Q?kPMU47zRAQBk+BCJo6aHaOVoMO8SlT7retuBVvxJAeAgbWuHhLel7A3yY2Xq?=
 =?us-ascii?Q?FxmucZVlMk2/ry3BSW7b0Ik=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1163a44f-1eed-4988-f09b-08d9a29536b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2021 08:53:20.0622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jMtnQWeg/KvZT7L4JzRJvy6c1CZgqSXVxbnE+PZ/J18ASV1gF1T2DceITpm1dc0PnWWBmUl/jMZ0DBS1BMZgUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5340
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, October 26, 2021 11:19 PM
>=20
> On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:
>=20
> > > This is also why I don't like it being so transparent as it is
> > > something userspace needs to care about - especially if the HW cannot
> > > support such a thing, if we intend to allow that.
> >
> > Userspace does need to care, but userspace's concern over this should
> > not be able to compromise the platform and therefore making VF
> > assignment more susceptible to fatal error conditions to comply with a
> > migration uAPI is troublesome for me.
>=20
> It is an interesting scenario.
>=20
> I think it points that we are not implementing this fully properly.
>=20
> The !RUNNING state should be like your reset efforts.
>=20
> All access to the MMIO memories from userspace should be revoked
> during !RUNNING

This assumes that vCPUs must be stopped before !RUNNING is entered=20
in virtualization case. and it is true today.

But it may not hold when talking about guest SVA and I/O page fault [1].
The problem is that the pending requests may trigger I/O page faults
on guest page tables. W/o running vCPUs to handle those faults, the
quiesce command cannot complete draining the pending requests
if the device doesn't support preempt-on-fault (at least it's the case for
some Intel and Huawei devices, possibly true for most initial SVA
implementations).=20

Of course migrating guest SVA requires more changes as discussed in [1].=20
Here just want to point out this forward-looking requirement so any=20
definition change in this thread won't break that usage.

[1] https://lore.kernel.org/qemu-devel/06cb5bfd-f6f8-b61b-1a7e-60a9ae2f8fac=
@nvidia.com/T/
(p.s. 'stop device' in [1] means 'quiesce device' in this thread)

Thanks,
Kevin

>=20
> All VMAs zap'd.
>=20
> All IOMMU peer mappings invalidated.
>=20
> The kernel should directly block userspace from causing a MMIO TLP
> before the device driver goes to !RUNNING.
>=20
> Then the question of what the device does at this edge is not
> relevant as hostile userspace cannot trigger it.
>=20
> The logical way to implement this is to key off running and
> block/unblock MMIO access when !RUNNING.
>=20
> To me this strongly suggests that the extra bit is the correct way
> forward as the driver is much simpler to implement and understand if
> RUNNING directly controls the availability of MMIO instead of having
> an irregular case where !RUNNING still allows MMIO but only until a
> pending_bytes read.
>=20
> Given the complexity of this can we move ahead with the current
> mlx5_vfio and Yishai&co can come with some followup proposal to split
> the freeze/queice and block MMIO?
>=20
> Jason
