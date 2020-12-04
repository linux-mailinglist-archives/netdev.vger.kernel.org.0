Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2740F2CE6A1
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 04:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgLDDhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 22:37:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbgLDDhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 22:37:52 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B125C061A51
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 19:37:11 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id c7so4388725edv.6
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 19:37:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H7q4vopEbHCewQ+qUf3Z4+KiH74FFIhB3Uhp8jwbeRs=;
        b=h6lJHRIwp2kfx3tSOHVwfn7ZLGG5UVFD8MKBKp7vUUe6bQP9aSUb2KT6tfLpyXgiUe
         uO6sK9Zr6nxXuBdVBLOzPIc/ctgN7f8WXi3+IqA+i/l4PUf34JFoUG1MgvdHxb83NkfG
         992rzEGAkOKMrn7Zk5BdbZcsSSV0ZoYaMre+DOnrBNpMGrfyzstujfH3254xsLfR4B7o
         NVQrrDevjQHrIX4aoLuzXQrXRgPxWOtr4VWhBU4Frntmabksc0kVn0+NFWDqUXvoLt3v
         2+74tWrg/Ib+xO/tsR5jl9suTNwsI9fqZibS8HovKAsGg7JFCBbQoUNrxcvtwNjJvDg9
         SazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H7q4vopEbHCewQ+qUf3Z4+KiH74FFIhB3Uhp8jwbeRs=;
        b=RPX7f/lJrFPw9m3JwvioQWIiI8DnYQrWAdReeTL1/yoH06vnDz/1+vpPr/jjL3rXco
         Fnz9qp0mcPwzGQR1VShEb7MbSPz5xVugKEhk0dom37Ny6JYwva+jrZgfZeBV20Wg2uPF
         aHE0ioCYiqFJ6MrfiNy54lh8LCAcE6ufcVInmK/ueV7bzBc0LRvSu4VZLRvm3jD284mS
         iy6Py5+BrjdMIg7nWU5+nOYnGLFSvaAxKDhKu+l/IrTjMyxwftX3gOQUXxg6Sae5zHzw
         PAYe9SMNsN3QyvDhRm8yCOa/7EDwC7v7XxYDtgnM4W4WSo5GQuYmeUxbjje+iDLKD0x5
         maLw==
X-Gm-Message-State: AOAM532KyOXSD2rVdAujcpUaSHlTN4ejRWGriAM8MDAwGukQ2lstpLw2
        cU6XOfr3MkgRDVlwuAKNPTDCQUZC756DjJz7jxMNzOwyiwI=
X-Google-Smtp-Source: ABdhPJypzF/zxqPx2JjCtFUbZXdp8DAB6CgTOr6BBeH65H/vxbjhDErMw8S4HuqSooRtOzznLRIL1KkQvJFsw0MnHHY=
X-Received: by 2002:a50:8a44:: with SMTP id i62mr2924285edi.97.1607053030239;
 Thu, 03 Dec 2020 19:37:10 -0800 (PST)
MIME-Version: 1.0
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
 <X8j+8DRrPeXBaTA7@kroah.com> <20201204023357.GA1337723@nvidia.com>
In-Reply-To: <20201204023357.GA1337723@nvidia.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Thu, 3 Dec 2020 19:37:06 -0800
Message-ID: <CAPcyv4iDr9RUK_F52mNuO=+ZuFtD4PTpB5QzKA4fnF_RaRoR1w@mail.gmail.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 6:34 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Dec 03, 2020 at 04:06:24PM +0100, Greg KH wrote:
>
> > > ...for all the independent drivers to have a common commit baseline. It
> > > is not there yet pending Greg's Ack.
> >
> > I have been trying to carve out some time to review this.  At my initial
> > glance, I still have objections, so please, give me a few more days to
> > get this done...
>
> There are still several more days till the merge window, but I am
> going to ask Leon to get the mlx5 series, and this version of the
> auxbus patch it depends on, into linux-next with the intention to
> forward it to Linus if there are no substantive comments.
>
> Regardless of fault or reason this whole 1.5 year odyssey seems to have
> brought misery to everyone involved and it really is time to move on.
>
> Leon and his team did a good deed 6 weeks ago to quickly turn around
> and build another user example. For their efforts they have been
> rewarded with major merge conflicts and alot of delayed work due to
> the invasive nature of the mlx5 changes. To continue to push this out
> is disrespectful to him and his team's efforts.
>
> A major part of my time as RDMA maintainer has been to bring things
> away from vendor trees and into a common opensource community.  Intel
> shipping a large out of tree RDMA driver and abandoning their intree
> driver is really harmful. This auxbus is a substantial blocker to them
> normalizing their operations, thus I view it as important to
> resolve. Even after this it is going to take a long time and alot of
> effort to review their new RDMA driver.

When you have 3 independent driver teams (mlx5, i40e, sof) across 2
companies (NVIDIA and Intel), and multiple subsystem maintainers with
a positive track record of upstream engagement all agreeing on a piece
of infrastructure, I struggle to imagine a stronger case for merging.
I did get word of a fixup needed in the shutdown code, I'll get that
folded. Then, barring a concrete objection, I'll look to publish a
commit that others can pull in to start building soak time in -next
this time tomorrow.
