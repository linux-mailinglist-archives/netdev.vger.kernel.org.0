Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85D4326B1E
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 03:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbhB0CL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 21:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhB0CLZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 21:11:25 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6885C06174A
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 18:10:44 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id b13so4019206edx.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 18:10:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UCiQ7GpLiB8agEE/m1fcSs6peYfVdKtaK3fIWdjh6lw=;
        b=adyhu4he45j26SfKOXAERcXQwHT4kPCbEskLyXOZqVEPBmfXnwmxFBJYKjtuF2zwLW
         PW4Bu4aeeoSN4ncW9nmKk90oua1W20NmHz7lpMyA6QIe47oHeSK2w+fSLS3JQfnxdSv5
         w/LkQY+NIukIih6h7s65o4sbDR++R1revEgvkcBMd8g4wBYNMithdVzb9kb7gQWR3SeA
         KBQzUa+K5jzp9sIGDly1Fwqp+RZ0wIPy6N5FVRpaC4wnphCUAetoVoVlTTxOuS6wZYpb
         saAqz6KUelFnqWA1F9D+xH8+5gHaYmFqNbh+QNCF7+/WDxTzAQ9wUarKXX8MxzuYhMKT
         jKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UCiQ7GpLiB8agEE/m1fcSs6peYfVdKtaK3fIWdjh6lw=;
        b=UJ5EJnzMb5vFqE5UIRDHDrXU7m3DDFtR4INoytevINLQg94PPCvvIy6FkFDDhnziT4
         0G0KLtPt4RhhaxTEzORZd+tr7ajy4Fu4YtHLLd/O4TL3iiaP5K6IahSIjmVqunZWH/h/
         ngU+6JY3Mjxw8INXPwrCcTxHdpYQvbi5GePkycM8i4l9YE1jwsxEyYjuQLinFXcaNFmQ
         0qCsfr27zsyahJF6g8ih97n1cc5oWG9SVWYNSRX+hlCNxfovQTGhTW0tziCE3c0+xBz/
         iaiEZRAWWRqKLtUJ9iGLtXG48/YmSN+pcXoOj5F4fdfARtElE7t0cvKIfLF2C2qAOdnw
         7efg==
X-Gm-Message-State: AOAM532uNOnME3BZjoxVXbKGamHlC6qVXRUmCANNbax0eYkh87D3Tyew
        4NKAlg4m6W5edvtXM5fPWIngVlLMF14=
X-Google-Smtp-Source: ABdhPJz8mNmMzi8pxMv3foS5LEQVI4qst/T5YiVNAteNoqu9SKsOqEEkuvlcR51ssRMtZSopHbZ+Uw==
X-Received: by 2002:aa7:c044:: with SMTP id k4mr6407398edo.47.1614391842683;
        Fri, 26 Feb 2021 18:10:42 -0800 (PST)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id b17sm6397000ejj.9.2021.02.26.18.10.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 18:10:42 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id n4so10367211wrx.1
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 18:10:42 -0800 (PST)
X-Received: by 2002:a5d:640b:: with SMTP id z11mr5874171wru.327.1614391842063;
 Fri, 26 Feb 2021 18:10:42 -0800 (PST)
MIME-Version: 1.0
References: <20210225234631.2547776-1-Jason@zx2c4.com> <CA+FuTScmM12PG96k8ZjGd1zCjAaGzjk3cOS+xam+_h6sx2_HDA@mail.gmail.com>
 <CAHmME9o2yPQ+Ai12XcCjF3jMVcMT_aooFCeKkfgFFOnqPmK_yg@mail.gmail.com>
 <CA+FuTSdCnCKFrpe-G55rPCq_D7uv4EaQ4z8XW2MOtTRKcWVJYQ@mail.gmail.com> <CAHmME9rV1=deEkHS=W4ApHSRyN2M=VGhqcYh76DrB3ywDEce0w@mail.gmail.com>
In-Reply-To: <CAHmME9rV1=deEkHS=W4ApHSRyN2M=VGhqcYh76DrB3ywDEce0w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 26 Feb 2021 21:10:03 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdKpkz3Fr3i4W9qONCt=-gUtXDKZ3DS=Gw6MR=kBSdXBw@mail.gmail.com>
Message-ID: <CA+FuTSdKpkz3Fr3i4W9qONCt=-gUtXDKZ3DS=Gw6MR=kBSdXBw@mail.gmail.com>
Subject: Re: [PATCH] net: always use icmp{,v6}_ndo_send from ndo_start_xmit
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 7:42 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Sat, Feb 27, 2021 at 12:29 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Fri, Feb 26, 2021 at 5:39 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > On Fri, Feb 26, 2021 at 10:25 PM Willem de Bruijn
> > > <willemdebruijn.kernel@gmail.com> wrote:
> > > >
> > > > On Thu, Feb 25, 2021 at 6:46 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > > > >
> > > > > There were a few remaining tunnel drivers that didn't receive the prior
> > > > > conversion to icmp{,v6}_ndo_send. Knowing now that this could lead to
> > > > > memory corrution (see ee576c47db60 ("net: icmp: pass zeroed opts from
> > > > > icmp{,v6}_ndo_send before sending") for details), there's even more
> > > > > imperative to have these all converted. So this commit goes through the
> > > > > remaining cases that I could find and does a boring translation to the
> > > > > ndo variety.
> > > > >
> > > > > Cc: Willem de Bruijn <willemb@google.com>
> > > > > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > >
> > > > Using a stack variable over skb->cb[] is definitely the right fix for
> > > > all of these. Thanks Jason.
> > > >
> > > > Only part that I don't fully know is the conntrack conversion. That is
> > > > a behavioral change. What is the context behind that? I assume it's
> > > > fine. In that if needed, that is the case for all devices, nothing
> > > > specific about the couple that call icmp(v6)_ndo_send already.
> > >
> > > That's actually a sensible change anyway. icmp_send does something
> > > bogus if the packet has already passed through netfilter, which is why
> > > the ndo variant was adopted. So it's good and correct for these to
> > > change in that way.
> > >
> > > Jason
> >
> > Something bogus, how? Does this apply to all uses of conntrack?
> > Specifically NAT? Not trying to be obtuse, but I really find it hard
> > to evaluate that part.
>
> By the time packets hit ndo_start_xmit, the src address has changed,
> and icmp can't deliver to the actual source, and its rate limiting
> works against the wrong source. All of this was explained, justified,
> and discussed on the original icmp_ndo_start patchset, which included
> the function and converted drivers to use it. However, a few spots
> were missed, which this patchset cleans up. Here's the merge with
> details:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=803381f9f117493d6204d82445a530c834040fe6

Thanks for the link. I used git blame to a look at the patch that
introduced the code before asking for more context, but this state was
in the merge commit, so I missed it.

> The network devices that this patch here adjusts are no different than
> the four I originally fixed up in that series -- xfrmi, gtp, sunvnet,
> wireguard.

Agreed.


> > Please cc: the maintainers for patches that are meant to be merged, btw.
>
> Whoops. I'll do so and repost.
