Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08785434FE8
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhJTQQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbhJTQQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:16:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D70B7C061760;
        Wed, 20 Oct 2021 09:14:28 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id c29so3381150pfp.2;
        Wed, 20 Oct 2021 09:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xJAElodWUEbJrINM9N/fL8JP3Jfud76GbQ+m80oxwfU=;
        b=eXyMZqCHl1gQkYmGZO4EEANXNwks7Bpsxxdn9kn4t+6M342wzlyzpdBb5KXbTuFviR
         jvjdugsW+XijAazAhHQCxOxPNzil753Fb3Q4t9ZBor4halCYQ/IvpOtay9d0ZJrqrvTe
         V8CYtpLEBpS9w3uHGHbvQOMZptTvPVRfMC5tO8VmKhATtS4Lp1GQxxfkp50OuSEKAvuT
         ARKeSZ6o6c6irfpVTgJWZDdF7CZ7++tahIHy6D2ERtf+au8Jzmw6snUIzGCGTpnpamON
         AkR/mKg6bNyhEJZWhFJoBXSu/RwbX4JuipyqCXKw5Mgh4z117sufhFbe9waki7yMtsQR
         VGYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJAElodWUEbJrINM9N/fL8JP3Jfud76GbQ+m80oxwfU=;
        b=NPYZf4qA3mgVFQ+OjzOyrKqhPz93IxueNjcHuJ9/jzOOy2UEaEjns+7SbmalKbtEaA
         /GPQjM4n4tnsxHXZl8fQf82Fg32CVJ18CxRWO1I3/9PQaQ2BskCQUEv+x3v6C1TCW3Ll
         i8DTC8V5uvFF1nzjQDPyunJDKTZajBO4FSIJuw3a45uzyN5lOqMDUwg1jjQ1yb2HDYHd
         3fmTeZxsxLg1nWeNoNpIrTqJS8fYl5aYWgVgc9e8mfJ7ivpq/MB2KmObl0phtXoOc4Vf
         8+j4gHC+ldNiYKcjb7ruw1HSF/kB+xQdIkkU11QJnJDPypnxtJfkT/qGYhEYRhdh9wFJ
         TdnQ==
X-Gm-Message-State: AOAM533wPv2Px3joH+87oyFlcMrPMrJxriE/WNVJYHCdvjepw5pkYzqF
        k1xkNYAEmw3z6IspegZua3EEWdhoqDE=
X-Google-Smtp-Source: ABdhPJxwhKmSMHs/+lvMK+y/oIOrdN6RWwhuk9SWZ+AFhwPxQTOIF/EV38G5s+TBvjlT5OkV7SM6ng==
X-Received: by 2002:a63:b54b:: with SMTP id u11mr131998pgo.163.1634746468414;
        Wed, 20 Oct 2021 09:14:28 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e12sm2939849pfl.67.2021.10.20.09.14.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 09:14:27 -0700 (PDT)
Subject: Re: [PATCH net v9] skb_expand_head() adjust skb->truesize incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        linux-kernel@vger.kernel.org, kernel@openvz.org
References: <45b3cb13-8c6e-25a3-f568-921ab6f1ca8f@virtuozzo.com>
 <2bd9c638-3038-5aba-1dae-ad939e13c0c4@virtuozzo.com>
 <a1b83e46-27d6-d8f0-2327-bb3466e2de13@gmail.com>
 <a7318420-0182-7e66-33e3-3368d4cc181f@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0e8fff74-b9a8-8ec8-71f6-4745fc82dd4b@gmail.com>
Date:   Wed, 20 Oct 2021 09:14:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <a7318420-0182-7e66-33e3-3368d4cc181f@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/21 10:57 PM, Vasily Averin wrote:

>>>  
>>> diff --git a/net/core/sock.c b/net/core/sock.c
>>> index 62627e868e03..1932755ae9ba 100644
>>> --- a/net/core/sock.c
>>> +++ b/net/core/sock.c
>>> @@ -2227,6 +2227,14 @@ void skb_set_owner_w(struct sk_buff *skb, struct sock *sk)
>>>  }
>>>  EXPORT_SYMBOL(skb_set_owner_w);
>>>  
>>> +bool is_skb_wmem(const struct sk_buff *skb)
>>> +{
>>> +	return skb->destructor == sock_wfree ||
>>> +	       skb->destructor == __sock_wfree ||
>>> +	       (IS_ENABLED(CONFIG_INET) && skb->destructor == tcp_wfree);
>>> +}
>>> +EXPORT_SYMBOL(is_skb_wmem);
>>> +
>>
>> This probably should be inlined.
> 
> David Miller pointed me out in the comments to an early version of the patch
> "Please do not use inline in foo.c files, let the compiler decide."
> 

Sure, my suggestion was to move this helper in an include file,
and use

static inline bool ....

I would not suggest add an inline in a C file, unless absolutely critical.
