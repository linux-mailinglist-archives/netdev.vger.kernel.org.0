Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F891AAD85
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415420AbgDOQOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:14:42 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:6037
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410241AbgDOQMp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndF1JfnpJbO/0LaHBYgaBWTsukZ1YivN0LbyVbPYvBann3LTTP2H1PCwN0ow0rkw1MS3uN+TIpYuEkQD3Efao5K1eYdl+uDKXpaEXb73+xdYH0gLWNCg1BaMluV6QXQgxTvHfBgqS4Q83dxajbUzO7L+nxyDLxsZXfL5rxWwWMw237U1xuXf58/bfRI8/cJ/FEFGPlFPMuPLEZl6yzqQPlQLn2nOHpoR+nshTCn2fW0PEkxIfZSp35S8hT7NW+XsV6KFd/EDU5ERZ3aG/y2pXvt/sXnbkMEf0W1+WEpmxbo7OFeTNWnEETndA+wjU4M5CryJcGElxhaeW4+uLcCotw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nU6sNOskPMXTlqA3I0Fivrf0FKMczAep9cVTArvKfOU=;
 b=Ku7j/bWfbKZkbPbnsPEXuo3wyaakQuVlLhCjFKgcMPcMHKhmNIPgFkFmL0Ole9MfYudIzJjASVpI/isuVqfxCKfTMwk/W1vAv25aMKn1CrP5yJ9BMd+IaZB82A96EHEP3kXdQC3/2RGjaLC5dWdknKRx/tipHmFmm0w3SyojbxLpkllO18xeRhqGOv70DA1R2gCcW5aX7l576HeCtI3uepbWvAMbOyn50YTqvKPcC2c30J1atx/VXssJy2Ks/6MXdTl2MWpOpUDrYbgVWZlH5/bLGI9feotTFp6umL4TL6V8O6k+lnyLWHoQox5jfue9OhAx0LRNGoL1jn7H8qTTQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nU6sNOskPMXTlqA3I0Fivrf0FKMczAep9cVTArvKfOU=;
 b=XFZBFdOG+b9fXIG8kRvoAQMQ/LnpvHYoxiJw4Yh8pIkrXKZi7qKAHza8AA9cewCrkYi8KLPacfNXpPS6j9a1z5edF30ZJxgH1P8Kj4XwojrM1THNyMuzjXZypfNa4Rqb+gRP9zdQaq0d6co8i2KbftLD0YkO1qcZcz+fiuqSybI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 16:12:40 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:39 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/20] staging: wfx: drop useless wfx_fwd_probe_req()
Date:   Wed, 15 Apr 2020 18:11:38 +0200
Message-Id: <20200415161147.69738-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
References: <20200415161147.69738-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR1PR01CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:102::40) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:38 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6db4add9-f980-415e-6884-08d7e157d1ee
X-MS-TrafficTypeDiagnostic: MWHPR11MB1599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB15997B4F093A00472D90382C93DB0@MWHPR11MB1599.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:454;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(396003)(346002)(366004)(39850400004)(136003)(4326008)(66476007)(107886003)(81156014)(86362001)(8936002)(2616005)(6512007)(6486002)(316002)(52116002)(66556008)(66946007)(6506007)(8886007)(2906002)(1076003)(36756003)(66574012)(5660300002)(54906003)(478600001)(16526019)(8676002)(186003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xzva1H4bY0AVbYCJ6GhpMnLhSa4Flltz1Gq0iBGgLD+fHn6izER94j1zyMuy69cDnlV+qhE4nSvHDlPXfQXIVLoii1rtHdJMDRlI8iO1FvbTM+HdRfzKC3+qEpvLekYZGqIotquU64hT4mk6SxOBgC0rbzV52sRMWLNzDplB19uCBDPdjLiRYXVu0teYqaHeL8HBO4UpC2iIz9ltPDWA2TQb3y4olQhAPe/kOggszX69+cHK/bHwq3pGqDJI0Ms9a23vf9oC+PlfdE5j96lVAUYZ1hKm2H6Xy7GdyplaAPPnK4W3Z0ZCqWtWIKC3qqyk8z6pEDTmYpRRnK9tz6cM5vxGj89yN9472jIUAjTee3HqHnkkZ+x2SW1h+jGJ1QbQBgAPuLqNx54y3H/gC2UPpU4RYcWJlYx9WOCr6tljrrUngSaT08k43Fc7Y+a/OSSO
X-MS-Exchange-AntiSpam-MessageData: zOY6d8KMU4yzr8kbCuWIF2rQAC6QjvC834oyQJXAfuUXpL+xkZCPqKVJDjsfAmSMNNz1VvmxoOojDlSYml7o8BOKNJOC2Fvj5+bXIqtpobgO9kGpNKzj/ur41+VnrJC16D/uNN8Ko95H+w6+TZA6xuY/dhZWgOooiaAlcbM7HJHSTAR0DbjkS5xciR5aCIyfDoqPtBU/xoFur5Msb5lDZQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6db4add9-f980-415e-6884-08d7e157d1ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:39.8270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HSrEAxeCthlfTUz8M8hQ9w4FzOxk0ogD4sj8fv6igRPQpzx8gzqyh0SFXW0JJLJy1UWbszj3ld8g5VGWahoKEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKd2Z4
X2Z3ZF9wcm9iZV9yZXEoKSBpcyBhIGZ1bmN0aW9uIG9mIHR3byBsaW5lcyBjYWxsZWQgZnJvbSBv
bmx5IG9uZQpwbGFjZS4gSW4gb3JkZXIgdG8gdW5pZm9ybWl6ZSBhbGwgZmlsdGVyaW5nIGZ1bmN0
aW9ucywgZHJvcAp3ZnhfZndkX3Byb2JlX3JlcSgpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUg
UG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2lu
Zy93Zngvc3RhLmMgfCAxNCArKysrKy0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEu
aCB8ICAxIC0KIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNlcnRpb25zKCspLCAxMCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwppbmRleCBiNzg1YjFiN2Q1ODMuLjhkMjM2NWEyZTM1YiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCkBAIC0xMTMsMTMgKzExMyw2IEBAIHZvaWQgd2Z4X2NxbV9ic3Nsb3NzX3NtKHN0cnVjdCB3
ZnhfdmlmICp3dmlmLCBpbnQgaW5pdCwgaW50IGdvb2QsIGludCBiYWQpCiAJbXV0ZXhfdW5sb2Nr
KCZ3dmlmLT5ic3NfbG9zc19sb2NrKTsKIH0KIAotaW50IHdmeF9md2RfcHJvYmVfcmVxKHN0cnVj
dCB3ZnhfdmlmICp3dmlmLCBib29sIGVuYWJsZSkKLXsKLQl3dmlmLT5md2RfcHJvYmVfcmVxID0g
ZW5hYmxlOwotCXJldHVybiBoaWZfc2V0X3J4X2ZpbHRlcih3dmlmLCB3dmlmLT5maWx0ZXJfYnNz
aWQsCi0JCQkJIHd2aWYtPmZ3ZF9wcm9iZV9yZXEpOwotfQotCiB2b2lkIHdmeF91cGRhdGVfZmls
dGVyaW5nKHN0cnVjdCB3ZnhfdmlmICp3dmlmKQogewogCWludCBpOwpAQCAtMjQ5LDkgKzI0Miwx
MiBAQCB2b2lkIHdmeF9jb25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAog
CQl9CiAKIAkJaWYgKCp0b3RhbF9mbGFncyAmIEZJRl9QUk9CRV9SRVEpCi0JCQl3ZnhfZndkX3By
b2JlX3JlcSh3dmlmLCB0cnVlKTsKKwkJCXd2aWYtPmZ3ZF9wcm9iZV9yZXEgPSB0cnVlOwogCQll
bHNlCi0JCQl3ZnhfZndkX3Byb2JlX3JlcSh3dmlmLCBmYWxzZSk7CisJCQl3dmlmLT5md2RfcHJv
YmVfcmVxID0gZmFsc2U7CisJCWhpZl9zZXRfcnhfZmlsdGVyKHd2aWYsIHd2aWYtPmZpbHRlcl9i
c3NpZCwKKwkJCQkgIHd2aWYtPmZ3ZF9wcm9iZV9yZXEpOworCiAJCW11dGV4X3VubG9jaygmd3Zp
Zi0+c2Nhbl9sb2NrKTsKIAl9CiAJbXV0ZXhfdW5sb2NrKCZ3ZGV2LT5jb25mX211dGV4KTsKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4
L3N0YS5oCmluZGV4IDhkNzZmYmE1ZjUwNC4uYTkwZWFmNTA0M2E4IDEwMDY0NAotLS0gYS9kcml2
ZXJzL3N0YWdpbmcvd2Z4L3N0YS5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmgKQEAg
LTg4LDcgKzg4LDYgQEAgdm9pZCB3Znhfc3VzcGVuZF9yZXN1bWVfbWMoc3RydWN0IHdmeF92aWYg
Knd2aWYsIGVudW0gc3RhX25vdGlmeV9jbWQgY21kKTsKIAogLy8gT3RoZXIgSGVscGVycwogdm9p
ZCB3ZnhfY3FtX2Jzc2xvc3Nfc20oc3RydWN0IHdmeF92aWYgKnd2aWYsIGludCBpbml0LCBpbnQg
Z29vZCwgaW50IGJhZCk7Ci1pbnQgd2Z4X2Z3ZF9wcm9iZV9yZXEoc3RydWN0IHdmeF92aWYgKnd2
aWYsIGJvb2wgZW5hYmxlKTsKIHUzMiB3ZnhfcmF0ZV9tYXNrX3RvX2h3KHN0cnVjdCB3ZnhfZGV2
ICp3ZGV2LCB1MzIgcmF0ZXMpOwogCiAjZW5kaWYgLyogV0ZYX1NUQV9IICovCi0tIAoyLjI1LjEK
Cg==
