Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B73D4EAE84
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 15:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbiC2NcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 09:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233731AbiC2NcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 09:32:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C952AE15;
        Tue, 29 Mar 2022 06:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oPBJdcTsYz89B9JfTdMxmEmqdgHm41Psy6CO6PMvhzuZAX51382+zIr3axktQv3FugVSkDgTwCBxqhOJKswmP4lFj0Ba5ez/5Pe4eCjI1j4yx8f8Aot+yyY4efLaMOO65xERGf8O+apOoTFX4txsQLAspFmFX0oir/ucL9o5kRRdqbh+W1sXoF/T2ROVme+3qNthNGCvT/6dNL2f7hdV0nWmKeHrmXDasCVOjbuzUurDxscbzUA3tyG1b8zEVTJXLSxv7uRI3tmQSB/F3N6Qi7lTB5jdPgaIWku+sn10eNBoco/TlQPR2YFMfosuioq54jyFqhD6fXG3sq48hMAq4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Woslcw9dpy+GTWhEoQev8SKaJo4gNEvOYk/jAk7bcwQ=;
 b=F4ar9fv80JbhDF+b2vehB0k0BXigMOXTa4HLPdGKBtKhFn7ooy0GH32fsfvDcTImDOVBjc18SyjqSxdB0krABr0FQIc2URzDG5sNvIlf+R6e9RTjbFS4vN+miRCZa5NdDHqUWwOWs16clL9g0scoqPR/ikHyyApLsnXb/285fZ9bL64WCsaOH9ia0SSFfI8NBtlNiXrhEMkX2P62+chDno7enEG9dcQthxw2Rgz5hm3HZlk51qWJ191oGgLIifYdan4EfX/CWEBJtNpAvEGHJMrUgRMbhJ0uJ18rpzLZzgm/fo5R6PdN+eF9SWOSsE2TJTD7rJpxA+pW29BT0ELtsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Woslcw9dpy+GTWhEoQev8SKaJo4gNEvOYk/jAk7bcwQ=;
 b=IQr0CO5fiZwr4fu6gaak5sgWMSy/sbjmGF4QC4Ir08XnUEkOCi2n5Y2aKf0TFZmulS5RDG29tUwgSA8dw9jMEVk4MP14lT9WUiHplUIpfJ4xwFNX7vxHBb5t/DkTSdyhJaI9RynZYD1NqGyRaGLxQJZrN8rHrgpgm/ETyyyBR20oHukiY2i/sP875hY5SCs3rupr2pwv8RPu1UIJESZmjVY0tJdntpWpSbswxKMZrykIS6neEOvULGp7HYCyBzIPLv5csBUgVzMMRoHdeYz8xCvRAr2sEwjecVIaHTWlntwWyOkMQGrmOwLXLtdB4f9w7w0BUZgp1BjTv6ZDnbbaaA==
Received: from DM5PR13CA0044.namprd13.prod.outlook.com (2603:10b6:3:7b::30) by
 DM6PR12MB4121.namprd12.prod.outlook.com (2603:10b6:5:220::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.17; Tue, 29 Mar 2022 13:30:26 +0000
Received: from DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::d1) by DM5PR13CA0044.outlook.office365.com
 (2603:10b6:3:7b::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Tue, 29 Mar 2022 13:30:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT054.mail.protection.outlook.com (10.13.173.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5102.17 via Frontend Transport; Tue, 29 Mar 2022 13:30:26 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 29 Mar
 2022 13:30:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 29 Mar
 2022 06:30:24 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Tue, 29 Mar
 2022 06:30:20 -0700
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Arthur Fabre <afabre@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Maxim Mikityanskiy" <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH bpf v4] bpf: Support dual-stack sockets in bpf_tcp_check_syncookie
Date:   Tue, 29 Mar 2022 16:30:01 +0300
Message-ID: <20220329133001.2283509-1-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d917046a-1363-4855-95ca-08da118848d5
X-MS-TrafficTypeDiagnostic: DM6PR12MB4121:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB4121EC75E42C7E3FC0E30492DC1E9@DM6PR12MB4121.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oba3PvGD3Lm1WGvdsKo+FWPNXIyQGYbXvTm9gXHRcFgUk9+PQXTOSIDgK6zlIyM26tLDci33OS0lFcPPXKvbQqS3pyPVTI8u+E0Mb2w30v81qzKTFAHVmCqGv2I40+tye2vEXmIGMDUXJk0zuYjvuX5yQYxsmOoRO5IJepEzq5n2bT+eFTjn7+ZTRgpWY8YZQyau9D/dEKCjtQ18FMmlMvuT4NTQIqIEij8ToEpouJdB9XzSyx9qOjxjXHdCF74ljMrtHsrSHJkY2zix4WdnJcvUa1ri+rDxVPXAbeW+8lHVHcoyzmL3L3gq/fAv7+jqyX5s5cx9Im5qMHiTLIB+eICi23F8qdqUBTD+Xy3EeNdWrbrmqeAdk1drQ0vyH7j/KN/2vJZcle+Mx2K2lmkbMvCLgEEUm7N0yPXtp+QsGIqSAnuSHZsI6KnLJc7vYqWv7EQkL6CSR7R13UGuxlqi68UTkb9jm0on5eQ6gfjfUkOO2udjO8CCSfiXlo3KPE2iLfu8shM+Wm1GxTrEp1h69q9ZKKW1rZ+yFrcNPe1iMqPnMDC78Qz8eOrNRykEKx8eryTVfLlmEiDQ0G/aJcr7LuaIzrypP21hlHtf0ZmgBUsJZh9jtbcjaESklHkeib/R6ijDJ11Msxze9Ek4dZQ/2lKjYmqOz50O4eDwOwVLF5rgVtkaYz2rtvxi8QdKQbbTaf4atJ4rT6McA2Jbq/gNeQ==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(26005)(1076003)(186003)(7696005)(83380400001)(4326008)(47076005)(426003)(2906002)(316002)(8676002)(36756003)(70206006)(54906003)(110136005)(336012)(7416002)(86362001)(508600001)(356005)(82310400004)(5660300002)(36860700001)(8936002)(107886003)(70586007)(81166007)(40460700003)(6666004)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2022 13:30:26.0434
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d917046a-1363-4855-95ca-08da118848d5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4121
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

v2 changes: moved from bpf-next to bpf.

v3 changes: added a selftest.

v4 changes: none, CCed Jakub and Arthur from Cloudflare.

diff --git a/net/core/filter.c b/net/core/filter.c
index a7044e98765e..64470a727ef7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7016,24 +7016,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
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

