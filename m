Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE7052C931
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 03:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiESBWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 21:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiESBWu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 21:22:50 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5BF6D1B8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 18:22:48 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id p74so668739iod.8
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 18:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bMllE0YLxhmVO+VNKdUselPcHgXb5yforOCYNbGxW3o=;
        b=T+ZPExuNiB56mAUW40HcVPnwFLRx9v0m6xRSwKcBxmA6hrLtz6wBrYJN7nU0enyT9K
         2PHGa1V2xGt3JzAjc86pb4vo7EooWhjONXxkEd8UFXq7taL+2Kb8v2d+7tHFFId6+MgI
         kErioyyCNs0XMRe/wv8zvYbN6dUjDyivY7aNQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bMllE0YLxhmVO+VNKdUselPcHgXb5yforOCYNbGxW3o=;
        b=TejvQmST86LGS2XPJxouwixebnKhmVqmr/mAVNela1gLpzHORbS9FPEoizQw809wMJ
         8WBFrfVxeAWHTFHoEu2ylJ4Fvbce5SlYuQZcRlxLWpWIfoNZGjmBayQMbqCg1y8SO7Il
         MxPzvKcpMYcJS1doPB4UWNZbIhF+xEu+11kB7O25LWYBSBdQK0lrq4/vHVppzhrxp/WO
         AGTJgLobAG0BYUsj8EmawMocpB7Nw8pbBQyXu3TTHsdeDDeYDa90KJCsM9/3zkoGg0WQ
         vVGuMjA+XgKwYtfLTiX/RjDjAXrOudARdxHyP8mCKs1+IkpNplQACPxq+h0mX7vrkSkS
         dnuw==
X-Gm-Message-State: AOAM532ATDJU/5CPaxswp0p+Q+WkikR2WDUYoKPgcho8qXcjc0xt7JIx
        wZKfedkfP6mT+uEe2zAqjEuf9A==
X-Google-Smtp-Source: ABdhPJwMBgl7mJ7nt1XzegWRztORPT7g4sl2tPBze8YQ8TaUqxHlul0nxffGeI3irEEMMpKUqKhFww==
X-Received: by 2002:a05:6602:15d0:b0:65a:a94e:8814 with SMTP id f16-20020a05660215d000b0065aa94e8814mr1251741iow.11.1652923368081;
        Wed, 18 May 2022 18:22:48 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id r23-20020a6b5d17000000b006050cababc5sm349617iob.0.2022.05.18.18.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 18:22:47 -0700 (PDT)
Message-ID: <c7ad27bf-1bd7-86d5-8f22-c0cbc38ebda1@ieee.org>
Date:   Wed, 18 May 2022 20:22:46 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next] net: ipa: don't proceed to out-of-bound write
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        elder@kernel.org
References: <20220519004417.2109886-1-kuba@kernel.org>
From:   Alex Elder <elder@ieee.org>
In-Reply-To: <20220519004417.2109886-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/22 7:44 PM, Jakub Kicinski wrote:
> GCC 12 seems upset that we check ipa_irq against array bound
> but then proceed, anyway:
> 
> drivers/net/ipa/ipa_interrupt.c: In function ‘ipa_interrupt_add’:
> drivers/net/ipa/ipa_interrupt.c:196:27: warning: array subscript 30 is above array bounds of ‘void (*[30])(struct ipa *, enum ipa_irq_id)’ [-Warray-bounds]
>    196 |         interrupt->handler[ipa_irq] = handler;
>        |         ~~~~~~~~~~~~~~~~~~^~~~~~~~~
> drivers/net/ipa/ipa_interrupt.c:42:27: note: while referencing ‘handler’
>     42 |         ipa_irq_handler_t handler[IPA_IRQ_COUNT];
>        |                           ^~~~~~~
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Well, that's a reasonable thing to complain about.  I think when
I switched to using these WARN*() calls Leon said testing the
return value was unusual in the networking code.

In any case, this is a good fix.  The problem won't happen
anyway, so silencing the error this way is just fine.

Reviewed-by: Alex Elder <elder@linaro.org>

> ---
> CC: elder@kernel.org
> ---
>   drivers/net/ipa/ipa_interrupt.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
> index b35170a93b0f..307bed2ee707 100644
> --- a/drivers/net/ipa/ipa_interrupt.c
> +++ b/drivers/net/ipa/ipa_interrupt.c
> @@ -191,7 +191,8 @@ void ipa_interrupt_add(struct ipa_interrupt *interrupt,
>   	struct ipa *ipa = interrupt->ipa;
>   	u32 offset;
>   
> -	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
> +	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
> +		return;
>   
>   	interrupt->handler[ipa_irq] = handler;
>   
> @@ -208,7 +209,8 @@ ipa_interrupt_remove(struct ipa_interrupt *interrupt, enum ipa_irq_id ipa_irq)
>   	struct ipa *ipa = interrupt->ipa;
>   	u32 offset;
>   
> -	WARN_ON(ipa_irq >= IPA_IRQ_COUNT);
> +	if (WARN_ON(ipa_irq >= IPA_IRQ_COUNT))
> +		return;
>   
>   	/* Update the IPA interrupt mask to disable it */
>   	interrupt->enabled &= ~BIT(ipa_irq);

