Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF1C2562B2A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiGAGCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiGAGCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:02:07 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF916B81E;
        Thu, 30 Jun 2022 23:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1656655322; x=1688191322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88W0IhCdmASo0Tm8efAxg0rx5GK9cZqYIieLJEzdB/g=;
  b=QC9t5NAwDpvtU481hI8sRR3goRJzZE4rgZUjX0al6s5zQ3xYH3Xjd0Mw
   UEKNoyxe/DpdLBakPbBkTxeFxZaf7pQBotqD0St+9+bFy/M5igxgubTHr
   1oQbDFf+VRYA5iAk7QdCrZpgYXhmx4eUXtNmXiPIdmdtEv6tH/F5zdhP8
   FakkAS33Rmw59RgFCTR8ow0J6VOIUsQUsvi1BDQ9vmi8zhM161YkLbs65
   CDIQz/0ufdUrHv/o+DQVNuH3+H3fp43JoNcAy6wPtczyT1QmwUYgneC+h
   Gewx5fAvc13z0wZCUGvnH94UxjlLUm7CcjtWm8ZyPvXN1/mUODotch7QZ
   w==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650924000"; 
   d="scan'208";a="24791549"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 01 Jul 2022 08:01:59 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Fri, 01 Jul 2022 08:01:59 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Fri, 01 Jul 2022 08:01:59 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1656655319; x=1688191319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=88W0IhCdmASo0Tm8efAxg0rx5GK9cZqYIieLJEzdB/g=;
  b=K6Q2CfywRqDUvlFcJVmFu6SslcG04+Frpxyc2nE7tT9SSWUzopX9hnsx
   i6hJLpLOtTHT9IVKGQC+koLLc/A/bGGIkSAIfUyMDrKbj4CHLsr+sUstl
   aKw3+7dp0h/TxION+F2+Bk8XlOfNfla4YtFnUkE/YnWbuQ43uXkNzO17g
   UCnShk/d3oJONlpNe5O3TXeunAeL5rX6ZhnfYiWsDMOQpN4WIeq0x9MvP
   FUNanteNRubdyH9vtorxD286thuUKE7eIO6xZuLlN0TxahRJb8e/k6vez
   V5LBq6rqg/eU0Vz1vkuGh6ZK93H6lyFCyiRsOzS4gP/elcCZNoqD85/w0
   g==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650924000"; 
   d="scan'208";a="24791548"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 01 Jul 2022 08:01:59 +0200
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 8C3D0280071;
        Fri,  1 Jul 2022 08:01:58 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: (EXT) Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
Date:   Fri, 01 Jul 2022 08:01:56 +0200
Message-ID: <5265491.31r3eYUQgx@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <CAGETcx_1qa=gGT4LVkyPpcA1vFM9FzuJE+0DhL_nFyg5cbFjVg@mail.gmail.com>
References: <20220601070707.3946847-1-saravanak@google.com> <4799738.LvFx2qVVIh@steina-w> <CAGETcx_1qa=gGT4LVkyPpcA1vFM9FzuJE+0DhL_nFyg5cbFjVg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

Am Freitag, 1. Juli 2022, 02:37:14 CEST schrieb Saravana Kannan:
> On Thu, Jun 23, 2022 at 5:08 AM Alexander Stein
> 
> <alexander.stein@ew.tq-group.com> wrote:
> > Hi,
> > 
> > Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony Lindgren:
> > > Hi,
> > > 
> > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > "power-domains" property, the execution will never get to the point
> > > > where driver_deferred_probe_check_state() is called before the
> > > > supplier
> > > > has probed successfully or before deferred probe timeout has expired.
> > > > 
> > > > So, delete the call and replace it with -ENODEV.
> > > 
> > > Looks like this causes omaps to not boot in Linux next. With this
> > > simple-pm-bus fails to probe initially as the power-domain is not
> > > yet available. On platform_probe() genpd_get_from_provider() returns
> > > -ENOENT.
> > > 
> > > Seems like other stuff is potentially broken too, any ideas on
> > > how to fix this?
> > 
> > I think I'm hit by this as well, although I do not get a lockup.
> > In my case I'm using
> > arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts and probing of
> > 38320000.blk-ctrl fails as the power-domain is not (yet) registed.
> 
> Ok, took a look.
> 
> The problem is that there are two drivers for the same device and they
> both initialize this device.
> 
>     gpc: gpc@303a0000 {
>         compatible = "fsl,imx8mq-gpc";
>     }
> 
> $ git grep -l "fsl,imx7d-gpc" -- drivers/
> drivers/irqchip/irq-imx-gpcv2.c
> drivers/soc/imx/gpcv2.c
> 
> IMHO, this is a bad/broken design.
> 
> So what's happening is that fw_devlink will block the probe of
> 38320000.blk-ctrl until 303a0000.gpc is initialized. And it stops
> blocking the probe of 38320000.blk-ctrl as soon as the first driver
> initializes the device. In this case, it's the irqchip driver.
> 
> I'd recommend combining these drivers into one. Something like the
> patch I'm attaching (sorry for the attachment, copy-paste is mangling
> the tabs). Can you give it a shot please?

I tried this patch and it delayed the driver initialization (those of UART as 
well BTW). Unfortunately the driver fails the same way:
> [    1.125253] imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV: failed to 
attach power domain "bus"

More than that it even introduced some more errors:
> [    0.008160] irq: no irq domain found for gpc@303a0000 !
> [    0.013251] Failed to map interrupt for
> /soc@0/bus@30400000/timer@306a0000
> [    0.020152] Failed to initialize '/soc@0/bus@30400000/timer@306a0000':
> -22

I kept the timestamps to show that these errors happen very early. So now the 
usage of the "global" interrupt parent, set at line 18,
> interrupt-parent = <&gpc>;
is not possible at this point of boot time.

Best regards,
Alexander



