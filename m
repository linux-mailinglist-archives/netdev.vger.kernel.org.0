Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC7C26FBF0
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgIRL77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 07:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIRL76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 07:59:58 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A45C06174A;
        Fri, 18 Sep 2020 04:59:58 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x14so6668790oic.9;
        Fri, 18 Sep 2020 04:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Lzn6u1TqSXCWYoBwgZEzZ6h25P/gRjpfquy+GupLuk=;
        b=jY/BUGmCjODZdeRrPGcQFkExyjBFYrD+vuMkiB9sK1tmfoRp6G0SLPElqNyu6YymMS
         rgR8pDKjM6/rDM/qO8v1qdJ8R42If1YH1EdzYrgiaQt5KoPEf5QXdej9boJ/94O0Wf/z
         Jqf8wNLqLXAd1bvpeBnZQk8jL2YNX6a2EdT6Y74hM7IeqBM9d893ExDAlIXSMrE4YxN0
         bZV1yuRe/HGJryS2/hAfooAdVKalqkRak5oLp9oovH2dROvJTkWtTrLYpllHT8EOgVDs
         Lq/jvsHopGwR8Z/lqwHpx+s4gvK8FwCotAsC6E+s1aItr06yu89oPQb3qpM85Nhyfh78
         CGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Lzn6u1TqSXCWYoBwgZEzZ6h25P/gRjpfquy+GupLuk=;
        b=k2MkooPAdnhFRZwUPGvYfN/rP4qmI4EqNyi9G85x0twiLxafPIONKvRjm4R1A+ilqq
         Qc5MUVqdAB7LIaxyCEojKXhH/c0VRxrKvxUTDyujfcSxU1nFtvGG3gMhyFpsxj61Xln5
         Mbv+q4e68M86ENFM7cKZv4u1n/PMiJHsogHMhOzfGY7+WuXMqim1cAw5cPMnu2yZDSED
         ENzEOWLaXWeIKdUPt22xwsvIrwuTU/sC1e5hZGPPVPU0yWxdQQLxv4x79L9Dxm5YnSBf
         luwopF/FM4j01yQh6DZNdG8Vgbe3WDbGHdNBEVLmJx1gtJW0b4/83l4hpX10/5WVeC7x
         r/vQ==
X-Gm-Message-State: AOAM533nvp9ja880z3XyNbTY9q1tvBhho+DZi+bR9Q01XtLr7zH/IREY
        YxhBcvncpUL5FXabphpa6jwrQ8KAMp6+SDPw4h/qzJbYE9jJCA==
X-Google-Smtp-Source: ABdhPJw+2KeGVhCIuG1Whvj7EwbbzAPMoclqLsTA9zfvDdIVEA8IacOY8yoQu6EXJkYLaDaG+HADJ+I+2V+vPF6GuEk=
X-Received: by 2002:aca:c758:: with SMTP id x85mr9262586oif.102.1600430398098;
 Fri, 18 Sep 2020 04:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca>
In-Reply-To: <20200918115601.GP8409@ziepe.ca>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 14:59:28 +0300
Message-ID: <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>
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

On Fri, Sep 18, 2020 at 2:56 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> > On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> > >> infrastructure for communication between multiple accelerators. Same
> > >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> > >> The RDMA implementation we did does NOT support some basic RDMA
> > >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> > >> library or to connect to the rdma infrastructure in the kernel.
> > >
> > > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > > you can't add random device offloads as IOCTL to nedevs.
> > >
> > > RDMA is the proper home for all the networking offloads that don't fit
> > > into netdev.
> > >
> > > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > > all. I'm sure this can too.
> >
> > Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> > was suggested to go through the vfio subsystem instead.
> >
> > I think this comes back to the discussion we had when EFA was upstreamed, which
> > is what's the bar to get accepted to the RDMA subsystem.
> > IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> > ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
>
> That is more or less where we ended up, yes.
>
> I'm most worried about this lack of PD and MR.
>
> Kernel must provide security for apps doing user DMA, PD and MR do
> this. If the device doesn't have PD/MR then it is hard to see how a WQ
> could ever be exposed directly to userspace, regardless of subsystem.
>
> Jason

Hi Jason,
What you say here is very true and we handle that with different
mechanisms. I will start working on a dedicated patch-set of the RDMA
code in the next few weeks with MUCH MORE details in the commit
messages. That will explain exactly how we expose stuff and protect.

For example, regarding isolating between applications, we only support
a single application opening our file descriptor.
Another example is that the submission of WQ is done through our QMAN
mechanism and is NOT mapped to userspace (due to the restrictions you
mentioned above and other restrictions).

But again, I want to send something organized and with proper explanations.
I hope to have something in a couple of weeks.

Thanks,
Oded
