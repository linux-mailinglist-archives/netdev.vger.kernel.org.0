Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B94861231CE
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfLQQP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:56 -0500
Received: from mail-bn7nam10on2081.outbound.protection.outlook.com ([40.107.92.81]:6496
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728993AbfLQQPv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KokckUPELIkdJuN/VS/I1Hl82Sv6elSjn1iSG3oExz9J3PKMIqX1wc4/ZaAoKXKYAy+3EKYLyiVOOMjgVR5p3DOjrz9ycWNUVSa4lo1FOeHon+aamWXq/+dxicYi2kYgsXfhZ6GzAXbcMnD+Mt4P89oiBZApjx6DlXghT5tcSnl+uEfOrPT5h5FatQdGtXrJG6BIsr7LCMAD/9S1lDGXxUPJvtOmnP/bz8iC7kFDAwYEL1jsYA7bZeXInIRAtQK248GMODHy/1YLldzd6pu/iJKGsTJFfIXOjI+FbCKwhMMMXVlE4tMfUfqKFcAUv98A+4BWmb6m289Zy10JvTuvmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKxfHIn3UfcP8BiheuajfFFSvjD3njr1+SQofPKu/sU=;
 b=J44TFIusLBGUO2ROUKvCRgHNaZVyZUz0EbIuyaGTRyDL8xPVDMHGXPDausW+6Je4SAOnlKdMW37xFs0+XCvdsg3rTOCMSTthBqNTQ/Kg8HUUxUJOThFDqfvpAVzZp2qCmT+WPizZee65VK4gjtyLV48XEhogy2z13Vq/1dkHX2yy0SAkQ2fM1yashmDyvxqMWPYBe6AHqUS8MtN+OudUgGbNts4aJArFM/9JjIaGZozZLZwknv/BOm4uM3g7JuiEULLu1rEf3CEPf9zt/fMakOKa3it1J8R5RGWJMmKiouOCMziqTDG3YS6Bp6M4uV0VP5LgeXVFm+h9ATedtzUNKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKxfHIn3UfcP8BiheuajfFFSvjD3njr1+SQofPKu/sU=;
 b=qGXjKH2aIlvqlQLPCe0fB+01SVzHB2vIfGWrJ62fg05B1bNSttWvLZXljxcc45lyFGxUvBw6lpeVvz/Lfi84zYy3a7J7zOrgINBddOhKFaaleicWvzxGaWoKaFuFXXTES8zM24cW1QNSVHHeQFi9UAz0NQvFE8+Qm61pamFzeoY=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:44 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:44 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 38/55] staging: wfx: prefer a bitmask instead of an array
 of boolean
Thread-Topic: [PATCH v2 38/55] staging: wfx: prefer a bitmask instead of an
 array of boolean
Thread-Index: AQHVtPUt4iwFHdNV4UmHD5bdoL1eVQ==
Date:   Tue, 17 Dec 2019 16:15:20 +0000
Message-ID: <20191217161318.31402-39-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 27d00fd2-14c1-4dde-4f31-08d7830c501c
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208C668A241BF2B77E205AE93500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1060;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NKT1oiInPTPtQP3NYIYiPMgBhXQutcCJ6DDSfiOkPoE34U4c13cN9JISEmVtO8GwMd8lc76FM4dV/FNGRLvM++zULlg1NzUsTdKweNk0j9PT4s8oLmCtkl+ml2T1EXxwdfRfWSzJLuXjw8b0sw4ox8Huu4IyKxx56vT0nwr1vUOUtVhYfGDkxje+dHChHOpVBjSQb1ldGWIiiT34rNnQP99zWEew3tYDdi27Yt0/GYm4prVcSfEx3Teyrh+b2yKUBoXTuPrCKoOvjXNi2upyagNqDeVIWlmgsoFDxsj5HBxGrUTgCTBnq64jWVAcweCVDi9c3LvyGZGueOT/1TcvK5zpDyELJ82TbIwQBma5OdDUZap04gy+2AKnRVvO2fiX2f2yedMYcQBVZNa2JhwnV9yXJqMm7S4UhTviPRyY0Kw57kDdzslnJOSrFdNaQXtV
Content-Type: text/plain; charset="utf-8"
Content-ID: <43A6274CC90D97468DC7CC6E65370619@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27d00fd2-14c1-4dde-4f31-08d7830c501c
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:20.4802
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6etrvSAvei9DvkuDsGH36pN4HBE6U/JmtFKZ0LagiqcYqH5/vpJE9kScnwC1gTY1pXszvibLHsmdPXM2cwIdvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgZWFzaWVyIHRvIG1hbmlwdWxhdGUgYSBpbnQgdGhhbiBhbiBhcnJheSBvZiBib29sZWFucy4K
ClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJz
LmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgMTcgKysrKysrKy0tLS0tLS0t
LS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmggfCAgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCA4
IGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDA0NWQzOTE2
YWRhOC4uZTU5NTYwZjQ5OWVhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTExOSwyMiArMTE5LDIyIEBAIHN0
YXRpYyBpbnQgd2Z4X3NldF91YXBzZF9wYXJhbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAkgKiAg
Vk8gWzAsM10sIFZJIFsxLCAyXSwgQkUgWzIsIDFdLCBCSyBbMywgMF0KIAkgKi8KIAotCWlmIChh
cmctPnVhcHNkX2VuYWJsZVtJRUVFODAyMTFfQUNfVk9dKQorCWlmIChhcmctPnVhcHNkX21hc2sg
JiBCSVQoSUVFRTgwMjExX0FDX1ZPKSkKIAkJd3ZpZi0+dWFwc2RfaW5mby50cmlnX3ZvaWNlID0g
MTsKIAllbHNlCiAJCXd2aWYtPnVhcHNkX2luZm8udHJpZ192b2ljZSA9IDA7CiAKLQlpZiAoYXJn
LT51YXBzZF9lbmFibGVbSUVFRTgwMjExX0FDX1ZJXSkKKwlpZiAoYXJnLT51YXBzZF9tYXNrICYg
QklUKElFRUU4MDIxMV9BQ19WSSkpCiAJCXd2aWYtPnVhcHNkX2luZm8udHJpZ192aWRlbyA9IDE7
CiAJZWxzZQogCQl3dmlmLT51YXBzZF9pbmZvLnRyaWdfdmlkZW8gPSAwOwogCi0JaWYgKGFyZy0+
dWFwc2RfZW5hYmxlW0lFRUU4MDIxMV9BQ19CRV0pCisJaWYgKGFyZy0+dWFwc2RfbWFzayAmIEJJ
VChJRUVFODAyMTFfQUNfQkUpKQogCQl3dmlmLT51YXBzZF9pbmZvLnRyaWdfYmUgPSAxOwogCWVs
c2UKIAkJd3ZpZi0+dWFwc2RfaW5mby50cmlnX2JlID0gMDsKIAotCWlmIChhcmctPnVhcHNkX2Vu
YWJsZVtJRUVFODAyMTFfQUNfQktdKQorCWlmIChhcmctPnVhcHNkX21hc2sgJiBCSVQoSUVFRTgw
MjExX0FDX0JLKSkKIAkJd3ZpZi0+dWFwc2RfaW5mby50cmlnX2Jja2dybmQgPSAxOwogCWVsc2UK
IAkJd3ZpZi0+dWFwc2RfaW5mby50cmlnX2Jja2dybmQgPSAwOwpAQCAtMzMwLDcgKzMzMCw2IEBA
IHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9wbShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHsKIAlzdHJ1
Y3QgaWVlZTgwMjExX2NvbmYgKmNvbmYgPSAmd3ZpZi0+d2Rldi0+aHctPmNvbmY7CiAJc3RydWN0
IGhpZl9yZXFfc2V0X3BtX21vZGUgcG07Ci0JdTE2IHVhcHNkX2ZsYWdzOwogCiAJaWYgKHd2aWYt
PnN0YXRlICE9IFdGWF9TVEFURV9TVEEgfHwgIXd2aWYtPmJzc19wYXJhbXMuYWlkKQogCQlyZXR1
cm4gMDsKQEAgLTM0NSw5ICszNDQsNyBAQCBzdGF0aWMgaW50IHdmeF91cGRhdGVfcG0oc3RydWN0
IHdmeF92aWYgKnd2aWYpCiAJCQlwbS5wbV9tb2RlLmZhc3RfcHNtID0gMTsKIAl9CiAKLQltZW1j
cHkoJnVhcHNkX2ZsYWdzLCAmd3ZpZi0+dWFwc2RfaW5mbywgc2l6ZW9mKHVhcHNkX2ZsYWdzKSk7
Ci0KLQlpZiAodWFwc2RfZmxhZ3MgIT0gMCkKKwlpZiAod3ZpZi0+ZWRjYS51YXBzZF9tYXNrKQog
CQlwbS5wbV9tb2RlLmZhc3RfcHNtID0gMDsKIAogCS8vIEtlcm5lbCBkaXNhYmxlIFBvd2VyU2F2
ZSB3aGVuIG11bHRpcGxlIHZpZnMgYXJlIGluIHVzZS4gSW4gY29udHJhcnksCkBAIC0zNzUsNyAr
MzcyLDcgQEAgaW50IHdmeF9jb25mX3R4KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qg
aWVlZTgwMjExX3ZpZiAqdmlmLAogCVdBUk5fT04ocXVldWUgPj0gaHctPnF1ZXVlcyk7CiAKIAlt
dXRleF9sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKLQl3dmlmLT5lZGNhLnVhcHNkX2VuYWJsZVtx
dWV1ZV0gPSBwYXJhbXMtPnVhcHNkOworCWFzc2lnbl9iaXQocXVldWUsICZ3dmlmLT5lZGNhLnVh
cHNkX21hc2ssIHBhcmFtcy0+dWFwc2QpOwogCWVkY2EgPSAmd3ZpZi0+ZWRjYS5wYXJhbXNbcXVl
dWVdOwogCWVkY2EtPmFpZnNuID0gcGFyYW1zLT5haWZzOwogCWVkY2EtPmN3X21pbiA9IHBhcmFt
cy0+Y3dfbWluOwpAQCAtMTU1Miw5ICsxNTQ5LDkgQEAgaW50IHdmeF9hZGRfaW50ZXJmYWNlKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmKQogCWZvciAo
aSA9IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgaSsrKSB7CiAJCW1lbWNweSgmd3ZpZi0+ZWRj
YS5wYXJhbXNbaV0sICZkZWZhdWx0X2VkY2FfcGFyYW1zW2ldLAogCQkgICAgICAgc2l6ZW9mKGRl
ZmF1bHRfZWRjYV9wYXJhbXNbaV0pKTsKLQkJd3ZpZi0+ZWRjYS51YXBzZF9lbmFibGVbaV0gPSBm
YWxzZTsKIAkJaGlmX3NldF9lZGNhX3F1ZXVlX3BhcmFtcyh3dmlmLCAmd3ZpZi0+ZWRjYS5wYXJh
bXNbaV0pOwogCX0KKwl3dmlmLT5lZGNhLnVhcHNkX21hc2sgPSAwOwogCXdmeF9zZXRfdWFwc2Rf
cGFyYW0od3ZpZiwgJnd2aWYtPmVkY2EpOwogCiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOwpk
aWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaCBiL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmgKaW5kZXggNDcxOTgwN2JjMjVhLi43NDc1NWY2ZmEwMzAgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuaApA
QCAtMzcsNyArMzcsNyBAQCBzdHJ1Y3Qgd2Z4X2hpZl9ldmVudCB7CiBzdHJ1Y3Qgd2Z4X2VkY2Ff
cGFyYW1zIHsKIAkvKiBOT1RFOiBpbmRleCBpcyBhIGxpbnV4IHF1ZXVlIGlkLiAqLwogCXN0cnVj
dCBoaWZfcmVxX2VkY2FfcXVldWVfcGFyYW1zIHBhcmFtc1tJRUVFODAyMTFfTlVNX0FDU107Ci0J
Ym9vbCB1YXBzZF9lbmFibGVbSUVFRTgwMjExX05VTV9BQ1NdOworCXVuc2lnbmVkIGxvbmcgdWFw
c2RfbWFzazsKIH07CiAKIHN0cnVjdCB3ZnhfZ3JwX2FkZHJfdGFibGUgewotLSAKMi4yNC4wCgo=
