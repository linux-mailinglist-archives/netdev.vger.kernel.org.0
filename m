Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2B11999D
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 10:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfEJIYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 04:24:08 -0400
Received: from mail-eopbgr10057.outbound.protection.outlook.com ([40.107.1.57]:25819
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727156AbfEJIYF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 04:24:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypVf1RAo+conpxFWNSV5B9XfuX0wzX/1uSowUE65D+g=;
 b=SIAmou0WtVu+9+XR4WQ0Cs/y1TvOS4Vn5wRv9niwurxNhrzh4Ah7yc/Ukj8pNjQDGK9FBslSf1TUlYJQ9U0g3Frv8bMqPOodyvE7vtokJb3cgZRBKFaBlRoIV0sifZudUmTz6UlY1X4UP61tG8Pj+TD8IeOeP1XXtU/6id0OkM8=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.5.23) by
 VI1PR0402MB2815.eurprd04.prod.outlook.com (10.172.255.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.22; Fri, 10 May 2019 08:24:01 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::9889:fa82:4172:14df%6]) with mapi id 15.20.1878.022; Fri, 10 May 2019
 08:24:01 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ynezz@true.cz" <ynezz@true.cz>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andy Duan <fugang.duan@nxp.com>
Subject: [PATCH net 1/3] net: ethernet: add property "nvmem_macaddr_swap" to
 swap macaddr bytes order
Thread-Topic: [PATCH net 1/3] net: ethernet: add property "nvmem_macaddr_swap"
 to swap macaddr bytes order
Thread-Index: AQHVBwm4BewhjCi/Zkaqy4SJng2qbg==
Date:   Fri, 10 May 2019 08:24:00 +0000
Message-ID: <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
References: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
In-Reply-To: <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.7.4
x-clientproxiedby: HK2PR02CA0212.apcprd02.prod.outlook.com
 (2603:1096:201:20::24) To VI1PR0402MB3600.eurprd04.prod.outlook.com
 (2603:10a6:803:a::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 85b36509-3390-4bdb-fd93-08d6d520dae1
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB2815;
x-ms-traffictypediagnostic: VI1PR0402MB2815:
x-microsoft-antispam-prvs: <VI1PR0402MB2815F355BD14DC8C05D338A1FF0C0@VI1PR0402MB2815.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0033AAD26D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(396003)(366004)(39860400002)(189003)(30594003)(199004)(11346002)(486006)(26005)(6436002)(305945005)(2616005)(6116002)(3846002)(68736007)(316002)(7736002)(386003)(6506007)(6486002)(102836004)(446003)(186003)(2906002)(6916009)(50226002)(54906003)(1730700003)(66066001)(66556008)(36756003)(8676002)(66946007)(66476007)(64756008)(76176011)(2351001)(81156014)(476003)(5660300002)(73956011)(86362001)(66446008)(81166006)(14454004)(478600001)(8936002)(25786009)(5640700003)(256004)(14444005)(6512007)(52116002)(71190400001)(71200400001)(2501003)(53936002)(4326008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB2815;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: j/slM9JAKV/GOB6Yj5/U5/3oIEUB35cmAJx1MrdFZrl0Bau+DKsYGShRUBPQOIruUr7HEJxwnEjtRCeIuezEy0OkNscvqfV+f+54XtSZiznkBVsCAD9efrHZf8euB1IO2AOampGOjzT+rGGJt8bYaKRZlyL3/kRJc2WK3X3dQlbCytNROi9BwE4/IF0xynn+A4EG9ItMcMb04VM0DpAORUKaA4hRAf0Mic+b8u7MBli5TTbI3rGYz54PNBnMtrJeA6gZuU843wb0+fM28Gl6yA5+RO97940QKza14BynKWE2p6iGb6bS/9CtdxvbGoIwRTjUu0Swe3bpaUgIm74Iag2jJiQP7ERFgeXTs/xUVRX3FIa38E89FTZtCHm8W5ChS9GmYwjgV31Jra3v3gY62zjIBuJkwlUtOBdTfuARhj8=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85b36509-3390-4bdb-fd93-08d6d520dae1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2019 08:24:01.0149
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2815
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ZXRoZXJuZXQgY29udHJvbGxlciBkcml2ZXIgY2FsbCAub2ZfZ2V0X21hY19hZGRyZXNzKCkgdG8g
Z2V0DQp0aGUgbWFjIGFkZHJlc3MgZnJvbSBkZXZpY3RyZWUgdHJlZSwgaWYgdGhlc2UgcHJvcGVy
dGllcyBhcmUNCm5vdCBwcmVzZW50LCB0aGVuIHRyeSB0byByZWFkIGZyb20gbnZtZW0uDQoNCkZv
ciBleGFtcGxlLCByZWFkIE1BQyBhZGRyZXNzIGZyb20gbnZtZW06DQpvZl9nZXRfbWFjX2FkZHJl
c3MoKQ0KCW9mX2dldF9tYWNfYWRkcl9udm1lbSgpDQoJCW52bWVtX2dldF9tYWNfYWRkcmVzcygp
DQoNCmkuTVg2eC83RC84TVEvOE1NIHBsYXRmb3JtcyBldGhlcm5ldCBNQUMgYWRkcmVzcyByZWFk
IGZyb20NCm52bWVtIG9jb3RwIGVGdXNlcywgYnV0IGl0IHJlcXVpcmVzIHRvIHN3YXAgdGhlIHNp
eCBieXRlcw0Kb3JkZXIuDQoNClRoZSBwYXRjaCBhZGQgb3B0aW9uYWwgcHJvcGVydHkgIm52bWVt
X21hY2FkZHJfc3dhcCIgdG8gc3dhcA0KbWFjYWRkciBieXRlcyBvcmRlci4NCg0KU2lnbmVkLW9m
Zi1ieTogRnVnYW5nIER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+DQotLS0NCiBuZXQvZXRoZXJu
ZXQvZXRoLmMgfCAyNSArKysrKysrKysrKysrKysrKysrKy0tLS0tDQogMSBmaWxlIGNoYW5nZWQs
IDIwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9uZXQvZXRo
ZXJuZXQvZXRoLmMgYi9uZXQvZXRoZXJuZXQvZXRoLmMNCmluZGV4IDRiMmIyMjIuLjBhMDk4NmIg
MTAwNjQ0DQotLS0gYS9uZXQvZXRoZXJuZXQvZXRoLmMNCisrKyBiL25ldC9ldGhlcm5ldC9ldGgu
Yw0KQEAgLTU4Myw4ICs1ODMsMTAgQEAgRVhQT1JUX1NZTUJPTChldGhfcGxhdGZvcm1fZ2V0X21h
Y19hZGRyZXNzKTsNCiBpbnQgbnZtZW1fZ2V0X21hY19hZGRyZXNzKHN0cnVjdCBkZXZpY2UgKmRl
diwgdm9pZCAqYWRkcmJ1ZikNCiB7DQogCXN0cnVjdCBudm1lbV9jZWxsICpjZWxsOw0KLQljb25z
dCB2b2lkICptYWM7DQorCWNvbnN0IHVuc2lnbmVkIGNoYXIgKm1hYzsNCisJdW5zaWduZWQgY2hh
ciBtYWNhZGRyW0VUSF9BTEVOXTsNCiAJc2l6ZV90IGxlbjsNCisJaW50IGkgPSAwOw0KIA0KIAlj
ZWxsID0gbnZtZW1fY2VsbF9nZXQoZGV2LCAibWFjLWFkZHJlc3MiKTsNCiAJaWYgKElTX0VSUihj
ZWxsKSkNCkBAIC01OTYsMTQgKzU5OCwyNyBAQCBpbnQgbnZtZW1fZ2V0X21hY19hZGRyZXNzKHN0
cnVjdCBkZXZpY2UgKmRldiwgdm9pZCAqYWRkcmJ1ZikNCiAJaWYgKElTX0VSUihtYWMpKQ0KIAkJ
cmV0dXJuIFBUUl9FUlIobWFjKTsNCiANCi0JaWYgKGxlbiAhPSBFVEhfQUxFTiB8fCAhaXNfdmFs
aWRfZXRoZXJfYWRkcihtYWMpKSB7DQotCQlrZnJlZShtYWMpOw0KLQkJcmV0dXJuIC1FSU5WQUw7
DQorCWlmIChsZW4gIT0gRVRIX0FMRU4pDQorCQlnb3RvIGludmFsaWRfYWRkcjsNCisNCisJaWYg
KGRldi0+b2Zfbm9kZSAmJg0KKwkgICAgb2ZfcHJvcGVydHlfcmVhZF9ib29sKGRldi0+b2Zfbm9k
ZSwgIm52bWVtX21hY2FkZHJfc3dhcCIpKSB7DQorCQlmb3IgKGkgPSAwOyBpIDwgRVRIX0FMRU47
IGkrKykNCisJCQltYWNhZGRyW2ldID0gbWFjW0VUSF9BTEVOIC0gaSAtIDFdOw0KKwl9IGVsc2Ug
ew0KKwkJZXRoZXJfYWRkcl9jb3B5KG1hY2FkZHIsIG1hYyk7DQogCX0NCiANCi0JZXRoZXJfYWRk
cl9jb3B5KGFkZHJidWYsIG1hYyk7DQorCWlmICghaXNfdmFsaWRfZXRoZXJfYWRkcihtYWNhZGRy
KSkNCisJCWdvdG8gaW52YWxpZF9hZGRyOw0KKw0KKwlldGhlcl9hZGRyX2NvcHkoYWRkcmJ1Ziwg
bWFjYWRkcik7DQogCWtmcmVlKG1hYyk7DQogDQogCXJldHVybiAwOw0KKw0KK2ludmFsaWRfYWRk
cjoNCisJa2ZyZWUobWFjKTsNCisJcmV0dXJuIC1FSU5WQUw7DQogfQ0KIEVYUE9SVF9TWU1CT0wo
bnZtZW1fZ2V0X21hY19hZGRyZXNzKTsNCi0tIA0KMi43LjQNCg0K
