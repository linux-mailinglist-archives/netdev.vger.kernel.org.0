Return-Path: <netdev+bounces-7241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D6B371F436
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:50:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED0872818CF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 20:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6965818C11;
	Thu,  1 Jun 2023 20:50:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F40B156E2;
	Thu,  1 Jun 2023 20:50:46 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00A599;
	Thu,  1 Jun 2023 13:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685652644; x=1717188644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v2Hqwy9Pa3Jz3V1vOVp7fX5nJZBl4nQhV6CQVGmiGdc=;
  b=Z+CmY9lOB344tPPZ02CZh+wCVhQjf6Bg+5HKKC61OAl5o68MBPspUjc2
   8jPYA4YcKj/aZzQJfBUlajHLmKyKIevFcqtw9BTFuDn/lZQg6g3lIiwoZ
   JhSBRysPdDub7+IRBjU8Jd0Mvgl5xPZMDEX6FSQRn0Q75soMAA+PdBquf
   ZGeHANhgU6/k+thCQdmc89zVW+ELaxPPB3Y47aqgeDyvVrZr8P6GGlN9C
   xblWOZzqaW9NzzmC8PfZMf0Qdfcst+IpIy0FaG7vJGs6Ds0em8QvlfMF6
   G5p0Gl2E10mJ/qLDsMXbprnH6L/NJRzSbIpgVWWoldIQjt5sb4Zj7itMq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="345247368"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="345247368"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 13:50:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="707539173"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="707539173"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 01 Jun 2023 13:50:41 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 13:50:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 13:50:41 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 13:50:41 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 13:50:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0Q+OjBIH9pyZQj0+qD/RSeEAoIaBIG5W1MHVckPbkGgJA/BmOg06kbt7jUBTJ6jZnn8s8JFxNNdQ0VdkbGZkIGfblzFmsdqE/m3viZ6IaYHXB7KtM7bUXjAamsZRgQk+7u0paF/pBbjfu+KLHeXQ/P+XvSmz0JuU75AF/K2XR6EpI0UXsOeiBQsSahWhoQsx+3qbJdscGwD5FGuunp3iJ/M7nGpla2Yr4b0CTZryrv6blE/2Hx2jTuYllt1ln4FBU7J5bIFIsqe3V/ADP4ksix5kXgZpJVdPANGShTfDYI15zhdFgoEgcek9Zeffp2gPBnYVIgNbXWUkRxaCR4Dgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v2Hqwy9Pa3Jz3V1vOVp7fX5nJZBl4nQhV6CQVGmiGdc=;
 b=I2MnBFXHSH5ZnfYG3OudlgWOJDC0FSeOTX4/JWDjpQMBqvZu7D2ebgWo6o8lJFPJ1oNAo1Zy6UK8SrqdvmCmYavDn4UbxFp0JXibh4Smzebz/6ssO6ADOz27+Sx8qIQ1VLuCjq5FRjRMsHG5s2q2IiJ/s5+KmkwfSdywIai2aE/ZWPuHFC+goUzwKBK4bWKDOqu9ZyqPBaBHjbiiQFDhmz6vI4q9Y+mztHEJdgmFxM5G2MpEGeEppuHVPC3p5A0HD7IErfeoGRsVEmWneGOBIC2Pi2cuiyzFPIsOuzvI6l8M3ZKxUomYe/CfVeP6mVPj816v4owoZQpDTR9LYCbX1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB5555.namprd11.prod.outlook.com (2603:10b6:208:317::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Thu, 1 Jun
 2023 20:50:39 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6433.025; Thu, 1 Jun 2023
 20:50:39 +0000
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
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "mpe@ellerman.id.au"
	<mpe@ellerman.id.au>, "x86@kernel.org" <x86@kernel.org>,
	"tsbogend@alpha.franken.de" <tsbogend@alpha.franken.de>, "rppt@kernel.org"
	<rppt@kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "christophe.leroy@csgroup.eu"
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
Thread-Index: AQHZlKm5cQf5rjPFXEabUnQGbxJicq92PIKAgAADw4CAAAbOAIAAJQoA
Date: Thu, 1 Jun 2023 20:50:39 +0000
Message-ID: <68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
References: <20230601101257.530867-1-rppt@kernel.org>
	 <20230601101257.530867-13-rppt@kernel.org>
	 <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
	 <ZHjcr26YskTm+0EF@moria.home.lan>
	 <a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
	 <ZHjljJfQjhVV/jNS@moria.home.lan>
In-Reply-To: <ZHjljJfQjhVV/jNS@moria.home.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB5555:EE_
x-ms-office365-filtering-correlation-id: 0558b2c5-9575-4ad4-f39b-08db62e1dba7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h9hiSLu4QMtmufk/4F9YZFF0wSWdExACNSFuhn36svkbjlisffCFs4tpBKrgUYNb9FT6iFVP5K140E3m6pjx0RZkOVaw9UQMKqTbiqM2y8mpEXQ7+VSLE/tv82GFAlKSJDkSRKutrdTmOxx2jy1XaIvXoatclAJ5iZLHADVzr0uP2vHqnzBkwYji8B5Gd69vQb0l91uQfG5ajFmzkZ+VVpQJozG4vqYnjBtKlXhhG7sgyQJZ4DVi0Cr08FpRgutjpIxAPRcNpDHwgi/C1JlauBMeD6hHxQo5Xq9qzUEmurKUj88jJ93iNt3so8swRen7Wm6F8dre887kinCp2HJKK0ZfrpunlphQ9BO1haDusTdLvsofOcweHCuTnFd0vWj3JfbPRHDOoLD82rBhxlS3QrZgIvegOByeJVuCjKW5W3Xjkk16lpbwaiIifiz+qN9RXpTaILUuvVtY63NtnCQsZ8PLpQujYZUAgTtipvrXWeMVc9ps1tvlbgzpOYAbVXqSuPwxAQXQ3gKpbM6a+XH1J3Mi24Xd+cRVmk00gPKoaErYsPVanunZcX5eKLEoml9AafSwU0TB34s9O4rcII/xWhWbRHh201yFMS+BmjBbaSWAt+BjjlN/iT+GstwBAM/a
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(136003)(366004)(39860400002)(346002)(396003)(451199021)(6486002)(71200400001)(82960400001)(36756003)(83380400001)(2616005)(38100700002)(38070700005)(86362001)(122000001)(6506007)(6512007)(26005)(186003)(8676002)(54906003)(2906002)(8936002)(316002)(41300700001)(5660300002)(7416002)(7406005)(91956017)(4326008)(76116006)(66446008)(6916009)(66476007)(66556008)(66946007)(64756008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SmF1SkhyTHFQYlE4RUdaalZUSnJBQ2J1SzdxdVBUUy80bFlRMWZkbzlzenQ1?=
 =?utf-8?B?OURUd2ZSdkx0Y2M0TzNTcklQWERTalVMSW9XUStjTVF0alFnNStaazV5MVJt?=
 =?utf-8?B?eXdLKzhpUm9PRDBQYmx0a0RlalF2dFk4ZDAyVSsvY1dtSXd5eVdYR1J5VjFk?=
 =?utf-8?B?dGpHcWpBQ0cxTzM5cU4zOGpvb1ZNQzVMelNLRlIzK2l5Sm40K2hxRE8wbjNj?=
 =?utf-8?B?elVOd1NrekkvOU02QUNJRTZocW43M0drWmgvUDNtZ0tmZXg5ekQ5YTJiMkNz?=
 =?utf-8?B?SkdCdVloOStOUjJQK2hGNllkQkVIbW9YVThqMGllL3JabUkzK29pWUxIWHdn?=
 =?utf-8?B?ZDYrZXFUbitxT0w4WndvVjRwVTBrd005NmM4eTY5Z2QwWkZKZWZVd3lhTkZP?=
 =?utf-8?B?dlBzSEJsNXdoQW9WaEFzRnduZzIvWXR2NFVMbisrd0lYc0ovdlV3QXFwb1kr?=
 =?utf-8?B?bWhBdDUxdWlKOUk2aStoU0lPSzRJbWlhOVhJSzNnWnhSV3ltc3ZZNlArMk15?=
 =?utf-8?B?aVdKRCtUNlhrKzdSb2tLd0FRVzdMZjBKSG1vTWpMZE1HNWo4ZFdPZnY1Tisx?=
 =?utf-8?B?b1hKalkydDZpamlHU2lEM0wraTRRN0JBOTVqa1czZXkwN2M2S1pqdHFobnBR?=
 =?utf-8?B?QllBV1dRcGZmU3BOSGNRVnZuZDk1c3BpRWhVR3RFM09YZTg2YWtIVnBDUDhn?=
 =?utf-8?B?Q1AwZVYwT3gzaEJ6N1hMWWwxZTc5SEFCbXk5OEgySFhqMmYycmJxK1BWRUFD?=
 =?utf-8?B?Ry9naU1jRGhLTHV0SkMzdFdWNnZ2cEQ5Z1pDcS9BbzJBR0p0ajkvZlE0TFNV?=
 =?utf-8?B?R2NkODRKZS9Tb0o1Z3NOWFhEYjZwTzh3YXFDcFgrYUhnSmw3azc3N1JyQkVN?=
 =?utf-8?B?QmtQa0JZV294Tyt6WWZQeVR6Z3VyYTVKN0ZaVjhEUVRIZGVUY1NqNmRMTVFq?=
 =?utf-8?B?YXcyS1p6Um80UUtxZVhadUZLWlVRZEd2ZEVWRnVsaW5oL0doLys1aU4zcWVB?=
 =?utf-8?B?dmRscFoxYUFPdWU3QVFjbk14SkxXQ0xGZDYydG9LaE1hM1JPODNqNG5PeG9o?=
 =?utf-8?B?SyttL3Q1ZDNuY24wajFzanI0eUM2TFZjV2Q3SDlGanMzWnJQSU9NMU1HZWFX?=
 =?utf-8?B?Y2xDWHk3ZDlxbTNrWW9rTldlNDhEV250QW40VTdyZTN0SEphY21rVXByUFgy?=
 =?utf-8?B?TVg3VHZTNlNyMmtjN3FJejVMdEh4eWlINEJUSGFtOStjQU9CU25vZHp2ZTRQ?=
 =?utf-8?B?V1JIOFBFYkpBZ1NIY3BFbzJnWnlDdXQybDZJSEQyWWhNYU5ucU84cEJqbzFo?=
 =?utf-8?B?VDNLbk1xVTRTR3dIN3pGaXFvYW5DcWg2bWZyVkk2cXJMT1RqN1J3TDFrRUpx?=
 =?utf-8?B?aW9TM2t2QnJqVmNSQ0RHY3BLZm9HcHRvbm92SVRRbEtFRjhEekRQSlF6OGFH?=
 =?utf-8?B?U1dZK3dUTlhGaXk2SnM5WjNtcGFlV3R6TnFJalVma0Q3NWFyaXJmajZmZEpn?=
 =?utf-8?B?ekU1UE5EWElkOWxoemRTaVRYMXQ0clZ2N0I1MDlxVHBWbmxtU3c4UHJuSnNp?=
 =?utf-8?B?MGgrK1p3MUk2OWtMVExZL0ZKZlErME9XWjhubnpnRmFUNTJJSi90ZUVBaGJu?=
 =?utf-8?B?ZEJGK25ZcjFDTktnNE5hV3picktyWVFNdkRGRUQycDN6dy9lRnYwL0N6dlFH?=
 =?utf-8?B?RkRiaTJ4Q29jQ1FlUHE3ZTJsNFF4a1hGd2VTL0FYZUlDSzZKano3WTI2eXV1?=
 =?utf-8?B?c0RZcHUzVXE3OTFyRTU2dVY0MEdFbmx5eXlmMmlLNG9XYk5LUlEvOTc2SkFH?=
 =?utf-8?B?akpKRjRUUjlpRHFhK0pwS2liT0UyU1pVWkhnU1ZVMXA2K1JGT3E4MnRkVmJE?=
 =?utf-8?B?L2J0cXROWEpaZEFYSTE4cW9RZ1IvUTZQRXlOK0ZxcTR0L2Vtb3A0UGZSZE5E?=
 =?utf-8?B?dGdHWFF6UzEwUTdjSGxEQ05DOHZQQktXTW5FWEhsNXBuaUFrSVRKelBlRFMr?=
 =?utf-8?B?WXdCdkZ6MUdRNTRrR2srRUM2M1ozRHBiNVYya1R0cEpZd2lzWmk2anRlQlVU?=
 =?utf-8?B?QVdXZ0dHZFI1L1QwV1NPUm40bU10Q3I4SGpjMTdsS3NOMnk3S0dZUjZSRVpB?=
 =?utf-8?B?QU95a3pOeDY1TjY4SkJndUlHSGdSSmp1TEtKa3hUK0xCWStOQ0I3ZHYzVTFz?=
 =?utf-8?B?MUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58C1A67412DFDC42B54B84624D58C6E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0558b2c5-9575-4ad4-f39b-08db62e1dba7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 20:50:39.5003
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxyZbl4bylVk7eQO89Z3RaEpbd4bcEyNFlvaIj8HupBtitni7GkflzWVX5xqievpMFxFSMt+i0F+NSHw3p2JKatBdsBkp0Ba0WJFDAA8CPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5555
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gVGh1LCAyMDIzLTA2LTAxIGF0IDE0OjM4IC0wNDAwLCBLZW50IE92ZXJzdHJlZXQgd3JvdGU6
DQo+IE9uIFRodSwgSnVuIDAxLCAyMDIzIGF0IDA2OjEzOjQ0UE0gKzAwMDAsIEVkZ2Vjb21iZSwg
UmljayBQIHdyb3RlOg0KPiA+ID4gdGV4dF9wb2tlKCkgX2RvZXNfIGNyZWF0ZSBhIHNlcGFyYXRl
IFJXIG1hcHBpbmcuDQo+ID4gDQo+ID4gU29ycnksIEkgbWVhbnQgYSBzZXBhcmF0ZSBSVyBhbGxv
Y2F0aW9uLg0KPiANCj4gQWggeWVzLCB0aGF0IG1ha2VzIHNlbnNlDQo+IA0KPiANCj4gPiANCj4g
PiA+IA0KPiA+ID4gVGhlIHRoaW5nIHRoYXQgc3Vja3MgYWJvdXQgdGV4dF9wb2tlKCkgaXMgdGhh
dCBpdCBhbHdheXMgZG9lcyBhDQo+ID4gPiBmdWxsDQo+ID4gPiBUTEINCj4gPiA+IGZsdXNoLCBh
bmQgQUZBSUNUIHRoYXQncyBub3QgcmVtb3RlbHkgbmVlZGVkLiBXaGF0IGl0IHJlYWxseQ0KPiA+
ID4gd2FudHMgdG8NCj4gPiA+IGJlDQo+ID4gPiBkb2luZyBpcyBjb25jZXB0dWFsbHkganVzdA0K
PiA+ID4gDQo+ID4gPiBrbWFwX2xvY2FsKCkNCj4gPiA+IG1lbXBjeSgpDQo+ID4gPiBrdW5tYXBf
bG9jYSgpDQo+ID4gPiBmbHVzaF9pY2FjaGUoKTsNCj4gPiA+IA0KPiA+ID4gLi4uZXhjZXB0IHRo
YXQga21hcF9sb2NhbCgpIHdvbid0IGFjdHVhbGx5IGNyZWF0ZSBhIG5ldyBtYXBwaW5nDQo+ID4g
PiBvbg0KPiA+ID4gbm9uLWhpZ2htZW0gYXJjaGl0ZWN0dXJlcywgc28gdGV4dF9wb2tlKCkgb3Bl
biBjb2RlcyBpdC4NCj4gPiANCj4gPiBUZXh0IHBva2UgY3JlYXRlcyBvbmx5IGEgbG9jYWwgQ1BV
IFJXIG1hcHBpbmcuIEl0J3MgbW9yZSBzZWN1cmUNCj4gPiBiZWNhdXNlDQo+ID4gb3RoZXIgdGhy
ZWFkcyBjYW4ndCB3cml0ZSB0byBpdC4NCj4gDQo+ICpub2QqLCBzYW1lIGFzIGttYXBfbG9jYWwN
Cg0KSXQncyBvbmx5IHVzZWQgYW5kIGZsdXNoZWQgbG9jYWxseSwgYnV0IGl0IGlzIGFjY2Vzc2li
bGUgdG8gYWxsIENQVSdzLA0KcmlnaHQ/DQoNCj4gDQo+ID4gSXQgYWxzbyBvbmx5IG5lZWRzIHRv
IGZsdXNoIHRoZSBsb2NhbCBjb3JlIHdoZW4gaXQncyBkb25lIHNpbmNlDQo+ID4gaXQncw0KPiA+
IG5vdCB1c2luZyBhIHNoYXJlZCBNTS4NCj4gwqANCj4gQWhoISBUaGFua3MgZm9yIHRoYXQ7IHBl
cmhhcHMgdGhlIGNvbW1lbnQgaW4gdGV4dF9wb2tlKCkgYWJvdXQgSVBJcw0KPiBjb3VsZCBiZSBh
IGJpdCBjbGVhcmVyLg0KPiANCj4gV2hhdCBpcyBpdCAoaWYgYW55dGhpbmcpIHlvdSBkb24ndCBs
aWtlIGFib3V0IHRleHRfcG9rZSgpIHRoZW4/IEl0DQo+IGxvb2tzDQo+IGxpa2UgaXQncyBkb2lu
ZyBicm9hZGx5IHNpbWlsYXIgdGhpbmdzIHRvIGttYXBfbG9jYWwoKSwgc28gc2hvdWxkIGJlDQo+
IGluIHRoZSBzYW1lIGJhbGxwYXJrIGZyb20gYSBwZXJmb3JtYW5jZSBQT1Y/DQoNClRoZSB3YXkg
dGV4dF9wb2tlKCkgaXMgdXNlZCBoZXJlLCBpdCBpcyBjcmVhdGluZyBhIG5ldyB3cml0YWJsZSBh
bGlhcw0KYW5kIGZsdXNoaW5nIGl0IGZvciAqZWFjaCogd3JpdGUgdG8gdGhlIG1vZHVsZSAobGlr
ZSBmb3IgZWFjaCB3cml0ZSBvZg0KYW4gaW5kaXZpZHVhbCByZWxvY2F0aW9uLCBldGMpLiBJIHdh
cyBqdXN0IHRoaW5raW5nIGl0IG1pZ2h0IHdhcnJhbnQNCnNvbWUgYmF0Y2hpbmcgb3Igc29tZXRo
aW5nLg0KDQo=

