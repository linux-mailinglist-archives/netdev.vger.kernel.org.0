Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BA2263FF2
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 10:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbgIJIc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 04:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730538AbgIJIb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 04:31:29 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7369C0613ED;
        Thu, 10 Sep 2020 01:31:28 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o16so2670813pjr.2;
        Thu, 10 Sep 2020 01:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sSNYJQoq7VIn+vtERBylFPcQxQX6LuWyosQXlSFU3cQ=;
        b=UHcE0TK6XW0LUH+yA9/uVjm3cxevVJQZX3lUOg1MBIyA9raAg0xLnbcs8J3VQDy5xs
         3pdHdQuPgGTt+7dXNFyL3pgB5Oin7dT3RhoPtZXZtoQiePs3LaoEDedgQgI7NDcMB1Pc
         gY0cndgg9+n6pGnoJ84OdmJwt55+iWcfV83TcsVsTujfdSE69tlFJcdDH/bmYP3SATLo
         3uPKm4MoW6LqvVCDRUw8KeKYr7TuuMPBMPF1RwaszfS2rh2GLcKSAY59iNmq3FnCJdF1
         SCKhIhHUcYyn/6Z0zSUIZ9EWRmakE9kQIiRVKMvzib2IofPZ/NB5DkNhlRzR4hoR8zQ7
         xk3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sSNYJQoq7VIn+vtERBylFPcQxQX6LuWyosQXlSFU3cQ=;
        b=LBntxdedNatSoTO3Qtoz4ZuuCdCAZcs3yOoMsB+t3VANwkyokSLciIbB2sxBX0zTiv
         pL3ZIMskOy0MnCgPy+keV3/SSq3Nw5olEjml1WjJhGJfY36Pi44VMcksvpzLVslY4PN3
         YtM5iEcjEWVMY4TJ+jen4dJOKT1y1FL2DzosjAALoaQB51ws9vCaVmjEnIBhLcXviMC6
         8G1DZyju5/JdDR5oxqqqVGXZyNg66Pqgws6cKuyWsfRipmHVOS3puNDuSA5whsZdg2Wg
         INHEuqEx3kZmwWi949O0oMXFr2A5HIgFzGayHCuoPLRnVBWBWSzTC5WK35zGWWdTZP/2
         RQsw==
X-Gm-Message-State: AOAM533BHUrT+ZP9VFtclDekiZEPwXxZtexqULBUwU/IiQ7yiC2VZf3R
        EnlvYwnCKKlrPGRKZGHCCM0=
X-Google-Smtp-Source: ABdhPJxXAfEgM9tV8AlLz+vaUk2lc/oSuiwnQ6x9FyFJ93oagdyTA1EpdzmQ7jg/MS4Pcgc61E2aaQ==
X-Received: by 2002:a17:902:9303:: with SMTP id bc3mr4616620plb.170.1599726688316;
        Thu, 10 Sep 2020 01:31:28 -0700 (PDT)
Received: from VM.ger.corp.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id c7sm5183438pfj.100.2020.09.10.01.31.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 01:31:27 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/3] samples/bpf: add quiet option to xdpsock
Date:   Thu, 10 Sep 2020 10:31:06 +0200
Message-Id: <1599726666-8431-4-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
References: <1599726666-8431-1-git-send-email-magnus.karlsson@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a quiet option (-Q) that disables the statistics print outs of
xdpsock. This is good to have when measuring 0% loss rate performance
as it will be quite terrible if the application uses printfs.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 samples/bpf/xdpsock_user.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index b60bf4e..b220173 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -78,6 +78,7 @@ static int opt_pkt_count;
 static u16 opt_pkt_size = MIN_PKT_SIZE;
 static u32 opt_pkt_fill_pattern = 0x12345678;
 static bool opt_extra_stats;
+static bool opt_quiet;
 static int opt_poll;
 static int opt_interval = 1;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
@@ -718,6 +719,7 @@ static struct option long_options[] = {
 	{"tx-pkt-size", required_argument, 0, 's'},
 	{"tx-pkt-pattern", required_argument, 0, 'P'},
 	{"extra-stats", no_argument, 0, 'x'},
+	{"quiet", no_argument, 0, 'Q'},
 	{0, 0, 0, 0}
 };
 
@@ -753,6 +755,7 @@ static void usage(const char *prog)
 		"			Min size: %d, Max size %d.\n"
 		"  -P, --tx-pkt-pattern=nPacket fill pattern. Default: 0x%x\n"
 		"  -x, --extra-stats	Display extra statistics.\n"
+		"  -Q, --quiet          Do not display any stats.\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE,
 		opt_batch_size, MIN_PKT_SIZE, MIN_PKT_SIZE,
@@ -768,7 +771,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:x",
+		c = getopt_long(argc, argv, "Frtli:q:pSNn:czf:muMd:b:C:s:P:xQ",
 				long_options, &option_index);
 		if (c == -1)
 			break;
@@ -852,6 +855,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'x':
 			opt_extra_stats = 1;
 			break;
+		case 'Q':
+			opt_quiet = 1;
+			break;
 		default:
 			usage(basename(argv[0]));
 		}
@@ -1286,9 +1292,11 @@ int main(int argc, char **argv)
 
 	setlocale(LC_ALL, "");
 
-	ret = pthread_create(&pt, NULL, poller, NULL);
-	if (ret)
-		exit_with_error(ret);
+	if (!opt_quiet) {
+		ret = pthread_create(&pt, NULL, poller, NULL);
+		if (ret)
+			exit_with_error(ret);
+	}
 
 	prev_time = get_nsecs();
 	start_time = prev_time;
@@ -1302,7 +1310,8 @@ int main(int argc, char **argv)
 
 	benchmark_done = true;
 
-	pthread_join(pt, NULL);
+	if (!opt_quiet)
+		pthread_join(pt, NULL);
 
 	xdpsock_cleanup();
 
-- 
2.7.4

