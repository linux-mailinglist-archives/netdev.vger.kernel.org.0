Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02276342A13
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 03:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbhCTCpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 22:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCTCpj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 22:45:39 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D3B1C061761;
        Fri, 19 Mar 2021 19:45:39 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id v26so8134284iox.11;
        Fri, 19 Mar 2021 19:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=3HbSqhKhb+2M9US5GUuB0n43oGaldI+qLo9i6FdnxS8=;
        b=lzrQTJr6vhaPY9lsEDlNOYMtGcWeTuK7J5BF3Z+3hYVKd2Rw3A+3Oe7vZMwRGaE0xy
         N3JD/N8lLMNqa78nFic/xTrB4r6U6aHGJ6oiSQzu2TfWZREoTgdhoRpZCLSWKwEW6aPu
         kGWpzUyEjnnOKpLwyCErUgl9Ob0AKCr7sZPJ5cfzg1ZxHoCXd6jzld9ZTxLxjZh/cuNB
         /kbJWyxWqQO0BaU3cM13s51gq9P34lVjDmaZV8fjq0MHU6OnF/iozF1EOxLS3oLyWoMI
         m7Q6DR5WX8FVxmJfFVCVBKl7m9+GiPl7Wuy8Gsv+2KeIBVEAlG/00p7LWD+6PoBPwLvh
         BQ0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=3HbSqhKhb+2M9US5GUuB0n43oGaldI+qLo9i6FdnxS8=;
        b=B2zQabcWdmWBAUAFQLapxcYL1bvX0/YzsXlyPf6I+rOtyhHv9cjPkiHjg2qBjZEOHJ
         8cM7n1IojScD0HqTYlia8ggPdCBGTD8U9apPPkoVnNTlVilv7/d0NCroALvpVeUaD5Ru
         XDIDuUGe1EQgNOcG7EKJr9AsTgt47lWp8fmkXqLhXyhTEDTmksNxVEKqnQPLygTkuOgF
         FFBCxEJhI4rHeaDi5Yho396fbvXj4Ueae43HVPUXrIrf9Z/8FRfLM1Sv5y0X4OFwW+Lb
         h/6KkgN7eyS+XEhQP3WMCTRk7kIX4cR3V6ROdJKe+Xt2dr/Smucuoi/LIE2u2glgooza
         a0zw==
X-Gm-Message-State: AOAM530FezffeF4YDayeZNX2G/ihUpaGbR+mOgjHZERx22ph/TtE6tTZ
        UU2mPMePVCnTCwpijVzh1GE=
X-Google-Smtp-Source: ABdhPJx5eVOA6fMtRJbrwHrv0ZrDyL7jwVjSm7ixTNqqWMVDfKs4166hVGyDjtf7SDy8tbhdqZ19/w==
X-Received: by 2002:a02:6989:: with SMTP id e131mr3877470jac.105.1616208338792;
        Fri, 19 Mar 2021 19:45:38 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id x17sm3556156ilm.40.2021.03.19.19.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 19:45:38 -0700 (PDT)
Date:   Fri, 19 Mar 2021 19:45:31 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <605561cbb8e08_1ca40208ad@john-XPS-13-9370.notmuch>
In-Reply-To: <20210317022219.24934-5-xiyou.wangcong@gmail.com>
References: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
 <20210317022219.24934-5-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v5 04/11] skmsg: avoid lock_sock() in
 sk_psock_backlog()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> We do not have to lock the sock to avoid losing sk_socket,
> instead we can purge all the ingress queues when we close
> the socket. Sending or receiving packets after orphaning
> socket makes no sense.
> 
> We do purge these queues when psock refcnt reaches zero but
> here we want to purge them explicitly in sock_map_close().
> There are also some nasty race conditions on testing bit
> SK_PSOCK_TX_ENABLED and queuing/canceling the psock work,
> we can expand psock->ingress_lock a bit to protect them too.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/linux/skmsg.h |  1 +
>  net/core/skmsg.c      | 50 +++++++++++++++++++++++++++++++------------
>  net/core/sock_map.c   |  1 +
>  3 files changed, 38 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index f2d45a73b2b2..0f5e663f6c7f 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -347,6 +347,7 @@ static inline void sk_psock_report_error(struct sk_psock *psock, int err)
>  }

Overall looks good, comment/question below.

>  
>  #if IS_ENABLED(CONFIG_BPF_STREAM_PARSER)
>  int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 305dddc51857..d0a227b0f672 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -497,7 +497,7 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
>  	if (!ingress) {
>  		if (!sock_writeable(psock->sk))
>  			return -EAGAIN;
> -		return skb_send_sock_locked(psock->sk, skb, off, len);
> +		return skb_send_sock(psock->sk, skb, off, len);
>  	}
>  	return sk_psock_skb_ingress(psock, skb);
>  }
> @@ -511,8 +511,6 @@ static void sk_psock_backlog(struct work_struct *work)
>  	u32 len, off;
>  	int ret;
>  
> -	/* Lock sock to avoid losing sk_socket during loop. */
> -	lock_sock(psock->sk);
>  	if (state->skb) {
>  		skb = state->skb;
>  		len = state->len;
> @@ -529,7 +527,7 @@ static void sk_psock_backlog(struct work_struct *work)
>  		skb_bpf_redirect_clear(skb);
>  		do {
>  			ret = -EIO;
> -			if (likely(psock->sk->sk_socket))
> +			if (!sock_flag(psock->sk, SOCK_DEAD))
>  				ret = sk_psock_handle_skb(psock, skb, off,
>  							  len, ingress);
>  			if (ret <= 0) {
> @@ -537,13 +535,13 @@ static void sk_psock_backlog(struct work_struct *work)
>  					state->skb = skb;
>  					state->len = len;
>  					state->off = off;
> -					goto end;
> +					return;

Unrelated to your series I'll add it to my queue of fixes, but I think we
leak state->skb on teardown.

>  				}
>  				/* Hard errors break pipe and stop xmit. */
>  				sk_psock_report_error(psock, ret ? -ret : EPIPE);
>  				sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
>  				kfree_skb(skb);
> -				goto end;
> +				return;
>  			}
>  			off += ret;
>  			len -= ret;
> @@ -552,8 +550,6 @@ static void sk_psock_backlog(struct work_struct *work)
>  		if (!ingress)
>  			kfree_skb(skb);
>  	}
> -end:
> -	release_sock(psock->sk);
>  }
>  
>  struct sk_psock *sk_psock_init(struct sock *sk, int node)
> @@ -631,7 +627,7 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
>  	}
>  }
>  
> -static void sk_psock_zap_ingress(struct sk_psock *psock)
> +static void __sk_psock_zap_ingress(struct sk_psock *psock)
>  {
>  	struct sk_buff *skb;
>  
> @@ -639,8 +635,13 @@ static void sk_psock_zap_ingress(struct sk_psock *psock)
>  		skb_bpf_redirect_clear(skb);
>  		kfree_skb(skb);
>  	}
> -	spin_lock_bh(&psock->ingress_lock);
>  	__sk_psock_purge_ingress_msg(psock);
> +}
> +
> +static void sk_psock_zap_ingress(struct sk_psock *psock)
> +{
> +	spin_lock_bh(&psock->ingress_lock);
> +	__sk_psock_zap_ingress(psock);
>  	spin_unlock_bh(&psock->ingress_lock);

I'm wondering about callers of sk_psock_zap_ingress() and why the lock is
needed here. We have two callers

sk_psock_destroy_deferred(), is deferred after an RCU grace period and after
cancel_work_sync() so there should be no users to into the skb queue. If there
are we  have other problems I think.

sk_psock_drop() is the other. It is called when the refcnt is zero and does
a sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED). Should it just wrap
up the clear_state and sk_psock_zap_ingress similar to other cases so it
doesn't have to deal with the case where enqueue happens after
sk_psock_zap_ingress.

Something like this would be clearer?
                                                                                           
void sk_psock_drop(struct sock *sk, struct sk_psock *psock)                                
{                                                                                          
	sk_psock_stop()
        write_lock_bh(&sk->sk_callback_lock);                                              
        sk_psock_restore_proto(sk, psock);                                                 
        rcu_assign_sk_user_data(sk, NULL);                                                 
        if (psock->progs.stream_parser)                                                    
                sk_psock_stop_strp(sk, psock);                                             
        else if (psock->progs.stream_verdict)                                              
                sk_psock_stop_verdict(sk, psock);                                          
        write_unlock_bh(&sk->sk_callback_lock);                                            
        call_rcu(&psock->rcu, sk_psock_destroy);                                           
}                                                                                          
EXPORT_SYMBOL_GPL(sk_psock_drop)

Then sk_psock_zap_ingress, as coded above, is not really needed anywhere and
we just use the lockless variant, __sk_psock_zap_ingress(). WDYT, to I miss
something.


>  }
>  
> @@ -654,6 +655,17 @@ static void sk_psock_link_destroy(struct sk_psock *psock)
>  	}
>  }
>  
> +void sk_psock_stop(struct sk_psock *psock)
> +{
> +	spin_lock_bh(&psock->ingress_lock);
> +	sk_psock_clear_state(psock, SK_PSOCK_TX_ENABLED);
> +	sk_psock_cork_free(psock);
> +	__sk_psock_zap_ingress(psock);
> +	spin_unlock_bh(&psock->ingress_lock);
> +
> +	cancel_work_sync(&psock->work);
> +}
> +
>  static void sk_psock_done_strp(struct sk_psock *psock);
