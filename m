Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6FC1405F2E
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 00:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245617AbhIIWD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 18:03:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:13928 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhIIWD0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 18:03:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10102"; a="217758753"
X-IronPort-AV: E=Sophos;i="5.85,281,1624345200"; 
   d="scan'208";a="217758753"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2021 15:02:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,281,1624345200"; 
   d="scan'208";a="607031007"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga001.fm.intel.com with ESMTP; 09 Sep 2021 15:02:16 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 9 Sep 2021 15:02:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 9 Sep 2021 15:02:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.102)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 9 Sep 2021 15:02:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbk961gmnfwQYJxy6cBAMak/RVhj1Hjch2N/97G/CnvLUrvvzvaxKaktQHTqPbyCljb7+MsprJsR1hbkef4L24lHfQrPJGF9POTuiyvTSg2Bkm/kdYWSHw3QPLrqTrFF8rGO6E7lAvbX93nbvZpPJpM+prtpFPEHVuho64o7ixPAH26VrV3uWB9zMyTykQxqgtupw9yILpAKVj3nL7+Ps+OBQKyWvmXFAQfym6Bywk1ZF55XMjlkzhDitfKrr7vUnPrIS/xb32OSt0KFeAP1q9ygj3BN5R+s1UeZ79jxBmfScu5i/KDbyoPD63XbnHpssYASADHVfQf3e/SSUPakCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bIdQcxoGe0dnieeo8ZGxHgYOe3p6V72eGRhUPj10B7E=;
 b=g2quEwlCNq0NzJTV0jr1WpL1JVKf0rF0HdhcLQHqB28wz1Ktfpq+c3o5Nc3QWv5GnzssdwZUrDepBXw+vdmPIGoGuw4ioAva567ZV3YIjPQlu8Mp3B1kb/xtMx20q8gnc7HNMSgewwDcsC2Cn2Ua495e2tI0n6sb6dZrQk9fBIXtXTQq0n//D8m8Rb4eIbohS56R/HX1xDFrbS6kKgjXKFSt/MnZPZ6NIBD9cwXeyX2/gSLp0l2TpEEdNQ30Vi7BYmZLA4qR1N9TnxziGcgL2ubDZvCMJEAkIIjB6Gi5utfsQdEKOQEcuL5fQkNiVLInmYttwPb6O/5imYFLn5yEWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIdQcxoGe0dnieeo8ZGxHgYOe3p6V72eGRhUPj10B7E=;
 b=cdAGcbGmOF1qRJo4CXZR6x87jseYlcyTagzZ+N+ODL13Z4s/bXhB/aMvJxtWNpBuwJ5DANBSvzghjYbO91cs2qqzUCguG1mgB0N0kc25Q8dpirg6xAlBT0CJhLW4Bzo0UQ5OycJXsxLAw54Zc00KqrvA2cE9Y7r7cG54ziLQzy8=
Received: from SJ0PR11MB4975.namprd11.prod.outlook.com (2603:10b6:a03:2d0::23)
 by BY5PR11MB4194.namprd11.prod.outlook.com (2603:10b6:a03:1c0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Thu, 9 Sep
 2021 22:02:13 +0000
Received: from SJ0PR11MB4975.namprd11.prod.outlook.com
 ([fe80::8d4:a28b:26b6:e8c5]) by SJ0PR11MB4975.namprd11.prod.outlook.com
 ([fe80::8d4:a28b:26b6:e8c5%2]) with mapi id 15.20.4500.016; Thu, 9 Sep 2021
 22:02:13 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "yongxin.liu@windriver.com" <yongxin.liu@windriver.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH net] ice: Correctly deal with PFs that do not support RDMA
Thread-Topic: [PATCH net] ice: Correctly deal with PFs that do not support
 RDMA
Thread-Index: AQHXpcR4A6Zxkkm/5kK6iDoPUIa3IqucQNUQ
Date:   Thu, 9 Sep 2021 22:02:13 +0000
Message-ID: <SJ0PR11MB497570D18E7F08AC4E4186F2DDD59@SJ0PR11MB4975.namprd11.prod.outlook.com>
References: <20210909085612.570229-1-david.m.ertman@intel.com>
 <20210909144833.2ca0069d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210909144833.2ca0069d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eaf909d4-1003-43d8-f433-08d973dd7b0a
x-ms-traffictypediagnostic: BY5PR11MB4194:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR11MB4194D614D67918D8F3BEDE03DDD59@BY5PR11MB4194.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VGOxJcW1P4zaD5kQe5q6T1WPHmZfW2g3fIc4PVtIHFDOD4cFjRv6JkR3L5ZjDIOllevWbZS7wTQdNenQ6kYdslZEw4Bya/lyz6G6QlFZqEpeJapoBQ48diKSSr3EAhZ8L3I8Z5C9D9bJRj+yNDanaNwIXN7mZxZ+8sf64Ur7t+CtgIZZj4zRhkGMTSXJeg7wOaYsxIXzau5IzAVi8pEcc2NnWkO7W3LeshDdg6epQTBDDigmE3T0rlIZy9ttoj117D3CZdvV9PtAWU08wR3GsRMVTYj11p6nX7Di1shEpjk6uCAAyQ1vB764hXyTdX1AWs6W785osm7BxVNGFq47tgw1r0UcuEsH0dRW1WK3Z4VytWm6bwt/JCy1BY8uSP7nDZCo2wQyHZC+2L8h5jcWeLzTnURJzzvYOdJAmhP9zthpP3xN+bWnBuW4ZMJEgh6fMLr0wmbR4ERyB7J7n17DxTURBEWouQ1VLBSFBV1ukcbYJd1UB3uStvF0cRNIsHXQ5ao/XrK5Y13l8xhbwO4TLI/6ghj187uLYu+vg5eiSAcfWdZgojSgQmBRk7/Ya9/wKKTiq/wxBGKevzu6oJuHKR1Ts1ntVydOi3/TB6JC629GReIogbtueC/lPWu46oQIHhhCBvsUHM/KrcR7VJdAriIkyuxbi3YVHeklv+dYOpovU5IBJDf5q9xguOGM/cVLm+D/BrCebznljZsMo0Tjfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4975.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(38070700005)(186003)(66476007)(86362001)(52536014)(2906002)(8936002)(76116006)(478600001)(7696005)(54906003)(6916009)(6506007)(316002)(66946007)(83380400001)(5660300002)(66446008)(9686003)(71200400001)(8676002)(4326008)(33656002)(53546011)(38100700002)(122000001)(66556008)(26005)(55016002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?IdJtKzHstfDvnTMuMXFMcX6dEzemCvkyAP83PIO+4qoBfvmk5AbY7Jx05OSM?=
 =?us-ascii?Q?tk0we+ITMaRfUycE0acfecc9pAu8Sh1uXITNKdWARFhtcMzDh3Sqm1ILNN82?=
 =?us-ascii?Q?MMUhBRFbpTT5EP5p0eRYkK/7pn7fk9Rb5IT9CoDYSqDG+kK3oOXWsulzVNa8?=
 =?us-ascii?Q?cFkcmPxxumspOJwQZRDv2kBidHRb7cHMJqdEffJ7/uWuiu+poD08/SgMlTlE?=
 =?us-ascii?Q?v6jLjZGWRp+RtZTVq1kBdnYZiUsX/ktZi/NgDe3HbBufmt2bxpMJnMabJ8P9?=
 =?us-ascii?Q?o7EDRzdGYkrBA6/aTzcSzjiq0M5Yn7SMLQFBhbEmnqQRdEyymThZivmglM8U?=
 =?us-ascii?Q?vP2Y0o3S25iQs2MwQO8PtuhrzxZSRxRlgPBBZVGUaxPejgTg9etw03LAobk9?=
 =?us-ascii?Q?+6CLjwhN79iTryG42GNFFpsL+B72Olp1bLx8cHhAbfQRG+PxhpjBQo6ba4bz?=
 =?us-ascii?Q?KnZWKtMlaZ4XfklS6twA6KXMXNztH+GA9AN3FG+zELrJa528sOhguZCslzDn?=
 =?us-ascii?Q?Rl1p3PzEt8RRKLAOCBO2PFbQHSCfWiwcfeoPcfZDQkN2m0amyC/wVdY5E16c?=
 =?us-ascii?Q?iKoN1pYzWPj0A3nI+nhrTBnYc4IoLPSEVv59dzfEtbL4NbbY4HUwXdAlGlLp?=
 =?us-ascii?Q?jSl+FTY6hnvOj0uvRogbtQkXgPz1xyHzz5dWiS/ewSPtNsPXIGUuJ+4wCRs7?=
 =?us-ascii?Q?N3vwAT/MKWsYRIEJYDgob0zorP7NPx8+WMu9FuzNf3LoQni6rJ+L/NqUBwLT?=
 =?us-ascii?Q?vs+tR42EI0JcdoMGb5Rs1uPkRTxb7hzXzPn3ArqcfvtLIwmPQ/0VWXAC7xTA?=
 =?us-ascii?Q?XTeTT2LUQjgIbLRGz7TnMM10bDIkseScDGgcBSsl5ef/Fq7EMx19QLjZNrlE?=
 =?us-ascii?Q?oUVxQ8aVsB0Nq2DBMy86+hVxCBR1V1nLgm11aQUZnjfhuLINKGLjLL9oMvBH?=
 =?us-ascii?Q?UJoWArEACkponpT7y5RCeH1CJGGxaaTwFm1mPV53ecyA3dDDwHVI1cAwprTA?=
 =?us-ascii?Q?qqYWllnHg3zOBIvZT2rwKU2VUxK+TL7pFsiTXD3Sl+Xoh41KJqG1HX8WwuLg?=
 =?us-ascii?Q?aAvz5T8aMDRoQVWA5Uj4fjc9dv5sm0rMPqY+YoHPyEBU/RCIyiYau7Jo2WMl?=
 =?us-ascii?Q?sEZ9zw13TKiEU1RQTUm1tz5cd7gqsJ75HEEIHgjXhTWGtnb0FceLwJAkqzdh?=
 =?us-ascii?Q?ZfWfIVKhUFK90P1MwkEvJv64bvW39Y9G7w4HPoeZe/VaYytOjgzGoFeP+opJ?=
 =?us-ascii?Q?U3nYuJHc/sduPNoLQbm/ZqNxrHDA07fXXnaTYxffgJfvpeeYFvVxOjIQL7s3?=
 =?us-ascii?Q?yFk=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4975.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaf909d4-1003-43d8-f433-08d973dd7b0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2021 22:02:13.7553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yzOZ4aeSyhCc02av295weiZeDikuCwoHihAd5xS0oO7ejkS7i4QN5bRmccalXoi4I4XUviLmr/TPjZrX61escrTA2N17mdwni8we/rTiKUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4194
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 9, 2021 2:49 PM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: davem@davemloft.net; yongxin.liu@windriver.com; Saleem, Shiraz
> <shiraz.saleem@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> intel-wired-lan@lists.osuosl.org
> Subject: Re: [PATCH net] ice: Correctly deal with PFs that do not support
> RDMA
>=20
> On Thu,  9 Sep 2021 01:56:12 -0700 Dave Ertman wrote:
> > There are two cases where the current PF does not support RDMA
> > functionality.  The first is if the NVM loaded on the device is set
> > to not support RDMA (common_caps.rdma is false).  The second is if
> > the kernel bonding driver has included the current PF in an active
> > link aggregate.
> >
> > When the driver has determined that this PF does not support RDMA, then
> > auxiliary devices should not be created on the auxiliary bus.  Without
> > a device on the auxiliary bus, even if the irdma driver is present, the=
re
> > will be no RDMA activity attempted on this PF.
> >
> > Currently, in the reset flow, an attempt to create auxiliary devices is
> > performed without regard to the ability of the PF.  There needs to be a
> > check in ice_aux_plug_dev (as the central point that creates auxiliary
> > devices) to see if the PF is in a state to support the functionality.
> >
> > When disabling and re-enabling RDMA due to the inclusion/removal of the
> PF
> > in a link aggregate, we also need to set/clear the bit which controls
> > auxiliary device creation so that a reset recovery in a link aggregate
> > situation doesn't try to create auxiliary devices when it shouldn't.
> >
> > Fixes: f9f5301e7e2d ("ice: Register auxiliary device to provide RDMA")
> > Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>=20
> Why CC lkml but not CC RDMA or Leon?

Oversight on my part - thought I had cut-n-pasted all of the address=20
in my git send-email command.  Will send again and correct issue
