Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F05B606224
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 15:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiJTNri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 09:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJTNrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 09:47:36 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D856188100;
        Thu, 20 Oct 2022 06:47:34 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so2215879wmq.4;
        Thu, 20 Oct 2022 06:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DUeyLKFEKZCoWrqjotl/UIMGSQmHxC+SlSV0Q+kjoMw=;
        b=qaEGbRisWRW8Ap+sF4YBUanz6C0QzQO3OQDrX9Y2bElYk1m4nLKiTK9gpwzE98LryU
         rMdrPExY/fAHFiU3Ih9sNY05yXt6bkRkzzzuVoRHTi7BX23iK5pFGa1dpvBwdWtGaNw9
         +N3LOMivIuqBZ5UMEoZzmkyPyuUiqH4yP1eP5EvDYB81mP9Vx86xA66URpeJ3CGFBHze
         1N3eoU5Ptxiueee20PIdvLo4icJegq9ZkTe8xyjPSassxfD90+o30Jo1Vo1OATsRBadR
         QHEpIr//PtTXj92Om4i6rug9hog78sZbGvbWbMVE7ZUvrwwZacuXWiLtwsU0kkGk1HWH
         JJKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DUeyLKFEKZCoWrqjotl/UIMGSQmHxC+SlSV0Q+kjoMw=;
        b=V9xuP5xAtyErG/c/yk8BWZS+++vEPhEZC8W0We+jF/mpqT29A7IACT6hm4VA/98OTw
         9V4xF9sxXXu5hqaffgFnQo8lkMLiHDNUXCvQCYoOvc5ZHs63dkPpMDzF0QxbOVApRONh
         6kG6djQTJR4duHPhvGMQ2lHxO5c3ZM0/fXwNRtkYACZ+4TKLfupFpRmF35svcaFt8du6
         wJA5nrwb7voQanYf93qnuLDb5/rZGllgHRfdb4zpZrVwUER47lf+/QUyuO3DBdyOdyJX
         kjGFnmUXv+NpHkuR1vSkHr7F2PH9oKy2ASYZVzf7K2KkZk25ouYUS3NhkCU6+5yNF2pq
         7lag==
X-Gm-Message-State: ACrzQf1qGnvw23tkjX2MFywcj58TXXitRPyMpfkNSJg1ymHxdJmcF1q6
        GhC5DpGyKVacaFG+XKu3MzK7CkXdd/c=
X-Google-Smtp-Source: AMsMyM6YIyrigCAhrxtC8TLi3THdusYlaVB9magdMAYYNjCg7nYwqJHCd71yRFHRUJNafYtneD8eTQ==
X-Received: by 2002:a05:600c:3b88:b0:3c6:cef8:8465 with SMTP id n8-20020a05600c3b8800b003c6cef88465mr29896271wms.64.1666273652289;
        Thu, 20 Oct 2022 06:47:32 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c092:600::2:93dd])
        by smtp.gmail.com with ESMTPSA id f7-20020adfc987000000b0022e04bfa661sm16520654wrh.59.2022.10.20.06.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Oct 2022 06:47:31 -0700 (PDT)
Message-ID: <d05e9a24-c02b-5f0d-e206-9053a786179e@gmail.com>
Date:   Thu, 20 Oct 2022 14:46:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: IORING_SEND_NOTIF_REPORT_USAGE (was Re: IORING_CQE_F_COPIED)
Content-Language: en-US
To:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Dylan Yudaken <dylany@fb.com>
References: <4385ba84-55dd-6b08-0ca7-6b4a43f9d9a2@samba.org>
 <6f0a9137-2d2b-7294-f59f-0fcf9cdfc72d@gmail.com>
 <4bbf6bc1-ee4b-8758-7860-a06f57f35d14@samba.org>
 <cd87b6d0-a6d6-8f24-1af4-4b8845aa669c@gmail.com>
 <df47dbd0-75e4-5f39-58ad-ec28e50d0b9c@samba.org>
 <fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com>
 <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <acad81e4-c2ef-59cc-5f0c-33b99082d270@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/20/22 11:04, Stefan Metzmacher wrote:
> Hi Pavel,
[...]
> 
> So far I came up with a IORING_SEND_NOTIF_REPORT_USAGE opt-in flag
> and the reporting is done in cqe.res with IORING_NOTIF_USAGE_ZC_USED (0x00000001)
> and/or IORING_NOTIF_USAGE_ZC_COPIED (0x8000000). So the caller is also
> able to notice that some parts were able to use zero copy, while other
> fragments were copied.

Are we really interested in multihoming and probably some very edge cases?
I'd argue we're not and it should be a single bool hint indicating whether
zc is viable or not. It can do more complex calculations _if_ needed, e.g.
looking inside skb's and figure out how many bytes were copied but as for me
it should better be turned into a single bool in the end. Could also be the
number of bytes copied, but I don't think we can't have the accuracy for
that (e.g. what we're going to return if some protocol duplicates an skb
and sends to 2 different devices or is processing it in a pipeline?)

So the question is what is the use case for having 2 flags?

btw, now we've got another example why the report flag is a good idea,
we can't use cqe.res unconditionally because we want to have a "one CQE
per request" mode, but it's fine if we make it and the report flag
mutually exclusive.


> I haven't tested it yet, but I want to post it early...
> 
> What do you think?

Keeping in mind potential backporting let's make it as simple and
short as possible first and then do optimisations on top.

> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index ab7458033ee3..751fc4eff8d1 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -296,10 +296,28 @@ enum io_uring_op {
>    *
>    * IORING_RECVSEND_FIXED_BUF    Use registered buffers, the index is stored in
>    *                the buf_index field.
> + *
> + * IORING_SEND_NOTIF_REPORT_USAGE
> + *                If SEND[MSG]_ZC should report
> + *                the zerocopy usage in cqe.res
> + *                for the IORING_CQE_F_NOTIF cqe.
> + *                IORING_NOTIF_USAGE_ZC_USED if zero copy was used
> + *                (at least partially).
> + *                IORING_NOTIF_USAGE_ZC_COPIED if data was copied
> + *                (at least partially).
>    */
>   #define IORING_RECVSEND_POLL_FIRST    (1U << 0)
>   #define IORING_RECV_MULTISHOT        (1U << 1)
>   #define IORING_RECVSEND_FIXED_BUF    (1U << 2)
> +#define IORING_SEND_NOTIF_REPORT_USAGE    (1U << 3)
> +
> +/*
> + * cqe.res for IORING_CQE_F_NOTIF if
> + * IORING_SEND_NOTIF_REPORT_USAGE was requested
> + */
> +#define IORING_NOTIF_USAGE_ZC_USED    (1U << 0)
> +#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
> +
> 
>   /*
>    * accept flags stored in sqe->ioprio
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 735eec545115..a79d7d349e19 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -946,9 +946,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> 
>       zc->flags = READ_ONCE(sqe->ioprio);
>       if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
> -              IORING_RECVSEND_FIXED_BUF))
> +              IORING_RECVSEND_FIXED_BUF |
> +              IORING_SEND_NOTIF_REPORT_USAGE))
>           return -EINVAL;
> -    notif = zc->notif = io_alloc_notif(ctx);
> +    notif = zc->notif = io_alloc_notif(ctx,
> +                       zc->flags & IORING_SEND_NOTIF_REPORT_USAGE);
>       if (!notif)
>           return -ENOMEM;
>       notif->cqe.user_data = req->cqe.user_data;
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index e37c6569d82e..3844e3c8ad7e 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -3,13 +3,14 @@
>   #include <linux/file.h>
>   #include <linux/slab.h>
>   #include <linux/net.h>
> +#include <linux/errqueue.h>

Is it needed?

>   #include <linux/io_uring.h>
> 
>   #include "io_uring.h"
>   #include "notif.h"
>   #include "rsrc.h"
> 
> -static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
> +static inline void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)

Let's remove this hunk with inlining and do it later

>   {
>       struct io_notif_data *nd = io_notif_to_data(notif);
>       struct io_ring_ctx *ctx = notif->ctx;
> @@ -21,20 +22,46 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
>       io_req_task_complete(notif, locked);
>   }
> 
> -static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
> -                      struct ubuf_info *uarg,
> -                      bool success)
> +static inline void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
> +                         struct ubuf_info *uarg,
> +                         bool success)

This one as well.


>   {
>       struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
>       struct io_kiocb *notif = cmd_to_io_kiocb(nd);
> 
>       if (refcount_dec_and_test(&uarg->refcnt)) {
> -        notif->io_task_work.func = __io_notif_complete_tw;
>           io_req_task_work_add(notif);
>       }
>   }
> 
> -struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
> +static void __io_notif_complete_tw_report_usage(struct io_kiocb *notif, bool *locked)

Just shove all that into __io_notif_complete_tw().

> +{
> +    struct io_notif_data *nd = io_notif_to_data(notif);
> +
> +    if (likely(nd->zc_used))
> +        notif->cqe.res |= IORING_NOTIF_USAGE_ZC_USED;
> +
> +    if (unlikely(nd->zc_copied))
> +        notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
> +
> +    __io_notif_complete_tw(notif, locked);
> +}
> +
> +static void io_uring_tx_zerocopy_callback_report_usage(struct sk_buff *skb,
> +                            struct ubuf_info *uarg,
> +                            bool success)
> +{
> +    struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
> +
> +    if (success && !nd->zc_used && skb)
> +        nd->zc_used = true;
> +    else if (unlikely(!success && !nd->zc_copied))
> +        nd->zc_copied = true;

It's fine but racy, so let's WRITE_ONCE() to indicate it.

> +
> +    io_uring_tx_zerocopy_callback(skb, uarg, success);
> +}
> +
> +struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx, bool report_usage)
>       __must_hold(&ctx->uring_lock)

And it's better to kill this argument and init zc_used/copied
unconditionally.

>   {
>       struct io_kiocb *notif;
> @@ -54,7 +81,14 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
>       nd = io_notif_to_data(notif);
>       nd->account_pages = 0;
>       nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
> -    nd->uarg.callback = io_uring_tx_zerocopy_callback;
> +    if (report_usage) {
> +        nd->zc_used = nd->zc_copied = false;
> +        nd->uarg.callback = io_uring_tx_zerocopy_callback_report_usage;
> +        notif->io_task_work.func = __io_notif_complete_tw_report_usage;
> +    } else {
> +        nd->uarg.callback = io_uring_tx_zerocopy_callback;
> +        notif->io_task_work.func = __io_notif_complete_tw;
> +    }
>       refcount_set(&nd->uarg.refcnt, 1);
>       return notif;
>   }
> @@ -66,7 +100,6 @@ void io_notif_flush(struct io_kiocb *notif)
> 
>       /* drop slot's master ref */
>       if (refcount_dec_and_test(&nd->uarg.refcnt)) {
> -        notif->io_task_work.func = __io_notif_complete_tw;
>           io_req_task_work_add(notif);
>       }
>   }
> diff --git a/io_uring/notif.h b/io_uring/notif.h
> index 5b4d710c8ca5..5ac7a2745e52 100644
> --- a/io_uring/notif.h
> +++ b/io_uring/notif.h
> @@ -13,10 +13,12 @@ struct io_notif_data {
>       struct file        *file;
>       struct ubuf_info    uarg;
>       unsigned long        account_pages;
> +    bool            zc_used;
> +    bool            zc_copied;

IIRC io_notif_data is fully packed in 6.1, so placing zc_{used,copied}
there might complicate backporting (if any). We can place them in io_kiocb
directly and move in 6.2. Alternatively account_pages doesn't have to be
long.

>   };
> 
>   void io_notif_flush(struct io_kiocb *notif);
> -struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx);
> +struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx, bool report_usage);
> 
>   static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
>   {
> 

-- 
Pavel Begunkov
