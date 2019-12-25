Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 062BB12A904
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 20:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbfLYTE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 14:04:56 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35030 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfLYTE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 14:04:56 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so9676022plt.2
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 11:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zFwjOzvEwYsCMqPxR9qSVrNAmD1MKfKMdVbc5ZQpsKU=;
        b=GKU9FWVyJlq2ngYV5Dy9jxjkQ/3Ks3wgrHjpnpD7pz1Jm3oOTRPazHiru+cvB5aafB
         uqyEXVYAG7IRgli5lQz/KBD+qYQzLxAxLS0oziQPLAGfGJa3ZONK4ppbr1p5qbwzpuJ/
         2Wiy+jMq5qR8rnbUuu5yBz+TrFItnTMYSpdMLkud8Q8wf2rqsaODrK/TrHRq8UUzlMNQ
         G9K/QunPY0xjqYO7fNKkMZ9sqSqZqvyCk7bmLCKt7aGG7fGyVcZM+zLEQaVzaSkgKbTQ
         si3nuA3aGcjCG4eUwTbyV2APHO0VvL42n5YKeNybIcOSKLm0vjpSNJCP2XQ1KFk7q7jR
         E/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zFwjOzvEwYsCMqPxR9qSVrNAmD1MKfKMdVbc5ZQpsKU=;
        b=MYz7zv5yBB705nt6dA8JY7mjTSz9H9xS1LISUBwJr4/VB1ym0Bs0OFCLgQ6WX0x9I1
         xB8MgZp1QXAWsi7IX6u3g5ToBdLak1LLod2g+3KiRyBLxuHWr1PfRqJW9mAjfgGr0em9
         kiZncg2jE5w/MMEN4rLbXiHiAnMFuybe7PMKTQfJSqUg9Ld3ebyNrLXxx+tRj/dp9qqe
         6g9iQVLt3ynPTKVTbKOp/qMIVDdufMNOn0txy7BRntjjjI5pGH/EeQaQtCJy8Klw18wD
         Xk6f5V0Kx5PLAqwMrocOUlZwrewfvb7rvCCeJM1DyO7UzR/hfU1/r8hA3hESM8gcmoXZ
         gI9g==
X-Gm-Message-State: APjAAAXFtJ/ra0GTAQL4qvz9Z/XaXA+d7vZn//rQgcNDK2wEMDAn0e2I
        zytDrJMoOS2a15L9+qr3B9SFaySNC4o=
X-Google-Smtp-Source: APXvYqxfvzbNA/iw4mi8bKgjcNnG97KEwX4l8OF9m7P1bEj/vs6FUu/YB7eJr85rp6ghsOtmRsgGwQ==
X-Received: by 2002:a17:902:b611:: with SMTP id b17mr43008580pls.210.1577300695173;
        Wed, 25 Dec 2019 11:04:55 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id j28sm30019719pgb.36.2019.12.25.11.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 11:04:54 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH iproute2-next 10/10] tc: fq_codel: fix missing statistic in JSON output
Date:   Thu, 26 Dec 2019 00:34:18 +0530
Message-Id: <20191225190418.8806-11-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191225190418.8806-1-lesliemonis@gmail.com>
References: <20191225190418.8806-1-lesliemonis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print JSON object even if tc_fq_codel_xstats->class_stats.drop_next
is negative.

Cc: Toke Høiland-Jørgensen <toke@toke.dk>
Fixes: 997f2dc19378 ("tc: Add JSON output of fq_codel stats")
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_fq_codel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index 12ce3fbf..efed4d28 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -276,12 +276,12 @@ static int fq_codel_print_xstats(struct qdisc_util *qu, FILE *f,
 			sprint_time(st->class_stats.ldelay, b1));
 		if (st->class_stats.dropping) {
 			print_bool(PRINT_ANY, "dropping", " dropping", true);
+			print_int(PRINT_JSON, "drop_next", NULL,
+				  st->class_stats.drop_next);
 			if (st->class_stats.drop_next < 0)
 				print_string(PRINT_FP, NULL, " drop_next -%s",
 					sprint_time(-st->class_stats.drop_next, b1));
 			else {
-				print_uint(PRINT_JSON, "drop_next", NULL,
-					st->class_stats.drop_next);
 				print_string(PRINT_FP, NULL, " drop_next %s",
 					sprint_time(st->class_stats.drop_next, b1));
 			}
-- 
2.17.1

