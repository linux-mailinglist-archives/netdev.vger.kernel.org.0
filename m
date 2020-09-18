Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42EAF26FC87
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgIRMcX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIRMcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:32:23 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780E2C06174A;
        Fri, 18 Sep 2020 05:32:22 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id m12so5236156otr.0;
        Fri, 18 Sep 2020 05:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ow3B4nNSeHkTX9cFIh+YoDf8dKRS0Nl5CVhGWxfy+4g=;
        b=GIZfEveKfJsMiR5RALHiHcSQ7iLEqo+WldrzExn8n2bG5mqJ9R3/7IKlTXIIfbV95o
         vdNl3CA3XNz2X8uICf9dqxEPTI0DiBhwvgHZ1WGUwk/0LPR/gaQTwUlEXKdS2GcNDDoX
         1SmzZNTYJYXAA/D+OnlxB0YJKNKMtNrUY+dRdVUq3rYvdkyotKUKSM4n8YyAejeVP9Ha
         qDbp3sbwlWGzNVfw5qA0d0wQ0MMJHhHh6tkU2xk5FPCvQhBm/iyL46f9G1LXy0NIqoNG
         rOD5+J1JEuHHSb6PSOe+rlOZXtkBxJ4dL3dOtWUXUtSQI1s2Obq01jXjym8sl0zjcerE
         FbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ow3B4nNSeHkTX9cFIh+YoDf8dKRS0Nl5CVhGWxfy+4g=;
        b=Z6HQhrDI3EdybsxB2PaQk5f2i1cnt5GaMBuZ1+sFQojLsH04XwWMIA0PTmcV1WwDs7
         efzTV2/LRFPXbSvutIRY3iOYN//G1Crf8S/uTHrWjZvgmIvfIXKW9RbWcNcOJ30eVf8z
         DkNfz8GKls8gMvHPgsGr2yWPvFqNoLHt1mmlfXx3ahMKcnFzjeNCfF6hiICAxglyNHXM
         UBj3MAK9J//N9T19oOsVaCLJ83hhi6JO41KaM15Ewel5UhGa3lJdBRu7r8f5Zr05hUsR
         EKLGgn4nkyi56gNpSSbbPaiDeNnmyjAkwq3ap3cD8U8J03qGmlE70KEnx+FRrseiEP1D
         YsYA==
X-Gm-Message-State: AOAM531iNysdICCee7yHB9hEM3Qt7nSj5blBm1GjeBiUVGErdO/BqLwE
        R8Pmh18OOyZCULqRhJbmoXDOA48BxF+rkCyjB28=
X-Google-Smtp-Source: ABdhPJzw92zZv9Qlrag/gBj6x8zLEFeJ6TW0tzw3lgIYh4l2zDfmqKpozYMp0A3j6fs+Naz6FLh1gliOf8+yMQ33mJc=
X-Received: by 2002:a9d:6d95:: with SMTP id x21mr23668443otp.339.1600432341761;
 Fri, 18 Sep 2020 05:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal> <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal> <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
In-Reply-To: <20200918121905.GU869610@unreal>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 15:31:51 +0300
Message-ID: <CAFCwf12KEa=chCZCWWkJ5bvGDeRCrmBcY9fB8CrtzjOknRQ5Qg@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Gal Pressman <galpress@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, izur@habana.ai,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 3:19 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Sep 18, 2020 at 03:07:19PM +0300, Oded Gabbay wrote:
> > On Fri, Sep 18, 2020 at 3:03 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Fri, Sep 18, 2020 at 02:56:09PM +0300, Oded Gabbay wrote:
> > > > On Fri, Sep 18, 2020 at 2:52 PM Leon Romanovsky <leon@kernel.org> wrote:
> > > > >
> > > > > On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> > > > > > On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > > > > > > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> > > > > > >> infrastructure for communication between multiple accelerators. Same
> > > > > > >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> > > > > > >> The RDMA implementation we did does NOT support some basic RDMA
> > > > > > >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> > > > > > >> library or to connect to the rdma infrastructure in the kernel.
> > > > > > >
> > > > > > > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > > > > > > you can't add random device offloads as IOCTL to nedevs.
> > > > > > >
> > > > > > > RDMA is the proper home for all the networking offloads that don't fit
> > > > > > > into netdev.
> > > > > > >
> > > > > > > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > > > > > > all. I'm sure this can too.
> > > > > >
> > > > > > Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> > > > > > was suggested to go through the vfio subsystem instead.
> > > > > >
> > > > > > I think this comes back to the discussion we had when EFA was upstreamed, which
> > > > > > is what's the bar to get accepted to the RDMA subsystem.
> > > > > > IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> > > > > > ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
> > > > > >
> > > > > > Does GAUDI fit these requirements? If not, should it be in a different subsystem
> > > > > > or should we open the "what qualifies as an RDMA device" question again?
> > > > >
> > > > > I want to remind you that rdma-core requirement came to make sure that
> > > > > anything exposed from the RDMA to the userspace is strict with proper
> > > > > UAPI header hygiene.
> > > > >
> > > > > I doubt that Havana's ioctls are backed by anything like this.
> > > > >
> > > > > Thanks
> > > >
> > > > Why do you doubt that ? Have you looked at our code ?
> > > > Our uapi and IOCTLs interface is based on drm subsystem uapi interface
> > > > and it is very safe and protected.
> > >
> > > Yes, I looked and didn't find open-source users of your UAPI headers.
> > > It is not related to being safe or protected by to the common request
> > > to present userspace that relies on those exported interfaces.
> > >
> > > > Otherwise Greg would have never allowed me to go upstream in the first place.
> > >
> > > Nice, can we get a link?
> > >
> > > >
> > > > We have a single function which is the entry point for all the IOCTLs
> > > > of our drivers (only one IOCTL is RDMA related, all the others are
> > > > compute related).
> > > > That function is almost 1:1 copy of the function in drm.
> > >
> > > DRM has same rules as RDMA, no kernel code will be merged without seeing
> > > open-source userspace.
> > >
> > > Thanks
> > >
> > > >
> > > > Thanks,
> > > > Oded
> >
> > So we do have an open-source library called hl-thunk, which uses our
> > driver and indeed that was part of the requirement.
> > It is similar to libdrm.
> > Here is the link:
> > https://github.com/HabanaAI/hl-thunk
>
> Are you kidding?
>
> This is mirror of some internal repository that looks like dumpster
> with ChangeId, internal bug tracker numbers, not part of major OS
> distributions.
>
> It is not open-source library and shows very clear why you chose
> to upstream your driver through driver/misc/ tree.
>
> Thanks

Adding Olof here.

No, usually not.
But are you kidding ?
What did you exactly expect to find ? Is there an open-source project
somewhere that encapsulates Deep-learning accelerators which I could
connect to ?
AFAIK, the only thing remotely relevant is CUDA and that is
closed-source (strange to hear lectures about open-source from NVIDIA
people here...)

So we are trying to give to the community such an open source library,
or at least an example. Hopefully one day, when more companies
upstream their drivers for deep-learning accelerators we could do
something like libdrm or rdma-core, but for now, it's just our driver.

I have been in this community since 2013 with AMD and then RedHat, and
I come with good intentions and a desire to open source and upstream
as much as I can. I don't think I deserve this kind of response.

The bottom line is that we had this discussion with Greg and Olof and
DRM people almost 2 years ago and if there was some open-source
project in user-space or some subsystem in the kernel we could connect
to, we would have done that instead of what we did, but the fact of
the matter there isn't such thing. Olof tried and is trying to create
a h/w accelerator subsystem but it still hasn't got up from the ground
yet.

Oded
