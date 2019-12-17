Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D41B51231F8
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbfLQQTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:19:07 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:6496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728707AbfLQQPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DvDDmHzaApdi2VW2QlCJEOqkn8v/oTe6TppNiUAQcSkrBwYLywDij1FsuKYaasp31Lx26Iia0ZfQwdPdENkaT1tddHV15CdURanW6Ewssori/eK5Y9iBZN2/ou5+gJVDbfG1QGAPIItjVwv0N8SQNdVaKaW1y2IL2mJjJbdNnPpHzUEDqFtWvbsU11OZpsrFqDWX2YVJwLkitBOt4wQr0MytupXffOf7hgBAUJ+y85r8AINKg7hl/uSNCKwuekdT8mlhUSZoOW5wcIyVysUiDReOXUOhZWxMk5L2FF+bu0I+nOPmTG/t8aPYvB+mLHK8a+9MXhcPlEgM/PQx7t5CvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nWAnv+qpHBHZEfgEkRrgWIwRNoZUxsON81aiF6xIKo=;
 b=Oi5DAX5AC5lOkqImfFLXZZHvqnmeKwwpawrpuf64gEtU/HkRUU8itWu0/AJ5Qvs0OSfzxzJt8DxL4QGCceyIANGbUjegbn7xsf0Cdhup5ps6Avf0+u62EFRz/9IutgLBLNI6/fSbeNuGoYzNpfjQW13bbkqn/v5Nnu6V4sYwjRU3F+DPwXgrUA7SsjGW24zfpopAoyoyAHrTa21xHTZTZinqKQBvhq3otNinPCF7V8logn6QUEZKB0SokwkOsfN/Fnama7Qz5HW4v72pYOzEKwAi30WtRrewv8MBi3+lj2j7rI4B8YT01eXyAgm5aHCxw1WMqT5VgVPexnc7grC4ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nWAnv+qpHBHZEfgEkRrgWIwRNoZUxsON81aiF6xIKo=;
 b=BLYlqaLsFdoovrp0Aq4t3zkEWOm2GTLARuEAYwuqi3Z9ZLNkajgFSudnkxBTaXo6ztq9FSyqieQumkQUuRsDh1032KQwZlC7SUjrjJv5yfTf4z7wA09vfOOaYaYloUhcnUEVT+06Swj7zOfhChGEWB8PX1RheRFOrnzXZcjv1Vw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:40 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:40 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 31/55] staging: wfx: declare wfx_set_pm() static
Thread-Topic: [PATCH v2 31/55] staging: wfx: declare wfx_set_pm() static
Thread-Index: AQHVtPUomNvdF9c8U06XszlJrpgzug==
Date:   Tue, 17 Dec 2019 16:15:11 +0000
Message-ID: <20191217161318.31402-32-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 135d5509-bd38-48f6-5616-08d7830c4a80
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB420830CCFC0B35BF9A75FBF793500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lav8zDhbJ9zi7PJuf3gJZ1rF5cJFuQu2rUkvpm3VZPfHdFjhBIOQjtc1OKQdtNaJcsgqPdyRdshlEe4nCSixFi1mb/CY7M1SqpKFMjQlO2OrQykYTJpWrkf9o11G8ltXAPUprIAqYnl4uMCwh3QbE/51dVbizWTfEG4qp8ZV2RcCdqGS3GL1cwOMgklvLJ2kXGjZwVzzVuW/ok7OKJRZnmPZ+LDXXNPwvKtXMFZfQGzKZfnNqZuN7Ae6QHh5az2Umg6dUh6l4CfyRmHWpUbaG3oTy7f9ON1T3dth+Y05BE8QSWghuxkTLSPOJ0ibuqBf9h1ESjqYDv1H4K7ag+/iiOC5Kk1GpBp2wahHUSLd3lzrnCVrYJFjCBGPUQvMiD8IiAH+beCqnyoT4D2xp1nsYpidrigHnRMcl557Z/Saq4nZ3BlrT3sdW6wOitdhAea4
Content-Type: text/plain; charset="utf-8"
Content-ID: <E211FA957536EA429954995A87FD08FF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135d5509-bd38-48f6-5616-08d7830c4a80
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:11.1254
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9aLdogLEVfxVkdGidZrZasyKNRTj3Dygsh4T3rMpqTxVDgXF0ek4Ievwijk4qCtwjpI3yOyn2u+7m8KTnq51vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3NldF9wbSgpIGlzIG5vdyBvbmx5IHVzZWQgYnkgc3RhLmMuIEl0IGNhbiBiZSBkZWNsYXJlZCBz
dGF0aWMuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVy
QHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8IDU3ICsrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
aCB8ICAxIC0KIDIgZmlsZXMgY2hhbmdlZCwgMzAgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKaW5kZXggZmI0NWFhNjZmYzU2Li5lYjA4N2I5YzgwOTcgMTAwNjQ0Ci0t
LSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYwpAQCAtMzI2LDYgKzMyNiwzNiBAQCB2b2lkIHdmeF9jb25maWd1cmVfZmlsdGVyKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3LAogCX0KIH0KIAorc3RhdGljIGludCB3Znhfc2V0X3BtKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLAorCQkgICAgICBjb25zdCBzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9k
ZSAqYXJnKQoreworCXN0cnVjdCBoaWZfcmVxX3NldF9wbV9tb2RlIHBtID0gKmFyZzsKKwl1MTYg
dWFwc2RfZmxhZ3M7CisJaW50IHJldDsKKworCWlmICh3dmlmLT5zdGF0ZSAhPSBXRlhfU1RBVEVf
U1RBIHx8ICF3dmlmLT5ic3NfcGFyYW1zLmFpZCkKKwkJcmV0dXJuIDA7CisKKwltZW1jcHkoJnVh
cHNkX2ZsYWdzLCAmd3ZpZi0+dWFwc2RfaW5mbywgc2l6ZW9mKHVhcHNkX2ZsYWdzKSk7CisKKwlp
ZiAodWFwc2RfZmxhZ3MgIT0gMCkKKwkJcG0ucG1fbW9kZS5mYXN0X3BzbSA9IDA7CisKKwkvLyBL
ZXJuZWwgZGlzYWJsZSBQb3dlclNhdmUgd2hlbiBtdWx0aXBsZSB2aWZzIGFyZSBpbiB1c2UuIElu
IGNvbnRyYXJ5LAorCS8vIGl0IGlzIGFic29sdXRseSBuZWNlc3NhcnkgdG8gZW5hYmxlIFBvd2Vy
U2F2ZSBmb3IgV0YyMDAKKwkvLyBGSVhNRTogb25seSBpZiBjaGFubmVsIHZpZjAgIT0gY2hhbm5l
bCB2aWYxCisJaWYgKHd2aWZfY291bnQod3ZpZi0+d2RldikgPiAxKSB7CisJCXBtLnBtX21vZGUu
ZW50ZXJfcHNtID0gMTsKKwkJcG0ucG1fbW9kZS5mYXN0X3BzbSA9IDA7CisJfQorCisJaWYgKCF3
YWl0X2Zvcl9jb21wbGV0aW9uX3RpbWVvdXQoJnd2aWYtPnNldF9wbV9tb2RlX2NvbXBsZXRlLAor
CQkJCQkgbXNlY3NfdG9famlmZmllcygzMDApKSkKKwkJZGV2X3dhcm4od3ZpZi0+d2Rldi0+ZGV2
LAorCQkJICJ0aW1lb3V0IHdoaWxlIHdhaXRpbmcgb2Ygc2V0X3BtX21vZGVfY29tcGxldGVcbiIp
OworCXJldHVybiBoaWZfc2V0X3BtKHd2aWYsICZwbSk7Cit9CisKIGludCB3ZnhfY29uZl90eChz
dHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJICAg
dTE2IHF1ZXVlLCBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX3R4X3F1ZXVlX3BhcmFtcyAqcGFyYW1z
KQogewpAQCAtMzcxLDMzICs0MDEsNiBAQCBpbnQgd2Z4X2NvbmZfdHgoc3RydWN0IGllZWU4MDIx
MV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJcmV0dXJuIHJldDsKIH0KIAot
aW50IHdmeF9zZXRfcG0oc3RydWN0IHdmeF92aWYgKnd2aWYsIGNvbnN0IHN0cnVjdCBoaWZfcmVx
X3NldF9wbV9tb2RlICphcmcpCi17Ci0Jc3RydWN0IGhpZl9yZXFfc2V0X3BtX21vZGUgcG0gPSAq
YXJnOwotCXUxNiB1YXBzZF9mbGFnczsKLQotCWlmICh3dmlmLT5zdGF0ZSAhPSBXRlhfU1RBVEVf
U1RBIHx8ICF3dmlmLT5ic3NfcGFyYW1zLmFpZCkKLQkJcmV0dXJuIDA7Ci0KLQltZW1jcHkoJnVh
cHNkX2ZsYWdzLCAmd3ZpZi0+dWFwc2RfaW5mbywgc2l6ZW9mKHVhcHNkX2ZsYWdzKSk7Ci0KLQlp
ZiAodWFwc2RfZmxhZ3MgIT0gMCkKLQkJcG0ucG1fbW9kZS5mYXN0X3BzbSA9IDA7Ci0KLQkvLyBL
ZXJuZWwgZGlzYWJsZSBQb3dlclNhdmUgd2hlbiBtdWx0aXBsZSB2aWZzIGFyZSBpbiB1c2UuIElu
IGNvbnRyYXJ5LAotCS8vIGl0IGlzIGFic29sdXRseSBuZWNlc3NhcnkgdG8gZW5hYmxlIFBvd2Vy
U2F2ZSBmb3IgV0YyMDAKLQlpZiAod3ZpZl9jb3VudCh3dmlmLT53ZGV2KSA+IDEpIHsKLQkJcG0u
cG1fbW9kZS5lbnRlcl9wc20gPSAxOwotCQlwbS5wbV9tb2RlLmZhc3RfcHNtID0gMDsKLQl9Ci0K
LQlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3ZpZi0+c2V0X3BtX21vZGVfY29t
cGxldGUsCi0JCQkJCSBtc2Vjc190b19qaWZmaWVzKDMwMCkpKQotCQlkZXZfd2Fybih3dmlmLT53
ZGV2LT5kZXYsCi0JCQkgInRpbWVvdXQgd2hpbGUgd2FpdGluZyBvZiBzZXRfcG1fbW9kZV9jb21w
bGV0ZVxuIik7Ci0JcmV0dXJuIGhpZl9zZXRfcG0od3ZpZiwgJnBtKTsKLX0KLQogaW50IHdmeF9z
ZXRfcnRzX3RocmVzaG9sZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdTMyIHZhbHVlKQogewog
CXN0cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gaHctPnByaXY7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaAppbmRleCA3MjFiN2Nl
ZTljMTAuLjQ3MTk4MDdiYzI1YSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
aAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCkBAIC05Nyw3ICs5Nyw2IEBAIHZvaWQg
d2Z4X3N1c3BlbmRfcmVzdW1lKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogLy8gT3RoZXIgSGVscGVy
cwogdm9pZCB3ZnhfY3FtX2Jzc2xvc3Nfc20oc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBpbml0
LCBpbnQgZ29vZCwgaW50IGJhZCk7CiB2b2lkIHdmeF91cGRhdGVfZmlsdGVyaW5nKHN0cnVjdCB3
ZnhfdmlmICp3dmlmKTsKLWludCB3Znhfc2V0X3BtKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBjb25z
dCBzdHJ1Y3QgaGlmX3JlcV9zZXRfcG1fbW9kZSAqYXJnKTsKIGludCB3ZnhfZndkX3Byb2JlX3Jl
cShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFibGUpOwogCiAjZW5kaWYgLyogV0ZYX1NU
QV9IICovCi0tIAoyLjI0LjAKCg==
