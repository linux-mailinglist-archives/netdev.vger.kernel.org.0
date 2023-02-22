Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3A569FD83
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbjBVVJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbjBVVJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:09:27 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC1F1BF6;
        Wed, 22 Feb 2023 13:08:59 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s26so35777409edw.11;
        Wed, 22 Feb 2023 13:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TKZzlZfBDXX9ovC7FvjcjFToHnoFrJbUmg3S2ObSizU=;
        b=Qi0FT2IUyQQOvg+dUR8iu+MBUprX4Yp4c/PRGu5ZDrf50x2u86gDyZvgm/OAnXQKLV
         DofG0tMus8J48Pp8+1TsaxQWC/a4zyxPD5qtlHoiBEhXnwB5EUwxSukcKaSjkUEifuM8
         5JcK8kogp7qLrOCAkYn5F2YcSzDz0NsbfOZFWz1QxPBxUYgA11HVu/6xWQv2nlNANIj6
         5G7VuWKYEDRT5YSYkIIyQqRqRBk1qDZdg0iNxv7todIA3l+zDKWM5TTpGrm5yiSn76lH
         Oo/YGvM1wAwXmyYlS4BYwEykWXitrqkDBv+mDfjhK+45x+pQHLq7T3I8QjXHcRIDInDu
         NKsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TKZzlZfBDXX9ovC7FvjcjFToHnoFrJbUmg3S2ObSizU=;
        b=ACbNMS2/R2fgu+3t9Mf6LsBrcZl27z5e9nW9UDdrwbDwRMuFlobF3/6bE0/GzQXdY2
         q+Y8aB+iKzQHsUHeQL6TjIMNhThkbp9fyQUAm48QbeuBCwqVSEIbWiprvts/J4OiMokI
         DE85akZnZO4q73jrzSd9zLQJn5zKTXY7ZFz3gqHWlTvIWQKsQ9bzZDh1r09Fvs4eWY1T
         FjWvAFEvl095hdAv4CU/2lJXtvobGczS1/3c38qstCPhQcoSo7nToUpi4czd2mQwy4md
         7qGaHaB6t9VEU4m9eBQ+Tew2vIw/kbTa5uVpYQDVIwSbbEFo1ZylZWMwpxCA4Rh2oGSh
         Jvyw==
X-Gm-Message-State: AO0yUKWrnfwMl23nKLsl//Wcal5WKHjpxrtiGAmzdKvQGvR/TO41MllP
        SLPal5W8tVuASBD49RDVxvs=
X-Google-Smtp-Source: AK7set+ROnBMqNCZMQkstFUlY6hHcug0kg5ZKChH9LX6u81Izbb7L4r5rYlAHSpxag/5VeL/J2uQ7g==
X-Received: by 2002:a17:906:95ce:b0:87b:3d29:2990 with SMTP id n14-20020a17090695ce00b0087b3d292990mr16659223ejy.9.1677100136625;
        Wed, 22 Feb 2023 13:08:56 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id t24-20020a1709066bd800b008c6c47f59c1sm5607663ejs.48.2023.02.22.13.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 13:08:56 -0800 (PST)
Date:   Wed, 22 Feb 2023 23:08:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>, stable@vger.kernel.org
Subject: Re: [PATCH] net: dsa: microchip: Fix gigabit set and get function
 for KSZ87xx
Message-ID: <20230222210853.pilycwhhwmf7csku@skbuf>
References: <20230222031738.189025-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222031738.189025-1-marex@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please summarize in the commit title what is the user-visible impact of
the problem that is being fixed. Short and to the point.

On Wed, Feb 22, 2023 at 04:17:38AM +0100, Marek Vasut wrote:
> Per KSZ8794 [1] datasheet DS00002134D page 54 TABLE 4-4: PORT REGISTERS,
> it is Register 86 (0x56): Port 4 Interface Control 6 which contains the
> Is_1Gbps field.

Good thing you mention Is_1Gbps (even though it's irrelevant to the
change you're proposing, since ksz_port_set_xmii_speed() is only called
by ksz9477_phylink_mac_link_up()).

That is actually what I want to bring up. If you change the speed in
your fixed-link nodes (CPU port and DSA master) to 100 Mbps on KSZ87xx,
does it work? No, right? Because P_GMII_1GBIT_M always remains at its
hardware default value, which is selected based on pin strapping.
That's a bug, and should be fixed too.

Good thing you brought this up, I wouldn't have mentioned it if it
wasn't in the commit message.

> Currently, the driver uses PORT read function on register P_XMII_CTRL_1
> to access the P_GMII_1GBIT_M, i.e. Is_1Gbps, bit.

Provably false. The driver does do that, but not for KSZ87xx.
Please delete red herrings from the commit message, they do not help
assess users if they care about backporting a patch to a custom tree
or not.

> The problem is, the register P_XMII_CTRL_1 address is already 0x56,
> which is the converted PORT register address instead of the offset
> within PORT register space that PORT read function expects and
> converts into the PORT register address internally. The incorrectly
> double-converted register address becomes 0xa6, which is what the PORT
> read function ultimatelly accesses, and which is a non-existent
                ~~~~~~~~~~~
                ultimately

> register on the KSZ8794/KSZ8795 .
> 
> The correct value for P_XMII_CTRL_1 is 0x6, which gets converted into
> port address 0x56, which is Register 86 (0x56): Port 4 Interface Control 6
> per KSZ8794 datasheet, i.e. the correct register address.
> 
> To make this worse, there are multiple other call sites which read and
                                ~~~~~~~~
                                multiple implies more than 1.

There is no call site other than ksz_set_xmii(). Please delete false
information from the commit message.

> even write the P_XMII_CTRL_1 register, one of them is ksz_set_xmii(),
> which is responsible for configuration of RGMII delays. These delays
> are incorrectly configured and a non-existent register is written
> without this change.

Not only RGMII delays, but also P_MII_SEL_M (interface mode selection).

The implication of writing the value at an undocumented address is that
the real register 0x56 remains with the value decided by pin strapping
(which may or may not be adequate for Linux runtime). This is absolutely
the same class of bug as what happens with Is_1Gbps.

> Fix the P_XMII_CTRL_1 register offset to resolve these problems.
> 
> [1] https://ww1.microchip.com/downloads/aemDocuments/documents/UNG/ProductDocuments/DataSheets/KSZ8794CNX-Data-Sheet-DS00002134.pdf
> 
> Fixes: 46f80fa8981b ("net: dsa: microchip: add common gigabit set and get function")

Technically, the problem was introduced by:

Fixes: c476bede4b0f ("net: dsa: microchip: ksz8795: use common xmii function")

because that's when ksz87xx was transitioned from the old logic (which
also used to set Is_1Gbps) to the new one.

And that same commit is also to blame for the Is_1Gbps bug, because the
new logic from ksz8795_cpu_interface_select() should have called not
only ksz_set_xmii(), but also ksz_set_gbit() for code-wise identical
behavior. It didn't do that. Then with commit f3d890f5f90e ("net: dsa:
microchip: add support for phylink mac config"), this incomplete
configuration just got moved around.

> Signed-off-by: Marek Vasut <marex@denx.de>

The contents of the patch is not wrong, but the commit message that
describes it misses a lot of points which make non-zero difference to
someone trying to assess whether a patch fixes a problem he's seeing or not.

Even worse, there is another _actual_ Is_1Gbps bug which I've presented
above, which this patch does *not* fix.
