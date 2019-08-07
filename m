Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06DD58529A
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 20:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389116AbfHGSDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 14:03:47 -0400
Received: from mail-eopbgr40070.outbound.protection.outlook.com ([40.107.4.70]:50595
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388615AbfHGSDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Aug 2019 14:03:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aS1PwG88N8RoB1Xq4Zvr7xywoouYcdJJPjXjv1ypPj+xP42vVQf+93nKJJXWq3n9NUki+YBBmin32LksKsyHSinShNx/hiW9C3MldniAMT1BF0sPPZzzEUTHKQx/c3RwNTvnhzmrhMJAZdPcpHJmRYnLbn15fGJKv+FzU/VqKB5uIlV3E6Go/SrwFA+TRAAPQh9Dusu+ZhfyudBWXTM5JhlnLOB7KKxZDxdNELZkAh2kZG7hW/DJzsCeJxFWiZ5nWJAEA+jGbbR6r06IaSe0yLpPQMOIHRW3ZbtjlbDz/RrM7eTlG3j/gtHM2PXUyzv40sgf4/gpBIg6IutLkyXapw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SI6nb2QZ1MqUqDT8AuAEVo37tXYGehTDI32GiVLgBhY=;
 b=TTkMBWIdS8+klmJsXtviP0aIyasMNMVaFgYLBC/TPS5GWxs3WNXW+rSKxLlbeTrgSZYSP3aCgCddprU1pHEeLi3RU+su2LG3S4MUjtB/VM9Hda2SFGw4HCI472QHi9qnQ50Yjt88MUX6G9K2zHELjapanvDviwrAAXPB0uLOR4PeQEcy9poQQO0XJYbJFnfL5Ovl/J3aHTncuLvcT5XwDeGVjhCD8HkqnJPBqyaB6qjlJwm2NCw8A77lr92YgG1UTDyIwpSzvRvX+iMVqfbSOi8qrpEH8eSwm5Vq9FmosS5axDn/xQqfzXWHVW+FbzNFy4XMLqqqa5swGy1SCEPG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SI6nb2QZ1MqUqDT8AuAEVo37tXYGehTDI32GiVLgBhY=;
 b=YaKWW1V2JMy4zyTeT3NcGwTdj4622Y6tZltg0qQE/yHiwiAjdyw7PfRZ3KRue3JSz7O9SfP7AYP0dJ8Ba+9bWBPhaDSZ/t7g0djO9oGhQIvNQhIRfWqPCpwccOiG445NPrDP1Sy6kDTpsqzx4XHAcxGmckY0abctbjajMlf6aXc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2520.eurprd05.prod.outlook.com (10.168.74.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 7 Aug 2019 18:03:43 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Wed, 7 Aug 2019
 18:03:43 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "leon@kernel.org" <leon@kernel.org>
CC:     "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hslester96@gmail.com" <hslester96@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] mlx5: Use refcount_t for refcount
Thread-Topic: [PATCH v3] mlx5: Use refcount_t for refcount
Thread-Index: AQHVS/qqPWmA6k0y9U2jqPKx2/PeLKbullCAgABu9oCAAPeogA==
Date:   Wed, 7 Aug 2019 18:03:43 +0000
Message-ID: <71b2d9688834a69d8db587dd01f92088fd9bf497.camel@mellanox.com>
References: <20190806015950.18167-1-hslester96@gmail.com>
         <cbea99e74a1f70b1a67357aaf2afdb55655cd2bd.camel@mellanox.com>
         <20190807031717.GB4832@mtr-leonro.mtl.com>
In-Reply-To: <20190807031717.GB4832@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47d0efe7-3671-40b7-f2ee-08d71b619600
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2520;
x-ms-traffictypediagnostic: DB6PR0501MB2520:
x-microsoft-antispam-prvs: <DB6PR0501MB2520CB478DFDC7D57A81E17FBED40@DB6PR0501MB2520.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 01221E3973
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(189003)(199004)(186003)(1730700003)(6506007)(26005)(102836004)(6512007)(53936002)(6246003)(71190400001)(71200400001)(4326008)(25786009)(256004)(54906003)(58126008)(446003)(316002)(81156014)(8936002)(81166006)(486006)(14444005)(2351001)(11346002)(476003)(6436002)(2616005)(2906002)(5640700003)(6916009)(68736007)(36756003)(66066001)(229853002)(2501003)(478600001)(66446008)(14454004)(99286004)(7736002)(4744005)(6116002)(3846002)(76176011)(8676002)(86362001)(118296001)(305945005)(66946007)(66556008)(5660300002)(6486002)(91956017)(66476007)(64756008)(76116006);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2520;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lwYWm2NFspCbVGVQPud9832ZRda2JvYLoPKY4K+/WWTyj86bGhIieraCW2dKGtHkaTTVBJW5KXaDXwD9MwanEYRjlJPYDZ22d00z7DGhBbW1goz+ZwsAegaV+hRMCjdlMBMp6yROr/kHQ6LMRt8EXZjR4tUX2eqAS6trrXJYHvyrHw2SWEDGuwDM3pPqTyKcKadlZ7Iwsi2LovVrx0GFwYraurarKmQrb1lWtTez8ZK4b7OglqldoPbb+Ti+HtiTd9GgrzavoYRe8nobPdlxOGNBq1wSiX9OjQ6zZfS5TJKYhQgGhtYSe6cdgTIxq1rVYL2uquJOC68zy4om0NCBJtTNuA6sAo5Wm78b4MwNf1aYgJhVSuDKpQhPNoXdgj4ARw0RUNLh1RxjaQfFGGJtF66GqvSHuyvGnXZ+T8Xvs9A=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E597FA60F51BC42BDFA7D14A1056932@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d0efe7-3671-40b7-f2ee-08d71b619600
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2019 18:03:43.6857
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2520
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA4LTA3IGF0IDA2OjE3ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgQXVnIDA2LCAyMDE5IGF0IDA4OjQwOjExUE0gKzAwMDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAxOS0wOC0wNiBhdCAwOTo1OSArMDgwMCwgQ2h1aG9u
ZyBZdWFuIHdyb3RlOg0KPiA+ID4gUmVmZXJlbmNlIGNvdW50ZXJzIGFyZSBwcmVmZXJyZWQgdG8g
dXNlIHJlZmNvdW50X3QgaW5zdGVhZCBvZg0KPiA+ID4gYXRvbWljX3QuDQo+ID4gPiBUaGlzIGlz
IGJlY2F1c2UgdGhlIGltcGxlbWVudGF0aW9uIG9mIHJlZmNvdW50X3QgY2FuIHByZXZlbnQNCj4g
PiA+IG92ZXJmbG93cyBhbmQgZGV0ZWN0IHBvc3NpYmxlIHVzZS1hZnRlci1mcmVlLg0KPiA+ID4g
U28gY29udmVydCBhdG9taWNfdCByZWYgY291bnRlcnMgdG8gcmVmY291bnRfdC4NCj4gPiA+IA0K
PiA+ID4gU2lnbmVkLW9mZi1ieTogQ2h1aG9uZyBZdWFuIDxoc2xlc3Rlcjk2QGdtYWlsLmNvbT4N
Cj4gPiA+IC0tLQ0KPiA+ID4gQ2hhbmdlcyBpbiB2MzoNCj4gPiA+ICAgLSBNZXJnZSB2MiBwYXRj
aGVzIHRvZ2V0aGVyLg0KPiA+ID4gDQo+ID4gPiAgZHJpdmVycy9pbmZpbmliYW5kL2h3L21seDUv
c3JxX2NtZC5jICAgICAgICAgfCA2ICsrKy0tLQ0KPiA+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9xcC5jIHwgNiArKystLS0NCj4gPiA+ICBpbmNsdWRlL2xpbnV4
L21seDUvZHJpdmVyLmggICAgICAgICAgICAgICAgICB8IDMgKystDQo+ID4gPiAgMyBmaWxlcyBj
aGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiANCj4g
PiBMR1RNLCBMZW9uLCBsZXQgbWUga25vdyBpZiB5b3UgYXJlIGhhcHB5IHdpdGggdGhpcyB2ZXJz
aW9uLA0KPiA+IHRoaXMgc2hvdWxkIGdvIHRvIG1seDUtbmV4dC4NCj4gDQo+IFRoYW5rcywNCj4g
QWNrZWQtYnk6IExlb24gUm9tYW5vdnNreSA8bGVvbnJvQG1lbGxhbm94LmNvbT4NCg0KQXBwbGll
ZCB0byBtbHg1LW5leHQuDQoNClRoYW5rcyAhDQo=
