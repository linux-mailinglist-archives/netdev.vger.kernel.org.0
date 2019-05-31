Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7972A314B5
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbfEaSap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:30:45 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:59975
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727212AbfEaSap (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 14:30:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aodvYUDZLKPTXg/8NIzIMI4eTSFJPQC9df/pg4kLLkQ=;
 b=FoYRQWvDySpMlmxeONgAjZeK0CsdG+n8OJH1b6I2Q6KZBvUaPBiiPBaAXrmwX+gCELotzWGNsN2kuwl9xhxoDv6LhB6qG5+4zvROewTFkGFv14lUz+DdKnRWVSDDpSWTLZARWJVvmAWXGkRuzNxSC8tIiHaRC/lC/phtx9y3b1M=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB5103.eurprd05.prod.outlook.com (20.177.49.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.17; Fri, 31 May 2019 18:30:41 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 18:30:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net-next 2/3] indirect call wrappers: add helpers for 3
 and 4 ways switch
Thread-Topic: [PATCH net-next 2/3] indirect call wrappers: add helpers for 3
 and 4 ways switch
Thread-Index: AQHVF6/5O5vnoPxts0iY1Smg4vFIaaaFjoSA
Date:   Fri, 31 May 2019 18:30:41 +0000
Message-ID: <1133f7e92cffb7ade5249e6d6ac0dd430549bf14.camel@mellanox.com>
References: <cover.1559304330.git.pabeni@redhat.com>
         <7dc56c32624fd102473fc66ffdda6ebfcdfe6ad0.1559304330.git.pabeni@redhat.com>
In-Reply-To: <7dc56c32624fd102473fc66ffdda6ebfcdfe6ad0.1559304330.git.pabeni@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6bfc9c1-c581-466b-e432-08d6e5f61644
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5103;
x-ms-traffictypediagnostic: VI1PR05MB5103:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR05MB510339F3905CB2D722707623BE190@VI1PR05MB5103.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(376002)(346002)(39860400002)(366004)(396003)(189003)(199004)(53936002)(99286004)(36756003)(71200400001)(5660300002)(118296001)(71190400001)(6246003)(66556008)(11346002)(6486002)(6436002)(446003)(110136005)(229853002)(66946007)(7736002)(91956017)(102836004)(6512007)(6306002)(73956011)(66446008)(54906003)(25786009)(66476007)(26005)(76116006)(305945005)(186003)(64756008)(58126008)(4326008)(68736007)(81156014)(14454004)(476003)(316002)(508600001)(966005)(2501003)(76176011)(66066001)(3846002)(2616005)(5024004)(6116002)(256004)(2906002)(486006)(8676002)(81166006)(8936002)(6506007)(86362001)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5103;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9MQPrDboTHQHgIECab7HylSxEtTtQWM4oOH65KG42XAEjrWS16ML3xByxCgNNmGhQ7sIhYmA8upjIwtLYoT4SkNWDrA9ii0ZraBh+XUc3RyIyMGDZ7wX54S+nelJRr73oGPap4FB6opokOq+dv/0MYRljr0KLm9qZYiJ6TcoNkHuzB6awXQNdMfsnf6imBetDW0M+65otxhA+MCPgvxtjUOMjSaGMtowVzlGWMZ6K4ahQ8aTciT0dzZ5+tXyR3sxm0u0sTXYN59VLoZ2/KKo7oKHmqac00OqscdRnMAuPi9tcnv6v38ZqTDgUImcfHDQn/s2YJWe6qVjPQ6ksl99br6qi67iPcC+bSIMKHW+QycaDu48PrgjXSWvWmKm0/8rcYMsUYWcGPWuvIQbhBFOorf5nU8Ii5ERr2jKOVARar4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB285A31657DAA4E8B99E7C5F3A1E43C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6bfc9c1-c581-466b-e432-08d6e5f61644
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 18:30:41.6813
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA1LTMxIGF0IDE0OjUzICswMjAwLCBQYW9sbyBBYmVuaSB3cm90ZToNCj4g
RXhwZXJpbWVudGFsIHJlc3VsdHNbMV0gaGFzIHNob3duIHRoYXQgcmVzb3J0aW5nIHRvIHNldmVy
YWwgYnJhbmNoZXMNCj4gYW5kIGEgZGlyZWN0LWNhbGwgaXMgZmFzdGVyIHRoYW4gaW5kaXJlY3Qg
Y2FsbCB2aWEgcmV0cG9saW5lLCBldmVuDQo+IHdoZW4gdGhlIG51bWJlciBvZiBhZGRlZCBicmFu
Y2hlcyBnbyB1cCA1Lg0KPiANCj4gVGhpcyBjaGFuZ2UgYWRkcyB0d28gYWRkaXRpb25hbCBoZWxw
ZXJzLCB0byBjb3BlIHdpdGggaW5kaXJlY3QgY2FsbHMNCj4gd2l0aCB1cCB0byA0IGF2YWlsYWJs
ZSBkaXJlY3QgY2FsbCBvcHRpb24uIFdlIHdpbGwgdXNlIHRoZW0NCj4gaW4gdGhlIG5leHQgcGF0
Y2guDQo+IA0KPiBbMV0gDQo+IGh0dHBzOi8vbGludXhwbHVtYmVyc2NvbmYub3JnL2V2ZW50LzIv
Y29udHJpYnV0aW9ucy85OS9hdHRhY2htZW50cy85OC8xMTcvbHBjMThfcGFwZXJfYWZfeGRwX3Bl
cmYtdjIucGRmDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhh
dC5jb20+DQo+IC0tLQ0KPiAgaW5jbHVkZS9saW51eC9pbmRpcmVjdF9jYWxsX3dyYXBwZXIuaCB8
IDEyICsrKysrKysrKysrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4g
DQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2luZGlyZWN0X2NhbGxfd3JhcHBlci5oDQo+
IGIvaW5jbHVkZS9saW51eC9pbmRpcmVjdF9jYWxsX3dyYXBwZXIuaA0KPiBpbmRleCAwMGQ3ZThl
OTE5YzYuLjdjNGNhYzg3ZWFmNyAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9pbmRpcmVj
dF9jYWxsX3dyYXBwZXIuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L2luZGlyZWN0X2NhbGxfd3Jh
cHBlci5oDQo+IEBAIC0yMyw2ICsyMywxNiBAQA0KPiAgCQlsaWtlbHkoZiA9PSBmMikgPyBmMihf
X1ZBX0FSR1NfXykgOgkJCQ0KPiBcDQo+ICAJCQkJICBJTkRJUkVDVF9DQUxMXzEoZiwgZjEsIF9f
VkFfQVJHU19fKTsJDQo+IFwNCj4gIAl9KQ0KPiArI2RlZmluZSBJTkRJUkVDVF9DQUxMXzMoZiwg
ZjMsIGYyLCBmMSwgLi4uKQkJCQkNCj4gXA0KPiArCSh7CQkJCQkJCQkNCj4gXA0KPiArCQlsaWtl
bHkoZiA9PSBmMykgPyBmMyhfX1ZBX0FSR1NfXykgOgkJCQ0KPiBcDQo+ICsJCQkJICBJTkRJUkVD
VF9DQUxMXzIoZiwgZjIsIGYxLA0KPiBfX1ZBX0FSR1NfXyk7IFwNCj4gKwl9KQ0KPiArI2RlZmlu
ZSBJTkRJUkVDVF9DQUxMXzQoZiwgZjQsIGYzLCBmMiwgZjEsIC4uLikJCQkNCj4gCVwNCj4gKwko
ewkJCQkJCQkJDQo+IFwNCj4gKwkJbGlrZWx5KGYgPT0gZjQpID8gZjQoX19WQV9BUkdTX18pIDoJ
CQ0KDQpkbyB3ZSByZWFsbHkgd2FudCAibGlrZWx5IiBoZXJlID8gaW4gb3VyIGNhc2VzIHRoZXJl
IGlzIG5vIHByZWZlcmVuY2UNCm9uIHdodWNoIGZOIGlzIGdvaW5nIHRvIGhhdmUgdGhlIHRvcCBw
cmlvcml0eSwgYWxsIG9mIHRoZW0gYXJlIGVxdWFsbHkNCmltcG9ydGFudCBhbmQgc3RhdGljYWxs
eSBjb25maWd1cmVkIGFuZCBndXJhbnRlZWQgdG8gbm90IGNoYW5nZSBvbiBkYXRhDQpwYXRoIC4u
IA0KDQo+IAlcDQo+ICsJCQkJICBJTkRJUkVDVF9DQUxMXzMoZiwgZjMsIGYyLCBmMSwNCj4gX19W
QV9BUkdTX18pOyBcDQo+ICsJfSkNCj4gIA0KDQpPaCB0aGUgUkVUUE9MSU5FIQ0KDQpPbiB3aGlj
aCAoTikgd2hlcmUgSU5ESVJFQ1RfQ0FMTF9OKGYsIGZOLCBmTi0xLCAuLi4sIGYxLC4uLikgLCBj
YWxsaW5nDQp0aGUgaW5kaXJlY3Rpb24gZnVuY3Rpb24gcG9pbnRlciBkaXJlY3RseSBpcyBnb2lu
ZyB0byBiZSBhY3R1YWxseQ0KYmV0dGVyIHRoYW4gdGhpcyB3aG9sZSBJTkRJUkVDVF9DQUxMX04g
d3JhcHBlciAiaWYgZWxzZSIgZGFuY2UgPw0KDQo+ICAjZGVmaW5lIElORElSRUNUX0NBTExBQkxF
X0RFQ0xBUkUoZikJZg0KPiAgI2RlZmluZSBJTkRJUkVDVF9DQUxMQUJMRV9TQ09QRQ0KPiBAQCAt
MzAsNiArNDAsOCBAQA0KPiAgI2Vsc2UNCj4gICNkZWZpbmUgSU5ESVJFQ1RfQ0FMTF8xKGYsIGYx
LCAuLi4pIGYoX19WQV9BUkdTX18pDQo+ICAjZGVmaW5lIElORElSRUNUX0NBTExfMihmLCBmMiwg
ZjEsIC4uLikgZihfX1ZBX0FSR1NfXykNCj4gKyNkZWZpbmUgSU5ESVJFQ1RfQ0FMTF8zKGYsIGYz
LCBmMiwgZjEsIC4uLikgZihfX1ZBX0FSR1NfXykNCj4gKyNkZWZpbmUgSU5ESVJFQ1RfQ0FMTF80
KGYsIGY0LCBmMywgZjIsIGYxLCAuLi4pIGYoX19WQV9BUkdTX18pDQo+ICAjZGVmaW5lIElORElS
RUNUX0NBTExBQkxFX0RFQ0xBUkUoZikNCj4gICNkZWZpbmUgSU5ESVJFQ1RfQ0FMTEFCTEVfU0NP
UEUJCXN0YXRpYw0KPiAgI2VuZGlmDQo=
