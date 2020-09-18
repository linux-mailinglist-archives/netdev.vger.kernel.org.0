Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6519C26FF99
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 16:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIROMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 10:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbgIROMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 10:12:36 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF81AC0613CE;
        Fri, 18 Sep 2020 07:12:35 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id u25so5509140otq.6;
        Fri, 18 Sep 2020 07:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OfM3D/HWKVnBtRdUqaIJUO91TX5FfrMOdFLYWhdYaGY=;
        b=P1vrERlawL05FpJ0Gbz4yJ9KbBPf0loHsqsu713qx3ufWs6Ee9dmGwAA+AOG/ykdsJ
         +1CXiJ8Gfrfe6OZ6CqHrAkmDbPi9vRdPpGih90hBSyTMAwFIo/h1UtkPiwKFYDB1olPv
         5Rs/IK06TRdLTznJjjB4IlFCxF7bzXvhCOnpVgrRciU/e6mOle5zN3N+UgdFfwA0r1Au
         Tjrt8QCSKfd3CTmtwIrcFZQOJWRaEjxYeagpmTO7Be305z4e+Fb9SeaRR5c4tdYhBLGJ
         UAzEJ27MSa459D6PmYmlF9bR+5M+LSZuMIY9HCmaVGYg1nWQsaj73/bK1NAqJMFK7v5d
         6a1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OfM3D/HWKVnBtRdUqaIJUO91TX5FfrMOdFLYWhdYaGY=;
        b=Ssj56uoI4KH8mgcuLckj4ueiWCwNU/jkmsE3HzMtOBRI8FWB+v1DILnZROdtIbHp/o
         Sy+vdMD0HkgT9p1AoxUopVJ+proyIaqzBwSXFkUnxdo1huRHx/bBgwGnT31yzJdtSaec
         gcZR2SE08i8AEjdp9H9CGmw83IzZmWIz9L9S6q6cfmDRQPS79RANTDwdlQfsp5Y2TamV
         62M41Hw+xsvJAdKLsO1gVitRVEo4/9KGKVe1FxqdJffklWNBqn+Oh02xouhy0ngeKCnV
         wu8F4pF/5xd7Y6kpuDyzlf5Qr0NFMooxk7/UrwemGrnu+Yi+V2Kpla/6r3YFGk5cNAec
         PC2A==
X-Gm-Message-State: AOAM533XJ5nffBDxP5Zsx8GYBh+TqeWr0523hDXdyqWPS/5+NMan83NJ
        nD+syxVlcsr9fsg79x7skJlUIH7RGNou3PkYvNk=
X-Google-Smtp-Source: ABdhPJynAtaof2ZNWbjdtzCtmITrXYnI+XfEk3lreIkgPVxpjZcOyBmmrsQBNW4okEV8aD2ScTyuYkN7HFum49X2pdo=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr22590538oth.145.1600438355136;
 Fri, 18 Sep 2020 07:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca> <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
 <20200918121621.GQ8409@ziepe.ca> <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
 <20200918125014.GR8409@ziepe.ca> <CAFCwf12oK4RXYhgzXiN_YvXvjoW1Fwx1xBzR3Y5E4RLvzn_vhA@mail.gmail.com>
 <20200918132645.GS8409@ziepe.ca> <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
 <20200918135915.GT8409@ziepe.ca>
In-Reply-To: <20200918135915.GT8409@ziepe.ca>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 17:12:04 +0300
Message-ID: <CAFCwf13rJgb4=as7yW-2ZHvSnUd2NK1GP0UKKjyMfkB3vsnE5w@mail.gmail.com>
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

On Fri, Sep 18, 2020 at 4:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Sep 18, 2020 at 04:49:25PM +0300, Oded Gabbay wrote:
> > On Fri, Sep 18, 2020 at 4:26 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > >
> > > On Fri, Sep 18, 2020 at 04:02:24PM +0300, Oded Gabbay wrote:
> > >
> > > > The problem with MR is that the API doesn't let us return a new VA. It
> > > > forces us to use the original VA that the Host OS allocated.
> > >
> > > If using the common MR API you'd have to assign a unique linear range
> > > in the single device address map and record both the IOVA and the MMU
> > > VA in the kernel struct.
> > >
> > > Then when submitting work using that MR lkey the kernel will adjust
> > > the work VA using the equation (WORK_VA - IOVA) + MMU_VA before
> > > forwarding to HW.
> > >
> > We can't do that. That will kill the performance. If for every
> > submission I need to modify the packet's contents, the throughput will
> > go downhill.
>
> You clearly didn't read where I explained there is a fast path and
> slow path expectation.
>
> > Also, submissions to our RDMA qmans are coupled with submissions to
> > our DMA/Compute QMANs. We can't separate those to different API calls.
> > That will also kill performance and in addition, will prevent us from
> > synchronizing all the engines.
>
> Not sure I see why this is a problem. I already explained the fast
> device specific path.
>
> As long as the kernel maintains proper security when it processes
> submissions the driver can allow objects to cross between the two
> domains.
Can you please explain what you mean by "two domains" ?
You mean the RDMA and compute domains ? Or something else ?

What I was trying to say is that I don't want the application to split
its submissions to different system calls.

Currently we perform submissions through the CS_IOCTL that is defined
in our driver. It is a single IOCTL which allows the user to submit
work to all queues, without regard to the underlying engine of each
queue.
If I need to split that to different system calls it will have major
implications. I don't even want to start thinking about all the
synchronization at the host (userspace) level that I will need to do.
That's what I meant by saying that you force me to treat my device as
if it were multiple devices. The whole point of our ASIC is to combine
multiple IPs on the same ASIC.

What will happen when we will add a third domain to our device (e.g.
storage, video decoding, encryption engine, whatever). Will I then
need to separate submissions to 3 different system calls ? In 3
different subsystems ? This doesn't scale. And I strongly say that it
will kill the performance of the device. Not because of the driver.
Because of the complications to the user-space.

Oded

>
> Jason
