Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDDEC22F58C
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 18:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbgG0QmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 12:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgG0QmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 12:42:04 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF2FC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:42:04 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k1so9821760pjt.5
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 09:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oBlU0YbZsH/tzFMrRGuGOEiXmiNq6+dzGmr1J+E2sug=;
        b=AhmAo6nAXCm4oLyl9uaZ0PCrZnTtXRdJQgDR1hxuZ0FU4gTVVCJCq/q/dEXCMZfxaw
         YDwSiLHC6P6wfDO2NWe0utjXoJsEfUN7Y8m52Ez+ZXsuj54M5ROz2rMqArgvb0h11xnw
         Z/gAiqSqOhVsb6AL0vaUPDc9k2bEPrbzrTQwP7Oqe41zqQdvAczUXmXjlT+uS4Gu4P3j
         Ha8hf1wdRE18M9wWo3cGfN0QTvN8Dvj0kR77S1iMQF/U38fb+UaHmykDsrJHOwUq1Cgr
         o34hnVo1U7bTxMmmerkgGF1jsUMPjDOsroPIqojWhKnHoMo9P/YamrGBZw53vqiJo9WJ
         3juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oBlU0YbZsH/tzFMrRGuGOEiXmiNq6+dzGmr1J+E2sug=;
        b=N39HtCMquz5NRYsjCo9KS0sONsEUK3i3KAn+XfSt5QfILPa8SQzcB3k3Oqq/c+EFyY
         f8rADS4/m1GsDW5Wn29I4/4j67v+6+MtZ7YsqNQzgs6wlVBKw2s0CDlzqDvNnybVfAKH
         KpdonWjYkixut4U2ipxDNspJI0omMV3tfnwXjIKvEbsDRdHulis6K2rv9uerHBNMhk5w
         nk/JdTQnFp6m5qFtp5q16yDdWnqfdTCC4gBSg/AnFPLtepzTidE4pVGPkvWZ8Qmnw4tP
         TcDqeIbjUx9n1U4WOhQZaoDiiMqT62EBayv6TQ4MmgZgNJQWPHXgCQGMVfUPkUoVQCDn
         q62w==
X-Gm-Message-State: AOAM5335nwpNtFN9k7iALVC0/DzJV8/PGlkeWHvOAKb5bfrMBRoIlI3S
        E/YFV8zegV+rLivvku5WRL2zVJ6fHhw=
X-Google-Smtp-Source: ABdhPJz4wZesoFdadG0zIat2wiUQVvfLcP1aDA2k0Tpe1UkLV/h1HcfrIFBj/jbHkLmBfC6/mWQzAA==
X-Received: by 2002:a17:90a:8d06:: with SMTP id c6mr136080pjo.137.1595868123657;
        Mon, 27 Jul 2020 09:42:03 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id t63sm1472748pfb.210.2020.07.27.09.42.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2020 09:42:03 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] ionic: recover from ringsize change failure
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200725002326.41407-1-snelson@pensando.io>
 <20200725002326.41407-3-snelson@pensando.io>
 <20200724.194417.2151242753657227232.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <5cf99807-2362-cec0-dbad-8f23ba627b04@pensando.io>
Date:   Mon, 27 Jul 2020 09:42:00 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200724.194417.2151242753657227232.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/24/20 7:44 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Fri, 24 Jul 2020 17:23:24 -0700
>
>> If the ringsize change fails, try restoring the previous setting.
>>
>> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> You really can't recover properly, or reliably, with the way all of this
> is structured in the ionic driver.  This is at best a half attempt at
> error recovery.
>
> Doing a full ionic_open() call abstracts things too heavily.
>
> What you need to do is save away the current queue memory and object,
> without freeing them, and only release them when you can successfully
> setup the new queues.
>
> This is the only way you can properly recover from errors in this
> operation, with a proper check/commit sequence.
>
> I'd rather not merge half solutions to this problem, sorry.

Sure, thanks anyway.
sln

