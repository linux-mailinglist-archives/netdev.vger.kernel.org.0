Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989AF1DF2EE
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387441AbgEVXYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731175AbgEVXYd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:24:33 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051B5C061A0E;
        Fri, 22 May 2020 16:24:33 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id d1so5531363qvl.6;
        Fri, 22 May 2020 16:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p3DOwgx50lHaOYH/y9NF0WRQ9Ja31vmsw+vc99//yd8=;
        b=cRe1Q0LpdKC1fFLtFRt0iy1U8UOw08DyLWTpDvNkZTCMRvCW2MbsPxkBFNnPyOigYP
         Ri3z371nh3MlGmkEJLxfQo3RNLbznUMwIq+ijREpBh9h+zFrfQZDB8yx9kyL7fpgj9Ni
         vgGs/M89F8xeUiI1OSgG39x+nHhSLFabisERtnRb6JCIUvtgM/h+1K89DF9f4G5g5C6P
         kDcwAye3TywnKLYJ46Nwbqj8/tUKWtXDoPd+ktOeGXQQbyAx7VFIt+j3rQdV8SA3VMyU
         oyBxMJpz+db2N/52oG2pNEYrvp1wfDzgguTwv5LNyfqIik+gSy00RgB5i25uuIaGN+6e
         s++w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p3DOwgx50lHaOYH/y9NF0WRQ9Ja31vmsw+vc99//yd8=;
        b=DQCicihEaQ2AVnWq/oW5oa3oCCVCvND1pOOBK0h6Jg3sxO/fF2mlRTg73vZLh93/DV
         CIr3Vsmo8rKfr0Ex8tYxR7iszAX98aTGDWAofja2fHkGgaqHPfKE1ajyVfUibDFoo9nn
         fEGyVNYxyO7n04QDMkGwIrC10h3r0mQxnyPycLrie0M3dHsjyebUNAYmHtuZmowI+gVx
         ALGGNwfM2eMK25jsM/Yu3f1uhIP0e0uz5KQxMvsIbvPIdqvkyHwed+Q93F4AU8bdyz7S
         IsdVUBFl19WrRTyRO4U/q4m0HZtpYdFkeNH5TjT0GAyg6G6w1tkKk7jSPDxoheUb3FoM
         HbDw==
X-Gm-Message-State: AOAM530SeswPMKbzwFTqAj7Ux48Oroa3zrOlTH2UoyqDnFoG099fnjaA
        wa3e6XHfrdUNqTJq0OvXh6+/9EqKt24veDIszU0=
X-Google-Smtp-Source: ABdhPJyONXtwaNSOSYLXwVMotvNgibyETSqzfSzBJG08UQWtvZoltYGqNRcszNvI7/n5dP2gIMR1JKoMcyYH7mDK7Uw=
X-Received: by 2002:ad4:4b26:: with SMTP id s6mr6198033qvw.146.1590189872044;
 Fri, 22 May 2020 16:24:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200519010530.GS11244@42.do-not-panic.com> <20200519211531.3702593-1-kuba@kernel.org>
 <20200522052046.GY11244@42.do-not-panic.com> <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net> <20200522215145.GC11244@42.do-not-panic.com>
In-Reply-To: <20200522215145.GC11244@42.do-not-panic.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Fri, 22 May 2020 16:23:55 -0700
Message-ID: <CALLGbR+QPcECtJbYmzztV_Qysc5qtwujT_qc785zvhZMCH50fg@mail.gmail.com>
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, jiri@resnulli.us,
        briannorris@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 2:51 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Fri, May 22, 2020 at 10:46:07PM +0200, Johannes Berg wrote:
> > FWIW, I still completely disagree on that taint. You (Luis) obviously
> > have been running into a bug in that driver, I doubt the firmware
> > actually managed to wedge the hardware.
>
> This hasn't happened just once, its happed many times sporadically now,
> once a week or two weeks I'd say. And the system isn't being moved
> around.
>
> > But even if it did, that's still not really a kernel taint. The kernel
> > itself isn't in any way affected by this.
>
> Of course it is, a full reboot is required.
>
> > Yes, the system is in a weird state now. But that's *not* equivalent to
> > "kernel tainted".
>
> Requiring a full reboot is a dire situation to be in, and loosing
> connectivity to the point this is not recoverable likewise.
>
> You guys are making out a taint to be the end of the world. We have a
> taint even for a kernel warning, and as others have mentioned mac80211
> already produces these.
>

I had to go RTFM re: kernel taints because it has been a very long
time since I looked at them. It had always seemed to me that most were
caused by "kernel-unfriendly" user actions.  The most famous of course
is loading proprietary modules, out-of-tree modules, forced module
loads, etc...  Honestly, I had forgotten the large variety of uses of
the taint flags. For anyone who hasn't looked at taints recently, I
recommend: https://www.kernel.org/doc/html/latest/admin-guide/tainted-kernels.html

In light of this I don't object to setting a taint on this anymore.
I'm a little uneasy, but I've softened on it now, and now I feel it
depends on implementation.

Specifically, I don't think we should set a taint flag when a driver
easily handles a routine firmware crash and is confident that things
have come up just fine again. In other words, triggering the taint in
every driver module where it spits out a log comment that it had a
firmware crash and had to recover seems too much. Sure, firmware
shouldn't crash, sure it should be open source so we can fix it,
whatever... those sort of wishful comments simply ignore reality and
our ability to affect effective change. A lot of WiFi firmware crashes
and for well-known cases the drivers handle them well. And in some
cases, not so well and that should be a place the driver should detect
and thus raise a red flag.  If a WiFi firmware crash can bring down
the kernel, there's either a major driver bug or some very funky
hardware crap going on. That sort of thing we should be able to
detect, mark with a taint (or something), and fix if within our sphere
of influence. I guess what it comes down to me is how aggressive we
are about setting the flag.

I would like there to be a single solution, or a minimized set
depending on what makes sense for the requirements. I haven't had time
to look into the alternatives mentioned here so I don't have an
informed opinion about the solution. I do think Luis is trying to
solve a real problem though. Can we look at this from the point of
view of what are the requirements?  What is it we're trying to solve?

I _think_ that the goal of Luis's original proposal is to report up to
the user, at some future point when the user is interested (because
something super drastic just occured, but long after the fw crash),
that there was a firmware crash without the user having to grep
through all logs on the machine. And then if the user sees that flag
and suspects it, then they can bother to find it in the logs or do
more drastic debugging steps like finding the fw crash in the log and
pulling firmware crash dumps, etc.

I think the various alternate solutions are great but perhaps solving
a superset of features (like adding in user-space notifications etc)?
Perhaps different people on these related threads are trying to solve
different problems?


- Steve
