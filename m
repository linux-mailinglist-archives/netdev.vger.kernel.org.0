Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B962D2D396
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfE2CID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:08:03 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:48196
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726439AbfE2CIC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:08:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1rGEef9qMuIt3TG5IQ9Ri1c81MD7tuoZ8zR0zup8fBk=;
 b=TLO+ywZtj9Gh5axEq0x5z3WWitp8xTy9K3n0sPrTONpwHh2b5XYAU5rKmt1WveeHRyJvB4Wx05bNXHwDCf+OHjiR4LOR44Rcu4SI7Fqsxkp8OaZBqeYk8kvpEf4UezmWaIJS+sA7eE+6JFVM7Sdd4syrrFqXtDtmIfi3Ne5aeQE=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 02:07:59 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:07:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Huy Nguyen <huyn@mellanox.com>
Subject: [net 1/6] net/mlx5: Fix error handling in mlx5_load()
Thread-Topic: [net 1/6] net/mlx5: Fix error handling in mlx5_load()
Thread-Index: AQHVFcNWztXGwjX+u0qvDKXWzxtcfw==
Date:   Wed, 29 May 2019 02:07:59 +0000
Message-ID: <20190529020737.4172-2-saeedm@mellanox.com>
References: <20190529020737.4172-1-saeedm@mellanox.com>
In-Reply-To: <20190529020737.4172-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:74::43) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cd4e05d-b83d-46df-ab1c-08d6e3da78d8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB59478F4BBE5617B0240D98EABE1F0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(3846002)(6116002)(54906003)(6486002)(8936002)(2906002)(86362001)(81166006)(6506007)(50226002)(8676002)(81156014)(99286004)(53936002)(256004)(14454004)(386003)(14444005)(5024004)(71200400001)(52116002)(7736002)(305945005)(102836004)(6436002)(71190400001)(5660300002)(316002)(36756003)(4744005)(186003)(4326008)(476003)(68736007)(486006)(6512007)(446003)(1076003)(66476007)(73956011)(66446008)(66556008)(66946007)(25786009)(478600001)(26005)(2616005)(107886003)(76176011)(66066001)(64756008)(6916009)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jW58VSiWrqLTEhOtrSXMDX5ECQ4WqRJJSl6Z60XSUxoYx2wFWqIJldA2/r9tV447igIyCw7wOTpnE0RqFKPVqa4Afohd9eynX8IvnVqrHFqehC1Jg6NxXssWKcC89EtY/ONuEYmAONfYrQmRHGUBhdfuURzUtUEVACRl9PMr6wNgmjWCFtQKDC/8nDAAe7CpL4svWilLp3/0PQFAY1IiyT8YRCS1nZ6ltqPClQLPnNCg/FFliJZa6+CeufIgiX6v0frDlNvUt7XHctAlTZi9q073ZHjHgp8uhRzJLE3XQ/I95z6hDy3r4lIK0QR/ahEfw4DoxIFsHWBM4wOIi36AIPkGJiFHQO2kqybi+5kmTkS4GxfdkPXhOderV6AcTwkkP+JqNCuJ6Rfl2ZwdJfKVK73GTWHcTdU2SZi2WkpwfQ0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd4e05d-b83d-46df-ab1c-08d6e3da78d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:07:59.4961
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SW4gY2FzZSBtbHg1X2NvcmVfc2V0X2hjYV9kZWZhdWx0cyBmYWlscywgaXQgc2hvdWxkIGp1bXAg
dG8NCm1seDVfY2xlYW51cF9mcywgZml4IHRoYXQuDQoNCkZpeGVzOiBjODUwMjNlMTUzZTMgKCJJ
Qi9tbHg1OiBBZGQgcmF3IGV0aGVybmV0IGxvY2FsIGxvb3BiYWNrIHN1cHBvcnQiKQ0KU2lnbmVk
LW9mZi1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1i
eTogSHV5IE5ndXllbiA8aHV5bkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBN
YWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9tYWluLmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL21haW4uYw0KaW5kZXggNjFmYTFkMTYyZDI4Li4yM2Q1MzE2M2NlMTUg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFp
bi5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbWFpbi5j
DQpAQCAtMTA2Nyw3ICsxMDY3LDcgQEAgc3RhdGljIGludCBtbHg1X2xvYWQoc3RydWN0IG1seDVf
Y29yZV9kZXYgKmRldikNCiAJZXJyID0gbWx4NV9jb3JlX3NldF9oY2FfZGVmYXVsdHMoZGV2KTsN
CiAJaWYgKGVycikgew0KIAkJbWx4NV9jb3JlX2VycihkZXYsICJGYWlsZWQgdG8gc2V0IGhjYSBk
ZWZhdWx0c1xuIik7DQotCQlnb3RvIGVycl9mczsNCisJCWdvdG8gZXJyX3NyaW92Ow0KIAl9DQog
DQogCWVyciA9IG1seDVfc3Jpb3ZfYXR0YWNoKGRldik7DQotLSANCjIuMjEuMA0KDQo=
