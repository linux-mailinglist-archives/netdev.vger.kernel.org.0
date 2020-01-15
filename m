Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA3713C4CA
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgAONyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:16 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729011AbgAONyQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XEZIu3Fovd72WM6DKinYT4/d4OPHJKEpb3jhr9cOfnbR1tr/RcdI6VngyTVAqKakOUT6Q6HXP5e5DAwkYWbnauo+jukWVmHnOviu0tvpFXke+laJFEq9rQ27/4h4m38p0lh6uDvQxQZYTnLwm66S5E9e4BKHEOXWalTlXkbW1sUxxGwoMdwkLOvB8c33pS2K57Zr+IIObotY6IyGNCyebmIm8GB1NzJZS/rVCQRWEpYqYo7wfQZq2/W9H1lgTc+hNtkZC9leNBH7SBVNtXfCQZ4270uVJjSsK6Mafh5ImvjJBATOdS1LP0HuRj5Gb7GznLNeO8q17llyFLHOzcmNdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEZlc4WIt+v7EkS55ULjmBTrlz1CZWTH8qKnG2sxQBQ=;
 b=G2Hl8OX5kRHbA4xK8fMTw2G8wofiJ/G3XPwEyQgcv4ISKwtp3dT/LDX2wZTdMD2mJwRzfkBVmBn7EHlvZ50iKsb1UGl7PCckkctNL+bXhERyWbfQ8zSQKn1D3bhwtGLivZqIBns2YQEVhzhlF94UMhIqsmBTVtu0y5S20Aj2U0EVBLDGjey/K8LbtrZkp4qba3Rg1q2OxMAvgt5soXad1IZi400h4C1eWGaKvTyjotnSvN1HxvXlsy5sEYK9tn1wRSWzxB4yze137Mv5j/WX2rOWOPase+IFyzOpgpC25otJdwtI17ZIAUe7c1IdIrM30cFI3fyzahJlr5DfS5X9PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OEZlc4WIt+v7EkS55ULjmBTrlz1CZWTH8qKnG2sxQBQ=;
 b=dz23sIW9qGKGCU2gkH5wvm7icQbVkIQAlxNE46ws6bgggHyDpW25Fat5PuIR2IdQSCUhTFUdZwcMPgk87gIxyDV+RGKKveVibwRTwwnuh+CXbPzwa/DIk5l87BsegCWyAhIcl0Owx/OanAd8g7kVzz1yR3iKUny50eaZudkHbTc=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:05 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:05 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:03 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 02/65] staging: wfx: make hif_scan() usage clearer
Thread-Topic: [PATCH v2 02/65] staging: wfx: make hif_scan() usage clearer
Thread-Index: AQHVy6s/Ndb2TyZkm0GzjGyBr1EUAw==
Date:   Wed, 15 Jan 2020 13:54:05 +0000
Message-ID: <20200115135338.14374-3-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 254ad27a-18e9-4e04-659f-08d799c26251
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4094D8890DF37983A036BDE993370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p7e5biMURsUKPDvhl3s2ffY0vCXBru6dwrSY4zgkGq85rwpTKSC4Uv3Y3Ooy8lQu3WC/jN4WUpRPIi3NXqFwIoNEO+sx7ieClpi/IWS7Un+7t7WYuKTr1w2n24KFa0etSSkuJp+qwEIQEZsqMEUO50ah2fogAe/bezmB1bRRrKcwZoYTlqgpf9z7tSCJ/YXd4dB89yIhe7upWHWIgxptKXdfUPeCxcjQyMFHZxZ0rvDMkjgdb3PajAlMHHBGbDCj7ERVBuvPHB6JCUFFSdrU+5mc75xMzKqrg68lqxcy8jhnzaxvh6LvTJ9cHsl1eQKjGim+OYv7Oe6uTAOttmDefRDvkKDM/Y0m9SmLvARYKgiZfxC57FYyrJdJ2ZO6H7997d17FDIyoWOoZxy3jVeHTYPHcqRKqJdDH2c0U5hY7ysb78CdPLzfdxhEaHVjN305
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA390745B0FDBF4CB61AA6D648C0E5CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254ad27a-18e9-4e04-659f-08d799c26251
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:05.0350
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hBElN6frnUbKvLx78Q6BLAwMXToJeen4ctpJ3DvfTrAP4KwWr/+dk1IhjpPf8MieMc8hLuSKdgLhYShxz/8Exw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKaGlm
X3NjYW4oKSByZXR1cm4gbWF4IG51bWJlciBvZiBqaWZmaWVzIHRvIHdhaXQgYmVmb3JlIHRoZSBj
b21wbGV0aW9uCmluZGljYXRpb24uIEhvd2V2ZXIsIGlmIHRoaXMgdmFsdWUgaXMgbmVnYXRpdmUs
IGFuIGVycm9yIGhhcyBvY2N1cnJlZC4KClJld29yZCB0aGUgY29kZSB0byByZWZsZWN0IHRoYXQg
YmVoYXZpb3IuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWls
bGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgfCA3ICsrKy0t
LS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3NjYW4uYwppbmRleCAyNDA2MWQwOWM0MDQuLjliMzY3NGIzMjI2YSAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zY2FuLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zY2FuLmMK
QEAgLTU2LDEwICs1Niw5IEBAIHN0YXRpYyBpbnQgc2VuZF9zY2FuX3JlcShzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiwKIAl3ZnhfdHhfbG9ja19mbHVzaCh3dmlmLT53ZGV2KTsKIAl3dmlmLT5zY2FuX2Fi
b3J0ID0gZmFsc2U7CiAJcmVpbml0X2NvbXBsZXRpb24oJnd2aWYtPnNjYW5fY29tcGxldGUpOwot
CXJldCA9IGhpZl9zY2FuKHd2aWYsIHJlcSwgc3RhcnRfaWR4LCBpIC0gc3RhcnRfaWR4KTsKLQlp
ZiAocmV0IDwgMCkKLQkJcmV0dXJuIHJldDsKLQl0aW1lb3V0ID0gcmV0OworCXRpbWVvdXQgPSBo
aWZfc2Nhbih3dmlmLCByZXEsIHN0YXJ0X2lkeCwgaSAtIHN0YXJ0X2lkeCk7CisJaWYgKHRpbWVv
dXQgPCAwKQorCQlyZXR1cm4gdGltZW91dDsKIAlyZXQgPSB3YWl0X2Zvcl9jb21wbGV0aW9uX3Rp
bWVvdXQoJnd2aWYtPnNjYW5fY29tcGxldGUsIHRpbWVvdXQpOwogCWlmIChyZXEtPmNoYW5uZWxz
W3N0YXJ0X2lkeF0tPm1heF9wb3dlciAhPSB3dmlmLT53ZGV2LT5vdXRwdXRfcG93ZXIpCiAJCWhp
Zl9zZXRfb3V0cHV0X3Bvd2VyKHd2aWYsIHd2aWYtPndkZXYtPm91dHB1dF9wb3dlciAqIDEwKTsK
LS0gCjIuMjUuMAoK
