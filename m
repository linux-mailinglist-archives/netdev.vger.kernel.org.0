Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C3842B62
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 17:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731837AbfFLP5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 11:57:00 -0400
Received: from mail-eopbgr20081.outbound.protection.outlook.com ([40.107.2.81]:31558
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730580AbfFLP47 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 11:56:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Be5Z26DLu8VjthGUK0YN3emGoe6WQ9tAAO3Uk6YtSz0=;
 b=TIl+xBjIzSWU0L8BWnlF5q4a9bqxSC2ELvwkwHOla+lFb4nS9zmO7CnOqOzG+ikAmlRE/BuJei0mjRCQXlEsCwqMz1Ev5RyoAwah0YJUb71KnvHWFVsmfqYEPDG77l8VrhM9FLJwxxjDq6EFUOCzVPql24OCODQkTSmUEqMQi50=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5240.eurprd05.prod.outlook.com (20.177.196.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.10; Wed, 12 Jun 2019 15:56:50 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.010; Wed, 12 Jun 2019
 15:56:50 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v4 08/17] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Topic: [PATCH bpf-next v4 08/17] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Index: AQHVITdyXTZeU0qV00G/wIrCvnqMKQ==
Date:   Wed, 12 Jun 2019 15:56:50 +0000
Message-ID: <20190612155605.22450-9-maximmi@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
In-Reply-To: <20190612155605.22450-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::31) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce69f872-81a1-4660-0509-08d6ef4e9494
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5240;
x-ms-traffictypediagnostic: AM6PR05MB5240:
x-microsoft-antispam-prvs: <AM6PR05MB5240DBDA0CEEC6E930B33653D1EC0@AM6PR05MB5240.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0066D63CE6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(136003)(39860400002)(396003)(346002)(189003)(199004)(486006)(8936002)(6486002)(446003)(8676002)(81166006)(81156014)(4744005)(2906002)(6436002)(36756003)(26005)(11346002)(2616005)(476003)(50226002)(66066001)(102836004)(14454004)(186003)(107886003)(110136005)(54906003)(71190400001)(71200400001)(478600001)(316002)(25786009)(4326008)(1076003)(7736002)(305945005)(6512007)(66476007)(66946007)(66556008)(64756008)(66446008)(73956011)(68736007)(256004)(99286004)(7416002)(6116002)(386003)(14444005)(3846002)(6506007)(86362001)(53936002)(76176011)(5660300002)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5240;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TXboSXakUAsUptg+WTAH2sC2GJk2X4qHq65t7HUseGg19RZcGR0eU6a77Vdeim1rW6r4IDVArE9biMySbtAI2K6ciqiahDtMu5WottBwPaJgBXrw6rzCE4Z+z/wS6umSF0yjQ4Gx6LAHBrRIcWgPKQpdV5iJlEv/g7vdGUIq17zpOAtW1NlOpVBhwYrpKIm1uu/ymJ8rwlpOr13or5DqmNY+6loXZt+VZxG/tHbi2LEUzCBSsLvtIakBQWXm6+j4ekpFAfscs9mxg1XWg2w2TVqnGyNTdFRjRAt3/K7S8WhK6ggi1+nMbGTtDm9zxWFvPezOw4uDaom94yJH+B49U7+x88ytZHO/R34pVH+/S8XMkMZtyVnbTnD+santBseomPQ9dR0lkSsrS5FR0EMNHPhWYu4PreeXUIOw0cuuei0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce69f872-81a1-4660-0509-08d6ef4e9494
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2019 15:56:50.2198
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5240
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhlIFBDSSBBUEkgZm9yIERNQSBpcyBkZXByZWNhdGVkLCBhbmQgUENJX0RNQV9UT0RFVklDRSBp
cyBqdXN0IGRlZmluZWQNCnRvIERNQV9UT19ERVZJQ0UgZm9yIGJhY2t3YXJkIGNvbXBhdGliaWxp
dHkuIEp1c3QgdXNlIERNQV9UT19ERVZJQ0UuDQoNClNpZ25lZC1vZmYtYnk6IE1heGltIE1pa2l0
eWFuc2tpeSA8bWF4aW1taUBtZWxsYW5veC5jb20+DQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2Fu
IDx0YXJpcXRAbWVsbGFub3guY29tPg0KQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1A
bWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hkcC5jIHwgMiArLQ0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2VuL3hkcC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9j
b3JlL2VuL3hkcC5jDQppbmRleCBlYjhlZjc4ZTU2MjYuLjVhOTAwYjcwYjIwMyAxMDA2NDQNCi0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94ZHAuYw0KKysr
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jDQpAQCAt
NjQsNyArNjQsNyBAQCBtbHg1ZV94bWl0X3hkcF9idWZmKHN0cnVjdCBtbHg1ZV94ZHBzcSAqc3Es
IHN0cnVjdCBtbHg1ZV9kbWFfaW5mbyAqZGksDQogCQlyZXR1cm4gZmFsc2U7DQogCXhkcGkuZG1h
X2FkZHIgPSBkaS0+YWRkciArICh4ZHBpLnhkcGYtPmRhdGEgLSAodm9pZCAqKXhkcGkueGRwZik7
DQogCWRtYV9zeW5jX3NpbmdsZV9mb3JfZGV2aWNlKHNxLT5wZGV2LCB4ZHBpLmRtYV9hZGRyLA0K
LQkJCQkgICB4ZHBpLnhkcGYtPmxlbiwgUENJX0RNQV9UT0RFVklDRSk7DQorCQkJCSAgIHhkcGku
eGRwZi0+bGVuLCBETUFfVE9fREVWSUNFKTsNCiAJeGRwaS5kaSA9ICpkaTsNCiANCiAJcmV0dXJu
IHNxLT54bWl0X3hkcF9mcmFtZShzcSwgJnhkcGkpOw0KLS0gDQoyLjE5LjENCg0K
