Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C473413BFCA
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732311AbgAOMQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:16:34 -0500
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:31808
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731307AbgAOMNe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:13:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNfNMp5BUSKdlT8lafMpCvTd2i+N9k6cJPWuPtkvlkOIhgVA3pwZnh/SDzadexnEkICGKg3Yq3LfOuZL8tsuzkuQPSbIbhG0xxF5dbBbtWqol3JE3yhqR3PmExwC5vCy7x0XCNfjzvmhwaCPnxIjKNAQ9Adcw63y43ztjfT54GzKmczzjgoK+wWCh/vBZJyjtpdBEtcTbt5R/pj/kHImWpZXvnnd4ORhF2aGTd/AZVmzP9AHLN9iQg5z7mcXcIAbDHtjb55QdPJS2mO9MCSpAqupA7Um3sX8o+fmEbCJFOHUFi6DZ5uavTeHUBfrbQmLhBrS/cyXqN3NCJaJxl7YkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqaSYkN3+5Zn6ohlAX6hVbCkz5NgCFZL+6QN3uKKY08=;
 b=CBaXNPMvbAQ5kZMs3yMkL4wJfKb9U8Fdu8r8vzW9Cok8lJ8OusMjpMJ4aKlKj9HBAWE5EG+FkGbXGiy7IshzKCubIz4BkjJQ70QeQE5m3VcDme2oomot+T6euvVgoaku+oZhtK2YLPFOaHY52WnUAZG22fEN3AREjkhu052jslnso/qNDbvajfUNEbf/JvfwGZn8z+VBfpyFoP1Uy2LjLTVANgAs55TLrBw44gSldjFHm2L/IbmYojXobtybQp8Do3ok5tEZSiECOMuN0DlnpsNrqWs9I91jqsoEbmhBcNtWYTLDyeco+OF/dd9kCCajeCdyelwal2ZKtFDL11i2Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HqaSYkN3+5Zn6ohlAX6hVbCkz5NgCFZL+6QN3uKKY08=;
 b=R5KFS8gRH0ItUXIDfI7esF9lB+4D7GixRU5S2KaaY2E4rp6CdhWcZqVUmDIFlP4A8uQjBPvr4iapHlVqgY5gyiR9JK9uvR3VV9Jyvgv1rRDNuLUoHhgUpUbb1mnkVfX9dcK1A/q0nA7yi1W0XzrcIL/xcn4zwKrO+HukYh8MRTE=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4096.namprd11.prod.outlook.com (20.179.150.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Wed, 15 Jan 2020 12:13:24 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2623.018; Wed, 15 Jan 2020
 12:13:24 +0000
Received: from pc-42.silabs.com (37.71.187.125) by PR2PR09CA0009.eurprd09.prod.outlook.com (2603:10a6:101:16::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Wed, 15 Jan 2020 12:12:57 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 37/65] staging: wfx: simplify wfx_set_mcast_filter()
Thread-Topic: [PATCH 37/65] staging: wfx: simplify wfx_set_mcast_filter()
Thread-Index: AQHVy50ffyZ+1pzr9kexID2HJOS3AQ==
Date:   Wed, 15 Jan 2020 12:12:58 +0000
Message-ID: <20200115121041.10863-38-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 02b9fd2b-5f37-4140-02be-08d799b44254
x-ms-traffictypediagnostic: MN2PR11MB4096:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4096B7C806541A479CB4769D93370@MN2PR11MB4096.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 02830F0362
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(85202003)(66946007)(66446008)(66476007)(2906002)(107886003)(66556008)(1076003)(66574012)(64756008)(5660300002)(8936002)(6486002)(186003)(26005)(8676002)(316002)(81156014)(36756003)(52116002)(2616005)(7696005)(478600001)(16526019)(956004)(54906003)(110136005)(86362001)(71200400001)(85182001)(4326008)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4096;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4MavCGGu3CReDAA87N6vK2Tu/JIizp7yMGPem6VB0eYDzD6cxbAI2vBkgWpNwhRVGvS/EIjpg/nmhhAry9WaiU0I8JHIm1kSbill5gKUnQyivLtDJ6nBRrXZIkeXckFGl5s0+3rFTAkIDCdCJN9jyqysOfQS2NTMv5uvzLrv+lwfj4BwxKm1+cUXn0DtEZOf/lqCzqaM8rVyHV33t5OBHNzUFXXuRisb8YgndtEoupANtiWJ9tqA1gUTnWJhXiVxY+rnsTmGGldyE0ATnwW3ciWqFw7q7KaeZBRTbQCrAsC0tUDnTW48b9EdTZRsyqudVNCeCkETusYgMATtt5v8/vFWqYmFJavAbucywx2Toin11H15xjfnJuJPG0l89X6/irlNFWSRr3ulE5KqLrpRQMi/vg/O0xIpjkkjAQfzELVjnjY2cN7DsZIfIBMy6LpO
Content-Type: text/plain; charset="utf-8"
Content-ID: <A04B25D8678C36479DB6BF62394E3711@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02b9fd2b-5f37-4140-02be-08d799b44254
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2020 12:12:58.3898
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d1drJ1rc7yBYXSAKNQirHJiFb8WnXYzAIr1upGkqansa6n7zsHmC7GiNvjDCeopEBkU/fDmDZONJdQfUYUgIow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4096
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
