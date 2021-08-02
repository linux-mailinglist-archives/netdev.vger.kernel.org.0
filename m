Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4096F3DE13B
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 23:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbhHBVJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 17:09:36 -0400
Received: from mga07.intel.com ([134.134.136.100]:44590 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231367AbhHBVJf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 17:09:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10064"; a="277302014"
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="277302014"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2021 14:09:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,289,1620716400"; 
   d="scan'208";a="636381313"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 02 Aug 2021 14:09:25 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 14:09:25 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 2 Aug 2021 14:09:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Mon, 2 Aug 2021 14:09:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 2 Aug 2021 14:09:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zzt1bn9kQ/aeQz8vHr8S7L9RCOA+AbdBfAPCvxUZ0gABZ2VnV5srfOimB9UWA0F46RF3bsHkkjNAYmv16kK7NzKdkf1NPRkuVecYEyh1fYWrybL5hhUbuWzfjIE8dYscpfJco/nk93D1/6WJaCA+iV0/8xKm+cEbhJkdmlBAcZM7CdfyK/4pAb3Bjz46ZqmWP9WIGBpfDm6P9LQ+qALYFxBfNYoCurmfudiGu1LQXqV3BJvSGsdjauK9zNVh/2ojg3ZT8X/O8d6dOQ1/AaGixtm4j1WN3aJtk/ILPUhDr48VXjsx3M0lV8jwYPzkXreMABZa7ohxD88+5D7lh8WR+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2Wjv29P7dE6LbitcyYEXyfGkp/37bHZjyEeUHjaVFE=;
 b=I7m7aQNlIIc6xFV26FzRP5C4FI6t+wXnRHfv5aSWN82DmotfQym08S5tQMWTJpqUSi/UsN4j4rJJHirt8ijRTJ1qrcmkcY9FxScGXzfLjx8zc1kouxl67bvwe6aqfOLD6nmdfSPMMqhWrvdl4HheLaxyBSsHz1zym3+ppVS+7de2UHaC872nC5u0L6Vg9cFAFfKmnUn90TNsV3imGSzNnbMJ9HWdiaaZeYNGSKuMTDnnMDFs3FD0gqpmJVoEg7NzmRorf6WVziXgpd3Xtfp6FuV/0bX0qi6ys6WjTQne5wafptF6+caTthSWTRI6nU3FQQpRTNg3toBtAbtr2VBilg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O2Wjv29P7dE6LbitcyYEXyfGkp/37bHZjyEeUHjaVFE=;
 b=jfNq5Z0NnUmsyWdOd66avtOhtSUi/Uo+x04NrHnYOeaagtiZHBktqCj34Fl01eULR/WcOG/1mlKamYOL/V8t1rgcvym31UvX8JcmsZ+TG1vloONOcnfquBNptODa/83yeMr1zd0Pti++6fGA3iJBMaZR2Phm1mE2WBoGz/vkyaw=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Mon, 2 Aug
 2021 21:09:20 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.026; Mon, 2 Aug 2021
 21:09:20 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuICAAAqYAIAAAknggAAFUACAAAKXsA==
Date:   Mon, 2 Aug 2021 21:09:19 +0000
Message-ID: <CO1PR11MB5089DBFAEB671ED58D9BAEADD6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <CAK8P3a3P6=ZROxT8daW83mRp7z5rYAQydetWFXQoYF7Y5_KLHA@mail.gmail.com>
 <CO1PR11MB50892367410160A8364DBF69D6EF9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <CAK8P3a379=Qi7g7Hmf299GgM-6g32Them81uYXPqRDZDro_azg@mail.gmail.com>
In-Reply-To: <CAK8P3a379=Qi7g7Hmf299GgM-6g32Them81uYXPqRDZDro_azg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a8bb2171-b8ef-4bfa-ddc3-08d955f9cba4
x-ms-traffictypediagnostic: CO1PR11MB5044:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB50440E7CF42A4155737F1350D6EF9@CO1PR11MB5044.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T20ZFgglFxMZudlOqZ8HTcdsazSJxZDTi5So+wLph/gn2A+s3QngI1sK+daMtqNnuX/iUzM142Nf/e+ZZKiAodeJElfsZvLVedbBcXlYKXPijipouj2EvzWlxzpzaFkcAW6a+fbicNGJtEvivCAu+KUlyiMrW5G8SYPUgk2bi66cWbV5qZqrBD9+8tcihZxNkryTqM3LKslCyZnFqa8B9TS2mcPDuwdQUEQseQAnmvXy8KUc/4YSUzgVV0xeQQ7QNSVTwnGcqMAkYgjgH6eMhGwjpfE5TSpNiIzTavXh/XdBhVOMEoyxJEMMkpnlWRUgOXLT5Wsa/yDV9O+7I4qbG/W5aYKkqoC4wuxjsrq9klR7GpF9/JF1TD2tfmhulOGgje8OqUTJgOS8jnqFF9FwnzF0JdNIb9vm+ZoTUA1pNlTHKOT/XX7tPMy64FIlL2oVPyVnLui9WkSkFhgF+ovkIe/9qZREDgVJQIymGFLDv+fMo/0E9bd4FgGFSG51KtkKMf/gBbsiaVOwPABFCym+1+kVVoYH3Suc1+ViM2gnW0jLiGgZkjhvfkNwTdHP1Yea4pL2mUBhKpre3mXpyspYXguhkDQg9hjB5tFSqNlSpe9QRY9sPuYlu16662hKJxSXI29aRdi/fHWmhNlAU7sI/PkIgMm1fNttbpnjpAFMt6GlPk6noXjmlNW/44ioYmgL8Ynn4+RTUSvYmsBfxE/o6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(86362001)(4326008)(83380400001)(66556008)(186003)(33656002)(2906002)(316002)(6916009)(9686003)(8936002)(64756008)(26005)(54906003)(7696005)(66446008)(66946007)(5660300002)(6506007)(55016002)(71200400001)(8676002)(38070700005)(53546011)(508600001)(38100700002)(122000001)(7416002)(76116006)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c01GNkNJcXFNWlFIcWJSaGJGejhyc2RMb01sNHc1dm1hZmU0eEJsWHFsenp5?=
 =?utf-8?B?OWpEWDllL1R1SzZIdUxWd2labGNjcHR6VTc4dGtRQWpwaVhOaEZ1SEtsU0JM?=
 =?utf-8?B?Wkp0OTZCTk5HMGZOVmU1K3hRdDZqdlJrN0xyTWt4V2FkbytUcTM4M2MrUVJM?=
 =?utf-8?B?cFArY1hvekNVajRCWnBCUlpmcVNMTWczNzVFYk55TFZ1VmZNVHZyUUJ4UkFk?=
 =?utf-8?B?NFpxOThPY3dQSmZmQTdNaDdFcnIxdEcxdU1nSnk4TXJVbmlrcXNHUFhlci9F?=
 =?utf-8?B?MnplRzdTWThmWUF5R1pOVCszbzRIRTJ4Z1lHTCt0VG1xMklDL0pKWVpWVXJU?=
 =?utf-8?B?Zi9qaDVSaU4xWEI1V1BUNEErQzhJZG81UER4OGw0aEc5dnFBQm9qeGtUU1pj?=
 =?utf-8?B?WE1CckU0aFZHaHIxb3pvUVY5OVYxR2g0dmJOVCtucXRzMkdVVGNZZjlrbzlK?=
 =?utf-8?B?RWtoNmh3dmtjMm9xVEJVSWNta3ZxSzgvMktxN2ZKVVNWVkkzSmJVQ3lXR2dt?=
 =?utf-8?B?NC9FRHAyejE4UExJK3h4VmYrR0V1UGx2cVppNXQ0dTZyNnRyZDRobXVxd3N6?=
 =?utf-8?B?UUwwam9oR3NBVTYwcWl5dmZIRmZ1RHBzcFJMdWxjdU9ybHNlT2xzaFJZUlk1?=
 =?utf-8?B?WGJTVmlRT1d6bVI2Wml1d3dqbXRGVFhRWUhDQlNLTk84Z0JWUVpvNkl2SXNG?=
 =?utf-8?B?NUFUOUJzakZiVzFtNHBCVGF2YUJHWHh5WGdtc3FFcTJRMWR3VXlvNlJOaGFS?=
 =?utf-8?B?WG1RK2NwRTBxV0Z3ZkhYREZkbUc3TXIyczAvdG0yWEs4RU1mS0l4b1RmbXJQ?=
 =?utf-8?B?UUV6VGpBT0d6ZVlBWDF5RHNHbGVEd0FOUytsK1ZpSFkzVkI4REtyaitnSXBy?=
 =?utf-8?B?cnFtUlI1Ull6NjZCVnUyeWY2eEtObWh2Q0F6bk9IQmw2NDRnM0RWbXN5ckx4?=
 =?utf-8?B?SGg0L3FaVTB4RW5xNmpCdVp0cit0K3pPUmRyVUdWQlEvdHNwNFp6TTM2TDBj?=
 =?utf-8?B?T3R1NDNjcE9BY0RNbjY3TlVMVmF1TjhlazlBNnk1SlRrNEVJLzhkYjFUenRW?=
 =?utf-8?B?clQ3Y3ozNkJDUGhYdFgrWk1nRUFQSW5hSTFXdUpUOFNrY05MazVEeTlKUER1?=
 =?utf-8?B?a1dUbTZsa3VoODNPWFcrOFNFRVdLb2haak85c21oVi80NTdkWG9vSytXVE5Y?=
 =?utf-8?B?cFpPdDQvTWUrWmdmN3VhdmpIaFY4TVl6UGJ5WWJFR1hCR1d0SlVRNjFTZXdz?=
 =?utf-8?B?ZHVEMk8xRVhSVEZpbDhNQkdkbjBqUi9HTkZGZ2hGQVJHbmc2YmdSWHppd1Ju?=
 =?utf-8?B?MFZRazZwcWNKU3ltdmlCT0Eyei9HMkl5aE01SFQwNnVxVSsyY0Zicnd1Zkk0?=
 =?utf-8?B?QUdDRTFGY2YvUHpEMnhVc2xYNXN2RzR3Ylc5RU1vL3QwWEhxdk9kMndRVnBy?=
 =?utf-8?B?bzJEQlh6TG03NEppNHU1TWVVcWpRTHJ6R1JnRXdYb3JualZ2Z0hWMDRQeDVD?=
 =?utf-8?B?ZWlmUWwyc3RhaE1pZjltWlVmckVHdG9zK0Ixd3IrU3V0NTlaVDRwV2FaSDQz?=
 =?utf-8?B?Zk1lYUUrVEQ5QnRZbWpPbEtQU081dXh0dGVsNnBNY2ZSS1FNSnoxM2t6REFu?=
 =?utf-8?B?RStUMU13SHNRY2UvQ1Q2b3Fva0lDSTI4S2dUaTFuZmxPTFdsbVdnczBNM1FZ?=
 =?utf-8?B?KzRsajJ5NDY5L05jUzBxeVNPZ201LzFWZzE0OFNqeUNqaHoxRWZrcENyK3Vh?=
 =?utf-8?Q?lQlY/hZces8hSA/U/w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8bb2171-b8ef-4bfa-ddc3-08d955f9cba4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2021 21:09:19.9421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PaT6cTIWmxMmeLEaRGnMMlk/l2NgwxWtVIhfAH1djmS1C0IxP2BDaUyK/l9R3+sMfMe6fV7myEKZH1yrXtaNUrhUgKXu8i7hX0g5EMb6TSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5044
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQXJuZCBCZXJnbWFubiA8
YXJuZEBrZXJuZWwub3JnPg0KPiBTZW50OiBNb25kYXksIEF1Z3VzdCAwMiwgMjAyMSAxOjU5IFBN
DQo+IFRvOiBLZWxsZXIsIEphY29iIEUgPGphY29iLmUua2VsbGVyQGludGVsLmNvbT4NCj4gQ2M6
IFJpY2hhcmQgQ29jaHJhbiA8cmljaGFyZGNvY2hyYW5AZ21haWwuY29tPjsgTmljb2xhcyBQaXRy
ZQ0KPiA8bmljb2xhcy5waXRyZUBsaW5hcm8ub3JnPjsgQnJhbmRlYnVyZywgSmVzc2UgPGplc3Nl
LmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsNCj4gTmd1eWVuLCBBbnRob255IEwgPGFudGhvbnkubC5u
Z3V5ZW5AaW50ZWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0
PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IEFybmQgQmVyZ21hbm4NCj4gPGFy
bmRAYXJuZGIuZGU+OyBLdXJ0IEthbnplbmJhY2ggPGt1cnRAbGludXRyb25peC5kZT47IFNhbGVl
bSwgU2hpcmF6DQo+IDxzaGlyYXouc2FsZWVtQGludGVsLmNvbT47IEVydG1hbiwgRGF2aWQgTSA8
ZGF2aWQubS5lcnRtYW5AaW50ZWwuY29tPjsNCj4gaW50ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9z
bC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJu
ZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgdjJdIGV0aGVybmV0L2ludGVs
OiBmaXggUFRQXzE1ODhfQ0xPQ0sNCj4gZGVwZW5kZW5jaWVzDQo+IA0KPiBJIGRvbid0IHdhbnQg
dG8gbWVzcyB3aXRoIHRoZSBzZW1hbnRpY3Mgb2YgdGhlIGtleXdvcmQgYW55IGZ1cnRoZXIuDQo+
IFRoZSBvcmlnaW5hbCBtZWFuaW5nIHdhcyBtZWFudCB0byBhdm9pZCBjaXJjdWxhciBkZXBlbmRl
bmNpZXMNCj4gYnkgbWFraW5nIGl0IGEgc29mdGVyIHZlcnNpb24gb2YgJ3NlbGVjdCcgdGhhdCB3
b3VsZCBub3QgdHJ5IHRvIHNlbGVjdA0KPiBhbnl0aGluZyB0aGF0IGhhcyB1bm1ldCBkZXBlbmRl
bmNpZXMuIFRoZSBjdXJyZW50IHZlcnNpb24gbWFkZQ0KPiBpdCBldmVuIHNvZnRlciBieSBvbmx5
IGhhdmluZyBhbiBlZmZlY3QgZHVyaW5nICdtYWtlIGRlZmNvbmZpZycNCj4gYW5kICdtYWtlIG9s
ZGNvbmZpZycgYnV0IG5vdCBwcmV2ZW50aW5nIGl0IGZyb20gYmVpbmcgc29mdC1kaXNhYmxlZA0K
PiBhbnkgbW9yZS4gQ2hhbmdpbmcgaXQgeWV0IGFnYWluIGlzIGd1YXJhbnRlZSB0byBicmVhayBs
b3RzIG9mIHRoZQ0KPiBleGlzdGluZyB1c2Vycywgd2hpbGUgcHJvYmFibHkgYWxzbyBicmluZ2lu
ZyBiYWNrIHRoZSBvcmlnaW5hbCBwcm9ibGVtDQo+IG9mIHRoZSBjaXJjdWxhciBkZXBlbmRlbmNp
ZXMuDQo+IA0KPiAgICAgICAgICBBcm5kDQoNClllYSBvayB0aGF0IG1ha2VzIHNlbnNlLiBCZXR0
ZXIgdG8gdXNlIGEgbmV3IGtleXdvcmQgaWYgd2UgZG8gYXQgYWxsLg0K
