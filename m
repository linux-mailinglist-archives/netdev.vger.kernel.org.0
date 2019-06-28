Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73305A777
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfF1XSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:18:36 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28738
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726643AbfF1XSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:18:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=h+cijWu7cIy+t0ZXOMkKCc3uNNLDC4cdvzA4mQ9gDGd2smRi+0dkyVuoaKendJezN9aaDUgyfwEgMEzp+DaK5MdlwKxM3aVvDHcys0HYI2UA6r8PopRgQsLtfqBF/6V05h+dUcnnqqJHQ+W67Jt8Wa1WGbBVfX9h8diuR4K23qs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4J8PPw4+9PAfVyPLOlmHQPoHzMvSjWQ6eqUM96F5WVM=;
 b=YbcvNB+j8StTFV0NdqxdcrEDgSP1gyhXlA7XStnyw/twEBOWDMtSaVG4MeaMAx7IagxmCJwzPBz0eFwsWiIx8zNnxats3QM6fLPktaA7Ll1iZ4z5j+6NbnXhYEGC9Wl99cSnqD8/eylKgQLFMdQzFZpb7HWKAbmPEiJVkJKs/Bo=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4J8PPw4+9PAfVyPLOlmHQPoHzMvSjWQ6eqUM96F5WVM=;
 b=VeBFgvLMq+56TdNm5tpjqPpImfSJOC98Ei99CuTy6mITZCYCvfrvEaKjYJPpJ1nPqCvxSTV241lGIgPsZ34VCSdraAIXDD53bji/ijV5Rfc1rpWXBFcpbsRLuR5Bvqf0Gwebs8JpXsM8ZiWCPc0c8100XenP7BdRAJRETH2Qig4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:21 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Gavi Teitz <gavi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/10] net/mlx5: MPFS, Allow adding the same MAC more than
 once
Thread-Topic: [net-next 02/10] net/mlx5: MPFS, Allow adding the same MAC more
 than once
Thread-Index: AQHVLgfGhJvAF6VYOEmR19OrhdC2QQ==
Date:   Fri, 28 Jun 2019 23:18:21 +0000
Message-ID: <20190628231759.16374-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 17459774-a517-488d-d5e7-08d6fc1ee938
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB2198274397FD5AD5E6236860BEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(14444005)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +/lno1T27pn4lhPNVjF+CC4ijYZoVjcIRzcz24LTQmz2/kHeVNJqETeb2CuonROj0L5Co1lZlUa4dDWT98fUh26l+1lh6caUFYiAMQTZxUJLfhId4Df4vtkLeCSCJLnupxWcx5ecwX12GqfAaG3vaeQApr83TPh6pEoNaRjvMscX1cazfZ3C+Ouc6YsbUMduk68ntuA8fvPd/qG5YnIAB0YYAMNlm7Rmf7m7IF7/8rS9uwUAF51WnNDGPWoe6mFSxrHPKWfn4C1jjcKKJXtkpUjShtR4TR/nU9rudGuRTbfw0RgmKE1DI15c0dYslSI/r8QK3djQHXT3BMS/Ruj46VXzTa39YKb+0D8D2NaKkkbjXFLg8V53QJlrahCDch4vda6R7q+Z9cOGgS0NWv5N5i9n948qf+ZtONPZlTpfFng=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17459774-a517-488d-d5e7-08d6fc1ee938
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:21.4270
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

RnJvbTogR2F2aSBUZWl0eiA8Z2F2aUBtZWxsYW5veC5jb20+DQoNClJlbW92ZSB0aGUgbGltaXRh
dGlvbiBwcmV2ZW50aW5nIGFkZGluZyBhIHZwb3J0J3MgTUFDIGFkZHJlc3MgdG8gdGhlDQpNdWx0
aS1QaHlzaWNhbCBGdW5jdGlvbiBTd2l0Y2ggKE1QRlMpIG1vcmUgdGhhbiBvbmNlIHBlciBFLXN3
aXRjaCwgYXMNCnRoZXJlIGlzIG5vIGRpZmZlcmVuY2UgaW4gdGhlIE1QRlMgaWYgYW4gYWRkcmVz
cyBpcyBiZWluZyB1c2VkIGJ5IGFuDQpFLXN3aXRjaCBtb3JlIHRoYW4gb25jZS4NCg0KVGhpcyBh
bGxvd3MgdGhlIEUtc3dpdGNoIHRvIGhhdmUgbXVsdGlwbGUgdnBvcnRzIHdpdGggdGhlIHNhbWUg
TUFDDQphZGRyZXNzLCBhbGxvd2luZyB2cG9ydHMgdG8gYmUgY2xhc3NpZmllZCBieSBWTEFOIGlk
IGluc3RlYWQgb2YgYnkgTUFDDQppZiBkZXNpcmVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBHYXZpIFRl
aXR6IDxnYXZpQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxz
YWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gv
bWx4NS9jb3JlL2xpYi9tcGZzLmMgfCA3ICsrKysrKy0NCiAxIGZpbGUgY2hhbmdlZCwgNiBpbnNl
cnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvbGliL21wZnMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9saWIvbXBmcy5jDQppbmRleCA5YWU3ZGFkNTkwYTkuLjMxMThl
OGQ2NjQwNyAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUv
Y29yZS9saWIvbXBmcy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvbGliL21wZnMuYw0KQEAgLTY3LDYgKzY3LDcgQEAgc3RhdGljIGludCBkZWxfbDJ0YWJs
ZV9lbnRyeV9jbWQoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgdTMyIGluZGV4KQ0KIHN0cnVj
dCBsMnRhYmxlX25vZGUgew0KIAlzdHJ1Y3QgbDJhZGRyX25vZGUgbm9kZTsNCiAJdTMyICAgICAg
ICAgICAgICAgIGluZGV4OyAvKiBpbmRleCBpbiBIVyBsMiB0YWJsZSAqLw0KKwlpbnQgICAgICAg
ICAgICAgICAgcmVmX2NvdW50Ow0KIH07DQogDQogc3RydWN0IG1seDVfbXBmcyB7DQpAQCAtMTQ0
LDcgKzE0NSw3IEBAIGludCBtbHg1X21wZnNfYWRkX21hYyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAq
ZGV2LCB1OCAqbWFjKQ0KIA0KIAlsMmFkZHIgPSBsMmFkZHJfaGFzaF9maW5kKG1wZnMtPmhhc2gs
IG1hYywgc3RydWN0IGwydGFibGVfbm9kZSk7DQogCWlmIChsMmFkZHIpIHsNCi0JCWVyciA9IC1F
RVhJU1Q7DQorCQlsMmFkZHItPnJlZl9jb3VudCsrOw0KIAkJZ290byBvdXQ7DQogCX0NCiANCkBA
IC0xNjMsNiArMTY0LDcgQEAgaW50IG1seDVfbXBmc19hZGRfbWFjKHN0cnVjdCBtbHg1X2NvcmVf
ZGV2ICpkZXYsIHU4ICptYWMpDQogCQlnb3RvIHNldF90YWJsZV9lbnRyeV9lcnI7DQogDQogCWwy
YWRkci0+aW5kZXggPSBpbmRleDsNCisJbDJhZGRyLT5yZWZfY291bnQgPSAxOw0KIA0KIAltbHg1
X2NvcmVfZGJnKGRldiwgIk1QRlMgbWFjIGFkZGVkICVwTSwgaW5kZXggKCVkKVxuIiwgbWFjLCBp
bmRleCk7DQogCWdvdG8gb3V0Ow0KQEAgLTE5NCw2ICsxOTYsOSBAQCBpbnQgbWx4NV9tcGZzX2Rl
bF9tYWMoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgdTggKm1hYykNCiAJCWdvdG8gdW5sb2Nr
Ow0KIAl9DQogDQorCWlmICgtLWwyYWRkci0+cmVmX2NvdW50ID4gMCkNCisJCWdvdG8gdW5sb2Nr
Ow0KKw0KIAlpbmRleCA9IGwyYWRkci0+aW5kZXg7DQogCWRlbF9sMnRhYmxlX2VudHJ5X2NtZChk
ZXYsIGluZGV4KTsNCiAJbDJhZGRyX2hhc2hfZGVsKGwyYWRkcik7DQotLSANCjIuMjEuMA0KDQo=
