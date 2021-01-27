Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E08C3062C7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 18:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344301AbhA0R4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 12:56:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344230AbhA0R43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 12:56:29 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE0FC061573;
        Wed, 27 Jan 2021 09:55:47 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id a14so3508402edu.7;
        Wed, 27 Jan 2021 09:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=07Cx0N7sAlmEOm8aYQT87xr1W2lqhgpffncnWFRCnP4=;
        b=thRrDb4M6i7H+/Q0rN5HgZ5qk0CqvTqxSqybrupAUpmSgx8EEF8SpebZ0mPlkrXXN7
         gXa08Pymbv1Qk2XIMm4tdAOGuX6Sy8PSvopduGLW1dfK0S7x+uTfRyYz7E+xtVzhW247
         BUZzfK7i2jgJ/tSWFa3NH0oXEt8jiYnoRBu9h/jEOqQbjUTY8aaaBlaDd6pSUzQchkx/
         P8Xdv5IwUA8ITUenmkEoICcexierBpyjN3MSA23U17L5/vOlXkprSwTZe1iqrEd/RBn+
         936kSxsp0CDqBzQmUHBikt16jCGIJss6GHbcDKYsTz7oG3bgn94g8/aiAd69C/gQiAZO
         46VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=07Cx0N7sAlmEOm8aYQT87xr1W2lqhgpffncnWFRCnP4=;
        b=DC43uP4aRmN0dLN453pdlX1MEii1HGjMyTxz848g4nYVEjEKG6w1Zc01H5kGpywa6c
         eKUdSDfA7d8OSdbrrE7GwTm/GSePpd8TvjIuoOrXjTPiytTXQ+Ev10Ol/kBlVmecB3Mx
         2yFjn4/t5M0g3sUrLHL1VjoMrzFD5l0sOMcJDeznH5j1Wdx6Vu74D96oAGXQmF+z0cNo
         izDOHsu0PahBSqdNL+wzAUz8THzDVeIHyDjFMdr40ikbt9FvpSehwaxtvSPRvqOJ1WSi
         4x97//GyiqN8Mvk+cNuqbQ70t/kTyTbOuwCnqwOg+z+lVpq9tdPXyty9Ersqe9iimc5T
         bpNQ==
X-Gm-Message-State: AOAM530pYObvSk3/3hE7esKT97SzSz2UD4QWIuiAMk6PxocP97lPEsWI
        iLme2v1RI1HWDpVtV2+821jvBPPJVoVnf8bW68QzLyQB
X-Google-Smtp-Source: ABdhPJw+neJO3ns0B/lkgaMsFxlurgebNb7cIoBLzD0i0hZXGdXXwjXd0HHJSW0a+i0f6mcZo4f27jcDHwZ7CvV+XR8=
X-Received: by 2002:a05:6402:31bb:: with SMTP id dj27mr10156316edb.285.1611770146616;
 Wed, 27 Jan 2021 09:55:46 -0800 (PST)
MIME-Version: 1.0
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 27 Jan 2021 12:55:10 -0500
Message-ID: <CAF=yD-+nk3f+7oshk_rPx0GdOf6oqeUXYCZyDZJANM6P4rAHng@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 00/19] net: mvpp2: Add TX Flow Control support
To:     stefanc@marvell.com
Cc:     Network Development <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Miller <davem@davemloft.net>, nadavh@marvell.com,
        ymarkman@marvell.com, LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux@armlinux.org.uk,
        mw@semihalf.com, Andrew Lunn <andrew@lunn.ch>,
        rmk+kernel@armlinux.org.uk, Antoine Tenart <atenart@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 6:50 AM <stefanc@marvell.com> wrote:
>
> From: Stefan Chulski <stefanc@marvell.com>
>
> Armada hardware has a pause generation mechanism in GOP (MAC).
> The GOP generate flow control frames based on an indication programmed in Ports Control 0 Register. There is a bit per port.
> However assertion of the PortX Pause bits in the ports control 0 register only sends a one time pause.
> To complement the function the GOP has a mechanism to periodically send pause control messages based on periodic counters.
> This mechanism ensures that the pause is effective as long as the Appropriate PortX Pause is asserted.
>
> Problem is that Packet Processor that actually can drop packets due to lack of resources not connected to the GOP flow control generation mechanism.
> To solve this issue Armada has firmware running on CM3 CPU dedicated for Flow Control support.
> Firmware monitors Packet Processor resources and asserts XON/XOFF by writing to Ports Control 0 Register.
>
> MSS shared SRAM memory used to communicate between CM3 firmware and PP2 driver.
> During init PP2 driver informs firmware about used BM pools, RXQs, congestion and depletion thresholds.
>
> The pause frames are generated whenever congestion or depletion in resources is detected.
> The back pressure is stopped when the resource reaches a sufficient level.
> So the congestion/depletion and sufficient level implement a hysteresis that reduces the XON/XOFF toggle frequency.
>
> Packet Processor v23 hardware introduces support for RX FIFO fill level monitor.
> Patch "add PPv23 version definition" to differ between v23 and v22 hardware.
> Patch "add TX FC firmware check" verifies that CM3 firmware supports Flow Control monitoring.
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
>   dts: marvell: add CM3 SRAM memory to cp115 ethernet device tree
>
> Stefan Chulski (18):
>   doc: marvell: add cm3-mem device tree bindings description
>   net: mvpp2: add CM3 SRAM memory map
>   doc: marvell: add PPv2.3 description to marvell-pp2.txt
>   net: mvpp2: add PPv23 version definition
>   net: mvpp2: always compare hw-version vs MVPP21
>   net: mvpp2: increase BM pool size to 2048 buffers
>   net: mvpp2: increase RXQ size to 1024 descriptors
>   net: mvpp2: add FCA periodic timer configurations
>   net: mvpp2: add FCA RXQ non occupied descriptor threshold
>   net: mvpp2: add spinlock for FW FCA configuration path
>   net: mvpp2: enable global flow control
>   net: mvpp2: add RXQ flow control configurations
>   net: mvpp2: add ethtool flow control configuration support
>   net: mvpp2: add BM protection underrun feature support
>   net: mvpp2: add PPv23 RX FIFO flow control
>   net: mvpp2: set 802.3x GoP Flow Control mode
>   net: mvpp2: limit minimum ring size to 1024 descriptors
>   net: mvpp2: add TX FC firmware check
>
>  Documentation/devicetree/bindings/net/marvell-pp2.txt |   4 +-
>  arch/arm64/boot/dts/marvell/armada-cp11x.dtsi         |  10 +
>  drivers/net/ethernet/marvell/mvpp2/mvpp2.h            | 130 ++++-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c       | 564 ++++++++++++++++++--
>  4 files changed, 658 insertions(+), 50 deletions(-)

Besides the per patch comments, see also the patchwork state for the
patches. Patch 3 and 12 seem to introduce new build warnings or
errors. And one patch misses the sign-off of the author in the From
line.
