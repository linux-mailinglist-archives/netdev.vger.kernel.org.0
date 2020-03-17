Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A722D188DF8
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 20:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgCQT1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 15:27:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36100 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbgCQT06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 15:26:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id z72so2422819pgz.3
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 12:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eIH780lKo/rb33F4YHloi/el+aHlsF367yBAH+X174U=;
        b=Hfc/oq3h3bpA/9jizixMvlagvZpQ0GXLYkjRUqO0Fq19WbfJMXp+TObHC8ZdauYSFJ
         k2pB15fllkfW7/x6uN0kvhVB2sibeR7SaDwMcsarb1zL/gvrsI0mRzlohYHPKLy2ZKwQ
         KL8egtdF5LrYuB/kxTbIwdY6jhN53nKof0+QTVXqIMLjmt2J5E0FAh10494/f1XpN6HY
         aZnaO2mkKalH2F3OGQLZwUl3sIkUxV8RiAzmln7wsBq1D0Go5aJQ5j3cW1fajZSFPQ+A
         Xy2sNR6yB31HnIf00AQibfJSsnd0JMFb+TdQNG2QPHawlRdlH5dO5V2JH1UuBZJ+haS0
         vCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eIH780lKo/rb33F4YHloi/el+aHlsF367yBAH+X174U=;
        b=ARFLeO7IXE7AIYBNcm/FzpMlFkoAPcr0JpKCuXY01GxSUPn3nGWo0xnPl/DJF+YZr0
         mvIpO1Lu8+s8qc3jiuEG+sxRNdIJxjAaH/swDnS4Kz8dTLoJ22Gh0hRJu0AVZIuL5rfe
         WttmedEmqRwmUMBKAEv2q1RWXjLcBXjRj4/wdpdhE+neNhS4Pep3P6jV1hoCL4ZA53d0
         A+hGMC6Re4ZpMcdcy/MYKxtCwNz/FqyBFdK2ocfT9cwFjt2O1zXgi9M6jRApHMdIPaCs
         1FgoiJeuYRb/I1oh+5w4LRUr2WVl7UGtahKStodRq3+eJRRPpcd6QfNt5LRhwLoLdwC+
         hA+w==
X-Gm-Message-State: ANhLgQ3JhPTKTa8PoVRz6B1oqh7RsXPxcTa3syfuZ6X4ylj3rffHDVDf
        umAakz7ehvbtAL8/CKUxXmNJH/Lq
X-Google-Smtp-Source: ADFU+vtNronwsRb9krrSAvV9dQslbzrgmjo5df/brKTZ42IfhwPJduzbF8s7k6u6QMasIkriSqtXeQ==
X-Received: by 2002:aa7:9d0a:: with SMTP id k10mr336857pfp.266.1584473216124;
        Tue, 17 Mar 2020 12:26:56 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:83ec:eccf:6871:57])
        by smtp.gmail.com with ESMTPSA id gn11sm173209pjb.42.2020.03.17.12.26.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 12:26:55 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: [PATCH net-next 3/5] selftests: txtimestamp: add new command-line flags.
Date:   Tue, 17 Mar 2020 12:25:07 -0700
Message-Id: <20200317192509.150725-4-jianyang.kernel@gmail.com>
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

A longer sleep duration between sendmsg()s makes more cachelines to be
evicted and results in higher latency. Making the duration configurable.

Add the following new flags:
-S: Configurable sleep duration.
-b: Busy loop instead of poll().

Remove the following flag:
-D: No delay between packets: subsumed by -S.

Signed-off-by: Jian Yang <jianyang@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
---
 .../networking/timestamping/txtimestamp.c     | 24 ++++++++++++-------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.c b/tools/testing/selftests/networking/timestamping/txtimestamp.c
index a9b8c41a3009..ee060ae3d44f 100644
--- a/tools/testing/selftests/networking/timestamping/txtimestamp.c
+++ b/tools/testing/selftests/networking/timestamping/txtimestamp.c
@@ -65,8 +65,9 @@ static int cfg_delay_snd;
 static int cfg_delay_ack;
 static bool cfg_show_payload;
 static bool cfg_do_pktinfo;
+static bool cfg_busy_poll;
+static int cfg_sleep_usec = 50 * 1000;
 static bool cfg_loop_nodata;
-static bool cfg_no_delay;
 static bool cfg_use_cmsg;
 static bool cfg_use_pf_packet;
 static bool cfg_do_listen;
@@ -553,10 +554,11 @@ static void do_test(int family, unsigned int report_opt)
 			error(1, errno, "send");
 
 		/* wait for all errors to be queued, else ACKs arrive OOO */
-		if (!cfg_no_delay)
-			usleep(50 * NSEC_PER_USEC);
+		if (cfg_sleep_usec)
+			usleep(cfg_sleep_usec);
 
-		__poll(fd);
+		if (!cfg_busy_poll)
+			__poll(fd);
 
 		while (!recv_errmsg(fd)) {}
 	}
@@ -575,9 +577,9 @@ static void __attribute__((noreturn)) usage(const char *filepath)
 			"  -4:   only IPv4\n"
 			"  -6:   only IPv6\n"
 			"  -h:   show this message\n"
+			"  -b:   busy poll to read from error queue\n"
 			"  -c N: number of packets for each test\n"
 			"  -C:   use cmsg to set tstamp recording options\n"
-			"  -D:   no delay between packets\n"
 			"  -F:   poll() waits forever for an event\n"
 			"  -I:   request PKTINFO\n"
 			"  -l N: send N bytes at a time\n"
@@ -588,6 +590,7 @@ static void __attribute__((noreturn)) usage(const char *filepath)
 			"  -P:   use PF_PACKET\n"
 			"  -r:   use raw\n"
 			"  -R:   use raw (IP_HDRINCL)\n"
+			"  -S N: usec to sleep before reading error queue\n"
 			"  -u:   use udp\n"
 			"  -v:   validate SND delay (usec)\n"
 			"  -V:   validate ACK delay (usec)\n"
@@ -601,7 +604,7 @@ static void parse_opt(int argc, char **argv)
 	int proto_count = 0;
 	int c;
 
-	while ((c = getopt(argc, argv, "46c:CDFhIl:LnNp:PrRuv:V:x")) != -1) {
+	while ((c = getopt(argc, argv, "46bc:CFhIl:LnNp:PrRS:uv:V:x")) != -1) {
 		switch (c) {
 		case '4':
 			do_ipv6 = 0;
@@ -609,15 +612,15 @@ static void parse_opt(int argc, char **argv)
 		case '6':
 			do_ipv4 = 0;
 			break;
+		case 'b':
+			cfg_busy_poll = true;
+			break;
 		case 'c':
 			cfg_num_pkts = strtoul(optarg, NULL, 10);
 			break;
 		case 'C':
 			cfg_use_cmsg = true;
 			break;
-		case 'D':
-			cfg_no_delay = true;
-			break;
 		case 'F':
 			cfg_poll_timeout = -1;
 			break;
@@ -655,6 +658,9 @@ static void parse_opt(int argc, char **argv)
 			cfg_proto = SOCK_RAW;
 			cfg_ipproto = IPPROTO_RAW;
 			break;
+		case 'S':
+			cfg_sleep_usec = strtoul(optarg, NULL, 10);
+			break;
 		case 'u':
 			proto_count++;
 			cfg_proto = SOCK_DGRAM;
-- 
2.25.1.481.gfbce0eb801-goog

