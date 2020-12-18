Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546C42DE9B6
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbgLRTXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730082AbgLRTXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:23:04 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588EBC0617A7;
        Fri, 18 Dec 2020 11:22:24 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id r17so3122010ilo.11;
        Fri, 18 Dec 2020 11:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lBAy0stBOkcu8fodY1L3CFnmTdsk4sYtix1WdMWHeV4=;
        b=aHWHqDQw4RGtaqUqQ6SlKBNyrb87KiMiSHaFFiNd7nGlU+mNn0lKL905I7ocyWxVnN
         RJLWD8mkuNmB/GkY6ATqApZN3ui82weHujtw0REw2chpSP3agmIR5/XYSl7GPFAUC7ZB
         C4lJeoV/TAz76F7tQ3XLTPZms8G2F++/dhL0EzQK0zBQPsxnamwzCgk5YXjzfxWeNMNN
         +MnTzf3nLFCfBnOkRWiMKJs8jopydRmH25EiqIX1JfnxhPf1blWdvp1II7yhNFcJg80e
         zxs1wlGyxfvqezriV3wbgt3Kdp+Iwv+PSG22EzOt73Mg+GrnkOMQuddjySMsKq/8uqFA
         to3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lBAy0stBOkcu8fodY1L3CFnmTdsk4sYtix1WdMWHeV4=;
        b=ndSGypxVwTfl1xVsfXeaX8lcxKdD6ci8k6iNw+TY8vRgLnCG6ii9diXA8uAvEYL4eH
         zwM1nO6s6P24cf3/fXe+mgfUDOZmDpXUyK9eez/q20D+Nn+rhwX2AzVTz37ym+o8ejea
         wTZBigNBcW9RnGEXe7nWik9dzu5Yr3q+Hhc7d/C5+Hh0CBl0oVHQXdvWUxOeQ6X2xADR
         G5urPMAcgMPb2TNrJBwETMJO7nuBKgaxkCDTnx7gcUjqFdYzDKQf9Y6id2iAJbhrtkej
         NK0vfbBqqSSltMHNhC0hcs42aBGxjLIj5XeWhqy2znBFSUhaO8fBtbr/thh0IgGqt9/1
         Vx5g==
X-Gm-Message-State: AOAM532rMwC4ut0PaV+OPXCRkLtpOK88Nm9B1v1dzjDcOnzIKDYa9Bfe
        wxUDhE8hryyq2D71iTEk97xlABKFsNLX+WwU9do=
X-Google-Smtp-Source: ABdhPJyLToaHF3ZBbBd7rQ3s0zfjtGFOHbRZI8Ss5kVckmrxjlAfIJKP1D6eEqBBignzB8wWVwWTV+IdNqLr+5krNu8=
X-Received: by 2002:a92:c682:: with SMTP id o2mr5517065ilg.97.1608319343638;
 Fri, 18 Dec 2020 11:22:23 -0800 (PST)
MIME-Version: 1.0
References: <ecad34f5c813591713bb59d9c5854148c3d7f291.camel@kernel.org>
 <CAKgT0UfTOqS9PBeQFexyxm7ytQzdj0j8VMG71qv4+Vn6koJ5xQ@mail.gmail.com>
 <20201216001946.GF552508@nvidia.com> <CAKgT0UeLBzqh=7gTLtqpOaw7HTSjG+AjXB7EkYBtwA6EJBccbg@mail.gmail.com>
 <20201216030351.GH552508@nvidia.com> <CAKgT0UcwP67ihaTWLY1XsVKEgysa3HnjDn_q=Sgvqnt=Uc7YQg@mail.gmail.com>
 <20201216133309.GI552508@nvidia.com> <CAKgT0UcRfB8a61rSWW-NPdbGh3VcX_=LCZ5J+-YjqYNtm+RhVg@mail.gmail.com>
 <20201216175112.GJ552508@nvidia.com> <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com> <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com> <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
 <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0UdtEJ0Xe5icMOSj0dg-unEgTR8AwDrtdAWTKEH4D-0www@mail.gmail.com> <BY5PR12MB43223E49FF50757D8FD80738DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
In-Reply-To: <BY5PR12MB43223E49FF50757D8FD80738DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 18 Dec 2020 11:22:12 -0800
Message-ID: <CAKgT0Uetb7_P541Sd5t5Rne=np_+8AzJrv6GWqsFW_2A-kYEFw@mail.gmail.com>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
To:     Parav Pandit <parav@nvidia.com>
Cc:     David Ahern <dsahern@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 10:01 AM Parav Pandit <parav@nvidia.com> wrote:
>
>
> > From: Alexander Duyck <alexander.duyck@gmail.com>
> > Sent: Friday, December 18, 2020 9:31 PM
> >
> > On Thu, Dec 17, 2020 at 9:20 PM Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > > > From: Alexander Duyck <alexander.duyck@gmail.com>
> > > > Sent: Friday, December 18, 2020 8:41 AM
> > > >
> > > > On Thu, Dec 17, 2020 at 5:30 PM David Ahern <dsahern@gmail.com>
> > wrote:
> > > > >
> > > > > On 12/16/20 3:53 PM, Alexander Duyck wrote:
> > > > The problem is PCIe DMA wasn't designed to function as a network
> > > > switch fabric and when we start talking about a 400Gb NIC trying to
> > > > handle over 256 subfunctions it will quickly reduce the
> > > > receive/transmit throughput to gigabit or less speeds when encountering
> > hardware multicast/broadcast replication.
> > > > With 256 subfunctions a simple 60B ARP could consume more than 19KB
> > > > of PCIe bandwidth due to the packet having to be duplicated so many
> > > > times. In my mind it should be simpler to simply clone a single skb
> > > > 256 times, forward that to the switchdev ports, and have them
> > > > perform a bypass (if available) to deliver it to the subfunctions.
> > > > That's why I was thinking it might be a good time to look at addressing it.
> > > Linux tc framework is rich to address this and already used by openvswich
> > for years now.
> > > Today arp broadcasts are not offloaded. They go through software path
> > and replicated in the L2 domain.
> > > It is a solved problem for many years now.
> >
> > When you say they are replicated in the L2 domain I assume you are talking
> > about the software switch connected to the switchdev ports.
> Yes.
>
> > My question is
> > what are you doing with them after you have replicated them? I'm assuming
> > they are being sent to the other switchdev ports which will require a DMA to
> > transmit them, and another to receive them on the VF/SF, or are you saying
> > something else is going on here?
> >
> Yes, that is correct.
>
> > My argument is that this cuts into both the transmit and receive DMA
> > bandwidth of the NIC, and could easily be avoided in the case where SF
> > exists in the same kernel as the switchdev port by identifying the multicast
> > bit being set and simply bypassing the device.
> It probably can be avoided but its probably not worth for occasional ARP packets on neighbor cache miss.
> If I am not mistaken, even some recent HW can forward such ARP packets to multiple switchdev ports with commit 7ee3f6d2486e without following the above described DMA path.

Even with that it sounds like it will have to DMA the packet to
multiple Rx destinations even if it is only performing the Tx DMA
once. The Intel NICs did all this replication in hardware as well so
that is what I was thinking of when I was talking about the
replication behavior seen with SR-IOV.

Basically what I am getting at is that this could be used as an
architectural feature for switchdev to avoid creating increased DMA
overhead for broadcast, multicast and unknown-unicast traffic. I'm not
saying this is anything mandatory, and I would be perfectly okay with
something like this being optional and defaulted to off. In my mind
the setup only has the interfaces handling traffic to single point
destinations so that at most you are only looking at a 2x bump in PCIe
bandwidth for those cases where the packet ends up needing to go out
the physical port. It would essentially be a software offload to avoid
saturating the PCIe bus.

This setup would only work if both interfaces are present in the same
kernel though so that is why I chose now to bring it up as
historically SR-IOV hasn't normally been associated with containers
due to the limited number of interfaces that could be created.

Also as far as the patch count complaints I have seen in a few threads
I would be fine with splitting things up so that the devlink and aux
device creation get handled in one set, and then we work out the
details of mlx5 attaching to the devices and spawning of the SF
netdevs in another since that seems to be where the debate is.
