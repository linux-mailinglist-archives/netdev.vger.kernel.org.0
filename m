Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9DD756198
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 07:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbfFZFDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 01:03:25 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:32887 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfFZFDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 01:03:24 -0400
Received: by mail-ed1-f66.google.com with SMTP id i11so1346958edq.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 22:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCEx+wm+8u6zNsFuuRGg9wGxgBsqnyvoa2b9m0m8nNw=;
        b=YiyGA2Jj+cPgkHYyOnGZnAmxEFQhHiVSflTN6/QhXf6oGmT1tAEITMFZ8RvDCq6aTx
         TIKKnzzsS1wJJms9ftwknXhyzp1b7njRc1X8XddpxTBpL2epbON/K8Y6ilBDWgEx6Aq9
         2Ht02TYBu4YlXJ27XE3YdWo1lp1SQIqLJnp00=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCEx+wm+8u6zNsFuuRGg9wGxgBsqnyvoa2b9m0m8nNw=;
        b=N10Ou6PFbvlxUcb9a6MZ2ZbQm02uqQFUOXcF35Lo87AxvNx7OKKd8A9ww9QHtfdXut
         rrb+Kcc2Y1/EA1AsFKIEsZd6/cvx69FpmsvuUpiTSgcwaHEHpuxMIZcwaVCAN739xJB7
         +KEBCG+KnHeTu2JWJuS0FRmDD9j1U99n6Yn4lICd+fD0FpSiwHXELYtUWV64jkZ2lsd4
         ikw6GG3DJMtcjxQuFOmhdl2Co0SbJzLqOYY/Os7qAr1NBgqRS6aTqtWIfa8q/o/pR9Hb
         brRLT+/lfoG8A0fJSkbzuulyiJbswf/SHxYOogadxqJlqxMhC17TbndEKP39nk0igc8y
         gUhw==
X-Gm-Message-State: APjAAAVGXY9CtNqznQCKaXRKCw69i0Go5hdVlP8aRQ3fr6XW13FEfNRd
        M/BD8lfqKlvdw1vi6YzpDCIUWvaIrHy1pm8eZ0w0bg==
X-Google-Smtp-Source: APXvYqyU7g3sQVU+J+sDBRLyW+kn1Z13E8zjUHkPOndduDbAjrn5/OXGOjBmBPxXqJq2ug8Qo8t/g2zTXFOTPDoWW/E=
X-Received: by 2002:a17:906:474a:: with SMTP id j10mr2161630ejs.104.1561525402613;
 Tue, 25 Jun 2019 22:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190620115108.5701-1-ap420073@gmail.com> <20190623.110737.1466794521532071350.davem@davemloft.net>
 <CAMArcTXWNY6WTjuBuUVxeb3c6dTqf8wf6sHFmNL5SvsGBbPqdQ@mail.gmail.com>
 <CAJieiUjri=-w2PqB9q5fEa=4jqkTWSfK0dUwnT7Cvxdo2sRRzg@mail.gmail.com> <CAMArcTWG-KLsmzrtQRGGmnUN31yz4UMqJ9FLyv3xNNPoXY_6=Q@mail.gmail.com>
In-Reply-To: <CAMArcTWG-KLsmzrtQRGGmnUN31yz4UMqJ9FLyv3xNNPoXY_6=Q@mail.gmail.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Tue, 25 Jun 2019 22:03:12 -0700
Message-ID: <CAJieiUjb6ev0spr6A00OoLsN5MFv32T+-Hn-wCsZePa5MvJV_g@mail.gmail.com>
Subject: Re: [PATCH net] vxlan: do not destroy fdb if register_netdevice() is failed
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 9:08 AM Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Tue, 25 Jun 2019 at 13:12, Roopa Prabhu <roopa@cumulusnetworks.com> wrote:
> >
>
> Hi Roopa,
>
> Thank you for the review!
>
> > On Sun, Jun 23, 2019 at 7:18 PM Taehee Yoo <ap420073@gmail.com> wrote:
> > >
> > > On Mon, 24 Jun 2019 at 03:07, David Miller <davem@davemloft.net> wrote:
> > > >
> > >
> > > Hi David,
> > >
> > > Thank you for the review!
> > >
> > > > From: Taehee Yoo <ap420073@gmail.com>
> > > > Date: Thu, 20 Jun 2019 20:51:08 +0900
> > > >
> > > > > __vxlan_dev_create() destroys FDB using specific pointer which indicates
> > > > > a fdb when error occurs.
> > > > > But that pointer should not be used when register_netdevice() fails because
> > > > > register_netdevice() internally destroys fdb when error occurs.
> > > > >
> > > > > In order to avoid un-registered dev's notification, fdb destroying routine
> > > > > checks dev's register status before notification.
> > > >
> > > > Simply pass do_notify as false in this failure code path of __vxlan_dev_create(),
> > > > thank you.
> > >
> > > Failure path of __vxlan_dev_create() can't handle do_notify in that case
> > > because if register_netdevice() fails it internally calls
> > > ->ndo_uninit() which is
> > > vxlan_uninit().
> > > vxlan_uninit() internally calls vxlan_fdb_delete_default() and it callls
> > > vxlan_fdb_destroy().
> > > do_notify of vxlan_fdb_destroy() in vxlan_fdb_delete_default() is always true.
> > > So, failure path of __vxlan_dev_create() doesn't have any opportunity to
> > > handle do_notify.
> >
> >
> > I don't see register_netdevice calling ndo_uninit in case of all
> > errors. In the case where it does not,
> > does your patch leak the fdb entry ?.
> >
> > Wondering if we should just use vxlan_fdb_delete_default with a notify
> > flag to delete the entry if exists.
> > Will that help ?
> >
> > There is another commit that touched this code path:
> > commit 6db9246871394b3a136cd52001a0763676563840
> >
> > Author: Petr Machata <petrm@mellanox.com>
> > Date:   Tue Dec 18 13:16:00 2018 +0000
> >     vxlan: Fix error path in __vxlan_dev_create()
>
> I have checked up failure path of register_netdevice().
> Yes, this patch leaks fdb entry.
> There are 3 failure cases in the register_netdevice().
> A. error occurs before calling ->ndo_init().
> it doesn't call ->ndo_uninit().
> B. error occurs after calling ->ndo_init().
> it calls ->ndo_uninit() and dev->reg_state is NETREG_UNINITIALIZED.
> C. error occurs after registering netdev. it calls rollback_registered().
> rollback_registered() internally calls ->ndo_uninit()
> and dev->reg_state is NETREG_UNREGISTERING.
>
> A panic due to these problem could be fixed by using
> vxlan_fdb_delete_default() with notify flag.
> But notification problem could not be fixed clearly
> because of the case C.

yes, you are right. The notification issue still remains.

>
> I don't have clear solution for the case C.
> Please let me know, if you have any good idea for fixing the case C.

One option is a variant of fdb create. alloc the fdb  but don't assign
it to the vxlan dev.
__vxlan_dev_create
             create fdb entry
             register_netdevice
             rtnl_configure_link
             link fdb to vxlan
             fdb notify


Yet another option is moving fdb create after register_netdevice
__vxlan_dev_create
             register_netdevice
             rtnl_configure_link
             create fdb entry
             fdb notify
But if fdb create fails, user-space will see , NEWLINK + DELLINK when
creating a vxlan device and that seems weird.
