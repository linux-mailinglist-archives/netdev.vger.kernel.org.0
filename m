Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9AB9123205
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfLQQPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:09 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728743AbfLQQPH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwNYF/bF5oDB5qaqo6aemRRlhWCospW5t/XsyrUCUL6LivIpbzOzgvr0TVy9GhQiqaRZEPzFph/JkFvnsMkQ6Ip06TD6EWfCixMQtChWzRWvpYwdfISTc+Z6nfOHBlljg+waxTKnhE0ZBUBVSCZ2ZYBYqyC/1Pf0/uJLJm9wFYxP8i3RDWDyKxh0hBXFCTaQgdo88bpmsvXbPyoxRe6UV7nzPcxodBoHAHYKkSU1s0yrCqecVJ+ZKt26QmUqXAULufXA5Ww8kjyUhkf3AtEX+CIHArNIK6h9a89DOPEhdNsL7GjV8+oL6scCfnRTECPRFKIN9gfcXyXOluCIy2Q9KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GTFV5SWac53s1xD0x1J89lUpDsz6huBwnt1RPa61zg=;
 b=dLL6Hw9KGuP2Ye1A/0LbH0qMC3P5PJUersOZWtztV0aFgg2YX6X1q4NmOC8KE94kQL0Kx3dqaEAIQlZvq8L9vM7Ky0GRguto71DD7mtEZlROhjV8sUVVGM1CccbpYndG9pLd7QvmaJhRgF1pqUyeeiRokcp3hFUT09FXU+g7t1LNIEG4f8IIH7AZO5kDbuzeo3L5HISP32jB+6xsshVNvDNJ0FkGi+VQIHkhTlESRBp6jYEIN4PuDAdMh6yBTtOsDGtCNRik/nICzI+ozvwVM7c5i1sbdiGxQP/55OsnhVg2cwi99sl7YcYHi5hVU36Qc+/Zqz8YkbZsYKKom/89zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GTFV5SWac53s1xD0x1J89lUpDsz6huBwnt1RPa61zg=;
 b=LZprxSUL9GjvEbQPv5hp380zmIxQWE47uSeZ9Vlw+CjaS15htlH8HEbznoFWY/J7nVw6u3Wj6PBA+u3pkX/+1jcvT2AbQWDAxvui9b9oNjiaoUt8wrHhD245d6SB9qe0Ip/6i1xgbVZH7Ris3mzkp84Puu/aVkQHpKvDJ5TjVfM=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:57 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:57 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 20/55] staging: wfx: make conditions easier to read
Thread-Topic: [PATCH v2 20/55] staging: wfx: make conditions easier to read
Thread-Index: AQHVtPUftxWFpzusskSHUCZVHaED9g==
Date:   Tue, 17 Dec 2019 16:14:56 +0000
Message-ID: <20191217161318.31402-21-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6559ceaa-b93a-4a9c-adf6-08d7830c4216
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3791A69499B1B86E84B71BCB93500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:376;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dR4TK0TLOEnTC9pFYokQA2cyqyZexjdKpF3hL2bWU3mZw92uCYtLAKaUkYpNXqG1rXkCIS0boD9j/XmhEkjZNSTrudc5anqMdlJPKa8AMxH5pvZmIU+Kq8kfuiulmrZikKPyDmkFRuhfbs1LiNmmjF8ZW8u3B1cmPro8CrEIh76UVeXxsUBEbE2AfQHPfUEUlicMUVfC32YDAle17KzBMlMHAGlzhYLJnVI+PWPRFtmcRVcGTvZR9BlYt1YFqdoR+Rn76AkbnUPz7w4YmWPbWIq2prpxKIvjdKMK9NnOxFroAUHvZLDG5YI1ApWXxot9w8zO/8jYrqm6UtDrXWGIvKtPdurvV6zPhIIIIOs286b5t4UhtaZSD0YP10QCca3BiHP7qg6su/moS8GLltnPIY8Y5QW7cD96lPl3zwPfv+78r/UiXWOdhPZhW4LMjCsQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <79F9E7C7A4645F45BCD9BE37D25F2B13@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6559ceaa-b93a-4a9c-adf6-08d7830c4216
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:56.9842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Hpw7gcpxV2c0/oG6ojV1Oep1ntQVkNdXm8WnfAtwMW7FDXhkmK0fTLTIuia2pMimpZIFTOhRWHo9OBVkuNbXEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2Ug
cHJlZmVyIHNlcmllcyBvZiBzaW1wbGUgYm9vbGVhbiBjb25kaXRpb25zIHRoYW4gY29tcHV0aW5n
IGJpdG1hc2tzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3Vp
bGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAyNyArKysr
KysrKysrKysrKystLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCsp
LCAxMiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCA0NzFkZDE1YjIyN2YuLjdmNGVhYThl
NmQ4NCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0xMDU1LDkgKzEwNTUsMTEgQEAgdm9pZCB3ZnhfYnNzX2lu
Zm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJfQogCX0KIAotCWlmIChjaGFu
Z2VkICYKLQkgICAgKEJTU19DSEFOR0VEX0JFQUNPTiB8IEJTU19DSEFOR0VEX0FQX1BST0JFX1JF
U1AgfAotCSAgICAgQlNTX0NIQU5HRURfQlNTSUQgfCBCU1NfQ0hBTkdFRF9TU0lEIHwgQlNTX0NI
QU5HRURfSUJTUykpIHsKKwlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0JFQUNPTiB8fAorCSAg
ICBjaGFuZ2VkICYgQlNTX0NIQU5HRURfQVBfUFJPQkVfUkVTUCB8fAorCSAgICBjaGFuZ2VkICYg
QlNTX0NIQU5HRURfQlNTSUQgfHwKKwkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX1NTSUQgfHwK
KwkgICAgY2hhbmdlZCAmIEJTU19DSEFOR0VEX0lCU1MpIHsKIAkJd3ZpZi0+YmVhY29uX2ludCA9
IGluZm8tPmJlYWNvbl9pbnQ7CiAJCXdmeF91cGRhdGVfYmVhY29uaW5nKHd2aWYpOwogCQl3Znhf
dXBsb2FkX2JlYWNvbih3dmlmKTsKQEAgLTEwOTUsMTAgKzEwOTcsMTEgQEAgdm9pZCB3ZnhfYnNz
X2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJaWYgKGNoYW5nZWQgJiBC
U1NfQ0hBTkdFRF9CU1NJRCkKIAkJCWRvX2pvaW4gPSB0cnVlOwogCi0JCWlmIChjaGFuZ2VkICYK
LQkJICAgIChCU1NfQ0hBTkdFRF9BU1NPQyB8IEJTU19DSEFOR0VEX0JTU0lEIHwKLQkJICAgICBC
U1NfQ0hBTkdFRF9JQlNTIHwgQlNTX0NIQU5HRURfQkFTSUNfUkFURVMgfAotCQkgICAgIEJTU19D
SEFOR0VEX0hUKSkgeworCQlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8CisJCSAg
ICBjaGFuZ2VkICYgQlNTX0NIQU5HRURfQlNTSUQgfHwKKwkJICAgIGNoYW5nZWQgJiBCU1NfQ0hB
TkdFRF9JQlNTIHx8CisJCSAgICBjaGFuZ2VkICYgQlNTX0NIQU5HRURfQkFTSUNfUkFURVMgfHwK
KwkJICAgIGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9IVCkgewogCQkJaWYgKGluZm8tPmFzc29jKSB7
CiAJCQkJaWYgKHd2aWYtPnN0YXRlIDwgV0ZYX1NUQVRFX1BSRV9TVEEpIHsKIAkJCQkJaWVlZTgw
MjExX2Nvbm5lY3Rpb25fbG9zcyh2aWYpOwpAQCAtMTEyMCw5ICsxMTIzLDkgQEAgdm9pZCB3Znhf
YnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAl9CiAKIAkvKiBFUlAg
UHJvdGVjdGlvbiAqLwotCWlmIChjaGFuZ2VkICYgKEJTU19DSEFOR0VEX0FTU09DIHwKLQkJICAg
ICAgIEJTU19DSEFOR0VEX0VSUF9DVFNfUFJPVCB8Ci0JCSAgICAgICBCU1NfQ0hBTkdFRF9FUlBf
UFJFQU1CTEUpKSB7CisJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9BU1NPQyB8fAorCSAgICBj
aGFuZ2VkICYgQlNTX0NIQU5HRURfRVJQX0NUU19QUk9UIHx8CisJICAgIGNoYW5nZWQgJiBCU1Nf
Q0hBTkdFRF9FUlBfUFJFQU1CTEUpIHsKIAkJdTMyIHByZXZfZXJwX2luZm8gPSB3dmlmLT5lcnBf
aW5mbzsKIAogCQlpZiAoaW5mby0+dXNlX2N0c19wcm90KQpAQCAtMTEzOSwxMCArMTE0MiwxMCBA
QCB2b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJ
c2NoZWR1bGVfd29yaygmd3ZpZi0+c2V0X2N0c193b3JrKTsKIAl9CiAKLQlpZiAoY2hhbmdlZCAm
IChCU1NfQ0hBTkdFRF9BU1NPQyB8IEJTU19DSEFOR0VEX0VSUF9TTE9UKSkKKwlpZiAoY2hhbmdl
ZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9FUlBfU0xPVCkK
IAkJaGlmX3Nsb3RfdGltZSh3dmlmLCBpbmZvLT51c2Vfc2hvcnRfc2xvdCA/IDkgOiAyMCk7CiAK
LQlpZiAoY2hhbmdlZCAmIChCU1NfQ0hBTkdFRF9BU1NPQyB8IEJTU19DSEFOR0VEX0NRTSkpIHsK
KwlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FTU09DIHx8IGNoYW5nZWQgJiBCU1NfQ0hBTkdF
RF9DUU0pIHsKIAkJc3RydWN0IGhpZl9taWJfcmNwaV9yc3NpX3RocmVzaG9sZCB0aCA9IHsKIAkJ
CS5yb2xsaW5nX2F2ZXJhZ2VfY291bnQgPSA4LAogCQkJLmRldGVjdGlvbiA9IDEsCi0tIAoyLjI0
LjAKCg==
