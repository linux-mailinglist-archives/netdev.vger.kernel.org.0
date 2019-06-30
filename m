Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 245A35AFC5
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 14:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfF3MPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 08:15:39 -0400
Received: from mail-eopbgr130052.outbound.protection.outlook.com ([40.107.13.52]:50343
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726500AbfF3MPi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 Jun 2019 08:15:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=HdDaAP+xLXJdfzMN8xPVcsuw0C8xYMqiWgKB8Z7Jmd6WJurJcz4mpzD+JqMrtvaL4NA/SH1xbWujL5o5pcK6x9bRlxaRv5BmNR3olUd0wkuPZ5DwBr/+ApsPZopflpYBO0PdI7MBv9Lb0gED4SpLBwvxoJ/Atal5E5KZo0+cakY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVS88SgAJ4ocq1C2O8OIysK44DwPZuma/KpUDFHGLuw=;
 b=HynzijjOuLF9esJbxCnI/wZ348r26MsfJT27LzVMGLnHT543as+Frx9818VGXvjg7AMrwQKrG/l4kByl7IttDVUEiggft7xNb/lFN6dja5KoXrrF9SO65smUDdnBzByRCXnMQtvMNS1wQCy9BaK91tyR7RjhlSYcyYiZuYCXNFQ=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVS88SgAJ4ocq1C2O8OIysK44DwPZuma/KpUDFHGLuw=;
 b=czg6FxbkP9MsnnMehZy82q1Yz9U+ZQliUwSBomVpRM78msDymmiqbxQQlrEX/x2XQMrU4Bv/tQBBD1H6dTPcAnFV91WjvFNPI959atwknAOU38CFVia96tPdAo4ONbNKSc44ahrH1w4K+K9FClNzDZBGF+IYAwzFSzSCyUC5O0E=
Received: from AM0PR05MB6274.eurprd05.prod.outlook.com (20.179.32.142) by
 AM0PR05MB4611.eurprd05.prod.outlook.com (52.133.52.139) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Sun, 30 Jun 2019 12:15:33 +0000
Received: from AM0PR05MB6274.eurprd05.prod.outlook.com
 ([fe80::1cc3:1163:6c88:384d]) by AM0PR05MB6274.eurprd05.prod.outlook.com
 ([fe80::1cc3:1163:6c88:384d%5]) with mapi id 15.20.2032.019; Sun, 30 Jun 2019
 12:15:33 +0000
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Fuqian Huang <huangfq.daxian@gmail.com>
CC:     Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 87/87] ethernet: mlx4: remove memset after
 dma_alloc_coherent
Thread-Topic: [PATCH 87/87] ethernet: mlx4: remove memset after
 dma_alloc_coherent
Thread-Index: AQHVLQ+3aFt6rVFhoU2ojZzw+pONgKa0IOAA
Date:   Sun, 30 Jun 2019 12:15:33 +0000
Message-ID: <4645429b-1429-34bb-e181-74c461ace04a@mellanox.com>
References: <20190627174227.4726-1-huangfq.daxian@gmail.com>
In-Reply-To: <20190627174227.4726-1-huangfq.daxian@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0021.eurprd09.prod.outlook.com
 (2603:10a6:101:16::33) To AM0PR05MB6274.eurprd05.prod.outlook.com
 (2603:10a6:208:139::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tariqt@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49f379de-d3bc-458b-22e8-08d6fd54a65b
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4611;
x-ms-traffictypediagnostic: AM0PR05MB4611:
x-microsoft-antispam-prvs: <AM0PR05MB4611CAD22559F1D4AC925FBEAEFE0@AM0PR05MB4611.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:144;
x-forefront-prvs: 008421A8FF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(189003)(199004)(76176011)(26005)(6916009)(446003)(11346002)(66476007)(36756003)(486006)(102836004)(86362001)(31696002)(229853002)(7736002)(66446008)(2616005)(4744005)(4326008)(476003)(81156014)(305945005)(71190400001)(99286004)(53936002)(53546011)(186003)(68736007)(386003)(71200400001)(52116002)(6506007)(6246003)(6512007)(316002)(2906002)(8936002)(6116002)(66066001)(54906003)(5660300002)(478600001)(31686004)(66946007)(3846002)(256004)(6486002)(8676002)(73956011)(64756008)(66556008)(81166006)(14454004)(25786009)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4611;H:AM0PR05MB6274.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8lKdloF625MSICiE7e5fa+VyTyizTklz4hji0A2W7Izy+7EgvtW5pNSDAJTTumDC5d8GxmQz4/3T/nqWwxPyLCRQKuxXOHKZ9t76JYg/cgLDZVglkbRVOhQQFsYSgHoAunyVNYeSlfd74KlWwaN9HLRIB90NexBb1bjlAe7+6fdo1/j97480SPWkKhZOFctb732RgsJWeDZVTT2QR8pfm2dFdETdWgIBKmbvNxuyjLixlmI90a+FkpVnARUuZ6eyn49Kx3OzCXT7lfru1qDbMaDL/8gy2SOIlNNPtO+3DcyG6LBVVLhYlvjTTZPjiyAAm64L80SXaQERC3wZqh5lTNhhfhZGEBz/YwSoarI9vS3J2az9Szye3kwycj2QE/6HsxPkJ57MZICaIbD3o49R3TAhaWTsWFgzL56SJKUkRDc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A51E0748EDA4C240AF843394D503CD31@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49f379de-d3bc-458b-22e8-08d6fd54a65b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2019 12:15:33.3242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tariqt@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4611
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDYvMjcvMjAxOSA4OjQyIFBNLCBGdXFpYW4gSHVhbmcgd3JvdGU6DQo+IEluIGNvbW1p
dCBhZjdkZGQ4YTYyN2MNCj4gKCJNZXJnZSB0YWcgJ2RtYS1tYXBwaW5nLTQuMjEnIG9mIGdpdDov
L2dpdC5pbmZyYWRlYWQub3JnL3VzZXJzL2hjaC9kbWEtbWFwcGluZyIpLA0KPiBkbWFfYWxsb2Nf
Y29oZXJlbnQgaGFzIGFscmVhZHkgemVyb2VkIHRoZSBtZW1vcnkuDQo+IFNvIG1lbXNldCBpcyBu
b3QgbmVlZGVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogRnVxaWFuIEh1YW5nIDxodWFuZ2ZxLmRh
eGlhbkBnbWFpbC5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDQvZXEuYyB8IDIgLS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgMiBkZWxldGlvbnMoLSkNCj4g
DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VxLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg0L2VxLmMNCj4gaW5kZXggYTViZTI3
NzcyYjhlLi5jNzkwYTVmY2VhNzMgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDQvZXEuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg0L2VxLmMNCj4gQEAgLTEwMTMsOCArMTAxMyw2IEBAIHN0YXRpYyBpbnQgbWx4NF9jcmVh
dGVfZXEoc3RydWN0IG1seDRfZGV2ICpkZXYsIGludCBuZW50LA0KPiAgIA0KPiAgIAkJZG1hX2xp
c3RbaV0gPSB0Ow0KPiAgIAkJZXEtPnBhZ2VfbGlzdFtpXS5tYXAgPSB0Ow0KPiAtDQo+IC0JCW1l
bXNldChlcS0+cGFnZV9saXN0W2ldLmJ1ZiwgMCwgUEFHRV9TSVpFKTsNCj4gICAJfQ0KPiAgIA0K
PiAgIAllcS0+ZXFuID0gbWx4NF9iaXRtYXBfYWxsb2MoJnByaXYtPmVxX3RhYmxlLmJpdG1hcCk7
DQo+IA0KDQpSZXZpZXdlZC1ieTogVGFyaXEgVG91a2FuIDx0YXJpcXRAbWVsbGFub3guY29tPg0K
DQpUaGFua3MuDQo=
