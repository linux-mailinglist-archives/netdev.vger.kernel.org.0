Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB513C3A2
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAONyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:15 -0500
Received: from mail-bn7nam10on2086.outbound.protection.outlook.com ([40.107.92.86]:18912
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726132AbgAONyN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CbelD5pUiphsZZyaGAFhNJtNVDAm4o/Luz1cGZNPuNBN58wxzdz6zyJYYJQ2XJ8+vYMIjyc6ODD8zizyIMaLe77bCARfygZuRHPKlt08gbrPCaK8P0YhHUuuKEByFxKUL53m0CiM0K0SuK73/UJUHcJV+jmkHsleoXAyrD9QcUT8QqRKoVkPUBxYNuONbsaJuIfyipAfdJxbt/vtmQrxjcucvvfIRVS3f37VBDPPcmWRwjpvssiEFJ5Jh0mN5kQWWmUUMKAbq0TtIuUJLTY8dya35m8d91GWMgIVCtlnjB8Br6H2qanfOSwGGn6J53rd5hFBfkqZvdYygVJib4QVZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUo8LwBo1qK4cZ/ojBZuyySQUx8sEw77KK5ENOyqfFo=;
 b=HCBKOMPxJgYBQOISmX6bSCNGFVyCRM//jgRIlEt98nNIZG6RQ1lBXJy+UOLF/o+XZeIxWpfOs5DWyqoegnV4LMV9XI7vbBSIClTp9r+5uPZVGpoxBmZf4ao0DYR57Cm6PljjMOxrojFbX1xUSnmt+JNfCVIvtsBnBmXV4eOWMmh9vkuXbNhqLjxBBPq4/fYppT8MwhqDs6ZC9K6f5cAKvDzmgBxTtfNDwSkce0F8QU1XPl9SMvpU1Jp0fdwzWBSx91z7vyDADemSO8jWbYL3vRNX/Vb+abRMNmVkWyo3VElfRsnVOC2XH0LNfnWLgWQnGrjsFkakJZFZoI+LvOH8Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUo8LwBo1qK4cZ/ojBZuyySQUx8sEw77KK5ENOyqfFo=;
 b=BEKnFwWJQPrMpZ7hiR2LeQCMFnwX8P/AB9dyLNbbBsvqLOhwp/3Le2VOeJEBsjgnQk+NM+L7dxzMklVQPaMjxSoCR5jzaG4IeEOyFenmbxlKf8HMKPg5dQiVmTZLiCuJn6NkgsNYjmQQLFHlTnWJCV3/c18JhFUdBqQVDhnGdzw=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:10 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:10 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:09 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 06/65] staging: wfx: simplify hif_set_output_power() usage
Thread-Topic: [PATCH v2 06/65] staging: wfx: simplify hif_set_output_power()
 usage
Thread-Index: AQHVy6tDn0wcOEiD3EqwTSZft4VqOw==
Date:   Wed, 15 Jan 2020 13:54:10 +0000
Message-ID: <20200115135338.14374-7-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 699dc407-fb96-4338-c86e-08d799c265b8
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36611E0D5C1DB33BE0CD9AE293370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(6666004)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bV9/az/qwmag8KOydqEccbH0lqiobg0+Lzls7S2n4kWbA4g2ZuEuXIL8a+1kz6FNshzry9GeUf8MLL4whj3zDCGtuGa1d7wIrND5aAbmM4fOOLyG1kjZ75blL8HNQ5VMXg5XLnB5wxTAZwGpprndx4r7ooX6T1kCAHh59y2YZu5Y1N+YrUJ2X85yu9oEO9RkES89/SMkfTze3MSYTHM0WoDU0eagBw9BQxw73gzLA8/7rHzDAbNDd23+LwMYjEDN9PdCbj+qyOaQOo9qpvD2JKtRVKVfORf6CdoUvrphmIndpeXbt9uV2O3j2zhZVxejOnoIocwCNPxGgtMn6s6NUKdv63W1rQAJkn7E2BqlipCQ/VuT5dBJYKmpqgSywLF8T2eYza8bp0yTEphB+CEtQ40LIf2dHtb7MyLYMTp6GpCyn76vBOuZU0uUZCETrhXg
Content-Type: text/plain; charset="utf-8"
Content-ID: <92D6F7CF6F831D4EB0E35503B86C08E3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 699dc407-fb96-4338-c86e-08d799c265b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:10.7457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yn6YLVcGqffhc582qevWhFNzRlSSBMkneUBajPp4eoYyIYo7gNpUJToGCjgBdZ2mydGUBD3bmnQJ8xTsiYKPEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGFy
ZHdhcmUgQVBJIHVzZSAxMHRoIG9mIGRCbSBmb3Igb3V0cHV0IHBvd2VyIHVuaXQuIFVwcGVyIGxh
eWVycyBzaG91bGQKdXNlIHNhbWUgdW5pdHMgdGhhbiBtYWM4MDIxMSBhbmQgdGhlIGNvbnZlcnNp
b24gc2hvdWxkIGJlIGRvbmUgYnkgbG93CmxldmVsIGxheWVyIG9mIHRoZSBkcml2ZXIgKGhpZl9z
ZXRfb3V0cHV0X3Bvd2VyKCkpCgpJbiBhZGQsIGN1cnJlbnQgY29kZSBvZiBoaWZfc2V0X291dHB1
dF9wb3dlcigpIHVzZSBhIF9fbGUzMiB3aGlsZSB0aGUKZGV2aWNlIEFQSSBzcGVjaWZ5IGEgc3Bl
Y2lmaWMgc3RydWN0dXJlIGZvciB0aGlzLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX3R4X21pYi5oIHwgOCArKysrKy0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgICAg
ICAgfCAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8IDYgKysrLS0tCiAz
IGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvaGlmX3R4X21pYi5oCmluZGV4IGVmMDMzYTQwOTM4MS4uNzQ5ZGY2NzEzMWMzIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuaAorKysgYi9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2hpZl90eF9taWIuaApAQCAtMTUsMTMgKzE1LDE1IEBACiAjaW5jbHVkZSAiaGlmX3R4
LmgiCiAjaW5jbHVkZSAiaGlmX2FwaV9taWIuaCIKIAotc3RhdGljIGlubGluZSBpbnQgaGlmX3Nl
dF9vdXRwdXRfcG93ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBwb3dlcl9sZXZlbCkKK3N0
YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfb3V0cHV0X3Bvd2VyKHN0cnVjdCB3ZnhfdmlmICp3dmlm
LCBpbnQgdmFsKQogewotCV9fbGUzMiB2YWwgPSBjcHVfdG9fbGUzMihwb3dlcl9sZXZlbCk7CisJ
c3RydWN0IGhpZl9taWJfY3VycmVudF90eF9wb3dlcl9sZXZlbCBhcmcgPSB7CisJCS5wb3dlcl9s
ZXZlbCA9IGNwdV90b19sZTMyKHZhbCAqIDEwKSwKKwl9OwogCiAJcmV0dXJuIGhpZl93cml0ZV9t
aWIod3ZpZi0+d2Rldiwgd3ZpZi0+aWQsCiAJCQkgICAgIEhJRl9NSUJfSURfQ1VSUkVOVF9UWF9Q
T1dFUl9MRVZFTCwKLQkJCSAgICAgJnZhbCwgc2l6ZW9mKHZhbCkpOworCQkJICAgICAmYXJnLCBz
aXplb2YoYXJnKSk7CiB9CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfYmVhY29uX3dha2V1
cF9wZXJpb2Qoc3RydWN0IHdmeF92aWYgKnd2aWYsCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3NjYW4uYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc2Nhbi5jCmluZGV4IDliMzY3NGIz
MjI2YS4uOGUwYWM4OWZkMjhmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4u
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3NjYW4uYwpAQCAtNjEsNyArNjEsNyBAQCBzdGF0
aWMgaW50IHNlbmRfc2Nhbl9yZXEoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCXJldHVybiB0aW1l
b3V0OwogCXJldCA9IHdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91dCgmd3ZpZi0+c2Nhbl9jb21w
bGV0ZSwgdGltZW91dCk7CiAJaWYgKHJlcS0+Y2hhbm5lbHNbc3RhcnRfaWR4XS0+bWF4X3Bvd2Vy
ICE9IHd2aWYtPndkZXYtPm91dHB1dF9wb3dlcikKLQkJaGlmX3NldF9vdXRwdXRfcG93ZXIod3Zp
Ziwgd3ZpZi0+d2Rldi0+b3V0cHV0X3Bvd2VyICogMTApOworCQloaWZfc2V0X291dHB1dF9wb3dl
cih3dmlmLCB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIpOwogCXdmeF90eF91bmxvY2sod3ZpZi0+
d2Rldik7CiAJaWYgKCFyZXQpIHsKIAkJZGV2X25vdGljZSh3dmlmLT53ZGV2LT5kZXYsICJzY2Fu
IHRpbWVvdXRcbiIpOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggOGY1M2E3OGQ3MjE1Li4xMWUzM2E2ZDViYjUg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwpAQCAtNTAzLDcgKzUwMyw3IEBAIHN0YXRpYyB2b2lkIHdmeF9kb191bmpv
aW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJaGlmX2tlZXBfYWxpdmVfcGVyaW9kKHd2aWYsIDAp
OwogCWhpZl9yZXNldCh3dmlmLCBmYWxzZSk7CiAJd2Z4X3R4X3BvbGljeV9pbml0KHd2aWYpOwot
CWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHd2aWYtPndkZXYtPm91dHB1dF9wb3dlciAqIDEw
KTsKKwloaWZfc2V0X291dHB1dF9wb3dlcih3dmlmLCB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIp
OwogCXd2aWYtPmR0aW1fcGVyaW9kID0gMDsKIAloaWZfc2V0X21hY2FkZHIod3ZpZiwgd3ZpZi0+
dmlmLT5hZGRyKTsKIAl3ZnhfZnJlZV9ldmVudF9xdWV1ZSh3dmlmKTsKQEAgLTEwNjMsNyArMTA2
Myw3IEBAIHZvaWQgd2Z4X2Jzc19pbmZvX2NoYW5nZWQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcs
CiAJaWYgKGNoYW5nZWQgJiBCU1NfQ0hBTkdFRF9UWFBPV0VSICYmCiAJICAgIGluZm8tPnR4cG93
ZXIgIT0gd2Rldi0+b3V0cHV0X3Bvd2VyKSB7CiAJCXdkZXYtPm91dHB1dF9wb3dlciA9IGluZm8t
PnR4cG93ZXI7Ci0JCWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHdkZXYtPm91dHB1dF9wb3dl
ciAqIDEwKTsKKwkJaGlmX3NldF9vdXRwdXRfcG93ZXIod3ZpZiwgd2Rldi0+b3V0cHV0X3Bvd2Vy
KTsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKIApAQCAtMTMxNyw3ICsx
MzE3LDcgQEAgaW50IHdmeF9jb25maWcoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBjaGFu
Z2VkKQogCW11dGV4X2xvY2soJndkZXYtPmNvbmZfbXV0ZXgpOwogCWlmIChjaGFuZ2VkICYgSUVF
RTgwMjExX0NPTkZfQ0hBTkdFX1BPV0VSKSB7CiAJCXdkZXYtPm91dHB1dF9wb3dlciA9IGNvbmYt
PnBvd2VyX2xldmVsOwotCQloaWZfc2V0X291dHB1dF9wb3dlcih3dmlmLCB3ZGV2LT5vdXRwdXRf
cG93ZXIgKiAxMCk7CisJCWhpZl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHdkZXYtPm91dHB1dF9w
b3dlcik7CiAJfQogCiAJaWYgKGNoYW5nZWQgJiBJRUVFODAyMTFfQ09ORl9DSEFOR0VfUFMpIHsK
LS0gCjIuMjUuMAoK
