Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BF51D88B0
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 22:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgERT7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 15:59:55 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40183 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgERT7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 15:59:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id t16so4674634plo.7;
        Mon, 18 May 2020 12:59:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=aj1xZpMnVA3x+kJm7X/0LI6rc+dHdrwpfJIQAOKnjiw=;
        b=CzxPhnUpSwy3kc7kLP4A0flqyPyRNSmCBmKbeQna3Z1M12d+5jJIlSQ/PGLwYg9LnE
         taqs23fIeOIS54awHXNWqtKusT9ZPwukm0/LuXvTp2I8KwRiBNDALAIFa7/CXnbnYIib
         cy6DjsI3s61cjuRqYBEJXTxve1zLLnLMQEXpTmeD8rM+4+C0p3JYbP7NFCgOF2VGRcTl
         F+ygfKxbgC8iNzKQVzTw0PPt/kQMHI0gcaiR9+aBVG2plqmATSiumblSB1mlOrZTX8UC
         2JGfVCyFZwBdFHC0Q+W9RV61AQCeVrbihEccxbLVhVH0FKy320DqKkFzqGxY/BkXC+FC
         gXig==
X-Gm-Message-State: AOAM531DaOM1zPIm0nnQKkbM98tqhTI44+0meElp9V0V6bLypZgoFUri
        yCgc/JAX93DivAaoNIAaXzE=
X-Google-Smtp-Source: ABdhPJzstjncLL1Pa6WoPiWI0iTEbP3pqQuPkP5Nmh12sc6FmfH/dXgoEDbYs7yqGBBK4bjkTNucAg==
X-Received: by 2002:a17:90a:6a0f:: with SMTP id t15mr1097314pjj.121.1589831992465;
        Mon, 18 May 2020 12:59:52 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id s13sm5573431pfh.118.2020.05.18.12.59.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 12:59:51 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 94E14404B0; Mon, 18 May 2020 19:59:50 +0000 (UTC)
Date:   Mon, 18 May 2020 19:59:50 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Steve deRosier <derosier@gmail.com>,
        Ben Greear <greearb@candelatech.com>, jeyu@kernel.org,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com,
        Takashi Iwai <tiwai@suse.de>, schlad@suse.de,
        andriy.shevchenko@linux.intel.com, keescook@chromium.org,
        daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 12/15] ath10k: use new module_firmware_crashed()
Message-ID: <20200518195950.GP11244@42.do-not-panic.com>
References: <20200515212846.1347-13-mcgrof@kernel.org>
 <2b74a35c726e451b2fab2b5d0d301e80d1f4cdc7.camel@sipsolutions.net>
 <20200518165154.GH11244@42.do-not-panic.com>
 <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
 <20200518170934.GJ11244@42.do-not-panic.com>
 <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
 <20200518171801.GL11244@42.do-not-panic.com>
 <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
 <20200518190930.GO11244@42.do-not-panic.com>
 <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 09:25:09PM +0200, Johannes Berg wrote:
> On Mon, 2020-05-18 at 19:09 +0000, Luis Chamberlain wrote:
> 
> > > Unfortunately a "taint" is interpreted by many users as: "your kernel
> > > is really F#*D up, you better do something about it right now."
> > > Assuming they're paying attention at all in the first place of course.
> > 
> > Taint historically has been used and still is today to help rule out
> > whether or not you get support, or how you get support.
> > 
> > For instance, a staging driver is not supported by some upstream
> > developers, but it will be by those who help staging and Greg. TAINT_CRAP
> > cannot be even more clear.
> > 
> > So, no, it is not just about "hey your kernel is messed up", there are
> > clear support boundaries being drawn.
> 
> Err, no. Those two are most definitely related. Have you looked at (most
> or some or whatever) staging drivers recently? Those contain all kinds
> of garbage that might do whatever with your kernel.

No, I stay away :)

> Of course that's not a completely clear boundary, maybe you can find a
> driver in staging that's perfect code just not written to kernel style?
> But I find that hard to believe, in most cases.
> 
> So no, it's really not about "[a] staging driver is not supported" vs.
> "your kernel is messed up". The very fact that you loaded one of those
> things might very well have messed up your kernel entirely.
> 
> > These days though, I think we all admit, that firmware crashes can use
> > a better generic infrastructure for ensuring that clearly affecting-user
> > experience issues. This patch is about that *when and if these happen*,
> > we annotate it in the kernel for support pursposes.
> 
> That's all fine, I just don't think it's appropriate to pretend that
> your kernel is now 'tainted' (think about the meaning of that word) when
> the firmware of some random device crashed.

If the firmware crash *does* require driver remove / addition again,
or a reboot, would you think that this is a situation that merits a taint?

> > Recovery without affecting user experience would be great, the taint is
> > *not* for those cases. The taint definition has:
> > 
> > + 18) ``Q`` used by device drivers to annotate that the device driver's firmware
> > +     has crashed and the device's operation has been severely affected. The    
> > +     device may be left in a crippled state, requiring full driver removal /   
> > +     addition, system reboot, or it is unclear how long recovery will take.
> > 
> > Let me know if this is not clear.
> 
> It's pretty clear, but even then, first of all I doubt this is the case
> for many of the places that you've sprinkled the annotation on,

We can remove it, for this driver I can vouch for its location as it did
reach a state where I required a reboot. And its not the first time this
has happened. This got me thinking about the bigger picture of the lack
of proper way to address these cases in the kernel, and how the user is
left dumbfounded.

> and secondly it actually hides useful information.

What is it hiding?

> Regardless of the support issue, I think this hiding of information is
> also problematic.
> 
> I really think we'd all be better off if you just made a sysfs file (I
> mistyped debugfs in some other email, sorry, apparently you didn't see
> the correction in time) that listed which device(s) crashed and how many
> times. 

Ah yes, count. The taint does not address count.

> That would actually be useful. Because honestly, if a random
> device crashed for some random reason, that's pretty much a non-event.
> If it keeps happening, then we might even want to know about it.

True.

> You can obviously save the contents of this file into your bug reports
> automatically and act accordingly, but I think you'll find that this is
> far more useful than saying "TAINT_FIRMWARE_CRASHED" so I'll ignore this
> report.

Absolutely.

> Yeah, that might be reasonable thing if the bug report is about
> slow wifi *and* you see that ath10k firmware crashed every 10 seconds,
> but if it just crashed once a few days earlier it's of no importance to
> the system anymore ... And certainly a reasonable driver (which I
> believe ath10k to be) would _not_ randomly start corrupting memory
> because its firmware crashed. Which really is what tainting the kernel
> is about.

I still see it as a support thing too. But discussing this further is
pointless as I agree that taint does not cover count and that it is
important.


  Luis
