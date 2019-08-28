Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68589A048F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfH1OPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:15:24 -0400
Received: from mail-eopbgr150087.outbound.protection.outlook.com ([40.107.15.87]:19021
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727018AbfH1OPX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 10:15:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeHGzp0ST95HxoFLw4hEdpLjbcTCs/4uHYtnVt2gBixG2bcnvI98y+v/BYUVM5Q6zs7P8y7GsJhQXfh5rsWCIkTpA/ddEwN7qSZOW8xtSpi003YNGpmlBSo7MUvu/WL8YrTWr9cSOei+t3DLDfo0GDkIEdOEU6MAgnltg3npVvYT1WaYy3G+H4i9xSGE9tHqOXlwmb+Qi63ae1hnyXFMqnmLPJXEjSGBGCDvr7HdLR7+V5LuXYuTpcc9TZrPqzdl+PNLDJbOKtHlilmQpYXUuVsPijhW4iF76aYkAJzhGuYUhhUCbrxwwUXgRHSdG+NR/YGl0qOIoO1NIpiwVOGELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9oaq7nv0FU5ujhf/2t8qkgAG72yw5aOVjiULsW5kec=;
 b=IeinjecachXMxD/LXd2IaQ42NC+SkCFyTE0aXjB9TFbk1HeuXWXYARHjx7neO0KB8blshtPutIT/TcNsrbOex3An0NWW0+Nu1guVt5ix+LNSmfffZWQUgkHWgFSYi0jPdzkTlGkSwNrDA2wpXcBF+ymXW+UPy7pKZThm/WSU4/zPTNpJRhPArtc/yadPRrjsB7TYqyi+8rNrhua2kE5hsVR/1FFlCZ6bWzG70vRIz/3XQQoF3HYOfp0Ar2QyAQExYrR/Y/iM8oNiB9cFXYNHl3AMB6bcUzB5j8Nb7hoj33olTw7roug0njVezS1tE0UHkvCEmS79Ra28oSDHuP+RLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9oaq7nv0FU5ujhf/2t8qkgAG72yw5aOVjiULsW5kec=;
 b=XGfPD0sbLXCHXNeNvS1B7Qw/RIRuocaa16QSyq/fFKC20E+9kMyfZ4dpD8wHRFie2lldo23pe3B6BiJGXemol2GmMLkkms+VUo9tTdh+xjkAgoOdjhQdkQf7bDMapDXLRkTaDO+VwDquiGmNiuo8rnTpmfNY5zxC99YiwC84usY=
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com (20.178.12.80) by
 VI1PR05MB5568.eurprd05.prod.outlook.com (20.177.202.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 14:15:17 +0000
Received: from VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae]) by VI1PR05MB5295.eurprd05.prod.outlook.com
 ([fe80::ec21:2019:cb6f:44ae%7]) with mapi id 15.20.2178.023; Wed, 28 Aug 2019
 14:15:17 +0000
From:   Vlad Buslov <vladbu@mellanox.com>
To:     tanhuazhong <tanhuazhong@huawei.com>
CC:     Vlad Buslov <vladbu@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next v3 05/10] net: sched: add API for registering
 unlocked offload block callbacks
Thread-Topic: [PATCH net-next v3 05/10] net: sched: add API for registering
 unlocked offload block callbacks
Thread-Index: AQHVXBSHMVX/xyrnN0yQdsJfQI7UeKcQdjsAgAAnn4A=
Date:   Wed, 28 Aug 2019 14:15:17 +0000
Message-ID: <vbf7e6x74we.fsf@mellanox.com>
References: <20190826134506.9705-1-vladbu@mellanox.com>
 <20190826134506.9705-6-vladbu@mellanox.com>
 <e44141c7-2029-3bee-57b5-ce910a100b72@huawei.com>
In-Reply-To: <e44141c7-2029-3bee-57b5-ce910a100b72@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0113.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::29) To VI1PR05MB5295.eurprd05.prod.outlook.com
 (2603:10a6:803:b1::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vladbu@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 398f1b66-65d6-4ad8-7157-08d72bc226ab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR05MB5568;
x-ms-traffictypediagnostic: VI1PR05MB5568:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB556875DBBE245F41EF92E59EADA30@VI1PR05MB5568.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(189003)(199004)(305945005)(6916009)(6116002)(3846002)(486006)(64756008)(66946007)(66476007)(66556008)(66446008)(386003)(6506007)(53546011)(4326008)(229853002)(102836004)(186003)(76176011)(14454004)(71190400001)(71200400001)(25786009)(26005)(6486002)(5024004)(256004)(5660300002)(478600001)(316002)(14444005)(99286004)(36756003)(54906003)(66066001)(8676002)(7736002)(53936002)(107886003)(81166006)(81156014)(6246003)(8936002)(2906002)(11346002)(476003)(52116002)(446003)(6512007)(86362001)(2616005)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5568;H:VI1PR05MB5295.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: fM9l0PHHF7XxSHlwlc6oksFyRXtlTJMYUOyqXiaYs3+RTx1ozRbnUA7X6R6IbU0Z2q0uoA9P7iaFnkCyYaAAF7NTLG26l00vBqMFGOCjo1GyQMXakjHgwXumU41X/wZJK5dFme0vtlTFGZkxpRAWTwjYuHTngABBoq8CmRgsiRMvx9tML3ESOnXMUuYsccQcV0vV3jilLAWxOTwMWeV6lIfSapNmNjv2Z2q42sOb094s2xBJlpVzpGwyIABaedpKSQVLq9+fg9stM6FRZGGEz8VUldHdfOikpP/hl+ZXEGQODzDt28r5PNfXIFqfaRvG2wVfjxGFNyCmIvMIZAtINyBSkcIp0diNSUH0dqSNP3twdVbKUC+kJ8221626oxdEn8dOqHiPF+wR+ENDBDIE9NXNtgrmvRxyuV/TMrI2Wy4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <50EC0D490EF8BA4C9A631C45FA286926@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 398f1b66-65d6-4ad8-7157-08d72bc226ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 14:15:17.0333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lo4ZUUeBEc3UGnESdlpo8x9T5LAgUTPvJpgNjdULiPofYJ8zGxcyZqLwxRawysORDTb2/1vs73B0mE7XLADe8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5568
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkIDI4IEF1ZyAyMDE5IGF0IDE0OjUzLCB0YW5odWF6aG9uZyA8dGFuaHVhemhvbmdAaHVh
d2VpLmNvbT4gd3JvdGU6DQo+IE9uIDIwMTkvOC8yNiAyMTo0NSwgVmxhZCBCdXNsb3Ygd3JvdGU6
DQo+PiBFeHRlbmQgc3RydWN0IGZsb3dfYmxvY2tfb2ZmbG9hZCB3aXRoICJ1bmxvY2tlZF9kcml2
ZXJfY2IiIGZsYWcgdG8gYWxsb3cNCj4+IHJlZ2lzdGVyaW5nIGFuZCB1bnJlZ2lzdGVyaW5nIGJs
b2NrIGhhcmR3YXJlIG9mZmxvYWQgY2FsbGJhY2tzIHRoYXQgZG8gbm90DQo+PiByZXF1aXJlIGNh
bGxlciB0byBob2xkIHJ0bmwgbG9jay4gRXh0ZW5kIHRjZl9ibG9jayB3aXRoIGFkZGl0aW9uYWwN
Cj4+IGxvY2tlZGRldmNudCBjb3VudGVyIHRoYXQgaXMgaW5jcmVtZW50ZWQgZm9yIGVhY2ggbm9u
LXVubG9ja2VkIGRyaXZlcg0KPj4gY2FsbGJhY2sgYXR0YWNoZWQgdG8gZGV2aWNlLiBUaGlzIGNv
dW50ZXIgaXMgbmVjZXNzYXJ5IHRvIGNvbmRpdGlvbmFsbHkNCj4+IG9idGFpbiBydG5sIGxvY2sg
YmVmb3JlIGNhbGxpbmcgaGFyZHdhcmUgY2FsbGJhY2tzIGluIGZvbGxvd2luZyBwYXRjaGVzLg0K
Pj4NCj4+IFJlZ2lzdGVyIG1seDUgdGMgYmxvY2sgb2ZmbG9hZCBjYWxsYmFja3MgYXMgInVubG9j
a2VkIi4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBWbGFkIEJ1c2xvdiA8dmxhZGJ1QG1lbGxhbm94
LmNvbT4NCj4+IEFja2VkLWJ5OiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT4NCj4+IC0t
LQ0KPj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5j
IHwgMiArKw0KPj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5f
cmVwLmMgIHwgMyArKysNCj4+ICAgaW5jbHVkZS9uZXQvZmxvd19vZmZsb2FkLmggICAgICAgICAg
ICAgICAgICAgICAgICB8IDEgKw0KPj4gICBpbmNsdWRlL25ldC9zY2hfZ2VuZXJpYy5oICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgMSArDQo+PiAgIG5ldC9zY2hlZC9jbHNfYXBpLmMgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfCA2ICsrKysrKw0KPj4gICA1IGZpbGVzIGNoYW5nZWQs
IDEzIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lbl9tYWluLmMNCj4+IGluZGV4IGZhNGJmMmQ0YmNkNC4uODU5MmI5
OGQwZTcwIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL2VuX21haW4uYw0KPj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuX21haW4uYw0KPj4gQEAgLTM0NzAsMTAgKzM0NzAsMTIgQEAgc3RhdGljIGlu
dCBtbHg1ZV9zZXR1cF90YyhzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LCBlbnVtIHRjX3NldHVwX3R5
cGUgdHlwZSwNCj4+ICAgCQkJICB2b2lkICp0eXBlX2RhdGEpDQo+PiAgIHsNCj4+ICAgCXN0cnVj
dCBtbHg1ZV9wcml2ICpwcml2ID0gbmV0ZGV2X3ByaXYoZGV2KTsNCj4+ICsJc3RydWN0IGZsb3df
YmxvY2tfb2ZmbG9hZCAqZiA9IHR5cGVfZGF0YTsNCj4+ICAgICAJc3dpdGNoICh0eXBlKSB7DQo+
PiAgICNpZmRlZiBDT05GSUdfTUxYNV9FU1dJVENIDQo+PiAgIAljYXNlIFRDX1NFVFVQX0JMT0NL
Og0KPj4gKwkJZi0+dW5sb2NrZWRfZHJpdmVyX2NiID0gdHJ1ZTsNCj4+ICAgCQlyZXR1cm4gZmxv
d19ibG9ja19jYl9zZXR1cF9zaW1wbGUodHlwZV9kYXRhLA0KPj4gICAJCQkJCQkgICZtbHg1ZV9i
bG9ja19jYl9saXN0LA0KPj4gICAJCQkJCQkgIG1seDVlX3NldHVwX3RjX2Jsb2NrX2NiLA0KPiBI
aSwNCj4NCj4gSSBoYXZlIGdvdCBiZWxvdyB3YXJuaW5nIHdoZW4gY29tcGlsaW5nIHRoZSBsYXRl
c3QgbmV0LW5leHQ6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94Ly9tbHg1L2NvcmUv
ZW5fbWFpbi5jOjM0NzM6Mjk6IHdhcm5pbmc6IHVudXNlZA0KPiB2YXJpYWJsZSDigJhm4oCZIFst
V3VudXNlZC12YXJpYWJsZV0NCj4gICBzdHJ1Y3QgZmxvd19ibG9ja19vZmZsb2FkICpmID0gdHlw
ZV9kYXRhOw0KPg0KPiBDb3VsZCB0aGlzIHZhcmlhYmxlIGJlIGRlZmluZWQgd2l0aGluICIjaWZk
ZWYgQ09ORklHX01MWDVfRVNXSVRDSCI/DQo+IEJUVywgaXQgc2VlbXMgdmFyaWJsZSBmIGhhcyBu
b3QgYmVlbiB1c2VkIGluIGFueSBwbGFjZSBpbiBhZGRpdGlvbiB0byBhc3NpZ25pbmcNCj4gdHJ1
ZSB0byBpdHMgbWVtYmVyIHVubG9ja2VkX2RyaXZlcl9jYiBpbiAiY2FzZSBUQ19TRVRVUF9CTE9D
SzoiLiBNYXliZSBJIGhhdmUNCj4gbWlzcyBzb21ldGhpbmcgYWJvdXQgaXQ6KS4NCj4NCj4gSHVh
emhvbmcuDQo+IFRoYW5rcy4NCj4NCg0KSGkgSHVhemhvbmcsDQoNClRoYW5rcyBmb3IgcmVwb3J0
aW5nIQ0KDQpZZXMsIGl0IGxvb2tzIGxpa2UgZiBkZWNsYXJhdGlvbiBuZWVkcyB0byBiZSBtb3Zl
ZCBpbnRvICIjaWZkZWYNCkNPTkZJR19NTFg1X0VTV0lUQ0giIGJsb2NrLiBJJ2xsIHNlbmQgdGhl
IHBhdGNoLg0KDQpSZWdhcmRzLA0KVmxhZA0K
