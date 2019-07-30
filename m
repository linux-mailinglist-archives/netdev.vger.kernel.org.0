Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E07F7B40B
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbfG3UJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:09:37 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:51022
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726174AbfG3UJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 16:09:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqQoXeYGmF2UJ9mTIloVSrTN075qkB0JgKE4yFP7l/QsijUsp8H+N6ieGXC87J1wtH36jB0+/WeMdP3KRKKjLSgPC1F2gAOohK+yWW9v+ti6/JOlcSJMYINK8z6CYPNTAlTHEsv0cuWa0jbUfkqpKbith867VV0VTb0zgL+pvoer1Ou8cz8QMpnBIk/TVtFc1VO3NbZUrKCNyZi2jDqULSFkzTBjfIfTnoDB7Le7khGGZHl/G2kU6msF67YcO8Y5O1Lpf42Qky64mzBFs1e0hOnXAZ4ZrVFoyzdcJkeGw8J5MMCEOvnjHT+vYBqYqSpDp5GmhMia4ttycTgYXMwsEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v56VEIt9bN2c22p5tT5DzPkZfiAQnOUjHQzDbZdpVyA=;
 b=dAPRWuoEBHvQ+99a8owB3XR0SjVNAW7A8TNJpyW2rgvbkAbH/YjY2nUfQPvyutZjb8ZfbBuRGkylX1pYHuLh77yNpcoa/JK0U3zVXLfrCRkCe9tMmxcsO9qRfBUucVUv7IJyBsIExrFv5x5wghT7gbAcBoYjZdrrdqG6rhi/xwWA2qGyYyxuLafgbuxJWu3kQVygPL+4MpSA9nZ0cu9SSZSmCP1vwgsDkmqOXNhDep1derKA2qaaGi1BPF48d5f9/TO8QS+NnG9s0piTM3J7tKJSo0NMtx7e31f3PJCYEN121LzMxuZ2K0DXiDO54iW4wbC7Uch8anjA8MNC2eGexQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v56VEIt9bN2c22p5tT5DzPkZfiAQnOUjHQzDbZdpVyA=;
 b=QbshGtHdaF6RW0plbpJYcsHeZ+VyiMo40Wv4Xm71sduOeahzKTKp+nUo/RXPZ43Pve/teIQfZgpDatEq19tu48XLJhf0nt2UkH0ZLMAk8mapx7DHrfQqaQmMNVJlLiAbHGwNnC+/amdRhBBXPF3xNm4RPiurHQcU7Slu/k7sqjs=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2533.eurprd05.prod.outlook.com (10.168.74.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Tue, 30 Jul 2019 20:09:33 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 20:09:33 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>
CC:     Roi Dayan <roid@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>
Subject: Re: [net-next 08/13] net/mlx5e: Protect tc flows hashtable with rcu
Thread-Topic: [net-next 08/13] net/mlx5e: Protect tc flows hashtable with rcu
Thread-Index: AQHVRmhmeTi75BdH60+Po7jjBFRT4KbjV0AAgAAGNYCAADsfgA==
Date:   Tue, 30 Jul 2019 20:09:33 +0000
Message-ID: <f0e4d9fbcdba0ed19fc3494a29cf70ae2702e727.camel@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
         <20190729234934.23595-9-saeedm@mellanox.com>
         <CA+FuTSfnikCV_J2cUEeafCaui8KxrK4njRR9rqgpo+5JhBxR9g@mail.gmail.com>
         <CAF=yD-LgfHTJrfyaVfokKkZWwPpz4uxYDKA11+jgO5rAq1LamA@mail.gmail.com>
In-Reply-To: <CAF=yD-LgfHTJrfyaVfokKkZWwPpz4uxYDKA11+jgO5rAq1LamA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99d0a0cb-6d92-401a-bb60-08d71529d687
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2533;
x-ms-traffictypediagnostic: DB6PR0501MB2533:
x-microsoft-antispam-prvs: <DB6PR0501MB25335C56E01C9E94CD6E578CBEDC0@DB6PR0501MB2533.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(366004)(396003)(39860400002)(189003)(199004)(186003)(316002)(64756008)(66556008)(66476007)(66446008)(305945005)(58126008)(478600001)(53936002)(54906003)(6246003)(102836004)(81156014)(1361003)(76116006)(7736002)(66946007)(3846002)(4326008)(14454004)(6506007)(6116002)(91956017)(446003)(11346002)(26005)(107886003)(66066001)(2616005)(81166006)(476003)(99286004)(2351001)(2501003)(486006)(68736007)(76176011)(53546011)(2906002)(5660300002)(36756003)(14444005)(256004)(71190400001)(118296001)(229853002)(6916009)(6436002)(86362001)(8936002)(6486002)(8676002)(6512007)(71200400001)(25786009)(5640700003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2533;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S+aTgKf17vxUAJBzdM83ZqlfbcxP9fvhk4kbidmO5NM4P6X0XzF5ACShHjhsukHJFW5Vht27V0JdoYgSSyiqISb2BgSZZM1ZI+xxQ5XrkbEojMvcvawLunsd8ZoASARTMfSp+SCvzvLOww6oNNDXRgJl9eLekJICEtHnfNPpULahKKcbcDxRmQ8f52+iQxf/fYaQUnyRgzxZIn3E68XOulAgtAtpHZU41Fy/a62CJLopNPQkQf+QIim0fj6DE5i14qs8uNGpiMyN6LhoZMAQ/7KmhsvsPPbbSSukTpOVsE/XnzpxIwVJus/MSrJHZAGx77fyCxpo3ObnyfsZCTS2EAcko75detqVSjKsZHUSMan5gT9B+cD/miEl5wvK2KRGd48157myJDlMQpRhfMwXhxgPiyHDVNrYBkH8Pc7PoE8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1BF03CB9B9C22748AA767939E8E815B8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99d0a0cb-6d92-401a-bb60-08d71529d687
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 20:09:33.1047
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2533
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTMwIGF0IDEyOjM3IC0wNDAwLCBXaWxsZW0gZGUgQnJ1aWpuIHdyb3Rl
Og0KPiBPbiBUdWUsIEp1bCAzMCwgMjAxOSBhdCAxMjoxNiBQTSBXaWxsZW0gZGUgQnJ1aWpuDQo+
IDx3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPiB3cm90ZToNCj4gPiBPbiBNb24sIEp1
bCAyOSwgMjAxOSBhdCA3OjUwIFBNIFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29t
DQo+ID4gPiB3cm90ZToNCj4gPiA+IEZyb206IFZsYWQgQnVzbG92IDx2bGFkYnVAbWVsbGFub3gu
Y29tPg0KPiA+ID4gDQo+ID4gPiBJbiBvcmRlciB0byByZW1vdmUgZGVwZW5kZW5jeSBvbiBydG5s
IGxvY2ssIGFjY2VzcyB0byB0YyBmbG93cw0KPiA+ID4gaGFzaHRhYmxlDQo+ID4gPiBtdXN0IGJl
IGV4cGxpY2l0bHkgcHJvdGVjdGVkIGZyb20gY29uY3VycmVudCBmbG93cyByZW1vdmFsLg0KPiA+
ID4gDQo+ID4gPiBFeHRlbmQgdGMgZmxvdyBzdHJ1Y3R1cmUgd2l0aCByY3UgdG8gYWxsb3cgY29u
Y3VycmVudCBwYXJhbGxlbA0KPiA+ID4gYWNjZXNzLiBVc2UNCj4gPiA+IHJjdSByZWFkIGxvY2sg
dG8gc2FmZWx5IGxvb2t1cCBmbG93IGluIHRjIGZsb3dzIGhhc2ggdGFibGUsIGFuZA0KPiA+ID4g
dGFrZQ0KPiA+ID4gcmVmZXJlbmNlIHRvIGl0LiBVc2UgcmN1IGZyZWUgZm9yIGZsb3cgZGVsZXRp
b24gdG8gYWNjb21tb2RhdGUNCj4gPiA+IGNvbmN1cnJlbnQNCj4gPiA+IHN0YXRzIHJlcXVlc3Rz
Lg0KPiA+ID4gDQo+ID4gPiBBZGQgbmV3IERFTEVURUQgZmxvdyBmbGFnLiBJbWxlbWVudCBuZXcg
Zmxvd19mbGFnX3Rlc3RfYW5kX3NldCgpDQo+ID4gPiBoZWxwZXINCj4gPiA+IHRoYXQgaXMgdXNl
ZCB0byBzZXQgYSBmbGFnIGFuZCByZXR1cm4gaXRzIHByZXZpb3VzIHZhbHVlLiBVc2UgaXQNCj4g
PiA+IHRvDQo+ID4gPiBhdG9taWNhbGx5IHNldCB0aGUgZmxhZyBpbiBtbHg1ZV9kZWxldGVfZmxv
d2VyKCkgdG8gZ3VhcmFudGVlDQo+ID4gPiB0aGF0IGZsb3cgY2FuDQo+ID4gPiBvbmx5IGJlIGRl
bGV0ZWQgb25jZSwgZXZlbiB3aGVuIHNhbWUgZmxvdyBpcyBkZWxldGVkIGNvbmN1cnJlbnRseQ0K
PiA+ID4gYnkNCj4gPiA+IG11bHRpcGxlIHRhc2tzLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBWbGFkIEJ1c2xvdiA8dmxhZGJ1QG1lbGxhbm94LmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5
OiBKaWFuYm8gTGl1IDxqaWFuYm9sQG1lbGxhbm94LmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBS
b2kgRGF5YW4gPHJvaWRAbWVsbGFub3guY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogU2FlZWQg
TWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+IEBAIC0zNDky
LDE2ICszNTA3LDMyIEBAIGludCBtbHg1ZV9kZWxldGVfZmxvd2VyKHN0cnVjdCBuZXRfZGV2aWNl
DQo+ID4gPiAqZGV2LCBzdHJ1Y3QgbWx4NWVfcHJpdiAqcHJpdiwNCj4gPiA+ICB7DQo+ID4gPiAg
ICAgICAgIHN0cnVjdCByaGFzaHRhYmxlICp0Y19odCA9IGdldF90Y19odChwcml2LCBmbGFncyk7
DQo+ID4gPiAgICAgICAgIHN0cnVjdCBtbHg1ZV90Y19mbG93ICpmbG93Ow0KPiA+ID4gKyAgICAg
ICBpbnQgZXJyOw0KPiA+ID4gDQo+ID4gPiArICAgICAgIHJjdV9yZWFkX2xvY2soKTsNCj4gPiA+
ICAgICAgICAgZmxvdyA9IHJoYXNodGFibGVfbG9va3VwX2Zhc3QodGNfaHQsICZmLT5jb29raWUs
DQo+ID4gPiB0Y19odF9wYXJhbXMpOw0KPiA+ID4gLSAgICAgICBpZiAoIWZsb3cgfHwgIXNhbWVf
Zmxvd19kaXJlY3Rpb24oZmxvdywgZmxhZ3MpKQ0KPiA+ID4gLSAgICAgICAgICAgICAgIHJldHVy
biAtRUlOVkFMOw0KPiA+ID4gKyAgICAgICBpZiAoIWZsb3cgfHwgIXNhbWVfZmxvd19kaXJlY3Rp
b24oZmxvdywgZmxhZ3MpKSB7DQo+ID4gPiArICAgICAgICAgICAgICAgZXJyID0gLUVJTlZBTDsN
Cj4gPiA+ICsgICAgICAgICAgICAgICBnb3RvIGVycm91dDsNCj4gPiA+ICsgICAgICAgfQ0KPiA+
ID4gDQo+ID4gPiArICAgICAgIC8qIE9ubHkgZGVsZXRlIHRoZSBmbG93IGlmIGl0IGRvZXNuJ3Qg
aGF2ZQ0KPiA+ID4gTUxYNUVfVENfRkxPV19ERUxFVEVEIGZsYWcNCj4gPiA+ICsgICAgICAgICog
c2V0Lg0KPiA+ID4gKyAgICAgICAgKi8NCj4gPiA+ICsgICAgICAgaWYgKGZsb3dfZmxhZ190ZXN0
X2FuZF9zZXQoZmxvdywgREVMRVRFRCkpIHsNCj4gPiA+ICsgICAgICAgICAgICAgICBlcnIgPSAt
RUlOVkFMOw0KPiA+ID4gKyAgICAgICAgICAgICAgIGdvdG8gZXJyb3V0Ow0KPiA+ID4gKyAgICAg
ICB9DQo+ID4gPiAgICAgICAgIHJoYXNodGFibGVfcmVtb3ZlX2Zhc3QodGNfaHQsICZmbG93LT5u
b2RlLCB0Y19odF9wYXJhbXMpOw0KPiA+ID4gKyAgICAgICByY3VfcmVhZF91bmxvY2soKTsNCj4g
PiA+IA0KPiA+ID4gICAgICAgICBtbHg1ZV9mbG93X3B1dChwcml2LCBmbG93KTsNCj4gPiANCj4g
PiBEZXJlZmVyZW5jaW5nIGZsb3cgb3V0c2lkZSByY3UgcmVhZHNpZGUgY3JpdGljYWwgc2VjdGlv
bj8gRG9lcyBhDQo+ID4gYnVpbGQNCj4gPiB3aXRoIGxvY2tkZXAgbm90IGNvbXBsYWluPw0KPiAN
Cj4gRWggbm8sIGl0IHdvbid0LiBUaGUgc3VycHJpc2luZyBwYXJ0IHRvIG1lIHdhcyB0byB1c2Ug
YSByZWFkc2lkZQ0KPiBjcml0aWNhbCBzZWN0aW9uIHdoZW4gcGVyZm9ybWluZyBhIHdyaXRlIGFj
dGlvbiBvbiBhbiBSQ1UgcHRyLiBUaGUNCj4gREVMRVRFRCBmbGFnIGVuc3VyZXMgdGhhdCBtdWx0
aXBsZSB3cml0ZXJzIHdpbGwgbm90IGNvbXBldGUgdG8gY2FsbA0KPiByaGFzaHRhYmxlX3JlbW92
ZV9mYXN0LiByY3VfcmVhZF9sb2NrIGlzIGEgY29tbW9uIHBhdHRlcm4gdG8gZG8NCj4gcmhhc2h0
YWJsZSBsb29rdXAgKyBkZWxldGUuDQo+IA0KDQpjb3JyZWN0Lg0KDQo=
