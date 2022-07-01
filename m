Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D478562D7E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 10:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbiGAILb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 04:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235408AbiGAIL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 04:11:29 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BB970ACF
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 01:11:26 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id q132so2709353ybg.10
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 01:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hHlkuZMmnoq/Fcx5WJPgqnbubzspv6b5yJUWnWtjBFU=;
        b=ef3c0Q9NjuflyQ+MqqXmFYsu6VqqoBDzl3Rn9YOZ6BtoUOKK35qOxdgC8QR/fTDybG
         VqqyO8E0kSnvEPQLWxHMS1kOy7d31CPndv9IcUcD1PZLZYa4nQ8pJrAPz/ENotu6Fg+T
         cv1U55Rkpgay9b5N9Cz/uaM1OcWmVrSoIxTsrnEXfFYEuj/E7nl1nLRX5Jmy3jh1toiX
         m6K3sNRCdCrEU4AMi4upx2V2xs8eSYC2ucM/rUpwcUaeacdhm6JFJPOXHzwhz9f44Iz2
         TiArY9oQLDmL0lT1Yba9o0E0/3CCha39GqTmMcxgRbms+W6WPbfZ6/kPtFAZ3gzJXLrq
         H1MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hHlkuZMmnoq/Fcx5WJPgqnbubzspv6b5yJUWnWtjBFU=;
        b=0l+6XaXgfiMAtq058OZvAP+xROD6qqONJ52uDS9wz0twXgb9AhU0bXHLbBxx15pGZY
         WUqmaKItx2rTIj8n4kJir3sV0xp0OEj8pK1BiUJwYLnuY2CgPV/9kONwqXSQv4eo+n4l
         XhNCEZWvrXtvWkiVCUo0V2giiRFIVgzK79VMQk8cXHxDRftY0TXW9iBjq3Hl0vMRSfwh
         fQkUU+OcpQp382Qhv+RnJG+7npE6yZDYbKfOZTTmRBbBe7EA92uWJ+UuY5FWzNFQIfcF
         jbr7D/uXPbnET6YIutqGkDI/xsqbDQeEG+VqeZCmuLWFz0v7R3/DthM7TLvJlq9OJGsZ
         PyPQ==
X-Gm-Message-State: AJIora9DYtiiUKiVACQG7TxBCqY1K0yW9d6Y+L66aW8eXkdnziB7NMzD
        Fpy29rBxBKY367Wag2VX3aPTwPx+vT+phFE4skVvBw==
X-Google-Smtp-Source: AGRyM1vDgmfSwZquyidL3tNXvh2BQFGuYMc3TLjl4/SGBSIpusjC3N4lyjRUlXNEzsK9FZ7zCyuWpHbcQKPzr3oaKYo=
X-Received: by 2002:a05:6902:1544:b0:66d:3948:deae with SMTP id
 r4-20020a056902154400b0066d3948deaemr14505784ybu.530.1656663085093; Fri, 01
 Jul 2022 01:11:25 -0700 (PDT)
MIME-Version: 1.0
References: <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com> <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com> <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com> <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
 <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
 <CAGETcx9ZmeTyP1sJCFZ9pBbMyXeifQFohFvWN3aBPx0sSOJ2VA@mail.gmail.com>
 <Yr6HQOtS4ctUYm9m@atomide.com> <Yr6QUzdoFWv/eAI6@atomide.com>
In-Reply-To: <Yr6QUzdoFWv/eAI6@atomide.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Fri, 1 Jul 2022 01:10:48 -0700
Message-ID: <CAGETcx-0bStPx8sF3BtcJFiu74NwiB0btTQ+xx_B=8B37TEb8w@mail.gmail.com>
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 11:12 PM Tony Lindgren <tony@atomide.com> wrote:
>
> * Tony Lindgren <tony@atomide.com> [220701 08:33]:
> > * Saravana Kannan <saravanak@google.com> [220630 23:25]:
> > > On Thu, Jun 30, 2022 at 4:26 PM Rob Herring <robh@kernel.org> wrote:
> > > >
> > > > On Thu, Jun 30, 2022 at 5:11 PM Saravana Kannan <saravanak@google.com> wrote:
> > > > >
> > > > > On Mon, Jun 27, 2022 at 2:10 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > > >
> > > > > > * Saravana Kannan <saravanak@google.com> [220623 08:17]:
> > > > > > > On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > >
> > > > > > > > * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > > > > > > > > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > > > > > This issue is no directly related fw_devlink. It is a side effect of
> > > > > > > > > > removing driver_deferred_probe_check_state(). We no longer return
> > > > > > > > > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> > > > > > > > >
> > > > > > > > > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > > > > > > > > was deleted because fw_devlink=on should have short circuited the
> > > > > > > > > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > > > > > > > > probe function and hitting this -ENOENT failure. That's why I was
> > > > > > > > > asking the other questions.
> > > > > > > >
> > > > > > > > OK. So where is the -EPROBE_DEFER supposed to happen without
> > > > > > > > driver_deferred_probe_check_state() then?
> > > > > > >
> > > > > > > device_links_check_suppliers() call inside really_probe() would short
> > > > > > > circuit and return an -EPROBE_DEFER if the device links are created as
> > > > > > > expected.
> > > > > >
> > > > > > OK
> > > > > >
> > > > > > > > Hmm so I'm not seeing any supplier for the top level ocp device in
> > > > > > > > the booting case without your patches. I see the suppliers for the
> > > > > > > > ocp child device instances only.
> > > > > > >
> > > > > > > Hmmm... this is strange (that the device link isn't there), but this
> > > > > > > is what I suspected.
> > > > > >
> > > > > > Yup, maybe it's because of the supplier being a device in the child
> > > > > > interconnect for the ocp.
> > > > >
> > > > > Ugh... yeah, this is why the normal (not SYNC_STATE_ONLY) device link
> > > > > isn't being created.
> > > > >
> > > > > So the aggregated view is something like (I had to set tabs = 4 space
> > > > > to fit it within 80 cols):
> > > > >
> > > > >     ocp: ocp {         <========================= Consumer
> > > > >         compatible = "simple-pm-bus";
> > > > >         power-domains = <&prm_per>; <=========== Supplier ref
> > > > >
> > > > >                 l4_wkup: interconnect@44c00000 {
> > > > >             compatible = "ti,am33xx-l4-wkup", "simple-pm-bus";
> > > > >
> > > > >             segment@200000 {  /* 0x44e00000 */
> > > > >                 compatible = "simple-pm-bus";
> > > > >
> > > > >                 target-module@0 { /* 0x44e00000, ap 8 58.0 */
> > > > >                     compatible = "ti,sysc-omap4", "ti,sysc";
> > > > >
> > > > >                     prcm: prcm@0 {
> > > > >                         compatible = "ti,am3-prcm", "simple-bus";
> > > > >
> > > > >                         prm_per: prm@c00 { <========= Actual Supplier
> > > > >                             compatible = "ti,am3-prm-inst", "ti,omap-prm-inst";
> > > > >                         };
> > > > >                     };
> > > > >                 };
> > > > >             };
> > > > >         };
> > > > >     };
> > > > >
> > > > > The power-domain supplier is the great-great-great-grand-child of the
> > > > > consumer. It's not clear to me how this is valid. What does it even
> > > > > mean?
> > > > >
> > > > > Rob, is this considered a valid DT?
> > > >
> > > > Valid DT for broken h/w.
> > >
> > > I'm not sure even in that case it's valid. When the parent device is
> > > in reset (when the SoC is coming out of reset), there's no way the
> > > descendant is functional. And if the descendant is not functional, how
> > > is the parent device powered up? This just feels like an incorrect
> > > representation of the real h/w.
> >
> > It should be correct representation based on scanning the interconnects
> > and looking at the documentation. Some interconnect parts are wired
> > always-on and some interconnect instances may be dual-mapped.

Thanks for helping to debug this. Appreciate it.

> >
> > We have a quirk to probe prm/prcm first with pdata_quirks_init_clocks().

:'(

I checked out the code. These prm devices just get populated with NULL
as the parent. So they are effectively top level devices from the
perspective of driver core.

> > Maybe that also now fails in addition to the top level interconnect
> > probing no longer producing -EPROBE_DEFER.

As far as I can tell pdata_quirks_init_clocks() is just adding these
prm devices (amongst other drivers). So I don't expect that to fail.

> >
> > > > So the domain must be default on and then simple-pm-bus is going to
> > > > hold a reference to the domain preventing it from ever getting powered
> > > > off and things seem to work. Except what happens during suspend?
> > >
> > > But how can simple-pm-bus even get a reference? The PM domain can't
> > > get added until we are well into the probe of the simple-pm-bus and
> > > AFAICT the genpd attach is done before the driver probe is even
> > > called.
> >
> > The prm/prcm gets of_platform_populate() called on it early.

:'(

> The hackish patch below makes things boot for me, not convinced this
> is the preferred fix compared to earlier deferred probe handling though.
> Going back to the init level tinkering seems like a step back to me.

The goal of fw_devlink is to avoid init level tinkering and it does
help with that in general. But these kinds of quirks are going to need
a few exceptions -- with them being quirks and all. And this change
will avoid an unnecessary deferred probe (that used to happen even
before my change).

The other option to handle this quirk is to create the invalid
(consumer is parent of supplier) fwnode_link between the prm device
and its consumers when the prm device is populated. Then fw_devlink
will end up creating a device link when ocp gets added. But I'm not
sure if it's going to be easy to find and add all those consumers.

I'd say, for now, let's go with this patch below. I'll see if I can
get fw_devlink to handle these odd quirks without breaking the normal
cases or making them significantly slower. But that'll take some time
and I'm not sure there'll be a nice solution.

Thanks,
Saravana

> Regards,
>
> Tony
>
> 8< ----------------
> diff --git a/drivers/soc/ti/omap_prm.c b/drivers/soc/ti/omap_prm.c
> --- a/drivers/soc/ti/omap_prm.c
> +++ b/drivers/soc/ti/omap_prm.c
> @@ -991,4 +991,9 @@ static struct platform_driver omap_prm_driver = {
>                 .of_match_table = omap_prm_id_table,
>         },
>  };
> -builtin_platform_driver(omap_prm_driver);
> +
> +static int __init omap_prm_init(void)
> +{
> +        return platform_driver_register(&omap_prm_driver);
> +}
> +subsys_initcall(omap_prm_init);
> --
> 2.36.1
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
