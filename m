Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7B6123171
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728895AbfLQQPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:25 -0500
Received: from mail-bn8nam11on2073.outbound.protection.outlook.com ([40.107.236.73]:39265
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728835AbfLQQPO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cK4YN/4jKG7kIRvcqI3ya5lWdWMYjs1bL7cuQ0FSgp9bYYSQhAYd3puufA6sBOcEUAmzJBh7jn0w81h/tvRSqO3A6MoL17fJJt+C04+xmbeoVy3vW9ICl7yATPsTgqqVJXHpdpJOEX2463dvUf2kHtUR9Ce4nIi5Z/Hq88gVMKFi7GTBSjScEYUfR/v6Di83y5r8uYfSQdUb8NJJGSWp31yOagb/G9vMa51+D572FH16Rmh40ET2mAbe3T+2UhNj4oVVd8v9/5x8bii42G/aadJSwyksh4mG5IberjV9dEJA3Z6xjjSa5S7SA4SviZooYp6Irl9v6MTHK/zsUAL9DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgRsYGpOQruqWvGnWEUUxdiA+S21vlMKBbozCs8hMqg=;
 b=G8mFtlxwMbrBP/Q4wfsykDn3ZyvKMhGaJz/NUk7HgyR+Kwajg1Xf/fmb7knT/U759Bm3F7eaaaqm1eNevpgwiYAvJj2dEFTUUAAF4OIYCdE63Ms1F/XhaSWw0lUoPxQIJlExj2DBnsc3nQ1YaNCKsnzDCCNIA6DPpUsq0tLqv0HG3z7Zufm0IjkEZ/kol4p04MAEJp5ou2Jox/fU/MFzC6SrlCjXsRnpf4i95nFzT/AD4xR79Qt0q8QRNkwdMOQvn92oZXBCcka4HrOUVigP4JVZiw3O15aer+Kcdz4uJTHzRzAYa30GE0AclxD1F8UCui2tXCrlGq6WoYrkiHXjxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgRsYGpOQruqWvGnWEUUxdiA+S21vlMKBbozCs8hMqg=;
 b=dpYCguyo8BYZ33c+kx6JF9UAktyoLsahOJbkAErJtBML90bvVrY0Kh0Pk8qfl/i7Ai4Yi9CP/94D4VavY6TQtTbgoVVMAkFNIq8vGWNpBk6qELfZbe+io/tTyJcv828iTg+VHQnDaNWpQVewzkOuSjYl6XvQ9i7RgfDu4D2ugIg=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:08 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:08 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 29/55] staging: wfx: simplify handling of tx_lock in
 wfx_do_join()
Thread-Topic: [PATCH v2 29/55] staging: wfx: simplify handling of tx_lock in
 wfx_do_join()
Thread-Index: AQHVtPUmosfEjogheUqodIyJPKuxrQ==
Date:   Tue, 17 Dec 2019 16:15:08 +0000
Message-ID: <20191217161318.31402-30-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 552362d5-4cfe-4523-d31b-08d7830c48fc
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208239D2C6D66548941A8EC93500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hM9zcGfLv8VHYpaq22iU8lkrl1JqjQdPZlT/akPQ5PNozlt3GYfTZFDVChHwmfQ1SdQjATT4P5oSkOpRmYMkYdPp7HRiafe6XLUfoie/oshnHtk7b+2m2GjDejL/TgLFyUjuphgpXbcdUTpQIf891F9JpqWmEKHpToWmXTFlWFqV4TRvYAsryCaItexR/QLBC9DuXrJnpGXVnjXL4koQHo2thxNgSC9KJttK6NjtEC68G0u5Qt4+3aUGsWi3lWy8CQ3Bc652KKWwMPG2Jq+ZUQ5OU2VoZ1cFHo9cxZWgY5ejGBKrUyigqKXnrKVHXTwS3VI2ujnC3OUg/5zJCg+jshvfwOZ5hpMiFxfELMtfPr58nOKejB1RpoJCzn2EVa2yx2rH5d4qkpoaNLAeMjt2JtEuei8L8QzuBKZGOot7jqkWalEddwW6p/ltwwbUwWBq
Content-Type: text/plain; charset="utf-8"
Content-ID: <CF1B9EB2D382FC4C938B0C532FB8936C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552362d5-4cfe-4523-d31b-08d7830c48fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:08.5248
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SWdH+viZBM7hEXQ27QX9NEueQYZRD6MxxeLaiaMLyDRIyiz6lguVxCmDQ4dPcwx9CU484vmHHvDDvoBBVf4+1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
dGhlIG9sZCBkYXlzLCB3ZnhfZG9fam9pbigpIGNvdWxkIGJlIGNhbGxlZCBmcm9tIGRpZmZlcmVu
dCBjb250ZXh0cy4KTm93IHRoYXQgd2Z4X2RvX2pvaW4oKSBpcyBjYWxsZWQgb25seSBmcm9tIG9u
ZSBwbGFjZSwgaXQgaXMgY2xlYW5lciB0bwprZWVwIGxvY2sgYW5kIHVubG9jayBvZiBkYXRhIGlu
c2lkZSB0aGUgZnVuY3Rpb24uCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVy
b21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyB8
IDkgKysrKy0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA1IGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDkzOWM2NGYxMDhlZC4uNjJlNjU0OTNhNGZlIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKQEAgLTY0NCw3ICs2NDQsNiBAQCBzdGF0aWMgdm9pZCB3Znhfc2V0X21mcChzdHJ1Y3Qg
d2Z4X3ZpZiAqd3ZpZiwKIAloaWZfc2V0X21mcCh3dmlmLCBtZnBjLCBtZnByKTsKIH0KIAotLyog
TVVTVCBiZSBjYWxsZWQgd2l0aCB0eF9sb2NrIGhlbGQhICBJdCB3aWxsIGJlIHVubG9ja2VkIGZv
ciB1cy4gKi8KIHN0YXRpYyB2b2lkIHdmeF9kb19qb2luKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQog
ewogCWNvbnN0IHU4ICpic3NpZDsKQEAgLTY1OSw2ICs2NTgsOCBAQCBzdGF0aWMgdm9pZCB3Znhf
ZG9fam9pbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAkJCQkJCSAgICAgIGNvbmYtPmJhc2ljX3Jh
dGVzKSwKIAl9OwogCisJd2Z4X3R4X2xvY2tfZmx1c2god3ZpZi0+d2Rldik7CisKIAlpZiAod3Zp
Zi0+Y2hhbm5lbC0+ZmxhZ3MgJiBJRUVFODAyMTFfQ0hBTl9OT19JUikKIAkJam9pbi5wcm9iZV9m
b3Jfam9pbiA9IDA7CiAKQEAgLTExODAsMTAgKzExODEsOCBAQCB2b2lkIHdmeF9ic3NfaW5mb19j
aGFuZ2VkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCX0KIAltdXRleF91bmxvY2soJndkZXYt
PmNvbmZfbXV0ZXgpOwogCi0JaWYgKGRvX2pvaW4pIHsKLQkJd2Z4X3R4X2xvY2tfZmx1c2god2Rl
dik7Ci0JCXdmeF9kb19qb2luKHd2aWYpOyAvKiBXaWxsIHVubG9jayBpdCBmb3IgdXMgKi8KLQl9
CisJaWYgKGRvX2pvaW4pCisJCXdmeF9kb19qb2luKHd2aWYpOwogfQogCiBzdGF0aWMgdm9pZCB3
ZnhfcHNfbm90aWZ5KHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBlbnVtIHN0YV9ub3RpZnlfY21kIG5v
dGlmeV9jbWQsCi0tIAoyLjI0LjAKCg==
