Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3725147D5
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 13:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358116AbiD2LT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 07:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358173AbiD2LT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 07:19:26 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08on2067.outbound.protection.outlook.com [40.107.100.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766B783B37;
        Fri, 29 Apr 2022 04:16:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acP+AWs7k5LXDpWbodZngprObLEJyzIllj4vlmvfijxV8RqVYQ8vDWVlQ9edrUodqcy9VCOQdXI0St7rSmkKAw6pfmDh18LHW2Cc25umu6L/4LPvYRg9903hQa6dgRV8idrnMogIp8TrZsfltCS80gDG5yS+//N+jzKwbh2e7s0rpkWRZmU+rMRorCAO2qh9J1DMf4NVPwR66R+jiZiFmrEWeZZCr8OE1zaoyofo05DZXJ5ctm4liPKHYInJnrlNXFIuZVg3ug5k7M7gNY7wuMD0hke5wDZmWcjAzOPiMjlpGaV5LGRMZ922bvV5VkD4GqL18JlB0gKMy2HI0d35SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8jFYVXsAiIAAMpp76D60LJxpRBskdYeGC3vhq/HqfIc=;
 b=Jd3UBnA1GVrlsoS+b0+2KuqGRnklHMl0xU4+1af4T9zkW5EVztMigKMuia0CnL/np88ouG/3T4PjSIKXmS3KJ1aoyrfKJotK5F46tbJQz/bKb4Yk7cj37MOFG/MdJwERFZG+SIwukM6LzNUnfPDzprKX0zVLTMnxYOFxkP/jFtUqlvJ/3F4C2mPsGc6zejGvPoZG0N6ELm3YvbGdHjAqubAazZ520OrK2Mf06VNs9APJWU00PEe4mt4BLb7IrvfPTbr544+ABoW/cDKzNFJgnyMGkLyPrjzGR+oj31I1RvQdMB3k36HcN3X6WPoW6YopkwDrTtnWM1IT8E80Rp7IdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8jFYVXsAiIAAMpp76D60LJxpRBskdYeGC3vhq/HqfIc=;
 b=l69s7VRopA3WpOJHX0x0L7qFzwQTsP6CrMcNaqCEhArbAcWnfyxSy8S/sHa6ztLpAibgVqyoqPgArW0vm73TC6Qb32JVyCn3D4MwY3I4lcwwTBR1dfwIFGrj4L3hHxahGf8ezFQuB8qVJZfPolIaOMZu3+36mn552QBg/6CVI0FGmz2t8NvIQrR38tJ/WLkNGRErC/tqP1geFHrOqOTJU0C7FXM8LHMdoFGLbshdPrIGVtgRlm0HpjW3Vvlx85i93RXNZZ9fIeqBmwjuHTVW5bFJhuYqB0pULExSNvyrgclbs8pfmq2YqcGfn/uuNCa3UZtRakfCyAichQqsw9fy2w==
Received: from BN0PR04CA0181.namprd04.prod.outlook.com (2603:10b6:408:e9::6)
 by BN6PR1201MB0100.namprd12.prod.outlook.com (2603:10b6:405:59::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 11:16:06 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e9:cafe::be) by BN0PR04CA0181.outlook.office365.com
 (2603:10b6:408:e9::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14 via Frontend
 Transport; Fri, 29 Apr 2022 11:16:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Fri, 29 Apr 2022 11:16:06 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Fri, 29 Apr 2022 11:15:59 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Fri, 29 Apr 2022 04:15:58 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server id 15.2.986.22 via Frontend
 Transport; Fri, 29 Apr 2022 04:15:51 -0700
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
Subject: [PATCH bpf-next v8 1/5] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Fri, 29 Apr 2022 14:15:37 +0300
Message-ID: <20220429111541.339853-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429111541.339853-1-maximmi@nvidia.com>
References: <20220429111541.339853-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cea6704f-72bd-423b-b2f4-08da29d1a7d9
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0100:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB0100DCA98A0D919EC3829796DCFC9@BN6PR1201MB0100.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: quRtxsRS1SHjxaFtIpymaaSXr1OHSvuV/v822+uDNobNi4ld4JHrkel/iEhZVGr11kzTIfqwExgKUMn1o5RwKfwP3aRkpAXXCCAtyK1E0tgpfyr6j28wqGZH5s9gcdbx6cGV70Gf2Rl5vSlQMJ6lD0d0AT2wi00vY4Ltv1RJ0PFMaB0uLDEeXHfb8CUTBqE5r+X3z4XZj7fVWLDb64b1u8eHAW2pCBMBFHG0OTsojHo7sfQF3/SVoOHzbUAAnhS9TkloySAWWULtRkaX5P08Jm9b8YK+xFasqOhizXlbsksCLJZMNM+fo8A2QIOO+S7BP8Hb3iKehOZTkoITokd/MttbYefOHbfQwbgOpJowteCUXIkUFcmqa6DSQ7aCREuA3oUnbPTqJIgx+fN6BqiSHPdTxlCC1bwe+RGgG4bV6VpsaC6W0W6RZSJf/NS8Pi0/XNadNyYcnLSVA9QUtUyPDvzFSZ6FEqPbsjHyj+IQr1+wrD0wOGfzX436KCS9KBLMI/nX3RmR4S9FhtbVfGQR68RKGZ73qHptlza1jmZnxHG9tXjtjF/OEYRi4QDsiFKmYbVtG5oCKf3WNByKqoikEC+6etGiL1s7qIyOQfiNRVy9tCzFWjDaK+Jnp8oBfPjmds6ejLB8iy3f/gUy2uk7WKDbdKo20g+z/Yxqao34YJi8KeM3nr4enwpGkf/437KnIbB7lVYqypgSipTCsHIE6A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(508600001)(6666004)(7696005)(8936002)(5660300002)(7416002)(26005)(81166007)(107886003)(356005)(2616005)(47076005)(426003)(1076003)(186003)(336012)(36756003)(110136005)(316002)(54906003)(82310400005)(83380400001)(4326008)(2906002)(70586007)(70206006)(36860700001)(8676002)(40460700003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 11:16:06.5437
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cea6704f-72bd-423b-b2f4-08da29d1a7d9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0100
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_gen_syncookie expects the full length of the TCP header (with
all options), and bpf_tcp_check_syncookie accepts lengths bigger than
sizeof(struct tcphdr). Fix the documentation that says these lengths
should be exactly sizeof(struct tcphdr).

While at it, fix a typo in the name of struct ipv6hdr.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/uapi/linux/bpf.h       | 10 ++++++----
 tools/include/uapi/linux/bpf.h | 10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 444fe6f1cf35..4dd9e34f2a60 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3587,10 +3587,11 @@ union bpf_attr {
  *
  * 		*iph* points to the start of the IPv4 or IPv6 header, while
  * 		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- * 		**sizeof**\ (**struct ip6hdr**).
+ * 		**sizeof**\ (**struct ipv6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
@@ -3773,10 +3774,11 @@ union bpf_attr {
  *
  *		*iph* points to the start of the IPv4 or IPv6 header, while
  *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- *		**sizeof**\ (**struct ip6hdr**).
+ *		**sizeof**\ (**struct ipv6hdr**).
  *
  *		*th* points to the start of the TCP header, while *th_len*
- *		contains the length of the TCP header.
+ *		contains the length of the TCP header with options (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  *	Return
  *		On success, lower 32 bits hold the generated SYN cookie in
  *		followed by 16 bits which hold the MSS value for that cookie,
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 444fe6f1cf35..4dd9e34f2a60 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3587,10 +3587,11 @@ union bpf_attr {
  *
  * 		*iph* points to the start of the IPv4 or IPv6 header, while
  * 		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- * 		**sizeof**\ (**struct ip6hdr**).
+ * 		**sizeof**\ (**struct ipv6hdr**).
  *
  * 		*th* points to the start of the TCP header, while *th_len*
- * 		contains **sizeof**\ (**struct tcphdr**).
+ *		contains the length of the TCP header (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  * 	Return
  * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
  * 		error otherwise.
@@ -3773,10 +3774,11 @@ union bpf_attr {
  *
  *		*iph* points to the start of the IPv4 or IPv6 header, while
  *		*iph_len* contains **sizeof**\ (**struct iphdr**) or
- *		**sizeof**\ (**struct ip6hdr**).
+ *		**sizeof**\ (**struct ipv6hdr**).
  *
  *		*th* points to the start of the TCP header, while *th_len*
- *		contains the length of the TCP header.
+ *		contains the length of the TCP header with options (at least
+ *		**sizeof**\ (**struct tcphdr**)).
  *	Return
  *		On success, lower 32 bits hold the generated SYN cookie in
  *		followed by 16 bits which hold the MSS value for that cookie,
-- 
2.30.2

