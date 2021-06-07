Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BFE39D301
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhFGCkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:40:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbhFGCkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 22:40:03 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E2AC061766;
        Sun,  6 Jun 2021 19:37:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id k15so11988629pfp.6;
        Sun, 06 Jun 2021 19:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=oLQtUOIn4QtzdXXro9qIUOXoA9lqcXyVqOHi0yt3oF0=;
        b=HYx5cZpxB91PiEdWIKHPNZ1PdHIFcdlgacW4GuvFI+pa7MvWY28ediYtgjY3wXZnlp
         vewbr5MfTtbjNL5MCmXt7fQaL55Udn01hCuVaK/LmuAt0skBmsc2MywLtrB0Ea/IFf2F
         /6uHroP2dJVFfQZOo1Ih37myAN3l9o1BayOcAjwzki5wdDPq5mIt6NiWeSl9jMBP/eb7
         u8d++83umKWthmTp+MT/4pFsc4SLdy7szU9ykUeXO2pUxkjR0fAvBiIhCQxlmamqKktY
         7Jzoh+cB0MPki6tjJ8YyPKi5E1MF/Zx1YXY9YA0SUazWTiuviclbJnxJPOw53HsqeHfC
         eeYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oLQtUOIn4QtzdXXro9qIUOXoA9lqcXyVqOHi0yt3oF0=;
        b=Pmce7eNWXKc16545qrptdvb2bgab5ITTuO0W2+0OSxXCnm79jS1v/Hw+dK0UpkhpN3
         T6X/GLl72HpYBYlNwSxasDUDsQkJLht7GcptN3HNkK/Mjz6VhntVh8cnjy0iDbPZZLw+
         Il0Q1igl7/tHtOdq6ZW4AziI6V2AYQHccmBA/9wVANLhbflE1Bs3aPsDvt+ncw9d7W7t
         RYLBndbSnaH23mBP26ojoqnuX2qESHPNM7k2IMn9DCwtzK3GbWjnddoyojnerzGvpesb
         I2rcpVMumqo20UY/DAbwPrsJe/S8yKA7df2baedAWKKHgIOwDl9wQz8HFxXFtqfMVmeg
         dkpg==
X-Gm-Message-State: AOAM533X008o6L3JkcjVVlrcYj3yxWxEXAAp+R58yLw3o48xbn7r50k4
        +t5PZNPbN3xZaFhhf1hfNi8=
X-Google-Smtp-Source: ABdhPJxMe6+SMdMIaJGLcuBRboZ3H+G5Pz60NdwiWMe++XrNXG2PHGHvKlvJHHum59rsPnO3yNcPKA==
X-Received: by 2002:a63:4d0:: with SMTP id 199mr16178107pge.423.1623033474438;
        Sun, 06 Jun 2021 19:37:54 -0700 (PDT)
Received: from sz-dl-056.autox.sz ([185.241.43.163])
        by smtp.gmail.com with ESMTPSA id 18sm10350540pje.22.2021.06.06.19.37.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Jun 2021 19:37:54 -0700 (PDT)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, yebin10@huawei.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yejune Deng <yejune.deng@gmail.com>
Subject: [PATCH] pktgen: add pktgen_handle_all_threads() for the same code
Date:   Mon,  7 Jun 2021 10:37:41 +0800
Message-Id: <1623033461-3003-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pktgen_{run, reset, stop}_all_threads() has the same code,
so add pktgen_handle_all_threads() for it.

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 net/core/pktgen.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 3fba429..7e258d2 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -467,7 +467,7 @@ static struct pktgen_dev *pktgen_find_dev(struct pktgen_thread *t,
 static int pktgen_device_event(struct notifier_block *, unsigned long, void *);
 static void pktgen_run_all_threads(struct pktgen_net *pn);
 static void pktgen_reset_all_threads(struct pktgen_net *pn);
-static void pktgen_stop_all_threads_ifs(struct pktgen_net *pn);
+static void pktgen_stop_all_threads(struct pktgen_net *pn);
 
 static void pktgen_stop(struct pktgen_thread *t);
 static void pktgen_clear_counters(struct pktgen_dev *pkt_dev);
@@ -516,14 +516,11 @@ static ssize_t pgctrl_write(struct file *file, const char __user *buf,
 	data[count - 1] = 0;	/* Strip trailing '\n' and terminate string */
 
 	if (!strcmp(data, "stop"))
-		pktgen_stop_all_threads_ifs(pn);
-
+		pktgen_stop_all_threads(pn);
 	else if (!strcmp(data, "start"))
 		pktgen_run_all_threads(pn);
-
 	else if (!strcmp(data, "reset"))
 		pktgen_reset_all_threads(pn);
-
 	else
 		return -EINVAL;
 
@@ -3027,20 +3024,25 @@ static void pktgen_run(struct pktgen_thread *t)
 		t->control &= ~(T_STOP);
 }
 
-static void pktgen_stop_all_threads_ifs(struct pktgen_net *pn)
+static void pktgen_handle_all_threads(struct pktgen_net *pn, u32 flags)
 {
 	struct pktgen_thread *t;
 
-	func_enter();
-
 	mutex_lock(&pktgen_thread_lock);
 
 	list_for_each_entry(t, &pn->pktgen_threads, th_list)
-		t->control |= T_STOP;
+		t->control |= (flags);
 
 	mutex_unlock(&pktgen_thread_lock);
 }
 
+static void pktgen_stop_all_threads(struct pktgen_net *pn)
+{
+	func_enter();
+
+	pktgen_handle_all_threads(pn, T_STOP);
+}
+
 static int thread_is_running(const struct pktgen_thread *t)
 {
 	const struct pktgen_dev *pkt_dev;
@@ -3103,16 +3105,9 @@ static int pktgen_wait_all_threads_run(struct pktgen_net *pn)
 
 static void pktgen_run_all_threads(struct pktgen_net *pn)
 {
-	struct pktgen_thread *t;
-
 	func_enter();
 
-	mutex_lock(&pktgen_thread_lock);
-
-	list_for_each_entry(t, &pn->pktgen_threads, th_list)
-		t->control |= (T_RUN);
-
-	mutex_unlock(&pktgen_thread_lock);
+	pktgen_handle_all_threads(pn, T_RUN);
 
 	/* Propagate thread->control  */
 	schedule_timeout_interruptible(msecs_to_jiffies(125));
@@ -3122,16 +3117,9 @@ static void pktgen_run_all_threads(struct pktgen_net *pn)
 
 static void pktgen_reset_all_threads(struct pktgen_net *pn)
 {
-	struct pktgen_thread *t;
-
 	func_enter();
 
-	mutex_lock(&pktgen_thread_lock);
-
-	list_for_each_entry(t, &pn->pktgen_threads, th_list)
-		t->control |= (T_REMDEVALL);
-
-	mutex_unlock(&pktgen_thread_lock);
+	pktgen_handle_all_threads(pn, T_REMDEVALL);
 
 	/* Propagate thread->control  */
 	schedule_timeout_interruptible(msecs_to_jiffies(125));
-- 
2.7.4

