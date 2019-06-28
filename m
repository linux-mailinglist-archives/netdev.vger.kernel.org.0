Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 133B85A776
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfF1XSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:18:33 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28738
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbfF1XSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:18:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=Euu4L0w7xfs07mWUiveRdSDWpZj/4TmsI76vyt7oWzo2+n6AvRzL2KL42WEh+7wc1ypHCeRoJWc90dm7MrGQP7qoS01JOwD6R6qYopCFy/q6CR8CIAa1vBJyFmJfI0+yQ2Uvx0ts45EHYw0WaHmPCpkeFv+spdW5B9v2Dm0O6dE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiAqjcszIEiRswCDCF/esCZc6qNO+Fs5+tz3rBqyjHc=;
 b=Pzf21XXY5LWv/Q+JT8JkIQd7+D7Sl+9b8LtQnhOXOLIi3AMzK/OatXiipPk2kpW189OYIXH8w5GsZybcT9fkgiZZqx3AbaTOrCM+IQBq9qZl/6CA/otQ5bYKif+04Sme3eRV8kPjhD7cFVnlLLhrSDWBOvZ1WLa9W3CuFiFqsFE=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JiAqjcszIEiRswCDCF/esCZc6qNO+Fs5+tz3rBqyjHc=;
 b=EqVd+OsuOh+zdUvwq/wP23lfHWfeOZQ4QWgOuBtGOGo8qrWwlvo7sMhpcbbQZTN8YkLVdVtaF+vta5YvNTsyJ091TQlVXzLeRB8zwTZFiQ228EBkrAhoSarfDynDuGwZGa6NF0e5mJkHht6ijwgldyCNo0susEnX6tcoQsqzV2E=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:20 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gavi Teitz <gavi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/10] net/mlx5: MPFS, Cleanup add MAC flow
Thread-Topic: [net-next 01/10] net/mlx5: MPFS, Cleanup add MAC flow
Thread-Index: AQHVLgfGvQgOa6bQK0On5Bd7vUKAiQ==
Date:   Fri, 28 Jun 2019 23:18:20 +0000
Message-ID: <20190628231759.16374-2-saeedm@mellanox.com>
References: <20190628231759.16374-1-saeedm@mellanox.com>
In-Reply-To: <20190628231759.16374-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR01CA0057.prod.exchangelabs.com (2603:10b6:a03:94::34)
 To DB6PR0501MB2759.eurprd05.prod.outlook.com (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fc7a88b-d0cf-45e2-a532-08d6fc1ee863
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB2198A0F0C4E015749EDFC57EBEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(14444005)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: PWNPzyKSRvXlz9VM1eUQXkqVrQ0TrDF1J+GSRkAkON+hk1UQN0Ey4yMKD1PdvkJ/Tzny6P/CO/J8QHSKmFZuJFYBYjV/3L8Dyzs7lKfmzuDPHxRNMEXTnEXg9MXWaJrqLrhavLL3QAZpLHEeMPN4hfIqfj8cQYGW8QmD4Vv8pMRR3A5keToO2Pj/ZaefCXFAdPhCMJ1dacjqQ9RdLVkmBd8uxJgsIv8APdKMzq8mceFnBb/kYOsPUCMp1FIrPenT8gMBiTOzpw+S4XcfD2Ef3pAj5Aulgq3Ggy4UwSRx+jwKU8PHExfzb5uyog4GBEkWoHX7rZadFEBNkNvENrcuYy1pBhznOJzt8cCk7e4kMmxpaMG2gahDd9/7FcU04KBvBR9A1xAedKg1+UYSv1/vPQ4T1Y3Q+ki2asT6Vvh0Yg4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc7a88b-d0cf-45e2-a532-08d6fc1ee863
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:20.0519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2198
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogR2F2aSBUZWl0eiA8Z2F2aUBtZWxsYW5veC5jb20+DQoNClVuaWZ5IGFuZCBpc29sYXRl
IHRoZSBlcnJvciBoYW5kbGluZyBmbG93IGluIG1seDVfbXBmc19hZGRfbWFjKCksDQpyZW1vdmlu
ZyBjb2RlIGR1cGxpY2F0aW9uLg0KDQpTaWduZWQtb2ZmLWJ5OiBHYXZpIFRlaXR6IDxnYXZpQG1l
bGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFu
b3guY29tPg0KLS0tDQogLi4uL2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9saWIvbXBmcy5j
ICAgIHwgMjYgKysrKysrKysrKystLS0tLS0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRp
b25zKCspLCAxMSBkZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9saWIvbXBmcy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2xpYi9tcGZzLmMNCmluZGV4IGE3MWQ1YjljN2FiMi4uOWFlN2Rh
ZDU5MGE5IDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2xpYi9tcGZzLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9saWIvbXBmcy5jDQpAQCAtMTM0LDggKzEzNCw4IEBAIGludCBtbHg1X21wZnNfYWRkX21h
YyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB1OCAqbWFjKQ0KIHsNCiAJc3RydWN0IG1seDVf
bXBmcyAqbXBmcyA9IGRldi0+cHJpdi5tcGZzOw0KIAlzdHJ1Y3QgbDJ0YWJsZV9ub2RlICpsMmFk
ZHI7DQorCWludCBlcnIgPSAwOw0KIAl1MzIgaW5kZXg7DQotCWludCBlcnI7DQogDQogCWlmICgh
TUxYNV9FU1dJVENIX01BTkFHRVIoZGV2KSkNCiAJCXJldHVybiAwOw0KQEAgLTE0NSwyOSArMTQ1
LDMzIEBAIGludCBtbHg1X21wZnNfYWRkX21hYyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCB1
OCAqbWFjKQ0KIAlsMmFkZHIgPSBsMmFkZHJfaGFzaF9maW5kKG1wZnMtPmhhc2gsIG1hYywgc3Ry
dWN0IGwydGFibGVfbm9kZSk7DQogCWlmIChsMmFkZHIpIHsNCiAJCWVyciA9IC1FRVhJU1Q7DQot
CQlnb3RvIGFib3J0Ow0KKwkJZ290byBvdXQ7DQogCX0NCiANCiAJZXJyID0gYWxsb2NfbDJ0YWJs
ZV9pbmRleChtcGZzLCAmaW5kZXgpOw0KIAlpZiAoZXJyKQ0KLQkJZ290byBhYm9ydDsNCisJCWdv
dG8gb3V0Ow0KIA0KIAlsMmFkZHIgPSBsMmFkZHJfaGFzaF9hZGQobXBmcy0+aGFzaCwgbWFjLCBz
dHJ1Y3QgbDJ0YWJsZV9ub2RlLCBHRlBfS0VSTkVMKTsNCiAJaWYgKCFsMmFkZHIpIHsNCi0JCWZy
ZWVfbDJ0YWJsZV9pbmRleChtcGZzLCBpbmRleCk7DQogCQllcnIgPSAtRU5PTUVNOw0KLQkJZ290
byBhYm9ydDsNCisJCWdvdG8gaGFzaF9hZGRfZXJyOw0KIAl9DQogDQotCWwyYWRkci0+aW5kZXgg
PSBpbmRleDsNCiAJZXJyID0gc2V0X2wydGFibGVfZW50cnlfY21kKGRldiwgaW5kZXgsIG1hYyk7
DQotCWlmIChlcnIpIHsNCi0JCWwyYWRkcl9oYXNoX2RlbChsMmFkZHIpOw0KLQkJZnJlZV9sMnRh
YmxlX2luZGV4KG1wZnMsIGluZGV4KTsNCi0JfQ0KKwlpZiAoZXJyKQ0KKwkJZ290byBzZXRfdGFi
bGVfZW50cnlfZXJyOw0KKw0KKwlsMmFkZHItPmluZGV4ID0gaW5kZXg7DQogDQogCW1seDVfY29y
ZV9kYmcoZGV2LCAiTVBGUyBtYWMgYWRkZWQgJXBNLCBpbmRleCAoJWQpXG4iLCBtYWMsIGluZGV4
KTsNCi1hYm9ydDoNCisJZ290byBvdXQ7DQorDQorc2V0X3RhYmxlX2VudHJ5X2VycjoNCisJbDJh
ZGRyX2hhc2hfZGVsKGwyYWRkcik7DQoraGFzaF9hZGRfZXJyOg0KKwlmcmVlX2wydGFibGVfaW5k
ZXgobXBmcywgaW5kZXgpOw0KK291dDoNCiAJbXV0ZXhfdW5sb2NrKCZtcGZzLT5sb2NrKTsNCiAJ
cmV0dXJuIGVycjsNCiB9DQotLSANCjIuMjEuMA0KDQo=
