Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A0B562CF0
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbiGAHqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235351AbiGAHqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:46:38 -0400
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024F953D33;
        Fri,  1 Jul 2022 00:46:38 -0700 (PDT)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-1048b8a38bbso2458235fac.12;
        Fri, 01 Jul 2022 00:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b36GzMWyZ+B5pJeIXpOWUar+t32MbUtjaNf9+EBzdK8=;
        b=EFgo6LmCmfM6xn+qg3fV66RwzyzYyhWQba5go3m41dbIlGNZC35+ksncDTF9KbmPPG
         CPVVb1OVJ2qpH6J0Y55TpaJQg+I6Mfdj8J18w0oE3U/oN/HmptkHwJzRbwP6RJu3tu+2
         QvIKYW/NLfb4xGYEifMN3qUxXgfEUH3yQLIHO874KhwJF/Oh979/rPSupFTLVBIYEn06
         07ilr3kFSzNEBx9z6ylPE2Z44WeuUoyAJaDkVM07JAq/MMM6G3cgcN0kmu1HcTCE4X3c
         D2qzXooU3w0cPRLZp2FHv856Z59kOnDvVaF8J1rTIadV6jexnFMdY1GweVRfNZru2qRw
         e9jw==
X-Gm-Message-State: AJIora82VNKtYFiddkpb/BQkGA5EaoSrSNrNTAIvauczxB6ky7EPEtKc
        jprgs/rFHDaXHtPRu49uVd8bptN1UZb0Rw==
X-Google-Smtp-Source: AGRyM1tN+6Dp5ZyGr8q+dgO4YnyL8m6TaU4VBlEvV7wo5FDU/pwVSu7lr6iiDwUPjdwbX7zq4BIzAA==
X-Received: by 2002:a05:6870:a115:b0:10b:b089:abb6 with SMTP id m21-20020a056870a11500b0010bb089abb6mr2376527oae.140.1656661596714;
        Fri, 01 Jul 2022 00:46:36 -0700 (PDT)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com. [209.85.210.52])
        by smtp.gmail.com with ESMTPSA id x35-20020a056870a7a300b00101c9597c6fsm14168830oao.28.2022.07.01.00.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Jul 2022 00:46:36 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id q18-20020a9d7c92000000b00616b27cda7cso1247948otn.9;
        Fri, 01 Jul 2022 00:46:36 -0700 (PDT)
X-Received: by 2002:a81:1c4b:0:b0:31c:5f22:6bd3 with SMTP id
 c72-20020a811c4b000000b0031c5f226bd3mr1406855ywc.47.1656661147084; Fri, 01
 Jul 2022 00:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com> <YrFzK6EiVvXmzVG6@atomide.com>
 <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com> <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com> <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
 <Yrlz/P6Un2fACG98@atomide.com> <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
In-Reply-To: <CAGETcx8c+P0r6ARmhv+ERaz9zAGBOVJQu3bSDXELBycEGfkYQw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 1 Jul 2022 09:38:55 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW78nybK8LH2cDpM_0TCF-==QojaW8rKjudUhfJWNO0jA@mail.gmail.com>
Message-ID: <CAMuHMdW78nybK8LH2cDpM_0TCF-==QojaW8rKjudUhfJWNO0jA@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of driver_deferred_probe_check_state()
To:     Saravana Kannan <saravanak@google.com>
Cc:     Tony Lindgren <tony@atomide.com>, Rob Herring <robh@kernel.org>,
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
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Fri, Jul 1, 2022 at 1:11 AM Saravana Kannan <saravanak@google.com> wrote:
> On Mon, Jun 27, 2022 at 2:10 AM Tony Lindgren <tony@atomide.com> wrote:
> > * Saravana Kannan <saravanak@google.com> [220623 08:17]:
> > > On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
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
>
> Geert, thoughts on whether this is a correct use of simple-pm-bus device?

Well, if the hardware is wired that way...

It's not that dissimilar from CPU cores, and interrupt and GPIO
controllers in power domains and clocked by controllable clocks:
you can cut the branch you're sitting on, and you have to be careful
when going to sleep, and make sure your wake-up sources are still
functional.

> Also, how is the power domain attach/get working in this case? As far
> as I can tell, at least for "simple-pm-bus" devices, the pm domain
> attachment is happening under:
> really_probe() -> call_driver_probe -> platform_probe() ->
> dev_pm_domain_attach()
>
> So, how is the pm domain attach succeeding in the first place without
> my changes?

That's a software thing ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
