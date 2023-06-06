Return-Path: <netdev+bounces-8581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BC3A724A12
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 19:20:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E40AA280D4F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384211ED57;
	Tue,  6 Jun 2023 17:20:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B161ED50
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 17:20:46 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2BF10CB;
	Tue,  6 Jun 2023 10:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686072045; x=1717608045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UFnD/RmHRvwcKHK4TvkU3YlbyR8Pnuxb0uYQw4w5PkU=;
  b=BxX8e4hJz8GoOxoyv2+onLhdU6ixLKJE5S/Sgvx1KCQMBN597AT1x83+
   3FJSgrLuT0P6SXNOQVexCtoZ5Ey0ECAmuhnHm5XDNDdQX9HOGkKrrllwe
   2NKlhDYaLQn22xmajExjt/JX1qWZMdYYMV132fP+6e1KOaJ0FB1EE5CuO
   igyzkOWHnCZYJJTaWqDP+eP4kJn5FIQFMtaxy21Pr5GnxsbqhuujegGo7
   Lze0Z3W/khQTVrYOHLP0rbc48xNky5uR35LqOLX6MZ20upMXjGEYLKiHz
   74wgaqjuflQNW0ILIgdZ3uGYoZvsXZLYjjYgs128JGDjZfzNpsXv9N2UC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="443116200"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="443116200"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 10:20:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="709155248"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="709155248"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 06 Jun 2023 10:20:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:20:44 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:20:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 10:20:44 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 10:20:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juBPuMc/1frBSzj4y5oXTpgOeQztAsSIrCcnYLhMdYoZTxynMjy9aDtza4lKrDemV21XZuwNvH/wCP54telH53CpMvLOMGvn1CXheq/cg8KgXUmF62Al8uf/iDT8NYedVVGrZMwb4xQW2IQ6s+UBZ4SHuJFkKYAVSuoHUyXFIwnt8vRMIr86bYe4oGZWvyHBVN94v08I2gSq9AOTZaEvwg7UlLO1wpARZ5uNk39rKcJsxwaoDy1i2xcZZ486OQAsLVUWce5wGN9USPV3uzZ5bFEjGstI3+bHFh4a7LyinQAoIvkDR23+dwbcil33Wz2ie92aiajjymGZ1XjcBiSMog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp8PFjesnDIel6rs3sa396QpnmoerVPOc3Kpyy9g2rI=;
 b=Rl7Jwjlir5ksIQ2CbmyLutUZi9pDmXD4oqM8JlgND2Dzys51bL6B/efbStXHQDP3vuiB/ts1VRKmUnUX3qnVpjFWOWNuhlQ28HKrSwvInd3iI2QzhmMU7K+NC2wZwzhOd4s0UcZNnLCpM4GgG24MceacJhKyVv0uhU/jjSE3FeUX5UyJHDciPLbq9I/cQeXQ9V1qLSipIYYjLdO4H2PduQ0eaVLk65JsZJlvzOVuu8IZ+RmRZkgPC2krrJvFx0c1OtB8choj9lL2oMbxQRR3ey3j8J/D030C3djlwgjFWuRlHM4hq62bN+liyfGx/hVQdc+ML7LCAz/kfhN5drz8Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5028.namprd11.prod.outlook.com (2603:10b6:303:9a::12)
 by DM8PR11MB5654.namprd11.prod.outlook.com (2603:10b6:8:33::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 17:20:38 +0000
Received: from CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::a5d5:532b:7e2e:46f0]) by CO1PR11MB5028.namprd11.prod.outlook.com
 ([fe80::a5d5:532b:7e2e:46f0%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 17:20:38 +0000
From: "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>
To: Tariq Toukan <ttoukan.linux@gmail.com>, Simon Horman <horms@kernel.org>,
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>
CC: "Mishra, Sudhansu Sekhar" <sudhansu.mishra@intel.com>, "Kolacinski, Karol"
	<karol.kolacinski@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "David S. Miller"
	<davem@davemloft.net>, Dan Carpenter <dan.carpenter@linaro.org>
Subject: RE: [Intel-wired-lan] [PATCH net] ice: Don't dereference NULL in
 ice_gns_read error path
Thread-Topic: [Intel-wired-lan] [PATCH net] ice: Don't dereference NULL in
 ice_gns_read error path
Thread-Index: AQHZjxm1Bi4O93cuFUSVgyTDfYP+sq9sUC6AgA9zfiA=
Date: Tue, 6 Jun 2023 17:20:37 +0000
Message-ID: <CO1PR11MB5028E9B124D8DA66D08F8560A052A@CO1PR11MB5028.namprd11.prod.outlook.com>
References: <20230525-null-ice-v1-1-30d10557b91e@kernel.org>
 <e1e3dea5-a393-180a-805a-a944ec778041@gmail.com>
In-Reply-To: <e1e3dea5-a393-180a-805a-a944ec778041@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5028:EE_|DM8PR11MB5654:EE_
x-ms-office365-filtering-correlation-id: b1676b40-747f-4354-0546-08db66b2589d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2FljMTWLDHaSaoIgYpOs56+N/O71dva9yTG+lwep2EaIsuDVnOzJQVINHyxduXUoe+BfyQs2cxM/tt2Stn47de3oSyawyzcf8T/cijjveddZrT9ohnEU3rGvRCsAicOFrpXX/kwNQTPf9+GuByQUaQ+dKHfKuw4llU8a1FEa0nvSry+Aokok6ujpX7OUFQw784oPOFLQn9DzBbyiPkcYZnVFkmEoNXMRelQ+dDMt5HWzevT5CvnWXX+uosS3b0iO8MrkId03CwHtdDfrqZC9bnrbn+uDSbTRm9/YTPsMOxyiTSw/VpiCQ3omFRaSdT36Pr5h8Ztu/bS2jcJJOQULMxI1gvyOo/k90TDYFO85AifcqZUYrPfMXBvbHgqvBUHF9XeKLIECPNqcT20OOx82vlps9qzQf/z+g8c2fTXiLlzJGKriGH+5QozYDrnc/uh1w4Le7d5zXoxaqxVrAI3b0vCKR4hi0MRz9GOwQ3ZSEd2AU0Kf1TACSD20FeGnCXw6ICEn3wfM60qWs0Tb1pmnOOAu5/5myOF4bkZgwaMJ8u7nKudyu5NXkELquYUt+IzPjyZGKWn1wg03G/x7B2XYZs/QWpBmv9PoE6SsNo4NhcYjvVfrY+WkeAY0ZShsF4wO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5028.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199021)(86362001)(52536014)(122000001)(83380400001)(54906003)(110136005)(6636002)(4326008)(64756008)(76116006)(38100700002)(66946007)(66476007)(66446008)(66556008)(71200400001)(7696005)(478600001)(2906002)(186003)(38070700005)(8936002)(41300700001)(8676002)(33656002)(316002)(55016003)(5660300002)(82960400001)(7416002)(26005)(53546011)(9686003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zrm2X8xQ9W4BXoOte9UNWwDGvg1B+laEL1DY8JZcQn9gcEkro0ue3JKcqpPl?=
 =?us-ascii?Q?AS+H0uepYZ8YC5BTv6jlN0YrHVuMeL28DfyrA0rVcggfDIjZQuTW2GNKJzD+?=
 =?us-ascii?Q?gN/hOshdZLmOOhzt5/rpFFCvxa3SoYUXpyOcoOkFvRZCgmexken7hJzXRAGI?=
 =?us-ascii?Q?8qI/Es8luKql+dO+N0GhBbl0ljJfvJJgBet7JkiYfmfuUUNwUAYgxEz3K2Wo?=
 =?us-ascii?Q?6GdDP7ZR43BLe1An8VBmRzRDqpUjH2vv2BKAtormSgbHEBrxfgfVKU7AfMGy?=
 =?us-ascii?Q?GIHCP1eJl2B3YBs0+YzWzPOjUzidgJ7RaKgqdycOa5ZwJiqZh9rEPCJZDfIm?=
 =?us-ascii?Q?7fWXxNwusydn/gZ8bong1EMwY9eaTnB6YkKe+kE83/8LdyUO58iM8JX2mSQ7?=
 =?us-ascii?Q?nwQVcIh5Tv7RtylOaZ1D/cHrkOHHotyTTvRP8WdfnUpbkAi1xFOq8DygtdH0?=
 =?us-ascii?Q?3ewfyuKiG+u4fxwuQHX+xMHwfqnXfeTIym9DHtaWJM3U7OoHnEWA0lDHCVOi?=
 =?us-ascii?Q?sEXb/B0Nv+JkW0k8XK8yKjO4KUTLjgbTK+/yuU5AC4G3my6RK6xhYwoxfBNe?=
 =?us-ascii?Q?rC2QNptjBhM0spaWsYykkpik9uw9exlBYiwrDhhvpKwS54rFMR2QHTwLZVrL?=
 =?us-ascii?Q?GFnv6s6h+mEjFIfAyUsZqbHp9VVlqce3Eqbvdpx/PtL2pBugiQ0C9eqtakq0?=
 =?us-ascii?Q?CKvOWQsCe20/9Uw4Snyy5lkviRuaRtu1IAsF2i7vpH5nupWDG1xNeN46LJXN?=
 =?us-ascii?Q?EqwLj8yYszfyloDgQXdLeCcT+GUqBlDENcSpa6hUoHnvC5KgMVmsIMdMhyh+?=
 =?us-ascii?Q?M98n3MkPlNumZB5KE84wlm+5U+bVMTx+2D5aBmsC6T0Y6ypf035HMkdUYgmX?=
 =?us-ascii?Q?llkuToHKsj8KeaTdB4ziZDHHka+LZWCxOIZpYya8fVjx65cPpfUNGIfbb4fZ?=
 =?us-ascii?Q?eypemOdz1e3Ce1l7AXKOZ7eoBC6rz6/HHpwN5n/Y1xZNy8oBEeiQP9YQtK9q?=
 =?us-ascii?Q?XbHaVmQu6if8NW9yV06dWuyfAlKEE4ySMMgodx27ljWt3uhdQJ8cEsqeF03p?=
 =?us-ascii?Q?YdCDpn41QGQNmyq/ekb8bThHHzKLxsLPBSJtzPMddjdz0kc195aEf/ALd8xX?=
 =?us-ascii?Q?8+sp8b0/A8hr2QXKfuN3bAcUwcF5Kkx7GsCCq+j0mMvtpd7Kb3ByYICUQasS?=
 =?us-ascii?Q?bA/+uAAK51UZ3hcIxrCUwQ8M+vvQ2pPyCVa7wSdkSDYK7z+WUEs16iymT8vg?=
 =?us-ascii?Q?n7RYxp4UGIAqaqWgx7WB3WDeno6Kp1iUZtil6RUYz4t4nQnGeer6hMIEuWga?=
 =?us-ascii?Q?PTcoIm9/nDWhWHXVGHoYklzj12pfAcrfYjFuyTW5Ty2WKiCXXrOFeJSiqgpy?=
 =?us-ascii?Q?DO14JOtfq8Tji2HwilmFwBoUbnE0PK7cEE7ON0snmlq1ZhZDcVicd5J9/OZ7?=
 =?us-ascii?Q?iaY1d+c9IWf/QlE+/w/3D2KB/rQTDaBBsG4JW2vErcN6vFk+FwD4EpplJEXN?=
 =?us-ascii?Q?/km4cfhx7JgkFCIozPsIXz7LbeEwN/YV8cExtyT/dOadkhKP7jHsEFZG7wxb?=
 =?us-ascii?Q?jeuBr5KzyY8TMp4bXsOfsjUnGvo1cNNc6i0XPZBFG8soXAfWmnQvDZgwCd8d?=
 =?us-ascii?Q?aA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5028.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1676b40-747f-4354-0546-08db66b2589d
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 17:20:37.9697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g2p5u0+uHbptZ1BwRijxqHrzSaTbW5SexYD0R02nrAgI89RiQRDLFDrAIIjC2YlXt7/Yyo0QW2EHNaXqsnO5Vd2VkCRm3MfIDAZAXKyBkFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR11MB5654
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of T=
ariq Toukan
> Sent: Friday, May 26, 2023 2:48 AM
> To: Simon Horman <horms@kernel.org>; Brandeburg, Jesse <jesse.brandeburg@=
intel.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: Mishra, Sudhansu Sekhar <sudhansu.mishra@intel.com>; Kolacinski, Karo=
l <karol.kolacinski@intel.com>; linux-kernel@vger.kernel.org; Eric Dumazet =
<edumazet@google.com>; intel-wired-lan@lists.osuosl.org; netdev@vger.kernel=
.org; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Da=
vid S. Miller <davem@davemloft.net>; Dan Carpenter <dan.carpenter@linaro.or=
g>
> Subject: Re: [Intel-wired-lan] [PATCH net] ice: Don't dereference NULL in=
 ice_gns_read error path
>
>
>
> On 25/05/2023 13:52, Simon Horman wrote:
>>  If pf is NULL in ice_gns_read() then it will be dereferenced in the=20
>> error path by a call to dev_dbg(ice_pf_to_dev(pf), ...).
>>
>>  Avoid this by simply returning in this case.
>>  If logging is desired an alternate approach might be to use pr_err()=20
>>  before returning.
>> =20
>>  Flagged by Smatch as:
>> =20
>>     .../ice_gnss.c:196 ice_gnss_read() error: we previously assumed=20
>>  'pf' could be null (see line 131)
> >
>>  Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
>>  Signed-off-by: Simon Horman <horms@kernel.org>
>>  ---
Tested-by: Sunitha Mekala <sunithax.d.mekala@intel.com> (A Contingent worke=
r at Intel)

