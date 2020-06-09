Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE4F1F3EBC
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 17:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730364AbgFIPAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 11:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgFIPAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 11:00:43 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C836C05BD1E
        for <netdev@vger.kernel.org>; Tue,  9 Jun 2020 08:00:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b201so10206508pfb.0
        for <netdev@vger.kernel.org>; Tue, 09 Jun 2020 08:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j5UxA45aRF+5YrFam7t9hJgb+qz3+9jbeXWg5W3RcEQ=;
        b=elipdQNYMSwTemVoRuRK2f+MO5Yq+7P3Vq0HiAf+f6SVGwj3QQFbBSq/l6uh+zGcra
         HZIr/XbcK+vvsRkeQ2gQJDDSTikXnu3Lz+hdqwEvYPBc/gxZmW0w049ozMhMa/WJkymX
         lNnsNoz9ywXAHAKS31NhDLsGLehJL7V19HR4KwARuoadQmim6qJsfYC3FpR6+Ai4rnA/
         w0QuDJsez5XfhXjaSfh+R0HBgeqr4PbnTw2I7SW9mNBgTG/CrOw+gIVBX5KTgbtbWgM/
         /IxOkyY2/Z6Tvahqf3RGp8QEdrg7rme9Z2q+BxTdYxQPjQMpyYgA4byqc4Xh/l2Lb/QW
         bGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j5UxA45aRF+5YrFam7t9hJgb+qz3+9jbeXWg5W3RcEQ=;
        b=ElT3RkSEERbw8S/fYw0mu1mWehUbbsUFxBUooPbmhFci3/nEl7HteFbQDy9FUuxIP3
         gfdP5kwDdBRr6aYboRh63Db3fzGV/sIT1lWdL9Ta1EnJl6GwuN4Ttu9GPVus8dChRGg7
         X0XAGpqCKQogkNFZ8RW8XfwFITJgNw0oQpSmEFr5HMhhY/tCxqQH+HaQq25a8WtOsczt
         BPwjjnC3+1GQx04kuWh2BR+6cn8Gd/MUp+uu7EutIKcXydWxA0gPw8HcDE97b7ZRq/GP
         +f00q2eiwl7zgLWVn6GzKlYc1PvC0LFAvBQ2tp+c1hVO+TawZKWim3mTBrueEw+66Y9s
         WG7A==
X-Gm-Message-State: AOAM533D2Eie2+qwwNmuY7XVaKLMsLBTY5UVB8Q1NDkYfjukSvAjyDk0
        /EC6ACmKIxLPTSCwwFSePM8=
X-Google-Smtp-Source: ABdhPJxQJmaQI103/sKIQD60ugJhHBKtvVvV4Ck9ugkJsHRIdbuZg1ugSNJueBqnzeNm/9W2t/LBYQ==
X-Received: by 2002:a62:1951:: with SMTP id 78mr25222188pfz.226.1591714840675;
        Tue, 09 Jun 2020 08:00:40 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id y81sm10524084pfb.33.2020.06.09.08.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jun 2020 08:00:39 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 3/6] net_sched: sch_fq: multiple release time
 support
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>
References: <20200609140934.110785-1-willemdebruijn.kernel@gmail.com>
 <20200609140934.110785-4-willemdebruijn.kernel@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e145e4c1-3a58-d183-c6ed-cd34c1c2de8a@gmail.com>
Date:   Tue, 9 Jun 2020 08:00:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200609140934.110785-4-willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/20 7:09 AM, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Optionally segment skbs on FQ enqueue, to later send segments at
> their individual delivery time.
> 
> Segmentation on enqueue is new for FQ, but already happens in TBF,
> CAKE and netem.
> 
> This slow patch should probably be behind a static_branch.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/sched/sch_fq.c | 33 +++++++++++++++++++++++++++++++--
>  1 file changed, 31 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
> index 8f06a808c59a..a5e2c35bb557 100644
> --- a/net/sched/sch_fq.c
> +++ b/net/sched/sch_fq.c
> @@ -439,8 +439,8 @@ static bool fq_packet_beyond_horizon(const struct sk_buff *skb,
>  	return unlikely((s64)skb->tstamp > (s64)(q->ktime_cache + q->horizon));
>  }
>  
> -static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> -		      struct sk_buff **to_free)
> +static int __fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> +			struct sk_buff **to_free)
>  {
>  	struct fq_sched_data *q = qdisc_priv(sch);
>  	struct fq_flow *f;
> @@ -496,6 +496,35 @@ static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  	return NET_XMIT_SUCCESS;
>  }
>  
> +static int fq_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> +		      struct sk_buff **to_free)
> +{
> +	struct sk_buff *segs, *next;
> +	int ret;
> +
> +	if (likely(!skb_is_gso(skb) || !skb->sk ||

You also need to check sk_fullsock(skb->sk), otherwise KMSAN might be unhappy.

> +		   !skb->sk->sk_txtime_multi_release))
> +		return __fq_enqueue(skb, sch, to_free);
> +
> +	segs = skb_gso_segment_txtime(skb);
> +	if (IS_ERR(segs))
> +		return qdisc_drop(skb, sch, to_free);
> +	if (!segs)
> +		return __fq_enqueue(skb, sch, to_free);
> +
> +	consume_skb(skb);

   This needs to be qdisc_drop(skb, sch, to_free) if queue is full, see below.

> +
> +	ret = NET_XMIT_DROP;
> +	skb_list_walk_safe(segs, segs, next) {
> +		skb_mark_not_on_list(segs);
> +		qdisc_skb_cb(segs)->pkt_len = segs->len;

This seems to under-estimate bytes sent. See qdisc_pkt_len_init() for details.

> +		if (__fq_enqueue(segs, sch, to_free) == NET_XMIT_SUCCESS)
> +			ret = NET_XMIT_SUCCESS;
> +	}

        if (unlikely(ret == NET_XMIT_DROP))
            qdisc_drop(skb, sch, to_free);
        else
            consume_skb(skb);

> +
> +	return ret;
> +}
> +
>  static void fq_check_throttled(struct fq_sched_data *q, u64 now)
>  {
>  	unsigned long sample;
> 


