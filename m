Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0448B2D39B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 04:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfE2CIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 22:08:17 -0400
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:48196
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726520AbfE2CIP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 22:08:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D3IybpV4HbBfsStzSLEf/KiVkPN+xwz1uUEur9EMvas=;
 b=Q/ru9Hpy9g+DD9/M7yypri40iOHvpBhjwBz+ijSD22PiWqm+VtFvCyReHzqqCyYhre0eRr0iKpgId0eKc9iqack5HmesEDLCdQ6n1z7tM/9NXPO7SA2FNiSfx85WfCksTfaWMXXnlcGjzbqzhBoZNCwVc7NdOTJ4j8xeQANlSjs=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5947.eurprd05.prod.outlook.com (20.179.11.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Wed, 29 May 2019 02:08:08 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.021; Wed, 29 May 2019
 02:08:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jes Sorensen <jsorensen@fb.com>
Subject: [net 6/6] net/mlx5e: Disable rxhash when CQE compress is enabled
Thread-Topic: [net 6/6] net/mlx5e: Disable rxhash when CQE compress is enabled
Thread-Index: AQHVFcNbYfBwoIgCvk2qV68sWarfDA==
Date:   Wed, 29 May 2019 02:08:07 +0000
Message-ID: <20190529020737.4172-7-saeedm@mellanox.com>
References: <20190529020737.4172-1-saeedm@mellanox.com>
In-Reply-To: <20190529020737.4172-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:a03:74::43) To DB8PR05MB5898.eurprd05.prod.outlook.com
 (2603:10a6:10:a4::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0a903dcb-cfc6-45f7-1711-08d6e3da7e12
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB5947;
x-ms-traffictypediagnostic: DB8PR05MB5947:
x-microsoft-antispam-prvs: <DB8PR05MB59472725E6A1C4E07C672942BE1F0@DB8PR05MB5947.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0052308DC6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(3846002)(6116002)(54906003)(6486002)(8936002)(2906002)(86362001)(81166006)(6506007)(50226002)(8676002)(81156014)(99286004)(53936002)(256004)(14454004)(386003)(14444005)(71200400001)(52116002)(7736002)(305945005)(102836004)(6436002)(71190400001)(5660300002)(316002)(36756003)(186003)(4326008)(476003)(68736007)(486006)(6512007)(446003)(1076003)(66476007)(73956011)(66446008)(66556008)(66946007)(25786009)(478600001)(26005)(2616005)(76176011)(66066001)(64756008)(6916009)(11346002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5947;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WLoP7RIChBFs3hBAslOa2+39SAgGjywEg/ICVKZmv+Eoig508EKK6P/VOY/E9eTmHlNs7eEdNya0XGsaXj+gwWZbAwQYCfgVqkllww6OBUjyvmCult19a8bfWr4Xd9dPg0uyWywWw2kpSWbtLdM7bVyj4ya4nrVM+IGZyJYtNGGo99+QC47Dw88VGZkjYfS3A9jwXI2gwuTfBmVkz8tps5RUOb3rP3bnxoZCZ8szjX86cCxKpF6uDSUB8QhCEX+jnnngVafn8ntL+xKfPYU1owD3h9ho1TfLDH31XGl7QSdyckqWsGNYJ9s5emF11DHUm3XftueYUzWh8z6lY1xxyR8v+OI6HIR5mI+1P/u3gDH1psqyWjif0PDkmYVpxWJA0mB5ZXs37bV4SRVWjF0ZVbxiyoICFK4aCPU2ThjIgPE=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a903dcb-cfc6-45f7-1711-08d6e3da7e12
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2019 02:08:07.9372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5947
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

V2hlbiBDUUUgY29tcHJlc3Npb24gaXMgZW5hYmxlZCAoTXVsdGktaG9zdCBzeXN0ZW1zKSwgY29t
cHJlc3NlZCBDUUVzDQptaWdodCBhcnJpdmUgdG8gdGhlIGRyaXZlciByeCwgY29tcHJlc3NlZCBD
UUVzIGRvbid0IGhhdmUgYSB2YWxpZCBoYXNoDQpvZmZsb2FkIGFuZCB0aGUgZHJpdmVyIGFscmVh
ZHkgcmVwb3J0cyBhIGhhc2ggdmFsdWUgb2YgMCBhbmQgaW52YWxpZCBoYXNoDQp0eXBlIG9uIHRo
ZSBza2IgZm9yIGNvbXByZXNzZWQgQ1FFcywgYnV0IHRoaXMgaXMgbm90IGdvb2QgZW5vdWdoLg0K
DQpPbiBhIGNvbmdlc3RlZCBQQ0llLCB3aGVyZSBDUUUgY29tcHJlc3Npb24gd2lsbCBraWNrIGlu
IGFnZ3Jlc3NpdmVseSwNCmdybyB3aWxsIGRlbGl2ZXIgbG90cyBvZiBvdXQgb2Ygb3JkZXIgcGFj
a2V0cyBkdWUgdG8gdGhlIGludmFsaWQgaGFzaA0KYW5kIHRoaXMgbWlnaHQgY2F1c2UgYSBzZXJp
b3VzIHBlcmZvcm1hbmNlIGRyb3AuDQoNClRoZSBvbmx5IHZhbGlkIHNvbHV0aW9uLCBpcyB0byBk
aXNhYmxlIHJ4aGFzaCBvZmZsb2FkIGF0IGFsbCB3aGVuIENRRQ0KY29tcHJlc3Npb24gaXMgZmF2
b3JhYmxlIChNdWx0aS1ob3N0IHN5c3RlbXMpLg0KDQpGaXhlczogNzIxOWFiMzRmMTg0ICgibmV0
L21seDVlOiBDUUUgY29tcHJlc3Npb24iKQ0KQ0M6IEplcyBTb3JlbnNlbiA8anNvcmVuc2VuQGZi
LmNvbT4NClNpZ25lZC1vZmYtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29t
Pg0KLS0tDQogZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4u
YyB8IDEzICsrKysrKysrKysrKysNCiAxIGZpbGUgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKQ0K
DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vu
X21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9tYWlu
LmMNCmluZGV4IDQ1N2NjMzk0MjNmMi4uYzY1Y2VmZDg0ZWRhIDEwMDY0NA0KLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX21haW4uYw0KQEAgLTM2ODcsNiAr
MzY4NywxMiBAQCBzdGF0aWMgbmV0ZGV2X2ZlYXR1cmVzX3QgbWx4NWVfZml4X2ZlYXR1cmVzKHN0
cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsDQogCQkJbmV0ZGV2X3dhcm4obmV0ZGV2LCAiRGlzYWJs
aW5nIExSTywgbm90IHN1cHBvcnRlZCBpbiBsZWdhY3kgUlFcbiIpOw0KIAl9DQogDQorCWlmIChN
TFg1RV9HRVRfUEZMQUcocGFyYW1zLCBNTFg1RV9QRkxBR19SWF9DUUVfQ09NUFJFU1MpKSB7DQor
CQlmZWF0dXJlcyAmPSB+TkVUSUZfRl9SWEhBU0g7DQorCQlpZiAobmV0ZGV2LT5mZWF0dXJlcyAm
IE5FVElGX0ZfUlhIQVNIKQ0KKwkJCW5ldGRldl93YXJuKG5ldGRldiwgIkRpc2FibGluZyByeGhh
c2gsIG5vdCBzdXBwb3J0ZWQgd2hlbiBDUUUgY29tcHJlc3MgaXMgYWN0aXZlXG4iKTsNCisJfQ0K
Kw0KIAltdXRleF91bmxvY2soJnByaXYtPnN0YXRlX2xvY2spOw0KIA0KIAlyZXR1cm4gZmVhdHVy
ZXM7DQpAQCAtMzgxMiw2ICszODE4LDkgQEAgaW50IG1seDVlX2h3c3RhbXBfc2V0KHN0cnVjdCBt
bHg1ZV9wcml2ICpwcml2LCBzdHJ1Y3QgaWZyZXEgKmlmcikNCiAJbWVtY3B5KCZwcml2LT50c3Rh
bXAsICZjb25maWcsIHNpemVvZihjb25maWcpKTsNCiAJbXV0ZXhfdW5sb2NrKCZwcml2LT5zdGF0
ZV9sb2NrKTsNCiANCisJLyogbWlnaHQgbmVlZCB0byBmaXggc29tZSBmZWF0dXJlcyAqLw0KKwlu
ZXRkZXZfdXBkYXRlX2ZlYXR1cmVzKHByaXYtPm5ldGRldik7DQorDQogCXJldHVybiBjb3B5X3Rv
X3VzZXIoaWZyLT5pZnJfZGF0YSwgJmNvbmZpZywNCiAJCQkgICAgc2l6ZW9mKGNvbmZpZykpID8g
LUVGQVVMVCA6IDA7DQogfQ0KQEAgLTQ2ODAsNiArNDY4OSwxMCBAQCBzdGF0aWMgdm9pZCBtbHg1
ZV9idWlsZF9uaWNfbmV0ZGV2KHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYpDQogCWlmICghcHJp
di0+Y2hhbm5lbHMucGFyYW1zLnNjYXR0ZXJfZmNzX2VuKQ0KIAkJbmV0ZGV2LT5mZWF0dXJlcyAg
Jj0gfk5FVElGX0ZfUlhGQ1M7DQogDQorCS8qIHByZWZlcmUgQ1FFIGNvbXByZXNzaW9uIG92ZXIg
cnhoYXNoICovDQorCWlmIChNTFg1RV9HRVRfUEZMQUcoJnByaXYtPmNoYW5uZWxzLnBhcmFtcywg
TUxYNUVfUEZMQUdfUlhfQ1FFX0NPTVBSRVNTKSkNCisJCW5ldGRldi0+ZmVhdHVyZXMgJj0gfk5F
VElGX0ZfUlhIQVNIOw0KKw0KICNkZWZpbmUgRlRfQ0FQKGYpIE1MWDVfQ0FQX0ZMT1dUQUJMRSht
ZGV2LCBmbG93X3RhYmxlX3Byb3BlcnRpZXNfbmljX3JlY2VpdmUuZikNCiAJaWYgKEZUX0NBUChm
bG93X21vZGlmeV9lbikgJiYNCiAJICAgIEZUX0NBUChtb2RpZnlfcm9vdCkgJiYNCi0tIA0KMi4y
MS4wDQoNCg==
