Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEA791730B
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 09:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfEHH5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 03:57:48 -0400
Received: from mail-eopbgr50093.outbound.protection.outlook.com ([40.107.5.93]:2542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725860AbfEHH5s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 03:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.se;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ENo8AJONM22XGe8TsR7VWj338UKilLJmk7uWAyPh4eU=;
 b=TLzWsZT5o3TgSiWoorymv74lAcUPCJaiO1dOM2MprMb4ZhPNiaNL7RL46a/iAgbKp77OmXiI02coLX7h1MDSH8ZytEEE2F1uFi9KM1bzSKOIMTcMQZGe4HEUkJCXLaHoAE2cRzOZhVvaGG4D6cYdu6XnB8q4O3jqwqryybok8KA=
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM (20.178.126.212) by
 VI1PR10MB2735.EURPRD10.PROD.OUTLOOK.COM (20.178.127.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.11; Wed, 8 May 2019 07:57:39 +0000
Received: from VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8]) by VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::48b8:9cff:182:f3d8%2]) with mapi id 15.20.1856.012; Wed, 8 May 2019
 07:57:38 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
Thread-Topic: [RFC PATCH 1/5] net: dsa: mv88e6xxx: introduce support for two
 chips using direct smi addressing
Thread-Index: AQHVAFSRDSaXDG0750O+aewkwJZ2+6ZWtaaAgAoxFgA=
Date:   Wed, 8 May 2019 07:57:38 +0000
Message-ID: <f5924091-352c-c14a-f959-6bb8a32746e3@prevas.dk>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-2-rasmus.villemoes@prevas.dk>
 <20190501201919.GC19809@lunn.ch>
In-Reply-To: <20190501201919.GC19809@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0701CA0053.eurprd07.prod.outlook.com
 (2603:10a6:3:9e::21) To VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:803:e3::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Rasmus.Villemoes@prevas.se; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [81.216.59.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39cbdb05-87ed-4f5d-b832-08d6d38ad6e8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:VI1PR10MB2735;
x-ms-traffictypediagnostic: VI1PR10MB2735:
x-microsoft-antispam-prvs: <VI1PR10MB2735405A1DB67DACD2F6372A8A320@VI1PR10MB2735.EURPRD10.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0031A0FFAF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39850400004)(366004)(346002)(376002)(189003)(199004)(44832011)(476003)(446003)(11346002)(14454004)(66476007)(42882007)(66446008)(64756008)(2616005)(486006)(66946007)(73956011)(478600001)(316002)(14444005)(256004)(6512007)(72206003)(31696002)(6436002)(71190400001)(71200400001)(26005)(36756003)(6486002)(186003)(386003)(6506007)(81166006)(81156014)(305945005)(25786009)(66556008)(76176011)(8976002)(5660300002)(68736007)(52116002)(74482002)(66066001)(229853002)(8936002)(8676002)(31686004)(7736002)(99286004)(54906003)(3846002)(6116002)(6916009)(6246003)(102836004)(2906002)(53936002)(4326008);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR10MB2735;H:VI1PR10MB2672.EURPRD10.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: prevas.se does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QdVc4ECyVIqHZFwiSWCdSsAVlQPVLruvrsjkSpFIhlpJao0DA+wLredLDSccc22SHesvFsL8oM9D5y9lHLI7yoHmx7xl7fdo2xUhrcsb0QaTsJ8xwpqGwHxJDh0ahTGuww67JsggIOEmzrDlFJg0swt0oJ95ifxu5lMb8LUaPy82LEWenKnP+e+qKf7GKpWKgvoYdUpOggGgA5fK7u43heVRt4k6K82QJX3u+uk1t4HbYt7un/9cRG0MoCod6O5bCxZ1V271MKbjvqRsklKTF5e8M0YP2/rDcRJfHDx09HgOYP+JVVd2/hF8sNL1Oenqim7LdmV5VKdsKB+n/aF+WT34E0hTmOED2GMkXhgzW1eL4vI7KPUbqvodDLyC3RvvYiBJHDDlv5b81UMauMeeSe5B9emPPxP3ci43jbtl74c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F611D2F7F520DF478196BA2B1E6005A9@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 39cbdb05-87ed-4f5d-b832-08d6d38ad6e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2019 07:57:38.8620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB2735
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEvMDUvMjAxOSAyMi4xOSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IE9uIFdlZCwgTWF5IDAx
LCAyMDE5IGF0IDA3OjMyOjEwUE0gKzAwMDAsIFJhc211cyBWaWxsZW1vZXMgd3JvdGU6DQo+PiBU
aGUgODhlNjI1MCAoYXMgd2VsbCBhcyA2MjIwLCA2MDcxLCA2MDcwLCA2MDIwKSBkbyBub3Qgc3Vw
cG9ydA0KPj4gbXVsdGktY2hpcCAoaW5kaXJlY3QpIGFkZHJlc3NpbmcuIEhvd2V2ZXIsIG9uZSBj
YW4gc3RpbGwgaGF2ZSB0d28gb2YNCj4+IHRoZW0gb24gdGhlIHNhbWUgbWRpbyBidXMsIHNpbmNl
IHRoZSBkZXZpY2Ugb25seSB1c2VzIDE2IG9mIHRoZSAzMg0KPj4gcG9zc2libGUgYWRkcmVzc2Vz
LCBlaXRoZXIgYWRkcmVzc2VzIDB4MDAtMHgwRiBvciAweDEwLTB4MUYgZGVwZW5kaW5nDQo+PiBv
biB0aGUgQUREUjQgcGluIGF0IHJlc2V0IFtzaW5jZSBBRERSNCBpcyBpbnRlcm5hbGx5IHB1bGxl
ZCBoaWdoLCB0aGUNCj4+IGxhdHRlciBpcyB0aGUgZGVmYXVsdF0uDQo+Pg0KPj4gSW4gb3JkZXIg
dG8gcHJlcGFyZSBmb3Igc3VwcG9ydGluZyB0aGUgODhlNjI1MCBhbmQgZnJpZW5kcywgaW50cm9k
dWNlDQo+PiBtdjg4ZTZ4eHhfaW5mbzo6ZHVhbF9jaGlwIHRvIGFsbG93IGhhdmluZyBhIG5vbi16
ZXJvIHN3X2FkZHIgd2hpbGUNCj4+IHN0aWxsIHVzaW5nIGRpcmVjdCBhZGRyZXNzaW5nLg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IFJhc211cyBWaWxsZW1vZXMgPHJhc211cy52aWxsZW1vZXNAcHJl
dmFzLmRrPg0KPj4gLS0tDQo+PiAgZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMgfCAx
MCArKysrKysrLS0tDQo+PiAgZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmggfCAgNSAr
KysrKw0KPj4gIDIgZmlsZXMgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMo
LSkNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMg
Yi9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4L2NoaXAuYw0KPj4gaW5kZXggYzA3OGM3OTFmNDgx
Li5mNjZkYWE3Nzc3NGIgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbXY4OGU2eHh4
L2NoaXAuYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL212ODhlNnh4eC9jaGlwLmMNCj4+IEBA
IC02Miw2ICs2MiwxMCBAQCBzdGF0aWMgdm9pZCBhc3NlcnRfcmVnX2xvY2soc3RydWN0IG12ODhl
Nnh4eF9jaGlwICpjaGlwKQ0KPj4gICAqIFdoZW4gQUREUiBpcyBub24temVybywgdGhlIGNoaXAg
dXNlcyBNdWx0aS1jaGlwIEFkZHJlc3NpbmcgTW9kZSwgYWxsb3dpbmcNCj4+ICAgKiBtdWx0aXBs
ZSBkZXZpY2VzIHRvIHNoYXJlIHRoZSBTTUkgaW50ZXJmYWNlLiBJbiB0aGlzIG1vZGUgaXQgcmVz
cG9uZHMgdG8gb25seQ0KPj4gICAqIDIgcmVnaXN0ZXJzLCB1c2VkIHRvIGluZGlyZWN0bHkgYWNj
ZXNzIHRoZSBpbnRlcm5hbCBTTUkgZGV2aWNlcy4NCj4+ICsgKg0KPj4gKyAqIFNvbWUgY2hpcHMg
dXNlIGEgZGlmZmVyZW50IHNjaGVtZTogT25seSB0aGUgQUREUjQgcGluIGlzIHVzZWQgZm9yDQo+
PiArICogY29uZmlndXJhdGlvbiwgYW5kIHRoZSBkZXZpY2UgcmVzcG9uZHMgdG8gMTYgb2YgdGhl
IDMyIFNNSQ0KPj4gKyAqIGFkZHJlc3NlcywgYWxsb3dpbmcgdHdvIHRvIGNvZXhpc3Qgb24gdGhl
IHNhbWUgU01JIGludGVyZmFjZS4NCj4+ICAgKi8NCj4+ICANCj4+ICBzdGF0aWMgaW50IG12ODhl
Nnh4eF9zbWlfcmVhZChzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQo+PiBAQCAtODcsNyAr
OTEsNyBAQCBzdGF0aWMgaW50IG12ODhlNnh4eF9zbWlfc2luZ2xlX2NoaXBfcmVhZChzdHJ1Y3Qg
bXY4OGU2eHh4X2NoaXAgKmNoaXAsDQo+PiAgew0KPj4gIAlpbnQgcmV0Ow0KPj4gIA0KPj4gLQly
ZXQgPSBtZGlvYnVzX3JlYWRfbmVzdGVkKGNoaXAtPmJ1cywgYWRkciwgcmVnKTsNCj4+ICsJcmV0
ID0gbWRpb2J1c19yZWFkX25lc3RlZChjaGlwLT5idXMsIGFkZHIgKyBjaGlwLT5zd19hZGRyLCBy
ZWcpOw0KPj4gIAlpZiAocmV0IDwgMCkNCj4+ICAJCXJldHVybiByZXQ7DQo+PiAgDQo+PiBAQCAt
MTAxLDcgKzEwNSw3IEBAIHN0YXRpYyBpbnQgbXY4OGU2eHh4X3NtaV9zaW5nbGVfY2hpcF93cml0
ZShzdHJ1Y3QgbXY4OGU2eHh4X2NoaXAgKmNoaXAsDQo+PiAgew0KPj4gIAlpbnQgcmV0Ow0KPj4g
IA0KPj4gLQlyZXQgPSBtZGlvYnVzX3dyaXRlX25lc3RlZChjaGlwLT5idXMsIGFkZHIsIHJlZywg
dmFsKTsNCj4+ICsJcmV0ID0gbWRpb2J1c193cml0ZV9uZXN0ZWQoY2hpcC0+YnVzLCBhZGRyICsg
Y2hpcC0+c3dfYWRkciwgcmVnLCB2YWwpOw0KPj4gIAlpZiAocmV0IDwgMCkNCj4+ICAJCXJldHVy
biByZXQ7DQo+IA0KPiBIaSBSYXNtdXMNCj4gDQo+IFRoaXMgd29ya3MsIGJ1dCBpIHRoaW5rIGkg
cHJlZmVyIGFkZGluZyBtdjg4ZTZ4eHhfc21pX2R1YWxfY2hpcF93cml0ZSwNCj4gbXY4OGU2eHh4
X3NtaV9kdWFsX2NoaXBfcmVhZCwgYW5kIGNyZWF0ZSBhDQo+IG12ODhlNnh4eF9zbWlfc2luZ2xl
X2NoaXBfb3BzLg0KDQpIaSBBbmRyZXcNCg0KTm93IHRoYXQgVml2aWVuJ3MgIm5ldDogZHNhOiBt
djg4ZTZ4eHg6IHJlZmluZSBTTUkgc3VwcG9ydCIgaXMgaW4NCm1hc3RlciwgZG8geW91IHN0aWxs
IHByZWZlciBpbnRyb2R1Y2luZyBhIHRoaXJkIGJ1c19vcHMgc3RydWN0dXJlDQoobXY4OGU2eHh4
X3NtaV9kdWFsX2RpcmVjdF9vcHMgPyksIG9yIHdvdWxkIHRoZSBhcHByb2FjaCBvZiBhZGRpbmcN
CmNoaXAtPnN3X2FkZHIgaW4gdGhlIHNtaV9kaXJlY3Rfe3JlYWQvd3JpdGV9IGZ1bmN0aW9ucyBi
ZSBvayAod2hpY2gNCndvdWxkIHRoZW4gcmVxdWlyZSBjaGFuZ2luZyB0aGUgaW5kaXJlY3QgY2Fs
bGVycyB0byBwYXNzIDAgaW5zdGVhZCBvZg0KY2hpcC0+c3dhZGRyKS4NCg0KVGhhbmtzLA0KUmFz
bXVzDQo=
