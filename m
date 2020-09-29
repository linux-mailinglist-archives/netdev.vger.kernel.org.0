Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F0A27BB9A
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 05:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgI2Djq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 23:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgI2Djq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 23:39:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E98C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 20:39:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b124so3159199pfg.13
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 20:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9tF4qJ73W2C704pE4TQr8MRHkbDaR6WwuY3GUOMxdTg=;
        b=O5+5zbTcf9PtfuXfw5+6w7GSju77odBMZLgIhuXIVnW+w8cXWBDlyr0Wx1gYvTrZa7
         6c5mP5Fh2cXkwOXFtB5e7sIC2jjcHJ70QM7LWIqWrClHIkdlm2s1/SZEXDbF0dq6vTrQ
         zeBpmEqs4pmN2sOW+Us4sPi48d/53bNjw41wA/FQNVmHiqiyzoFpPdffCelFn1UJyund
         oqlf4rw3NjU/pyjjAgfWBXiAJM/JovxQJv2SbBEU7A3DvVrcslyf48Ey6qVheLP/fZkb
         88fNFZ1yzPMVe068u7GT0CkHXPeAYHACOUJQiTuZQK18IYc/+7k2KpIrDShUeXcMGWtU
         S50g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9tF4qJ73W2C704pE4TQr8MRHkbDaR6WwuY3GUOMxdTg=;
        b=MziPyhytM4jSidnBA7w46I2yrZz5MBgG5wwCpk7yExm1XODdeYRSf9hvTjgYDuIQVq
         /eyj2Py3ls+sojRoTEvuLA1EP22z9q4pezpSiBhVV7GowMiZKd7CbUqpQZ0HtaRClEdf
         ey7TDx7PCf1GgUnwZKPgGZae7x3FVthnqkKA1EVhtuADKiWyOOZ2QNJi0merGTlAAkRO
         7C9ZpuO6SnMRCj10Xm/TLVYR0sp7xvDx3yKPBenf1MfXUYoyVnHSwKGOBM7w67UiUTwC
         P8cmoqNdRIhXkSgfR/KtsFDhB7UCXhPhvSnQfJywS5hsht3M9xAm9vKweNsKW/4xSk0M
         y1sw==
X-Gm-Message-State: AOAM530LD5hvIWXcCcRZV3oYTyu6fRLDF2jmwk6YYVzBts9dENAvTuaD
        o1k2gAmmhNTJQldEjvWVP4s=
X-Google-Smtp-Source: ABdhPJzwUhg9ubdddRuLhvTdXU5ZMB/dD1XpKgP7QPRjSgXgSKzjwAwc/Kg7Y69KSYhX2VEpxRdwpA==
X-Received: by 2002:a62:92ce:0:b029:13b:88f6:3935 with SMTP id o197-20020a6292ce0000b029013b88f63935mr2141189pfd.2.1601350785819;
        Mon, 28 Sep 2020 20:39:45 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id 64sm3286753pfg.98.2020.09.28.20.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 20:39:44 -0700 (PDT)
Subject: Re: IPv6 regression introduced by commit
 3b6761d18bc11f2af2a6fc494e9026d39593f22c
To:     Baptiste Jonglez <baptiste@bitsofnetworks.org>
Cc:     Alarig Le Lay <alarig@swordarmor.fr>, netdev@vger.kernel.org,
        jack@basilfillan.uk, Vincent Bernat <bernat@debian.org>,
        Oliver <bird-o@sernet.de>
References: <20200305081747.tullbdlj66yf3w2w@mew.swordarmor.fr>
 <d8a0069a-b387-c470-8599-d892e4a35881@gmail.com>
 <20200927153552.GA471334@fedic> <20200927161031.GB471334@fedic>
 <66345b05-7864-ced2-7f3c-493260be39f7@gmail.com>
 <20200928064800.GA1132636@tuxmachine.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c2349ca8-acd2-a6af-6bc4-11b0486dbe37@gmail.com>
Date:   Mon, 28 Sep 2020 20:39:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200928064800.GA1132636@tuxmachine.localdomain>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/20 11:48 PM, Baptiste Jonglez wrote:
> On 27-09-20, David Ahern wrote:
>> On 9/27/20 9:10 AM, Baptiste Jonglez wrote:
>>> On 27-09-20, Baptiste Jonglez wrote:
>>>> 1) failing IPv6 neighbours, what Alarig reported.  We are seeing this
>>>>    on a full-view BGP router with rather low amount of IPv6 traffic
>>>>    (around 10-20 Mbps)
>>>
>>> Ok, I found a quick way to reproduce this issue:
>>>
>>>     # for net in {1..9999}; do ip -6 route add 2001:db8:ffff:${net}::/64 via fe80::4242 dev lo; done
>>>
>>> and then:
>>>
>>>     # for net in {1..9999}; do ping -c1 2001:db8:ffff:${net}::1; done
>>>
>>> This quickly gets to a situation where ping fails early with:
>>>
>>>     ping: connect: Network is unreachable
>>>
>>> At this point, IPv6 connectivity is broken.  The kernel is no longer
>>> replying to IPv6 neighbor solicitation from other hosts on local
>>> networks.
>>>
>>> When this happens, the "fib_rt_alloc" field from /proc/net/rt6_stats
>>> is roughly equal to net.ipv6.route.max_size (a bit more in my tests).
>>>
>>> Interestingly, the system appears to stay in this broken state
>>> indefinitely, even without trying to send new IPv6 traffic.  The
>>> fib_rt_alloc statistics does not decrease.
>>>
>>
>> fib_rt_alloc is incremented by calls to ip6_dst_alloc. Each of your
>> 9,999 pings is to a unique address and hence causes a dst to be
>> allocated and the counter to be incremented. It is never decremented.
>> That is standard operating procedure.
> 
> Ok, then this is a change in behaviour.  Here is a graph of fib_rt_alloc
> on a busy router (IPv6 full view, moderate IPv6 traffic) with 4.9 kernel:
> 
>   https://files.polyno.me/tmp/rt6_stats_fib_rt_alloc_4.9.png
> 
> It varies quite a lot and stays around 50, so clearly it can be
> decremented in regular operation.
> 
> On 4.19 and later, it does seem to be decremented only when a route is
> removed (ip -6 route delete).  Here is the same graph on a router with a
> 4.19 kernel and a large net.ipv6.route.max_size:
> 
>    https://files.polyno.me/tmp/rt6_stats_fib_rt_alloc_4.19.png
> 
> Overall, do you mean that fib_rt_alloc is a red herring and is not a good
> marker of the issue?
> 

$ git checkout v4.9
$ egrep -r fib_rt_alloc include/ net/
include//net/ip6_fib.h:	__u32		fib_rt_alloc;		/* permanent routes	*/
net//ipv6/route.c:		   net->ipv6.rt6_stats->fib_rt_alloc,

The first declares it; the second prints it. That's it, no other users
so I have no idea why it shows any changes in your v4.9 graph.

Looking git history shows that Wei actually wired up the stats with
commit 81eb8447daae3b62247aa66bb17b82f8fef68249

Author: Wei Wang <weiwan@google.com>
Date:   Fri Oct 6 12:06:11 2017 -0700

    ipv6: take care of rt6_stats

That patch adds an inc but no dec for this stat which is what you show
in your 4.19 graph

Coming back to the bigger problem, fib_rt_alloc has *no* bearing on the
ability to create dst entries which is what the max_route_size sysctl
affects (not FIB entries which are now unbounded, but dst_entry
instances which is when a FIB entry has been hit and used in the
datapath to move packets).

Eric investigated a similar problem recently which resulted in

commit d8882935fcae28bceb5f6f56f09cded8d36d85e6
Author: Eric Dumazet <edumazet@google.com>
Date:   Fri May 8 07:34:14 2020 -0700

    ipv6: use DST_NOCOUNT in ip6_rt_pcpu_alloc()

and I believe is released in v5.8.

