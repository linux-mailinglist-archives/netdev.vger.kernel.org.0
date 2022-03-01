Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318F94C85B2
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233206AbiCAH7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiCAH7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:59:48 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1CC50E03;
        Mon, 28 Feb 2022 23:59:08 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id o26so13113641pgb.8;
        Mon, 28 Feb 2022 23:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QzqMQ7hY2MYfklNGeKF7LFcaPkZedhmqr5FhyMheFwo=;
        b=gVxF1LdSpG+k8ok8OMNRdDVtLVE/NqVwo2cuhWNRniKttJozJwf5d6VZzH1i92tcfk
         LjvV2n6up3BQHyac+coxsykXnz5tWVcVghrIO/tq32iI8qFez1io7PrDuupWuIK5szwX
         qEjlBQh+0f4d0L0OTTiYJtjiL5fRe2VA3Yct7uyzXCmqDfkhSWwiAarqiCN4a3N/VHCX
         zWewXOlqmVeI74ZEOxGPYEkH6z5Gys0pTYAPlWV7VdU0/ZCr3lP8qsP0igB+sK6iL7i0
         GV3sXSENLbKqbl8ye1/LTCIdneSxT7Wqtw/pCXiNbKTPso4aWiY4bMLS4DiiToakIcIN
         HbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QzqMQ7hY2MYfklNGeKF7LFcaPkZedhmqr5FhyMheFwo=;
        b=pMBNSIBOBG5eMnCSleLMo4D43yeJdYpODTR6zZic5a8j/QguxrioAqin0vl1rMNN4w
         sZ+WwDmW+89o/eUU2v1gE0iS4VF87V/9LsJdes+3ccneroFSCkZo7Y3/fJsYeLtFgtg7
         x0isAIBdIrkaf1EfVHgjezCsfBjAY8KP0PTzNIYzU6+SxffRWSwfu4CxjQkdPAF1bFrz
         Pi/brAczQ5dBVEsLK8NQKybJi9HAYmUXA7ri9aaV2Adc6QG7XHu2GjivOt3DWPJgtO6H
         rvWPXToQVMi5w9ukMGZ2ql1Cbm2WLxWS4HOexrn0QZ0V0YYO04/M40V3y/eK/nxybRwd
         QADw==
X-Gm-Message-State: AOAM531fq0aFPfVq6kqyMsz7V/JQMu3uYIj+WXbg80hmV1erFi8KKS9I
        LGTYKncn3hQjceZ+rZfZo6I=
X-Google-Smtp-Source: ABdhPJyuoS68KxM7xG7Clm6TRMSCvt/W4vvf7HErAeAb32bAA7KFsQ5E8Cn37Dg0u8Z/+37AV7q49Q==
X-Received: by 2002:a05:6a00:1312:b0:4e1:58c4:ddfd with SMTP id j18-20020a056a00131200b004e158c4ddfdmr26133089pfu.65.1646121548180;
        Mon, 28 Feb 2022 23:59:08 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm1662745pjq.0.2022.02.28.23.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:59:07 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH 3/6] kernel: remove iterator use outside the loop
Date:   Tue,  1 Mar 2022 15:58:36 +0800
Message-Id: <20220301075839.4156-4-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
References: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Demonstrations for:
 - list_for_each_entry_inside
 - list_for_each_entry_continue_inside
 - list_for_each_entry_safe_continue_inside

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 kernel/power/snapshot.c | 28 ++++++++++++++++------------
 kernel/signal.c         |  6 +++---
 2 files changed, 19 insertions(+), 15 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 330d49937..75958b5fa 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -625,16 +625,18 @@ static int create_mem_extents(struct list_head *list, gfp_t gfp_mask)
 
 	for_each_populated_zone(zone) {
 		unsigned long zone_start, zone_end;
-		struct mem_extent *ext, *cur, *aux;
+		struct mem_extent *me = NULL;
 
 		zone_start = zone->zone_start_pfn;
 		zone_end = zone_end_pfn(zone);
 
-		list_for_each_entry(ext, list, hook)
-			if (zone_start <= ext->end)
+		list_for_each_entry_inside(ext, struct mem_extent, list, hook)
+			if (zone_start <= ext->end) {
+				me = ext;
 				break;
+			}
 
-		if (&ext->hook == list || zone_end < ext->start) {
+		if (!me || zone_end < me->start) {
 			/* New extent is necessary */
 			struct mem_extent *new_ext;
 
@@ -645,23 +647,25 @@ static int create_mem_extents(struct list_head *list, gfp_t gfp_mask)
 			}
 			new_ext->start = zone_start;
 			new_ext->end = zone_end;
-			list_add_tail(&new_ext->hook, &ext->hook);
+			if (!me)
+				list_add_tail(&new_ext->hook, list);
+			else
+				list_add_tail(&new_ext->hook, &me->hook);
 			continue;
 		}
 
 		/* Merge this zone's range of PFNs with the existing one */
-		if (zone_start < ext->start)
-			ext->start = zone_start;
-		if (zone_end > ext->end)
-			ext->end = zone_end;
+		if (zone_start < me->start)
+			me->start = zone_start;
+		if (zone_end > me->end)
+			me->end = zone_end;
 
 		/* More merging may be possible */
-		cur = ext;
-		list_for_each_entry_safe_continue(cur, aux, list, hook) {
+		list_for_each_entry_safe_continue_inside(cur, aux, me, list, hook) {
 			if (zone_end < cur->start)
 				break;
 			if (zone_end < cur->end)
-				ext->end = cur->end;
+				me->end = cur->end;
 			list_del(&cur->hook);
 			kfree(cur);
 		}
diff --git a/kernel/signal.c b/kernel/signal.c
index 9b04631ac..da2c20de1 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -711,7 +711,7 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
 {
 	struct task_struct *tsk = current;
 	struct sigpending *pending = &tsk->pending;
-	struct sigqueue *q, *sync = NULL;
+	struct sigqueue *sync = NULL;
 
 	/*
 	 * Might a synchronous signal be in the queue?
@@ -722,7 +722,7 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
 	/*
 	 * Return the first synchronous signal in the queue.
 	 */
-	list_for_each_entry(q, &pending->list, list) {
+	list_for_each_entry_inside(q, struct sigqueue, &pending->list, list) {
 		/* Synchronous signals have a positive si_code */
 		if ((q->info.si_code > SI_USER) &&
 		    (sigmask(q->info.si_signo) & SYNCHRONOUS_MASK)) {
@@ -735,7 +735,7 @@ static int dequeue_synchronous_signal(kernel_siginfo_t *info)
 	/*
 	 * Check if there is another siginfo for the same signal.
 	 */
-	list_for_each_entry_continue(q, &pending->list, list) {
+	list_for_each_entry_continue_inside(q, sync, &pending->list, list) {
 		if (q->info.si_signo == sync->info.si_signo)
 			goto still_pending;
 	}
-- 
2.17.1

