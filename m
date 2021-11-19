Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E753457574
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 18:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236628AbhKSR3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 12:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhKSR3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 12:29:22 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20F3AC061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 09:26:20 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id a9so19360039wrr.8
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 09:26:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sg9mZ2PGrmzKFrdGWcYp7whsp41pLzgkMBSKP2kUkUI=;
        b=Vbsc7bWTZ03zDF5sukj16xOFul7ZJk+3rnoh0sMCu+2lF5Gj2fLtYqmpFk0I8+pd4g
         m6H/+/dpreNm9kgpxf/J4CDMJ6US2CaJdGC6YZeEFt22S9vJUbGgLiNAdQgjZe1+VRbM
         pabiMqSmwWCj+/BGSgkI6QHzMBywuD/SYRaf2kspJzc75bsmUhIMJ0AE17gwXm0Wlp78
         4kLwmR3ZopEMHS2bfzGA+yozHEWYoayiI39FDIVUJSUV7Ay96wFYgB6Du9yZ6bmlerH3
         c7NC/3HvjjLb/wvx+fIveQVQ6ehSEgYdxeiet9mlkKQ9fZuvoYKM4vAXYtREmzj2nIxX
         7weA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Sg9mZ2PGrmzKFrdGWcYp7whsp41pLzgkMBSKP2kUkUI=;
        b=BTKrEweRZcjoUDgzhz8R9AcM9tUJuRBh7LW5aI8l6rsXtWIqDHhv2WnJ9u0vcBw3Lv
         UaPn3h5rcDvXtj7QEAVQbGozdW27Y3ZLSY+biQjAFlZQJn0699wfOILCDkZF6QYtzMwo
         awkjxjgxdT1K7kw0G2JpwJGf1fbWO2gzRXGM4pWZ1Niq2M/W9Eem1AGvxxdKlELqceso
         nqJk2tXHNfl5OoATrvP4zLcPw0CnfhfA1DvpToWbpu3v7MyevvrCPJs6Mt6Ar0kkUfig
         AGhI4/03pMvoXfdtI9p3wJi/wZCJK7oMtHsZQ5FUyR5RLam4E1Yj2hMZDy5E1QdtJAp1
         JLEQ==
X-Gm-Message-State: AOAM533ZnQFUYvvkyCQZASCsItAqYY/tH1qzZNBjjd5urgi0c+wpsMhF
        JB3r9ZnJJnitkgwpuoZcgpyCGWrnWzgelg==
X-Google-Smtp-Source: ABdhPJyGkEi7tIQg4mUQtRrwaDcg07ia1PulbfHRbtd5ceBpa7LR7yLfOth6+KIqoSdREJl+2n515w==
X-Received: by 2002:a5d:6351:: with SMTP id b17mr9106870wrw.151.1637342778687;
        Fri, 19 Nov 2021 09:26:18 -0800 (PST)
Received: from ?IPv6:2a01:e0a:b41:c160:28cf:7e86:cefd:55f9? ([2a01:e0a:b41:c160:28cf:7e86:cefd:55f9])
        by smtp.gmail.com with ESMTPSA id j40sm15115709wms.19.2021.11.19.09.26.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Nov 2021 09:26:18 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net] tun: fix bonding active backup with arp monitoring
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
References: <20211112075603.6450-1-nicolas.dichtel@6wind.com>
 <163698180894.15087.10819422346391173910.git-patchwork-notify@kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <37db0bc8-d3e0-7155-5f08-fe8b5abd21ed@6wind.com>
Date:   Fri, 19 Nov 2021 18:26:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <163698180894.15087.10819422346391173910.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/11/2021 à 14:10, patchwork-bot+netdevbpf@kernel.org a écrit :
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Fri, 12 Nov 2021 08:56:03 +0100 you wrote:
>> As stated in the bonding doc, trans_start must be set manually for drivers
>> using NETIF_F_LLTX:
>>  Drivers that use NETIF_F_LLTX flag must also update
>>  netdev_queue->trans_start. If they do not, then the ARP monitor will
>>  immediately fail any slaves using that driver, and those slaves will stay
>>  down.
>>
>> [...]
> 
> Here is the summary with links:
>   - [net] tun: fix bonding active backup with arp monitoring
>     https://git.kernel.org/netdev/net/c/a31d27fbed5d
> 
> You are awesome, thank you!
> 
May I ask for a backport to stable of this patch?

It's now in Linus tree: a31d27fbed5d ("tun: fix bonding active backup with arp
monitoring"):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a31d27fbed5d

I didn't put a Fixes tag in the original submission because the bug is there
before git ages.
Maybe "Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")" would have been a better choice.


Regards,
Nicolas


