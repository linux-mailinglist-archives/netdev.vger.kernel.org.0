Return-Path: <netdev+bounces-7170-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E5AA71EFC1
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43E76280CA6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:54:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 899374079F;
	Thu,  1 Jun 2023 16:54:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DCD40795;
	Thu,  1 Jun 2023 16:54:32 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C89318D;
	Thu,  1 Jun 2023 09:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685638470; x=1717174470;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BUjteEGxetQDfPrzeWQXLGeSMPX1KPX+hxmz2RWYAnQ=;
  b=V1J4o05fMzmleYcDPpD24x4wfD8QPXbQrFl3wgeG5vXzvScDt1H+yjoK
   +cRu0UfViI++O2TVWD6SljGxGfzejF3W75yHtZYb/CZwlFa4hsG6Bawyu
   KP3Np2Bmyt0aL4tQvuFJ6DWyxC+Ss82RoVX4S6sMVRSWOB+lDcpecfZVc
   qKoVC9eNxK0ZArGdNChesW/TSWWuH2P1Wsb7rDYjFMbQ0CVTZTWoLHvvr
   tKLyCysfMQ8A5JzuIRfl7/2NVOjVcM8BTBNi4P00iQdeEsgAMRSao1TLd
   9D/ylp6kNlRSRCcm5vAl+GWaalG7Lhmd33c0cje8MwJyIjnF4/X4fQ6vM
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="419140282"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="419140282"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 09:54:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="740431256"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="740431256"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 01 Jun 2023 09:54:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 1 Jun 2023 09:54:28 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 1 Jun 2023 09:54:28 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 1 Jun 2023 09:54:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zbibrfc1nYMmSYSmWamsZ/CxDq6ixzqD6EzUnfClZi+JynoUkstr7YgEr0XXqL2q6FR+9vgCn+GiXfqM7eiBbukCie4ctg9eTycwz99s8n2h/ntM45LH9QaqychEwWAf48ZpYJm5e6qJGoe8wijfRVY0l/ze8LS+QjlQRtXZU6nixHkItl6Oqnsu/TZ5ZVQDzNhpZOFEo9y0cD0zfzmohDrI6fAZz48GsAw010GfOo2INdlN1RYs33TyiFiy/pr3QCZ3bqOqlGAkKhIJfWq+vQExEmFvnrM9hLuSOIcKArDueNkfeNZGD/ZrTWQWNv7sKzQK+K2hRHyI5zTvHzZRuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUjteEGxetQDfPrzeWQXLGeSMPX1KPX+hxmz2RWYAnQ=;
 b=I60EDY4dO5GIuagfMmqqvtNyP14CKkG86lsl+LdKaK4P9h2jGByGy5xzwOJFQ+V4jD+NqwwSKJh+MPKSU0B+grqjEVVgmSIloZ4uUUDXQA97CChvrk9JsELdZLoaP58PPAou836AmYgmOzYZ0sHhGLQV/ARw86zMinM+EM5zPh3n1ERu9NXWEgmBYSa5KV5h7LEKLfsGiWDF4mZPpIDeSAhZjVw99dGgykZJtoMoeA2L951dkg2jls1uGRd0BYrObe2xAAr3u80WvbprxKYuzHokERmY4GX2KoAst3BSamDcwznYLrJtB1goRMhWlTuSPQquFtNWvVZ1xCCCpmKpzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB5319.namprd11.prod.outlook.com (2603:10b6:208:31b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Thu, 1 Jun
 2023 16:54:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 16:54:27 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mcgrof@kernel.org"
	<mcgrof@kernel.org>, "deller@gmx.de" <deller@gmx.de>, "davem@davemloft.net"
	<davem@davemloft.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "mpe@ellerman.id.au"
	<mpe@ellerman.id.au>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "tsbogend@alpha.franken.de"
	<tsbogend@alpha.franken.de>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
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
Thread-Index: AQHZlKm5cQf5rjPFXEabUnQGbxJicg==
Date: Thu, 1 Jun 2023 16:54:27 +0000
Message-ID: <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
References: <20230601101257.530867-1-rppt@kernel.org>
	 <20230601101257.530867-13-rppt@kernel.org>
In-Reply-To: <20230601101257.530867-13-rppt@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB5319:EE_
x-ms-office365-filtering-correlation-id: 854e45c5-1221-436f-ad1c-08db62c0dc4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RURq59KEkgL9dxke3RR539c60O0c+TKb11SQg19YJ2goWtU5ip9yuKH27Pk7cq7zJu7Rpil2Mv7h5zJaNQ/aAWmGd8toCdIwkHqZAfxjorO0HpY9Skh4Z0l7fSlimCbYxju3YZ2fIjpBkW7D5VTIy8G+N0UWMqIWgKHXmCiv6au1SGJWyiYvIJWNPWa+EQwkolaeJUPjMYAX2WAVdC/VPh3pWK0gDLf7MVsedS2AO0D8ntIYvhVp+VDKmZr1YDhGwZWS9uXAraIa9MY3KYs/Fd10aXyQsobSV9x2y0RVxlZHDdKGtIGLtM95TsqIOCA7prJpBYnSC8nsQ7gA1ADaXnCG2MBKI+N7ctTtc5sXZLRcg5hNOzJex9Xa6JzfIw81gJgKqGwd+U3Q7EA/KVtKklu/BssAjh5rZzjzopb+FhZ6Wh0DwgZpwDCyBIKZ4PQafQ99RPGPRsRziFem0pfjj4UJwE1VeWPMRA/vM3uyqw5DldE6nfmF40+vItyU0q3gLphJr8CVJDnAE58sHWqRXXumGEBjDk6HD82nSYzFZA0mDsRjhwEbQDGFHy3cvtVYaAC04pm9r9Xx/0yxpJBP5/rBuoY2IvzAm9gYkj4CV8Yzb0gsvXccffbhjgnqbzT+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(366004)(346002)(396003)(39860400002)(451199021)(41300700001)(5660300002)(316002)(110136005)(64756008)(66446008)(66556008)(54906003)(66476007)(4326008)(38070700005)(91956017)(66946007)(86362001)(7416002)(7406005)(76116006)(2906002)(8936002)(38100700002)(8676002)(478600001)(66899021)(122000001)(82960400001)(36756003)(71200400001)(6486002)(2616005)(186003)(26005)(6506007)(6512007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ME9NNDkwQ1MrM3pPTW13Y3FLTU5OdFJzMlZIT1ZBaWxaU1pkUG9wWW82dXdr?=
 =?utf-8?B?TlZkOFRpZy8wOGtGanFkQWxkWGpsRUNLdjhvQlFkUUErdDdrOURWVmVQbnd1?=
 =?utf-8?B?aEdJa1d3QlBpRHI3Sm92OVNGaEZSQ2syWG42SHJGdGZiYzNGazJiQzEvZG45?=
 =?utf-8?B?ME0wVEgxakdNNzluK09OVDZDVFNIRitJbXNoT1BmMVM4a3NNODZXdkYwc1Qx?=
 =?utf-8?B?TVRycDNsRG85SU1KWlJ3ZkZIYlNsTDZKL2dlNUdLVVRSOTFxajdOZFJ3Vm44?=
 =?utf-8?B?YUYzZEtkT0xHNkxidUtQaVJ6Wm81M0F0Qi8rcFhZTzRGa1JVNS9TOEROYlY5?=
 =?utf-8?B?OFlFdUtQR2o5blJGUHNnYXdmN3M5TnhvYkVTUmYrZm9DWHAwRmpnckk2ZWRl?=
 =?utf-8?B?RnBJOXRHeHdCYVNncG5SQnZMMWk3cHV6VDZUc29mK3BNSk02dzVjaFArOTh2?=
 =?utf-8?B?dFFURFZkNzlISUJNYlZSS1VBUURVRC9FalF5WUcrdUVMYlRESW5wM1RmdVBt?=
 =?utf-8?B?TzlRbUsvYUpxWXo5VEREZ1FVK1pDd0h4Y2NVdXlBeGNYQkdZUnVWRmQ0YVVo?=
 =?utf-8?B?VHFYdGdMLzZhMk1USk1xdnZTdDU2bmMrTGM0TVNGUTVmdndLNk9lVFBUb2pW?=
 =?utf-8?B?SmJzV0pzak53RVowUEVKeEx0dVhIVnAxdmk1YlphdWZndkJhUE9Uc283MHRn?=
 =?utf-8?B?UHVJNjBudmVOalEzb21LYTJrT0M4UElpcDNrb0w2eTJWbko4QmhPOUFGNWc1?=
 =?utf-8?B?TXRGT01TbHVIS1BGaTJ2c1E0a2hUemNiNUhqTGFWM3J3QWdRakplZVZ3aEE0?=
 =?utf-8?B?QW9SNkpMbXNLeEtSQnhDMThzWERYSWZzbDdDU01NY1RqeGNYQ2lyUTd0QnZE?=
 =?utf-8?B?OUpQTTE2RWhOQm5QV3pqRVBYRnNFbkhya3h6dnJ5UVR5dUdiUW9kSVRjNEVN?=
 =?utf-8?B?em01RGcrU3A4Q1Q3cDZYZkxtUk5LS3JmS0N6QW1WZXYyeE44TFYvaXZuakFn?=
 =?utf-8?B?UER3aWZYcVZYRisxekZLQjNnQUhRVEwxdElBb0phR2tGMEUzeHRLai9zZ29X?=
 =?utf-8?B?YnpUMExqeFpmcHQxWnBzQ3VTYXBUSmJtWThEOEJvRWhhUjdjR2Y2UGFIeDBj?=
 =?utf-8?B?QkE2eE91ZnRabDgvY21XUjVnZGVvUWpyZnRtMU1VNnUxenVpSjg2UmVSdzJG?=
 =?utf-8?B?Q2V5Yi9wOXZIN0xEUDhybjQ1eThLRTBXNVZkVytuLzdGQnZoS05XT0ttbUlB?=
 =?utf-8?B?WUxyTXljU2w5S296TVg4eU11dFRyRVgxK1hIcVBSSXJzTDVNMUJGTTRiN1pK?=
 =?utf-8?B?aGlPdFcwRlFQQmFGdG92NGFuQWxxd1hIWFE2c3F5eENaYzBmOEhNNEcyL3kw?=
 =?utf-8?B?YjIrRVR5bzlma21XMjU3RTJCQ1BBSmNMNEQ5cDZwTmNnSk5TMXdaVHcvWnJE?=
 =?utf-8?B?VXJUU2ZoYitOa1hab0JydGs2M1ZqRUVlY2ZoU0dydVZBRU5lYXJ2TnlScWdC?=
 =?utf-8?B?MVdNS0pkV3pSNGdOWStzQjduaTQzSlRyeW1Zb09YL3VtVmxmakRVd0lpbzNB?=
 =?utf-8?B?ZHBCNHA2QnRCL0c2VWl3eEZLcUt1MHFRQXg5L2V6VTJQYTRLRlY2bjBLT2tu?=
 =?utf-8?B?VE9NVU5PQVU5QlJsdHFmTG5Mc2lSRmJCc2VYbDN5c1F2OFVoanZQc2czUE8z?=
 =?utf-8?B?Z3lXMEtMSnhkUWQ5dW82YnRwNVhWNEpMbzBTRWdtZ2tuVk4rWEo5MUdIZkVX?=
 =?utf-8?B?Uzdtankrbks2L1Y1VG9wa1VQamZBT2NGdjdqMWFXR0NNWkdQUVpPUGxsNmJQ?=
 =?utf-8?B?VmJ0aUFoRnBVTEprTWJiSHFReXdzYXd5YjdYdU5ycHFhNlhQVTRUK2dKMG9R?=
 =?utf-8?B?UEpsK0U4NmtnemVoN2VtMU5qU0p3N1lhNktCUjBsai9oZVROTVlVdzk0RWV5?=
 =?utf-8?B?VXBuNW92UktyRzdmeHNCOFIvQ1BTMWhIUEo3cVgvWDB2SHNtS3NUb3ZMVFNO?=
 =?utf-8?B?SkFUdEtuS2NiRm03ams2L29JdXVvczQ1WXFmeU1GTk5BMUE5eHcxaG1ldlRV?=
 =?utf-8?B?SjEwNFJ2Q1hpaktyMnV6Q3BPVkkxb2VlOS9nc3kxbnRtekZGQ0lhZng2WnFN?=
 =?utf-8?B?Z1lTT204YjRHRENrSjhWeHJrcmNRaFljTlMxTXA0b2lydlplaThKZncvb0xE?=
 =?utf-8?B?K0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FF33FF1B802A6C439E645ECFC49A3063@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 854e45c5-1221-436f-ad1c-08db62c0dc4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 16:54:27.2063
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /TFvjAO6rF2DYfVsikoxsavgloiOUIL5sYBq2CdhgAc/1K8ch2qtYBjrWC3MQOthAfkkxm+LLWJ4OxMqD7vVS5eLCAMEyrN4MTYcIpV+4g8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5319
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gVGh1LCAyMDIzLTA2LTAxIGF0IDEzOjEyICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+
IMKgLyoKPiDCoCAqIEFyZSB3ZSBsb29raW5nIGF0IGEgbmVhciBKTVAgd2l0aCBhIDEgb3IgNC1i
eXRlIGRpc3BsYWNlbWVudC4KPiBAQCAtMzMxLDcgKzM0NCw3IEBAIHZvaWQgX19pbml0X29yX21v
ZHVsZSBub2lubGluZQo+IGFwcGx5X2FsdGVybmF0aXZlcyhzdHJ1Y3QgYWx0X2luc3RyICpzdGFy
dCwKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRFVNUF9CWVRFUyhpbnNu
X2J1ZmYsIGluc25fYnVmZl9zeiwgIiVweDogZmluYWxfaW5zbjoKPiAiLCBpbnN0cik7Cj4gwqAK
PiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdGV4dF9wb2tlX2Vhcmx5KGluc3RyLCBp
bnNuX2J1ZmYsIGluc25fYnVmZl9zeik7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGRvX3RleHRfcG9rZShpbnN0ciwgaW5zbl9idWZmLCBpbnNuX2J1ZmZfc3opOwo+IMKgCj4gwqBu
ZXh0Ogo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgb3B0aW1pemVfbm9wcyhpbnN0
ciwgYS0+aW5zdHJsZW4pOwo+IEBAIC01NjQsNyArNTc3LDcgQEAgdm9pZCBfX2luaXRfb3JfbW9k
dWxlIG5vaW5saW5lCj4gYXBwbHlfcmV0cG9saW5lcyhzMzIgKnN0YXJ0LCBzMzIgKmVuZCkKPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBvcHRpbWl6ZV9u
b3BzKGJ5dGVzLCBsZW4pOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoERVTVBfQllURVMoKCh1OCopYWRkcikswqAgbGVuLCAiJXB4OiBvcmlnOiAiLAo+
IGFkZHIpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oERVTVBfQllURVMoKCh1OCopYnl0ZXMpLCBsZW4sICIlcHg6IHJlcGw6ICIsCj4gYWRkcik7Cj4g
LcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0ZXh0X3Bva2Vf
ZWFybHkoYWRkciwgYnl0ZXMsIGxlbik7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBkb190ZXh0X3Bva2UoYWRkciwgYnl0ZXMsIGxlbik7Cj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB9Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoH0KPiBA
QCAtNjM4LDcgKzY1MSw3IEBAIHZvaWQgX19pbml0X29yX21vZHVsZSBub2lubGluZSBhcHBseV9y
ZXR1cm5zKHMzMgo+ICpzdGFydCwgczMyICplbmQpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBpZiAobGVuID09IGluc24ubGVuZ3RoKSB7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRFVNUF9CWVRFUygoKHU4KilhZGRyKSzCoCBsZW4s
ICIlcHg6IG9yaWc6ICIsCj4gYWRkcik7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgRFVNUF9CWVRFUygoKHU4KilieXRlcyksIGxlbiwgIiVweDogcmVw
bDogIiwKPiBhZGRyKTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHRleHRfcG9rZV9lYXJseShhZGRyLCBieXRlcywgbGVuKTsKPiArwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGRvX3RleHRfcG9rZShhZGRyLCBieXRl
cywgbGVuKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiDCoMKgwqDCoMKg
wqDCoMKgfQo+IMKgfQo+IEBAIC02NzQsNyArNjg3LDcgQEAgc3RhdGljIHZvaWQgcG9pc29uX2Vu
ZGJyKHZvaWQgKmFkZHIsIGJvb2wgd2FybikKPiDCoMKgwqDCoMKgwqDCoMKgICovCj4gwqDCoMKg
wqDCoMKgwqDCoERVTVBfQllURVMoKCh1OCopYWRkciksIDQsICIlcHg6IG9yaWc6ICIsIGFkZHIp
Owo+IMKgwqDCoMKgwqDCoMKgwqBEVU1QX0JZVEVTKCgodTgqKSZwb2lzb24pLCA0LCAiJXB4OiBy
ZXBsOiAiLCBhZGRyKTsKPiAtwqDCoMKgwqDCoMKgwqB0ZXh0X3Bva2VfZWFybHkoYWRkciwgJnBv
aXNvbiwgNCk7Cj4gK8KgwqDCoMKgwqDCoMKgZG9fdGV4dF9wb2tlKGFkZHIsICZwb2lzb24sIDQp
Owo+IMKgfQo+IMKgCj4gwqAvKgo+IEBAIC04NjksNyArODgyLDcgQEAgc3RhdGljIGludCBjZmlf
ZGlzYWJsZV9jYWxsZXJzKHMzMiAqc3RhcnQsIHMzMgo+ICplbmQpCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBpZiAoIWhhc2gpIC8qIG5vY2ZpIGNhbGxlcnMgKi8KPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjb250aW51ZTsKPiDCoAo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0ZXh0X3Bva2VfZWFybHkoYWRkciwgam1w
LCAyKTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZG9fdGV4dF9wb2tlKGFkZHIs
IGptcCwgMik7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gMDsKPiBAQCAtODkyLDcgKzkwNSw3IEBAIHN0YXRpYyBpbnQgY2ZpX2VuYWJsZV9jYWxsZXJz
KHMzMiAqc3RhcnQsIHMzMgo+ICplbmQpCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpZiAoIWhhc2gpIC8qIG5vY2ZpIGNhbGxlcnMgKi8KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjb250aW51ZTsKPiDCoAo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqB0ZXh0X3Bva2VfZWFybHkoYWRkciwgbW92LCAyKTsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZG9fdGV4dF9wb2tlKGFkZHIsIG1vdiwgMik7Cj4gwqDC
oMKgwqDCoMKgwqDCoH0KPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gMDsKPiBAQCAtOTEz
LDcgKzkyNiw3IEBAIHN0YXRpYyBpbnQgY2ZpX3JhbmRfcHJlYW1ibGUoczMyICpzdGFydCwgczMy
Cj4gKmVuZCkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqByZXR1cm4gLUVJTlZBTDsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
aGFzaCA9IGNmaV9yZWhhc2goaGFzaCk7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oHRleHRfcG9rZV9lYXJseShhZGRyICsgMSwgJmhhc2gsIDQpOwo+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBkb190ZXh0X3Bva2UoYWRkciArIDEsICZoYXNoLCA0KTsKPiDCoMKgwqDC
oMKgwqDCoMKgfQo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOwo+IEBAIC05MzIsOSAr
OTQ1LDkgQEAgc3RhdGljIGludCBjZmlfcmV3cml0ZV9wcmVhbWJsZShzMzIgKnN0YXJ0LCBzMzIK
PiAqZW5kKQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBhZGRyLCBhZGRyLCA1LCBhZGRyKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gLUVJTlZBTDsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB0ZXh0X3Bva2VfZWFybHkoYWRkciwgZmluZWlidF9wcmVhbWJsZV9zdGFy
dCwKPiBmaW5laWJ0X3ByZWFtYmxlX3NpemUpOwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBkb190ZXh0X3Bva2UoYWRkciwgZmluZWlidF9wcmVhbWJsZV9zdGFydCwKPiBmaW5laWJ0
X3ByZWFtYmxlX3NpemUpOwo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgV0FSTl9P
TigqKHUzMiAqKShhZGRyICsgZmluZWlidF9wcmVhbWJsZV9oYXNoKSAhPQo+IDB4MTIzNDU2Nzgp
Owo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0ZXh0X3Bva2VfZWFybHkoYWRkciAr
IGZpbmVpYnRfcHJlYW1ibGVfaGFzaCwgJmhhc2gsCj4gNCk7Cj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGRvX3RleHRfcG9rZShhZGRyICsgZmluZWlidF9wcmVhbWJsZV9oYXNoLCAm
aGFzaCwgNCk7Cj4gwqDCoMKgwqDCoMKgwqDCoH0KCkl0IGlzIGp1c3QgYSBsb2NhbCBmbHVzaCwg
YnV0IEkgd29uZGVyIGhvdyBtdWNoIHRleHRfcG9rZSgpaW5nIGlzIHRvbwptdWNoLiBBIGxvdCBv
ZiB0aGUgYXJlIGV2ZW4gaW5zaWRlIGxvb3BzLiBDYW4ndCBpdCBkbyB0aGUgYmF0Y2ggdmVyc2lv
bgphdCBsZWFzdD8KClRoZSBvdGhlciB0aGluZywgYW5kIG1heWJlIHRoaXMgaXMgaW4gcGFyYW5v
aWEgY2F0ZWdvcnksIGJ1dCBpdCdzCnByb2JhYmx5IGF0IGxlYXN0IHdvcnRoIG5vdGluZy4gQmVm
b3JlIHRoZSBtb2R1bGVzIHdlcmUgbm90IG1hZGUKZXhlY3V0YWJsZSB1bnRpbCBhbGwgb2YgdGhl
IGNvZGUgd2FzIGZpbmFsaXplZC4gTm93IHRoZXkgYXJlIG1hZGUKZXhlY3V0YWJsZSBpbiBhbiBp
bnRlcm1lZGlhdGUgc3RhdGUgYW5kIHRoZW4gcGF0Y2hlZCBsYXRlci4gSXQgbWlnaHQKd2Vha2Vu
IHRoZSBDRkkgc3R1ZmYsIGJ1dCBhbHNvIGl0IGp1c3Qga2luZCBvZiBzZWVtcyBhIGJpdCB1bmJv
dW5kZWQKZm9yIGRlYWxpbmcgd2l0aCBleGVjdXRhYmxlIGNvZGUuCgpQcmVwYXJpbmcgdGhlIG1v
ZHVsZXMgaW4gYSBzZXBhcmF0ZSBSVyBtYXBwaW5nLCBhbmQgdGhlbiB0ZXh0X3Bva2UoKWluZwp0
aGUgd2hvbGUgdGhpbmcgaW4gd2hlbiB5b3UgYXJlIGRvbmUgd291bGQgcmVzb2x2ZSBib3RoIG9m
IHRoZXNlLgo=

