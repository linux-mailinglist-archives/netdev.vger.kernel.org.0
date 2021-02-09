Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B533151D1
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 15:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBIOjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 09:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231998AbhBIOjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 09:39:09 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FA5C061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 06:38:29 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id f23so11534924lfk.9
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 06:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Bl4NyxXsoM0k1giwqa8fcGVmVR7pMDAW/zMJKNCYqws=;
        b=Xivd2tDXmiWq4XBM9+2Cz7mxlKHY48ZN/JOEJ2zU2ZhQyP4pTfQw/Z0aaGSbxU2vHe
         YLF3Ug+pwL6c3Oe7efw+k8p0ZFDt1Qj+EpXkafRJHtWd912oCTtluZ4Cjhtc0VqJchfY
         EB66CVZBK0/ts683kGmquoqW0KoiTkLeKd/pri7NIfuE4LJdZhZw4LdcUL34tfr5B51S
         bYVIdnl2rB97VpN3eixZXLVxVHIESIWwuiFdyOq+JPAOKv6XrNagc5qRW6yTNAZT1e4Q
         a1g+lHl1qx2TknsIQgxm2eZkNaxOT7XFKtGa9jYvODYGahONItKGFwXhebysdUBEXMGI
         AsjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Bl4NyxXsoM0k1giwqa8fcGVmVR7pMDAW/zMJKNCYqws=;
        b=kLecgzZ0AnZZw6lyaoeAaYxmBqBoczLiwqZLERvKmPKTO5qeETSFD7VjTFNXNEyPUI
         sc69KkIlA8Mshf2DMLuR6m9mucyEXUz/8gG3EV4DEWZ4xpvZpHy+3n+KOEnBuj5r1Je4
         hGXC3hY8c0cNNpfsypFWScvXzYU3+JrvNTmRrqNHa1HNsoSlP0PjYRTvPip8byYumrJ5
         P5vI5v7x1jhy/LP2QiTchiesVRyI1idwc/OKwUICacSfGlEHfkOQpbvTFUYtDRJbPBmQ
         1PiMKxfnpF2UeBm6GVkP/1MCtRO1ctGIl0PUrHVUOw8EwRHz0hk5ZpEE9mvlUTF2QRlO
         KJcw==
X-Gm-Message-State: AOAM530yQ+EZPMSBwJv53PF8zTQXBiK3lR8+LU6Du4oLEIADQQslZTrz
        UMflPSu/IQC4qZicsR60O8xLP+j6+ApJ5HH6
X-Google-Smtp-Source: ABdhPJxp74N8Y4LWchStcORu7wa9ouCn5q4bAue4YyGEcfdkXZUjb5gqmidtQcHLCP7dXWy76daq7Q==
X-Received: by 2002:a05:6512:3748:: with SMTP id a8mr13207041lfs.31.1612881507044;
        Tue, 09 Feb 2021 06:38:27 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id x14sm2552129lfg.165.2021.02.09.06.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 06:38:26 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA switches
In-Reply-To: <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com>
References: <20210204215926.64377-1-george.mccollister@gmail.com> <87sg6648nw.fsf@waldekranz.com> <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com>
Date:   Tue, 09 Feb 2021 15:38:25 +0100
Message-ID: <87k0rh487y.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 15:09, George McCollister <george.mccollister@gmail.com> wrote:
> On Mon, Feb 8, 2021 at 2:16 PM Tobias Waldekranz <tobias@waldekranz.com> wrote:
>>
>> On Thu, Feb 04, 2021 at 15:59, George McCollister <george.mccollister@gmail.com> wrote:
>> > Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
>> > removal, forwarding and duplication on DSA switches.
>> > This series adds offloading to the xrs700x DSA driver.
>> >
>> > Changes since RFC:
>> >  * Split hsr and dsa patches. (Florian Fainelli)
>> >
>> > Changes since v1:
>> >  * Fixed some typos/wording. (Vladimir Oltean)
>> >  * eliminate IFF_HSR and use is_hsr_master instead. (Vladimir Oltean)
>> >  * Make hsr_handle_sup_frame handle skb_std as well (required when offloading)
>> >  * Don't add hsr tag for HSR v0 supervisory frames.
>> >  * Fixed tag insertion offloading for PRP.
>> >
>> > George McCollister (4):
>> >   net: hsr: generate supervision frame without HSR/PRP tag
>> >   net: hsr: add offloading support
>> >   net: dsa: add support for offloading HSR
>> >   net: dsa: xrs700x: add HSR offloading support
>> >
>> >  Documentation/networking/netdev-features.rst |  21 ++++++
>> >  drivers/net/dsa/xrs700x/xrs700x.c            | 106 +++++++++++++++++++++++++++
>> >  drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
>> >  include/linux/if_hsr.h                       |  27 +++++++
>> >  include/linux/netdev_features.h              |   9 +++
>> >  include/net/dsa.h                            |  13 ++++
>> >  net/dsa/dsa_priv.h                           |  11 +++
>> >  net/dsa/port.c                               |  34 +++++++++
>> >  net/dsa/slave.c                              |  14 ++++
>> >  net/dsa/switch.c                             |  24 ++++++
>> >  net/dsa/tag_xrs700x.c                        |   7 +-
>> >  net/ethtool/common.c                         |   4 +
>> >  net/hsr/hsr_device.c                         |  46 ++----------
>> >  net/hsr/hsr_device.h                         |   1 -
>> >  net/hsr/hsr_forward.c                        |  33 ++++++++-
>> >  net/hsr/hsr_forward.h                        |   1 +
>> >  net/hsr/hsr_framereg.c                       |   2 +
>> >  net/hsr/hsr_main.c                           |  11 +++
>> >  net/hsr/hsr_main.h                           |   8 +-
>> >  net/hsr/hsr_slave.c                          |  10 ++-
>> >  20 files changed, 331 insertions(+), 56 deletions(-)
>> >  create mode 100644 include/linux/if_hsr.h
>> >
>> > --
>> > 2.11.0
>>
>> Hi George,
>>
>> I will hopefully have some more time to look into this during the coming
>> weeks. What follows are some random thoughts so far, I hope you can
>> accept the windy road :)
>>
>> Broadly speaking, I gather there are two common topologies that will be
>> used with the XRS chip: "End-device" and "RedBox".
>>
>> End-device:    RedBox:
>>  .-----.       .-----.
>>  | CPU |       | CPU |
>>  '--+--'       '--+--'
>>     |             |
>> .---0---.     .---0---.
>> |  XRS  |     |  XRS  3--- Non-redundant network
>> '-1---2-'     '-1---2-'
>>   |   |         |   |
>>  HSR Ring      HSR Ring
>
> There is also the HSR-HSR use case and HSR-PRP use case.

HSR-HSR is also known as a "QuadBox", yes? HSR-PRP is the same thing,
but having two PRP networks on one side and an HSR ring on the other?

>> From the looks of it, this series only deals with the end-device
>> use-case. Is that right?
>
> Correct. net/hsr doesn't support this use case right now. It will
> stomp the outgoing source MAC with that of the interface for instance.

Good to know! When would that behavior be required? Presumably it is not
overriding the SA just for fun?

> It also doesn't implement a ProxyNodeTable (though that actually
> wouldn't matter if you were offloading to the xrs700x I think). Try
> commenting out the ether_addr_copy() line in hsr_xmit and see if it
> makes your use case work.

So what is missing is basically to expand the current facility for
generating sequence numbers to maintain a table of such associations,
keyed by the SA?

Is the lack of that table the reason for enforcing that the SA match the
HSR netdev?

>> I will be targeting a RedBox setup, and I believe that means that the
>> remaining port has to be configured as an "interlink". (HSR/PRP is still
>> pretty new to me). Is that equivalent to a Linux config like this:
>
> Depends what you mean by configured as an interlink. I believe bit 9
> of HSR_CFG in the switch is only supposed to be used for the HSR-HSR
> and HSR-PRP use case, not HSR-SAN.

Interesting, section 6.4.1 of the XRS manual states: "The interlink port
can be either in HSR, PRP or normal (non-HSR, non-PRP) mode." Maybe the
term is overloaded?

>>       br0
>>      /   \
>>    hsr0   \
>>    /  \    \
>> swp1 swp2 swp3
>>
>> Or are there some additional semantics involved in forwarding between
>> the redundant ports and the interlink?
>
> That sounds right.
>
>>
>> The chip is very rigid in the sense that most roles are statically
>> allocated to specific ports. I think we need to add checks for this.
>
> Okay. I'll look into this. Though a lot of the restrictions have to do
> with using the third gigabit port for an HSR/PRP interlink (not
> HSR-SAN) which I'm not currently supporting anyway.

But nothing is stopping me from trying to setup an HSR ring between port
(2,3) or (1,3), right? And that is not supported by the chip as I
understand it from looking at table 25.

>> Looking at the packets being generated on the redundant ports, both
>> regular traffic and supervision frames seem to be HSR-tagged. Are
>> supervision frames not supposed to be sent with an outer ethertype of
>> 0x88fb? The manual talks about the possibility of setting up a policy
>> entry to bypass HSR-tagging (section 6.1.5), is this what that is for?
>
> This was changed between 62439-3:2010 and 62439-3:2012.
> "Prefixing the supervision frames on HSR by an HSR tag to simplify the hardware
> implementation and introduce a unique EtherType for HSR to simplify
> processing."

Thank you, that would have taken me a long time to figure out :)

> The Linux HSR driver calls the former HSR v0 and the later HSR v1. I'm
> not sure what their intention was with this feature. The inbound
> policies are pretty flexible so maybe they didn't have anything so
> specific in mind.

Now that I think of it, maybe you want things like LLDP to still operate
hop-by-hop over the ring?

> I don't think the xrs7000 series could offload HSR v0 anyway because
> the tag ether type is different.
>
>>
>> In the DSA layer (dsa_slave_changeupper), could we merge the two HSR
>> join/leave calls somehow? My guess is all drivers are going to end up
>> having to do the same dance of deferring configuration until both ports
>> are known.
>
> Describe what you mean a bit more. Do you mean join and leave should
> each only be called once with both hsr ports being passed in?

Exactly. Maybe we could use `netdev_for_each_lower_dev` to figure out if
the other port has already been switched over to the new upper or
something. I find it hard to believe that there is any hardware out
there that can do something useful with a single HSR/PRP port anyway.
