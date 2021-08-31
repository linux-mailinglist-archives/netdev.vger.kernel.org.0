Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A80B3FCAA9
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238981AbhHaPU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:20:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:7652 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232559AbhHaPUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 11:20:55 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="218542519"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="218542519"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 08:19:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="687768509"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 31 Aug 2021 08:19:38 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 31 Aug 2021 08:19:38 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 31 Aug 2021 08:19:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 31 Aug 2021 08:19:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 31 Aug 2021 08:19:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LP5ccnofrlqfofAYpxkvgPCqy9BlBEj3Km3CU+qkD+/H6HFkLlT30hGcHPxN7cCq4R1T2JMwRQGDwwXrA1qa8Ox25Lq5+ieOO8YIRMs86Yb5+6DbiE3HJtEZSEpuJqJoM2v4DvEm1smIWMozHtPRD8n0NYrDM8LgHVewGoQW9by+Z/Eh6kKs7rpQpQf7mtOo9inA/1sgKunyUGETf4McUpye7lowoC5TgdxLnMuTXUH/231DiVvfYMB8SaKlJFqgsIjb5usoCQO8It2Mu0zO7CF2xDtsfLRLaje/Yho94u2BKqqQQQ78416RJEWOwEpUB0+m/cIrrJoHjxKMdIjrIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXj7cIrZ7Vn+55mwzVLa01KK11+37Njw3uVfCBqtw7c=;
 b=dEyEE7Baad42boYwj3sc7KZLzkmjUvovwZm3AXhuimx07ypdv/jW/4PEym0eUKetddm0Wb3NXlK3DH0jWwSwDPbo5elKsLhjtnw8pDloUSN8xAKC6u0WnHo3fl1Rmd03aeFDuL63PtcFTbQ34lSLBtWSK0JBvbOBALc+ajSftd11fXqZEVjNHqM5C7+HwYtfGrx0mcJEevgpuDLaj7zfyPzhcCNfRlA+VOpaH+EgZ0yuZl7PCgbWZB4exPT0UyeWkUheuTn0Jr0FY5PmwQIAFuZet4DO4uGVDuGmT6cnMoKKtWk3OTuDT3uvwoSipyOvYna2u35MYM97oCd3CTi4HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXj7cIrZ7Vn+55mwzVLa01KK11+37Njw3uVfCBqtw7c=;
 b=xwMpcfWgz3MmlxH7fVcuw1LRNf1IqkxQsVfHDJXP0Non8wJbYw9BA81En4N2M7j3H/mDRffPRqWbPNnErG6OZ8+F0WVEVRMyIl5O7nxvKxGFjtEAtAyspyCTahZuS4NAv9XUEzBeN9SSFkCZrt6eI1Bsbu8AGHUzYsWCyVpzK2k=
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24)
 by BYAPR11MB2581.namprd11.prod.outlook.com (2603:10b6:a02:cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 31 Aug
 2021 15:19:36 +0000
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062]) by SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062%7]) with mapi id 15.20.4373.031; Tue, 31 Aug 2021
 15:19:36 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        Jonathan Lemon <bsd@fb.com>
Subject: RE: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Topic: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Index: AQHXnK7K1rkxJTKXbUG0z9L1S2fbo6uKlpWAgAANa/CAAeYOAIAAKj6AgAC0GNCAADexAIAABHUwgAAIGoCAAAwNIA==
Date:   Tue, 31 Aug 2021 15:19:36 +0000
Message-ID: <SJ0PR11MB4958304AA06A63DD6290D3DEEACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
        <20210829080512.3573627-2-maciej.machnikowski@intel.com>
        <20210829151017.GA6016@hoboy.vegasvil.org>
        <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210830205758.GA26230@hoboy.vegasvil.org>
        <20210830162909.110753ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB4958029CF18F93846B29F685EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
        <20210831063304.4bcacbe3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <SJ0PR11MB49583C74616AC7E715C6E3A9EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
 <20210831071801.0535c0cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210831071801.0535c0cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc078da7-f99b-4c63-af33-08d96c92be81
x-ms-traffictypediagnostic: BYAPR11MB2581:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB25818EDA98A8D4687085B4CCEACC9@BYAPR11MB2581.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VLOlQGladvw4k3woaxXkNUB+VJiMa1dR9YHvRbLajevWCd+D76s3okyAl5eu7vRGhQ7o+YInkpBeWUMrddQKciDBD4FjCiHpxFPa2OFYJCkiqr8kBWFUD61qB1lYB/pSiWwnRlSRQ0LneQfRnp7xW4NAIRfxGEjNoHQDoIuhcnLd8ZezZYtWAGIfXvd5Qjl3dsD1HPbZC5HIWswwWie2ZYiVfZ3IcY+OB+tCYkdY0KhA/ZKU1Cix2Vo/KcS8nn/eCPtE8kpon4G1TDj4NiRkBpuj1EI6zBE7ugyO74+7AO/zyWiZpK5+ceYp9htGBlfguRCO+5DBvO+zwUotRlTc2hF6sVPteq+GN8THwFb6Rd9OhlhGeIk/v11quk4AkJKy0HmAtWOxFgutYRVkvjwL3CJxxZ9z1WGGmOsjip1DGwttgGqxODReiJpAUJNsgoEGLxsWnrGGEMgUhgdJ680NCJ6jg+i4nGc69Y6Ya1dpAQxUW79R/0IYBo2h9W9oyi9IfzG26dekpsNLtJdmQ8+t4NHC8L9t+VPCywfO8wEs4si9GZpBW1KBnZ+j9jIs7i1Z4KD/CDurdgpL4l6FVQs+MSRhfQhJYsN9d11adIBwGB0PX3vQozQOtDUcsDPfRB+cpqg2BDG1sCxVa3s2LElufVWoNtb/rZgvMZIoRM8f2scDSAqynJ8fvoYtAEXBLgNJzNQb6+bfYfszQZnf/Rt+uA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4958.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(66556008)(66476007)(186003)(54906003)(83380400001)(64756008)(316002)(66446008)(8676002)(2906002)(86362001)(66946007)(4326008)(55016002)(9686003)(38070700005)(76116006)(8936002)(26005)(7696005)(5660300002)(52536014)(478600001)(33656002)(53546011)(6506007)(6916009)(15650500001)(38100700002)(71200400001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?n2v1QptOt2NDm9LpDPwPLlnOU5HlasXuZVffV11xFbD8rFbsom3vBj4avViA?=
 =?us-ascii?Q?HpMbmXm+0Y2oFz599llDgYB3igoR4nVNXngVKCqn11B55LXAtzIPVeMu/sZ/?=
 =?us-ascii?Q?c0JxgiLc2zNwz5Uw8Nbeg4uIu9VnlQPhS7hh9XfQxT7JARNqyeI/3OND8kwB?=
 =?us-ascii?Q?9iAw6LIUia7BjJr2OFOI9g+LGN9RxW80Q0vwl22FUKP++xIxu6IWz4RP/T9T?=
 =?us-ascii?Q?TZQvXEM7qxp6gXqsZ57Rvp+sqfo3/7+QzK7SyUU1BtuGZOGPPyedLG/N8DGG?=
 =?us-ascii?Q?qs/N7tA8nYIXuEtyx7kVmQBMMtYxF/nrP2G4EyBVmt5td1HQ2AYPQewh8RMH?=
 =?us-ascii?Q?R68MLP1+G7tWTpcq1Tb4O7TdT8ZN2WEomfYaQpLug+uuFLvUTPQrfcCTldqF?=
 =?us-ascii?Q?wn2z2TFcF26BA0oMJjIGw1MogfOKEEwqb+iewbHzpQlHGcczy0t8PgGFDJ0B?=
 =?us-ascii?Q?+t2KZcEAkIOgEfZ6i8NHexF5rms/aKwXkM/p4ty8hGwyTB04IOhzZ0diekVv?=
 =?us-ascii?Q?C/U1burbhDVOpqTWmCqGIkD00scptLwujLSMNojWIodmlNSExrDRYOFsDWKe?=
 =?us-ascii?Q?UWzzyS7bu9vDnzEn9FKzwNpojYdJhl3y7CD3q4CAV3vIKEzmJ/FVnT0nPooB?=
 =?us-ascii?Q?7uCqgH7w8P5d73zC+SPjCYs9rMvqGaoYi+aPJuanWXzCo8irWAYVgxH0hUpA?=
 =?us-ascii?Q?XsLCCOaE9+RH0LkWZmbogl3/Lw0ltYT/+4voDOYUs9QWcWAzYE05UHPhKCm9?=
 =?us-ascii?Q?LQv3G1Y1us2sA377bwIbpJk4tSOkb7/xvyxBK6TPDSr7Kv9VslhgeWtgqY1x?=
 =?us-ascii?Q?B4q2x9DEqNop46jxwdFH92vlzJ6ow64t6PK6TE72mdg2nyW38kLQvpKaQTE+?=
 =?us-ascii?Q?mNNcQ1PbqU1ddB+AjAQFBUE+fi/PTebKmA1xx0nDE1DIOujedWcq6R5IDyRt?=
 =?us-ascii?Q?PXOw/AdCvy9AKYCsz/3+sd9DeTzmh9asPuVwlv2cR0YryQ+KJkbKNZZdsAuH?=
 =?us-ascii?Q?WSt+IT+WZQbG9eulPExrb/wVtGdXJTfvXeIKZZcvtgI+VJFNxpfRAE8cX406?=
 =?us-ascii?Q?Sss7JVyTtDJus7nOf/xpwVJ5GoxL8ZTmpI4YJV9z1AQ7fxYJ2aAmze6pGgL/?=
 =?us-ascii?Q?7fABYN0X8KVsILDwtL0j1U/P79XKIP4zxsv2dj/2B/C3ZtLRvJ24nej3Tvj2?=
 =?us-ascii?Q?wjYO5ykvnKv+/oQjnVroshGyHF87JRGpmfQNdngevI+jHqpo+oBIyb0m/Ifq?=
 =?us-ascii?Q?Sbaxg/Yt3nTdm+juavNJKcQBC+HwDn2zlWIHRa/ffeQ5YwE3HuJnVR5sUKNJ?=
 =?us-ascii?Q?Wzo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4958.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc078da7-f99b-4c63-af33-08d96c92be81
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 15:19:36.5675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Kh2DdEahDBb+BrSISLKRBZfBLCqJhcU+snKYosa5UJ91sqTIyommlBkFBgnXX3XkblBDyap52F3o7oQoLufDaxTl9OQeIh39RXWh2PFtEYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2581
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 31, 2021 4:18 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
> message to get SyncE status
>=20
> On Tue, 31 Aug 2021 14:07:32 +0000 Machnikowski, Maciej wrote:
> > > > I agree that this also is useful for Time card, yet it's also usefu=
l here.
> > > > PTP subsystem should implement a similar logic to this one for
> > > > DPLL-driven timers which can lock its frequency to external sources=
.
> > >
> > > Why would we have two APIs for doing the same thing? IIUC Richard
> does
> > > not want this in the PTP ioctls which is fair, but we need to cater t=
o
> devices
> > > which do not have netdevs.
> >
> > From technical point of view - it can be explained by the fact that the=
 DPLL
> > driving the SyncE logic can be separate from the one driving PTP.  Also
> > SyncE is frequency-only oriented and doesn't care about phase and
> > Time of Day that PTP also needs. The GNSS lock on the PTP side will be
> > multi-layered, as the full lock would mean that our PTP clock is not on=
ly
> > syntonized, but also has its time and phase set correctly.
>=20
> Just because GNSS lock addresses more parameters (potentially) doesn't
> mean the syntonization part shouldn't be addressed by the same API.

Fair enough.

>=20
> > A PTP can reuse the "physical" part of this interface later on, but it =
also
> needs
> > to solve more SW-specific challenges, like reporting the PTP lock on a =
SW
> level.
> >
> > I agree that having such API for PTP subsystem will be very useful,
> > but let's address SyncE in netdev first and build the PTP netlink on to=
p of
> what
> > we learn here. We can always move the structures defined here to the
> layer
> > above without affecting any APIs.
>=20
> It's a reasonable SW design strategy to start simple. Unfortunately,
> it doesn't apply to stable uAPI design. You're adding a RTNL op, which
> will have to be supported for ever. If we add anything "later" it will
> be a strict addition, and will have to be backward compatible. Which
> I'm not sure how to do when the object we'd operate on would be
> completely different (clock vs netdev).

I agree - the point I'm trying to make here is that the existence of
the PTP-specific interface will not invalidate the need of having=20
SyncE-specific one as well. Even if we report lock-states for the clock
we will still need to report lock-states for devices that don't use PTP
clocks, but support SyncE. (that's also a reason why RTNL is still required=
).

The RTNL interface will also address devices that only need the=20
frequency syntonization (especially in Radio Access Networks).

>=20
> As I said I can write the boilerplate code for you if you prefer, the
> code implementing the command and the driver interface will be almost
> identical.

I think it's a great idea to start that in parallel to this patch. Then mov=
e
the common structures to the generic layer and use them in both
SyncE-specific RTNL implementation and PTP-specific part that will
be added. This won't affect SyncE specific APIs. The "worst" that can
happen is that the driver will put the same info for PTP part and
SyncE part if that's the design someone follows.

Regards
Maciek

>=20
> Is there a reason why RTNL is better?
