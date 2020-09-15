Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F8F26AF77
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgIOVVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:21:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbgIOVUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 17:20:43 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA44DC061788;
        Tue, 15 Sep 2020 14:20:42 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id a3so5587617oib.4;
        Tue, 15 Sep 2020 14:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Kgwhp6oomGrG//FJ4IaZ4jY90heMqg4iryVxsn2sPAo=;
        b=aSgas9/1Jvbmf8th0cpGRYHBLlYUY9njpmeNTsl2l8ID1RnrSHfsTyAEw4VU++XZPI
         ImIea+lzlqDNuNZ5gGOoAkBIuL/aE/TZ3eUaM2kOSfxXwghpRZdbMZNnNjoSZ5sHLnZb
         4XA89+T6MjwZMpNuewprx05dEu1od9R8JRzBDyLbWzZIV0vowujkcnR93FpU82hMAfeZ
         J1DNkVnFAyfdwGdv7MtmtYMRGI2Hm/Mt8fBY5bcpbRF8F+jgBOpmlxZI2Qfl7L8aWKqQ
         /Ds6Q3S6oA+Ts0CJO1aPvAejtcVvFgB+LA1kp0H5v30L9BWhLamimB2f33vmNI5lsKZF
         blFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Kgwhp6oomGrG//FJ4IaZ4jY90heMqg4iryVxsn2sPAo=;
        b=oWWNEbitlcnAA7KJSYT/NjU38pTWdj+EzkW4pTJHFKOlYtIrqRVw96s/b2TU+qTjoh
         dFBVvJjXG8RF0UVkjIZmI+uZwXELMkTu2M4jJ/AUsy7CixcG8dZO10ZAkF2hVsMjJvzq
         BRPairYzdcLnkjOF8eGXLZUAOdVuAfLg/CvqoOs4t37fW7Jqzw6wwjzRQM2uehuODE7s
         9ROvqBbqxQg8ElAkHR4vhjMPgRUnx4gqzAkuSeI4RUded31wn/rH9wDCsQbKgoqXjMRH
         4sUNtEwDNCmgnC7irJIktp8Zt/oNqRhwEMY74zF4+GyUGzOlpGBvCXaDoELSj3VL0DdS
         UEXw==
X-Gm-Message-State: AOAM53377k1UNuvAG1IVGOY+1TigrSu9fA2pAERGVtnlcite062ewT3c
        uw8mVUPze1E4ARHFTV0WGgzXoTlsoV6ZhdX2Atc=
X-Google-Smtp-Source: ABdhPJxxLeU9sU7zfpVQXzYAXAbWMv5zUuaU0G05yYqQVc4aUYXKQd7yA2WsSDTmz5R8Oo5AZ8EYE3evic2VrSo/3dg=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr1006436oij.154.1600204842036;
 Tue, 15 Sep 2020 14:20:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com> <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Wed, 16 Sep 2020 00:20:12 +0300
Message-ID: <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 16, 2020 at 12:04 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 15 Sep 2020 23:46:58 +0300 Oded Gabbay wrote:
> > On Tue, Sep 15, 2020 at 11:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Tue, 15 Sep 2020 20:10:08 +0300 Oded Gabbay wrote:
> > > > Hello,
> > > >
> > > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > > into the habanalabs driver.
> > > >
> > > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > > are in that patch's commit message.
> > >
> > > You keep reposting this, yet this SDK shim^W^W driver is still living in
> > > drivers/misc. If you want to make it look like a NIC, the code belongs
> > > where NIC drivers are.
> > >
> > > Then again, is it a NIC? Why do you have those custom IOCTLs? That's far
> > > from normal.
> >
> > I'm sorry but from your question it seems as if you didn't read my
> > cover letter at all, as I took great lengths in explaining exactly
> > what our device is and why we use custom IOCTLs.
> > TL;DR
> > We have an accelerator for deep learning (GAUDI) which uses RDMA as
> > infrastructure for communication between multiple accelerators. Same
> > as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> > The RDMA implementation we did does NOT support some basic RDMA
> > IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> > library or to connect to the rdma infrastructure in the kernel. We
> > wanted to do it but when we analyzed it, we saw we wouldn't be able to
> > support basic stuff and therefore we had to revert to our IOCTLs.
> > To sum it up, because our NIC is used for intra-communication, we
> > don't expose nor intend users to use it as a NIC per-se. However, to
> > be able to get statistics and manage them in a standard way, and
> > support control plane over Ethernet, we do register each port to the
> > net subsystem (i.e. create netdev per port).
> >
> > I hope this short summary explains this better.
>
> I read your cover letter. Networking drivers don't get to define random
> IOCTLs as they please. You have to take that part out of the "NIC"
> driver.

The IOCTLs are not for the Ethernet part. They are strictly for the
RDMA operations. RDMA drivers also have IOCTLs as interfaces in the
drivers/infiniband area, so I don't think I'm doing something
different here.
And my driver is not networking. It is an accelerator which has some
network ports.
btw, this is only a single new IOCTL call. The rest of the IOCTLs are
already upstreamed and are for the rest of the ASIC's compute
functionality. What I'm trying to say is that it's very common to
define IOCTLs for accelerators.

>
> > As per your request that this code lives in the net subsystem, I think
> > that will make it only more complicated and hard to upstream and
> > maintain.
> > I see there are other examples (e.g. sgi-xp) that contain networking
> > driver code in misc so I don't understand this objection.
>
> The maintenance structure and CI systems for the kernel depend on the
> directory layout. If you don't understand that I don't know how to help
> you.
I completely understand but you didn't answer my question. How come
there are drivers which create netdev objects, and specifically sgi-xp
in misc (but I also saw it in usb drivers) that live outside
drivers/net ? Why doesn't your request apply to them as well ?
When we wrote the code, we saw those examples and therefore assumed it was fine.

>
> > > Please make sure to CC linux-rdma. You clearly stated that the device
> > > does RDMA-like transfers.
> >
> > We don't use the RDMA infrastructure in the kernel and we can't
> > connect to it due to the lack of H/W support we have so I don't see
> > why we need to CC linux-rdma.
>
> You have it backward. You don't get to pick and choose which parts of
> the infrastructure you use, and therefore who reviews your drivers.
> The device uses RDMA under the hood so Linux RDMA experts must very
> much be okay with it getting merged. That's how we ensure Linux
> interfaces are consistent and good quality.

I understand your point of view but If my H/W doesn't support the
basic requirements of the RDMA infrastructure and interfaces, then
really there is nothing I can do about it. I can't use them.
I wish I was able to use that infrastructure but I can't. That's why
we wrote the IOCTLs in our accelerator driver.

Thanks,
Oded
