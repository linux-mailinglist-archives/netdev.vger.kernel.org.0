Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3729964A2B4
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 14:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiLLN67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 08:58:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233309AbiLLN6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 08:58:53 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB682FD7
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 05:58:50 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso5245431wmo.1
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 05:58:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=SrwQ/Z4IreXW+hFxY6PA7uZd/VCLbBUnFznKWdDotp8=;
        b=X/2sLRBjQ6U2PUOiuvTlhlKbZ9MAIT48e7tuvdfZYc2GfTVSLMe5YelNw1pdhp/Rl0
         /3DrWvybkA1gdHu6FeW1Kkl8FQ4PN4vDRb6DQsQMIAGLE+agqhgKs1YnIN4FHVP2eSPV
         fN6P7OWMMrXMpIiHaoS1tohZ/ldlr+14TU6gpbLsprtkR8fghASAVNBDENl5CDj+ZVLf
         ZrtJ60s8DLKwazjCbFRODmvp9kf9SnJbJWR7wkg7c9JfNym4rj8V19cvlxv9O1Fyi0Ew
         tky7tmmezS83sPCh85Jka361QWzVYnS1/4xG8j4wEliCBMU7GmUlr9KVM1tSZdHjZAGH
         R6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SrwQ/Z4IreXW+hFxY6PA7uZd/VCLbBUnFznKWdDotp8=;
        b=vzzm60GdEMPi0lhf/vMhd+a33Xoc73KT30dySWwCQNVVGJYGw64TlTsCC09lhPjVD+
         hfHNzc3/p1o6dH5qIAQpnLGRK+UJsGe0W0vygObnH21LNh2QhberUh5LCQfD4xrmJTyH
         paW9d5ulK70HiNJNw50zHSNaiHylSZoyOSCSmL/mN2nLfmX3cF5hM1Zo6N7gKYOrpQKE
         fzQtQLCiwkf7ZsBPUxyotPMt863KwEUVGH0WHQJlnmWVOtgSjdGvjdbpgY4n95y+BRH4
         r41ciAaf6eZ3tsXD8OniRCTW0prD5yr4OjM8A9ClHSbIjTWgnK7DLrhx290MOWG/izm4
         VMQQ==
X-Gm-Message-State: ANoB5pkWGXi71U+f7sXThM4VEM0hErMaQu/boMLKKqlxxWm5ue7weizN
        HjIjmm/JL6lqCKgdm03+mu+W17IV0qKDKZS+E3DJ+A==
X-Google-Smtp-Source: AA0mqf6XAGOuVepLC5bcp6CjC+gBwt+ZuvWZE1L7CAhX0Z34rq43pHR19ttU9uAYyaSsdVhxkhBOUA==
X-Received: by 2002:a1c:7c15:0:b0:3cf:7197:e67c with SMTP id x21-20020a1c7c15000000b003cf7197e67cmr12189388wmc.25.1670853529485;
        Mon, 12 Dec 2022 05:58:49 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id m5-20020a05600c4f4500b003d1e1f421bfsm10159615wmq.10.2022.12.12.05.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 05:58:48 -0800 (PST)
Date:   Mon, 12 Dec 2022 14:58:47 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Maciek Machnikowski <maciek@machnikowski.net>,
        "'Kubalewski, Arkadiusz'" <arkadiusz.kubalewski@intel.com>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        'Paolo Abeni' <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Message-ID: <Y5czl6HgY2GPKR4v@nanopsycho>
References: <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
 <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221209083104.2469ebd6@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Dec 09, 2022 at 05:31:04PM CET, kuba@kernel.org wrote:
>On Fri, 9 Dec 2022 15:09:08 +0100 Maciek Machnikowski wrote:
>> On 12/9/2022 12:07 PM, Jiri Pirko wrote:
>> > Looking at the documentation of the chips, they all have mupltiple DPLLs
>> > on a die. Arkadiusz, in your proposed implementation, do you model each
>> > DPLL separatelly? If yes, then I understand the urgency of need of a
>> > shared pin. So all DPLLs sharing the pin are part of the same chip?
>> > 
>> > Question: can we have an entity, that would be 1:1 mapped to the actual
>> > device/chip here? Let's call is "a synchronizer". It would contain
>> > multiple DPLLs, user-facing-sources(input_connector),
>> > user-facing-outputs(output_connector), i/o pins.
>> > 
>> > An example:
>> >                                SYNCHRONIZER
>> > 
>> >                               ┌───────────────────────────────────────┐
>> >                               │                                       │
>> >                               │                                       │
>> >   SyncE in connector          │              ┌─────────┐              │     SyncE out connector
>> >                 ┌───┐         │in pin 1      │DPLL_1   │     out pin 1│    ┌───┐
>> >                 │   ├─────────┼──────────────┤         ├──────────────┼────┤   │
>> >                 │   │         │              │         │              │    │   │
>> >                 └───┘         │              │         │              │    └───┘
>> >                               │              │         │              │
>> >                               │           ┌──┤         │              │
>> >    GNSS in connector          │           │  └─────────┘              │
>> >                 ┌───┐         │in pin 2   │                  out pin 2│     EXT SMA connector
>> >                 │   ├─────────┼───────────┘                           │    ┌───┐
>> >                 │   │         │                           ┌───────────┼────┤   │
>> >                 └───┘         │                           │           │    │   │
>> >                               │                           │           │    └───┘
>> >                               │                           │           │
>> >    EXT SMA connector          │                           │           │
>> >                 ┌───┐   mux   │in pin 3      ┌─────────┐  │           │
>> >                 │   ├────┬────┼───────────┐  │         │  │           │
>> >                 │   │    │    │           │  │DPLL_2   │  │           │
>> >                 └───┘    │    │           │  │         │  │           │
>> >                          │    │           └──┤         ├──┘           │
>> >                          │    │              │         │              │
>> >    EXT SMA connector     │    │              │         │              │
>> >                 ┌───┐    │    │              │         │              │
>> >                 │   ├────┘    │              └─────────┘              │
>> >                 │   │         │                                       │
>> >                 └───┘         └───────────────────────────────────────┘
>> > 
>> > Do I get that remotelly correct?  
>> 
>> It looks goot, hence two corrections are needed:
>> - all inputs can go to all DPLLs, and a single source can drive more
>>   than one DPLL
>> - The external mux for SMA connector should not be a part of the
>>   Synchronizer subsystem - I believe there's already a separate MUX
>>   subsystem in the kernel and all external connections should be handled
>>   by a devtree or a similar concept.
>> 
>> The only "muxing" thing that could potentially be modeled is a
>> synchronizer output to synchronizer input relation. Some synchronizers
>> does that internally and can use the output of one DPLL as a source for
>> another.
>
>My experience with DT and muxes is rapidly aging, have you worked with
>those recently? From what I remember the muxes were really.. "embedded"
>and static compared to what we want here.

Why do you think we need something "non-static"? The mux is part of the
board, isn't it? That sounds quite static to me.


>
>Using DT may work nicely for defining the topology, but for config we
>still need a different mechanism.

"config" of what? Each item in topology would be configure according to
the item type, won't it?

[...]
