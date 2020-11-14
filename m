Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD0E2B2B1C
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 04:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgKNDhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 22:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNDhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 22:37:18 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E68C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:37:16 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id t8so11811316iov.8
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 19:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mHB76bFBVb+Daza5fzEkrTLKypseZA4q9TCyNHg751w=;
        b=TH5Mo8P4OvpZsbt9Im+XJqMnLcNcYS/2auwCJLt6E6e9Mt9v4Sg6klqiUKYECc/Vrl
         xlX2CqjJ5ujHYkCbuiRhMfHfuGxRWrVO0EqlRecrjCis+qrdj/loBOfjiCeX0tH9uE50
         l11Rv5BkBzDohQPx/JR+csQP7q7tlmiih/ztWRDETOlROZkC+5af99QYJ6+6SDz7V4QF
         Dcy+/SUOOBzHqJyBI/VGHUWhPIUp1racAa7f403Qx2gnuHWSM+QbC4mGpLxTgnuL7ztq
         dVJ8BYREqpjT5BDTlEPqP8eWmq2RaTksmCE8giQ2ISaPSGm4d3ZVJkC7o6hH3NZaBS1Q
         GYow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mHB76bFBVb+Daza5fzEkrTLKypseZA4q9TCyNHg751w=;
        b=IEgHwO6C6BoHWQTBF2Gbd/dO7wraE85h6qwg2sq7cEdFn/bg//dS3ZK4IIU/+wi6ED
         Wdu8owCR0qPGs6UmZQubztTAjZiKt41mjNG5AzSSGk/9fOOTyv5xd5cu2eXwt1wX3pC0
         V1a2rsnYKYsWSYZ6UWbS5RYsn96LfB58LDbjvuCyToY9UvMsdF+HuZqX5W2Z6FFilt70
         b546XYYzwwALtzVis72LqQ4JS004POxQOiH00Uby6E7m3Qb8EgmH6pmfyP1Qv3sWY17q
         VB7BxBbZ/yBTfCZi7TuSvPrZPCIT8ZFuYr0QMXWqyuT7c1odpF4Qn1ndDBvhExuAILbQ
         lVKQ==
X-Gm-Message-State: AOAM533Vwcc8rqksyKYd6K8z/x2ad6Ic2NOTBjw8EZFz+LEIxoxpPmo2
        KC4vP+pA122PSzJ3pwwA+H9RBupNw/GQSQ==
X-Google-Smtp-Source: ABdhPJzNdMVeYAeXS6D+omozWB8Z7F4DoLY/t+507sUoY25pY8bRJ0iX5Os5Mdhh7lUQBXbBB/w0ng==
X-Received: by 2002:a05:6602:124b:: with SMTP id o11mr2045005iou.181.1605325035764;
        Fri, 13 Nov 2020 19:37:15 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id v9sm5937069ilh.6.2020.11.13.19.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 19:37:15 -0800 (PST)
Subject: Re: [net-next,v2,4/5] seg6: add support for the SRv6 End.DT4 behavior
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        netdev@vger.kernel.org
References: <20201107153139.3552-5-andrea.mayer@uniroma2.it>
 <202011131747.puABQV5A-lkp@intel.com>
 <20201113085730.5f3c850a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c7623978-5586-5757-71aa-d12ee046a338@gmail.com>
 <20201113190045.GA1463790@ubuntu-m3-large-x86>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7f73993c-cff9-042c-9b52-2c724f6d1bc4@gmail.com>
Date:   Fri, 13 Nov 2020 20:37:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201113190045.GA1463790@ubuntu-m3-large-x86>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/20 12:00 PM, Nathan Chancellor wrote:
> On Fri, Nov 13, 2020 at 10:05:56AM -0700, David Ahern wrote:
>> On 11/13/20 9:57 AM, Jakub Kicinski wrote:
>>> Good people of build bot, 
>>>
>>> would you mind shedding some light on this one? It was also reported on
>>> v1, and Andrea said it's impossible to repro. Strange that build bot
>>> would make the same mistake twice, tho.
>>>
>>
>> I kicked off a build this morning using Andrea's patches and the config
>> from the build bot; builds fine as long as the first 3 patches are applied.
>>
> 
> I can confirm this as well with clang; if I applied the first three
> patches then this one, there is no error but if you just apply this one,
> there will be. If you open the GitHub URL, it shows just this patch
> applied, not the first three, which explains it.
> 
> For what it's worth, b4 chokes over this series:

Thanks, Nathan. I'll forward to Konstantin.

> 
> $ b4 am -o - 20201107153139.3552-1-andrea.mayer@uniroma2.it | git am
> Looking up https://lore.kernel.org/r/20201107153139.3552-1-andrea.mayer%40uniroma2.it
> Grabbing thread from lore.kernel.org/linux-kselftest
> Analyzing 18 messages in the thread
> ---
> Writing /tmp/tmp8425by7fb4-am-stdout
>   [net-next,v2,3/5] seg6: add callbacks for customizing the creation/destruction of a behavior
> ---
> Total patches: 1
> ---
>  Link: https://lore.kernel.org/r/20201107153139.3552-1-andrea.mayer@uniroma2.it
>  Base: not found
> ---
> Applying: seg6: add callbacks for customizing the creation/destruction of a behavior
> error: patch failed: net/ipv6/seg6_local.c:1015
> error: net/ipv6/seg6_local.c: patch does not apply
> Patch failed at 0001 seg6: add callbacks for customizing the creation/destruction of a behavior
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> 
> Even if I grab the mbox from lore.kernel.org, it tries to do the same
> thing and apply the 3rd patch first, which might explain why the 0day
> bot got confused.
> 
> Cheers,
> Nathan
> 

