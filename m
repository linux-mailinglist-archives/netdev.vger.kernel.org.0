Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5549C31EDAC
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhBRRvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbhBRRcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 12:32:06 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A588C0613D6
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 09:30:23 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id n13so6856694ejx.12
        for <netdev@vger.kernel.org>; Thu, 18 Feb 2021 09:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Hqpe4XGeawtX1jpXJzzUAsNPv6nWuZPmbAMWnr53vMY=;
        b=YV/QUozL58gNYfBUI9Qu2CmWfznw/eGy7l2fNbGDLUCGyXwwuP5qJK+D3gqKzq8fg5
         HlvNovw68XutI2sO5MRTz+c5/kfZ0Rb164J/AR8OBKt7YYP9JLtnzbqzILMQw6vplR5F
         m7htZ2sVEJ+fHM08URCd/dq9Gigt7x+m8U5z1wcawicu+2+1JTLa8fpIj7jD9VaAzqlJ
         Va4h/X0gUEFToHtjpZwNpU5S7UNgBu5THAPH1HBR9bybI9aG98D338Mygsw9aD650Gre
         ImTEo7Yza7DSnesktVjIo9Q4mxiu5io9HyujycvNybSinK1KrxAIwcWGpNknuVXpHWtx
         o2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Hqpe4XGeawtX1jpXJzzUAsNPv6nWuZPmbAMWnr53vMY=;
        b=OfDWdMgZjbrnPyr1h0vNhNI9+UrciNfbYCfa5tqLpJC9z0b/EgT+ZuxszBykiLtqG/
         eHqXVxox3rq7aASW1Xh+aHCJ0AzN9iJAJkZKRkS9Dc1sr4AMZ/DcRiC84bBId2JO0uU7
         srvr7MagH7Q6JhwraEzJXKTnrBcYs0rOweKibtSE/7V0F0ARiosE+G64puk+YFuHIRKX
         G9wxuGIcIvK4fxLLXwJwPgm2lKrLdRWVgGrUOQfRzIFozRjMUF0OB/K4IlFE0Cf++l9L
         Yy8WszGU/kB2vGAgMl0F3q+dx4XcDohwlXDvu/MSf1PJrP4If40/fCOyjWvrYDkpV0XX
         4FLQ==
X-Gm-Message-State: AOAM531rg1fDqJ6bo/pFljqj7VN8Yo61rnSSsX2clPOie/B7WdTVM0qR
        7BjW1qfQbJ+qRjLKOGCwaWpt9xQKVU+FF1WGIiE5pNeI
X-Google-Smtp-Source: ABdhPJzwqbNCTOs/4TlhSXEhB1KZ91PpMYG5fw+GL7r+N/RDIyLe5Ma3wAitPABXrcWoKDRkrlWkEY4M+LoZyBEaTK4=
X-Received: by 2002:a17:906:184e:: with SMTP id w14mr5159761eje.56.1613669422293;
 Thu, 18 Feb 2021 09:30:22 -0800 (PST)
MIME-Version: 1.0
References: <20210218123053.2239986-1-Jason@zx2c4.com> <CA+FuTSdyovtMVaQfdtpWquawpNDoUKz+qXa+8U8eBTzWVtPXHQ@mail.gmail.com>
 <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
In-Reply-To: <CAHmME9o-N5wamS0YbQCHUfFwo3tPD8D3UH=AZpU61oohEtvOKg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 18 Feb 2021 12:29:45 -0500
Message-ID: <CAF=yD-Kw=gmPA1qRY0zEVdUQue35L+Y99JySxyG2--LubvptWQ@mail.gmail.com>
Subject: Re: [PATCH net] net: icmp: zero-out cb in icmp{,v6}_ndo_send before sending
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        SinYu <liuxyon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 10:40 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Willem,
>
> On Thu, Feb 18, 2021 at 3:57 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Feb 18, 2021 at 7:31 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > The icmp{,v6}_send functions make all sorts of use of skb->cb, assuming
> >
> > Indeed that also casts skb->cb, to read IP6CB(skb)->iif, good catch.
> >
> > Still, might be good to more precisely detail the relevant bug:
> > icmp_send casts the cb to an option struct.
> >
> >         __icmp_send(skb_in, type, code, info, &IPCB(skb_in)->opt);
> >
> > which is referenced to parse headers by __ip_options_echo, copying
> > data into stack allocated icmp_param and so overwriting the stack
> > frame.
>
> The other way to fix this bug would be to just make icmp_ndo_send call
> __icmp_send with an zeored stack-allocated ip_options, rather than
> calling icmp_send which calls __icmp_send with the IPCB one. The
> implementation of this is very easy, and that's what I did at first,
> until I noticed that the v6 side would require a little bit more
> plumbing to do right. But, I can go ahead and do that, if you think
> that's the better strategy.

Thanks for that. It does seem to add more code change that we'd like
for stable backports.

> > This is from looking at all the callers of icmp{,v6}_ndo_send.
> >
> > If you look at the callers of icmp{,v6}_send there are even a couple
> > more. Such as ipoib_cm_skb_reap (which memsets), clip_neigh_error
> > (which doesn't), various tunnel devices (which live under net/ipv4,
> > but are called as .ndo_start_xmit downstream from, e.g., segmentation
> > (SKB_GSO_CB). Which are fixed (all?) in commit 5146d1f15112
> > ("tunnel: Clear IPCB(skb)->opt before dst_link_failure called").
> >
> > Might be even better to do the memset in __icmp_send/icmp6_send,
> > rather than in the wrapper. What do you think?
>
> I don't think memsetting from icmp_send itself is a good idea, since
> most callers of that are actually from the inet layer, where it makes
> sense to look at IPCB. Other callers, from the ndo layer, should be
> using the icmp_ndo_send helper instead. Or am I confused?
>
> If there are places that are using icmp_send from ndo_start_xmit,
> that's a problem that should be fixed, with those uses swapped for
> icmp_ndo_send.

I missed this response earlier (two inboxes). Agreed. Sorry that I
didn't reply before your v2.
