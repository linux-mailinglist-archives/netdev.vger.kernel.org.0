Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C31685C19
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 01:19:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjBAAT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 19:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231673AbjBAATT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 19:19:19 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B205528C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:19:10 -0800 (PST)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6BDCA3F135
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 00:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675210747;
        bh=THqFl0me8Ks10Tkt9+ZckNKES+j+lzbfaB3495mdeRc=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=gNkK6m2mIF9bGJ+i8uFf+P1bGY+DuiGYkQ1viSA+MkPwWSXI3rdGPl4UTPCe3YSzc
         sAa1bL6oXgp7JiArESTYZyRC+rr1eN2B4X5udax6I5uzlerizolApQHGuDgozlKAiC
         XNh+NQkBTCbDwG0B+GfE07pRWwJYyKLM4xBpXAnnBhihgx2fJFA/2lJZQNggNutN/c
         GaLL8/T+tpZqMrZ0/n9I+XgtiaaVnVQnLrme0HMMQ9tWorMB1Lpa44dDM8zZHBe/cS
         P2CjJI3hAB19ltlLy9Opy0AS9Y/8nKsOMtgx1Ot9YkylvbydZSwwLAZIOGMVd5V/W8
         b2Tvz7vhjvgKA==
Received: by mail-wm1-f71.google.com with SMTP id o42-20020a05600c512a00b003dc5341afbaso151769wms.7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 16:19:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=THqFl0me8Ks10Tkt9+ZckNKES+j+lzbfaB3495mdeRc=;
        b=4lJ3smT+09mgVh0RD9m/fJN7PwOej1HinG7IOZorxN7rtiF9ee3ZZUHamYULt3JuOZ
         liQ+6VaM4pdUKM4kY1VA+RWBCvTbKmgjEstFrJPug+dXxrheO8JKdIcrR2uo5fpDrMQD
         W5ohUUcEUtgpiZwtPCo/ZasbtFKLJzerlfnap6vjXm3XjW6rJgjEczn3aoEgjYr9p4TA
         +3jZriKpd7ydluoaMWhaEutGc0Q5WkRs2emvBbCmg2EoQ3eQE4HCbsrK6hlrHB58FL/B
         w7aLwo5PmwLv85reA1tCH/xUEM/0lb4ijnMoyDS3/odMdEYoMeWHDXtmbsAT1LQN1PyX
         0qoA==
X-Gm-Message-State: AO0yUKUPfRzTtLbELKbjcRdAhN9/uhLdKLziqhardya2pQUY6I/JAmhg
        sV6lV1idqrY+o8YqYyVIsUa3OmvvSUrPYPSSHgLD6URFAVxpB3LrA96N4Ha2KF2U7prbHFc/Xq3
        Fl0cVwSuGneK2mLek0+lqBtIWVx6yI4Zz5Q==
X-Received: by 2002:a5d:6791:0:b0:2bd:bb5f:6a9f with SMTP id v17-20020a5d6791000000b002bdbb5f6a9fmr695840wru.67.1675210747127;
        Tue, 31 Jan 2023 16:19:07 -0800 (PST)
X-Google-Smtp-Source: AK7set9II6Vfu8dlIujX+EybQlwMJwMubFPOzNguQSRbDTV3j5xSGtpEYZbX4ult2qRMpsHsXInLmA==
X-Received: by 2002:a5d:6791:0:b0:2bd:bb5f:6a9f with SMTP id v17-20020a5d6791000000b002bdbb5f6a9fmr695821wru.67.1675210746855;
        Tue, 31 Jan 2023 16:19:06 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id n6-20020a7bcbc6000000b003d237d60318sm108925wmi.2.2023.01.31.16.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 16:19:06 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Cc:     Andrei Gherzan <andrei.gherzan@canonical.com>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net v4 4/4] selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking
Date:   Wed,  1 Feb 2023 00:16:16 +0000
Message-Id: <20230201001612.515730-4-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230201001612.515730-1-andrei.gherzan@canonical.com>
References: <20230201001612.515730-1-andrei.gherzan@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The test tool can check that the zerocopy number of completions value is
valid taking into consideration the number of datagram send calls. This can
catch the system into a state where the datagrams are still in the system
(for example in a qdisk, waiting for the network interface to return a
completion notification, etc).

This change adds a retry logic of computing the number of completions up to
a configurable (via CLI) timeout (default: 2 seconds).

Fixes: 79ebc3c26010 ("net/udpgso_bench_tx: options to exercise TX CMSG")
Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/udpgso_bench_tx.c | 34 +++++++++++++++----
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
index b47b5c32039f..477392715a9a 100644
--- a/tools/testing/selftests/net/udpgso_bench_tx.c
+++ b/tools/testing/selftests/net/udpgso_bench_tx.c
@@ -62,6 +62,7 @@ static int	cfg_payload_len	= (1472 * 42);
 static int	cfg_port	= 8000;
 static int	cfg_runtime_ms	= -1;
 static bool	cfg_poll;
+static int	cfg_poll_loop_timeout_ms = 2000;
 static bool	cfg_segment;
 static bool	cfg_sendmmsg;
 static bool	cfg_tcp;
@@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
 	}
 }
 
-static void flush_errqueue(int fd, const bool do_poll)
+static void flush_errqueue(int fd, const bool do_poll,
+			   unsigned long poll_timeout, const bool poll_err)
 {
 	if (do_poll) {
 		struct pollfd fds = {0};
 		int ret;
 
 		fds.fd = fd;
-		ret = poll(&fds, 1, 500);
+		ret = poll(&fds, 1, poll_timeout);
 		if (ret == 0) {
-			if (cfg_verbose)
+			if ((cfg_verbose) && (poll_err))
 				fprintf(stderr, "poll timeout\n");
 		} else if (ret < 0) {
 			error(1, errno, "poll");
@@ -254,6 +256,20 @@ static void flush_errqueue(int fd, const bool do_poll)
 	flush_errqueue_recv(fd);
 }
 
+static void flush_errqueue_retry(int fd, unsigned long num_sends)
+{
+	unsigned long tnow, tstop;
+	bool first_try = true;
+
+	tnow = gettimeofday_ms();
+	tstop = tnow + cfg_poll_loop_timeout_ms;
+	do {
+		flush_errqueue(fd, true, tstop - tnow, first_try);
+		first_try = false;
+		tnow = gettimeofday_ms();
+	} while ((stat_zcopies != num_sends) && (tnow < tstop));
+}
+
 static int send_tcp(int fd, char *data)
 {
 	int ret, done = 0, count = 0;
@@ -413,7 +429,8 @@ static int send_udp_segment(int fd, char *data)
 
 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
+	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] "
+		    "[-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
 		    filepath);
 }
 
@@ -423,7 +440,7 @@ static void parse_opts(int argc, char **argv)
 	int max_len, hdrlen;
 	int c;
 
-	while ((c = getopt(argc, argv, "46acC:D:Hl:mM:p:s:PS:tTuvz")) != -1) {
+	while ((c = getopt(argc, argv, "46acC:D:Hl:L:mM:p:s:PS:tTuvz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -452,6 +469,9 @@ static void parse_opts(int argc, char **argv)
 		case 'l':
 			cfg_runtime_ms = strtoul(optarg, NULL, 10) * 1000;
 			break;
+		case 'L':
+			cfg_poll_loop_timeout_ms = strtoul(optarg, NULL, 10) * 1000;
+			break;
 		case 'm':
 			cfg_sendmmsg = true;
 			break;
@@ -679,7 +699,7 @@ int main(int argc, char **argv)
 			num_sends += send_udp(fd, buf[i]);
 		num_msgs++;
 		if ((cfg_zerocopy && ((num_msgs & 0xF) == 0)) || cfg_tx_tstamp)
-			flush_errqueue(fd, cfg_poll);
+			flush_errqueue(fd, cfg_poll, 500, true);
 
 		if (cfg_msg_nr && num_msgs >= cfg_msg_nr)
 			break;
@@ -698,7 +718,7 @@ int main(int argc, char **argv)
 	} while (!interrupted && (cfg_runtime_ms == -1 || tnow < tstop));
 
 	if (cfg_zerocopy || cfg_tx_tstamp)
-		flush_errqueue(fd, true);
+		flush_errqueue_retry(fd, num_sends);
 
 	if (close(fd))
 		error(1, errno, "close");
-- 
2.34.1

