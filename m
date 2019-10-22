Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7641E0B35
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfJVSKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:10:15 -0400
Received: from mail-eopbgr60056.outbound.protection.outlook.com ([40.107.6.56]:37189
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727154AbfJVSKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 14:10:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cW/QzHRb4/bSFfoiqqX16+LxxtuzNGR8mzSDXP+pt2sQizL59M0qrN10EFFYCTBKTa2MKC5IgbEZeR30Yz59xgVnrRL+VItlBIu5eksP1VjZMHllxGpcpyn330+/VkJrac+dht9yyFy+75e8KdYrROeVjWHfQsXmhBIzdW9JDnyRk1FXKtqENXgbeCuMv0M9EgU4RszQbT9aGNA/IxQ5q4lMauUbA7W5wwyuHDJXd85dJEsJdKqnD1GJ5S+V0lt8lizgfy169T5+vrCNPPR+6O+Y4Z2eGN/eMbNvUFMFCUzL4eVpBwwMFca2LEPihc5ldESd01a+Myw16VGqtEJF0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCIliWgu8ph8ABKWxkNO7UfHgXe/1DyEofo9bq5B62Q=;
 b=GlQoHe3aOzk2ntd9F5ZEyjyYSyNWIdrINn37YIJqdF/YthXUZHqn6myLai380lKLVK89sVQLj6fVaG2aPiwUpKImA2JusOLQbvMRLTFqH9Fy1UYcNf4iAPcZYyK0h/7AgOptwaHFJAJUb2LR99ZBo7DgmZrGImyvJZ7DgF9Ho+bKyjYLZ5HoCHe88FSxirG9qrUPSJhLqTvlLeXwtWK3BkpInKghTr45eaSwMsOwZ+6u2q04FKEdX/xQCGZLIazdPqt11XJZPbmbI5mO2On9mVHpevW+U/j+7yK+DKlRw617T1wU+d+4cJm1PCcfBrlZHIn/20WKgITemdz2bT8VtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCIliWgu8ph8ABKWxkNO7UfHgXe/1DyEofo9bq5B62Q=;
 b=lZ9VxMra8f/3VVrVWcE/BDB/870WTjIOaV8UdH581a2b5BGA/RaDhG2vEozCKiUIg/lvxKTNrC7Z0+cUXxH1G6vKELUii9dKTOiP3BA30JFHq6dz65vW2tfKxi58KhwlFrgK5DOWr0gJ+E0Fw5I6ewGstT+g2KZ4YWBt+hQYm94=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3214.eurprd05.prod.outlook.com (10.175.243.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.21; Tue, 22 Oct 2019 18:10:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 18:10:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Thread-Topic: [net 12/15] net/mlx5e: kTLS, Enhance TX resync flow
Thread-Index: AQHVheubJJkqR3lyxEm2rDcZyu4JaqdhM5oAgAXIWQA=
Date:   Tue, 22 Oct 2019 18:10:11 +0000
Message-ID: <b52dee38856c98dc4702ad269d85cf35d3689cf7.camel@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
         <20191018193737.13959-13-saeedm@mellanox.com>
         <20191018185128.0cc912f8@cakuba.netronome.com>
In-Reply-To: <20191018185128.0cc912f8@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 079da89e-20b3-4c54-d0e0-08d7571b14a2
x-ms-traffictypediagnostic: VI1PR05MB3214:|VI1PR05MB3214:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB32142D72FB03E5EC31C1566BBE680@VI1PR05MB3214.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(189003)(66066001)(229853002)(6512007)(6246003)(6486002)(2351001)(5640700003)(6116002)(3846002)(107886003)(4326008)(7736002)(305945005)(25786009)(81166006)(81156014)(8676002)(8936002)(478600001)(14454004)(64756008)(118296001)(66556008)(66476007)(76116006)(91956017)(6916009)(66946007)(66446008)(6436002)(102836004)(316002)(54906003)(58126008)(446003)(11346002)(186003)(2616005)(476003)(5660300002)(486006)(36756003)(71200400001)(4001150100001)(86362001)(26005)(2501003)(256004)(99286004)(71190400001)(14444005)(76176011)(6506007)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3214;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2oIAEkA1mEmMgNp2FjjEqAf2fU/7ZRrDr6x5dqgHhOAN3rjTHEe6N72Pq+HdLc9FR6lHUwaoUsFmVykP2Rf+IbjsQQ1epIJ4BHQTRkoF6zUkUfswa98gz9lcdsogZj9uDL3ypUJoMEtHUcGCh6fY2Ue2o/yFF/sp7Bv/s/Ubs5bIyjp85Tdd8X7GPxOBjyC8kaCQ7FY3Gi1EZFpjrcIawGPr/yUuNBDef7YCX/4bwRFoM8TAyR3ylbtu5PHKoXQmBFs7U0vLZOltfVhYkoCzop9/cIRqX2yML5xI+75Yy+V9HWGQP9dgjtwNmpjfxMaiTBaIzpKgOyX3vGZHILIVcXNvZpqR8VzyN8rZEVPE23HiUS3MuCC0gQDz/I+522vUbPPrgP6IQpnS+ZiOwiFKUoLKEgBuehT546vzuLFz0vUXbj2hDT9Oh4MbVOFAao4g
Content-Type: text/plain; charset="utf-8"
Content-ID: <299A09280DD5874A902C8340E5E26D51@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079da89e-20b3-4c54-d0e0-08d7571b14a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 18:10:11.6963
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3Swz7oCNft3inhiF/aPxE9RGwXCRqdlb50UL9QiX6RWnFWDrq7fLxXYPyi7Aj+IPjkegZm702mUIxEQy6hrtaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3214
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTEwLTE4IGF0IDE4OjUxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAxOCBPY3QgMjAxOSAxOTozODoyNCArMDAwMCwgU2FlZWQgTWFoYW1lZWQgd3Jv
dGU6DQo+ID4gRnJvbTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiA+IA0K
PiA+IE9uY2UgdGhlIGtUTFMgVFggcmVzeW5jIGZ1bmN0aW9uIGlzIGNhbGxlZCwgaXQgdXNlZCB0
byByZXR1cm4NCj4gPiBhIGJpbmFyeSB2YWx1ZSwgZm9yIHN1Y2Nlc3Mgb3IgZmFpbHVyZS4NCj4g
PiANCj4gPiBIb3dldmVyLCBpbiBjYXNlIHRoZSBUTFMgU0tCIGlzIGEgcmV0cmFuc21pc3Npb24g
b2YgdGhlIGNvbm5lY3Rpb24NCj4gPiBoYW5kc2hha2UsIGl0IGluaXRpYXRlcyB0aGUgcmVzeW5j
IGZsb3cgKGFzIHRoZSB0Y3Agc2VxIGNoZWNrDQo+ID4gaG9sZHMpLA0KPiA+IHdoaWxlIHJlZ3Vs
YXIgcGFja2V0IGhhbmRsZSBpcyBleHBlY3RlZC4NCj4gPiANCj4gPiBJbiB0aGlzIHBhdGNoLCB3
ZSBpZGVudGlmeSB0aGlzIGNhc2UgYW5kIHNraXAgdGhlIHJlc3luYyBvcGVyYXRpb24NCj4gPiBh
Y2NvcmRpbmdseS4NCj4gPiANCj4gPiBDb3VudGVyczoNCj4gPiAtIEFkZCBhIGNvdW50ZXIgKHRs
c19za2lwX25vX3N5bmNfZGF0YSkgdG8gbW9uaXRvciB0aGlzLg0KPiA+IC0gQnVtcCB0aGUgZHVt
cCBjb3VudGVycyB1cCBhcyB0aGV5IGFyZSB1c2VkIG1vcmUgZnJlcXVlbnRseS4NCj4gPiAtIEFk
ZCBhIG1pc3NpbmcgY291bnRlciBkZXNjcmlwdG9yIGRlY2xhcmF0aW9uIGZvciB0bHNfcmVzeW5j
X2J5dGVzDQo+ID4gICBpbiBzcV9zdGF0c19kZXNjLg0KPiA+IA0KPiA+IEZpeGVzOiBkMmVhZDFm
MzYwZTggKCJuZXQvbWx4NWU6IEFkZCBrVExTIFRYIEhXIG9mZmxvYWQgc3VwcG9ydCIpDQo+ID4g
U2lnbmVkLW9mZi1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiANCj4g
Q291bGQgeW91IGRvY3VtZW50IHRoZSBuZXcgY291bnRlciBpbiB0bHMtb2ZmbG9hZC5yc3Q/DQoN
ClRhcmlxIGFscmVhZHkgcHJlcGFyZWQgdGhlIHBhdGNoLCBkbyB3ZSB3YW50IHRoaXMgaW4gbmV0
IG9yIG5ldC1uZXh0ID8gDQptb3N0IG9mIG91ciBrVExTIHVzZXJzIGFyZSBnb2luZyB0byB1c2Ug
NS4zLzUuNCBzdGFibGUga2VybmVscywgYnV0IGkNCmFtIG5vdCBzdXJlIHRoaXMgc2hvdWxkIGdv
IHRvIG5ldC4uIA0KDQpUaGFua3MsDQpTYWVlZC4gDQo=
