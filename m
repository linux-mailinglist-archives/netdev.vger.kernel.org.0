Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7486346AEA
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 22:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhCWVRy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 17:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233453AbhCWVRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 17:17:34 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B778CC061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 14:17:33 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id f26so27534317ljp.8
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 14:17:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=leb2MtIF5Nbuqogh38v2FlQ1Dc42TK4r5LUMPwp3jC8=;
        b=DUVhawQRGDYbNNXrMb7V1tnuGCpl/YlPMn5w3OG2RC6x9Z9LEitjZAKMqu+Brwb2Xj
         jT43VXCMdF3WX5FlS+IzfXkG7ALVreoNGHZPm3dRe6l0xWuUwdwBHeQfocuuFXh8IBVG
         GXsRayJ0JKUkx0if6bFzSqJ6s1cRZXP6TYkCO9AAc0LhhtkfVPX02SPa+eXdti5Rho0H
         /vfyeYVH810u2Z5zASN9BnMf0sCQtF7llp4jg0dyaRTD4SaR8HRbu1tIkJaeUmW+QA4Z
         XJqlWESDpH+h8KoRPzhaRR9dKr562VQLMhBjh/y4DOSt8pl8bOm70OuESNsvSay6aS6W
         XcmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=leb2MtIF5Nbuqogh38v2FlQ1Dc42TK4r5LUMPwp3jC8=;
        b=sZVj/FXvY60Muyp9+JzLRvph7a4TA93RDywPd7JIOjE/SXS9WQxqqjpdcuWa1kzM/T
         ts6krFqEaQY5HVAF8meE4+7cQPWtPYcF28kdGMRjh/SYkxj/2gYFSsUb79YukqeMyWmh
         /An02zRacbjoqz4K/F0uVDiavkmwiX1y0+LuKUA67eZAJ2/DEcYYB4ArnuiLC1whWZj5
         JB0QBg62cVTHQDPJqM/7gexjfy4XaZ5WjVz674yjJhnQznrzNgaL1VgtgSYPeEsiHczr
         LfWMCG2Xqo81jzqGov0bPm0Q+JqUMmTRtzYxzoXk+wKWo/SlZIBrHQhf7Raq6s2fmEN1
         NhYA==
X-Gm-Message-State: AOAM531z88h8vc4EaGWjb4ogjG7MSGz/UTshuSo5eU/9SSvmPR1l1ziJ
        vgoUzZdnDKFfADoZ1Dbl2OBWLDBsPVDDbMNm
X-Google-Smtp-Source: ABdhPJyr6rdcNkF+bKjzYq5Q6BUmtSdJLPpfhJTtGN414jCJM7po28vw5A1rjoyvYHlpaxPOOjO3zA==
X-Received: by 2002:a2e:b011:: with SMTP id y17mr4344834ljk.390.1616534251911;
        Tue, 23 Mar 2021 14:17:31 -0700 (PDT)
Received: from wkz-x280 (h-236-82.A259.priv.bahnhof.se. [98.128.236.82])
        by smtp.gmail.com with ESMTPSA id j27sm21748lfp.186.2021.03.23.14.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 14:17:31 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <20210323190302.2v7ianeuwylxdqjl@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <20210323113522.coidmitlt6e44jjq@skbuf> <87blbalycs.fsf@waldekranz.com> <20210323190302.2v7ianeuwylxdqjl@skbuf>
Date:   Tue, 23 Mar 2021 22:17:30 +0100
Message-ID: <8735wlmuxh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 21:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 23, 2021 at 03:48:51PM +0100, Tobias Waldekranz wrote:
>> On Tue, Mar 23, 2021 at 13:35, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > The netdev_uses_dsa thing is a bit trashy, I think that a more polished
>> > version should rather set NETIF_F_RXALL for the DSA master, and have the
>> > dpaa driver act upon that. But first I'm curious if it works.
>> 
>> It does work. Thank you!
>
> Happy to hear that.
>
>> Does setting RXALL mean that the master would accept frames with a bad
>> FCS as well?
>
> Do you mean from the perspective of the network stack, or of the hardware?
>
> As far as the hardware is concerned, here is what the manual has to say:
>
> Frame reception from the network may encounter certain error conditions.
> Such errors are reported by the Ethernet MAC when the frame is transferred
> to the Buffer Manager Interface (BMI). The action taken per error case
> is described below. Besides the interrupts, the BMI is capable of
> recognizing several conditions and setting a corresponding flag in FD
> status field for Host usage. These conditions are as follows:
>
> * Physical Error. One of the following events were detected by the
>   Ethernet MAC: Rx FIFO overflow, FCS error, code error, running
>   disparity error (in applicable modes), FIFO parity error, PHY Sequence
>   error, PHY error control character detected, CRC error. The BMI
>   discards the frame, or enqueue directly to EFQID if FMBM_RCFG[FDOVR]
>   is set [ editor's note: this is what my patch does ]. FPE bit is set
>   in the FD status.
> * Frame size error. The Ethernet MAC detected a frame that its length
>   exceeds the maximum allowed as configured in the MAC registers. The
>   frame is truncated by the MAC to the maximum allowed, and it is marked
>   as truncated. The BMI sets FSE in the FD status and forwards the frame
>   to next module in the FMan as usual.
> * Some other network error may result in the frame being discarded by
>   the MAC and not shown to the BMI. However, the MAC is responsible for
>   counting such errors in its own statistics counters.
>
> So yes, packets with bad FCS are accepted with FMBM_RCFG[FDOVR] set.
> But it would be interesting to see what is the value of "fd_status" in
> rx_default_dqrr() for bad packets. You know, in the DPAA world, the
> correct approach to solve this problem would be to create a
> configuration to describe a "soft examination sequence" for the
> programmable hardware "soft parser", which identifies the DSA tag and

Yeah I know you can do that. It is a very flexible chip that can do all
kinds of fancy stuff...

> skips over a programmable number of octets. This allows you to be able
> to continue to do things such as flow steering based on IP headers
> located after the DSA tag, etc. This is not supported in the upstream
> FMan driver however, neither the soft parser itself nor an abstraction
> for making DSA masters DSA-aware. I think it would also require more

...but this is the problem. These accelerators are always guarded by
NDAs and proprietary code. If NXP could transpile XDP to dpaa/dpaa2 in
the kernel like how Netronome does it, we would never even talk to
another SoC-vendor.

> work than it took me to hack up this patch. But at least, if I
> understand correctly, with a soft parser in place, the MAC error
> counters should at least stop incrementing, if that is of any importance
> to you.

This is the tragedy: I know for a fact that a DSA soft parser exists,
but because of the aforementioned maze of NDAs and license agreements
we, the community, cannot have nice things.

>> If so, would that mean that we would have to verify it in software?
>
> I don't see any place in the network stack that recalculates the FCS if
> NETIF_F_RXALL is set. Additionally, without NETIF_F_RXFCS, I don't even
> know how could the stack even tell a packet with bad FCS apart from one
> with good FCS. If NETIF_F_RXALL is set, then once a packet is received,
> it's taken for granted as good.

Right, but there is a difference between a user explicitly enabling it
on a device and us enabling it because we need it internally in the
kernel.

In the first scenario, the user can hardly complain as they have
explicitly requested to see all packets on that device. That would not
be true in the second one because there would be no way for the user to
turn it off. It feels like you would end up in a similar situation as
with the user- vs. kernel- promiscuous setting.

It seems to me if we enable it, we are responsible for not letting crap
through to the port netdevs.

> There is a separate hardware bit to include the FCS in the RX buffer, I
> don't think this is what you want/need.
>
>> >> 
>> >> As a workaround, switching to EDSA (thereby always having a proper
>> >> EtherType in the frame) solves the issue.
>> >
>> > So basically every user needs to change the tag protocol manually to be
>> > able to receive from port 8? Not sure if that's too friendly.
>> 
>> No it is not friendly at all. My goal was to add it as a device-tree
>> property, but for reasons I will detail in my answer to Andrew, I did
>> not manage to figure out a good way to do that. Happy to take
>> suggestions.
>
> My two cents here are that you should think for the long term. If you
> need it due to a limitation which you have today but might no longer
> have tomorrow, don't put it in the device tree unless you want to
> support it even when you don't need it anymore.
