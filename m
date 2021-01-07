Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1ECB2EC9D9
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 06:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbhAGFIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 00:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725970AbhAGFIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 00:08:31 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9741C0612F0
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 21:07:50 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id q1so5592515ilt.6
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 21:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yZJjW69EaraumHukb3idOmjK2XSWpy7LIZcq7hPMseA=;
        b=FwLZ1c7M1U3iji1liTY4NmWHu0RuTrCv12rdvUM/qnq5BCNDb2Mtya4GcfND/hCEo/
         swhj/jjZ7FVnoFpL7D7vcvBElKHbMPDRSq8T2NP1KsSXL7FtBscOrI+tmJKO2KwcT07i
         T1drYfod1BCHp0b3Xl/w2wiBLQDlg4dYeLmNKGpH0ztniTdpSjUHUUmqjqecdtYFzPcb
         z0Q4okpzI7j0TerBnbbPW6wihKdWfECJNVocvuaqE1r+UyvziJKdsJUj/N1l1U+HdbiG
         p4I4b6erBwzFRVjCEbUU7i3qdFBK7PG6Q+pzCxpaHeka51iedr2XN9JdrQBAoO6RDQBR
         IYWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yZJjW69EaraumHukb3idOmjK2XSWpy7LIZcq7hPMseA=;
        b=IG3a3nvOHR5J66TPGMm9zwb5xg8qIlkfapa9DJTMXvpmV3Ab/ACqe1s3Tpg5+X0bIz
         36Eiyw/NFQMIm3EVqLNA36GJ+o7QeU2ztp/9yABrih7zqCk4GOtU1ybGzDZ9275NtNMO
         hcF+/osyTzlnnSUXExnrvqsvgDbq4rxs+VoeAi2sWV+LxUu9Y1OmzJshyC7agXlNI8MM
         nHZNtOtuuZ7inu/es9dXplLRNKNGN8m7LbMiujUIEIFIHG9gCBsM9iHWMUk1sfsGZAlm
         8bdVSuVVZpHcg1oFPhVQyGTvrbC88p2BPo0x1NP6fi3Vp/jmbDF3hKAPq+A4E7ginvm7
         gMpQ==
X-Gm-Message-State: AOAM530wtnI47Jdl3ZFgsLK+gYSVSgD5dyTcHA4DbmhXmN6phCe8/R+3
        2Ci+E6uq+0MVhVE66av2Av2uAzki35RqKAoKpd0=
X-Google-Smtp-Source: ABdhPJwpchOzxaq7yDiBHVauYT7gSL6oBy9r42VARfrL3DI1adnO5NfVWUzVWPm5vTgXaPc8kHFlUZTP6ol0RNPMi44=
X-Received: by 2002:a05:6e02:8e5:: with SMTP id n5mr7568288ilt.151.1609996070225;
 Wed, 06 Jan 2021 21:07:50 -0800 (PST)
MIME-Version: 1.0
References: <CABdVr8RVXj3dg-by_W99=fPSjdfB7fYXFRBW9sropQpYKD1xOQ@mail.gmail.com>
 <CAF=yD-+0m5Md8bjyv458Tszr_Ti-o=zDnS0TJs4cspjS2n8RLg@mail.gmail.com>
In-Reply-To: <CAF=yD-+0m5Md8bjyv458Tszr_Ti-o=zDnS0TJs4cspjS2n8RLg@mail.gmail.com>
From:   Baptiste Lepers <baptiste.lepers@gmail.com>
Date:   Thu, 7 Jan 2021 16:07:39 +1100
Message-ID: <CABdVr8Q4BrCPSD0JfCSAVdzup5wUTWxqV2F5Esd5RQ_MVn53DA@mail.gmail.com>
Subject: Re: Possible read of uninitialized array values in reuseport_select_sock?
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks. I will submit a patch.

Baptiste.

On Thu, Jan 7, 2021 at 3:57 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Jan 6, 2021 at 10:54 PM Baptiste Lepers
> <baptiste.lepers@gmail.com> wrote:
> >
> > Hello,
> >
> > While reading the code of net/core/sock_reuseport.c, I think I found a
> > possible race in reuseport_select_sock. The current code has the
> > following pattern:
> >
> >    socks = READ_ONCE(reuse->num_socks);
> >    smp_rmb(); // paired with reuseport_add_sock to make sure
> > reuse->socks[i < num_socks] are initialized
> >    while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
> >         if (i >= reuse->num_socks) // should be "socks" and not
> > "reuse->num_socks"?
> >
> > The barrier seems to be here to make sure that all items of
> > reuse->socks are initialized before being read, but the barrier only
> > protects indexes < socks, not indexes < reuse->num_socks.
> >
> > I have a patch ready to fix this issue, but I wanted to confirm that
> > the current code is indeed incorrect (if the code is correct for a
> > non-obvious reason, I'd be happy to add some comments to document the
> > behavior).
> >
> >
> > Here is the diff of the patch I was planning to submit:
> >
> > diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
> > index bbdd3c7b6cb5..b065f0a103ed 100644
> > --- a/net/core/sock_reuseport.c
> > +++ b/net/core/sock_reuseport.c
> > @@ -293,7 +293,7 @@ struct sock *reuseport_select_sock(struct sock *sk,
> >              i = j = reciprocal_scale(hash, socks);
> >              while (reuse->socks[i]->sk_state == TCP_ESTABLISHED) {
> >                  i++;
> > -                if (i >= reuse->num_socks)
> > +                if (i >= socks)
> >                      i = 0;
> >                  if (i == j)
> >                      goto out;
> >
> >
> > Thanks,
> > Baptiste.
>
> Thanks for the clear description. Yes, I believe you're correct.
