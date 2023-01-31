Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00DD9682271
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:00:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjAaDAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjAaDAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:00:46 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 950B314485;
        Mon, 30 Jan 2023 19:00:43 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id mc11so15275739ejb.10;
        Mon, 30 Jan 2023 19:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KB1gOc0HcUUYO3AePIdRgc9Asdr8fM6rOImlU/ZlctA=;
        b=Hxr6l7l0w8hid1jSI/mIuA828FOIZKbq7yp6Icw5g5ab69soHB8NQvs+6d7hqUTa4s
         /d/PWN3GWpaAFJ3IwnX/9cV0rkWmjsXUfEVCm92NA1y3lt4xKYx0z89PmuE2MhXHjMFh
         ny3u9OSjIpNsZr7j1GuJxxXBawtqZfBalLItiFwrXo5N0FIjadMd6DAtUo1iAu+Zm2D7
         wzcigcCtt/oXtYOh2Trh8Q5uGRZNTiKZqDiivazumsrySOgyJFezjUWau90FmxZrTtar
         VCw4WXZquVWaDeFO+hgpNbiZj/FYq9Ew28ivNr5zb9T6E0vnKZYSZttvWvoWyXDOM6TK
         FoLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KB1gOc0HcUUYO3AePIdRgc9Asdr8fM6rOImlU/ZlctA=;
        b=wUAWLQ2BYO0oPGYE0FW8h0IEgxQx5xd2DQz5xXv2f7QBR2f6pcImC3Ftn2slO837/6
         3O32ns6CTZNF0Oy+Zg+QM24fyGQu0hfgvetCWM075KGasVyjLBuXtaBW9vUXzS0n6Nm+
         np4g9M+02dkzhH0RppUS64aBWbmd23hh/HuoJobKTMYUIYDyMLbWoayUzElE2PMW+nyC
         MqGrr3Td8ChbaYdAUKqzDqCdVweAStd8uFer7l0Rj+gTL5+zWgSmx5Z/riZuntCnMtIy
         Cxg01ZQt5VAXZQkgL6FNGf5GDSoeuVwkpaAWkwfERQ0QcOFgEunkZ4HhzsjPP+FeafzL
         xhVw==
X-Gm-Message-State: AO0yUKXp33ZzIl4XeG4ynmrGEyeVvHgT4N2KskMLVr6tc6rUD/2Rb7Q2
        q0tYbvz9F3mq7wZbw5/ei8S6Q2hSbbP9CLaArxc=
X-Google-Smtp-Source: AK7set/zjqdVvHTBlPFj7JKAlCcpIE96STET1tKq8wkHLQwfe14R5p89zOB1naAdHEb6BTnZap92epc+f0+eKr4dHYg=
X-Received: by 2002:a17:906:7108:b0:87b:d4df:32bc with SMTP id
 x8-20020a170906710800b0087bd4df32bcmr3213316ejj.303.1675134041976; Mon, 30
 Jan 2023 19:00:41 -0800 (PST)
MIME-Version: 1.0
References: <20230127122018.2839-1-kerneljasonxing@gmail.com> <Y9fdRqHp7sVFYbr6@boxer>
In-Reply-To: <Y9fdRqHp7sVFYbr6@boxer>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Tue, 31 Jan 2023 11:00:05 +0800
Message-ID: <CAL+tcoBbUKO5Y_dOjZWa4iQyK2C2O76QOLtJ+dFQgr_cpqSiyQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH v2 net] ixgbe: allow to increase MTU to
 some extent with XDP enabled
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        bpf@vger.kernel.org, Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:09 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> On Fri, Jan 27, 2023 at 08:20:18PM +0800, Jason Xing wrote:
> > From: Jason Xing <kernelxing@tencent.com>
> >
> > I encountered one case where I cannot increase the MTU size directly
> > from 1500 to 2000 with XDP enabled if the server is equipped with
> > IXGBE card, which happened on thousands of servers in production
> > environment.
>

> You said in this thread that you've done several tests - what were they?

Tests against XDP are running on the server side when MTU varies from
1500 to 3050 (not including ETH_HLEN, ETH_FCS_LEN and VLAN_HLEN) for a
few days.
I choose the iperf tool to test the maximum throughput and observe the
behavior when the machines are under greater pressure. Also, I use
netperf to send different size packets to the server side with
different modes (TCP_RR/_STREAM) applied.

> Now that you're following logic from other drivers, have you tested 3k MTU

Sure, the maximum MTU size users could set is 3050 (which is 3072 - 14
- 4 - 4 in ixgbe_change_mtu() function).

> against XDP? Because your commit msg still refer to 2k as your target. If
> 3k is fine then i would reflect that in the subject of the patch.

I will modify the title and body message both.

>
> >
> > This patch follows the behavior of changing MTU as i40e/ice does.
> >
> > Referrences:
> > commit 23b44513c3e6f ("ice: allow 3k MTU for XDP")
> > commit 0c8493d90b6bb ("i40e: add XDP support for pass and drop actions")
> >
> > Link: https://lore.kernel.org/lkml/20230121085521.9566-1-kerneljasonxing@gmail.com/
>
> Why do you share a link to v1 here?

I originally intended to let maintainers trace the previous
discussion. Well, I'm going to remove the link.

>
> You're also missing Fixes: tag, as you're targetting the net tree.
>

I'll do it in the v3 patch.

Thanks,
Jason

> > Signed-off-by: Jason Xing <kernelxing@tencent.com>
> > ---
> > v2:
> > 1) change the commit message.
> > 2) modify the logic when changing MTU size suggested by Maciej and Alexander.
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index ab8370c413f3..2c1b6eb60436 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
> >                       ixgbe_free_rx_resources(adapter->rx_ring[i]);
> >  }
> >
> > +/**
> > + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
> > + * @adapter - device handle, pointer to adapter
> > + */
> > +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> > +{
> > +     if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> > +             return IXGBE_RXBUFFER_2K;
> > +     else
> > +             return IXGBE_RXBUFFER_3K;
> > +}
> > +
> >  /**
> >   * ixgbe_change_mtu - Change the Maximum Transfer Unit
> >   * @netdev: network interface device structure
> > @@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
> >  {
> >       struct ixgbe_adapter *adapter = netdev_priv(netdev);
> >
> > -     if (adapter->xdp_prog) {
> > +     if (ixgbe_enabled_xdp_adapter(adapter)) {
> >               int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
> >                                    VLAN_HLEN;
> > -             int i;
> > -
> > -             for (i = 0; i < adapter->num_rx_queues; i++) {
> > -                     struct ixgbe_ring *ring = adapter->rx_ring[i];
> >
> > -                     if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> > -                             e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > -                             return -EINVAL;
> > -                     }
> > +             if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
> > +                     e_warn(probe, "Requested MTU size is not supported with XDP\n");
> > +                     return -EINVAL;
> >               }
> >       }
> >
> > --
> > 2.37.3
> >
> > _______________________________________________
> > Intel-wired-lan mailing list
> > Intel-wired-lan@osuosl.org
> > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
