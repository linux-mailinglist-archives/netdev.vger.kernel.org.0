Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA7B713C458
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgAON6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:58:25 -0500
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:2785
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729952AbgAONze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nh2uOXznNGd0ZYzC/XTIbJV1aZcCoVEI0tcFYZ64GP6BvCh3QpHNfOa6OuPGWc0CFzD+04ZFlObb+LjztBl3kvSo4BOdyXaYO1bo0t/7vhItHe4mfM4qRsXK+HpIKuH2rZPRvJPb7Mjh78lxPL9kc8G0Aj6aErLYCWSXGBiue+PfCgTqx8sLvmPH7OSgSFxMF6HsFPktc9eb/t3htw/F7vRS2VstvbTgDRtGEdPuEGV5Z0HUwLCh+uLRB99f2SytI6+qnMLg+4HgrhsXzxXfhFyYTTNqzU61lX99twErkYs4W/+9Q9AVLJ1eYS3FBv4u5heMNV0ri+/iM5E0JPbINQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRUV34dVR5FpqMHul/yJ0EDmgmWG5LdkxOQALJF4n3w=;
 b=AvU+cyR5GhBBaAE0Eak2PzkPeF1yVyd3APaby7TEVrAyWhqluPlS3VI4PkuZp0L2I3nXTBrLd2kGmayroKgjvpHfyB1JR0C37T1rFl43hAkJUoJ73yf8WmOgoUK5Om5PmRcGJZsbia+WMunlx8uNVqV+Ym7j/AVXHqHh9aR/zHrG5jMa8ZUW07LaVfxqUKCg78A+419gZbjBDsAtvnEsR5wTnODJdmt4+2FL3nW3JoNYRDXj+YSxK3Ov8Bb8PZQORXREAFlVvyRddO8K6xUoI7Z5SacWi8o2kMC0XDLgKncZMwhs+FbIXnVXdeyYFfJgUQ6l1PGMJaJH27hOqo+6yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VRUV34dVR5FpqMHul/yJ0EDmgmWG5LdkxOQALJF4n3w=;
 b=SC+yJTfyKHn75DPuQXqVEAhtHM2eqW4oIeMNtLhVHHkyI51JCObSbglikdyoEaF+4uRNRjrAdOvun1/x8Zx5zs0dRQxwoWqRUMiRYlAuaY89oVSMxC6GmPCEU8sjYgworeqhLb1uqz559OIxZhuU26J3CwDHjn1/hKd8UKG3/SE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:22 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:22 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:55:02 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 42/65] staging: wfx: do not update uapsd if not necessary
Thread-Topic: [PATCH v2 42/65] staging: wfx: do not update uapsd if not
 necessary
Thread-Index: AQHVy6tiRx282zhTbE+fHkJ8ipKZXg==
Date:   Wed, 15 Jan 2020 13:55:03 +0000
Message-ID: <20200115135338.14374-43-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: b88758ac-d1ba-4915-3ceb-08d799c2855a
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094B22EA97CF9BB29EC759593370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(15650500001)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WM7rAlmJBqcVESP5bLGV2P0GMpxI90QNmzjx0nY18KT3J5Lxpb+kcXqnPoZ3UoNL6qjKlyvgGMW8K0Wm1JrpWc+V1OeKYV70wtdDz8KiBcllCm6QVp6aWg9YeNZ8PxUZYx/ndsqL7MEuhbaHnHH0V7T2NhVpe+20nAdPRIDzTl4qV/LK+kT5yDwiWmkUCSGQsJ3fLKuexWWkMx0mFtORaXfL+8f9GANJRkAvV2sRFoycKMlz3dMbM+KEFRgwT3xcKV7Q04qn1t4XPraR+Efzq9Ed1BESfBYT9aQomA00N7knIDs+xEg8BCmP+hnHzy3gC9j35wgKy40uGqQTQCEM9wBfKQmHpccoJAzEDDeVBVw3mAhg9Tn14EUmN9fmIbxmxyx48uVtM5MYKQh/awNvcSxWZIUAXEnseO0pmoejE+rrriobDggoCptLJ4YiUYBE
Content-Type: text/plain; charset="utf-8"
Content-ID: <E29BFC9771EDC8488F99A9C37569B683@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b88758ac-d1ba-4915-3ceb-08d799c2855a
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:55:03.8012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U3rvV8DtFbeweZFNZqS9xb9pHTFCthM4ylWh3tkJl+yZPbW0VANieOWMlhzEi4YjBpqX/zYdE5e16cu0yjlbiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2NvbmZfdHgoKSBpcyBjYWxsZWQgZm9yIGVhY2ggcXVldWUuIE9uIGV2ZXJ5IGNhbGwsIHRoZSBm
dW5jdGlvbgp1cGRhdGVzIFVBUFNEIG1hc2sgYW5kIFBNIG1vZGUgZm9yIGFsbCBxdWV1ZXMuIEl0
IGlzIGEgcGl0eSBzaW5jZSB0aGUKVUFQU0QgY29uZmlndXJhdGlvbiB2ZXJ5IHJhcmVseSBjaGFu
Z2VzIGFuZCBpdCBtYWtlcyBleGNoYW5nZXMgYmV0d2Vlbgp0aGUgaG9zdCBhbmQgdGhlIGNoaXAg
bW9yZSBkaWZmaWN1bHQgdG8gdHJhY2suCgpUaGlzIHBhdGNoIGF2b2lkIHRvIHVwZGF0ZSBVQVBT
RCBhbmQgUG93ZXIgTW9kZSBpbiBtb3N0IHVzdWFsIGNhc2VzLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMgfCA0ICsrKy0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBiZjI4NTM4OWMzMDMuLjZhNDNkZWNk
NWFlNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC0yODYsNiArMjg2LDcgQEAgaW50IHdmeF9jb25mX3R4KHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogewogCXN0
cnVjdCB3ZnhfZGV2ICp3ZGV2ID0gaHctPnByaXY7CiAJc3RydWN0IHdmeF92aWYgKnd2aWYgPSAo
c3RydWN0IHdmeF92aWYgKikgdmlmLT5kcnZfcHJpdjsKKwlpbnQgb2xkX3VhcHNkID0gd3ZpZi0+
dWFwc2RfbWFzazsKIAlpbnQgcmV0ID0gMDsKIAogCVdBUk5fT04ocXVldWUgPj0gaHctPnF1ZXVl
cyk7CkBAIC0yOTQsNyArMjk1LDggQEAgaW50IHdmeF9jb25mX3R4KHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAogCWFzc2lnbl9iaXQocXVldWUsICZ3
dmlmLT51YXBzZF9tYXNrLCBwYXJhbXMtPnVhcHNkKTsKIAltZW1jcHkoJnd2aWYtPmVkY2FfcGFy
YW1zW3F1ZXVlXSwgcGFyYW1zLCBzaXplb2YoKnBhcmFtcykpOwogCWhpZl9zZXRfZWRjYV9xdWV1
ZV9wYXJhbXMod3ZpZiwgcXVldWUsIHBhcmFtcyk7Ci0JaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBO
TDgwMjExX0lGVFlQRV9TVEFUSU9OKSB7CisJaWYgKHd2aWYtPnZpZi0+dHlwZSA9PSBOTDgwMjEx
X0lGVFlQRV9TVEFUSU9OICYmCisJICAgIG9sZF91YXBzZCAhPSB3dmlmLT51YXBzZF9tYXNrKSB7
CiAJCWhpZl9zZXRfdWFwc2RfaW5mbyh3dmlmLCB3dmlmLT51YXBzZF9tYXNrKTsKIAkJd2Z4X3Vw
ZGF0ZV9wbSh3dmlmKTsKIAl9Ci0tIAoyLjI1LjAKCg==
