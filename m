Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF91C13C098
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgAOMTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:19:55 -0500
Received: from mail-bn7nam10on2050.outbound.protection.outlook.com ([40.107.92.50]:24527
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730223AbgAOMM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:12:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJZbRQolcu1G/oxoklS7YlprRezAnmwhUujEH4xorsoXqAEGydeXElUveSdSTKMwTAofcahtB1hRoOnqWm+q/CC2fouwRop/unnPl0OGl6S8WDLUf45rnGHix/InJPwObTEwvnYpmwOxUCxP7HB2irxX4AdW32HlrwjQ+tDs4uuAxOIBqjSWd83QgD9/St1VdxUheA0Bjm5jTYcYrn4p4tkOyRBNbZ4kmg2oDdCh5nSk4CG5mpOrJnPlQSThoLgZDMPw1wXMkwRj3m0/nCVLlq+nClay7pUggVneQMF52aQqZxYVzDEi3HGIFAs5KxsZXVpp/zcGzG36zHmD1tBX7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyI3qpeaw1sCvgNMoy3SoJLojFxutx56dQKR09Nvy+U=;
 b=e50kVGnCEFrDYPAckq6xODQhI/nn2/lLIJR6jt6nbJsCr2yMQPDyOQ1hHwRXYb51w10AUjtZbiWyrAe53rONjnt+Rm6jeaYbAoiHKc/cDxOgmJUsmhKT6ftRVkZjKICniOdgiu+nT2eIC+YsdWx8lPszJ3uFtI0uAh7CPnNZiw/pm5dCbvXFR2m/zi7W/EwsD546tnTJ88ekZ4sz78I5iickwY/piVHA4WWF12xuvxu+omMtITMlZtT17BcvmKTzslu+LwG9fRCJJO/UTem1aYAZSrSht1Cyy7eKIkkuhuFMdgSj5uAAzMr2z4ZHqS35wgdckqkCsdOiIZZzwqf8+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NyI3qpeaw1sCvgNMoy3SoJLojFxutx56dQKR09Nvy+U=;
 b=hvpE6VqJYBoqvN4QCAVMYnOFA8QtAcPDf5shP9wuAzorulrw1WQ4Ctc6XZe4yXESlEjb+sotTeA5+jiFvSIbloNfenfUA0V/J2rnAhqmbbbATkqRGXChkFukNg04vbFyyBdWrQ2+BoDboPjqFGOggybbAxhSrxXeEdWaLPufzNE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:12:22 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:12:22 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:20 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 10/65] staging: wfx: use specialized structs for HIF arguments
Thread-Topic: [PATCH 10/65] staging: wfx: use specialized structs for HIF
 arguments
Thread-Index: AQHVy50KLWYv+/f8d0mulv7JbySJsA==
Date:   Wed, 15 Jan 2020 12:12:21 +0000
Message-ID: <20200115121041.10863-11-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: c0716d3a-0150-4afb-4942-08d799b42c97
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096794AE5F1D1C92B146FF193370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /e/KnE7tQYi0c/TulMO0txoiV85ovPTTsGasNSSpBa7Y3BsCXW3Ongga3qAiaUy5t2WCzpjBr/qktzxkvA2Rh/pN/5kfxw/Fi13MJVDCe34jziITBcrikASnOasTX2MdOTU5XjZRy5Y7/HJ+y0QYvfY6ynJxUjYBQcCK9izMMKB8HaNcepN29wAp8BjsfJkSM94VDS6NhUeQFE2DlMrS7EEjMSUDJleFSj6QCe1s207sR74DiNALgZFqmUSbyJpjPx0W8Q3vBR0Y43iB/oR5sWSeiv+mVaz9bpdEfeOpzCyrmY6rQf3uc2o3+WGh+Cg5uw6M0i6+2VZV0BaRLpbgHiounN7ZUyiDAg/FZe6+2KpveMbEVCjznoHqCgp3lsMP3Mf5f66NOsvDvQ7Eni4+4ns2qVYjLiXXoyQNMtcdmE/osYDmQq1fBD8zKsmRhCk7
Content-Type: text/plain; charset="utf-8"
Content-ID: <153D7851AA9F7A40BC023E6052A3DC3E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0716d3a-0150-4afb-4942-08d799b42c97
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:21.9508
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ILG0zpONQ+tkYp4QMD1YiYwBnlgob4Bi5oiQPVzrWD81xWoRkpkaqWg9cjuDKvsEuzOPFPoDBvuPsRqQTRjEoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTW9z
dCBvZiB0aGUgY29tbWFuZHMgdGhhdCBhcmUgc2VudCB0byBkZXZpY2Ugc2hvdWxkIHRha2Ugc3Ry
dWN0IGluCmFyZ3VtZW50LiBJbiB0aGUgY3VycmVudCBjb2RlLCB3aGVuIHRoaXMgc3RydWN0IGlz
IGJpbmFyeSBjb21wYXRpYmxlCndpdGggYSBfX2xlMzIsIHRoZSBkcml2ZXIgdXNlIGEgX19sZTMy
LiBUaGlzIGJlaGF2aW9yIGlzIGVycm9yIHByb25lLgpUaGlzIHBhdGNoIGZpeGVzIHRoYXQgYW5k
IHVzZXMgdGhlIHNwZWNpYWxpemVkIHN0cnVjdHMgaW5zdGVhZC4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl90eC5jICAgICB8ICA0ICsrLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5oIHwgMjcgKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tCiAyIGZpbGVzIGNo
YW5nZWQsIDIwIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5j
CmluZGV4IGJlMzEzODU5MGE0Zi4uMmQ1NDE2MDFlMjI0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4LmMKQEAg
LTQzMiwxNCArNDMyLDE0IEBAIGludCBoaWZfc3RhcnQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGNv
bnN0IHN0cnVjdCBpZWVlODAyMTFfYnNzX2NvbmYgKmNvbmYsCiAJcmV0dXJuIHJldDsKIH0KIAot
aW50IGhpZl9iZWFjb25fdHJhbnNtaXQoc3RydWN0IHdmeF92aWYgKnd2aWYsIGJvb2wgZW5hYmxl
X2JlYWNvbmluZykKK2ludCBoaWZfYmVhY29uX3RyYW5zbWl0KHN0cnVjdCB3ZnhfdmlmICp3dmlm
LCBib29sIGVuYWJsZSkKIHsKIAlpbnQgcmV0OwogCXN0cnVjdCBoaWZfbXNnICpoaWY7CiAJc3Ry
dWN0IGhpZl9yZXFfYmVhY29uX3RyYW5zbWl0ICpib2R5ID0gd2Z4X2FsbG9jX2hpZihzaXplb2Yo
KmJvZHkpLAogCQkJCQkJCSAgICAgJmhpZik7CiAKLQlib2R5LT5lbmFibGVfYmVhY29uaW5nID0g
ZW5hYmxlX2JlYWNvbmluZyA/IDEgOiAwOworCWJvZHktPmVuYWJsZV9iZWFjb25pbmcgPSBlbmFi
bGUgPyAxIDogMDsKIAl3ZnhfZmlsbF9oZWFkZXIoaGlmLCB3dmlmLT5pZCwgSElGX1JFUV9JRF9C
RUFDT05fVFJBTlNNSVQsCiAJCQlzaXplb2YoKmJvZHkpKTsKIAlyZXQgPSB3ZnhfY21kX3NlbmQo
d3ZpZi0+d2RldiwgaGlmLCBOVUxMLCAwLCBmYWxzZSk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5o
CmluZGV4IGEzMjVjODcwYjRlYS4uNWIzOTIwMGJkNjk3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9t
aWIuaApAQCAtMjc4LDEwICsyNzgsMTEgQEAgc3RhdGljIGlubGluZSBpbnQgaGlmX3NldF9hcnBf
aXB2NF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBpZHgsCiAJCQkgICAgICZhcmcs
IHNpemVvZihhcmcpKTsKIH0KIAotc3RhdGljIGlubGluZSBpbnQgaGlmX3VzZV9tdWx0aV90eF9j
b25mKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAotCQkJCQlib29sIGVuYWJsZWQpCitzdGF0aWMgaW5s
aW5lIGludCBoaWZfdXNlX211bHRpX3R4X2NvbmYoc3RydWN0IHdmeF9kZXYgKndkZXYsIGJvb2wg
ZW5hYmxlKQogewotCV9fbGUzMiBhcmcgPSBlbmFibGVkID8gY3B1X3RvX2xlMzIoMSkgOiAwOwor
CXN0cnVjdCBoaWZfbWliX2dsX3NldF9tdWx0aV9tc2cgYXJnID0geworCQkuZW5hYmxlX211bHRp
X3R4X2NvbmYgPSBlbmFibGUsCisJfTsKIAogCXJldHVybiBoaWZfd3JpdGVfbWliKHdkZXYsIC0x
LCBISUZfTUlCX0lEX0dMX1NFVF9NVUxUSV9NU0csCiAJCQkgICAgICZhcmcsIHNpemVvZihhcmcp
KTsKQEAgLTMwNiw3ICszMDcsOSBAQCBzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X3VhcHNkX2lu
Zm8oc3RydWN0IHdmeF92aWYgKnd2aWYsIHVuc2lnbmVkIGxvbmcgdmFsKQogCiBzdGF0aWMgaW5s
aW5lIGludCBoaWZfZXJwX3VzZV9wcm90ZWN0aW9uKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29s
IGVuYWJsZSkKIHsKLQlfX2xlMzIgYXJnID0gZW5hYmxlID8gY3B1X3RvX2xlMzIoMSkgOiAwOwor
CXN0cnVjdCBoaWZfbWliX25vbl9lcnBfcHJvdGVjdGlvbiBhcmcgPSB7CisJCS51c2VfY3RzX3Rv
X3NlbGYgPSBlbmFibGUsCisJfTsKIAogCXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYs
IHd2aWYtPmlkLAogCQkJICAgICBISUZfTUlCX0lEX05PTl9FUlBfUFJPVEVDVElPTiwgJmFyZywg
c2l6ZW9mKGFyZykpOwpAQCAtMzE0LDE2ICszMTcsMTggQEAgc3RhdGljIGlubGluZSBpbnQgaGlm
X2VycF91c2VfcHJvdGVjdGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFibGUpCiAK
IHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zbG90X3RpbWUoc3RydWN0IHdmeF92aWYgKnd2aWYsIGlu
dCB2YWwpCiB7Ci0JX19sZTMyIGFyZyA9IGNwdV90b19sZTMyKHZhbCk7CisJc3RydWN0IGhpZl9t
aWJfc2xvdF90aW1lIGFyZyA9IHsKKwkJLnNsb3RfdGltZSA9IGNwdV90b19sZTMyKHZhbCksCisJ
fTsKIAogCXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYsIHd2aWYtPmlkLCBISUZfTUlC
X0lEX1NMT1RfVElNRSwKIAkJCSAgICAgJmFyZywgc2l6ZW9mKGFyZykpOwogfQogCi1zdGF0aWMg
aW5saW5lIGludCBoaWZfZHVhbF9jdHNfcHJvdGVjdGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwg
Ym9vbCB2YWwpCitzdGF0aWMgaW5saW5lIGludCBoaWZfZHVhbF9jdHNfcHJvdGVjdGlvbihzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFibGUpCiB7CiAJc3RydWN0IGhpZl9taWJfc2V0X2h0
X3Byb3RlY3Rpb24gYXJnID0gewotCQkuZHVhbF9jdHNfcHJvdCA9IHZhbCwKKwkJLmR1YWxfY3Rz
X3Byb3QgPSBlbmFibGUsCiAJfTsKIAogCXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYs
IHd2aWYtPmlkLCBISUZfTUlCX0lEX1NFVF9IVF9QUk9URUNUSU9OLApAQCAtMzMyLDcgKzMzNyw5
IEBAIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9kdWFsX2N0c19wcm90ZWN0aW9uKHN0cnVjdCB3Znhf
dmlmICp3dmlmLCBib29sIHZhbCkKIAogc3RhdGljIGlubGluZSBpbnQgaGlmX3dlcF9kZWZhdWx0
X2tleV9pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IHZhbCkKIHsKLQlfX2xlMzIgYXJnID0g
Y3B1X3RvX2xlMzIodmFsKTsKKwlzdHJ1Y3QgaGlmX21pYl93ZXBfZGVmYXVsdF9rZXlfaWQgYXJn
ID0geworCQkud2VwX2RlZmF1bHRfa2V5X2lkID0gdmFsLAorCX07CiAKIAlyZXR1cm4gaGlmX3dy
aXRlX21pYih3dmlmLT53ZGV2LCB3dmlmLT5pZCwKIAkJCSAgICAgSElGX01JQl9JRF9ET1QxMV9X
RVBfREVGQVVMVF9LRVlfSUQsCkBAIC0zNDEsNyArMzQ4LDkgQEAgc3RhdGljIGlubGluZSBpbnQg
aGlmX3dlcF9kZWZhdWx0X2tleV9pZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgaW50IHZhbCkKIAog
c3RhdGljIGlubGluZSBpbnQgaGlmX3J0c190aHJlc2hvbGQoc3RydWN0IHdmeF92aWYgKnd2aWYs
IGludCB2YWwpCiB7Ci0JX19sZTMyIGFyZyA9IGNwdV90b19sZTMyKHZhbCA+IDAgPyB2YWwgOiAw
eEZGRkYpOworCXN0cnVjdCBoaWZfbWliX2RvdDExX3J0c190aHJlc2hvbGQgYXJnID0geworCQku
dGhyZXNob2xkID0gY3B1X3RvX2xlMzIodmFsID4gMCA/IHZhbCA6IDB4RkZGRiksCisJfTsKIAog
CXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYsIHd2aWYtPmlkLAogCQkJICAgICBISUZf
TUlCX0lEX0RPVDExX1JUU19USFJFU0hPTEQsICZhcmcsIHNpemVvZihhcmcpKTsKLS0gCjIuMjUu
MAoK
