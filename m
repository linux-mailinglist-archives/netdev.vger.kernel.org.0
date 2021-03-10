Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21517333222
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhCJABn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:01:43 -0500
Received: from mga11.intel.com ([192.55.52.93]:12960 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhCJABX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 19:01:23 -0500
IronPort-SDR: sY7KiZB3HAXm3kylVbsXleo+bweGSicSf69W5ZagBVwbupCHdFJHslvEP55Wz/IW4qwELXCadv
 8sIFssJHz8OQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="184987669"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="184987669"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 16:01:12 -0800
IronPort-SDR: vkW4GZP9kE1ATdCwxUJAy3s20phham5qAXPoNKv4zhQxlYtQBDpn0+WjW793cr+KsXrEP7N0S5
 lAV3gLUc/3TA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="447693305"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 09 Mar 2021 16:01:12 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 16:01:11 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 16:01:11 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 16:01:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=US1NHtHu+h1jYVq6YT6lzGpsFaJ4AHcm8uzsMGXolUdHdPCzaXAOQQqC8/oTC21vBLyFbIo5540g6T13eFUCm5fJgVqllPYaU1Xex8nuhLQikZj3uqZXeRL9xG77RCXggoUt2Ic0l7bzGY8ImKYoBWUOlVR6/vlCwPguwF8jjefCO6wWR5GVIorLghfGI2v+/THHq6s+z5QBl0YV8vozmSsNccIuN4YzFeLs+eecwFEIfgUIOUjO2CmR4E5js9FLUOJuNCQpDS07ueMfv0qqfdwtLQxHIQwkE+4uIF7AsgbYtTzzGBi/EoOqpNo8AZbpE6uiLLQg4WuYGSu90Mq/EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAkp33iPyeV/HfoU57NgCW3SMVG7HA4iIuIa0xFeY20=;
 b=OIQ10UgZXmaD9uleK/J2xIfWn30+VEpRYHg8ffPPgesbIrM/sjyFqZyNnpDpN/h+/tzgjYsF/Sw5UqIa5fP5ZpJN4MVV5VL8F3Nj4auPuC7R/5iE0GpOjttd4kp1gCXI8SY+tLSwrZY5IRrL+A83VdlcQTMu7NnyNyrQ/7h2fWRCDwY9Oqh4/hxRK7tDwG4sJALFVXyfyaVKXLMxoLNxIXB1aXydQipbdNSRUUEcKdia/tzZxeWyG1iOOJqFPNqK2MJeFhANrf82i1amI/5Jl2s+NLF+whdRaDaEuvjj5+yG13aMjpuzoWqX/XvdOWNwOwQL7DiPHGdRlTNi/7KeMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RAkp33iPyeV/HfoU57NgCW3SMVG7HA4iIuIa0xFeY20=;
 b=hctm+eyYJzyNIXuqaPlIVec4bg1mM9+11iWmjYpFjbEgnjBIXh1VUpWw6AcdidYOYD8t3Fj4J1XEYDHHElhijczM/M1lHtrYJheDhrF8mktGv9ny1GHU8dMUatOHg9b+peZmxsYv86tQErQ7FX1TLlLrQLfHbCgxdOtum46DT9s=
Received: from CO1PR11MB5105.namprd11.prod.outlook.com (2603:10b6:303:9f::7)
 by MWHPR1101MB2141.namprd11.prod.outlook.com (2603:10b6:301:50::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Wed, 10 Mar
 2021 00:01:09 +0000
Received: from CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc78:a58:d862:c366]) by CO1PR11MB5105.namprd11.prod.outlook.com
 ([fe80::fc78:a58:d862:c366%3]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 00:01:09 +0000
From:   "Brelinski, TonyX" <tonyx.brelinski@intel.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH RESEND][next] ice: Fix fall-through
 warnings for Clang
Thread-Topic: [Intel-wired-lan] [PATCH RESEND][next] ice: Fix fall-through
 warnings for Clang
Thread-Index: AQHXEZ0GqwTMi5pfiE60a2gAsfPXVap1GbkAgAdDz6A=
Date:   Wed, 10 Mar 2021 00:01:09 +0000
Message-ID: <CO1PR11MB51052F33DA15B71D28E29993FA919@CO1PR11MB5105.namprd11.prod.outlook.com>
References: <20210305085257.GA138498@embeddedor>
 <833549f5-a191-b532-50bf-4ec343c48dd0@molgen.mpg.de>
In-Reply-To: <833549f5-a191-b532-50bf-4ec343c48dd0@molgen.mpg.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.0.76
dlp-reaction: no-action
authentication-results: molgen.mpg.de; dkim=none (message not signed)
 header.d=none;molgen.mpg.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.236.132.75]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 751d3390-a7c7-4530-5088-08d8e3579c72
x-ms-traffictypediagnostic: MWHPR1101MB2141:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2141BC314CA68FF09FAD6DA4FA919@MWHPR1101MB2141.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eO9/4guy+g1g8gdfssHFhlkoZhNsm1i8zVKnUlsYUWeMkpanPHTWC7M4K/OrMwzp+dS0DIPLwhLp0bm0kCJptgD9IjCwn86O/qKk+3pvjt44oBZeCQiYhrFW+jd4APUhxyWF2AfdCVmXDx4Vz4GBXqj12uE5/VMlJQ96WFHJYs99DJUOy7zn7kb7OkA5sv9Bc2zcsZ5uYz2PmHNj/chpGvM+3Zj0VTcNmTI1wlqK3zuFK3fbx9AVRjoi3eIPRkHMB0WtsTRfzG6E3/BmazIyjwjl3rAfN0A4wOnAb2nT4jppmi0IwdAWZa2mXOxkMvuUGUdHwE6PGZolWrNmzE89lCmCLgkjBm662K460Q4KBXUI7DquE8mbrESnsBv4omk1HvsuEM9F8kzaCpCmNSbZ/oEDMHxOfhVfmaLzKkfaPWfRabBMqefIlDoe02Xn0h8Eh/852fVrc8e8T32CH0u2ZzSCe09Zw81uTrzDReK3jZq/TwD41sPDymeTdiFTbiizewLDqZTRFrxubvrO6ZsGFlmQN848eoslbAsp1jCIDFu7pgFj/79OEC2KVlre5o6ZjHLNJCB1yVBkyWCDA4oRPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(110136005)(6506007)(2906002)(64756008)(33656002)(316002)(53546011)(54906003)(478600001)(55016002)(52536014)(966005)(71200400001)(8676002)(86362001)(4326008)(5660300002)(8936002)(7696005)(66556008)(66946007)(83380400001)(66446008)(66476007)(9686003)(26005)(186003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?L29mSmc4eTZya040TEhROE1Ca05Kc3BjVGY5ajBraVVuZHZMSENVbTAzaEc0?=
 =?utf-8?B?d0FZejNBd1lOYTNaUUtOK3FRc3FYT1R3L2l3L1N1cVk4RzhyTmVWbGRFdm1o?=
 =?utf-8?B?WDAwWVJicm1ienNkZ2JWWGwzcnZUbTVMK0NYNlh3emJyeHJRSm50MG90NWQ4?=
 =?utf-8?B?dHBlWEUvWjR0d2JYcnVEZWxUT1IxcjNJRXJ5VCt5SGZjakRTZm1pejJmT1NU?=
 =?utf-8?B?a2NPWE0xNS90dGsxRU4wWVRHanlOZ2NTb3l3SGFFdlU0R3JyT01wQnpNeTV4?=
 =?utf-8?B?NTR3WHVzRDNUR0o4VFZMUEVubnEzRUdadUk3d3NGVWROdVhmYm9YaWhHai9O?=
 =?utf-8?B?ZTVteVdDT0VVRURDaHdqVTJJMFNZOVZZR3ZXUzFjL1M0QXdSeEtmZGJ0Z3Fx?=
 =?utf-8?B?RW1QalVUcHdmUGlwTnovaUZkY0VkSHFpSE9LUHVuNC9XdWk2K2hIMDRKU240?=
 =?utf-8?B?U1IzVm5ZbjJWT3FyU3RyQzVoKzk2Ylh3UDJXRC9BNzMrcmlkN1U1Y3FESlBu?=
 =?utf-8?B?RnZybFV0WjhHODRMVkpiNlRwNmYwTzRwMmVqSGliQkN3UjRkUWRSTVF6VHli?=
 =?utf-8?B?ZzNMd0k0UjJ4bHlvQkJ1bGFtWkxGVTZTTkV4YTFzZ2phLzJWeUNDYVk2ekdv?=
 =?utf-8?B?NFdSUEpuQmFzNTg3OFMwV0kxdlJqYzJrN1N4RENRc2ErbzZpcFpKV0lTb3VR?=
 =?utf-8?B?SHlWbEVlN3huTW5LVWlrVFNsZnZPcWFreVk2MDhBTmJFb2xYSlZKRkxIdWdJ?=
 =?utf-8?B?emJQWDh6b3hTN3Z4Y3JYdHphMG56TXZzdzJOa21DczEvYncxNkdPUjdGV29E?=
 =?utf-8?B?NlJSemFGMEZFTGdTZThyQW5RZDRJb0orT1EwOVh5VzNXUm1GbUI5QktaU2Fk?=
 =?utf-8?B?N2Fmcm9idjhocFBNTTlyOFhIblhQZ1Z3UXdDazlKaEI3c25jaTl2MVdQN0pO?=
 =?utf-8?B?TWZhT0FjaWJvTlVCcjBvd3M5SHoxRTY3dXVTRHNKSThTNlJyR0F1cFkzWi9O?=
 =?utf-8?B?Y3JpZDVOZlg1cjhkQnl3NG5QZ1JXaWJZb1VCM1NhdXptTHg0VVlFb2VGS1E5?=
 =?utf-8?B?M1IxcVkxS0ZmbjdoVHhVWkVkVTBGMkxFTDMrQVFVaG1tUUY3TW51aHJCM2JR?=
 =?utf-8?B?eUQrWTJrUi9BS25qbjIxTEIvbFpFYU1tN3BkRzFlcjRNYTRSaitvV0lKR3FM?=
 =?utf-8?B?cjdOMG9NMEFZVnNtN0Uyakx3bXlsN0tMeVNiOU5xSUxvQjFOM3VSc1VtUWth?=
 =?utf-8?B?QWQ2Y1Z3Mk5DZXR0SjkrZjRsT0Z2aHhlaE9WSVBzL2FDRk1JR0VYMFFDem1v?=
 =?utf-8?B?Mkh5NXc0alM3Y2p2QUxHcEdTMVg4L0xiWjRkM3FCQVVyVk9HNU1PblBrWWxz?=
 =?utf-8?B?dnI5NGdDSnhWdkU1blZJUW5odTB2Y0x4eExLTjNod3JzaGhqbTJtaGFta0dM?=
 =?utf-8?B?VGJQaFlXdG9KMStPb2sxYS9HeTc0d2Fsc2JLMzFNZlNyWEZpOFVPZzI0aERw?=
 =?utf-8?B?NTltK2ROeXFqOTI0NE9ZTnRXcE5vUG9QN2w1a3BLQzZsMk82cXNoU3ZLM3cx?=
 =?utf-8?B?MXIrdDU0RU15OEVqZmEzNzgrWnJ1d083Rm1zUkNqTnpCdHM1N3d4alZ1SFlX?=
 =?utf-8?B?MGRqN1NEaTFjQ1c4eExzSmtPUHpRaXFzcTc2RmszWFRaOWtLYnlobUhZaHNF?=
 =?utf-8?B?eTN3L0Znakd4K3E4NmxTdzR5RVVSYXN6ZkE3YkcwaWxnK3RNMUVqd1Y5bHhR?=
 =?utf-8?Q?XiZ+MLNrRU6i2e6w655Xw23KEZVWNKBYaKbW2h9?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751d3390-a7c7-4530-5088-08d8e3579c72
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 00:01:09.8157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wl2UWu7tIPvNKFJ4Ydwkej+/tCa+hja6PqmoLicD//MkYVWVf1h7/090l6pk/nsCP6haXSm3w7Fy+mRM4UVSPSoAMHftYkkwPLNGH7dXRho=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2141
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGlu
dGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5vcmc+IE9uIEJlaGFsZiBPZg0KPiBQYXVsIE1l
bnplbA0KPiBTZW50OiBGcmlkYXksIE1hcmNoIDUsIDIwMjEgMTowNCBBTQ0KPiBUbzogR3VzdGF2
byBBLiBSLiBTaWx2YSA8Z3VzdGF2b2Fyc0BrZXJuZWwub3JnPjsgQnJhbmRlYnVyZywgSmVzc2UN
Cj4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPjsgTmd1eWVuLCBBbnRob255IEwNCj4gPGFu
dGhvbnkubC5uZ3V5ZW5AaW50ZWwuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxv
ZnQubmV0PjsNCj4gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gQ2M6IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IGludGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnOyBsaW51
eC0NCj4gaGFyZGVuaW5nQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVs
Lm9yZw0KPiBTdWJqZWN0OiBSZTogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIFJFU0VORF1bbmV4
dF0gaWNlOiBGaXggZmFsbC10aHJvdWdoDQo+IHdhcm5pbmdzIGZvciBDbGFuZw0KPiANCj4gRGVh
ciBHdXN0YXZvLA0KPiANCj4gDQo+IFRoYW5rIHlvdSBmb3Igd29ya2luZyBvbiB0aGF0Lg0KPiAN
Cj4gQW0gMDUuMDMuMjEgdW0gMDk6NTIgc2NocmllYiBHdXN0YXZvIEEuIFIuIFNpbHZhOg0KPiA+
IEluIHByZXBhcmF0aW9uIHRvIGVuYWJsZSAtV2ltcGxpY2l0LWZhbGx0aHJvdWdoIGZvciBDbGFu
ZywgZml4IGENCj4gPiB3YXJuaW5nIGJ5IGV4cGxpY2l0bHkgYWRkaW5nIGEgYnJlYWsgc3RhdGVt
ZW50IGluc3RlYWQgb2YganVzdCBsZXR0aW5nDQo+ID4gdGhlIGNvZGUgZmFsbCB0aHJvdWdoIHRv
IHRoZSBuZXh0IGNhc2UuDQo+IA0KPiBJdCB3b3VsZCBiZSBuaWNlIHRvIGhhdmUgYSBzaG9ydCBz
dW1tYXJ5IG9mIHRoZSBkaXNjcmVwYW5jeSBiZXR3ZWVuIEdDQw0KPiBhbmQgY2xhbmcsIGFuZCBp
dCB3YXMgZGVjaWRlZCB0byBnbyB3aXRoIHRoZSDigJxjbGFuZyBkZWNpc2lvbuKAnSwgYW5kIG5v
dCBoYXZlDQo+IGNsYW5nIGFkYXB0IHRvIEdDQy4NCj4gDQo+ID4gTGluazogaHR0cHM6Ly9naXRo
dWIuY29tL0tTUFAvbGludXgvaXNzdWVzLzExNQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEd1c3Rhdm8g
QS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4NCj4gPiAtLS0NCj4gPiAgIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfdHhyeF9saWIuYyB8IDEgKw0KPiA+ICAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQoNClRlc3RlZC1ieTogVG9ueSBCcmVsaW5za2kg
PHRvbnl4LmJyZWxpbnNraUBpbnRlbC5jb20+IEEgQ29udGluZ2VudCBXb3JrZXIgYXQgSW50ZWwN
Cg0KDQo=
