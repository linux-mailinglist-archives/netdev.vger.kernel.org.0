Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F393470754
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 18:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244586AbhLJRhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 12:37:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241342AbhLJRhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 12:37:12 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504F6C061A72
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:33 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso10345161otr.2
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 09:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/nnwsniEu8uqYxjrwTyGxxsdhf651m9rl/Wv8zBibbw=;
        b=SmXM3bXqM0gP1T/ezve3OJ9V/UwR0HRmCygo4+nqyzJjP1gF+zR7fge5vblTzlNrCX
         w04iFxqxd77ZVX79QZ2Zt1uJoQN9tDojIGVstIdl1Ce1fS/SMZQYXDALiC1835irYpPi
         EhPQEF96/sDzUgJbQgTPDroDn8RrRbvtb3geQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/nnwsniEu8uqYxjrwTyGxxsdhf651m9rl/Wv8zBibbw=;
        b=sYcI7zpZEsUAXsnyz8rMIPZ7ponWHtwk03lKnd9Os7wc1r7+d9EDkf5MI5ygr0S04Y
         0WZsCvRXv7uS0gDU4PQ9DANnezk2DHUi6OuvJgZZ2LSl/IsEq0l8QLAGjBmbrcKatXHf
         F4fwA3Hj3GRpnczmZc+AQKa7sfboB3Xb0ilAIoGPLugTypyrrNH/pSZttjTkkq5fNKYw
         LeH12VVu2TJxRTlynfNnfXe+jJMvmk1oq8dty+nzsFlKsD8pzAM3+EXZ7DkC2YhDxdFs
         /a9MoyPd+GRmfYvjxDeLWTx8GWHenwZFoL0AtcSbZ/i1noea4yYDFHooynLDD/KSqo/C
         VnbQ==
X-Gm-Message-State: AOAM532vc9/nH71mBQyTBsVbRAnG5RUkkwcVh0l3cRWWx04qdq+8m0wT
        UTbGbl4IlzmJXqrhB3CyBU0XOw==
X-Google-Smtp-Source: ABdhPJw9KMAr8iR7/gO1NKMOwvgOgpBIMplkuY0P/9SLX80+FALZ7l62v8z8IlRFbsoMk0FcxwUIOQ==
X-Received: by 2002:a9d:ea6:: with SMTP id 35mr11764702otj.304.1639157612590;
        Fri, 10 Dec 2021 09:33:32 -0800 (PST)
Received: from shuah-t480s.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x4sm892224oiv.35.2021.12.10.09.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 09:33:32 -0800 (PST)
From:   Shuah Khan <skhan@linuxfoundation.org>
To:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        kuba@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        boqun.feng@gmail.com, akpm@linux-foundation.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 07/12] selftests/net: remove ARRAY_SIZE define from individual tests
Date:   Fri, 10 Dec 2021 10:33:17 -0700
Message-Id: <1356c830b8155ddd37a6330c1f5d4df7a1bdb86a.1639156389.git.skhan@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1639156389.git.skhan@linuxfoundation.org>
References: <cover.1639156389.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ARRAY_SIZE is defined in several selftests. Remove definitions from
individual test files and include header file for the define instead.
ARRAY_SIZE define is added in a separate patch to prepare for this
change.

Remove ARRAY_SIZE from net tests and pickup the one defined in
kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
---
 tools/testing/selftests/net/gro.c                     | 3 ++-
 tools/testing/selftests/net/ipsec.c                   | 1 -
 tools/testing/selftests/net/reuseport_bpf.c           | 4 +---
 tools/testing/selftests/net/rxtimestamp.c             | 2 +-
 tools/testing/selftests/net/socket.c                  | 3 ++-
 tools/testing/selftests/net/tcp_fastopen_backup_key.c | 6 ++----
 6 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
index cf37ce86b0fd..221525ccbe1d 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -57,10 +57,11 @@
 #include <string.h>
 #include <unistd.h>
 
+#include "../kselftest.h"
+
 #define DPORT 8000
 #define SPORT 1500
 #define PAYLOAD_LEN 100
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #define NUM_PACKETS 4
 #define START_SEQ 100
 #define START_ACK 100
diff --git a/tools/testing/selftests/net/ipsec.c b/tools/testing/selftests/net/ipsec.c
index 3d7dde2c321b..cc10c10c5ed9 100644
--- a/tools/testing/selftests/net/ipsec.c
+++ b/tools/testing/selftests/net/ipsec.c
@@ -41,7 +41,6 @@
 
 #define pr_err(fmt, ...)	printk(fmt ": %m", ##__VA_ARGS__)
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
 #define IPV4_STR_SZ	16	/* xxx.xxx.xxx.xxx is longest + \0 */
diff --git a/tools/testing/selftests/net/reuseport_bpf.c b/tools/testing/selftests/net/reuseport_bpf.c
index b5277106df1f..072d709c96b4 100644
--- a/tools/testing/selftests/net/reuseport_bpf.c
+++ b/tools/testing/selftests/net/reuseport_bpf.c
@@ -24,9 +24,7 @@
 #include <sys/resource.h>
 #include <unistd.h>
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
-#endif
+#include "../kselftest.h"
 
 struct test_params {
 	int recv_family;
diff --git a/tools/testing/selftests/net/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
index e4613ce4ed69..9eb42570294d 100644
--- a/tools/testing/selftests/net/rxtimestamp.c
+++ b/tools/testing/selftests/net/rxtimestamp.c
@@ -18,7 +18,7 @@
 #include <linux/net_tstamp.h>
 #include <linux/errqueue.h>
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#include "../kselftest.h"
 
 struct options {
 	int so_timestamp;
diff --git a/tools/testing/selftests/net/socket.c b/tools/testing/selftests/net/socket.c
index afca1ead677f..db1aeb8c5d1e 100644
--- a/tools/testing/selftests/net/socket.c
+++ b/tools/testing/selftests/net/socket.c
@@ -7,6 +7,8 @@
 #include <sys/socket.h>
 #include <netinet/in.h>
 
+#include "../kselftest.h"
+
 struct socket_testcase {
 	int	domain;
 	int	type;
@@ -31,7 +33,6 @@ static struct socket_testcase tests[] = {
 	{ AF_INET, SOCK_STREAM, IPPROTO_UDP, -EPROTONOSUPPORT, 1  },
 };
 
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
 #define ERR_STRING_SZ	64
 
 static int run_tests(void)
diff --git a/tools/testing/selftests/net/tcp_fastopen_backup_key.c b/tools/testing/selftests/net/tcp_fastopen_backup_key.c
index 9c55ec44fc43..c1cb0c75156a 100644
--- a/tools/testing/selftests/net/tcp_fastopen_backup_key.c
+++ b/tools/testing/selftests/net/tcp_fastopen_backup_key.c
@@ -26,6 +26,8 @@
 #include <fcntl.h>
 #include <time.h>
 
+#include "../kselftest.h"
+
 #ifndef TCP_FASTOPEN_KEY
 #define TCP_FASTOPEN_KEY 33
 #endif
@@ -34,10 +36,6 @@
 #define PROC_FASTOPEN_KEY "/proc/sys/net/ipv4/tcp_fastopen_key"
 #define KEY_LENGTH 16
 
-#ifndef ARRAY_SIZE
-#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
-#endif
-
 static bool do_ipv6;
 static bool do_sockopt;
 static bool do_rotate;
-- 
2.32.0

