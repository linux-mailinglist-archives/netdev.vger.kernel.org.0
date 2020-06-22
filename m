Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA204203E34
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgFVRna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729857AbgFVRn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:43:29 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C286C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 10:43:29 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l6so12666655qkc.6
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 10:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f+PwSbbNoipG/smkaNRSaWjSuWv55Vp6nZQTyzFTU4w=;
        b=GCEXgKZO0wG7/rSU0Pat0OKJo1Wpz1gXNkXt3B2l7CWLerDM/bNuRXMDKZE89mJHxK
         4hWuEeQSLHbyftkW6wtFSUH/NAq7Qkp+Afbau67JjNztYtlrVBl3uJe/neEiMpsGashc
         wdt1YiD4K9fbxTaSPs6Mxg2rDwGiU8K1yG5mkQFgnYjkV+dPaNYz1EM+VeeHB8fIsHiV
         B9tbTRXKfkGevZJ6pEyQD8AsBdETmMc3e+1wU7unWnutNdgOJV3FoNdey8Xs5DjGC+Bc
         tcAogrwRkf7gmgklIBRVd0CphbAW2H+XHAFcqw1pTMmKBuUrhRcVUXhWveKY4JOGO9KH
         jJTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f+PwSbbNoipG/smkaNRSaWjSuWv55Vp6nZQTyzFTU4w=;
        b=Tld1h+3xYgFwV3k9fBA57tSdXxWRw2XMZw5PXj0VipJkkQbOWUMkXZv/dcfzqJT0Zi
         rQnwaBeMC3oVBcV1m8kYBlPwXbNGn1l5rzB0rUBAFM7R97ZSHglOl0u3MjHrUiw3elup
         uXMGoKgck0BQckX9tZ0ka1pCLfN9iSwI3tZjmgO6ibRnSgnIvYxUBSgucBKBr/CvSLT0
         s0Jxaw0WyLPXVSTFjqt9LbdQmXIcomZx0G9Mgr7UNRpUnsHtRrCJw4Uzs7YSk3C8nt1+
         pU0KikzmAI2w3XPelEKXcEh4z/Gqery0uQvdZCmjpi3OPtovSiedMtXQGcHrlRi6KPAR
         NKKQ==
X-Gm-Message-State: AOAM531R6ecoAAEdTIHYqq9cKo88Nr8LDI4X5PvmBiXTpJuC+izt23DU
        YP4BnpgNn1B1bHajXQ3mK9hvfTbm
X-Google-Smtp-Source: ABdhPJyL5M3543HZ/eVKhBrgR3OlKAYLwy+J3auwaL5RKjBjpy9I8atEyeCtDu6t762I5KbfnayLng==
X-Received: by 2002:ae9:f444:: with SMTP id z4mr3699916qkl.80.1592847808599;
        Mon, 22 Jun 2020 10:43:28 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:6db4:c56e:8332:4abd])
        by smtp.gmail.com with ESMTPSA id x144sm4044996qkb.93.2020.06.22.10.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 10:43:28 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tannerlove <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: plug rxtimestamp test into kselftest framework
Date:   Mon, 22 Jun 2020 13:43:24 -0400
Message-Id: <20200622174324.42142-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: tannerlove <tannerlove@google.com>

Run rxtimestamp as part of TEST_PROGS. Analogous to other tests, add
new rxtimestamp.sh wrapper script, so that the test runs isolated
from background traffic in a private network namespace.

Also ignore failures of test case #6 by default. This case verifies
that a receive timestamp is not reported if timestamp reporting is
enabled for a socket, but generation is disabled. Receive timestamp
generation has to be enabled globally, as no associated socket is
known yet. A background process that enables rx timestamp generation
therefore causes a false positive. Ntpd is one example that does.

Add a "--strict" option to cause failure in the event that any test
case fails, including test #6. This is useful for environments that
are known to not have such background processes.

Tested:
make -C tools/testing/selftests TARGETS="net" run_tests

Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/Makefile       |  1 +
 tools/testing/selftests/net/rxtimestamp.c  | 11 +++++++++--
 tools/testing/selftests/net/rxtimestamp.sh |  4 ++++
 3 files changed, 14 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/rxtimestamp.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 895ec992b2f1..bfacb960450f 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -17,6 +17,7 @@ TEST_PROGS += route_localnet.sh
 TEST_PROGS += reuseaddr_ports_exhausted.sh
 TEST_PROGS += txtimestamp.sh
 TEST_PROGS += vrf-xfrm-tests.sh
+TEST_PROGS += rxtimestamp.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
index 422e7761254d..d4ea86a13e52 100644
--- a/tools/testing/selftests/net/rxtimestamp.c
+++ b/tools/testing/selftests/net/rxtimestamp.c
@@ -44,6 +44,7 @@ struct test_case {
 	struct options sockopt;
 	struct tstamps expected;
 	bool enabled;
+	bool warn_on_fail;
 };
 
 struct sof_flag {
@@ -89,7 +90,7 @@ static struct test_case test_cases[] = {
 	},
 	{
 		{ so_timestamping: SOF_TIMESTAMPING_SOFTWARE },
-		{}
+		warn_on_fail : true
 	},
 	{
 		{ so_timestamping: SOF_TIMESTAMPING_RX_SOFTWARE
@@ -115,6 +116,7 @@ static struct option long_options[] = {
 	{ "tcp", no_argument, 0, 't' },
 	{ "udp", no_argument, 0, 'u' },
 	{ "ip", no_argument, 0, 'i' },
+	{ "strict", no_argument, 0, 'S' },
 	{ NULL, 0, NULL, 0 },
 };
 
@@ -327,6 +329,7 @@ int main(int argc, char **argv)
 {
 	bool all_protocols = true;
 	bool all_tests = true;
+	bool strict = false;
 	int arg_index = 0;
 	int failures = 0;
 	int s, t;
@@ -363,6 +366,9 @@ int main(int argc, char **argv)
 			all_protocols = false;
 			socket_types[0].enabled = true;
 			break;
+		case 'S':
+			strict = true;
+			break;
 		default:
 			error(1, 0, "Failed to parse parameters.");
 		}
@@ -379,7 +385,8 @@ int main(int argc, char **argv)
 
 			printf("Starting testcase %d...\n", t);
 			if (run_test_case(socket_types[s], test_cases[t])) {
-				failures++;
+				if (strict || !test_cases[t].warn_on_fail)
+					failures++;
 				printf("FAILURE in test case ");
 				print_test_case(&test_cases[t]);
 			}
diff --git a/tools/testing/selftests/net/rxtimestamp.sh b/tools/testing/selftests/net/rxtimestamp.sh
new file mode 100755
index 000000000000..91631e88bf46
--- /dev/null
+++ b/tools/testing/selftests/net/rxtimestamp.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+./in_netns.sh ./rxtimestamp $@
-- 
2.27.0.111.gc72c7da667-goog

