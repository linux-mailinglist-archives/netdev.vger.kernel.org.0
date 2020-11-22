Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881412BC5B4
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 13:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727848AbgKVMsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 07:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727646AbgKVMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 07:48:09 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A6BC0613CF
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 04:48:08 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id l5so14244183edq.11
        for <netdev@vger.kernel.org>; Sun, 22 Nov 2020 04:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wKBOm973gFCUjAD+VkJGzoO25Jh88Yph6PgN7ax+GFA=;
        b=npHGkv5+sd2f87y7DwcBQPhWeesXl3HcHEnsq9g/aP3MFuHqHD6echKQyq5FIbc4oK
         cggxoQmMk5fNU3MD3DfKmdXx7pcAxuryIPFYVqHV4USkEVJnbvYROFVPnCXsuhwH2GrZ
         CmT2yH176Y7Tt+NGzyLy7fZ+zRhMnSPTsLgtBg63+3J7XPDeOk4KGqeys3GBhCTANZby
         vO9vBrGHm/3QO0yO5Cc22M5CZMMCvrLowxHAklyU3T1SO9vWspl8UYpMx4X4FmiSTNSG
         d68QMqjPJky0zbIGawiKCP4SDEDRfH1BBbes79tH0zBnu16ym2VvHvPeQYPrUY0XB5nu
         ZFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wKBOm973gFCUjAD+VkJGzoO25Jh88Yph6PgN7ax+GFA=;
        b=AK6yQcOhoinfaN1SyXezLZKxfaQHkIHp6rvz2XEDzzpeYWRLqUngCeAKuImu3tEs6m
         Y/TzHtrmnYJ55p0VFoF+0OBBMckshmamk/d5FHIgS5HwN2SqweHjZ4+bJ4ThwehWAsKJ
         kQBTEZkTc1YiYVu4e3AhUysLSULQua0cSaLkTwF/rhDMJP+5g/PQ6YBD1EPZqLad2dj6
         zlt0x1ZNUz5Jn+o/zhr4rjjSFgiyUPtk0vD/Qtp/wZMkXi4NLlD9Mwu0MNVXdqYmOt/g
         33iTf1VH41hLiHsHZFQmUBn+NyogX+iyDdo7j1sXd7AzUFoHcUUVaz9bmrKme+Nq608n
         /9RA==
X-Gm-Message-State: AOAM532jz9sAaAxQfVLff7uiQBZSEJmUbEE2MD9vAjNdpTa+LomKa1MK
        4gzPvvmF35pHN+4BhNHShRw=
X-Google-Smtp-Source: ABdhPJwWdvzl/VGLQqXbXpcV9OkFuJMwuq49+CnPbzZ/ZR1qBttOJ2H27kbdBe0ONTLUIuDC2mNguw==
X-Received: by 2002:a05:6402:b02:: with SMTP id bm2mr42468304edb.299.1606049287587;
        Sun, 22 Nov 2020 04:48:07 -0800 (PST)
Received: from [192.168.0.110] ([77.127.85.120])
        by smtp.gmail.com with ESMTPSA id u23sm559132ejc.46.2020.11.22.04.48.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2020 04:48:07 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] TLS TX HW offload for Bond
To:     Jakub Kicinski <kuba@kernel.org>, Jarod Wilson <jarod@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
 <20201118160239.78871842@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <0e4a04f2-2ffa-179d-3b7b-ef08b52c9290@gmail.com>
 <20201119083811.6b68bfa8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <ee42de0e-e657-4108-3fb7-05e252979673@gmail.com>
Date:   Sun, 22 Nov 2020 14:48:04 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201119083811.6b68bfa8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/19/2020 6:38 PM, Jakub Kicinski wrote:
> On Thu, 19 Nov 2020 17:59:38 +0200 Tariq Toukan wrote:
>> On 11/19/2020 2:02 AM, Jakub Kicinski wrote:
>>> On Sun, 15 Nov 2020 15:42:49 +0200 Tariq Toukan wrote:
>>>> This series opens TLS TX HW offload for bond interfaces.
>>>> This allows bond interfaces to benefit from capable slave devices.
>>>>
>>>> The first patch adds real_dev field in TLS context structure, and aligns
>>>> usages in TLS module and supporting drivers.
>>>> The second patch opens the offload for bond interfaces.
>>>>
>>>> For the configuration above, SW kTLS keeps picking the same slave
>>>> To keep simple track of the HW and SW TLS contexts, we bind each socket to
>>>> a specific slave for the socket's whole lifetime. This is logically valid
>>>> (and similar to the SW kTLS behavior) in the following bond configuration,
>>>> so we restrict the offload support to it:
>>>>
>>>> ((mode == balance-xor) or (mode == 802.3ad))
>>>> and xmit_hash_policy == layer3+4.
>>>
>>> This does not feel extremely clean, maybe you can convince me otherwise.
>>>
>>> Can we extend netdev_get_xmit_slave() and figure out the output dev
>>> (and if it's "stable") in a more generic way? And just feed that dev
>>> into TLS handling?
>>
>> I don't see we go through netdev_get_xmit_slave(), but through
>> .ndo_start_xmit (bond_start_xmit).
> 
> I may be misunderstanding the purpose of netdev_get_xmit_slave(),
> please correct me if I'm wrong. AFAIU it's supposed to return a
> lower netdev that the skb should then be xmited on.

That's true. It was recently added and used by the RDMA team. Not used 
or integrated in the Eth networking stack.

> So what I was thinking was either construct an skb or somehow reshuffle
> the netdev_get_xmit_slave() code to take a flow dissector output or
> ${insert other ideas}. Then add a helper in the core that would drill
> down from the socket netdev to the "egress" netdev. Have TLS call
> that helper, and talk to the "egress" netdev from the start, rather
> than the socket's netdev. Then loosen the checks on software devices.

As I understand it, best if we can even generalize this to apply to all 
kinds of traffic: bond driver won't do the xmit itself anymore, it just 
picks an egress dev and returns it. The core infrastructure will call 
the xmit function for the egress dev.

I like the idea, it can generalize code structures for all kinds of 
upper-devices and sockets, taking them into a common place in core, 
which reduces code duplications.

If we go only half the way, i.e. keep xmit logic in bond for 
non-TLS-offloaded traffic, then we have to let TLS module (and others in 
the future) act deferentially for different kinds of devs (upper/lower) 
which IMHO reduces generality.

I'm in favor of the deeper change. It will be on a larger scale, and 
totally orthogonal to the current TLS offload support in bond.

If we decide to apply the idea only to TLS sockets (or any subset of 
sockets) we're actually taking a generic one-flow (the xmit patch of a 
bond dev) and turning it into two (or potentially more) flows, depending 
on the socket type. This also reduces generality.

> 
> I'm probably missing the problem you're trying to explain to me :S
> 

I kept the patch minimal, and kept the TLS offload logic internal to the 
bond driver, just like it is internal to the device drivers (mlx5e, and 
others), with no core infrastructure modification.

> Side note - Jarod, I'd be happy to take a patch renaming
> netdev_get_xmit_slave() and the ndo, if you have the cycles to send
> a patch. It's a recent addition, and in the core we should make more
> of an effort to avoid sensitive terms.
> 
>> Currently I have my check there to
>> catch all skbs belonging to offloaded TLS sockets.
>>
>> The TLS offload get_slave() logic decision is per socket, so the result
>> cannot be saved in the bond memory. Currently I save the real_dev field
>> in the TLS context structure.
> 
> Right, but we could just have ctx->netdev be the "egress" netdev
> always, right? Do we expect somewhere that it's going to be matching
> the socket's dst?
> 

So once the offload context is established we totally bypass the bond 
dev? and lose interaction or reference to it?
What if the egress dev is detached form the bond? We must then be 
notified somehow.

>> One way to make it more generic is to save it on the sock structure. I
>> agree that this replaces the TLS-specific logic, but demands increasing
>> the sock struct, and has larger impact on all other flows...
> 
