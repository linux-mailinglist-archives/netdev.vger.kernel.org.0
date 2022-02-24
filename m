Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAE34C2F1F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 16:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbiBXPN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 10:13:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235719AbiBXPN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 10:13:26 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D766120A389;
        Thu, 24 Feb 2022 07:12:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e14olXQs7rlEBtSyNK3Narz1pdF803WdpWd/KrcbEIO86W+3KOP38rhru8Lh5IpQ5PTDvibBKdK+6Lg9qsNkk82bOV6X33OB2fgaByrsZif0Ps6qWRfemG77p/b1hP2iA7WNxo/Y3ZtEd7K25k8MRFFcQbfjgJdpUoGR0alJlCDZ9CU3ZsKLbzh2E9MSpJZsiAf6eW4mwpurvm2hdipVYWHJ/jgfMhzFL0gkabErO2q/dyM+vmhRCnAOGKLG6arjNzNgxHfHq3iyE/FCHT4ukz6h90BUH359VfHHSy8J0YtS0Pvjy0jFv39Qva09Wz5LUjdobBFi4yeSnCKWbPPfAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2OlLGZTGT0tFee9mqcOfWJKhyqE7cIBpoUeCvZspeY=;
 b=Q3PxD27QE3BYDXdJWDkVp4Mj+mLmoo9tVTQeNB7wTvFjtu3a25Yyblhbzc3j6sYUjpSsyG/RxnIn+ZQ9mfehwFbRXPWe9OsxBNfVOnHGy9UKqk0oc45d1zgGNohf1HUiu9BPeMjsiLkitdJcNhRqjiqMMXXgijBQA1K6vhrcGERevEdupFGjmtwE3CHlKs/XLe/I9146t8IILBXKxylAwJaSUDj2zQ7X2Aaf2iDyXOyZrnlyCsvzwJpk+aTRDHW3SjMgBIbejohWq99v+CbH8V3t1n5W1Pvcv0w1R5gC3bJt3+Ipy95fYhQ8gsHrsqbYq+96ljx0IDYFFxHALJ1d7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u2OlLGZTGT0tFee9mqcOfWJKhyqE7cIBpoUeCvZspeY=;
 b=nBMgsXfDbpvm5DdaHZJT10+1Y+d4JFYMc+ninM9Cy0l7bBmna7b4N6iHU8bDo0yd186LfIwSG3OWjj1iZzFS+zMkk4fLl2YtJ6y9bmbm+VwuTUz3yvCRv7eqkjKcx2liIvsOKB8W/BP/0BiBNGdzLYrr5dGG51hfdYSW7qelRp1wPaRg4CErDOnwLKUB3RU9nE5jsTpbWzxShtgcqq9NIwZqsZhwUosPwABazJskZUP6dpiVaNsNSs160mVqbQ3mVO7rCTBZpfqyupiwX651Si8zDkbxdoF1IQ5oMyjCejLeFbpxV6WdBffYLllysMCi77FrAbI3gVUy22aiXZB0IQ==
Received: from BN9PR03CA0964.namprd03.prod.outlook.com (2603:10b6:408:109::9)
 by BN9PR12MB5084.namprd12.prod.outlook.com (2603:10b6:408:135::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Thu, 24 Feb
 2022 15:12:52 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::e9) by BN9PR03CA0964.outlook.office365.com
 (2603:10b6:408:109::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22 via Frontend
 Transport; Thu, 24 Feb 2022 15:12:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5017.22 via Frontend Transport; Thu, 24 Feb 2022 15:12:52 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 24 Feb
 2022 15:12:40 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Thu, 24 Feb 2022
 07:12:39 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Thu, 24 Feb
 2022 07:12:32 -0800
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
Subject: [PATCH bpf-next v3 2/5] bpf: Fix documentation of th_len in bpf_tcp_{gen,check}_syncookie
Date:   Thu, 24 Feb 2022 17:11:42 +0200
Message-ID: <20220224151145.355355-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220224151145.355355-1-maximmi@nvidia.com>
References: <20220224151145.355355-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5b2aa44a-35b7-4771-7369-08d9f7a820cd
X-MS-TrafficTypeDiagnostic: BN9PR12MB5084:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB50843D03594D9200524CD47DDC3D9@BN9PR12MB5084.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TqtNfr0wrqmTiiD+oFznsTAwYbsWM3QFrSgPpYnc5q7QY4P8V/lXPMaGW6m0N7v2zXw/KLwq+ZVozHA07Tgpk+yXAo5kdhmpE1CoExIr76u3RsIz+LHlWmirjLNpGHYRJhqhBPXaUxu6D6ch3rKKbGm8p2Yi1nSTGAmsCbWUJSYXkFo1RqMMvsAgqUdLR3VAPeQvLjK6vqXBmHjc7BNQmdDMf6/rtfu8Jev0ETSnmtq8Rj9Ri9kr+OZHTz0nKQ1rtop/5RbZfCCUYtz7vto7Jjq2dAS9NJf8xQMf61bywispCSZLRLlDsco10XHsbOeno8qI3EJ5GJV8eQONnPcoiiBuMc3aPZcjYxrGwmIo0ANoar5H7JnSRkPWlegSt1mnfpy4mwBjeARSO/VoIABYMckuVlYgT3xeQZnRmNa5njqQOkMu8fWPHFGP/a927Nq/rnBBdA4g8P7JSlg0XsgqQLl6FyR5UGT6rv87/12jOMCJ2zyiUANu/FGT2g8DChXSDfXfKMhDC6SYualoXn4/UISaAzFbpmMDiAZATZS33RXb5dCkQ4djX5n92BAbAq0sZCd0Iun59u8iAm0VXHPVuFAtOlYCJDZQoNEjoQjnSAh7tvvfxafcl0qg0YBQrjaI1sDsJDR6jQhkdhFKskn8FoV7fjeV3OjJhaAp/FrIleNAK2GgR/q/U23i+iMe25CHnujdJvyiXj0pbInRU5vUCg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(186003)(110136005)(8676002)(70206006)(4326008)(54906003)(26005)(70586007)(36860700001)(6666004)(7696005)(1076003)(8936002)(2616005)(82310400004)(316002)(36756003)(2906002)(86362001)(5660300002)(47076005)(426003)(336012)(356005)(81166007)(508600001)(107886003)(83380400001)(40460700003)(7416002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2022 15:12:52.4975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b2aa44a-35b7-4771-7369-08d9f7a820cd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5084
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
index afe3d0d7f5f2..1b933454bbb5 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3570,10 +3570,11 @@ union bpf_attr {
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
@@ -3756,10 +3757,11 @@ union bpf_attr {
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
index afe3d0d7f5f2..1b933454bbb5 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3570,10 +3570,11 @@ union bpf_attr {
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
@@ -3756,10 +3757,11 @@ union bpf_attr {
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

