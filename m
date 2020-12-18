Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A42DDCFF
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 03:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732325AbgLRCks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 21:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731599AbgLRCkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 21:40:47 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD79C06138C
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 18:40:07 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id g20so1056853ejb.1
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 18:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9dgG7qudFm2M5ITbimg/EWCzHwUSe9U+CunlE6/jL+E=;
        b=K0iNceVwSaWAQkyefoafIL+r7jjBCygPntMyHwd3POvZ8g7YT3AyjHi/gqQvjRrJPp
         AQWvJ6QTr8tSOFjOEiKecyu618xXLtEzB37NYJTRWPBWh/iiWfJ5t/SN0pDlfSIXxTnW
         8XQzV9vnsOMuQsRKnQA5Jq590u5DiEXtzkdJCh1ysSLMrEsG1R56M1pUe8CrRCb+AcvC
         cnxem06FxnKPRYauImA7ZiEd5hlHlH70gZYuIdvcL9ybSDCFbUcFzjRNwwgZivcciosw
         8TUurj7TkNKk9PaAy3cONHdKYvZ8nYXBh9cejLzDWsfKSSXwUBWfA9pr0ceTS+6Hcm7W
         xQxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9dgG7qudFm2M5ITbimg/EWCzHwUSe9U+CunlE6/jL+E=;
        b=sr5O2PWWppJPuppQqvEDzQazaW+uaALy+ZpMr5PfKV62WH3IlLekntxK6NvPV168dE
         A6UXup6fHtFle4xtbaaGVrSdyRpWHmsqkeVfyHJPcrRN2+grX4DPzzJbkPlOajZmkZkF
         CoY3qpynjA+fUzsIWf107OAN2EdC6dZfEmfpYMcK7qGfQOJcwprni696N6zfRLM5sbG7
         fxlkmDbDDEyyczNlUQXZg/llwwidKY0bNAvEL7LB9AYLJR3eVm1v8vC84zRo6N8piXYl
         MpdoysgM21HcHp77EiHqWwFT2zqMV67KzPdjF0l96TDPCYIOlwNSPWYCsPPgWpU7xp9p
         1Rdg==
X-Gm-Message-State: AOAM532mnRJh5VYCa+pVfKw2QGYKWonyoltdx+tVs5UHp1E2dZ4s3PL2
        oabpVIhosCX/KKg7CVJM/ZIAazagX4WsLlEARAoaeQ==
X-Google-Smtp-Source: ABdhPJySH0QTe8IayfD/c7x3TXLpQyM5fmUjCclwC7NQ12btUfoyVuaLt0jSgr0SOVFRPZFstKr7iq1l+tk4kWBsDWE=
X-Received: by 2002:a17:906:2707:: with SMTP id z7mr1965646ejc.418.1608259205621;
 Thu, 17 Dec 2020 18:40:05 -0800 (PST)
MIME-Version: 1.0
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8ogtmrm7tOzZo+N@kroah.com> <CAPcyv4iLG7V9JT34La5PYfyM9378acbLnkShx=6pOmpPK7yg3A@mail.gmail.com>
 <X8usiKhLCU3PGL9J@kroah.com> <20201217211937.GA3177478@piout.net>
In-Reply-To: <20201217211937.GA3177478@piout.net>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 17 Dec 2020 18:39:55 -0800
Message-ID: <CAPcyv4h-jg0dxKZ89yYnHsTEDj7jLWDBhBVTgEC77tLLsz92pw@mail.gmail.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 1:20 PM Alexandre Belloni
<alexandre.belloni@bootlin.com> wrote:
>
> Hello,
>
> On 05/12/2020 16:51:36+0100, Greg KH wrote:
> > > To me, the documentation was written, and reviewed, more from the
> > > perspective of "why not open code a custom bus instead". So I can see
> > > after the fact how that is a bit too much theory and justification and
> > > not enough practical application. Before the fact though this was a
> > > bold mechanism to propose and it was not clear that everyone was
> > > grokking the "why" and the tradeoffs.
> >
> > Understood, I guess I read this from the "of course you should do this,
> > now how do I use it?" point of view.  Which still needs to be addressed
> > I feel.
> >
> > > I also think it was a bit early to identify consistent design patterns
> > > across the implementations and codify those. I expect this to evolve
> > > convenience macros just like other parts of the driver-core gained
> > > over time. Now that it is in though, another pass through the
> > > documentation to pull in more examples seems warranted.
> >
> > A real, working, example would be great to have, so that people can know
> > how to use this.  Trying to dig through the sound or IB patches to view
> > how it is being used is not a trivial thing to do, which is why
> > reviewing this took so much work.  Having a simple example test module,
> > that creates a number of devices on a bus, ideally tied into the ktest
> > framework, would be great.  I'll attach below a .c file that I used for
> > some basic local testing to verify some of this working, but it does not
> > implement a aux bus driver, which needs to be also tested.
> >
>
> There is something I don't get from the documentation and it is what is
> this introducing that couldn't already be done using platform drivers
> and platform devices?

There is room for documentation improvement here. I realize reading it
back now that much of the justification for "why not platform bus?"
happened on the list, but only a small mention made it into the
document. It turns out that platform-bus has some special integrations
and hacks with platform-firmware implementations. For example, the
ACPI companion magic and specific platform firmware integrations in
platform_match(). It's also an awkward bus name to use because these
devices do not belong to the platform. The platform bus is for devices
that do not have an enumeration mechanism besides board files or
firmware descriptions.

So while many of the auxiliary device use cases might be able to be
squeezed into a platform-bus scheme it further overloads what is
already a wide responsibility.

In comparison, the auxiliary-bus is tailored to the "sub-function of a
parent device/driver" use case. It lets the host driver be the root of
a namespace of sub-functionality in a standard template way.

> We already have a bunch of drivers in tree that have to share a state
> and register other drivers from other subsystems for the same device.
> How is the auxiliary bus different?

There's also custom subsystem buses that do this. Why not other
alternatives? They didn't capture the simultaneous mindshare of RDMA,
SOF, and NETDEV developers. Personally my plans for using
auxiliary-bus do not map cleanly to anything else in the tree. I want
to use it for attaching an NPEM driver (Native PCIE Enclosure
Management) to any PCI device driver that opts-in, but it would be
overkill to go create an "npem" bus for this.
