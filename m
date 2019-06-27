Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8928057B66
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 07:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbfF0F2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 01:28:34 -0400
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:29664
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfF0F2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 01:28:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXH8is6chbZ+zCaR5wo19TiMSMpzSnIE6aPc/76ck0U=;
 b=H0rjpOFczfs2aqqIhpUpdZxNWSGTP/LNKCyf/Z/ldAvI7jTIp+j+lhyA8vA/VuYScekYPz31q540R09stBLn0R6Cwv20MaCFKSeUFUggRE/CFloFZpd4Sp4QfYssJpZ4vbbAK3vyOZY0mAsCBLElqZZV2s9U6k9rY4Ng9ZYOP70=
Received: from AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) by
 AM4PR0501MB2642.eurprd05.prod.outlook.com (10.172.215.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.17; Thu, 27 Jun 2019 05:28:29 +0000
Received: from AM4PR0501MB2257.eurprd05.prod.outlook.com
 ([fe80::4d19:2bbc:edde:4baf]) by AM4PR0501MB2257.eurprd05.prod.outlook.com
 ([fe80::4d19:2bbc:edde:4baf%7]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 05:28:29 +0000
From:   Yamin Friedman <yaminf@mellanox.com>
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
        Max Gurtovoy <maxg@mellanox.com>
Subject: Re: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Topic: [for-next V2 10/10] RDMA/core: Provide RDMA DIM support for ULPs
Thread-Index: AQHVK5ipk0L0aWPJ8Ui4sRWOVz16m6as3rOAgAIcZQA=
Date:   Thu, 27 Jun 2019 05:28:29 +0000
Message-ID: <690d58a0-df81-c02f-e46d-863ca8c3236e@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-11-saeedm@mellanox.com>
 <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
In-Reply-To: <adb3687a-6db3-b1a4-cd32-8b4889550c81@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0217.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::13) To AM4PR0501MB2257.eurprd05.prod.outlook.com
 (2603:10a6:200:50::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yaminf@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5aff8f04-6879-452d-faba-08d6fac04966
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2642;
x-ms-traffictypediagnostic: AM4PR0501MB2642:
x-microsoft-antispam-prvs: <AM4PR0501MB264280C99205A6ECD48B9464B1FD0@AM4PR0501MB2642.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(346002)(366004)(51234002)(199004)(189003)(31686004)(186003)(14454004)(4326008)(110136005)(478600001)(25786009)(7736002)(107886003)(26005)(11346002)(54906003)(66556008)(446003)(229853002)(6116002)(2616005)(53936002)(3846002)(66946007)(68736007)(64756008)(66476007)(66446008)(316002)(73956011)(256004)(8676002)(71190400001)(71200400001)(52116002)(81156014)(81166006)(31696002)(86362001)(2906002)(99286004)(305945005)(386003)(53546011)(66066001)(6506007)(6512007)(36756003)(486006)(102836004)(6486002)(476003)(6636002)(6246003)(5660300002)(76176011)(8936002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2642;H:AM4PR0501MB2257.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BaLI3mTBWcF4TiGGGhNKj4x5VJd1hHCu9PzxKmBgx2fLpMVzYuHXryr0JJDErRw+z+oyVXT8kfc3mcNvtFdqOA8ilAWj7NJdqx0SFzzCBTiRc6mVAfzbyw0eIBxiaprVW62ctqRhTkTYsOV2zz2nDumWdJ7G2VDJbWmfz6IEogmHShpaAuAoq0Vy3W2ylaWihOo3bye3mGxsUUN3TBY6IqcTXCW1gdjlmZAaeQ/LfmLXfywY1QG7jzHghQCnuyaCwS0yHXM1d8JT5FaKAHO6KFPlU1uIkbELYD3VOifFV2KC7BqoF+qpEmZoO8lzu8hBt9yFN6XfaTNTAm0KsqLrWnAaYKgwRd4jWFFQjvqeMaKZfBYx+jTAvWptNrnGvikC4hSEbN08TtcfnrgabUM1qggarzDYSapmS0siYXPKrH0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5242F2890C15CB4CA7C2BFECF0AF01AD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aff8f04-6879-452d-faba-08d6fac04966
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 05:28:29.5967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yaminf@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2642
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzI2LzIwMTkgMTI6MTQgQU0sIFNhZ2kgR3JpbWJlcmcgd3JvdGU6DQo+DQo+DQo+PiAr
c3RhdGljIGludCBpYl9wb2xsX2RpbV9oYW5kbGVyKHN0cnVjdCBpcnFfcG9sbCAqaW9wLCBpbnQg
YnVkZ2V0KQ0KPj4gK3sNCj4+ICvCoMKgwqAgc3RydWN0IGliX2NxICpjcSA9IGNvbnRhaW5lcl9v
Zihpb3AsIHN0cnVjdCBpYl9jcSwgaW9wKTsNCj4+ICvCoMKgwqAgc3RydWN0IGRpbSAqZGltID0g
Y3EtPmRpbTsNCj4+ICvCoMKgwqAgaW50IGNvbXBsZXRlZDsNCj4+ICsNCj4+ICvCoMKgwqAgY29t
cGxldGVkID0gX19pYl9wcm9jZXNzX2NxKGNxLCBidWRnZXQsIGNxLT53YywgSUJfUE9MTF9CQVRD
SCk7DQo+PiArwqDCoMKgIGlmIChjb21wbGV0ZWQgPCBidWRnZXQpIHsNCj4+ICvCoMKgwqDCoMKg
wqDCoCBpcnFfcG9sbF9jb21wbGV0ZSgmY3EtPmlvcCk7DQo+PiArwqDCoMKgwqDCoMKgwqAgaWYg
KGliX3JlcV9ub3RpZnlfY3EoY3EsIElCX1BPTExfRkxBR1MpID4gMCkNCj4+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGlycV9wb2xsX3NjaGVkKCZjcS0+aW9wKTsNCj4+ICvCoMKgwqAgfQ0KPj4g
Kw0KPj4gK8KgwqDCoCByZG1hX2RpbShkaW0sIGNvbXBsZXRlZCk7DQo+DQo+IFdoeSBkdXBsaWNh
dGUgdGhlIGVudGlyZSB0aGluZyBmb3IgYSBvbmUtbGluZXI/DQpZb3UgYXJlIHJpZ2h0LCB0aGlz
IHdhcyBsZWZ0b3ZlciBmcm9tIGEgcHJldmlvdXMgdmVyc2lvbiB3aGVyZSB0aGVyZSANCndlcmUg
bW9yZSBzaWduaWZpY2FudCBjaGFuZ2VzLiBJIHdpbGwgcmVtb3ZlIHRoZSBleHRyYSBmdW5jdGlv
bi4NCj4NCj4+ICsNCj4+ICvCoMKgwqAgcmV0dXJuIGNvbXBsZXRlZDsNCj4+ICt9DQo+PiArDQo+
PiDCoCBzdGF0aWMgdm9pZCBpYl9jcV9jb21wbGV0aW9uX3NvZnRpcnEoc3RydWN0IGliX2NxICpj
cSwgdm9pZCAqcHJpdmF0ZSkNCj4+IMKgIHsNCj4+IMKgwqDCoMKgwqAgaXJxX3BvbGxfc2NoZWQo
JmNxLT5pb3ApOw0KPj4gQEAgLTEwNSwxNCArMTU3LDE4IEBAIHN0YXRpYyB2b2lkIGliX2NxX2Nv
bXBsZXRpb25fc29mdGlycShzdHJ1Y3QgDQo+PiBpYl9jcSAqY3EsIHZvaWQgKnByaXZhdGUpDQo+
PiDCoCDCoCBzdGF0aWMgdm9pZCBpYl9jcV9wb2xsX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3
b3JrKQ0KPj4gwqAgew0KPj4gLcKgwqDCoCBzdHJ1Y3QgaWJfY3EgKmNxID0gY29udGFpbmVyX29m
KHdvcmssIHN0cnVjdCBpYl9jcSwgd29yayk7DQo+PiArwqDCoMKgIHN0cnVjdCBpYl9jcSAqY3Eg
PSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IGliX2NxLA0KPj4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHdvcmspOw0KPg0KPiBXaHkgd2FzIHRoYXQgY2hhbmdlZD8N
Cg0KSSB3aWxsIGZpeCB0aGlzLg0KDQo+DQo+PiDCoMKgwqDCoMKgIGludCBjb21wbGV0ZWQ7DQo+
PiDCoCDCoMKgwqDCoMKgIGNvbXBsZXRlZCA9IF9faWJfcHJvY2Vzc19jcShjcSwgSUJfUE9MTF9C
VURHRVRfV09SS1FVRVVFLCANCj4+IGNxLT53YywNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBJQl9QT0xMX0JBVENIKTsNCj4+ICsNCj4NCj4gbmV3bGluZT8N
Cg0KU2FtZSBhcyBhYm92ZS4NCg0KPg0KPj4gwqDCoMKgwqDCoCBpZiAoY29tcGxldGVkID49IElC
X1BPTExfQlVER0VUX1dPUktRVUVVRSB8fA0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIGliX3JlcV9u
b3RpZnlfY3EoY3EsIElCX1BPTExfRkxBR1MpID4gMCkNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBx
dWV1ZV93b3JrKGNxLT5jb21wX3dxLCAmY3EtPndvcmspOw0KPj4gK8KgwqDCoCBlbHNlIGlmIChj
cS0+ZGltKQ0KPj4gK8KgwqDCoMKgwqDCoMKgIHJkbWFfZGltKGNxLT5kaW0sIGNvbXBsZXRlZCk7
DQo+PiDCoCB9DQo+PiDCoCDCoCBzdGF0aWMgdm9pZCBpYl9jcV9jb21wbGV0aW9uX3dvcmtxdWV1
ZShzdHJ1Y3QgaWJfY3EgKmNxLCB2b2lkIA0KPj4gKnByaXZhdGUpDQo+PiBAQCAtMTY2LDYgKzIy
Miw4IEBAIHN0cnVjdCBpYl9jcSAqX19pYl9hbGxvY19jcV91c2VyKHN0cnVjdCBpYl9kZXZpY2Ug
DQo+PiAqZGV2LCB2b2lkICpwcml2YXRlLA0KPj4gwqDCoMKgwqDCoCByZG1hX3Jlc3RyYWNrX3Nl
dF90YXNrKCZjcS0+cmVzLCBjYWxsZXIpOw0KPj4gwqDCoMKgwqDCoCByZG1hX3Jlc3RyYWNrX2th
ZGQoJmNxLT5yZXMpOw0KPj4gwqAgK8KgwqDCoCByZG1hX2RpbV9pbml0KGNxKTsNCj4+ICsNCj4+
IMKgwqDCoMKgwqAgc3dpdGNoIChjcS0+cG9sbF9jdHgpIHsNCj4+IMKgwqDCoMKgwqAgY2FzZSBJ
Ql9QT0xMX0RJUkVDVDoNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoCBjcS0+Y29tcF9oYW5kbGVyID0g
aWJfY3FfY29tcGxldGlvbl9kaXJlY3Q7DQo+PiBAQCAtMTczLDcgKzIzMSwxMyBAQCBzdHJ1Y3Qg
aWJfY3EgKl9faWJfYWxsb2NfY3FfdXNlcihzdHJ1Y3QgDQo+PiBpYl9kZXZpY2UgKmRldiwgdm9p
ZCAqcHJpdmF0ZSwNCj4+IMKgwqDCoMKgwqAgY2FzZSBJQl9QT0xMX1NPRlRJUlE6DQo+PiDCoMKg
wqDCoMKgwqDCoMKgwqAgY3EtPmNvbXBfaGFuZGxlciA9IGliX2NxX2NvbXBsZXRpb25fc29mdGly
cTsNCj4+IMKgIC3CoMKgwqDCoMKgwqDCoCBpcnFfcG9sbF9pbml0KCZjcS0+aW9wLCBJQl9QT0xM
X0JVREdFVF9JUlEsIGliX3BvbGxfaGFuZGxlcik7DQo+PiArwqDCoMKgwqDCoMKgwqAgaWYgKGNx
LT5kaW0pIHsNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlycV9wb2xsX2luaXQoJmNxLT5p
b3AsIElCX1BPTExfQlVER0VUX0lSUSwNCj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgaWJfcG9sbF9kaW1faGFuZGxlcik7DQo+PiArwqDCoMKgwqDCoMKgwqAg
fSBlbHNlDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpcnFfcG9sbF9pbml0KCZjcS0+aW9w
LCBJQl9QT0xMX0JVREdFVF9JUlEsDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGliX3BvbGxfaGFuZGxlcik7DQo+PiArDQo+PiDCoMKgwqDCoMKgwqDCoMKg
wqAgaWJfcmVxX25vdGlmeV9jcShjcSwgSUJfQ1FfTkVYVF9DT01QKTsNCj4+IMKgwqDCoMKgwqDC
oMKgwqDCoCBicmVhazsNCj4+IMKgwqDCoMKgwqAgY2FzZSBJQl9QT0xMX1dPUktRVUVVRToNCj4+
IEBAIC0yMjYsNiArMjkwLDkgQEAgdm9pZCBpYl9mcmVlX2NxX3VzZXIoc3RydWN0IGliX2NxICpj
cSwgc3RydWN0IA0KPj4gaWJfdWRhdGEgKnVkYXRhKQ0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgIFdB
Uk5fT05fT05DRSgxKTsNCj4+IMKgwqDCoMKgwqAgfQ0KPj4gwqAgK8KgwqDCoCBpZiAoY3EtPmRp
bSkNCj4+ICvCoMKgwqDCoMKgwqDCoCBjYW5jZWxfd29ya19zeW5jKCZjcS0+ZGltLT53b3JrKTsN
Cj4+ICvCoMKgwqAga2ZyZWUoY3EtPmRpbSk7DQo+PiDCoMKgwqDCoMKgIGtmcmVlKGNxLT53Yyk7
DQo+PiDCoMKgwqDCoMKgIHJkbWFfcmVzdHJhY2tfZGVsKCZjcS0+cmVzKTsNCj4+IMKgwqDCoMKg
wqAgcmV0ID0gY3EtPmRldmljZS0+b3BzLmRlc3Ryb3lfY3EoY3EsIHVkYXRhKTsNCj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMgDQo+PiBiL2RyaXZlcnMv
aW5maW5pYmFuZC9ody9tbHg1L21haW4uYw0KPj4gaW5kZXggYWJhYzcwYWQ1YzdjLi5iMWI0NWRi
ZTI0YTUgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL2luZmluaWJhbmQvaHcvbWx4NS9tYWluLmMN
Cj4+ICsrKyBiL2RyaXZlcnMvaW5maW5pYmFuZC9ody9tbHg1L21haW4uYw0KPj4gQEAgLTYzMDUs
NiArNjMwNSw4IEBAIHN0YXRpYyBpbnQgbWx4NV9pYl9zdGFnZV9jYXBzX2luaXQoc3RydWN0IA0K
Pj4gbWx4NV9pYl9kZXYgKmRldikNCj4+IMKgwqDCoMKgwqDCoMKgwqDCoMKgIE1MWDVfQ0FQX0dF
TihkZXYtPm1kZXYsIGRpc2FibGVfbG9jYWxfbGJfbWMpKSkNCj4+IMKgwqDCoMKgwqDCoMKgwqDC
oCBtdXRleF9pbml0KCZkZXYtPmxiLm11dGV4KTsNCj4+IMKgICvCoMKgwqAgZGV2LT5pYl9kZXYu
dXNlX2NxX2RpbSA9IHRydWU7DQo+PiArDQo+DQo+IFBsZWFzZSBkb24ndC4gVGhpcyBpcyBhIGJh
ZCBjaG9pY2UgdG8gb3B0IGl0IGluIGJ5IGRlZmF1bHQuDQo=
