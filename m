Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 167E6666181
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:14:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjAKROg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbjAKROZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:14:25 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B552AFA
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:14:24 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 141so11017687pgc.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 09:14:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RNNYEg2gyXGi1z+2Hl6GfQD7MlyhChYBO7cCwCU+Kz8=;
        b=YwhHVXQ8+NE5AU10uNTDwHiss/ifLhSA/GEqIMZ/0AtnQ36Y6fMc3KenYtfTxj+BQZ
         CoR1DEuBqUjDnlmRRasqSLnXhCLPOKGU7QAW1ZUBfuGJHwSa3orGst16Mh8aJuVUv8gl
         /8wrNT5PoswjVyWWi2LDdDfkZP75yTGutgikxX7kL88JA/RU4chtN3jKvW8NPqKxGinY
         4ilsep8z+JjusaWxw/0o8J1kNCAcKdArLoPZ0xkaSrNoW1EDwuKa0sIwQqAkiSpVozsI
         C5lYF5U6TvP3Xcd//V2NxRrbmBs/gFfIuTkPXIIwku4WbVVQTJXEoqRLosfXXkzozq+8
         ou8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNNYEg2gyXGi1z+2Hl6GfQD7MlyhChYBO7cCwCU+Kz8=;
        b=p8w2D4yXYCXiakDPIsyXkND+a2d8EuV1N72fkhmhhm5JndjhZYnXPQOl90cwNy1Uy5
         5IB1o2d96JExX1MgYGDNqwZk/8SleYdKKaOX9FZYHTcykKI32X/FBevLWCM+PBcyTc09
         MD+/uqw1adpW+56awWcpjNLnTVHOufmD5eWiOM+3Tm7B19PM5YQE0qOmdXLCVgqsdFBV
         zNlDXNP8jMHtzijBJgKRlXKhuuPmyH7HHAKC/dpcgb1JUd1hxnACy5UoiRGfyUSdj68V
         zCAv5wKcRYTCOSlrQI8HKvHGBe8p1uIKJL/nfkY7ncWegiGKzpl4oyPo+acIyA3PSlMV
         zVIQ==
X-Gm-Message-State: AFqh2krUq2cYI4kyK4JgWRX7IvqRG8rpVukiIoS3Fzfj8ZJB6Uqzt2su
        2rFA0k8SVN8IL6rKzVypGNhF9iSe6Yt8APF9hKs=
X-Google-Smtp-Source: AMrXdXtg+d5P77VsBiEJv3jpgbukK2lJJjDUxx7iOh7VC7X6yeJkHeinEQkx7APSwnLmhqgkyaDN+A==
X-Received: by 2002:a62:f203:0:b0:576:b8d0:6034 with SMTP id m3-20020a62f203000000b00576b8d06034mr72911608pfh.31.1673457263546;
        Wed, 11 Jan 2023 09:14:23 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id b126-20020a62cf84000000b00574e84ed847sm75849pfg.24.2023.01.11.09.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:14:23 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute] tc: remove support for rr qdisc
Date:   Wed, 11 Jan 2023 09:14:20 -0800
Message-Id: <20230111171420.57282-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Round-Robin qdisc was removed in kernel version 2.6.27.
Remove code and man page references from iproute.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 bash-completion/tc |   4 +-
 man/man8/tc.8      |   4 --
 tc/Makefile        |   1 -
 tc/q_rr.c          | 119 ---------------------------------------------
 4 files changed, 2 insertions(+), 126 deletions(-)
 delete mode 100644 tc/q_rr.c

diff --git a/bash-completion/tc b/bash-completion/tc
index 9f16d0d481e0..8352cc94e391 100644
--- a/bash-completion/tc
+++ b/bash-completion/tc
@@ -3,7 +3,7 @@
 # Copyright 2016 Quentin Monnet <quentin.monnet@6wind.com>
 
 QDISC_KIND=' choke codel bfifo pfifo pfifo_head_drop fq fq_codel gred hhf \
-            mqprio multiq netem pfifo_fast pie fq_pie red rr sfb sfq tbf atm \
+            mqprio multiq netem pfifo_fast pie fq_pie red sfb sfq tbf atm \
             cbq drr dsmark hfsc htb prio qfq '
 FILTER_KIND=' basic bpf cgroup flow flower fw route rsvp tcindex u32 matchall '
 ACTION_KIND=' gact mirred bpf sample '
@@ -339,7 +339,7 @@ _tc_qdisc_options()
                 bandwidth ecn harddrop'
             return 0
             ;;
-        rr|prio)
+        prio)
             _tc_once_attr 'bands priomap multiqueue'
             return 0
             ;;
diff --git a/man/man8/tc.8 b/man/man8/tc.8
index 2969fb55aafc..d436d46472af 100644
--- a/man/man8/tc.8
+++ b/man/man8/tc.8
@@ -361,10 +361,6 @@ Random Early Detection simulates physical congestion by randomly dropping
 packets when nearing configured bandwidth allocation. Well suited to very
 large bandwidth applications.
 .TP
-rr
-Round-Robin qdisc with support for multiqueue network devices. Removed from
-Linux since kernel version 2.6.27.
-.TP
 sfb
 Stochastic Fair Blue is a classless qdisc to manage congestion based on
 packet loss and link utilization history while trying to prevent
diff --git a/tc/Makefile b/tc/Makefile
index 5a517af20b7c..98d2ee597a1e 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -15,7 +15,6 @@ TCMODULES += q_prio.o
 TCMODULES += q_skbprio.o
 TCMODULES += q_tbf.o
 TCMODULES += q_cbq.o
-TCMODULES += q_rr.o
 TCMODULES += q_multiq.o
 TCMODULES += q_netem.o
 TCMODULES += q_choke.o
diff --git a/tc/q_rr.c b/tc/q_rr.c
deleted file mode 100644
index 843a4faeef41..000000000000
--- a/tc/q_rr.c
+++ /dev/null
@@ -1,119 +0,0 @@
-/*
- * q_rr.c		RR.
- *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
- *
- * Authors:	PJ Waskiewicz, <peter.p.waskiewicz.jr@intel.com>
- * Original Authors:	Alexey Kuznetsov, <kuznet@ms2.inr.ac.ru> (from PRIO)
- */
-
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-#include <arpa/inet.h>
-#include <string.h>
-
-#include "utils.h"
-#include "tc_util.h"
-
-static void explain(void)
-{
-	fprintf(stderr, "Usage: ... rr bands NUMBER priomap P1 P2... [multiqueue]\n");
-}
-
-
-static int rr_parse_opt(struct qdisc_util *qu, int argc, char **argv, struct nlmsghdr *n, const char *dev)
-{
-	int pmap_mode = 0;
-	int idx = 0;
-	struct tc_prio_qopt opt = {3, { 1, 2, 2, 2, 1, 2, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1 } };
-	struct rtattr *nest;
-	unsigned char mq = 0;
-
-	while (argc > 0) {
-		if (strcmp(*argv, "bands") == 0) {
-			if (pmap_mode)
-				explain();
-			NEXT_ARG();
-			if (get_integer(&opt.bands, *argv, 10)) {
-				fprintf(stderr, "Illegal \"bands\"\n");
-				return -1;
-			}
-		} else if (strcmp(*argv, "priomap") == 0) {
-			if (pmap_mode) {
-				fprintf(stderr, "Error: duplicate priomap\n");
-				return -1;
-			}
-			pmap_mode = 1;
-		} else if (strcmp(*argv, "help") == 0) {
-			explain();
-			return -1;
-		} else if (strcmp(*argv, "multiqueue") == 0) {
-			mq = 1;
-		} else {
-			unsigned int band;
-
-			if (!pmap_mode) {
-				fprintf(stderr, "What is \"%s\"?\n", *argv);
-				explain();
-				return -1;
-			}
-			if (get_unsigned(&band, *argv, 10)) {
-				fprintf(stderr, "Illegal \"priomap\" element\n");
-				return -1;
-			}
-			if (band > opt.bands) {
-				fprintf(stderr, "\"priomap\" element is out of bands\n");
-				return -1;
-			}
-			if (idx > TC_PRIO_MAX) {
-				fprintf(stderr, "\"priomap\" index > TC_RR_MAX=%u\n", TC_PRIO_MAX);
-				return -1;
-			}
-			opt.priomap[idx++] = band;
-		}
-		argc--; argv++;
-	}
-
-	nest = addattr_nest_compat(n, 1024, TCA_OPTIONS, &opt, sizeof(opt));
-	if (mq)
-		addattr_l(n, 1024, TCA_PRIO_MQ, NULL, 0);
-	addattr_nest_compat_end(n, nest);
-	return 0;
-}
-
-static int rr_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
-{
-	int i;
-	struct tc_prio_qopt *qopt;
-	struct rtattr *tb[TCA_PRIO_MAX + 1];
-
-	if (opt == NULL)
-		return 0;
-
-	if (parse_rtattr_nested_compat(tb, TCA_PRIO_MAX, opt, qopt,
-						sizeof(*qopt)))
-		return -1;
-
-	fprintf(f, "bands %u priomap ", qopt->bands);
-	for (i = 0; i <= TC_PRIO_MAX; i++)
-		fprintf(f, " %d", qopt->priomap[i]);
-
-	if (tb[TCA_PRIO_MQ])
-		fprintf(f, " multiqueue: %s ",
-			rta_getattr_u8(tb[TCA_PRIO_MQ]) ? "on" : "off");
-
-	return 0;
-}
-
-struct qdisc_util rr_qdisc_util = {
-	.id		= "rr",
-	.parse_qopt	= rr_parse_opt,
-	.print_qopt	= rr_print_opt,
-};
-- 
2.39.0

