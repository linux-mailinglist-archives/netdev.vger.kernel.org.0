Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86090498349
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240646AbiAXPOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:14:00 -0500
Received: from mail-bn7nam10on2068.outbound.protection.outlook.com ([40.107.92.68]:16128
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240645AbiAXPOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:14:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+JMFppverX5VkXOaTBGHi4XlZFsVKbwDCGoPPvRW3lOYZNzajpOo2TxbUFM7tSbxpVNEgJBc1woKTmwZTlW9XqFU8ZHuyK28Y/Us93C6r9YmhngPLi9QpP30MR+ShwbC6U8uzwxae1uTujCVXfoR66C8YhPg3XiusU9DpBCdFIpvJoahVq5csqd9KRWkkQtcuYF+k+gVjK4Bue1VmGXUXaxAKLQIA3CVmaPBUkEOctXbu5AykcFNtBZhBj064VA5G3olCZPT52lFkNZNNJeKrBDsvGzhoP5VBb8idPS+C90uw+TIP37M+hYuiU35gNmZBB7GQFrGtHgv6HN8ssLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jJz1E4q8IHEsNZme2+SFHc9hhOK+bUU+3TJh2JtlVzQ=;
 b=WuDICP60Y+fWiQF5IObmIobcwP1LgfGxJiVog0zL3Zelqx//nFeMzyXY6+TZWOQD7u+ZYg+vyxEPVyItCV08z5xNofbbBJB2UO+MqugcjFXG+4qlCF4tq3AOVr4ByeHoYZUQvy9lJmV20Laoq/TOIj1LOm1Qk3fITuPWfVHktBYYvZ4CkxTjJZG5i57AHaC00xTkbJdlu0GeV7QDoqjSIsoghwvGKjxdWdKGqWRdG41FlQ2ACOjndgiXyIo10Ebi0MK+QEKOh5X7Mo9gHRlRuzwKw2ZNH8UJgWyVqnHbpI9Sbgc0zgFl5p+2d4e94Xfr6jsO6KdqbfJ9ZNwFWB/riA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJz1E4q8IHEsNZme2+SFHc9hhOK+bUU+3TJh2JtlVzQ=;
 b=kWCTNRK6BRJ4M5QRrJ8TIGmEXzNzHCSzUnivqeg5u6Wsfh2A/ekZ0qO629KYdSWebbv15R2jHiedJR+0DIWg7XmrRDLCEaVAUoN1oNYF56h7W5+iQ+v83LOJ63YMVqeasCoVDCWbfk9rRiwyxbCrosNMUVNp4gjoTzarUFyCC8xoBN2l8EAYXWKjp/DPZILSBTOXBogkJCFRDGGyNQswK26gTjgo/5Sq6NbSTiR78jxfUHLv0smggRd83rwoK/q5WNqf/Fx7+ED1VMeU6OOGL2poy/ihzQvNL/mibt6VF48uSPBjEGxhEEOlsqq1pnghZz6nB+uUFCDdAnQwLstpsg==
Received: from BN9PR03CA0216.namprd03.prod.outlook.com (2603:10b6:408:f8::11)
 by MN2PR12MB4221.namprd12.prod.outlook.com (2603:10b6:208:1d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.12; Mon, 24 Jan
 2022 15:13:57 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::fe) by BN9PR03CA0216.outlook.office365.com
 (2603:10b6:408:f8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.11 via Frontend
 Transport; Mon, 24 Jan 2022 15:13:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:13:56 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:13:56 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:13:55 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:13:49 -0800
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
Subject: [PATCH bpf-next v2 1/3] bpf: Make errors of bpf_tcp_check_syncookie distinguishable
Date:   Mon, 24 Jan 2022 17:13:38 +0200
Message-ID: <20220124151340.376807-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124151340.376807-1-maximmi@nvidia.com>
References: <20220124151340.376807-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c3c499b7-0aaf-4a66-685d-08d9df4c2460
X-MS-TrafficTypeDiagnostic: MN2PR12MB4221:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4221C2F63C1E03071DA5C647DC5E9@MN2PR12MB4221.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lx6MS+VfNk6YqfSjBWqABS2NQIbYY6a98/Yex/qXS+eKXwWg9FFC5ZMVs7Urk8yrg+5VynuVdBlRV/ojbMMB66PsLZh8XogL6YzZ7//vG6KAzxDGuUOjMZy7pCG7PpDQAsiBLYtDT+nz8uomaE1r0zjN0/xts+wm70B6kukXsilg0mjeIHAPUkexOZuX2Z59jetqypaoGsG2czT4myA8nsrCqPspDAba7objTUaFy6dRrFPKXY/JRwSKu9MLmHbNdpeQP/Mw7x7CQjjM2mgw3hcaCAaBNSIEAxOcL0Px7LLLtDhMBUMHbiRmTvFou18QQzPF0Ganm+a/28qVifwMz3+YrSNwYgFLmAD6hYA0WQAY9KRYp1VCgI307TayUo1WI8lcqlx0nVC61KZ4gWul8mCY7H8fj2f5cOHFZ8CJhGFbdKWSrDnt8LgyhJ0qimbiN9SoiMJeHkCo/8Qftyx88D+JynQOHj6VdgjmtUK9hnt4OHuDTr/mUbYZKw2DI74w3mucRpkkiLs2opdM9KMdgeRO8zvy0QBpxFMnYvQEAtmXWFMdSswnXHaFXaVHotk0pEfPQQoNpxTpT1nWrZwP4XVi9TsCmjE8L7Hg2FfN/XBxZa5wBjsVPRVqXM+oaPLYW6KGHPKAa2Qrk+DIXzhH/u+x+n0RMvAlBquC3aZH9WI4bgqWUwPJG8C+cq6N5t+blEMWHktHKPaf7nxoaRvUJRc4SpyEGjshekFeFeFUpqrEUOJy/sjOlp5iHU1k7v3ghDDBH7OJaygoudeFdnq36rP6TYQ7ozSRASwL3GggDfA=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(36840700001)(46966006)(86362001)(2616005)(40460700003)(336012)(8676002)(6666004)(70206006)(186003)(70586007)(7416002)(47076005)(8936002)(107886003)(82310400004)(2906002)(356005)(426003)(81166007)(83380400001)(1076003)(7696005)(508600001)(4326008)(26005)(36860700001)(36756003)(54906003)(5660300002)(110136005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:13:56.8723
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c499b7-0aaf-4a66-685d-08d9df4c2460
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_check_syncookie returns ambiguous error codes in some cases. The
list below shows various error conditions and matching error codes:

1. NULL socket: -EINVAL.

2. Invalid packet: -EINVAL, -ENOENT.

3. Bad cookie: -ENOENT.

4. Cookies are not in use: -EINVAL, -ENOENT.

5. Good cookie: 0.

As we see, the same error code may correspond to multiple error
conditions, making them undistinguishable, and at the same time one
error condition may return different codes, although it's typically
handled in the same way.

This patch reassigns error codes of bpf_tcp_check_syncookie and
documents them:

1. Invalid packet or NULL socket: -EINVAL;

2. Bad cookie: -EACCES.

3. Cookies are not in use: -ENOENT.

4. Good cookie: 0.

This change allows XDP programs to make smarter decisions based on error
code, because different error conditions are now easily distinguishable.

Backward compatibility shouldn't suffer because of these reasons:

1. The specific error codes weren't documented. The behavior that used
   to be documented (0 is good cookie, negative values are errors) still
   holds. Anyone who relied on implementation details should have
   understood the risks.

2. Two known usecases (classification of ACKs with cookies that initial
   new connections, SYN flood protection) take decisions which don't
   depend on specific error codes:

     Traffic classification:
       ACK packet is new, error == 0: classify as NEW.
       ACK packet is new, error < 0: classify as INVALID.

     SYN flood protection:
       ACK packet is new, error == 0: good cookie, XDP_PASS.
       ACK packet is new, error < 0: bad cookie, XDP_DROP.

   As Lorenz Bauer confirms, their implementation of traffic classifier
   won't break, as well as the kernel selftests.

3. It's hard to imagine that old error codes could be used for any
   useful decisions.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/uapi/linux/bpf.h       | 18 ++++++++++++++++--
 net/core/filter.c              |  6 +++---
 tools/include/uapi/linux/bpf.h | 18 ++++++++++++++++--
 3 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 16a7574292a5..4d2d4a09bf25 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -3575,8 +3575,22 @@ union bpf_attr {
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
index a06931c27eeb..18559b5828a3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6998,10 +6998,10 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 		return -EINVAL;
 
 	if (!sock_net(sk)->ipv4.sysctl_tcp_syncookies)
-		return -EINVAL;
+		return -ENOENT;
 
 	if (!th->ack || th->rst || th->syn)
-		return -ENOENT;
+		return -EINVAL;
 
 	if (tcp_synq_no_recent_overflow(sk))
 		return -ENOENT;
@@ -7032,7 +7032,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (ret > 0)
 		return 0;
 
-	return -ENOENT;
+	return -EACCES;
 #else
 	return -ENOTSUPP;
 #endif
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 16a7574292a5..4d2d4a09bf25 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -3575,8 +3575,22 @@ union bpf_attr {
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

