Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E71F413C4D1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbgAOOCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 09:02:13 -0500
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:6092
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728921AbgAONyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8z6Wj5Kv3iQRMsEaIsYM1uQXtqugGwHJRpe3GgcORT3Z3ywsGWqmXHyKnywZtnmyfOVJx9wCL78Pu98oUfEbFz0ZjKV751jKSp2CYL1/P6+g4+AJD23XmPyh02zRXGi6hW4uUtSp09tgFLFJz2Q+KHtvmztvClWjXNss+4CSAT/DKlBm8zm2EiGeVYzXPsmAWPMtLZQQW6haZw0dkux0xbg6Da8DB5GB9Z3Lm3cRp32r20x5oTg+PoolDpAAU1JD0t+BfVXGvGfsPfO4D5L8bi2qs6+dm4rRVHsAecWIIWSENeUkftStJb1WmjkofbuJRW3rKXFlGuosW5Fp6OMBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xbX4O+7DVFKMuBoAyyVIDQfYyePPJ696cihc2JM5rQ=;
 b=VyprSv28Ej6GaIM6l9kWbHnli0eaGRjIhVsL5cL/dfc1YnGzt1Pg6QejWUqUM8n0dDJzsGUItT7hXX8nZE3f/2cJTBm7TiKOv6bsHuzFnv0UEIMH1o7PZE1EQK0BGZA7Fikj5UppOf09RPO1hlw3HY1jsmMxvcvrfAy9QQOeMUSvcXDbNLMuy3XtyB4PLdBYsel7w0jEewXH27ty7rsbGmQTjourhV7z9QnKURhzfmG/MVsbVRdErcdAb85CdKUvR+FurVrh2L5xOxirj9fsPpn3hgTp8rN9RLLA33G9kFDoRw0FwzIgLgeF/5IiMNHNy/J8QeC1CfDmd3AJQw69Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1xbX4O+7DVFKMuBoAyyVIDQfYyePPJ696cihc2JM5rQ=;
 b=HwNnMIh7iLXY1gE0s97M3TjRWJSt5FKkxF92j7TMUMemCxbh9V7FSLaf+kVBPG2KKnnf7d5pMMJ/lGxiJcis7GfcjKRTx/O7mvAnNV5aKay9G+yJu4YcJpdJfqyvIZ28CXQ+EomzKY7CKSspP9DlSTaRQ6YAi3oeRgVS6DXk9RY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:13 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:13 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:12 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 08/65] staging: wfx: simplify hif_set_arp_ipv4_filter()
 usage
Thread-Topic: [PATCH v2 08/65] staging: wfx: simplify
 hif_set_arp_ipv4_filter() usage
Thread-Index: AQHVy6tE9/lgazPwXUqL2H/VLmF1rg==
Date:   Wed, 15 Jan 2020 13:54:13 +0000
Message-ID: <20200115135338.14374-9-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: a17c3d4d-e39e-4965-f045-08d799c2675a
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB366102EB8FD020D9CE63599593370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YgDMuMEucScAk/jPKdZR50BXkVNw2p3fNAzniVMaEICo1RUsOPDPr0yvLaLofQNlvmu2xjyMN/qrV1DRZNtG7hxJN3Fh4gXOoiufwiNbCrcnesPuqeyiqycF1aeZ7ip5hbUZkaEBXDQt5CtCn9zYtdJrSQ2Fle1SIdGyODBRw0dNmWrp7CeNUDl/uvvbzpO1SRZgK1SV6fpwy3KCbcEgNXQMX5fII93yiCL9vGCuit3OtMNzsIaJBjy+HhouoEv4PklH67siztHn774K2DsYEATVi/LpBx3UUZ+2RxTZVm/9UCml69+OHx1rFhAb5Sv9i3zsBdM1P6yG9mlLsTrVe+W9s3q5zso71BLBJzjqWm4HzT+R0yDhoyX14V2YYE4a/kH+2oMMoHfvfmNQIKKmRW5ymDSpSsIETSatTOKvxmupk7oIhqBy5xrl0oSgdJci
Content-Type: text/plain; charset="utf-8"
Content-ID: <79A659AAF64AF24FA47C4AB0DBB8BD6E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17c3d4d-e39e-4965-f045-08d799c2675a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:13.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eC4MoYcTvCmiTvAUC+fNRNdUz301t9Y1sS2u2gPSV70oDLMHB50NMWBEDTg7XOpqkZFSpXY72gj2+tZjxdzPKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
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
