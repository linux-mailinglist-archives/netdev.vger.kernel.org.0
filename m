Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D860F50BEC6
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 19:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbiDVRiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 13:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbiDVRhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 13:37:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABF7FE5EF;
        Fri, 22 Apr 2022 10:34:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C02dUtDRKRM1g8mAG8TRFE7Ln3uGTMPC4rjsotQyZXHT0pCQwmJb5OQX60BWB7KGC1Gd5nVmdXmZ/x6CqyhB0Aa5qXinXfZvE5+OK3KsvhQYwx1AK9G0E+1d3BVx4OEhbOBxO0lZkfgweX3hfdjLNUPWafX8P7boGIfP8QGlSHkGREAiv9BW2nOXloa9+6VkzKsmEjic2jp2SfPPRo04Z+aSbQvAkn1dS+dhsH3Z5nvWnVxtc/FNrpRk5Dda8L38zlnhyM6FU34MBAKG0bTgvxkkcG9WKA1JHa7rHpGbyyttNLuscTJ11qfCwMS45wQWXDEz5pOvXqvGhK3uVfQxBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ceeGsQYgi1i09dOkw/xW9S/NUSgxrVXoQZ4vKjoj1Xc=;
 b=TU1Q/nztvaL3tPJDIbOttBfqfiT56YjcmirMYBaDqItk9E1phO7kAZxTOa30VbtZGGRGl4EjfOYqrYGkXJ2o2eFK6B5xbVnAlZfRKT0twL3KH3NPiUecC6ZWUxXlwRUgeGiHhXvETxZNZLnbNhOdOzcdazyt8jzB2n9tYnBhhX2ccIdId71czgsD7pggfF/8UNsSMl0wOW/DstYAajDqOZXPsiFk66TiKJlHtlfdbmNU47lqOIWWiTomN7gwX+mPQf9ZAiIC3DPAy2+0I5va6gA8g35krQTkRJRaeO+FN0j1+0hH35fD3S/1I47VqgLA0rZHGA3f+CXSYex2Klx8QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceeGsQYgi1i09dOkw/xW9S/NUSgxrVXoQZ4vKjoj1Xc=;
 b=Udo46AraQfap0sbrYPJTfACQs+4TR90j3riSv1tM0yvo0ZTD8oqBLILw9WwpsJxjGiSZw9z5v7I8HYqydKmRtg06hFyb/6JwnG9l5l2Ey3l8Jdi785z8DHirS7QnJZig/5plI19swldpq/EgbKCn3KPp2sfhhr5CJI7iQxA/vhIvEPtxH4Z2RYu4NSYBYrkdzQ3TmPXrqgdPA+YRtcMq3u8o7HqBBzz8VD8gKkcdFlfp9r+WgyZCUr2DEWa6Xs0DqzByDxrGHG92KsYTsJX/PB6/xpRrGP5GDfgL1i6U6X9hIUHdxTgZEfA+rKBl0tIHKP7OND1ILKOOCjeDmZ4WgQ==
Received: from DS7PR03CA0355.namprd03.prod.outlook.com (2603:10b6:8:55::30) by
 MN2PR12MB3822.namprd12.prod.outlook.com (2603:10b6:208:166::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 22 Apr
 2022 17:24:43 +0000
Received: from DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:55:cafe::9e) by DS7PR03CA0355.outlook.office365.com
 (2603:10b6:8:55::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13 via Frontend
 Transport; Fri, 22 Apr 2022 17:24:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT034.mail.protection.outlook.com (10.13.173.47) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5186.14 via Frontend Transport; Fri, 22 Apr 2022 17:24:43 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 22 Apr
 2022 17:24:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 22 Apr
 2022 10:24:42 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 22 Apr
 2022 10:24:34 -0700
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
        Florian Westphal <fw@strlen.de>, <pabeni@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next v6 1/6] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Date:   Fri, 22 Apr 2022 20:24:17 +0300
Message-ID: <20220422172422.4037988-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422172422.4037988-1-maximmi@nvidia.com>
References: <20220422172422.4037988-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ff8327c-80a7-4e0f-ec81-08da2484fda0
X-MS-TrafficTypeDiagnostic: MN2PR12MB3822:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB38221B096CBBC8548740E2E6DCF79@MN2PR12MB3822.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +OkCaQOo9KH/cV45tzLBu19NIEPiE0zZllH9N/ILm6xEod/BnWn6Uotno3N7Gdmu7J3eQ3Q7PwXyzGQeV166vcIoEhr0TA3Ku9F2WPSAdbYgR6bso+/511fhUioyCY8GjrL5CUV1fv9KsNzO+5m8f1AicQQ/IWTOV7vcJVv5PHtnlrVsLkFCCfGCjsKhHYFjZXAR3yqNmoiz8nWYi74aQ+718aGkPVfvB89jLsI8/zwFWvCM6+okruN6TXnYVdGvsKV+ymCQzaI3W4qGEpabG8dnlwrMgiu29sXFqhDLo/ANEwxonIj3w0tICS9qyk8V6pqpO6pgZszoIixShvc5yvuW0qMQQDNC7pinbMMqHtR7dNyiXcWnnm38f2I89UIfqqpBJNw8CZlN6QMpNJySTzqQ0bXqklI1PpsAuKS8J5j7zUZLvkArXKtoF/xKMPIMZyxlnvfKcwGT7PazsYyKteJbUSFHzWK9YQ69nvPnbGA1SKwYr/bNMMOh4yKyRcXMwSY/iKATZ2fvZIk1zSUZ9BPBvxBm2f1x+edzRsVSN5LyZGUMt9JBqnkV/zPGt6rSRflbE0uZBlwfg+8wg8UVCQid8o1+gj7xCckNAsF3CS2aeXU7p1Duvw+Z+WYuSYiIEOywdKB+1bqXCotoKDo6DX1F7yCgConDjzcwl7FEFJVRKwMUFjFwFKbwYDAgowQkByMuSiiPWmCPwaxw0x0AaA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(83380400001)(36756003)(70586007)(1076003)(70206006)(107886003)(336012)(2906002)(4326008)(86362001)(8676002)(316002)(110136005)(54906003)(40460700003)(7696005)(4744005)(6666004)(186003)(81166007)(26005)(426003)(356005)(508600001)(2616005)(5660300002)(47076005)(82310400005)(7416002)(8936002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 17:24:43.4717
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff8327c-80a7-4e0f-ec81-08da2484fda0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT034.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3822
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 8847316ee20e..207a13db5c80 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7099,7 +7099,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	 */
 	switch (((struct iphdr *)iph)->version) {
 	case 4:
-		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
-- 
2.30.2

