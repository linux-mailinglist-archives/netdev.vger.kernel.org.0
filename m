Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A123F95E0
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 10:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244482AbhH0IV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 04:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbhH0IV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 04:21:27 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0911C061757
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 01:20:38 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k20-20020a05600c0b5400b002e87ad6956eso3771330wmr.1
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 01:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s3Pna3R3wE20JEp3ZjaDaTee03UQvsv6gWe2RfX72mA=;
        b=MSBJrHgMrGUYGVJFQFD5v4in3Xa39shew8MNRFj27TJlLTkQtXepfol45vW4Z5ldbK
         yvuhP7pi/p0GhpqivIDQ61Ss17FZ4Ey3TD45F44WIS6IRweX0ZLc2ym+2PogjNoYBY8b
         rcpwFm0ZKkQsoPV/2MpTQSShzf2OlPzqXaWXjlTQfssaMrTzbsQyhA7FyDT4ccR/iFPo
         1lNWCHQJhSwbRxv0Dzxkmwsw0AzirttMuboqLqV90HVxal22Govj30BC97Y8GT15a0rM
         aUpK08XujxExbLjix1RB2yheoAg4xrTBlsL4ES/KbVEGZ4Fs7Y4fLn9QCr0UPQapzREK
         8LEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=s3Pna3R3wE20JEp3ZjaDaTee03UQvsv6gWe2RfX72mA=;
        b=i+9PVUktF6SMjzECBpnivsMGxItkqxNGX0ijTN0uZ6y3DnVmGRswhPAPivMHfFz1ls
         thJuSClRSHbbtKk9u0kWA+6NdIvhi/Qw5dvZR93/O5RA1t/BFpJkGEvNQNfbLAlSkfXK
         8xjC3it7I4jhMrGt+c9qEIngMBtePQc59EBZNcI1iLMM+bSmMaLNRA/5PISXpaXArq7V
         yIYD0SS+4e/NOLkQCJ/CMA7whEfwkACJ2whsVQaOnoCRaj50wX68pv4d6T33V00Fmrd7
         9wkeBfyV96O4S00HB68jnhwDJaMaD55HdsdZNZFuu8B5e3bu78k4z+ghdpJYhwUXZfox
         +ePw==
X-Gm-Message-State: AOAM531MbWQbNrZKMub4KZ4kAIlYw4JMecrtI49tF0kEarmvVAE21i3G
        zDe8zCKVnOcMe2ZJlqbMoeWDpA==
X-Google-Smtp-Source: ABdhPJyetZlN3zlWgipcm5thq7PwILd1idIxij4vMVyyWjYmDl+D4ucyox7PY3hogq8O0pe964U+Og==
X-Received: by 2002:a1c:4682:: with SMTP id t124mr18479370wma.168.1630052437320;
        Fri, 27 Aug 2021 01:20:37 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:c9d3:467d:ff28:670a? ([2a01:e0a:410:bb00:c9d3:467d:ff28:670a])
        by smtp.gmail.com with ESMTPSA id m24sm7428033wrb.18.2021.08.27.01.20.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Aug 2021 01:20:36 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC net-next] ipv6: Support for anonymous tunnel decapsulation
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, tom@herbertland.com,
        edumazet@google.com
References: <20210826140150.19920-1-justin.iurman@uliege.be>
 <fd41d544-31f0-8e60-a301-eb4f4e323a5b@6wind.com>
 <1977792481.53611744.1629994989620.JavaMail.zimbra@uliege.be>
 <76c2a8bf-e8c8-7402-ba20-a493fbf7c0e4@6wind.com>
 <324963792.54305318.1630050698741.JavaMail.zimbra@uliege.be>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <63ec6555-77f8-d241-80d5-a40bc4561d75@6wind.com>
Date:   Fri, 27 Aug 2021 10:20:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <324963792.54305318.1630050698741.JavaMail.zimbra@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/08/2021 à 09:51, Justin Iurman a écrit :
>> [snip]
>>
>>>>> Thoughts?
>>>> I'm not sure to understand why the current code isn't enough. The fallback
>>>> tunnels created by legacy IP tunnels drivers are able to receive and decapsulate
>>>> any encapsulated packets.
>>>
>>> Because, right now, you need to use the ip6_tunnel module and explicitly
>>> configure a tunnel, as you described below. The goal of this patch is to
>>> provide a way to apply an ip6ip6 decapsulation *without* having to configure a
>>> tunnel.
>>
>> What is the difference between setting a sysctl somewhere and putting an
>> interface up?
> 
> Well, correct me if I'm wrong but, it's more than just putting an interface up. You'd first need ip6_tunnel (and so tunnel6) module loaded, but you'd also need to configure a tunnel on the decap node.
No, you just need to have the module. The fallback device is automatically
created. And if the module is built-in, there is nothing to do.

 Indeed, the current ip6_tunnel fallback handler only works if a tunnel matches
the packet (i.e., ipxip6_rcv will return -1 since ip6_tnl_lookup will return
NULL, leading to *no* decapsulation from this handler).
No. ip6_tnl_lookup() won't return NULL if the fallback device exists and is up.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/ip6_tunnel.c#n168

The tunnels lookup algorithm has several steps:
 - try to match local and remote addr
 - try to match only local addr
 - try to match only dst addr
 - return the lwt tunnel if it exists
 - return the fallback device if it exists and is up

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/ip6_tunnel.c#n100
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv6/sit.c#n96
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/ip_tunnel.c#n72

> 
> So, again, think about the case where you have lots of ingresses and egresses that should be linked (= a tunnel for each pair) altogether in a domain. You'd need to configure N tunnels on the decap node, where N is the number of ingresses. Well, actually no, you could just configure one tunnel with "remote any", but you'd still depend on the ip6_tunnel module and play with tunnel configuration and its interface. This patch provides a way to avoid that by just enabling the ip6ip6 decapsulation through a per interface sysctl.
> 
I don't understand the problem of depending to the ip6_tunnel module.
Duplicating a subset of the existing code to avoid a dependency to an existing
module seems a bad idea for me, from a maintenance point of view.


Regards,
Nicolas
