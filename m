Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EB21E8D99
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725814AbgE3EHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:07:23 -0400
Received: from mail-db8eur05on2089.outbound.protection.outlook.com ([40.107.20.89]:38473
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725536AbgE3EHX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:07:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PjpJQ+hb0IQxryTDOfCbyI81EPuCSTSNHuLSXD0I3fSYXcCwkhBDDfQeXWHptGccRiVe9rW917xKQEaHdNX7MDC4m0FRxSlwL1QcAG24wNzZuNV9whsYeIPEt3hscH2PTtYjrlDHj0jCeh0rw8pKP/X8MnidUsGjqqiCg3tC2mvP+wkp79NJ7dasPsZiC3yY2Eu962BhEjbEtXNO2fkrEQpOM+PYVLqfqFehtVCNkTflrXvkMR8HAAIO0O2RSvrnBVsK2Fc0IFrXaSD4Fhu0hZHyfuYTSTXaGEL0myDKdOBEVfLUn8EQQVDooxdoea+Y9XDBzeLbLihxh9dYbgUkzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3htXjww4MK+S/P0Rc30jVmsc9xc69wp5riNEbYdMaII=;
 b=WNe/U1WNrtB8pJZgEft4sr8s+ya73GgotVLvsW/UZfogDtIoYEWICC6SUUCaXKCOxyiz8PiL3LiLvy0FkAHbW9QlnrfPyDA8c0n77I9X6+Kf4sK9Jno6D9hzTY3vDjcpnWLraUAA2Os7Tx3+YbJfrIUGe5pIEYDYDLjLf1Xx/Mn3P6QW8SuQshfX7JvtwvWjXITnY2FOUhS/vbsxkiwB/cK8eu6S3t4HaUtrAK2sRLpyM17tiQtKVRIlKybdw1s0HTLSv80guf1eJpMczmbplGiB3AI/5HQkevLXq2yOvTNpn9nZAUNnc3W+NocarGHmx38Og82aMnb3d1TocJgM3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3htXjww4MK+S/P0Rc30jVmsc9xc69wp5riNEbYdMaII=;
 b=ZRhI3xIwPm29PYExf+4hf7r2VzqQWIY0bumvLiVUJYT7WSKf0o6/7J52b6gqCVmx1Q8mvG3ZS5cmYh64QO9jj+3HLAXFWQFztdXQ5n8y44huJohHsJJI+QKKMUd7dqMJjrZ+oIx2SBjp0uMi8inug/I3CPvJp1QMB8pz2a20PSI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6656.eurprd05.prod.outlook.com (2603:10a6:800:13d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:07:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:07:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Boris Pismenny <borisp@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Thread-Topic: [net-next 10/11] net/mlx5e: kTLS, Add kTLS RX resync support
Thread-Index: AQHWNfH6mom1hs1JjU+8qCOucXKJOKi/gDGAgAAHzoCAABKDgIAAD8gAgABZaoA=
Date:   Sat, 30 May 2020 04:07:18 +0000
Message-ID: <cd4b35f3a998d4f3b98b0f7681b90fe2a99a311f.camel@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
         <20200529194641.243989-11-saeedm@mellanox.com>
         <20200529131631.285351a5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <e0b8a4d9395207d553e46cb28e38f37b8f39b99d.camel@mellanox.com>
         <20200529145043.5d218693@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <715f6826c876f78dd79264cc5bc0ae4601a95630.camel@mellanox.com>
In-Reply-To: <715f6826c876f78dd79264cc5bc0ae4601a95630.camel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 599fe438-e9db-4269-24f2-08d8044ef209
x-ms-traffictypediagnostic: VI1PR05MB6656:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB66561BB2C15AE758FA9DB378BE8C0@VI1PR05MB6656.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 041963B986
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 44wTYTcK8PqfxBwjuGrNL/3C7yMkyYWTLKKhX9X24Yb4IbpBbM4Hdbdpj+1F72+AKHrM2+7hW+V5Afy26FfEhL06K/iSW/4D4uXvmq+ox4antxlg2GKIVloNEm23B1DWbA5YAYcgb7Hj+R6nLzJzIKZ2mHNzY6t6V68HZDMCzdULuIareKqaFqTsP5rrO42Ashcl7lXCvpf3yeo392V/DsFg+lOiBG8+FgQIA5w5xpuHmu4BHdfBSR+gUpfx0gRRxWGRVURu6YRr5Nm6GrKHf/pyluyyUsmDSFyDovfkKC7hon0ohUGl3se+XLTNB6vZDv4643vUgROwPKyoTQ37xA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(8936002)(8676002)(107886003)(186003)(86362001)(316002)(54906003)(71200400001)(26005)(5660300002)(110136005)(478600001)(6512007)(2906002)(66476007)(4326008)(66946007)(6506007)(66446008)(64756008)(83380400001)(76116006)(91956017)(66556008)(6486002)(36756003)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hUOlG1Unlb3h7ppRbSlgBuZgEAyl9Qfx/etIiJOlWAz1PbWInQB34L4Nlb1FdD1PH1eDURseARLnvogpTPZjQShxGjupZrE27/PoghRb+kd1njX816/Y/gRF02KYBqcWjuMFdXsJ4i43rf2z/yTbEt7dGU7s34yCrmcEO+5Dj1PnDMMtr8BzQTTfYROKs+g+vAkogmp48Gjc6NBk1BD2QcPtIBe20TH1sZVT1XO/pmZikLdzJRzunt7iq/kPyiJyc/Z+edR9K84UsQKCvST+cY7um6rnn52OcJV4AKbWkYClkLrpyxQhLAvTpbgs0L472W7LfO6xIBiHFZmMMJhxo+qvSr7E37mB71O9Faf1WYxlvuU2vSbKikNXciMc+I3eJsor8pPoXp5Xx5QiJ5r/9zrcCpQAAOy8b12lLPUNtLsF9f0tRQLk/fkgdYdkafHXSXghgOspywj/UxIZw6hj8hpo2NyQCDk/2Z7wiAr+Q8U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <86879A4833A7714EAA4E70131AAE9059@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 599fe438-e9db-4269-24f2-08d8044ef209
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2020 04:07:18.5721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Db9DfKNY0lgeVzdg375sh23ObGx7MJe9nXEoOpqDkI7tMVbWKg+vkb+UBlPfO+/YfpgleOzLC7WtnBaDmoJ4kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6656
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTI5IGF0IDIyOjQ3ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gT24gRnJpLCAyMDIwLTA1LTI5IGF0IDE0OjUwIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90
ZToNCj4gPiBPbiBGcmksIDI5IE1heSAyMDIwIDIwOjQ0OjI5ICswMDAwIFNhZWVkIE1haGFtZWVk
IHdyb3RlOg0KPiA+ID4gPiBJIHRob3VnaHQgeW91IHNhaWQgdGhhdCByZXN5bmMgcmVxdWVzdHMg
YXJlIGd1YXJhbnRlZWQgdG8gbmV2ZXINCj4gPiA+ID4gZmFpbD8NCj4gPiA+IA0KPiA+ID4gSSBk
aWRuJ3Qgc2F5IHRoYXQgOiksICBtYXliZSB0YXJpcSBkaWQgc2F5IHRoaXMgYmVmb3JlIG15IHJl
dmlldywNCj4gPiANCj4gPiBCb3JpcyA7KQ0KPiA+IA0KPiA+ID4gYnV0IGJhc2ljYWxseSB3aXRo
IHRoZSBjdXJyZW50IG1seDUgYXJjaCwgaXQgaXMgaW1wb3NzaWJsZSB0bw0KPiA+ID4gZ3VhcmFu
dGVlDQo+ID4gPiB0aGlzIHVubGVzcyB3ZSBvcGVuIDEgc2VydmljZSBxdWV1ZSBwZXIga3RscyBv
ZmZsb2FkcyBhbmQgdGhhdCBpcw0KPiA+ID4gZ29pbmcNCj4gPiA+IHRvIGJlIGFuIG92ZXJraWxs
IQ0KPiA+IA0KPiA+IElJVUMgZXZlcnkgb29vIHBhY2tldCBjYXVzZXMgYSByZXN5bmMgcmVxdWVz
dCBpbiB5b3VyDQo+ID4gaW1wbGVtZW50YXRpb24NCj4gPiAtDQo+ID4gaXMgdGhhdCB0cnVlPw0K
PiA+IA0KPiANCj4gRm9yIHR4IHllcywgZm9yIFJYIGkgYW0gbm90IHN1cmUsIHRoaXMgaXMgYSBo
dyBmbG93IHRoYXQgSSBhbSBub3QNCj4gZnVsbHkNCj4gZmFtaWxpYXIgd2l0aC4NCj4gDQo+IEFu
eXdheSBhY2NvcmRpbmcgdG8gVGFyaXEsIFRoZSBodyBtaWdodCBnZW5lcmF0ZSBtb3JlIHRoYW4g
b25lIHJlc3luYw0KPiByZXF1ZXN0IG9uIHRoZSBzYW1lIGZsb3csIGFuZCB0aGlzIGlzIGFsbCBi
ZWluZyBoYW5kbGVkIGJ5IHRoZSBkcml2ZXINCj4gY29ycmVjdGx5LiBJIGFtIG5vdCBzdXJlIGlm
IHRoaXMgaXMgd2hhdCB5b3UgYXJlIGxvb2tpbmcgZm9yLg0KPiANCj4gTWF5YmUgVGFyaXEvQm9y
aXMgY2FuIGVsYWJvcmF0ZSBtb3JlIG9uIHRoZSBodyByZXN5bmMgbWVjaGFuaXNtLg0KPiANCj4g
PiBJdCdkIGJlIGdyZWF0IHRvIGhhdmUgbW9yZSBpbmZvcm1hdGlvbiBhYm91dCB0aGUgb3BlcmF0
aW9uIG9mIHRoZQ0KPiA+IGRldmljZSBpbiB0aGUgY29tbWl0IG1lc3NhZ2UuLg0KPiA+IA0KPiAN
Cj4gSG93IGFib3V0Og0KPiANCj4gUmVzeW5jIGZsb3cgb2NjdXJzIHdoZW4gcGFja2V0cyBoYXZl
IGJlZW4gbG9zdCBhbmQgdGhlIGRldmljZSBsb3N0DQo+IHRyYWNrIG9mIFRMUyByZWNvcmRzLiBU
aGUgZGV2aWNlIGF0dGVtcHRzIHRvIHJlc3luYyBieSB0cmFja2luZyBUTFMNCj4gcmVjb3Jkcywg
YW5kIHNlbmRzIGEgcmVzeW5jIHJlcXVlc3QgdG8gZHJpdmVyLiBUaGUgVExTIFByb2dyZXNzDQo+
IFBhcmFtcw0KPiBDb250ZXh0IGhvbGRzIHRoZSBUQ1AtU04gb2YgdGhlIHJlY29yZCB3aGVyZSB0
aGUgZGV2aWNlIGJlZ2FuDQo+IHRyYWNraW5nDQo+IHJlY29yZHMgYW5kIGNvdW50aW5nIHRoZW0u
IFRoZSBkcml2ZXIgd2lsbCBhY2tub3dsZWRnZSB0aGUgVENQLVNOIGlmDQo+IGl0DQo+IG1hdGNo
ZXMgYSBsZWdhbCByZWNvcmQgYnkgc2V0dGluZyB0aGUgVExTIFN0YXRpYyBQYXJhbXMgQ29udGV4
dC4NCj4gDQo+ID8gDQo+IHdlIGNhbiBlbGFib3JhdGUgbW9yZSB3aXRoIGEgc3RlcCBieSBzdGVw
IHByb2NlZHVyZS4uIGlmIHlvdSB0aGluayBpdA0KPiBpcyByZXF1aXJlZC4NCj4gDQo+ID4gPiBU
aGlzIGlzIGEgcmFyZSBjb3JuZXIgY2FzZSBhbnl3YXksIHdoZXJlIG1vcmUgdGhhbiAxayB0Y3AN
Cj4gPiA+IGNvbm5lY3Rpb25zDQo+ID4gPiBzaGFyaW5nIHRoZSBzYW1lIFJYIHJpbmcgd2lsbCBy
ZXF1ZXN0IHJlc3luYyBhdCB0aGUgc2FtZSBleGFjdA0KPiA+ID4gbW9tZW50LiANCj4gPiANCj4g
PiBJREsgYWJvdXQgdGhhdC4gQ2VydGFpbiBhcHBsaWNhdGlvbnMgYXJlIGFyY2hpdGVjdGVkIGZv
ciBtYXgNCj4gPiBjYXBhY2l0eSwNCj4gPiBub3QgZWZmaWNpZW5jeSB1bmRlciBzdGVhZHkgbG9h
ZC4gU28gaXQgbWF0dGVycyBhIGxvdCBob3cgdGhlDQo+ID4gc3lzdGVtDQo+ID4gYmVoYXZlcyB1
bmRlciBzdHJlc3MuIFdoYXQgaWYgdGhpcyBpcyB0aGUgY2hhaW4gb2YgZXZlbnRzOg0KPiA+IA0K
PiA+IG92ZXJsb2FkIC0+IGRyb3BzIC0+IFRMUyBzdGVhbXMgZ28gb3V0IG9mIHN5bmMgLT4gYWxs
IHRyeSB0byByZXN5bmMNCj4gPiANCj4gPiBXZSBkb24ndCB3YW50IHRvIGFkZCBleHRyYSBsb2Fk
IG9uIGV2ZXJ5IHJlY29yZCBpZiBIVyBvZmZsb2FkIGlzDQo+ID4gZW5hYmxlZC4gVGhhdCdzIHdo
eSB0aGUgbmV4dCByZWNvcmQgaGludCBiYWNrcyBvZmYsIGNoZWNrcyBzb2NrZXQgDQo+ID4gc3Rh
dGUgZXRjLg0KPiA+IA0KDQpXaGF0IHdlIGNhbiBkbyBoZXJlIGlzIGluc3RlYWQgb2YgZmFpbGlu
ZyB3aGVuIHRoZSBxdWV1ZSBpcyBmdWxsLCBhDQpyZXN5bmMgcmVxdWVzdCB3aWxsIGtlZXAgdHJ5
aW5nIGFuZCBleHBvbmVudGlhbGx5IGJhY2tvZmYgDQp1cCB0byBvbmNlIHBlciBzZWNvbmQuIHNv
IGV2ZW50dWFsbHkgdGhlIHN5c3RlbSB3aWxsIG5vdCBvdmVybG9hZCBpZg0KdGhlIGh3IHF1ZXVl
IGNhbid0IGtlZXAgdXAsIGFuZCBldmVudHVhbGx5IHRoZSBsYXRlc3QgaHcgcmVzeW5jIHJlcXVl
c3QNCndpbGwgYmUgaGFuZGxlZC4NCg0KPiA+IEJUVyBJIGFsc28gZG9uJ3QgdW5kZXJzdGFuZCB3
aHkgbWx4NWVfa3Rsc19yeF9yZXN5bmMoKSBoYXMgYQ0KPiA+IHRsc19vZmZsb2FkX3J4X2ZvcmNl
X3Jlc3luY19yZXF1ZXN0KHNrKSBhdCB0aGUgZW5kLiBJZiB0aGUgdXBkYXRlIA0KPiA+IGZyb20g
dGhlIE5JQyBjb21lcyB3aXRoIGEgbGF0ZXIgc2VxIHRoYW4gY3VycmVudCwgcmVxdWVzdCB0aGUg
c3luYyANCj4gPiBmb3IgX3RoYXRfIHNlcS4gSSBkb24ndCB1bmRlcnN0YW5kIHRoZSBuZWVkIHRv
IGZvcmNlIGEgY2FsbCBiYWNrIG9uDQo+ID4gZXZlcnkgcmVjb3JkIGhlcmUuIA0KPiANCj4gR29v
ZCBwb2ludCB0aGVvcmV0aWNhbGx5IHNob3VsZCB3b3JrLCB1bmxlc3Mgd2UgaGF2ZSBzb21lIGxp
bWl0YXRpb25zDQo+IHRoYXQgaSBhbSBub3Qgc2VlaW5nLCBpIHdpbGwgbGV0IFRhcmlxIGNvbW1l
bnQgb24gdGhpcy4NCj4gDQoNCkkgdGhpbmsgc2FtZSBhcyBhYm92ZSwgd2UgY2FuIGhpbnQgdG8g
dGhlIGh3IF90aGF0XyBuZXcgc2VxLCANCmFuZCB3aWxsIGJhY2tvZmYgdW50aWwgdGhlIGh3IGNh
dGNoZXMgdXAgd2l0aCBzdyBhbmQgaXNzdWVzIGEgbmV3IHZhbGlkDQpyZXN5bmMgcmVxdWVzdC4N
Cg0KPiA+IEFsc28gaWYgdGhlIHN5bmMgZmFpbGVkIGJlY2F1c2UgcXVldWUgd2FzIGZ1bGwsIEkg
ZG9uJ3Qgc2VlIGhvdw0KPiA+IGZvcmNpbmcgDQo+ID4gYW5vdGhlciBzeW5jIGF0dGVtcHQgZm9y
IHRoZSBuZXh0IHJlY29yZCBpcyBnb2luZyB0byBtYXRjaD8NCj4gDQo+IEluIHRoaXMgY2FzZSBp
IGd1ZXNzIHdlIG5lZWQgdG8gYWJvcnQgYW5kIHdhaXQgZm9yIHRoZSBodyB0byBpc3N1ZQ0KPiBh
bmV3IHJlc3luYyByZXF1ZXN0IC4uIA0K
