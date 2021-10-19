Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD79143390B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhJSOuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:50:09 -0400
Received: from mail-bn8nam11on2084.outbound.protection.outlook.com ([40.107.236.84]:40160
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229790AbhJSOuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:50:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jwpc3cOGJQp6eFJp2nbzDBjJeSUDawedApdWjo/yj0wFEEY9n/1YtYDUtnfZnIPi5IwjG27DXzn0OLwACwOrHnHBWxmsq13ioaGQ2fSGz2DQjaS4FLxQmEx8Hj9q5GKNqJq5Uc9xB6YsT0g/1G01p0ol7H05igKySFSPTdvjfn1MOvAD7tojuGWDkiVgoMwnbO7t9C3sSG01SkKlNtJUx8e2PW5XD1TB1LL+DzYtvmwKE11ARlzG6E2WCGsPZKBoar9u+HZfiePyX15RdTk8kBndSOArvJ+MIElPrr62okS7XS0QoHxF8PDx65kSSskMxE8LWrTnXZT9Bh7uLqWhEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iBQ0gwMkFusxTqbsXw5hdDyo8RoCQn5IqnfK77WvkY=;
 b=jUJMdkgLIFYByMkTimXqIfQIyVa+MDvR5/n0Snuahf9sS6FPVRCpi/NPgEIjEtpCwWYv6FKanJfXVA/+qGPdgQjFnl/OWX1tTBORFcbWK8oyr7lzZWk483PnmTkm8nDGn9nrzAoOZmPWy9Xr6vgHMM7KA0qkMAUUdlzYht66a5TzFoSVZOU+rOL51d6JwxPoPzmQZBEtC25hRQzOYF2CDnIwu0NxfPWly3RYmC+qEbRg7annn9sQ85StL8Enwgvvhx9hv8yge4O6PdMWbuQpEmIX1VlpDopM7HF+6zjRnnjVfMq87faGJgIn5bgUQY7BYZOvLokXB82rTSmd6l1z8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iBQ0gwMkFusxTqbsXw5hdDyo8RoCQn5IqnfK77WvkY=;
 b=FEFBeIrS85jLyOItDt3aMj2dhibqq6goADnZnWCFkgWtsvSFUvf/1DQUybYRVTFrYCgVqXDMF6hgoTZcN/whGa/MHfy1Kw16B3+0mgd1nqJwapq8vE8c8vC1ZHl9FQB4ie9Y/w628xz8DS+cO+EqdbFxF+nQVw9ILxxUHt/QAHy+KBVHQXqBAFl3g+07PmzRitWVhyBEW6R8eKAYyp8N9Rce+cqCKJxYkaah9ctycczlC+GkuaIZJIcPgcgiV4xZn/ug6SrBSWkOuW0PNdY2cdo0ZXB2pfDf6D9wf770UGYDy1xYaf8WMqTcu3HBrFlQVD/cAtm7SK8OS3z/XmNOLA==
Received: from DM6PR06CA0023.namprd06.prod.outlook.com (2603:10b6:5:120::36)
 by BN6PR12MB1635.namprd12.prod.outlook.com (2603:10b6:405:3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 14:47:52 +0000
Received: from DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:120:cafe::f7) by DM6PR06CA0023.outlook.office365.com
 (2603:10b6:5:120::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT023.mail.protection.outlook.com (10.13.173.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:47:51 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 07:47:50 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:38 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next 03/10] bpf: Use EOPNOTSUPP in bpf_tcp_check_syncookie
Date:   Tue, 19 Oct 2021 17:46:48 +0300
Message-ID: <20211019144655.3483197-4-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019144655.3483197-1-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d2669bd0-f6bb-4ea1-68a5-08d9930f6d7c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1635:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1635BF908116452C015BD95FDCBD9@BN6PR12MB1635.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cK/aQwOSJstpsONa+KlBS213rvP81Z4QY4aPZm/7sooTdzeenBYcngtCVKm5ayMIu3KIO+tg2qBNaURbAFkhHJw7d3GAeEMOpzklFbGdUDTGgZBX4KCCOQi9KVY+a3B4PDQUy380/JNiwagDfrcU5+JPGrKlDtHJyAipTtkPXE09IC9x045qNkbhAPXCuPvJS0T2Kf8JY1qNcNKHqWh5OD9Zxi/dkrXBXFBs4X+/zEOfVgXMCnfXdIWsTbLNwsoocYb6KZJR2tJwI2TZSD3qHmuhLHk5wl0Gs9iwAdctLUD+U9IjvS3pkMGfsZmhclPpT8KSAO2+fAQNpnxsOQ6wYo9ynMZd5O9DIIcUy2sAKCHu5qnsJE3sBlLVYYAuD/nG73qnGv1LInv5qB+D8jYdqG1L6zuhpI5ssRMKkwh73a0f155oLxRVPrx/Wj6QaFjpRXQiKFBPGipzAKrE1yUbaID0qu3sJMDm9nMcpTY+Q1efsjMuk1OM4ZucuRFmnwuc+WF0fRZrwmy+sC/h02X5dKEpvL5nu1ZZiEP++QqCK0U6pbh7VQq0gvQmaY3wUN3Hvlx7qqpoFZtso15B1tSuXE/wqgRhBFkpJnbR/FPSY/5pwnKkTCXOcZX50/QnyAbklh24azR3k+pf6rJqDzOqRASAEEIQmhH8P8lL5gLbHKhn2L20yCiK6NB6ijTHUOosyHDWRYdeqPijdRq9Jfpjsg==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(36860700001)(36756003)(7636003)(8676002)(356005)(1076003)(83380400001)(70586007)(86362001)(47076005)(4744005)(4326008)(186003)(70206006)(82310400003)(2906002)(316002)(336012)(5660300002)(2616005)(508600001)(8936002)(110136005)(54906003)(107886003)(426003)(7416002)(6666004)(7696005)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:47:51.8798
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2669bd0-f6bb-4ea1-68a5-08d9930f6d7c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT023.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1635
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_SYN_COOKIES is off, bpf_tcp_check_syncookie returns
ENOTSUPP. It's a non-standard and deprecated code. The related function
bpf_tcp_gen_syncookie and most of the other functions use EOPNOTSUPP if
some feature is not available. This patch changes ENOTSUPP to EOPNOTSUPP
in bpf_tcp_check_syncookie.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6cfb676e1adb..2c5877b775d9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6754,7 +6754,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 
 	return -ENOENT;
 #else
-	return -ENOTSUPP;
+	return -EOPNOTSUPP;
 #endif
 }
 
-- 
2.30.2

