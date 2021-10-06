Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCD3D423D47
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 13:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbhJFLu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 07:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238615AbhJFLuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 07:50:06 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACA4C061772;
        Wed,  6 Oct 2021 04:48:04 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d8so8764773edx.9;
        Wed, 06 Oct 2021 04:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UzgnEBfEy8GITMpLw3dCBMiAJFduwV8u4GzYFR+Amz8=;
        b=VNzQpuNASk12h/qIDrkjwE5DLpVV0k5g33AmttoauD5vw+Mt4OIFhYDmHu5H7sWwcF
         c2fQPrELKOu37tgzts7WWa7H+YqzzRhxTBwHxyk/YE7e5o2gTz8DUuBVUxs2A/xIqbUL
         N6D773eX0BCz/NzvdC30G3QH4nDyDgUcIrXn1Ye9aP5BkhEIcNZlyAiyUuvVV1T0lYty
         nLdgSyxrM8tbQ0zRC4hhU6iNdWCe1Bgk0HoOcV4bSc2Gx6wzlUArDPs30FGZdUrl2g3r
         zsbvJzXWa3Ms+Rep39gajupjCvC4+5HU9J+ACKzY2VudfW8lUDxO5jLvKPMK66nwl3f8
         GtlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UzgnEBfEy8GITMpLw3dCBMiAJFduwV8u4GzYFR+Amz8=;
        b=HvlTj+xnn6Z1xFmz0mQgx/ZA16W0FmBDwiMNHR05rE3FuHMeppSN+KQU5pbd2PZwV2
         ywdCtEqDohVn43s7Zq1Y/CqnJEAA/SQko2l0r1cH5OUI+IJ/ZwM/QZdBpLxQM8bd56/9
         9v1rE5noGrgI1k67CA0/abBKnZmr7T2LkocUfNPujBNgtpwkEdqLsfsJ8HoMabLzMwxX
         bSR2NcWeDPmheIREn5zkJr/2r9FhZTuWH/ay46gq0UNUij9Vzr/fMUzfMhW2rmFVmXo3
         5DmgPugSgWY+Qt9o2dvuq1oLaeTy9u6a1dNc3ztpijtKo8nFn3tlCxzBIdPIscP1Lmn0
         TdNQ==
X-Gm-Message-State: AOAM5338u0EyJI7E7k6slzm8KSNeFUouDEJOIp0mLHl6YrVJZZ285JfZ
        dMyIshWUwWLjrbvmGV+2fws=
X-Google-Smtp-Source: ABdhPJwMD6nSBGOh5piuQ9ajkXRfLh7Bf8LPnoeIY5d5PVXj4ZL1Z+U+yLMao/gHVvorYbF8yOTlNQ==
X-Received: by 2002:a17:906:3281:: with SMTP id 1mr31239704ejw.167.1633520882849;
        Wed, 06 Oct 2021 04:48:02 -0700 (PDT)
Received: from localhost.localdomain ([95.76.3.69])
        by smtp.gmail.com with ESMTPSA id y40sm1402187ede.31.2021.10.06.04.48.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 04:48:02 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, Shuah Khan <shuah@kernel.org>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] selftests: nettest: Convert timeout to miliseconds
Date:   Wed,  6 Oct 2021 14:47:25 +0300
Message-Id: <5a320aefed743c2a0e64c3cb30b3e258db013d1b.1633520807.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1633520807.git.cdleonard@gmail.com>
References: <cover.1633520807.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows tests to be faster

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/nettest.c | 52 +++++++++++++++++++++------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index 576d8bb4c94c..eb6c8cf69a74 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -125,18 +125,24 @@ struct sock_args {
 	/* ESP in UDP encap test */
 	int use_xfrm;
 };
 
 static int server_mode;
-static unsigned int prog_timeout = 5;
+static unsigned int prog_timeout_ms = 5000;
 static unsigned int interactive;
 static int iter = 1;
 static char *msg = "Hello world!";
 static int msglen;
 static int quiet;
 static int try_broadcast = 1;
 
+static void set_timeval_ms(struct timeval *tv, unsigned long ms)
+{
+	tv->tv_sec = ms / 1000;
+	tv->tv_usec = (ms % 1000) * 1000;
+}
+
 static char *timestamp(char *timebuf, int buflen)
 {
 	time_t now;
 
 	now = time(NULL);
@@ -566,10 +572,29 @@ static int str_to_uint(const char *str, int min, int max, unsigned int *value)
 	}
 
 	return -1;
 }
 
+/* parse seconds with a decimal point as miliseconds */
+static int str_to_msec(const char *str, unsigned int *value)
+{
+	float float_value;
+	char *end;
+
+	float_value = strtof(str, &end);
+
+	/* entire string should be consumed by conversion
+	 * and value should be between min and max
+	 */
+	if (((*end == '\0') || (*end == '\n')) && (end != str)) {
+		*value = float_value * 1000;
+		return 0;
+	}
+
+	return -1;
+}
+
 static int resolve_devices(struct sock_args *args)
 {
 	if (args->dev) {
 		args->ifindex = get_ifidx(args->dev);
 		if (args->ifindex < 0) {
@@ -1165,11 +1190,11 @@ static void set_recv_attr(int sd, int version)
 }
 
 static int msg_loop(int client, int sd, void *addr, socklen_t alen,
 		    struct sock_args *args)
 {
-	struct timeval timeout = { .tv_sec = prog_timeout }, *ptval = NULL;
+	struct timeval timeout, *ptval = NULL;
 	fd_set rfds;
 	int nfds;
 	int rc;
 
 	if (args->type != SOCK_STREAM)
@@ -1182,13 +1207,15 @@ static int msg_loop(int client, int sd, void *addr, socklen_t alen,
 		if (client) {
 			if (send_msg(sd, addr, alen, args))
 				return 1;
 		}
 		if (!interactive) {
+			if (!prog_timeout_ms)
+				set_timeval_ms(&timeout, 5000);
+			else
+				set_timeval_ms(&timeout, prog_timeout_ms);
 			ptval = &timeout;
-			if (!prog_timeout)
-				timeout.tv_sec = 5;
 		}
 	}
 
 	nfds = interactive ? MAX(fileno(stdin), sd)  + 1 : sd + 1;
 	while (1) {
@@ -1479,11 +1506,11 @@ static void ipc_write(int fd, int message)
 }
 
 static int do_server(struct sock_args *args, int ipc_fd)
 {
 	/* ipc_fd = -1 if no parent process to signal */
-	struct timeval timeout = { .tv_sec = prog_timeout }, *ptval = NULL;
+	struct timeval timeout, *ptval = NULL;
 	unsigned char addr[sizeof(struct sockaddr_in6)] = {};
 	socklen_t alen = sizeof(addr);
 	int lsd, csd = -1;
 
 	fd_set rfds;
@@ -1501,12 +1528,14 @@ static int do_server(struct sock_args *args, int ipc_fd)
 	args->dev = args->server_dev;
 	args->expected_dev = args->expected_server_dev;
 	if (resolve_devices(args) || validate_addresses(args))
 		goto err_exit;
 
-	if (prog_timeout)
+	if (prog_timeout_ms) {
+		set_timeval_ms(&timeout, prog_timeout_ms);
 		ptval = &timeout;
+	}
 
 	if (args->has_grp)
 		lsd = msock_server(args);
 	else
 		lsd = lsock_init(args);
@@ -1584,20 +1613,22 @@ static int do_server(struct sock_args *args, int ipc_fd)
 	return 1;
 }
 
 static int wait_for_connect(int sd)
 {
-	struct timeval _tv = { .tv_sec = prog_timeout }, *tv = NULL;
+	struct timeval _tv, *tv = NULL;
 	fd_set wfd;
 	int val = 0, sz = sizeof(val);
 	int rc;
 
 	FD_ZERO(&wfd);
 	FD_SET(sd, &wfd);
 
-	if (prog_timeout)
+	if (prog_timeout_ms) {
+		set_timeval_ms(&_tv, prog_timeout_ms);
 		tv = &_tv;
+	}
 
 	rc = select(FD_SETSIZE, NULL, &wfd, NULL, tv);
 	if (rc == 0) {
 		log_error("connect timed out\n");
 		return -2;
@@ -1945,12 +1976,11 @@ int main(int argc, char *argv[])
 				return 1;
 			}
 			args.port = (unsigned short) tmp;
 			break;
 		case 't':
-			if (str_to_uint(optarg, 0, INT_MAX,
-					&prog_timeout) != 0) {
+			if (str_to_msec(optarg, &prog_timeout_ms) != 0) {
 				fprintf(stderr, "Invalid timeout\n");
 				return 1;
 			}
 			break;
 		case 'D':
@@ -2091,11 +2121,11 @@ int main(int argc, char *argv[])
 			"Fork after listen only supported for server mode\n");
 		return 1;
 	}
 
 	if (interactive) {
-		prog_timeout = 0;
+		prog_timeout_ms = 0;
 		msg = NULL;
 	}
 
 	if (both_mode) {
 		if (pipe(fd) < 0) {
-- 
2.25.1

