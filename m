Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1EB36ECF3
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 17:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbhD2PFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 11:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbhD2PFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 11:05:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66392C06138B;
        Thu, 29 Apr 2021 08:04:54 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n4-20020a05600c4f84b029013151278decso11014043wmq.4;
        Thu, 29 Apr 2021 08:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3d76vX4kuWTUOcufdr1MTpnOOHbzBsWhZKuDv7dL6z0=;
        b=WSs6V71w5Kv4cPLzq5kagQMkJyOQtS9DvfjL7k1+OsXVK1njQeiO7ylw1EG/7s4jiY
         GTBpn6AEOIApk+9ZutVXgHEnjVBQ2cXJJ3ed6ZEVX6c7Dgm/bTT+N3AdTCEKsgF3+SIq
         qA+SPPVR0nR9bT4K/coa3qoclC0iiB11hwp3nzmMEMbEf2e2HVtYtZquCgwzHnvs/uWj
         Y9KXyuAmXpMng91RDA1judcuQeroqc5r8jQKTnl7iW5MXyuKsWK+ejXd8D51epkbvTAh
         fNA3EjjOl4or+FZsWu/KQNqFOqpHG/6JBmRpeDVzdEHGwWgXa2pxNE0+Fl14spdz6wSv
         1d8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3d76vX4kuWTUOcufdr1MTpnOOHbzBsWhZKuDv7dL6z0=;
        b=PclqrAI4ZFn+L+sWwdtGBtKNpVLzOKqg3lMYhTDPnhGLwi9d26AiegyR0BH4ihjuJW
         i12V4W+6qSxJRuvcmvM54v+hoo7qF3G/dCisD5KpyHZU087XDYBeZVsYKs0YU2VBZT0W
         s7yOUxP7lRwKOdG3VA42g+R+dVYajob/8KvuWvS4YO1tU0q74jckFlds1642XpB6dnuD
         YfK1ZZC6JFcPEezv2fvz7r1rqyNK3vUHrdGldmso9mtnSJA16i7Lk9HlHYXp4tNC6NLT
         HRXek1QImFqJnVEiILOGFc/lJRFfpvhrSwhE3KNJ4jLWIzlnlO4OjkBv/g5PPSDrK3yS
         UFgg==
X-Gm-Message-State: AOAM530cuTcbSqSX6zMTx0hTdqp0AVKvp2+5ybYk0SLfvwaOuQic5lo4
        bAEXFVbTwPHlg6FKmmOuoqXq0nUyGDCmmw==
X-Google-Smtp-Source: ABdhPJwcUymh02+33Kvx4H86bFTO0juehMkFrKkfU0qMI7cgMR+xMKbHkmP8f1oApNvi9N/JpYhhtQ==
X-Received: by 2002:a05:600c:b4b:: with SMTP id k11mr503864wmr.180.1619708693183;
        Thu, 29 Apr 2021 08:04:53 -0700 (PDT)
Received: from [192.168.1.122] (cpc159425-cmbg20-2-0-cust403.5-4.cable.virginm.net. [86.7.189.148])
        by smtp.gmail.com with ESMTPSA id c8sm986314wrx.4.2021.04.29.08.04.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 08:04:52 -0700 (PDT)
Subject: Re: [PATCH] sfc: adjust efx->xdp_tx_queue_count with the real number
 of initialized queues
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     habetsm.xilinx@gmail.com, "David S. Miller" <davem@davemloft.net>,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>, stable@vger.kernel.org
References: <20210427210938.661700-1-ignat@cloudflare.com>
 <a56546ee-87a1-f13d-8b2f-25497828f299@gmail.com>
 <CALrw=nF+rD+GdWAZndKGxTW4cpao+x2W0dvDfUacXjD=A5mCKA@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <f7951d69-0c67-7455-2b0c-530cb959bff5@gmail.com>
Date:   Thu, 29 Apr 2021 16:04:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <CALrw=nF+rD+GdWAZndKGxTW4cpao+x2W0dvDfUacXjD=A5mCKA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/04/2021 15:49, Ignat Korchagin wrote:
> On Thu, Apr 29, 2021 at 3:22 PM Edward Cree <ecree.xilinx@gmail.com> wrote:
>>
>> On 27/04/2021 22:09, Ignat Korchagin wrote:
>>> +     if (xdp_queue_number)
>> Wait, why is this guard condition needed?
>> What happens if we had nonzero efx->xdp_tx_queue_count initially, but we end up
>>  with no TXQs available for XDP at all (so xdp_queue_number == 0)?
>>
>> -ed
> 
> My thoughts were: efx->xdp_tx_queue_count is originally used to
> allocate efx->xdp_tx_queues.
> So, if xdp_queue_number ends up being 0, we should keep
> efx->xdp_tx_queue_count positive not
> to forget to release efx->xdp_tx_queues (because most checks are
> efx->xdp_tx_queue_count && efx->xdp_tx_queues).
Well, we allocated it in this function, so could we not just free it
 (and NULL it) if we get here with xdp_queue_number == 0?
Assuming it even makes sense for those checks to be that conjunction,
 and not just efx->xdp_tx_queues.

> I'm not familiar enough with SFC internals to definitely say if it is
> even possible to have
> xdp_queue_number == 0 while having efx->xdp_tx_queue_count > 0
If it's possible for us to get xdp_queue_number != efx->xdp_tx_queue_count
 at all (which I can't remember exactly how it happens, but I think it's a
 case of not getting as many VIs back from firmware as we wanted, which
 happens after the initial determination of numbers of queues & channels),
 then it's possible that our number of available TXQs is reduced far
 enough that we don't have any left for XDP.
At least, I think so; this part of the driver confuses me too :S

-ed
