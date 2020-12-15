Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281172DA702
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 05:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgLOEBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 23:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgLOEAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 23:00:55 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47284C061793
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 20:00:15 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id v67so17668431ybi.1
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 20:00:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlZdIao1w4rKceJj4NEQKHadqijsMwQQDzIFeMc2pfQ=;
        b=BLWTtHpePfNjnNHv36Y4fZ2+rhB48u1XIKJumioNhstioK1HBc8asCw7q9KAnYoixY
         JUiiHmfJKB0JYMdguQpz3r+/LhZjMMHuD6Jp4o2lP82m9A6x51qTj+HiI1BFW+xaFE0x
         bAKeYsw8kQJQMvxoYcri3j8VOte/tdd4rw1H31YebXPGBidxQE71VeIYvesjT4umNBbA
         HzCViD6bvPVvCrTrF9cM5UJ2lHbVzxG/3/HzOt7Sx7NLa7/W5U7Lof2iI+qeL26FUoif
         NzxJCe391BJd1LofRh2ydW9sRcqEnMmijm3u4BrFK0JXtGO4TJ83Qkfp2tTUcBfDwLw1
         beeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlZdIao1w4rKceJj4NEQKHadqijsMwQQDzIFeMc2pfQ=;
        b=WXMWJZVT+JgznwLvZCd+Vt5GcQQkWSuzPTA2b3xLNqbxXfxQMT9Tmvg/2Iif47azTV
         8ZQe4fYYgZTlHpftHkqWusd/coE98+6sL3Yvio7ZsEgZsFacwagJ5Wq0McR2wRimdSXW
         0d2mt7IWAeSUNZb386EgzGTrxBSeObAX/xRhtDcI9fQ73bgg/+vlP1QD1vmqA3XoRY3R
         B46gywcWFIZJczNCmWPJUEgH4GT3w2IG/Aus+aRXXi63aFYUVB+V2S+xdWo2+WcgW6q/
         q/wNly2vyo5gtptkIR1/6kuQglFOdTxBEXhJZNIrThRnws+IoH0piLENZzabs1NkMmlE
         Syvg==
X-Gm-Message-State: AOAM530CFdNXy89dCq33ni2Phf3f2oP/I21kd/kDMyFDold2gFQixeN7
        AUl0fwqjN8CbgUIlYYCY6VZywTXJltr3/rPoPFk=
X-Google-Smtp-Source: ABdhPJwatoSMrvRYDKIt49jytUg8d6p11CiYfabz9MXtBKwyeMJaYjNSyo9spoWX9FxGIbJ9P6fOr2BaxWhVEUmNUwY=
X-Received: by 2002:a25:428d:: with SMTP id p135mr40370545yba.316.1608004814405;
 Mon, 14 Dec 2020 20:00:14 -0800 (PST)
MIME-Version: 1.0
References: <20201212044017.55865-1-pbshelar@fb.com> <67f7c207-a537-dd22-acd8-dcce42755d1a@norrbonn.se>
 <CAOrHB_Dpq+ZnUxQ3PWSxPv_a7N+WPqdczuD=iG_YDpC-r8Q82Q@mail.gmail.com> <d739b613-0d8f-9339-4bc4-3c4270e58c67@norrbonn.se>
In-Reply-To: <d739b613-0d8f-9339-4bc4-3c4270e58c67@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Mon, 14 Dec 2020 20:00:03 -0800
Message-ID: <CAOrHB_Drah9B5vqO9DvSRQUNs7X98AFy8uKxiK_vx5THXH0hPQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] GTP: add support for flow based tunneling API
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Pravin B Shelar <pbshelar@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>, laforge@gnumonks.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:29 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Pravin,
>
> On 13/12/2020 20:32, Pravin Shelar wrote:
> > On Sat, Dec 12, 2020 at 11:56 PM Jonas Bonn <jonas@norrbonn.se> wrote:
> >>
> >> Hi Pravin,
> >>
> >> I've been thinking a bit about this and find it more and more
> >> interesting.  Could you post a bit of information about the ip-route
> >> changes you'll make in order to support GTP LWT encapsulation?  Could
> >> you provide an example command line?
> >>
> > This is done as part of the magma core project
> > (https://www.magmacore.org/) that needs OVS GTP support.
> > I have started with OVS integration first, there are unit tests that
> > validate the GTP support. This is datapath related test, that has the
> > setup commands:
> > https://github.com/pshelar/ovs/blob/6ec6a2a86adc56c7c9dcab7b3a7b70bb6dad35c9/tests/system-layer3-tunnels.at#L158
>
> That link just shows the classic setup using gtp-link and gtp-tunnel
> from libgtpnl.  It doesn't exercise LWT at all.
>
OVS add-port (ref ADD_OVS_TUNNEL) creates LWT tunnel.

> > Once OVS patches are upstream I can post patches for ip-route command.
>
> No, you should do it the other way around, please.  Post the ip-route
> changes along with this so we can see where this is going.
>
Currently we are using OVS for GTP tunnel. So I added support for OVS
first. You can see how it is used from OVS code. In the past when
adding support for other LWT tunnel protocols we have never followed
any ordering wrt OVS vs ip-route.
ip-route does not even support regular GTP tunnel devices. so this
should not be a blocker for this patch.

Anyways, I have a patch for iproute:
https://github.com/pshelar/iproute2/commit/d6e99f8342672e6e9ce0b71e153296f8e2b41cfc

> >>> +#include <net/dst_metadata.h>
> >>>    #include <net/net_namespace.h>
> >>>    #include <net/protocol.h>
> >>>    #include <net/ip.h>
> >>> @@ -73,6 +74,9 @@ struct gtp_dev {
> >>>        unsigned int            hash_size;
> >>>        struct hlist_head       *tid_hash;
> >>>        struct hlist_head       *addr_hash;
> >>> +     /* Used by flow based tunnel. */
> >>> +     bool                    collect_md;
> >>> +     struct socket           *collect_md_sock;
> >>
> >> I'm not convinced that you need to special-case LWT in this way.  It
> >> should be possible to just use the regular sk1u socket.  I know that the
> >> sk1u socket is created in userspace and might be set up to listen on the
> >> wrong address, but that's a user error if they try to use that device
> >> with LWT.  You could easily make the sk1u socket an optional parameter
> >> and create it (as you do in your patch) if it's not provided.  Then
> >> ip_tunnel_collect_metadata() would tell you whether to get the
> >> encapsulaton details from the tunnel itself or whether to look up a PDP
> >> context.  That should suffice, right?
> >>
> > Sounds good. I have added it as part of v3.
> > Just to be clear, I still need collect_md_sock to keep reference to
> > the socket that is created as part of the newlink in kernel space.
>
> Why?  I don't see that there's anything special enough about that socket
> that you can't just use it as sk1u.  You might need to massage the types
> a bit, but that doesn't seem like a big problem.  What am I missing?
>

If you look at the code you can see I do use sk1u for all datapath
processing, collect_md_sock reference to socket object is only kept
for destroying the socket object.
