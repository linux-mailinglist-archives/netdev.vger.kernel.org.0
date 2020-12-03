Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1015B2CE26F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 00:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729729AbgLCXNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 18:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbgLCXNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 18:13:16 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF58C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 15:12:35 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id z1so4467113ljn.4
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 15:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=whK4D+aaSOWnBd3zTUnnjxlbfXSe7RerqQ+rJHpCIUo=;
        b=UPKiDqlrG+L//1iz1kWme8JlYvrmFGpHxW6YG/ZL3KPNRdx83G+/Qy7bb2JurX/J38
         VLCHyQujSaOFCrnuq78+rXMiburueybT5XXT+AJraYSLSPWxE406qzbQCA3kjpWbnHnX
         +rQ1DwFW7KRs0PVV+oLXoIZ+ZY8LZEWi/Yf9y70qFe1hieBDQjMTZLszRXTWwkXaL6W2
         3bk5DuM3eOrVKUrZA+MRx+Jh1W/CxA7sQYWsAHyeAy9dUC2MIGX0dJ68HL6+LYdh/KVk
         I65Yw1Rxty8DGBOgU1tFdIfOA68b88XuZ6Emm/b8pakqDCoJdppMBIBwgcEYnQey6Q7d
         tmeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=whK4D+aaSOWnBd3zTUnnjxlbfXSe7RerqQ+rJHpCIUo=;
        b=YeeFztWP1mzvJJsmQn2211xRNOVi7yZVL1WMjTuKU95gvdQnkKhigmtzzl8oGdy1bM
         GFsG9x2rheHGi9Cw3gBnrr26gCocwm2GAtLEyetDv5LSsH9iRKWV+bQf7BYQ3PefnR4R
         uEnD/nglTu4WMlXSYejSpEIdwA7WMI0k6pQrevydM48POA2Z3qHSyL/jfSf4uO/8N8jc
         humVtZ48BAvZZuol3f3YEWS8K4i/2+nQs9qF5OFGt6VDE+ldfVwa1sgbUl36q6vJwkH4
         2sm4qTOASosuEKDinr2tyYKEqO68W9oDQLKUAQzKziu/fb0eQWo32gY0E2u7lzHwZF26
         tK5g==
X-Gm-Message-State: AOAM532KuwHM1vG2xQuJvlA7JrLVRDGz7OfuTDdeZxoKjZz0qsICJR+t
        ZUek0sDb6/VpeImF3de2z8IM/6cvThWEr5e+
X-Google-Smtp-Source: ABdhPJyzRRaiZdTl5jUw+AV+CI4at2sKI02ncgWAIjsnrH3s3/bbYfp4Qs56/FV3LRfEFXNm68wq8A==
X-Received: by 2002:a2e:9615:: with SMTP id v21mr2058949ljh.211.1607037154092;
        Thu, 03 Dec 2020 15:12:34 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id q20sm920099ljp.90.2020.12.03.15.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 15:12:33 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201203215725.uuptum4qhcwvhb6l@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201203162428.ffdj7gdyudndphmn@skbuf> <87a6uu7gsr.fsf@waldekranz.com> <20201203215725.uuptum4qhcwvhb6l@skbuf>
Date:   Fri, 04 Dec 2020 00:12:32 +0100
Message-ID: <87360m7acf.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 23:57, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Dec 03, 2020 at 09:53:08PM +0100, Tobias Waldekranz wrote:
>> I am not sure which way is the correct one, but I do not think that it
>> necessarily _always_ correct to silently fallback to a non-offloaded
>> mode.
>
> Of course, neither is fully correct. There is always more to improve on
> the communication side of things. But DSA, which stands for "Not Just A
> Switch", promises you, above all, a port multiplexer with the ability to
> make full use of the network stack. Maybe I'm still under the influence
> of a recent customer meeting I had, but there is a large base of use
> cases there, where people just don't seem to have enough ports, and they
> can just add a $3 switch to their system, and voila, problem solved.
> Everything works absolutely the same as before. The newly added switch
> ports are completely integrated with the kernel's IP routing database.
> They aren't even switch ports, they're just ports.
>
> And even there, on the software fallback front, we don't do enough,
> currently. I've had other customers who said that they even _prefer_
> to do bridging in software, in order to get a chance to run their
> netfilter/ebtables based firewall on their traffic. Of course, DSA
> currently has no idea when netfilter rules are installed, so I just told
> them to hack the driver and remove the bridging offload, which they
> happily did.

Totally agree with your customer, we should be able to disable all
offloading for an individual port and run it in a plain "NIC mode". In
fact, that might be what opens up a third option for how LAG offloading
should be handled.

> I suspect you're looking at this from the wrong angle. I did, too, for
> the longest time, because I was focused on squeezing the most out of the
> hardware I had. And "I feel cheated because the operating system sits
> between me and the performance I want from my hardware" is an argument
> I've heard all too often. But not everybody needs even gigabits of
> traffic, or absurdly low latency. Making a product that works acceptably
> and at a low cost is better than hand-picking only hardware that can
> accelerate everything and spending $$$$ on it, for a performance
> improvement that no user will notice. Doing link aggregation in software
> is fine. Doing bridging in software is fine. Sure, the CPU can't compete
> past a number of KPPS, but maybe it doesn't even have to.

I really get the need for being able to apply some CPU-duct-tape to
solve that final corner case in a network. Or to use it as a cheap port
expander.

> Again, this doesn't mean that we should not report, somehow, what is
> offloaded and what isn't, and more importantly, the reason why
> offloading the set of required actions is not supported. And I do
> realize that I wrote a long rant about something that has nothing to do
> with the topic at hand, which is: should we deny bonding interfaces that
> use balance-rr, active-backup, broadcast, balance-tlb, balance-alb on
> top of a DSA interface? Hell no, you wouldn't expect an intel e1000 card
> to error out when you would set up a bonding interface that isn't xor or
> 802.3ad, would you? But you wouldn't go ahead and set up bridging
> offload either, therefore running into the problem I raised above with
> netfilter rules. You would just set out to do what the user asked for,
> in the way that you can, and let them decide if the performance is what
> they need or not.

You make a lot of good points. I think it might be better to force the
user to be explicit about their choice though. Imagine something like
this:

- We add NETIF_F_SWITCHDEV_OFFLOAD, which is set on switchdev ports by
  default. This flag is only allowed to be toggled when the port has no
  uppers - we do not want to deal with a port in a LAG in a bridge all
  of a sudden changing mode.

- If it is set, we only allow uppers/tc-rules/etc that we can
  offload. If the user tries to configure something outside of that, we
  can suggest disabling offloading in the error we emit.

- If it is not set, we just sit back and let the kernel do its thing.

This would work well both for exotic LAG modes and for advanced
netfilter(ebtables)/tc setups I think. Example session:

$ ip link add dev bond0 type bond mode balance-rr
$ ip link set dev swp0 master bond0
Error: swp0: balance-rr not supported when using switchdev offloading
$ ethtool -K swp0 switchdev off
$ ip link set dev swp0 master bond0
$ echo $?
0

>> > Should we add an array of supported TX types that the switch port can
>> > offload, and that should be checked by DSA in dsa_lag_offloading?
>>
>> That would work. We could also create a new DSA op that we would call
>> for each chip from PRECHANGEUPPER to verify that it is supported. One
>> advantage with this approach is that we can just pass along the `struct
>> netdev_lag_upper_info` so drivers always have access to all information,
>> in the event that new fields are added to it for example.
>
> Hmm, not super pleased to have yet another function pointer, but I don't
> have any other idea, so I guess that works just fine.

Yeah I do not like it either, maybe it is just the least bad thing.

> I would even go out on a limb and say hardcode the TX_TYPE_HASH in DSA
> for now. I would be completely surprised to see hardware that can
> offload anything else in the near future.

If you tilt your head a little, I think active backup is really just a
trivial case of a hashed LAG wherein only a single member is ever
active. I.e. all buckets are always allocated to one port (effectivly
negating the hashing). The active member is controlled by software, so I
think we should be able to support that.

mv88e6xxx could also theoretically be made to support broadcast. You can
enable any given bucket on multiple ports, but that seems silly.
