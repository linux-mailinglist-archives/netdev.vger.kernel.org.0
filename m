Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA6B6913D0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 23:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjBIW6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 17:58:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjBIW6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 17:58:22 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE57759EB;
        Thu,  9 Feb 2023 14:58:20 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E59715C019A;
        Thu,  9 Feb 2023 17:58:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 09 Feb 2023 17:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=devkernel.io; h=
        cc:cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1675983497; x=1676069897; bh=T9qwmWUoby
        dUXq0GSoviXyxe8Wv5bXZrLpHZb+Q0fwE=; b=H1xS9YdEPs5gZIYdTqWnP+hzO8
        FjPByAkLtr7DY+EA42syeLtbIgvng+VphNqS/J+BRWy0dwtZ5Z/zQ/zJ6mdITTow
        s/+4t37VlQ6q4QdwYgX+Dm7vPYRtnMUyd6VTtAXLLkBeMWo0XLMEWup7PZAars6m
        5DDlKec7h//ng1vg5rsbfXVsu+yP8OU7eGla57Wkr483GAscHG4kDC20/6agJyvw
        U3tubq6th4tdSQeLSw7773OK6b3QBzW2aLHINuuh08ssB2ClnL7LntGqNHdjbPqr
        ZYBI81JXTnaiUpG4HLLcMA4i1/RcIJqUQerTD/tQ/CI2hanKdXrWWgqsgpRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1675983497; x=1676069897; bh=T9qwmWUobydUXq0GSoviXyxe8Wv5
        bXZrLpHZb+Q0fwE=; b=lVitY9WfZUN+vUVeNxiEZcftwwNWNlFbRtq1rWprGUUv
        opEe4CZ7eus+id8W0yulclfYHLGDqwEyT7Ot/fgbh1Jf5zfjip/z9zK+JckTCJ+e
        vtesv2Ahh8kFYa/2oTVYu8UlXohHJ/pW4r8DbX++1DdVlYRCW0tNVNc4237IirWy
        GZZGW18L89YY55URECGBqtzmjxVJ775mSZP2e3W0yPCVY3DqTPHI/gPUpKvi3qbN
        iCwruHUg0Gh6pWFSDYPApUNyZJBi2zPHW6PQBTYocJKQ5Nf7xa/efQ/HH2SLcFDB
        it+q6LF09+HqimKRg2BZY9f4u/cXTaqs7hZXEdP2/Q==
X-ME-Sender: <xms:iXrlYy3wwHNJdSqb9XMK3FXv3oRhICdaQeDCT87vuuj1hssp3X8ftQ>
    <xme:iXrlY1HNYFhdAv6JXVmrEBLpcWfIGrGE490BCMPg2O7DrlG0ndnOzZXwQlLBLE0Y-
    GtQH7OE4phRFrZPETI>
X-ME-Received: <xmr:iXrlY66JuhXnIdTAtNsg_E-Fa5GZVnB92z9mPjgeBHMylkeN3bWwWJrGgU_SeY8NK2O8Xm6GqhfdKE_jStDnnaTba0vlT3YCPynZyhKf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehgedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfhgfhffvvefuffgjkfggtgesthdtredttdertdenucfhrhhomhepufhtvghf
    rghnucftohgvshgthhcuoehshhhrseguvghvkhgvrhhnvghlrdhioheqnecuggftrfgrth
    htvghrnhepveelgffghfehudeitdehjeevhedthfetvdfhledutedvgeeikeeggefgudeg
    uedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsh
    hhrhesuggvvhhkvghrnhgvlhdrihho
X-ME-Proxy: <xmx:iXrlYz1fau2DtI9hlMF8UVO5fkG7mOKAfzppWXWRdnQ1p__0bCMvVg>
    <xmx:iXrlY1EfW5YeRPK3xB4gGfo7Vg6YHGyZGnpXnmJf8F-UQyQS6FZmvQ>
    <xmx:iXrlY8-3gYAXHwkGq4e1qy9qvvUhu1gLUwqzBn0b4S9ySM3Ot483rA>
    <xmx:iXrlY-M7rQVcvO5IcfiZdKUeDUq_grypFuqnhMN0DQk8Sr-q1gb36Q>
Feedback-ID: i84614614:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Feb 2023 17:58:16 -0500 (EST)
References: <20230203060850.3060238-1-shr@devkernel.io>
 <20230203060850.3060238-2-shr@devkernel.io>
 <d66a3abd-18cf-02be-cd99-9dda1b3fd85e@kernel.dk>
User-agent: mu4e 1.6.11; emacs 28.2.50
From:   Stefan Roesch <shr@devkernel.io>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     kernel-team@fb.com, olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org, ammarfaizi2@gnuweeb.org
Subject: Re: [PATCH v7 1/3] io_uring: add napi busy polling support
Date:   Thu, 09 Feb 2023 14:53:29 -0800
In-reply-to: <d66a3abd-18cf-02be-cd99-9dda1b3fd85e@kernel.dk>
Message-ID: <qvqw4jrula4c.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jens Axboe <axboe@kernel.dk> writes:

>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 128a67a40065..d9551790356e 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -2,6 +2,7 @@
>>  #define IO_URING_TYPES_H
>>
>>  #include <linux/blkdev.h>
>> +#include <linux/hashtable.h>
>>  #include <linux/task_work.h>
>>  #include <linux/bitmap.h>
>>  #include <linux/llist.h>
>> @@ -274,6 +275,15 @@ struct io_ring_ctx {
>>  	struct xarray		personalities;
>>  	u32			pers_next;
>>
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	struct list_head	napi_list;	/* track busy poll napi_id */
>> +	DECLARE_HASHTABLE(napi_ht, 8);
>> +	spinlock_t		napi_lock;	/* napi_list lock */
>> +
>> +	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
>> +	bool			napi_prefer_busy_poll;
>> +#endif
> Minor thing, but I wonder if we should put this in a struct and allocate
> it if NAPI gets used rather than bloat the whole thing here. This
> doubles the size of io_ring_ctx, the hash above is 2k in size!
>
I changed the hash table size to 16, so the size should no longer be a
concern. The hash table was sized too big, its limited by the number of
nic queues.

>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index db623b3185c8..96062036db41 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -90,6 +90,7 @@
>>  #include "rsrc.h"
>>  #include "cancel.h"
>>  #include "net.h"
>> +#include "napi.h"
>>  #include "notif.h"
>>
>>  #include "timeout.h"
>> @@ -335,6 +336,14 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>  	INIT_WQ_LIST(&ctx->locked_free_list);
>>  	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>>  	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	INIT_LIST_HEAD(&ctx->napi_list);
>> +	spin_lock_init(&ctx->napi_lock);
>> +	ctx->napi_prefer_busy_poll = false;
>> +	ctx->napi_busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
>> +#endif
>
> I think that should go in a io_napi_init() function, so we can get rid
> of these ifdefs in the main code.
>

The next version will add io_napi_init and io_napi_free.

>>  static inline bool io_has_work(struct io_ring_ctx *ctx)
>> @@ -2498,6 +2512,196 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>>  	return ret < 0 ? ret : 1;
>>  }
>>
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
>> +
>> +struct io_napi_ht_entry {
>> +	unsigned int		napi_id;
>> +	struct list_head	list;
>> +
>> +	/* Covered by napi lock spinlock.  */
>> +	unsigned long		timeout;
>> +	struct hlist_node	node;
>> +};
>
> Not strictly related to just this, but I think it'd be a good idea to
> add a napi.c file and put it all in there rather than in the core
> io_uring code. It really doesn't belong there.
>

The next version adds a napi.c file and all napi functions are moved
there.

>> +/*
>> + * io_napi_add() - Add napi id to the busy poll list
>> + * @file: file pointer for socket
>> + * @ctx:  io-uring context
>> + *
>> + * Add the napi id of the socket to the napi busy poll list and hash table.
>> + */
>> +void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
>> +{
>> +	unsigned int napi_id;
>> +	struct socket *sock;
>> +	struct sock *sk;
>> +	struct io_napi_ht_entry *he;
>> +
>> +	if (!io_napi_busy_loop_on(ctx))
>> +		return;
>
> I think io_napi_add() belongs in napi.h and should look ala:
>
> static inline void io_napi_add(struct io_kiocb *req)
> {
> 	struct io_ring_ctx *ctx = req->ctx;
>
> 	if (!io_napi_busy_loop_on(ctx))
> 		return;
>
> 	__io_napi_add(ctx, req->file);
> }
>
> and put __io_napi_add() in napi.c
>

I added the above function.

>> +static void io_napi_free_list(struct io_ring_ctx *ctx)
>> +{
>> +	unsigned int i;
>> +	struct io_napi_ht_entry *he;
>> +	LIST_HEAD(napi_list);
>> +
>> +	spin_lock(&ctx->napi_lock);
>> +	hash_for_each(ctx->napi_ht, i, he, node) {
>> +		hash_del(&he->node);
>> +	}
>> +	spin_unlock(&ctx->napi_lock);
>> +}
>
> No need for the braces here for the loop.
>

Fixed in the next version.

>> +static void io_napi_blocking_busy_loop(struct list_head *napi_list,
>> +				       struct io_wait_queue *iowq)
>> +{
>> +	unsigned long start_time = list_is_singular(napi_list)
>> +					? 0
>> +					: busy_loop_current_time();
>
> No ternaries please. This is so much easier to read as:
>
> 	unsigned long start_time = 0;
>
> 	if (!list_is_singular(napi_list))
> 		start_time = busy_loop_current_time();
>

Fixed in the next version.

>> +	do {
>> +		if (list_is_singular(napi_list)) {
>> +			struct io_napi_ht_entry *ne =
>> +				list_first_entry(napi_list,
>> +						 struct io_napi_ht_entry, list);
>> +
>> +			napi_busy_loop(ne->napi_id, io_napi_busy_loop_end, iowq,
>> +				       iowq->napi_prefer_busy_poll, BUSY_POLL_BUDGET);
>> +			break;
>> +		}
>> +	} while (io_napi_busy_loop(napi_list, iowq->napi_prefer_busy_poll) &&
>> +		 !io_napi_busy_loop_end(iowq, start_time));
>> +}
>
> This is almost impossible to read, please rewrite that in a way so
> that it's straight forward to understand what is going on.
>

I rewrote the function in the next version of the patch series.

>> +void io_napi_merge_lists(struct io_ring_ctx *ctx, struct list_head *napi_list)
>> +{
>> +	spin_lock(&ctx->napi_lock);
>> +	list_splice(napi_list, &ctx->napi_list);
>> +	io_napi_remove_stale(ctx);
>> +	spin_unlock(&ctx->napi_lock);
>> +}
>
> Question on the locking - the separate lock is obviously functionally
> correct, but at least for the arming part, we generally already have the
> ctx uring_lock at that point. Did you look into if it's feasible to take
> advantage of that? I
>

Its not guaranteed to have the lock in all code paths when I checked.

>> @@ -2510,6 +2714,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  	struct io_rings *rings = ctx->rings;
>>  	ktime_t timeout = KTIME_MAX;
>>  	int ret;
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	LIST_HEAD(local_napi_list);
>> +#endif
>>
>>  	if (!io_allowed_run_tw(ctx))
>>  		return -EEXIST;
>> @@ -2539,12 +2746,34 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  			return ret;
>>  	}
>>
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	iowq.napi_busy_poll_to = 0;
>> +	iowq.napi_prefer_busy_poll = READ_ONCE(ctx->napi_prefer_busy_poll);
>> +
>> +	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
>> +		spin_lock(&ctx->napi_lock);
>> +		list_splice_init(&ctx->napi_list, &local_napi_list);
>> +		spin_unlock(&ctx->napi_lock);
>> +	}
>> +#endif
>> +
>>  	if (uts) {
>>  		struct timespec64 ts;
>>
>>  		if (get_timespec64(&ts, uts))
>>  			return -EFAULT;
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +		if (!list_empty(&local_napi_list)) {
>> +			io_napi_adjust_busy_loop_timeout(READ_ONCE(ctx->napi_busy_poll_to),
>> +						&ts, &iowq.napi_busy_poll_to);
>> +		}
>> +#endif
>>  		timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	} else if (!list_empty(&local_napi_list)) {
>> +		iowq.napi_busy_poll_to = READ_ONCE(ctx->napi_busy_poll_to);
>> +#endif
>>  	}
>
> This is again a lot of ifdefs, please consider ways of getting rid of
> them.
>

I added helper functions to eliminate the ifdefs.

>> @@ -2555,6 +2784,15 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>>  	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
>>
>>  	trace_io_uring_cqring_wait(ctx, min_events);
>> +
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	if (iowq.napi_busy_poll_to)
>> +		io_napi_blocking_busy_loop(&local_napi_list, &iowq);
>> +
>> +	if (!list_empty(&local_napi_list))
>> +		io_napi_merge_lists(ctx, &local_napi_list);
>> +#endif
>> +
>
> And here.
>
>>  	do {
>>  		if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
>>  			finish_wait(&ctx->cq_wait, &iowq.wq);
>> @@ -2754,6 +2992,9 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>>  	io_req_caches_free(ctx);
>>  	if (ctx->hash_map)
>>  		io_wq_put_hash(ctx->hash_map);
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	io_napi_free_list(ctx);
>> +#endif
>
> Put an io_napi_free_list() stub in napi.h with the actual thing in
> napi.c if CONFIG_NET_RX_BUSY_POLL is defined.
>

I added io_napi_free as a helper function.

>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 559652380672..b9fb077de15b 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -15,6 +15,7 @@
>>  #include <uapi/linux/io_uring.h>
>>
>>  #include "io_uring.h"
>> +#include "napi.h"
>>  #include "sqpoll.h"
>>
>>  #define IORING_SQPOLL_CAP_ENTRIES_VALUE 8
>> @@ -168,6 +169,9 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>>  {
>>  	unsigned int to_submit;
>>  	int ret = 0;
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +	LIST_HEAD(local_napi_list);
>> +#endif
>>
>>  	to_submit = io_sqring_entries(ctx);
>>  	/* if we're handling multiple rings, cap submit size for fairness */
>> @@ -193,6 +197,19 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
>>  			ret = io_submit_sqes(ctx, to_submit);
>>  		mutex_unlock(&ctx->uring_lock);
>>
>> +#ifdef CONFIG_NET_RX_BUSY_POLL
>> +		spin_lock(&ctx->napi_lock);
>> +		list_splice_init(&ctx->napi_list, &local_napi_list);
>> +		spin_unlock(&ctx->napi_lock);
>> +
>> +		if (!list_empty(&local_napi_list) &&
>> +		    READ_ONCE(ctx->napi_busy_poll_to) > 0 &&
>> +		    io_napi_busy_loop(&local_napi_list, ctx->napi_prefer_busy_poll)) {
>> +			io_napi_merge_lists(ctx, &local_napi_list);
>> +			++ret;
>> +		}
>> +#endif
>> +
>>  		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
>>  			wake_up(&ctx->sqo_sq_wait);
>>  		if (creds)
>
> Add a helper here too please.

I also added a helper function for the sqpoll busy poll.
