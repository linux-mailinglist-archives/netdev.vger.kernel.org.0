Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB4913BF78
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbgAOMNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:50 -0500
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:28929
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731675AbgAOMNt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bCQEoSnB9R5vVySa1kVyYNiHVlhuxW0BopIMuMIleqyqSgNW8r8CMmNpzywiTXaOgZWDDmfBW+rg80s+a9FYUOTc2sJ8VHGHM75TZLzvM/pcrideEsj5LTzXiIzyg21yIriQZFdf3ChIhN95v48R6ZYycOO4Y59J3gEWFrzTYLsgmczN6Ez/GoJQNCNfmTEdRR198RU3vxohajFEWj1F16DLG6NFPjY8Qk5XEe24sRUkvMvQl+QFCkX7p/j7soBSY1Wdch5KK1SNQCtv+bTtO/JtLDcs0640WMEZioF7dOLRmvHhg4RxeEsrWDTygoyKjGj2Bz5FK6rhq9WSg8+uGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+zq5T9uMxfb/CgmD1ygDpRDLGnzrLVhppu2bg4VgJQ=;
 b=NW+NvbNgpApKXpyBJFhUnOdixbMw3Tc0+9dDQrGFI+Se5Q2fNKUQOKYM6qNtNXODeTWKO1Ei+M0OTHjJvKU+pLWa6AC+SmeVqQdtK3BrbEiivCk3fQCXnHyAGHeSuzTgBZzgYBez7QacpJNFYsvU2i6PY4Rw72X/6hSzbxQVxxOUsop0DJD8vwk+NKd0mJnyzfu3OS0vCmY+ngtcSqg/HDaRktqOZlL7/bTXJ1ToMfxbQ54JVA9u6IahwJO+6KhN+KUfqpyCQKg+8MX0ESwvUQcIO9ODw+Mo3oHJp0xq6flGfdpvjmGOcTBOoe+WukJG7PwvAnz8bz4j/ZIh0Ld4/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+zq5T9uMxfb/CgmD1ygDpRDLGnzrLVhppu2bg4VgJQ=;
 b=MTySAJMaDsVDiqeHg8iQPniY0dv+NgCd5DXdN9q8+rz83iXoH8k77mTGozF19JbrVFKID+sqZUDQxB9i7pBG0YU/B8VxecEP+ySiGX2ZeaBARZxXuNPpYTBtMwg3I5yP6es+mkg3qcAwkYLhhN6wREmaqNVDq+qoqWC1FKlZ5dk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:34 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:34 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:21 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 55/65] staging: wfx: firmware never return PS status for
 stations
Thread-Topic: [PATCH 55/65] staging: wfx: firmware never return PS status for
 stations
Thread-Index: AQHVy50uPuhrVCL5JUid2UVR7lkP9g==
Date:   Wed, 15 Jan 2020 12:13:22 +0000
Message-ID: <20200115121041.10863-56-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 783d192f-f107-49d3-80e4-08d799b4509c
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3934E35CD2C2ED41644C5C5C93370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OcX5SeFyt8VMlwMga49ftRfYugosQgEsOnY1Z7CP1cvdEtkNWrqNS/gv3Jc+OISnM8RKLe7fUbNHUeFhe2UYG3TZweT32Gt9ZnehPAwFisvGutQ4z0z2KsHSPQAribfcV+Jyc+Lveum1F1GJrGC3jf+7t66MuaDpJymZmP5zty/e8krmVqB2WkFd1OTXA/PsJrKKFej04EO2x4xlTWymVcnFm6tArh8nwltb6ZfhiRUo64sKEsBh52wVqGngBRyrZjWKGSKfTxU3rT4W/Mzi5ia3+99HgplVmYeLh6S/l2ebPhLQsitbUFBhbxfIcMCXjq9itR6eX8t3eWKe7UADgLlPeVP8MV8QE4ptWJWVZguJjQ4aHsonJnMNjgdYJWUP59UnoX3s/77yhSKqD6+CTuLFfRGSP2OUfNHKzV03BZ/jtMkTMbShizAPCX9usJQG
Content-Type: text/plain; charset="utf-8"
Content-ID: <119AB7DD32FCA94C9AFD7932B6368CD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783d192f-f107-49d3-80e4-08d799b4509c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:22.4110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sbw8C2DfxG5jxnYm91YY/LFbO6XRTxdJhn7ssdWianN0/W+MYww0m7CZ4XvcHR3aphcokYwyrJ84hTwsl9QF1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQXQg
dGhlIGJlZ2lubmluZywgZmlybXdhcmUgY291bGQgc2VuZCBzdXNwZW5kX3Jlc3VtZSBpbmRpY2F0
aW9uIHRvCm5vdGlmeSB0aGF0IGEgc3RhdGlvbiB3YWtlIHVwIG9yIHNsZWVwIGRvd24uIEhvd2V2
ZXIsIG1hYzgwMjExIGFscmVhZHkKaGFuZGxlcyBwb3dlciBzYXZlIHN0YXR1cyBvZiBzdGF0aW9u
cyBhbmQgdGhpcyBiZWhhdmlvciBoYXMgYmVlbiByZW1vdmVkCmZyb20gdGhlIGZpcm13YXJlLiBT
byBub3csIHdoZW4gc3VzcGVuZF9yZXN1bWUgaW5kaWNhdGlvbiBpcyByZWNlaXZlZCwKaXQgaXMg
YWx3YXlzIHRvIG5vdGlmeSB0aGF0IGEgRFRJTSBpcyBhYm91dCB0byBiZSBzZW50LgoKU28sIGl0
IGlzIHBvc3NpYmxlIHRvIHNpbXBseSB3Znhfc3VzcGVuZF9yZXN1bWUoKS4KClNpZ25lZC1vZmYt
Ynk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBk
cml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNDMgKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTcgaW5zZXJ0aW9ucygrKSwgMjYgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZDRjMTFiMDc0OTdmLi5jZTgzYTU3Mzk3YzggMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtOTg1LDM4ICs5ODUsMjkgQEAgaW50IHdmeF9hbXBkdV9hY3Rpb24oc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsCiAJcmV0dXJuIC1FTk9UU1VQUDsKIH0KIAotc3RhdGljIHZvaWQg
d2Z4X2R0aW1fbm90aWZ5KHN0cnVjdCB3ZnhfdmlmICp3dmlmKQotewotCXNwaW5fbG9ja19iaCgm
d3ZpZi0+cHNfc3RhdGVfbG9jayk7Ci0Jd3ZpZi0+c3RhX2FzbGVlcF9tYXNrID0gMDsKLQl3Znhf
YmhfcmVxdWVzdF90eCh3dmlmLT53ZGV2KTsKLQlzcGluX3VubG9ja19iaCgmd3ZpZi0+cHNfc3Rh
dGVfbG9jayk7Ci19Ci0KIHZvaWQgd2Z4X3N1c3BlbmRfcmVzdW1lKHN0cnVjdCB3ZnhfdmlmICp3
dmlmLAogCQkJY29uc3Qgc3RydWN0IGhpZl9pbmRfc3VzcGVuZF9yZXN1bWVfdHggKmFyZykKIHsK
LQlpZiAoYXJnLT5zdXNwZW5kX3Jlc3VtZV9mbGFncy5iY19tY19vbmx5KSB7Ci0JCWJvb2wgY2Fu
Y2VsX3RtbyA9IGZhbHNlOworCWJvb2wgY2FuY2VsX3RtbyA9IGZhbHNlOwogCi0JCXNwaW5fbG9j
a19iaCgmd3ZpZi0+cHNfc3RhdGVfbG9jayk7Ci0JCWlmICghYXJnLT5zdXNwZW5kX3Jlc3VtZV9m
bGFncy5yZXN1bWUpCi0JCQl3dmlmLT5tY2FzdF90eCA9IGZhbHNlOwotCQllbHNlCi0JCQl3dmlm
LT5tY2FzdF90eCA9IHd2aWYtPmFpZDBfYml0X3NldCAmJgotCQkJCQkgd3ZpZi0+bWNhc3RfYnVm
ZmVyZWQ7Ci0JCWlmICh3dmlmLT5tY2FzdF90eCkgewotCQkJY2FuY2VsX3RtbyA9IHRydWU7Ci0J
CQl3ZnhfYmhfcmVxdWVzdF90eCh3dmlmLT53ZGV2KTsKLQkJfQotCQlzcGluX3VubG9ja19iaCgm
d3ZpZi0+cHNfc3RhdGVfbG9jayk7Ci0JCWlmIChjYW5jZWxfdG1vKQotCQkJZGVsX3RpbWVyX3N5
bmMoJnd2aWYtPm1jYXN0X3RpbWVvdXQpOwotCX0gZWxzZSBpZiAoYXJnLT5zdXNwZW5kX3Jlc3Vt
ZV9mbGFncy5yZXN1bWUpIHsKLQkJd2Z4X2R0aW1fbm90aWZ5KHd2aWYpOwotCX0gZWxzZSB7CisJ
aWYgKCFhcmctPnN1c3BlbmRfcmVzdW1lX2ZsYWdzLmJjX21jX29ubHkpIHsKIAkJZGV2X3dhcm4o
d3ZpZi0+d2Rldi0+ZGV2LCAidW5zdXBwb3J0ZWQgc3VzcGVuZC9yZXN1bWUgbm90aWZpY2F0aW9u
XG4iKTsKKwkJcmV0dXJuOwogCX0KKworCXNwaW5fbG9ja19iaCgmd3ZpZi0+cHNfc3RhdGVfbG9j
ayk7CisJaWYgKCFhcmctPnN1c3BlbmRfcmVzdW1lX2ZsYWdzLnJlc3VtZSkKKwkJd3ZpZi0+bWNh
c3RfdHggPSBmYWxzZTsKKwllbHNlCisJCXd2aWYtPm1jYXN0X3R4ID0gd3ZpZi0+YWlkMF9iaXRf
c2V0ICYmCisJCQkJIHd2aWYtPm1jYXN0X2J1ZmZlcmVkOworCWlmICh3dmlmLT5tY2FzdF90eCkg
eworCQljYW5jZWxfdG1vID0gdHJ1ZTsKKwkJd2Z4X2JoX3JlcXVlc3RfdHgod3ZpZi0+d2Rldik7
CisJfQorCXNwaW5fdW5sb2NrX2JoKCZ3dmlmLT5wc19zdGF0ZV9sb2NrKTsKKwlpZiAoY2FuY2Vs
X3RtbykKKwkJZGVsX3RpbWVyX3N5bmMoJnd2aWYtPm1jYXN0X3RpbWVvdXQpOwogfQogCiBpbnQg
d2Z4X2FkZF9jaGFuY3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAotLSAKMi4yNS4wCgo=
