Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDF81231E7
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbfLQQPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:52 -0500
Received: from mail-bn8nam11on2041.outbound.protection.outlook.com ([40.107.236.41]:6164
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728985AbfLQQPt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cc5woHWIBU1vVGxoCPShMpjuvN+dZMDzVjG/UZOHnomc6FVk022YIkQoWMwV90w8BIq+Mzl8bI4mSoU/6z3bvJ6J7Vc0N/C0CYQPqBn7Pyj/GeKSq6PbAV8vEij+FZWlPp7fJDA2mT6eqeTt48gb03SBWutfoY8cShkND/oZCs5Kw1SoFYsNAmVFmm1a/x9TVyhwhaNMcr1jn+yuhn3O+JbgsXwMFZq0Ab7gVokOATX2GkebFvmgrM+48vXUw3XVCaG27UvX98hwS+fc0FLKpae5DCVOmNDrI8mPa0TkCTzmg3Wp9Nh2tip2Esl3/3f0Ns0LKTrl+qs7YGORhuJDaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBtnj1bNQTnGGhOpk3jCRHj24nG0onADt+L/8QwqKtM=;
 b=WTrGBJD5fkei/w0qMvp7QqMXmzgat3iG5553q22oKs97DkvtffTlXZTFOn+f/w4ZDr6C6Q3Ix2lfaRidsZ6ZqddRyh/gl+4px3o3Rcw352NO1iaaai3Mp3LuE95oV+qqdBVa9otRxw56ezxm862/v+aLj5ZjTGlJHoC8jOEdM812GEPUhur1cYOaEi5qRTPON+5tyAy1Rj2MRAxO+NYPEMK6FXlreGDbLUnBu+rWbngljFzcqpThkMH/D2OGJ+UO8SBcNbG4fFPY0dgy5l7nKgzg3X6n0JSjTzJ2xd0RhzmbWlhGajGALyp/aoYQoOU7MvBJgm4I/FgvwsUYzpj8OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fBtnj1bNQTnGGhOpk3jCRHj24nG0onADt+L/8QwqKtM=;
 b=WftvVjyqZnei0p8O4OmcEjKk2S5ArJaLVkOa83oJ6/UbsX4OVKtd1rh8+vtvNHdgAo7JhRJlmS9Pe+J3STdJu03SqlfWucdH1/0Gelnt3Emv/Cn2nhPS/grexXd7SxRokyL/Xwph8lWtGPbAt/D75P9JNdqkDk4iNlg/ZC0nKFI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:43 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:43 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 36/55] staging: wfx: fix pm_mode timeout
Thread-Topic: [PATCH v2 36/55] staging: wfx: fix pm_mode timeout
Thread-Index: AQHVtPUsDpz282pF+Eq5j4+Emd0k5w==
Date:   Tue, 17 Dec 2019 16:15:17 +0000
Message-ID: <20191217161318.31402-37-Jerome.Pouiller@silabs.com>
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
x-ms-office365-filtering-correlation-id: 61fabd90-d3f8-49cb-4329-08d7830c4e7e
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB4208185799B768E2AF9C2D1393500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(66574012)(4326008)(8676002)(86362001)(6486002)(6666004)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(4744005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ND5P8JeLMI8X8Ol8TjkyJW4dltFse2Bu/0KieFDyB5/4FCO+m0f83+S1LLU4t8FMVlLEhCf8AZSxvkgw2wzwjqK2Ub3JbmBPQv6YPkBTfCLe79h4UMTTiGKoHOmB7hMeydqigvKCI9s+Dit0WFBH6c03GZbz6900ADVZO15QapCRZ8nvVQgkt703tsrZxaaBkcmrm3Go7a14OkyQwERPqECF0+gNmoOtZGMKgGLZOUcOGTIS8jxXW3zpVs6o7LU6JsWkJeGX+nMTh6k29GNwI6FibT+r6u730NvaK95hDGgwSjX7a5eOFA4F7anqtyMpx3aAMerWLCl+7MJ98ea4PR1J8mQJX7chyHVyUYguUkfgnvUU7RLe4brhabs2SwMla3bUCUwYqjS9VO7IMDid6w1ElCNp4Iwj7pjo5mOg80oeZ/W27vhdgH0LhQETmv+N
Content-Type: text/plain; charset="utf-8"
Content-ID: <44BBF00B9B784E40BA7A13590F05A826@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61fabd90-d3f8-49cb-4329-08d7830c4e7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:17.8756
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AmDam+g1ibTXobGEfQ1M2c/dUYPXF8Ipp5ryuK6Xw/hICx2PBC8s6/x8MuUWwsUIV4F2wfNAHWzzhQ7RZRsVjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKTWF4
aW11bSByZXF1ZXN0IHRpbWUgKGhvdyBsb25nIGEgcmVxdWVzdCB3YWl0IGZvciB0aGUgbWVkaXVt
KSBpcyBzZXQgaW4KZmlybXdhcmUgdG8gNTEyVFUKClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L3N0YS5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMv
c3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZGNiNDY5M2VjOTgwLi40MmIwZDAxZDg1Y2MgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dm
eC9zdGEuYwpAQCAtMzU5LDcgKzM1OSw3IEBAIHN0YXRpYyBpbnQgd2Z4X3VwZGF0ZV9wbShzdHJ1
Y3Qgd2Z4X3ZpZiAqd3ZpZikKIAl9CiAKIAlpZiAoIXdhaXRfZm9yX2NvbXBsZXRpb25fdGltZW91
dCgmd3ZpZi0+c2V0X3BtX21vZGVfY29tcGxldGUsCi0JCQkJCSBtc2Vjc190b19qaWZmaWVzKDMw
MCkpKQorCQkJCQkgVFVfVE9fSklGRklFUyg1MTIpKSkKIAkJZGV2X3dhcm4od3ZpZi0+d2Rldi0+
ZGV2LAogCQkJICJ0aW1lb3V0IHdoaWxlIHdhaXRpbmcgb2Ygc2V0X3BtX21vZGVfY29tcGxldGVc
biIpOwogCXJldHVybiBoaWZfc2V0X3BtKHd2aWYsICZwbSk7Ci0tIAoyLjI0LjAKCg==
