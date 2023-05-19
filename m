Return-Path: <netdev+bounces-3802-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A368708E90
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 06:08:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25BA4281B1B
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 04:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B753D39B;
	Fri, 19 May 2023 04:07:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA551FBD;
	Fri, 19 May 2023 04:07:08 +0000 (UTC)
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC71E72;
	Thu, 18 May 2023 21:07:07 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-64d30ab1f89so199981b3a.3;
        Thu, 18 May 2023 21:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684469227; x=1687061227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8LDFpEJF2r3u4aoZRDO+MEf7dfGfkdbpGtCFF1Q2dVs=;
        b=Kkr81qZgFqB/mxntE3Z1t17gIOVxmursheA3tL6Cb+4eLkPeN25X63l+aRd+5Hj6zr
         uWRViyLHVubWab1m/CHOdQEr332yuXpUtjDvvsxR/DGWk/P3nyOA4sQCukjkzfVOy+gb
         Z1nmsr4qPF6nJgfD8SOextxUh8p0dscRX6Gn4efwYAQyF2zzjXOFyjxbczaQo8NX5M7m
         0yI+WN4x/GLTmIZSUzVfdJLtNXkNndltEF9eVMAvIwVaHy0lPQV/u+ra23QfZsM26ewK
         RdXSw10Mbg4RkKUCMKQFG2Xs9SO6KW9zBug609ZUBhg0Woz8dbDzulPeguom+OliPV0l
         8CNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684469227; x=1687061227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8LDFpEJF2r3u4aoZRDO+MEf7dfGfkdbpGtCFF1Q2dVs=;
        b=JVmf9XiV05YR0J2QyPnAjJnPcTL0cZREy41lnm0+5dRk6edgkBDweyvKc9Fq0WxOep
         HH+8e2VFsvmg9vGMyqrFFWuvQ/tJKjwGp4GsL3j6423LxkmIVv0Z6AmPjybs3Gs7+iRI
         OdeagEyo5foJbto7K1deMm6V8EwUN1Sw2omoMUXCQllJGaXq9c/KiDoagXp4GmC/fLyv
         CfA7yeo27mNBVVjxinmLqUeTwRvyt945HWBaaPHfKEHDSkiuQPXBcU+9KMdJmn6g1Bey
         ZsYwJG8sJPZ86V65bMw7XBydEJzBv6UtRxD6FGUnqW6dCVaCGVmalmaI3ZboM8B7Lq4U
         jO6Q==
X-Gm-Message-State: AC+VfDwygBOOYN6rmea4TD+xpvjsYH9Zw8fZ2L0uHwaZCl4L7xwzz3rq
	8IAkangRkuWLiJp/ewHsy1I=
X-Google-Smtp-Source: ACHHUZ5yBZ0pHBzZnt8pwVffHoXA/hpzrTVp00Kk91klBG5ZAvk07Oajj8s3py+gWD2b2FkNfzSwYQ==
X-Received: by 2002:a05:6a00:2da8:b0:64b:20cd:6d52 with SMTP id fb40-20020a056a002da800b0064b20cd6d52mr1591191pfb.14.1684469227387;
        Thu, 18 May 2023 21:07:07 -0700 (PDT)
Received: from john.lan ([2605:59c8:148:ba10:706:628a:e6ce:c8a9])
        by smtp.gmail.com with ESMTPSA id x11-20020aa784cb000000b00625d84a0194sm434833pfn.107.2023.05.18.21.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 21:07:06 -0700 (PDT)
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
Subject: [PATCH bpf v9 03/14] bpf: sockmap, reschedule is now done through backlog
Date: Thu, 18 May 2023 21:06:48 -0700
Message-Id: <20230519040659.670644-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230519040659.670644-1-john.fastabend@gmail.com>
References: <20230519040659.670644-1-john.fastabend@gmail.com>
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

Now that the backlog manages the reschedule() logic correctly we can drop
the partial fix to reschedule from recvmsg hook.

Rescheduling on recvmsg hook was added to address a corner case where we
still had data in the backlog state but had nothing to kick it and
reschedule the backlog worker to run and finish copying data out of the
state. This had a couple limitations, first it required user space to
kick it introducing an unnecessary EBUSY and retry. Second it only
handled the ingress case and egress redirects would still be hung.

With the correct fix, pushing the reschedule logic down to where the
enomem error occurs we can drop this fix.

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Fixes: bec217197b412 ("skmsg: Schedule psock work if the cached skb exists on the psock")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 net/core/skmsg.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 0a9ee2acac0b..76ff15f8bb06 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -481,8 +481,6 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
 		msg_rx = sk_psock_peek_msg(psock);
 	}
 out:
-	if (psock->work_state.skb && copied > 0)
-		schedule_delayed_work(&psock->work, 0);
 	return copied;
 }
 EXPORT_SYMBOL_GPL(sk_msg_recvmsg);
-- 
2.33.0


