Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 965A513C47C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 15:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgAONys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:54:48 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:14113
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729454AbgAONyq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:54:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Te0daHa6Hy88EMAnbIKWHh99DYl84LH8Wc2QTkB6uwPmZH9w/YQ5ImcWS3LivYzoJdG4r8v/d8GUCEhBPVIKDxv1DnpXkjRWG/oCzlHxhpiaqSTisAhnt3/Lk2T31Sd+J+se7o1d1nWdMHzQN3gPv0e0sGSDbLInIAyoD/vPH2clvB4dx4CSj2ApIXn1lcJM+CN+STNKeTjzSyySv+zccODObeUQmQqVv+YEgnWKL8m9uS/C3fq7ImicJYhFjy3gqLcv4qmvcwf2kgpYN+ZYp4djD/ZGACUM4jluEvnN0U2gD1DBKvAR780ig0DKUM6ndSc8h8nss+kw3m1RqPyPcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v8lmwrZH/RnjmTRFxIndgVQtr5M/Rb020b3Yufs6f8=;
 b=czBbthKRyd3vyj0NGMthtLLHrpoAPA5PbjxtGDgZMWkwUZYEZ06cbPM6acSyPRsq9azZFO8GfThzOAkLXgyAS/npYqrUI382LiLKwDOwKjhK4s+BZavtB3Ioak3eJjNkhTQ8naH/apFogeckLx7a00DhYYSWZQzUzH9GIJUdGb2B+87jEOeCqX8KqxLi5KRpWKxOuiwEbEliDNueAaNouw9FjvwgMz2DhN8Ju+3XiHrHXKbqiEgP8pHbQhD5rFQwmaSfbUIA5Xhhb4miZSlkmX8DfCRU2hp3U3ZCH5SIk+amLQMpwb2ZvEZtnwS5zSouNu5ZAxn5XYmh397g2zaZYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v8lmwrZH/RnjmTRFxIndgVQtr5M/Rb020b3Yufs6f8=;
 b=dvcZD+GbmbUOcpCx2CcJ4GK/g9PXyTKzHgjKHRNFZmUYoaFxxXm0vw69NLXiOHkPUQFFAsnUhN+UyoYas6PMZNiFhZuAY336Eba1vG1ByHPpMChyVqhqQx2jJfMeQe7M48BXtrxnge5hCaCFLdx/Gqf5CiQiVBXyz/0PXkGJMmU=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:54:29 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:54:29 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:27 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 19/65] staging: wfx: fix __wfx_flush() when drop == false
Thread-Topic: [PATCH v2 19/65] staging: wfx: fix __wfx_flush() when drop ==
 false
Thread-Index: AQHVy6tOjJgVdNaIeEm4iALKY8/T+Q==
Date:   Wed, 15 Jan 2020 13:54:29 +0000
Message-ID: <20200115135338.14374-20-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 724be364-0141-4c1a-c623-08d799c2709e
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40941BC946D22A92062CE51093370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BFVKgGbPcwqP6yrBXPBYCLM/QwwwUojMH4+1vw01rffuoidf+VkdyLuYSpQGDb6pA4Xr9caSTyDQz+/zzr5xWN7yrs8EsKzuEPQdJKNmmrarTzXCr202D3AflRYRuz+5uzWDKy5u6e4eNDdiQ+MVA+UDTeTr37481iFiakwt0eWbaF7Ux7gd1IWktKuMEGgfSaB3oqL6T0153HnXs05QgkCa20F+oPEHEE7V1wSRWd+wG5H4wHw19nnTTN2z4PiTA4xexJLpgj/9P1rpC9Juzva2ZFdNCPLqFpswNfG6Kapoim7oV3O+zBcDAMeveXJtjhaRcqobqyippeO3EwUvNUn0+llSw714PMuay7Z8kdMV+pV7DLF6u2F+smHjaMRdbVI6YWCLj+Vi1zjmEj3Q5IhITlf/KYr+M3YlCxm0rIaJKYOaoAtTBHkX7Nq9S/Qt
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB458BAC12297648AB167C228BDBB6CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 724be364-0141-4c1a-c623-08d799c2709e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:29.0502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lOQbPPAs26qcXBwIoaLFSyKED6qyoXoC2kXYXnhL6atqzXXU2Oi/3YGG64FPt/MtdF/3QlZXM17fqxZIfwJrWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X3R4X3F1ZXVlc19jbGVhcigpIG9ubHkgY2xlYXIgbm90IHlldCBzZW50IHJlcXVlc3RzLiBTbywg
aXQgYWx3YXlzCm5lY2Vzc2FyeSB0byB3YWl0IGZvciB0eF9xdWV1ZV9zdGF0cy53YWl0X2xpbmtf
aWRfZW1wdHkgd2hhdGV2ZXIgdGhlCnZhbHVlIG9mICJkcm9wIiBhcmd1bWVudC4KCkluIGFkZCwg
aXQgaXMgbm90IG5lY2Vzc2FyeSB0byByZXR1cm4gd2l0aCB0eCBxdWV1ZSBsb2NrZWQgc2luY2Ug
YWxsCmNhbGxzIHRvIF9fd2Z4X2ZsdXNoKCkgdW5sb2NrIHRoZSB0eCBxdWV1ZSBqdXN0IGFmdGVy
IHRoZSBjYWxsIHRvCl9fd2Z4X3R4X2ZsdXNoKCkuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQ
b3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5n
L3dmeC9xdWV1ZS5jIHwgIDIgLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgICB8IDQyICsr
KysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTEg
aW5zZXJ0aW9ucygrKSwgMzMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9xdWV1ZS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCmluZGV4IGFiZmJh
ZDdjOWY3NS4uOTJiYjlhNzk0ZjMwIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3F1
ZXVlLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jCkBAIC0zMSw4ICszMSw2IEBA
IHZvaWQgd2Z4X3R4X2ZsdXNoKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2KQogewogCWludCByZXQ7CiAK
LQlXQVJOKCFhdG9taWNfcmVhZCgmd2Rldi0+dHhfbG9jayksICJ0eF9sb2NrIGlzIG5vdCBsb2Nr
ZWQiKTsKLQogCS8vIERvIG5vdCB3YWl0IGZvciBhbnkgcmVwbHkgaWYgY2hpcCBpcyBmcm96ZW4K
IAlpZiAod2Rldi0+Y2hpcF9mcm96ZW4pCiAJCXJldHVybjsKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmluZGV4IDBjNzM2
OTFhYjczNi4uM2Q2NjVlZWY4YmE3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTM0Myw0MiArMzQzLDI1IEBA
IGludCB3Znhfc2V0X3J0c190aHJlc2hvbGQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiB2
YWx1ZSkKIAlyZXR1cm4gMDsKIH0KIAotLyogSWYgc3VjY2Vzc2Z1bCwgTE9DS1MgdGhlIFRYIHF1
ZXVlISAqLwogc3RhdGljIGludCBfX3dmeF9mbHVzaChzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgYm9v
bCBkcm9wKQogewotCWludCByZXQ7Ci0KIAlmb3IgKDs7KSB7Ci0JCWlmIChkcm9wKSB7CisJCWlm
IChkcm9wKQogCQkJd2Z4X3R4X3F1ZXVlc19jbGVhcih3ZGV2KTsKLQkJfSBlbHNlIHsKLQkJCXJl
dCA9IHdhaXRfZXZlbnRfdGltZW91dCgKLQkJCQl3ZGV2LT50eF9xdWV1ZV9zdGF0cy53YWl0X2xp
bmtfaWRfZW1wdHksCi0JCQkJd2Z4X3R4X3F1ZXVlc19pc19lbXB0eSh3ZGV2KSwKLQkJCQkyICog
SFopOwotCQl9Ci0KLQkJaWYgKCFkcm9wICYmIHJldCA8PSAwKSB7Ci0JCQlyZXQgPSAtRVRJTUVE
T1VUOwotCQkJYnJlYWs7Ci0JCX0KLQkJcmV0ID0gMDsKLQotCQl3ZnhfdHhfbG9ja19mbHVzaCh3
ZGV2KTsKLQkJaWYgKCF3ZnhfdHhfcXVldWVzX2lzX2VtcHR5KHdkZXYpKSB7Ci0JCQkvKiBIaWdo
bHkgdW5saWtlbHk6IFdTTSByZXF1ZXVlZCBmcmFtZXMuICovCi0JCQl3ZnhfdHhfdW5sb2NrKHdk
ZXYpOwotCQkJY29udGludWU7Ci0JCX0KLQkJYnJlYWs7CisJCWlmICh3YWl0X2V2ZW50X3RpbWVv
dXQod2Rldi0+dHhfcXVldWVfc3RhdHMud2FpdF9saW5rX2lkX2VtcHR5LAorCQkJCSAgICAgICB3
ZnhfdHhfcXVldWVzX2lzX2VtcHR5KHdkZXYpLAorCQkJCSAgICAgICAyICogSFopIDw9IDApCisJ
CQlyZXR1cm4gLUVUSU1FRE9VVDsKKwkJd2Z4X3R4X2ZsdXNoKHdkZXYpOworCQlpZiAod2Z4X3R4
X3F1ZXVlc19pc19lbXB0eSh3ZGV2KSkKKwkJCXJldHVybiAwOworCQlkZXZfd2Fybih3ZGV2LT5k
ZXYsICJmcmFtZXMgcXVldWVkIHdoaWxlIGZsdXNoaW5nIHR4IHF1ZXVlcyIpOwogCX0KLQlyZXR1
cm4gcmV0OwogfQogCiB2b2lkIHdmeF9mbHVzaChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3Ry
dWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJICB1MzIgcXVldWVzLCBib29sIGRyb3ApCiB7Ci0J
c3RydWN0IHdmeF9kZXYgKndkZXYgPSBody0+cHJpdjsKIAlzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZjsK
IAogCWlmICh2aWYpIHsKQEAgLTM4OSwxMCArMzcyLDggQEAgdm9pZCB3ZnhfZmx1c2goc3RydWN0
IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJCSAgICAhd3Zp
Zi0+ZW5hYmxlX2JlYWNvbikKIAkJCWRyb3AgPSB0cnVlOwogCX0KLQogCS8vIEZJWE1FOiBvbmx5
IGZsdXNoIHJlcXVlc3RlZCB2aWYKLQlpZiAoIV9fd2Z4X2ZsdXNoKHdkZXYsIGRyb3ApKQotCQl3
ZnhfdHhfdW5sb2NrKHdkZXYpOworCV9fd2Z4X2ZsdXNoKGh3LT5wcml2LCBkcm9wKTsKIH0KIAog
LyogV1NNIGNhbGxiYWNrcyAqLwpAQCAtMTA0Niw4ICsxMDI3LDcgQEAgc3RhdGljIGludCB3Znhf
c2V0X3RpbV9pbXBsKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCBib29sIGFpZDBfYml0X3NldCkKIAlz
a2IgPSBpZWVlODAyMTFfYmVhY29uX2dldF90aW0od3ZpZi0+d2Rldi0+aHcsIHd2aWYtPnZpZiwK
IAkJCQkgICAgICAgJnRpbV9vZmZzZXQsICZ0aW1fbGVuZ3RoKTsKIAlpZiAoIXNrYikgewotCQlp
ZiAoIV9fd2Z4X2ZsdXNoKHd2aWYtPndkZXYsIHRydWUpKQotCQkJd2Z4X3R4X3VubG9jayh3dmlm
LT53ZGV2KTsKKwkJX193ZnhfZmx1c2god3ZpZi0+d2RldiwgdHJ1ZSk7CiAJCXJldHVybiAtRU5P
RU5UOwogCX0KIAl0aW1fcHRyID0gc2tiLT5kYXRhICsgdGltX29mZnNldDsKLS0gCjIuMjUuMAoK
