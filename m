Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F0B433906
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhJSOuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:50:00 -0400
Received: from mail-dm3nam07on2054.outbound.protection.outlook.com ([40.107.95.54]:4832
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232568AbhJSOt6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:49:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TfWfD1o2Bp2QtmYhRrYEl+VJyq97RGb0bP4das5qSztfOCTF6CsgsSqH3PzckdEIGCND9hghzbJwO5HGJOicmaL43x7tjv0detKk1QcsMkrQKOOB8rt+ngmSBxkP7zj2xCOFH7MNUTc+KM6ISp4tZ9hz1bNMETCCXmkmo6XCrDO2HGtQncoePf+9CV3oW9KinFku2A9YWSnpA9zeh3zhueiDUqLjjGEB6dfel3vWm+Rmsxk2gjU5Zaejwuwjd3u2sPEGTDsQn6ydsTQr1NLovH3VLzfG/KMuJh8Wy61D7SVHwcr9NygXT0wHRwOX7qonal4R86XxfHOtueB+tiuxrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwTjwXxdG12o2mQxxRArAsWV4kp+J5whluLckcXufEY=;
 b=h9PEg0mZuKLHFP5VZs8PMyxlaDA5BbPsDwxZNPeg4UfUNf6/eyawky+leEGdFPlNFiJr2VzrfkzetSKaFBf5Kg/3a7PjsBPoIiUGsWVThR0XYNRSvTvYus0Onb987Eu5vf1mqVc0cziUhK9yDzkDdytiIt/a9nJqMkmbfMZ5klnOJVTFmY9whfRpmPhpoo3FA/Hq0WG39ZECC9mKvlPCAGSLo3nWWrSe3ZSksurmUr6T5FbSmg8VQ9ZMuv6zZnI41ULbFh2dvH3rONLtOXBBFJeBKPjdaDJ+d2POq7ZWLrGcHJA255KFrgMSXK8xPMOCKYds4bbt5mDWBPCSPkzRKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QwTjwXxdG12o2mQxxRArAsWV4kp+J5whluLckcXufEY=;
 b=RFsH5apj1amfKxAdkvyeOrFZitWxuYukyq507eqjwHkbsJUwpsy441r4iSuUV010lEtoXvWDmbcNEKTfET5HE73OryCegNSHpSHClB5IbGRglZlvspUMXiTppQmyccngjCs+reT7PlpCvuIArrUurWHtBDzYsoOIHiVn7rCSFRXWjxFHFZzTAd9QtXxcsieztO/C0RwmLRhFPmKZLz0JT0veRt4WAJpLseKqw/LwHhTk9iAF5RX+BoMW2tmv4qeC5Gsd5QOTUYBOdjNIAPx8LU4gPqxRD09PbijJhuAMpbIbqErjh3dWX2RSWypIeY7UIVQb9JACvOTYh2/Nn8GWAA==
Received: from DM6PR04CA0019.namprd04.prod.outlook.com (2603:10b6:5:334::24)
 by MWHPR12MB1613.namprd12.prod.outlook.com (2603:10b6:301:11::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Tue, 19 Oct
 2021 14:47:43 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::a8) by DM6PR04CA0019.outlook.office365.com
 (2603:10b6:5:334::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4608.15 via Frontend Transport; Tue, 19 Oct 2021 14:47:42 +0000
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 19 Oct
 2021 14:47:38 +0000
Received: from vdi.nvidia.com (172.20.187.6) by mail.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 19 Oct 2021 14:47:26 +0000
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
        Lorenz Bauer <lmb@cloudflare.com>,
        Tariq Toukan <tariqt@nvidia.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <clang-built-linux@googlegroups.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf-next 02/10] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
Date:   Tue, 19 Oct 2021 17:46:47 +0300
Message-ID: <20211019144655.3483197-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211019144655.3483197-1-maximmi@nvidia.com>
References: <20211019144655.3483197-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d9e9ae9-f70e-498f-a6d8-08d9930f6838
X-MS-TrafficTypeDiagnostic: MWHPR12MB1613:
X-Microsoft-Antispam-PRVS: <MWHPR12MB161308509A2C820E0DEA73E1DCBD9@MWHPR12MB1613.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vRCszz2Ht3l9BG44B4UFz+Q1OMaS+0V1EIIMF6sJDnZk7YI+Nze4BGLGog2NvDuGLgdZY14m/AF6vocsyGpn9CbibM7EPKNAVCIPV/N7/qPZ56BHYCO2/IEUDAe8MgJle9Qt92rfz7Rh2ja2DLQLN63TIpAx4KSeM2lTjYqXc9K7NHCH/9eSBrrVclWI+VFU23Hbhxz7Zt1IWyqTqaXkeaOgMIgJDxuPP1gn20rqwYFJ82+YrKvsL+smT+D+CTHI4u6+GTPuIG7N0nWMs4Qj4HQu7/Wjv1R+OrdAH/c9JU0r64EWXgHGg015T3XqFNNLHy+WzaZ9wa6hacuY0QJmuM2x86vN3eHhbRYbwmBrMu25fbI9+0Fycuq1VP/Zxfju8WEaAk64J4mh4qWpLHYQkJZ1VXOKxwZuZ2G1vlqg09XSknn2qJ9xytd+RJKMnZ1CJzBSjbtRpgJBtxIsOTOQnXdVvzQsyC9fHBpa36vHGHclYGXkN+q+Z1e2qvZ1UVwr4hM/Bya9PT6/q/Qt5exYvAatioQnqhV7d7Sa5YkcLMPNgARLPQPmwmmnZqugnJS6efJB66AG7LvtL1zOpIYP39gbf/t8xbsS288+JsDvVIn7hkO7XwfBImb1wGkSeASWRbvToA8Tp8rLtja8U+mSJJtj3COpWF+MLMwUhyt/3RIjpIbIYyatE0vVrsvkWPEo2JCyTtvwjK5d8I6D4dulmQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(7416002)(47076005)(36756003)(186003)(1076003)(86362001)(7636003)(356005)(70586007)(83380400001)(26005)(426003)(4326008)(2616005)(110136005)(107886003)(316002)(36860700001)(5660300002)(70206006)(336012)(54906003)(2906002)(82310400003)(508600001)(8936002)(7696005)(36906005)(6666004)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2021 14:47:42.6304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d9e9ae9-f70e-498f-a6d8-08d9930f6838
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1613
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_tcp_gen_syncookie looks at the IP version in the IP header and
validates the address family of the socket. It supports IPv4 packets in
AF_INET6 dual-stack sockets.

On the other hand, bpf_tcp_check_syncookie looks only at the address
family of the socket, ignoring the real IP version in headers, and
validates only the packet size. This implementation has some drawbacks:

1. Packets are not validated properly, allowing a BPF program to trick
   bpf_tcp_check_syncookie into handling an IPv6 packet on an IPv4
   socket.

2. Dual-stack sockets fail the checks on IPv4 packets. IPv4 clients end
   up receiving a SYNACK with the cookie, but the following ACK gets
   dropped.

This patch fixes these issues by changing the checks in
bpf_tcp_check_syncookie to match the ones in bpf_tcp_gen_syncookie. IP
version from the header is taken into account, and it is validated
properly with address family.

Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 net/core/filter.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d830055d477c..6cfb676e1adb 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6714,24 +6714,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (!th->ack || th->rst || th->syn)
 		return -ENOENT;
 
+	if (unlikely(iph_len < sizeof(struct iphdr)))
+		return -EINVAL;
+
 	if (tcp_synq_no_recent_overflow(sk))
 		return -ENOENT;
 
 	cookie = ntohl(th->ack_seq) - 1;
 
-	switch (sk->sk_family) {
-	case AF_INET:
-		if (unlikely(iph_len < sizeof(struct iphdr)))
+	/* Both struct iphdr and struct ipv6hdr have the version field at the
+	 * same offset so we can cast to the shorter header (struct iphdr).
+	 */
+	switch (((struct iphdr *)iph)->version) {
+	case 4:
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
 		break;
 
 #if IS_BUILTIN(CONFIG_IPV6)
-	case AF_INET6:
+	case 6:
 		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
 			return -EINVAL;
 
+		if (sk->sk_family != AF_INET6)
+			return -EINVAL;
+
 		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
 		break;
 #endif /* CONFIG_IPV6 */
-- 
2.30.2

