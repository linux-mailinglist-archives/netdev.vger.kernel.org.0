Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B50C4DC471
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 12:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbiCQLIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 07:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiCQLIR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 07:08:17 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C291D7D9E;
        Thu, 17 Mar 2022 04:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647515221; x=1679051221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1MLk0nGN5yRG+EPQEQB+T1pUQpNRL4odves+GjpHiv4=;
  b=aO38hJXKhaG9mLI7MXFnW5o8RMqovZL8zRJ3dADBAWzsEezNMrvCtS1f
   /yfHxX36E3vv790axFKScgEqn0oFZZXWbikUNbtqD8GWvJARcNXKwJBjN
   l0RzAQOnNT8d7O1se8lX4/+JWWWq3zNVIUg61mxFLyXU/koZrGsvgNufH
   n990WAEWSvYiJSH20tusK/8SXpxtxpXGi+HJruSr8Rud3xW6FEj1fGSwk
   aIStTxMbNXO9K7CkI2K4tkHC0v44YDXUCUmZgjKJbnpn9DhcxdaS7TiCf
   AHoiYUjQwoKTV9NLZwYHeESDoyLUVMbUpd1HvNH7kpH0F39V8yl/NJlxJ
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="256790109"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="256790109"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 04:07:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="613964486"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 17 Mar 2022 04:07:00 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 04:07:00 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Thu, 17 Mar 2022 04:07:00 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Thu, 17 Mar 2022 04:07:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WESA2iuDc2NxeGJrFbFONJ2k9224fCoKJKpuI6OOShIj08/EVJcE1NwyaS3myl1uxVUsPc5DS+oU8SkOkyOOj2UAIJjBKlNzFKLPLWprXmMx0Ks2KBKqXqwasedlHa51q0yoLubm6uPkpcy9P2Dqa4KvwQrSRO2ArDN9WIgFLtRL+rhrzevpvbs6D9zLs0Uh/duFceUF/uLbvm1275ij1wRMeBswqdPhxdTkXE3MfOtXU9LSzZeHC4VPR2Q5E9oGjOw3Rnr8iKVlij+Gh99LssutcIuqnSankYB3Al9DPT3aYLkxP1BS3IN5B36rLaEpTsMcdjdlTlk+8TzKIV0w3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MLk0nGN5yRG+EPQEQB+T1pUQpNRL4odves+GjpHiv4=;
 b=dsY2Fsr0qtK7NhQF4U6lOx0UuGCWbn59Ifgr8/fohhyVhu0w3qfONT0WJtqxVinxvYdzO652LgU6T2jAn7FCJ8HCF9tKPp2JW2y8ZxgbDlv3SH4yJpA/am61gSrr3ocFjooldiABosah518pbueL7VMWSAS67lUfAuTe88YAt19rtQwOQGtuWzaCWVGol/wvGX9WeIHqjH9ldNvk7ygDcbGIaFgeqG9Wb0Mv1SkGegGKWFtILSP+xpXkeUmHUzW+Xakl7i6XhwQXSg1SfTcqJ+1Btg0ZGp6awy5lBoJWBSb5SX8K5ZkoOlE4YGchjITOgkvkZFkAhH5T03UMFirJhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by PH0PR11MB5189.namprd11.prod.outlook.com (2603:10b6:510:3d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 11:06:58 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::a428:75b3:6530:4167%7]) with mapi id 15.20.5081.015; Thu, 17 Mar 2022
 11:06:58 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "arnd@kernel.org" <arnd@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Beker, Ayala" <ayala.beker@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: mei: fix building iwlmei
Thread-Topic: [PATCH] iwlwifi: mei: fix building iwlmei
Thread-Index: AQHYOWTHPLmml5yFXU6hM90mCcYWnqzCXBOAgAEPX4A=
Date:   Thu, 17 Mar 2022 11:06:58 +0000
Message-ID: <3554c5cb403df472eca607e036a1f48a7699d490.camel@intel.com>
References: <20220316183617.1470631-1-arnd@kernel.org>
         <SA1PR11MB5825D9DDC4F622A9B8FA77B9F2119@SA1PR11MB5825.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB5825D9DDC4F622A9B8FA77B9F2119@SA1PR11MB5825.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.43.3-1+b1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10808e6d-066d-4c17-4aeb-08da0806417e
x-ms-traffictypediagnostic: PH0PR11MB5189:EE_
x-microsoft-antispam-prvs: <PH0PR11MB5189B3D30BEAAEA2630E7C8C90129@PH0PR11MB5189.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GIxulMXdKCzgY+KbB6OuPiHxIyHk2dKLycPzT7In6tiIRExdZZxmyTqYKsDhARuWHTGXrIxlZblsMGlzj5Vx+CgaTD2h9QKtE4ZCUy2ZHthWgJbPwOw4KGohw+4bdynCzr+/cisdb2jl9Cbc/uJHkYueBrklnUAR7h2x/D2hVTlewf8vecT1x9RBHFuZI8xjHPv/Tnq63tueYj3BcoxVvVCNzC8DjFea9TdkJEMkUUEdqdJHpmZpIKew83RLPnqjnhurFlFln3y2hIr/a5S8BNHp2NjV//YXiT4MbAebXKiBQjpApc53IU+WStRpwlJmH1K3O/gJYclHQ1zZaCY/I6giUDm+a6ZqxZGSMKGFJZVOBnWOPRxz+Zp1uNmNjxujPWFkXWONsSBD7MlyH/GOxHdL5ous9GLcgRx5JrAQiQwN/DW173sT5KFF6fsmN+yhxcKKYr7SWQ7Fh1g/rPVZk+2/W1McL36Bmk5kx1N8+SMgMLAjDTLLx0ZJ/RC9sPsNW3z8Q3ZeFikHjHRPA9wZdFUhvDjuumnFgwBJHb6JpWTe0BxDgzPJre/kOmGt/UjgHMS1JCRkQ4Vlt/dHDcDFYt/inrOfTCsA/42ZF0zpjmPGLEBXDIommi4HU/OBgg4zj2XDG0hWj/jP+V842z7ycHGzNnf4uFHsx70I1MGzgNzY/2j2Ps6EvcnNjTVn6ND2m52wbS7bpJibwrK2Bjjnvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(83380400001)(186003)(26005)(38100700002)(82960400001)(122000001)(8936002)(5660300002)(66946007)(66556008)(66476007)(8676002)(64756008)(66446008)(4326008)(2906002)(76116006)(508600001)(6506007)(2616005)(6512007)(316002)(91956017)(54906003)(71200400001)(6486002)(110136005)(36756003)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WFdneFMwaXFyT3pOdXFUTEN4Q01CbzZqcXRBV1ZGQU1nZXVpNitndFZKc2tj?=
 =?utf-8?B?RUlmZ2ZKWEtIR0VhTGp1RjIrSEtBWCtrRmVsUk94N2dJVlV0STU4cFEwK2lB?=
 =?utf-8?B?RjZwb1pRakUyejlhM1hTSExoRUJvOElUMEVvejl6RTc4SmVxbE5LQXhIVFdv?=
 =?utf-8?B?V3hPK1lVeTFYZXRTZmZPZUFoNTVmWUdYdkk3NjZUZi92R0gxeFNaQTllMyt4?=
 =?utf-8?B?MFgwZGVxTVZmdkQzcmp1b2xieEZBaXVZNHZPZ2JWWWczNitMTythdWtrRHJC?=
 =?utf-8?B?TG13eEVrYjQ0TmlJMFZreU9HQkhhMlJVbGx6Y2lDVjNTb2FIbEdidmdRQllz?=
 =?utf-8?B?VnAwLzFqSG9CRFJSL3pJSmFPNk9CaTcrSmtvUUFHeDhoeXc1eXJVZWgyd25B?=
 =?utf-8?B?cFlrcHFpWUZKMkxodEQ0Nm9od2J3NU51MEM5OTMxSjJkQzRJRXBDNWZFbEFJ?=
 =?utf-8?B?aEx0Z3JIbE5kZWNzVUtjQzh6VldSdTNHTXZIOGVRR3pZQXREQk9ZRUxiM1dV?=
 =?utf-8?B?NHl4OWl2VGRML0x0SDdhc0grbmpOd1h5VjBBNDBjcE0vZElwaHhoNWRhcGhp?=
 =?utf-8?B?WE1WbnVtNjUwRkFDazRVRnRBWDFHUlNHR1lOYVBSUTJyYTNzdnNzVGxLWStC?=
 =?utf-8?B?ZE9vZjdFMnhoU3NwaDhGOHU2VC9nSjQxektUYzNJSXNsRDgrS2lvcG1RR2sx?=
 =?utf-8?B?cjdpVm80WHo1bUlOd3BJVjJsSDlJajJ2UGljaXhaM3E5eVM1MVU4UTVEUFJT?=
 =?utf-8?B?dXMvcG9GaERRMm9ERHJ1OXNSMkZMZmMvSnYxMXEzVmllNGVDTTRQN0xvRjRi?=
 =?utf-8?B?ak5jOXJycWVmZWRLaHVnbUkwdkR2Q0w0elF4K1ZMVjJpM25PejFZcXdrV1VO?=
 =?utf-8?B?ZVV5Zmc0cmVzbHB2OFVQOVUvcGNsMEVaM1JHYXVLenNsNTArSkt5R3FGRStD?=
 =?utf-8?B?NzZEK1BTcHVUWWxBUk1odEtaNmIxLzBEd1kwaE5JejMxczF3WTh3R2U3RGhi?=
 =?utf-8?B?dldLQjZXdEtNYytaZGc1akcwVjJTeU9oeVhjZ1BUamxhZUcydlUxOEhzNmpX?=
 =?utf-8?B?czl4OUhGTHIwOGlLK2sza3UraHRMOFdSTTllNXhjZnBSRk1RdnRKT3FmWDgv?=
 =?utf-8?B?QXNmY2JjYi82SkRoS0x0R0ZnRnZub0dFMjNQWXZZNEJhbUxTNDBNWE5WRDlV?=
 =?utf-8?B?TXZ0QWdtMUlqSHNQajl0bFZZTG1RTUtFYXdmVkJSdUIwUFZWQ2F4ZFN1VXFh?=
 =?utf-8?B?eWgzYUNISTdUWHU4YkRmZWN2RVRQRENEUkVyNTZRa3p3WmM5akZLS3BSeUF5?=
 =?utf-8?B?bkZrS3BzNW1SSUFRZUJ4dGNLdHYwM1J5ZHJGSkFnQ3NPQjNUY3c5aDdyUjJx?=
 =?utf-8?B?QzhOZERxUFVvaUtreTJkUVE4UVhEUmwxdkZoY2xxSFhhbHRJdENYNWxkOGNm?=
 =?utf-8?B?K29lM2VJUFI2c0w4Mzc2Vms4bWYrMmRRRVZDSWZYTzBJdXR0OGdObzR1bDZ6?=
 =?utf-8?B?UTRVUCt5bWhkQldiT25ISithWDRBQUtrdVEyTHBhSXpjRitjZ0ladm1ZWlVB?=
 =?utf-8?B?NnlFZ3VoN0FBRTAvVXQ4R0NFVC9jcW8vZzhGSDR3MVpGc2ZST2hqMERRVnVs?=
 =?utf-8?B?RWRuU3hrSERsOXZDMXMrLzBLWWlmWEZ4YzBoZUdLSkNNUWxiYUlWT0JJTmxU?=
 =?utf-8?B?NXYxQTE5YnNCTXdaUjFXRUk5ZEtNNmlzc3ZyNXN6YmZUZzRSMTJnancwZ2g0?=
 =?utf-8?B?MTNPb3FBeHRaYmhnK1J4TnZJb1NFOE4zSWx1YzFIam5HTkpaa2w1WGI3N0xw?=
 =?utf-8?B?OW5aSFlGdzl6Y2xOdDNFUnRXSnhmb0VZNXUzOGE0SGd1Smp1dkwwTXRHU3lJ?=
 =?utf-8?B?cWRobEFoSWxPTTZLbXFFSERpMnRVYzJXejZvMmNrcE54bnNXZXZKY3pPQkx3?=
 =?utf-8?B?UURzUFNyVEd1aldzNWVieHlkUzE5Qlk4ejY5R2ZueUxmdFEweCtxclZIN3Jv?=
 =?utf-8?B?WXZJYXRWMllBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB5933034B3CD541BA9F97511A09EAD7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10808e6d-066d-4c17-4aeb-08da0806417e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2022 11:06:58.7030
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NbZTHcW0bo4vMls2iyrHngRC45k+C+wdS4iYVaM8LVMuynk4X0R5iB1hK/UjBi6k7vFq950VOvrrylpuJL4VkCDMjEGVG6ljEKZmDZP5Des=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5189
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAzLTE2IGF0IDE4OjU1ICswMDAwLCBHcnVtYmFjaCwgRW1tYW51ZWwgd3Jv
dGU6DQo+ID4gDQo+ID4gRnJvbTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5kYi5kZT4NCj4gPiAN
Cj4gPiBCdWlsZGluZyBpd2xtZWkgd2l0aG91dCBDT05GSUdfQ0ZHODAyMTEgY2F1c2VzIGEgbGlu
ay10aW1lIHdhcm5pbmc6DQo+ID4gDQo+ID4gbGQubGxkOiBlcnJvcjogdW5kZWZpbmVkIHN5bWJv
bDogaWVlZTgwMjExX2hkcmxlbg0KPiA+ID4gPiA+IHJlZmVyZW5jZWQgYnkgbmV0LmMNCj4gPiA+
ID4gPiANCj4gPiA+ID4gPiBuZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9tZWkvbmV0Lm86KGl3
bF9tZWlfdHhfY29weV90b19jc21lDQo+ID4gPiA+ID4gKSBpbg0KPiA+ID4gPiA+IGFyY2hpdmUg
ZHJpdmVycy9idWlsdC1pbi5hDQo+ID4gDQo+ID4gQWRkIGFuIGV4cGxpY2l0IGRlcGVuZGVuY3kg
dG8gYXZvaWQgdGhpcy4gSW4gdGhlb3J5IGl0IHNob3VsZCBub3QNCj4gPiBiZSBuZWVkZWQNCj4g
PiBoZXJlLCBidXQgaXQgYWxzbyBzZWVtcyBwb2ludGxlc3MgdG8gYWxsb3cgSVdMTUVJIGZvcg0K
PiA+IGNvbmZpZ3VyYXRpb25zIHdpdGhvdXQNCj4gPiBDRkc4MDIxMS4NCj4gPiANCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiA+IC0tLQ0KPiA+IMKg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9LY29uZmlnIHwgMSArDQo+ID4gwqAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gPiANCj4gPiBJIHNlZSB0aGlzIHdhcm5p
bmcgb24gNS4xNy1yYzgsIGJ1dCBkaWQgbm90IHRlc3QgaXQgb24gbGludXgtbmV4dCwNCj4gPiB3
aGljaCBtYXkNCj4gPiBhbHJlYWR5IGhhdmUgYSBmaXguDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvS2NvbmZpZw0KPiA+IGIvZHJpdmVy
cy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9LY29uZmlnDQo+ID4gaW5kZXggODVlNzA0Mjgz
NzU1Li5hNjQ3YTQwNmI4N2IgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aW50ZWwvaXdsd2lmaS9LY29uZmlnDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9LY29uZmlnDQo+ID4gQEAgLTEzOSw2ICsxMzksNyBAQCBjb25maWcgSVdMTUVJ
DQo+ID4gwqAJdHJpc3RhdGUgIkludGVsIE1hbmFnZW1lbnQgRW5naW5lIGNvbW11bmljYXRpb24g
b3ZlciBXTEFOIg0KPiA+IMKgCWRlcGVuZHMgb24gSU5URUxfTUVJDQo+ID4gwqAJZGVwZW5kcyBv
biBQTQ0KPiA+ICsJZGVwZW5kcyBvbiBDRkc4MDIxMQ0KPiA+IMKgCWhlbHANCj4gPiDCoAkgIEVu
YWJsZXMgdGhlIGl3bG1laSBrZXJuZWwgbW9kdWxlLg0KPiA+IA0KPiANCj4gRldJVzogTHVjYSBq
dXN0IG1lcmdlZCB0aGUgZXhhY3Qgc2FtZSBwYXRjaCBpbnRlcm5hbGx5LiBTbw0KPiBBY2tlZC1i
eTogRW1tYW51ZWwgR3J1bWJhY2ggPEVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4NCg0KWWVh
aCwgcGxlYXNlIHRha2UgdGhpcy4NCg0KQWNrZWQtYnk6IEx1Y2EgQ29lbGhvIDxsdWNpYW5vLmNv
ZWxob0BpbnRlbC5jb20+DQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
