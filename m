Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A371B225A
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 16:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbfIMOhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 10:37:23 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43785 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729546AbfIMOhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 10:37:22 -0400
Received: by mail-oi1-f193.google.com with SMTP id t84so2785052oih.10
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 07:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BaVVdn2KdYlgZJgXO9zeyQEn195Q6XfGNuPvq0e68fE=;
        b=iLuuDSh3L0DsD86MbeacgC5d86MeF41h1eAIbwsQkX/kl5bKLjCgGWWBuRDZ5EYyNY
         oDmL31Akx/hFZFvYmroHRMz7psYtbr5RH9cCwJxrO6Ch6BQAxfjtgVTcTXTsI9RnfMfa
         Uqwhnlr9kx2g2vsuWDAzdQz3H5c6VlG4TGW0nEJqBQ0OYmy3y4yalhK1UXWzpPJwQOZR
         thmel9rEW++IVWwN76iUf3KvDqhhWY89Gg0RomB2piF2Pdg/Zn8mpXOQpnio1nUgchGx
         3am6jn3CAIYvaT5l6IhM3furz2+4U0hcQ3UaBFNUdWXrvoHRaaflq6+nfZ9pJRDuuara
         Wdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BaVVdn2KdYlgZJgXO9zeyQEn195Q6XfGNuPvq0e68fE=;
        b=rgWzH33W3D0BIZw+qPqB3FmRkmf2gPcyGyisw8OXrRoA5+/AirAq3fYlLzaCDvWq3K
         GrvUS90GQveGYgcjnyZo73eTALeIModxzAHgA5R4LMdDqmoydo3qpo9T9zQbkr2Qf1ht
         rN86IQNfC4kYFcXkPoKd8KBqlM7ZNpyalwmFyj1d/5Eq4NPfT0htqyW3GPiAKE0VEtot
         +PK0aT2gcEKlTivwj2SCv8PZoxmXyMm20RVpCDxdP2uRpXUxVMCjeN6NBZ0AjfhdbbaA
         i+FvRUMZD4OZeued+SGlpJwKaq3sZgcypnE6WtTYjJs5Txcb7B5boOLhYEUPxgDYyXvr
         xsQQ==
X-Gm-Message-State: APjAAAVZE1oT8XjlRYKseM9ikrwDtDYfUwigMfRWKwbnuvf9HEnSurc7
        1sfoPQbJ94FkKSwSXi6XXCJWAZ2aWlSHWXDI93Enhg==
X-Google-Smtp-Source: APXvYqzFga4yJttNUVlyEBorgVE0QkyowddboUWkmlzjjBAR0jer1XoQrndrt5V0Uib3kLTISRGg5qQzeuy4XSAjitc=
X-Received: by 2002:a54:478d:: with SMTP id o13mr2184714oic.95.1568385440802;
 Fri, 13 Sep 2019 07:37:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190911223148.89808-1-tph@fb.com> <20190911223148.89808-2-tph@fb.com>
 <CADVnQynNiTEAmA-++JL7kMeht+dzfh2b==R_UJnEdnX3W=3k8g@mail.gmail.com>
 <CAA93jw7q71mpenRMD0dWiVNap1WKD6O4+GCBagcPa5OhHTMErw@mail.gmail.com> <20190913142936.GA84687@tph-mbp>
In-Reply-To: <20190913142936.GA84687@tph-mbp>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 13 Sep 2019 10:37:04 -0400
Message-ID: <CADVnQy=fv=OBpqKLyL+ks0aw0KWpAJNaODyE7qYserqxVAqULg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] tcp: Add rcv_wnd to TCP_INFO
To:     Thomas Higdon <tph@fb.com>
Cc:     Dave Taht <dave.taht@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dave Jones <dsj@fb.com>, Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 10:29 AM Thomas Higdon <tph@fb.com> wrote:
>
> On Thu, Sep 12, 2019 at 10:14:33AM +0100, Dave Taht wrote:
> > On Thu, Sep 12, 2019 at 1:59 AM Neal Cardwell <ncardwell@google.com> wrote:
> > >
> > > On Wed, Sep 11, 2019 at 6:32 PM Thomas Higdon <tph@fb.com> wrote:
> > > >
> > > > Neal Cardwell mentioned that rcv_wnd would be useful for helping
> > > > diagnose whether a flow is receive-window-limited at a given instant.
> > > >
> > > > This serves the purpose of adding an additional __u32 to avoid the
> > > > would-be hole caused by the addition of the tcpi_rcvi_ooopack field.
> > > >
> > > > Signed-off-by: Thomas Higdon <tph@fb.com>
> > > > ---
> > >
> > > Thanks, Thomas.
> > >
> > > I know that when I mentioned this before I mentioned the idea of both
> > > tp->snd_wnd (send-side receive window) and tp->rcv_wnd (receive-side
> > > receive window) in tcp_info, and did not express a preference between
> > > the two. Now that we are faced with a decision between the two,
> > > personally I think it would be a little more useful to start with
> > > tp->snd_wnd. :-)
> > >
> > > Two main reasons:
> > >
> > > (1) Usually when we're diagnosing TCP performance problems, we do so
> > > from the sender, since the sender makes most of the
> > > performance-critical decisions (cwnd, pacing, TSO size, TSQ, etc).
> > > From the sender-side the thing that would be most useful is to see
> > > tp->snd_wnd, the receive window that the receiver has advertised to
> > > the sender.
> >
> > I am under the impression, that particularly in the mobile space, that
> > network behavior
> > is often governed by rcv_wnd. At least, there's been so many papers on
> > this that I'd
> > tended to assume so.
> >
> > Given a desire to do both vars, is there a *third* u32 we could add to
> > fill in the next hole? :)
> > ecn marks?
>
> Neal makes some good points -- there is a fair amount of existing
> information for deriving receive window. It seems like snd_wnd would be
> more valuable at this moment. For the purpose of pairing up these __u32s
> to get something we can commit, I propose that we go with
> the rcv_ooopack/snd_wnd pair for now, and when something comes up later,
> one might consider pairing up rcv_wnd.

FWIW that sounds like a great plan to me. Thanks, Thomas!

neal
