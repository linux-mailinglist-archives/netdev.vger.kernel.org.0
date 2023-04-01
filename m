Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4BC6D31D2
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 17:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjDAPE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 11:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjDAPE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 11:04:27 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A981BF72
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 08:04:25 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id i5so101140594eda.0
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 08:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680361463;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7fkds5lRhz1Hred/+whZlrNhXM3Fioq0vyxt4vGodlY=;
        b=OjbA3YOQ8uY5/DHPx+YQ84AyqhfytToS1R5CGesgvToD+8soKQhm2Ey1eW1/YWl8N+
         3ctl247SAz20KnZpVzsmG/1DDhrNmGqPGsITXOFvQUqaJomSn8NFBXJUDe2n6JhqV7Pf
         h0JVAbdS7YzQmJ4XgATYitVwelavd9U+vwEjQ/TlenOaa/tObxAbpgZ7ao/qVqmkS9OI
         QV52PICzl5XuinaHAB/Riv3breEsGa/W8Nc17dUaAtKlnkkPFL/MW/aO4WknJ7x0c7xK
         ol2ISg164kCNar9OGF763x70r5PH9frV9R2q5vmyNytN122NhbBTzLkCRkr5mDqNRK80
         nFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680361463;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7fkds5lRhz1Hred/+whZlrNhXM3Fioq0vyxt4vGodlY=;
        b=i6Yt53b1/TckLBbXuBB2wc1bjvciS7yS2hjFPPbljYuSYrZTJKjz995AUuI0kJu2P3
         p0MGiU+PjCkNqcWq9kkkppNZOFEJL0er+5HU0VAazs6ZR2anQe6fL+IIIiR0wC3rqWiA
         3mDk9a2mR+s47OZzpmM4g7YRj99xdA12I4UXUa2bwO+ik/W0Kx7EqmAKQNJrbPYNHAEt
         tLAHmbYUUo8TqQISo5VajHz95E65Ol5YvvtRTlBuF7CBg13YB3NBLsEjjqId2w1ZRkoN
         3rLEa4Hq7xWBLJy15BQh8KhDrudV+nx1xCaJNvYLjsArzNYVQ6bcD7Z3aiOnklU6oTh1
         6DGQ==
X-Gm-Message-State: AAQBX9cem2TKZ5IEfQ2tZRXgvGtaQQXtQWPV5MBxa6Ov7WU8Gt4DB7pC
        zsP+KmIKzNZrbMiTc9nx+RhZemqotRU=
X-Google-Smtp-Source: AKy350YlZv/EYXo+MzdS5QKo1RKe5X3DEEh3LaSr4WEVC0/2J8JnZQ2Q61TDTYZ8dzQfHbMyBPeWog==
X-Received: by 2002:a17:907:a808:b0:93f:fbe:c389 with SMTP id vo8-20020a170907a80800b0093f0fbec389mr27439681ejc.13.1680361463315;
        Sat, 01 Apr 2023 08:04:23 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bda6:2000:35bd:7a7:441f:cb1? (dynamic-2a01-0c23-bda6-2000-35bd-07a7-441f-0cb1.c23.pool.telefonica.de. [2a01:c23:bda6:2000:35bd:7a7:441f:cb1])
        by smtp.googlemail.com with ESMTPSA id fi11-20020a170906da0b00b0093a0e5977e2sm2167258ejb.225.2023.04.01.08.04.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Apr 2023 08:04:22 -0700 (PDT)
Message-ID: <5b997cab-d5ee-9772-7555-8d7e8eaccb16@gmail.com>
Date:   Sat, 1 Apr 2023 17:04:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
References: <20230401051221.3160913-1-kuba@kernel.org>
 <20230401051221.3160913-2-kuba@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
In-Reply-To: <20230401051221.3160913-2-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.04.2023 07:12, Jakub Kicinski wrote:
> A lot of drivers follow the same scheme to stop / start queues
> without introducing locks between xmit and NAPI tx completions.
> I'm guessing they all copy'n'paste each other's code.
> 
> Smaller drivers shy away from the scheme and introduce a lock
> which may cause deadlocks in netpoll.
> 
> Provide macros which encapsulate the necessary logic.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2:
>  - really flip the unlikely into a likely in __netif_tx_queue_maybe_wake()
>  - convert if / else into pre-init of _ret
> v1: https://lore.kernel.org/all/20230322233028.269410-1-kuba@kernel.org/
>  - perdicate -> predicate
>  - on race use start instead of wake and make a note of that
>    in the doc / comment at the start
> rfc: https://lore.kernel.org/all/20230311050130.115138-1-kuba@kernel.org/
> ---
>  include/net/netdev_queues.h | 167 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 167 insertions(+)
>  create mode 100644 include/net/netdev_queues.h
> 
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> new file mode 100644
> index 000000000000..d050eb5e5bea
> --- /dev/null
> +++ b/include/net/netdev_queues.h
> @@ -0,0 +1,167 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_NET_QUEUES_H
> +#define _LINUX_NET_QUEUES_H
> +
> +#include <linux/netdevice.h>
> +
> +/* Lockless queue stopping / waking helpers.
> + *
> + * These macros are designed to safely implement stopping and waking
> + * netdev queues without full lock protection. We assume that there can
> + * be no concurrent stop attempts and no concurrent wake attempts.
> + * The try-stop should happen from the xmit handler*, while wake up
> + * should be triggered from NAPI poll context. The two may run
> + * concurrently (single producer, single consumer).
> + *
> + * All descriptor ring indexes (and other relevant shared state) must
> + * be updated before invoking the macros.
> + *
> + * * the try-stop side does not reschedule Tx (netif_tx_start_queue()
> + *   instead of netif_tx_wake_queue()) so uses outside of the xmit
> + *   handler may lead to bugs
> + */
> +
> +#define netif_tx_queue_try_stop(txq, get_desc, start_thrs)		\
> +	({								\
> +		int _res;						\
> +									\
> +		netif_tx_stop_queue(txq);				\
> +									\
> +		smp_mb();						\

Wouldn't a smp_mb__after_atomic() be sufficient here, because netif_tx_stop_queue()
includes a set_bit()? At least on X86 this would result in a no-op.

> +									\
> +		/* We need to check again in a case another		\
> +		 * CPU has just made room available.			\
> +		 */							\
> +		_res = 0;						\
> +		if (unlikely(get_desc >= start_thrs)) {			\
> +			netif_tx_start_queue(txq);			\
> +			_res = -1;					\
> +		}							\
> +		_res;							\
> +	})								\
> +
> +/**
> + * netif_tx_queue_maybe_stop() - locklessly stop a Tx queue, if needed
> + * @txq:	struct netdev_queue to stop/start
> + * @get_desc:	get current number of free descriptors (see requirements below!)
> + * @stop_thrs:	minimal number of available descriptors for queue to be left
> + *		enabled
> + * @start_thrs:	minimal number of descriptors to re-enable the queue, can be
> + *		equal to @stop_thrs or higher to avoid frequent waking
> + *
> + * All arguments may be evaluated multiple times, beware of side effects.
> + * @get_desc must be a formula or a function call, it must always
> + * return up-to-date information when evaluated!
> + * Expected to be used from ndo_start_xmit, see the comment on top of the file.
> + *
> + * Returns:
> + *	 0 if the queue was stopped
> + *	 1 if the queue was left enabled
> + *	-1 if the queue was re-enabled (raced with waking)
> + */
> +#define netif_tx_queue_maybe_stop(txq, get_desc, stop_thrs, start_thrs)	\
> +	({								\
> +		int _res;						\
> +									\
> +		_res = 1;						\
> +		if (unlikely(get_desc < stop_thrs))			\
> +			_res = netif_tx_queue_try_stop(txq, get_desc,	\
> +						       start_thrs);	\
> +		_res;							\
> +	})								\
> +
> +#define __netif_tx_queue_try_wake(txq, get_desc, start_thrs, down_cond) \

Maybe I miss something, but: Why the get_desc and start_thrs parameters
if they aren't used?

> +	({								\
> +		int _res;						\
> +									\
> +		/* Make sure that anybody stopping the queue after	\
> +		 * this sees the new next_to_clean.			\
> +		 */							\
> +		smp_mb();						\
> +		_res = 1;						\
> +		if (unlikely(netif_tx_queue_stopped(txq)) && !(down_cond)) { \
> +			netif_tx_wake_queue(txq);			\
> +			_res = 0;					\
> +		}							\
> +		_res;							\
> +	})
> +
> +#define netif_tx_queue_try_wake(txq, get_desc, start_thrs)		\
> +	__netif_tx_queue_try_wake(txq, get_desc, start_thrs, false)
> +
> +/**
> + * __netif_tx_queue_maybe_wake() - locklessly wake a Tx queue, if needed
> + * @txq:	struct netdev_queue to stop/start
> + * @get_desc:	get current number of free descriptors (see requirements below!)
> + * @start_thrs:	minimal number of descriptors to re-enable the queue
> + * @down_cond:	down condition, predicate indicating that the queue should
> + *		not be woken up even if descriptors are available
> + *
> + * All arguments may be evaluated multiple times.
> + * @get_desc must be a formula or a function call, it must always
> + * return up-to-date information when evaluated!
> + *
> + * Returns:
> + *	 0 if the queue was woken up
> + *	 1 if the queue was already enabled (or disabled but @down_cond is true)
> + *	-1 if the queue was left stopped
> + */
> +#define __netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, down_cond) \
> +	({								\
> +		int _res;						\
> +									\
> +		_res = -1;						\
> +		if (likely(get_desc > start_thrs))			\
> +			_res = __netif_tx_queue_try_wake(txq, get_desc,	\
> +							 start_thrs,	\
> +							 down_cond);	\
> +		_res;							\
> +	})
> +
> +#define netif_tx_queue_maybe_wake(txq, get_desc, start_thrs)		\
> +	__netif_tx_queue_maybe_wake(txq, get_desc, start_thrs, false)
> +
> +/* subqueue variants follow */
> +
> +#define netif_subqueue_try_stop(dev, idx, get_desc, start_thrs)		\
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq = netdev_get_tx_queue(dev, idx);			\
> +		netif_tx_queue_try_stop(txq, get_desc, start_thrs);	\
> +	})
> +
> +#define netif_subqueue_maybe_stop(dev, idx, get_desc, stop_thrs, start_thrs) \
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq = netdev_get_tx_queue(dev, idx);			\
> +		netif_tx_queue_maybe_stop(txq, get_desc,		\
> +					  stop_thrs, start_thrs);	\
> +	})
> +
> +#define __netif_subqueue_try_wake(dev, idx, get_desc, start_thrs, down_cond) \
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq = netdev_get_tx_queue(dev, idx);			\
> +		__netif_tx_queue_try_wake(txq, get_desc,		\
> +					  start_thrs, down_cond);	\
> +	})
> +
> +#define netif_subqueue_try_wake(dev, idx, get_desc, start_thrs)		\
> +	__netif_subqueue_try_wake(dev, idx, get_desc, start_thrs, false)
> +
> +#define __netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs, down_cond) \
> +	({								\
> +		struct netdev_queue *txq;				\
> +									\
> +		txq = netdev_get_tx_queue(dev, idx);			\
> +		__netif_tx_queue_maybe_wake(txq, get_desc,		\
> +					    start_thrs, down_cond);	\
> +	})
> +
> +#define netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs)	\
> +	__netif_subqueue_maybe_wake(dev, idx, get_desc, start_thrs, false)
> +
> +#endif

