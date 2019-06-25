Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27DB455647
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbfFYRs1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:48:27 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:51759
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732675AbfFYRsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Jun 2019 13:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CPBBfFj3dYKX0SCkk1v9BTUl2JiW1yHxtAXD9uHFFyg=;
 b=JMcU0OItJPOh4Yfwu89UrYrgHGuWyVu6KhB2p7GBZfj56LwwDDfvJ6U6edDAEABg5w7A2xh0Rmpq9yMPUWJS3jexGEcClCOYKSzp65FwI19o2bJ7N/c80UseGTRm22dwk57Jb0apRNNfJLpE1CPPq8iv42k1B1pQajYyVwb7vaE=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2216.eurprd05.prod.outlook.com (10.168.55.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 17:48:14 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 17:48:14 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, Mark Bloch <markb@mellanox.com>
Subject: [PATCH V2 mlx5-next 13/13] net/mlx5: E-Switch, Enable vport metadata
 matching if firmware supports it
Thread-Topic: [PATCH V2 mlx5-next 13/13] net/mlx5: E-Switch, Enable vport
 metadata matching if firmware supports it
Thread-Index: AQHVK34px/MMPJz8LEGdQoWeN6bNSQ==
Date:   Tue, 25 Jun 2019 17:48:14 +0000
Message-ID: <20190625174727.20309-14-saeedm@mellanox.com>
References: <20190625174727.20309-1-saeedm@mellanox.com>
In-Reply-To: <20190625174727.20309-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::36) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac6c5322-66f4-4c9d-4c70-08d6f9954bd4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2216;
x-ms-traffictypediagnostic: DB6PR0501MB2216:
x-microsoft-antispam-prvs: <DB6PR0501MB22164A0B596A1BB20B8318E1BEE30@DB6PR0501MB2216.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(396003)(376002)(39860400002)(189003)(199004)(36756003)(26005)(76176011)(1076003)(86362001)(14454004)(50226002)(52116002)(110136005)(6116002)(186003)(6506007)(5660300002)(68736007)(386003)(8936002)(2906002)(3846002)(6436002)(256004)(316002)(102836004)(478600001)(81166006)(53936002)(6512007)(107886003)(450100002)(4326008)(486006)(7736002)(8676002)(11346002)(66556008)(64756008)(66946007)(73956011)(99286004)(446003)(66476007)(66446008)(66066001)(2616005)(305945005)(81156014)(71190400001)(54906003)(71200400001)(476003)(6636002)(25786009)(6486002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2216;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SA2+Xgee5luoLdRio792g7IggMSsKMXjNChoiy0OmKDO032qaoEZTiiOz2MKewHYk627DYn2Owr2bPGDDa3m+MALW2ZOXNuK/82k5QXfF92NFg+3es4guv2LMt5VKxSUMct/sc5hdSxOU9+3Z+Y35wUAhkD4EuypRaawHN4kkeivWRWli2IFY6kh6Oqu2PAONYSC2oc/39JZzsRfyOeoMWGDoe5+xDP0m33QETnBQIkr9CAxSej45YGDQUQpHPTxTLk0mrnkg1n67xR1FHQDrJVVbG914Y4dG3ODNBNpvNkJ7YVLMOAx9s0TcFXiUbUlBAo+H9W+hbafN7x9bpbI1snKDKrOOLatNuzPaUW/zyt28QnqVDKbuVpzeMaVxt0hMEIWnxpNZ6ChoKyUkN/8drYoCp0LzfP0/M5cFKEHyOE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac6c5322-66f4-4c9d-4c70-08d6f9954bd4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 17:48:14.1545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2216
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSmlhbmJvIExpdSA8amlhbmJvbEBtZWxsYW5veC5jb20+DQoNCkFzIHRoZSBpbmdyZXNz
IEFDTCBydWxlcyBzYXZlIHZoY2EgaWQgYW5kIHZwb3J0IG51bWJlciB0byBwYWNrZXQncw0KbWV0
YWRhdGEgUkVHX0NfMCwgYW5kIHRoZSBtZXRhZGF0YSBtYXRjaGluZyBmb3IgdGhlIHJ1bGVzIGlu
IGJvdGggZmFzdA0KcGF0aCBhbmQgc2xvdyBwYXRoIGFyZSBhbGwgYWRkZWQsIGVuYWJsZSB0aGlz
IGZlYXR1cmUgaWYgc3VwcG9ydGVkLg0KDQpTaWduZWQtb2ZmLWJ5OiBKaWFuYm8gTGl1IDxqaWFu
Ym9sQG1lbGxhbm94LmNvbT4NClJldmlld2VkLWJ5OiBSb2kgRGF5YW4gPHJvaWRAbWVsbGFub3gu
Y29tPg0KUmV2aWV3ZWQtYnk6IE1hcmsgQmxvY2ggPG1hcmtiQG1lbGxhbm94LmNvbT4NClNpZ25l
ZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4u
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgICAgIHwgMjMgKysrKysrKysr
KysrKysrKysrKw0KIDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZs
b2Fkcy5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hf
b2ZmbG9hZHMuYw0KaW5kZXggOTRiNTVkMGJkZGE5Li4xNzRiMGVjNDE2MmYgMTAwNjQ0DQotLS0g
YS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fk
cy5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRj
aF9vZmZsb2Fkcy5jDQpAQCAtMTkwNCwxMiArMTkwNCwzNSBAQCBzdGF0aWMgaW50IGVzd192cG9y
dF9pbmdyZXNzX2NvbW1vbl9jb25maWcoc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3LA0KIAlyZXR1
cm4gZXJyOw0KIH0NCiANCitzdGF0aWMgYm9vbA0KK2Vzd19jaGVja192cG9ydF9tYXRjaF9tZXRh
ZGF0YV9zdXBwb3J0ZWQoY29uc3Qgc3RydWN0IG1seDVfZXN3aXRjaCAqZXN3KQ0KK3sNCisJaWYg
KCFNTFg1X0NBUF9FU1coZXN3LT5kZXYsIGVzd191cGxpbmtfaW5ncmVzc19hY2wpKQ0KKwkJcmV0
dXJuIGZhbHNlOw0KKw0KKwlpZiAoIShNTFg1X0NBUF9FU1dfRkxPV1RBQkxFKGVzdy0+ZGV2LCBm
ZGJfdG9fdnBvcnRfcmVnX2NfaWQpICYNCisJICAgICAgTUxYNV9GREJfVE9fVlBPUlRfUkVHX0Nf
MCkpDQorCQlyZXR1cm4gZmFsc2U7DQorDQorCWlmICghTUxYNV9DQVBfRVNXX0ZMT1dUQUJMRShl
c3ctPmRldiwgZmxvd19zb3VyY2UpKQ0KKwkJcmV0dXJuIGZhbHNlOw0KKw0KKwlpZiAobWx4NV9j
b3JlX2lzX2VjcGZfZXN3X21hbmFnZXIoZXN3LT5kZXYpIHx8DQorCSAgICBtbHg1X2VjcGZfdnBv
cnRfZXhpc3RzKGVzdy0+ZGV2KSkNCisJCXJldHVybiBmYWxzZTsNCisNCisJcmV0dXJuIHRydWU7
DQorfQ0KKw0KIHN0YXRpYyBpbnQgZXN3X2NyZWF0ZV9vZmZsb2Fkc19hY2xfdGFibGVzKHN0cnVj
dCBtbHg1X2Vzd2l0Y2ggKmVzdykNCiB7DQogCXN0cnVjdCBtbHg1X3Zwb3J0ICp2cG9ydDsNCiAJ
aW50IGksIGo7DQogCWludCBlcnI7DQogDQorCWlmIChlc3dfY2hlY2tfdnBvcnRfbWF0Y2hfbWV0
YWRhdGFfc3VwcG9ydGVkKGVzdykpDQorCQllc3ctPmZsYWdzIHw9IE1MWDVfRVNXSVRDSF9WUE9S
VF9NQVRDSF9NRVRBREFUQTsNCisNCiAJbWx4NV9lc3dfZm9yX2FsbF92cG9ydHMoZXN3LCBpLCB2
cG9ydCkgew0KIAkJZXJyID0gZXN3X3Zwb3J0X2luZ3Jlc3NfY29tbW9uX2NvbmZpZyhlc3csIHZw
b3J0KTsNCiAJCWlmIChlcnIpDQotLSANCjIuMjEuMA0KDQo=
