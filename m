Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E778A22A
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfHLPVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:21:42 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41794 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727037AbfHLPVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:21:41 -0400
Received: by mail-ed1-f67.google.com with SMTP id w5so1174954edl.8
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 08:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8NPZDGRfc1FizPxi9hoeL3xo3E1O7S1BKYjA4NrTuPc=;
        b=f0uXDidpEuE+PL+mAekNNCOd6tajz74Cf+KqQpYG2kPIV8+zHmXKXOIkNKGIp9xfJK
         yrNR+ODgT0tWEizB/gskk82kDj5+/qALeTMUXGrZ+ZqRZ5taG/lbnujaWG7f/QswD5h8
         un+V1Km04IF4Al/pVtKnfsMMBv6dyOqghvR3A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8NPZDGRfc1FizPxi9hoeL3xo3E1O7S1BKYjA4NrTuPc=;
        b=jKu+jugWZBcKqe7o+uEmfXD0o8eb0MItVPzB5V6BLJPanB3QdhFKeuDfgW0Z4helq1
         ow2mmZ9S+j0HGtQ84WwZpoasNU5DxoIiM24AGNxUEN1w+Q2zqjEijNvh7J2osZdhZkDz
         Pezh9uNR2wZwifeBmuxwx+mHgvqg7DtZj+NxCFVi9ugaF5wY0pXD8y5HgSD5+pG7oBLS
         kRZX4/vZCstRWcHrQJr4T9DUxKd6aS2vKCEuJYH6qXVaxBC/bmgs5mnoSlVSdDBxlp1R
         omm5CocniE23yaEyXryReHiQJuAxByULV2mhJWNV+L+8cvCDYqrIEti5/PFhvxExrAOi
         cNPA==
X-Gm-Message-State: APjAAAUtmiETL2DpsC6EsCXGsVNDFRRxff33hm6OOvvTn4bf/ZFxKjlz
        iwlpt+oqdghGwwMnLhlLAmShuDjtvj50UvSEhhgCEg==
X-Google-Smtp-Source: APXvYqxDRQ5PZ+jCt+VY7Jc5SViZh4cyUjOa6jLzjTXqJ9li9R7cz/zQkAD5RgI+np3HDvzG6j5y08TtIB2y/1HilmQ=
X-Received: by 2002:aa7:c559:: with SMTP id s25mr36602267edr.117.1565623299513;
 Mon, 12 Aug 2019 08:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190719110029.29466-1-jiri@resnulli.us> <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion> <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <20190809154609.GG31971@unicorn.suse.cz> <CAJieiUhcG6tpDA3evMtiyPSsKS9bfKPeD=dUO70oYOgGbFKy9Q@mail.gmail.com>
 <20190810155042.GA30089@unicorn.suse.cz> <CAJieiUi3n2kKGBVogHBJOd1q+fUjm8ik+xKvDTOxodnZjmH2WQ@mail.gmail.com>
 <20190811221027.GD30089@unicorn.suse.cz>
In-Reply-To: <20190811221027.GD30089@unicorn.suse.cz>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Mon, 12 Aug 2019 08:21:31 -0700
Message-ID: <CAJieiUjQNHdgHCsQqMHO3u3DtGRBgZfx0Wo3aUj0LyUm_YJ5Eg@mail.gmail.com>
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

On Sun, Aug 11, 2019 at 3:10 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Sat, Aug 10, 2019 at 12:39:31PM -0700, Roopa Prabhu wrote:
> > On Sat, Aug 10, 2019 at 8:50 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> > >
> > > On Sat, Aug 10, 2019 at 06:46:57AM -0700, Roopa Prabhu wrote:
> > > > On Fri, Aug 9, 2019 at 8:46 AM Michal Kubecek <mkubecek@suse.cz> wrote:
> > > > >
> > > > > On Fri, Aug 09, 2019 at 08:40:25AM -0700, Roopa Prabhu wrote:
> > > > > > to that point, I am also not sure why we have a new API For multiple
> > > > > > names. I mean why support more than two names  (existing old name and
> > > > > > a new name to remove the length limitation) ?
> > > > >
> > > > > One use case is to allow "predictable names" from udev/systemd to work
> > > > > the way do for e.g. block devices, see
> > > > >
> > > > >   http://lkml.kernel.org/r/20190628162716.GF29149@unicorn.suse.cz
> > > > >
> > > >
> > > > thanks for the link. don't know the details about alternate block
> > > > device names. Does user-space generate multiple and assign them to a
> > > > kernel object as proposed in this series ?. is there a limit to number
> > > > of names ?. my understanding of 'predictable names' was still a single
> > > > name but predictable structure to the name.
> > >
> > > It is a single name but IMHO mostly because we can only have one name.
> > > For block devices, udev uses symlinks to create multiple aliases based
> > > on different naming schemes, e.g.
> > >
> > > mike@lion:~> find -L /dev/disk/ -samefile /dev/sda2 -exec ls -l {} +
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/ata-WDC_WD30EFRX-68AX9N0_WD-WMC1T3114933-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-SATA_WDC_WD30EFRX-68A_WD-WMC1T3114933-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-SATA_WDC_WD30EFRX-68_WD-WMC1T3114933-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-0ATA_WDC_WD30EFRX-68A_WD-WMC1T3114933-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-1ATA_WDC_WD30EFRX-68AX9N0_WD-WMC1T3114933-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/scsi-350014ee6589cfea0-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-id/wwn-0x50014ee6589cfea0-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-partlabel/root2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-partuuid/71affb47-a93b-40fd-8986-d2e227e1b39d -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-path/pci-0000:00:11.0-ata-1-part2 -> ../../sda2
> > > lrwxrwxrwx 1 root root 10 srp  5 21:47 /dev/disk/by-path/pci-0000:00:11.0-scsi-0:0:0:0-part2 -> ../../sda2
> > >
> > > Few years ago, udev even dropped support for renaming block and
> > > character devices (NAME="...") so that it now keeps kernel name and only
> > > creates symlinks to it. Recent versions only allow NAME="..." for
> > > network devices.
> >
> > ok thanks for the details. This looks like names that are structured
> > on hardware info which could fall into devlinks scope and they point
> > to a single name.
> > We should think about keeping them under devlink (by-id, by-mac etc).
> > It already can recognize network interfaces by id.
>
> Not all of them are hardware based, there are also links based on
> filesystem label or UUID. But my point is rather that udev creates
> multiple links so that any of them can be used in any place where
> a block device is to be identified.
>
> As network devices can have only one name, udev drops kernel provided
> name completely and replaces it with name following one naming scheme.
> Thus we have to know which naming scheme is going to be used and make
> sure it does not change. With multiple alternative names, we could also
> have all udev provided names at once (and also the original one from
> kernel).

ok, understand the use-case.
But, Its hard for me to understand how udev is going to manage this
list of names without structure to them.
Plus how is udev going to distinguish its own names from user given name ?.

I thought this list was giving an opportunity to use the long name
everywhere else.
But if this is going to be managed by udev with a bunch of structured
names, I don't understand how the rest of the system is going to use
these names.

Maybe we should just call this a udev managed list of names.

(again, i think the best way to do this for udev is to provide the
symlink like facility via devlink or any other infra).
