Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C35911F1EB
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 14:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbfLNNO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 08:14:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:36319 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725884AbfLNNO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 08:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576329294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tXUYo8Z/1wc5z0Jgm8edXNyqrl3xATvrCgL0TB1nk/w=;
        b=QgmGlJgk31M3cdPE5A04rioe+FYAY76MlL83lxm5/g1Oqd/tLnKlHImSEgBOGsm2mCg91D
        N3kEK6hv+JEXt1SkymJmr6hAPQP0GhPNPxQMTJYkscsbxTTRaWXPjAeqT4/jKwDe9/6ABD
        kZ6TvMD7Mps9pcBIZq24rL1N0t5gtA0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-rUQ5ZRhwOgGtKTWQa1kIFQ-1; Sat, 14 Dec 2019 08:14:50 -0500
X-MC-Unique: rUQ5ZRhwOgGtKTWQa1kIFQ-1
Received: by mail-lj1-f200.google.com with SMTP id j22so578587lja.20
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 05:14:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXUYo8Z/1wc5z0Jgm8edXNyqrl3xATvrCgL0TB1nk/w=;
        b=K6bp81u4TrUe8G2X0M6godDCNsSzwi4JtA5393Q6a7tgNfzvOa5WA+TT6Pe5v6WGr3
         MUajPfvhP7nW2iUo793AR0sHF+EBYfdtaNDSJzkNvXBapVhsKcmAjpmalS40E2QWQui0
         gDL6h1HmOWcUb0Fiq+ETGVgiYaHwSdkTidjctrd6svP2I/xCNERuMb/CG9FR2VM6W0k/
         DvqyUukO8hRKpuP2is9T3NKcpIiiqQjo6ug7s401HJeGMYWrs4WqRLm2pCvpvYIJ4rFL
         bfafJaNW/SEmxMSTUcHdJbHEN3mrLyKink7nvpHBYdnac7Yt2k0c+wJjL0GYoPY3V4LU
         Gdrw==
X-Gm-Message-State: APjAAAX5blcec7FhOvlgcUG7len2IgXhvtnd0bYqaBvM/g2iiIehUPzH
        o3B2CdGCVSpHYPjdTzUVBSeesm1JHa77F9kEWHreG1FbqtnQgtCqG5FQpHlbxrtu9zEfm/Z8i8o
        qGO3eMcQm0WSYkZfuyK3SzjK39c8jbVN2
X-Received: by 2002:a2e:824a:: with SMTP id j10mr13161571ljh.209.1576329289307;
        Sat, 14 Dec 2019 05:14:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxZbGoEbpVT/4Wz1na9eFRLpPfqSek9IjoemkGbe1gb3IsBoF63dOqBqzFEQofQR68ctx7JMlHOmw1geb/Km1Q=
X-Received: by 2002:a2e:824a:: with SMTP id j10mr13161563ljh.209.1576329289135;
 Sat, 14 Dec 2019 05:14:49 -0800 (PST)
MIME-Version: 1.0
References: <20191210152454.86247-1-mcroce@redhat.com> <20191213181051.0f949b17@cakuba.netronome.com>
In-Reply-To: <20191213181051.0f949b17@cakuba.netronome.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Sat, 14 Dec 2019 14:14:13 +0100
Message-ID: <CAGnkfhwbp3ZzsMTSuAP9WQhs49PJmPimoX1D-M+0uWuUErO91A@mail.gmail.com>
Subject: Re: [PATCH net-next] bonding: don't init workqueues on error
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 3:11 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 10 Dec 2019 16:24:54 +0100, Matteo Croce wrote:
> > bond_create() initialize six workqueues used later on.
>
> Work _entries_ not _queues_ no?
>

Right

> > In the unlikely event that the device registration fails, these
> > structures are initialized unnecessarily, so move the initialization
> > out of the error path. Also, create an error label to remove some
> > duplicated code.
>
> Does the initialization of work entries matter? Is this prep for further
> changes?
>

Not a big issue, I just found useless to initialize those data and
free a bit later.
Just a cleanup.

> > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > ---
> >  drivers/net/bonding/bond_main.c | 11 +++++++----
> >  1 file changed, 7 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index fcb7c2f7f001..8756b6a023d7 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -4889,8 +4889,8 @@ int bond_create(struct net *net, const char *name)
> >                                  bond_setup, tx_queues);
> >       if (!bond_dev) {
> >               pr_err("%s: eek! can't alloc netdev!\n", name);
>
> If this is a clean up patch I think this pr_err() could also be removed?
> Memory allocation usually fail very loudly so there should be no reason
> to print more errors.
>

Sure, I just didn't want to alter the behaviour too much.

> > -             rtnl_unlock();
> > -             return -ENOMEM;
> > +             res = -ENOMEM;
> > +             goto out_unlock;
> >       }
> >
> >       /*
> > @@ -4905,14 +4905,17 @@ int bond_create(struct net *net, const char *name)
> >       bond_dev->rtnl_link_ops = &bond_link_ops;
> >
> >       res = register_netdevice(bond_dev);
> > +     if (res < 0) {
> > +             free_netdev(bond_dev);
> > +             goto out_unlock;
> > +     }
> >
> >       netif_carrier_off(bond_dev);
> >
> >       bond_work_init_all(bond);
> >
> > +out_unlock:
> >       rtnl_unlock();
> > -     if (res < 0)
> > -             free_netdev(bond_dev);
> >       return res;
> >  }
> >
>
> I do appreciate that the change makes the error handling follow a more
> usual kernel pattern, but IMHO it'd be even better if the error
> handling was completely moved. IOW the success path should end with
> return 0; and the error path should contain free_netdev(bond_dev);
>
> -       int res;
> +       int err;
>
>         [...]
>
>         rtnl_unlock();
>
>         return 0;
>
> err_free_netdev:
>         free_netdev(bond_dev);
> err_unlock:
>         rtnl_unlock();
>         return err;
>
> I'm just not 100% sold on the improvement made by this patch being
> worth the code churn, please convince me, respin or get an ack from
> one of the maintainers? :)
>

ACK :)

-- 
Matteo Croce
per aspera ad upstream

