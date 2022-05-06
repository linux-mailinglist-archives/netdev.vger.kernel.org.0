Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C1A51DFC3
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 21:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391415AbiEFTtq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 15:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391394AbiEFTtp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 15:49:45 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553203668F;
        Fri,  6 May 2022 12:46:01 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id dv4so6111787qvb.13;
        Fri, 06 May 2022 12:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=REYumsm6kh6dG5JfkpmEJOF6iBFTzLNrYeIRsQ91Yy4=;
        b=VgAPfjB60nZTL9ZLu1vVz05PN2jFWEmo7BOcQM53pAaGA0tQ83p8FQCMyfMkWCUljO
         xrUUTVpW545iQaNOP3al4ieey6zhWj2eAeHuWQ2a7+Oe6FuuJbb4bJOvxMWgh3Qk4NmJ
         Wd7/6LkMCZy7RhIfUGloBVSwbRHaFkIfbkHxfCwJsHyzqaq35+SJZnVWO70KIwVhycPJ
         XIqvFfFfqOF8Ah2OHjTQ7nwjiYjyxgJ5OSZI+MrmKSFRl2iW4wich8ZSUpf00XWCkFxG
         S1F7rRgyv7T19H7c6HjBR66HLe1ZrTif7h6o1COmDeSFxKlM8AyLQSxwpijpAH+0W8hM
         vidQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=REYumsm6kh6dG5JfkpmEJOF6iBFTzLNrYeIRsQ91Yy4=;
        b=8AXbXr4j8WzxBdo/AWHMG3EPfBQITurOPqO5/M7h2dvnsSNXUMb7/buBy8MYer56ti
         icHa7fudZXQw4Pu1AEMZmCXH5NpT7FlHSSX7tKZD+P9PamK8+6va0fQtbR1aedMX4aBV
         e6eLUrLDaZdFSEygr4Q3N45KN0qFol7+0bkZCC/PoRjEpO+upXx9vsAD1wd0CsiXGH9V
         211pD6NCLGlAn9eXmnqan7UaDe7EiEShaEyu0MrnYhxT1TVyupjOS7TRapJdjkFzSwDM
         RSpriHlXuGQ8X7yf5x4Uh4jFY0l3cdYK4c/z9onFXcrAmpX1fwnkrcybQ3EsrgH4e3ef
         P9Ow==
X-Gm-Message-State: AOAM531je1EghQGNcld0eONcd7dTvmmQaffO3ec365c24HyMHhdmsXBh
        Tdzp3yjB133R5OgD00o1r/Lo5PYVHJVM
X-Google-Smtp-Source: ABdhPJwn1oEegsPCYxjvx5slYAKeM9HTqK+wZHoSG8ht/TYx6MTMPYLOpdpDUgiPDZWYRYuyRGvNZg==
X-Received: by 2002:ad4:5749:0:b0:459:1c08:f80a with SMTP id q9-20020ad45749000000b004591c08f80amr3892776qvx.56.1651866360484;
        Fri, 06 May 2022 12:46:00 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-72-174-210.compute-1.amazonaws.com. [52.72.174.210])
        by smtp.gmail.com with ESMTPSA id c14-20020ac8518e000000b002f39b99f694sm3028513qtn.46.2022.05.06.12.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 12:46:00 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH RFC v1 net-next 4/4] net/sched: sch_cbq: Use Qdisc backpressure infrastructure
Date:   Fri,  6 May 2022 12:45:46 -0700
Message-Id: <e9c482dd77e7788f5ec97e1c8c3ef9571741167e.1651800598.git.peilin.ye@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651800598.git.peilin.ye@bytedance.com>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Recently we introduced a Qdisc backpressure infrastructure for TCP and
UDP sockets.  Use it in CBQ.

Suggested-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
 net/sched/sch_cbq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_cbq.c b/net/sched/sch_cbq.c
index 02d9f0dfe356..4a5204da49d0 100644
--- a/net/sched/sch_cbq.c
+++ b/net/sched/sch_cbq.c
@@ -382,6 +382,7 @@ cbq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		return ret;
 	}
 
+	qdisc_backpressure_overlimit(sch, skb);
 	if (net_xmit_drop_count(ret)) {
 		qdisc_qstats_drop(sch);
 		cbq_mark_toplevel(q, cl);
@@ -509,6 +510,7 @@ static enum hrtimer_restart cbq_undelay(struct hrtimer *timer)
 
 		time = 0;
 		time = ktime_add_ns(time, PSCHED_TICKS2NS(now + delay));
+		qdisc_backpressure_throttle(sch);
 		hrtimer_start(&q->delay_timer, time, HRTIMER_MODE_ABS_PINNED);
 	}
 
@@ -851,9 +853,11 @@ cbq_dequeue(struct Qdisc *sch)
 
 	if (sch->q.qlen) {
 		qdisc_qstats_overlimit(sch);
-		if (q->wd_expires)
+		if (q->wd_expires) {
+			qdisc_backpressure_throttle(sch);
 			qdisc_watchdog_schedule(&q->watchdog,
 						now + q->wd_expires);
+		}
 	}
 	return NULL;
 }
-- 
2.20.1

