Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24F44A005
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 14:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728840AbfFRMAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 08:00:50 -0400
Received: from mail-eopbgr140058.outbound.protection.outlook.com ([40.107.14.58]:20207
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726543AbfFRMAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jun 2019 08:00:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czFzeHn7fcjg32YvOLvRcqgQ4x7/5VerVr7rtyMyoKU=;
 b=c3hhGGhVrojhT/l3NYoDMIDbyAVXyOmMgifOY/6s2F2f921MyhPBNWFUMcSLbb2tFHCh4Q5Z3zzyM21ESn9X6jHyKPwNkwDTSCiBuMcpy15g1IrGZrxUXpnjuijWP4vRlwDL1fLHfJWArHeFbnSn7yN/i7bdcTop0y2uZSlMBJU=
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com (20.179.0.76) by
 AM6PR05MB5333.eurprd05.prod.outlook.com (20.177.197.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.13; Tue, 18 Jun 2019 12:00:45 +0000
Received: from AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5]) by AM6PR05MB5879.eurprd05.prod.outlook.com
 ([fe80::9527:fe9d:2a02:41d5%5]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 12:00:45 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH bpf-next v5 03/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Topic: [PATCH bpf-next v5 03/16] xsk: Add getsockopt XDP_OPTIONS
Thread-Index: AQHVJc110CoAeST1Qk6grsoB16+IhQ==
Date:   Tue, 18 Jun 2019 12:00:45 +0000
Message-ID: <20190618120024.16788-4-maximmi@mellanox.com>
References: <20190618120024.16788-1-maximmi@mellanox.com>
In-Reply-To: <20190618120024.16788-1-maximmi@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0064.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::28) To AM6PR05MB5879.eurprd05.prod.outlook.com
 (2603:10a6:20b:a2::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.19.1
x-originating-ip: [141.226.120.58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 15b7a4ce-3bbb-49f8-2516-08d6f3e49801
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5333;
x-ms-traffictypediagnostic: AM6PR05MB5333:
x-microsoft-antispam-prvs: <AM6PR05MB5333CCA28F387D5640E20048D1EA0@AM6PR05MB5333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(346002)(39860400002)(136003)(396003)(199004)(189003)(305945005)(66556008)(476003)(11346002)(66476007)(386003)(68736007)(478600001)(2616005)(66066001)(66946007)(73956011)(86362001)(6436002)(66446008)(25786009)(26005)(81156014)(6486002)(64756008)(446003)(6506007)(4326008)(316002)(81166006)(8676002)(102836004)(8936002)(54906003)(486006)(186003)(110136005)(6512007)(7416002)(53936002)(71200400001)(50226002)(76176011)(71190400001)(14444005)(52116002)(36756003)(256004)(14454004)(107886003)(66574012)(6116002)(1076003)(3846002)(5660300002)(7736002)(99286004)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5333;H:AM6PR05MB5879.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xSeqUZ/6FSJA5stZV6TXIzY3eAfNW+7xl1Q2BD4euMLACeEP9HDcQkS5VMzdhwzm5MppAYd2/2ilMUTPJJa8ISPpG5bSK1uPne1CL2g3yloZ9mCkaFbDH/tMX7yQJNc722IoJlJddoBWEud2sqUEFiY9V54hmrwWcVtL0Zuo+gCuM4lxwcX1k0gwEynaAngMRm1b8yDfcabffzQ2azWx7ga/q988kes/oCIhYAYNaiyuZb7uHXX6zz4WsrvTiXQMDE2W82ZSLTzdkd9mzPg5uKtqrk1Xh9hyUL2e/gqHhZl42FTEU/bZQWYcXCL42f0qAvB7v5rgRImgGzR1tFvhJNqmvW9eZskg/RVDw9EvDvAU2SKCW7l/fPg5rMkTiZs42ZqJdlzRSLvqWYKWAv+BvtMMtxjGteuhdeCSta+14S8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <623715A47D85DF48B301C2959F0FAD76@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15b7a4ce-3bbb-49f8-2516-08d6f3e49801
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 12:00:45.0627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: maximmi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TWFrZSBpdCBwb3NzaWJsZSBmb3IgdGhlIGFwcGxpY2F0aW9uIHRvIGRldGVybWluZSB3aGV0aGVy
IHRoZSBBRl9YRFANCnNvY2tldCBpcyBydW5uaW5nIGluIHplcm8tY29weSBtb2RlLiBUbyBhY2hp
ZXZlIHRoaXMsIGFkZCBhIG5ldw0KZ2V0c29ja29wdCBvcHRpb24gWERQX09QVElPTlMgdGhhdCBy
ZXR1cm5zIGZsYWdzLiBUaGUgb25seSBmbGFnDQpzdXBwb3J0ZWQgZm9yIG5vdyBpcyB0aGUgemVy
by1jb3B5IG1vZGUgaW5kaWNhdG9yLg0KDQpTaWduZWQtb2ZmLWJ5OiBNYXhpbSBNaWtpdHlhbnNr
aXkgPG1heGltbWlAbWVsbGFub3guY29tPg0KUmV2aWV3ZWQtYnk6IFRhcmlxIFRvdWthbiA8dGFy
aXF0QG1lbGxhbm94LmNvbT4NCkFja2VkLWJ5OiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxh
bm94LmNvbT4NCkFja2VkLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+
DQotLS0NCiBpbmNsdWRlL3VhcGkvbGludXgvaWZfeGRwLmggICAgICAgfCAgOCArKysrKysrKw0K
IG5ldC94ZHAveHNrLmMgICAgICAgICAgICAgICAgICAgICB8IDIwICsrKysrKysrKysrKysrKysr
KysrDQogdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oIHwgIDggKysrKysrKysNCiAz
IGZpbGVzIGNoYW5nZWQsIDM2IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2luY2x1ZGUv
dWFwaS9saW51eC9pZl94ZHAuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaA0KaW5kZXgg
Y2FlZDhiMTYxNGZmLi5mYWFhNWNhMmExMTcgMTAwNjQ0DQotLS0gYS9pbmNsdWRlL3VhcGkvbGlu
dXgvaWZfeGRwLmgNCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9pZl94ZHAuaA0KQEAgLTQ2LDYg
KzQ2LDcgQEAgc3RydWN0IHhkcF9tbWFwX29mZnNldHMgew0KICNkZWZpbmUgWERQX1VNRU1fRklM
TF9SSU5HCQk1DQogI2RlZmluZSBYRFBfVU1FTV9DT01QTEVUSU9OX1JJTkcJNg0KICNkZWZpbmUg
WERQX1NUQVRJU1RJQ1MJCQk3DQorI2RlZmluZSBYRFBfT1BUSU9OUwkJCTgNCiANCiBzdHJ1Y3Qg
eGRwX3VtZW1fcmVnIHsNCiAJX191NjQgYWRkcjsgLyogU3RhcnQgb2YgcGFja2V0IGRhdGEgYXJl
YSAqLw0KQEAgLTYwLDYgKzYxLDEzIEBAIHN0cnVjdCB4ZHBfc3RhdGlzdGljcyB7DQogCV9fdTY0
IHR4X2ludmFsaWRfZGVzY3M7IC8qIERyb3BwZWQgZHVlIHRvIGludmFsaWQgZGVzY3JpcHRvciAq
Lw0KIH07DQogDQorc3RydWN0IHhkcF9vcHRpb25zIHsNCisJX191MzIgZmxhZ3M7DQorfTsNCisN
CisvKiBGbGFncyBmb3IgdGhlIGZsYWdzIGZpZWxkIG9mIHN0cnVjdCB4ZHBfb3B0aW9ucyAqLw0K
KyNkZWZpbmUgWERQX09QVElPTlNfWkVST0NPUFkgKDEgPDwgMCkNCisNCiAvKiBQZ29mZiBmb3Ig
bW1hcGluZyB0aGUgcmluZ3MgKi8NCiAjZGVmaW5lIFhEUF9QR09GRl9SWF9SSU5HCQkJICAwDQog
I2RlZmluZSBYRFBfUEdPRkZfVFhfUklORwkJIDB4ODAwMDAwMDANCmRpZmYgLS1naXQgYS9uZXQv
eGRwL3hzay5jIGIvbmV0L3hkcC94c2suYw0KaW5kZXggYjY4YTM4MGY1MGIzLi4zNWNhNTMxYWM3
NGUgMTAwNjQ0DQotLS0gYS9uZXQveGRwL3hzay5jDQorKysgYi9uZXQveGRwL3hzay5jDQpAQCAt
NjUwLDYgKzY1MCwyNiBAQCBzdGF0aWMgaW50IHhza19nZXRzb2Nrb3B0KHN0cnVjdCBzb2NrZXQg
KnNvY2ssIGludCBsZXZlbCwgaW50IG9wdG5hbWUsDQogDQogCQlyZXR1cm4gMDsNCiAJfQ0KKwlj
YXNlIFhEUF9PUFRJT05TOg0KKwl7DQorCQlzdHJ1Y3QgeGRwX29wdGlvbnMgb3B0cyA9IHt9Ow0K
Kw0KKwkJaWYgKGxlbiA8IHNpemVvZihvcHRzKSkNCisJCQlyZXR1cm4gLUVJTlZBTDsNCisNCisJ
CW11dGV4X2xvY2soJnhzLT5tdXRleCk7DQorCQlpZiAoeHMtPnpjKQ0KKwkJCW9wdHMuZmxhZ3Mg
fD0gWERQX09QVElPTlNfWkVST0NPUFk7DQorCQltdXRleF91bmxvY2soJnhzLT5tdXRleCk7DQor
DQorCQlsZW4gPSBzaXplb2Yob3B0cyk7DQorCQlpZiAoY29weV90b191c2VyKG9wdHZhbCwgJm9w
dHMsIGxlbikpDQorCQkJcmV0dXJuIC1FRkFVTFQ7DQorCQlpZiAocHV0X3VzZXIobGVuLCBvcHRs
ZW4pKQ0KKwkJCXJldHVybiAtRUZBVUxUOw0KKw0KKwkJcmV0dXJuIDA7DQorCX0NCiAJZGVmYXVs
dDoNCiAJCWJyZWFrOw0KIAl9DQpkaWZmIC0tZ2l0IGEvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4
L2lmX3hkcC5oIGIvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQppbmRleCBjYWVk
OGIxNjE0ZmYuLmZhYWE1Y2EyYTExNyAxMDA2NDQNCi0tLSBhL3Rvb2xzL2luY2x1ZGUvdWFwaS9s
aW51eC9pZl94ZHAuaA0KKysrIGIvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2lmX3hkcC5oDQpA
QCAtNDYsNiArNDYsNyBAQCBzdHJ1Y3QgeGRwX21tYXBfb2Zmc2V0cyB7DQogI2RlZmluZSBYRFBf
VU1FTV9GSUxMX1JJTkcJCTUNCiAjZGVmaW5lIFhEUF9VTUVNX0NPTVBMRVRJT05fUklORwk2DQog
I2RlZmluZSBYRFBfU1RBVElTVElDUwkJCTcNCisjZGVmaW5lIFhEUF9PUFRJT05TCQkJOA0KIA0K
IHN0cnVjdCB4ZHBfdW1lbV9yZWcgew0KIAlfX3U2NCBhZGRyOyAvKiBTdGFydCBvZiBwYWNrZXQg
ZGF0YSBhcmVhICovDQpAQCAtNjAsNiArNjEsMTMgQEAgc3RydWN0IHhkcF9zdGF0aXN0aWNzIHsN
CiAJX191NjQgdHhfaW52YWxpZF9kZXNjczsgLyogRHJvcHBlZCBkdWUgdG8gaW52YWxpZCBkZXNj
cmlwdG9yICovDQogfTsNCiANCitzdHJ1Y3QgeGRwX29wdGlvbnMgew0KKwlfX3UzMiBmbGFnczsN
Cit9Ow0KKw0KKy8qIEZsYWdzIGZvciB0aGUgZmxhZ3MgZmllbGQgb2Ygc3RydWN0IHhkcF9vcHRp
b25zICovDQorI2RlZmluZSBYRFBfT1BUSU9OU19aRVJPQ09QWSAoMSA8PCAwKQ0KKw0KIC8qIFBn
b2ZmIGZvciBtbWFwaW5nIHRoZSByaW5ncyAqLw0KICNkZWZpbmUgWERQX1BHT0ZGX1JYX1JJTkcJ
CQkgIDANCiAjZGVmaW5lIFhEUF9QR09GRl9UWF9SSU5HCQkgMHg4MDAwMDAwMA0KLS0gDQoyLjE5
LjENCg0K
