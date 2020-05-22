Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3EB1DF323
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgEVXoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:44:13 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:51023 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbgEVXoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 19:44:13 -0400
Received: by mail-pj1-f66.google.com with SMTP id nu7so5668374pjb.0;
        Fri, 22 May 2020 16:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qwBCXfH3p/Q+vVVyulpo5RbTtF9OgkKNjUK7JBnoUUc=;
        b=AGoJhfmY+9SgSx+hS1hGSaeFZf8w463YgLqZhFn3jjms7Sept3salil+b5YMgNP5Iq
         Q0yx3CJIhi20OZOOmQ9KpOzVn9/o/piEGM9sDklBjIeNmsHr+infF31S1gdJNCkVju4x
         4VlfmaJtI4FZ5zvDW+9AsInRXfogaGJuJTGOM3b+qmlzXLdFFfjgCQFE5U7RuipCFHoz
         B0NkpecRKr+3bAp93PY9iZikUdP0Z0xkFFkfMhkrgEzQI5IyGS8aG6GTJBuHNsS6HXuS
         0Ql3joAmb3zw1WVnrpKLgX77hZQd/QAdqqISHzZinHjXMoD/CUgOHFpWmhER5wdBgvat
         EWwA==
X-Gm-Message-State: AOAM533FWNfxS8GpW+0E3b689nMw3sggM+DBoTnj62kSCgA0Af/fp67X
        HcUQ8awFDABiKU4AMitWmgI=
X-Google-Smtp-Source: ABdhPJxH0UgigagwiX+j+Sh0IiHJq/UtU9464U2bbx9EQXaHcu8Jt446U8JYth1jEeGTt/TQ3L8OXg==
X-Received: by 2002:a17:90b:1082:: with SMTP id gj2mr7642106pjb.225.1590191052196;
        Fri, 22 May 2020 16:44:12 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 10sm7565945pfx.138.2020.05.22.16.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 16:44:10 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id B4B5740321; Fri, 22 May 2020 23:44:09 +0000 (UTC)
Date:   Fri, 22 May 2020 23:44:09 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Steve deRosier <derosier@gmail.com>
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
Subject: Re: [RFC 1/2] devlink: add simple fw crash helpers
Message-ID: <20200522234409.GH11244@42.do-not-panic.com>
References: <20200519010530.GS11244@42.do-not-panic.com>
 <20200519211531.3702593-1-kuba@kernel.org>
 <20200522052046.GY11244@42.do-not-panic.com>
 <20200522101738.1495f4cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2e5199edb433c217c7974ef7408ff8c7253145b6.camel@sipsolutions.net>
 <20200522215145.GC11244@42.do-not-panic.com>
 <CALLGbR+QPcECtJbYmzztV_Qysc5qtwujT_qc785zvhZMCH50fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLGbR+QPcECtJbYmzztV_Qysc5qtwujT_qc785zvhZMCH50fg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 22, 2020 at 04:23:55PM -0700, Steve deRosier wrote:
> Specifically, I don't think we should set a taint flag when a driver
> easily handles a routine firmware crash and is confident that things
> have come up just fine again. In other words, triggering the taint in
> every driver module where it spits out a log comment that it had a
> firmware crash and had to recover seems too much. Sure, firmware
> shouldn't crash, sure it should be open source so we can fix it,
> whatever... those sort of wishful comments simply ignore reality and
> our ability to affect effective change. A lot of WiFi firmware crashes
> and for well-known cases the drivers handle them well. And in some
> cases, not so well and that should be a place the driver should detect
> and thus raise a red flag.  If a WiFi firmware crash can bring down
> the kernel, there's either a major driver bug or some very funky
> hardware crap going on. That sort of thing we should be able to
> detect, mark with a taint (or something), and fix if within our sphere
> of influence. I guess what it comes down to me is how aggressive we
> are about setting the flag.

Exactly the crux of the issue.

I hope that by now we should all be in agreement that at least a
firmware crash requiring a reboot is something we should record and
inform the user of. A taint seems like a reasonable standard practice
for these sorts of things.

> I would like there to be a single solution, or a minimized set
> depending on what makes sense for the requirements. I haven't had time
> to look into the alternatives mentioned here so I don't have an
> informed opinion about the solution. I do think Luis is trying to
> solve a real problem though. Can we look at this from the point of
> view of what are the requirements?  What is it we're trying to solve?
> 
> I _think_ that the goal of Luis's original proposal is to report up to
> the user, at some future point when the user is interested (because
> something super drastic just occured, but long after the fw crash),
> that there was a firmware crash without the user having to grep
> through all logs on the machine. And then if the user sees that flag
> and suspects it, then they can bother to find it in the logs or do
> more drastic debugging steps like finding the fw crash in the log and
> pulling firmware crash dumps, etc.

Yes, that's exactly it. Not all users are clueful to inspect logs. I now
have a generic uevent mechanism drafted which sends a uevent for *any*
taint. So that is, it does not even depend on this series. But it
accomplishes the goal of informing the user of taints.

> I think the various alternate solutions are great but perhaps solving
> a superset of features (like adding in user-space notifications etc)?
> Perhaps different people on these related threads are trying to solve
> different problems?

The uevent mechanism I implemented (but not yet posted for review) at
least sends out a smoke signal. I think that if each subsystem wants
to expand on this with dumping facilities that is great too!

  Luis
