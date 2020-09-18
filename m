Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4426FDBD
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgIRNC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbgIRNCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:02:54 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710C1C06174A;
        Fri, 18 Sep 2020 06:02:54 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x14so6882394oic.9;
        Fri, 18 Sep 2020 06:02:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IaS9N3Cng7inbUF+J31vDuAkMgLHxsqDlirlY0FiQ4o=;
        b=qV8eq1i4hzO2ZurLNa/xNu3twhKi6zMyrsuXQV1Ulfpi/1aq4CCkSPsIYb9riyPmL8
         WHxx4SMEqX+6uqRn1ORKEgwRfisC/Qg76pmuQpf8M9N4wH+uuNrmn7YivQvViR0Nsxm1
         ip1Pmtatumvk568qONRe1Z+q4rUJd9fRqScm38Gm3SrCAGP9XuiDWcB0clvDEf3it27w
         clH8qM4/fN8YInstvz6Hf2ar85ZCff5wudlRBBI95oZwwszuskQlS9gO7/ezYAzW8L5g
         XoGT5bCzVip2/Iyvzsoozt07gqKZnFBgjTd7nC8c31gQtvPd8f6F1nl6j07X2GidNRuv
         itsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IaS9N3Cng7inbUF+J31vDuAkMgLHxsqDlirlY0FiQ4o=;
        b=FUl6ngCAn67MazrVlynzCoXYlg/4WUG9mae2+KrCVuTuQzhp47Qu5vQzGZ5HJERf8d
         uDsaHQVZoAEnMijODyZx1SgripfRPi77AwW5CbS9t/N7TCKCsoHLr08y+3H7+h4nY+/9
         6K4OWrot11LcVZUeQNDFs+2Z9On8LitFTVwxm7yKi18KY4no+Ft/6sPnXmntGHHnYfq9
         eIGovrx6aYqMWQPrwYsfe+OsM+us1Rszo5kPkyxzxENSCVl5CmqXf9Kt297xKjH3nIxX
         fdA8cltNRVs0V8ZNuTjgjW9RxwS2/7BJZCSQ8C0W65Z6GKNpXQIkKx2ibchzSnjvM+ej
         9IxA==
X-Gm-Message-State: AOAM533pQN83Qz9ao7lTsTqMoxrKEs3oV7GV15915xScyKHjrsyIsJ9W
        EYwuOO+MzPUzA0M61eKZb7TA9L29RdC/zcwYmi8=
X-Google-Smtp-Source: ABdhPJx5P2coN1iGx3hJqsOpCFte2hcUqF1dJiLi+OdLp4UhEFLRTpyVy97rOoc92Wp7oG+09/gygVAOe7JkT+97dr4=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr9510248oij.154.1600434173449;
 Fri, 18 Sep 2020 06:02:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca> <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
 <20200918121621.GQ8409@ziepe.ca> <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
 <20200918125014.GR8409@ziepe.ca>
In-Reply-To: <20200918125014.GR8409@ziepe.ca>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 16:02:24 +0300
Message-ID: <CAFCwf12oK4RXYhgzXiN_YvXvjoW1Fwx1xBzR3Y5E4RLvzn_vhA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     izur@habana.ai, Gal Pressman <galpress@amazon.com>,
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

On Fri, Sep 18, 2020 at 3:50 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Sep 18, 2020 at 03:34:54PM +0300, Oded Gabbay wrote:
> > > > Another example is that the submission of WQ is done through our QMAN
> > > > mechanism and is NOT mapped to userspace (due to the restrictions you
> > > > mentioned above and other restrictions).
> > >
> > > Sure, other RDMA drivers also require a kernel ioctl for command
> > > execution.
> > >
> > > In this model the MR can be a software construct, again representing a
> > > security authorization:
> > >
> > > - A 'full process' MR, in which case the kernel command excution
> > >   handles dma map and pinning at command execution time
> > > - A 'normal' MR, in which case the DMA list is pre-created and the
> > >   command execution just re-uses this data
> > >
> > > The general requirement for RDMA is the same as DRM, you must provide
> > > enough code in rdma-core to show how the device works, and minimally
> > > test it. EFA uses ibv_ud_pingpong, and some pyverbs tests IIRC.
> > >
> > > So you'll want to arrange something where the default MR and PD
> > > mechanisms do something workable on this device, like auto-open the
> > > misc FD when building the PD, and support the 'normal' MR flow for
> > > command execution.
> >
> > I don't know how we can support MR because we can't support any
> > virtual address on the host. Our internal MMU doesn't support 64-bits.
> > We investigated in the past, very much wanted to use IBverbs but
> > didn't figure out how to make it work.
> > I'm adding Itay here and he can also shed more details on that.
>
> I'm not sure what that means, if the driver intends to DMA from
> process memory then it certainly has a MR concept.
>
> MRs can control the IOVA directly so if you say the HW needs a MR IOVA
> < 2**32 then that is still OK.
>
> Jason

Hi Jason,
I'll try to explain but please bear with me because it requires some
understanding of our H/W architecture.

Our ASIC has 32 GB of HBM memory (similar to GPUs). The problem is
that HBM memory is accessed by our ASIC's engines (DMA, NIC, etc.)
with physical addressing, which is mapped inside our device between
0x0 to 0x8_0000_0000.

Now, if a user performs malloc and then maps that memory to our device
(using our memory MAP ioctl, similar to how GPU works), it will get a
new virtual address, which is in the range of 0x80_0000_0000 - (2^50
-1). Then, he can use that new VA in our device with different engines
(DMA, NIC, compute).

That way, addresses that represent the host memory do not overlap
addresses that represent HBM memory.

The problem with MR is that the API doesn't let us return a new VA. It
forces us to use the original VA that the Host OS allocated. What will
we do if that VA is in the range of our HBM addresses ? The device
won't be able to distinguish between them. The transaction that is
generated by an engine inside our device will go to the HBM instead of
going to the PCI controller and then to the host.

That's the crust of the problem and why we didn't use MR.
If that's not clear, I'll be happy to explain more.

Thanks,
Oded
