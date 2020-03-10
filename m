Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233CB17F4BD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgCJKOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:14:19 -0400
Received: from mail-bn8nam12on2076.outbound.protection.outlook.com ([40.107.237.76]:6032
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726244AbgCJKOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:14:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYoiHT48E4du/BrT8lYEdxzKGFw4hyl2foj0qdpRIFAJSPnershKdPqq0iev6KNwfimVFPjC2gvK/YJ532vOjsmCZT5aYr+/VC5HFpZdJWSODgStrNWh4xo1awstN7oo1EMqxUnAEvIWdhF4rLlCI8gDAzF9ww0+55oaQxEDM6T8qO2A2SmocfUTCwBtEH0BUUKDdPfM+0DSeaAAMvIC/F6+bAuoBEpONpBKkly55KuUaTcmJ6cgluel3IDLNqkD4X5Kz1AiT6xghOQd7O47SE0jaNUiSLyaa/Hwh6eSM33UzCwCsjsV9TFIbd7RGzgJYNuE/HkXzTFMJKwZsEIc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTjzoDyxVLJyP4o40xD6qa7pM8dNY2+OGu5walqarXA=;
 b=A8ceaMRsfeCpTFncIO5s8nA90qbdxizD8LiABR6ykVXhVgYvlX3tCCgdf+Y4/7pUGAGEplTxwyxejrIJHz4v987KnjnS8uOki4xoWooNqNiST5snN6Q3gJJusezbVVaWYX+xkj43p/yKwdoZlMHffZSzbeObMz2SZkT3TUW7z/JokeVWRuKSj4MUGctmzt8Cnl+6yjQ8yeUiDXxifbo9vS4lwNDSkMMMf02bLDP3abG93EtVgoCJn8C0QbQrqFGMOrq8kEz+mZS6+xE0BrkQquxhQZcHOyXWCotWwZeysAbV4OXPCaNCkqo90cZsuFv2FPsMcjz2nvTg5vv5mZ1SsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTjzoDyxVLJyP4o40xD6qa7pM8dNY2+OGu5walqarXA=;
 b=HRZDLDiSqXsMyqqNPuwyQKmbCdNYgzwFVcq8m6x1F3Ny/wNhRMB2dMnnsU9jiwXE215P24TlJ9L+us9jxrgmj858JoOEd9dNR0AzkUH/c0bpvCqZFmAt6vdlF3WbulfudkNtTIs3KByFDbIZ9LYIoutxF0GCogjLIhWlXSWS8Ro=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB3615.namprd11.prod.outlook.com (2603:10b6:208:ec::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Tue, 10 Mar
 2020 10:14:16 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 10:14:16 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 2/5] staging: wfx: fix lines ending with a comma instead of a semicolon
Date:   Tue, 10 Mar 2020 11:13:53 +0100
Message-Id: <20200310101356.182818-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
References: <20200310101356.182818-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::24) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1c::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Tue, 10 Mar 2020 10:14:15 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c64ec05e-7e0d-4ace-b2b6-08d7c4dbc9ee
X-MS-TrafficTypeDiagnostic: MN2PR11MB3615:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB36155D8773CC47C589392C3493FF0@MN2PR11MB3615.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(39850400004)(136003)(366004)(376002)(396003)(346002)(189003)(199004)(6666004)(52116002)(5660300002)(2616005)(86362001)(316002)(956004)(36756003)(478600001)(7696005)(8936002)(54906003)(4326008)(16526019)(186003)(26005)(6486002)(66946007)(8676002)(1076003)(81166006)(2906002)(66476007)(81156014)(66556008)(107886003);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB3615;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +6iLNYSWGhbyxj8fIF5UeLQgQm/ZxtjhvxCua6TCawap3zjA2K7SJvuC3zh8MorP3ZOpSJvcAFszGpnS+N8mZLnzSpWy3Qpwt4NU9Sv6QO0W21ZSvqC6iBOAqVH01Wbex5kv+bUQPGRWENxSo55io5Sao0KOrZmzt7nnL22ltDwykiLe+PLOP6RMIzbDfSnsCIn5CHWaKf/rYj144ri4+7LTJf7uFQhoaQFJMDu+IClVb2nOGenUL3l31r9hz8tERepYSTIC61q0ujFicusrmOLDi9RPbNlG5Wm9mtgOX6UZd8Jxv9i6Ru0vHQQsbdZsiF4BbwuOFcsjyA/HGbDDdrXymyu4zlHBCX17SyDRrmRj7Rp9WSgYnvvwckx0EhpEX5lpWpZ3sJXRISYYcbR3A0I9W+HtU0kltDRdejhOQ6Z4atubyTmOomAvzVQHDmKm
X-MS-Exchange-AntiSpam-MessageData: HTCrFGwAsxl8ob06DuzTpFucht9O5Arw8vsYwwFJdWDbddW51MjLDNFUHYkAnoOPHBT3Sd5Us/K/nQWW33BaPfwwvqGWjo8kX2pAht4nCKPGjEK+RCNQOz0IL9oMTZnQC/dysP1puXkhh9ji++Gs0g==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64ec05e-7e0d-4ace-b2b6-08d7c4dbc9ee
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 10:14:16.2329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dny66N5jkEum8u8l1b/3Ltcu/uUvhqYN++KxXxiDJhEKu7oXH5JbqUNBy3wmW9SCvnyeWKT+lHlqM3efl9uXPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3615
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKT2J2
aW91c2x5IGludHJvZHVjZWQgYnkgbWlzdGFrZS4KCkZpeGVzOiAwOTc3OTI3NmYxYmEgKCJzdGFn
aW5nOiB3Zng6IHNpbXBsaWZ5IGhpZl9zdGFydCgpIHVzYWdlIikKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX3R4LmMgfCA2ICsrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHguYwppbmRleCA3YjczMmM1MzFh
NzQuLjdhNTZlNDViY2RhYSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHgu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eC5jCkBAIC00MjgsOSArNDI4LDkgQEAg
aW50IGhpZl9zdGFydChzdHJ1Y3Qgd2Z4X3ZpZiAqd3ZpZiwgY29uc3Qgc3RydWN0IGllZWU4MDIx
MV9ic3NfY29uZiAqY29uZiwKIAlzdHJ1Y3QgaGlmX21zZyAqaGlmOwogCXN0cnVjdCBoaWZfcmVx
X3N0YXJ0ICpib2R5ID0gd2Z4X2FsbG9jX2hpZihzaXplb2YoKmJvZHkpLCAmaGlmKTsKIAotCWJv
ZHktPmR0aW1fcGVyaW9kID0gY29uZi0+ZHRpbV9wZXJpb2QsCi0JYm9keS0+c2hvcnRfcHJlYW1i
bGUgPSBjb25mLT51c2Vfc2hvcnRfcHJlYW1ibGUsCi0JYm9keS0+Y2hhbm5lbF9udW1iZXIgPSBj
cHVfdG9fbGUxNihjaGFubmVsLT5od192YWx1ZSksCisJYm9keS0+ZHRpbV9wZXJpb2QgPSBjb25m
LT5kdGltX3BlcmlvZDsKKwlib2R5LT5zaG9ydF9wcmVhbWJsZSA9IGNvbmYtPnVzZV9zaG9ydF9w
cmVhbWJsZTsKKwlib2R5LT5jaGFubmVsX251bWJlciA9IGNwdV90b19sZTE2KGNoYW5uZWwtPmh3
X3ZhbHVlKTsKIAlib2R5LT5iZWFjb25faW50ZXJ2YWwgPSBjcHVfdG9fbGUzMihjb25mLT5iZWFj
b25faW50KTsKIAlib2R5LT5iYXNpY19yYXRlX3NldCA9CiAJCWNwdV90b19sZTMyKHdmeF9yYXRl
X21hc2tfdG9faHcod3ZpZi0+d2RldiwgY29uZi0+YmFzaWNfcmF0ZXMpKTsKLS0gCjIuMjUuMQoK
