Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A592D1C55
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbgLGVuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726146AbgLGVuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:50:23 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2834C061749
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 13:49:42 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id s30so20233360lfc.4
        for <netdev@vger.kernel.org>; Mon, 07 Dec 2020 13:49:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=gXQAy34572kQEb4yeLMtHQEnzi0xSEA+FOKcKJKM1Hs=;
        b=b2bz2iAK8tsO8fQuCeNo67ix6NmVOduFzoL3Pt9sogPXhuXeyThZSIsPfbNjlvtUev
         YPv0GVv6uTF2hXRegVwqygwH1IwEFJUhEaRrf6L3G7xuP7/+E7DlxCl/MaibYTnko2CJ
         d1C+njISlEWiPE7cI7Ik8tuBri8QCjR8Lgcl42B/UiMRI2SUYBgv5rmg813+IUvJD26A
         bIhcnotC84jQzGXdqWPAlOJxjTMfuqUGpSVKqLnpE2Q7tiPs2riyhfsdhnu2i+qXYZbR
         +A2gNVIPD2qaI+uiM2z9wZy2ELd2p5NynJXIugWxiuJKBiTFdwudQw/y8sfjFVc9QHKw
         WBRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=gXQAy34572kQEb4yeLMtHQEnzi0xSEA+FOKcKJKM1Hs=;
        b=gg4wHbvQroNO6/bow/jbo3ZMhTsUxjVE6i2gpz1cGdLvd8PVcl7elJjekTVhWnAaw9
         /bBXt6RCRqbge6NstmH36B9XRDdqecnwIvcF1xugHeFkXZ/Ulfi42ioQAMVYfBDYAVme
         EhV7x5QBBqOwWHgkk+cP5BjXDzHao2L8wtRX8U8vYy+2N0SrHdUSf0K+BjuyajYTWQqM
         AqA9p0wSOg3xaLlfqot7a9jo7vSeofCZCojbrkrFRo6U6Escq/Wr5JLtxKx4JFOhRkDA
         Mv5LOqyZdCDV7BuWLDDOZ+MtIRmx1bFTwj7BR4a2M2G9aWlra4w+ApXF8Gc0yv9g7TIg
         v7oQ==
X-Gm-Message-State: AOAM5301WLO2nYTwSiw7FggxB7TknajtYXDBHpN8NrAvNlDsP+CBPGru
        txWOEfdWEJkx2icdYEDkGejAZJiACNXOKrEc
X-Google-Smtp-Source: ABdhPJwParNz7Dxz7TiCF249nrPgtWEMgNcEuUk2PWlpJBxMPZK8aTBHhdpLrFT/p8JgnXr9VsoR4g==
X-Received: by 2002:a19:c219:: with SMTP id l25mr8600907lfc.575.1607377781085;
        Mon, 07 Dec 2020 13:49:41 -0800 (PST)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id c136sm450964lfg.306.2020.12.07.13.49.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:49:40 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201204005653.uep7nvtg4ish5xct@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201203162428.ffdj7gdyudndphmn@skbuf> <87a6uu7gsr.fsf@waldekranz.com> <20201203215725.uuptum4qhcwvhb6l@skbuf> <87360m7acf.fsf@waldekranz.com> <20201204005653.uep7nvtg4ish5xct@skbuf>
Date:   Mon, 07 Dec 2020 22:49:39 +0100
Message-ID: <87sg8h5lsc.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 02:56, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Dec 04, 2020 at 12:12:32AM +0100, Tobias Waldekranz wrote:
>> You make a lot of good points. I think it might be better to force the
>> user to be explicit about their choice though. Imagine something like
>> this:
>>
>> - We add NETIF_F_SWITCHDEV_OFFLOAD, which is set on switchdev ports by
>>   default. This flag is only allowed to be toggled when the port has no
>>   uppers - we do not want to deal with a port in a LAG in a bridge all
>>   of a sudden changing mode.
>>
>> - If it is set, we only allow uppers/tc-rules/etc that we can
>>   offload. If the user tries to configure something outside of that, we
>>   can suggest disabling offloading in the error we emit.
>>
>> - If it is not set, we just sit back and let the kernel do its thing.
>>
>> This would work well both for exotic LAG modes and for advanced
>> netfilter(ebtables)/tc setups I think. Example session:
>>
>> $ ip link add dev bond0 type bond mode balance-rr
>> $ ip link set dev swp0 master bond0
>> Error: swp0: balance-rr not supported when using switchdev offloading
>> $ ethtool -K swp0 switchdev off
>> $ ip link set dev swp0 master bond0
>> $ echo $?
>> 0
>
> And you want the default to be what, on or off? I believe on?
> I'd say the default should be off. The idea being that you could have
> "write once, run everywhere" types of scripts. You can only get that
> behavior with "off", otherwise you'd get random errors on some equipment
> and it wouldn't be portable. And "ethtool -K swp0 switchdev off" is a
> bit of a strange incantation to add to every script just to avoid
> errors.. But if the default switchdev mode is off, then what's the
> point in even having the knob, your poor Linus will still be confused
> and frustrated, and it won't help him any bit if he can flip the switch
> - it's too late, he already knows what the problem is by the time he
> finds the switch.

Yeah I can not argue with that. OK, I surrender, software fallback it
is.

>> > I would even go out on a limb and say hardcode the TX_TYPE_HASH in DSA
>> > for now. I would be completely surprised to see hardware that can
>> > offload anything else in the near future.
>>
>> If you tilt your head a little, I think active backup is really just a
>> trivial case of a hashed LAG wherein only a single member is ever
>> active. I.e. all buckets are always allocated to one port (effectivly
>> negating the hashing). The active member is controlled by software, so I
>> think we should be able to support that.
>
> Yup, my head is tilted and I see it now. If I understand this mode
> (never used it), then any hardware switch that can offload bridging can
> also offload the active-backup LAG.

Neither have I, but I guess you still need an actual LAG to associate
neighbors with, instead of the physical port? Maybe ocelot is different,
but on mv88e6xxx you otherwise get either (1) packet loss when the
active member changes or (2) duplicated packets when more than one
member is active.

>> mv88e6xxx could also theoretically be made to support broadcast. You can
>> enable any given bucket on multiple ports, but that seems silly.
>
> Yeah, the broadcast bonding mode looks like an oddball. It sounds to me
> almost like HSR/PRP/FRER but without the sequence numbering, which is a
> surefire way to make a mess out of everything. I have no idea how it is
> used (how duplicate elimination is achieved).

That is the way I interpret it as well. I suppose the dedup is done on
some higher layer, or it is some kind of redundant rx-only recorder or
something.
