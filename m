Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2300EA3BC1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 18:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbfH3QP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 12:15:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52439 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbfH3QP0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 12:15:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id t17so7947516wmi.2;
        Fri, 30 Aug 2019 09:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RvULTbglvsEpSUEl2PMG0UwvBIgjs3k2jzK9oMeOf/g=;
        b=Vydb4Dle1to+M1trUotpf7b+sETb6evWQuAc+mqP6Se10ww7Uj5Z2OJh4a8WeQKK4H
         JcelOy8LVyJLrAbl57+7h7YSZwdGEUW62VBWmClF2upOMUUN3h3BNuXNF4FrHNOlBCXo
         uZASVSphcFVKqsCYib4AhC+ffQNc6MqSbc8ktNejdbKsj9mZMpaTSwlfkfKWjDH/A9Uz
         EsbQF8GGUnD5U3KS+q/BQGAyagegoMcvkELq9KT+kIorskpg8butTUZMU0cT6wkmOObY
         VSFnKRNz9DXKENkvJeVh/8+KPTJcJ5ORccvuKcueZ3sjeLF0Igst+bup83+efeb5zDGZ
         07Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RvULTbglvsEpSUEl2PMG0UwvBIgjs3k2jzK9oMeOf/g=;
        b=MXERSTTnhJG29ttns79tNwIG+XAUFBMJw/RUYSn9GdYxGTthAaVaRT1QpRYf/iOV+q
         CnL9OttS2CB902RNDoE4Dz2GKfNl0B6XP8HCfyx8lDx2/VRCxUUgcffwfzCsEOJi9Rp8
         ytLfdKX14v9wnDbkJo4F4RdwRfLWhIVk9/BpmH9vH9Hdeo3HY1BgJQqusJFrQXIoRFXD
         7VQ/MNXYs5L0EClcaZWasyXO7CqVhA6iNASEVAYjOvCmo/YVHOqSXJZKZEVgpMy36NhU
         NQnGgirSnFPMkhuen24+TuMlwZhoEaEcEhl1qb1fmqHcTtXS8NIkL7zDYzOAIkZgtxk+
         cyBQ==
X-Gm-Message-State: APjAAAWARsZl1SKV6sSQcp7ntdDWK9sPkvAaoeVPZimwpnSRjnP5mfqB
        nJHbY+a5sWysFXRu5evopVaQpWiU
X-Google-Smtp-Source: APXvYqwRC7VjVdR0nKtT76M4w3gVjPwIDRv5e5ONZ1A8loK1XrViNO6i2f2wuGBdd7VkCTp3RNgyew==
X-Received: by 2002:a7b:c954:: with SMTP id i20mr16685029wml.169.1567181724174;
        Fri, 30 Aug 2019 09:15:24 -0700 (PDT)
Received: from [192.168.8.147] (95.168.185.81.rev.sfr.net. [81.185.168.95])
        by smtp.gmail.com with ESMTPSA id f6sm15241274wrh.30.2019.08.30.09.15.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2019 09:15:23 -0700 (PDT)
Subject: Re: [PATCH] net/skbuff: silence warnings under memory pressure
To:     Qian Cai <cai@lca.pw>, Eric Dumazet <eric.dumazet@gmail.com>,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <1567177025-11016-1-git-send-email-cai@lca.pw>
 <6109dab4-4061-8fee-96ac-320adf94e130@gmail.com>
 <1567178728.5576.32.camel@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <229ebc3b-1c7e-474f-36f9-0fa603b889fb@gmail.com>
Date:   Fri, 30 Aug 2019 18:15:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567178728.5576.32.camel@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/30/19 5:25 PM, Qian Cai wrote:
> On Fri, 2019-08-30 at 17:11 +0200, Eric Dumazet wrote:
>>
>> On 8/30/19 4:57 PM, Qian Cai wrote:
>>> When running heavy memory pressure workloads, the system is throwing
>>> endless warnings below due to the allocation could fail from
>>> __build_skb(), and the volume of this call could be huge which may
>>> generate a lot of serial console output and cosumes all CPUs as
>>> warn_alloc() could be expensive by calling dump_stack() and then
>>> show_mem().
>>>
>>> Fix it by silencing the warning in this call site. Also, it seems
>>> unnecessary to even print a warning at all if the allocation failed in
>>> __build_skb(), as it may just retransmit the packet and retry.
>>>
>>
>> Same patches are showing up there and there from time to time.
>>
>> Why is this particular spot interesting, against all others not adding
>> __GFP_NOWARN ?
>>
>> Are we going to have hundred of patches adding __GFP_NOWARN at various points,
>> or should we get something generic to not flood the syslog in case of memory
>> pressure ?
>>
> 
> From my testing which uses LTP oom* tests. There are only 3 places need to be
> patched. The other two are in IOMMU code for both Intel and AMD. The place is
> particular interesting because it could cause the system with floating serial
> console output for days without making progress in OOM. I suppose it ends up in
> a looping condition that warn_alloc() would end up generating more calls into
> __build_skb() via ksoftirqd.
> 

Yes, but what about other tests done by other people ?

You do not really answer my last question, which was really the point I tried
to make.

If there is a risk of flooding the syslog, we should fix this generically
in mm layer, not adding hundred of __GFP_NOWARN all over the places.

Maybe just make __GFP_NOWARN the default, I dunno.
