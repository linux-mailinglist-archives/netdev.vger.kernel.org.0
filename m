Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9580147C918
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 23:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237673AbhLUWMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 17:12:49 -0500
Received: from mga05.intel.com ([192.55.52.43]:58751 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232284AbhLUWMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 17:12:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640124768; x=1671660768;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PGpVodvSvN5Hx9lUskfr95r0t+L9Lp8asddDZFd2OBE=;
  b=MTeoreBch1WspNvVfo0p1zj+vvobiajRUz3At3VqXj8m3vuoWFuTQH/i
   849CSU1i2fXy0QNSEf8EBYSM4rJr5KbuYwTEYGMWK+M2OM5uzW/aGTTTY
   Ef23jpMuKlkDkO6QcwkPaU47qTzncnVltmAbhr1c4HQragVtHHn6uGC5P
   p3hbSJXgVYjKlHDZKifqmDJMKqvbbi8TzHlN0KLD7Sm4KjiWu7aqaUtOv
   ZSWjHpdQCjvuP9H8EZcz0afWZTPbor8QzjWsAnfWo01nKr567TXsvaMvr
   E0VwGhiDR8RcMVG5dM3CSmVmkzeHqrrmT4Nsiq5bShBGpsAqjj9wDgYsY
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="326802815"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="326802815"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 14:12:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="755994681"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga006.fm.intel.com with ESMTP; 21 Dec 2021 14:12:47 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 14:12:47 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 14:12:47 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 14:12:47 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 14:12:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PGe2r9ZgWXpahqZgKZYcjx0mN3rM6KtDhMvOgQa4HIqZWcrIdXl4swiIg+7jAKWDAR0Gc7C/GQ9SUhUXm7adxPEFIiQFCgcYSHrprEziT0+trBRgnPq8qjHc9sGznYXDWF/WCl5EqKHtAwfjzg0oitScl38pZ9GybG2HG7g+XX5RWMG3mals7iFaPIlkuy6hbmEBMrQa+uVbGt/hIWZpHvQFxb3WMqOKqHmX65AsFsycsygqu+vDFnAPbzE3WC46PUUOAD0JT6nvKToHbJBjMN+oB4oyv4YXdpn/7i4onNzvnoqhFZTrWqaFDUjGaE4xJTucaCL6PMC3mDgqx7Pgtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EgTKrrq9V1C6sFng8Pzy3M3oV94uEZVCl7Z+qCEdbjA=;
 b=Q3eGdtvXZvJqU6JdzON1grDDZ3DrpjPT5mUNaIVhbMk1ZoLFAHH6rh9/S5smzSfaJjeUiOyk3A/dQ7ZZVkfSV3pkOlggjytCiGXsu8CsPJxOwH734x1mBZz69VDZM/VfVCk4oARRIW5L8C/8IAlpnH04Luz/6t6dl2GlZSRguv2xK+nRBkdwRxfy3yKJFU0DNr1jxb0xwfSyE27J/S8vSNXVs+IVTvnuwiMNdTHqGrLkcZ4Qr/1D7nRm+Pr1jgGTbe5F4QwWfquVflTeYwYRAqel3Oi0h6Gg/KohsjhH1mOmO5l5mRlbt520Auv+Lqh7K6b+dIoOkqFOrt1h0KrJBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by CO1PR11MB5090.namprd11.prod.outlook.com (2603:10b6:303:96::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 22:12:44 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1ca9:6778:2b2f:7de9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1ca9:6778:2b2f:7de9%5]) with mapi id 15.20.4801.020; Tue, 21 Dec 2021
 22:12:44 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Byagowi, Ahmad" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "Vadim Fedorenko" <vfedorenko@novek.ru>
Subject: RE: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Topic: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
Thread-Index: AQHX7c5gIm8QXL1ZEECyYOKvL6PbZKwuwIcAgAFiCYCAC1L2AIACGiOw
Date:   Tue, 21 Dec 2021 22:12:44 +0000
Message-ID: <MW5PR11MB58127387AC887DFF43140697EA7C9@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211210134550.1195182-1-maciej.machnikowski@intel.com>
 <YbXhXstRpzpQRBR8@shredder>
 <MW5PR11MB5812E5A30C05E2F1EAB2D9D5EA769@MW5PR11MB5812.namprd11.prod.outlook.com>
 <YcCKLnrvbu9RBlR8@shredder>
In-Reply-To: <YcCKLnrvbu9RBlR8@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d40f6213-3f13-4191-1227-08d9c4cf038b
x-ms-traffictypediagnostic: CO1PR11MB5090:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CO1PR11MB509077BB953F8E482EFAD758EA7C9@CO1PR11MB5090.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7LPpaGamSOeBRqt/Mx4jQS4K1IK4U4jD4v2QjjHRtnL9/Ona0kpEW9n2l8udL1fe18BjzRCiuJJr8AzxIFTnd0h4jacyo5WnMZ5/iCyGRioNcDcnIUkk0buSivwSHk1170irTJX/OPH0MHC1RzM24JAx+nfgjR72gef9BJedEaW0Gp7WJogksv6IVpMawDAhFipzXycucF0/575PPNbt5YVYBPT96SGci0NORa8XIR5Phng/9+2/AZSOveFLDbIkypEyC/Mw+1rpUKQXX4RozMYD2MiE1+1puQj18GG/no+HpSqt+0QDz3tCSZ3gj42Qnngg5T5PEXgRh7fEZODFHChBnhR11OtuQs3dk3h5TUIF6VLFAS/ItgCOiK5GOwMfKRugGkYzntUVLOmz5ReORgo6jDij8JLdwSH1rwF63wXiaanzMp1D8MsVhKTdyXUiIDQVvjMas5I/2tfQos7ypLj+fD0REdYa/fxbygSON4jWEiHilJog41rNBwFXY8wHZoWEe5L59+KLj1Nm4ArbBfj4QZmO4ghgx8nrJL+2cCrkNy7qlOS+CSPwXgJ0NKkUxPRP1JEUJZ9p0XlzYBfbHWcyowlXlouJgL2Hjj9AiVhIfmNJTa0PYuSMIH0biVqsf6eiNDxP9CueQAsWkjzyrjEO09K1b735aLig8+I+Md41bNEL3SCFKkp15fmqw2Bnip0l61xOBLSeMsp9GxWiYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(38070700005)(8936002)(82960400001)(7696005)(52536014)(66946007)(66556008)(508600001)(64756008)(316002)(54906003)(9686003)(76116006)(66446008)(55016003)(66476007)(5660300002)(71200400001)(86362001)(8676002)(7416002)(53546011)(6506007)(83380400001)(26005)(38100700002)(122000001)(2906002)(186003)(33656002)(6916009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dHwVIh/fPyk/xfmIeXoPr6nyi9L7hVYQC9+Bi9lrIglUJgrnvsT51Ycf7ToG?=
 =?us-ascii?Q?tazqWTLP02/+hNeoywu1TNgav4mwPkdhm3d/fIhVUdva1KN0NzQMHETEC+oT?=
 =?us-ascii?Q?11mridI9lTndm016Lj8/Fo69JnhyrsRu03TjR1F4YegHq1Nhri/0uZ15UMCk?=
 =?us-ascii?Q?sjsWWPk4eOR5Auarn39WvH4zcWJEo/iOlkXCKP/L0JlFHfK7i2dmjMZTO83z?=
 =?us-ascii?Q?DsSlGWG6PsWcvKCAH+CtoQ84FA88poTZXdxVywUOe9Q02pk7SZIbTJgnQXUi?=
 =?us-ascii?Q?0LJ/82bu7qn92v0wOS4gOBMIRWVtwppltqnDLfZ2T50zhf5VItKcLDfwBeJo?=
 =?us-ascii?Q?4dv0GWMAqCY3go1V/xcFM7nDIEToZ1KLWUHOi0XkQ6y5A7jmYY2PA5WQ8z0s?=
 =?us-ascii?Q?XCXc+70aN6C9JSDGkDuFKPYjfeOwpqmO1tksV1ymPwjv9Y7zBjVBSorZT8nU?=
 =?us-ascii?Q?aY40zZLk4NfIw7YMqsLwiJmeTb4hZJSANdgyVTaHluglWfeM0CIzqeuvT+HK?=
 =?us-ascii?Q?49qJQehWV5KuXBfsMikuYF6JzPGAuPaU2s9mZcPGKg4EXgXbPsnRt7PN7573?=
 =?us-ascii?Q?MAeOkw9R/ltnvWjkTdvJVsiV0DZfL/MRh/NDiW1eW9qm2Eyj6oqekuLQA4b5?=
 =?us-ascii?Q?SM9OlPMvZlDf8qQ2ypupTmGKa16ZvXxauQVpGVqdPwrSYT9MprwuNX8AfVoz?=
 =?us-ascii?Q?dVQq2K+eRRGICVRYQlimOwMuSpezXuXl3mUpnT06DcWq8dh1OyDFkSnW0wew?=
 =?us-ascii?Q?Ih5XPtLhhEfGcZaxV06LqJF9ZSZQtN2Jn+jb0n1CQhUtL24nl1RJOO2NphL+?=
 =?us-ascii?Q?7qut3vYWLAZw7E4tKl4lANb3xtSAxHim7l+8LmfapLYoVbPuGyx8+Dzo6McU?=
 =?us-ascii?Q?kljsfboo6PVrscCX19a3wBAHWxn6lZEmTMwhk2Qa63K04GygA+SPjRski5Lw?=
 =?us-ascii?Q?fa56DGEQD5rm7kR64o8RwY6uzjX8xMSNBV9RctjGmUzSQFVidNukJGWwqsl9?=
 =?us-ascii?Q?1h0O6BehwUwOh9zwczBWG9RJVM3ADsc3A120HqgYl+SRvk1cdcL2TqrNTyyj?=
 =?us-ascii?Q?ZbiU3CQYeqwwvdUEexxyIGQVwNAzAw6a64a9hCVe2CnDXcAcQdA6dfw54YbV?=
 =?us-ascii?Q?fW0BvPzUbokD5UZjQX2LxDe0cZhYNwqpCLjnU7Y7vTJ8amEL8EqbCkMv9Jra?=
 =?us-ascii?Q?qzAoFCzgRpMh1DPOAMhu+TuG63qDjYxkdF/0O6OOJGGS5Yf6bg87e6xEHCoM?=
 =?us-ascii?Q?bdUyr5O6nP0BSQXTpDZXrXvi/Q6VdGR5P3fwVVRaF4oatMWUvbJwunA/4Zap?=
 =?us-ascii?Q?KkHU7cpVSzFPRTKoD9pjTkIak+fA/QHa56mIGx+wjeeTcBoCdZ3HM4S7WDFN?=
 =?us-ascii?Q?IZN2NyWGmxOTniYk1BbHB9aKIfh97zKADbCfjL5Npfe0YRRH/rmOZEw9ARth?=
 =?us-ascii?Q?2+DU76PlzduvOuQCLFQ57hRiV3W3aPHFrECBsQR50nDxZTK963D58zFE+OD0?=
 =?us-ascii?Q?ePAoWmcyTBsTJgJN9nR7GGZofAoDdRkzo6B2xMvRcIkD4UsTmat4WofhMpJR?=
 =?us-ascii?Q?ZpG7TELggd3OaQRyn7yCkzd/PGwM7Fp5g52ROun96IW4uX58/qAYk7C8iiDz?=
 =?us-ascii?Q?+B2PLG8L4S5Zc/ZmYgg9up+Y5B24H+fkCe7ya5+Qn6F2+bLcwBBF/WU4Mzx7?=
 =?us-ascii?Q?nbn0yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d40f6213-3f13-4191-1227-08d9c4cf038b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 22:12:44.4928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y11VOeVzI4bcvFOdLCnqiekMXv44hNDie2u57xKQWD9iyQ58t1ysxKLDZsNQ41wfxn0Q9s0FShg4zmZYoYcsZf8Vhp4cNCxV3wD/uUzvJ1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5090
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Monday, December 20, 2021 2:51 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClocks
>=20
> On Wed, Dec 15, 2021 at 12:13:47PM +0000, Machnikowski, Maciej wrote:
> > > -----Original Message-----
> > > From: Ido Schimmel <idosch@idosch.org>
> > > Sent: Sunday, December 12, 2021 12:48 PM
> > > To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> > > Subject: Re: [PATCH v5 net-next 0/4] Add ethtool interface for RClock=
s
> > >
> > > On Fri, Dec 10, 2021 at 02:45:46PM +0100, Maciej Machnikowski wrote:
> > > > Synchronous Ethernet networks use a physical layer clock to syntoni=
ze
> > > > the frequency across different network elements.
> > > >
> > > > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > > > Equipment Clock (EEC) and have the ability to synchronize to refere=
nce
> > > > frequency sources.
> > > >
> > > > This patch series is a prerequisite for EEC object and adds ability
> > > > to enable recovered clocks in the physical layer of the netdev obje=
ct.
> > > > Recovered clocks can be used as one of the reference signal by the =
EEC.
> > >
> > > The dependency is the other way around. It doesn't make sense to add
> > > APIs to configure the inputs of an object that doesn't exist. First a=
dd
> > > the EEC object, then we can talk about APIs to configure its inputs f=
rom
> > > netdevs.
> >
> > This API configures frequency outputs of the PTY layer of
> > a PHY/integrated MAC. It does not configure any inputs nor it interacts
> > with the EEC. The goal of it is to expose the clock to the piece that
> > requires it as a reference one (a DPLL/FPGA/anything else).
>=20
> My fundamental issue with these patches is that instead of abstracting
> the hardware from user space they give user space direct control over
> it.

Unfortunately, I don't see any other way to address the use cases that I li=
sted
otherwise. I'm a big fan of simple solutions, but only when they address
all use cases that are known at the time of defining them.

> This approach has the advantage of keeping the kernel relatively simple
> and fitting more use cases than just EEC, but these are also its
> disadvantages. Complexity needs to live somewhere and if this complexity
> is related to the abstraction of hardware, then it should live in the
> kernel and not in user space. We should strive to come up with an API
> that does the same thing regardless of the underlying hardware
> implementation.
>=20
> Look at the proposed API, it basically says "Make the clock recovered
> from eth0 available on pin 1". If user space issues this command on
> different systems, it will mean different things, based on the
> underlying design of the hardware and the connection of the pin: To
> "DPLL/FPGA/anything else".

The link to the right DPLL input can be easily added later by adding
the new attribute to those commands. This has a big advantage
over the other model, as it is scalable to multiple different devices
serviced by different drivers, as it doesn't have the issue we have with
linking objects in kernel...

> Contrast that with an API that says "Set the source of EEC X to the
> clock recovered from eth0". This API is well defined and does the same
> thing across different systems.
>=20
> Lets assume that these patches are merged as-is and tomorrow we get
> another implementation of these two ethtool operations in a different
> driver. We can't tell if these are used to feed the recovered clock into
> an EEC like ice does or enable some other use case that we never
> intended to enable.

...that issue is caused by the randomness and scalability of that=20
infrastructure. At the time system boots it enumerates devices and
initializes them in  "random" order depending on the current system=20
configuration which makes it impossible to code any co-driver=20
dependencies, as it's impossible to guess what identifier the kernel
assigned to the other device that's connected to the same DPLL.

> Even if all the implementations use this API to feed the EEC, consider
> how difficult it is going to be for user space to use it. Ideally, user
> space should be able to query the state of the EEC and its source via an
> EEC object in a single command. With the current approach in which we
> have some amorphic object called "DPLL" that is only aware of pins and
> not netdevs, it's going to be very hard. User space will see that the
> DPLL is locked to the clock fed via pin 1. How user space is supposed to
> understand what is the source of this clock? Issue RCLK_GET dump and
> check for matching pin index that is enabled? User space has no reason
> to do it given that it doesn't even know that the source is a netdev.

Userspace tool will always know what ports it works with - it will come
from the config file, as - even if you have a dozen ports linked to a singl=
e
DPLL you may decide that you don't want to send ESMC messages
on some of them - just like we do with ptp4l.

The amorphic DPLL device has much more uses that a dedicated EEC
object and if we know what pin the DPLL uses and what is the link
between the RCLK output and the DPLL input it'll be very easy to
figure out what's going on.

The dump will also not be needed, as we know who we set as the best
source after receiving the ESMC packets from neighbors.

> >
> > I don't agree with the statement that we must have EEC object first,
> > as we can already configure different frequency sources using different
> > subsystems.
>=20
> Regardless of all the above technical arguments, I think that these
> patches should not be merged now based on common sense alone. Not only
> these patches are of very limited use without an EEC object, they also
> prevent us from making changes to the API when such an object is
> introduced.

And I see a big value of merging them in as that would enable upstreaming
of the userspace tools that will explain a lot and close many gaps.

> > The source of signal should be separated from its consumer.
>=20
> If it is completely separated (despite being hardwired on the board),
> then user space does not know how the signal is used when it issues the
> command. Is this signal fed into an EEC that controls that transmission
> rate of other netdev? Is this signal fed into an FPGA that blinks a led?

It's the same thing with frequency pins of the PTP subsystem. Userspace
tool can enable them, but has no idea what's on the other end of them.

> >
> > > With these four patches alone, user space doesn't know how many EECs
> > > there are in the system, it doesn't know the mapping from netdev to E=
EC,
> > > it doesn't know the state of the EEC, it doesn't know which source is
> > > chosen in case more than one source is enabled. Patch #3 tries to wor=
k
> > > around it by having ice print to kernel log, when the information sho=
uld
> > > really be exposed via the EEC object.
> >
> > The goal of them is to add API for recovered clocks - not for EECs.
>=20
> What do you mean by "not for EECs"? The file is called
> "net/ethtool/synce.c", if the signal is not being fed into an EEC then
> into what? It is unclear what kind of back doors this API will open.

Can be a DPLL of the radio part of the device, or different devices that
expects frequency reference.
If it makes it better we can move that to net/ethtool/rclk.c.

> > This part is there for observability and will still be there when EEC
> > is in place.  Those will need to be addressed by the DPLL subsystem.
>=20
> If it is it only meant for observability, then why these messages are
> emitted as warnings to the kernel log? Regardless, the user API should
> be designed with observability in mind so that you wouldn't need to rely
> on prints to the kernel log.

You're right - need to change that to dev_info.
And yes - in the final form userspace tools will pull EEC's info from the D=
PLL
subsystem - this prints the state of 2 DPLLs and is designed for debuggabil=
ity.

> >
> > > +		dev_warn(ice_pf_to_dev(pf),
> > > +			 "<DPLL%i> state changed to: %d, pin %d",
> > > +			 ICE_CGU_DPLL_SYNCE,
> > > +			 pf->synce_dpll_state,
> > > +			 pin);
> > >
> > > >
> > > > Further work is required to add the DPLL subsystem, link it to the
> > > > netdev object and create API to read the EEC DPLL state.
> > >
> > > When the EEC object materializes, we might find out that this API nee=
ds
> > > to be changed / reworked / removed, but we won't be able to do that
> > > given it's uAPI. I don't know where the confidence that it won't happ=
en
> > > stems from when there are so many question marks around this new
> > > object.
> >
> > This API follows the functionality of other frequency outputs that exis=
t
> > in the kernel, like PTP period file for frequency output of PTP clock
> > or other GPIOs. I highly doubt it'll change - we may extend it to add
> mapping
> > between pins, but like I indicated - this will not always be known to S=
W.
> >
> > Regards
> > Maciek
