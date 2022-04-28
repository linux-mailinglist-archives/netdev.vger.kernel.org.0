Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676D75138A2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349293AbiD1Pm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349273AbiD1PmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:42:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA77B6D0E;
        Thu, 28 Apr 2022 08:39:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=edSC3dhnlzRjoXYi5KymnjGx8qYfNLse72FcUOUI+vc+fJd5fEVXAf0oksGc5wh0gxJvM1lqzlT+McxGJWOwKxdGiAVMpB+bGjUn0ZcfsjQvgETH9KEDecb+nrKD66K3evaemaZmrIbaB/59tgyx2m3LkmZjYZLjxu0+eSKOVPxjXYPEMLbHy/OPftutF1R703Tde4x8XBAfNNo8/Q7vst4KvBppOGs+yjjS1JQ1l1VuRu8jUPFO4E+FTA9itJlWdJH09jUZFaCDIOl/HBg0UN9bV5pEYjJc5WvzTYS/YhPBd6Wsjj/o18TR+HkPe9x00nVPhwsLQk6kToDZQZuJwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hFQwhPnaKv6Borx7fkXbGSMbgkP1qrsQyquN1OU7cpw=;
 b=G3uhXBX5gUNqQfYdwwDemDx+fddkvS46NB/Kzd7BFqBQYy+1vaA1i8bwa2/RlRTuVf0fHheq0A5MG5XG9AtE2qz+27V4Sr2JNljc8jK2Ldx7qeSCwcTap2X6D0tG56gqe9+ea1KwIgAKzh8REWGJ/4etPLRWYSh6nlcr23fM2sx2TmbcJPav5IdTR51VO32wg2bd2WF9eTSw8uRAR6T/HtKLfwlYBtg+SWQcOB8GnpV/s17cBsCKTtUR14nlP9Cx2A1jpD897cEmKEfub3s/gm65yaCT/0G7XMGnDobXwBwY5/012+zBwO9laZcYR7N9tXrUdyASo5j/h0NRY+qmMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hFQwhPnaKv6Borx7fkXbGSMbgkP1qrsQyquN1OU7cpw=;
 b=ffafOe3g7nMVv85s5cTSSkAkXCgKh7f5zpMAr6Q1DvY74uOeTJRC11xFNg6gha9Am927BdosUvJ4rp2zf6iYE7aPnkaEhOWpQWHzk8hUTnViHQwdLy5/MdhuiqV61AVX42F2k9M1Euk+IBLa8XVSF0L7bafuC+eL6tVHzehIcmlMOkhlWPBRfYQ7RcXeelnwymJ2faqC/fj/F0uLDXqAqTSPcuTw4550r4ZPJaTXyha9Dm0w7gha9Ec/bfesvl2FqddNyD4EO72gshgGcZE03PpRkol9tU51aBMJz9/Hw1GiN+Gh5ezjv+wGiv4tBW1aYnHJozP54bghHLydKqPRjQ==
Received: from BN8PR03CA0024.namprd03.prod.outlook.com (2603:10b6:408:94::37)
 by SN6PR12MB2638.namprd12.prod.outlook.com (2603:10b6:805:6f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Thu, 28 Apr
 2022 15:39:01 +0000
Received: from BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::65) by BN8PR03CA0024.outlook.office365.com
 (2603:10b6:408:94::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.12 via Frontend
 Transport; Thu, 28 Apr 2022 15:39:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT055.mail.protection.outlook.com (10.13.177.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 15:39:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Apr
 2022 15:39:00 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Thu, 28 Apr
 2022 08:39:00 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Thu, 28 Apr
 2022 08:38:52 -0700
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
Subject: [PATCH bpf-next v7 2/6] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Thu, 28 Apr 2022 18:38:29 +0300
Message-ID: <20220428153833.278064-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220428153833.278064-1-maximmi@nvidia.com>
References: <20220428153833.278064-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9d934a50-3652-4cf5-85b0-08da292d3804
X-MS-TrafficTypeDiagnostic: SN6PR12MB2638:EE_
X-Microsoft-Antispam-PRVS: <SN6PR12MB263840FEB1C1CC2C5E670C4FDCFD9@SN6PR12MB2638.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VBNLMQgObgd6Hmuwp7RLmBZVYLjiOOQ+Hchu3MvlqsUsxEyD2pMnFg6TKLZqwUOfLDdVUVNrJFpplvhvfzkuzF7POr4YbUgPiBhsa9LgRw8YXKu2cHnbKSJl/nSJBlo3WP17iVN9AVBxJmUx94Ua8dXLnEMiho31n/aKbo6kkvd1W2QzzVLFLitdlLL45fiQH27xzXcAzUCdMF8mPGd+swQmvzi88TYMKx18q/zuhKlHaYlBfw7/hIU/9HvOTvxiqHSbn2Q27nby1uTH/9EDR/MusCyEpQiGkl9cj5bvOl3mJwCjGbjz9tunyIvnvGrLGWsSu6KtkC3ZFmnhlRzhd34Agt/EMoV2vXTdoKLF4wSsMIt+5GHDUkwqFr7Dg482Y6ZsA5Uk9tObeJae2YcjogS62K7cYvPCsHJkB1HvDRe6LwgROcEadi06xieuhKSUwngRy1vkGs5lEK0hulgl63VRX4NNgLSi1iHjtPbJw0Zfc4rOLXff53PgvuOCCMy39yyLT3HtJw12B4UDJIvzeZcUPE1N4EcYiN70mxUxXPh+VHxpoum1tnVE2YO/Sy+ZwHiZow+MNTqnnUNYjx0Utk6xA6L/OQyf9SECI554sjEuCItw6MQ1DpZHzRBWDkbVFCufPCOt5MtS3ZOVAQfqT9lHi1LNpsMapfRcfGjCW0DsSUamsltFCsO1GaOdRuD8/TspO2U8/qf8iBT31U2ZSw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(82310400005)(47076005)(7696005)(316002)(426003)(336012)(86362001)(36756003)(7416002)(26005)(186003)(1076003)(40460700003)(5660300002)(8676002)(36860700001)(83380400001)(70586007)(70206006)(107886003)(356005)(110136005)(6666004)(54906003)(2906002)(4326008)(2616005)(81166007)(508600001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 15:39:01.4559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d934a50-3652-4cf5-85b0-08da292d3804
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2638
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
index d14b10b85e51..5e1679af8282 100644
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
index d14b10b85e51..5e1679af8282 100644
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

