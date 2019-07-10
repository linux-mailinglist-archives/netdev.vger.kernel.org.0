Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7877A646D2
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfGJNK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:10:27 -0400
Received: from mail-eopbgr760077.outbound.protection.outlook.com ([40.107.76.77]:3330
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725911AbfGJNK0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 09:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uNrj1a1xYvEEXWxnOymMfWoNPV1ydUCOXhYmBgDN0mk=;
 b=VC17AU38W9eu5MH0bKu1ckwvnUjPXBUpXZENq3BJgyiXpM02IoNuwXjrjVK9r4YH/0fuHN6yk31T+U5t+7a7ksB0Taq5vDGeR7DZ0cnkX5QJ9YfA7zpX6o46cKCBhBHZs/ZX9ZVY4KQLNEChYzTwwtkSWNTG+rpVyaqelcFKevo=
Received: from MN2PR15MB3581.namprd15.prod.outlook.com (52.132.172.94) by
 MN2PR15MB2573.namprd15.prod.outlook.com (20.179.145.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.19; Wed, 10 Jul 2019 13:10:20 +0000
Received: from MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::7d02:e054:fcd1:f7a0]) by MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::7d02:e054:fcd1:f7a0%7]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 13:10:20 +0000
From:   Jon Maloy <jon.maloy@ericsson.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] tipc: ensure skb->lock is initialised
Thread-Topic: [PATCH] tipc: ensure skb->lock is initialised
Thread-Index: AQHVNRbZCg2+IkEFUEKEsAEksjW2W6bB5j8AgABgI5CAAAiXAIAAV45AgADaXgCAAFK8kA==
Date:   Wed, 10 Jul 2019 13:10:20 +0000
Message-ID: <MN2PR15MB3581E1D6D56D6AA7DE8E357E9AF00@MN2PR15MB3581.namprd15.prod.outlook.com>
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
 <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
 <361940337b0d4833a5634ddd1e1896a9@svr-chch-ex1.atlnz.lc>
 <87fd2150548041219fc42bce80b63c9c@svr-chch-ex1.atlnz.lc>
 <b862a74b-9f1e-fb64-0641-550a83b64664@gmail.com>
 <MN2PR15MB35811151C4A627C0AF364CAC9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
 <ef9a2ec1-1413-e8f9-1193-d53cf8ee52ba@gmail.com>
 <MN2PR15MB35813EA3ADE7E5E83A657D3F9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
 <e7606e76-8a0a-dab7-4561-f44f98d90164@gmail.com>
In-Reply-To: <e7606e76-8a0a-dab7-4561-f44f98d90164@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c73ea754-390a-4c3c-4086-08d70537f641
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR15MB2573;
x-ms-traffictypediagnostic: MN2PR15MB2573:
x-microsoft-antispam-prvs: <MN2PR15MB2573CFFE79BF43FD1EF22FB29AF00@MN2PR15MB2573.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(39860400002)(396003)(376002)(199004)(189003)(13464003)(446003)(66946007)(4326008)(68736007)(86362001)(486006)(25786009)(76116006)(478600001)(66476007)(66556008)(2501003)(14454004)(44832011)(11346002)(476003)(110136005)(2201001)(229853002)(71200400001)(2906002)(256004)(5660300002)(14444005)(54906003)(305945005)(3846002)(66446008)(52536014)(81166006)(81156014)(7696005)(316002)(6436002)(55016002)(76176011)(66066001)(53546011)(53936002)(6246003)(64756008)(99286004)(7736002)(186003)(6506007)(8936002)(26005)(102836004)(74316002)(8676002)(33656002)(6116002)(71190400001)(9686003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR15MB2573;H:MN2PR15MB3581.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: JUiaAR3oDbftQWyZ4TOOqLibn0r/hHI7CvFnK2SQvzEejDsVTUAFC2DZ/KiOXaK4u9kPdhUAWTqyhsIezNHBOkNH5uaK6FrBeovDmccyNDT+55f4PVjLc/curdg3RE18uAeHDNYaN9uN2sjFLWNHk/Y/FOYDz4tjFyTtGplY4ejVd/Wo/GECpW2T5FxsI29v35L7WYVCBbAepxMGFDs2ml7U3XAvfd9vSdKGMDTueSqKJ9l4c0aQzKg7CxtJqWfaTdYWixtRapcNyA8p0w/d72uOHpEnlO7wHVwPbSMjopdZnL+Wyulaq0cjgo3Lgwjp9INTa562Zff8h7Cfr6YRxoFahHqqhZjmaJKEquLybi1JUKKXSvmMJ8sFAHRSf/OHO6PG3DCCpw9oDE2/lO+wsn/2aDkkjRk5HC88E0i0cvU=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c73ea754-390a-4c3c-4086-08d70537f641
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 13:10:20.6767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB2573
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
cmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiBTZW50OiAxMC1KdWwtMTkgMDQ6MDANCj4gVG86IEpv
biBNYWxveSA8am9uLm1hbG95QGVyaWNzc29uLmNvbT47IEVyaWMgRHVtYXpldA0KPiA8ZXJpYy5k
dW1hemV0QGdtYWlsLmNvbT47IENocmlzIFBhY2toYW0NCj4gPENocmlzLlBhY2toYW1AYWxsaWVk
dGVsZXNpcy5jby5uej47IHlpbmcueHVlQHdpbmRyaXZlci5jb207DQo+IGRhdmVtQGRhdmVtbG9m
dC5uZXQNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHRpcGMtZGlzY3Vzc2lvbkBsaXN0
cy5zb3VyY2Vmb3JnZS5uZXQ7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0hdIHRpcGM6IGVuc3VyZSBza2ItPmxvY2sgaXMgaW5pdGlhbGlzZWQN
Cj4gDQo+IA0KPiANCj4gT24gNy85LzE5IDEwOjE1IFBNLCBKb24gTWFsb3kgd3JvdGU6DQo+ID4N
Cj4gPiBJdCBpcyBub3Qgb25seSBmb3IgbG9ja2RlcCBwdXJwb3NlcywgLWl0IGlzIGVzc2VudGlh
bC4gIEJ1dCBwbGVhc2UgcHJvdmlkZSBkZXRhaWxzDQo+IGFib3V0IHdoZXJlIHlvdSBzZWUgdGhh
dCBtb3JlIGZpeGVzIGFyZSBuZWVkZWQuDQo+ID4NCj4gDQo+IFNpbXBsZSBmYWN0IHRoYXQgeW91
IGRldGVjdCBhIHByb2JsZW0gb25seSB3aGVuIHNrYl9xdWV1ZV9wdXJnZSgpIGlzIGNhbGxlZA0K
PiBzaG91bGQgdGFsayBieSBpdHNlbGYuDQo+IA0KPiBBcyBJIHN0YXRlZCwgdGhlcmUgYXJlIG1h
bnkgcGxhY2VzIHdoZXJlIHRoZSBsaXN0IGlzIG1hbmlwdWxhdGVkIF93aXRob3V0XyBpdHMNCj4g
c3BpbmxvY2sgYmVpbmcgaGVsZC4NCg0KWWVzLCBhbmQgdGhhdCBpcyB0aGUgd2F5IGl0IHNob3Vs
ZCBiZSBvbiB0aGUgc2VuZCBwYXRoLg0KDQo+IA0KPiBZb3Ugd2FudCBjb25zaXN0ZW5jeSwgdGhl
bg0KPiANCj4gLSBncmFiIHRoZSBzcGlubG9jayBhbGwgdGhlIHRpbWUuDQo+IC0gT3IgZG8gbm90
IGV2ZXIgdXNlIGl0Lg0KDQpUaGF0IGlzIGV4YWN0bHkgd2hhdCB3ZSBhcmUgZG9pbmcuIA0KLSBU
aGUgc2VuZCBwYXRoIGRvZXNuJ3QgbmVlZCB0aGUgc3BpbmxvY2ssIGFuZCBuZXZlciBncmFicyBp
dC4NCi0gVGhlIHJlY2VpdmUgcGF0aCBkb2VzIG5lZWQgaXQsIGFuZCBhbHdheXMgZ3JhYnMgaXQu
DQoNCkhvd2V2ZXIsIHNpbmNlIHdlIGRvbid0IGtub3cgZnJvbSB0aGUgYmVnaW5uaW5nIHdoaWNo
IHBhdGggYSBjcmVhdGVkIG1lc3NhZ2Ugd2lsbCBmb2xsb3csIHdlIGluaXRpYWxpemUgdGhlIHF1
ZXVlIHNwaW5sb2NrICJqdXN0IGluIGNhc2UiIHdoZW4gaXQgaXMgY3JlYXRlZCwgZXZlbiB0aG91
Z2ggaXQgbWF5IG5ldmVyIGJlIHVzZWQgbGF0ZXIuDQpZb3UgY2FuIHNlZSB0aGlzIGFzIGEgdmlv
bGF0aW9uIG9mIHRoZSBwcmluY2lwbGUgeW91IGFyZSBzdGF0aW5nIGFib3ZlLCBidXQgaXQgaXMg
YSBwcml6ZSB0aGF0IGlzIHdvcnRoIHBheWluZywgZ2l2ZW4gc2F2aW5ncyBpbiBjb2RlIHZvbHVt
ZSwgY29tcGxleGl0eSBhbmQgcGVyZm9ybWFuY2UuDQoNCj4gDQo+IERvIG5vdCBpbml0aWFsaXpl
IHRoZSBzcGlubG9jayBqdXN0IGluIGNhc2UgYSBwYXRoIHdpbGwgdXNlIHNrYl9xdWV1ZV9wdXJn
ZSgpDQo+IChpbnN0ZWFkIG9mIHVzaW5nIF9fc2tiX3F1ZXVlX3B1cmdlKCkpDQoNCkkgYW0gb2sg
d2l0aCB0aGF0LiBJIHRoaW5rIHdlIGNhbiBhZ3JlZSB0aGF0IENocmlzIGdvZXMgZm9yIHRoYXQg
c29sdXRpb24sIHNvIHdlIGNhbiBnZXQgdGhpcyBidWcgZml4ZWQuDQoNCi8vL2pvbg0KDQoNCg==
