Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E8A4C7DC
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 09:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbfFTHHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 03:07:12 -0400
Received: from mail-eopbgr30083.outbound.protection.outlook.com ([40.107.3.83]:3590
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbfFTHHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 03:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zeSNjYlA6QH4c3HM42jlKgrI5kW2umtF+XqY2HVdudA=;
 b=IZ60QUj2SezKQZ7YqGD/DuMCj6GKp8/pxersFz6Grh+WFVss4JvZVkv7w1XV5YWYyhEaLTm79VTQrXthXhajhfPY8Mm3hB1nGj4ZksFNf8hXpoBWHFUsdSaXPmn8sTVdBCwAblCbHjy4b5ubPL9t9kZBXEvQwW76UPjMPJMRfUE=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3492.eurprd05.prod.outlook.com (10.171.187.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 20 Jun 2019 07:07:07 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::1180:59ab:b53a:a27f%3]) with mapi id 15.20.1987.014; Thu, 20 Jun 2019
 07:07:07 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Topic: [PATCH net-next 1/3] net/sched: Introduce action ct
Thread-Index: AQHVIFmsY/4/azwa5kOjF2Jw4P/H36ajWjSAgADSnoA=
Date:   Thu, 20 Jun 2019 07:07:07 +0000
Message-ID: <a0f2c46b-b559-bcb3-4dd9-500c062405a1@mellanox.com>
References: <1560259713-25603-1-git-send-email-paulb@mellanox.com>
 <1560259713-25603-2-git-send-email-paulb@mellanox.com>
 <20190619183313.GA2746@localhost.localdomain>
In-Reply-To: <20190619183313.GA2746@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0095.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::35) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6161be2-8aa5-4f6b-8084-08d6f54de7f1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3492;
x-ms-traffictypediagnostic: AM4PR05MB3492:
x-microsoft-antispam-prvs: <AM4PR05MB34921320C2995D7B5B08971ECFE40@AM4PR05MB3492.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(346002)(396003)(376002)(39860400002)(189003)(199004)(66066001)(8936002)(31686004)(316002)(478600001)(4326008)(6916009)(53546011)(6506007)(386003)(31696002)(256004)(81166006)(52116002)(6246003)(54906003)(102836004)(64756008)(7736002)(99286004)(66446008)(5660300002)(305945005)(66946007)(76176011)(81156014)(66556008)(3846002)(71200400001)(446003)(66476007)(73956011)(2906002)(8676002)(36756003)(6512007)(25786009)(86362001)(2616005)(71190400001)(53936002)(186003)(6486002)(14454004)(486006)(6436002)(68736007)(26005)(11346002)(476003)(229853002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3492;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 21iC2EfYWP821Oz3mTtRdydGQoBr9QtKSeB1c7YOGMw5Ljc3trKOkAjN41i/R2ISyYQXXsAOuoUhLIMcLAx22c8C59oDB16NrfqiFolQ+NKfqjiToJKL2xu4tLmIrJ0uVQNgaQSTO4Scz6xnUhgT7QiZrpw1eC8IgDchmQ5Y1nZnGGndDL5MGPLACPVLcP0zFADKtSax0Q5WNBfBgSA0P7FwgsC2M1xt9HujDjYDju692bhgiirxOV5cNIHc1TiIPNRam3eH4HPrSPlOH3TQt4/sUmrlpQrjxAPDkXkZ/F3dMVzwESvcYd2DwmZYS0fXz72YwUUxrdFdIYzyV5qDmSB3jI0qSs7rGgRNsXNBlfx3Wu7Ahzy1o0GC8w/nRehc5O0uGelWC5cpgS75d2TXsoDweS+w8vF5jiWcBcy/jOo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <919E97A2D8D7F04488DA3066B08A3EC5@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6161be2-8aa5-4f6b-8084-08d6f54de7f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 07:07:07.4998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3492
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzE5LzIwMTkgOTozMyBQTSwgTWFyY2VsbyBSaWNhcmRvIExlaXRuZXIgd3JvdGU6DQo+
IE9uIFR1ZSwgSnVuIDExLCAyMDE5IGF0IDA0OjI4OjMxUE0gKzAzMDAsIFBhdWwgQmxha2V5IHdy
b3RlOg0KPiAuLi4NCj4+ICtzdGF0aWMgaW50IHRjZl9jdF9maWxsX3BhcmFtc19uYXQoc3RydWN0
IHRjZl9jdF9wYXJhbXMgKnAsDQo+PiArCQkJCSAgc3RydWN0IHRjX2N0ICpwYXJtLA0KPj4gKwkJ
CQkgIHN0cnVjdCBubGF0dHIgKip0YiwNCj4+ICsJCQkJICBzdHJ1Y3QgbmV0bGlua19leHRfYWNr
ICpleHRhY2spDQo+PiArew0KPj4gKwlzdHJ1Y3QgbmZfbmF0X3JhbmdlMiAqcmFuZ2U7DQo+PiAr
DQo+PiArCWlmICghKHAtPmN0X2FjdGlvbiAmIFRDQV9DVF9BQ1RfTkFUKSkNCj4+ICsJCXJldHVy
biAwOw0KPj4gKw0KPj4gKwlpZiAoIUlTX0VOQUJMRUQoQ09ORklHX05GX05BVCkpIHsNCj4+ICsJ
CU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssICJOZXRmaWx0ZXIgbmF0IGlzbid0IGVuYWJsZWQg
aW4ga2VybmVsIik7DQo+PiArCQlyZXR1cm4gLUVPUE5PVFNVUFA7DQo+PiArCX0NCj4+ICsNCj4+
ICsJaWYgKCEocC0+Y3RfYWN0aW9uICYgKFRDQV9DVF9BQ1RfTkFUX1NSQyB8IFRDQV9DVF9BQ1Rf
TkFUX0RTVCkpKQ0KPj4gKwkJcmV0dXJuIDA7DQo+PiArDQo+PiArCWlmICgocC0+Y3RfYWN0aW9u
ICYgVENBX0NUX0FDVF9OQVRfU1JDKSAmJg0KPj4gKwkgICAgKHAtPmN0X2FjdGlvbiAmIFRDQV9D
VF9BQ1RfTkFUX0RTVCkpIHsNCj4+ICsJCU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssICJkbmF0
IGFuZCBzbmF0IGNhbid0IGJlIGVuYWJsZWQgYXQgdGhlIHNhbWUgdGltZSIpOw0KPj4gKwkJcmV0
dXJuIC1FT1BOT1RTVVBQOw0KPj4gKwl9DQo+PiArDQo+PiArCXJhbmdlID0gJnAtPnJhbmdlOw0K
Pj4gKwlpZiAodGJbVENBX0NUX05BVF9JUFY0X01JTl0pIHsNCj4+ICsJCXJhbmdlLT5taW5fYWRk
ci5pcCA9DQo+PiArCQkJbmxhX2dldF9pbl9hZGRyKHRiW1RDQV9DVF9OQVRfSVBWNF9NSU5dKTsN
Cj4+ICsJCXJhbmdlLT5mbGFncyB8PSBORl9OQVRfUkFOR0VfTUFQX0lQUzsNCj4+ICsJCXAtPmlw
djRfcmFuZ2UgPSB0cnVlOw0KPj4gKwl9DQo+PiArCWlmICh0YltUQ0FfQ1RfTkFUX0lQVjRfTUFY
XSkgew0KPj4gKwkJcmFuZ2UtPm1heF9hZGRyLmlwID0NCj4+ICsJCQlubGFfZ2V0X2luX2FkZHIo
dGJbVENBX0NUX05BVF9JUFY0X01BWF0pOw0KPj4gKwkJcmFuZ2UtPmZsYWdzIHw9IE5GX05BVF9S
QU5HRV9NQVBfSVBTOw0KPj4gKwkJcC0+aXB2NF9yYW5nZSA9IHRydWU7DQo+PiArCX0gZWxzZSBp
ZiAocmFuZ2UtPm1pbl9hZGRyLmlwKSB7DQo+PiArCQlyYW5nZS0+bWF4X2FkZHIuaXAgPSByYW5n
ZS0+bWluX2FkZHIuaXA7DQo+PiArCX0NCj4+ICsNCj4+ICsJaWYgKHRiW1RDQV9DVF9OQVRfSVBW
Nl9NSU5dKSB7DQo+PiArCQlyYW5nZS0+bWluX2FkZHIuaW42ID0NCj4+ICsJCQlubGFfZ2V0X2lu
Nl9hZGRyKHRiW1RDQV9DVF9OQVRfSVBWNl9NSU5dKTsNCj4+ICsJCXJhbmdlLT5mbGFncyB8PSBO
Rl9OQVRfUkFOR0VfTUFQX0lQUzsNCj4+ICsJCXAtPmlwdjRfcmFuZ2UgPSBmYWxzZTsNCj4+ICsJ
fQ0KPj4gKwlpZiAodGJbVENBX0NUX05BVF9JUFY2X01BWF0pIHsNCj4+ICsJCXJhbmdlLT5tYXhf
YWRkci5pbjYgPQ0KPj4gKwkJCW5sYV9nZXRfaW42X2FkZHIodGJbVENBX0NUX05BVF9JUFY2X01B
WF0pOw0KPj4gKwkJcmFuZ2UtPmZsYWdzIHw9IE5GX05BVF9SQU5HRV9NQVBfSVBTOw0KPj4gKwkJ
cC0+aXB2NF9yYW5nZSA9IGZhbHNlOw0KPj4gKwl9IGVsc2UgaWYgKG1lbWNocl9pbnYoJnJhbmdl
LT5taW5fYWRkci5pbjYsIDAsDQo+PiArCQkgICBzaXplb2YocmFuZ2UtPm1pbl9hZGRyLmluNikp
KSB7DQo+PiArCQlyYW5nZS0+bWF4X2FkZHIuaW42ID0gcmFuZ2UtPm1pbl9hZGRyLmluNjsNCj4g
VGhpcyB3aWxsIG92ZXJ3cml0ZSBpcHY0X21heCBpZiBpdCB3YXMgdXNlZCwgYXMgbWluL21heF9h
ZGRyIGFyZQ0KPiB1bmlvbnMuDQo+IFdoYXQgYWJvdXQgaGF2aW5nIHRoZSBfTUFYIGhhbmRsaW5n
IChmb3IgYm90aCBpcHY0LzYpIGluc2lkZSB0aGUNCj4gICBpZiAoLi5fTUlOKSB7IH0gIGJsb2Nr
ID8NCg0KWWVzIHRoYXQgd2hhdCBJIHBsYW5uZWQgb24gZG9pbmc6DQoNCiDCoMKgwqDCoMKgwqDC
oCByYW5nZSA9ICZwLT5yYW5nZTsNCiDCoMKgwqDCoMKgwqDCoCBpZiAodGJbVENBX0NUX05BVF9J
UFY0X01JTl0pIHsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcC0+aXB2NF9yYW5n
ZSA9IHRydWU7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJhbmdlLT5mbGFncyB8
PSBORl9OQVRfUkFOR0VfTUFQX0lQUzsNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
cmFuZ2UtPm1pbl9hZGRyLmlwID0NCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIG5sYV9nZXRfaW5fYWRkcih0YltUQ0FfQ1RfTkFUX0lQVjRfTUlOXSk7DQoN
CiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmFuZ2UtPm1heF9hZGRyLmlwID0gdGJb
VENBX0NUX05BVF9JUFY0X01BWF0gPw0KbmxhX2dldF9pbl9hZGRyKHRiW1RDQV9DVF9OQVRfSVBW
NF9NQVhdKSA6DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJhbmdlLT5taW5fYWRkci5pcDsNCiDCoMKgwqDC
oMKgwqDCoCB9IGVsc2UgaWYgKHRiW1RDQV9DVF9OQVRfSVBWNl9NSU5dKSB7DQogwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgIHAtPmlwdjRfcmFuZ2UgPSBmYWxzZTsNCiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmFuZ2UtPmZsYWdzIHw9IE5GX05BVF9SQU5HRV9NQVBfSVBT
Ow0KIMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCByYW5nZS0+bWluX2FkZHIuaW42ID0N
CiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIG5sYV9nZXRf
aW42X2FkZHIodGJbVENBX0NUX05BVF9JUFY2X01JTl0pOw0KDQogwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHJhbmdlLT5tYXhfYWRkci5pbjYgPSB0YltUQ0FfQ1RfTkFUX0lQVjZfTUFY
XSA/DQpubGFfZ2V0X2luNl9hZGRyKHRiW1RDQV9DVF9OQVRfSVBWNl9NQVhdKSA6DQogwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgcmFuZ2UtPm1pbl9hZGRyLmluNjsNCiDCoMKgwqDCoMKgwqDCoCB9DQoNCiDC
oMKgwqDCoMKgwqDCoCBpZiAodGJbVENBX0NUX05BVF9QT1JUX01JTl0pIHsNCiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgcmFuZ2UtPmZsYWdzIHw9IE5GX05BVF9SQU5HRV9QUk9UT19T
UEVDSUZJRUQ7DQogwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJhbmdlLT5taW5fcHJv
dG8uYWxsID0gDQpubGFfZ2V0X2JlMTYodGJbVENBX0NUX05BVF9QT1JUX01JTl0pOw0KDQogwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJhbmdlLT5tYXhfcHJvdG8uYWxsID0gdGJbVENB
X0NUX05BVF9QT1JUX01BWF0/DQpubGFfZ2V0X2JlMTYodGJbVENBX0NUX05BVF9QT1JUX01BWF0p
IDoNCiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJhbmdlLT5taW5fcHJvdG8uYWxsOw0KDQoNCg0KDQoN
Cj4+ICsJfQ0KPj4gKw0K
