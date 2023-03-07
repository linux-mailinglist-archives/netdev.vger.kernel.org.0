Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88C656AF781
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:24:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbjCGVYB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbjCGVX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:23:58 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6599125AD;
        Tue,  7 Mar 2023 13:23:56 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id f1so9843367qvx.13;
        Tue, 07 Mar 2023 13:23:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678224235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7wy7tldXBpzM+bGCTdlS1FPn6gzwTpV6plLhyQ1/xY=;
        b=kNpTxyc5InwLq3A4NJn6e98b54cUXBQZ0R+OtFYvzJoM/UqAzXBo3cV31cgtJWZAfY
         V+k6apeYn5+5HPAQsoyADJchP8KsYGaAFWMoPectpaLn7p3bHFhuyQHJ6GPzmNYi97e2
         wTaTS3oHvrS6dBJC5Q4SmGaKf/Y1Do2whfxe84mk7GtaFUjRg/+b1QL0WzfNXuuZXDbE
         DVW2AweGEQEKTFuZ0SvCLum6zgWRtkxG6mxe/f+u1ETgC5LxQdoAVXN/tmXKOUfEPfev
         g9DbigLGTj5Zg7ahHDIKLJJCaw5tc5cDSGtkRuRv7S20s1wznVspyggP58EgTkZ+ZjNt
         rwuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678224235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W7wy7tldXBpzM+bGCTdlS1FPn6gzwTpV6plLhyQ1/xY=;
        b=PamKlUTfyNWu/EyuFUCwz5kwQXuZqJyyzIJ4n7h0S/U0BKfDQQ5AIIDa8TAo5A5K9a
         GCdqivtvdMwQo61W/VrZ0vBvWaxEye2oL26t3g9VYXraeFOGI0dRYguRdlILafwjGPKz
         ymFkWiabkiQCjsvqvW9qS8CwZgNpqJ2Sx59d1aa718wCN6h8yfDnchxigvdXm4L75DCP
         wdtTDQayqHpIrLaecG4uVGYf/ib2ha3eYiNSIWIjH6CugIEIy1ZgDs2vztsr1ECFybDG
         RoCq76j74w6gm0ZiapOld4d9qektg3vCmDpfzClndz12z2ZrG/DyPhozeWQbHkD8Ap2b
         Y27w==
X-Gm-Message-State: AO0yUKWwU/8dsechFgN/Pgpa6kWkDFcE40DcKdV7wP+HVyjGMJUHnGnK
        tJ70kej4VfErLDeumi2xlRJ3PICHiOk=
X-Google-Smtp-Source: AK7set9hXudD9H3ogfdHRtGH95OcQwDFxVrzlyWzzsMYJLClnUuvtRAYDjhdRmhIm6IvuvnCk/nWug==
X-Received: by 2002:a05:6214:250e:b0:56e:bdfb:f4c5 with SMTP id gf14-20020a056214250e00b0056ebdfbf4c5mr549120qvb.36.1678224235664;
        Tue, 07 Mar 2023 13:23:55 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id q28-20020a05620a2a5c00b007422fd3009esm10346878qkp.20.2023.03.07.13.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 13:23:55 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH net-next 2/2] sctp: add weighted fair queueing stream scheduler
Date:   Tue,  7 Mar 2023 16:23:27 -0500
Message-Id: <61dc1f980ae4cb8c7082446b1334d931404ec9c2.1678224012.git.lucien.xin@gmail.com>
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

As it says in rfc8260#section-3.6 about the weighted fair queueing
scheduler:

   A Weighted Fair Queueing scheduler between the streams is used.  The
   weight is configurable per outgoing SCTP stream.  This scheduler
   considers the lengths of the messages of each stream and schedules
   them in a specific way to use the capacity according to the given
   weights.  If the weight of stream S1 is n times the weight of stream
   S2, the scheduler should assign to stream S1 n times the capacity it
   assigns to stream S2.  The details are implementation dependent.
   Interleaving user messages allows for a better realization of the
   capacity usage according to the given weights.

This patch adds Weighted Fair Queueing Scheduler actually based on
the code of Fair Capacity Scheduler by adding fc_weight into struct
sctp_stream_out_ext and taking it into account when sorting stream->
fc_list in sctp_sched_fc_sched() and sctp_sched_fc_dequeue_done().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/stream_sched.h |  1 +
 include/net/sctp/structs.h      |  1 +
 include/uapi/linux/sctp.h       |  3 +-
 net/sctp/stream_sched.c         |  1 +
 net/sctp/stream_sched_fc.c      | 50 ++++++++++++++++++++++++++++++---
 5 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 913170710adb..572d73fdcd5e 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -59,5 +59,6 @@ void sctp_sched_ops_register(enum sctp_sched_type sched,
 void sctp_sched_ops_prio_init(void);
 void sctp_sched_ops_rr_init(void);
 void sctp_sched_ops_fc_init(void);
+void sctp_sched_ops_wfq_init(void);
 
 #endif /* __sctp_stream_sched_h__ */
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 2f1c9f50b352..a0933efd93c3 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1432,6 +1432,7 @@ struct sctp_stream_out_ext {
 		struct {
 			struct list_head fc_list;
 			__u32 fc_length;
+			__u16 fc_weight;
 		};
 	};
 };
diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
index 6814c5a1c4bc..b7d91d4cf0db 100644
--- a/include/uapi/linux/sctp.h
+++ b/include/uapi/linux/sctp.h
@@ -1212,7 +1212,8 @@ enum sctp_sched_type {
 	SCTP_SS_PRIO,
 	SCTP_SS_RR,
 	SCTP_SS_FC,
-	SCTP_SS_MAX = SCTP_SS_FC
+	SCTP_SS_WFQ,
+	SCTP_SS_MAX = SCTP_SS_WFQ
 };
 
 /* Probe Interval socket option */
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 1ebd14ef8daa..e843760e9aaa 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -125,6 +125,7 @@ void sctp_sched_ops_init(void)
 	sctp_sched_ops_prio_init();
 	sctp_sched_ops_rr_init();
 	sctp_sched_ops_fc_init();
+	sctp_sched_ops_wfq_init();
 }
 
 static void sctp_sched_free_sched(struct sctp_stream *stream)
diff --git a/net/sctp/stream_sched_fc.c b/net/sctp/stream_sched_fc.c
index b336c2f5486b..4bd18a497a6d 100644
--- a/net/sctp/stream_sched_fc.c
+++ b/net/sctp/stream_sched_fc.c
@@ -19,11 +19,32 @@
 #include <net/sctp/sm.h>
 #include <net/sctp/stream_sched.h>
 
-/* Fair Capacity handling
- * RFC 8260 section 3.5
+/* Fair Capacity and Weighted Fair Queueing handling
+ * RFC 8260 section 3.5 and 3.6
  */
 static void sctp_sched_fc_unsched_all(struct sctp_stream *stream);
 
+static int sctp_sched_wfq_set(struct sctp_stream *stream, __u16 sid,
+			      __u16 weight, gfp_t gfp)
+{
+	struct sctp_stream_out_ext *soute = SCTP_SO(stream, sid)->ext;
+
+	if (!weight)
+		return -EINVAL;
+
+	soute->fc_weight = weight;
+	return 0;
+}
+
+static int sctp_sched_wfq_get(struct sctp_stream *stream, __u16 sid,
+			      __u16 *value)
+{
+	struct sctp_stream_out_ext *soute = SCTP_SO(stream, sid)->ext;
+
+	*value = soute->fc_weight;
+	return 0;
+}
+
 static int sctp_sched_fc_set(struct sctp_stream *stream, __u16 sid,
 			     __u16 weight, gfp_t gfp)
 {
@@ -50,6 +71,7 @@ static int sctp_sched_fc_init_sid(struct sctp_stream *stream, __u16 sid,
 
 	INIT_LIST_HEAD(&soute->fc_list);
 	soute->fc_length = 0;
+	soute->fc_weight = 1;
 
 	return 0;
 }
@@ -67,7 +89,8 @@ static void sctp_sched_fc_sched(struct sctp_stream *stream,
 		return;
 
 	list_for_each_entry(pos, &stream->fc_list, fc_list)
-		if (pos->fc_length >= soute->fc_length)
+		if ((__u64)pos->fc_length * soute->fc_weight >=
+		    (__u64)soute->fc_length * pos->fc_weight)
 			break;
 	list_add_tail(&soute->fc_list, &pos->fc_list);
 }
@@ -137,7 +160,8 @@ static void sctp_sched_fc_dequeue_done(struct sctp_outq *q,
 
 	pos = soute;
 	list_for_each_entry_continue(pos, &stream->fc_list, fc_list)
-		if (pos->fc_length >= soute->fc_length)
+		if ((__u64)pos->fc_length * soute->fc_weight >=
+		    (__u64)soute->fc_length * pos->fc_weight)
 			break;
 	list_move_tail(&soute->fc_list, &pos->fc_list);
 }
@@ -181,3 +205,21 @@ void sctp_sched_ops_fc_init(void)
 {
 	sctp_sched_ops_register(SCTP_SS_FC, &sctp_sched_fc);
 }
+
+static struct sctp_sched_ops sctp_sched_wfq = {
+	.set = sctp_sched_wfq_set,
+	.get = sctp_sched_wfq_get,
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
+void sctp_sched_ops_wfq_init(void)
+{
+	sctp_sched_ops_register(SCTP_SS_WFQ, &sctp_sched_wfq);
+}
-- 
2.39.1

