Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D061219299
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:37:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgGHVhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgGHVhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:37:04 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1563C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 14:37:04 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f2so18722076plr.8
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 14:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5cFZXl6PQ1GyllgRCgHr71/9jT73bo8omQl3q45yYZI=;
        b=o+r3+orZ/bUODLdVQK0nxq+uZOwkwvK5+440zx4Y54GRTLmOfAH8zeX6Gap13c6uUZ
         FhZHp8T94yBokJiWmAEbR3so9I71MzOYnG9kg3kBnVll7TQah7D4l/b46GfLz75pd/Vm
         CY3uCUM0kbHbc3Ofuo8UHnz9U2fg0G8/zJOwGPQQVQOJiKMGertwK42jE5TPki7BTx3j
         ad8J8lFyQ5YC1L0jatkVY8TNePIKa5cDHSnqTg9d7ypot0l8ugrRDFy6QpqQgX9++wBO
         FGbvJDx0D+cQnif0nXZ4OkP03vTO58ohtv6II/lhK7G6JKccNeJrVWHq2a2nWp0nSV/o
         vomA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5cFZXl6PQ1GyllgRCgHr71/9jT73bo8omQl3q45yYZI=;
        b=eMsJ5ZyqwUZAWUCDlUioynPktNP9JFcuEUqE/pe/TYUSBxum+WzydMBXoA2r4R+Kyl
         LZugC6icNCBtPEieKiPBmMQyTqppm28IDsPVKlpsgPVTfyUgyDwC1p0f2zl82YuASUtx
         s7JyGbFwyz6jPdvmlwjuW11nIiw8Gp1X6/0rryXZPPUNVAzM3vhiQ8Hc/eMxlYH9k5cb
         /m0CkUEJp1AfwIol0yoo+V4yQ+MShMF+OLtZV0JL8ZlaGs5t8bra3gGAnNz0w8OgOrJz
         twL+hpU5UF2IEmdhECjjBaE0s8kvQYItjpFZstZuF+Ks517VIcO9Xbgkkt2nEzsYfCJU
         hN9Q==
X-Gm-Message-State: AOAM531qqkzAsWfk/WRHwv505zq4QgFroGKOCm5xBIUUWR29Spn0Eqd8
        C2Dffoeh9i6dG9hP1GwdXFqO4898
X-Google-Smtp-Source: ABdhPJykYP72Q6GECtEzUkyIAOYXOyObFKYc7o6StRjkQJwx9ORj7JO8wyvxqkOWGZpLKhfAnqCj+Q==
X-Received: by 2002:a17:90a:17e4:: with SMTP id q91mr11329014pja.61.1594244224055;
        Wed, 08 Jul 2020 14:37:04 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id l15sm433868pjq.1.2020.07.08.14.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 14:37:03 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <f7b8e306-5169-ad5c-0a5e-7ec6333e24bf@gmail.com>
Date:   Wed, 8 Jul 2020 14:37:01 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 9:38 AM, YU, Xiangning wrote:
> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
> use of outbound bandwidth on a shared link. With the help of lockless
> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
> designed to scale in the cloud data centers.
> 

...

This ltb_class struct has a size of 1579584 bytes :/

> +struct ltb_class {
> +	struct Qdisc_class_common common;
> +	struct psched_ratecfg ratecfg;
> +	struct psched_ratecfg ceilcfg;
> +	u32 prio;
> +	struct ltb_class *parent;
> +	struct Qdisc *qdisc;
> +	struct Qdisc *root_qdisc;
> +	u32 classid;
> +	struct list_head pnode;
> +	unsigned long state; ____cacheline_aligned_in_smp
> +
> +	/* Aggr/drain context only */
> +	s64 next_timestamp; ____cacheline_aligned_in_smp
> +	int num_cpus;
> +	int last_cpu;
> +	s64 bw_used;
> +	s64 last_bytes;
> +	s64 last_timestamp;
> +	s64 stat_bytes;
> +	s64 stat_packets;
> +	atomic64_t stat_drops;
> +
> +	/* Balance delayed work only */
> +	s64 rate; ____cacheline_aligned_in_smp
> +	s64 ceil;
> +	s64 high_water;
> +	int drop_delay;
> +	s64 bw_allocated;
> +	bool want_more;
> +
> +	/* Shared b/w aggr/drain thread and balancer */
> +	unsigned long curr_interval; ____cacheline_aligned_in_smp
> +	s64 bw_measured;	/* Measured actual bandwidth */
> +	s64 maxbw;	/* Calculated bandwidth */
> +
> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN) aggr_queues[MAX_CPU_COUNT];
> +	____cacheline_aligned_in_smp
> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN * MAX_CPU_COUNT) drain_queue;
> +	____cacheline_aligned_in_smp
> +	STRUCT_KFIFO(struct sk_buff *, SKB_QLEN) fanout_queues[MAX_CPU_COUNT];
> +	____cacheline_aligned_in_smp
> +
> +	struct tasklet_struct aggr_tasklet;
> +	struct hrtimer aggr_timer;
> +};
> +
>

> +
> +static struct ltb_class *ltb_alloc_class(struct Qdisc *sch,
> +					 struct ltb_class *parent, u32 classid,
> +					 struct psched_ratecfg *ratecfg,
> +					 struct psched_ratecfg *ceilcfg,
> +					 u32 prio)
> +{
> +	struct ltb_sched *ltb  = qdisc_priv(sch);
> +	struct ltb_class *cl;
> +	int i;
> +
> +	if (ratecfg->rate_bytes_ps > ceilcfg->rate_bytes_ps ||
> +	    prio < 0 || prio >= TC_LTB_NUMPRIO)
> +		return NULL;
> +
> +	cl = kzalloc(sizeof(*cl), GFP_KERNEL);

This is going to fail, 2MB chunks of physically contiguous memory is unreasonable.

2MB per class makes this qdisc very particular, especially with 1000 classes ?

In comparison, HTB class consumes less than 1 KB


