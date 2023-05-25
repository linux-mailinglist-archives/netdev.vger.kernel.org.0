Return-Path: <netdev+bounces-5191-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B9457101EE
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 02:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C047280D99
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 00:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E9D7197;
	Thu, 25 May 2023 00:17:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFFA18E
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 00:17:00 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D29C99
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684973819; x=1716509819;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qt5fVEaTAoh48HJ0Xaui3fcklkQEAvGCRDnEmXr3Leg=;
  b=D5+fh3evfv7JJX3nZshrkYDk2fcQlpWVAFXBBxYiaLHaZgXNYYG9JfR0
   DgHNSbOXM7+Hxxlo1bqxrg5pBwz6JukRhxMiM2Z4dA3oyMdZWq7NzJzHC
   bN/yyaKN9Ho7kpOQGw5+RgOO+rux36WWZrQrx/bFeB4Vj7PmUsVQHJbxX
   i1tLwxFFNV40X+PHSo3mS3zxYwkBPb7qbb3m3gI8y/DkRhSc2Q4TYToyu
   UeAEZfBA9/Kw8tF6SoNIRFJGz/BimVhzQNcBa0PGd/Q6fNTpp0PHcxtgz
   rIOBMSq7AcmR3K0WWVmt/RSzqlwpKIYg+NoD4OH7s3qunPObQfw4HnFeY
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="419451314"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="419451314"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 17:16:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="654994738"
X-IronPort-AV: E=Sophos;i="6.00,190,1681196400"; 
   d="scan'208";a="654994738"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 24 May 2023 17:16:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 17:16:58 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 17:16:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 17:16:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 17:16:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nL1LlHBhSTqEoQ0qwiCYJR2U7BGnBKNGILrWMcj2acLv1e13WUAG5+T3R3BNf2i5L72qsaw1tjkglQ3TGhOjqtq4IegF+PpKbB9QMRxdgabULcJv4WkODiquihmf79vyhmxp73CWeiwRH4J/pqONLj2myVZv+BEP01l6AfZ6pvf9xEu+WTooZ+3oJXkhCLoA84j3o+pC1rnz7e9tHreZzMqHROQxJVJ1H0/G3T/TQh3MUIv7U14qSQ/BT6XS/5EVD8XDkXdN8omCo39ZauskY2qCzkFFXrNRPfaCTXiYsxg75R/dTiZi44c3xZthsQlyKeFyXrWBNAIT5BNGlqjeCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qt5fVEaTAoh48HJ0Xaui3fcklkQEAvGCRDnEmXr3Leg=;
 b=K/cn+VGeBfX2955uBylmqlXbT64umQXbQzNJ6xR6iH8vJYtMIbjbtx8y003E8xa3rhLD7GXnZLRuqwjdAgMP5Xu7EmBbLbO8IcSenDhNvZ1fRu1Aeb4R5eAhaWcKRnD3kYU0zRVZq2tKD5gBb1wnu2lJ3rguTfgQjElfv0OVayrmuHzPc6QnGt5lnTW1/2ozlLtTXC09xr+BV3nOxobq7rK4yeS6dhKPL9/qgQlAjS49YnTaE18p7SFkLeli2KlAr8XH1uw+SaeTz6FnRcom1m1wY1wNwUsdy2BVYPb23ZKkvE0ati1HCBWtetY3zDMqhNFe/jGaCiY1WQBUjpDiWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by MN2PR11MB4550.namprd11.prod.outlook.com (2603:10b6:208:267::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 00:16:55 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::7742:b078:5670:551f]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::7742:b078:5670:551f%7]) with mapi id 15.20.6433.015; Thu, 25 May 2023
 00:16:54 +0000
From: "Nambiar, Amritha" <amritha.nambiar@intel.com>
To: Jakub Kicinski <kuba@kernel.org>, Sebastian Andrzej Siewior
	<bigeasy@linutronix.de>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Eric Dumazet
	<edumazet@google.com>, "Kanzenbach, Kurt" <kurt.kanzenbach@linutronix.de>,
	Paolo Abeni <pabeni@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
	"Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Thread-Topic: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
Thread-Index: AQHZjjDmXutHi6P/50mhZvQ5NvRAe69pk9eAgACKjfA=
Date: Thu, 25 May 2023 00:16:54 +0000
Message-ID: <MWHPR11MB129321759864A20827BE04DDF1469@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <20230524111259.1323415-1-bigeasy@linutronix.de>
	<20230524111259.1323415-2-bigeasy@linutronix.de>
 <20230524085507.3f38c758@kernel.org>
In-Reply-To: <20230524085507.3f38c758@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1293:EE_|MN2PR11MB4550:EE_
x-ms-office365-filtering-correlation-id: f2fb9385-5dd5-4dac-36d3-08db5cb5584e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t7oZA3OJLtxryEy4ozLToDM+fsJyT6YpaOEyODxH98tSA2LgrT4TQ/lBUYd7DHr/RnfIxsIQ5RsitO9DVEP9kSyg6obczU2cucPeT2IZoAcIFyMRaIZ8fehaysheBRP3aOR+K9SXVwAxSpi5kmtVwQeCtcdcdqN1knRWTBsjr+9LUoI6Kud1Cq7mSH0nm6h9/HVFEILdpLik7SC3fDORjkGyf+lvwM9ZexeJ7mN50PVbKJ2s/WgZ/jTb9zfKAW0AhNnCqRVYLqlx+MLrgToXvZrhw/aglh5DwhCOwRZzQNIdui6RAHMtHZPYuqItkmeuSHq/Pb0fCajv2XlYy+ByMmJYT+hOAEiwhFoEPigaQz8+7KSw3N3Z2p4uE2S5RJveFg2zgENhAeXwWRxYcZYBUuorDigpvqiIZmGDZ7UPufQZTqQ7vFuFd5VY+ylFFLH3YSWPUBTgsWyZw3IPwyUtQryDDYZpLJ8N5YECoj6QO1txGY6DjkzKqVLYxRm1F4DMoUnpo1wWCtu4Jl6ejFLuTMjmUu5TcfDn/fd2uon68yDYaxb9RQ/LJTTKobUO1L3T9wrEMf3xEma8wXNYnkkduscX9fXj2rn3E+vdcyeSwBk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(136003)(396003)(376002)(366004)(451199021)(66446008)(55016003)(9686003)(26005)(6506007)(66946007)(4326008)(66476007)(66556008)(64756008)(316002)(76116006)(107886003)(71200400001)(41300700001)(966005)(478600001)(110136005)(54906003)(7696005)(8676002)(52536014)(5660300002)(8936002)(82960400001)(86362001)(83380400001)(2906002)(38070700005)(122000001)(38100700002)(186003)(33656002)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?E3UQJwNHtCuKg0rhCZs6aRzS84rexrINct5SlzU6E0sn3HG77Y/svvMkaW9r?=
 =?us-ascii?Q?FXjJ4NvVsi7miOlFIz4CC9afCG1cmakoSHKDPpzhpi2t/c+7d1BMJ+GKI2hH?=
 =?us-ascii?Q?LwxQanQsiDC5zKWae//21EH7THUmXphzHzYwHI/dZaZJxL3ap4cDaMMaHFLI?=
 =?us-ascii?Q?836NU2uQWPTpo3t4pRuCdr8edAVJfvOwYLfqF8dZYZ3NBUBJN6yAnvrLNffd?=
 =?us-ascii?Q?8MeSieKUxy5uY7M8++yCvn5HSpx+fK0UhIowCxb1Tps9zKqRqleP1+9YqzJx?=
 =?us-ascii?Q?MRIuquMtGKXHqUpNvkGrVJi9B4OYIGQ/hADEMxIecMPbh4Xad8CnrtREQ/XD?=
 =?us-ascii?Q?VQC6laxH48eYwgTReCYYl4qEPKalmDkUTKNipc1hTmpSCH72XuriAa733798?=
 =?us-ascii?Q?36iNHFja1FeJD/bNG+oxPl6D7ccZHPpCWXOFuohqKIlma5YYZOoFlmht4x8k?=
 =?us-ascii?Q?kUZS2K2favts6SkXEB/ePlKX2mlU1tWGHkyT4mirzQxPSbfgT3n5VePuFzDi?=
 =?us-ascii?Q?AQmw3t58fXGqoCVsnShgVd7UpPKxPEN4ogXUKFqRKYR579A/OqWw6ZtwIR3a?=
 =?us-ascii?Q?8wo9kWBlVhFzqaVOIK1Vxgq42m8e3oC7Bgdjbn/jZff5+aQKgj4Tsu46SUex?=
 =?us-ascii?Q?StWZUGspW/p+i7H6ybC0RhYp68KDZmzfPpXLerE7aC+xz8yhDej9gTMO0UPF?=
 =?us-ascii?Q?CpCJfxd4P2GPrjPFFEpwUCkGM/jlCjbEOq+qsitTwT/a3NNJK57C/nIH8VQx?=
 =?us-ascii?Q?oS+4bNyUxLN81snT1BbYt4WPLOIxJymrY2Z/vdhJepiN62q/Fb5pM32f2CmO?=
 =?us-ascii?Q?uM2RP+v+sEPiD7nUWEvDC+1kJvaqTqTMGhlbZvS9CiZWMGxmfz0YZEt09oeu?=
 =?us-ascii?Q?EDKmyGGHaHJo8//XxNtr+vIb3Qg2pr6hV7Mcc54g9CIscByocpfft2fm2j24?=
 =?us-ascii?Q?6C/GDnz7vJrsXbpzl1r/53lt76WREVf00HOdbeBHIjTub/Hn+K74Ydf2CCjS?=
 =?us-ascii?Q?cMrED3Xkk1XeNsIvenqDqUNi1w+jnF+0Mpk2n+5ZrFw+GBQrDRuH+AJrnfYm?=
 =?us-ascii?Q?OFJ02/xJ1WCipHdCKuGhqMkXFJjkGkb8ZVbTF4vjonv4iLXL8uWzBKNK9Q7F?=
 =?us-ascii?Q?4coGVwvYdJlD+RLxibUGNW70kCMBPkBeWRBI4Jr9/3T262bO9lHE9jT68Hl9?=
 =?us-ascii?Q?hmTbZ20jpDmlP2J4tGdVPKoYHwV099OPlZdbgfE4ElsbHPBvqjZXiFeJjIUE?=
 =?us-ascii?Q?C2vjT7F8STYypIqN8rGUf6kF21zxeLfCGLwmXm0wsO6ddde60QwU30SavoHy?=
 =?us-ascii?Q?cLZS9Btu+dfKE9GsK6QBp+1AWWqgRtUNYrJeyNpHg1WjsxIrMpTsjgNAyzBl?=
 =?us-ascii?Q?tOlFYz18ZInT5aWgrQMprPXwMfJNjN55+cIWlw8ize9Yv3BQ8NhBYWWgDeD5?=
 =?us-ascii?Q?GeJ8M8EVJSXjiaPPZJJ87BCJ8HvAHAi1JFJaImudUmvv62/Xd1bsbucSdwcT?=
 =?us-ascii?Q?lFpxQImuSRFYRiaSzDRpNt0bTt5PHZtunjLPPsvIur8HdTL8ddmAUl5KjQnf?=
 =?us-ascii?Q?T05GzZdJ8mVbeS2vOE8z6HUOltAJ+6l/RDBL5UcF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2fb9385-5dd5-4dac-36d3-08db5cb5584e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2023 00:16:54.3357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BDyE3dE8/uVh9RzxcEEVEjyAOlwINNIjuZNUAcLzrfeFDdnbiB6YpKJujzOaLkdc9sbSiPN74vHa4FNS6eGheKc1ovz1a5OgF6lWYgI5hbI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4550
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, May 24, 2023 9:25 PM
> To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: netdev@vger.kernel.org; Eric Dumazet <edumazet@google.com>;
> Kanzenbach, Kurt <kurt.kanzenbach@linutronix.de>; Paolo Abeni
> <pabeni@redhat.com>; Thomas Gleixner <tglx@linutronix.de>
> Subject: Re: [RFC PATCH 1/2] net: Add sysfs files for threaded NAPI.
>=20
> On Wed, 24 May 2023 13:12:58 +0200 Sebastian Andrzej Siewior wrote:
> > I've been looking into threaded NAPI. One awkward thing to do is
> > to figure out the thread names, pids in order to adjust the thread
> > priorities and SMP affinity.
> > On PREEMPT_RT the NAPI thread is treated (by the user) the same way as
> > the threaded interrupt which means a dedicate CPU affinity for the
> > thread and a higher task priority to be favoured over other tasks on th=
e
> > CPU. Otherwise the NAPI thread can be preempted by other threads
> leading
> > to delays in packet delivery.
> > Having to run ps/ grep is awkward to get the PID right. It is not easy
> > to match the interrupt since there is no obvious relation between the
> > IRQ and the NAPI thread.
> > NAPI threads are enabled often to mitigate the problems caused by a
> > "pending" ksoftirqd (which has been mitigated recently by doing softiqr=
s
> > regardless of ksoftirqd status). There is still the part that the NAPI
> > thread does not use softnet_data::poll_list.
>=20
> This needs to go to the netdev netlink family, not sysfs.
> There's much more information about NAPI to expose and sysfs will
> quickly start showing its limitations.

Based on the discussion in https://lore.kernel.org/netdev/c8476530638a5f438=
1d64db0e024ed49c2db3b02.camel@gmail.com/T/#m00999652a8b4731fbdb7bf698d2e366=
6c65a60e7 ,
I am working on a patch series (will post RFCs next week), to extend the
netdev-genl interface to expose napi_ids and associated queues. The patch
series will enable support for retrieving napi information contained in the
netdev struct, such as napi id, queue/queue-set (both RX and TX) associated
with each napi instance etc. I figure this requirement for exposing napi th=
read
to PID association can be done as a follow-on/extension to my series.


