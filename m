Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9536726BD54
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 08:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgIPGg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 02:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgIPGgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 02:36:52 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28971C06174A;
        Tue, 15 Sep 2020 23:36:52 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id c10so5629356otm.13;
        Tue, 15 Sep 2020 23:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z23HU1mxCZZbJlpTvKa8qAEV3TkyoUwCFPg8hsdXyL0=;
        b=jqsK7I8FfhK/0plFJio08fNWJbDmkMvS/e3NY5NZHbwGC/SfxM4SV5lW0cpmCYW/Z2
         KPDI++0LRPCVrTtGtxWRxD7WyHSlra1HLtlUk6x0Bgj84jg0muk55uGJ8W850+DwhpGr
         0gelcUxwnLP1idWXnCoA/hw9gjOreKKDISWotuXE+fdjqFqZk2QYRP67ihxu9se/hCat
         DUM/T1IU5bcVPzmksnt3INw0lN4fnkf2pCTG4kGGRvsFEAg7+QQwa/HxsJqL/Nv99PHN
         /6MbnHnx1hoXdemU1hLwcMHVWk8sA0qv6KbHoEatayh+8SwGL12CzfUeAvXFoZwFs3S9
         0sKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z23HU1mxCZZbJlpTvKa8qAEV3TkyoUwCFPg8hsdXyL0=;
        b=lcDb4rsQetZZwYUV28wLaTBhOlfURudZdO5TCSo6/g5L++CYyvJcVx4jFDwiq9DKnC
         VAVywnRW3lNKie1nJz9PmW5fxn8fhJ+UFhWB97oT+gp9u6MLAJ9XBPUucOT7Tfu4p37f
         z8nfwM0cpv0H5vyjw3sKTM35Ptwb0rg6a53mm7JOZcwwBJbbbTjZaFB0ehL/x8lcmy52
         hqTfWteDXFEjRXfs3K61rXGHiLMEiAPpyfc7oq4a3eAY3Aladl9qVTGD/XlMB2KrMMGi
         m9SBrQ6cJlr6Ar76eAH0HNGXwPqjJTrpjXExgTbVyPva9ob6zds/QTWjs8tZZmkYkhtt
         0+ig==
X-Gm-Message-State: AOAM532apA0I9+1HSydPl664FTs7rqszMuEK8zAyeXKTCvE3Zhu0Zw5t
        z9bjYaaUoYhxtx6EyDsKqyuZMkE6Ny7ueDCRnps=
X-Google-Smtp-Source: ABdhPJzLmCOY1/3HseaJIDt4VnhSnKOsj1qaq2zNlFrQ7tsZlyYn1PjCufexO7Zrz5iF+wm61/TN9iZAz8LgHjerLU8=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr15199348oth.145.1600238211305;
 Tue, 15 Sep 2020 23:36:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915.134252.1280841239760138359.davem@davemloft.net>
 <CAFCwf131Vbo3im1BjOi_XXfRUu+nfrJY54sEZv8Z5LKut3QE6w@mail.gmail.com> <20200916062614.GF142621@kroah.com>
In-Reply-To: <20200916062614.GF142621@kroah.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Wed, 16 Sep 2020 09:36:23 +0300
Message-ID: <CAFCwf126PVDtjeAD8wCc_TiDfer04iydrW1AjUicH4oVHbs12Q@mail.gmail.com>
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

On Wed, Sep 16, 2020 at 9:25 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 15, 2020 at 11:49:12PM +0300, Oded Gabbay wrote:
> > On Tue, Sep 15, 2020 at 11:42 PM David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Oded Gabbay <oded.gabbay@gmail.com>
> > > Date: Tue, 15 Sep 2020 20:10:08 +0300
> > >
> > > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > > into the habanalabs driver.
> > > >
> > > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > > are in that patch's commit message.
> > > >
> > > > Link to v2 cover letter:
> > > > https://lkml.org/lkml/2020/9/12/201
> > >
> > > I agree with Jakub, this driver definitely can't go-in as it is currently
> > > structured and designed.
> > Why is that ?
> > Can you please point to the things that bother you or not working correctly?
> > I can't really fix the driver if I don't know what's wrong.
> >
> > In addition, please read my reply to Jakub with the explanation of why
> > we designed this driver as is.
> >
> > And because of the RDMA'ness of it, the RDMA
> > > folks have to be CC:'d and have a chance to review this.
> > As I said to Jakub, the driver doesn't use the RDMA infrastructure in
> > the kernel and we can't connect to it due to the lack of H/W support
> > we have
> > Therefore, I don't see why we need to CC linux-rdma.
> > I understood why Greg asked me to CC you because we do connect to the
> > netdev and standard eth infrastructure, but regarding the RDMA, it's
> > not really the same.
>
> Ok, to do this "right" it needs to be split up into separate drivers,
> hopefully using the "virtual bus" code that some day Intel will resubmit
> again that will solve this issue.
Hi Greg,
Can I suggest an alternative for the short/medium term ?

In an earlier email, Jakub said:
"Is it not possible to move the files and still build them into a single
module?"

I thought maybe that's a good way to progress here ?
First, split the content to Ethernet and RDMA.
Then move the Ethernet part to drivers/net but build it as part of
habanalabs.ko.
Regarding the RDMA code, upstream/review it in a different patch-set
(maybe they will want me to put the files elsewhere).

What do you think ?

>
> That will allow you to put the network driver portion in drivers/net/
> and split the code up into the proper different pieces easier.
>
> I recommend grabbing the virtual bus code from the archives and looking
> at that for how this can be done.  Now that you are part of Intel, I'm
> sure that the internal-Intel-Linux-kernel-review-process can kick in and
> those developers can help you out.  If not, let me know, so I can go
> kick them :)
>
> As for the RDMA stuff, yeah, you should look at the current RDMA
> interfaces and verify that those really do not work for you here, and
> then document why that is in your patch submission.
ok, will do that.

Thanks,
Oded
>
> thanks,
>
> greg k-h
