Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB25B2FF233
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 18:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbhAURmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 12:42:51 -0500
Received: from mga17.intel.com ([192.55.52.151]:40536 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733190AbhAURmp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 12:42:45 -0500
IronPort-SDR: 9wpyL+vxH/tPNT7XoaSmyWqlDMIMacPot00x5BJ3EFsG6e0OqHZomu/Q8W7CwYnvMThIvHTNry
 zV89HR9OjKtg==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="159089807"
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="159089807"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 09:42:02 -0800
IronPort-SDR: kz1iuaVrSJg7UDLNRJV4cj4of5PuAVFRBWr6kqeiIhMzIy0NdyFLcSYHVb2+H88VwocFoLN5Kb
 Vy+Y8lw3T2dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,364,1602572400"; 
   d="scan'208";a="351531970"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 21 Jan 2021 09:42:01 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Jan 2021 09:42:01 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 21 Jan 2021 09:42:01 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 21 Jan 2021 09:42:01 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 21 Jan 2021 09:42:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DSxaoHOAeiiFzigjspyWbu9q2cKVIMhSSa7v9C1fgny1N2FRGRj3cDSZvDmUL6sBXGnPtMHEROjVAPjutFf32U9GDUIam36NMJpShjRhbM+2nND5zglXu4JgRk5jnf0DruGqCQr26hOCd5XO3Xnp3C7i6EbbM/jDq7lqXhMV8xMsXE6KwvX8wp0wO4hzgrk8r4ZG5gWMEyk6jtxc6Nrk6xDFNYuUOLKWIHzQfMp6ELGi921rUVaSbPyzwBpp/IDoarj63lG74lWIT8aHJpUjsliCUKzRrOsjb1H5z2ncAIOgPJeAZidsSxMT7uLWaXf23Rp/iPpLMy+D9IZyWGFgzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngAUc5oVczqvapW1oTVgGwilsTyRtp8cHTB9byYmU08=;
 b=a0V4Wk4O0k085BY/7EqHZETjgPya0lkqDig3eV+nJUj4LWmsY1TsIJ4PQd1UJR11lK7vJ7WGfZqOK7yHu4eBXtb8WCwnJMYUffrPmz7MS/HkSLuoHoRBIriVAguipC9opL3x3WdKvkOKJlgQ9fJobMAHXB8rfw5Jk9XeOFw/lAt1xi0wWVAg3WDcL1a75v+e6kRuOMrkvoP/cYsF2dkOEfR72U4JvqE3KFF+C66s57O9STsWZEcFuOa0/0ulBWVlA/iGE7q8nxnvzDl8vjCjRFYKJwRbyufAJ5I7j1Y/PhrvqOUt5OHXaeMhlDHViQnsuxY0caYlUzvI+VWpjTi8yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngAUc5oVczqvapW1oTVgGwilsTyRtp8cHTB9byYmU08=;
 b=I2VyRUKR1CW+sDwKQwNHcLg7/LDisVZEL/tu7wUJZo4jcwVOYiCFBYpJTGtacFaXf0bQuvUGjANqsGo2PJDO+DGTr7Agr9krpKYwakbbf74eNrxvIxr1tqfqFrhl5608xrHtgcbunauXUKav1hJazmayEg2cVQ1/P/wuWcaIHqI=
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by MWHPR1101MB2286.namprd11.prod.outlook.com (2603:10b6:301:5b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 17:41:59 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::851c:df49:9853:26af]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::851c:df49:9853:26af%8]) with mapi id 15.20.3784.013; Thu, 21 Jan 2021
 17:41:59 +0000
From:   "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Thread-Topic: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Thread-Index: AQHW6hko29AaKvr6HE2iTtaOFm6DP6on2oMAgAfQUoCAAAsJgIAAFs+AgAAHQACAAo51AA==
Date:   Thu, 21 Jan 2021 17:41:59 +0000
Message-ID: <90dcdc6efe3ec0dff7ddc541bd6990fa5673745c.camel@intel.com>
References: <20210113234226.3638426-1-anthony.l.nguyen@intel.com>
         <20210114164252.74c1cf18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <7272d1b6e6c447989cae07e7519422ab80518ca1.camel@intel.com>
         <20210119164147.36a77cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <910a50d7ae84913e140d14aed11675f751254eb1.camel@intel.com>
         <20210119182922.1102ca91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119182922.1102ca91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a93b704-b93b-4cbc-a534-08d8be33dabf
x-ms-traffictypediagnostic: MWHPR1101MB2286:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB22862DCF1B7C863348AA231090A19@MWHPR1101MB2286.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kpW3CGLXCH7aM5WpWihrjBh2Bi62FYejz1a52WgFpqroEsdElWB9o3QM6uMtFCcWxt5kRch0wpIR2GEmB2iM29l7qCEeAGz9pUOaVGMqY1Pg0t9CChhdboOSyAp+WI5PSZ8e6wiOnRO5r+7cUwk18HDc2QRXm0Qj7OuTXrAv5mHbB2bPVWsif3iO4KEldnaZwLiSM7HPoorKaR7+eNX2bOodmh25j9gFrpUMA0f8qcvmKiGzO6F7Zzhh0bN1WUCmvoc1sLJG/sxaL/0wcjzxTtI9zPNddtGLpTkLcjEx4UsMY9C4QrR2yK5JsOtR3PqYd+wjljQIWQVZmEjDRfAfESp2pIa2TYcuKi9SikZW5R2jFGbSMQzygLbutNU8F3oP+3/SZnPJG32shxMOEHkrzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39860400002)(366004)(316002)(26005)(6506007)(6512007)(83380400001)(6916009)(8936002)(4326008)(478600001)(54906003)(2616005)(71200400001)(8676002)(6486002)(2906002)(36756003)(86362001)(66556008)(66476007)(66946007)(66446008)(186003)(64756008)(76116006)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ZGdpUFI3amxqWE1jbXBCM0NXcHRSckdhVWJ4TUovZE8yaDc5QWoxVjI1REJT?=
 =?utf-8?B?NWZwMG9OMHI4WFdsb0g4UXU3M0ZIV0pwWFh5T09TZ2xOUXlwK25SaDNSanhT?=
 =?utf-8?B?YWRTL1ZOeVdiZ1J4UzMySkFWM1Z4dm9zWTljQnloYUVhMGRYaFBDR2RyLzJE?=
 =?utf-8?B?aEZPUUxBalZmamlaWkhtd1p5VVJabXd4M204NXptTVgxQW44MHNzRUJyclZy?=
 =?utf-8?B?NGJFditBcDdhYkN2dW9LU3ZWSjNxQ3oxRHMrL29ZcTd5UkFseGord1Z3RlFq?=
 =?utf-8?B?R3RDSHFLa0RidmJ4bzI0MVQrK1FnTjJjdUFPa1RZNHI0R1QwanoxYnRrODRE?=
 =?utf-8?B?OEMxemx3R0xhZ1hXelA1djk4WGhhcmQ1eGhnREFDNVBjSXlQK1ZEb1pHemp5?=
 =?utf-8?B?M3dpaGZuWHdWWWgzVE5sd21IYmFIY2QzUlp6QkRuYnlQcXQ5Mm5leWk0d2tp?=
 =?utf-8?B?V3ZPMUFyeEhhOGdXeXhxSVJjM3BlNzdFOVpPYS9UQ2g5ZitEdVE3QlJhcE9z?=
 =?utf-8?B?bW0vS0xvOW1qQXZSVjNzbTlYalgvZzA0aGFxWk5pcldRcWRnN0lUSU11NzZM?=
 =?utf-8?B?RGs3NFlrQk5PeUxESjA1TFY2TFZUR01rT0l6S2ZuVFFhYlUxVWxva2FvdGZo?=
 =?utf-8?B?cys5Zk9Cck9OcWY5MVd6SUtJZWYvUkpFV3p4Um9UR0ZsWnd4cXhPS1VpMjN3?=
 =?utf-8?B?MENsd0swN3RhY2xvUVlucXBNcE9IcC9Wa3JnazN6SmdPVDBwQWlZdUR5SkFB?=
 =?utf-8?B?M3o2MHUyL3NqTUhJKzMxN0k4Rmg4MEE1ait3NnhtcU9MRmN1d2pOOWNKYVhD?=
 =?utf-8?B?N2ZWMDdLYVpPWHdGZTBKaFE5SDBaQWdUcGJrRFNsenpMTENBWFFXbndDR0JF?=
 =?utf-8?B?ZC9JRXRqamdId2RhSXJ6MHhvWGhMSGd2UDE3MHhWSGE2SW5XZWFXTjVxdkRk?=
 =?utf-8?B?MXJqTjlmVFRmMGFwL0Q4UE9tK2w3d0JCVWNSYTlqT2FZWmMydFBzWS91UVQ2?=
 =?utf-8?B?MStZTjdQeTM2OVEzZFErWDJWN21XMEtOK3BKbnlEcWxIcE94cGRWUVFSY2Yy?=
 =?utf-8?B?RUNwZmNJcUJpT3c5VFhQNGhvZXJwTGxadUtLRkduZ3VGVmkrRXBXS2pmT0JI?=
 =?utf-8?B?cWd2bVlVWkZJVWVldWJtdENmSHRNR2x0THVxSkdxNk5UK1pScFl5blpObk9I?=
 =?utf-8?B?NUtsVVdZc1lJdzYxR2VCNWRQUG45SUxNZnNWM1ZMSUJhVVMxOVRQcGFQejI5?=
 =?utf-8?B?OTJWeDF1Yk5LYlJHcCsreUFPb2NHMlFoTzR5MHhBZzIwVW5OeDN6Qk5DelFw?=
 =?utf-8?Q?K3H0JX0NES1YQAVZ4goYuNNKCq/nke1zVa?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5D7190BDEB9F34DACC97E16B7649A35@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a93b704-b93b-4cbc-a534-08d8be33dabf
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2021 17:41:59.4402
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 35ZgrJtfQBDApEel72PNfE0FV9f/rhj2BQuqssDMd6ephe4akt28d8DQr2wzxJoscZyj1vVqEvItOzLxEMbGJ2LvH6M9SptzKvkeN9cs34D9NkRlALIXRtf9bFq8bHtp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2286
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTE5IGF0IDE4OjI5IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyMCBKYW4gMjAyMSAwMjoxMzozNiArMDAwMCBWZW5rYXRhcmFtYW5hbiwgQW5p
cnVkaCB3cm90ZToNCj4gPiA+ID4gQXMgcGVyIHRoZSBjdXJyZW50IGxvZ2ljLCBpZiB0aGUgZHJp
dmVyIGRvZXMgbm90IGdldCB0aGUgbnVtYmVyDQo+ID4gPiA+IG9mDQo+ID4gPiA+IE1TSS0NCj4g
PiA+ID4gWCB2ZWN0b3JzIGl0IG5lZWRzLCBpdCB3aWxsIGltbWVkaWF0ZWx5IGRyb3AgdG8gIkRv
IEkgaGF2ZSBhdA0KPiA+ID4gPiBsZWFzdA0KPiA+ID4gPiB0d28NCj4gPiA+ID4gKElDRV9NSU5f
TEFOX1ZFQ1MpIE1TSS1YIHZlY3RvcnM/Ii4gSWYgeWVzLCB0aGUgZHJpdmVyIHdpbGwNCj4gPiA+
ID4gZW5hYmxlDQo+ID4gPiA+IGENCj4gPiA+ID4gc2luZ2xlIFR4L1J4IHRyYWZmaWMgcXVldWUg
cGFpciwgYm91bmQgdG8gb25lIG9mIHRoZSB0d28gTVNJLVgNCj4gPiA+ID4gdmVjdG9ycy4NCj4g
PiA+ID4gDQo+ID4gPiA+IFRoaXMgaXMgYSBiaXQgb2YgYW4gYWxsLW9yLW5vdGhpbmcgdHlwZSBh
cHByb2FjaC4gVGhlcmUncyBhDQo+ID4gPiA+IG1pZC0NCj4gPiA+ID4gZ3JvdW5kDQo+ID4gPiA+
IHRoYXQgY2FuIGFsbG93IG1vcmUgcXVldWVzIHRvIGJlIGVuYWJsZWQgKGV4LiBkcml2ZXIgYXNr
ZWQgZm9yDQo+ID4gPiA+IDMwMA0KPiA+ID4gPiB2ZWN0b3JzLCBidXQgZ290IDY4IHZlY3RvcnMs
IHNvIGVuYWJsZWQgNjQgZGF0YSBxdWV1ZXMpIGFuZA0KPiA+ID4gPiB0aGlzDQo+ID4gPiA+IHBh
dGNoDQo+ID4gPiA+IGltcGxlbWVudHMgdGhlIG1pZC1ncm91bmQgbG9naWMuIA0KPiA+ID4gPiAN
Cj4gPiA+ID4gVGhpcyBtaWQtZ3JvdW5kIGxvZ2ljIGNhbiBhbHNvIGJlIGltcGxlbWVudGVkIGJh
c2VkIG9uIHRoZQ0KPiA+ID4gPiByZXR1cm4NCj4gPiA+ID4gdmFsdWUNCj4gPiA+ID4gb2YgcGNp
X2VuYWJsZV9tc2l4X3JhbmdlKCkgYnV0IElNSE8gdGhlIGltcGxlbWVudGF0aW9uIGluIHRoaXMN
Cj4gPiA+ID4gcGF0Y2gNCj4gPiA+ID4gdXNpbmcgcGNpX2VuYWJsZV9tc2l4X2V4YWN0IGlzIGJl
dHRlciBiZWNhdXNlIGl0J3MgYWx3YXlzIG9ubHkNCj4gPiA+ID4gZW5hYmxpbmcvcmVzZXJ2aW5n
IGFzIG1hbnkgTVNJLVggdmVjdG9ycyBhcyByZXF1aXJlZCwgbm90IG1vcmUsDQo+ID4gPiA+IG5v
dA0KPiA+ID4gPiBsZXNzLiAgDQo+ID4gPiANCj4gPiA+IFdoYXQgZG8geW91IG1lYW4gYnkgInJl
cXVpcmVkIiBpbiB0aGUgbGFzdCBzZW50ZW5jZT8gICANCj4gPiANCj4gPiAuLiBhcyAicmVxdWly
ZWQiIGluIHRoYXQgcGFydGljdWxhciBpdGVyYXRpb24gb2YgdGhlIGxvb3AuDQo+ID4gDQo+ID4g
PiBUaGUgZHJpdmVyDQo+ID4gPiByZXF1ZXN0cyBudW1fb25saW5lX2NwdXMoKS13b3J0aCBvZiBJ
UlFzLCBzbyBpdCBtdXN0IHdvcmsgd2l0aA0KPiA+ID4gYW55DQo+ID4gPiBudW1iZXIgb2YgSVJR
cy4gV2h5IGlzIG51bV9jcHVzKCkgLyAxLDIsNCw4ICJyZXF1aXJlZCI/ICANCj4gPiANCj4gPiBM
ZXQgbWUgYmFjayB1cCBhIGJpdCBoZXJlLiANCj4gPiANCj4gPiBVbHRpbWF0ZWx5LCB0aGUgaXNz
dWUgd2UgYXJlIHRyeWluZyB0byBzb2x2ZSBoZXJlIGlzICJ3aGF0IGhhcHBlbnMNCj4gPiB3aGVu
DQo+ID4gdGhlIGRyaXZlciBkb2Vzbid0IGdldCBhcyBtYW55IE1TSS1YIHZlY3RvcnMgYXMgaXQg
bmVlZHMsIGFuZCBob3cNCj4gPiBpdCdzDQo+ID4gaW50ZXJwcmV0ZWQgYnkgdGhlIGVuZCB1c2Vy
Ig0KPiA+IA0KPiA+IExldCdzIHNheSB0aGVyZSBhcmUgdGhlc2UgdHdvIHN5c3RlbXMsIGVhY2gg
d2l0aCAyNTYgY29yZXMgYnV0IHRoZQ0KPiA+IHJlc3BvbnNlIHRvIHBjaV9lbmFibGVfbXNpeF9y
YW5nZSgpIGlzIGRpZmZlcmVudDoNCj4gPiANCj4gPiBTeXN0ZW0gMTogMjU2IGNvcmVzLCBwY2lf
ZW5hYmxlX21zaXhfcmFuZ2UgcmV0dXJucyA3NSB2ZWN0b3JzDQo+ID4gU3lzdGVtIDI6IDI1NiBj
b3JlcywgcGNpX2VuYWJsZV9tc2l4X3JhbmdlIHJldHVybnMgMjIwIHZlY3RvcnMgDQo+ID4gDQo+
ID4gSW4gdGhpcyBjYXNlLCB0aGUgbnVtYmVyIG9mIHF1ZXVlcyB0aGUgdXNlciB3b3VsZCBzZWUg
ZW5hYmxlZCBvbg0KPiA+IGVhY2gNCj4gPiBvZiB0aGVzZSBzeXN0ZW1zIHdvdWxkIGJlIHZlcnkg
ZGlmZmVyZW50ICg3MyBvbiBzeXN0ZW0gMSBhbmQgMjE4IG9uDQo+ID4gc3lzdGVtIDIpLiBUaGlz
IHZhcmlhYmlsdHkgbWFrZXMgaXQgZGlmZmljdWx0IHRvIGRlZmluZSB3aGF0IHRoZQ0KPiA+IGV4
cGVjdGVkIGJlaGF2aW9yIHNob3VsZCBiZSwgYmVjYXVzZSBpdCdzIG5vdCBleGFjdGx5IG9idmlv
dXMgdG8NCj4gPiB0aGUNCj4gPiB1c2VyIGhvdyBtYW55IGZyZWUgTVNJLVggdmVjdG9ycyBhIGdp
dmVuIHN5c3RlbSBoYXMuIEluc3RlYWQsIGlmDQo+ID4gdGhlDQo+ID4gZHJpdmVyIHJlZHVjZWQg
aXQncyBkZW1hbmQgZm9yIHZlY3RvcnMgaW4gYSB3ZWxsIGRlZmluZWQgbWFubmVyDQo+ID4gKG51
bV9jcHVzKCkgLyAxLDIsNCw4KSwgdGhlIHVzZXIgdmlzaWJsZSBkaWZmZXJlbmNlIGJldHdlZW4g
dGhlIHR3bw0KPiA+IHN5c3RlbXMgd291bGRuJ3QgYmUgc28gZHJhc3RpYy4NCj4gPiANCj4gPiBJ
ZiB0aGlzIGlzIHBsYWluIHdyb25nIG9yIGlmIHRoZXJlJ3MgYSBwcmVmZXJyZWQgYXBwcm9hY2gs
IEknZCBiZQ0KPiA+IGhhcHB5DQo+ID4gdG8gZGlzY3VzcyBmdXJ0aGVyLg0KPiANCj4gTGV0J3Mg
c3RpY2sgdG8gdGhlIHN0YW5kYXJkIExpbnV4IHdheSBvZiBoYW5kbGluZyBJUlEgZXhoYXVzdGlv
biwgYW5kDQo+IHJlbHkgb24gcGNpX2VuYWJsZV9tc2l4X3JhbmdlKCkgdG8gcGljayB0aGUgbnVt
YmVyLiBJZiB0aGUgY3VycmVudA0KPiBiZWhhdmlvciBvZiBwY2lfZW5hYmxlX21zaXhfcmFuZ2Uo
KSBpcyBub3cgd2hhdCB1c2VycyB3YW50IHdlIGNhbg0KPiBjaGFuZ2UgaXQuIEVhY2ggZHJpdmVy
IGNyZWF0aW5nIGl0cyBvd24gaGV1cmlzdGljIGlzIHdvcnN0IG9mIGFsbA0KPiBjaG9pY2VzIGFz
IG1vc3QgYnJvd25maWVsZCBkZXBsb3ltZW50cyB3aWxsIGhhdmUgYSBtaXggb2YgTklDcy4NCg0K
T2theSwgd2Ugd2lsbCByZXdvcmsgdGhlIGZhbGxiYWNrIGltcHJvdmVtZW50IGxvZ2ljLg0KDQpK
dXN0IHNvIHlvdSBhcmUgYXdhcmUsIHdlIHdpbGwgYmUgcG9zdGluZyBhIGNvdXBsZSBvZiBidWct
Zml4IHBhdGNoZXMNCnRoYXQgZml4IGlzc3VlcyBhcm91bmQgdGhlIGN1cnJlbnQgZmFsbGJhY2sg
bG9naWMuDQo=
