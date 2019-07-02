Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 314845CEA2
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 13:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfGBLm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 07:42:57 -0400
Received: from mail-eopbgr20085.outbound.protection.outlook.com ([40.107.2.85]:47681
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725868AbfGBLm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 07:42:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N3JscJrlhK23FTALjJAWEPsMBvAsikFiFMcXrYGeKSc=;
 b=A4Ywz8jt8V+O6SYXsTWFzktxgzcv3qbi5Jw86vYUozQZHA4kHUapnDZshJwYRjuez/2wFxGz74R6duUW8hatg1WcD1uX7GSfBfjkZ/hMMaKrSw2DPOkH6klm4zymd98k24E0lw+PAeC5KrRHzda6DR+KJnsw/6PQ8JyjjbCWZL8=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5443.eurprd05.prod.outlook.com (20.177.118.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 11:42:52 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 11:42:52 +0000
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
Subject: Re: [PATCH bpf-next v2 1/6] xsk: replace ndo_xsk_async_xmit with
 ndo_xsk_wakeup
Thread-Topic: [PATCH bpf-next v2 1/6] xsk: replace ndo_xsk_async_xmit with
 ndo_xsk_wakeup
Thread-Index: AQHVMLepaHKAfTCLxEm8ejzCutA5DKa3NRqA
Date:   Tue, 2 Jul 2019 11:42:52 +0000
Message-ID: <a57b5b49-bd03-92af-cc5d-fe11d1d0e437@mellanox.com>
References: <1562059288-26773-1-git-send-email-magnus.karlsson@intel.com>
 <1562059288-26773-2-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1562059288-26773-2-git-send-email-magnus.karlsson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0012.eurprd04.prod.outlook.com
 (2603:10a6:3:d0::22) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.67.35.250]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b24073e3-5639-4b8e-ad65-08d6fee26a79
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5443;
x-ms-traffictypediagnostic: AM6PR05MB5443:
x-microsoft-antispam-prvs: <AM6PR05MB544378838872A2A05A765AEAD1F80@AM6PR05MB5443.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2201;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(396003)(136003)(39860400002)(199004)(189003)(486006)(446003)(53546011)(4744005)(102836004)(2616005)(6506007)(5660300002)(6116002)(11346002)(476003)(110136005)(71190400001)(26005)(2501003)(66946007)(66476007)(66556008)(66446008)(14454004)(3846002)(386003)(2906002)(64756008)(186003)(81156014)(256004)(52116002)(99286004)(73956011)(81166006)(76176011)(54906003)(71200400001)(7416002)(53936002)(66066001)(36756003)(6486002)(6246003)(4326008)(68736007)(31686004)(478600001)(6512007)(6436002)(305945005)(7736002)(229853002)(316002)(25786009)(8936002)(8676002)(86362001)(31696002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5443;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7Vsr7mwJGPKxdgVkrgXJbXYq2jyVMk2bFlbrdwCHxDqIw9Xeqid2/z9juB52GOKhSBAHgW6qnTPuq7GIxYyr6zstWlAeRomEX3TbqAX0JONbo5U86M5Pg/P/V3OeUr13qgJXmom3M9kMuWEHWqyOXh4xObydrS9MBuV/tSOn2nIpIKxDwePHZJaRqsCrv6AJjk55BirWKjbJe04osxFQAtzUYkIr+IJNY+P1i0AJPhHGYyi1Kv/pzuOpnliNDdfjYrI2kL+21TgUZr2vbXdMO9Lam9BKowwBU5lLu58E3YJRqvEbKzSqT6xOH5NFv86jF0RGJ7COuMdaAbj8xe4mCDMNOP7li/7kCxCLt2TvxXsnOMtPutBp/nsxaInR/iyQxUSAsCRlzUvBfu5ZLOX4D5RvxTBUz5mcUIdnNL+v2ys=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFCF971AF860124981B96D27F3AB962E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b24073e3-5639-4b8e-ad65-08d6fee26a79
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 11:42:52.6654
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5443
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAxOS0wNy0wMiAxMjoyMSwgTWFnbnVzIEthcmxzc29uIHdyb3RlOg0KPiBUaGlzIGNvbW1p
dCByZXBsYWNlcyBuZG9feHNrX2FzeW5jX3htaXQgd2l0aCBuZG9feHNrX3dha2V1cC4gVGhpcyBu
ZXcNCj4gbmRvIHByb3ZpZGVzIHRoZSBzYW1lIGZ1bmN0aW9uYWxpdHkgYXMgYmVmb3JlIGJ1dCB3
aXRoIHRoZSBhZGRpdGlvbiBvZg0KPiBhIG5ldyBmbGFncyBmaWVsZCB0aGF0IGlzIHVzZWQgdG8g
c3BlY2lmaXkgaWYgUngsIFR4IG9yIGJvdGggc2hvdWxkIGJlDQo+IHdva2VuIHVwLiBUaGUgcHJl
dmlvdXMgbmRvIG9ubHkgd29rZSB1cCBUeCwgYXMgaW1wbGllZCBieSB0aGUNCj4gbmFtZS4gVGhl
IGk0MGUgYW5kIGl4Z2JlIGRyaXZlcnMgKHdoaWNoIGFyZSBhbGwgdGhlIHN1cHBvcnRlZCBvbmVz
KQ0KPiBhcmUgdXBkYXRlZCB3aXRoIHRoaXMgbmV3IGludGVyZmFjZS4NCg0KVGhpcyBBUEkgY2hh
bmdlIHdpbGwgYnJlYWsgYnVpbGQgb2YgbWx4NSAtIFhTSyBzdXBwb3J0IGZvciBtbHg1IHdhcyBt
ZXJnZWQuDQoNCj4gVGhpcyBuZXcgbmRvIHdpbGwgYmUgdXNlZCBieSB0aGUgbmV3IG5lZWRfd2Fr
ZXVwIGZ1bmN0aW9uYWxpdHkgb2YgWERQDQo+IHNvY2tldHMgdGhhdCBuZWVkIHRvIGJlIGFibGUg
dG8gd2FrZSB1cCBib3RoIFJ4IGFuZCBUeCBkcml2ZXINCj4gcHJvY2Vzc2luZy4NCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IE1hZ251cyBLYXJsc3NvbiA8bWFnbnVzLmthcmxzc29uQGludGVsLmNvbT4N
Cg0K
