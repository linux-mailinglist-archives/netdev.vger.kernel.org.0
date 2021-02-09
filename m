Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0259314E65
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbhBILou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhBILle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 06:41:34 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28C6EC06178A
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 03:40:54 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id t63so17597466qkc.1
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 03:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=41hi0c02oO4tuVV9L3cubuwMoL173xYyde0J3gmHoXc=;
        b=fCj4pquVd+PYGzXHqiOzDIiiXRItclK5wdS6DU24eUPtYG+9Cggfj3eH70jg+mmE2X
         Kc8C4HjFPJ+96a6fmoFEq9Vj+0JBrS3CEusK9LwAu/fmTYSQvI8dRDE3r8DTwJaVKxOS
         dioyYvCpcHCKJubWfmmxabMaMeJ1m1R8tKy5MLKvdLpen13KO/+3fKblqdX2y/3qxgrm
         rYH1YnUtRSO420arDanE5tBHaDrrcPgP6AamClV1ZnhQkximvTzpj6ggX5lIU+ladOAi
         uNEE2LlTLBtxa+5FoaGjWipXnBbskEAWG+dKZcKd5WzHjNGyMYE9lp7IUX7stfa7WJv4
         0YAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=41hi0c02oO4tuVV9L3cubuwMoL173xYyde0J3gmHoXc=;
        b=g12Y1Lfgt3s575nxGE8aE0/iIKXntsQViwUOVQevxbUqT3C+QUEuhteFSaab+Y1OQ9
         3XJr31SAbqI83K3YZ+qo9y+Xw30vlJyhAB3KYGAIUR19NZh/HmYj+b2HZG7ON8CpMQ/l
         njgLwFUnK3cKi0qud940sy2RINf/KZfhHc/m3MztWCB2bBz6RkJOV7Q80VYY1wF2V+SL
         QS4zpdi+xIjQYcUztgoFFjEGC+B5a3wnqdM+S2BrJtc/lH/iAaHpYYNsnZcJQPycPo5S
         YL+P3shjmyDAZfx/rrQh2K+100ADwdg13f1w9HP0k72nmD4jgftEB3VR9kPa/fqGvXJp
         cnNA==
X-Gm-Message-State: AOAM530iDxHY/f9BDBsDQ5KP6fuGjZF6uyAKsvzm5mIU/9UZ7I/QVvyI
        /P1Xn5vHnKhlzIUBazau4vjGNkHiF2620IjvBVgGwg==
X-Google-Smtp-Source: ABdhPJxCHSJNQXMjgze7X9u2yZHdDNqVyw+Bk6ovFO5Ibu9/5qGY8UcJiI9iON3FJkM1rECcEHVerJiY6P8pQKYSQYs=
X-Received: by 2002:a37:74b:: with SMTP id 72mr20666133qkh.155.1612870853195;
 Tue, 09 Feb 2021 03:40:53 -0800 (PST)
MIME-Version: 1.0
References: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1612860151-12275-1-git-send-email-stefanc@marvell.com>
From:   Marcin Wojtas <mw@semihalf.com>
Date:   Tue, 9 Feb 2021 12:40:41 +0100
Message-ID: <CAPv3WKfbz6c69ON_gd7yu41QFU+C9qtoW1P=+P-NKZ7vQLE5FA@mail.gmail.com>
Subject: Re: [PATCH v11 net-next 00/15] net: mvpp2: Add TX Flow Control support
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>, nadavh@marvell.com,
        Yan Markman <ymarkman@marvell.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>, atenart@kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?UTF-8?Q?Gr=C3=A9gory_Clement?= <gregory.clement@bootlin.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

wt., 9 lut 2021 o 09:43 <stefanc@marvell.com> napisa=C5=82(a):
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Armada hardware has a pause generation mechanism in GOP (MAC).
> The GOP generate flow control frames based on an indication programmed in=
 Ports Control 0 Register. There is a bit per port.
> However assertion of the PortX Pause bits in the ports control 0 register=
 only sends a one time pause.
> To complement the function the GOP has a mechanism to periodically send p=
ause control messages based on periodic counters.
> This mechanism ensures that the pause is effective as long as the Appropr=
iate PortX Pause is asserted.
>
> Problem is that Packet Processor that actually can drop packets due to la=
ck of resources not connected to the GOP flow control generation mechanism.
> To solve this issue Armada has firmware running on CM3 CPU dedicated for =
Flow Control support.
> Firmware monitors Packet Processor resources and asserts XON/XOFF by writ=
ing to Ports Control 0 Register.
>
> MSS shared SRAM memory used to communicate between CM3 firmware and PP2 d=
river.
> During init PP2 driver informs firmware about used BM pools, RXQs, conges=
tion and depletion thresholds.
>
> The pause frames are generated whenever congestion or depletion in resour=
ces is detected.
> The back pressure is stopped when the resource reaches a sufficient level=
.
> So the congestion/depletion and sufficient level implement a hysteresis t=
hat reduces the XON/XOFF toggle frequency.
>
> Packet Processor v23 hardware introduces support for RX FIFO fill level m=
onitor.
> Patch "add PPv23 version definition" to differ between v23 and v22 hardwa=
re.
> Patch "add TX FC firmware check" verifies that CM3 firmware supports Flow=
 Control monitoring.
>
> v10 --> v11
> - Improve "net: mvpp2: add CM3 SRAM memory map" comment
> - Move condition check to 'net: mvpp2: always compare hw-version vs MVPP2=
1' patch
>
> v9 --> v10
> - Add CM3 SRAM description to PPv2 documentation
>
> v8 --> v9
> - Replace generic pool allocation with devm_ioremap_resource
>
> v7 --> v8
> - Reorder "always compare hw-version vs MVPP21" and "add PPv23 version de=
finition" commits
> - Typo fixes
> - Remove condition fix from "add RXQ flow control configurations"
>
> v6 --> v7
> - Reduce patch set from 18 to 15 patches
>  - Documentation change combined into a single patch
>  - RXQ and BM size change combined into a single patch
>  - Ring size change check moved into "add RXQ flow control configurations=
" commit
>
> v5 --> v6
> - No change
>
> v4 --> v5
> - Add missed Signed-off
> - Fix warnings in patches 3 and 12
> - Add revision requirement to warning message
> - Move mss_spinlock into RXQ flow control configurations patch
> - Improve FCA RXQ non occupied descriptor threshold commit message
>
> v3 --> v4
> - Remove RFC tag
>
> v2 --> v3
> - Remove inline functions
> - Add PPv2.3 description into marvell-pp2.txt
> - Improve mvpp2_interrupts_mask/unmask procedure
> - Improve FC enable/disable procedure
> - Add priv->sram_pool check
> - Remove gen_pool_destroy call
> - Reduce Flow Control timer to x100 faster
>
> v1 --> v2
> - Add memory requirements information
> - Add EPROBE_DEFER if of_gen_pool_get return NULL
> - Move Flow control configuration to mvpp2_mac_link_up callback
> - Add firmware version info with Flow control support
>
> Konstantin Porotchkin (1):
>   dts: marvell: add CM3 SRAM memory to cp11x ethernet device tree
>
> Stefan Chulski (14):
>   doc: marvell: add CM3 address space and PPv2.3 description
>   net: mvpp2: add CM3 SRAM memory map
>   net: mvpp2: always compare hw-version vs MVPP21
>   net: mvpp2: add PPv23 version definition
>   net: mvpp2: increase BM pool and RXQ size
>   net: mvpp2: add FCA periodic timer configurations
>   net: mvpp2: add FCA RXQ non occupied descriptor threshold
>   net: mvpp2: enable global flow control
>   net: mvpp2: add RXQ flow control configurations
>   net: mvpp2: add ethtool flow control configuration support
>   net: mvpp2: add BM protection underrun feature support
>   net: mvpp2: add PPv23 RX FIFO flow control
>   net: mvpp2: set 802.3x GoP Flow Control mode
>   net: mvpp2: add TX FC firmware check
>
>  Documentation/devicetree/bindings/net/marvell-pp2.txt |   6 +-
>  arch/arm64/boot/dts/marvell/armada-cp11x.dtsi         |   2 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h            | 124 ++++-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       | 526 ++++++++++++=
++++++--
>  4 files changed, 609 insertions(+), 49 deletions(-)
>

For the series:
Acked-by: Marcin Wojtas <mw@semihalf.com>

Thanks,
Marcin
