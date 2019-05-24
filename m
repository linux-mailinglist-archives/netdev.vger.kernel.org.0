Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAED9294C1
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 11:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390203AbfEXJfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 05:35:39 -0400
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:45477
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389869AbfEXJfj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 05:35:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Be5Z26DLu8VjthGUK0YN3emGoe6WQ9tAAO3Uk6YtSz0=;
 b=oaVv+gDFIe9K/HXvxjBUaTZU1jnNINLctSGI78QlNliewBomjWFjQbbH2QGkhl7IFI0kuAD962F8+dAZ8BmXNldaSqRzlsaCua3yhMU1wPgT7MNOxvVozRI4TO8wbUC3tdL4WZsMbflXDcB0h6OKB5kZKQMbQvgbi751tWzkcCw=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB4294.eurprd05.prod.outlook.com (52.135.160.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Fri, 24 May 2019 09:35:25 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::3cb0:9252:d790:51e2%7]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 09:35:25 +0000
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
Subject: [PATCH bpf-next v3 07/16] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Topic: [PATCH bpf-next v3 07/16] net/mlx5e: Replace deprecated
 PCI_DMA_TODEVICE
Thread-Index: AQHVEhQEBqt5BrlWt0ewK6DPcfoGCQ==
Date:   Fri, 24 May 2019 09:35:25 +0000
Message-ID: <20190524093431.20887-8-maximmi@mellanox.com>
References: <20190524093431.20887-1-maximmi@mellanox.com>
In-Reply-To: <20190524093431.20887-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0126.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::18) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2646838-9383-4d10-79f9-08d6e02b2620
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4294;
x-ms-traffictypediagnostic: AM6PR05MB4294:
x-microsoft-antispam-prvs: <AM6PR05MB429455B22701C262868FDC17D1020@AM6PR05MB4294.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(396003)(366004)(346002)(376002)(199004)(189003)(66476007)(99286004)(478600001)(76176011)(66556008)(66946007)(14454004)(68736007)(6506007)(64756008)(386003)(66446008)(36756003)(316002)(54906003)(110136005)(73956011)(4744005)(107886003)(26005)(486006)(71200400001)(71190400001)(52116002)(11346002)(446003)(186003)(305945005)(7736002)(2616005)(2906002)(476003)(6436002)(5660300002)(53936002)(50226002)(7416002)(8676002)(102836004)(1076003)(8936002)(256004)(66066001)(86362001)(25786009)(6486002)(6512007)(4326008)(81166006)(3846002)(6116002)(81156014)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4294;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j0mKru92PodhNJ9DIDNoY7k5g1T/xoE5vdV6SfL1kOgdHu393kp3qZQ+NHOqnA+ah9t0tAiGm0KIK7MZnrpqNnSTuCAtzw/exINe3vCpV8GSG+Ns6N4rkHUrQg+pT1CV9R+LY6eIK45EIEZdWfYYENhtMXgR32O0eC0w1K4DOo5wVQff6tmY+/vDOtLJ+f0z4sujIcjrD7KKLp2uR5CEYUpQGStGkObxVHEDHvXFhD+Hp+sZO8ZM9qHesD4MVnXI+j8YFDPBlo6Z3WAvj/djVmYcbT842IkHF0J4KVPbU5smTMM4MWIPgKYOCECf1tiLA9jqavuUyiZ8UUxUpjcOjSJgj65DE0ydzARrqs06lICrLmEiP2QoUCCzIg2Z6/C2Db4KJQCOlmguvkdoV3cqo3uS5jkbigjnKCX8OIFc5dA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2646838-9383-4d10-79f9-08d6e02b2620
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 09:35:25.4357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4294
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
