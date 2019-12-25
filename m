Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D96C12A902
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfLYTEu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:50 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37473 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:49 -0500
Received: by mail-pj1-f65.google.com with SMTP id m13so2582952pjb.2
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8BM4lmgMz7f1OUZm6GWOmaJ8rrEuG2SU2JKwCv1rhQ8=;
        b=Bo78ttC9HMGVG7YmNlT/WMpbxXtEtg4VAQ9IUBgBOKfDTQZ932lOkPzK8WO+nTGtX2
         uhGVxa0E+BOkI20AGRYJNgl8r5gkXEsCdikk0YjcgmAVYoSazJQcKcLW3MHfs0Y1t2V2
         2brDIOUXlhzrv9wWymoYMVGVDPPDkxWyCDQn1iRGnZIAvKVWrOFsKQiMJW0ODhX5CTSS
         d5M6XkYmghgakRmfTwNiImZe0m+ksay5bgfvLcsqhhvEhgw5PaAY5WYQUBDuSazntCtW
         U9Rkcr/Oxgsq/tCTWtp7wKkDOH4K2B06GyuUd72h2nZITnp1H7bjdVIjyvFWGs7aJ628
         +Crw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8BM4lmgMz7f1OUZm6GWOmaJ8rrEuG2SU2JKwCv1rhQ8=;
        b=Z9JHMQw+SFeN1+LuPH77u71x+DHOo4RA33FvETCaivggmNTuOAqz3Bicpznnw/JsaY
         GV/dE74LI26Bl9tyi2qNWbzKyFD7nnSD59fmzmdGPrPNokVnjIgVPjj4JmFejRTd+7r+
         VcDXovA8cBGjt2uRHMy0a0Qh6uQTOuauzQk5ANPQOWyPLC7PJPU4qVDIhTcOm6PvG2Y9
         ihCoOkHuATS4CK/QkU3BQadeBFEGOutfo9pzN50cnFFwuK6+CYjsJ39s93sZIYnabRtj
         Q5+oe3oMSJtjYJHy1QoamhntLmFSbfpJLmJz+K+M5vhCEbfj5r5o4BLXb9GIsFhrTEW0
         N6Kw==
X-Gm-Message-State: APjAAAXK3Esgn+btDEpjk5Suy89ldiWgFkbKMjzwZvsUZ8zAad6KTYq6
        hisjyqWDza9wNYT1myIK/vVK2xFeYgI=
X-Google-Smtp-Source: APXvYqwCVZsgZE+DJbiSA49LWcJuR8C/Tuv2QzQkWk1KDMI3qE91j4OpOdfbfAAkJH+yThFwA9Fg+Q==
X-Received: by 2002:a17:902:788e:: with SMTP id q14mr42467093pll.305.1577300688754;
        Wed, 25 Dec 2019 11:04:48 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:48 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 08/10] tc: sfq: add support for JSON output
Date:   Thu, 26 Dec 2019 00:34:16 +0530
Message-Id: <20191225190418.8806-9-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable proper JSON output for the SFQ Qdisc.
Use the long double format specifier to print the value of
"probability".
Also, fix the indentation in the online output of the contents in the
tc_sfqred_stats structure.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_sfq.c | 66 ++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 42 insertions(+), 24 deletions(-)

diff --git a/tc/q_sfq.c b/tc/q_sfq.c
index 4998921d..2b9bbcd2 100644
--- a/tc/q_sfq.c
+++ b/tc/q_sfq.c
@@ -217,35 +217,53 @@ static int sfq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (RTA_PAYLOAD(opt) >= sizeof(*qopt_ext))
 		qopt_ext = RTA_DATA(opt);
 	qopt = RTA_DATA(opt);
-	fprintf(f, "limit %up ", qopt->limit);
-	fprintf(f, "quantum %s ", sprint_size(qopt->quantum, b1));
+
+	print_uint(PRINT_ANY, "limit", "limit %up ", qopt->limit);
+	print_uint(PRINT_JSON, "quantum", NULL, qopt->quantum);
+	print_string(PRINT_FP, NULL, "quantum %s ",
+		     sprint_size(qopt->quantum, b1));
+
 	if (qopt_ext && qopt_ext->depth)
-		fprintf(f, "depth %u ", qopt_ext->depth);
+		print_uint(PRINT_ANY, "depth", "depth %u ", qopt_ext->depth);
 	if (qopt_ext && qopt_ext->headdrop)
-		fprintf(f, "headdrop ");
+		print_bool(PRINT_ANY, "headdrop", "headdrop ", true);
+	if (show_details)
+		print_uint(PRINT_ANY, "flows", "flows %u ", qopt->flows);
+
+	print_uint(PRINT_ANY, "divisor", "divisor %u ", qopt->divisor);
 
-	if (show_details) {
-		fprintf(f, "flows %u/%u ", qopt->flows, qopt->divisor);
-	}
-	fprintf(f, "divisor %u ", qopt->divisor);
 	if (qopt->perturb_period)
-		fprintf(f, "perturb %dsec ", qopt->perturb_period);
+		print_int(PRINT_ANY, "perturb", "perturb %dsec ",
+			   qopt->perturb_period);
 	if (qopt_ext && qopt_ext->qth_min) {
-		fprintf(f, "\n ewma %u ", qopt_ext->Wlog);
-		fprintf(f, "min %s max %s probability %g ",
-			sprint_size(qopt_ext->qth_min, b2),
-			sprint_size(qopt_ext->qth_max, b3),
-			qopt_ext->max_P / pow(2, 32));
+		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt_ext->Wlog);
+		print_uint(PRINT_JSON, "min", NULL, qopt_ext->qth_min);
+		print_string(PRINT_FP, NULL, "min %s ",
+			     sprint_size(qopt_ext->qth_min, b2));
+		print_uint(PRINT_JSON, "max", NULL, qopt_ext->qth_max);
+		print_string(PRINT_FP, NULL, "max %s ",
+			     sprint_size(qopt_ext->qth_max, b3));
+		print_float(PRINT_ANY, "probability", "probability %lg ",
+			    qopt_ext->max_P / pow(2, 32));
 		tc_red_print_flags(qopt_ext->flags);
 		if (show_stats) {
-			fprintf(f, "\n prob_mark %u prob_mark_head %u prob_drop %u",
-				qopt_ext->stats.prob_mark,
-				qopt_ext->stats.prob_mark_head,
-				qopt_ext->stats.prob_drop);
-			fprintf(f, "\n forced_mark %u forced_mark_head %u forced_drop %u",
-				qopt_ext->stats.forced_mark,
-				qopt_ext->stats.forced_mark_head,
-				qopt_ext->stats.forced_drop);
+			print_nl();
+			print_uint(PRINT_ANY, "prob_mark", "  prob_mark %u",
+				   qopt_ext->stats.prob_mark);
+			print_uint(PRINT_ANY, "prob_mark_head",
+				   " prob_mark_head %u",
+				   qopt_ext->stats.prob_mark_head);
+			print_uint(PRINT_ANY, "prob_drop", " prob_drop %u",
+				   qopt_ext->stats.prob_drop);
+			print_nl();
+			print_uint(PRINT_ANY, "forced_mark",
+				   "  forced_mark %u",
+				   qopt_ext->stats.forced_mark);
+			print_uint(PRINT_ANY, "forced_mark_head",
+				   " forced_mark_head %u",
+				   qopt_ext->stats.forced_mark_head);
+			print_uint(PRINT_ANY, "forced_drop", " forced_drop %u",
+				   qopt_ext->stats.forced_drop);
 		}
 	}
 	return 0;
@@ -262,8 +280,8 @@ static int sfq_print_xstats(struct qdisc_util *qu, FILE *f,
 		return -1;
 	st = RTA_DATA(xstats);
 
-	fprintf(f, " allot %d ", st->allot);
-	fprintf(f, "\n");
+	print_int(PRINT_ANY, "allot", "  allot %d", st->allot);
+
 	return 0;
 }
 
-- 
2.17.1

