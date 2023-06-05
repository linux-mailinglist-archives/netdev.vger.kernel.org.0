Return-Path: <netdev+bounces-8206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A76B7231D4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 90E311C20D3B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB70261F3;
	Mon,  5 Jun 2023 21:01:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BE2261EC;
	Mon,  5 Jun 2023 21:01:20 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD7DED;
	Mon,  5 Jun 2023 14:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685998878; x=1717534878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pllprPRXgvKu0sh2Nvr+CLsb6a6MBDECEAZsZeI+9WE=;
  b=V4e0MxoV+dTiUzG9DD/l82hPDZCT2nTTwQ+H3l6/hxkvRUnoMetMElgG
   gt7wEmCTeQdyEnkiQl9csbk9LwsXa1lrU9SAVpg74Ifeab9LCfeAi2GYc
   tfKm/DfKmZlyHhRKPW4gQQbrTmYF+JRUlKSYxrf9govWL3iPu5VQtuvHc
   iyLvRH43TuFnXHQtArXyFARdx21liaZ/Zzezq8u7nRyPL6qjnFCuxkQtC
   FC9ZPJMHSwijZWKJ5TpjnvYyKQ8kfIYxeFUEuFMYwhjJhp9NC1eKA0F9I
   HLoCLN4mV1af3/0mreNzQb3z/b1Fan7EOeqQPqW3Ch+YBpIgRD/LmjeB/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336839008"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336839008"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 14:01:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="708809077"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="708809077"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 05 Jun 2023 14:01:17 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 14:01:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 14:01:16 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 14:01:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HvtTA3XQG/b5PnLyZsFAO9hlwcE1wUDGe7A2mo+LGGyCBex526g5L6e0joaQfVgKCfX3AoeFH3Zz2xsHiW8LFe8WuYkhB2v6aUKn+X0U+dExwYWMLke99XfPlir942nthq9/wwek5pt7M4I6Nc5g4GPUZCMqwiVqfdHMO86QUaFqcubhTqJs6oVgS0TdvZqdrTB3UCvaWhjvJ7CLGarPSldbkChNx70ZFbk0W5BulPvbo/mTDabQhGG9SicSEG0K5psX266J3vq6+eW2YiZvawfcGvzZ5oBfvAftRPG8wF2PPRoJgyVoBvcYLDjrrHt2D3tSb/Mzrpb24W79KvpUpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pllprPRXgvKu0sh2Nvr+CLsb6a6MBDECEAZsZeI+9WE=;
 b=Ox1bwX3lnk5ij63jcjmSCdUJlcldXePFWage0yiMMV1zZmirJ95TkkcPqBALNwEs5TeJvm/4fuYZOfUasU5tWvabhMWPxOxo28MBSOrNqrEG6xZWB4rXFREaAKf5mGbB7A/O1Roa3dqVwlShvUb497OnknS19Jd1DJGRmiFHmPIyacSz0PYntirUE2GEt9uS4pTSiWc0IFdB15OZ+e+3nbMDQDnHXDHBDiker668rJJzm8/Ba3GLIjbG6Dwhp65gk2y78QhTXnBvIPqpElj/T7QcyxADOTk+cMwtYjAG45oE70KpIGHUtoQsryZCAPpgaLaoNKy3gzemynIEWLxqTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN2PR11MB4568.namprd11.prod.outlook.com (2603:10b6:208:266::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Mon, 5 Jun
 2023 21:01:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 21:01:14 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "rppt@kernel.org" <rppt@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "deller@gmx.de"
	<deller@gmx.de>, "mcgrof@kernel.org" <mcgrof@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "nadav.amit@gmail.com"
	<nadav.amit@gmail.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"davem@davemloft.net" <davem@davemloft.net>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "chenhuacai@kernel.org"
	<chenhuacai@kernel.org>, "tsbogend@alpha.franken.de"
	<tsbogend@alpha.franken.de>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "christophe.leroy@csgroup.eu"
	<christophe.leroy@csgroup.eu>, "x86@kernel.org" <x86@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "will@kernel.org" <will@kernel.org>,
	"dinguyen@kernel.org" <dinguyen@kernel.org>, "naveen.n.rao@linux.ibm.com"
	<naveen.n.rao@linux.ibm.com>, "sparclinux@vger.kernel.org"
	<sparclinux@vger.kernel.org>, "linux-modules@vger.kernel.org"
	<linux-modules@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "song@kernel.org" <song@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
Thread-Topic: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
Thread-Index: AQHZlKm5cQf5rjPFXEabUnQGbxJicq92PIKAgAADw4CAAAbOAIAAJQoAgAAzZgCABOjDAIAAWSCAgACFuQCAAEwqAIAABRyA
Date: Mon, 5 Jun 2023 21:01:14 +0000
Message-ID: <fc80e5bcec4f1fd06d9d81a2ccae3f489166d503.camel@intel.com>
References: <20230601101257.530867-13-rppt@kernel.org>
	 <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
	 <ZHjcr26YskTm+0EF@moria.home.lan>
	 <a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
	 <ZHjljJfQjhVV/jNS@moria.home.lan>
	 <68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
	 <50D768D7-15BF-43B8-A5FD-220B25595336@gmail.com>
	 <20230604225244.65be9103@rorschach.local.home>
	 <20230605081143.GA3460@kernel.org>
	 <88a62f834688ed77d08c778e1e427014cf7d3c1b.camel@intel.com>
	 <20230605204256.GA52412@kernel.org>
In-Reply-To: <20230605204256.GA52412@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN2PR11MB4568:EE_
x-ms-office365-filtering-correlation-id: 3acc26cb-d230-4031-b839-08db6607ffb5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9jGREqZFuZCFi6EgVT/gYfE+20NE0t5hQG/ADzmQaJNyoKILM4dUtv5pL8ouOXwaFra2xTPRS54ozbGt0mjBdrT64h4T3Gu08i4hfBS1GTQRSTkR7URqi7S8/+xDGIxFEX4LmcXaUbxM/eGqH1CBrQogk6ka0m0UV3WeZu0EGZ5d4H103ul7HptRhUf4npVNEDMxvBokVBBLAc0oz49wV1YsTFdHFOWTZVcUtRuA3NofKWYf8wNsiaFxie0Aq7fFMZLFiGLtj4OXXAphPAfz3MzGh26yWw6hh/jnXmZBiWietvOB63unRi9TLNiEFTH8/u2Mv1cPq7LYz0b1843vkJyKfp8ks/9aUHF1+1sSHvNfJZCF8O50HY7aRxVwBXVZSDZuKrW409MuVxgboG1kDQCC7xecGw2b5Mwoot8XlQhnsMG5CjzFi9pvQU9rkMxkHyvq9uYG1BB+sEHYzflMPo/6P4xcnPdL1OzNZjroAeI8jPsXtm8PWLENe1xY5C2sLSnnh4/4m3ldemrRDsYruZQ1W2FP9VMRiAVbxv56wciqAeBxSef5xObWrnFZbvVdV56AVGKvEtX0zusJqrLtn7072TjcywqyTSlvQelrRm4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(396003)(346002)(136003)(451199021)(2616005)(6512007)(26005)(66446008)(6506007)(316002)(83380400001)(6916009)(66556008)(4326008)(76116006)(64756008)(66476007)(91956017)(66946007)(122000001)(966005)(6486002)(186003)(38070700005)(478600001)(71200400001)(54906003)(36756003)(66899021)(2906002)(5660300002)(8936002)(8676002)(82960400001)(86362001)(7416002)(7406005)(41300700001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S29FUkRuOS8xWCsxSUt6VWloRHlYNkhraHg3eStucEx0NWE0L2pwRWlVWUlK?=
 =?utf-8?B?VzlWbGljbGdSVWRiamFMZERVSXo3eUs3RzdTd0RjQjQ2WFZRRWRpS1dMeDIz?=
 =?utf-8?B?aFhrU2lPYUw3UU1sY3dxTWluVXUrSk1qWlJxWElNUmZ4RW5ybzcxRCtGREE1?=
 =?utf-8?B?blBmN2N5VG05bmFnNHRMUUcxR3B4L0FIMzRVeDlsTU1haU9uNGdHc29GVytT?=
 =?utf-8?B?cGpBM28xSUdSbTVOdHhLaGgrQlIrUU83Q1dzUXZhTCtoeDNBUmxoZmdQdGd3?=
 =?utf-8?B?Vm5EVEpSWk5qSGtyeW13c2ppekpxYzhlc0picDd3NWd3T2plZzNueVZyUlhw?=
 =?utf-8?B?dTErTk1kSGxFVm5hWllSYjlldCsxNW5yNlEyeHlpZjRoZE5PN0pIeDBMaGZ0?=
 =?utf-8?B?WFBjSU5JTW9CUkVjUWd3NllMNmx0SG5jamk4U3Vsbll2UXdFaGVRcmUxeWE4?=
 =?utf-8?B?Q1c0dEVqN0JValMxMnU4VDlVK2lWTjdNSkx6bHo5QmwvQUhsZ0RYeXNmMlI2?=
 =?utf-8?B?TmozaFhkbW5LSXVEK1JtL01BSGVIY2NINWp0NnlpMUxkeis2NVlHczB5VzJQ?=
 =?utf-8?B?eWJYUzFITXMwYnVMWnJqbktYYXJIQ1NOSkFubEdHM01xaUhLNFl6dEU0YjI3?=
 =?utf-8?B?QVR1UDZHazlkT1VaZXhHN3J4SThORkFqd0tWSzI2bUpFVjhlb3dmbUkwbXB0?=
 =?utf-8?B?WTgxNnJwSDZWYXZ1ZDR2SWNETTdtYTdYVU43VlErc2dqbTZRVTk2R1YxbmpN?=
 =?utf-8?B?UEV5b3llc3VVc29RajgxeFhVdmcvZjErUytsT3dRVGtqWTcyZzBoeTJjWUhj?=
 =?utf-8?B?N1hKbkpSRFJ3dDJ0eFFVbFJEQXphajdUdC85cFUybmZ3T2Z2bHB3bVV1eFU4?=
 =?utf-8?B?WmlmbUZ4WUFUSEdSQXRpa3ZNZlk4WTN4bEI1TDZ0UFhpQk00K1ErSzRSd1ZP?=
 =?utf-8?B?QVV0b0VuL1ozVGZUcnJFT1Q3TFJROG83dFc4MlJtcTUyVUZzZzd6SnNROE5Z?=
 =?utf-8?B?M1puY0tCVUZoVS9oamhvUkVMREZWQ1o2R2ViUWRCT3hKdVFraVF5eE41RlI3?=
 =?utf-8?B?ajZqdDdWMldSMmJWSllvc1YwQnhTQ0hNQ2FyWVhCRlNTcmxBQzRPczk4dnhQ?=
 =?utf-8?B?aTRpb1dzQXQrTnI4QVM4NlVBWU5JT21seG5LTXJIZ2xzMG12VGxqdllvVDdT?=
 =?utf-8?B?c1VSZW1xRmN0UzFIdW81alJocnBYaHpmVVNSQ2NueXR5RVBxeXhqOHBPVnlO?=
 =?utf-8?B?ODZ0VFpvUW5FcDN4eUh6L002S3R3N3JBZ05yeHlPRzB4NmZpL3ZyRnl6bXhD?=
 =?utf-8?B?d3dmdVkwTkNCL1k4d2lMUkxqM3d1L2NBVG9iM1FHd1RabTdTV3I0U21vK1V4?=
 =?utf-8?B?eDlUbHhWSmhHempGYVRMcHROSng4UFZRRGhGY2R1dE1WT21FOGhTVU5rMFB3?=
 =?utf-8?B?M3ZzOEVOSHVrNm55dFcwTzd5eUpGMmpYR3FIanZUcFJCUHNVUkhtVy9zQjE1?=
 =?utf-8?B?VHliY2I1NnNTMXlUYXNleG9Ua1ErRDVhZGgyMkNyTlp3d3dkYWw0VHlHaERG?=
 =?utf-8?B?Wm0vRVI1RmlGTTFseFhla011YU1xTmZPb2RWTnJxeTZmbVRoUkgwek5hK3R5?=
 =?utf-8?B?WTNhcng5eFA1bHVUQkFidmhPNHZMWUJ5UnliL3lva3lqbjhicUMxNlhxRFRB?=
 =?utf-8?B?dlRjVy83RDdLTkMwbnN0SWJVTkg2WXk5ZjVCL2ZTS0V5RkFHRGkycXIrSHBG?=
 =?utf-8?B?cTVJb253VDJzVlJhaEtwdit0RnRjbzdNeXdwVkJtVjVLUVhxZWVuN3RtRE5l?=
 =?utf-8?B?eU9lWnFyNWxTdXF3VlIrVE9jbk0rN25FcGtkMW5IQjBZSVI1Mm90RTdSWDAz?=
 =?utf-8?B?UmYwa2tJK214YjBTdy9pNXcwdjRnU2JwbzBudks4SHlJSmFZODJReVVqanBx?=
 =?utf-8?B?SUJ4eWlLaVFXcElYa1ZYKzViT3RoZHBQbFROTDdUUTRPWWtJREljVDNNM3R1?=
 =?utf-8?B?UjVBeXlpRTRhRXJLcTQ4ZlFjbnk0R0RjZkp1NDMvTVhleHBuT2g1dE5KeFRj?=
 =?utf-8?B?WTcvZFRsZytSWGhCajNIMm1qY3Vzc2pMemtOYXFxRkk4bFRoNEIrcDF2MlpJ?=
 =?utf-8?B?SzdtWXZ6MWZxaDVoOUtJdXFEV3JMc0Zsc3h0TmlNK1RKRUhiK3FMZUc5MTYz?=
 =?utf-8?B?aEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0A76E7569A3A14895AFBA66A81A63FA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3acc26cb-d230-4031-b839-08db6607ffb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 21:01:14.3578
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: or92ZRUxLP4WnJBNqSmtCfjoi0excGLmnB8XHduaF6RQEGkRuJk63kIOc4btGOFpWNVSqkZ7gyQSdx/ue6LOBXkMwmpjBsTanMQXBFpPwxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4568
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gTW9uLCAyMDIzLTA2LTA1IGF0IDIzOjQyICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiA+IEkgdHJpZWQgdGhpcyB0ZWNobmlxdWUgcHJldmlvdXNseSBbMF0sIGFuZCBJIHRob3VnaHQg
aXQgd2FzIG5vdCB0b28NCj4gPiBiYWQuIEluIG1vc3Qgb2YgdGhlIGNhbGxlcnMgaXQgbG9va3Mg
c2ltaWxhciB0byB3aGF0IHlvdSBoYXZlIGluDQo+ID4gZG9fdGV4dF9wb2tlKCkuIFNvbWV0aW1l
cyBsZXNzLCBzb21ldGltZXMgbW9yZS4gSXQgbWlnaHQgbmVlZA0KPiA+IGVubGlnaHRlbmluZyBv
ZiBzb21lIG9mIHRoZSBzdHVmZiBjdXJyZW50bHkgdXNpbmcgdGV4dF9wb2tlKCkNCj4gPiBkdXJp
bmcNCj4gPiBtb2R1bGUgbG9hZGluZywgbGlrZSBqdW1wIGxhYmVscy4gU28gdGhhdCBiaXQgaXMg
bW9yZSBpbnRydXNpdmUsDQo+ID4geWVhLg0KPiA+IEJ1dCBpdCBzb3VuZHMgc28gbXVjaCBjbGVh
bmVyIGFuZCB3ZWxsIGNvbnRyb2xsZWQuIERpZCB5b3UgaGF2ZSBhDQo+ID4gcGFydGljdWxhciB0
cm91YmxlIHNwb3QgaW4gbWluZD8NCj4gDQo+IE5vdGhpbmcgaW4gcGFydGljdWxhciwgZXhjZXB0
IHRoZSBpbnRydXNpdmUgcGFydC4gRXhjZXB0IHRoZSBjaGFuZ2VzDQo+IGluDQo+IG1vZHVsZXMu
YyB3ZSdkIG5lZWQgdG8gdGVhY2ggYWx0ZXJuYXRpdmVzIHRvIGRlYWwgd2l0aCBhIHdyaXRhYmxl
DQo+IGNvcHkuDQoNCkkgZGlkbid0IHRoaW5rIGFsdGVybmF0aXZlcyBwaWVjZSBsb29rZWQgdG9v
IGJhZCBvbiB0aGUgY2FsbGVyIHNpZGUgKGlmDQp0aGF0J3Mgd2hhdCB5b3UgbWVhbnQpOg0KaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIwMTEyMDIwMjQyNi4xODAwOS03LXJpY2sucC5l
ZGdlY29tYmVAaW50ZWwuY29tLw0KDQpUaGUgdWdseSBwYXJ0IHdhcyBpbiB0aGUgKHBvb3JseSBu
YW1lZCkgbW9kdWxlX2FkanVzdF93cml0YWJsZV9hZGRyKCk6DQoNCitzdGF0aWMgaW5saW5lIHZv
aWQgKm1vZHVsZV9hZGp1c3Rfd3JpdGFibGVfYWRkcih2b2lkICphZGRyKQ0KK3sNCisJdW5zaWdu
ZWQgbG9uZyBsYWRkciA9ICh1bnNpZ25lZCBsb25nKWFkZHI7DQorCXN0cnVjdCBtb2R1bGUgKm1v
ZDsNCisNCisJbXV0ZXhfbG9jaygmbW9kdWxlX211dGV4KTsNCisJbW9kID0gX19tb2R1bGVfYWRk
cmVzcyhsYWRkcik7DQorCWlmICghbW9kKSB7DQorCQltdXRleF91bmxvY2soJm1vZHVsZV9tdXRl
eCk7DQorCQlyZXR1cm4gYWRkcjsNCisJfQ0KKwltdXRleF91bmxvY2soJm1vZHVsZV9tdXRleCk7
DQorCS8qIFRoZSBtb2R1bGUgc2hvdWxkbid0IGJlIGdvaW5nIGF3YXkgaWYgc29tZW9uZSBpcyB0
cnlpbmcgdG8NCndyaXRlIHRvIGl0ICovDQorDQorCXJldHVybiAodm9pZCAqKXBlcm1fd3JpdGFi
bGVfYWRkcihtb2R1bGVfZ2V0X2FsbG9jYXRpb24obW9kLA0KbGFkZHIpLCBsYWRkcik7DQorfQ0K
Kw0KDQpJdCB0b29rIG1vZHVsZV9tdXRleCBhbmQgbG9va2VkIHVwIHRoZSBtb2R1bGUgaW4gb3Jk
ZXIgdG8gZmluZCB0aGUNCndyaXRhYmxlIGJ1ZmZlciBmcm9tIGp1c3QgdGhlIGV4ZWN1dGFibGUg
YWRkcmVzcy4gQmFzaWNhbGx5IGFsbCB0aGUNCmxvYWRpbmcgY29kZSBleHRlcm5hbCB0byBtb2R1
bGVzIGhhZCB0byBnbyB0aHJvdWdoIHRoYXQgaW50ZXJmYWNlLiBCdXQNCm5vdyBJJ20gd29uZGVy
aW5nIHdoYXQgSSB3YXMgdGhpbmtpbmcsIGl0IHNlZW1zIHRoaXMgY291bGQganVzdCBiZSBhbg0K
UkNVIHJlYWQgbG9jay4gVGhhdCBkb2Vzbid0IHNlZW0gdG8gYmFkLi4uDQo=

