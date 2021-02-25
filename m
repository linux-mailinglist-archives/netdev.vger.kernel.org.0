Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D331632558F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 19:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbhBYSdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 13:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbhBYSbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 13:31:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858A3C061786;
        Thu, 25 Feb 2021 10:31:08 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id t9so4026117pjl.5;
        Thu, 25 Feb 2021 10:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YV1fWHtw2C61QMiLwr9hI51XV3MLWr2gQO7xjRtkvb0=;
        b=fWlEAyo/WYYLmGgp3hZwQpDEOxNJvWvnUGDtGPlA9zCnBatwbfKi/XT+sVS8dyE4xl
         ck5FcB/9VHBSCijvLYNOjQKm6IPISegYRqIt6X5//7gKUxVoDP3yI8+Ww/pWTjU6V9U5
         /DdOVQZc6tVkgjdYpRgK7vZcuGRXwrT0Dqs2NNYw/TqiKVvNWcxvBt6CBfh0/Z32bhqi
         NmLFHHH89bVvc7I3Uwiy+zUt1C5hb+tFwO4T7++IAsfhhGSj2K5MPsUh1qkkJLpEuEpz
         b6mo0TAkb/2SZ8cSyBkOCY46VFWNZHJrJLS9MOqbI/qNDA9Sn+iwaHIAV/EV578IWg+Z
         nDFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YV1fWHtw2C61QMiLwr9hI51XV3MLWr2gQO7xjRtkvb0=;
        b=ABknWvyM1hEjI9OLWpE+8A4LecUr1m7tbXUbyDLnwQkr4aP8DarS+QxGoVU7/ia72u
         ClPa65qvm1M/YiC2rq9EA/eAO8cdmJTH71vS7H1gcTTpsmeZd1Z1BDaMkS2vs6zs9as9
         Jk+EvA3wU32wWLzFeo8vr8sB8+ljJS2IuATPBKxzhdPaDUwHOrBnNtygyPVWRpl6n4RY
         91KFIV6QIqJH1Ue1F21Produ3BxE96/JG5tpt9qMOYfTFvL6dknRosxeZdT1n+FEddku
         IXw2wQAKyIKLbq71NQYx0a9KNrUpTg9MWmSgseXbKGWoidOX+Tfwks4n0wUkXPBI0Rzs
         uUmg==
X-Gm-Message-State: AOAM531nIt11KmuEo8fywKCRBIFyckXY4Nq0sWjpgOyLVVzDgFIKpghR
        1P189/37/ucVaHNi/6FBA2k=
X-Google-Smtp-Source: ABdhPJxClqo5O77l2F11J1fAbwrSkP+iEGqg+r6crye40gf4yPM8wiuY1gltGyJF6c90lkfTtpCbeA==
X-Received: by 2002:a17:90a:d149:: with SMTP id t9mr4407644pjw.43.1614277867860;
        Thu, 25 Feb 2021 10:31:07 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a2sm7027920pfi.64.2021.02.25.10.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 10:31:07 -0800 (PST)
Subject: Re: [PATCH stable 0/8] net: dsa: b53: Correct learning for standalone
 ports
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, olteanv@gmail.com, sashal@kernel.org
References: <20210225010853.946338-1-f.fainelli@gmail.com>
 <YDdcvkQQoAs2yc3C@kroah.com> <7d32ff3e-eea7-90ac-a458-348b07410f85@gmail.com>
 <YDfaUaaoc+u3HCDC@kroah.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <29532b28-e30d-aa17-14ce-e518105d7447@gmail.com>
Date:   Thu, 25 Feb 2021 10:31:03 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <YDfaUaaoc+u3HCDC@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/2021 9:11 AM, Greg KH wrote:
> On Thu, Feb 25, 2021 at 08:53:22AM -0800, Florian Fainelli wrote:
>>
>>
>> On 2/25/2021 12:15 AM, Greg KH wrote:
>>> On Wed, Feb 24, 2021 at 05:08:53PM -0800, Florian Fainelli wrote:
>>>> From: Florian Fainelli <florian.fainelli@broadcom.com>
>>>>
>>>> Hi Greg, Sasha, Jaakub and David,
>>>>
>>>> This patch series contains backports for a change that recently made it
>>>> upstream as:
>>>>
>>>> commit f3f9be9c58085d11f4448ec199bf49dc2f9b7fb9
>>>> Merge: 18755e270666 f9b3827ee66c
>>>> Author: Jakub Kicinski <kuba@kernel.org>
>>>> Date:   Tue Feb 23 12:23:06 2021 -0800
>>>>
>>>>     Merge branch 'net-dsa-learning-fixes-for-b53-bcm_sf2'
>>>
>>> That is a merge commit, not a "real" commit.
>>>
>>> What is the upstream git commit id for this?
>>
>> The commit upstream is f9b3827ee66cfcf297d0acd6ecf33653a5f297ef ("net:
>> dsa: b53: Support setting learning on port") it may still only be in
>> netdev-net/master at this point, though it will likely reach Linus' tree
>> soon.
> 
> Ah, I can't do anything with them until that hits Linus's tree, you know
> this :)

Yes, that was a tad too quick.

> 
>>>> The way this was fixed in the netdev group's net tree is slightly
>>>> different from how it should be backported to stable trees which is why
>>>> you will find a patch for each branch in the thread started by this
>>>> cover letter.
>>>>
>>>> Let me know if this does not apply for some reason. The changes from 4.9
>>>> through 4.19 are nearly identical and then from 5.4 through 5.11 are
>>>> about the same.
>>>
>>> Thanks for the backports, but I still need a real git id to match these
>>> up with :)
>>
>> You should have it in the Fixes: tag of each patch which all point to
>> when the bug dates back to when the driver was introduced. Let me know
>> if you need me to tag the patches differently.
> 
> The fixes: tag shows what id this patch fixes, not the git id of this
> specific patch, like all stable patches show in their changelog text.
> 
> That's the id I need.  I'll just wait until this hits Linus's tree
> before worrying about it.

Looks like I found an issue that will need fixing in netdev-net/master
as well, so I will resubmit in due time when the commits reach Linus'
tree. Sorry for the noise.
-- 
Florian
