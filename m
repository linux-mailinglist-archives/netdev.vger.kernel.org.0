Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F194713BFB7
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731575AbgAOMPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:15:43 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:28929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731538AbgAOMNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXmQbNOXPkWCp7E6tQ1eFaxo5KVu8VhQcVHeCBJ+UXNcCfO5VGeDDj76d5whGmYVV+p79o6Eyzcb1+dcU8RV4NRgHnqfCdIXy4QY0kBtBA8+Zt5k9W21iGuSXspgblsEAup1TjbUji0A9EgA3F38uIencBWfw/KpaHNZRFRIf1KUV+FVI+/r7yM93JmYtA6IncY1n43gQQ4bS4NzpEdQUp2vcfRhoA/7EM2PGIojBGLylfyvdlMBPK/Ny8F6JwtJcU0O6PYymzC2wC81Ne9b5U+Nr1n7G9UF3dvWfun/GWyfNRlG5HqrwT/ZXEA9EH6EO6JTzH7wZhI1d1AQAisGgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzh1e1358l4KeQ62pZnLo1Vb2AqkkwvyM03nJIeYgK8=;
 b=dHbhiwv9q7H/N6P5CRdJx0ekcsnFVZjYv/N+wwdbbZCw6VVY/MLrvV/AOO2hSOXQzpGV7YkqCK1gzyz9Whn/xEg2fduDXw+uCKpeIJhH2qVWzVXjbETY00B6x4aytknwmhmdT0aeTqWbLQ9vGlZMzDHQhmNOYAGU0fT3b3zrQg6wYDqKZ0bJgJ5BQHhu80lhfO5520A257D6dZEMDaabEvO3kDrFZF+vi41hcq/i47FYzosA6uKHgmGkLRJn28rC4/fZzYMQzvcwkCw4sHepc+rZ7g4yvbOGszTbgzBq8K/bXo10LIJUsjV3S8Hpwvy667BMCwRoJFYTnx+nso88Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uzh1e1358l4KeQ62pZnLo1Vb2AqkkwvyM03nJIeYgK8=;
 b=Mb8ynQrAEzfsbNfUuzc+BuDjRcK+E87n14P/nnDdWVaKk0z6qaeWsRsiVLeW624hEKF5NEU/v0syjy7mqBvn5fbp8ICaOWTIxqXU4eIFQtrqWO2ZgFws5/tMhfmPowyB+LGIRYrVX469r1nHTNdqq2utCIydYd7L1hkhlm7QU5Q=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:28 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:28 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:07 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 45/65] staging: wfx: remove handling of "early_data"
Thread-Topic: [PATCH 45/65] staging: wfx: remove handling of "early_data"
Thread-Index: AQHVy50meZbmnDLbNEm11vC0VJj28w==
Date:   Wed, 15 Jan 2020 12:13:09 +0000
Message-ID: <20200115121041.10863-46-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 8c4d5665-08d3-4df4-ada7-08d799b448ab
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39346551AC8E327E5EE5C03A93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:265;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hHfOD4EGUtM7+lN7cyTV+Hf5YX2OOB6MWWssJA6yAPQwDsk7W0jtVzFCozH5Firv08EMA6nEi0LMD0/OSswzc5atXf80PHXNuivEcHqIeZZAAWSYwcLm3cdObqEz0htd36ZyfGKy3e7St5sSSUSAWd8w5YJNm3WuluP7zcTr4wJX9NXuQ8vX0d3B1+jbUqXjiRoHNBwfAGf9JtFD11TUxuqnvbkRMALFwOWCwiKDk7WWz4u/EeD5qplCpBKJ8vZafMXvMmNFPadA/QEM5h3BdP86NRxixQDKXTzSRlbVsleAIueBejZz9LDJNAIxHtRpFVR2DgxsxdaGeDVwLA793G4lxXyEzDbgzOygsIWzLBvfgYZmwg8p4diekmBY558qSmhcB+Mo60RhLV1gW7vYiBEqiWoyUfYJWcNrKVaiElwus20eloB8W00CS08TQU58
Content-Type: text/plain; charset="utf-8"
Content-ID: <2098199893BB864A869D1A9E07D937D5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c4d5665-08d3-4df4-ada7-08d799b448ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:09.0447
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OWnyqF7Q7IBxcO8UW2UJoyQzLjZIAS2ljGAXFygrTTn/+1lBTjKZT4dEREYgwJb8EMY9DTE3iU3qVhnDs6Lisg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
c2VlbXMgdGhhdCBwdXJwb3NlIG9mICJlYXJseV9kYXRhIiB3YXMgdG8gcHJldmVudCBzZW5kaW5n
IGRhdGEgdG8KbWFjODAyMTEgYmVmb3JlIHN0YXRpb24gd2FzIGNvbXBsZXRlbHkgYXNzb2NpYXRl
ZC4gSXQgaXMgYSB1c2VsZXNzCnByZWNhdXRpb24uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3J4LmMgfCAxNyArLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3R4LmMgfCAgMyAtLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIHwgIDEg
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgfCAgMyAtLS0KIDQgZmlsZXMgY2hhbmdl
ZCwgMSBpbnNlcnRpb24oKyksIDIzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV9yeC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKaW5k
ZXggMGFiNzFjOTExZjg0Li5lMjZiYzY2NWIyYjMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvZGF0YV9yeC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5jCkBAIC0x
MDgsNyArMTA4LDYgQEAgdm9pZCB3ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJc3Ry
dWN0IGllZWU4MDIxMV9oZHIgKmZyYW1lID0gKHN0cnVjdCBpZWVlODAyMTFfaGRyICopc2tiLT5k
YXRhOwogCXN0cnVjdCBpZWVlODAyMTFfbWdtdCAqbWdtdCA9IChzdHJ1Y3QgaWVlZTgwMjExX21n
bXQgKilza2ItPmRhdGE7CiAJc3RydWN0IHdmeF9saW5rX2VudHJ5ICplbnRyeSA9IE5VTEw7Ci0J
Ym9vbCBlYXJseV9kYXRhID0gZmFsc2U7CiAKIAltZW1zZXQoaGRyLCAwLCBzaXplb2YoKmhkcikp
OwogCkBAIC0xMjEsOSArMTIwLDYgQEAgdm9pZCB3ZnhfcnhfY2Ioc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAJaWYgKGxpbmtfaWQgJiYgbGlua19pZCA8PSBXRlhfTUFYX1NUQV9JTl9BUF9NT0RFKSB7
CiAJCWVudHJ5ID0gJnd2aWYtPmxpbmtfaWRfZGJbbGlua19pZCAtIDFdOwogCQllbnRyeS0+dGlt
ZXN0YW1wID0gamlmZmllczsKLQkJaWYgKGVudHJ5LT5zdGF0dXMgPT0gV0ZYX0xJTktfU09GVCAm
JgotCQkgICAgaWVlZTgwMjExX2lzX2RhdGEoZnJhbWUtPmZyYW1lX2NvbnRyb2wpKQotCQkJZWFy
bHlfZGF0YSA9IHRydWU7CiAJfQogCiAJaWYgKGFyZy0+c3RhdHVzID09IEhJRl9TVEFUVVNfTUlD
RkFJTFVSRSkKQEAgLTE4MSwxOCArMTc3LDcgQEAgdm9pZCB3ZnhfcnhfY2Ioc3RydWN0IHdmeF92
aWYgKnd2aWYsCiAJCQlzY2hlZHVsZV93b3JrKCZ3dmlmLT51cGRhdGVfZmlsdGVyaW5nX3dvcmsp
OwogCQl9CiAJfQotCi0JaWYgKGVhcmx5X2RhdGEpIHsKLQkJc3Bpbl9sb2NrX2JoKCZ3dmlmLT5w
c19zdGF0ZV9sb2NrKTsKLQkJLyogRG91YmxlLWNoZWNrIHN0YXR1cyB3aXRoIGxvY2sgaGVsZCAq
LwotCQlpZiAoZW50cnktPnN0YXR1cyA9PSBXRlhfTElOS19TT0ZUKQotCQkJc2tiX3F1ZXVlX3Rh
aWwoJmVudHJ5LT5yeF9xdWV1ZSwgc2tiKTsKLQkJZWxzZQotCQkJaWVlZTgwMjExX3J4X2lycXNh
ZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7Ci0JCXNwaW5fdW5sb2NrX2JoKCZ3dmlmLT5wc19zdGF0
ZV9sb2NrKTsKLQl9IGVsc2UgewotCQlpZWVlODAyMTFfcnhfaXJxc2FmZSh3dmlmLT53ZGV2LT5o
dywgc2tiKTsKLQl9CisJaWVlZTgwMjExX3J4X2lycXNhZmUod3ZpZi0+d2Rldi0+aHcsIHNrYik7
CiAKIAlyZXR1cm47CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggNzA0ZWJmZTFjZDA1Li5lNjY5
ZmM0NDg1ZTYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC0yOTIsNyArMjkyLDYgQEAgc3RhdGlj
IGludCB3ZnhfYWxsb2NfbGlua19pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3QgdTggKm1h
YykKIAkJZW50cnktPnN0YXR1cyA9IFdGWF9MSU5LX1JFU0VSVkU7CiAJCWV0aGVyX2FkZHJfY29w
eShlbnRyeS0+bWFjLCBtYWMpOwogCQltZW1zZXQoJmVudHJ5LT5idWZmZXJlZCwgMCwgV0ZYX01B
WF9USUQpOwotCQlza2JfcXVldWVfaGVhZF9pbml0KCZlbnRyeS0+cnhfcXVldWUpOwogCQl3Znhf
dHhfbG9jayh3dmlmLT53ZGV2KTsKIAogCQlpZiAoIXNjaGVkdWxlX3dvcmsoJnd2aWYtPmxpbmtf
aWRfd29yaykpCkBAIC00MDAsOCArMzk5LDYgQEAgdm9pZCB3ZnhfbGlua19pZF9nY193b3JrKHN0
cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKIAkJCQluZXh0X2djID0gbWluX3QodW5zaWduZWQgbG9u
ZywgbmV4dF9nYywgdHRsKTsKIAkJCX0KIAkJfQotCQlpZiAobmVlZF9yZXNldCkKLQkJCXNrYl9x
dWV1ZV9wdXJnZSgmd3ZpZi0+bGlua19pZF9kYltpXS5yeF9xdWV1ZSk7CiAJfQogCXNwaW5fdW5s
b2NrX2JoKCZ3dmlmLT5wc19zdGF0ZV9sb2NrKTsKIAlpZiAobmV4dF9nYyAhPSAtMSkKZGlmZiAt
LWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9kYXRhX3R4LmgKaW5kZXggMDc4ZDBjZmM1MjFhLi41NDczOGMyZTNlYWMgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
ZGF0YV90eC5oCkBAIC0zNCw3ICszNCw2IEBAIHN0cnVjdCB3ZnhfbGlua19lbnRyeSB7CiAJdTgJ
CQltYWNbRVRIX0FMRU5dOwogCXU4CQkJb2xkX21hY1tFVEhfQUxFTl07CiAJdTgJCQlidWZmZXJl
ZFtXRlhfTUFYX1RJRF07Ci0Jc3RydWN0IHNrX2J1ZmZfaGVhZAlyeF9xdWV1ZTsKIH07CiAKIHN0
cnVjdCB0eF9wb2xpY3kgewpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBi
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNmE0M2RlY2Q1YWU2Li40YTQ0ZDcyZjBk
YjEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYwpAQCAtNTcxLDcgKzU3MSw2IEBAIGludCB3Znhfc3RhX2FkZChzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiA9IChzdHJ1Y3Qgd2Z4X3ZpZiAqKSB2aWYtPmRydl9wcml2OwogCXN0cnVj
dCB3Znhfc3RhX3ByaXYgKnN0YV9wcml2ID0gKHN0cnVjdCB3Znhfc3RhX3ByaXYgKikgJnN0YS0+
ZHJ2X3ByaXY7CiAJc3RydWN0IHdmeF9saW5rX2VudHJ5ICplbnRyeTsKLQlzdHJ1Y3Qgc2tfYnVm
ZiAqc2tiOwogCiAJaWYgKHd2aWYtPnZpZi0+dHlwZSAhPSBOTDgwMjExX0lGVFlQRV9BUCkKIAkJ
cmV0dXJuIDA7CkBAIC01ODksOCArNTg4LDYgQEAgaW50IHdmeF9zdGFfYWRkKHN0cnVjdCBpZWVl
ODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCQkJCQlJRUVFODAyMTFf
V01NX0lFX1NUQV9RT1NJTkZPX0FDX01BU0spCiAJCXd2aWYtPnN0YV9hc2xlZXBfbWFzayB8PSBC
SVQoc3RhX3ByaXYtPmxpbmtfaWQpOwogCWVudHJ5LT5zdGF0dXMgPSBXRlhfTElOS19IQVJEOwot
CXdoaWxlICgoc2tiID0gc2tiX2RlcXVldWUoJmVudHJ5LT5yeF9xdWV1ZSkpKQotCQlpZWVlODAy
MTFfcnhfaXJxc2FmZSh3ZGV2LT5odywgc2tiKTsKIAlzcGluX3VubG9ja19iaCgmd3ZpZi0+cHNf
c3RhdGVfbG9jayk7CiAJcmV0dXJuIDA7CiB9Ci0tIAoyLjI1LjAKCg==
