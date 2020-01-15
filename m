Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD6C13C3D5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgAONy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:58 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729593AbgAONy4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBvouFCR5c/7zo7uR8e4tAChJUHBy8/DMyLrAruYEoG2B7/Q5824A+f05DyG/Zh3soYWATWaHL9Tnjo0zdfWtwkrN/2YMRJE2EDPZIKkiDWlmw+iJ5fyE0MjfdgLP5LQ6QTQLW3nwbDmedOpdkcq+sP4DJVsNOlpwR7a9pqqFUTFdBEWzR+UzA/fh0Zl+VxfxkBs5c/FS4GeB1C1JmPBbbZFssDjfymIP90xIw/gZMVkVQW19F15pb4DuMG6PwNPaOOyq9yY1kXNIEg/JNpf9xBF8KrKz8wZqd6qcI9RrAZF1Ru7GTzrOOEwi6jiFRLkegELD34BIy/caG2hxenM3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjKAuLPHt5gNg/Eo1CFrDExKSrzLBhwAanAjvAIxEpw=;
 b=G1jYC2YRBXlLMcH5ud3pus73ZeXzpusXg9vtoBENwOux5dbxHqugkPoJDIO8EwooCGSxmeBmZgERpM0/cHwshyumvI9QsKuwTvEnf0Vls3MtodsGgnj+oZ4IupMqA+YILdXQfXDNOqAxVJg0w2G7zLMSuwzH/g74IvJByPjXKhnXzM4uxAZp+AQz9/Tj0OVKdMQRSdRbco71CBGS4cPur554K4sKr3UaVLs3meFPQnU4Q587ANozycExWC28dcqp/ZY+YPiT6F6+CblSGPMUYA/LIs72bvKqI4c/yJFjbK0gIgtVu/2aNjDbHnyotze0LhdhRuPKoGkzqa6ZQ8NcyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjKAuLPHt5gNg/Eo1CFrDExKSrzLBhwAanAjvAIxEpw=;
 b=QAsSU45mx9hebVmZVG6sDM+Jade8PW9SVuKDtjbWvtQyKbqNnqt4eee0/h4WgnKqAx8fAZZuoAPAMlMgLVP0pSp5L3SXle5QY3DohvG/YqUDjN9J32DMz7OMs8gxRBBBlwA5zMJud4Xm9MELjwH4OSdHDB5aFnN/BxmZndFZyu8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:38 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:38 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:37 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 25/65] staging: wfx: drop wvif->setbssparams_done
Thread-Topic: [PATCH v2 25/65] staging: wfx: drop wvif->setbssparams_done
Thread-Index: AQHVy6tT151hzhi3V0aXThOObsMaWQ==
Date:   Wed, 15 Jan 2020 13:54:38 +0000
Message-ID: <20200115135338.14374-26-Jerome.Pouiller@silabs.com>
References: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20200115135338.14374-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20)
 To MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.25.0
x-originating-ip: [2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9140b8a6-d657-409f-d364-08d799c27659
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094188945DA4BEA637E246993370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2958;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V/MEr8X8R2iOw/uCYtY+F/1o+wYY+qJe1kHH0EWznLz73lhU7JRczfo57zg/A/SHcOD91lUReqPCpmrt/lrVnDLOcUXy50pe8vuepKGtLf7lu99PD4fH853+g6i7E6OOFo01CFUUaWT+uIxDIYaeDmIY7AROA/fiMZB3ruhIEaM3VF9mUDnjhskdLpntCkQan5yyvwUP6dWDP3FmPUzFsE/DCZoaz1qo2aAMurz7CcH1x58S9ZHR1zE/qAi5oYxZMBynvNFza/YxaikX8GgT5tr5/OL23wat/o7lIPRGOdfCrI6TmcoDvc0ZfUxUYYi3M0WT1P5sSoIgQiELmNUDonr4VFiEy9VuNw4CPj/r3gXGlVzY7PuPTnE7/0vW7eKg1awmFgXkZfG5enVo6J/YxNiWoyXlcUySVHvukqBiRc3vIJJMK3aMxtfXU7LEMxzK
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E6E70C6E576E648A96EA30D450A6B09@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9140b8a6-d657-409f-d364-08d799c27659
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:38.6526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5nWjg8bYYqjduXj5YHqSWwR24/F7fad2pwr6UweHaMHquqxIGbn1APNTKALtRPmR1C+pbNpgyWim4KGBuAB1hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKc2V0
YnNzcGFyYW1zX2RvbmUgd2FzIGhlcmUgdG8gZW5zdXJlIHRoYXQgdGhlIGZpcm13YXJlIGRvZXMg
bm90IGVuYWJsZQpwb3dlcnNhdmUgYmVmb3JlIHRvIGdldCB0aGUgZmlyc3QgYmVhY29uLiBIb3dl
dmVyLCBtYWM4MDIxMSBhbHJlYWR5CmVuc3VyZXMgaXQgZ2V0cyBhIGJlYWNvbiBiZWZvcmUgdG8g
YXNzb2NpYXRlIHRvIHRoZSBCU1MuIEFuZCBldmVuLCBpZgppdCB3b24ndCwgdGhlIGZpcm13YXJl
IHdha2UgdXAgYXQgbGVhc3Qgb24gZXZlcnkgRFRJTSwgd2hpY2ggaXMKc3VmZmljaWVudCB0byBm
aW5hbGl6ZSB0aGUgYXNzb2NpYXRpb24uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyB8IDggKysrLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCAxIC0KIDIgZmls
ZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmlu
ZGV4IDAyMWRhYTlmN2EzMy4uN2FiZTI3MmRkYzBkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTMyNiw4ICsz
MjYsNyBAQCBpbnQgd2Z4X2NvbmZfdHgoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBp
ZWVlODAyMTFfdmlmICp2aWYsCiAJaGlmX3NldF9lZGNhX3F1ZXVlX3BhcmFtcyh3dmlmLCBxdWV1
ZSwgcGFyYW1zKTsKIAlpZiAod3ZpZi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJ
T04pIHsKIAkJaGlmX3NldF91YXBzZF9pbmZvKHd2aWYsIHd2aWYtPnVhcHNkX21hc2spOwotCQlp
ZiAod3ZpZi0+c2V0YnNzcGFyYW1zX2RvbmUgJiYgd3ZpZi0+c3RhdGUgPT0gV0ZYX1NUQVRFX1NU
QSkKLQkJCXJldCA9IHdmeF91cGRhdGVfcG0od3ZpZik7CisJCXdmeF91cGRhdGVfcG0od3ZpZik7
CiAJfQogCW11dGV4X3VubG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAJcmV0dXJuIHJldDsKQEAg
LTQ3NSw3ICs0NzQsNiBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fdW5qb2luKHN0cnVjdCB3Znhfdmlm
ICp3dmlmKQogCXd2aWYtPmRpc2FibGVfYmVhY29uX2ZpbHRlciA9IGZhbHNlOwogCXdmeF91cGRh
dGVfZmlsdGVyaW5nKHd2aWYpOwogCW1lbXNldCgmd3ZpZi0+YnNzX3BhcmFtcywgMCwgc2l6ZW9m
KHd2aWYtPmJzc19wYXJhbXMpKTsKLQl3dmlmLT5zZXRic3NwYXJhbXNfZG9uZSA9IGZhbHNlOwog
CiBkb25lOgogCW11dGV4X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CkBAIC03OTks
NyArNzk3LDYgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYg
Knd2aWYsCiAJaWYgKCFpbmZvLT5pYnNzX2pvaW5lZCkgewogCQloaWZfa2VlcF9hbGl2ZV9wZXJp
b2Qod3ZpZiwgMzAgLyogc2VjICovKTsKIAkJaGlmX3NldF9ic3NfcGFyYW1zKHd2aWYsICZ3dmlm
LT5ic3NfcGFyYW1zKTsKLQkJd3ZpZi0+c2V0YnNzcGFyYW1zX2RvbmUgPSB0cnVlOwogCQloaWZf
c2V0X2JlYWNvbl93YWtldXBfcGVyaW9kKHd2aWYsIGluZm8tPmR0aW1fcGVyaW9kLAogCQkJCQkg
ICAgIGluZm8tPmR0aW1fcGVyaW9kKTsKIAkJd2Z4X3VwZGF0ZV9wbSh3dmlmKTsKQEAgLTEyMjQs
NyArMTIyMSw4IEBAIGludCB3ZnhfYWRkX2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZikKIAlJTklUX1dPUksoJnd2aWYtPm1jYXN0X3N0
b3Bfd29yaywgd2Z4X21jYXN0X3N0b3Bfd29yayk7CiAJdGltZXJfc2V0dXAoJnd2aWYtPm1jYXN0
X3RpbWVvdXQsIHdmeF9tY2FzdF90aW1lb3V0LCAwKTsKIAotCXd2aWYtPnNldGJzc3BhcmFtc19k
b25lID0gZmFsc2U7CisJbWVtc2V0KCZ3dmlmLT5ic3NfcGFyYW1zLCAwLCBzaXplb2Yod3ZpZi0+
YnNzX3BhcmFtcykpOworCiAJbXV0ZXhfaW5pdCgmd3ZpZi0+YnNzX2xvc3NfbG9jayk7CiAJSU5J
VF9ERUxBWUVEX1dPUksoJnd2aWYtPmJzc19sb3NzX3dvcmssIHdmeF9ic3NfbG9zc193b3JrKTsK
IApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvd2Z4LmgKaW5kZXggMWI0ODdkOTZlY2EyLi41ZTFhNzYzZWI0YjUgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aApAQCAtMTA1LDcgKzEwNSw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlzdHJ1Y3Qgd29ya19zdHJ1
Y3QJdXBkYXRlX2ZpbHRlcmluZ193b3JrOwogCiAJdTMyCQkJZXJwX2luZm87Ci0JYm9vbAkJCXNl
dGJzc3BhcmFtc19kb25lOwogCXVuc2lnbmVkIGxvbmcJCXVhcHNkX21hc2s7CiAJc3RydWN0IGll
ZWU4MDIxMV90eF9xdWV1ZV9wYXJhbXMgZWRjYV9wYXJhbXNbSUVFRTgwMjExX05VTV9BQ1NdOwog
CXN0cnVjdCBoaWZfcmVxX3NldF9ic3NfcGFyYW1zIGJzc19wYXJhbXM7Ci0tIAoyLjI1LjAKCg==
