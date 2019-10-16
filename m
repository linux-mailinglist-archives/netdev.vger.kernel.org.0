Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE7AD9490
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 16:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404265AbfJPO6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 10:58:36 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43921 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732319AbfJPO6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 10:58:36 -0400
Received: by mail-ed1-f65.google.com with SMTP id r9so21552800edl.10
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 07:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W+FwUJzW9eNwwxj1jOQ5bccgq2KJrh5+TpB43dm99LQ=;
        b=XAI9E0kGAypH3mc4afOjkRNcfeuGdZ/Byzf8M6oSnkGLM3oy5ZByDZ6oicmBaUBt2i
         3j4PiAKK0yCZyRCGHClUpV3I7PwWjSK0PxektJXOh+T1arJoDmEQGcsyC2SrlcUacHa0
         IeMEcX0A1mJipy0exRG9AnB7l7JtaOv1wFGbI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W+FwUJzW9eNwwxj1jOQ5bccgq2KJrh5+TpB43dm99LQ=;
        b=W5SFRLr3oecjfQOM2u7GH/10CDvtjStwfAKrv14byWmJtHBlz9uPfiJgfynyVK+yM7
         QCHtBlICrpAzHhQxKuMIBJ1lwSUE4Tou8FT1P+Qp9dbhMKfXm8dyJY3bEApty3KGQTB9
         V7CzI4SR0EtriV/srm7aj/1jvLh2FxNN4QO/AR87TLhZ/cFgQrerWQNW62bx3pBCI/L4
         mQRB0uFgS1WZ3KoZutTmrpPevVQbML7JkIpKw+uD+FuyvaZ+xhRjuHoQE73XtHt8hBR0
         VRgLQIOeMfCEuwKNBFERYg41xCM6xlPd40L0UGx0pqQLX+8Yv7lfY4LtNQtslTrLmE0G
         VEWA==
X-Gm-Message-State: APjAAAUWwE9FveJyAvBmk5UdynAHNW9aA5fPdoBnogccCdVMMssJ5kjO
        BWcH+o5SBlwUV+eEe4A1kRbdIMri3qwKSd1gOAPGkw==
X-Google-Smtp-Source: APXvYqxN3h5Hc26B/llb8hGnRCpsF2eZp6L+FhPIy636LYKa6pexaMDTW7+5wmz3KsEmFVVn93PQgk/Dv9NhdtuqkUE=
X-Received: by 2002:aa7:c259:: with SMTP id y25mr39132821edo.117.1571237914806;
 Wed, 16 Oct 2019 07:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAFLxGvwnOi6dSq5yLM78XskweQOY6aPbRt==G9wv5qS+dfj8bw@mail.gmail.com>
 <3A7BDEE0-7C07-4F23-BA01-F32AD41451BB@cumulusnetworks.com> <5A4A5745-5ADC-4AAC-B060-1BC9907C153C@cumulusnetworks.com>
In-Reply-To: <5A4A5745-5ADC-4AAC-B060-1BC9907C153C@cumulusnetworks.com>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Wed, 16 Oct 2019 07:58:24 -0700
Message-ID: <CAJieiUi-b5vcOTGqXcDpn9fxVwA9jyoMWEDM2F_ZgVfzdgFgeA@mail.gmail.com>
Subject: Re: Bridge port userspace events broken?
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Richard Weinberger <richard.weinberger@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 3:53 AM <nikolay@cumulusnetworks.com> wrote:
>
> On 15 October 2019 12:48:58 CEST, nikolay@cumulusnetworks.com wrote:
> >On 14 October 2019 22:33:22 CEST, Richard Weinberger
> ><richard.weinberger@gmail.com> wrote:
> >>Hi!
> >>
> >>My userspace needs /sys/class/net/eth0/brport/group_fwd_mask, so I set
> >>up udev rules
> >>to wait for the sysfs file.
> >>Without luck.
> >>Also "udevadm monitor" does not show any event related to
> >>/sys/class/net/eth0/brport when I assign eth0 to a bridge.
> >>
> >>First I thought that the bridge code just misses to emit some events
> >>but
> >>br_add_if() calls kobject_uevent() which is good.
> >>
> >>Greg gave me the hint that the bridge code might not use the kobject
> >>model
> >>correctly.
> >>
> >>Enabling kobjekt debugging shows that all events are dropped:
> >>[   36.904602] device eth0 entered promiscuous mode
> >>[   36.904786] kobject: 'brport' (0000000028a47e33):
> >kobject_uevent_env
> >>[   36.904789] kobject: 'brport' (0000000028a47e33):
> >>kobject_uevent_env: filter function caused the event to drop!
> >>
> >>If I understood Greg correctly this is because the bridge code uses
> >>plain kobjects which
> >>have a parent object. Therefore all events are dropped.
> >>
> >>Shouldn't brport be a kset just like net_device->queues_kset?
> >
> >
> >Hi Richard,
> >I'm currently traveling and will be out of reach until mid-next week
> >when I'll be
> >able to take a closer look, but one thing which comes to mind is that
> >on
> >any bridge/port option change there should also be a netlink
> >notification which
> >you could use. I'll look into this and will probably cook a fix, if
> >anyone hasn't
> >beaten me to it by then. :)
> >
> >Cheers,
> >  Nik
>
> I meant the notifications could be used to configure the port mask once the
> netdev is enslaved as well as for monitoring changes to them.
> Generally we prefer using netlink for configuration changes, some
> of the bridge options are only accessible via netlink (e. g. vlan config).
>
>

+1,  this can be fixed....but in general all new bridge and link
attributes have better support with netlink.
In this case its IFLA_BRPORT_GROUP_FWD_MASK link attribute available
via ip monitor or bridge monitor.
 you probably cannot use it with udev today.

For the future, I think having udev listen to netlink link and devlink
events would make sense (Not sure if anybody is working on it).
AFAIK the sysfs uevent mechanism for link attributes don't  receive
the required attention and testing like the equivalent netlink events.
