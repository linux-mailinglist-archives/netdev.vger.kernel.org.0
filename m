Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142D088D05
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 21:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfHJTjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 15:39:44 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39095 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfHJTjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 15:39:43 -0400
Received: by mail-ed1-f67.google.com with SMTP id e16so6227010edv.6
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 12:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jp68P4+F/N3e+to1/MTlz2R+T6lRqlF0Duuuo+OrkOk=;
        b=PuK8mItbY6Eyq2Zby5M9cPgKVpYyWj8P95LO16xZiK2rv4dGIRoK2DkaRZjXC15LyJ
         63alatmKa4t1+KEcwv+MtMTC8RaeHZAn6S4qsq+RKUO3JG+8h5PS1izBlDuFyP0x2B+z
         P/o45mKi/bGd9HjGiorzAJuVfYCcGorS7fkP0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jp68P4+F/N3e+to1/MTlz2R+T6lRqlF0Duuuo+OrkOk=;
        b=mAKVre+rT0jYRVhyt4F7VvHjOO28GLh7Q/2hszSv5DLSbwD0cv1hzAWA10Zpek2AtR
         /pYi+lryt1k6T9CDbUBgWa5vuxPShcUf1KYunyCt4q0NXyqjJe0b4QugoeYDNBzekHB0
         jwnU1/Q4yZ1qJnSZDjSxAWhzmJgurccMt2SF2QV8hjb8ovk+IujMn9jyyRHjzFQAgjAS
         8UFSeYC6nL2orVNG8ThQuyAe2l0lmqnYMhq5fmbIuT2+TElKRIqImsWS2Qg0uSSDbCtk
         n+Dy0cutld3ET2GJfeSxk2wn4aRJ72LGTpt0O+S9Z6NzBRbiHceKpDZU8imrQyTcy3Y9
         D9bg==
X-Gm-Message-State: APjAAAXgtU4k8PprAyXW1sFWzSQfZaKgf97PIhK+Kr6vdeYAcEeokIQz
        YeMI7pX6/FuzwZ8LXo8PkGZjXMbRi67sW3Z4+BZX0g==
X-Google-Smtp-Source: APXvYqxEVAJJ9UkhvBZ73rvHWw/WnZqLfk3xARq5Ad9XF1Jgn+QCICh2NBF4bX7FX3M6IPR7oQ0iRRqJUf0Om6T7l4o=
X-Received: by 2002:aa7:c559:: with SMTP id s25mr28313904edr.117.1565465981917;
 Sat, 10 Aug 2019 12:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190719110029.29466-1-jiri@resnulli.us> <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion> <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <20190809154609.GG31971@unicorn.suse.cz> <CAJieiUhcG6tpDA3evMtiyPSsKS9bfKPeD=dUO70oYOgGbFKy9Q@mail.gmail.com>
 <20190810155042.GA30089@unicorn.suse.cz>
In-Reply-To: <20190810155042.GA30089@unicorn.suse.cz>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sat, 10 Aug 2019 12:39:31 -0700
Message-ID: <CAJieiUi3n2kKGBVogHBJOd1q+fUjm8ik+xKvDTOxodnZjmH2WQ@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 10, 2019 at 8:50 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Sat, Aug 10, 2019 at 06:46:57AM -0700, Roopa Prabhu wrote:
> > On Fri, Aug 9, 2019 at 8:46 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >
> > > On Fri, Aug 09, 2019 at 08:40:25AM -0700, Roopa Prabhu wrote:
> > > > to that point, I am also not sure why we have a new API For multiple
> > > > names. I mean why support more than two names  (existing old name and
> > > > a new name to remove the length limitation) ?
> > >
> > > One use case is to allow "predictable names" from udev/systemd to work
> > > the way do for e.g. block devices, see
> > >
> > >   http://lkml.kernel.org/r/20190628162716.GF29149@unicorn.suse.cz
> > >
> >
> > thanks for the link. don't know the details about alternate block
> > device names. Does user-space generate multiple and assign them to a
> > kernel object as proposed in this series ?. is there a limit to number
> > of names ?. my understanding of 'predictable names' was still a single
> > name but predictable structure to the name.
>
> It is a single name but IMHO mostly because we can only have one name.
> For block devices, udev uses symlinks to create multiple aliases based
> on different naming schemes, e.g.
>
> mike@lion:~> find -L /dev/disk/ -samefile /dev/sda2 -exec ls -l {} +
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3114933-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-SATA_WDC_WD30EFRX-68A_WD-WMC1T3114933-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3114933-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-0ATA_WDC_WD30EFRX-68A_WD-WMC1T3114933-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-1ATA_WDC_WD30EFRX-68AX9N0_WD-WMC1T3114933-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-350014ee6589cfea0-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/wwn-0x50014ee6589cfea0-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-partlabel/root2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-partuuid/71affb47-a93b-40fd-8986-d2e227e1b39d -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-path/pci-0000:00:11.0-ata-1-part2 -> ../../sda2
> lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2 -> ../../sda2
>
> Few years ago, udev even dropped support for renaming block and
> character devices (NAME="...") so that it now keeps kernel name and only
> creates symlinks to it. Recent versions only allow NAME="..." for
> network devices.


ok thanks for the details. This looks like names that are structured
on hardware info which could fall into devlinks scope and they point
to a single name.
We should think about keeping them under devlink (by-id, by-mac etc).
It already can recognize network interfaces by id.

The netdev IFLA_NAME falls more under user-defined name with no
structure (dummy1, dummy1-longname) which network interface managers,
protocols etc use.
 Since the goal of the series is to relax the IFLA_NAME limit, I was
hoping it can be replaced by a single attribute that apps can use in
lieu of IFLA_NAME when available.

I would vote for keeping  the structured and user defined unstructured
names separate and that would help with simplifying the API in this
series.
