Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91C9F2CE13E
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 22:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729550AbgLCV6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 16:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727352AbgLCV6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 16:58:09 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FE0C061A4F
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 13:57:29 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id v22so3736772edt.9
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 13:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3EHTTIL4WiU0oCod52Ov1y3PaRdvgO9VMIUu4bAqa0=;
        b=HPfKizgww5uaSZyb/xqD4GC8hjpfX7p6qN2Y9lbAEyfyB8ekh1/Fz6W726lZa+kv6q
         N80kQ4HuhB6vb0mI23CQmzg5YelJ0lNieBUGkSmxGUlcRIZ9nCRaicXCwNswgoHyPQqv
         F61jC3+UEHHFvGc/5HS/E4qrtCuV4j9Nl0st8mKfruqe5B2h1swtgptJGT3t7V7yPzMo
         3mvvbVR5facRNC2hChqnHyTIFcgOZTB7xu3sMZQQAjpy6Vytw3V/0h15xYJQ4MqaRG4R
         qsFdZJZmOHnuqCa/VX6xztLCRXIY3AXef5TDy2F9etUEdgvEVNK5mgz1nLcf72b/L5Pp
         COWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j3EHTTIL4WiU0oCod52Ov1y3PaRdvgO9VMIUu4bAqa0=;
        b=g3X/yyqzRwMU8eUvC1aU/pcBZPGIyI6NAM/Gqr4JBziFz9yVbBNRiovh1BXW6tg3p6
         jHdk4w5wdlQ7LAZBtflKWY9IgDnh4WDRszf/Mt3sAsGepAXpMZKn4DZ4HkBoRS7T9hpu
         PHU8zRDeHRhTYYvy3lFB4kG/3bdzz16HF+OCCts+GKTTrYJylekmE+4VnbyogbxvSlki
         qHDpibi3ic5q+D6mPlnY1z87KIJe57s8CHMXL45vMMfRjxP39hww5zX4L1VYUfNj5lVO
         E0qdM9a7vGiu0i0/sCTm5eI1eTgeRead1KvAgacIY/N+jSfKo/h4ubrP05QEjOnXwsnq
         Hgjg==
X-Gm-Message-State: AOAM533VPqMDfjrAdXE1FP8AOyygignUiJ91LO3tjxmIia6vhffOVBVm
        myVxVi+o5Y7KuOw6Zt6ouCaksJaeCBc=
X-Google-Smtp-Source: ABdhPJzKPU1JdMRUqF4+A8m+5j96sPfExxI+znnJBH7mAQeBUiIVEqfaEse5/BT0fmYhk6RMagVpyQ==
X-Received: by 2002:a05:6402:b45:: with SMTP id bx5mr4693623edb.193.1607032648078;
        Thu, 03 Dec 2020 13:57:28 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id v18sm2036820edx.30.2020.12.03.13.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 13:57:27 -0800 (PST)
Date:   Thu, 3 Dec 2020 23:57:25 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201203215725.uuptum4qhcwvhb6l@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201203162428.ffdj7gdyudndphmn@skbuf>
 <87a6uu7gsr.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6uu7gsr.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 03, 2020 at 09:53:08PM +0100, Tobias Waldekranz wrote:
> > I like the fact that we revert to a software-based implementation for
> > features the hardware can't offload. So rejecting other TX types is out
> > of the question.
>
> Well if we really want to be precise, we must also ensure that the exact
> hash type is supported by the hardware. mv88e6xxx only supports
> NETDEV_LAG_HASH_L2 for example. There is a needle to thread here I
> think. Story time ('tis the season after all):

Fine, I'll go along with the story-telling mood, even if that'll make my
message less than concise or informative.

>
>     A user, Linus, has just installed OpenWRT on his gateway. Finally,
>     he can unlock the full potential of his 802.11 AP by setting up a
>     LAG to it.
>
>     He carefully studies teamd.conf(5) and rightfully comes to the
>     conclusion that he should set up the tx_hash to include the full
>     monty of available keys. Teamd gets nothing but praise from the
>     kernel when applying the configuration.
>
>     And yet, Linus is not happy - the throughput between his NAS and his
>     smart TV is now lower than before. It is enough for Linus to start
>     working on his OS. It won't be big and professional like Linux of
>     course, but it will at least get this bit right.
>
> One could argue that if Linus had received an error instead, adapted his
> teamd config and tried again, he would be a happier user and we might
> not have to compete with his OS.
>
> I am not sure which way is the correct one, but I do not think that it
> necessarily _always_ correct to silently fallback to a non-offloaded
> mode.

Of course, neither is fully correct. There is always more to improve on
the communication side of things. But DSA, which stands for "Not Just A
Switch", promises you, above all, a port multiplexer with the ability to
make full use of the network stack. Maybe I'm still under the influence
of a recent customer meeting I had, but there is a large base of use
cases there, where people just don't seem to have enough ports, and they
can just add a $3 switch to their system, and voila, problem solved.
Everything works absolutely the same as before. The newly added switch
ports are completely integrated with the kernel's IP routing database.
They aren't even switch ports, they're just ports.

And even there, on the software fallback front, we don't do enough,
currently. I've had other customers who said that they even _prefer_
to do bridging in software, in order to get a chance to run their
netfilter/ebtables based firewall on their traffic. Of course, DSA
currently has no idea when netfilter rules are installed, so I just told
them to hack the driver and remove the bridging offload, which they
happily did.

I suspect you're looking at this from the wrong angle. I did, too, for
the longest time, because I was focused on squeezing the most out of the
hardware I had. And "I feel cheated because the operating system sits
between me and the performance I want from my hardware" is an argument
I've heard all too often. But not everybody needs even gigabits of
traffic, or absurdly low latency. Making a product that works acceptably
and at a low cost is better than hand-picking only hardware that can
accelerate everything and spending $$$$ on it, for a performance
improvement that no user will notice. Doing link aggregation in software
is fine. Doing bridging in software is fine. Sure, the CPU can't compete
past a number of KPPS, but maybe it doesn't even have to.

Again, this doesn't mean that we should not report, somehow, what is
offloaded and what isn't, and more importantly, the reason why
offloading the set of required actions is not supported. And I do
realize that I wrote a long rant about something that has nothing to do
with the topic at hand, which is: should we deny bonding interfaces that
use balance-rr, active-backup, broadcast, balance-tlb, balance-alb on
top of a DSA interface? Hell no, you wouldn't expect an intel e1000 card
to error out when you would set up a bonding interface that isn't xor or
802.3ad, would you? But you wouldn't go ahead and set up bridging
offload either, therefore running into the problem I raised above with
netfilter rules. You would just set out to do what the user asked for,
in the way that you can, and let them decide if the performance is what
they need or not.

> > Should we add an array of supported TX types that the switch port can
> > offload, and that should be checked by DSA in dsa_lag_offloading?
>
> That would work. We could also create a new DSA op that we would call
> for each chip from PRECHANGEUPPER to verify that it is supported. One
> advantage with this approach is that we can just pass along the `struct
> netdev_lag_upper_info` so drivers always have access to all information,
> in the event that new fields are added to it for example.

Hmm, not super pleased to have yet another function pointer, but I don't
have any other idea, so I guess that works just fine.
I would even go out on a limb and say hardcode the TX_TYPE_HASH in DSA
for now. I would be completely surprised to see hardware that can
offload anything else in the near future.
