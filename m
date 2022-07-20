Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E14B57BE37
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 21:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbiGTTCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 15:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiGTTCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 15:02:09 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AA473933
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 12:02:07 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id f73so33448705yba.10
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 12:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZrLA67cwNZVETS1ZHuCD/RT+6Ux5ZfCBf4rowrb0zk0=;
        b=YT3DmTiyfkNmNptMHmutH4aCptYOfYRcFG5iGz+vPj1xh91hftwgRZVbF/wRHhgFCW
         1yP86FQRWdyvxo3CPjgvnAYFhKYsg4xRdhZAvb8fEmhoefgT03SVJLFYubN1htgW4In8
         t6tNVr6ozTt06SPfaEt4t0hjTV1L36J3WR01kFU5ZNbxj6GCZ743km1XpjzuQHn+RR1i
         jytsYhkdsZViX0r1R/6noErQEJfi5bpHwxr3gD8SgyAPCv7vWZfI56uCK7HWM7r7/PFy
         SmvPNalQP0Ie215MNTJOK1vcSRgDWta0erJ4se7iwmpkVwf7aKNEFOMppZgPMGsnyAwV
         GblA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZrLA67cwNZVETS1ZHuCD/RT+6Ux5ZfCBf4rowrb0zk0=;
        b=JGCafxhF48SKj7FE8aiFBy/A1ZnZ0e8R3qlVq8lYlgynVv1p8SluA0OGQFDjSez7rL
         NUXgmGrr6TrVJfEVy9TJGyHfIXCDhDhzwoHxFBhkYZUnhFwLlzpN2QPlBKAvjlqPTpnx
         PJvbET8VHgEwNP/s4G/TNY6ajl2L6MxEI3ufy8ykp+YoIiQ/u4KKpAelWM3Ok2d81kJP
         Luu3ksgcpKZLAYRDqC29l6p8EqZ4M7GAFOLuINXmn/dTPZaaRn7ZnAeUs7YN5Nx3ct+x
         VgL/P3E6Zb3AsL2ba6PRBlzvzlsCeM/RG+rAJd1wHhTCU+EsWrod+i0n5hmFOWuQozHz
         WL/Q==
X-Gm-Message-State: AJIora9Lqthsw1DjEbhPr4UUfcX4kW+xmtWm084ExsK2t4h3gZosA/Nl
        Wjup3mif+aoXuBGGUvJkjJfcWHTNpqwzFo7NXFPJeQ==
X-Google-Smtp-Source: AGRyM1uk+awIxg+8Ie0mI4x1EeK/QSvobPmBqLZR8RQ7K+Gyc23VhWoJ9xFtopJENev37KrbfMD18GZF9BwnX6/O8DQ=
X-Received: by 2002:a25:aaa9:0:b0:66e:c6ba:15dd with SMTP id
 t38-20020a25aaa9000000b0066ec6ba15ddmr37815606ybi.242.1658343726294; Wed, 20
 Jul 2022 12:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-7-saravanak@google.com> <CAMuHMdVVgB7KZq7-u-pAC-cZvVLWkv5wM4HC_jW7WK_tz52+cg@mail.gmail.com>
In-Reply-To: <CAMuHMdVVgB7KZq7-u-pAC-cZvVLWkv5wM4HC_jW7WK_tz52+cg@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Wed, 20 Jul 2022 12:01:30 -0700
Message-ID: <CAGETcx-5-241=CxaPsGTTHhCSAZuGb742J9Xrhbj56+2yG6OhQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] Revert "driver core: Set default
 deferred_probe_timeout back to 0."
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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
        David Ahern <dsahern@kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 10:31 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Saravana,
>
> On Wed, Jun 1, 2022 at 9:45 AM Saravana Kannan <saravanak@google.com> wrote:
> > This reverts commit 11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61.
> >
> > Let's take another shot at getting deferred_probe_timeout=10 to work.
> >
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
>
> Thanks for your patch, which is now commit f516d01b9df2782b
> ("Revert "driver core: Set default deferred_probe_timeout
> back to 0."") in driver-core/driver-core-next.
>
> Wolfram found an issue on a Renesas board where disabling the IOMMU
> driver (CONFIG_IPMMU_VMSA=n) causes the system to fail to boot,
> and bisected this to a merge of driver-core/driver-core-next.
> After some trials, I managed to reproduce the issue, and bisected it
> further to commit f516d01b9df2782b.
>
> The affected config has:
>     CONFIG_MODULES=y
>     CONFIG_RCAR_DMAC=y
>     CONFIG_IPMMU_VMSA=n
>
> In arch/arm64/boot/dts/renesas/r8a77951-salvator-xs.dtb,
> e6e88000.serial links to a dmac, and the dmac links to an iommu,
> for which no driver is available.

Thanks for digging into this and giving more details.

Is e6e88000.serial being blocked the reason for the boot failure?

If so, can you give this a shot?
https://lore.kernel.org/lkml/20220701012647.2007122-1-saravanak@google.com/

> Playing with deferred_probe_timeout values doesn't help.

This part is strange though. If you set deferred_probe_timeout=1,
fw_devlink will stop blocking all probes 1 second after
late_initcall()s finish. So, similar to the ip autoconfig issue, is
the issue caused by something that needs to be finished before we hit
late_initcall() but is getting blocked?

> However, the above options do not seem to be sufficient to trigger
> the issue, as I had other configs with those three options that do
> boot fine.
>
> After bisecting configs, I found the culprit: CONFIG_IP_PNP.
> As Wolfram was using an initramfs, CONFIG_IP_PNP was not needed.
> If CONFIG_IP_PNP=n, booting fails.
> If CONFIG_IP_PNP=y, booting succeeds.
> In fact, just disabling late_initcall(ip_auto_config) makes it fail,
> too.
> Reducing ip_auto_config(), it turns out the call to
> wait_for_init_devices_probe() is what is needed to unblock booting.
>
> So I guess wait_for_init_devices_probe() needs to be called (where?)
> if CONFIG_IP_PNP=n, too?

That function just unblocks all devices and allows them to try and
probe and then waits for all possible probes to finish before
returning. They problem with call it randomly/every time is that it
breaks functionality where an optional supplier will probe after a few
modules are loaded in the future.

I guess one possible issue with the timeout not helping is that once
the timeout expires, things are still being probed and nothing is
being blocked till they finish probing.

I'm trying to have the default config (in terms of fw_devlink,
deferred probe behavior, timeouts, etc) be the same between a fully
static kernel (but CONFIG_MODULES still enabled) and a fully modular
kernel (like GKI). But it might end up being an untenable problem.

I'll wait to see what specifically is the issue in this case and then
I'll go from there.

-Saravana

> > --- a/drivers/base/dd.c
> > +++ b/drivers/base/dd.c
> > @@ -256,7 +256,12 @@ static int deferred_devs_show(struct seq_file *s, void *data)
> >  }
> >  DEFINE_SHOW_ATTRIBUTE(deferred_devs);
> >
> > +#ifdef CONFIG_MODULES
> > +int driver_deferred_probe_timeout = 10;
> > +#else
> >  int driver_deferred_probe_timeout;
> > +#endif
> > +
> >  EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
> >
> >  static int __init deferred_probe_timeout_setup(char *str)
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
>
