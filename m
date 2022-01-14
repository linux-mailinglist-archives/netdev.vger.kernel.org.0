Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F7D48E347
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 05:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239155AbiANEaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 23:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbiANEaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 23:30:04 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A315AC061574;
        Thu, 13 Jan 2022 20:30:04 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id h23so10986241iol.11;
        Thu, 13 Jan 2022 20:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QytipBfsQBns2WRd2Yb0XfQLH0+kyvtCcIoi6sIqkJ4=;
        b=SMVaSVH7HbN62VgDLbaKPeMgz/nNzM96EnzJ7pfCfsH8wB21VHoAavj09rBXU0FaRw
         vF5z8RVoc2rgdQM2yBJnf7iRMYD+9zFP70dHdbEIGVYuzwyvCmWKuaJg9gi2UaWO2rjo
         wp9HnmTiDayBZc8EUFshgien7+abAWzmT9p/gLKuoM2qZrM7KMiBcHDxUIbbLTBHEQyU
         sJUUQcSpmJvQ5oFSKNZ01FG3Xfh4yH0zQyuBlRD2yCmaJYe1Y2b6SNwHyFO6tMJQTnRS
         rgkjFCF22GO/zcla/SDu8CZ001drV1N64KfZXEKOsuz776QhTrLDMVoSLPRjqlBC+rUS
         2MZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QytipBfsQBns2WRd2Yb0XfQLH0+kyvtCcIoi6sIqkJ4=;
        b=yGfkKrPrbQ/5e2WfFVBGWkOrPKspgG+j2dq4G2UVClO+MqtfUfYhVAHCANvl6/x6ZH
         YeK9V7CFXQrvJCMRWx5/6MydP1gTROYORQgTqCDNcWmh1KMTCWD+7GwxmLkY5yNJTsYp
         8b5vv94U+uVuUcCr3qL9GEi9n+uQtA+yLQEJJG6XeEKkMZIgcBj8r/78IB0Ik4qleBga
         qBnmXG+RfAGtGqeRiCEOcYXywobPsw7yM4IcNMw9SQXOk8ij0ccMuttnNlZoCSNJaAz8
         dsIkocOC56iQtQaT3W1F/NpH3R3vU/AmQtauT1xQlVDqFMOwFV7vXIpiVMwrrp23QrCF
         /Zvw==
X-Gm-Message-State: AOAM530qRFmdmKJy8ImC76GWr1FVKAKh/FVy92c+4ntde6AaK9/JP3g+
        sb2m0Xf7f+VJg0hD1uBqPVUFsX5pgas=
X-Google-Smtp-Source: ABdhPJyLzIDNY+70gOmfgSgl1Y6mccID6Tq7RrYVuu6rDm6r0Uwo3JE0gH4aLYkHvpWeQYqDNDvx6w==
X-Received: by 2002:a05:6638:a33:: with SMTP id 19mr1710902jao.257.1642134604105;
        Thu, 13 Jan 2022 20:30:04 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id y15sm4530295iow.44.2022.01.13.20.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jan 2022 20:30:03 -0800 (PST)
Message-ID: <b4363fb0-a837-f452-8abe-549f4568f38a@gmail.com>
Date:   Thu, 13 Jan 2022 21:30:02 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH] ipv6: ICMPV6: Use swap() instead of open coding it
Content-Language: en-US
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220113161731.130554-1-jiapeng.chong@linux.alibaba.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220113161731.130554-1-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/22 9:17 AM, Jiapeng Chong wrote:
> Clean the following coccicheck warning:
> 
> ./net/ipv6/icmp.c:348:25-26: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  net/ipv6/icmp.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 

looks fine to me but net-next is closed; resubmit when it opens.

Also, you need to add the tree to the subject line so in this case:

[PATCH net-next] ipv6: ICMPV6: Use swap() instead of open coding it
