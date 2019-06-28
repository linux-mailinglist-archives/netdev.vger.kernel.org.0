Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 777425A77B
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfF1XSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:18:46 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28738
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbfF1XSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:18:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=TBHUmtl0qM0oUbGLki9fu0pt5F7hSJ71lAnZODjDg7rj5RsrhqibcKPbweVP/2OjR4TKxfhAftFjyfoMS/0RI00nGRL6DSOQAVbSWxqPjRapSA0q6toYZeUoaJE0nHQZIZuKNus9L9byqIIOcX2MPhT+RU9ETfBDPwP1Md4ROrY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHhYFs6NH6KIaNTZo72gxwuxUywOQ0viLI7zMXicpvg=;
 b=rpBtYsf2zI7oNWhfWmAY7ulYLlk9X/lvdPakbuGGG45qFQM3Akff+Bk1DZUEt/xLJunPL6ZDGm0Qdcub8yOGcTf6unvI7mhJapHbnEl0OIgpcIRnQQzdzM+evgAixsjuI/P4unz/V5g8U+Fc2FaHEBPZ3N4dLWYfiCdNE1UX3lI=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dHhYFs6NH6KIaNTZo72gxwuxUywOQ0viLI7zMXicpvg=;
 b=UTDdFI5/tH0dOsNFs/SVqyJBs3n/0eLohLHJt3BM1DdcVhfyeLmHcjrORrWKPW8EVwyouM0Kdlh8Rrm4rfvXuZIZMJ1wPjUtQX4WuE7SPWc1XnAMiTbT872p3MHcmOXy09Ugymovj2H1dnKKjy+tcsnaL4wtXV6YpKZPXoCjSfk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:28 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 06/10] net/mlx5e: Set drvinfo in generic manner
Thread-Topic: [net-next 06/10] net/mlx5e: Set drvinfo in generic manner
Thread-Index: AQHVLgfL7ICqWvEDz0ebseRK70/gDQ==
Date:   Fri, 28 Jun 2019 23:18:28 +0000
Message-ID: <20190628231759.16374-7-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 6ea7598c-f5bd-4a14-01ee-08d6fc1eed45
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB219843871DAF0DE06903E091BEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:854;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(14444005)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(4744005)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3R/EFquKq8FI+mHOETZ4xwyZJF6CdUcfocOJFmCJ2vNF8ZjgyLmVie7pZfGUE3lsXfKAOTG+vkVJruCvkush55WSEQht2RckhPRMpFsNxmo61wQe+ErEiXHAlLCJ5OQTHBhVLAlV1/h5T55NSj9F/D8U2lh/xm7kssCtx6pr/jbzjReXMNMef3K3Q/huOa/sLbffoYrqwkaTwNAGe1k40NjIfYHhw/1mtpFxOTnbsfvOxlOWVCMCIJfMhcEQXM7EF7xprqH0d1r/bKQiEYN01yfvoIe+7ZuseJid2uC2fZuMtdo9EtUMyIx7PfiI26RKpeb7jdcsTbJgZpQK9qXl/FC689vf6V+pBhgDlrnAjxEMyiwk7eJbp8o7fves4PeK4SVtALd0b9akDHpiOozMDJBs/T9ghQUGaJsynpHGlnE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ea7598c-f5bd-4a14-01ee-08d6fc1eed45
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:28.4859
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

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCkNvbnNpZGVyIFBDSSBh
bmQgbm9uIFBDSSBkZXZpY2UgdHlwZXMgd2hpbGUgc2V0dGluZyBkZXZpY2UgbmFtZQ0KaW4gZ2V0
X2RydmluZm8oKSBjYWxsYmFjayB1c2luZyBleGlzdGluZyBnZW5lcmljIGRldmljZS4NCg0KU2ln
bmVkLW9mZi1ieTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1i
eTogVnUgUGhhbSA8dnVodW9uZ0BtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5OiBTYWVlZCBN
YWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbl9ldGh0b29sLmMgfCAyICstDQogMSBmaWxlIGNoYW5nZWQs
IDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jIGIvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX2V0aHRvb2wuYw0KaW5kZXggMDVmMDczMzFh
YjQxLi4xOThhNTJkMWU1MTUgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxs
YW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9t
ZWxsYW5veC9tbHg1L2NvcmUvZW5fZXRodG9vbC5jDQpAQCAtNDYsNyArNDYsNyBAQCB2b2lkIG1s
eDVlX2V0aHRvb2xfZ2V0X2RydmluZm8oc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQogCQkgIiVk
LiVkLiUwNGQgKCUuMTZzKSIsDQogCQkgZndfcmV2X21haihtZGV2KSwgZndfcmV2X21pbihtZGV2
KSwgZndfcmV2X3N1YihtZGV2KSwNCiAJCSBtZGV2LT5ib2FyZF9pZCk7DQotCXN0cmxjcHkoZHJ2
aW5mby0+YnVzX2luZm8sIHBjaV9uYW1lKG1kZXYtPnBkZXYpLA0KKwlzdHJsY3B5KGRydmluZm8t
PmJ1c19pbmZvLCBkZXZfbmFtZShtZGV2LT5kZXZpY2UpLA0KIAkJc2l6ZW9mKGRydmluZm8tPmJ1
c19pbmZvKSk7DQogfQ0KIA0KLS0gDQoyLjIxLjANCg0K
