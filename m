Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1AFD13C06B
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbgAOMMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:12:45 -0500
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:27390
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730698AbgAOMMn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUqoQJH6ZfLWqE78d/3mCYzbCh7IESQyd4bR6V3b72TtNbVbUPjum0I60aaQaVb1BwOzqm3vB0ueiKCNOgYbAqMUMEwr/gYzQrFEXrd/K2y8/4dUttUC+CPTVHPRsQqeRG/wPJUD2MFBI42qsvwy0Sw2qB3jzk3Z3jUbGV4EOC8G+aHDUKagSh3lv1zYgKvNN77v1A6pkVDggqTguGrp3bYuY+bTsN2BATY8ouj8YTs3sgebi7s9mK9AgSb0YNG+IQxyiETX18liFp6U0zVXL0YtFSlh6Vfs/fWECD7PptNw389tYv1KVL/6veD+tuJMbCbAiGWh+1P23iDNQIE83w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b50yWk0WdKoZEN9INKqfong0gAhkN4IuUW7QgFNvUOc=;
 b=b0Ri/iRh+CQQ+D+h0l0liSHW6FhipwDHmQ0UETTnWe73n/WqjpeuvAEiIkGv5KG6MW8PILDRMsb0cA7/6TRVRPooBJuyxHfaRJSAGzf7bL25NnTfNPfcwkj0jREWMJEzPZzI4ToskZU0z5ehJOeoOIT6MBG39cvYRcssHvNFyFsmJwoNw08OfKuhuOsldID3zcFfIx0TqM9lPpkBu2uBHaLYrXZitbi81qkyDFJgh2eJsfYmZVHTri+8NwPSCu+ZI1HGzrtyQId80PpfZm7tBSUclDgoGeGjMsy13h5U7EeLQmRL+jrOoYKOlhxwM6tVFl/kM902Lkd8gKElInc/Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b50yWk0WdKoZEN9INKqfong0gAhkN4IuUW7QgFNvUOc=;
 b=TNQ+1hu6/10rXS87I+UUzPng1hQaRGPA8kin2h/6l5H7Iy/DIiV6ki4EV67f2EdKpkK6TYV5/+nBbZZUWkN74HEDPL3EVKUXuJkYM8Xds/ClOMpmaKHCzH01aZmr05qA4dVzUD1e9psWDMdbAsCnMHsNRe9Mqg/lSaZ+4YLGt0E=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:38 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:38 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:37 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 22/65] staging: wfx: drop wvif->dtim_period
Thread-Topic: [PATCH 22/65] staging: wfx: drop wvif->dtim_period
Thread-Index: AQHVy50UQPIxOEH670msKKVPymhU0g==
Date:   Wed, 15 Jan 2020 12:12:38 +0000
Message-ID: <20200115121041.10863-23-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: a8d35155-db27-46bb-6034-08d799b43686
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096066B7EF5B560AF60289A93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J090Owbzf/Nbuc05nZRHJKsJptsXbzahK6wtFK/Oqzw8e2aun6qdDob/tc2viWu06A9/EiH9SgNvgCHidAe6hF4s+lR48J7qiCif5NMJCi4whAJvyskKiaej5NQqYofFtHpazJ6C9/1ZI+/eP4sUK71ceIlrF8W40iqQXGn/1HZpEeIUYzKw/8KDBJBhZXle99NdLnGl+5W7Umz5aaXHws53zzzCupAjrmP4UIZCZXqQlmYqNqhGiLARCGWWOkYUnWwTvXBxQMV6YDk8SudrmzxblLa24i79A1JihdZshm/7XFeuHLkGO1ZFvlSSWFIxFpn+kcYElQEOC0cmWlLvmQr1r4xVRe2SWJNSIMDBiTA0oZ9j079Nx+9cnk6Si6WfnTMuu1iZBmKY6oJmq0fF4aa0rdkPZqGT/hxhOb8uJLX740FmhhTkPKmZ5731pUBF
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AF613F12ED9E743A39CBCA025978E58@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d35155-db27-46bb-6034-08d799b43686
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:38.6042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6D3wvYpOcqgw4U4XGaB85BIZiGpPD4biRuN1vsr3GfNPWl0+S5r+VxJd+crUdVd2SmOYs3nFXfxgUDfwHvKnDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm90IG5lY2Vzc2FyeSB0byBrZWVwIGEgY29weSBvZiBkdGltX3BlcmlvZCBpbiB3Znhfdmlm
LiBQcmVmZXIgdG8KanVzdCByZWx5IG9uIGJzc19jb25mLT5kdGltX3BlcmlvZC4KClNpZ25lZC1v
ZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0t
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMjAgKysrKy0tLS0tLS0tLS0tLS0tLS0KIGRy
aXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCAgMSAtCiAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKSwgMTcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggMWFmOTliNzkzMGY0Li4z
NzY0NTE0MzNlOWUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIv
ZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNDY0LDcgKzQ2NCw2IEBAIHN0YXRpYyB2b2lk
IHdmeF9kb191bmpvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJaGlmX2tlZXBfYWxpdmVfcGVy
aW9kKHd2aWYsIDApOwogCWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7CiAJd2Z4X3R4X3BvbGljeV9p
bml0KHd2aWYpOwotCXd2aWYtPmR0aW1fcGVyaW9kID0gMDsKIAloaWZfc2V0X21hY2FkZHIod3Zp
Ziwgd3ZpZi0+dmlmLT5hZGRyKTsKIAl3ZnhfZnJlZV9ldmVudF9xdWV1ZSh3dmlmKTsKIAljYW5j
ZWxfd29ya19zeW5jKCZ3dmlmLT5ldmVudF9oYW5kbGVyX3dvcmspOwpAQCAtNTU3LDEwICs1NTYs
NiBAQCBzdGF0aWMgdm9pZCB3ZnhfZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAkJd3Zp
Zi0+YmVhY29uX2ludCA9IDE7CiAKIAlqb2luLmJlYWNvbl9pbnRlcnZhbCA9IHd2aWYtPmJlYWNv
bl9pbnQ7Ci0KLQkvLyBEVElNIHBlcmlvZCB3aWxsIGJlIHNldCBvbiBmaXJzdCBCZWFjb24KLQl3
dmlmLT5kdGltX3BlcmlvZCA9IDA7Ci0KIAlqb2luLmNoYW5uZWxfbnVtYmVyID0gd3ZpZi0+Y2hh
bm5lbC0+aHdfdmFsdWU7CiAJbWVtY3B5KGpvaW4uYnNzaWQsIGJzc2lkLCBzaXplb2Yoam9pbi5i
c3NpZCkpOwogCkBAIC03MDEsOCArNjk2LDYgQEAgc3RhdGljIGludCB3Znhfc3RhcnRfYXAoc3Ry
dWN0IHdmeF92aWYgKnd2aWYpCiAJaW50IHJldDsKIAogCXd2aWYtPmJlYWNvbl9pbnQgPSB3dmlm
LT52aWYtPmJzc19jb25mLmJlYWNvbl9pbnQ7Ci0Jd3ZpZi0+ZHRpbV9wZXJpb2QgPSB3dmlmLT52
aWYtPmJzc19jb25mLmR0aW1fcGVyaW9kOwotCiAJbWVtc2V0KCZ3dmlmLT5saW5rX2lkX2RiLCAw
LCBzaXplb2Yod3ZpZi0+bGlua19pZF9kYikpOwogCiAJd3ZpZi0+d2Rldi0+dHhfYnVyc3RfaWR4
ID0gLTE7CkBAIC03NjYsMTAgKzc1OSw3IEBAIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXpl
KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCXN0cnVjdCBpZWVlODAyMTFfc3RhICpzdGEgPSBOVUxM
OwogCXN0cnVjdCBoaWZfbWliX3NldF9hc3NvY2lhdGlvbl9tb2RlIGFzc29jaWF0aW9uX21vZGUg
PSB7IH07CiAKLQlpZiAoaW5mby0+ZHRpbV9wZXJpb2QpCi0JCXd2aWYtPmR0aW1fcGVyaW9kID0g
aW5mby0+ZHRpbV9wZXJpb2Q7CiAJd3ZpZi0+YmVhY29uX2ludCA9IGluZm8tPmJlYWNvbl9pbnQ7
Ci0KIAlyY3VfcmVhZF9sb2NrKCk7CiAJaWYgKGluZm8tPmJzc2lkICYmICFpbmZvLT5pYnNzX2pv
aW5lZCkKIAkJc3RhID0gaWVlZTgwMjExX2ZpbmRfc3RhKHd2aWYtPnZpZiwgaW5mby0+YnNzaWQp
OwpAQCAtODA0LDkgKzc5NCw2IEBAIHN0YXRpYyB2b2lkIHdmeF9qb2luX2ZpbmFsaXplKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLAogCXd2aWYtPmJzc19wYXJhbXMuYmVhY29uX2xvc3RfY291bnQgPSAy
MDsKIAl3dmlmLT5ic3NfcGFyYW1zLmFpZCA9IGluZm8tPmFpZDsKIAotCWlmICh3dmlmLT5kdGlt
X3BlcmlvZCA8IDEpCi0JCXd2aWYtPmR0aW1fcGVyaW9kID0gMTsKLQogCWhpZl9zZXRfYXNzb2Np
YXRpb25fbW9kZSh3dmlmLCAmYXNzb2NpYXRpb25fbW9kZSk7CiAKIAlpZiAoIWluZm8tPmlic3Nf
am9pbmVkKSB7CkBAIC0xMDU1LDkgKzEwNDIsMTAgQEAgaW50IHdmeF9zZXRfdGltKHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLCBib29sIHNldCkKIAog
c3RhdGljIHZvaWQgd2Z4X21jYXN0X3N0YXJ0X3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQogewotCXN0cnVjdCB3ZnhfdmlmICp3dmlmID0gY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCB3
ZnhfdmlmLAotCQkJCQkgICAgbWNhc3Rfc3RhcnRfd29yayk7Ci0JbG9uZyB0bW8gPSB3dmlmLT5k
dGltX3BlcmlvZCAqIFRVX1RPX0pJRkZJRVMod3ZpZi0+YmVhY29uX2ludCArIDIwKTsKKwlzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiA9CisJCWNvbnRhaW5lcl9vZih3b3JrLCBzdHJ1Y3Qgd2Z4X3ZpZiwg
bWNhc3Rfc3RhcnRfd29yayk7CisJc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAqY29uZiA9ICZ3
dmlmLT52aWYtPmJzc19jb25mOworCWxvbmcgdG1vID0gY29uZi0+ZHRpbV9wZXJpb2QgKiBUVV9U
T19KSUZGSUVTKHd2aWYtPmJlYWNvbl9pbnQgKyAyMCk7CiAKIAljYW5jZWxfd29ya19zeW5jKCZ3
dmlmLT5tY2FzdF9zdG9wX3dvcmspOwogCWlmICghd3ZpZi0+YWlkMF9iaXRfc2V0KSB7CmRpZmYg
LS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93
ZnguaAppbmRleCBkMjAxY2NlZWMxYWIuLmJkNGI1NWUwN2M3MyAxMDA2NDQKLS0tIGEvZHJpdmVy
cy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC05
OCw3ICs5OCw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlzcGlubG9ja190CQlwc19zdGF0ZV9sb2Nr
OwogCXN0cnVjdCB3b3JrX3N0cnVjdAlzZXRfdGltX3dvcms7CiAKLQlpbnQJCQlkdGltX3Blcmlv
ZDsKIAlpbnQJCQliZWFjb25faW50OwogCWJvb2wJCQllbmFibGVfYmVhY29uOwogCWJvb2wJCQlm
aWx0ZXJfYnNzaWQ7Ci0tIAoyLjI1LjAKCg==
