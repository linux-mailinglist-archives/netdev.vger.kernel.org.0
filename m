Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B7F631C5E
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKUJHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiKUJHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:07:22 -0500
X-Greylist: delayed 33674 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Nov 2022 01:07:21 PST
Received: from conssluserg-04.nifty.com (conssluserg-04.nifty.com [210.131.2.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8E26DCF7;
        Mon, 21 Nov 2022 01:07:20 -0800 (PST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id 2AL96qJA015443;
        Mon, 21 Nov 2022 18:06:53 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com 2AL96qJA015443
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669021613;
        bh=7X6L8AAqOEY0/aQSZIAWdIdlY5cPDBedn82Z4qDbDj8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bnQuxmb5RXwPbs0ZUhMNOeDUNzwY/Zhp3ZOHah5mrJYICSCcNUgGwoPPHUg+BegtS
         J5pOR0SpnPPe0CMz2/5zaUv0EMjloyHCipCzvBpgWgP5oZYfVjposgLigRwcWb8oGH
         xeOb1/sGcD/hs/x7q+hmiHfCDuj6GRApfYKFGMmLqqY9DyJ5GZx0cs3+8G+kxyV1yR
         9mHIoaQAXnbD7ta3fVmQMGlWgic0DZ0vihX9O5QatbZekvvHcuOddmheF5BFtJR77J
         RwVI/6juTSl6HHmeT2AMWdHS0zmsqqca7hX2ruiTisv54Z2WAkOry2L6gcFQEBPaOT
         Fbfvz7BhBRCmQ==
X-Nifty-SrcIP: [209.85.167.171]
Received: by mail-oi1-f171.google.com with SMTP id v81so11911434oie.5;
        Mon, 21 Nov 2022 01:06:53 -0800 (PST)
X-Gm-Message-State: ANoB5pnsxr4EPOygI75y6gbxGkHkInPVXXh5B+WiciRX9Nqx8H3/d9UL
        Z7NVhLEHi+1MyNx1FRY1mE5e3TfqYcLe+Fw6mvc=
X-Google-Smtp-Source: AA0mqf4oPAKiL8xYOTZ6xdM9i5EZ8/eV9uwfHeFU3qXK3j1ph/tgydAxQdRN8Em2+5zt0pL3BK3LUpJUuqi8g1IvgKM=
X-Received: by 2002:a05:6808:3009:b0:354:94a6:a721 with SMTP id
 ay9-20020a056808300900b0035494a6a721mr11148779oib.194.1669021611960; Mon, 21
 Nov 2022 01:06:51 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-12-alobakin@pm.me>
 <Y3oxyUx0UkWVjGvn@smile.fi.intel.com> <961a7d7e-c917-86a8-097b-5961428e9ddc@redhat.com>
 <CAK7LNASxxzA1OEGuJR=BU=6G8XaatGx+gDCMe2s9Y3MRcwptYw@mail.gmail.com> <87852fc9-0757-7e58-35a2-90cccf970f5c@redhat.com>
In-Reply-To: <87852fc9-0757-7e58-35a2-90cccf970f5c@redhat.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 21 Nov 2022 18:06:15 +0900
X-Gmail-Original-Message-ID: <CAK7LNAROUV6Z6L6yn4WiigfPRJTGU4+j0ujLt6nsxVp9+aCUzw@mail.gmail.com>
Message-ID: <CAK7LNAROUV6Z6L6yn4WiigfPRJTGU4+j0ujLt6nsxVp9+aCUzw@mail.gmail.com>
Subject: Re: [PATCH 11/18] platform/x86: int3472: fix object shared between
 several modules
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-kbuild@vger.kernel.org, Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 5:12 PM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 11/21/22 00:45, Masahiro Yamada wrote:
> > On Mon, Nov 21, 2022 at 5:55 AM Hans de Goede <hdegoede@redhat.com> wrote:
> >>
> >> Hi,
> >>
> >> On 11/20/22 14:55, Andy Shevchenko wrote:
> >>> On Sat, Nov 19, 2022 at 11:08:17PM +0000, Alexander Lobakin wrote:
> >>>> common.o is linked to both intel_skl_int3472_{discrete,tps68470}:
> >>>>
> >>>>> scripts/Makefile.build:252: ./drivers/platform/x86/intel/int3472/Makefile:
> >>>>> common.o is added to multiple modules: intel_skl_int3472_discrete
> >>>>> intel_skl_int3472_tps68470
> >>>>
> >>>> Although both drivers share one Kconfig option
> >>>> (CONFIG_INTEL_SKL_INT3472), it's better to not link one object file
> >>>> into several modules (and/or vmlinux).
> >>>> Under certain circumstances, such can lead to the situation fixed by
> >>>> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> >>>>
> >>>> Introduce the new module, intel_skl_int3472_common, to provide the
> >>>> functions from common.o to both discrete and tps68470 drivers. This
> >>>> adds only 3 exports and doesn't provide any changes to the actual
> >>>> code.
> >>
> >> Replying to Andy's reply here since I never saw the original submission
> >> which was not Cc-ed to platform-driver-x86@vger.kernel.org .
> >>
> >> As you mention already in the commit msg, the issue from:
> >>
> >> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects")
> >>
> >> is not an issue here since both modules sharing the .o file are
> >> behind the same Kconfig option.
> >>
> >> So there is not really an issue here and common.o is tiny, so
> >> small chances are it does not ever increase the .ko size
> >> when looking a the .ko size rounded up to a multiple of
> >> the filesystem size.
> >>
> >> At the same time adding an extra module does come with significant
> >> costs, it will eat up at least 1 possibly more then 1 fs blocks
> >> (I don't know what the module header size overhead is).
> >>
> >> And it needs to be loaded separately and module loading is slow;
> >> and it will grow the /lib/modules/<kver>/modules.* sizes.
> >>
> >> So nack from me for this patch, since I really don't see
> >> it adding any value.
> >
> >
> >
> >
> > This does have a value.
> >
> > This clarifies the ownership of the common.o,
> > in other words, makes KBUILD_MODNAME deterministic.
> >
> >
> > If an object belongs to a module,
> > KBUILD_MODNAME is defined as the module name.
> >
> > If an object is always built-in,
> > KBUILD_MODNAME is defined as the basename of the object.
> >
> >
> >
> > Here is a question:
> > if common.o is shared by two modules intel_skl_int3472_discrete
> > and intel_skl_int3472_tps68470, what should KBUILD_MODNAME be?
> >
> >
> > I see some patch submissions relying on the assumption that
> > KBUILD_MODNAME is unique.
> > We cannot determine KBUILD_MODNAME correctly if an object is shared
> > by multiple modules.
> >
> >
> >
> >
> >
> >
> > BTW, this patch is not the way I suggested.
> > The Suggested-by should not have been there
> > (or at least Reported-by)
> >
> >
> > You argued "common.o is tiny", so I would vote for
> > making them inline functions, like
> >
> >
> > https://lore.kernel.org/linux-kbuild/20221119225650.1044591-2-alobakin@pm.me/T/#u
>
> Yes just moving the contents of common.c to static inline helpers in common.h
> would be much better.
>
> If someone creates such a patch, please do not forget to Cc
> platform-driver-x86@vger.kernel.org



I think this patch series should be split
and sent to each sub-system instead of kbuild.






> Regards,
>
> Hans
>
>
>
> >
> >
> >
> >
> >
> >
> >
> >
> >> Regards,
> >>
> >> Hans
> >>
> >>
> >>
> >>
> >>
> >>>
> >>> ...
> >>>
> >>>> +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> >>>> +
> >>>
> >>> Redundant blank line. You may put it to be last MODULE_*() in the file, if you
> >>> think it would be more visible.
> >>>
> >>>>  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Discrete Device Driver");
> >>>>  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
> >>>>  MODULE_LICENSE("GPL v2");
> >>>
> >>> ...
> >>>
> >>>> +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> >>>> +
> >>>>  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI TPS68470 Device Driver");
> >>>>  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
> >>>>  MODULE_LICENSE("GPL v2");
> >>>
> >>> Ditto. And the same to all your patches.
> >>>
> >>
> >
> >
>


-- 
Best Regards
Masahiro Yamada
