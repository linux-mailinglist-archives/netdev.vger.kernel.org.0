Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C481231EA
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfLQQSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:18:34 -0500
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:6164
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728959AbfLQQPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PaoJZGR/y8WR5PuoajiMbvyW9R5WrwLQyiCA7489ISX47WErEgC4zYKe/TxN5fgsDuk1MVufLMUrbiPeMz+qXqCUTbmVYq8QJqbUA+/o4Uln9ftQ6WcsbmLHh1F3mEDVZkzUOBdjaVA1abcwq/m/ijeRdFATqsZR3FIbwodpsjRZZ1+maKwUjvHzAMpD9WhV+OQXtlru1Knhwjbu53gNvmKXSNXRMH9IoH5F2ROLxagxt4dkpGN6Q4EYhtAVdnXcT3uXIsqNfg7XV4vYdUdCynAVUNmAbJdFQj1f9h0IGYmKlloaUiL1UTw7m9v+Vh6ugloOktR1xQBYf/+nTaFRaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6JE+ScPoQgbxTngVfkGUoTAsmuuz8DyIHnJzKHImn0=;
 b=bgelZaT6lBKBePakoWxjr9dNIYz22d56k+mt7bN1tiW2UCoW7y4u9KbiQgwQWMsp3SNOsXiVvaraIuFhHBqdTEYxKPfvJOeNyNfRNJIt18VoIkU4AhdIwr+SHXq00Ca60Zr6mNU4A9gZCf/qYGyGuxlhO4ZXn53jxTH9Ric6vVq5yCZqswZb379nJBxzcPuF7oy+C/CskyzldtqgLdYGDRA+WHAsRSxV0YDSo6R6/sz8xvpIVnoVjarsVW99GopK1s2uEDfj/UL1+NsYR5qdcG6zatCI271AHtwpb+7IcvSEfhFn2hGygboZlk6oS5qJPezUC9/5luRQIp0vodlSTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d6JE+ScPoQgbxTngVfkGUoTAsmuuz8DyIHnJzKHImn0=;
 b=cJurI9kj/g4sXdGCtalPj65FNrK8NmridCgJuloq1wGTw8zDnzak8p0drnd2pS9EjtZirdiOymB+cymt61/Dkm0CKRkz3XXiv1ufkbkHO6zW/GU0G8iPLTmeHITr1BQ6jmG5yJKUWaiPHjzsH3GXo5NQgoXgYmU3nPGM/xn//yM=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:43 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:43 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 37/55] staging: wfx: simplify wfx_conf_tx()
Thread-Topic: [PATCH v2 37/55] staging: wfx: simplify wfx_conf_tx()
Thread-Index: AQHVtPUsL868vn81/0yJsYaLr+/fgQ==
Date:   Tue, 17 Dec 2019 16:15:19 +0000
Message-ID: <20191217161318.31402-38-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: b68acbf3-b2e4-4097-e66c-08d7830c4f5e
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB42084D8B65BE66ADDC30895193500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S4PmgccgZEOB0PqA9Pdx9A8/O6uGj4XSFTn18KP48fTtQwQ88ijVtBsMuZL/TPR08phNl3TY0nSfFAzdjRcea+TGLVi+212dV4fs93ZX5V89FdO6HeUWL6RkxKu6Ht/3Xatr2PLEfi7g0/eJQjbc4kRMtqYx0N+COT226q1DsiH91QHq1v35QeHMP2fjYhO6ODqus+AuayPfah6HAUOT6iAGcxGd2fNf5q+X6wifSb4aTSYcYJhnOKmv7nThETXaK3pJo20aT+4YIRDbRnPN4GC5FV46IYI9d8XDTopFX4A5V4kbEHWHUWTczSbrWDzRTbtENHEJFCKNNC49uzTP07DC5FgCzt1P25C7S+9e5WsiXiK4eMNr6GACiVM2sAXyGXPwCxQNL6ESFtWKeAfhPeGplKKb8rlK3PVU1QEAj3fw0bN2rfrbXdZptR9dtgKt
Content-Type: text/plain; charset="utf-8"
Content-ID: <14529C3CBA36A446A39E9ACBB38B1839@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b68acbf3-b2e4-4097-e66c-08d7830c4f5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:19.2179
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TAmuATt9jRc35LbTL2UiYro1ZcY9RHa0uiBd+q3e93LDq//EllmE9UiVo21ocX5Ds+ZuJrW7yi2KhhD6dx3dNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRXJy
b3IgbWFuYWdlbWVudCBvZiB3ZnhfY29uZl90eCgpIGNhbiBiZSBzaW1wbGlmaWVkLgoKSW4gYWRk
LCB0aGUgaGFyZHdhcmUgY29tbWFuZCAiaGlmX3NldF9lZGNhX3F1ZXVlX3BhcmFtcyIgbmV2ZXIg
cmV0dXJucwphbnkgZXJyb3IuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8
IDQ0ICsrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDE2IGluc2VydGlvbnMoKyksIDI4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDQy
YjBkMDFkODVjYy4uMDQ1ZDM5MTZhZGE4IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTM3MCwzOSArMzcwLDI3
IEBAIGludCB3ZnhfY29uZl90eChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4
MDIxMV92aWYgKnZpZiwKIHsKIAlzdHJ1Y3Qgd2Z4X2RldiAqd2RldiA9IGh3LT5wcml2OwogCXN0
cnVjdCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopIHZpZi0+ZHJ2X3ByaXY7Ci0J
aW50IHJldCA9IDA7CiAJc3RydWN0IGhpZl9yZXFfZWRjYV9xdWV1ZV9wYXJhbXMgKmVkY2E7CiAK
LQltdXRleF9sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKLQotCWlmIChxdWV1ZSA8IGh3LT5xdWV1
ZXMpIHsKLQkJZWRjYSA9ICZ3dmlmLT5lZGNhLnBhcmFtc1txdWV1ZV07Ci0KLQkJd3ZpZi0+ZWRj
YS51YXBzZF9lbmFibGVbcXVldWVdID0gcGFyYW1zLT51YXBzZDsKLQkJZWRjYS0+YWlmc24gPSBw
YXJhbXMtPmFpZnM7Ci0JCWVkY2EtPmN3X21pbiA9IHBhcmFtcy0+Y3dfbWluOwotCQllZGNhLT5j
d19tYXggPSBwYXJhbXMtPmN3X21heDsKLQkJZWRjYS0+dHhfb3BfbGltaXQgPSBwYXJhbXMtPnR4
b3AgKiBUWE9QX1VOSVQ7Ci0JCWVkY2EtPmFsbG93ZWRfbWVkaXVtX3RpbWUgPSAwOwotCQlyZXQg
PSBoaWZfc2V0X2VkY2FfcXVldWVfcGFyYW1zKHd2aWYsIGVkY2EpOwotCQlpZiAocmV0KSB7Ci0J
CQlyZXQgPSAtRUlOVkFMOwotCQkJZ290byBvdXQ7Ci0JCX0KKwlXQVJOX09OKHF1ZXVlID49IGh3
LT5xdWV1ZXMpOwogCi0JCWlmICh3dmlmLT52aWYtPnR5cGUgPT0gTkw4MDIxMV9JRlRZUEVfU1RB
VElPTikgewotCQkJcmV0ID0gd2Z4X3NldF91YXBzZF9wYXJhbSh3dmlmLCAmd3ZpZi0+ZWRjYSk7
Ci0JCQlpZiAoIXJldCAmJiB3dmlmLT5zZXRic3NwYXJhbXNfZG9uZSAmJgotCQkJICAgIHd2aWYt
PnN0YXRlID09IFdGWF9TVEFURV9TVEEpCi0JCQkJcmV0ID0gd2Z4X3VwZGF0ZV9wbSh3dmlmKTsK
LQkJfQotCX0gZWxzZSB7Ci0JCXJldCA9IC1FSU5WQUw7CisJbXV0ZXhfbG9jaygmd2Rldi0+Y29u
Zl9tdXRleCk7CisJd3ZpZi0+ZWRjYS51YXBzZF9lbmFibGVbcXVldWVdID0gcGFyYW1zLT51YXBz
ZDsKKwllZGNhID0gJnd2aWYtPmVkY2EucGFyYW1zW3F1ZXVlXTsKKwllZGNhLT5haWZzbiA9IHBh
cmFtcy0+YWlmczsKKwllZGNhLT5jd19taW4gPSBwYXJhbXMtPmN3X21pbjsKKwllZGNhLT5jd19t
YXggPSBwYXJhbXMtPmN3X21heDsKKwllZGNhLT50eF9vcF9saW1pdCA9IHBhcmFtcy0+dHhvcCAq
IFRYT1BfVU5JVDsKKwllZGNhLT5hbGxvd2VkX21lZGl1bV90aW1lID0gMDsKKwloaWZfc2V0X2Vk
Y2FfcXVldWVfcGFyYW1zKHd2aWYsIGVkY2EpOworCisJaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7CisJCXdmeF9zZXRfdWFwc2RfcGFyYW0od3ZpZiwgJnd2
aWYtPmVkY2EpOworCQlpZiAod3ZpZi0+c2V0YnNzcGFyYW1zX2RvbmUgJiYgd3ZpZi0+c3RhdGUg
PT0gV0ZYX1NUQVRFX1NUQSkKKwkJCXdmeF91cGRhdGVfcG0od3ZpZik7CiAJfQotCi1vdXQ6CiAJ
bXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKLQlyZXR1cm4gcmV0OworCXJldHVybiAw
OwogfQogCiBpbnQgd2Z4X3NldF9ydHNfdGhyZXNob2xkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3
LCB1MzIgdmFsdWUpCi0tIAoyLjI0LjAKCg==
