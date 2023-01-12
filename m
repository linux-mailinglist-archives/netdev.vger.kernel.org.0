Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025FD667851
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 15:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240083AbjALO6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 09:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240155AbjALO5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 09:57:36 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB3E625D4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:43:53 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ss4so38016480ejb.11
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ+8HHMtBhm4FR1fBsHJK63o1abNxUgWSrPVOH5d3iw=;
        b=DoEmtYJQGonS61K6saGJQpRl1ps1UfR3y5aUXY6FfjIuBPpg10sTz5IL/L+f7Y5WA3
         u5zRK4mXI+VlhEKi+TdT4y7oXIlmlYsr5CR4MuXxXZUdOnD1ViU8hO2cAZI4pbHI7YLj
         PcnGtOnl5yjFVe8RaH7/0P4TNYwd/3NsgAzoyCY3o/jbNlRF+h5EIvwyMmnSpsriQFwY
         Lvzw/uVQ5/RAzTuhO3mUlCzIipfpSz1qUuKLhdM6FW4od80MkKs2f+FFaoeBqFuNDa9O
         4z7BkA43AVFb+qGHkzK9kZqkqnWI3lkKj8bnjA3tchIVx2U/prFNRvA8VtLgLjtIpt/D
         TBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZ+8HHMtBhm4FR1fBsHJK63o1abNxUgWSrPVOH5d3iw=;
        b=4/vk3z7ivs2oSgI9yA/i4nN0HyBa7gYSBqY2TO1p5sViG+XAjtw0vmftyJhIF+qZmk
         UTxFuBJIE0K2NbLSQFAmYEGt/g12tUw9wMPkollcJMwgkPiRx/tnf+YxgBeGlzmiNd0T
         aR30kboU3Wp2Gy/jsU9wtSkMk6j00R3Gg9xivX9m2VmE+vywbolmkS6dqbADbOpX7T4o
         UKkkZS3nyjfRKhvGoGZBUb0b2WqLYNtX8jpC8Lj9LX11cyLEOrqmpSXLzJaHkX/L29nL
         B0UPAvdiBUtJ55zTDfqGUeCxqkKTo+1o5DAwK3obH5bTn8MXa/G63cUdQxUBMajvLEs0
         Cnhw==
X-Gm-Message-State: AFqh2kpkyDCD6Rhu2alp60c4nMqSrk7fq5MZ3OIRLF5rHoJlOD262Jft
        B1ZUpyYiAyoLb7qB91IKzdqiMQ==
X-Google-Smtp-Source: AMrXdXvhGyAFE70MT9iQZf8X8kJsSReLM9h1cNphTO+3C0L/b7eEXI+p2GJzuQKFcutM1uXXNfP1EA==
X-Received: by 2002:a17:907:d48a:b0:7c1:766e:e09 with SMTP id vj10-20020a170907d48a00b007c1766e0e09mr70504227ejc.29.1673534631462;
        Thu, 12 Jan 2023 06:43:51 -0800 (PST)
Received: from localhost ([217.111.27.204])
        by smtp.gmail.com with ESMTPSA id y11-20020aa7c24b000000b004954c90c94bsm7290057edo.6.2023.01.12.06.43.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 06:43:50 -0800 (PST)
Date:   Thu, 12 Jan 2023 15:43:49 +0100
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
Message-ID: <Y8Acpf5AhZ5UgyA3@nanopsycho>
References: <20221209083104.2469ebd6@kernel.org>
 <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230110120549.4d764609@kernel.org>
 <Y75xFlEDCThGtMDq@nanopsycho>
 <DM6PR11MB4657AC41BBF714A280B578D49BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y77QEajGlJewGKy1@nanopsycho>
 <DM6PR11MB4657DC9A41A69B71A42DD22F9BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y77gf1ekbSMdY83b@nanopsycho>
 <DM6PR11MB4657A41D59E6B1162EA6AFDB9BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM6PR11MB4657A41D59E6B1162EA6AFDB9BFD9@DM6PR11MB4657.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 12, 2023 at 01:15:30PM CET, arkadiusz.kubalewski@intel.com wrote:
>>From: Jiri Pirko <jiri@resnulli.us>
>>Sent: Wednesday, January 11, 2023 5:15 PM
>>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>>
>>Wed, Jan 11, 2023 at 04:30:44PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>Sent: Wednesday, January 11, 2023 4:05 PM
>>>>To: Kubalewski, Arkadiusz <arkadiusz.kubalewski@intel.com>
>>>>
>>>>Wed, Jan 11, 2023 at 03:16:59PM CET, arkadiusz.kubalewski@intel.com
>>wrote:
>>>>>>From: Jiri Pirko <jiri@resnulli.us>
>>>>>>Sent: Wednesday, January 11, 2023 9:20 AM
>>>>>>
>>>>>>Tue, Jan 10, 2023 at 09:05:49PM CET, kuba@kernel.org wrote:
>>>>>>>On Mon, 9 Jan 2023 14:43:01 +0000 Kubalewski, Arkadiusz wrote:
>>>>>>>> This is a simplified network switch board example.
>>>>>>>> It has 2 synchronization channels, where each channel:
>>>>>>>> - provides clk to 8 PHYs driven by separated MAC chips,
>>>>>>>> - controls 2 DPLLs.
>>>>>>>>
>>>>>>>> Basically only given FW has control over its PHYs, so also a control
>>>>>>over it's
>>>>>>>> MUX inputs.
>>>>>>>> All external sources are shared between the channels.
>>>>>>>>
>>>>>>>> This is why we believe it is not best idea to enclose multiple DPLLs
>>>>>>with one
>>>>>>>> object:
>>>>>>>> - sources are shared even if DPLLs are not a single synchronizer
>>chip,
>>>>>>>> - control over specific MUX type input shall be controllable from
>>>>>>different
>>>>>>>> driver/firmware instances.
>>>>>>>>
>>>>>>>> As we know the proposal of having multiple DPLLs in one object was a
>>>>try
>>>>>>to
>>>>>>>> simplify currently implemented shared pins. We fully support idea of
>>>>>>having
>>>>>>>> interfaces as simple as possible, but at the same time they shall be
>>>>>>flexible
>>>>>>>> enough to serve many use cases.
>>>>>>>
>>>>>>>I must be missing context from other discussions but what is this
>>>>>>>proposal trying to solve? Well implemented shared pins is all we need.
>>>>>>
>>>>>>There is an entity containing the pins. The synchronizer chip. One
>>>>>>synchronizer chip contains 1-n DPLLs. The source pins are connected
>>>>>>to each DPLL (usually). What we missed in the original model was the
>>>>>>synchronizer entity. If we have it, we don't need any notion of somehow
>>>>>>floating pins as independent entities being attached to one or many
>>>>>>DPLL refcounted, etc. The synchronizer device holds them in
>>>>>>straightforward way.
>>>>>>
>>>>>>Example of a synchronizer chip:
>>>>>>https://www.renesas.com/us/en/products/clocks-timing/jitter-
>>attenuators-
>>>>>>frequency-translation/8a34044-multichannel-dpll-dco-four-eight-
>>>>>>channels#overview
>>>>>
>>>>>Not really, as explained above, multiple separated synchronizer chips
>>can
>>>>be
>>>>>connected to the same external sources.
>>>>>This is why I wrote this email, to better explain need for references
>>>>between
>>>>>DPLLs and shared pins.
>>>>>Synchronizer chip object with multiple DPLLs would have sense if the
>>pins
>>>>would
>>>>>only belong to that single chip, but this is not true.
>>>>
>>>>I don't understand how it is physically possible that 2 pins belong to 2
>>>>chips. Could you draw this to me?
>>>>
>>>
>>>Well, sure, I was hoping this is clear, without extra connections on the
>>draw:
>>
>>Okay, now I understand. It is not a shared pin but shared source for 2
>>pins.
>>
>
>Yes, exactly.
>
>>
>>>+----------+
>>>|i0 - GPS  |--------------\
>>>+----------+              |
>>>+----------+              |
>>>|i1 - SMA1 |------------\ |
>>>+----------+            | |
>>>+----------+            | |
>>>|i2 - SMA2 |----------\ | |
>>>+----------+          | | |
>>>                      | | |
>>>+---------------------|-|-|-------------------------------------------+
>>>| Channel A / FW0     | | |     +-------------+   +---+   +--------+  |
>>>|                     | | |-i0--|Synchronizer0|---|   |---| PHY0.0 |--|
>>
>>One pin here               ^^^
>>
>>>|         +---+       | | |     |             |   |   |   +--------+  |
>>>| PHY0.0--|   |       | |---i1--|             |---| M |---| PHY0.1 |--|
>>>|         |   |       | | |     | +-----+     |   | A |   +--------+  |
>>>| PHY0.1--| M |       |-----i2--| |DPLL0|     |   | C |---| PHY0.2 |--|
>>>|         | U |       | | |     | +-----+     |   | 0 |   +--------+  |
>>>| PHY0.2--| X |--+----------i3--| +-----+     |---|   |---| ...    |--|
>>>|         | 0 |  |    | | |     | |DPLL1|     |   |   |   +--------+  |
>>>| ...   --|   |  | /--------i4--| +-----+     |---|   |---| PHY0.7 |--|
>>>|         |   |  | |  | | |     +-------------+   +---+   +--------+  |
>>>| PHY0.7--|   |  | |  | | |                                           |
>>>|         +---+  | |  | | |                                           |
>>>+----------------|-|--|-|-|-------------------------------------------+
>>>| Channel B / FW1| |  | | |     +-------------+   +---+   +--------+  |
>>>|                | |  | | \-i0--|Synchronizer1|---|   |---| PHY1.0 |--|
>>
>>And second pin here        ^^^
>>
>>There are 2 separate pins. Sure, they need to have the same config as
>>they are connected to the same external entity (GPS, SMA1, SMA2).
>>
>>Perhaps we need to have a board description using dts to draw this
>>picture so the drivers can use this schema in order to properly
>>configure this?
>>
>>My point is, you are trying to hardcode the board geometry in the
>>driver. Is that correct?
>>
>
>Well, we are trying to have userspace-friendly interface :)
>As we discussed yesterday dts is more of embedded world thing and we don't
>want to go that far, the driver knows the hardware it is using, thus it
>shall be enough if it has all the information needed for initialization.
>At least that is what I understood.

Yes, I think yesterday called cleared things up. Thanks!


>
>BR,
>Arkadiusz
>
>>
>>>|         +---+  | |  | |       |             |   |   |   +--------+  |
>>>| PHY1.0--|   |  | |  | \---i1--|             |---| M |---| PHY1.1 |--|
>>>|         |   |  | |  |         | +-----+     |   | A |   +--------+  |
>>>| PHY1.1--| M |  | |  \-----i2--| |DPLL0|     |   | C |---| PHY1.2 |--|
>>>|         | U |  | |            | +-----+     |   | 1 |   +--------+  |
>>>| PHY1.2--| X |  \-|--------i3--| +-----+     |---|   |---| ...    |--|
>>>|         | 1 |    |            | |DPLL1|     |   |   |   +--------+  |
>>>| ...   --|   |----+--------i4--| +-----+     |---|   |---| PHY1.7 |--|
>>>|         |   |                 +-------------+   +---+   +--------+  |
>>>| PHY1.7--|   |                                                       |
>>>|         +---+                                                       |
>>>+---------------------------------------------------------------------+
>>>
>>>>
>>>>>As the pins are shared between multiple DPLLs (both inside 1 integrated
>>>>circuit
>>>>>and between multiple integrated circuits), all of them shall have
>>current
>>>>state
>>>>>of the source or output.
>>>>>Pins still need to be shared same as they would be inside of one
>>>>synchronizer
>>>>>chip.
>>>>
>>>>Do I understand correctly that you connect one synchronizer output to
>>>>the input of the second synchronizer chip?
>>>
>>>No, I don't recall such use case. At least nothing that needs to exposed
>>>in the DPLL subsystem itself.
>>>
>>>BR,
>>>Arkadiusz
>>>
>>>>
>>>>>
>>>>>BR,
>>>>>Arkadiusz
