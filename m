Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0450F42DE8C
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 17:45:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhJNPrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 11:47:43 -0400
Received: from mga07.intel.com ([134.134.136.100]:9145 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229637AbhJNPrm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 11:47:42 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10137"; a="291190669"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="291190669"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 08:45:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="571432042"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 14 Oct 2021 08:45:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 08:45:23 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 08:45:23 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 08:18:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz4nC6V0+Jh3zVdKBJDIDU64/JvHjl4GR/bIrjKDc80rJs4xRyuOmQFWSBFKrcbcGK6PBP+lYzZu6V3zCCiJSD7AvTzrM1xBXSIAiMMRwzrJnBJ7bQ7ABVO1CHYy1ouZqT3YczXJJLwNxnpMr+6RgF21g30+/XqYmobflq/XUDOiw+rmiS+GzNaWaK4EGiLXTzPOnEjwfpuOD/GZophkgoPwCuVvTfDRPln59zrlvRTZUOmYXMJXRn0oR4NHPeq9/QE/aWjw2L+8cPW5amd0WUX90VWl6MGx0LGc1RdcFcZqyJ5FTx2O6nXN5k2Dv1HxAfE6wpPRwp6imvY6zi1TLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HFiHt2fl7rxXX6vp2P3xnZW3clXY8GhR7mzzYsfM0gE=;
 b=hqvVvqvCjwymkuoEnUtHO248vhx1LeolCdAQ8jhxJEc1BkvnjSWjFWO+cbXy/NBHSobJaoh6ZKOSdG+e3iTAAo/4trwqrI5JQaKGmpFyDjW1Xc1UVj81AQ4/MexmI9/uOgmk94YDxTXIn1EtwdAaQ2S3SV4VYLoRg0Nm+L7w0y/UPg3JXKCEAPq8Ii4LTKhkRUD8uRju9Srgv47/rTjTM7vR8Al2UiNvdK/PfGAs0fdl4UdT5zDDM+qv+kmYh8ANbZ82TqrcFaPESK65bbm4KczmDo4RetJNZ5fUxque5pgDspZAdg7sr/Q2sQ5ZysXDXCAOpx0KTe/cCEQWnfClmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HFiHt2fl7rxXX6vp2P3xnZW3clXY8GhR7mzzYsfM0gE=;
 b=m/xfBXHJpWlv9xDqi2bawg6r2RHcT3vbgMQBgMAkdyQdFdzg/HERRGlWN/Epfzi+k0xGaaRqjmLb6zuIKKMSXwtSy5r6lq7fXCnbl3HEMKNs3qtt+1+3qIGA+iNSkQhjZYhHtsVcGO4k8p6+08SZ0FVFr/+TYq/vTVNcjWA/8HY=
Received: from BYAPR11MB3224.namprd11.prod.outlook.com (2603:10b6:a03:77::24)
 by SJ0PR11MB4815.namprd11.prod.outlook.com (2603:10b6:a03:2dd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Thu, 14 Oct
 2021 15:17:09 +0000
Received: from BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::6862:fb31:6fed:3d45]) by BYAPR11MB3224.namprd11.prod.outlook.com
 ([fe80::6862:fb31:6fed:3d45%7]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 15:17:09 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "Mekala, SunithaX D" <sunithax.d.mekala@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 3/4] ice: Add support for SMA control multiplexer
Thread-Topic: [PATCH net-next 3/4] ice: Add support for SMA control
 multiplexer
Thread-Index: AQHXv4b8vL6cIJG3FUOtYjRtcn2EP6vRkmSAgAELJ4A=
Date:   Thu, 14 Oct 2021 15:17:08 +0000
Message-ID: <048af8333ca4503ff61a2e007e934f9441f98dd2.camel@intel.com>
References: <20211012163153.2104212-1-anthony.l.nguyen@intel.com>
         <20211012163153.2104212-4-anthony.l.nguyen@intel.com>
         <20211013161909.735f2f17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211013161909.735f2f17@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-1.fc34) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cdc90548-1a2d-4575-e1e0-08d98f25b0c3
x-ms-traffictypediagnostic: SJ0PR11MB4815:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4815B48E47FFEFFB17A7F5FEC6B89@SJ0PR11MB4815.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xM4NWYeJgBmQpX/NV3eqVg8B6S5gubctQewkH1oH5dtue75ouxhGEB5/QzV+sfNXkZiXv+QfLa6l6eamlzsmlWi1hEFFEtO8/SGvCjkRPDSGevzcDzojQYQvdNuDWl2/7mmfRJYDob1o8cFUGZ8fsyUxBHMR5d+Ji/5a0wYDu0DIRKFqInEEKgoZjG9oqKPVCeu3DFhyHbL3x1jj4hBtsMPo5ICMzuWePtSLHz2qBzY94ntutqCjFLmJBTgajf2aVg2pbaGP8zL5Q/WQVzUIG94En5niwXqgpRB0MFKmyEBedMcFrruKlepTori2rY8TPdpmuqM3Q8s2ElcCxDQmDmyqekvebhwK20tZIZncOrkwFgStq0mDiyEzpcOiSqeLk6PSy26B/1LfzT9rsB2gR1ktXP84XrzDcvBk8sCWyawEtGb5pLdTU6MMG9sYQWI7NnNLjjZ54bgVaBhpvr40+ggWKnI02AiTG4cQcU1xlw4WUM1zpSa7YYQZXW8OnJld3fQlaqo1OHTasAfsTTzel/k4fDsi9lR76g9+AQqEwxH0Gz8wR1N858acMXHwxMDHkwljnz9Qdn8N6ydSIOYvTjuCFtm9e1USbBBjVLAu+cGhdCY72rMg1qZvDXNC1VTMeyjnM27doxIkLrmxcRrN+O/wIXdwyGRfKveDbQfxbU2Lro06h4nxxPtfKZMhXUxDBnWbuQ0x+6gcI+YdRC42EQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3224.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66946007)(66446008)(66556008)(38070700005)(6512007)(54906003)(64756008)(66476007)(86362001)(76116006)(186003)(2906002)(2616005)(26005)(6506007)(508600001)(83380400001)(6916009)(71200400001)(8936002)(4326008)(316002)(122000001)(38100700002)(6486002)(36756003)(8676002)(82960400001)(4001150100001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d1hkWHNXSkVwbktKcHFKNzBKWU13bGxQNE1yK2ZtTm1PTGxHNEduNk84UElI?=
 =?utf-8?B?emI2WitQQlFHa1hGZFNialpyMG1PY0VWNkgvcm5ETG0zeE5iR3dJS3lXWnRj?=
 =?utf-8?B?UkFmaDhkMEVSZzlVR3dOcUxmZHBoaEJialVWeGFCSEFlZVVRY0FKckgxYjFG?=
 =?utf-8?B?SjZTNkdxN016UEFBV21jR1ZsQjNVYWJNaHZXM2dyTjJWejlySWkwREpydDRn?=
 =?utf-8?B?SXBWc05DdjlTZ2dkLzd1U1pmMm5VeVlyTHh1SWN3RWc2VHdyNFZid1VGVzhB?=
 =?utf-8?B?SGZWMjRJOHpVT2Y1Y08rQVVGeUhVS09aU3h0NGJBblEzM2RyMGs4SjJUbStV?=
 =?utf-8?B?WVo0TXJTTmhGSnZLcTZVV0VOSWZtdk9oSk5nUWxVWG0yMDc2OFBKd1RvejA2?=
 =?utf-8?B?QkZuMTRUWTVlVkc0SUFVZGlvWGxDNzJtaVQwamZHQmFjSnUwampLWDRvamEz?=
 =?utf-8?B?RWcyUHUweGFWWDRROE5CS2Z0YkRDbWVPcUtOdWlUN3dRMjdXZHJoemNOMkdx?=
 =?utf-8?B?RnhwOEd1SU9ORTNQR0JBR284TE9sWGVhMHpibndlVm8ra3UzSThlOWI0b28z?=
 =?utf-8?B?R3Rzd0FjaHA5Rkh4WFJCSzhUdDJZNXdML0RBaGJXUTlVM0d2di9YcjZ1c0Jh?=
 =?utf-8?B?bU8yUFdYajNjTDY5eDlKUkJuV2ZjaXZxalhLcmhnRUtyemR2U1k4SUEvWGxp?=
 =?utf-8?B?aGFjWjh1dFBscmp0UlA0RjB5V0syK0pJVHAwcWtteUN1dXZ1aWZqc1M4bUMr?=
 =?utf-8?B?Yjh3VTRlSU4vbDJLZUV3ZURKdndBRTg3VkhkWFNLeFgwRjB4Z1FFOGxRVklE?=
 =?utf-8?B?QUxzUWVzUGc2ZjhpenBEaDBDaVhSdUR1ankydUQ3QzhGRTd0UWUxRmFVNFNE?=
 =?utf-8?B?UldrSy96Z29URi9MMFB5aWl4U1IwOGV4SkZMMzdubXVFZUxpZTNYZWZ1U1J2?=
 =?utf-8?B?aUlDeHIrOFVTWkFleTJvbXpDV0JGY0d1U2F6TG5nWUNtbnRKaGY1NWFHMGJp?=
 =?utf-8?B?UVo0UVE0Y2lncnMrNDhGSkpvS25lU1g3YkxpdjlueEhYanhtWEhMNXZZZGZH?=
 =?utf-8?B?ek0ydHcvVUN5V2hmUEV6VituMXJvaEFhS2pkVjVhaUtTSW9UK0oxb3d1Nk51?=
 =?utf-8?B?dUdkQjFodlhkNWQrN0ZCT0wxN0grOTRqMk1sUmFXZ05VNVJmU1FkY3hIUVFY?=
 =?utf-8?B?MWh1UldSdGpzM1JvVEc5OUhWViswU01IbU5rVzJwLzloMU9BQ0RhQUZKMmJK?=
 =?utf-8?B?dlJwc1ArcEJOK2dRNXNTTkowSCtuL3Jma1AzMjU1TnZDK3RUVzg3dVBjRFhx?=
 =?utf-8?B?UEM4aUJuOTBpc29LZUExa0hXd0pQSlJMVVBDWHBoc2loR3kwNmhmY3FNOFFH?=
 =?utf-8?B?UEUzL3hHb0V0WDZKc284K3kvWmhIbFJiTlRCYzU2cmhCa2pob1pYUnY5RHRD?=
 =?utf-8?B?NnZyYnVqS0oyRnoybSt6M0s2a1B5bWMrYWk4UGxKSm1FRm5KZmNTRGQ3blY0?=
 =?utf-8?B?RUFNVDRBSGJKOFo5UURmV1owejEwbFVnV0MvSzJSL21lWUpaUytoSk94TVkr?=
 =?utf-8?B?QzNjdzdWdE1KaWZqLy9LWWtCbk5hUndYdjhKK1R4ZVVzOVJLcTFTQ3NXcWF1?=
 =?utf-8?B?ZXFJRzllVDR2S1hGdUtNQ3k3cUZpWGVxZVBPQnM5RUV6T1RlUUN3NlJHbWYz?=
 =?utf-8?B?SUhrdXZOWTgwbGZRYWJBNWJWRUs2LzQ1ZzV4TlNNNlZVQ243Rmw4dG5nQU1E?=
 =?utf-8?B?Q3VvRFdFVmc4Y1R6T3IzVjVyc2dkZFFrc2o5alJpdTBaSTh1NGxhNjBKSE9M?=
 =?utf-8?B?ejVzeGQ4aUovZEJKYjhvZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FFC63977CFF65142B6512461287DFC74@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3224.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cdc90548-1a2d-4575-e1e0-08d98f25b0c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 15:17:09.0435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vgH1SNruw1pPzBii65Y7M/A7m/1/yQwpUsrQVilIa9AG6s9Q4ZzsRKvWDV1TRLAxjmMTdAIXWha5emzjEHH9xAxkjWQMFXDA5MO8oyiPnk8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4815
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEwLTEzIGF0IDE2OjE5IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxMiBPY3QgMjAyMSAwOTozMTo1MiAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiBGcm9tOiBNYWNpZWogTWFjaG5pa293c2tpIDxtYWNpZWoubWFjaG5pa293c2tpQGludGVs
LmNvbT4NCj4gPiANCj4gPiBFODEwLVQgYWRhcHRlcnMgaGF2ZSB0d28gZXh0ZXJuYWwgYmlkaXJl
Y3Rpb25hbCBTTUEgY29ubmVjdG9ycyBhbmQNCj4gPiB0d28NCj4gPiBpbnRlcm5hbCB1bmlkaXJl
Y3Rpb25hbCBVLkZMIGNvbm5lY3RvcnMuIE11bHRpcGxleGluZyBiZXR3ZWVuIFUuRkwNCj4gPiBh
bmQNCj4gPiBTTUEgYW5kIFNNQSBkaXJlY3Rpb24gaXMgY29udHJvbGxlZCB1c2luZyB0aGUgUENB
OTU3NSBleHBhbmRlci4NCj4gPiANCj4gPiBBZGQgc3VwcG9ydCBmb3IgdGhlIFBDQTk1NzUgZGV0
ZWN0aW9uIGFuZCBjb250cm9sIG9mIHRoZSByZXNwZWN0aXZlDQo+ID4gcGlucw0KPiA+IG9mIHRo
ZSBTTUEvVS5GTCBtdWx0aXBsZXhlciB1c2luZyB0aGUgR1BJTyBBUSBBUEkuDQo+IA0KPiA+ICtz
dGF0aWMgaW50DQo+ID4gK2ljZV9nZXRfcGNhOTU3NV9oYW5kbGUoc3RydWN0IGljZV9odyAqaHcs
IHUxNiAqcGNhOTU3NV9oYW5kbGUpDQo+ID4gK3sNCj4gPiArwqDCoMKgwqDCoMKgwqBzdHJ1Y3Qg
aWNlX2FxY19nZXRfbGlua190b3BvICpjbWQ7DQo+ID4gK8KgwqDCoMKgwqDCoMKgc3RydWN0IGlj
ZV9hcV9kZXNjIGRlc2M7DQo+ID4gK8KgwqDCoMKgwqDCoMKgaW50IHN0YXR1czsNCj4gPiArwqDC
oMKgwqDCoMKgwqB1OCBpZHg7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoGlmICghaHcgfHwg
IXBjYTk1NzVfaGFuZGxlKQ0KPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1
cm4gLUVJTlZBTDsNCj4gDQo+IExvb2tzIGxpa2UgcHVyZXN0IGZvcm0gb2YgZGVmZW5zaXZlIHBy
b2dyYW1taW5nLCBwbGVhc2UgZHJvcCB0aGlzLg0KPiANCj4gPiArYm9vbCBpY2VfaXNfcGNhOTU3
NV9wcmVzZW50KHN0cnVjdCBpY2VfaHcgKmh3KQ0KPiA+ICt7DQo+ID4gK8KgwqDCoMKgwqDCoMKg
dTE2IGhhbmRsZSA9IDA7DQo+ID4gK8KgwqDCoMKgwqDCoMKgaW50IHN0YXR1czsNCj4gPiArDQo+
ID4gK8KgwqDCoMKgwqDCoMKgaWYgKCFpY2VfaXNfZTgxMHQoaHcpKQ0KPiA+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gZmFsc2U7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKg
wqDCoHN0YXR1cyA9IGljZV9nZXRfcGNhOTU3NV9oYW5kbGUoaHcsICZoYW5kbGUpOw0KPiA+ICvC
oMKgwqDCoMKgwqDCoGlmICghc3RhdHVzICYmIGhhbmRsZSkNCj4gPiArwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIHRydWU7DQo+ID4gKw0KPiA+ICvCoMKgwqDCoMKgwqDCoHJl
dHVybiBmYWxzZTsNCj4gPiArfQ0KPiANCj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAhc3RhdHVz
ICYmIGhhbmRsZTsNCg0KVGhhbmtzIGZvciB0aGUgcmV2aWV3IEpha3ViLiBXaWxsIG1ha2UgdGhl
c2UgYWRqdXN0bWVudHMgYXMgd2VsbCBhcyB0aGUNCm9uZSBmcm9tIHBhdGNoIDQuDQoNCi1Ub255
DQoNCg==
