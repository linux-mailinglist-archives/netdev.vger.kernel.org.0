Return-Path: <netdev+bounces-7218-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5033271F170
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C974B1C21141
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:13:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB6348248;
	Thu,  1 Jun 2023 18:13:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFFA48231;
	Thu,  1 Jun 2023 18:13:50 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FC018C;
	Thu,  1 Jun 2023 11:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685643229; x=1717179229;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=x2kfGM5zg1pegy2ACJbDcHZqHZCUJKCbv1jAtHgTy3Q=;
  b=mR7YGNm53lv21d3LKfM6w85lsy2z/gd6dISTZFcZH2YD4BHTAmPmFLJ9
   MN4Ggci2GtbCQpdV25Nyfpyt/R/KMB3w0sw5zNELn0vIPCv3Un03i+8Ue
   tW5n4cbI2S2c63V2wPf3mQv3nAcwMsfYbiHuCntnDLYLCTuBEJq25TfwS
   9oOhNsBdBXJS19/Dj1D7SCDjm0PZgDs6yt+7HmsIlU62UXXuyIx+ggMU/
   Iy/5q+A/RvAm1GK+5ly8nIua82Q4SDU2nxDyICAG9NwPrrMGRbFuB6/rL
   jGm6S2AzxKAkasdHQ6zF7kKqyJKSth2TA1IuI4KhNx0Yg7RRnPYayCHl5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="336000212"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="336000212"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 11:13:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="684957733"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="684957733"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 01 Jun 2023 11:13:47 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 11:13:47 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 11:13:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 11:13:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 11:13:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiyVNJpNSHN3j5/nXPEZ+PYcWomLH9K8UFWjCS0mxyWBa3YKeBDXdTFw87NTub0kg/C1cH6Q0tjwPISKaQtt66HLDLlgV5wG/D5uIVEW3NKkgfaEkt8y5yFCeMaObgoorOwxgtS5nuXMhEQ3h5ZMRXSnHVR5Exa260CdFn5sskHy8aKDvdEHualMLJU6bnCfxDjDPXgRzblWQq38UO0nSDSdUFSM/Pl1/YNVYFd4oaBSVd3ORJvgYZM9w9A7umj4ezLWaBApRQ/9s5ev3Bt6Edw+wgCQuXG00Fo1LMUQByo4H5JKKx88x1Doa4aaEL6yRPaDRIuIfGT+0LS0qFcKCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x2kfGM5zg1pegy2ACJbDcHZqHZCUJKCbv1jAtHgTy3Q=;
 b=I9rb6vn9bqNLlb8+n5kiHaGjAvPBDctiZldP7Aa/BXptz+fficqBZeAJCOvSz7+s27WtwVtZ6HYMGu0ylzqlVHeZy8r+UcXlsds3UgXLd5fT0FKglTOW5WEtWJLfxzc5gkRZ+4RpfD9cGzray/4cVw/nCVZ5w52d1ff76PbTFasALKLMMvMUkbmvSYzBEMkq+rIVXpEZYSBfb5y/eELAWfuxUuQrFhO3xLsjl41gqE2Mef//HO2mL+n/TWwkNEzXArCWQOVW94wiUQdYNIYX7D97ALX8i3xEoPbp18Woaz/mWGtrNhoY4F38eL4H5g574qpOKGUZWwqI0ZpVPoHs8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by SJ0PR11MB5118.namprd11.prod.outlook.com (2603:10b6:a03:2dd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Thu, 1 Jun
 2023 18:13:44 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::c6c4:7e98:bcea:f07d]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::c6c4:7e98:bcea:f07d%4]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 18:13:44 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kent.overstreet@linux.dev" <kent.overstreet@linux.dev>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mcgrof@kernel.org"
	<mcgrof@kernel.org>, "deller@gmx.de" <deller@gmx.de>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "davem@davemloft.net"
	<davem@davemloft.net>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"x86@kernel.org" <x86@kernel.org>, "chenhuacai@kernel.org"
	<chenhuacai@kernel.org>, "tsbogend@alpha.franken.de"
	<tsbogend@alpha.franken.de>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "christophe.leroy@csgroup.eu"
	<christophe.leroy@csgroup.eu>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"will@kernel.org" <will@kernel.org>, "dinguyen@kernel.org"
	<dinguyen@kernel.org>, "naveen.n.rao@linux.ibm.com"
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
Thread-Index: AQHZlKm5cQf5rjPFXEabUnQGbxJicq92PIKAgAADw4A=
Date: Thu, 1 Jun 2023 18:13:44 +0000
Message-ID: <a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
References: <20230601101257.530867-1-rppt@kernel.org>
	 <20230601101257.530867-13-rppt@kernel.org>
	 <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
	 <ZHjcr26YskTm+0EF@moria.home.lan>
In-Reply-To: <ZHjcr26YskTm+0EF@moria.home.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|SJ0PR11MB5118:EE_
x-ms-office365-filtering-correlation-id: 373a1b69-e770-4acc-1884-08db62cbefb5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SkvZkPkVW70+2quULFZXlldo2L+zLi4wZ3IS26g975GucpOzpfNah8EjQQHSmesMHWpBTfdJzANfFTbEdq2B31Wa1qDj/dDVUQ4myE91p5Ifgoh5vlUldRgLxSGfm65FsbfKWr+AiUKk62tQvuwKMbDtcBffwrHMW5SARSWQTFYjaznG/lQrZF/j1L+akacE0qWbAAGFR1lirXthYXRoDxyj8kK038YZlBeRH4GYrKq9/gxNyjKgu2OQfkbtKjkTJ6R+DtHXHWH6hHX+69oa1oXsfA/YjZPozWwnFQGgw3GJL/bvRLq0eTWmOBvqXCLKatzt1krM9eG6VY2RxuxNlpjG4mV5GsWqg83RB8fCB+0cygRVRfdYWvQcPOajurxs+kW/ZfOSQ5aZP4gmy3Dns0/QXQZyPjOqpJShJyAjDDgDTYhfjvpKdm1VdeIprbspvwGMYkM10SllOqfi7b8xZHX4Qy8p7om0xBffIyvvb2qOgkBn5EaE4fA0TxkAS33VY2pH0KobQFd7yykoPiTaceHRa0KX50ihyQhk8/kRC0s/trvjLKg4I6120KxQm0+9P5NyaAGNeAe+ilLhOc3mW0AWdlCz6QsZTWhQYAwuJUpuY1+GO2LFKrVgKn+lxcif
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199021)(4326008)(7406005)(91956017)(7416002)(66946007)(76116006)(66556008)(66446008)(66476007)(6916009)(64756008)(8676002)(316002)(41300700001)(5660300002)(2906002)(8936002)(54906003)(66899021)(6486002)(82960400001)(478600001)(71200400001)(186003)(6506007)(36756003)(2616005)(6512007)(26005)(122000001)(38070700005)(38100700002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y1ZLbTR5WWhOYlF4QUVuWXJ6STR3RXpVVVpWbFVueWlRQkNHazFVbzlUdzBJ?=
 =?utf-8?B?aEZVL2IxK0JQbXE3UlArd0w4b1N1Ni9hRkVrSUVCQk9lSUtqdU50NTV3bTZR?=
 =?utf-8?B?WEI4OVA3UytuRFZHVDZVTnFzTUNBdGpyMnhrbkNwZWxVK2Z1SVpUNHJvQ0NW?=
 =?utf-8?B?M1loMnk0d0M0TkpEV1p3bm1zYkZtSlBnRzUzZWZFMUk4eWNZeGVzVHlycXNp?=
 =?utf-8?B?VkJyYm9hZHIvUGtUL0N4UFMrRDFHekpGUU1IM0xTdXJ5QWp5TGFWVWRJd2RE?=
 =?utf-8?B?UjFXZmNvSlhNSEhMTjZuOEFmVHJIY21TOElTS2RTN3ZVV2xvUWt0N2t5TFlO?=
 =?utf-8?B?dUl1K2JYcmJBWVpuTGNFOFUwWjhZMmpKTkg1WDl2eWRhclNHNjV4YzBFL1JX?=
 =?utf-8?B?ZkZ3cWZIZzJHMkdwd0xucndHeldqZCs5MXdBNXY0NTFtS0FoWXpvVDEwY0Y1?=
 =?utf-8?B?VzFMUzdHQnNZOXlrMGtMR2hQRHNFcFVxdDdHUGVGL25USzd2a3ZNMW5LN05J?=
 =?utf-8?B?VEZoOEpoT01sS2dyMFAwWWVtK256ZEdLUG1lVzJON3QxZGN2bjIxc2pIbmZ6?=
 =?utf-8?B?c3NsTFVURUNidmRENjErVEdyMis2SitVeDdLUFhDYWd1WWwrV0pwNjVGVUUw?=
 =?utf-8?B?L2o1bEkwSzg4K1JpT1JiVFl6UWNoSXM1akVDTldrYittbFVybzFQaXZGOUVl?=
 =?utf-8?B?RDh2ejArWUYxTWRibThBZ3g1d2ZCUm5GNklETXFkajRCUE1qOEVuMGViY1ds?=
 =?utf-8?B?dzZrajhGeXBTM2tkWDhIRVNVYUFwMHM2UE5Sbzl2UXRGcnFwa0ZUcmxvSWVv?=
 =?utf-8?B?ZzVza0t6MUNEUFNrOVNKeFV0eHBKb0YyemR6akRERjFTTSt0bDVZZVMwUHJN?=
 =?utf-8?B?Y3R2MEZvWTMwRGx1ODVsWGRmNnJWZk94MW9DbG5NSDNabkpPMFhBWnBockFx?=
 =?utf-8?B?Tmt0Uk5kUFZyOHZGL3grVWduWjBuZlU3Rk1aVWkxQS8xTXB6cFVkcGlFamZM?=
 =?utf-8?B?c0FLbUxhWEFkb3g1djBuRlo1bWJDcjFXa045MHV1RDd5NUllcnpZTnVMY3pC?=
 =?utf-8?B?dzBEK0MwN21wdEo1MTlOR21qcUhCT3diR3gvbVg3bFhkQ0l1SGh3eUZQTzFB?=
 =?utf-8?B?N0UrazdQa2E4Sm9qc3NBUndiZzhRRHYzRitGN1ViNjd5SlJKdWZ2enFCdVgv?=
 =?utf-8?B?NzJPZTB2VXk2SElscXFWRVJMMVNZSHFVTlo3b1dFWDhWUzQ4Vm1VckEvOEZO?=
 =?utf-8?B?aEtmY2gvbXdIZE5XbFc5Sk84OW1kenBaWHRBcCtvamZ5ckF4Snk5TW5ranFC?=
 =?utf-8?B?dHg3akxPQTh2Q05ucS9WNXQyclFmQ3VjZVJtUEZPc1NQUE5RdXdNRk1WTEVs?=
 =?utf-8?B?bm9FYzI2ZndnMTR6SkkrZUJOTUpiMnVSMTFqWDNUYVJ0RENISFE3dm9OQjBO?=
 =?utf-8?B?U2lRbGtJMjZCaFVOeGFuWmcwVFVOdHF0RTB4VEY4ZUpyNmRjclY5emtzQm9R?=
 =?utf-8?B?bkFJM2crOVFsaU0veSs4SUVwS2ZOR1BGalBtVlJmN25pRTlXMXF0bVUvNnlX?=
 =?utf-8?B?dWhjdW85K1kwNG5CaGF0cmNXVTVtTkRDNjdaQk5YV2RFY1l4S2Z6dlRaR0RJ?=
 =?utf-8?B?YWdVU2R3VmJVSzJBVGNKVkJScXZ4eWlrbURBbFgrZU9pY0tPS245cjhrYkY0?=
 =?utf-8?B?WSswbzhEL1g5b3cwdG1YbTJsR3QvTWtPU3JJdlpudC84Um4zdkRKelJXNWI1?=
 =?utf-8?B?THB2UzlYVHYvRmxLTzRuWWZOdVZsbEh4NDN2c296Y21HbzdFSFNMTjFUSkI1?=
 =?utf-8?B?Nm8wOU5ZMW9NclJmaytFVmlCUHVGQ0RDOE9BaVhyQTZTaWNnL3EwZUdIbGMx?=
 =?utf-8?B?VmhKQmlJWDFHd3NOdjlaa1ArMEIxM3FTQTRwYm00OC81K2FuY3B4bnZMN3Ix?=
 =?utf-8?B?UUFMOTAxTktHVEU0Ukd6OGF6UllpUER3YXh4MTZwM1hmV0IvQlBHMHVoOTBO?=
 =?utf-8?B?bFoxUFFZcGh5b05xZlpjc3V5MGpqK2dUbXR0bE5sRHNmNzgxM2pSajg1NTY5?=
 =?utf-8?B?Z0ZadmdLcjc3SCtLU1FEd1NTeEVsTXpoWTIvdEFlYWhSQUZ0ZkpSSkxzMlh5?=
 =?utf-8?B?ajFuL3FGTkhTbW5WNnVQZUFXazNPd2t4VnU2RHBGN296RmdBWUtZbnVRV1Ev?=
 =?utf-8?B?cFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1A647A111E5A34C9562FF24B7BCE62B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 373a1b69-e770-4acc-1884-08db62cbefb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 18:13:44.2336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EZEGCqIhVLCJDZJZETWqE/mANMxvpV+PwMIeUO9cuBGIfIZ9t19MxsZuj9buirXQjUNQYhSHs7wq62TXonZF0S8Yv0FgeMYhEF8erVy5WPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5118
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gVGh1LCAyMDIzLTA2LTAxIGF0IDE0OjAwIC0wNDAwLCBLZW50IE92ZXJzdHJlZXQgd3JvdGU6
DQo+IE9uIFRodSwgSnVuIDAxLCAyMDIzIGF0IDA0OjU0OjI3UE0gKzAwMDAsIEVkZ2Vjb21iZSwg
UmljayBQIHdyb3RlOg0KPiA+IEl0IGlzIGp1c3QgYSBsb2NhbCBmbHVzaCwgYnV0IEkgd29uZGVy
IGhvdyBtdWNoIHRleHRfcG9rZSgpaW5nIGlzDQo+ID4gdG9vDQo+ID4gbXVjaC4gQSBsb3Qgb2Yg
dGhlIGFyZSBldmVuIGluc2lkZSBsb29wcy4gQ2FuJ3QgaXQgZG8gdGhlIGJhdGNoDQo+ID4gdmVy
c2lvbg0KPiA+IGF0IGxlYXN0Pw0KPiA+IA0KPiA+IFRoZSBvdGhlciB0aGluZywgYW5kIG1heWJl
IHRoaXMgaXMgaW4gcGFyYW5vaWEgY2F0ZWdvcnksIGJ1dCBpdCdzDQo+ID4gcHJvYmFibHkgYXQg
bGVhc3Qgd29ydGggbm90aW5nLiBCZWZvcmUgdGhlIG1vZHVsZXMgd2VyZSBub3QgbWFkZQ0KPiA+
IGV4ZWN1dGFibGUgdW50aWwgYWxsIG9mIHRoZSBjb2RlIHdhcyBmaW5hbGl6ZWQuIE5vdyB0aGV5
IGFyZSBtYWRlDQo+ID4gZXhlY3V0YWJsZSBpbiBhbiBpbnRlcm1lZGlhdGUgc3RhdGUgYW5kIHRo
ZW4gcGF0Y2hlZCBsYXRlci4gSXQNCj4gPiBtaWdodA0KPiA+IHdlYWtlbiB0aGUgQ0ZJIHN0dWZm
LCBidXQgYWxzbyBpdCBqdXN0IGtpbmQgb2Ygc2VlbXMgYSBiaXQNCj4gPiB1bmJvdW5kZWQNCj4g
PiBmb3IgZGVhbGluZyB3aXRoIGV4ZWN1dGFibGUgY29kZS4NCj4gDQo+IEkgYmVsaWV2ZSBicGYg
c3RhcnRzIG91dCBieSBpbml0aWFsaXppbmcgbmV3IGV4ZWN1dGFibGUgbWVtb3J5IHdpdGgNCj4g
aWxsZWdhbCBvcGNvZGVzLCBtYXliZSB3ZSBzaG91bGQgc3RlYWwgdGhhdCBhbmQgbWFrZSBpdCBz
dGFuZGFyZC4NCg0KSSB3YXMgdGhpbmtpbmcgb2YgbW9kdWxlcyB3aGljaCBoYXZlIGEgdG9uIG9m
IGFsdGVybmF0aXZlcywgZXJyYXRhDQpmaXhlcywgZXRjIGFwcGxpZWQgdG8gdGhlbSBhZnRlciB0
aGUgaW5pdGlhbCBzZWN0aW9ucyBhcmUgd3JpdHRlbiB0bw0KdGhlIHRvLWJlLWV4ZWN1dGFibGUg
bWFwcGluZy4gSSB0aG91Z2h0IHRoaXMgaGFkIHplcm9lZCBwYWdlcyB0byBzdGFydCwNCndoaWNo
IHNlZW1zIG9rLg0KDQo+IA0KPiA+IFByZXBhcmluZyB0aGUgbW9kdWxlcyBpbiBhIHNlcGFyYXRl
IFJXIG1hcHBpbmcsIGFuZCB0aGVuDQo+ID4gdGV4dF9wb2tlKClpbmcNCj4gPiB0aGUgd2hvbGUg
dGhpbmcgaW4gd2hlbiB5b3UgYXJlIGRvbmUgd291bGQgcmVzb2x2ZSBib3RoIG9mIHRoZXNlLg0K
PiANCj4gdGV4dF9wb2tlKCkgX2RvZXNfIGNyZWF0ZSBhIHNlcGFyYXRlIFJXIG1hcHBpbmcuDQoN
ClNvcnJ5LCBJIG1lYW50IGEgc2VwYXJhdGUgUlcgYWxsb2NhdGlvbi4NCg0KPiANCj4gVGhlIHRo
aW5nIHRoYXQgc3Vja3MgYWJvdXQgdGV4dF9wb2tlKCkgaXMgdGhhdCBpdCBhbHdheXMgZG9lcyBh
IGZ1bGwNCj4gVExCDQo+IGZsdXNoLCBhbmQgQUZBSUNUIHRoYXQncyBub3QgcmVtb3RlbHkgbmVl
ZGVkLiBXaGF0IGl0IHJlYWxseSB3YW50cyB0bw0KPiBiZQ0KPiBkb2luZyBpcyBjb25jZXB0dWFs
bHkganVzdA0KPiANCj4ga21hcF9sb2NhbCgpDQo+IG1lbXBjeSgpDQo+IGt1bm1hcF9sb2NhKCkN
Cj4gZmx1c2hfaWNhY2hlKCk7DQo+IA0KPiAuLi5leGNlcHQgdGhhdCBrbWFwX2xvY2FsKCkgd29u
J3QgYWN0dWFsbHkgY3JlYXRlIGEgbmV3IG1hcHBpbmcgb24NCj4gbm9uLWhpZ2htZW0gYXJjaGl0
ZWN0dXJlcywgc28gdGV4dF9wb2tlKCkgb3BlbiBjb2RlcyBpdC4NCg0KVGV4dCBwb2tlIGNyZWF0
ZXMgb25seSBhIGxvY2FsIENQVSBSVyBtYXBwaW5nLiBJdCdzIG1vcmUgc2VjdXJlIGJlY2F1c2UN
Cm90aGVyIHRocmVhZHMgY2FuJ3Qgd3JpdGUgdG8gaXQuIEl0IGFsc28gb25seSBuZWVkcyB0byBm
bHVzaCB0aGUgbG9jYWwNCmNvcmUgd2hlbiBpdCdzIGRvbmUgc2luY2UgaXQncyBub3QgdXNpbmcg
YSBzaGFyZWQgTU0uIEl0IHVzZWQgdG8gdXNlDQp0aGUgZml4bWFwLCB3aGljaCBpcyBzaW1pbGFy
IHRvIHdoYXQgeW91IGFyZSBkZXNjcmliaW5nIEkgdGhpbmsuDQoNCg==

