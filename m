Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D4B13C40A
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgAONzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:55 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:2785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbgAONzq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QGD6RDn+eBl1yBAACLGm00V8g0RiDotxL9MolbBDZI5USYgGqlRW7AUUuYYLvl2nh9Up748ZXaL5saQSDEiPeYXX4OWhG+/UvOB+rxakyeXcE/ddAxfw/rII8A7CCh7WPdFAVf6TcPI1b5iMwFoR6oLIiWt6m8KUflo+kONAjkoFlFebhsuNsGZ4AXzdoe3xj7r/Hfwx7nufchuvUM0a4GuB+3RJQe8pljK6gay0W8Sf7VujXR9uEQR/LDYgLB3gUn+Z/Qmd6L87MlafLEmgAfxxwSx6l6/ze+yIuuHzK0BxHRhsTZKsI9oVRlScT+P5/7pbGcE5JTPHFfLr84yzeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lth01pwnvd1VKz3M1apCRW9wn/D3pZfNBvY7HmUha+Y=;
 b=du1wzLyJqk83eGvyb3UJQ61oOasN0AOdTJZhsiDQ5CskQtW1uZLbTT2x2YvIynHOP+BZZKtKcAz7408oFkJL4uOchl1TDnTrd+iLQjUo4AnyGKpn4nlZO/oLi6uWJ94cFXGoChAeLDKAi2M8Enw9OIqjmcXLcyze/sGF/n1TNKCTF0fT0a/BPRcSLDd46N6C05oZ04OW10EhwYJUsYDrEyHMDTbUqQFtvfZAwW6BVGE3V1Ot55IEVLnreGdmNkw+gvgEBCID35OQ8Dt9zKky5Uax7TtSNKX9Cuq0g2IjrKw7kLcEm73l0LNxWkftDtMoF/2DSND9NftFOt6d/budmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lth01pwnvd1VKz3M1apCRW9wn/D3pZfNBvY7HmUha+Y=;
 b=EyN7rPKxO3myZmuz2fZ6V+oUF/gPXyMGKrlbeOQvLNg+Pm85cWWKbA9g21EVWhNTUf7zq8qXEl+pJLc6/JLHyMbFupyJJWObhlr4aepStec9zTOdgSvC10nhIyIE2f3tdYXwHxjruF/6/IsoRA5xYjlf51blC7X73HfTZ5oI0V0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:30 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:30 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:20 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 54/65] staging: wfx: sta and dtim
Thread-Topic: [PATCH v2 54/65] staging: wfx: sta and dtim
Thread-Index: AQHVy6ttVcenlxcO1EKX1Q2hSlIFWg==
Date:   Wed, 15 Jan 2020 13:55:21 +0000
Message-ID: <20200115135338.14374-55-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 1ad99bb7-a777-4b5f-c75a-08d799c28faa
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40946B4AB4CC6C0E53D244AF93370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F70YYYCzkWHFY/Sxu0mpGJdMYIkH6sGe0pOk/5y3a/LwZYFzHNN9vK7Wh4hJ1l+piJSbK5WOZieTufCy7T5cmjvaEspHja1UZqfOf5B1Rhzd7zc6YlgmpWwPmnNRrPoN+sznY59UwNnCfNC24CP8TP6oA/l0jkaTihxr+50NiOGnb4EpOIsy5WvreonDwZiVo1chTQiUPFhwUV3eGofuUNUzW33PtzJfWry+KYwKIwYtZ/VZ3b+7iuGd2Ikq0KmNYEIJEyVXnfg6IU7jD/ohmRQBUWCYYk0GWVMowBfX/IUurAhkxaD02/UYy9VSRD6LUdPqs3raP3VaxuwS7P6AKChvgjzCPJDTDWAW9wzFjpD4BKhO3K4BnlLQEF9vR5zBoHCZniEZl7rGRckNQ62pFN/7NjjA1duGNu/F+bByuAuoApbZBIp0/iAGXpZ6Xb5W
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACFABC59BA6F8048801F24EDCCB5DBA1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ad99bb7-a777-4b5f-c75a-08d799c28faa
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:21.1032
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qQksKHMkVs1wQ1wbjYLVO91lz0yriW60NhDgmj+93RshOk6wKXEWKXinFA2BGqQVB7y4EFPF3EuxwboSA2wJBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3BzX25vdGlmeSgpIGlzIGNhbGxlZCBmb3IgYW55IGNoYW5nZXMgaW4gdGhlIFRJTS4gSG93ZXZl
ciwKYXNzb2NpYXRpb24gSUQgMCBpcyBhIHZlcnkgc3BlY2lhbCBjYXNlIHRoYXQgc2hvdWxkIGJl
IGhhbmRsZWQKaW5kZXBlbmRlbnRseS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVy
IDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jIHwgMzMgKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdl
ZCwgMTUgaW5zZXJ0aW9ucygrKSwgMTggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggYzI0
OWEyOTUzYmIwLi45ZjRjNTY2NTE3YTEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtODM5LDIxICs4MzksMTMg
QEAgdm9pZCB3ZnhfYnNzX2luZm9fY2hhbmdlZChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJ
d2Z4X2RvX2pvaW4od3ZpZik7CiB9CiAKLXN0YXRpYyB2b2lkIHdmeF9wc19ub3RpZnkoc3RydWN0
IHdmeF92aWYgKnd2aWYsIGVudW0gc3RhX25vdGlmeV9jbWQgbm90aWZ5X2NtZCwKLQkJCSAgaW50
IGxpbmtfaWQpCitzdGF0aWMgdm9pZCB3ZnhfcHNfbm90aWZ5X3N0YShzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZiwKKwkJCSAgICAgIGVudW0gc3RhX25vdGlmeV9jbWQgbm90aWZ5X2NtZCwgaW50IGxpbmtf
aWQpCiB7CiAJdTMyIGJpdCwgcHJldjsKIAogCXNwaW5fbG9ja19iaCgmd3ZpZi0+cHNfc3RhdGVf
bG9jayk7Ci0JLyogWmVybyBsaW5rIGlkIG1lYW5zICJmb3IgYWxsIGxpbmsgSURzIiAqLwotCWlm
IChsaW5rX2lkKSB7Ci0JCWJpdCA9IEJJVChsaW5rX2lkKTsKLQl9IGVsc2UgaWYgKG5vdGlmeV9j
bWQgIT0gU1RBX05PVElGWV9BV0FLRSkgewotCQlkZXZfd2Fybih3dmlmLT53ZGV2LT5kZXYsICJ1
bnN1cHBvcnRlZCBub3RpZnkgY29tbWFuZFxuIik7Ci0JCWJpdCA9IDA7Ci0JfSBlbHNlIHsKLQkJ
Yml0ID0gd3ZpZi0+bGlua19pZF9tYXAgJiB+MTsKLQl9CisJYml0ID0gQklUKGxpbmtfaWQpOwog
CXByZXYgPSB3dmlmLT5zdGFfYXNsZWVwX21hc2sgJiBiaXQ7CiAKIAlzd2l0Y2ggKG5vdGlmeV9j
bWQpIHsKQEAgLTg2Nyw3ICs4NTksNyBAQCBzdGF0aWMgdm9pZCB3ZnhfcHNfbm90aWZ5KHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9jbWQsCiAJY2FzZSBT
VEFfTk9USUZZX0FXQUtFOgogCQlpZiAocHJldikgewogCQkJd3ZpZi0+c3RhX2FzbGVlcF9tYXNr
ICY9IH5iaXQ7Ci0JCQlpZiAobGlua19pZCAmJiAhd3ZpZi0+c3RhX2FzbGVlcF9tYXNrKQorCQkJ
aWYgKCF3dmlmLT5zdGFfYXNsZWVwX21hc2spCiAJCQkJc2NoZWR1bGVfd29yaygmd3ZpZi0+bWNh
c3Rfc3RvcF93b3JrKTsKIAkJCXdmeF9iaF9yZXF1ZXN0X3R4KHd2aWYtPndkZXYpOwogCQl9CkBA
IC04ODIsNyArODc0LDcgQEAgdm9pZCB3Znhfc3RhX25vdGlmeShzdHJ1Y3QgaWVlZTgwMjExX2h3
ICpodywgc3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiA9
IChzdHJ1Y3Qgd2Z4X3ZpZiAqKSB2aWYtPmRydl9wcml2OwogCXN0cnVjdCB3Znhfc3RhX3ByaXYg
KnN0YV9wcml2ID0gKHN0cnVjdCB3Znhfc3RhX3ByaXYgKikgJnN0YS0+ZHJ2X3ByaXY7CiAKLQl3
ZnhfcHNfbm90aWZ5KHd2aWYsIG5vdGlmeV9jbWQsIHN0YV9wcml2LT5saW5rX2lkKTsKKwl3Znhf
cHNfbm90aWZ5X3N0YSh3dmlmLCBub3RpZnlfY21kLCBzdGFfcHJpdi0+bGlua19pZCk7CiB9CiAK
IHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV90aW0oc3RydWN0IHdmeF92aWYgKnd2aWYpCkBAIC05OTMs
NiArOTg1LDE0IEBAIGludCB3ZnhfYW1wZHVfYWN0aW9uKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3
LAogCXJldHVybiAtRU5PVFNVUFA7CiB9CiAKK3N0YXRpYyB2b2lkIHdmeF9kdGltX25vdGlmeShz
dHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKK3sKKwlzcGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xv
Y2spOworCXd2aWYtPnN0YV9hc2xlZXBfbWFzayA9IDA7CisJd2Z4X2JoX3JlcXVlc3RfdHgod3Zp
Zi0+d2Rldik7CisJc3Bpbl91bmxvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xvY2spOworfQorCiB2
b2lkIHdmeF9zdXNwZW5kX3Jlc3VtZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkJCWNvbnN0IHN0
cnVjdCBoaWZfaW5kX3N1c3BlbmRfcmVzdW1lX3R4ICphcmcpCiB7CkBAIC0xMDEzLDEyICsxMDEz
LDkgQEAgdm9pZCB3Znhfc3VzcGVuZF9yZXN1bWUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCWlm
IChjYW5jZWxfdG1vKQogCQkJZGVsX3RpbWVyX3N5bmMoJnd2aWYtPm1jYXN0X3RpbWVvdXQpOwog
CX0gZWxzZSBpZiAoYXJnLT5zdXNwZW5kX3Jlc3VtZV9mbGFncy5yZXN1bWUpIHsKLQkJLy8gRklY
TUU6IHNob3VsZCBjaGFuZ2UgZWFjaCBzdGF0aW9uIHN0YXR1cyBpbmRlcGVuZGVudGx5Ci0JCXdm
eF9wc19ub3RpZnkod3ZpZiwgU1RBX05PVElGWV9BV0FLRSwgMCk7Ci0JCXdmeF9iaF9yZXF1ZXN0
X3R4KHd2aWYtPndkZXYpOworCQl3ZnhfZHRpbV9ub3RpZnkod3ZpZik7CiAJfSBlbHNlIHsKLQkJ
Ly8gRklYTUU6IHNob3VsZCBjaGFuZ2UgZWFjaCBzdGF0aW9uIHN0YXR1cyBpbmRlcGVuZGVudGx5
Ci0JCXdmeF9wc19ub3RpZnkod3ZpZiwgU1RBX05PVElGWV9TTEVFUCwgMCk7CisJCWRldl93YXJu
KHd2aWYtPndkZXYtPmRldiwgInVuc3VwcG9ydGVkIHN1c3BlbmQvcmVzdW1lIG5vdGlmaWNhdGlv
blxuIik7CiAJfQogfQogCi0tIAoyLjI1LjAKCg==
