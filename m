Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B72A64836
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727718AbfGJOWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:22:36 -0400
Received: from mail-eopbgr130077.outbound.protection.outlook.com ([40.107.13.77]:36352
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726458AbfGJOWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 10:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlXGswaZ/5zL+0Zngylny5MOfThBYNZMFUGClamJQc4=;
 b=IG4lusor55i/60H7144lY0Y1KgEFF1XeCmxOYC33jlWy7TcMJLqDod4vgYMQJt+slR9nnH/hNHNfvUUxL746kRkrvIVPQtv/trtETfY7f1FliWciMFe8dhZxjq0c0erefFqO6cxzIF13JV74e+g0D7NgfL67dzwwWYz9+Z27e3s=
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com (20.179.40.84) by
 DBBPR05MB6284.eurprd05.prod.outlook.com (20.179.40.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Wed, 10 Jul 2019 14:22:32 +0000
Received: from DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d]) by DBBPR05MB6283.eurprd05.prod.outlook.com
 ([fe80::2833:939d:2b5c:4a2d%6]) with mapi id 15.20.2052.020; Wed, 10 Jul 2019
 14:22:32 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Arnd Bergmann <arnd@arndb.de>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH] [net-next] net/mlx5e: avoid uninitialized variable use
Thread-Topic: [PATCH] [net-next] net/mlx5e: avoid uninitialized variable use
Thread-Index: AQHVNyBRVwVX0gwDIkCUs29jQk2dLKbD54yA
Date:   Wed, 10 Jul 2019 14:22:32 +0000
Message-ID: <ff44dab2-3955-25a8-e14e-a21e8826010b@mellanox.com>
References: <20190710130638.1846846-1-arnd@arndb.de>
In-Reply-To: <20190710130638.1846846-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR10CA0061.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::38) To DBBPR05MB6283.eurprd05.prod.outlook.com
 (2603:10a6:10:c1::20)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45cf00b1-638f-4c12-ae4c-08d705420ba3
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DBBPR05MB6284;
x-ms-traffictypediagnostic: DBBPR05MB6284:
x-microsoft-antispam-prvs: <DBBPR05MB62842A78A3A45EFE4AB4C65BAEF00@DBBPR05MB6284.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0094E3478A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(199004)(189003)(476003)(486006)(25786009)(446003)(11346002)(8676002)(81156014)(6512007)(68736007)(36756003)(316002)(102836004)(81166006)(2906002)(6246003)(26005)(52116002)(66066001)(4326008)(53546011)(110136005)(54906003)(2616005)(478600001)(8936002)(71190400001)(31686004)(6506007)(99286004)(386003)(186003)(305945005)(53936002)(66946007)(256004)(31696002)(14444005)(86362001)(14454004)(229853002)(5660300002)(66476007)(66556008)(66446008)(64756008)(6116002)(3846002)(6486002)(6436002)(71200400001)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DBBPR05MB6284;H:DBBPR05MB6283.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0NmcMLRHii1F9T4YUCN+jaMAQAYICLL0l71TE9VgYnGhpATwIMrSJjmq7szoZPrKb9X1RQ78lxZp0MSJULyGewYsXSd9e130TMpzR84da6LaQr+eI/Qfm734A3hXYx1fHBeB0cLmDjNAuvwGskG7184piFevST3Fa+R/TjfEVWa1JprAQXxlg+/skRByn30Dbx/Et2URIVwZnJXeutmmduFsoHjOW70ZC3oTxj8V+WYddckGVHTEB9hzjQtIbScE7SMtQhlze58ybgCEYWDGhBt0OJ3k8OUd7jsEAJLnFl0FqXbR9mOMPo0BNN/Yq0v2XanAWdNqr9C5mF2rOGPr7s7TkPUleEaG4SLeKkGmdLrPSB8V4Pso8o24dO8XOpyWwa8xvpCkpYTLnuZF9vuemvp0DmMAKMcj8LSjY7N9PUg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4102A4EFDB3ED24CA8D41EA9F9003CF4@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45cf00b1-638f-4c12-ae4c-08d705420ba3
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2019 14:22:32.0179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6284
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTAvMjAxOSA0OjA2IFBNLCBBcm5kIEJlcmdtYW5uIHdyb3RlOg0KPiBjbGFuZyBw
b2ludHMgdG8gYSB2YXJpYWJsZSBiZWluZyB1c2VkIGluIGFuIHVuZXhwZWN0ZWQNCj4gY29kZSBw
YXRoOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2Fj
Y2VsL2t0bHNfdHguYzoyNTE6Mjogd2FybmluZzogdmFyaWFibGUgJ3JlY19zZXFfc3onIGlzIHVz
ZWQgdW5pbml0aWFsaXplZCB3aGVuZXZlciBzd2l0Y2ggZGVmYXVsdCBpcyB0YWtlbiBbLVdzb21l
dGltZXMtdW5pbml0aWFsaXplZF0NCj4gICAgICAgICAgZGVmYXVsdDoNCj4gICAgICAgICAgXn5+
fn5+fg0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fYWNjZWwv
a3Rsc190eC5jOjI1NTo0Njogbm90ZTogdW5pbml0aWFsaXplZCB1c2Ugb2NjdXJzIGhlcmUNCj4g
ICAgICAgICAgc2tpcF9zdGF0aWNfcG9zdCA9ICFtZW1jbXAocmVjX3NlcSwgJnJuX2JlLCByZWNf
c2VxX3N6KTsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBefn5+fn5+fn5+DQo+IA0KPiAgRnJvbSBsb29raW5nIGF0IHRoZSBmdW5jdGlvbiBs
b2dpYywgaXQgc2VlbXMgdGhhdCB0aGVyZSBpcyBubw0KPiBzZW5zaWJsZSB3YXkgdG8gY29udGlu
dWUgaGVyZSwgc28ganVzdCByZXR1cm4gZWFybHkgYW5kIGhvcGUNCj4gZm9yIHRoZSBiZXN0Lg0K
PiANCj4gRml4ZXM6IGQyZWFkMWYzNjBlOCAoIm5ldC9tbHg1ZTogQWRkIGtUTFMgVFggSFcgb2Zm
bG9hZCBzdXBwb3J0IikNCj4gU2lnbmVkLW9mZi1ieTogQXJuZCBCZXJnbWFubiA8YXJuZEBhcm5k
Yi5kZT4NCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2VuX2FjY2VsL2t0bHNfdHguYyB8IDEgKw0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS9lbl9hY2NlbC9rdGxzX3R4LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fYWNjZWwva3Rsc190eC5jDQo+IGluZGV4IDNmNWY0MzE3YTIyYi4uNWMw
ODg5MTgwNmYwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvZW5fYWNjZWwva3Rsc190eC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9hY2NlbC9rdGxzX3R4LmMNCj4gQEAgLTI1MCw2ICsyNTAs
NyBAQCB0eF9wb3N0X3Jlc3luY19wYXJhbXMoc3RydWN0IG1seDVlX3R4cXNxICpzcSwNCj4gICAJ
fQ0KPiAgIAlkZWZhdWx0Og0KPiAgIAkJV0FSTl9PTigxKTsNCj4gKwkJcmV0dXJuOw0KPiAgIAl9
DQo+ICAgDQo+ICAgCXNraXBfc3RhdGljX3Bvc3QgPSAhbWVtY21wKHJlY19zZXEsICZybl9iZSwg
cmVjX3NlcV9zeik7DQo+IA0KDQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVs
bGFub3guY29tPg0KDQpUaGFua3MhDQo=
