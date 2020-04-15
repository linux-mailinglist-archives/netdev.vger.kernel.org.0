Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7366D1AAD29
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415258AbgDOQNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:13:00 -0400
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:4064
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1415229AbgDOQM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRWCcrVRL9gEZO84EI88GPd9wnZwK1V+4XUbOqCa2h8GIfB/KPByxnBdFNbWpOYfD4zCbC/n/qtjmte85MGC++rwg9LuYnLvOGFqcw0um/5uTnMBsot9xgQ/WXkiTNHxwckH/yQC6AGV9fu/56Ls27TjCFtdhOh1iEQoPpS0zKl03ypH9WC05iC0oLovTSr3Gzc/4FQgpJAH4MwTb0Ilkxt8fxPWs8P9OGxY+aZ00CMbnlJ/ryBtYxc9yDi0/f+SrqTiI7RoCLcDj1dZjDSb2vTvePekr9NVkBZa0QmBY3StAWYQyFyi9cBkbuwQNbI4vX+yBZmiJQt0mkro5YPk3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNLfJVzh5VJ31qEn7gbyiYEuSbHzRJCYxbJgsAgxrkk=;
 b=ihMYL1lEEghaXUNBNB22QzkazDmRWjL34oxbO5GJYhEiex5vDR6DtK3HBKjJJdTD77rgWQfOG0CpInnYKOjIat9PZJbZ8bEEnmhJXKPLuA841lnsiaj4E6jzjKvaMVp1opj90nyuwXHa9jGnG/iEA9h984SKWrQVf/+NKtQJXhA1ov8MfYpqhm+gQ9ER+KqerhOdpbDdBgdlkc8CXi2fjQKNan3zxDL+suvCbUv7BAgk6PQGbpenXoULkfV/7kL/RGPFfXvPZ/MIP27eDDgT6J9CMG+PkL8xfSfrp8g7JWanoQJxTcS04U2UVkYs00iUzfISQoWzBmppapqYE4smhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNLfJVzh5VJ31qEn7gbyiYEuSbHzRJCYxbJgsAgxrkk=;
 b=kK9/gM8ZdOHvF+JGTj5I3C1xCCtKarUR+I0k0I7PHk6awaB9e0o1inY1l65a+fYDyIUfXxa5LpmkI5GHDOa3DgcVeKJHyBkb/1pC/BOhd/W/jXuQmz8GOuLOvqYHSAK8wkuAJZlpZf6tn98H1kIwanNUUSlPxoaXScsFP48z4Jg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1327.namprd11.prod.outlook.com (2603:10b6:300:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Wed, 15 Apr
 2020 16:12:53 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:53 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 16/20] staging: wfx: drop useless attributes 'filter_prbreq' and 'filter_bssid'
Date:   Wed, 15 Apr 2020 18:11:43 +0200
Message-Id: <20200415161147.69738-17-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:50 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5b34595-86cb-4be6-68c6-08d7e157da0b
X-MS-TrafficTypeDiagnostic: MWHPR11MB1327:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1327F75A32769D76CC851BE193DB0@MWHPR11MB1327.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:317;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(39850400004)(136003)(346002)(366004)(376002)(396003)(4326008)(81156014)(107886003)(52116002)(54906003)(8676002)(478600001)(8936002)(6506007)(5660300002)(6512007)(36756003)(8886007)(86362001)(316002)(6486002)(1076003)(2616005)(186003)(2906002)(66574012)(6666004)(66556008)(16526019)(66946007)(66476007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RvU5qAJMv4nCX8E7Mkvbb4WE/ZLu7umW0QyORGO5USwTIN0Bh9LeSRfI4ubmFkRKOZ420Nk0Xu/E038cwWTENY0yyBqJMAhX85LT0xzlf5AEUJrL1JPLLDrS4feVTWNR8qkWwlkaJ2oApOczTxpdfNIB8zv3qTaC3Rwes3c2i+7+PFsAtho6FpTrkAczswdrnUmE7Fbq+7xBZjamDLglbLgSMuwNonO+tnedTRY24nH1Bm6DG4GtJ89YsTniEXjYGY04FrMUU2E8Z9KUJtZC/9p92IhZJ50eOpw3sBd3laYxp4bnU8oPtgiSQjPxa5/Dt0xIxWiFvky3Nc2e4J2SLW6lU0cfqB2qczBoXcxt2vscGzeQF7GKt/YYZNudVAcUYC6tO2aOuUC94QEBlUO9wTJ2YM6xSIKTvI+PbaoP74HhOOUaQ5B9HzXjNj5U8LLu
X-MS-Exchange-AntiSpam-MessageData: +CQhcFEbKDIiv+oxAzja5MDfPyrfJZRM41ZtZyUr3I/mTLoE5mQsLTsnP6xcW8f4vE2glOUpz0Q8vhCwCl1aXuNWfCrUoECCjeOBUYfA/4cW0N30fL2PrRjeNyTBYd/uB+4abiwGLZMxSBDR4CaXt564DzHgwxflel5AqR0xFhP4djbXWe9v8otLmn2uQLXzyR7+EtVWNTj64+EMfSGQjg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b34595-86cb-4be6-68c6-08d7e157da0b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:53.5588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U76nZlfXbO2Sm+/5omj7Ox5HrJZNYwjGyLap6wpSHSJd1l7dPAvm8E9GXgZdBGcZ+SpwVHNbao2jrcev6qbWaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1327
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSXQg
aXMgbm93IHVzZWxlc3MgdG8gc3RvcmUgZmlsdGVyX3ByYnJlcSBhbmQgZmlsdGVyX2Jzc2lkIGlu
IHN0cnVjdAp3ZnhfdmlmLiBXZSBjYW4ganVzdCBwYXNzIHRoZW0gYXMgcGFyYW1ldGVycyB0byBo
aWZfc2V0X3J4X2ZpbHRlcigpLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGpl
cm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMg
fCAxMiArKysrKystLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggfCAgMiAtLQogMiBm
aWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
aW5kZXggYzc1MDViNWQwOTQ3Li5hOTI2MWVmNGI0YzUgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtMTk0LDYg
KzE5NCw3IEBAIHZvaWQgd2Z4X2NvbmZpZ3VyZV9maWx0ZXIoc3RydWN0IGllZWU4MDIxMV9odyAq
aHcsCiB7CiAJc3RydWN0IHdmeF92aWYgKnd2aWYgPSBOVUxMOwogCXN0cnVjdCB3ZnhfZGV2ICp3
ZGV2ID0gaHctPnByaXY7CisJYm9vbCBmaWx0ZXJfYnNzaWQsIGZpbHRlcl9wcmJyZXE7CiAKIAkv
LyBOb3RlczoKIAkvLyAgIC0gUHJvYmUgcmVzcG9uc2VzIChGSUZfQkNOX1BSQlJFU1BfUFJPTUlT
QykgYXJlIG5ldmVyIGZpbHRlcmVkCkBAIC0yMjcsOSArMjI4LDkgQEAgdm9pZCB3ZnhfY29uZmln
dXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAkJd2Z4X3VwZGF0ZV9maWx0ZXJp
bmcod3ZpZik7CiAKIAkJaWYgKCp0b3RhbF9mbGFncyAmIEZJRl9PVEhFUl9CU1MpCi0JCQl3dmlm
LT5maWx0ZXJfYnNzaWQgPSBmYWxzZTsKKwkJCWZpbHRlcl9ic3NpZCA9IGZhbHNlOwogCQllbHNl
Ci0JCQl3dmlmLT5maWx0ZXJfYnNzaWQgPSB0cnVlOworCQkJZmlsdGVyX2Jzc2lkID0gdHJ1ZTsK
IAogCQkvLyBJbiBBUCBtb2RlLCBjaGlwIGNhbiByZXBseSB0byBwcm9iZSByZXF1ZXN0IGl0c2Vs
ZgogCQlpZiAoKnRvdGFsX2ZsYWdzICYgRklGX1BST0JFX1JFUSAmJgpAQCAtMjM5LDExICsyNDAs
MTAgQEAgdm9pZCB3ZnhfY29uZmlndXJlX2ZpbHRlcihzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywK
IAkJfQogCiAJCWlmICgqdG90YWxfZmxhZ3MgJiBGSUZfUFJPQkVfUkVRKQotCQkJd3ZpZi0+Zmls
dGVyX3ByYnJlcSA9IGZhbHNlOworCQkJZmlsdGVyX3ByYnJlcSA9IGZhbHNlOwogCQllbHNlCi0J
CQl3dmlmLT5maWx0ZXJfcHJicmVxID0gdHJ1ZTsKLQkJaGlmX3NldF9yeF9maWx0ZXIod3ZpZiwg
d3ZpZi0+ZmlsdGVyX2Jzc2lkLAotCQkJCSAgd3ZpZi0+ZmlsdGVyX3ByYnJlcSk7CisJCQlmaWx0
ZXJfcHJicmVxID0gdHJ1ZTsKKwkJaGlmX3NldF9yeF9maWx0ZXIod3ZpZiwgZmlsdGVyX2Jzc2lk
LCBmaWx0ZXJfcHJicmVxKTsKIAogCQltdXRleF91bmxvY2soJnd2aWYtPnNjYW5fbG9jayk7CiAJ
fQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCBiL2RyaXZlcnMvc3RhZ2lu
Zy93Zngvd2Z4LmgKaW5kZXggNTMxODRmZTJkYTRiLi4zMTBkOTU0Nzg4MjQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC93Zngu
aApAQCAtOTAsOCArOTAsNiBAQCBzdHJ1Y3Qgd2Z4X3ZpZiB7CiAJaW50CQkJZmlsdGVyX21jYXN0
X2NvdW50OwogCXU4CQkJZmlsdGVyX21jYXN0X2FkZHJbOF1bRVRIX0FMRU5dOwogCWJvb2wJCQlm
aWx0ZXJfbWNhc3Q7Ci0JYm9vbAkJCWZpbHRlcl9ic3NpZDsKLQlib29sCQkJZmlsdGVyX3ByYnJl
cTsKIAlib29sCQkJZmlsdGVyX2JlYWNvbjsKIAogCXVuc2lnbmVkIGxvbmcJCXVhcHNkX21hc2s7
Ci0tIAoyLjI1LjEKCg==
