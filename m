Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E44F66B37B
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 19:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjAOSix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 13:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbjAOSiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 13:38:51 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5562112843;
        Sun, 15 Jan 2023 10:38:50 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id s8so10037562qkj.6;
        Sun, 15 Jan 2023 10:38:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dA3K3JQjPRreM+nPzpJ70e+z9tgmP77Og8tezrTxSTU=;
        b=MdITaKjcTrMAh5/3U10JvGk93Exj0vtMmlXkOLWo/GqBCUXrH5f8uwAj+Rv8pMZYGE
         ii8jXn7M0T9xp4d0//tNP4MCxPHLZR6YX61s8q3kelVpTQA77jJr2A2som0JM2kVvvwx
         yyaHJEMawG+bB1f1TX3/Jc4ZqMZr3cydQOYsYeR0pHYyn+J/tC1qfAuyS69flOFLBXW+
         zzeaQL7M+wN46K/WtdmUTVFHTCckWJ0zeWR0Eo0meOLvRZvavs1sX9dZkS8fwEfzej1Q
         SSy3dvlfxO0v7UYzFPoI/K2A2wEkljwRFzvMhg0SZWSMe52BWiAktT3X9okKeeskiiR/
         xh8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dA3K3JQjPRreM+nPzpJ70e+z9tgmP77Og8tezrTxSTU=;
        b=UgwmU1MhV0B9Ks905QiW0dgvrNdp8pXfaC9axr2JjR7FIny7SVAx7IFyQ++AJya1tY
         lGI36QfhR/eBAD4bKe1JMffBpE/G+B5Cvy+384kWSMB8wpFj072hFRqAWPjKC6ZRRgMI
         4PaydCDot6rNtp9mC9qZPofNlnQftGW0clonL0Mxr61ui0NQ3nu+4iV78mH/rDmoMmdF
         stO2R/qHFh7fFAfc9uBY+bme8vAehZ7PlnYU62EM0ij8TnQPRSYCxiVvYeH5TAgOu3ag
         xfUNaK8GA11UBmUYnJhFjXKUbHOsHNSJeqrAHtYQjxC6SZ/JdWc3VlKzgK96Xl3buAT6
         63Dw==
X-Gm-Message-State: AFqh2koyrHQQFddDObgAz0Mi1aVsvV/H+zKmJnA0c7pcPuhP6EkpXze0
        Ou8zS9WsAwg+jLvCLvGbpz/+HesT5b60519xLsQ=
X-Google-Smtp-Source: AMrXdXtaYwL2VZUH0BsVxwP2weVcIpWZTudvW2qfgwUiV3CJzmB7cAvPfZYqAik0izlKOZsyt0rlR8l+tgrIO05eMVk=
X-Received: by 2002:a37:68f:0:b0:706:4c72:42b4 with SMTP id
 137-20020a37068f000000b007064c7242b4mr223599qkg.425.1673807929200; Sun, 15
 Jan 2023 10:38:49 -0800 (PST)
MIME-Version: 1.0
References: <20230115161006.16431-1-pierluigi.p@variscite.com> <Y8QzI2VUY6//uBa/@lunn.ch>
In-Reply-To: <Y8QzI2VUY6//uBa/@lunn.ch>
From:   Pierluigi Passaro <pierluigi.passaro@gmail.com>
Date:   Sun, 15 Jan 2023 19:38:38 +0100
Message-ID: <CAJ=UCjX0YzVgedO1hDu_NsFAGhxe8HouUmHmbO6AXZqT=OUYLg@mail.gmail.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
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

On Sun, Jan 15, 2023 at 6:08 PM Andrew Lunn <andrew@lunn.ch> wrote:
> On Sun, Jan 15, 2023 at 05:10:06PM +0100, Pierluigi Passaro wrote:
> > When the reset gpio is defined within the node of the device tree
> > describing the PHY, the reset is initialized and managed only after
> > calling the fwnode_mdiobus_phy_device_register function.
> > However, before calling it, the MDIO communication is checked by the
> > get_phy_device function.
> > When this happens and the reset GPIO was somehow previously set down,
> > the get_phy_device function fails, preventing the PHY detection.
> > These changes force the deassert of the MDIO reset signal before
> > checking the MDIO channel.
> > The PHY may require a minimum deassert time before being responsive:
> > use a reasonable sleep time after forcing the deassert of the MDIO
> > reset signal.
> > Once done, free the gpio descriptor to allow managing it later.
>
> This has been discussed before. The problem is, it is not just a reset
> GPIO. There could also be a clock which needs turning on, a regulator,
> and/or a linux reset controller. And what order do you turn these on?
>
> The conclusion of the discussion is you assume the device cannot be
> found by enumeration, and you put the ID in the compatible. That is
> enough to get the driver to load, and the driver can then turn
> everything on in the correct order, with the correct delays, etc.
>
Can you provide any reference to this discussion?
From our investigation, the MDIO communication is checked before managing
the "reset" gpio .
This behaviour is generally not visible, but easily reproducible with all NXP
platforms with dual fec (iMX28, iMX6UL, iMX7, iMX8QM, iMX8QXP)
where the MDIO bus is owned by the 1st interface but shared with the 2nd.
When the 1st interface is probed, this causes the probe of the MDIO bus
when the 2nd interface is not yet set up.
Here a reference configuration
https://github.com/varigit/linux-imx/blob/5.15-2.0.x-imx_var01/arch/arm64/boot/dts/freescale/imx8qm-var-spear.dtsi#L168-L219
Without this patch, the above settings can fail simply forcing the reset GPIOs
to zero in u-boot.
Please let me know if further details are needed.
>
> I think there has been some work on generic power sequencing. I've not
> being following it, so I've no idea how far it has got. If that could
> be used to solve this problem for all the possible controls of a PHY,
> i would be open for such patches.
>
>       Andrew
