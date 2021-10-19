Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31BC4433900
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbhJSOty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:49:54 -0400
Received: from mail-dm6nam10on2078.outbound.protection.outlook.com ([40.107.93.78]:37089
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231250AbhJSOtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:49:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dwIhJaFPf25JklXDlUI1s/5M3JHN7laa0OOAH59d3sOd5wHF8GRuZAZjIla4iWw+Foj7xOJY7aYg5CZY1pytaNdvDYJnwc6NzLNZN6alX02DMNyOWB2tZdCRFNRyZjLsGfFsE5dclkNnBZyzDx+3IJTV6DgAevH6Z9kI0pbn4kYfMcURt9uLo2G5wQBH9+chqJWtvo5L6nQuRV/XS+roCoSojGRzwhM56LXwvcTm3ds6tTZfSwVnbc7QfOymoRJd+2Fx37VjSxMqk0+XqSOLdXblPqMtiUMkhWzDDgOgE3wtf5EwmZphoqVnNjXTmsnu/WPDaAhk/Y7UQyxV8/sIpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7DpgvEwdn7iizPr5bjsqGU1PVBCFESrVJBDSlHkEIc=;
 b=djPwJEdyy8zmsIl8qteJxnZtgumh9gF4nBhYMpq30P+R7rzABQipcuYzWI5WGH5XyrL8c3v2HSuTIKsgzLcT0H3RJ/MyaJWeTFsndX0ZYtKf0dZw/A+arzL7Mwy7B0j4xjWESX5FlYqvihpvEpWeJtwYm44Oi0O+SWbK6KdwkgP1Oe2u1OwaY6dOWimbGoI3cpQ4HptwxGhVEZbxhEIrp1gcu1s3dZRi1y2vLrc3S5oq5xbyifjlG0QbNRQH44h5V7jnl8OF8oQRXAAeVp7zoUMzpcuUoGeiG/02xUxjlv+b949Xz3deqv3BoqsaCHGQVgTYBSIwwXJK0yPtjp6zXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.36) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r7DpgvEwdn7iizPr5bjsqGU1PVBCFESrVJBDSlHkEIc=;
 b=Pg+4s8SMZ2MnFi4WxX+FASrRzA0eisDQeXFsEE1NkwefAL4EIkDI0SX7zEsISxGPHAhcWPAXpBqZEr51xwqu8HsfhzJcVsxv2lsnLggxuz2+OHQH2jol4jgeE6K4oYJEwjw014VisfAm8bmxR/fuGQLB4o4FGXV8gCk6UZUkG6nPd0QAx80GZ/NBw3AsQC54lZYkhmJW9Sdg2z5YG9sT1pchxl5JScs0YQqo2VMFAMV1x8ISEusX0WHtwQawK+e/BOyd1FZ2OfPY91lX3eTDKfWi8YEWqFdpGSBgEONh1UWqu4gj1S51R+XmdBbI7GWEvSKIkMLkqafYQqy7BC5Gxw==
Received: from MWHPR03CA0013.namprd03.prod.outlook.com (2603:10b6:300:117::23)
 by CY4PR12MB1893.namprd12.prod.outlook.com (2603:10b6:903:127::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 14:47:29 +0000
Received: from CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:117:cafe::b4) by MWHPR03CA0013.outlook.office365.com
 (2603:10b6:300:117::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.36)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.36 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.36; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.36) by
 CO1NAM11FT015.mail.protection.outlook.com (10.13.175.130) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:47:28 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 14:47:25 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:14 +0000
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
        "Lorenz Bauer" <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next 01/10] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Date:   Tue, 19 Oct 2021 17:46:46 +0300
Message-ID: <20211019144655.3483197-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019144655.3483197-1-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0474ccf-f881-4441-2713-08d9930f5fbd
X-MS-TrafficTypeDiagnostic: CY4PR12MB1893:
X-Microsoft-Antispam-PRVS: <CY4PR12MB18937DC0B9CAB612DC68C2A5DCBD9@CY4PR12MB1893.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1169;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v4iJwkEB1OyZtb8PyVTAMSwGyfTWV0rKqSi5INKm4KpMQ0KIp7/P5jvquKlQjsfJpSuIxOBlq/QktDjxXtVUbsoLX1y46qpCe3oLd7cuyzgvf5SQMEJtruWWqA3XnnbVqitLgh1kNsEHY+LXVKw5duHN8mIWmMJinoGnLKbzbS78rlwQ9PyClXyQZnNfmfRemAuC8TPwIEiE5fn/hJOn+VBKYPMfdT4Wng/CJZP/VIs/RYzxMdfUpolfqND9heS+Iv5lTVgB1Yq9c9YG7Z+miRbfGcfdx7SvHXUPJ8RP3W/oLxtJhIImtWbo+k7b1vsubnHytFrxHh5LFm5QkiSfZR3FCmkkqQ+hKtDMHw+cCwVKQ/6vkU7z4syUxDdrHeEFNL4XcmfzrVPkdNWQY9fvLgqa+LMLhVNaPw68e56vE0BOeykYNXmYQSWQvaNGrB852suNhndb8pNceUqVosYN+xAvUfaGCkqiQhIkEdSpUB9gRXedWBpHxLfcteJCDvxSqTHrfFITQ67pWSsLNu4IoFNM/CjVUrlsY4mZF8N7nOXyWlBsEdPxf1UJxrjrFZGjUJiP0qYwv7qMwnf7/KSDWZjMNpOHRabFAbx+2Y+cIwXHTvp7fTk5wHksI9MI6aSt50B/mMjq0QFRrUffnkGTS9GDdMizFYGURuQskg790hcLa8ATElKQ1m6s2S3mB4CH5XxgVp8TwrrmowrxtJaZbw==
X-Forefront-Antispam-Report: CIP:216.228.112.36;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid05.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(356005)(316002)(36860700001)(26005)(7636003)(7416002)(54906003)(186003)(5660300002)(2616005)(83380400001)(110136005)(2906002)(8676002)(86362001)(508600001)(336012)(7696005)(8936002)(426003)(47076005)(36756003)(4744005)(107886003)(4326008)(1076003)(70206006)(70586007)(82310400003)(6666004)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:47:28.1115
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b0474ccf-f881-4441-2713-08d9930f5fbd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.36];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT015.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1893
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of querying the sk_ipv6only field directly, use the dedicated
ipv6_only_sock helper.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4bace37a6a44..d830055d477c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6788,7 +6788,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	 */
 	switch (((struct iphdr *)iph)->version) {
 	case 4:
-		if (sk->sk_family == AF_INET6 && sk->sk_ipv6only)
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		mss = tcp_v4_get_syncookie(sk, iph, th, &cookie);
-- 
2.30.2

