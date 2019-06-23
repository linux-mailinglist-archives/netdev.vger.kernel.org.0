Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6976C4FB63
	for <lists+netdev@lfdr.de>; Sun, 23 Jun 2019 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFWLx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jun 2019 07:53:59 -0400
Received: from mail-eopbgr00083.outbound.protection.outlook.com ([40.107.0.83]:7843
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726453AbfFWLx7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jun 2019 07:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vZiJAIZzuHCp2wermD4N6Wuo0Qr3dhXvIAq3SyqS48=;
 b=jdGQbOI8i7oc9EB/OE1g0pZyJwkOzQZusL4O7iOkGBqbgQ8S0WELVpWJhl7PLhnED1b9LPGmvbk2+HHLoTit78NBVPptBOe7iw3hp7G0BMFV4vc7fOZIKFKSzxz27Ja+zjuhyl9UTsVUHMgIAW8h+YAYFWSSRU/YC2Su3vIxz1Q=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6300.eurprd05.prod.outlook.com (20.179.40.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sun, 23 Jun 2019 11:53:50 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::f108:af4c:575e:83c]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::f108:af4c:575e:83c%7]) with mapi id 15.20.2008.014; Sun, 23 Jun 2019
 11:53:50 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Saeed Mahameed <saeedm@dev.mellanox.co.il>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
CC:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v5 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Topic: [PATCH bpf-next v5 00/16] AF_XDP infrastructure improvements and
 mlx5e support
Thread-Index: AQHVJc1yhr4qzEhOK0mpzi+V0aD6WKakRTeAgAJExYCAAp8BAA==
Date:   Sun, 23 Jun 2019 11:53:50 +0000
Message-ID: <39ee9568-125c-3dea-9e2a-0bd558f63505@mellanox.com>
References: <20190618120024.16788-1-maximmi@mellanox.com>
 <CAJ+HfNia-vUv7Eumfs8aMYGGkxPbbUQ++F+BQ=9C1NtP0Jt3hA@mail.gmail.com>
 <CALzJLG-eCiYYshkm_op1PqkCmxTmdDdPSGbX7g2JMqTb8QXyJg@mail.gmail.com>
In-Reply-To: <CALzJLG-eCiYYshkm_op1PqkCmxTmdDdPSGbX7g2JMqTb8QXyJg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0051.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::15) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 165e4fa1-ce2c-4ea5-78fd-08d6f7d174f5
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6300;
x-ms-traffictypediagnostic: DBBPR05MB6300:
x-microsoft-antispam-prvs: <DBBPR05MB630024C103F18F58A6FBBA7FAEE10@DBBPR05MB6300.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00770C4423
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(396003)(39860400002)(136003)(51914003)(199004)(189003)(66946007)(71200400001)(36756003)(110136005)(71190400001)(229853002)(6436002)(8676002)(81166006)(25786009)(81156014)(54906003)(11346002)(486006)(5024004)(4326008)(3846002)(53936002)(6116002)(478600001)(316002)(305945005)(31686004)(256004)(14444005)(7736002)(6512007)(8936002)(6246003)(186003)(66574012)(26005)(86362001)(31696002)(64756008)(66446008)(386003)(6506007)(99286004)(66066001)(76176011)(52116002)(446003)(6486002)(7416002)(73956011)(68736007)(476003)(2616005)(102836004)(2906002)(5660300002)(14454004)(66476007)(66556008)(53546011)(42413003)(32563001);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6300;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dfP+kvoKSeVlh98yQLA8/fygA4z4IegnO0Z/MYTR/NfvwC2M5mwFb171Pagpwf/MN/qRyxSeG68fhZX/1t4gsOfnmwZof1XkLxqdwEuR3rF0ZmkfhK+gQ/xTBIfODV/E8aXAeJy2mZOT6LMfasZmMN2CuVGESdwkysssqhXFtceZYhmK007ShF4H18O0wwQIhcCwBiysXm1kZA3Ru2Inw0Vt+yPLQT4/fVdM+jZVnXBLcPPUM7jlxdSxAsHkT8ZBavaauh5N4FkdHecSTDo8yomb5v/3wGzB+kLLGrEtrd3D8eoLS1Vy/kmG/yi4Z5DTAy7vLn0lEW+xGLZuNvpfg8gf0/VBzAV1m7tktFNlPuNU/iZBZ+8jGAwSI6sxxPb6Oee+4jtSbxGvh6H/loeFXCqNrBFG+11vv+/iNkZW7gE=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB820DD9F131AA40A4DF23DA60F4EF01@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 165e4fa1-ce2c-4ea5-78fd-08d6f7d174f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2019 11:53:50.6131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6300
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjEvMjAxOSAxMDo1MiBQTSwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+IE9uIFRo
dSwgSnVuIDIwLCAyMDE5IGF0IDI6MTMgQU0gQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAZ21h
aWwuY29tPiB3cm90ZToNCj4+DQo+PiBPbiBUdWUsIDE4IEp1biAyMDE5IGF0IDE0OjAwLCBNYXhp
bSBNaWtpdHlhbnNraXkgPG1heGltbWlAbWVsbGFub3guY29tPiB3cm90ZToNCj4+Pg0KPj4+IFRo
aXMgc2VyaWVzIGNvbnRhaW5zIGltcHJvdmVtZW50cyB0byB0aGUgQUZfWERQIGtlcm5lbCBpbmZy
YXN0cnVjdHVyZQ0KPj4+IGFuZCBBRl9YRFAgc3VwcG9ydCBpbiBtbHg1ZS4gVGhlIGluZnJhc3Ry
dWN0dXJlIGltcHJvdmVtZW50cyBhcmUNCj4+PiByZXF1aXJlZCBmb3IgbWx4NWUsIGJ1dCBhbHNv
IHNvbWUgb2YgdGhlbSBiZW5lZml0IHRvIGFsbCBkcml2ZXJzLCBhbmQNCj4+PiBzb21lIGNhbiBi
ZSB1c2VmdWwgZm9yIG90aGVyIGRyaXZlcnMgdGhhdCB3YW50IHRvIGltcGxlbWVudCBBRl9YRFAu
DQo+Pj4NCj4+PiBUaGUgcGVyZm9ybWFuY2UgdGVzdGluZyB3YXMgcGVyZm9ybWVkIG9uIGEgbWFj
aGluZSB3aXRoIHRoZSBmb2xsb3dpbmcNCj4+PiBjb25maWd1cmF0aW9uOg0KPj4+DQo+Pj4gLSAy
NCBjb3JlcyBvZiBJbnRlbCBYZW9uIEU1LTI2MjAgdjMgQCAyLjQwIEdIeg0KPj4+IC0gTWVsbGFu
b3ggQ29ubmVjdFgtNSBFeCB3aXRoIDEwMCBHYml0L3MgbGluaw0KPj4+DQo+Pj4gVGhlIHJlc3Vs
dHMgd2l0aCByZXRwb2xpbmUgZGlzYWJsZWQsIHNpbmdsZSBzdHJlYW06DQo+Pj4NCj4+PiB0eG9u
bHk6IDMzLjMgTXBwcyAoMjEuNSBNcHBzIHdpdGggcXVldWUgYW5kIGFwcCBwaW5uZWQgdG8gdGhl
IHNhbWUgQ1BVKQ0KPj4+IHJ4ZHJvcDogMTIuMiBNcHBzDQo+Pj4gbDJmd2Q6IDkuNCBNcHBzDQo+
Pj4NCj4+PiBUaGUgcmVzdWx0cyB3aXRoIHJldHBvbGluZSBlbmFibGVkLCBzaW5nbGUgc3RyZWFt
Og0KPj4+DQo+Pj4gdHhvbmx5OiAyMS4zIE1wcHMgKDE0LjEgTXBwcyB3aXRoIHF1ZXVlIGFuZCBh
cHAgcGlubmVkIHRvIHRoZSBzYW1lIENQVSkNCj4+PiByeGRyb3A6IDkuOSBNcHBzDQo+Pj4gbDJm
d2Q6IDYuOCBNcHBzDQo+Pj4NCj4+PiB2MiBjaGFuZ2VzOg0KPj4+DQo+Pj4gQWRkZWQgcGF0Y2hl
cyBmb3IgbWx4NWUgYW5kIGFkZHJlc3NlZCB0aGUgY29tbWVudHMgZm9yIHYxLiBSZWJhc2VkIGZv
cg0KPj4+IGJwZi1uZXh0Lg0KPj4+DQo+Pj4gdjMgY2hhbmdlczoNCj4+Pg0KPj4+IFJlYmFzZWQg
Zm9yIHRoZSBuZXdlciBicGYtbmV4dCwgcmVzb2x2ZWQgY29uZmxpY3RzIGluIGxpYmJwZi4gQWRk
cmVzc2VkDQo+Pj4gQmrDtnJuJ3MgY29tbWVudHMgZm9yIGNvZGluZyBzdHlsZS4gRml4ZWQgYSBi
dWcgaW4gZXJyb3IgaGFuZGxpbmcgZmxvdyBpbg0KPj4+IG1seDVlX29wZW5feHNrLg0KPj4+DQo+
Pj4gdjQgY2hhbmdlczoNCj4+Pg0KPj4+IFVBUEkgaXMgbm90IGNoYW5nZWQsIFhTSyBSWCBxdWV1
ZXMgYXJlIGV4cG9zZWQgdG8gdGhlIGtlcm5lbC4gVGhlIGxvd2VyDQo+Pj4gaGFsZiBvZiB0aGUg
YXZhaWxhYmxlIGFtb3VudCBvZiBSWCBxdWV1ZXMgYXJlIHJlZ3VsYXIgcXVldWVzLCBhbmQgdGhl
DQo+Pj4gdXBwZXIgaGFsZiBhcmUgWFNLIFJYIHF1ZXVlcy4gVGhlIHBhdGNoICJ4c2s6IEV4dGVu
ZCBjaGFubmVscyB0byBzdXBwb3J0DQo+Pj4gY29tYmluZWQgWFNLL25vbi1YU0sgdHJhZmZpYyIg
d2FzIGRyb3BwZWQuIFRoZSBmaW5hbCBwYXRjaCB3YXMgcmV3b3JrZWQNCj4+PiBhY2NvcmRpbmds
eS4NCj4+Pg0KPj4+IEFkZGVkICJuZXQvbWx4NWU6IEF0dGFjaC9kZXRhY2ggWERQIHByb2dyYW0g
c2FmZWx5IiwgYXMgdGhlIGNoYW5nZXMNCj4+PiBpbnRyb2R1Y2VkIGluIHRoZSBYU0sgcGF0Y2gg
YmFzZSBvbiB0aGUgc3R1ZmYgZnJvbSB0aGlzIG9uZS4NCj4+Pg0KPj4+IEFkZGVkICJsaWJicGY6
IFN1cHBvcnQgZHJpdmVycyB3aXRoIG5vbi1jb21iaW5lZCBjaGFubmVscyIsIHdoaWNoIGFsaWdu
cw0KPj4+IHRoZSBjb25kaXRpb24gaW4gbGliYnBmIHdpdGggdGhlIGNvbmRpdGlvbiBpbiB0aGUg
a2VybmVsLg0KPj4+DQo+Pj4gUmViYXNlZCBvdmVyIHRoZSBuZXdlciBicGYtbmV4dC4NCj4+Pg0K
Pj4+IHY1IGNoYW5nZXM6DQo+Pj4NCj4+PiBJbiB2NCwgZXRodG9vbCByZXBvcnRzIHRoZSBudW1i
ZXIgb2YgY2hhbm5lbHMgYXMgJ2NvbWJpbmVkJyBhbmQgdGhlDQo+Pj4gbnVtYmVyIG9mIFhTSyBS
WCBxdWV1ZXMgYXMgJ3J4JyBmb3IgbWx4NWUuIEl0IHdhcyBjaGFuZ2VkLCBzbyB0aGF0ICdyeCcN
Cj4+PiBpcyAwLCBhbmQgJ2NvbWJpbmVkJyByZXBvcnRzIHRoZSBkb3VibGUgYW1vdW50IG9mIGNo
YW5uZWxzIGlmIHRoZXJlIGlzDQo+Pj4gYW4gYWN0aXZlIFVNRU0gLSB0byBtYWtlIGxpYmJwZiBo
YXBweS4NCj4+Pg0KPj4+IFRoZSBwYXRjaCBmb3IgbGliYnBmIHdhcyBkcm9wcGVkLiBBbHRob3Vn
aCBpdCdzIHN0aWxsIHVzZWZ1bCBhbmQgZml4ZXMNCj4+PiB0aGluZ3MsIGl0IHJhaXNlcyBzb21l
IGRpc2FncmVlbWVudCwgc28gSSdtIGRyb3BwaW5nIGl0IC0gaXQncyBubyBsb25nZXINCj4+PiB1
c2VmdWwgZm9yIG1seDVlIGFueW1vcmUgYWZ0ZXIgdGhlIGNoYW5nZSBhYm92ZS4NCj4+Pg0KPj4N
Cj4+IEp1c3QgYSBoZWFkcy11cDogVGhlcmUgYXJlIHNvbWUgY2hlY2twYXRjaCB3YXJuaW5ncyAo
PjgwIGNoYXJzL2xpbmUpDQo+IA0KPiBUaGFua3MgQmpvcm4gZm9yIHlvdXIgY29tbWVudCwgaW4g
bWx4NSB3ZSBhbGxvdyB1cCB0byA5NSBjaGFycyBwZXIgbGluZSwNCj4gb3RoZXJ3aXNlIGl0IGlz
IGdvaW5nIHRvIGJlIGFuIHVnbHkgemlnemFncy4NCj4gDQo+PiBmb3IgdGhlIG1sbng1IGRyaXZl
ciBwYXJ0cywgYW5kIHRoZSBzZXJpZXMgZGlkbid0IGFwcGx5IGNsZWFubHkgb24NCj4+IGJwZi1u
ZXh0IGZvciBtZS4NCj4+DQo+PiBJIGhhdmVuJ3QgYmVlbiBhYmxlIHRvIHRlc3QgdGhlIG1sbng1
IHBhcnRzLg0KPj4NCj4+IFBhcnRzIG9mIHRoZSBzZXJpZXMgYXJlIHVucmVsYXRlZC9vcnRob2dv
bmFsLCBhbmQgY291bGQgYmUgc3VibWl0dGVkDQo+PiBhcyBzZXBhcmF0ZSBzZXJpZXMsIGUuZy4g
cGF0Y2hlcyB7MSw3fSBhbmQgcGF0Y2hlcyB7Myw0fS4gTm8gYmxvY2tlcnMNCj4+IGZvciBtZSwg
dGhvdWdoLg0KPj4NCj4+IFRoYW5rcyBmb3IgdGhlIGhhcmQgd29yayENCj4+DQo+PiBGb3IgdGhl
IHNlcmllczoNCj4+IEFja2VkLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5j
b20+DQoNCkp1c3Qgd2FudGVkIHRvIG1ha2Ugc3VyZSB3ZSdyZSBvbiB0aGUgc2FtZSBwYWdlLCBz
byB3ZSBkb24ndCBtaXNzIHRoaXMgDQprZXJuZWwuDQoNCkFJVSwgY3VycmVudGx5IG5vIGFjdGlv
biBpcyBuZWVkZWQgZnJvbSBNYXhpbSdzIHNpZGUsIGFzIFNhZWVkIGlzIGZpbmUgDQp3aXRoIHRo
ZSBtbHg1IHBhcnQsIGFuZCBzZXJpZXMgaXMgc3RpbGwgbWFya2VkIGFzICdOZXcnIGluIHBhdGNo
d29ya3MgDQp3aXRoIG5vIHJlcXVlc3RlZCBjaGFuZ2VzLg0KDQpSZWdhcmRzLA0KVGFyaXENCg==
