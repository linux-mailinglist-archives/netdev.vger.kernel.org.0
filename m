Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5542A26FC9E
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgIRMfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRMfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:35:24 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C90C06174A;
        Fri, 18 Sep 2020 05:35:24 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id s17so1383729ooe.6;
        Fri, 18 Sep 2020 05:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JFRmQfbrs/7G147elh1viIOL/oIvRXgZxuDndXl62DU=;
        b=qp3hOiFiPZw89xotj6l5KPjoBeqjukkjcAfCJ5eVPQvNAvafHg1pbHdi8dGwUFhybN
         vVFjFyXzIFHwFExxH2orTGUyxptIOxVd/QbEfEa9UcGaQqMqR5LHlG8lJa4VdRNIU3WP
         FzHvDI7Jiz7+jAXo72ZwUl1lMsOgbuarrMY9ZxI/uj46ewj8DKxmNfFSwLc8MbauMad3
         y5QYUpQi8O9T74urKxTZKff1+p/xY6AOwavN1ii8fLhGevbMOghCjyzLnLt9pF1i2oVd
         0L0LGgX1K+2XYN2JfHp8NsaPK2xaA0kuzkQIZAK3powLam8AKEUTUzK7PFWyVp6ztXnr
         e9wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JFRmQfbrs/7G147elh1viIOL/oIvRXgZxuDndXl62DU=;
        b=TziGrLEvHMzTiWPGLelX22jNaGQ3iYXNJVO7xHjPwhyM6z6NjLMoeerWu5uNx4c54n
         cH9CWSI5HDdvRC6U/QYK8TbPwHDqJMYhb3WJcRhW09gOymwaWDWGUJ2voMeD11xhHRAP
         w0dwoBio3KE2QOQKwTfYtTK9JR3D6o+jD5N0G+oK7HKVBdLphLnNCLATf1T0mz43vhaA
         OE53x0vwTGdlJ56zjimKsTSiaclFTjgtwXujI5MzJfYYbRRda0biWfRftfv7spTaaPsL
         gwCvye4S2k2SnKXhmrC7ugpcQnMbSr2h7MdH0o+kK5uGOvdrRvYI2EkAe1LsdOz/oWhl
         9j5A==
X-Gm-Message-State: AOAM531I4nnzm0m/TrOzKSiWzEVVtjUV/VjRMcq3IHZLVVHT/HxNL1Xv
        +3SMat+u4e8eAGmF7qD+6QZP1Yhm0lkq6IL2n9M=
X-Google-Smtp-Source: ABdhPJyeHfOlobmyu2tRxFIZ57Ot6v5qoei2XCRDV9ELQV7SbBvEPsWL7cd500IeGqybXonoUlJs8XSzVsGTPbywrDw=
X-Received: by 2002:a4a:d9c3:: with SMTP id l3mr23628692oou.27.1600432523808;
 Fri, 18 Sep 2020 05:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca> <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
 <20200918121621.GQ8409@ziepe.ca>
In-Reply-To: <20200918121621.GQ8409@ziepe.ca>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 15:34:54 +0300
Message-ID: <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>, izur@habana.ai
Cc:     Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 3:16 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Sep 18, 2020 at 02:59:28PM +0300, Oded Gabbay wrote:
> > On Fri, Sep 18, 2020 at 2:56 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> > > > On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > > > > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> > > > >> infrastructure for communication between multiple accelerators. Same
> > > > >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> > > > >> The RDMA implementation we did does NOT support some basic RDMA
> > > > >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> > > > >> library or to connect to the rdma infrastructure in the kernel.
> > > > >
> > > > > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > > > > you can't add random device offloads as IOCTL to nedevs.
> > > > >
> > > > > RDMA is the proper home for all the networking offloads that don't fit
> > > > > into netdev.
> > > > >
> > > > > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > > > > all. I'm sure this can too.
> > > >
> > > > Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> > > > was suggested to go through the vfio subsystem instead.
> > > >
> > > > I think this comes back to the discussion we had when EFA was upstreamed, which
> > > > is what's the bar to get accepted to the RDMA subsystem.
> > > > IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> > > > ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
> > >
> > > That is more or less where we ended up, yes.
> > >
> > > I'm most worried about this lack of PD and MR.
> > >
> > > Kernel must provide security for apps doing user DMA, PD and MR do
> > > this. If the device doesn't have PD/MR then it is hard to see how a WQ
> > > could ever be exposed directly to userspace, regardless of subsystem.
> >
> > Hi Jason,
> > What you say here is very true and we handle that with different
> > mechanisms. I will start working on a dedicated patch-set of the RDMA
> > code in the next few weeks with MUCH MORE details in the commit
> > messages. That will explain exactly how we expose stuff and protect.
> >
> > For example, regarding isolating between applications, we only support
> > a single application opening our file descriptor.
>
> Then the driver has a special PD create that requires the misc file
> descriptor to authorize RDMA access to the resources in that security
> context.
>
> > Another example is that the submission of WQ is done through our QMAN
> > mechanism and is NOT mapped to userspace (due to the restrictions you
> > mentioned above and other restrictions).
>
> Sure, other RDMA drivers also require a kernel ioctl for command
> execution.
>
> In this model the MR can be a software construct, again representing a
> security authorization:
>
> - A 'full process' MR, in which case the kernel command excution
>   handles dma map and pinning at command execution time
> - A 'normal' MR, in which case the DMA list is pre-created and the
>   command execution just re-uses this data
>
> The general requirement for RDMA is the same as DRM, you must provide
> enough code in rdma-core to show how the device works, and minimally
> test it. EFA uses ibv_ud_pingpong, and some pyverbs tests IIRC.
>
> So you'll want to arrange something where the default MR and PD
> mechanisms do something workable on this device, like auto-open the
> misc FD when building the PD, and support the 'normal' MR flow for
> command execution.
>
> Jason

I don't know how we can support MR because we can't support any
virtual address on the host. Our internal MMU doesn't support 64-bits.
We investigated in the past, very much wanted to use IBverbs but
didn't figure out how to make it work.
I'm adding Itay here and he can also shed more details on that.
Oded
