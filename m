Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9558210E75
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 17:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731716AbgGAPIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 11:08:02 -0400
Received: from mail-bn8nam12on2056.outbound.protection.outlook.com ([40.107.237.56]:52640
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731343AbgGAPIB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Jul 2020 11:08:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJU5S/8VKILFgN61qtyrJu8Qiu7r4/A8nebqpw1MzLBsrPMo7ID0h76qWp72lm4DH0P7srTbUGaRx2+a3/uzLjTjRXKkafX6KoMkrjP8tiv7wZdSFf5nR+uAnITWy/Lcz1Wg3bZu9Pwb4gUGeBmleIcD3CGMKRcVHPttRJdbsiQeZ+XkyazIs7Z2wNEdEtkDSSfksu9DBbeBeINKA4rctZFuwMqun2IPNNvCiOVqEW9X5wjfS1atJUOnN+V9jUixzxNuc1tcUy/nhkK8NQgI3awKpcqLxuOrVrZl5WsyfPu4eQBMBnOG8zo/bAMqD8TRCtlS9UNMvq2ta3FtnnTrfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWWmudIIqZ0mhAhXjWQdagl6C7Lf5Cej04u/aB9o7Yo=;
 b=cUkS9StBLNWaEJT1NTNmbL9KwFNdFJWflTlZeYFjY7iLJaVMbg8mBkvtMu07kCkxQOSABkOkn72Hu3Af1+34YzA0vK9SkEVWDPLfw6VXXXjrLLl65xs74IhBLX/iyz42WF/h6RXPaEQZSwEfUCrEgm+2Qmx27rXJhykGb9Dc3kERJLR13Vjg8NcuUBSQJy4tQaXz2+eZOaK3TjDS4PNll7UZeHH/6mt9pxAV4BjmY03JQW8MybSS5bvaAV0H044FVzK5GvsBTO/cGE6gbxkbLndrA+BnA9534TOctbi3varlYdnEyjXQ4jspILzOa3nA4kuMKOkkttsQmERORmN0xQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eWWmudIIqZ0mhAhXjWQdagl6C7Lf5Cej04u/aB9o7Yo=;
 b=XzC+bT+OzuFSgvNXwWGFnkcCCxITqBuW9IYCiVwhcmP7BxwL/BOy5vLGNa1plKipReYPlF/j5uWWqnRUfYfpWhk3rkSE6yb7sjDSeA30mUx+FFpOsl8im9jO4uUTfz2JpQPnp8mqYNEe2G0vxM7BU3yLiN2SpOQMdiO6RSFpBPU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA0PR11MB4736.namprd11.prod.outlook.com (2603:10b6:806:9f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Wed, 1 Jul
 2020 15:07:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::c504:2d66:a8f7:2336%7]) with mapi id 15.20.3131.033; Wed, 1 Jul 2020
 15:07:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 00/13] staging: wfx: multiple fixes
Date:   Wed,  1 Jul 2020 17:06:54 +0200
Message-Id: <20200701150707.222985-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.27.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR07CA0143.namprd07.prod.outlook.com
 (2603:10b6:3:13e::33) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR07CA0143.namprd07.prod.outlook.com (2603:10b6:3:13e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21 via Frontend Transport; Wed, 1 Jul 2020 15:07:56 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e957100-ba5f-4250-c041-08d81dd08a45
X-MS-TrafficTypeDiagnostic: SA0PR11MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR11MB4736DA27A0F3E4D45A1421EF936C0@SA0PR11MB4736.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04519BA941
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OJf7QW8LuxhSl5bhqcflnO+CaC6E6TZ0zm2GkfY7VO+MonvT0P5QBINdrg4KzIw68N/69BTWaVIfx/wnQyI+RLWsIObZagXiUSrE9y9Vbza4A8T1P3EuWCQbJphEfDNkGvemx3zES/hU3BjzddY9lSv8qNujco3ngqk1r6yCYoJyDCm/pJvidMkzcWz2QnMOLEIMnBmxNSbDRbBrOf8/yOHLlzytlcL0e+N2ccTjwXX2rmnmurMLOmOucth1vFaRNpcchaVATgmCEWzxUlhjK+gTutzouWOc1k35e4XvP2OEcuB9mD4FTqOM7YYOZK7De9uyoFCpFcU56oEJ0y6W6A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(366004)(346002)(376002)(396003)(136003)(5660300002)(6486002)(86362001)(66574015)(36756003)(2906002)(186003)(83380400001)(16526019)(8936002)(66556008)(66476007)(107886003)(4326008)(8676002)(2616005)(1076003)(478600001)(316002)(54906003)(66946007)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dU8G2+ib6YZbarPCp1euTjCAKZWmIVFgOAWGMJzfI9iozKzc4KXCP5OHHn9hhaoAzj8sEOBDz4flp8AM3K531ruWrha3VuvTMUHMpg+0OFA7toM/+sz3k3CHJ4hJGp9fBudWyS7aebHy6RB9n7n/dGwxRaPhZhf0p1Ggdbp3rJRSpD686YzgvpcN/bE5jCW/xvaGO5RyZ1sdHtbsJ2gWYzjw3gFjf5RtfsKYKBoQWd/cs8ltghwLZ4nNyCqVuf7Wm15mILJuI5HMA3dMQCoFon0O3SzwZbU24+hCnDmwo57MmGyqIElVo7qPsCP6xBx6dNPGHBOEm6agllDLP2tyXAww83nsjKiO58rCfn6y7gMGXpOi+piCW0NLvYrLL3AbmrHBCv0NgIaTRCSZFBnsFG+AHQYFF1sfZUv+OqaQb3qiZvHAyExATsR5k43puBRWCvYNahujX/CXNG4wnAYoXj/vLa6cXD4q4NY8PrtFIdbK8tUjNBOiLgpnBHvDP0Ggt+yIcsspZnUtlZEoFlc5hi7jtWDDGAgYTkoR8w7HNDE=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e957100-ba5f-4250-c041-08d81dd08a45
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2020 15:07:58.6033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lmr/jbdCf7OriRbTL6uhsf6in/kLUGzyNzcYu+gwB4iXAvHEoGDf95ftXNuS0rAiw3DFdELQWao/jJ2R9IsiTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4736
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGVs
bG8sCgpUaGlzIHNlcmllcyBmaXhlcyBhIGZldyBpc3N1ZXMvaW1wcm92ZW1lbnRzIGRpc2NvdmVy
ZWQgZHVyaW5nIHRoZSBsYXN0IG1vbnRocy4KCkrDqXLDtG1lIFBvdWlsbGVyICgxMyk6CiAgc3Rh
Z2luZzogd2Z4OiBhc3NvY2lhdGUgdHhfcXVldWVzIHRvIHZpZnMKICBzdGFnaW5nOiB3Zng6IGNo
ZWNrIHRoZSB2aWYgSUQgb2YgdGhlIFR4IGNvbmZpcm1hdGlvbnMKICBzdGFnaW5nOiB3Zng6IGNv
cnJlY3RseSByZXRyaWV2ZSB2aWYgSUQgZnJvbSBUeCBjb25maXJtYXRpb24KICBzdGFnaW5nOiB3
Zng6IGFkZCB0cmFjZXBvaW50ICJxdWV1ZXNfc3RhdHMiCiAgc3RhZ2luZzogd2Z4OiBsb2FkIHRo
ZSBmaXJtd2FyZSBmYXN0ZXIKICBzdGFnaW5nOiB3Zng6IGltcHJvdmUgcHJvdGVjdGlvbiBhZ2Fp
bnN0IG1hbGZvcm1lZCBISUYgbWVzc2FnZXMKICBzdGFnaW5nOiB3Zng6IGZpeCB1bmV4cGVjdGVk
IGNhbGxzIHRvIGllZWU4MDIxMV9zdGFfc2V0X2J1ZmZlcmVkKCkKICBzdGFnaW5nOiB3Zng6IGRy
b3AgY291bnRlciBvZiBidWZmZXJlZCBmcmFtZXMKICBzdGFnaW5nOiB3Zng6IGZpeCBoYW5kbGlu
ZyBvZiBmcmFtZXMgd2l0aG91dCBSU1NJIGRhdGEKICBzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IGhh
bmRsaW5nIG9mIGVuY3J5cHRlZCBmcmFtZXMKICBzdGFnaW5nOiB3Zng6IGZpeCBDQ01QL1RLSVAg
cmVwbGF5IHByb3RlY3Rpb24KICBzdGFnaW5nOiB3Zng6IGFkZCBhIGRlYnVnZnMgZW50cnkgdG8g
Zm9yY2UgcHNfdGltZW91dAogIHN0YWdpbmc6IHdmeDogYWx3YXlzIGVuYWJsZSBGYXN0UHMgaW4g
Y29tYm8gd2l0aCBuZXcgZmlybXdhcmVzCgogZHJpdmVycy9zdGFnaW5nL3dmeC9iaC5jICAgICAg
fCAgMzYgKysrKy0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV9yeC5jIHwgIDg1ICsrKysr
Ky0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIHwgMTI3ICsrKysr
KysrKysrLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5oIHwg
ICAzICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2RlYnVnLmMgICB8ICAyMyArKysrKwogZHJpdmVy
cy9zdGFnaW5nL3dmeC9md2lvLmMgICAgfCAgIDkgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlm
X3J4LmMgIHwgIDIyICstLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAgICB8ICAgNCAr
LQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5jICAgfCAxNTIgKysrKysrKysrKysrKysrKy0t
LS0tLS0tLS0tLS0tLS0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9xdWV1ZS5oICAgfCAgMTMgKyst
CiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jICAgICB8ICAzNiArKystLS0tLQogZHJpdmVycy9z
dGFnaW5nL3dmeC9zdGEuaCAgICAgfCAgIDQgKy0KIGRyaXZlcnMvc3RhZ2luZy93ZngvdHJhY2Vz
LmggIHwgIDUxICsrKysrKysrKysrKwogZHJpdmVycy9zdGFnaW5nL3dmeC93ZnguaCAgICAgfCAg
IDUgKy0KIDE0IGZpbGVzIGNoYW5nZWQsIDI3MCBpbnNlcnRpb25zKCspLCAzMDAgZGVsZXRpb25z
KC0pCgotLSAKMi4yNy4wCgo=
