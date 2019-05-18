Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC27E221AA
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 07:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbfERFJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 01:09:25 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:49314
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfERFJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 May 2019 01:09:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9XpXqIjFnoKok80DhvXvy+JFd4K8tX6u2kZnbNXi+k=;
 b=VL6WFtXXZktlRIJ2Pzd/ESV0RroT3SKuggrZti+WiiyrMBe5n1+SHhjYxOMs6aU6ATza37xWLfQMaa6p39yOtSlq+OO79nNQjCzTkX5YBkYBbbFCeBJ4Aw7ukYiJF2Mmdn54JgVB/zmwp7lp87IcNYo6T/8y5KRUA1qtsz/lBNM=
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com (52.134.125.139) by
 AM0PR05MB4211.eurprd05.prod.outlook.com (52.134.126.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Sat, 18 May 2019 05:09:20 +0000
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::9d94:3e29:d61d:f79f]) by AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::9d94:3e29:d61d:f79f%5]) with mapi id 15.20.1900.010; Sat, 18 May 2019
 05:09:20 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     wenxu <wenxu@ucloud.cn>, Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
Thread-Topic: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
Thread-Index: AQHVDJI54U3U/3hROkOwo7IesqXmtKZv4csAgABVbwCAAB7MAA==
Date:   Sat, 18 May 2019 05:09:19 +0000
Message-ID: <16f1a1c9-a02b-e17d-dd95-71c525f8c1be@mellanox.com>
References: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
 <1129938e-2dff-9aed-5a76-f438e3e7ea15@mellanox.com>
 <2b7bb0a4-d697-2a7e-fa02-399f1368d809@ucloud.cn>
In-Reply-To: <2b7bb0a4-d697-2a7e-fa02-399f1368d809@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0099.namprd05.prod.outlook.com
 (2603:10b6:104:1::25) To AM0PR05MB4403.eurprd05.prod.outlook.com
 (2603:10a6:208:65::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [104.156.100.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a18a9fea-e605-4045-7882-08d6db4efb88
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4211;
x-ms-traffictypediagnostic: AM0PR05MB4211:
x-microsoft-antispam-prvs: <AM0PR05MB42110D9131EBBBA5DDDD676AD2040@AM0PR05MB4211.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0041D46242
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(136003)(366004)(39860400002)(396003)(189003)(199004)(110136005)(99286004)(68736007)(186003)(36756003)(66066001)(5660300002)(71190400001)(71200400001)(86362001)(8676002)(26005)(53546011)(6506007)(76176011)(31696002)(52116002)(316002)(81156014)(81166006)(8936002)(7736002)(386003)(6636002)(6486002)(478600001)(6436002)(25786009)(476003)(102836004)(2616005)(11346002)(256004)(486006)(446003)(4326008)(6246003)(66446008)(66476007)(3846002)(229853002)(6116002)(2906002)(6512007)(53936002)(31686004)(64756008)(66556008)(66946007)(14454004)(73956011)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4211;H:AM0PR05MB4403.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ZOaOYVkltBE6iIs9yhAk6rQiE9jGFAypqkrmMb57jNLBDHACH2uqcjSpEB2yxZDVsvCbboLNU7atES/d5iK6PdhFeOB7juf5OodcboGubUlP7p+wszYPcMNLTLklthL3FGoQZp8zZo1ZM4bQGq3N+5me+/9SItxo4moURGDPPL0b7SiiDneGaFmel0u6aDDNI/KDi5TH6zshEqG/PbYdV23DZM6LZdbZrvN5n3y8TFKHbumriXVwnAZ2nQ8DidI5/jqkKYTQBL/mo8KIUvJUEwiaYQZIswffMtn6zbowblJsyPFqkCtwXtEEhdMZWXHbRPa5VPdLIcxWWg0J7329IzRZ84h//xgwI0qOqyQNeq2N8+k0Ebsv3usnS+pjt0y/GwMeR9KH2Kk3uKDbaaU9V2D1gBs7fLzMrY8Idj+t4jU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAD37A080844344B9F571E17E66078BC@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a18a9fea-e605-4045-7882-08d6db4efb88
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2019 05:09:20.0916
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4211
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMTcvMjAxOSAyMDoxNywgd2VueHUgd3JvdGU6DQo+IA0KPiDlnKggMjAxOS81LzE4
IDY6MTEsIE1hcmsgQmxvY2gg5YaZ6YGTOg0KPj4NCj4+IE9uIDUvMTcvMTkgMjoxNyBBTSwgd2Vu
eHVAdWNsb3VkLmNuIHdyb3RlOg0KPj4+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+
Pj4NCj4+PiBUaGUgbWx4NWUgc3VwcG9ydCB0aGUgbGFnIG1vZGUuIFdoZW4gYWRkIG1seF9wMCBh
bmQgbWx4X3AxIHRvIGJvbmQwLg0KPj4+IHBhY2tldCByZWNlaXZlZCBmcm9tIG1seF9wMCBvciBt
bHhfcDEgYW5kIGluIHRoZSBpbmdyZXNzIHRjIGZsb3dlcg0KPj4+IGZvcndhcmQgdG8gdmYwLiBU
aGUgdGMgcnVsZSBjYW4ndCBiZSBvZmZsb2FkZWQgYmVjYXVzZSB0aGVyZSBpcw0KPj4+IG5vIGlu
ZHJfcmVnaXN0ZXJfYmxvY2sgZm9yIHRoZSBib25kaW5nIGRldmljZS4NCj4+Pg0KPj4+IFNpZ25l
ZC1vZmYtYnk6IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+Pj4gLS0tDQo+Pj4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyB8IDEgKw0KPj4+ICAxIGZp
bGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fcmVwLmMNCj4+PiBpbmRleCA5MWUyNGYxLi4x
MzRmYTBiIDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9yZXAuYw0KPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9yZXAuYw0KPj4+IEBAIC03OTYsNiArNzk2LDcgQEAgc3RhdGljIGludCBt
bHg1ZV9uaWNfcmVwX25ldGRldmljZV9ldmVudChzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLA0K
Pj4+ICAJc3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IG5ldGRldl9ub3RpZmllcl9pbmZvX3Rv
X2RldihwdHIpOw0KPj4+ICANCj4+PiAgCWlmICghbWx4NWVfdGNfdHVuX2RldmljZV90b19vZmZs
b2FkKHByaXYsIG5ldGRldikgJiYNCj4+PiArCSAgICAhbmV0aWZfaXNfYm9uZF9tYXN0ZXIobmV0
ZGV2KSAmJg0KPj4gSSdtIG5vdCB0aGF0IGZhbWlsaWFyIHdpdGggdGhpcyBjb2RlIHBhdGgsIGJ1
dCBzaG91bGRuJ3QgeW91IGNoZWNrIHRoZSBtbHg1ZQ0KPj4gbmV0ZGV2aWNlcyBhcmUgc2xhdmVz
IG9mIHRoZSBib25kIGRldmljZSAod2hhdCBpZiB5b3UgaGF2ZSBtdWx0aXBsZQ0KPj4gYm9uZCBk
ZXZpY2VzIGluIHRoZSBzeXN0ZW0/KQ0KPiANCj4gVGhlIGJvbmRpbmcgZGV2aWNlIGlzIG5vdCBz
aW1saWxhciB3aXRoIHZsYW4gZGV2aWNlLMKgIHdoZW4gdmxhbiBkZXZpY2UgaXMgcmVnaXN0ZXIs
IHRoZSByZWFsIGRldmljZSBpcyBkZWZpbnRpdmVkLsKgIEJ1dCB0aGUgd2hlbiB0aGUgYm9uZGlu
ZyBkZXZpY2UgaXMgcmVnaXN0ZXIsIHRoZXJlIG1heWJlIG5vdCBzbGF2ZSBkZXZpY2UuDQoNCkkg
a25vdyBob3cgYm9uZGluZyB3b3JrcywgdGhhdCdzIHdoeSBJIGFza2VkIHdoYXQgSSBhc2tlZC4N
Ckl0IHNlZW1zIHRoZXJlIGlzIGEgcGllY2Ugb2YgY29kZSBtaXNzaW5nIHdoaWNoIGZpbHRlcnMg
dGhlIHJ1bGVzIChwcm9iYWJseSBpbiBtbHg1ZV9jb25maWd1cmVfZmxvd2VyKCkpDQogDQo+IA0K
PiBBcyB0aGUgZm9sbG93aW5nIGNvZGVzLiBBbnkgTkVUREVWX1JFR0lTVEVSIEVWRU5UIHdpbGwg
ZG8gaW5kciByZWdpc3RlciBibG9jay4NCj4gDQo+IMKgwqDCoCBpZiAoIW1seDVlX3RjX3R1bl9k
ZXZpY2VfdG9fb2ZmbG9hZChwcml2LCBuZXRkZXYpICYmDQo+IMKgwqDCoMKgwqDCoMKgICFuZXRp
Zl9pc19ib25kX21hc3RlcihuZXRkZXYpICYmDQo+IMKgwqDCoMKgwqDCoMKgICFpc192bGFuX2Rl
dihuZXRkZXYpKQ0KPiDCoMKgwqDCoMKgwqDCoCByZXR1cm4gTk9USUZZX09LOw0KPiANCj4gwqDC
oMKgIHN3aXRjaCAoZXZlbnQpIHsNCj4gwqDCoMKgIGNhc2UgTkVUREVWX1JFR0lTVEVSOg0KPiDC
oMKgwqDCoMKgwqDCoCBtbHg1ZV9yZXBfaW5kcl9yZWdpc3Rlcl9ibG9jayhycHJpdiwgbmV0ZGV2
KTsNCj4gDQo+Pj4gIAkgICAgIWlzX3ZsYW5fZGV2KG5ldGRldikpDQo+Pj4gIAkJcmV0dXJuIE5P
VElGWV9PSzsNCj4+PiAgDQo+Pj4NCj4+IE1hcmsNCg0KTWFyaw0K
