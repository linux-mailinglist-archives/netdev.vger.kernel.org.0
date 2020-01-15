Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4332613BFA6
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731598AbgAOMPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:15:13 -0500
Received: from mail-bn7nam10on2085.outbound.protection.outlook.com ([40.107.92.85]:6101
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731597AbgAOMNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QDIq/r4/k3pwHnv5aauj9j+4PQgtL5gPsE69mcHzayEjRPLPvftysriCYweweniqzgB9qY+xMmAvqGfpqL8bo0JfnhG9kET7KFIpkBGEmopb/mtr6x7mpPWhehU3HRoVkAug6HkNrMCkdMpPupRFDH9kq1eCChuZnkRreKZfVDTCZ1Bdaz1LbLHPFaOfUaXBAebPsQQKQOhDS3ZsuVPgsl37YU6qxhZ4h8cublUpS0AEhKQY7v+qeTH2mfil/NCwnRakqEi6Sp+0nLHznymAIfmQxkUkcJkpoA60k8/JxzTPNW/8zAnzwtfAsIJ9j0B0U+uJ2iH5xgKMQJeA5m5R5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBpMtVw4Bzufoc9c1Lv0GypFZxbeCWfS1uC6i42B9q0=;
 b=UvPhkHzne5HE+bfTmquxoPAyrIAw5hokd3Uf513CEUJ00u5FEDyTTlfx04o2fBvGQPCTJmEv9L3CwwniCfi060JKirlKPiv7s0Bt+61gcXPphO13GwL8Cp28tfZ4XAwcgLYWjFRJbne8j3/vFKtcFUzNwmv3SexbAZnpW4yqmuMSIT37SSoxVPO9ctj9Wqb/B0m6qy5X7GCwnWcuBj0p4rNUGqKSbhoUHsUtketshVOhEWKxb1IcuJWXbkX36gIDxiwg3GGr8ckBd03u/8f+fT1wUWMl1iLc3iktBx9qpGUNZYv1LaF8+n2pBln5FJbIKc61UMmhug4Zn3H8kMhrVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBpMtVw4Bzufoc9c1Lv0GypFZxbeCWfS1uC6i42B9q0=;
 b=ZRBXljsfBcy/Ioml0Nk4cNktZkN9+zfeatd6dc4qzQqF1Q+D6xsAO5v/h+dlYywavNkP4t30w76MEb10tLlZFGU52f+TU8IwP9DnZyzDpFlIf6Eg5oxBaSsW5r4PyBihJNlhmwrsTLhPiacxJWfDQiGH7fBrN0ZNXCeyqLX9ZAU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:31 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:31 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:13 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 49/65] staging: wfx: simplify wfx_set_tim_impl()
Thread-Topic: [PATCH 49/65] staging: wfx: simplify wfx_set_tim_impl()
Thread-Index: AQHVy50pM5JkyPfNJEGVPJow5DsikQ==
Date:   Wed, 15 Jan 2020 12:13:14 +0000
Message-ID: <20200115121041.10863-50-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: b3170333-d940-49bb-ee4d-08d799b44bca
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934E43C07517E8A40FFAAE893370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1227;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u2CL40jdt3mLGJ9RLoQJEnH38ElffJL4lQV+AHArk3VEffWKDmkDStIGw7qLIhvqUo+/WGkZBstJC7WHJYt3cGyzzxGNnFSaplmy31B9xan25c+XfWMNwUskn7WmXjCjsjB/jjY2ta2hRSCIbTJPZtboDUhUyeCwA/UIitBqe4iV7AwRNQDdSe/BErFAjlOrClXZ/7cRFF9ebzoLS5dm+VNNhaBwgaXztIzgC4M5SeTWj3Gza+83PtrAsreKJW5BiV19NHZIwZZOKxzt/OwcHI8vztWVWYe/e9SD2eVsQNBD0QCkrn6ispYyj3mFHIP7dz7ZZFRB8Id1JPCtwRbnUyqD9bvMBR9kgfAFtXP5/49uOwtjKpmHuEcyVZgSz8zpMZG3rU/75jNHsdI7eIz/DNuOBfYqsJMMSNVQNGh6icplAprHqCsCXdkH5kOBkrbv
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E67FAC9F9E9E14CA07EFA6A15EFEEEF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3170333-d940-49bb-ee4d-08d799b44bca
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:14.2956
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bJfslAESvqFssrbPltj9ognj9xUszEvwSpYplQj64+exrY5qwhTSNT3SCnWUhWaoz51EyB2wTSFvIkq+nsae0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQXJn
dW1lbnQgcHJvdmlkZWQgdG8gd2Z4X3NldF90aW1faW1wbCgpIGlzIGFsd2F5cyB3dmlmLT5haWQw
X2JpdF9zZXQgYW5kCnRoZXJlIGlzIG5vIHJlYXNvbiB0byBwcm92aWRlIGFub3RoZXIgYXJndW1l
bnQuCgpBbHNvIHJlbmFtZSB3Znhfc2V0X3RpbV9pbXBsKCkgaW50byB3ZnhfdXBkYXRlX3RpbSgp
IHRvIHJlZmxlY3QgdGhlIG5ldwpiZWhhdmlvci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIHwgMTggKysrKysrKysrLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3dm
eC5oIHwgIDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZDUwYjU4M2FmMTg3Li40NzI3MWI3ZWVhYWIgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtODk1LDcgKzg5NSw3IEBAIHZvaWQgd2Z4X3N0YV9ub3RpZnkoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJd2Z4X3BzX25vdGlm
eSh3dmlmLCBub3RpZnlfY21kLCBzdGFfcHJpdi0+bGlua19pZCk7CiB9CiAKLXN0YXRpYyBpbnQg
d2Z4X3NldF90aW1faW1wbChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBhaWQwX2JpdF9zZXQp
CitzdGF0aWMgaW50IHdmeF91cGRhdGVfdGltKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogewogCXN0
cnVjdCBza19idWZmICpza2I7CiAJdTE2IHRpbV9vZmZzZXQsIHRpbV9sZW5ndGg7CkBAIC05MTYs
NyArOTE2LDcgQEAgc3RhdGljIGludCB3Znhfc2V0X3RpbV9pbXBsKHN0cnVjdCB3ZnhfdmlmICp3
dmlmLCBib29sIGFpZDBfYml0X3NldCkKIAkJdGltX3B0clsyXSA9IDA7CiAKIAkJLyogU2V0L3Jl
c2V0IGFpZDAgYml0ICovCi0JCWlmIChhaWQwX2JpdF9zZXQpCisJCWlmICh3dmlmLT5haWQwX2Jp
dF9zZXQpCiAJCQl0aW1fcHRyWzRdIHw9IDE7CiAJCWVsc2UKIAkJCXRpbV9wdHJbNF0gJj0gfjE7
CkBAIC05MjgsMTEgKzkyOCwxMSBAQCBzdGF0aWMgaW50IHdmeF9zZXRfdGltX2ltcGwoc3RydWN0
IHdmeF92aWYgKnd2aWYsIGJvb2wgYWlkMF9iaXRfc2V0KQogCXJldHVybiAwOwogfQogCi1zdGF0
aWMgdm9pZCB3Znhfc2V0X3RpbV93b3JrKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykKK3N0YXRp
YyB2b2lkIHdmeF91cGRhdGVfdGltX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogewot
CXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB3Znhfdmlm
LCBzZXRfdGltX3dvcmspOworCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gY29udGFpbmVyX29mKHdv
cmssIHN0cnVjdCB3ZnhfdmlmLCB1cGRhdGVfdGltX3dvcmspOwogCi0Jd2Z4X3NldF90aW1faW1w
bCh3dmlmLCB3dmlmLT5haWQwX2JpdF9zZXQpOworCXdmeF91cGRhdGVfdGltKHd2aWYpOwogfQog
CiBpbnQgd2Z4X3NldF90aW0oc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAy
MTFfc3RhICpzdGEsIGJvb2wgc2V0KQpAQCAtOTQxLDcgKzk0MSw3IEBAIGludCB3Znhfc2V0X3Rp
bShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwgYm9v
bCBzZXQpCiAJc3RydWN0IHdmeF9zdGFfcHJpdiAqc3RhX2RldiA9IChzdHJ1Y3Qgd2Z4X3N0YV9w
cml2ICopICZzdGEtPmRydl9wcml2OwogCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gd2Rldl90b193
dmlmKHdkZXYsIHN0YV9kZXYtPnZpZl9pZCk7CiAKLQlzY2hlZHVsZV93b3JrKCZ3dmlmLT5zZXRf
dGltX3dvcmspOworCXNjaGVkdWxlX3dvcmsoJnd2aWYtPnVwZGF0ZV90aW1fd29yayk7CiAJcmV0
dXJuIDA7CiB9CiAKQEAgLTk1NSw4ICs5NTUsOCBAQCBzdGF0aWMgdm9pZCB3ZnhfbWNhc3Rfc3Rh
cnRfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCiAJY2FuY2VsX3dvcmtfc3luYygmd3Zp
Zi0+bWNhc3Rfc3RvcF93b3JrKTsKIAlpZiAoIXd2aWYtPmFpZDBfYml0X3NldCkgewogCQl3Znhf
dHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKLQkJd2Z4X3NldF90aW1faW1wbCh3dmlmLCB0cnVl
KTsKIAkJd3ZpZi0+YWlkMF9iaXRfc2V0ID0gdHJ1ZTsKKwkJd2Z4X3VwZGF0ZV90aW0od3ZpZik7
CiAJCW1vZF90aW1lcigmd3ZpZi0+bWNhc3RfdGltZW91dCwgamlmZmllcyArIHRtbyk7CiAJCXdm
eF90eF91bmxvY2sod3ZpZi0+d2Rldik7CiAJfQpAQCAtOTcxLDcgKzk3MSw3IEBAIHN0YXRpYyB2
b2lkIHdmeF9tY2FzdF9zdG9wX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQogCQlkZWxf
dGltZXJfc3luYygmd3ZpZi0+bWNhc3RfdGltZW91dCk7CiAJCXdmeF90eF9sb2NrX2ZsdXNoKHd2
aWYtPndkZXYpOwogCQl3dmlmLT5haWQwX2JpdF9zZXQgPSBmYWxzZTsKLQkJd2Z4X3NldF90aW1f
aW1wbCh3dmlmLCBmYWxzZSk7CisJCXdmeF91cGRhdGVfdGltKHd2aWYpOwogCQl3ZnhfdHhfdW5s
b2NrKHd2aWYtPndkZXYpOwogCX0KIH0KQEAgLTExMTgsNyArMTExOCw3IEBAIGludCB3ZnhfYWRk
X2ludGVyZmFjZShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYg
KnZpZikKIAlJTklUX0RFTEFZRURfV09SSygmd3ZpZi0+bGlua19pZF9nY193b3JrLCB3ZnhfbGlu
a19pZF9nY193b3JrKTsKIAogCXNwaW5fbG9ja19pbml0KCZ3dmlmLT5wc19zdGF0ZV9sb2NrKTsK
LQlJTklUX1dPUksoJnd2aWYtPnNldF90aW1fd29yaywgd2Z4X3NldF90aW1fd29yayk7CisJSU5J
VF9XT1JLKCZ3dmlmLT51cGRhdGVfdGltX3dvcmssIHdmeF91cGRhdGVfdGltX3dvcmspOwogCiAJ
SU5JVF9XT1JLKCZ3dmlmLT5tY2FzdF9zdGFydF93b3JrLCB3ZnhfbWNhc3Rfc3RhcnRfd29yayk7
CiAJSU5JVF9XT1JLKCZ3dmlmLT5tY2FzdF9zdG9wX3dvcmssIHdmeF9tY2FzdF9zdG9wX3dvcmsp
OwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvd2Z4LmgKaW5kZXggZjU2YTkxZWEwODJkLi5jYjM1OTE1MGUyYWQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aApAQCAtOTYsNyArOTYsNyBAQCBzdHJ1Y3Qgd2Z4X3ZpZiB7CiAJdTMyCQkJc3RhX2FzbGVlcF9t
YXNrOwogCXUzMgkJCXBzcG9sbF9tYXNrOwogCXNwaW5sb2NrX3QJCXBzX3N0YXRlX2xvY2s7Ci0J
c3RydWN0IHdvcmtfc3RydWN0CXNldF90aW1fd29yazsKKwlzdHJ1Y3Qgd29ya19zdHJ1Y3QJdXBk
YXRlX3RpbV93b3JrOwogCiAJaW50CQkJYmVhY29uX2ludDsKIAlib29sCQkJZmlsdGVyX2Jzc2lk
OwotLSAKMi4yNS4wCgo=
