Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEDCE4F6338
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 17:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbiDFPdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 11:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236191AbiDFPdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 11:33:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28364BDACB;
        Wed,  6 Apr 2022 05:42:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q878cRs4//0C9Kud4vo/wW1AFKbYnIGxgHWMtrgt3umA0MKqJsvc5dN/xe2dwPoetUyhLEgP2Nc/yf9nogFM+mCU5aGUbJyjphfdRgAjsD4sp+v8wl/g7ROAgucK2bWdzjB25aQ1LamEgZVrIBkZSo3E1zCR3xLjPd625cgzvMlVwMPAxor4R3A6cz3HRWwcimJchAW61rYpF/1qyV060NJ7LDNnhKA9tIIxkEBe/rxZkSgBT7FxU3Q3Lfeq+DsS7yixVaw0J+tjlm8REi8OEcrk4wezXcHfgNgW01Q+qYronUpErTci9k0qi5tvNTUDn/eMr7LI58bEYGoEXWsnwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTWuh4pIIul7EGJ/M/YyW67bt48nhB3Usbkemo/n3h8=;
 b=MmZpt5PMVcv5MeBUs1rPmWZVd8GYWRP6MEPYDvhqhbxdiCjggqRkJuwQvUJEgnHlUAdlx+N05OINj95cWhDZhwRKlzOg3uYv0jW/TCq/o3usYqVrrgXTfvSo97j/XV1ozWAcprwPu68hV3USzCD2aQJZ+CAy1r2IuceOYM2wEkv27+N+okfOx+J3Ny/6y9yLmpYFj5p7pQVi/Z2xRWNKYSvIRoOrHhgZ2yz/d/be9sTzKnbc7P39ZANs1o1LC8Bsu/ZYGKL2TNFjTvf3ir+8kZsU6pCg8lx9jK0wFlDAQ2tIO3aQBRFsTzCxHGr8iCDoYWfGP4WlgLX/lKbRgQ4AqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTWuh4pIIul7EGJ/M/YyW67bt48nhB3Usbkemo/n3h8=;
 b=OzOJgxE8RFAkeo/kP4gVKYSPYfu5TGZYlXEaHUvRPDy+W2fmO1tIBAmxKdElo0Z4gN1sAgTrx9wdUv5jS/zpzKJReIymEfHFYio54JgInvGdXCIfla1IF5AGZBcgyNRmJhUbIJmNgrt3E02t3bIqoA/iezymSY+8VHJonsEUQP6+RQYXd6MHdDByBmV4ghgv1w1VMd9Ap6YeRrpBRZYzuPzufAXjb2dHJKTCXAbEG02QacCctvjOeE08fDa6rT5M3LHszm/I2M+70sDMJfixQ1EeX4Ko0+uBHG0HRz7D3jQVKPLgXuosPesqJObSpeW4vWLzqC7l6nSuk1tTZpt+ig==
Received: from BN9P222CA0008.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::13)
 by BN6PR12MB1810.namprd12.prod.outlook.com (2603:10b6:404:107::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Wed, 6 Apr
 2022 12:41:49 +0000
Received: from BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::db) by BN9P222CA0008.outlook.office365.com
 (2603:10b6:408:10c::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.13 via Frontend
 Transport; Wed, 6 Apr 2022 12:41:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT010.mail.protection.outlook.com (10.13.177.53) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5144.20 via Frontend Transport; Wed, 6 Apr 2022 12:41:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 6 Apr
 2022 12:41:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Wed, 6 Apr 2022
 05:41:47 -0700
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.22 via Frontend Transport; Wed, 6 Apr
 2022 05:41:42 -0700
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
        "Maxim Mikityanskiy" <maximmi@nvidia.com>
Subject: [PATCH bpf v5 2/2] bpf: Adjust bpf_tcp_check_syncookie selftest to test dual-stack sockets
Date:   Wed, 6 Apr 2022 15:41:13 +0300
Message-ID: <20220406124113.2795730-2-maximmi@nvidia.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220406124113.2795730-1-maximmi@nvidia.com>
References: <20220406124113.2795730-1-maximmi@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0c8dbfc-1e34-4a14-f4db-08da17cad167
X-MS-TrafficTypeDiagnostic: BN6PR12MB1810:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1810A25603AFDCAE839B48CEDCE79@BN6PR12MB1810.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yYamxIOrRdqnE+ZBmETUqo1nRpWNE8n/Ro83pQuJX9g7vP0D7U7qIW2pZCl7y3I++Yb4CwEIsmx06fkEoApluMy9JExeS5Hj9ZnJFNOPHKiIkZ/OwX0OFrmLlYvksCzBb+QEhRYPHhcK/YSvlpktjBKTHCL6xa0TKq4syxrQAIxuXNI9VLkjeC+Feg9rLzYAQEApddp2iIfHlb4xJAiYzeixXTsW080CJC3WCk1L+srYlygX3J0U+Od91BeIWTD/d24HObPNyYnXe9Y2AZMwN+bNeZrAJ6EdJ1tMlkPy2RgFEh6m5vcFHLGHWEPJZB+Gf6gv4VH+lt9YiQH4+ls6RZgDH2U7McdAjwMJWQ2WEJNWckd64wlgzRbYBk0fAcFMf0VB0kd5DZYsu4syKmu88sbD+R3A0fOz4Vg2mjMMohjDZpUAWLLiFpqipYJULWnOyG6Y9i3kUNCsn15K1dlf8g8hV/aRjGGZxEFGAK/jN4ytAD0FwR7COOJHi4wjG7a6yXKnilw1pmcxlM1Opv0sZnwzO02MLUfN1T8a/gPNnK5IyBY1sh9Hgj+M4asJAIgMAA5TXkO6x7YmRKyTrVqhauEQj0Q+PizuqvHU8g7vcUpvk7gdgBbjIp0fCAASaAGah8d8Ejjinl1B+ndvCou4WefKmMKfBI+amgzBQw6rk8A67ahWoHfgQMBICjfiNodbzHnBxH5MU/8eTD9mlnNmaQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(7696005)(6666004)(426003)(36860700001)(2616005)(47076005)(83380400001)(107886003)(26005)(186003)(336012)(1076003)(7416002)(8936002)(4326008)(36756003)(70206006)(81166007)(5660300002)(82310400005)(356005)(8676002)(2906002)(316002)(508600001)(110136005)(40460700003)(54906003)(86362001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2022 12:41:48.8711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d0c8dbfc-1e34-4a14-f4db-08da17cad167
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1810
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit fixed support for dual-stack sockets in
bpf_tcp_check_syncookie. This commit adjusts the selftest to verify the
fixed functionality.

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Acked-by: Arthur Fabre <afabre@cloudflare.com>
---
 .../bpf/test_tcp_check_syncookie_user.c       | 78 ++++++++++++++-----
 1 file changed, 59 insertions(+), 19 deletions(-)

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

