Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2217E5633E1
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbiGANA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234982AbiGANAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:00:55 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 328604160C;
        Fri,  1 Jul 2022 06:00:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 519DF80FA;
        Fri,  1 Jul 2022 12:55:34 +0000 (UTC)
Date:   Fri, 1 Jul 2022 16:00:51 +0300
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
Message-ID: <Yr7wA8d4J7xtjwsH@atomide.com>
References: <YrQP3OZbe8aCQxKU@atomide.com>
 <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com>
 <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
 <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
 <CAGETcx9ZmeTyP1sJCFZ9pBbMyXeifQFohFvWN3aBPx0sSOJ2VA@mail.gmail.com>
 <Yr6HQOtS4ctUYm9m@atomide.com>
 <Yr6QUzdoFWv/eAI6@atomide.com>
 <CAGETcx-0bStPx8sF3BtcJFiu74NwiB0btTQ+xx_B=8B37TEb8w@mail.gmail.com>
 <CAGETcx-Yp2JKgCNfaGD0SzZg9F2Xnu8A3zXmV5=WX1hY7uR=0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-Yp2JKgCNfaGD0SzZg9F2Xnu8A3zXmV5=WX1hY7uR=0g@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Saravana Kannan <saravanak@google.com> [220701 08:21]:
> On Fri, Jul 1, 2022 at 1:10 AM Saravana Kannan <saravanak@google.com> wrote:
> >
> > On Thu, Jun 30, 2022 at 11:12 PM Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > * Tony Lindgren <tony@atomide.com> [220701 08:33]:
> > > > * Saravana Kannan <saravanak@google.com> [220630 23:25]:
> > > > > On Thu, Jun 30, 2022 at 4:26 PM Rob Herring <robh@kernel.org> wrote:
> > > > > >
> > > > > > On Thu, Jun 30, 2022 at 5:11 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > > > >
> > > > > > > On Mon, Jun 27, 2022 at 2:10 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > >
> > > > > > > > * Saravana Kannan <saravanak@google.com> [220623 08:17]:
> > > > > > > > > On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > > > >
> > > > > > > > > > * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > > > > > > > > > > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > > > > > > This issue is no directly related fw_devlink. It is a side effect of
> > > > > > > > > > > > removing driver_deferred_probe_check_state(). We no longer return
> > > > > > > > > > > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> > > > > > > > > > >
> > > > > > > > > > > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > > > > > > > > > > was deleted because fw_devlink=on should have short circuited the
> > > > > > > > > > > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > > > > > > > > > > probe function and hitting this -ENOENT failure. That's why I was
> > > > > > > > > > > asking the other questions.
> > > > > > > > > >
> > > > > > > > > > OK. So where is the -EPROBE_DEFER supposed to happen without
> > > > > > > > > > driver_deferred_probe_check_state() then?
> > > > > > > > >
> > > > > > > > > device_links_check_suppliers() call inside really_probe() would short
> > > > > > > > > circuit and return an -EPROBE_DEFER if the device links are created as
> > > > > > > > > expected.
> > > > > > > >
> > > > > > > > OK
> > > > > > > >
> > > > > > > > > > Hmm so I'm not seeing any supplier for the top level ocp device in
> > > > > > > > > > the booting case without your patches. I see the suppliers for the
> > > > > > > > > > ocp child device instances only.
> > > > > > > > >
> > > > > > > > > Hmmm... this is strange (that the device link isn't there), but this
> > > > > > > > > is what I suspected.
> > > > > > > >
> > > > > > > > Yup, maybe it's because of the supplier being a device in the child
> > > > > > > > interconnect for the ocp.
> > > > > > >
> > > > > > > Ugh... yeah, this is why the normal (not SYNC_STATE_ONLY) device link
> > > > > > > isn't being created.
> > > > > > >
> > > > > > > So the aggregated view is something like (I had to set tabs = 4 space
> > > > > > > to fit it within 80 cols):
> > > > > > >
> > > > > > >     ocp: ocp {         <========================= Consumer
> > > > > > >         compatible = "simple-pm-bus";
> > > > > > >         power-domains = <&prm_per>; <=========== Supplier ref
> > > > > > >
> > > > > > >                 l4_wkup: interconnect@44c00000 {
> > > > > > >             compatible = "ti,am33xx-l4-wkup", "simple-pm-bus";
> > > > > > >
> > > > > > >             segment@200000 {  /* 0x44e00000 */
> > > > > > >                 compatible = "simple-pm-bus";
> > > > > > >
> > > > > > >                 target-module@0 { /* 0x44e00000, ap 8 58.0 */
> > > > > > >                     compatible = "ti,sysc-omap4", "ti,sysc";
> > > > > > >
> > > > > > >                     prcm: prcm@0 {
> > > > > > >                         compatible = "ti,am3-prcm", "simple-bus";
> > > > > > >
> > > > > > >                         prm_per: prm@c00 { <========= Actual Supplier
> > > > > > >                             compatible = "ti,am3-prm-inst", "ti,omap-prm-inst";
> > > > > > >                         };
> > > > > > >                     };
> > > > > > >                 };
> > > > > > >             };
> > > > > > >         };
> > > > > > >     };
> > > > > > >
> > > > > > > The power-domain supplier is the great-great-great-grand-child of the
> > > > > > > consumer. It's not clear to me how this is valid. What does it even
> > > > > > > mean?
> > > > > > >
> > > > > > > Rob, is this considered a valid DT?
> > > > > >
> > > > > > Valid DT for broken h/w.
> > > > >
> > > > > I'm not sure even in that case it's valid. When the parent device is
> > > > > in reset (when the SoC is coming out of reset), there's no way the
> > > > > descendant is functional. And if the descendant is not functional, how
> > > > > is the parent device powered up? This just feels like an incorrect
> > > > > representation of the real h/w.
> > > >
> > > > It should be correct representation based on scanning the interconnects
> > > > and looking at the documentation. Some interconnect parts are wired
> > > > always-on and some interconnect instances may be dual-mapped.
> >
> > Thanks for helping to debug this. Appreciate it.
> >
> > > >
> > > > We have a quirk to probe prm/prcm first with pdata_quirks_init_clocks().
> >
> > :'(
> >
> > I checked out the code. These prm devices just get populated with NULL
> > as the parent. So they are effectively top level devices from the
> > perspective of driver core.
> >
> > > > Maybe that also now fails in addition to the top level interconnect
> > > > probing no longer producing -EPROBE_DEFER.
> >
> > As far as I can tell pdata_quirks_init_clocks() is just adding these
> > prm devices (amongst other drivers). So I don't expect that to fail.
> >
> > > >
> > > > > > So the domain must be default on and then simple-pm-bus is going to
> > > > > > hold a reference to the domain preventing it from ever getting powered
> > > > > > off and things seem to work. Except what happens during suspend?
> > > > >
> > > > > But how can simple-pm-bus even get a reference? The PM domain can't
> > > > > get added until we are well into the probe of the simple-pm-bus and
> > > > > AFAICT the genpd attach is done before the driver probe is even
> > > > > called.
> > > >
> > > > The prm/prcm gets of_platform_populate() called on it early.
> >
> > :'(
> >
> > > The hackish patch below makes things boot for me, not convinced this
> > > is the preferred fix compared to earlier deferred probe handling though.
> > > Going back to the init level tinkering seems like a step back to me.
> >
> > The goal of fw_devlink is to avoid init level tinkering and it does
> > help with that in general. But these kinds of quirks are going to need
> > a few exceptions -- with them being quirks and all. And this change
> > will avoid an unnecessary deferred probe (that used to happen even
> > before my change).
> >
> > The other option to handle this quirk is to create the invalid
> > (consumer is parent of supplier) fwnode_link between the prm device
> > and its consumers when the prm device is populated. Then fw_devlink
> > will end up creating a device link when ocp gets added. But I'm not
> > sure if it's going to be easy to find and add all those consumers.
> >
> > I'd say, for now, let's go with this patch below. I'll see if I can
> > get fw_devlink to handle these odd quirks without breaking the normal
> > cases or making them significantly slower. But that'll take some time
> > and I'm not sure there'll be a nice solution.
> 
> Can you check if this hack helps? If so, then I can think about
> whether we can pick it up without breaking everything else. Copy-paste
> tab mess up warning.

Yeah so manually applying your patch while updating it against
next-20220624 kernel boots for me. I ended up with the following
changes FYI.

Also, looks like both with the initcall change for prm, and the patch
below, there seems to be also another problem where my test devices no
longer properly idle somehow compared to reverting the your two patches
in next.

Regards,

Tony

8< -------------------
diff --git a/drivers/of/property.c b/drivers/of/property.c
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1138,18 +1138,6 @@ static int of_link_to_phandle(struct device_node *con_np,
 		return -ENODEV;
 	}
 
-	/*
-	 * Don't allow linking a device node as a consumer of one of its
-	 * descendant nodes. By definition, a child node can't be a functional
-	 * dependency for the parent node.
-	 */
-	if (of_is_ancestor_of(con_np, sup_np)) {
-		pr_debug("Not linking %pOFP to %pOFP - is descendant\n",
-			 con_np, sup_np);
-		of_node_put(sup_np);
-		return -EINVAL;
-	}
-
 	/*
 	 * Don't create links to "early devices" that won't have struct devices
 	 * created for them.
@@ -1163,9 +1151,27 @@ static int of_link_to_phandle(struct device_node *con_np,
 		of_node_put(sup_np);
 		return -ENODEV;
 	}
-	put_device(sup_dev);
+
+	/*
+	 * Don't allow linking a device node as a consumer of one of its
+	 * descendant nodes. By definition, a child node can't be a functional
+	 * dependency for the parent node.
+	 *
+	 * However, if the child node already has a device while the parent is
+	 * in the process of being added, it's probably some weird quirk
+	 * handling. So, don't both checking if the consumer is an ancestor of
+	 * the supplier.
+	 */
+	if (!sup_dev && of_is_ancestor_of(con_np, sup_np)) {
+		pr_debug("Not linking %pOFP to %pOFP - is descendant\n",
+			 con_np, sup_np);
+		put_device(sup_dev);
+		of_node_put(sup_np);
+		return -EINVAL;
+	}
 
 	fwnode_link_add(of_fwnode_handle(con_np), of_fwnode_handle(sup_np));
+	put_device(sup_dev);
 	of_node_put(sup_np);
 
 	return 0;
-- 
2.36.1
