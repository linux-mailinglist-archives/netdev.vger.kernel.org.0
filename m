Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC9928695E
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgJGUqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:46:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:31676 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbgJGUqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:46:53 -0400
IronPort-SDR: 1MYeXasLjbAVIzHMcInBI3kCsgupVbtBUGbVVzUBfv8gpS0cIPivGRFGNGqrZiP5sZ51x4iyj6
 ItfioxRveWUw==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="164349173"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="164349173"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 13:46:53 -0700
IronPort-SDR: pl7TbxISjdh5vIGS/UOFAgtXfNLOcxMAD9auXmFgjcGA8tUR+wxLmU7fqPhDy/adWdB1BqDYu2
 IAYS/drSBFbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="355086793"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 07 Oct 2020 13:46:52 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 13:46:52 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 13:46:51 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Oct 2020 13:46:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 7 Oct 2020 13:46:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZY6hjO7S6UMYhxk/v+1qfEhHn4nE0xHTdcjh4vMpxlJHUGrUCktWglbG5FUZIYeFYIi58KYvh8tWE1DcUn03NmBJgFmyd7U5kOC9qBlVjoB3TXyiJ051f7rAk8Fv9WeKiRJqdvkFvC4sd/OQ/EkMYZYl4dVWi3Gs8ut3RaW+x0A7DHZ747jbinkG4rez6vf0NSS9qQN9ELZgFttYHr5Bx/YrnVnl0BzDW04nf2x7W5KOEYs/wcSekQggwsQ5+IWzrbzYLZmxzJXoK+8ca3NWRfJkE4dd2KgGjziEUP3R0ZHdwwKDcXwM0EojXsjFuHa1OW2FHmWg885rYOoYzci0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdmJvc3IBeti00X6tQWhBaeVcxl3tlVNsPXgAk1j8zE=;
 b=Ujl348hF8a+kpG6RdESLDt7EBkBSpXrQHIcsjIEGthPRlKCbbdFnvlwvBWRX4xa1e0KstEIy50Abe6pL2tsozmF2y/ggOqRbFOTxiZs05/EQR5OawPDJ4mwyqzxcvI5+izg2eMLj/Oo9S88g02lmBgbLjcpc9tNoM96KY2d8uS/XC8gHascwq/gwuSubUsD3eSs9G1jehYIVHvQlJhAJyZgO9Fhhmhv/+nBztw34BQbmR77LGWWrUDtiEbOfHHaiFezwZ4ngF6vzTWTnL+mnC7k5hRDhngv9rKZmMKfUIjQI/g5hOH9nLKWmv78T4qk7+sQ1iyqmuPMD2d7VwFvHEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sdmJvc3IBeti00X6tQWhBaeVcxl3tlVNsPXgAk1j8zE=;
 b=MuYj+hQIba3uG8WjrItXSlWwdCqrptuh6w+s8KoNLp0CIl82OQWJ8Vp0eHpBwQQ/e1YlmF6BdxhGA7EvX9VGagj3keD0sL/dbC64k1cKx7D3lSV3PxynOoMib526llIwtOUrj49jxxoqHPQ4EKtL5GrMbL/5ZiRBFWqG5RuLR3Y=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM5PR11MB1595.namprd11.prod.outlook.com (2603:10b6:4:c::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.23; Wed, 7 Oct 2020 20:46:45 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 20:46:45 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Parav Pandit <parav@nvidia.com>, Leon Romanovsky <leon@kernel.org>
CC:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAA5GgIAABE1g
Date:   Wed, 7 Oct 2020 20:46:45 +0000
Message-ID: <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2abfaee4-8d82-4ddf-d533-08d86b021a8b
x-ms-traffictypediagnostic: DM5PR11MB1595:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1595C2A1B5D135CD74CD2F0EDD0A0@DM5PR11MB1595.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XIs2NoDN64SRMG3T4AmmqlZGCJwR+xD11p78RENEd8SHfgWxbyIBWIYR7rolImwjECTXeLndx+SA7MEUBvtKpT8PtV6AjtAnxOqhA7q8Egy2l37bC4SXvERX6WoUceUJfBWuZZkIOhrgRGFte3TLBXSgeAuU4fYCBJDRrkcGr9BlN2QkHpTjY2D4B3ge89gQ3NuOrrOWWJEDj7QpcOFCKar/nHBDfkbCqbQWlmXvmIMjX9zTqwYCxqM9bLRM7N6Ifd2beDrusoCaHFhDiJHsvsmywS+0Ox/+tGpxEAMAQL0TmZ6RYR59qjysb+A3/FNlMb3IPKPhsiFnPscDY29oDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(366004)(39860400002)(6506007)(53546011)(7416002)(7696005)(52536014)(316002)(4326008)(54906003)(9686003)(110136005)(71200400001)(83380400001)(86362001)(55016002)(478600001)(33656002)(66946007)(76116006)(66556008)(66446008)(66476007)(26005)(64756008)(186003)(2906002)(8676002)(8936002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: X6Jz70mQQR/DeBDDy2tOADaSifdVFmTmVj7wtvIMUmUMoC24xbtM35ehLJaexKaMjKVxpIoL0/X9jPHdZ4Z6zdMCTgjSQFvcFNFb3Cu9dJmRL5nRY7pAixa/Lyl5WIlP3Vrgvae8I+dpkOQ0CR9N7MGmm6xkCxFbLX+0geXIiOA8jg3EeNVWFqg5RBXyxhVvqEtWzt5lPQmUqwKqYFy3NLSiQDIAyTld834J7SGfU3TnetaTeCnG5A5aeK4YPLd2vfceF0qO0c87mkwZetjGm6D+ZdoboFGVSfTC4fT8uixLf9K+S9kSxtbrhqJSWS0c0l2L3Xv+DWZFUz5Ilrhindb60OyDGTUNCeBNZpP9XF4E/2UQsqmYtsSGUHNTYwdYoy/A4cZZLdlWcxlwLsGDUHX62dQFBAilSIMrO5TPzFhlQt0IOCQmbtxS2Z1FfNwOZbKaDLIbOdbLUeGsbWjQpxUjQtz0wpY1JpZFeL63yxUAj2JZpAENHGKkndzkAdCxCXAqSDa1zRodydg/azzcS7+lwZ8GVU8YZZxtiLwRb8E7U826BWxfgECQnMgoe1iOa/3GiGueVNu51OREMeiWiZegFEjnkvUtg9n5EEavw4CFXg3qsUxcv/0Ufn9zNqV8j7Hr4dGYo5GGkf9lAx3C2w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2abfaee4-8d82-4ddf-d533-08d86b021a8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 20:46:45.1104
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AqctHz3Qv846IvsxdovbsBnJhLibXaSep4eguJK4iSvWp7MtEw2qhQY8y5/uBivi4MZt8+vn7WhKZKKUdvMCd6FIqdZJp6AVQl12m5u+NFs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1595
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Parav Pandit <parav@nvidia.com>
> Sent: Wednesday, October 7, 2020 1:17 PM
> To: Leon Romanovsky <leon@kernel.org>; Ertman, David M
> <david.m.ertman@intel.com>
> Cc: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>; alsa-
> devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com;
> fred.oh@linux.intel.com; linux-rdma@vger.kernel.org;
> dledford@redhat.com; broonie@kernel.org; Jason Gunthorpe
> <jgg@nvidia.com>; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: RE: [PATCH v2 1/6] Add ancillary bus support
>=20
>=20
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Thursday, October 8, 2020 12:56 AM
> >
> > > > This API is partially obscures low level driver-core code and needs
> > > > to provide clear and proper abstractions without need to remember
> > > > about put_device. There is already _add() interface why don't you d=
o
> > > > put_device() in it?
> > > >
> > >
> > > The pushback Pierre is referring to was during our mid-tier internal
> > > review.  It was primarily a concern of Parav as I recall, so he can s=
peak to
> his
> > reasoning.
> > >
> > > What we originally had was a single API call
> > > (ancillary_device_register) that started with a call to
> > > device_initialize(), and every error path out of the function perform=
ed a
> > put_device().
> > >
> > > Is this the model you have in mind?
> >
> > I don't like this flow:
> > ancillary_device_initialize()
> > if (ancillary_ancillary_device_add()) {
> >   put_device(....)
> >   ancillary_device_unregister()
> Calling device_unregister() is incorrect, because add() wasn't successful=
.
> Only put_device() or a wrapper ancillary_device_put() is necessary.
>=20
> >   return err;
> > }
> >
> > And prefer this flow:
> > ancillary_device_initialize()
> > if (ancillary_device_add()) {
> >   ancillary_device_unregister()
> This is incorrect and a clear deviation from the current core APIs that a=
dds the
> confusion.
>=20
> >   return err;
> > }
> >
> > In this way, the ancillary users won't need to do non-intuitive put_dev=
ice();
>=20
> Below is most simple, intuitive and matching with core APIs for name and
> design pattern wise.
> init()
> {
> 	err =3D ancillary_device_initialize();
> 	if (err)
> 		return ret;
>=20
> 	err =3D ancillary_device_add();
> 	if (ret)
> 		goto err_unwind;
>=20
> 	err =3D some_foo();
> 	if (err)
> 		goto err_foo;
> 	return 0;
>=20
> err_foo:
> 	ancillary_device_del(adev);
> err_unwind:
> 	ancillary_device_put(adev->dev);
> 	return err;
> }
>=20
> cleanup()
> {
> 	ancillary_device_de(adev);
> 	ancillary_device_put(adev);
> 	/* It is common to have a one wrapper for this as
> ancillary_device_unregister().
> 	 * This will match with core device_unregister() that has precise
> documentation.
> 	 * but given fact that init() code need proper error unwinding, like
> above,
> 	 * it make sense to have two APIs, and no need to export another
> symbol for unregister().
> 	 * This pattern is very easy to audit and code.
> 	 */
> }

I like this flow +1

But ... since the init() function is performing both device_init and
device_add - it should probably be called ancillary_device_register,=20
and we are back to a single exported API for both register and
unregister.

At that point, do we need wrappers on the primitives init, add, del,
and put?

-DaveE
