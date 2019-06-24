Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6F751DE6
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 00:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfFXWFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 18:05:38 -0400
Received: from mail-eopbgr50049.outbound.protection.outlook.com ([40.107.5.49]:32558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbfFXWFh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 18:05:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LTf/8UwMCfjjlyUS+WYjF3OItICmBmQevAUqotBasc0=;
 b=USwXynNS4cZnyDZG61HzQFVANoNFMIi20CNWm4SIXqi1ToP1Foec8r7xdhE0EK8PRI61OYbXK1rmJp7b4M6dplP9aOGtltdtDq4AiWhe94DEqGPUsU8qDns88HkIXMMt9hJYxiGipIpHdFSQ4jencsgme+L6UM7ilP4/FXghVLU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2389.eurprd05.prod.outlook.com (10.168.71.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 22:05:34 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 22:05:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next] net/mlx5: Convert mkey_table to XArray
Thread-Topic: [PATCH mlx5-next] net/mlx5: Convert mkey_table to XArray
Thread-Index: AQHVJzZOrdAeQY5FHUKmEjqAi8wYYaarY3OA
Date:   Mon, 24 Jun 2019 22:05:33 +0000
Message-ID: <18138852207dfcd26ed512482af2c5ea9de93277.camel@mellanox.com>
References: <20190620070305.31632-1-saeedm@mellanox.com>
In-Reply-To: <20190620070305.31632-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e8a4d932-119c-4377-58e7-08d6f8f014a8
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2389;
x-ms-traffictypediagnostic: DB6PR0501MB2389:
x-microsoft-antispam-prvs: <DB6PR0501MB2389B21885ABAF716786CBF7BEE00@DB6PR0501MB2389.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(376002)(366004)(396003)(346002)(199004)(189003)(71190400001)(6862004)(14444005)(66476007)(256004)(91956017)(81156014)(66556008)(73956011)(6506007)(6486002)(4326008)(81166006)(76116006)(446003)(66946007)(11346002)(71200400001)(64756008)(14454004)(66446008)(25786009)(5660300002)(478600001)(6436002)(8936002)(58126008)(37006003)(54906003)(6246003)(486006)(8676002)(66066001)(2616005)(36756003)(476003)(316002)(229853002)(7736002)(68736007)(102836004)(186003)(3846002)(305945005)(86362001)(26005)(6116002)(6512007)(76176011)(6636002)(53936002)(4744005)(2906002)(118296001)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2389;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ba+vQaUTkTZztNhP84GEgqHg2bPPGG7AEHg0YqQyAKmJnO5gyXdmm+VkVKZOtQ1XR+AYGMMVsh/nhe5PTTocH+oOYn9uiZ3avtd5rgAcZIidn7Mn40ubgUMoEm3xCJUjdlMlvQFyPposT2DgrYbMTwquflVh4GKD1y4YYOV64yAPc8aOPIX0UBjzpj94BJR7+PLXZqzl4VofrEo68GXnzEZ0wxTKHPUCE8kW6Df/Y5Ak5ZwcXqjU3d6q5qdHct4hhDFeS/tWTKNlBUlUds+MAXDjv6+2ew9sycVUTxuxIEmuvMm9E1JYr5YEzYWoVGnCht45Rg7bQJmoCtsVYHz15hkokzAEFu6v5yQaUxJyT5DAjrMPRwoRzV06YTiWEfuZslbiKIA1AQLGTRH49LrTEOPO0n/e1up576NuXqgrO9I=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0FCFA3E0244E5A4E9DA00271DA13B946@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a4d932-119c-4377-58e7-08d6f8f014a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 22:05:34.0939
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2389
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA2LTIwIGF0IDA3OjAzICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gRnJvbTogTWF0dGhldyBXaWxjb3ggPHdpbGx5QGluZnJhZGVhZC5vcmc+DQo+IA0KPiBUaGUg
bG9jayBwcm90ZWN0aW5nIHRoZSBkYXRhIHN0cnVjdHVyZSBkb2VzIG5vdCBuZWVkIHRvIGJlIGFu
DQo+IHJ3bG9jay4gIFRoZQ0KPiBvbmx5IHJlYWQgYWNjZXNzIHRvIHRoZSBsb2NrIGlzIGluIGFu
IGVycm9yIHBhdGgsIGFuZCBpZiB0aGF0J3MNCj4gbGltaXRpbmcNCj4geW91ciBzY2FsYWJpbGl0
eSwgeW91IGhhdmUgYmlnZ2VyIHBlcmZvcm1hbmNlIHByb2JsZW1zLg0KPiANCj4gRWxpbWluYXRl
IG1seDVfbWtleV90YWJsZSBpbiBmYXZvdXIgb2YgdXNpbmcgdGhlIHhhcnJheSBkaXJlY3RseS4N
Cj4gcmVnX21yX2NhbGxiYWNrIG11c3QgdXNlIEdGUF9BVE9NSUMgZm9yIGFsbG9jYXRpbmcgWEFy
cmF5IG5vZGVzIGFzIGl0DQo+IG1heQ0KPiBiZSBjYWxsZWQgaW4gaW50ZXJydXB0IGNvbnRleHQu
DQo+IA0KPiBUaGlzIGFsc28gZml4ZXMgYSBtaW5vciBidWcgd2hlcmUgU1JDVSBsb2NraW5nIHdh
cyBiZWluZyB1c2VkIG9uIHRoZQ0KPiByYWRpeA0KPiB0cmVlIHJlYWQgc2lkZSwgd2hlbiBSQ1Ug
d2FzIG5lZWRlZCB0b28uDQo+IA0KPiBDaGFuZ2UtSWQ6IElmZWVkYmJjOGYyYzg1NmNjMDQ0MDk0
ZDAzMTY3YWFlOWY5MTYyNDAwDQo+IFNpZ25lZC1vZmYtYnk6IE1hdHRoZXcgV2lsY294IDx3aWxs
eUBpbmZyYWRlYWQub3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYXNvbiBHdW50aG9ycGUgPGpnZ0Bt
ZWxsYW5veC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVs
bGFub3guY29tPg0KPiAgDQoNCkFwcGxpZWQgdG8gbWx4NS1uZXh0Lg0KDQpUaGFua3MsDQpTYWVl
ZC4NCg==
