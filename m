Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388F56D51BB
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 22:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjDCUBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 16:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232831AbjDCUBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 16:01:47 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0457235AB;
        Mon,  3 Apr 2023 13:01:45 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so31718009pjt.5;
        Mon, 03 Apr 2023 13:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680552104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xONlFwVRLI4ELB/ejl1E4uUj36etSqy4lWn6gdwTo6Y=;
        b=OFq/6uFZmSss1Idk9wUU7YFdIiAaETLACTsWOvQOI5u+1DXFdlCg39CUbJMgH/owuW
         1hCQNE/0xWw4LYWGOcxSzH/E2+YbFWcjZCjg/kgIJE8T9DpOhOz2D1cNKaiTJFZYaAvB
         GNfLtFIghDOkdo4Ii5MSo9L+9LeHJTVhfE/dfJfCcSWWlLPBDCPJWaf39+DdGKu6fjjx
         vNzQ8/vPc5Z4mQhmaqYsD4uwOYZZGNfEjvioOymNIPUMeRCYvpOy2PJTHnSmOolQV+Pt
         uxlRGbNR5vQ1cbQyT2F3EInHmV9kIEAqPF6zzmUq7nx0kn4fABaEZjy+yrFkJB6shIns
         7JAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680552104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xONlFwVRLI4ELB/ejl1E4uUj36etSqy4lWn6gdwTo6Y=;
        b=y+oFnvef8OsNHKOby8bRekGLyPliEIEsivWI7BZz2IGNbc4vLdro941Rjhdc6s/iKr
         5pMoKLvJqFp6t7/B25mSYWo92dYlJA5HqBy7dphoZqEDrtjeXJSGStP0XN7oXCsxWA/X
         +gALepHVY+0dtozC2A5idhA2ticjHf0bWZl+TOBtDDO1sAfnjxHem4qmy27MZOzsChTN
         GOQ1qKvB7Ge/9jeW/t9ozxMK7JgxP/ddA745mIXct5sFyrTWkJ0SvAmexvb1ATqJE5cG
         bb2ktoM689iDl61UXl4vyk3/ISk7SS95CSi0TGQDglnYoxwUS0kF/b3YX/mO4A7fkdhV
         hEmg==
X-Gm-Message-State: AAQBX9eGtt0DjXjzjn8fMN471r5+vazTDoxJEe40P8v3v1tuJrDmAtQg
        nu92eKfezLm7HUSHdQCHOMw=
X-Google-Smtp-Source: AKy350ZSokLZDEdIj0eH7gWF0nt9t6Atr8NOPkKKYPRowXPjkNubj32fCOIyDdR6IoG6UMEqsNfigQ==
X-Received: by 2002:a17:903:2890:b0:19f:188c:3e34 with SMTP id ku16-20020a170903289000b0019f188c3e34mr188155plb.53.1680552104369;
        Mon, 03 Apr 2023 13:01:44 -0700 (PDT)
Received: from localhost.localdomain ([2605:59c8:4c5:7110:3da7:5d97:f465:5e01])
        by smtp.gmail.com with ESMTPSA id t18-20020a1709028c9200b0019c2b1c4db1sm6948835plo.239.2023.04.03.13.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 13:01:43 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     cong.wang@bytedance.com, jakub@cloudflare.com,
        daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
        will@isovalent.com
Subject: [PATCH bpf v3 02/12] bpf: sockmap, convert schedule_work into delayed_work
Date:   Mon,  3 Apr 2023 13:01:28 -0700
Message-Id: <20230403200138.937569-3-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230403200138.937569-1-john.fastabend@gmail.com>
References: <20230403200138.937569-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sk_buffs are fed into sockmap verdict programs either from a strparser
(when the user might want to decide how framing of skb is done by attaching
another parser program) or directly through tcp_read_sock. The
tcp_read_sock is the preferred method for performance when the BPF logic is
a stream parser.

The flow for Cilium's common use case with a stream parser is,

 tcp_read_sock()
  sk_psock_verdict_recv
    ret = bpf_prog_run_pin_on_cpu()
    sk_psock_verdict_apply(sock, skb, ret)
     // if system is under memory pressure or app is slow we may
     // need to queue skb. Do this queuing through ingress_skb and
     // then kick timer to wake up handler
     skb_queue_tail(ingress_skb, skb)
     schedule_work(work);


The work queue is wired up to sk_psock_backlog(). This will then walk the
ingress_skb skb list that holds our sk_buffs that could not be handled,
but should be OK to run at some later point. However, its possible that
the workqueue doing this work still hits an error when sending the skb.
When this happens the skbuff is requeued on a temporary 'state' struct
kept with the workqueue. This is necessary because its possible to
partially send an skbuff before hitting an error and we need to know how
and where to restart when the workqueue runs next.

Now for the trouble, we don't rekick the workqueue. This can cause a
stall where the skbuff we just cached on the state variable might never
be sent. This happens when its the last packet in a flow and no further
packets come along that would cause the system to kick the workqueue from
that side.

To fix we could do simple schedule_work(), but while under memory pressure
it makes sense to back off some instead of continue to retry repeatedly. So
instead to fix convert schedule_work to schedule_delayed_work and add
backoff logic to reschedule from backlog queue on errors. Its not obvious
though what a good backoff is so use '1'.

To test we observed some flakes whil running NGINX compliance test with
sockmap we attributed these failed test to this bug and subsequent issue.

From on list discussion. This commit

 bec217197b41("skmsg: Schedule psock work if the cached skb exists on the psock")

was intended to address similar race, but had a couple cases it missed.
Most obvious it only accounted for receiving traffic on the local socket
so if redirecting into another socket we could still get an sk_buff stuck
here. Next it missed the case where copied=0 in the recv() handler and
then we wouldn't kick the scheduler. Also its sub-optimal to require
userspace to kick the internal mechanisms of sockmap to wake it up and
copy data to user. It results in an extra syscall and requires the app
to actual handle the EAGAIN correctly.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |  2 +-
 net/core/skmsg.c      | 20 +++++++++++++-------
 net/core/sock_map.c   |  3 ++-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 84f787416a54..904ff9a32ad6 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -105,7 +105,7 @@ struct sk_psock {
 	struct proto			*sk_proto;
 	struct mutex			work_mutex;
 	struct sk_psock_work_state	work_state;
-	struct work_struct		work;
+	struct delayed_work		work;
 	struct rcu_work			rwork;
 };
 
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 4a3dc8d27295..198bed303c51 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -482,7 +482,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 	}
 out:
 	if (psock->work_state.skb && copied > 0)
-		schedule_work(&psock->work);
+		schedule_delayed_work(&psock->work, 0);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
@@ -640,7 +640,8 @@ static void sk_psock_skb_state(struct sk_psock *psock,
 
 static void sk_psock_backlog(struct work_struct *work)
 {
-	struct sk_psock *psock = container_of(work, struct sk_psock, work);
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
 	struct sk_buff *skb = NULL;
 	bool ingress;
@@ -680,6 +681,11 @@ static void sk_psock_backlog(struct work_struct *work)
 				if (ret == -EAGAIN) {
 					sk_psock_skb_state(psock, state, skb,
 							   len, off);
+
+					/* Delay slightly to prioritize any
+					 * other work that might be here.
+					 */
+					schedule_delayed_work(&psock->work, 1);
 					goto end;
 				}
 				/* Hard errors break pipe and stop xmit. */
@@ -734,7 +740,7 @@ struct sk_psock *sk_psock_init(struct sock *sk, int node)
 	INIT_LIST_HEAD(&psock->link);
 	spin_lock_init(&psock->link_lock);
 
-	INIT_WORK(&psock->work, sk_psock_backlog);
+	INIT_DELAYED_WORK(&psock->work, sk_psock_backlog);
 	mutex_init(&psock->work_mutex);
 	INIT_LIST_HEAD(&psock->ingress_msg);
 	spin_lock_init(&psock->ingress_lock);
@@ -823,7 +829,7 @@ static void sk_psock_destroy(struct work_struct *work)
 
 	sk_psock_done_strp(psock);
 
-	cancel_work_sync(&psock->work);
+	cancel_delayed_work_sync(&psock->work);
 	mutex_destroy(&psock->work_mutex);
 
 	psock_progs_drop(&psock->progs);
@@ -938,7 +944,7 @@ static int sk_psock_skb_redirect(struct sk_psock *from, struct sk_buff *skb)
 	}
 
 	skb_queue_tail(&psock_other->ingress_skb, skb);
-	schedule_work(&psock_other->work);
+	schedule_delayed_work(&psock_other->work, 0);
 	spin_unlock_bh(&psock_other->ingress_lock);
 	return 0;
 }
@@ -1018,7 +1024,7 @@ static int sk_psock_verdict_apply(struct sk_psock *psock, struct sk_buff *skb,
 			spin_lock_bh(&psock->ingress_lock);
 			if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
 				skb_queue_tail(&psock->ingress_skb, skb);
-				schedule_work(&psock->work);
+				schedule_delayed_work(&psock->work, 0);
 				err = 0;
 			}
 			spin_unlock_bh(&psock->ingress_lock);
@@ -1049,7 +1055,7 @@ static void sk_psock_write_space(struct sock *sk)
 	psock = sk_psock(sk);
 	if (likely(psock)) {
 		if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
-			schedule_work(&psock->work);
+			schedule_delayed_work(&psock->work, 0);
 		write_space = psock->saved_write_space;
 	}
 	rcu_read_unlock();
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index a68a7290a3b2..d38267201892 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1624,9 +1624,10 @@ void sock_map_close(struct sock *sk, long timeout)
 		rcu_read_unlock();
 		sk_psock_stop(psock);
 		release_sock(sk);
-		cancel_work_sync(&psock->work);
+		cancel_delayed_work_sync(&psock->work);
 		sk_psock_put(sk, psock);
 	}
+
 	/* Make sure we do not recurse. This is a bug.
 	 * Leak the socket instead of crashing on a stack overflow.
 	 */
-- 
2.33.0

