Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A9724E3FA
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 01:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgHUXky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 19:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgHUXkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 19:40:52 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1BFC061573
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 16:40:51 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id h12so1711664pgm.7
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 16:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6HL03UX4Gj87VyZdlLdiyRJmkp25AjPaPEQDReb2erg=;
        b=g5bj9XrE2HuLF5o1KwsYnRP6mgg1GEr1TJGZ5FCE6fekNP1wBm6M1aj/O9lbFPZw5c
         CLOPy6l5R9JU6MaKJe36zuMLgzeMEBjIFnCRW0/RAsYWbeq4r6fGISFa+iJh7Vou8nRQ
         6wFUCGb4y7PtL2CxR/Nhiuy8Yj6d/rSvTpbdrSAE3Yj/kcZS/oyQ+HYYE+w0E1By5Rme
         RPQzTkXQ53mHCtUmmQKEM7pRxJMGl62xhsbKu4aNu9d5o1DgF+Qe6TOjL8F94ChTvlZB
         Ni0uBAVXLuf4jSa1waxGPwQuQ9JHFoMbsYO6b/Rg3M0kQYRK8DUy7PCVJrJttYN7eR2i
         VuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6HL03UX4Gj87VyZdlLdiyRJmkp25AjPaPEQDReb2erg=;
        b=dLMHrmP8u4+K/aXSlWnmIXLqfY9ZXC56DKI4eVUrxiezrpFz/1KcsgORx3CowOPJ6g
         1s1S7LPUdgeHaFutQZWNWrR1bxv648EfEY5txXoU2IubVUr4B60qZFxiK8gwOjvMgIZm
         sJQTg69wY0w5uJ6ezyqhgpUOJlyTZvBe0ZEsThYL7iReoc5wA23a0+wNl+arf5v6tHUw
         6Wsk/2VB7tFXK0X/TskPvrqTMoyFT4A6oTrlHGlHRHCzTYQf/l1t/VvzYdRgP9i+qZ88
         R/u65xQF48qzcWtvaXCWEXftj1ChT9E7ebjWMM6yHKVt+v13zFmaI1RauHG2kTnL1GII
         q7PQ==
X-Gm-Message-State: AOAM530dR75zAjPDVElYFHZ4iKsQO2kT7MThMu7H+OvrflayuW2W5P9d
        RknYj8hauulZoMsd2+vFB8E=
X-Google-Smtp-Source: ABdhPJwEXj/cBFOx37G/FRP5aZdiLcXwQlEwtytbwAslKLjiOGj2ce3z/mTT6wp/lxCir+qvA0xtwQ==
X-Received: by 2002:aa7:96ef:: with SMTP id i15mr4443725pfq.231.1598053251245;
        Fri, 21 Aug 2020 16:40:51 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id t2sm3710886pfb.123.2020.08.21.16.40.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 16:40:50 -0700 (PDT)
Subject: Re: [PATCH] net: Get rid of consume_skb when tracing is off
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Neil Horman <nhorman@tuxdriver.com>
References: <20200821222329.GA2633@gondor.apana.org.au>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5d9b715e-d213-8e82-1a68-aee24c3b589d@gmail.com>
Date:   Fri, 21 Aug 2020 16:40:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200821222329.GA2633@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/21/20 3:23 PM, Herbert Xu wrote:
> The function consume_skb is only meaningful when tracing is enabled.
> This patch makes it conditional on CONFIG_TRACEPOINTS.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 


I am not completely familiar with CONFIG_TRACEPOINTS

Is "perf probe" support requiring it ?

We want the following to be supported.

perf probe consume_skb


