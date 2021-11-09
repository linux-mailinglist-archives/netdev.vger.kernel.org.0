Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E1944A013
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 01:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbhKIBBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:01:14 -0500
Received: from mga05.intel.com ([192.55.52.43]:7953 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236348AbhKIBBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:01:14 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10162"; a="318551970"
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="318551970"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2021 16:58:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,218,1631602800"; 
   d="scan'208";a="451689416"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 08 Nov 2021 16:58:28 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 16:58:27 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 8 Nov 2021 16:58:27 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 8 Nov 2021 16:58:27 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 8 Nov 2021 16:58:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNq/PrRLDuoXkKfjBTVzKWQmh2z00TjwLqQlv5HOXNrETonAMMbUZQieVn7xY18C7vVF61CAM9+B1ZODrSz+UjNNllV/8AK7efogLTVIzHK3cp4sy0eghCTagVsR5w54zyiWI0VA1LTfzd4VcWBoeGlpcUZ7CmXzrp80v4HnW2sEOP1abpfiEeLDhxivrNJwS8SxTs8JrYhyFCNzktng0fCYWYC4cD25/9GD3urM8fuyZyRLyCpzpLrWm0mkLPRbTEWGk1t7W9x00788CucG85ISCS/y38Yuum4S4xuaj6U3TWc1yUGiE6PzRtI4X1ao1pD0O47ZDzF4/W8+01ZyPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrHBClRDT6z+VXR5CQBdBU4ogHGur29WIWQ47STYwQE=;
 b=c8u3O7MlME/z85VGOYM06UKe5opthnoy3hvtqvT1SlOiRT2dUGhdoSwUYtuKNRdbhySEJUm2fJARlvWKuyagNd6RIc+tmE/PVn2z8fI8o3ZZLViFKPxFalKXR4Io1bonAmlfdxXsIMfZT05Ybiu2mH78ZUuhCQcc1XPSbqPybfRIVtnn8pHf0JNWYTRQv9aep6Pl3AKobfoww7AY5G8aa9IkZkNRe/FRjTvylT13/vGSRpRi9wYKToep6k4YqKHGo64B9+GQePcmsqAXmGyBbUYWhzlcFhscnV5L5i8zyThCJ7Havtqo0unLaLl2sYF75cGxBswly9x39ODx3HlR8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrHBClRDT6z+VXR5CQBdBU4ogHGur29WIWQ47STYwQE=;
 b=R2sOWuVHlPXB6Cvf1H+jv32n2h02+2I1895MxQz/xrPLuNwz2ixHX5Er9TMUh2oyB/07VZCoRCuFjQmFvIx2VbuIKr4q05Kzc49CskPz8C+gIqOZlvkCdRi5OXm21389M+dSyhI1wCCD3g+ryh4t4C20aU7J2PYJKMbex+nyopg=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN9PR11MB5420.namprd11.prod.outlook.com (2603:10b6:408:101::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10; Tue, 9 Nov
 2021 00:58:26 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::ecad:62e1:bab9:ac81%9]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 00:58:26 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
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
Thread-Index: AQHXxNiiQv8W8p5Om0G/XtAgyw28t6vaqNQAgAALEQCAABqsAIAAIxaAgACddQCAAIzwAIAAI26AgAAjuICAANCqAIAAzO+AgAWtdwCAACFWgIAAB8YAgAGYuJeAE/f4kIAASI+AgADKufA=
Date:   Tue, 9 Nov 2021 00:58:26 +0000
Message-ID: <BN9PR11MB5433435CAAAB23EAE085C3128C929@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
 <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <BN9PR11MB5433ACFD8418D888F9E1BCAE8C919@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211108123547.GS2744544@nvidia.com>
In-Reply-To: <20211108123547.GS2744544@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c1e8c1e-808b-4ced-85dd-08d9a31c096f
x-ms-traffictypediagnostic: BN9PR11MB5420:
x-microsoft-antispam-prvs: <BN9PR11MB54203E25617F6B101AF720088C929@BN9PR11MB5420.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qfFsQcpJMNq1nyt5BfGWy+9CAnQaofQH0WLTVkXoBqKCCgX+BzpB/BAK59raE/ewpZFN0pttneRDvZEFQ6TGveaIG1jVOf/PK4DMsYDmVCSmYQgijzc84G6ClBZX9CqG2yX8XFkaym53lHy0toSFRZ90WDiYXMsDf2KJgHXkJeNErUMpbeE8bLW5mpaBVKj1mwWCZgzZQm/wwwGuB5sHNRQvy0lNYP0OSvcsm/ArECwYekvNjBVS9G51vhW+G2RRtBky0scSxWKpMLEB2IaF4/0wmNT7MJEIz8qjlgUxQHZIbxPQvMgV0jn1EyQg0XGVd9gfIOH+9niqhlvENp/FdkmUm612LSeePZy9V1v41bJY07nkGELR2zs70/MjHPy4UaWwW6Hr58eT5h+9YheUuQiuB/1PeTAGgTyQXU71sxWvjg9biaCR/a29eTFwjYq9EliTRKEzJIZgVbrgCYN19wlgzr8FCyx7jozqawVneTKYeNW+JAF+e8ENzkZXNAkSEcgwkgRDrmfB+lXvqoQvItdjzfFVE0eX1ZitpRM5KEUNOP/PvAz7j2TP2tBfVWcWHnQu2yOL6YVCMxNutn/xZxJg/meRimTGi1fxbLIM05wLRy7exaqxsOB9SaSU22mfWorxQ5SgXfhsJK3AN9WBadBuIot6PXL2xsU85xMHvIaFwxMum1yZtDc7HxKc+oFWWzF2FgSRFsbk0gsqtf6/Vw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(8676002)(76116006)(122000001)(7416002)(71200400001)(83380400001)(5660300002)(26005)(52536014)(54906003)(38070700005)(6916009)(186003)(86362001)(7696005)(66476007)(8936002)(316002)(64756008)(6506007)(82960400001)(55016002)(9686003)(508600001)(33656002)(38100700002)(66946007)(66446008)(66556008)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tOsNuNrb2CeNDcned1jNMbdsSvHmzpa2oxi6vjtgqQhyK5BLJNgzlR7tJesr?=
 =?us-ascii?Q?rq2btwldCuDcOkaefWAXikADCrmsrqL3t/CeNiBZezoYFHtnh3EPQFeSMNtL?=
 =?us-ascii?Q?5/yDkEuklztv1lNVIXqpEie1zQ+xzNSzLTYF27QNvan8RNimdiNYaMYN5fGT?=
 =?us-ascii?Q?4OjKut8eqqnaT24mL8TAUVVr7olKGW9oKJQ1WtkOUbSlXJSgkqUTdFNb444O?=
 =?us-ascii?Q?hn6f18Z/e3Y5tLKbVq+tF+uwDaifPDEsOFineOaT78Ec09D2D5FN8EWd/aaK?=
 =?us-ascii?Q?bfeQwqGuB1MeC3U6p5zWSb7WtIqSYG84NX5MSDnPeC1OSINz7wuHCr8OFPro?=
 =?us-ascii?Q?U7AsTjaL9twuFHchn57+X/Zyklct26aLmwQmoe59zzG/YeEwQ4mpjbWvEQTO?=
 =?us-ascii?Q?+2yr2kQnrPyUokWpNZXe3f6VW9Fb2NEWArUwE35HViF8koQyQyHVhgSU3Yw0?=
 =?us-ascii?Q?OhnML+KfYawGVq0Zbu37GkwBbKy5zBghJ8gAV6tjckV26hj4VB4q3umECMJe?=
 =?us-ascii?Q?WnC0yBZzrV/JYDnthNLpLtHysvNG2Ke28DdA8gic2UQBa1raVxdMVrnHtQ3c?=
 =?us-ascii?Q?Vp9yNHfZpdrVXpJ85DFqlEkHSA0zzBZpzxQ5tLETvhS/em4fmRy8D64GyGTh?=
 =?us-ascii?Q?gbEOMGKwdLaIQQjZ4cK7TNX8cW6tunKKv03Zm9kKpBJkPp2WBoSYvoxkKNui?=
 =?us-ascii?Q?RtukxbbU35GjdmYxtW9qPapbmFyWjth4ilTfuB4Eoyxw5TP+lL+wVTS9NHCm?=
 =?us-ascii?Q?JmOauuZQebXe4Ba8WbVwPj/19N2Of1NFUpv/yYy0CAy6EpIbJjjH7BeQ4BAr?=
 =?us-ascii?Q?LlFYHr+L/wk3+vto1UySoS2zhrHzMOW3GIZhd57j1IcwfcYdrIZYMvszF98I?=
 =?us-ascii?Q?rOxOhTKyKmx4tS0owzgpR0ik4KJamUj12eAixhA+fueGfxxc2IJOSQ8ivuT2?=
 =?us-ascii?Q?+GmrkrnOcymct5FnpNl21aXR2QvLrhPBalJ5DwEjgz1Zu8aZEvHKzQ7XjTZa?=
 =?us-ascii?Q?vjwFCs/BPTaI68rNtsSy69pPufXkjxaZAOCFob56h2+Blf0f2Hr/X/ek2PoE?=
 =?us-ascii?Q?bKcsWYBjmsMdH9zqEPFVaSDc8uSVVUXYYuBG01ijITJkuhyC3ftrLK4uPgX1?=
 =?us-ascii?Q?mV6ZxEiGm1yY2fe99C7Nn8n7/rT9Trtwn+2nEWZQ1HMg9nr5kz6YBggyx7kv?=
 =?us-ascii?Q?3Rr8roT8yeB9BTC2egRprp04jRg1KRQW9lQ4KrJwj5EYxmHtpQiGoGi9cCCi?=
 =?us-ascii?Q?b00BhbzsX+6nadmC5Paqxs+6HqLMzHOPqlMuqCBJs7exy+pnvNqH1cwkf/lQ?=
 =?us-ascii?Q?AtYgtWiQ7ye5sr/GrF8yDG5ON+piowoOIvbm+hLQ+po3bfO/junpRJSuoENN?=
 =?us-ascii?Q?oal8cmxrH5dPBvS+BsgE9QQqCQB2fqkGRZ1dFHWGFrasi5GUB7CyDMGYsu6m?=
 =?us-ascii?Q?fDhf9T2SFWc37xtErWaO1hzljZCYdbI34piSIHeJkxwhVHHL8cDJpor/9hk+?=
 =?us-ascii?Q?2trruoq6swv39vthX9rNOwk0rJMaSq/Y8J2NWsmTBF22oqcp4LX8uvTYkjHv?=
 =?us-ascii?Q?BroLf74Au8A1vG5uvs/F2Id9UCWLUDzjpGQFkMRYyGa4D/DsDLkgSyV7xJYo?=
 =?us-ascii?Q?OZEOPsT/MH1+csQlVWp+KoE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c1e8c1e-808b-4ced-85dd-08d9a31c096f
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2021 00:58:26.1057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dNqAO+QpOEwuYGDLPuf/WmRMohfqNNDPTH5lHnZYn+maxGVE+WPsbkXbiUc7C5Uqkpu81X9Lng1VQvHhT3tdLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5420
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, November 8, 2021 8:36 PM
>=20
> On Mon, Nov 08, 2021 at 08:53:20AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, October 26, 2021 11:19 PM
> > >
> > > On Tue, Oct 26, 2021 at 08:42:12AM -0600, Alex Williamson wrote:
> > >
> > > > > This is also why I don't like it being so transparent as it is
> > > > > something userspace needs to care about - especially if the HW
> cannot
> > > > > support such a thing, if we intend to allow that.
> > > >
> > > > Userspace does need to care, but userspace's concern over this shou=
ld
> > > > not be able to compromise the platform and therefore making VF
> > > > assignment more susceptible to fatal error conditions to comply wit=
h a
> > > > migration uAPI is troublesome for me.
> > >
> > > It is an interesting scenario.
> > >
> > > I think it points that we are not implementing this fully properly.
> > >
> > > The !RUNNING state should be like your reset efforts.
> > >
> > > All access to the MMIO memories from userspace should be revoked
> > > during !RUNNING
> >
> > This assumes that vCPUs must be stopped before !RUNNING is entered
> > in virtualization case. and it is true today.
> >
> > But it may not hold when talking about guest SVA and I/O page fault [1]=
.
> > The problem is that the pending requests may trigger I/O page faults
> > on guest page tables. W/o running vCPUs to handle those faults, the
> > quiesce command cannot complete draining the pending requests
> > if the device doesn't support preempt-on-fault (at least it's the case =
for
> > some Intel and Huawei devices, possibly true for most initial SVA
> > implementations).
>=20
> It cannot be ordered any other way.
>=20
> vCPUs must be stopped first, then the PCI devices must be stopped
> after, otherwise the vCPU can touch a stopped a device while handling
> a fault which is unreasonable.
>=20
> However, migrating a pending IOMMU fault does seem unreasonable as well.
>=20
> The NDA state can potentially solve this:
>=20
>   RUNNING | VCPU RUNNING - Normal
>   NDMA | RUNNING | VCPU RUNNING - Halt and flush DMA, and thus all
> faults
>   NDMA | RUNNING - Halt all MMIO access

should be two steps?

NDMA | RUNNING - vCPU stops access to the device
NDMA - halt all MMIO access by revoking mapping

>   0 - Halted everything

yes, adding a new state sounds better than reordering the vcpu/device
stop sequence.

>=20
> Though this may be more disruptive to the vCPUs as they could spin on
> DMA/interrupts that will not come.

it's inevitable regardless how we define the migration states. the
actual impact depends on how long 'Halt and flush DMA' will take.

Thanks
Kevin
