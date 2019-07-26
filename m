Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2EF774E5
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 01:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfGZXS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 19:18:56 -0400
Received: from mail-eopbgr40079.outbound.protection.outlook.com ([40.107.4.79]:45588
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726216AbfGZXSz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 19:18:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xy0S9uuI7PINDKW9GCx9pTXzEDj9BXSzMYeUnfAeUPSEJrZ9Z2Fn1BO8+yGxE2iT3v4WFhLssDGr3DrBLCejV54vzD6NabsGvLBR7PMN64stfsQ0rpZQZRgak+Dbl6K0OS4IoV1VzAn38xi3llIRSUywxsB/PaKPYr9Brw+xGSF93vdrqEYfKGsEnKjsyYogYB+IMxmirbSfw3sqsR4P4vDtLCl39AF/QuoxEwXIw9ApWNWUKJ5Q1CTigSrkb3xooMAmqUJyM8oQJ1XswvegSirygclYYCljX79RBmvV9/LBs2/yFsjD9MIl6VifHERToPWdbXC7kil/NxdwPuPnwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfC6F+lmijp5lbPw2YKcgU2NxPN/dPcwWl9922SCaGQ=;
 b=T8Rdp5PZWgOogEZjg9fIRJAY/cECcydUoGJeh9u4TUZ6M6GhmkKrTY7n8O4X3fKBE1M5Nq3tp98o3CUu71QK3zITxxQljG/clNpJiWiDu2fxGB1uVW0E+bq+w8dghxkFdBkqnaH09pv6ukrH3BVkWzvAP9fObaJAXwdEWTFKNyFlpWzBv1S3ywMKj2C9vaIjWZmboIAZCeCk0DUw88zJ1rji8YoSYP5dUrXECLb0VpaKqLYPEJvaSqzzLOKYBYLc9qwlbzCU16+uCh03A26cZ4e9E1EuKgAZ2FbD8iRedSNoSVdi+ppd0X7zeUKvY+AJ6FWKO6SzzSaMocHYPtJsVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TfC6F+lmijp5lbPw2YKcgU2NxPN/dPcwWl9922SCaGQ=;
 b=bTFgWpvmZSk9vxcUg9z0MXgnvlUNsNAbXCsoUmMuy8a+9ZmrIbiqbGdIe7pJoi98KaCNLMPvWNfpDkFNNugAA2H6+PhbNgbn6yiJIJBJIwS8maUycYo7HXItCeLpZFIUXrmah7ZIDQ1pRBR6WGaHOu6UpBr/3mXdKc52jn0cJtI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2326.eurprd05.prod.outlook.com (10.168.55.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Fri, 26 Jul 2019 23:18:48 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 23:18:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linyunsheng@huawei.com" <linyunsheng@huawei.com>,
        "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 08/11] net: hns3: add interrupt affinity support
 for misc interrupt
Thread-Topic: [PATCH net-next 08/11] net: hns3: add interrupt affinity support
 for misc interrupt
Thread-Index: AQHVQc7h8LVK7WWOpUSCTT2iQP99HabaJ1aAgABv4QCAAvYcgA==
Date:   Fri, 26 Jul 2019 23:18:48 +0000
Message-ID: <fa9b747119c2e7acb1ef5f139c022402cd2c854d.camel@mellanox.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
         <1563938327-9865-9-git-send-email-tanhuazhong@huawei.com>
         <67b32cdc72c0be03622e78899ac518d807ca7b85.camel@mellanox.com>
         <db2d081f-b892-b141-7fa5-44e66dd97eb9@huawei.com>
In-Reply-To: <db2d081f-b892-b141-7fa5-44e66dd97eb9@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e795e9b1-6ea5-4eea-02e5-08d7121f9d0f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2326;
x-ms-traffictypediagnostic: DB6PR0501MB2326:
x-microsoft-antispam-prvs: <DB6PR0501MB232681FC4D106DE173AFB27ABEC00@DB6PR0501MB2326.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(199004)(189003)(6512007)(2616005)(58126008)(6436002)(110136005)(4326008)(316002)(86362001)(478600001)(118296001)(2201001)(68736007)(66946007)(53546011)(8676002)(66066001)(76176011)(66446008)(7736002)(2906002)(36756003)(64756008)(6246003)(6506007)(76116006)(14454004)(54906003)(229853002)(3846002)(6486002)(8936002)(53936002)(5660300002)(446003)(66556008)(102836004)(91956017)(256004)(81166006)(81156014)(71190400001)(11346002)(14444005)(26005)(486006)(186003)(99286004)(71200400001)(2501003)(476003)(305945005)(6116002)(25786009)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2326;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZIB6U1OvHVrXUQVAaRM/iQinnRjZvhuFY9cZbEtbEhCm+9nWK3WoPuB8mRY8TfOIkE5y7ZTJ4C1oo/d2ad0BzzD31hE2G0DQJZmZ2oKZxKTOdOQCglrsiwDhDRTDws/Vr2fZnHf1nMZOjulhPbFuU13TUSwjVqnF+6DN+dYqBsKvYph0cTKo9gS+4hMFG3cVsmP8/v47H6ZtA30oBhVX3CslZuj3Isn1tA3/UgyldsyvZKY8zxNpGmpW1DPn4u+MuqtRUYvbwnya1X3XdDgzcpAiKODytnfuX6sx9IKMVYdPTjTh8dBRsHC0fbYlncM5m/BiT9Dwz0aVxBpisbYIxri7Qi+cBbiU94qyKXzaQvmIQwpF3rWs9UiXO+WKx9JULJkiEwjjwP1c/sN67nVYWEgjYwxV9OK7izB/3jd8B+I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73A99BE7BD9751499AF6B7EC92C4B369@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e795e9b1-6ea5-4eea-02e5-08d7121f9d0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 23:18:48.3427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2326
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDEwOjA1ICswODAwLCBZdW5zaGVuZyBMaW4gd3JvdGU6DQo+
IE9uIDIwMTkvNy8yNSAzOjI0LCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBPbiBXZWQsIDIw
MTktMDctMjQgYXQgMTE6MTggKzA4MDAsIEh1YXpob25nIFRhbiB3cm90ZToNCj4gPiA+IEZyb206
IFl1bnNoZW5nIExpbiA8bGlueXVuc2hlbmdAaHVhd2VpLmNvbT4NCj4gPiA+IA0KDQpbLi4uXQ0K
PiA+ID4gDQo+ID4gPiArc3RhdGljIHZvaWQgaGNsZ2VfaXJxX2FmZmluaXR5X25vdGlmeShzdHJ1
Y3QgaXJxX2FmZmluaXR5X25vdGlmeQ0KPiA+ID4gKm5vdGlmeSwNCj4gPiA+ICsJCQkJICAgICAg
Y29uc3QgY3B1bWFza190ICptYXNrKQ0KPiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IGhjbGdlX2Rl
diAqaGRldiA9IGNvbnRhaW5lcl9vZihub3RpZnksIHN0cnVjdCBoY2xnZV9kZXYsDQo+ID4gPiAr
CQkJCQkgICAgICBhZmZpbml0eV9ub3RpZnkpOw0KPiA+ID4gKw0KPiA+ID4gKwljcHVtYXNrX2Nv
cHkoJmhkZXYtPmFmZmluaXR5X21hc2ssIG1hc2spOw0KPiA+ID4gKwlkZWxfdGltZXJfc3luYygm
aGRldi0+c2VydmljZV90aW1lcik7DQo+ID4gPiArCWhkZXYtPnNlcnZpY2VfdGltZXIuZXhwaXJl
cyA9IGppZmZpZXMgKyBIWjsNCj4gPiA+ICsJYWRkX3RpbWVyX29uKCZoZGV2LT5zZXJ2aWNlX3Rp
bWVyLCBjcHVtYXNrX2ZpcnN0KCZoZGV2LQ0KPiA+ID4gPiBhZmZpbml0eV9tYXNrKSk7DQo+ID4g
PiArfQ0KPiA+IA0KPiA+IEkgZG9uJ3Qgc2VlIGFueSByZWxhdGlvbiBiZXR3ZWVuIHlvdXIgbWlz
YyBpcnEgdmVjdG9yIGFuZCAmaGRldi0NCj4gPiA+IHNlcnZpY2VfdGltZXIsIHRvIG1lIHRoaXMg
bG9va3MgbGlrZSBhbiBhYnVzZSBvZiB0aGUgaXJxIGFmZmluaXR5DQo+ID4gPiBBUEkNCj4gPiB0
byBhbGxvdyB0aGUgdXNlciB0byBtb3ZlIHRoZSBzZXJ2aWNlIHRpbWVyIGFmZmluaXR5Lg0KPiAN
Cj4gSGksIHRoYW5rcyBmb3IgcmV2aWV3aW5nLg0KPiANCj4gaGRldi0+c2VydmljZV90aW1lciBp
cyB1c2VkIHRvIHNjaGVkdWxlIHRoZSBwZXJpb2RpYyB3b3JrDQo+IHF1ZXVlIGhkZXYtPnNlcnZp
Y2VfdGFza++8jCB3ZSB3YW50IGFsbCB0aGUgbWFuYWdlbWVudCB3b3JrDQo+IHF1ZXVlIGluY2x1
ZGluZyBoZGV2LT5zZXJ2aWNlX3Rhc2sgdG8gYmluZCB0byB0aGUgc2FtZSBjcHUNCj4gdG8gaW1w
cm92ZSBjYWNoZSBhbmQgcG93ZXIgZWZmaWNpZW5jeSwgaXQgaXMgYmV0dGVyIHRvIG1vdmUNCj4g
c2VydmljZSB0aW1lciBhZmZpbml0eSBhY2NvcmRpbmcgdG8gdGhhdC4NCj4gDQo+IFRoZSBoZGV2
LT5zZXJ2aWNlX3Rhc2sgaXMgY2hhbmdlZCB0byBkZWxheSB3b3JrIHF1ZXVlIGluDQo+IG5leHQg
cGF0Y2ggIiBuZXQ6IGhuczM6IG1ha2UgaGNsZ2Vfc2VydmljZSB1c2UgZGVsYXllZCB3b3JrcXVl
dWUiLA0KPiBTbyB0aGUgYWZmaW5pdHkgaW4gdGhlIHRpbWVyIG9mIHRoZSBkZWxheSB3b3JrIHF1
ZXVlIGlzIGF1dG9tYXRpY2FsbHkNCj4gc2V0IHRvIHRoZSBhZmZpbml0eSBvZiB0aGUgZGVsYXkg
d29yayBxdWV1ZSwgd2Ugd2lsbCBtb3ZlIHRoZQ0KPiAibWFrZSBoY2xnZV9zZXJ2aWNlIHVzZSBk
ZWxheWVkIHdvcmtxdWV1ZSIgcGF0Y2ggYmVmb3JlIHRoZQ0KPiAiYWRkIGludGVycnVwdCBhZmZp
bml0eSBzdXBwb3J0IGZvciBtaXNjIGludGVycnVwdCIgcGF0Y2gsIHNvDQo+IHdlIGRvIG5vdCBo
YXZlIHRvIHNldCBzZXJ2aWNlIHRpbWVyIGFmZmluaXR5IGV4cGxpY2l0bHkuDQo+IA0KPiBBbHNv
LCBUaGVyZSBpcyB0aGVyZSB3b3JrIHF1ZXVlcyhtYnhfc2VydmljZV90YXNrLCBzZXJ2aWNlX3Rh
c2ssDQo+IHJzdF9zZXJ2aWNlX3Rhc2spIGluIHRoZSBobnMzIGRyaXZlciwgd2UgcGxhbiB0byBj
b21iaW5lIHRoZW0NCj4gdG8gb25lIG9yIHR3byB3b3JrcXVldWUgdG8gaW1wcm92ZSBlZmZpY2ll
bmN5IGFuZCByZWFkYWJpbGl0eS4NCj4gDQoNClNvIGp1c3QgdG8gbWFrZSBpdCBjbGVhciwgeW91
IGhhdmUgMyBkZWZlcnJlZCB3b3JrcywgMiBhcmUgdHJpZ2dlcmVkIGJ5DQp0aGUgbWlzYyBpcnEg
YW5kIDEgaXMgcGVyaW9kaWMsIHlvdSB3YW50IHRoZW0gYWxsIG9uIHRoZSBzYW1lIGNvcmUgYW5k
DQp5b3Ugd2FudCB0byBjb250cm9sIHRoZWlyIGFmZmluaXR5IHZpYSB0aGUgaXJxIGFmZmluaXR5
ID8gZm9yIHdvcmtzICMxDQphbmQgICMyIHlvdSBnZXQgdGhhdCBmb3IgZnJlZSBzaW5jZSB0aGUg
aXJxIGlzIHRyaWdnZXJpbmcgdGhlbSwgYnV0IGZvcg0Kd29yayAjMyAodGhlIHBlcmlvZGljIG9u
ZSkgeW91IG5lZWQgdG8gbWFudWFsbHkgbW92ZSBpdCB3aGVuIHRoZSBpcnENCmFmZmluaXR5IGNo
YW5nZXMuDQoNCkkgZ3Vlc3MgaSBhbSBvayB3aXRoIHRoaXMsIHNpbmNlIG1vdmluZyB0aGUgaXJx
IGFmZmluaXR5IGlzbid0IG9ubHkNCnJlcXVpcmVkIGJ5IHRoZSBwZXJpb2RpYyB3b3JrIGJ1dCBh
bHNvIGZvciB0aGUgb3RoZXIgd29ya3MgdGhhdCB0aGUgaXJxDQppcyBhY3R1YWxseSB0cmlnZ2Vy
aW5nIChzbyBpdCBpcyBub3QgYW4gYWN0dWFsIGFidXNlLCBzb3J0IG9mIC4uICkNCg0KDQoNCg==
