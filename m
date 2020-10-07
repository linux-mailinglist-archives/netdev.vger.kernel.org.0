Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BA32868B2
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 21:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgJGT5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 15:57:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:24741 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgJGT5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 15:57:15 -0400
IronPort-SDR: BymAXrmm/KKFyzPKLf5RvlyeryHZKdvmd1utexUHsiOaZ5jmi2e6VNo/CX9A2URD7xLQFVbxWY
 sCUwGAxavg7g==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="164327549"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="164327549"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 12:57:14 -0700
IronPort-SDR: 4u8WFIsey+WI9f0frCvboHRwEoZKDCyiE+6QWoGzaoJUqKr6OTMRGPCIAWyId892gNbMWLQ1Vp
 CsbtUKTtDfSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="297744863"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga008.fm.intel.com with ESMTP; 07 Oct 2020 12:57:14 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 12:57:13 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 7 Oct 2020 12:57:13 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 7 Oct 2020 12:57:13 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 7 Oct 2020 12:57:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eG9SgXSiN6gDcuXmemj3Bj0nUBJcORsjBwlPi3iKvKBKqeLW0KI09WUQdK1drs2cgG4pbQ6yVA3ly/RAFf39/R7br1ZQCBxnm3F2HBlSQmErmsBjAd+eSCz2M5YJ0lLeFcZOGmhA8zFVOMX8/xwTXnyJOde0KfYMd7AhmjigIw/s/z1gOnFWQm7Xl+GCIhf74SelrfFQqObfpPp/0gHkmDCv5T40v8mEPgoQ1lcP3/YfRCx2Y3hyjUs5ey0g/DP1MX52i5uze08pcq97ew9NaIIhb/8NTspUZ7p05pCc0eMb2wyadynE4BkvmbPfvene4Z5QeZvyDkNdn/EFj4FRog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ETy33kRYnfV6ANBCzs6Jkw3BJl601FlBm1kJQkhqcI=;
 b=dSPZwE962xEH7QEsCcf9+RXpGkzqNph7/tAve4N7x6n2Csy65M1RaOpp/5SuGEkiKB5NkyNOpysXwf60H5ics2TneHWPq2dtnHcLOuThYZVYCau8fttn1ilFsMobVjTOi9tQfSw9BjF1G+CUbVufxuWw4eB6HdbRvJnB2r+QkTzag5kqJaDGBc0w5Z6CtCOo5U9BvmOqfMLEIwz9aixboDsrtjopsqUNyjYiwyielocgqlpDgqE4Ey01SIPxICO9iq4BfcMV3zeXKWjdqVBqDKVwqhcaggYUJZYM06wLuwflaq8Xdyiex4+TXMZBCCMgiqN7zudsMt4I13W6EsOWKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7ETy33kRYnfV6ANBCzs6Jkw3BJl601FlBm1kJQkhqcI=;
 b=HHJHRFdZ0LHfW71EMCUnAdJijrlEnlQm7mkzJA5nscT0NrrICphhtohcoAZPf0RanofS/astevC54dEaW2oJRq9JULrH6McvUylql4t99LXdbEWd8IPzXNXVHRZNjFpqeLXqRDz4vCVm7zDj5JrvxG3ZMevUOuUxB1UfOG+5rv4=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM6PR11MB2875.namprd11.prod.outlook.com (2603:10b6:5:cc::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.35; Wed, 7 Oct 2020 19:57:05 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.044; Wed, 7 Oct 2020
 19:57:05 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAAc1oIAAAO1A
Date:   Wed, 7 Oct 2020 19:57:05 +0000
Message-ID: <DM6PR11MB284118B518949C844F81BD72DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <DM6PR11MB2841EBB5C27A947789F9DB73DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
In-Reply-To: <DM6PR11MB2841EBB5C27A947789F9DB73DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.47.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f081094-8263-483f-48f8-08d86afb2abf
x-ms-traffictypediagnostic: DM6PR11MB2875:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB28750DFDD0603F760970406CDD0A0@DM6PR11MB2875.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pe8WXTRebxQDlL/J2QrDPh7Q3Pf2gImH50wAnTEyEK7F12/QuTov0f2tpmKKZJBCK+PmGDGBWrJf8s4HusZCIGaXMiwCVA/7XxilBoUZaO49Kcj5Ep3fUS3kQYXlYO3YlQNbz8SkQfojYwZNnJ1vqLeCm80XVYvPKWffWkErLtUEaKT27QBRzMc+X+LAvdjUzIDizj0G7205JsXv1+G2yJ67/RpWTlQlK1FoLNKw1BAWytLviN3kQP1X/gU+XEhlcxWzy+pX7pjnUvVkrYnzkoSzF7qBIlof6hh2qmHi17ER9JFsVmacGOpxiub3oIfM7mnHuDucCv3wkmu+n42DbQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(39860400002)(376002)(346002)(396003)(71200400001)(86362001)(9686003)(83380400001)(478600001)(33656002)(6916009)(7416002)(8676002)(8936002)(66946007)(7696005)(2906002)(186003)(53546011)(6506007)(55016002)(2940100002)(64756008)(52536014)(26005)(316002)(4326008)(5660300002)(76116006)(66446008)(66476007)(66556008)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YAsO++Y1W6rdAaqnEIIKP0+gzwt7ewVbGmhVhvrgrjqAxijSLWaGTxI+RlzqRcIOj0H4QRfS4tTkrwehaFlszO1WRvop1OJ0wq+XW1TISqwZPnHRpm8YBBwJElAxrqq/d8nHjuiLpn4FjCHngflStD8JtXkRVSf6frfEPmlKVsERFNrlPwCdn/RSntDtGGXbIQ+s1WYGilPZKh1AmeIBHTiup9TrgiXPZB26TNXCYk+FSeW+154Rx+GmMpPRtdITipVP8oeoNgl7RhZ4uDRSwOywnqrlsE2hcw0KvRQ2UlbZQV2ubGl9umWIsM5HdRa0l4d6eVSj9iB0+19lawb0GTdXFqKIp83W78yBzMBHG7Z9bUQ+isFE18rWU1r6X/5aZ7SS/THHJf61jAjSULZESPcwxAMFwjnZ0yw01rOsn/wvHJg0kOqKXeDZQqouyCIpM9fXg+lDoLJe17jgclGINf54qpLz7zCWuBdp95D5r0jshYsVBc/FQkFm9gf5P4oTJ/uqw50HNxXsanfVpQSsNTNijjAJa688OTYdg6bg80hqMdPRYnfi5nbYFhUsbIrjUhnb+oqL59NouKNcr1yBiCAGpeqEYhY8+3bgt8jfUmvQfWpJaVS/ICt57M5MXKt0j4VqKzcbk3NRV/MiXGLsEQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f081094-8263-483f-48f8-08d86afb2abf
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 19:57:05.8340
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gqbP3pXCLTn7voMrNfpgkiViLkjdvSZEgRV4/GjzU3r1Zn32n//S6VmH9vIqKCwlfyPTkwsJzoToQ2Kaf5XT3sL5Wa9A/NzJFUIp8yij32w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2875
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Ertman, David M
> Sent: Wednesday, October 7, 2020 12:54 PM
> To: 'Leon Romanovsky' <leon@kernel.org>
> Cc: alsa-devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com; Pierre-Louis
> Bossart <pierre-louis.bossart@linux.intel.com>; fred.oh@linux.intel.com;
> linux-rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org;
> jgg@nvidia.com; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> <kiran.patil@intel.com>
> Subject: RE: [PATCH v2 1/6] Add ancillary bus support
>=20
> > -----Original Message-----
> > From: Alsa-devel <alsa-devel-bounces@alsa-project.org> On Behalf Of
> Leon
> > Romanovsky
> > Sent: Wednesday, October 7, 2020 12:26 PM
> > To: Ertman, David M <david.m.ertman@intel.com>
> > Cc: alsa-devel@alsa-project.org; parav@mellanox.com; tiwai@suse.de;
> > netdev@vger.kernel.org; ranjani.sridharan@linux.intel.com; Pierre-Louis
> > Bossart <pierre-louis.bossart@linux.intel.com>; fred.oh@linux.intel.com=
;
> > linux-rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org;
> > jgg@nvidia.com; gregkh@linuxfoundation.org; kuba@kernel.org; Williams,
> > Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > <kiran.patil@intel.com>
> > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> >
> > On Wed, Oct 07, 2020 at 06:06:30PM +0000, Ertman, David M wrote:
> > > > -----Original Message-----
> > > > From: Leon Romanovsky <leon@kernel.org>
> > > > Sent: Tuesday, October 6, 2020 10:03 AM
> > > > To: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > > > Cc: Ertman, David M <david.m.ertman@intel.com>; alsa-devel@alsa-
> > > > project.org; parav@mellanox.com; tiwai@suse.de;
> > netdev@vger.kernel.org;
> > > > ranjani.sridharan@linux.intel.com; fred.oh@linux.intel.com; linux-
> > > > rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org;
> > > > jgg@nvidia.com; gregkh@linuxfoundation.org; kuba@kernel.org;
> > Williams,
> > > > Dan J <dan.j.williams@intel.com>; Saleem, Shiraz
> > > > <shiraz.saleem@intel.com>; davem@davemloft.net; Patil, Kiran
> > > > <kiran.patil@intel.com>
> > > > Subject: Re: [PATCH v2 1/6] Add ancillary bus support
> > > >
> > > > On Tue, Oct 06, 2020 at 10:18:07AM -0500, Pierre-Louis Bossart wrot=
e:
> > > > > Thanks for the review Leon.
> > > > >
> > > > > > > Add support for the Ancillary Bus, ancillary_device and
> > ancillary_driver.
> > > > > > > It enables drivers to create an ancillary_device and bind an
> > > > > > > ancillary_driver to it.
> > > > > >
> > > > > > I was under impression that this name is going to be changed.
> > > > >
> > > > > It's part of the opens stated in the cover letter.
> > > >
> > > > ok, so what are the variants?
> > > > system bus (sysbus), sbsystem bus (subbus), crossbus ?
> > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > > > +	const struct my_driver my_drv =3D {
> > > > > > > +		.ancillary_drv =3D {
> > > > > > > +			.driver =3D {
> > > > > > > +				.name =3D "myancillarydrv",
> > > > > >
> > > > > > Why do we need to give control over driver name to the driver
> > authors?
> > > > > > It can be problematic if author puts name that already exists.
> > > > >
> > > > > Good point. When I used the ancillary_devices for my own
> SoundWire
> > test,
> > > > the
> > > > > driver name didn't seem specifically meaningful but needed to be =
set
> to
> > > > > something, what mattered was the id_table. Just thinking aloud,
> maybe
> > we
> > > > can
> > > > > add prefixing with KMOD_BUILD, as we've done already to avoid
> > collisions
> > > > > between device names?
> > > >
> > > > IMHO, it shouldn't be controlled by the drivers at all and need to =
have
> > > > kernel module name hardwired. Users will use it later for various
> > > > bind/unbind/autoprobe tricks and it will give predictability for th=
em.
> > > >
> > > > >
> > > > > [...]
> > > > >
> > > > > > > +int __ancillary_device_add(struct ancillary_device *ancildev=
,
> const
> > > > char *modname)
> > > > > > > +{
> > > > > > > +	struct device *dev =3D &ancildev->dev;
> > > > > > > +	int ret;
> > > > > > > +
> > > > > > > +	if (!modname) {
> > > > > > > +		pr_err("ancillary device modname is NULL\n");
> > > > > > > +		return -EINVAL;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	ret =3D dev_set_name(dev, "%s.%s.%d", modname, ancildev-
> > >name,
> > > > ancildev->id);
> > > > > > > +	if (ret) {
> > > > > > > +		pr_err("ancillary device dev_set_name failed: %d\n",
> > ret);
> > > > > > > +		return ret;
> > > > > > > +	}
> > > > > > > +
> > > > > > > +	ret =3D device_add(dev);
> > > > > > > +	if (ret)
> > > > > > > +		dev_err(dev, "adding ancillary device failed!: %d\n",
> > ret);
> > > > > > > +
> > > > > > > +	return ret;
> > > > > > > +}
> > > > > >
> > > > > > Sorry, but this is very strange API that requires users to put
> > > > > > internal call to "dev" that is buried inside "struct ancillary_=
device".
> > > > > >
> > > > > > For example in your next patch, you write this "put_device(&cde=
v-
> > > > >ancildev.dev);"
> > > > > >
> > > > > > I'm pretty sure that the amount of bugs in error unwind will be
> > > > > > astonishing, so if you are doing wrappers over core code, bette=
r do
> > not
> > > > > > pass complexity to the users.
> > > > >
> > > > > In initial reviews, there was pushback on adding wrappers that do=
n't
> do
> > > > > anything except for a pointer indirection.
> > > > >
> > > > > Others had concerns that the API wasn't balanced and blurring lay=
ers.
> > > >
> > > > Are you talking about internal review or public?
> > > > If it is public, can I get a link to it?
> > > >
> > > > >
> > > > > Both points have merits IMHO. Do we want wrappers for everything
> > and
> > > > > completely hide the low-level device?
> > > >
> > > > This API is partially obscures low level driver-core code and needs=
 to
> > > > provide clear and proper abstractions without need to remember abou=
t
> > > > put_device. There is already _add() interface why don't you do
> > > > put_device() in it?
> > > >
> > >
> > > The pushback Pierre is referring to was during our mid-tier internal
> review.
> > It was
> > > primarily a concern of Parav as I recall, so he can speak to his reas=
oning.
> > >
> > > What we originally had was a single API call (ancillary_device_regist=
er)
> that
> > started
> > > with a call to device_initialize(), and every error path out of the f=
unction
> > performed
> > > a put_device().
> > >
> > > Is this the model you have in mind?
> >
> > I don't like this flow:
> > ancillary_device_initialize()
> > if (ancillary_ancillary_device_add()) {
> >   put_device(....)
> >   ancillary_device_unregister()
> >   return err;
> > }
> >
> > And prefer this flow:
> > ancillary_device_initialize()
> > if (ancillary_device_add()) {
> >   ancillary_device_unregister()
> >   return err;
> > }
> >
> > In this way, the ancillary users won't need to do non-intuitive put_dev=
ice();
>=20
> Isn't there a problem calling device_unregister() if device_add() fails?
> device_unregister() does a device_del() and if the device_add() failed th=
ere
> is
> nothing to delete?

Sorry, hit send there unintentionally.

So, would it be best to split the unregister API into two calls as well.

ancillary_device_del()
ancillary_device_put()
?
-DaveE
>=20
> -DaveE
>=20
> >
> > Thanks
