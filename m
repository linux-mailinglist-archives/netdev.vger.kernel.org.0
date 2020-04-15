Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071EB1AAD28
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 18:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1415246AbgDOQM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 12:12:58 -0400
Received: from mail-bn7nam10on2054.outbound.protection.outlook.com ([40.107.92.54]:6037
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2410281AbgDOQMz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 12:12:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/W43N+FM2AveQtp4tQHvDt87MaW/Xn0fo7CRcQH3i/JHc6+cq4Wxo+FvG0ZzKWzyqW6P6QSXxO0yCCC734z3AEnU/s3J9LnnmLeEAYLhZvw3U/FHkYVmSGWKfQS8Pmm3K8Y3+sjvJZXPV0wiLph20W/cVcbKae13a3JlGmJ/oY3LWo4F16MagroovXa7JthPn+NJlH+vUgtPofqDo7xGYWSIY9C5o8/L96ssPCaF4GgXbSz+vNGQGmS/XIrHxNfsOaK52uy/aHBXz9+b8QLaJsWYM8wIP32AjJ05++9kXoYIsOUNTP7Rk+3yi3KWbP8rTAeanKB+imxeYxHRAt+gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiI1Ngo5lz8VctH56hbGmIIpcY5X2PxEb0j7B11g3Rs=;
 b=HG9/SKf2+JmsQKfDPC7fYv73YpTbBBNbWfvyEJ8y4opNPwkgP63QI/L4nnomzv+QnLvxentibZwbVRPwdA/C+/aTwE+kfMyep5P6FddbfMyz0lXAY1cVGowJnpmESx5TNQBYKIn866pgvRhj9Ggrjtfv4Mnlu0Sa8w9TgzIDp4Zar2clp0oIS2d//MFOveT9xyEGSsaA/uQGJjon0EQhbHStX5f0oAigHvanIo6qkgMkOIqXb0Hxh/p+PVlJVggh4+A5ICPayxsX+u9NYNXXU48WSgWN2g+uZMvJclwF4NNGoCHhj9fouSzU8Wsl8TiM1HHh0YTH/3EEnRQI8fFRxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiI1Ngo5lz8VctH56hbGmIIpcY5X2PxEb0j7B11g3Rs=;
 b=MCNDluEQs2Q8p6wTjvZO2twkVobOdqHWme0IVCvWYTpgooOkNlQTpyoVU1G8RZi96ByB2rmfU8b4y4zcqOOVr+ouuo5oIRn2Emc/Tw6wiRLBs9JH6d629GZ3rdG4oEfkKUrfpshe7IAD2OLzHruSrk12ys76bJ/UiO1MSKEJj3U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1599.namprd11.prod.outlook.com (2603:10b6:301:e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Wed, 15 Apr
 2020 16:12:45 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::81d5:b62b:3770:ffbe%10]) with mapi id 15.20.2921.024; Wed, 15 Apr
 2020 16:12:45 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 13/20] staging: wfx: align semantic of probe request filter with other filters
Date:   Wed, 15 Apr 2020 18:11:40 +0200
Message-Id: <20200415161147.69738-14-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.home (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by PR1PR01CA0027.eurprd01.prod.exchangelabs.com (2603:10a6:102::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 16:12:42 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 688a55d0-704b-421c-a88a-08d7e157d507
X-MS-TrafficTypeDiagnostic: MWHPR11MB1599:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB1599174F062D99F09C162A9B93DB0@MWHPR11MB1599.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:949;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(376002)(396003)(346002)(366004)(39850400004)(136003)(4326008)(66476007)(107886003)(81156014)(86362001)(8936002)(2616005)(6512007)(6486002)(316002)(52116002)(66556008)(66946007)(6506007)(8886007)(2906002)(1076003)(36756003)(66574012)(5660300002)(54906003)(478600001)(16526019)(8676002)(186003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WhW18EeacP7X1k0ag8vbAqkNov7m87/hIOEijDbdjFb1cuxEsX8Sqi7opukIjhl89L5RCAZLKKYz+c6hwCRqPARbK0E1EChzTm6x46fN/2CW8Nn+7fFEwzUJX/koIcEu2kjcHq7iHBPzpoTZVnyTUSAVdAOamr1ed93sUlVz3fz8y0UdRGn0oFjPN6wNAQhfOxeCvSB+TFbYAjWxlxNZUR6yM92qwsF7dlKigrBLb+TxV+SEtzRQLqZnnUcG4PtHTZpc9euQRs186gv1RzGlxL6+aVtk/VM3g7oam5eqqL8Q/zMb8CTPAMCSa14gkN6nr1plMFWa06CbN/IYJZqHHbs2cgRqj8hRBpwi7sp9FqJdwgbrz6z3Es4+FxNynv7X5b9k4CI41Z6b8BJv+Wp+TfucCjnuWcKjr+OWIF3nl5FokvxkyMDcXWjv8316d0gB
X-MS-Exchange-AntiSpam-MessageData: vOOjjA/3rcbF9pn96qqRPoTaPWd5mbly0JMENR/mEdB+a01K7lZ2Ra0JnzLntieO9/VReMriLYtYHHDdQEhghrAakwZ/7vvzZyNq5kX2iS1/Ge5z/8Xk/4ghEQ2LlGYh1/05D39L00WjlNSXEtKKQz3bl3Q1Caw5kFYS4oogsvoMG6pdZIfV1kNQNqgdJDmvkzFVfUp3KdXBzCeOivwMzQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 688a55d0-704b-421c-a88a-08d7e157d507
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 16:12:44.9647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBbScTTXrtsZPuZB0OseV9H/1hoORNum0dYroprtaKlJP8Ltom6h1yZPsFfKGVTTUVFBxD+PCHOmCs/YZl9LwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1599
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRmls
dGVycyBwcm92aWRlZCBieSBISUYgQVBJIGFyZSBzb21ldGltZSBpbmNsdXNpdmUsIHNvbWV0aW1l
IGV4Y2x1c2l2ZS4KClRoaXMgcGF0Y2ggYWxpZ24gdGhlIGJlaGF2aW9yIGFuZCBuYW1lIG9mIHRo
ZSBwcm9iZSByZXF1ZXN0IGZpbHRlciB3aXRoCnRoZSBvdGhlciBmaWx0ZXJzLgoKU2lnbmVkLW9m
Zi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0K
IGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jIHwgNCArKy0tCiBkcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jICAgICAgICB8IDggKysrKy0tLS0KIGRyaXZlcnMvc3RhZ2luZy93Zngvd2Z4
LmggICAgICAgIHwgMiArLQogMyBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDcgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMg
Yi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYwppbmRleCA0MWYzMDkwZDI5YmUuLjFk
MjZkNzQwYmQwYiAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKQEAgLTkwLDEzICs5MCwxMyBA
QCBpbnQgaGlmX3NldF9tYWNhZGRyKHN0cnVjdCB3ZnhfdmlmICp3dmlmLCB1OCAqbWFjKQogfQog
CiBpbnQgaGlmX3NldF9yeF9maWx0ZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsCi0JCSAgICAgIGJv
b2wgZmlsdGVyX2Jzc2lkLCBib29sIGZ3ZF9wcm9iZV9yZXEpCisJCSAgICAgIGJvb2wgZmlsdGVy
X2Jzc2lkLCBib29sIGZpbHRlcl9wcmJyZXEpCiB7CiAJc3RydWN0IGhpZl9taWJfcnhfZmlsdGVy
IHZhbCA9IHsgfTsKIAogCWlmIChmaWx0ZXJfYnNzaWQpCiAJCXZhbC5ic3NpZF9maWx0ZXIgPSAx
OwotCWlmIChmd2RfcHJvYmVfcmVxKQorCWlmICghZmlsdGVyX3ByYnJlcSkKIAkJdmFsLmZ3ZF9w
cm9iZV9yZXEgPSAxOwogCXJldHVybiBoaWZfd3JpdGVfbWliKHd2aWYtPndkZXYsIHd2aWYtPmlk
LCBISUZfTUlCX0lEX1JYX0ZJTFRFUiwKIAkJCSAgICAgJnZhbCwgc2l6ZW9mKHZhbCkpOwpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngv
c3RhLmMKaW5kZXggOTYzY2FjODNiNmE4Li4zYTEwNWQ0ODUyMzcgMTAwNjQ0Ci0tLSBhL2RyaXZl
cnMvc3RhZ2luZy93Zngvc3RhLmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAt
MTM2LDcgKzEzNiw3IEBAIHZvaWQgd2Z4X3VwZGF0ZV9maWx0ZXJpbmcoc3RydWN0IHdmeF92aWYg
Knd2aWYpCiAJCX0KIAl9OwogCi0JaGlmX3NldF9yeF9maWx0ZXIod3ZpZiwgd3ZpZi0+ZmlsdGVy
X2Jzc2lkLCB3dmlmLT5md2RfcHJvYmVfcmVxKTsKKwloaWZfc2V0X3J4X2ZpbHRlcih3dmlmLCB3
dmlmLT5maWx0ZXJfYnNzaWQsIHd2aWYtPmZpbHRlcl9wcmJyZXEpOwogCWlmICghd3ZpZi0+Zmls
dGVyX2JlYWNvbikgewogCQloaWZfc2V0X2JlYWNvbl9maWx0ZXJfdGFibGUod3ZpZiwgMCwgTlVM
TCk7CiAJCWhpZl9iZWFjb25fZmlsdGVyX2NvbnRyb2wod3ZpZiwgMCwgMSk7CkBAIC0yNDIsMTEg
KzI0MiwxMSBAQCB2b2lkIHdmeF9jb25maWd1cmVfZmlsdGVyKHN0cnVjdCBpZWVlODAyMTFfaHcg
Kmh3LAogCQl9CiAKIAkJaWYgKCp0b3RhbF9mbGFncyAmIEZJRl9QUk9CRV9SRVEpCi0JCQl3dmlm
LT5md2RfcHJvYmVfcmVxID0gdHJ1ZTsKKwkJCXd2aWYtPmZpbHRlcl9wcmJyZXEgPSBmYWxzZTsK
IAkJZWxzZQotCQkJd3ZpZi0+ZndkX3Byb2JlX3JlcSA9IGZhbHNlOworCQkJd3ZpZi0+ZmlsdGVy
X3ByYnJlcSA9IHRydWU7CiAJCWhpZl9zZXRfcnhfZmlsdGVyKHd2aWYsIHd2aWYtPmZpbHRlcl9i
c3NpZCwKLQkJCQkgIHd2aWYtPmZ3ZF9wcm9iZV9yZXEpOworCQkJCSAgd3ZpZi0+ZmlsdGVyX3By
YnJlcSk7CiAKIAkJbXV0ZXhfdW5sb2NrKCZ3dmlmLT5zY2FuX2xvY2spOwogCX0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3dmeC5o
CmluZGV4IDUzZWQ0YzEzN2IxOS4uMzk0MTQ2MjA5N2E0IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L3dmeC5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvd2Z4LmgKQEAgLTg5LDcg
Kzg5LDcgQEAgc3RydWN0IHdmeF92aWYgewogCXN0cnVjdCB3b3JrX3N0cnVjdAl1cGRhdGVfdGlt
X3dvcms7CiAKIAlib29sCQkJZmlsdGVyX2Jzc2lkOwotCWJvb2wJCQlmd2RfcHJvYmVfcmVxOwor
CWJvb2wJCQlmaWx0ZXJfcHJicmVxOwogCWJvb2wJCQlmaWx0ZXJfYmVhY29uOwogCiAJdW5zaWdu
ZWQgbG9uZwkJdWFwc2RfbWFzazsKLS0gCjIuMjUuMQoK
