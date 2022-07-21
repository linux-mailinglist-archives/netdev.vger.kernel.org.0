Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67E057C697
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232109AbiGUIkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiGUIkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:40:31 -0400
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3046D4E613;
        Thu, 21 Jul 2022 01:40:30 -0700 (PDT)
Received: by mail-qk1-f172.google.com with SMTP id c3so803655qko.1;
        Thu, 21 Jul 2022 01:40:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QvrjWjlD4kqRKdbG/mvxTTXUIQvY0KUhkxqPtqDf08Q=;
        b=dnMPv8cq360u9u2mQLFK4HnWY/DYulnmOIUzg8A0wAArgG+2KlEeL3VUO+CO1aQBbY
         8wHyc+SfD66k0h3CYBXvILhNcJad37x0d7TL2MXmZGyWnqvpsidVFJXEZqBEdGceX6Qt
         8A0oR79MLYArTAxhJNi+Jx4yV12QoxkS4iCVFnzas2wh5V7MNHXflQnF8oQ3nhuhtCzl
         fOeFn3WZwSGuQpqfUMopW+BriD3dGsdVtAN3BCS6v87FZixlqEkpoFU2y5aeHFxSydyE
         XF0aNLGJV5DC0FPZDXW1XI56gXC+L5feyRMrOPP3F9S6tKQLgEsO3xCdHalLChtfXvQs
         c9qw==
X-Gm-Message-State: AJIora87MKa973xb4YlQyrHrM3+VRP5dSJFGl7OvU6BEPNteIuIzp1zQ
        AC4kcx+hCQ1eDsR86YjgolNU2HP0kX4T8A==
X-Google-Smtp-Source: AGRyM1tzE830A27JcgiMXxx71diSLL3TO0ytrKJM+Y31H9nYkMu9nx1FPiH5goLGfEYAKKf3C+Z1NQ==
X-Received: by 2002:a05:620a:294e:b0:6a7:750b:abf8 with SMTP id n14-20020a05620a294e00b006a7750babf8mr26714409qkp.513.1658392829113;
        Thu, 21 Jul 2022 01:40:29 -0700 (PDT)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id d21-20020ac85ad5000000b0031ea1ad6c5asm965813qtd.75.2022.07.21.01.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 01:40:28 -0700 (PDT)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-31e67c46ba2so9924567b3.2;
        Thu, 21 Jul 2022 01:40:27 -0700 (PDT)
X-Received: by 2002:a81:84c1:0:b0:31e:4e05:e4f4 with SMTP id
 u184-20020a8184c1000000b0031e4e05e4f4mr15900153ywf.384.1658392826805; Thu, 21
 Jul 2022 01:40:26 -0700 (PDT)
MIME-Version: 1.0
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-7-saravanak@google.com> <CAMuHMdVVgB7KZq7-u-pAC-cZvVLWkv5wM4HC_jW7WK_tz52+cg@mail.gmail.com>
 <CAGETcx-5-241=CxaPsGTTHhCSAZuGb742J9Xrhbj56+2yG6OhQ@mail.gmail.com>
In-Reply-To: <CAGETcx-5-241=CxaPsGTTHhCSAZuGb742J9Xrhbj56+2yG6OhQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 21 Jul 2022 10:40:15 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXqRQdQe+34KORCAPxPc4sywZBZ6a=+yzS5k+kJVHjWhw@mail.gmail.com>
Message-ID: <CAMuHMdXqRQdQe+34KORCAPxPc4sywZBZ6a=+yzS5k+kJVHjWhw@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] Revert "driver core: Set default
 deferred_probe_timeout back to 0."
To:     Saravana Kannan <saravanak@google.com>
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
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Wed, Jul 20, 2022 at 9:02 PM Saravana Kannan <saravanak@google.com> wrote:
> On Wed, Jul 20, 2022 at 10:31 AM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Wed, Jun 1, 2022 at 9:45 AM Saravana Kannan <saravanak@google.com> wrote:
> > > This reverts commit 11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61.
> > >
> > > Let's take another shot at getting deferred_probe_timeout=10 to work.
> > >
> > > Signed-off-by: Saravana Kannan <saravanak@google.com>
> >
> > Thanks for your patch, which is now commit f516d01b9df2782b
> > ("Revert "driver core: Set default deferred_probe_timeout
> > back to 0."") in driver-core/driver-core-next.
> >
> > Wolfram found an issue on a Renesas board where disabling the IOMMU
> > driver (CONFIG_IPMMU_VMSA=n) causes the system to fail to boot,
> > and bisected this to a merge of driver-core/driver-core-next.
> > After some trials, I managed to reproduce the issue, and bisected it
> > further to commit f516d01b9df2782b.
> >
> > The affected config has:
> >     CONFIG_MODULES=y
> >     CONFIG_RCAR_DMAC=y
> >     CONFIG_IPMMU_VMSA=n
> >
> > In arch/arm64/boot/dts/renesas/r8a77951-salvator-xs.dtb,
> > e6e88000.serial links to a dmac, and the dmac links to an iommu,
> > for which no driver is available.
>
> Thanks for digging into this and giving more details.
>
> Is e6e88000.serial being blocked the reason for the boot failure?

It doesn't seem to be.

> If so, can you give this a shot?
> https://lore.kernel.org/lkml/20220701012647.2007122-1-saravanak@google.com/

Thanks, but it doesn't make a difference.

> > After bisecting configs, I found the culprit: CONFIG_IP_PNP.
> > As Wolfram was using an initramfs, CONFIG_IP_PNP was not needed.
> > If CONFIG_IP_PNP=n, booting fails.
> > If CONFIG_IP_PNP=y, booting succeeds.
> > In fact, just disabling late_initcall(ip_auto_config) makes it fail,
> > too.
> > Reducing ip_auto_config(), it turns out the call to
> > wait_for_init_devices_probe() is what is needed to unblock booting.
> >
> > So I guess wait_for_init_devices_probe() needs to be called (where?)
> > if CONFIG_IP_PNP=n, too?
>
> That function just unblocks all devices and allows them to try and
> probe and then waits for all possible probes to finish before
> returning. They problem with call it randomly/every time is that it
> breaks functionality where an optional supplier will probe after a few
> modules are loaded in the future.
>
> I guess one possible issue with the timeout not helping is that once
> the timeout expires, things are still being probed and nothing is
> being blocked till they finish probing.

I'm not sure that it's a device that's missing.

Calling wait_for_init_devices_probe() or not changes lots of little
things in the probing order. But when comparing the sorted boot logs,
there does not seem to be any difference in the list of devices that
was probed successfully.
It looks like the system is just blocked on something else?...

I tried getting a list of all locks held using Magic SysRq + d,
but Magic SysRq on the serial console does not work at this point
(it does work in the booted kernel with CONFIG_IP_PNP=y).


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
