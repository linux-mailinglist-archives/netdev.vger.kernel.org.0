Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036F3270016
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgIROpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIROpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 10:45:52 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D12BC0613CE;
        Fri, 18 Sep 2020 07:45:52 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id i17so7268445oig.10;
        Fri, 18 Sep 2020 07:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=P3yjlF/u/Jq78fyyLTk7Xu7YketxuCacj+GbVd3Zo6Y=;
        b=enM6YbdNgFfctL5C7tLyYWfpX/M4PJOj0W8dR7JU2Dd9ar49JLIw7Kc6jJDT+m204i
         ybAZ+Eo7r5BAQMD4WrgR0A44p13Nn6LDK4DH/ro1pbRUHCH89w23FFeahO43Jw9yvLOq
         2sXQj4RjkT0a4c6rhSt2J55vd/rx5N9ndyQVpIG6c9/PVY2EEYz7kdKKJhP4ABem2fDw
         P5ZcJ2hJcH8ixa6KWsk3/gCKgMg/DKFQ//MPUt4kPqemL0YIstcQk59g6QE7ySTk4GU9
         A+k1DvITKSVMgjrAo87kYGSMQm+n3bHXzOMXFKf2JgvgQFP9rt7PQuBp2WbD7BFIP6bS
         fYzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=P3yjlF/u/Jq78fyyLTk7Xu7YketxuCacj+GbVd3Zo6Y=;
        b=XkrgGSD3LllzFyonu3+R+jl2GfYn4LHzDv1bQIwVVZoj5XsiqYEhfC0Ggm017s3Jqe
         xFxKOqRsNAUI6a1Yd1oYDEMZC0I0Oe6t+VQ3A12hrQLdgItesAMkGmB+bWg9d1II93Qq
         Fly6icyQBTe/PgUYRVmi3AX9hSU4gUvqsT/SnKWo7EYXz6zR0YXqQwzoTd5glI1xlvac
         TMxFGYf/J0XqW13fDuAAac+0Hvhj1ohxTn1eUas8H+fwIr8ExB2i5rN0kD+UgV08awVK
         jItNQ4aGtjv43hQOFHsoSPA6oGKgTkZYTfYkkTf+7HAmiKUtptRFP6jknPb9GEuqu3gp
         FwEg==
X-Gm-Message-State: AOAM530r2PFfxVgdR0cMbkaPj0uhm1LvovYlqu0B/qBHea2ix3vNCrtE
        KGdB4045dC9MsrkhOweq3VnbpNeuktr6ztEh/00=
X-Google-Smtp-Source: ABdhPJz/i4bbm7wHudQ7m1ea0DSFHMeM7Luj/q8+jhfzj3Q0pi3v87KFtEfOmu6DG+/WwqK7X8N12F+Jv7ZFO/chCzU=
X-Received: by 2002:a05:6808:3bb:: with SMTP id n27mr9293603oie.130.1600440351487;
 Fri, 18 Sep 2020 07:45:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200918115601.GP8409@ziepe.ca> <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
 <20200918121621.GQ8409@ziepe.ca> <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
 <20200918125014.GR8409@ziepe.ca> <CAFCwf12oK4RXYhgzXiN_YvXvjoW1Fwx1xBzR3Y5E4RLvzn_vhA@mail.gmail.com>
 <20200918132645.GS8409@ziepe.ca> <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
 <20200918135915.GT8409@ziepe.ca> <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
 <20200918141909.GU8409@ziepe.ca>
In-Reply-To: <20200918141909.GU8409@ziepe.ca>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 17:45:21 +0300
Message-ID: <CAFCwf121_UNivhfPfO6uFoHbF+2Odeb1c3+482bOXeOZUsEnug@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, izur@habana.ai,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 5:19 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Sep 18, 2020 at 05:12:04PM +0300, Oded Gabbay wrote:
> > On Fri, Sep 18, 2020 at 4:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Fri, Sep 18, 2020 at 04:49:25PM +0300, Oded Gabbay wrote:
> > > > On Fri, Sep 18, 2020 at 4:26 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > > >
> > > > > On Fri, Sep 18, 2020 at 04:02:24PM +0300, Oded Gabbay wrote:
> > > > >
> > > > > > The problem with MR is that the API doesn't let us return a new VA. It
> > > > > > forces us to use the original VA that the Host OS allocated.
> > > > >
> > > > > If using the common MR API you'd have to assign a unique linear range
> > > > > in the single device address map and record both the IOVA and the MMU
> > > > > VA in the kernel struct.
> > > > >
> > > > > Then when submitting work using that MR lkey the kernel will adjust
> > > > > the work VA using the equation (WORK_VA - IOVA) + MMU_VA before
> > > > > forwarding to HW.
> > > > >
> > > > We can't do that. That will kill the performance. If for every
> > > > submission I need to modify the packet's contents, the throughput will
> > > > go downhill.
> > >
> > > You clearly didn't read where I explained there is a fast path and
> > > slow path expectation.
> > >
> > > > Also, submissions to our RDMA qmans are coupled with submissions to
> > > > our DMA/Compute QMANs. We can't separate those to different API calls.
> > > > That will also kill performance and in addition, will prevent us from
> > > > synchronizing all the engines.
> > >
> > > Not sure I see why this is a problem. I already explained the fast
> > > device specific path.
> > >
> > > As long as the kernel maintains proper security when it processes
> > > submissions the driver can allow objects to cross between the two
> > > domains.
> > Can you please explain what you mean by "two domains" ?
> > You mean the RDMA and compute domains ? Or something else ?
>
> Yes
>
> > What I was trying to say is that I don't want the application to split
> > its submissions to different system calls.
>
> If you can manage the security then you can cross them. Eg since The
> RDMA PD would be created on top of the /dev/misc char dev then it is
> fine for the /dev/misc char dev to access the RDMA objects as a 'dv
> fast path'.
>
> But now that you say everything is interconnected, I'm wondering,
> without HW security how do you keep netdev isolated from userspace?
>
> Can I issue commands to /dev/misc and write to kernel memory (does the
> kernel put any pages into the single MMU?) or corrupt the netdev
> driver operations in any way?
>
> Jason

No, no, no. Please give me more credit :) btw, our kernel interface
was scrutinized when we upstreamed the driver and it was under review
by the Intel security team.

To explain our security mechanism will require some time. It is
detailed in the driver, but it is hard to understand without some
background.
I wonder where to start...

First of all, we support open, close, mmap and IOCTLs to
/dev/misc/hlX. We don't support read/write system calls.
A user never gets direct access to kernel memory. Only through
standard mmap. The only thing we allow to mmap is a command buffer
(which is used to submit work to certain DMA  queues on our device)
and to a memory region we use for "CQ" for the RDMA. That's it.

Any access by the device's engines to the host memory is done via our
device's MMU. Our MMU supports multiple ASIDs - Address Space IDs. The
kernel driver is assigned ASID 0, while the user is assigned ASID 1.
We can support up to 1024 ASIDs, but because we limit the user to have
a single application, we only use ASID 0 and 1.

The above means a user can't program an engine (DMA, NIC, compute) to
access memory he didn't first mapped into our device's MMU. The
mapping is done via one of our IOCTLs and the kernel driver makes sure
(using standard kernel internal APIs) the host memory truly belongs to
the user process. All those mappings are done using ASID 1.

If the driver needs to map kernel pages into the device's MMU, then
this is done using ASID 0. This is how we take care of separation
between kernel memory and user memory.

Each transaction our engines create and is going to the host first
passes through our MMU. The transaction comes with its ASID value.
According to that, the MMU knows which page tables to do the walk on.

Specifically regarding RDMA, the user prepares a WQE on the host
memory in an area which is mapped into our MMU using ASID 1. The user
uses the NIC control IOCTL to give the kernel driver the virtual base
address of the WQ and the driver programs it to the H/W. Then, the
user can submit the WQE by submitting a command buffer to the NIC
QMAN. The command buffer contains a message to the QMAN that tells it
to ring the doorbell of the relevant NIC port. The user can't do it
from userspace.

For regular Ethernet traffice, we don't have any IOCTLs of course. All
Ethernet operations are done via the standard networking subsystem
(sockets, etc.).

There are more details of course. I don't know how much you want me to
go deeper. If you have specific questions I'll be happy to answer.
Oded
