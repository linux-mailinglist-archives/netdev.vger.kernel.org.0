Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3096B123245
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbfLQQVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:21:19 -0500
Received: from mail-eopbgr680046.outbound.protection.outlook.com ([40.107.68.46]:59543
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728350AbfLQQOh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:14:37 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lg2F233jN7e/Nvj7z3Xeih1hNcn02p0hffpv+1+decB792Wap9GhTjwUyeyCh3liwMU3M9UBxf+J6YKU5efsWJzHlXUguYaEHPT5Kb1+KTGJgcjdPSwCb/0+LklwS3JHdeh1NYu+eS6h60JN1j3xV7VzrXPhe7ZQKqFE7YANarXY95O+fUa0jaZweGaZVTPLvVclao5fPSY8J7aSnbXR88GJny+vd+JQ2EdHB+UWXufbVadr4KGf3m78Djl0psTBQApR9elAMg7O4b7F7SCC5Cq+MG9LHc6HTeOnYGv8hI5PNPxaJ1+CNTt5VmZ9bW4iOD7Yfk5AJo44IOlb+HobgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW+GlCwGU1KRrlIvF9xBKI5A21F8qEf1xA0yRpPIjx0=;
 b=NdNTTak5Ift9Wu+nAeYwQerEQI7hgXE3fSdbZ98V2jSd6zuODUaQzAHNo6e7Yx8AE/OjeJD+pmwEKLaTUQf7cR1rm2Yub2HximzekvzPgbGJ7gxiJyvd7FmJ3eOYnpvUQcXXuiNlIan2CYNba6EfTcveKd5Xh1Ug7AXchnxbvNnQFu6bWJSY3V7NaU1LkiYm/31F7oqX99a0MmQEb8goiY7n9W0TUHUIaxVUiIOe+AITrMO9NQD+koFxAMuUZo8Llf2d+wdd2oaEfeTgVxDVZ8wekkWEuITda8fvckxvgqQxSZNwnPYZSsuho2aAj9jn7o0xgKWERsI1QKzlbZu3lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EW+GlCwGU1KRrlIvF9xBKI5A21F8qEf1xA0yRpPIjx0=;
 b=KkAT6gxCoKdPUg/I67aicmcIn9oWvOQCsZbYHbf3CHCriErnwwrwqtHbOOPRNjL5G7ytOZVbtdIl0vhxWcQ4uwaAwhZZwo38nd5u4Im+oN4bLCBFFMjTfq9mvhMO2CmYLUqoA5sdtqyI3rZbSEBYq6tTq9SPjOJJTQVDljGOf20=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB3791.namprd11.prod.outlook.com (20.178.254.78) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 16:14:34 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:14:34 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 05/55] staging: wfx: firmware does not support more than 32
 total retries
Thread-Topic: [PATCH v2 05/55] staging: wfx: firmware does not support more
 than 32 total retries
Thread-Index: AQHVtPURB57vyPfkUU6483afGqAOTA==
Date:   Tue, 17 Dec 2019 16:14:33 +0000
Message-ID: <20191217161318.31402-6-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: ecce136a-c2dc-4e10-3ad6-08d7830c340d
x-ms-traffictypediagnostic: MN2PR11MB3791:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB3791193D3335CFE1E25FD33593500@MN2PR11MB3791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(346002)(136003)(39860400002)(189003)(199004)(2906002)(52116002)(107886003)(2616005)(86362001)(478600001)(6486002)(4326008)(64756008)(66556008)(66476007)(81156014)(66946007)(6506007)(1076003)(316002)(66446008)(8936002)(71200400001)(81166006)(5660300002)(36756003)(26005)(186003)(8676002)(85202003)(4744005)(66574012)(85182001)(110136005)(54906003)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3791;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ScudY5cvDHLk30lVWIsq+ARx710hANedTRRlm+/N3+mfcP/QV5vieohs3sWq4sHlnxiaMGZ2G/KjtWbk5IptYoKFHR/yhV9Hm+PoqgBCFOv54g7AVjfMXSmvP/x/CBK0JQ97ZgjZISil7X19DGXMXPUNe3M+V+hikDfaEcM69Olpbp/KWZhfuyHFDMwgRqk5QTLCmvMjPTmLwI8NM7BdxyCVWMO9lCe083GYN/Ev0x4HqG9L3BRQ30Wq422w9XDKIYDUWCV5jnQaJ6RwCG8uvLHbkw6Wp1FWb3VqsqLbVIG+jSwiEUMbjLcJ1SedMzRoYYyPH+KdPMNi5wMCVvQyqR7b74A2HqnBanx32+oxVf35ut4d8O/m2EMvxGV3axFvZYsa1cgWxwRfSHre7LS+v7XD84b9ySXAFdfQJPz9ICmqefXKXKLKUHzTF5VwyqGL
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CF8296E4FBC304E90F47CD27C471D6B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecce136a-c2dc-4e10-3ad6-08d7830c340d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:14:33.4901
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QzIPpPKqduTNn2Fb8Ai0nL0chjiUJhXLdJh+OqtQr8iq4ZFLa6gy7DM3CNBKSDF7wA9FNPNUGkubB6ZoG5RBog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3791
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IHN1bSBvZiBhbGwgcmV0cmllcyBmb3IgYSBUeCBmcmFtZSBjYW5ub3QgYmUgc3VwZXJpb3IgdG8g
MzIuCgpUaGVyZSBhcmUgNCByYXRlcyBhdCBtb3N0LiBTbyB0aGlzIHBhdGNoIGxpbWl0cyBudW1i
ZXIgb2YgcmV0cmllcyBwZXIKcmF0ZSB0byA4LgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91
aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93
ZngvbWFpbi5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L21haW4uYwppbmRleCA5ODZhMmVmNjc4YjkuLjNiNDdiNmMyMWVhMSAxMDA2
NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9tYWluLmMKKysrIGIvZHJpdmVycy9zdGFnaW5n
L3dmeC9tYWluLmMKQEAgLTI4OSw3ICsyODksNyBAQCBzdHJ1Y3Qgd2Z4X2RldiAqd2Z4X2luaXRf
Y29tbW9uKHN0cnVjdCBkZXZpY2UgKmRldiwKIAlody0+c3RhX2RhdGFfc2l6ZSA9IHNpemVvZihz
dHJ1Y3Qgd2Z4X3N0YV9wcml2KTsKIAlody0+cXVldWVzID0gNDsKIAlody0+bWF4X3JhdGVzID0g
ODsKLQlody0+bWF4X3JhdGVfdHJpZXMgPSAxNTsKKwlody0+bWF4X3JhdGVfdHJpZXMgPSA4Owog
CWh3LT5leHRyYV90eF9oZWFkcm9vbSA9IHNpemVvZihzdHJ1Y3QgaGlmX3NsX21zZ19oZHIpICsK
IAkJCQlzaXplb2Yoc3RydWN0IGhpZl9tc2cpCiAJCQkJKyBzaXplb2Yoc3RydWN0IGhpZl9yZXFf
dHgpCi0tIAoyLjI0LjAKCg==
