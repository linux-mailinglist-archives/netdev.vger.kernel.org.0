Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280A41DF169
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 23:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgEVVp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 17:45:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731072AbgEVVp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 17:45:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424BEC061A0E
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:45:58 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so5604386pgl.9
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 14:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o8IX8NAUnDOEVX6Nk7rJBXYRBqlNgn0ggDradDyA97E=;
        b=qGsmjGwliRvn4RwyclU/hGYzhG8Q2i7HW1y/nWN0E6ozrlE8NepCk2BEPsjEjF7vD3
         xnVg/UdjMejxjD6HR3dPPWFQXc6qMGRlxYT2hSGNfhV4C852/amHqP+lELQvTXdz4UCI
         MJ4tfsWkHTB5Qbd2Oqk6aZ7AikFvHk79KIm+aE9CZGwEhmKGGt60902AHIHsnkjufXHs
         H2w9AK5xFAGaEGQKTDr368JZDEkTxR42/uT6K2GKW4oLml8UQD2hXso0mkyU0Uqhuafg
         YqH4YUqLU8niDDjbHW2aslCTccESgU2EHSbgVgk8mD6qGUXK5BuYtuv0QwcIebddX3x0
         hCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o8IX8NAUnDOEVX6Nk7rJBXYRBqlNgn0ggDradDyA97E=;
        b=AZVDhdYAB7SmSUsTGM9tSOMa0iw8Rf5KVky2ZuDuSGMXdNuTWgWvhdKt2bAvI/6bqr
         bNWHkDzIFnoPs7F9L2gi3ZkmGNdLJL8gRuOrF3hoRZZA5RsU1z+8b3dnA7CSKQU3lV2I
         yP2N6L8dEVpqGd7CzWbEWCGV1VbPEcXILK3SwiBRtLme/n+chxA4Pa7oiXOtaJ1TXmzn
         INJiMpFFTqfRj5kJGOy2HsHp1BX24JzIYR5z0k0QUJQg7e3DcgvbccVQk7ycJQdD0Nfz
         rM0UOTLGgD7uHgsiNAmBNdgvPLMexJPOrAw01yLlob63LCEC2cgEK6Oo+GcTlXUzZnKR
         qh+w==
X-Gm-Message-State: AOAM530vqkXLsseIrE7nWmOYkEFO+FYMrHewVsA/7RuB/HlImhdzXxGo
        BYFL2G6pa2y+g4Qat6TZE5Tpuq5i
X-Google-Smtp-Source: ABdhPJyLZMl2h2n/6v4pPqkXcgmiZbtrKdIgYck3++u6OCq7+xNLOjZcL3DhVNXVrkVZsIQKSxqDsg==
X-Received: by 2002:a65:49c9:: with SMTP id t9mr3253894pgs.148.1590183957509;
        Fri, 22 May 2020 14:45:57 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x7sm7581876pfo.160.2020.05.22.14.45.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 14:45:56 -0700 (PDT)
Subject: Re: [PATCH] tipc: Disable preemption when calling send_msg method.
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Cc:     netdev@vger.kernel.org
References: <20200520114529.3433-1-penguin-kernel@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5a668c12-4038-1f68-3e17-edcdc66e9e96@gmail.com>
Date:   Fri, 22 May 2020 14:45:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200520114529.3433-1-penguin-kernel@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/20/20 4:45 AM, Tetsuo Handa wrote:
> syzbot is reporting that tipc_udp_send_msg() is calling dst_cache_get()
> without preemption disabled [1]. Since b->media->send_msg() is called
> with RCU lock already held, we can also disable preemption at that point.
> 
> [1] https://syzkaller.appspot.com/bug?id=dc6352b92862eb79373fe03fdf9af5928753e057
> 
> Reported-by: syzbot+1a68504d96cd17b33a05@syzkaller.appspotmail.com
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  net/tipc/bearer.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
> index 34ca7b789eba..e5cf91665881 100644
> --- a/net/tipc/bearer.c
> +++ b/net/tipc/bearer.c
> @@ -516,6 +516,7 @@ void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
>  	struct tipc_msg *hdr = buf_msg(skb);
>  	struct tipc_bearer *b;
>  
> +	preempt_disable();
>  	rcu_read_lock();
>  	b = bearer_get(net, bearer_id);
>  	if (likely(b && (test_bit(0, &b->up) || msg_is_reset(hdr)))) {
> @@ -528,6 +529,7 @@ void tipc_bearer_xmit_skb(struct net *net, u32 bearer_id,
>  		kfree_skb(skb);
>  	}
>  	rcu_read_unlock();
> +	preempt_enable();
>  }
>  
>  /* tipc_bearer_xmit() -send buffer to destination over bearer
> @@ -543,6 +545,7 @@ void tipc_bearer_xmit(struct net *net, u32 bearer_id,
>  	if (skb_queue_empty(xmitq))
>  		return;
>  
> +	preempt_disable();
>  	rcu_read_lock();
>  	b = bearer_get(net, bearer_id);
>  	if (unlikely(!b))
> @@ -560,6 +563,7 @@ void tipc_bearer_xmit(struct net *net, u32 bearer_id,
>  		}
>  	}
>  	rcu_read_unlock();
> +	preempt_enable();
>  }
>  
>  /* tipc_bearer_bc_xmit() - broadcast buffers to all destinations
> @@ -574,6 +578,7 @@ void tipc_bearer_bc_xmit(struct net *net, u32 bearer_id,
>  	struct sk_buff *skb, *tmp;
>  	struct tipc_msg *hdr;
>  
> +	preempt_disable();
>  	rcu_read_lock();
>  	b = bearer_get(net, bearer_id);
>  	if (unlikely(!b || !test_bit(0, &b->up)))
> @@ -591,6 +596,7 @@ void tipc_bearer_bc_xmit(struct net *net, u32 bearer_id,
>  			b->media->send_msg(net, skb, b, dst);
>  	}
>  	rcu_read_unlock();
> +	preempt_enable();
>  }
>  
>  /**
> 


This is wrong, see my patch instead.

https://patchwork.ozlabs.org/project/netdev/patch/20200521182958.163436-1-edumazet@google.com/ 

Thanks.

