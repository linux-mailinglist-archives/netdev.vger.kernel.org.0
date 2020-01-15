Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C53313C49B
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgAONym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:42 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729378AbgAONym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJaanCjTatpOTrUaOSDqisAZX2i+FuiGfMbhglPSAVH00ahXUOh0cq4Q2eLv/hkQEh9kh8d8eWYyP4PzPQgcv3bGT2N+afWFx/XQ+ci2XwkjHI9aviQipPED/2HEpwP0BeARt9CV4k3YkQ2Bfhh0/VabR5gKyc2jIQcLIykx8Qa51RauTS8Lm3E6FDQKggDILG9lj7VJNsPPmJP1S+lphCMjqCuWtXxShNJ7fdlPrx+jfN1zqba+w2tUrbtKiGtAu8MvNCrea3SPsIo1koLI+AzfoqO9dV3RNZaVad5DCO8G8XblSthA9q3o/DgUE/daWFdyIvziobquUI+n6Ecv0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzVf8PCsjhv48CVwVz+IbX+oGTKM2/8Ap4mn8+5bTGE=;
 b=BfVJFgf67nDRo2+z1cG0jjy3csHZ8S/Vrmry94eqhYk179uLEgRx3E1SK9PNc2NdIiw0xelAWIHDw98J9046QM4n2NaxoMYNqiGdi0pnKZ96GyPGhoxg79puf6E8BmYho5YdCF4BMNYCLHPFIopYHHXudAOQXTOf70rymMncj0315ZOjrQkQEM6Mh2WQjvpBEzHeX8AuV3sRyYndQZKkHrEtBRO/XJKxsKZ60K4SsrwDZOBD539T28Usz+Xm2mYkWOzKmrSNxumCglCJRBY2uVFI3QsWactnXo5vOTt14cOzm6ewhRX9ohYeAXqlp9uR6AIegm+oZv6XLpXnTz2/qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vzVf8PCsjhv48CVwVz+IbX+oGTKM2/8Ap4mn8+5bTGE=;
 b=XGDtkF9T+Kp0mI65nMRvvvpFro8hovIrVxfdSrh6asvC/TGEoJM0//gwJ5cxHpMhRf53MtSUWo4P3PqJ1GCWk6dVODZdSedaRS1ddBGwICXhensBleyc0s+rDXPWZE5Zuxv1IQkKXuGUVY3sPFu65lVd2gBnWuMeHsvqlCrebGA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:26 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:26 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:25 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 17/65] staging: wfx: simplify wfx_upload_ap_templates()
Thread-Topic: [PATCH v2 17/65] staging: wfx: simplify
 wfx_upload_ap_templates()
Thread-Index: AQHVy6tMm6Ei/ubRgkWvfX7AxA3Pvg==
Date:   Wed, 15 Jan 2020 13:54:26 +0000
Message-ID: <20200115135338.14374-18-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: dd43a2a5-47bc-407e-3228-08d799c26ef8
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40944FB9D23AA9B70BFBC90393370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Lq4Fk2fm81heqR5dIkGWvE6YbPzgHF86ivMmt62pt2l2vv2hWIPP9O31aFtPgy1T8P25upqpd88ga7EESw2gp3spPDG1FAKt+LjFWq8twlOqZbvB79XwXeUVSxyIT7tN7lwwjWig+VG6hbkx4nySym4GKjK/eqYAiE+vgt+WZVxK5/yc+VKtuzvQz203P0wZFDSJhr+DonqiCsGS+XXIVp+3kQ1tWagPYYOwgbHC8K4EknyBGELRuAvVvnzofZBh/ZcExi7SxTbPB7HjszvbVtF2oGpGq13DE2tGI2iopEmdT5mcHcwBJa+p+fTQjL9L9kYEiYylElZhIKnfjp+KdohiLdGX1/dFGl0pFJeKdUIY7U0Qk/a1FppYd6vZF2ct8NYB83TH1vkLtcCDjo/9YHInSwjKEbJlP7UVG7PYA+nITL5C4Zp03isq7CJGoLz7
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AAE882B4E271E4CA0420451E9A569DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd43a2a5-47bc-407e-3228-08d799c26ef8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:26.2628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IMgMxJPLUosRPpSAHJy1VrFi7W4CzjTpA8ydoRoTz4bWmTJntEzUTML7bcRUdzyXXsMIMsuPKpzqaVf+X2zOJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBmdW5jdGlvbiBidWlsdCBwcm9iZSByZXNwb25zZSBmcm9tIGRhdGEgcmV0cmlldmVkIGluIGJl
YWNvbi4gWWV0LAp0aGlzIGpvYiBjYW4gYmUgZG9uZSB3aXRoIGllZWU4MDIxMV9wcm9iZXJlc3Bf
Z2V0KCkuIFNvLCB3ZSBjYW4gc2ltcGxpZnkKdGhhdCBjb2RlIChhbmQgZml4IGJ1Z3MgbGlrZSBp
bmNsdXNpb24gb2YgVElNIGluIHByb2JlIHJlc3BvbnNlcykuCgpTaWduZWQtb2ZmLWJ5OiBKw6ly
w7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuYyB8IDEyICsrKystLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5z
ZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBmZGRlN2FiOTIzMDIu
LjExODEyMDM0ODlmMCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC03ODMsNyArNzgzLDYgQEAgc3RhdGljIGlu
dCB3ZnhfdXBkYXRlX2JlYWNvbmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIHN0YXRpYyBpbnQg
d2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7CiAJc3RydWN0
IHNrX2J1ZmYgKnNrYjsKLQlzdHJ1Y3QgaWVlZTgwMjExX21nbXQgKm1nbXQ7CiAKIAlpZiAod3Zp
Zi0+dmlmLT50eXBlID09IE5MODAyMTFfSUZUWVBFX1NUQVRJT04gfHwKIAkgICAgd3ZpZi0+dmlm
LT50eXBlID09IE5MODAyMTFfSUZUWVBFX01PTklUT1IgfHwKQEAgLTc5NSwxNCArNzk0LDExIEBA
IHN0YXRpYyBpbnQgd2Z4X3VwbG9hZF9hcF90ZW1wbGF0ZXMoc3RydWN0IHdmeF92aWYgKnd2aWYp
CiAJCXJldHVybiAtRU5PTUVNOwogCWhpZl9zZXRfdGVtcGxhdGVfZnJhbWUod3ZpZiwgc2tiLCBI
SUZfVE1QTFRfQkNOLAogCQkJICAgICAgIEFQSV9SQVRFX0lOREVYX0JfMU1CUFMpOworCWRldl9r
ZnJlZV9za2Ioc2tiKTsKIAotCS8qIFRPRE86IERpc3RpbGwgcHJvYmUgcmVzcDsgcmVtb3ZlIFRJ
TSBhbmQgYW55IG90aGVyIGJlYWNvbi1zcGVjaWZpYwotCSAqIElFcwotCSAqLwotCW1nbXQgPSAo
dm9pZCAqKXNrYi0+ZGF0YTsKLQltZ210LT5mcmFtZV9jb250cm9sID0KLQkJY3B1X3RvX2xlMTYo
SUVFRTgwMjExX0ZUWVBFX01HTVQgfCBJRUVFODAyMTFfU1RZUEVfUFJPQkVfUkVTUCk7Ci0KKwlz
a2IgPSBpZWVlODAyMTFfcHJvYmVyZXNwX2dldCh3dmlmLT53ZGV2LT5odywgd3ZpZi0+dmlmKTsK
KwlpZiAoIXNrYikKKwkJcmV0dXJuIC1FTk9NRU07CiAJaGlmX3NldF90ZW1wbGF0ZV9mcmFtZSh3
dmlmLCBza2IsIEhJRl9UTVBMVF9QUkJSRVMsCiAJCQkgICAgICAgQVBJX1JBVEVfSU5ERVhfQl8x
TUJQUyk7CiAJZGV2X2tmcmVlX3NrYihza2IpOwotLSAKMi4yNS4wCgo=
