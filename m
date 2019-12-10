Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA60A118AC9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 15:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfLJO1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 09:27:01 -0500
Received: from mail-eopbgr00048.outbound.protection.outlook.com ([40.107.0.48]:16710
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727061AbfLJO1A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 09:27:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PswY+42ZEDOA5olBXa4MnRtOIu+gtPUF0Pn2ZTAfeX9T0XKVGgu97vDOnNY32NML+Mm9xSk3LhJjS0xxJmLPfvWaX6mtEEIV7P4Bory4ruDSfJ0SDUmOylZmzMiba7UyPGxcqb/hKDd74sASnvWWN72jC//BQifjfIFbxP1cWaN/WWlf1MYA0uHSroBe4yEzSWO7QW2yfqi4JYYF7YsCuM6ZzBYx5n1TvIwtFmK88QoJNa0LDKLhTd29xypSZUD8Iy030lfr6odkyNqEoPgvkDP6JTbCBp44h3bQ7iWC6me51+8yUMan9vgournzVfacdp1yRc8lHLIBcD0dhlDdvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCM8HZcS76yMRhOSONewq9gIUSVrHxzTOFjNIx9zBGc=;
 b=LkiROb+1ClTwlCI8clxrzOhc5Z99n17qvd/0sCo1Olc4yt1cWjKFjP6gOWpP3KkyQLmWGv83OjDtamGCDcxHvZDMsT7iYpiT0zIgWjSUY2hFABRWzHpYKEKrC9mqw1ghOuezIWxcn2ZAkjjQMXN9LtUk+guYwVTRfH9CZfzB8aIXysVLS8vAK/s2wRKSTXVmD7/Y1hFepsLaYCDPh0rW/SDRge0q00nbAlQERKGNPUUf+5/xqwhlins0qsJm0qrQi7jXuB6fDawOMN6yWpsX3ufDx+BtsQEo8y57bJ3Ylk/ouNEH0i18cyrpB9jin8cjKG28D7JgZNt1L1mIKaVuUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cCM8HZcS76yMRhOSONewq9gIUSVrHxzTOFjNIx9zBGc=;
 b=nxGLrakUveQw1qlOZUSTf58gu/t5PCuwnyEgfPPgvIvmDs43NIueEBe06Xmzt+hoEPSFdpRAhZOisuJ2jual8Wc6/NTkRiNQ/PqeJV43hCnF43I7eoRW7M1IRhZDy4bcmS4hjG2W9wp+qGb5hGrJH2W1m7Vc3fhNqXf1+LUqqRU=
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com (20.178.119.159) by
 AM0PR05MB4643.eurprd05.prod.outlook.com (52.133.58.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.17; Tue, 10 Dec 2019 14:26:44 +0000
Received: from AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e]) by AM0PR05MB5875.eurprd05.prod.outlook.com
 ([fe80::dca5:7e63:8242:685e%7]) with mapi id 15.20.2516.018; Tue, 10 Dec 2019
 14:26:44 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
CC:     Magnus Karlsson <magnus.karlsson@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH bpf 3/4] net/i40e: Fix concurrency issues between config
 flow and XSK
Thread-Topic: [PATCH bpf 3/4] net/i40e: Fix concurrency issues between config
 flow and XSK
Thread-Index: AQHVq4PTP1CGOF24FEqoAXqjM71N8Kes0OoAgAajvQA=
Date:   Tue, 10 Dec 2019 14:26:44 +0000
Message-ID: <121c3135-3b52-1d64-c1e0-26de38687b4f@mellanox.com>
References: <20191205155028.28854-1-maximmi@mellanox.com>
 <20191205155028.28854-4-maximmi@mellanox.com>
 <CAJ+HfNiXPo_Qkja=tCakX6a=swVY_KRMXmT79wQuQa_+kORQ=g@mail.gmail.com>
In-Reply-To: <CAJ+HfNiXPo_Qkja=tCakX6a=swVY_KRMXmT79wQuQa_+kORQ=g@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P193CA0115.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::20) To AM0PR05MB5875.eurprd05.prod.outlook.com
 (2603:10a6:208:12d::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [77.75.144.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: dad1aea8-4f83-4ee0-79e5-08d77d7cfb8f
x-ms-traffictypediagnostic: AM0PR05MB4643:|AM0PR05MB4643:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB46430B121B7DFE8A852390A9D15B0@AM0PR05MB4643.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02475B2A01
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(189003)(43544003)(199004)(66556008)(2616005)(36756003)(64756008)(31686004)(31696002)(26005)(66476007)(66946007)(6506007)(66574012)(71200400001)(478600001)(66446008)(53546011)(4326008)(54906003)(81166006)(81156014)(52116002)(316002)(8676002)(7416002)(86362001)(110136005)(5660300002)(6486002)(186003)(2906002)(8936002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4643;H:AM0PR05MB5875.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0+HfADlcB4VueUFTxKgomjF6/R+v+vUezQ6o1Qk8CqVAchPJnS6GquRigTQJRlM9W532JsJAtzHP56oxA6CqvjfcRh1f35Ss1dhD9y8DckIupDo6ABvrfDTrqOQqZO69LmrspsZwir7Upy2Mc5/yh68FYK1K/Q3LSdX6RjBT3Gx1BH3BIGZ4LptvSgme+rIM8559PGnGx7AKL4os9NN3ML03zJG0au4HDbYptFTkx8mjT0jU54Cil/IoxW7Mq7sBWTkbHV0ZFOxJfz/UjK2XZr1Xrmue52U0WmOLxEi7VT+NyvLuv8IbzN2nu6MuH9erhiZQrkwFXQUQkT/dhUofsVx+/Duzx4BpsKpEm80YjEBtzGx5ex2HZyNfaB0BcHyr/hkE5UVgv6a+DcHQ+E8hBLdPgOoKXqHSR1p2zvVBKn2Mjl5/Zs///T7lh8UroOqY+iQ0gap/6N7snV89m5eTW69D8Ay0KJqU6FXcgwm1fB6ud9LNE8P6Mbx8R563tTQa
Content-Type: text/plain; charset="utf-8"
Content-ID: <A7D9DB65C2074E4F8B5A8104B51BDF02@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dad1aea8-4f83-4ee0-79e5-08d77d7cfb8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2019 14:26:44.7574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hpuz0rWQcdMclIjYsEVVCIwoBYC/oSmy68BBUsj4rD7uetCSM8yGm4l7UBXoyGMfVvmvAYiuEcX8dzApP8AAxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4643
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0xMi0wNiAxMTowMywgQmrDtnJuIFTDtnBlbCB3cm90ZToNCj4gT24gVGh1LCA1IERl
YyAyMDE5IGF0IDE2OjUyLCBNYXhpbSBNaWtpdHlhbnNraXkgPG1heGltbWlAbWVsbGFub3guY29t
PiB3cm90ZToNCj4+DQo+PiBVc2Ugc3luY2hyb25pemVfcmN1IHRvIHdhaXQgdW50aWwgdGhlIFhT
SyB3YWtldXAgZnVuY3Rpb24gZmluaXNoZXMNCj4+IGJlZm9yZSBkZXN0cm95aW5nIHRoZSByZXNv
dXJjZXMgaXQgdXNlczoNCj4+DQo+PiAxLiBpNDBlX2Rvd24gYWxyZWFkeSBjYWxscyBzeW5jaHJv
bml6ZV9yY3UuIE9uIGk0MGVfZG93biBlaXRoZXINCj4+IF9fSTQwRV9WU0lfRE9XTiBvciBfX0k0
MEVfQ09ORklHX0JVU1kgaXMgc2V0LiBDaGVjayB0aGUgbGF0dGVyIGluDQo+PiBpNDBlX3hza19h
c3luY194bWl0ICh0aGUgZm9ybWVyIGlzIGFscmVhZHkgY2hlY2tlZCB0aGVyZSkuDQo+Pg0KPj4g
Mi4gQWZ0ZXIgc3dpdGNoaW5nIHRoZSBYRFAgcHJvZ3JhbSwgY2FsbCBzeW5jaHJvbml6ZV9yY3Ug
dG8gbGV0DQo+PiBpNDBlX3hza19hc3luY194bWl0IGV4aXQgYmVmb3JlIHRoZSBYRFAgcHJvZ3Jh
bSBpcyBmcmVlZC4NCj4+DQo+PiAzLiBDaGFuZ2luZyB0aGUgbnVtYmVyIG9mIGNoYW5uZWxzIGJy
aW5ncyB0aGUgaW50ZXJmYWNlIGRvd24gKHNlZQ0KPj4gaTQwZV9wcmVwX2Zvcl9yZXNldCBhbmQg
aTQwZV9wZl9xdWllc2NlX2FsbF92c2kpLg0KPj4NCj4+IDQuIERpc2FibGluZyBVTUVNIHNldHMg
X19JNDBFX0NPTkZJR19CVVNZLCB0b28uDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogTWF4aW0gTWlr
aXR5YW5za2l5IDxtYXhpbW1pQG1lbGxhbm94LmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jIHwgNyArKysrKy0tDQo+PiAgIGRyaXZl
cnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYyAgfCA0ICsrKysNCj4+ICAgMiBm
aWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfbWFpbi5jDQo+PiBpbmRleCAxY2Nh
YmVhZmE0NGMuLmFmYTNhOTllNjhlMSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2k0MGUvaTQwZV9tYWluLmMNCj4+IEBAIC02ODIzLDggKzY4MjMsOCBAQCB2b2lkIGk0
MGVfZG93bihzdHJ1Y3QgaTQwZV92c2kgKnZzaSkNCj4+ICAgICAgICAgIGZvciAoaSA9IDA7IGkg
PCB2c2ktPm51bV9xdWV1ZV9wYWlyczsgaSsrKSB7DQo+PiAgICAgICAgICAgICAgICAgIGk0MGVf
Y2xlYW5fdHhfcmluZyh2c2ktPnR4X3JpbmdzW2ldKTsNCj4+ICAgICAgICAgICAgICAgICAgaWYg
KGk0MGVfZW5hYmxlZF94ZHBfdnNpKHZzaSkpIHsNCj4+IC0gICAgICAgICAgICAgICAgICAgICAg
IC8qIE1ha2Ugc3VyZSB0aGF0IGluLXByb2dyZXNzIG5kb194ZHBfeG1pdA0KPj4gLSAgICAgICAg
ICAgICAgICAgICAgICAgICogY2FsbHMgYXJlIGNvbXBsZXRlZC4NCj4+ICsgICAgICAgICAgICAg
ICAgICAgICAgIC8qIE1ha2Ugc3VyZSB0aGF0IGluLXByb2dyZXNzIG5kb194ZHBfeG1pdCBhbmQN
Cj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAqIG5kb194c2tfYXN5bmNfeG1pdCBjYWxscyBh
cmUgY29tcGxldGVkLg0KDQpPb29wcywgSSBzZWUgbm93IHNvbWUgY2hhbmdlcyB3ZXJlIGxvc3Qg
ZHVyaW5nIHJlYmFzaW5nLiBJIGhhZCBhIHZlcnNpb24gDQpvZiB0aGlzIHNlcmllcyB3aXRoIG5k
b194c2tfYXN5bmNfeG1pdCAtPiBuZG9feHNrX3dha2V1cCBmaXhlZC4NCg0KPj4gICAgICAgICAg
ICAgICAgICAgICAgICAgICAqLw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgIHN5bmNocm9u
aXplX3JjdSgpOw0KPj4gICAgICAgICAgICAgICAgICAgICAgICAgIGk0MGVfY2xlYW5fdHhfcmlu
Zyh2c2ktPnhkcF9yaW5nc1tpXSk7DQo+PiBAQCAtMTI1NDUsNiArMTI1NDUsOSBAQCBzdGF0aWMg
aW50IGk0MGVfeGRwX3NldHVwKHN0cnVjdCBpNDBlX3ZzaSAqdnNpLA0KPj4gICAgICAgICAgICAg
ICAgICBpNDBlX3ByZXBfZm9yX3Jlc2V0KHBmLCB0cnVlKTsNCj4+DQo+PiAgICAgICAgICBvbGRf
cHJvZyA9IHhjaGcoJnZzaS0+eGRwX3Byb2csIHByb2cpOw0KPj4gKyAgICAgICBpZiAob2xkX3By
b2cpDQo+PiArICAgICAgICAgICAgICAgLyogV2FpdCB1bnRpbCBuZG9feHNrX2FzeW5jX3htaXQg
Y29tcGxldGVzLiAqLw0KPj4gKyAgICAgICAgICAgICAgIHN5bmNocm9uaXplX3JjdSgpOw0KPiAN
Cj4gVGhpcyBpcyBub3QgbmVlZGVkIC0tIHBsZWFzZSBjb3JyZWN0IG1lIGlmIEknbSBtaXNzaW5n
IHNvbWV0aGluZyEgSWYNCj4gd2UncmUgZGlzYWJsaW5nIFhEUCwgdGhlIG5lZWRfcmVzZXQtY2xh
dXNlIHdpbGwgdGFrZSBjYXJlIG9yIHRoZQ0KPiBwcm9wZXIgc3luY2hyb25pemF0aW9uLg0KDQpZ
ZXMsIGl0IHdhcyBhZGRlZCB0byBjb3ZlciB0aGUgY2FzZSBvZiBkaXNhYmxpbmcgWERQLiBJJ20g
bm90IHN1cmUgaG93IA0KaTQwZV9yZXNldF9hbmRfcmVidWlsZCB3aWxsIGhlbHAgaGVyZS4gV2hh
dCBJIHdhbnRlZCB0byBhY2hpZXZlIGlzIHRvIA0Kd2FpdCB1bnRpbCBhbGwgaTQwZV94c2tfd2Fr
ZXVwcyBmaW5pc2ggYWZ0ZXIgc2V0dGluZyB2c2ktPnhkcF9wcm9nID0gDQpOVUxMIGFuZCBiZWZv
cmUgZG9pbmcgYW55dGhpbmcgZWxzZS4gSSBkb24ndCBzZWUgaG93IA0KaTQwZV9yZXNldF9hbmRf
cmVidWlsZCBoZWxwcyBoZXJlLCBidXQgSSdtIG5vdCB2ZXJ5IGZhbWlsaWFyIHdpdGggaTQwZSAN
CmNvZGUuIENvdWxkIHlvdSBndWlkZSBtZSB0aHJvdWdoIHRoZSBjb2RlIG9mIGk0MGVfcmVzZXRf
YW5kX3JlYnVpbGQgYW5kIA0Kc2hvdyBob3cgaXQgdGFrZXMgY2FyZSBvZiB0aGUgc3luY2hyb25p
emF0aW9uPw0KDQo+IEFuZCB3ZSBkb24ndCBuZWVkIHRvIHdvcnJ5IGFib3V0IG9sZF9wcm9nIGZv
cg0KPiB0aGUgc3dhcC1YRFAgY2FzZSwNCg0KUmlnaHQuDQoNCj4gYmVjYXVzZSBicGZfcHJvZ19w
dXQoKSBkb2VzIGNsZWFudXAgd2l0aA0KPiBjYWxsX3JjdSgpLg0KDQpCdXQgaWYgaTQwZV94c2tf
d2FrZXVwIGlzIG5vdCB3cmFwcGVkIHdpdGggcmN1X3JlYWRfbG9jaywgaXQgd29uJ3Qgc3luYyAN
CndpdGggaXQuDQoNCj4gDQo+Pg0KPj4gICAgICAgICAgaWYgKG5lZWRfcmVzZXQpDQo+PiAgICAg
ICAgICAgICAgICAgIGk0MGVfcmVzZXRfYW5kX3JlYnVpbGQocGYsIHRydWUsIHRydWUpOw0KPj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV94c2suYw0KPj4gaW5kZXggZDA3
ZTFhODkwNDI4Li5mNzNjZDkxN2M0NGYgMTAwNjQ0DQo+PiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNrLmMNCj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2k0MGUvaTQwZV94c2suYw0KPj4gQEAgLTc4Nyw4ICs3ODcsMTIgQEAgaW50IGk0MGVf
eHNrX3dha2V1cChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCB1MzIgcXVldWVfaWQsIHUzMiBmbGFn
cykNCj4+ICAgew0KPj4gICAgICAgICAgc3RydWN0IGk0MGVfbmV0ZGV2X3ByaXYgKm5wID0gbmV0
ZGV2X3ByaXYoZGV2KTsNCj4+ICAgICAgICAgIHN0cnVjdCBpNDBlX3ZzaSAqdnNpID0gbnAtPnZz
aTsNCj4+ICsgICAgICAgc3RydWN0IGk0MGVfcGYgKnBmID0gdnNpLT5iYWNrOw0KPj4gICAgICAg
ICAgc3RydWN0IGk0MGVfcmluZyAqcmluZzsNCj4+DQo+PiArICAgICAgIGlmICh0ZXN0X2JpdChf
X0k0MEVfQ09ORklHX0JVU1ksIHBmLT5zdGF0ZSkpDQo+PiArICAgICAgICAgICAgICAgcmV0dXJu
IC1FTkVURE9XTjsNCj4+ICsNCj4gDQo+IFlvdSByaWdodCB0aGF0IHdlIG5lZWQgdG8gY2hlY2sg
Zm9yIEJVU1ksIHNpbmNlIHRoZSBYRFAgcmluZyBtaWdodCBiZQ0KPiBzdGFsZSEgVGhhbmtzIGZv
ciBjYXRjaGluZyB0aGlzISBDYW4geW91IHJlc3BpbiB0aGlzIHBhdGNoLCB3aXRoIGp1c3QNCj4g
dGhpcyBodW5rPyAoVW5sZXNzIEknbSB3cm9uZyEgOi0pKQ0KDQpUaGlzIGNoZWNrIGl0c2VsZiB3
aWxsIG5vdCBiZSBlbm91Z2gsIHVubGVzcyB5b3Ugd3JhcCBpNDBlX3hza193YWtldXAgDQp3aXRo
IHJjdV9yZWFkX2xvY2suDQoNCmk0MGVfeHNrX3dha2V1cCBkb2VzIHNvbWUgY2hlY2tzIGluIHRo
ZSBiZWdpbm5pbmcsIHRoZW4gdGhlIG1haW4gcGFydCBvZiANCnRoZSBjb2RlIGdvZXMuIE15IGFz
c3VtcHRpb24gaXMgdGhhdCBpZiB0aGUgY2hlY2tzIGRvbid0IHBhc3MsIHRoZSBtYWluIA0KcGFy
dCB3aWxsIGZhaWwgaW4gc29tZSB3YXkgKGUuZy4sIE5VTEwgb3IgZGFuZ2xpbmcgcG9pbnRlciB3
aGVuIA0KYWNjZXNzaW5nIHRoZSByaW5nKSwgb3RoZXJ3aXNlIHlvdSB3b3VsZG4ndCBuZWVkIHRo
b3NlIGNoZWNrcyBhdCBhbGwuIA0KV2l0aG91dCBSQ1UsIGV2ZW4gaWYgeW91IGRvIHRoZXNlIGNo
ZWNrcywgaXQgbWF5IHN0aWxsIGZhaWwgaW4gdGhlIA0KZm9sbG93aW5nIHNjZW5hcmlvOg0KDQox
LiBpNDBlX3hza193YWtldXAgc3RhcnRzIHJ1bm5pbmcsIGNoZWNrcyB0aGUgZmxhZywgdGhlIGZs
YWcgaXMgc2V0LCB0aGUgDQpmdW5jdGlvbiBnb2VzIG9uLg0KDQoyLiBUaGUgZmxhZyBnZXRzIGNs
ZWFyZWQuDQoNCjMuIFRoZSByZXNvdXJjZXMgYXJlIGRlc3Ryb3llZC4NCg0KNC4gaTQwZV94c2tf
d2FrZXVwIHRyaWVzIHRvIGFjY2VzcyB0aGUgcmVzb3VyY2VzIHRoYXQgd2VyZSBkZXN0cm95ZWQu
DQoNCkkgZG9uJ3Qgc2VlIGFueXRoaW5nIGluIGk0MGUgYW5kIGl4Z2JlIHRoYXQgY3VycmVudGx5
IHByb3RlY3RzIGZyb20gc3VjaCANCmEgcmFjZSBjb25kaXRpb24uIElmIEknbSBtaXNzaW5nIGFu
eXRoaW5nLCBwbGVhc2UgcG9pbnQgbWUgdG8gaXQsIA0Kb3RoZXJ3aXNlIGk0MGVfeHNrX3dha2V1
cCByZWFsbHkgbmVlZHMgdG8gYmUgd3JhcHBlZCBpbnRvIHJjdV9yZWFkX2xvY2suIA0KSSB3b3Vs
ZCBwcmVmZXIgdG8gaGF2ZSByY3VfcmVhZF9sb2NrIGluIHRoZSBrZXJuZWwsIHNvIHRoYXQgYWxs
IGRyaXZlcnMgDQpjb3VsZCBiZW5lZml0IGZyb20gaXQsIGJlY2F1c2UgSSB0aGluayBpdCdzIHRo
ZSBzYW1lIGlzc3VlIGluIGFsbCANCmRyaXZlcnMsIGJ1dCBJJ20gZmluZSB3aXRoIG1vdmluZyBp
dCB0byB0aGUgZHJpdmVycyBpZiB0aGVyZSBpcyBhIHJlYXNvbiANCndoeSBzb21lIGRyaXZlcnMg
bWF5IG5vdCBuZWVkIGl0Lg0KDQpUaGFua3MgZm9yIHRha2luZyBhIGxvb2suIExldCdzIHNldHRs
ZSB0aGUgY2FzZSB3aXRoIEludGVsJ3MgZHJpdmVycywgc28gDQp0aGF0IEkgd2lsbCBrbm93IHdo
YXQgZml4ZXMgdG8gaW5jbHVkZSBpbnRvIHRoZSByZXNwaW4uDQoNCj4gDQo+IA0KPj4gICAgICAg
ICAgaWYgKHRlc3RfYml0KF9fSTQwRV9WU0lfRE9XTiwgdnNpLT5zdGF0ZSkpDQo+PiAgICAgICAg
ICAgICAgICAgIHJldHVybiAtRU5FVERPV047DQo+Pg0KPj4gLS0NCj4+IDIuMjAuMQ0KPj4NCg0K
