Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69577290DCE
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 00:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731899AbgJPWjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 18:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731257AbgJPWjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 18:39:23 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F94C061755
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 15:39:23 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id 140so3223265qko.2
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 15:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A7vRkpeq6oF7y1uLVD7hHZ2BUOjTTW5x+4EJzcO6XLk=;
        b=pbRrNQmV/O0YqcKW9Hr2HSJv+0AFYlc/WibExVzN8SXonmHrn+2+Fj5Mf37y1Sw9YE
         V8N38wkIZv4dVJFixdo9vBg2itX0wEAAo14ycgVWEBNknrWvwJIxbgzbGmBH6cH1a9Vh
         9gWF7ERNktUO280fCs+swfTHbJLlyW6MBe5JyOlZ9HVKzmhA9X0yhLNEYMDKWVU6eQAJ
         M0yTPTQR1x12vKQwakAz5YIOZS//S6ZtquU+KDyWy0AMaJGd/nna1GV74vaRqNh1VWl9
         cCvfoussVIyBvxnKE/kq638h0o00/j7QXAHYvw+XGbMwu2qgEz5YGak38wYo7LSHEJqh
         g9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A7vRkpeq6oF7y1uLVD7hHZ2BUOjTTW5x+4EJzcO6XLk=;
        b=lL7KN9LFPYacyXAI9UilXo9K30kjg/il79rSu2ecRNMRjrqrW24phiJioVQkceVEbB
         dIYQeiVYhC3F4lYlaGFb3b0xWw3wemHGeRCLUwEJeg6QxsMC2nsVaXlYSmeV0uZAQ3yY
         XOlQ9NFqTn/NasLznR5eLD3BmtQQuklk0AID5fiVd96+y7Y1VJf70GJzMdIvNc+dgyrc
         NWj5kjqNguBcsL6hCovajUAcLVM7B/EdKuy0o+Kj2LJcRSwu+CiKyoLqD5mddHgZxXvg
         aAXp8gtU/BWBTQSgNrwiIwoTYGULF6mUZPPNPfEoZgQvyj1KSTEsw02pyuoVZ22NqZ4W
         EP2g==
X-Gm-Message-State: AOAM533p9mXpaiPaWmtTll1MTn6P4/9pzKZt+xb0Z8+UFRx1hL0Chued
        pIH91aZLzncuxeT+ao/Ome0OSpRkgQ6psbbvhbOWY2oW+bU=
X-Google-Smtp-Source: ABdhPJxZ2xS2xhf7sCclLZXdEGKqhWooYcqSTk5XLzP2aYOatQerA09t9DjTAfi1e+ZbvauBtHAkwu0Ni5qWy2Lnbdo=
X-Received: by 2002:a37:a187:: with SMTP id k129mr6321075qke.435.1602887962177;
 Fri, 16 Oct 2020 15:39:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAA85sZv=13q8NXbjdf7+R=wu0Q5=Vj9covZ24e9Ew2DCd7S==A@mail.gmail.com>
 <CAA85sZs9wswn06hd7ien2B_fyqFM9kEWL_-vXQN-sjhqisizaQ@mail.gmail.com> <20201016122122.0a70f5a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201016122122.0a70f5a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Ian Kumlien <ian.kumlien@gmail.com>
Date:   Sat, 17 Oct 2020 00:39:11 +0200
Message-ID: <CAA85sZtGt0ZbhGY8+96G9TY+cE+tgmjb8rHmiGT9Js+ZbjKJeg@mail.gmail.com>
Subject: Re: ixgbe - only presenting one out of four interfaces on 5.9
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jeffrey.t.kirsher@intel.com,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 9:21 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 16 Oct 2020 11:35:15 +0200 Ian Kumlien wrote:
> > Adding netdev, someone might have a clue of what to look at...
> >
> > On Mon, Oct 12, 2020 at 9:20 PM Ian Kumlien <ian.kumlien@gmail.com> wrote:
> > >
> > > Hi,
> > >
> > > I was really surprised when i rebooted my firewall and there was
> > > network issues, I was even more surprised when
> > > only one of the four ports of my ixbe (x553) nic was available when booted.
>
> Just to be sure you mean that the 3 devices are not present in ip link
> show?

or ifconfig or /proc etc etc, so yes

> > > You can actually see it dmesg... And i tried some basic looking at
> > > changes to see if it was obvious.... but..
>
> Showing a full dmesg may be helpful, but looking at what you posted it
> seems like the driver gets past the point where netdev gets registered,
> so the only thing that could fail after that point AFIACT is
> mdiobus_register(). Could be some breakage in MDIO.

Humm... interesting, will have a look at it

> Any chance you could fire up perf, bpftrace and install a kretprobe to
> see what mdiobus_register() returns? You can rebind the device to the
> driver through sysfs.

Do you need a difference between the kernels?
