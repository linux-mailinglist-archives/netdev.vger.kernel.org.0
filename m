Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041C263E433
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 00:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbiK3XEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 18:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiK3XEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 18:04:36 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86FB94921;
        Wed, 30 Nov 2022 15:04:34 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id u10so161003qvp.4;
        Wed, 30 Nov 2022 15:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bvasqp0br7Dnvt4oDk9UedSZNqtGeKjlxlY9orix7O4=;
        b=WYUgmmoBisoU4wG7iptFmUlKEesvDqVscpxMy/Pueyx5FPiCo8Gn610Vuj2kE9svUW
         tDWlxaNOJqsemBjn9Wne9702bM25GE7sV/88Flx0/lURD8cW4IyuQcJQik9tlPICK23b
         zXWfoYGlnW18YkTvuZ/FJXjkoKd7sV+pDSaILCs0iRgFIUOVzS+uod3QfJ2UWFVYfoSI
         Ua365MF4q/L/OkUahR2mTHPTV8FAnM8jkrueWSIHYo09SxMuTsFFPkZw8Ty2ZBKvXK0O
         MOHoaiDrl2YUcgKfh+DPKukGjp6OqhVCsQXopM1QdGe+5aSOFP20dIxctnFZTES86iHm
         FKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bvasqp0br7Dnvt4oDk9UedSZNqtGeKjlxlY9orix7O4=;
        b=lPMlcEZi0IGsEnyhh3XHZXvV4wx13KIC5V0/ayiZVOpg1xW/8rKSxm+7ipXwazL2hF
         +l+y/8dWE3RjMVUKfzP/OTzpDXzxBHNltof2sIyX+z3caJluBU4O2F/v8E7JoVzx1EqA
         oNmOAfs5PFn2A28gjyKd6ChJvH2CCvRXPn7yQalLO6IiPGam0WOipfNZr36XvIFJRd01
         qFX5bRZMwzSm9oSlemUt1U6+w7ibooWhwmR2N6vuJCz8rKiWHq7eN5sjKbROOepn4QnB
         0sNrtKqgXlJ0OaOAci/4xJyzWfbdbnk13j85O2RTpzJ/p9WBDO5ND/9O68Gz3GgKVyJ3
         xxWw==
X-Gm-Message-State: ANoB5pkoTlI8NDJ3ORVipEAGMgq6T6BEEMAiLLGVFSBDvKlGEmEFGoyR
        MqqxUknzmQv6wv485QInmsauuPXKLko=
X-Google-Smtp-Source: AA0mqf7+ND9+fj8h/Yx/QEpvMmnSvyfrLA/AsboyXScWjrBczOSBx76XvYI75q0HtyQ2FlyupAGvtw==
X-Received: by 2002:a05:6214:b22:b0:4bb:6661:61df with SMTP id w2-20020a0562140b2200b004bb666161dfmr40267180qvj.113.1669849473767;
        Wed, 30 Nov 2022 15:04:33 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d2-20020a05620a240200b006fab68c7e87sm2160944qkn.70.2022.11.30.15.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 15:04:33 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net-next] sctp: delete free member from struct sctp_sched_ops
Date:   Wed, 30 Nov 2022 18:04:31 -0500
Message-Id: <e10aac150aca2686cb0bd0570299ec716da5a5c0.1669849471.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit 9ed7bfc79542 ("sctp: fix memory leak in
sctp_stream_outq_migrate()"), sctp_sched_set_sched() is the only
place calling sched->free(), and it can actually be replaced by
sched->free_sid() on each stream, and yet there's already a loop
to traverse all streams in sctp_sched_set_sched().

This patch adds a function sctp_sched_free_sched() where it calls
sched->free_sid() for each stream to replace sched->free() calls
in sctp_sched_set_sched() and then deletes the unused free member
from struct sctp_sched_ops.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_sched.h |  2 --
 net/sctp/stream_sched.c         | 38 +++++++++++++++++----------------
 net/sctp/stream_sched_prio.c    | 27 -----------------------
 net/sctp/stream_sched_rr.c      |  6 ------
 4 files changed, 20 insertions(+), 53 deletions(-)

diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 65058faea4db..fa00dc20a0d7 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -28,8 +28,6 @@ struct sctp_sched_ops {
 	int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
 	/* free a stream */
 	void (*free_sid)(struct sctp_stream *stream, __u16 sid);
-	/* Frees the entire thing */
-	void (*free)(struct sctp_stream *stream);
 
 	/* Enqueue a chunk */
 	void (*enqueue)(struct sctp_outq *q, struct sctp_datamsg *msg);
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 7c8f9d89e16a..330067002deb 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -50,10 +50,6 @@ static void sctp_sched_fcfs_free_sid(struct sctp_stream *stream, __u16 sid)
 {
 }
 
-static void sctp_sched_fcfs_free(struct sctp_stream *stream)
-{
-}
-
 static void sctp_sched_fcfs_enqueue(struct sctp_outq *q,
 				    struct sctp_datamsg *msg)
 {
@@ -101,7 +97,6 @@ static struct sctp_sched_ops sctp_sched_fcfs = {
 	.init = sctp_sched_fcfs_init,
 	.init_sid = sctp_sched_fcfs_init_sid,
 	.free_sid = sctp_sched_fcfs_free_sid,
-	.free = sctp_sched_fcfs_free,
 	.enqueue = sctp_sched_fcfs_enqueue,
 	.dequeue = sctp_sched_fcfs_dequeue,
 	.dequeue_done = sctp_sched_fcfs_dequeue_done,
@@ -131,6 +126,23 @@ void sctp_sched_ops_init(void)
 	sctp_sched_ops_rr_init();
 }
 
+static void sctp_sched_free_sched(struct sctp_stream *stream)
+{
+	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
+	struct sctp_stream_out_ext *soute;
+	int i;
+
+	sched->unsched_all(stream);
+	for (i = 0; i < stream->outcnt; i++) {
+		soute = SCTP_SO(stream, i)->ext;
+		if (!soute)
+			continue;
+		sched->free_sid(stream, i);
+		/* Give the next scheduler a clean slate. */
+		memset_after(soute, 0, outq);
+	}
+}
+
 int sctp_sched_set_sched(struct sctp_association *asoc,
 			 enum sctp_sched_type sched)
 {
@@ -146,18 +158,8 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 	if (sched > SCTP_SS_MAX)
 		return -EINVAL;
 
-	if (old) {
-		old->free(&asoc->stream);
-
-		/* Give the next scheduler a clean slate. */
-		for (i = 0; i < asoc->stream.outcnt; i++) {
-			struct sctp_stream_out_ext *ext = SCTP_SO(&asoc->stream, i)->ext;
-
-			if (!ext)
-				continue;
-			memset_after(ext, 0, outq);
-		}
-	}
+	if (old)
+		sctp_sched_free_sched(&asoc->stream);
 
 	asoc->outqueue.sched = n;
 	n->init(&asoc->stream);
@@ -181,7 +183,7 @@ int sctp_sched_set_sched(struct sctp_association *asoc,
 	return ret;
 
 err:
-	n->free(&asoc->stream);
+	sctp_sched_free_sched(&asoc->stream);
 	asoc->outqueue.sched = &sctp_sched_fcfs; /* Always safe */
 
 	return ret;
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 4fc9f2923ed1..42d4800f263d 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -222,32 +222,6 @@ static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
 	kfree(prio);
 }
 
-static void sctp_sched_prio_free(struct sctp_stream *stream)
-{
-	struct sctp_stream_priorities *prio, *n;
-	LIST_HEAD(list);
-	int i;
-
-	/* As we don't keep a list of priorities, to avoid multiple
-	 * frees we have to do it in 3 steps:
-	 *   1. unsched everyone, so the lists are free to use in 2.
-	 *   2. build the list of the priorities
-	 *   3. free the list
-	 */
-	sctp_sched_prio_unsched_all(stream);
-	for (i = 0; i < stream->outcnt; i++) {
-		if (!SCTP_SO(stream, i)->ext)
-			continue;
-		prio = SCTP_SO(stream, i)->ext->prio_head;
-		if (prio && list_empty(&prio->prio_sched))
-			list_add(&prio->prio_sched, &list);
-	}
-	list_for_each_entry_safe(prio, n, &list, prio_sched) {
-		list_del_init(&prio->prio_sched);
-		kfree(prio);
-	}
-}
-
 static void sctp_sched_prio_enqueue(struct sctp_outq *q,
 				    struct sctp_datamsg *msg)
 {
@@ -342,7 +316,6 @@ static struct sctp_sched_ops sctp_sched_prio = {
 	.init = sctp_sched_prio_init,
 	.init_sid = sctp_sched_prio_init_sid,
 	.free_sid = sctp_sched_prio_free_sid,
-	.free = sctp_sched_prio_free,
 	.enqueue = sctp_sched_prio_enqueue,
 	.dequeue = sctp_sched_prio_dequeue,
 	.dequeue_done = sctp_sched_prio_dequeue_done,
diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
index cc444fe0d67c..1f235e7f643a 100644
--- a/net/sctp/stream_sched_rr.c
+++ b/net/sctp/stream_sched_rr.c
@@ -94,11 +94,6 @@ static void sctp_sched_rr_free_sid(struct sctp_stream *stream, __u16 sid)
 {
 }
 
-static void sctp_sched_rr_free(struct sctp_stream *stream)
-{
-	sctp_sched_rr_unsched_all(stream);
-}
-
 static void sctp_sched_rr_enqueue(struct sctp_outq *q,
 				  struct sctp_datamsg *msg)
 {
@@ -182,7 +177,6 @@ static struct sctp_sched_ops sctp_sched_rr = {
 	.init = sctp_sched_rr_init,
 	.init_sid = sctp_sched_rr_init_sid,
 	.free_sid = sctp_sched_rr_free_sid,
-	.free = sctp_sched_rr_free,
 	.enqueue = sctp_sched_rr_enqueue,
 	.dequeue = sctp_sched_rr_dequeue,
 	.dequeue_done = sctp_sched_rr_dequeue_done,
-- 
2.31.1

