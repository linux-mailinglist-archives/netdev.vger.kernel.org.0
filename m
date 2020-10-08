Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA22287A3C
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729813AbgJHQm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:42:56 -0400
Received: from mga07.intel.com ([134.134.136.100]:53505 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbgJHQm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 12:42:56 -0400
IronPort-SDR: 6cDLo5KSzImzgEE00kwCsYKqN9kG+8uiFjnEG8VOfLozjDiA2lV2e5yR4j3oFvKsiSaZxAaCJ8
 tWVLnT2sUhoA==
X-IronPort-AV: E=McAfee;i="6000,8403,9768"; a="229554934"
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="229554934"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2020 09:42:55 -0700
IronPort-SDR: j9oKH0xl1gfROf72nFbh/TptvmnytoKLpvjVcIvaj7eq7lnJV3zMIlPGTDCt9fU9Ux9ZBD807Z
 Le110HScVMBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,351,1596524400"; 
   d="scan'208";a="519406851"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 08 Oct 2020 09:42:55 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 09:42:54 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 8 Oct 2020 09:42:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 8 Oct 2020 09:42:54 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 8 Oct 2020 09:42:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=To3yMk8FSuPgRVyyqG5J8ebJfJvuL1WYmj3VUgql+uNjrQbDbRIyPjXzMy1YXDVVejwaAlyDJUgC3ryQsLSDSo+ilDw4+ckybz22b7eiRQujsMjWxjSbRlzW9cYzWMIequCvm2UKAp/ozlu8W2h52+Ay8+7FIZQisKUEJsQ9T5c9cNLdkitq7sM5xW0OalW5nQ2Ud0of3rf/cIKySiNdrqZj9XQ70Hc32y/fc9ILk9TWU4M9HCArtwZepNbC13cnRfEMb++8TJU74FkcHBRUHinfWpCAGVvu4LCm8GkZsqVzvDeBrylUD7aka6C+SzKeW/NIfOV7qAInZCuXVN7Elg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbHvyf8gLMyd7SbRRfuHpqIcQMWhvt+KrcitCAgTpLA=;
 b=Y6ChccWJRPJOgssGrCZBT83t6qoSX23+H3mUVLtZPHoZrTtKnMtVLYcf0zn1gVwl72+7ZYJD8tQimMCVBN79CiKuootj/7FNUp20OZE3GGx3axYef3edvr1gvODj6HVBJYj6zJ5CNOh72ihubo/TH4z3XjF1azfw+F7PNWvm8wAxv7KftsW88ynikhLacz0jDjeSZoREzgXENmwDqm+kckIM2Cl5JDrjZqPOt/jvcgUEwK/uUNh2qjxMckXSqqFnNJ3E3Qd45LiSnAEC+a4E22LiUKBZQ8aDTlsNteT0zTcaUUro1wlgCKlIOc/x0DsRgIzBWSqC9EwSeeAjTzkIjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SbHvyf8gLMyd7SbRRfuHpqIcQMWhvt+KrcitCAgTpLA=;
 b=uWk9fZ4f5Sovz1QzDbS8RJOAl18b87bNWV0U6mFgmUBlO7zFUrjpC1iGSSNyy4TsbYh7dyXpRMqqQLQVFxDN9ppnkgvbx2S8F9EZL8o2pw/1yZBkWbVPc/theRZDDfFaK8AdTy7dNJpC/tFYVFFJRkKw/Nfet7r37h82AYmdI+o=
Received: from DM6PR11MB2841.namprd11.prod.outlook.com (2603:10b6:5:c8::32) by
 DM5PR11MB1353.namprd11.prod.outlook.com (2603:10b6:3:a::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3433.32; Thu, 8 Oct 2020 16:42:48 +0000
Received: from DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a]) by DM6PR11MB2841.namprd11.prod.outlook.com
 ([fe80::6d8e:9b06:ef72:2a%5]) with mapi id 15.20.3433.046; Thu, 8 Oct 2020
 16:42:48 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>
CC:     Parav Pandit <parav@nvidia.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
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
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
Subject: RE: [PATCH v2 1/6] Add ancillary bus support
Thread-Topic: [PATCH v2 1/6] Add ancillary bus support
Thread-Index: AQHWm06cVdQZOfJAqUq6P9wAQIqk66mKKyCAgACGDICAAB03gIABoskggAAXogCAAA5GgIAABE1ggACTy4CAABO4gIAAB+sAgAAKeACAAAYyAIAAkRLg
Date:   Thu, 8 Oct 2020 16:42:48 +0000
Message-ID: <DM6PR11MB284123995577294BE3E0C36EDD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
References: <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201008052137.GA13580@unreal>
 <CAPcyv4gz=mMTfLO4mAa34MEEXgg77o1AWrT6aguLYODAWxbQDQ@mail.gmail.com>
 <20201008070032.GG13580@unreal>
 <CAPcyv4jUbNaR6zoHdSNf1Rsq7MUp2RvdUtDGrmi5Be6hK_oybg@mail.gmail.com>
 <20201008080010.GK13580@unreal>
In-Reply-To: <20201008080010.GK13580@unreal>
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
x-ms-office365-filtering-correlation-id: 889d3152-efc9-4ed4-5145-08d86ba930d3
x-ms-traffictypediagnostic: DM5PR11MB1353:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB135319A57C9E9864243A134FDD0B0@DM5PR11MB1353.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HXu5nDbA3s9D/0HSbd0qKHjODtcmOOf0jeCkG7ciN+VXkTtufjQnSFtXGOgNQ5D5GUo+hLcN5OLs1IxtsL6bymtWFi/3mDRYInmeBRU2yMyRLNh9c42HMh+YR69NaXUEoboS7DZp5o0IDatjz+SsvKC8BQAcsRO+N842Xz819xXkHTSeQR1AnDu27n54Lo13/EgQV/ReExMXUWDk3lkXebJeMNgeBvhVgle5ILQL6XCzmOkGf7a2otOUdYZHg5NteSegMfzL6rv+3WDRY2OBOVz9t/Mt8iDbS9YL/r9w7zhXMCVPs6C5m5MMs/Rnmq69m3RXq6WWPdkyW3EjFl6cmrbmzkMCtK4O1PPke6LunpHrYQxlenjvolDzjy4x7F5lHQmZfkjv4bHgqTsW8l9U0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2841.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(376002)(39860400002)(346002)(8936002)(55016002)(9686003)(6636002)(86362001)(2906002)(7416002)(966005)(110136005)(54906003)(33656002)(5660300002)(52536014)(66476007)(76116006)(66446008)(64756008)(66556008)(4326008)(71200400001)(8676002)(83080400001)(6506007)(53546011)(26005)(7696005)(316002)(478600001)(186003)(83380400001)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: /9U6+yszD3AmXSWOBusdmspr6zcjGFkq6NBQT6XyBQWbidTb5tLXukh6pR7XDSall2qKm3Xrc+dVFF3dZNZZeTYOhaeGVOSivLZFEcyOF9yE1Bjy+FUzStgH+OJiH7vZDXze7SL+tF1JEJVniS3ibZae1O+tcbKZ3Fj2v2r6GOVFEfDTxAa1OSo5Ho1I3GhZXzzVMXV/b21oq17OJ/mKjwYFUnl4Z/bpZFA6A/3p3FVql7e9huKGNjYy04lw1UmnagoV6atsmCVXn0mpVh8SR4xRNCID6X058jXG5fP8zAlVcLwAYe9p0p4dGBGwAQKSzjzURRYe5Wb+88151UfnAJ57zzmP1RRXZikh8YPV/Hia0zU1bf9dCTEoFzvmlv5XNOC5rAb+oQFnQF7Tj5so7eCERueOZ4N1mTkvCEuHi3yQXsiIt/Q4nHmWwcOxcb04r8WL+12VBlbc8E3aSaNTdi7DZYlxCuV+FW2F32rbzQkyNzm2xkmhK9uGUtuWlb/C+cGk21XFlXKyw5dfxl3vVVVzIiVVXA3GpOuZ8q73aXXjdhH9uCB9SUD/KJzvlenDgRJ7FvzbdGGbxzRIF9zB5h1jlCgndCCxmkSv7v9s4IT9K15p56xDjCUQbvrC2lUleW7+RNAg3GJ5e519et3YIw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2841.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889d3152-efc9-4ed4-5145-08d86ba930d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2020 16:42:48.4526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q10tNWYYcxC4Bos/b97HY6heqpH64ybtEt6Zfoy1HD5CGoEto7fdD0Z3lQ104g+6MBv85KsOs+X25rnXOBI8SaIJ9jY2+u5STrTyNavPvw8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1353
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Thursday, October 8, 2020 1:00 AM
> To: Williams, Dan J <dan.j.williams@intel.com>
> Cc: Ertman, David M <david.m.ertman@intel.com>; Parav Pandit
> <parav@nvidia.com>; Pierre-Louis Bossart <pierre-
> louis.bossart@linux.intel.com>; alsa-devel@alsa-project.org;
> parav@mellanox.com; tiwai@suse.de; netdev@vger.kernel.org;
> ranjani.sridharan@linux.intel.com; fred.oh@linux.intel.com; linux-
> rdma@vger.kernel.org; dledford@redhat.com; broonie@kernel.org; Jason
> Gunthorpe <jgg@nvidia.com>; gregkh@linuxfoundation.org;
> kuba@kernel.org; Saleem, Shiraz <shiraz.saleem@intel.com>;
> davem@davemloft.net; Patil, Kiran <kiran.patil@intel.com>
> Subject: Re: [PATCH v2 1/6] Add ancillary bus support
>=20
> On Thu, Oct 08, 2020 at 12:38:00AM -0700, Dan Williams wrote:
> > On Thu, Oct 8, 2020 at 12:01 AM Leon Romanovsky <leon@kernel.org>
> wrote:
> > [..]
> > > All stated above is my opinion, it can be different from yours.
> >
> > Yes, but we need to converge to move this forward. Jason was involved
> > in the current organization for registration, Greg was angling for
> > this to be core functionality. I have use cases outside of RDMA and
> > netdev. Parav was ok with the current organization. The SOF folks
> > already have a proposed incorporation of it. The argument I am hearing
> > is that "this registration api seems hard for driver writers" when we
> > have several driver writers who have already taken a look and can make
> > it work. If you want to follow on with a simpler wrappers for your use
> > case, great, but I do not yet see anyone concurring with your opinion
> > that the current organization is irretrievably broken or too obscure
> > to use.
>=20
> Can it be that I'm first one to use this bus for very large driver (>120K=
 LOC)
> that has 5 different ->probe() flows?
>=20
> For example, this https://lore.kernel.org/linux-
> rdma/20201006172317.GN1874917@unreal/
> hints to me that this bus wasn't used with anything complex as it was ini=
tially
> intended.
>=20
> And regarding registration, I said many times that init()/add() scheme is=
 ok,
> the inability
> to call to uninit() after add() failure is not ok from my point of view.

So, to address your concern of not being able to call an uninit after a add=
 failure
I can break the unregister flow into two steps also.  An uninit and a delet=
e to mirror
the registration process's init and add.

Would this make the registration and un-registration flow acceptable?

-DaveE



>=20
> Thanks
