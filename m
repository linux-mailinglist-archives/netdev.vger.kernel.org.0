Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757402A8815
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731744AbgKEU17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgKEU17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:27:59 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E56C0613D3
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 12:27:58 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id ay21so2978683edb.2
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 12:27:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4tO08g/mdJrUnRp5xmIkC4E/sM1L+cB4NfZ88sr/eLY=;
        b=0Gexu+U6183ptqb2s+FG8/LMY6pXKXn7N3ue80u0iYvQLt+J1c2jziWIJNZODieL9I
         fjudyFeW2Y8vrOoj/uVLGT946g16HQe9FL8wBkxCdGiWweZU2yE2/V2gb4Bqcm8BYY+/
         ns6dNvrguGQ8l6UlwQ19zwKV0nsKkWa27hj/znxgNjAWTwoklQ1nLt+8YIkOsZdmkPvC
         3q3H5/w0tJ3ggiRN/S0VmI7w6ofXq+u9NWrITHIzdaNW9JjSbueu3JGkhuCe0FDdmPbB
         99034gC0Dhmp0LfcxNOoxcJnDRGv8mIiyor9veTUHkdTOiqrRpVnSG0GX3EAWjathtJi
         9AwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4tO08g/mdJrUnRp5xmIkC4E/sM1L+cB4NfZ88sr/eLY=;
        b=I/2prYsOnooc7a2X5fBbjeYSp32p3VAnJ/jDziyyeHa4DuZocRkcAjV5rAG2tMEyv9
         GX9Ac2LnZzQubcEnpHjdnQyeMsSfVbLCRqAS4yTStKN2wFihtS2KA1+bWLH3nCYDqtRa
         GyDKniNQIu0Zztl6i7X3trbv1ffGve6AYIsEFsTNvbikG13ltHq0Z0E9m/QN2WXfD7ww
         CJ8rrBVVexkCL9GQFx1ZaAKLMPzzaSHn8r+Wjn3xvwuM/3Tzx5u7rIF8CSsqt1JaeLzh
         VjTgcp5hUwgPYtYVdI6hy1hXwNQoDOMI2RQiytUtSeFBa8Hq3J3ldZZ4z0TM/2nIQvPP
         u3jg==
X-Gm-Message-State: AOAM533KMm4gtcwD3PkTK8fsesPTgr1Si2oP0kbkXjOhxfjSZHuiIiwc
        WySAHLRp1b46CFaVppzGrFqCgBLXOYM9uio5i7y6DQ==
X-Google-Smtp-Source: ABdhPJxZyMj5TW7rvvLgOn3hpEvUsDtY61IBF+U1P3Dju0RxQi9OL2cMh7kULFE2kxodEX2WW11HNleHVODps7fifRk=
X-Received: by 2002:a05:6402:b35:: with SMTP id bo21mr4691836edb.52.1604608077519;
 Thu, 05 Nov 2020 12:27:57 -0800 (PST)
MIME-Version: 1.0
References: <20201023003338.1285642-1-david.m.ertman@intel.com>
 <20201023003338.1285642-2-david.m.ertman@intel.com> <CAPcyv4i9s=CsO5VJOhPnS77K=bD0LTQ8TUAbhLd+0OmyU8YQ3g@mail.gmail.com>
 <20201105094719.GQ5429@unreal> <CAPcyv4hmBhkFjSA2Q_p=Ss40CLFs86N7FugJOpq=sZ-NigoSRw@mail.gmail.com>
 <20201105193009.GA5475@unreal>
In-Reply-To: <20201105193009.GA5475@unreal>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 5 Nov 2020 12:27:46 -0800
Message-ID: <CAPcyv4j9CiOnxpzcpje-AvdX=EbzUVTGBqiC2AyhLv8rP12sVg@mail.gmail.com>
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

On Thu, Nov 5, 2020 at 11:30 AM Leon Romanovsky <leonro@nvidia.com> wrote:
>
> On Thu, Nov 05, 2020 at 09:12:51AM -0800, Dan Williams wrote:
> > On Thu, Nov 5, 2020 at 1:47 AM Leon Romanovsky <leonro@nvidia.com> wrote:
> > >
> > > On Thu, Nov 05, 2020 at 01:19:09AM -0800, Dan Williams wrote:
> > > > Some doc fixups, and minor code feedback. Otherwise looks good to me.
> > > >
> > > > On Thu, Oct 22, 2020 at 5:35 PM Dave Ertman <david.m.ertman@intel.com> wrote:
> > > > >
> > >
> > > <...>
> > >
> > > > >
> > > > > +config AUXILIARY_BUS
> > > > > +       bool
> > > >
> > > > tristate? Unless you need non-exported symbols, might as well let this
> > > > be a module.
> > >
> > > I asked it to be "bool", because bus as a module is an invitation for
> > > a disaster. For example if I compile-in mlx5 which is based on this bus,
> > > and won't add auxiliary_bus as a module to initramfs, the system won't boot.
> >
> > Something is broken if module dependencies don't arrange for
> > auxiliary_bus.ko to be added to the initramfs automatically, but yes,
> > it is another degree of freedom for something to go wrong if you build
> > the initramfs by hand.
>
> And this is something that I would like to avoid for now.

Fair enough.

>
> >
> > >
> > > <...>
> > >
> > > >
> > > > Per above SPDX is v2 only, so...
> > >
> > > Isn't it default for the Linux kernel?
> >
> > SPDX eliminated the need to guess a default, and MODULE_LICENSE("GPL")
> > implies the "or later" language. The only default assumption is that
> > the license is GPL v2 compatible, those possibilities are myriad, but
> > v2-only is the first preference.
>
> I mean that plain GPL == GPL v2 in the kernel.

You are right, I was wrong.
