Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5494A9D5A
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 18:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376746AbiBDRFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 12:05:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:45511 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1376742AbiBDRFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Feb 2022 12:05:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643994319; x=1675530319;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QksmDMXG3nmnmGBQD4eyCfEalBbJse72Bqkc8Vlv9V4=;
  b=MiYDukxyoc3O2BmpIpInPgsoPC37Pf9FOWgcVdesH6txbitzaX0JnLZK
   QuIxR2dODtMmjBZ0yw/ScU8tiRxRjznf8Uaw3lwhep8h66o9dqAr7W//n
   l8Apb+AGu2drk4MsFQMT19CNz3wZ1ZLrD0dJXGm4VEff6sTF4QueZE1GM
   fwX+YsaqUdnzqoj3j/cF8O5brDTQU5JtkDxGcfRoYirLl91mXzVz+LhQT
   Ds4Exd4wb1p++CxJqrb10TRcdRvl1m4f+93M4ykiWup4lBqpv2ho2VZB9
   9RMvPwEAk51K7P77HWtI+10xM+Aul+INQfBfKdRIHJAtSyB1K1XTDqFNE
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10248"; a="248162758"
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="248162758"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2022 09:05:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,343,1635231600"; 
   d="scan'208";a="699732350"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 04 Feb 2022 09:05:00 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 4 Feb 2022 09:04:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Fri, 4 Feb 2022 09:04:59 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Fri, 4 Feb 2022 09:04:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrcr8tZK5disx7QIE2Pqp0dCuyc+8c/dGbyiU3vLWG0FrThiOTv0qrHudAvbUxLz4ycfcoG5TaZR4AGDgsTnjz2cb+lbOrQXD85L5Gd0YuAYT+CTF9p0Q/jPnDmPEBH+58hiOl8XV2DvesTcM8x6ir58LGBWYk9nhZyfsBgBxJRCOBoC3g7pDw+ueMe/BacWkaTz1kYw+vjLxO1LVOdsm2NUWSIV1xF5J7mo/je7SIB7s6x3m+QBv+GIJ3EEg7NnjH7wdvITq2Pciwovs4lnblmTN5nnHEqWOFufFy14g8aV1d5Q8VbkckDZ87wB6j70UKsThgaquYAqUySOWst5dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QksmDMXG3nmnmGBQD4eyCfEalBbJse72Bqkc8Vlv9V4=;
 b=AuYxSDp8775MnGQVDEz9ISK8QysXac0oaVy6kDhNX8CX944rpDhJpeNMimprWcgGh9u/MK01G1dyN3LwN28ABS1MoO+z6+4Jki308NB03V3591Gc6rv2zq6+hKrwidePp1fMPklx/uwcwKtIO3jMM5yAYi7jnsx9yVRmpxWRZyU33rJjmw2pUHBYjv55kBqBXTbwqWn2NXIaIO/F/O9bowX+vIMe4Ib1Uy8QNIGg0a4WIs4yPYYZ9nbu+S2fSpGWUoDFlrbM3QtWd8jOzC5KNGiPQGk61Q1dpsy/r35tPm3ncO6YL5/zEoCtkbr1R37LwvmasTWl7naHGRF5CoQUbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by PH0PR11MB4791.namprd11.prod.outlook.com (2603:10b6:510:43::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Fri, 4 Feb
 2022 17:04:58 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bded:8c4b:271e:7c1%5]) with mapi id 15.20.4930.023; Fri, 4 Feb 2022
 17:04:58 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "andre.guedes@intel.com" <andre.guedes@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vedang.patel@intel.com" <vedang.patel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] igc: Clear old XDP info when changing ring settings
Thread-Topic: [PATCH net] igc: Clear old XDP info when changing ring settings
Thread-Index: AQHYGZ2tzEmCbpcqjUa3LJ7uzfmEa6yDn2gA
Date:   Fri, 4 Feb 2022 17:04:58 +0000
Message-ID: <0f1e1c0fc4f555ef0eaaa983da6d8f012a0acf60.camel@intel.com>
References: <20220204080217.70054-1-kurt@linutronix.de>
In-Reply-To: <20220204080217.70054-1-kurt@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e365ca4-027f-4eef-8378-08d9e800793d
x-ms-traffictypediagnostic: PH0PR11MB4791:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <PH0PR11MB4791C2CCDF92D9E1FB203BB2C6299@PH0PR11MB4791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dziNV2Vp5C3XTAkXU5aUH7E0TL62P96wTvu+A/WEmh62sDitOHj7bE4+FbiR1dL4y6FThkUm2+gNvWlI3GdbFBtP3EZvfUeCDxCgS2pcq3G3vpmR9MpokBt82jBkssjU4ve0JnZKy56ary2fl+AI3NbHvjov6kJIrBvUvss3k1E5LQ8GjnAjBeYQIE3EG7FIQ6PlWnK44g+b0y4/VY9fXsTzaR7YGpAhcL7veyQ1EGyWFHpjjNm9pTGuhuAhH3DzJCchUbVjXkLJcD0icvj4VcE5MzLt57iudzPzgwXZ7foql49TFVj41ZWlMKP7V6r+PM1jKc/7bxDFf4CCnEcYWz71Mj0ariEuKwroYNL+xZ3lFKYxDYiiuQbaqSOCBxsuMZuU7XLLWf3V6kt0lDQ12l/yvB8QNNFxNV2yIjcONU2xXH69fYBYDT4UJBL6ECWqj0ooKcLGkuWHXLP6iZvcElJAAqwuBqaCuuTKY4I9wtigbgF8p7BSSOpkVN+g4wI2JSCGUg1hf1YZAYSwJ7hGeHZsnmh06sE10ludpLb7kottXzLtSyV9Vdv15RbRQkJZurCP80RLl4wA0y/3IANQXnQaYJ9CSCVsHkdjfMOSfXa6VKW9wGqYvrTFHjkzaSWUcX/+mCQ4/Zp1WLUl8lx/v+MPld9XxvHBfvPT5QGAmInnNuDjp/7j/DS5bUYqOmk0zXVeh5rikIM78fyvufIGmtbrBHlmBX9YN7u4qbbpPlWDCer9sCqKt6bKfkqKkg6a4dd+x2V/4ZPJia30A+0eQYEV85ebI6uuD41nmhAZnzMmGilR6+U7OUxpch6uRmxrAglJDNqqAKwe/74dtUPxJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66556008)(64756008)(66446008)(4326008)(66476007)(2906002)(6512007)(8936002)(8676002)(83380400001)(5660300002)(4744005)(66946007)(91956017)(76116006)(26005)(186003)(2616005)(36756003)(6506007)(71200400001)(38070700005)(86362001)(316002)(6636002)(122000001)(966005)(508600001)(6486002)(38100700002)(110136005)(54906003)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NHFTZ0QxWXhFR2l6OVIyWDdMMk9RcEdUcGE2NjRWdUllZWk4UTFscExVMG00?=
 =?utf-8?B?Um5DS1FKalZpNElGQlEzNEhBZG53LzFTZjFtSDJKSHFLclhnSFlDN1NFQjZB?=
 =?utf-8?B?VUlBeVRXcml1eWgxREpuQVBjemRkc2l4OHhMUTNrYlNWVGZDc1lsczVSbWl6?=
 =?utf-8?B?ZDF4ZjhSeHZZWEpOcDBlUGlvV0hOSmFzUHdSdnlWVlcvRUN3OWpVUTdLdU85?=
 =?utf-8?B?T2IxaDNlUkpvcjhtbWxQRU9zanc4aklsbC96dkpkTFIraDFzMjlabi9HKzVB?=
 =?utf-8?B?cHNmbHBaRjBHRmlvdW1zYWhjcGFRMjcwZm5uVmRyeW1tQmZIQjNaTHB3SHJU?=
 =?utf-8?B?Z01XVkhoMWpmUUNQeWw4Qkl4anNKN3BBNjVlbkhXcHRNeFN0eE9EZzc3VnlO?=
 =?utf-8?B?TjlEdEdtV2pRT2k5blpSbGRyZmFpaEIzZk9LL1JqdU55SXNLQS9DZzBnamhM?=
 =?utf-8?B?VGliZ2lvNEUwV1dnQXIzcXZVNjZkQzZrS2RZVFptL1dEYVBrb05rQzQ5V2l6?=
 =?utf-8?B?Um5IeVNxemcyMWVvZnNUV0J5aTcwcnlqaE5UcENlV0p4dlUxY3ZTNEpqYnRQ?=
 =?utf-8?B?YTNMMS9sV0NscmtiN1M1VVdCNEhTaVNBQk5qRk9jZWI4VTZjQmJnRWY0VTFK?=
 =?utf-8?B?ekJjQ0E2VnB1ekNoZmdjY1M2NUEySGk4SjRhN2ZPNC9acGdKb1FYZ00xeEIy?=
 =?utf-8?B?eTQ4a2pSZ1hIYm9SUmRaZUZyTitTcnhwL2h5c3Y3VGpqYTVtTlJ2eEZ5SnVB?=
 =?utf-8?B?RStIeTFKVjFhRnNta1JwdDBTU205dE5lMTNseDZQbTlWV3lTLzRIemptTHRv?=
 =?utf-8?B?RlM0RWtXb2JubjNpQmpMQVd5ZHl5bjBNVVVhallPbnpNWVBES0RqZENOaG9R?=
 =?utf-8?B?K0hUOUpHbzRpUko5cFhnTktZY3I0dnUxbEFlVFJQUk80L0taa3N2eW5rRFRI?=
 =?utf-8?B?am1Bak1jNUdocFZXcEg5R3J2Z294aTRsWVFnS1NPTm54NDdZd01saWViWUVZ?=
 =?utf-8?B?TDhzY3RQdHREdUxRMGZmenZ6NlVGeUVJeDZlNXY3SnYyN3lIdnI3anNKOU82?=
 =?utf-8?B?Q2FWbWxOMmNPbWc5bXlIRnV5MGtkS01kWk9CamoyaG10dnNEN1pYWUF3ZWdK?=
 =?utf-8?B?KzlGeU5pWVlHOU90T2h6TXlLeHh4QVRmS0c1Q2E5Rmc1ZkVGYWlGaDQxcVBn?=
 =?utf-8?B?TTNDbDJlRGo4VEpmRjRiTGNHRmhtaHovU0VCRTJnNWF2QTBUeFJ2RDNaRi81?=
 =?utf-8?B?NkV2dWZNZVpzUElvZ3pxUTJpQk84VjRrb0dJQko5cFhsUDlRZCtvTXp3ZTFE?=
 =?utf-8?B?NGtHbllPVm50QXRNcG1RNmlYRWFTYWNNdlpab0RsOFZPbFh6dFptWEcyNHVD?=
 =?utf-8?B?L3d6bmdIZ0Z3elRDanFKV05JU0lKZFJ3QWdpQU9IY3lKbmhCQ1EvSGpXT2hZ?=
 =?utf-8?B?M2ViT0pHK3VDbGF0cmhOOVRoVURIYm5NZ1dTaXZkWWo4N1lFTnZEd3c2UnhZ?=
 =?utf-8?B?RzFPOUFhd0RCMjZlYS8xdXNtbnF6TllYMG5tTVVua3ZYTk00cUdrbnhSa3Bm?=
 =?utf-8?B?Wnl3cUV0SVRyR0R2alM2amNyeHFVSWdHRUtDQ0h5UVExTkhWRGhCNEFJc0Nh?=
 =?utf-8?B?U3RhQk53L2pPN25ZU3VscEdiUXpDTjhoUEZxZUVmUGZuM1Q5Y2taQXhqYU1j?=
 =?utf-8?B?bVlHQzJTaTRmSC80TjVkTUdPODhVTGExTWRpVTQ0RHNrN3hYZEdJN2R6V0ts?=
 =?utf-8?B?YzJvVE5ic3l2NkI1MzF4SVlYZm5zQW1UOTAxczJBOHYwOFFyYVRQVDNFMFB0?=
 =?utf-8?B?aGdybkVBc2ZEcitxdjZCYW9uZ0E3VnlYVEZ5WG5menNrVkJKSmR3NGxDbmhT?=
 =?utf-8?B?dlZMQ1o2aDF2YW9FaE9Bbk5ncVJ2dk9BZzNwM09tYWFZTEdaTEh5SGdrVzVG?=
 =?utf-8?B?ekM2L0I2VnZDSVllVWh2NXlPalVZV0c3MGFHVXRlVi9yZ0JoQ0FBMmZPckNk?=
 =?utf-8?B?OFVUdFVwbDVFdXpEcHdrV3FyVCs4NkRjTEtSUlRpR1hpRDZrSE1LRFRodWpk?=
 =?utf-8?B?NldLYUVVWW5CcW9icHY2ejZRRUZLQjhkTzFtZWhCNHB5N2lTenhFd2cyczNy?=
 =?utf-8?B?SHJXc1Z1UkkxN1FESU4zMTB2alVRcEN5SFBQcSs0dDljN3V5Z2owMkNIZ1VI?=
 =?utf-8?B?ZExuS3d1RVU2ZVpZL3Jyd05Lalh0U2x0cUJPaFQ5ZHo0K3JoMU5SR0JpT2g4?=
 =?utf-8?Q?RXUds+r2xoVKewyg5887vB5CgZyr7JwppceTpgQz20=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D87E9DE26BACC4498413802D61F9A489@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e365ca4-027f-4eef-8378-08d9e800793d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Feb 2022 17:04:58.0260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ru2Jtgw4CFnQniv+EVZyVCg40TVLihAC2d8LNMIR01JHGw4Mp7TEpUrqWgToiNo9GevVDH2UeJ1LXnmy/XVONvfNG6bYfKeXK5ikJdHMhwk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4791
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3VydCwNCg0KT24gRnJpLCAyMDIyLTAyLTA0IGF0IDA5OjAyICswMTAwLCBLdXJ0IEthbnpl
bmJhY2ggd3JvdGU6DQo+IFdoZW4gY2hhbmdpbmcgcmluZyBzaXplcyB0aGUgZHJpdmVyIHRyaWdn
ZXJzIGtlcm5lbCB3YXJuaW5ncyBpbiBYRFANCj4gY29kZS4NCj4gDQo+IEZvciBpbnN0YW5jZSwg
cnVubmluZyAnZXRodG9vbCAtRyAkaW50ZXJmYWNlIHR4IDEwMjQgcnggMTAyNCcgeWllbGRzOg0K
PiANCj4gPiBbwqAgNzU0LjgzODEzNl0gTWlzc2luZyB1bnJlZ2lzdGVyLCBoYW5kbGVkIGJ1dCBm
aXggZHJpdmVyDQo+ID4gW8KgIDc1NC44MzgxNDNdIFdBUk5JTkc6IENQVTogNCBQSUQ6IDcwNCBh
dCBuZXQvY29yZS94ZHAuYzoxNzANCj4gPiB4ZHBfcnhxX2luZm9fcmVnKzB4N2QvMHhlMA0KPiAN
Cj4gVGhlIG5ld2x5IGFsbG9jYXRlZCByaW5nIGlzIGNvcGllZCBieSBtZW1jcHkoKSBhbmQgc3Rp
bGwgY29udGFpbnMgdGhlDQo+IG9sZCBYRFANCj4gaW5mb3JtYXRpb24uIFRoZXJlZm9yZSwgaXQg
aGFzIHRvIGJlIGNsZWFyZWQgYmVmb3JlIGFsbG9jYXRpbmcgbmV3DQo+IHJlc291cmNlcw0KPiBi
eSBpZ2Nfc2V0dXBfcnhfcmVzb3VyY2VzKCkuDQo+IA0KPiBJZ2IgZG9lcyBpdCB0aGUgc2FtZSB3
YXkuIEtlZXAgdGhlIGNvZGUgaW4gc3luYy4NCg0KVGhhbmtzIGZvciB0aGUgcGF0Y2gsIGJ1dCB3
ZSBoYXZlIGEgcGF0Y2hbMV0gdG8gcmVzb2x2ZSB0aGlzIGlzc3VlIGluIGENCm1vcmUgcHJlZmVy
cmVkIG1ldGhvZC4gaWdiIGlzIGFjdHVhbGx5IGNoYW5naW5nIGFzIHdlbGwgdG8gdGhpcyBuZXcN
CnNvbHV0aW9uIFsyXS4NCg0KVGhhbmtzLA0KVG9ueQ0KDQpbMV0gaHR0cHM6Ly9wYXRjaHdvcmsu
b3psYWJzLm9yZy9wYXRjaC8xNTgxODE2Lw0KWzJdIGh0dHBzOi8vcGF0Y2h3b3JrLm96bGFicy5v
cmcvcGF0Y2gvMTU4MTgxNS8NCg0KPiBGaXhlczogNDYwOWZmYjlmNjE1ICgiaWdjOiBSZWZhY3Rv
ciBYRFAgcnhxIGluZm8gcmVnaXN0cmF0aW9uIikNCj4gU2lnbmVkLW9mZi1ieTogS3VydCBLYW56
ZW5iYWNoIDxrdXJ0QGxpbnV0cm9uaXguZGU+DQoNCg==
