Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28080645CEC
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 15:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiLGOvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 09:51:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbiLGOvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 09:51:50 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4294E6B9
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 06:51:45 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ud5so14586323ejc.4
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 06:51:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YOoLyltdiLP2JEEnnOjDDBjmowt4f2XyOeFTDUjuF0o=;
        b=8LPvLa5f8GWVmsFwwTg1U5kbOjmfPOIweDVg0JgDkU66U1Ai1CbGUzeH5erXRynjOi
         bpCw2zeV3JTSuD4QxVcpaCSD65NM5j/LicODL+gOZ/fyGnZm2JdE/LAmtPIs08k3OafD
         gzY126/r2xXz3k3USm6gxKL86ySXNxid+nHRkNG9XNIXdoisTW6DyfyWeTrF+CE7MuvH
         phmUUNN96h8w6chWW22UHnVkGmKHWUs1ME3SN0+GJGAZs1eY3Peh+8H1UGD9QwSobNdY
         kNDYVcWIBg/M02ThYpRLRfaSzbvWC9q7qVOtW8q9ueoTalt19EPU8s/8Tbgnk1gMB+Bs
         oX/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOoLyltdiLP2JEEnnOjDDBjmowt4f2XyOeFTDUjuF0o=;
        b=1Q2kQ3SnaFzJODUnjWzkczUvhLwX3WBO3MQH59ECs472+OvjlHqPypi5S/D3OC2mLO
         GlphAd+oxO4/7sKtNy9vOuaHXqMaHuKrPuq2W9snU3hH0Pqmwd7YdN+3bIaza1RJn95o
         /fgx/kzRa1Uk2PgU3185bl0Bs3xpJF2PgvmwGwCp1K1aoFGEQxp378p04cF5UsQWSeE+
         wmOeZloCrQbMTxtUCNmwK24lqn01R8FYYNEQ6e1HXunxkVz2OSKsZQZyTDuDeELLtQgk
         rWeeCgOGSPvbss8pSzwqpM/3WBvOA8zcVj037Xa1mNd6VsZue3hGC1LAFP9D9H8IESU1
         YB9A==
X-Gm-Message-State: ANoB5pk6W633maLJcqWjqiBIQ0jrhtjD1YUgJ/Tvue8Vp11qXDFN3V3N
        EqFzbr2V4u6zbpvONl/8zUZVvg==
X-Google-Smtp-Source: AA0mqf4OhmBvoNlAGnMbABNrcBrV4WGf+zkPhfefEbSuw49mlb/2DuiPLNVZwEQyVvDzmJlJx3pPTA==
X-Received: by 2002:a17:906:39c8:b0:7ad:79c0:5482 with SMTP id i8-20020a17090639c800b007ad79c05482mr67114184eje.730.1670424704218;
        Wed, 07 Dec 2022 06:51:44 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s26-20020a056402015a00b00461bacee867sm2294555edu.25.2022.12.07.06.51.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:51:43 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:51:42 +0100
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
Message-ID: <Y5CofhLCykjsFie6@nanopsycho>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
 <20221206184740.28cb7627@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206184740.28cb7627@kernel.org>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Dec 07, 2022 at 03:47:40AM CET, kuba@kernel.org wrote:
>On Fri, 2 Dec 2022 17:12:06 +0100 Jiri Pirko wrote:
>> >But this is only doable with assumption, that the board is internally capable
>> >of such internal board level communication, which in case of separated
>> >firmwares handling multiple dplls might not be the case, or it would require
>> >to have some other sw component feel that gap.  
>> 
>> Yep, you have the knowledge of sharing inside the driver, so you should
>> do it there. For multiple instances, use in-driver notifier for example.
>
>No, complexity in the drivers is not a good idea. The core should cover
>the complexity and let the drivers be simple.

Really, even in case only one driver actually consumes the complexicity?
I understand having a "libs" to do common functionality for drivers,
even in case there is one. But this case, I don't see any benefit.


>
>> >For complex boards with multiple dplls/sync channels, multiple ports,
>> >multiple firmware instances, it seems to be complicated to share a pin if
>> >each driver would have own copy and should notify all the other about changes.
>> >
>> >To summarize, that is certainly true, shared pins idea complicates stuff
>> >inside of dpll subsystem.
>> >But at the same time it removes complexity from all the drivers which would use  
>> 
>> There are currently 3 drivers for dpll I know of. This in ptp_ocp and
>> mlx5 there is no concept of sharing pins. You you are talking about a
>> single driver.
>> 
>> What I'm trying to say is, looking at the code, the pin sharing,
>> references and locking makes things uncomfortably complex. You are so
>> far the only driver to need this, do it internally. If in the future
>> other driver appears, this code would be eventually pushed into dpll
>> core. No impact on UAPI from what I see. Please keep things as simple as
>> possible.
>
>But the pin is shared for one driver. Who cares if it's not shared in
>another. The user space must be able to reason about the constraints.

Sorry, I don't follow :/ Could you please explain what do you mean by
this?

>
>You are suggesting drivers to magically flip state in core objects
>because of some hidden dependencies?!

It's not a state flip. It's more like a well propagated event of a state
change. The async changes may happen anyway, so the userspace needs
to handle them. Why is this different?


>
>> >it and is easier for the userspace due to common identification of pins.  
>> 
>> By identification, you mean "description" right? I see no problem of 2
>> instances have the same pin "description"/label.
>>
>> >This solution scales up without any additional complexity in the driver,
>> >and without any need for internal per-board communication channels.
>> >
>> >Not sure if this is good or bad, but with current version, both approaches are
>> >possible, so it pretty much depending on the driver to initialize dplls with
>> >separated pin objects as you have suggested (and take its complexity into
>> >driver) or just share them.
>> >  
>> >>
>> >>3) I don't like the concept of muxed pins and hierarchies of pins. Why
>> >>   does user care? If pin is muxed, the rest of the pins related to this
>> >>   one should be in state disabled/disconnected. The user only cares
>> >>   about to see which pins are related to each other. It can be easily
>> >>   exposed by "muxid" like this:
>> >>   pin 1
>> >>   pin 2
>> >>   pin 3 muxid 100
>> >>   pin 4 muxid 100
>> >>   pin 5 muxid 101
>> >>   pin 6 muxid 101
>> >>   In this example pins 3,4 and 5,6 are muxed, therefore the user knows
>> >>   if he connects one, the other one gets disconnected (or will have to
>> >>   disconnect the first one explicitly first).
>> >
>> >Currently DPLLA_PIN_PARENT_IDX is doing the same thing as you described, it
>> >groups MUXed pins, the parent pin index here was most straightforward to me,  
>> 
>> There is a big difference if we model flat list of pins with a set of
>> attributes for each, comparing to a tree of pins, some acting as leaf,
>> node and root. Do we really need such complexicity? What value does it
>> bring to the user to expose this?
>
>The fact that you can't auto select from devices behind muxes.

Why? What's wrong with the mechanism I described in another part of this
thread?

Extending my example from above

   pin 1 source
   pin 2 output
   pin 3 muxid 100 source
   pin 4 muxid 100 source
   pin 5 muxid 101 source
   pin 6 muxid 101 source
   pin 7 output

User now can set individial prios for sources:

dpll x pin 1 set prio 10
etc
The result would be:

   pin 1 source prio 10
   pin 2 output
   pin 3 muxid 100 source prio 8
   pin 4 muxid 100 source prio 20
   pin 5 muxid 101 source prio 50
   pin 6 muxid 101 source prio 60
   pin 7 output

Now when auto is enabled, the pin 3 is selected. Why would user need to
manually select between 3 and 4? This is should be abstracted out by the
driver.

Actually, this is neat as you have one cmd to do selection in manual
mode and you have uniform way of configuring/monitoring selection in
autosel. Would the muxed pin make this better?

For muxed pin being output, only one pin from mux would be set:

   pin 1 source
   pin 2 output
   pin 3 muxid 100 disconnected
   pin 4 muxid 100 disconnected
   pin 5 muxid 101 output
   pin 6 muxid 101 disconnected
   pin 7 output


>The HW topology is of material importance to user space.

Interesting. When I was working on linecards, you said that the user
does not care about the inner HW topology. And it makes sense. When
things could be abstracted out to make iface clean, I think they should.


>How many times does Arkadiusz have to explain this :|

Pardon my ignorance, I don't see why exactly we need mux hierarchy
(trees) exposed to user.

