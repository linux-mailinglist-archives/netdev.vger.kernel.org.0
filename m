Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6512C2AE8
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389615AbgKXPI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:08:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389459AbgKXPI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:08:57 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7647BC0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 07:08:57 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id a15so21239384edy.1
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 07:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sACOkTaaowoYDfpu+Z0Fkw191/0qHBjjRDqPqGw2Lj8=;
        b=Qec4BY0uA53KkoBLmaL/IS+7AGtUz6D9oPxINtwo5XduzSplAuTT/IFiHkU1IZyzac
         CkPRzV9Y1DseoNGqU+6x0sZXNAQdALOwI2LB7t9LU4WtCJDvYbvzN4E+Tm1BFZVXZieB
         8CnAIPxZ+ExVLbLKpHzFzsIohY2B1GdnyoCvsZ9Cc62vKB4YJvdH0fVCefz20IjEBLON
         h6wl14bS0wvQsevrCoko2jTWxx3VDiJJ/Kew6zqRrbhfRJQAGckwhZIY/rNCIp2UOll3
         Jy8SAHIujzS5nUJ+8m1sOkTX7xkri7LNcS3L4xnu2sCt75GpDrydX2ZRMxYbt5bNQN5l
         mvhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sACOkTaaowoYDfpu+Z0Fkw191/0qHBjjRDqPqGw2Lj8=;
        b=Xr9laE+p03wsGWQVPJ8toxciGvyFDZ8HsksfKTDG+yhH0nh3zlKyb5iL6sekRsu1pE
         s0HqtNBLygql5Kbhp5tDsWvsNebjNL/Rqgavi6nueT92dHkEmA+3zBAFGM1KiRHpVffV
         xHVisDHfH8eZ3g4O/3wtto2oMwlY7wLn2tAQ3xzaVdjGTfwKvB0FMWMp2JpsjZXPW/O6
         rdlvX/iq/OqY9CMlAQFjprp7SCUdLF7+wLJHWZvhlfV070e1ReV/J5Pt98YChY19D4/R
         Il3JNivrF2IehBlvBbpStWidjK+Ly4zBUjZo/tbwQJYS9hhkfnc4T97JMksI6QjDhVpi
         mnEA==
X-Gm-Message-State: AOAM533NGuKLblowvA92WVyaV/e/plAZlgVGCZWZIAADRB7IavYB18xT
        tEphwHjQ+nNmPqJ1mSQRdds=
X-Google-Smtp-Source: ABdhPJyql6K6NA5veLIXG+a4hskYBa194jJSlEhtcRJwGiv3fqfnS5i6oP2r51i827OyelHel/PGFQ==
X-Received: by 2002:aa7:d711:: with SMTP id t17mr4387389edq.83.1606230536160;
        Tue, 24 Nov 2020 07:08:56 -0800 (PST)
Received: from [192.168.1.110] ([77.124.63.70])
        by smtp.gmail.com with ESMTPSA id a12sm7081396edu.89.2020.11.24.07.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 07:08:55 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] TLS TX HW offload for Bond
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jarod Wilson <jarod@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
 <20201118160239.78871842@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <0e4a04f2-2ffa-179d-3b7b-ef08b52c9290@gmail.com>
 <20201119083811.6b68bfa8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <ee42de0e-e657-4108-3fb7-05e252979673@gmail.com>
 <20201123102040.338f32c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <7056d516-20a5-113b-ca04-b32d326f7742@gmail.com>
Date:   Tue, 24 Nov 2020 17:08:42 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201123102040.338f32c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/23/2020 8:20 PM, Jakub Kicinski wrote:
> On Sun, 22 Nov 2020 14:48:04 +0200 Tariq Toukan wrote:
>> On 11/19/2020 6:38 PM, Jakub Kicinski wrote:
>>> On Thu, 19 Nov 2020 17:59:38 +0200 Tariq Toukan wrote:
>>>> On 11/19/2020 2:02 AM, Jakub Kicinski wrote:
>>>>> On Sun, 15 Nov 2020 15:42:49 +0200 Tariq Toukan wrote:
>>>>>> This series opens TLS TX HW offload for bond interfaces.
>>>>>> This allows bond interfaces to benefit from capable slave devices.
>>>>>>
>>>>>> The first patch adds real_dev field in TLS context structure, and aligns
>>>>>> usages in TLS module and supporting drivers.
>>>>>> The second patch opens the offload for bond interfaces.
>>>>>>
>>>>>> For the configuration above, SW kTLS keeps picking the same slave
>>>>>> To keep simple track of the HW and SW TLS contexts, we bind each socket to
>>>>>> a specific slave for the socket's whole lifetime. This is logically valid
>>>>>> (and similar to the SW kTLS behavior) in the following bond configuration,
>>>>>> so we restrict the offload support to it:
>>>>>>
>>>>>> ((mode == balance-xor) or (mode == 802.3ad))
>>>>>> and xmit_hash_policy == layer3+4.
>>>>>
>>>>> This does not feel extremely clean, maybe you can convince me otherwise.
>>>>>
>>>>> Can we extend netdev_get_xmit_slave() and figure out the output dev
>>>>> (and if it's "stable") in a more generic way? And just feed that dev
>>>>> into TLS handling?
>>>>
>>>> I don't see we go through netdev_get_xmit_slave(), but through
>>>> .ndo_start_xmit (bond_start_xmit).
>>>
>>> I may be misunderstanding the purpose of netdev_get_xmit_slave(),
>>> please correct me if I'm wrong. AFAIU it's supposed to return a
>>> lower netdev that the skb should then be xmited on.
>>
>> That's true. It was recently added and used by the RDMA team. Not used
>> or integrated in the Eth networking stack.
>>
>>> So what I was thinking was either construct an skb or somehow reshuffle
>>> the netdev_get_xmit_slave() code to take a flow dissector output or
>>> ${insert other ideas}. Then add a helper in the core that would drill
>>> down from the socket netdev to the "egress" netdev. Have TLS call
>>> that helper, and talk to the "egress" netdev from the start, rather
>>> than the socket's netdev. Then loosen the checks on software devices.
>>
>> As I understand it, best if we can even generalize this to apply to all
>> kinds of traffic: bond driver won't do the xmit itself anymore, it just
>> picks an egress dev and returns it. The core infrastructure will call
>> the xmit function for the egress dev.
> 
> I think you went way further than I was intending :) I was only
> considering the control path. Leave the datapath unchanged.
> 
> AFAIK you're making 3 changes:
>   - forwarding tls ops
>   - pinning flows
>   - handling features
> 
> Pinning of the TLS device to a leg of the bond looks like ~15LoC.
> I think we can live with that.
> 

Good.
You mean the changes under __bond_start_xmit ?

> It's the 150 LoC of forwarding TLS ops and duplicating dev selection
> logic in bond_sk_hash_l34() that I'd rather avoid.
> 

I see.
But there are several issues with this:

1. The .ndo_get_xmit_slave acts on an SKB, not a socket. Hence, it 
doesn't fit for the stage of calling tls_dev_add, unless the ndo goes 
through some refactoring before the feature itself.

2. Existing hash logic acts on an SKB. We must have one that acts on a 
socket to be used inside get_slave(sk). Hence, I don't really see how 
the logic under bond_sk_hash_l34() are going to disappear, maybe just 
move around to a new place.


> Handling features is probably fine, too, I haven't thought about that
> much.
> 

Good.

>> I like the idea, it can generalize code structures for all kinds of
>> upper-devices and sockets, taking them into a common place in core,
>> which reduces code duplications.
>>
>> If we go only half the way, i.e. keep xmit logic in bond for
>> non-TLS-offloaded traffic, then we have to let TLS module (and others in
>> the future) act deferentially for different kinds of devs (upper/lower)
>> which IMHO reduces generality.
> 
> How so? I was expecting TLS to just do something like:
> 
> 	netdev = sk_get_xmit_dev_lowest(sk);
> 
> which would recursively call get_xmit_slave(CONST) until it reaches
> a device which doesn't resolve further.
> 
> BTW is the flow pinning to bond legs actually a must-do? I don't know
> much about bonding but wouldn't that mean that if the selected leg goes
> down we'd lose connectivity, rather than falling back to SW crypto?
> 

Right. As long as we don't have logic for un-offloading.
Currently in TLS, the device-offloaded connections has some 
"independence" once they are created, it's hard to modify them and apply 
configuration modifications to them (example: interaction with tx csum 
offload).
So I think there is a missing un-offloading mechanism in TLS that should 
address all of these together.

This fits with your comments below.

>> I'm in favor of the deeper change. It will be on a larger scale, and
>> totally orthogonal to the current TLS offload support in bond.
>>
>> If we decide to apply the idea only to TLS sockets (or any subset of
>> sockets) we're actually taking a generic one-flow (the xmit patch of a
>> bond dev) and turning it into two (or potentially more) flows, depending
>> on the socket type. This also reduces generality.
> 
> I don't follow this part.
> 
>>> I'm probably missing the problem you're trying to explain to me :S
>>
>> I kept the patch minimal, and kept the TLS offload logic internal to the
>> bond driver, just like it is internal to the device drivers (mlx5e, and
>> others), with no core infrastructure modification.
>>
>>> Side note - Jarod, I'd be happy to take a patch renaming
>>> netdev_get_xmit_slave() and the ndo, if you have the cycles to send
>>> a patch. It's a recent addition, and in the core we should make more
>>> of an effort to avoid sensitive terms.
>>>    
>>>> Currently I have my check there to
>>>> catch all skbs belonging to offloaded TLS sockets.
>>>>
>>>> The TLS offload get_slave() logic decision is per socket, so the result
>>>> cannot be saved in the bond memory. Currently I save the real_dev field
>>>> in the TLS context structure.
>>>
>>> Right, but we could just have ctx->netdev be the "egress" netdev
>>> always, right? Do we expect somewhere that it's going to be matching
>>> the socket's dst?
>>
>> So once the offload context is established we totally bypass the bond
>> dev? and lose interaction or reference to it?
> 
> Yup, I don't think we need it.
> 
>> What if the egress dev is detached form the bond? We must then be
>> notified somehow.
> 
> Do we notify TLS when routing changes? I think it's a separate topic.
> 
> If we have the code to "un-offload" a flow we could handle clearing
> features better and notify from sk_validate_xmit_skb that the flow
> started hitting unexpected dev, hence it should be re-offloaded.
> 
> I don't think we need an explicit invalidation from the particular
> drivers here.
> 

Agree.
