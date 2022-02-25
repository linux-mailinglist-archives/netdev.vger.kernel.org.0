Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE39A4C3A9A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 01:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236115AbiBYA6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 19:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiBYA6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 19:58:20 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA7518C79D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 16:57:49 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j7so6779418lfu.6
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 16:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w76VyCLNjCNjgyDe2C/fhnjmx1UCmS0n3lxCwRttFPA=;
        b=VwTElvDPyYA5LrjoWodLnDLFdZKSA6sRUdSxjwcvpbHogB1pED2nIRh/gIABUsupaK
         ebAwMAxIWr9SYNQtoESuDEM+zbUHZgDnOF3gcNXeW7X0ubApEQl9PKsitDs4f5VmCOF2
         Q8/KHvt26KAveqZ7BTCDKiEPHB/cvRy2QUiBc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w76VyCLNjCNjgyDe2C/fhnjmx1UCmS0n3lxCwRttFPA=;
        b=orLmRY3lZGChPWTsg1932xP3omotcwP4JiCIlNXWtAAyKJYDoInN5YwdvAylgFo/JJ
         er1E6vKlI8vp9D5WriE/Vl785vX33Os4q4xxsH/zbtJbx6HpdfTUBpV0xaE9Eff5qfu5
         MHWMjlyYeAVqWmdbbOu4kLVl8QmLbjGJiBgQd7cffN/wLUM66Q8DpfBZYARciNwQPpaQ
         Jx974HsTCqt6sP7M9Cci8E+CMRsBh143kDySojexr++U/YufP/m3eCU4QsB3idNg5Y3N
         kPZ/e0HXxnGVy3YF76hBOFGuOElf9lkn1imUUWm7ifmGuS0gA5enH3zW9wZhWHJVwj6X
         IuUA==
X-Gm-Message-State: AOAM531xF6pYBhoQ9iMu2ab41WJKZhfb8FDlCWjJWd8UXnfqwUwBNxxA
        NwvtzxCAn2CSo4vNB1T2b7lcvOVNBHoO7hY9wAp1Dg==
X-Google-Smtp-Source: ABdhPJxU2kKUusLSIMTHq0QV+2ABUUmfQO6RVCH0H0SZsHcJzpV6rdbUs/5rDFYl8ov/yb8fImEDTGOW+ni1rP84ixg=
X-Received: by 2002:a05:6512:692:b0:437:9580:9ab5 with SMTP id
 t18-20020a056512069200b0043795809ab5mr3364075lfe.689.1645750667679; Thu, 24
 Feb 2022 16:57:47 -0800 (PST)
MIME-Version: 1.0
References: <20220218234536.9810-1-dmichail@fungible.com> <20220218234536.9810-5-dmichail@fungible.com>
 <Yhfq1N7ce/adhmN9@lunn.ch>
In-Reply-To: <Yhfq1N7ce/adhmN9@lunn.ch>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 24 Feb 2022 16:57:36 -0800
Message-ID: <CAOkoqZmTc6y=qn8WeFmcupPOncCmSSEMgbXPUtR80zyRhn=qdA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 4/8] net/funeth: ethtool operations
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 12:30 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static void fun_link_modes_to_ethtool(u64 modes,
> > +                                   unsigned long *ethtool_modes_map)
> > +{
> > +#define ADD_LINK_MODE(mode) \
> > +     __set_bit(ETHTOOL_LINK_MODE_ ## mode ## _BIT, ethtool_modes_map)
> > +
> > +     if (modes & FUN_PORT_CAP_AUTONEG)
> > +             ADD_LINK_MODE(Autoneg);
> > +     if (modes & FUN_PORT_CAP_1000_X)
> > +             ADD_LINK_MODE(1000baseX_Full);
> > +     if (modes & FUN_PORT_CAP_10G_R) {
> > +             ADD_LINK_MODE(10000baseCR_Full);
> > +             ADD_LINK_MODE(10000baseSR_Full);
> > +             ADD_LINK_MODE(10000baseLR_Full);
> > +             ADD_LINK_MODE(10000baseER_Full);
> > +     }
>
> > +static unsigned int fun_port_type(unsigned int xcvr)
> > +{
> > +     if (!xcvr)
> > +             return PORT_NONE;
> > +
> > +     switch (xcvr & 7) {
> > +     case FUN_XCVR_BASET:
> > +             return PORT_TP;
>
> You support twisted pair, so should you also have the BaseT_FULL link
> modes above?

I agree with that but FW currently doesn't report BASE-T speeds in its
port capabilities and the link modes are based on them. Looks simple to fix
but needs future FW.

> > +static void fun_get_pauseparam(struct net_device *netdev,
> > +                            struct ethtool_pauseparam *pause)
> > +{
> > +     const struct funeth_priv *fp = netdev_priv(netdev);
> > +     u8 active_pause = fp->active_fc;
> > +
> > +     pause->rx_pause = !!(active_pause & FUN_PORT_CAP_RX_PAUSE);
> > +     pause->tx_pause = !!(active_pause & FUN_PORT_CAP_TX_PAUSE);
> > +     pause->autoneg = !!(fp->advertising & FUN_PORT_CAP_AUTONEG);
>
> pause->autoneg is if you are negotiating pause via autneg, not if you
> are doing autoneg in general. The user can set pause autoneg to false, via

Indeed, overall AN and pause AN are separate controls. But because of current
FW limitation they need to have the same value and pause AN == overall AN.

> ethtool -A|--pause devname [autoneg on|off]
>
> but the link can still negotiate speed, duplex etc. But then it gets
> more confusing with the following code:
>
> > +}
> > +
> > +static int fun_set_pauseparam(struct net_device *netdev,
> > +                           struct ethtool_pauseparam *pause)
> > +{
> > +     struct funeth_priv *fp = netdev_priv(netdev);
> > +     u64 new_advert;
> > +
> > +     if (fp->port_caps & FUN_PORT_CAP_VPORT)
> > +             return -EOPNOTSUPP;
> > +     /* Forcing PAUSE settings with AN enabled is unsupported. */
> > +     if (!pause->autoneg && (fp->advertising & FUN_PORT_CAP_AUTONEG))
> > +             return -EOPNOTSUPP;
>
> This seems wrong. You don't advertise you cannot advertise. You simply
> don't advertise. It could just be you have a bad variable name here?

advertising & FUN_PORT_CAP_AUTONEG means that AN is enabled, and
when this bit is off AN is disabled.
When AN is enabled FW doesn't allow forcing pause hence this combination is
rejected. I changed it to be this way after the discussion we had last time.

> > +     if (pause->autoneg && !(fp->advertising & FUN_PORT_CAP_AUTONEG))
> > +             return -EINVAL;
>
> So it should be, you have the capability to advertise pause, not that
> you have the ability to advertise advertising. And it sounds like the
> ability to advertise pause is hard coded on.

It's just the AN on/off state, it's not trying to advertise
advertising. When it's on
pause AN is indeed forced on.

> > +static void fun_get_ethtool_stats(struct net_device *netdev,
> > +                               struct ethtool_stats *stats, u64 *data)
> > +{
> > +     const struct funeth_priv *fp = netdev_priv(netdev);
> > +     struct funeth_txq_stats txs;
> > +     struct funeth_rxq_stats rxs;
> > +     struct funeth_txq **xdpqs;
> > +     struct funeth_rxq **rxqs;
> > +     unsigned int i, start;
> > +     u64 *totals, *tot;
> > +
> > +     if (!netif_running(netdev))
> > +             return;
>
> Why this limitation? I don't expect the counters to increment, but
> they should still indicate the state when the interface was configured
> down.

Most of the counters are queue counters and the queues are deleted when the
net device is down. That was there to prevent attempting to walk non-existing
queues. It's not needed, the condition is handled by another if further down.
I've removed this, at least you get the last MAC stats now.

>
>         Andrew
