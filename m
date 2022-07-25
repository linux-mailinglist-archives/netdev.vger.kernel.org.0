Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3532857FA47
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 09:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiGYHay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 03:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiGYHaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 03:30:52 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F4311C2A;
        Mon, 25 Jul 2022 00:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658734251; x=1690270251;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jy7I3Vt7YPmIQn+I0E7t+OrBG9buZzn6cF9CNJ50HVo=;
  b=ksw0z32H2GO/fCaMQJmMi5m/KzfJTZ16c1nW/ZAtHk1By4ggXQgnKBaz
   LuKgtAHsMOQ896diLDuIQ1be9HzCdMLSwLTCNcqeCIEVD9SIVRxW4+j5l
   fHhdZ/NQ11RrSdVB8F6oazrPtOQshIe0wB0/xJwgo2Y2utqpr2VYpTVri
   tcZPfoGQ3KVSIEvsBwKlaRLr1kHFRzqu6ED6QDLF3iBGOfqE+j5F0ynK/
   ij8YdQ5UyRWwhJm1iigtbokxHkJb2VUCLd1g1UTbxpw9B721DAmjgsdhj
   K7exsz0vCWeVhOB/3+HEklkbD1YBvixQv8GoxvOM7hoiT4IBmFNuv+Pln
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10418"; a="274497574"
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="274497574"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2022 00:30:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,192,1654585200"; 
   d="scan'208";a="741742379"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 25 Jul 2022 00:30:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 00:30:50 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 25 Jul 2022 00:30:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 25 Jul 2022 00:30:49 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 25 Jul 2022 00:30:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gfafo0O2SQOKQxZrj8lOahsqoXxSG6dVH3Nqwrmdz613HYXK0EobsaOpGdOMFqQSZttrWynD6RDO5JrdWsHmtx0vLnDMy3YTtmEFZIz0IlHdZHCM3OIejfJnYCWpnLoS/KILgiOpabhUpxaoVjZNpBYaiTsWSrsRH6d4AvAqTwYC9TjyLrNsW82qimqprcdpIPj0E80CyjNJTOjSGeMCgzTuodfi4meZwzTOiWU6gArYc3pW+xKo2CIV+ukptfySrvgcNTd4e0YdllijLk7AmYOrcclZ/2JbGRwN9j3NPPh1Dqw4Y+BYyR0PSo+Z13IJChKwffuR4BIz2lmh0bxaJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jy7I3Vt7YPmIQn+I0E7t+OrBG9buZzn6cF9CNJ50HVo=;
 b=g3RwQvJ+VLGSay4xo9J408QaObcVcK6zpW11y6PXWcVyYh2K9L3Djit39KRw1BGDgrJJQtgDhqGmTdBDSU4tEPY1LMwBAaXNdJhIs/qyxn3L3hD7zynYsJ9tmdQNfnWxNkGULExgWvwrazm2RzdcE04i+ilRtDYppAYiQd2aHqsed+mtDa3OqJUx1c5CbWdu2mvCeuM7u8T7qQAqVq5WdRiSIOWRkcOlAmOOLO+RtUrWkb5LjVoy61eor9jk/ucGc+Z6xuh7WDiN3Dafh5H0ac1J3ndA9evPtOI4MlUWf6ncCD/5czGLnyqPUHF1R8UwrynGqm4gzrAGano93nmYiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3193.namprd11.prod.outlook.com (2603:10b6:5:57::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Mon, 25 Jul
 2022 07:30:46 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5458.024; Mon, 25 Jul 2022
 07:30:46 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Topic: [PATCH V2 vfio 03/11] vfio: Introduce DMA logging uAPIs
Thread-Index: AQHYl1nJKS3L4jvyo020+ZxRKt+bu62IiPNggAAsCgCABgpRoA==
Date:   Mon, 25 Jul 2022 07:30:46 +0000
Message-ID: <BN9PR11MB5276BEDFBBD53A44C1525A118C959@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-4-yishaih@nvidia.com>
 <BN9PR11MB5276B26F76F409BE27E593758C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
In-Reply-To: <56bd06d3-944c-18da-86ed-ae14ce5940b7@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfd829e8-35dc-490a-c93e-08da6e0f96e8
x-ms-traffictypediagnostic: DM6PR11MB3193:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /knEfcItA5iry4UcVjlkTnTQ3B/BE5GTGDeIgD9cBhE1yFIC4K8EVHsKeVZGeRti2oXM90ZJzPRByDpFCikwx46BTnzVTXkfFhW0945wDxMsNFuIYIb7XOIvNb0zvMBZbRlY+mCeeOdWb5qxhn7taYM7uHCgkXq4t6jPOFS2yIqpZcXwJkXxoxXQ9vTJNBSlKduEcfnwmp5JgLd58IEZxixqMkExCXKOxhYdUKaQPqjO/ttKJ+VTNPnpT78rbrAi1Qm1Ae8kJ5VyBkaIwF9INmdvBTvfi9VrbtbGedY6RUHNnhZhEFGdW1qZcA+Lvi8Fuugt6GzAfAJWjAesm/EENb0c9QfOzuk8/m+2fK5I7SHLGQSefjxQzj7VJJYicncWE+RoYqK0qMPas8GMuZKqoorCVuCqO3Yn2lfdXZkxmVJgUOkEW+rMgaJ9P9RjiH54CxxYekYp/lq0rAYMNL/LKOLHOuEGvHtJO+csWtvNnb2TwQDWTjLNaINVqLjqZZJertJqEE1htghTysZr0L1XfxhFRbpEPzOEBw//WN7qu5j9aUsNnC3957/MLqxVh7UZp5u6C4lVkjV/bJHjzkGmDuq8Si6Z4cqnRzj0/xpSD4UWZNicB2BC+4+eSWeMCC/biX5ny7BSxdkLB7J9vvIse9KlYpR2kKwEV/HzYEtZIoN73fq0ZUwVV2V9k5Prm/gCPnWYD0myEIXLCVhD2PSHaHJRk+Z/uGt64j9/+UJ2FokGZof7quwgh6OLKaGKVsNkf18+wS8li8ITLqpq6w14fMT+ya7W2Fs7dkg6s4IY+eU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(396003)(136003)(39860400002)(86362001)(41300700001)(2906002)(26005)(9686003)(7696005)(6506007)(33656002)(71200400001)(7416002)(5660300002)(478600001)(8936002)(52536014)(83380400001)(55016003)(38070700005)(186003)(38100700002)(122000001)(82960400001)(8676002)(66446008)(4326008)(66476007)(54906003)(110136005)(316002)(66556008)(64756008)(76116006)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1Rwc3NzOTJuZEM0RzJMSmEyQVhNS3pybXYxdml6Qmt5dDZNamJhYkpYeFMr?=
 =?utf-8?B?SGtDeXdqNGVQMVV5NkVCWGRxSTNlbUJBL0JKMkliVVU3QWFsZFJSQ0RxcitO?=
 =?utf-8?B?TzhpMlRRcHQwbTdiSExFU1EvOUdnNWlGM0E0WGFoVzVqcGpWbUN2ZFh5NnBV?=
 =?utf-8?B?MEtPWGI3T2hGaTJBWldPYTVWMlVzYVBDV2NrNGJjbXZLZW9UZlAwVThTRHdB?=
 =?utf-8?B?L0FJc2RwM2lmWkZOYjY5aHNkbG8wdTM1UnhQUVMreGNKbWo1dzhLQ0hKbVpq?=
 =?utf-8?B?TUI4QWp0VGFWZmN1NmkvcFU0a09JakZlNVlycnAxQlIvcDdDZUs3R0pLUU1U?=
 =?utf-8?B?d1lQQzdNbW9EWUpnWVM2c3BnQnlkQTY0Q0p3Z2UwTkl1ZGdMdXNSNTlQT0VH?=
 =?utf-8?B?aE81SWJjVnFtN0ExR2thSE5GYzFvcGRLa21DY2JXaFRCZkFUbTlxSUJQQVNm?=
 =?utf-8?B?VWNObWJsSDZLT1oxQUdRYWRuc3Jnbk4vaTBRWitCQmJDUXB5Y1kwNXJGaVF0?=
 =?utf-8?B?MlJTUjRVTGVGek1DY3dtZ2hwWXE0OEFKLzhkU3pwTnVzWnkzVzR1TzNLcGlS?=
 =?utf-8?B?Qmg5dXQzS3BWc3JmZGd2N2lnRUdWSHNwWnB5ek5HcnpydzdJZUJBdCtwak51?=
 =?utf-8?B?QVJpeVZKMnk3TWRLUEdhK1pnSGdaUnZXejgyUGdRYnpkOEN6SmR6R1Z1TVVW?=
 =?utf-8?B?NlgxcmRWSllxbVRnamY0R1hULzk4TE96REYzNi9yQXdrTGgxTi9EZnV1bGVs?=
 =?utf-8?B?RnRnZlN6NVc0WG9hM1FYd3Y3Kzg1OWpTS1Nva3oyejBzVyttMTBwZmFrZzdY?=
 =?utf-8?B?N3FTVXhTNFVWYjdaenBmRTRPTlNZeHNSOUVSNVUzcW8xNXoyV0o5VGwzbXQr?=
 =?utf-8?B?T0VZYzQwZ1FkVThQSjJpMFhHc1R6YnBLQWllWmwzLzB3YlgzMHJ2QUNoZnpL?=
 =?utf-8?B?UWpuMEk2aC9ZcEpZeUNtRkN5M0labzJMVVFyUlNZN1pjQ2JwNDhob0pSQXBG?=
 =?utf-8?B?VmxMY0FHUWIwS0RibjFCekFVWnVad3ArUmR5RS9CZDl5QlpadFFoNzFUY0ww?=
 =?utf-8?B?WE4xNHk0d3hSREdUWHg0b3lZSzNueXhkRHRnRzhEb0tOdWMzelNlMldHRzMv?=
 =?utf-8?B?VWM4bXlUclJUMGZWM3V4RkZRVEp4blRRSXMwSTlNWDViU3BpMGNnY3VsNUsv?=
 =?utf-8?B?Zm9oY2FCaG9qSGtPY3NsWlJibDhWYk1HNVpnU1hVaXEzKzFYSHpjYVRROG5E?=
 =?utf-8?B?OTJmKzRBK211SlhXNmw2b0EvTTRUUVlDTzlaUUZiUEtxbjdZSkp6dHQ2RHV4?=
 =?utf-8?B?RzVvRXpPRmFEVHJKdHZBQld5Ylc5R09iTkhLdTJYWEJ3VnQwVzJISFB6SGpH?=
 =?utf-8?B?WUNkT2pUSCtnMGRrUDJtVVNrK0tKNE5oeFF5OXVCSUhHcGp3cTNlb2lsSkhP?=
 =?utf-8?B?ZCtRV0FHZ3NPTCs0NUo4SFZZV2RCemU2RDZnWDNvVXdHMFhsTmxPd2pYOFMr?=
 =?utf-8?B?MERpR3d1ekxlUjlXOG5qSm8yZkN6ckpuTGJZNHQ5cm15RWNGYTVmZTRiZEFh?=
 =?utf-8?B?VmlISm9vZklvYm9SUVRUOXhOUGhta1hlcTlyU0ZUeUpUeHZZWndpQ2dlRzZw?=
 =?utf-8?B?UDVFbWFTaUVDYVNtWnlpd0x6eW1neUtYRzlRSkJNZWlsdEpuWHFuMUFRZ0I2?=
 =?utf-8?B?dTRTcGYwN2wwVUpadzBXMEo3emY1ejEvR24wTTZMZUY1SDFGWkFRelZveFkw?=
 =?utf-8?B?TVdRRTlsMnlHaVFtQS9WQitQVjdTWlRLMEdKbVZTNFVFRVZhM1RHZkhueVgy?=
 =?utf-8?B?WVFEWHVlTjMvdzU5aFpsZW0zKy9UMEFnOXdpNXEzMlVsTStIM2ZIc2JHNUZP?=
 =?utf-8?B?L1FGNjZxNllKRHVlUm9kVW5jVGw1T2swdkdYSVFBQ3FzMXRvaFJIVllmbkdy?=
 =?utf-8?B?WmtveERXSlJWeERHdVgvLytPQzRCZWNmZzJOTEhHSVNNV09hR0wxNUpOWjVV?=
 =?utf-8?B?MXpQNE1XbWdBVVUxTnZLME1lVU9WUFNDSGp6U3pna20rNVhER21VcnEyK0pX?=
 =?utf-8?B?SnNkUThHbllra0RCZTZFK3pkdm5TdTNqVlF3T1UrL1g2bC9HckxtZThVSnhL?=
 =?utf-8?Q?A5z07W4HgBuGZwk+GOwd/FtzS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfd829e8-35dc-490a-c93e-08da6e0f96e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 07:30:46.1436
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u71sB3u93Q1CuRRWEXoXe1G46GzfIOibiZZgddqsl2J7BU8tSkV5Z6xAHau0LpQq3lG32zx9usEG1QKqkNHzJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3193
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHBsZWFzZSB1c2UgcGxhaW4tdGV4dCBuZXh0IHRpbWU+DQoNCj4gRnJvbTogWWlzaGFpIEhhZGFz
IDx5aXNoYWloQG52aWRpYS5jb20+IA0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyMSwgMjAyMiA3
OjA2IFBNDQo+ID4gPiArLyoNCj4gPiA+ICsgKiBVcG9uIFZGSU9fREVWSUNFX0ZFQVRVUkVfU0VU
IHN0YXJ0IGRldmljZSBETUEgbG9nZ2luZy4NCj4gPg0KPiA+IGJvdGggJ3N0YXJ0Jy8nc3RvcCcg
YXJlIHZpYSBWRklPX0RFVklDRV9GRUFUVVJFX1NFVA0KPg0KPiBSaWdodCwgd2UgaGF2ZSBhIG5v
dGUgZm9yIHRoYXQgbmVhciBWRklPX0RFVklDRV9GRUFUVVJFX0RNQV9MT0dHSU5HX1NUT1AuDQo+
IEhlcmUgaXQgcmVmZXJzIHRvIHRoZSBzdGFydCBvcHRpb24uDQoNCmxldCdzIG1ha2UgaXQgYWNj
dXJhdGUgaGVyZS4NCg0KPiA+ID4gKyAqIHBhZ2Vfc2l6ZSBpcyBhbiBpbnB1dCB0aGF0IGhpbnRz
IHdoYXQgdHJhY2tpbmcgZ3JhbnVsYXJpdHkgdGhlIGRldmljZQ0KPiA+ID4gKyAqIHNob3VsZCB0
cnkgdG8gYWNoaWV2ZS4gSWYgdGhlIGRldmljZSBjYW5ub3QgZG8gdGhlIGhpbnRlZCBwYWdlIHNp
emUgdGhlbiBpdA0KPiA+ID4gKyAqIHNob3VsZCBwaWNrIHRoZSBuZXh0IGNsb3Nlc3QgcGFnZSBz
aXplIGl0IHN1cHBvcnRzLiBPbiBvdXRwdXQgdGhlIGRldmljZQ0KPiA+DQo+ID4gbmV4dCBjbG9z
ZXN0ICdzbWFsbGVyJyBwYWdlIHNpemU/DQo+DQo+IE5vdCBvbmx5LCBpdCBkZXBlbmRzIG9uIHRo
ZSBkZXZpY2UgY2FwYWJpbGl0aWVzL3N1cHBvcnQgYW5kIHNob3VsZCBiZSBhIGRyaXZlciBjaG9p
Y2UuDQoNCidzaG91bGQgcGljayBuZXh0IGNsb3Nlc3QiIGlzIGEgZ3VpZGVsaW5lIHRvIHRoZSBk
cml2ZXIuIElmIHVzZXIgcmVxdWVzdHMgDQo4S0Igd2hpbGUgdGhlIGRldmljZSBzdXBwb3J0cyA0
S0IgYW5kIDE2S0IsIHdoaWNoIG9uZSBpcyBjbG9zZXN0Pw0KDQpJdCdzIHByb2JhYmx5IHNhZmVy
IHRvIGp1c3Qgc2F5IHRoYXQgaXQncyBhIGRyaXZlciBjaG9pY2Ugd2hlbiB0aGUgaGludGVkIHBh
Z2UNCnNpemUgY2Fubm90IGJlIHNldD8NCg0KPiA+ID4gK3N0cnVjdCB2ZmlvX2RldmljZV9mZWF0
dXJlX2RtYV9sb2dnaW5nX2NvbnRyb2wgew0KPiA+ID4gKwlfX2FsaWduZWRfdTY0IHBhZ2Vfc2l6
ZTsNCj4gPiA+ICsJX191MzIgbnVtX3JhbmdlczsNCj4gPiA+ICsJX191MzIgX19yZXNlcnZlZDsN
Cj4gPiA+ICsJX19hbGlnbmVkX3U2NCByYW5nZXM7DQo+ID4gPiArfTsNCj4gPg0KPiA+IHNob3Vs
ZCB3ZSBtb3ZlIHRoZSBkZWZpbml0aW9uIG9mIExPR19NQVhfUkFOR0VTIHRvIGJlIGhlcmUNCj4g
PiBzbyB0aGUgdXNlciBjYW4ga25vdyB0aGUgbWF4IGxpbWl0cyBvZiB0cmFja2VkIHJhbmdlcz8N
Cj4gVGhpcyB3YXMgcmFpc2VkIGFzIGFuIG9wdGlvbiBhcyBwYXJ0IG9mIHRoaXMgbWFpbCB0aHJl
YWQuDQo+IEhvd2V2ZXIsIGZvciBub3cgaXQgc2VlbXMgcmVkdW5kYW50IGFzIHdlIG1heSBub3Qg
ZXhwZWN0IHVzZXIgc3BhY2UgdG8gaGl0IHRoaXMgbGltaXQgYW5kIGl0IG1haW5seSBjb21lcyB0
byBwcm90ZWN0IGtlcm5lbCBmcm9tIG1lbW9yeSBleHBsb2RpbmcgYnkgYSBtYWxpY2lvdXMgdXNl
ci4NCg0KTm8gbWF0dGVyIGhvdyByZWFsaXN0aWMgYW4gdXNlciBtaWdodCBoaXQgYW4gbGltaXRh
dGlvbiwgaXQgZG9lc24ndA0Kc291bmQgZ29vZCB0byBub3QgZXhwb3NlIGl0IGlmIGV4aXN0aW5n
Lg0KDQo+ID4gPiArDQo+ID4gPiArc3RydWN0IHZmaW9fZGV2aWNlX2ZlYXR1cmVfZG1hX2xvZ2dp
bmdfcmFuZ2Ugew0KPiA+ID4gKwlfX2FsaWduZWRfdTY0IGlvdmE7DQo+ID4gPiArCV9fYWxpZ25l
ZF91NjQgbGVuZ3RoOw0KPiA+ID4gK307DQo+ID4gPiArDQo+ID4gPiArI2RlZmluZSBWRklPX0RF
VklDRV9GRUFUVVJFX0RNQV9MT0dHSU5HX1NUQVJUIDMNCj4gPg0KPiA+IENhbiB0aGUgdXNlciB1
cGRhdGUgdGhlIHJhbmdlIGxpc3QgYnkgZG9pbmcgYW5vdGhlciBTVEFSVD8NCj4NCj4gTm8sIHNp
bmdsZSBzdGFydCB0byBhc2sgdGhlIGRldmljZSB3aGF0IHRvIHRyYWNrIGFuZCBhIG1hdGNoaW5n
IHNpbmdsZSBzdG9wIHNob3VsZCBmb2xsb3cgYXQgdGhlIGVuZC4NCg0KbGV0J3MgZG9jdW1lbnQg
aXQgdGhlbi4NCg0KVGhhbmtzDQpLZXZpbg0KDQo=
