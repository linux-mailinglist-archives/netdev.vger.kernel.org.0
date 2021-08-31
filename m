Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC8F3FCD81
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 21:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240075AbhHaTG7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 15:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239852AbhHaTG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 15:06:58 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8AFC061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:06:02 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id q17so52782edv.2
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 12:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xacMz/b04mCsp/h1BcKghGZ/bJ9daM4OBFuEy5+SyIQ=;
        b=ShQEQr/MBBhdAnLPkHRC7s1CEE3iLVVTcMpwghmeRR6og5jSbSPLiCwQnlOe1SHfVi
         vMRh7/c+UoEPCUjRRXkBHKICmtRVoAZ28U7Yjti70gves3pobZ7Xyr4dVpSXFRCrHs5F
         6obq10sQaPKZglh4QX4w0IKH4rYi0Whq1aMzdvpQBJB5mYr14BgZ2Q/mHMdjG8mpwXpD
         xQtZjWm3TQz5GCn98IKLLD2WnUAhcz/CGuIEjSAPAQ9DA4dHgaBaE+cZ9zURbrVpvoeo
         OEWNByEj3f/vqYaUaM0X98e7y5yYb/2xayupqaxJaYnTiJaV0Ili4n2SiIEQtbDztaZw
         Z/dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xacMz/b04mCsp/h1BcKghGZ/bJ9daM4OBFuEy5+SyIQ=;
        b=uccki94WeY89arb8nwCtc51ort79MhcS8m+LxXESdUq5NXqDJaI9t1kcI3vQ6YLU2i
         NVJ6509x6kQXtWt2i+Tuhimsrqr9pp2nY5TdVzuKl5QX5Tm78cjkT9rWveJABVJUVl/y
         +EAIjLAlQ1elY4UtUVGTIMrEGnJ9jHtUq5kFxrokyDRINZcCVU2YO14VEQvoCZCjKJLT
         sz6FQe/OsNhyiiliPcm3GiCoXzAAI6ej8l1sLkfdVG/O2scUaaAgHO9t7UD742E0kgam
         1NEG9zYKbfueQcfhjgyiDhrLW1eX5xHfGjCjhriwB1xo6heCvQefiYUSQjO6o6UJA3me
         Px4Q==
X-Gm-Message-State: AOAM532Cq92iNPrRhoKOBNrYnzzg3SvfXK9GrobZC6lPShO44BAMVXby
        iqtAF8M9e4F9Z+8S7Qi+6o8=
X-Google-Smtp-Source: ABdhPJzq2v371jkUC7hIEwj1y1dCQIJJvVDUqzlEDpABnctFWx5NS29wWfMbBLSUg3r0YGjbS1jCKw==
X-Received: by 2002:a05:6402:2751:: with SMTP id z17mr30921920edd.290.1630436761465;
        Tue, 31 Aug 2021 12:06:01 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id p18sm3511262edu.86.2021.08.31.12.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 12:06:01 -0700 (PDT)
Date:   Tue, 31 Aug 2021 22:05:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
Subject: Re: [PATCH net] net: dsa: tag_rtl4_a: Fix egress tags
Message-ID: <20210831190559.3kiwaxyeyxn2733p@skbuf>
References: <20210828235619.249757-1-linus.walleij@linaro.org>
 <20210830072913.fqq6n5rn3nkbpm3q@skbuf>
 <CACRpkdbVs9H8CPYV9Fgwje40qqS=wxXqVkDc=Du=c82eqeKCAw@mail.gmail.com>
 <20210830222007.2i6k7pg72yuoygwh@skbuf>
 <CACRpkdbX4XErV-7UCezobF4jLX-HvjMHE=dnYYLqD5Sb8LkCpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbX4XErV-7UCezobF4jLX-HvjMHE=dnYYLqD5Sb8LkCpw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 08:35:05PM +0200, Linus Walleij wrote:
> On Tue, Aug 31, 2021 at 12:20 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > > > Does it get broadcast, or forwarded by MAC DA/VLAN ID as you'd expect
> > > > for a regular data packet?
> > >
> > > It gets broadcast :/
> >
> > Okay, so a packet sent to a port mask of zero behaves just the same as a
> > packet sent to a port mask of all ones is what you're saying?
> > Sounds a bit... implausible?
> >
> > When I phrased the question whether it gets "forwarded by MAC DA/VLAN ID",
> > obviously this includes the possibility of _flooding_, if the MAC
> > DA/VLAN ID is unknown to the FDB. The behavior of flooding a packet due
> > to unknown destination can be practically indistinguishable from a
> > "broadcast" (the latter having the sense that "you've told the switch to
> > broadcast this packet to all ports", at least this is what is implied by
> > the context of your commit message).
> >
> > The point is that if the destination is not unknown, the packet is not
> > flooded (or "broadcast" as you say). So "broadcast" would be effectively
> > a mischaracterization of the behavior.
> 
> Oh OK sorry what I mean is that the packet appears on all ports of
> the switch. Not sent to the broadcast address.

Yes, but why (due to which hardware decision does this behavior take place)?

I was not hung up on the "broadcast" word. That was used a bit imprecisely,
but I got over that. I was curious as to _why_ would the packets be
delivered to all ports of the switch. After all, you told the switch to
send the packet to _no_ port :-/

The reason why I'm so interested about this is because other switches
(mt7530) treat a destination port mask of 0x0 as "look up the FDB"
(reported by Qingfang here):
https://patchwork.kernel.org/project/netdevbpf/patch/20210825083832.2425886-3-dqfext@gmail.com/#24407683

This means it would be possible to implement the bridge TX forwarding
offload feature:
https://patchwork.kernel.org/project/netdevbpf/cover/20210722155542.2897921-1-vladimir.oltean@nxp.com/

I just wanted to know what type of packets were you testing with. If you
were testing with a unidirectional stream (where the switch has no
opportunity to learn the destination MAC on a particular port), then it
is much more likely that what's happening in your case is that the
packets were flooded, and not simply "broadcast". Pick a different MAC
DA, which _is_ learned in the FDB, and the packets would not be
"broadcast" (actually flooded) at all.

This is still my hypothesis about what was going on.

> > Just want to make sure that the switch does indeed "broadcast" packets
> > with a destination port mask of zero. Also curious if by "all ports",
> > the CPU port itself is also included (effectively looping back the packet)?
> 
> It does not seem to appear at the CPU port. It appear on ports
> 0..4.

Which again would be consistent with my theory.

> > > > > -     out = (RTL4_A_PROTOCOL_RTL8366RB << 12) | (2 << 8);
> > > >
> > > > What was 2 << 8? This patch changes that part.
> > >
> > > It was a bit set in the ingress packets, we don't really know
> > > what egress tag bits there are so first I just copied this
> > > and since it turns out the bits in the lower order are not
> > > correct I dropped this too and it works fine.
> > >
> > > Do you want me to clarify in the commit message and
> > > resend?
> >
> > Well, it is definitely not a logical part of the change. Also, a bug fix
> > patch that goes to stable kernels seems like the last place to me where
> > you'd want to change something that you don't really know what it does...
> > In net-next, this extra change is more than welcome. Possibly has
> > something to do with hardware address learning on the CPU port, but this
> > is just a very wild guess based on some other Realtek tagging protocol
> > drivers I've looked at recently. Anyway, more than likely not just a
> > random number with no effect.
> 
> Yeah but I don't know anything else about it than that it appear
> in the ingress packets which are known to have a different
> format than the egress packets, the assumption that they were
> the same format was wrong ... so it seems best to drop it as well.
> But if you insist I can defer that to a separate patch for next.
> I just can't see that it has any effect at all.

I was about to say that you can do as you wish, but I see you've resent
already. In general it is good to keep a change to the point, and
documented well and clear.
