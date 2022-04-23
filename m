Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1338550CB65
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbiDWOoc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiDWOob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:44:31 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325D1D4472
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 07:41:34 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id j2so19499664ybu.0
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 07:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nathanrossi.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xea/ooL0oXQr48b59SjzLL2di9oPZrvbBXHt0wat3jc=;
        b=VpMPIOjOPRfPsA5kT+RVI6LIkgrPRSEhBxxCycmmriboalFnHZKg9ebRbAeSZ0AylJ
         53JinkuYkyfLJnUoDEdgy6nuNtVb1iIn68aGCQanDvreWw/BaIhREYxzEN34vN9Le6R6
         CaJUvkavT/umtxEhhvs4E46Zz+2oHy1bpzTBaTBcFv9TwpXn0ek5ldst3nLNl3gEtBxb
         ITzc8AJ/ShTSyTr5KnRObrbq/a1+EAqWznf95hx+fqxqychkdFqUaMQc3okP6tuT+GZr
         TAhmQb/C5f2ulGMEU4wvDSgLK3EgBwRO0a0mJ5lldjr5TQeZ+WZXgcfVF2oHY7isz9WZ
         3/hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xea/ooL0oXQr48b59SjzLL2di9oPZrvbBXHt0wat3jc=;
        b=sbmLMCHQA06VYWnsIW1AnoYCOC94Bw2cFuDld4dCsylnuGf0Xd3mFnfIeZ3tDTfLiz
         iZOOVcfxosEzivSIeewFUyxxCtLkSyi3PNjJ8EtFTWh/6M/GpwCs11B4LHh14nwdWeld
         VTu1IJB7tC1qWBBDeLRPsbWMpiEjh8TB/PZeNhuP+w95hQauI4qM+pFh74IyucnPJzHn
         36K+IdpaskKpu5Ap9aQIQ+DDvUI2fFozQPU3YXOFOIg075ZJe/SXoL2CN/MTU5hM1SUI
         orrWSLFCUjn74j6boO7rMqIar9WCVKGfQKHLDjx2ZOiaitefqxsmHvWdtQfifuagFWBJ
         1oqg==
X-Gm-Message-State: AOAM530ud1qVWo/Csvf5C6fLEuxEL1ounJTZf4y3SkXrIBJVH0/x86oq
        U6UPy9ch4Gh98rkfjLY1miGI+XXXQ8Eot17W+76k3VXViKuyFh/c
X-Google-Smtp-Source: ABdhPJx7MQMqxc6szpt3wAHoBUFuvlBgosdX8utQ5F+DTI9tcw27agSFUd5ZmgiQru4z6NkEKr4c1mEK3vvCwkafq78=
X-Received: by 2002:a5b:a43:0:b0:63d:c248:13a5 with SMTP id
 z3-20020a5b0a43000000b0063dc24813a5mr9196772ybq.614.1650724893453; Sat, 23
 Apr 2022 07:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220423131427.237160-1-nathan@nathanrossi.com>
 <20220423131427.237160-2-nathan@nathanrossi.com> <YmQIHWL4iTS5qVIz@lunn.ch>
In-Reply-To: <YmQIHWL4iTS5qVIz@lunn.ch>
From:   Nathan Rossi <nathan@nathanrossi.com>
Date:   Sun, 24 Apr 2022 00:41:22 +1000
Message-ID: <CA+aJhH3EtAxAKy8orC-SU8UnagBCibF3dHXrp78zfjuAzj4vUg@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: Handle single-chip-address OF property
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Apr 2022 at 00:07, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Apr 23, 2022 at 01:14:27PM +0000, Nathan Rossi wrote:
> > Handle the parsing and use of single chip addressing when the switch has
> > the single-chip-address property defined. This allows for specifying the
> > switch as using single chip addressing even when mdio address 0 is used
> > by another device on the bus. This is a feature of some switches (e.g.
> > the MV88E6341/MV88E6141) where the switch shares the bus only responding
> > to the higher 16 addresses.
>
> Hi Nathan
>
> I think i'm missing something in this explanation:
>
> smi.c says:
>
> /* The switch ADDR[4:1] configuration pins define the chip SMI device address
>  * (ADDR[0] is always zero, thus only even SMI addresses can be strapped).
>  *
>  * When ADDR is all zero, the chip uses Single-chip Addressing Mode, assuming it
>  * is the only device connected to the SMI master. In this mode it responds to
>  * all 32 possible SMI addresses, and thus maps directly the internal devices.
>  *
>  * When ADDR is non-zero, the chip uses Multi-chip Addressing Mode, allowing
>  * multiple devices to share the SMI interface. In this mode it responds to only
>  * 2 registers, used to indirectly access the internal SMI devices.
>  *
>  * Some chips use a different scheme: Only the ADDR4 pin is used for
>  * configuration, and the device responds to 16 of the 32 SMI
>  * addresses, allowing two to coexist on the same SMI interface.
>  */
>
> So if ADDR = 0, it takes up the whole bus. And in this case reg = 0.
> If ADDR != 0, it is in multi chip mode, and DT reg = ADDR.
>
> int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
>                        struct mii_bus *bus, int sw_addr)
> {
>         if (chip->info->dual_chip)
>                 chip->smi_ops = &mv88e6xxx_smi_dual_direct_ops;
>         else if (sw_addr == 0)
>                 chip->smi_ops = &mv88e6xxx_smi_direct_ops;
>         else if (chip->info->multi_chip)
>                 chip->smi_ops = &mv88e6xxx_smi_indirect_ops;
>         else
>                 return -EINVAL;
>
> This seems to implement what is above. smi_direct_ops == whole bus,
> smi_indirect_ops == multi-chip mode.
>
> In what situation do you see this not working? What device are you
> using, what does you DT look like, and what at the ADDR value?

The device I am using is the MV88E6141, it follows the second scheme
such that it only responds to the upper 16 of the 32 SMI addresses in
single chip addressing mode. I am able to define the switch at address
0, and everything works. However in the device I am using (Netgate
SG-3100) the ethernet phys for the non switch ethernet interfaces are
also on the same mdio bus as the switch. One of those phys is
configured with address 0. Defining both the ethernet-phy and switch
as address 0 does not work.

The device tree I have looks like:

&mdio {
    status = "okay";
    pinctrl-0 = <&mdio_pins>;
    pinctrl-names = "default";

    phy0: ethernet-phy@0 {
        status = "okay";
        reg = <0>;
    };

    phy1: ethernet-phy@1 {
        status = "okay";
        reg = <1>;
    };

    switch0: switch0@16 {
        compatible = "marvell,mv88e6141", "marvell,mv88e6085";
        single-chip-address;
        reg = <16>; /* first port in single address mode */
        dsa,member = <0 0>;
        status = "okay";

... ports/mdio nodes ...
    };
};

Thanks,
Nathan

>
> Thanks
>         Andrew
