Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4E2365D32
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 18:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbhDTQXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 12:23:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:4726 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232174AbhDTQXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 12:23:22 -0400
IronPort-SDR: MTUJiBzwmljtMuNegcQBtTC5c+9RXfS1VaYVcZeAraUQ8BNnRk/kr2fKoMrLMW1G+cJa8ke11B
 bWKY42b7YArw==
X-IronPort-AV: E=McAfee;i="6200,9189,9960"; a="192350159"
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="192350159"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2021 09:22:50 -0700
IronPort-SDR: y+9BhY1WJErvncaoMHHECZrdbpAenbCaHYQ9hDGvBftuXrXALW0j+10JXb2m01RC8Xz8YUlHTg
 SlGg5B++VCvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,237,1613462400"; 
   d="scan'208";a="523869493"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 20 Apr 2021 09:22:50 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 20 Apr 2021 09:22:50 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 20 Apr 2021 09:22:50 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 20 Apr 2021 09:22:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.56) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 20 Apr 2021 09:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WHsuScWoYON9VEctABAm3Iu4f5MzOyNqkITDiN6XKbQNPmLtnOlZ0FCnvhd8WjmX9/RFcXjhuAL8wd552dbEqJNBx8G3rA5sAVA2wMklhl/L2k6yd3NMaYMb05AEu3bPS4LGb6PVK0ThZhAsedZkJm1IvuM4A2nZnwDuG2AbbvhdVLYDMYRN2UYMD51R38/rJTS5bQVrmmizL000856P/t9y4WVnn37rnKwtJj/V91QOdIvfVf0WESAmBvisOwvXjmRxUVLxC2t2ldeltbMVi+EhlUlm6uwM0+J2ceuVy8tgaIt5VYlM2LxoiDh19hv0W287trp+mNxqd2EXR7gk9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+KXwV7Yho14mabSKprUDp9XWzPS60fZxYUXD3KKrCU=;
 b=eacHgLdC7qIzWi5xCVDNjdjjYasysRBay16QLgsJuqfBUCQKhfUUuuYfXrbrF6LwfiPbTe2dm/r4GX/UYP8OD8ynBibl3qMJJIrnpgYPnEDZsMo1LxhOAGNA0jrGJ4mFVxey3ZQqkm/RCoieY8ATQUw8rcdVgRJ0i4368YspU+2EGh+CrcLCwwnaEdnoiY2Yl5eG5m3lAyrhRs+HUiFU2iJggGBeRrCR2T9R3ojMKClkCsvR2hwqe59aZygWq8gDiUGIy43L5/pF3gSvi+3gVSri/dnTcp+uKuxVTp6y4xfQEQTuAfLxO3LUcixJckO0eJmo1c1tJuPdyx1w6QPJOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S+KXwV7Yho14mabSKprUDp9XWzPS60fZxYUXD3KKrCU=;
 b=TPxax4WgJIFTNtpguCC2IIiOzVb46PMkbOAGFQnSwtW/qj9I4lKFgOISzUqBrdjtHAFPF9K9A1Zq8d0YR4/NB/Mv5P2bih/vYWN7V/BcX65UhvmvgSgOQWYkVNeZNoRyYCDYO6RnbQ57FnS92vVQHlkinFtDIRt39xuvNky2ztE=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4778.namprd11.prod.outlook.com (2603:10b6:806:119::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Tue, 20 Apr
 2021 16:22:47 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 16:22:47 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "Siwik, Grzegorz" <grzegorz.siwik@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Switzer, David" <david.switzer@intel.com>
Subject: Re: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for i210
 and i211
Thread-Topic: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for i210
 and i211
Thread-Index: AQHXMwEl5YYXJs7jZ0WiKbf9BWeGcqq3pH2AgAX4TAA=
Date:   Tue, 20 Apr 2021 16:22:47 +0000
Message-ID: <b2850afee64efb6af2415cb3db75d4de14f3a1e2.camel@intel.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
         <20210416204500.2012073-3-anthony.l.nguyen@intel.com>
         <20210416141247.7a8048ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210416141247.7a8048ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4100f258-0497-438d-d14e-08d904188924
x-ms-traffictypediagnostic: SA2PR11MB4778:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB4778A7F3A5E568CB99E1D952C6489@SA2PR11MB4778.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oK8ZO059CMHP6IubkHPYh1usglmgK9nHprW1hpmDZ16YWCGqMXgMXpxYP0X0yNy397zhtgIUG4qB5dQSbWGYBb+zaAcaIZ6JewIaTfNI3DTLLJscb0z4yrReTzAq7i3+fMNgHitTINirPBrT8SQoFEJPFiInoyb6ZLIYY5JtcPjZYCU6o4qtn7wY7A4cwVjegAE8E6TaQPuoEmv6Dk2kmmzbX7vq9lzIPGrTg08CeLx7+c4Oj0aIKxx0/XbnLv1aGhGmImjScmqkgDA3+q2qswcDrZa0iaBodJDBFybb2g2sfSmT74MFAaPDxEfqcu/iOtwqRnYvog7/dyDjlLR3u56Ae9GEHxWsuv+4DQP2/OLKF4Thi/AqVEK0mZLLu6dcVuAY7jlo/u14lQF8vKzF7J+nzOjYhc0aBF703cg6uDGwmwKDRlsY1P57vGIyBzQzEFP/HVIvPSTrHgkv3hq8HXtu9rXA9FS2S1y5+mWI9JRRTwgrM/seVHnvXK+TGMsgqfzxbtp7ij//Ef32KAFOlspqMcnkCa6js0POC71HDgdugAGR0KXnOqpTEit8Fz8RTWNg5ZFYDR2jIxa/gvM9lXAnSaVLMqo3d1B+ygTTd8UkheVoUjwz2VrIda4C+XAclgCSFnLwGRsyGVEsKTJELg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(346002)(376002)(366004)(6486002)(66446008)(86362001)(91956017)(8936002)(5660300002)(122000001)(107886003)(4744005)(38100700002)(26005)(478600001)(4326008)(2906002)(8676002)(66476007)(6506007)(186003)(6916009)(2616005)(76116006)(54906003)(66946007)(83380400001)(64756008)(66556008)(6512007)(316002)(71200400001)(36756003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?a2JSUTNocm1UTTlMOTNCK3pzWEhzZHBEb1Q4dzdLdHVhNEN4UVcxOFM0VnRI?=
 =?utf-8?B?ckp1dGpKUDBqUVdBaTVHYTZUNzJLeGN3QW1tUWRzQ3JpYVI4eHlhbE5FYUpH?=
 =?utf-8?B?TlhzaUlBclY5clhNcEVQcGh5cXNqSW1EMU9YWHBhaGczT2FIejlyTTk3V202?=
 =?utf-8?B?SWpkc3h5MDcyV0tjeEs4MEllM3BpV1YxSFpzL0d3dkVZL1h2Mk9XNXVWMGxz?=
 =?utf-8?B?TDdxU2YvM3JjakxFNXVSY0hyREVhYVBHc2c1eGlFQU0yUGlCQXIrcjBHcnBy?=
 =?utf-8?B?Tmp1dUNOSG5XQXpoeitaSjR6bnQwZzBLdTBTdmQ4M2lFNGU0WFBqd2VDb2dq?=
 =?utf-8?B?OEMyd2RrVXp5ejN2SWVWcWZuamlqT0VNRWRsZmJRSzZzcTlHbW1UTlF5Qytl?=
 =?utf-8?B?RXhzMERVSlZUUWVOUmg0QytzZCtJd2JTWkVhWVBJUHB5SWhLRE5CT1BVaWVN?=
 =?utf-8?B?QUFxcnJSY1E3dGxFTE9uNk94dTFSZGVHbGFWSlBMMUdwQi9SSjFSNkxvTXZ1?=
 =?utf-8?B?RDRTcXNuc0hOMU95dlZoOUZGdDZwSmt1S0ljbi9OOXl4ZDcyMzNjdGRWZkoy?=
 =?utf-8?B?cjRReDYxU0E3Y1hyRzdUMFVzQWk1WitPTGtHeTZ1cVhJazVod0RWVTdsVE9i?=
 =?utf-8?B?UzBMczFQTmRESDFrVUNOelhFVkpJazEveFdGeU43RTBVbVQyUGlFKzhEbURs?=
 =?utf-8?B?c3JRMlFzL2Z3ajVWS3RYeTlVUVdnaWJLcDFuOGtDOW00QTBoNU9VVjVST20w?=
 =?utf-8?B?azEwT01KQ3BYR0d0WVF2MUVIYktudmhnNlJaMmZqMVlEdTVlbFhKekF3V2cr?=
 =?utf-8?B?enpsZ3Zlb3o1c1U0MkNrbGF0TXNNeWFtb280U05LWUREUGVkMzlqY1JybjUw?=
 =?utf-8?B?ckp1MFk1WkFrdVRXRk1uL0hqQ3AyTHBzbU5peWFnZlRkeFh5cEpobUp6Mkox?=
 =?utf-8?B?VGFEaXBEUWlSS1NRbWoxQk1CS0pMMThoN3V4YUxlK0FqWFRJaW9ZcWZoZ1Vq?=
 =?utf-8?B?bkovSzI4SEpHR3ZLeHh0VUc5empiNTJNbFVycm9ad3JZdUc0eUxXeGd0NE5V?=
 =?utf-8?B?cnZjbENjUnhWdDhPMzZiOTZuWjhFcmZ6ZzY3dDhhMHNPS0Z2ZSs5UTNiblE2?=
 =?utf-8?B?Z0Ixb1BKMDdHaTF5aUNkSjFCK3JRME4vc093eFdJOWxZVTNBbVUwWktmdEtP?=
 =?utf-8?B?ZUg4UytJZ1g5ZUZLL0JTK2VjUWdxNlZ4TUlIMmp0SEp5QnQ1aTlqTHpEcENH?=
 =?utf-8?B?QXMwTGp3MDAyb0JIOFh5SWtiYlJLMzJ2YXJUTnF5ZGx3SmpFM1BYNXRjVGFO?=
 =?utf-8?B?VTJKK2Z4SHdyWTA1eU5nMmc3eUNKYzdsdDVpZkRTTTJBdlE3WE1VZHFWWGI1?=
 =?utf-8?B?MExIbXFOenFyT0wzSFpOMUZZaGF2WVEralY1RE9yVEExRXZ0T01WQWkzanJO?=
 =?utf-8?B?WnVGSUFEOFJNQ1cyTC83MGJtQ2V1ckJsLzkyU1VVZDRzQ1U4VTVLMWtsM09s?=
 =?utf-8?B?aCtjTVl1cHZwNVEzZ3RVbUlpWjdzeWJKbTJnM1llLzYyUmxjNzYydG16c1Rm?=
 =?utf-8?B?VW1vdWVWS3ViSStuZlFjQ1RHMlpYZ2RYaUpFU081VHFxeWFCVFpTNWtoZnF4?=
 =?utf-8?B?KzIxWlVpaHkxZVJwNFBabUxsMzdUcFovc2I2ZitNR3JhbUVpQVVNdS9KK1hr?=
 =?utf-8?B?cjM3d3IrWW5mOTNVTTVTbitWa1V6dm91ZWc1R1RHZjJDMXdxTDdqYmhWWWRr?=
 =?utf-8?B?ZHNYSElYS0lqNEhOWDFDN2FOelVHZG9kMTk1T3hjQWxseHk1aFEya2ZTdEVV?=
 =?utf-8?B?ZjRqSnN5Wk01WDdONllUdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE7B6F11FB885542AA30F65DB06048B0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4100f258-0497-438d-d14e-08d904188924
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 16:22:47.4864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vr5Pk4WGuQjN2aeY67cl2I6c+vCxpYuTfsL6adm228FImN1vbU85RIBJQPkGVJh+jHGl4oCG6bTXL0ynxkZRV699eNMA/vQEYYy6qPr4xbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4778
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA0LTE2IGF0IDE0OjEyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAxNiBBcHIgMjAyMSAxMzo0NDo1NiAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiArCWJvb2wgaXNfZmFpbGVkOw0KPiA+ICsJaW50IGk7DQo+ID4gKw0KPiA+ICsJZG8gew0K
PiA+ICsJCWlzX2ZhaWxlZCA9IGZhbHNlOw0KPiA+ICsJCWZvciAoaSA9IGh3LT5tYWMubXRhX3Jl
Z19jb3VudCAtIDE7IGkgPj0gMDsgaS0tKSB7DQo+ID4gKwkJCWlmIChhcnJheV9yZDMyKEUxMDAw
X01UQSwgaSkgIT0gaHctDQo+ID4gPm1hYy5tdGFfc2hhZG93W2ldKSB7DQo+ID4gKwkJCQlpc19m
YWlsZWQgPSB0cnVlOw0KPiA+ICsJCQkJYXJyYXlfd3IzMihFMTAwMF9NVEEsIGksIGh3LQ0KPiA+
ID5tYWMubXRhX3NoYWRvd1tpXSk7DQo+ID4gKwkJCQl3cmZsKCk7DQo+ID4gKwkJCQlicmVhazsN
Cj4gPiArCQkJfQ0KPiA+ICsJCX0NCj4gPiArCX0gd2hpbGUgKGlzX2ZhaWxlZCk7DQo+IA0KPiBM
b29rcyBsaWtlIGEgcG90ZW50aWFsIGluZmluaXRlIGxvb3Agb24gcGVyc2lzdGVudCBmYWlsdXJl
Lg0KPiBBbHNvIHlvdSBkb24ndCBuZWVkICJpc19mYWlsZWQiLCB5b3UgY2FuIHVzZSB3aGlsZSAo
aSA+PSAwKSwgb3INCj4gYXNzaWduIGkgPSBody0+bWFjLm10YV9yZWdfY291bnQsIG9yIGNvbnNp
ZGVyIHVzaW5nIGEgZ290by4gDQoNCldlIHdpbGwgbWFrZSBhIGZvbGxvdyBvbiBwYXRjaCB0byBh
ZGRyZXNzIHRoZXNlIGlzc3Vlcy4NCg0KVGhhbmtzLA0KVG9ueQ0K
