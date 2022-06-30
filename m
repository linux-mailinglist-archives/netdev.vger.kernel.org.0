Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009B5562707
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 01:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiF3X0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 19:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiF3X0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 19:26:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218D94476D;
        Thu, 30 Jun 2022 16:26:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE784B82D3D;
        Thu, 30 Jun 2022 23:26:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91681C341DA;
        Thu, 30 Jun 2022 23:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656631595;
        bh=ocxWtABVoequW5YNJWHtxjCAN6pvUTRglOmXliA+RpI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Qi98AIkpiogBRU1SIQ0tRIDCbTH3aUhLmIwceSXkScDwXJRgoZSsHLUvO4xn/Aaco
         jUeeJ1bfKaPPoD5NhRVnYvDv7ZJXteCeyyAcTVk2eHussC2U0xAsQizgRBBb0q143b
         FegjCvwcXeJGM0D9K4OwnWTFftyuJNqy/fsRt4PTeKXuJzs2BuvZWQf47mcHBJ2zFS
         QiVBk+IwIKPPurNp4TBJXnbB2mxb/ZoerePEqqTYli4zzKaVWaF/7nbwI+VJW9Rn0M
         rjJI0pOTvoDA8U1DSfb8VACgJqhFmYGFBJhUpERO6ZqZ0i2uiu9/r5+1gdHldP6Y7H
         ugsbpRRMOTwdQ==
Received: by mail-ua1-f49.google.com with SMTP id l7so242492ual.9;
        Thu, 30 Jun 2022 16:26:35 -0700 (PDT)
X-Gm-Message-State: AJIora/ff47zuqJIg9g5I/iw+cAn4HD1zgN6N1goCfyDEo1vU6k982DW
        TG+3LJD4XguuAcgLL0Z71mDMCAsyg8wDV6xX1w==
X-Google-Smtp-Source: AGRyM1uzRDE+5OSb/zj34pnreLyYTDG7fKIijDdSX9upnNZPRoBKS78Ucyprll5y2N89WsffxoVjZnek2U5JH0kmp0E=
X-Received: by 2002:ab0:244f:0:b0:37f:2985:e620 with SMTP id
 g15-20020ab0244f000000b0037f2985e620mr6853095uan.36.1656631594258; Thu, 30
 Jun 2022 16:26:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com> <YrFzK6EiVvXmzVG6@atomide.com>
 <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com> <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com> <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com> <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
In-Reply-To: <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 30 Jun 2022 17:26:22 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
Message-ID: <CAL_JsqJd3J6k6pRar7CkHVaaPbY7jqvzAePd8rVDisRV-dLLtg@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Saravana Kannan <saravanak@google.com>
Cc:     Tony Lindgren <tony@atomide.com>,
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
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 5:11 PM Saravana Kannan <saravanak@google.com> wrote:
>
> On Mon, Jun 27, 2022 at 2:10 AM Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Saravana Kannan <saravanak@google.com> [220623 08:17]:
> > > On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
> > > >
> > > > * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > > > > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > > > > > This issue is no directly related fw_devlink. It is a side effect of
> > > > > > removing driver_deferred_probe_check_state(). We no longer return
> > > > > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> > > > >
> > > > > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > > > > was deleted because fw_devlink=on should have short circuited the
> > > > > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > > > > probe function and hitting this -ENOENT failure. That's why I was
> > > > > asking the other questions.
> > > >
> > > > OK. So where is the -EPROBE_DEFER supposed to happen without
> > > > driver_deferred_probe_check_state() then?
> > >
> > > device_links_check_suppliers() call inside really_probe() would short
> > > circuit and return an -EPROBE_DEFER if the device links are created as
> > > expected.
> >
> > OK
> >
> > > > Hmm so I'm not seeing any supplier for the top level ocp device in
> > > > the booting case without your patches. I see the suppliers for the
> > > > ocp child device instances only.
> > >
> > > Hmmm... this is strange (that the device link isn't there), but this
> > > is what I suspected.
> >
> > Yup, maybe it's because of the supplier being a device in the child
> > interconnect for the ocp.
>
> Ugh... yeah, this is why the normal (not SYNC_STATE_ONLY) device link
> isn't being created.
>
> So the aggregated view is something like (I had to set tabs = 4 space
> to fit it within 80 cols):
>
>     ocp: ocp {         <========================= Consumer
>         compatible = "simple-pm-bus";
>         power-domains = <&prm_per>; <=========== Supplier ref
>
>                 l4_wkup: interconnect@44c00000 {
>             compatible = "ti,am33xx-l4-wkup", "simple-pm-bus";
>
>             segment@200000 {  /* 0x44e00000 */
>                 compatible = "simple-pm-bus";
>
>                 target-module@0 { /* 0x44e00000, ap 8 58.0 */
>                     compatible = "ti,sysc-omap4", "ti,sysc";
>
>                     prcm: prcm@0 {
>                         compatible = "ti,am3-prcm", "simple-bus";
>
>                         prm_per: prm@c00 { <========= Actual Supplier
>                             compatible = "ti,am3-prm-inst", "ti,omap-prm-inst";
>                         };
>                     };
>                 };
>             };
>         };
>     };
>
> The power-domain supplier is the great-great-great-grand-child of the
> consumer. It's not clear to me how this is valid. What does it even
> mean?
>
> Rob, is this considered a valid DT?

Valid DT for broken h/w.

So the domain must be default on and then simple-pm-bus is going to
hold a reference to the domain preventing it from ever getting powered
off and things seem to work. Except what happens during suspend?

Rob
