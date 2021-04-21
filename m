Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1082A367255
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242598AbhDUSP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242144AbhDUSP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:15:26 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FD5C06174A;
        Wed, 21 Apr 2021 11:14:51 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id x20so37901054lfu.6;
        Wed, 21 Apr 2021 11:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m+33ExQ8GMR4a50sNxm7ncwO9qlKKgczXAy8xRozW64=;
        b=sNt2BMPC3ThHO5SheN86oUr0qmJLUi/h0k9OkAp0pPIUMFT+TAk/aKdLfwWSMnla0D
         a7IrFl1bHbLo47JvfCrd1xcpljXXAMr/GKNO9WSL91iZ8gbcT+DS0uANHVG6fwxkRE8K
         ZPkMTWh1fsKTAo9vfxeBi/kuKcInP+6hKhjiGTk+FefXUUSfdlgqjitR2DXB7W/Zugek
         FBYCQthPUF0im39lUZsjNcisc6MUpD4UTLFRG+9Tr75Q4b0SJ7Csf9sfLrVqmaY+Bbnv
         2688+oya7jgG4y83XOSXIbNSnYx+1u3Uc9tVyJnM+6D7/uzhdPZ9qtMFcjSdijGXJkt3
         eQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m+33ExQ8GMR4a50sNxm7ncwO9qlKKgczXAy8xRozW64=;
        b=ejk7uewsdCiIcqGerpQVPd8UP9EYQ8gn4PCymZ276k1jhkI4W2Dol5IlMy6OEnqCu+
         7B968uALq6V8/OfYO4e2MkNL7RqCBaP6SbLDhYRDwUQsOe6HMVEAlAqbVVn4Y4bXx09R
         huEaTk9crHzuTwiw+qc40aYPfvlCmT5UFrX976+B4HiyzJLEdnPHMrEVvZ0RlY+wgqph
         WGfCXdZXHPnPgXQKRnkuDNIQmC7xsQydsrNK42bysjvrK0JmvHh6T9GeXJt8664/8V0Y
         ArkcfwiWdJxHHwpa7CikBZBTKg7spYyaTrxxALPnhYI+KG5CjoGbv436vFFqui0Bwhv4
         fuYg==
X-Gm-Message-State: AOAM5308R2KgNl2UIe8gsNCzmDEUNw4Bj58MMhHt+OmOvdFMrWKeb4AM
        eO0apjjgUXicWuyUBQHWFo42vw7ua3E=
X-Google-Smtp-Source: ABdhPJx0WH7LPDRInqqblV1hKWcAqoztOYmnkXlnttU7+XBdaH+e+pwGbG7XmFPcFj3zm1BzXx66aA==
X-Received: by 2002:a05:6512:21a5:: with SMTP id c5mr20846510lft.534.1619028889298;
        Wed, 21 Apr 2021 11:14:49 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.83.219])
        by smtp.gmail.com with ESMTPSA id 14sm29074lfr.252.2021.04.21.11.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 11:14:48 -0700 (PDT)
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
To:     patchwork-bot+netdevbpf@kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
 <161902800958.24373.15370499378110944137.git-patchwork-notify@kernel.org>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <d5dd135b-241f-6116-466d-8505b7e7d697@gmail.com>
Date:   Wed, 21 Apr 2021 21:14:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <161902800958.24373.15370499378110944137.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 4/21/21 9:00 PM, patchwork-bot+netdevbpf@kernel.org wrote:

[...]
>> When a lot of frames were received in the short term, the driver
>> caused a stuck of receiving until a new frame was received. For example,
>> the following command from other device could cause this issue.
>>
>>     $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>
>>
>> The previous code always cleared the interrupt flag of RX but checks
>> the interrupt flags in ravb_poll(). So, ravb_poll() could not call
>> ravb_rx() in the next time until a new RX frame was received if
>> ravb_rx() returned true. To fix the issue, always calls ravb_rx()
>> regardless the interrupt flags condition.
>>
>> [...]
> 
> Here is the summary with links:
>   - net: renesas: ravb: Fix a stuck issue when a lot of frames are received
>     https://git.kernel.org/netdev/net/c/5718458b092b
> 
> You are awesome, thank you!

   WTF is this rush?! :-/
   I was going to review this patch (it didn't look well to me from th 1s glance)...

[...]

MBR, Sergei
