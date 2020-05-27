Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0711E3661
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387421AbgE0DTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:19:25 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:39186 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728475AbgE0DTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:19:21 -0400
Received: by mail-pj1-f65.google.com with SMTP id n15so763597pjt.4
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 20:19:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=s1BKNsNjOLcUtv/AvsFQU2yBPI63llFtuSI9Z++rcXY=;
        b=Q+7CccvlLUCkydI2SOu7r1p/DzwXAmPNuydH4TxHu/tRZnKpQurU7Gvh+KqkJpw9Kw
         fz6QtWeXsA4kJzftFj4LoR5cjaawGkrHofNjo/6MPyG+wSedHLzYNieNJKzQM49KHGhg
         2FVKqpBRX+NsxlQaw5lg0sB1jTrD5J5+4141ZvLTH3GGRZ4W/A1BS7sQ4y4ykfcxXBlT
         RqBHaAa+uQJe+rtona5Mcm2vjFmtQYAHZrAeNvlP9/KanjPWYgFDAUj1/Uo3fxCuoZ7v
         TxEfuzKDclb+DoL93mPnSoAAttd/EwgfNNeETle1H044LnWsCDyzDzuDLIxkh26LJhM7
         mAAg==
X-Gm-Message-State: AOAM531K44XamvFxzksE2KHlxhoTd+e/syqB1YzW62X7+RjIRmx4RixL
        W2UW7mnm2C8eA6ydBiwRrfc1aHx+4ATfTA==
X-Google-Smtp-Source: ABdhPJw63Hd8qOsma/1dfvS26fyru11UYBgLrdZ/oDQxGddQNoc0qOdrhp0GOfHqw6LAL08L2D+rwQ==
X-Received: by 2002:a17:90b:1882:: with SMTP id mn2mr2493415pjb.139.1590549560065;
        Tue, 26 May 2020 20:19:20 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id t21sm818519pgu.39.2020.05.26.20.19.18
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 20:19:19 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 20B41419C3; Wed, 27 May 2020 03:19:18 +0000 (UTC)
Date:   Wed, 27 May 2020 03:19:18 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jeyu@kernel.org, davem@davemloft.net, michael.chan@broadcom.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        kvalo@codeaurora.org, johannes@sipsolutions.net,
        akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        derosier@gmail.com, keescook@chromium.org, daniel.vetter@ffwll.ch,
        will@kernel.org, mchehab+samsung@kernel.org, vkoul@kernel.org,
        mchehab+huawei@kernel.org, robh@kernel.org, mhiramat@kernel.org,
        sfr@canb.auug.org.au, linux@dominikbrodowski.net,
        glider@google.com, paulmck@kernel.org, elver@google.com,
        bauerman@linux.ibm.com, yamada.masahiro@socionext.com,
        samitolvanen@google.com, yzaikin@google.com, dvyukov@google.com,
        rdunlap@infradead.org, corbet@lwn.net, dianders@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 0/8] kernel: taint when the driver firmware crashes
Message-ID: <20200527031918.GU11244@42.do-not-panic.com>
References: <20200526145815.6415-1-mcgrof@kernel.org>
 <20200526154606.6a2be01f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20200526230748.GS11244@42.do-not-panic.com>
 <20200526163031.5c43fc1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526163031.5c43fc1d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 04:30:31PM -0700, Jakub Kicinski wrote:
> On Tue, 26 May 2020 23:07:48 +0000 Luis Chamberlain wrote:
> > On Tue, May 26, 2020 at 03:46:06PM -0700, Jakub Kicinski wrote:
> > > On Tue, 26 May 2020 14:58:07 +0000 Luis Chamberlain wrote:  
> > > > To those new on CC -- this is intended to be a simple generic interface
> > > > to the kernel to annotate when the firwmare has crashed leaving the
> > > > driver or system in a questionable state, in the worst case requiring
> > > > full system reboot. This series is first addressing only a few
> > > > networking patches, however, I already have an idea of where such
> > > > firmware crashes happen across the tree. The goal with this series then
> > > > is to first introduce the simple framework, and only if that moves
> > > > forward will I continue to chug on with the rest of the drivers /
> > > > subsystems.
> > > > 
> > > > This is *not* a networking specific problem only.
> > > > 
> > > > This v3 augments the last series by introducing the uevent for panic
> > > > events, one of them is during tainting. The uvent mechanism is
> > > > independent from any of this firmware taint mechanism. I've also
> > > > addressed Jessica Yu's feedback. Given I've extended the patches a bit
> > > > with other minor cleanup which checkpatch.pl complains over, and since
> > > > this infrastructure is still being discussed, I've trimmed the patch
> > > > series size to only cover drivers for which I've received an Acked-by
> > > > from the respective driver maintainer, or where we have bug reports to
> > > > support such dire situations on the driver such as ath10k.
> > > > 
> > > > During the last v2 it was discussed that we should instead use devlink
> > > > for this work, however the initial RFC patches produced by Jakub
> > > > Kicinski [0] shows how devlink is networking specific, and the intent
> > > > behind this series is to produce simple helpers which can be used by *any*
> > > > device driver, for any subsystem, not just networking. Subsystem
> > > > specific infrastructure to help address firwmare crashes may still make
> > > > sense, however that does not mean we *don't* need something even more
> > > > generic regardless of the subsystem the issue happens on. Since uevents
> > > > for taints are exposed, we now expose these through uapi as well, and
> > > > that was something which eventually had to happen given that the current
> > > > scheme of relying on sensible character representations for each taint
> > > > will not scale beyond the alphabet.  
> > > 
> > > Nacked-by: Jakub Kicinski <kuba@kernel.org>  
> > 
> > Care to elaborate?
> 
> I elaborated in the previous thread

No you didn't.

> and told you I will nack this, 

That's all you said.

> but sure let's go over this again.
> 
> For the third time saying the devlink is networking specific is not
> true. It was created as a netlink configuration channel for devices
> when there is no networking reference that could be used. It can be
> compiled in or out much like sysfs.

Perhaps I didn't get your email but this clarification was in no way
shape or form present in your reply on that thread.

> And as I've shown you devlink already has the uAPI for what you're
> trying to achieve.

I read your patch, and granted, I will accept I was under the incorrect
assumption that this can only be used by networking devices, however it
the devlink approach achieves getting userspace the ability with
iproute2 devlink util to query a device health, on to which we can peg
firmware health. But *this* patch series is not about health status and
letting users query it, its about a *critical* situation which has come up
with firmware requiring me to reboot my system, and the lack of *any*
infrastructure in the kernel today to inform userspace about it.

So say we use netlink to report a critical health situation, how are we
informing userspace with your patch series about requring a reboot?

  Luis
