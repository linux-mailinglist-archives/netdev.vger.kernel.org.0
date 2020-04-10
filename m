Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3771A1A47D1
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 17:19:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgDJPTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 11:19:20 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45450 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726142AbgDJPTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 11:19:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586531960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=forbnF5zJPe1SgIq7fGqt6u0u+jU0CMDqYv4pkH8qr8=;
        b=HYe0qLvbFldEGqtDUX2VDvQbIS+nm6fWQn9UlgyRskxja8KB9HH/TaZy8HUB54td1iZXIF
        Umojo8UVdlXpeoBzCBJ9ZTQvp3NCjH2O3suj8mTcr2iJbtOfVYP7Qf+1xoY92zrZaca7pD
        jKGyRnxaKtRt8RJiN79n/Un26iSt6kE=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-v3lzvbMNNHmnb9RMpJXm8A-1; Fri, 10 Apr 2020 11:19:18 -0400
X-MC-Unique: v3lzvbMNNHmnb9RMpJXm8A-1
Received: by mail-ed1-f70.google.com with SMTP id q27so2160541edc.15
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 08:19:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=forbnF5zJPe1SgIq7fGqt6u0u+jU0CMDqYv4pkH8qr8=;
        b=eROqLO1s4aDufvyhxNV7pYcvH6Y/1qJhMccCCWYSxXOFCtTb7F884EDhIjHUvv8+cC
         hJDvofr1W71+c55k34kqgiljoBWCSM/L02cb/bNwzcyjJ+tH1dsIHi2XOwebk+aULcP2
         SGKGViaFcNtY7VB3jOxAJQKZV6YLpxwiWgYTZb/UMJSkMU8AvKjOOnOUnflnTyKCWwxx
         yf4S/zZZwa5NuTixivkZsTSv/N5wQbCX/975aG+cRwClrMcIVC+D7VO6WzmIxat4YT/4
         u/5PkhQqhSUH3mD86ZZcmVqmDSmTqWmgHydcIXc4kKQJ2R7afnKutcknROS8ZqYafubI
         icQA==
X-Gm-Message-State: AGi0PuZSvZf3HlRhikNuJeppTZvnfV/1heTAstbPni452Hh8Jq52cSev
        /hlHe4XGMwWvh5wjYVKzXWzOxr+eReAfgJmVTrJeUsV0Q8Gi03VUCdstKVxDVykwsc6lscvqS1a
        RqVdspv2amHK/FMrhzeYGnqzvLr+Sz8JG
X-Received: by 2002:a17:906:4cd2:: with SMTP id q18mr4393830ejt.70.1586531957108;
        Fri, 10 Apr 2020 08:19:17 -0700 (PDT)
X-Google-Smtp-Source: APiQypImtmXOVUmThRLz25GHjN6wH8xW/8HumPkt2ZDGw9/IaAZx3IxrFKWDcbsw5cX8lO+Y+tDULfPapCfnVMIJJoY=
X-Received: by 2002:a17:906:4cd2:: with SMTP id q18mr4393805ejt.70.1586531956827;
 Fri, 10 Apr 2020 08:19:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200303155347.GS25745@shell.armlinux.org.uk> <E1j99sC-00011f-22@rmk-PC.armlinux.org.uk>
 <CAGnkfhx+JkD6a_8ojU6tEL_vk6vtwQpxbwU9+beDepL4dxgLyQ@mail.gmail.com>
 <20200410141914.GY25745@shell.armlinux.org.uk> <20200410143658.GM5827@shell.armlinux.org.uk>
 <CAGnkfhxPm6UWj8Dyt9S08vHdh9nwkTums+WfY14D52dsBsBPgQ@mail.gmail.com>
 <20200410145034.GA25745@shell.armlinux.org.uk> <CAGnkfhwOCLSG=3v2jy6tTxiPyX0H+Azj7Ni5t8_nkRi=rUfnUQ@mail.gmail.com>
 <20200410151627.GB25745@shell.armlinux.org.uk>
In-Reply-To: <20200410151627.GB25745@shell.armlinux.org.uk>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 10 Apr 2020 17:18:41 +0200
Message-ID: <CAGnkfhyE8q3iM6oW73R2ZUys+osd6YVYWcDDp6-YDsxmyzgKrg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 3/3] net: phy: marvell10g: place in powersave
 mode at probe
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Luka Perkov <luka.perkov@sartura.hr>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 5:16 PM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Fri, Apr 10, 2020 at 04:59:44PM +0200, Matteo Croce wrote:
> > On Fri, Apr 10, 2020 at 4:50 PM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Apr 10, 2020 at 04:39:48PM +0200, Matteo Croce wrote:
> > # ./mii-diag eth0 -p 32769
> > Using the specified MII PHY index 32769.
> > Basic registers of MII PHY #32769:  2040 0082 002b 09ab 0071 009a c000 0009.
> >  Basic mode control register 0x2040: Auto-negotiation disabled, with
> >  Speed fixed at 100 mbps, half-duplex.
> >  Basic mode status register 0x0082 ... 0082.
> >    Link status: not established.
> >    *** Link Jabber! ***
> >  Your link partner is generating 100baseTx link beat  (no autonegotiation).
> >    End of basic transceiver information.
> >
> > root@macchiatobin:~# ip link show dev eth0
> > 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP
> > mode DEFAULT group default qlen 2048
> >     link/ether 00:51:82:11:22:00 brd ff:ff:ff:ff:ff:ff
> >
> > But no traffic in any direction
>
> So you have the same version PHY hardware as I do.
>
> So, we need further diagnosis, which isn't possible without a more
> advanced mii-diag tool - I'm sorting that out now, and will provide
> a link to a git repo later this afternoon.
>

Ok, I'll wait for the tool

Thanks a lot,
-- 
Matteo Croce
per aspera ad upstream

