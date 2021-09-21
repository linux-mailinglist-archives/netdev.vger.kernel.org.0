Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB479413D87
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 00:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235952AbhIUW2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 18:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232631AbhIUW2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 18:28:37 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFC5C061756
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 15:27:08 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id bk29so2690050qkb.8
        for <netdev@vger.kernel.org>; Tue, 21 Sep 2021 15:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w/NniegAPsrqQovylT0x9NdPmzuMLuCowwMM3/4Onrw=;
        b=ghpssHVgObsePZG2YaoSQ2quCtUJuEd+tpwL75F4+ZiQHCroqi5rVSH2ZqzuJPKDyE
         miQF0K4xr278cH3ExdUkk7Kew9L0K1HdsgX1dhdCizJxDByC9ZylYWb7lMVnwOPwHK9G
         WmQReFJ1UZxLZLt2WnU+bf3PwrEIWEfcMGnBtPtW9w+vIilWCiAGXvhB7wZGSzoifFeP
         BKP261L03zHAU4mK0No44udA4T9V/oVsFItOWAU8WZAB89A7BEeEjCehQ/aEhJ/fstbi
         30nFWBr7aifNRAa8U9mptzSxjfS4zQ7Cbi345F6RzpMaocweM5q1G0SYPhoOCK+z+/BB
         1SSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w/NniegAPsrqQovylT0x9NdPmzuMLuCowwMM3/4Onrw=;
        b=LWlyl0cU4+mxwQ+BfHmyT1yszmKLCnYwWHnHs4QA9qh7N0cqaIZwLMWpMIff/M3kTJ
         NvU1YSE+p79PLJiZbozeJAFJt4gRKEpv62ToW7uqoEYadLOhOsD2FwmpO0OrpgSBdB4M
         L6IpNSYcy/hUOhH+fr4oZJNDytQ7WlLrsMm06WP04YGGRb1XJyYYGYHXmUo4i/02nzay
         yb9dZM88JrGQi3fao3V0sWsezAHjT7gB6HpUwfl4earnuLYB+91qIJKdwMxmqguJ6f8v
         26Sq/AD5CmipsMvMD2eZWxRwPI8phY2h+2Uv/uCUNgXuXfpnG4X7m82iexOrXq9Of1Jf
         zghQ==
X-Gm-Message-State: AOAM533vuVq44fYg3lRg5bSr91WafF0OXQAJh3mc/foiPN5Lmw9KAhBl
        5VxAY5mhuxT+HaEW+kbhi5tg837lxqAW9nB0sKUdBw==
X-Google-Smtp-Source: ABdhPJxcziC4sfd1j8S82m5DEO1q33o86vhq5rhsTYZKiMFbaEe6ncY4ZucVAUPhAY3Ew7XWld4rers0+g8ztdMSLYA=
X-Received: by 2002:a25:6543:: with SMTP id z64mr5960602ybb.486.1632263227316;
 Tue, 21 Sep 2021 15:27:07 -0700 (PDT)
MIME-Version: 1.0
References: <CAJZ5v0h11ts69FJh7LDzhsDs=BT2MrN8Le8dHi73k9dRKsG_4g@mail.gmail.com>
 <YUaPcgc03r/Dw0yk@lunn.ch> <YUoFFXtWFAhLvIoH@kroah.com> <CAJZ5v0jjvf6eeEKMtRJ-XP1QbOmjEWG=DmODbMhAFuemNn4rZg@mail.gmail.com>
 <YUocuMM4/VKzNMXq@lunn.ch> <CAJZ5v0iU3SGqrw909GLtuLwAxdyOy=pe2avxpDW+f4dP4ArhaQ@mail.gmail.com>
 <YUo3kD9jgx6eNadX@lunn.ch> <CAGETcx9hTFhY4+fHd71zYUsWW223GfUWBp8xxFCb2SNR6YUQ4Q@mail.gmail.com>
 <YUpIgTqyrDRXMUyC@lunn.ch> <CAGETcx_50KQuj0L+MCcf2Se8kpFfZwJBKP0juh_T7w+ZCs2p+g@mail.gmail.com>
 <YUpW9LIcrcok8rBa@lunn.ch>
In-Reply-To: <YUpW9LIcrcok8rBa@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 21 Sep 2021 15:26:31 -0700
Message-ID: <CAGETcx_CNyKU-tXT+1_089MpVHQaBoNiZs6K__MrRXzWSi6P8g@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] driver core: fw_devlink: Add support for FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        "Cc: Android Kernel" <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 3:04 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Sep 21, 2021 at 02:54:47PM -0700, Saravana Kannan wrote:
> > On Tue, Sep 21, 2021 at 2:03 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > > There are cases where the children try to probe too quickly (before
> > > > the parent has had time to set up all the resources it's setting up)
> > > > and the child defers the probe. Even Andrew had an example of that
> > > > with some ethernet driver where the deferred probe is attempted
> > > > multiple times wasting time and then it eventually succeeds.
> > >
> > > And i prefer an occasional EPROBE_DEFER over a broken Ethernet switch,
> > > which is the current state. I'm happy to see optimisations, but not at
> > > the expense of breaking working stuff.
> >
> > Right, but in that case, the long term solution should be to make
> > changes so we don't expect the child to be bound as soon as it's
> > added. Not disable the optimization. Agree?
>
> Maybe. Lets see how you fix what is currently broken. At the moment, i
> don't care too much about the long term solution. The current quick
> fix for stable does not seem to be making any progress. So we need the
> real fix now, to unbreak what is currently broken, then we can think
> about the long term.

Wait, what's the difference between a real fix vs a long term fix? To
me those are the same.

I agree that having DSA be broken till we have the final fix isn't
good. Especially because DSA is complicated and the over eager gen PHY
driver makes it even harder to fix it quickly.

Merging this patch gives an exception to DSA, while we figure out a
good fix. It also makes sure more drivers don't get merged with the
same assumptions (because fw_devlink=on won't give them the
exception).

Greg/Rafael, can we merge this please while we figure out a fix for
DSA/PHY. It's a non-trivial problem to solve because PHYs need some
kind of driver "match rating".

-Saravana
