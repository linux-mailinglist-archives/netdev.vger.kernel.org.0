Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2854119AA0E
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 13:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732453AbgDALFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 07:05:12 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:6053
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732335AbgDALFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 07:05:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPs0JlMNyTEXl7aWc2dIADAO5j+ku64zPrw/OGjf4598emz8t8CqL99XNtP460udnszrvcTOCogHUafYDZ7hZ+0cQvleBurou2i9OUD/tFCEBef+z1qWwPEDdxFeyWTFDXuyXn+cx3FHd6RBr3qSk8akgspy83RUzQOckiQERi9tYOcVi/eIbXNcZvY03rwD0L+diia2Zi5oC6XgVKMVOm7vK8V0C8jubLKQadcw4oVsumTZabgI2nmyr0dt4P1dAkBr6GQzEvLMZ3S+azchD563D7XKG3EkIsu5EPNUV+lFlOFRbnrzKgibHK2u0gtCGBnVM6qdnjSrdPJoSfLhMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20ueHzGkZvyRLZMo7s2ss/kn1LfmbL/UGhtDkK8/TvQ=;
 b=HRcTo87Cnr+F9vgYkIxtqE+4KcV2Z8hO0Zp5FS3TxT6S0U+JoUGrQqhXiwqAVwRRTWTZruDtT6Yvb+aeJ1ozOtf1HSqu6Z2tUTckH52FLxbT5E3vDeMgf0dXdIraNSUBvOslGPJfR+4EA5dQXu0J8BxKZ6qg3WaabkIQsmvFBn55WSWD9wnKOYExJu6DlQd0xbZkjB/8W9i8WhWuewgm5rdX0aF68YG0I8MDA/gEx2lfV81XUfzl0FMpV8nttX/QD7xaSC2Mk/HooCzbSHubuSOiZJ88YsLXu5noIoFoeHvERd8VOx+vwYPudkUHS+wNk6kQqtPzfEvrslGlGaZomQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20ueHzGkZvyRLZMo7s2ss/kn1LfmbL/UGhtDkK8/TvQ=;
 b=p2p5JdUfDfUGdwYq0grxAKvm5ZsgDq/c+5of2XOA7599NYb/dsmkS/TU4Vi+NmxSlKNeUQjxCxDVtEo68LdPFwt73Y83SsfGVDxG+stVHs4vmErKrJ9472rnlIyHprluvXMVCt5y4QRUvjwHd0GcBbQSj7bQ+qQW21gfdC4QDLw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4285.namprd11.prod.outlook.com (2603:10b6:208:191::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Wed, 1 Apr
 2020 11:04:56 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 11:04:56 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 18/32] staging: wfx: drop unused raw_link_id field
Date:   Wed,  1 Apr 2020 13:03:51 +0200
Message-Id: <20200401110405.80282-19-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0501CA0156.namprd05.prod.outlook.com
 (2603:10b6:803:2c::34) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:1265:30ff:fefd:6e7f) by SN4PR0501CA0156.namprd05.prod.outlook.com (2603:10b6:803:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.9 via Frontend Transport; Wed, 1 Apr 2020 11:04:54 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:1265:30ff:fefd:6e7f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7147423-a4a7-4bed-1c56-08d7d62c8347
X-MS-TrafficTypeDiagnostic: MN2PR11MB4285:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB4285CBE7E9287F7CB0B25B7593C90@MN2PR11MB4285.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 03607C04F0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4063.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(136003)(366004)(346002)(376002)(39850400004)(396003)(7696005)(8676002)(1076003)(16526019)(186003)(6666004)(5660300002)(86362001)(4326008)(52116002)(478600001)(66946007)(66476007)(54906003)(36756003)(8936002)(316002)(81156014)(6486002)(2906002)(66556008)(107886003)(81166006)(2616005);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HLFZCAJmo7AMq7kyy+j/9qaPsslT8EJzH9x6BEJ40HFquNoWJmqQ4Sch7/rhM9O6eT7icnEE4OWfftK2qTTYay9yhiFrklSgdx0P7RXN2OaKNvJrB8QHZvrj87x1BHIGRXeKjjuVXop4zZ5eVQJvsgkxTb3ghe8oZxQcKqsqnZzAP7DjLW3vzUy+S3GwV7oSaAeaIba/VhMjbJJ6IQa2EXJ9vwYVspm/Pi1EEcvQVrQnKiuQ/q1oADMOY+8aTTwZDUeZxhpDQhFdab7qlDll1gcuNpZIToiLJroiy8bvZpxVixRPpJvU1zAFnLOgxfpjK97/1ZvIgFocxC/8cAvvUGgbtxTnYaYvRByF0BWBUq3UXdkdC1WEy1DZRzUx8PP+axZy+gCO4RWRlhCc3bl4DGAFMVpokMMpg+cg8WIG15McjhgywDZBuoZQ3q5rHvgx
X-MS-Exchange-AntiSpam-MessageData: ZHZCdHbdu3Fmb7cjJY5uhPuhtvU0YIm8b5VFUwE6yPuY5VXarFHOvG7Ly2rDC2DZRHOtXTBnwsXiNXc0Qe8n0ngD1nlLMhM8YQPFuI6X1wFdA1E8HVy42QBwZlNcU5BdjLp2RjFYK+eA1G9aQujS1R5pBF6EIFLIBl9G4mNh4qN7RLRTkzN2agwlXD0fiAwxT/9eKbcukfU8vJigrxn0KQ==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7147423-a4a7-4bed-1c56-08d7d62c8347
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2020 11:04:56.7284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 71W5l25Oz1CGYIRvo5VkX7TthRKuEem/pgb5FvoyTkau6RRplqoab9bPn01Nh+INIQECJiJDYMhaoLM79wVNEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4285
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKcmF3
X2xpbmtfaWQgY2FuIGJlIHJldHJpZXZlZCBieSB3ZnhfdHhfZ2V0X3Jhd19saW5rX2lkKCkuIFNv
LCBpdCBpcyBub3QKbmVjZXNzYXJ5IHRvIGtlZXAgaXQgaW4gc3RydWN0IHdmeF90eF9wcml2LgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgMyArLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvZGF0YV90eC5oIHwgMSAtCiAyIGZpbGVzIGNoYW5nZWQsIDEgaW5zZXJ0aW9u
KCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0
YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggZjc5NDIxMmY0MmUy
Li41N2FmYWJjMTAyYTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC00MjMsNyArNDIzLDYgQEAg
c3RhdGljIGludCB3ZnhfdHhfaW5uZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVl
ODAyMTFfc3RhICpzdGEsCiAJbWVtc2V0KHR4X2luZm8tPnJhdGVfZHJpdmVyX2RhdGEsIDAsIHNp
emVvZihzdHJ1Y3Qgd2Z4X3R4X3ByaXYpKTsKIAkvLyBGaWxsIHR4X3ByaXYKIAl0eF9wcml2ID0g
KHN0cnVjdCB3ZnhfdHhfcHJpdiAqKXR4X2luZm8tPnJhdGVfZHJpdmVyX2RhdGE7Ci0JdHhfcHJp
di0+cmF3X2xpbmtfaWQgPSB3ZnhfdHhfZ2V0X3Jhd19saW5rX2lkKHd2aWYsIHN0YSwgaGRyKTsK
IAlpZiAoaWVlZTgwMjExX2hhc19wcm90ZWN0ZWQoaGRyLT5mcmFtZV9jb250cm9sKSkKIAkJdHhf
cHJpdi0+aHdfa2V5ID0gaHdfa2V5OwogCkBAIC00NTUsNyArNDU0LDcgQEAgc3RhdGljIGludCB3
ZnhfdHhfaW5uZXIoc3RydWN0IHdmeF92aWYgKnd2aWYsIHN0cnVjdCBpZWVlODAyMTFfc3RhICpz
dGEsCiAJcmVxLT5kYXRhX2ZsYWdzLmZjX29mZnNldCA9IG9mZnNldDsKIAlpZiAodHhfaW5mby0+
ZmxhZ3MgJiBJRUVFODAyMTFfVFhfQ1RMX1NFTkRfQUZURVJfRFRJTSkKIAkJcmVxLT5kYXRhX2Zs
YWdzLmFmdGVyX2R0aW0gPSAxOwotCXJlcS0+cXVldWVfaWQucGVlcl9zdGFfaWQgPSB0eF9wcml2
LT5yYXdfbGlua19pZDsKKwlyZXEtPnF1ZXVlX2lkLnBlZXJfc3RhX2lkID0gd2Z4X3R4X2dldF9y
YXdfbGlua19pZCh3dmlmLCBzdGEsIGhkcik7CiAJLy8gUXVldWUgaW5kZXggYXJlIGludmVydGVk
IGJldHdlZW4gZmlybXdhcmUgYW5kIExpbnV4CiAJcmVxLT5xdWV1ZV9pZC5xdWV1ZV9pZCA9IDMg
LSBxdWV1ZV9pZDsKIAlyZXEtPmh0X3R4X3BhcmFtZXRlcnMgPSB3ZnhfdHhfZ2V0X3R4X3Bhcm1z
KHd2aWYtPndkZXYsIHR4X2luZm8pOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9k
YXRhX3R4LmggYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2RhdGFfdHguaAppbmRleCBiNTYxYmJmOWYx
NmYuLjAzZmUzZTMxOWJhMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4
LmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmgKQEAgLTM2LDcgKzM2LDYgQEAg
c3RydWN0IHR4X3BvbGljeV9jYWNoZSB7CiBzdHJ1Y3Qgd2Z4X3R4X3ByaXYgewogCWt0aW1lX3Qg
eG1pdF90aW1lc3RhbXA7CiAJc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqaHdfa2V5OwotCXU4
IHJhd19saW5rX2lkOwogfSBfX3BhY2tlZDsKIAogdm9pZCB3ZnhfdHhfcG9saWN5X2luaXQoc3Ry
dWN0IHdmeF92aWYgKnd2aWYpOwotLSAKMi4yNS4xCgo=
