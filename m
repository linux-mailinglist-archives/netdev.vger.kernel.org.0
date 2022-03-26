Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19944E7BA9
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbiCZAIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 20:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiCZAIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 20:08:24 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8E2E3A70E;
        Fri, 25 Mar 2022 17:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648253208; x=1679789208;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QOw2dj4hoMPJnbvDq0L74Et1GMTzcDsPGoyiAaMy8JI=;
  b=DCAMY4NCzFtG/mimoTfCa0YbQdX769NDMjnny95PHD4s+x6PkLDXPGht
   MVNdnqujOGiJWn0fP9RKPd5Kivk3JjGC7fokqk9puP6X9pC45j5AJdlda
   UmvOApc9oXKkwSukj/KtX4zJf6klVc66G8XJIrItqW5vGG16v4wjckl8w
   3+bEIUeA9BcFtAiUrycAR5ggBl422kUfBvYtRLpaUAmpua3xlHNyZO8rq
   PM0aOdq1gEXujcmKU43TwXKIho1/QuNGfDxLQMkdxuzn95ABcSHi/vvuA
   qlz3hPw6CW6iDWA8K0WBiUWqxEMSqRsMlnWHBzJgVMlpztm9FRbG1lFRE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10297"; a="258456538"
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="258456538"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2022 17:06:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,211,1643702400"; 
   d="scan'208";a="826181199"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 25 Mar 2022 17:06:47 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 25 Mar 2022 17:06:47 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 25 Mar 2022 17:06:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 25 Mar 2022 17:06:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TWxrHXtJUPa+vvGAkNcXfcoB7S+x3Wr7mLxGuWlCyTqM/1OSbf9PvIHgp8TfGNCSbFFDUrfTT84ChQLF8iGNchdsfKGfDMADDGELRrDAZVVazMNg38FQlXyohVaBCSNkbagqO2f6yHqebfbIkuBJ3/doPCZepAc+Cg9mkXbtakkJpHkgmLlIvWnM1dTHGmOuAclX1+ZNltxEygJOmRzkBaCwJBPGtkR2ywQLWNOBvRIbYed2p6gMDcxK9rtyW/H9ZrLqNkXzC1QHAxA4ooXE5F5JgkFUrgjf29VmJAxA7wuRXPNiwqPQFnr3BTAYNHqoce2nsvMa0n0mT2F5ees2PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QOw2dj4hoMPJnbvDq0L74Et1GMTzcDsPGoyiAaMy8JI=;
 b=I0VmSXZBq3yrjEAp3U9PiM3vCwSMf5iU1SApNSQS/9zT6plKTWWhb7b3QkEQ+ZdwuOxcmU/ik4V/mMtFE0bTN2IMieD6j4LgUdLejVCAAMxFUHagNulnrhktM4moXtTCrLMUS4wErM+Rl2DzfXUkQEtb6LQN3yWdx3oQb1s4b2PlPw6CwuoWqeulRlvy4BQBMJ322gmWvM3o7Z8JAy+Gw1K2w9eHO5vKbYMXM/7fMyzF7fdKzBpLrgYwikI0ibGvkNIXtmKP4uh4aMZYDhM4uosmKbvyWerc/FiDz76kEAE4wa8y27P/KOUkxyllrEkLeRWUhuif6OOZe0k5G7mdug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1392.namprd11.prod.outlook.com (2603:10b6:300:24::14)
 by MWHPR11MB1870.namprd11.prod.outlook.com (2603:10b6:300:10f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.18; Sat, 26 Mar
 2022 00:06:45 +0000
Received: from MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b]) by MWHPR11MB1392.namprd11.prod.outlook.com
 ([fe80::69:f7e:5f37:240b%3]) with mapi id 15.20.5102.018; Sat, 26 Mar 2022
 00:06:45 +0000
From:   "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "songliubraving@fb.com" <songliubraving@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "iii@linux.ibm.com" <iii@linux.ibm.com>
Subject: Re: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Topic: [PATCH v9 bpf-next 1/9] x86/Kconfig: select
 HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
Thread-Index: AQHYQHSY+pR621m40EmnNhTft3vXEqzQydiA
Date:   Sat, 26 Mar 2022 00:06:45 +0000
Message-ID: <5bd16e2c06a2df357400556c6ae01bb5d3c5c32a.camel@intel.com>
References: <20220204185742.271030-1-song@kernel.org>
         <20220204185742.271030-2-song@kernel.org>
In-Reply-To: <20220204185742.271030-2-song@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cb0c354-effb-4d47-4140-08da0ebc840f
x-ms-traffictypediagnostic: MWHPR11MB1870:EE_
x-microsoft-antispam-prvs: <MWHPR11MB18700155CA587815B4015B34C91B9@MWHPR11MB1870.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RhWpS9/43MKj7ITZJY5MvKfYEyd68D65QQ8cjHkWfu9dD9/FGABA44amgXv1vbVBmGjuDFqA9UYC5Y8huglcehk9GDywOyoFV3SO9LrMMazC3drGjHPpKk1sD1libX5y2WRkEvQVi3ggeGplIUsXSBqVMZSI762LxTPFTpK69382rW54FEWwR1u/Zq5RQlwkpMRJvIgcGfHhitzaSnZ5SFDxJq9Lz1GS2BhbvMEwdE5ooUwxgZgKByaVV4lXGzhVgnDgqm5JEX5Ukk0dK1yWtebfdEMNp2JVqbOYrutDvrAqhDF+bubbyv2Ue7+TzWxNHQrQ2VgPyCtHQnXr9o1LCxRX9R/d2Nn4yVv20+TtDGA1YNulLaLMxn5h0NsN1JX06T65al2mYyxbVLk6+WA7Io0jK2hWEfcDDsUb4hq4mfE1d7tUwRAL5j19RNOtuv1msEl/u4Iq5qm1WJTKRT0V05E1b64ddnIQLf7sASqMC6REdZ1ws2EvnZfdlEmDbnB1Pa2aWl8xFKlVICtInpwn6B3D66ay8y0QcWwHLzsp78eiIof9XHx0rhTS+KzAZBRhawCWeTScDA/tufeQSiiDUOGpmnVQMKZVBVobpmje7oTEZW7lG7dO3tK0frD/+J0o+SldXT/79Vw6jjmYcZCEqrCp0iqnJCjLtKHsr0zuZNwGu9WTOWntnv5anyl3+WcOIZobpM4kD0+WoIrD2UvRT8eUkjLgacdXLp/YHfWCEg2mhswbT/AiFrqyx+JAgeRbLbfsJYsboIbcZXg/z2YbvcD/KXbjwkTKToHACXGQXWbpZnvuLCrqz1MDvFK40Rmv2k8l6Mxe4ewDNqmplV8Fcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1392.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6486002)(76116006)(966005)(6512007)(86362001)(66446008)(66476007)(8676002)(64756008)(4326008)(110136005)(7416002)(5660300002)(66556008)(66946007)(38100700002)(2616005)(6506007)(82960400001)(54906003)(38070700005)(508600001)(122000001)(2906002)(36756003)(83380400001)(26005)(186003)(71200400001)(316002)(99106002)(14583001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UThQSW9MSWgrVG9ucTVOdzg3eGdmaDBoVTlRaTdpakw4VXRMQktZRUNtK3NW?=
 =?utf-8?B?TXd1eEQyOVRGZHI0UFM0dVhrQnlZb3ZSWXZXZURYT2k4QVJDemtlN0lXa1pM?=
 =?utf-8?B?RXpQbXl0NHVvSmphSWY5UUFUVFBWMjVkTldDU0RMbTBoM251Ylh3Kzd6OW1G?=
 =?utf-8?B?emZPZjdTL21wL2N4SEVKdzNQU1RGQVNWQy9vU2ZlRkwrVEVvR3o5UVFLSlZk?=
 =?utf-8?B?N0NYeVAzS2w3Z0pQMkJUUHJrdXQ1d0h4aGpYUytLU2tTTk9WMWtMWGVuV1Vx?=
 =?utf-8?B?cjllTU93cHlmTmlKWWJFWmcxOU9LUzFzZkR2K2hiYmNUYlpYbDFkcHhuZDZl?=
 =?utf-8?B?bDhLT2RIVzVkQnp3NjJDWlhublZTekFtQTduUVI2UUVzZVIwdWVScE56cEFn?=
 =?utf-8?B?VFo5VjhTeFY1NnNkVUorR2dsYUc2QXNiK0Y2WVNJY01weTBIRFpBTktUYTRT?=
 =?utf-8?B?L2dPVWsySjFLSEVwZ21hTVFzVDNNRWVGaURQSks5dFJTWGkrYkVkcmQvNW9S?=
 =?utf-8?B?Q2pLOUlRcmh6YkhEbWdmMGZ1eVdRZGE5Y1B1V0NSUU9UWnNGdFRMQ2NXWFh6?=
 =?utf-8?B?SUFnd1JOZjNzZVZxNCtEUzdtUlV0K2hVZm1qdk9WdFRRMnk0UXIwWWZHK0Nm?=
 =?utf-8?B?TUM4NkRiZXVXUUtlakF3Mkk4ZWQzOGxOdU9KRW91VmpuN2hMR1hpZkd3YnIx?=
 =?utf-8?B?T1VqRWtnb0tRNGt3cGJmbDRXbnFUUUVxRm1HQXo3T09kZGErakNRZHA4NGpH?=
 =?utf-8?B?V3MzQ3NWTnJlOVJLbW9QOEZXVmd6c2FBZFJZTU9GWnl3N0tPY21GTy9aVm92?=
 =?utf-8?B?L0EzVTgrdi9IMitqdkJGY2N5ZzBveFl1dHpXUUttcjJsc1JCVUNkcXdyaTli?=
 =?utf-8?B?eUxOUzNJZ0xlcXd2ZzF0QjZDaC9vazFiVFo1dUUySlVPLzQzSjBMU2g5dFlh?=
 =?utf-8?B?aWc4elpiVy9jaUh1K0wrZEZiNVV6bllva0VIbG1ZdytjZlJ0QmpScmd4Um16?=
 =?utf-8?B?MkxXL2UyWkJPN3JqMERBQmVjajhNKzl2dHUzUjBDaGtTRGlsakVLQVNmSSsy?=
 =?utf-8?B?SzRBeWlEejJ3RUZVUisxaVA1VkxNZHJTVkNXK0JINnl1UDF6dXlKYUx0eWYr?=
 =?utf-8?B?bEdPSXhudnEwTDl6YXQ4QURNc0xuQlpFd1AyNCs2eGdoaXZPcEJxTjhpL25a?=
 =?utf-8?B?NGhLM3ovc2FVZ1RqQlQ4N0hsVnNOMW5VMHdmNkxVWENlQjYyMXA3QmRQdy9l?=
 =?utf-8?B?WUkrV280ZXF5NXg3SWM0NGwxWFBrb0xNbGJ5YkdTOFd4NEJ2K0tmNjkyWW94?=
 =?utf-8?B?T3dZYUdHMWFKK1FFVGdEMVNIL2EvVDFOYXNnVW51ZGwzZzkyR21BaTZmOTZB?=
 =?utf-8?B?MnVDeVRubmVTOTg1RFlxMk5jbVEyTUc3MHdiam1MOTdBYjBodWg3Yk5KMnFz?=
 =?utf-8?B?WS8wcEpYcFdDd3dVamlId1BLTzR6eU4xYWZBUTIrV25icEZ4VlJQM1BKd3BJ?=
 =?utf-8?B?akY2eWZWRDkwY0VMcHRvOG1FenpCMFlPWThsUWtxRUJuOFFDNi9yM2JKVnY5?=
 =?utf-8?B?VHpCbzJlaGYrNFhmUjJKLy80ZVhuUGZLZG45UXBRWDV4WkwzU0h6b1ZZelZt?=
 =?utf-8?B?TFJqNzU1QW9qa0Q3T0V6bCtDeFg4RHkyY0ZtcThWZVR3U2gveTROd1BSajVu?=
 =?utf-8?B?Q1c3RzB3dUJRUlh0aFNoOCtVYTI5czhvMVJGanZmNkkxb1pXbU1SNEdqVXFJ?=
 =?utf-8?B?bCtPRjluTDF3ZXl4V0RYQjdsWU5qeW15a2pvR0Rhemg4bytIczJROVBGUlFw?=
 =?utf-8?B?UFAwSFhUMnkvWlBETENlRlRpNFo1SEpYbmNZWDJ4dU1MbzluSnl6LytubnYy?=
 =?utf-8?B?clZ2WFJVS2Rlc3BiZnpGM3daOFp1a2ZJVlVDRzVnU2Z4OW11a05FUjZzYVRC?=
 =?utf-8?B?N2d1TUpDR1gwVUkwSGpQcUNJb2xYVHJkUTlOWUNtRTJOQmRNaWQ4UU9jS1cz?=
 =?utf-8?Q?3dqRb7gKLC1JvSL+BAOIjlR5KyS8p8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DB01764C9759B408DEBB7A240DECA85@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1392.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cb0c354-effb-4d47-4140-08da0ebc840f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2022 00:06:45.7173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b1GhT66rJHBZgq9ymqXdVHBIIDV3BGLVhFvzMHTUMV1fQhq5bqjsjXUO1VCUdFyfadHqKPhGBJHKWeOiE3yvZzfuMii39v3MAiyzdwFmYPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1870
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTAyLTA0IGF0IDEwOjU3IC0wODAwLCBTb25nIExpdSB3cm90ZToNCj4gRnJv
bTogU29uZyBMaXUgPHNvbmdsaXVicmF2aW5nQGZiLmNvbT4NCj4gDQo+IFRoaXMgZW5hYmxlcyBt
b2R1bGVfYWxsb2MoKSB0byBhbGxvY2F0ZSBodWdlIHBhZ2UgZm9yIDJNQisgcmVxdWVzdHMuDQo+
IFRvIGNoZWNrIHRoZSBkaWZmZXJlbmNlIG9mIHRoaXMgY2hhbmdlLCB3ZSBuZWVkIGVuYWJsZSBj
b25maWcNCj4gQ09ORklHX1BURFVNUF9ERUJVR0ZTLCBhbmQgY2FsbCBtb2R1bGVfYWxsb2MoMk1C
KS4gQmVmb3JlIHRoZSBjaGFuZ2UsDQo+IC9zeXMva2VybmVsL2RlYnVnL3BhZ2VfdGFibGVzL2tl
cm5lbCBzaG93cyBwdGUgZm9yIHRoaXMgbWFwLiBXaXRoIHRoZQ0KPiBjaGFuZ2UsIC9zeXMva2Vy
bmVsL2RlYnVnL3BhZ2VfdGFibGVzLyBzaG93IHBtZCBmb3IgdGhpZSBtYXAuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPiAtLS0NCj4gIGFy
Y2gveDg2L0tjb25maWcgfCAxICsNCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKQ0K
DQpIaSwNCg0KSSBqdXN0IHNhdyB0aGlzIHVwc3RyZWFtIHRvZGF5LiBHbGFkIHRvIHNlZSB0aGlz
IGZ1bmN0aW9uYWxpdHksIGJ1dCBJDQp0aGluayB0dXJuaW5nIG9uIGh1Z2Ugdm1hbGxvYyBwYWdl
cyBmb3IgeDg2IG5lZWRzIGEgYml0IG1vcmUuIEnigJlsbA0KZGVzY3JpYmUgYSBjb3VwbGUgcG9z
c2libGUgZmFpbHVyZSBtb2RlcyBJIGhhdmVu4oCZdCBhY3R1YWxseSB0ZXN0ZWQuDQoNCk9uZSBw
cm9ibGVtIGlzIHRoYXQgdGhlIGRpcmVjdCBtYXAgcGVybWlzc2lvbiByZXNldCBwYXJ0IGluIHZt
YWxsb2MNCmFzc3VtZXMgYW55IHNwZWNpYWwgcGVybWlzc2lvbmVkIHBhZ2VzIGFyZSBtYXBwZWQg
NGsgb24gdGhlIGRpcmVjdCBtYXAuDQpPdGhlcndpc2UgdGhlIG9wZXJhdGlvbiBjb3VsZCBmYWls
IHRvIHJlc2V0IGEgcGFnZSBSVyBpZiBhIFBURSBwYWdlDQphbGxvY2F0aW9uIGZhaWxzIHdoZW4g
aXQgdHJpZXMgdG8gc3BsaXQgdGhlIHBhZ2UgdG8gdG9nZ2xlIGEgNGsgc2l6ZWQNCnJlZ2lvbiBO
UC9QLiBJZiB5b3UgYXJlIG5vdCBmYW1pbGlhciwgeDg2IENQQSBnZW5lcmFsbHkgbGVhdmVzIHRo
ZQ0KZGlyZWN0IG1hcCBwYWdlIHNpemVzIG1pcnJvcmluZyB0aGUgcHJpbWFyeSBhbGlhcyAodm1h
bGxvYykuIFNvIG9uY2UNCnZtYWxsb2MgaGFzIGh1Z2UgcGFnZXMsIHRoZSBzcGVjaWFsIHBlcm1p
c3Npb25lZCBkaXJlY3QgbWFwIGFsaWFzZXMNCndpbGwgaGF2ZSB0aGVtIHRvby4gVGhpcyBsaW1p
dGF0aW9uIG9mIEhBVkVfQVJDSF9IVUdFX1ZNQUxMT0MgaXMNCmFjdHVhbGx5IGhpbnRlZCBhYm91
dCBpbiB0aGUgS2NvbmZpZyBjb21tZW50cywgYnV0IEkgZ3Vlc3MgaXQgd2FzbuKAmXQNCnNwZWNp
ZmljIHRoYXQgeDg2IGhhcyB0aGVzZSBwcm9wZXJ0aWVzLg0KDQpJIHRoaW5rIHRvIG1ha2UgdGhl
IHZtYWxsb2MgcmVzZXR0aW5nIHBhcnQgc2FmZToNCjEuIHNldF9kaXJlY3RfbWFwX2ludmFsaWQv
ZGVmYXVsdCgpIG5lZWRzIHRvIHN1cHBvcnQgbXVsdGlwbGUgcGFnZXMNCmxpa2UgdGhpc1swXS4N
CjIuIHZtX3JlbW92ZV9tYXBwaW5ncygpIG5lZWRzIHRvIGNhbGwgdGhlbSB3aXRoIHRoZSBjb3Jy
ZWN0IHBhZ2Ugc2l6ZQ0KaW4gdGhlIGhwYWdlIGNhc2Ugc28gdGhleSBkb24ndCBjYXVzZSBhIHNw
bGl0WzFdLg0KMy4gVGhlbiBoaWJlcm5hdGUgbmVlZHMgdG8gYmUgYmxvY2tlZCBkdXJpbmcgdGhp
cyBvcGVyYXRpb24gc28gaXQNCmRvZXNu4oCZdCBlbmNvdW50ZXIgdGhlIG5vdyBzb21ldGltZXMg
aHVnZSBOUCBwYWdlcywgd2hpY2ggaXQgY2Fu4oCZdA0KaGFuZGxlLiBOb3Qgc3VyZSB3aGF0IHRo
ZSByaWdodCB3YXkgdG8gZG8gdGhpcyBpcywgYnV0IHBvdGVudGlhbGx5IGxpa2UNCmluIHRoZSBk
aWZmIGJlbG93WzFdLg0KDQpBbm90aGVyIHByb2JsZW0gaXMgdGhhdCBDUEEgd2lsbCBzb21ldGlt
ZXMgbm93IHNwbGl0IHBhZ2VzIG9mIHZtYWxsb2MNCm1hcHBpbmdzIGluIGNhc2VzIHdoZXJlIGl0
IHNldHMgYSByZWdpb24gb2YgYW4gYWxsb2NhdGlvbiB0byBhDQpkaWZmZXJlbnQgcGVybWlzc2lv
biB0aGFuIHRoZSByZXN0IChmb3IgZXhhbXBsZSByZWd1bGFyIG1vZHVsZXMgY2FsbGluZw0Kc2V0
X21lbW9yeV94KCkgb24gdGhlIHRleHQgc2VjdGlvbikuIEJlZm9yZSB0aGlzIGNoYW5nZSwgdGhl
c2UgY291bGRu4oCZdA0KZmFpbCBzaW5jZSB0aGUgbW9kdWxlIHNwYWNlIG1hcHBpbmcgd291bGQg
bmV2ZXIgcmVxdWlyZSBhIHNwbGl0Lg0KTW9kdWxlcyBkb2VzbuKAmXQgY2hlY2sgZm9yIGZhaWx1
cmUgdGhlcmUsIHNvIEnigJltIHRoaW5raW5nIG5vdyBpdCB3b3VsZA0KcHJvY2VlZCB0byB0cnkg
dG8gZXhlY3V0ZSBOWCBtZW1vcnkgaWYgdGhlIHNwbGl0IGZhaWxlZC4gSXQgY291bGQgb25seQ0K
aGFwcGVuIG9uIGFsbG9jYXRpb24gb2YgZXNwZWNpYWxseSBsYXJnZSBtb2R1bGVzLiBNYXliZSBp
dCBzaG91bGQganVzdA0KYmUgYXZvaWRlZCBmb3Igbm93IGJ5IGhhdmluZyByZWd1bGFyIG1vZHVs
ZSBhbGxvY2F0aW9ucyBwYXNzDQpWTV9OT19IVUdFX1ZNQVAgb24geDg2LiBBbmQgQlBGIGNvdWxk
IGNhbGwgX192bWFsbG9jX25vZGVfcmFuZ2UoKQ0KZGlyZWN0bHkgdG8gZ2V0IDJNQiB2bWFsbG9j
cy4NCg0KWzBdIA0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIxMDIwODA4NDkyMC4y
ODg0LTUtcnBwdEBrZXJuZWwub3JnLyN0DQoNClsxXSBVbnRlc3RlZCwgYnV0IHNvbWV0aGluZyBs
aWtlIHRoaXMgcG9zc2libHk6DQpkaWZmIC0tZ2l0IGEvbW0vdm1hbGxvYy5jIGIvbW0vdm1hbGxv
Yy5jDQppbmRleCA5OWUwZjNlOGQxYTUuLjk3YzRjYTNhMjliMSAxMDA2NDQNCi0tLSBhL21tL3Zt
YWxsb2MuYw0KKysrIGIvbW0vdm1hbGxvYy5jDQpAQCAtNDIsNiArNDIsNyBAQA0KICNpbmNsdWRl
IDxsaW51eC9zY2hlZC9tbS5oPg0KICNpbmNsdWRlIDxhc20vdGxiZmx1c2guaD4NCiAjaW5jbHVk
ZSA8YXNtL3NobXBhcmFtLmg+DQorI2luY2x1ZGUgPGxpbnV4L3N1c3BlbmQuaD4NCiANCiAjaW5j
bHVkZSAiaW50ZXJuYWwuaCINCiAjaW5jbHVkZSAicGdhbGxvYy10cmFjay5oIg0KQEAgLTIyNDEs
NyArMjI0Miw3IEBAIEVYUE9SVF9TWU1CT0wodm1fbWFwX3JhbSk7DQogDQogc3RhdGljIHN0cnVj
dCB2bV9zdHJ1Y3QgKnZtbGlzdCBfX2luaXRkYXRhOw0KIA0KLXN0YXRpYyBpbmxpbmUgdW5zaWdu
ZWQgaW50IHZtX2FyZWFfcGFnZV9vcmRlcihzdHJ1Y3Qgdm1fc3RydWN0ICp2bSkNCitzdGF0aWMg
aW5saW5lIHVuc2lnbmVkIGludCB2bV9hcmVhX3BhZ2Vfb3JkZXIoY29uc3Qgc3RydWN0IHZtX3N0
cnVjdA0KKnZtKQ0KIHsNCiAjaWZkZWYgQ09ORklHX0hBVkVfQVJDSF9IVUdFX1ZNQUxMT0MNCiAg
ICAgICAgcmV0dXJuIHZtLT5wYWdlX29yZGVyOw0KQEAgLTI1NjAsMTIgKzI1NjEsMTIgQEAgc3Ry
dWN0IHZtX3N0cnVjdCAqcmVtb3ZlX3ZtX2FyZWEoY29uc3Qgdm9pZA0KKmFkZHIpDQogc3RhdGlj
IGlubGluZSB2b2lkIHNldF9hcmVhX2RpcmVjdF9tYXAoY29uc3Qgc3RydWN0IHZtX3N0cnVjdCAq
YXJlYSwNCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCAoKnNldF9k
aXJlY3RfbWFwKShzdHJ1Y3QNCnBhZ2UgKnBhZ2UpKQ0KIHsNCisgICAgICAgdW5zaWduZWQgaW50
IHBhZ2Vfb3JkZXIgPSB2bV9hcmVhX3BhZ2Vfb3JkZXIoYXJlYSk7DQogICAgICAgIGludCBpOw0K
IA0KLSAgICAgICAvKiBIVUdFX1ZNQUxMT0MgcGFzc2VzIHNtYWxsIHBhZ2VzIHRvIHNldF9kaXJl
Y3RfbWFwICovDQotICAgICAgIGZvciAoaSA9IDA7IGkgPCBhcmVhLT5ucl9wYWdlczsgaSsrKQ0K
KyAgICAgICBmb3IgKGkgPSAwOyBpIDwgYXJlYS0+bnJfcGFnZXM7IGkgKz0gMVUgPDwgcGFnZV9v
cmRlcikNCiAgICAgICAgICAgICAgICBpZiAocGFnZV9hZGRyZXNzKGFyZWEtPnBhZ2VzW2ldKSkN
Ci0gICAgICAgICAgICAgICAgICAgICAgIHNldF9kaXJlY3RfbWFwKGFyZWEtPnBhZ2VzW2ldKTsN
CisgICAgICAgICAgICAgICAgICAgICAgIHNldF9kaXJlY3RfbWFwKGFyZWEtPnBhZ2VzW2ldLCAx
VSA8PA0KcGFnZV9vcmRlcik7DQogfQ0KIA0KIC8qIEhhbmRsZSByZW1vdmluZyBhbmQgcmVzZXR0
aW5nIHZtIG1hcHBpbmdzIHJlbGF0ZWQgdG8gdGhlIHZtX3N0cnVjdC4NCiovDQpAQCAtMjU5Miw2
ICsyNTkzLDEwIEBAIHN0YXRpYyB2b2lkIHZtX3JlbW92ZV9tYXBwaW5ncyhzdHJ1Y3Qgdm1fc3Ry
dWN0DQoqYXJlYSwgaW50IGRlYWxsb2NhdGVfcGFnZXMpDQogICAgICAgICAgICAgICAgcmV0dXJu
Ow0KICAgICAgICB9DQogDQorICAgICAgIC8qIEhpYmVybmF0ZSBjYW4ndCBoYW5kbGUgbGFyZ2Ug
TlAgcGFnZXMgKi8NCisgICAgICAgaWYgKHBhZ2Vfb3JkZXIpDQorICAgICAgICAgICAgICAgbG9j
a19zeXN0ZW1fc2xlZXAoKTsNCisNCiAgICAgICAgLyoNCiAgICAgICAgICogSWYgZXhlY3V0aW9u
IGdldHMgaGVyZSwgZmx1c2ggdGhlIHZtIG1hcHBpbmcgYW5kIHJlc2V0IHRoZQ0KZGlyZWN0DQog
ICAgICAgICAqIG1hcC4gRmluZCB0aGUgc3RhcnQgYW5kIGVuZCByYW5nZSBvZiB0aGUgZGlyZWN0
IG1hcHBpbmdzIHRvDQptYWtlIHN1cmUNCkBAIC0yNjE3LDYgKzI2MjIsOSBAQCBzdGF0aWMgdm9p
ZCB2bV9yZW1vdmVfbWFwcGluZ3Moc3RydWN0IHZtX3N0cnVjdA0KKmFyZWEsIGludCBkZWFsbG9j
YXRlX3BhZ2VzKQ0KICAgICAgICBzZXRfYXJlYV9kaXJlY3RfbWFwKGFyZWEsIHNldF9kaXJlY3Rf
bWFwX2ludmFsaWRfbm9mbHVzaCk7DQogICAgICAgIF92bV91bm1hcF9hbGlhc2VzKHN0YXJ0LCBl
bmQsIGZsdXNoX2RtYXApOw0KICAgICAgICBzZXRfYXJlYV9kaXJlY3RfbWFwKGFyZWEsIHNldF9k
aXJlY3RfbWFwX2RlZmF1bHRfbm9mbHVzaCk7DQorDQorICAgICAgIGlmIChwYWdlX29yZGVyKQ0K
KyAgICAgICAgICAgICAgIHVubG9ja19zeXN0ZW1fc2xlZXAoKTsNCiB9DQogDQogc3RhdGljIHZv
aWQgX192dW5tYXAoY29uc3Qgdm9pZCAqYWRkciwgaW50IGRlYWxsb2NhdGVfcGFnZXMpDQo=
