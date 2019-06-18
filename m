Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4BFD49FFD
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727584AbfFRMA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:00:26 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:26174
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725913AbfFRMA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:00:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iD1IzA6ACil6NFGhAV54pe9oibElY98XAT18TFQTLMk=;
 b=ToeffsvhyQa7IHz/XNaSnySD7i23ZSQ3j3ozU8sllPX3BtjB6crE+/hzBr8+TopMGqBJnjsovMuyWldcL7SGD8CTnolk/mwMmaDGkoJG2yFskw2fCQIe0c6DKjb0H4a1xxCj2KSuQfesMuXp66lJzPKpDMU6hSnM8QmIhODE2Uo=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5333.eurprd05.prod.outlook.com (20.177.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 18 Jun 2019 12:00:18 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:17 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
CC:     Jakub Kicinski <jakub.kicinski@netronome.com>,
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
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Topic: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Index: AQHVITdxVC+hU8LhkUKnNDgy7zjLlaaYdxEAgAEneoCAAAxZgIABe9mAgABAc4CABfEdAA==
Date:   Tue, 18 Jun 2019 12:00:12 +0000
Message-ID: <4b65eeb9-194c-0716-3362-228899513cdc@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-8-maximmi@mellanox.com>
 <20190612132352.7ee27bf3@cakuba.netronome.com>
 <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
 <20190613164514.00002f66@gmail.com>
 <eb175575-1ab4-4d29-1dc9-28d85cddd842@mellanox.com>
 <20190614191549.0000374d@gmail.com>
In-Reply-To: <20190614191549.0000374d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P190CA0046.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:52::35)
 To AM6PR05MB5879.eurprd05.prod.outlook.com (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7361026-2c9a-4ec2-508a-08d6f3e48386
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5333;
x-ms-traffictypediagnostic: AM6PR05MB5333:
x-microsoft-antispam-prvs: <AM6PR05MB53338AD769EC089121BAC040D1EA0@AM6PR05MB5333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(305945005)(66556008)(476003)(11346002)(66476007)(386003)(68736007)(478600001)(2616005)(6916009)(66066001)(66946007)(73956011)(86362001)(6436002)(66446008)(25786009)(26005)(81156014)(6486002)(64756008)(1411001)(446003)(6506007)(4326008)(316002)(81166006)(8676002)(102836004)(8936002)(54906003)(486006)(186003)(53546011)(229853002)(6512007)(7416002)(6666004)(31686004)(53936002)(71200400001)(76176011)(71190400001)(14444005)(5024004)(52116002)(36756003)(256004)(31696002)(14454004)(6246003)(6116002)(3846002)(5660300002)(7736002)(99286004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5333;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: tZw4O++ubW0it1quleMzYJYvZK2KIitwSPI0ApgMkdMRiJQlmYwO5vFbC5kap885TCio0ddkOzVJYord0qvehFqh/OebugmeHacCGjWDWntJ6Er62mnRB0Y+X35nUAiKyZ8hxzrSMIl5Br2rUghGQZV5WLponbQP9P3B+dpAXKRZ6qU43efcpH2prLVurIJEZi7HLiAcE82WzAw0VbL6otQHRJiQqWCyIbhrBI/8Y+XKNyFC5g59vS6RF0WjkQo3UjiMZT4m9G1+kausnx8iBfggoh3DP8c3HDs/3tisK0rFEC/iEa3OQI0ux/eHKOEYkW4Vq6W8JGDm0PY/+7J8r9sMhoU10pd+w2FG6FgEqpH+oFqbn86uAuWxxjE7hVYupvhnKFehIjhzCZjCgk7//xluwZe0Nsn8J0azm6bsIUU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <52DB783F6F10D8438E2282E64BCD1BC8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7361026-2c9a-4ec2-508a-08d6f3e48386
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:13.6356
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xNCAyMDoxNSwgTWFjaWVqIEZpamFsa293c2tpIHdyb3RlOg0KPiBPbiBGcmks
IDE0IEp1biAyMDE5IDEzOjI1OjI0ICswMDAwDQo+IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1t
aUBtZWxsYW5veC5jb20+IHdyb3RlOg0KPiANCj4+IE9uIDIwMTktMDYtMTMgMTc6NDUsIE1hY2ll
aiBGaWphbGtvd3NraSB3cm90ZToNCj4+PiBPbiBUaHUsIDEzIEp1biAyMDE5IDE0OjAxOjM5ICsw
MDAwDQo+Pj4gTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4gd3JvdGU6
DQo+Pj4gICAgDQo+Pj4+IE9uIDIwMTktMDYtMTIgMjM6MjMsIEpha3ViIEtpY2luc2tpIHdyb3Rl
Og0KPj4+Pj4gT24gV2VkLCAxMiBKdW4gMjAxOSAxNTo1Njo0OCArMDAwMCwgTWF4aW0gTWlraXR5
YW5za2l5IHdyb3RlOg0KPj4+Pj4+IEN1cnJlbnRseSwgbGliYnBmIHVzZXMgdGhlIG51bWJlciBv
ZiBjb21iaW5lZCBjaGFubmVscyBhcyB0aGUgbWF4aW11bQ0KPj4+Pj4+IHF1ZXVlIG51bWJlci4g
SG93ZXZlciwgdGhlIGtlcm5lbCBoYXMgYSBkaWZmZXJlbnQgbGltaXRhdGlvbjoNCj4+Pj4+Pg0K
Pj4+Pj4+IC0geGRwX3JlZ191bWVtX2F0X3FpZCgpIGFsbG93cyB1cCB0byBtYXgoUlggcXVldWVz
LCBUWCBxdWV1ZXMpLg0KPj4+Pj4+DQo+Pj4+Pj4gLSBldGh0b29sX3NldF9jaGFubmVscygpIGNo
ZWNrcyBmb3IgVU1FTXMgaW4gcXVldWVzIHVwIHRvDQo+Pj4+Pj4gICAgICBjb21iaW5lZF9jb3Vu
dCArIG1heChyeF9jb3VudCwgdHhfY291bnQpLg0KPj4+Pj4+DQo+Pj4+Pj4gbGliYnBmIHNob3Vs
ZG4ndCBsaW1pdCBhcHBsaWNhdGlvbnMgdG8gYSBsb3dlciBtYXggcXVldWUgbnVtYmVyLiBBY2Nv
dW50DQo+Pj4+Pj4gZm9yIG5vbi1jb21iaW5lZCBSWCBhbmQgVFggY2hhbm5lbHMgd2hlbiBjYWxj
dWxhdGluZyB0aGUgbWF4IHF1ZXVlDQo+Pj4+Pj4gbnVtYmVyLiBVc2UgdGhlIHNhbWUgZm9ybXVs
YSB0aGF0IGlzIHVzZWQgaW4gZXRodG9vbC4NCj4+Pj4+Pg0KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6
IE1heGltIE1pa2l0eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQo+Pj4+Pj4gUmV2aWV3
ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4+Pj4+PiBBY2tlZC1i
eTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+Pj4+Pg0KPj4+Pj4gSSBk
b24ndCB0aGluayB0aGlzIGlzIGNvcnJlY3QuICBtYXhfdHggdGVsbHMgeW91IGhvdyBtYW55IFRY
IGNoYW5uZWxzDQo+Pj4+PiB0aGVyZSBjYW4gYmUsIHlvdSBjYW4ndCBhZGQgdGhhdCB0byBjb21i
aW5lZC4gIENvcnJlY3QgY2FsY3VsYXRpb25zIGlzOg0KPj4+Pj4NCj4+Pj4+IG1heF9udW1fY2hh
bnMgPSBtYXgobWF4X2NvbWJpbmVkLCBtYXgobWF4X3J4LCBtYXhfdHgpKQ0KPj4+Pg0KPj4+PiBG
aXJzdCBvZiBhbGwsIEknbSBhbGlnbmluZyB3aXRoIHRoZSBmb3JtdWxhIGluIHRoZSBrZXJuZWws
IHdoaWNoIGlzOg0KPj4+Pg0KPj4+PiAgICAgICAgY3Vyci5jb21iaW5lZF9jb3VudCArIG1heChj
dXJyLnJ4X2NvdW50LCBjdXJyLnR4X2NvdW50KTsNCj4+Pj4NCj4+Pj4gKHNlZSBuZXQvY29yZS9l
dGh0b29sLmMsIGV0aHRvb2xfc2V0X2NoYW5uZWxzKCkpLg0KPj4+Pg0KPj4+PiBUaGUgZm9ybXVs
YSBpbiBsaWJicGYgc2hvdWxkIG1hdGNoIGl0Lg0KPj4+Pg0KPj4+PiBTZWNvbmQsIHRoZSBleGlz
dGluZyBkcml2ZXJzIGhhdmUgZWl0aGVyIGNvbWJpbmVkIGNoYW5uZWxzIG9yIHNlcGFyYXRlDQo+
Pj4+IHJ4IGFuZCB0eCBjaGFubmVscy4gU28sIGZvciB0aGUgZmlyc3Qga2luZCBvZiBkcml2ZXJz
LCBtYXhfdHggZG9lc24ndA0KPj4+PiB0ZWxsIGhvdyBtYW55IFRYIGNoYW5uZWxzIHRoZXJlIGNh
biBiZSwgaXQganVzdCBzYXlzIDAsIGFuZCBtYXhfY29tYmluZWQNCj4+Pj4gdGVsbHMgaG93IG1h
bnkgVFggYW5kIFJYIGNoYW5uZWxzIGFyZSBzdXBwb3J0ZWQuIEFzIG1heF90eCBkb2Vzbid0DQo+
Pj4+IGluY2x1ZGUgbWF4X2NvbWJpbmVkIChhbmQgdmljZSB2ZXJzYSksIHdlIHNob3VsZCBhZGQg
dGhlbSB1cC4NCj4+Pj4gICANCj4+Pj4+PiAgICAgdG9vbHMvbGliL2JwZi94c2suYyB8IDYgKysr
LS0tDQo+Pj4+Pj4gICAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRp
b25zKC0pDQo+Pj4+Pj4NCj4+Pj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi94c2suYyBi
L3Rvb2xzL2xpYi9icGYveHNrLmMNCj4+Pj4+PiBpbmRleCBiZjE1YTgwYTM3YzIuLjg2MTA3ODU3
ZTFmMCAxMDA2NDQNCj4+Pj4+PiAtLS0gYS90b29scy9saWIvYnBmL3hzay5jDQo+Pj4+Pj4gKysr
IGIvdG9vbHMvbGliL2JwZi94c2suYw0KPj4+Pj4+IEBAIC0zMzQsMTMgKzMzNCwxMyBAQCBzdGF0
aWMgaW50IHhza19nZXRfbWF4X3F1ZXVlcyhzdHJ1Y3QgeHNrX3NvY2tldCAqeHNrKQ0KPj4+Pj4+
ICAgICAJCWdvdG8gb3V0Ow0KPj4+Pj4+ICAgICAJfQ0KPj4+Pj4+ICAgICANCj4+Pj4+PiAtCWlm
IChjaGFubmVscy5tYXhfY29tYmluZWQgPT0gMCB8fCBlcnJubyA9PSBFT1BOT1RTVVBQKQ0KPj4+
Pj4+ICsJcmV0ID0gY2hhbm5lbHMubWF4X2NvbWJpbmVkICsgbWF4KGNoYW5uZWxzLm1heF9yeCwg
Y2hhbm5lbHMubWF4X3R4KTsNCj4+Pg0KPj4+IFNvIGluIGNhc2Ugb2YgMzIgSFcgcXVldWVzIHlv
dSdkIGxpa2UgdG8gZ2V0IDY0IGVudHJpZXMgaW4geHNrbWFwPw0KPj4NCj4+ICIzMiBIVyBxdWV1
ZXMiIGlzIG5vdCBxdWl0ZSBjb3JyZWN0LiBJdCB3aWxsIGJlIDMyIGNvbWJpbmVkIGNoYW5uZWxz
LA0KPj4gZWFjaCB3aXRoIG9uZSByZWd1bGFyIFJYIHF1ZXVlIGFuZCBvbmUgWFNLIFJYIHF1ZXVl
IChyZWd1bGFyIFJYIHF1ZXVlcw0KPj4gYXJlIHBhcnQgb2YgUlNTKS4gSW4gdGhpcyBjYXNlLCBJ
J2xsIGhhdmUgNjQgWFNLTUFQIGVudHJpZXMuDQo+Pg0KPj4+IERvIHlvdSBzdGlsbA0KPj4+IGhh
dmUgYSBuZWVkIGZvciBhdHRhY2hpbmcgdGhlIHhza3NvY2tzIHRvIHRoZSBSU1MgcXVldWVzPw0K
Pj4NCj4+IFlvdSBjYW4gYXR0YWNoIGFuIFhTSyB0byBhIHJlZ3VsYXIgUlggcXVldWUsIGJ1dCBu
b3QgaW4gemVyby1jb3B5IG1vZGUuDQo+PiBUaGUgaW50ZW5kZWQgdXNlIGlzLCBvZiBjb3Vyc2Us
IHRvIGF0dGFjaCBYU0tzIHRvIFhTSyBSWCBxdWV1ZXMgaW4NCj4+IHplcm8tY29weSBtb2RlLg0K
Pj4NCj4+PiBJIHRob3VnaHQgeW91IHdhbnQNCj4+PiB0aGVtIHRvIGJlIHNlcGFyYXRlZC4gU28g
aWYgSSdtIHJlYWRpbmcgdGhpcyByaWdodCwgWzAsIDMxXSB4c2ttYXAgZW50cmllcw0KPj4+IHdv
dWxkIGJlIHVudXNlZCBmb3IgdGhlIG1vc3Qgb2YgdGhlIHRpbWUsIG5vPw0KPj4NCj4+IFRoaXMg
aXMgY29ycmVjdCwgYnV0IHRoZXNlIGVudHJpZXMgYXJlIHN0aWxsIG5lZWRlZCBpZiBvbmUgZGVj
aWRlcyB0bw0KPj4gcnVuIGNvbXBhdGliaWxpdHkgbW9kZSB3aXRob3V0IHplcm8tY29weSBvbiBx
dWV1ZXMgMC4uMzEuDQo+IA0KPiBXaHkgd291bGQgSSB3YW50IHRvIHJ1biBBRl9YRFAgd2l0aG91
dCBaQz8gVGhlIG1haW4gcmVhc29uIGZvciBoYXZpbmcgQUZfWERQDQo+IHN1cHBvcnQgaW4gZHJp
dmVycyBpcyB0aGUgemVybyBjb3B5LCByaWdodD8NCg0KWWVzLCBBRl9YRFAgaXMgaW50ZW5kZWQg
dG8gYmUgdXNlZCB3aXRoIHplcm8gY29weSB3aGVuIHRoZSBkcml2ZXIgDQppbXBsZW1lbnRzIGl0
LiBJJ20gbm90IGJyZWFraW5nIHRoZSBjb21wYXRpYmlsaXR5IG1vZGUgaWYgSSBjYW4ga2VlcCBp
dCANCnN1cHBvcnRlZC4NCg0KPiBCZXNpZGVzIHRoYXQsIGFyZSB5b3UgZWR1Y2F0aW5nIHRoZSB1
c2VyIGluIHNvbWUgd2F5IHdoaWNoIHF1ZXVlIGlkcyBzaG91bGQgYmUNCj4gdXNlZCBzbyB0aGVy
ZSdzIFpDIGluIHBpY3R1cmU/IElmIHRoYXQgd2FzIGFscmVhZHkgYXNrZWQvYW5zd2VyZWQsIHRo
ZW4gc29ycnkNCj4gYWJvdXQgdGhhdC4NCg0KVGhlIGRldGFpbHMgYWJvdXQgcXVldWUgSURzIGFy
ZSBpbiB0aGUgY29tbWl0IG1lc3NhZ2UgZm9yIHRoZSBmaW5hbCBwYXRjaC4NCg0KPj4NCj4+PiAg
ICANCj4+Pj4+PiArDQo+Pj4+Pj4gKwlpZiAocmV0ID09IDAgfHwgZXJybm8gPT0gRU9QTk9UU1VQ
UCkNCj4+Pj4+PiAgICAgCQkvKiBJZiB0aGUgZGV2aWNlIHNheXMgaXQgaGFzIG5vIGNoYW5uZWxz
LCB0aGVuIGFsbCB0cmFmZmljDQo+Pj4+Pj4gICAgIAkJICogaXMgc2VudCB0byBhIHNpbmdsZSBz
dHJlYW0sIHNvIG1heCBxdWV1ZXMgPSAxLg0KPj4+Pj4+ICAgICAJCSAqLw0KPj4+Pj4+ICAgICAJ
CXJldCA9IDE7DQo+Pj4+Pj4gLQllbHNlDQo+Pj4+Pj4gLQkJcmV0ID0gY2hhbm5lbHMubWF4X2Nv
bWJpbmVkOw0KPj4+Pj4+ICAgICANCj4+Pj4+PiAgICAgb3V0Og0KPj4+Pj4+ICAgICAJY2xvc2Uo
ZmQpOw0KPj4+Pj4gICAgICAgDQo+Pj4+ICAgDQo+Pj4gICAgDQo+Pg0KPiANCg0K
