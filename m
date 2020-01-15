Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267AC13C023
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbgAOMNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:13:24 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:31808
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730228AbgAOMNW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iqR+LEG8x+sNaDVK7gnAtwmWT9aPVwLs34LQWo0QS110WmsdCeLVP6hobPiwsvi4qElfD9ZZY5LhIyiiH+w03mrhkNAHyRnttOVK7AssLS45jXVVFtuSWENIQGi7QZ2F2q6GbV/WNiILd9NIyGpfHP9uaazyo+4ve1fQPybP1d9TsONBwD5LCP8B+MNyqo9fW5oHiPCL9+uOe9AP8R9ZSHRfr9VaX9aBmdFAdHRcOF8rMzz0Mx9ePc0dn+zly2TQGniBczoP1nInubmpzGEbif4an/A7Z+TJl5G4ysEfn+EPIZltQiaJJUqxs8YZLJKYVV522++cUlmZa0sD9HDWGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83XLPoKJOHbwgxaYl6x/ur2Ey8D+6u88X4pvsRD0nwY=;
 b=Zc2PV0uCk8jvzzC1uVNiPvPp48O7WfCG3J8l7G9HPl4H5gaB6R2DOJK5lxrq7cdRCRhLd+YTL9IIHOUb3TFxtGjV5pJz6+VSX0Px9KVc2Rp5r2kK2cSR6GL5xwvuutlsz/1n6wo+/hPBLvBs5v0KVegsgM9ZAsnEisDYBpEe7E+aJBQwicpZiArY3bk7PNHRyhtnR6sJn094MJjYiNix/6bV0Ldtz807CHPoWZCblYKjcPkWxmDn+FbVw8wWDAi6P09bRCF3N+4n3tTxgbYjNYMkQMT057PGHcwgsBJ8YOfs+iosVVNwiaKDBrVPfn2hB1qs2ss9+yZEKavX9wt0BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83XLPoKJOHbwgxaYl6x/ur2Ey8D+6u88X4pvsRD0nwY=;
 b=K1dbEoER4Z9UNZRG+XSiRJNI0+MYR5YR6AhYWAg9ZKu02jOfHgFxeV55DMW21MvwEk6DzO8ccfp+Qc1S56d4/IKpeF+ip2NC33HgzBRW3Woiwyz9FF5ruX28yOQ+qssTaD/tuTiSCxIv4NU0CeOKNjAaRFOHx6tuQhQ6mKuZGtk=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:19 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:19 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:48 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 30/65] staging: wfx: simplify hif_set_association_mode()
Thread-Topic: [PATCH 30/65] staging: wfx: simplify hif_set_association_mode()
Thread-Index: AQHVy50aX1wStvuIQkKM+/3XwIvfFA==
Date:   Wed, 15 Jan 2020 12:12:49 +0000
Message-ID: <20200115121041.10863-31-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 999f97ae-5f67-42c5-ec57-08d799b43ce2
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096DC28D1D85AE028FB77AC93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K7M9DAIAi+8BaYgufucqm22ba1YRlmlJryfAYdDz0PI+R1+pHeEaAP8AfuliwwL32hwnYXC8THCGBefan8vl180ekIWs+sJdylj9pc1lX5KPrj7KWjdM7NaIw0OX3gHPoVoraNpm3hZEpgGu6hlX06NLDn4U3Kd0YTMfEp7Gcz9+WedI2O/kZahAAheH8WKpvbU38widD4oCRYnZSbecRdOtQ2ZEUmn/B5JzWRJdxSeP5e2eD8nW0PhXKNCnvQvxD35vDHmllq1HOH9t4x8PpCLvq9Sr1kKWkVHwdYdxoQpsDS1Usm7uzuG6+0M2s91iPwo7jij/Vai2HC2TQaBPbYvYWuNmXDku2xNCOa6FUCvtPvd8GYc7899e/qFR9VfaI1FmjaNZ7vDBRnp7DCE94xfsG3IxvU4CKg8Mgx0rcHu1fE2IDst+gjZqhZ9auE76
Content-Type: text/plain; charset="utf-8"
Content-ID: <2C363E75B42A8D4DBFA8F6B10BA2A17F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 999f97ae-5f67-42c5-ec57-08d799b43ce2
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:49.2910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UCkTcN2pErUU6p1JKjZs5zh7huQzJrS8GDLwBBFM/LCJyyZ1JmNMiKrCwwe4Vu5/wN/EBCpu3PtE9zvVBsoirg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
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
