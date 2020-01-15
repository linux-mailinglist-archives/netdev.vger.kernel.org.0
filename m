Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC3113C033
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgAOMR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:17:57 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730776AbgAOMMs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKBU6PhD2cC8DyRVeML1nKSEVg5zd7KROI2VFWAcn0JFQ4uv0K7Jaj7imRxPQlQstQOvpGw/wqvWZuq7UQUvB+hVadsH1nRDUtnjBJGQkH5xv3b0JhnlkdkwgpKBCt2jKsrGeVxnYk38cfgVuIfY8lfK2aVOjqFUGOiNkzBfpa6kfKOibxVI42mr1XLyhfUK+b1BnU+A7DQiODDMZ0qYDMqFocvNfp2pAfe9SlwSUPP+EAx5+EPtqL9XXP7R5c/bD8OCdkUHuWmH1HvdtgkhGCGQHbNtaEYhysIPVZpV8Yi6JEvXmqQgYu8wfTCcQMXtUV/yIBr6xgvbj26fQTfAOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/9iTfaxfTcnYc8YPZNodlKI4v6m4/uHAT4ZHAmep34=;
 b=HsguAn1tshBQfboSAr/bmyX8ViEj697Kgji58aFmTWqTnfBmoQ5oLU+hLyw+om8ygDa5044hbc1elwG7C6jMWNh80AO9ZmILWGJcJc/ffQLMxnmK//yvLSrgUEnCs7MAipm/HgDiJs4A01wLnWL3rjGdvTCaPTx2Mx06OcygGE028SfLWK7ZR/J9wRygQPgFz/EdgwI4UTpQrrtykTC6EHpOIFBpChJ+aqX4OsX83W6GFN8X63EMBLvOoJ7PUSOryQuBbt1O4F0cOWdD8Yx0wxeR/WcO3DH34maeFlxwIKwPq+mLY5dcitwYqP9VBGoHdDD8qIusS9pQ9I63OX25IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/9iTfaxfTcnYc8YPZNodlKI4v6m4/uHAT4ZHAmep34=;
 b=Kfy55T2ORkw7TcuspLPDIMF0luqX8s+zEn5UaotujyzvaKckf5NYGC2rjxiXSOnIVUxSpOjKqgPl4HKKDgsQAX7RkPNTzfOJKzS9dT8mQY1BWsQSrcErMYw1yAKH7bKJtdIzPpHIWb8A5o7X82mwN4UttJPXOm9zr7HP4B9/VYo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:44 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:44 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:42 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 26/65] staging: wfx: drop wfx_set_cts_work()
Thread-Topic: [PATCH 26/65] staging: wfx: drop wfx_set_cts_work()
Thread-Index: AQHVy50XS1F8Nym7N0mDF65g+7U93A==
Date:   Wed, 15 Jan 2020 12:12:43 +0000
Message-ID: <20200115121041.10863-27-Jerome.Pouiller@silabs.com>
References: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115121041.10863-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0009.eurprd09.prod.outlook.com
 (2603:10a6:101:16::21) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 54ecaa24-9037-4f26-e54f-08d799b439b2
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40960C8981336E216932A90793370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8WgcLhFgU1bgzIct20FbHbX+I1Gxq3H4gWzZGzL2KBFoXURgv/Whk2v3drRRzP5EVo0OQIvwIKs65hy1F5PifESJBCmglSkLE5KsvZfbM96uaeQ8NyAeFE5oJSpZ8hRig+6/8LyJi79dgPC/E97eT4AZf4RwKvKx/wI1ZA4aWOFNjMZ0gQIT5Z9VzcyqYQcF8OOTvOAaiOZ1A7vAw6iBZz6zXk0Y61i5RqfW1iRtDeX3tXhOyainvIfDrc+wLMtcox9kUIyvWrb0dTDy9agccVIJtuPmKzfKUMNSf6I05vDMKTNAOoPIYSt9FBBgbwzpn/uQwFykHMo1dVTnIaQTg2nq8tu4f1QEFotn8qEVYXlNHZAkPjXJ96PuCPtie8/g7Y96d0wX8PelWK7GBaJbMVAnlapRnyLee3Vx0bNif/jTSroMwAld5TguaDIGvpj9
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D529A718145244FBF40CCF6AF0153DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54ecaa24-9037-4f26-e54f-08d799b439b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:43.9201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DOeUhCNGSYgxmUQK0qSJVgs7icT/b2cqAnn/lSKWAJY6kvnhTFldHH34X717yYEG3QldDV0ghcz4Yfu5+6hZ8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2Jzc19pbmZvX2NoYW5nZWQoKSBpcyBub3QgY2FsbGVkIGZyb20gYXRvbWljIGNvbnRleHRzLiBT
bywgaXQgaXMgbm90Cm5lY2Vzc2FyeSB0byByYWlzZSBhbiBhc3luY2hyb25vdXMgd29yayB0byBj
aGFuZ2UgRVJQLiBUaHVzCndmeF9zZXRfY3RzX3dvcmsoKSBiZWNvbWUgdXNlbGVzcy4KClNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4K
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNDAgKysrKysrKysrLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIHwgIDIgLS0KIDIg
ZmlsZXMgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspLCAzMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
YwppbmRleCA3YWJlMjcyZGRjMGQuLmUwMmViYzM5ZWQ0MSAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC02NzEs
MjQgKzY3MSw2IEBAIGludCB3Znhfc3RhX3JlbW92ZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywg
c3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIHZvaWQg
d2Z4X3NldF9jdHNfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCi17Ci0Jc3RydWN0IHdm
eF92aWYgKnd2aWYgPSBjb250YWluZXJfb2Yod29yaywgc3RydWN0IHdmeF92aWYsIHNldF9jdHNf
d29yayk7Ci0JdTggZXJwX2llWzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9OwotCXN0
cnVjdCBoaWZfaWVfZmxhZ3MgdGFyZ2V0X2ZyYW1lID0gewotCQkuYmVhY29uID0gMSwKLQl9Owot
Ci0JbXV0ZXhfbG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7Ci0JZXJwX2llWzJdID0gd3Zp
Zi0+ZXJwX2luZm87Ci0JbXV0ZXhfdW5sb2NrKCZ3dmlmLT53ZGV2LT5jb25mX211dGV4KTsKLQot
CWhpZl9lcnBfdXNlX3Byb3RlY3Rpb24od3ZpZiwgZXJwX2llWzJdICYgV0xBTl9FUlBfVVNFX1BS
T1RFQ1RJT04pOwotCi0JaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBOTDgwMjExX0lGVFlQRV9TVEFU
SU9OKQotCQloaWZfdXBkYXRlX2llKHd2aWYsICZ0YXJnZXRfZnJhbWUsIGVycF9pZSwgc2l6ZW9m
KGVycF9pZSkpOwotfQotCiBzdGF0aWMgaW50IHdmeF9zdGFydF9hcChzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZikKIHsKIAlpbnQgcmV0OwpAQCAtODk2LDI0ICs4NzgsMjEgQEAgdm9pZCB3ZnhfYnNzX2lu
Zm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJfQogCX0KIAotCS8qIEVSUCBQ
cm90ZWN0aW9uICovCiAJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQyB8fAogCSAgICBj
aGFuZ2VkICYgQlNTX0NIQU5HRURfRVJQX0NUU19QUk9UIHx8CiAJICAgIGNoYW5nZWQgJiBCU1Nf
Q0hBTkdFRF9FUlBfUFJFQU1CTEUpIHsKLQkJdTMyIHByZXZfZXJwX2luZm8gPSB3dmlmLT5lcnBf
aW5mbzsKKwkJc3RydWN0IGhpZl9pZV9mbGFncyB0YXJnZXRfZnJhbWUgPSB7CisJCQkuYmVhY29u
ID0gMSwKKwkJfTsKKwkJdTggZXJwX2llWzNdID0geyBXTEFOX0VJRF9FUlBfSU5GTywgMSwgMCB9
OwogCisJCWhpZl9lcnBfdXNlX3Byb3RlY3Rpb24od3ZpZiwgaW5mby0+dXNlX2N0c19wcm90KTsK
IAkJaWYgKGluZm8tPnVzZV9jdHNfcHJvdCkKLQkJCXd2aWYtPmVycF9pbmZvIHw9IFdMQU5fRVJQ
X1VTRV9QUk9URUNUSU9OOwotCQllbHNlIGlmICghKHByZXZfZXJwX2luZm8gJiBXTEFOX0VSUF9O
T05fRVJQX1BSRVNFTlQpKQotCQkJd3ZpZi0+ZXJwX2luZm8gJj0gfldMQU5fRVJQX1VTRV9QUk9U
RUNUSU9OOwotCisJCQllcnBfaWVbMl0gfD0gV0xBTl9FUlBfVVNFX1BST1RFQ1RJT047CiAJCWlm
IChpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGUpCi0JCQl3dmlmLT5lcnBfaW5mbyB8PSBXTEFOX0VS
UF9CQVJLRVJfUFJFQU1CTEU7Ci0JCWVsc2UKLQkJCXd2aWYtPmVycF9pbmZvICY9IH5XTEFOX0VS
UF9CQVJLRVJfUFJFQU1CTEU7Ci0KLQkJaWYgKHByZXZfZXJwX2luZm8gIT0gd3ZpZi0+ZXJwX2lu
Zm8pCi0JCQlzY2hlZHVsZV93b3JrKCZ3dmlmLT5zZXRfY3RzX3dvcmspOworCQkJZXJwX2llWzJd
IHw9IFdMQU5fRVJQX0JBUktFUl9QUkVBTUJMRTsKKwkJaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKQorCQkJaGlmX3VwZGF0ZV9pZSh3dmlmLCAmdGFyZ2V0X2Zy
YW1lLCBlcnBfaWUsIHNpemVvZihlcnBfaWUpKTsKIAl9CiAKIAlpZiAoY2hhbmdlZCAmIEJTU19D
SEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfU0xPVCkKQEAgLTEyMzcs
NyArMTIxNiw2IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAljb21wbGV0ZSgmd3ZpZi0+c2V0X3BtX21v
ZGVfY29tcGxldGUpOwogCUlOSVRfV09SSygmd3ZpZi0+dXBkYXRlX2ZpbHRlcmluZ193b3JrLCB3
ZnhfdXBkYXRlX2ZpbHRlcmluZ193b3JrKTsKIAlJTklUX1dPUksoJnd2aWYtPmJzc19wYXJhbXNf
d29yaywgd2Z4X2Jzc19wYXJhbXNfd29yayk7Ci0JSU5JVF9XT1JLKCZ3dmlmLT5zZXRfY3RzX3dv
cmssIHdmeF9zZXRfY3RzX3dvcmspOwogCUlOSVRfV09SSygmd3ZpZi0+dW5qb2luX3dvcmssIHdm
eF91bmpvaW5fd29yayk7CiAJSU5JVF9XT1JLKCZ3dmlmLT50eF9wb2xpY3lfdXBsb2FkX3dvcmss
IHdmeF90eF9wb2xpY3lfdXBsb2FkX3dvcmspOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCA1ZTFhNzYzZWI0
YjUuLmY1NmE5MWVhMDgyZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAor
KysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC0xMDQsMTIgKzEwNCwxMCBAQCBzdHJ1
Y3Qgd2Z4X3ZpZiB7CiAJYm9vbAkJCWRpc2FibGVfYmVhY29uX2ZpbHRlcjsKIAlzdHJ1Y3Qgd29y
a19zdHJ1Y3QJdXBkYXRlX2ZpbHRlcmluZ193b3JrOwogCi0JdTMyCQkJZXJwX2luZm87CiAJdW5z
aWduZWQgbG9uZwkJdWFwc2RfbWFzazsKIAlzdHJ1Y3QgaWVlZTgwMjExX3R4X3F1ZXVlX3BhcmFt
cyBlZGNhX3BhcmFtc1tJRUVFODAyMTFfTlVNX0FDU107CiAJc3RydWN0IGhpZl9yZXFfc2V0X2Jz
c19wYXJhbXMgYnNzX3BhcmFtczsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJYnNzX3BhcmFtc193b3Jr
OwotCXN0cnVjdCB3b3JrX3N0cnVjdAlzZXRfY3RzX3dvcms7CiAKIAlpbnQJCQlqb2luX2NvbXBs
ZXRlX3N0YXR1czsKIAlzdHJ1Y3Qgd29ya19zdHJ1Y3QJdW5qb2luX3dvcms7Ci0tIAoyLjI1LjAK
Cg==
