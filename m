Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 150D2315D9
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbfEaUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:09:56 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:15081
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727405AbfEaUJ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 16:09:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWKTpyv7RnKCkhUkUA6R/PmiuGPmM/Euve94VeoUOnU=;
 b=Vn+Lgf8Wo5qCbLFOy+8J5exkDt+lBPIx26k+cXX6EBwxAxtyciu7YSs27rhpAHzE5q8roj8UuYDtOfEhq/CQ/SpTFp02W3gHWtzquAlEu7LIg9H0LR0sT/wvhVB6oucUWzz/3bMUWD8idkCBZYm6Bm57tA+hZocog3y078b9Vn4=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB5600.eurprd05.prod.outlook.com (20.177.203.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.16; Fri, 31 May 2019 20:09:26 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 20:09:26 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 3/9] net/mlx5e: Enable setting multiple match criteria for
 flow group
Thread-Topic: [net-next 3/9] net/mlx5e: Enable setting multiple match criteria
 for flow group
Thread-Index: AQHVF+y/Yu0g4OU6eEib/ahuK4eczA==
Date:   Fri, 31 May 2019 20:09:26 +0000
Message-ID: <20190531200838.25184-4-saeedm@mellanox.com>
References: <20190531200838.25184-1-saeedm@mellanox.com>
In-Reply-To: <20190531200838.25184-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0086.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::27) To VI1PR05MB5902.eurprd05.prod.outlook.com
 (2603:10a6:803:df::31)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad69628e-7d24-4416-c6ef-08d6e603e13d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5600;
x-ms-traffictypediagnostic: VI1PR05MB5600:
x-microsoft-antispam-prvs: <VI1PR05MB56006F4AF24E31033566D24FBE190@VI1PR05MB5600.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(136003)(396003)(346002)(189003)(199004)(99286004)(52116002)(2616005)(6116002)(6512007)(107886003)(486006)(54906003)(386003)(476003)(76176011)(186003)(26005)(3846002)(11346002)(305945005)(81166006)(66066001)(256004)(6506007)(4326008)(25786009)(6486002)(102836004)(6436002)(66946007)(8936002)(64756008)(7736002)(8676002)(53936002)(66476007)(73956011)(446003)(66556008)(81156014)(66446008)(6916009)(1076003)(68736007)(2906002)(86362001)(71190400001)(14454004)(5660300002)(316002)(508600001)(36756003)(50226002)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5600;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: z0BEPVcToFcHRKiSCI2b+Iv+CCtoADVRfsJw9hwhKsZ9pmnmFiSyBUE9ugkVVe7jVAlMR0DYgc9BqhTVFjDRoXltJJW0OQmvtlEkY7ob9Q1WhYxsmWw1RBa4fsESr6maV5vDbBUS8SWRtlWnsFsN/z12OOlCTUUQxj+U4gZVk5Ht0Mgj90T/oVU/lxXODDKJa3sosu25+kZjvK0GLq5MHVu6iUX1cutLacHyEHYHn3m8FLOAjply8WLMU4XQJDTadrV3SDx1u+SvOzUkP5xw9r5VLDKiCRln6nCSUHv1GjaxPKZzgXBTiWy5SoGFYsX02aUL1PVVs/WsIVDVBwXabkKdsVvio0mx6TD8Goy3hn9limMGbbPz9njok50wn0A4KKLCXcZZ2OIAM/nkQG9XskxKSWdwmhDbQXTIq/bi0L8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad69628e-7d24-4416-c6ef-08d6e603e13d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 20:09:26.2273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5600
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWWV2Z2VueSBLbGl0ZXluaWsgPGtsaXRleW5AbWVsbGFub3guY29tPg0KDQpXaGVuIGZp
bGxpbmcgaW4gZmxvdyBzcGVjIG1hdGNoIGNyaXRlcmlhLCB0byBhbGxvdyBwcmV2aW91cw0KbW9k
aWZpY2F0aW9ucyBvZiB0aGUgbWF0Y2ggY3JpdGVyaWEsIHVzZSAifD0iIHJhdGhlciB0aGFuICI9
Ii4NCg0KVHVubmVsIG9wdGlvbnMgYXJlIHBhcnNlZCBiZWZvcmUgdGhlIG1hdGNoIGNyaXRlcmlh
IG9mIHRoZSBvZmZsb2FkZWQNCmZsb3cgYXJlIGJlaW5nIHNldC4gSWYgdGhlIHRoZSBmbG93IHRo
YXQgd2UncmUgYWJvdXQgdG8gb2ZmbG9hZCBoYXMNCmVuY2Fwc3VsYXRpb24gb3B0aW9ucywgdGhl
IGZsb3cgZ3JvdXAgbWlnaHQgbmVlZCB0byBtYXRjaCBvbiBhZGRpdGlvbmFsDQpjcml0ZXJpYS4N
Cg0KRm9yIEdlbmV2ZSwgYW4gYWRkaXRpb25hbCBmbG93IGdyb3VwIG1hdGNoaW5nIHBhcmFtZXRl
ciBzaG91bGQNCmJlIHVzZWQgLSBtaXNjMy4gVGhlIGFwcHJvcHJpYXRlIGJpdCBpbiB0aGUgbWF0
Y2ggY3JpdGVyaWEgaXMgc2V0DQp3aGlsZSBwYXJzaW5nIHRoZSB0dW5uZWwgb3B0aW9ucywgc28g
dGhlIGNyaXRlcmlhIHZhbHVlIHNob3VsZG4ndA0KYmUgb3ZlcndyaXR0ZW4uDQoNClRoaXMgaXMg
YSBwcmUtc3RlcCBmb3Igc3VwcG9ydGluZyBHZW5ldmUgVExWIG9wdGlvbnMgb2ZmbG9hZC4NCg0K
UmV2aWV3ZWQtYnk6IE96IFNobG9tbyA8b3pzaEBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5
OiBZZXZnZW55IEtsaXRleW5payA8a2xpdGV5bkBtZWxsYW5veC5jb20+DQpTaWduZWQtb2ZmLWJ5
OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0
L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jICAgICAgICAgICB8IDIgKy0NCiAu
Li4vbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgICAg
fCA4ICsrKystLS0tDQogMiBmaWxlcyBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDUgZGVsZXRp
b25zKC0pDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1
L2NvcmUvZW5fdGMuYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9l
bl90Yy5jDQppbmRleCAxYzQ5Yjc0NWI1NzkuLjhlMmQ4ZTczNWZhYSAxMDA2NDQNCi0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl90Yy5jDQorKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fdGMuYw0KQEAgLTc5OSw3ICs3
OTksNyBAQCBtbHg1ZV90Y19hZGRfbmljX2Zsb3coc3RydWN0IG1seDVlX3ByaXYgKnByaXYsDQog
CX0NCiANCiAJaWYgKGF0dHItPm1hdGNoX2xldmVsICE9IE1MWDVfTUFUQ0hfTk9ORSkNCi0JCXBh
cnNlX2F0dHItPnNwZWMubWF0Y2hfY3JpdGVyaWFfZW5hYmxlID0gTUxYNV9NQVRDSF9PVVRFUl9I
RUFERVJTOw0KKwkJcGFyc2VfYXR0ci0+c3BlYy5tYXRjaF9jcml0ZXJpYV9lbmFibGUgfD0gTUxY
NV9NQVRDSF9PVVRFUl9IRUFERVJTOw0KIA0KIAlmbG93LT5ydWxlWzBdID0gbWx4NV9hZGRfZmxv
d19ydWxlcyhwcml2LT5mcy50Yy50LCAmcGFyc2VfYXR0ci0+c3BlYywNCiAJCQkJCSAgICAmZmxv
d19hY3QsIGRlc3QsIGRlc3RfaXgpOw0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRjaF9vZmZsb2Fkcy5jDQppbmRleCBkOTg3YmQw
NjkzNWQuLmE4YzY2ODNjMzM0OSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21l
bGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCisrKyBiL2RyaXZlcnMvbmV0L2V0
aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMNCkBAIC0xNzMsNyAr
MTczLDcgQEAgbWx4NV9lc3dpdGNoX2FkZF9vZmZsb2FkZWRfcnVsZShzdHJ1Y3QgbWx4NV9lc3dp
dGNoICplc3csDQogCQlNTFg1X1NFVF9UT19PTkVTKGZ0ZV9tYXRjaF9zZXRfbWlzYywgbWlzYywN
CiAJCQkJIHNvdXJjZV9lc3dpdGNoX293bmVyX3ZoY2FfaWQpOw0KIA0KLQlzcGVjLT5tYXRjaF9j
cml0ZXJpYV9lbmFibGUgPSBNTFg1X01BVENIX01JU0NfUEFSQU1FVEVSUzsNCisJc3BlYy0+bWF0
Y2hfY3JpdGVyaWFfZW5hYmxlIHw9IE1MWDVfTUFUQ0hfTUlTQ19QQVJBTUVURVJTOw0KIAlpZiAo
Zmxvd19hY3QuYWN0aW9uICYgTUxYNV9GTE9XX0NPTlRFWFRfQUNUSU9OX0RFQ0FQKSB7DQogCQlp
ZiAoYXR0ci0+dHVubmVsX21hdGNoX2xldmVsICE9IE1MWDVfTUFUQ0hfTk9ORSkNCiAJCQlzcGVj
LT5tYXRjaF9jcml0ZXJpYV9lbmFibGUgfD0gTUxYNV9NQVRDSF9PVVRFUl9IRUFERVJTOw0KQEAg
LTI2NiwxMCArMjY2LDEwIEBAIG1seDVfZXN3aXRjaF9hZGRfZndkX3J1bGUoc3RydWN0IG1seDVf
ZXN3aXRjaCAqZXN3LA0KIAkJCQkgc291cmNlX2Vzd2l0Y2hfb3duZXJfdmhjYV9pZCk7DQogDQog
CWlmIChhdHRyLT5tYXRjaF9sZXZlbCA9PSBNTFg1X01BVENIX05PTkUpDQotCQlzcGVjLT5tYXRj
aF9jcml0ZXJpYV9lbmFibGUgPSBNTFg1X01BVENIX01JU0NfUEFSQU1FVEVSUzsNCisJCXNwZWMt
Pm1hdGNoX2NyaXRlcmlhX2VuYWJsZSB8PSBNTFg1X01BVENIX01JU0NfUEFSQU1FVEVSUzsNCiAJ
ZWxzZQ0KLQkJc3BlYy0+bWF0Y2hfY3JpdGVyaWFfZW5hYmxlID0gTUxYNV9NQVRDSF9PVVRFUl9I
RUFERVJTIHwNCi0JCQkJCSAgICAgIE1MWDVfTUFUQ0hfTUlTQ19QQVJBTUVURVJTOw0KKwkJc3Bl
Yy0+bWF0Y2hfY3JpdGVyaWFfZW5hYmxlIHw9IE1MWDVfTUFUQ0hfT1VURVJfSEVBREVSUyB8DQor
CQkJCQkgICAgICAgTUxYNV9NQVRDSF9NSVNDX1BBUkFNRVRFUlM7DQogDQogCXJ1bGUgPSBtbHg1
X2FkZF9mbG93X3J1bGVzKGZhc3RfZmRiLCBzcGVjLCAmZmxvd19hY3QsIGRlc3QsIGkpOw0KIA0K
LS0gDQoyLjIxLjANCg0K
