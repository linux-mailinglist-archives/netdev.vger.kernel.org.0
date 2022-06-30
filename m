Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC425626A0
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 01:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiF3XLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 19:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiF3XLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 19:11:01 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D9658FF5
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:11:00 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ef5380669cso7819317b3.9
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 16:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S1BoFOa2LtA+D+cJfjxLFr8ByDI13+RV4RpERikla2g=;
        b=j6G/dJbFKHnQExUqH76mXhgqPp9ZcqVNcEQ+TkrRQCB4vbElxQSuQLezKQlQ7xN+VC
         CDDzmaQeHdxlOZOCBFq//logchR7RZDvSUc+pDl0prPBWCPWEX69BjWXjPSEp2UxoX7u
         wDKATzphl9/JUAB/pAgWFj7XeUNfrTbYLZHtGGbwPBqb4efbEEjdJtWBbMaCbpb1rcIp
         o6T1fs6ZC9OgDeTixalEeTj3kFaVH5X1sN++K92xWyut4jEM6I+OmHfvOw0Abh1REVAc
         VPf1701wcHq3wjBOr+BDHBnKRAl9ol09c0TNkhO+FRlji0Jcx3/ON8sPMqhei3siga1C
         tf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S1BoFOa2LtA+D+cJfjxLFr8ByDI13+RV4RpERikla2g=;
        b=WXjcywGShOjx/8wJhkyGoELw0SyoVtWKICPRjPb19LOpJiZ7TURz+JyDM4CxUTOSEo
         P5mGJxSuUUrbyxFYZWTF+VGfDT1HZU4DLhCS+UOQiM1FgR2+UbuiB/agIb0udc6kjm1w
         B18hJzwXCOoGhTi+b9Sx/EGTvMIr85T2r9cTS3J0jnmOLFOpspxw5KZEC/RQxKlCdzzI
         sZyQvW6uVNnn+z8lYhfM5kKiCFjsMXqelHGl8dQ2EE9u4XbdzwWWCZJonxS4LQtZ7ZiT
         2g0jswYzGJlT3VPnUY5DdWEn+TbezTr+plb6tBtAvhUiDUXVdhzyq6oz4MQ5qoh2fhXG
         c2Aw==
X-Gm-Message-State: AJIora9D+pntQlPblCcHY6qH24PNRCOHjeCx4m6XZ0QhLLnJHtHS31Am
        DZlUyhWYoo66sHiTB6E56hc04Gh8YsR8btex3Ndo9Q==
X-Google-Smtp-Source: AGRyM1u13ZqWwVRME+f0vAv8E2QASlU+p6PTsPGGdH/NEQ/jIY6Gn1dbdhukUneaQ15EmMWjJGOMoC+FKq768Lix/J4=
X-Received: by 2002:a81:a095:0:b0:317:d4ce:38b6 with SMTP id
 x143-20020a81a095000000b00317d4ce38b6mr13731218ywg.83.1656630659375; Thu, 30
 Jun 2022 16:10:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com> <YrFzK6EiVvXmzVG6@atomide.com>
 <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com> <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com> <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com>
In-Reply-To: <Yrlz/P6Un2fACG98@atomide.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Thu, 30 Jun 2022 16:10:23 -0700
Message-ID: <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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

On Mon, Jun 27, 2022 at 2:10 AM Tony Lindgren <tony@atomide.com> wrote:
>
> * Saravana Kannan <saravanak@google.com> [220623 08:17]:
> > On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
> > >
> > > * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > > > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > > > > This issue is no directly related fw_devlink. It is a side effect of
> > > > > removing driver_deferred_probe_check_state(). We no longer return
> > > > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> > > >
> > > > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > > > was deleted because fw_devlink=on should have short circuited the
> > > > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > > > probe function and hitting this -ENOENT failure. That's why I was
> > > > asking the other questions.
> > >
> > > OK. So where is the -EPROBE_DEFER supposed to happen without
> > > driver_deferred_probe_check_state() then?
> >
> > device_links_check_suppliers() call inside really_probe() would short
> > circuit and return an -EPROBE_DEFER if the device links are created as
> > expected.
>
> OK
>
> > > Hmm so I'm not seeing any supplier for the top level ocp device in
> > > the booting case without your patches. I see the suppliers for the
> > > ocp child device instances only.
> >
> > Hmmm... this is strange (that the device link isn't there), but this
> > is what I suspected.
>
> Yup, maybe it's because of the supplier being a device in the child
> interconnect for the ocp.

Ugh... yeah, this is why the normal (not SYNC_STATE_ONLY) device link
isn't being created.

So the aggregated view is something like (I had to set tabs = 4 space
to fit it within 80 cols):

    ocp: ocp {         <========================= Consumer
        compatible = "simple-pm-bus";
        power-domains = <&prm_per>; <=========== Supplier ref

                l4_wkup: interconnect@44c00000 {
            compatible = "ti,am33xx-l4-wkup", "simple-pm-bus";

            segment@200000 {  /* 0x44e00000 */
                compatible = "simple-pm-bus";

                target-module@0 { /* 0x44e00000, ap 8 58.0 */
                    compatible = "ti,sysc-omap4", "ti,sysc";

                    prcm: prcm@0 {
                        compatible = "ti,am3-prcm", "simple-bus";

                        prm_per: prm@c00 { <========= Actual Supplier
                            compatible = "ti,am3-prm-inst", "ti,omap-prm-inst";
                        };
                    };
                };
            };
        };
    };

The power-domain supplier is the great-great-great-grand-child of the
consumer. It's not clear to me how this is valid. What does it even
mean?

Rob, is this considered a valid DT?

Geert, thoughts on whether this is a correct use of simple-pm-bus device?

Also, how is the power domain attach/get working in this case? As far
as I can tell, at least for "simple-pm-bus" devices, the pm domain
attachment is happening under:
really_probe() -> call_driver_probe -> platform_probe() ->
dev_pm_domain_attach()

So, how is the pm domain attach succeeding in the first place without
my changes?

> > Now we need to figure out why it's missing. There are only a few
> > things that could cause this and I don't see any of those. I already
> > checked to make sure the power domain in this instance had a proper
> > driver with a probe() function -- if it didn't, then that's one thing
> > that'd could have caused the missing device link. The device does seem
> > to have a proper driver, so looks like I can rule that out.
> >
> > Can you point me to the dts file that corresponds to the specific
> > board you are testing this one? I probably won't find anything, but I
> > want to rule out some of the possibilities.
>
> You can use the beaglebone black dts for example, that's
> arch/arm/boot/dts/am335x-boneblack.dts and uses am33xx.dtsi for
> ocp interconnect with simple-pm-bus.
>
> > All the device link creation logic is inside drivers/base/core.c. So
> > if you can look at the existing messages or add other stuff to figure
> > out why the device link isn't getting created, that'd be handy. In
> > either case, I'll continue staring at the DT and code to see what
> > might be happening here.
>
> In device_links_check_suppliers() I see these ocp suppliers:
>
> platform ocp: device_links_check_suppliers: 1024: supplier 44e00d00.prm: link->status: 0 link->flags: 000001c0
> platform ocp: device_links_check_suppliers: 1024: supplier 44e01000.prm: link->status: 0 link->flags: 000001c0
> platform ocp: device_links_check_suppliers: 1024: supplier 44e00c00.prm: link->status: 0 link->flags: 000001c0
> platform ocp: device_links_check_suppliers: 1024: supplier 44e00e00.prm: link->status: 0 link->flags: 000001c0
> platform ocp: device_links_check_suppliers: 1024: supplier 44e01100.prm: link->status: 0 link->flags: 000001c0
> platform ocp: device_links_check_suppliers: 1024: supplier fixedregulator0: link->status: 1 link->flags: 000001c0
>
> No -EPROBE_DEFER is returned in device_links_check_suppliers() for
> 44e00c00.prm supplier for beaglebone black for example, 0 gets
> returned.

Yeah, the "1c0" flags are SYNC_STATE_ONLY device links and aren't
relevant to the issue we are seeing. Those links are being created as
a proxy for other descendant devices of ocp that haven't been added
yet, but are consumers of these *.prm devices. They are mainly meant
for correctness of sync_state() callbacks of the supplier and don't
affect probe order. For example: target-module@56000000 is a consumer
of prm_gfx 44e01100.prm.

-Saravana
