Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92290179872
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgCDS4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:56:15 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39857 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726561AbgCDS4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:56:14 -0500
Received: by mail-pg1-f196.google.com with SMTP id s2so1422640pgv.6
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:56:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ww6PVJ28DVfom+lsskPik3ecq8bDZeuZCLwJlAjQfg0=;
        b=DXq2OLbnyITD7Q9+8+kOx4Bv/9NUbB54JkNDq+6ydoYcgMrDmcO3QRURD5C0/Lg/uZ
         ZMlkTnKEWZ4aRAcuTcFvs9ORn54OLRchJDUdfWZTCfV+YV0VRrxci/JlY8M6rpUh9TsZ
         C4yKGWJcD6M+KC17ZCDI9ck7fArW4ziJES+CscRy6jCm3HDJn/SCKQcbrUkA1Fs4Wynu
         w8/GhOepCD81Bw5zbM1ImFYFm+xY+hQUzxZllVe1juGkTmCiuf/ZdR9U8z/YMrVU4OWr
         8K6fkbQsH5Bea6NvczFWoNdeOnGQUqY5tu3A+H8W0aJPgGl+ourkECgCfb+4WsoHpLo6
         0bTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ww6PVJ28DVfom+lsskPik3ecq8bDZeuZCLwJlAjQfg0=;
        b=I8xjKEQND6XrJZ4ILl5OaOrYBP6MD+1TZaZRRH+sFj3g+zRYsFoILkUSiSt9SBLy8c
         XPg9S3CGgBgzKDjOsQhdnEYSWGRx2JBc69d7Lxz7q/2b7bWKsSEPJ7LBsvIXM00skv63
         PyceGp1GqJPg1HVMb1SI6T7rKGvCOnkd7EZxEpB8viC8dkF1ibaZFXRrolijgPJb6ftZ
         BnTNuKfccxPHdeVS71KG7Lwblu1ZbAi8M05v/EGgIFxhPqWHbDl3mCWrwRzhjMzLvkmO
         VK+mF6ruZe+bYQMT7lJr90T1lx2rkCQ9QH308W7iLrQI7VeJMxAqo35wel5oNhVBEyiH
         m71g==
X-Gm-Message-State: ANhLgQ1dPzvYUBLOVCatF+6XumU2qolbHa/qXDA8dyHmq3kgYRhPC9VM
        j1TUa+w4mIEVoYfSoQ1ZCeAsvEZS
X-Google-Smtp-Source: ADFU+vsC/FveQYc+d+swxVLz/N8PektcA9bqcq1kIMjsu4MAzXBW5HkJHAN4SgdRVROoL9SxwSRKDg==
X-Received: by 2002:a63:f757:: with SMTP id f23mr3791644pgk.223.1583348173117;
        Wed, 04 Mar 2020 10:56:13 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id h12sm12720021pfk.124.2020.03.04.10.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:56:12 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next v2 1/4] pie: use term backlog instead of qlen
Date:   Thu,  5 Mar 2020 00:25:59 +0530
Message-Id: <20200304185602.2540-2-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304185602.2540-1-lesliemonis@gmail.com>
References: <20200304185602.2540-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove ambiguity by using the term backlog instead of qlen when
representing the queue length in bytes.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 include/net/pie.h   | 10 +++++-----
 net/sched/sch_pie.c | 22 +++++++++++-----------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index fd5a37cb7993..24f68c1e9919 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -46,7 +46,7 @@ struct pie_params {
  * @accu_prob:			accumulated drop probability
  * @dq_count:			number of bytes dequeued in a measurement cycle
  * @avg_dq_rate:		calculated average dq rate
- * @qlen_old:			queue length during previous qdelay calculation
+ * @backlog_old:		queue backlog during previous qdelay calculation
  * @accu_prob_overflows:	number of times accu_prob overflows
  */
 struct pie_vars {
@@ -58,7 +58,7 @@ struct pie_vars {
 	u64 accu_prob;
 	u64 dq_count;
 	u32 avg_dq_rate;
-	u32 qlen_old;
+	u32 backlog_old;
 	u8 accu_prob_overflows;
 };
 
@@ -127,12 +127,12 @@ static inline void pie_set_enqueue_time(struct sk_buff *skb)
 }
 
 bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
-		    struct pie_vars *vars, u32 qlen, u32 packet_size);
+		    struct pie_vars *vars, u32 backlog, u32 packet_size);
 
 void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
-			 struct pie_vars *vars, u32 qlen);
+			 struct pie_vars *vars, u32 backlog);
 
 void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
-			       u32 qlen);
+			       u32 backlog);
 
 #endif
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 915bcdb59a9f..8a2f9f11c86f 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -31,7 +31,7 @@ struct pie_sched_data {
 };
 
 bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
-		    struct pie_vars *vars, u32 qlen, u32 packet_size)
+		    struct pie_vars *vars, u32 backlog, u32 packet_size)
 {
 	u64 rnd;
 	u64 local_prob = vars->prob;
@@ -51,7 +51,7 @@ bool pie_drop_early(struct Qdisc *sch, struct pie_params *params,
 	/* If we have fewer than 2 mtu-sized packets, disable pie_drop_early,
 	 * similar to min_th in RED
 	 */
-	if (qlen < 2 * mtu)
+	if (backlog < 2 * mtu)
 		return false;
 
 	/* If bytemode is turned on, use packet size to compute new
@@ -215,7 +215,7 @@ static int pie_change(struct Qdisc *sch, struct nlattr *opt,
 }
 
 void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
-			 struct pie_vars *vars, u32 qlen)
+			 struct pie_vars *vars, u32 backlog)
 {
 	psched_time_t now = psched_get_time();
 	u32 dtime = 0;
@@ -231,7 +231,7 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
 
 		vars->dq_tstamp = now;
 
-		if (qlen == 0)
+		if (backlog == 0)
 			vars->qdelay = 0;
 
 		if (dtime == 0)
@@ -244,7 +244,7 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
 	 * we have enough packets to calculate the drain rate. Save
 	 * current time as dq_tstamp and start measurement cycle.
 	 */
-	if (qlen >= QUEUE_THRESHOLD && vars->dq_count == DQCOUNT_INVALID) {
+	if (backlog >= QUEUE_THRESHOLD && vars->dq_count == DQCOUNT_INVALID) {
 		vars->dq_tstamp = psched_get_time();
 		vars->dq_count = 0;
 	}
@@ -283,7 +283,7 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
 			 * dq_count to 0 to re-enter the if block when the next
 			 * packet is dequeued
 			 */
-			if (qlen < QUEUE_THRESHOLD) {
+			if (backlog < QUEUE_THRESHOLD) {
 				vars->dq_count = DQCOUNT_INVALID;
 			} else {
 				vars->dq_count = 0;
@@ -307,7 +307,7 @@ void pie_process_dequeue(struct sk_buff *skb, struct pie_params *params,
 EXPORT_SYMBOL_GPL(pie_process_dequeue);
 
 void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
-			       u32 qlen)
+			       u32 backlog)
 {
 	psched_time_t qdelay = 0;	/* in pschedtime */
 	psched_time_t qdelay_old = 0;	/* in pschedtime */
@@ -322,7 +322,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 		vars->qdelay_old = vars->qdelay;
 
 		if (vars->avg_dq_rate > 0)
-			qdelay = (qlen << PIE_SCALE) / vars->avg_dq_rate;
+			qdelay = (backlog << PIE_SCALE) / vars->avg_dq_rate;
 		else
 			qdelay = 0;
 	} else {
@@ -330,10 +330,10 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 		qdelay_old = vars->qdelay_old;
 	}
 
-	/* If qdelay is zero and qlen is not, it means qlen is very small,
+	/* If qdelay is zero and backlog is not, it means backlog is very small,
 	 * so we do not update probabilty in this round.
 	 */
-	if (qdelay == 0 && qlen != 0)
+	if (qdelay == 0 && backlog != 0)
 		update_prob = false;
 
 	/* In the algorithm, alpha and beta are between 0 and 2 with typical
@@ -409,7 +409,7 @@ void pie_calculate_probability(struct pie_params *params, struct pie_vars *vars,
 		vars->prob -= vars->prob / 64;
 
 	vars->qdelay = qdelay;
-	vars->qlen_old = qlen;
+	vars->backlog_old = backlog;
 
 	/* We restart the measurement cycle if the following conditions are met
 	 * 1. If the delay has been low for 2 consecutive Tupdate periods
-- 
2.17.1

