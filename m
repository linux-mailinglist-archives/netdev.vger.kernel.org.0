Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF81347F994
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 01:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234875AbhL0Aka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 19:40:30 -0500
Received: from mga12.intel.com ([192.55.52.136]:49628 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232840AbhL0Ak3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Dec 2021 19:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640565629; x=1672101629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rtf511deUNiyLGe5PKYvf++20n8kBaL/AXzkX7Rwy8o=;
  b=hkyxchbEL6Y+9a3wDGr4ISg3VQ8tufTukPQYAr8J1+9Qq+M7WS1CzGaQ
   Q2q2YJdaGE3Ruc0WM+JfqKoQItBw+fK4skxUotcJcykxuaXE2qHYgCKn+
   +iawyEbZXrOd6GIHaBoi7e+v5NK/47h4eMl0T5TfVinoBK79g/zlkWXjW
   dYlhXjMjLxNCG0Jc8WuzwNERR7Muc9aUYhYoO4qsSzal+Cuvr9Q05am0x
   PWdhTg3ako4zOt2R4P9C7+vOJhlRQPJDwGYh5a3Eg9Jecw5kQX7p0SF1x
   aDW2m8yOYT6hKKHclOhlxWwsZ9Zu2/MDyC/ex2GiTbrPkA+uZqUDSpWF5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10209"; a="221146540"
X-IronPort-AV: E=Sophos;i="5.88,238,1635231600"; 
   d="scan'208";a="221146540"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2021 16:40:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,238,1635231600"; 
   d="scan'208";a="758245333"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 26 Dec 2021 16:40:28 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 26 Dec 2021 16:40:28 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 26 Dec 2021 16:40:28 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Sun, 26 Dec 2021 16:40:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hdBl7xFBpxNtgtcmk7JzK7aV14UWERD9Z37k2W2iRNqrTewRXNyjFwDW/l5Qd/h2PvjKkNAaQapYN1SnnIDeE2MzmIFgfnqkLeEqBS7RSwmdx8GJ9v1jjvjajBcXYOOiDD6/rOw/6yjoVj5Ab/QQx8NT6TqPAj5eNrCA/Uk3O9nKwTKKMi8mLq1Jksihaxvqrw8XUItVy/s2wUI+K5PGGNPdmkel6ez8lPkvnedbgrSf9Suz050Fj4sJbj67fNxuXWFo7RUkE6TieP/OYnHqhWK1ykVGl+rq3JgLBywTH1Srwc0d7ZASYeRyrjhxEFZ0GZI8ehXm0bnjHv/GfJL2yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rtf511deUNiyLGe5PKYvf++20n8kBaL/AXzkX7Rwy8o=;
 b=b5kDlJxmXF7Ie4rvsAbeyu5gsxePKM4+VTLyW5UTHnypl4JK714wm6HvV8GsU4QA/ki8LiHRp1JGFQoxaeWO9eRfR/JcbwvTZjjtjpbi5rbybSk9lslPMZFcID8islje0GocLFKxpaYSPzjc1uuzcsQ6g6Oo5rfLHF6V8CGIHtQW2DsBZhF+ZIs1SN/z8KxyeFW6AsiWQ+CnEzHNTG8DVjR3932c4fbnpbVy2scrXlpVFWr/UEDaQYGzbOmyeUE2uQF0OYrRjekocn9uZf+8rxYtzeUKMTE3LJ1J1eVeeC/M48tLlIH7HBu+UNacOY8QebH0jbLrYyItzlEpvixrXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR11MB1983.namprd11.prod.outlook.com (2603:10b6:300:112::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 00:40:26 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%7]) with mapi id 15.20.4823.022; Mon, 27 Dec 2021
 00:40:26 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Topic: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8tNAAgACRSSCAADPkgIAABxaggAGHswCAAHiSsIAAYEmAgAWg+WA=
Date:   Mon, 27 Dec 2021 00:40:26 +0000
Message-ID: <CO1PR11MB51700B59B074DF5F0E9364ADD9429@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcGkILZxGLEUVVgU@lunn.ch>
 <CO1PR11MB51705AE8B072576F31FEC18CD97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcJJh9e2QCJOoEB/@lunn.ch>
 <CO1PR11MB5170C1925DFB4BFE4B7819F5D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcOYDi1s5x5gU/5w@lunn.ch>
 <CO1PR11MB5170B7667FD1C091E1946CEDD97E9@CO1PR11MB5170.namprd11.prod.outlook.com>
 <YcRN9zwkP4nw4Dh8@lunn.ch>
In-Reply-To: <YcRN9zwkP4nw4Dh8@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87faebae-b893-4821-e928-08d9c8d179b7
x-ms-traffictypediagnostic: MWHPR11MB1983:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR11MB198386570F9AB26A575170CBD9429@MWHPR11MB1983.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U6RqcGx7x7hlM84zQb2r57eyRGVOGK2sKrPfIkymxF6q0vt+YnV00+bz3mCexDJG10AecF1vZ8n/Q36Rl7InvvaNkiCxYddYGCqy5oAc2h+LcaEqZU1IpbWEtqy/xFJEWe+7CCOE1BqQ5VkQSlOb5ornfKh4WzR514f5Fs0wAhIVt3H3HQQcECLEriUFZS6EszqLu0j1GbpFXsjQ9lMIaN/whylsW4Liv0wFR/dyj6CuqRqxHB8PTzO7dWyrt72NmFO/vzibjEH0Tsftu+hiKfzDsI0kuKNkeCeUkf9TymeKM6StHoJBNEdZaDFP14g8+B549gM4dhMCLgpeCYyTFcg+Jo+7Viet4wMWMN/dLVk/3WXcHJzo0NuCM9Plk3k+eyEA4YWN6kqY6uI6RxznHsW90uKPSfwXh7YBjAyvfp3LgEZrDEWGQ31LXBI9GGLj8ncDSTq3+dcUfJsWqotXyZtk2MifpOxco3fCP1+pXaMljJJLOr2qVEhdFr9D2QDXMbuq3FJCYzWwrIpkUz/PnWymWYGfHbB8S+c2ZzzdBYIxSahUgF+cWXIpOhJfog/fiJeg+waqrPidto7jI8UKzCCDyBKxJ1jw6m0fUKFCBL5fo1csEe2lngXMAzQNRFm5oOUVMVmTQyg6TmH65gT9QpK6pq4+QVHwcSZ8J/Kx6ADVZxs3yxmZOamto0JZSmIc77l3IVLx12JVVEoCl1wZxLop1a0JSk19fALeI6PHfO5CT6WWPYru0/N5N9J2IhgPhVx5poHY8GIKDw9mC8OAjoj9eDdGMi6OMdOVcJ5caEQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(55016003)(186003)(7696005)(508600001)(4326008)(5660300002)(6506007)(53546011)(71200400001)(26005)(38070700005)(966005)(122000001)(8676002)(9686003)(38100700002)(316002)(6916009)(76116006)(8936002)(86362001)(66946007)(66556008)(64756008)(66446008)(66476007)(82960400001)(83380400001)(54906003)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jnpneDo76B0mrYSDS2Ih6NoS4WK1sXEHPVrxq1liiTvfIkGjcwbftP77A+xY?=
 =?us-ascii?Q?pUuJ2OwqRX0DMhZ6RAiTQf2GlgcnkD4DOcPVzYYX9Hcgdr3neNcEZPerTimO?=
 =?us-ascii?Q?GVhHs3abtGjXPPoYfa1mHKAVHsstFMKAOIEFGzUnIXq5OHCZHeJA8Hf9uf6m?=
 =?us-ascii?Q?xzzUyWCoO4LT7VvDWb/DJuNjH+kcNQyrIV/gWfuRHX1AqxjnQOyLwXwHv1wZ?=
 =?us-ascii?Q?Zd/1I8mP7GvqR1f48zLWyNh1e1aOKBhkTRZdbBHCsCUvKyaiT0RrReEJayIT?=
 =?us-ascii?Q?0AnD/wUGzZeBziHeRSOKfQAJU+5/GrCHf7M+2HsWL+CF/KnXoRG/MeNfroPt?=
 =?us-ascii?Q?Yu5S8ClDpgocazjJdfuUEAzj+iW/280v3Juo0u0YuZWLeZgQ6LK98qM8rlC7?=
 =?us-ascii?Q?qfpSRwHOYYQYjZW6VqqXjSBw/3JGKir7J4uevwuWbw6qmgAWSuccxz2W9Jq3?=
 =?us-ascii?Q?UMcTTni42oVzW0UFXwzobr3TiIgkosR/WaE3fa8Sc3tEhjsPl0lz4aCl5RMw?=
 =?us-ascii?Q?SnpQbmBEND/m1FYdk/y/jMFDH40bY0PONfk/gRbxEilDqEjblqxamxZoehPv?=
 =?us-ascii?Q?EK3ILgVOapp4NQEUeFrolOAagu6mcdqQQUbZzUdklvF69/LdTgrB5zJLbKte?=
 =?us-ascii?Q?qpPqnBASJwJNPkBjr6zqOTq+lChIQE8kRKcB6rE9sKRqeh/G6TDU3VBlVs/i?=
 =?us-ascii?Q?pidaCMwW/XfYhir/bLgv8L/0atV9JAJWfwgkskcj0QbHX2EUgP7yLk1/E+vW?=
 =?us-ascii?Q?lQFbLrHjurBCqPzAHpbKL+LJ86pa1UpM+TdmbpmqM1bsfSrVZqBeZGBf0Yb6?=
 =?us-ascii?Q?mK2qS4esr+xXaK8vpxLdFnZqoBIHk8uF2kghqrvbnP761qrzaKP7BzivjTnh?=
 =?us-ascii?Q?hnV4Dfv3HUkW3CgQDOAUh2VR5b34GKbpICdm9WOpqk+vgTzsGHqArR1PSMJg?=
 =?us-ascii?Q?L/wpnsi6Rtp98TmVOEIhs8srqBwmeNEXHz1kTtdSqwSEOAksKSq/+//bdveo?=
 =?us-ascii?Q?Bz2DogvgpN4zImynQE1zWujgQfVS/ZoXhh/zNoyWAhvHDdseSZqFMKF8TFOJ?=
 =?us-ascii?Q?Q32hn6OCMIg4cehZ51Gm11SoofwNGmecmVhxSMxmcHA4Zr2e/WlKfRtMnWmU?=
 =?us-ascii?Q?go2N3qNO+nswI0OaKkD4TIt6RyrhfZDd+r39YbOMcUuUTdx9dk85krFJz5yC?=
 =?us-ascii?Q?kS8O2ZnDy6e7UJFBv9qNVUu6/D1ThxshpD7dRcNqJaISKTU7eu+PBE/YuJ+G?=
 =?us-ascii?Q?Xv74Ih48ZMY1oNBWcOqJWegewDKkT63FIxKF/hRFrSDjLVLFLadGe4XHH9JY?=
 =?us-ascii?Q?0QZEortML4S1puTsFA+hi+EJBgwng8IzFRVOn38XDuKihaiexCYJut1Bi7hi?=
 =?us-ascii?Q?v+ALdfSy1Zm5VdHe9uH0cuiq1td0Ehv01MUlQT2t5IrliyDVhiOPKP1qKkOs?=
 =?us-ascii?Q?T/ThDUre6clbxNyGoil9ZgIp5iuNA/5hAh84li/uqb7jB14obC9qISPXhC1g?=
 =?us-ascii?Q?DtuJ+scDyqefCvdQvggAa08d80gfNdD5C+R+3quHzA2r1V0WoLsx6MNfp2BL?=
 =?us-ascii?Q?rkdm+cMErR3bu44EnLrn/NHcJka5vZhEFe0z8pG+s15yWSRdPI/caOm+1Ncx?=
 =?us-ascii?Q?uWOFJ3NAUUOV0kal9vqAR8xfQlinDjor9RVTjfWEj/OupOzuA4W6lx8ms5fB?=
 =?us-ascii?Q?c6ZpIQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87faebae-b893-4821-e928-08d9c8d179b7
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2021 00:40:26.4047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aEXFCU+lFdMn96EYjfUB+T3N/ARPrhpfK0Z1IPUHJXLMRk4/hJx8RF1bS2BmV6m7ymm2jzzKb1J2PVuSi/k0ML5P0C4DxZ3JRttSDn8nMJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1983
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Thursday, December 23, 2021 5:23 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; gregkh@linuxfoundation.o=
rg; Williams, Dan J
> <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com; netdev@=
vger.kernel.org;
> davem@davemloft.net; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
>=20
> On Thu, Dec 23, 2021 at 05:15:34AM +0000, Chen, Mike Ximing wrote:
> >
> >
> > > -----Original Message-----
> > > From: Andrew Lunn <andrew@lunn.ch>
> > > Sent: Wednesday, December 22, 2021 4:27 PM
> > > To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> > > Cc: linux-kernel@vger.kernel.org; arnd@arndb.de;
> > > gregkh@linuxfoundation.org; Williams, Dan J
> > > <dan.j.williams@intel.com>; pierre-louis.bossart@linux.intel.com;
> > > netdev@vger.kernel.org; davem@davemloft.net; kuba@kernel.org
> > > Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
> > >
> > > > > pointing to skbufs? How are the lifetimes of skbufs managed? How
> > > > > do you get skbufs out of the NIC? Are you using XDP?
> > > >
> > > > This is not a network accelerator in the sense that it does not
> > > > have direct access to the network sockets/ports. We do not use XDP.
> > >
> > > So not using XDP is a problem. I looked at previous versions of this
> > > patch, and it is all DPDK. But DPDK is not in mainline, XDP is. In or=
der for this to be merged into
> mainline you need a mainline user of it.
> > >
> > > Maybe you should abandon mainline, and just get this driver merged in=
to the DPDK fork of Linux?
> > >
> > Hi Andrew,
> >
> > I am not sure why not using XDP is a problem. As mentioned earlier,
> > the DLB driver is not a part of network stack.
> >
> > DPDK is one of applications that can make a good use of DLB, but is
> > not the only one. We have applications that access DLB directly via
> > the kernel driver API without using DPDK.
>=20
> Cool. Please can you point at a repo for the code? As i said, we just nee=
d a userspace user, which gives us
> a good idea how the hardware is supposed to be used, how the kAPI is to b=
e used, and act as a good test
> case for when kernel modifications are made. But it needs to be pure main=
line.
>=20
> There have been a few good discussion on LWN about accelerators recently.=
 Worth reading.
>=20
We don't have a public repo for dlb yet, but you can download the dlb=20
software package at https://www.intel.com/content/www/us/en/download/686372=
/intel-dynamic-load-balancer.html.
It includes dlb kernel driver and sample user applications (for both
DPDK and non-DPDK users).

I will check out the discussion on LWN.
Thanks for the suggestion.

Mike
