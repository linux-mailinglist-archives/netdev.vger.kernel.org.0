Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C13143F0E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgAUONn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:43 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38077 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbgAUONn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:43 -0500
Received: by mail-pj1-f66.google.com with SMTP id l35so1603823pje.3
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MhdoGB2dOxgGgsYCpXJK63reh8b1AS0/NQxYWj0RslQ=;
        b=aY5niDczBO7Rs8eqBTPzES2LoZRRIIrtm/DM6JRTIZWYPv1QiaTu78pQ7Yfcj5nekQ
         r1L9DlU3w43blgY2HkyU+86sUSbkHPoBI66NDZo6HPpum3NvfzNeJfJkGFRSDXccBN0G
         xRjp1bqZf7nj0UcDOkSFlNrZdGBeLhW/tWrLAdUpHfuwyw9sjCZehxXqL+rFSNee7Vh+
         oYL+i4QC65920CICYYcucHUx+/EiQJVHwh8Uv2SklAADaJeKXUKpiT4mFcJPxJBIWKme
         X5DqymJaGTMySHr12h3PS9TYmFTc21F55djvspAA2ygq/XGkpKmhlZWglEJhDxrNeuLq
         8XEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MhdoGB2dOxgGgsYCpXJK63reh8b1AS0/NQxYWj0RslQ=;
        b=fmgLWNZmpo+ct0qLaJ49WDTXzOtfDixUJP+MW9cjj6JbbIYzKud+L/Qkxc8VsU1zfs
         Pu1ajGa7R0Wkz7od3dYhbdd2zWWH/KkyEAsJsJ7X36RLWm1/942knCTdgnvkVcY4dLpL
         +jksA/dIckCPYoV4ajAJfMMlFK4nq/ljLQpLGFSVPICvu1HDOlUjPIsyy1Q1XzvdtHQH
         +Qif+SFoTbp3aki5f5NLTFAXGDP2WXiSiolfoL1LkMnpwO3nlWEDDVh+9k895+p15vm1
         WQpQx3bSt0izYyCtmYUp9DwHe9CDce5dga1O9JVZfNAIZMmu2z8rAVURMNk6e/38kccL
         GD2w==
X-Gm-Message-State: APjAAAXE4XqPwS67jJEilHnGMpu6KmZ18S1SHyWUfr3CKpRWgU4q3+xw
        RmSPd9FJEWyrYBlTUuq+W6iDvQIzhuh8KA==
X-Google-Smtp-Source: APXvYqw+2OQ+sZvjYumUPaYQwCXE8no2bbyyt52OXUUrSEYV1JKTWqsZ6SxPTK7IDq4YwH5r+CnRhg==
X-Received: by 2002:a17:902:7d86:: with SMTP id a6mr5765573plm.212.1579616022005;
        Tue, 21 Jan 2020 06:13:42 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:41 -0800 (PST)
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
Subject: [PATCH net-next v4 08/10] net: sched: pie: fix alignment in struct instances
Date:   Tue, 21 Jan 2020 19:42:47 +0530
Message-Id: <20200121141250.26989-9-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
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
index c0a4df01c0a0..637b0fcb1238 100644
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

