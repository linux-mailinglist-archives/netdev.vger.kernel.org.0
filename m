Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8126E628A
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 14:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfJ0NG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 09:06:26 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35846 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfJ0NGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 09:06:25 -0400
Received: by mail-pl1-f195.google.com with SMTP id g9so3360364plp.3;
        Sun, 27 Oct 2019 06:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LdolkZV7QL6VSy4nsGhXagr++XFXLydJeQ8PKkqogwg=;
        b=m7Z7VMyeC8cOHgfkqr7ZGcO8ugTvoC1F0axf7QGlxOUV/1syg9GPyu2ka8UKU3nOTs
         D69bkxfYcqnOEEqbNLt0VX3JtQM4+x02iiJsAIlCaXIyCSo6uW0Iz1y92thY1n0zOGJO
         F/IBA2K+zE7C06SKFHoXJMHRg9CaEYAQAx1gr946yVXU64kYBoWAG8CQSJHjDCmql/yq
         tCfjeYN4gXvBvRNCL13LUZ2v9ZvjfZiIeZjMLL+C0aPPrh8Ef4kGhg1dI44JMRGDy7o5
         CA21kwXujaT3SpZLm3o0Y4GZjHLvkiLjl5Irs+9RD7uBHle8eh+zJ9SHT2m0xLCNTQ+a
         F9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LdolkZV7QL6VSy4nsGhXagr++XFXLydJeQ8PKkqogwg=;
        b=d+xAUyVFg9h5V+fbYIsnFT3/tMF9JnYXCZkXeXnho/zaFjbI0GNtvmbI00BQPudnLp
         YGtnBcsV/irJAAl1hmWZCRTn+YNl/uta1uiVYhCjxXHAsn3VS4gElQJqw2ZJ+9GO/5Ux
         lWxwLflVU8HaBG6ntWQK9PuLhpcAtHAhKZZbTNE9bto0LrELTSdmyZTjy27LK4wYuguE
         a3ZoUUbYc1JdAF5rUJiMZF7dSHkADpww/dOWliN2jQE8PdbeCi+AUf/aQMMR40FSrnmc
         pMhN/UvWp3FjgJ+Y+FyQZBDexej8tH7FvqHNRMfJiFnDRKpVYFRo+f7tS1mqa4Ly1aCQ
         6e5w==
X-Gm-Message-State: APjAAAW8iwG42Vwu8cwORqgEZWs6Q8GzTA8uprZSfw60aW0QSLEW1qrI
        OIhQ4Mm07wtYKquBNcF1mfRUYuLH
X-Google-Smtp-Source: APXvYqzqVhcrLSDmTUyyfW/aL9/mV+YS01NJb9TbaMP5vCIbizQY98WXaDW6ob9KpvK4f5ag53T12A==
X-Received: by 2002:a17:902:ff0f:: with SMTP id f15mr13878752plj.207.1572181584534;
        Sun, 27 Oct 2019 06:06:24 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id j12sm8499064pjz.12.2019.10.27.06.06.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 06:06:23 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
Message-ID: <59ca42a2-3779-4c9a-a094-8222405c65fe@gmail.com>
Date:   Sun, 27 Oct 2019 22:06:18 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/23 (水) 1:54:57, John Fastabend wrote:
> Toshiaki Makita wrote:
>> On 2019/10/19 0:22, John Fastabend wrote:
>>> Toshiaki Makita wrote:
>>>> This is a PoC for an idea to offload flow, i.e. TC flower and nftables,
>>>> to XDP.
>>>>
>>>
>>> I've only read the cover letter so far but...
>>
>> Thank you for reading this long cover letter.
>>
>>>
>>>> * Motivation
>>>>
>>>> The purpose is to speed up flow based network features like TC flower and
>>>> nftables by making use of XDP.
>>>>
>>>> I chose flow feature because my current interest is in OVS. OVS uses TC
>>>> flower to offload flow tables to hardware, so if TC can offload flows to
>>>> XDP, OVS also can be offloaded to XDP.
>>>
>>> This adds a non-trivial amount of code and complexity so I'm
>>> critical of the usefulness of being able to offload TC flower to
>>> XDP when userspace can simply load an XDP program.
>>>
>>> Why does OVS use tc flower at all if XDP is about 5x faster using
>>> your measurements below? Rather than spend energy adding code to
>>> a use case that as far as I can tell is narrowly focused on offload
>>> support can we enumerate what is missing on XDP side that blocks
>>> OVS from using it directly?
>>
>> I think nothing is missing for direct XDP use, as long as XDP datapath
>> only partially supports OVS flow parser/actions like xdp_flow.
>> The point is to avoid duplicate effort when someone wants to use XDP
>> through TC flower or nftables transparently.
> 
> I don't know who this "someone" is that wants to use XDP through TC
> flower or nftables transparently. TC at least is not known for a
> great uapi. It seems to me that it would be a relatively small project
> to write a uapi that ran on top of a canned XDP program to add
> flow rules. This could match tc cli if you wanted but why not take
> the opportunity to write a UAPI that does flow management well.

Not sure why TC is not a great uapi (or cli you mean?).
I'm not thinking it's a good idea to add another API when there is an 
API to do the same thing.

> Are there users of tc_flower in deployment somewhere?

Yes at least I know a few examples in my company...
To me flower is easier to use compared to u32 as it can automatically 
dissect flows, so I usually use it when some filter or redirection is 
necessary on devices level.

> I don't have
> lots of visibility but my impression is these were mainly OVS
> and other switch offload interface.
> 
> OVS should be sufficiently important that developers can right a
> native solution in my opinion. Avoiding needless layers of abstraction
> in the process. The nice thing about XDP here is you can write
> an XDP program and set of maps that matches OVS perfectly so no
> need to try and fit things in places.

I think the current XDP program for TC matches OVS as well, so I don't 
see such merit. TC flower and ovs kmod is similar in handling flows 
(both use mask list and look up hash table per mask).

> 
>>
>>> Additionally for hardware that can
>>> do XDP/BPF offload you will get the hardware offload for free.
>>
>> This is not necessary as OVS already uses TC flower to offload flows.
> 
> But... if you have BPF offload hardware that doesn't support TCAM
> style flow based offloads direct XDP offload would seem easier IMO.
> Which is better? Flow table based offloads vs BPF offloads likely
> depends on your use case in my experience.

I thought having single control path for offload is simple and 
intuitive. If XDP is allowed to be offloaded, OVS needs to have more 
knobs to enable offload of XDP programs.
I don't have ideas about difficulty in offload drivers' implementation 
though.

> 
>>
>>> Yes I know XDP is bytecode and you can't "offload" bytecode into
>>> a flow based interface likely backed by a tcam but IMO that doesn't
>>> mean we should leak complexity into the kernel network stack to
>>> fix this. Use the tc-flower for offload only (it has support for
>>> this) if you must and use the best (in terms of Mpps) software
>>> interface for your software bits. And if you want auto-magic
>>> offload support build hardware with BPF offload support.
>>>
>>> In addition by using XDP natively any extra latency overhead from
>>> bouncing calls through multiple layers would be removed.
>>
>> To some extent yes, but not completely. Flow insertion from userspace
>> triggered by datapath upcall is necessary regardless of whether we use
>> TC or not.
> 
> Right but these are latency involved with OVS architecture not
> kernel implementation artifacts. Actually what would be an interesting
> metric would be to see latency of a native xdp implementation.
> 
> I don't think we should add another implementation to the kernel
> that is worse than what we have.
> 
> 
>   xdp_flow  TC        ovs kmod
>   --------  --------  --------
>   22ms      6ms       0.6ms
> 
> TC is already order of magnitude off it seems :(

Yes but I'm unsure why it takes so much time. I need to investigate that...

> 
> If ovs_kmod is .6ms why am I going to use something that is 6ms or
> 22ms. I expect a native xdp implementation using a hash map to be
> inline with ovs kmod if not better. So if we have already have
> an implementation in kernel that is 5x faster and better at flow
> insertion another implementation that doesn't meet that threshold
> should probably not go in kernel.

Note that simple hash table (micro flows) implementation is hard.
It requires support for all key parameters including conntrack 
parameters, which does not look feasible now.
I only support mega flows using multiple hash tables each of which has 
its mask. This allows for support of partial set of keys which is 
feasible with XDP.

With this implementation I needed to emulate a list of masks using 
arrays, which I think is the main source of the latency, as it requires 
several syscalls to modify and lookup the BPF maps (I think it can be 
improved later though). This is the same even if we cross out the TC.

Anyway if the flow is really sensitive to latency, users should add the 
flow entry in advance. Going through userspace itself has non-negligible 
latency.

> 
> Additionally, for the OVS use case I would argue the XDP native
> solution is straight forward to implement. Although I will defer
> to OVS datapath experts here but above you noted nothing is
> missing on the feature side?

Yes as long as it is partial flow key/action support.
For full datapath support it's far from feasible, as William experienced...

> 
>>
>>>> When TC flower filter is offloaded to XDP, the received packets are
>>>> handled by XDP first, and if their protocol or something is not
>>>> supported by the eBPF program, the program returns XDP_PASS and packets
>>>> are passed to upper layer TC.
>>>>
>>>> The packet processing flow will be like this when this mechanism,
>>>> xdp_flow, is used with OVS.
>>>
>>> Same as obove just cross out the 'TC flower' box and add support
>>> for your missing features to 'XDP prog' box. Now you have less
>>> code to maintain and less bugs and aren't pushing packets through
>>> multiple hops in a call chain.
>>
>> If we cross out TC then we would need similar code in OVS userspace.
>> In total I don't think it would be less code to maintain.
> 
> Yes but I think minimizing kernel code and complexity is more important
> than minimizing code in a specific userspace application/use-case.
> Just think about the cost of a bug in kernel vs user space side. In
> user space you have ability to fix and release your own code in kernel
> side you will have to fix upstream, manage backports, get distributions
> involved, etc.
> 
> I have no problem adding code if its a good use case but in this case
> I'm still not seeing it.

I can understand the kernel code is more important, but if we determine 
not to have the code in kernel, we probably need each code in each 
userland tools? OVS has XDP, TC (iproute2 or some new userland tool) has 
XDP, nft has XDP, and they will be the same functionality, which is 
duplicate effort.

> 
>>
>>>
>>>>
>>>>    +-------------+
>>>>    | openvswitch |
>>>>    |    kmod     |
>>>>    +-------------+
>>>>           ^
>>>>           | if not match in filters (flow key or action not supported by TC)
>>>>    +-------------+
>>>>    |  TC flower  |
>>>>    +-------------+
>>>>           ^
>>>>           | if not match in flow tables (flow key or action not supported by XDP)
>>>>    +-------------+
>>>>    |  XDP prog   |
>>>>    +-------------+
>>>>           ^
>>>>           | incoming packets
>>>>
>>>> Of course we can directly use TC flower without OVS to speed up TC.
>>>
>>> huh? TC flower is part of TC so not sure what 'speed up TC' means. I
>>> guess this means using tc flower offload to xdp prog would speed up
>>> general tc flower usage as well?
>>
>> Yes.
>>
>>>
>>> But again if we are concerned about Mpps metrics just write the XDP
>>> program directly.
>>
>> I guess you mean any Linux users who want TC-like flow handling should develop
>> their own XDP programs? (sorry if I misunderstand you.)
>> I want to avoid such a situation. The flexibility of eBPF/XDP is nice and it's
>> good to have any program each user wants, but not every sysadmin can write low
>> level good performance programs like us. For typical use-cases like flow handling
>> easy use of XDP through existing kernel interface (here TC) is useful IMO.
> 
> For OVS the initial use case I suggest write a XDP program tailored and
> optimized for OVS. Optimize it for this specific use case.

I think current code is already optimized for OVS as well as TC.

> 
> If you want a general flow based XDP program write one, convince someone
> to deploy and build a user space application to manage it. No sysadmin
> has to touch this. Toke and others at RedHat appear to have this exact
> use case in mind.
> 
>>
>>>
>> ...
>>>> * About alternative userland (ovs-vswitchd etc.) implementation
>>>>
>>>> Maybe a similar logic can be implemented in ovs-vswitchd offload
>>>> mechanism, instead of adding code to kernel. I just thought offloading
>>>> TC is more generic and allows wider usage with direct TC command.
>>>>
>>>> For example, considering that OVS inserts a flow to kernel only when
>>>> flow miss happens in kernel, we can in advance add offloaded flows via
>>>> tc filter to avoid flow insertion latency for certain sensitive flows.
>>>> TC flower usage without using OVS is also possible.
>>>
>>> I argue to cut tc filter out entirely and then I think non of this
>>> is needed.
>>
>> Not correct. Even with native XDP use, multiple map lookup/modification
>> from userspace is necessary for flow miss handling, which will lead to
>> some latency.
> 
> I have not done got the data but I suspect the latency will be much
> closer to the ovs kmod .6ms than the TC or xdp_flow latency.

It should not as I explained above, although I should confirm it.

> 
>>
>> And there are other use-cases for direct TC use, like packet drop or
>> redirection for certain flows.
> 
> But these can be implemented in XDP correct?

So want to avoid duplicate work...

> 
>>
>>>
>>>>
>>>> Also as written above nftables can be offloaded to XDP with this
>>>> mechanism as well.
>>>
>>> Or same argument use XDP directly.
>>
>> I'm thinking it's useful for sysadmins to be able to use XDP through
>> existing kernel interfaces.
> 
> I agree its perhaps friendly to do so but for OVS not necessary and
> if sysadmins want a generic XDP flow interface someone can write one.
> Tell admins using your new tool gives 5x mpps improvement and orders
> of magnitude latency reduction and I suspect converting them over
> should be easy. Or if needed write an application in userspace that
> converts tc commands to native XDP map commands.
> 
> I think for sysadmins in general (not OVS) use case I would work
> with Jesper and Toke. They seem to be working on this specific problem.

I have talked about this in Netdev 0x13 and IIRC Jesper was somewhat 
positive on this idea...
Jesper, any thoughts?

Toshiaki Makita
