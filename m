Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93543390F
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhJSOuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:50:20 -0400
Received: from mail-co1nam11on2040.outbound.protection.outlook.com ([40.107.220.40]:25664
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229641AbhJSOuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:50:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X4N6/ndJtwnRABwvbQMO9vh66s8G5E95Nmg6eSFEAokrBIdAyW2QvzPLFVzvPTDHsdUpx79jgARyifP5ca8C9vPPUnNE6W0artPPrBJq3L5RZ/h6cb3AFAgqI2Yjr/Dr2xO1MD13bO7JOuaNRHHzwdiBjHaxIMfjfsXsqXqTyimKMczklB/Lg4eGicJNVWgkbMfosiCvDibnz1yoeZBdXjg1CyaClOhA80k+umZVAP9J5J5F68rGnYXlSNKjBj5YY/TErIP7wwGKLvPRbZ7iobgDNXohii+tOoG0WprR3txorwZkQ6M3DqqJqYFGS+/OXimoe+s/Dcr/FpoWtvfahA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jXLQ7xAs8EOu6G2zUj4E0yFOji2FUos7HtcrIt0viUk=;
 b=fib6ncjq2r8saJChd3oebAZPjywo4FDxhK/eeUpQ2rz+kNUwRvG649xT0bWSQ9KrmhjRkWScRBD3SWdERjHXBEuiENL+0CnGkW8lsiCNakHCPmvZ0w9W0qfbaekc/Vfuqf8dT2HmDckUFPdJ5TAyVYQiSY3mNaH6pahyZnTZ2Y7MV9Np/2kp/h9O6YsUfjQwMgCXEtj6k4LKbMXoPQddKSi9dAwuyjQZY5mokNBNznntDBQb3KE2umjWJ3iADNR2XmoO9cEDHiDrZQzvSBTMzBJLlZ8L+nb1nMW+HLWHiofXLUnlPUT7FpSlwf6pp6NcHD5DplKC5YQcbZSA/k6nHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.32) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXLQ7xAs8EOu6G2zUj4E0yFOji2FUos7HtcrIt0viUk=;
 b=OmhToDrlEuDsBmTgWf6cn9jqKUN4NXM0LDTmuwoKN7ceZn+fnpS/X0IZu7eh54fWk5In8ef45+mUIPCBSjaF2YcsxlgjQRlzPs6leTdEmZDoZx5xIyL47u3SZlRE0D35k9LzcW9W7d0Vl8YV9pCHdyAFd/6PaSn+4EspeaTqyvA0/IIXdeo8q0K5A2/76PuG9Dt3WY/l+3o/zhCOkBtXh9lurvJDk52BvhDrWmRhH0THyGdqiL+cwAMqNhxD6tVH8eWy/mIsVf4VrWVR65BDG+VCaowILPHm8ZrEbmYF3YEJZjNpOoeYlzvTUkjFg+OkFdxioMS+A1DiS8Cpvp/Zgg==
Received: from DM6PR03CA0013.namprd03.prod.outlook.com (2603:10b6:5:40::26) by
 CY4PR1201MB0199.namprd12.prod.outlook.com (2603:10b6:910:1c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Tue, 19 Oct
 2021 14:48:03 +0000
Received: from DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::4) by DM6PR03CA0013.outlook.office365.com
 (2603:10b6:5:40::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend
 Transport; Tue, 19 Oct 2021 14:48:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.32)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.32 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.32; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.32) by
 DM6NAM11FT028.mail.protection.outlook.com (10.13.173.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:48:03 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 07:48:02 -0700
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:51 +0000
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
Subject: [PATCH bpf-next 04/10] bpf: Make errors of bpf_tcp_check_syncookie distinguishable
Date:   Tue, 19 Oct 2021 17:46:49 +0300
Message-ID: <20211019144655.3483197-5-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019144655.3483197-1-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dbffa9f1-e9d6-4067-fb84-08d9930f7452
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0199:
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0199E769E8000F0E40711B55DCBD9@CY4PR1201MB0199.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HUDYheS+pV6nwD7bM5lIZQ+sE+Qpea1QxXSfKXbFkeW+cZFjpaL5owE+buJzw64Ld+iws2ZcAsJi5KQSRvISs0xw78ls2G8ydv2X8vgkDOoCYQE6wXa602ucJPhAryAtA5LouAMI6kwYsEwnNumrbGVcVZ543G0R7ZLJ5YSeNEuiv24yVJgePzVMc7sqWFlC8OhndOHT4GI8jFP9NNZ3LTdpuugjgf91EIUY+eNIYmLS5QyonFih7w5bls/yxZVThIgt10wAU1ZTbKt+r4nTHaB6j5u16sNa1z6+P030FwE9EbbmmL9k9SNJcimSH0B3sfE5HfrjJFjNkD/MdK/dSU1b2Wl4M0OnXBw4iN+WV6oPuef3GJ0TXtDkxZz6h9sAAe9KHiJo5/KcXbAe8s4xil82FMz8sfguJad+y4P4gh2cYfrfAbxSgvYOgp14DrAhVOJ7te94fhwXYPvYWWLkX4xtm94BWxTmRxNPUHmFqCt+ugtDWQHws4iADUaQLeJFSj3/nOf3twT/n6Qdw0yRAxQekkDmQ186+JSLrk/XBoQ05IY5qOhboPXrEfqxlaerkCcU8mG9i/8pdBn09+J+TQQJ0ULUUDJpU2z8nynW5HzPaxQaBMr3YQkn6KeFXWi/jg2iu4m+UA40SIxufhapIl299m7K9h/XC+yD8W0qm5TyUm+4nYURA/vYaSAvdi2xhX0lCMeP4Cm5eV+hjs3E7Q==
X-Forefront-Antispam-Report: CIP:216.228.112.32;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid01.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(110136005)(2616005)(54906003)(70586007)(107886003)(2906002)(8676002)(47076005)(1076003)(316002)(83380400001)(7696005)(5660300002)(70206006)(7416002)(36860700001)(82310400003)(426003)(26005)(36756003)(186003)(356005)(7636003)(336012)(508600001)(8936002)(86362001)(4326008);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:48:03.3404
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dbffa9f1-e9d6-4067-fb84-08d9930f7452
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.32];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0199
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_check_syncookie returns errors when SYN cookie generation is
disabled (EINVAL) or when no cookies were recently generated (ENOENT).
The same error codes are used for other kinds of errors: invalid
parameters (EINVAL), invalid packet (EINVAL, ENOENT), bad cookie
(ENOENT). Such an overlap makes it impossible for a BPF program to
distinguish different cases that may require different handling.

For a BPF program that accelerates generating and checking SYN cookies,
typical logic looks like this (with current error codes annotated):

1. Drop invalid packets (EINVAL, ENOENT).

2. Drop packets with bad cookies (ENOENT).

3. Pass packets with good cookies (0).

4. Pass all packets when cookies are not in use (EINVAL, ENOENT).

The last point also matches the behavior of cookie_v4_check and
cookie_v6_check that skip all checks if cookie generation is disabled or
no cookies were recently generated. Overlapping error codes, however,
make it impossible to distinguish case 4 from cases 1 and 2.

The original commit message of commit 399040847084 ("bpf: add helper to
check for a valid SYN cookie") mentions another use case, though:
traffic classification, where it's important to distinguish new
connections from existing ones, and case 4 should be distinguishable
from case 3.

To match the requirements of both use cases, this patch reassigns error
codes of bpf_tcp_check_syncookie and adds missing documentation:

1. EINVAL: Invalid packets.

2. EACCES: Packets with bad cookies.

3. 0: Packets with good cookies.

4. ENOENT: Cookies are not in use.

This way all four cases are easily distinguishable.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/uapi/linux/bpf.h       | 18 ++++++++++++++++--
 net/core/filter.c              |  6 +++---
 tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++--
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 6fc59d61937a..2f12b11f1259 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3545,8 +3545,22 @@ union bpf_attr {
  * 		*th* points to the start of the TCP header, while *th_len*
  * 		contains **sizeof**\ (**struct tcphdr**).
  * 	Return
- * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
- * 		error otherwise.
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EINVAL** if the packet or input arguments are invalid.
+ *
+ *		**-ENOENT** if SYN cookies are not issued (no SYN flood, or SYN
+ *		cookies are disabled in sysctl).
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
+ *		CONFIG_IPV6 is disabled).
  *
  * long bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
  *	Description
diff --git a/net/core/filter.c b/net/core/filter.c
index 2c5877b775d9..d04988e67640 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6709,10 +6709,10 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 		return -EINVAL;
 
 	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
-		return -EINVAL;
+		return -ENOENT;
 
 	if (!th->ack || th->rst || th->syn)
-		return -ENOENT;
+		return -EINVAL;
 
 	if (unlikely(iph_len < sizeof(struct iphdr)))
 		return -EINVAL;
@@ -6752,7 +6752,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (ret > 0)
 		return 0;
 
-	return -ENOENT;
+	return -EACCES;
 #else
 	return -EOPNOTSUPP;
 #endif
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 6fc59d61937a..2f12b11f1259 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3545,8 +3545,22 @@ union bpf_attr {
  * 		*th* points to the start of the TCP header, while *th_len*
  * 		contains **sizeof**\ (**struct tcphdr**).
  * 	Return
- * 		0 if *iph* and *th* are a valid SYN cookie ACK, or a negative
- * 		error otherwise.
+ *		0 if *iph* and *th* are a valid SYN cookie ACK.
+ *
+ *		On failure, the returned value is one of the following:
+ *
+ *		**-EACCES** if the SYN cookie is not valid.
+ *
+ *		**-EINVAL** if the packet or input arguments are invalid.
+ *
+ *		**-ENOENT** if SYN cookies are not issued (no SYN flood, or SYN
+ *		cookies are disabled in sysctl).
+ *
+ *		**-EOPNOTSUPP** if the kernel configuration does not enable SYN
+ *		cookies (CONFIG_SYN_COOKIES is off).
+ *
+ *		**-EPROTONOSUPPORT** if the IP version is not 4 or 6 (or 6, but
+ *		CONFIG_IPV6 is disabled).
  *
  * long bpf_sysctl_get_name(struct bpf_sysctl *ctx, char *buf, size_t buf_len, u64 flags)
  *	Description
-- 
2.30.2

