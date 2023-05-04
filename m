Return-Path: <netdev+bounces-316-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A376F704F
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 19:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 407AC1C21225
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:00:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852FBBA2D;
	Thu,  4 May 2023 17:00:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E24BA22
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 17:00:55 +0000 (UTC)
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7649030F7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 10:00:53 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-95369921f8eso124831566b.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 10:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1683219652; x=1685811652;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=qjaODlPi6v4XERHXsi1vzOe64e5c9SqxGMblTgf0hzM=;
        b=XtNivxu3Rq1nSlFVf9oMdr0PfWMVAFMHG0UpHiyUnCTMbA8ktrSOO8JKMLjr8BITGV
         fiDSQX2C42CNvV2d5lQhrQOm/kQAja8NT2pLjKOZ0d79af8WoDMGouleYu76NuUlawaE
         OG2IAx8ZyMvDIbAUZkht93gW9ANqQLL1xOqPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683219652; x=1685811652;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qjaODlPi6v4XERHXsi1vzOe64e5c9SqxGMblTgf0hzM=;
        b=eQiYAQudHitEVzy0fhFEHtpjKhyBkIRS7qzZkK+Y5Zlesn384wXL7aso3lLV7HgYW1
         AwF1YG24IVBnYRcMaQ1V0tYCRmx5OT5GiCDNBY+sF7EDXBzYN1UGOtP1n1dQSQycgcWo
         Htn+3HsZtwowJyiKllfb3/0HuJfcCfGMPnvjDHcGQ9zcM8VCP/d0qwlAz3/f2V85oB5p
         T84N2jgKbgA8fLmBv4uAEqP99ZJmY9gchlaVxdvA31oZRUZUM4VkYOb83d5oxDTly5H0
         2fp7eREXXLVoCoI+f4Crj06sc+m5E+XHHxufVxnsEsidGvCizuxtCkn0SZN1xQaOhfV8
         5uPw==
X-Gm-Message-State: AC+VfDwAcIYJr3evBwM7WlYNixwAjtbKtBqTzxpNRIiF9LFh/kcOjBQa
	DJ5vWDOFqPgXGljFeQiFkUATiA==
X-Google-Smtp-Source: ACHHUZ5T3XqAsp9qZYStW12DZCevceerSES5BJgR2t3xpunOjYUbQaPsEm3xJX3JQlTTQteps26KnQ==
X-Received: by 2002:a17:907:628b:b0:957:272d:7b2c with SMTP id nd11-20020a170907628b00b00957272d7b2cmr7679611ejc.41.1683219651628;
        Thu, 04 May 2023 10:00:51 -0700 (PDT)
Received: from cloudflare.com (apn-31-0-32-7.dynamic.gprs.plus.pl. [31.0.32.7])
        by smtp.gmail.com with ESMTPSA id jz17-20020a17090775f100b009603d34cfecsm9843162ejc.164.2023.05.04.10.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 10:00:50 -0700 (PDT)
References: <20230502155159.305437-1-john.fastabend@gmail.com>
 <20230502155159.305437-5-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
 andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v7 04/13] bpf: sockmap, improved check for empty queue
Date: Thu, 04 May 2023 18:53:23 +0200
In-reply-to: <20230502155159.305437-5-john.fastabend@gmail.com>
Message-ID: <877cto2fr2.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 08:51 AM -07, John Fastabend wrote:
> We noticed some rare sk_buffs were stepping past the queue when system was
> under memory pressure. The general theory is to skip enqueueing
> sk_buffs when its not necessary which is the normal case with a system
> that is properly provisioned for the task, no memory pressure and enough
> cpu assigned.
>
> But, if we can't allocate memory due to an ENOMEM error when enqueueing
> the sk_buff into the sockmap receive queue we push it onto a delayed
> workqueue to retry later. When a new sk_buff is received we then check
> if that queue is empty. However, there is a problem with simply checking
> the queue length. When a sk_buff is being processed from the ingress queue
> but not yet on the sockmap msg receive queue its possible to also recv
> a sk_buff through normal path. It will check the ingress queue which is
> zero and then skip ahead of the pkt being processed.
>
> Previously we used sock lock from both contexts which made the problem
> harder to hit, but not impossible.
>
> To fix instead of popping the skb from the queue entirely we peek the
> skb from the queue and do the copy there. This ensures checks to the
> queue length are non-zero while skb is being processed. Then finally
> when the entire skb has been copied to user space queue or another
> socket we pop it off the queue. This way the queue length check allows
> bypassing the queue only after the list has been completely processed.
>
> To reproduce issue we run NGINX compliance test with sockmap running and
> observe some flakes in our testing that we attributed to this issue.
>
> Fixes: 04919bed948dc ("tcp: Introduce tcp_read_skb()")
> Tested-by: William Findlay <will@isovalent.com>
> Suggested-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/linux/skmsg.h |  1 -
>  net/core/skmsg.c      | 32 ++++++++------------------------
>  2 files changed, 8 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 904ff9a32ad6..054d7911bfc9 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -71,7 +71,6 @@ struct sk_psock_link {
>  };
>  
>  struct sk_psock_work_state {
> -	struct sk_buff			*skb;
>  	u32				len;
>  	u32				off;
>  };
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 3f95c460c261..bc5ca973400c 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -622,16 +622,12 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
>  
>  static void sk_psock_skb_state(struct sk_psock *psock,
>  			       struct sk_psock_work_state *state,
> -			       struct sk_buff *skb,
>  			       int len, int off)
>  {
>  	spin_lock_bh(&psock->ingress_lock);
>  	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
> -		state->skb = skb;
>  		state->len = len;
>  		state->off = off;
> -	} else {
> -		sock_drop(psock->sk, skb);
>  	}
>  	spin_unlock_bh(&psock->ingress_lock);
>  }
> @@ -642,23 +638,17 @@ static void sk_psock_backlog(struct work_struct *work)
>  	struct sk_psock *psock = container_of(dwork, struct sk_psock, work);
>  	struct sk_psock_work_state *state = &psock->work_state;
>  	struct sk_buff *skb = NULL;
> +	u32 len = 0, off = 0;
>  	bool ingress;
> -	u32 len, off;
>  	int ret;
>  
>  	mutex_lock(&psock->work_mutex);
> -	if (unlikely(state->skb)) {
> -		spin_lock_bh(&psock->ingress_lock);
> -		skb = state->skb;
> +	if (unlikely(state->len)) {
>  		len = state->len;
>  		off = state->off;
> -		state->skb = NULL;
> -		spin_unlock_bh(&psock->ingress_lock);
>  	}
> -	if (skb)
> -		goto start;
>  
> -	while ((skb = skb_dequeue(&psock->ingress_skb))) {
> +	while ((skb = skb_peek(&psock->ingress_skb))) {
>  		len = skb->len;
>  		off = 0;
>  		if (skb_bpf_strparser(skb)) {
> @@ -667,7 +657,6 @@ static void sk_psock_backlog(struct work_struct *work)
>  			off = stm->offset;
>  			len = stm->full_len;
>  		}
> -start:
>  		ingress = skb_bpf_ingress(skb);
>  		skb_bpf_redirect_clear(skb);
>  		do {
> @@ -677,8 +666,7 @@ static void sk_psock_backlog(struct work_struct *work)
>  							  len, ingress);
>  			if (ret <= 0) {
>  				if (ret == -EAGAIN) {
> -					sk_psock_skb_state(psock, state, skb,
> -							   len, off);
> +					sk_psock_skb_state(psock, state, len, off);
>  
>  					/* Delay slightly to prioritize any
>  					 * other work that might be here.

I've been staring at this bit and I think it doesn't matter if we update
psock->work_state when SK_PSOCK_TX_ENABLED has been cleared.

But what I think we shouldn't be doing here is scheduling
sk_psock_backlog again if SK_PSOCK_TX_ENABLED got cleared by
sk_psock_stop.

> @@ -689,15 +677,16 @@ static void sk_psock_backlog(struct work_struct *work)
>  				/* Hard errors break pipe and stop xmit. */
>  				sk_psock_report_error(psock, ret ? -ret : EPIPE);
>  				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
> -				sock_drop(psock->sk, skb);
>  				goto end;
>  			}
>  			off += ret;
>  			len -= ret;
>  		} while (len);
>  
> -		if (!ingress)
> +		skb = skb_dequeue(&psock->ingress_skb);
> +		if (!ingress) {
>  			kfree_skb(skb);
> +		}
>  	}
>  end:
>  	mutex_unlock(&psock->work_mutex);

