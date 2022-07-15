Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E12575D92
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 10:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbiGOIeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 04:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbiGOIeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 04:34:16 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DBA29C83
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:34:15 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t25so6716389lfg.7
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 01:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a9XRqXHxQeqHgzxMR3XBbO4lnwgsjCZAWCSiuY+LFq4=;
        b=L/VSt+//pCHUgmC2XJNpaJzs7B1wIvaPRUFDXi+rTW21A9pMGPmUda1JnQ+sUbC6Vn
         L/kjZqWVz8zpvqEgQK8pyvrSuSKTDkBfofqgYPrcr9/HY5Za3cjdi6ce/XoRwNxLc9qH
         VGJxCrrOyY/e0ZjEj8Q+AvXFeA8EKgUBk+NIueJ9pGCvfFOHx778Z96CuFf5qVFdccOc
         ZLnLWrXawOo/PxQubfgGPgRJIR0rhMc8DSfF7shOVZS9CNk0SwGA86lznFU97YAWQtZM
         0JlAIpV2SwrQbNV2PMm3aIWwuwGEV9cVwgVtLKQibagMWlDf+odU25sXqslmwuvmljUf
         fgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a9XRqXHxQeqHgzxMR3XBbO4lnwgsjCZAWCSiuY+LFq4=;
        b=o8ZROnnWMONwAC9UpLwgu+1yRwbf70RZxNL72yRB+DH4Rrg3Awp/+Fhu3ynCxl4m80
         tSAGeG62OZGvkfGSdd6IwaA95lh7pQTFK8HdL+khff93hB3Jenv++1UT5JU0ADhv34wE
         jurk0acp2l0FP34/CzQ46znwY+46/GnJC+h1oWi5l/2sZcpmL/L2q9g8hEyFzZOCw6bb
         ZyqpHz1+1Ix8zJ1K0R0/y6ToaA0Duqzdky434ewA7gpwCAr/50QBH1iOyyuwGlxSKDbu
         sWPUQXQOkE7qs8JKHUauv+OYdpYLrbkAtP70TW/PJQSBKIezJQw8QyhPi7fv5hOYvqIh
         rFXQ==
X-Gm-Message-State: AJIora85HLTbw/F1nkIX+ey3CY6nGdx6GfLURmOXNnNPZaEwKVfSwAJ2
        EiSUK8DuFySMkYDI2Dtry0ljPOLmI0mlxmWBIspXFxJsEdc=
X-Google-Smtp-Source: AGRyM1uXGIv2oypdMMb0kZdiNq2tc6jrAqle0xF0fVdanjMwSKuuGriweh5n3wFGSKTHxeth1/RswnNTKELc0XOzZQQ=
X-Received: by 2002:a05:6512:2315:b0:489:cbc1:886a with SMTP id
 o21-20020a056512231500b00489cbc1886amr6859122lfu.428.1657874053862; Fri, 15
 Jul 2022 01:34:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220714010021.1786616-1-mw@semihalf.com> <YtAMw7Sp06Kiv9PK@shell.armlinux.org.uk>
 <CAPv3WKcxH=b01ikuUESczWeX8SJjc2fg3GjSCp7Q8p72uSt_og@mail.gmail.com> <YtByJhYpo5BzX4GV@shell.armlinux.org.uk>
In-Reply-To: <YtByJhYpo5BzX4GV@shell.armlinux.org.uk>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Fri, 15 Jul 2022 10:34:04 +0200
Message-ID: <CAPv3WKdS-ocj_1uMC-aaw_QQ01FCb2xs-FyV2HHRG_Epd6V0CA@mail.gmail.com>
Subject: Re: [net-next: PATCH] net: dsa: mv88e6xxx: fix speed setting for
 CPU/DSA ports
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>,
        Tomasz Nowicki <tn@semihalf.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

czw., 14 lip 2022 o 21:44 Russell King (Oracle)
<linux@armlinux.org.uk> napisa=C5=82(a):
>
> On Thu, Jul 14, 2022 at 07:18:57PM +0200, Marcin Wojtas wrote:
> > Hi Russell,
> >
> > czw., 14 lip 2022 o 14:32 Russell King (Oracle)
> > <linux@armlinux.org.uk> napisa=C5=82(a):
> > >
> > > On Thu, Jul 14, 2022 at 03:00:21AM +0200, Marcin Wojtas wrote:
> > > > Commit 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX set=
ting")
> > > > stopped relying on SPEED_MAX constant and hardcoded speed settings
> > > > for the switch ports and rely on phylink configuration.
> > > >
> > > > It turned out, however, that when the relevant code is called,
> > > > the mac_capabilites of CPU/DSA port remain unset.
> > > > mv88e6xxx_setup_port() is called via mv88e6xxx_setup() in
> > > > dsa_tree_setup_switches(), which precedes setting the caps in
> > > > phylink_get_caps down in the chain of dsa_tree_setup_ports().
> > > >
> > > > As a result the mac_capabilites are 0 and the default speed for CPU=
/DSA
> > > > port is 10M at the start. To fix that execute phylink_get_caps() ca=
llback
> > > > which fills port's mac_capabilities before they are processed.
> > > >
> > > > Fixes: 3c783b83bd0f ("net: dsa: mv88e6xxx: get rid of SPEED_MAX set=
ting")
> > > > Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> > >
> > > Please don't merge this - the plan is to submit the RFC series I sent=
 on
> > > Wednesday which deletes this code, and I'd rather not re-spin the ser=
ies
> > > and go through the testing again because someone else changed the cod=
e.
> >
> > Thank for the heads-up. Are you planning to resend the series or
> > willing to get it merged as-is? I have perhaps one comment, but I can
> > apply it later as a part of fwnode_/device_ migration.
> >
> > >
> > > Marcin - please can you test with my RFC series, which can be found a=
t:
> > >
> > > https://lore.kernel.org/all/Ys7RdzGgHbYiPyB1@shell.armlinux.org.uk/
> > >
> >
> > The thing is my v2 of DSA fwnode_/device_ migration is tested and
> > ready to send. There will be conflicts (rather easy) with your
> > patchset - I volunteer to resolve it this way or another, depending on
> > what lands first. I have 2 platforms to test it with + also ACPI case
> > locally.
> >
> > I'd like to make things as smooth as possible and make it before the
> > upcoming merge window - please share your thoughts on this.
>
> I've also been trying to get the mv88e6xxx PCS conversion in, but
> it's been held up because there's a fundamental problem in DSA that
> this series is addressing.
>
> This series is addressing a faux pas on my part, where I had forgotten
> that phylink doesn't get used in DSA unless firmware specifies a
> fixed-link (or a PHY) - in other words when the firmware lacks a
> description of the link.
>
> So, what do we do...
>

Ok, thanks. I tested your patchset in 2 setups with multiple
combinations - all worked fine, so this patch can be abandoned.

I already rebased my series on top of yours, so I'll submit my v2 this way.

Best regards,
Marcin
