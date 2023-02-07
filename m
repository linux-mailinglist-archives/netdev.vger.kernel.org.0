Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F7468E39A
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjBGWug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjBGWuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:50:35 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F246E1421E
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 14:50:33 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id v23so17308704plo.1
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 14:50:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OHT2t7CmHc1BShbkXNiomXJ+rZ4JX8H7RJvJy1LCAdk=;
        b=gJltYkvCj7+EpdWp0/S23i/RnQDHlDYxSDvY5pIP12Z/NO47lTB1SeSnxvRFcVZSfL
         S6SW2EVvAGHPwonuCa0buyYqgukYosg7GP3EbS2fnUHkYvNoZgIGfXCKN0bflif+c32Z
         x28sQ/HYNK5xFOYa8WSr2QFZCRzl2eQv4gLBMWDnoBGeCstVM+QzkuLfkiLSizm59ewC
         jsHHeI8g8KFGx/mHGbsn9xIP8cXI1M4iE/7JSPmsdVVWXuyZFesG+3Qxk6jUao4lB7/C
         m7cqgUW0oB8QOBh0Q7p1hlooAIwziMiWbfHwefiGN8QOoYJQFtoz6yYOXti0ls3+ZmpG
         eC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OHT2t7CmHc1BShbkXNiomXJ+rZ4JX8H7RJvJy1LCAdk=;
        b=zuCZLhDXY4exCA1PdH9D980Vv2i2uhim11yof57qEaVaNKDT5y/IecmH/l8nbDkCEE
         EmuxHwuIdpVGyDGVJwW3gL+rBMYdXtTMn/NDk309RMJUy+2oqPamIHfBOaEqcZT1o10A
         uFkbg9GaVDlscYLCQfHu4ge2JQMmJRCuGBk9ICpGXFymK3zAa4HObElxhDniVfa7Yg46
         L51m3sCA5l8vncOYtApMobFcZ8iKnDOzfLmBaVZAA1fySHPgs1ONwbB1F/2eN7TbSx+f
         HmWj6dbx5cLQ5aa2HMt+BuGoexN9sRW+tZ8kFMQVX/W6NKog8i8ab5nXYRS+wOD7iQ4O
         WXQg==
X-Gm-Message-State: AO0yUKXMsxYJ3D3wgjqFTE4rrltKG6HqWBwXgP4LA6Fyh6VKVcTshNSK
        ikvDnAAvwYAp1gdJrQ4jBmY0LA==
X-Google-Smtp-Source: AK7set+pFU/IFlHDvEox1zOv0bHiMl99DhW2PrN2q18Oy2kCDcbZ4zI2PcDzJ5lFxTDwMXdCPADZKw==
X-Received: by 2002:a17:902:e5d1:b0:196:3cab:58cf with SMTP id u17-20020a170902e5d100b001963cab58cfmr4979486plf.4.1675810233198;
        Tue, 07 Feb 2023 14:50:33 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id iy10-20020a170903130a00b0019928ce257dsm2653653plb.99.2023.02.07.14.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 14:50:32 -0800 (PST)
Message-ID: <d66a3abd-18cf-02be-cd99-9dda1b3fd85e@kernel.dk>
Date:   Tue, 7 Feb 2023 15:50:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v7 1/3] io_uring: add napi busy polling support
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, ammarfaizi2@gnuweeb.org
References: <20230203060850.3060238-1-shr@devkernel.io>
 <20230203060850.3060238-2-shr@devkernel.io>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230203060850.3060238-2-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 128a67a40065..d9551790356e 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -2,6 +2,7 @@
>  #define IO_URING_TYPES_H
>  
>  #include <linux/blkdev.h>
> +#include <linux/hashtable.h>
>  #include <linux/task_work.h>
>  #include <linux/bitmap.h>
>  #include <linux/llist.h>
> @@ -274,6 +275,15 @@ struct io_ring_ctx {
>  	struct xarray		personalities;
>  	u32			pers_next;
>  
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	struct list_head	napi_list;	/* track busy poll napi_id */
> +	DECLARE_HASHTABLE(napi_ht, 8);
> +	spinlock_t		napi_lock;	/* napi_list lock */
> +
> +	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
> +	bool			napi_prefer_busy_poll;
> +#endif
Minor thing, but I wonder if we should put this in a struct and allocate
it if NAPI gets used rather than bloat the whole thing here. This
doubles the size of io_ring_ctx, the hash above is 2k in size!

> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index db623b3185c8..96062036db41 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -90,6 +90,7 @@
>  #include "rsrc.h"
>  #include "cancel.h"
>  #include "net.h"
> +#include "napi.h"
>  #include "notif.h"
>  
>  #include "timeout.h"
> @@ -335,6 +336,14 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>  	INIT_WQ_LIST(&ctx->locked_free_list);
>  	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>  	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
> +
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	INIT_LIST_HEAD(&ctx->napi_list);
> +	spin_lock_init(&ctx->napi_lock);
> +	ctx->napi_prefer_busy_poll = false;
> +	ctx->napi_busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
> +#endif

I think that should go in a io_napi_init() function, so we can get rid
of these ifdefs in the main code.

>  static inline bool io_has_work(struct io_ring_ctx *ctx)
> @@ -2498,6 +2512,196 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  	return ret < 0 ? ret : 1;
>  }
>  
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
> +
> +struct io_napi_ht_entry {
> +	unsigned int		napi_id;
> +	struct list_head	list;
> +
> +	/* Covered by napi lock spinlock.  */
> +	unsigned long		timeout;
> +	struct hlist_node	node;
> +};

Not strictly related to just this, but I think it'd be a good idea to
add a napi.c file and put it all in there rather than in the core
io_uring code. It really doesn't belong there.

> +/*
> + * io_napi_add() - Add napi id to the busy poll list
> + * @file: file pointer for socket
> + * @ctx:  io-uring context
> + *
> + * Add the napi id of the socket to the napi busy poll list and hash table.
> + */
> +void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
> +{
> +	unsigned int napi_id;
> +	struct socket *sock;
> +	struct sock *sk;
> +	struct io_napi_ht_entry *he;
> +
> +	if (!io_napi_busy_loop_on(ctx))
> +		return;

I think io_napi_add() belongs in napi.h and should look ala:

static inline void io_napi_add(struct io_kiocb *req)
{
	struct io_ring_ctx *ctx = req->ctx;

	if (!io_napi_busy_loop_on(ctx))
		return;

	__io_napi_add(ctx, req->file);
}

and put __io_napi_add() in napi.c

> +static void io_napi_free_list(struct io_ring_ctx *ctx)
> +{
> +	unsigned int i;
> +	struct io_napi_ht_entry *he;
> +	LIST_HEAD(napi_list);
> +
> +	spin_lock(&ctx->napi_lock);
> +	hash_for_each(ctx->napi_ht, i, he, node) {
> +		hash_del(&he->node);
> +	}
> +	spin_unlock(&ctx->napi_lock);
> +}

No need for the braces here for the loop.

> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
> +				       struct io_wait_queue *iowq)
> +{
> +	unsigned long start_time = list_is_singular(napi_list)
> +					? 0
> +					: busy_loop_current_time();

No ternaries please. This is so much easier to read as:

	unsigned long start_time = 0;

	if (!list_is_singular(napi_list))
		start_time = busy_loop_current_time();

> +	do {
> +		if (list_is_singular(napi_list)) {
> +			struct io_napi_ht_entry *ne =
> +				list_first_entry(napi_list,
> +						 struct io_napi_ht_entry, list);
> +
> +			napi_busy_loop(ne->napi_id, io_napi_busy_loop_end, iowq,
> +				       iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
> +			break;
> +		}
> +	} while (io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll) &&
> +		 !io_napi_busy_loop_end(iowq, start_time));
> +}

This is almost impossible to read, please rewrite that in a way so
that it's straight forward to understand what is going on.

> +void io_napi_merge_lists(struct io_ring_ctx *ctx, struct list_head *napi_list)
> +{
> +	spin_lock(&ctx->napi_lock);
> +	list_splice(napi_list, &ctx->napi_list);
> +	io_napi_remove_stale(ctx);
> +	spin_unlock(&ctx->napi_lock);
> +}

Question on the locking - the separate lock is obviously functionally
correct, but at least for the arming part, we generally already have the
ctx uring_lock at that point. Did you look into if it's feasible to take
advantage of that? I

> @@ -2510,6 +2714,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	struct io_rings *rings = ctx->rings;
>  	ktime_t timeout = KTIME_MAX;
>  	int ret;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	LIST_HEAD(local_napi_list);
> +#endif
>  
>  	if (!io_allowed_run_tw(ctx))
>  		return -EEXIST;
> @@ -2539,12 +2746,34 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  			return ret;
>  	}
>  
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	iowq.napi_busy_poll_to = 0;
> +	iowq.napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
> +
> +	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
> +		spin_lock(&ctx->napi_lock);
> +		list_splice_init(&ctx->napi_list, &local_napi_list);
> +		spin_unlock(&ctx->napi_lock);
> +	}
> +#endif
> +
>  	if (uts) {
>  		struct timespec64 ts;
>  
>  		if (get_timespec64(&ts, uts))
>  			return -EFAULT;
> +
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +		if (!list_empty(&local_napi_list)) {
> +			io_napi_adjust_busy_loop_timeout(READ_ONCE(ctx->napi_busy_poll_to),
> +						&ts, &iowq.napi_busy_poll_to);
> +		}
> +#endif
>  		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	} else if (!list_empty(&local_napi_list)) {
> +		iowq.napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
> +#endif
>  	}

This is again a lot of ifdefs, please consider ways of getting rid of
them.

> @@ -2555,6 +2784,15 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>  
>  	trace_io_uring_cqring_wait(ctx, min_events);
> +
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	if (iowq.napi_busy_poll_to)
> +		io_napi_blocking_busy_loop(&local_napi_list, &iowq);
> +
> +	if (!list_empty(&local_napi_list))
> +		io_napi_merge_lists(ctx, &local_napi_list);
> +#endif
> +

And here.

>  	do {
>  		if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
>  			finish_wait(&ctx->cq_wait, &iowq.wq);
> @@ -2754,6 +2992,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>  	io_req_caches_free(ctx);
>  	if (ctx->hash_map)
>  		io_wq_put_hash(ctx->hash_map);
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	io_napi_free_list(ctx);
> +#endif

Put an io_napi_free_list() stub in napi.h with the actual thing in
napi.c if CONFIG_NET_RX_BUSY_POLL is defined.

> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index 559652380672..b9fb077de15b 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -15,6 +15,7 @@
>  #include <uapi/linux/io_uring.h>
>  
>  #include "io_uring.h"
> +#include "napi.h"
>  #include "sqpoll.h"
>  
>  #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
> @@ -168,6 +169,9 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>  {
>  	unsigned int to_submit;
>  	int ret = 0;
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	LIST_HEAD(local_napi_list);
> +#endif
>  
>  	to_submit = io_sqring_entries(ctx);
>  	/* if we're handling multiple rings, cap submit size for fairness */
> @@ -193,6 +197,19 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>  			ret = io_submit_sqes(ctx, to_submit);
>  		mutex_unlock(&ctx->uring_lock);
>  
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +		spin_lock(&ctx->napi_lock);
> +		list_splice_init(&ctx->napi_list, &local_napi_list);
> +		spin_unlock(&ctx->napi_lock);
> +
> +		if (!list_empty(&local_napi_list) &&
> +		    READ_ONCE(ctx->napi_busy_poll_to) > 0 &&
> +		    io_napi_busy_loop(&local_napi_list, ctx->napi_prefer_busy_poll)) {
> +			io_napi_merge_lists(ctx, &local_napi_list);
> +			++ret;
> +		}
> +#endif
> +
>  		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
>  			wake_up(&ctx->sqo_sq_wait);
>  		if (creds)

Add a helper here too please.

-- 
Jens Axboe


