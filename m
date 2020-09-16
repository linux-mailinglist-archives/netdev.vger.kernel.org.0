Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E4D26BEC1
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 10:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbgIPIDh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 04:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbgIPIDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 04:03:35 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2E5C06174A;
        Wed, 16 Sep 2020 01:03:07 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id i16so1729014oii.12;
        Wed, 16 Sep 2020 01:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lmpE7Zf045Vv00K6sEaHXo64+zEBp0yhPWRBeLSTcn0=;
        b=kuIn3pJpGJ+mpkQyhF710YhlvD1LVwbS+RTByqTFNLD49Jem0MDX+aDtN3XDVKSjVC
         7xMMr1wLVTprF2yesOSOzRXOXPsgIRAgttbC36inMn4N4Z3yUdn9KmGtTY4hYIZsUwGC
         vsx9XE1/bwypsv5YJT8sWRIK+pZaBWnf3mwjyLNLRZIz/LUZwKFZa9A6Za6NXMS4UbHE
         K7JB5rrTr53FVtvcaOXdrsOOgAACwe9UZg5Yk3qbRUOyTkLFvC9MR9Sr9lN37cdE7j11
         K176XvPct2UBtyXlKihm9JKofLELIIDIZJkBkJo5RrCeimpLZ90Nk8t4/OQ9O5DYnSxy
         /Pjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lmpE7Zf045Vv00K6sEaHXo64+zEBp0yhPWRBeLSTcn0=;
        b=WRpehHdx+kNYTdn6/gRlXA98oHQLiCmLjQbYXNgbz0KQKa3t7YNwZr8dM26FVyAeN9
         A9kFZrJNH4zV8WP3zaDx8xldOaHhLRHKAdJwdy3ZCktBURUeBPGfITbZtO8Ew35+iEQV
         3wARkX4O+r1GZh7XqZVjsKmWFthUEAYLLWZaoSL2+HV0Trh61Ots7+92PmOlDtdIUnwt
         bszPypKKeIIJ2uDMHeOcaFtVQMV8DygyaZUaIiLpskQCTbYqeB866IX5DIi+hh6TKnbM
         YFs1rOp6UrVnvvFIDrZgZVjdAzo5oR/liHzGG2hap4VNBtAV5f+F895Raf1/emkqlP0d
         mA2Q==
X-Gm-Message-State: AOAM531LvHYpjDP2rF0fWPFjl2o0nWkzhy2fVZ1gyX3ekarw5Cok67Zz
        J/J5i0kU6DJoyYMu1hERQZpsH5xTk3KC3F/DFcFV/emI4EnMLA==
X-Google-Smtp-Source: ABdhPJy0d4x7g48hIPo/6h8BE8KloT2VJFeG1CSKsxy395xfz4UzMudOhX0Z8FA6d9JbI5RT1bfPgZ8o8WONtmqfknk=
X-Received: by 2002:a05:6808:3bb:: with SMTP id n27mr2211314oie.130.1600243386330;
 Wed, 16 Sep 2020 01:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915.134252.1280841239760138359.davem@davemloft.net>
 <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com>
 <20200916062614.GF142621@kroah.com> <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
 <20200916074217.GB189144@kroah.com>
In-Reply-To: <20200916074217.GB189144@kroah.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Wed, 16 Sep 2020 11:02:39 +0300
Message-ID: <CAFCwf10zLR9v65sgGGdkcf+JzZaw_WORAbQvEw-hbbfj=dy2Xg@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 10:41 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Sep 16, 2020 at 09:36:23AM +0300, Oded Gabbay wrote:
> > On Wed, Sep 16, 2020 at 9:25 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Tue, Sep 15, 2020 at 11:49:12PM +0300, Oded Gabbay wrote:
> > > > On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
> > > > >
> > > > > From: Oded Gabbay <oded.gabbay@gmail.com>
> > > > > Date: Tue, 15 Sep 2020 20:10:08 +0300
> > > > >
> > > > > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > > > > into the habanalabs driver.
> > > > > >
> > > > > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > > > > are in that patch's commit message.
> > > > > >
> > > > > > Link to v2 cover letter:
> > > > > > https://lkml.org/lkml/2020/9/12/201
> > > > >
> > > > > I agree with Jakub, this driver definitely can't go-in as it is currently
> > > > > structured and designed.
> > > > Why is that ?
> > > > Can you please point to the things that bother you or not working correctly?
> > > > I can't really fix the driver if I don't know what's wrong.
> > > >
> > > > In addition, please read my reply to Jakub with the explanation of why
> > > > we designed this driver as is.
> > > >
> > > > And because of the RDMA'ness of it, the RDMA
> > > > > folks have to be CC:'d and have a chance to review this.
> > > > As I said to Jakub, the driver doesn't use the RDMA infrastructure in
> > > > the kernel and we can't connect to it due to the lack of H/W support
> > > > we have
> > > > Therefore, I don't see why we need to CC linux-rdma.
> > > > I understood why Greg asked me to CC you because we do connect to the
> > > > netdev and standard eth infrastructure, but regarding the RDMA, it's
> > > > not really the same.
> > >
> > > Ok, to do this "right" it needs to be split up into separate drivers,
> > > hopefully using the "virtual bus" code that some day Intel will resubmit
> > > again that will solve this issue.
> > Hi Greg,
> > Can I suggest an alternative for the short/medium term ?
> >
> > In an earlier email, Jakub said:
> > "Is it not possible to move the files and still build them into a single
> > module?"
> >
> > I thought maybe that's a good way to progress here ?
>
> Cross-directory builds of a single module are crazy.  Yes, they work,
> but really, that's a mess, and would never suggest doing that.
>
> > First, split the content to Ethernet and RDMA.
> > Then move the Ethernet part to drivers/net but build it as part of
> > habanalabs.ko.
> > Regarding the RDMA code, upstream/review it in a different patch-set
> > (maybe they will want me to put the files elsewhere).
> >
> > What do you think ?
>
> I think you are asking for more work there than just splitting out into
> separate modules :)
>
> thanks,
>
> greg k-h
Hi Greg,

If cross-directory building is out of the question, what about
splitting into separate modules ? And use cross-module notifiers/calls
? I did that with amdkfd and amdgpu/radeon a couple of years back. It
worked (that's the best thing I can say about it).
The main problem with this "virtual bus" thing is that I'm not
familiar with it at all and from my experience I imagine it would take
a considerable time and effort to upstream this infrastructure work.
This could delay the NIC code for a couple of years, which by then
this won't be relevant at all.

So I'm trying to find some middle ground here on how to proceed.

Thanks,
Oded
