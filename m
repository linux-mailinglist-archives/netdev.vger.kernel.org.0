Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05F1D89F5
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 23:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728179AbgERVSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 17:18:14 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:33762 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgERVSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 17:18:14 -0400
Received: by mail-pj1-f66.google.com with SMTP id z15so384161pjb.0;
        Mon, 18 May 2020 14:18:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=l7e4wKCO02j4byrVDyWhWctfhv6l8FZHk8XSWR2z0vo=;
        b=plDKgRHdhpJsjGO96kdVpRhRsZbAKwq6HGHt+vC3gnFYc8cMu1SPqJUq+W9Nk0KZax
         XkDnQ4974LyMrf5moA+JAtHJZKR8oRc5kxx2KmAmZcnJ4N36wszwUVyqZ9mVij1yaKMj
         slYroe6+f/4DhtZvpIXfFCsIZjflus06/uXGEY2fSVzhM1xYQOlyB7qcvorQhe8FekB4
         /3S8+Z7peksiFQMV+CGXfypWt/CabMxT9N6llsePLkI4GJ4JF8e16juUNJAAnw4+Tct7
         qBdCx36X7j8cJ2Ys7MeJfZWc/spsZnBqkMfZIEXN6Nyr7sAEG8WqFkG2OpG4nLr7fKdY
         z4FQ==
X-Gm-Message-State: AOAM53342i2Haulktxw4//Yf8b3yFapQYhWE4a6SuWmpDLM3qrpPZeBm
        62LYcs9cLiA7IMx1lvQV3N8=
X-Google-Smtp-Source: ABdhPJzkdRsgH22dj2g8Hm1MTTSw8RzHY7IB5l/iNmXwB4OiLU+K1Uzi5CZ4z9dHoULajnN+bWOrAg==
X-Received: by 2002:a17:902:5a8c:: with SMTP id r12mr15373937pli.51.1589836691939;
        Mon, 18 May 2020 14:18:11 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id o15sm371753pjq.28.2020.05.18.14.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 14:18:10 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 4F1A4404B0; Mon, 18 May 2020 21:18:09 +0000 (UTC)
Date:   Mon, 18 May 2020 21:18:09 +0000
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
Message-ID: <20200518211809.GQ11244@42.do-not-panic.com>
References: <20200518165154.GH11244@42.do-not-panic.com>
 <4ad0668d-2de9-11d7-c3a1-ad2aedd0c02d@candelatech.com>
 <20200518170934.GJ11244@42.do-not-panic.com>
 <abf22ef3-93cb-61a4-0af2-43feac6d7930@candelatech.com>
 <20200518171801.GL11244@42.do-not-panic.com>
 <CALLGbR+ht2V3m5f-aUbdwEMOvbsX8ebmzdWgX4jyWTbpHrXZ0Q@mail.gmail.com>
 <20200518190930.GO11244@42.do-not-panic.com>
 <e3d978c8fa6a4075f12e843548d41e2c8ab537d1.camel@sipsolutions.net>
 <20200518195950.GP11244@42.do-not-panic.com>
 <bb0b9a2da99c16a28c1dbee93d08abfa2aecdc8b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb0b9a2da99c16a28c1dbee93d08abfa2aecdc8b.camel@sipsolutions.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 10:07:49PM +0200, Johannes Berg wrote:
> On Mon, 2020-05-18 at 19:59 +0000, Luis Chamberlain wrote:
> 
> > > Err, no. Those two are most definitely related. Have you looked at (most
> > > or some or whatever) staging drivers recently? Those contain all kinds
> > > of garbage that might do whatever with your kernel.
> > 
> > No, I stay away :)
> 
> :)
> 
> > > That's all fine, I just don't think it's appropriate to pretend that
> > > your kernel is now 'tainted' (think about the meaning of that word) when
> > > the firmware of some random device crashed.
> > 
> > If the firmware crash *does* require driver remove / addition again,
> > or a reboot, would you think that this is a situation that merits a taint?
> 
> Not really. In my experience, that's more likely a hardware issue (card
> not properly seated, for example) that a bus reset happens to "fix".
> 
> > > It's pretty clear, but even then, first of all I doubt this is the case
> > > for many of the places that you've sprinkled the annotation on,
> > 
> > We can remove it, for this driver I can vouch for its location as it did
> > reach a state where I required a reboot. And its not the first time this
> > has happened. This got me thinking about the bigger picture of the lack
> > of proper way to address these cases in the kernel, and how the user is
> > left dumbfounded.
> 
> Fair, so the driver is still broken wrt. recovery here. I still don't
> think that's a situation where e.g. the system should say "hey you have
> a taint here, if your graphics go bad now you should not report that
> bug" (which is effectively what the single taint bit does).

But again, let's think about the generic type of issue, and the
unexpected type of state that can be reached. The circumstance here
*does* lead to a case which is not recoverable. Now, consider how
many cases in the kernel where similar situations can happen and leave
the device or driver in a non-functional state.

> > > and secondly it actually hides useful information.
> > 
> > What is it hiding?
> 
> Most importantly, which device crashed. Secondarily I'd say how many
> times (*).

The device is implied by the module, the taint is applied to both.
If you had multiple devices, however, yes, it would not be possible
to distinguish from the taint which exact device it happened on.

So the only thing *generic* which would be left out is count.

> The information "firmware crashed" is really only useful in relation to
> the device.

If you have to reboot to get a functional network again then the device
is quite useless for many people, regardless of which device that
happened on.

But from a support perspective a sysfs interface which provides a tiny
bit more generic information indeed provides more value than a taint.

  Luis
