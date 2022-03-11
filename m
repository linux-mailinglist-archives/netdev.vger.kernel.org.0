Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02524D6684
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbiCKQiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350400AbiCKQiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:38:15 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2061.outbound.protection.outlook.com [40.107.92.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24AC01BD9AB;
        Fri, 11 Mar 2022 08:37:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RTHvjr901Rsydc+iN3Js26360mZAHuIQdlWZ/7w0qDkPIMhIOWRjp7TXJpDjno2ssrApQENHyTiUk7WkoH5I4iJMwvyKkuETjWz0KM3Jz8g4Nfgy5VA/ZXdDo5RGz9vT4YaIRWr2P6vAtk6RAY9O9YZ72WTVK1dyF8Yg9mXHB6z92txMyVCPdUQy2gLUQ9sApLVma7lZlGxAP+3848JJRSq/7gXz9MscAVCMbbOufwhVn5CXfTOBbGTqtjGIdOamWzRYmAyqsnfBtJ5HRrRDMWS99oYa2oh++Dr7tPiH/GEfZs4gH37g8btq+jlYwUs76pYLBE9Q8/OvbAhH7rse2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jW8XMeLHYiv54Rxhiq9doZJORLMH3WCZm9xJFaDyJxg=;
 b=kNuL3EHTCeqzNkBWtDooQWHDvO61BjniXY962HYewz53HsY9XpUbjeo61tmWhS+zwfMTyMrCivg+IyVytSdpf/LzcMnq+GsjKpsiyy3+Da5kHGp5uZN6fhJYOCbqiE8LxyanZNQwItBUIazxxLdhuNKGSaBgBS4z+w0ilkDeF8dHxweGhL7HIT3k2U7mIQdhHXtj0AW+L873SV5I3h7zNzXJcWaH02Z0YxibC2RA+INiLRDmzCGNsS+1QFPYH8zCf03UzPaBc6fCCh20PgKUsuhVbaH2Xphvm6YD9wu2DSqeqO3bE20Pp3ikMMzeBVIeNrrbUZ705rSK/F4Ka46oMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jW8XMeLHYiv54Rxhiq9doZJORLMH3WCZm9xJFaDyJxg=;
 b=b7ZPkTFT58lG5huSMFxYq+2DcGTpbvYhtnfOAITs6Qf7S+lG8E6Ayhjd4nqbHBKoAM8UdIYQuGIi02MaAtKgrEV6zI3kmpnjAXFox8lSqxwuRTeRTe+kl10Q4vSGu/wDpF69CP8WKV5ZxOnmKK8WbaMTFUiq37Tiiz+AlaOm984oB4BtWO/Q6LZRtLRrMrohT51Uy3+zDUGJQC3PTb1ClPuI/d4z5bmv8ZBROz5ojxPi0e+K+UHeNyOLy2Lqkuj/PJwgn4S38mNK5IRaWUmO+FUuWIJxxsZrOaa4WYBtzIulgLPEo8yy7EV4h8ySFQQXl5CBwlnVgp9XVsuCIMWo4A==
Received: from CO2PR04CA0198.namprd04.prod.outlook.com (2603:10b6:104:5::28)
 by SA0PR12MB4576.namprd12.prod.outlook.com (2603:10b6:806:93::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Fri, 11 Mar
 2022 16:37:09 +0000
Received: from CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::c6) by CO2PR04CA0198.outlook.office365.com
 (2603:10b6:104:5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.20 via Frontend
 Transport; Fri, 11 Mar 2022 16:37:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT060.mail.protection.outlook.com (10.13.175.132) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5061.22 via Frontend Transport; Fri, 11 Mar 2022 16:37:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Fri, 11 Mar
 2022 16:37:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Fri, 11 Mar
 2022 08:37:06 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Fri, 11 Mar
 2022 08:36:59 -0800
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
Subject: [PATCH bpf-next v4 2/5] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Fri, 11 Mar 2022 18:36:39 +0200
Message-ID: <20220311163642.1003590-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220311163642.1003590-1-maximmi@nvidia.com>
References: <20220311163642.1003590-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2cbe7ef8-4690-4369-fa7d-08da037d62ae
X-MS-TrafficTypeDiagnostic: SA0PR12MB4576:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4576BC171CD475E7E3D365D9DC0C9@SA0PR12MB4576.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E5bUQrnyqqdMckctLEJm05ga/A8P9EucMF7f3tY0hozkW9L9wLQD4BXpHCdygdKf4psYfbCxSeyM1071fo4jOie7qXVGvi0wiQHsYG6yh1VNgQuZUfJw8+7ZGywsRUS8ncsU0Qdd6+U39wc/XZMEH1DmNbkZ4XVuCj7hMX45SijG/qLUL76TjmLWByrS5gDJpJSetF6DYXneXhUhRmeHNqZZW2M2fdCJY2UDj19PGn0HQUM1wGrjTxkbXPljSGLhxCX2997u9e/NAAD2rg7cmsz4QzdNFjdzWu0ScUDwKnESXaUU+iq6cSx908WzPikN3wJ0Y1NV4rZN+w5D9c/E5+JP19hYrjy1taPeM6GJUM+ki7pIYtkgQUWWjNj/gaF/Ryng1BRHNALRyBWmkQUPOSMiOew8TVMvjnNT8DhYRVA66aB/R2uhp0dnmLImMc12kDSMsXQd+cuODk7Fbae9p9dZWfu06vVS5tqQSvvR96GUxHsqi04KbEya0r+qPXQtxGlXXPCDygKLX0kTwOiiI357ipJwy2p3swLY9X4yEYynefeN914gY/d55E3UhpB45UQobyBAPTCWR160PontYh7NJ0Gkx9BnNuE5viy7tzrhv7574IavNGZrc7HM3cBVPiv2tUnDvnmX6qhqFd0YbBB2/8Yk3jjPobQvGG2+8XaPOiCMQ7NBsvEgqEo1J6g7Pm7KG+gTQ2xOlhTaInNItQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(508600001)(70206006)(47076005)(6666004)(70586007)(82310400004)(86362001)(8676002)(4326008)(110136005)(54906003)(316002)(36860700001)(186003)(26005)(1076003)(81166007)(107886003)(7696005)(356005)(40460700003)(83380400001)(336012)(426003)(2616005)(2906002)(36756003)(8936002)(5660300002)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2022 16:37:08.6682
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cbe7ef8-4690-4369-fa7d-08da037d62ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4576
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 99fab54ae9c0..34afdd27d0bf 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3573,10 +3573,11 @@ union bpf_attr {
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
@@ -3759,10 +3760,11 @@ union bpf_attr {
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
index 99fab54ae9c0..34afdd27d0bf 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3573,10 +3573,11 @@ union bpf_attr {
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
@@ -3759,10 +3760,11 @@ union bpf_attr {
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

