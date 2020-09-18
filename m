Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0226FC17
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgIRMHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726154AbgIRMHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:07:50 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45D8C06174A;
        Fri, 18 Sep 2020 05:07:49 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id z26so6677787oih.12;
        Fri, 18 Sep 2020 05:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=olhpFJeb79uNmX+rc+aZ5O5IyhDNeG2Rm5bnVZ+y69o=;
        b=fNrhazAzHHG7klbmFdnOHUX+2cTGM5BcL6hGDJVNr+Cyh4dyGJwHctiL/86UZyEwhH
         QGLVh3AxzZpMY8ZTmF3CZvfkymA32qpxOWGAQtDaduVEIG6rhYhFPdM6uh5YjvDkWuFP
         7wbctzhuNmTnEe53S8+b/oVbf1gs/Mo34aA7gcgAsnuZO9Igogu0x/hnvD0zKslNDC6p
         rUCyKOFVIxyn1NkRAOHMqJH6PN9/z337UaNF/WRNQcjNlB29KdNTWm31kwhDu4QIKean
         iOv66OUSPycG5hzQOqH5LCMh914w7KjtudZ3B6YdrRImI0dYEQA/Ci3Eyp3cY/bbsMTN
         Epng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=olhpFJeb79uNmX+rc+aZ5O5IyhDNeG2Rm5bnVZ+y69o=;
        b=sw6KCPGF3Se/Uxy79KdAAqEG1Rw9Wxl5TS4VjTU9CTHBJ9ZixSsDfPSq1cMelH/VMM
         5T95u25QrQC1088uOwhWQ5sJcJfpGqO2drWTl6dBcn3pkxjSRz1R9DTeMvXlOgx2FwN3
         EYr8HSnICi3nQRQyx94E++UtCcxMd7IBp29zCmpLOpUZ/0DRr9AX6EjCx7QGMnc1/gHm
         l81D07IUt1xOXZFlbDmpdx3thyHpAlZeVRFrzeQJZiTe6n0LYvdkxgbNRQ3pZ5FYSx8Z
         y+tfKMH6J0s6A3+M0a94ECmW70hjF/VAjrA4svSLjXCbRCvMKBx+Jz0qc16/wv5n7SpR
         dXZw==
X-Gm-Message-State: AOAM530ly879udqos+vYsv5ftysVG4PrPWHB4O6fz/H9dft/nDxBKRQD
        JpzUEgFCWyx/HyULDSgMQPNeK6qp+oyFeN0iUy4=
X-Google-Smtp-Source: ABdhPJykhIm/KBPowAEvz98pjun9+Q5ApuAXuoAHVZIcRTXGQOSg7O37+gpym5icQptKoY8HIzOjpWqmlbyrB99smR4=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr9355355oij.154.1600430869082;
 Fri, 18 Sep 2020 05:07:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115227.GR869610@unreal> <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
In-Reply-To: <20200918120340.GT869610@unreal>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 15:07:19 +0300
Message-ID: <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
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
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 3:03 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Fri, Sep 18, 2020 at 02:56:09PM +0300, Oded Gabbay wrote:
> > On Fri, Sep 18, 2020 at 2:52 PM Leon Romanovsky <leon@kernel.org> wrote:
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
> > > >
> > > > Does GAUDI fit these requirements? If not, should it be in a different subsystem
> > > > or should we open the "what qualifies as an RDMA device" question again?
> > >
> > > I want to remind you that rdma-core requirement came to make sure that
> > > anything exposed from the RDMA to the userspace is strict with proper
> > > UAPI header hygiene.
> > >
> > > I doubt that Havana's ioctls are backed by anything like this.
> > >
> > > Thanks
> >
> > Why do you doubt that ? Have you looked at our code ?
> > Our uapi and IOCTLs interface is based on drm subsystem uapi interface
> > and it is very safe and protected.
>
> Yes, I looked and didn't find open-source users of your UAPI headers.
> It is not related to being safe or protected by to the common request
> to present userspace that relies on those exported interfaces.
>
> > Otherwise Greg would have never allowed me to go upstream in the first place.
>
> Nice, can we get a link?
>
> >
> > We have a single function which is the entry point for all the IOCTLs
> > of our drivers (only one IOCTL is RDMA related, all the others are
> > compute related).
> > That function is almost 1:1 copy of the function in drm.
>
> DRM has same rules as RDMA, no kernel code will be merged without seeing
> open-source userspace.
>
> Thanks
>
> >
> > Thanks,
> > Oded

So we do have an open-source library called hl-thunk, which uses our
driver and indeed that was part of the requirement.
It is similar to libdrm.
Here is the link:
https://github.com/HabanaAI/hl-thunk

That library also comes with a comprehensive suite of tests which
shows how to use the accelerator and we have many NIC tests which show
how to use the NIC.
All the rest of the user-space code in Habana is going through that library.

Currently, you won't find the NIC code there because we didn't
upstream it as the driver code wasn't ready, but I'll push it there in
a private branch if you want to take a look.

Thanks,
Oded
