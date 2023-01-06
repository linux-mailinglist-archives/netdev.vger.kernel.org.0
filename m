Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E4366027F
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbjAFOte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbjAFOtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:49:33 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B9A80AE2;
        Fri,  6 Jan 2023 06:49:32 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id v3so1299171pgh.4;
        Fri, 06 Jan 2023 06:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=c/4B91u6ylTOx45/hW4gw/DI9Z2QPBD6uPxzsWE2OKI=;
        b=lBGd001WMXdtntPtwChp6zaRmJnQeUHwDPEXKK/yB9/1/JZVtXHJJwt0DBicxsBhgg
         ycomVC11nLhHdKKbEv3OsAFQaHaZ5yB4ieDLfSid+KIGCuh9RnBEvkOosidug4LbyFyD
         5px175Lc3gPq+dOSbxYjmw8uMOBa57VmxXVS7h29Kh5z57lAfMXGGXSlvRdgLLYszgbI
         842PPSUVxWgT7+HdaV+vjG6+LbHAJaW5vQkGrhIgIyHuRTaCQuwDnmpIJT8R5cK3YrLf
         wc8U6I1+6NtR4DRVX4RLMHIynabLaz5d5dLYJpQ8n9LopdC3AVJBJfgnSYehPfLb0FkZ
         UN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c/4B91u6ylTOx45/hW4gw/DI9Z2QPBD6uPxzsWE2OKI=;
        b=ukr/Jn3PxWCAyrE25EgoniIymIRhGMMzN8PdWox1wVYMLjgU3oE8PVB+u9O9/9oWek
         B7mHntMY80o4upI18ZkLB9yaf2nz9KqaLtRebtqrjIexKCDBjbyeL+JpY+wOIrXgLuOF
         7XRUm1XGg/54Ad1YMCqBhQpwTA0spIc88B9Xdikz/VusQRIslwWqcJErHbtnqlzovH22
         WT1fQdqcojo4GGHDYkYmiVDeZuLd7vYtg7SlTx5daM3Xt3J9w62msg9LxaJdVQFWwtIs
         KKMkLTT0iOwSGTGcimbObUFKOyTFOENFWCx4lywTRV8FaHAtnk94lC5pmqzN0fcVAz0m
         UZUg==
X-Gm-Message-State: AFqh2krOwcr7kCu28t9YuCkoK7zEBkOkLDa1wjUINM+YzqKafLDMvzex
        6w+gj7nSritb8gxsg2H7i8+ARVeTgL8cIxj7hCY=
X-Google-Smtp-Source: AMrXdXv6Hi6xAyBKGxu0uaFaLQxZ/0W2Skmn5T7z+UH6tBvjBrYG8c3gK+7llscHrF2GRQ2pBJLun1kC7jxATlgJE40=
X-Received: by 2002:a63:4d04:0:b0:46f:c183:2437 with SMTP id
 a4-20020a634d04000000b0046fc1832437mr3001814pgb.613.1673016571907; Fri, 06
 Jan 2023 06:49:31 -0800 (PST)
MIME-Version: 1.0
References: <20230104141245.8407-1-aford173@gmail.com> <20230104141245.8407-2-aford173@gmail.com>
 <CAMuHMdXQfAJUVsYeN37T_KvXUoEaSqYJ+UWtUehLv-9R9goVzA@mail.gmail.com>
 <CAHCN7xJQZgLgDH_beWZfvzksEgm87rotfq7T2SMhgzjojJesKg@mail.gmail.com> <CAMuHMdXD_hq8xtrxxCZ_dToJwCKp3CfAiJh-jg5SqeM8qKgyyQ@mail.gmail.com>
In-Reply-To: <CAMuHMdXD_hq8xtrxxCZ_dToJwCKp3CfAiJh-jg5SqeM8qKgyyQ@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Fri, 6 Jan 2023 08:49:20 -0600
Message-ID: <CAHCN7x+aGm50mfoDkPDGHnm4zTyNSf8VEPWKHDKx=u+0y4VJPg@mail.gmail.com>
Subject: Re: [PATCH 2/4] Revert "arm64: dts: renesas: Add compatible
 properties to AR8031 Ethernet PHYs"
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     linux-renesas-soc@vger.kernel.org, aford@beaconembedded.com,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 6, 2023 at 8:45 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Adam,
>
> On Fri, Jan 6, 2023 at 3:35 PM Adam Ford <aford173@gmail.com> wrote:
> > On Fri, Jan 6, 2023 at 8:28 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > On Wed, Jan 4, 2023 at 3:12 PM Adam Ford <aford173@gmail.com> wrote:
> > > > This reverts commit 18a2427146bf8a3da8fc7825051d6aadb9c2d8fb.
> > > >
> > > > Due to the part shortage, the AR8031 PHY was replaced with a
> > > > Micrel KSZ9131.  Hard-coding the ID of the PHY makes this new
> > > > PHY non-operational.  Since previous hardware had shipped,
> > > > it's not as simple as just replacing the ID number as it would
> > > > break the older hardware.  Since the generic mode can correctly
> > > > identify both versions of hardware, it seems safer to revert
> > > > this patch.
> > > >
> > > > Signed-off-by: Adam Ford <aford173@gmail.com>
> > >
> > > Thanks for your patch!
> > >
> > > > --- a/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> > > > +++ b/arch/arm64/boot/dts/renesas/beacon-renesom-som.dtsi
> > > > @@ -59,8 +59,6 @@ &avb {
> > > >         status = "okay";
> > > >
> > > >         phy0: ethernet-phy@0 {
> > > > -               compatible = "ethernet-phy-id004d.d074",
> > > > -                            "ethernet-phy-ieee802.3-c22";
> > > >                 reg = <0>;
> > > >                 interrupt-parent = <&gpio2>;
> > > >                 interrupts = <11 IRQ_TYPE_LEVEL_LOW>;
> > >
> > > The next line:
> > >
> > >                 reset-gpios = <&gpio2 10 GPIO_ACTIVE_LOW>;
> > >
> > > Unfortunately, removing the compatible value will cause regressions
> > > for kexec/kdump and for Ethernet driver unbind, as the PHY reset will
> > > be asserted before starting the new kernel, or on driver unbind.
> > > Due to a deficiency in the Ethernet PHY subsystem, the PHY will be
> > > probed while the reset is still asserted, and thus fail probing[1].
> >
> > FWIW, the bootloader brings the device out of reset.  Would it be
>
> The bootloader is not involved when using kexec/kdump, or when
> unbinding the Ethernet driver.
>
> > sufficient to keep  "ethernet-phy-ieee802.3-c22" and drop the
> > hard-coded ID?
>
> I am afraid not, as that still requires actual probing to determine
> the PHY ID.

OK.  I'll try to find out how many of the older versions of the board
shipped. I don't really want to maintain two device trees for a small
population of boards.  Even those customers with early hardware won't
be getting the same versions going forward and Qualcomm/Atheros told
us it's an EOL part and cancelled our orders.  If there are no
objections, I might just change the ID to the new PHY.  The customers
who received the older hardware should have already been notified of
the hardware change and the fact they won't get any more with that
PHY.

adam
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
