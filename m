Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0704A2FA8A1
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407538AbhARSWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436843AbhARSV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 13:21:56 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E2DC061574;
        Mon, 18 Jan 2021 10:21:15 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id x21so16371276iog.10;
        Mon, 18 Jan 2021 10:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Irdub0NzYRYZ97o/wX/g+f9roxLKhwr4Y5Mvi1eMFyk=;
        b=Jyef1kdLU/P08Zp+KZ5SjmOiESfT8wy3HE4qG1IOAHczzkgGmm4AkRWjBSCg3rCXFV
         Uwrcw/qNkuHzuD0I8R3jNwzICen8/Ey2rVmAaySXVZljwF6EpZ6zgXY8aM7uSlCL+IFa
         m5ZlgWZBmTgbuGgUvKswmRKVsSE0qb4co4PwXCvKouio9nhIsoDdPu/Wq/Ms70WptC7B
         uacfn07mQkRwTeSA836Hv3r4chdJjwhRyd/ZqfJ+phdZh/ydXhOz1sgQjSKFOTlKDsUn
         LWwhH4kC9Ph77rlu3rKUuhXupB1UXlRxWO/qtaviGFRbvvfk+XSiczBf0dI11xIAZ4Rr
         WltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Irdub0NzYRYZ97o/wX/g+f9roxLKhwr4Y5Mvi1eMFyk=;
        b=fsB/JeJXfSPRwzGJggQedNVIfmtBIMouq7LNZbcLRKKlIJI6jAnE7E1c2EA4BkYumU
         MMlVpbbNIlyokE4o9yBEKqls3SCauqpTZ5jdS06ZQLaL0aTlUbvEBvhrnTeS64Ml86jE
         UC4hEqiPmTvHV34Sn3fdhXIXwETYui/d6zhO/qkUdeTSl5VU63rHjhnGnIzivfsbWt9R
         9UVdfDDpJ4JBJ7+U+7w6VINoIbcM3Bn4cWMUR5CqHKTT41K/R7SpuYgDlOW3yv15o5Yo
         VM1/dUWRQpBlr9M3+DfnNKZwesPYPlqIMeAkI0gPyVzOt9cpIzAMAtkke1znMVm9vs4y
         oFbQ==
X-Gm-Message-State: AOAM530fENA/1KSNYewLu5jLOIqW1CeqpVxwhMEysWZPp+fk6OR7cCb0
        /GOOsaa1rbMaIigxd44p8hHBlhVWQtXP1esOCKs=
X-Google-Smtp-Source: ABdhPJwQ+OIZ65wo86uFlyfh9T7nx8PWb6XpeYNjx75pCM7/387XM6clHfLRN9wqhCju4GbYSlapZXaNJS3cxZDYg14=
X-Received: by 2002:a92:cf04:: with SMTP id c4mr402883ilo.237.1610994075154;
 Mon, 18 Jan 2021 10:21:15 -0800 (PST)
MIME-Version: 1.0
References: <20210114200825.GR4147@nvidia.com> <CAKgT0UcaRgY4XnM0jgWRvwBLj+ufiabFzKPyrf3jkLrF1Z8zEg@mail.gmail.com>
 <20210114162812.268d684a@omen.home.shazbot.org> <CAKgT0Ufe1w4PpZb3NXuSxug+OMcjm1RP3ZqVrJmQqBDt3ByOZQ@mail.gmail.com>
 <20210115140619.GA4147@nvidia.com> <20210115155315.GJ944463@unreal>
 <CAKgT0UdzCqbLwxSnDTtgha+PwTMW5iVb-3VXbwdMNiaAYXyWzQ@mail.gmail.com>
 <20210116082031.GK944463@unreal> <CAKgT0UeKiz=gh+djt83GRBGi8qQWTBzs-qxKj_78N+gx-KtkMQ@mail.gmail.com>
 <20210118072008.GA4843@unreal> <20210118132800.GA4835@unreal>
In-Reply-To: <20210118132800.GA4835@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 18 Jan 2021 10:21:03 -0800
Message-ID: <CAKgT0UeYb5xz8iehE1Y0s-cyFbsy46bjF83BkA7qWZMkAOLR-g@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v1 2/5] PCI: Add SR-IOV sysfs entry to read
 number of MSI-X vectors
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 18, 2021 at 5:28 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Mon, Jan 18, 2021 at 09:20:08AM +0200, Leon Romanovsky wrote:
> > On Sun, Jan 17, 2021 at 07:16:30PM -0800, Alexander Duyck wrote:
> > > On Sat, Jan 16, 2021 at 12:20 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > >
> > > > On Fri, Jan 15, 2021 at 05:48:59PM -0800, Alexander Duyck wrote:
> > > > > On Fri, Jan 15, 2021 at 7:53 AM Leon Romanovsky <leon@kernel.org> wrote:
> > > > > >
> > > > > > On Fri, Jan 15, 2021 at 10:06:19AM -0400, Jason Gunthorpe wrote:
> > > > > > > On Thu, Jan 14, 2021 at 05:56:20PM -0800, Alexander Duyck wrote:
>
> <...>
>
> > > If you want yet another compromise I would be much happier with the PF
> > > registering the sysfs interfaces on the VFs rather than the VFs
> > > registering the interface and hoping the PF supports it. At least with
> > > that you are guaranteed the PF will respond to the interface when it
> > > is registered.
> >
> > Thanks a lot, I appreciate it, will take a look now.
>
> I found only two solutions to implement it in this way.
> Option 1.
> Allow multi entry write to some new sysfs knob that will receive BDF (or another VF
> identification) and vector count. Something like this:
>
>  echo "0000:01:00.2 123" > sriov_vf_msix_count
>
> From one side, that solution is unlikely to be welcomed by Greg KH and from another,
> it will require a lot of boilerplate code to make it safe and correct.

You are overthinking this. I didn't say the sysfs had to be in the PF
directory itself. My request was that the PF is what placed the sysfs
file in the directory since indirectly it is responsible for spawning
the VF anyway it shouldn't be too much of a lift to have the PF place
sysfs files in the VF hierarchy.

The main piece I am not a fan of is the fact that the VF is blindly
registering an interface and presenting it without knowing if it even
works.

The secondary issue that I see as important, but I am willing to
compromise on is that the interface makes it appear as though the VF
configuration space is writable via this sysfs file. My preference
would be to somehow make it transparent that the PF is providing this
functionality. I thought it might be easier to do with devlink rather
than with sysfs which is why I have been preferring devlink. However
based on your pushback I am willing to give up on that, but I think we
still need to restructure how the sysfs is being managed.

> Option 2.
> Create directory under PF device with files writable and organized by VF numbers.
> It is doable, but will cause to code bloat with no gain at all. Cleaner than now,
> it won't be.
>
> Why the current approach with one file per-proper VF device is not good enough?

Because it is muddying the waters in terms of what is control taking
place from the VF versus the PF. In my mind the ideal solution if you
insist on going with the VF sysfs route would be to look at spawning a
directory inside the VF sysfs specifically for all of the instances
that will be PF management controls. At least that would give some
hint that this is a backdoor control and not actually interacting with
the VF PCI device directly. Then if in the future you have to add more
to this you have a spot already laid out and the controls won't be
mistaken for standard PCI controls as they are PF management controls.

In addition you could probably even create a directory on the PF with
the new control you had added for getting the master count as well as
look at adding symlinks to the VF files so that you could manage all
of the resources in one spot. That would result in the controls being
nicely organized and easy to use.
