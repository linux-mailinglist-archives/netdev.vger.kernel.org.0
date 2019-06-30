Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC175AF77
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 10:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfF3Inr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 04:43:47 -0400
Received: from mail-eopbgr10049.outbound.protection.outlook.com ([40.107.1.49]:26141
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726513AbfF3Inq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 04:43:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPPeIpv6LSfEkQdZ1kKhg84ZLOpIx6mhndzTviT0d2c=;
 b=kbv3vJZckHRiHSyfDvnqXgriMyDxBhCirW3u7vzIlcYwDLHdhvWZQuVzDx4kgvrDLyYKs3Z7Zq3auU1LQLhn5ckc9/ZaoHLiwp2YRVdBxKgdW+ps71p0mtcvHu97mBKuBPNxfMAOez0lyFvcjhxbScl2VPRTE4i1YWK1JdvAPuI=
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com (10.171.190.30) by
 AM4PR05MB3171.eurprd05.prod.outlook.com (10.171.189.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Sun, 30 Jun 2019 08:43:00 +0000
Received: from AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7]) by AM4PR05MB3411.eurprd05.prod.outlook.com
 ([fe80::9434:99ea:e230:aba7%4]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 08:43:00 +0000
From:   Paul Blakey <paulb@mellanox.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v2 0/4] net/sched: Introduce tc connection
 tracking
Thread-Topic: [PATCH net-next v2 0/4] net/sched: Introduce tc connection
 tracking
Thread-Index: AQHVJ25Gi09ptRMhWE69xU3ZbUgBvaarHjqAgAjSiQA=
Date:   Sun, 30 Jun 2019 08:43:00 +0000
Message-ID: <175dd850-49c8-f4a9-bd9e-61b8b7482ed4@mellanox.com>
References: <1561038141-31370-1-git-send-email-paulb@mellanox.com>
 <CAM_iQpU+EojoF-qOZ3gVB28+Hp-HE=tHTcC7uUh3b3XwMwWJ=w@mail.gmail.com>
In-Reply-To: <CAM_iQpU+EojoF-qOZ3gVB28+Hp-HE=tHTcC7uUh3b3XwMwWJ=w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR06CA0033.eurprd06.prod.outlook.com
 (2603:10a6:20b:14::46) To AM4PR05MB3411.eurprd05.prod.outlook.com
 (2603:10a6:205:b::30)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 852e2cac-68d1-4181-81bd-08d6fd36f4f4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR05MB3171;
x-ms-traffictypediagnostic: AM4PR05MB3171:
x-microsoft-antispam-prvs: <AM4PR05MB317196B3A1ED156480A42A85CFFE0@AM4PR05MB3171.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(189003)(199004)(316002)(5660300002)(66946007)(66446008)(73956011)(81166006)(6116002)(66476007)(54906003)(6246003)(71200400001)(8936002)(3846002)(8676002)(66556008)(64756008)(305945005)(7736002)(81156014)(25786009)(66574012)(7416002)(4326008)(86362001)(446003)(71190400001)(36756003)(31696002)(256004)(5024004)(2906002)(476003)(486006)(2616005)(11346002)(99286004)(14454004)(66066001)(6916009)(76176011)(6436002)(102836004)(186003)(53936002)(52116002)(229853002)(386003)(6486002)(53546011)(6506007)(26005)(478600001)(68736007)(31686004)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3171;H:AM4PR05MB3411.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: YnY1IL5GsvvQ/NIaTvf/sBq3nOz9o43jjjgOUux3sUVmkFfw+zr/yozO1iWvGgpAFpEJCl2TVMFCvffPYdvcNyuSU+HRoP6+Mp8ly5OGwxNU20blxvhlg86W7amPxVto3evyGWqAxm8PnnZQadaB5auXn/7puHzdJgDSfchDFRBUzTa5G52FEDhQSQD1nM+qypCBUYLA6yw0+Wz2PTS80cui7QlxHswiwI80k9iBNxAubBJ/VXx5Uq+V91j/TN1IodNvAkC8UG0fxLcmFTZwMRbrAN3Ffbp1I5XX3BRqWnCfHSYumy+NMe8qkTcq7zOcgpiJlj1LMAk/gRFrralYjNH+0nlcdSKzibBG2PBq4Hv/hd7EXP0qZ1lwa2caQ6hNsyBRX0GiShK96bYb0uyr/4ry/PS3KmYNZAAFk7maoOo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72D275B1327F54438036AB7FAD0F5DFE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852e2cac-68d1-4181-81bd-08d6fd36f4f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 08:43:00.2088
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: paulb@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3171
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNC8yMDE5IDg6NTkgUE0sIENvbmcgV2FuZyB3cm90ZToNCg0KPiBPbiBUaHUsIEp1biAy
MCwgMjAxOSBhdCA2OjQzIEFNIFBhdWwgQmxha2V5IDxwYXVsYkBtZWxsYW5veC5jb20+IHdyb3Rl
Og0KPj4gSGksDQo+Pg0KPj4gVGhpcyBwYXRjaCBzZXJpZXMgYWRkIGNvbm5lY3Rpb24gdHJhY2tp
bmcgY2FwYWJpbGl0aWVzIGluIHRjIHN3IGRhdGFwYXRoLg0KPj4gSXQgZG9lcyBzbyB2aWEgYSBu
ZXcgdGMgYWN0aW9uLCBjYWxsZWQgYWN0X2N0LCBhbmQgbmV3IHRjIGZsb3dlciBjbGFzc2lmaWVy
IG1hdGNoaW5nDQo+PiBvbiBjb25udHJhY2sgc3RhdGUsIG1hcmsgYW5kIGxhYmVsLg0KPiBUaGFu
a3MgZm9yIG1vcmUgZGV0YWlsZWQgZGVzY3JpcHRpb24gaGVyZS4NCj4NCj4gSSBzdGlsbCBkb24n
dCBzZWUgd2h5IHdlIGhhdmUgdG8gZG8gdGhpcyBpbiBMMiwgbWluZCB0byBiZSBtb3JlIHNwZWNp
ZmljPw0KDQp0YyBpcyBhbiBjb21wbGV0ZSBkYXRhcGF0aCwgYW5kIGRvZXMgaXQncyByb3V0aW5n
L21hbmlwdWxhdGlvbiBiZWZvcmUgDQp0aGUga2VybmVsIHN0YWNrIChoZXJlIHRoZSBob29rcw0K
DQphcmUgb24gZGV2aWNlIGluZ3Jlc3MgcWRpc2MpLCBmb3IgZXhhbXBsZSwgdGFrZSB0aGlzIHNp
bXBsZSBuYW1lc3BhY2Ugc2V0dXANCg0KI3NldHVwIDIgcmVwcw0Kc3VkbyBpcCBuZXRucyBhZGQg
bnMwDQpzdWRvIGlwIG5ldG5zIGFkZCBuczENCnN1ZG8gaXAgbGluayBhZGQgdm0gdHlwZSB2ZXRo
IHBlZXIgbmFtZSB2bV9yZXANCnN1ZG8gaXAgbGluayBhZGQgdm0yIHR5cGUgdmV0aCBwZWVyIG5h
bWUgdm0yX3JlcA0Kc3VkbyBpcCBsaW5rIHNldCB2bSBuZXRucyBuczANCnN1ZG8gaXAgbGluayBz
ZXQgdm0yIG5ldG5zIG5zMQ0Kc3VkbyBpcCBuZXRucyBleGVjIG5zMCBpZmNvbmZpZyB2bSAzLjMu
My4zLzI0IHVwDQpzdWRvIGlwIG5ldG5zIGV4ZWMgbnMxIGlmY29uZmlnIHZtMiAzLjMuMy40LzI0
IHVwDQpzdWRvIGlmY29uZmlnIHZtX3JlcCB1cA0Kc3VkbyBpZmNvbmZpZyB2bTJfcmVwIHVwDQpz
dWRvIHRjIHFkaXNjIGFkZCBkZXYgdm1fcmVwIGluZ3Jlc3MNCnN1ZG8gdGMgcWRpc2MgYWRkIGRl
diB2bTJfcmVwIGluZ3Jlc3MNCg0KI291dGJvdW5kDQpzdWRvIHRjIGZpbHRlciBhZGQgZGV2IHZt
X3JlcCBpbmdyZXNzIHByb3RvIGlwIGNoYWluIDAgcHJpbyAxIGZsb3dlciANCmN0X3N0YXRlIC10
cmvCoMKgwqDCoCBhY3Rpb24gbWlycmVkIGVncmVzcyByZWRpcmVjdCBkZXYgdm0yX3JlcA0Kc3Vk
byB0YyBmaWx0ZXIgYWRkIGRldiB2bV9yZXAgaW5ncmVzcyBwcm90byBpcCBjaGFpbiAxIHByaW8g
MSBmbG93ZXIgDQpjdF9zdGF0ZSArdHJrK25ldyBhY3Rpb24gY3QgY29tbWl0IHBpcGUgYWN0aW9u
IG1pcnJlZCBlZ3Jlc3MgcmVkaXJlY3QgDQpkZXYgdm0yX3JlcA0Kc3VkbyB0YyBmaWx0ZXIgYWRk
IGRldiB2bV9yZXAgaW5ncmVzcyBwcm90byBpcCBjaGFpbiAxIHByaW8gMSBmbG93ZXIgDQpjdF9z
dGF0ZSArdHJrK2VzdCBhY3Rpb24gbWlycmVkIGVncmVzcyByZWRpcmVjdCBkZXYgdm0yX3JlcA0K
DQojaW5ib3VuZA0Kc3VkbyB0YyBmaWx0ZXIgYWRkIGRldiB2bTJfcmVwIGluZ3Jlc3MgcHJvdG8g
aXAgY2hhaW4gMCBwcmlvIDEgZmxvd2VyIA0KY3Rfc3RhdGUgLXRya8KgwqDCoMKgIGFjdGlvbiBt
aXJyZWQgZWdyZXNzIHJlZGlyZWN0IGRldiB2bV9yZXANCnN1ZG8gdGMgZmlsdGVyIGFkZCBkZXYg
dm0yX3JlcCBpbmdyZXNzIHByb3RvIGlwIGNoYWluIDEgcHJpbyAxIGZsb3dlciANCmN0X3N0YXRl
ICt0cmsrZXN0IGFjdGlvbiBtaXJyZWQgZWdyZXNzIHJlZGlyZWN0IGRldiB2bV9yZXANCg0KI2hh
bmRsZSBhcnBzDQpzdWRvIHRjIGZpbHRlciBhZGQgZGV2IHZtMl9yZXAgaW5ncmVzcyBwcm90byBh
cnAgY2hhaW4gMCBwcmlvIDIgZmxvd2VyIA0KYWN0aW9uIG1pcnJlZCBlZ3Jlc3MgcmVkaXJlY3Qg
ZGV2IHZtX3JlcA0Kc3VkbyB0YyBmaWx0ZXIgYWRkIGRldiB2bV9yZXAgaW5ncmVzcyBwcm90byBh
cnAgY2hhaW4gMCBwcmlvIDIgZmxvd2VyIA0KYWN0aW9uIG1pcnJlZCBlZ3Jlc3MgcmVkaXJlY3Qg
ZGV2IHZtMl9yZXANCg0KI3J1biB0cmFmZmljDQpzdWRvIHRpbWVvdXQgMjAgaXAgbmV0bnMgZXhl
YyBuczEgaXBlcmYgLXMmDQpzdWRvIGlwIG5ldG5zIGV4ZWMgbnMwIGlwZXJmIC1jIDMuMy4zLjQg
LXQgMTANCg0KDQpUaGUgdHJhZmZpYyBpcyBoYW5kbGVkIGluIHRjIGRhdGFwYXRoIGxheWVyIGFu
ZCB0aGUgdXNlciBoZXJlIGRlY2lkZWQgDQpob3cgdG8gcm91dGUgdGhlIHBhY2tldHMuDQoNCklu
IGEgcmVhbCB3b3JsZCBleG1hcGxlLMKgIHdlIGFyZSBnb2luZyB0byB1c2UgaXQgd2l0aCBTUklP
ViB3aGVyZSB0aGUgdGMgDQpydWxlcyBhcmUgb24gcmVwcmVzZW50b3JzLCBhbmQgdGhlIHZtcyBh
Ym92ZSBhcmUNCg0KU1JJT1YgdmZzIGF0dGFjaGVkIHRvIFZNcy4gV2UgYWxzbyBkb24ndCB3YW50
IHRvIHNlbmQgYW55IHBhY2tldCB0byANCmNvbm50cmFjayBqdXN0IHRob3NlIHRoYXQgd2Ugd2Fu
dCwNCg0KYW5kIHdlIG1pZ2h0IGRvIG1hbmlwdWxhdGlvbiBvbiB0aGUgcGFja2V0IGJlZm9yZSBz
ZW5kaW5nIGl0IHRvIA0KY29ubnRyYWNrIHN1Y2ggYXMgd2l0aCB0YyBhY3Rpb24gcGVkaXQgLCBp
biBhIHJvdXRlcg0KDQpzZXR1cCAoY2hhbmdlIG1hY3MsIGlwcykuDQoNCj4NCj4gSU9XLCBpZiB5
b3UgcmVhbGx5IHdhbnQgdG8gbWFuaXB1bGF0ZSBjb25udHJhY2sgaW5mbyBhbmQgdXNlIGl0IGZv
cg0KPiBtYXRjaGluZywgd2h5IG5vdCBkbyBpdCBpbiBuZXRmaWx0ZXIgbGF5ZXIgYXMgaXQgaXMg
d2hlcmUgY29ubnRyYWNrIGlzPw0KPg0KPiBCVFcsIGlmIHRoZSBjbHNfZmxvd2VyIGN0X3N0YXRl
IG1hdGNoaW5nIGlzIG5vdCBpbiB1cHN0cmVhbSB5ZXQsIHBsZWFzZQ0KPiB0cnkgdG8gcHVzaCBp
dCBmaXJzdCwgYXMgaXQgaXMgYSBqdXN0aWZpY2F0aW9uIG9mIHRoaXMgcGF0Y2hzZXQuDQo+DQo+
IFRoYW5rcy4NCg0KSXQncyBwYXRjaCAzLzQgb2YgdGhpcyBwYXRjaCBzZXQsIEkgY2FuIG1vdmUg
aXQgdG8gYmUgZmlyc3QNCg0K
