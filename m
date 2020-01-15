Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E313513C47E
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAONzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:20 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729728AbgAONzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZS1g+BhRcsh1+EYU28ZNZaUER02f6lcht9f56bcJC1wkydzvI5zBUV6868KuONKzoJ+eD1DzEey8/KIJpn9QeTyeR58NfPdDQU+Yc/BPkpA9uYQXhN+UZRaBkuMtbdN/TLvVaxgppEI9trnyjjeXDMy+WknosBxOWd8/B8KS1PXlM4H0dJUlaiQf8NeQBh2BAQPwktDkleL6MTnPhl9d5UBtIOOI3TQIvWIwiXkYfr2gDnizgePhmDPunMwlCtOhEsuX7isQcsnj8C7Fc42RaWjk58NIuJpnFGMQqfLb85IE/uSU/i8pLgooIjAgIwGkrBLVB/jC37FRTgDTRfRd3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83XLPoKJOHbwgxaYl6x/ur2Ey8D+6u88X4pvsRD0nwY=;
 b=CoALfwlM/z/b/L9FvjGzI0GVk00eBScXP8faXnr1QdEoTIZAsZqz6QfmwlwppcojRjczbRkelhbn3XH4yKC8kLeXy7AyCBC4uEdBjcOU/3Khsg6+Gt4Lb6E61ZT2FEnR7uFgh4U2wjIdXos6fUhvR1plrORrDMEwq4QewyI94nmRMb1Anc+94DK3d85LFq7sKOm2ue5heY7KozMNrKvZvvVuRZbNEE/47jo9uQmh6GXP75RLKv1CWUzAaV4y5aiWISo3sPoLaNuiv41W9S9rPLWxGvRo3p2mX8Lc6KiMTjh47qvNULjie0AkFDA4OfHwmlEjbl1sB79sWv8Apm/OuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83XLPoKJOHbwgxaYl6x/ur2Ey8D+6u88X4pvsRD0nwY=;
 b=TnblwiSt6akUQs3v+61E1vjjaA37h6tAHAdAVMmDwVEq9mhxoyKfzKqxAInY99NaFJqd3kich1qT165rvKV10xxcp45MinEQymKSIhGZQfHdhkLSh5/UYamm98bnNIXs1u4B3cMrcr52ksTG8pr+4MoITpA292Ylbqw/vFqY9hM=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:16 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:16 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:45 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 30/65] staging: wfx: simplify hif_set_association_mode()
Thread-Topic: [PATCH v2 30/65] staging: wfx: simplify
 hif_set_association_mode()
Thread-Index: AQHVy6tYdBfJhrYIq0+G0WpEU/sZWA==
Date:   Wed, 15 Jan 2020 13:54:46 +0000
Message-ID: <20200115135338.14374-31-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 386c424c-f0d1-40d2-47a1-08d799c27b30
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB366100E45B066F34150AD1C493370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8LPDo53B5Zk0Wd+z1VToVtG5qPZanGkeEPrao0HO40osdMnxAvN20K15wTKcr1k0GykHNStGV0SxYHNjKdZkH0fQdJzNCXM7J9mWMup90aGsw/lruzcRgR/0iv80piizfMprwV59bH4AX2ynuJ9vK765tsJH1RIkaynfWPTl6LVVdRSRDk5dcxrabqsHkX40gO4S8j7sSC95pPO49raWLkYtIdiqYAT3nn+AKKviiVzzMOEZDoRY0f6UZux24SvO2iOqNARz3sxjrTmcufrrppBQ6ySiEbIH9alvZ+R1FNJCEOMSIde93fH5uzM5uUE+jAySfnWS1DEd4a49sg7zk1pox+g9Cn6G5NgqAlYl+zB7smwhBFL0oodhU1V/7kegmMxGwF+Zi1LvADmwrQ9d27P62tqUcSYglgdI1Ri3PG/srfi2x6KjL0bmxdqe+MAQ
Content-Type: text/plain; charset="utf-8"
Content-ID: <E99742FE638F1144A1AA6E88AAA8CF42@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386c424c-f0d1-40d2-47a1-08d799c27b30
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:46.7820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ll7Qlw+rnhY5GgVS0IOpExJSuObVLTsn+PXQHbzo1EGhegtMA+Ga5X/5Nj1m+0X/OYuGXso5NVVoTIgZgUY1Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX3NldF9hc3NvY2lhdGlvbl9tb2RlIGNvbWUgZnJvbSBoYXJkd2Fy
ZSBBUEkuIEl0IGlzCm5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1cHBlciBsYXll
cnMgb2YgdGhlIGRyaXZlci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZfc2V0X2Fzc29j
aWF0aW9uX21vZGUoKSBpcyB0b28gZHVtYi4gSXQKc2hvdWxkIHBhY2sgZGF0YSB3aXRoIGhhcmR3
YXJlIHJlcHJlc2VudGF0aW9uIGluc3RlYWQgb2YgbGVhdmluZyBhbGwKd29yayB0byB0aGUgY2Fs
bGVyLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIHwgMjIgKysr
KysrKysrKysrKysrKysrKystLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAgfCAx
NiArLS0tLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDE3
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKaW5kZXggNWIzOTIwMGJkNjk3
Li5lZWM2ZjQxNTdlNjAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCkBAIC0xOTEsMTAgKzE5
MSwyOCBAQCBzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X2Jsb2NrX2Fja19wb2xpY3koc3RydWN0
IHdmeF92aWYgKnd2aWYsCiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfYXNzb2NpYXRp
b25fbW9kZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCQkJICAgc3RydWN0IGhpZl9taWJfc2V0
X2Fzc29jaWF0aW9uX21vZGUgKmFyZykKKwkJCQkJICAgc3RydWN0IGllZWU4MDIxMV9ic3NfY29u
ZiAqaW5mbywKKwkJCQkJICAgc3RydWN0IGllZWU4MDIxMV9zdGFfaHRfY2FwICpodF9jYXApCiB7
CisJaW50IGJhc2ljX3JhdGVzID0gd2Z4X3JhdGVfbWFza190b19odyh3dmlmLT53ZGV2LCBpbmZv
LT5iYXNpY19yYXRlcyk7CisJc3RydWN0IGhpZl9taWJfc2V0X2Fzc29jaWF0aW9uX21vZGUgdmFs
ID0geworCQkucHJlYW1idHlwZV91c2UgPSAxLAorCQkubW9kZSA9IDEsCisJCS5yYXRlc2V0ID0g
MSwKKwkJLnNwYWNpbmcgPSAxLAorCQkuc2hvcnRfcHJlYW1ibGUgPSBpbmZvLT51c2Vfc2hvcnRf
cHJlYW1ibGUsCisJCS5iYXNpY19yYXRlX3NldCA9IGNwdV90b19sZTMyKGJhc2ljX3JhdGVzKQor
CX07CisKKwkvLyBGSVhNRTogaXQgaXMgc3RyYW5nZSB0byBub3QgcmV0cmlldmUgYWxsIGluZm9y
bWF0aW9uIGZyb20gYnNzX2luZm8KKwlpZiAoaHRfY2FwICYmIGh0X2NhcC0+aHRfc3VwcG9ydGVk
KSB7CisJCXZhbC5tcGR1X3N0YXJ0X3NwYWNpbmcgPSBodF9jYXAtPmFtcGR1X2RlbnNpdHk7CisJ
CWlmICghKGluZm8tPmh0X29wZXJhdGlvbl9tb2RlICYgSUVFRTgwMjExX0hUX09QX01PREVfTk9O
X0dGX1NUQV9QUlNOVCkpCisJCQl2YWwuZ3JlZW5maWVsZCA9ICEhKGh0X2NhcC0+Y2FwICYgSUVF
RTgwMjExX0hUX0NBUF9HUk5fRkxEKTsKKwl9CisKIAlyZXR1cm4gaGlmX3dyaXRlX21pYih3dmlm
LT53ZGV2LCB3dmlmLT5pZCwKLQkJCSAgICAgSElGX01JQl9JRF9TRVRfQVNTT0NJQVRJT05fTU9E
RSwgYXJnLCBzaXplb2YoKmFyZykpOworCQkJICAgICBISUZfTUlCX0lEX1NFVF9BU1NPQ0lBVElP
Tl9NT0RFLCAmdmFsLCBzaXplb2YodmFsKSk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9z
ZXRfdHhfcmF0ZV9yZXRyeV9wb2xpY3koc3RydWN0IHdmeF92aWYgKnd2aWYsCmRpZmYgLS1naXQg
YS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpp
bmRleCAzMGM2MmUzYjM3MTYuLjkwMzA2ODE4NThiYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC03MTIsNyAr
NzEyLDYgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2
aWYsCiAJCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19jb25mICppbmZvKQogewogCXN0cnVj
dCBpZWVlODAyMTFfc3RhICpzdGEgPSBOVUxMOwotCXN0cnVjdCBoaWZfbWliX3NldF9hc3NvY2lh
dGlvbl9tb2RlIGFzc29jaWF0aW9uX21vZGUgPSB7IH07CiAKIAl3dmlmLT5iZWFjb25faW50ID0g
aW5mby0+YmVhY29uX2ludDsKIAlyY3VfcmVhZF9sb2NrKCk7CkBAIC03MzAsMjYgKzcyOSwxMyBA
QCBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAll
bHNlCiAJCWhpZl9kdWFsX2N0c19wcm90ZWN0aW9uKHd2aWYsIGZhbHNlKTsKIAotCWFzc29jaWF0
aW9uX21vZGUucHJlYW1idHlwZV91c2UgPSAxOwotCWFzc29jaWF0aW9uX21vZGUubW9kZSA9IDE7
Ci0JYXNzb2NpYXRpb25fbW9kZS5yYXRlc2V0ID0gMTsKLQlhc3NvY2lhdGlvbl9tb2RlLnNwYWNp
bmcgPSAxOwotCWFzc29jaWF0aW9uX21vZGUuc2hvcnRfcHJlYW1ibGUgPSBpbmZvLT51c2Vfc2hv
cnRfcHJlYW1ibGU7Ci0JYXNzb2NpYXRpb25fbW9kZS5iYXNpY19yYXRlX3NldCA9IGNwdV90b19s
ZTMyKHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+d2RldiwgaW5mby0+YmFzaWNfcmF0ZXMpKTsK
LQlpZiAoc3RhICYmIHN0YS0+aHRfY2FwLmh0X3N1cHBvcnRlZCAmJgotCSAgICAhKGluZm8tPmh0
X29wZXJhdGlvbl9tb2RlICYgSUVFRTgwMjExX0hUX09QX01PREVfTk9OX0dGX1NUQV9QUlNOVCkp
Ci0JCWFzc29jaWF0aW9uX21vZGUuZ3JlZW5maWVsZCA9Ci0JCQkhIShzdGEtPmh0X2NhcC5jYXAg
JiBJRUVFODAyMTFfSFRfQ0FQX0dSTl9GTEQpOwotCWlmIChzdGEgJiYgc3RhLT5odF9jYXAuaHRf
c3VwcG9ydGVkKQotCQlhc3NvY2lhdGlvbl9tb2RlLm1wZHVfc3RhcnRfc3BhY2luZyA9IHN0YS0+
aHRfY2FwLmFtcGR1X2RlbnNpdHk7Ci0KIAl3ZnhfY3FtX2Jzc2xvc3Nfc20od3ZpZiwgMCwgMCwg
MCk7CiAJY2FuY2VsX3dvcmtfc3luYygmd3ZpZi0+dW5qb2luX3dvcmspOwogCiAJd3ZpZi0+YnNz
X3BhcmFtcy5iZWFjb25fbG9zdF9jb3VudCA9IDIwOwogCXd2aWYtPmJzc19wYXJhbXMuYWlkID0g
aW5mby0+YWlkOwogCi0JaGlmX3NldF9hc3NvY2lhdGlvbl9tb2RlKHd2aWYsICZhc3NvY2lhdGlv
bl9tb2RlKTsKKwloaWZfc2V0X2Fzc29jaWF0aW9uX21vZGUod3ZpZiwgaW5mbywgc3RhID8gJnN0
YS0+aHRfY2FwIDogTlVMTCk7CiAKIAlpZiAoIWluZm8tPmlic3Nfam9pbmVkKSB7CiAJCWhpZl9r
ZWVwX2FsaXZlX3BlcmlvZCh3dmlmLCAzMCAvKiBzZWMgKi8pOwotLSAKMi4yNS4wCgo=
