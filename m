Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC1AB6D31F1
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 17:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjDAPSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 11:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbjDAPST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 11:18:19 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0551D2DC
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 08:18:17 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id t10so100868078edd.12
        for <netdev@vger.kernel.org>; Sat, 01 Apr 2023 08:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680362296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZNOCNVSqqahh/tPEz2QLxtiwYfWMNUjx1TNpicPz0Ak=;
        b=mfqN+XrdHNPVvt5JZHCMWwBGnAHELtvSe0tSU+MagF/uqnzpVdQ148fp+qcUc+mXlT
         BBY2z2O0n/O3++VOjV/tQC780ruyEN+i5OrXG0674TkUOShgM5PAW5uQbr+QQrlPuVL5
         pa76DoTnJYHs/my5Tj0lmz5JkEvxbVcvD6rZV1rK5fD52ILgXvLwVuctE+8eNiAg7QL1
         23kN35R4YgxuTQBAJGXeH3oAT4loE6OwlxM7OZQEyYA1fRTwlBr1GpI8Bytiuhn+9SRm
         1e2MOcQF2RcmwE30r5YDrfC2huTLumEeR5b5a2fiJiZLe7pgjT+nJiKHXnqDNc1pdxKO
         8RwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680362296;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZNOCNVSqqahh/tPEz2QLxtiwYfWMNUjx1TNpicPz0Ak=;
        b=L8clenxp0X5wTp2EA5VdXme8Ov7HvNEDqbwnV+2eIL0Ow+p0TWAclHJH6N7Oe68ls+
         7B3nbJBnFaXUF4ZDKNPhgVkKe+OVeitnQIS8sHsUZwwIgUcgHZdXVdjjhDS7hcYZLsBK
         a2hMD2F5isc86R3/mlur3Wv2mEBLyv3sDHOIZt1cKRmBy1UD6VGke7EAoZqwvG8OHudz
         SvEcrO8hV4lSljlQW0u9dFCY1Fzb/ykrlDhadIo8NoWcYoeFUtCEvElNhfqfBGfuhXv7
         rbHQRGH/2GHB4Q4mOOOzkC6R+P6vIMQJmc0E3VEOP8BcsnSIWuer84+30MN5dl71O9xf
         v6Ew==
X-Gm-Message-State: AAQBX9cFsbCu3CIeX+h/ahQSKA4BNHv1NpCU7Ewmxan0ePZk9apVLjUl
        qfHzootDylUK60GLKmrdkTg=
X-Google-Smtp-Source: AKy350ZrNXkbWZg9026lSoe9c55stE12yjXT+bW6tGwLqWy/w8ORJTGs+xkq1ZUxkFXe5L66tkYFMQ==
X-Received: by 2002:a17:906:b049:b0:937:9a24:370b with SMTP id bj9-20020a170906b04900b009379a24370bmr31359539ejb.67.1680362296263;
        Sat, 01 Apr 2023 08:18:16 -0700 (PDT)
Received: from ?IPV6:2a01:c23:bda6:2000:35bd:7a7:441f:cb1? (dynamic-2a01-0c23-bda6-2000-35bd-07a7-441f-0cb1.c23.pool.telefonica.de. [2a01:c23:bda6:2000:35bd:7a7:441f:cb1])
        by smtp.googlemail.com with ESMTPSA id a22-20020a17090682d600b0092c8da1e5ecsm2184453ejy.21.2023.04.01.08.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Apr 2023 08:18:15 -0700 (PDT)
Message-ID: <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
Date:   Sat, 1 Apr 2023 17:18:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
References: <20230401051221.3160913-1-kuba@kernel.org>
 <20230401051221.3160913-2-kuba@kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
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

One more question: Don't we need a read memory barrier here to ensure
get_desc is up-to-date?

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

