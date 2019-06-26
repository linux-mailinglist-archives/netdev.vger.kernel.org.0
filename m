Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E267F56CE3
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 16:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbfFZOxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 10:53:32 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:43597 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbfFZOxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 10:53:31 -0400
Received: by mail-oi1-f193.google.com with SMTP id w79so2127526oif.10
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 07:53:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q3A5zu6+vStHzn6+CZ7yc8OAsQveC6ssxpabFTxvpWQ=;
        b=fzUUnSQ5s1eGwkjHw37j35uo74Eayzuo0V0eQRIzwerYhQ1EHT//gNy35FwHwDs/2Y
         3jvgUCA3VyJe6vuueYfSqD0PAkBUPclCUsnepQW+3UUla4VkLlsqb2/CSvrYGKi78DWC
         zjZON/qbTuF0YHzbWbFkY91HTLwJHWdJALjyACzPT2Vr5JzJJfo97Oh2BRca6iCsuuJK
         +PZJgVwn+x6gO/LLx69T0ksIGKMOzgbhszUt/4fM4i5gspzMqrqlOaFy5mukSBWN0j1m
         sVSVGRRcA0UsCmgpcuchVPVeOsiw1fGpOimVd7CnH0gfb0afKTUUJLjnMlsg1HFpBkwJ
         T0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q3A5zu6+vStHzn6+CZ7yc8OAsQveC6ssxpabFTxvpWQ=;
        b=kQqrTWhjeynbAIi29riWGegfuG5Kj6Xjwrqdm4ifbNIRnSD2nVlLy+E0d0BrR8c2Cx
         uxL4+kVVjp9DgSod1E6AwUZxDDuHJbSzOoxNCOM3hALzh5wA+A5TYqsDnnwXHgNXSkVI
         +xpQShD2Vp+9TrtKDdfHizMKdk+qKg3ebBs91dK+mp3Y9a8GxvcEF1kOFntSCNZuGidO
         DCzz0vf3OkrD3tyC3YFh2fZ41r3gfzB2G5MaUkR4KVuMdZMcInCl9YrtMbuqw00tedvV
         K+hZTgHsYqhkzLZEY+Ric4wxhRcBEFEvBcpsH3QCJo4/6/kqBUWO2tlX9UHAQkJiyRJI
         Tt2g==
X-Gm-Message-State: APjAAAVSSuNjHwlSO2/TfXN35/ao5VANXjvzP0ORtxPCM20gAuYtjHcM
        qijC3Su5oGac//DXNpR1rto1SBJFforaHfUOKi8=
X-Google-Smtp-Source: APXvYqzUo9HPDOWOekLx4k6Cs40C6vzrf957PwlUdr9ROnyBX6TmuBfMNNYAwGGe987BtmXdDeT/VPAw/Nj+Nx1BaQk=
X-Received: by 2002:aca:5015:: with SMTP id e21mr2069378oib.159.1561560810728;
 Wed, 26 Jun 2019 07:53:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190620115108.5701-1-ap420073@gmail.com> <20190623.110737.1466794521532071350.davem@davemloft.net>
 <CAMArcTXWNY6WTjuBuUVxeb3c6dTqf8wf6sHFmNL5SvsGBbPqdQ@mail.gmail.com>
 <CAJieiUjri=-w2PqB9q5fEa=4jqkTWSfK0dUwnT7Cvxdo2sRRzg@mail.gmail.com>
 <CAMArcTWG-KLsmzrtQRGGmnUN31yz4UMqJ9FLyv3xNNPoXY_6=Q@mail.gmail.com> <CAJieiUjb6ev0spr6A00OoLsN5MFv32T+-Hn-wCsZePa5MvJV_g@mail.gmail.com>
In-Reply-To: <CAJieiUjb6ev0spr6A00OoLsN5MFv32T+-Hn-wCsZePa5MvJV_g@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 26 Jun 2019 23:53:19 +0900
Message-ID: <CAMArcTV6u8LFYDiHpe61_gEgKLNuQ6wvmFceDbzjnxeg06yg3A@mail.gmail.com>
Subject: Re: [PATCH net] vxlan: do not destroy fdb if register_netdevice() is failed
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 at 14:03, Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>
> On Tue, Jun 25, 2019 at 9:08 AM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > On Tue, 25 Jun 2019 at 13:12, Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
> > >
> >
> > Hi Roopa,
> >
> > Thank you for the review!
> >
> > > On Sun, Jun 23, 2019 at 7:18 PM Taehee Yoo <ap420073@gmail.com> wrote:
> > > >
> > > > On Mon, 24 Jun 2019 at 03:07, David Miller <davem@davemloft.net> wrote:
> > > > >
> > > >
> > > > Hi David,
> > > >
> > > > Thank you for the review!
> > > >
> > > > > From: Taehee Yoo <ap420073@gmail.com>
> > > > > Date: Thu, 20 Jun 2019 20:51:08 +0900
> > > > >
> > > > > > __vxlan_dev_create() destroys FDB using specific pointer which indicates
> > > > > > a fdb when error occurs.
> > > > > > But that pointer should not be used when register_netdevice() fails because
> > > > > > register_netdevice() internally destroys fdb when error occurs.
> > > > > >
> > > > > > In order to avoid un-registered dev's notification, fdb destroying routine
> > > > > > checks dev's register status before notification.
> > > > >
> > > > > Simply pass do_notify as false in this failure code path of __vxlan_dev_create(),
> > > > > thank you.
> > > >
> > > > Failure path of __vxlan_dev_create() can't handle do_notify in that case
> > > > because if register_netdevice() fails it internally calls
> > > > ->ndo_uninit() which is
> > > > vxlan_uninit().
> > > > vxlan_uninit() internally calls vxlan_fdb_delete_default() and it callls
> > > > vxlan_fdb_destroy().
> > > > do_notify of vxlan_fdb_destroy() in vxlan_fdb_delete_default() is always true.
> > > > So, failure path of __vxlan_dev_create() doesn't have any opportunity to
> > > > handle do_notify.
> > >
> > >
> > > I don't see register_netdevice calling ndo_uninit in case of all
> > > errors. In the case where it does not,
> > > does your patch leak the fdb entry ?.
> > >
> > > Wondering if we should just use vxlan_fdb_delete_default with a notify
> > > flag to delete the entry if exists.
> > > Will that help ?
> > >
> > > There is another commit that touched this code path:
> > > commit 6db9246871394b3a136cd52001a0763676563840
> > >
> > > Author: Petr Machata <petrm@mellanox.com>
> > > Date:   Tue Dec 18 13:16:00 2018 +0000
> > >     vxlan: Fix error path in __vxlan_dev_create()
> >
> > I have checked up failure path of register_netdevice().
> > Yes, this patch leaks fdb entry.
> > There are 3 failure cases in the register_netdevice().
> > A. error occurs before calling ->ndo_init().
> > it doesn't call ->ndo_uninit().
> > B. error occurs after calling ->ndo_init().
> > it calls ->ndo_uninit() and dev->reg_state is NETREG_UNINITIALIZED.
> > C. error occurs after registering netdev. it calls rollback_registered().
> > rollback_registered() internally calls ->ndo_uninit()
> > and dev->reg_state is NETREG_UNREGISTERING.
> >
> > A panic due to these problem could be fixed by using
> > vxlan_fdb_delete_default() with notify flag.
> > But notification problem could not be fixed clearly
> > because of the case C.
>
> yes, you are right. The notification issue still remains.
>
> >
> > I don't have clear solution for the case C.
> > Please let me know, if you have any good idea for fixing the case C.
>
> One option is a variant of fdb create. alloc the fdb  but don't assign
> it to the vxlan dev.
> __vxlan_dev_create
>              create fdb entry
>              register_netdevice
>              rtnl_configure_link
>              link fdb to vxlan
>              fdb notify
>
>
> Yet another option is moving fdb create after register_netdevice
> __vxlan_dev_create
>              register_netdevice
>              rtnl_configure_link
>              create fdb entry
>              fdb notify
> But if fdb create fails, user-space will see , NEWLINK + DELLINK when
> creating a vxlan device and that seems weird.

Thank you for suggesting ideas!

I think first one is very nice.
It's simple and clear.
So, I have been testing first one.
I will send a new patch after more testing.

Thank you again!
