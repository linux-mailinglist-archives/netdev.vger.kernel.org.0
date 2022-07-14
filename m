Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632B6574528
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 08:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiGNGlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 02:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbiGNGlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 02:41:50 -0400
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3D11F2E7;
        Wed, 13 Jul 2022 23:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1657780908; x=1689316908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=up1scXNMnYnQ0BHA0UZHK0Hve7fsYEf/AAW8bvkaxNw=;
  b=bvnEoQlaUafDkEsuIjDL0cdb70cYbOkZORLnsZ6qILgniVWeFrI5lSER
   /lwg4cazwucdMrX6RfcNDNaNgNDO6kQKUVJAeZYQn84OhZrn1rYz3R+3H
   7MLeTAAC8Jej6HmHXeDnHCACIM89Nhmbvudukc5yNxiqR2WCdCpG/5XpP
   SHJvHgNPA9iIXKnFPszMxY418t0KIDezdJCtMV0EB8Vwzp5HX9kqFQC8e
   SvY54R6whPqG8XEYblkzulCp5MrFoqLXLJH9cvb4QCOUUgw1zR6whzR8x
   fREz14VUZTSHJvDY4D1Hb5ZeL6fgOOXEVJ5X2xPTqFODrRsjuDlAvw2B1
   w==;
X-IronPort-AV: E=Sophos;i="5.92,269,1650924000"; 
   d="scan'208";a="25040844"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 14 Jul 2022 08:41:45 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 14 Jul 2022 08:41:45 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 14 Jul 2022 08:41:45 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1657780905; x=1689316905;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=up1scXNMnYnQ0BHA0UZHK0Hve7fsYEf/AAW8bvkaxNw=;
  b=TyVO8EWaHYG842SStZ0EQ8lyNPYUmgSoWOdLWMuJqy58k1I97h0lMRMc
   7FEROs4Zzl3liZNM93RhI5sVS+BPjnMu4gQU3dqjd7FsALhQmiTISvRGI
   a/+6dUXgTUmvU3IBSo6kTu1CfITh4t/JncO+QqFfQROcYcBnQrEdSBzEX
   zRJTPHe2iTXgrDM/+yZWUcI13g+kqFopcbXJHkv6t/mQsEkciEdah+7Kj
   YS0HvmYTpLH6K2vNOba2qkE8ChbFzO9zyzLuTNYv++ylsAYuzCWGngQvs
   HYm9K69Mx/bEauTfR6OtROsrtD1aUNt091GL5GpRR0IgXWQZM1onYasf/
   g==;
X-IronPort-AV: E=Sophos;i="5.92,269,1650924000"; 
   d="scan'208";a="25040843"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 14 Jul 2022 08:41:45 +0200
Received: from steina-w.localnet (unknown [10.123.49.12])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 0FB97280056;
        Thu, 14 Jul 2022 08:41:45 +0200 (CEST)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Saravana Kannan <saravanak@google.com>, l.stach@pengutronix.de
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
Subject: Re: Re: Re: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
Date:   Thu, 14 Jul 2022 08:41:42 +0200
Message-ID: <1822575.tdWV9SEqCh@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <CAGETcx8-kx7RGTPhdyEHfFoxCyaojn5BnAr_f1==b=qeWZ6itQ@mail.gmail.com>
References: <20220601070707.3946847-1-saravanak@google.com> <6079032.MhkbZ0Pkbq@steina-w> <CAGETcx8-kx7RGTPhdyEHfFoxCyaojn5BnAr_f1==b=qeWZ6itQ@mail.gmail.com>
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

Am Mittwoch, 13. Juli 2022, 02:45:06 CEST schrieb Saravana Kannan:
> On Wed, Jul 6, 2022 at 6:02 AM Alexander Stein
> <alexander.stein@ew.tq-group.com> wrote:
> 
> 
> Thanks for testing all my patches and helping me debug this.
> 
> Btw, can you try to keep the subject the same please? Looks like
> somewhere in your path [EXT] is added sometimes. lore.kernel.org keeps
> the thread together, but my email client (gmail) gets confused.

Sorry about that. Unfortunately [EXT] is inserted automatically and it is 
tedious and error-prone to remove it manually...

> > Am Dienstag, 5. Juli 2022, 03:24:33 CEST schrieb Saravana Kannan:
> > > On Mon, Jul 4, 2022 at 12:07 AM Alexander Stein
> > > 
> > > <alexander.stein@ew.tq-group.com> wrote:
> > > > Am Freitag, 1. Juli 2022, 09:02:22 CEST schrieb Saravana Kannan:
> > > > > On Thu, Jun 30, 2022 at 11:02 PM Alexander Stein
> > > > > 
> > > > > <alexander.stein@ew.tq-group.com> wrote:
> > > > > > Hi Saravana,
> > > > > > 
> > > > > > Am Freitag, 1. Juli 2022, 02:37:14 CEST schrieb Saravana Kannan:
> > > > > > > On Thu, Jun 23, 2022 at 5:08 AM Alexander Stein
> > > > > > > 
> > > > > > > <alexander.stein@ew.tq-group.com> wrote:
> > > > > > > > Hi,
> > > > > > > > 
> > > > > > > > Am Dienstag, 21. Juni 2022, 09:28:43 CEST schrieb Tony 
Lindgren:
> > > > > > > > > Hi,
> > > > > > > > > 
> > > > > > > > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > > > > > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > > > > > > > "power-domains" property, the execution will never get to
> > > > > > > > > > the
> > > > > > > > > > point
> > > > > > > > > > where driver_deferred_probe_check_state() is called before
> > > > > > > > > > the
> > > > > > > > > > supplier
> > > > > > > > > > has probed successfully or before deferred probe timeout
> > > > > > > > > > has
> > > > > > > > > > expired.
> > > > > > > > > > 
> > > > > > > > > > So, delete the call and replace it with -ENODEV.
> > > > > > > > > 
> > > > > > > > > Looks like this causes omaps to not boot in Linux next. With
> > > > > > > > > this
> > > > > > > > > simple-pm-bus fails to probe initially as the power-domain
> > > > > > > > > is
> > > > > > > > > not
> > > > > > > > > yet available. On platform_probe() genpd_get_from_provider()
> > > > > > > > > returns
> > > > > > > > > -ENOENT.
> > > > > > > > > 
> > > > > > > > > Seems like other stuff is potentially broken too, any ideas
> > > > > > > > > on
> > > > > > > > > how to fix this?
> > > > > > > > 
> > > > > > > > I think I'm hit by this as well, although I do not get a
> > > > > > > > lockup.
> > > > > > > > In my case I'm using
> > > > > > > > arch/arm64/boot/dts/freescale/imx8mq-tqma8mq-mba8mx.dts and
> > > > > > > > probing of
> > > > > > > > 38320000.blk-ctrl fails as the power-domain is not (yet)
> > > > > > > > registed.
> > > > > > > 
> > > > > > > Ok, took a look.
> > > > > > > 
> > > > > > > The problem is that there are two drivers for the same device
> > > > > > > and
> > > > > > > they
> > > > > > > both initialize this device.
> > > > > > > 
> > > > > > >     gpc: gpc@303a0000 {
> > > > > > >     
> > > > > > >         compatible = "fsl,imx8mq-gpc";
> > > > > > >     
> > > > > > >     }
> > > > > > > 
> > > > > > > $ git grep -l "fsl,imx7d-gpc" -- drivers/
> > > > > > > drivers/irqchip/irq-imx-gpcv2.c
> > > > > > > drivers/soc/imx/gpcv2.c
> > > > > > > 
> > > > > > > IMHO, this is a bad/broken design.
> > > > > > > 
> > > > > > > So what's happening is that fw_devlink will block the probe of
> > > > > > > 38320000.blk-ctrl until 303a0000.gpc is initialized. And it
> > > > > > > stops
> > > > > > > blocking the probe of 38320000.blk-ctrl as soon as the first
> > > > > > > driver
> > > > > > > initializes the device. In this case, it's the irqchip driver.
> > > > > > > 
> > > > > > > I'd recommend combining these drivers into one. Something like
> > > > > > > the
> > > > > > > patch I'm attaching (sorry for the attachment, copy-paste is
> > > > > > > mangling
> > > > > > > the tabs). Can you give it a shot please?
> > > > > > 
> > > > > > I tried this patch and it delayed the driver initialization (those
> > > > > > of
> > > > > > UART
> > > > > > as
> > > > > 
> > > > > > well BTW). Unfortunately the driver fails the same way:
> > > > > Thanks for testing the patch!
> > > > > 
> > > > > > > [    1.125253] imx8m-blk-ctrl 38320000.blk-ctrl: error -ENODEV:
> > > > > > > failed
> > > > > > > to
> > > > > > 
> > > > > > attach power domain "bus"
> > > > > > 
> > > > > > More than that it even introduced some more errors:
> > > > > > > [    0.008160] irq: no irq domain found for gpc@303a0000 !
> > > > > 
> > > > > So the idea behind my change was that as long as the irqchip isn't
> > > > > the
> > > > > root of the irqdomain (might be using the terms incorrectly) like
> > > > > the
> > > > > gic, you can make it a platform driver. And I was trying to hack up
> > > > > a
> > > > > patch that's the equivalent of platform_irqchip_probe() (which just
> > > > > ends up eventually calling the callback you use in
> > > > > IRQCHIP_DECLARE().
> > > > > I probably made some mistake in the quick hack that I'm sure if
> > > > > fixable.
> > > > > 
> > > > > > > [    0.013251] Failed to map interrupt for
> > > > > > > /soc@0/bus@30400000/timer@306a0000
> > > > > 
> > > > > However, this timer driver also uses TIMER_OF_DECLARE() which can't
> > > > > handle failure to get the IRQ (because it's can't -EPROBE_DEFER).
> > > > > So,
> > > > > this means, the timer driver inturn needs to be converted to a
> > > > > platform driver if it's supposed to work with the IRQCHIP_DECLARE()
> > > > > being converted to a platform driver.
> > > > > 
> > > > > But that's a can of worms not worth opening. But then I remembered
> > > > > this simpler workaround will work and it is pretty much a variant of
> > > > > the workaround that's already in the gpc's irqchip driver to allow
> > > > > two
> > > > > drivers to probe the same device (people really should stop doing
> > > > > that).
> > > > > 
> > > > > Can you drop my previous hack patch and try this instead please? I'm
> > > > > 99% sure this will work.
> > > > > 
> > > > > diff --git a/drivers/irqchip/irq-imx-gpcv2.c
> > > > > b/drivers/irqchip/irq-imx-gpcv2.c index b9c22f764b4d..8a0e82067924
> > > > > 100644
> > > > > --- a/drivers/irqchip/irq-imx-gpcv2.c
> > > > > +++ b/drivers/irqchip/irq-imx-gpcv2.c
> > > > > @@ -283,6 +283,7 @@ static int __init imx_gpcv2_irqchip_init(struct
> > > > > device_node *node,
> > > > > 
> > > > >          * later the GPC power domain driver will not be skipped.
> > > > >          */
> > > > >         
> > > > >         of_node_clear_flag(node, OF_POPULATED);
> > > > > 
> > > > > +       fwnode_dev_initialized(domain->fwnode, false);
> > > > > 
> > > > >         return 0;
> > > > >  
> > > > >  }
> > > > 
> > > > Just to be sure here, I tried this patch on top of next-20220701 but
> > > > unfortunately this doesn't fix the original problem either. The timer
> > > > errors are gone though.
> > > 
> > > To clarify, you had the timer issue only with my "combine drivers"
> > > patch,
> > > right?
> > 
> > That's correct.
> > 
> > > > The probe of imx8m-blk-ctrl got slightly delayed (from 0.74 to 0.90s
> > > > printk
> > > > time) but results in the identical error message.
> > > 
> > > My guess is that the probe attempt of blk-ctrl is delayed now till gpc
> > > probes (because of the device links getting created with the
> > > fwnode_dev_initialized() fix), but by the time gpc probe finishes, the
> > > power domains aren't registered yet because of the additional level of
> > > device addition and probing.
> > > 
> > > Can you try the attached patch please?
> > 
> > Sure, it needed some small fixes though. But the error still is present.
> > 
> > > And if that doesn't fix the issues, then enable the debug logs in the
> > > following functions please and share the logs from boot till the
> > > failure? If you can enable CONFIG_PRINTK_CALLER, that'd help too.
> > > device_link_add()
> > > fwnode_link_add()
> > > fw_devlink_relax_cycle()
> > 
> > I switched fw_devlink_relax_cycle() for fw_devlink_relax_link() as the
> > former has no debug output here.
> > 
> > For the record I added the following line to my kernel command line:
> > > dyndbg="func device_link_add +p; func fwnode_link_add +p; func
> > 
> > fw_devlink_relax_link +p"
> > 
> > I attached the dmesg until the probe error to this mail. But I noticed the
> > 
> > following lines which seem interesting:
> > > [    1.466620][    T8] imx-pgc imx-pgc-domain.5: Linked as a consumer to
> > > regulator.8
> > > [    1.466743][    T8] imx-pgc imx-pgc-domain.5: imx_pgc_domain_probe:
> > > Probe> 
> > succeeded
> > 
> > > [    1.474733][    T8] imx-pgc imx-pgc-domain.6: Linked as a consumer to
> > 
> > regulator.9
> > 
> > > [    1.474774][    T8] imx-pgc imx-pgc-domain.6: imx_pgc_domain_probe:
> > > Probe> 
> > succeeded
> 
> I'm guessing this happens after the probe error.
> 
> Ok, I looked at the dmesg logs and this pretty much confirms my
> thought on why the probe ordering wasn't maintained.
> 
> The power domains lack a compatible property, so the blk-ctrl is
> linked as a consumer of the gpc instead:
> [    0.343905][    T1] blk-ctrl@38320000 Linked as a fwnode consumer
> to gpc@303a0000
> [    0.343943][    T1] blk-ctrl@38320000 Linked as a fwnode consumer
> to clock-controller@30380000
> This ^^ is the device tree parsing figuring out the dependencies
> between the DT nodes.
> 
> [    0.368462][    T1] platform 38320000.blk-ctrl: Linked as a
> consumer to 30380000.clock-controller
> [    0.368542][    T1] platform 38320000.blk-ctrl: Linked as a
> consumer to 303a0000.gpc
> This ^^ is converting the DT node dependencies into device links.
> 
> So, the only real options are:
> 1. Fix DT and add a compatible string to the DT nodes.
> 2. Move the initcall level of the regulator driver so the powerdomain
> probe doesn't get deferred. Not ideal that we are playing initcall
> chicken to handle the feature meant to remove the need for initcall
> chicken. But I see these "device, but won't have a compatible
> property" as exceptions and feel it's okay to have to play with
> initcall levels to handle those.
> 3. Provide a helper function that driver that do this (creating
> devices for child DT nodes without compatible property) can use to
> move/copy their consumer device links to the child devices they add.
> And then fix up the gpc driver so that it copies the gpc -- blk-ctrl
> device link to the proper power domain.
> 4. I have another idea for how I could fix that at a driver core
> level, but I'm not sure it'll work yet and its definitely not
> something I want to try and get in for 5.19 -- too late for that IMHO.
> 
> Want to give (2) a shot so that I can still try to keep the cleanup
> series that caused this problem (that's the long term goal) while I
> give (3) and (4) a shot for 5.20?

Sure, I can give (2) a shot. Which initcall needs to be modified? You have a 
diff snippet?
BTW: this potentially affects all imx8m and imx7d as they have the same gpc 
binding.

Can't say much about (1). I added Lucas Stach to recipients, he did a lot on 
this gpc driver.
@Lucas: Do you have some input why the gpc power domains do not have a 
compatible? Is it reasonable to add them?

Best regards,
Alexander

> > regulator.8 and regulator.9 is the power sequencer, attached on I2C. This
> > also makes perfectly sense if you look at [1]ff. These power domains are
> > supplied by specific power supply rails. Several, if not all, imx8mq
> > boards have this kind of setting.
> 
> Yeah, makes sense in terms of what's going on.
> 
> -Saravana
> 
> > > Btw, part of the reason I'm trying to make sure we fix it the right
> > > way is that when we try to enable async boot by default, we don't run
> > > into issues.
> > 
> > Sounds resonable.
> > 
> > Best regards,
> > Alexander
> > 
> > [1]
> > https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/tree/
> > arch/arm64/boot/dts/freescale/imx8mq-tqma8mq.dtsi#n84




