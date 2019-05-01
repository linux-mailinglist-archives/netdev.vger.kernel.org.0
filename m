Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEAA10826
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726295AbfEANLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:11:15 -0400
Received: from mail-eopbgr150088.outbound.protection.outlook.com ([40.107.15.88]:45829
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbfEANLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 09:11:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddf+hT/XaEz4d8a5EwvJp8XUoRQ2rM+W/ihgUacjPCI=;
 b=l4IvDXIsa0Y5g04QhMzpaabvzDaCLCo8jUG6jrIhqgA4aOM8U1pCyOsBE6N0ElimCnnE3f4u+o/I9DnmGul8S8968m3ea045zx3N81J72XBcawgUNOUdIt/iiYtzwMsfMnnYUXg4QAuFxpeSF9v7EQZqRes+JyzuRZemfMDk0zg=
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com (52.133.38.142) by
 AM0PR0502MB3859.eurprd05.prod.outlook.com (52.133.45.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Wed, 1 May 2019 13:11:11 +0000
Received: from AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::c978:d8d3:5678:4488]) by AM0PR0502MB4068.eurprd05.prod.outlook.com
 ([fe80::c978:d8d3:5678:4488%3]) with mapi id 15.20.1835.018; Wed, 1 May 2019
 13:11:11 +0000
From:   Eran Ben Elisha <eranbe@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@mellanox.com>
Subject: Re: [Patch net-next] net: add a generic tracepoint for TX queue
 timeout
Thread-Topic: [Patch net-next] net: add a generic tracepoint for TX queue
 timeout
Thread-Index: AQHU/4WXqnR2U0+BOEq21MTF+mLa56ZWP6IA
Date:   Wed, 1 May 2019 13:11:11 +0000
Message-ID: <68f5b7e3-4022-edd4-8d18-752b3dfc500f@mellanox.com>
References: <20190430185009.20456-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20190430185009.20456-1-xiyou.wangcong@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0123.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::28) To AM0PR0502MB4068.eurprd05.prod.outlook.com
 (2603:10a6:208:d::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=eranbe@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f6790ecb-aa0b-447e-2e9d-08d6ce367b36
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR0502MB3859;
x-ms-traffictypediagnostic: AM0PR0502MB3859:
x-microsoft-antispam-prvs: <AM0PR0502MB38599E2ED88D8A5925B2A0BFBA3B0@AM0PR0502MB3859.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00246AB517
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(346002)(136003)(39860400002)(189003)(199004)(8936002)(52116002)(76176011)(478600001)(86362001)(31696002)(316002)(99286004)(81166006)(256004)(81156014)(110136005)(14454004)(14444005)(3846002)(6116002)(2906002)(2501003)(66556008)(71190400001)(4326008)(66066001)(66446008)(31686004)(64756008)(66476007)(66946007)(8676002)(6512007)(71200400001)(476003)(5660300002)(186003)(229853002)(102836004)(68736007)(26005)(6506007)(386003)(53936002)(446003)(11346002)(53546011)(486006)(2616005)(36756003)(305945005)(107886003)(25786009)(7736002)(6246003)(6436002)(73956011)(6486002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR0502MB3859;H:AM0PR0502MB4068.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XJIgy+GSxDGNLumYs70m1BVsUJnVV6nGFjX5bo+JzRf8OmqT7fJ/3r3xpQczdH22odHWaQk9rRKaY3hm8tcBQDlU8Wv9u6VKloiZYPLNsnlr6NE4so7F2zlU2SUdB9Lx0kUKVB2HaYDFcicpKGhE7cYUv0Vxt8PfxXu3xhbMDzzgakiMSsmDOX4Wf/MUpPiFVH5leKk89hDuWDFWkmdgph3YRNrpNAXol5mSpkfnwP0jItatDBiiwdKlsa3CGir78jmKsUkK4/X82cHuT9I4EiO4PPFlXAuGS0/PGlO6lrtX/NhqdrvJ+RrgKfdjEBLH7Bc5mMos4/dJaA4hWjRDMaAn6TxlOdI2/ihJ4anbvj/09lqjQwi2JgivdiTdjoTI0kqhayiyljraEEo9CNRMbGXNzmDqunHkKFpFHMxammg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <24AE34C1A02FD34CA5D75A6A39F49E4A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6790ecb-aa0b-447e-2e9d-08d6ce367b36
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 May 2019 13:11:11.3050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3859
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDQvMzAvMjAxOSA5OjUwIFBNLCBDb25nIFdhbmcgd3JvdGU6DQo+IEFsdGhvdWdoIGRl
dmxpbmsgaGVhbHRoIHJlcG9ydCBkb2VzIGEgbmljZSBqb2Igb24gcmVwb3J0aW5nIFRYDQo+IHRp
bWVvdXQgYW5kIG90aGVyIE5JQyBlcnJvcnMsIHVuZm9ydHVuYXRlbHkgaXQgcmVxdWlyZXMgZHJp
dmVycw0KPiB0byBzdXBwb3J0IGl0IGJ1dCBjdXJyZW50bHkgb25seSBtbHg1IGhhcyBpbXBsZW1l
bnRlZCBpdC4NCg0KVGhlIGRldmxpbmsgaGVhbHRoIHdhcyBuZXZlciBpbnRlbmRlZCB0byBiZSB0
aGUgZ2VuZXJpYyBtZWNoYW5pc20gZm9yIA0KbW9uaXRvcmluZyBhbGwgZHJpdmVyJ3MgVFggdGlt
ZW91dHMgbm90aWZpY2F0aW9ucy4gbWx4NWUgZHJpdmVyIGNob3NlIHRvIA0KaGFuZGxlIFRYIHRp
bWVvdXQgbm90aWZpY2F0aW9uIGJ5IHJlcG9ydGluZyBpdCB0byB0aGUgbmV3bHkgZGV2bGluayAN
CmhlYWx0aCBtZWNoYW5pc20uDQoNCj4gQmVmb3JlIG90aGVyIGRyaXZlcnMgY291bGQgY2F0Y2gg
dXAsIGl0IGlzIHVzZWZ1bCB0byBoYXZlIGENCj4gZ2VuZXJpYyB0cmFjZXBvaW50IHRvIG1vbml0
b3IgdGhpcyBraW5kIG9mIFRYIHRpbWVvdXQuIFdlIGhhdmUNCj4gYmVlbiBzdWZmZXJpbmcgVFgg
dGltZW91dCB3aXRoIGRpZmZlcmVudCBkcml2ZXJzLCB3ZSBwbGFuIHRvDQo+IHN0YXJ0IHRvIG1v
bml0b3IgaXQgd2l0aCByYXNkYWVtb24gd2hpY2gganVzdCBuZWVkcyBhIG5ldyB0cmFjZXBvaW50
Lg0KDQpHcmVhdCBpZGVhIHRvIHN1Z2dlc3QgYSBnZW5lcmljIHRyYWNlIG1lc3NhZ2UgdGhhdCBj
YW4gYmUgbW9uaXRvcmVkIG92ZXIgDQphbGwgZHJpdmVycy4NCg0KPiANCj4gU2FtcGxlIG91dHB1
dDoNCj4gDQo+ICAgIGtzb2Z0aXJxZC8xLTE2ICAgIFswMDFdIC4uczIgICAxNDQuMDQzMTczOiBu
ZXRfZGV2X3htaXRfdGltZW91dDogZGV2PWVuczMgZHJpdmVyPWUxMDAwIHF1ZXVlPTANCj4gDQo+
IENjOiBFcmFuIEJlbiBFbGlzaGEgPGVyYW5iZUBtZWxsYW5veC5jb20+DQo+IENjOiBKaXJpIFBp
cmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogQ29uZyBXYW5nIDx4aXlv
dS53YW5nY29uZ0BnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIGluY2x1ZGUvdHJhY2UvZXZlbnRzL25l
dC5oIHwgMjMgKysrKysrKysrKysrKysrKysrKysrKysNCj4gICBuZXQvc2NoZWQvc2NoX2dlbmVy
aWMuYyAgICB8ICAyICsrDQo+ICAgMiBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspDQo+
IA0KPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS90cmFjZS9ldmVudHMvbmV0LmggYi9pbmNsdWRlL3Ry
YWNlL2V2ZW50cy9uZXQuaA0KPiBpbmRleCAxZWZkN2Q5YjI1ZmUuLjAwMmQ2ZjA0YjllNSAxMDA2
NDQNCj4gLS0tIGEvaW5jbHVkZS90cmFjZS9ldmVudHMvbmV0LmgNCj4gKysrIGIvaW5jbHVkZS90
cmFjZS9ldmVudHMvbmV0LmgNCj4gQEAgLTMwMyw2ICszMDMsMjkgQEAgREVGSU5FX0VWRU5UKG5l
dF9kZXZfcnhfZXhpdF90ZW1wbGF0ZSwgbmV0aWZfcmVjZWl2ZV9za2JfbGlzdF9leGl0LA0KPiAg
IAlUUF9BUkdTKHJldCkNCj4gICApOw0KPiAgIA0KDQpJIHdvdWxkIGhhdmUgcHV0IHRoaXMgbmV4
dCB0byBuZXRfZGV2X3htaXQgdHJhY2UgZXZlbnQgZGVjbGFyYXRpb24uDQoNCj4gK1RSQUNFX0VW
RU5UKG5ldF9kZXZfeG1pdF90aW1lb3V0LA0KPiArDQo+ICsJVFBfUFJPVE8oc3RydWN0IG5ldF9k
ZXZpY2UgKmRldiwNCj4gKwkJIGludCBxdWV1ZV9pbmRleCksDQo+ICsNCj4gKwlUUF9BUkdTKGRl
diwgcXVldWVfaW5kZXgpLA0KPiArDQo+ICsJVFBfU1RSVUNUX19lbnRyeSgNCj4gKwkJX19zdHJp
bmcoCW5hbWUsCQlkZXYtPm5hbWUJKQ0KPiArCQlfX3N0cmluZygJZHJpdmVyLAkJbmV0ZGV2X2Ry
aXZlcm5hbWUoZGV2KSkNCj4gKwkJX19maWVsZCgJaW50LAkJcXVldWVfaW5kZXgJKQ0KPiArCSks
DQo+ICsNCj4gKwlUUF9mYXN0X2Fzc2lnbigNCj4gKwkJX19hc3NpZ25fc3RyKG5hbWUsIGRldi0+
bmFtZSk7DQo+ICsJCV9fYXNzaWduX3N0cihkcml2ZXIsIG5ldGRldl9kcml2ZXJuYW1lKGRldikp
Ow0KPiArCQlfX2VudHJ5LT5xdWV1ZV9pbmRleCA9IHF1ZXVlX2luZGV4Ow0KPiArCSksDQo+ICsN
Cj4gKwlUUF9wcmludGsoImRldj0lcyBkcml2ZXI9JXMgcXVldWU9JWQiLA0KPiArCQlfX2dldF9z
dHIobmFtZSksIF9fZ2V0X3N0cihkcml2ZXIpLCBfX2VudHJ5LT5xdWV1ZV9pbmRleCkNCj4gKyk7
DQo+ICsNCj4gICAjZW5kaWYgLyogX1RSQUNFX05FVF9IICovDQo+ICAgDQo+ICAgLyogVGhpcyBw
YXJ0IG11c3QgYmUgb3V0c2lkZSBwcm90ZWN0aW9uICovDQo+IGRpZmYgLS1naXQgYS9uZXQvc2No
ZWQvc2NoX2dlbmVyaWMuYyBiL25ldC9zY2hlZC9zY2hfZ2VuZXJpYy5jDQo+IGluZGV4IDg0OGFh
YjM2OTNiZC4uY2NlMWU5ZWU4NWFmIDEwMDY0NA0KPiAtLS0gYS9uZXQvc2NoZWQvc2NoX2dlbmVy
aWMuYw0KPiArKysgYi9uZXQvc2NoZWQvc2NoX2dlbmVyaWMuYw0KPiBAQCAtMzIsNiArMzIsNyBA
QA0KPiAgICNpbmNsdWRlIDxuZXQvcGt0X3NjaGVkLmg+DQo+ICAgI2luY2x1ZGUgPG5ldC9kc3Qu
aD4NCj4gICAjaW5jbHVkZSA8dHJhY2UvZXZlbnRzL3FkaXNjLmg+DQo+ICsjaW5jbHVkZSA8dHJh
Y2UvZXZlbnRzL25ldC5oPg0KPiAgICNpbmNsdWRlIDxuZXQveGZybS5oPg0KPiAgIA0KPiAgIC8q
IFFkaXNjIHRvIHVzZSBieSBkZWZhdWx0ICovDQo+IEBAIC00NDEsNiArNDQyLDcgQEAgc3RhdGlj
IHZvaWQgZGV2X3dhdGNoZG9nKHN0cnVjdCB0aW1lcl9saXN0ICp0KQ0KPiAgIAkJCX0NCj4gICAN
Cj4gICAJCQlpZiAoc29tZV9xdWV1ZV90aW1lZG91dCkgew0KPiArCQkJCXRyYWNlX25ldF9kZXZf
eG1pdF90aW1lb3V0KGRldiwgaSk7DQo+ICAgCQkJCVdBUk5fT05DRSgxLCBLRVJOX0lORk8gIk5F
VERFViBXQVRDSERPRzogJXMgKCVzKTogdHJhbnNtaXQgcXVldWUgJXUgdGltZWQgb3V0XG4iLA0K
PiAgIAkJCQkgICAgICAgZGV2LT5uYW1lLCBuZXRkZXZfZHJpdmVybmFtZShkZXYpLCBpKTsNCj4g
ICAJCQkJZGV2LT5uZXRkZXZfb3BzLT5uZG9fdHhfdGltZW91dChkZXYpOw0KPiANCg==
