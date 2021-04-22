Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485A1368171
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 15:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbhDVN3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 09:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbhDVN3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 09:29:06 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF132C06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 06:28:30 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id z16so32813411pga.1
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 06:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YA/IyyScVMHtnGUCQkKANEniZtf1p79+m5Tz00EglkA=;
        b=nDtubKn+Urha0ULrYWpiiBXxx+kTQO6ZE+jTgKwN+eP56hsgbv+rBX4slFdUgOeEvr
         3d81jg2xcgh7GaCt6nkJX5wsK0lUET+ybQUR8ZZFqlLoV3aRzcnz3bUyRNJQunTB9SYd
         vgDvm430NqYXv3OoVN7GGX5Ncr/YqsmDmEvGWeWbXUj2AMU3LRtMwuCyPJf31x4IJ2ve
         a6OL6muoX6TQ6HN3mn4F1zwjWxqZc6he4OYUjm6yM6aJ1xaMkgvzi7mlRZNjp5WirTyN
         WsVzDDNoy7z9rT2+7ZwzUe8M2EkbsSCWJuuGCoYcIbFmdHETAWzWC1YLaX8OqYR6N9e5
         QGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YA/IyyScVMHtnGUCQkKANEniZtf1p79+m5Tz00EglkA=;
        b=iaDzYTvfnLcpvyzrreRX0YttOYNy87rc6PVi3C7fgTIUgaiuydV7z+Yo0b8irnZNj1
         OcZfichu3ARR28qVS8Rsq7K42OWKhjsci9gT+ixijFWNjRr1iaTkpFyQ/WU0mGVxhQ+I
         HGJPVKmZ7Mgkkhz7TmLhutt++9MBo3imCgKI3IGioBha4vZTIe/BBk8a9NgJ6ScKPVLS
         8lqZOX8q8aHOu9HZqfLD0n7pklza8ZI+a1ed++JxMoGFVlOVC/hObj+pLBi5dLEJMIyY
         Ql79GQs7mGDOfcOLX9KmSllekwio/JkYAJJ6Tw/BTA88ikwkrAchfUn2CWGmZq4/DHcR
         X7PQ==
X-Gm-Message-State: AOAM533Rmj/UJaOv8ydnoanRSPhGErYX9YBmPUUq/nQ2geOXCFhmq+d0
        UtKFVYUEVLu1qicQ1mSjhy4usaYSspGFiKXhBIoBaw==
X-Google-Smtp-Source: ABdhPJwx9CxwE/OQKd7ZqSrd39jg+68zdLf7b7ViWZxNUrvK0vAXvWlWRgma50ajbGYR5zuvCgUswgv3LIoVZVpPALw=
X-Received: by 2002:aa7:8c47:0:b029:25c:8bbd:908 with SMTP id
 e7-20020aa78c470000b029025c8bbd0908mr3451054pfd.54.1619098110140; Thu, 22 Apr
 2021 06:28:30 -0700 (PDT)
MIME-Version: 1.0
References: <1619084614-24925-1-git-send-email-loic.poulain@linaro.org>
 <YIFUvMCCivi62Rb4@unreal> <CAMZdPi8fMu-Be4Rfxcd3gafyUhNozV0RS3idS_eF6gjYW3E9qw@mail.gmail.com>
 <YIFzLUNliMn1DO6h@unreal>
In-Reply-To: <YIFzLUNliMn1DO6h@unreal>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 22 Apr 2021 15:37:10 +0200
Message-ID: <CAMZdPi_GvNeY605HW6MfJrACViHTp20NyAtpm1Gbe-7F1=GzZA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: wwan: core: Return poll error in case of
 port removal
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 at 14:59, Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Apr 22, 2021 at 01:21:47PM +0200, Loic Poulain wrote:
> > Hi Leon,
> >
> > On Thu, 22 Apr 2021 at 12:49, Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Thu, Apr 22, 2021 at 11:43:34AM +0200, Loic Poulain wrote:
> > > > Ensure that the poll system call returns error flags when port is
> > > > removed, allowing user side to properly fail, without trying read
> > > > or write. Port removal leads to nullified port operations, add a
> > > > is_port_connected() helper to safely check the status.
> > > >
> > > > Fixes: 9a44c1cc6388 ("net: Add a WWAN subsystem")
> > > > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > > > ---
> > > >  drivers/net/wwan/wwan_core.c | 17 +++++++++++++++--
> > > >  1 file changed, 15 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
> > > > index 5be5e1e..c965b21 100644
> > > > --- a/drivers/net/wwan/wwan_core.c
> > > > +++ b/drivers/net/wwan/wwan_core.c
> > > > @@ -369,14 +369,25 @@ static int wwan_port_op_tx(struct wwan_port *port, struct sk_buff *skb)
> > > >       return ret;
> > > >  }
> > > >
> > > > +static bool is_port_connected(struct wwan_port *port)
> > > > +{
> > > > +     bool connected;
> > > > +
> > > > +     mutex_lock(&port->ops_lock);
> > > > +     connected = !!port->ops;
> > > > +     mutex_unlock(&port->ops_lock);
> > > > +
> > > > +     return connected;
> > > > +}
> > >
> > > The above can't be correct. What prevents to change the status of
> > > port->ops right before or after your mutex_lock/mutex_unlock?
> >
> > Nothing, this is just to protect access to the variable (probably
> > overkill though), which can be concurrently nullified in port removal,
> > and to check if the event (poll wake-up) has been caused by removal of
> > the port, no port operation (port->ops...) is actually called on that
> > condition. If the status is changed right after the check, then any
> > subsequent poll/read/write syscall will simply fail properly.
>
> Taking locks when it is not needed is not overkill, but bug.

Ok understood, so going to rework that patch properly.

> I wander if all these is_*_blocked() checks can be trusted if port->ops
> pointer flips.

The port->ops value can only flip from something (port connected) to
null (port disconnected), and testing port->ops in is_*_blocked()
prevents blocking on waitqueue once the port is removed (similarly to
e.g. virtio_console).

Regards,
Loic
