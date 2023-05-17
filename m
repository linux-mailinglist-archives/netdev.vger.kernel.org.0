Return-Path: <netdev+bounces-3196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5216E705F39
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 07:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35D591C20E9E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 05:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5297D5680;
	Wed, 17 May 2023 05:23:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447E08BE0;
	Wed, 17 May 2023 05:23:12 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37AD448A;
	Tue, 16 May 2023 22:22:57 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ae408f4d1aso3668235ad.0;
        Tue, 16 May 2023 22:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684300977; x=1686892977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AMWQXrGcXhHgmJZ5RnEojce3chjmU+rt7GqrTxtYxbI=;
        b=sB20xARYeZerNV0bZVpO+CIptoUkhcXuYgdqiYez2/gJHy9QbTH4Za66p9b45q5hIL
         LLWeUx2RdMUjHWdDiK3ovC4TXZ2Elf83nSmk+f0KSNzVNL24ng7zxfab5Efr++cHIBMw
         Rish94AgLXFWl0I7ah3fBmLfqwJmWOX0T6vE14fRX2hAs05zX/K5N6Us4mlfzeK8Addg
         5WJTKzCtab5kJQyPrgL5lE5r8IesWFC5eG/NAhbRf+fu1bx+ogDRVuHXwmsQm03/ITFs
         VtVBqBvIi/tJUhFTT/r6y/2PbF8q75QMMZm8NXp8ijmawD3NIdkBTLXw7zwUUqBgpCse
         RI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684300977; x=1686892977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AMWQXrGcXhHgmJZ5RnEojce3chjmU+rt7GqrTxtYxbI=;
        b=cIomk1oKty0Wu5+cEN0GMGmgCepMmp18bfN+l9rukqxvmcLoag67+LOJrbc3vUIsrr
         kBvK3dc6Auzr1jyqt8y7PIuFlwntxHUh9TocoJeF9dADON6iUWBMkRZdBE5ECvgIiKt5
         iXuG5Y7XtgXwXFsyrmiD231iS0gBdVAhaa9S6y2rAb4qNwBWf21ct7FVMEl0kzMcw7J7
         PozySgxPyNGEIBRoEFoNK2zUE9t3bipTvdmj/v+cSQWzPigCrSb/orULBt7KpmrmBRm6
         0mBgq+VwduLz169q+WHPkyG25XZaxdFvCajkWz7iAVkw8J0UImPjLQnonBbO2nnqgoOt
         1+Pw==
X-Gm-Message-State: AC+VfDyOl3QN3P/pgqInQckRG7PUJgi7kYOAA8DmrjZ303Wdrp/olokk
	1sNvg6qLC81N2qgrnQe7mfAodIJURWY=
X-Google-Smtp-Source: ACHHUZ40FygeNkOFuw/sIJWyDlQq9i7b00Z5DB3wwEamHf3QLmfIvAMfFn4sd5YdjEx2uWCqxYpJzg==
X-Received: by 2002:a17:902:f54f:b0:1ac:750e:33ef with SMTP id h15-20020a170902f54f00b001ac750e33efmr42452729plf.3.1684300977089;
        Tue, 16 May 2023 22:22:57 -0700 (PDT)
Received: from john.lan ([98.97.37.198])
        by smtp.gmail.com with ESMTPSA id n11-20020a17090a2fcb00b0023cfdbb6496sm581779pjm.1.2023.05.16.22.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 22:22:56 -0700 (PDT)
From: John Fastabend <john.fastabend@gmail.com>
To: jakub@cloudflare.com,
	daniel@iogearbox.net
Cc: john.fastabend@gmail.com,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	edumazet@google.com,
	ast@kernel.org,
	andrii@kernel.org,
	will@isovalent.com
Subject: [PATCH bpf v8 04/13] bpf: sockmap, improved check for empty queue
Date: Tue, 16 May 2023 22:22:35 -0700
Message-Id: <20230517052244.294755-5-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230517052244.294755-1-john.fastabend@gmail.com>
References: <20230517052244.294755-1-john.fastabend@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We noticed some rare sk_buffs were stepping past the queue when system was
under memory pressure. The general theory is to skip enqueueing
sk_buffs when its not necessary which is the normal case with a system
that is properly provisioned for the task, no memory pressure and enough
cpu assigned.

But, if we can't allocate memory due to an ENOMEM error when enqueueing
the sk_buff into the sockmap receive queue we push it onto a delayed
workqueue to retry later. When a new sk_buff is received we then check
if that queue is empty. However, there is a problem with simply checking
the queue length. When a sk_buff is being processed from the ingress queue
but not yet on the sockmap msg receive queue its possible to also recv
a sk_buff through normal path. It will check the ingress queue which is
zero and then skip ahead of the pkt being processed.

Previously we used sock lock from both contexts which made the problem
harder to hit, but not impossible.

To fix instead of popping the skb from the queue entirely we peek the
skb from the queue and do the copy there. This ensures checks to the
queue length are non-zero while skb is being processed. Then finally
when the entire skb has been copied to user space queue or another
socket we pop it off the queue. This way the queue length check allows
bypassing the queue only after the list has been completely processed.

To reproduce issue we run NGINX compliance test with sockmap running and
observe some flakes in our testing that we attributed to this issue.

Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
Tested-by: William Findlay <will@isovalent.com>
Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h |  1 -
 net/core/skmsg.c      | 32 ++++++++------------------------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 904ff9a32ad6..054d7911bfc9 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -71,7 +71,6 @@ struct sk_psock_link {
 };
 
 struct sk_psock_work_state {
-	struct sk_buff			*skb;
 	u32				len;
 	u32				off;
 };
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 76ff15f8bb06..bcd45a99a3db 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -622,16 +622,12 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 
 static void sk_psock_skb_state(struct sk_psock *psock,
 			       struct sk_psock_work_state *state,
-			       struct sk_buff *skb,
 			       int len, int off)
 {
 	spin_lock_bh(&psock->ingress_lock);
 	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
-		state->skb = skb;
 		state->len = len;
 		state->off = off;
-	} else {
-		sock_drop(psock->sk, skb);
 	}
 	spin_unlock_bh(&psock->ingress_lock);
 }
@@ -642,23 +638,17 @@ static void sk_psock_backlog(struct work_struct *work)
 	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
 	struct sk_psock_work_state *state = &psock->work_state;
 	struct sk_buff *skb = NULL;
+	u32 len = 0, off = 0;
 	bool ingress;
-	u32 len, off;
 	int ret;
 
 	mutex_lock(&psock->work_mutex);
-	if (unlikely(state->skb)) {
-		spin_lock_bh(&psock->ingress_lock);
-		skb = state->skb;
+	if (unlikely(state->len)) {
 		len = state->len;
 		off = state->off;
-		state->skb = NULL;
-		spin_unlock_bh(&psock->ingress_lock);
 	}
-	if (skb)
-		goto start;
 
-	while ((skb = skb_dequeue(&psock->ingress_skb))) {
+	while ((skb = skb_peek(&psock->ingress_skb))) {
 		len = skb->len;
 		off = 0;
 		if (skb_bpf_strparser(skb)) {
@@ -667,7 +657,6 @@ static void sk_psock_backlog(struct work_struct *work)
 			off = stm->offset;
 			len = stm->full_len;
 		}
-start:
 		ingress = skb_bpf_ingress(skb);
 		skb_bpf_redirect_clear(skb);
 		do {
@@ -677,8 +666,7 @@ static void sk_psock_backlog(struct work_struct *work)
 							  len, ingress);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
-					sk_psock_skb_state(psock, state, skb,
-							   len, off);
+					sk_psock_skb_state(psock, state, len, off);
 
 					/* Delay slightly to prioritize any
 					 * other work that might be here.
@@ -690,15 +678,16 @@ static void sk_psock_backlog(struct work_struct *work)
 				/* Hard errors break pipe and stop xmit. */
 				sk_psock_report_error(psock, ret ? -ret : EPIPE);
 				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
-				sock_drop(psock->sk, skb);
 				goto end;
 			}
 			off += ret;
 			len -= ret;
 		} while (len);
 
-		if (!ingress)
+		skb = skb_dequeue(&psock->ingress_skb);
+		if (!ingress) {
 			kfree_skb(skb);
+		}
 	}
 end:
 	mutex_unlock(&psock->work_mutex);
@@ -791,11 +780,6 @@ static void __sk_psock_zap_ingress(struct sk_psock *psock)
 		skb_bpf_redirect_clear(skb);
 		sock_drop(psock->sk, skb);
 	}
-	kfree_skb(psock->work_state.skb);
-	/* We null the skb here to ensure that calls to sk_psock_backlog
-	 * do not pick up the free'd skb.
-	 */
-	psock->work_state.skb = NULL;
 	__sk_psock_purge_ingress_msg(psock);
 }
 
@@ -814,7 +798,6 @@ void sk_psock_stop(struct sk_psock *psock)
 	spin_lock_bh(&psock->ingress_lock);
 	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
 	sk_psock_cork_free(psock);
-	__sk_psock_zap_ingress(psock);
 	spin_unlock_bh(&psock->ingress_lock);
 }
 
@@ -829,6 +812,7 @@ static void sk_psock_destroy(struct work_struct *work)
 	sk_psock_done_strp(psock);
 
 	cancel_delayed_work_sync(&psock->work);
+	__sk_psock_zap_ingress(psock);
 	mutex_destroy(&psock->work_mutex);
 
 	psock_progs_drop(&psock->progs);
-- 
2.33.0


