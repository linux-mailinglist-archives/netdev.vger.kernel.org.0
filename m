Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92E53E454E
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 14:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhHIMGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 08:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbhHIMEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 08:04:11 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9E8C0613D3;
        Mon,  9 Aug 2021 05:03:51 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id y130so5340924qkb.6;
        Mon, 09 Aug 2021 05:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vOrmXw6xMZz6x2vI7mFxWDMo2fJoo8txxv+fx5TuKHI=;
        b=Izc0XFr/vVLcC5AtUwCgx/4jqGzyuoqcGztO1p4kjKnxPK68oYrhwm9+HY0jGq/0rP
         WGPj9XBEPRODYOBPyGmdfNo5fAFu8Q7ykHj0yy8bZS68YKajPxzLoZR2ansWoAcfaC0C
         nkUQR8NbGe9PoaXa0YrpXYcrj1Q0OJajSbtTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vOrmXw6xMZz6x2vI7mFxWDMo2fJoo8txxv+fx5TuKHI=;
        b=cB3RaBYqojMpZq+VWDnU8MAqdafrzRNOPjbn63vjvURGpHtzn59VhrJKtEEek38MQa
         /Mj3MdXeX8Gdp6M/kG0yOTEtu2OUwxuKuoxEyo1LtSfyNCAsZLmQ4B6ycJa6iLM69CLF
         WmIlZ4x0kKHTtCok1tZD6bjBCdYlmJbbs9hMtQ6smxWu9w8KKnpGjoFrIuTCJ16qkLX8
         iz4g1PE60Px201Ccxy6V0XK6tL+5pk6SG3Hx05KszOdbgitax2qlPXgtOce4mvCIfja6
         W9usSuj3HclggVP7DFfhaQwNnQqRpuFXyOYV8m38qycG9O2P3sGnj+Q1CmIJX1zmD8su
         jecA==
X-Gm-Message-State: AOAM530iP2w2ygE0ce+mOFZDmPpxq7Gk3f6jCX9tOoU2EXn3zqAOcZ/0
        MDKIXbPrVtMPUWYfnvStZpLdRAzRSpWaaeHNk4A=
X-Google-Smtp-Source: ABdhPJwtvid5gqf7+QI1oj9Cie1nf6YXVEoRhE2++B1JGzipCkBMZfulQeetLDkW12/5AIhsY5pzpcPnVyt+yfTWhg8=
X-Received: by 2002:a37:a4c4:: with SMTP id n187mr18359865qke.55.1628510629375;
 Mon, 09 Aug 2021 05:03:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210806054904.534315-1-joel@jms.id.au> <20210806054904.534315-3-joel@jms.id.au>
 <20210806161030.52a7ae93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210806161030.52a7ae93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Joel Stanley <joel@jms.id.au>
Date:   Mon, 9 Aug 2021 12:03:36 +0000
Message-ID: <CACPK8XcCjNWm=85uXX2tubP=WAgfF8ewqMAMWO_wJVeHB-U_0w@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network interface
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Gabriel Somlo <gsomlo@gmail.com>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review Jakub.

On Fri, 6 Aug 2021 at 23:10, Jakub Kicinski <kuba@kernel.org> wrote:
> > +static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> > +{
> > +     struct liteeth *priv = netdev_priv(netdev);
> > +     void __iomem *txbuffer;
> > +     int ret;
> > +     u8 val;
> > +
> > +     /* Reject oversize packets */
> > +     if (unlikely(skb->len > MAX_PKT_SIZE)) {
> > +             if (net_ratelimit())
> > +                     netdev_dbg(netdev, "tx packet too big\n");
> > +             goto drop;
> > +     }
> > +
> > +     txbuffer = priv->tx_base + priv->tx_slot * LITEETH_BUFFER_SIZE;
> > +     memcpy_toio(txbuffer, skb->data, skb->len);
> > +     writeb(priv->tx_slot, priv->base + LITEETH_READER_SLOT);
> > +     writew(skb->len, priv->base + LITEETH_READER_LENGTH);
> > +
> > +     ret = readl_poll_timeout_atomic(priv->base + LITEETH_READER_READY, val, val, 5, 1000);
>
> Why the need for poll if there is an interrupt?
> Why not stop the Tx queue once you're out of slots and restart
> it when the completion interrupt comes?

That makes sense.

In testing I have not been able to hit the LITEETH_READER_READY
not-ready state. I assume it's there to say that the slots are full.

>
> > +     if (ret == -ETIMEDOUT) {
> > +             netdev_err(netdev, "LITEETH_READER_READY timed out\n");
>
> ratelimit this as well, please
>
> > +             goto drop;
> > +     }
> > +
> > +     writeb(1, priv->base + LITEETH_READER_START);
> > +
> > +     netdev->stats.tx_bytes += skb->len;
>
> Please count bytes and packets in the same place

AFAIK we don't know the length when the interrupt comes in, so we need
to count both here in xmit?

>
> > +     priv->tx_slot = (priv->tx_slot + 1) % priv->num_tx_slots;
> > +     dev_kfree_skb_any(skb);
> > +     return NETDEV_TX_OK;
> > +drop:
> > +     /* Drop the packet */
> > +     dev_kfree_skb_any(skb);
> > +     netdev->stats.tx_dropped++;
> > +
> > +     return NETDEV_TX_OK;
> > +}
