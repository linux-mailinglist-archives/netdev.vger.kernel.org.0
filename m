Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DCA3564E52
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233241AbiGDHI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232982AbiGDHIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:08:05 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CE0958F;
        Mon,  4 Jul 2022 00:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1656918475; x=1688454475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AgnZ/0GTsI5N0Vyb3VmA0aulIyEF8kyx7iX2ZYUNwqY=;
  b=fI6PIOcCNHbueT+UWd4e8oeNh64huXABoRcBiayGlgaAHgxauL7Jou8c
   SeEuYKRhvKoqJUsitl8F7gVGEN/Txos9m/as6NABcR8Zoi6YtUPZRh71m
   cexVjuZU+cg9FiKuEumI0D4jOV8yULYaf1A8HHtQuwIyEoWa0zK4JJEyn
   y4zvUO5L7Zvk0TKXnp9bcxpJAfAcnTRL0AB+p00eBX9BFjGJC3tlrQAli
   ecj1y7sZtYlK4De5ODGRrZjJd1s5RbDvrenBbyVcIevFVdMaeMBvAIdCx
   WeerA93nTOf+4rByiy0Enhf9hmO5OnDZC9bC2MqW8ddV8LBnJuekilEZw
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650924000"; 
   d="scan'208";a="24825060"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 04 Jul 2022 09:07:52 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 04 Jul 2022 09:07:52 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 04 Jul 2022 09:07:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1656918472; x=1688454472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AgnZ/0GTsI5N0Vyb3VmA0aulIyEF8kyx7iX2ZYUNwqY=;
  b=LDsL/qkgTLzLCiPw0J1xSWUct9sHyZrn+x98rgSroq34z+NFujNwgraa
   cq1AbZNacqmgfIS3WcoWHUGz0pf3QZvd+UR5qyDOfUODNyR9g+UdqTJSz
   H7qUPSd+RW8A1BUbFQNrAYR9nfOdFhQuMqrkmAjDEE9UH8tHhIsG3fJ6Y
   FVPSBOHKjmmGquzgpSVNx0vt/WECg3USZVHgWZ3p34RIYbLqrfwqNFGeT
   ekkBex+cCC0951V4IKOqgDWDqqMCgPhCvxXuMQJzxBbU/1ODpLglwlkKv
   5oC5SqlB3Ue39Dgh9nt2YTZw3swiPA6vJei+ZVfZT964Seidcqdvez+rj
   A==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650924000"; 
   d="scan'208";a="24825059"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 04 Jul 2022 09:07:51 +0200
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 6A945280071;
        Mon,  4 Jul 2022 09:07:51 +0200 (CEST)
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
Subject: Re: (EXT) Re: (EXT) Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
Date:   Mon, 04 Jul 2022 09:07:48 +0200
Message-ID: <5717577.DvuYhMxLoT@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <CAGETcx-fLAXnG+1S4MHJwg9t7O6jj6Mp+q25bh==C_Z1CLs-mg@mail.gmail.com>
References: <20220601070707.3946847-1-saravanak@google.com> <5265491.31r3eYUQgx@steina-w> <CAGETcx-fLAXnG+1S4MHJwg9t7O6jj6Mp+q25bh==C_Z1CLs-mg@mail.gmail.com>
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

Am Freitag, 1. Juli 2022, 09:02:22 CEST schrieb Saravana Kannan:
> On Thu, Jun 30, 2022 at 11:02 PM Alexander Stein
> 
> <alexander.stein@ew.tq-group.com> wrote:
> > Hi Saravana,
> > 
> > Am Freitag, 1. Juli 2022, 02:37:14 CEST schrieb Saravana Kannan:
> > > On Thu, Jun 23, 2022 at 5:08 AM Alexander Stein
> > > 
> > > <alexander.stein@ew.tq-group.com> wrote:
> > > > Hi,
> > > > 
> > > > Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony Lindgren:
> > > > > Hi,
> > > > > 
> > > > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > > > "power-domains" property, the execution will never get to the
> > > > > > point
> > > > > > where driver_deferred_probe_check_state() is called before the
> > > > > > supplier
> > > > > > has probed successfully or before deferred probe timeout has
> > > > > > expired.
> > > > > > 
> > > > > > So, delete the call and replace it with -ENODEV.
> > > > > 
> > > > > Looks like this causes omaps to not boot in Linux next. With this
> > > > > simple-pm-bus fails to probe initially as the power-domain is not
> > > > > yet available. On platform_probe() genpd_get_from_provider() returns
> > > > > -ENOENT.
> > > > > 
> > > > > Seems like other stuff is potentially broken too, any ideas on
> > > > > how to fix this?
> > > > 
> > > > I think I'm hit by this as well, although I do not get a lockup.
> > > > In my case I'm using
> > > > arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts and probing of
> > > > 38320000.blk-ctrl fails as the power-domain is not (yet) registed.
> > > 
> > > Ok, took a look.
> > > 
> > > The problem is that there are two drivers for the same device and they
> > > both initialize this device.
> > > 
> > >     gpc: gpc@303a0000 {
> > >     
> > >         compatible = "fsl,imx8mq-gpc";
> > >     
> > >     }
> > > 
> > > $ git grep -l "fsl,imx7d-gpc" -- drivers/
> > > drivers/irqchip/irq-imx-gpcv2.c
> > > drivers/soc/imx/gpcv2.c
> > > 
> > > IMHO, this is a bad/broken design.
> > > 
> > > So what's happening is that fw_devlink will block the probe of
> > > 38320000.blk-ctrl until 303a0000.gpc is initialized. And it stops
> > > blocking the probe of 38320000.blk-ctrl as soon as the first driver
> > > initializes the device. In this case, it's the irqchip driver.
> > > 
> > > I'd recommend combining these drivers into one. Something like the
> > > patch I'm attaching (sorry for the attachment, copy-paste is mangling
> > > the tabs). Can you give it a shot please?
> > 
> > I tried this patch and it delayed the driver initialization (those of UART
> > as
> > well BTW). Unfortunately the driver fails the same way:
> Thanks for testing the patch!
> 
> > > [    1.125253] imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV: failed
> > > to
> > 
> > attach power domain "bus"
> > 
> > More than that it even introduced some more errors:
> > > [    0.008160] irq: no irq domain found for gpc@303a0000 !
> 
> So the idea behind my change was that as long as the irqchip isn't the
> root of the irqdomain (might be using the terms incorrectly) like the
> gic, you can make it a platform driver. And I was trying to hack up a
> patch that's the equivalent of platform_irqchip_probe() (which just
> ends up eventually calling the callback you use in IRQCHIP_DECLARE().
> I probably made some mistake in the quick hack that I'm sure if
> fixable.
> 
> > > [    0.013251] Failed to map interrupt for
> > > /soc@0/bus@30400000/timer@306a0000
> 
> However, this timer driver also uses TIMER_OF_DECLARE() which can't
> handle failure to get the IRQ (because it's can't -EPROBE_DEFER). So,
> this means, the timer driver inturn needs to be converted to a
> platform driver if it's supposed to work with the IRQCHIP_DECLARE()
> being converted to a platform driver.
> 
> But that's a can of worms not worth opening. But then I remembered
> this simpler workaround will work and it is pretty much a variant of
> the workaround that's already in the gpc's irqchip driver to allow two
> drivers to probe the same device (people really should stop doing
> that).
> 
> Can you drop my previous hack patch and try this instead please? I'm
> 99% sure this will work.
> 
> diff --git a/drivers/irqchip/irq-imx-gpcv2.c
> b/drivers/irqchip/irq-imx-gpcv2.c index b9c22f764b4d..8a0e82067924 100644
> --- a/drivers/irqchip/irq-imx-gpcv2.c
> +++ b/drivers/irqchip/irq-imx-gpcv2.c
> @@ -283,6 +283,7 @@ static int __init imx_gpcv2_irqchip_init(struct
> device_node *node,
>          * later the GPC power domain driver will not be skipped.
>          */
>         of_node_clear_flag(node, OF_POPULATED);
> +       fwnode_dev_initialized(domain->fwnode, false);
>         return 0;
>  }

Just to be sure here, I tried this patch on top of next-20220701 but 
unfortunately this doesn't fix the original problem either. The timer errors 
are gone though.
The probe of imx8m-blk-ctrl got slightly delayed (from 0.74 to 0.90s printk 
time) but results in the identical error message.

Best regards,
Alexander



