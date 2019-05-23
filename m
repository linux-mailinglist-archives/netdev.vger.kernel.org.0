Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD74285EC
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 20:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbfEWSa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 14:30:27 -0400
Received: from mail-eopbgr40081.outbound.protection.outlook.com ([40.107.4.81]:40014
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731107AbfEWSa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 14:30:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tc9FI6ZocbEIchdQ3V5ehZSaWi1saEEA34SKaVI4mto=;
 b=abicirUm9TCpsFbveyQi+leyz68j6sqxtkxODGCRDFWmwTKPF2ejTbd6FTwJSAJDUdgxMZe0snwwhlAgtLHwuaA0K5oanJ1g4bEwhnQCsZq7xqxZUuaA/JPQpIVIojPOLtomJBLweV4KHEquDIePGLZ40U531IgvEH1H0a4l9pY=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5996.eurprd05.prod.outlook.com (20.179.10.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 23 May 2019 18:30:23 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.013; Thu, 23 May 2019
 18:30:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        mlxsw <mlxsw@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
Thread-Topic: [patch net-next 3/7] mlxfw: Propagate error messages through
 extack
Thread-Index: AQHVEUw6Nqf6DxxMyUuqd+iSQ0aW7aZ401AAgAA1PgA=
Date:   Thu, 23 May 2019 18:30:22 +0000
Message-ID: <aeac02b92108ee6b64d43a674fe087ac7c074987.camel@mellanox.com>
References: <20190523094510.2317-1-jiri@resnulli.us>
         <20190523094510.2317-4-jiri@resnulli.us>
         <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
In-Reply-To: <7f3362de-baaf-99ee-1b53-55675aaf00fe@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1a92cca-8d17-4738-d831-08d6dfacb7cd
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5996;
x-ms-traffictypediagnostic: DB8PR05MB5996:
x-microsoft-antispam-prvs: <DB8PR05MB59962694ACDD2B2F77B6B935BE010@DB8PR05MB5996.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(136003)(376002)(346002)(39860400002)(189003)(199004)(53936002)(86362001)(36756003)(2501003)(6246003)(316002)(2201001)(14454004)(99286004)(118296001)(5660300002)(54906003)(6512007)(6436002)(478600001)(64756008)(66446008)(6486002)(229853002)(110136005)(58126008)(2906002)(66946007)(66556008)(73956011)(66476007)(91956017)(66066001)(2616005)(8676002)(76116006)(7736002)(476003)(305945005)(14444005)(68736007)(81166006)(81156014)(11346002)(8936002)(256004)(186003)(26005)(102836004)(6506007)(53546011)(6116002)(71190400001)(15650500001)(76176011)(486006)(446003)(4326008)(25786009)(3846002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5996;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: BovHxoozKtzyfnOwqAHukG7eXiaN9uHKBY3Gw+nN17PajHJN6Kgs4YDXYiYALPvKkZlRZU7EyXmirGOrCV2TgNYZywVzAkpiNaaMlA4BljhOaPeWrwHKHlp+a9kEFLQLJcTqe+Tt7t8lzGzXmlYK+H5UOmrqSiW5GTjesWyYeBlL61nCJd1RWKIq0Pg2ucMUDOiSpJYmjE/k8qQrOr+ELWkr4g/ucDf6SI9TStLvZJsaheiqk/VbsOnzEZT/Vof7iyc2xvukJWl8TDqdAgJncfG53wZA7z2ErZdLcvTGcEYeTuT+H3lSAioWk+Kbt9LHcT+/TIZBXhY4JIF5Pq005B9cQ1PysCZRwJDQjcE/WTMG2OYs7zKMvJaXUeveSeNjr5qe5TuOgHb1gPOsejg+eZiJfXKgnJY8q+OVfqHvd60=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2325862591F34B4697E88DA751A388DC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a92cca-8d17-4738-d831-08d6dfacb7cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 18:30:22.9094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5996
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA1LTIzIGF0IDA5OjE5IC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
T24gNS8yMy8xOSAzOjQ1IEFNLCBKaXJpIFBpcmtvIHdyb3RlOg0KPiA+IEBAIC01NywxMSArNTgs
MTMgQEAgc3RhdGljIGludCBtbHhmd19mc21fc3RhdGVfd2FpdChzdHJ1Y3QNCj4gPiBtbHhmd19k
ZXYgKm1seGZ3X2RldiwgdTMyIGZ3aGFuZGxlLA0KPiA+ICAJaWYgKGZzbV9zdGF0ZV9lcnIgIT0g
TUxYRldfRlNNX1NUQVRFX0VSUl9PSykgew0KPiA+ICAJCXByX2VycigiRmlybXdhcmUgZmxhc2gg
ZmFpbGVkOiAlc1xuIiwNCj4gPiAgCQkgICAgICAgbWx4ZndfZnNtX3N0YXRlX2Vycl9zdHJbZnNt
X3N0YXRlX2Vycl0pOw0KPiA+ICsJCU5MX1NFVF9FUlJfTVNHX01PRChleHRhY2ssICJGaXJtd2Fy
ZSBmbGFzaCBmYWlsZWQiKTsNCj4gPiAgCQlyZXR1cm4gLUVJTlZBTDsNCj4gPiAgCX0NCj4gPiAg
CWlmIChjdXJyX2ZzbV9zdGF0ZSAhPSBmc21fc3RhdGUpIHsNCj4gPiAgCQlpZiAoLS10aW1lcyA9
PSAwKSB7DQo+ID4gIAkJCXByX2VycigiVGltZW91dCByZWFjaGVkIG9uIEZTTSBzdGF0ZSBjaGFu
Z2UiKTsNCj4gPiArCQkJTkxfU0VUX0VSUl9NU0dfTU9EKGV4dGFjaywgIlRpbWVvdXQgcmVhY2hl
ZCBvbg0KPiA+IEZTTSBzdGF0ZSBjaGFuZ2UiKTsNCj4gDQo+IEZTTT8gSXMgdGhlIG1lYW5pbmcg
b2J2aW91cyB0byB1c2Vycz8NCg0KVGhlc2UgbWVzc2FnZXMgYXJlIHZlbmRvciBkcml2ZXIgZ2Vu
ZXJhdGVkLCBob3cgY2FuIHdlIG1ha2UgdGhlbSB1c2VyDQpmcmllbmRseSwgeWV0IGV4cG9zZSB2
ZW5kb3Igc3BlY2lmaWMgaW5mb3JtYXRpb24gdGhhdCBvbmx5IHRoZSB2ZW5kb3INCmNhbiB1bmRl
cnN0YW5kIC4uID8gSSB0aGluayBpdCBpcyBsZWdpdCB0byBoYXZlIHZlbmRvciBzcGVjaWZpYyB0
ZXJtcw0KaW4gZXh0YWNrIHdoaWNoIGlzIGdlbmVyYXRlZCBieSBkcml2ZXJzLi4gDQoNCj4gDQo+
ID4gIAkJCXJldHVybiAtRVRJTUVET1VUOw0KPiA+ICAJCX0NCj4gPiAgCQltc2xlZXAoTUxYRldf
RlNNX1NUQVRFX1dBSVRfQ1lDTEVfTVMpOw0KPiA+IEBAIC03Niw3ICs3OSw4IEBAIHN0YXRpYyBp
bnQgbWx4ZndfZnNtX3N0YXRlX3dhaXQoc3RydWN0IG1seGZ3X2Rldg0KPiA+ICptbHhmd19kZXYs
IHUzMiBmd2hhbmRsZSwNCj4gPiAgDQo+ID4gIHN0YXRpYyBpbnQgbWx4ZndfZmxhc2hfY29tcG9u
ZW50KHN0cnVjdCBtbHhmd19kZXYgKm1seGZ3X2RldiwNCj4gPiAgCQkJCSB1MzIgZndoYW5kbGUs
DQo+ID4gLQkJCQkgc3RydWN0IG1seGZ3X21mYTJfY29tcG9uZW50ICpjb21wKQ0KPiA+ICsJCQkJ
IHN0cnVjdCBtbHhmd19tZmEyX2NvbXBvbmVudCAqY29tcCwNCj4gPiArCQkJCSBzdHJ1Y3QgbmV0
bGlua19leHRfYWNrICpleHRhY2spDQo+ID4gIHsNCj4gPiAgCXUxNiBjb21wX21heF93cml0ZV9z
aXplOw0KPiA+ICAJdTggY29tcF9hbGlnbl9iaXRzOw0KPiA+IEBAIC05Niw2ICsxMDAsNyBAQCBz
dGF0aWMgaW50IG1seGZ3X2ZsYXNoX2NvbXBvbmVudChzdHJ1Y3QNCj4gPiBtbHhmd19kZXYgKm1s
eGZ3X2RldiwNCj4gPiAgCWlmIChjb21wLT5kYXRhX3NpemUgPiBjb21wX21heF9zaXplKSB7DQo+
ID4gIAkJcHJfZXJyKCJDb21wb25lbnQgJWQgaXMgb2Ygc2l6ZSAlZCB3aGljaCBpcyBiaWdnZXIg
dGhhbg0KPiA+IGxpbWl0ICVkXG4iLA0KPiA+ICAJCSAgICAgICBjb21wLT5pbmRleCwgY29tcC0+
ZGF0YV9zaXplLCBjb21wX21heF9zaXplKTsNCj4gPiArCQlOTF9TRVRfRVJSX01TR19NT0QoZXh0
YWNrLCAiQ29tcG9uZW50IGlzIHdoaWNoIGlzDQo+ID4gYmlnZ2VyIHRoYW4gbGltaXQiKTsNCj4g
DQo+IE5lZWQgdG8gZHJvcCAnaXMgd2hpY2gnLg0KPiANCj4gDQo+IC4uLg0KPiANCj4gPiBAQCAt
MTU2LDYgKzE2Myw3IEBAIHN0YXRpYyBpbnQgbWx4ZndfZmxhc2hfY29tcG9uZW50cyhzdHJ1Y3QN
Cj4gPiBtbHhmd19kZXYgKm1seGZ3X2RldiwgdTMyIGZ3aGFuZGxlLA0KPiA+ICAJCQkJCSAgICAg
ICZjb21wb25lbnRfY291bnQpOw0KPiA+ICAJaWYgKGVycikgew0KPiA+ICAJCXByX2VycigiQ291
bGQgbm90IGZpbmQgZGV2aWNlIFBTSUQgaW4gTUZBMiBmaWxlXG4iKTsNCj4gPiArCQlOTF9TRVRf
RVJSX01TR19NT0QoZXh0YWNrLCAiQ291bGQgbm90IGZpbmQgZGV2aWNlIFBTSUQNCj4gPiBpbiBN
RkEyIGZpbGUiKTsNCj4gDQo+IHNhbWUgaGVyZSwgaXMgUFNJRCB1bmRlcnN0b29kIGJ5IHVzZXI/
DQo+IA0K
