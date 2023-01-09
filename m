Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801F1662B40
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 17:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbjAIQat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 11:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbjAIQap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 11:30:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F391869E
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 08:30:26 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so10180296pjj.4
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 08:30:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WtRT+wwwKvHWECOr7HcCnX4J5vFUq9c9V1yolIUSEGo=;
        b=0z3/3/A9lynNElzxD/uqnFXGW/31Ie7nEDika90bnMQHxp/F1SC1MyP9xNGhQo9oui
         kj6OXgpjoOQJduyPPEyqQHHL4g78xPCQa7YsxlF9qFuifJZUb/ccOGdjL4ag6IBl+Znd
         Ok8/Y9fBd2ecPMWnTe3/XyKYEOVgjIUYlB+gUXiuzJDypxlQtZYTI+kXgMuBuVNYZ6kV
         4rhWoIKXdDIZ6b2noMto28aS70uP19b5AhPMkc7Oz+izmH8fW8BGf7yqysp3Vi1agl66
         xwYx23azw+477pIaOWjlgM9W8P8ipjEuXDTwB6egVMGHZqrDzUMfnsaV6A0qIVNxNBAI
         sSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WtRT+wwwKvHWECOr7HcCnX4J5vFUq9c9V1yolIUSEGo=;
        b=oMTpb25jSxiV38uFNNrLykpfk/Eh0P7yvHEjhATAvDV6S2AxxEDUdMM7rfNuHmIvSx
         oZp7ZWP/nCTJrtuNcdnhPPUDtGuYxzFrvNJWk1abO7qqpOf75WG6AQx3DQWESlsBcRmL
         g72ljwCDaWXFrqemiGNWzCncCg9lmvTDpDMvkTMZCmDQ2fkMC8KS8sCc7GCmvlqNBz1L
         3msQ0kjZVKtAtwsPLurooY29oluOUpASJ1ybi1K+QaEoBSQmTY35YDz5S2h+sW9Sb3KD
         NeI11XB17w8K5DKAOOXWnNV3MgZ+zieuf/FNvWlgfLe17NEFSmoklMmb8GZLWBHH36u8
         HojA==
X-Gm-Message-State: AFqh2koBKKv0JXYR4z+TmxM/Nwm52fJBJoKBLvDaEe2sBtD46XRFXBl6
        2kvkgAQkIXRT8RUxvu+SweX59Q==
X-Google-Smtp-Source: AMrXdXuXGd/rX6Uz/geXG3OE+/fYoWxsnnM+3qiSrZ0b6rxBD+RuG70T1nHtrCR1xjM0XqP8JYLyvw==
X-Received: by 2002:a17:90a:a618:b0:210:ccdf:2952 with SMTP id c24-20020a17090aa61800b00210ccdf2952mr68582504pjq.28.1673281825459;
        Mon, 09 Jan 2023 08:30:25 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id ct14-20020a17090af58e00b00219186abd7csm5766795pjb.16.2023.01.09.08.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 08:30:24 -0800 (PST)
Date:   Mon, 9 Jan 2023 17:30:22 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Maciek Machnikowski <maciek@machnikowski.net>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y7xBHtR3XwfAahry@nanopsycho>
References: <Y4oj1q3VtcQdzeb3@nanopsycho>
 <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org>
 <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Jan 09, 2023 at 03:43:01PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Monday, December 12, 2022 2:59 PM
>>
>>Fri, Dec 09, 2022 at 05:31:04PM CET, kuba@kernel.org wrote:
>>>On Fri, 9 Dec 2022 15:09:08 +0100 Maciek Machnikowski wrote:
>>>> On 12/9/2022 12:07 PM, Jiri Pirko wrote:
>>>> > Looking at the documentation of the chips, they all have mupltiple
>>DPLLs
>>>> > on a die. Arkadiusz, in your proposed implementation, do you model
>>each
>>>> > DPLL separatelly? If yes, then I understand the urgency of need of a
>>>> > shared pin. So all DPLLs sharing the pin are part of the same chip?
>>>> >
>>>> > Question: can we have an entity, that would be 1:1 mapped to the
>>actual
>>>> > device/chip here? Let's call is "a synchronizer". It would contain
>>>> > multiple DPLLs, user-facing-sources(input_connector),
>>>> > user-facing-outputs(output_connector), i/o pins.
>>>> >
>>>> > An example:
>>>> >                                SYNCHRONIZER
>>>> >
>>>> >
>>┌───────────────────────────────────────┐
>>>> >                               │
>>│
>>>> >                               │
>>│
>>>> >   SyncE in connector          │              ┌─────────┐
>>│     SyncE out connector
>>>> >                 ┌───┐         │in pin 1      │DPLL_1   │     out pin
>>1│    ┌───┐
>>>> >                 │   ├─────────┼──────────────┤
>>├──────────────┼────┤   │
>>>> >                 │   │         │              │         │
>>│    │   │
>>>> >                 └───┘         │              │         │
>>│    └───┘
>>>> >                               │              │         │
>>│
>>>> >                               │           ┌──┤         │
>>│
>>>> >    GNSS in connector          │           │  └─────────┘
>>│
>>>> >                 ┌───┐         │in pin 2   │                  out pin
>>2│     EXT SMA connector
>>>> >                 │   ├─────────┼───────────┘
>>│    ┌───┐
>>>> >                 │   │         │
>>┌───────────┼────┤   │
>>>> >                 └───┘         │                           │
>>│    │   │
>>>> >                               │                           │
>>│    └───┘
>>>> >                               │                           │
>>│
>>>> >    EXT SMA connector          │                           │
>>│
>>>> >                 ┌───┐   mux   │in pin 3      ┌─────────┐  │
>>│
>>>> >                 │   ├────┬────┼───────────┐  │         │  │
>>│
>>>> >                 │   │    │    │           │  │DPLL_2   │  │
>>│
>>>> >                 └───┘    │    │           │  │         │  │
>>│
>>>> >                          │    │           └──┤         ├──┘
>>│
>>>> >                          │    │              │         │
>>│
>>>> >    EXT SMA connector     │    │              │         │
>>│
>>>> >                 ┌───┐    │    │              │         │
>>│
>>>> >                 │   ├────┘    │              └─────────┘
>>│
>>>> >                 │   │         │
>>│
>>>> >                 └───┘
>>└───────────────────────────────────────┘
>>>> >
>>>> > Do I get that remotelly correct?
>>>>
>>>> It looks goot, hence two corrections are needed:
>>>> - all inputs can go to all DPLLs, and a single source can drive more
>>>>   than one DPLL
>>>> - The external mux for SMA connector should not be a part of the
>>>>   Synchronizer subsystem - I believe there's already a separate MUX
>>>>   subsystem in the kernel and all external connections should be handled
>>>>   by a devtree or a similar concept.
>>>>
>>>> The only "muxing" thing that could potentially be modeled is a
>>>> synchronizer output to synchronizer input relation. Some synchronizers
>>>> does that internally and can use the output of one DPLL as a source for
>>>> another.
>>>
>>>My experience with DT and muxes is rapidly aging, have you worked with
>>>those recently? From what I remember the muxes were really.. "embedded"
>>>and static compared to what we want here.
>>
>>Why do you think we need something "non-static"? The mux is part of the
>>board, isn't it? That sounds quite static to me.
>>
>>
>>>
>>>Using DT may work nicely for defining the topology, but for config we
>>>still need a different mechanism.
>>
>>"config" of what? Each item in topology would be configure according to
>>the item type, won't it?
>>
>>[...]
>
>
>Hi guys,
>
>We have been trying to figure out feasibility of new approach proposed on our
>latest meeting - to have a single object which encapsulates multiple DPLLs.
>
>Please consider following example:
>
>Shared common inputs:                                      
>i0 - GPS  / external                                       
>i1 - SMA1 / external                                       
>i2 - SMA2 / external                                       
>i3 - MUX0 / clk recovered from PHY0.X driven by MAC0       
>i4 - MUX1 / clk recovered from PHY1.X driven by MAC1       
>
>+---------------------------------------------------------+
>| Channel A / FW0             +---+                       |
>|                         i0--|   |                       |
>|         +---+               |   |                       |
>| PHY0.0--|   |           i1--| D |                       |
>|         |   |               | P |                       |
>| PHY0.1--| M |           i2--| L |   +---+   +--------+  |
>|         | U |               | L |---|   |---| PHY0.0 |--|
>| PHY0.2--| X |-+---------i3--| 0 |   |   |   +--------+  |
>|         | 0 | |+------+     |   |---| M |---| PHY0.1 |--|
>| ...   --|   | || MUX1 |-i4--|   |   | A |   +--------+  |
>|         |   | |+------+     +---+   | C |---| PHY0.2 |--|
>| PHY0.7--|   | |         i0--|   |   | 0 |   +--------+  |
>|         +---+ |             |   |---|   |---| ...    |--|
>|               |         i1--| D |   |   |   +--------+  |
>|               |             | P |---|   |---| PHY0.7 |--|
>|               |         i2--| L |   +---+   +--------+  |
>|               |             | L |                       |
>|               \---------i3--| 1 |                       |
>|                +------+     |   |                       |
>|                | MUX1 |-i4--|   |                       |
>|                +------+     +---+                       |
>+---------------------------------------------------------+
>| Channel B / FW1             +---+                       |
>|                         i0--|   |                       |
>|                             |   |                       |
>|                         i1--| D |                       |
>|         +---+               | P |                       |
>| PHY1.0--|   |           i2--| L |   +---+   +--------+  |
>|         |   |  +------+     | L |---|   |---| PHY1.0 |--|
>| PHY1.1--| M |  | MUX0 |-i3--| 0 |   |   |   +--------+  |
>|         | U |  +------+     |   |---| M |---| PHY1.1 |--|
>| PHY1.2--| X |-+---------i4--|   |   | A |   +--------+  |
>|         | 1 | |             +---+   | C |---| PHY1.2 |--|
>| ...   --|   | |         i0--|   |   | 1 |   +--------+  |
>|         |   | |             |   |---|   |---| ...    |--|
>| PHY1.7--|   | |         i1--| D |   |   |   +--------+  |
>|         +---+ |             | P |---|   |---| PHY1.7 |--|
>|               |         i2--| L |   +---+   +--------+  |
>|               |+------+     | L |                       |
>|               || MUX0 |-i3--| 1 |                       |
>|               |+------+     |   |                       |
>|               \---------i4--|   |                       |
>|                             +---+                       |
>+---------------------------------------------------------+

What is "a channel" here? Are these 2 channels part of the same physival
chip? Could you add the synchronizer chip/device entities to your drawing?


>
>This is a simplified network switch board example.
>It has 2 synchronization channels, where each channel:
>- provides clk to 8 PHYs driven by separated MAC chips,
>- controls 2 DPLLs.
>
>Basically only given FW has control over its PHYs, so also a control over it's
>MUX inputs.
>All external sources are shared between the channels.
>
>This is why we believe it is not best idea to enclose multiple DPLLs with one
>object:
>- sources are shared even if DPLLs are not a single synchronizer chip,
>- control over specific MUX type input shall be controllable from different
>driver/firmware instances.
>
>As we know the proposal of having multiple DPLLs in one object was a try to
>simplify currently implemented shared pins. We fully support idea of having
>interfaces as simple as possible, but at the same time they shall be flexible
>enough to serve many use cases.
>
>Right now the use case of single "synchronizer chip" is possible (2 DPLLs with
>shared inputs), as well as multiple synchronizer chips with shared inputs.
>
>If we would entirely get rid of sharing pins idea and instead allowed only to
>have multiple DPLLs in one object, we would fall back to the problem where
>change on one input is braking another "synchronizer chip" input.
>I.e. considering above scheme, user configured both channels to use SMA1 1MHz.
>If SMA1 input is changed to 10MHz, all DPLLs are affected, thus all using that

You say "SMA1 input *is changed*". Could you add to your drawing:
1) Who is the one triggering the change.
2) Entity that manages the SMA input and applies the configuration.


>input shall be notified, as long as that input is shared.
>For the drivers that have single point of control over dpll, they might just
>skip those requests. But if there are multiple firmware instances controlling
>multiple DPLLs, they would process it independently.
>
>Current implementation is the most flexible and least complex for the level of
>flexibility it provides.
>
>BR, Happy new year!
>Arkadiusz
