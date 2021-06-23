Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBEE3B1BAA
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhFWN5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:57:33 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55531 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230263AbhFWN5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 09:57:31 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id C68F95C0081;
        Wed, 23 Jun 2021 09:55:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 23 Jun 2021 09:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=gUWzsfhi8Ky7FahDiCmtxCzmrxQlRChjZMzLJyOh0lY=; b=jYUMuGJ8
        QleVRUcutSi3BPauS1EaK/m4bkNtG+N7OTUaJwvKwumhtWvBIVzF46XKSv1Pl8Vp
        c+U0sUbKVV25DOt/BwunAV27ZQptJ33HREJ8fJYP5fUQ9seyx1EJIsZU4iRn35GV
        f39h/LkIs9UST+bW96C0UvjspwgrmJS4x3MZc3iMYTdDYtlqPo1OA407ja8VMo6M
        9U23rnQg2kN+MOoHYDQgjjZ9+PFfSZNcibZx0F5MzxcWW/rFtJ6QYqcJGvXS5PxA
        5yd1SJkqwxtNRBtt9RpmWVHCu7dIBvwgae0QU7tOnFj4ilvUU36QGzc2wxQVSYZ8
        imvxLC/38jz3Uw==
X-ME-Sender: <xms:QT3TYMOfU_a83oTdP32yPoWm93j4Xi7Rc7cHz20alUpIEWB0fxkHOg>
    <xme:QT3TYC9U3qwocZjrrQf0sRJ7Y-WwQzyQ3YzlwiyLeRfzY7OhJIXM2k2a3jXIvTvbb
    jCMP_aWp3YFtv2xFWA>
X-ME-Received: <xmr:QT3TYDRqAK_CNgn4Lz5mvypEzpq4TQ-2CRP6pvtDTxvDX7NE55cfbdVJs7mHxz2LsM78CQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegfedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepofgrrhhthihnrghsucfruhhmphhuthhishcuoehmsehlrghm
    sggurgdrlhhtqeenucggtffrrghtthgvrhhnpedtffffgeffjeeiheeuvdfhkeejvefhie
    dufeekffekueeuhfelvdetjeeiteduvdenucevlhhushhtvghrufhiiigvpedtnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehmsehlrghmsggurgdrlhht
X-ME-Proxy: <xmx:QT3TYEtcayeLoY2A_altQrTL8R4Q0601u0nQoSmZhziaAnpgE-xDIg>
    <xmx:QT3TYEdyCZlaV37KSUu4md7vlyBmbVdNia-zsnaIxbB5dRKaZmoubA>
    <xmx:QT3TYI0ODBIng5Qb0ZIANqkZdpM0Qhc-2l54m3XE_sN-IJFGPbM5_g>
    <xmx:QT3TYM7YoGPy04MhSA6TAB_jJ4mjNUR4hcVSEfgilqofnisyQni94g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 23 Jun 2021 09:55:12 -0400 (EDT)
From:   Martynas Pumputis <m@lambda.lt>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, daniel@iogearbox.net, ast@kernel.org,
        m@lambda.lt, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH net-next v2 2/2] tools/testing: add a selftest for SO_NETNS_COOKIE
Date:   Wed, 23 Jun 2021 15:56:46 +0200
Message-Id: <20210623135646.1632083-2-m@lambda.lt>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623135646.1632083-1-m@lambda.lt>
References: <20210623135646.1632083-1-m@lambda.lt>
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

