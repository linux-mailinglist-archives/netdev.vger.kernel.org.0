Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7041AAD22
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410234AbgDOQMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:12:31 -0400
Received: from mail-eopbgr700077.outbound.protection.outlook.com ([40.107.70.77]:38433
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415192AbgDOQMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FeinoMT7uEA8YyflQJhJy5jRcWOwow6j728t737yiX6KhDs4YW3G9IEQJeEHqE9Fq7CGtamd7DbbvTIlBfvGsoi7tJ1d9QbJIPaE0CrbqxlkgudGHnJxMyxWu0RBQ78FrfWEJsRpijyyLY+2cDV+03yVzybfkC455UIDTyhE8InqHkJSv8TSMWJhw6iz0b0JsdIUlj36ry1RfCkqPtrweTsM/znpk7mxvQqeGjhR1TXOLPLQ/XIID7Mfb5axDqlrtFIggiisFEBe1dBVDGRjpo4OhXLZQ1kS4J1/OfiU4aODT/X/sGVMMuc4s+TYeLWNyukN6biVZVdyk7Vub284PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g62HYkkGU/coH6qCoMkXIzdcdD18sCGRgbclU1snP4E=;
 b=R3huz/zR8+bt1jCzYNbGyjkX2ep+5RJWqUhQ0fgFPujPIwhZirzBzdfbF4U72ZRopVlPlYiberqv6kfW4vwb8bZDwIj/SZiXKuYzaNlW1WRxxVTKoUPav0JcGOLSKtX7RhUcli0QlB23U8tCquLYpcombDYwRDtrEWfFuMBVNJt2adFZkbnx+WEXtGGUWrgyeRtRmluYU9owDivgtTaw31FN8dOiF4CSCFHcp60nYja30iWb1o8uevViQMfS0laFtuPYxYHPlVLgVXHDRjbkKh7XO9Yzb6N2cqNXHmJGYEUwkAP0o7fXRHV1sn0XXgtjy+7KXiUOoDkg8YiCVv5ZDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g62HYkkGU/coH6qCoMkXIzdcdD18sCGRgbclU1snP4E=;
 b=kWfXi4xgvHLsaLYQF63etnGpdAzIpLWW5z5sETSj8/B1cn/ZaUMZQ6Kdje1LyzGALUI/Xhyj2uFqLNLUqC45fqv2lyKfoJ/7RlPyWl2vkwqEER2LRTG6Pe1jZO8oZ22nhEg99UGsnnksCa44SatIU2M7J1GOkw1Qu2DH+BFHXuQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1408.namprd11.prod.outlook.com (2603:10b6:300:24::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25; Wed, 15 Apr
 2020 16:12:15 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:15 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/20] staging: wfx: simplify wfx_update_filtering()
Date:   Wed, 15 Apr 2020 18:11:29 +0200
Message-Id: <20200415161147.69738-3-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:13 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca8e450f-87b0-45cb-34a3-08d7e157c301
X-MS-TrafficTypeDiagnostic: MWHPR11MB1408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB14089BCC6097C26A04C94A1A93DB0@MWHPR11MB1408.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(396003)(376002)(346002)(39850400004)(366004)(8886007)(8936002)(5660300002)(2906002)(6666004)(86362001)(8676002)(478600001)(81156014)(66574012)(1076003)(4326008)(52116002)(316002)(54906003)(107886003)(186003)(16526019)(66556008)(66476007)(36756003)(2616005)(6512007)(6486002)(6506007)(66946007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F3kt4/H7pIyA2iGASpp2DVAa0k/DJJGBSVIhuyltXOl0JfomK90OmK4hydVoZ1LFyUPkJUxlrT4O58LomOgiF9xSfvCp/jkDdQhsRCU0YpSQ8oiJNzIVqzfJCLgwFsCuJL3lM5ErtEN0gD0OAFHD1ovgQgdX69S/zNQSx7GlJgIVsOwD+EjfO06I16EPC0+sFaHxD7eaWmyVjz2FfgLFAhYgI6604Nf401ut0SeRgsZiDbBh346PpyHiJALZMS3KM9D2c8xhTrDuPl9K7/nCY10BfHwsxvaCs83yYK3GgIUE+4TPsFDNAuEl0hs7crIMR+B5ULsV0QbmjUeXKHiRYNtJRmQRqM2aaH83oLFB90KrirzoS/rfB7OIPCjOpdyLmfwOp7GuwOlcfSKuvE7IY1xR5LNTkF+XbdTX1FhzTtRDSqhyG8SBGtU+ZVOaEgVY
X-MS-Exchange-AntiSpam-MessageData: KHDp3y6EJb3akgI8kZ8HqZ9nnwcvfXCkt2BS23bHgcS5UdAUjQugEOgVDvraYTbpBfi5DwsWK95ffygiTov7BLpC5H+DBAm3bZa6HXbXP8iNgJIS7SgbNHKeap445Is/gxx+yi6FO9DlnTvS12oNeMhy3Hdp1+EVOLc9PB3fyggifzhSrXE594t2YtfJSTm9ocqkZXSpDTz4JOyTT3t7ig==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca8e450f-87b0-45cb-34a3-08d7e157c301
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:14.9203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uLXjjrwHfbA3dAVwjRdka7hiBSD+Ms3LZxSit0kWr/HTDr7kIPFpmB/Vmkhkuk2N2kUson6lfGuRdfLoAdUKUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW5s
aW5lIHdmeF9zZXRfbWNhc3RfZmlsdGVyKCkgaW50byB3ZnhfdXBkYXRlX2ZpbHRlcmluZygpIGFu
ZCByZW1vdmUKdXNlbGVzcyBpbnRlcm1lZGlhdGUgdmFyaWFibGVzLgoKU2lnbmVkLW9mZi1ieTog
SsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMgfCA2OSArKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCA0NCBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYwppbmRleCBjYjlkMTQ0NzE3NDUuLjE0ZTJmMTA2YjA0MiAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0
YS5jCkBAIC0xMjAsMzQgKzEyMCw5IEBAIGludCB3ZnhfZndkX3Byb2JlX3JlcShzdHJ1Y3Qgd2Z4
X3ZpZiAqd3ZpZiwgYm9vbCBlbmFibGUpCiAJCQkJIHd2aWYtPmZ3ZF9wcm9iZV9yZXEpOwogfQog
Ci1zdGF0aWMgaW50IHdmeF9zZXRfbWNhc3RfZmlsdGVyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLAot
CQkJCSAgICBzdHJ1Y3Qgd2Z4X2dycF9hZGRyX3RhYmxlICpmcCkKLXsKLQlpbnQgaTsKLQotCS8v
IFRlbXBvcmFyeSB3b3JrYXJvdW5kIGZvciBmaWx0ZXJzCi0JcmV0dXJuIGhpZl9zZXRfZGF0YV9m
aWx0ZXJpbmcod3ZpZiwgZmFsc2UsIHRydWUpOwotCi0JaWYgKCFmcC0+ZW5hYmxlKQotCQlyZXR1
cm4gaGlmX3NldF9kYXRhX2ZpbHRlcmluZyh3dmlmLCBmYWxzZSwgdHJ1ZSk7Ci0KLQlmb3IgKGkg
PSAwOyBpIDwgZnAtPm51bV9hZGRyZXNzZXM7IGkrKykKLQkJaGlmX3NldF9tYWNfYWRkcl9jb25k
aXRpb24od3ZpZiwgaSwgZnAtPmFkZHJlc3NfbGlzdFtpXSk7Ci0JaGlmX3NldF91Y19tY19iY19j
b25kaXRpb24od3ZpZiwgMCwKLQkJCQkgICBISUZfRklMVEVSX1VOSUNBU1QgfCBISUZfRklMVEVS
X0JST0FEQ0FTVCk7Ci0JaGlmX3NldF9jb25maWdfZGF0YV9maWx0ZXIod3ZpZiwgdHJ1ZSwgMCwg
QklUKDEpLAotCQkJCSAgIEJJVChmcC0+bnVtX2FkZHJlc3NlcykgLSAxKTsKLQloaWZfc2V0X2Rh
dGFfZmlsdGVyaW5nKHd2aWYsIHRydWUsIHRydWUpOwotCi0JcmV0dXJuIDA7Ci19Ci0KIHZvaWQg
d2Z4X3VwZGF0ZV9maWx0ZXJpbmcoc3RydWN0IHdmeF92aWYgKnd2aWYpCiB7Ci0JaW50IHJldDsK
LQlpbnQgYmZfZW5hYmxlOwotCWludCBiZl9jb3VudDsKLQlpbnQgbl9maWx0ZXJfaWVzOworCWlu
dCBpOwogCWNvbnN0IHN0cnVjdCBoaWZfaWVfdGFibGVfZW50cnkgZmlsdGVyX2llc1tdID0gewog
CQl7CiAJCQkuaWVfaWQgICAgICAgID0gV0xBTl9FSURfVkVORE9SX1NQRUNJRklDLApAQCAtMTY4
LDI5ICsxNDMsMzUgQEAgdm9pZCB3ZnhfdXBkYXRlX2ZpbHRlcmluZyhzdHJ1Y3Qgd2Z4X3ZpZiAq
d3ZpZikKIAkJfQogCX07CiAKKwloaWZfc2V0X3J4X2ZpbHRlcih3dmlmLCB3dmlmLT5maWx0ZXJf
YnNzaWQsIHd2aWYtPmZ3ZF9wcm9iZV9yZXEpOwogCWlmICh3dmlmLT5kaXNhYmxlX2JlYWNvbl9m
aWx0ZXIpIHsKLQkJYmZfZW5hYmxlID0gMDsKLQkJYmZfY291bnQgPSAxOwotCQluX2ZpbHRlcl9p
ZXMgPSAwOworCQloaWZfc2V0X2JlYWNvbl9maWx0ZXJfdGFibGUod3ZpZiwgMCwgTlVMTCk7CisJ
CWhpZl9iZWFjb25fZmlsdGVyX2NvbnRyb2wod3ZpZiwgMCwgMSk7CiAJfSBlbHNlIGlmICh3dmlm
LT52aWYtPnR5cGUgIT0gTkw4MDIxMV9JRlRZUEVfU1RBVElPTikgewotCQliZl9lbmFibGUgPSBI
SUZfQkVBQ09OX0ZJTFRFUl9FTkFCTEUgfCBISUZfQkVBQ09OX0ZJTFRFUl9BVVRPX0VSUDsKLQkJ
YmZfY291bnQgPSAwOwotCQluX2ZpbHRlcl9pZXMgPSAyOworCQloaWZfc2V0X2JlYWNvbl9maWx0
ZXJfdGFibGUod3ZpZiwgMiwgZmlsdGVyX2llcyk7CisJCWhpZl9iZWFjb25fZmlsdGVyX2NvbnRy
b2wod3ZpZiwgSElGX0JFQUNPTl9GSUxURVJfRU5BQkxFIHwKKwkJCQkJCUhJRl9CRUFDT05fRklM
VEVSX0FVVE9fRVJQLCAwKTsKIAl9IGVsc2UgewotCQliZl9lbmFibGUgPSBISUZfQkVBQ09OX0ZJ
TFRFUl9FTkFCTEU7Ci0JCWJmX2NvdW50ID0gMDsKLQkJbl9maWx0ZXJfaWVzID0gMzsKKwkJaGlm
X3NldF9iZWFjb25fZmlsdGVyX3RhYmxlKHd2aWYsIDMsIGZpbHRlcl9pZXMpOworCQloaWZfYmVh
Y29uX2ZpbHRlcl9jb250cm9sKHd2aWYsIEhJRl9CRUFDT05fRklMVEVSX0VOQUJMRSwgMCk7CiAJ
fQogCi0JcmV0ID0gaGlmX3NldF9yeF9maWx0ZXIod3ZpZiwgd3ZpZi0+ZmlsdGVyX2Jzc2lkLCB3
dmlmLT5md2RfcHJvYmVfcmVxKTsKLQlpZiAoIXJldCkKLQkJcmV0ID0gaGlmX3NldF9iZWFjb25f
ZmlsdGVyX3RhYmxlKHd2aWYsIG5fZmlsdGVyX2llcywgZmlsdGVyX2llcyk7Ci0JaWYgKCFyZXQp
Ci0JCXJldCA9IGhpZl9iZWFjb25fZmlsdGVyX2NvbnRyb2wod3ZpZiwgYmZfZW5hYmxlLCBiZl9j
b3VudCk7Ci0JaWYgKCFyZXQpCi0JCXJldCA9IHdmeF9zZXRfbWNhc3RfZmlsdGVyKHd2aWYsICZ3
dmlmLT5tY2FzdF9maWx0ZXIpOwotCWlmIChyZXQpCi0JCWRldl9lcnIod3ZpZi0+d2Rldi0+ZGV2
LCAidXBkYXRlIGZpbHRlcmluZyBmYWlsZWQ6ICVkXG4iLCByZXQpOworCS8vIFRlbXBvcmFyeSB3
b3JrYXJvdW5kIGZvciBmaWx0ZXJzCisJaGlmX3NldF9kYXRhX2ZpbHRlcmluZyh3dmlmLCBmYWxz
ZSwgdHJ1ZSk7CisJcmV0dXJuOworCisJaWYgKCF3dmlmLT5tY2FzdF9maWx0ZXIuZW5hYmxlKSB7
CisJCWhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgZmFsc2UsIHRydWUpOworCQlyZXR1cm47
CisJfQorCWZvciAoaSA9IDA7IGkgPCB3dmlmLT5tY2FzdF9maWx0ZXIubnVtX2FkZHJlc3Nlczsg
aSsrKQorCQloaWZfc2V0X21hY19hZGRyX2NvbmRpdGlvbih3dmlmLCBpLAorCQkJCQkgICB3dmlm
LT5tY2FzdF9maWx0ZXIuYWRkcmVzc19saXN0W2ldKTsKKwloaWZfc2V0X3VjX21jX2JjX2NvbmRp
dGlvbih3dmlmLCAwLAorCQkJCSAgIEhJRl9GSUxURVJfVU5JQ0FTVCB8IEhJRl9GSUxURVJfQlJP
QURDQVNUKTsKKwloaWZfc2V0X2NvbmZpZ19kYXRhX2ZpbHRlcih3dmlmLCB0cnVlLCAwLCBCSVQo
MSksCisJCQkJICAgQklUKHd2aWYtPm1jYXN0X2ZpbHRlci5udW1fYWRkcmVzc2VzKSAtIDEpOwor
CWhpZl9zZXRfZGF0YV9maWx0ZXJpbmcod3ZpZiwgdHJ1ZSwgdHJ1ZSk7CiB9CiAKIHN0YXRpYyB2
b2lkIHdmeF91cGRhdGVfZmlsdGVyaW5nX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0ICp3b3JrKQot
LSAKMi4yNS4xCgo=
