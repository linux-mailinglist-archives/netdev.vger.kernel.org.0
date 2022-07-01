Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C853B562E2B
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234647AbiGAI2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236907AbiGAI2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:28:03 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF35735B7
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 01:26:49 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-31bf3656517so16114967b3.12
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 01:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DFHQbeJx5jwdm59RTWIMoBtHZxmRicrNH3p04gGarLE=;
        b=AzTS8CSHgg24vVLWLAVAUKBTE2q2L1PVl7ppLTo3Zj86QBew7/SFn1zxxqsqLRAMVg
         GM4zHuwZkkAh0kJhkpSeJHqAnmR6/4yPzcJxJS/c5e1zkGtXFw6Wen6LjUa1YXAF1cMN
         mcqprTGQfkN1s6ue74YKMXGtIxXOTQBbdPBgM/o2A0OiokSErKLCj1DubDW0lscRUkkc
         eNGHuji8/eElVM4S5dNkZ0zCSKTlHAUbR05NKJtSPMoTXCLbd8zzSXASpMDq9OD4/7ZO
         4Iy1dRJNcEnugt0k5eO4jdqKIlTPV0d4hc1l4rz4ta7mLkpK4ad7qQisJOBbcXVWDk/Z
         KrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DFHQbeJx5jwdm59RTWIMoBtHZxmRicrNH3p04gGarLE=;
        b=iPlut9NPguj8VOo/7SS3IuGy3Awtj1hOsdVFl3Cp6Jm+dnKIBn9EGF7wQvr6ALp6Tk
         UVOW5VtJfXq1RuUIlWk4vsv5Migoh30Oj25vOlm24mhCOdiJe1RmGmi9UJsjnYl18j4W
         X+P9uS/spwK/X/O7eKz8KiC2O4p5cP3TBRePVcIzojCvyyvXENXhgJyOYHXwdSxRjT/m
         Dsb/zESzrUWHhKO2x7uqrx44o22JYImGDKyXyAPRVDLnz4HOMvnOsuuhkMYZh8jgdowQ
         sERBJDKOpIOK+QGBX8WBQPWoTGDziqq+r5/TnQVUYOBqwmIY5WFS+uqvs7i0MxRBcIOe
         GeTA==
X-Gm-Message-State: AJIora+fzBWX15xlPL/zwWPsf9Enbl2y3AHWnLETaJZeVmuYcUfSMDbk
        574cABZUna9P9R6oj42swZacdKK56hZjLVgeMuRwEQ==
X-Google-Smtp-Source: AGRyM1up3BnIZtVTno8CLly59mX1nlGCMK6yx7mZcwIJuREZEw964lzwOzB2OYTG2R1vIk9rd4N3GYoPzRQKhBjtmhA=
X-Received: by 2002:a81:7557:0:b0:317:6536:d404 with SMTP id
 q84-20020a817557000000b003176536d404mr15306258ywc.459.1656664008847; Fri, 01
 Jul 2022 01:26:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com> <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com> <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com> <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
 <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
 <CAGETcx9ZmeTyP1sJCFZ9pBbMyXeifQFohFvWN3aBPx0sSOJ2VA@mail.gmail.com>
 <Yr6HQOtS4ctUYm9m@atomide.com> <Yr6QUzdoFWv/eAI6@atomide.com> <CAGETcx-0bStPx8sF3BtcJFiu74NwiB0btTQ+xx_B=8B37TEb8w@mail.gmail.com>
In-Reply-To: <CAGETcx-0bStPx8sF3BtcJFiu74NwiB0btTQ+xx_B=8B37TEb8w@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 1 Jul 2022 01:26:12 -0700
Message-ID: <CAGETcx-Yp2JKgCNfaGD0SzZg9F2Xnu8A3zXmV5=WX1hY7uR=0g@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Tony Lindgren <tony@atomide.com>
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 1, 2022 at 1:10 AM Saravana Kannan <saravanak@google.com> wrote:
>
> On Thu, Jun 30, 2022 at 11:12 PM Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Tony Lindgren <tony@atomide.com> [220701 08:33]:
> > > * Saravana Kannan <saravanak@google.com> [220630 23:25]:
> > > > On Thu, Jun 30, 2022 at 4:26 PM Rob Herring <robh@kernel.org> wrote:
> > > > >
> > > > > On Thu, Jun 30, 2022 at 5:11 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > > >
> > > > > > On Mon, Jun 27, 2022 at 2:10 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > >
> > > > > > > * Saravana Kannan <saravanak@google.com> [220623 08:17]:
> > > > > > > > On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > > >
> > > > > > > > > * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > > > > > > > > > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > > > > > This issue is no directly related fw_devlink. It is a side effect of
> > > > > > > > > > > removing driver_deferred_probe_check_state(). We no longer return
> > > > > > > > > > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> > > > > > > > > >
> > > > > > > > > > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > > > > > > > > > was deleted because fw_devlink=on should have short circuited the
> > > > > > > > > > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > > > > > > > > > probe function and hitting this -ENOENT failure. That's why I was
> > > > > > > > > > asking the other questions.
> > > > > > > > >
> > > > > > > > > OK. So where is the -EPROBE_DEFER supposed to happen without
> > > > > > > > > driver_deferred_probe_check_state() then?
> > > > > > > >
> > > > > > > > device_links_check_suppliers() call inside really_probe() would short
> > > > > > > > circuit and return an -EPROBE_DEFER if the device links are created as
> > > > > > > > expected.
> > > > > > >
> > > > > > > OK
> > > > > > >
> > > > > > > > > Hmm so I'm not seeing any supplier for the top level ocp device in
> > > > > > > > > the booting case without your patches. I see the suppliers for the
> > > > > > > > > ocp child device instances only.
> > > > > > > >
> > > > > > > > Hmmm... this is strange (that the device link isn't there), but this
> > > > > > > > is what I suspected.
> > > > > > >
> > > > > > > Yup, maybe it's because of the supplier being a device in the child
> > > > > > > interconnect for the ocp.
> > > > > >
> > > > > > Ugh... yeah, this is why the normal (not SYNC_STATE_ONLY) device link
> > > > > > isn't being created.
> > > > > >
> > > > > > So the aggregated view is something like (I had to set tabs = 4 space
> > > > > > to fit it within 80 cols):
> > > > > >
> > > > > >     ocp: ocp {         <========================= Consumer
> > > > > >         compatible = "simple-pm-bus";
> > > > > >         power-domains = <&prm_per>; <=========== Supplier ref
> > > > > >
> > > > > >                 l4_wkup: interconnect@44c00000 {
> > > > > >             compatible = "ti,am33xx-l4-wkup", "simple-pm-bus";
> > > > > >
> > > > > >             segment@200000 {  /* 0x44e00000 */
> > > > > >                 compatible = "simple-pm-bus";
> > > > > >
> > > > > >                 target-module@0 { /* 0x44e00000, ap 8 58.0 */
> > > > > >                     compatible = "ti,sysc-omap4", "ti,sysc";
> > > > > >
> > > > > >                     prcm: prcm@0 {
> > > > > >                         compatible = "ti,am3-prcm", "simple-bus";
> > > > > >
> > > > > >                         prm_per: prm@c00 { <========= Actual Supplier
> > > > > >                             compatible = "ti,am3-prm-inst", "ti,omap-prm-inst";
> > > > > >                         };
> > > > > >                     };
> > > > > >                 };
> > > > > >             };
> > > > > >         };
> > > > > >     };
> > > > > >
> > > > > > The power-domain supplier is the great-great-great-grand-child of the
> > > > > > consumer. It's not clear to me how this is valid. What does it even
> > > > > > mean?
> > > > > >
> > > > > > Rob, is this considered a valid DT?
> > > > >
> > > > > Valid DT for broken h/w.
> > > >
> > > > I'm not sure even in that case it's valid. When the parent device is
> > > > in reset (when the SoC is coming out of reset), there's no way the
> > > > descendant is functional. And if the descendant is not functional, how
> > > > is the parent device powered up? This just feels like an incorrect
> > > > representation of the real h/w.
> > >
> > > It should be correct representation based on scanning the interconnects
> > > and looking at the documentation. Some interconnect parts are wired
> > > always-on and some interconnect instances may be dual-mapped.
>
> Thanks for helping to debug this. Appreciate it.
>
> > >
> > > We have a quirk to probe prm/prcm first with pdata_quirks_init_clocks().
>
> :'(
>
> I checked out the code. These prm devices just get populated with NULL
> as the parent. So they are effectively top level devices from the
> perspective of driver core.
>
> > > Maybe that also now fails in addition to the top level interconnect
> > > probing no longer producing -EPROBE_DEFER.
>
> As far as I can tell pdata_quirks_init_clocks() is just adding these
> prm devices (amongst other drivers). So I don't expect that to fail.
>
> > >
> > > > > So the domain must be default on and then simple-pm-bus is going to
> > > > > hold a reference to the domain preventing it from ever getting powered
> > > > > off and things seem to work. Except what happens during suspend?
> > > >
> > > > But how can simple-pm-bus even get a reference? The PM domain can't
> > > > get added until we are well into the probe of the simple-pm-bus and
> > > > AFAICT the genpd attach is done before the driver probe is even
> > > > called.
> > >
> > > The prm/prcm gets of_platform_populate() called on it early.
>
> :'(
>
> > The hackish patch below makes things boot for me, not convinced this
> > is the preferred fix compared to earlier deferred probe handling though.
> > Going back to the init level tinkering seems like a step back to me.
>
> The goal of fw_devlink is to avoid init level tinkering and it does
> help with that in general. But these kinds of quirks are going to need
> a few exceptions -- with them being quirks and all. And this change
> will avoid an unnecessary deferred probe (that used to happen even
> before my change).
>
> The other option to handle this quirk is to create the invalid
> (consumer is parent of supplier) fwnode_link between the prm device
> and its consumers when the prm device is populated. Then fw_devlink
> will end up creating a device link when ocp gets added. But I'm not
> sure if it's going to be easy to find and add all those consumers.
>
> I'd say, for now, let's go with this patch below. I'll see if I can
> get fw_devlink to handle these odd quirks without breaking the normal
> cases or making them significantly slower. But that'll take some time
> and I'm not sure there'll be a nice solution.

Can you check if this hack helps? If so, then I can think about
whether we can pick it up without breaking everything else. Copy-paste
tab mess up warning.

-Saravana

8< ----------------

diff --git a/drivers/of/property.c b/drivers/of/property.c
index 967f79b59016..f671a7528719 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -1138,18 +1138,6 @@ static int of_link_to_phandle(struct device_node *con_np,
                return -ENODEV;
        }

-       /*
-        * Don't allow linking a device node as a consumer of one of its
-        * descendant nodes. By definition, a child node can't be a functional
-        * dependency for the parent node.
-        */
-       if (of_is_ancestor_of(con_np, sup_np)) {
-               pr_debug("Not linking %pOFP to %pOFP - is descendant\n",
-                        con_np, sup_np);
-               of_node_put(sup_np);
-               return -EINVAL;
-       }
-
        /*
         * Don't create links to "early devices" that won't have struct devices
         * created for them.
@@ -1163,6 +1151,25 @@ static int of_link_to_phandle(struct device_node *con_np,
                of_node_put(sup_np);
                return -ENODEV;
        }
+
+       /*
+        * Don't allow linking a device node as a consumer of one of its
+        * descendant nodes. By definition, a child node can't be a functional
+        * dependency for the parent node.
+        *
+        * However, if the child node already has a device while the parent is
+        * in the process of being added, it's probably some weird quirk
+        * handling. So, don't both checking if the consumer is an ancestor of
+        * the supplier.
+        */
+       if (!sup_dev && of_is_ancestor_of(con_np, sup_np)) {
+               pr_debug("Not linking %pOFP to %pOFP - is descendant\n",
+                        con_np, sup_np);
+               put_device(sup_dev);
+               of_node_put(sup_np);
+               return -EINVAL;
+       }
+
