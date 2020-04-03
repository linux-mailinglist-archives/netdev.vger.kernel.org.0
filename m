Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60A7319E144
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgDCXGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:06:03 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:53598
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728610AbgDCXGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 19:06:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WaP2YBNBT3JBV7o/AI9ZCbWDvIKhSfLKkHdF2w4vc0oMwMuP6CzvUobpy6tiIqmtDukwiMkx42UjlFaYhKCAXKfTLmbQuLI5eIv6ZuEplMAXzcjmJGElsSfOenjlOvJWNnwQjZ1+NS6gX6J5r1kmjd2+ZwFvLxLX1GSC8m/cDVMbubJZvg+n1TmvZPjqkpgzisnFw1EknrshSZ5wS0xIJTfUVXVFTqket4Nb2EzO7mgjZ6IdVMAv8Tf39kGSXnyT7JNrVPfNDGkjVqtwwHKBmRWKeRhLICZ6JC/kAKo3vxCXuhR5wYRq8hulL8LHLzMZA2TtcJLyt9QYN6uBIzWl0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JDJOUaRMSv7ZbFl2X3koP+J1yzfgLYGiJOBzXc7ycY=;
 b=LWw36iSGnpuqNFy9BDYoItqolaNJ78g5QqfcSTQzkNzodAA1PxgsBYYPUS0oQuxWZgu9khJKk/aT1qMl73w9GYRky1iCpvzGwf1QjJYdREAQy7qxB9r0D3A3W3IMc5tGuT2XvwLmcMwGENdiGv1sJvJvqssag988QbaVWqU2cCavYeLYeBVvlOTPP9oiEGzFO5IfkNsI8ivGdvcKi1RmHtU2VDs8heU55NFcC+RBD7bvYalx1L+vo9Pr4kngHi6V+vaUVr1YQdVfRyoaHXqxwarkDXRO8pEE59ItZLEjOJmzbxwBAc4n/TzEX8PReiGYWhW1vzdySE6IKtuyYq98+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JDJOUaRMSv7ZbFl2X3koP+J1yzfgLYGiJOBzXc7ycY=;
 b=qOHAOJscBIqtUh9JZBLerpCRmokm8NA6CDJpsv+SBzLUQNEE9dndRKjsQ94eVA/cOvG+/W2Mdwixk/2S6zbwA7rO674wuUfA7B63ndcxYm5JY7PDI9HkhUw8uYlBK/TIZ1Hy514Oo+y7fzkXyWNOvbfhOD6T7xVgBsJJB8FWi54=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4652.eurprd05.prod.outlook.com (2603:10a6:7:99::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.17; Fri, 3 Apr 2020 23:05:57 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2856.019; Fri, 3 Apr 2020
 23:05:57 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next v2 2/3] man: tc-pedit: Add examples for dsfield and retain
Date:   Sat,  4 Apr 2020 02:05:30 +0300
Message-Id: <4a1f881e2dce535e3848dd87914db41f80fd0d57.1585954968.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585954968.git.petrm@mellanox.com>
References: <cover.1585954968.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0039.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::14) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P193CA0039.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Fri, 3 Apr 2020 23:05:56 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9307a56c-50e0-4c16-579b-08d7d8239131
X-MS-TrafficTypeDiagnostic: HE1PR05MB4652:|HE1PR05MB4652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4652595EBEB4DDEECBF0BBF4DBC70@HE1PR05MB4652.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(54906003)(6916009)(2616005)(956004)(36756003)(86362001)(81166006)(52116002)(2906002)(5660300002)(8676002)(8936002)(478600001)(81156014)(16526019)(186003)(66556008)(6506007)(6486002)(316002)(26005)(66476007)(66946007)(6666004)(4326008)(6512007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sP/JUwiIM6dFe6E2xnD378yAqCJGhVveSvXdirUdwUX5eBY1bTkvl1u8Xd+RSICNA92AmQ3YAKJdN8HNArPjeLBFyIUnmSmWFhd58Uwd73wlZXW9r+StAkgN4mvsxUN53JZVHDh1WN1/61Im6Jkn4Mqu0r6MRKoFZeVTv79wjfntfj+HO/O8qFV6hfE29N8gFqsx4LtqYhhLKjr01aY9RbIhOpHFmVW5sXjXWV6HReeWNpnOx6xKHyU5sHm6yxCA6v429zbOzmIfCA5EXthuzD54YFT0j72nqUbACrfb+maVC4bQ8l0MarLC9n6fGn3+qQfK2DvqGh4q7kJJWCYMhjQfnzf0dGBI7G63QTA4UFG/XcaIPdO2QbevoGQp7QO4CfPPpxtp/UEKg7UXdatURvo4gyNdSCYuXcVV0IHNeQMs5FtgOW6Dw2j3DJXfYnHU
X-MS-Exchange-AntiSpam-MessageData: UylB5tM4Fc0KFO0V8s3uot+nphQbPi/fP7GzG13zNnGGF2dUT+fGo6tllW5IrsZ+qvA496QJAATKmB7LOGW2DohxfgjjNXA6bEUiEl3B9wGllvxbD+EDYWDCpyQ6xfsNT462P5LPmVajwaFLjfbm8g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9307a56c-50e0-4c16-579b-08d7d8239131
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 23:05:57.3156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S6tS2L6EAt+0jPTh/RrCbwiszpMWzCDBk34B+y4xCdjhj4HGe1pIcpQMRazBaWTs/POwSQvPKJuxjRD0y1DfcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4652
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe a way to update just the DSCP and just the ECN part of the
dsfield. That is useful on its own, but also it shows how retain works.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-pedit.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index 3f6baa3d..d2b37ef0 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -369,6 +369,28 @@ tc filter add dev eth0 parent ffff: u32 \\
 	action pedit ex munge tcp dport set 22
 .EE
 .RE
+
+To rewrite just part of a field, use the
+.B retain
+directive. E.g. to overwrite the DSCP part of a dsfield with $DSCP, without
+touching ECN:
+
+.RS
+.EX
+tc filter add dev eth0 ingress flower ... \\
+	action pedit ex munge ip dsfield set $((DSCP << 2)) retain 0xfc
+.EE
+.RE
+
+And vice versa, to set ECN to e.g. 1 without impacting DSCP:
+
+.RS
+.EX
+tc filter add dev eth0 ingress flower ... \\
+	action pedit ex munge ip dsfield set 1 retain 0x3
+.EE
+.RE
+
 .SH SEE ALSO
 .BR tc (8),
 .BR tc-htb (8),
-- 
2.20.1

