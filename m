Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5585A43CA80
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235191AbhJ0NYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:24:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:29870 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhJ0NYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 09:24:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="230105394"
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="230105394"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 06:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,186,1631602800"; 
   d="scan'208";a="537558111"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 27 Oct 2021 06:22:00 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 27 Oct 2021 06:21:59 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 27 Oct 2021 06:21:59 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 27 Oct 2021 06:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9On2goceEF2EWS+SkIc5rcXoep2VT4NR8EZT5QPXYg6GbLQl467dnZH05n5B+YfoD/xJJzibwc2foSm0Ff3zYvxM2yCMVrKBrvwpPYCHUbtynRswGJWP/zKRAi71RFwIzO4ycgTsUJI2E/LlPm6OmHMl1oLYX7uAWAAssFywmJsyXuN4RtmxeQ57R82WTwhDIocfPDdmGdW05HdJ8xaqWSK82cVnLzYTR65yRU9UoSB2z8BIEMS76FAf1SsozsfIh2yWsdeYQrTubPRCM777WUzmOFzkSizu1ki9CdlsmEDdJpYtrXEek+nVpb3G50ial5CXMN4Dd3t35/0dHKijg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7twgqxV8dLIHXgWlp745al1KIi3x/x0g9TMhdpqEXI=;
 b=Qw6JwGwFBoT23PwyaKi3PRm6l+amFpfH/CFe5tKT2LxlZZR+QQ81nyfPNdghjQ45v+ibkwD31L315QpKGcGW36zc8VSkJCeQ4k2c2SyUU5EQWHu5k78lLt/yEbEEnTwYsI8DHd6AJn9rpzzuCr3T5f2MkWrnZEu1k8lWlWyLgzz4gTWiCI3tkJT5o+Q9Q+c/ZkUQ9sWHnqdrYRMj0dVXyCvGjBI8jQ2gn092nzWHK+JziZ8yckusdV8P+nql4S6wGIW5wuwgjyR6ViiN7O4kjmfJYDssFIPqt2BNYDfiStpnVXiJCCLbOpOgCbiXYXwF6Ke5MSCiLs6UpJQ5xH4ohg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7twgqxV8dLIHXgWlp745al1KIi3x/x0g9TMhdpqEXI=;
 b=YqYRryUWigU79agddDfg7kPC3mb+mbNyJomzMDQVOLjKNH4aMLbr0TQZ9bLbUXffHaeSnhPRsz8vJF6HNTEVF7MRR3bAXhMznNruyzDpWGGOijjdofskcFqVfS6AGK3Vj/Dy5Cuqzw6nIkO+Lh0h2sWT+lAT/UP9DLPyDugPuhs=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5927.namprd11.prod.outlook.com (2603:10b6:510:14e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 13:21:58 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::7129:76c3:12b8:de49]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::7129:76c3:12b8:de49%2]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 13:21:58 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
Thread-Topic: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
Thread-Index: AQHXypF0qbvmrrSvGE6wNeD0sLdJiqvmaJ8AgABr7yA=
Date:   Wed, 27 Oct 2021 13:21:58 +0000
Message-ID: <PH0PR11MB4951A17040D860D8AC6975C1EA859@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
 <YXj2oKjjobd0ZgBi@shredder>
In-Reply-To: <YXj2oKjjobd0ZgBi@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: idosch.org; dkim=none (message not signed)
 header.d=none;idosch.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6a674fc-c07f-4220-7278-08d9994cc137
x-ms-traffictypediagnostic: PH0PR11MB5927:
x-microsoft-antispam-prvs: <PH0PR11MB5927029E8645C8703369EA7DEA859@PH0PR11MB5927.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Btj36XKSW4tl3iJm5MqlDMcazCoM/onm47Ekk0m4pocr8MwleAxj3qp3tP7jj5hF4QGT1O+sc5uxglAWhXlFcANqNGkG+uqQm4WpRdidx6fUzvfJZZ20vQ54EQNxpWT2NsLCJ9oJXVUDtPnB8Hh7btZa8OPB55emFBSzzQWuOOgGHEtYrdK6kN6D3aNQ5D0Gcx+Q/2LIJzxsZbV8JnJ0vTQk1Ei1+hSRqeX36wUmfc4cMQqbiuvDSNfLBnAAOVYcQb1tJeen+Vu3EPZaxlvm/W6hGXwuatBNPzZ5BuMO6Zgnsmhb4q07/osk/5J2UqYvcM1BDN7e11KRynplWZfvXEzh/gQJJuWSWDao7gDwRoXjRX1v2UuPvUsXnA/4sA1GTJ/00OGmtsHsGdgMTTWRTas/BM7U25BI8I9DroZYnpM6AHoD4ZBt89JH7+3fJlS0Bs/jp9VfGXhxGzqlRkhr3G0/rzZzUqvebKa2abLtJ21YkaUs716rK5LoJzGoVVWO3Yft4NBf5l5tPEglNtplHmL5V6jBQqFrABZKmXNa070PQsbcJSzWf5SLWvSIDeS2Ne+Gfu17KVUzMfFvVgs79KE9AP0y70m5atngR1fiIigBOqwX/4nYnz7BtU3fg4CSqgtna/7ZqTFm1bzPph7uuJ3n3Rw4TQNSQdt9cBEgfCXEfAgSBsg6E1/qOqKfoQQ9T7ridiQFArMyLy4V7mhfjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66946007)(38070700005)(186003)(66446008)(9686003)(8676002)(66556008)(64756008)(76116006)(316002)(508600001)(55016002)(4326008)(7696005)(38100700002)(33656002)(6506007)(82960400001)(2906002)(8936002)(6916009)(83380400001)(26005)(122000001)(54906003)(7416002)(52536014)(53546011)(71200400001)(5660300002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Ae+55r3M6RiyljgZTG+dHO910MIDXbGBcM0B3OTQGlVFOQpO/sSrTPMF3Dj?=
 =?us-ascii?Q?X5RcocBeIg7pyVjPbTIsZAAJl6Y0K0AQgy16RjytGgGmlBgYHIwMIfcB4Yin?=
 =?us-ascii?Q?j0NXZz/9DPP4mvERHboPTXtULW5YEy7Nl8atm0aa3+20QNutE62vQgCUaZDJ?=
 =?us-ascii?Q?zh+58VOZCweqUuRYZ1zdHLtpgkdp3gb5CAYH4ZEathqursvzrPakvwC++/br?=
 =?us-ascii?Q?VuRdPUR48NdBiNQ1UJSnbKDZXHW16CxwFYWYknpcq8Co2toYCe5py8Hv15aW?=
 =?us-ascii?Q?2d4kfoU7/w0DGJyy/6CtNFlMIc4U+vg440WqUmi2xSjOhyvIaVx/XAlmfEZI?=
 =?us-ascii?Q?qgt79rOYPzTCZF+flTgFwim7ehxeWIXtkhaA6zkJp14HG/1mOp6orSFJVAsA?=
 =?us-ascii?Q?DH/4l7de0kujIOhCguo5JlxRir25OUlfF7zqJHtST7wYYbdDsA5dEGSRzb/h?=
 =?us-ascii?Q?M5dZCMmxmAbSmfB2wlPsQcafGFFw3Z9EuFyt6ycEWsNdKRmq9KG1L59V3FY6?=
 =?us-ascii?Q?s9A/Fb3chDKPutrLdmQRNzNStGzK1T+v/uLEmd6YankXhMF5Pfi4kD0+/iyg?=
 =?us-ascii?Q?AAW+Nbn+w1HqGmHFCzu0HmVxZ3Ub0RxF2uMFYyULIhBWOhBrbcbOPopas2hf?=
 =?us-ascii?Q?C0QByRfhauAQwBYSOxIm5TpwTEbTSyLZpX6SajboQrtaoAoVOJHiHmYrb0Vn?=
 =?us-ascii?Q?zHKnAX7y1eFV36qqiNfAEhSZdx8unLdfxqr/gzBRd2XARwlfLs07+3Yg9nHK?=
 =?us-ascii?Q?U6KFHOu9nb3zlojgej3VWMqX86ttCmvI7aKrMeBhf50L1O5Z2ESqF99oX556?=
 =?us-ascii?Q?1tzTapYcjC4xUE9pQFyJfBC0ReFBEHCtzg8tGVMzR5tiEPhdfMmDN3yij1Sj?=
 =?us-ascii?Q?p3NYptQNNgj5tDG/NQ3gXdaqQoykoZHXj0Ubtr4241jWOBVC3b+OiixV6/nM?=
 =?us-ascii?Q?3Lhz+4VXbKEvM16ue0JPqaxN0XhN01809auWjiyhA2IM1agZ7QenSDdJspGi?=
 =?us-ascii?Q?YFYZM5YglsP9i6V8dNQGcZTE98khcjrnu2pizKevF/6KYel8lrOw0diYbojZ?=
 =?us-ascii?Q?HenY+/d1bPXQCnbgQMwrzB9xahd3IrPt/I/Qz/XCQgQgB95uRr8ew5/LgK4H?=
 =?us-ascii?Q?Kt2bOYfncGh9JrnBehxk0wQLifFOns0ae+uRJ+qDOwKRe+g8XhZcWZr87tGX?=
 =?us-ascii?Q?8OXNcxyPqDmnCyuSrlR+1islrCC6Hk/nR0rm8MpWtWljYF5THZFWD7vrVZS/?=
 =?us-ascii?Q?5NTdXtpIj1+e/RmwVx7rfN1IqlJD+0esoxqLAw52QwT+7oKPrQo8/PhUIRYW?=
 =?us-ascii?Q?LQwHbUBpP0LaNrTrT784/oFW5B5ceU0gBRE1/xNuJH2GTHZJMvX3ngDu+HIV?=
 =?us-ascii?Q?we4RjUfT1E8D5j48kMwsJJEqb/W/YWmDhUtaERK90zQ1CTezI0tPiXJAkW5c?=
 =?us-ascii?Q?vwmYaDZUaRCFrvkdgT9q8MwXbleBHKbh+ycWwvox1TTWlgvFYJC2Y02LWPrK?=
 =?us-ascii?Q?QkkpHqqfDuKxdMFZBpZkigqIZmYBaCawnoi8xbQO4PDUFqQgStBBUvh5Pmbu?=
 =?us-ascii?Q?h2QgoVICJrl2YNO1z8biQcCCq6mrV0peSENWS1LEKD9vKFdAiGEmKAISkXdg?=
 =?us-ascii?Q?ZjbImDVuwkvWZshNmFjng+tYyZ9s5XTgKvr+QgTgz0Iof6V6ogAOC+l5HbYW?=
 =?us-ascii?Q?r+J/RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6a674fc-c07f-4220-7278-08d9994cc137
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 13:21:58.6343
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yyRKasFSmc6296nTtX1+eaTVHAS6R8NZvLHs9+OqFaY43f3IwQtW+p+r3t4dYdlOV6ZY8BFZy9OMPwxeTSZKDbcgN9sYN1HUiypbzMrcp/E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5927
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ido Schimmel <idosch@idosch.org>
> Sent: Wednesday, October 27, 2021 8:50 AM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> linux-kselftest@vger.kernel.org; mkubecek@suse.cz; saeed@kernel.org;
> michael.chan@broadcom.com
> Subject: Re: [RFC v5 net-next 0/5] Add RTNL interface for SyncE
>=20
> On Tue, Oct 26, 2021 at 07:31:41PM +0200, Maciej Machnikowski wrote:
> > Synchronous Ethernet networks use a physical layer clock to syntonize
> > the frequency across different network elements.
> >
> > Basic SyncE node defined in the ITU-T G.8264 consist of an Ethernet
> > Equipment Clock (EEC) and have the ability to recover synchronization
> > from the synchronization inputs - either traffic interfaces or external
> > frequency sources.
> > The EEC can synchronize its frequency (syntonize) to any of those sourc=
es.
> > It is also able to select synchronization source through priority table=
s
> > and synchronization status messaging. It also provides neccessary
> > filtering and holdover capabilities
> >
> > This patch series introduces basic interface for reading the Ethernet
> > Equipment Clock (EEC) state on a SyncE capable device. This state gives
> > information about the source of the syntonization signal (ether my port=
,
> > or any external one) and the state of EEC. This interface is required\
> > to implement Synchronization Status Messaging on upper layers.
> >
> > v2:
> > - removed whitespace changes
> > - fix issues reported by test robot
> > v3:
> > - Changed naming from SyncE to EEC
> > - Clarify cover letter and commit message for patch 1
> > v4:
> > - Removed sync_source and pin_idx info
> > - Changed one structure to attributes
> > - Added EEC_SRC_PORT flag to indicate that the EEC is synchronized
> >   to the recovered clock of a port that returns the state
> > v5:
> > - add EEC source as an optiona attribute
> > - implement support for recovered clocks
> > - align states returned by EEC to ITU-T G.781
>=20
> Hi,
>=20
> Thanks for continuing to work on this.
>=20
> I was under the impression (might be wrong) that the consensus last time
> was to add a new ethtool message to query the mapping between the port
> and the EEC clock (similar to TSINFO_GET) and then use a new generic
> netlink family to perform operations on the clock itself.

Hi!

I believe we finally agreed to continue with this implementations (for a
simplified devices) and when the DPLL subsystem is ready, plug it into this
API as well using the discovery mechanism. As there may be some simplified
solutions that would not use the controllable DPLL and only provide the
status (i.e. using physical signals)

> At least in the case of RTM_GETEECSTATE and a multi-port adapter, you
> would actually query the same state via each netdev, but without
> realizing it's the same clock.

True, yet for a given port we need info whether we are locked or not,
so the interdependency wouldn't break anything.
=20
> I think another reason to move to ethtool was that this stuff is
> completely specific to Ethernet and not applicable to all logical
> netdevs.

That was an open in previous discussion. Wanted to first show the
full API to discuss where it fits. I believe all other networks (like SONET=
)
may also benefit from having it in the netdev, but am open for discussion.

Regards
Maciek
