Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB524FF7FA
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 15:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235856AbiDMNoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 09:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiDMNoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 09:44:21 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2050.outbound.protection.outlook.com [40.107.244.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D2060045;
        Wed, 13 Apr 2022 06:42:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F9sJ4cBkHCC/l1CRG/C9gTNeOxRJ/G85FmbFiCBghIdzpQXeNQIjWX+G+iYq/jcfA1BiBmLW2adHSrE4yOXcaeeFgl7hVwrJuomRSkmbUwCwjyTxtUANP6WKqyUHlI1GUCLPFPdG9M2eMaSA4rt08yYxLoTK9TyoZcCSCqk4y5BpxGQn8mePfpPbmNF7qvvExnSWAE6esqn/EsTd7cXlrYHihvsiCyLk8az2w/iveNj2KX2Zj1KlZzKk+Fpj/3791yytRkU457UHORgIWmT20hpPvrJjjzEx739RLS1auC2vMFMVV5QfFIEogXNuwkQUGGsuICT4aIC+hkzTAjBmMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VkFNJL+nACgSCZ8KkBlp0MLtTWd/4VSTt96dbH8ESg4=;
 b=DzjZpE8PoEKutHinMGbXSPCcxUtzn2SDEX9YAFb48/WM/Cjwn+VXOZFlkFeeSlM0vsMc1gLklwXCK+rOL67U3wlmz9ZIU95PJyyyQuzDvrkHSUMUl5ZmU5vpUo/gKnTg0d7lH0L2T01j3NcJ/YRGO1Ss/zMEKtTpYfB9XNTJLnjgrAGbyepWKbxGRmDQmwzQ6fGbPpVVFYjESFpRsrfqW58cr8oQuhH87c0vx3vnVNMbIN0xyW40v1MAfj/3Xi4sejunvOUPiA/KNUxJ1asMK1IB8ds4RdtLxdiE4xwfRlUCj2E7T8Se10LhfAKtfCnlxjHk7S2pQghwDyd4299zmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VkFNJL+nACgSCZ8KkBlp0MLtTWd/4VSTt96dbH8ESg4=;
 b=apkqafbNI3bB/V63m+YE6Qqewmo+te/BEElTrm51qFAzfRu7bQibr7lBCAsCEJWWam/x+9J7dC5a9ZnrDQ34h4EOUVGSrNU/tXBj5EoFyKJ+niZgyLAexwH/L/pDNU26n8juzXxJs0fPkgu5u/N7uqW77qKs0CbCEaR4+r4BnVSLRKZtux1Znk44Kj3wv0ISzgmcM27cMxw8um7t/gAsgYDfOB9QiWT2CeeVCtkwExzN29aPlN/TtwjtZyNrtmu0yygJ1+/G+JcyAcA2tr4ySOi8uteyEDkb33YoWig9dUwb9hWztzvfEpakD0KrlbQNHaH/5Qbx/916FUoun+kCxg==
Received: from MW4PR03CA0011.namprd03.prod.outlook.com (2603:10b6:303:8f::16)
 by BL0PR12MB2356.namprd12.prod.outlook.com (2603:10b6:207:4d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.26; Wed, 13 Apr
 2022 13:41:56 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::e0) by MW4PR03CA0011.outlook.office365.com
 (2603:10b6:303:8f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20 via Frontend
 Transport; Wed, 13 Apr 2022 13:41:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5164.19 via Frontend Transport; Wed, 13 Apr 2022 13:41:53 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 13 Apr
 2022 13:41:50 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 13 Apr
 2022 06:41:49 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 13 Apr
 2022 06:41:43 -0700
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
Subject: [PATCH bpf-next v5 2/6] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Wed, 13 Apr 2022 16:41:16 +0300
Message-ID: <20220413134120.3253433-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413134120.3253433-1-maximmi@nvidia.com>
References: <20220413134120.3253433-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c46e0b8-86d4-4ce2-6524-08da1d535ed1
X-MS-TrafficTypeDiagnostic: BL0PR12MB2356:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB2356B88F706EC69AB9859ACBDCEC9@BL0PR12MB2356.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VDqtxjvh6hFzxx+7pdS6y54jNCHTnc+ozGdeD9VzM/GwHShHItADA/DEHH8gFrq/mDd0hpCuZDf71a5iqHxGNaxHdA6Z03WXirQugRZU7bWC5HgM1247X4eYRYViLGiW2hHYFTgrnciLqH8qA30InELlMCOn6VKdg5jneIwNWUl3OoZGY7p9rypYQv2CW1di2i5gBKzNjlA0Wwri8+umjpcqz+KNXFr+CJ3yF03ty7Q1QRh4gy8rWNjhV/jTN/Ag5Cj+gwoxjD9/S6UaJS/+ztAD2A9TMFYgg813N03aRrwKW27wLMtgWBfggUoULA6I5WqPNVEg5Utv8uQURD0JCjpP1QFuOMIbGASf48DNT4M9XqemK95gqre17YyM+n0meP9iu82cnskm7Tyy4QzdRtrbpOiYPI+OpfdqCmBXczSt/VdcpdrQdR4ZkvRTpZlYTgLJZ2Z7Pwb/7IziAmO/XVhV3P2CUEl8lQPQaHhwfNJ5rkgtnvW72AhZvDlCJ3GjMX1NKC4hQtswDbl2i5+XTrqE6NQpn0oZcg26zFrfMQHmM57j42/DNYb9fgycvBrfpKDRlmrGB5MOP0B3SUk1Sk1JHLHDCIoiHxO1DlIdBJDb0JQF9Cf/2wIV6YjxykNoDJ6a4wkom+wyAe7uEaR4DDtAN3iG9ixkposfvWC6adde42vuT8zpI6M277vaVcjAhR8gemWH0BSheTEpN6dBKQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(8676002)(2616005)(6666004)(426003)(7696005)(5660300002)(7416002)(8936002)(336012)(36756003)(186003)(2906002)(26005)(40460700003)(107886003)(86362001)(1076003)(508600001)(4326008)(54906003)(356005)(82310400005)(81166007)(110136005)(47076005)(70206006)(70586007)(36860700001)(316002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 13:41:53.5837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c46e0b8-86d4-4ce2-6524-08da1d535ed1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2356
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index 7604e7d5438f..6ca3c017a664 100644
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

