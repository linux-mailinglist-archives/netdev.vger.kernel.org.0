Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456402F21E2
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 22:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730893AbhAKVgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 16:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbhAKVgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 16:36:41 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DAEC061786;
        Mon, 11 Jan 2021 13:36:00 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id d26so247891wrb.12;
        Mon, 11 Jan 2021 13:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:subject:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JjhX+TMUEJN1XvProD26j5/JejgcKCm/i/sK2lOcnvk=;
        b=gbuZuqib606BmRbnJWObIfxMPb/hm83LrUIPbHo2kk8Ct3ps306mxAM/5Go2sfuESr
         Z9gUv5yHCIJadsOex7tmNTCuJVglZEVSoRr4PIZUrSEASmwvlVQjvAOuxIP5VQM55oTr
         /OZC6dVhSOavZMlYuNwf8q4ALHIP+aDH66onsZl6n31SmmtAKi0gVzA1lzhfbal+RGCN
         NbM2ni/kPftZNkITZSwk0ZBktb/6XWkkwiV0szX7qb3QKpIZfdnHcw8zoN738Mf5K/mt
         A5i8OTvx8O4EW4g7vraLkSM0PVCPuvxjyHqZKHE9PLJRTA/m8KCTio54HuPj1/uIqYs9
         rNXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JjhX+TMUEJN1XvProD26j5/JejgcKCm/i/sK2lOcnvk=;
        b=JsowEhnD/GoFL1/Wla5zag7nX1IJC5BzU5ZuE8hkjizgTZYAIZltXTOG17px3Ds3RE
         FiZqswtPafzdbZ37fhbkLhPWoRLd9OvgOnl6iQkx/nikT1XsNywQoW/UMyS6eXAMTkXn
         kr2FtFa4sli73iwDYlKneLiljPT6mpL+vVIiYMFHYrXe5nx1GGpxrqIknsa190a4+zU7
         QBJwZItN9OkdQyhHVZg44aelPvtLl4Yv2FfTetqxeHzThYoFK8gO6w9uUHwVZ7FRMBuU
         KHjsfB1ZYsDzQszN6A3y1o7wPLgh5A9Wwtma/5c6YQoI+tOqIeOMhl0hNlYZz3euYDeG
         2OKg==
X-Gm-Message-State: AOAM53182v4YiltU+obCFcBbW99tg7JQ5f03bYnLYaVtgjjtTDaHloVh
        Wi1+269th6xglBqvA0c5pNU=
X-Google-Smtp-Source: ABdhPJxKVSv0DdrJagzcdGXIj4f8cDmyg+28M0v95gXqEiBzxqfepXB4KE7PWXXraVlAuEnOfArupA==
X-Received: by 2002:a5d:6cad:: with SMTP id a13mr955104wra.275.1610400959259;
        Mon, 11 Jan 2021 13:35:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:7ca2:fb6:9bde:f4e5? (p200300ea8f0655007ca20fb69bdef4e5.dip0.t-ipconnect.de. [2003:ea:8f06:5500:7ca2:fb6:9bde:f4e5])
        by smtp.googlemail.com with ESMTPSA id j10sm869109wmj.7.2021.01.11.13.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 13:35:58 -0800 (PST)
To:     Paul Thomas <pthomas8589@gmail.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org
References: <CAD56B7fYivPF33BhXWDPskYqNE5jRxd-sA=6+ushNXhyiCrwiQ@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: net: macb: can macb use __napi_schedule_irqoff() instead of
 __napi_schedule()
Message-ID: <f3b0e354-9390-1ce8-6be5-b6ba9f201589@gmail.com>
Date:   Mon, 11 Jan 2021 22:35:54 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CAD56B7fYivPF33BhXWDPskYqNE5jRxd-sA=6+ushNXhyiCrwiQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.01.2021 20:45, Paul Thomas wrote:
> Hello, recently I was doing a lot of tracing/profiling to understand
> an issue we were having. Anyway, during this I ran across
> __napi_schedule_irqoff() where the comment in dev.c says "Variant of
> __napi_schedule() assuming hard irqs are masked".
> 
> It looks like the queue_writel(queue, IDR, bp->rx_intr_mask); call
> just before the __napi_schedule() call in macb_main.c is doing this
> hard irq masking? So could it change to be like this?
> 
It's unsafe under forced irq threading. There has been a number of
discussions about this topic in the past.

> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1616,7 +1623,7 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
> 
>                         if (napi_schedule_prep(&queue->napi)) {
>                                 netdev_vdbg(bp->dev, "scheduling RX softirq\n");
> -                               __napi_schedule(&queue->napi);
> +                               __napi_schedule_irqoff(&queue->napi);
>                         }
>                 }
> 
> -Paul
> 

