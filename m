Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C717C423D4A
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238662AbhJFLua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238660AbhJFLuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:50:10 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B29BC061778;
        Wed,  6 Oct 2021 04:48:06 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id v18so8713807edc.11;
        Wed, 06 Oct 2021 04:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qOGjkZMl8DerBlT4kJpDzU8Uye/g7CHr0erytT4iSf4=;
        b=hSsgAUhJwv+j3HxImHE/DQRFOci0Fj1ma/4HX1Zi5G9Vx3RNUz6YqdspTfuuh2iGU0
         ooFtF8n3c0Kl5/k+08GhNaGpMVqFjVf4RLHi0CWuP2JIQl64JedQqWLnlwHt5d1yr8AF
         TJQCPPw6oYfn4FAnFoC2gt0oV1BirEH87zROVD+jUG/RWClU2mPS+KzoFKTd1Y3B//HO
         3SRgCFhL0kK9hjbnFRRUgHoows9CToXlYr5VbmJdg2c/z5/B7pCLHkEDw3+VgFYcS8P5
         D2wi19NSyoAifch+flAFdtIa07Y5tXwFz1h36dnKp1g1OriSD1Z+LtNHCgRtrxubk6Gh
         azFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qOGjkZMl8DerBlT4kJpDzU8Uye/g7CHr0erytT4iSf4=;
        b=oTTxjN4Nuq/krJB0uyiNKjX9Aaa6FqLfxXGM/trAQ/p0rZRviVYyye8w1TNRYwAGHH
         gDJyT1IL7LBQ4gPUdB7ilwnwNuplnZoEQ7WK3eACbquv/JVNvplMTKjWoSeAXdneBp3N
         u32yk7LSfHKLed+IGCMRiNxST6x3N3PW+tZueu+PO+Hma7fo2LdfeoEszmvCuVV+Q6nD
         Ve0iEePr12j3ohH59bauvQZf+p9Y7DW6hU0TyQoP6Vmd2t5wQg85UpXJHqoS5nOt1HPZ
         HLlJrB+ucaMFr6cPm5u0paeXnPqOl7VCg7id1mnXSUYlq28JXiKts4qbN5yrwfX4eWJE
         OkVw==
X-Gm-Message-State: AOAM531PU+T4JjVMKTD7oPijnixOB83H9cqWKn35JzaNfbdSUojFrCdT
        Y83BP9k+FBtXGUcBY2Lw81w=
X-Google-Smtp-Source: ABdhPJzJGNtNmryU+B+aCYTq/ZRvoO2qnWejJi7zLZQV+rb93P6zFXpxo/0kIl+HTwiihXs90/fQVg==
X-Received: by 2002:a17:906:7f01:: with SMTP id d1mr32126761ejr.318.1633520884077;
        Wed, 06 Oct 2021 04:48:04 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:48:03 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/11] selftests: nettest: Add NETTEST_CLIENT,SERVER}_TIMEOUT envvars
Date:   Wed,  6 Oct 2021 14:47:26 +0300
Message-Id: <ffb237e32f2d725eb782f541681b05a0319b591b.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the single "prog_timeout_ms" into sock_args and split into client
and server timeouts.

Add NETTEST_CLIENT_TIMEOUT and NETTEST_SERVER_TIMEOUT which can set a
default value different than the default of 5 seconds.

This allows exporting NETTEST_CLIENT_TIMEOUT=0.1 and running all of
fcnal-test.sh quickly.

A reduced server timeout is less useful, most tests would work fine with
an infinite timeout because nettest is launched in the background and
killed explicitly.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 66 ++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index eb6c8cf69a74..bc5976f842f9 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -122,14 +122,16 @@ struct sock_args {
 		struct in6_addr in6;
 	} expected_raddr;
 
 	/* ESP in UDP encap test */
 	int use_xfrm;
+
+	unsigned int client_timeout_ms;
+	unsigned int server_timeout_ms;
 };
 
 static int server_mode;
-static unsigned int prog_timeout_ms = 5000;
 static unsigned int interactive;
 static int iter = 1;
 static char *msg = "Hello world!";
 static int msglen;
 static int quiet;
@@ -1207,14 +1209,21 @@ static int msg_loop(int client, int sd, void *addr, socklen_t alen,
 		if (client) {
 			if (send_msg(sd, addr, alen, args))
 				return 1;
 		}
 		if (!interactive) {
-			if (!prog_timeout_ms)
+			unsigned int timeout_ms;
+
+			if (client)
+				timeout_ms = args->client_timeout_ms;
+			else
+				timeout_ms = args->server_timeout_ms;
+
+			if (!timeout_ms)
 				set_timeval_ms(&timeout, 5000);
 			else
-				set_timeval_ms(&timeout, prog_timeout_ms);
+				set_timeval_ms(&timeout, timeout_ms);
 			ptval = &timeout;
 		}
 	}
 
 	nfds = interactive ? MAX(fileno(stdin), sd)  + 1 : sd + 1;
@@ -1528,12 +1537,12 @@ static int do_server(struct sock_args *args, int ipc_fd)
 	args->dev = args->server_dev;
 	args->expected_dev = args->expected_server_dev;
 	if (resolve_devices(args) || validate_addresses(args))
 		goto err_exit;
 
-	if (prog_timeout_ms) {
-		set_timeval_ms(&timeout, prog_timeout_ms);
+	if (args->server_timeout_ms) {
+		set_timeval_ms(&timeout, args->server_timeout_ms);
 		ptval = &timeout;
 	}
 
 	if (args->has_grp)
 		lsd = msock_server(args);
@@ -1611,22 +1620,22 @@ static int do_server(struct sock_args *args, int ipc_fd)
 err_exit:
 	ipc_write(ipc_fd, 0);
 	return 1;
 }
 
-static int wait_for_connect(int sd)
+static int wait_for_connect(int sd, struct sock_args *args)
 {
 	struct timeval _tv, *tv = NULL;
 	fd_set wfd;
 	int val = 0, sz = sizeof(val);
 	int rc;
 
 	FD_ZERO(&wfd);
 	FD_SET(sd, &wfd);
 
-	if (prog_timeout_ms) {
-		set_timeval_ms(&_tv, prog_timeout_ms);
+	if (args->client_timeout_ms) {
+		set_timeval_ms(&_tv, args->client_timeout_ms);
 		tv = &_tv;
 	}
 
 	rc = select(FD_SETSIZE, NULL, &wfd, NULL, tv);
 	if (rc == 0) {
@@ -1692,11 +1701,11 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 		if (errno != EINPROGRESS) {
 			log_err_errno("Failed to connect to remote host");
 			rc = -1;
 			goto err;
 		}
-		rc = wait_for_connect(sd);
+		rc = wait_for_connect(sd, args);
 		if (rc < 0)
 			goto err;
 	}
 out:
 	return sd;
@@ -1883,11 +1892,11 @@ static void print_usage(char *prog)
 	"Required:\n"
 	"    -r addr       remote address to connect to (client mode only)\n"
 	"    -p port       port to connect to (client mode)/listen on (server mode)\n"
 	"                  (default: %d)\n"
 	"    -s            server mode (default: client mode)\n"
-	"    -t            timeout seconds (default: none)\n"
+	"    -t seconds    timeout seconds for both client and server (default: 5.000)\n"
 	"\n"
 	"Optional:\n"
 	"    -B            do both client and server via fork and IPC\n"
 	"    -N ns         set client to network namespace ns (requires root)\n"
 	"    -O ns         set server to network namespace ns (requires root)\n"
@@ -1920,19 +1929,46 @@ static void print_usage(char *prog)
 	"    -3 dev        Expected device name (or index) to receive packets - server mode\n"
 	"\n"
 	"    -b            Bind test only.\n"
 	"    -q            Be quiet. Run test without printing anything.\n"
 	"    -k            Fork server in background after bind or listen.\n"
+	"\n"
+	"Environment Variables:"
+	"\n"
+	"NETTEST_CLIENT_TIMEOUT:  timeouts in seconds for client"
+	"NETTEST_SERVER_TIMEOUT:  timeouts in seconds for server"
 	, prog, DEFAULT_PORT);
 }
 
+int parse_env(struct sock_args *args)
+{
+	const char *str;
+
+	if ((str = getenv("NETTEST_CLIENT_TIMEOUT"))) {
+		if (str_to_msec(str, &args->client_timeout_ms) != 0) {
+			fprintf(stderr, "Invalid NETTEST_CLIENT_TIMEOUT\n");
+			return 1;
+		}
+	}
+	if ((str = getenv("NETTEST_SERVER_TIMEOUT"))) {
+		if (str_to_msec(str, &args->server_timeout_ms) != 0) {
+			fprintf(stderr, "Invalid NETTEST_SERVER_TIMEOUT\n");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct sock_args args = {
 		.version = AF_INET,
 		.type    = SOCK_STREAM,
 		.port    = DEFAULT_PORT,
+		.client_timeout_ms = 5000,
+		.server_timeout_ms = 5000,
 	};
 	struct protoent *pe;
 	int both_mode = 0;
 	unsigned int tmp;
 	int forever = 0;
@@ -1941,10 +1977,14 @@ int main(int argc, char *argv[])
 
 	/* process inputs */
 	extern char *optarg;
 	int rc = 0;
 
+	rc = parse_env(&args);
+	if (rc)
+		return rc;
+
 	/*
 	 * process input args
 	 */
 
 	while ((rc = getopt(argc, argv, GETOPT_STR)) != -1) {
@@ -1976,14 +2016,15 @@ int main(int argc, char *argv[])
 				return 1;
 			}
 			args.port = (unsigned short) tmp;
 			break;
 		case 't':
-			if (str_to_msec(optarg, &prog_timeout_ms) != 0) {
+			if (str_to_msec(optarg, &args.client_timeout_ms) != 0) {
 				fprintf(stderr, "Invalid timeout\n");
 				return 1;
 			}
+			args.server_timeout_ms = args.client_timeout_ms;
 			break;
 		case 'D':
 			args.type = SOCK_DGRAM;
 			break;
 		case 'R':
@@ -2121,11 +2162,12 @@ int main(int argc, char *argv[])
 			"Fork after listen only supported for server mode\n");
 		return 1;
 	}
 
 	if (interactive) {
-		prog_timeout_ms = 0;
+		args.client_timeout_ms = 0;
+		args.server_timeout_ms = 0;
 		msg = NULL;
 	}
 
 	if (both_mode) {
 		if (pipe(fd) < 0) {
-- 
2.25.1

