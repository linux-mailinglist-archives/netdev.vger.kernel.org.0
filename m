Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4E7188DF6
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgCQT05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:26:57 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38331 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgCQT04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:26:56 -0400
Received: by mail-pg1-f194.google.com with SMTP id x7so12271280pgh.5
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 12:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3C5KkwEzy2bBiVbwdCPxKG2NiX9VPV/Zzg0DN8mIJXU=;
        b=midwy7/U5/NkSwnrOUjsdPBuWJRvcD3MNJg6XuPBLQJA4G9rcUXH6wcKI8FFYRlrCK
         rX6XlnDNbWVlTPeq2H7gX1+y7uRuS7jBB+cKvYm78k/iurQKiBJKakfGZvVWgKHzUatb
         dmG+o9NAx7HnOp0oNCbeUxs/RfM+unC1BdCz+bmIU6EmzF5Y+11ML6xNDYDDMYo/gIsy
         EcceDlqiaXHiu1wnCdZBTUPVrvl+RVhEXwZoSz0JWAacYqW8AxyvVaHalPlNSb4idzLV
         C4EspqH45A8fOgDG4SkjM5Ln1bdqtXSpiFbhYRi2fTT3p/YfNL3tY+PUObRzln/yzmwF
         76OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3C5KkwEzy2bBiVbwdCPxKG2NiX9VPV/Zzg0DN8mIJXU=;
        b=FiZNnS3a2qryu42TbrcbXCyzTjuSbNPikJd+BVbl3SlHMsnOAg6bzBPPN1TgFcbS4e
         1SY5/nvNZa1SB8FrTWoerCGEzdS+K1YYhAPuU4nwUBGoXtemnZyZ5avCEVouSN0INMKS
         wVZLzDdd5gm719vjmC5jnYP97emuJ3h0hcsX865egt52iUXYXR66hwgDQ2lYSDhhIFfs
         ycIfgG9IICbUpvoszBbymnhAOOOlPeEsfi6kkWp99Q4jTu7A2Qr8+J7ihPCilquGbiFX
         wWW1djrZLdZvrQqHla8y34EKx+Up2Ti+n4/JBcUNeAWreS5Gm/oxgCBaUSbh7437hMYk
         Zn9A==
X-Gm-Message-State: ANhLgQ2Jo08h3y4W3olw2v3p81COq2IIGvFIoF/sLSYX77J/bzwohRtS
        p8h3UIgTGeT5yR6yMx/ifYc=
X-Google-Smtp-Source: ADFU+vs9WyF6UMW53JM+q3SDjVrOgW4cJWx25/WJKH6HN2+PSsbN8w3ugrSq++q3iO6r/JqgYFulHg==
X-Received: by 2002:a62:1894:: with SMTP id 142mr325630pfy.27.1584473215171;
        Tue, 17 Mar 2020 12:26:55 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:83ec:eccf:6871:57])
        by smtp.gmail.com with ESMTPSA id gn11sm173209pjb.42.2020.03.17.12.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 12:26:54 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next 2/5] selftests: txtimestamp: allow printing latencies in nsec.
Date:   Tue, 17 Mar 2020 12:25:06 -0700
Message-Id: <20200317192509.150725-3-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200317192509.150725-1-jianyang.kernel@gmail.com>
References: <20200317192509.150725-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

Txtimestamp reports latencies in uses resolution, while nsec is needed
in cases such as measuring latencies on localhost.

Add the following new flag:
-N: print timestamps and durations in nsec (instead of usec)

Signed-off-by: Jian Yang <jianyang@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 .../networking/timestamping/txtimestamp.c     | 56 +++++++++++++++----
 1 file changed, 44 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.c b/tools/testing/selftests/networking/timestamping/txtimestamp.c
index 7e386be47120..a9b8c41a3009 100644
--- a/tools/testing/selftests/networking/timestamping/txtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/txtimestamp.c
@@ -49,6 +49,10 @@
 #include <time.h>
 #include <unistd.h>
 
+#define NSEC_PER_USEC	1000L
+#define USEC_PER_SEC	1000000L
+#define NSEC_PER_SEC	1000000000LL
+
 /* command line parameters */
 static int cfg_proto = SOCK_STREAM;
 static int cfg_ipproto = IPPROTO_TCP;
@@ -67,6 +71,7 @@ static bool cfg_use_cmsg;
 static bool cfg_use_pf_packet;
 static bool cfg_do_listen;
 static uint16_t dest_port = 9000;
+static bool cfg_print_nsec;
 
 static struct sockaddr_in daddr;
 static struct sockaddr_in6 daddr6;
@@ -77,9 +82,14 @@ static int saved_tskey_type = -1;
 
 static bool test_failed;
 
+static int64_t timespec_to_ns64(struct timespec *ts)
+{
+	return ts->tv_sec * NSEC_PER_SEC + ts->tv_nsec;
+}
+
 static int64_t timespec_to_us64(struct timespec *ts)
 {
-	return ts->tv_sec * 1000 * 1000 + ts->tv_nsec / 1000;
+	return ts->tv_sec * USEC_PER_SEC + ts->tv_nsec / NSEC_PER_USEC;
 }
 
 static void validate_key(int tskey, int tstype)
@@ -113,25 +123,43 @@ static void validate_timestamp(struct timespec *cur, int min_delay)
 	start64 = timespec_to_us64(&ts_usr);
 
 	if (cur64 < start64 + min_delay || cur64 > start64 + max_delay) {
-		fprintf(stderr, "ERROR: delay %lu expected between %d and %d\n",
+		fprintf(stderr, "ERROR: %lu us expected between %d and %d\n",
 				cur64 - start64, min_delay, max_delay);
 		test_failed = true;
 	}
 }
 
+static void __print_ts_delta_formatted(int64_t ts_delta)
+{
+	if (cfg_print_nsec)
+		fprintf(stderr, "%lu ns", ts_delta);
+	else
+		fprintf(stderr, "%lu us", ts_delta / NSEC_PER_USEC);
+}
+
 static void __print_timestamp(const char *name, struct timespec *cur,
 			      uint32_t key, int payload_len)
 {
+	int64_t ts_delta;
+
 	if (!(cur->tv_sec | cur->tv_nsec))
 		return;
 
-	fprintf(stderr, "  %s: %lu s %lu us (seq=%u, len=%u)",
-			name, cur->tv_sec, cur->tv_nsec / 1000,
-			key, payload_len);
-
-	if (cur != &ts_usr)
-		fprintf(stderr, "  (USR %+" PRId64 " us)",
-			timespec_to_us64(cur) - timespec_to_us64(&ts_usr));
+	if (cfg_print_nsec)
+		fprintf(stderr, "  %s: %lu s %lu ns (seq=%u, len=%u)",
+				name, cur->tv_sec, cur->tv_nsec,
+				key, payload_len);
+	else
+		fprintf(stderr, "  %s: %lu s %lu us (seq=%u, len=%u)",
+				name, cur->tv_sec, cur->tv_nsec / NSEC_PER_USEC,
+				key, payload_len);
+
+	if (cur != &ts_usr) {
+		ts_delta = timespec_to_ns64(cur) - timespec_to_ns64(&ts_usr);
+		fprintf(stderr, "  (USR +");
+		__print_ts_delta_formatted(ts_delta);
+		fprintf(stderr, ")");
+	}
 
 	fprintf(stderr, "\n");
 }
@@ -526,7 +554,7 @@ static void do_test(int family, unsigned int report_opt)
 
 		/* wait for all errors to be queued, else ACKs arrive OOO */
 		if (!cfg_no_delay)
-			usleep(50 * 1000);
+			usleep(50 * NSEC_PER_USEC);
 
 		__poll(fd);
 
@@ -537,7 +565,7 @@ static void do_test(int family, unsigned int report_opt)
 		error(1, errno, "close");
 
 	free(buf);
-	usleep(100 * 1000);
+	usleep(100 * NSEC_PER_USEC);
 }
 
 static void __attribute__((noreturn)) usage(const char *filepath)
@@ -555,6 +583,7 @@ static void __attribute__((noreturn)) usage(const char *filepath)
 			"  -l N: send N bytes at a time\n"
 			"  -L    listen on hostname and port\n"
 			"  -n:   set no-payload option\n"
+			"  -N:   print timestamps and durations in nsec (instead of usec)\n"
 			"  -p N: connect to port N\n"
 			"  -P:   use PF_PACKET\n"
 			"  -r:   use raw\n"
@@ -572,7 +601,7 @@ static void parse_opt(int argc, char **argv)
 	int proto_count = 0;
 	int c;
 
-	while ((c = getopt(argc, argv, "46c:CDFhIl:Lnp:PrRuv:V:x")) != -1) {
+	while ((c = getopt(argc, argv, "46c:CDFhIl:LnNp:PrRuv:V:x")) != -1) {
 		switch (c) {
 		case '4':
 			do_ipv6 = 0;
@@ -604,6 +633,9 @@ static void parse_opt(int argc, char **argv)
 		case 'n':
 			cfg_loop_nodata = true;
 			break;
+		case 'N':
+			cfg_print_nsec = true;
+			break;
 		case 'p':
 			dest_port = strtoul(optarg, NULL, 10);
 			break;
-- 
2.25.1.481.gfbce0eb801-goog

