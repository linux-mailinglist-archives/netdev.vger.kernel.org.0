Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791D42A847D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 18:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730973AbgKERNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 12:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgKERNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 12:13:05 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93614C0613D2
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 09:13:05 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id q3so2055579edr.12
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 09:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1OVEId5NbPuZhwiD2RAxt7P3TFnewmmafINvYAxM9CY=;
        b=LrZHWpUiBijvD4dqiTIysN1yWqAONqYpkr1vF2nMOS+hzduZIeM9hIf9ooQe26IE8x
         Zmen5HnkiRYPdRkczOgG7PHViRULQgRSh24HzkkD8TnlHfrOHC4X8yhXpNpNG/ORWYm+
         8wzyGEQEYw5xzt1fv37sZ7AzR4NgvrT5AI/st4t6GIPGqYX4ujx5Od/iswmS/n1ZkGFi
         8ArvQwe1MlI/iMZPOw7fltm7snk1o3RERYoVlgdlK3w0d6tT17fuPenDn1EL1jlT7c7c
         xPw0cBd21Pvskls1uPUF/wiUX/ZxaGdUHaYJf0LBuCctPWOozxR9FnzbhilazLwlxX+o
         3kUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1OVEId5NbPuZhwiD2RAxt7P3TFnewmmafINvYAxM9CY=;
        b=HQXgGCX+WZ8eYDC+Zdb2KHOoI5u5WOzk2F7Y4VUiuQlDhclDGE40CIT6kC2DnnGtXj
         HwNOuhis82o6xgNjt3oHh6Q/aJylGw50nWEFTGAWRy+c10ownsNjLFKjCSviQf4Nb58o
         XUQKArlqL7NlZeUUfK14jkCA4TJ4VXCHBvw09mTVwGFlR/SqQBUqG4YNmsldmxyfx1Pf
         vKq9tb8LHFvTy74r2Uo5jDnHzIRI4iwsmLB7Akdo4PghaBARAh+3OGzqnRq/Gj5nVRIc
         SyT1RtOgtW05gMY6gaPrbB8JkFYu1x+EIV1igCpmAe3XPoKznikD5TV4Of+u2lyuRJBU
         KK8w==
X-Gm-Message-State: AOAM5331gImkZ1Ji0zWkplCwuqQBj9eOzckhxS78xspa+ihmrQVoRydq
        6HkYZm9rkaxfiBrJ2eMnoRniEo7KBv6WTwIgiWErZw==
X-Google-Smtp-Source: ABdhPJxR0K2Ny/la8w6wudT2r17AxOkb0bU7Tr0zLMl7ek9oU/t/pYtRlPYcNtxXSTQpX0bbGX3l0C3ZdfAY3A/HaRk=
X-Received: by 2002:aa7:d843:: with SMTP id f3mr3709824eds.354.1604596382315;
 Thu, 05 Nov 2020 09:13:02 -0800 (PST)
MIME-Version: 1.0
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com> <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <20201105094719.GQ5429@unreal>
In-Reply-To: <20201105094719.GQ5429@unreal>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 5 Nov 2020 09:12:51 -0800
Message-ID: <CAPcyv4hmBhkFjSA2Q_p=Ss40CLFs86N7FugJOpq=sZ-NigoSRw@mail.gmail.com>
Subject: Re: [PATCH v3 01/10] Add auxiliary bus support
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Dave Ertman <david.m.ertman@intel.com>,
        alsa-devel@alsa-project.org, Takashi Iwai <tiwai@suse.de>,
        Mark Brown <broonie@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Patil, Kiran" <kiran.patil@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 5, 2020 at 1:47 AM Leon Romanovsky <leonro@nvidia.com> wrote:
>
> On Thu, Nov 05, 2020 at 01:19:09AM -0800, Dan Williams wrote:
> > Some doc fixups, and minor code feedback. Otherwise looks good to me.
> >
> > On Thu, Oct 22, 2020 at 5:35 PM Dave Ertman <david.m.ertman@intel.com> wrote:
> > >
>
> <...>
>
> > >
> > > +config AUXILIARY_BUS
> > > +       bool
> >
> > tristate? Unless you need non-exported symbols, might as well let this
> > be a module.
>
> I asked it to be "bool", because bus as a module is an invitation for
> a disaster. For example if I compile-in mlx5 which is based on this bus,
> and won't add auxiliary_bus as a module to initramfs, the system won't boot.

Something is broken if module dependencies don't arrange for
auxiliary_bus.ko to be added to the initramfs automatically, but yes,
it is another degree of freedom for something to go wrong if you build
the initramfs by hand.

>
> <...>
>
> >
> > Per above SPDX is v2 only, so...
>
> Isn't it default for the Linux kernel?

SPDX eliminated the need to guess a default, and MODULE_LICENSE("GPL")
implies the "or later" language. The only default assumption is that
the license is GPL v2 compatible, those possibilities are myriad, but
v2-only is the first preference.
