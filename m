Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C9761B10F1
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 18:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbgDTQDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 12:03:49 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:6055
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728279AbgDTQDm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 12:03:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fwori2fQYLL3zoM2/UWYe/QQ3H6+bfCmk7dVMMwEe/WWfee9Fs6xFxpSJc3l7YlI+vamZaKhqaYrnf3R9epIj3vw8rp90wvVB2YeJRV6wdC5T4H71c+wYvDHBid4gwVaNsZpS/vq5WTS5n+nbWJGncnmmyLcSSKr+G6HEUkQjYw03zouL1zLUkRI0CMWsoxCERYCxwhpgc1czFVo3Or4jdTo5Uvyg34YW2ca/0sbyoQvzedO5P9rZ5HZsnMjmlSIuw+8lXswMZg0wg4KHZc4heZDRTnNjWJhTrlExqDHPhNjRG85LAbzISUzuzTgwaCEP594rg8f46llNm9WC0+xug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XriGrlSX95bXHZj40QDpDZgOB9/D/eBvV6rjUtBDCyc=;
 b=G6A2PY5skh0JqIgZ1tlCBqcjN/jQLrVNZZR3gPXTbIsAKBYRwzv5NFbRh7PSzCBhK7fp4huGCINqBq9moxjtNWSFcSzDOCqcCeeSUdR2dmH7EyQQ5hr5DVwhq0SgX6kbQJalb2vrr/SYW+bp0qBknGBE3xkmq80gBSEYZ4mCnkw6ysyS4qG3/mZjienwQzOnQYr8rW3w3tBBNzwnv4J/B2KWjKzG86LbqDVZm6LhnIqTmq6y9UiSW9wEcafUJAsv6JyxGCGbAebYe+t1717LKhixdDqyFRogo8AesgTnJ/h+VaVHZ/HgFCV5HNgmUtp6d0wTKmvo2dCf6VEH00/oOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XriGrlSX95bXHZj40QDpDZgOB9/D/eBvV6rjUtBDCyc=;
 b=pq9Dki7MDumTXMqQSb4/9tdqv6g14Ml6ak4/mCPsi/WDhl3aexAemkXmrrzKXBOBsW4Quzo9epYs6xdMpGzQrCUvg/Jnfi8Vtpj5CAm9n0U31Mtrxq5Bouc2pyQGKLBfL1kSMqNMDAyzAeR1QnF9uGURXfYEpjy30qCSiFed61k=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHSPR00MB249.namprd11.prod.outlook.com (2603:10b6:300:68::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Mon, 20 Apr
 2020 16:03:39 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.030; Mon, 20 Apr
 2020 16:03:39 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/16] staging: wfx: also fix network parameters for IBSS networks
Date:   Mon, 20 Apr 2020 18:03:00 +0200
Message-Id: <20200420160311.57323-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
References: <20200420160311.57323-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM6PR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:5:74::42) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM6PR07CA0065.namprd07.prod.outlook.com (2603:10b6:5:74::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.26 via Frontend Transport; Mon, 20 Apr 2020 16:03:36 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f9b80fd4-3510-4aa8-e25f-08d7e5446388
X-MS-TrafficTypeDiagnostic: MWHSPR00MB249:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHSPR00MB2493A138C580298C4CE671293D40@MWHSPR00MB249.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(376002)(396003)(39850400004)(346002)(8676002)(7696005)(52116002)(6666004)(4326008)(8936002)(81156014)(66556008)(66476007)(66946007)(36756003)(186003)(54906003)(16526019)(107886003)(478600001)(2906002)(316002)(66574012)(1076003)(86362001)(6486002)(2616005)(5660300002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9GJBJTLQPjjmXmefPgq03BEeSWWhzHP0D/kF5YP/UEFLEaet0XwaOlSJ6uaCp0yRG0fKU9mbxdAUkbexg0pijfi8kt9NGonGCB6tqCaFn8gUIV0DaC65rx8rM71L2MhvvEUoUfA0CexvYS+zaqG45zfBCgRq5Cl+i+uS+W5YPI5aw2ncAgwUPwtb4K1BzYgcIDawn+7DjO/ABt6g/MIEW0kH0V8GJPqlM2YKtG8pVlvi16XEaM7xNX3xfPFFCi/UjXYtvf92mvkQP/74uF5Q+t9zREPAJIlyPxTiOW1VJgqwdU7Ts+ZVL5w9G1HiMlgELZvg4LCU3KDDvHdoVeDM1DJvGt2OG7tyT4SQM5QOzQarb0bMtVJ5mggqueNAVJ5blH4hVyySljGRylDWYHjxaL4+NHNST418CQ+0EiiMbmKlG0d6ZWBEyZB6Ihc/31Aj
X-MS-Exchange-AntiSpam-MessageData: QtAArj4mOJ32biQWs4ZSVQltKg9U9i0E51TGCIoKXvl4g5tVOCNChTO/+RhZqFBHz96CXFxxNIQwx0/Uam2LzEQhXIZvIRLgh0STpaO8VTTgm4rSokjMNsHYwQwejY7Pe/gsOe52NYOCU5L0LYiX9E625glyWzZv7JNsz092OPsbA3O3321TtibAbwt492dbA7ZGzNQYHIGrVY1dQUrDFX5GfegY/RnPjTlSBekv9XPjBSVEXdd7RpoFPeJohn1XwazREAWoUzE544ieRbH2pWLa65XLMyozuoEY2J5V7I+cC/BYTYv/QsPJify4fgto7tuSFFVjgfF0S5iPSgaBdAJDHZadpnMlYRv6hh86JYqI8bQZO36UQXF2qlpTji0bAUqucUtSaCUZ+RXrVni+3s7jMy9qh011mTqIdOaF7ZyZOHis2xyAHWSpoh+X9E7vbtYShkYM7+oCSB4GkfpKgZh513hjMb54WFTFTGlrKkScOAi+8PPyGqrRhDVQjJtfAzAXGgXQB6seVkgPt+qGzwRtm2YfETrorpYMNfduSVjK3AtWZOyiuW26DfFoywr/Szj4pxSpeLJiTLvNKmFQPriKobZn51ABtoyVYePQGX45hN+RDFqZVHSlD+rTNMy6Z5dpoyuMffwRZS7xlVPskyMyzrk6GtWY5G7+Vdc/PM2WFrVsnHwoCkuL9ix0OcQO+Ul+JW/f+LJWu4Uv67guoLNe/DQKgqVuve0h8YU5JsZguSxUKD86UPjdkt+xyJ/QwMcioIem4rEUM19h8qcy99gQtI0km4LhvdXZ9NuvZoHtkYLVgAJpMqaxxWQdE6bNrpVoX1SQJUJzMhdz3x66mu20YXrbgghJLQoZAYVrNHk=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b80fd4-3510-4aa8-e25f-08d7e5446388
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 16:03:39.0164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2/noBMPFCBa1HRG1FQzUtd4DJclCDohta1CGHVtkEGmoxCzROQ/VO5JExQOzrXun4vT40CtKZah4RjqxZ0ry3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB249
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBjb2RlIHNraXAgc29tZSBjb25maWd1cmF0aW9uIGR1cmluZyBqb2luaW5nIGFuIElCU1Mg
bmV0d29yay4KSW5kZWVkLCBpdCBzZWVtcyB0aGF0IHRoaXMgY29uZmlndXJhdGlvbiBpcyBub3Qg
dXNlZCBpbiBJQlNTLiBIb3dldmVyLAppdCB3b3VsZCBiZSBoYXJtbGVzcyB0byBzZXQgdGhlbS4g
SW4gYWRkLCB3ZSB3b3VsZCBwcmVmZXIgdG8ga2VlcAphc3NvY2lhdGlvbiBwcm9jZXNzZXMgZm9y
IGFkLWhvYyBhbmQgbWFuYWdlZCBuZXR3b3JrcyB0aGUgY2xvc2VzdCBhcwpwb3NzaWJsZS4gSXQg
YWxzbyBlbnN1cmVzIHRoZSB2YWx1ZXMgb2YgaW50ZXJuYWwgcGFyYW1ldGVycyBvZiB0aGUKZmly
bXdhcmUuCgpUaGVyZWZvcmUsIGFwcGx5IHRoZW0gdW5jb25kaXRpb25hbGx5LgoKU2lnbmVkLW9m
Zi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0K
IGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgfCAxMSArKysrKy0tLS0tLQogMSBmaWxlIGNoYW5n
ZWQsIDUgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwppbmRleCBhMGM4
NDE2NThhMGIuLmEwYzc3Mzc5MDNiOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9z
dGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCkBAIC00OTQsMTQgKzQ5NCwxMyBA
QCBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwKIAli
c3NfcGFyYW1zLmFpZCA9IGluZm8tPmFpZDsKIAogCWhpZl9zZXRfYXNzb2NpYXRpb25fbW9kZSh3
dmlmLCBpbmZvKTsKKwloaWZfa2VlcF9hbGl2ZV9wZXJpb2Qod3ZpZiwgMCk7CisJaGlmX3NldF9i
c3NfcGFyYW1zKHd2aWYsICZic3NfcGFyYW1zKTsKKwloaWZfc2V0X2JlYWNvbl93YWtldXBfcGVy
aW9kKHd2aWYsIDEsIDEpOworCXdmeF91cGRhdGVfcG0od3ZpZik7CiAKLQlpZiAoIWluZm8tPmli
c3Nfam9pbmVkKSB7CisJaWYgKCFpbmZvLT5pYnNzX2pvaW5lZCkKIAkJd3ZpZi0+c3RhdGUgPSBX
RlhfU1RBVEVfU1RBOwotCQloaWZfa2VlcF9hbGl2ZV9wZXJpb2Qod3ZpZiwgMCk7Ci0JCWhpZl9z
ZXRfYnNzX3BhcmFtcyh3dmlmLCAmYnNzX3BhcmFtcyk7Ci0JCWhpZl9zZXRfYmVhY29uX3dha2V1
cF9wZXJpb2Qod3ZpZiwgMSwgMSk7Ci0JCXdmeF91cGRhdGVfcG0od3ZpZik7Ci0JfQogfQogCiBp
bnQgd2Z4X2pvaW5faWJzcyhzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgc3RydWN0IGllZWU4MDIx
MV92aWYgKnZpZikKLS0gCjIuMjYuMQoK
