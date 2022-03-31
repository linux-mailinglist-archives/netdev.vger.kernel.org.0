Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE69D4ED5EF
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbiCaImP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232656AbiCaImO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:42:14 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67AA1F6867;
        Thu, 31 Mar 2022 01:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648716027; x=1680252027;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Wq9ZCmlBbpnQ6SW7emW+opZxSxLwP6ZI+zOf2qM6ceE=;
  b=PVIFzILOZzXbao74N2CG9QtoE2JUa6gzVOEwk6VzCKbtLabgfDpRpuoR
   BkDh3z+7rZG2uFQPN5+lTDSD4Xs94WG3ZIkUMcKmw595yHuYggPuIemyG
   Mx7IdifTRwNi/bSPSpvkXV0uVstSYffe9pulYAcg3uWmRXP/4oQ80kHi5
   0kzvLKThFzQsfHai4SQnmUq8WpxnsC74OQINmYb8NBXg7ziCX2SdPTiSZ
   qD/RTNNYpGjZse/DtXzwkP+b9yBCqYuCGOjZYPH0ODOeY1HaGteI/iPCe
   4kU/WMFF7t5xVxpEDmp+MQGRRFOYeuqaLPetp7CWivs7e53GEKxEpwG6e
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="239686423"
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="239686423"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 01:40:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,224,1643702400"; 
   d="scan'208";a="566281013"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 31 Mar 2022 01:39:59 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 01:39:58 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 31 Mar 2022 01:39:58 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 31 Mar 2022 01:39:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S/of/FKQmE+CZaA7y0zRBbI5osk/Qvpv5K25pUswF/0bXbVLqVNAH/BuerdQLWAa8PMhWxJvOPbmTIHgnA8OR37c3NIXD6Fgz8OZOCc9ml7naOixO5ARMR9NWUOAPBopRwvS2dBmzX+O8rxeIqxcO6g+hABjHtz/7U2gFYDcMzl+aOXdHBtxNGYTt68LNMXKZbeUm9uT4Mum6fj7Gj+gpdP39AO82ULsuuYay0TvCUjKkhCvae97+mxbYAF5g5EtbEmFJjfa4e11TWMAHuaIqWlEawZW9TlPugmWcurgsjPIgADVSGr8QG5oJrIAve5J61muAPFM6bsXHnZTuw/vIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wq9ZCmlBbpnQ6SW7emW+opZxSxLwP6ZI+zOf2qM6ceE=;
 b=XpWpA3gRvmOyO2Pe+mn8yJzRXMMd5IYNwMc0/cBMDqtrSW9FSXiScWK0eEGZa12q4rZgscRKt+ERWSNJYh55gc3opBrzLsKrUVcbYX5xYaqPBojpEnHnCwflf2BtZ0qpfB3PU/p3IHUF266lEoNw7qghkaLgEr6AD7/BnFDScIEcc4o4cINPEACovnWxNxeIXodI6X11LkkzNebNxlQOXG4Dq4P9Uajf+tnAtp70GfGQLxGWSSN67nObUAIeGJfdK5pwbgl39ncLXdl3fIdD1qd7kabr9PYEr3TLjX6qTLC7zciA+NwdcJTvmU7SClWdWASZs+fIkrEQI5JhS//c7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5445.namprd11.prod.outlook.com (2603:10b6:208:30b::7)
 by DM6PR11MB4284.namprd11.prod.outlook.com (2603:10b6:5:205::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Thu, 31 Mar
 2022 08:39:56 +0000
Received: from BL1PR11MB5445.namprd11.prod.outlook.com
 ([fe80::55fe:1d31:4f97:9f92]) by BL1PR11MB5445.namprd11.prod.outlook.com
 ([fe80::55fe:1d31:4f97:9f92%6]) with mapi id 15.20.5102.023; Thu, 31 Mar 2022
 08:39:56 +0000
From:   "Liu, Chuansheng" <chuansheng.liu@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "deller@gmx.de" <deller@gmx.de>, "x86@kernel.org" <x86@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        Song Liu <song@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>,
        Borislav Petkov <bp@alien8.de>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH] fbdev: defio: fix the pagelist corruption
Thread-Topic: [PATCH] fbdev: defio: fix the pagelist corruption
Thread-Index: AQHYOcSRnc9LTAQJmE6ZG+PF4wN6xazRXpEAgAKlKOCAAF8dAIABKG+wgAKsr4CAAHj40IAAjDcAgAAEigA=
Date:   Thu, 31 Mar 2022 08:39:56 +0000
Message-ID: <BL1PR11MB5445D978D1F47D0761C645F997E19@BL1PR11MB5445.namprd11.prod.outlook.com>
References: <20220317054602.28846-1-chuansheng.liu@intel.com>
 <c058f18b-3dae-9ceb-57b4-ed62fedef50a@molgen.mpg.de>
 <BL1PR11MB54455684D2A1B4F0A666F861971D9@BL1PR11MB5445.namprd11.prod.outlook.com>
 <502adc88-740f-fd68-d870-4f5577e1254d@molgen.mpg.de>
 <BL1PR11MB544534F78BE2AB3502981AE5971D9@BL1PR11MB5445.namprd11.prod.outlook.com>
 <baebc9c2-a8fc-9b36-6133-7fa8368a93d5@molgen.mpg.de>
 <BL1PR11MB5445633C68B3039320FE780E97E19@BL1PR11MB5445.namprd11.prod.outlook.com>
 <208cb9f0-09e1-094f-5bca-9a9effbf1da8@molgen.mpg.de>
In-Reply-To: <208cb9f0-09e1-094f-5bca-9a9effbf1da8@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e95a467-1394-426d-04b6-08da12f208cd
x-ms-traffictypediagnostic: DM6PR11MB4284:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4284CC6D4240440ADAB654D197E19@DM6PR11MB4284.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v6JpEiXj6jDa8NKumAt+8X9J9NwK6ox6HgIdPgUvx4kXLzhBkLIz27Cd6Jp+Ebk5+IcNZ1gBxi0FFRvOKBri2uEhd9YTU+wEpZGO8PqEy1d+Nnk0pYY18bHHrJVgtwrO2vXTWKIlb9eCNHx5x65kCavEP6Z0ygN64l6c22mXhPD3tDNqT+/YEbIImutKfo/AnqxACKIRvm4/ssMdgGsNVVVsYh2Ukxt3QFjacv16nyiu+SmpMj5fNu2pyp3GamD0qLsxE7PVZFiFGP6ahlhqCwx4+swdkwtkAJlFMOydZRcUD5m9cULdS64GDnUUK97Vv0PKGWNnNkbNnzCMoNIn2A/m8EIOKtt3+qaxj5c5rDQg4Br0UOkdsRcRKJI/M+feA1hddvfKKOaiDUcUqI9SvDzwM2DY7x7lTLcbJ7pRwgtixDcOVAAQHrPqQF3Zk91pLOBQsxy9nKcqlCYN3s2h8ztwj++A19BbIv9+x6uz/xVJZYDXKk3JMDuNY8gjR/fNEgTH5gy7NzlWpEgrAi2f67f8J4b6UDMLLPUnJODmzy4ba3ca7+rvarfLV7Qj5SYuyGn/PFs5ONn1i6m8LXh/LWUofS7yOhFFQN9tIugS+8BKQE0JU5Me9Qv17TqZTimWqKdIteJzxDqNcbhifkL4nYqSSYAUpM+fGrxhPWkTDV7/mDQOJ35vWWBuK0AIM3aRggAZXMB0CAjCtbMFWIHLY8AsinYAqIafOI5cejMZeU8G9OgVwiEEY8Nvl4ytnQzYf+r0GU1JTDnMjT5aGl3rch1c7OCGh2T8Ogwxa7dorQI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5445.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66446008)(64756008)(76116006)(66556008)(186003)(26005)(66946007)(8676002)(4326008)(54906003)(6916009)(33656002)(55016003)(83380400001)(316002)(122000001)(52536014)(71200400001)(7416002)(8936002)(5660300002)(38100700002)(966005)(9686003)(7696005)(6506007)(2906002)(82960400001)(86362001)(38070700005)(53546011)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cWUreVVqZVgwckhWcEVqeGRWcC93WVJrT1BKb3dmOU1WckhlZ29QcE9UYWRH?=
 =?utf-8?B?akVaK3NZcHExYm5MRFFDbS9lMlNqelJndGg4eE1MY0RHRHBPN1lGUk1kaUJu?=
 =?utf-8?B?bHRzTkxvb29IQ2VJcVh4V2NCMC8vdC9DWXNLbnljb0grMkd1NFk1WGw2UHRi?=
 =?utf-8?B?ZUJkSkhKSDM4NDI1bHlXcnRxMTcxaUxGVzlWaW9sYkdFNXdEV1pKZFBwNWxZ?=
 =?utf-8?B?YmFZNW12QWRoRCt4ZEhDRmVlRW40KzZMYVRlOTJoQjJEZnV4YmxLKzJHU3lU?=
 =?utf-8?B?b0pmK2hqN3Z5eFRUTUs4ZlZ5S2VHbU1DVFZsTE9ySlBaWjNCY1haQmtIM21B?=
 =?utf-8?B?T2UwZld1STJOQmFUMFIxZlRUYjhuMG5qaDNXYlpTQzZTak53Q3RYTUxFblYz?=
 =?utf-8?B?NjNYMTI5VnlUckV2ejZld1RMUk1zMmI0WlVDbWtrU2xnRENSemtXU01aSGc1?=
 =?utf-8?B?VWI4OEZUZXA2M3NsNnBLR0lDYnZhTzljcDlCTmtyMzZCcWNwcjg1VVZrVkZl?=
 =?utf-8?B?cEdkbnZqa2w2ZVQ3VmpmNnRwUEsrYWxZbHNsS3F2b3NUcEJxQUszQ09GYWVh?=
 =?utf-8?B?c1JoRi9NdSt6TnBYRkRlMnBuQ0xZYks3NU5kQU03aVNFdVk2SDVsS2dBZFUr?=
 =?utf-8?B?b2cwdVBWMHZXZEo4dENyZ09sUTgrd1d6eHNvcHhnYnZzUVliL2Q3aXJqcTJL?=
 =?utf-8?B?QmFOQVlSYytQRDVYZFdkMGhSSFBqUFdqNGtSK0dBTzFjQUNnVUhtOVgzRmx2?=
 =?utf-8?B?Tllxb3FiTTRwbCt1U2w0aGRnTmc5UHFFTDFweHhoQm9xdkorOFB6Y1FXYlRl?=
 =?utf-8?B?dmJnVXUrZmhFbDdSWklCYzllb1JzRHA1ZjU3eWlGT2dGQ1FTUDBHVEtjTDl3?=
 =?utf-8?B?UUYvaEdKdW9rbXhEeWJJVXZWME1QUjM5Yi9RQU5JdGVvZ3I1UXVuU3RGS1N3?=
 =?utf-8?B?YU0zbE1XL2NhUFZMU0YxSTZIdjYzd1ZaL3BjWU12dDJVd1QvR2Q4aGtUOVo4?=
 =?utf-8?B?ajhwL3hxaEtGV2ZkRUVIUWE4c1Z0SjZRbUVxb3ArbWh1VlR6Tk1QTU9oMTFz?=
 =?utf-8?B?NHpUc3lDVXRVZ1ZqbWhVODd5aGFvNVRBUFplbytuaGl1Z21PMFRsbmZReDVq?=
 =?utf-8?B?eXhBbHRrNThycldsdVZLR0FnanJYaWI4WkRCK3VPUnpDb2xwMmpLbXdZdU9n?=
 =?utf-8?B?L1VNdnJ3YmJlZVZsakRpYmpWanc4RlpaRWNKUTZFdDJ2UHcySFUrYklmTEYz?=
 =?utf-8?B?QWd6amhqTkdmWGhEbE5SOFozNXVWcTRydzVqaGloSzlKeEdHaXlpak9xMDJI?=
 =?utf-8?B?UXFRMTdEbjlUYXdUQy9GRDFtWjRHUDB2NjB2UjhyZkorbkxMWWxRaHVVZlpU?=
 =?utf-8?B?NTFvV3FmQW45M2xqc3Ztamw4VzkybFZraHQ2K2ZhaVpISjdURWloaTM2ZFBn?=
 =?utf-8?B?czlLKzhxNURGVFhpR3hVNTRxdnp1UXVwZGw1d2w1Y1lNNDF1NjhPaEtSbitN?=
 =?utf-8?B?NkNpUnRhQjVkY0pQYzdtNHMwUVVYYlNZUFlMcEo5VCt1ZlpBRkFpaEUxRGJr?=
 =?utf-8?B?cExidzRrWmpRK3F3TVFZSmFFRThhWVQvZTZqc2dyTGNPQWxhbGZwNTFGdlRP?=
 =?utf-8?B?ODBDNTNrMVFJRFdUOWdDWm1xYVBqMkxTcTRIUUwvdWsrMmZEMEl1VVh4Wm9s?=
 =?utf-8?B?NFpzWnU0WDZMMzlhVTlBRnQ1ZnhXWmRDaEFtTngvTDgxYUxTa0gvS3pLNWRS?=
 =?utf-8?B?MlRKUEJkS2w0MTI2dWxZb3hycEowUUNGZVlRL25GYTY2T2NFZEMrU1luNTNK?=
 =?utf-8?B?TFJzdEFjYXU5b0xsM1QvY1NJSlNna3MxODZEajFob0hpSElEQWQvMy9TaDN6?=
 =?utf-8?B?SmFzVVJySnhQVFVLb0ZOdHZoRDVvWS9qRFkrSmlPUUlTakFnVEZ6RDJwUkxQ?=
 =?utf-8?B?NzB5THMrWDVBRUZuUVJnTUxpdFZoTWFWazlJdVN5YzRoNkpLWTNkTVl2MHdw?=
 =?utf-8?B?VTR5ZzBnNWFhUFRDSU5NQkdaUE5Gdzh6blFOZjJKYTVTNk1XQzRQVmpGR045?=
 =?utf-8?B?anViekd4cVZxbG9xVVA4YTFTZHQwOWtZbFZlQ21pUkNXdmo3Y0FaVTM0Tkgv?=
 =?utf-8?B?T2ZaUk9JaitNZlJKVVVXbTlmRW9wMVpIclk4SFJFYysvbU53cHMvdjIyMkVx?=
 =?utf-8?B?OWVXSC80Y0VZVjFNczRhMmFwUGFyeFFrWktpbERJT29tbnJ6bDFxWURxS1o0?=
 =?utf-8?B?NGppQjM0K3gzaElaODNiOFJvWjV3MWVUZHJTc1JnbURpQkJvL2xweHRSSWlM?=
 =?utf-8?B?VDNodVE1QXpTakpiblhIQVZGemt0VEpjZE04a0JwZEI2Rk90eWZ3RTVLaDBW?=
 =?utf-8?Q?fUx/B6Gf7Xim+O54=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5445.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e95a467-1394-426d-04b6-08da12f208cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 08:39:56.4136
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +UEIt51nctr9SHCDNfWCD4+XD2eZYhXX/vdphtjH9K3DXxB66AWAU2Ax4arBcHUYNk8d/ZO4eiUIPvw9pm+W2IrdMW9Rjjypi3CyX2+FU4g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4284
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUGF1bCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBkcmktZGV2
ZWwgPGRyaS1kZXZlbC1ib3VuY2VzQGxpc3RzLmZyZWVkZXNrdG9wLm9yZz4gT24gQmVoYWxmIE9m
IFBhdWwNCj4gTWVuemVsDQo+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAzMSwgMjAyMiA0OjIyIFBN
DQo+IFRvOiBMaXUsIENodWFuc2hlbmcgPGNodWFuc2hlbmcubGl1QGludGVsLmNvbT4NCj4gQ2M6
IGxpbnV4LWZiZGV2QHZnZXIua2VybmVsLm9yZzsgRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGxp
bnV4LmludGVsLmNvbT47DQo+IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7IGRhbmllbEBpb2dl
YXJib3gubmV0OyBsaW51eC1tbUBrdmFjay5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IGRlbGxlckBnbXguZGU7IHg4NkBrZXJuZWwub3JnOyBhc3RAa2VybmVsLm9yZzsgZHJpLQ0KPiBk
ZXZlbEBsaXN0cy5mcmVlZGVza3RvcC5vcmc7IGFuZHJpaUBrZXJuZWwub3JnOyBTb25nIExpdSA8
c29uZ0BrZXJuZWwub3JnPjsNCj4gSW5nbyBNb2xuYXIgPG1pbmdvQHJlZGhhdC5jb20+OyBUaG9t
YXMgR2xlaXhuZXIgPHRnbHhAbGludXRyb25peC5kZT47DQo+IHR6aW1tZXJtYW5uQHN1c2UuZGU7
IEJvcmlzbGF2IFBldGtvdiA8YnBAYWxpZW44LmRlPjsgYnBmQHZnZXIua2VybmVsLm9yZzsNCj4g
RWRnZWNvbWJlLCBSaWNrIFAgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPjsga2VybmVsLXRl
YW1AZmIuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIGZiZGV2OiBkZWZpbzogZml4IHRoZSBw
YWdlbGlzdCBjb3JydXB0aW9uDQo+IA0KPiBEZWFyIENodWFuc2hlbmcsDQo+IA0KPiANCj4gQW0g
MzEuMDMuMjIgdW0gMDI6MDYgc2NocmllYiBMaXUsIENodWFuc2hlbmc6DQo+IA0KPiA+PiAtLS0t
LU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBQYXVsIE1lbnplbCA8cG1lbnplbEBt
b2xnZW4ubXBnLmRlPg0KPiA+PiBTZW50OiBUaHVyc2RheSwgTWFyY2ggMzEsIDIwMjIgMTI6NDcg
QU0NCj4gDQo+IFvigKZdDQo+IA0KPiA+PiBBbSAyOS4wMy4yMiB1bSAwMTo1OCBzY2hyaWViIExp
dSwgQ2h1YW5zaGVuZzoNCj4gPj4NCj4gPj4+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiA+Pj4+IEZyb206IFBhdWwgTWVuemVsDQo+ID4+Pj4gU2VudDogTW9uZGF5LCBNYXJjaCAyOCwg
MjAyMiAyOjE1IFBNDQo+ID4+DQo+ID4+Pj4gQW0gMjguMDMuMjIgdW0gMDI6NTggc2NocmllYiBM
aXUsIENodWFuc2hlbmc6DQo+ID4+Pj4NCj4gPj4+Pj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+ID4+Pj4NCj4gPj4+Pj4+IFNlbnQ6IFNhdHVyZGF5LCBNYXJjaCAyNiwgMjAyMiA0OjEx
IFBNDQo+ID4+Pj4NCj4gPj4+Pj4+IEFtIDE3LjAzLjIyIHVtIDA2OjQ2IHNjaHJpZWIgQ2h1YW5z
aGVuZyBMaXU6DQo+ID4+Pj4+Pj4gRWFzaWx5IGhpdCB0aGUgYmVsb3cgbGlzdCBjb3JydXB0aW9u
Og0KPiA+Pj4+Pj4+ID09DQo+ID4+Pj4+Pj4gbGlzdF9hZGQgY29ycnVwdGlvbi4gcHJldi0+bmV4
dCBzaG91bGQgYmUgbmV4dCAoZmZmZmZmZmZjMGNlYjA5MCksIGJ1dA0KPiA+Pj4+Pj4+IHdhcyBm
ZmZmZWM2MDQ1MDdlZGM4LiAocHJldj1mZmZmZWM2MDQ1MDdlZGM4KS4NCj4gPj4+Pj4+PiBXQVJO
SU5HOiBDUFU6IDY1IFBJRDogMzk1OSBhdCBsaWIvbGlzdF9kZWJ1Zy5jOjI2DQo+ID4+Pj4+Pj4g
X19saXN0X2FkZF92YWxpZCsweDUzLzB4ODANCj4gPj4+Pj4+PiBDUFU6IDY1IFBJRDogMzk1OSBD
b21tOiBmYmRldiBUYWludGVkOiBHICAgICBVDQo+ID4+Pj4+Pj4gUklQOiAwMDEwOl9fbGlzdF9h
ZGRfdmFsaWQrMHg1My8weDgwDQo+ID4+Pj4+Pj4gQ2FsbCBUcmFjZToNCj4gPj4+Pj4+PiAgICAg
IDxUQVNLPg0KPiA+Pj4+Pj4+ICAgICAgZmJfZGVmZXJyZWRfaW9fbWt3cml0ZSsweGVhLzB4MTUw
DQo+ID4+Pj4+Pj4gICAgICBkb19wYWdlX21rd3JpdGUrMHg1Ny8weGMwDQo+ID4+Pj4+Pj4gICAg
ICBkb193cF9wYWdlKzB4Mjc4LzB4MmYwDQo+ID4+Pj4+Pj4gICAgICBfX2hhbmRsZV9tbV9mYXVs
dCsweGRjMi8weDE1OTANCj4gPj4+Pj4+PiAgICAgIGhhbmRsZV9tbV9mYXVsdCsweGRkLzB4MmMw
DQo+ID4+Pj4+Pj4gICAgICBkb191c2VyX2FkZHJfZmF1bHQrMHgxZDMvMHg2NTANCj4gPj4+Pj4+
PiAgICAgIGV4Y19wYWdlX2ZhdWx0KzB4NzcvMHgxODANCj4gPj4+Pj4+PiAgICAgID8gYXNtX2V4
Y19wYWdlX2ZhdWx0KzB4OC8weDMwDQo+ID4+Pj4+Pj4gICAgICBhc21fZXhjX3BhZ2VfZmF1bHQr
MHgxZS8weDMwDQo+ID4+Pj4+Pj4gUklQOiAwMDMzOjB4N2ZkOThmYzhmYWQxDQo+ID4+Pj4+Pj4g
PT0NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IEZpZ3VyZSBvdXQgdGhlIHJhY2UgaGFwcGVucyB3aGVu
IG9uZSBwcm9jZXNzIGlzIGFkZGluZyAmcGFnZS0+bHJ1DQo+IGludG8NCj4gPj4+Pj4+PiB0aGUg
cGFnZWxpc3QgdGFpbCBpbiBmYl9kZWZlcnJlZF9pb19ta3dyaXRlKCksIGFub3RoZXIgcHJvY2Vz
cyBpcw0KPiA+Pj4+Pj4+IHJlLWluaXRpYWxpemluZyB0aGUgc2FtZSAmcGFnZS0+bHJ1IGluIGZi
X2RlZmVycmVkX2lvX2ZhdWx0KCksIHdoaWNoIGlzDQo+ID4+Pj4+Pj4gbm90IHByb3RlY3RlZCBi
eSB0aGUgbG9jay4NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IFRoaXMgZml4IGlzIHRvIGluaXQgYWxs
IHRoZSBwYWdlIGxpc3RzIG9uZSB0aW1lIGR1cmluZyBpbml0aWFsaXphdGlvbiwNCj4gPj4+Pj4+
PiBpdCBub3Qgb25seSBmaXhlcyB0aGUgbGlzdCBjb3JydXB0aW9uLCBidXQgYWxzbyBhdm9pZHMg
SU5JVF9MSVNUX0hFQUQoKQ0KPiA+Pj4+Pj4+IHJlZHVuZGFudGx5Lg0KPiA+Pj4+Pj4+DQo+ID4+
Pj4+Pj4gRml4ZXM6IDEwNWE5NDA0MTZmYyAoImZiZGV2L2RlZmlvOiBFYXJseS1vdXQgaWYgcGFn
ZSBpcyBhbHJlYWR5DQo+IGVubGlzdGVkIikNCj4gPj4+Pj4+PiBDYzogVGhvbWFzIFppbW1lcm1h
bm4gPHR6aW1tZXJtYW5uQHN1c2UuZGU+DQo+ID4+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogQ2h1YW5z
aGVuZyBMaXUgPGNodWFuc2hlbmcubGl1QGludGVsLmNvbT4NCj4gPj4+Pj4+PiAtLS0NCj4gPj4+
Pj4+PiAgICAgIGRyaXZlcnMvdmlkZW8vZmJkZXYvY29yZS9mYl9kZWZpby5jIHwgOSArKysrKysr
Ky0NCj4gPj4+Pj4+PiAgICAgIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkNCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3ZpZGVv
L2ZiZGV2L2NvcmUvZmJfZGVmaW8uYw0KPiBiL2RyaXZlcnMvdmlkZW8vZmJkZXYvY29yZS9mYl9k
ZWZpby5jDQo+ID4+Pj4+Pj4gaW5kZXggOThiMGYyM2JmNWUyLi5lYWZiNjZjYTRmMjggMTAwNjQ0
DQo+ID4+Pj4+Pj4gLS0tIGEvZHJpdmVycy92aWRlby9mYmRldi9jb3JlL2ZiX2RlZmlvLmMNCj4g
Pj4+Pj4+PiArKysgYi9kcml2ZXJzL3ZpZGVvL2ZiZGV2L2NvcmUvZmJfZGVmaW8uYw0KPiA+Pj4+
Pj4+IEBAIC01OSw3ICs1OSw2IEBAIHN0YXRpYyB2bV9mYXVsdF90IGZiX2RlZmVycmVkX2lvX2Zh
dWx0KHN0cnVjdA0KPiB2bV9mYXVsdCAqdm1mKQ0KPiA+Pj4+Pj4+ICAgICAgCQlwcmludGsoS0VS
Tl9FUlIgIm5vIG1hcHBpbmcgYXZhaWxhYmxlXG4iKTsNCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+ICAg
ICAgCUJVR19PTighcGFnZS0+bWFwcGluZyk7DQo+ID4+Pj4+Pj4gLQlJTklUX0xJU1RfSEVBRCgm
cGFnZS0+bHJ1KTsNCj4gPj4+Pj4+PiAgICAgIAlwYWdlLT5pbmRleCA9IHZtZi0+cGdvZmY7DQo+
ID4+Pj4+Pj4NCj4gPj4+Pj4+PiAgICAgIAl2bWYtPnBhZ2UgPSBwYWdlOw0KPiA+Pj4+Pj4+IEBA
IC0yMjAsNiArMjE5LDggQEAgc3RhdGljIHZvaWQgZmJfZGVmZXJyZWRfaW9fd29yayhzdHJ1Y3QN
Cj4gd29ya19zdHJ1Y3QgKndvcmspDQo+ID4+Pj4+Pj4gICAgICB2b2lkIGZiX2RlZmVycmVkX2lv
X2luaXQoc3RydWN0IGZiX2luZm8gKmluZm8pDQo+ID4+Pj4+Pj4gICAgICB7DQo+ID4+Pj4+Pj4g
ICAgICAJc3RydWN0IGZiX2RlZmVycmVkX2lvICpmYmRlZmlvID0gaW5mby0+ZmJkZWZpbzsNCj4g
Pj4+Pj4+PiArCXN0cnVjdCBwYWdlICpwYWdlOw0KPiA+Pj4+Pj4+ICsJaW50IGk7DQo+ID4+Pj4+
Pj4NCj4gPj4+Pj4+PiAgICAgIAlCVUdfT04oIWZiZGVmaW8pOw0KPiA+Pj4+Pj4+ICAgICAgCW11
dGV4X2luaXQoJmZiZGVmaW8tPmxvY2spOw0KPiA+Pj4+Pj4+IEBAIC0yMjcsNiArMjI4LDEyIEBA
IHZvaWQgZmJfZGVmZXJyZWRfaW9faW5pdChzdHJ1Y3QgZmJfaW5mbyAqaW5mbykNCj4gPj4+Pj4+
PiAgICAgIAlJTklUX0xJU1RfSEVBRCgmZmJkZWZpby0+cGFnZWxpc3QpOw0KPiA+Pj4+Pj4+ICAg
ICAgCWlmIChmYmRlZmlvLT5kZWxheSA9PSAwKSAvKiBzZXQgYSBkZWZhdWx0IG9mIDEgcyAqLw0K
PiA+Pj4+Pj4+ICAgICAgCQlmYmRlZmlvLT5kZWxheSA9IEhaOw0KPiA+Pj4+Pj4+ICsNCj4gPj4+
Pj4+PiArCS8qIGluaXRpYWxpemUgYWxsIHRoZSBwYWdlIGxpc3RzIG9uZSB0aW1lICovDQo+ID4+
Pj4+Pj4gKwlmb3IgKGkgPSAwOyBpIDwgaW5mby0+Zml4LnNtZW1fbGVuOyBpICs9IFBBR0VfU0la
RSkgew0KPiA+Pj4+Pj4+ICsJCXBhZ2UgPSBmYl9kZWZlcnJlZF9pb19wYWdlKGluZm8sIGkpOw0K
PiA+Pj4+Pj4+ICsJCUlOSVRfTElTVF9IRUFEKCZwYWdlLT5scnUpOw0KPiA+Pj4+Pj4+ICsJfQ0K
PiA+Pj4+Pj4+ICAgICAgfQ0KPiA+Pj4+Pj4+ICAgICAgRVhQT1JUX1NZTUJPTF9HUEwoZmJfZGVm
ZXJyZWRfaW9faW5pdCk7DQo+ID4+Pj4+Pj4NCj4gPj4+Pj4+IEFwcGx5aW5nIHlvdXIgcGF0Y2gg
b24gdG9wIG9mIGN1cnJlbnQgTGludXPigJkgbWFzdGVyIGJyYW5jaCwgdHR5MCBpcw0KPiA+Pj4+
Pj4gdW51c2FibGUgYW5kIGxvb2tzIGZyb3plbi4gU29tZXRpbWVzIG5ldHdvcmsgY2FyZCBzdGls
bCB3b3JrcywNCj4gc29tZXRpbWVzDQo+ID4+Pj4+PiBub3QuDQo+ID4+Pj4+DQo+ID4+Pj4+IEkg
ZG9uJ3Qgc2VlIGhvdyB0aGUgcGF0Y2ggd291bGQgY2F1c2UgYmVsb3cgQlVHIGNhbGwgc3RhY2ss
IG5lZWQgc29tZQ0KPiB0aW1lIHRvDQo+ID4+Pj4+IGRlYnVnLiBKdXN0IGZldyBjb21tZW50czoN
Cj4gPj4+Pj4gMS4gV2lsbCB0aGUgc3lzdGVtIHdvcmsgd2VsbCB3aXRob3V0IHRoaXMgcGF0Y2g/
DQo+ID4+Pj4NCj4gPj4+PiBZZXMsIHRoZSBmcmFtZWJ1ZmZlciB3b3JrcyB3ZWxsIHdpdGhvdXQg
dGhlIHBhdGNoLg0KPiA+Pj4+DQo+ID4+Pj4+IDIuIFdoZW4geW91IGFyZSBzdXJlIHRoZSBwYXRj
aCBjYXVzZXMgdGhlIHJlZ3Jlc3Npb24geW91IHNhdywgcGxlYXNlIGdldA0KPiBmcmVlDQo+ID4+
Pj4gdG8gc3VibWl0IG9uZSByZXZlcnRlZCBwYXRjaCwgdGhhbmtzIDogKQ0KPiA+Pj4+DQo+ID4+
Pj4gSSB0aGluayB5b3UgZm9yIHBhdGNoIHdhc27igJl0IHN1Ym1pdHRlZCB5ZXQg4oCTIGF0IGxl
YXN0IG5vdCBwdWxsZWQgYnkgTGludXMuDQo+ID4+PiBUaGUgcGF0Y2ggaGFzIGJlZW4gaW4gZHJt
LXRpcCwgY291bGQgeW91IGhhdmUgYSB0cnkgd2l0aCB0aGUgbGF0ZXN0IGRybS10aXANCj4gdG8g
c2VlDQo+ID4+PiBpZiB0aGUgRnJhbWVidWZmZXIgd29ya3Mgd2VsbCwgaW4gdGhhdCBjYXNlLCB3
ZSBjb3VsZCByZXZlcnQgaXQgaW4gZHJtLXRpcCB0aGVuLg0KPiA+Pg0KPiA+PiBXaXRoIGRybS10
aXAgKGRybS10aXA6IDIwMjJ5LTAzbS0yOWQtMTNoLTE0bS0zNXMgVVRDIGludGVncmF0aW9uDQo+
ID4+IG1hbmlmZXN0KSBldmVyeXRoaW5nIHdvcmtzIGZpbmUuIChJIGhhZCB0byBkaXNhYmxlIGFt
ZGdwdSBkcml2ZXIsIGFzIGl0DQo+ID4+IGZhaWxlZCB0byBidWlsZC4pIElzIGFueW9uZSBhYmxl
IHRvIGV4cGxhaW4gdGhhdD8NCj4gPg0KPiA+IE15IHBhdGNoIGlzIGZvciBmaXhpbmcgYW5vdGhl
ciBwYXRjaCB3aGljaCBpcyBpbiB0aGUgZHJtLXRpcCBhdCBsZWFzdCwNCj4gDQo+IFRoZSByZWZl
cmVuY2VkIGNvbW1pdCAxMDVhOTQwNDE2ZmMgaW4gdGhlIEZpeGVzIHRhZyBpcyBhbHNvIGluIExp
bnVz4oCZDQo+IG1hc3RlciBicmFuY2guDQo+IA0KPiA+IHNvIEkgYXNzdW1lIGFwcGx5aW5nIG15
IHBhdGNoIGludG8gTGludXMgdHJlZSBkaXJlY3RseSBpcyBub3QNCj4gPiBjb21wbGV0ZWx5IHBy
b3Blci4gVGhhdCdzIG15IGludGVudGlvbiBvZiBhc2tpbmcgeW91ciBoZWxwIGZvcg0KPiA+IHJl
dGVzdGluZyBkcm0tdGlwLg0KPiBJZiB0aGVyZSB3ZXJlIHN1Y2ggYSByZWxhdGlvbiwgdGhhdCB3
b3VsZCBuZWVkIHRvIGJlIGRvY3VtZW50ZWQgaW4gdGhlDQo+IGNvbW1pdCBtZXNzYWdlLg0KWW91
IHNob3VsZCBoYXZlIHNlZW4gaXQgOiApDQoNCj4gDQo+ID4gWW91IG1lYW4gZXZlcnl0aGluZyB3
b3JraW5nIGZpbmUgbWVhbnMgYW5vdGhlciBpc3N1ZSB5b3UgaGl0IGlzIGFsc28NCj4gPiBnb25l
Pw0KPiBObywgSSBqdXN0IG1lYW4gdGhlIGhhbmcgd2hlbiBhcHBseWluZyB5b3VyIHBhdGNoLg0K
PiANCj4gQW55d2F5LCBhZnRlciBmaWd1cmluZyBvdXQsIHRoYXQgZHJtLXRpcCwgaXMgYWN0dWFs
bHkgbm90IGJlaGluZCBMaW51c+KAmQ0KPiBtYXN0ZXIgYnJhbmNoLCBJIHRyaWVkIHRvIGZpZ3Vy
ZSBvdXQgdGhlIGRpZmZlcmVuY2VzLCBhbmQgaXQgdHVybnMgb3V0DQo+IGl04oCZcyBhbHNvIHJl
bGF0ZWQgdG8gY29tbWl0IGZhYzU0ZTJiZmI1YiAoeDg2L0tjb25maWc6IFNlbGVjdA0KPiBIQVZF
X0FSQ0hfSFVHRV9WTUFMTE9DIHdpdGggSEFWRV9BUkNIX0hVR0VfVk1BUCkgWzFdLCB3aGljaCBp
cyBpbg0KPiBMaW51c+KAmQ0KPiBtYXN0ZXIgYnJhbmNoLCBidXQgbm90IGRybS10aXAuIE5vdGUs
IEkgYW0gdXNpbmcgYSAzMi1iaXQgdXNlciBzcGFjZSBhbmQNCj4gYSA2NC1iaXQgTGludXgga2Vy
bmVsLiBSZXZlcnRpbmcgY29tbWl0IGZhYzU0ZTJiZmI1YiwgYW5kIGhhdmluZyB5b3VyDQo+IHBh
dGNoIGEgYXBwbGllZCwgdGhlIGhhbmcgaXMgZ29uZS4NCkdvb2QgdG8ga25vdyB5b3UgaGF2ZSBm
aWd1cmVkIGl0IG91dCwgYW5kIHRoZSBpc3N1ZSB5b3UgaGl0IGlzIG5vdCByZWxhdGVkIHRvDQpt
eSBwYXRjaCA6ICkNCg0KPiANCj4gSSBhbSBhZGRpbmcgdGhlIHBlb3BsZSBpbnZvbHZlZCBpbiB0
aGUgb3RoZXIgZGlzY3Vzc2lvbiB0byBtYWtlIHRoZW0NCj4gYXdhcmUgb2YgdGhpcyBmYWlsdXJl
IGNhc2UuDQo+IA0KPiANCj4gS2luZCByZWdhcmRzLA0KPiANCj4gUGF1bA0KPiANCj4gDQo+IFsx
XTogaHR0cHM6Ly9saW51eC1yZWd0cmFja2luZy5sZWVtaHVpcy5pbmZvL3JlZ3pib3QvbWFpbmxp
bmUvDQo=
