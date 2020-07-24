Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6AC22CCDF
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 20:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgGXSSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 14:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgGXSSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 14:18:02 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F27EC0619D3
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 11:18:02 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id d27so7552693qtg.4
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 11:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IM+k+BPK9bSz4jD4o6435UpTaeLCWKIRqQ/FMa90ZXI=;
        b=bRgrcT/K+3rZ//SjLRT7rM6IdNJOhgKj+AbDXVGY/lrkn+9Y0JI5D0F5RYFfI8PbPo
         sZP51+kVm0cMBOiG+okB9+ekwFAGAJhXSjud5YDePe3EYG1y83jf4UvjDlzZ58X5t8vf
         8S1VzEh+U7L+g+GS6E4sjUIy1myQVeCpEDNKptN082Xe0UQOJUB/GNVYaIa3w/5ACzGz
         r1fSM8b4FcU4AO72EanKOqtOR0HZwJ9FU+2fbPzBP5lOppHUX+YtDbjc2SWZYQMRKz0L
         Hck9oNceA+jezPHdB8JBVJImiViRsLQXBbuSzCdMNVDpzq1XeFfMgIpf7axPQHL6oosL
         VvMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IM+k+BPK9bSz4jD4o6435UpTaeLCWKIRqQ/FMa90ZXI=;
        b=gJngbiGv8JN9L0vlRBHuGGAYiaLX09NIknT4ccEQxNJFr4GtxJyR0fvLzjjN3IpZFL
         vgocHA3Gnk6CxxhJUoGs+dka1RCSq2RQ2W4yuduexhrgNcnDpBILGz7hRLGiGTMG0pwG
         rSMK3MpUbfAZJUv3ZR6YWpT8XzmBEv/hQDs/1RXVEseBlHdNNy2/Qb0OU7HZvDJyaf4w
         myANOj7oimVgrENXozM4OkbQGnKnP1J+T3ruqTqZK6q8JFQ4WyxMbcU0/xS2053EJPtP
         GXVeNCoJn1DqiIH9O2mHdS4LD4ZrzKlSrE2jXRKVbxWDsd5SYEfBF4NIGCi4b/AeVDLh
         RDmQ==
X-Gm-Message-State: AOAM532ZpzPjOHfPWi2x7rC9wHMilryb1K2bwfLwrD5eCoFHrJ+5Jj/p
        4ObRk/I8NyZhetIQl+WmESL2obqt
X-Google-Smtp-Source: ABdhPJz6EnBSpRv8gQbXY6AiCfvp4ye8/QUL1Q9ScAQ4jWkM7F96uEGXkF1B0ErrlXMy4CjPYtQkNQ==
X-Received: by 2002:ac8:6793:: with SMTP id b19mr1531516qtp.333.1595614681288;
        Fri, 24 Jul 2020 11:18:01 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:316:f693:9fff:feea:df57])
        by smtp.gmail.com with ESMTPSA id x29sm2041217qtv.80.2020.07.24.11.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 11:18:00 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Tanner Love <tannerlove@google.com>,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH net] selftests/net: fix clang issues for target arch PowerPC and others
Date:   Fri, 24 Jul 2020 14:17:57 -0400
Message-Id: <20200724181757.2331172-1-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Address these warnings observed with clang 9.

rxtimestamp:
The signedness of char is implementation-dependent. Some systems
(including PowerPC and ARM) use unsigned char.
Compilation yielded:
warning: result of comparison of constant -1 with expression of type \
'char' is always true [-Wtautological-constant-out-of-range-compare]
                                  &arg_index)) != -1) {

psock_fanout:
Compilation yielded warnings like:
warning: format specifies type 'unsigned short' but the argument has \
type 'int' [-Wformat]
                typeflags, PORT_BASE, PORT_BASE + port_off);

so_txtime:
On powerpcle, int64_t maps to long long.
Compilation yielded:
warning: absolute value function 'labs' given an argument of type \
'long long' but has parameter of type 'long' which may cause \
truncation of value [-Wabsolute-value]
        if (labs(tstop - texpect) > cfg_variance_us)

tcp_mmap:
Compilation yielded:
warning: result of comparison of constant 34359738368 with \
expression of type 'size_t' (aka 'unsigned int') is always true \
[-Wtautological-constant-out-of-range-compare]
        while (total < FILE_SZ) {

Tested: make -C tools/testing/selftests TARGETS="net" run_tests

Fixes: 16e781224198 ("selftests/net: Add a test to validate behavior of rx timestamps")
Fixes: af5136f95045 ("selftests/net: SO_TXTIME with ETF and FQ")
Fixes: 77f65ebdca50 ("packet: packet fanout rollover during socket overload")
Fixes: 192dc405f308 ("selftests: net: add tcp_mmap program")
Signed-off-by: Tanner Love <tannerlove@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/psock_fanout.c | 3 ++-
 tools/testing/selftests/net/rxtimestamp.c  | 3 +--
 tools/testing/selftests/net/so_txtime.c    | 2 +-
 tools/testing/selftests/net/tcp_mmap.c     | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/psock_fanout.c b/tools/testing/selftests/net/psock_fanout.c
index 8c8c7d79c38d..2c522f7a0aec 100644
--- a/tools/testing/selftests/net/psock_fanout.c
+++ b/tools/testing/selftests/net/psock_fanout.c
@@ -350,7 +350,8 @@ static int test_datapath(uint16_t typeflags, int port_off,
 	int fds[2], fds_udp[2][2], ret;
 
 	fprintf(stderr, "\ntest: datapath 0x%hx ports %hu,%hu\n",
-		typeflags, PORT_BASE, PORT_BASE + port_off);
+		typeflags, (uint16_t)PORT_BASE,
+		(uint16_t)(PORT_BASE + port_off));
 
 	fds[0] = sock_fanout_open(typeflags, 0);
 	fds[1] = sock_fanout_open(typeflags, 0);
diff --git a/tools/testing/selftests/net/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
index 422e7761254d..bcb79ba1f214 100644
--- a/tools/testing/selftests/net/rxtimestamp.c
+++ b/tools/testing/selftests/net/rxtimestamp.c
@@ -329,8 +329,7 @@ int main(int argc, char **argv)
 	bool all_tests = true;
 	int arg_index = 0;
 	int failures = 0;
-	int s, t;
-	char opt;
+	int s, t, opt;
 
 	while ((opt = getopt_long(argc, argv, "", long_options,
 				  &arg_index)) != -1) {
diff --git a/tools/testing/selftests/net/so_txtime.c b/tools/testing/selftests/net/so_txtime.c
index ceaad78e9667..3155fbbf644b 100644
--- a/tools/testing/selftests/net/so_txtime.c
+++ b/tools/testing/selftests/net/so_txtime.c
@@ -121,7 +121,7 @@ static bool do_recv_one(int fdr, struct timed_send *ts)
 	if (rbuf[0] != ts->data)
 		error(1, 0, "payload mismatch. expected %c", ts->data);
 
-	if (labs(tstop - texpect) > cfg_variance_us)
+	if (llabs(tstop - texpect) > cfg_variance_us)
 		error(1, 0, "exceeds variance (%d us)", cfg_variance_us);
 
 	return false;
diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selftests/net/tcp_mmap.c
index 4555f88252ba..92086d65bd87 100644
--- a/tools/testing/selftests/net/tcp_mmap.c
+++ b/tools/testing/selftests/net/tcp_mmap.c
@@ -344,7 +344,7 @@ int main(int argc, char *argv[])
 {
 	struct sockaddr_storage listenaddr, addr;
 	unsigned int max_pacing_rate = 0;
-	size_t total = 0;
+	unsigned long total = 0;
 	char *host = NULL;
 	int fd, c, on = 1;
 	char *buffer;
-- 
2.28.0.rc0.142.g3c755180ce-goog

