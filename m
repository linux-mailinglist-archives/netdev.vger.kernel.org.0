Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E782CFFF5
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbgLFAd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:33:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgLFAd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:33:26 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 862E2C0613D4
        for <netdev@vger.kernel.org>; Sat,  5 Dec 2020 16:32:46 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id k4so9870406edl.0
        for <netdev@vger.kernel.org>; Sat, 05 Dec 2020 16:32:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gsJTnuBIKurvy5/BWkf4XzEJ7IPXfR3rghfxKMIdv5A=;
        b=XJKdb70pzE/zlzt49Fah0BHTuoQI/1gp0ANorpuSlhGDe5lvKDxwj1nV++iduDrHZO
         5egN+IeYeOoixDnwHTi+ErwlWJ+Vl+DXaKxjuuG3F/u9C+kgikt9jpCoUPiQQ1mk0GIt
         pBAXWYgQJ1gEgASRAC53JsKxZYF+LILb7PRheMEEHWH1ulEM1oA7Rc1amBxJiy/fw4JZ
         neU2YHasQLwYOvA7dz6DDjUocijcqE5kYh3+tTwKzYMoSu3Q35cXR08a5d22e4q4of7L
         ULTmY6TebcajaaxeAZrLRPeqJTkHVyBHaJyFwu6L6IYSGC272/5HyZK8l8KYXknxFPxa
         8P7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gsJTnuBIKurvy5/BWkf4XzEJ7IPXfR3rghfxKMIdv5A=;
        b=jzTbO72OFFwSsN8Vkm7H8Z9qisXeXZp8zF16um+1FS3f8a0ssmzMOfteUBZa58E/eL
         PZwpXSq9RIWxYYnVm2zR79+oEEuWyypAAg8SIRnW8UMM//vT3Wf66R2g8/i5/lV459DT
         UJObhwJK7VX40hN+BQssSlUJkJ74o2miO80BdMpGMCVbzLUUZE//JH53dTs1s1WYhwwm
         +lYXc/vrPUzluIX19dc4AJw+g+s4Qt7U0+qWuPzjPlMapnvWRMBvT1sfza3tOp2soqJB
         3hAzct4yo9WNLVt0a5YAzy6GRjiluI+8l3zSqDL6DdtZjKc1BhI6J6fxSUQscXrNXo2D
         VTvA==
X-Gm-Message-State: AOAM532O+ysCwCI3Y8BKbwE0yTP86YcOX+W+ud44AlpEKqLbWGtUwUxH
        gRbNJ3e0DX8u0j+dB+0286FycZD/3ff9KZYRUMhvPQ==
X-Google-Smtp-Source: ABdhPJyfTHBvHCXuS7GMkDJKmo6ZL65D889ZDN8Fij1tzRHq9IWIaeeueUQ0KTEr9lBaBh47xr9YPay4K9BanZOMcCg=
X-Received: by 2002:a50:e0ce:: with SMTP id j14mr14231534edl.18.1607214765241;
 Sat, 05 Dec 2020 16:32:45 -0800 (PST)
MIME-Version: 1.0
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <a24b3044-1379-6331-c171-be8d95f21353@gmail.com>
In-Reply-To: <a24b3044-1379-6331-c171-be8d95f21353@gmail.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Sat, 5 Dec 2020 16:32:41 -0800
Message-ID: <CAPcyv4iM=_MhhpKKA9ihWAq_c43kKjRwGKzhvKEYHYJ+FiAVJA@mail.gmail.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, alsa-devel@alsa-project.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 5, 2020 at 4:24 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 12/2/20 5:54 PM, Dan Williams wrote:
> > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> > index 8d7001712062..040be48ce046 100644
> > --- a/drivers/base/Kconfig
> > +++ b/drivers/base/Kconfig
> > @@ -1,6 +1,9 @@
> >  # SPDX-License-Identifier: GPL-2.0
> >  menu "Generic Driver Options"
> >
> > +config AUXILIARY_BUS
> > +     bool
> > +
> >  config UEVENT_HELPER
> >       bool "Support for uevent helper"
> >       help
>
> Missing a description and without it does not appear in menuconfig or in
> the config file.
>
> Could use a blurb in the help as well.

It doesn't have a description or help because it is a select-only
symbol, but a comment to that effect and a pointer to the
documentation would help.
