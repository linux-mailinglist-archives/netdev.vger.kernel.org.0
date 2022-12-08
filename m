Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D093D646F33
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 13:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbiLHMCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 07:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiLHMCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 07:02:15 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8651862D2
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 04:02:12 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id z92so1785418ede.1
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 04:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qz3MP8hDU1IsxsCEe+N2MZItnF0m71Vp8b1O7ckwZcA=;
        b=7iGcG4y6WEOvG7ppT7je8BwERX7JRrYwRxsJTwKO7IkUnzyhTABt2RuFROoI1/AITF
         mqhvHnUsOzwlPBMdbYE/bKMWQtZQnS/+7i0n05HCIypZhJfEvFqyxotpVFYCzJp5WBoL
         HaMUZTbLcW4vcDXjp+B8CUByJ1ACdZFF9ejZ2VUZikcblsk2B0FuH09+ZsOb6/4EDSBT
         EhBYBI71EEvP9r6g2+rD9KhzA9/re3POEVnUNqTLtp2GRlhg2Vk8m6j7XLR9yUkdpOGv
         1i8VpMfI5JP8KaPfxsbTnW++lF2X0y84l+BBocT5txuBvTrqXw8EwNpEIBYCWbC23/RS
         v6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qz3MP8hDU1IsxsCEe+N2MZItnF0m71Vp8b1O7ckwZcA=;
        b=npCkMMj1WKVldt7ySwB1Jfu5j6ZxZ6T/xSC1xWG2Ntt776lCRDgXW4TB9evJu+bNZH
         pD7CmqR3DXeE2K/Pm3s3V64Ac95yhqMs/aVWS76DLRos4hcZac4qTQqKly8HpLsDdKqT
         6NcRDMbWeBPfeFlGy21iiKNGN6gqB++q2pZLZKF3eap3jdO66V1QO/FQP+omLZkG05wq
         C/0wpaapwrgauy9PbWgQsvvtco5fOk4+sPp1n/Rx5bHxCWnckJka41iNDvhheJ20Nzq4
         H87C9qMBqIVvDFHDP7foZPP6ygXiYOiLc9rLZ1Tu2fYKO77VAqinukwc9sdkgJCv924A
         JIZA==
X-Gm-Message-State: ANoB5pljtXFCpFH93k+rail6ZOby4EIi5X+upK7wpRnvZzVTTT/ElpA8
        ofD5UdpjZaOPM3gTdC9X6HTCQA==
X-Google-Smtp-Source: AA0mqf7dmEc8cfEAKf5s+0mmMiNPbAoDNOYS0r9qBabTpzLNPaiSbpCgcK9k0zK7FwH5wNdXlo7RDg==
X-Received: by 2002:a05:6402:eaa:b0:462:c7ed:7b41 with SMTP id h42-20020a0564020eaa00b00462c7ed7b41mr2063468eda.21.1670500931147;
        Thu, 08 Dec 2022 04:02:11 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r19-20020aa7cb93000000b00463c5c32c6esm3269411edt.89.2022.12.08.04.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 04:02:10 -0800 (PST)
Date:   Thu, 8 Dec 2022 13:02:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        Vadim Fedorenko <vfedorenko@novek.ru>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y5HSQU1aCGpOZLiJ@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
 <20221206184740.28cb7627@kernel.org>
 <Y5CofhLCykjsFie6@nanopsycho>
 <20221207091946.3115742f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207091946.3115742f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 06:19:46PM CET, kuba@kernel.org wrote:
>On Wed, 7 Dec 2022 15:51:42 +0100 Jiri Pirko wrote:
>> Wed, Dec 07, 2022 at 03:47:40AM CET, kuba@kernel.org wrote:
>> >On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:  
>> >> Yep, you have the knowledge of sharing inside the driver, so you should
>> >> do it there. For multiple instances, use in-driver notifier for example.  
>> >
>> >No, complexity in the drivers is not a good idea. The core should cover
>> >the complexity and let the drivers be simple.  
>> 
>> Really, even in case only one driver actually consumes the complexicity?
>> I understand having a "libs" to do common functionality for drivers,
>> even in case there is one. But this case, I don't see any benefit.
>
>In the same email thread you admit that mlx5 has multiple devlink
>instances for the same ASIC and refuse to try to prevent similar
>situation happening in the new subsystem.

I don't understand your point. In CX there is 1 clock for 2 pci PFs. I
plan to have 1 dpll instance for the clock shared.

But how is what you write relevant to the discussion? We are talking
about:
a) 1 pin in 2 dpll instances
what I undestand you say here is to prevent:
b) 2 dpll instances for 1 clock
apples and oranges. Am I missing something?

I'm totally against b) but that is not what we discuss here, correct?


>
>> >> There are currently 3 drivers for dpll I know of. This in ptp_ocp and
>> >> mlx5 there is no concept of sharing pins. You you are talking about a
>> >> single driver.
>> >> 
>> >> What I'm trying to say is, looking at the code, the pin sharing,
>> >> references and locking makes things uncomfortably complex. You are so
>> >> far the only driver to need this, do it internally. If in the future
>> >> other driver appears, this code would be eventually pushed into dpll
>> >> core. No impact on UAPI from what I see. Please keep things as simple as
>> >> possible.  
>> >
>> >But the pin is shared for one driver. Who cares if it's not shared in
>> >another. The user space must be able to reason about the constraints.  
>> 
>> Sorry, I don't follow :/ Could you please explain what do you mean by
>> this?
>
>We don't wait with adding APIs until there is more than one driver that
>needs them.

Agreed. I was under impression that this is only kernel internals and
won't affect the UAPI. Perhaps I'm wrong.


>
>> >You are suggesting drivers to magically flip state in core objects
>> >because of some hidden dependencies?!  
>> 
>> It's not a state flip. It's more like a well propagated event of a state
>> change. The async changes may happen anyway, so the userspace needs
>> to handle them. Why is this different?
>
>What if the user space wants conflicting configurations for the muxes
>behind a shared pin?
>
>The fact that there is a notification does not solve the problem of
>user space not knowing what's going on. Why would the user space play
>guessing games if the driver _knows_ the topology and can easily tell
>it.

Okay. I get your point. This visibility is probably something nice to
have. If it weights over the added complexicity, I'm not sure. But it
looks like you are, and I don't care that much. So let's focus on
defining the shared pin model properly.


>> >> There is a big difference if we model flat list of pins with a set of
>> >> attributes for each, comparing to a tree of pins, some acting as leaf,
>> >> node and root. Do we really need such complexicity? What value does it
>> >> bring to the user to expose this?  
>> >
>> >The fact that you can't auto select from devices behind muxes.  
>> 
>> Why? What's wrong with the mechanism I described in another part of this
>> thread?
>> 
>> Extending my example from above
>> 
>>    pin 1 source
>>    pin 2 output
>>    pin 3 muxid 100 source
>>    pin 4 muxid 100 source
>>    pin 5 muxid 101 source
>>    pin 6 muxid 101 source
>>    pin 7 output
>> 
>> User now can set individial prios for sources:
>> 
>> dpll x pin 1 set prio 10
>> etc
>> The result would be:
>> 
>>    pin 1 source prio 10
>>    pin 2 output
>>    pin 3 muxid 100 source prio 8
>>    pin 4 muxid 100 source prio 20
>>    pin 5 muxid 101 source prio 50
>>    pin 6 muxid 101 source prio 60
>>    pin 7 output
>> 
>> Now when auto is enabled, the pin 3 is selected. Why would user need to
>> manually select between 3 and 4? This is should be abstracted out by the
>> driver.
>> 
>> Actually, this is neat as you have one cmd to do selection in manual
>> mode and you have uniform way of configuring/monitoring selection in
>> autosel. Would the muxed pin make this better?
>> 
>> For muxed pin being output, only one pin from mux would be set:
>> 
>>    pin 1 source
>>    pin 2 output
>>    pin 3 muxid 100 disconnected
>>    pin 4 muxid 100 disconnected
>>    pin 5 muxid 101 output
>>    pin 6 muxid 101 disconnected
>>    pin 7 output
>
>Sorry, can't parse, could you draw the diagram?

There is no diagram. It's a plain list of pins with attributes, one pin
with attributes per line.


>
>To answer the most basic question - my understanding is that for
>prio-based selection there needs to be silicon that can tell if
>there is a valid clock on the line. While mux is just a fancy switch,
>it has no complex logic, just connects wires.
>
>Arkadiusz, is my understanding incorrect? I may have "intuited" this.
>
>IDK if there are any bidirectional pins after a mux, but that'd be
>another problem. Muxes are only simple for inputs.
>
>> >The HW topology is of material importance to user space.  
>> 
>> Interesting. When I was working on linecards, you said that the user
>> does not care about the inner HW topology. And it makes sense. When
>> things could be abstracted out to make iface clean, I think they should.
>
>I recall only the FW related conversations, but what I think is key 
>is whether the information can be acted upon.

What I was refering to was the device/gearbox exposure per-linecard.

>
>> >How many times does Arkadiusz have to explain this :|  
>> 
>> Pardon my ignorance, I don't see why exactly we need mux hierarchy
>> (trees) exposed to user.
