Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4797E4C1A19
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243488AbiBWRpr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243476AbiBWRpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:45:46 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319C642A00
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:45:18 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id w4so4044595vsq.1
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MEOtqPN/ClMnur+Fbx2ddji0SBCl4ErQtnMrevhDyU8=;
        b=OJfRahV+3M5v/Ck3KAMQLF2Nvj28h2JkunNrT8CMqTpIvzoH9MhlHseF6rfRIJNiH2
         SeWChr4VHUK12xS2iOfJcErpMLzqlCGhuPC+14Jlb48ejcP0xDLsrNpYqrNmzLrliUs3
         9Oz1L0T0R3kJR65XzmQE6cuRxoczWgnM1YH1LIxFBs2w2GX9L/ZDwLExhxbbPVxvx/Ap
         TQScpkoROOdA4Fs8OsDTrOqn+60Xvp3hGfrtlKENoBTZYhA5fADADHfY30sAeuzzrUjb
         s8WEw/kFeyHI/DDlzZe0lfqVHy0ppJZyMxfUU0gufewf+cK3Mlp4DYDK0XuJQyD7/2sN
         pshw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MEOtqPN/ClMnur+Fbx2ddji0SBCl4ErQtnMrevhDyU8=;
        b=0quWTF4sRYERu9MFLrJZY/F4KT3p4ElfQqrqgWBz1XDKxUYBRnxJBKfrKw4mAyQnse
         S30gUlomb8mku7Iq5vnFlZnCzDc3jKfHjZftpzG8Sp9nrcc3mGHnnHY6rqirWLauHTY8
         IoJnuFF/hWyE/sZCcxmxZkER1jGuy1nlpizwyTikvxlDg8MUC7xzBabDiQXzXYr00IMz
         Z2hX2DiTWwFMKd5+EpfvuHn9RpWBqBsVTXOmWzXSos097epvgJdXqEN4oVOf3yf+WgFs
         FuUiAgo3yzeWxEjW4v/4jWoKsS3wlhoiIhpA5vIU3H8BAomopD9Pl1ujmRzGTARzmSqj
         rUjg==
X-Gm-Message-State: AOAM5300uqW+8s0jCkgWedBt5H8hT0tx+l6KOltSZ/tY4xi6tS7iUjM2
        FBJ3AFHO3QQS1COPf7xAsCX7STDiwLbT8v4LT3M=
X-Google-Smtp-Source: ABdhPJykiLzEy9QDLXLOdFHbmVVlvnA2M90fmn0YlIROejeTLr2ZxlwNqSjjIHHTcBx6ytpB7Pvby1dRZ2H/48B+b08=
X-Received: by 2002:a67:e046:0:b0:30d:c59c:7f06 with SMTP id
 n6-20020a67e046000000b0030dc59c7f06mr319749vsl.86.1645638317277; Wed, 23 Feb
 2022 09:45:17 -0800 (PST)
MIME-Version: 1.0
References: <20220222095348.2926536-1-pbrobinson@gmail.com>
 <f79df42b-ff25-edaa-7bf3-00b44b126007@gmail.com> <CALeDE9NGckRoatePdaWFYqHXHcOJ2Xzd4PGLOoNWDibzPB_zXQ@mail.gmail.com>
 <734024dc-dadd-f92d-cbbb-c8dc9c955ec3@gmail.com> <CALeDE9Nk8gvCS425pJe5JCgcfSZugSnYwzGOkxhszrBz3Da6Fg@mail.gmail.com>
 <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
In-Reply-To: <3ae3a9fc-9dd1-00c6-4ae8-a65df3ed225f@gmail.com>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Wed, 23 Feb 2022 17:45:06 +0000
Message-ID: <CALeDE9PK9JkFkbTc36HOZH8CG8MM3OMhKJ24FKioKF5bspSPkA@mail.gmail.com>
Subject: Re: [PATCH] net: bcmgenet: Return not supported if we don't have a
 WoL IRQ
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > The top two are pre/post plugging an ethernet cable with the patched
> > kernel, the last two are the broken kernel. There doesn't seem to be a
> > massive difference in interrupts but you likely know more of what
> > you're looking for.
>
> There is not a difference in the hardware interrupt numbers being
> claimed by GENET which are both GIC interrupts 189 and 190 (157 + 32 and
> 158 + 32). In the broken case we can see that the second interrupt line
> (interrupt 190), which is the one that services the non-default TX
> queues does not fire up at all whereas it does in the patched case.
>
> The transmit queue timeout makes sense given that transmit queue 2
> (which is not the default one, default is 0) has its interrupt serviced
> by the second interrupt line (190). We can see it not firing up, hence
> the timeout.
>
> What I *think* might be happening here is the following:
>
> - priv->wol_irq = platform_get_irq_optional(pdev, 2) returns a negative
> error code we do not install the interrupt handler for the WoL interrupt
> since it is not valid
>
> - bcmgenet_set_wol() is called, we do not check priv->wol_irq, so we
> call enable_irq_wake(priv->wol_irq) and somehow irq_set_irq_wake() is
> able to resolve that irq number to a valid interrupt descriptor
>
> - eventually we just mess up the interrupt descriptor for interrupt 49
> and it stops working
>
> Now since this appears to be an ACPI-enabled system, we may be hitting
> this part of the code in platform_get_irq_optional():
>
>            r = platform_get_resource(dev, IORESOURCE_IRQ, num);
>            if (has_acpi_companion(&dev->dev)) {
>                    if (r && r->flags & IORESOURCE_DISABLED) {
>                            ret = acpi_irq_get(ACPI_HANDLE(&dev->dev),
> num, r);
>                            if (ret)
>                                    goto out;
>                    }
>            }
>
> and then I am not clear what interrupt this translates into here, or
> whether it is possible to get a valid interrupt descriptor here.
>
> The patch is fine in itself, but I would really prefer that we get to
> the bottom of this rather than have a superficial understanding of the
> nature of the problem.

I have no problems working with you to improve the driver, the problem
I have is this is currently a regression in 5.17 so I would like to
see something land, whether it's reverting the other patch, landing
thing one or another straight forward fix and then maybe revisit as
whole in 5.18.

> Thanks for providing these dumps.
> --
> Florian
