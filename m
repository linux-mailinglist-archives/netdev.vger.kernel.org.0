Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEF912A900
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbfLYTEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:44 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37761 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:43 -0500
Received: by mail-pl1-f193.google.com with SMTP id c23so9671105plz.4
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CPrWCJ0Wg1MOU5b+rweHaFZhX0i6NpV2QOswsjpE9I0=;
        b=gHCkwimqAabukCpNyJGtrtCoRTc3moyGvuWlaffTINCIxv74NXDa3B8sp0+4Xox9x+
         bYr234ET3gelE5kcWQHBmbvpYvcLdpjMnYfO0QSXZ/qTq3CwVelLay1LirnW5jvef2dQ
         Fq+mWsx7FdBEIDHbo/PhUj2iOqUR4pgVxQkcoHmhu9JXzN2NZPE8RVCZJH8r7qFnKmJB
         o1So+j87FOrxAqNuvg0mLmeSc/LR1c7zfdHvecz+cQ7D5xCJL+dt9LYO4qrWm1fBeaG8
         3hXC4gfS96vWLDvTFc6YW6tvLsBL5DI8Hgl5eqPY6pRGOLo6Mzwy83p+srsQkrGRpi+D
         bAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CPrWCJ0Wg1MOU5b+rweHaFZhX0i6NpV2QOswsjpE9I0=;
        b=Ye/LyS+hgZkNsTMtTHsz7DWa3Uy9Xn6/ht7n9lsdyKGB45zwLx9kHzth6CH8aVGq2u
         bTPF8uYBd5HPUObzp0Da5Wm2NfUnxyte0Bugx+EGXY8BUiFYOTTGN5NxZjEFvf6SG2/8
         cNiZpw1csFAARz5qZU+/iNXmfXTaXpKQSYJ6HXu+M+fxnVIARpHxfQYu+px6ZAr3u4Qm
         Uxz1d/moU+4HIb4uCRaMdw2gXGeORei9z9RQFQ0YLoUpUW+03Gzm8oMqSJSWoX/2QUnl
         UiUvEnA1RV7TagJDOgUGP0qClq3d62nX5vLn9YmBS5h1kWovmWap2s7ePVh3NgxrjU87
         eZTQ==
X-Gm-Message-State: APjAAAXEq39sZq8MYf1I/Q7jlLfFVcaYn7dCsT+wH7WSRVxbLfVHU07D
        Q7Mab1E2j4QR4KBeVIVNcXoUCxV65DU=
X-Google-Smtp-Source: APXvYqwrz448MkQhv3bPiUwsNrH+kWXZcenwkxFDDb3NdfNg8LVWCMbb62Zx/H1afuF+SAUbFpe9DQ==
X-Received: by 2002:a17:902:d915:: with SMTP id c21mr42561362plz.295.1577300682499;
        Wed, 25 Dec 2019 11:04:42 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:41 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 06/10] tc: pie: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:14 +0530
Message-Id: <20191225190418.8806-7-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the PIE Qdisc.
Use sprint_time() to print the value of tc_pie_xstats->delay.
Use the long double format specifier to print tc_pie_xstats->prob.
Also, fix the indentation in the oneline output of statistics and update
the man page to reflect this change.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 man/man8/tc-pie.8 | 16 ++++++++--------
 tc/q_pie.c        | 47 ++++++++++++++++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 25 deletions(-)

diff --git a/man/man8/tc-pie.8 b/man/man8/tc-pie.8
index bdcfba51..0db97d13 100644
--- a/man/man8/tc-pie.8
+++ b/man/man8/tc-pie.8
@@ -107,32 +107,32 @@ is turned off.
    qdisc pie 8036: dev eth0 root refcnt 2 limit 1000p target 15.0ms tupdate 16.0ms alpha 2 beta 20
     Sent 31216108 bytes 20800 pkt (dropped 80, overlimits 0 requeues 0)
     backlog 16654b 11p requeues 0
-   prob 0.006161 delay 15666us
-   pkts_in 20811 overlimit 0 dropped 80 maxq 50 ecn_mark 0
+     prob 0.006161 delay 15666us
+     pkts_in 20811 overlimit 0 dropped 80 maxq 50 ecn_mark 0
 
  # tc qdisc add dev eth0 root pie dq_rate_estimator
  # tc -s qdisc show
    qdisc pie 8036: dev eth0 root refcnt 2 limit 1000p target 15.0ms tupdate 16.0ms alpha 2 beta 20
     Sent 63947420 bytes 42414 pkt (dropped 41, overlimits 0 requeues 0)
     backlog 271006b 179p requeues 0
-   prob 0.000092 delay 22200us avg_dq_rate 12145996
-   pkts_in 41 overlimit 343 dropped 0 maxq 50 ecn_mark 0
+     prob 0.000092 delay 22200us avg_dq_rate 12145996
+     pkts_in 41 overlimit 343 dropped 0 maxq 50 ecn_mark 0
 
  # tc qdisc add dev eth0 root pie limit 100 target 20ms tupdate 30ms ecn
  # tc -s qdisc show
    qdisc pie 8036: dev eth0 root refcnt 2 limit 100p target 20.0ms tupdate 32.0ms alpha 2 beta 20 ecn
     Sent 6591724 bytes 4442 pkt (dropped 27, overlimits 0 requeues 0)
     backlog 18168b 12p requeues 0
-   prob 0.008845 delay 11348us
-   pkts_in 4454 overlimit 0 dropped 27 maxq 65 ecn_mark 0
+     prob 0.008845 delay 11348us
+     pkts_in 4454 overlimit 0 dropped 27 maxq 65 ecn_mark 0
 
  # tc qdisc add dev eth0 root pie limit 100 target 50ms tupdate 30ms bytemode
  # tc -s qdisc show
    qdisc pie 8036: dev eth0 root refcnt 2 limit 100p target 50.0ms tupdate 32.0ms alpha 2 beta 20 bytemode
     Sent 1616274 bytes 1137 pkt (dropped 0, overlimits 0 requeues 0)
     backlog 13626b 9p requeues 0
-   prob 0.000000 delay 0us
-   pkts_in 1146 overlimit 0 dropped 0 maxq 23 ecn_mark 0
+     prob 0.000000 delay 0us
+     pkts_in 1146 overlimit 0 dropped 0 maxq 23 ecn_mark 0
 
 .SH SEE ALSO
 .BR tc (8),
diff --git a/tc/q_pie.c b/tc/q_pie.c
index fda98a71..709a78b4 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -156,40 +156,44 @@ static int pie_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_PIE_LIMIT] &&
 	    RTA_PAYLOAD(tb[TCA_PIE_LIMIT]) >= sizeof(__u32)) {
 		limit = rta_getattr_u32(tb[TCA_PIE_LIMIT]);
-		fprintf(f, "limit %up ", limit);
+		print_uint(PRINT_ANY, "limit", "limit %up ", limit);
 	}
 	if (tb[TCA_PIE_TARGET] &&
 	    RTA_PAYLOAD(tb[TCA_PIE_TARGET]) >= sizeof(__u32)) {
 		target = rta_getattr_u32(tb[TCA_PIE_TARGET]);
-		fprintf(f, "target %s ", sprint_time(target, b1));
+		print_uint(PRINT_JSON, "target", NULL, target);
+		print_string(PRINT_FP, NULL, "target %s ",
+			     sprint_time(target, b1));
 	}
 	if (tb[TCA_PIE_TUPDATE] &&
 	    RTA_PAYLOAD(tb[TCA_PIE_TUPDATE]) >= sizeof(__u32)) {
 		tupdate = rta_getattr_u32(tb[TCA_PIE_TUPDATE]);
-		fprintf(f, "tupdate %s ", sprint_time(tupdate, b1));
+		print_uint(PRINT_JSON, "tupdate", NULL, tupdate);
+		print_string(PRINT_FP, NULL, "tupdate %s ",
+			     sprint_time(tupdate, b1));
 	}
 	if (tb[TCA_PIE_ALPHA] &&
 	    RTA_PAYLOAD(tb[TCA_PIE_ALPHA]) >= sizeof(__u32)) {
 		alpha = rta_getattr_u32(tb[TCA_PIE_ALPHA]);
-		fprintf(f, "alpha %u ", alpha);
+		print_uint(PRINT_ANY, "alpha", "alpha %u ", alpha);
 	}
 	if (tb[TCA_PIE_BETA] &&
 	    RTA_PAYLOAD(tb[TCA_PIE_BETA]) >= sizeof(__u32)) {
 		beta = rta_getattr_u32(tb[TCA_PIE_BETA]);
-		fprintf(f, "beta %u ", beta);
+		print_uint(PRINT_ANY, "beta", "beta %u ", beta);
 	}
 
 	if (tb[TCA_PIE_ECN] && RTA_PAYLOAD(tb[TCA_PIE_ECN]) >= sizeof(__u32)) {
 		ecn = rta_getattr_u32(tb[TCA_PIE_ECN]);
 		if (ecn)
-			fprintf(f, "ecn ");
+			print_bool(PRINT_ANY, "ecn", "ecn ", true);
 	}
 
 	if (tb[TCA_PIE_BYTEMODE] &&
 	    RTA_PAYLOAD(tb[TCA_PIE_BYTEMODE]) >= sizeof(__u32)) {
 		bytemode = rta_getattr_u32(tb[TCA_PIE_BYTEMODE]);
 		if (bytemode)
-			fprintf(f, "bytemode ");
+			print_bool(PRINT_ANY, "bytemode", "bytemode ", true);
 	}
 
 	if (tb[TCA_PIE_DQ_RATE_ESTIMATOR] &&
@@ -197,7 +201,8 @@ static int pie_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 		dq_rate_estimator =
 				rta_getattr_u32(tb[TCA_PIE_DQ_RATE_ESTIMATOR]);
 		if (dq_rate_estimator)
-			fprintf(f, "dq_rate_estimator ");
+			print_bool(PRINT_ANY, "dq_rate_estimator",
+				   "dq_rate_estimator ", true);
 	}
 
 	return 0;
@@ -208,6 +213,8 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
 {
 	struct tc_pie_xstats *st;
 
+	SPRINT_BUF(b1);
+
 	if (xstats == NULL)
 		return 0;
 
@@ -215,18 +222,24 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
 		return -1;
 
 	st = RTA_DATA(xstats);
-	/*prob is returned as a fracion of maximum integer value */
-	fprintf(f, "prob %f delay %uus",
-		(double)st->prob / (double)UINT64_MAX, st->delay);
+
+	/* prob is returned as a fracion of maximum integer value */
+	print_float(PRINT_ANY, "prob", "  prob %lg",
+		    (double)st->prob / (double)UINT64_MAX);
+	print_uint(PRINT_JSON, "delay", NULL, st->delay);
+	print_string(PRINT_FP, NULL, " delay %s", sprint_time(st->delay, b1));
 
 	if (st->dq_rate_estimating)
-		fprintf(f, " avg_dq_rate %u\n", st->avg_dq_rate);
-	else
-		fprintf(f, "\n");
+		print_uint(PRINT_ANY, "avg_dq_rate", " avg_dq_rate %u",
+			   st->avg_dq_rate);
+
+	print_nl();
+	print_uint(PRINT_ANY, "pkts_in", "  pkts_in %u", st->packets_in);
+	print_uint(PRINT_ANY, "overlimit", " overlimit %u", st->overlimit);
+	print_uint(PRINT_ANY, "dropped", " dropped %u", st->dropped);
+	print_uint(PRINT_ANY, "maxq", " maxq %u", st->maxq);
+	print_uint(PRINT_ANY, "ecn_mark", " ecn_mark %u", st->ecn_mark);
 
-	fprintf(f, "pkts_in %u overlimit %u dropped %u maxq %u ecn_mark %u\n",
-		st->packets_in, st->overlimit, st->dropped, st->maxq,
-		st->ecn_mark);
 	return 0;
 
 }
-- 
2.17.1

