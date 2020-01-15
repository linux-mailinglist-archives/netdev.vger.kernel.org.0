Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A78E13C46C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729898AbgAONz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:28 -0500
Received: from mail-eopbgr770084.outbound.protection.outlook.com ([40.107.77.84]:58049
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729832AbgAONz0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPTUWwAJogAa6L/kz+YrhmYYrucSjspMqvsdC5KQGHgDlieJb5nEPsquMtsCdLlOWfLSbUwB+qXXT3TNio9mVO6IgMP0gX8UrttNJXuNiDgV4JQE7Ths0/KJ7qXYpmXZeAWTLVwqZJ3Qghc8uZQo5StcBRl8NnBa/CZY3OMzRFcVoWOlLQJDAwKaevNSM9OZt6lMYgnQTUwtbz9kqgXhTXAC/ZViKgqO6eh8cj25Gh0hnXqbewY41xr8ZlfJT84LjuIKFRnifwaJVkwK384iL4nDP+5SkJdb8EZ0D6WPmiRBNmJb0qWDXGEyTUHngw+s+5N05kdR8EsaHqj1LYNtAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wE4NZayrc5/OqYjwEoTG0wWNVVdW3mn+wI1Dx4BnsqA=;
 b=GLDctxCX4cW4tFx/HhfnBBejZRQn4j/btNy9+3c7LUoINHTZ/ehYv3zqbMXaoBXhPf6yQAxqu1mR8y6fbMH+gW3xDa9ifqIamcvDF7pferqR3u2l+E8uXqiz4kiLfAtM8eYP/NnKppAQvqnK9BuUR+pk6IuPw6O5ZSm8ZYsaL+/D3SD1htoYMxJzc0XVx6guC7+sDiBkKAqWRAqaJFxMFRKvONYd//EWHuV22J2Au6HDkTOb1PZS5qvaHUg1PpWBXavuu3p4hU8pbSWnGauxS5vMxVZiy9GTccL8aP1A0G0D84ORMLRGqhIH0nVWVzdSA4aPzsRZQJkDR9WsOZFnuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wE4NZayrc5/OqYjwEoTG0wWNVVdW3mn+wI1Dx4BnsqA=;
 b=RpUz1f4TCRB3y2p3g7fWxTohcPvlblUXIOXPUKvfXrUj89zoCy49wiDagOzmT9okmwWg+0fCBQXVt4b4cIeNW3oJ4nmLopYFbDf0CtkVWuHbLdoHeJk2SOnvQykJuXO1ORVBUG1sEN0/mQvXCVICHdCtykuIkyvtuNB83HYGh+0=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3661.namprd11.prod.outlook.com (20.178.252.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Wed, 15 Jan 2020 13:55:19 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:19 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:53 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 35/65] staging: wfx: simplify hif_set_mac_addr_condition()
Thread-Topic: [PATCH v2 35/65] staging: wfx: simplify
 hif_set_mac_addr_condition()
Thread-Index: AQHVy6tdKZiopWSZ2kOuHCvFUPD35A==
Date:   Wed, 15 Jan 2020 13:54:54 +0000
Message-ID: <20200115135338.14374-36-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 2d02b6f4-9692-4992-70f1-08d799c27f9c
x-ms-traffictypediagnostic: MN2PR11MB3661:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB36617E15636DF953891A893F93370@MN2PR11MB3661.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(396003)(136003)(346002)(366004)(199004)(189003)(8886007)(6486002)(316002)(54906003)(71200400001)(36756003)(6506007)(66476007)(66446008)(66946007)(110136005)(8676002)(81166006)(81156014)(478600001)(86362001)(2616005)(4326008)(66574012)(2906002)(107886003)(1076003)(16526019)(186003)(85202003)(5660300002)(6512007)(52116002)(64756008)(66556008)(85182001)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3661;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W4GlHOAe5oC0MeoZ7wgzeQwf7dhoJuK8ldCA7uujxoTxKoaDYnIRfVuqojXOKaZx++DhbmMHoqsZHYOuK3Wvye7VoJ16l7tCR7qWHX81a0XjiXhhN684Wdy4uwWGIlILKrbu9EvM/BMANtAKywB3DDDVOq9J4D5/ugYkhNS8N9y0PrUCWHr2qj9nyXX4Rcxdho4eV/fvWaVMRigPuGFwKbAHTgxCAwBEj6Tn1tikrrNeMnqbpkGJyAv2bKfPny1F/gwpUxH/QKj/rx9LdjCvQJnr9rKpJwAGWjAvn3ORp7U8zlrQ3urmVWH2f2Jl3JtCO20PW26vm9j08lYpvelzOmGCCJTXjdZYtG1pvudFdyWMG2OTfzGD48uAGl11QTqvp+CeHxFBSSwNRA7q2KqTncuwP5AZgRp7yF+jt6xa6+GINwQVD65TY2QkhyaSg1pv
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A0FED88EB22C64384549192AA4995C2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d02b6f4-9692-4992-70f1-08d799c27f9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:54.1597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RXkemEvno/OhSSLkG7jinIQdeRGMCm1lPe0JPNDJk4vzY5bEn9GYT6evktAAUbA5oxvy8n+21NHWZGLZ0aaN7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3661
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN0cnVjdHVyZSBoaWZfbWliX21hY19hZGRyX2RhdGFfZnJhbWVfY29uZGl0aW9uIGNvbWUgZnJv
bSBoYXJkd2FyZQpBUEkuIEl0IGlzIG5vdCBpbnRlbmRlZCB0byBiZSBtYW5pcHVsYXRlZCBpbiB1
cHBlciBsYXllcnMgb2YgdGhlIGRyaXZlci4KCkluIGFkZCwgY3VycmVudCBjb2RlIGZvciBoaWZf
c2V0X21hY19hZGRyX2NvbmRpdGlvbigpIGlzIHRvbyBkdW1iLiBJdApzaG91bGQgcGFjayBkYXRh
IHdpdGggaGFyZHdhcmUgcmVwcmVzZW50YXRpb24gaW5zdGVhZCBvZiBsZWF2aW5nIGFsbAp3b3Jr
IHRvIHRoZSBjYWxsZXIuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21l
LnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWli
LmggfCAxMCArKysrKysrKy0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICB8ICA5
ICstLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9u
cygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oIGIvZHJp
dmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmgKaW5kZXggZWUyMmM3MTY5ZmFiLi45MDQ3NGIx
YzVlYzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCisrKyBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5oCkBAIC0yMzksMTEgKzIzOSwxNyBAQCBz
dGF0aWMgaW5saW5lIGludCBoaWZfc2V0X3R4X3JhdGVfcmV0cnlfcG9saWN5KHN0cnVjdCB3Znhf
dmlmICp3dmlmLAogfQogCiBzdGF0aWMgaW5saW5lIGludCBoaWZfc2V0X21hY19hZGRyX2NvbmRp
dGlvbihzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKLQkJCQkJICAgICBzdHJ1Y3QgaGlmX21pYl9tYWNf
YWRkcl9kYXRhX2ZyYW1lX2NvbmRpdGlvbiAqYXJnKQorCQkJCQkgICAgIGludCBpZHgsIGNvbnN0
IHU4ICptYWNfYWRkcikKIHsKKwlzdHJ1Y3QgaGlmX21pYl9tYWNfYWRkcl9kYXRhX2ZyYW1lX2Nv
bmRpdGlvbiB2YWwgPSB7CisJCS5jb25kaXRpb25faWR4ID0gaWR4LAorCQkuYWRkcmVzc190eXBl
ID0gSElGX01BQ19BRERSX0ExLAorCX07CisKKwlldGhlcl9hZGRyX2NvcHkodmFsLm1hY19hZGRy
ZXNzLCBtYWNfYWRkcik7CiAJcmV0dXJuIGhpZl93cml0ZV9taWIod3ZpZi0+d2Rldiwgd3ZpZi0+
aWQsCiAJCQkgICAgIEhJRl9NSUJfSURfTUFDX0FERFJfREFUQUZSQU1FX0NPTkRJVElPTiwKLQkJ
CSAgICAgYXJnLCBzaXplb2YoKmFyZykpOworCQkJICAgICAmdmFsLCBzaXplb2YodmFsKSk7CiB9
CiAKIHN0YXRpYyBpbmxpbmUgaW50IGhpZl9zZXRfdWNfbWNfYmNfY29uZGl0aW9uKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLApkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2Ry
aXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggNTg4MDk0NDg2YTdhLi5iNzRlMGNlNDEwNjkg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwpAQCAtMTE4LDcgKzExOCw2IEBAIHN0YXRpYyBpbnQgd2Z4X3NldF9tY2Fz
dF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCiB7CiAJaW50IGksIHJldDsKIAlzdHJ1Y3Qg
aGlmX21pYl9jb25maWdfZGF0YV9maWx0ZXIgY29uZmlnID0geyB9OwotCXN0cnVjdCBoaWZfbWli
X21hY19hZGRyX2RhdGFfZnJhbWVfY29uZGl0aW9uIGZpbHRlcl9hZGRyX3ZhbCA9IHsgfTsKIAog
CS8vIFRlbXBvcmFyeSB3b3JrYXJvdW5kIGZvciBmaWx0ZXJzCiAJcmV0dXJuIGhpZl9zZXRfZGF0
YV9maWx0ZXJpbmcod3ZpZiwgZmFsc2UsIHRydWUpOwpAQCAtMTI2LDE0ICsxMjUsOCBAQCBzdGF0
aWMgaW50IHdmeF9zZXRfbWNhc3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAogCWlmICgh
ZnAtPmVuYWJsZSkKIAkJcmV0dXJuIGhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgZmFsc2Us
IHRydWUpOwogCi0JLy8gQTEgQWRkcmVzcyBtYXRjaCBvbiBsaXN0CiAJZm9yIChpID0gMDsgaSA8
IGZwLT5udW1fYWRkcmVzc2VzOyBpKyspIHsKLQkJZmlsdGVyX2FkZHJfdmFsLmNvbmRpdGlvbl9p
ZHggPSBpOwotCQlmaWx0ZXJfYWRkcl92YWwuYWRkcmVzc190eXBlID0gSElGX01BQ19BRERSX0Ex
OwotCQlldGhlcl9hZGRyX2NvcHkoZmlsdGVyX2FkZHJfdmFsLm1hY19hZGRyZXNzLAotCQkJCWZw
LT5hZGRyZXNzX2xpc3RbaV0pOwotCQlyZXQgPSBoaWZfc2V0X21hY19hZGRyX2NvbmRpdGlvbih3
dmlmLAotCQkJCQkJICZmaWx0ZXJfYWRkcl92YWwpOworCQlyZXQgPSBoaWZfc2V0X21hY19hZGRy
X2NvbmRpdGlvbih3dmlmLCBpLCBmcC0+YWRkcmVzc19saXN0W2ldKTsKIAkJaWYgKHJldCkKIAkJ
CXJldHVybiByZXQ7CiAJCWNvbmZpZy5tYWNfY29uZCB8PSAxIDw8IGk7Ci0tIAoyLjI1LjAKCg==
