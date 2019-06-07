Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB65239806
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 23:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbfFGVrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 17:47:47 -0400
Received: from mail-eopbgr30044.outbound.protection.outlook.com ([40.107.3.44]:37518
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730116AbfFGVrq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 17:47:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q69goByoNsXTvTQOXmtL4uzvTinYlnxzUv3LAznckGc=;
 b=NMywJhHhSiQt6mEAPFr4fLmt2fME1TVz9LayE1zcDMyp0KQVQlu++n4qgKwvyk3+1c5vWTC8wVsqHivLJCQoCN6fwdt0XAUPiH/z/z1hvOnm5/AEWUZePb3XK6dpFKSUBmobx7PydbqXnXYz6T+8YMpaDEnu36iHB4lWiH3s8m0=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6139.eurprd05.prod.outlook.com (20.179.12.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.15; Fri, 7 Jun 2019 21:47:38 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::4008:6417:32d4:6031%5]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 21:47:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alaa Hleihel <alaa@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/7] net/mlx5: Avoid reloading already removed devices
Thread-Topic: [net 2/7] net/mlx5: Avoid reloading already removed devices
Thread-Index: AQHVHXqgNu8QFqwqcEiGk+oLCYRg4g==
Date:   Fri, 7 Jun 2019 21:47:38 +0000
Message-ID: <20190607214716.16316-3-saeedm@mellanox.com>
References: <20190607214716.16316-1-saeedm@mellanox.com>
In-Reply-To: <20190607214716.16316-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::46) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f6d8e05-ff4a-41a4-5927-08d6eb91c27a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6139;
x-ms-traffictypediagnostic: DB8PR05MB6139:
x-microsoft-antispam-prvs: <DB8PR05MB61397F18A8618A5DD9477B15BE100@DB8PR05MB6139.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(366004)(376002)(346002)(136003)(189003)(199004)(71200400001)(81166006)(71190400001)(8676002)(25786009)(52116002)(64756008)(66446008)(66556008)(66476007)(8936002)(76176011)(86362001)(99286004)(73956011)(66946007)(66066001)(50226002)(54906003)(6916009)(6512007)(81156014)(7736002)(316002)(486006)(14444005)(256004)(102836004)(2906002)(305945005)(6116002)(53936002)(3846002)(4326008)(107886003)(6436002)(36756003)(476003)(2616005)(11346002)(6486002)(68736007)(446003)(6506007)(386003)(1076003)(186003)(26005)(14454004)(5660300002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6139;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9XTb80hBt5QFNCR2FC7jXCw68eYYPGVmvBiAliYLBh9Fp0erfACSAbthqIEF5umEicfhCxxm4f/EhhdK84pkdywBnS+bOta2VHyuzDI1uy8musrTPIG+7BB+qMY0eZWvOtKsyeO4dDtIHju2/6k/NMPgZ8DXR9xQuzNgghmE75KvI3w1QavGDpK2RxL3feOTU8BicVIhI6BcAQyht7/GeR4+AuNiKXbQ0RFAa4HFXa6vGSZfa9zqKvkdkKVp89kUPbuOzAW24fZZ7nogX/hqP/8u0OWt7pRnimUuOsCHNO0EAKCtg6zbmRLIhHf5EC6Z18CIs6YSIdL5zeOA/maasdqbxvoYlA+5E5x57QrDiqa7jh3O+xqlgNaHGpTm3rCOw300J3QXCNOdZrnqX38DWiGl4OpFRe5HnkwjnpeohAw=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f6d8e05-ff4a-41a4-5927-08d6eb91c27a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 21:47:38.7325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6139
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogQWxhYSBIbGVpaGVsIDxhbGFhQG1lbGxhbm94LmNvbT4NCg0KUHJpb3IgdG8gcmVsb2Fk
aW5nIGEgZGV2aWNlIHdlIG11c3QgZmlyc3QgdmVyaWZ5IHRoYXQgaXQgd2FzIG5vdCBhbHJlYWR5
DQpyZW1vdmVkLiBPdGhlcndpc2UsIHRoZSBhdHRlbXB0IHRvIHJlbW92ZSB0aGUgZGV2aWNlIHdp
bGwgZG8gbm90aGluZywgYW5kDQppbiB0aGF0IGNhc2Ugd2Ugd2lsbCBlbmQgdXAgcHJvY2VlZGlu
ZyB3aXRoIGFkZGluZyBhbiBuZXcgZGV2aWNlIHRoYXQgbm8NCm9uZSB3YXMgZXhwZWN0aW5nIHRv
IHJlbW92ZSwgbGVhdmluZyBiZWhpbmQgdXNlZCByZXNvdXJjZXMgc3VjaCBhcyBFUXMgdGhhdA0K
Y2F1c2VzIGEgZmFpbHVyZSB0byBkZXN0cm95IGNvbXAgRVFzIGFuZCBzeW5kcm9tZSAoMHgzMGY0
MzMpLg0KDQpGaXggdGhhdCBieSBtYWtpbmcgc3VyZSB0aGF0IHdlIHRyeSB0byByZW1vdmUgYW5k
IGFkZCBhIGRldmljZSAoYmFzZWQgb24gYQ0KcHJvdG9jb2wpIG9ubHkgaWYgdGhlIGRldmljZSBp
cyBhbHJlYWR5IGFkZGVkLg0KDQpGaXhlczogYzU0NDdjNzA1OTRiICgibmV0L21seDU6IEUtU3dp
dGNoLCBSZWxvYWQgSUIgaW50ZXJmYWNlIHdoZW4gc3dpdGNoaW5nIGRldmxpbmsgbW9kZXMiKQ0K
U2lnbmVkLW9mZi1ieTogQWxhYSBIbGVpaGVsIDxhbGFhQG1lbGxhbm94LmNvbT4NClNpZ25lZC1v
ZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Rldi5jIHwgMjUgKysrKysrKysrKysr
KysrKystLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygt
KQ0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3Jl
L2Rldi5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Rldi5jDQpp
bmRleCBlYmMwNDZmYTk3ZDMuLmY2YjFkYTk5ZTZjMiAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9kZXYuYw0KKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Rldi5jDQpAQCAtMjQ4LDExICsyNDgsMzIgQEAgdm9p
ZCBtbHg1X3VucmVnaXN0ZXJfaW50ZXJmYWNlKHN0cnVjdCBtbHg1X2ludGVyZmFjZSAqaW50ZikN
CiB9DQogRVhQT1JUX1NZTUJPTChtbHg1X3VucmVnaXN0ZXJfaW50ZXJmYWNlKTsNCiANCisvKiBN
dXN0IGJlIGNhbGxlZCB3aXRoIGludGZfbXV0ZXggaGVsZCAqLw0KK3N0YXRpYyBib29sIG1seDVf
aGFzX2FkZGVkX2Rldl9ieV9wcm90b2NvbChzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqbWRldiwgaW50
IHByb3RvY29sKQ0KK3sNCisJc3RydWN0IG1seDVfZGV2aWNlX2NvbnRleHQgKmRldl9jdHg7DQor
CXN0cnVjdCBtbHg1X2ludGVyZmFjZSAqaW50ZjsNCisJYm9vbCBmb3VuZCA9IGZhbHNlOw0KKw0K
KwlsaXN0X2Zvcl9lYWNoX2VudHJ5KGludGYsICZpbnRmX2xpc3QsIGxpc3QpIHsNCisJCWlmIChp
bnRmLT5wcm90b2NvbCA9PSBwcm90b2NvbCkgew0KKwkJCWRldl9jdHggPSBtbHg1X2dldF9kZXZp
Y2UoaW50ZiwgJm1kZXYtPnByaXYpOw0KKwkJCWlmIChkZXZfY3R4ICYmIHRlc3RfYml0KE1MWDVf
SU5URVJGQUNFX0FEREVELCAmZGV2X2N0eC0+c3RhdGUpKQ0KKwkJCQlmb3VuZCA9IHRydWU7DQor
CQkJYnJlYWs7DQorCQl9DQorCX0NCisNCisJcmV0dXJuIGZvdW5kOw0KK30NCisNCiB2b2lkIG1s
eDVfcmVsb2FkX2ludGVyZmFjZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqbWRldiwgaW50IHByb3Rv
Y29sKQ0KIHsNCiAJbXV0ZXhfbG9jaygmbWx4NV9pbnRmX211dGV4KTsNCi0JbWx4NV9yZW1vdmVf
ZGV2X2J5X3Byb3RvY29sKG1kZXYsIHByb3RvY29sKTsNCi0JbWx4NV9hZGRfZGV2X2J5X3Byb3Rv
Y29sKG1kZXYsIHByb3RvY29sKTsNCisJaWYgKG1seDVfaGFzX2FkZGVkX2Rldl9ieV9wcm90b2Nv
bChtZGV2LCBwcm90b2NvbCkpIHsNCisJCW1seDVfcmVtb3ZlX2Rldl9ieV9wcm90b2NvbChtZGV2
LCBwcm90b2NvbCk7DQorCQltbHg1X2FkZF9kZXZfYnlfcHJvdG9jb2wobWRldiwgcHJvdG9jb2wp
Ow0KKwl9DQogCW11dGV4X3VubG9jaygmbWx4NV9pbnRmX211dGV4KTsNCiB9DQogDQotLSANCjIu
MjEuMA0KDQo=
