Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD681C55B8
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 14:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbgEEMja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 08:39:30 -0400
Received: from mail-eopbgr770049.outbound.protection.outlook.com ([40.107.77.49]:46720
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729093AbgEEMik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 08:38:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWyb7CL50KHAq+4EeevvoOfGBRHgl+PqmFIwiL7HR0VJUEDDRORg4JeEZWvagI19/l8c0/3jYZK51I3OpNV1mCJUXBS6n9JRw0ZeojtRe09lQyP3PwCklR0ECmetIve6kvoZonHMDIhqdHGpmok9QfSGzWo1oFz/ZpUoE19OALHfS7unXLm2W8Z12RcKCXh4lWJdPZsMY8LV2z5hEtoKx1UzxzFtmjkVms0yvw+Hvuqwa5wF/ufv4xoCNGuv7T8dFmud1BXJCMkG2heOxT/O6rsARaYkwrlGuyWOJb1/DKZe05/fx5cz/KrQJ/JOui7cZtYgIuMIQ2oMc0Zzb+c+wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfmbkVlabOhxx6jWwD7ziZZb7yTgpnlVPqiATYhkPLE=;
 b=cWxKP7/ZPVYLbWevzu9T761S7mEYSwDIuWsBQIK5VbnnKB4mhHJ1y74db6BGXFn/C7Z1jWDwD4sVLh+mkh+0FhXyrC/jAd7x1PKBV8OZ15e2I02NSYn1Pz+epRcYkwlcu/WrxBZl2PiDx3oedVLaEIUQjhj6AwINsNJDz9XKBX9IncJLNqrSYm+aoZGwgfPI4Y/eWss0ISHHhTXmgzckCOgpnH/ZJK1l5iuSsUzBtYpYAgG4INNZB3PskakQnkIowz4Jus5FrBFs13rst3NbAEXX0F0b1tGWVk7CFB00rCuC/UIwDpaNUF+gDifn3K9ceivWHbC405yWYQKaKwHKrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hfmbkVlabOhxx6jWwD7ziZZb7yTgpnlVPqiATYhkPLE=;
 b=Y/vzivx/xwkRRVzdhBMF+UsDvLx4He1Nv+ELXCOq3qAywwHavpwPiTBesuVuYxjtPeiz32f5Jms91ip6Wf/P/soJemeWeck/h9pGHnc9G9xg/i2b+6cdkWFJA7fYxtMN0TGppiGwZHYAUBsXh5IKbDp9E8SDAqyhUSca2WsT+uo=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB2046.namprd11.prod.outlook.com (2603:10b6:300:28::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Tue, 5 May
 2020 12:38:35 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 12:38:35 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 11/15] staging: wfx: prefer ARRAY_SIZE instead of a magic number
Date:   Tue,  5 May 2020 14:37:53 +0200
Message-Id: <20200505123757.39506-12-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
References: <20200505123757.39506-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0022.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::27) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by PR3P189CA0022.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 12:38:33 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcfe5599-dd90-4e3b-6b00-08d7f0f13a65
X-MS-TrafficTypeDiagnostic: MWHPR11MB2046:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB20461387773C02F592B71C7293A70@MWHPR11MB2046.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AwtTL6JfCdlC1seKRewbI6hZfzxtK6IM+k7hW+wj2Svn1zeor6VDbShbbbc1b+DPM3TbvPWPny2UzLQubh3ObgDFX98jr/v4JaKwTA3rkt28a60nIRaFSi3XMX+/OYP66p5voMEj5iWKVyxbcGM76dn03VaC4UDVxHTBNeubfX84en6DG5Rs+cp2Aq3hSnSXQALjFmjxEAPo8oDLVif0QjcjStoBoIHUpveKoU+UZ73tUXP5fMoUFrCQdwwmbHx4JgqHqX73L10EK8vb3VTBNgGBLPgFs7bCSHcoAiDhLhnmgfjcTNsLCDUHVeFAbsGxgMYKRqPTBB9P7cISnx90rRXFG4iB+T6veyUYTSSB4PZiozI9h1Ta6uzylViAqc3Sms3DFkYSUcA91dOuXMk7OVAEJw4xYR5fduktEp7tD2Wt7t7UV8g2Y6sPTAR3GU6KrZ6Rmt2zpCCzGNHVSKg9pZUCii1GjwvjA/F6hcNEbUrYN0qMD1QefB7PnvEGFV4YvVZ2Yf2KJqagdtL0iFKP1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(366004)(346002)(39850400004)(136003)(376002)(33430700001)(2906002)(36756003)(52116002)(86362001)(5660300002)(6486002)(1076003)(8676002)(66574012)(8936002)(6666004)(107886003)(2616005)(66476007)(66946007)(16526019)(186003)(66556008)(6512007)(8886007)(478600001)(4326008)(6506007)(33440700001)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: q0wH728LkbUiQtcb4a372gkKTG2dVQIttHyCpjF3dei4cKQHJsDyKh0kBLhxovkAcVSDJ+gW92pnB5e5pjq6YLq0lv6s7qL4d9Q2jcT21/nM5qxb3jQ1kxFmbZEOKC6QE5Fw+aIFezXt1BtV3uM0Zndep48/PFJ7i9Vf7x/qf3FLqXElh16Z5OQfHIaoKGKDvC0CWQUtkcEl1lM7+X/qktEHFRs7vVZdWNV9+ibBBGM+5gfdb/RblM+k+tPUL0tQl7J7IEYMucYACvgUCtBQ6djXJOBmUJMKFT1em5G86aVqOhd5zSPC3qX86vEWRdlVRXhNveYB0OUIyBrysrIZt+GSZZJANcwieBh8zfdq+uJhNBG530xPjPswi+DMXYk0ySkuVe7t3tuDJzsIGsV+hudqxvm/3N5kmDb4b30FMYS8eVfwBn6kd/UfB2QTGbVKapg197QMVqJsLIvOg4ChWzem+JqfOF/1LR7riTKR+beJMRM84j1s4t3JLCLiCpJpxR9dY7Q0okqkiwMgM5Ijbk2cB2kzJg07x3lEVOqtFrN9C54PQjdITikPjjRap3kj39mO4alMny0fG+6s1p6bT2rt/mZFKQuI90n03G6/Lo6HMJ/1FccjkpnL2E0Jy+67UrlV2UpNfTyK2HwZQYx/FXs9yrAv2E31Hnc6ZAiofItrTT1U5RdcCCV2W843nGg0KWj0jkJxhSQSeORamiAkG1dCJE3r/lcjUpHKE4srXcVezqf6p0C9cZtm+LIYemh8JUcNZL+K2Fiwy6p68iGfGc8ew4Mc1TFe+SdgV6bWfRMgs3uuDCMKHucHdXj4QiXRh0BCJdbmWMnui3mQc2bEm1IB5mjCDl3dINHrZRylSu4=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcfe5599-dd90-4e3b-6b00-08d7f0f13a65
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 12:38:35.6522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gwf+2229wXONrrtiNqHyqdx1p6agzT4Sa5S/mVEeME/xVo3Q/bhmTYOQOjSgkEFGCXk8QA60XE6uhQXKL299vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKV2hl
biBwb3NzaWJsZSwgd2UgcHJlZmVyIHRvIHVzZSB0aGUgbWFjcm8gQVJSQVlfU0laRSByYXRoZXIg
dGhhbiBoYXJkCmNvZGluZyB0aGUgbnVtYmVyIG9mIGVsZW1lbnRzLgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgOCArKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQg
aW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L2RhdGFfdHguYyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCmluZGV4IDMw
YWE4YzI2N2NkMC4uODNhOTI1NmYwOWJmIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2RhdGFfdHguYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguYwpAQCAtMTY2LDEz
ICsxNjYsMTMgQEAgc3RhdGljIGludCB3ZnhfdHhfcG9saWN5X3VwbG9hZChzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZikKIAogCWRvIHsKIAkJc3Bpbl9sb2NrX2JoKCZ3dmlmLT50eF9wb2xpY3lfY2FjaGUu
bG9jayk7Ci0JCWZvciAoaSA9IDA7IGkgPCBISUZfVFhfUkVUUllfUE9MSUNZX01BWDsgKytpKSB7
CisJCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHd2aWYtPnR4X3BvbGljeV9jYWNoZS5jYWNo
ZSk7ICsraSkgewogCQkJaXNfdXNlZCA9IG1lbXpjbXAocG9saWNpZXNbaV0ucmF0ZXMsCiAJCQkJ
CSAgc2l6ZW9mKHBvbGljaWVzW2ldLnJhdGVzKSk7CiAJCQlpZiAoIXBvbGljaWVzW2ldLnVwbG9h
ZGVkICYmIGlzX3VzZWQpCiAJCQkJYnJlYWs7CiAJCX0KLQkJaWYgKGkgPCBISUZfVFhfUkVUUllf
UE9MSUNZX01BWCkgeworCQlpZiAoaSA8IEFSUkFZX1NJWkUod3ZpZi0+dHhfcG9saWN5X2NhY2hl
LmNhY2hlKSkgewogCQkJcG9saWNpZXNbaV0udXBsb2FkZWQgPSB0cnVlOwogCQkJbWVtY3B5KHRt
cF9yYXRlcywgcG9saWNpZXNbaV0ucmF0ZXMsIHNpemVvZih0bXBfcmF0ZXMpKTsKIAkJCXNwaW5f
dW5sb2NrX2JoKCZ3dmlmLT50eF9wb2xpY3lfY2FjaGUubG9jayk7CkBAIC0xODAsNyArMTgwLDcg
QEAgc3RhdGljIGludCB3ZnhfdHhfcG9saWN5X3VwbG9hZChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZikK
IAkJfSBlbHNlIHsKIAkJCXNwaW5fdW5sb2NrX2JoKCZ3dmlmLT50eF9wb2xpY3lfY2FjaGUubG9j
ayk7CiAJCX0KLQl9IHdoaWxlIChpIDwgSElGX1RYX1JFVFJZX1BPTElDWV9NQVgpOworCX0gd2hp
bGUgKGkgPCBBUlJBWV9TSVpFKHd2aWYtPnR4X3BvbGljeV9jYWNoZS5jYWNoZSkpOwogCXJldHVy
biAwOwogfQogCkBAIC0yMDQsNyArMjA0LDcgQEAgdm9pZCB3ZnhfdHhfcG9saWN5X2luaXQoc3Ry
dWN0IHdmeF92aWYgKnd2aWYpCiAJSU5JVF9MSVNUX0hFQUQoJmNhY2hlLT51c2VkKTsKIAlJTklU
X0xJU1RfSEVBRCgmY2FjaGUtPmZyZWUpOwogCi0JZm9yIChpID0gMDsgaSA8IEhJRl9UWF9SRVRS
WV9QT0xJQ1lfTUFYOyArK2kpCisJZm9yIChpID0gMDsgaSA8IEFSUkFZX1NJWkUoY2FjaGUtPmNh
Y2hlKTsgKytpKQogCQlsaXN0X2FkZCgmY2FjaGUtPmNhY2hlW2ldLmxpbmssICZjYWNoZS0+ZnJl
ZSk7CiB9CiAKLS0gCjIuMjYuMQoK
