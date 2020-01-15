Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C39C13BF87
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731991AbgAOMON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:14:13 -0500
Received: from mail-bn7nam10on2064.outbound.protection.outlook.com ([40.107.92.64]:33252
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731673AbgAOMNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBh4Y08K0w8HE9sxblNhpWvS/R9cYFtOEsAF0MN7cefjEEseQUypIT/ZYeniPai6185r/OgiyOOG1VY070b7NYxEnNwb8X+5WNMFD7ErC1Bv/xdudSivA51v1OEuuZNo2FtIZERQ7IG9J7QunPnvPlLDeMhLGZv2rYPEvNIAW+fRerwSsDIXosjPQrGCrKSxoMGkqzebSyWw/HEm3hQtn4Mf6TwMcq7osQfPe0suyVlfhi+jvoXMFtVl9wtThMOrmMBONijVx5e/OLsKdk1p4If85zDB4viUEYaOm1x122nt9hQSKKjQ19USFpyceBJBPbQIjxyxn6zk7M6GOWEDqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOfkk1dzUC/6ez+F5LEQHcokA7G0L9veToOFnzjqtGc=;
 b=FjQ3FLHIwc/z4rzUanEB8ye8k8Xw9n0RY1dYf/AO5pYzSjdjkirHMOVRfBUJpTykYtMvlFtKs3wq52GzSoglFTVVusEtv1D8HrVjkqxq+L4MZIGlDICMz7PGMXhVCotdgPp6AGbzxxikGIYUPbdUjpeWNhe5Fnpg1716T6HldMNReFfWNl6lKZTomnTPT3B5XGp6MGNDaFRIecUHe+Q2swAkdLvPSAFjA8RZcLzhZZZR55oaSUbekA6hrvvPTdrTHcLy4AjK2igSRN70fPCddR3xcND3AFh3SNFkJbaigtipTutfc7JiEjvc3iJw/ms/Wc0K/zBePZ4ZNYp60+Q3WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GOfkk1dzUC/6ez+F5LEQHcokA7G0L9veToOFnzjqtGc=;
 b=NibSf/RK+EHrPsp0R3M4D1g5zVjyfcOFOVc95DQ4/Asma9wb/l/tRpO824cCoAEAfMpUZHk6fHSL9siJoPICNmgri4++03KI1ULA17XOMwer3JvIWffUikBbS9pIqxq+oebwOiGz5fsP/LWLQwyCimXPcZnaBdL/7ptMCRAcxoo=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3934.namprd11.prod.outlook.com (10.255.180.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.20; Wed, 15 Jan 2020 12:13:33 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:33 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:13:18 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 53/65] staging: wfx: pspoll_mask make no sense
Thread-Topic: [PATCH 53/65] staging: wfx: pspoll_mask make no sense
Thread-Index: AQHVy50sVno8itD1SEeZHKH340+g7w==
Date:   Wed, 15 Jan 2020 12:13:19 +0000
Message-ID: <20200115121041.10863-54-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: aaa1a99d-f173-4142-c042-08d799b44f09
x-ms-traffictypediagnostic: MN2PR11MB3934:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB39344A69DEEB0EDE4EFFFCE493370@MN2PR11MB3934.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:283;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(376002)(366004)(346002)(199004)(189003)(54906003)(110136005)(86362001)(956004)(107886003)(2616005)(316002)(36756003)(71200400001)(52116002)(7696005)(478600001)(8936002)(81156014)(8676002)(4326008)(81166006)(6486002)(2906002)(26005)(66946007)(16526019)(186003)(5660300002)(66574012)(1076003)(66556008)(64756008)(66446008)(85182001)(66476007)(85202003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3934;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LGeeV9p1rMvugEHmbAbpHiakR8EcuRoNUCuNusK5ZGI9vHj2kfylpKTLg3MWqBQ2m6vFexY6O0APHeBGydUNqT/B8Bm8LWC0960hPd946Pjhi33+N6ewkmqdzFiMMM+7cyv59ijtCVUlchqNgsOXBSDI0wjlJdihZyQQqSWh3fPgqNCKILiHcxRKkE+G5+XKJjzMxBlnoNy7RWbJ0oNy2+O9I98JLMSo8tNQX16h0czFftY2w3Qq15D8kE01T3sm223/WcVG/zxL1Zs4yCJjihjOMc5YVUm9SEM9THe/0IJC1G+QL5LwLbGUhZjjqpu2Sa6og0v9J0z+bSgEbICogzM+SVMLZxFcJm9GZzd7TjIgOVYTWy68wsW+UMbAPjbJOXhPIURMmJMs7hRTCQ5uCQLC1KCr+LMTTDYc+pD0XFxHvl8BPmpZ8T76Mj9/3quz
Content-Type: text/plain; charset="utf-8"
Content-ID: <D71D5B2F443326408388F1BFBC39F846@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaa1a99d-f173-4142-c042-08d799b44f09
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:13:19.7195
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MSrfxtv+CQ5IueRNroK5Cg/9hGoA8qMvo9OieA51DYOxtXLhNViL5O6kGn7Ver3uDwX9Eoc05h8QuXtIes5ziA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3934
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKcHNw
b2xsX21hc2sgaXMgaGVyZSB0byBzZW5kIGRhdGEgYnVmZmVyZWQgaW4gZHJpdmVyLiBCdXQgc2lu
Y2Ugc3RhdGlvbgppcyBtYXJrZWQgYnVmZmVyZWQsIFRJTSBmb3IgdGhpcyBzdGF0aW9uIGlzIDEg
YW5kIG1hYzgwMjExIHdpbGwgY2FsbApzdGFfbm90aWZ5IHdoZW4gYSBwcy1wb2xsIGlzIHJlY2Vp
dmVkLiBTbyBwc3BvbGxfbWFzayBpcyB1c2VsZXNzIGFuZApzdGFfYWxzZWVwX21hc2sgaXMgc3Vm
ZmljaWVudC4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxs
ZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYyB8IDM5IC0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2Rh
dGFfdHguYyB8ICA0ICstLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYyAgIHwgIDggKyst
LS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgfCAgMiAtLQogZHJpdmVycy9zdGFn
aW5nL3dmeC93ZnguaCAgICAgfCAgMSAtCiA1IGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygr
KSwgNTEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRh
X3J4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfcnguYwppbmRleCA2OTllMmQ2MGZhODku
LjVkMTk4NDU3YzZjZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3J4LmMKQEAgLTEzLDQxICsxMyw2IEBACiAj
aW5jbHVkZSAiYmguaCIKICNpbmNsdWRlICJzdGEuaCIKIAotc3RhdGljIGludCB3ZnhfaGFuZGxl
X3BzcG9sbChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgc3RydWN0IHNrX2J1ZmYgKnNrYikKLXsKLQlz
dHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhOwotCXN0cnVjdCBpZWVlODAyMTFfcHNwb2xsICpwc3Bv
bGwgPSAoc3RydWN0IGllZWU4MDIxMV9wc3BvbGwgKilza2ItPmRhdGE7Ci0JaW50IGxpbmtfaWQg
PSAwOwotCXUzMiBwc3BvbGxfbWFzayA9IDA7Ci0JaW50IGk7Ci0KLQlpZiAod3ZpZi0+c3RhdGUg
IT0gV0ZYX1NUQVRFX0FQKQotCQlyZXR1cm4gMTsKLQlpZiAoIWV0aGVyX2FkZHJfZXF1YWwod3Zp
Zi0+dmlmLT5hZGRyLCBwc3BvbGwtPmJzc2lkKSkKLQkJcmV0dXJuIDE7Ci0KLQlyY3VfcmVhZF9s
b2NrKCk7Ci0Jc3RhID0gaWVlZTgwMjExX2ZpbmRfc3RhKHd2aWYtPnZpZiwgcHNwb2xsLT50YSk7
Ci0JaWYgKHN0YSkKLQkJbGlua19pZCA9ICgoc3RydWN0IHdmeF9zdGFfcHJpdiAqKSZzdGEtPmRy
dl9wcml2KS0+bGlua19pZDsKLQlyY3VfcmVhZF91bmxvY2soKTsKLQlpZiAobGlua19pZCkKLQkJ
cHNwb2xsX21hc2sgPSBCSVQobGlua19pZCk7Ci0JZWxzZQotCQlyZXR1cm4gMTsKLQotCXd2aWYt
PnBzcG9sbF9tYXNrIHw9IHBzcG9sbF9tYXNrOwotCS8qIERvIG5vdCByZXBvcnQgcHNwb2xzIGlm
IGRhdGEgZm9yIGdpdmVuIGxpbmsgaWQgaXMgcXVldWVkIGFscmVhZHkuICovCi0JZm9yIChpID0g
MDsgaSA8IElFRUU4MDIxMV9OVU1fQUNTOyArK2kpIHsKLQkJaWYgKHdmeF90eF9xdWV1ZV9nZXRf
bnVtX3F1ZXVlZCgmd3ZpZi0+d2Rldi0+dHhfcXVldWVbaV0sCi0JCQkJCQlwc3BvbGxfbWFzaykp
IHsKLQkJCXdmeF9iaF9yZXF1ZXN0X3R4KHd2aWYtPndkZXYpOwotCQkJcmV0dXJuIDE7Ci0JCX0K
LQl9Ci0JcmV0dXJuIDA7Ci19Ci0KIHN0YXRpYyBpbnQgd2Z4X2Ryb3BfZW5jcnlwdF9kYXRhKHN0
cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCQkJCSBjb25zdCBzdHJ1Y3QgaGlmX2luZF9yeCAqYXJnLAog
CQkJCSBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQpAQCAtMTI1LDEwICs5MCw2IEBAIHZvaWQgd2Z4X3J4
X2NiKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCQlnb3RvIGRyb3A7CiAJfQogCi0JaWYgKGllZWU4
MDIxMV9pc19wc3BvbGwoZnJhbWUtPmZyYW1lX2NvbnRyb2wpKQotCQlpZiAod2Z4X2hhbmRsZV9w
c3BvbGwod3ZpZiwgc2tiKSkKLQkJCWdvdG8gZHJvcDsKLQogCWhkci0+YmFuZCA9IE5MODAyMTFf
QkFORF8yR0haOwogCWhkci0+ZnJlcSA9IGllZWU4MDIxMV9jaGFubmVsX3RvX2ZyZXF1ZW5jeShh
cmctPmNoYW5uZWxfbnVtYmVyLAogCQkJCQkJICAgaGRyLT5iYW5kKTsKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4
LmMKaW5kZXggN2RhMWFmZDZlOWI1Li43OTE0YzA2NTc4YWEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
CkBAIC0yODYsMTAgKzI4Niw4IEBAIHN0YXRpYyB2b2lkIHdmeF90eF9tYW5hZ2VfcG0oc3RydWN0
IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVlODAyMTFfaGRyICpoZHIsCiAJaW50IHRpZCA9IGll
ZWU4MDIxMV9nZXRfdGlkKGhkcik7CiAKIAlzcGluX2xvY2tfYmgoJnd2aWYtPnBzX3N0YXRlX2xv
Y2spOwotCWlmIChpZWVlODAyMTFfaXNfYXV0aChoZHItPmZyYW1lX2NvbnRyb2wpKSB7CisJaWYg
KGllZWU4MDIxMV9pc19hdXRoKGhkci0+ZnJhbWVfY29udHJvbCkpCiAJCXd2aWYtPnN0YV9hc2xl
ZXBfbWFzayAmPSBtYXNrOwotCQl3dmlmLT5wc3BvbGxfbWFzayAmPSBtYXNrOwotCX0KIAogCWlm
ICh0eF9wcml2LT5saW5rX2lkID09IFdGWF9MSU5LX0lEX0FGVEVSX0RUSU0gJiYKIAkgICAgIXd2
aWYtPm1jYXN0X2J1ZmZlcmVkKSB7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKaW5kZXggM2Q0MDM4ODczOWUzLi40
MmQ2NDUzNGM5MmMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvcXVldWUuYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1ZXVlLmMKQEAgLTQ5MywxMiArNDkzLDEwIEBAIHN0YXRp
YyBpbnQgd2Z4X3R4X3F1ZXVlX21hc2tfZ2V0KHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCS8qIFNl
YXJjaCBmb3IgdW5pY2FzdCB0cmFmZmljICovCiAJdHhfYWxsb3dlZF9tYXNrID0gfnd2aWYtPnN0
YV9hc2xlZXBfbWFzazsKIAl0eF9hbGxvd2VkX21hc2sgfD0gQklUKFdGWF9MSU5LX0lEX1VBUFNE
KTsKLQlpZiAod3ZpZi0+c3RhX2FzbGVlcF9tYXNrKSB7Ci0JCXR4X2FsbG93ZWRfbWFzayB8PSB3
dmlmLT5wc3BvbGxfbWFzazsKKwlpZiAod3ZpZi0+c3RhX2FzbGVlcF9tYXNrKQogCQl0eF9hbGxv
d2VkX21hc2sgJj0gfkJJVChXRlhfTElOS19JRF9BRlRFUl9EVElNKTsKLQl9IGVsc2UgeworCWVs
c2UKIAkJdHhfYWxsb3dlZF9tYXNrIHw9IEJJVChXRlhfTElOS19JRF9BRlRFUl9EVElNKTsKLQl9
CiAJaWR4ID0gd2Z4X2dldF9wcmlvX3F1ZXVlKHd2aWYsIHR4X2FsbG93ZWRfbWFzaywgJnRvdGFs
KTsKIAlpZiAoaWR4IDwgMCkKIAkJcmV0dXJuIC1FTk9FTlQ7CkBAIC01ODUsOCArNTgzLDYgQEAg
c3RydWN0IGhpZl9tc2cgKndmeF90eF9xdWV1ZXNfZ2V0KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQog
CQlpZiAoaGlmX2hhbmRsZV90eF9kYXRhKHd2aWYsIHNrYiwgcXVldWUpKQogCQkJY29udGludWU7
ICAvKiBIYW5kbGVkIGJ5IFdTTSAqLwogCi0JCXd2aWYtPnBzcG9sbF9tYXNrICY9IH5CSVQodHhf
cHJpdi0+cmF3X2xpbmtfaWQpOwotCiAJCS8qIGFsbG93IGJ1cnN0aW5nIGlmIHR4b3AgaXMgc2V0
ICovCiAJCWlmICh3dmlmLT5lZGNhX3BhcmFtc1txdWV1ZV9udW1dLnR4b3ApCiAJCQlidXJzdCA9
IChpbnQpd2Z4X3R4X3F1ZXVlX2dldF9udW1fcXVldWVkKHF1ZXVlLCB0eF9hbGxvd2VkX21hc2sp
ICsgMTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDYxZDY0YmViNjE0My4uNjY5N2M3MzZhMDU0IDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKQEAgLTg2Nyw3ICs4NjcsNiBAQCBzdGF0aWMgdm9pZCB3ZnhfcHNfbm90aWZ5KHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5vdGlmeV9jbWQsCiAJY2FzZSBT
VEFfTk9USUZZX0FXQUtFOgogCQlpZiAocHJldikgewogCQkJd3ZpZi0+c3RhX2FzbGVlcF9tYXNr
ICY9IH5iaXQ7Ci0JCQl3dmlmLT5wc3BvbGxfbWFzayAmPSB+Yml0OwogCQkJaWYgKGxpbmtfaWQg
JiYgIXd2aWYtPnN0YV9hc2xlZXBfbWFzaykKIAkJCQlzY2hlZHVsZV93b3JrKCZ3dmlmLT5tY2Fz
dF9zdG9wX3dvcmspOwogCQkJd2Z4X2JoX3JlcXVlc3RfdHgod3ZpZi0+d2Rldik7CkBAIC0xMTc4
LDcgKzExNzcsNiBAQCB2b2lkIHdmeF9yZW1vdmVfaW50ZXJmYWNlKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LAogCQl3dmlmLT5tY2FzdF90eCA9IGZhbHNlOwogCQl3dmlmLT5haWQwX2JpdF9zZXQg
PSBmYWxzZTsKIAkJd3ZpZi0+bWNhc3RfYnVmZmVyZWQgPSBmYWxzZTsKLQkJd3ZpZi0+cHNwb2xs
X21hc2sgPSAwOwogCQkvKiByZXNldC5saW5rX2lkID0gMDsgKi8KIAkJaGlmX3Jlc2V0KHd2aWYs
IGZhbHNlKTsKIAkJYnJlYWs7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5o
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAppbmRleCAzNjVhYWNjMDczZmIuLjg0OTFmMDUw
NDc4ZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3dmeC5oCkBAIC05MSw3ICs5MSw2IEBAIHN0cnVjdCB3ZnhfdmlmIHsKIAlz
dHJ1Y3Qgd29ya19zdHJ1Y3QJdHhfcG9saWN5X3VwbG9hZF93b3JrOwogCiAJdTMyCQkJc3RhX2Fz
bGVlcF9tYXNrOwotCXUzMgkJCXBzcG9sbF9tYXNrOwogCXNwaW5sb2NrX3QJCXBzX3N0YXRlX2xv
Y2s7CiAJc3RydWN0IHdvcmtfc3RydWN0CXVwZGF0ZV90aW1fd29yazsKIAotLSAKMi4yNS4wCgo=
