Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C06328BDC0
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403900AbgJLQ2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:28:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:41497 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403825AbgJLQ2N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 12:28:13 -0400
IronPort-SDR: tfuxRT02OgZElPeQ0ot6m78mgmFSHt/diTos0oFvdskg8H8mhobUf+JQKNypWp2QC1BHtfskBK
 Z9TyN9PpOGIg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="152694782"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="152694782"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:28:07 -0700
IronPort-SDR: +NxfvKHS9nRdc6upqYYipT3n1byVOLesZgYxSpbuVZ/nX3aKZLTXkPssMVaMhiUfgPLagLd6AL
 hPgGOzJ+IZ1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="344940747"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga004.fm.intel.com with ESMTP; 12 Oct 2020 09:28:06 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 09:28:05 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 09:28:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 09:28:05 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 09:28:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQ4Ag/DZAUFC3XnmEkOa2QXo0ghWLZqk6dWdoUYabv6H11JwlJDAfd0u25aENIwKAAASu7ozeHMl+dmAf2V4k2nN0GB3hVvyuJ+OGb3Dna4QwByjK3Wo4Riwr43GGkiETTr04v8MP/+3c8n6Km1qdhCSnXGtb8qXp9WCbLzE/Efe5HbIDWliTLmqYE4vkzsPuDF+wgGmnD3i1KmTivmkkXYZ1DtvhqGtu16s5s8q/gDbiVJyMftYh0xD5jAOmrNRwhImZJsb94vRs6hA3FfsHIAHdy1C+qdGhgfbXbLO2aDaJuoHg/H8obarHZOL76WNEw6tZ2NLpe+Rluq1lEUT9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ee8VPPAMnoqGBrM/S6ozZICEYs/BXr1an0DO31TuZbw=;
 b=IZyy8tMHsduYXtGxVZPlYp86W7PZkLvZjNVfItELmZYMg9rq8QUbSDjrnux6jSt00GpzFqidBiD5Snb192Bswh+An/g9af5Lt28cR6kVYz0F+ZzA4rG9qLf3MBSGUcc/iBMOouNqltvMdma3JQnEcK9cMCefJweFife/zv36z1XRJ0B4Nv57B8tgeXn0U4VWPxac6LuYecEd816AIwItZ77FTFlnNFRQq6WMAqg0//iZBgeZ7PnORx42M5PA+rLX08zN5ZiIhY5zSbG7U9BlYFPgkTFAA7AqZ+hXhxbUTgRmJ7Gm2Uyjt5l9GI4U8RN6hnoeEnoDGJuM4l+tokp3tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ee8VPPAMnoqGBrM/S6ozZICEYs/BXr1an0DO31TuZbw=;
 b=kg7ZG89gbMWRFrNESD/bF2+GkO4TO3CfBbsgm8mHRiT3abEes7j/Ea6vgNoQlzJeUbn8blcHbnlTFYlKiuIPsPtLPFlWCqPQQRXJ5wo6e0xuKra3XtyqmAStfbxTvc1JPtBhggiydh+osLmeK5jU3OenwMF2skgARRYW11g6SJU=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2847.namprd11.prod.outlook.com (2603:10b6:805:55::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Mon, 12 Oct
 2020 16:27:59 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e%7]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 16:27:59 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [net-next 2/3] i40e: Fix MAC address setting for a VF via Host/VM
Thread-Topic: [net-next 2/3] i40e: Fix MAC address setting for a VF via
 Host/VM
Thread-Index: AQHWnP8ncoJi2TWGMEav32zM+Hnj16mPjkmAgAShAwA=
Date:   Mon, 12 Oct 2020 16:27:58 +0000
Message-ID: <07967f3b63b12a501c83b86befc209769b322c56.camel@intel.com>
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
         <20201007231050.1438704-3-anthony.l.nguyen@intel.com>
         <CA+FuTSfX55yiPHZ-Pf051RqMkKbyvHWT86HFB135Tb4kjm6PjQ@mail.gmail.com>
In-Reply-To: <CA+FuTSfX55yiPHZ-Pf051RqMkKbyvHWT86HFB135Tb4kjm6PjQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f1a4132-4f86-40d8-2eab-08d86ecbc849
x-ms-traffictypediagnostic: SN6PR11MB2847:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2847E373DBD94C8812F723EBC6070@SN6PR11MB2847.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 37xLfZyfHXl7BYQzKoJTRVPsbDfFAEvsG6ZM9VW2JQ30uxiGuZc10xY2ZNOcSutsMVP+K2O7/eOK7g4IQPref8uoLz3PPm6J0xx+MQ5u19JoUkgPAhmr3bSqAnPMLezoY68RuI/ut4CVFiaHXHwjBQ+LzVcUFwVEa0fz8iBQ8mGDs3SnnuIcSJtzl70qiHOXAU+IrvMyxQrx1aLIOqBIXodXohUy8o6dTvp6W9sZb1qRHd8TaKBSRDjrPvlADlsZL6XiD5Ahs2KppppXyb0jJcwr4lOuoAtXz1eewhSaS6ovwr6dGLrEHNrb5iXaGUMYZC2oNsfWZcIrV96eLsxyOVuamTqAiNSWMWSGn1njdVoK4j/+WZ6MbplB9puSVcxC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(376002)(136003)(39860400002)(6506007)(8676002)(6486002)(83380400001)(8936002)(54906003)(5660300002)(86362001)(36756003)(2616005)(6916009)(53546011)(186003)(26005)(66946007)(478600001)(66476007)(76116006)(91956017)(66556008)(64756008)(4326008)(316002)(66446008)(71200400001)(2906002)(6512007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: bphA4Ziey6+eSezHebUDY/5XrALQo9v2AbzGguoBht6N0WzaxHSTfy7KJdvnPWtZY4aFFijAdqTsueXqWjWtcyuxhwOKIb4JsJ03KMEIcJZjN1/yOdnyq5k9Jws6X8iJgsQN2iRCqORMyRgQzcMIyxZIZQx4Q696rnoNUgMcM97y/RFNQRte25cAjGK0KzT7cBwSMjECRkAI+eOQqcNzm9jG1RpEabkaKBPfYPRKkuRKMBHv+2czQdxtY+pHL7JLrOamroJV3Ht9w79Zy29Fpu3LrY4xcuHId/gh/pbCVNGwxM02hNhAC6PG9ihUhXqhlKysuIATVackLHpYTSM7cDgZgoWzQHlS2jVy5OD/VBxsUowVzxAxkPUkIxwOpTDdx4OLmaIRHmnU6nQhbzu+gsMO/uJlN9VrFnSyFg4RY8uanMCokJDqWqVyk8mXJVbg4VElvFFaIL7z78iL0phYf4kIVYFLJZNbT6L369iHMH4kweEGnoGPkYJXdJL2D4vTK+swWmEDdFf3KZqMPPIjp+3GJ//cTz8W4IDnJTJnB0vTwgkADxxkqsZjupoUZ6Wz8LlYNFiPuwa4cHfmZhlcQ/kqxu25DLEcjQZjfnTOSp/C6yVbKU/X/NMa54d/04eiZhdv81PrsrDAm0vw+na76w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EC359FB7C32D74982D9C9E86B88F674@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1a4132-4f86-40d8-2eab-08d86ecbc849
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 16:27:58.9181
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJ+3grgcn8D8TahHNoci4ft7IwVxT4ccMDrDCYp0SEhJlo/DikfNjn3zYyRH9S3yQFKKxuy4AwKHYyW9wFE/eOs2qkwy6l9y3GxVFwaKiPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2847
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDEzOjQ2IC0wNDAwLCBXaWxsZW0gZGUgQnJ1aWpuIHdyb3Rl
Og0KPiBPbiBXZWQsIE9jdCA3LCAyMDIwIGF0IDc6MTEgUE0gVG9ueSBOZ3V5ZW4gPA0KPiBhbnRo
b255Lmwubmd1eWVuQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gRnJvbTogQWxla3NhbmRy
IExva3Rpb25vdiA8YWxla3NhbmRyLmxva3Rpb25vdkBpbnRlbC5jb20+DQo+ID4gDQo+ID4gRml4
IE1BQyBzZXR0aW5nIGZsb3cgZm9yIHRoZSBQRiBkcml2ZXIuDQo+ID4gDQo+ID4gV2l0aG91dCB0
aGlzIGNoYW5nZSB0aGUgTUFDIGFkZHJlc3Mgc2V0dGluZyB3YXMgaW50ZXJwcmV0ZWQNCj4gPiBp
bmNvcnJlY3RseSBpbiB0aGUgZm9sbG93aW5nIHVzZSBjYXNlczoNCj4gPiAxKSBQcmludCBpbmNv
cnJlY3QgVkYgTUFDIG9yIHplcm8gTUFDDQo+ID4gaXAgbGluayBzaG93IGRldiAkcGYNCj4gPiAy
KSBEb24ndCBwcmVzZXJ2ZSBNQUMgYmV0d2VlbiBkcml2ZXIgcmVsb2FkDQo+ID4gcm1tb2QgaWF2
ZjsgbW9kcHJvYmUgaWF2Zg0KPiA+IDMpIFVwZGF0ZSBWRiBNQUMgd2hlbiBtYWN2bGFuIHdhcyBz
ZXQNCj4gPiBpcCBsaW5rIGFkZCBsaW5rICR2ZiBhZGRyZXNzICRtYWMgJHZmLjEgdHlwZSBtYWN2
bGFuDQo+ID4gNCkgRmFpbGVkIHRvIHVwZGF0ZSBtYWMgYWRkcmVzcyB3aGVuIFZGIHdhcyB0cnVz
dGVkDQo+ID4gaXAgbGluayBzZXQgZGV2ICR2ZiBhZGRyZXNzICRtYWMNCj4gPiANCj4gPiBUaGlz
IGluY2x1ZGVzIGFsbCBvdGhlciBjb25maWd1cmF0aW9ucyBpbmNsdWRpbmcgYWJvdmUgY29tbWFu
ZHMuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogQWxla3NhbmRyIExva3Rpb25vdiA8YWxla3Nh
bmRyLmxva3Rpb25vdkBpbnRlbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogQXJrYWRpdXN6IEt1
YmFsZXdza2kgPGFya2FkaXVzei5rdWJhbGV3c2tpQGludGVsLmNvbQ0KPiA+ID4NCj4gPiBUZXN0
ZWQtYnk6IEFuZHJldyBCb3dlcnMgPGFuZHJld3guYm93ZXJzQGludGVsLmNvbT4NCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBUb255IE5ndXllbiA8YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+DQo+IA0K
PiBJZiB0aGlzIGlzIGEgZml4LCBzaG91bGQgaXQgdGFyZ2V0IG5ldCBhbmQvb3IgaXMgdGhlcmUg
YSBjb21taXQgZm9yIGENCj4gRml4ZXMgdGFnPw0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcgV2ls
bGVtLiBJIHdpbGwgYWRkIGEgZml4ZXMgdGFnIGFuZCBzZW5kIGl0IHRvDQpuZXQuDQoNCj4gPiBA
QCAtMjc0MCw2ICsyNzQ0LDcgQEAgc3RhdGljIGludCBpNDBlX3ZjX2RlbF9tYWNfYWRkcl9tc2co
c3RydWN0DQo+ID4gaTQwZV92ZiAqdmYsIHU4ICptc2cpDQo+ID4gIHsNCj4gPiAgICAgICAgIHN0
cnVjdCB2aXJ0Y2hubF9ldGhlcl9hZGRyX2xpc3QgKmFsID0NCj4gPiAgICAgICAgICAgICAoc3Ry
dWN0IHZpcnRjaG5sX2V0aGVyX2FkZHJfbGlzdCAqKW1zZzsNCj4gPiArICAgICAgIGJvb2wgd2Fz
X3VuaW1hY19kZWxldGVkID0gZmFsc2U7DQo+ID4gICAgICAgICBzdHJ1Y3QgaTQwZV9wZiAqcGYg
PSB2Zi0+cGY7DQo+ID4gICAgICAgICBzdHJ1Y3QgaTQwZV92c2kgKnZzaSA9IE5VTEw7DQo+ID4g
ICAgICAgICBpNDBlX3N0YXR1cyByZXQgPSAwOw0KPiA+IEBAIC0yNzU5LDYgKzI3NjQsOCBAQCBz
dGF0aWMgaW50IGk0MGVfdmNfZGVsX21hY19hZGRyX21zZyhzdHJ1Y3QNCj4gPiBpNDBlX3ZmICp2
ZiwgdTggKm1zZykNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICByZXQgPSBJNDBFX0VSUl9J
TlZBTElEX01BQ19BRERSOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gZXJyb3Jf
cGFyYW07DQo+ID4gICAgICAgICAgICAgICAgIH0NCj4gPiArICAgICAgICAgICAgICAgaWYgKGV0
aGVyX2FkZHJfZXF1YWwoYWwtPmxpc3RbaV0uYWRkciwgdmYtDQo+ID4gPmRlZmF1bHRfbGFuX2Fk
ZHIuYWRkcikpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgd2FzX3VuaW1hY19kZWxldGVk
ID0gdHJ1ZTsNCj4gPiAgICAgICAgIH0NCj4gPiAgICAgICAgIHZzaSA9IHBmLT52c2lbdmYtPmxh
bl92c2lfaWR4XTsNCj4gPiANCj4gPiBAQCAtMjc3OSwxMCArMjc4NiwyNSBAQCBzdGF0aWMgaW50
IGk0MGVfdmNfZGVsX21hY19hZGRyX21zZyhzdHJ1Y3QNCj4gPiBpNDBlX3ZmICp2ZiwgdTggKm1z
ZykNCj4gPiAgICAgICAgICAgICAgICAgZGV2X2VycigmcGYtPnBkZXYtPmRldiwgIlVuYWJsZSB0
byBwcm9ncmFtIFZGICVkDQo+ID4gTUFDIGZpbHRlcnMsIGVycm9yICVkXG4iLA0KPiA+ICAgICAg
ICAgICAgICAgICAgICAgICAgIHZmLT52Zl9pZCwgcmV0KTsNCj4gPiANCj4gPiArICAgICAgIGlm
ICh2Zi0+dHJ1c3RlZCAmJiB3YXNfdW5pbWFjX2RlbGV0ZWQpIHsNCj4gPiArICAgICAgICAgICAg
ICAgc3RydWN0IGk0MGVfbWFjX2ZpbHRlciAqZjsNCj4gPiArICAgICAgICAgICAgICAgc3RydWN0
IGhsaXN0X25vZGUgKmg7DQo+ID4gKyAgICAgICAgICAgICAgIHU4ICptYWNhZGRyID0gTlVMTDsN
Cj4gPiArICAgICAgICAgICAgICAgaW50IGJrdDsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAg
IC8qIHNldCBsYXN0IHVuaWNhc3QgbWFjIGFkZHJlc3MgYXMgZGVmYXVsdCAqLw0KPiA+ICsgICAg
ICAgICAgICAgICBzcGluX2xvY2tfYmgoJnZzaS0+bWFjX2ZpbHRlcl9oYXNoX2xvY2spOw0KPiA+
ICsgICAgICAgICAgICAgICBoYXNoX2Zvcl9lYWNoX3NhZmUodnNpLT5tYWNfZmlsdGVyX2hhc2gs
IGJrdCwgaCwgZiwNCj4gPiBobGlzdCkgew0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgIGlm
IChpc192YWxpZF9ldGhlcl9hZGRyKGYtPm1hY2FkZHIpKQ0KPiA+ICsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgbWFjYWRkciA9IGYtPm1hY2FkZHI7DQo+IA0KPiBuaXQ6IGNvdWxkIGJy
ZWFrIGhlcmUNCg0KV2lsbCBhZGQgdGhlIGJyZWFrLg0KDQpUaGFua3MsDQpUb255DQo=
