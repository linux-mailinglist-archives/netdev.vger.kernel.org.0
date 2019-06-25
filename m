Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A7F55403
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 18:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728243AbfFYQI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 12:08:59 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:32931 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfFYQI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 12:08:58 -0400
Received: by mail-oi1-f195.google.com with SMTP id f80so12963527oib.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 09:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jA95Qh1yntfG34AOSZY5UOtyMZURQYp8MONEUbEV66A=;
        b=HgDIOt6qQTgaSmreTjm51zaSSvenITCVEMB/GtgVt7OXuWIUPL2yH/HA0gpDKCjq9V
         1vdIIAOblK6RW0V48U+lVE+u/KyUCd3RC0YGvJJx+oDV13I+xUq1YJLyPTeiVPk9r2nr
         5aCiaH/ijhirc0/AdePKS5Uc0IQJLMjYAlkjrrviXn+DV9SwmUNIfpa7wEvTxp3Uysay
         G6jbpa2iJsIr+cBBzyAPEqHp8ublctBKTGVWIMJWR5fulf+RY/Tdf3/0hfh49pIL9p72
         w4nUwSmh+F5h85tVTgKeXGRHyoRyAQaCT/5VxDobuZfVWxJ7IHqGYoWPyPfEvH+bOUNN
         5hZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jA95Qh1yntfG34AOSZY5UOtyMZURQYp8MONEUbEV66A=;
        b=WI/rp9M4vILTzkP7dhisbJWARrKs5ZUNsHDlv7iSenj8gvtQ4xOMlMSruXaGdZn+rS
         KjA2C0OeEs9p0qlmOUjMkinMZUUk5yN2PVrmkr+dK62jLPojybMYcyFlszNCWg69/uu1
         +2hurvNFC9eTsERQhEENKDiTt9GzEArlPrX4UIiNiVvOplWMHkNv4wnVbisS8G962Tkv
         rgJITVBnHSjfE5dH8jATwms4f4Jh/bYuAIi5T7dowcr3eDI3j5Wfk5NICjB7Q+af1JgV
         a+DdGDJz8rTs9zM2enS3tjnjnNOIXQAXVfA0/K/sEnwJoqtYH5SCfQk1VIS4d6kgECYw
         23EQ==
X-Gm-Message-State: APjAAAWFq99nKjroRf2KMY4QxJrgBzKfBJXLVZJt5DbtvlF0do2ol2jw
        NFS5bdrTLxV4ySZ7zcyfqiCReqO6tEOYfdGosIU=
X-Google-Smtp-Source: APXvYqzFgbsPn+MwxiBY7K1wsjZI0pkm9+pIkIGS6pCZth84Yy+3LGlgq89mEvw1Esmbjz5dMFb4j5MpaIRBcRHFvpY=
X-Received: by 2002:a05:6808:8f0:: with SMTP id d16mr14600104oic.173.1561478938094;
 Tue, 25 Jun 2019 09:08:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190620115108.5701-1-ap420073@gmail.com> <20190623.110737.1466794521532071350.davem@davemloft.net>
 <CAMArcTXWNY6WTjuBuUVxeb3c6dTqf8wf6sHFmNL5SvsGBbPqdQ@mail.gmail.com> <CAJieiUjri=-w2PqB9q5fEa=4jqkTWSfK0dUwnT7Cvxdo2sRRzg@mail.gmail.com>
In-Reply-To: <CAJieiUjri=-w2PqB9q5fEa=4jqkTWSfK0dUwnT7Cvxdo2sRRzg@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 26 Jun 2019 01:08:47 +0900
Message-ID: <CAMArcTWG-KLsmzrtQRGGmnUN31yz4UMqJ9FLyv3xNNPoXY_6=Q@mail.gmail.com>
Subject: Re: [PATCH net] vxlan: do not destroy fdb if register_netdevice() is failed
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 at 13:12, Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
>

Hi Roopa,

Thank you for the review!

> On Sun, Jun 23, 2019 at 7:18 PM Taehee Yoo <ap420073@gmail.com> wrote:
> >
> > On Mon, 24 Jun 2019 at 03:07, David Miller <davem@davemloft.net> wrote:
> > >
> >
> > Hi David,
> >
> > Thank you for the review!
> >
> > > From: Taehee Yoo <ap420073@gmail.com>
> > > Date: Thu, 20 Jun 2019 20:51:08 +0900
> > >
> > > > __vxlan_dev_create() destroys FDB using specific pointer which indicates
> > > > a fdb when error occurs.
> > > > But that pointer should not be used when register_netdevice() fails because
> > > > register_netdevice() internally destroys fdb when error occurs.
> > > >
> > > > In order to avoid un-registered dev's notification, fdb destroying routine
> > > > checks dev's register status before notification.
> > >
> > > Simply pass do_notify as false in this failure code path of __vxlan_dev_create(),
> > > thank you.
> >
> > Failure path of __vxlan_dev_create() can't handle do_notify in that case
> > because if register_netdevice() fails it internally calls
> > ->ndo_uninit() which is
> > vxlan_uninit().
> > vxlan_uninit() internally calls vxlan_fdb_delete_default() and it callls
> > vxlan_fdb_destroy().
> > do_notify of vxlan_fdb_destroy() in vxlan_fdb_delete_default() is always true.
> > So, failure path of __vxlan_dev_create() doesn't have any opportunity to
> > handle do_notify.
>
>
> I don't see register_netdevice calling ndo_uninit in case of all
> errors. In the case where it does not,
> does your patch leak the fdb entry ?.
>
> Wondering if we should just use vxlan_fdb_delete_default with a notify
> flag to delete the entry if exists.
> Will that help ?
>
> There is another commit that touched this code path:
> commit 6db9246871394b3a136cd52001a0763676563840
>
> Author: Petr Machata <petrm@mellanox.com>
> Date:   Tue Dec 18 13:16:00 2018 +0000
>     vxlan: Fix error path in __vxlan_dev_create()

I have checked up failure path of register_netdevice().
Yes, this patch leaks fdb entry.
There are 3 failure cases in the register_netdevice().
A. error occurs before calling ->ndo_init().
it doesn't call ->ndo_uninit().
B. error occurs after calling ->ndo_init().
it calls ->ndo_uninit() and dev->reg_state is NETREG_UNINITIALIZED.
C. error occurs after registering netdev. it calls rollback_registered().
rollback_registered() internally calls ->ndo_uninit()
and dev->reg_state is NETREG_UNREGISTERING.

A panic due to these problem could be fixed by using
vxlan_fdb_delete_default() with notify flag.
But notification problem could not be fixed clearly
because of the case C.

I don't have clear solution for the case C.
Please let me know, if you have any good idea for fixing the case C.

Thank you!
