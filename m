Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5384A13C4B5
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgAONyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:25 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:8538
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729163AbgAONyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FP4fI6IepO3jn1zwVjF37idcEoruE2fKs1O+lFoCaCDEspiXp13edo3RudaStG+pzVMiQCWMOMNgIWEXXX6ScNrrWWUkEMrzVOVbO2VH3gfb0MsRC6oDgYxHqKJnEJ39ZQVjOVKQDx+NrHCVcCBGnfrCN5dWEIlfrhubB05Tn/9NRqmxGWQnbGC8CPaL+9iSQLZLtsCvNPg57dPOSKmSfUT+pAhOJdDuZj3wBowo3zBtICwWO1aqz3R60+pywL5lopVbMT+Jp/TdPL2WUHz/Fg2hrvkxZCFmEyel+AggkK4jb5mlfGZaKWnzB9lwDhFvHfgg1TxaipO+aQ4iVc7QbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkgqQrIIiJU7w+2JUxpXKH/R2F2qsPbaxSas1tRjHT8=;
 b=NlQBdQk+p0jKXswUr+i/8+t5kl0T5b9AMWlmBJBFC/6QL57PnRFsK9vISKNq2dhhrdfZcPG5n10lt+N1f5ABHSoOU1OFX6MOTGAnFRBfvpH8uLTAuH+8wL4sHwI/GtgioRV3PielKrrUok63ClgQ+Uuy4jgFbySRs1IvxTEc/bei8dIZkutRH7fyHEsln111rbfJgf341ksgTjRs36jcy1dWCB+XGcho54QbVT29UwhpHJLKZoN3laNBhgKsXUBEMNXLiJwpEze5YX5aN72oQIzz0aKFzOn3ilOS20PjvdmyXDG6CmlPuR7fGOUAkKHNVh1HGLMquSIVu+J52mt49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TkgqQrIIiJU7w+2JUxpXKH/R2F2qsPbaxSas1tRjHT8=;
 b=OzdYana7CgtzK+ik/JIZ/Wc4p+1OvNX2IQfVIGR/fy5/Efhu4Zi0QU1crq/+CEtw2ibOVTK8GHzHkpbWcsWA59TDiuLuszTuFhcl0CmmfOJzGaAIi6EWsawGzfLIFWJHZ9Y+NDymVeKvSPnVqztAE4VLoyWjSgQKdDe59Xii/cI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:54:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:20 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:19 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 13/65] staging: wfx: drop struct wfx_ht_info
Thread-Topic: [PATCH v2 13/65] staging: wfx: drop struct wfx_ht_info
Thread-Index: AQHVy6tJ79W/WzZaRkeK96ItHLEj3g==
Date:   Wed, 15 Jan 2020 13:54:20 +0000
Message-ID: <20200115135338.14374-14-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2fc063dc-0788-4e5e-4cc4-08d799c26b96
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3661297E90319C9E36F9F83393370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:242;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(6666004)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9lGYzE6mgO6ulIpLpbpO1z90TltrB79KZuzk1MNe1f8lhOz+EU9xXe3WRYAZYYtAWJ3R8qMG5J9oV7mEAl5garzeFfarvIotuSMzPz5qqUG39A3JPUV/w/+0M8OSRa71rI6NSGjcQ6BxJ8fBcyAEjgzDh94lwVUV2yKLHQBgldT/mEhmFYGGtc7g8PCKkcc1Mda4AnXJCSrzerGkwnxrTYvKP5UtzCXdXZreZokaesSirQ8bYe/iPiCGdnDk+s8KA9lRW72/b54sFzJqUGQRoDk6+8LArPbBM98dVT/xvoCS232q76l2wubpcNcAYwzPshG5YXzJ+40MMGfTZ4U0yBwpwLbFqFo+Ai8V7UR7/xFLuWBMbGGAhfaGZihnnOB3orP2uEqVzkhXlJalpkuYbYeL5FUmEWY08jW7khExVXHMowp/YCRv2VgosZkopjwP
Content-Type: text/plain; charset="utf-8"
Content-ID: <4074A93F9E914341BC8F6A807A33B556@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fc063dc-0788-4e5e-4cc4-08d799c26b96
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:20.5610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oV5LDy3jpubjx7z70NjZrZJbb3BkJZwOLzvqHYBZnsz17PNicvpKYdnFBRJibwS9H+TZXVf2a7nPHDxdqPj+5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhp
cyBzdHJ1Y3QgaXMgbm8gbW9yZSB1c2VkLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxs
ZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMgfCAxOCArKystLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgg
fCAgNiAtLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCAgMSAtCiAzIGZpbGVzIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMjIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXgg
ZmNkOWZlNjZlNDE3Li5kZDJkMDQyMmM5Y2EgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNTE3LDcgKzUxNyw2
IEBAIHN0YXRpYyB2b2lkIHdmeF9kb191bmpvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJd2Z4
X3VwZGF0ZV9maWx0ZXJpbmcod3ZpZik7CiAJbWVtc2V0KCZ3dmlmLT5ic3NfcGFyYW1zLCAwLCBz
aXplb2Yod3ZpZi0+YnNzX3BhcmFtcykpOwogCXd2aWYtPnNldGJzc3BhcmFtc19kb25lID0gZmFs
c2U7Ci0JbWVtc2V0KCZ3dmlmLT5odF9pbmZvLCAwLCBzaXplb2Yod3ZpZi0+aHRfaW5mbykpOwog
CiBkb25lOgogCW11dGV4X3VubG9jaygmd3ZpZi0+d2Rldi0+Y29uZl9tdXRleCk7CkBAIC04MTIs
MTEgKzgxMSw2IEBAIHN0YXRpYyBpbnQgd2Z4X3VwbG9hZF9iZWFjb24oc3RydWN0IHdmeF92aWYg
Knd2aWYpCiAJcmV0dXJuIDA7CiB9CiAKLXN0YXRpYyBpbnQgd2Z4X2lzX2h0KGNvbnN0IHN0cnVj
dCB3ZnhfaHRfaW5mbyAqaHRfaW5mbykKLXsKLQlyZXR1cm4gaHRfaW5mby0+Y2hhbm5lbF90eXBl
ICE9IE5MODAyMTFfQ0hBTl9OT19IVDsKLX0KLQogc3RhdGljIHZvaWQgd2Z4X2pvaW5fZmluYWxp
emUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2Jzc19j
b25mICppbmZvKQogewpAQCAtODMwLDE3ICs4MjQsMTIgQEAgc3RhdGljIHZvaWQgd2Z4X2pvaW5f
ZmluYWxpemUoc3RydWN0IHdmeF92aWYgKnd2aWYsCiAJcmN1X3JlYWRfbG9jaygpOwogCWlmIChp
bmZvLT5ic3NpZCAmJiAhaW5mby0+aWJzc19qb2luZWQpCiAJCXN0YSA9IGllZWU4MDIxMV9maW5k
X3N0YSh3dmlmLT52aWYsIGluZm8tPmJzc2lkKTsKLQlpZiAoc3RhKSB7Ci0JCXd2aWYtPmh0X2lu
Zm8uaHRfY2FwID0gc3RhLT5odF9jYXA7CisJcmN1X3JlYWRfdW5sb2NrKCk7CisJaWYgKHN0YSkK
IAkJd3ZpZi0+YnNzX3BhcmFtcy5vcGVyYXRpb25hbF9yYXRlX3NldCA9CiAJCQl3ZnhfcmF0ZV9t
YXNrX3RvX2h3KHd2aWYtPndkZXYsIHN0YS0+c3VwcF9yYXRlc1t3dmlmLT5jaGFubmVsLT5iYW5k
XSk7Ci0JCXd2aWYtPmh0X2luZm8ub3BlcmF0aW9uX21vZGUgPSBpbmZvLT5odF9vcGVyYXRpb25f
bW9kZTsKLQl9IGVsc2UgewotCQltZW1zZXQoJnd2aWYtPmh0X2luZm8sIDAsIHNpemVvZih3dmlm
LT5odF9pbmZvKSk7CisJZWxzZQogCQl3dmlmLT5ic3NfcGFyYW1zLm9wZXJhdGlvbmFsX3JhdGVf
c2V0ID0gLTE7Ci0JfQotCXJjdV9yZWFkX3VubG9jaygpOwotCiAJaWYgKHN0YSAmJgogCSAgICBp
bmZvLT5odF9vcGVyYXRpb25fbW9kZSAmIElFRUU4MDIxMV9IVF9PUF9NT0RFX05PTl9HRl9TVEFf
UFJTTlQpCiAJCWhpZl9kdWFsX2N0c19wcm90ZWN0aW9uKHd2aWYsIHRydWUpOwpAQCAtMTIyNCw3
ICsxMjEzLDYgQEAgaW50IHdmeF9hc3NpZ25fdmlmX2NoYW5jdHgoc3RydWN0IGllZWU4MDIxMV9o
dyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAKIAlXQVJOKHd2aWYtPmNoYW5uZWws
ICJjaGFubmVsIG92ZXJ3cml0ZSIpOwogCXd2aWYtPmNoYW5uZWwgPSBjaDsKLQl3dmlmLT5odF9p
bmZvLmNoYW5uZWxfdHlwZSA9IGNmZzgwMjExX2dldF9jaGFuZGVmX3R5cGUoJmNvbmYtPmRlZik7
CiAKIAlyZXR1cm4gMDsKIH0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCmluZGV4IGI1ZDhkNjQ5NDE1Ny4uZTBiNTQzMzJl
OThhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCisrKyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmgKQEAgLTIzLDEyICsyMyw2IEBAIGVudW0gd2Z4X3N0YXRlIHsKIAlX
RlhfU1RBVEVfQVAsCiB9OwogCi1zdHJ1Y3Qgd2Z4X2h0X2luZm8gewotCXN0cnVjdCBpZWVlODAy
MTFfc3RhX2h0X2NhcCBodF9jYXA7Ci0JZW51bSBubDgwMjExX2NoYW5uZWxfdHlwZSBjaGFubmVs
X3R5cGU7Ci0JdTE2IG9wZXJhdGlvbl9tb2RlOwotfTsKLQogc3RydWN0IHdmeF9oaWZfZXZlbnQg
ewogCXN0cnVjdCBsaXN0X2hlYWQgbGluazsKIAlzdHJ1Y3QgaGlmX2luZF9ldmVudCBldnQ7CmRp
ZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC93ZnguaAppbmRleCAwYTNkZjM4MmFmMDMuLmJhNmUwZTkyM2Y0YiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC93ZnguaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5oCkBA
IC0xMTMsNyArMTEzLDYgQEAgc3RydWN0IHdmeF92aWYgewogCXUzMgkJCWVycF9pbmZvOwogCWlu
dAkJCWNxbV9yc3NpX3Rob2xkOwogCWJvb2wJCQlzZXRic3NwYXJhbXNfZG9uZTsKLQlzdHJ1Y3Qg
d2Z4X2h0X2luZm8JaHRfaW5mbzsKIAl1bnNpZ25lZCBsb25nCQl1YXBzZF9tYXNrOwogCXN0cnVj
dCBpZWVlODAyMTFfdHhfcXVldWVfcGFyYW1zIGVkY2FfcGFyYW1zW0lFRUU4MDIxMV9OVU1fQUNT
XTsKIAlzdHJ1Y3QgaGlmX3JlcV9zZXRfYnNzX3BhcmFtcyBic3NfcGFyYW1zOwotLSAKMi4yNS4w
Cgo=
