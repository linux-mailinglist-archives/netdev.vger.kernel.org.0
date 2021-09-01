Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A2A3FE5E0
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 02:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346196AbhIAWzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 18:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346093AbhIAWzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 18:55:24 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF24DC061757
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 15:54:26 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id n126so72965ybf.6
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 15:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4hcsgNE4R+wSEzNZUDcoiFTfxL7X/EpFAbnpFeONnhQ=;
        b=nzYKN1yHfdGtTNSnK9qy05x8ECkDVabJvtzd+c5QxqYjTICjSxGsc7oP5QHTal5VG0
         2fiIIHOhx5FzXvMNwSTO443PMJbh1fUcaf5SqNRO9bNrRz5QRkFPFHTkvRSyeXtKD+GT
         Jz3440JXJN3e4YbmXUAyyplSOxl0JloVkkkVEN/asWzW+B3pJtcgk+IJwXPGjrgAu9m8
         6jVLRvWvX9VMS5TqtxmJeGsZQVoF3vP9PdHpHJjt1dk2bdbEeRhZAPgLrQU0fI+ldlWq
         WsHwpfNY2NGLPobNesD/HTEOOCSuMUs+BW03qQtWzYuBsWXvyMMYPibzREajTH1dl7bM
         9apg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4hcsgNE4R+wSEzNZUDcoiFTfxL7X/EpFAbnpFeONnhQ=;
        b=XVKJ5HLtHK4v78S31/aki+vp7QXBN4UwaU/vu6h02dNgU+6AkY8DoSXes2sOiRyYA0
         jUPERWGAazdtzVR0QiL8WvYN4wUZkdsF0GGwO2rl+C3o2YI9YczJaRGOLUJQyMzaFPQv
         Sc7utYVnbtwEcqZ4rX84LDMxQnzIr/pQ0+CqWO/Kz3W6DQ62pRe4ObqzKROR9Fyz0KJt
         30ivQOPtygdYsP/jnlFhhkvhD/QDEjAH8epqXqcrhUq9iRQUxRPBDgwSFwZTQHQiPS06
         S1XyjUtjFznrzRlTML4Q677n28UrGwscSndnqASzK65so4Kz+4885ozjhJmeVMJ6x0Me
         kk4Q==
X-Gm-Message-State: AOAM5339+KcMdLEEC5UODEwBRuo9BPTmghp1AqgHd7xqVFAw9XHOrl0c
        NJcOe/DBaR5DrABmLqLq0seLPXI0mXfm709CH7mZgA==
X-Google-Smtp-Source: ABdhPJwoOhg36Xui+G7bkyl+uIvJ83xIP0J492cVY6H8q/yrsXWzOzWSj9Jt3PUDWPuxgUiPtUW2N9/wk1Wtaoa43AI=
X-Received: by 2002:a25:d213:: with SMTP id j19mr431059ybg.20.1630536865855;
 Wed, 01 Sep 2021 15:54:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAGETcx-ZvENq8tFZ9wb_BCPZabpZcqPrguY5rsg4fSNdOAB+Kw@mail.gmail.com>
 <YSpr/BOZj2PKoC8B@lunn.ch> <CAGETcx_mjY10WzaOvb=vuojbodK7pvY1srvKmimu4h6xWkeQuQ@mail.gmail.com>
 <YS4rw7NQcpRmkO/K@lunn.ch> <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch> <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch> <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx-ktuU1RqXwj_qV8tCOLAg3DXU-wCAm6+NukyxRencSjw@mail.gmail.com> <20210901084625.sqzh3oacwgdbhc7f@skbuf>
In-Reply-To: <20210901084625.sqzh3oacwgdbhc7f@skbuf>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 1 Sep 2021 15:53:49 -0700
Message-ID: <CAGETcx9D1pBqMjPgJq7poWxnEO7AbT6yFkXL-3LsNuELLs+PWQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for FWNODE_FLAG_BROKEN_PARENT
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 1, 2021 at 1:46 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Tue, Aug 31, 2021 at 07:00:58PM -0700, Saravana Kannan wrote:
> > On Tue, Aug 31, 2021 at 4:18 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > >
> > > On Wed, Sep 01, 2021 at 01:02:09AM +0200, Andrew Lunn wrote:
> > > > Rev B is interesting because switch0 and switch1 got genphy, while
> > > > switch2 got the correct Marvell PHY driver. switch2 PHYs don't have
> > > > interrupt properties, so don't loop back to their parent device.
> > >
> > > This is interesting and not what I really expected to happen. It goes to
> > > show that we really need more time to understand all the subtleties of
> > > device dependencies before jumping on patching stuff.
> > >
> > > In case the DSA tree contains more than one switch, different things
> > > will happen in dsa_register_switch().
> > > The tree itself is only initialized when the last switch calls
> > > dsa_register_switch(). All the other switches just mark themselves as
> > > present and exit probing early. See this piece of code in dsa_tree_setup:
> > >
> > >         complete = dsa_tree_setup_routing_table(dst);
> > >         if (!complete)
> > >                 return 0;
> > >
> > > So it should be a general property of cross-chip DSA trees that all
> > > switches except the last one will have the specific PHY driver probed
> > > properly, and not the genphy.
> > >
> > > Because all (N - 1) switches of a tree exit early in dsa_register_switch,
> > > they have successfully probed by the time the last switch brings up the
> > > tree, and brings up the PHYs on behalf of every other switch.
> > >
> > > The last switch can connect to the PHY on behalf of the other switches
> > > past their probe ending, and those PHYs should not defer probing because
> > > their supplier is now probed. It is only that the last switch cannot
> > > connect to the PHYs of its own ports.
> >
> > I'm not saying this with any intention of making things easier for me
> > (I'm not even sure it does). But your description about how multiple
> > switches are handled by DSA has me even more convinced than before
> > that DSA needs to use a component device model. This is like the
> > textbook example for component devices.
>
> In this example, I guess the component master would be the "struct dsa_switch_tree",

Right.

> but there is no struct device associated with it.

We can create one? I don't think it needs to have a DT node. And if it
does, this is where my "I'm willing to help improve component device"
offer comes in to help make it a bit more generic.

>
> How many "struct dsa_switch_tree" instances there are in a system
> depends on whether OF is used or not.
>
> If we use OF, the device tree needs to be parsed, and every unique first
> cell (tree-id) of:
>         dsa,member = <tree-id switch-id>;
> constitutes a different "struct dsa_switch_tree".
>
> If we do not use OF, the number of switch trees in a system is one, see dsa_switch_parse.
>
> It seems to me like the compare function for component_match (where each
> component is a "struct dsa_switch" should look at dev->of_node and parse
> the "dsa,member" property again, and match on the same tree-id as the
> component master itself?

I don't know enough about DSA to give a useful answer here. But I guess so?

>
> There's also the question of how to do the component_match in a way that
> also works for the pdata/non-OF based DSA systems (of which I have none to test).

You could always just short circuit it and not create a component
device if it's just pdata/non-OF. That's one option.

> All of this to move dsa_tree_setup() outside of the probe calling
> context of any individual struct dsa_switch, and into the "bind" calling
> context of the component master associated with the struct dsa_switch_tree.

Right.

> This would allow the phy_connect()/phy_attach_direct() calls to find the
> PHY device already bound to the specific driver, which would avoid
> binding genphy as a last resort?

Short answer, yes. Long answer: this would fix multiple things:
1) Remove the parent's probe from depending on the child's probe().
This is not guaranteed at all, so we'd fix this bad assumption in the
code.
2) It would allow the PHYs to probe with fw_devlink because the switch
would have completed probing.
3) It'd avoid the bad design of the last switch's probe doing all the
PHY handling for the previous N-1 switches. What if something fails
there? Shouldn't it be one of the previous switches that should report
the failure (either in probe or switch registration or whatever?)? The
component device model would allow each switch to do all it's own work
and then the component master can do the "tying up" of all these
switches and PHYs.

>
> Two questions:
>
> - Why would it now be more guaranteed that the PHY drivers are bound to
>   the internal PHY devices exactly during the time span between events
>   (a) Switch driver (a component of the switch tree) finishes probing
>   (b) Switch tree (the component master) starts binding

Firstly, PHYs won't defer probe due to fw_devlink enforcing their
dependency on the switch and will actually have their probe() called
(and possibly succeed -- see more below).

>   I mean in lack of any guarantee, we can still end up in a situation
>   where the specific PHY driver still is not bound early enough to the
>   internal PHY to be available by the time we call phylink_of_phy_connect,
>   and we have all those component device goodies but they don't help.
>   I'm sure I'm misunderstanding something but I don't know what.
>
> - What if the internal PHY has other suppliers beyond the interrupt-parent?
>   What if, say, it has a reset-gpios = <&gpio1>, where gpio1 is provided
>   by some other thing on some other slow bus, which is equally slow (or
>   slower) to probe to the DSA switch itself. So the temporary absence of
>   this other supplier is causing the specific PHY driver to defer probing,
>   just enough for a concurrent call to phylink_of_phy_connect -> phy_attach_direct
>   to say "ok, I've waited enough and there is no driver, genphy it is".
>   How would this be avoided?

Good question and this is another reason for me suggesting the use of
component model.

> Or are you thinking of some kind of two-level
>   component driver system:
>   - the DSA switch is a component master, with components being its
>     sub-devices such as internal PHYs etc
>   - the DSA switch is also a component of the DSA switch tree

I was thinking of one component master with all the devices that make
up the DSA switch tree. I don't think there's any requirement that all
the component devices need to be of the same type. That way, the DSA
switch tree won't even be attempted until all the devices are ready.

One thing that's not clear to me wrt using specific driver vs the
genphy -- at what point is it okay to give up waiting for a specific
driver? This is more of a question to the maintainers than what
happens today. What if the specific driver is a module that's loaded
after the switch's driver? There's no time bound to this event. Are we
going to put the restriction that all the PHY's drivers need to be
registered/loaded before the switch's driver? If that's the decision,
that's okay by me. But I just want to understand the requirements.

Also see my reply to your other email.

-Saravana
