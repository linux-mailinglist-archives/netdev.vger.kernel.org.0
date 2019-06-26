Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B74EA563D7
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 09:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFZH5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 03:57:14 -0400
Received: from mail-eopbgr130071.outbound.protection.outlook.com ([40.107.13.71]:17027
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725379AbfFZH5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 03:57:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=B8FL42O6WYsO70UqCDIVI4/Dq6mV5wbO2mVp9qr1bHbPg7hjhhG6fdFdZCYcNeKegVWrNhXhs8ugYvPMd8ZQVWaGHsZqBH63oNrwYRDrXk1xYUqrBdiAZPWv59DpqCjt3Ocq0rWmM9tfAxSx4v5ndg2LMsexMUrgUbS5WpKCZgU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3kQhacehSpdeqvO4AKrsBpoMQvV+UBXt6zInL83GTM=;
 b=MNh35+8V1YpUlPickOj0qvumceZAIM2iSFKo6o4u9DlF3NwsLaIj64KiMd4P4NOmGETV2QB69PLAL2E/qMkXOiOJ8s92G/d5x8j1QOBh1oLSDEa9XIdeq9dPZ73OCO7c5s+H0Z2iyVM2uRUI02yGfZ5KiK3i+/8xjG0Nvy4ORWo=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3kQhacehSpdeqvO4AKrsBpoMQvV+UBXt6zInL83GTM=;
 b=pVPNbupWE383tWvtYkl6/+TGWW4/UH9TXxzZVAsdhR1Pdrr1IX4R9Zcik3d29csXPo5XB4Mdvn3HpXSae+8m4mtYJ2O9udx1J/48f6TrIciRFl/LWis8EywUdAMx3Z/cGuw5TMCAMvEmnKA+UD37PTLNoSs2OczYQUgLPWz+MUU=
Received: from AM5PR0501MB2483.eurprd05.prod.outlook.com (10.169.150.140) by
 AM5PR0501MB2388.eurprd05.prod.outlook.com (10.169.149.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Wed, 26 Jun 2019 07:57:09 +0000
Received: from AM5PR0501MB2483.eurprd05.prod.outlook.com
 ([fe80::3d38:1f3a:a477:c3c9]) by AM5PR0501MB2483.eurprd05.prod.outlook.com
 ([fe80::3d38:1f3a:a477:c3c9%5]) with mapi id 15.20.2008.014; Wed, 26 Jun 2019
 07:57:09 +0000
From:   Idan Burstein <idanb@mellanox.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>,
        Max Gurtovoy <maxg@mellanox.com>
Subject: RE: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Topic: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Index: AQHVK5iv/PlxMrwrIkOzzXe+rsY0A6as3rOAgACxQjA=
Date:   Wed, 26 Jun 2019 07:56:44 +0000
Deferred-Delivery: Wed, 26 Jun 2019 07:56:02 +0000
Message-ID: <AM5PR0501MB248327B260F97EF97CD5B80EC5E20@AM5PR0501MB2483.eurprd05.prod.outlook.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
 <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
In-Reply-To: <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=idanb@mellanox.com; 
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a007067-8a74-4cb0-8d62-08d6fa0be3ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM5PR0501MB2388;
x-ms-traffictypediagnostic: AM5PR0501MB2388:
x-microsoft-antispam-prvs: <AM5PR0501MB238859F354B62E5E2BB35F61C5E20@AM5PR0501MB2388.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(396003)(366004)(39860400002)(346002)(51234002)(189003)(13464003)(199004)(110136005)(305945005)(107886003)(6246003)(66066001)(68736007)(186003)(99286004)(33656002)(64756008)(229853002)(52536014)(476003)(14454004)(8676002)(81156014)(81166006)(6436002)(66476007)(55016002)(53936002)(66446008)(7736002)(9686003)(4326008)(5660300002)(74316002)(446003)(2906002)(256004)(6116002)(76176011)(11346002)(71190400001)(73956011)(486006)(71200400001)(66946007)(54906003)(6636002)(3846002)(76116006)(6666004)(53546011)(66556008)(26005)(7696005)(25786009)(316002)(86362001)(478600001)(102836004)(6506007)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM5PR0501MB2388;H:AM5PR0501MB2483.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cgHDXjxwwxEhXHU/MEc4u9xu+aLuX9BgwDqjbKnJjWJ/JkNENYili0KiWt3CVTWblCkhOj409946tQ+cfyy80GjZkDCdoJde/QjgOlt2+AKQ78DKl1aXb0bImrPsWIxCIVsWMSfm/+wbSkKM6MEkAKGWO5I13qMXqSbFsPPVS+FunUFLDBZ5KK1D6tti+4rwmN+FoVu7kewS81RsEyNy/bHv98Swy51QqQpINUgp6TI5keQ/m+5jvwK91FpkGYdX8exbrowBtJ4tQ/s/lznfuVIQN7g4o9SLKU3ymOZY6hs5VXPdQLtk/A+325ScSUi5lIx+y+XcFov3ZSNxxmcYM18db21sRaUbiTh+bbk0DJ7v/m1GKbhIUYMO3Y62f79retmC9BZgZ2MdUwyb5yOGsZm/kBntQkXxpUyB9fP1VNo=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a007067-8a74-4cb0-8d62-08d6fa0be3ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 07:57:09.3457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: idanb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0501MB2388
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IiBQbGVhc2UgZG9uJ3QuIFRoaXMgaXMgYSBiYWQgY2hvaWNlIHRvIG9wdCBpdCBpbiBieSBkZWZh
dWx0LiINCg0KSSBkaXNhZ3JlZSBoZXJlLiBJJ2QgcHJlZmVyIExpbnV4IHRvIGhhdmUgZ29vZCBv
dXQgb2YgdGhlIGJveCBleHBlcmllbmNlIChlLmcuIHJlYWNoIDEwMEcgaW4gNEsgTlZNZU9GIG9u
IEludGVsIHNlcnZlcnMpIHdpdGggdGhlIGRlZmF1bHQgcGFyYW1ldGVycy4gRXNwZWNpYWxseSBz
aW5jZSBZYW1pbiBoYXZlIHNob3duIGl0IGlzIGJlbmVmaWNpYWwgLyBub3QgaHVydGluZyBpbiB0
ZXJtcyBvZiBwZXJmb3JtYW5jZSBmb3IgdmFyaWV0eSBvZiB1c2UgY2FzZXMuIFRoZSB3aG9sZSBj
b25jZXB0IG9mIERJTSBpcyB0aGF0IGl0IGFkYXB0cyB0byB0aGUgd29ya2xvYWQgcmVxdWlyZW1l
bnRzIGluIHRlcm1zIG9mIGJhbmR3aWR0aCBhbmQgbGF0ZW5jeS4gDQoNCk1vcmVvdmVyLCBuZXQt
ZGltIGlzIGVuYWJsZWQgYnkgZGVmYXVsdCwgSSBkb24ndCBzZWUgd2h5IFJETUEgaXMgZGlmZmVy
ZW50Lg0KDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBsaW51eC1yZG1hLW93
bmVyQHZnZXIua2VybmVsLm9yZyA8bGludXgtcmRtYS1vd25lckB2Z2VyLmtlcm5lbC5vcmc+IE9u
IEJlaGFsZiBPZiBTYWdpIEdyaW1iZXJnDQpTZW50OiBXZWRuZXNkYXksIEp1bmUgMjYsIDIwMTkg
MTI6MTQgQU0NClRvOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT47IERhdmlk
IFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IERvdWcgTGVkZm9yZCA8ZGxlZGZvcmRA
cmVkaGF0LmNvbT47IEphc29uIEd1bnRob3JwZSA8amdnQG1lbGxhbm94LmNvbT4NCkNjOiBMZW9u
IFJvbWFub3Zza3kgPGxlb25yb0BtZWxsYW5veC5jb20+OyBPciBHZXJsaXR6IDxvZ2VybGl0ekBt
ZWxsYW5veC5jb20+OyBUYWwgR2lsYm9hIDx0YWxnaUBtZWxsYW5veC5jb20+OyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZzsgWWFtaW4gRnJpZWRtYW4g
PHlhbWluZkBtZWxsYW5veC5jb20+OyBNYXggR3VydG92b3kgPG1heGdAbWVsbGFub3guY29tPg0K
U3ViamVjdDogUmU6IFtmb3ItbmV4dCBWMiAxMC8xMF0gUkRNQS9jb3JlOiBQcm92aWRlIFJETUEg
RElNIHN1cHBvcnQgZm9yIFVMUHMNCg0KDQoNCj4gK3N0YXRpYyBpbnQgaWJfcG9sbF9kaW1faGFu
ZGxlcihzdHJ1Y3QgaXJxX3BvbGwgKmlvcCwgaW50IGJ1ZGdldCkgew0KPiArCXN0cnVjdCBpYl9j
cSAqY3EgPSBjb250YWluZXJfb2YoaW9wLCBzdHJ1Y3QgaWJfY3EsIGlvcCk7DQo+ICsJc3RydWN0
IGRpbSAqZGltID0gY3EtPmRpbTsNCj4gKwlpbnQgY29tcGxldGVkOw0KPiArDQo+ICsJY29tcGxl
dGVkID0gX19pYl9wcm9jZXNzX2NxKGNxLCBidWRnZXQsIGNxLT53YywgSUJfUE9MTF9CQVRDSCk7
DQo+ICsJaWYgKGNvbXBsZXRlZCA8IGJ1ZGdldCkgew0KPiArCQlpcnFfcG9sbF9jb21wbGV0ZSgm
Y3EtPmlvcCk7DQo+ICsJCWlmIChpYl9yZXFfbm90aWZ5X2NxKGNxLCBJQl9QT0xMX0ZMQUdTKSA+
IDApDQo+ICsJCQlpcnFfcG9sbF9zY2hlZCgmY3EtPmlvcCk7DQo+ICsJfQ0KPiArDQo+ICsJcmRt
YV9kaW0oZGltLCBjb21wbGV0ZWQpOw0KDQpXaHkgZHVwbGljYXRlIHRoZSBlbnRpcmUgdGhpbmcg
Zm9yIGEgb25lLWxpbmVyPw0KDQo+ICsNCj4gKwlyZXR1cm4gY29tcGxldGVkOw0KPiArfQ0KPiAr
DQo+ICAgc3RhdGljIHZvaWQgaWJfY3FfY29tcGxldGlvbl9zb2Z0aXJxKHN0cnVjdCBpYl9jcSAq
Y3EsIHZvaWQgKnByaXZhdGUpDQo+ICAgew0KPiAgIAlpcnFfcG9sbF9zY2hlZCgmY3EtPmlvcCk7
DQo+IEBAIC0xMDUsMTQgKzE1NywxOCBAQCBzdGF0aWMgdm9pZCBpYl9jcV9jb21wbGV0aW9uX3Nv
ZnRpcnEoc3RydWN0IA0KPiBpYl9jcSAqY3EsIHZvaWQgKnByaXZhdGUpDQo+ICAgDQo+ICAgc3Rh
dGljIHZvaWQgaWJfY3FfcG9sbF93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4gICB7
DQo+IC0Jc3RydWN0IGliX2NxICpjcSA9IGNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3QgaWJfY3Es
IHdvcmspOw0KPiArCXN0cnVjdCBpYl9jcSAqY3EgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0
IGliX2NxLA0KPiArCQkJCQl3b3JrKTsNCg0KV2h5IHdhcyB0aGF0IGNoYW5nZWQ/DQoNCj4gICAJ
aW50IGNvbXBsZXRlZDsNCj4gICANCj4gICAJY29tcGxldGVkID0gX19pYl9wcm9jZXNzX2NxKGNx
LCBJQl9QT0xMX0JVREdFVF9XT1JLUVVFVUUsIGNxLT53YywNCj4gICAJCQkJICAgIElCX1BPTExf
QkFUQ0gpOw0KPiArDQoNCm5ld2xpbmU/DQoNCj4gICAJaWYgKGNvbXBsZXRlZCA+PSBJQl9QT0xM
X0JVREdFVF9XT1JLUVVFVUUgfHwNCj4gICAJICAgIGliX3JlcV9ub3RpZnlfY3EoY3EsIElCX1BP
TExfRkxBR1MpID4gMCkNCj4gICAJCXF1ZXVlX3dvcmsoY3EtPmNvbXBfd3EsICZjcS0+d29yayk7
DQo+ICsJZWxzZSBpZiAoY3EtPmRpbSkNCj4gKwkJcmRtYV9kaW0oY3EtPmRpbSwgY29tcGxldGVk
KTsNCj4gICB9DQo+ICAgDQo+ICAgc3RhdGljIHZvaWQgaWJfY3FfY29tcGxldGlvbl93b3JrcXVl
dWUoc3RydWN0IGliX2NxICpjcSwgdm9pZCANCj4gKnByaXZhdGUpIEBAIC0xNjYsNiArMjIyLDgg
QEAgc3RydWN0IGliX2NxICpfX2liX2FsbG9jX2NxX3VzZXIoc3RydWN0IGliX2RldmljZSAqZGV2
LCB2b2lkICpwcml2YXRlLA0KPiAgIAlyZG1hX3Jlc3RyYWNrX3NldF90YXNrKCZjcS0+cmVzLCBj
YWxsZXIpOw0KPiAgIAlyZG1hX3Jlc3RyYWNrX2thZGQoJmNxLT5yZXMpOw0KPiAgIA0KPiArCXJk
bWFfZGltX2luaXQoY3EpOw0KPiArDQo+ICAgCXN3aXRjaCAoY3EtPnBvbGxfY3R4KSB7DQo+ICAg
CWNhc2UgSUJfUE9MTF9ESVJFQ1Q6DQo+ICAgCQljcS0+Y29tcF9oYW5kbGVyID0gaWJfY3FfY29t
cGxldGlvbl9kaXJlY3Q7IEBAIC0xNzMsNyArMjMxLDEzIEBAIA0KPiBzdHJ1Y3QgaWJfY3EgKl9f
aWJfYWxsb2NfY3FfdXNlcihzdHJ1Y3QgaWJfZGV2aWNlICpkZXYsIHZvaWQgKnByaXZhdGUsDQo+
ICAgCWNhc2UgSUJfUE9MTF9TT0ZUSVJROg0KPiAgIAkJY3EtPmNvbXBfaGFuZGxlciA9IGliX2Nx
X2NvbXBsZXRpb25fc29mdGlycTsNCj4gICANCj4gLQkJaXJxX3BvbGxfaW5pdCgmY3EtPmlvcCwg
SUJfUE9MTF9CVURHRVRfSVJRLCBpYl9wb2xsX2hhbmRsZXIpOw0KPiArCQlpZiAoY3EtPmRpbSkg
ew0KPiArCQkJaXJxX3BvbGxfaW5pdCgmY3EtPmlvcCwgSUJfUE9MTF9CVURHRVRfSVJRLA0KPiAr
CQkJCSAgICAgIGliX3BvbGxfZGltX2hhbmRsZXIpOw0KPiArCQl9IGVsc2UNCj4gKwkJCWlycV9w
b2xsX2luaXQoJmNxLT5pb3AsIElCX1BPTExfQlVER0VUX0lSUSwNCj4gKwkJCQkgICAgICBpYl9w
b2xsX2hhbmRsZXIpOw0KPiArDQo+ICAgCQlpYl9yZXFfbm90aWZ5X2NxKGNxLCBJQl9DUV9ORVhU
X0NPTVApOw0KPiAgIAkJYnJlYWs7DQo+ICAgCWNhc2UgSUJfUE9MTF9XT1JLUVVFVUU6DQo+IEBA
IC0yMjYsNiArMjkwLDkgQEAgdm9pZCBpYl9mcmVlX2NxX3VzZXIoc3RydWN0IGliX2NxICpjcSwg
c3RydWN0IGliX3VkYXRhICp1ZGF0YSkNCj4gICAJCVdBUk5fT05fT05DRSgxKTsNCj4gICAJfQ0K
PiAgIA0KPiArCWlmIChjcS0+ZGltKQ0KPiArCQljYW5jZWxfd29ya19zeW5jKCZjcS0+ZGltLT53
b3JrKTsNCj4gKwlrZnJlZShjcS0+ZGltKTsNCj4gICAJa2ZyZWUoY3EtPndjKTsNCj4gICAJcmRt
YV9yZXN0cmFja19kZWwoJmNxLT5yZXMpOw0KPiAgIAlyZXQgPSBjcS0+ZGV2aWNlLT5vcHMuZGVz
dHJveV9jcShjcSwgdWRhdGEpOyBkaWZmIC0tZ2l0IA0KPiBhL2RyaXZlcnMvaW5maW5pYmFuZC9o
dy9tbHg1L21haW4uYyANCj4gYi9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMNCj4g
aW5kZXggYWJhYzcwYWQ1YzdjLi5iMWI0NWRiZTI0YTUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMv
aW5maW5pYmFuZC9ody9tbHg1L21haW4uYw0KPiArKysgYi9kcml2ZXJzL2luZmluaWJhbmQvaHcv
bWx4NS9tYWluLmMNCj4gQEAgLTYzMDUsNiArNjMwNSw4IEBAIHN0YXRpYyBpbnQgbWx4NV9pYl9z
dGFnZV9jYXBzX2luaXQoc3RydWN0IG1seDVfaWJfZGV2ICpkZXYpDQo+ICAgCSAgICAgTUxYNV9D
QVBfR0VOKGRldi0+bWRldiwgZGlzYWJsZV9sb2NhbF9sYl9tYykpKQ0KPiAgIAkJbXV0ZXhfaW5p
dCgmZGV2LT5sYi5tdXRleCk7DQo+ICAgDQo+ICsJZGV2LT5pYl9kZXYudXNlX2NxX2RpbSA9IHRy
dWU7DQo+ICsNCg0KUGxlYXNlIGRvbid0LiBUaGlzIGlzIGEgYmFkIGNob2ljZSB0byBvcHQgaXQg
aW4gYnkgZGVmYXVsdC4NCg==
