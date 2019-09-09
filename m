Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5029CADF8F
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 21:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405771AbfIITjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 15:39:43 -0400
Received: from mail-eopbgr00077.outbound.protection.outlook.com ([40.107.0.77]:49031
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405742AbfIITjn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 15:39:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEMWm2hRHvTVWiP0phBHExsEQlOdG40WfsqTjYiQAKmmkhxl0v/LPuoZv4/KXKxpgBs5VyUIw2lLYyD3AV9sZm155WwIGu+6/TlcO451SH0xhXX9+OmxtnBa+ownWseIWRMP8mtYPFqRd+2PhgeZQNT78QlP6ReA/qkYnUTfAU83dc0diNGGijvBN+pzTtXwE6sQJlLhXmw5vrcpzEUft/B7YNgPG49m/7+wrQ2khos6Z4w3zUM0wnfXE2kH6oI8X09X4DfVInDLLJM2JD6L8ZI7P1NhCbN457rOC4OX52NSGCsO7R5PwYoK1eT4y/dmvnbRr/IIivjE/OauZipHAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqAcOrPEgauFOFVOmLTIm6WgUKSVtwsfoX96GP52j3g=;
 b=gaOV55wsVPec5gmI/43lHEV8WpYhINHGpuqwpMr/LdhZsLn1eCQgmjSKNzMWBC/TUx90ySdTE0vnbi6wvnFPk6SxRb5aTQdGXH2ZiXvHJF5rOyxC40O2BDfgp57RK6zH9su7C/NB7Fat+tGBYP9DfpkHXbRjThqpp4PKTf//pysEevYFZlNqHa3uOuKCPZ8qvjQT7ex2AOxx05ld2rq71GwGC6Nfa9Ygf8d0HW4EPkZ/knkUjo3YGpBVBRpi3AH/fAmJO679xKHOvREpxtYzIYb3pkPSH2+w2YaE2JodlQxa7QnzFumC3XEftBlfk92sYqtviPgCv2yk+26bHVUbCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yqAcOrPEgauFOFVOmLTIm6WgUKSVtwsfoX96GP52j3g=;
 b=TfoXv/bfpqLnvw20mvvIbGzbGTZBfKCgVkuVoK1PdxWLu5nKIIfeCL95NEjA7QHIThMQYQkaEZKnR1Tj1KRdYo/teLVDSerLjRp+kxengsYKHvSnwuZDoZb8NNv02t8DPfIyWMB8Q6iM36y8VJYIQFDYwuUAjKtgl9bxP7XrYMI=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2856.eurprd05.prod.outlook.com (10.172.225.143) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.14; Mon, 9 Sep 2019 19:39:38 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Mon, 9 Sep 2019
 19:39:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "cai@lca.pw" <cai@lca.pw>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Feras Daoud <ferasda@mellanox.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Erez Shitrit <erezsh@mellanox.com>
Subject: Re: [PATCH] net/mlx5: reduce stack usage in FW tracer
Thread-Topic: [PATCH] net/mlx5: reduce stack usage in FW tracer
Thread-Index: AQHVZMVcvjrXfAAg+0q1zHGyRVHFvqcjwxGA
Date:   Mon, 9 Sep 2019 19:39:37 +0000
Message-ID: <383db08b6001503ac45c2e12ac514208dc5a4bba.camel@mellanox.com>
References: <20190906151123.1088455-1-arnd@arndb.de>
In-Reply-To: <20190906151123.1088455-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 658d0bb4-3218-4a94-2d0f-08d7355d7376
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2856;
x-ms-traffictypediagnostic: DB6PR0501MB2856:|DB6PR0501MB2856:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB285631D1A2C07DAA5819B777BEB70@DB6PR0501MB2856.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(366004)(39860400002)(51914003)(189003)(199004)(3846002)(6116002)(6486002)(58126008)(5660300002)(6436002)(36756003)(486006)(8676002)(4326008)(305945005)(2201001)(118296001)(71200400001)(71190400001)(2906002)(76176011)(26005)(102836004)(6506007)(229853002)(186003)(256004)(66946007)(64756008)(66476007)(86362001)(66556008)(66446008)(91956017)(76116006)(99286004)(478600001)(476003)(8936002)(446003)(11346002)(6512007)(25786009)(2616005)(66066001)(81156014)(54906003)(110136005)(2501003)(14454004)(53936002)(6246003)(7736002)(316002)(107886003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2856;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7/HzQr30aHp7r2k4MuA6dcVFmeeqKgswF3p5MuOwgBWl/1C5GtHXIzmyTZJ/4NzvhB8WE1RkGVnnK+y2dR5Z1Wx+62JuFphNMJNHs3UDqIvC4X9tLaCJN6Z3MR8XinPtQGLbGjitGei5ZBezIaTcEYYvqlPKWaDZlkL+46jElSLLnquBOjcTacCpDNxyOdcMEj3ixvU7PDkccef/6aypoAwwSnnKd7xIRbFKUbLLjYgItXXoKxd6bP/xzOit8XIUyKULTkgAF84O/1Zd2iozIQ9YcIGH4ynhHvFCkwOZvc2AwPWJXZMCmrWMT/3v7iVF4j8irCWBPeTNbNIg74FnN5e74Y95OjslXfigvnpicsGjJMgHPZEs5ZANbQxE0OWikSxu09AzV4lX4XKZ/NYgfGz+YwkIqB8KMCn4NPCGieg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA8435D65940174CAE227F3EECA102FE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 658d0bb4-3218-4a94-2d0f-08d7355d7376
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2019 19:39:38.0150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DUIJIw5CKbTL6aMotBEKtHQs869SPmu8JhQLKdi/IHhhVNB5kTX7ZYsFINr63+HUnfun3gMGCCEL0SKeudvNVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2856
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA5LTA2IGF0IDE3OjExICswMjAwLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0K
PiBJdCdzIGdlbmVyYWxseSBub3Qgb2sgdG8gcHV0IGEgNTEyIGJ5dGUgYnVmZmVyIG9uIHRoZSBz
dGFjaywgYXMNCj4ga2VybmVsDQo+IHN0YWNrIGlzIGEgc2NhcmNlIHJlc291cmNlOg0KPiANCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmM6
NjYwOjEzOg0KPiBlcnJvcjogc3RhY2sgZnJhbWUgc2l6ZSBvZiAxMDMyIGJ5dGVzIGluIGZ1bmN0
aW9uDQo+ICdtbHg1X2Z3X3RyYWNlcl9oYW5kbGVfdHJhY2VzJyBbLVdlcnJvciwtV2ZyYW1lLWxh
cmdlci10aGFuPV0NCj4gDQo+IFRoaXMgaXMgZG9uZSBpbiBhIGNvbnRleHQgdGhhdCBpcyBhbGxv
d2VkIHRvIHNsZWVwLCBzbyB1c2luZw0KPiBkeW5hbWljIGFsbG9jYXRpb24gaXMgb2sgYXMgd2Vs
bC4gSSdtIG5vdCB0b28gd29ycmllZCBhYm91dA0KPiBydW50aW1lIG92ZXJoZWFkLCBhcyB0aGlz
IGFscmVhZHkgY29udGFpbnMgYW4gc25wcmludGYoKSBhbmQNCj4gb3RoZXIgZXhwZW5zaXZlIGZ1
bmN0aW9ucy4NCj4gDQo+IEZpeGVzOiA3MGRkNmZkYjg5ODcgKCJuZXQvbWx4NTogRlcgdHJhY2Vy
LCBwYXJzZSB0cmFjZXMgYW5kIGtlcm5lbA0KPiB0cmFjaW5nIHN1cHBvcnQiKQ0KPiBTaWduZWQt
b2ZmLWJ5OiBBcm5kIEJlcmdtYW5uIDxhcm5kQGFybmRiLmRlPg0KPiAtLS0NCj4gIC4uLi9tZWxs
YW5veC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIuYyAgICAgICB8IDIxICsrKysrKysrKystLS0t
LS0tDQo+IC0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZGlhZy9md190cmFjZXIuYw0KPiBpbmRleCAyMDExZWFmMTVjYzUuLmQ4
MWU3ODA2MGY5ZiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2RpYWcvZndfdHJhY2VyLmMNCj4gQEAgLTU1NywxNiArNTU3LDE2
IEBAIHN0YXRpYyB2b2lkIG1seDVfdHJhY2VyX3ByaW50X3RyYWNlKHN0cnVjdA0KPiB0cmFjZXJf
c3RyaW5nX2Zvcm1hdCAqc3RyX2ZybXQsDQo+ICAJCQkJICAgIHN0cnVjdCBtbHg1X2NvcmVfZGV2
ICpkZXYsDQo+ICAJCQkJICAgIHU2NCB0cmFjZV90aW1lc3RhbXApDQo+ICB7DQo+IC0JY2hhcgl0
bXBbNTEyXTsNCj4gLQ0KDQpIaSBBcm5kLCB0aGFua3MgZm9yIHRoZSBwYXRjaCwgDQp0aGlzIGZ1
bmN0aW9uIGlzIHZlcnkgcGVyZm9tYW5jZSBjcml0aWNhbCB3aGVuIGZ3IHRyYWNlcyBhcmUgYWN0
aXZhdGVkDQp0byBwdWxsIHNvbWUgZncgY29udGVudCBvbiBlcnJvciBzaXR1YXRpb25zLCB1c2lu
ZyBrbWFsbG9jIGhlcmUgbWlnaHQNCmJlY29tZSBhIHByb2JsZW0gYW5kIHN0YWxsIHRoZSBzeXN0
ZW0gZnVydGhlciBtb3JlIGlmIHRoZSBwcm9ibGVtIHdhcw0KaW5pdGlhbGx5IGR1ZSB0byBsYWNr
IG9mIG1lbW9yeS4NCg0Kc2luY2UgdGhpcyBmdW5jdGlvbiBvbmx5IG5lZWRzIDUxMiBieXRlcyBt
YXliZSB3ZSBzaG91bGQgbWFyayBpdCBhcw0Kbm9pbmxpbmUgdG8gYXZvaWQgYW55IGV4dHJhIHN0
YWNrIHVzYWdlcyBvbiB0aGUgY2FsbGVyIGZ1bmN0aW9uDQptbHg1X2Z3X3RyYWNlcl9oYW5kbGVf
dHJhY2VzID8NCg0KPiAtCXNucHJpbnRmKHRtcCwgc2l6ZW9mKHRtcCksIHN0cl9mcm10LT5zdHJp
bmcsDQo+IC0JCSBzdHJfZnJtdC0+cGFyYW1zWzBdLA0KPiAtCQkgc3RyX2ZybXQtPnBhcmFtc1sx
XSwNCj4gLQkJIHN0cl9mcm10LT5wYXJhbXNbMl0sDQo+IC0JCSBzdHJfZnJtdC0+cGFyYW1zWzNd
LA0KPiAtCQkgc3RyX2ZybXQtPnBhcmFtc1s0XSwNCj4gLQkJIHN0cl9mcm10LT5wYXJhbXNbNV0s
DQo+IC0JCSBzdHJfZnJtdC0+cGFyYW1zWzZdKTsNCj4gKwljaGFyICp0bXAgPSBrYXNwcmludGYo
R0ZQX0tFUk5FTCwgc3RyX2ZybXQtPnN0cmluZywNCj4gKwkJCSAgICAgIHN0cl9mcm10LT5wYXJh
bXNbMF0sDQo+ICsJCQkgICAgICBzdHJfZnJtdC0+cGFyYW1zWzFdLA0KPiArCQkJICAgICAgc3Ry
X2ZybXQtPnBhcmFtc1syXSwNCj4gKwkJCSAgICAgIHN0cl9mcm10LT5wYXJhbXNbM10sDQo+ICsJ
CQkgICAgICBzdHJfZnJtdC0+cGFyYW1zWzRdLA0KPiArCQkJICAgICAgc3RyX2ZybXQtPnBhcmFt
c1s1XSwNCj4gKwkJCSAgICAgIHN0cl9mcm10LT5wYXJhbXNbNl0pOw0KPiArCWlmICghdG1wKQ0K
PiArCQlyZXR1cm47DQo+ICANCj4gIAl0cmFjZV9tbHg1X2Z3KGRldi0+dHJhY2VyLCB0cmFjZV90
aW1lc3RhbXAsIHN0cl9mcm10LT5sb3N0LA0KPiAgCQkgICAgICBzdHJfZnJtdC0+ZXZlbnRfaWQs
IHRtcCk7DQo+IEBAIC01NzYsNiArNTc2LDcgQEAgc3RhdGljIHZvaWQgbWx4NV90cmFjZXJfcHJp
bnRfdHJhY2Uoc3RydWN0DQo+IHRyYWNlcl9zdHJpbmdfZm9ybWF0ICpzdHJfZnJtdCwNCj4gIA0K
PiAgCS8qIHJlbW92ZSBpdCBmcm9tIGhhc2ggKi8NCj4gIAltbHg1X3RyYWNlcl9jbGVhbl9tZXNz
YWdlKHN0cl9mcm10KTsNCj4gKwlrZnJlZSh0bXApOw0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgaW50
IG1seDVfdHJhY2VyX2hhbmRsZV9zdHJpbmdfdHJhY2Uoc3RydWN0IG1seDVfZndfdHJhY2VyDQo+
ICp0cmFjZXIsDQo=
