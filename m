Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37E94F9133
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbfKLN7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:59:50 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:46728 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfKLN7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 08:59:50 -0500
Received: by mail-ed1-f66.google.com with SMTP id x11so14955225eds.13
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 05:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=orOPOwRq/CLtduLE0yuNX3V83X6iS4R+sjfuQv+AccU=;
        b=MkfeKdMyX6OrjYvmjl7FTbIAjqfgFerzMZX4yVe/r4iX27rdVbxhErrV02mjWe8M8M
         SPNy7e+XqV5gbAxEJa7nUsAqTpdrdKsPUJmTi81Ruy+Uuu/j0f/oclBXeb+fypMjgmb5
         ArPlhPdZVWicGOH8aoK9tjJtP4aiYMdqrRh2eK5bzRO/EREaGXw8KbKif1b2Ggq2Xu4o
         h13hJ1Q55Kh8Jq2Edipzn2ffauviLETEqTBO4vZ/wCaID0kiBnxl+nr9Gi1i/oHglUi6
         n+QcCgY1/jcd3hu55QQauyK8sIPsNS03GL47p7B9LhbCgomeZQtQKtxAmIqInrW1euMk
         hwPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=orOPOwRq/CLtduLE0yuNX3V83X6iS4R+sjfuQv+AccU=;
        b=iQFkPL7u/GVf0Opydy1lU6KcHWhi2VdnJCXYXpcCvcTgNJYQGyV0UhBlO1rAPhWJ3M
         IKLSpRnljI/0PC4Z4+tGgwtsTYeCy53IMmlwxMmseq3z9sSHKTJxEbylhtJ/xMyzxRFo
         q06eCU+KbEFYGdlGI2OldthkhcIEg6M5b1MSqkStF0jZXuekWk4jXb4eCAebxfvCZ985
         b7nR/+MJrlaJm/Ohqb4qV7qQ0kEy2coh6ehE2jXKwlWSatYuwdEtWx3Ks46EzYW1GpD6
         5uJtnSnsSmSbcRQmudcnjYy+uV7IFIJ62REbTol84tasUyYwhbJ2flqfktLlebm7CLN6
         8rSg==
X-Gm-Message-State: APjAAAWJCBnlowtWg6rGfU4ydQ8oVUNi/8R68UzouwPWatx81tuaZg/m
        CIUFAY3dzKfjPA+dq3AYzIDk1fQlNtKZjPNVs1s=
X-Google-Smtp-Source: APXvYqxJD8qRcBx3EZ3zXm+DLXPofSZu+fDvqJlDZU8Eo2rANUttQC2OByv/ddFvytdYBi8zx2PhtoRDzDy+r/dRzVE=
X-Received: by 2002:a17:906:3450:: with SMTP id d16mr15372416ejb.216.1573567188357;
 Tue, 12 Nov 2019 05:59:48 -0800 (PST)
MIME-Version: 1.0
References: <20191112124420.6225-1-olteanv@gmail.com> <20191112124420.6225-8-olteanv@gmail.com>
 <20191112135559.GI5090@lunn.ch>
In-Reply-To: <20191112135559.GI5090@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 12 Nov 2019 15:59:37 +0200
Message-ID: <CA+h21hpH7O_O83KD-oEJ4c7iu2VsXJFQm2upNadD7xxOv7dvfw@mail.gmail.com>
Subject: Re: [PATCH net-next 07/12] net: mscc: ocelot: separate the
 implementation of switch reset
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Nov 2019 at 15:56, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Nov 12, 2019 at 02:44:15PM +0200, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The Felix switch has a different reset procedure, so a function pointer
> > needs to be created and added to the ocelot_ops structure.
> >
> > The reset procedure has been moved into ocelot_init.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/ethernet/mscc/ocelot.c       |  3 ++
> >  drivers/net/ethernet/mscc/ocelot.h       |  1 +
> >  drivers/net/ethernet/mscc/ocelot_board.c | 37 +++++++++++++++---------
>
> I'm wondering about the name board. So far, the code you have moved
> into ocelot_board has nothing to do with the board as such. This is
> not a GPIO used to reset the switch, it is not a regulator, etc. It is
> all internal to the device, but just differs per family. Maybe you can
> think of a better name?
>

Alexandre, what do you think? I agree "ocelot_board" is a bit strange.

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew
