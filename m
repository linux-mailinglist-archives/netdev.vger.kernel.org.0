Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 482055A77A
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfF1XSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:18:40 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28738
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbfF1XSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:18:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=kO1aKchC2YScowxHh7n8c/UMyx+3tXlx0K4rrs8ST+eGY+ImZLrvrKW8yWd/0RU7yxsuEC2c0JzD9UbKqtOQ+0iT6tQygo6xEdhPeVQfhDh+CZdiR9edAYZK+LNRNvrh+HmLlPAh2Vlak+CblwBFfEeISpoMmIFJfrm/7pgGMaI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63F/DkylDxEsJr83AYFHQ3qBNFS8KvmAlLkediXigCA=;
 b=T+zyNTSZ+nKI8zc8S+UROdqtwh0eF93Q+Bi1smnQEdTtYVOcRmTo4mJONMEDGf/hsXyV4u7fYr3R/A/y9NgxqGgyEDTx38ZK7XFha6mguHHf9HHGwrXeF92jQSzrVJpAr6+lO6nYBihqd6/kGKn0Cb1CM6eOE3tNMAdTjZ57yso=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=63F/DkylDxEsJr83AYFHQ3qBNFS8KvmAlLkediXigCA=;
 b=jFmy9Gvk8JbsjaplDHrLKyxiqPFGtKxYXo1H1syTBSxQ12duNYjXXvR5OxPvDX2EnQMlM/N7EN4V5EsgNsJd72pD37JHZYql95e8WiDalLDL7Tpz8HFg4fSysiqtgdGX+bhHIu+xX5w2eYmPcWvxD1PXt3OPHaEshRBjCqm9NrQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:24 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/10] net/mlx5e: Report netdevice MPLS features
Thread-Topic: [net-next 04/10] net/mlx5e: Report netdevice MPLS features
Thread-Index: AQHVLgfIVspb4k6f60+5eO+x8NMnJw==
Date:   Fri, 28 Jun 2019 23:18:24 +0000
Message-ID: <20190628231759.16374-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 268ddd31-ebb5-4598-56cf-08d6fc1eeae7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB21981425A4CCE733A818C8DABEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Q3p955isCEH7R3/FD2Z5uot8/py03djG5EkV3qT8rklrEEQlEwKnBsv52U9sy3Fgf8Ca/ydFd4aX/uCarPF1TAlM4xNM5WvYuuOwYDUibz6d/usSbiO2xqjrCGgP3/PSWWNGUAkRH0XMMF07onG4TCpNdsx/UwIqU0sR1BZHyjhWRlcB1vWhbIdzo4C3rDoYAXM4RT5PeCcQmzeFTZX/bd6kn0eok0N3CasdXLN46+8DMptFT3UT4lL4SUeajDd3AN8cYB2y5yHoRvM7JZU8D+ZbxpQX1mNRhFAVE/sEEcWkB9yWWFkma8v2+3gFYXrh0+J9tsum+hERXlX+xafNqpiBFiDIil2oVrJrm6oJt8zyhjOqV5itbaotSli5n0+vDkD8/gNUgPoK3vIZVaQ2F9nxJAQzlo0m75P89/TDvXc=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 268ddd31-ebb5-4598-56cf-08d6fc1eeae7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:24.5266
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

RnJvbTogQXJpZWwgTGV2a292aWNoIDxsYXJpZWxAbWVsbGFub3guY29tPg0KDQpTZXQgc3VwcG9y
dGVkIGRldmljZSBmZWF0dXJlcyBpbiB0aGUgbmV0ZGV2aWNlIE1QTFMgZmVhdHVyZXMgbWFzay4N
ClRoaXMgd2lsbCBlbmFibGUgSFcgY2hlY2tzdW1taW5nIGFuZCBUU08gZm9yIE1QTFMgdGFnZ2Vk
IHRyYWZmaWMuDQoNClNpZ25lZC1vZmYtYnk6IEFyaWVsIExldmtvdmljaCA8bGFyaWVsQG1lbGxh
bm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3gu
Y29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21h
aW4uYyB8IDUgKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5j
IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KaW5k
ZXggODk5NWNkZDRkMjRjLi4zZGY2NjNkNmU0ZDggMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQorKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fbWFpbi5jDQpAQCAtNDYyNCw2ICs0NjI0LDEx
IEBAIHN0YXRpYyB2b2lkIG1seDVlX2J1aWxkX25pY19uZXRkZXYoc3RydWN0IG5ldF9kZXZpY2Ug
Km5ldGRldikNCiAJbmV0ZGV2LT52bGFuX2ZlYXR1cmVzICAgIHw9IE5FVElGX0ZfUlhDU1VNOw0K
IAluZXRkZXYtPnZsYW5fZmVhdHVyZXMgICAgfD0gTkVUSUZfRl9SWEhBU0g7DQogDQorCW5ldGRl
di0+bXBsc19mZWF0dXJlcyAgICB8PSBORVRJRl9GX1NHOw0KKwluZXRkZXYtPm1wbHNfZmVhdHVy
ZXMgICAgfD0gTkVUSUZfRl9IV19DU1VNOw0KKwluZXRkZXYtPm1wbHNfZmVhdHVyZXMgICAgfD0g
TkVUSUZfRl9UU087DQorCW5ldGRldi0+bXBsc19mZWF0dXJlcyAgICB8PSBORVRJRl9GX1RTTzY7
DQorDQogCW5ldGRldi0+aHdfZW5jX2ZlYXR1cmVzICB8PSBORVRJRl9GX0hXX1ZMQU5fQ1RBR19U
WDsNCiAJbmV0ZGV2LT5od19lbmNfZmVhdHVyZXMgIHw9IE5FVElGX0ZfSFdfVkxBTl9DVEFHX1JY
Ow0KIA0KLS0gDQoyLjIxLjANCg0K
