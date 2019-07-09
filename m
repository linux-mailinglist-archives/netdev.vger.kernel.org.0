Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C905636E2
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 15:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfGINZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 09:25:43 -0400
Received: from mail-eopbgr730073.outbound.protection.outlook.com ([40.107.73.73]:59552
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726047AbfGINZn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jul 2019 09:25:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I2UO8kYnnbXtKD5qMIMbOYdHnWAU6Ef/UI1XueY2urA=;
 b=bTWxDaUhjBIhpUo5BQRfJUtSaKdHXLgUe1fqbl5hRO2K2n1L0nCcRQWg3SJJ/uwbyj4HRPcuR3guxCRXZVsekyMGmfK8GA/GL7yTsWw05x/KfBt3IHflF6LVpGlZ2MKB+bxqKBieYtSKjTcCK/hDAXR864GRBZamV12Vfvhu+k0=
Received: from MN2PR15MB3581.namprd15.prod.outlook.com (52.132.172.94) by
 MN2PR15MB3678.namprd15.prod.outlook.com (52.132.173.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Tue, 9 Jul 2019 13:25:38 +0000
Received: from MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::7d02:e054:fcd1:f7a0]) by MN2PR15MB3581.namprd15.prod.outlook.com
 ([fe80::7d02:e054:fcd1:f7a0%7]) with mapi id 15.20.2052.020; Tue, 9 Jul 2019
 13:25:38 +0000
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
Thread-Index: AQHVNRbZCg2+IkEFUEKEsAEksjW2W6bB5j8AgABgI5A=
Date:   Tue, 9 Jul 2019 13:25:37 +0000
Message-ID: <MN2PR15MB35811151C4A627C0AF364CAC9AF10@MN2PR15MB3581.namprd15.prod.outlook.com>
References: <20190707225328.15852-1-chris.packham@alliedtelesis.co.nz>
 <2298b9eb-100f-6130-60c4-0e5e2c7b84d1@gmail.com>
 <361940337b0d4833a5634ddd1e1896a9@svr-chch-ex1.atlnz.lc>
 <87fd2150548041219fc42bce80b63c9c@svr-chch-ex1.atlnz.lc>
 <b862a74b-9f1e-fb64-0641-550a83b64664@gmail.com>
In-Reply-To: <b862a74b-9f1e-fb64-0641-550a83b64664@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jon.maloy@ericsson.com; 
x-originating-ip: [24.225.233.31]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cafed7e-f39b-42fb-4450-08d70470eee3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR15MB3678;
x-ms-traffictypediagnostic: MN2PR15MB3678:
x-microsoft-antispam-prvs: <MN2PR15MB3678D433105582423EC4D7DD9AF10@MN2PR15MB3678.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0093C80C01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(39860400002)(136003)(346002)(376002)(199004)(189003)(13464003)(7736002)(186003)(2201001)(14444005)(66066001)(99286004)(7696005)(53936002)(102836004)(6246003)(54906003)(25786009)(486006)(256004)(44832011)(8936002)(14454004)(316002)(81156014)(81166006)(26005)(86362001)(8676002)(110136005)(71190400001)(52536014)(229853002)(5660300002)(66946007)(66476007)(6506007)(74316002)(53546011)(11346002)(4326008)(76116006)(2906002)(2501003)(64756008)(66446008)(6116002)(9686003)(66556008)(6436002)(446003)(3846002)(76176011)(68736007)(305945005)(478600001)(55016002)(33656002)(71200400001)(73956011)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR15MB3678;H:MN2PR15MB3581.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: ericsson.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xIHWuHcps/02WHpKmUTzlIR4PyK1gmW3XFuK8xWNWQRwxrH3hnmFLAT0Jy29aoV2YvdI9ACXnHTzwtJCcY9qJnB+X7zHzAWo65GV9ZTTt7ia4YzJQZfye6ric4/gy2mKSb68ZWdlcUImu0agQK/ztmc2CA5PasLmN0HlGmta0kQgOWrqQgphTfE29dcxfDc4m6spalK4LiuWQflGGf055Ty2YFRDJeykJGfwY9JbR8+NZIF8ERezdrv6Olp5VUaaYWhmC0mo6P78LRiphkClY8vjZOtLuFL9g4TrA3A0G59/V0e4dAhKbr9zSMPJHKUiJ6XfXFhPb4hTFn2XiAC8SKpsksMSddqaklVv42YVhfUsV7wqe9TWreCPY37HlVFj+nSFBZkVW9fWEWGrh2aK8r+xnLxTsoJ9wQKwX2yNhYc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cafed7e-f39b-42fb-4450-08d70470eee3
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jul 2019 13:25:38.4185
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jon.maloy@ericsson.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3678
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRXJpYyBEdW1hemV0IDxl
cmljLmR1bWF6ZXRAZ21haWwuY29tPg0KPiBTZW50OiA5LUp1bC0xOSAwMzozMQ0KPiBUbzogQ2hy
aXMgUGFja2hhbSA8Q2hyaXMuUGFja2hhbUBhbGxpZWR0ZWxlc2lzLmNvLm56PjsgRXJpYyBEdW1h
emV0DQo+IDxlcmljLmR1bWF6ZXRAZ21haWwuY29tPjsgSm9uIE1hbG95IDxqb24ubWFsb3lAZXJp
Y3Nzb24uY29tPjsNCj4geWluZy54dWVAd2luZHJpdmVyLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dA0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgdGlwYy1kaXNjdXNzaW9uQGxpc3RzLnNv
dXJjZWZvcmdlLm5ldDsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVj
dDogUmU6IFtQQVRDSF0gdGlwYzogZW5zdXJlIHNrYi0+bG9jayBpcyBpbml0aWFsaXNlZA0KPiAN
Cj4gDQo+IA0KPiBPbiA3LzgvMTkgMTE6MTMgUE0sIENocmlzIFBhY2toYW0gd3JvdGU6DQo+ID4g
T24gOS8wNy8xOSA4OjQzIEFNLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0KPiA+PiBPbiA4LzA3LzE5
IDg6MTggUE0sIEVyaWMgRHVtYXpldCB3cm90ZToNCj4gPj4+DQo+ID4+Pg0KPiA+Pj4gT24gNy84
LzE5IDEyOjUzIEFNLCBDaHJpcyBQYWNraGFtIHdyb3RlOg0KPiA+Pj4+IHRpcGNfbmFtZWRfbm9k
ZV91cCgpIGNyZWF0ZXMgYSBza2IgbGlzdC4gSXQgcGFzc2VzIHRoZSBsaXN0IHRvDQo+ID4+Pj4g
dGlwY19ub2RlX3htaXQoKSB3aGljaCBoYXMgc29tZSBjb2RlIHBhdGhzIHRoYXQgY2FuIGNhbGwN
Cj4gPj4+PiBza2JfcXVldWVfcHVyZ2UoKSB3aGljaCByZWxpZXMgb24gdGhlIGxpc3QtPmxvY2sg
YmVpbmcgaW5pdGlhbGlzZWQuDQo+ID4+Pj4gRW5zdXJlIHRpcGNfbmFtZWRfbm9kZV91cCgpIHVz
ZXMgc2tiX3F1ZXVlX2hlYWRfaW5pdCgpIHNvIHRoYXQgdGhlDQo+ID4+Pj4gbG9jayBpcyBleHBs
aWNpdGx5IGluaXRpYWxpc2VkLg0KPiA+Pj4+DQo+ID4+Pj4gU2lnbmVkLW9mZi1ieTogQ2hyaXMg
UGFja2hhbSA8Y2hyaXMucGFja2hhbUBhbGxpZWR0ZWxlc2lzLmNvLm56Pg0KPiA+Pj4NCj4gPj4+
IEkgd291bGQgcmF0aGVyIGNoYW5nZSB0aGUgZmF1bHR5IHNrYl9xdWV1ZV9wdXJnZSgpIHRvDQo+
ID4+PiBfX3NrYl9xdWV1ZV9wdXJnZSgpDQo+ID4+Pg0KPiA+Pg0KPiA+PiBNYWtlcyBzZW5zZS4g
SSdsbCBsb29rIGF0IHRoYXQgZm9yIHYyLg0KPiA+Pg0KPiA+DQo+ID4gQWN0dWFsbHkgbWF5YmUg
bm90LiB0aXBjX3JjYXN0X3htaXQoKSwgdGlwY19ub2RlX3htaXRfc2tiKCksDQo+ID4gdGlwY19z
ZW5kX2dyb3VwX21zZygpLCBfX3RpcGNfc2VuZG1zZygpLCBfX3RpcGNfc2VuZHN0cmVhbSgpLCBh
bmQNCj4gPiB0aXBjX3NrX3RpbWVvdXQoKSBhbGwgdXNlIHNrYl9xdWV1ZV9oZWFkX2luaXQoKS4g
U28gbXkgb3JpZ2luYWwgY2hhbmdlDQo+ID4gYnJpbmdzIHRpcGNfbmFtZWRfbm9kZV91cCgpIGlu
dG8gbGluZSB3aXRoIHRoZW0uDQo+ID4NCj4gPiBJIHRoaW5rIGl0IHNob3VsZCBiZSBzYWZlIGZv
ciB0aXBjX25vZGVfeG1pdCgpIHRvIHVzZQ0KPiA+IF9fc2tiX3F1ZXVlX3B1cmdlKCkgc2luY2Ug
YWxsIHRoZSBjYWxsZXJzIHNlZW0gdG8gaGF2ZSBleGNsdXNpdmUNCj4gPiBhY2Nlc3MgdG8gdGhl
IGxpc3Qgb2Ygc2ticy4gSXQgc3RpbGwgc2VlbXMgdGhhdCB0aGUgY2FsbGVycyBzaG91bGQgYWxs
DQo+ID4gdXNlDQo+ID4gc2tiX3F1ZXVlX2hlYWRfaW5pdCgpIGZvciBjb25zaXN0ZW5jeS4NCg0K
SSBhZ3JlZSB3aXRoIHRoYXQuDQoNCj4gPg0KPiANCj4gTm8sIHRpcGMgZG9lcyBub3QgdXNlIHRo
ZSBsaXN0IGxvY2sgKGl0IHJlbGllcyBvbiB0aGUgc29ja2V0IGxvY2spICBhbmQgdGhlcmVmb3Jl
DQo+IHNob3VsZCBjb25zaXN0ZW50bHkgdXNlIF9fc2tiX3F1ZXVlX2hlYWRfaW5pdCgpIGluc3Rl
YWQgb2YNCj4gc2tiX3F1ZXVlX2hlYWRfaW5pdCgpDQoNClRJUEMgaXMgdXNpbmcgdGhlIGxpc3Qg
bG9jayBhdCBtZXNzYWdlIHJlY2VwdGlvbiB3aXRoaW4gdGhlIHNjb3BlIG9mIHRpcGNfc2tfcmN2
KCkvdGlwY19za2JfcGVla19wb3J0KCksIHNvIGl0IGlzIGZ1bmRhbWVudGFsIHRoYXQgdGhlIGxv
Y2sgYWx3YXlzIGlzIGNvcnJlY3RseSBpbml0aWFsaXplZC4NCg0KPiANClsuLi5dDQo+IA0KPiB0
aXBjX2xpbmtfeG1pdCgpIGZvciBleGFtcGxlIG5ldmVyIGFjcXVpcmVzIHRoZSBzcGlubG9jaywg
eWV0IHVzZXMgc2tiX3BlZWsoKQ0KPiBhbmQgX19za2JfZGVxdWV1ZSgpDQoNCg0KWW91IHNob3Vs
ZCBsb29rIGF0IHRpcGNfbm9kZV94bWl0IGluc3RlYWQuIE5vZGUgbG9jYWwgbWVzc2FnZXMgYXJl
IHNlbnQgZGlyZWN0bHkgdG8gdGlwY19za19yY3YoKSwgYW5kIG5ldmVyIGdvIHRocm91Z2ggdGlw
Y19saW5rX3htaXQoKQ0KDQpSZWdhcmRzDQovLy9qb24NCg0KDQo=
