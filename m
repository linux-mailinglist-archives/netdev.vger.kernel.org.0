Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC5F526E74
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiENBXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 21:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiENBXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 21:23:13 -0400
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEBBD508F33
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:52:52 -0700 (PDT)
Received: by mail-ua1-x92f.google.com with SMTP id y2so1139135uan.4
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 17:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gh7lyMR/wwSZPN8VM7Gm13nBDOjOCSeBHsdtAIxkzG8=;
        b=V/0/Z8mBX//e4K3r0ItRdb+QOez5W2XQln5EnRm9IolusnHAblUXo5tTq1gXrjgaOQ
         h2uOoGmdQlAWavWoSg7h1u45GIg701NSi5498nSXOq4rOpruJ/GAKqNcnk1nUGSwdlUH
         KF/Jd1j27FhvkKRcNt+VDQDHFUXXZrlRDIyEPE51WCxWNi4RlSDQBmEsIkT8VjxxBV0b
         bDPbYNoTE5Wm/8XlRiWLjhfWSbYoG/1p+MWkOJdk68z8KRjORJleBHix1Qr33jg0oxdF
         eFtoXAqEfV7XKe02t4strhNLtYX/5/rc/0uVvjb2X05Tuys7X0VuVPMAtMSbS1+/HUec
         eX7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gh7lyMR/wwSZPN8VM7Gm13nBDOjOCSeBHsdtAIxkzG8=;
        b=bnTmb6uv9cGXzCBJR3Mh1nu8l4nycy7TO0DzCxpGAVaq+HOoc7NsXpIpYpYsK/dzjY
         foarLW6j6rlekkrxKuTW4hIK3GXNORXjgG5r36a8R2UYphCVtsPvPoI96enaQqbVKENq
         BRnBxCGmNTI4v6M1ZcDZWgrGcf/oFC3cUnZ9bhSPHo/rl6WMYHLfZzDDkMPDGPhJVskL
         yynJz66aA6cYybUDAnf/8DZ6i7U0lzwBpwTkFEWsS7mxAkWZevdt28EEgOp1uYPzbho+
         NZm2wdk+YsVzxOguSyNsj5FQ4ACnwYHYN2MAcTsvW7dkHa7OYrSKTCL8kesYRggmAasO
         F2wQ==
X-Gm-Message-State: AOAM5313o+0jzkyz6hIMSMde3ps3IxSoXLSV7xxtsraa8AI85iFwdRRr
        9bUMct/bvZ2fXEvsTH56e7TWlK3BaFaU4UqwvYE67+7QBmQ=
X-Google-Smtp-Source: ABdhPJzCWv0a5whfDvG5f1fLXqD8nN3mfB3Ex3KVjsax4u4aVTZ/7ict9ABMT/pHleIA0/+WB0eCT0OjzJ1BqwVO5x8=
X-Received: by 2002:a25:504c:0:b0:64b:979c:1bae with SMTP id
 e73-20020a25504c000000b0064b979c1baemr5408913ybb.563.1652488799877; Fri, 13
 May 2022 17:39:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220513233640.2518337-1-vladimir.oltean@nxp.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 13 May 2022 17:39:24 -0700
Message-ID: <CAGETcx9Q-yXpdai+Ujg+-gMGyHbSO=ws+e7ejqDSmJs5tQRLNQ@mail.gmail.com>
Subject: Re: [RFC PATCH net 0/2] Make phylink and DSA wait for PHY driver that
 defers probe
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <jstultz@google.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 4:37 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> This patch set completes the picture described by
> '[RFC,devicetree] of: property: mark "interrupts" as optional for fw_devlink'
> https://patchwork.kernel.org/project/netdevbpf/patch/20220513201243.2381133-1-vladimir.oltean@nxp.com/

I replied to that patch. I don't think we can pull that in.

> I've CCed non-networking maintainers just in case they want to gain a
> better understanding. If not, apologies and please ignore the rest.
>
>
>
> My use case is to migrate a PHY driver from poll mode to interrupt mode
> without breaking compatibility between new device trees and old kernels
> which did not have a driver for that IRQ parent, and therefore (for
> things to work) did not even have that interrupt listed in the "vintage
> correct" DT blobs. Note that current kernels as of today are also
> "old kernels" in this description.
>
> Creating some degree of compatibility has multiple components.
>
> 1. A PHY driver must eventually give up waiting for an IRQ provider,
>    since the dependency is optional and it can fall back to poll mode.
>    This is currently supported thanks to commit 74befa447e68 ("net:
>    mdio: don't defer probe forever if PHY IRQ provider is missing").
>
> 2. Before it finally gives up, the PHY driver has a transient phase of
>    returning -EPROBE_DEFER. That transient phase causes some breakage
>    which is handled by this patch set, details below.
>
> 3. PHY device probing and Ethernet controller finding it and connecting
>    to it are async events. When both happen during probing, the problem
>    is that finding the PHY fails if the PHY defers probe, which results
>    in a missing PHY rather than waiting for it. Unfortunately there is
>    no universal way to address this problem, because the majority of
>    Ethernet drivers do not connect to the PHY during probe. So the
>    problem is fixed only for the driver that is of interest to me in
>    this context, DSA, and with special API exported by phylink
>    specifically for this purpose, to limit the impact on other drivers.

I'll take a closer look at this later this week, but once we add
phy-handle support to fw_devlink (the device_bind_driver() is making
it hard to add support), I think we can address most/all of these
problems automatically. So hopefully we can work towards that?
Actually this patch might already fix this for you:
https://lore.kernel.org/lkml/20220429220933.1350374-1-saravanak@google.com/

Before fw_devlink, we'd give up on waiting on all suppliers, whether
they had a driver (but hadn't yet probed for a multitude of reasons)
or not. fw_devlink is smart about allowing consumers to probe without
their suppliers only if the supplier has no driver or the driver fails
(I'll send a patch for this). The deferred_probe_timeout is what's
used to decide when to give up waiting for drivers.

-Saravana

>
> Note that drivers that connect to the PHY at ndo_open are superficially
> "fixed" by the patch at step 1 alone, and therefore don't need the
> mechanism introduced in phylink here. This is because of the larger span
> of time between PHY probe and opening the network interface (typically
> initiated by user space). But this is the catch, nfsroot and other
> in-kernel networking users can also open the net device, and this will
> still expose the EPROBE_DEFER as a hard error for this second kind of
> drivers. I don't know how to fix that. From this POV, it's better to do
> what DSA does (connect to the PHY on probe).
>
> Vladimir Oltean (2):
>   net: phylink: allow PHY driver to defer probe when connecting via OF
>     node
>   net: dsa: wait for PHY to defer probe
>
>  drivers/net/phy/phylink.c | 73 ++++++++++++++++++++++++++++++---------
>  include/linux/phylink.h   |  2 ++
>  net/dsa/dsa2.c            |  2 ++
>  net/dsa/port.c            |  6 ++--
>  net/dsa/slave.c           | 10 +++---
>  5 files changed, 70 insertions(+), 23 deletions(-)
>
> --
> 2.25.1
>
