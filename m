Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165D066B45C
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 23:33:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjAOWdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 17:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjAOWdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 17:33:44 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A111E9C1;
        Sun, 15 Jan 2023 14:33:43 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id y8so18566441qvn.11;
        Sun, 15 Jan 2023 14:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PFKSzjkxvB/mlkvHAJr5Uw0FSkGRIzDY5XBNi8/DRKg=;
        b=oWhqG3k4CpBHY9jWeLVs6Menj7FPZdZ3rMwdyN01tclsoaZhf4XSXaatc7wXFnEQeU
         +Sz3BVStBFAobDBF84N/bt8RgWqfAPPHLnc/D9sc/4hVgKidgyIisZstLaq0pi6i00fp
         +GPhUU/csQSe/2TTsobZw96JmvhSIUcfNGtSqh8xsxvuBBdYI5vbCb+ySqyo9s2+gK5j
         8PxIdM5sfa59Ct895ChSuECIdDSSddKZJY8umLRpegIGRypaHCfwFUC666x9rz2lj4rM
         XLUamtIX6ECS9tBD6jWwSo6gTjw9vIcoHcZLw+3cInLtnbAYfwL0B9L3ra8FosKjXHep
         T5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PFKSzjkxvB/mlkvHAJr5Uw0FSkGRIzDY5XBNi8/DRKg=;
        b=DASo/f4GBqlKcd9fdSCxv60qadZ1QxPArR6ZyjtKh8cjzNGWthjqNrKo+z17DB1kEo
         7rzmFime7ey3xM99zLg0vn4ty758/5QRDLvagnFg+O+gEtzx+lelk0cNzZOReR+FgjxL
         XcyS9SUo1TTvZ8CgWAPJpY/KcRk1fPhekzjtwY/AY94lu38XRS9VlmEu4Zep9pT6MVEx
         uWJcNE5E5IMQratze/b4A26CXnBjTObcEAtQ5ej1KT05jz7ssHj2xDnY8JCneKoGPmQ0
         kMex5fYQeCDJ7xSNKcUZHakiTSLwverjiWlD+XD48nuIxY3pjygDhz6HsvpPrupuIsu5
         gnHg==
X-Gm-Message-State: AFqh2kqViHcgzBm7Ho9zn4Xt8GhPozeyXyXHCcgLnKiiAWEYVoL/U9Uy
        6OHPygzqe0FKJnaHKT9OHFirH1VjLWYgkLsufoo=
X-Google-Smtp-Source: AMrXdXtqLhlCnEc+AfNTHS5CF1Cpb4RLNy4pbdGH7qUzPwkoDeHPSFc/t4M1DXIPKHMJL7iUmN8+Kq2JTI869X49ETg=
X-Received: by 2002:a05:6214:2dc7:b0:532:8c6:4552 with SMTP id
 nc7-20020a0562142dc700b0053208c64552mr3103594qvb.107.1673822022618; Sun, 15
 Jan 2023 14:33:42 -0800 (PST)
MIME-Version: 1.0
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch> <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
In-Reply-To: <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
From:   Pierluigi Passaro <pierluigi.passaro@gmail.com>
Date:   Sun, 15 Jan 2023 23:33:31 +0100
Message-ID: <CAJ=UCjUo3t+D9S=J_yEhxCOo5OMj3d-UW6Z6HdwY+O+Q6JO0+A@mail.gmail.com>
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
To:     Lars-Peter Clausen <lars@metafoo.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, eran.m@variscite.com,
        nate.d@variscite.com, francesco.f@variscite.com,
        pierluigi.p@variscite.com
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

On Sun, Jan 15, 2023 at 10:59 PM Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 1/15/23 09:08, Andrew Lunn wrote:
> > On Sun, Jan 15, 2023 at 05:10:06PM +0100, Pierluigi Passaro wrote:
> >> When the reset gpio is defined within the node of the device tree
> >> describing the PHY, the reset is initialized and managed only after
> >> calling the fwnode_mdiobus_phy_device_register function.
> >> However, before calling it, the MDIO communication is checked by the
> >> get_phy_device function.
> >> When this happen and the reset GPIO was somehow previously set down,
> >> the get_phy_device function fails, preventing the PHY detection.
> >> These changes force the deassert of the MDIO reset signal before
> >> checking the MDIO channel.
> >> The PHY may require a minimum deassert time before being responsive:
> >> use a reasonable sleep time after forcing the deassert of the MDIO
> >> reset signal.
> >> Once done, free the gpio descriptor to allow managing it later.
> > This has been discussed before. The problem is, it is not just a reset
> > GPIO. There could also be a clock which needs turning on, a regulator,
> > and/or a linux reset controller. And what order do you turn these on?
> >
> > The conclusions of the discussion is you assume the device cannot be
> > found by enumeration, and you put the ID in the compatible. That is
> > enough to get the driver to load, and the driver can then turn
> > everything on in the correct order, with the correct delays, etc.
>
> I've been running into this same problem again and again over the past
> years.
>
> Specifying the ID as part of the compatible string works for clause 22
> PHYs, but for clause 45 PHYs it does not work. The code always wants to
> read the ID from the PHY itself. But I do not understand things well
> enough to tell whether that's a fundamental restriction of C45 or just
> our implementation and the implementation can be changed to fix it.
>
> Do you have some thoughts on this?
>
IMHO, since the framework allows defining the reset GPIO, it does not sound
reasonable to manage it only after checking if the PHY can communicate:
if the reset is asserted, the PHY cannot communicate at all.
This patch just ensures that, if the reset GPIO is defined, it's not asserted
while checking the communication.
