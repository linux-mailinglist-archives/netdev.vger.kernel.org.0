Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8986519127B
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 15:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbgCXOIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 10:08:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44650 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgCXOId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 10:08:33 -0400
Received: by mail-lj1-f193.google.com with SMTP id p14so2990589lji.11;
        Tue, 24 Mar 2020 07:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5tGRfxFBD/mMtGBAGbXivTMDN2VWxYI9KHcqRxJ6Y1g=;
        b=VhG+H3kqrZUW4eOgrHkF3r10IPIzoGAdF+XWWAVuy2QKfhFWOJMS1t6k2VTwVCHthZ
         3JbqOL98hfkBDaC0X+XTFzbtUoldv19OBx8TkmskUP+GMN05l9SOUASIMQ1rr/b+IZS6
         5ZOeFp93Zh42f3+JYEQLHB+enR7u+fJGxwR+dAYep2o7f8z9vml2CWeBIUlBqaieMZYR
         czgVMGr6g6PNwBL6B81tgiYQgNRCEIrwkMdPycGouYcUoiY8zrBWK0yciPjAY725gH3N
         UlM59rYxs0g4gMRiGh07VMbKjQKocUZdJ1mA0Jr+PdpJvs/rV1BMXFql0wAuJtZtt1t7
         mKCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5tGRfxFBD/mMtGBAGbXivTMDN2VWxYI9KHcqRxJ6Y1g=;
        b=PAq8Pqmd6nP4vLZom3IiqxuI7zIuoG4jXfjggQ07fiCfS7pmo/etcUeSgbf0VhDVu6
         heCAYv4itTuA7oMCdf+zSV0xyCN6cpnvuXnYjP50bKMZ8LEjCgoz4oEIDS/IOintqwKf
         6Bg0cTWjUO21dHDAwjX5+V0atrKVpBGx2zEpcwXpNKBMebXRUFbnOipViUYqOFfMUfoM
         jiqr54hbWLbngNT5Bt8o/IIzwdOtzG25yMKVgw2AbA/akCazOureC8wH3spfs7QQy99y
         ZRnOwn/TmQw9Yy365oFuoTgseEFp/ic8alZApLii6SxiA+n/tPZxv6hTrfuYlpKyZ7WI
         tC/w==
X-Gm-Message-State: ANhLgQ2mZhczLhtoJYar1qGEKJNkGMCUGduXAJxE+X+bvbnyzCw9eSjf
        gszpqq76VEzRxI8IEWucFVMlSIUm5lKJI7LwGTY=
X-Google-Smtp-Source: ADFU+vtzcYEq4l4GLOvoCLbhDwDa23lp38rUPB/KSBNCuqY6QifnFNBsCZSVn8hiIYyUCKuj53/rjgbFlNidOMC8Apk=
X-Received: by 2002:a2e:2e11:: with SMTP id u17mr17248355lju.90.1585058909718;
 Tue, 24 Mar 2020 07:08:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200324123041.18825-1-ap420073@gmail.com> <20200324131957.GA2501774@kroah.com>
In-Reply-To: <20200324131957.GA2501774@kroah.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 24 Mar 2020 23:08:18 +0900
Message-ID: <CAMArcTXBM=TNMK5Ave0AsxfVC50o4+E+5pWuFw-76rNrG9jBzg@mail.gmail.com>
Subject: Re: [PATCH net 0/3] net: core: avoid unexpected situation in
 namespace change routine
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, mitch.a.williams@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 at 22:28, Greg KH <gregkh@linuxfoundation.org> wrote:
>

Hi Greg!

> On Tue, Mar 24, 2020 at 12:30:41PM +0000, Taehee Yoo wrote:
> > This patchset is to avoid an unexpected situation when an interface's
> > namespace is being changed.
> >
> > When interface's namespace is being changed, dev_change_net_namespace()
> > is called. This removes and re-allocates many resources that include
> > sysfs files. The "/net/class/net/<interface name>" is one of them.
> > If the sysfs creation routine(device_rename()) found duplicate sysfs
> > file name, it warns about it and fails. But unfortunately, at that point,
> > dev_change_net_namespace() doesn't return fail because rollback cost
> > is too high.
> > So, the interface can't have a sysfs file.
> >
> > The approach of this patchset is to find the duplicate sysfs file as
> > fast as possible. If it found that, dev_change_net_namespace() returns
> > fail immediately with zero rollback cost.
> >
> > 1. The first patch is to add class_find_and_get_file_ns() helper function.
> > That function will be used for checking the existence of duplicate
> > sysfs file.
> > 2. The second patch is to add netdev_class_has_file_ns().
> > That function is to check whether duplicate sysfs file in
> > the "/sys/class/net*" using class_find_and_get_file_ns().
> > 3. The last patch is to avoid an unexpected situation.
> > a) If duplicate sysfs is existing, it fails as fast as possible in
> > the dev_change_net_namespace()
> > b) Acquire rtnl_lock() in both bond_create_sysfs() and bond_destroy_sysfs()
> > to avoid race condition.
> > c) Do not remove "/sys/class/net/bonding_masters" sysfs file by
> > bond_destroy_sysfs() if the file wasn't created by bond_create_sysfs().
> >
> > Test commands#1:
> >     ip netns add nst
> >     ip link add bonding_masters type dummy
> >     modprobe bonding
> >     ip link set bonding_masters netns nst
> >
> > Test commands#2:
> >     ip link add bonding_masters type dummy
> >     ls /sys/class/net
> >     modprobe bonding
> >     modprobe -rv bonding
> >     ls /sys/class/net
> >
> > After removing the bonding module, we can see the "bonding_masters"
> > interface's sysfs will be removed.
> > This is an unexpected situation.
> >
> > Taehee Yoo (3):
> >   class: add class_find_and_get_file_ns() helper function
> >   net: core: add netdev_class_has_file_ns() helper function
> >   net: core: avoid warning in dev_change_net_namespace()
> >
> >  drivers/base/class.c             | 12 ++++++++++++
> >  drivers/net/bonding/bond_sysfs.c | 13 ++++++++++++-
> >  include/linux/device/class.h     |  4 +++-
> >  include/linux/netdevice.h        |  2 +-
> >  include/net/bonding.h            |  1 +
> >  net/core/dev.c                   |  4 ++++
> >  net/core/net-sysfs.c             | 13 +++++++++++++
> >  7 files changed, 46 insertions(+), 3 deletions(-)
>
> I don't seem to see patch 1/3 anywhere...
>

I don't know why the first patch was lost.
Below is the lkml link.
https://lkml.org/lkml/2020/3/24/576
I will resend the first patch.

Thank you!
Taehee Yoo
