Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F2F3B0EAF
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 22:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhFVU1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 16:27:01 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:59965 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229667AbhFVU1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 16:27:01 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id A7C059B1;
        Tue, 22 Jun 2021 16:24:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 22 Jun 2021 16:24:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gUWzsfhi8Ky7FahDiCmtxCzmrxQlRChjZMzLJyOh0lY=; b=I06DSlLG
        OJkbX73muBxCeFVojSuTaGIN+RUzwdBZG2jnfS9a9lzEd76+MounYhFCldT0iSGT
        WORh1x9Z6kVsQrkubenLr+JF55tViKmjERLxYt7x4jlVX6W00lZIX1OKVOtj0QB6
        VrFeNNp3pHryvlcb3RyqIjrNgjPnBo+gZzVb/6sLILFbih8tHZENEaeCWQrbH41e
        pWNSx0oYQuxz00gkf+lUXFyeWKWKHKOZtjHssH9LOmGRB/2A9H0aL7kKIDov+HXv
        02O3qug2I0BwOpQB5dx9m/4XZjvyM6VghBUPjVJWstrIXhpsEgJTohOKvmhNURvG
        S5rceRHaT1i5xg==
X-ME-Sender: <xms:C0fSYJvuw8H-ldqpFGA0npEipzqe2GtixjrrYnNW66slnzD8MQL2HA>
    <xme:C0fSYCf2pTFslVdamblvIlpdrFGX2Rwc3RREbqxbQpR9tDU5Z5UPw3F9qeMpCxvg8
    0MtHZOLJpCTKswiyws>
X-ME-Received: <xmr:C0fSYMwwJfQ083z5Rt0UDYAvCFGMruFqrJM_gBiEr0VaoneKDZVV9C3_Bt60NCIF8m5v2Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeeguddgudegjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeforghrthihnhgrshcurfhumhhpuhhtihhsuceomheslhgr
    mhgsuggrrdhltheqnecuggftrfgrthhtvghrnheptdffffegffejieehuedvhfekjeevhf
    eiudefkeffkeeuuefhledvteejieetuddvnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepmheslhgrmhgsuggrrdhlth
X-ME-Proxy: <xmx:C0fSYAN7oIY_zEHIzGJ4j-bwLnZ7hbfOqthThfkVy2keqqoif-twrw>
    <xmx:C0fSYJ_W4L3_WNg9RDktQgR4D9gqNfh1bl99pmsCizSQfNlk1nytiw>
    <xmx:C0fSYAXYCBeKBP4zUjcBZmn7g2uL7Bl8axSdaCI95gN7d3rp-5aGeQ>
    <xmx:DEfSYLJ4DqI1-Gm5UxCUa5oXenxGGo3Xx9tCcS0DAdUmozb_e4heGg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 16:24:42 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH net-next 2/2] tools/testing: add a selftest for SO_NETNS_COOKIE
Date:   Tue, 22 Jun 2021 22:26:23 +0200
Message-Id: <20210622202623.1311901-2-m@lambda.lt>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622202623.1311901-1-m@lambda.lt>
References: <20210622202623.1311901-1-m@lambda.lt>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

Make sure that SO_NETNS_COOKIE returns a non-zero value, and
that sockets from different namespaces have a distinct cookie
value.

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 tools/testing/selftests/net/.gitignore        |  1 +
 tools/testing/selftests/net/Makefile          |  2 +-
 tools/testing/selftests/net/config            |  1 +
 tools/testing/selftests/net/so_netns_cookie.c | 61 +++++++++++++++++++
 4 files changed, 64 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/so_netns_cookie.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 61ae899cfc17..19deb9cdf72f 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -30,3 +30,4 @@ hwtstamp_config
 rxtimestamp
 timestamping
 txtimestamp
+so_netns_cookie
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3915bb7bfc39..79c9eb0034d5 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -30,7 +30,7 @@ TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
-TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
+TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr so_netns_cookie
 TEST_GEN_FILES += tcp_fastopen_backup_key
 TEST_GEN_FILES += fin_ack_lat
 TEST_GEN_FILES += reuseaddr_ports_exhausted
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 614d5477365a..6f905b53904f 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -1,4 +1,5 @@
 CONFIG_USER_NS=y
+CONFIG_NET_NS=y
 CONFIG_BPF_SYSCALL=y
 CONFIG_TEST_BPF=m
 CONFIG_NUMA=y
diff --git a/tools/testing/selftests/net/so_netns_cookie.c b/tools/testing/selftests/net/so_netns_cookie.c
new file mode 100644
index 000000000000..b39e87e967cd
--- /dev/null
+++ b/tools/testing/selftests/net/so_netns_cookie.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+#define _GNU_SOURCE
+#include <sched.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <errno.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdint.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+
+#ifndef SO_NETNS_COOKIE
+#define SO_NETNS_COOKIE 71
+#endif
+
+#define pr_err(fmt, ...) \
+	({ \
+		fprintf(stderr, "%s:%d:" fmt ": %m\n", \
+			__func__, __LINE__, ##__VA_ARGS__); \
+		1; \
+	})
+
+int main(int argc, char *argvp[])
+{
+	uint64_t cookie1, cookie2;
+	socklen_t vallen;
+	int sock1, sock2;
+
+	sock1 = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock1 < 0)
+		return pr_err("Unable to create TCP socket");
+
+	vallen = sizeof(cookie1);
+	if (getsockopt(sock1, SOL_SOCKET, SO_NETNS_COOKIE, &cookie1, &vallen) != 0)
+		return pr_err("getsockopt(SOL_SOCKET, SO_NETNS_COOKIE)");
+
+	if (!cookie1)
+		return pr_err("SO_NETNS_COOKIE returned zero cookie");
+
+	if (unshare(CLONE_NEWNET))
+		return pr_err("unshare");
+
+	sock2 = socket(AF_INET, SOCK_STREAM, 0);
+	if (sock2 < 0)
+		return pr_err("Unable to create TCP socket");
+
+	vallen = sizeof(cookie2);
+	if (getsockopt(sock2, SOL_SOCKET, SO_NETNS_COOKIE, &cookie2, &vallen) != 0)
+		return pr_err("getsockopt(SOL_SOCKET, SO_NETNS_COOKIE)");
+
+	if (!cookie2)
+		return pr_err("SO_NETNS_COOKIE returned zero cookie");
+
+	if (cookie1 == cookie2)
+		return pr_err("SO_NETNS_COOKIE returned identical cookies for distinct ns");
+
+	close(sock1);
+	close(sock2);
+	return 0;
+}
-- 
2.32.0

