Return-Path: <netdev+bounces-11510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 761667335D5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:19:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9939C1C2108C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:19:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBECA1ACB7;
	Fri, 16 Jun 2023 16:19:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EA1171CE;
	Fri, 16 Jun 2023 16:19:26 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C3649EC;
	Fri, 16 Jun 2023 09:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686932343; x=1718468343;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=7aQzXaNNCzcofhR0wByREp9LMZNsQcX56Do4/qKDzbM=;
  b=FcqWLjjEFAjs0BlVheQxdI4LXdF2GBraYEhg4W4rKBbI2NGKSxPJ4A6l
   Z36wr9LFt+sSNeiCPCKsQE3Fm89KQOzXz3UQn6TBUbGq75BcmBYOuNbMR
   qRodoJzmkLCU0AdXoDo52N1rRznxqbN3LjbKZMcvhy1P2Goe1DiWCDwjy
   cT5P/AHwqBqNafs0PQOkE13r9gbGug/2jnq7k6ilZJnLPGwthmONcbnh3
   iYi7nXicDyoPvQp+UyM+VQolIN2Bx46p7khCjVPfMB4UZMMlPt+jKpsUS
   b5aTxkshTQm3G19kkb82Xn5LrTttsAN+ThNxHSu07H2xn19srwX9nV5c5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358124857"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="358124857"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 09:16:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="857447982"
X-IronPort-AV: E=Sophos;i="6.00,247,1681196400"; 
   d="scan'208";a="857447982"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jun 2023 09:16:34 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 09:16:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 09:16:33 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 09:16:33 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 09:16:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RIKvaAVpjLljoZh+zdIsIIb72gYKvkuR6oG3Q1WK9krH9oDT/8wqL2s+zAfCcP676QriedulURXxpAMTRpRjPR4NZqKmnKEg5omW0XcS9uarEKVtTHPqpyh9HfFihZcm0ASeqOp5l3sT0XqMuwanxAVZfAloIhjqqrb1euvVlfLIO/TUJsmVChhuVoDQPbzpXgEmRLGRblEpX5ktfqVJ2+ikK81p8yKusXQT4F49chS6FuhSwQPQA1g20uFOOh4tzuwTdBSfa6t5aSuPEOCEJ/wuvuqe2GzxA6k6ql3wmOi0MnsSA3yXbVAhN5o08sPeTIx25+5Q8BXRzLs3RgtQ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7aQzXaNNCzcofhR0wByREp9LMZNsQcX56Do4/qKDzbM=;
 b=S37z/anMvXZxtjjRKzDyL1xlNupeDNnYf29q180NYSR3hsN3dVlhazZyy0Yja6pcIo0Nfn9limKYMaDNeoDJvHyM6mkohQdyxlrIeREf0u8LPHFXdzYe5KWr6DQySpfVVusF2o773gK0FXl0XLl4cZFHXTyabsUP/z7S40sCU273ZP/tS34f9PiMouffmwPiM8BC9QFBNflocYWqzpRqiKWbeJ6FgDnUuGN8QswmqgVC6pC1sYesLOofTR42I4APSB+bPUk2Up8MRe+7I2YYSWnc5SDYv2F/DCJKdtm4HPYAhVs4ky8h4GA4KA0DYPgAdUNX6USAJsjPENB7KuLLVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5211.namprd11.prod.outlook.com (2603:10b6:806:fb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.29; Fri, 16 Jun
 2023 16:16:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::6984:19a5:fe1c:dfec%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 16:16:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mcgrof@kernel.org"
	<mcgrof@kernel.org>, "deller@gmx.de" <deller@gmx.de>, "davem@davemloft.net"
	<davem@davemloft.net>, "nadav.amit@gmail.com" <nadav.amit@gmail.com>,
	"linux@armlinux.org.uk" <linux@armlinux.org.uk>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"kent.overstreet@linux.dev" <kent.overstreet@linux.dev>,
	"puranjay12@gmail.com" <puranjay12@gmail.com>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "tsbogend@alpha.franken.de"
	<tsbogend@alpha.franken.de>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-parisc@vger.kernel.org"
	<linux-parisc@vger.kernel.org>, "christophe.leroy@csgroup.eu"
	<christophe.leroy@csgroup.eu>, "x86@kernel.org" <x86@kernel.org>,
	"mpe@ellerman.id.au" <mpe@ellerman.id.au>, "mark.rutland@arm.com"
	<mark.rutland@arm.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
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
Subject: Re: [PATCH v2 04/12] mm/execmem, arch: convert remaining overrides of
 module_alloc to execmem
Thread-Topic: [PATCH v2 04/12] mm/execmem, arch: convert remaining overrides
 of module_alloc to execmem
Thread-Index: AQHZoC/LGBA3mmzfQkO23PT+dFijlq+Nm28A
Date: Fri, 16 Jun 2023 16:16:28 +0000
Message-ID: <15f5dff8217b1a2e16697d40e48dee6dd1f9b2f3.camel@intel.com>
References: <20230616085038.4121892-1-rppt@kernel.org>
	 <20230616085038.4121892-5-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-5-rppt@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5211:EE_
x-ms-office365-filtering-correlation-id: 1b1e1c0d-78d1-4dbe-2289-08db6e850a8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sL+NvKcWu4qq1yK/0fUqlmIywEbv6qulNC7P+tEWorqnAUtbvxpFjSaAYvqkhmIKWnybi9OhM4i9fH6Mx6YsX/geEesmaMzxzot8rJzIpbtLY7vnfvcKecVs/po6fe18ELIgNu757gg1Keul2dKvf16TLMoFVyFe4nkR6/bRqqKZGlYgKVZvLN3W/wbYg9L9nRLrk0qevZGrXI3JZwSDdW1ajB4LFUiV586dXAEb55G2+u6v3qbWmZg52ZIr06673MnQkWUYJ5XGu0HYbvFMYe8OjalagrKhRW2g3lq7gue9h7etKAFT+7W+gZL1tuJXWcRZ16dHxDRI8ftJ0FqecLkSIohZDlz8gHhuUC7BFsaV07XunbOLztPz1YCiAxnkaHSKqgfjrkamLKn8W7WoIXThw58OPB8TnA/R0xKzLLRrZeqG8Bjp+W4vp9wXrLFSny3cfFkHj75hVQtoi5G/mjwsSDUsdwAUb6L3Xpv/i5/19J6NJQFawgPZjlHyep/TkpmHc5apc/1OmBzgjND8h5Rhl+w8kIptwFDFBDCgju5t+roHd6L04fkURveqxTFcbu2lwSdW+P2PkysQgAos/RQO1U8x6jL+2yW26vuXT7/eyupzkiidp0E65FY9L13r
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(366004)(136003)(451199021)(478600001)(110136005)(54906003)(6486002)(122000001)(5660300002)(8936002)(82960400001)(8676002)(41300700001)(2906002)(36756003)(38070700005)(86362001)(7416002)(7406005)(38100700002)(66446008)(66476007)(66556008)(64756008)(316002)(66946007)(4326008)(91956017)(76116006)(71200400001)(26005)(6512007)(6506007)(186003)(83380400001)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0F4bHRNWkNCM0RIZHcyeVNzbHZpU1h0NEljSlJsVkRQWVlLVHRrMHJWVjQr?=
 =?utf-8?B?aDdQVGtqa3hkSnlBZFF4MkRrSUpwTDRnK0hVbjlHcmkxcXowN21qN3hQcXJ6?=
 =?utf-8?B?WjZ3anErejR1REgvUlllQTFEMnJEOTB5UkJmZTdRcXY0OFVXVTBaemZNeEpR?=
 =?utf-8?B?UEhlVkNyVVNHVFl4UHZ4NlBpaXdSbncrM0R6S1lyR3NIMTJhemE2TThOaTJY?=
 =?utf-8?B?NitRcGdqUkEvWDQ2cE9MVndFNG9GeDBtZ1QyYkkyMVBlbWVCV1RMOElxUDVN?=
 =?utf-8?B?Qk9xbmZROXJiZXYraklPTlU2eWZyL1ZqL01yQ0FIb3VEaEI1ZlJiOHVzS3Vq?=
 =?utf-8?B?QXpjSFZjQ1Rmcnk3ZWY0Mm03RUQ5dnNhUGQ4VmUvUXpJMGxGTzRsWGdTbGE5?=
 =?utf-8?B?NUJYUnh2b3pNZVNNTUZlbmNkZCtpUGdobTFKVllRSjlJZFBTV0gyQnVrVEpw?=
 =?utf-8?B?OEJCb04xelhYU2hZSHpWU0dNKzJzczhRSlo5V0pzd2UycXdZR3hhQkFpTmNT?=
 =?utf-8?B?VjY2N2dPQzV6MFVWQzV3bmdwSUpQdWZZSUt3dVhQTGpSYkFLOUJGTU0wbjMv?=
 =?utf-8?B?S2l0dms4WnNaSHpYSEhFcjE3MC9pdEI4ekNQZVpSa2gyUU5VQ3pscnNaWmg2?=
 =?utf-8?B?YzUyVEllRUFaZmc4WGNlNUNYQXVkQlpBSm9kOGYxUzEwWFpNWVAwOUQ2ZFNZ?=
 =?utf-8?B?NitJUGJEbEFlTldPcEd6bWsxOTlJSUxtd1hvTUNwcVhsVGM3Nmt2Q1Ywb1ov?=
 =?utf-8?B?SEZxZnkzZGNPclZMZzZWR09uM1d1ZFBrU2svQ01nU1lrQWxzNzBpYTUvMUFB?=
 =?utf-8?B?ZHdTekd2dVIzWEVVYXh0WWV5SXU0dHI0QWhiNmptSCtKVzBUdmVkL1R1cXY1?=
 =?utf-8?B?RGNDd1ZxK2E0YW5mU1lqYW5JRHZuMmkzOU9NZFZ6WkxGWjB3UXZqUzNUL2tX?=
 =?utf-8?B?NGFnS3hhYUl4NWRtVElGQ1Q4b3VZa2VRMXg0T29JMmNxaGgrVlYxM1BqK2hk?=
 =?utf-8?B?L3QwQXlYemFjTk9ZZzJSVUdhUGlKd1FVT0greE5yRGJmc2xrTk55MW55OVdt?=
 =?utf-8?B?R0ViaGthZDdyQkdCWURuR0pmeDBGSGNaRnFPQUF6SXVSVzh0UFp3Z2dWM2J2?=
 =?utf-8?B?WjArUk44M0EyTlFqTUtCUlZVYzFsN0NsZW82eFcvQjdSU1hyVWZwS0xHZUNM?=
 =?utf-8?B?USt4MXQxZTNyZWJVTjNYc2FnSWhVNitzK1BxVXcxWmZVcHc1NDRTcjdsMmZs?=
 =?utf-8?B?WlBMa0dka2pGR1g5cVRUZDRXeG9tcVprMzBveExZU0NWVzNkZXJ6VURzcHQ0?=
 =?utf-8?B?NkJLTzhCdjdKYmtyVERjdWU0ZlRiS0lEOTV6enlUTnZRckxYMFIwRWRxdlhq?=
 =?utf-8?B?UGhBSmZtQU05SEdtSkhDeWorbldObmV1ZlJMNjlibEd2NEovVHZsZWoyOTAx?=
 =?utf-8?B?MWpRMlF5bmZXclA2c0NBcC90NTdDY1FsQ0JBN01OQnEwVVVjTVN4aWpMd1lh?=
 =?utf-8?B?NnNuOXBWcXJuZ0FCQ09DSXFLY01sNUdnQ2pSVWVoZ1BYdDlaaVloMTh6WXZG?=
 =?utf-8?B?Mnczc1l2N0sxQmt0SG53R1lzdlBMV2xNK2pkS2Ntb0ZNekRUcmRlMmNtNE5a?=
 =?utf-8?B?eDFFbVZ0MmJWR1pPS1V6TXY2VGtJU3VCc3hDQ2NFZ2hhYU5wdjBxVm5WTi9U?=
 =?utf-8?B?N3FyOVEwKzRDSkhodHdNNmdOcDlvM3hmazFTVEMwRlJPa0UwbzdzdEhrNDdH?=
 =?utf-8?B?YjlYZ3JCNjkrSnduN1g4L2hYSHZVeExGTkRvcEtUUjZzNExyaDJRQVlJT3Vp?=
 =?utf-8?B?T1ZLQ3BiZHpSTVFIQUY1MCt2b3JtRCtLTUkwRm5uOHgrYWx0RXlhcEhlR01w?=
 =?utf-8?B?NTJ3UXVRRG5zeDlLV0FEc0xIckFVZkJtQm9jOUYxZkJWaXZ2VVJtOHdPYWk2?=
 =?utf-8?B?dHFZcXVPdWZFczRJUkNOQmorM0RBY0w0Unc5S25pMUEwWnpzU2o2VlZxWTAz?=
 =?utf-8?B?THdzK3FCOE1sZ3A4MTg0Sk5DRTZ6ek9mcjJnZHBJUHBSZ3Q2NkZtVGtleFRy?=
 =?utf-8?B?VlNlTmpoSVZwL1Nwa1J2TkRWWFFyS3FZSWdMK1pIQjV5TDdXd0J6SlJxZEp0?=
 =?utf-8?B?MStLQmdIU1hGeHMvK0NJSnRLb1VpQ1V2WnJ3TmVaSFZYNTBxZjVVWmYxWS9q?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35AF17E8FF6808408461026965BABB0F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1e1c0d-78d1-4dbe-2289-08db6e850a8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jun 2023 16:16:28.9669
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1RXpNA2lUgeKDpHD6bbRl4Bo7YsAEJrIf+cbE98QxEJ5CBwaRzdcpv8A/GuGV03duFj9oTzK26lmfC8fjVdE6CJPGDuszF9h7A2LUPpgA8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5211
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gRnJpLCAyMDIzLTA2LTE2IGF0IDExOjUwICswMzAwLCBNaWtlIFJhcG9wb3J0IHdyb3RlOgo+
IC12b2lkICptb2R1bGVfYWxsb2ModW5zaWduZWQgbG9uZyBzaXplKQo+IC17Cj4gLcKgwqDCoMKg
wqDCoMKgZ2ZwX3QgZ2ZwX21hc2sgPSBHRlBfS0VSTkVMOwo+IC3CoMKgwqDCoMKgwqDCoHZvaWQg
KnA7Cj4gLQo+IC3CoMKgwqDCoMKgwqDCoGlmIChQQUdFX0FMSUdOKHNpemUpID4gTU9EVUxFU19M
RU4pCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiBOVUxMOwo+ICtzdGF0
aWMgc3RydWN0IGV4ZWNtZW1fcGFyYW1zIGV4ZWNtZW1fcGFyYW1zID0gewo+ICvCoMKgwqDCoMKg
wqDCoC5tb2R1bGVzID0gewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAuZmxhZ3Mg
PSBFWEVDTUVNX0tBU0FOX1NIQURPVywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
LnRleHQgPSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAuYWxpZ25tZW50ID0gTU9EVUxFX0FMSUdOLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqB9LAo+ICvCoMKgwqDCoMKgwqDCoH0sCj4gK307CgpEaWQgeW91IGNvbnNpZGVyIG1ha2lu
ZyB0aGVzZSBleGVjbWVtX3BhcmFtcydzIHJvX2FmdGVyX2luaXQ/IE5vdCB0aGF0Cml0IGlzIHNl
Y3VyaXR5IHNlbnNpdGl2ZSwgYnV0IGl0J3MgYSBuaWNlIGhpbnQgdG8gdGhlIHJlYWRlciB0aGF0
IGl0IGlzCm9ubHkgbW9kaWZpZWQgYXQgaW5pdC4gQW5kIEkgZ3Vlc3MgYmFzaWNhbGx5IGZyZWUg
c2FuaXRpemluZyBvZiBidWdneQp3cml0ZXMgdG8gaXQuCgo+IMKgCj4gLcKgwqDCoMKgwqDCoMKg
cCA9IF9fdm1hbGxvY19ub2RlX3JhbmdlKHNpemUsIE1PRFVMRV9BTElHTiwKPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgTU9E
VUxFU19WQUREUiArCj4gZ2V0X21vZHVsZV9sb2FkX29mZnNldCgpLAo+IC3CoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBNT0RVTEVT
X0VORCwgZ2ZwX21hc2ssIFBBR0VfS0VSTkVMLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBWTV9GTFVTSF9SRVNFVF9QRVJN
UyB8Cj4gVk1fREVGRVJfS01FTUxFQUssCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIE5VTUFfTk9fTk9ERSwKPiBfX2J1aWx0
aW5fcmV0dXJuX2FkZHJlc3MoMCkpOwo+ICtzdHJ1Y3QgZXhlY21lbV9wYXJhbXMgX19pbml0ICpl
eGVjbWVtX2FyY2hfcGFyYW1zKHZvaWQpCj4gK3sKPiArwqDCoMKgwqDCoMKgwqB1bnNpZ25lZCBs
b25nIHN0YXJ0ID0gTU9EVUxFU19WQUREUiArCj4gZ2V0X21vZHVsZV9sb2FkX29mZnNldCgpOwoK
SSB0aGluayB3ZSBjYW4gZHJvcCB0aGUgbXV0ZXgncyBpbiBnZXRfbW9kdWxlX2xvYWRfb2Zmc2V0
KCkgbm93LCBzaW5jZQpleGVjbWVtX2FyY2hfcGFyYW1zKCkgc2hvdWxkIG9ubHkgYmUgY2FsbGVk
IG9uY2UgYXQgaW5pdC4KCj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBpZiAocCAmJiAoa2FzYW5fYWxs
b2NfbW9kdWxlX3NoYWRvdyhwLCBzaXplLCBnZnBfbWFzaykgPCAwKSkKPiB7Cj4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHZmcmVlKHApOwo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXR1cm4gTlVMTDsKPiAtwqDCoMKgwqDCoMKgwqB9Cj4gK8KgwqDCoMKgwqDCoMKg
ZXhlY21lbV9wYXJhbXMubW9kdWxlcy50ZXh0LnN0YXJ0ID0gc3RhcnQ7Cj4gK8KgwqDCoMKgwqDC
oMKgZXhlY21lbV9wYXJhbXMubW9kdWxlcy50ZXh0LmVuZCA9IE1PRFVMRVNfRU5EOwo+ICvCoMKg
wqDCoMKgwqDCoGV4ZWNtZW1fcGFyYW1zLm1vZHVsZXMudGV4dC5wZ3Byb3QgPSBQQUdFX0tFUk5F
TDsKPiDCoAo+IC3CoMKgwqDCoMKgwqDCoHJldHVybiBwOwo+ICvCoMKgwqDCoMKgwqDCoHJldHVy
biAmZXhlY21lbV9wYXJhbXM7Cj4gwqB9Cj4gwqAKCg==

