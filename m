Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D884C2F17
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiBXPNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:13:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiBXPNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:13:05 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4341F208336;
        Thu, 24 Feb 2022 07:12:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXKsM11txYjlENqefhIX6LoTCi+Ia0kMmYo/Uxz2xN7+HBSj5M0x51loR7WJ6xWHudOj5AhGVpOAZ6EKk6Ih7Ie3hL1YS34CBWkWljnTbR40vJXgWDZ8WdO4QGLvp6anrlMQBjnliC72WoYClnT7VEFxSz1/iXCpwAv2oG2eeuD9bO9GW+yBBeVIjx0vMDeoLrUc4aL1u/xdmpjSirHpPXXaUq0afVE1b3idMc0WiTLuajnWyiYDircxEuyTfLtC5kK1MvoA80RW0+BRzu28dTSeCkdw5cIiV6zCU6uPpjMrh4Os0KsGODVu6HBrhMUq+xjqrk/Pu0LliWFEYtTKiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzYDJQFTQ+bPA/fNPuLw+mpTN1oMl0HlOp87YmlWGR4=;
 b=V4aAMJCuWsZzF3Y35Y6aRRYdliw/mkHvBTnroZGVLKxcuPfc/bjDpc3ExttEZDmRxklrVcmj1ObS0YLMdo8r2pzwG62IfpQX6TV3Pq7qqlfqOXPZAJwOIev66PjNK1oxQ8XhFOCryASBFsMpnFdJgm1a7JwGVEVGvwuaYK1YaLHJZ5vb4IlOtEHu+jiXFE5wYcf6qEceOq+rk1oRe+ERTlHg/WRWvGDZHxOJtwyIPquE91mQTz8e8Ck639yxc+RxrmgwSVGwDC33REPRklBBkiX1Wvs6DoNQhd74MQEyNg/i4f7ZrnHka5huO2WSJZ6sZgp4tF5Fq3ZG4aCxtQh1eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzYDJQFTQ+bPA/fNPuLw+mpTN1oMl0HlOp87YmlWGR4=;
 b=QkbtlJ2m6KXR5bmvJumGA/api/LHkXP8t5XLF9DVUfiJ3gk5Wz6n1TroNzZbZ51cSc74SUb/s0kX2mOTTOjqZngo4UG+6Wln1Z9Sa8dc+bhczPaHrO2yIgOLFbhoLUOn/HVBDBvVYWwWUTcaxvysQszpXNpgnW814IGMo577wXvqPzzr9gAK0MgStpdq9BacfNvT0Mf86U9prgwI18Wo3fxeCq69cHWt6DD0J1oV1ZcpTiFjBe/xZ0JjD2Mg7/sAVjKKhnbbQ84rMO9s+f8WlRWCf96/tH1zB4mzgjt07z/pR6VtFmfHTcJmjqPChSsY8O5icVKkCYMbveOxEdZaww==
Received: from CO2PR18CA0064.namprd18.prod.outlook.com (2603:10b6:104:2::32)
 by DM6PR12MB4403.namprd12.prod.outlook.com (2603:10b6:5:2ab::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Thu, 24 Feb
 2022 15:12:33 +0000
Received: from CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:2:cafe::7c) by CO2PR18CA0064.outlook.office365.com
 (2603:10b6:104:2::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.19 via Frontend
 Transport; Thu, 24 Feb 2022 15:12:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT058.mail.protection.outlook.com (10.13.174.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 15:12:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 15:12:32 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 07:12:31 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 07:12:24 -0800
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>
CC:     Tariq Toukan <tariqt@nvidia.com>, Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        "Nick Desaulniers" <ndesaulniers@google.com>,
        Joe Stringer <joe@cilium.io>,
        "Florent Revest" <revest@chromium.org>,
        <linux-kselftest@vger.kernel.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH bpf-next v3 1/5] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Date:   Thu, 24 Feb 2022 17:11:41 +0200
Message-ID: <20220224151145.355355-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220224151145.355355-1-maximmi@nvidia.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e3029334-861f-42cc-2b9e-08d9f7a8150b
X-MS-TrafficTypeDiagnostic: DM6PR12MB4403:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4403DC5F94FF55B07716A867DC3D9@DM6PR12MB4403.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5zGqYYpNd1rCyInuVdjYHWvjbN3+vG5zSr+HOPQUw0LzEvnvsGCgrw48Qytg0JCGupZrZ4jCuY4H+Iod5DYyjH7YRSAwbEUyqiOH9o1UCJeCEkCs+OTokTGfyQK53LcZFfjrV0TFJnVQtbBUbLQFJH1mffwyH6FyB8zbi69TRe5Q2RczoApugNo8hb7j6mZbj0EdD6mEwfByoH5aXYSWzeFcMx7DVn9NqqbFnkXvf1zo4WDqwQMWVmBHFPgu/xemHt2uY4DnftzPrzp7/gcrjaTtH2WR85NVRN6tdJbq7XdAQELKFBLY9NAeOy6ujgm2PNAPjXHcRv5F7nUOzvd3RpUzj8d1UvKLds1g6vYClGJlQQ3uPJHS5b1OMtbDcuNWu9zcdPyNAw8/XwwFuAMD/z/x+0PQqtVif0w2/zyQe2m92Oiu13OWiiAVuRg9FoEL5rtRMx7JWiSV3B+g4IY8EWg8twXh6J0vfCJv/ChjJ0uidJUSsjBPKUnRsYMdCXHX5Z6Ezo+XCiJZvuK3MBm/HPDJiSVr+shvd/gpuIwdVeA7JIXDLBB4P+O5a2bxbbtAroIPPfRykex0g5NJ0ud+iQ0NTbyNwWtkB0s45YC/LLCrJhbGsTg6j/39e1Fzn/GINSd7x4AZdHiry2lmscA6ZMJeVYQDkB6wMCw3MlrwrnhRxC1Cro8MRRSruIsVLk0jc8gdazy7vgMlfHj3+TSXjQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(36860700001)(36756003)(54906003)(47076005)(81166007)(316002)(356005)(83380400001)(110136005)(26005)(426003)(336012)(6666004)(70206006)(7416002)(5660300002)(8936002)(7696005)(70586007)(4326008)(2906002)(8676002)(82310400004)(40460700003)(86362001)(1076003)(4744005)(2616005)(508600001)(186003)(107886003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:12:32.8162
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e3029334-861f-42cc-2b9e-08d9f7a8150b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4403
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of querying the sk_ipv6only field directly, use the dedicated
ipv6_only_sock helper.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Petar Penkov <ppenkov@google.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 65869fd510e8..0edbfdc8cb24 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7090,7 +7090,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	 */
 	switch (((struct iphdr *)iph)->version) {
 	case 4:
-		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
-- 
2.30.2

