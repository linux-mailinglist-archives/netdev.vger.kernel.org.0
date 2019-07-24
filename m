Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52B3F7407C
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 22:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728591AbfGXU4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 16:56:14 -0400
Received: from mail-eopbgr10058.outbound.protection.outlook.com ([40.107.1.58]:39394
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726591AbfGXU4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 16:56:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGXahjZwLifzS9PwkbbzPwdIbkRn5Eadi+eldqnxyzYJz1ncRj7d1uK6YtvzqHN3wkyYMfmXRCJZa/1gW475rVS/XNcJ3X133AcpISTlp8GzszDkPIlb+XQnSUeBlOx9RhlNW4WX20tFSz9KLF15n/2SHB6kmLlQBGHgQxD9+h5NqVioIY4al1B7a4kWNX5nnO3L3v5WDpAJ6gaGjjkoJbljhF8GpEKNwTvCTI6z7FFoUahU888rJspl2a9F9sFuTwCA8emxmW1vprUPi31NS99mDISv8MDHqIto7BYZn+wrVA3ZDGhNesG9NMP7D0yjKtVUzHbrNGmfnDfJ2HKc/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa1YCqDyyVP/idyVQzW6i+QWoNEtlyB1Kv7GKn6g170=;
 b=gCmTJ7/DWhTp9SZ7fQIv+/GbbGHtXnM4IKim/RvId12yBv5bEjnlqeTjoCurUCt1R9KZL6pfOlHnXQNMs+ZE+7jot7Tj9ADv5+Me/iY3PkBzswqfcGxmSnu6pe4heGxMNUGIP0l4QFeUXk8FkB5E0CuXEAo9VpLwyAcecup2OL6I/lR8BbsRyUpcKGWYZT1Ks4NIa+GJfNX2IslxfRVp/td2sg6g4xZ3AycdCqekcsj3DZCLkPNHjp07IJB7A6RAT3IJYYJMBD7xtxN1dXcj077Bg0w5L4qZlhaDEB6+cWu06B/PZAB8+e0M+NUuk96LPM89CpJRBnaDTwXnxkoKFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa1YCqDyyVP/idyVQzW6i+QWoNEtlyB1Kv7GKn6g170=;
 b=KVbkqzgnzZtiR5NU6OQrC1iYz0MmzTxclkSSBORuT/UMlHTqrR8PcyQ1ASOsN2Ga2SYV6FgTUp1K/ttAiNb9Ph0gpIOZVD4Il94VPlYR5fNvDP8BdL0aq84cu2422Kuy5/7qtgpGCYpXXlAqxMYPk4+ODAppwXbRXGWrco8A6MA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Wed, 24 Jul 2019 20:56:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 20:56:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Edward Srouji <edwards@mellanox.com>
Subject: Re: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
Thread-Topic: [PATCH mlx5-next] net/mlx5: Fix modify_cq_in alignment
Thread-Index: AQHVQSYU/XFyboT9FUmZvXfwV+sFwqbYhqUAgAAJ5ACAAbGXAA==
Date:   Wed, 24 Jul 2019 20:56:08 +0000
Message-ID: <5447fded90dfd133ef002177b77bfd3685bf8b42.camel@mellanox.com>
References: <20190723071255.6588-1-leon@kernel.org>
         <20190723.112850.610952032088764951.davem@davemloft.net>
         <20190723190414.GU5125@mtr-leonro.mtl.com>
In-Reply-To: <20190723190414.GU5125@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae9d2210-96b3-49f3-f81b-08d710795a53
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB2198C8FA9A6B24C90DEFA70BBEC60@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(189003)(199004)(54906003)(446003)(66556008)(66946007)(64756008)(99286004)(476003)(186003)(6512007)(6246003)(81156014)(66476007)(11346002)(7736002)(71190400001)(76116006)(66446008)(58126008)(102836004)(110136005)(8676002)(2906002)(305945005)(2616005)(91956017)(14444005)(6436002)(86362001)(71200400001)(6506007)(68736007)(229853002)(478600001)(486006)(26005)(118296001)(76176011)(4744005)(4326008)(2501003)(36756003)(256004)(81166006)(66066001)(107886003)(8936002)(53936002)(6486002)(3846002)(25786009)(14454004)(6116002)(316002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3PFAr/htBSAiHfi322/UCFhBxEramg3aoYg/uSgD9JX/TxVhsqcu1i5tEsfzS7NNclCyzY60pZh9NKOAWsuRIyPlXu+q28apXyPXXe3/n2W0DiNzuDDaBybDqApCIVVx0ntJJKo6o3eFqMLLBUHjV6CJAaqOudbSkbjwWxH61SjF7EaQI2xGz6V5Ui81dpoVnLVRyRmieCs4UeEaMPYR+/qg5wx8nVSI5wjCr7fm1G/sPnjBnYpKEGLcJ9l4fO82Kw9ZOktJkIoZE2z2uB3XVl3QUGbepHv4LIXUvTUg0nxYChr8lU17W47PdlY7+H3Nof+Yafq7/e4U8NdXVKQBR6DD8lq5FM5b6DUYDQZjgd1AOgQIAnJSM4myreaKPjHyh3uVKYWCtpxIT/96kEQ86VD82/hzA4q6bu/UuxHue1c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9C5D278A1746B744BB8F68AFC7B1EA55@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae9d2210-96b3-49f3-f81b-08d710795a53
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 20:56:08.7254
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

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDIyOjA0ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgSnVsIDIzLCAyMDE5IGF0IDExOjI4OjUwQU0gLTA3MDAsIERhdmlkIE1pbGxl
ciB3cm90ZToNCj4gPiBGcm9tOiBMZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4NCj4g
PiBEYXRlOiBUdWUsIDIzIEp1bCAyMDE5IDEwOjEyOjU1ICswMzAwDQo+ID4gDQo+ID4gPiBGcm9t
OiBFZHdhcmQgU3JvdWppIDxlZHdhcmRzQG1lbGxhbm94LmNvbT4NCj4gPiA+IA0KPiA+ID4gRml4
IG1vZGlmeV9jcV9pbiBhbGlnbm1lbnQgdG8gbWF0Y2ggdGhlIGRldmljZSBzcGVjaWZpY2F0aW9u
Lg0KPiA+ID4gQWZ0ZXIgdGhpcyBmaXggdGhlICdjcV91bWVtX3ZhbGlkJyBmaWVsZCB3aWxsIGJl
IGluIHRoZSByaWdodA0KPiA+ID4gb2Zmc2V0Lg0KPiA+ID4gDQo+ID4gPiBDYzogPHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmc+ICMgNC4xOQ0KPiA+ID4gRml4ZXM6IGJkMzcxOTc1NTRlYiAoIm5ldC9t
bHg1OiBVcGRhdGUgbWx4NV9pZmMgd2l0aCBERVZYIFVJRA0KPiA+ID4gYml0cyIpDQoNCkxlb24s
IEkgYXBwbGllZCB0aGlzIHBhdGNoIHRvIG15IHRyZWUsIGl0IGdvdCBtYXJrZWQgZm9yIC1zdGFi
bGUgNC4yMA0KYW5kIG5vdCA0LjE5LCBpIGNoZWNrZWQgbWFudWFsbHkgYW5kIGluZGVlZCB0aGUg
b2ZmZW5kaW5nIHBhdGNoIGNhbWUgdG8NCmxpZ2h0IG9ubHkgb24gNC4yMA0KDQo=
