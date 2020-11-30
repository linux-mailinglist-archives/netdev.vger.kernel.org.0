Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1C12C7EC4
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 08:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgK3Hgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 02:36:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgK3Hgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 02:36:41 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC627C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 23:36:00 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id 38so7310666edr.8
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 23:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=016co89yrxcr+ysmztL/MSBpSEQ5mWM8UKNhRdgsrxg=;
        b=pbQrIYPBX/EmlO7/ENdLohfw+C+bDuOoZ3FGtZaunuNUFi4vP4JkZpLxc2cVw4YFXl
         ujgvMFBJx9qBDlnTy0vuGcZNXVpTDFUVVny88xIwponhef7afYBXMCmEInw1VSfbWe4K
         dv9fPiiDVDltXp0TmIOzuLAKUgSyfywX6P9Tg01Urk/GzkNrWndZFkkVC7hqveSdhCng
         zhi6nt6FBYZ2b1P6S2yj4i18hAx4/eqa/tKvm27I++Ol1YVtAVI3tP7opGrOgvmJSOVn
         YML5u6FmigvRPEbsLNlD1d64JMI/reCy0pe0jaTlf3eB70rhuhLpigmotuT9qFvRKLE2
         OiJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=016co89yrxcr+ysmztL/MSBpSEQ5mWM8UKNhRdgsrxg=;
        b=UZd60OK0oWvHy3x2WL4X6YmMJbo5y0HnTIEGKZ1kWq+qAX5magM/7zLa3yZE0Lh9aV
         j3NXpaIbI3svnRwzH2VuEFp6ipO/kuoxJVdLkPbCLgUrZbLvGaBGi/z2xEEUTTIaOjca
         2DnXmWlzwCHzTjrddvlMlJyWzPmTa6QvjrzSLILg3hpsPS6SiwNO2MpIUD71jDcrFeIb
         rpZEzO0xTlIh0+HQh9lbG8TpAO79FFdcyOE54KXQyOTMR2+YQDxDEJzrEuhqO/rSX9Iz
         aO+gC1ThtB6F9hrGs0x/vUo1tLG3eoTRmbd95+UhV8eOvUMjWABfVclN0Ire0+g74lWU
         hFfA==
X-Gm-Message-State: AOAM532D2qWQOTZDJ5BZVHuOwV+wArZyvzaj7mSZobxyKCDSfyBgDbcI
        bw3Rg1tpJMFgqGmoRgte0G4=
X-Google-Smtp-Source: ABdhPJxaMDBZhi6gh2QU1zbYvIUc6q8EJJ+XyDJnSGwMHaNrv2BSNpGEFU5ij0kZQu0dNWMm/ptY/Q==
X-Received: by 2002:aa7:da01:: with SMTP id r1mr20527935eds.45.1606721759292;
        Sun, 29 Nov 2020 23:35:59 -0800 (PST)
Received: from [132.68.43.131] ([132.68.43.131])
        by smtp.gmail.com with ESMTPSA id q19sm8199318ejz.90.2020.11.29.23.35.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 23:35:58 -0800 (PST)
Subject: Re: [PATCH net-next 0/2] TLS TX HW offload for Bond
To:     Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>
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
From:   Boris Pismenny <borispismenny@gmail.com>
Message-ID: <4cbebace-2c97-cdd3-384e-f52492b298b7@gmail.com>
Date:   Mon, 30 Nov 2020 09:35:56 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201123102040.338f32c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/11/2020 20:20, Jakub Kicinski wrote:
> On Sun, 22 Nov 2020 14:48:04 +0200 Tariq Toukan wrote:
>>
>> As I understand it, best if we can even generalize this to apply to all 
>> kinds of traffic: bond driver won't do the xmit itself anymore, it just 
>> picks an egress dev and returns it. The core infrastructure will call 
>> the xmit function for the egress dev.
> I think you went way further than I was intending :) I was only
> considering the control path. Leave the datapath unchanged.
>
> AFAIK you're making 3 changes:
>  - forwarding tls ops
>  - pinning flows
>  - handling features
>
> Pinning of the TLS device to a leg of the bond looks like ~15LoC.
> I think we can live with that.
>
> It's the 150 LoC of forwarding TLS ops and duplicating dev selection
> logic in bond_sk_hash_l34() that I'd rather avoid.
>
> Handling features is probably fine, too, I haven't thought about that
> much.

Sorry for jumping in late, but I'd like to present an argument in favor of the approach in the original patch-set, as it may have been overlooked.

The forwarding of TLS ops approach is very flexible, and it will enable support for per-SKB hashing in the future (high-availability): This will require taking ooo_okay into consideration and offloading the context to more than one NIC. But, I think its doable. Even though this approach requires more lines of code, it is already used by other offloads. For instance, XFRM offload in bond_main.c.


>> I like the idea, it can generalize code structures for all kinds of 
>> upper-devices and sockets, taking them into a common place in core, 
>> which reduces code duplications.
>>
>> If we go only half the way, i.e. keep xmit logic in bond for 
>> non-TLS-offloaded traffic, then we have to let TLS module (and others in 
>> the future) act deferentially for different kinds of devs (upper/lower) 
>> which IMHO reduces generality.
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

It is definitely not a must, and I think we should remove it in the future, once the use-case presents itself.


>> What if the egress dev is detached form the bond? We must then be 
>> notified somehow.
> Do we notify TLS when routing changes? I think it's a separate topic. 
>
> If we have the code to "un-offload" a flow we could handle clearing
> features better and notify from sk_validate_xmit_skb that the flow
> started hitting unexpected dev, hence it should be re-offloaded.
>
> I don't think we need an explicit invalidation from the particular
> drivers here.

Even though re-offload is not exercised, it is possible:
if packets are not using offload by the old netdev, then remove offload from it, and add offload to the new netdev.
A resync, will likely follow, after which offload continue on the new netdev.

The question is who identifies/decides when to re-offload. One option is that the bond driver will trigger it.



