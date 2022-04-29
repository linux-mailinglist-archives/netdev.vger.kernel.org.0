Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140135149F3
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359535AbiD2Mz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245070AbiD2Mz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:55:26 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70548CA0E4;
        Fri, 29 Apr 2022 05:52:07 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id y2so14274412ybi.7;
        Fri, 29 Apr 2022 05:52:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FZ/8JNTm7vpbFc2YOEAMd+Fo9SryLJ8pTwtRQk4/FOk=;
        b=WpO4+NLt8Ukw2ZwcrHbAnQOpf98OVlUhSt5NXSdanwU6n/UsXzPSEXnAhaRaWv+umA
         oNaoj/qqNLSY1rADzGLWH33peBDOWAbfw07ezxxVLrnvFkQ2VJ5sm05LM/1AB+12Ayfp
         vwPoaUdjKMiHlXSnxykyEnD+dNeN69tef5GI2MYDqqbM45RC2sU7A5E+jHLaOD5MOV8S
         cXdlSabecyTUnhGXGC51P+VKEBPjw+L7YB+JN1bbywbd1s2/ikRZV8PJnZAWGHcFKVIr
         t9l+jgDRDnCXoB7q+rwC6kfur/qnMXQCxKXf6/mrUbNcpF2ov8+un6as/MfOks3OBGhw
         GhSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FZ/8JNTm7vpbFc2YOEAMd+Fo9SryLJ8pTwtRQk4/FOk=;
        b=F7zKvD2bKgDprIwElUEKbXJq6BUWHV9Yi3ElB9E5Qv4tXt0e10yqA6aITlpiContiV
         GBViNEvR/YjoIDGlbJLIyu1akcXAoBMl4skrs+d1QlXol37HEOWrxV61V2F0HnVf449T
         j0Wi0Wi1JBWi/hMuEk/qZvbtjeMGSCwSnr6RUqEIMWIxkpgMl79MDD/P4u7TMU5xOML8
         Pxt+UFbSASd7OEW+aw0MQOLXi5ONE/cdKb1J79nG99Js+Svl6Dre1fa5w5iOq5PHd/nc
         n2lByNsBg3SLEjlyjsH0xPVUm0WzlUc2ynTAhq8Ql4xgg1e14v4c50bGAK3KSEI1o6Rs
         7Wqg==
X-Gm-Message-State: AOAM530VwUi2I6+P2Xwe8xyloW0R8O6H9/80YQSFWY53f6/tVf7D9pnN
        wEsaLrzCk7Mz8IcxAAPOZ0pz7ZwypoO5jyJQ+mE=
X-Google-Smtp-Source: ABdhPJzRNlEiq1/vYE5gH25u17jZRFLjz3wbD2iYLzU01FlXhl/FlC+A6HDjYY9XS8w8L6gcw/IvaA0gnNC3PgK0txQ=
X-Received: by 2002:a25:600b:0:b0:648:ef9b:172d with SMTP id
 u11-20020a25600b000000b00648ef9b172dmr9893719ybb.585.1651236726660; Fri, 29
 Apr 2022 05:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220228233057.1140817-1-pgwipeout@gmail.com> <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
 <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
In-Reply-To: <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Fri, 29 Apr 2022 08:51:54 -0400
Message-ID: <CAMdYzYrFuMw4aj_9L698ZhL7Xqy8=NeXhy9HDz4ug-v3=f4fpw@mail.gmail.com>
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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

On Mon, Feb 28, 2022 at 7:44 PM Peter Geis <pgwipeout@gmail.com> wrote:
>
> On Mon, Feb 28, 2022 at 7:14 PM Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
> >
> > On Mon, Feb 28, 2022 at 06:30:57PM -0500, Peter Geis wrote:
> > > The sentinel compatible entry whitespace causes automatic module loading
> > > to fail with certain userspace utilities. Fix this by removing the
> > > whitespace and sentinel comment, which is unnecessary.
> >
> > Umm. How does it fail?
>
> It simply does not auto load the module by device id match.
> Manually loading the module after the fact works fine.
>
> >
> > >  static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
> > >       { PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
> > > -     { /* sentinal */ }
> > > +     {}
> >
> > These two should be 100% identical in terms of the object code produced,
> > and thus should have no bearing on the ability for the module to be
> > loaded.
> >
> > Have you investigated the differences in the produced object code?
>
> Yes, you are correct, I just compared the produced files and they are identical.
> This patch can get dropped then.
> I'm curious now why it seemed to make a difference.
>
> I am not familiar enough with how the various userspace elements
> decide to match the modules to determine exactly why this is failing.
> It seems to be hit or miss if userspace decides to auto load this, for
> instance Ubuntu 20.04 was happy to load my kernel module built with
> the arm64 official toolchain, but Manjaro will not load their self
> built kernel module.
> I originally suspected it was due to the manufacturer id being all zeros.
> Unless there's some weird compiler optimization that I'm not seeing in
> my configuration.
>
> Any ideas would be appreciated.
> Thanks!

Good Morning,

After testing various configurations I found what is actually
happening here. When libphy is built in but the phy drivers are
modules and not available in the initrd, the generic phy driver binds
here. This allows the phy to come up but it is not functional. It also
prevents the module driver from binding when it becomes available.
https://elixir.bootlin.com/linux/v5.18-rc4/source/drivers/net/phy/phy_device.c#L1383

It seems there is an implicit dependency between phy_device and the
device specific drivers that isn't realized in the configuration.

I can think of a few ways to fix this, but I think the simplest is to
make the device specific drivers have a kconfig dependency on libphy
(which builds phy_device). This means that the only time the device
specific phy drivers can be modules is if libphy is as well, otherwise
if libphy is built in, the device specific drivers would need to be as
well. There are more elegant and complicated solutions I can think of
here, such as breaking out the generic driver as a module or having a
device-tree flag that annotates that we need a device specific driver.

This isn't realized with most of the common devices such as the
Realtek driver because they have cross dependencies that ensure they
are likely to be built in.

Very Respectfully,
Peter Geis


>
> > If not, please do so, and describe what they were. Thanks.
> >
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
