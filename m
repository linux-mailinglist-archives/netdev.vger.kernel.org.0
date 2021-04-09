Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B66E35A73B
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 21:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhDITjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 15:39:37 -0400
Received: from mga05.intel.com ([192.55.52.43]:33035 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhDITjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 15:39:36 -0400
IronPort-SDR: XFNbLbf5vK7m1jRBwtcnYZzUgCb/WvyszcHCEtzS8By1lcb68O5VuRjdQQfhIj4NJmyB7WDxMR
 TrJLkMu2kWDw==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="279104843"
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="279104843"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 12:39:22 -0700
IronPort-SDR: QE7OHSyJIM0N4+vOx+cwXDA0R6slLTIttg20L16Fwu1QDdcH/zLd7o79S8M5/bP9b90SIJAzDV
 PupKuGLixLPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,210,1613462400"; 
   d="scan'208";a="422860969"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 09 Apr 2021 12:39:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 12:39:22 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 9 Apr 2021 12:39:21 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 9 Apr 2021 12:39:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 9 Apr 2021 12:39:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=au47fqjVhz7XE2JFHUbHrRD52BUKoctxVOg+s132iSLOLwWETqms13aSpfbFh/6jJMK16cjc1TA8Hc/AuT2UnhWuFHwk5aQGJJiIJFumq5kKZnpqJjv3wQ+JeRWw+DBZpDsx7KHfOncw00wf3Ok4ZqhKIDeiQfEi/omGr1UnRzXgSFoG3plLgls95E5LUaJUGT9mQY9XYY8Ag6fi6DTdGng7HCQyBh4qTj0HZFBNzh/it5/KPNerJ6xO22WFHJGcfY9jhphlsA0duo2KjsgrnxnXY50mfhQx4ZvKbKXAgWtKnYeW25/fYy5WIOe2u4XDxEgbRrq5VL4Tyj8Q4IzLpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBxBqtwphiaKBeL8gwNhfNBzz/BokpTjv8RwFW01U5g=;
 b=nnD8cvvhGlflw/KBsxyyFM/uyc7aQbytI0huYedJi1j0B+5gpkzBTP39siGQlRuO+VRieG3D3A07M07Po+ohY60LfJfDlwO9sdkx6fGSFQ2LlOtVBJNbh7RL9B9LYQGKjbW4e0ulG8hjzOT9LcB5WKjkaBDajDIPN8sqSRTEZ/RU/AaCfT/AnobTFAhRBuk+yyrSEsBDzUocHD+6NC1CZ/8uTFhUnitOob5ISr7nySMvq/AILuf4rQVVLIlqJ2AQ68Jhgq735mLYeq3tirYu/Mka8NcLYXu22/QdmceMM4Ex7TaPKnL2G1LhocKP6hoPpJ9yMH/b3WMyiGfkAXW0aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JBxBqtwphiaKBeL8gwNhfNBzz/BokpTjv8RwFW01U5g=;
 b=UUb+A+973hdkXi5RHW/8Ervv59xBf9g84Rkd6wBkwtajTpkM9km+8eCTEJYs1qWZDQ5mede3OMu0tHIf+gYKp/tJmOdANi3Lj3HsTtBnBF2NY7vD3bD4m1EI7EA/vZX5b+wiKKrakDJ7UTUUdeePnNmUy/5fOnS6p6E+FhBaS2U=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by CO1PR11MB5026.namprd11.prod.outlook.com (2603:10b6:303:9c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 19:39:20 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212%5]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 19:39:20 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net PATCH] ixgbe: Fix NULL pointer dereference in ethtool
 loopback test
Thread-Topic: [net PATCH] ixgbe: Fix NULL pointer dereference in ethtool
 loopback test
Thread-Index: AQHXFFuC4etCb6gAeUaB/gftV7Pl+KqsxzzA
Date:   Fri, 9 Apr 2021 19:39:20 +0000
Message-ID: <MW3PR11MB4748FAECF13CAF958B57A9B5EB739@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <161523611656.36376.3641992659589167121.stgit@localhost.localdomain>
In-Reply-To: <161523611656.36376.3641992659589167121.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.40.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6abb5374-30ba-4334-ad90-08d8fb8f2bde
x-ms-traffictypediagnostic: CO1PR11MB5026:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB50266055751EB10B4740A643EB739@CO1PR11MB5026.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4yIomQLOw5T/lWxxRONvJjGNXM01kPwtcuShtCAo6GZAUtGV3MFFkrYqIiwJKcdCbcIHyjG60g3g/WmUJmRR+JsPcRGAxhwv+Gy4QJ2FiWLtk5/Z6/Maxgv8iZDS6rT7XpvHIndZ1YfXxM7IOodNonOUIQYgHCPfgI4e2oz5kbaWrimJ24iPJ83Q0GOpM5IaI2CVr70zcM4U8CkroJV4OsEXDnAHCDBRQhMIVCu+2nEfvJbTCJFr/iUKGDBo0wZewkOpav/Vds8979o2ZLLObLgG4mER/+rOgk8c0dI12F7xXOrxLHFP24ID3bltKy/guqAmFUPL+18fA4Kvolb8yq+/bNBsKuhju6i0MOV9RX8baISrMhqV6iGx2bxQHhHNzBNTrMjdh78LR8YKYjPxns7H0nyNKHpK8dpT3gOAwSBqWF6KBhn2T+qLO9K8xl4nRmblox88v5ptd5GiI0Q3mTIVhw6YIjZK0dl14W81Ti304c6f9hXqwhmlyaNWMPj42SjTr90d3jfe65PVI2Meef3Ofqs/peYTFSH26bx1+sas08OJqAV0NBWZdHCsieYYXYfqUYHf3ojd6PBvWHSvpEt36kBXmsp9XI2rmLxrpLQXyn55xfuihbdVjQtuKhSWwBOjXNo5XPfu6piC5+3e4cNbYwULUxtykn7TIs9AVrA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(376002)(346002)(186003)(478600001)(86362001)(8676002)(110136005)(8936002)(4326008)(316002)(26005)(7696005)(64756008)(83380400001)(66946007)(6506007)(54906003)(4744005)(52536014)(9686003)(2906002)(5660300002)(33656002)(66556008)(38100700001)(66476007)(76116006)(66446008)(55016002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VGFvVWZNTjIyQnRwOTVYL3ZiUXp3RzFkUmcrcm9wTE43Z0grUWxkNm0vazk0?=
 =?utf-8?B?aW8xTzlSMUVZcGJmSnVWejBsL1J2TFVUR3MrOG54U0hNamYxaW9pUUJ1VFBu?=
 =?utf-8?B?S2R5Q3hkZndyNlh1YUtGMHp3MWN3UzArMFdqVkZIVmVtVVV4aEwvTHhXeWg3?=
 =?utf-8?B?SW13SlVRaEFqODFITW9tNm04My9NakhvSmlEUVhza0hqR1lENWN6aGs4bVJp?=
 =?utf-8?B?bit2eko4dHZBNlFyK3dKTnBWdjlrcWEzRnR4b1hGSFNPQWd1dk1Sb3g4UldH?=
 =?utf-8?B?b3FGSFZlWGxyNmw0MHQyR0VrOVc2a1NYa3JWQlY2YjBPYmhJdmM2blpFYStM?=
 =?utf-8?B?cGZXbXRBdUVvQy9YNDZjMm5FeFRuTTVrN3Zoa2pnTHhYM3pNcVp0MVlzNHBW?=
 =?utf-8?B?ZkRtdnVsNmVVUTZOdEhENEI3SmNMWTVONFptQmZ4UlNSYms2aVBjSXUvVVF2?=
 =?utf-8?B?c0x3SFkwNVpwaXI2d0YzamsxRi8zSm9zZGU1TTdhcnk4M1dnZ29YOHg5WDQz?=
 =?utf-8?B?SkE2Znh0UXBBZWIrQm9yK2J0cjA1eW1XL1Y2eE4vZ1hmZTdpdUkzQWxXWVBq?=
 =?utf-8?B?K2pncnB1TXhwV2RRU1hVTTVEdTBVUVIwbWRySlhPdFZIRkQxWGw1ajQ2N3Jr?=
 =?utf-8?B?YUc4eHhlVGlCdDFBQWNISkYxU3J4NEYvMHhrS1dXNFU2Mk9YSkdDaFZCeE9n?=
 =?utf-8?B?Ykg0dFlSNENnYUsyZFJPZ3h6KzIyaXFrdEsyRWNJSHJFZEtRZHNpOC9QS0c2?=
 =?utf-8?B?d2EzaXFueUg4RHhoUk1meHRMS1l3UHJaV0YxUFg1SXIyN1dzeCtYcnFBV05H?=
 =?utf-8?B?cWFnekpjM015L1R6V2owRTIyd21UZTBnZjhUUEovb1BBa3ZIM3RCSmNCUlBz?=
 =?utf-8?B?QlhEemhkcmpvZlFYMmZRREtIdmJhcHloaHU5NU91SXJZeVhBTjJqcjlXZFFa?=
 =?utf-8?B?MWN3bU9lS09nR3o3Mmpzai9USE5qTDI1M2V4YXVJeldxbzVrUGNkMUxscnln?=
 =?utf-8?B?MzZMVkhYK1RVNGFiNnhjMVpYdVUycUk0RnpMR0ZSbHU3YUdlTTFOb01qcE5Y?=
 =?utf-8?B?c0pYdHViY1NYL3k5YlgvZ3hBbzVrM3pzcmppc0tNbUoyWXB3aS82QWs1Tmkr?=
 =?utf-8?B?WWZJWFR1YkRYaUd2QzhxUkoweGFEM1NqYmFLNitsVnNHeHVQMDc0VWt4UEdh?=
 =?utf-8?B?RVR2U09icjJYK0pMcktjMDh6Smh3Z3FSUGczSlVIQ0M1dG82cUd5bEVocDRQ?=
 =?utf-8?B?ZzkwUzhBVzdrZ0VBVWhmeXZ3SmV0cjk1VHdsYlAyZ09zcU42L1dKUHBobTZv?=
 =?utf-8?B?YnNXWTM3Umd2K083ckd4NjV4VHpxNHcxRm8yTjJMSzIzd3VEeHZIYjNlOXRh?=
 =?utf-8?B?dFZRTnJtSlBwYVNzc00waHlGT1QwajhTQWRSampONjlpdWxlbnkzR3A0V3lI?=
 =?utf-8?B?MG1sWHdRN005aW5CUnE3M0txYVFNRTJjME9nZ3l3TSt5TnNVS1o3RFI2K2JP?=
 =?utf-8?B?dHEvYUdCWjMyNkEwQm1DWGJkVEtSbndLZHlUL0VGRTZ0aVI2enZJSm9sVi8r?=
 =?utf-8?B?WmZjWUdkS0YxVHphV0d6MWxpYXVaSjgzZE03eEp6SXhZSDFmNXdxUUhnYVll?=
 =?utf-8?B?U3RWUjVKaEFGdGtVWGo3d0N0UmJrUlJFSHFDWmh2WXRvbnZCVGMrZFErMWxB?=
 =?utf-8?B?UEs5VWY0YWtVRmVmcGdvVml0L0NkSEFYTDdpSEVuR1BrU1k0YTl1U25pUm9h?=
 =?utf-8?Q?brQA1La4IK0xp/2i5I=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abb5374-30ba-4334-ad90-08d8fb8f2bde
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 19:39:20.7057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EFhhFQkrbY3M7w0ygc4MzFko/T9EGE2zQdvonibwL9sLkqFTFsKpsYDarKL7NiQtAENCL41GTaIDFxuId+SeMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5026
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlci5kdXlja0BnbWFpbC5jb20+DQo+U2VudDogTW9uZGF5LCBNYXJjaCA4LCAyMDIxIDEy
OjQyIFBNDQo+VG86IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnDQo+Q2M6IEJyYW5k
ZWJ1cmcsIEplc3NlIDxqZXNzZS5icmFuZGVidXJnQGludGVsLmNvbT47IE5ndXllbiwgQW50aG9u
eSBMDQo+PGFudGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
Zw0KPlN1YmplY3Q6IFtuZXQgUEFUQ0hdIGl4Z2JlOiBGaXggTlVMTCBwb2ludGVyIGRlcmVmZXJl
bmNlIGluIGV0aHRvb2wgbG9vcGJhY2sgdGVzdA0KPg0KPkZyb206IEFsZXhhbmRlciBEdXljayA8
YWxleGFuZGVyZHV5Y2tAZmIuY29tPg0KPg0KPlRoZSBpeGdiZSBkcml2ZXIgY3VycmVudGx5IGdl
bmVyYXRlcyBhIE5VTEwgcG9pbnRlciBkZXJlZmVyZW5jZSB3aGVuDQo+cGVyZm9ybWluZyB0aGUg
ZXRodG9vbCBsb29wYmFjayB0ZXN0LiBUaGlzIGlzIGR1ZSB0byB0aGUgZmFjdCB0aGF0IHRoZXJl
IGlzbid0IGENCj5xX3ZlY3RvciBhc3NvY2lhdGVkIHdpdGggdGhlIHRlc3QgcmluZyB3aGVuIGl0
IGlzIHNldHVwIGFzIGludGVycnVwdHMgYXJlIG5vdA0KPm5vcm1hbGx5IGFkZGVkIHRvIHRoZSB0
ZXN0IHJpbmdzLg0KPg0KPlRvIGFkZHJlc3MgdGhpcyBJIGhhdmUgYWRkZWQgY29kZSB0aGF0IHdp
bGwgY2hlY2sgZm9yIGEgcV92ZWN0b3IgYmVmb3JlIHJldHVybmluZw0KPmEgbmFwaV9pZCB2YWx1
ZS4gSWYgYSBxX3ZlY3RvciBpcyBub3QgcHJlc2VudCBpdCB3aWxsIHJldHVybiBhIHZhbHVlIG9m
IDAuDQo+DQo+Rml4ZXM6IGIwMmU1YTBlYmIxNyAoInhzazogUHJvcGFnYXRlIG5hcGlfaWQgdG8g
WERQIHNvY2tldCBSeCBwYXRoIikNCj5TaWduZWQtb2ZmLWJ5OiBBbGV4YW5kZXIgRHV5Y2sgPGFs
ZXhhbmRlcmR1eWNrQGZiLmNvbT4NCj4tLS0NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwv
aXhnYmUvaXhnYmVfbWFpbi5jIHwgICAgOSArKysrKysrKy0NCj4gMSBmaWxlIGNoYW5nZWQsIDgg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPg0KVGVzdGVkLWJ5OiBEYXZlIFN3aXR6ZXIg
PGRhdmlkLnN3aXR6ZXJAaW50ZWwuY29tPg0KDQo=
