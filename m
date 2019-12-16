Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31FA81210AF
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfLPRDv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:03:51 -0500
Received: from mail-eopbgr750081.outbound.protection.outlook.com ([40.107.75.81]:59109
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726515AbfLPRDt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:03:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EZ0Ap+N4Y3KXnYw88WTgJlE9s8TFU+Z0LEousYt5AeJU/5szVSWj3+rDd4yZ8amWe+K7Rv35qvy4LWOR+LynO3oeNwBkDjMIj9klTzMlRRqP5wlgjI43+DLipho9CRDT7ceePS9NhyvHAm96KSodihuFowp+2oDXz2VG2h2C80JpFh0pGmjOBdLcI8wg1gjM547XonMCCG5ajeI8uucoevoGC5Reh41q2lbXEI9axAAkk8E0z7llQnTHlQfZKPD7eYoX4Tvc3glEZUKwhEUjP85rdUevsMQ2mI5eZnxCAfUkhX9pqKj1yLIE2iF27aj4m6lzNPMj6hTf1KIH495xRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMuY9Bd/n5yOSxKk77U3gaSSLH6bVEIGEc9MECBvc44=;
 b=Cg+aN/Z1rTY1CzUUl4noAKppq10GDUl/yXc4wms+U8dVlWnSUaDvTkKCOpSjBNKG5MMj+7o4hBt6QWvw4tz4iIU9AaquBlmgwcUHQoPMhldxXNWR3LroHqmDd0AtmiIJUe9rZOU1+l7yRQm54NeAAQbDDjGP1xsjh/U0damYRGiskjhM+O4YF/uFmfyEDywXqY13iGS7WxlfbqQ8rxaSU9ZP/s11k8wO+Rj7IMoZ/rB1pHLBoY8ArF+pjQcxsVdY4PG+6pqqvL9B3aAzAhchcZkHxQru6zbynzjBURFqDnm3tObDhFA89Yt53nxIsW+YQiAUMGwL3z7J8JiPeBpUNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMuY9Bd/n5yOSxKk77U3gaSSLH6bVEIGEc9MECBvc44=;
 b=JdkXQZspfKtHH43bFd3WGjzhrY40BXruoXVMwPTr1p0rf6LKUOw2mmv4yyhPPtA7mVJFZ6FJE/fAqk0/IThePSl+7+EMYpCXWED9VCCW0oaG+JObJXzNldc8jRL92qLcfhEMr8x6YtOEsZRRnGAndCw9+526qhQiG34Q2uh0cZA=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3838.namprd11.prod.outlook.com (20.178.252.202) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Mon, 16 Dec 2019 17:03:41 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:03:41 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH 06/55] staging: wfx: fix rate control handling
Thread-Topic: [PATCH 06/55] staging: wfx: fix rate control handling
Thread-Index: AQHVtDLBrt01a30t0E2TkFlK/I6J9g==
Date:   Mon, 16 Dec 2019 17:03:36 +0000
Message-ID: <20191216170302.29543-7-Jerome.Pouiller@silabs.com>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdb3a1b0-4b12-418e-4ab1-08d78249e70b
x-ms-traffictypediagnostic: MN2PR11MB3838:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB383803F6EB6346739760ECF893510@MN2PR11MB3838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(136003)(39860400002)(396003)(366004)(189003)(199004)(85202003)(8936002)(81166006)(8676002)(54906003)(110136005)(316002)(85182001)(6506007)(186003)(2906002)(5660300002)(6512007)(26005)(107886003)(81156014)(36756003)(4326008)(6666004)(2616005)(76116006)(91956017)(64756008)(66556008)(66476007)(66946007)(71200400001)(86362001)(66446008)(6486002)(478600001)(1076003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3838;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HsQWRMopeVk0jSZ2keiwjN8l3E4pkbbNm2hyC6UEk/8S2I0hMwXEmvgmrGwrW/Qchz1nWCRxFlW0vpHoh0WZhtyGO0k5kI8XBaDq2SljOAhXDHeWx8png3au6rCq1F1Vu65TbBq+dbjCnCnSxZ98xeXCjjS8KqGniLYoTUQJQiqFhKrSqYpmQ/dwI0qriD7tTLkijJYbKLz6Qp/UpPMFhzE0h4z+hu3tqCQz9sJ4OaJaH1fM1UZnQjfeoP7/nMdkoMfe/4+rAuEoOCZlY1ieSxOiLjnUHAQOIQhBCJ99WkgQMUID0WGBXsWkjybUEDm3o8mLvAxKg+arcE5VB67AFIRKTuIqDFQpE9YY/ltpVbetbNIGM6JowPHah6xBLnrY58K6yMJKdo3FkfInq44xicZoN2Y8667JfVD6+QcjjGU4fiju3ZiofLFgPD/IR+UP
Content-Type: text/plain; charset="utf-8"
Content-ID: <966E117E84C6214FB71D6AAC690B6CC0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb3a1b0-4b12-418e-4ab1-08d78249e70b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:03:36.3715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wt4B+/9SyR0j63vGmnfzihvaVBBTNTtMs9pdfQwj8+g1R1VM7F+6uXvY0urzTDsaFaJY4P6PNdMJVfAVgNSt6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3838
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPg0KDQpB
IHR4X3JldHJ5X3BvbGljeSAodGhlIGVxdWl2YWxlbnQgb2YgYSBsaXN0IG9mIGllZWU4MDIxMV90
eF9yYXRlIGluDQpoYXJkd2FyZSBBUEkpIGlzIG5vdCBhYmxlIHRvIGluY2x1ZGUgYSByYXRlIG11
bHRpcGxlIHRpbWUuIFNvIGN1cnJlbnRseSwNCnRoZSBkcml2ZXIgbWVyZ2VzIHRoZSBpZGVudGlj
YWwgcmF0ZXMgZnJvbSB0aGUgcG9saWN5IHByb3ZpZGVkIGJ5DQptaW5zdHJlbCAoYW5kIGl0IHRy
eSB0byBkbyB0aGUgYmVzdCBjaG9pY2UgaXQgY2FuIGluIHRoZSBhc3NvY2lhdGVkDQpmbGFncykg
YmVmb3JlIHRvIHNlbnQgaXQgdG8gZmlybXdhcmUuDQoNClVudGlsIG5vdywgd2hlbiByYXRlcyBh
cmUgbWVyZ2VkLCBmaWVsZCAiY291bnQiIGlzIHNldCB0bw0KbWF4KGNvdW50MSwgY291bnQyKS4g
QnV0LCBpdCBtZWFucyB0aGF0IHRoZSBzdW0gb2YgcmV0cmllcyBmb3IgYWxsIHJhdGVzDQpjb3Vs
ZCBiZSBmYXIgbGVzcyB0aGFuIGluaXRpYWwgbnVtYmVyIG9mIHJldHJpZXMuIFNvLCB0aGlzIHBh
dGNoIGNoYW5nZXMNCnRoZSB2YWx1ZSBvZiBmaWVsZCAiY291bnQiIHRvIGNvdW50MSArIGNvdW50
Mi4gVGh1cywgc3VtIG9mIGFsbCByZXRyaWVzDQpmb3IgYWxsIHJhdGVzIHN0YXkgdGhlIHNhbWUu
DQoNClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2ls
YWJzLmNvbT4NCi0tLQ0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgNiArKystLS0N
CiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KDQpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMgYi9kcml2ZXJzL3N0YWdpbmcv
d2Z4L2RhdGFfdHguYw0KaW5kZXggYjcyNmRkNWU1OWYzLi40NmFkODNiOTVmNTIgMTAwNjQ0DQot
LS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYw0KKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9kYXRhX3R4LmMNCkBAIC01MjQsOSArNTI0LDkgQEAgc3RhdGljIHZvaWQgd2Z4X3R4X2Zp
eHVwX3JhdGVzKHN0cnVjdCBpZWVlODAyMTFfdHhfcmF0ZSAqcmF0ZXMpDQogCQlmb3IgKGkgPSAw
OyBpIDwgSUVFRTgwMjExX1RYX01BWF9SQVRFUyAtIDE7IGkrKykgew0KIAkJCWlmIChyYXRlc1tp
ICsgMV0uaWR4ID09IHJhdGVzW2ldLmlkeCAmJg0KIAkJCSAgICByYXRlc1tpXS5pZHggIT0gLTEp
IHsNCi0JCQkJcmF0ZXNbaV0uY291bnQgPQ0KLQkJCQkJbWF4X3QoaW50LCByYXRlc1tpXS5jb3Vu
dCwNCi0JCQkJCSAgICAgIHJhdGVzW2kgKyAxXS5jb3VudCk7DQorCQkJCXJhdGVzW2ldLmNvdW50
ICs9IHJhdGVzW2kgKyAxXS5jb3VudDsNCisJCQkJaWYgKHJhdGVzW2ldLmNvdW50ID4gMTUpDQor
CQkJCQlyYXRlc1tpXS5jb3VudCA9IDE1Ow0KIAkJCQlyYXRlc1tpICsgMV0uaWR4ID0gLTE7DQog
CQkJCXJhdGVzW2kgKyAxXS5jb3VudCA9IDA7DQogDQotLSANCjIuMjAuMQ0K
