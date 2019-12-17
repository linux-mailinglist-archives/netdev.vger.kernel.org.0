Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9262123176
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbfLQQPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:13 -0500
Received: from mail-bn8nam11on2073.outbound.protection.outlook.com ([40.107.236.73]:39265
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728804AbfLQQPM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eN0NmthCv6ar63fXVcuPoRhHruL0ZmMF6r2Rbp4xq5l0R1Bw39Mtc+ybjrPI3B1XQerNEJJoUNxScqCZsPvekvZ2YzTFPttelj82bLtDdVA6/rIeQ52+zmByd4AMxTXNHzSs8QdnLpoKxbCyD1EWPAeejxZr8hPwsUURiVydrn0avHiZNj/kt1OGeqvypoq5isCytmc9cVlEl7c/r/VgKOk1g2gBvdU7uVxJnFoqXuQm8jB5fIEO8mCJSvQBZiTUIYONzOfIZOvwl+q4M07D7zTxmJvHNza5vAUK07BGCaIWU1HbnZEDFU0TXiO0Dy+ZigxoD+/SoOG4Y2qbRVbbWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAR2CJleKMtf7Fzv+6IfTj9mDulTG22RY2Q0iKygpGM=;
 b=byiD2ewwFJJVQ/E4ldIqNtCF6B++knBF7dILpqfxZbLPXVDVofdHIdomwLsg5FPNWxget5vgOb7CyII+ixDgse/QQtmscRHuBYZm2RWv/YmY0RZM455oWsd7e1oXXOdhnPzbBuHttiq/p/6c4zvQ58LGyOfGHqlOJwQbaYj5BqXhWvxkr1wtklQhZU8BBOlz57w7+YOmKZTMjrM1S1O849L8yLsZu1UTkz2QzWSuKksiqDa3gd/XQOavmAat3RXJgacpMf/4Zq+CJE46o+OyvquFZ2VloimqqXvlWd6QKQgMUyxLxHGbyIpaLkVgeKqVD9LF/zfGtFm1xZ2SosQZnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAR2CJleKMtf7Fzv+6IfTj9mDulTG22RY2Q0iKygpGM=;
 b=Ph0FlskkdA7PZLslB2a3pSkGWDcBAY8XV/LRzJ1Ud4jfQrcj1/eSry51EYMg76Ki33v1zVhTsMVwF+0bpQa5y85cwqVMmRuZJldhiOs2PsJZRtXp8HiUq0Fa0AkorSltg8neG/ENFU2Msue5Mk0XFcEah2WW60FO4SjnvQEJJb8=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:04 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:04 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 26/55] staging: wfx: improve API of
 hif_req_join->infrastructure_bss_mode
Thread-Topic: [PATCH v2 26/55] staging: wfx: improve API of
 hif_req_join->infrastructure_bss_mode
Thread-Index: AQHVtPUkg13sfTPhAkmFbUcYXxvbJg==
Date:   Tue, 17 Dec 2019 16:15:04 +0000
Message-ID: <20191217161318.31402-27-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 0b6fc2a0-7664-4578-4f94-08d7830c46b9
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208FC00E3CD7DE9F2E1B10F93500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(4326008)(8676002)(86362001)(6486002)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Di/P062DZqb/K+9SxmQ8wMbxlTMkeKtjOPStr471xRPrl84B0jjqL/Gczv3SHAx3vNGZ2P1C5MUkNwDZsEzz5uvACwQ05rfGTCZWb8u+yjiYDys5IT3bwHIz2ev6ygJQ1Lr2qtXfH0dV3fAovdPjVOEPuJpOLKiq7dam0fSVcRaq6P0OL+shiE3JySeAlPY8tF8GN01rzGcq+QwVDfpQV77ovQu4DANwP905aJ5yOjzyoULL2H0uzPc+SU/SoUJ3ZZ3MjyKKuzVv8uj/jKLwZcb8hFJADw8VdDbKMJDddNhMTnRxApAhwLi3uS+OVOTRREUC69qKYrirwQseBdP/EQqnsQaMp9uxacRZeqTEJz2TDG2ieQeEfe5ERvcPL7LmXH1oXB6Yd2iuTmsNij7va69K8RiCSP9GzKjTEBpoyfmQaAjiNlUmPJ+6rr/e38+l
Content-Type: text/plain; charset="utf-8"
Content-ID: <5E879E467877804696EFAA130F292F83@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6fc2a0-7664-4578-4f94-08d7830c46b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:04.7109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 986oG1tFXeaUD5e1gUawCzymkhuKJ/sSQdMw8OvVzwNOqSzmAJIn5imouUvepvrHLCby11Q/V+4lR9lqEPh4/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
ZmFjdCAibW9kZSIgaXMgYSBib29sZWFuIHRoYXQgaW5kaWNhdGVzIGlmIElCU1MgbW9kZSBpcyB1
c2VkLiBUaGlzCnBhdGNoIGZpeGVzIHRoZSBuYW1lIGFuZCB1c2VzIGEgbW9yZSBhZGFwdGVkIG1l
bW9yeSByZXByZXNlbnRhdGlvbi4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxq
ZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9h
cGlfY21kLmggfCA4ICsrLS0tLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICAgICAg
fCAyICstCiAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmggYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKaW5kZXggNGNlM2JiNTFjZjA0Li5lODQ4YmQzMDcz
YTIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAorKysgYi9k
cml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl9hcGlfY21kLmgKQEAgLTM3NywxMSArMzc3LDYgQEAgc3Ry
dWN0IGhpZl9jbmZfZWRjYV9xdWV1ZV9wYXJhbXMgewogCXUzMiAgIHN0YXR1czsKIH0gX19wYWNr
ZWQ7CiAKLWVudW0gaGlmX2FwX21vZGUgewotCUhJRl9NT0RFX0lCU1MgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICA9IDB4MCwKLQlISUZfTU9ERV9CU1MgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgPSAweDEKLX07Ci0KIGVudW0gaGlmX3ByZWFtYmxlIHsKIAlISUZfUFJFQU1CTEVf
TE9ORyAgICAgICAgICAgICAgICAgICAgICAgICAgPSAweDAsCiAJSElGX1BSRUFNQkxFX1NIT1JU
ICAgICAgICAgICAgICAgICAgICAgICAgID0gMHgxLApAQCAtMzk2LDcgKzM5MSw4IEBAIHN0cnVj
dCBoaWZfam9pbl9mbGFncyB7CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX3JlcV9qb2luIHsK
LQl1OCAgICBtb2RlOworCXU4ICAgIGluZnJhc3RydWN0dXJlX2Jzc19tb2RlOjE7CisJdTggICAg
cmVzZXJ2ZWQxOjc7CiAJdTggICAgYmFuZDsKIAl1MTYgICBjaGFubmVsX251bWJlcjsKIAl1OCAg
ICBic3NpZFtFVEhfQUxFTl07CmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5j
IGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBiNGJiNWI2NTNlNjQuLjIzZWM3YTRh
OTI2YiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC02NTEsNyArNjUxLDcgQEAgc3RhdGljIHZvaWQgd2Z4X2Rv
X2pvaW4oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJc3RydWN0IGllZWU4MDIxMV9ic3NfY29uZiAq
Y29uZiA9ICZ3dmlmLT52aWYtPmJzc19jb25mOwogCXN0cnVjdCBjZmc4MDIxMV9ic3MgKmJzcyA9
IE5VTEw7CiAJc3RydWN0IGhpZl9yZXFfam9pbiBqb2luID0gewotCQkubW9kZSA9IGNvbmYtPmli
c3Nfam9pbmVkID8gSElGX01PREVfSUJTUyA6IEhJRl9NT0RFX0JTUywKKwkJLmluZnJhc3RydWN0
dXJlX2Jzc19tb2RlID0gIWNvbmYtPmlic3Nfam9pbmVkLAogCQkucHJlYW1ibGVfdHlwZSA9IGNv
bmYtPnVzZV9zaG9ydF9wcmVhbWJsZSA/IEhJRl9QUkVBTUJMRV9TSE9SVCA6IEhJRl9QUkVBTUJM
RV9MT05HLAogCQkucHJvYmVfZm9yX2pvaW4gPSAxLAogCQkuYXRpbV93aW5kb3cgPSAwLAotLSAK
Mi4yNC4wCgo=
