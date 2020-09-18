Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB326FC29
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgIRMKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgIRMKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:10:33 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC5DC06174A;
        Fri, 18 Sep 2020 05:10:33 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id c13so6711506oiy.6;
        Fri, 18 Sep 2020 05:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYs4bLPxf5U2CwN351Fz3pz8c3JiFvsCwPJ6TwddRl4=;
        b=pFwgS1qcP5TdlQh/DggXtyCercGMIyQsPcGNK6psa0D/K1kVTHV6WumorJe2Jh/MrX
         UAHlrMuM63qB3vkYBJMijQrbhco9qUaalqgQjqe41ymFtE9dT94vieD+aivqr2te1pto
         NS3SPsIdAKo56Eu4TmdsdH04eTmXaPPLAj+r6jVStWcL3+UH3d++a+WtyNpQueZdUrQC
         6hVssYPRrT3ezGLazrcpllkU5Bel/ubWwPJrYdavkTd094cJgb5JRq8Zp5EBfgmBjzj5
         llcAxwZ8y/4SF8EWnbpx3mIMRfafi18LBKizTigzxZPITpwimqj7N5d4Tas6SRmhZnAD
         hUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYs4bLPxf5U2CwN351Fz3pz8c3JiFvsCwPJ6TwddRl4=;
        b=b73wk0RzWbMymfCiCpvgn7DCAiUg+vqXeENLMMGSiGlmcvGEGLHXJoxi/CMFtpiNqB
         yBFVIsDKbNcaR52F69Dd/FVI0V6vPZZdinJxdPeZDwf7TRMLXaJPscFtymabic4SUmma
         RU4Gw38PbfoQmDEMFwgJm7y9Qz5JneCb4BkvFwQtM7Nnc7gLXgmYaD+JLgBnQGYNXwPT
         we+CiEHH/o+25Hk+YIPVPf9Rgpj/vIPAk1U3I/c+NeODGjG74dbXYLd86uaUY35tS2kQ
         R97x8GwtVbfwxKvbMpCA7c7Oa/wWFifkw8BCdbHGFB1zAPi1Y0PU9VQLum7dAuD8Flj2
         fsjQ==
X-Gm-Message-State: AOAM532GNyM8WwuSQju0gxhcx0Mal4EmFnfMXqhHMv27JqbsW/2JFuhu
        Iz1oxyOOs7XAb175dTqHRRC23AoEFvsJUxkyyG8=
X-Google-Smtp-Source: ABdhPJxNxx2D7fuNrVCtnNmgpSYF6DQqlUBcTKoMe4qovKAbwwcQNRKtzTN2TQjwjDDlutUE7S31384fyvqr9q/Ye9M=
X-Received: by 2002:a05:6808:a05:: with SMTP id n5mr9364376oij.154.1600431032320;
 Fri, 18 Sep 2020 05:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200915171022.10561-1-oded.gabbay@gmail.com> <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca> <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
In-Reply-To: <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
From:   Oded Gabbay <oded.gabbay@gmail.com>
Date:   Fri, 18 Sep 2020 15:10:03 +0300
Message-ID: <CAFCwf12B4vCCwmfA7+VTUYUgJ9EHAtvg6F0bMYnsSCUBST+aWA@mail.gmail.com>
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
To:     izur@habana.ai
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org, Gal Pressman <galpress@amazon.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 2:36 PM Gal Pressman <galpress@amazon.com> wrote:
>
> On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> >> infrastructure for communication between multiple accelerators. Same
> >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> >> The RDMA implementation we did does NOT support some basic RDMA
> >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> >> library or to connect to the rdma infrastructure in the kernel.
> >
> > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > you can't add random device offloads as IOCTL to nedevs.
> >
> > RDMA is the proper home for all the networking offloads that don't fit
> > into netdev.
> >
> > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > all. I'm sure this can too.
>
> Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> was suggested to go through the vfio subsystem instead.
>
> I think this comes back to the discussion we had when EFA was upstreamed, which
> is what's the bar to get accepted to the RDMA subsystem.
> IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
>
> Does GAUDI fit these requirements? If not, should it be in a different subsystem
> or should we open the "what qualifies as an RDMA device" question again?

Hi Itay,
Please see the above comments/questions.
Thanks,
Oded
