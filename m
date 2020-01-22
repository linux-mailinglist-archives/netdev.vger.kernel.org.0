Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2D1145B85
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgAVSX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:23:27 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46564 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:23:26 -0500
Received: by mail-pg1-f193.google.com with SMTP id z124so3915648pgb.13
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=anPHFBLNPdadjSGekrzr3WCtJamEsDr9v8sySIJaS0w=;
        b=ApC2j0PigWH00DWBSANTZFKN13G9sOX04/PTbu2P5teXWxl+5WHBQXbjgLiR5Vgsmp
         J0v2AzPA4HQeT4eTtc9WOkYGEmcFK9sJutVJhHHKUUB+bjMP42nnp7HMifSl7U/sMiWs
         XM8Va0hT6/phC8BmzMmfV36oPO2gsZkehta70t+/3C8kn0X4zil/nUjxR9+dvQy7E/h5
         FAsVIwM07qoJUETod3R31SrMXSxJ/yab3lcAYRYOeZdMfREd6J78IhgZUKgAs/67hhJq
         6NuZYPTQI63e3rhHWHP9jafLlv/1+QTidh3CiVTL+l1vxSihNjZ8Dk12umFRzlto1vtv
         syUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=anPHFBLNPdadjSGekrzr3WCtJamEsDr9v8sySIJaS0w=;
        b=SpVNBl6IiaHBrNu9ekvufLfbMboKfLqhBVbqY8eHSss+yYZvycr0OzmJeyAcU+2a9Q
         JXRYRJj0ChTNbrttg0M3kkltwBs/+q3tzjAklSIO7irqIDf36am0ksMqW9sqMzONLgHM
         eCXX2lWmGQyuAKbD0D4hNT/GX0PcnV3E7ZBmEpr8RhwLL+bWKtc0cjUiStkR0QyVTItk
         dANmb8sli32hpB1qiokJhP7cn04uKTmaVqp+yREyvhSVvMlHFYsCFIHfc3rCUe8RKF54
         XevDBrW2AtfemtJvVmPk3Ww5XJzffpOHIxmoPGqDRF1yPc+fpvxhAg6KiNT6rGlfSIbP
         1xCw==
X-Gm-Message-State: APjAAAWhrUp8lzTNfLv5ZDLgzp9NZ64ITUIGPBzO41Twmj3Onn4zpdR4
        bhhE39H5X81R5CA6cbphpqWpj72nhHpfTrUZ
X-Google-Smtp-Source: APXvYqzNwh4AR7JGWn9Upz9Xt/vSDPS9j/ZAYlL/ad+vGJxSWA5Sf0u9uaKKvBpfyTOxcX/5TOu6IA==
X-Received: by 2002:a63:6704:: with SMTP id b4mr12807562pgc.424.1579717405651;
        Wed, 22 Jan 2020 10:23:25 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:23:25 -0800 (PST)
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
Subject: [PATCH net-next v7 08/10] net: sched: pie: fix alignment in struct instances
Date:   Wed, 22 Jan 2020 23:52:31 +0530
Message-Id: <20200122182233.3940-9-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
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

