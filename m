Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08EC84B9496
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 00:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbiBPXj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 18:39:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiBPXj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 18:39:27 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1F9C10E07C;
        Wed, 16 Feb 2022 15:39:10 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id w3so6598329edu.8;
        Wed, 16 Feb 2022 15:39:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZtQTe9qZ0480BUZJAqADPabVUS6dlNdJLoC5sO4bcYQ=;
        b=ayN5pEGK6wmpu8gmohHSN4BQ49t9jT5Z3FLGyjbLcmCdP1QjviUsXHq9Rgv2x1kmgk
         GTXS4zn9TTdfpRKAr89EZdgxTkaAVg++BYO1/dOGfp6PAapP7yhww/3UJbePkXaVMdeN
         kWyLb0JY15qpkebBCRI+QeO6v0IMS/z9qek/6iSQs63f0LYEM0iakCUtTtAL2w6EANek
         YOK08DNIIoTKjDHVQmphYb2sIqeFxdJCf37g4NzKNiS3JwLAYrqx63y4roPmAB11HHym
         l3QsTDHPDr4nf0p224zzS6knNXQfB8V0pdliymug+U8TAmUB2TPIhKl02MWkkenwoQuW
         l2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZtQTe9qZ0480BUZJAqADPabVUS6dlNdJLoC5sO4bcYQ=;
        b=Ro9IYNpURRm+1WXtsErVzbpXMojkLepcr4fDDfrFuwS8ZPKS9vjz/H49UoYX4pW/oi
         H3QJOiCx7meSyKB7KkIXnYSQXBfFelI7nh9I2SK8Cq2jeDtJNXFhCsvn+Z4BALH+FQz9
         iKYu96HDU2LwSPQ4dj3qL0bk0y8wUczopxV8AulQBVbi+Fyy5irIeQ1Ao/kZNVn5PaGo
         s6xSrXfkhtS6ZFfvjiMbcQk2Q0UaPMh50V0euDy2Z8qgioafmZPxRDkQTw+HambEzc5a
         25tCJsQtd2KLPIECXhEz8FEdicNdXcIB5U6mU299wHUFs33MKA9KyaqTXEWBHiDhcNha
         +TWQ==
X-Gm-Message-State: AOAM531+tOb0jtVQ6DMwLzNATxJdsAWourBuQXiJJZYPDbAcorhEi+c2
        EY/q0ucsJMc+vQpHO0EGCEc=
X-Google-Smtp-Source: ABdhPJwd+gTGk6NW2CfYI2pcuXkz6EM9mXO9IZ7dLECGhUvOXt2fqJTPYBKYi/dvZDBw6bB543NM+w==
X-Received: by 2002:a50:f686:0:b0:410:e352:e61a with SMTP id d6-20020a50f686000000b00410e352e61amr124421edn.23.1645054748640;
        Wed, 16 Feb 2022 15:39:08 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id j19sm470237ejo.202.2022.02.16.15.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 15:39:07 -0800 (PST)
Date:   Thu, 17 Feb 2022 01:39:06 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: dsa: realtek: rtl8365mb: serialize
 indirect PHY register access
Message-ID: <20220216233906.5dh67olhgfz7ji6o@skbuf>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
 <20220216160500.2341255-3-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220216160500.2341255-3-alvin@pqrs.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 05:05:00PM +0100, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Realtek switches in the rtl8365mb family can access the PHY registers of
> the internal PHYs via the switch registers. This method is called
> indirect access. At a high level, the indirect PHY register access
> method involves reading and writing some special switch registers in a
> particular sequence. This works for both SMI and MDIO connected
> switches.
> 
> Currently the rtl8365mb driver does not take any care to serialize the
> aforementioned access to the switch registers. In particular, it is
> permitted for other driver code to access other switch registers while
> the indirect PHY register access is ongoing. Locking is only done at the
> regmap level. This, however, is a bug: concurrent register access, even
> to unrelated switch registers, risks corrupting the PHY register value
> read back via the indirect access method described above.
> 
> Arınç reported that the switch sometimes returns nonsense data when
> reading the PHY registers. In particular, a value of 0 causes the
> kernel's PHY subsystem to think that the link is down, but since most
> reads return correct data, the link then flip-flops between up and down
> over a period of time.
> 
> The aforementioned bug can be readily observed by:
> 
>  1. Enabling ftrace events for regmap and mdio
>  2. Polling BSMR PHY register for a connected port;
>     it should always read the same (e.g. 0x79ed)
>  3. Wait for step 2 to give a different value
> 
> Example command for step 2:
> 
>     while true; do phytool read swp2/2/0x01; done
> 
> On my i.MX8MM, the above steps will yield a bogus value for the BSMR PHY
> register within a matter of seconds. The interleaved register access it
> then evident in the trace log:
> 
>  kworker/3:4-70      [003] .......  1927.139849: regmap_reg_write: ethernet-switch reg=1004 val=bd
>      phytool-16816   [002] .......  1927.139979: regmap_reg_read: ethernet-switch reg=1f01 val=0
>  kworker/3:4-70      [003] .......  1927.140381: regmap_reg_read: ethernet-switch reg=1005 val=0
>      phytool-16816   [002] .......  1927.140468: regmap_reg_read: ethernet-switch reg=1d15 val=a69
>  kworker/3:4-70      [003] .......  1927.140864: regmap_reg_read: ethernet-switch reg=1003 val=0
>      phytool-16816   [002] .......  1927.140955: regmap_reg_write: ethernet-switch reg=1f02 val=2041
>  kworker/3:4-70      [003] .......  1927.141390: regmap_reg_read: ethernet-switch reg=1002 val=0
>      phytool-16816   [002] .......  1927.141479: regmap_reg_write: ethernet-switch reg=1f00 val=1
>  kworker/3:4-70      [003] .......  1927.142311: regmap_reg_write: ethernet-switch reg=1004 val=be
>      phytool-16816   [002] .......  1927.142410: regmap_reg_read: ethernet-switch reg=1f01 val=0
>  kworker/3:4-70      [003] .......  1927.142534: regmap_reg_read: ethernet-switch reg=1005 val=0
>      phytool-16816   [002] .......  1927.142618: regmap_reg_read: ethernet-switch reg=1f04 val=0
>      phytool-16816   [002] .......  1927.142641: mdio_access: SMI-0 read  phy:0x02 reg:0x01 val:0x0000 <- ?!
>  kworker/3:4-70      [003] .......  1927.143037: regmap_reg_read: ethernet-switch reg=1001 val=0
>  kworker/3:4-70      [003] .......  1927.143133: regmap_reg_read: ethernet-switch reg=1000 val=2d89
>  kworker/3:4-70      [003] .......  1927.143213: regmap_reg_write: ethernet-switch reg=1004 val=be
>  kworker/3:4-70      [003] .......  1927.143291: regmap_reg_read: ethernet-switch reg=1005 val=0
>  kworker/3:4-70      [003] .......  1927.143368: regmap_reg_read: ethernet-switch reg=1003 val=0
>  kworker/3:4-70      [003] .......  1927.143443: regmap_reg_read: ethernet-switch reg=1002 val=6
> 
> The kworker here is polling MIB counters for stats, as evidenced by the
> register 0x1004 that we are writing to (RTL8365MB_MIB_ADDRESS_REG). This
> polling is performed every 3 seconds, but is just one example of such
> unsynchronized access.
> 
> Further investigation reveals the underlying problem: if we read from an
> arbitrary register A and this read coincides with the indirect access
> method in rtl8365mb_phy_ocp_read, then the final read from
> RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG will always return the value in
> register A. The value read back can be readily poisoned by repeatedly
> reading back the value of another register A via debugfs in a busy loop
> via the dd utility or similar.
> 
> This issue appears to be unique to the indirect PHY register access
> pattern. In particular, it does not seem to impact similar sequential
> register operations such MIB counter access.
> 
> To fix this problem, one must guard against exactly the scenario seen in
> the above trace. In particular, other parts of the driver using the
> regmap API must not be permitted to access the switch registers until
> the PHY register access is complete. Fix this by using the newly
> introduced "nolock" regmap in all PHY-related functions, and by aquiring
> the regmap mutex at the top level of the PHY register access callbacks.
> Although no issue has been observed with PHY register _writes_, this
> change also serializes the indirect access method there. This is done
> purely as a matter of convenience.
> 
> Fixes: 4af2950c50c8 ("net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC")
> Link: https://lore.kernel.org/netdev/CAJq09z5FCgG-+jVT7uxh1a-0CiiFsoKoHYsAWJtiKwv7LXKofQ@mail.gmail.com/
> Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reported-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---

This implementation where the indirect PHY access blocks out every other
register read and write is only justified if you can prove that you can
stuff just about any unrelated register read or write before
RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG, and this, in and of itself,
will poison what gets read back from RTL8365MB_INDIRECT_ACCESS_READ_DATA_REG.

rtl8365mb_mib_counter_read() doesn't seem like a particularly good
example to prove this, since it appears to be an indirect access
procedure as well. Single register reads or writes would be ideal, like
RTL8365MB_CPU_CTRL_REG, artificially inserted into strategic places.
Ideally you wouldn't even have a DSA or MDIO or PHY driver running.
Just a simple kernel module with access to the regmap, and try to read
something known, like the PHY ID of one of the internal PHYs, via an
open-coded function. Then add extra regmap accesses and see what
corrupts the indirect PHY access procedure.

Are Realtek aware of this and do they confirm the issue? Sounds like
erratum material to me, and a pretty severe one, at that. Alternatively,
we may simply not be understanding the hardware architecture, like for
example the fact that MIB indirect access and PHY indirect access may
share some common bus and must be sequential w.r.t. each other.
