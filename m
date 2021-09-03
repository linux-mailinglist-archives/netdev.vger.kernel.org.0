Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6AD83FFAA3
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347333AbhICGvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:51:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:49969 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347003AbhICGvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:51:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="241629470"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="241629470"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 23:50:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="447474110"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga002.jf.intel.com with ESMTP; 02 Sep 2021 23:50:15 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:50:14 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 23:50:14 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 23:50:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WO4oA5TN5drN8kgaSsTTBBO0A1lAVz6ItAOtiHysDorDBF/wDFe3DqF2dlIxEROBxB2UePzAMZlucL47bThoRZj5PizalDtNt1B/kHw6Boj3qO/Yn8G0Q26+4K0uDr5TRUhbNFuuzv8s0FN+0vwbTCCelaI8o2vYaFD+rUUg9KILZzXNSGJHcSTGW4yoMIjlEToEJ8xUm+2pj6+82PpvlMYEDPJmfpP3Rb7xJ4Wx5APOsC14nXne4+f+jiS+L2TY8wjpxz7+l58tqyWq4lmS6HsxnXp37wP06/RxotTBDvJMAqKSLzejJ9dkA6nLyFu5l1pJeeF3Q0AsVlpJKsgRrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4beWbhDUJuqEvO0Ymkg+XurLP5UZ7vVeclH65Hzn3gY=;
 b=JdgL3m5aEnvtpCypPqWxmNKSk7C1QbZEkW8sSSUVbocS6B0Za2OiqGaALHmlfIb/YnuY6F5mvmEV+3JsNcPRKItr6ORBz1wWEWv1ac+iP0rzSWHGTH7cL8ckiKF7zJtLl1WSmPBWDXpzW+9N8B0BGYiPg0CbXCsUCbuWmZa8a5BHYk3RLISIURGeOkgYcdx/UDCFPHmMQug7+abTZmFijMjDLtn2dr4QBsD084k6U7m7sI0fH0tP0qucSW4OVYeoMheXVSrOfGXk80c0EUl0/jEcn+0NHarj6OqMOfqzZepv2e9lor0v6q+0pMIWAz0eU1CmGU/mddMbFjNFT5QCRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4beWbhDUJuqEvO0Ymkg+XurLP5UZ7vVeclH65Hzn3gY=;
 b=GMUQJym/YUP481+TxhScOmYyJmUZGpn/7MMHzxjzzzs3Y4Vtzrli1f1h864lpz60xvlBJQsbGN5eE2ewrhvKimef5FxStZAi2+2m4GLRwWA+b1aSJlqQe5ljjqp5MRmi932NcgMKVWFGDA5dw3B9EmxANovSVU/d9ScIAifDaTk=
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by PH0PR11MB5031.namprd11.prod.outlook.com (2603:10b6:510:33::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 06:50:08 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885%3]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 06:50:08 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "joamaki@gmail.com" <joamaki@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 7/9] ice: optimize XDP_TX
 workloads
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 7/9] ice: optimize XDP_TX
 workloads
Thread-Index: AQHXlPQBWzZmA3JPVECA71xdkOc3hauR9RdA
Date:   Fri, 3 Sep 2021 06:50:07 +0000
Message-ID: <PH0PR11MB51448A83D389CE43D822D72EE2CF9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-8-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-8-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3556792d-b540-47c3-7a50-08d96ea7116a
x-ms-traffictypediagnostic: PH0PR11MB5031:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5031C63CA947A44FAE54C083E2CF9@PH0PR11MB5031.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yuIHXMatPvLq+L7cHDUS/Xfjq2lZO5tX6gNlXGbVbOTmaz1YPzMURU0z2WUklzG5rRxAdUAXCb5yXoQ3cPnLmumAwE5K9NNEw3SkyqnCi78QkIfRe/oELNwoYVIY8j4UqYSvR+lJgRQCu8OynXsMCDHA5hdWv6rOnW1CNMYxMhK8EFju+BGsDUzVPXQm4Ftrhoxotl740uxFTIXJo0QFIG4WE5mh+DZSzwStQFy4Tp88ZpBHEqOrD9qDFOqBhhcYPNwYMlkGrtn9rLr9HjtzbeDJK9evlL/Neur6MXZQsWSv7ATn8rqZhVBL1IdOpk45i72Jy8/0mWg0r2dHzqASnd1iAUqMIAOt+Zlc3xUqsnnDlDItQ8YAohoaP0LhJd3LCynd3eM0/aiRYw7iJJCBmee99bQCwZwF3VuS2LJpeTPzyCr/b+Xtx0O5CzW1VEpHFxm/Y9i2tbBwoINzr8taMAH6SzGha9LFku/rlZTmxzYFvFuGoonECqN+jE4rnRHkEuKZ89zKZgCfSmPfXAOSWkdna/2D6Kfi2A4DCas/sU11z7y5fZI+CfW7CFVOZJdKe5Llr9hPvpj96bK95SwisP5xZIgu6V8Akc/GKUjpgCYn1x+PFI6UKD8iFx8fq7MlPA1LSzNaKSoUqFcZ+4Ta9+UNOwgyjfS9XcDSUiJprwg6XlM4UKhuiwAADb/vBfYISnj9qoIs7pOVaBtMV5EfYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(9686003)(66446008)(38070700005)(76116006)(186003)(26005)(55016002)(53546011)(107886003)(54906003)(4326008)(2906002)(122000001)(508600001)(316002)(110136005)(7696005)(71200400001)(66946007)(5660300002)(8676002)(66556008)(64756008)(66476007)(6506007)(33656002)(52536014)(83380400001)(8936002)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jpH2kxW3fCOirgvYROXeIlx+WcpKvUE3RYpo+JkPRfsZFpzRYJDTcxU8LWBc?=
 =?us-ascii?Q?EEX0CM3TVCqvpJj9SAYdmlTl+OfeTIvPoD/h/WWZfcFswn+ikeQeQNkF0ek/?=
 =?us-ascii?Q?HT2wcrQzTjJaR4uzRnneN+GJJhoxJDwBlbKlhh0bzqlGaPzPOWUM1fCGd/Cz?=
 =?us-ascii?Q?HRZWnD+lKaI7N9cT7G5kB0wnRxFFKE3ce/UAzqxpd/p0a6mxkpmBfLc6CYwq?=
 =?us-ascii?Q?pc/hfBU0j85baxFTC/ylAAZ/G1MAJbKxLwwosA26ZcTMSo+5QjnxOk+CSj0B?=
 =?us-ascii?Q?Rpe/WgaRM3a4Trj+Fxxu/gQGVgszDJ2R76AdwYzwkT9/QPCtcjJgzD+rdBoc?=
 =?us-ascii?Q?x3EO5d9mYqAOzaYi4nhG04w1aUitugYMm7TCFaZAYALtHjD99rjOFS9hRgpE?=
 =?us-ascii?Q?4147WKo0qNnGRRnoO8OaFYbG0rWBaaC0veVHQC14h2tsBrraUENl5QXtJYOm?=
 =?us-ascii?Q?3yrtVv5L3wYes+eWJedq2qX4nom+HQGgsnMSjigFR6e9Izvy4BNwSJvJZGLs?=
 =?us-ascii?Q?WQ3fFtfhi542pAST8KpG406c8gV45weiiEhzJqInIgrCkYe9a4/jmCtgaT4Z?=
 =?us-ascii?Q?Bad40tDBMeeko2f0QOom5z5r1nmM89tzcKgbtM3/BehhDLexX5PjSrZr+Fni?=
 =?us-ascii?Q?vxO0pm9ojc1OtwpumSqTlsXqgo4jLqVXmnO6Sgb/GWYGF5W+A9INNlpRlIsj?=
 =?us-ascii?Q?wtcvyaXas+prsp+LxV4lCJwpUY4WMkWfwg5penhWat9omKnimIKNokQ3UG7t?=
 =?us-ascii?Q?CR1Kg6bGRErO4eBshjv42BOL9mktIxuU+Wy/iEFDwjvV5Fj0OUJZrXQpHRqq?=
 =?us-ascii?Q?tMMgOa2Xmv5tpk/BCfOcDEbA182Z7R3YocJTPPgCr9Bibk3IFI8R2d2lMDSE?=
 =?us-ascii?Q?4ME9GyWlBDbVrIAmffc3yIzlHzM+5xicgKeC7xAWgnHsvNWtSCE8X+hBzWB4?=
 =?us-ascii?Q?+OiZsnH0A4Yd7gmssPrr6urt6dYuzr1HMuMQLfgECeA2jAMrh6aaNaSGI9kP?=
 =?us-ascii?Q?fPViEZt0m33wECDMbFjC2ybppggjWBatGeKgbKJajHOXGj01EsvXT+7dJDhq?=
 =?us-ascii?Q?rBQIwNEmaxM2BLs9CQR4//x+MuR1eiBS3v63TnNoSjvHtiu4AAd4mR2qgX4Q?=
 =?us-ascii?Q?0pULgAQvhsJ+Ggbrx9gHCIM9xlLEwCT1dqlneaSujHsRq1GMRQSWtDWNunIX?=
 =?us-ascii?Q?EbgY3lfGQ+VCZg/VeHORvehVNZkcX5+yoHoc1iDRsxhzczzda7KBCFPtfAU7?=
 =?us-ascii?Q?nNyFe0/CkcthdPiw3MKQ7SxCpB4WWi2qDlTiH918W/tWQhoXOvWKaJGS22eA?=
 =?us-ascii?Q?P1oBeS2/WiS+QBglWyds2AIO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3556792d-b540-47c3-7a50-08d96ea7116a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 06:50:07.9594
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y1KqK3fNcdb5lF8+nurlk4PrXrXqp5kjR7OJOKYLidV7pGAtnpNiQezdwnMAj0lH8EwUuRIIL9ZZqyXwWNdwI+FLtS56+VB6fouNQuABv8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5031
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org; kuba@kernel.or=
g;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 7/9] ice: optimize XDP_TX=
 workloads
>=20
> Optimize Tx descriptor cleaning for XDP. Current approach doesn't really =
scale
> and chokes when multiple flows are handled.
>=20
> Introduce two ring fields, @next_dd and @next_rs that will keep track of =
descriptor
> that should be looked at when the need for cleaning arise and the descrip=
tor that
> should have the RS bit set, respectively.
>=20
> Note that at this point the threshold is a constant (32), but it is somet=
hing that we
> could make configurable.
>=20
> First thing is to get away from setting RS bit on each descriptor. Let's =
do this only
> once NTU is higher than the currently @next_rs value. In such case, grab =
the
> tx_desc[next_rs], set the RS bit in descriptor and advance the @next_rs b=
y a 32.
>=20
> Second thing is to clean the Tx ring only when there are less than 32 fre=
e entries.
> For that case, look up the tx_desc[next_dd] for a DD bit.
> This bit is written back by HW to let the driver know that xmit was succe=
ssful. It will
> happen only for those descriptors that had RS bit set. Clean only 32 desc=
riptors
> and advance the DD bit.
>=20
> Actual cleaning routine is moved from ice_napi_poll() down to the
> ice_xmit_xdp_ring(). It is safe to do so as XDP ring will not get any SKB=
s in there
> that would rely on interrupts for the cleaning. Nice side effect is that =
for rare case
> of Tx fallback path (that next patch is going to introduce) we don't have=
 to trigger
> the SW irq to clean the ring.
>=20
> With those two concepts, ring is kept at being almost full, but it is gua=
ranteed that
> driver will be able to produce Tx descriptors.
>=20
> This approach seems to work out well even though the Tx descriptors are
> produced in one-by-one manner. Test was conducted with the ice HW bombard=
ed
> with packets from HW generator, configured to generate 30 flows.
>=20
> Xdp2 sample yields the following results:
> <snip>
> proto 17:   79973066 pkt/s
> proto 17:   80018911 pkt/s
> proto 17:   80004654 pkt/s
> proto 17:   79992395 pkt/s
> proto 17:   79975162 pkt/s
> proto 17:   79955054 pkt/s
> proto 17:   79869168 pkt/s
> proto 17:   79823947 pkt/s
> proto 17:   79636971 pkt/s
> </snip>
>=20
> As that sample reports the Rx'ed frames, let's look at sar output.
> It says that what we Rx'ed we do actually Tx, no noticeable drops.
> Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s t=
xcmp/s
> rxmcst/s   %ifutil
> Average:       ens4f1 79842324.00 79842310.40 4678261.17 4678260.38 0.00
> 0.00      0.00     38.32
>=20
> with tx_busy staying calm.
>=20
> When compared to a state before:
> Average:        IFACE   rxpck/s   txpck/s    rxkB/s    txkB/s   rxcmp/s t=
xcmp/s
> rxmcst/s   %ifutil
> Average:       ens4f1 90919711.60 42233822.60 5327326.85 2474638.04 0.00
> 0.00      0.00     43.64
>=20
> it can be observed that the amount of txpck/s is almost doubled, meaning =
that the
> performance is improved by around 90%. All of this due to the drops in th=
e driver,
> previously the tx_busy stat was bumped at a 7mpps rate.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c     |  9 ++-
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 21 +++---
>  drivers/net/ethernet/intel/ice/ice_txrx.h     | 10 ++-
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 73 ++++++++++++++++---
>  4 files changed, 88 insertions(+), 25 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
