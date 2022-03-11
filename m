Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4992D4D667F
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350558AbiCKQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:38:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350499AbiCKQiG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:38:06 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2086.outbound.protection.outlook.com [40.107.100.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B031BD9AB;
        Fri, 11 Mar 2022 08:37:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FdLByx/XwGSZyxaacBS8MCX4cQSHu9tz/mbhUxU15OTJNuyZ4w8aVt6iaR+A1pS8DWHpOxFLWWCACHkK+DBGPd+C0AnipqHF3e/uGH5cqRe6r8zxNdhw3AxuKlCEtemin1exDDTnzTYKhBFsAk8Mz+LnlXX5H9LbWP5FmejmQPHKIb5lWdFR/MCCQPxnY2Hi0N+QQ7KZMUyIPw2EUpZ85xKB1+w/9JWSSYOrcvWjpB/ps2ThTXL+Wm2VlE2MenE3FJTIThI9wLe9bzJUVtoD5rOmELwhYsqRcB9FMbUcwHJAYKXZN7CdVq4MFA8jRn2afEjb93ADOgBsUNt7fhUhsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=enCbGNAmpoTTpSdJG5zSmC8iYXIsq1XalQxVYL3DMoA=;
 b=eASYnj1Ap2/N2egssOQ8rIXP9NR52F382//PQBvk1QkymIZIgqjEydCnyxTtrZHXxf4ebPAMckDViNGwta5SaaVLk2DJ096RyVX2PgYQ1kvRl1D3OvR91YFLwr9rtGCI3GAEji0br2c1J1j17gNCJ5KBgmgqmbHEgw3mXkNOn7RAXXjfRKlWuAiyxEX7GMoKLyGLbtEp2H5koyyXfeEKtjpSkLVIESaBCVxdTwW6Fhryi1mNwVs5i8Hf5g/NENeh8g9pHAw30Vy6zKVpcZgSpuetWVVXK9vF+1YiD8xjejAUFCovfuzAJxwjvg1JLsadcrKCkBz4Ogg1yP4RG0LagQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=enCbGNAmpoTTpSdJG5zSmC8iYXIsq1XalQxVYL3DMoA=;
 b=pDhIMKgHT2phMuTNhU03amJz8kwPcn2oW9TAOA3mYS1RFTCjl9T4psGiI9kKXzpLCM4sHYvPnIFbC9271fyuj0p/ffv2cbNzGuulWtKYPRT63Zq7GsPkmRfzniDFO5cDzomJpwMl5MXmpQeT/RRS+FN9HjHkNl9g6/h4O/tE3L8bKzMTbIMeuzbC3Owa8QCFYAK94TUK88/BgHSdKvIfXWP5okYZUzzm93fWkhVSZ5W/XgSLYjSDEqG9fKNZhFN9ykzDrr/k8yXfPiPjGRY6howvnhDT3OnBW10sruljHZwQhmDOury0ZQMPgKpFaQRY/XtFI7pvYbuAvwmdWeNZtw==
Received: from DM6PR03CA0078.namprd03.prod.outlook.com (2603:10b6:5:333::11)
 by CH2PR12MB4971.namprd12.prod.outlook.com (2603:10b6:610:6b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 11 Mar
 2022 16:37:01 +0000
Received: from DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::ad) by DM6PR03CA0078.outlook.office365.com
 (2603:10b6:5:333::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22 via Frontend
 Transport; Fri, 11 Mar 2022 16:37:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT012.mail.protection.outlook.com (10.13.173.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 16:37:00 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 16:37:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 08:36:59 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 11 Mar
 2022 08:36:52 -0800
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
Subject: [PATCH bpf-next v4 1/5] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
Date:   Fri, 11 Mar 2022 18:36:38 +0200
Message-ID: <20220311163642.1003590-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311163642.1003590-1-maximmi@nvidia.com>
References: <20220311163642.1003590-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6414ae86-a4c3-4d50-9a20-08da037d5df9
X-MS-TrafficTypeDiagnostic: CH2PR12MB4971:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB49714FC7614E94D776DD6F79DC0C9@CH2PR12MB4971.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jwBtW/oT4E/8/HsNuUWo8OEguB29kx+ynbRHrkcMNMrBm6Xop/Kg/YjuOlsfpEVE8zHaFKOooMmpnqYjR6+wFn9h5jiETh5x22nt+ke9UaMz0WLEuYfchj7tUJTCZXYU/dS3622Q8eU2HliVictWl+0LhVE5wAGGdCimxqV9883zGv3EAa721B8nQDwpM2qdsqz2H6fFfx5hbO/1RXHQajaYyEe7Hl6gltMJFK2RyIg+pAcuYfNP9KbNitrMg6Dt+SKiCHHlvADPMDh8m+ff6+VuXfYDS/x77AazlMG0wLfGfojQ/d/uALAIvl91GB0qMTPCFyypNbJ/JDNDjZtohGUiRzGs6I/hJ/Ubjb/b+WPdIu+tBO1AoqxDl5wOdSQuXKmijFi7MbgfiZx3oiIIuunPhqvUnSD2mM1d+zX4fE7vLAEOG9ia/o/TKB/3uiJuxLgGlMq4n+tYGjX0Xgn4nIssz9zQVDceiMcRkw7RMgXKZiHPg1jx6E7SA7L/pR1A4B3ovqMVbz9Ny1oCFI9Ja4QSXhmB+/TydatksVk4DDBhwLAGARxhX7lSUm+6q/3x0jmO1RzrfLBJPGGHxpaKa035scazqqCQlmpWLNGoX+omgnyBtiOfQO3WN6ef5VH1AJtmmDSjlCFJVL6z8xxrmiDjg8UtYzDx9TpqhethjujfFqGJHAK+8KozRoW9w4wDO0hYhb+EdfmVJNye0ipVCg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(82310400004)(356005)(36756003)(8676002)(4326008)(70586007)(6666004)(81166007)(70206006)(26005)(107886003)(2906002)(1076003)(8936002)(86362001)(186003)(2616005)(40460700003)(7696005)(4744005)(83380400001)(7416002)(5660300002)(336012)(426003)(508600001)(47076005)(36860700001)(316002)(54906003)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 16:37:00.7687
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6414ae86-a4c3-4d50-9a20-08da037d5df9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT012.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4971
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 03655f2074ae..7d896c14e20f 100644
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

