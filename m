Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7294046C7
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 10:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbhIIIND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 04:13:03 -0400
Received: from mga18.intel.com ([134.134.136.126]:60490 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhIIIND (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 04:13:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10101"; a="207831283"
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="207831283"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 01:11:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,279,1624345200"; 
   d="scan'208";a="430997897"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 09 Sep 2021 01:11:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 9 Sep 2021 01:11:53 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 9 Sep 2021 01:11:52 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 9 Sep 2021 01:11:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 9 Sep 2021 01:11:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fxSk0Wp7vnbiv5zoiYhFOg6YTwEEQhaG7WqCQpKe3MnxvZo90d1hJikwUmAyOlvBL60XxcnFB0ENgxhxpLyQpJzf50Zfk8iibbaljhWPZomAvSW3MQLWPgnk3Gv8XGIU3W+5+IaZ8/Fh379mYnM0sH61cnfapxh/pBcCaqPHO6BhBNg19puSBOY85XXpKPSbO6MmPjRrQbhZ5vbcWeaIZoBV2SHWaEkr9DnUgN8qUTagpxhwViDmHjU+l4F4Z4ER4aF1qzzREethJ+J1OR1UfVMUqHSoDEoW43BCwJrl+e2nVqCKrowU/gMn3tUJwgis1zesUfjQw4bOpEJlmRrprg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=iCxIU6dhz/92GgDPOKhlKIY1TC4QOWcY2fn6PxzbhRM=;
 b=iTl2V4AivHAjfgB0KgQsOBWfsMBdwiz0Yi7g1fR9aNMBharyZliX4wZnNl23iLLzWyCeUK3eJeP+XA1oA9aPiTvZLJFreKwvqlyP12CqlzqGoYkuUYoDSnk7/QiafRsDIbJr6K6SfbfxswWIQijj2RBlUrGQ7iap34HkiXhU/P9za65/l6wmC/qaUbOVO4WrZt5rANfWiM/n54tK8jt0GZsVV9e9Hq8n0Q95kpjdeI7Lp7WGfjCS5RIfVw1QNS7jU64957FFRfWoZVKdI/rLkN3MD2ddWlhemlxf3zwz4fYL9wcbPWRDh74O5FFo7zRNE28hDa+3lmbpT5hP823Qag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iCxIU6dhz/92GgDPOKhlKIY1TC4QOWcY2fn6PxzbhRM=;
 b=nHdG+ARlJR/5w43NI5njs5pCCCkncC2UkYaZXtn8+66F3sIyJRe6Qrvdtts2yedMqVGCJBTRw3GuCtPluZVdUo6muZqco7+hARFjPqocxY+u2oESM7i+l/2z0k0eapq0nYIligeu0MWjvSEA+wJOA3AwMPIF7xMhIYwcr7+DwwE=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5141.namprd11.prod.outlook.com (2603:10b6:510:3c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Thu, 9 Sep
 2021 08:11:51 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Thu, 9 Sep 2021
 08:11:51 +0000
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
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEIAAa06AgAADpCCAAE4LAIAAxVmQgACTXICAAAjlIIAAWwUAgACbtAA=
Date:   Thu, 9 Sep 2021 08:11:51 +0000
Message-ID: <PH0PR11MB4951205B0D078D94ADBAFCACEAD59@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210908092115.191fdc28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951AA3C65DD8E7612F5F396EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210908151852.7ad8a0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210908151852.7ad8a0f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: 9ef5a8c6-226d-42b2-6953-08d973697ac1
x-ms-traffictypediagnostic: PH0PR11MB5141:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB514118620AE4E2556A53757DEAD59@PH0PR11MB5141.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: daecQyNmtvoCSHgZ9B15MxY8cNQX6lIwrvxf9b4WT/QerOLjYHTPNGbAatBKmHAR4OWAIsCaatmF0hEeX8/rx/fR5ctdl+blDIul4qoUmr8yWnGrIXGguzMLLFslpJ4ZNxrXKoXzoON0ADWlxwDA/INoej3XMfD1LeBFISuUeJUnWF9CF9mHUoMyy+70FGW+TY1X6xBaZVc6GyG4WE1S9Mk21X5odBboVqpqfrb9bAOdxIEpx+zzlLp88PhJYlnHM3cRJ0dg0jQ7Hirx36XRKzIvUUetMeZD8216eDH2X3bnrBWqu7olMtfttwNYwClTOzMJb8Zw/oen3g2PN7XhOseuaGY1WFmHbW953XNpJTU6XVZbIKpDG0aPS+7lxNIj6UupO6b+fdMh7pKBUSCqc3xtQLv1qYinqLrrqT7E9+r2XD9lj6zp2PqE9wvMCTwWDjNS0aXkiVr2Y0M2TeX7ymeGt3JziSjP2L+f7rZ0Z19SvStSG9GWZpR0EAWMFTmV5JmtHbaSdrGHUaHtqPmioWOc9umRw0z4Um+ZKt042/XJhQeKeJjKuiWon4Hiza7/WgKXoE3RZZ9jgBGE/tJonlpL2DqcU+OLhICP9kwHNElK5sdWofUTyZbut+aZwxOakdCx5pGtw4/z12+5IpiutPag1A3bmI7kiF4bwxQ1TIWN+ON6/i6RFLHGvco5Se6XW/kDYsgjsUQGc6KrSa7TCQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(366004)(39860400002)(316002)(8936002)(71200400001)(52536014)(54906003)(4326008)(9686003)(76116006)(6916009)(7416002)(5660300002)(83380400001)(64756008)(66556008)(6506007)(53546011)(66476007)(66446008)(66946007)(15650500001)(186003)(7696005)(122000001)(38100700002)(26005)(33656002)(478600001)(86362001)(38070700005)(55016002)(8676002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TC2lc1X/ocqLyzr7InsQDmRIFk6JIEcwercD6/Q7KdOqlJdvb5ofdFFqTffP?=
 =?us-ascii?Q?v1YYFKG49oHJB7PtCO/YGFGNoMOiBt5vJbvH4WG/E6ilHaA3aTWT37P3/Ml7?=
 =?us-ascii?Q?Y9PCVRl7pbhMQ4FPv6+LJXiw1w+axHFzA8raApRZsXGuKGwVpxlfawD6Ft1g?=
 =?us-ascii?Q?DugmXowfWmHEDSFLVyzrn9Vq56milgwoKzGdfeVrT2Bb1DN0fiJ0iLWbTq9J?=
 =?us-ascii?Q?RawS28IxwSRZqHsiRN1+5iapMPjn90EMoJQiRRn5/ro2iaCylrCEafvSkqRV?=
 =?us-ascii?Q?SojYYclSfTI5W0SUVlVoOmzLQQu+lf0C466WQwfG4whN/igdzv56wah9zia4?=
 =?us-ascii?Q?b1z5kWLzBp/ctVi3cD2czkfST1FWpyKWQBeo8CbviCoQrO5Zwa0PXD3E2i7B?=
 =?us-ascii?Q?1i6Ua6X4k/d4zriOoSUePSpEPyCqJNMtuh+7glef7TEg1hcxhN9zce2ycspA?=
 =?us-ascii?Q?ENim1A1SR+fq5oeMBZV3SkIln2NwqdTRzZM9WDzGOFu9kU4u+YhcFA54LuUa?=
 =?us-ascii?Q?HA/zbuNqBukumVkCNB1imkmeRwcU8VIBGMriEKM/v2S7XXK4JER4Lzydzffx?=
 =?us-ascii?Q?jcKtQyYuVPBDGPzEa3JtWthSf6L9bRIjKoiZNYIqrkWV4PEQh6GPHAjDbXBy?=
 =?us-ascii?Q?tlGgL3yj6ntUwVvYcb6qgcdHha772kCbC5GMQC2emkYoYOL7BG8x3xYqIbmk?=
 =?us-ascii?Q?Gwoey5kDHzJVn0bS2+S6IyutMJ4FmC5ktejrPehN7G4h4lMgE6TuYTtrhH/5?=
 =?us-ascii?Q?fYKxuDZ8oQyDao4M4tuaR0/3uA2ZWBSJPv+CVH5stYztq3vimUctBCGVuxoD?=
 =?us-ascii?Q?e5hCEp3f8Z9xN08P9mRuOmLrwojglXlrRxWYHx0Qc2kNEbx5dd2cpJT2x0aA?=
 =?us-ascii?Q?IrJ0/PiuWgEgKN2ycpNMh8bWAkMs5zdcmzIwPOI39SKcQlIbNyQRuArdBsks?=
 =?us-ascii?Q?6XHGa7T2C4Dc6qEotSKDRv6TJNvQnGhj5R6xmqsHzV2q/w6PSp0cfgzMYmY6?=
 =?us-ascii?Q?rdZJhunL0QT1b2LIV2JfNhRSAvfkyu5kDjMHBnCQ0BBebLNHvO2PFd/8qh15?=
 =?us-ascii?Q?LW7XlI64hgdC5XlPNlStIxAyo7a77nebTrQPviw3VCLWcQyXpUmoBaxFaaPM?=
 =?us-ascii?Q?UxVTXaLqHaW1sJgDR9RRTFETdnmR5uefuVXbCpT6S4W9stFG+mT08zHU6Vpl?=
 =?us-ascii?Q?D7R0paLCysKa31JPtOGmAZLohtOCoGjlamc33mU20Gf8lvm1SfRDmQTliZsC?=
 =?us-ascii?Q?Hef3og6J2MK+kAMH9udgY9Oj+Zk29nRikz4yj9bonujQlG8vsd+YwPBJ3pT2?=
 =?us-ascii?Q?oUE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ef5a8c6-226d-42b2-6953-08d973697ac1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 08:11:51.6099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VZoj7NbIb9VMmz4fl6YqFxRqpeGHGw1eIEyqUsVsBwK7zw9ugfQrWq7MwcYftyZ1894q6Pk3OZmWm8GG7yn5QPL940QHCn5luDuefQ4dywk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5141
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 9, 2021 12:19 AM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Wed, 8 Sep 2021 17:30:24 +0000 Machnikowski, Maciej wrote:
> > Lane0
> > ------------- |\  Pin0        RefN ____
> > ------------- | |-----------------|     |      synced clk
> >               | |-----------------| EEC |------------------
> > ------------- |/ PinN         RefM|____ |
> > Lane N      MUX
> >
> > To get the full info a port needs to know the EEC state and which lane =
is
> used
> > as a source (or rather - my lane or any other).
>=20
> EEC here is what the PHY documentation calls "Cleanup PLL" right?

It's a generic term for an internal or external PLL that takes the referenc=
e
frequency from the certain port/lane and drives its TX part. In a specific=
=20
case it can be the internal cleanup PLL.

> > The lane -> Pin mapping is buried in the PHY/MAC, but the source of
> frequency
> > is in the EEC.
>=20
> Not sure what "source of frequency" means here. There's a lot of
> frequencies here.

It's the source lane/port that drives the DPLL reference. In other words,
the DPLL will tune its frequency to match the one recovered from=20
a certain PHY lane/port.

> > What's even more - the Pin->Ref mapping is board specific.
>=20
> Breaking down the system into components we have:
>=20
> Port
>   A.1 Rx lanes
>   A.2 Rx pins (outputs)
>   A.3 Rx clk divider
>   B.1 Tx lanes
>   B.2 Tx pins (inputs)
>=20
> ECC
>   C.1 Inputs
>   C.2 Outputs
>   C.3 PLL state
>=20
> In the most general case we want to be able to:
>  map recovered clocks to PHY output pins (A.1 <> A.2)
>  set freq div on the recovered clock (A.2 <> A.3)

Technically the pin (if exists) will be the last thing, so a better way wou=
ld=20
be to map lane to the divider (A.1<>A.3) and then a divider to pin (A.3<>A.=
2),=20
but the idea is the same

>  set the priorities of inputs on ECC (C.1)
>  read the ECC state (C.3)
>  control outputs of the ECC (C.2)

Yes!

>  select the clock source for port Tx (B.2 <> B.1)

And here we usually don't allow control over this. The DPLL is preconfigure=
d to=20
output the frequency that's expected on the PHY/MAC clock input and we
shouldn't mess with it in runtime.

> As you said, pin -> ref mapping is board specific, so the API should
> not assume knowledge of routing between Port and ECC. If it does just
> give the pins matching names.

I believe referring to a board user guide is enough to cover that one, just=
 like
with PTP pins. There may be 1000 different ways of connecting those signals=
.

> We don't have to implement the entire design but the pieces we do create
> must be right for the larger context. With the current code the
> ECC/Cleanup PLL is not represented as a separate entity, and mapping of
> what source means is on the wrong "end" of the A.3 <> C.1 relationship.

That's why I initially started with the EEC state + pin idx of the driving =
source.
I believe it's a cleaner solution, as then we can implement the same pin
indexes in the recovered clock part of the interface and the user will be
able to see the state and driving pin from the EEC_STATE (both belongs to
the DPLL) and use the PHY pins subsystem to see if the driving pin index
matches the index that I drive. In that case we keep all C-thingies in the =
C
subsystem and A stuff in A subsystem. The only "mix" is in the pin indexes
that would use numbering from C.
If it's an attribute - it can as well be optional for the deployments that
don't need/support it.

> > The viable solutions are:
> > - Limit to the proposed "I drive the clock" vs "Someone drives it" and
> assume the
> >    Driver returns all info
> > - return the EEC Ref index, figure out which pin is connected to it and=
 then
> check
> >   which MAC/PHY lane that drives it.
> >
> > I assume option one is easy to implement and keep in the future even if
> we
> > finally move to option 2 once we define EEC/DPLL subsystem.
> >
> > In future #1 can take the lock information from the DPLL subsystem, but
> > will also enable simple deployments that won't expose the whole DPLL,
> > like a filter PLL embedded in a multiport PHY that will only work for
> > SyncE in which case this API will only touch a single component.
>=20
> Imagine a system with two cascaded switch ASICs and a bunch of PHYs.
> How do you express that by pure extensions to the proposed API?
> Here either the cleanup PLLs would be cascaded (subordinate one needs
> to express that its "source" is another PLL) or single lane can be
> designated as a source for both PLLs (but then there is only one
> "source" bit and multiple "enum if_eec_state"s).

In that case - once we have pins- we'll see that the leader DPLL is synced
to the pin that comes from the PHY/MAC and be able to find the correspondin=
g
lane, and on the follower side we'll see that it's locked to the pin that
corresponds to the master DPLL. The logic to "do something" with
that knowledge needs to be in the userspace app, as there may be
some external connections needed that are unknown at the board level
(think of 2 separate adapters connected with an external cable).

> I think we can't avoid having a separate object for ECC/Cleanup PLL.
> You can add it as a subobject to devlink but new genetlink family seems
> much preferable given the devlink instances themselves have unclear
> semantics at this point. Or you can try to convince Richard that ECC
> belongs as part of PTP :)

> In fact I don't think you care about any of the PHY / port stuff
> currently. All you need is the ECC side of the API. IIUC you have
> relatively simple setup where there is only one pin per port, and
> you don't care about syncing the Tx clock.

I actually do. There's (almost) always less recovered clock resources
(aka pins) than ports/lanes in the system. The TX clock will be
synchronized once the EEC reports the lock state, as it's the part that
generates clocks for the TX part of the PHY.
