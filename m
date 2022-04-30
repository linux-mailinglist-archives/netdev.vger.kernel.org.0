Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB6AB515F42
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 18:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383084AbiD3QfH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Apr 2022 12:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383104AbiD3QfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Apr 2022 12:35:02 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A3218355;
        Sat, 30 Apr 2022 09:31:39 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id i38so19433068ybj.13;
        Sat, 30 Apr 2022 09:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQBIwY6gYucmpK0m5q+UiClACSjy1lrKIL+7r3g96NE=;
        b=mJewPIEQt6k7No6Cs9mgMKMZpiDMbHOCzpdmu9Hd2D9DK1XXla4qkJeEslHt343F64
         +fFfV++PExhSKg+0Bf478eXbqavUUHVfys017SvsqXZcWG2hLN4jjpGLjNpYDXC2w/3/
         RYIrLgVeRrda0EfPcWSmPMG+OhHTXlfLUsm1FMufxwwgFOsE7TbNXbwWUl8yhWVPzj4A
         sLqiOyLTwLyKxW0lgcKEWr5HEmhub0795GKjfrt1IrP4laVRkDo/fjxdPquNAbyww+8h
         xEos337yRLnzvj3kvKVdIS7id0MeXg2kUaebuvXcryseCVuCyfXBP/FLxWFXyTTQwR7/
         2Nhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQBIwY6gYucmpK0m5q+UiClACSjy1lrKIL+7r3g96NE=;
        b=Rrh/OE/j9WDMceOUjrlT6lHKB5gSJgc6bLA/oW5Ci8n2aw9upEUORWAG16ICMLp6v8
         gCtIdp6Sm7A5t1RoyH2J+maQfqcIQHjK8OLUO+t3PnQ7IwQ+OFKRXIeLvCMrXp3P+Xh0
         iqYa1XMAprj+ZrnEKeQKBMyXtUEfz2AgAUe9UZJUOyIEm8nAHc16JcftH/XXn56NaODL
         4mKTnrHoYz5HyMTuIFF9QRLE2zAfps7xFrm6nN/fjD7VVXBnI57si+hmYdJiMGfjMIqf
         sS59zsbRMI4z+SPmxJ2nPkyhzQcXnehp+TGKf0ATTkJTOkKkLFe9Ilc6IKnvA3mvMZdm
         A9yw==
X-Gm-Message-State: AOAM533zg3aNKSHXCx1/ZoyuRKcCWu4/+Nuf/0p3xrsG220/JoEbcJ6f
        xHZiecYfjwykmdgZrH3YPug3k/JocJpAuSlA6UA79ubZG6Y=
X-Google-Smtp-Source: ABdhPJyP1o+RQhfe6Taz8kwGwJR4bz9ro27WjlM3uAynYTPZWAZ04EdNCK1TxHTsM4b3MKj7CIqpMywzaDRHxrbbo2M=
X-Received: by 2002:a5b:dc8:0:b0:624:a898:dea6 with SMTP id
 t8-20020a5b0dc8000000b00624a898dea6mr4168113ybr.600.1651336298505; Sat, 30
 Apr 2022 09:31:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220228233057.1140817-1-pgwipeout@gmail.com> <Yh1lboz7VDiuYuZV@shell.armlinux.org.uk>
 <CAMdYzYrNvUUMom4W4uD9yf9LtFK1h5Xw+9GYc54hB5+iqVmJtw@mail.gmail.com>
 <CAMdYzYrFuMw4aj_9L698ZhL7Xqy8=NeXhy9HDz4ug-v3=f4fpw@mail.gmail.com> <Ym1bWHNj0p6L9lY8@lunn.ch>
In-Reply-To: <Ym1bWHNj0p6L9lY8@lunn.ch>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Sat, 30 Apr 2022 12:31:27 -0400
Message-ID: <CAMdYzYq41TndbJK-=ah31=vECisgRbPmtFYwOLQQ7yn4L=JVYw@mail.gmail.com>
Subject: Re: [PATCH v1] net: phy: fix motorcomm module automatic loading
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
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

On Sat, Apr 30, 2022 at 11:52 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Good Morning,
> >
> > After testing various configurations I found what is actually
> > happening here. When libphy is built in but the phy drivers are
> > modules and not available in the initrd, the generic phy driver binds
> > here. This allows the phy to come up but it is not functional.
>
> What MAC are you using?

Specifically Motorcomm, but I've discovered it can happen with any of
the phy drivers with the right kconfig.

>
> Why is you interface being brought up by the initramfs? Are you using
> NFS root from within the initramfs?

This was discovered with embedded programming. It's common to have a
small initramfs, or forgo an initramfs altogether. Another cause is a
mismatch in kernel config where phylib is built in because of a
dependency, but the rest of the phy drivers are modular.
The key is:
- phylib is built in
- ethernet driver is built in
- the phy driver is a module
- modules aren't available at probe time (for any reason).

In this case phylib assumes there is no driver, when the vast majority
of phys now have device specific drivers.It seems this is an unsafe
assumption as this means there is now an implicit dependency of the
device specific phy drivers and phylib. It just so happens to work
simply because both broadcom and realtek, some of the more common
phys, have explicit dependencies elsewhere that cause them to be built
in as well.

>
> What normally happens is that the kernel loads, maybe with the MAC
> driver and phylib loading, as part of the initramfs. The other modules
> in the initramfs allow the root filesystem to be found, mounted, and
> pivoted into it. The MAC driver is then brought up by the initscripts,
> which causes phylib to request the needed PHY driver modules, it loads
> and all is good.
>
> If you are using NFS root, then the load of the PHY driver happens
> earlier, inside the initramfs. If this is you situation, maybe the
> correct fix is to teach the initramfs tools to include the PHY drivers
> when NFS root is being used?
>
>      Andrew
