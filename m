Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77DD438B7
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733187AbfFMPHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:07:48 -0400
Received: from mail-eopbgr130084.outbound.protection.outlook.com ([40.107.13.84]:17571
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732390AbfFMOBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 10:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxeuX7D1QAiTCC8RFAgTcVdwBN6G+b1c/lunrCn+vz0=;
 b=RzTTuEu50IBPyAecUezKHUDTQpMMoFDaKq0A/t2U5tVqA/fqW4dHfxOqxOWywSf4y9CkdfgpUt3aLH5mHz7CVm/F6CJBrfYuU1NWx1fEqY0suQtweoj4omnrPhVFMWahxKgRdq0srf32/0LLswOa63q19VNwM5nkRxHf/Gmh8hU=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5637.eurprd05.prod.outlook.com (20.178.86.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Thu, 13 Jun 2019 14:01:39 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Thu, 13 Jun 2019
 14:01:39 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
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
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Topic: [PATCH bpf-next v4 07/17] libbpf: Support drivers with
 non-combined channels
Thread-Index: AQHVITdxVC+hU8LhkUKnNDgy7zjLlaaYdxEAgAEneoA=
Date:   Thu, 13 Jun 2019 14:01:39 +0000
Message-ID: <0afd3ef2-d0e3-192b-095e-0f8ae8e6fb5d@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
 <20190612155605.22450-8-maximmi@mellanox.com>
 <20190612132352.7ee27bf3@cakuba.netronome.com>
In-Reply-To: <20190612132352.7ee27bf3@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR11CA0044.namprd11.prod.outlook.com
 (2603:10b6:a03:80::21) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [159.224.90.213]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4567792d-b3dc-4388-e864-08d6f007a7ae
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5637;
x-ms-traffictypediagnostic: AM6PR05MB5637:
x-microsoft-antispam-prvs: <AM6PR05MB5637F159FAB162855067B860D1EF0@AM6PR05MB5637.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(376002)(346002)(366004)(199004)(189003)(68736007)(11346002)(31686004)(446003)(8936002)(8676002)(81156014)(81166006)(486006)(305945005)(73956011)(66946007)(66446008)(66476007)(66556008)(64756008)(6246003)(229853002)(14454004)(7736002)(476003)(2616005)(6512007)(316002)(31696002)(99286004)(7416002)(6486002)(25786009)(54906003)(66066001)(53936002)(52116002)(6916009)(76176011)(5660300002)(4326008)(478600001)(6436002)(86362001)(53546011)(6506007)(386003)(26005)(55236004)(102836004)(71190400001)(71200400001)(256004)(14444005)(186003)(36756003)(2906002)(6116002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5637;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: g7fqX9efSejPiGnE6QO4goNSQYL88N/kQaD9KiLJKakgE3J0EmXfZA4ClorCsuPuTAx+Egjrs7XaTtH2Sq5m1jWd/XZe/GjoG9cG5e3InrOCEZknTc30gjxir8IvF7cUGtNggroweyFG3h3g0Mdag5amHisxm+QL5eriIIjM8HYy9c361f5+RZYXGgJG+fHiFy46TThnszQ1AWlXYWnC4HeNGNDoA37q0O6UUEZGYO4ShDdHnV7XLtPbC0FUqCRFOuUHCf3+WLwuLWriFzzFKuachzXONSp9xD5gdbNwgIsWlTOb1bi1UnFXtbfnzF/Dz1w63vXntV+vNdABOx/dO8RcKFzNibOwN2CWIT/pRwrN/l9SIXTttUJaD6NVXJZaXRP4BarQsXoiiGKD4Mvv0wJzfGeuGCtjuhEPGsp2iX4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A2847739FBBE6E4D8C648F8AA3D087F3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4567792d-b3dc-4388-e864-08d6f007a7ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 14:01:39.5454
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5637
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNi0xMiAyMzoyMywgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IE9uIFdlZCwgMTIg
SnVuIDIwMTkgMTU6NTY6NDggKzAwMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4+IEN1
cnJlbnRseSwgbGliYnBmIHVzZXMgdGhlIG51bWJlciBvZiBjb21iaW5lZCBjaGFubmVscyBhcyB0
aGUgbWF4aW11bQ0KPj4gcXVldWUgbnVtYmVyLiBIb3dldmVyLCB0aGUga2VybmVsIGhhcyBhIGRp
ZmZlcmVudCBsaW1pdGF0aW9uOg0KPj4NCj4+IC0geGRwX3JlZ191bWVtX2F0X3FpZCgpIGFsbG93
cyB1cCB0byBtYXgoUlggcXVldWVzLCBUWCBxdWV1ZXMpLg0KPj4NCj4+IC0gZXRodG9vbF9zZXRf
Y2hhbm5lbHMoKSBjaGVja3MgZm9yIFVNRU1zIGluIHF1ZXVlcyB1cCB0bw0KPj4gICAgY29tYmlu
ZWRfY291bnQgKyBtYXgocnhfY291bnQsIHR4X2NvdW50KS4NCj4+DQo+PiBsaWJicGYgc2hvdWxk
bid0IGxpbWl0IGFwcGxpY2F0aW9ucyB0byBhIGxvd2VyIG1heCBxdWV1ZSBudW1iZXIuIEFjY291
bnQNCj4+IGZvciBub24tY29tYmluZWQgUlggYW5kIFRYIGNoYW5uZWxzIHdoZW4gY2FsY3VsYXRp
bmcgdGhlIG1heCBxdWV1ZQ0KPj4gbnVtYmVyLiBVc2UgdGhlIHNhbWUgZm9ybXVsYSB0aGF0IGlz
IHVzZWQgaW4gZXRodG9vbC4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNr
aXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KPj4gUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8
dGFyaXF0QG1lbGxhbm94LmNvbT4NCj4+IEFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRt
QG1lbGxhbm94LmNvbT4NCj4gDQo+IEkgZG9uJ3QgdGhpbmsgdGhpcyBpcyBjb3JyZWN0LiAgbWF4
X3R4IHRlbGxzIHlvdSBob3cgbWFueSBUWCBjaGFubmVscw0KPiB0aGVyZSBjYW4gYmUsIHlvdSBj
YW4ndCBhZGQgdGhhdCB0byBjb21iaW5lZC4gIENvcnJlY3QgY2FsY3VsYXRpb25zIGlzOg0KPiAN
Cj4gbWF4X251bV9jaGFucyA9IG1heChtYXhfY29tYmluZWQsIG1heChtYXhfcngsIG1heF90eCkp
DQoNCkZpcnN0IG9mIGFsbCwgSSdtIGFsaWduaW5nIHdpdGggdGhlIGZvcm11bGEgaW4gdGhlIGtl
cm5lbCwgd2hpY2ggaXM6DQoNCiAgICAgY3Vyci5jb21iaW5lZF9jb3VudCArIG1heChjdXJyLnJ4
X2NvdW50LCBjdXJyLnR4X2NvdW50KTsNCg0KKHNlZSBuZXQvY29yZS9ldGh0b29sLmMsIGV0aHRv
b2xfc2V0X2NoYW5uZWxzKCkpLg0KDQpUaGUgZm9ybXVsYSBpbiBsaWJicGYgc2hvdWxkIG1hdGNo
IGl0Lg0KDQpTZWNvbmQsIHRoZSBleGlzdGluZyBkcml2ZXJzIGhhdmUgZWl0aGVyIGNvbWJpbmVk
IGNoYW5uZWxzIG9yIHNlcGFyYXRlIA0KcnggYW5kIHR4IGNoYW5uZWxzLiBTbywgZm9yIHRoZSBm
aXJzdCBraW5kIG9mIGRyaXZlcnMsIG1heF90eCBkb2Vzbid0IA0KdGVsbCBob3cgbWFueSBUWCBj
aGFubmVscyB0aGVyZSBjYW4gYmUsIGl0IGp1c3Qgc2F5cyAwLCBhbmQgbWF4X2NvbWJpbmVkIA0K
dGVsbHMgaG93IG1hbnkgVFggYW5kIFJYIGNoYW5uZWxzIGFyZSBzdXBwb3J0ZWQuIEFzIG1heF90
eCBkb2Vzbid0IA0KaW5jbHVkZSBtYXhfY29tYmluZWQgKGFuZCB2aWNlIHZlcnNhKSwgd2Ugc2hv
dWxkIGFkZCB0aGVtIHVwLg0KDQo+PiAgIHRvb2xzL2xpYi9icGYveHNrLmMgfCA2ICsrKy0tLQ0K
Pj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPj4N
Cj4+IGRpZmYgLS1naXQgYS90b29scy9saWIvYnBmL3hzay5jIGIvdG9vbHMvbGliL2JwZi94c2su
Yw0KPj4gaW5kZXggYmYxNWE4MGEzN2MyLi44NjEwNzg1N2UxZjAgMTAwNjQ0DQo+PiAtLS0gYS90
b29scy9saWIvYnBmL3hzay5jDQo+PiArKysgYi90b29scy9saWIvYnBmL3hzay5jDQo+PiBAQCAt
MzM0LDEzICszMzQsMTMgQEAgc3RhdGljIGludCB4c2tfZ2V0X21heF9xdWV1ZXMoc3RydWN0IHhz
a19zb2NrZXQgKnhzaykNCj4+ICAgCQlnb3RvIG91dDsNCj4+ICAgCX0NCj4+ICAgDQo+PiAtCWlm
IChjaGFubmVscy5tYXhfY29tYmluZWQgPT0gMCB8fCBlcnJubyA9PSBFT1BOT1RTVVBQKQ0KPj4g
KwlyZXQgPSBjaGFubmVscy5tYXhfY29tYmluZWQgKyBtYXgoY2hhbm5lbHMubWF4X3J4LCBjaGFu
bmVscy5tYXhfdHgpOw0KPj4gKw0KPj4gKwlpZiAocmV0ID09IDAgfHwgZXJybm8gPT0gRU9QTk9U
U1VQUCkNCj4+ICAgCQkvKiBJZiB0aGUgZGV2aWNlIHNheXMgaXQgaGFzIG5vIGNoYW5uZWxzLCB0
aGVuIGFsbCB0cmFmZmljDQo+PiAgIAkJICogaXMgc2VudCB0byBhIHNpbmdsZSBzdHJlYW0sIHNv
IG1heCBxdWV1ZXMgPSAxLg0KPj4gICAJCSAqLw0KPj4gICAJCXJldCA9IDE7DQo+PiAtCWVsc2UN
Cj4+IC0JCXJldCA9IGNoYW5uZWxzLm1heF9jb21iaW5lZDsNCj4+ICAgDQo+PiAgIG91dDoNCj4+
ICAgCWNsb3NlKGZkKTsNCj4gDQoNCg==
