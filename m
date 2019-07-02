Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5D95D0F1
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 15:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfGBNrC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 09:47:02 -0400
Received: from mail-eopbgr70040.outbound.protection.outlook.com ([40.107.7.40]:63425
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726628AbfGBNrC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 09:47:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lgsYv+yX9sosOVaOrFSC6dyYyQYA+UkBCLw4P9YxESY=;
 b=NiV9kIbjK3YwXiDGF40QLT7nfATsdVTgxj+sdrFdNMBZDlUwurEC0UfNbTyesPxRVlpC/18/e2THAir4BwFXnm76fhjNhPaoq5ztfOgvih/6h4BwpiNPcDoPq75otjVKf+J2YHRPcAlhn+jMhv4cLIqfc3wwAKgko63Cf9b/aUY=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB6261.eurprd05.prod.outlook.com (20.177.32.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 13:46:18 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 13:46:18 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Magnus Karlsson <magnus.karlsson@intel.com>,
        "ast@kernel.org" <ast@kernel.org>
CC:     "bjorn.topel@intel.com" <bjorn.topel@intel.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "bruce.richardson@intel.com" <bruce.richardson@intel.com>,
        "ciara.loftus@intel.com" <ciara.loftus@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "xiaolong.ye@intel.com" <xiaolong.ye@intel.com>,
        "qi.z.zhang@intel.com" <qi.z.zhang@intel.com>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "kevin.laatz@intel.com" <kevin.laatz@intel.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "maciejromanfijalkowski@gmail.com" <maciejromanfijalkowski@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH bpf-next v2 2/6] xsk: add support for need_wakeup flag in
 AF_XDP rings
Thread-Topic: [PATCH bpf-next v2 2/6] xsk: add support for need_wakeup flag in
 AF_XDP rings
Thread-Index: AQHVMLevUssjBLrxPEO5SaX/SuuNRaa3V5eA
Date:   Tue, 2 Jul 2019 13:46:18 +0000
Message-ID: <d4318783-18a4-d5c1-1044-691aaebb2b0a@mellanox.com>
References: <1562059288-26773-1-git-send-email-magnus.karlsson@intel.com>
 <1562059288-26773-3-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1562059288-26773-3-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR05CA0254.eurprd05.prod.outlook.com
 (2603:10a6:3:fb::30) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ff01408f-97f5-49c2-a32c-08d6fef3a8c3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6261;
x-ms-traffictypediagnostic: AM6PR05MB6261:
x-microsoft-antispam-prvs: <AM6PR05MB6261F74A050F59B77E62E851D1F80@AM6PR05MB6261.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(199004)(189003)(486006)(2906002)(2616005)(476003)(71200400001)(31696002)(3846002)(6116002)(31686004)(36756003)(11346002)(446003)(110136005)(54906003)(316002)(478600001)(256004)(71190400001)(86362001)(8676002)(81156014)(53936002)(5660300002)(6246003)(52116002)(6506007)(386003)(14454004)(102836004)(26005)(76176011)(6512007)(7736002)(25786009)(305945005)(4326008)(2501003)(81166006)(8936002)(66066001)(66946007)(66446008)(64756008)(66556008)(66476007)(68736007)(6486002)(6436002)(186003)(73956011)(229853002)(53546011)(99286004)(7416002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6261;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2BHbxKeVenFgcaJMF1B2RvcuP0yIYaz1uC+lPj4mFbCOh5iSP6G2LyNRC2K+UId+qYGQ4N87gx00CihH1pWrmjRaj2JqmSReWSn++azy/QT2xb/nnHRAQ9F9BerPimO9SCcuIuY4nZQY/+w1+F1chGSc8EoktP02DfyhB6V9C2ssBsFkyifv78raD77bvnkkxrrpurSgNFRssHHkqCD17VPWL5f7p4VfviW6x9TN0mf2hTKxBgdYX/OCsqzTmyLfBrRWFobQkvKCcr5PvyOZ8lCNFheHZNOGuWYqLUQuNXPLUFHbc8m69yUPUTWCq9K6jCBi4q8Jq0K8rev0/wx8FIaZW7eClT/0bAG3TWIxC8Z0RCFBWFwp5igaE6jAeFaLTFps4rHgaPJlaMGwOWCJ/o207L/am4eiKCyBYorbHac=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F60AE97F2E0EA24E81767672790595C7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff01408f-97f5-49c2-a32c-08d6fef3a8c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 13:46:18.6102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0wMiAxMjoyMSwgTWFnbnVzIEthcmxzc29uIHdyb3RlOg0KPiAgIA0KPiArLyog
WERQX1JJTkcgZmxhZ3MgKi8NCj4gKyNkZWZpbmUgWERQX1JJTkdfTkVFRF9XQUtFVVAgKDEgPDwg
MCkNCj4gKw0KPiAgIHN0cnVjdCB4ZHBfcmluZ19vZmZzZXQgew0KPiAgIAlfX3U2NCBwcm9kdWNl
cjsNCj4gICAJX191NjQgY29uc3VtZXI7DQo+ICAgCV9fdTY0IGRlc2M7DQo+ICsJX191NjQgZmxh
Z3M7DQo+ICAgfTsNCj4gICANCj4gICBzdHJ1Y3QgeGRwX21tYXBfb2Zmc2V0cyB7DQoNCjxzbmlw
Pg0KDQo+IEBAIC02MjEsOSArNjkyLDEyIEBAIHN0YXRpYyBpbnQgeHNrX2dldHNvY2tvcHQoc3Ry
dWN0IHNvY2tldCAqc29jaywgaW50IGxldmVsLCBpbnQgb3B0bmFtZSwNCj4gICAJY2FzZSBYRFBf
TU1BUF9PRkZTRVRTOg0KPiAgIAl7DQo+ICAgCQlzdHJ1Y3QgeGRwX21tYXBfb2Zmc2V0cyBvZmY7
DQo+ICsJCWJvb2wgZmxhZ3Nfc3VwcG9ydGVkID0gdHJ1ZTsNCj4gICANCj4gLQkJaWYgKGxlbiA8
IHNpemVvZihvZmYpKQ0KPiArCQlpZiAobGVuIDwgc2l6ZW9mKG9mZikgLSBzaXplb2Yob2ZmLnJ4
LmZsYWdzKSkNCj4gICAJCQlyZXR1cm4gLUVJTlZBTDsNCj4gKwkJZWxzZSBpZiAobGVuIDwgc2l6
ZW9mKG9mZikpDQo+ICsJCQlmbGFnc19zdXBwb3J0ZWQgPSBmYWxzZTsNCj4gICANCj4gICAJCW9m
Zi5yeC5wcm9kdWNlciA9IG9mZnNldG9mKHN0cnVjdCB4ZHBfcnh0eF9yaW5nLCBwdHJzLnByb2R1
Y2VyKTsNCj4gICAJCW9mZi5yeC5jb25zdW1lciA9IG9mZnNldG9mKHN0cnVjdCB4ZHBfcnh0eF9y
aW5nLCBwdHJzLmNvbnN1bWVyKTsNCj4gQEAgLTYzOCw2ICs3MTIsMTYgQEAgc3RhdGljIGludCB4
c2tfZ2V0c29ja29wdChzdHJ1Y3Qgc29ja2V0ICpzb2NrLCBpbnQgbGV2ZWwsIGludCBvcHRuYW1l
LA0KPiAgIAkJb2ZmLmNyLnByb2R1Y2VyID0gb2Zmc2V0b2Yoc3RydWN0IHhkcF91bWVtX3Jpbmcs
IHB0cnMucHJvZHVjZXIpOw0KPiAgIAkJb2ZmLmNyLmNvbnN1bWVyID0gb2Zmc2V0b2Yoc3RydWN0
IHhkcF91bWVtX3JpbmcsIHB0cnMuY29uc3VtZXIpOw0KPiAgIAkJb2ZmLmNyLmRlc2MJPSBvZmZz
ZXRvZihzdHJ1Y3QgeGRwX3VtZW1fcmluZywgZGVzYyk7DQo+ICsJCWlmIChmbGFnc19zdXBwb3J0
ZWQpIHsNCj4gKwkJCW9mZi5yeC5mbGFncyA9IG9mZnNldG9mKHN0cnVjdCB4ZHBfcnh0eF9yaW5n
LA0KPiArCQkJCQkJcHRycy5mbGFncyk7DQo+ICsJCQlvZmYudHguZmxhZ3MgPSBvZmZzZXRvZihz
dHJ1Y3QgeGRwX3J4dHhfcmluZywNCj4gKwkJCQkJCXB0cnMuZmxhZ3MpOw0KPiArCQkJb2ZmLmZy
LmZsYWdzID0gb2Zmc2V0b2Yoc3RydWN0IHhkcF91bWVtX3JpbmcsDQo+ICsJCQkJCQlwdHJzLmZs
YWdzKTsNCj4gKwkJCW9mZi5jci5mbGFncyA9IG9mZnNldG9mKHN0cnVjdCB4ZHBfdW1lbV9yaW5n
LA0KPiArCQkJCQkJcHRycy5mbGFncyk7DQo+ICsJCX0NCg0KQXMgZmFyIGFzIEkgdW5kZXJzdG9v
ZCAoY29ycmVjdCBtZSBpZiBJJ20gd3JvbmcpLCB5b3UgYXJlIHRyeWluZyB0byANCnByZXNlcnZl
IGJhY2t3YXJkIGNvbXBhdGliaWxpdHksIHNvIHRoYXQgaWYgdXNlcnNwYWNlIGRvZXNuJ3Qgc3Vw
cG9ydCANCnRoZSBmbGFncyBmaWVsZCwgeW91IHdpbGwgZGV0ZXJtaW5lIHRoYXQgYnkgbG9va2lu
ZyBhdCBsZW4gYW5kIGZhbGwgYmFjayANCnRvIHRoZSBvbGQgZm9ybWF0Lg0KDQpIb3dldmVyLCB0
d28gdGhpbmdzIGFyZSBicm9rZW4gaGVyZToNCg0KMS4gVGhlIGNoZWNrIGBsZW4gPCBzaXplb2Yo
b2ZmKSAtIHNpemVvZihvZmYucnguZmxhZ3MpYCBzaG91bGQgYmUgYGxlbiA8IA0Kc2l6ZW9mKG9m
ZikgLSA0ICogc2l6ZW9mKGZsYWdzKWAsIGJlY2F1c2Ugc3RydWN0IHhkcF9tbWFwX29mZnNldHMg
DQpjb25zaXN0cyBvZiA0IHN0cnVjdHMgeGRwX3Jpbmdfb2Zmc2V0Lg0KDQoyLiBUaGUgb2xkIGFu
ZCBuZXcgZm9ybWF0cyBhcmUgbm90IGJpbmFyeSBjb21wYXRpYmxlLCBhcyBmbGFncyBhcmUgDQpp
bnNlcnRlZCBpbiB0aGUgbWlkZGxlIG9mIHN0cnVjdCB4ZHBfbW1hcF9vZmZzZXRzLg0K
