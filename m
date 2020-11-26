Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37582C53FA
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 13:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgKZMad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 07:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727633AbgKZMac (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 07:30:32 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6155CC0613D4;
        Thu, 26 Nov 2020 04:30:32 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id o9so2723744ejg.1;
        Thu, 26 Nov 2020 04:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2m+lvGSR6BHsH9qKxh1TPWUrONGP2N8HIxUK/qJixF8=;
        b=tulT464tQTXRd7bYocc5gHqkSpzMlqWbXuOm1Ch/HU5XbNujpD/ZBcJmRGmccz+zQt
         Ddst5/a3Ldj9QhjlHqTuzDnF/D3gdXAtU00ZsWaK9ztomOaLFY69m7H9AsOosM9/UPZo
         uQ+4M7zrmf3pC/SFBZPprdPc4aFFyNCZ2S0EEj1RXBn00CxRZqOs5LSE2mCTAhsihG5S
         dbLu9jmgVrGOleUJGxjxPGqF2q/jpR7Oyl+NUKlW2qW/dy2NBC/S69HpKy89z6y+8fqp
         IRUDqGDaH6OTHzQkPeTktD/nu+cJ8ce0eDVas4smXA57HuveaLD8dVA2R4Orw43YZqo8
         dieA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2m+lvGSR6BHsH9qKxh1TPWUrONGP2N8HIxUK/qJixF8=;
        b=m0bQtj/NrD0x8Bm1U1Q1swi05MaAnfvrgrpq0KdHReW6R7Z47u4WEE6DCWgS00wILQ
         dgBIcOlTlITOyXfA+7Bp6eOoQHM1dXdPJxYzYcpUpPnYzF5nIbkoVGrXLP0mcFmm2HqO
         Njmxt9nmbBhGwFgRqCt4+v/7afqsXV7EPLa9WX/WgmCmj9ej0AEbB58FD1q2wV06SBNM
         WNvv09mJ8y2jBJYwckp3DYWkKiuw5/t18UPBhslG7dmMnYkcOAttG9qLXHUHFPO+JpG5
         54aGJLo6ZENaHAkb21cuKFZauiKERWB08y86+g897sdpTBD4bvfIkj0XusW30WdDAann
         JnsA==
X-Gm-Message-State: AOAM5302fcy+kacTR0+93L3PWzQ+cDa9X62KwuIk5GFSt0AkzfeCY0eK
        NtHeQIQ/BCCA1c4iunHMFrs=
X-Google-Smtp-Source: ABdhPJyky7aETAB1Auf4sTcYZY/tUTC2pIUCoYPJAyUotZ0x/OJjMuOEsL/kWsGW4j/YSdYTotvgaQ==
X-Received: by 2002:a17:906:4410:: with SMTP id x16mr2125701ejo.536.1606393830953;
        Thu, 26 Nov 2020 04:30:30 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id y15sm3116327eds.56.2020.11.26.04.30.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 04:30:30 -0800 (PST)
Date:   Thu, 26 Nov 2020 14:30:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <20201126123027.ocsykutucnhpmqbt@skbuf>
References: <20201125232459.378-1-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125232459.378-1-lukma@denx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lukasz,

On Thu, Nov 26, 2020 at 12:24:55AM +0100, Lukasz Majewski wrote:
> This is the first attempt to add support for L2 switch available on some NXP
> devices - i.e. iMX287 or VF610. This patch set uses common FEC and DSA code.
>
> This code provides _very_ basic switch functionality (packets are passed
> between lan1 and lan2 ports and it is possible to send packets via eth0),
> at its main purpose is to establish the way of reusing the FEC driver. When
> this is done, one can add more advanced features to the switch (like vlan or
> port separation).
>
> I also do have a request for testing on e.g. VF610 if this driver works on
> it too.
> The L2 switch documentation is very scant on NXP's User Manual [0] and most
> understanding of how it really works comes from old (2.6.35) NXP driver [1].
> The aforementioned old driver [1] was monolitic and now this patch set tries
> to mix FEC and DSA.
>
> Open issues:
> - I do have a hard time on understanding how to "disable" ENET-MAC{01} ports
> in DSA (via port_disable callback in dsa_switch_ops).
> When I disable L2 switch port1,2 or the ENET-MAC{01} in control register, I
> cannot simply re-enable it with enabling this bit again. The old driver reset
> (and setup again) the whole switch.

You don't have to disable the ports if that does more harm than good, of course.

> - The L2 switch is part of the SoC silicon, so we cannot follow the "normal" DSA
> pattern with "attaching" it via mdio device. The switch reuses already well
> defined ENET-MAC{01}. For that reason the MoreThanIP switch driver is
> registered as platform device

That is not a problem. Also, I would not say that the "normal" DSA
pattern is to have an MDIO-attached switch. Maybe that was true 10 years
ago. But now, we have DSA switches registered as platform devices, I2C
devices, SPI devices, PCI devices. That is not an issue under any
circumstance.

> - The question regarding power management - at least for my use case there
> is no need for runtime power management. The L2 switch shall work always at
> it connects other devices.
>
> - The FEC clock is also used for L2 switch management and configuration (as
> the L2 switch is just in the same, large IP block). For now I just keep it
> enabled so DSA code can use it. It looks a bit problematic to export
> fec_enet_clk_enable() to be reused on DSA code.
>
> Links:
> [0] - "i.MX28 Applications Processor Reference Manual, Rev. 2, 08/2013"
> [1] - https://github.com/lmajewski/linux-imx28-l2switch/commit/e3c7a6eab73401e021aef0070e1935a0dba84fb5

Disclaimer: I don't know the details of imx28, it's just now that I
downloaded the reference manual to see what it's about.

I would push back and say that the switch offers bridge acceleration for
the FEC. The fact that the bridge acceleration is provided by a different
vendor and requires access to an extra set of register blocks is immaterial.
To qualify as a DSA switch, you need to have indirect networking I/O
through a different network interface. You do not have that. What I
would do is I would expand the fec driver into something that, on
capable SoCs, detects bridging of the ENET_MAC0 and ENETC_MAC1 ports and
configures the switch accordingly to offload that in a seamless manner
for the user. This would also solve your power management issues, since
the entire Ethernet block would be handled by a single driver.
DSA is a complication you do not need. Convince me otherwise.

Also, side note.
Please, please, please, stop calling it "l2 switch" and use something
more specific. If everybody writing a driver for the Linux kernel called
their L2 switch "L2 switch", we would go crazy. The kernel is not a deep
silo like the hardware team that integrated this MTIP switching IP into
imx28, and for whom this L2 switch is the only switch that exists, and
therefore for whom no further qualification was necessary. Andy, Peng or
Fabio might be able to give you a reference to an internal code name
that you can use, or something. Otherwise, I don't care if you need to
invent a name yourself - be as creative as you feel like. mtip-fec-switch,
charlie, matilda, brunhild, all fine by me.
