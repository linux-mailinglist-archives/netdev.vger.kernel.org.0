Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92CA2BB1DD
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 18:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgKTR6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 12:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727215AbgKTR63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 12:58:29 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA695C0613CF;
        Fri, 20 Nov 2020 09:58:27 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id z14so7556509ilm.10;
        Fri, 20 Nov 2020 09:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zABshzHwq1JQeEQYxU6E8eN0h9D7A0YzJDlMCVB4nKc=;
        b=cttfeaajCF9PSuHOJg9QOydU3sroEwOZ5sj/qWJC5Spp427HdajPSrzwi58Nrca7Xt
         6N/GlGxPiGJ6pV9plCYJ0zD1HBP8PtZ9DOJ+AOnuLtel7rHcBl61U5LQ+EDM8O88rpUy
         cOW6CWXL25jLj/55jNlYKZPAj6XnOPvK+h4hEO4lrTdi7EahL4Xo1SFfbLMq/I4N9yba
         PqQ1FbxDP3I8MbKJ0mBU1YtGJ31LJULd8p8QWMhASxbUE4xOGZu5h82Iy+bp6QFSGChm
         Yh2oAZqIC6pGC9wnuut518r0Fm5jjFxJHCzzC4wlwwOICGg25FJpaqMHsEHxsdGW1xe0
         K5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zABshzHwq1JQeEQYxU6E8eN0h9D7A0YzJDlMCVB4nKc=;
        b=EW7OEQUZoozm581sgVJ7ueJMX8aKhifrRhYzitfr43G10AVMnNjilmW0AxoiY5vi4g
         rJL8zIy06rKnEa3gVgfJkpsvA7tI+k2nqoqAQCh5yMN9rBg/P4xo1i+8NZNdZaa9jnHy
         vq7mGs6NUESkgtykPs7qB9g5XxIX1fG3GChNW667o52XEZPeK+WmPCUr1UnOOGgFOmnE
         eg9O0xfffzZ/h8VvnKwWGRayR0Wqalvd9MTNTNjDshHqtCKmgvVcfPVcckx1ONhOMTz7
         pVViEICaAr8MddylRwOP3FEls0b1zv2Rqwse/+kqYH5GNA7y8LpmNUlOoG31dqb0HpPc
         RAgg==
X-Gm-Message-State: AOAM533LofMWqDwnxcUH1QoXeaIlTTwbJs7Q29teC3jiPgC+GRMpcI/e
        gPFmK5b/KS/FUh5kJxavQFFu9Kth2PJS2YtX/06VjJ0tyc0=
X-Google-Smtp-Source: ABdhPJx70cbvvEFgQvjxgi5Xe678tHAs6JctoKL/yOpqqiwAcWl0NSWzh3iYnQfj1/tLQ0XQe/9DvMlgfX4r7jpbU64=
X-Received: by 2002:a05:6e02:120f:: with SMTP id a15mr23968135ilq.97.1605895107271;
 Fri, 20 Nov 2020 09:58:27 -0800 (PST)
MIME-Version: 1.0
References: <20201112192424.2742-1-parav@nvidia.com> <20201116145226.27b30b1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cdd576ebad038a3a9801e7017b7794e061e3ddcc.camel@kernel.org>
 <20201116175804.15db0b67@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43229F23C101AFBCD2971534DCE20@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20201117091120.0c933a4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201117184954.GV917484@nvidia.com> <20201118181423.28f8090e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <96e59cf0-1423-64af-1da9-bd740b393fa8@gmail.com> <20201119172930.11ab9e68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119172930.11ab9e68@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 20 Nov 2020 09:58:16 -0800
Message-ID: <CAKgT0Uf4i9hrq6Z4dx03sv_ubVpZwKm5Tiz+-UwJp38cTyZg+g@mail.gmail.com>
Subject: Re: [PATCH net-next 00/13] Add mlx5 subfunction support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 5:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 18 Nov 2020 21:35:29 -0700 David Ahern wrote:
> > On 11/18/20 7:14 PM, Jakub Kicinski wrote:
> > > On Tue, 17 Nov 2020 14:49:54 -0400 Jason Gunthorpe wrote:
> > >> On Tue, Nov 17, 2020 at 09:11:20AM -0800, Jakub Kicinski wrote:
> > >>
> > >>>> Just to refresh all our memory, we discussed and settled on the flow
> > >>>> in [2]; RFC [1] followed this discussion.
> > >>>>
> > >>>> vdpa tool of [3] can add one or more vdpa device(s) on top of already
> > >>>> spawned PF, VF, SF device.
> > >>>
> > >>> Nack for the networking part of that. It'd basically be VMDq.
> > >>
> > >> What are you NAK'ing?
> > >
> > > Spawning multiple netdevs from one device by slicing up its queues.
> >
> > Why do you object to that? Slicing up h/w resources for virtual what
> > ever has been common practice for a long time.
>
> My memory of the VMDq debate is hazy, let me rope in Alex into this.
> I believe the argument was that we should offload software constructs,
> not create HW-specific APIs which depend on HW availability and
> implementation. So the path we took was offloading macvlan.

I think it somewhat depends on the type of interface we are talking
about. What we were wanting to avoid was drivers spawning their own
unique VMDq netdevs and each having a different way of doing it. The
approach Intel went with was to use a MACVLAN offload to approach it.
Although I would imagine many would argue the approach is somewhat
dated and limiting since you cannot do many offloads on a MACVLAN
interface.

With the VDPA case I believe there is a set of predefined virtio
devices that are being emulated and presented so it isn't as if they
are creating a totally new interface for this.

What I would be interested in seeing is if there are any other vendors
that have reviewed this and sign off on this approach. What we don't
want to see is Nivida/Mellanox do this one way, then Broadcom or Intel
come along later and have yet another way of doing this. We need an
interface and feature set that will work for everyone in terms of how
this will look going forward.
