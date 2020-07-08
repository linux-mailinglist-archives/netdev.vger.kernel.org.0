Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7E7E2185E4
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 13:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgGHLRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 07:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgGHLRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 07:17:22 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA3CC08C5DC
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 04:17:22 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id w16so49976403ejj.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 04:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5M3U61xRN0rk0vpKpdQ7yyYN0u/EFgldrR1eCqUQlHY=;
        b=bReDJ038x+E2AnOTNDbIhqpr83+fdDZ8MLDEJ473UPEvhZ/3rlq1V5+appYpO+bnBS
         7iWYFcQoWCgNzVPrWNUIe0wQGk8MdhHTCfIy8ybbfDvwNPJeZl4mA7gvjZirYNTInYK9
         jwrQfMDWwfl8erSuR4qO7a2+2MEjIOBMzgXc8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5M3U61xRN0rk0vpKpdQ7yyYN0u/EFgldrR1eCqUQlHY=;
        b=E7WzJMcd9dRPuOz/+l1vpx/HjwRe+My6nX1gB0GOLZPzov7Mb4qLt4ub0kp3ILC5ri
         hPH8ZrWcL2HMt4Uf0rG7ezJL7wQ7KW6C08U0mL5454BbISmmwL5xkz0e+XJIZb26JKNx
         QYa1PZKsU5LUFRAOlMCELuiw6PVCB1refiXRsWplJf+oJ0vtWEqcC8yZ9NJr/+mMnZIB
         TKWTzLKjXtbFg8oEyBdbwitOm1bUHQHK4bbM80urAlAdE6zUm4A/Q7OC8tVevUCfvR03
         PlThedptq7MHLi9hsdJTjp82nZE1OVOvs5qkZWWFzSDuGkB+0HFG1712JMPLwGlrsaFX
         umFQ==
X-Gm-Message-State: AOAM532XzKn8MJbLgK/q5YnuQgdV83jDOlpCGqq7PKKas1n7cNAya8u5
        HnRW2zcYvdIZS4wL+boR4iJbj9zUDi4Y5w==
X-Google-Smtp-Source: ABdhPJyUDfzaQdA4kSqeZAtKrvF7wEgA1whnyqkzkUO8bm/kAhKA0f+Endu4oaONogs9k2ogqEB4bw==
X-Received: by 2002:a17:906:3850:: with SMTP id w16mr51822044ejc.205.1594207040555;
        Wed, 08 Jul 2020 04:17:20 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id dn15sm1907557ejc.26.2020.07.08.04.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:17:19 -0700 (PDT)
Subject: Re: What is the correct way to install an L2 multicast route into a
 bridge?
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     roopa@cumulusnetworks.com, netdev@vger.kernel.org
References: <20200708090454.zvb6o7jr2woirw3i@skbuf>
 <6e654725-ec5e-8f6d-b8ae-3cf8b898c62e@cumulusnetworks.com>
 <20200708094200.p6lprjdpgncspima@skbuf>
 <0d554adb-29c3-3b4a-d696-4d4bfd567767@cumulusnetworks.com>
Message-ID: <7a64aacf-51fd-4697-6af9-229bbbe97d0b@cumulusnetworks.com>
Date:   Wed, 8 Jul 2020 14:17:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <0d554adb-29c3-3b4a-d696-4d4bfd567767@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/07/2020 14:07, Nikolay Aleksandrov wrote:
> On 08/07/2020 12:42, Vladimir Oltean wrote:
>> On Wed, Jul 08, 2020 at 12:16:27PM +0300, Nikolay Aleksandrov wrote:
>>> On 08/07/2020 12:04, Vladimir Oltean wrote:
>>>> Hi,
>>>>
>>>> I am confused after reading man/man8/bridge.8. I have a bridge br0 with
>>>> 4 interfaces (eth0 -> eth3), and I would like to install a rule such
>>>> that the non-IP multicast address of 09:00:70:00:00:00 is only forwarded
>>>> towards 3 of those ports, instead of being flooded.
>>>> The manual says that 'bridge mdb' is only for IP multicast, and implies
>>>> that 'bridge fdb append' (NLM_F_APPEND) is only used by vxlan. So, what
>>>> is the correct user interface for what I am trying to do?
>>>>
>>>> Thank you,
>>>> -Vladimir
>>>>
>>>
>>> Hi Vladimir,
>>> The bridge currently doesn't support L2 multicast routes. The MDB interface needs to be extended
>>> for such support. Soon I'll post patches that move it to a new, entirely netlink attribute-
>>> based, structure so it can be extended easily for that, too. My change is motivated mainly by SSM
>>> but it will help with implementing this feature as well.
>>> In case you need it sooner, patches are always welcome! :)
>>>
>>> Current MDB fixed-size structure can also be used for implementing L2 mcast routes, but it would
>>> require some workarounds. 
>>>
>>> Cheers,
>>>  Nik
>>>
>>>
>>
>> Thanks, Nikolay.
>> Isn't mdb_modify() already netlink-based? I think you're talking about
>> some changes to 'struct br_mdb_entry' which would be necessary. What
>> changes would be needed, do you know (both in the 'workaround' case as
>> well as in 'fully netlink')?
>>
>> -Vladimir
>>
> 
> That is netlink-based, but the uAPI (used also for add/del/dump) uses a fixed-size struct
> which is very inconvenient and hard to extend. I plan to add MDBv2 which uses separate
> netlink attributes and can be easily extended as we plan to add some new features and will
> need that flexibility. It will use a new container attribute for the notifications as well.
> 
> In the workaround case IIRC you'd have to add a new protocol type to denote the L2 routes, and

Actually drop the whole /workaround/ comment altogether. It can be implemented fairly straight-forward
even with the struct we got now. You don't need any new attributes.
I just had forgotten the details and spoke too quickly. :)

> re-work the lookup logic to include L2 in non-IP case. You'd have to edit the multicast fast-path,
> and everything else that assumes the frame has to be IP/IPv6. I'm sure I'm missing some details as
> last I did this was over an year ago where I made a quick and dirty hack that implemented it with proto = 0
> to denote an L2 entry just as a proof of concept.
> Also you would have to make sure all of that is compatible with current user-space code. For example
> iproute2/bridge/mdb.c considers that proto can be only IPv4 or IPv6 if it's not v4, i.e. it will
> print the new L2 entries as :: IPv6 entries until it's fixed.
> 
> Obviously some of the items for the workaround case are valid in all cases for L2 routes (e.g. fast-path/lookup edit).
> But I think it's not that hard to implement without affecting the fast path much or even at all.
> 
> Cheers,
>  Nik
> 
> 
> 

