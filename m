Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EAF26FF1D
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 15:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgIRNt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 09:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRNtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 09:49:55 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD9C0C0613CE;
        Fri, 18 Sep 2020 06:49:55 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id r4so1436148ooq.7;
        Fri, 18 Sep 2020 06:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eSTVGNh/5mQHPnByx0WomiCqSvC+JAjHkYFnnp7p7Oc=;
        b=oGkNm1QkD3vp4zYjnHuVmKLK4++n6Bf0bmaLZL/JnCj7RlnQnc8qvgQQJrcW7mT1xe
         YgCUGdUw/xNgLJATeDEgLlI5xVkMJVsvvb8Jy0F0MRUcTsJT5xnqszbt4vxz/R4b5SIV
         LDIwxjDxnsKgMuzILtXjXOP7N22zJy2+l0ETltAPZN+ZlTb4s7fQPAMRCzDGfWF2wJzX
         eqlQFyu/3cvYMHtFuphUXGGBbj/33meHNLann0ep1qaVCBSEQXIQxt83gQPZnrh3crDu
         7ggd/shEGiWz7uBf4ZGpPDUZXbUpG5wjDErO6uAx8qUhO/x6CoNQbs7/q+McXvsuDbVf
         xrcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eSTVGNh/5mQHPnByx0WomiCqSvC+JAjHkYFnnp7p7Oc=;
        b=JVoQZkkHplnBQgiGe85YmmgBsKrmax90mv/65hjDjGVh1fXPXHxrynZb0r9JxieoEP
         QbJ21AyGks4lZThIckGQWLNlMmXxbVPmZpvu45ktsRvUKqQl8k1fWzJNcBocMZzrYjxG
         cUIKOsRfdbiaAXx4zLWtqjfOnK4OHpYDnmzuUaDTrAJAxUcEFWflyEIetaxq4HWRjzJ9
         u/z4PIidstqdKDIs7BHf8kbvGYe+JgRmFcZNTiM0YNX364nU76ZhUJ38rdae5Q9+mS5Q
         Wg9sWPbJHuC4u0MPf5yWYE0beZ3V1gOcFbA784W2CJrpqzEKZPHSzTXYUNuXG5A26JVM
         a4uA==
X-Gm-Message-State: AOAM531ee3tnpDwHuhJP9YAf2OEDyxNEqRWn7hEFyZqOFRsAo+CKsRZk
        YeGCiVCkN6LFqvH/L8CgxuQDn0fTF/KcZpicSjA=
X-Google-Smtp-Source: ABdhPJxt1KlcV1NIDtb7F+k+aLYBjtnRdSEBDNwlTzK/YlkzTD8P2J5/8WI5VYBIHoniB7tJcmAmpCOcgQ1qsAe+oQQ=
X-Received: by 2002:a4a:d9c3:: with SMTP id l3mr23846819oou.27.1600436994918;
 Fri, 18 Sep 2020 06:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca> <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
 <20200918121621.GQ8409@ziepe.ca> <CAFCwf12YBaka2w2cnTxyX9L=heMnaM6QN1_oJ7h7DxHDmy2Xng@mail.gmail.com>
 <20200918125014.GR8409@ziepe.ca> <CAFCwf12oK4RXYhgzXiN_YvXvjoW1Fwx1xBzR3Y5E4RLvzn_vhA@mail.gmail.com>
 <20200918132645.GS8409@ziepe.ca>
In-Reply-To: <20200918132645.GS8409@ziepe.ca>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 16:49:25 +0300
Message-ID: <CAFCwf109t5=GuNvqTqLUCiYbjLC6o2xVoLY5C-SBqbN66f6wxg@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     izur@habana.ai, Gal Pressman <galpress@amazon.com>,
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

On Fri, Sep 18, 2020 at 4:26 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Fri, Sep 18, 2020 at 04:02:24PM +0300, Oded Gabbay wrote:
>
> > The problem with MR is that the API doesn't let us return a new VA. It
> > forces us to use the original VA that the Host OS allocated.
>
> If using the common MR API you'd have to assign a unique linear range
> in the single device address map and record both the IOVA and the MMU
> VA in the kernel struct.
>
> Then when submitting work using that MR lkey the kernel will adjust
> the work VA using the equation (WORK_VA - IOVA) + MMU_VA before
> forwarding to HW.
>
We can't do that. That will kill the performance. If for every
submission I need to modify the packet's contents, the throughput will
go downhill.
Also, submissions to our RDMA qmans are coupled with submissions to
our DMA/Compute QMANs. We can't separate those to different API calls.
That will also kill performance and in addition, will prevent us from
synchronizing all the engines.

I also have to say, it troubles me that you keep referring to our
device as an RDMA device. It is not an RDMA device. It is a
deep-learning accelerator which uses RDMA as a way to interconnect
multiple devices. We don't intend to replace General-Purpose RDMA
devices. We know we don't support that.
Therefore, I still fail to see why we need to support all the above...

Our work submission is not to just "send/receive packets". Sending
packets is part of a general recipe to do DMA, perform compute on data
and send/receive data. All together, in a synchronized fashion.

The way you try to force me to go is to separate that into different
functionality, as if I have different ASICs, which is very
counter-productive in terms of performance and simplicity. i.e. have
one method of submitting work to DMA/compute and another way to RDMA
ports.

I know this is how the kernel is structured now - subsystems for
devices that belong to a single domain (graphics, net, storage). But I
fear that you will soon see this paradigm doesn't work with new
devices in AI, which combine multiple domains into a single ASIC.

Greg, I would love to hear your opinion here. Am I totally wrong ? Is
treating a single ASIC that belongs to multiple domains as if it were
multiple ASICs a good thing ? Don't you think it will hurt the
performance ?

Oded

> EFA doesn't support rkeys, so they are not required to be emulated. It
> would have to create rkeys using some guadidv_reg_mr_rkey()
>
> It is important to understand that the usual way we support these
> non-RDMA devices is to insist that they use SW to construct a minimal
> standards based RDMA API, and then allow the device to have a 'dv' API
> to access a faster, highly device specific, SW bypass path.
>
> So for instance you might have some guadidv_post_work(qp) that doesn't
> use lkeys and works directly on the MMU_VA. A guadidv_get_mmu_va(mr)
> would return the required HW VA from the kernel.
>
> Usually the higher level communication library (UCX, MPI, etc) forms
> the dv primitives into something application usable.
>
> > we do if that VA is in the range of our HBM addresses ? The device
> > won't be able to distinguish between them. The transaction that is
> > generated by an engine inside our device will go to the HBM instead of
> > going to the PCI controller and then to the host.
> >
> > That's the crust of the problem and why we didn't use MR.
>
> No, the problem with the device is that it doesn't have a lkey/rkey,
> so it is stuck with a single translation domain. RoCE compliant
> devices are required to have multiple translation domains - each
> lkey/rkey specifies a unique translation.
>
> The MR concept is a region of process VA mapped into the device for
> device access, and this device *clearly* has that.
>
> Jason
