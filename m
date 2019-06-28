Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087195A779
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 01:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbfF1XSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 19:18:42 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:28738
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726817AbfF1XSl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 19:18:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=igitWdW2mkQ1h1zpgDwXwz72TvuiK233Y+GLQ10P9rySAeNeK6iAHmLcpcOy9jJoOYGDIcXXHWatXivspb1iZE1O7XBdlDIqClsyL+hROHIt3l7xrPuEHe15c9SkrlkpZs0AzR7pUsFW4dSdamqIZamgXsTdNwD2K7cLtD2vdOo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nqPtxlOjgc4G876axegyLYaJ7EC85mESp/n1DiI4lA=;
 b=u2vkKwa9wUu9F0oB7ERVxORBucyk77KRqaWOtGCfyh1EsrFLSS8xHDyXGFU3BVZCYR3KF1qW1zK4RWK0opBrY5kR3zCPbWVY1Vi20gbF98CIyCMelySYpMU+p803Ufiwn86SMBzhf07CTpVuLcMrEgMJhl/VzF6ezh6DRYqRjtk=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+nqPtxlOjgc4G876axegyLYaJ7EC85mESp/n1DiI4lA=;
 b=W7hG58Zb6/3fat8ahhjs/o+Qgzqc53yK3bRVk7wupj4SYo7Feq08WJ2pIBjEAIYqvqEH6mL1L4adOLRWzX+3VxYWCp0BRJPOjjI41RWfwur075yE0kQtztB/Hm1VSkdkbMI16zoCuJQvIZ/44Jmy3sZs3l9k6PqAEB8pBc4nuZ8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2198.eurprd05.prod.outlook.com (10.168.55.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Fri, 28 Jun 2019 23:18:26 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Fri, 28 Jun 2019
 23:18:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Vu Pham <vuhuong@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/10] net/mlx5e: Correct phys_port_name for PF port
Thread-Topic: [net-next 05/10] net/mlx5e: Correct phys_port_name for PF port
Thread-Index: AQHVLgfJ7A8NmZgWAUaXCe/H4WFokA==
Date:   Fri, 28 Jun 2019 23:18:26 +0000
Message-ID: <20190628231759.16374-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1c768ee7-0d61-48e0-6a0a-08d6fc1eec0a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2198;
x-ms-traffictypediagnostic: DB6PR0501MB2198:
x-microsoft-antispam-prvs: <DB6PR0501MB21981DE68BABA35DC54BA0FBBEFC0@DB6PR0501MB2198.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 00826B6158
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(39850400004)(136003)(346002)(366004)(189003)(199004)(6512007)(186003)(71190400001)(81166006)(6916009)(478600001)(71200400001)(81156014)(476003)(3846002)(6506007)(53936002)(66946007)(66556008)(66446008)(64756008)(66476007)(25786009)(8676002)(54906003)(6486002)(486006)(446003)(73956011)(305945005)(66066001)(99286004)(4326008)(11346002)(1076003)(86362001)(7736002)(5660300002)(107886003)(52116002)(26005)(6116002)(36756003)(76176011)(4744005)(2616005)(386003)(14454004)(6436002)(2906002)(8936002)(102836004)(256004)(50226002)(316002)(68736007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2198;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AXzHiIpo9iddALg72fg0Zw1kUFT/ptRNEbwOgZB1acgZ37pokldvZ3vbvGFBJgPOf8xTGANV2vMNslnjZMz8vAiYpO1AyWhjsa56j+9p6Db9gLssvXREkMz0R/tGpigrJO5MJr8VjBUVgYtKbgtHSk7nY+pja3qCFWpaez1Mu31ZryZLRvnlZw+w46/x+BTwJhXuSiK8U3d7pQ9+ZZh0DipOR3psUFNgFxr/sT4se7MDqxll805KLrPna7sTNJmq3ZJ/Dgd/X9lEU+DxoB4UHg3X7aC69tR5IIePR1pru8hg3OCaB15w5TTcTzK9NDt/tThyBHh1YXy0+4kyYgWZ/BYI1Uy40TAdCX8E+7HyQcrmihmTvpHu9unAwkS8FBzNO7e4gpCA9oD1KEKnkhW/grcms+1AlSkJGod+tD5Jbhs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c768ee7-0d61-48e0-6a0a-08d6fc1eec0a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2019 23:18:26.5483
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

RnJvbTogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQoNCkN1cnJlbnRseSBQRiBw
aHlzX3BvcnRfbmFtZSBpcyBuYW1lZCBhcyBwZk52Zi0xIGFzIHZwb3J0IG51bWJlciBmb3IgUEYN
CnZwb3J0IGlzIDY1NTM1Lg0KQ29ycmVjdCBQRidzIHBoeXNfcG9ydCBuYW1lIGFzIGFncmVlZCB1
cG9uIG5hbWUgYXMgcGZOLg0KDQpTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQYW5kaXQgPHBhcmF2QG1l
bGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBWdSBQaGFtIDx2dWh1b25nQG1lbGxhbm94LmNvbT4N
ClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0t
DQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3JlcC5jIHwgMiAr
Kw0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9yZXAuYw0KaW5kZXggMzk5OWRhM2U2MzE0
Li5kZWUyZmJiZjNjMTIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvZW5fcmVwLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94
L21seDUvY29yZS9lbl9yZXAuYw0KQEAgLTExNDUsNiArMTE0NSw4IEBAIHN0YXRpYyBpbnQgbWx4
NWVfcmVwX2dldF9waHlzX3BvcnRfbmFtZShzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LA0KIA0KIAlp
ZiAocmVwLT52cG9ydCA9PSBNTFg1X1ZQT1JUX1VQTElOSykNCiAJCXJldCA9IHNucHJpbnRmKGJ1
ZiwgbGVuLCAicCVkIiwgZm4pOw0KKwllbHNlIGlmIChyZXAtPnZwb3J0ID09IE1MWDVfVlBPUlRf
UEYpDQorCQlyZXQgPSBzbnByaW50ZihidWYsIGxlbiwgInBmJWQiLCBmbik7DQogCWVsc2UNCiAJ
CXJldCA9IHNucHJpbnRmKGJ1ZiwgbGVuLCAicGYlZHZmJWQiLCBmbiwgcmVwLT52cG9ydCAtIDEp
Ow0KIA0KLS0gDQoyLjIxLjANCg0K
