Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E36F20BCEB
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgFZWq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:46:59 -0400
Received: from mail-am6eur05on2082.outbound.protection.outlook.com ([40.107.22.82]:6168
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726110AbgFZWq6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 18:46:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mv+3yo/L4FeJq5rWtysKpedFJcNuD7ZLSBJtttRpBd0KWNmm6ZOrJZJ3GKxg6VxwqV6U9df5JZQKx68aZ/gotz5tsTQfs/nv8+SF4pov/yMsV60b9JnTxyFhW0vl3oAjiGfgmKpmAIgtwAbb6Sv3kU1DU3BKJf2Dcl5crJ0z1OJnAk4nuim5AFb0iNq7/N/XxmJxciwJbpsgHeJyGWAsaGE1w7cDo/ar8NIBu/oat43t326gN8JSabii4ovvqsITsd3xnY9ZfGy4oKrKA9RvQcoe2T52G9SRpOM00dYXqlxMJaDhTyBKYFXsbjJXz2DafhC4/a05TkpaFOXkXufTEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFvt3AYzLc8vnVuXKAbqnOwhelN/2Q1uZcpGzQ5CF1A=;
 b=At3SXB02MIv4bswHch5dd346Dt6Yc1i+elCaJw8A7FUsB/jNtW8ErwCnsyc9jhBkErzZqsT9dTz5qkNQCzJUlsgbgWNgdgrNH8Vsitcr4PIwGr5Qg3KUC8rLg/37qJzvM08qXilm7gl4LCF9xXINTfdCY53l2w/BuwJvj6JeHpxCPe6eZPyYY7ZuGlE/4ZBKp/fG6uH35303FoIbDHRDo+8ZTG6RJGXCSPYmjjPw8kpKZtTXeD5F67O+V/CmCngzxN+h2jk56p9FxpJgqPS1leIwPZzrB1wxwMoLVdXz6MGPFb4sQUPnt2GpFIbbjSbDSyY4WF0yBJjZ6glewp8bTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFvt3AYzLc8vnVuXKAbqnOwhelN/2Q1uZcpGzQ5CF1A=;
 b=IarEyr+gMGvpyGYHAfgKTo9+AeNLPY1AwNbxjwxjMmgdH6RVzaiNFc3Exizr4kojqBXzC5N8AdtaoRzOTB6/R02m/T+1cpl5VW4z7wgMdHazvinNO/dsdadsmxmiccnDZ8sgoGjN4hIeCvSnHwK9O+bXgIK9OBfY7M7qy28xSmc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3196.eurprd05.prod.outlook.com (2603:10a6:7:33::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3131.21; Fri, 26 Jun 2020 22:46:21 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3131.024; Fri, 26 Jun 2020
 22:46:21 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, jiri@mellanox.com,
        idosch@mellanox.com, Petr Machata <petrm@mellanox.com>
Subject: [PATCH iproute2-next v1 3/4] man: tc: Describe qevents
Date:   Sat, 27 Jun 2020 01:45:32 +0300
Message-Id: <098797720a8835bf1e3c891f4c4ad6a4270b48b0.1593211071.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <ea058286aa9a3dd430d261e61111cf5f91c857bc.1593211071.git.petrm@mellanox.com>
References: <ea058286aa9a3dd430d261e61111cf5f91c857bc.1593211071.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0139.eurprd05.prod.outlook.com
 (2603:10a6:207:3::17) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR05CA0139.eurprd05.prod.outlook.com (2603:10a6:207:3::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Fri, 26 Jun 2020 22:46:19 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 50daf393-6348-441c-edaa-08d81a22bef6
X-MS-TrafficTypeDiagnostic: HE1PR05MB3196:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB31969972E252CAE355533446DB930@HE1PR05MB3196.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0446F0FCE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3c1h9bTAyamHI8d6pCPF+GgIuaQ7XIp702/6TCjIHzcDKCL7dHCkJUPGyYPsIuvVEw+45wRZN97jBa+98mMENm9etrsKsp5jeuFTqssdINTv5Klq1Ce21GHWGqWQk3mZsxe+rsVEyhjpckGwkRXlHRuY/Rn5upWW9j0Hg8MoC3HCWwy4P+dZfg4osGn1QMDcs0XSFx9iOFPXQc1yIeeaPuxftPhZstx8HDORziW218yrPtcEieqUwOQFMlYYK2fho+0Jot6RHunA2bEWmu4rNYOBa9nfdX3u+uccFrg46uH8u4WFEOESW+l/85XpqQNRORrbxLUIKtEPiwH7G8bdyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(136003)(366004)(346002)(376002)(5660300002)(66476007)(8676002)(956004)(54906003)(52116002)(2616005)(6666004)(83380400001)(4326008)(6512007)(2906002)(26005)(8936002)(6916009)(107886003)(66556008)(36756003)(478600001)(86362001)(66946007)(186003)(316002)(6486002)(6506007)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: MykgRdclZVsfKoZVB4aONZQv7OHD/252I7wpuDUB1Z5mvVeDQMaV8Bf+C9qeLoPrmtsRZcT/aP7BBjCVcsyBEnreqYBLG9iZ5FTCX7DoZ0LquBACW2df9zGjOEdvZpvORbPw4gv9bLHLs/bCyZhwubY85FRv/2sgHGGwzU6Qgil6T0qI3C487GVFo7W24QYopfuG59d0NulIc0J18AWGTRVQe/9/dCg3Xnhl5tf7c16yVtiXuF9svQQ5lawLRqoaaNHOkHhH+OAGHBFILreMzQ5otFqciTsCIupAsgEZP+krrKIPFFkcKXKo+iF8lFW8AuQ6ir4z6vOxuuF0n1b8TZ9faM52xZuJKpnPUW3G4Xi8nz9JwwseYWqKopa18TBDPYkpHFI2NyXUW3ZMdp8RKARedcFGlrBPLTF7lC8VbRFZbg8/CgjOxwTaLiwRJaz03HqqGFmshMLjiKaM8z5IvHHQjymOZdqk61PWQouOpMM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50daf393-6348-441c-edaa-08d81a22bef6
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2020 22:46:21.1087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AJ/2WgRg8T/FwHu96egl7tqXQ0YaUM9YDlBTKu0kIm29ayBaL1yrrYuApz8sgAd1qygzYNfa7KVwVMNpQQh8nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3196
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some general remarks about qevents.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc.8 | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/man/man8/tc.8 b/man/man8/tc.8
index e8e0cd0f..970440f6 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -254,6 +254,25 @@ Traffic control filter that matches every packet. See
 .BR tc-matchall (8)
 for details.
 
+.SH QEVENTS
+Qdiscs may invoke user-configured actions when certain interesting events
+take place in the qdisc. Each qevent can either be unused, or can have a
+block attached to it. To this block are then attached filters using the "tc
+block BLOCK_IDX" syntax. The block is executed when the qevent associated
+with the attachment point takes place. For example, packet could be
+dropped, or delayed, etc., depending on the qdisc and the qevent in
+question.
+
+For example:
+.PP
+.RS
+tc qdisc add dev eth0 root handle 1: red limit 500K avpkt 1K \\
+   qevent early block 10
+.RE
+.RS
+tc filter add block 10 matchall action mirred egress mirror dev eth1
+.RE
+
 .SH CLASSLESS QDISCS
 The classless qdiscs are:
 .TP
-- 
2.20.1

