Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4852201A
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 00:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfEQWLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 18:11:38 -0400
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:35662
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbfEQWLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 May 2019 18:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLpeFd/rs4TfMiOcbdQr7Y3pqSA9Jj4U+G3b+Xtzu0I=;
 b=TnmBskxJcW/7WeoWbjTqSIqm+Qs4Zz/OOLHSFBr/frjNPK9VGhrpeJsbzy94Bl4AmfoN7vL5lwxsiINyv5ll+u8mf057LiZrExqzfvQ1MJ3Ta3edTlGNP2lKr/djwvGCqvXXCxV7BB2JS3xPjTdJGDlfIPw2bVGZHPmIw5zfBJQ=
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com (52.134.125.139) by
 AM0PR05MB4196.eurprd05.prod.outlook.com (52.134.90.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Fri, 17 May 2019 22:11:34 +0000
Received: from AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::9d94:3e29:d61d:f79f]) by AM0PR05MB4403.eurprd05.prod.outlook.com
 ([fe80::9d94:3e29:d61d:f79f%5]) with mapi id 15.20.1900.010; Fri, 17 May 2019
 22:11:34 +0000
From:   Mark Bloch <markb@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Roi Dayan <roid@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
Thread-Topic: [PATCH v2] net/mlx5e: Add bonding device for indr block to
 offload the packet received from bonding device
Thread-Index: AQHVDJI54U3U/3hROkOwo7IesqXmtKZv4csA
Date:   Fri, 17 May 2019 22:11:33 +0000
Message-ID: <1129938e-2dff-9aed-5a76-f438e3e7ea15@mellanox.com>
References: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1558084668-21203-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0107.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::48) To AM0PR05MB4403.eurprd05.prod.outlook.com
 (2603:10a6:208:65::11)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=markb@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [208.186.24.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdf2c7fe-5177-465f-df08-08d6db149f1a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4196;
x-ms-traffictypediagnostic: AM0PR05MB4196:
x-microsoft-antispam-prvs: <AM0PR05MB41963BDD5FAD27DD8DB17094D20B0@AM0PR05MB4196.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(346002)(376002)(366004)(136003)(189003)(199004)(71190400001)(99286004)(73956011)(6246003)(71200400001)(26005)(186003)(8936002)(76176011)(66946007)(8676002)(4326008)(6636002)(81156014)(316002)(476003)(86362001)(68736007)(229853002)(256004)(110136005)(7736002)(5660300002)(305945005)(53936002)(31686004)(81166006)(31696002)(52116002)(14454004)(2906002)(478600001)(3846002)(6116002)(2616005)(53546011)(102836004)(11346002)(6436002)(446003)(2501003)(6506007)(6512007)(66446008)(66556008)(66476007)(64756008)(36756003)(25786009)(66066001)(386003)(486006)(55236004)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4196;H:AM0PR05MB4403.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: dIY7EojH4rHePe8NyCuhYE/dVTvMYnbFeq53yh5q+9r8C/W9f4F8RBNFD2ftbTVWXWetRAfcgNThN6CHCiqcEkp6GITxNG2v3HF+2GNNvyUB0kOOpTDLjbUIBRTkz+Ju8KFDH7l7mgGsazt/O2UFqFx9sYR127Xk/2E8A89OylyL8YrbjXwFIwLzsSjuA+a3O2YHDISgTK2i/+0G0a/qKLkbz2kRi2P2lphKds+/WRUHJAW/1XYdWJAO0JGB+5vXBA/lupvuiagdmpE+anDOemq+LQ/W4aVIWL9+nxI4c6O0/XGQIffHUCskZkHGCKTyji9xGtPgf3Yil0PNkyWzO1jm/Ef7gcIWvszQo6KULAMhopEqD1QyqaKEKbPUxIe0K0Gz8EN17vABgEl9MY3yFeCx503Q8L6pDwlQPWImOM4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5EBA18245660F643A3B6A6A0DC19CBBE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf2c7fe-5177-465f-df08-08d6db149f1a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 22:11:34.2386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDUvMTcvMTkgMjoxNyBBTSwgd2VueHVAdWNsb3VkLmNuIHdyb3RlOg0KPiBGcm9tOiB3
ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiANCj4gVGhlIG1seDVlIHN1cHBvcnQgdGhlIGxhZyBt
b2RlLiBXaGVuIGFkZCBtbHhfcDAgYW5kIG1seF9wMSB0byBib25kMC4NCj4gcGFja2V0IHJlY2Vp
dmVkIGZyb20gbWx4X3AwIG9yIG1seF9wMSBhbmQgaW4gdGhlIGluZ3Jlc3MgdGMgZmxvd2VyDQo+
IGZvcndhcmQgdG8gdmYwLiBUaGUgdGMgcnVsZSBjYW4ndCBiZSBvZmZsb2FkZWQgYmVjYXVzZSB0
aGVyZSBpcw0KPiBubyBpbmRyX3JlZ2lzdGVyX2Jsb2NrIGZvciB0aGUgYm9uZGluZyBkZXZpY2Uu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiB3ZW54dSA8d2VueHVAdWNsb3VkLmNuPg0KPiAtLS0NCj4g
IGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyB8IDEgKw0K
PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jDQo+IGluZGV4IDkxZTI0ZjEu
LjEzNGZhMGIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9yZXAuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fcmVwLmMNCj4gQEAgLTc5Niw2ICs3OTYsNyBAQCBzdGF0aWMgaW50IG1seDVl
X25pY19yZXBfbmV0ZGV2aWNlX2V2ZW50KHN0cnVjdCBub3RpZmllcl9ibG9jayAqbmIsDQo+ICAJ
c3RydWN0IG5ldF9kZXZpY2UgKm5ldGRldiA9IG5ldGRldl9ub3RpZmllcl9pbmZvX3RvX2Rldihw
dHIpOw0KPiAgDQo+ICAJaWYgKCFtbHg1ZV90Y190dW5fZGV2aWNlX3RvX29mZmxvYWQocHJpdiwg
bmV0ZGV2KSAmJg0KPiArCSAgICAhbmV0aWZfaXNfYm9uZF9tYXN0ZXIobmV0ZGV2KSAmJg0KDQpJ
J20gbm90IHRoYXQgZmFtaWxpYXIgd2l0aCB0aGlzIGNvZGUgcGF0aCwgYnV0IHNob3VsZG4ndCB5
b3UgY2hlY2sgdGhlIG1seDVlDQpuZXRkZXZpY2VzIGFyZSBzbGF2ZXMgb2YgdGhlIGJvbmQgZGV2
aWNlICh3aGF0IGlmIHlvdSBoYXZlIG11bHRpcGxlDQpib25kIGRldmljZXMgaW4gdGhlIHN5c3Rl
bT8pDQoNCj4gIAkgICAgIWlzX3ZsYW5fZGV2KG5ldGRldikpDQo+ICAJCXJldHVybiBOT1RJRllf
T0s7DQo+ICANCj4gDQoNCk1hcmsNCg==
