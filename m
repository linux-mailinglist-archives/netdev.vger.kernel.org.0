Return-Path: <netdev+bounces-8113-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE8C722C3F
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:11:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 907901C20CCC
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B5F622606;
	Mon,  5 Jun 2023 16:10:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEF36FC3;
	Mon,  5 Jun 2023 16:10:58 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632B6CD;
	Mon,  5 Jun 2023 09:10:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685981456; x=1717517456;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DcX/mgIZF1PdOzm0pjetJLhS6z49Hek0s2bcUYAh3f4=;
  b=OLISB08hqFRUGcJg96xNR30dY84f1QkXR1xeX9sQQ/ZTlJcsi5hCUKO+
   bzyR17ZpXDvWiJGLP4/hmYdz5i/DV7MfCUPtH0V8L+X22mVJkbKJPKREY
   gHXI3iFAIa/LzNh3EwduwNW70I3f3pLHiaFhOe4iHuBeu0DVZDX4ULVqO
   B1o0gmub7kttmmaEtX2IKWBzEmiEuChxhm9XdvA++mNy+FAEnr6zzW4K2
   Q8GdlU5ZHQnxz0ULf7aLAahwZWveGo0K1+yE/E24lPb+GCSabYVyhFVtU
   JOJJcBiPPkyMXGbpsUmI7CYc9tBrJZPn70FnmQyfErdbRck5Kw0m5/Yng
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="422232554"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="422232554"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 09:10:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="702798905"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="702798905"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 05 Jun 2023 09:10:29 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 09:10:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 5 Jun 2023 09:10:26 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 5 Jun 2023 09:10:26 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 5 Jun 2023 09:10:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9Y8QCoxrgFFb+eYkPSnVLA0Km/jjTSZ+VvUHuXfapank3sfqnHpfqUO35G0sRBHhWGpcspsKzcZlyyC+QQoFXr7c4ZNrfpy0yjXwBBPBPCEqcarxaS+SjYjCidGDeX8RR4D1K+u41rwi0bRWJ9V7K80Jwv+ghWgx7H1mUbXt/MsYwJIklp4qGBjU+fargD+C6YyCFkzPQXMaCIsHIHiCi4TeeRuzkZvvCYwWAdrtq3eo/dh63HLza78rwjSBXW3ADM+ip2fpghzyRF87cSfXdO8tCjRgRrFeUubT9ULsn3iu3wt0Fj1GfQpayJA4RU25Q5+qjXT03CxKrFXWdraPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DcX/mgIZF1PdOzm0pjetJLhS6z49Hek0s2bcUYAh3f4=;
 b=Du232hctzOByvw3DHjgGSacJlBNNUhhOKAB7krJPJnOTUISeEQKEeFHcteBTmm1lgbAkEVHIYwTNmd+1e7IDBeE+S+cA+8410LK259iJt3Ebgni1qN8ep0aeeRDGkxUuTiD0Y6fXsWtIHAjpATOnkbNHEntsffHP2kvVgr4FyBjqyg2JfZykvRJbLYXLnVKg7djAUBOFDY6bkLfEazUuR4LxNRE5zgNibinmAfeC7zGP+kJJOuj5ZXRU5rPCK6SfyTqNsyasH2eoJCtzFvbTuJOwYwjttUAsitExTkA7MSkIth2Ex899Ws/93w7HIqR56lzaOzFDtJ3t084VYCgOKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB6193.namprd11.prod.outlook.com (2603:10b6:208:3eb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Mon, 5 Jun
 2023 16:10:23 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6455.030; Mon, 5 Jun 2023
 16:10:21 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>, "rppt@kernel.org"
	<rppt@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "deller@gmx.de"
	<deller@gmx.de>, "mcgrof@kernel.org" <mcgrof@kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "nadav.amit@gmail.com"
	<nadav.amit@gmail.com>, "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
	"davem@davemloft.net" <davem@davemloft.net>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "chenhuacai@kernel.org"
	<chenhuacai@kernel.org>, "tsbogend@alpha.franken.de"
	<tsbogend@alpha.franken.de>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "mpe@ellerman.id.au"
	<mpe@ellerman.id.au>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"christophe.leroy@csgroup.eu" <christophe.leroy@csgroup.eu>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
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
Thread-Index: AQHZlKm5cQf5rjPFXEabUnQGbxJicq92PIKAgAADw4CAAAbOAIAAJQoAgAAzZgCABOjDAIAAWSCAgACFuQA=
Date: Mon, 5 Jun 2023 16:10:21 +0000
Message-ID: <88a62f834688ed77d08c778e1e427014cf7d3c1b.camel@intel.com>
References: <20230601101257.530867-1-rppt@kernel.org>
	 <20230601101257.530867-13-rppt@kernel.org>
	 <0f50ac52a5280d924beeb131e6e4717b6ad9fdf7.camel@intel.com>
	 <ZHjcr26YskTm+0EF@moria.home.lan>
	 <a51c041b61e2916d2b91c990349aabc6cb9836aa.camel@intel.com>
	 <ZHjljJfQjhVV/jNS@moria.home.lan>
	 <68b8160454518387c53508717ba5ed5545ff0283.camel@intel.com>
	 <50D768D7-15BF-43B8-A5FD-220B25595336@gmail.com>
	 <20230604225244.65be9103@rorschach.local.home>
	 <20230605081143.GA3460@kernel.org>
In-Reply-To: <20230605081143.GA3460@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB6193:EE_
x-ms-office365-filtering-correlation-id: ee8643d0-8d1f-4157-8171-08db65df5d13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l5teLHMKzFAk3oC03SjhIB0MUS5BMC3kJPnallgPovYCHtimkNUYjML/JYeNzXdOegN7Sm70uR/k2TWTHLtnXYqQVWb68OAlBUb5bETlJLQGUJgL8MAQSwBe7amwuTTaFlomrvsCfn9HGEVbj8t/u7w6z/DFP5CCn+bYKQHDQGnhw2GFbR1rW0qdALJ7SkqzCnXZT0VBRUzOkwtU1+MKJ0hJWj8U7X69uq1lorduvJ+CW7s7gsu+HkHs/+9wMLZljwfcsjO40CP5QBFbeJT7hwWB9M31Eput5YpoSPF/yoeJWQrL8wqMK2tIC3MR+WYILH+4RRGjaoLcAViMDd/Rq4pORCnD/2YcIApi7ko3VFk6zkPl3CiOHRIqAS8g4qR98foX8Q7s20dFu1QUVWkKWl1nQxiYK71Z7mAe7qpVNtr62phWOVNMJ0OsWquxPPsv6S7wO/H47es4eUqFd7vB9qScJtB+7w+eeRiLbD8oFRBUmcsT3Xdp8E72nITqHWt/Bw0iehWF3iUSt7fzGz/OpeMeHhp5ZqKTYcS63OoK7YUFi1tT6IHjJ0vqx/c7PnfKkvccBJOMfgi0Ope4hH/T0HdWWSab3xBTcJMMiuhVsUI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199021)(83380400001)(2906002)(2616005)(36756003)(86362001)(38070700005)(38100700002)(122000001)(82960400001)(966005)(6486002)(41300700001)(316002)(5660300002)(8936002)(8676002)(54906003)(110136005)(478600001)(91956017)(64756008)(66446008)(66556008)(66946007)(71200400001)(4326008)(76116006)(6506007)(6512007)(66476007)(26005)(186003)(7416002)(7406005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Szh2WkVDUGFsbU9qZ25QWUxhRTdJbFBJK0ZQWUU1RWkzanozTDFURHRydGNi?=
 =?utf-8?B?V1ZQbzVVdFVLS1lxdCs5dnIxRFVkbDc0aU92TVZHMDJTY2RKcFptbzMrazli?=
 =?utf-8?B?N2J6bkQrNmZhRHpHZnB6NFVyOGdpUm5GSFpPQVVJWlBrNURUV0dqMVV5MlBu?=
 =?utf-8?B?TGtqRWhPQ1FkUEFpUFZJT29hZHFDZkVQOTdxNS9md3Z1a0dIZ2ZUUEljb01m?=
 =?utf-8?B?cDQyK0Vjb2ZSQUhCR3phMkkrTVlSVzlRR1BuRGdFYm5YSklDUnFJVEVTdTA4?=
 =?utf-8?B?ZGNnM0s1c29WWER3UUsyWElHSFhvR1orRlNvT3ZONXUrekN2bE5EMG9mRnNI?=
 =?utf-8?B?eFphZDNXd3A1eUVMY2ZoQzh6RFhqZHpqbmtISFB0TU16RUh1QkJZUmRGdVFt?=
 =?utf-8?B?S2lJaSt1Qk41d1Fxb0U4VE5BeThoSktTYmxEaWxWN08zcTRXUm9HUTZtS2Vs?=
 =?utf-8?B?MnhXVjFMbkk0T1dBS2FXR2laRHpBV09BYnVuTWVTUE03TXdQRjc3M3VFeFhv?=
 =?utf-8?B?ZW5BS2g3ckdET0x3WjJDTkI4V2ZWU3orTzFyYkk5QUZZc3RNQW81bXJuTmlN?=
 =?utf-8?B?aUJwdSs2WnNIK1VTa3QrNnV1VDVjYjNjb3NnejQ2NU43cWd2WG1IdGF3UjNk?=
 =?utf-8?B?b2U0UGhYZkp6VXVVVDdURUFyeEtnLzNtYkk0dzFGS2JVZnpwanN6Rlk1cXVu?=
 =?utf-8?B?TG82NDFyQmVNMWdGNlFxcVdFTFVFbzdrczUzT0pDRHpCN3dCN2VFNkVaWVVp?=
 =?utf-8?B?alNJaTBmMHhsRU5GUkdubG11SVlEZlZ1U0VsSmRvTmZhQ3RhaEdsK2x5dnBZ?=
 =?utf-8?B?VzZMc0lHM3IxMVBmTzB4S1hpWFVlemUvK1V1T3dodHY1TDcyVFpBMnRDQXkx?=
 =?utf-8?B?VUhvQnZXR1RmeFBnK0lrMHZ3OUxGTjQ5RVF3cktQa3owaHVvMHNLSGFRSmdq?=
 =?utf-8?B?VEdnYjhSdWhPUXJNM1MzWmFqNUZMUGlmTS9WZXBZbldNWnhqdk4zUllSWHVI?=
 =?utf-8?B?c3lUdHR3cWNGeHJhUmE3am5QQ09ZQVQ2dEFsUzNkRTRYZ1JlNkl2RDJySnho?=
 =?utf-8?B?c0w5bG8xL3d6d3FMUEh5Y05jMmVXZ1hKSkpFL1B3aVNaTHhDQTVUVjd0RDl5?=
 =?utf-8?B?QzVWMHRTOXU0SVNaWnFzdDROUm92R2x6U2JleW53bVh1bHVVZThaRVBIQkp0?=
 =?utf-8?B?N3pnNGx0UHhOUG1yblVjMFBUOHlmM3pCT1ZBbm8zUGE2MFVaQkJCdjllaUJn?=
 =?utf-8?B?d0pVa1ExMDdtZUlRbm1JMWx4Ym5lWnY3R1hPUmtGVjVNWUhiRnJJMGFQOHdP?=
 =?utf-8?B?Y1NKc3FkeVJpcE9pUTlRTGFldzBOK2dtb1BaSmRlZGsvMjJ6Z0JYMFAyd01W?=
 =?utf-8?B?NmFJQmdEQkhOdHc1OGppZmhzajY2V0JUTW5WV1V5WWtET0tERk9lMTFJa1lK?=
 =?utf-8?B?VlBTZUIwcHFNTWFsRERoeHBpTGdRWk1nUkFNTGtlMmlKdW9pY1dLWDZiQXVV?=
 =?utf-8?B?NlVLd2xIQzBjbWVtYUZZVk9WNmE1QmQ4amxxbmd6SXlEY3JDWGRtVWplR3F2?=
 =?utf-8?B?WE9oY09HUjdBN2Z2M0txdG1ZbjlYVmxyZ2U5QUtYRzlKSzVQTk9qU2lnb3hs?=
 =?utf-8?B?dzl5WkdDa2x0NjM2VGoxV1RObjMwOUlPNTFYd0RSOVp6SWFkWjRYdUpWMjJv?=
 =?utf-8?B?K250YkJ1a3pQcWhNa2s0NkxoYnRYSFYwYTdyYmcvQnM4N0d4eVZHQ2NBSVk5?=
 =?utf-8?B?NGJMeUxyWU9BU0Y4UDM4UlVYWjhlVWg2c1kySE13elprbUUweXpTNU41Tytx?=
 =?utf-8?B?Y2tNb2lJVEpLSjBZN0R5S01QNEQ2RkkrRWc1aEFLSVI0aTNiR0wvNWdJSkpG?=
 =?utf-8?B?c0FzS0ZuVjVJZXpTbzRiK1ppdXBSSDczNWJ0ZTh0WHlwS0o5QVREMFJ5WU8x?=
 =?utf-8?B?MTlGc3lWY21QVkFiRzc4VjJHaktxWmduMmdhQXBsZGdydTJadkpLVnA2R1Yr?=
 =?utf-8?B?QXA5QktVQzUyZUtxUjBqRkZUOCtZZmpWcXZYQWREZ1pWbW51MTd5K282dCtp?=
 =?utf-8?B?Slk2YWQ2VkhwTURFb2xzVGNEdTJGZTF6aWROczlDSEhCcGNVQm13ME93MEMr?=
 =?utf-8?B?TzdzcDBRNDlWV1ZSMi9WWmRUdVl1cEFiQ0pON3VLa3hZaWVKNDNwNzFaVkRE?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <160C5866E02F8A45B3B65A7F5246565F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8643d0-8d1f-4157-8171-08db65df5d13
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jun 2023 16:10:21.6243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jQCyz/q2sGpIQsGCVO1eswqi4EBrJwlUJnz6hQx8TeGmSys5yQPrgFQ1SQr7UTktYitM6logw5XSYpsnN9chGGf4eq4hD+t0RHWhLeBwiNU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6193
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gTW9uLCAyMDIzLTA2LTA1IGF0IDExOjExICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOg0K
PiBPbiBTdW4sIEp1biAwNCwgMjAyMyBhdCAxMDo1Mjo0NFBNIC0wNDAwLCBTdGV2ZW4gUm9zdGVk
dCB3cm90ZToNCj4gPiBPbiBUaHUsIDEgSnVuIDIwMjMgMTY6NTQ6MzYgLTA3MDANCj4gPiBOYWRh
diBBbWl0IDxuYWRhdi5hbWl0QGdtYWlsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gPiA+IFRoZSB3
YXkgdGV4dF9wb2tlKCkgaXMgdXNlZCBoZXJlLCBpdCBpcyBjcmVhdGluZyBhIG5ldyB3cml0YWJs
ZQ0KPiA+ID4gPiBhbGlhcw0KPiA+ID4gPiBhbmQgZmx1c2hpbmcgaXQgZm9yICplYWNoKiB3cml0
ZSB0byB0aGUgbW9kdWxlIChsaWtlIGZvciBlYWNoDQo+ID4gPiA+IHdyaXRlIG9mDQo+ID4gPiA+
IGFuIGluZGl2aWR1YWwgcmVsb2NhdGlvbiwgZXRjKS4gSSB3YXMganVzdCB0aGlua2luZyBpdCBt
aWdodA0KPiA+ID4gPiB3YXJyYW50DQo+ID4gPiA+IHNvbWUgYmF0Y2hpbmcgb3Igc29tZXRoaW5n
LsKgIA0KPiANCj4gPiA+IEkgYW0gbm90IGFkdm9jYXRpbmcgdG8gZG8gc28sIGJ1dCBpZiB5b3Ug
d2FudCB0byBoYXZlIG1hbnkNCj4gPiA+IGVmZmljaWVudA0KPiA+ID4gd3JpdGVzLCBwZXJoYXBz
IHlvdSBjYW4ganVzdCBkaXNhYmxlIENSMC5XUC4gSnVzdCBzYXlpbmcgdGhhdCBpZg0KPiA+ID4g
eW91DQo+ID4gPiBhcmUgYWJvdXQgdG8gd3JpdGUgYWxsIG92ZXIgdGhlIG1lbW9yeSwgdGV4dF9w
b2tlKCkgZG9lcyBub3QNCj4gPiA+IHByb3ZpZGUNCj4gPiA+IHRvbyBtdWNoIHNlY3VyaXR5IGZv
ciB0aGUgcG9raW5nIHRocmVhZC4NCj4gDQo+IEhlaCwgdGhpcyBpcyBkZWZpbml0ZWx5IGFuZCBl
YXNpZXIgaGFjayB0byBpbXBsZW1lbnQgOikNCg0KSSBkb24ndCBrbm93IHRoZSBkZXRhaWxzLCBi
dXQgcHJldmlvdXNseSB0aGVyZSB3YXMgc29tZSBzdHJvbmcgZGlzbGlrZQ0Kb2YgQ1IwLldQIHRv
Z2dsaW5nLiBBbmQgbm93IHRoZXJlIGlzIGFsc28gdGhlIHByb2JsZW0gb2YgQ0VULiBTZXR0aW5n
DQpDUjAuV1A9MCB3aWxsICNHUCBpZiBDUjQuQ0VUIGlzIDEgKGFzIGl0IGN1cnJlbnRseSBpcyBm
b3Iga2VybmVsIElCVCkuDQpJIGd1ZXNzIHlvdSBtaWdodCBnZXQgYXdheSB3aXRoIHRvZ2dsaW5n
IHRoZW0gYm90aCBpbiBzb21lIGNvbnRyb2xsZWQNCnNpdHVhdGlvbiwgYnV0IGl0IG1pZ2h0IGJl
IGEgbG90IGVhc2llciB0byBoYWNrIHVwIHRoZW4gdG8gYmUgbWFkZQ0KZnVsbHkgYWNjZXB0YWJs
ZS4gSXQgZG9lcyBzb3VuZCBtdWNoIG1vcmUgZWZmaWNpZW50IHRob3VnaC4NCg0KPiANCj4gPiBC
YXRjaGluZyBkb2VzIGV4aXN0LCB3aGljaCBpcyB3aGF0IHRoZSB0ZXh0X3Bva2VfcXVldWUoKSB0
aGluZw0KPiA+IGRvZXMuDQo+IA0KPiBGb3IgbW9kdWxlIGxvYWRpbmcgdGV4dF9wb2tlX3F1ZXVl
KCkgd2lsbCBzdGlsbCBiZSBtdWNoIHNsb3dlciB0aGFuIGENCj4gYnVuY2gNCj4gb2YgbWVtc2V0
KClzIGZvciBubyBnb29kIHJlYXNvbiBiZWNhdXNlIHdlIGRvbid0IG5lZWQgYWxsIHRoZQ0KPiBj
b21wbGV4aXR5IG9mDQo+IHRleHRfcG9rZV9icF9iYXRjaCgpIGZvciBtb2R1bGUgaW5pdGlhbGl6
YXRpb24gYmVjYXVzZSB3ZSBhcmUgc3VyZSB3ZQ0KPiBhcmUNCj4gbm90IHBhdGNoaW5nIGxpdmUg
Y29kZS4NCj4gDQo+IFdoYXQgd2UnZCBuZWVkIGhlcmUgaXMgYSBuZXcgYmF0Y2hpbmcgbW9kZSB0
aGF0IHdpbGwgY3JlYXRlIGENCj4gd3JpdGFibGUNCj4gYWxpYXMgbWFwcGluZyBhdCB0aGUgYmVn
aW5uaW5nIG9mIGFwcGx5X3JlbG9jYXRlXyooKSBhbmQNCj4gbW9kdWxlX2ZpbmFsaXplKCksDQo+
IHRoZW4gaXQgd2lsbCB1c2UgbWVtY3B5KCkgdG8gdGhhdCB3cml0YWJsZSBhbGlhcyBhbmQgd2ls
bCB0ZWFyIHRoZQ0KPiBtYXBwaW5nDQo+IGRvd24gaW4gdGhlIGVuZC4NCg0KSXQncyBwcm9iYWJs
eSBvbmx5IGEgdGlueSBiaXQgZmFzdGVyIHRoYW4ga2VlcGluZyBhIHNlcGFyYXRlIHdyaXRhYmxl
DQphbGxvY2F0aW9uIGFuZCB0ZXh0X3Bva2luZyBpdCBpbiBhdCB0aGUgZW5kLg0KDQo+IA0KPiBB
bm90aGVyIG9wdGlvbiBpcyB0byB0ZWFjaCBhbHRlcm5hdGl2ZXMgdG8gdXBkYXRlIGEgd3JpdGFi
bGUgY29weQ0KPiByYXRoZXINCj4gdGhhbiBkbyBpbiBwbGFjZSBjaGFuZ2VzIGxpa2UgU29uZyBz
dWdnZXN0ZWQuIE15IGZlZWxpbmcgaXMgdGhhdCBpdA0KPiB3aWxsIGJlDQo+IG1vcmUgaW50cnVz
aXZlIGNoYW5nZSB0aG91Z2guDQoNCllvdSBtZWFuIGtlZXBpbmcgYSBzZXBhcmF0ZSBSVyBhbGxv
Y2F0aW9uIGFuZCB0aGVuIHRleHRfcG9raW5nKCkgdGhlDQp3aG9sZSB0aGluZyBpbiB3aGVuIHlv
dSBhcmUgZG9uZT8gVGhhdCBpcyB3aGF0IEkgd2FzIHRyeWluZyB0byBzYXkgYXQNCnRoZSBiZWdp
bm5pbmcgb2YgdGhpcyB0aHJlYWQuIFRoZSBvdGhlciBiZW5lZml0IGlzIHlvdSBkb24ndCBtYWtl
IHRoZQ0KaW50ZXJtZWRpYXRlIGxvYWRpbmcgc3RhdGVzIG9mIHRoZSBtb2R1bGUsIGV4ZWN1dGFi
bGUuDQoNCkkgdHJpZWQgdGhpcyB0ZWNobmlxdWUgcHJldmlvdXNseSBbMF0sIGFuZCBJIHRob3Vn
aHQgaXQgd2FzIG5vdCB0b28NCmJhZC4gSW4gbW9zdCBvZiB0aGUgY2FsbGVycyBpdCBsb29rcyBz
aW1pbGFyIHRvIHdoYXQgeW91IGhhdmUgaW4NCmRvX3RleHRfcG9rZSgpLiBTb21ldGltZXMgbGVz
cywgc29tZXRpbWVzIG1vcmUuIEl0IG1pZ2h0IG5lZWQNCmVubGlnaHRlbmluZyBvZiBzb21lIG9m
IHRoZSBzdHVmZiBjdXJyZW50bHkgdXNpbmcgdGV4dF9wb2tlKCkgZHVyaW5nDQptb2R1bGUgbG9h
ZGluZywgbGlrZSBqdW1wIGxhYmVscy4gU28gdGhhdCBiaXQgaXMgbW9yZSBpbnRydXNpdmUsIHll
YS4NCkJ1dCBpdCBzb3VuZHMgc28gbXVjaCBjbGVhbmVyIGFuZCB3ZWxsIGNvbnRyb2xsZWQuIERp
ZCB5b3UgaGF2ZSBhDQpwYXJ0aWN1bGFyIHRyb3VibGUgc3BvdCBpbiBtaW5kPw0KDQoNClswXQ0K
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIwMTEyMDIwMjQyNi4xODAwOS01LXJpY2su
cC5lZGdlY29tYmVAaW50ZWwuY29tLw0K

