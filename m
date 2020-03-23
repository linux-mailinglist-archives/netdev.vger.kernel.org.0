Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C423C18FB6B
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 18:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCWRZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 13:25:49 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:35916 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727163AbgCWRZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 13:25:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584984347;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UNXvxtDhqBPk2mR0oo9iDMMgS94HHc3o9IyrbgMoY40=;
        b=fJil2JFhiExjTejd9T6Y86KK2FX3S0gD5Tt1hnqXm4mYOPdadZHLHg8z0wzI5FFB0ssdGL
        32nIGD+som6b9mJf/WnFvJCdOGYH9PXidU7I8gruDKvVPNNXA7/jA2jehl3zZIQz4fVOK4
        W2pacpGIb/tr//7SHNTUHwn34mn1jlU=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-jFJ-2_GEMye-PI0GxOFhhw-1; Mon, 23 Mar 2020 13:25:45 -0400
X-MC-Unique: jFJ-2_GEMye-PI0GxOFhhw-1
Received: by mail-il1-f197.google.com with SMTP id g79so13554423ild.7
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 10:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UNXvxtDhqBPk2mR0oo9iDMMgS94HHc3o9IyrbgMoY40=;
        b=USLZKudZVFIOt/P8xCRbYnOkjPHVVzY4351tucapSmy3f3h+tjeNt9bcklxrazfzeY
         xy6VLr84Z9ikFNAF7kBTY8WusJGfOtGitJ2q1AsePtnXGhvzQzXocl4eIDdcIrEm3KfI
         7SO5h3GF/wZvZ0JhB3O51ROyF46Uy6P7adJESGx2mc3CkKZ1pHZ07NdatLJSELOdnbfK
         4kqGQP76OaPRUnyQXhYqbcPeHWUg/8+dXn1TZ1zhBfKtsATIfXwuVSEz56Cf2KbuwdeP
         WV0TkuW82A6WKQe/hdu4ByfLYGU/pKDvE9YUZ1OeVFbr7BLKOuU7LdDHt1OVL6hnK4QT
         U6nQ==
X-Gm-Message-State: ANhLgQ3wgJW33+B4z1KAljTvNTfh8cdpUk4AciXz0d0FPWMAsrUxddQe
        X3SCkAUHRjW7OZLRe8JSwkRhdVTrwnxEhG52decul7Y9skMbC+xffdXJD9QgtNhnY+426mpfY25
        /tUa0jRV4eqeC7gS6VybfW9+rnJJUjugz
X-Received: by 2002:a92:3a0b:: with SMTP id h11mr22801953ila.4.1584984344347;
        Mon, 23 Mar 2020 10:25:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuLssj9JilIEDPc0RYnk8iR7JRUYsvTaAjk977L5hc3ijcNT/E6IHIANDwSpS4wfADQ9h4vY7jOVq4lf7clFSI=
X-Received: by 2002:a92:3a0b:: with SMTP id h11mr22801940ila.4.1584984344100;
 Mon, 23 Mar 2020 10:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200318140605.45273-1-jarod@redhat.com> <8a88d1c8-c6b1-ad85-7971-e6ae8c6fa0e4@gmail.com>
 <CAKfmpSc0yea5-OfE1rnVdErDTeOza=owbL00QQEaH-M-A6Za7g@mail.gmail.com>
 <25629.1584564113@famine> <CAKfmpScbzEZAEw=zOEwguQJvr6L2fQiGmAY60SqSBQ_g-+B4tw@mail.gmail.com>
 <3dbabf42-90e6-4c82-0b84-d1b1a9e8fadf@gmail.com> <CAKfmpScXTnnz6wQK3OZcqw4aM1PaLnBRfQL769JgyR7tgM-u5A@mail.gmail.com>
 <20200319154108.2de87e34@hermes.lan>
In-Reply-To: <20200319154108.2de87e34@hermes.lan>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Mon, 23 Mar 2020 13:25:33 -0400
Message-ID: <CAKfmpSd_VQTwxy-gr-jNvQu_CMFf9F2enEjyQC3+W9+Y2WO1Dg@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: don't auto-add link-local address to lag ports
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Moshe Levi <moshele@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 6:41 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Thu, 19 Mar 2020 15:29:51 -0400
> Jarod Wilson <jarod@redhat.com> wrote:
>
> > On Thu, Mar 19, 2020 at 1:06 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > >
> > > On 3/19/20 9:42 AM, Jarod Wilson wrote:
> > >
> > > > Interesting. We'll keep digging over here, but that's definitely not
> > > > working for this particular use case with OVS for whatever reason.
> > >
> > > I did a quick test and confirmed that my bonding slaves do not have link-local addresses,
> > > without anything done to prevent them to appear.
> > >
> > > You might add a selftest, if you ever find what is the trigger :)
> >
> > Okay, have a basic reproducer, courtesy of Marcelo:
> >
> > # ip link add name bond0 type bond
> > # ip link set dev ens2f0np0 master bond0
> > # ip link set dev ens2f1np2 master bond0
> > # ip link set dev bond0 up
> > # ip a s
> > 1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
> > group default qlen 1000
> >     link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> >     inet 127.0.0.1/8 scope host lo
> >        valid_lft forever preferred_lft forever
> >     inet6 ::1/128 scope host
> >        valid_lft forever preferred_lft forever
> > 2: ens2f0np0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
> > mq master bond0 state UP group default qlen 1000
> >     link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
> > 5: ens2f1np2: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
> > mq master bond0 state DOWN group default qlen 1000
> >     link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
> > 11: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc
> > noqueue state UP group default qlen 1000
> >     link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
> >     inet6 fe80::20f:53ff:fe2f:ea40/64 scope link
> >        valid_lft forever preferred_lft forever
> >
> > (above trimmed to relevant entries, obviously)
> >
> > # sysctl net.ipv6.conf.ens2f0np0.addr_gen_mode=0
> > net.ipv6.conf.ens2f0np0.addr_gen_mode = 0
> > # sysctl net.ipv6.conf.ens2f1np2.addr_gen_mode=0
> > net.ipv6.conf.ens2f1np2.addr_gen_mode = 0
> >
> > # ip a l ens2f0np0
> > 2: ens2f0np0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc
> > mq master bond0 state UP group default qlen 1000
> >     link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
> >     inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
> >        valid_lft forever preferred_lft forever
> > # ip a l ens2f1np2
> > 5: ens2f1np2: <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP> mtu 1500 qdisc
> > mq master bond0 state DOWN group default qlen 1000
> >     link/ether 00:0f:53:2f:ea:40 brd ff:ff:ff:ff:ff:ff
> >     inet6 fe80::20f:53ff:fe2f:ea40/64 scope link tentative
> >        valid_lft forever preferred_lft forever
> >
> > Looks like addrconf_sysctl_addr_gen_mode() bypasses the original "is
> > this a slave interface?" check, and results in an address getting
> > added, while w/the proposed patch added, no address gets added.
> >
> > Looking back through git history again, I see a bunch of 'Fixes:
> > d35a00b8e33d ("net/ipv6: allow sysctl to change link-local address
> > generation mode")' patches, and I guess that's where this issue was
> > also introduced.
> >
>
> Yes the addrgen mode patches caused bad things to happen with hyper-v
> sub devices.  Addrconf code is very tricky to get right.
> If you look back there have been a large number of changes where
> a patch looks good, gets reviewed, merged, and then breaks something
> and has to be reverted.
>
> Probably the original patch should just be reverted rather than
> trying to add more here.

I'm not prepared to do a full revert here myself, I don't know the
code well enough, or what the ramifications might be. For v2, I was
just going to propose a check-and-bail for devices with IFF_SLAVE set
in addrconf_addr_gen(), to hopefully catch all the same devices the
existing check from c2edacf80e15 caught, should they take this code
pathway that skips that check.

-- 
Jarod Wilson
jarod@redhat.com

