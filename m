Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895FE49833F
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 16:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240631AbiAXPNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 10:13:07 -0500
Received: from mail-dm6nam11on2055.outbound.protection.outlook.com ([40.107.223.55]:9569
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240599AbiAXPNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 10:13:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VvjND9qc0R2Wn3SQnmnqimdxIDKVuosSTXaeArUubariNbX1EBpJbmv45H3w9iMjnkCWdRnbawHt0GZBX2Uh4LSreZxu6Jz1ReeNU3lvlbusH2VUcnS+8O8fJgQvvltSDJbqCU95sSGCPGE4phPPIXkgv/Di1psQjBwVeV2jeXgxtKJdcyBANqHlUA8seg4gXwKmSIsDUSahBy1ZNt1U2tlQRW6kVNCDx7aZ2cftGGJRDLrmFSR2f1Tj+Aa/ncaKItjKGp3kWt2kI5vTgvL6637InwMhJ0jtzI9HGxCxeZ8zWqSCNqOKYidVO3PfokGSnyxt7pP808lDayTn//zctw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sSLrECum19GVLxu/U2hMa+5Up5hqR2wp6WVRVn9cWyQ=;
 b=OxzDRTMBh5yTFBH04J+dvl0oqIdMY15H3uUfpickWgA1yvj5Hu3cDxfPSW37o5uB7x1dEKsvYTuUhJlxfbKK+TgjkX+c/ujuw5wtOKGEDQwHNmv7tR0PE/LgTekBFo47ixtcN1ip+mBGQaB/6j7qSHwuLQaef3iNRuHEJK9e1FiXt6V8ez0wXesy8yryR+Rhrw6/Xia9PWgLs3HeGvnamS8Bm9UuNkOwjIM7ezbO57T8qWSiN0+quzoGQrRxKexs/g7RNJRYm72VEhM6rCiC0J2puRCODPe3zffugUxfvz6ugr7FjsTUcs/wzbuuqLFiZYb+2yv1ZGJ03kM49SwPNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sSLrECum19GVLxu/U2hMa+5Up5hqR2wp6WVRVn9cWyQ=;
 b=lPAJwDCztyTIeQqr0mjeqOh9AlmUW4C8rUtafAuf4RgdLgrdcjJL7H3V1DmADK3T9aBE0GiOv21KpWbH28Cuxb9LGoRK+0gPPd8vhbgjeM4+Wm0hNRgnrEZBFf1n9bc5sYNoUP+To7/yGzcDHE5UMiU9BwKZuhAL4L5DuVBV/D0tlzjomrXkdtLANtwIddSNN1khIui4Ub3akj7xvxgFkuV0JxxkkUVj0bS6f4sI7oIbbnbnfi7F1WRDJUqVO9bIeIyV0ajDUWRb+C2Xhp1VNQUO7tu5jSieVn5GncaeWm2BUsGmYsbF80AqM2WQyO1LoS1N0ABYhd2HU9boOGoDwA==
Received: from BN6PR17CA0005.namprd17.prod.outlook.com (2603:10b6:404:65::15)
 by MWHPR12MB1485.namprd12.prod.outlook.com (2603:10b6:301:4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.10; Mon, 24 Jan
 2022 15:13:05 +0000
Received: from BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:65:cafe::c) by BN6PR17CA0005.outlook.office365.com
 (2603:10b6:404:65::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.17 via Frontend
 Transport; Mon, 24 Jan 2022 15:13:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT061.mail.protection.outlook.com (10.13.177.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 15:13:04 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 24 Jan 2022 15:13:03 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9;
 Mon, 24 Jan 2022 07:13:03 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.9 via Frontend
 Transport; Mon, 24 Jan 2022 07:12:59 -0800
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
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf v2 2/4] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
Date:   Mon, 24 Jan 2022 17:11:44 +0200
Message-ID: <20220124151146.376446-3-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220124151146.376446-1-maximmi@nvidia.com>
References: <20220124151146.376446-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0b425d60-eed8-4180-6853-08d9df4c0537
X-MS-TrafficTypeDiagnostic: MWHPR12MB1485:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB14850D499BF947DC3B6526D7DC5E9@MWHPR12MB1485.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LP1qvGe6SOlKUXjbNcovjWx042CBj3WGQtbbMlbyTomy9yY/LGtWYvOZTdCoLH/X9EGlaufdYdiK61jLegc7swOjqQl74Wq9JJmOEWtV2unGwXMWZPS7FFh2CQ0M1BonueZr1FJVg+RvD48JtUuR1MisbpMVx0z/xhW6ZDmXH3HBPiaJVo+aFlcu4qcBTEv2LdoWf68UviIIXT7vZ5yOLvKCk+376mBxaVpte0fPjNac+IEXFPYLyjzhN3R4clE+QpqCjwgBGu+P+41Ci7C9A1x8hAbnfAtomEjumt1eTut5aCveebNpYQCR/hQ7vM+hE6EEFan6uMlEAC4rkovv1OrqUeNL03Heps5/MlLOBkwEay6fJ5flNneTIiBd8+IT7+CMmpJoeFsPzeN1/TLJKMsIqUvsve8noruYu12HLn0m8bDtNFQtzSoe0IPv1v/hR6QV2W2VQYzmdXLR+Sc2XsaA/ONZg+9OGKU0g41AWthXGLG014kXlxI67DM7yEwqRN5GtyCpT3LN9WZK82+bmaqQ9t7moSvt7OOge1RLshIzpRShpaIjadzFNFyFoqyPMWqDBaL5zzH4PxzrNFV5x78jPnC4tkAQOkOB38EwxlXRQ0lzJlWmJypkGvGF+NxOezFDhR5P6ke64bt4rBJB0LdVvID2oELwc5wR/G/Q9w1wbH27QRpmyzZa2iiX9sX73iwGl+3I0Mv/ZCVxYYaVnE5aP/ju6zZTryBW8JA+MSvxAFT2oMgxTe5BxXsPUhAMfUZzOQ2Zx6FZ8ux01gaFrwsYRBURkLB9oiYYQWCg8Yw=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700004)(46966006)(36840700001)(2616005)(316002)(86362001)(107886003)(426003)(40460700003)(7416002)(36756003)(1076003)(54906003)(110136005)(83380400001)(82310400004)(508600001)(8676002)(36860700001)(70206006)(4326008)(70586007)(47076005)(7696005)(81166007)(186003)(26005)(8936002)(6666004)(5660300002)(336012)(356005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 15:13:04.6099
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b425d60-eed8-4180-6853-08d9df4c0537
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT061.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1485
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
index 05efa691b796..780e635fb52a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6774,24 +6774,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
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

