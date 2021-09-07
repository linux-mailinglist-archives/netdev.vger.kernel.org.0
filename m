Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FF7402587
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 10:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243101AbhIGIwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 04:52:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:39605 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243317AbhIGIwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 04:52:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10099"; a="207364946"
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="207364946"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Sep 2021 01:50:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,274,1624345200"; 
   d="scan'208";a="694905542"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 07 Sep 2021 01:50:57 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 7 Sep 2021 01:50:57 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 7 Sep 2021 01:50:56 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 7 Sep 2021 01:50:56 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.106)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 7 Sep 2021 01:50:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XoctpPniZqg+vCBireC83YuL7Kr77dA2Ky8LVc4Nbyp/CPmEIhZbaLQTm/7GGBX/DFxz1Lmt/9Mj21KqKW51kR8I2KssQWzKiWjWuqE7SZG3e7t0hPWcbRIjSavx9iwp8JrrMslSmUSCrw1Lw9NRw1wko62S/8pjtM4e7hRbIhBs7Lk4kX4f65tCdHR6CIqpnzWHnZ0YoQna54O2ZO5keJanOLBxXZrvhU8kBO4cH95xCs5z+nuvtcp0GJakBTDIuWEXkrbtBF4lL5I9rlnhhXRWxhMA94+0M7mEip2nWHlMjVbqdo2xbI8J7mj9kLX+KobVnzQV7DSnZ2vuhVkikQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLHLJ9YNFF0RSQvHk/3H3qG0NHQEya8E6fsGyiMe4BQ=;
 b=gAI/P/LA2XdTBMTyFT2oqqiY5ECI4XJRzgcH0ClEHSiQTMKT5BHoDvy2v6moCaZx80q+vCnxOAephGxde71sHnFlk6Yo3AqaNme7HjHPXQ/+LIwigXmrppYvFW52dTO3R9h46ITzRbwy3Lxi/Gq44EHj9msq8SZs7nKCh45dsgFJH8sERgfo0p/UzJJEEXs8bx4Q06egnfDQTqow7QA01sXWN1GBdUL82e7OR9ZUIBvGCYoe6KtbKtSo776VwFatwRhD2+G9jH6VxCiWQ+lJPBD2rNSujU8AY/yJVegGhhyKMIgrj6rMJTiKVrzCWF2P231mtHVigrXq4g5Sn+PVow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sLHLJ9YNFF0RSQvHk/3H3qG0NHQEya8E6fsGyiMe4BQ=;
 b=QF2E7ftsxe8x95BG8ovNZnaAJG8kMGIujG75wwTn7dTjO9iWwuQ3CoQU4Xv1sqfYXduipLrQvXBFFSMOJabUxVSqGx7dfFWwR/nDCcMQYOJR1S0ISt5EYtw1nHQQ6zY6A6zVo2nY5rYitBN3GK6oLIxt7GkZzt0asxICmqSEAdM=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB4949.namprd11.prod.outlook.com (2603:10b6:510:31::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Tue, 7 Sep
 2021 08:50:55 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Tue, 7 Sep 2021
 08:50:55 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEA==
Date:   Tue, 7 Sep 2021 08:50:55 +0000
Message-ID: <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 609971f1-60a1-468d-5647-08d971dc9acd
x-ms-traffictypediagnostic: PH0PR11MB4949:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB49495E23CD1C841DD6EB3C16EAD39@PH0PR11MB4949.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VLYGFink+u4pwNQCLZPnT5ctzUW85PZ5duhabk7diOlgKItnId81yHLbDFbWoUBykpu8Pcdo9uFUCF37ZTfaquZUqUdsF9ON1pYTKlMHn6PMky9JauhMIkNkSk6Un3fQsZjCbW9GH6G1FI8pDwTlvTR+fxyJIiRJsQI0XtU+lzOY0aMka1zwCm1u9MfwC/dsBPw3hFfi/suUXytu3KMvTkuNXXwyEuwIfZzFGmGQJTiV2+E3x6XM7sFIrXKX5GMKhHWkNb5hPSdE5KMPzTvu52HHhMO7L8xxaftSpZXzOvhqppdw/Nw2t7+kvDlWG59mCDPa9j1062sAC0novQtTI4W802z43MqnHzyVv1mWpWo0+64cQ2bhVvr/l406DPOSLy9PFQKLHxRuzSDv+rtroGuztx5BIHyzrE+zveZCg/8MXOWaLq2CbbwVr79EoEhsb3Kjsidyme7LA2nIGydbAPCDbIGJNBGChU72Nsl/4r0ndXVGPS4TAQu9qEZpBiOb/8ebyJKsM00UeFM2p/+I5xoBxz28W4VBW9tlyjNj3rTkyDtbQj33XPI5j+ErUiaclOhpR7sB022tKyN1fST8AaXxleYhTkJG/NkTSQ6md8aEna5oiczQ5qIR6Au65cZcy/hpm97LBbfD4EhcOc1WM+0FZBeJGOu5OMmkmR/h3XzJ8g4Wwkld7HhzeTt3p6khG8RH23OmhqhzDSD7t2it3A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(6506007)(4326008)(86362001)(66446008)(64756008)(7696005)(55016002)(76116006)(66476007)(186003)(66556008)(52536014)(8936002)(8676002)(9686003)(15650500001)(66946007)(6916009)(54906003)(33656002)(5660300002)(316002)(2906002)(38100700002)(71200400001)(26005)(478600001)(83380400001)(38070700005)(53546011)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OjoTrMXnlOJWf2rLYzQMxQ/ox8RKmFGJsgu6vh1s6EPwWui1smxmuYV882ke?=
 =?us-ascii?Q?7mspfQjHnJmJdykoA6UL2fXlnfl08RHN4IUAgmUklA5EYpo0D38Mw05K4fyP?=
 =?us-ascii?Q?mgyjLncvMUhJvj4nYuMqq9CNW/pByGWymospJhnmKkzxt6ogT/jGy7z/r1Jk?=
 =?us-ascii?Q?nxs/czTQuDNECWiFN6P6fVKQ0tm1fpJpI6GdUNp55+fay5Z5LfnBgZ592HAK?=
 =?us-ascii?Q?ngs1fVxIdIxzNiqZAGh5JsHABNOquMStM5iIk6z5RjnrXTyt/sYgkDgWTfMm?=
 =?us-ascii?Q?DZRUxLQWKQqyvpWQOfbNdVo/6R/fESvhnD4OFAp7JIn5S4ffYJgmGydPOXJv?=
 =?us-ascii?Q?4rpKO0NiY/3RtefXYaZokrrhlGz6QvUUERUkd4osvrqamDdyg4TzQQd4dSr8?=
 =?us-ascii?Q?oAyMH4PFLWI1pui8cAjQFPd0EsApT4znKyDvETPik9aj1mx3l4BthPT2HIlP?=
 =?us-ascii?Q?iWmI14hEyCJsUjLpzopANA4708sm4OcoQHSdMaD+p0pors29DYK9oK7TycDF?=
 =?us-ascii?Q?Oh5pMPx5ADZ756xu5N6gL/mRyWq2YB1gx7YoURi5ApORUcPO1tedQsaPK8fb?=
 =?us-ascii?Q?sn0f9c6RPZcmAtQdyJhoO4eCDLb9rQswx19x1Pjosj7N1uJ0xreL8RanUtZB?=
 =?us-ascii?Q?8amDA3x/3EeDlItKB3Gq+eoql+fqcDvAfeMXgu+/Oibvm7w7rW+3+gSZrVut?=
 =?us-ascii?Q?Xf+Cpmld5Sjo0UZsma7DHTPNwhrDMmO5Z88fRdTvFRM8oWei9Esm0Ly8pS3S?=
 =?us-ascii?Q?gV3OoyK/cjsnX2NO8Hr/BJ6rRSB94f9ssu16ec4ia8pO+jdHNsE/xUV+hNLv?=
 =?us-ascii?Q?az8c0lIWJYQ/k92ptVV4U8OhhrhV5F/rKf30g5EtmvyMxqLCh3kMkEq4gziW?=
 =?us-ascii?Q?uLbI4Vt/lhITF9DiUQEW52p+hs5mwNh7IGckqyrk/zlz9QH/LQQwHsJTacar?=
 =?us-ascii?Q?wztNZH0kWJGijUhVOQb5JN3ViSC38Ec4lBgepPlh7mPt9CBNB8i0TwQXBVgL?=
 =?us-ascii?Q?P3BgZXIHfHG9OGlZe2G5lhMxYi1oJCy3m4ielr6D6xXYrm7V2LKcaoqeVQ46?=
 =?us-ascii?Q?xnX+nVwzVKYJAMxNluDpRBuxvVQ2HvDao7T4u2aeFnZu8V39On63lBexD2d1?=
 =?us-ascii?Q?Kpj9DKAJNUj1GSlb6iwzkctV8Y5q62KAuRi6TqzTbbYnw6QS5gyX/loEztWv?=
 =?us-ascii?Q?EN4hMps+JsIhIBGLQMI5BedqFkGpQTr5LgDB80uIe9Tsb+pV6kStafL91bzb?=
 =?us-ascii?Q?VU1kWOfoiXF02lnG8IZKNMTeExg/7G1g4JKJxU/KgA7QaBGs6UjPEpPWVt3Z?=
 =?us-ascii?Q?jF8=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609971f1-60a1-468d-5647-08d971dc9acd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Sep 2021 08:50:55.2163
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pvSwXW/Tjk/j61iYOvbX85Kinky1FMBxoIhViDkl0fVu+RYfnKKQ5ww791pkJL4vSjJ/NYOgpun6293dAZ4/jsX4hp953DDwgdFqN6XthhY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4949
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, September 7, 2021 3:01 AM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Mon, 6 Sep 2021 19:01:54 +0000 Machnikowski, Maciej wrote:
> > > > Hmm. Main reason for netlink is that linuxptp already supports it,
> > > > and it was suggested by Richard.
> > > > Having an NDO would also make it easier to add a SyncE-related
> > > > files to the sysfs for easier operation (following the ideas from t=
he ptp
> > > > pins subsystem).
> > > > But I'm open for suggestions.
> > >
> > > I think linuxptp will need support for ethtool netlink sockets sooner
> > > rather than later. Moving this to ethtool makes sense to me since it'=
s
> > > very much a Ethernet-oriented API at this point.
> >
> > Ethtool also makes a lot of sense, but will it be possible to still mak=
e sysfs,
> > and it makes sense to add it for some deployments (more on that below)
>=20
> It should not make much difference whether ndo or ethtool op is used.

Will look into it then.

>=20
> > > > This bit has a different meaning. If it's set the port in question
> > > > is a frequency source for the multiport device, if it's cleared - s=
ome
> other
> > > > source is used as a source. This is needed to prevent setting inval=
id
> > > > configurations in the PHY (like setting the frequency source as a M=
aster
> > > > in AN) or sending invalid messages. If the port is a frequency sour=
ce
> > > > it must always send back QL-DNU messages to prevent synchronization
> > > > loops.
> > >
> > > Ah! I see. Is being the "source" negotiated somehow? Don't we need to
> > > give the user / linuxptp to select the source based on whatever info
> > > it has about topology?
> >
> > The frequency source can be either pre-set statically, negotiated using
> > ESMC QL-levels (if working in QL-Enabled mode), or follow automatic
> > fallback inside the device. This  flag gives feedback about the validit=
y
> > of recovered clock coming from a given port and is useful when you
> > enable multiple recovered clocks on more than one port in
> > active-passive model. In that case the "driving" port may change
> > dynamically, so it's a good idea to have some interface to reflect that=
.
>=20
> The ESMC messages are handled by Linux or some form of firmware?
> I don't see how you can implement any selection policy with a read-only
> API.

It can be either in FW or in Linux - depending on the deployment.
We try to define the API that would enable Linux to manage that.
EEC state will be read-only, but the recovered clock management part
will allow changes for QL-disabled SyncE deployments that only need
to see if the clock they receive on a given port is valid or not.

> In general it would be more natural to place a "source id" at the
> DPLL/clock, the "source" flag seems to mark the wrong end of the
> relationship. If there ever are multiple consumers we won't be able
> to tell which "target" the "source" is referring to. Hard to judge
> how much of a problem that could be by looking at a small slice of
> the system.

The DPLL will operate on pins, so it will have a pin connected from the
MAC/PHY that will have the recovered clock, but the recovered clock
can be enabled from any port/lane. That information is kept in the=20
MAC/PHY and the DPLL side will not be aware who it belongs to.

We can come up with a better name,  but think of it like:
You have multiport device (switch/NIC). One port is recovering
the clock, the PHY/MAC outputs that clock through the pin
to the EEC (DPLL). The DPLL knows if it locked to the signal coming
from the multiport PHY/MAC, but it doesn't know which port is the one
that generates that clock signal. All other ports can also present the
"locked" state, but they are following the clock that was received
in the chosen port. If we drop this flag we won't be able to easily tell
which port/lane drives the recovered clock.
In short: the port with that flag on is following the network clock
and leading clock of other ports of the multiport device.

In the most basic SyncE deployment you can put the passive DPLL that
will only give you the lock/holdover/unlocked info and just use this flag=20
to know who currently drives the DPLL.

> > That's where sysfs file be useful. When I add the implementation for
> > recovered clock configuration, the sysfs may be used as standalone
> > interface for configuring them when no dynamic change is needed.
>=20
> I didn't get that. Do you mean using a sysfs file to configure
> the parameters of the DPLL?

Only the PHY/MAC side of thing which is recovered clock configuration
and the ECC state.
=20
> If the DPLL has its own set of concerns we should go ahead and create
> explicit object / configuration channel for it.
>=20
> Somehow I got it into my head that you care mostly about transmitting
> the clock, IOW recovering it from one port and using on another but
> that's probably not even a strong use case for you or NICs in general :S

This is the right thinking. The DPLL can also have different external sourc=
es,
like the GNSS, and can also drive different output clocks. But for the most
basic SyncE implementation, which only runs on a recovered clock, we won't
need the DPLL subsystem.

> > > > Addressed all other comments - and thanks for giving a lot of helpf=
ul
> > > > suggestions!
> > >
> > > Thanks, BTW I think I forgot to ask for documentation, dumping info
> > > about the API and context under Documentation/ would be great!
> >
> > Could you suggest where to add that? Grepping for ndo_ don't give much.
> > I can add a new synce.rst file if it makes sense.
>=20
> New networking/synce.rst file makes perfect sense to me. And perhaps
> link to it from driver-api/ptp.rst.

OK will try to come up with something there
