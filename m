Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8020B3F52D5
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 23:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232785AbhHWVYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 17:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhHWVYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 17:24:51 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86EAFC061575
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 14:24:08 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id n126so23503006ybf.6
        for <netdev@vger.kernel.org>; Mon, 23 Aug 2021 14:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uJjeKSkgby3iQrQ4F/SDYPht7MD2Q8GYvEFjrosPPjs=;
        b=uNC3ugx1fahJMDiuD72VScZAm7i1AYgFL4e8dJqxkcgcZSA/vnDABtZH8hWj63UMvd
         86QpaMgXSwt2VryaWON03S2k0vO/ZoDU7Dr+Ch1JyG2iSeWJ4eGBBENATBiaOI3iz6H3
         g0CDxP+LhhTXALF5GtuspX6XeWJug3N1bqvSOKKGLaR4GqNgs0tKeop9rGAT2M+cfAr5
         BzyLxZFU9SPpGLOaNrFIr7fr083DmKr4/d0IE7lUenemNtJZg3aep1FAsbhaIctBwkqI
         RnOidfFcYErrMyzJxA7WLuODU16ZAjWh3Obehr5GfiSjj1/++VRaIBXaYr8PGyi37+If
         4/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uJjeKSkgby3iQrQ4F/SDYPht7MD2Q8GYvEFjrosPPjs=;
        b=VpSlJ1+rbqMYooSx3k7MfD+mK/RYcl5A4a7LQi18tPweLmiTbW4AmQ5493Mrh/JrNi
         kbdPOguyM5i9Xq6aa5q3w+RrNSAx6Rfx0wZo7Qn+/pYshn/lMoCMDSr+G6g+8IIpP3k1
         6qN1Cu3wwIPCEliYwEetXRgV2pVmjyq/EqPiyqhuvxVszVKZAb1wZSr/Dq5Hmf/iIujU
         hmPFxcSODuUcht8m4YPu+atCcEyf0T+zGdxDfhcX3IBk8HtWBcsTqE48GO0dU5YHKCD6
         fESfsmR8IkMxrm7m3Uzt0pxfdP454vQ9MFsIorQ+sezwhOmOnFEqde8CRQ1krX8k5jP4
         Q0Kg==
X-Gm-Message-State: AOAM532pkVY4if5Xc0ttG1HnbgGPL1FbX0rJiKvtcj2OuLFAYnq8hNHj
        pnrggmB71Y1fJO3U483czK6eiUIkdsK+Aqd8DWvvsw==
X-Google-Smtp-Source: ABdhPJy9TY7G10aHfYaF3aPKAyt2DdBEYhwqtDPQxWeXUNxi3Y3qAhhc/N9Z2osMFS5qPtjPuug+iaNTMaUcbrqXXsU=
X-Received: by 2002:a25:d2c8:: with SMTP id j191mr389470ybg.412.1629753847570;
 Mon, 23 Aug 2021 14:24:07 -0700 (PDT)
MIME-Version: 1.0
References: <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf> <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk> <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk> <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
 <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
 <14891624-655b-a71d-dc04-24404e0c2e1a@bang-olufsen.dk> <CAGETcx-7xgt5y_zNHzSMQf4YFCmWRPfP4_voshbNxKPgQ=b1tA@mail.gmail.com>
 <YSQIjtkJPg3lFg7t@lunn.ch>
In-Reply-To: <YSQIjtkJPg3lFg7t@lunn.ch>
From:   Saravana Kannan <saravanak@google.com>
Date:   Mon, 23 Aug 2021 14:23:31 -0700
Message-ID: <CAGETcx87mF=_90B_30tgTkMcFDPX6Lk2FRfA1d-G+x=Wuw2FLA@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 1:44 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I thought about this in the background the past few days. I think
> > there are a couple of options:
> > 1. We (community/Andrew) agree that this driver would only work with
> > fw_devlink=on and we can confirm that the other upstream uses of
> > "realtek,rtl8366rb" won't have any unprobed consumers problem and
> > switch to using my patch. Benefit is that it's a trivial and quick
> > change that gets things working again.
>
> I don't think realtek,rtl8366rb is doing anything particularly
> unusual. It is not the only switch driver with an MDIO bus driver with
> its internal PHYs on it.

But realtek,rtl8366rb is doing some unusual things though:
1. Expecting its child devices would get probed as soon as they are
added in its own probe().
2. The child device in turn depends on the parent node to have probed
(the interrupt dependency in this case).

There is absolutely no guarantee from the driver core that (1) would
happen. In fact, it's more likely for this to not happen.
(2) isn't fully wrong, but it's kinda weird when combined with (1)
because it causes a quasi cyclic dependency.

>
> > 2. The "realtek,rtl8366rb" driver needs to be fixed to use a
> > "component device".
>
> Again, i don't think "realtek,rtl8366rb is doing anything unusual,
> compared to the other DSA drivers. If you are suggesting it needs to
> make use of the component driver, you might also be suggesting that
> all the switch drivers need to be component devices.

I'm saying any driver that does both (1) and (2) above needs to start
using the component devices. Otherwise, it is using a broken driver
model AND it'll be caught/enforced by fw_devlink=on. Even just doing
(1) is wrong, but fw_devlink=on doesn't catch/enforce it.

> I don't fully
> understand the details here, but it might be, you are also suggesting
> some Ethernet drivers need modifying to use the component framework?

I'm not sure if I'm saying that and more likely I'm NOT saying that
(see further below). Based on link [1] I think it's actually the
opposite of point (1) above. IIUC, in the case of FEC, you don't want
the child to probe before the parent is done (because the child
depends on the parent) and fw_devlink=on actually enforces that.

What I'm pointing out is that since dsa_register_switch() is assuming
the PHYs are ready/attaches to PHYs when it's called, if ALL the
following conditions are met, a DSA switch driver needs to use a
component driver model:
1. Switches that have child PHYs that dsa_register_switch() will
attach to when called.
2. The child PHYs depend on services provided by the parent (eg:
interrupt controller)

I don't know much about dsa_register_switch(), but if the DSA
framework could NOT attempt to attach to PHYs as soon as the switch is
registered, that might solve the problem too without needing to use
the component driver model as that'll break the cyclic dependency.

> And that is not going to fly.
>
> This has all worked until now, things might need a few iterations with
> deferral, but we get there in the end.

A few deferred probes is totally fine and fw_devlink doesn't have any
issues with that. In fact, fw_devlink would cut down on some
unnecessary deferred probes [1]. I think you are mixing two different
cases. This case is not the same as [1]. In the case of this realtek
switch driver, it's saying the deferred probe of its child PHYs is NOT
allowed. And I'm saying that's not a valid assumption and the
component device model seems like one good way to handle this
situation.

> Maybe we need to back out the
> phy-handle patch? It does appear to be causing regressions.

I don't mind if you want to do that (fixing the issue Marek reported
is easy). But that doesn't mean this realtek driver isn't wrong and
needs to be fixed. It's just that fw_devlink=on is catching this more
clearly.

[1] - https://lore.kernel.org/netdev/CAGETcx9=AyEfjX_-adgRuX=8a0MkLnj8sy2KJGhxpNCinJu4yA@mail.gmail.com/

-Saravana
