Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12378326A66
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 00:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBZXaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 18:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhBZXaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 18:30:16 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F853C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 15:29:36 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id w21so12932733edc.7
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 15:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gp3mscLnHbLk2WQabMblkvDctVQNsKWhn5ptCzaF+1Y=;
        b=elWo1DZMnGks8yYN6bgTFChY/1/mOR4rD9vtrhZIjRgrhrBci4GGjZpG8RWEzRgLS2
         v9trDhxuRS10SeHGQ8jfxN1pPMU805JKI7gTdNDFN0ZMqyNKqrxn80bjDcgJ3u5gKgag
         D5BUQfouFcL6K2MliMzQqep58d0b0lFIEVOx9kWwXZ/Tv/sF5TOdbT0JKI2lMUtRlScu
         d1eyAMEhEBrzQKs/bs70qk1kqpN4GNeQXIiukCfR3b2sa5+OkRjPtaUI4t6yXE7+u8wH
         tV99qjqGI/Y79ryCtCBzDhZtiq50Fh/tQ9HBTa/bU4p+1232hnSB7Wmhw9szrb36xZ/f
         qGag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gp3mscLnHbLk2WQabMblkvDctVQNsKWhn5ptCzaF+1Y=;
        b=ooM7kkHPbR5GBq5gTQCJIiwRZhgYsvzYYvXL8zmL7ckWfI1QyrqlCuJBAXY0I1bAkP
         RT4RhS4M7Hmv7dVv2+wmZw6r0vfmsBmcpRbl6j40hgpwGU9vBvob5Kq2vn/OprkljrTb
         q+qFJjHPY2rVKv8dXv8WKdfQoM6/mkFIr4RWWkgLYbH4HfnNUhH5tSRp3rSRWVGH0Myt
         hfwHbd+8r8iYwXQ703tED9lwWYQGmhpONU5BSf+QQBZZznfZXyZVschXe/NrWrp7OxE6
         RXc6wnYRYuTjJUSlD0D9CIEoq+EkhJiFn8U4ab9KurRJIHLdQllRiM3zv/r4JYpkAHBW
         drrQ==
X-Gm-Message-State: AOAM531YLrjjLZot8P09Ir7tPAPgfqeYoTgkPICLlCz47RhALD5Yw8NS
        s8f9tssnPEpdOBVH0PW+5QuUUgELk2k=
X-Google-Smtp-Source: ABdhPJwprhfzngU1GNpRlYiM7pAujYkKpew4RtpcWmGvVWR77g/WyerWoXAo1t6YcIq6nB/ywC63GQ==
X-Received: by 2002:a50:8b66:: with SMTP id l93mr5846036edl.384.1614382174886;
        Fri, 26 Feb 2021 15:29:34 -0800 (PST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id by8sm6536157edb.95.2021.02.26.15.29.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 15:29:34 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id g11so4856443wmh.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 15:29:34 -0800 (PST)
X-Received: by 2002:a7b:c5d6:: with SMTP id n22mr4776065wmk.70.1614382174154;
 Fri, 26 Feb 2021 15:29:34 -0800 (PST)
MIME-Version: 1.0
References: <20210225234631.2547776-1-Jason@zx2c4.com> <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
 <CAHmME9o2yPQ+Ai12XcCjF3jMVcMT_aooFCeKkfgFFOnqPmK_yg@mail.gmail.com>
In-Reply-To: <CAHmME9o2yPQ+Ai12XcCjF3jMVcMT_aooFCeKkfgFFOnqPmK_yg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Feb 2021 18:28:56 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdCnCKFrpe-G55rPCq_D7uv4EaQ4z8XW2MOtTRKcWVJYQ@mail.gmail.com>
Message-ID: <CA+FuTSdCnCKFrpe-G55rPCq_D7uv4EaQ4z8XW2MOtTRKcWVJYQ@mail.gmail.com>
Subject: Re: [PATCH] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 5:39 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Fri, Feb 26, 2021 at 10:25 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Thu, Feb 25, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > There were a few remaining tunnel drivers that didn't receive the prior
> > > conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
> > > memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
> > > icmp{,v6}_ndo_send before sending") for details), there's even more
> > > imperative to have these all converted. So this commit goes through the
> > > remaining cases that I could find and does a boring translation to the
> > > ndo variety.
> > >
> > > Cc: Willem de Bruijn <willemb@google.com>
> > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> >
> > Using a stack variable over skb->cb[] is definitely the right fix for
> > all of these. Thanks Jason.
> >
> > Only part that I don't fully know is the conntrack conversion. That is
> > a behavioral change. What is the context behind that? I assume it's
> > fine. In that if needed, that is the case for all devices, nothing
> > specific about the couple that call icmp(v6)_ndo_send already.
>
> That's actually a sensible change anyway. icmp_send does something
> bogus if the packet has already passed through netfilter, which is why
> the ndo variant was adopted. So it's good and correct for these to
> change in that way.
>
> Jason

Something bogus, how? Does this apply to all uses of conntrack?
Specifically NAT? Not trying to be obtuse, but I really find it hard
to evaluate that part.

Please cc: the maintainers for patches that are meant to be merged, btw.
