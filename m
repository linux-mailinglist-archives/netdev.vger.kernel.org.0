Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBB349FCCA
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349538AbiA1P3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349368AbiA1P3B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:29:01 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D3BC061714;
        Fri, 28 Jan 2022 07:29:01 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id p27so12549947lfa.1;
        Fri, 28 Jan 2022 07:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N4J//Mo9xUttrK0yF032bWbn0KZLi4C3IbfSaVZ898E=;
        b=nMCCJwPleajqB6C9nJrLYmYyxvYJDjsPBaeAckGvpvNJDlogXVNDX5CMorLz8EkXwK
         tOGGJLbUBQ5vVXgmuATMWVHVp6zRhthE/Z4c3fXvDzusCCvuSOLi2PeQqPPynXDiEqJa
         wpkWD/KytYGfhbLSPodHYTZ193CEPYVnW8yYjqop2VUUI19OJJSNODw9+MHhdzD6OI8n
         reTz6lWlg50Q6pG/G+MdGVZEs7E/JstVtaC73N7E3+wALEq524Y3vPRmf0zJQjvvlg5R
         cR0EZAoEAIZxSDSUjdrrZQayHItW8C9PmvfUhNyD52CwO42YQFOTC1TF8xhvGNG+gp0E
         rLPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N4J//Mo9xUttrK0yF032bWbn0KZLi4C3IbfSaVZ898E=;
        b=ph2LkScdvjhnfKaTjEarW2R63Nvs8ycJqHuJIRLv5hUWHxGPa7c7gDEnwxsPW+UViA
         +f7GrCVyKklqPXeux47iYZoLQJhnxO7qeGsVsNpQNpw68eRm4ZsuwmAYQpjALWj+recc
         /lSmDgMhuXqo68QBjvJWU6ivOsYjb7U/BOwZyvJzhgQBCauAH3ux0HDQICP2lzB67YY7
         8ElHfICV9jXMbdCqSWvQKbWY7HkN/KPf0HNmr99kZvRnyVGcP2oKNBH1l/jujgaJRMMY
         N2sjGcsiU/ggS13Ciw3Sw2rTZxbR/T/8gzNUCJCWeQtVpOvIHcOsUidRvM7OqvjEDq0k
         xoBw==
X-Gm-Message-State: AOAM530RwKCIcHaPpXbjVRhkAtVBytlG62jJ7I3VQ3AREGp3y43wQ09m
        01HARGi5SDaXnCifDeKBaQo=
X-Google-Smtp-Source: ABdhPJyQ9v4PdBJzaie5bbiSmHbBxFsVgyJTcSUuDvUITdCGgIiqmLYFQd/isDs0HBzExLgZ/Z5wJg==
X-Received: by 2002:a05:6512:3a96:: with SMTP id q22mr6579539lfu.521.1643383739523;
        Fri, 28 Jan 2022 07:28:59 -0800 (PST)
Received: from [192.168.1.103] ([31.173.86.67])
        by smtp.gmail.com with ESMTPSA id z11sm2563451lfu.106.2022.01.28.07.28.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 07:28:58 -0800 (PST)
Subject: Re: [PATCH 4/7] mfd: hi6421-spmi-pmic: Use generic_handle_irq_safe().
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20220127113303.3012207-1-bigeasy@linutronix.de>
 <20220127113303.3012207-5-bigeasy@linutronix.de>
 <44b42c37-67a4-1d20-e2ff-563d4f9bfae2@gmail.com>
 <YfPwqfmrWEPm/9K0@google.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <0daa924f-790c-cdc7-a1c0-4eb91917e084@gmail.com>
Date:   Fri, 28 Jan 2022 18:28:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YfPwqfmrWEPm/9K0@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/22 4:33 PM, Lee Jones wrote:

>>> generic_handle_irq() is invoked from a regular interrupt service
>>> routing. This handler will become a forced-threaded handler on
>>
>>    s/routing/routine/?
>>
>>> PREEMPT_RT and will be invoked with enabled interrupts. The
>>> generic_handle_irq() must be invoked with disabled interrupts in order
>>> to avoid deadlocks.
>>>
>>> Instead of manually disabling interrupts before invoking use
>>> generic_handle_irq() which can be invoked with enabled and disabled
>>> interrupts.
>>>
>>> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>> [...]
>>
>> MBR, Sergey
> 
> What does that mean?

   That means that I think you had a typo in the word "routing".
The s/// comes from vim, I think --where it means search and replace.

MBR, Sergey
