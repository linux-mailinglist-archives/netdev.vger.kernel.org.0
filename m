Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B00946C049
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 17:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239410AbhLGQIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 11:08:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbhLGQIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 11:08:16 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C28C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 08:04:46 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso18676911otr.2
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 08:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TWGx7Q6J3sNy81S7J4IErwQKr1mXrEn52kS4U6z2fA4=;
        b=mqjnvKjv3LoZzeHXaXj4QE9ZAPQUKk1y2YeWrmFXzwACzvE4hcnHXyZpRtyzZB3QbR
         l+K5G6ybwkvWwwa+KER9kVBCy60ixPMYHrHct9LLW0yIkaes8sK57rSyRQg4RE20XA3n
         jwqvVniMpKLfj3kHyR0JTTXtjR3dgT8u/SxRmanIZabwOnbxT5d8y9aBRSTj6Tx+4AF1
         xrjI/zmFwxmyisMlUCtYsyv7G9UCI75leH/Nye0OmQX8aVz0jCBDlLLAqFIqT8HZauSJ
         x4jLXVrHcq7th59cT82NQrNWH4NITOGNVyjHIvWEHGLMnfvKW+PwQSEAqahzd71GreAg
         8Fyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TWGx7Q6J3sNy81S7J4IErwQKr1mXrEn52kS4U6z2fA4=;
        b=Aq+Ym4mCie2LSpV5zny3W9cn7rdMEIiKRb9OopqvT7GWDAqfyMTLhxFenr9BBdzHg+
         2+RM0vkPF7UjkwYV6RtEjp3KzlcSGuxBnm+KTUAsRk8Au7KZX1g4vXtz8mhwzcS5vqAH
         GaE9JwciBfCStIMBfV2YJYIa7+pZ1tl5W3pe4zhje8SdENNMH5JKoKNiA74EnPO9zGSu
         iRnDWJAiCA0tACfZYmrp5ptBfgjycjWAzjH9wfv4xijqNJmCE+YOHy0gbvAHaQDGV8lA
         g0t5CC7Llv0/nfsgmUFf4feC7GPRdGLybd85aZfI3N8WWjhdLInEfBh/avCsoQBKWAyx
         3DCg==
X-Gm-Message-State: AOAM5312anuW+yFob3EaW4X4BzI4UYcWWF1MqoEtFVxo9UEYskijfN4Z
        qMFcpYwkOFnGHQhv4y7pPuE=
X-Google-Smtp-Source: ABdhPJza89rIH69xnM4jKI3qHMXSItkUEUme5uOcQUUlkZtO1y5bsMKxHqRIELaQCGz9sM3LdLuhAw==
X-Received: by 2002:a05:6830:310f:: with SMTP id b15mr35853161ots.31.1638893085826;
        Tue, 07 Dec 2021 08:04:45 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id h6sm2820542otb.60.2021.12.07.08.04.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 08:04:45 -0800 (PST)
Message-ID: <24911380-995a-ece0-41ab-42f6ad6972ff@gmail.com>
Date:   Tue, 7 Dec 2021 09:04:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [PATCH net-next] vrf: use dev_replace_track() for better tracking
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
References: <20211207055603.1926372-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211207055603.1926372-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/21 10:56 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> vrf_rt6_release() and vrf_rtable_release() changes dst->dev
> 
> Instead of
> 
> dev_hold(ndev);
> dev_put(odev);
> 
> We should use
> 
> dev_replace_track(odev, ndev, &dst->dev_tracker, GFP_KERNEL);
> 
> If we do not transfer dst->dev_tracker to the new device,
> we will get warnings from ref_tracker_dir_exit() when odev
> is finally dismantled.
> 
> Fixes: 9038c320001d ("net: dst: add net device refcount tracking to dst_entry")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  drivers/net/vrf.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

