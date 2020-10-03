Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0E7282674
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 21:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725889AbgJCTvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 15:51:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgJCTvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 15:51:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601754658;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vAp1KAvQfJwJpulsfJOEBZJdr1SrMe1RU/k5kqvU5YU=;
        b=NN2aDWLrVthYoLUkw0MErhMQsUKwdzbhiSmdgsqT3BszWNJWEWGixgdwqlpAwgzfI+Y5Pr
        ABBrV/X1qDpnkA5QchXJ6mNiz8PdJeGpV6O9ZY1N5lbeFCApCN0e5HDqQrPdx81G2o6nr4
        LsIhcaXQTTYbCV+xRQ2IALaALLBkbMg=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-382-nxrJradKO1-I2lGLFA2p5w-1; Sat, 03 Oct 2020 15:50:57 -0400
X-MC-Unique: nxrJradKO1-I2lGLFA2p5w-1
Received: by mail-oo1-f71.google.com with SMTP id k18so2724199oou.1
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 12:50:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vAp1KAvQfJwJpulsfJOEBZJdr1SrMe1RU/k5kqvU5YU=;
        b=DRu6grET93+neSe9ABuE9ncMWHFsmwb5YSSV0HVTB6xC+YdF4cpDLniKq6H0fyh6+2
         053yBx+IlPqvinv6SsjfAp3VaSn6gQ5wGGzyRT3frcvPo4y50oBaYLtRP/nyOVeV3eGM
         H54VRYd76AzZdNIdPmFNlgz3JS0zrD4sVbrAu/iS/oUCesE86qjjKEts7WCUM5XewtiI
         XpQUJG5J683T7p1ZGkRc8+c3+OOQTCU9ZtsP33n+/Ogbeenrs8hCQiEHux0+Pbafh+IK
         WZFpHwQNI9k7vlu9QXAcK+av9/vg8zPZ+zVPxmGZ2DCyZxRb/RRQDEAXMtglu7dcdC86
         euaA==
X-Gm-Message-State: AOAM5333qVAGJ5OlexW5Bs8upiBZ9HtuEaKF1e5dojxPyoUAMfRltDTA
        0TdxdM7uUmbcCyEHxH9LjdvH9Ga/hPHwq4Yg/iJ8rSVrcw+NwjyBuLs2ef5b5TsJDTgXCPx8nJv
        HgwBtZz4KSDvL8QhR46lrYKuWHx8yIDuP
X-Received: by 2002:aca:4e06:: with SMTP id c6mr2755120oib.120.1601754656552;
        Sat, 03 Oct 2020 12:50:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx5PCrp4JFoSMI5lqXT2fmT6QXGsaWju6ZYuSNeLrSt6Cby+9/vV3qAnIAB4agessrMlqwV+kNUjkgDoMS2+84=
X-Received: by 2002:aca:4e06:: with SMTP id c6mr2755108oib.120.1601754656363;
 Sat, 03 Oct 2020 12:50:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201002174001.3012643-1-jarod@redhat.com> <20201002174001.3012643-7-jarod@redhat.com>
 <20201002121317.474c95f0@hermes.local> <CAKfmpSc3-j2GtQtdskEb8BQvB6q_zJPcZc2GhG8t+M3yFxS4MQ@mail.gmail.com>
 <20201002154222.3adfe408@hermes.local>
In-Reply-To: <20201002154222.3adfe408@hermes.local>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Sat, 3 Oct 2020 15:50:45 -0400
Message-ID: <CAKfmpSffg=mfVmy_06L3J28qe1ns6k_=SbSS7GvEJweUXLYmhg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to disable
 legacy interfaces
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 6:42 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 2 Oct 2020 16:23:46 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
>
> > On Fri, Oct 2, 2020 at 3:13 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> > >
> > > On Fri,  2 Oct 2020 13:40:01 -0400
> > > Jarod Wilson <jarod@redhat.com> wrote:
> > >
> > > > By default, enable retaining all user-facing API that includes the use of
> > > > master and slave, but add a Kconfig knob that allows those that wish to
> > > > remove it entirely do so in one shot.
...
> > > This is problematic. You are printing both old and new values.
> > > Also every distribution will have to enable it.
> > >
> > > This looks like too much of change to users.
> >
> > I'd had a bit of feedback that people would rather see both, and be
> > able to toggle off the old ones, rather than only having one or the
> > other, depending on the toggle, so I thought I'd give this a try. I
> > kind of liked the one or the other route, but I see the problems with
> > that too.
> >
> > For simplicity, I'm kind of liking the idea of just not updating the
> > proc and sysfs interfaces, have a toggle entirely disable them, and
> > work on enhancing userspace to only use netlink, but ... it's going to
> > be a while before any such work makes its way to any already shipping
> > distros. I don't have a satisfying answer here.
> >
>
> I like the idea of having bonding proc and sysf apis optional.

I do too, but I'd see it more as something only userspace developers
would care about for a while, as an easy way to make absolutely
certain their code/distro is no longer reliant on them and only uses
netlink, not as something any normal user really has any reason to do.

-- 
Jarod Wilson
jarod@redhat.com

