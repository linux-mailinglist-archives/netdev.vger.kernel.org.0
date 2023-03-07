Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9931A6AF77E
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjCGVX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbjCGVX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:23:57 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9E27D09A;
        Tue,  7 Mar 2023 13:23:55 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id y10so16074824qtj.2;
        Tue, 07 Mar 2023 13:23:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HItdaZz7zbV6fsRTsAYITY0QYydTzriva4ATuky12sU=;
        b=l9n4aPl6monGu2rP+shwYk4ufb3zszZF8tHIkkvQhLrPhdX17+NIekIPXAWRBb8tXq
         nMwdEd7FT+bqDjZZX/C9OXfM5ylp7VrVwvOeAVX45a7K5PjkwxZIChsA3lq+X7oC3tqo
         zz1fWHHgqzWdPQ/hGhc5BK7+wgavCI5XSpPBuZFVWGPJrpaxtay0SaPpG2mCaWzpanWi
         u9XB4bvTbLtBA672D6nzpMIWLxwNN3tU8XGeGI6My+NR6CeiSBIbb/ilDOZMLef2/qx0
         91ftaSOpwhpPL8xrP3b//1FNrTLfGNCRLPa+j9Rxx3bIS5UMVYMOf0TEbzVKkYzWNERc
         QHQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HItdaZz7zbV6fsRTsAYITY0QYydTzriva4ATuky12sU=;
        b=GxYOve/SWlg3ZH3RDjvg+YMsM9qqVDHiAUOBEUzOovorXTs6qXbuoHlz5hFkNZ6swk
         39ypZCEkgA6CIwherMa1YCVMJV/R6OZ8FwZAv0Mr+GAkjgQyrBNFPSGIHSqoI5KMue8s
         9n2M4uBPvEov3CwrzHDWwxA0Q/dyTt9VIXIupthsI2fjW0H0yDzJYzIcgwjBis8qJc89
         Ny0eOUD+kNjcKfJFg++cuXKFbVD2Ez7toFZbR3S/wASf6D7hA4+lMzeEOgYimjH56Te1
         SdAbZcTxfq+QL+kl+41R2nbfb9iFfHxhNgrb2giEcYVTiVIz4ukpjIetpkpfjxhLfzpB
         0MXA==
X-Gm-Message-State: AO0yUKWcmBNN2fORrVkEE9wbM4uPrqxen04641zObcEGJi2BGZLkYU23
        wIN2HEyR0oM9q/ZSY5afabArUOOAxVE=
X-Google-Smtp-Source: AK7set8J4IjV6cCZZqJboCKDuzBLz9d6NxY0lAqPSb9ykTg2TkPVbKQrarTOTTe8QMw4nXUmlXq1Gg==
X-Received: by 2002:a05:622a:1a99:b0:3bf:ca50:e82 with SMTP id s25-20020a05622a1a9900b003bfca500e82mr25908820qtc.15.1678224234618;
        Tue, 07 Mar 2023 13:23:54 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id q28-20020a05620a2a5c00b007422fd3009esm10346878qkp.20.2023.03.07.13.23.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:23:54 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net-next 1/2] sctp: add fair capacity stream scheduler
Date:   Tue,  7 Mar 2023 16:23:26 -0500
Message-Id: <3e977ca635d6b8ef8440d5eed2617a4f3a04b15b.1678224012.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1678224012.git.lucien.xin@gmail.com>
References: <cover.1678224012.git.lucien.xin@gmail.com>
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

As it says in rfc8260#section-3.5 about the fair capacity scheduler:

   A fair capacity distribution between the streams is used.  This
   scheduler considers the lengths of the messages of each stream and
   schedules them in a specific way to maintain an equal capacity for
   all streams.  The details are implementation dependent.  interleaving
   user messages allows for a better realization of the fair capacity
   usage.

This patch adds Fair Capacity Scheduler based on the foundations added
by commit 5bbbbe32a431 ("sctp: introduce stream scheduler foundations"):

A fc_list and a fc_length are added into struct sctp_stream_out_ext and
a fc_list is added into struct sctp_stream. In .enqueue, when there are
chunks enqueued into a stream, this stream will be linked into stream->
fc_list by its fc_list ordered by its fc_length. In .dequeue, it always
picks up the 1st skb from stream->fc_list. In .dequeue_done, fc_length
is increased by chunk's len and update its location in stream->fc_list
according to the its new fc_length.

Note that when the new fc_length overflows in .dequeue_done, instead of
resetting all fc_lengths to 0, we only reduced them by U32_MAX / 4 to
avoid a moment of imbalance in the scheduling, as Marcelo suggested.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_sched.h |   1 +
 include/net/sctp/structs.h      |   7 ++
 include/uapi/linux/sctp.h       |   3 +-
 net/sctp/Makefile               |   3 +-
 net/sctp/stream_sched.c         |   1 +
 net/sctp/stream_sched_fc.c      | 183 ++++++++++++++++++++++++++++++++
 6 files changed, 196 insertions(+), 2 deletions(-)
 create mode 100644 net/sctp/stream_sched_fc.c

diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index fa00dc20a0d7..913170710adb 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -58,5 +58,6 @@ void sctp_sched_ops_register(enum sctp_sched_type sched,
 			     struct sctp_sched_ops *sched_ops);
 void sctp_sched_ops_prio_init(void);
 void sctp_sched_ops_rr_init(void);
+void sctp_sched_ops_fc_init(void);
 
 #endif /* __sctp_stream_sched_h__ */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index e1f6e7fc2b11..2f1c9f50b352 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1429,6 +1429,10 @@ struct sctp_stream_out_ext {
 		struct {
 			struct list_head rr_list;
 		};
+		struct {
+			struct list_head fc_list;
+			__u32 fc_length;
+		};
 	};
 };
 
@@ -1475,6 +1479,9 @@ struct sctp_stream {
 			/* The next stream in line */
 			struct sctp_stream_out_ext *rr_next;
 		};
+		struct {
+			struct list_head fc_list;
+		};
 	};
 	struct sctp_stream_interleave *si;
 };
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index ed7d4ecbf53d..6814c5a1c4bc 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -1211,7 +1211,8 @@ enum sctp_sched_type {
 	SCTP_SS_DEFAULT = SCTP_SS_FCFS,
 	SCTP_SS_PRIO,
 	SCTP_SS_RR,
-	SCTP_SS_MAX = SCTP_SS_RR
+	SCTP_SS_FC,
+	SCTP_SS_MAX = SCTP_SS_FC
 };
 
 /* Probe Interval socket option */
diff --git a/net/sctp/Makefile b/net/sctp/Makefile
index e845e4588535..0448398408d8 100644
--- a/net/sctp/Makefile
+++ b/net/sctp/Makefile
@@ -13,7 +13,8 @@ sctp-y := sm_statetable.o sm_statefuns.o sm_sideeffect.o \
 	  tsnmap.o bind_addr.o socket.o primitive.o \
 	  output.o input.o debug.o stream.o auth.o \
 	  offload.o stream_sched.o stream_sched_prio.o \
-	  stream_sched_rr.o stream_interleave.o
+	  stream_sched_rr.o stream_sched_fc.o \
+	  stream_interleave.o
 
 sctp_diag-y := diag.o
 
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 330067002deb..1ebd14ef8daa 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -124,6 +124,7 @@ void sctp_sched_ops_init(void)
 	sctp_sched_ops_fcfs_init();
 	sctp_sched_ops_prio_init();
 	sctp_sched_ops_rr_init();
+	sctp_sched_ops_fc_init();
 }
 
 static void sctp_sched_free_sched(struct sctp_stream *stream)
diff --git a/net/sctp/stream_sched_fc.c b/net/sctp/stream_sched_fc.c
new file mode 100644
index 000000000000..b336c2f5486b
--- /dev/null
+++ b/net/sctp/stream_sched_fc.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* SCTP kernel implementation
+ * (C) Copyright Red Hat Inc. 2022
+ *
+ * This file is part of the SCTP kernel implementation
+ *
+ * These functions manipulate sctp stream queue/scheduling.
+ *
+ * Please send any bug reports or fixes you make to the
+ * email addresched(es):
+ *    lksctp developers <linux-sctp@vger.kernel.org>
+ *
+ * Written or modified by:
+ *    Xin Long <lucien.xin@gmail.com>
+ */
+
+#include <linux/list.h>
+#include <net/sctp/sctp.h>
+#include <net/sctp/sm.h>
+#include <net/sctp/stream_sched.h>
+
+/* Fair Capacity handling
+ * RFC 8260 section 3.5
+ */
+static void sctp_sched_fc_unsched_all(struct sctp_stream *stream);
+
+static int sctp_sched_fc_set(struct sctp_stream *stream, __u16 sid,
+			     __u16 weight, gfp_t gfp)
+{
+	return 0;
+}
+
+static int sctp_sched_fc_get(struct sctp_stream *stream, __u16 sid,
+			     __u16 *value)
+{
+	return 0;
+}
+
+static int sctp_sched_fc_init(struct sctp_stream *stream)
+{
+	INIT_LIST_HEAD(&stream->fc_list);
+
+	return 0;
+}
+
+static int sctp_sched_fc_init_sid(struct sctp_stream *stream, __u16 sid,
+				  gfp_t gfp)
+{
+	struct sctp_stream_out_ext *soute = SCTP_SO(stream, sid)->ext;
+
+	INIT_LIST_HEAD(&soute->fc_list);
+	soute->fc_length = 0;
+
+	return 0;
+}
+
+static void sctp_sched_fc_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
+static void sctp_sched_fc_sched(struct sctp_stream *stream,
+				struct sctp_stream_out_ext *soute)
+{
+	struct sctp_stream_out_ext *pos;
+
+	if (!list_empty(&soute->fc_list))
+		return;
+
+	list_for_each_entry(pos, &stream->fc_list, fc_list)
+		if (pos->fc_length >= soute->fc_length)
+			break;
+	list_add_tail(&soute->fc_list, &pos->fc_list);
+}
+
+static void sctp_sched_fc_enqueue(struct sctp_outq *q,
+				  struct sctp_datamsg *msg)
+{
+	struct sctp_stream *stream;
+	struct sctp_chunk *ch;
+	__u16 sid;
+
+	ch = list_first_entry(&msg->chunks, struct sctp_chunk, frag_list);
+	sid = sctp_chunk_stream_no(ch);
+	stream = &q->asoc->stream;
+	sctp_sched_fc_sched(stream, SCTP_SO(stream, sid)->ext);
+}
+
+static struct sctp_chunk *sctp_sched_fc_dequeue(struct sctp_outq *q)
+{
+	struct sctp_stream *stream = &q->asoc->stream;
+	struct sctp_stream_out_ext *soute;
+	struct sctp_chunk *ch;
+
+	/* Bail out quickly if queue is empty */
+	if (list_empty(&q->out_chunk_list))
+		return NULL;
+
+	/* Find which chunk is next */
+	if (stream->out_curr)
+		soute = stream->out_curr->ext;
+	else
+		soute = list_entry(stream->fc_list.next, struct sctp_stream_out_ext, fc_list);
+	ch = list_entry(soute->outq.next, struct sctp_chunk, stream_list);
+
+	sctp_sched_dequeue_common(q, ch);
+	return ch;
+}
+
+static void sctp_sched_fc_dequeue_done(struct sctp_outq *q,
+				       struct sctp_chunk *ch)
+{
+	struct sctp_stream *stream = &q->asoc->stream;
+	struct sctp_stream_out_ext *soute, *pos;
+	__u16 sid, i;
+
+	sid = sctp_chunk_stream_no(ch);
+	soute = SCTP_SO(stream, sid)->ext;
+	/* reduce all fc_lengths by U32_MAX / 4 if the current fc_length overflows. */
+	if (soute->fc_length > U32_MAX - ch->skb->len) {
+		for (i = 0; i < stream->outcnt; i++) {
+			pos = SCTP_SO(stream, i)->ext;
+			if (!pos)
+				continue;
+			if (pos->fc_length <= (U32_MAX >> 2)) {
+				pos->fc_length = 0;
+				continue;
+			}
+			pos->fc_length -= (U32_MAX >> 2);
+		}
+	}
+	soute->fc_length += ch->skb->len;
+
+	if (list_empty(&soute->outq)) {
+		list_del_init(&soute->fc_list);
+		return;
+	}
+
+	pos = soute;
+	list_for_each_entry_continue(pos, &stream->fc_list, fc_list)
+		if (pos->fc_length >= soute->fc_length)
+			break;
+	list_move_tail(&soute->fc_list, &pos->fc_list);
+}
+
+static void sctp_sched_fc_sched_all(struct sctp_stream *stream)
+{
+	struct sctp_association *asoc;
+	struct sctp_chunk *ch;
+
+	asoc = container_of(stream, struct sctp_association, stream);
+	list_for_each_entry(ch, &asoc->outqueue.out_chunk_list, list) {
+		__u16 sid = sctp_chunk_stream_no(ch);
+
+		if (SCTP_SO(stream, sid)->ext)
+			sctp_sched_fc_sched(stream, SCTP_SO(stream, sid)->ext);
+	}
+}
+
+static void sctp_sched_fc_unsched_all(struct sctp_stream *stream)
+{
+	struct sctp_stream_out_ext *soute, *tmp;
+
+	list_for_each_entry_safe(soute, tmp, &stream->fc_list, fc_list)
+		list_del_init(&soute->fc_list);
+}
+
+static struct sctp_sched_ops sctp_sched_fc = {
+	.set = sctp_sched_fc_set,
+	.get = sctp_sched_fc_get,
+	.init = sctp_sched_fc_init,
+	.init_sid = sctp_sched_fc_init_sid,
+	.free_sid = sctp_sched_fc_free_sid,
+	.enqueue = sctp_sched_fc_enqueue,
+	.dequeue = sctp_sched_fc_dequeue,
+	.dequeue_done = sctp_sched_fc_dequeue_done,
+	.sched_all = sctp_sched_fc_sched_all,
+	.unsched_all = sctp_sched_fc_unsched_all,
+};
+
+void sctp_sched_ops_fc_init(void)
+{
+	sctp_sched_ops_register(SCTP_SS_FC, &sctp_sched_fc);
+}
-- 
2.39.1

