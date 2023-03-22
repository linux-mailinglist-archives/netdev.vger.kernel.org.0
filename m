Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467716C4F3F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjCVPSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjCVPSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:18:08 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C99149CC;
        Wed, 22 Mar 2023 08:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679498284; x=1711034284;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NqVrJbLZN6LKsGeYY9+KaOAhlYLDBBntsrgLSoRjYIU=;
  b=MR2vS7NFqp4puzldSQaDcTzklnE3Y0KCMgWzG2wN6mBudb/XMLFk9BDm
   PNazCc1oIslh3hUIpzjuSbCq3SczSQ5RP4PVcWxDK2SG9AeLf0uXKB6yt
   Y2q9z66jhiyfL7iXpNcy89PmYgr4sSCGqDgGOwdZ5IHcotUcddjxGWC4W
   8k+onC0krXe5aVfp21GR4YQMInMTqFlIXMVKwPpZogrQKQ1yZTrscakvr
   l90MsEGWUMlwz0vL9XEVpqS4Fwydq24RurAVzn11mCxoX2l9XXpjtlGI3
   utucETYBa0bqWypawjZPQwZiQkJTxOOFg+yQUn/MTbpg6e99Sfx8gnOoA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="425528408"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="425528408"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 08:18:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="675317616"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="675317616"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 22 Mar 2023 08:18:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 08:18:02 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 08:18:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 08:18:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FjAt2lqvuNVUcyn4DMVGIdgSerURvfhimvV3zgZRgWCoeVwHPSFdUXra/fi5RtgB3ETytY4NTX9CD8x4DUfCk5THtTkwfSB0ihjgUCmsn6aNzPYc/Dp1VUJKRloikxemruppV3+ywSb+SVYfITGqJdkm1bIz2vPA+1QZBdCPXi12umiQOc3G4kFmfJNLwG4D7bzPKgPVBLbUfNWfuMQcXSmH99Nua34m6eZ0/lMQ7PjezToOhR08DZmmJEWUIp7vqOqvGXv9yvFnwMk1oAeg52GOZtW2DMNauH3JDM1eO32XPLW5al/JmgVHZ8y8KzfD8u3OElkl1kVBM39WZ5WKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBsK2D7pvBDEmUUn0Nf0A4g7Qf5n/81OBAvOxmZp6Rk=;
 b=WOomxLRv5zGz+DuyPcryo9tk4YFMYAwFnM8c7IU32wgCaEeRrFoJVokhbJlvQiva7XqMfIQ4IukfZCQKu9GdCRZoZabZyYPXiDhZCPXb924sp7Y/WeEuq5PePi5APE4WZdMu+OKUcAanfdaKYRcK+kGLKcYjf2yp1+pVw2i3a1zW65sJtBs9Utgpd2o75GyitXq6SPKYcJnQb1ySn90UwudGWYCcRt3UzIIKKb57otY+jILkXy9gSp1VhiV98G067bheMq3+/l24Q5is13UP+vx/2qEoKGp1LjFcscxSS4nqdsdau1iKXLb22fycD3NNHDg0aHKk+yEeNl5w8XQrrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5483.namprd11.prod.outlook.com (2603:10b6:408:104::10)
 by PH0PR11MB5609.namprd11.prod.outlook.com (2603:10b6:510:e0::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 15:17:55 +0000
Received: from BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc]) by BN9PR11MB5483.namprd11.prod.outlook.com
 ([fe80::af70:de56:4a6f:b2cc%7]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 15:17:54 +0000
From:   "Zhang, Tianfei" <tianfei.zhang@intel.com>
To:     =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-fpga@vger.kernel.org" <linux-fpga@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Pagani, Marco" <marpagan@redhat.com>,
        "Weight, Russell H" <russell.h.weight@intel.com>,
        "matthew.gerlach@linux.intel.com" <matthew.gerlach@linux.intel.com>,
        "nico@fluxnic.net" <nico@fluxnic.net>,
        "Khadatare, RaghavendraX Anand" 
        <raghavendrax.anand.khadatare@intel.com>
Subject: RE: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Thread-Topic: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
Thread-Index: AQHZXMpv4Yo9zQ8HK06ZEDUXfqbNWq8G5lsAgAAC3tA=
Date:   Wed, 22 Mar 2023 15:17:54 +0000
Message-ID: <BN9PR11MB5483FD3A64F28A5DBFF163B8E3869@BN9PR11MB5483.namprd11.prod.outlook.com>
References: <20230322143547.233250-1-tianfei.zhang@intel.com>
 <e2684d7c-903f-2a7e-4bf3-ad2edd485e60@linux.intel.com>
In-Reply-To: <e2684d7c-903f-2a7e-4bf3-ad2edd485e60@linux.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5483:EE_|PH0PR11MB5609:EE_
x-ms-office365-filtering-correlation-id: 241a4711-16e9-4f9d-f2a2-08db2ae89c50
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bI0P4Lm30oDQtIxkn/RJ1hv29W9TkgpCUi9OGyGit9UzI9PkXeFsELchFRUz1Z7Hs/FveM5sgfJRe3h7Q42Le+JkdalUlNqiQZA4LAt5ztbzfOnmYLKYUz1+05xCc2JGySfusx7OBoLUUHsXBMyQ2uBIMJtZkmzS5XUM37lItg1oD5Ekp/jfO44KbKuWVHk7LHQ+nONDn6grWZ2xJTdfhef+/7JMoFv+5oJNGYR/y0vvPI4rl9sKLGn9Ot9YNJlEQkmvFjErd+kgBegkKrnuYzFLk6HnjNzoQNqZ2VCS/3opBVJ+I9j2uk4NAh3KFN7ZC2y6RQsD1Of3hG47RrLU25cDJnQwP0im2fhL/WQlg6tAXP0jU5AFpf6uQpUprMpIzEf+649stRlnm9FVFJiL8JbkwOY052y9ODhzrZ4mTXBz1AoQVoPV9wEdJYFF+yng3qGbb45pp5g8buI/aHymLUD3zJTAoq5u93OdXpQdeFxtiCHsipNzBEvCfvYu4QU5UTTY9/TP70QVAmiyuYuvM5olCMhHBbJsC88/G1KZ24TadSn+OAR17m59N+NJboX1s20G/NqANTEkd2LNyI8gzwzyfL04czncVgpHtuzoagEd6aZvqcOwzHJBmwXgAaDvUCKdFafqZWPK1eamcZVW78yaDbl0Irwzb0/frgVB3nlS3H044+IjS/ZsBuNJndWj
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5483.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199018)(52536014)(8936002)(5660300002)(41300700001)(55016003)(82960400001)(33656002)(38070700005)(86362001)(38100700002)(122000001)(2906002)(186003)(4326008)(966005)(83380400001)(478600001)(66574015)(7696005)(9686003)(6506007)(71200400001)(53546011)(54906003)(316002)(8676002)(76116006)(66446008)(6916009)(64756008)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?DX5GUmkS/GwlKnEUQrnxHko2xjR1SO3SPuQguosrEROK4570YAcpPMZ4Mf?=
 =?iso-8859-1?Q?gImvV5F9NdvV6P3mjosinMHD7kqGRmBteSuQe54oTPsSY6b0m456X/ZjEu?=
 =?iso-8859-1?Q?w7/zi0gefxYGMLfvDFPIRrUqylYeiBHydg3vlcfsOplhbPNVdE6I6My4oW?=
 =?iso-8859-1?Q?IcFCcEy7MKhj4f7rtfXfVn9ZkE34gkSdEM+FCr71DMbuCF5kXi8VqUM8ka?=
 =?iso-8859-1?Q?juSIgihA/7COYteKpZKstNRqfpuSEMxDuMO7f8CuisZffRMh1i6e0EDinX?=
 =?iso-8859-1?Q?AEyeuYbhQG6GXe5UzGShzUNCwNPIr+uDi/p6cyOUhtL+mH/d0qlpfT9Ydw?=
 =?iso-8859-1?Q?8ek1Oel5KRDuVauI5mPSNd5Kdy+hcdfYISNAFat+kBsUMKDsmkGwWVotGm?=
 =?iso-8859-1?Q?6yJIhvgdFc0y8WBP2Hm+Dxil135HsndEaGotxX6y4iSTmo1qQCb85Rcpf4?=
 =?iso-8859-1?Q?wfiVpN++2PtBaweSx03w7BQ4VWJVYyqx9ETb1xEtCuxwhom/DKQLMQmmxn?=
 =?iso-8859-1?Q?wnqJhKtr0Jtp+KmmxvA9d8Q3eaGYTdd3HhcWtRvAJ8xa70KZBwEQ1X5wZF?=
 =?iso-8859-1?Q?/+gys9W8C9RZhHLSj5XeGqff5CRaHGX0giGedtadboluHnfylbxW8zMWlG?=
 =?iso-8859-1?Q?Atu6igpL/Wy3s1BjgcYGa/tkTBVMVMKqDOnvPADdLKP6aSwwWv16/sTOJC?=
 =?iso-8859-1?Q?iHlN6zOfQcbR1CLcOjr0EHC+WpDa5aoKWpsW+SBEbyv5uKBB+Ter3F5ILe?=
 =?iso-8859-1?Q?ImFnZ1QKlHHWzqynxwPEcJAmAh8eExTsTcOWnvKKunsuiHzD68a1WmhFNf?=
 =?iso-8859-1?Q?L9KFC5pgz1sKGfteoXhs3kGDmTkh7BvR25o5+j5tBAt/HEp6VjDnLEHKdH?=
 =?iso-8859-1?Q?5SJZyBteSkn1fI9uKQfEtcVK1zCyAC0Uwcn0CqWPeR9ShEUVRtM1DohXqz?=
 =?iso-8859-1?Q?Pzj8PtTDimqwsvvLUL3HLC25ORk3b8J7K+QGWh7OeaE+9auKoVNaqFvqBG?=
 =?iso-8859-1?Q?MiGegFOaHLqRvKmvwMtjT/jOO4hmLawB3vAT7AERA/O13ldPooTbXjTF5K?=
 =?iso-8859-1?Q?NyQoTmFHFe78i9ewGUU9N/eApa62EL/+qLTnkGyd0x9VlbkcITHRiit3Gh?=
 =?iso-8859-1?Q?0AKYNovwlllUshnAhBNVY/cJSWMGJ4MwFaL9V+eGVFTgRBDSsNCmQy8zmQ?=
 =?iso-8859-1?Q?jmglPWwCdJTaiN33jWj/eQJ1cPB9Sfn6B2SCaReq8doXpG7k/Spr3LjkZn?=
 =?iso-8859-1?Q?2e3SpzxJiWfC+sNh64q0z33XK2b0e4Gutl+aFsuqGfhdvBq4efr0/RC3tM?=
 =?iso-8859-1?Q?0/Ol2J+z8SuF+Ogh6vaQ4IZj7Xz66+rdzE91odU9/52pNcmxmrpqIa15Nj?=
 =?iso-8859-1?Q?911MS+YEMpkxKknuAo3aCJhuI+HG232LzBAHx5/GgbEsucK8gOGBMhErYs?=
 =?iso-8859-1?Q?530WAhg65jzqEzWIyTie7vhNvX6O3lA8m88WoUr8WAec8oZV+6vzieHzsE?=
 =?iso-8859-1?Q?4VWTz+ydsLiL3c9c/TzPNmFj8TGL4pOFm/6QrSrCdjm1BqPLwtcwiHaBuY?=
 =?iso-8859-1?Q?W4QQhLzbpf1EYL10h7WfXn3Ox1aV7yWSfqrBi7ns3GRIDdIANdPkNCTl8V?=
 =?iso-8859-1?Q?kJUsuX62krKcPEz/COVFLMoDfGKMpEoh+T6DPZMKjYHGqw1cmi/eX90/CV?=
 =?iso-8859-1?Q?2b+RtZGhzuZjYZWtMawvzh9QaqLIdraTuhvf5PwG?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5483.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 241a4711-16e9-4f9d-f2a2-08db2ae89c50
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 15:17:54.6230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 45XMdBa+HbVnHxLQJ4pWBZ5+AFkH0J7RicoJB8er7DJAI2fyTBFC5TqX1uySZRIVGrM8lW/dA6j0yV7YqsuwXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5609
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> Sent: Wednesday, March 22, 2023 11:07 PM
> To: Zhang, Tianfei <tianfei.zhang@intel.com>
> Cc: richardcochran@gmail.com; Netdev <netdev@vger.kernel.org>; linux-
> fpga@vger.kernel.org; Andy Shevchenko <andriy.shevchenko@linux.intel.com>=
;
> Gomes, Vinicius <vinicius.gomes@intel.com>; pierre-louis.bossart@linux.in=
tel.com;
> Pagani, Marco <marpagan@redhat.com>; Weight, Russell H
> <russell.h.weight@intel.com>; matthew.gerlach@linux.intel.com; nico@fluxn=
ic.net;
> Khadatare, RaghavendraX Anand <raghavendrax.anand.khadatare@intel.com>
> Subject: Re: [PATCH v2] ptp: add ToD device driver for Intel FPGA cards
>=20
> On Wed, 22 Mar 2023, Tianfei Zhang wrote:
>=20
> > Adding a DFL (Device Feature List) device driver of ToD device for
> > Intel FPGA cards.
> >
> > The Intel FPGA Time of Day(ToD) IP within the FPGA DFL bus is exposed
> > as PTP Hardware clock(PHC) device to the Linux PTP stack to
> > synchronize the system clock to its ToD information using phc2sys
> > utility of the Linux PTP stack. The DFL is a hardware List within
> > FPGA, which defines a linked list of feature headers within the device
> > MMIO space to provide an extensible way of adding subdevice features.
> >
> > Signed-off-by: Raghavendra Khadatare
> > <raghavendrax.anand.khadatare@intel.com>
> > Signed-off-by: Tianfei Zhang <tianfei.zhang@intel.com>
> >
> > ---
> > v2:
> > - handle NULL for ptp_clock_register().
> > - use readl_poll_timeout_atomic() instead of readl_poll_timeout(), and
> >   change the interval timeout to 10us.
> > - fix the uninitialized variable.
> > ---
> >  MAINTAINERS               |   7 +
> >  drivers/ptp/Kconfig       |  13 ++
> >  drivers/ptp/Makefile      |   1 +
> >  drivers/ptp/ptp_dfl_tod.c | 333
> > ++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 354 insertions(+)
> >  create mode 100644 drivers/ptp/ptp_dfl_tod.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS index
> > d8ebab595b2a..3fd603369464 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15623,6 +15623,13 @@ L:	netdev@vger.kernel.org
> >  S:	Maintained
> >  F:	drivers/ptp/ptp_ocp.c
> >
> > +INTEL PTP DFL ToD DRIVER
> > +M:	Tianfei Zhang <tianfei.zhang@intel.com>
> > +L:	linux-fpga@vger.kernel.org
> > +L:	netdev@vger.kernel.org
> > +S:	Maintained
> > +F:	drivers/ptp/ptp_dfl_tod.c
> > +
> >  OPENCORES I2C BUS DRIVER
> >  M:	Peter Korsgaard <peter@korsgaard.com>
> >  M:	Andrew Lunn <andrew@lunn.ch>
> > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
> > fe4971b65c64..e0d6f136ee46 100644
> > --- a/drivers/ptp/Kconfig
> > +++ b/drivers/ptp/Kconfig
> > @@ -186,4 +186,17 @@ config PTP_1588_CLOCK_OCP
> >
> >  	  More information is available at http://www.timingcard.com/
> >
> > +config PTP_DFL_TOD
> > +	tristate "FPGA DFL ToD Driver"
> > +	depends on FPGA_DFL
>=20
> Should this also have depends on PTP_1588_CLOCK?

Yes, I will add it later.

