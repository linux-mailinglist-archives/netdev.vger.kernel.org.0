Return-Path: <netdev+bounces-9135-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 403647276A0
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:24:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40B411C20F15
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB024C7D;
	Thu,  8 Jun 2023 05:24:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A904646B6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:24:38 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2780919BB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 22:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686201877; x=1717737877;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RKyOqNBDhpLljA37JV8+3gkVxIM78NHwXylCaJZ/MEg=;
  b=ONjEgrAGIsS06xnjW0oKrzhwHck5/ModRqJbFByP9/n9LmrqZtYmZy99
   QaaTsN16byAfwokDuXqTbSIg7oL5QnyFAWEbXbGNRIkG/4xGh+IXwv17Z
   y/UVlFYK5MovpJLm84vXySikfgwlmGaS6y4FfO5i3rgZ/V9fAhdWP1bDY
   ErWKJVaUKqUNoeqgK7fADaM4VCWcyZxR1FRfVLGWh6RIqeXNeIrLzbgwg
   iXfSwm3sZcCr7kEBNJL8SLYe3BXQAlQFqks6YVvHBGiUxA5zcuTyq3ynC
   pI2Uj6U1iLL+gigzy9iQHwdBQHQulq0aXVs264ERk1xIwSePo53vg3lD0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="356063259"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="356063259"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 22:24:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="834021898"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="834021898"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 07 Jun 2023 22:24:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 7 Jun 2023 22:24:14 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 7 Jun 2023 22:24:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 7 Jun 2023 22:24:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EMCBFhDjMFLHzJD9OsVWcmEeoqZgIWBeVjZktCWKc67vtpytt0eF/oQO2nWI3Wl2/jU1GBBIjBgbv1/TR+uQZGTKOFvbMoGXO7UqVrI/C0vdwQIAMvYqfxI7WMJdw5137BAv0pw0FvHcofXcQLAoJzT2zB4BFRUwwsywsxLoxaHX7bSHpb3YXDU3I6nl/4CNuctpKNiLGkF77pzT4SpuuX5C3C1l4CCmXVYuYKKkssLKXTPEgYYjD/uOwANS0ACEKNVQMmFEbMIy8O1TFL/FKaZ4lGGFmaO6xhEb2+d+z3S8luOmfPRtohygih/ukb8htPMJ/AeZNWC5hybDTmcG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f6BjzAvhj+4hlg4Mqe1+2Z9tFv7qkcNiuaWo5xe1sx8=;
 b=CuAwfVFy1O5y5tkV6hVZvnAEycNq91iW0bK3BNeyOlkj2VUv+YpIC86UXFJWww6Tt9qIruFDhNKYJ7PSwOgRP8Ro/xO8tDqXrVW5jc+GyOx77YGmu34fzbTkFS0eQyefhG8aoG0H6o+RBxP506hFPwI9FbQGz87iDn+Hog/r6+86Imu9FmcNob0Hm40bgRcHL1FD2nL+KAKourPzm0ko4d6IFFnRCc0717rXzJau15bkNq8wIiO4aq/646hX0xSNU+aSx2y9zZhGaq3L8XVmn0vW8/R1vzgYzbA3jlp2I90VSbBfyyPpPOmCqmgH5jzEC5emx63lYTjekfHNX1u6mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CY5PR11MB6391.namprd11.prod.outlook.com (2603:10b6:930:38::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 05:24:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::4e5a:e4d6:5676:b0ab%5]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 05:24:12 +0000
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Simon Wunderlich <sw@simonwunderlich.de>
CC: "davem@davemloft.net" <davem@davemloft.net>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "b.a.t.m.a.n@lists.open-mesh.org"
	<b.a.t.m.a.n@lists.open-mesh.org>, Vladislav Efanov <VEfanov@ispras.ru>,
	"stable@kernel.org" <stable@kernel.org>, Sven Eckelmann <sven@narfation.org>
Subject: RE: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed
 work
Thread-Topic: [PATCH 1/1] batman-adv: Broken sync while rescheduling delayed
 work
Thread-Index: AQHZmVqTyaVqKE3l2kyKiD2rtI51La+AWdkAgAAGE9A=
Date: Thu, 8 Jun 2023 05:24:12 +0000
Message-ID: <CO1PR11MB5089F99A62265CE85CCB413CD650A@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230607155515.548120-1-sw@simonwunderlich.de>
	<20230607155515.548120-2-sw@simonwunderlich.de>
 <20230607220126.26c6ee40@kernel.org>
In-Reply-To: <20230607220126.26c6ee40@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|CY5PR11MB6391:EE_
x-ms-office365-filtering-correlation-id: 7f8a6002-be4a-4806-de1a-08db67e09827
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mn7ebdCO2aVaZs+xOHyGtAxQqJlD2YukkRY3K9sBQcd4brv0t1OyIti7d+L8z7DERTZoiMQ3rxzc6kGpSgDe/mfAhFA1c28aKSFuqLCg3jP3ULATG6z82x0znjF3JWTyPr/AYLGei3B7J7AVf1LfqmTkMNrRvYGAdrXRtFSHyqHabFsbWTIB/skI6bMu8l3qGMHuYjreZUd2OI5u27BSmXTZsnxoEqOY2tCzb+OrJhfcYf6GRHltG9ORRQ3FaVC6hWefqCrfk9YSWeOGGQdTVKPoDBM1QecGmu5g0MFiBjem1NFZj4ZKQuUlhLSek0h+WjLEHAn039v/7fRfdhrPiEho4iVPiNHxO9+WV3pGlHnQvlCevYMWwZVlDX8FSBrIkBaKcgIzrqevHxAPTrnPAPsM9IaOnPsC/ToeV7Cjy2OrLHkEGik+gdZh1RxOidVW0Ovjaw7vF6+I94ygLDurXHH7ntJ2CWVNQnCpxS6NZEbyEr3JInFXzgqktZfrfQQo4iTYrxCuit3my0/AaCDXpvSJOX9H7UQ28/C5SnQ6t2SLma4jplhGCmnsazADGzGl63yHv4XX8cc0rXLsgcz0peAhqyiYoqgkf51IlNFiXH2n005UEbRKGGDmVOcLGj52
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199021)(8676002)(8936002)(54906003)(7696005)(110136005)(478600001)(55016003)(52536014)(5660300002)(41300700001)(316002)(26005)(186003)(76116006)(6506007)(64756008)(71200400001)(66556008)(66946007)(66446008)(53546011)(9686003)(4326008)(66476007)(83380400001)(2906002)(38100700002)(82960400001)(122000001)(38070700005)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hO3FCintRRBlOEud8OaHrl+wvMwObcgph75bdocLN+kVUG8B+HzN7PA9j3pH?=
 =?us-ascii?Q?I1KK9CPM3xu20eZD0X4BUdHeNz3ugcbNtEwggboLdY8LcHFfJ94w0701Li8r?=
 =?us-ascii?Q?81GaahSeSYTV0jCsiPAiJVJUrljlk4e4iIK8S5uL+48/3GBZv9EzsA6DudyJ?=
 =?us-ascii?Q?VhOqcRMv+5Oj4VS0kpApOLvnxefAeSdcLWcPXmFdw1FOcxIrC83VaFRXvt8h?=
 =?us-ascii?Q?MvSDqV5pDfBBRZDcPQLSHZd7dpZLFejygleof5WdJLPUvaA/fDV95MYwMok9?=
 =?us-ascii?Q?Hx4b/PkpsjbCM/OrUKg4H7fJ4Tm2kzFH1wcEPr9g0x7yLnwwvrjj0nYfWJUo?=
 =?us-ascii?Q?hO61J0Au4bVgtvT9tlVBE1r9SZegwSIcfPrQ5zWLu5mxJLY2AdD4NDihfSa8?=
 =?us-ascii?Q?XVOxQX+HXO5sWhH42eDFZmKHHf6lc/6LQHUH2Jjj6ROoXIa/ZMopTdKSvv7E?=
 =?us-ascii?Q?ty2C/ueKInQJlXPoOftRk9xGgX4QjaaNdPqbh+NIwItkh+zKzEj5xLsBOQL6?=
 =?us-ascii?Q?BTiZwIrDk7R1d/kuCElBNeBhXZyAPJrtJAcx96FZ/0U2ehAwstMFL7mJepwF?=
 =?us-ascii?Q?5l0LD+NuWBVJaa0yG4CNe7Gjye8ospqMTXG66opke5MDk2oue/+jSU+Ca6E0?=
 =?us-ascii?Q?x/afn4TGRBn2piywSf8EyIkqYYi74xZTf1icc7gMDepko3F1TJ23I6EO54JS?=
 =?us-ascii?Q?5qCXvqidmGMJztl/kYmfifn+yleI9HNDGj8f0ksgKJyqDY1GB/GXPkaID+Qp?=
 =?us-ascii?Q?tAp/7RZ8TAxEt832Pbl0L0QaR++Pq+XqB5lMVfIcqjkD36XxFILbV+1hhquR?=
 =?us-ascii?Q?NI5/Nbgfgd9BCLJFSxTz2n6StUtHyUlrY3uZYZG+oNs5kaSJ5kqS84DUl9jp?=
 =?us-ascii?Q?WWVMnpxbmWeJBhUOFyjlLP4bp4wWU6mKLawteuoO7rC4BD60V0id9BF9Euxn?=
 =?us-ascii?Q?wHwRxeP5ZiXMN+ejyf+XJ0V2l4RKkNFl9Y+LiDqIlHnpCUG2O/KlUcQDSpdd?=
 =?us-ascii?Q?nUqMY/7H2OsXApZ63DzNMYVEEvNmSIp8B45yKoL79EiBgUxTXL+DL9eqdBkH?=
 =?us-ascii?Q?Y1714KdqY9L9AByT63M00/vjpfE47/Rf2UvQV6T5iq/VTi2EMAUC8gsceD0V?=
 =?us-ascii?Q?FAXvtdYnZtgf3nUPaidh+cALCPDrTvaTuUK5rsmay/mTkOP/48n0sKVMYRDT?=
 =?us-ascii?Q?YNpsXSQOsyScu5zm+xGxYrTGo5dgO4uPDTMH5tqjQ9QhEv8TU+2/tajwbd4P?=
 =?us-ascii?Q?q2VVhjwfK7UM3+U5jyHVtL0jtOLrSYg47JfnItCmcO3HY/z4bogyuC2uSjBM?=
 =?us-ascii?Q?jm5/DkmqfmgyCJ9tISn+dlqQUyi6MKyMBqbm7vKrBPPMV6mOrcSYxWpsCmKl?=
 =?us-ascii?Q?GZzjPt5c29GauzERvRfTwKsZ18H2uY3QFX6/uqPFeUYGL+qI+zGO7zQwJeYM?=
 =?us-ascii?Q?4hnzJNdyMwfJtBFIGhKMTyLhsAcf7iMyzkghwkvjxWAND8vPx+SfkzRMrxf+?=
 =?us-ascii?Q?kLjqotqvPKe6S6aeVDM4id1AyQtS1Kc21hoSwwyoPwoLoqezpp6Yo6t00BBv?=
 =?us-ascii?Q?1ODHUJ2b772ilHwRZI7Y+tXCnqKkB63vr7kDV6iO?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f8a6002-be4a-4806-de1a-08db67e09827
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2023 05:24:12.5764
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hVPOfWmYP5xMtf5fcFNfZH0PxXDlQiCfi4vIzf176QAaEJzzaq5ETKbzskLAETxZ/YVLCbwsjaRpEOLbuKbB3DmOI4UmSKQ/NuiwJOMdbQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6391
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, June 7, 2023 10:01 PM
> To: Simon Wunderlich <sw@simonwunderlich.de>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; b.a.t.m.a.n@lists.open-
> mesh.org; Vladislav Efanov <VEfanov@ispras.ru>; stable@kernel.org; Sven
> Eckelmann <sven@narfation.org>
> Subject: Re: [PATCH 1/1] batman-adv: Broken sync while rescheduling delay=
ed
> work
>=20
> On Wed,  7 Jun 2023 17:55:15 +0200 Simon Wunderlich wrote:
> > The reason for these issues is the lack of synchronization. Delayed
> > work (batadv_dat_purge) schedules new timer/work while the device
> > is being deleted. As the result new timer/delayed work is set after
> > cancel_delayed_work_sync() was called. So after the device is freed
> > the timer list contains pointer to already freed memory.
>=20
> I guess this is better than status quo but is the fix really complete?
> We're still not preventing the timer / work from getting scheduled
> and staying alive after the netdev has been freed, right?

Yea, I would expect some synchronization mechanism to ensure that after can=
cel_delayed_work_sync() you can't queue the work again.

I know for timers there is recently timer_shutdown_sync() which can be used=
 to guarantee a timer can't re-arm at all, and its intended for some situat=
ions where there is a cyclic dependency...

Thanks,
Jake

