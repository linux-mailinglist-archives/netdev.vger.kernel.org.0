Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE9551453E9
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgAVLgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:36:32 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:34219 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgAVLgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:36:32 -0500
Received: by mail-pj1-f67.google.com with SMTP id s94so2026486pjc.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=anPHFBLNPdadjSGekrzr3WCtJamEsDr9v8sySIJaS0w=;
        b=Kh9uPNg65KKfdUb14FASBwrszeM+6XUrwfTkcSXulUz7JtSs6gSsIqAVUaMxYL5U01
         QNZr54whRWf8ily/IMTpoY30w/CQ1Elp5lfDAaeyFJKx5meMFI8bFMDrcqBekWkzVqSp
         YxCOansBldy193kdAQ6ahyZUuONLqfW5KVHtvkfAJMwCEAtuVN/qosyltCWKV9RGgC8O
         OjMUtI8Uxlantl/tdtCc7Hg/859aidkWIK2DDiYQiQUhL2h8m3iqIZ945i9fk2WU3MZY
         0GgUdOLiMWtGHv05vEs+41r4GrRBn6MLdG7rIMkmKNCjh/somFXO4sRCHHMgdwlHvCwB
         RtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=anPHFBLNPdadjSGekrzr3WCtJamEsDr9v8sySIJaS0w=;
        b=tfuApZ56xkrB6dUvzznxmN0nVdTRQL01GMrGYE14NUNjXvsH7PjTv4FfZJqEGkuI3i
         s94iGAFt1hyhewEyShh7dWdMc4/UHYw8sxgKxk9aepom2claHg0yIZxNyXQ6i0SjXbE3
         MzHzs9SQBLWHV98NqS4tsdpgppY/tCikFT1I/ORmAwph5p9VJUZlqjrz8+8/CHndon1Y
         syC95jTEcOZQ6bXElihIRO7ngYIJmLBloJlrukP5a07FDEA81M7BfB+wumNg56B2yxgt
         bKozxVgYYY7Qpwb4T9kWKYvtb+Ii2uD7hj7xNV0LFiBcvk40MIRr+MBUjNU6PRUvMHmB
         3vjQ==
X-Gm-Message-State: APjAAAURT1ODE0B38VZOtO6R+//fuEz5Vmqj4TF989m14ruOYbmgTbQn
        1DfI/xjqI40+ibpwwwVOPg4C0t2Ix+nWaiiX
X-Google-Smtp-Source: APXvYqwzbyZCJhk8PEr8//D95o3If/YXQ9TZk7XwxYm3OSPeejCGVvaN2orYwoMDRAl40alk55T2rg==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr2603017pjy.89.1579692991829;
        Wed, 22 Jan 2020 03:36:31 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.36.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:36:31 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v6 08/10] net: sched: pie: fix alignment in struct instances
Date:   Wed, 22 Jan 2020 17:05:31 +0530
Message-Id: <20200122113533.28128-9-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Make the alignment in the initialization of the struct instances
consistent in the file.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 net/sched/sch_pie.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 024f55569a38..c65164659bca 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -132,14 +132,14 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 }
 
 static const struct nla_policy pie_policy[TCA_PIE_MAX + 1] = {
-	[TCA_PIE_TARGET] = {.type = NLA_U32},
-	[TCA_PIE_LIMIT] = {.type = NLA_U32},
-	[TCA_PIE_TUPDATE] = {.type = NLA_U32},
-	[TCA_PIE_ALPHA] = {.type = NLA_U32},
-	[TCA_PIE_BETA] = {.type = NLA_U32},
-	[TCA_PIE_ECN] = {.type = NLA_U32},
-	[TCA_PIE_BYTEMODE] = {.type = NLA_U32},
-	[TCA_PIE_DQ_RATE_ESTIMATOR] = {.type = NLA_U32},
+	[TCA_PIE_TARGET]		= {.type = NLA_U32},
+	[TCA_PIE_LIMIT]			= {.type = NLA_U32},
+	[TCA_PIE_TUPDATE]		= {.type = NLA_U32},
+	[TCA_PIE_ALPHA]			= {.type = NLA_U32},
+	[TCA_PIE_BETA]			= {.type = NLA_U32},
+	[TCA_PIE_ECN]			= {.type = NLA_U32},
+	[TCA_PIE_BYTEMODE]		= {.type = NLA_U32},
+	[TCA_PIE_DQ_RATE_ESTIMATOR]	= {.type = NLA_U32},
 };
 
 static int pie_change(struct Qdisc *sch, struct nlattr *opt,
@@ -549,7 +549,7 @@ static void pie_destroy(struct Qdisc *sch)
 }
 
 static struct Qdisc_ops pie_qdisc_ops __read_mostly = {
-	.id = "pie",
+	.id		= "pie",
 	.priv_size	= sizeof(struct pie_sched_data),
 	.enqueue	= pie_qdisc_enqueue,
 	.dequeue	= pie_qdisc_dequeue,
-- 
2.17.1

