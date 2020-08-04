Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6350823C163
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 23:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgHDVYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 17:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgHDVYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 17:24:25 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F82C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 14:24:24 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id q4so27725703edv.13
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 14:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y+mBsvQmrZh2Tzpk2xjLumGFQMLB9QMRh1P157OJ2lI=;
        b=Q7chk6FxOuq+YAGComUiER6e8jtNJLsk1lXQNmrWYFhccQp8mjNylqzAidgiNQEcZR
         HP0g5bimQzMSh2pMWCYw+ojjaHxy1g6iBsYQwfbuevF8E6fOtBuOzWJZYxvPx+Z4Qxvr
         BQ3c2ONt6EtP4t4lZOrRKhW5UdjlfQ/Ja/hGqWJuIfzIZgomu1E+0ls/5IBTp6yaCGBe
         iTJjk/X+NjyfnORU78RtFW4IwaYjcR1aBhZ++a188AVfnynKelgBrrB2D0URm+lcAZiu
         EZTqzT9Dt82/xsLfmCBZt1MaW7FFYuM7HFwU3SY9dSRTrmW+RTpQrVTxJNwvX/3TVorc
         tOyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y+mBsvQmrZh2Tzpk2xjLumGFQMLB9QMRh1P157OJ2lI=;
        b=cgYyEQXYmkRg90Kc5L6LPSxSZF+Bcck6wesnSaLTydtXxCQP0tEMMAUEM8TJ1wFpL+
         MqGpPI5MzuVVkG207wMt5DIBrNHm2t+/eozpqcTEqX1bGpL5Zp5FCsV8co3RqNtUgZjD
         m56EWx8yayYq6f2E/HOieQgbB7QzI6+KJFqQZKComZa7AL5B7338ODAo6OYnjrNzEMPG
         yLy7msf+v2n+Uvbrs8k3VFxf5F6+KL1NDNfJKWBBd0dIfM6FfyMCv+fn/XI9hY6G8xRt
         b140enTa9qhidSQTOaCcdXiiarfnAB5xVjMVD1cxLEbLYeUu+/0DgzTq/UHQ4F30CNZ8
         yeBw==
X-Gm-Message-State: AOAM531hRnDu7lw6ULctUYNwhh+/ZeXXDECkjWafzgh/IV9/MuA41ooo
        u7RqPNdYHnlexZ64/TAxGoA=
X-Google-Smtp-Source: ABdhPJyi6jp5J8N7Y2zEdigYvcrCQ9J9OtEH1Jenb97MwsSZXhYyEEcDHgmZcezZLAfpqXboma8IaA==
X-Received: by 2002:a50:a187:: with SMTP id 7mr22733167edk.71.1596576263586;
        Tue, 04 Aug 2020 14:24:23 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id t6sm94847ejc.40.2020.08.04.14.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 14:24:23 -0700 (PDT)
Date:   Wed, 5 Aug 2020 00:24:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "Gaube, Marvin (THSE-TL1)" <Marvin.Gaube@tesat.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: PROBLEM: (DSA/Microchip): 802.1Q-Header lost on KSZ9477-DSA
 ingress without bridge
Message-ID: <20200804212421.e2lztrrg4evuk6zd@skbuf>
References: <c531bf92-dd7e-0e69-8307-4c4f37cb2d02@gmail.com>
 <f8465c4b8db649e0bb5463482f9be96e@BK99MAIL02.bk.local>
 <b5ad26fe-e6c3-e771-fb10-77eecae219f6@gmail.com>
 <020a80686edc48d5810e1dbf884ae497@BK99MAIL02.bk.local>
 <20200804142708.zjos3b6jvqjj7uas@skbuf>
 <CANn89iKD1H9idd-TpHQ-KS7vYHnz+6VhymrgD2cuGAUHgp2Zpg@mail.gmail.com>
 <20200804192933.pe32dhfkrlspdhot@skbuf>
 <CANn89iKw+OGo9U9iXf61ELYRo-XzC41uz-tr34KtHcW26C-z8g@mail.gmail.com>
 <20200804194333.iszq54mhrtcy3hs6@skbuf>
 <CANn89iKxjxdiMdmFvz6hH-XaH4wNQiweo27cqh=W-gC7UT_OLA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKxjxdiMdmFvz6hH-XaH4wNQiweo27cqh=W-gC7UT_OLA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 01:36:56PM -0700, Eric Dumazet wrote:
> On Tue, Aug 4, 2020 at 12:43 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Tue, Aug 04, 2020 at 12:40:24PM -0700, Eric Dumazet wrote:
> > > On Tue, Aug 4, 2020 at 12:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > > >
> > > > On Tue, Aug 04, 2020 at 07:54:18AM -0700, Eric Dumazet wrote:
> > > > >
> > > > > My 2013 commit was a bug fix, and hinted that in the future (eg in
> > > > > net-next tree) the stop-the-bleed could be refined.
> > > > >
> > > > > +               /* Note: we might in the future use prio bits
> > > > > +                * and set skb->priority like in vlan_do_receive()
> > > > > +                * For the time being, just ignore Priority Code Point
> > > > > +                */
> > > > > +               skb->vlan_tci = 0;
> > > > >
> > > > > If you believe this can be done, this is great.
> > > >
> > > > Do you have a reproducer for that bug? I am willing to spend some time
> > > > understand what is going on. This has nothing to do with priority. You
> > > > vaguely described a problem with 802.1p (VLAN 0) and used that as an
> > > > excuse to clear the entire vlan hwaccel tag regardless of VLAN ID. I'm
> > > > curious because we also now have commit 36b2f61a42c2 ("net: handle
> > > > 802.1P vlan 0 packets properly") in that general area, and I simply want
> > > > to know if your patch still serves a valid purpose or not.
> > > >
> > >
> > > I do not have a repro, the patch seemed to help at that time,
> > > according to the reporter.
> >
> > Do you mind if I respectfully revert then? It's clear that the patch has
> > loopholes already (it clears the vlan if it's hwaccel, but leaves it
> > alone if it isn't) and that the proper solution should be different
> > anyway.
> 
> Clearly the situation before the patch was not good, it seems well
> explained in the changelog.
> 
> If you want to revert, you will need to convince the bug has been
> solved in another way.
> 
> So it seems you might have to repro the initial problem.

What bug? What repro? You just said you don't have any.

Maybe I'm dumb, but the changelog is vague to me. It isn't clear what
kind of routing it is, what type of traffic was the router being
subjected to, from what direction was the VLAN traffic coming, was it
just VLAN 0 that was problematic, what drivers those were, what kernel
was used, what has any of that have to do with the referenced commit
48cc32d38a52 ("vlan: don't deliver frames for unknown vlans to
protocols") which is about macvlan returning RX_HANDLER_PASS instead of
RX_HANDLER_ANOTHER, were there other sub-interfaces as well?
And there are also obvious mistakes in the commit description: "if the
vlan id is set and we could find a vlan device for this particular id."
-> "couldn't" should be instead of "could".

This is ridiculous. Not only will I not waste my time as long as there
is nothing actionable (I could test stuff until the cows come home and I
would never know if I'm under your scenario or not), but I do feel that
it's fundamentally your job to prove that there's a bug for which this
is the right fix, rather than me to disprove it.

I'm sorry, I want to give a helping hand, but it doesn't look like I
can.
