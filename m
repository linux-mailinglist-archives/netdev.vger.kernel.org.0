Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C636E13C479
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 14:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbgAONzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 08:55:25 -0500
Received: from mail-dm6nam11on2047.outbound.protection.outlook.com ([40.107.223.47]:4897
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729814AbgAONzY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 08:55:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SDJIGc+vj/jBx9RmU4COyZ5QkY2huRuMwJRD15ICRLz9w+qIs/YasqTkGSe4dQhPCHfnaBvryljpl0Z71MWiernAKOmoGwJNdGnD+zt5L/rDjj8s50YUXCvio1SM3s/Io1M+YgKLvnPBl5eVBvOYTKd38WOP3mzXBlI0reneCTPDI/HZYLJu6FK/Y5Dq/nbpCevKls+QarwCZHzcdTIexfrADAbMlPJxwpF/P5tFaU1BqCEtAlAw++/VeSqm+X0NaWAFmy/GuTc8mxEoDfBxnZZrsDZfdZmpGPZz5rx1x5BaPxCNtOYSFN974z2sSEcm7QLMq6NQVDIGXNpdgkSJ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqaSYkN3+5Zn6ohlAX6hVbCkz5NgCFZL+6QN3uKKY08=;
 b=CNxHJ/VUvkFAq5rUrMz4l9B4OZDY/nvQtnUoW8D/stngtJESNSLmxzCOGWifqtfyfGDMzc7nwFAWLtcMoG6B6SCPfnBncc51l+ZalN74Fr6qHH4RcaxHXoF05pc2+E+rEySRJOR43I4FGSVeL2CpEXqv09dl1SZPjUCxPtlh1j09Fg1WkvX7vwc3FN8BZ1O18qAC1cegUZaSJcyghPyajJ4K43v8RvC1rdzkegDticfT4SdX6ecPY5Ozi1MRZGcxJ/jgz9cEo569+bmkRcRVrxm26w3+8FW90Z13S+ACcamciGyTCjdqtHa2iyNoAZnjfU5r1t22pdw/6hb5vapYyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqaSYkN3+5Zn6ohlAX6hVbCkz5NgCFZL+6QN3uKKY08=;
 b=gpVFi1t5S+bYCET4HzZf36RVYQIg0tzp73yHC531xcK9xy8vIhHESDyXVVsLIT4cwSqkoxn7ujCoWBu1ayjS+UJWuHUsorQv3Kk6OvMA6YESqa7SD+phltgyRpUupul8n9zr1yIbClTOssDnKi49Wkj7u72MGV6U2AtnSS+Jx8Y=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4094.namprd11.prod.outlook.com (10.255.180.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Wed, 15 Jan 2020 13:55:20 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 13:55:20 +0000
Received: from pc-42.home (2a01:e35:8bf5:66a0:3dbe:4cb5:6059:a948) by PR2P264CA0008.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 13:54:55 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 37/65] staging: wfx: simplify wfx_set_mcast_filter()
Thread-Topic: [PATCH v2 37/65] staging: wfx: simplify wfx_set_mcast_filter()
Thread-Index: AQHVy6texVjlQ/wD2USlTJjBKqBd1g==
Date:   Wed, 15 Jan 2020 13:54:56 +0000
Message-ID: <20200115135338.14374-38-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: d70ea8e3-9ecb-4b5c-5778-08d799c28141
x-ms-traffictypediagnostic: MN2PR11MB4094:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB40943A8170DA231DC325DAB293370@MN2PR11MB4094.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(396003)(346002)(136003)(376002)(189003)(199004)(316002)(110136005)(54906003)(85202003)(81156014)(5660300002)(8676002)(71200400001)(8936002)(81166006)(186003)(6506007)(86362001)(66946007)(66446008)(66476007)(66556008)(2906002)(64756008)(478600001)(6512007)(52116002)(66574012)(6486002)(1076003)(16526019)(4326008)(85182001)(107886003)(36756003)(8886007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4094;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ulc7FczGcmjWd3ab7ZcuwISrZXzJtXEOCDnk2HMAu+hwU3j7rDM9mX0WvSj4wBC8ooPKdA1j5htHHfmq3W8miADVcNqoMeg8fLy4QR7U6Pak6/vjMpWljalEcBRsTo6k+JHE8gCEBOilwBIw7f47OIh5pvG7pT/Qz47JDfwK/j/aS/IMBGoRT1i0B/uWnabTRkBFcvm0BZbRGSoiw3Imig8uJBNmDypM5Ojv9JTHBiVyBUnrKPss4DXIpqK2XKbVNReC03q4ZoGZut85BpPR9cjsR7/+mxAgnZyto4Aa+/+6laWt2hgYRB75jKSuQ6cyD7jgDgWIS/yD+LB1nh94UIpn2PXw+q0DbqVldflGPUujTbLNGkj9ncCzewUhANj0Ip5z8TCcIFMAZh57K9RKehWsOf1RzMNOwOgMmHdZgNBgo7QKpB417j51Wjk9Y//W
Content-Type: text/plain; charset="utf-8"
Content-ID: <813CD48D150FD04F90B8328CA5845427@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d70ea8e3-9ecb-4b5c-5778-08d799c28141
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 13:54:56.9231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l/MhyeFyhrOorcD2SFv9hDzd9jfyLosP6W/JMf9n0d6Uyb+q0KqJNe4zIQALuEIS6a/9So0l1625JHGpDZ3IvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSElG
IGZ1bmN0aW9ucyByZXR1cm4gb25seSBzZXJpb3VzIGVycm9ycyAoT09NIG9yIGRldmljZSBmcmVl
emUpLiBUaGUKY3VycmVudCBoYW5kbGluZyBvZiBlcnJvcnMgaW4gd2Z4X3NldF9tY2FzdF9maWx0
ZXIoKSBkb2VzIG5vdCBicmluZwphbnl0aGluZy4gRmluYWxseSBpdCBtYXkgZGlzdHVyYiB0aGUg
ZGV2ZWxvcGVyIG1vcmUgdGhhbiBpdCBoZWxwcy4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIHwgMzAgKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tCiAxIGZpbGUgY2hh
bmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMjAgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXgg
ZTcxYjk5YWExZjYzLi5hOTM0ZjY2ZjNhNGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93
Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMTE2LDcgKzExNiw3
IEBAIGludCB3ZnhfZndkX3Byb2JlX3JlcShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgYm9vbCBlbmFi
bGUpCiBzdGF0aWMgaW50IHdmeF9zZXRfbWNhc3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlm
LAogCQkJCSAgICBzdHJ1Y3Qgd2Z4X2dycF9hZGRyX3RhYmxlICpmcCkKIHsKLQlpbnQgaSwgcmV0
OworCWludCBpOwogCiAJLy8gVGVtcG9yYXJ5IHdvcmthcm91bmQgZm9yIGZpbHRlcnMKIAlyZXR1
cm4gaGlmX3NldF9kYXRhX2ZpbHRlcmluZyh3dmlmLCBmYWxzZSwgdHJ1ZSk7CkBAIC0xMjQsMjUg
KzEyNCwxNSBAQCBzdGF0aWMgaW50IHdmeF9zZXRfbWNhc3RfZmlsdGVyKHN0cnVjdCB3Znhfdmlm
ICp3dmlmLAogCWlmICghZnAtPmVuYWJsZSkKIAkJcmV0dXJuIGhpZl9zZXRfZGF0YV9maWx0ZXJp
bmcod3ZpZiwgZmFsc2UsIHRydWUpOwogCi0JZm9yIChpID0gMDsgaSA8IGZwLT5udW1fYWRkcmVz
c2VzOyBpKyspIHsKLQkJcmV0ID0gaGlmX3NldF9tYWNfYWRkcl9jb25kaXRpb24od3ZpZiwgaSwg
ZnAtPmFkZHJlc3NfbGlzdFtpXSk7Ci0JCWlmIChyZXQpCi0JCQlyZXR1cm4gcmV0OwotCX0KLQot
CXJldCA9IGhpZl9zZXRfdWNfbWNfYmNfY29uZGl0aW9uKHd2aWYsIDAsIEhJRl9GSUxURVJfVU5J
Q0FTVCB8Ci0JCQkJCQkgIEhJRl9GSUxURVJfQlJPQURDQVNUKTsKLQlpZiAocmV0KQotCQlyZXR1
cm4gcmV0OwotCi0JcmV0ID0gaGlmX3NldF9jb25maWdfZGF0YV9maWx0ZXIod3ZpZiwgdHJ1ZSwg
MCwgQklUKDEpLAotCQkJCQkgQklUKGZwLT5udW1fYWRkcmVzc2VzKSAtIDEpOwotCWlmIChyZXQp
Ci0JCXJldHVybiByZXQ7Ci0KLQlyZXQgPSBoaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsIHRy
dWUsIHRydWUpOwotCi0JcmV0dXJuIHJldDsKKwlmb3IgKGkgPSAwOyBpIDwgZnAtPm51bV9hZGRy
ZXNzZXM7IGkrKykKKwkJaGlmX3NldF9tYWNfYWRkcl9jb25kaXRpb24od3ZpZiwgaSwgZnAtPmFk
ZHJlc3NfbGlzdFtpXSk7CisJaGlmX3NldF91Y19tY19iY19jb25kaXRpb24od3ZpZiwgMCwKKwkJ
CQkgICBISUZfRklMVEVSX1VOSUNBU1QgfCBISUZfRklMVEVSX0JST0FEQ0FTVCk7CisJaGlmX3Nl
dF9jb25maWdfZGF0YV9maWx0ZXIod3ZpZiwgdHJ1ZSwgMCwgQklUKDEpLAorCQkJCSAgIEJJVChm
cC0+bnVtX2FkZHJlc3NlcykgLSAxKTsKKwloaWZfc2V0X2RhdGFfZmlsdGVyaW5nKHd2aWYsIHRy
dWUsIHRydWUpOworCisJcmV0dXJuIDA7CiB9CiAKIHZvaWQgd2Z4X3VwZGF0ZV9maWx0ZXJpbmco
c3RydWN0IHdmeF92aWYgKnd2aWYpCi0tIAoyLjI1LjAKCg==
