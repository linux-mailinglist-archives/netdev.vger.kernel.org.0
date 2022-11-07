Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F35A61FDA0
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 19:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiKGSdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 13:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231450AbiKGSdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 13:33:45 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D0D6A44C;
        Mon,  7 Nov 2022 10:33:44 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id h14so11367489pjv.4;
        Mon, 07 Nov 2022 10:33:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OI/lzTT1Vk9ql/bvDmK896/UvX4Q3wTA+4UFk5BnNko=;
        b=DH4QRAZFxQOIdm/2pPdd1i2B4InlhTzc7ibr6QF/dOhgyCzWYioQzPG7wT0E9D81Sh
         wSSggIZpwv0UX4zynRonOq0fK4CVlWmUh+pDdw8qpyqhAlZmZnWVHgyCeKn43CKteQeS
         dYzZSMy489Aocg6qSwpZUG9c7uDCLLYbRGCC3pgO50D+nSvqkD6hlf33AAivsCP+Mml0
         olbeAziBFVeqHjjcwPI4I6n1wz84rXIFTO7tnS2nT+SBU/WBKItZaUQsrXnWol6ykw3I
         6oi5uVjZkLDHlJhTmUcpGrRn+iCoRfiaZS/rUcgmCTvYPJ31csktS8XHGP3gf7HiglBw
         rQyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OI/lzTT1Vk9ql/bvDmK896/UvX4Q3wTA+4UFk5BnNko=;
        b=3+FrDi4HW5sbA9ZlDHB/DVZNUWCeVmRTulFLpkIbzjlSf5bNR693pt9lvGFmjDj9Ue
         4AbMmqhRWuLuC10cl7Tg+g00H7PzFUkUxpzeZpWzE0GSRWWJ08GNsUCtShPQsDd+89/9
         CFVqVhN4lKIlm2OGz1/C6eIQNRgzIWVUNk4/COp4RRCV1X0Zb0Cg2SE0HKuCjjH2c5sV
         QNUYuAbgyZtMYYMyV4u4NQ9KZ34Bx/tKlmISKBtig2itkR3xeEOvyFubQaRkl2aozXiL
         uN6k2bAb3daEYkFGyjNdA0g1EcDVB2P6qPLK55D/JZDCHIGemIUpJULZyWQZUIptKCZN
         QCZA==
X-Gm-Message-State: ACrzQf1lv1Zc5VEex3Vlefsldup4xNk3kWvX9RsM99o6Iz6uren4qseh
        DDdyEigFDyxjKMIdeN118AE=
X-Google-Smtp-Source: AMsMyM76HR1Qm6LNKdlcF49AbR44CXrdx9yRUHdNi6SOQMbf8d/1D3mk/kKjz83nam6F+SipDs50MQ==
X-Received: by 2002:a17:90b:2705:b0:20a:b4fa:f624 with SMTP id px5-20020a17090b270500b0020ab4faf624mr52551434pjb.124.1667846023593;
        Mon, 07 Nov 2022 10:33:43 -0800 (PST)
Received: from [192.168.86.247] (c-73-158-95-42.hsd1.ca.comcast.net. [73.158.95.42])
        by smtp.gmail.com with ESMTPSA id f17-20020aa79d91000000b005627d995a36sm4796512pfq.44.2022.11.07.10.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Nov 2022 10:33:42 -0800 (PST)
Message-ID: <0099021f-9185-69c1-3e63-64afdba988cf@gmail.com>
Date:   Mon, 7 Nov 2022 10:33:41 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH v2 1/2] io_uring: add napi busy polling support
To:     Stefan Roesch <shr@devkernel.io>, kernel-team@fb.com
Cc:     axboe@kernel.dk, olivier@trillion01.com, netdev@vger.kernel.org,
        io-uring@vger.kernel.org, kuba@kernel.org
References: <20221107175240.2725952-1-shr@devkernel.io>
 <20221107175240.2725952-2-shr@devkernel.io>
Content-Language: en-US
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20221107175240.2725952-2-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/7/22 09:52, Stefan Roesch wrote:
> This adds the napi busy polling support in io_uring.c. It adds a new
> napi_list to the io_ring_ctx structure. This list contains the list of
> napi_id's that are currently enabled for busy polling. The list is
> synchronized by the new napi_lock spin lock. The current default napi
> busy polling time is stored in napi_busy_poll_to. If napi busy polling
> is not enabled, the value is 0.
>
> The busy poll timeout is also stored as part of the io_wait_queue. This
> is necessary as for sq polling the poll interval needs to be adjusted
> and the napi callback allows only to pass in one value.
>
> Testing has shown that the round-trip times are reduced to 38us from
> 55us by enabling napi busy polling with a busy poll timeout of 100us.
>
> Signed-off-by: Stefan Roesch <shr@devkernel.io>
> Suggested-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   include/linux/io_uring_types.h |   6 +
>   io_uring/io_uring.c            | 240 +++++++++++++++++++++++++++++++++
>   io_uring/napi.h                |  22 +++
>   io_uring/poll.c                |   3 +
>   io_uring/sqpoll.c              |   9 ++
>   5 files changed, 280 insertions(+)
>   create mode 100644 io_uring/napi.h
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index f5b687a787a3..84b446b0d215 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -270,6 +270,12 @@ struct io_ring_ctx {
>   	struct xarray		personalities;
>   	u32			pers_next;
>   
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	struct list_head	napi_list;	/* track busy poll napi_id */
> +	spinlock_t		napi_lock;	/* napi_list lock */
> +	unsigned int		napi_busy_poll_to; /* napi busy poll default timeout */
> +#endif
> +
>   	struct {
>   		/*
>   		 * We cache a range of free CQEs we can use, once exhausted it
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index ac8c488e3077..b02bba4ebcbf 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -90,6 +90,7 @@
>   #include "rsrc.h"
>   #include "cancel.h"
>   #include "net.h"
> +#include "napi.h"
>   #include "notif.h"
>   
>   #include "timeout.h"
> @@ -327,6 +328,13 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	INIT_WQ_LIST(&ctx->locked_free_list);
>   	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
>   	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
> +
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	INIT_LIST_HEAD(&ctx->napi_list);
> +	spin_lock_init(&ctx->napi_lock);
> +	ctx->napi_busy_poll_to = READ_ONCE(sysctl_net_busy_poll);
> +#endif
> +
>   	return ctx;
>   err:
>   	kfree(ctx->dummy_ubuf);
> @@ -2303,6 +2311,10 @@ struct io_wait_queue {
>   	struct io_ring_ctx *ctx;
>   	unsigned cq_tail;
>   	unsigned nr_timeouts;
> +
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +	unsigned int busy_poll_to;
> +#endif
>   };
>   
>   static inline bool io_has_work(struct io_ring_ctx *ctx)
> @@ -2376,6 +2388,198 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>   	return 1;
>   }
>   
> +#ifdef CONFIG_NET_RX_BUSY_POLL
> +#define NAPI_TIMEOUT		(60 * SEC_CONVERSION)
> +
> +struct io_napi_entry {
> +	struct list_head	list;
> +	unsigned int		napi_id;
> +	unsigned long		timeout;
> +};
> +
> +static bool io_napi_busy_loop_on(struct io_ring_ctx *ctx)
> +{
> +	return READ_ONCE(ctx->napi_busy_poll_to);
> +}
> +
> +/*
> + * io_napi_add() - Add napi id to the busy poll list
> + * @file: file pointer for socket
> + * @ctx:  io-uring context
> + *
> + * Add the napi id of the socket to the napi busy poll list.
> + */
> +void io_napi_add(struct file *file, struct io_ring_ctx *ctx)
> +{
> +	unsigned int napi_id;
> +	struct socket *sock;
> +	struct sock *sk;
> +	struct io_napi_entry *ne;
> +
> +	if (!io_napi_busy_loop_on(ctx))
> +		return;
> +
> +	sock = sock_from_file(file);
> +	if (!sock)
> +		return;
> +
> +	sk = sock->sk;
> +	if (!sk)
> +		return;
> +
> +	napi_id = READ_ONCE(sk->sk_napi_id);
> +
> +	/* Non-NAPI IDs can be rejected */
> +	if (napi_id < MIN_NAPI_ID)
> +		return;
> +
> +	spin_lock(&ctx->napi_lock);
> +	list_for_each_entry(ne, &ctx->napi_list, list) {
> +		if (ne->napi_id == napi_id) {
> +			ne->timeout = jiffies + NAPI_TIMEOUT;
> +			goto out;
> +		}

This list could become very big, if you do not remove stale napi_id from it.

Device reconfiguration do not recycle napi_id, it creates new ones.


> +	}
> +
> +	ne = kmalloc(sizeof(*ne), GFP_NOWAIT);
> +	if (!ne)
> +		goto out;
> +
> +	ne->napi_id = napi_id;
> +	ne->timeout = jiffies + NAPI_TIMEOUT;
> +	list_add_tail(&ne->list, &ctx->napi_list);
> +
> +out:
> +	spin_unlock(&ctx->napi_lock);
> +}
> +
> +

