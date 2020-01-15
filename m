Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9BD413C07A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbgAOMMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:36 -0500
Received: from mail-co1nam11on2084.outbound.protection.outlook.com ([40.107.220.84]:24056
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730218AbgAOMMf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDb7t2/chHtMSNwo7HMctUnWKXCbIqyS4hBR+EjI7lVBznUmtbPFKkvPEcVqwBcpkIXwKYAfdX2TqSKJQc8RRqM1iAoZWyEcy8naVPXzmhFAt6UKlVF1H2D3OnecD0/auUMkmw5ySwh5d6pcgcvJzHTlXbZUsvMYIeQbdGb+LaN1TuKvhL39Oe1ekpb0PKPCtDpSkgtN8j0UkEtN8huGMe+ihmqdXRnzuVXBYB59lBO0DG2FftO9VM+qAN3PZUXNsqQ0bXLq61lJFv0RgPuWcRrwR/SthVAZSZq0QJ3aVToNI11HKc7YzihNvsirPiLAdgDGBN32v+AfAAXiuMkpJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xbX4O+7DVFKMuBoAyyVIDQfYyePPJ696cihc2JM5rQ=;
 b=H4OgCiYbIV8ssY0mbwgvRNlUWXooz+btXC9TPSn7AYg8omiNpLBWtnFeTjgg7dhGrnx8812OV7lDbnaZ4nhqSFUQQxRPquB93JzFH1AbRO3VONaqLtXocvBcSYMhAvrY26yfRqyLALmHjj9U7gLTYS2kAvJHbQzgF+K8S2vXEMkYhrNsiF8fRrdBeK5VCZpqX2OlZdcXua3cbL1xh/dJYYlAnnhZScANU0HyS9TbxcNR34YdN8lGDg9hJf6q9lxv4XamBBBSMreBbgLjXUEO1cBqpSGvSTmr9017FqxOKXi3kacUqbOaOeTLdf04nmAiTB07pcy71EVLhv1+X9zQjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xbX4O+7DVFKMuBoAyyVIDQfYyePPJ696cihc2JM5rQ=;
 b=HPnl98zI9D3+4ajNmxlUQ5qPpW/CZbNBkuLyHT6rf8vsd7sMVMrVhdwTq7NijAhZldM2Y71Japn9Fc8atLbiVKtpjV9H7vm1mzhMJZV7ml7kFgFIkMizdRwFOlw6cd7+/ecKy2T/ZM3yll5gTPMrTVjrwVvrXXRsZYA9OjGU7x0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:12:19 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:19 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:18 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 08/65] staging: wfx: simplify hif_set_arp_ipv4_filter() usage
Thread-Topic: [PATCH 08/65] staging: wfx: simplify hif_set_arp_ipv4_filter()
 usage
Thread-Index: AQHVy50Im5dbQg2Lpke2wSUOQkIzGw==
Date:   Wed, 15 Jan 2020 12:12:19 +0000
Message-ID: <20200115121041.10863-9-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 76e85dbf-9094-4dc8-e8a9-08d799b42afc
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39349459475A87CE8B40718993370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(136003)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IAo2YqZ3fTzQUGOIq/OTHNXGlZCfy2ZlmN/OeSJCfK5bdCN1VAn6OV/pUu6ki/segQ+ID6xo9aB+33y6CX8Dgjw5xHn2qypGt5FWUG3oCAiwPFdzRLHsnKihl1dZmg2plUy+KxKn+hOcRrk1kh+5p/HBPP4kuKZ2QwYkh9KiFK/1MNhFN8dtD15atd3gQQU0VEYOSY3R41PKdnvP6XhJWI/cJW6D1/CWMHjVhP9JKY70HRrEDpuDA5tSKtO+s6Ms3hesxByNL27U2Es7Lc9Ag9c3HOHCHSPupy08HkYROpS4kZFLktHRoQTo5yUHOM4/7kDTcqEZeStq9asqKpHnETbw3xqDkDcLs2oGi1Tg1SksYAMDtm0+B4TNeaXi7Hn2zdur1C2WBC3m9QtZbQq4iWHMuH89M9SFdTUZ81+ok1YwEptK8xBHoB6lvkb+eUGM
Content-Type: text/plain; charset="utf-8"
Content-ID: <521C4DC7DEED7941AC74B1AA443CFAEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76e85dbf-9094-4dc8-e8a9-08d799b42afc
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:19.2384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hIyWPtxxfEeTQLJ05lV7wfL/4wmHhwTUK2hf81vt3Q4QFqmOrwjRPGmHRNPqflbFVfMTvyZ5T+OpIgCqPnK+Xg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX2FycF9pcF9hZGRyX3RhYmxlIGNvbWUgZnJvbSBoYXJkd2FyZSBB
UEkuIEl0IGlzCm5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXllcnMg
b2YgdGhlIGRyaXZlci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZfc2V0X2FycF9pcHY0
X2ZpbHRlcigpIGlzIHRvbyBkdW1iLiBJdApzaG91bGQgcGFjayBkYXRhIHVzaW5nIHRoZSBoYXJk
d2FyZSByZXByZXNlbnRhdGlvbiBpbnN0ZWFkIG9mIGxlYXZpbmcKYWxsIHdvcmsgdG8gdGhlIGNh
bGxlci4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJA
c2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCB8IDE2ICsr
KysrKysrKysrKystLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICAgICAgIHwgMjUgKysr
KysrKy0tLS0tLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAyMCBpbnNlcnRpb25zKCsp
LCAyMSBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCmluZGV4IGE4MDgyNTA4
ZmJmZC4uYTMyNWM4NzBiNGVhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90
eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMjYwLDEy
ICsyNjAsMjIgQEAgc3RhdGljIGlubGluZSBpbnQgaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBpbnQgcGVyaW9kKQogCQkJICAgICAmYXJnLCBzaXplb2YoYXJnKSk7
CiB9OwogCi1zdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X2FycF9pcHY0X2ZpbHRlcihzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwKLQkJCQkJICBzdHJ1Y3QgaGlmX21pYl9hcnBfaXBfYWRkcl90YWJsZSAq
ZnApCitzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X2FycF9pcHY0X2ZpbHRlcihzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiwgaW50IGlkeCwKKwkJCQkJICBfX2JlMzIgKmFkZHIpCiB7CisJc3RydWN0IGhp
Zl9taWJfYXJwX2lwX2FkZHJfdGFibGUgYXJnID0geworCQkuY29uZGl0aW9uX2lkeCA9IGlkeCwK
KwkJLmFycF9lbmFibGUgPSBISUZfQVJQX05TX0ZJTFRFUklOR19ESVNBQkxFLAorCX07CisKKwlp
ZiAoYWRkcikgeworCQkvLyBDYXV0aW9uOiB0eXBlIG9mIGFkZHIgaXMgX19iZTMyCisJCW1lbWNw
eShhcmcuaXB2NF9hZGRyZXNzLCBhZGRyLCBzaXplb2YoYXJnLmlwdjRfYWRkcmVzcykpOworCQlh
cmcuYXJwX2VuYWJsZSA9IEhJRl9BUlBfTlNfRklMVEVSSU5HX0VOQUJMRTsKKwl9CiAJcmV0dXJu
IGhpZl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsCiAJCQkgICAgIEhJRl9NSUJfSURf
QVJQX0lQX0FERFJFU1NFU19UQUJMRSwKLQkJCSAgICAgZnAsIHNpemVvZigqZnApKTsKKwkJCSAg
ICAgJmFyZywgc2l6ZW9mKGFyZykpOwogfQogCiBzdGF0aWMgaW5saW5lIGludCBoaWZfdXNlX211
bHRpX3R4X2NvbmYoc3RydWN0IHdmeF9kZXYgKndkZXYsCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCAzMzlhY2Jj
ZTk2ZmIuLjhjNTUwODliMWVhNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC05MTUsMzAgKzkxNSwxOSBAQCB2
b2lkIHdmeF9ic3NfaW5mb19jaGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCXN0cnVj
dCB3ZnhfdmlmICp3dmlmID0gKHN0cnVjdCB3ZnhfdmlmICopIHZpZi0+ZHJ2X3ByaXY7CiAJYm9v
bCBkb19qb2luID0gZmFsc2U7CiAJaW50IGk7Ci0JaW50IG5iX2FycF9hZGRyOwogCiAJbXV0ZXhf
bG9jaygmd2Rldi0+Y29uZl9tdXRleCk7CiAKIAkvKiBUT0RPOiBCU1NfQ0hBTkdFRF9RT1MgKi8K
IAlpZiAoY2hhbmdlZCAmIEJTU19DSEFOR0VEX0FSUF9GSUxURVIpIHsKLQkJc3RydWN0IGhpZl9t
aWJfYXJwX2lwX2FkZHJfdGFibGUgZmlsdGVyID0geyB9OwotCi0JCW5iX2FycF9hZGRyID0gaW5m
by0+YXJwX2FkZHJfY250OwotCQlpZiAobmJfYXJwX2FkZHIgPD0gMCB8fCBuYl9hcnBfYWRkciA+
IEhJRl9NQVhfQVJQX0lQX0FERFJUQUJMRV9FTlRSSUVTKQotCQkJbmJfYXJwX2FkZHIgPSAwOwot
CiAJCWZvciAoaSA9IDA7IGkgPCBISUZfTUFYX0FSUF9JUF9BRERSVEFCTEVfRU5UUklFUzsgaSsr
KSB7Ci0JCQlmaWx0ZXIuY29uZGl0aW9uX2lkeCA9IGk7Ci0JCQlpZiAoaSA8IG5iX2FycF9hZGRy
KSB7Ci0JCQkJLy8gQ2F1dGlvbjogdHlwZSBvZiBhcnBfYWRkcl9saXN0W2ldIGlzIF9fYmUzMgot
CQkJCW1lbWNweShmaWx0ZXIuaXB2NF9hZGRyZXNzLAotCQkJCSAgICAgICAmaW5mby0+YXJwX2Fk
ZHJfbGlzdFtpXSwKLQkJCQkgICAgICAgc2l6ZW9mKGZpbHRlci5pcHY0X2FkZHJlc3MpKTsKLQkJ
CQlmaWx0ZXIuYXJwX2VuYWJsZSA9IEhJRl9BUlBfTlNfRklMVEVSSU5HX0VOQUJMRTsKLQkJCX0g
ZWxzZSB7Ci0JCQkJZmlsdGVyLmFycF9lbmFibGUgPSBISUZfQVJQX05TX0ZJTFRFUklOR19ESVNB
QkxFOwotCQkJfQotCQkJaGlmX3NldF9hcnBfaXB2NF9maWx0ZXIod3ZpZiwgJmZpbHRlcik7CisJ
CQlfX2JlMzIgKmFycF9hZGRyID0gJmluZm8tPmFycF9hZGRyX2xpc3RbaV07CisKKwkJCWlmIChp
bmZvLT5hcnBfYWRkcl9jbnQgPiBISUZfTUFYX0FSUF9JUF9BRERSVEFCTEVfRU5UUklFUykKKwkJ
CQlhcnBfYWRkciA9IE5VTEw7CisJCQlpZiAoaSA+PSBpbmZvLT5hcnBfYWRkcl9jbnQpCisJCQkJ
YXJwX2FkZHIgPSBOVUxMOworCQkJaGlmX3NldF9hcnBfaXB2NF9maWx0ZXIod3ZpZiwgaSwgYXJw
X2FkZHIpOwogCQl9CiAJfQogCi0tIAoyLjI1LjAKCg==
