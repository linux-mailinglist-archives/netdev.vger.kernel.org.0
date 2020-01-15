Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0528C13C44C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgAON55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:57:57 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729992AbgAONzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KviYz/AclFeEBPFDA9k37lVMRfA0ImRL9Bjf6DXXCRooveAiOQoElB++uNkRKqG9EdNePW9PH7jftRvofE20VS13jP+tEjCk07Ba2kACXOWT56PFCghjydND/N6U7KO2tdY64D4kh2aSvUwnSYFzNvQ8uOoXHfrfBectKdwPyos8CeUSfrXQlAj1e5ji8OB/PdsTNOyLX6BW8IM3gf+ROqISb5+eJpmZByn6SFwWh0+hE6t48XCZtltG2jks7YHhp0MTPzaL+LUTlYulCtEMfpxwHJh3IP3VaktTgLOBu/GyTShWGqLuMuWm+7KANRCrMXz3lo671bijiOH/WPABvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7v2gd1eExIciwm3NgwAWQLFhiL+CYtyNgPfkRRku7kc=;
 b=U6kpALnzI/oou0z288zq5nBL25o/6cqVWcsEUuKOjoui8yUKrtQdilkyWDnLq9FJmUvr231eYKD0pNLY4tOfP8G13MTCtREppzWylOW0X9p295A1zBPZft54doR21UEAtQU0AVo/BNMatlUx95Lc5Hlmbb4ZogryO/3Q+yUSh6JJVtPB1oSfhEdtLcrFu3uLeMzJmk0JuS9SbUvSRYaOtqedpbKnspk60rfvxZLBsPmeaJ0OzgVQ4iRn5mXk7X8nsz/QGbylq0/kK0EdveSiJoP6kiDgXtA2vGIMmUyujL55wJWDL66JxoWtUOIRErq3HB05YlOwj0GiqmJg4vG95w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7v2gd1eExIciwm3NgwAWQLFhiL+CYtyNgPfkRRku7kc=;
 b=PSN0k8Na6kH5Bfr7tvtQRHqy2LjrPc4n3XrOU56ZyaoGiHdLg47caeVD+SSV2d1K1anWXrzD3IL3SCX/eKxQJ7JasSI4XdCZ89a+zuUI+Av1zGZblzd3ZC95wQ+imC/Xe4ylhC5jQk/sJ36f4pM6pLlQrsDT2QRoeDyKRI+XSxc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:30 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:21 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 55/65] staging: wfx: firmware never return PS status for
 stations
Thread-Topic: [PATCH v2 55/65] staging: wfx: firmware never return PS status
 for stations
Thread-Index: AQHVy6tuk5n2JuFaUkqsh3lyGWV0Cw==
Date:   Wed, 15 Jan 2020 13:55:22 +0000
Message-ID: <20200115135338.14374-56-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: f288aa97-f01b-4338-3a9b-08d799c2907d
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36613AF048FD8151BE4E14FA93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +DpsURisWY2hNmxbC00/Iji0SSqlS8isJeBMvyaR5Nbha3HdWE8zrjDqocWlR7EHxBGcZzJe8pxUOXlNJiDtfRhtv5gPxItrjC/rcjNvTJcjdF27/30y7jDXRwBcRJsPaNKinjJtyPQJSE0lCsPEHHrqSWRRnIWgJbRE3xtImqxtNmH+Bxnlj3jhX7MockKGeDM9rl8z2QzSKnydgMbBcCcT2McSGx83jT7UVMc0o0cntxU08OPffZHM3WLRtD5Z9kw6kHVKx2afCkpjnX35K6YzixIxfVg/WitDdz4UB12nFsHv+lOsbv8gD8r5OhbfWhumrczjhZdLgSEWESuZ8higaLTYjT74tR9Cb8d/2NO+1cNpZLuMbcjPXcyJyD4O8Fni8H4GsLB5TGXwqMyYZ6liu2xFz0NvR1QHRBlS9nu4GisPZwCqCQTDu+O6DwIe
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A164A8CA90988409ACDDB4CD5B7DB78@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f288aa97-f01b-4338-3a9b-08d799c2907d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:22.5924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kilqQsja5hSRzP+o6X6iVcYnXI4THMq96uWhiSAABq+hss4mOjCsxBOzxF891FPvFgRSR7M3+JrE6oArRRc40w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
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
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggOWY0YzU2NjUxN2ExLi43YzllOTNmNTI5OTMgMTAwNjQ0
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
