Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59E9513C442
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbgAON4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:56:40 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:2785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730040AbgAONzh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0verkCuahh3GTMn/J8ZNpZAo06RdhnCj8JA2Z4kVUnJEWsEpCuJ2LLPuSk0niBux1n2BsulvGRBnHNEAmKydB0atd7ofD0aQVIHlKekZRdlOB74RK26vKw/HWbWhO+qxiXTnjy1l5BoQd+YCM5XuEY1Cy8mvz3HUTPUyqYTvNMHW+4uGwejPJ100Jzv6rdnU9MZoHD7+1kuWctyLTeGtPn4yN4R84Jz5890M9zdTloatby2AyJBOa6ZSIF1NT8GVfc8aRom1tfj+mihLyQKoER5/+MCd9GKuvrccvGCupyRfDc+Y+LmekCPgvUq27Fch3TtHeSM/9NlLaRXMuKm9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al1Suf7asEdXDlAgY+GihgZrRYhE2CYrZa2Hmh7IEOw=;
 b=Ff1iBeTMTP3o4G4oJn9aKYMzANvsMYDG7hQJLuqE78+oI6hbMHQgVGvnmmUFASxqVbY5ZdB4rjbEJMRk2J4DWqJ2HZM0YlMYLdK0OZoOh6n4o2+qe+v49QBLTNboScWBnbpGUcu5jzsvwuLrGXzPy+jDe994C9zujEu1wsW28jYsZEOej/M+Kt0UaRHFeI2WmF6AkdjU4QaCHMxGHwwsTOrqvm+o8Z2TY4279YNWihWLAJ/201qXHn82/+Kxxv7SiCI+4mhAVk9AZSlroVjAWFBrz0vjYWLXhQgGytzg77VyRzUGb9CN8Dra/VN6ABTaUWwkKxLJsFgh7VeExrj8Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al1Suf7asEdXDlAgY+GihgZrRYhE2CYrZa2Hmh7IEOw=;
 b=Zvqy5x5dWw/hkSF1XSTsm1EfCw+ZbYlx7PtuyFTowRKIeA6+iHRfehUC1UYvx75dKpBt6hFXbddqdt7bJVmflo3M7ej+BetocKp2gM6TthYB93xAKL0q39v3n2UX4SPzeBhQdJNZ2ESqAoQf8VWjhpAkAihts6hJx3F0PQyR6Hk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:25 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:25 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:09 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 47/65] staging: wfx: fix bss_loss
Thread-Topic: [PATCH v2 47/65] staging: wfx: fix bss_loss
Thread-Index: AQHVy6tnhftv2aZMEU6oRLHUQewePA==
Date:   Wed, 15 Jan 2020 13:55:10 +0000
Message-ID: <20200115135338.14374-48-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 7d7321ac-2b57-46a1-8ca0-08d799c28992
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB409413207F242D1D6C3A342493370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(6666004)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LAUFTak0rVAf0S+i6QK0h0fjJKR+ArLwYtDzEpPoiI+m2hT6LfaIRtMw8vx5amAKRdF7ltDRLa+WvL65d+qGsgGruqcoluzR3AQTsxF4p3PGfAaJghB1RUYDzG9hw71oUS7EeeYaXRl5LA3pQ7Gxw6c2w9f0z2+tUiuX4ecWVFBRdd5kWlLZ0cmCaTg4MD6XABeYGYaTyIX8VNX+jV29JAZpxg8Lp+1bF68XHYnLTxy3j8XtV9lrPb/LIp+fYBFpz3ucL+9evOw5Hm7w47QuiqUtBPr0FLcbbRTH3kHH5tlEnhnKSn8wEvruCjX9NaANcRWyQ9IbtNS/ZruK1MwOP/teulLYkAX9hpkJviNFbdJJp17VsrHuny99OOM1O8yvZX4yagqh6d15T4sPOn9z0MZfOHvoXz5fMnEXtiIKDwL+Xp3akIVQRlnQ1xUxHEVS
Content-Type: text/plain; charset="utf-8"
Content-ID: <22F3F573D434D346ABEA3324DA769F50@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d7321ac-2b57-46a1-8ca0-08d799c28992
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:10.8851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xyOXFL/WapsE8GyFv50JrtBgyceXwxE3CWJ7mByF4gPSFYP+cM/3nNwlHVct0dWq+jykE759dlASrHbG9BS2HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
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
cy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhZWJjZTk2ZGNkNGEuLjFjMTBlYmQxMTk0NCAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jCkBAIC04OCwxOSArODgsMjUgQEAgdm9pZCB3ZnhfY3FtX2Jzc2xvc3Nfc20oc3Ry
dWN0IHdmeF92aWYgKnd2aWYsIGludCBpbml0LCBpbnQgZ29vZCwgaW50IGJhZCkKIAkvLyBGSVhN
RTogY2FsbCBpZWVlODAyMTFfYmVhY29uX2xvc3MvaWVlZTgwMjExX2Nvbm5lY3Rpb25fbG9zcyBp
bnN0ZWFkCiAJaWYgKHR4KSB7CiAJCXN0cnVjdCBza19idWZmICpza2I7CisJCXN0cnVjdCBpZWVl
ODAyMTFfaGRyICpoZHI7CisJCXN0cnVjdCBpZWVlODAyMTFfdHhfY29udHJvbCBjb250cm9sID0g
eyB9OwogCiAJCXd2aWYtPmJzc19sb3NzX3N0YXRlKys7CiAKIAkJc2tiID0gaWVlZTgwMjExX251
bGxmdW5jX2dldCh3dmlmLT53ZGV2LT5odywgd3ZpZi0+dmlmLCBmYWxzZSk7CiAJCWlmICghc2ti
KQogCQkJZ290byBlbmQ7CisJCWhkciA9IChzdHJ1Y3QgaWVlZTgwMjExX2hkciAqKXNrYi0+ZGF0
YTsKIAkJbWVtc2V0KElFRUU4MDIxMV9TS0JfQ0Ioc2tiKSwgMCwKIAkJICAgICAgIHNpemVvZigq
SUVFRTgwMjExX1NLQl9DQihza2IpKSk7CiAJCUlFRUU4MDIxMV9TS0JfQ0Ioc2tiKS0+Y29udHJv
bC52aWYgPSB3dmlmLT52aWY7CiAJCUlFRUU4MDIxMV9TS0JfQ0Ioc2tiKS0+ZHJpdmVyX3JhdGVz
WzBdLmlkeCA9IDA7CiAJCUlFRUU4MDIxMV9TS0JfQ0Ioc2tiKS0+ZHJpdmVyX3JhdGVzWzBdLmNv
dW50ID0gMTsKIAkJSUVFRTgwMjExX1NLQl9DQihza2IpLT5kcml2ZXJfcmF0ZXNbMV0uaWR4ID0g
LTE7Ci0JCXdmeF90eCh3dmlmLT53ZGV2LT5odywgTlVMTCwgc2tiKTsKKwkJcmN1X3JlYWRfbG9j
aygpOyAvLyBwcm90ZWN0IGNvbnRyb2wuc3RhCisJCWNvbnRyb2wuc3RhID0gaWVlZTgwMjExX2Zp
bmRfc3RhKHd2aWYtPnZpZiwgaGRyLT5hZGRyMSk7CisJCXdmeF90eCh3dmlmLT53ZGV2LT5odywg
JmNvbnRyb2wsIHNrYik7CisJCXJjdV9yZWFkX3VubG9jaygpOwogCX0KIGVuZDoKIAltdXRleF91
bmxvY2soJnd2aWYtPmJzc19sb3NzX2xvY2spOwotLSAKMi4yNS4wCgo=
