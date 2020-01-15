Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DBB313BF75
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbgAOMNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:41 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731583AbgAOMNk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZH85UdByGCkDU/MMYgNd1RgkI3u7kytJ9bepj+5mI4plB5okRohypl1U8AT5xVVfyEjLUn18yMyjjRPI8igLAAVJmpmKYCDimboJIC4mGxMgS4GLOVo725hegnLwLecKY2nvFaaZI62VfLWd+M6jwMcemX7vVADOeBVr+BaDf8uro7XnPexCPZPQWXErx4EdqlSJFBKuiDMS0HxLuBvnoTicC08KzROzrnFVwOXDjinMT19G3W9I9U3PakdxOw1V0m2Fgp7879hq55jR2npCR9t7BpJ0p2IjwcUgSSjxxmm76ocly3V/tPJoZ1KU7Yr/lhK3y3hyP1OgD4R45c62w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmEvffuL1FL6nPJSGxWSnv9QgrUnGsDyHOKx+ciWH7s=;
 b=h669kTaS41dGLCCN3aIQ+9ccCfnUBv6DCssLc0oMFg4cBEGpwESy8hcVTFsSnhYTzwS3LNX7XKwi7jD3fJULQ1+A68T0KAq2vGFStWjQYzP0gBpFfOz3gt3PU7wTYwa0F3kn5Qw6qKwxs/Mz51oEB0Yu3zjz6e0oLeTfp6IZ9sjpcrtmwRCFixMXGgE3zZ5fOoglLOTnz8NdOA3qD4uykdBQfuxZ4ehRlAts5kTcd7TuY4xjrFKvnGlp4pv8rvNatrxzOmx9r8jyFopEMNgxpgr9WEbaYS+uByakqXoC3Lvv698w5PMRP/Wi0pvsdMsHETv4iQ4kax5uEs+P5aQ4dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MmEvffuL1FL6nPJSGxWSnv9QgrUnGsDyHOKx+ciWH7s=;
 b=dauG/V73kqWNDKebKm8J8grYdaq12/PyALredZCem5jLBStvp4XYbEAX13Z8PUxsa1xAluGhF6DM7LCWCCYUEMpYqxvvOgdlOPpsvCIcK1MMSg+UY17Ll0LrIxQ0t6Y+z2FG4tTSiHxkcY28KWE4aungf2VOUcwBLn8I6zSwPuA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:29 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:10 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 47/65] staging: wfx: fix bss_loss
Thread-Topic: [PATCH 47/65] staging: wfx: fix bss_loss
Thread-Index: AQHVy50nWkEZyBXnaEW7ErKQIpaudQ==
Date:   Wed, 15 Jan 2020 12:13:11 +0000
Message-ID: <20200115121041.10863-48-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 70be08f9-b675-4886-ab1c-08d799b44a3d
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39345643B86CF78494CD6D1E93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9IAtb72GmTDcFLIW11+yamKz6ksw3QO/dBIfcGqGHe9L+WInMDmHgdI+2r+4EIZc3dG1oNWa9rWFvhYALQxCErCOpSpAsuJsZ5oJ7CMwx6GK0Jzw60GPepIBHvrL3AS8W4UaVczWMPD9Lxf2/n6s6/Nx/q5xeJFdDZvD3N+My8ukdOo2s9FJ2DrgllwpenVP9f+KuISn/wAR9oMqR/qxxcnNHxvE0AeHy8zlF8A/CahoCsGKxf5dDKPUy3DLJDy2YCQBHTgQij6ZewFldJ8WnYJchTCBw+FYK1aGC/68Cdln98TNfSernX7esPpVRN1jTqK7zxLXytT+7DGWwwjf0lOaWrr/np9XU416yD0FZ75TtwbnjcQ68kswA3X5bT6aGS7jJYfKL3iw6VligefwtYFY+o5FwyZuAsyb2MnZV1KZuMitHvk4mAPoYEhjVsu4
Content-Type: text/plain; charset="utf-8"
Content-ID: <B553ABF3417ED24FBE66071DA27E1614@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70be08f9-b675-4886-ab1c-08d799b44a3d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:11.6791
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BlEt43zUGFsWYkaS43DlSLSSrfX+RKnA1UxIZeQ0JDrqKmCfJit9oXhXtkLANdt4PDVwMTYzDHjJ46kPdRNRQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X2NvbmZpcm1fY2IoKSAgcmV0cmlldmVzIHRoZSBzdGF0aW9uIGFzc29jaWF0ZWQgd2l0aCBh
IGZyYW1lIHVzaW5nCnRoZSBNQUMgYWRkcmVzcyBmcm9tIHRoZSA4MDIuMTEgaGVhZGVyLiBJbiB0
aGUgb3RoZXIgc2lkZSB3ZnhfdHgoKQpyZXRyaWV2ZXMgdGhlIHN0YXRpb24gdXNpbmcgc3RhIGZp
ZWxkIGZyb20gdGhlIGllZWU4MDIxMV90eF9jb250cm9sCmFyZ3VtZW50LgoKSW4gd2Z4X2NxbV9i
c3Nsb3NzX3NtKCksIHdmeF90eCgpIHdhcyBjYWxsZWQgZGlyZWN0bHkgd2l0aG91dCB2YWxpZCBz
dGEKZmllbGQsIGJ1dCB3aXRoIGEgdmFsaWQgTUFDIGFkZHJlc3MgaW4gODAyLjExIGhlYWRlci4g
U28gdGhlcmUgdGhlCnByb2Nlc3Npbmcgb2YgdGhpcyBwYWNrZXQgd2FzIHVuYmFsYW5jZWQgYW5k
IG1heSBwcm9kdWNlIHdlaXJkIGJ1Z3MuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxl
ciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYyB8IDggKysrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVs
ZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhZWJjZTk2ZGNkNGEuLjgwYTJhOWU4MjU2ZiAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCkBAIC04OCwxOSArODgsMjUgQEAgdm9pZCB3ZnhfY3FtX2Jzc2xvc3Nfc20oc3Ry
dWN0IHdmeF92aWYgKnd2aWYsIGludCBpbml0LCBpbnQgZ29vZCwgaW50IGJhZCkKIAkvLyBGSVhN
RTogY2FsbCBpZWVlODAyMTFfYmVhY29uX2xvc3MvaWVlZTgwMjExX2Nvbm5lY3Rpb25fbG9zcyBp
bnN0ZWFkCiAJaWYgKHR4KSB7CiAJCXN0cnVjdCBza19idWZmICpza2I7CisJCXN0cnVjdCBpZWVl
ODAyMTFfaGRyICpoZHIKKwkJc3RydWN0IGllZWU4MDIxMV90eF9jb250cm9sIGNvbnRyb2wgPSB7
IH07CiAKIAkJd3ZpZi0+YnNzX2xvc3Nfc3RhdGUrKzsKIAogCQlza2IgPSBpZWVlODAyMTFfbnVs
bGZ1bmNfZ2V0KHd2aWYtPndkZXYtPmh3LCB3dmlmLT52aWYsIGZhbHNlKTsKIAkJaWYgKCFza2Ip
CiAJCQlnb3RvIGVuZDsKKwkJaGRyID0gKHN0cnVjdCBpZWVlODAyMTFfaGRyICopc2tiLT5kYXRh
OwogCQltZW1zZXQoSUVFRTgwMjExX1NLQl9DQihza2IpLCAwLAogCQkgICAgICAgc2l6ZW9mKCpJ
RUVFODAyMTFfU0tCX0NCKHNrYikpKTsKIAkJSUVFRTgwMjExX1NLQl9DQihza2IpLT5jb250cm9s
LnZpZiA9IHd2aWYtPnZpZjsKIAkJSUVFRTgwMjExX1NLQl9DQihza2IpLT5kcml2ZXJfcmF0ZXNb
MF0uaWR4ID0gMDsKIAkJSUVFRTgwMjExX1NLQl9DQihza2IpLT5kcml2ZXJfcmF0ZXNbMF0uY291
bnQgPSAxOwogCQlJRUVFODAyMTFfU0tCX0NCKHNrYiktPmRyaXZlcl9yYXRlc1sxXS5pZHggPSAt
MTsKLQkJd2Z4X3R4KHd2aWYtPndkZXYtPmh3LCBOVUxMLCBza2IpOworCQlyY3VfcmVhZF9sb2Nr
KCk7IC8vIHByb3RlY3QgY29udHJvbC5zdGEKKwkJY29udHJvbC5zdGEgPSBpZWVlODAyMTFfZmlu
ZF9zdGEod3ZpZi0+dmlmLCBoZHItPmFkZHIxKTsKKwkJd2Z4X3R4KHd2aWYtPndkZXYtPmh3LCAm
Y29udHJvbCwgc2tiKTsKKwkJcmN1X3JlYWRfdW5sb2NrKCk7CiAJfQogZW5kOgogCW11dGV4X3Vu
bG9jaygmd3ZpZi0+YnNzX2xvc3NfbG9jayk7Ci0tIAoyLjI1LjAKCg==
