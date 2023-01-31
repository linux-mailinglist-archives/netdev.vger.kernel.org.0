Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AFC683835
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjAaVBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbjAaVBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:01:16 -0500
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CE499
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:01:15 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EECEB3F18C
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1675198873;
        bh=etom2qVxb9kUkl83UlutiswUofv0UufWb2skcOFCPPw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version;
        b=SXIMgrHbyfUSKwtXhmBHEFX14tKGCTAe+ECqlIS6wiK25EedCq74MqdJRd+KatoSJ
         O+OLy/zOWez9EPgQ+ctTZrQp2x9oNGWPcgP7FtqRFePMI5Szw9r+CisQdmTIWfn4ZI
         BGY8ESgNbYUC2Ml0a8UJ1cFXhtZzQYq0eIAN3wabIjnNhvJfyJctzXdSt+O+QotoFC
         5S2Tq8D2W6BHXdI+CfbW3Xv2Nfcc0y61pRtz4Hwn0ScW9PWesEOaeRNEmrQBgxY+KJ
         +bmbeDnFsPo6kk9FIjT1lB/20QN8siwyaXas1PGEnEI0JpJnV2a7aShqgoDn1hbHNa
         w9t1KuGinoLjg==
Received: by mail-wm1-f70.google.com with SMTP id h18-20020a05600c351200b003dc25fc1849so9251983wmq.6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:01:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=etom2qVxb9kUkl83UlutiswUofv0UufWb2skcOFCPPw=;
        b=A/z+p2gW+AcSu88yu7QyyWqP1wIrpS/spW3xJYY90Xo7+zrh+JZUw/GRwDCSmBmI0Y
         wsyyADhGBCqB4NYiNxul9RcYy9e4eNe4+9+Gd++T+65QuRLh1A07a41EMDVI/kYxJqsN
         zhhhSRv4mGnG3xWlDIkY2AvUoazesp7/yhWWmftg2L7E5H2yIPdsHc/rynPXpwcXI7vQ
         orbacbwaYofmmi/My0WcyQM7kfbjb8dDHA1mjVfig0xMFi24bxzAAfv+RBe5K/6J/A4b
         LLTuRYrfgyEhqveGTwmzlDTe6hcMN59X8cg3xilLrSY1JTHe3PS43rBtTGNDsTs9JyqI
         BvXw==
X-Gm-Message-State: AO0yUKX3lZQyuWIdbHN9Xeo0ZPEYbW0FLAkU6m1Bc8ztY723UZbJXzSM
        4OOqb7GBjw9NdxVy1hJzRfMYbxCAFplgv/qc9MBGs1M5lH1YbYPqcPkgS2mosQNb9elW4irfeyA
        2LvW/Xp7ydWUwsFSqJ+tt+9XMLj7uhJsBdQ==
X-Received: by 2002:a5d:5092:0:b0:2bf:ee58:72b1 with SMTP id a18-20020a5d5092000000b002bfee5872b1mr325262wrt.23.1675198871554;
        Tue, 31 Jan 2023 13:01:11 -0800 (PST)
X-Google-Smtp-Source: AK7set8tasggKf/Rx9l1go+kcn/gV3gCYWXptSmptiXfMWE21yhGCKkWfePVwItC66FiAsdLnfbQow==
X-Received: by 2002:a5d:5092:0:b0:2bf:ee58:72b1 with SMTP id a18-20020a5d5092000000b002bfee5872b1mr325240wrt.23.1675198871377;
        Tue, 31 Jan 2023 13:01:11 -0800 (PST)
Received: from qwirkle.internal ([81.2.157.149])
        by smtp.gmail.com with ESMTPSA id t27-20020adfa2db000000b002366553eca7sm15530408wra.83.2023.01.31.13.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 13:01:10 -0800 (PST)
From:   Andrei Gherzan <andrei.gherzan@canonical.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Fred Klassen <fklassen@appneta.com>
Cc:     Willem de Bruijn <willemb@google.com>,
        Andrei Gherzan <andrei.gherzan@canonical.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 4/4] selftests: net: udpgso_bench_tx: Cater for pending datagrams zerocopy benchmarking
Date:   Tue, 31 Jan 2023 21:00:51 +0000
Message-Id: <20230131210051.475983-4-andrei.gherzan@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
index b47b5c32039f..ef887842522a 100644
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
+		unsigned long poll_timeout, const bool poll_err)
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

