Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D5A402C25
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345550AbhIGPsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 11:48:16 -0400
Received: from mga07.intel.com ([134.134.136.100]:22037 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345458AbhIGPsP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 11:48:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="283941312"
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="283941312"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 08:47:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="512886896"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 07 Sep 2021 08:47:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 7 Sep 2021 08:47:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 7 Sep 2021 08:47:07 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 7 Sep 2021 08:47:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ViUzqxJR6Azw+spBGJRq0/8KQAoninbSuStJV5GRM/Drth8ZK5jibB6Ra8X2znxP314ebQ/7eNzudsLIQpjgl/pXn9V1yD2BQQl72jb0EasTgqQKarHPng2OH7RtwZ4dSLPrGP60dga+7gRNcvGq30E/JssNsInOps1h1v2pdy8t1JeEaySOA9g6Ahd4d3LHjg8P4FD5D6s0u4Y1v0L3AXL9jCt/oYBVud+B9dWpQrD9oKqNZf3Ta+5Lw85JMo5ssL6MzjL7U9V44NozLpO4OWfEFeIZVfhgBODnFmIjMiRzZWaKzlGr3jRyeKaKr8uInWbjr7ptBBT3VvDjNL8lkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=0qldo5V0WqF/L6ALKg5FlvFZTbN+kn8jTxeq2FTozJo=;
 b=Q7riYWYyc+flE2WuoNLTzwOLv4/K5bkoC2/1clKWvFBLnujSsGFDjo+Ky0AOkZ9BHShCEK4UDfajTpB0FgE4Iv6FIhBMszfgOlOIP+hQIarf+t2erUiWDOE6wBfF9DfNiIkzo/N6/07jCwBQLOUs+nQJWHA3fsVqeu9sg9MYm674nuQxcLcTpC3qj/2mz6tz3Ytq74KNJRBrmyxqQuXc3b/8vhQbB+0iGdBHLsjuJqjnaDg1M4Z2PPGvRH5Q4g1IhSixtEX+BTIVX7m6DsAQ5I9oUEHQUzVGydpTrnW8vPbLM8i/IIol0RBEo8pv+W3SZh4i4s6QWWOpyXJwNeJpCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qldo5V0WqF/L6ALKg5FlvFZTbN+kn8jTxeq2FTozJo=;
 b=LBein5y9tpbZF9muAa/wkHrb5kh/yuZVaJxHOiFwqSTPOPiBVIfdAJ6ATp219TDwoaA6wypDFyudHCjRw+R/5ZsEGzWKjOygVOUX49Jn8eWf7YPrqdKsIMHheUedvqP1GKrB5IUTG61lF+EEOMa5aUqvuBjk5UK3Jx3Ch0SCqOk=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5206.namprd11.prod.outlook.com (2603:10b6:510:3f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Tue, 7 Sep
 2021 15:47:05 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Tue, 7 Sep 2021
 15:47:05 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEIAAa06AgAADpCA=
Date:   Tue, 7 Sep 2021 15:47:05 +0000
Message-ID: <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: e5ef5471-7252-46d1-9cd4-08d97216be23
x-ms-traffictypediagnostic: PH0PR11MB5206:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB52065005023E4DAE6203AACCEAD39@PH0PR11MB5206.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gBTNTFyfqWn8NZVwwRpBprcOwYiGJMF4fWKRyL5zh/ii/BLMx4R098XAzPgpkL+sISiaZ7v98yvo4IyiNWBAwOEDT6GdTvO8O6L7emFMsxKnWIIokA5yq/7AFRDNgWvQTrrdYjmpJdlwYl9qMNXnCSNE0gGcei547np0Ir5Ke05EIf/AFtN+UkSBk/nkisp1kXhwE5eNoJ/I7VBiEfihD3dpbGE7R/xtUY3DH4cNU1j60B0LjVcjIp2/JiCpomPARGphuXYRA1DvK1FvI+rAKZNGgtTp0Fz79Sa1XOOq6nG02qnlOhP9EegWniJxs78ZtGRBzkbXG6qwbU8HM2ubz70297sBYrlukZCis7VOtluMLyqheMbDusEoi5P1o970EEFSJi9P0DBRfYLsDiDt3W+rfggvFet9ghS1W5j+2P6umKz8sFE692sItDVF/+3I6f4tLM+Q7pLOx8VIaDvn1OaG5oAjkMrVmT2IXUTC2WscY/9+3L70ogQjBxTaw0tIEWn5+1ROonx011PqGnoH14sps7rCwa5nbFXblZK/f7ibBIOJMiZjKm2R3eyBWLhM514nSC681mt8Ka2OmHrioA2Rp1YxGKzFuycR+oJuNh/XYuK20BobqcKv63Qj615gd+sGKi/CDCReykn6CsUXMfa1ZNmOiDU5Y7NMR0uaWBqyImyRfiQzK7P4HuOkCcak3SX7OuZ3Kn7VPGt06vt55rKF5UyV/Pp07iBkxI1wyU9k5NymcFnavXro1gE2lic3kG1P0fK1ZbHXAEDwjc90ph649VRNjW1nzg/ypPy9DOU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(5660300002)(7416002)(71200400001)(55016002)(86362001)(15650500001)(4326008)(316002)(54906003)(76116006)(66946007)(9686003)(6916009)(8676002)(966005)(64756008)(122000001)(66446008)(6506007)(66556008)(66476007)(478600001)(38100700002)(53546011)(7696005)(33656002)(186003)(26005)(8936002)(38070700005)(2906002)(52536014)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HjLKD/Jeg5p3qaPXKRRnGcB+AJkYDJcurCpO0NsZASM+SPycl4SDUMqf9JiM?=
 =?us-ascii?Q?SgTT3RgUSStiBFDvSKum9AyoYewLMdQtOs1KZLgHEFK7icet9lhrpjUcGPwU?=
 =?us-ascii?Q?q0Nhc+GZabavIANHDVf4XVKzcDI4SIP4I9WdgTeDmKQoWfuuamb3sEZpzVu9?=
 =?us-ascii?Q?yYlIn/qEWsRoYWajfOVXS7IfV5qIhDZ+ejiyD0AUw4Qyqw2baBmZH4Y70of7?=
 =?us-ascii?Q?GkvkvWFAcuEn3s9KySsAuudtL0gDdGyttFfOtqidoTcdcvSHgSmq9jl0Q/+C?=
 =?us-ascii?Q?uMW5m3wuOXb1LfKLT2xvnCofhpz6P7RJ+pkdEi1zmYJlDSXhpTZpn2uMnwgr?=
 =?us-ascii?Q?anRbHGPvDOai2aK6e0iGNoxogx8Fa2f1/qgB/1TzA8xCOgyePYLcZKwKizGB?=
 =?us-ascii?Q?4pMAulXCvii6rN9oSkqKmDvdzNyD0hnC1NrwrwH4+vYRepxN9c6iQjw2vUzr?=
 =?us-ascii?Q?g5JvaHLsT1i54IF4qbM5BWMtnpwf2BMVxSvtp7h2iiB2SaHxVNN8dvC33CWS?=
 =?us-ascii?Q?D7PDM88RTSaYff5QB5z0dFV0gdBlWAIvcqT954IWJdofO3+gBvWPY+nJuxHV?=
 =?us-ascii?Q?6QPMzTDTTh/I9iicODSM4tVbQhRFZ/K1uFi1etC534HvBk2zv9RO+hmtZCPX?=
 =?us-ascii?Q?kW+caaFuhXm+fGP9TQqexZVSrIH1IsYWxWl/KcPH2ZlMJk9N7lMLfEWANe+Y?=
 =?us-ascii?Q?bcShG1NmVeII+8AxVzoXmdS+KlKnXx05rodICgRIuVPMALxaXdLV+klcU9TM?=
 =?us-ascii?Q?MMnXhlbymGGegjjpl+Mh4izyszOyNVuv4D+vParnxAXqwHxYDkIzISxCpN87?=
 =?us-ascii?Q?d/IVAu845hVMZhOK8ncrbEzTg7Jc1tIkgO8HYxenJqzo3BHePzZQqJMNVIjj?=
 =?us-ascii?Q?44llnJkKdgk+2mxzqjQusCtKIjDoTKgiqzEBsRVtatXcqlyyV4SVnprbbAe3?=
 =?us-ascii?Q?oyo1vwC6IwisiYMerDGiF683Hh65G9/tqhmZdGIVwh5RkzEi+blFbEil/d5/?=
 =?us-ascii?Q?fSCAXlMQBxeo2CARvh/4LpL5Fd7WYE7mUKu5IUXJiQOIVlAOYlHzY7O4P5UN?=
 =?us-ascii?Q?2g5KzYogC870D1N+UTeymh4d75GhTF0XLQC+LegZGA2w6J5/l7ZiweVWclBV?=
 =?us-ascii?Q?vN22Vi1Qbfy+iVU2/20QePWd+YVC8pHDj+rjSXeJ7svFbIRfMCZ9/HT5ViJM?=
 =?us-ascii?Q?KaNpZn3XVl8UBRHsI69fbwCt4phbxIkLavf6aZulKAZvT4oLjcCVKh9Yh8Ab?=
 =?us-ascii?Q?76p3XD47REx4HQb2l8c5acutQgrI8NCSo8TtmzN3mmdsDrR5S8YhwA4R+XCK?=
 =?us-ascii?Q?OSg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5ef5471-7252-46d1-9cd4-08d97216be23
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2021 15:47:05.3551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O0EAwSbNTRH3UOkndqsEOg8is7Ngn0NFOuxPGhPFvgHzG2UIHslc2XJNnejWuK318pcEPauWwjySYqPpHsZq5IRN30uffxouvHQDVOVq2ME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5206
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, September 7, 2021 4:55 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; linux-
> kselftest@vger.kernel.org; Andrew Lunn <andrew@lunn.ch>; Michal
> Kubecek <mkubecek@suse.cz>; Saeed Mahameed <saeed@kernel.org>;
> Michael Chan <michael.chan@broadcom.com>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Tue, 7 Sep 2021 08:50:55 +0000 Machnikowski, Maciej wrote:
> > > > The frequency source can be either pre-set statically, negotiated u=
sing
> > > > ESMC QL-levels (if working in QL-Enabled mode), or follow automatic
> > > > fallback inside the device. This  flag gives feedback about the val=
idity
> > > > of recovered clock coming from a given port and is useful when you
> > > > enable multiple recovered clocks on more than one port in
> > > > active-passive model. In that case the "driving" port may change
> > > > dynamically, so it's a good idea to have some interface to reflect =
that.
> > >
> > > The ESMC messages are handled by Linux or some form of firmware?
> > > I don't see how you can implement any selection policy with a read-on=
ly
> > > API.
> >
> > It can be either in FW or in Linux - depending on the deployment.
> > We try to define the API that would enable Linux to manage that.
>=20
> We should implement the API for Linux to manage things from the get go.

Yep! Yet let's go one step at a time. I believe once we have the basics (EE=
C=20
monitoring and recovered clock configuration) we'll be able to implement
a basic functionality - and add bells and whistles later on, as there are m=
ore
capabilities that we could support in SW.
=20
> > EEC state will be read-only, but the recovered clock management part
> > will allow changes for QL-disabled SyncE deployments that only need
> > to see if the clock they receive on a given port is valid or not.
> >
> > > In general it would be more natural to place a "source id" at the
> > > DPLL/clock, the "source" flag seems to mark the wrong end of the
> > > relationship. If there ever are multiple consumers we won't be able
> > > to tell which "target" the "source" is referring to. Hard to judge
> > > how much of a problem that could be by looking at a small slice of
> > > the system.
> >
> > The DPLL will operate on pins, so it will have a pin connected from the
> > MAC/PHY that will have the recovered clock, but the recovered clock
> > can be enabled from any port/lane. That information is kept in the
> > MAC/PHY and the DPLL side will not be aware who it belongs to.
>=20
> So the clock outputs are muxed to a single pin at the Ethernet IP
> level, in your design. I wonder if this is the common implementation
> and therefore if it's safe to bake that into the API. Input from other
> vendors would be great...

I believe this is the state-of-art: here's the Broadcom public one
https://docs.broadcom.com/doc/1211168567832, I believe Marvel
has similar solution. But would also be happy to hear others.

> Also do I understand correctly that the output of the Ethernet IP
> is just the raw Rx clock once receiver is locked and the DPLL which
> enum if_synce_state refers to is in the time IP, that DPLL could be
> driven by GNSS etc?

Ethernet IP/PHY usually outputs a divided clock signal (since it's=20
easier to route) derived from the RX clock.
The DPLL connectivity is vendor-specific, as you can use it to connect=20
some external signals, but you can as well just care about relying=20
the SyncE clock and only allow recovering it and passing along=20
the QL info when your EEC is locked. That's why I backed up from
a full DPLL implementation in favor of a more generic EEC clock.
The Time IP is again relative and vendor-specific. If SyncE is deployed=20
alongside PTP it will most likely be tightly coupled, but if you only
care about having a frequency source - it's not mandatory and it can be
as well in the PHY IP.

Also I think I will strip the reported states to the bare minimum defined
in the ITU-T G.781 instead of reusing the states that were already defined=
=20
for a specific DPLL.
=20
> > We can come up with a better name,  but think of it like:
> > You have multiport device (switch/NIC). One port is recovering
> > the clock, the PHY/MAC outputs that clock through the pin
> > to the EEC (DPLL). The DPLL knows if it locked to the signal coming
> > from the multiport PHY/MAC, but it doesn't know which port is the one
> > that generates that clock signal. All other ports can also present the
> > "locked" state, but they are following the clock that was received
> > in the chosen port. If we drop this flag we won't be able to easily tel=
l
> > which port/lane drives the recovered clock.
> > In short: the port with that flag on is following the network clock
> > and leading clock of other ports of the multiport device.
> >
> > In the most basic SyncE deployment you can put the passive DPLL that
> > will only give you the lock/holdover/unlocked info and just use this fl=
ag
> > to know who currently drives the DPLL.
> >
> > > > That's where sysfs file be useful. When I add the implementation fo=
r
> > > > recovered clock configuration, the sysfs may be used as standalone
> > > > interface for configuring them when no dynamic change is needed.
> > >
> > > I didn't get that. Do you mean using a sysfs file to configure
> > > the parameters of the DPLL?
> >
> > Only the PHY/MAC side of thing which is recovered clock configuration
> > and the ECC state.
> >
> > > If the DPLL has its own set of concerns we should go ahead and create
> > > explicit object / configuration channel for it.
> > >
> > > Somehow I got it into my head that you care mostly about transmitting
> > > the clock, IOW recovering it from one port and using on another but
> > > that's probably not even a strong use case for you or NICs in general=
 :S
> >
> > This is the right thinking. The DPLL can also have different external s=
ources,
> > like the GNSS, and can also drive different output clocks. But for the =
most
> > basic SyncE implementation, which only runs on a recovered clock, we
> won't
> > need the DPLL subsystem.
>=20
> The GNSS pulse would come in over an external pin, tho, right? Your
> earlier version of the patchset had GNSS as an enum value, how would
> the driver / FW know that a given pin means GNSS?

The GNSS 1PPS will more likely go directly to the "full" DPLL.=20
The pin topology can be derived from FW or any vendor-specific way of mappi=
ng
pins to their sources. And, in "worst" case can just be hardcoded for a spe=
cific
device.
=20
> > > > Could you suggest where to add that? Grepping for ndo_ don't give
> much.
> > > > I can add a new synce.rst file if it makes sense.
> > >
> > > New networking/synce.rst file makes perfect sense to me. And perhaps
> > > link to it from driver-api/ptp.rst.
> >
> > OK will try to come up with something there
