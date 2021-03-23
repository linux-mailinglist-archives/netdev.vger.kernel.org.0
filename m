Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DE8346DC4
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 00:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhCWXPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 19:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbhCWXPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 19:15:12 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47375C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 16:15:11 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id z1so25495569edb.8
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 16:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IItw5NJgnJggMqKR8JDbynFnZKOn0gJ1rQihjP9ZGd4=;
        b=eXHGo/+7LZjQkrxdFKgeaZtvF8NLeJ83Z/C3x/FI5YgU/LjFFbn/BziOhr65yYGHN3
         Mnp6DVKWm4pJPDtj5ZsOsFnQag3sk/cvSC7XU31P8XWm/gJ7Ou76EcNCRhPZrnk3ce0e
         TBdIdArE6bof8xkqctqagKBJPjaVIqdxlbGR+jUTH6UDVxJHIKa0TaIGMZZ1n9mOXbl+
         DGuU0v7sH0XEVxKiBNf2Pdg6iAwCeD9joM+X6VjLWpA+KROTrgyB7JEEdFNFL+vSFGU4
         Yeafo9aEhIiOSj51L4Etb7EUvR1jw3SkoemhJf4XZ7nx35z6zEkfcq7BRflD82ch+t7u
         WQ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IItw5NJgnJggMqKR8JDbynFnZKOn0gJ1rQihjP9ZGd4=;
        b=ZUTpthg2s92qAbQODinSbagm51Nd16hkA0yQdECiZK77M0Q4p05EjAyF/o1UeojBjT
         G1OoHyLVdaR5XHtwhrGDNNiJZtJ/1p/2ujdLU3OzwAmnar4Rr3B8u9RCB2WiisxC8hLR
         NmxpFWFPt0BADLfO9ji7oYCmTnZ9XH7edIG8sjkEe6v4O/xS22exjEdwRRAg5m++z1rK
         iQKBTdIZbOCrW8GWrkV2+dtfYGGeLM6r5v5zwJdXUIW5B9iZpZ2BURkb/eiloLthzQwu
         a27IeEZ++DC08YY2sCWIB8LnZfvRgrbER4Bx/Sm5iuBH0rxsy/gw8tlYcteQ/WEJDXfT
         Ifqw==
X-Gm-Message-State: AOAM530RaetHGJXCK3CwSjKTiQ2jaKg7hCf1qLrUzg51kXroP78V4sAC
        T5lvtUX4RDFpyMXBJDdUMgo=
X-Google-Smtp-Source: ABdhPJym7s2QseuA/jj543DwrsD9R0pE6qFACN+vtpeE+GzDaKEBLQQrGruC//HgQLv4DUeEHu3TVw==
X-Received: by 2002:aa7:c447:: with SMTP id n7mr225542edr.171.1616541309921;
        Tue, 23 Mar 2021 16:15:09 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id si7sm78684ejb.84.2021.03.23.16.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 16:15:09 -0700 (PDT)
Date:   Wed, 24 Mar 2021 01:15:08 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210323231508.zt2knmica7ecuswf@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
 <20210323190302.2v7ianeuwylxdqjl@skbuf>
 <8735wlmuxh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735wlmuxh.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 10:17:30PM +0100, Tobias Waldekranz wrote:
> On Tue, Mar 23, 2021 at 21:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Tue, Mar 23, 2021 at 03:48:51PM +0100, Tobias Waldekranz wrote:
> >> On Tue, Mar 23, 2021 at 13:35, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > The netdev_uses_dsa thing is a bit trashy, I think that a more polished
> >> > version should rather set NETIF_F_RXALL for the DSA master, and have the
> >> > dpaa driver act upon that. But first I'm curious if it works.
> >> 
> >> It does work. Thank you!
> >
> > Happy to hear that.
> >
> >> Does setting RXALL mean that the master would accept frames with a bad
> >> FCS as well?
> >
> > Do you mean from the perspective of the network stack, or of the hardware?
> >
> > As far as the hardware is concerned, here is what the manual has to say:
> >
> > Frame reception from the network may encounter certain error conditions.
> > Such errors are reported by the Ethernet MAC when the frame is transferred
> > to the Buffer Manager Interface (BMI). The action taken per error case
> > is described below. Besides the interrupts, the BMI is capable of
> > recognizing several conditions and setting a corresponding flag in FD
> > status field for Host usage. These conditions are as follows:
> >
> > * Physical Error. One of the following events were detected by the
> >   Ethernet MAC: Rx FIFO overflow, FCS error, code error, running
> >   disparity error (in applicable modes), FIFO parity error, PHY Sequence
> >   error, PHY error control character detected, CRC error. The BMI
> >   discards the frame, or enqueue directly to EFQID if FMBM_RCFG[FDOVR]
> >   is set [ editor's note: this is what my patch does ]. FPE bit is set
> >   in the FD status.
> > * Frame size error. The Ethernet MAC detected a frame that its length
> >   exceeds the maximum allowed as configured in the MAC registers. The
> >   frame is truncated by the MAC to the maximum allowed, and it is marked
> >   as truncated. The BMI sets FSE in the FD status and forwards the frame
> >   to next module in the FMan as usual.
> > * Some other network error may result in the frame being discarded by
> >   the MAC and not shown to the BMI. However, the MAC is responsible for
> >   counting such errors in its own statistics counters.
> >
> > So yes, packets with bad FCS are accepted with FMBM_RCFG[FDOVR] set.
> > But it would be interesting to see what is the value of "fd_status" in
> > rx_default_dqrr() for bad packets. You know, in the DPAA world, the
> > correct approach to solve this problem would be to create a
> > configuration to describe a "soft examination sequence" for the
> > programmable hardware "soft parser", which identifies the DSA tag and
> 
> Yeah I know you can do that. It is a very flexible chip that can do all
> kinds of fancy stuff...
> 
> > skips over a programmable number of octets. This allows you to be able
> > to continue to do things such as flow steering based on IP headers
> > located after the DSA tag, etc. This is not supported in the upstream
> > FMan driver however, neither the soft parser itself nor an abstraction
> > for making DSA masters DSA-aware. I think it would also require more
> 
> ...but this is the problem. These accelerators are always guarded by
> NDAs and proprietary code.

Hey, that is simply not true. [ this is even more hilarous, given that
you are criticizing NXP about openness in a thread about Marvell hardware ]

I just created an account on nxp.com using my gmail email address, then
I typed "T1023" in the search bar, clicked on "T1024", clicked the
"Documentation" tab, went to the "Reference Manual" section, hit "More",
selected "T1024DPAArm, QorIQ T1024 Data Path Acceleration Architecture
(DPAA) Reference Manual", and it downloaded T1042DPAARM.pdf right away.
And that has 1373 pages of 'all you can eat' about the DPAA hardware.
And this user manual is _specifically_ for the network subsystem, the
SoC has a separate user manual (T1024RM.pdf) which has another 2121
pages about the other peripherals.

> If NXP could transpile XDP to dpaa/dpaa2 in the kernel like how
> Netronome does it, we would never even talk to another SoC-vendor.

'More complicated than it's worth' is, I believe, what the verdict on
that was. DPAA is an unbelievably complicated architecture living in a
universe of its own. Also, it was designed at the beginning of the
multi-core/multi-queue era, when it wasn't at all clear that Linux would
become the dominant operating system for embedded networking, but merely
one of the many contenders. So you'll find things like a queuing and
buffer management system optimized for dispatching towards many packet
processing engines arranged in composable pipelines, and with seemingly
exotic features such as order preservation for parallel processing of a
single network flow. Whereas in Linux, the dominant model [ coming from x86 ]
is that where 1 queue + 1 buffer pool are compressed into 1 ring which
goes to 1 CPU, which is a much more efficient data structure for
single-core, CPU-intensive processing, so that model won out. The way
the Linux drivers for DPAA make use of the hardware features is so poor
not because of lack of willpower, but due to an explosive combination of
dated hardware design and overengineering.

And DPAA2 is basically the response to the criticism that with DPAA1 it was
stupidly complicated to send a packet. With DPAA2 it's just as complicated,
except that now, most of the hardware intricacies are managed by a
firmware. The idea behind this was that it was supposed to make the
integration with operating systems easier, and many people smarter than
me say it's for the better.

Of course, all of these look like mistakes when seen through the lens of
hindsight, but I don't think I can really judge, just observe.

But many open source frameworks for packet acceleration with DPAA were
tried, rest assured. If you scan the "external/qoriq" project from
https://source.codeaurora.org/, I'm sure you'll find more code than you
can digest.

On the other hand, there _is_ support in the mainline kernel for both
dpaa and dpaa2 for native XDP, which is a modern framework that gives
you decent enough throughput for CPU-based packet processing.

> > work than it took me to hack up this patch. But at least, if I
> > understand correctly, with a soft parser in place, the MAC error
> > counters should at least stop incrementing, if that is of any importance
> > to you.
> 
> This is the tragedy: I know for a fact that a DSA soft parser exists,
> but because of the aforementioned maze of NDAs and license agreements
> we, the community, cannot have nice things.

Oh yeah? You can even create your own, if you have nerves of steel and a
thick enough skin to learn to use the "fmc" (Frame Manager Configuration
Tool) program, which is fully open source if you search for it on CAF
(and if you can actually make something out of the source code).

And this PDF (hidden so well behind the maze of NDAs, that I just had to
google for it, and you don't even need to register to read it):
https://www.nxp.com/docs/en/user-guide/LSDKUG_Rev20.12.pdf
is chock full of information on what you can do with it, see chapters 8.2.5 and 8.2.6.

Personally, I am not ashamed to admit that I'm too stupid to use it.
But to blame the mainline unavailability of these features on lack of
openness is unfair. Poor integration with Linux networking concepts?
Lack of popularity or demand from Linux users? Maybe, but that would
imply a certain circularity, and that would paint things in a
not-so-black-and-white tone, which you want to avoid.

If you want to do any sort of development around that area, I'm sure
you'd be raised a statue and sung odes to.

[ enough about DPAA ]

> >> If so, would that mean that we would have to verify it in software?
> >
> > I don't see any place in the network stack that recalculates the FCS if
> > NETIF_F_RXALL is set. Additionally, without NETIF_F_RXFCS, I don't even
> > know how could the stack even tell a packet with bad FCS apart from one
> > with good FCS. If NETIF_F_RXALL is set, then once a packet is received,
> > it's taken for granted as good.
> 
> Right, but there is a difference between a user explicitly enabling it
> on a device and us enabling it because we need it internally in the
> kernel.
> 
> In the first scenario, the user can hardly complain as they have
> explicitly requested to see all packets on that device. That would not
> be true in the second one because there would be no way for the user to
> turn it off. It feels like you would end up in a similar situation as
> with the user- vs. kernel- promiscuous setting.
> 
> It seems to me if we enable it, we are responsible for not letting crap
> through to the port netdevs.

Yes, the advantage of NETIF_F_RXALL is that you treat error packets as
normal, the disadvantage is that you treat error packets as normal.

So I think all the options were laid out:
- Make the driver use EDSA by default when it can, because that has
  better compatibility with masters, then users who care about
  performance can dynamically switch [ back ] to DSA. Pro: is simple,
  con: may affect somebody relying on the default behavior
- Make your board parse a custom device tree binding which tells it what
  initial tagging protocol to use. Pro: addresses the con of the above.
  Con: kinda hacky.
- Make the DSA master ignore parser errors. Pro: see above. Con: see above.
- Teach the DSA master to have a minimal understanding of the DSA header.
  Pro: is the right thing to do, is compatible and better for more
  advanced use cases. Con: is more complicated than the alternatives.
