Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE72CF212
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 17:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgLDQl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 11:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgLDQl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 11:41:56 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4791C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 08:41:15 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id d18so6472794edt.7
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 08:41:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0DSnVIqhCjfQRKv2sQg9Q6JdfEOfBg7tXO7oAxFOt6Q=;
        b=0yetlJbYMnmdPmLRUZn7RS3bh0tzdzDGM+9PDleeD2iqRFXkNd6mRf3f03rSWgmQd5
         qOdHp/kup+NAYxh/CJU9LLba4DAwBUgERhl0M4qXHOiXVt1fco+LP77vh1cyZ6qq4c/8
         foxoZxB5HbKBzb5iEeajTCsLfYovy0DkhPTg2Vx19iICqqPRG/USmccONRumHiexn6TT
         emAV80gchfWJPgkMYOcf5EbJkWMDGA1M8o5UgQZIurDf8zmRVSOw/6i4VpmZ4L3VjJY1
         Lb0/f/PdqHE31Hd1g7ro/aT6mcyIWyq6RwBrvqipCdwmt+1rH+sEiJAwqvHPxCuIWtFs
         z3iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0DSnVIqhCjfQRKv2sQg9Q6JdfEOfBg7tXO7oAxFOt6Q=;
        b=kB2pg/vK7CAT0H7mSK8J+MT/dXMacGWHVUF8zixN50Pr4pdsQTTKpJtvbbFNCx/xKb
         FmblPUNeWEr340s4L1KmAOYWpdMcMGKQK0wB0C4l22hzAze/iNnqGujy/ybYlT+fHL7v
         z/RIRI8Os/r06y1exbzTFVLIeXn8foD3wgYSQZENEeHwJxG9HerT439VLbi9J/XH32UX
         9SNLDTSVM+jZQZLZ2qJI7wAuEGO1Ya1LatufBHUOS6YEKx2pywgmoeOU3ojo2UfwCbFR
         yzC2wNd43jrBzsLCOQTcOQ7/v16W9Ro/k+v130CCupPRJae1YwFB3zeawTIcWL7YIpEX
         Im6A==
X-Gm-Message-State: AOAM533CIypMWtbd70O9fjwXK6iMfwhJukkA8urAZPJ/Zdk7t+A+e/aF
        22GFQXwcxG4SMvfDv3b3EZRsq3KRfF26PZvMCnk0Qw==
X-Google-Smtp-Source: ABdhPJwaZ4haRtuDzBD84WdDW7otHcrepP4bW/OgCJDuVGkx8fNTTRTGsYJMeW0OBOxCy0odLqO+2rTLHMU2+xmnxS8=
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr2165444edw.52.1607100074435;
 Fri, 04 Dec 2020 08:41:14 -0800 (PST)
MIME-Version: 1.0
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com>
In-Reply-To: <X8ogtmrm7tOzZo+N@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Fri, 4 Dec 2020 08:41:09 -0800
Message-ID: <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, alsa-devel@alsa-project.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 3:41 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Dec 02, 2020 at 04:54:24PM -0800, Dan Williams wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > Add support for the Auxiliary Bus, auxiliary_device and auxiliary_driver.
> > It enables drivers to create an auxiliary_device and bind an
> > auxiliary_driver to it.
> >
> > The bus supports probe/remove shutdown and suspend/resume callbacks.
> > Each auxiliary_device has a unique string based id; driver binds to
> > an auxiliary_device based on this id through the bus.
> >
> > Co-developed-by: Kiran Patil <kiran.patil@intel.com>
> > Co-developed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Co-developed-by: Fred Oh <fred.oh@linux.intel.com>
> > Co-developed-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Kiran Patil <kiran.patil@intel.com>
> > Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > Signed-off-by: Fred Oh <fred.oh@linux.intel.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
> > Reviewed-by: Shiraz Saleem <shiraz.saleem@intel.com>
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > Reviewed-by: Martin Habets <mhabets@solarflare.com>
> > Link: https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> > This patch is "To:" the maintainers that have a pending backlog of
> > driver updates dependent on this facility, and "Cc:" Greg. Greg, I
> > understand you have asked for more time to fully review this and apply
> > it to driver-core.git, likely for v5.12, but please consider Acking it
> > for v5.11 instead. It looks good to me and several other stakeholders.
> > Namely, stakeholders that have pressure building up behind this facility
> > in particular Mellanox RDMA, but also SOF, Intel Ethernet, and later on
> > Compute Express Link.
> >
> > I will take the blame for the 2 months of silence that made this awkward
> > to take through driver-core.git, but at the same time I do not want to
> > see that communication mistake inconvenience other parties that
> > reasonably thought this was shaping up to land in v5.11.
> >
> > I am willing to host this version at:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/djbw/linux tags/auxiliary-bus-for-5.11
> >
> > ...for all the independent drivers to have a common commit baseline. It
> > is not there yet pending Greg's Ack.
> >
> > For example implementations incorporating this patch, see Dave Ertman's
> > SOF series:
> >
> > https://lore.kernel.org/r/20201113161859.1775473-2-david.m.ertman@intel.com
> >
> > ...and Leon's mlx5 series:
> >
> > http://lore.kernel.org/r/20201026111849.1035786-1-leon@kernel.org
> >
> > PS: Greg I know I promised some review on newcomer patches to help with
> > your queue, unfortunately Intel-internal review is keeping my plate
> > full. Again, I do not want other stakeholder to be waiting on me to
> > resolve that backlog.
>
> Ok, I spent some hours today playing around with this.  I wrote up a
> small test-patch for this (how did anyone test this thing???) and while
> it feels awkward in places, and it feels like there is still way too
> much "boilerplate" code that a user has to write and manage, I don't
> have the time myself to fix it up right now.
>
> So I'll go apply this to my tree, and provide a tag for everyone else to
> be able to pull from for their different development trees so they can
> work on.
>
> I do have 3 follow-on patches that I will send to the list in response
> to this message that I will be applying on top of this patch.  They do
> some minor code formatting changes, as well as change the return type of
> the remove function to make it more future-proof.  That last change will
> require users of this code to change their implementations, but it will
> be obvious what to do as you will get a build warning.
>
> Note, I'm still not comfortable with a few things here.  The
> documentation feels odd, and didn't really help me out in writing any
> test code, which doesn't seem right.  Also the use of strings and '.' as
> part of the api feels awkward, and messy, and of course, totally
> undocumented.
>
> But, as the use of '.' is undocumented, that means we can change it in
> the future!  Because no driver or device name should ever be a user api
> reliant thing, if we come up with a better way to do all of this in the
> future, that shouldn't be a problem to change existing users over to
> this.  So this is a warning to everyone, you CAN NOT depend on the sysfs
> name of a device or bus name for any tool.  If so, your userspace tool
> is broken.
>
> Thanks for everyone in sticking with this, I know it's been a long slog,
> hopefully this will help some driver authors move forward with their
> crazy complex devices :)

To me, the documentation was written, and reviewed, more from the
perspective of "why not open code a custom bus instead". So I can see
after the fact how that is a bit too much theory and justification and
not enough practical application. Before the fact though this was a
bold mechanism to propose and it was not clear that everyone was
grokking the "why" and the tradeoffs.

I also think it was a bit early to identify consistent design patterns
across the implementations and codify those. I expect this to evolve
convenience macros just like other parts of the driver-core gained
over time. Now that it is in though, another pass through the
documentation to pull in more examples seems warranted.
