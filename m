Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC5E60321B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 20:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJRSNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 14:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJRSNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 14:13:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611277C1E7
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 11:13:29 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-355bdeba45bso146589777b3.0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 11:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=akcmD112bzoQOApwuxJTobxDhUf+pwiEurjJfy/+2sc=;
        b=O4NyK+L9H7jKRFZVfyvzxjZyWqT57krnNADBs0GQlEiophWQm4cHyv58FB5HpCcqQB
         ky4/m6GZEI4q5ODD7uZwgLVilyte7hG6ExWVUWEdiJUV6yI5QIHERcZgoUjqWNcdO0MI
         b/WhxbfBYytv0x9rfnE3FvJ+OIywjqNmlEaVC6UfYb61tbZEPfTci27oHp+v5WZj7ZHf
         Enj/6rRIeAIFQKWCsFVgRsB6OEbwCK3AN6ij0IPihHbSEybXqs1juCrJ9Wdcvc6CcgsR
         gHAImxBehhsh9KcLqFee9U+ei5rjYIkRFoxxawOF0Q6wAti3qnv9gJeLfTjoeJr3jYIt
         ZP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=akcmD112bzoQOApwuxJTobxDhUf+pwiEurjJfy/+2sc=;
        b=zzRx55s0f9ni7A1ZPKl0fFs9pMxhKnhs7dHqKyUlpowpNaFZWKB8MoEc2Xof7wpIll
         XmMo6gDMNOmSBipNqfRy5I9ikpXA8OZspG+2bV+ffFUb2s44DTXV5xVZkGdzGfpG6EGL
         h0pukbInrSlJ/ZvX3Z5k65HTf5xls34Ozf4M7hb2iPnqCkzpdYtCT3OTBd4/lBytkvjP
         eVOjfjdNNa/fP00LyXDSVQatKrCPsRFRkghbOsiFZCkPQoBn55ZsrZc7FTid1+yLTwHS
         5Z36bKJCLtfLGjfGCjrO3Td2aCuMLMKpm+icR2Vok8z+DsxdhcRxRYuVnfXxajD6Qx0q
         bTtw==
X-Gm-Message-State: ACrzQf3BWpi4662Nq7Hf8ir0+1TaID5h5xoczneeYfXH7RggrDxEj30f
        /N4uHEJHQrS7px3AF/o3BDVmxUg=
X-Google-Smtp-Source: AMsMyM65t+a4ncle068BiaEHChLaXyR0WVkZ5M4eotApkoZon4dTb+pBEUeTj+OcgW8ErKa0qCXB3/c=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a5b:f4a:0:b0:6c1:46d2:c7d3 with SMTP id
 y10-20020a5b0f4a000000b006c146d2c7d3mr3556551ybr.169.1666116808837; Tue, 18
 Oct 2022 11:13:28 -0700 (PDT)
Date:   Tue, 18 Oct 2022 11:13:27 -0700
In-Reply-To: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
References: <20221018020258.197333-1-xiyou.wangcong@gmail.com>
Message-ID: <Y07sxzoS/s6ZBhEx@google.com>
Subject: Re: [Patch bpf] sock_map: convert cancel_work_sync() to cancel_work()
From:   sdf@google.com
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/17, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>

> Technically we don't need lock the sock in the psock work, but we
> need to prevent this work running in parallel with sock_map_close().

> With this, we no longer need to wait for the psock->work synchronously,
> because when we reach here, either this work is still pending, or
> blocking on the lock_sock(), or it is completed. We only need to cancel
> the first case asynchronously, and we need to bail out the second case
> quickly by checking SK_PSOCK_TX_ENABLED bit.

> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> Reported-by: Stanislav Fomichev <sdf@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

This seems to remove the splat for me:

Tested-by: Stanislav Fomichev <sdf@google.com>

The patch looks good, but I'll leave the review to Jakub/John.

> ---
>   include/linux/skmsg.h |  2 +-
>   net/core/skmsg.c      | 19 +++++++++++++------
>   net/core/sock_map.c   |  4 ++--
>   3 files changed, 16 insertions(+), 9 deletions(-)

> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 48f4b645193b..70d6cb94e580 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -376,7 +376,7 @@ static inline void sk_psock_report_error(struct  
> sk_psock *psock, int err)
>   }

>   struct sk_psock *sk_psock_init(struct sock *sk, int node);
> -void sk_psock_stop(struct sk_psock *psock, bool wait);
> +void sk_psock_stop(struct sk_psock *psock);

>   #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
>   int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index ca70525621c7..c329e71ea924 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -647,6 +647,11 @@ static void sk_psock_backlog(struct work_struct  
> *work)
>   	int ret;

>   	mutex_lock(&psock->work_mutex);
> +	lock_sock(psock->sk);
> +
> +	if (!sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
> +		goto end;
> +
>   	if (unlikely(state->skb)) {
>   		spin_lock_bh(&psock->ingress_lock);
>   		skb = state->skb;
> @@ -672,9 +677,12 @@ static void sk_psock_backlog(struct work_struct  
> *work)
>   		skb_bpf_redirect_clear(skb);
>   		do {
>   			ret = -EIO;
> -			if (!sock_flag(psock->sk, SOCK_DEAD))
> +			if (!sock_flag(psock->sk, SOCK_DEAD)) {
> +				release_sock(psock->sk);
>   				ret = sk_psock_handle_skb(psock, skb, off,
>   							  len, ingress);
> +				lock_sock(psock->sk);
> +			}
>   			if (ret <= 0) {
>   				if (ret == -EAGAIN) {
>   					sk_psock_skb_state(psock, state, skb,
> @@ -695,6 +703,7 @@ static void sk_psock_backlog(struct work_struct *work)
>   			kfree_skb(skb);
>   	}
>   end:
> +	release_sock(psock->sk);
>   	mutex_unlock(&psock->work_mutex);
>   }

> @@ -803,16 +812,14 @@ static void sk_psock_link_destroy(struct sk_psock  
> *psock)
>   	}
>   }

> -void sk_psock_stop(struct sk_psock *psock, bool wait)
> +void sk_psock_stop(struct sk_psock *psock)
>   {
>   	spin_lock_bh(&psock->ingress_lock);
>   	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
>   	sk_psock_cork_free(psock);
>   	__sk_psock_zap_ingress(psock);
>   	spin_unlock_bh(&psock->ingress_lock);
> -
> -	if (wait)
> -		cancel_work_sync(&psock->work);
> +	cancel_work(&psock->work);
>   }

>   static void sk_psock_done_strp(struct sk_psock *psock);
> @@ -850,7 +857,7 @@ void sk_psock_drop(struct sock *sk, struct sk_psock  
> *psock)
>   		sk_psock_stop_verdict(sk, psock);
>   	write_unlock_bh(&sk->sk_callback_lock);

> -	sk_psock_stop(psock, false);
> +	sk_psock_stop(psock);

>   	INIT_RCU_WORK(&psock->rwork, sk_psock_destroy);
>   	queue_rcu_work(system_wq, &psock->rwork);
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index a660baedd9e7..d4e11d7f459c 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -1596,7 +1596,7 @@ void sock_map_destroy(struct sock *sk)
>   	saved_destroy = psock->saved_destroy;
>   	sock_map_remove_links(sk, psock);
>   	rcu_read_unlock();
> -	sk_psock_stop(psock, false);
> +	sk_psock_stop(psock);
>   	sk_psock_put(sk, psock);
>   	saved_destroy(sk);
>   }
> @@ -1619,7 +1619,7 @@ void sock_map_close(struct sock *sk, long timeout)
>   	saved_close = psock->saved_close;
>   	sock_map_remove_links(sk, psock);
>   	rcu_read_unlock();
> -	sk_psock_stop(psock, true);
> +	sk_psock_stop(psock);
>   	sk_psock_put(sk, psock);
>   	release_sock(sk);
>   	saved_close(sk, timeout);
> --
> 2.34.1

