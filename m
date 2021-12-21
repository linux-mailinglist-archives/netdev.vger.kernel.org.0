Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2925847C4CF
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 18:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240270AbhLURQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 12:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240266AbhLURQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 12:16:17 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68DA1C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 09:16:17 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id p65so18681560iof.3
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 09:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7iAi+1KQSj2WDLXsuhbvVM2dw9p459FUJwwdd3KzsPk=;
        b=h5mhknlxTZ70I69Lb9vxaxq7ZOOofgf84vxvpIU0xycrodZIuFN/+GWfkGWEpq3NnR
         F657gj6v5nqOmBf0H7PIi7ZxjQzBz2KB/2z4XHy+xbsZFHK01gYgNCgg77tN6l8Uqpwe
         jg8MYPIg0vA/jjCYoazzzy12DnHY2AZZtcBF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7iAi+1KQSj2WDLXsuhbvVM2dw9p459FUJwwdd3KzsPk=;
        b=y1bjtnnSfRm8yDcoHayoQhsjGfpA0qy0VtYs5EyRLkVP19ABjhRI8wmVxBh94/zWpL
         Faiz6bg9aWlvfDUQYFhgW/mo1gYd17vD+xOXnhBu8rKkfrn6j/nXFxAcLC9JAJRbqiDN
         bE32PsqNfsLIK76eiRF9cqohYlGhfpDB/2nTlfgvCmCHk7BjmbyDXfRStGTvhDcqGbwR
         rjpvCbxiqraxrH2Tt8u/qEtsOanw6bUDMvKquS8MQgre1M6gIAJA7SSjA7IRS1ubAWZZ
         KrInDmO/wDRMBS8CPFtqZWZia7efyuzxncT0kCDGxCe90vInfmHbv1Et7CN/6LZCBncC
         6EWw==
X-Gm-Message-State: AOAM531/xJIv5VljORenj2ay7Uz7xTFzG4XDgm2DtgNv9ixquLkBu6NO
        SYFr4tsUPGec6C7blY1uMHTCv3vcuFQtleFbq792IPO5ssQ=
X-Google-Smtp-Source: ABdhPJyLIOuom7svtnn/+gdqOVsMjreCh59ssWSTQkJgEAZCWeTzAWWTnbE5MUKiD0FNto6CaopDUCPEMEWCD3bdwdk=
X-Received: by 2002:a05:6638:d89:: with SMTP id l9mr2680694jaj.80.1640106975402;
 Tue, 21 Dec 2021 09:16:15 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nGtZbuQWdwh26qJA6HbbLsCNZjU4jaY78acbKfAAan+5w@mail.gmail.com>
 <CANn89i+CF0G+Yx_aJMURxBbr0mqDzS5ytQY7RtYh_pY0cOh01A@mail.gmail.com> <cf25887f1321e9b346aa3bf487bd55802f7bca80.camel@redhat.com>
In-Reply-To: <cf25887f1321e9b346aa3bf487bd55802f7bca80.camel@redhat.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Tue, 21 Dec 2021 17:16:04 +0000
Message-ID: <CALrw=nG5-Qyi8f0j6-dmkVts4viX24j755gEiUNTQDoXzXv1XQ@mail.gmail.com>
Subject: Re: tcp: kernel BUG at net/core/skbuff.c:3574!
To:     Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 3:40 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Tue, 2021-12-21 at 06:16 -0800, Eric Dumazet wrote:
> > On Tue, Dec 21, 2021 at 4:19 AM Ignat Korchagin <ignat@cloudflare.com> wrote:
> > >
> > > Hi netdev,
> > >
> > > While trying to reproduce a different rare bug we're seeing in
> > > production I've triggered below on 5.15.9 kernel and confirmed on the
> > > latest netdev master tree:
> > >
> >
> > Nothing comes to mind. skb_shift() has not been recently changed.
> >
> > Why are you disabling TSO exactly ?
> >
> > Is GRO being used on veth needed to trigger the bug ?
> > (GRO was added recently to veth, I confess I did not review the patches)

Yes, it seems enabling GRO for veth actually enables NAPI codepaths,
which trigger this bug (and actually another one we're investigating).
Through trial-and-error it seems disabling TSO is more likely to
trigger it at least in my dev environment. I'm not sure if this bug is
somehow related to the other one we're investigating, but once we have
a fix here I can try to verify before posting it to the mailing list.

> This is very likely my fault. I'm investigating it right now.

Thank you very much! Let me know if I can help somehow.

Ignat

> Thanks for the head-up.
>
> Paolo
>
