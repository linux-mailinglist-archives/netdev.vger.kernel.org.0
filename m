Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF51D29D758
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733168AbgJ1WXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732703AbgJ1WWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:22:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5A1C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:22:44 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a9so678290wrg.12
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 15:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K65zWHLh8YR1nSyqpCHIs4Qmst6KnZTXHcFHET+GAws=;
        b=b5fMx7OpB4F7D0eMs/HqkOCHcOJwwaipdGMoK9TSy1xZjwUifCp+w5O+QQOHW60F9M
         vbda5a5GGTlTJS7SSbafL4pwjxmSnElAlK5FZxBrknb2b05INJ0o9rcjYhOr99i7c00U
         2lzj89LbUF3eaaFqk/MZFfj/BIsLy7J0GEBmtj1aavp3JWRJ/02v3d6vNonB3sd5ixdA
         O5E8Kqxmws/ucy5yBioRYpdaLDqJRkNFbokYvPW09tAplsGyq6EaTLjfyPsIg2k4PUsw
         ZjMfZESbUx/ZjE4j2PU0clEHYOIbdZdRtLORzIktEUPgXohbCIB5gW0NxKErHGyw6x+L
         gwag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K65zWHLh8YR1nSyqpCHIs4Qmst6KnZTXHcFHET+GAws=;
        b=lD+mSSHEYJhmccMDvwNfUVlycB6B49ntuAKQ3kalF7emBoYuTCzKrJqFOSPy2GQT0J
         ceiEqU04YS8+5bEniVL0JtWgCLOoCUC1oC9U+mgWPll0dv9d4mWOaLVBu6bIaRoSBmkk
         Czqddh4q0ii40eTUml4q5CUt+kn/VCj8rqEQackN1MFOXKjffHJydtceeoZbBgWqLIvM
         4nmQV3WvPdx7SkamwnP0ESYvGnwrVqTXfqamo9gqeeoqGQSR7NmZ3vlhxjyyfUDiA1Mb
         TVJNPLkRmHZvfzLKHl1qwhCgsry3JtoRZM2u7QvAbrZ7bVVorrmxchXfnZEibU49CGX8
         C8BQ==
X-Gm-Message-State: AOAM5316huYUU5EUOqbOksLtf4RzDklpgBf7yLg9B4knfLZP0dbaHgAn
        uu8c1ZaiY+dBhBAtLnIjPRhgqg2G56Y=
X-Google-Smtp-Source: ABdhPJyhGuDRqsIfiyJbjlZXDwLIuuOm0Wtw15Foj9EdrKiuirQ8pqzK/Er/YTG+2q5vB2pm5OIyBw==
X-Received: by 2002:a17:906:38d8:: with SMTP id r24mr398355ejd.32.1603909105899;
        Wed, 28 Oct 2020 11:18:25 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id v21sm216046edt.80.2020.10.28.11.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 11:18:25 -0700 (PDT)
Date:   Wed, 28 Oct 2020 20:18:24 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC PATCH 4/4] net: dsa: tag_edsa: support reception of packets
 from lag devices
Message-ID: <20201028181824.3dccguch7d5iij2r@skbuf>
References: <20201028120515.gf4yco64qlcwoou2@skbuf>
 <C6OMPK3XEMGG.1243CP066VN7O@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C6OMPK3XEMGG.1243CP066VN7O@wkz-x280>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Ido here, he has some more experience with the do's and dont's
here, and therefore might have one or two ideas to share.

On Wed, Oct 28, 2020 at 04:28:23PM +0100, Tobias Waldekranz wrote:
> On Wed Oct 28, 2020 at 3:05 PM CET, Vladimir Oltean wrote:
> > On one hand, I feel pretty yucky about this change.
> > On the other hand, I wonder if it might be useful under some conditions
> > for drivers with DSA_TAG_PROTO_NONE? For example, once the user bridges
> > all slave interfaces, then that bridge will start being able to send and
> > receive traffic, despite none of the individual switch ports being able
> > to do that. Then, you could even go off and bridge a "foreign"
> > interface,
> > and that would again work properly. That use case is not supported
> > today,
> > but is very useful.
> >
> > Thoughts?
> 
> In a scenario like the one you describe, are you saying that you would
> set skb->dev to the bridge's netdev in the rcv op?
> 
> On ingress I think that would work. On egress I guess you would be
> getting duplicates for all multi-destination packets as there is no
> way for the none-tagger to limit it, right? (Unless you have the
> awesome tx-offloading we talked about yesterday of course :))
> 
> I think bridging to "foreign" interfaces still won't work, because on
> ingress the packet would never be caught by the bridge's rx
> handler. In order for something to be received by br_input.c, it has
> to pass through an interface that is attached to it, no?  Everything
> above the bridge (like VLAN interfaces) should still work though.

Yes, I expect that the bridge input would need to have one more entry
path into it than just br_handle_frame.

I'm a bit confused and undecided right now, so let's look at it from a
different perspective. Let's imagine a switchdev driver (DSA or not)
which is able to offload IP forwarding. There are some interfaces that
are bridged and one that is standalone. The setup looks as below.

 IP interfaces
                +---------------------------------------------------------+
                |                           br0                           |
                +---------------------------------------------------------+

 +------------+ +------------+ +------------+ +------------+ +------------+
 |    swp0    | |    swp1    | |    swp2    | |    swp3    | |    eth0    |
 +------------+ +------------+ +------------+ +------------+ +------------+

 Hardware interfaces

 +------------+ +------------+ +------------+ +------------+ +------------+
 | DSA port 0 | | DSA port 1 | | DSA port 2 | | DSA port 3 | |   e1000    |
 +------------+ +------------+ +------------+ +------------+ +------------+

Let's say you receive a packet on the standalone swp0, and you need to
perform IP routing towards the bridged domain br0. Some switchdev/DSA
ports are bridged and some aren't.

The switchdev/DSA switch will attempt to do the IP routing step first,
and it _can_ do that because it is aware of the br0 interface, so it
will decrement the TTL and replace the L2 header.

At this stage we have a modified IP packet, which corresponds with what
should be injected into the hardware's view of the br0 interface. The
packet is still in the switchdev/DSA hardware data path.

But then, the switchdev/DSA hardware will look up the FDB in the name of
br0, in an attempt of finding the destination port for the packet. But
the packet should be delivered to a station connected to eth0 (e1000,
foreign interface). So that's part of the exception path, the packet
should be delivered to the CPU.

But the packet was already modified by the hardware data path (IP
forwarding has already taken place)! So how should the DSA/switchdev
hardware deliver the packet to the CPU? It has 2 options:

(a) unwind the entire packet modification, cancel the IP forwarding and
    deliver the unmodified packet to the CPU on behalf of swp0, the
    ingress port. Then let software IP forwarding plus software bridging
    deal with it, so that it can reach the e1000.
(b) deliver the packet to the CPU in the middle of the hardware
    forwarding data path, where the exception/miss occurred, aka deliver
    it on behalf of br0. Modified by IP forwarding. This is where we'd
    have to manually inject skb->dev into br0 somehow.

Maybe this sounds a bit crazy, considering that we don't have IP
forwarding hardware with DSA today, and I am not exactly sure how other
switchdev drivers deal with this exception path today. But nonetheless,
it's almost impossible for DSA switches with IP forwarding abilities to
never come up some day, so we ought to have our mind set about how the
RX data path should like, and whether injecting directly into an upper
is icky or a fact of life.

Things get even more interesting when this is a cascaded DSA setup, and
the bridging and routing are cross-chip. There, the FIB/FDB of 2 there
isn't really any working around the problem that the packet might need
to be delivered to the CPU somewhere in the middle of the data path, and
it would need to be injected into the RX path of an upper interface in
that case.

What do you think?
