Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03F581E9E8
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 10:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfEOIOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 04:14:41 -0400
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:65186
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbfEOIOl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 04:14:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka103Hz8GNrDSBMc5HaWdQDiSV4F2Q6WwM9CeMxYSmQ=;
 b=cMcHHRRDenDa5Wsz8hnX1TS4lKMTCC4nzcyD3NQcuQDh3Swcd9/922aT3RB/TQH29YG0TeXEf2W00sfEA3XPuazodIpj/PctMkfshygHKqP/cxzYbAtQL24tD8k2M4h8UtpQAbfkSocW1dCumSlZoIXN2RkouSgRTuHfCHyD9GI=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5585.eurprd05.prod.outlook.com (20.177.188.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Wed, 15 May 2019 08:14:37 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1900.010; Wed, 15 May 2019
 08:14:37 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [RFC 2] Validate required parameters in inet6_validate_link_af
Thread-Topic: [RFC 2] Validate required parameters in inet6_validate_link_af
Thread-Index: AQHVCZ1Od/+t/BfWfU6JV9D+RXp2QqZrR22AgACRzQA=
Date:   Wed, 15 May 2019 08:14:37 +0000
Message-ID: <08069f49-58b0-4b83-eab8-97326e7e5080@mellanox.com>
References: <20190513150513.26872-1-maximmi@mellanox.com>
 <20190513150513.26872-3-maximmi@mellanox.com>
 <20190514163243.3f2a420f@cakuba.netronome.com>
In-Reply-To: <20190514163243.3f2a420f@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0202CA0028.eurprd02.prod.outlook.com
 (2603:10a6:3:e4::14) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83a2c39a-dbae-4b14-8e9c-08d6d90d5f1c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5585;
x-ms-traffictypediagnostic: AM6PR05MB5585:
x-microsoft-antispam-prvs: <AM6PR05MB558518B683B5A4813003E194D1090@AM6PR05MB5585.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0038DE95A2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(346002)(396003)(39860400002)(136003)(189003)(199004)(14454004)(68736007)(6916009)(4326008)(2906002)(3846002)(6512007)(508600001)(6116002)(25786009)(229853002)(186003)(31696002)(53936002)(107886003)(6246003)(86362001)(81166006)(8676002)(81156014)(8936002)(476003)(486006)(2616005)(446003)(11346002)(305945005)(7736002)(6486002)(316002)(5660300002)(71190400001)(71200400001)(52116002)(54906003)(99286004)(31686004)(102836004)(73956011)(6436002)(386003)(26005)(6506007)(53546011)(66066001)(64756008)(36756003)(66946007)(66446008)(76176011)(256004)(66476007)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5585;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AMVJmi6YFxXxpfKM0yritQwqACmJ+mWC0eCcNLoqRlc2IsB1h4yzodfhQ9J2gorSqC/qRrqlKouC+hgVE/Ok9tZpYOHSBXzZQ19rWTNIr28r0+s6NgHfmCIbbFqg2o/xRShvB4iA8Lb5yJgvQfhB6RtwI/p7iEsGdsu9/JeBRYQxIxzDcccTJzMfA4sBPKgH/Hff2c288LC3Y3EVs9Ae1tzJze7Ml5cSnkIBW5guwiyZFjRz3YELmCUU2aiWoQbIa+tRQOApSu+Crv+q2TF1y7NLKw5QuSr9/smO3pwJIhbWcYY8z0bbRB5a5smga3luwp8ai6Fv51IlUdHuC6H5J79WyIne1UlwARvni1E7eaBmfpVOrSHC4XvlmlgShJeGlPzTr4sBXwsoyoEd4CqlQem4caTwKLfvhMXTiPlfvec=
Content-Type: text/plain; charset="utf-8"
Content-ID: <58770F26279DD140A09BB2C8E014C680@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83a2c39a-dbae-4b14-8e9c-08d6d90d5f1c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2019 08:14:37.6031
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5585
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNS0xNSAwMjozMiwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIE1vbiwgMTMg
TWF5IDIwMTkgMTU6MDU6MzAgKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+ICsJ
ZXJyID0gLUVJTlZBTDsNCj4+ICsNCj4+ICsJaWYgKHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9E
RV0pIHsNCj4+ICsJCXU4IG1vZGUgPSBubGFfZ2V0X3U4KHRiW0lGTEFfSU5FVDZfQUREUl9HRU5f
TU9ERV0pOw0KPj4gKw0KPj4gKwkJaWYgKGNoZWNrX2FkZHJfZ2VuX21vZGUobW9kZSkgPCAwKQ0K
Pj4gKwkJCXJldHVybiAtRUlOVkFMOw0KPj4gKwkJaWYgKGRldiAmJiBjaGVja19zdGFibGVfcHJp
dmFjeShpZGV2LCBkZXZfbmV0KGRldiksIG1vZGUpIDwgMCkNCj4+ICsJCQlyZXR1cm4gLUVJTlZB
TDsNCj4+ICsNCj4+ICsJCWVyciA9IDA7DQo+PiArCX0NCj4+ICsNCj4+ICsJaWYgKHRiW0lGTEFf
SU5FVDZfVE9LRU5dKQ0KPj4gKwkJZXJyID0gMDsNCj4+ICsNCj4+ICsJcmV0dXJuIGVycjsNCj4g
DQo+IFdoaWxlIGF0IGl0IGNvdWxkIHlvdSBmb3JnbyB0aGUgcmV0dmFsIG9wdGltaXphdGlvbj8g
IE1vc3Qgb2YgdGhlIHRpbWUNCj4gaXQganVzdCBsZWFkcyB0byBsZXNzIHJlYWRhYmxlIGNvZGUg
Zm9yIG5vIGdhaW4uDQoNCk9LLCBJJ2xsIG1ha2UgdGhpcyBjaGFuZ2UgaW4gYSByZXNwaW4uDQoN
Cj4gVGhlIG5vcm1hbCB3YXkgdG8gd3JpdGUgdGhpcyBjb2RlIHdvdWxkIGJlOg0KPiANCj4gCWlm
ICghdGJbSUZMQV9JTkVUNl9BRERSX0dFTl9NT0RFXSAmJiAhdGJbSUZMQV9JTkVUNl9UT0tFTl0p
DQo+IAkJcmV0dXJuIC1FSU5WQUw7DQoNClllYWgsIHRoYXQncyBob3cgSSB3cm90ZSB0aGlzIGNo
ZWNrIGluIFJGQyAxLCBidXQgaGVyZSBpbiB0aGlzIHBhdGNoIEkgDQpkZWNpZGVkIHRvIHByZXNl
cnZlIHRoZSBwYXR0ZXJuIHRoYXQgd2FzIHVzZWQgaW4gaW5ldDZfc2V0X2xpbmtfYWYgDQpiZWZv
cmUgbXkgY2hhbmdlLCB0byBtaW5pbWl6ZSB0aGUgY2hhbmdlcy4gSSBhZ3JlZSBpdCdzIGxlc3Mg
cmVhZGFibGUgKEkgDQpkaWRuJ3QgbGlrZSB0aGUgZXJyb3IgaGFuZGxpbmcgZmxvdyBpbiBpbmV0
Nl9zZXRfbGlua19hZiBlaXRoZXIpLCBzbyANCkknbGwgZml4IGl0LiBUaGFua3MgZm9yIHJldmll
d2luZyENCg0KPiAJaWYgKHRiW0lGTEFfSU5FVDZfQUREUl9HRU5fTU9ERV0pIHsNCj4gCQl1OCBt
b2RlID0gbmxhX2dldF91OCh0YltJRkxBX0lORVQ2X0FERFJfR0VOX01PREVdKTsNCj4gDQo+IAkJ
aWYgKGNoZWNrX2FkZHJfZ2VuX21vZGUobW9kZSkgPCAwKQ0KPiAJCQlyZXR1cm4gLUVJTlZBTDsN
Cj4gCQlpZiAoZGV2ICYmIGNoZWNrX3N0YWJsZV9wcml2YWN5KGlkZXYsIGRldl9uZXQoZGV2KSwg
bW9kZSkgPCAwKQ0KPiAJCQlyZXR1cm4gLUVJTlZBTDsNCj4gCX0NCj4gDQo+IAlyZXR1cm4gMDsN
Cj4gDQoNCg==
