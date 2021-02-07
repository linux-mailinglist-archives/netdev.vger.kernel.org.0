Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A281E312683
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 18:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBGR5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 12:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhBGR5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 12:57:07 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5FF6C06174A
        for <netdev@vger.kernel.org>; Sun,  7 Feb 2021 09:56:26 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id 2so6014260qvd.0
        for <netdev@vger.kernel.org>; Sun, 07 Feb 2021 09:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AmKdXhnMmhh2qdJMK40kptFf+aukBbJ7hh0zcn8qXQ8=;
        b=al38wOd7XjTXg7DhFPbxgdLk+WNcLZJWY4VAdejvl0JDv6DpaU2IWhzHcd3NSwNSxo
         1ErlC4r3CWYf39859liZ5w+jv40Yb3s4XvxOqG7w/oIbwJ4ohnWJa8yuW2ITQH0zftvC
         Vz/eAcZkA0yJZuRdiy4y1v8KGa3v1fb2dP/eRlAuqCIRu7s7tKpNQ8I91wzYXSIxjfgk
         2iLtR8TlC8Z5h7O/DJtLwURZQzIofRRDdXoVgxGARNy5IMzFD37shxnAXP0STfD+JYA2
         fZNu+kP8/d8wP1atKjJjobua07CbD2kDuzx6yWzPXbKejAj2eBjKGvPtGjqT2fbBHkrX
         LiLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AmKdXhnMmhh2qdJMK40kptFf+aukBbJ7hh0zcn8qXQ8=;
        b=Kt2LD85Clpmh8lGfV4SuyDzEy/SMcSWe/oD9YY5OQA/nn2neIZ+UC0radOEpP7jSJ+
         MolzkKX/ZqkwuEoWJi/guCMY9T3N2wKUb4ivCfbdFpreuLSCzFuhpYhPTG16FPZ3OD78
         DS+c6uqkuxJjXxh9K1XnCtCo8NceaLSkzZzPCpcBkHAa63C7MHsOBbaniQWDqi47G16T
         R48dh428M07sGCfcbAmduO67ZYNJZ38YbKdW2j7iFRvQayB03KwCcLE2YcKkYQdLM7CV
         cWr9c4WJikCyBTHBXVjWPxbMjG/inBogv7FkGDsncUebgIuYb/ac6nVFOKnUG0LHbzQ1
         /Qfw==
X-Gm-Message-State: AOAM533rnrzvQpiovDj0M0gf2feiCWrdBW6k+mglfzP7itK6OKsbRxrV
        sEWBNz3JY/xERMTcosIwekLzyDTDiCqkErsqFNA=
X-Google-Smtp-Source: ABdhPJwYeAcl8DZ/C1TfXGdHijNzhGJvGfEUmukvm95YF5+/JdABSJRiaEA1NDUQVL6Q8rG/WRF8KlYVDcZf5JfdLd4=
X-Received: by 2002:a0c:ca8e:: with SMTP id a14mr13257188qvk.58.1612720586020;
 Sun, 07 Feb 2021 09:56:26 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se> <20210123195916.2765481-15-jonas@norrbonn.se>
 <5c94d0f6-4d35-6654-4fde-1eebbcc7d74f@norrbonn.se>
In-Reply-To: <5c94d0f6-4d35-6654-4fde-1eebbcc7d74f@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 7 Feb 2021 09:56:15 -0800
Message-ID: <CAOrHB_Abui8VgSm2xTxq0fbKRSMLO0nzAsWkwMkd7JioLqpDJA@mail.gmail.com>
Subject: Re: [RFC PATCH 14/16] gtp: add support for flow based tunneling
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Harald Welte <laforge@gnumonks.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 10:06 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Pravin et al;
>
> TL;DR:  we don't need to introduce an entire collect_md mode to the
> driver; we just need to tweak what we've got so that metadata is
> "always" added on RX and respected on TX; make the userspace socket
> optional and dump GTP packets to netstack if it's not present; and make
> a decision on whether to allow packets into netstack without validating
> their IP address.
>
Thanks for summarizing the LWT mechanism below. Overall I am fine with
the changes, a couple of comments inlined.


> On 23/01/2021 20:59, Jonas Bonn wrote:
> > From: Pravin B Shelar <pbshelar@fb.com>
> >
> > This patch adds support for flow based tunneling, allowing to send and
> > receive GTP tunneled packets via the (lightweight) tunnel metadata
> > mechanism.  This would allow integration with OVS and eBPF using flow
> > based tunneling APIs.
> >
> > The mechanism used here is to get the required GTP tunnel parameters
> > from the tunnel metadata instead of looking up a pre-configured PDP
> > context.  The tunnel metadata contains the necessary information for
> > creating the GTP header.
>
>
> So, I've been investigating this a bit further...
>
> What is being introduced in this patch is a variant of "normal
> functionality" that resembles something called "collect metadata" mode
> in other drivers (GRE, VXLAN, etc).  These other drivers operate in one
> of two modes:  more-or-less-point-to-point mode, or this alternative
> collect metadata varaint.  The latter is something that has been bolted
> on to an existing implementation of the former.
>
> For iproute2, a parameter called 'external' is added to the setup of
> links of the above type to switch between the two modes; the
> point-to-point parameters are invalid in 'external' (or 'collect
> metadata') mode.  The name 'external' is because the driver is
> externally controlled, meaning that the tunnel information is not
> hardcoded into the device instance itself.
>
> The GTP driver, however, has never been a point-to-point device.  It is
> already 'externally controlled' in the sense that tunnels can be added
> and removed at any time.  Adding this 'external' mode doesn't
> immediately make sense because that's roughly what we already have.
>
> Looking into how ip_tunnel_collect_metadata() works, it looks to me like
> it's always true if there's _ANY_ routing rule in the system with
> 'tunnel ID' set.  Is that correct?  I'll assume it is in order to
> continue my thoughts.
>
Right. It is just optimization to avoid allocating tun-dst in datapath.

> So, with that, either the system is collecting SKB metadata or it isn't.
>   If it is, it seems reasonable that we populate incoming packets with
> the tunnel ID as in this patch.  That said, I'm not convinced that we
> should bypass the PDP context mechanism entirely... there should still
> be a PDP context set up or we drop the packet for security reasons.
>
> For outgoing packets, it seems reasonable that the remote TEID may come
> from metadata OR a PDP context.  That would allow some routing
> alternatives to what we have right now which just does a PDP context
> lookup based on the destination/source address of the packet.  It would
> be nice for OVS/BPF to be able to direct a packet to a remote GTP
> endpoint by providing that endpoint/TEID via a metadata structure.
>
> So we end up with, roughly:
>
> On RX:
> i) check TEID in GTP header
> ii) lookup PDP context
> iii) validate IP of encapsulated packet
> iv) if ip(tunnel_collect_metadata()) { /* add tun info */ }
> v) decapsulate and pass to network stack
>
> On TX:
> i) if SKB has metadata, get destination and TEID from metadata (tunnel ID)
> ii) otherwise, lookup PDP context for packet
>
> For RX, only iv) is new; for TX only step i) is new.  The rest is what
> we already have.
>
> The one thing that this complicates is the case where an external entity
> (OVS or BPF) is doing validation of packet IP against incoming TEID.  In
> that case, we've got double validation of the incoming address and, I
> suppose, OVS/BPF would perhaps be more efficient (?)...  In that case,
> holding a PDP context is a bit of a waste of memory.
>
> It's somewhat of a security issue to allow un-checked packets into the
> system, so I'm not super keen on dropping the validation of incoming
> packets; given the previous paragraph, however, we might add a flag when
> creating the link to decide whether or not we allow packets through even
> if we can't validate them.  This would also apply to packets without a
> PDP context for an incoming TEID, too.  This flag, I suppose, looks a
> bit like the 'collect_metadata' flag that Pravin has added here.
>
Yes. user should have the option to use GTP devices in LTW mode and
bypass PDP session context completely. Lets add a flag for GTP link to
have consistent behaviour for all types of LWT devices.

> The other difference to what we currently have is that this patch sets
> up a socket exclusively in kernel space for the tunnel; currently, all
> sockets terminate in userspace:  userspace receives all packets that
> can't be decapsulated and re-injected in to the network stack.  With
> this patch, ALL packets (without a userspace termination) are
> re-injected into the network stack; it's just that anything that can't
> be decapsulated gets injected as a "GTP packet" with some metadata and
> an UNKNOWN protocol type.  If nothing is looking at the metadata and
> acting on it, then these will just get dropped; and that's what would
> happen if nothing was listening on the userspace end, too.  So we might
> as well just make the FD1 socket parameter to the link setup optional
> and be done with it.
>
Good idea to make FD1 optional argument.

Thanks.
