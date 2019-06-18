Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 466584A00F
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729038AbfFRMBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:01:01 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:20207
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728991AbfFRMBA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:01:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Be5Z26DLu8VjthGUK0YN3emGoe6WQ9tAAO3Uk6YtSz0=;
 b=bHdazBugHEuY8GJ2QxPaHeWHmtZ+vRXFTJLitsIqNwGABsh2SrhLrzj+q1OnHg3VJQ764TOEZpSzvomrwRaNAQ4iEPfPzlwznZul8KYfCGKjldFruAukllKymNHrGjBrz1u0F242dVsNsURjhFV93cc2GZFE2Vl248cz334zHag=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5333.eurprd05.prod.outlook.com (20.177.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 18 Jun 2019 12:00:53 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:53 +0000
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
Subject: [PATCH bpf-next v5 07/16] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Topic: [PATCH bpf-next v5 07/16] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Index: AQHVJc16Yk6KLgIOqUilxfzHG0QuzQ==
Date:   Tue, 18 Jun 2019 12:00:53 +0000
Message-ID: <20190618120024.16788-8-maximmi@mellanox.com>
References: <20190618120024.16788-1-maximmi@mellanox.com>
In-Reply-To: <20190618120024.16788-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0064.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::28) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1a9bfcfe-0b59-4fab-50ad-08d6f3e49cde
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5333;
x-ms-traffictypediagnostic: AM6PR05MB5333:
x-microsoft-antispam-prvs: <AM6PR05MB533308193687BDD195B09B55D1EA0@AM6PR05MB5333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(305945005)(66556008)(476003)(11346002)(66476007)(386003)(68736007)(478600001)(2616005)(66066001)(66946007)(73956011)(86362001)(6436002)(66446008)(25786009)(26005)(81156014)(6486002)(64756008)(446003)(6506007)(4326008)(316002)(81166006)(8676002)(102836004)(8936002)(54906003)(486006)(186003)(110136005)(6512007)(7416002)(53936002)(71200400001)(50226002)(76176011)(71190400001)(14444005)(52116002)(36756003)(256004)(4744005)(14454004)(107886003)(6116002)(1076003)(3846002)(5660300002)(7736002)(99286004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5333;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kYFdaTsmkNIsgCecdIOKhnFa9kI++zzCBR01wuYuQRjXRTuaiIn8zlaUtFIbd9bdGeIalLdOs1bwlU+ZA1fpV7Q9LJ+d4++5aH+Gz9SkWxuDZLO4LuZGjV6svrRvYGJpzSKKRmRAGwxn+2p6K4W+S7DCfCPUu0ptIGUSIdF2KUraVpgmmarDiS3a8OpgFqM3WtRROiwF+4oHClu8/OwaWBF9Iznm5nk/cDTkgF7w76xjpjoX6LAkB9od4obGmHCROI3w+UTClAXrA06cP2se6pVO1LNo0qTfjyo9cCeaka4+Y8BwnIPWkwPPZI3TqtgTWw5orT2H0LI+BKi86RRlU3AFG5Q6iaQNgKMMGwvXS9Ou8neo9c2YW7OLVkTtfB86ufUEnLxu2GZbGnUNxmauUz2OEfyYnrybweFk033u8Y0=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a9bfcfe-0b59-4fab-50ad-08d6f3e49cde
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:53.2520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5333
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
