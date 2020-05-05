Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A13DB1C5C02
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgEEPnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730542AbgEEPnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:43:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82F1C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 08:43:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h129so2887531ybc.3
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 08:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=8JgpSeOkIkbqwEqU/8Ds2H2RtksZG8y7lWBYS0HQjmY=;
        b=rX428mZiCbjD3JISXDjyYFEc57JsG6XMAqLf/16ahtsNOznkY8WFrE0Qg/LzVVE4Qi
         dQcuKAuv9jKOW9dNw4g2Tauf1HxJksZfRt9YRo8WkQmhNPv+FeyDTQaMR+orrWWlVWW5
         QG1RbSPK59jxmnIe2gLrztWjYDla6wlwvr/aE55MJawKjYtyU1c41Magk1smQC9V9Olc
         273VZilJr8sJIgU4IR8Wj/tYSKtxUBlA8N+BMGhaL6t+mftU6Y5pzhm/EA0Bo3sX+fI1
         8heM75XNJg35O9IgtZbRLIuXMOVERil0cjz1ZcDOPZy/kQlUzPY5dTfcVtI2m+BpRW4d
         5DtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=8JgpSeOkIkbqwEqU/8Ds2H2RtksZG8y7lWBYS0HQjmY=;
        b=mrCfw3fbCzmHdkGp7fc1A6vCYMhMJ/5VSZB9WVQDfyrS99IGe3ZnNVpoM6V+CwgHDx
         gvjaGNuSQMRPXEBcCRRLeuBtCNA6jQsx9vu4xku7Z32bHf0tMNiWpZqd3IfZjNEDJzJ1
         Jc4qj15T2hg9a3zWltzHC2l+59WMbMAOW4zAaLtreQg+XTI6sHdCekpaKESZYt/VuzUf
         ThrJQVRnQVX3pAx3qJudKJCjeqGSPz8i7YeV8QyPeG3RA40vFW+AKHp5R3rFLgEBOBzN
         72U44XpThnK3fctWc0qL/VVQinMJg5IWzFv+OKzh3vdenE/VxdQloYKHcPyMZn02km4y
         jPhw==
X-Gm-Message-State: AGi0PuY8ONRwHkmqWGAKBD9LHNCG+aaTZn5Ji022Wi69qUAiOHWx4j5R
        5evQ541vRQkPAlVLv0eWvd2cBdLMbv1brw==
X-Google-Smtp-Source: APiQypKs8N4ry2ZNexWjbGdyIWVpMTV6fWAvreyFj60BavJHP5E3ZeuUEmIBRwhorXI+Q2EDAd/IIPiGZsjRug==
X-Received: by 2002:a5b:9d0:: with SMTP id y16mr5809367ybq.81.1588693431121;
 Tue, 05 May 2020 08:43:51 -0700 (PDT)
Date:   Tue,  5 May 2020 08:43:48 -0700
Message-Id: <20200505154348.224941-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH iproute2] tc: fq: fix two issues
From:   Eric Dumazet <edumazet@google.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My latest patch missed the fact that this file got JSON support.

Also fixes a spelling error added during JSON change.

Fixes: be9ca9d54123 ("tc: fq: add timer_slack parameter")
Fixes: d15e2bfc042b ("tc: fq: add support for JSON output")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tc/q_fq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tc/q_fq.c b/tc/q_fq.c
index ffae0523b1abe6a9328c6542160ff938ad666532..98d1bf4014e3f9fbb8e804f92dcdc96e417b5c74 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -379,7 +379,9 @@ static int fq_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	if (tb[TCA_FQ_TIMER_SLACK] &&
 	    RTA_PAYLOAD(tb[TCA_FQ_TIMER_SLACK]) >= sizeof(__u32)) {
 		timer_slack = rta_getattr_u32(tb[TCA_FQ_TIMER_SLACK]);
-		fprintf(f, "timer_slack %s ", sprint_time64(timer_slack, b1));
+		print_uint(PRINT_JSON, "timer_slack", NULL, timer_slack);
+		print_string(PRINT_FP, NULL, "timer_slack %s ",
+			     sprint_time64(timer_slack, b1));
 	}
 
 	return 0;
@@ -442,7 +444,7 @@ static int fq_print_xstats(struct qdisc_util *qu, FILE *f,
 		print_nl();
 		print_lluint(PRINT_ANY, "pkts_too_long",
 			     "  pkts_too_long %llu", st->pkts_too_long);
-		print_lluint(PRINT_ANY, "alloc_errors", " alloc_erros %llu",
+		print_lluint(PRINT_ANY, "alloc_errors", " alloc_errors %llu",
 			     st->allocation_errors);
 	}
 
-- 
2.26.2.526.g744177e7f7-goog

