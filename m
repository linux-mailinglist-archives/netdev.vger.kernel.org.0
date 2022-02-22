Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A93C4BF6AA
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbiBVKwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:52:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiBVKwh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:52:37 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 473185B88C;
        Tue, 22 Feb 2022 02:52:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cL/1fo4x9sZazBz7knysznEOlOe3XBcDEuWFKODsVMizcg8snUtvJSaCIJRwAfQQBFJEhmUAmgcEJ2HzMD2oG4co9+P3OzgcdY0i4E8H1OGS2AEeyJzHBhLnCE8J6EhTWc8WWVJy3quzRTdBY5W0uTn33XTuyCZT62gBwTL3V+AYvEtSdOEjm2pwS4PdUE6p9O40KYRZT1IDVW2TnvyZrg50MXbvR/SAdy00T3/4n3LV/vMrY/cDP4gtWgLPj0J7AQ16YS9+k74nB3HzqtfXZk2+1utuUYu3caM9QQlkZ3WgQBrXfrYtC/3xgWUdwkPnbHgsiaTBno0akFq7OU9cGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uxY5urqF0ZRoaIJY32ui6uCPpx+jOVsY6iaQ+UNX8o=;
 b=nLdDvr7R/DnRI8ZiVmu9Ms23VCliyB646M6RbAyV8wKvIzUECR+m1itXqT0gXXM33zDJi9AON1A90hQSwlxql6mNxCnfDBFWPwvGACFllo1TywZtzjO/FCDiNyAUnlwiw+5ieyDfLxjjG5agCkQkTcgvWx2e4fWztnrR498oJy9b/X2MD18b/Z1+Wv3kfzR5pA4t7PkcVuKRyNTH94nWFadYVVCPrx88lYNvnpNwTILEp+1YnU6HhYT9zOjGrzXa2lg5TnbIeEM8LyBHYY0UKSkrGo4eE+maFbYTqIDdywKorZ8jpLX/+HxfAIfOGqD0qA/l1/N5IaQDhUXNrX/K4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=fb.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uxY5urqF0ZRoaIJY32ui6uCPpx+jOVsY6iaQ+UNX8o=;
 b=neRY8UCSTS6/OGBxdIT7X4lNzlSNqYBmo5YLbxfBe2/Ps956n8Mg17PaMpy7ZgHT7cBG3q6OhMUDn11ZYOq0/Cms4+kTBB/TpvHiSwAq/2YDE00aTjVcJZpgrlhodYIOI0m5dJ6NdxeP/f2amBaa4cAoEYNji6SfKAvkoJtuhgrdyjJkB9ii0co9snhzEnxDp1VkiQi+3n29NxO5UFJ1oM1EvJ9cIpw4gcXz5QUAwLynD65kJvfiYnpOVn4Bl+Wvt1RRwKpn/5PXZUyMujAiOexEVtpbKM3Bw03EONxvMruDHgv/tMjfIhNh+J0bwxg6uPHe0S3aOZ2SHti1ZPxAug==
Received: from BN9PR03CA0725.namprd03.prod.outlook.com (2603:10b6:408:110::10)
 by DM5PR12MB1739.namprd12.prod.outlook.com (2603:10b6:3:111::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Tue, 22 Feb
 2022 10:52:09 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::42) by BN9PR03CA0725.outlook.office365.com
 (2603:10b6:408:110::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Tue, 22 Feb 2022 10:52:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Tue, 22 Feb 2022 10:52:08 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 22 Feb
 2022 10:52:07 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 22 Feb 2022
 02:52:06 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 22 Feb
 2022 02:52:02 -0800
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
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [PATCH bpf v3] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
Date:   Tue, 22 Feb 2022 12:51:56 +0200
Message-ID: <20220222105156.231344-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5d40c75-aa0f-4215-515d-08d9f5f15fa2
X-MS-TrafficTypeDiagnostic: DM5PR12MB1739:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB1739B86A7B9F8198ED484BC3DC3B9@DM5PR12MB1739.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q8TxVzV1ey4IJuNh3hHUfaIc23bETGgMgmO3MhnWY3EzqNLGTTT3pSSRd9SbPHVtQpubRID5/Hcee9NcYrupVJ1EhBmNruUnYsXqxQyfA3P/uaesEJSTxBHl674BLa50GeYPB0jidOllG8L+LAdojga/hVcfnuWlkxGyAsIeEOy8NDXqWD18gAwuoN58E63O6lY7UkaB5MkYZesJebNE2DS3xD/CSrxw5DYqZoXTB27hS7Cflg/fr4nRvewbfDj+PzRIP99g/XRIiaNBIidDCzdQXkfHJUpvXUbG1xNwx+kFKitky+DNJNRVsDHk4iRV5jTznRq7p1xdCUq705595oeqzcxClcwu5QDkEWRT6Si5DtYBbo3WGK7M1x7Jg9HB69aGZnOtKyIXLs3VP0TxXmR/PiOxeZcH3cJLs9uzs1GtZpZFUgAUW27E838d7BL148U6N4VOA2NKOicJ0XZJmn+dZJHr8NDOkfeoRtv4XttaB+WX8guSobbjpkY9J4+R/Kp1h6hPo3qcxWkfOg00M17GI4c76DX/BcnhaWkfUFqoA3K+HWYFTqlvwlG7YvM5fqH6eJIrUaF0/1MGTH8L3KXUKxuwdv22dPGbB7TRn1QezozdCQHJ8bxRUzmnjBtmbcuxIDOqVNDLfW1leWps6iXOyjkt7aTMWehgH+nW/gKHGuW0cszPUlT+enECbfiI6j+mFOU675ymqNDkLjSiIA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(40470700004)(46966006)(36756003)(6666004)(2616005)(40460700003)(7696005)(107886003)(508600001)(36860700001)(47076005)(2906002)(7416002)(1076003)(5660300002)(8676002)(4326008)(110136005)(54906003)(8936002)(26005)(186003)(316002)(356005)(82310400004)(86362001)(336012)(426003)(81166007)(70586007)(70206006)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 10:52:08.6907
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b5d40c75-aa0f-4215-515d-08d9f5f15fa2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1739
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 net/core/filter.c                             | 17 +++-
 .../bpf/test_tcp_check_syncookie_user.c       | 78 ++++++++++++++-----
 2 files changed, 72 insertions(+), 23 deletions(-)

v3 changes: Added a selftest.

diff --git a/net/core/filter.c b/net/core/filter.c
index 9eb785842258..d1914c5c171c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6777,24 +6777,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
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
diff --git a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
index b9e991d43155..e7775d3bbe08 100644
--- a/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
+++ b/tools/testing/selftests/bpf/test_tcp_check_syncookie_user.c
@@ -18,8 +18,9 @@
 #include "bpf_rlimit.h"
 #include "cgroup_helpers.h"
 
-static int start_server(const struct sockaddr *addr, socklen_t len)
+static int start_server(const struct sockaddr *addr, socklen_t len, bool dual)
 {
+	int mode = !dual;
 	int fd;
 
 	fd = socket(addr->sa_family, SOCK_STREAM, 0);
@@ -28,6 +29,14 @@ static int start_server(const struct sockaddr *addr, socklen_t len)
 		goto out;
 	}
 
+	if (addr->sa_family == AF_INET6) {
+		if (setsockopt(fd, IPPROTO_IPV6, IPV6_V6ONLY, (char *)&mode,
+			       sizeof(mode)) == -1) {
+			log_err("Failed to set the dual-stack mode");
+			goto close_out;
+		}
+	}
+
 	if (bind(fd, addr, len) == -1) {
 		log_err("Failed to bind server socket");
 		goto close_out;
@@ -47,24 +56,17 @@ static int start_server(const struct sockaddr *addr, socklen_t len)
 	return fd;
 }
 
-static int connect_to_server(int server_fd)
+static int connect_to_server(const struct sockaddr *addr, socklen_t len)
 {
-	struct sockaddr_storage addr;
-	socklen_t len = sizeof(addr);
 	int fd = -1;
 
-	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
-		log_err("Failed to get server addr");
-		goto out;
-	}
-
-	fd = socket(addr.ss_family, SOCK_STREAM, 0);
+	fd = socket(addr->sa_family, SOCK_STREAM, 0);
 	if (fd == -1) {
 		log_err("Failed to create client socket");
 		goto out;
 	}
 
-	if (connect(fd, (const struct sockaddr *)&addr, len) == -1) {
+	if (connect(fd, (const struct sockaddr *)addr, len) == -1) {
 		log_err("Fail to connect to server");
 		goto close_out;
 	}
@@ -116,7 +118,8 @@ static int get_map_fd_by_prog_id(int prog_id, bool *xdp)
 	return map_fd;
 }
 
-static int run_test(int server_fd, int results_fd, bool xdp)
+static int run_test(int server_fd, int results_fd, bool xdp,
+		    const struct sockaddr *addr, socklen_t len)
 {
 	int client = -1, srv_client = -1;
 	int ret = 0;
@@ -142,7 +145,7 @@ static int run_test(int server_fd, int results_fd, bool xdp)
 		goto err;
 	}
 
-	client = connect_to_server(server_fd);
+	client = connect_to_server(addr, len);
 	if (client == -1)
 		goto err;
 
@@ -199,12 +202,30 @@ static int run_test(int server_fd, int results_fd, bool xdp)
 	return ret;
 }
 
+static bool get_port(int server_fd, in_port_t *port)
+{
+	struct sockaddr_in addr;
+	socklen_t len = sizeof(addr);
+
+	if (getsockname(server_fd, (struct sockaddr *)&addr, &len)) {
+		log_err("Failed to get server addr");
+		return false;
+	}
+
+	/* sin_port and sin6_port are located at the same offset. */
+	*port = addr.sin_port;
+	return true;
+}
+
 int main(int argc, char **argv)
 {
 	struct sockaddr_in addr4;
 	struct sockaddr_in6 addr6;
+	struct sockaddr_in addr4dual;
+	struct sockaddr_in6 addr6dual;
 	int server = -1;
 	int server_v6 = -1;
+	int server_dual = -1;
 	int results = -1;
 	int err = 0;
 	bool xdp;
@@ -224,25 +245,43 @@ int main(int argc, char **argv)
 	addr4.sin_family = AF_INET;
 	addr4.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
 	addr4.sin_port = 0;
+	memcpy(&addr4dual, &addr4, sizeof(addr4dual));
 
 	memset(&addr6, 0, sizeof(addr6));
 	addr6.sin6_family = AF_INET6;
 	addr6.sin6_addr = in6addr_loopback;
 	addr6.sin6_port = 0;
 
-	server = start_server((const struct sockaddr *)&addr4, sizeof(addr4));
-	if (server == -1)
+	memset(&addr6dual, 0, sizeof(addr6dual));
+	addr6dual.sin6_family = AF_INET6;
+	addr6dual.sin6_addr = in6addr_any;
+	addr6dual.sin6_port = 0;
+
+	server = start_server((const struct sockaddr *)&addr4, sizeof(addr4),
+			      false);
+	if (server == -1 || !get_port(server, &addr4.sin_port))
 		goto err;
 
 	server_v6 = start_server((const struct sockaddr *)&addr6,
-				 sizeof(addr6));
-	if (server_v6 == -1)
+				 sizeof(addr6), false);
+	if (server_v6 == -1 || !get_port(server_v6, &addr6.sin6_port))
+		goto err;
+
+	server_dual = start_server((const struct sockaddr *)&addr6dual,
+				   sizeof(addr6dual), true);
+	if (server_dual == -1 || !get_port(server_dual, &addr4dual.sin_port))
+		goto err;
+
+	if (run_test(server, results, xdp,
+		     (const struct sockaddr *)&addr4, sizeof(addr4)))
 		goto err;
 
-	if (run_test(server, results, xdp))
+	if (run_test(server_v6, results, xdp,
+		     (const struct sockaddr *)&addr6, sizeof(addr6)))
 		goto err;
 
-	if (run_test(server_v6, results, xdp))
+	if (run_test(server_dual, results, xdp,
+		     (const struct sockaddr *)&addr4dual, sizeof(addr4dual)))
 		goto err;
 
 	printf("ok\n");
@@ -252,6 +291,7 @@ int main(int argc, char **argv)
 out:
 	close(server);
 	close(server_v6);
+	close(server_dual);
 	close(results);
 	return err;
 }
-- 
2.30.2

