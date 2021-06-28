Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D13403B660E
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 17:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhF1Pvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 11:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbhF1PvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 11:51:25 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F45BC06115A
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 08:27:52 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i94so21802349wri.4
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 08:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lWo/Rt37gXmdt5sWI2DbV+mIEJQbvqNCpCWsIrIsohQ=;
        b=Vfj0vYoHBNt+inN+GRRLpfHzvKOGvf1c4gjFttZkCeAjw8IcRzhqZLuxt1ukkZOOYB
         aCTjhgtEeVUWHY8ukpA7uDl+L8HwPMiUzilJLDIIP03z3gF2Of6ZUZPWoC6kA6DqXsrw
         h1tMIl5hAtbzW/3gwd6cH0R1fxpV1mJJeMRZ9IXcg36+jw57Qt/O985GhzsY27LEISlc
         ynJtoTWykHCyPAqxM/YwZc6KrmivZHIZXmfQXKjNPfcLBYUSlUxxnmjikjAHtM2Sg4Ah
         NNNUM8tCVtlCMnZrRRj1KVc9uv4u5cPczIX3F/1hZWiwigOdTFWW0Vdysyc2Qc2eaODU
         oO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lWo/Rt37gXmdt5sWI2DbV+mIEJQbvqNCpCWsIrIsohQ=;
        b=uAyXc86MU59pqcl8ikS9h8tCQKwzUeVYOGs2BTFLYrt6vT3b0dNcAY9ITv6tVhCZfF
         HdaEzYmaXMIiLLL8T6gI91ar4dHUUeUBsnfYPCGkdTKCCoYSk6CG9DJlMbGMtej4QbTr
         +kR6HSFZaCZKPPaWqIKTdLPeDYlZaUNrwRECLaqHI2Np+64V3MSXQh3a64Y+va733lOL
         t2a5XFgMDImUt6tRLHIZJD6nJPOUQiMNZ1jOyw1SeRRtEsikEtjPH+VIsmzY6pTDjEw+
         tpCGtrGOLcq0gzD7qIhc1cztmLq8+4O5B/8q2WWRtk4U0s7nGIbrpeZWpULWtinfcC92
         iHFg==
X-Gm-Message-State: AOAM530OUBVW2O9dvIA5n9PmikQfCWMhhRx0laIjqSHMj2HF4YqKz+Ny
        B/GyDa+8iyfW+v43RLJ7btqHlOmxyOQ=
X-Google-Smtp-Source: ABdhPJztXf4+Diwz2iv2GjGJcZ57vXw16G9NxrzA/P+JiKdSVrerBVHDB0KyzI8bFdf5qPNQT8aeRg==
X-Received: by 2002:a5d:4e08:: with SMTP id p8mr10040704wrt.425.1624894070973;
        Mon, 28 Jun 2021 08:27:50 -0700 (PDT)
Received: from [10.0.0.12] (65.196.23.93.rev.sfr.net. [93.23.196.65])
        by smtp.gmail.com with ESMTPSA id s23sm15005989wmh.5.2021.06.28.08.27.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jun 2021 08:27:49 -0700 (PDT)
Subject: Re: [PATCH v3] net: sched: Add support for packet bursting.
To:     Niclas Hedam <nhed@itu.dk>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <532A8EEC-59FD-42F2-8568-4C649677B4B0@itu.dk>
 <877diekybt.fsf@toke.dk> <5E66E8DB-E4E5-4658-9179-E3A5BD9E8A31@itu.dk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bff04971-9e46-6674-dbbc-53e6d12b114e@gmail.com>
Date:   Mon, 28 Jun 2021 17:27:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5E66E8DB-E4E5-4658-9179-E3A5BD9E8A31@itu.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/28/21 2:08 PM, Niclas Hedam wrote:
> This commit implements packet bursting in the NetEm scheduler.
> This allows system administrators to hold back outgoing
> packets and release them at a multiple of a time quantum.
> This feature can be used to prevent timing attacks caused
> by network latency.
> 
> Signed-off-by: Niclas Hedam <niclas@hed.am>
> ---
> v2: add enum at end of list (Cong Wang)
> v3: fixed formatting of commit diff (Toke Høiland-Jørgensen)
>  include/uapi/linux/pkt_sched.h |  2 ++
>  net/sched/sch_netem.c          | 24 +++++++++++++++++++++---
>  2 files changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 79a699f106b1..1ba49f141dae 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -603,6 +603,7 @@ enum {
>  	TCA_NETEM_JITTER64,
>  	TCA_NETEM_SLOT,
>  	TCA_NETEM_SLOT_DIST,
> +        TCA_NETEM_BURSTING,
>  	__TCA_NETEM_MAX,
>  };
> 
> @@ -615,6 +616,7 @@ struct tc_netem_qopt {
>  	__u32	gap;		/* re-ordering gap (0 for none) */
>  	__u32   duplicate;	/* random packet dup  (0=none ~0=100%) */
>  	__u32	jitter;		/* random jitter in latency (us) */
> +	__u32	bursting;	/* send packets in bursts (us) */
>  };
> 
>  struct tc_netem_corr {
> diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
> index 0c345e43a09a..52d796287b86 100644
> --- a/net/sched/sch_netem.c
> +++ b/net/sched/sch_netem.c
> @@ -85,6 +85,7 @@ struct netem_sched_data {
>  	s64 latency;
>  	s64 jitter;
> 
> +	u32 bursting;
>  	u32 loss;
>  	u32 ecn;
>  	u32 limit;
> @@ -467,7 +468,7 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  	/* If a delay is expected, orphan the skb. (orphaning usually takes
>  	 * place at TX completion time, so _before_ the link transit delay)
>  	 */
> -	if (q->latency || q->jitter || q->rate)
> +	if (q->latency || q->jitter || q->rate || q->bursting)
>  		skb_orphan_partial(skb);
> 
>  	/*
> @@ -527,8 +528,17 @@ static int netem_enqueue(struct sk_buff *skb, struct Qdisc *sch,
>  	qdisc_qstats_backlog_inc(sch, skb);
> 
>  	cb = netem_skb_cb(skb);
> -	if (q->gap == 0 ||		/* not doing reordering */
> -	    q->counter < q->gap - 1 ||	/* inside last reordering gap */
> +	if (q->bursting > 0) {
> +		u64 now;
> +
> +		now = ktime_get_ns();
> +
> +		cb->time_to_send = now - (now % q->bursting) + q->bursting;

This wont compile on 32bit arches.

> +
> +		++q->counter;
> +		tfifo_enqueue(skb, sch);
> +	} else if (q->gap == 0 ||		/* not doing reordering */
> +	    q->counter < q->gap - 1 ||		/* inside last reordering gap */
>  	    q->reorder < get_crandom(&q->reorder_cor)) {
>  		u64 now;
>  		s64 delay;
> @@ -927,6 +937,7 @@ static const struct nla_policy netem_policy[TCA_NETEM_MAX + 1] = {
>  	[TCA_NETEM_ECN]		= { .type = NLA_U32 },
>  	[TCA_NETEM_RATE64]	= { .type = NLA_U64 },
>  	[TCA_NETEM_LATENCY64]	= { .type = NLA_S64 },
> +	[TCA_NETEM_BURSTING]	= { .type = NLA_U64 },
>  	[TCA_NETEM_JITTER64]	= { .type = NLA_S64 },
>  	[TCA_NETEM_SLOT]	= { .len = sizeof(struct tc_netem_slot) },
>  };
> @@ -1001,6 +1012,7 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
> 
>  	q->latency = PSCHED_TICKS2NS(qopt->latency);
>  	q->jitter = PSCHED_TICKS2NS(qopt->jitter);
> +	q->bursting = PSCHED_TICKS2NS(qopt->bursting);

This is a bit silly to use 64bit user<>kernel interface
but still use the old legacy PSCHED_TICKS2NS conversion,
since this will force a big granularity.

If someone want 10 usec bursts, we should allow it.

I would simply use a 32bit value, in ns unit.

(bursts of more than 2^32 ns make no sense)

>  	q->limit = qopt->limit;
>  	q->gap = qopt->gap;
>  	q->counter = 0;
> @@ -1032,6 +1044,9 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
>  	if (tb[TCA_NETEM_LATENCY64])
>  		q->latency = nla_get_s64(tb[TCA_NETEM_LATENCY64]);
> 
> +	if (tb[TCA_NETEM_BURSTING])
> +		q->bursting = nla_get_u64(tb[TCA_NETEM_BURSTING]);
> +
>  	if (tb[TCA_NETEM_JITTER64])
>  		q->jitter = nla_get_s64(tb[TCA_NETEM_JITTER64]);
> 
> @@ -1150,6 +1165,9 @@ static int netem_dump(struct Qdisc *sch, struct sk_buff *skb)
>  			     UINT_MAX);
>  	qopt.jitter = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->jitter),
>  			    UINT_MAX);
> +	qopt.bursting = min_t(psched_tdiff_t, PSCHED_NS2TICKS(q->bursting),
> +			    UINT_MAX);
> +
>  	qopt.limit = q->limit;
>  	qopt.loss = q->loss;
>  	qopt.gap = q->gap;
> --
> 2.25.1
> 
