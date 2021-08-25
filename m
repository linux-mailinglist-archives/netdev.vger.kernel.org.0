Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A193F6FA3
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 08:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239272AbhHYGgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 02:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238843AbhHYGgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 02:36:15 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDF2C061757;
        Tue, 24 Aug 2021 23:35:30 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id e15so18995444qtx.1;
        Tue, 24 Aug 2021 23:35:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5wA7aNOTXP+Y+al0rHQG+1sA1f1Ihy6VxwekY9Btnk=;
        b=iNhptUYApDmWVR9/kxA2NJILtiGqdNuKxWxkcICQDZlpakv72q9iGgCgpPO/py4qbL
         5dJkOGHGOsm8qwMXV/vOMmrLpR381UCZIzd3ug9N1j61yjY7SsArccQ/uYhs5nP3QTPA
         1g8YX8Mb1MWrNYPo7FZDsFzbfu4U3rk52yhqQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e5wA7aNOTXP+Y+al0rHQG+1sA1f1Ihy6VxwekY9Btnk=;
        b=JBWjJU1Y8n+GpBQHbRQMkTpSQ1fWTIQ0+J7LLvf82Lc/PO5USmaDMdManTbUBFFEva
         tlraCsNEcGhLZccqh/OSsQiNl1lIDU3BpneP090Dr2tnga3e2qMxZswYH+O6D3tDtrCq
         itGxEvTbO41iBCeRi93PdEdOPCtN0qHc54286Cq+aOPLJZf/NAHS3DXMFes5onuPVjRP
         8zHBhRhBmHk9rbDZJcyYLs7GoBRX8znLDbLpQVyAFEbzZnTShQm5Roi5wEVMsPUQPvov
         kDAugkr8HC760BhjoWDTJ3NSDhbP/2pEXYPVrq32Rtob3OQWVYatKvrrb6FrmVDT5Ef0
         x/9Q==
X-Gm-Message-State: AOAM530/YqQXquVGXakc0gzQUEBkYRefohdMiGtxr9sLWOpg649fcFtp
        IbQAM5okzAiNZ35LmzlhTa2LUOBym2TlDdPLKrM=
X-Google-Smtp-Source: ABdhPJzoQd1eVp0Nn8cXdqG70rpQMroeT9FhJwqNIOeYfwtsRZmSWCp7ZGquB/gZIrsUByLbU5N0LQNDy4Fj+3RjN2c=
X-Received: by 2002:ac8:4b64:: with SMTP id g4mr36120313qts.263.1629873329235;
 Tue, 24 Aug 2021 23:35:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210820074726.2860425-3-joel@jms.id.au> <YSVLz0Se+hTVr0DA@errol.ini.cmu.edu>
In-Reply-To: <YSVLz0Se+hTVr0DA@errol.ini.cmu.edu>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 25 Aug 2021 06:35:17 +0000
Message-ID: <CACPK8Xf9LGQBUHmS9sQ4zG1akk5SoQ-31MD-GMWVSRuByAT7KQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: Add driver for LiteX's LiteEth network interface
To:     "Gabriel L. Somlo" <gsomlo@gmail.com>,
        Florent Kermarrec <florent@enjoy-digital.fr>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Shah <dave@ds0.me>, Stafford Horne <shorne@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Aug 2021 at 19:43, Gabriel L. Somlo <gsomlo@gmail.com> wrote:
>
> Hi Joel,
>
> Couple of comments below:
>
> On Fri, Aug 20, 2021 at 05:17:26PM +0930, Joel Stanley wrote:

> > diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> > new file mode 100644
> > index 000000000000..265dba414b41
> > --- /dev/null
> > +++ b/drivers/net/ethernet/litex/Kconfig

> > +
> > +config LITEX_LITEETH
> > +     tristate "LiteX Ethernet support"
>
> Mostly cosmetic, but should there be a "depends on LITEX" statement in here?

No, there's as there is no dependency on the litex soc driver.

> Maybe also "select MII" and "select PHYLIB"?

Again, there is no mii or phy code so the driver doesn't need these.

> > diff --git a/drivers/net/ethernet/litex/Makefile b/drivers/net/ethernet/litex/Makefile
> > new file mode 100644
> > index 000000000000..9343b73b8e49
> > --- /dev/null
> > +++ b/drivers/net/ethernet/litex/Makefile
> > +int liteeth_setup_slots(struct liteeth *priv)
> > +{
> > +     struct device_node *np = priv->dev->of_node;
> > +     int err, depth;
> > +
> > +     err = of_property_read_u32(np, "rx-fifo-depth", &depth);
> > +     if (err) {
> > +             dev_err(priv->dev, "unable to get rx-fifo-depth\n");
> > +             return err;
> > +     }
> > +     if (depth < LITEETH_BUFFER_SIZE) {
>
> If I set depth to be *equal* to LITEETH_BUFFER_SIZE (2048) in DTS,
> no traffic makes it out of my network interface (linux-on-litex-rocket
> on an ecpix5 board, see github.com/litex-hub/linux-on-litex-rocket).
>
> May I suggest rejecting if (depth / LITEETH_BUFFER_SIZE < 2) instead?
> When that's enforced, the interface actually works fine for me.

Yes, I was using BUFFER_SIZE as the slot size, which it is not. I'll
rework it to use the slot size I think.

I spent some time digging through the migen source and I couldn't work
out where the 1024 length comes from. If anything it should be
eth_mtu, which is 1530.

Florent, can you clear that up?

>
> > +             dev_err(priv->dev, "invalid tx-fifo-depth: %d\n", depth);
>
> This should read "rx-fifo-depth".

Thanks.

>
> > +             return -EINVAL;
> > +     }
> > +     priv->num_rx_slots = depth / LITEETH_BUFFER_SIZE;
> > +
> > +     err = of_property_read_u32(np, "tx-fifo-depth", &depth);
> > +     if (err) {
> > +             dev_err(priv->dev, "unable to get tx-fifo-depth\n");
> > +             return err;
> > +     }
> > +     if (depth < LITEETH_BUFFER_SIZE) {
>
> Ditto reject if (depth / LITEETH_BUFFER_SIZE < 2) instead.
>
> > +             dev_err(priv->dev, "invalid rx-fifo-depth: %d\n", depth);
>
> This should read "tx-fifo-depth".

Ack.

>
> > +             return -EINVAL;
> > +     }
> > +     priv->num_tx_slots = depth / LITEETH_BUFFER_SIZE;
> > +
> > +     return 0;
> > +}
> > +
> > +static int liteeth_probe(struct platform_device *pdev)
> > +{
> > +     struct net_device *netdev;
> > +     void __iomem *buf_base;
> > +     struct resource *res;
> > +     struct liteeth *priv;
> > +     int irq, err;
> > +
> > +     netdev = devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
> > +     if (!netdev)
> > +             return -ENOMEM;
> > +
> > +     SET_NETDEV_DEV(netdev, &pdev->dev);
> > +     platform_set_drvdata(pdev, netdev);
> > +
> > +     priv = netdev_priv(netdev);
> > +     priv->netdev = netdev;
> > +     priv->dev = &pdev->dev;
> > +
> > +     irq = platform_get_irq(pdev, 0);
> > +     if (irq < 0) {
> > +             dev_err(&pdev->dev, "Failed to get IRQ %d\n", irq);
> > +             return irq;
>
> At this point, netdev has been dynamically allocated, and should
> probably be free'd before liteeth_probe() is allowed to fail,
> to avoid any potential leaks...

We use the managed variant of alloc_etherdev, which means the
structure is freed by the driver core when the driver is removed. This
saves having to open code the cleanup/free code.

Have a read of Documentation/driver-api/driver-model/devres.rst for
more information.

Thanks for the review Gabriel. I'll send a v3 with some fixes for the
fifo buffer handling.

Cheers,

Joel
