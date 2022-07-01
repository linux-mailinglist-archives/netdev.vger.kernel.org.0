Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14AB562B49
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233903AbiGAGMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233375AbiGAGMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:12:38 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B2F61A83D;
        Thu, 30 Jun 2022 23:12:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id A72FA80B0;
        Fri,  1 Jul 2022 06:07:18 +0000 (UTC)
Date:   Fri, 1 Jul 2022 09:12:35 +0300
From:   Tony Lindgren <tony@atomide.com>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "open list:THERMAL" <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of
 driver_deferred_probe_check_state()
Message-ID: <Yr6QUzdoFWv/eAI6@atomide.com>
References: <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com>
 <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com>
 <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com>
 <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
 <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
 <CAGETcx9ZmeTyP1sJCFZ9pBbMyXeifQFohFvWN3aBPx0sSOJ2VA@mail.gmail.com>
 <Yr6HQOtS4ctUYm9m@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr6HQOtS4ctUYm9m@atomide.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [220701 08:33]:
> * Saravana Kannan <saravanak@google.com> [220630 23:25]:
> > On Thu, Jun 30, 2022 at 4:26 PM Rob Herring <robh@kernel.org> wrote:
> > >
> > > On Thu, Jun 30, 2022 at 5:11 PM Saravana Kannan <saravanak@google.com> wrote:
> > > >
> > > > On Mon, Jun 27, 2022 at 2:10 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > >
> > > > > * Saravana Kannan <saravanak@google.com> [220623 08:17]:
> > > > > > On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > >
> > > > > > > * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > > > > > > > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > > > This issue is no directly related fw_devlink. It is a side effect of
> > > > > > > > > removing driver_deferred_probe_check_state(). We no longer return
> > > > > > > > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> > > > > > > >
> > > > > > > > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > > > > > > > was deleted because fw_devlink=on should have short circuited the
> > > > > > > > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > > > > > > > probe function and hitting this -ENOENT failure. That's why I was
> > > > > > > > asking the other questions.
> > > > > > >
> > > > > > > OK. So where is the -EPROBE_DEFER supposed to happen without
> > > > > > > driver_deferred_probe_check_state() then?
> > > > > >
> > > > > > device_links_check_suppliers() call inside really_probe() would short
> > > > > > circuit and return an -EPROBE_DEFER if the device links are created as
> > > > > > expected.
> > > > >
> > > > > OK
> > > > >
> > > > > > > Hmm so I'm not seeing any supplier for the top level ocp device in
> > > > > > > the booting case without your patches. I see the suppliers for the
> > > > > > > ocp child device instances only.
> > > > > >
> > > > > > Hmmm... this is strange (that the device link isn't there), but this
> > > > > > is what I suspected.
> > > > >
> > > > > Yup, maybe it's because of the supplier being a device in the child
> > > > > interconnect for the ocp.
> > > >
> > > > Ugh... yeah, this is why the normal (not SYNC_STATE_ONLY) device link
> > > > isn't being created.
> > > >
> > > > So the aggregated view is something like (I had to set tabs = 4 space
> > > > to fit it within 80 cols):
> > > >
> > > >     ocp: ocp {         <========================= Consumer
> > > >         compatible = "simple-pm-bus";
> > > >         power-domains = <&prm_per>; <=========== Supplier ref
> > > >
> > > >                 l4_wkup: interconnect@44c00000 {
> > > >             compatible = "ti,am33xx-l4-wkup", "simple-pm-bus";
> > > >
> > > >             segment@200000 {  /* 0x44e00000 */
> > > >                 compatible = "simple-pm-bus";
> > > >
> > > >                 target-module@0 { /* 0x44e00000, ap 8 58.0 */
> > > >                     compatible = "ti,sysc-omap4", "ti,sysc";
> > > >
> > > >                     prcm: prcm@0 {
> > > >                         compatible = "ti,am3-prcm", "simple-bus";
> > > >
> > > >                         prm_per: prm@c00 { <========= Actual Supplier
> > > >                             compatible = "ti,am3-prm-inst", "ti,omap-prm-inst";
> > > >                         };
> > > >                     };
> > > >                 };
> > > >             };
> > > >         };
> > > >     };
> > > >
> > > > The power-domain supplier is the great-great-great-grand-child of the
> > > > consumer. It's not clear to me how this is valid. What does it even
> > > > mean?
> > > >
> > > > Rob, is this considered a valid DT?
> > >
> > > Valid DT for broken h/w.
> > 
> > I'm not sure even in that case it's valid. When the parent device is
> > in reset (when the SoC is coming out of reset), there's no way the
> > descendant is functional. And if the descendant is not functional, how
> > is the parent device powered up? This just feels like an incorrect
> > representation of the real h/w.
> 
> It should be correct representation based on scanning the interconnects
> and looking at the documentation. Some interconnect parts are wired
> always-on and some interconnect instances may be dual-mapped.
> 
> We have a quirk to probe prm/prcm first with pdata_quirks_init_clocks().
> Maybe that also now fails in addition to the top level interconnect
> probing no longer producing -EPROBE_DEFER.
> 
> > > So the domain must be default on and then simple-pm-bus is going to
> > > hold a reference to the domain preventing it from ever getting powered
> > > off and things seem to work. Except what happens during suspend?
> > 
> > But how can simple-pm-bus even get a reference? The PM domain can't
> > get added until we are well into the probe of the simple-pm-bus and
> > AFAICT the genpd attach is done before the driver probe is even
> > called.
> 
> The prm/prcm gets of_platform_populate() called on it early.

The hackish patch below makes things boot for me, not convinced this
is the preferred fix compared to earlier deferred probe handling though.
Going back to the init level tinkering seems like a step back to me.

Regards,

Tony

8< ----------------
diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -991,4 +991,9 @@ static struct platform_driver omap_prm_driver = {
 		.of_match_table	= omap_prm_id_table,
 	},
 };
-builtin_platform_driver(omap_prm_driver);
+
+static int __init omap_prm_init(void)
+{
+        return platform_driver_register(&omap_prm_driver);
+}
+subsys_initcall(omap_prm_init);
-- 
2.36.1
