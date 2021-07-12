Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8133C5C27
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 14:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbhGLMbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 08:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbhGLMbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 08:31:33 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8AAC0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 05:28:45 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id s18so23925186ljg.7
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 05:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=PV4kOyQL1JsbRKkeKC/Gl82LBI1CwryP6/UZTJktqvo=;
        b=tRz8ZITx4e8sWUdV8lpH2Z6whRgaAkR9OpCccL8jSs2TzORA/IVUkCDmQK2WCknzeW
         vg3O1mfMxtssvqo/nq0mRAinJRmmzHw7Rc9NPdc+jQ8ZHuwbKvL6G4naQIo6WGUO7zqd
         juoe4xbiqcQDq4BQeeY6XJSHqk/xPC7rRVlPppx2kYUE5l0v/9at6ONt4WkwHRof1quL
         3Y61qBrKoQ2CRMxfUUSF5dSybuRj+Xw3antKhYRjjEj5oKVWGsYta7W5WEBpcD55mxbL
         ueS+Q18YETQpSs+AxPWo18EE59zDf75jCezvxQad3LvKTdSebHEZI5eSvuTedFGeLRG1
         K45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PV4kOyQL1JsbRKkeKC/Gl82LBI1CwryP6/UZTJktqvo=;
        b=lw8h/6u6Ax65wCqMK8l9mP52ekMYB07p9+UHgaggo/mQfBmoJUXbkeBewpL+9VA3C/
         cBwlC8f/2WLavyZZqtEh4AsAghuoNu/5scj0qNpwowxykdm/7yoSTAP0B2lRibWIsM+P
         q26NtKsPc/a6r9Te1JAD6i3yzF2MmRHicnWOH7j/0UtnEHIapVRAHphbOpDDm2iGBuOd
         URzPuTVEmNDOPPplEXw+tFdr5GW9Og1SDJdbrVf2duN4RcBbDXa4X2SePgooOhF2iaFQ
         2THKtsIYs5YA3ate2CO2Rz77Bv8Rjx9wotdsgXdK02AupYngGkgEuebGHJ4hhSJVB+K5
         Bp8w==
X-Gm-Message-State: AOAM531YtnzKmFuZCOXRyiiumv/HNAw+JAOZyn+Fq8ICQWW61eWDQnNX
        PPD+ky0JKzovy0drLLelXe5pdw==
X-Google-Smtp-Source: ABdhPJwSizldBKVPyfAIoWGmj7tVm64OWq085uMjLYhDEQJnU3uRoGIjzTZ4JFBUEIeUQMTheSePcg==
X-Received: by 2002:a05:651c:555:: with SMTP id q21mr15349536ljp.62.1626092923916;
        Mon, 12 Jul 2021 05:28:43 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u11sm1569978lja.129.2021.07.12.05.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 05:28:43 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "bridge\@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 04/10] net: bridge: switchdev: allow the data plane forwarding to be offloaded
In-Reply-To: <20210709140940.4ak5vvt5hxay3wus@skbuf>
References: <20210703115705.1034112-1-vladimir.oltean@nxp.com> <20210703115705.1034112-5-vladimir.oltean@nxp.com> <3686cff1-2a80-687e-7c64-cf070a0f5324@ti.com> <20210709140940.4ak5vvt5hxay3wus@skbuf>
Date:   Mon, 12 Jul 2021 14:28:42 +0200
Message-ID: <87r1g37m2t.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 14:09, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> Hi Grygorii,
>
> On Fri, Jul 09, 2021 at 04:16:13PM +0300, Grygorii Strashko wrote:
>> On 03/07/2021 14:56, Vladimir Oltean wrote:
>> > From: Tobias Waldekranz <tobias@waldekranz.com>
>> >
>> > Allow switchdevs to forward frames from the CPU in accordance with the
>> > bridge configuration in the same way as is done between bridge
>> > ports. This means that the bridge will only send a single skb towards
>> > one of the ports under the switchdev's control, and expects the driver
>> > to deliver the packet to all eligible ports in its domain.
>> >
>> > Primarily this improves the performance of multicast flows with
>> > multiple subscribers, as it allows the hardware to perform the frame
>> > replication.
>> >
>> > The basic flow between the driver and the bridge is as follows:
>> >
>> > - The switchdev accepts the offload by returning a non-null pointer
>> >    from .ndo_dfwd_add_station when the port is added to the bridge.
>> >
>> > - The bridge sends offloadable skbs to one of the ports under the
>> >    switchdev's control using dev_queue_xmit_accel.
>> >
>> > - The switchdev notices the offload by checking for a non-NULL
>> >    "sb_dev" in the core's call to .ndo_select_queue.
>>
>> Sry, I could be missing smth.
>>
>> Is there any possibility to just mark skb itself as "fwd_offload" (or smth), so driver can
>> just check it and decide what to do. Following you series:
>> - BR itself will send packet only once to one port if fwd offload possible and supported
>> - switchdev driver can check/negotiate BR_FWD_OFFLOAD flag
>>
>> In our case, TI CPSW can send directed packet (default now), by specifying port_id if DMA desc
>> or keep port_id == 0 which will allow HW to process packet internally, including MC duplication.
>>
>> Sry, again, but necessity to add 3 callbacks and manipulate with "virtual" queue to achieve
>> MC offload (seems like one of the primary goals) from BR itself looks a bit over-complicated :(
>
> After cutting my teeth myself with Tobias' patches, I tend to agree with
> the idea that the macvlan offload framework is not a great fit for the
> software bridge data plane TX offloading. Some reasons:

I agree. I was trying to find an API that would not require adding new
.ndos or other infrastructure. You can see in my original RFC cover that
this was something I wrestled with. 

> - the sb_dev pointer is necessary for macvlan because you can have
>   multiple macvlan uppers and you need to know which one this packet
>   came from. Whereas in the case of a bridge, any given switchdev net
>   device can have a single bridge upper. So a single bit per skb,
>   possibly even skb->offload_fwd_mark, could be used to encode this bit
>   of information: please look up your FDB for this packet and
>   forward/replicate it accordingly.

In fact, in the version I was about to publish, I reused
skb->offload_fwd_mark to encode precisely this property. It works really
well. Maybe I should just publish it, even with the issues regarding
mv88e6xxx. Let me know if you want to take a look at it.

> - I am a bit on the fence about the "net: allow ndo_select_queue to go
>   beyond dev->num_real_tx_queues" and "net: extract helpers for binding
>   a subordinate device to TX queues" patches, they look like the wrong
>   approach overall, just to shoehorn our use case into a framework that
>   was not meant to cover it.

Yep.

> - most importantly: Ido asked about the possibility for a switchdev to
>   accelerate the data plane for a bridge port that is a LAG upper. In the
>   current design, where the bridge attempts to call the
>   .ndo_dfwd_add_station method of the bond/team driver, this will not
>   work. Traditionally, switchdev has migrated away from ndo's towards
>   notifiers because of the ability for a switchdev to intercept the
>   notifier emitted by the bridge for the bonding interface, and to treat
>   it by itself. So, logically speaking, it would make more sense to
>   introduce a new switchdev notifier for TX data plane offloading per
>   port. Actually, now that I'm thinking even more about this, it would
>   be great not only if we could migrate towards notifiers, but if the
>   notification could be emitted by the switchdev driver itself, at

I added pass-through implementations of these .ndos to make it work on
top of LAGs, but a notifier is much cleaner.

>   bridge join time. Once upon a time I had an RFC patch that changed all
>   switchdev drivers to inform the bridge that they are capable of
>   offloading the RX data plane:
>   https://patchwork.kernel.org/project/netdevbpf/patch/20210318231829.3892920-17-olteanv@gmail.com/

Really like this approach! It also opens up the possibility of disabling
it manually (something like `ethtool -K swp0 bridge-{rx, tx} off`). This
will allow you to run a DPI firewall on a specific port in a LAN, for
example.

>   That patch was necessary because the bridge, when it sees a bridge
>   port that is a LAG, and the LAG is on top of a switchdev, will assign
>   the port hwdom based on the devlink switch ID of the switchdev. This
>   is wrong because it assumes that the switchdev offloads the LAG, but
>   in the vast majority of cases this is false, only a handful of
>   switchdev drivers have LAG offload right now. So the expectation is
>   that the bridge can do software forwarding between such LAG comprised
>   of two switchdev interfaces, and a third (standalone) switchdev
>   interface, but it doesn't do that, because to the bridge, all ports
>   have the same hwdom.
>   Now it seems common sense that I pick up this patch again and make the
>   switchdev drivers give 2 pieces of information:
>   (a) can I offload the RX data path
>   (b) can I offload the TX data path
>
> I can try to draft another RFC with these changes.
