Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DE72295DE
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 12:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731903AbgGVKVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 06:21:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727034AbgGVKVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 06:21:01 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D4A2C0619DE
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 03:21:01 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id x9so827361ila.3
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 03:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=PkgNjuH0re4Q7qPeSybNSLCmblxEadw0kOBtvVg3X1I=;
        b=oyw4eWd+Fb2mw9IxPseZ32QSlljL3Ww2mivGyJdH0RTmv4IVSRCkQ20tsZY504IGGg
         z0x0Bfn13NyfcR7nEZZaPFFCaqB/1jYE+CUEx1rZGOVh/7Z8c3eqM7Bap4mHvyg3kTLz
         llI7vmSIIR1gJux2u4qZ93GLnndLdBQ3xZIAR0jFR3QxAXBrq8Jd8yc6Uik559N9J216
         jKPJVLXReOynXPnbSSmBnLKZv9y+yFOqdFt7aJux4iIbdQSdIsgBZ2N7eLim/yBedltT
         nJl0WuGf8xAyIWFZBG0atg3q38cF79S5xBf9BBNrapUm38B6NRuCBRZbdBaozQHNIsFM
         lCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=PkgNjuH0re4Q7qPeSybNSLCmblxEadw0kOBtvVg3X1I=;
        b=t0vkccBYXoXfPlrFAv9lzcdlznZUiNgkTh9zbOvorykiyMuwJ0oYdL8H4ARHFbLjWD
         4HR+ZqHbTAEsI0KDt++3AkKmmg+yrXpTYa/Jrw7Tq5jjtYr+XL3CNpy5HCXlhujrYD2c
         WTQwrOQE5vN1l5YR5PSyemtjriVoJFpji4yE7HV4gyo4kAqId4qep/Xq5oAmJAUyyE+5
         g/Sy+Oli2UhqByPUq3/BpgskDWet95V7/ryR6NTr1g6HFJd53irnvb3SLplgTAvnGHzY
         3mof2Xa8ZZBIGjyZxdDAnv3aYq4DFHBE4IAo/LTKD5V9PNnJ1U3Kzaf2zs3JtBJKdJiX
         fKiA==
X-Gm-Message-State: AOAM53393LiXavt5P0ylcQ96zfeFKsOAxA6wV7mT+LdAxFSJlMu0tbe6
        JhGBH5nl1vjEaH82N8eKqMFcrg==
X-Google-Smtp-Source: ABdhPJx3gcQCFnXkbqf9RYJ79qKVem/VXm4+g5TjUOPMGb0VCOTAMwkwmX8poBZgDaKWgUu1s8Yqcw==
X-Received: by 2002:a92:8451:: with SMTP id l78mr32782711ild.234.1595413260592;
        Wed, 22 Jul 2020 03:21:00 -0700 (PDT)
Received: from nebulus.mtv.corp.google.com ([2620:15c:211:0:4a0f:cfff:fe35:d61b])
        by smtp.googlemail.com with ESMTPSA id z4sm2685899ilq.25.2020.07.22.03.20.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 03:21:00 -0700 (PDT)
Subject: Re: af_key: pfkey_dump needs parameter validation
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20200721132358.966099-1-salyzyn@android.com>
 <20200722093318.GO20687@gauss3.secunet.de>
From:   Mark Salyzyn <salyzyn@android.com>
Message-ID: <2ae16588-2972-a797-9310-4f9d56b7348b@android.com>
Date:   Wed, 22 Jul 2020 03:20:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200722093318.GO20687@gauss3.secunet.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 2:33 AM, Steffen Klassert wrote:
> On Tue, Jul 21, 2020 at 06:23:54AM -0700, Mark Salyzyn wrote:
>> In pfkey_dump() dplen and splen can both be specified to access the
>> xfrm_address_t structure out of bounds in__xfrm_state_filter_match()
>> when it calls addr_match() with the indexes.  Return EINVAL if either
>> are out of range.
>>
>> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: kernel-team@android.com
>> ---
>> Should be back ported to the stable queues because this is a out of
>> bounds access.
> Please do a v2 and add a proper 'Fixes' tag if this is a fix that
> needs to be backported.
>
> Thanks!

Confused because this code was never right? From 2008 there was a 
rewrite that instantiated this fragment of code so that it could handle 
continuations for overloaded receive queues, but it was not right before 
the adjustment.

Fixes: 83321d6b9872b94604e481a79dc2c8acbe4ece31 ("[AF_KEY]: Dump SA/SP 
entries non-atomically")

that is reaching back more than 12 years and the blame is poorly aimed 
AFAIK.

Sincerely -- Mark Salyzyn

