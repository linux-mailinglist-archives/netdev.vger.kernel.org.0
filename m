Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C09631770
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 00:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiKTXvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 18:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKTXvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 18:51:07 -0500
X-Greylist: delayed 154 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 20 Nov 2022 15:51:05 PST
Received: from condef-10.nifty.com (condef-10.nifty.com [202.248.20.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84BB2228D
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 15:51:05 -0800 (PST)
Received: from conssluserg-06.nifty.com ([10.126.8.85])by condef-10.nifty.com with ESMTP id 2AKNk84r024688
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 08:46:08 +0900
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45]) (authenticated)
        by conssluserg-06.nifty.com with ESMTP id 2AKNjpZc023879;
        Mon, 21 Nov 2022 08:45:51 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 2AKNjpZc023879
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1668987952;
        bh=s9BTiD0GI6mriCXqjrvxYJ6QwNVJZpRs243VrvgUOs8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V2nZDRtla9IC+j9REytTTKsWS+MWZveXEfc9JkwXO6iWUTYb3XXw3Rb3YONzMHrYn
         xt7gPB7RpkWo76vO1L1byQmgggdDPp0Mv0A/Xc9Gb/dNlEicIrA9qdbZQdvghsvn3Z
         AorOLyT61nE5hY+d6LsyQgL3T8tp4kD8AkJEZaYnk2E2DjW42PGBCmF39HyDxJqKQy
         vFWTqhjTG+U9u+4UeRSbVFecHRM/SXAkBKMK+P7I5MQSaAZBKXWY9L4MPeHR7LLAcq
         BURdxxVISTvkgqox0RllxQyDFYXZpVCqgM5Q9HHrFk7ZrKRAf9K8HegVJJSaV2gS04
         Ncuh8LmUa7mrw==
X-Nifty-SrcIP: [209.85.160.45]
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-14263779059so11195196fac.1;
        Sun, 20 Nov 2022 15:45:51 -0800 (PST)
X-Gm-Message-State: ANoB5pnsxTkwEWK9xOGTMYZerkJ99tO25ZOJIrxqWny155XM7SCDRmFr
        z0Qs/ccoviMGK28HjWVhWLktfZrJMPwnU7A8eXo=
X-Google-Smtp-Source: AA0mqf6ByykYs2P1cELTWy1CDKXEPOUZKOc5edEnQWT685V2mFlLkrfF2ubF7Vp17JaN2YvW4BmTrQrfECsi24Gezaw=
X-Received: by 2002:a05:6870:3b06:b0:13b:5d72:d2c6 with SMTP id
 gh6-20020a0568703b0600b0013b5d72d2c6mr8759399oab.287.1668987950539; Sun, 20
 Nov 2022 15:45:50 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-12-alobakin@pm.me>
 <Y3oxyUx0UkWVjGvn@smile.fi.intel.com> <961a7d7e-c917-86a8-097b-5961428e9ddc@redhat.com>
In-Reply-To: <961a7d7e-c917-86a8-097b-5961428e9ddc@redhat.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Mon, 21 Nov 2022 08:45:14 +0900
X-Gmail-Original-Message-ID: <CAK7LNASxxzA1OEGuJR=BU=6G8XaatGx+gDCMe2s9Y3MRcwptYw@mail.gmail.com>
Message-ID: <CAK7LNASxxzA1OEGuJR=BU=6G8XaatGx+gDCMe2s9Y3MRcwptYw@mail.gmail.com>
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

On Mon, Nov 21, 2022 at 5:55 AM Hans de Goede <hdegoede@redhat.com> wrote:
>
> Hi,
>
> On 11/20/22 14:55, Andy Shevchenko wrote:
> > On Sat, Nov 19, 2022 at 11:08:17PM +0000, Alexander Lobakin wrote:
> >> common.o is linked to both intel_skl_int3472_{discrete,tps68470}:
> >>
> >>> scripts/Makefile.build:252: ./drivers/platform/x86/intel/int3472/Makefile:
> >>> common.o is added to multiple modules: intel_skl_int3472_discrete
> >>> intel_skl_int3472_tps68470
> >>
> >> Although both drivers share one Kconfig option
> >> (CONFIG_INTEL_SKL_INT3472), it's better to not link one object file
> >> into several modules (and/or vmlinux).
> >> Under certain circumstances, such can lead to the situation fixed by
> >> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> >>
> >> Introduce the new module, intel_skl_int3472_common, to provide the
> >> functions from common.o to both discrete and tps68470 drivers. This
> >> adds only 3 exports and doesn't provide any changes to the actual
> >> code.
>
> Replying to Andy's reply here since I never saw the original submission
> which was not Cc-ed to platform-driver-x86@vger.kernel.org .
>
> As you mention already in the commit msg, the issue from:
>
> commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects")
>
> is not an issue here since both modules sharing the .o file are
> behind the same Kconfig option.
>
> So there is not really an issue here and common.o is tiny, so
> small chances are it does not ever increase the .ko size
> when looking a the .ko size rounded up to a multiple of
> the filesystem size.
>
> At the same time adding an extra module does come with significant
> costs, it will eat up at least 1 possibly more then 1 fs blocks
> (I don't know what the module header size overhead is).
>
> And it needs to be loaded separately and module loading is slow;
> and it will grow the /lib/modules/<kver>/modules.* sizes.
>
> So nack from me for this patch, since I really don't see
> it adding any value.




This does have a value.

This clarifies the ownership of the common.o,
in other words, makes KBUILD_MODNAME deterministic.


If an object belongs to a module,
KBUILD_MODNAME is defined as the module name.

If an object is always built-in,
KBUILD_MODNAME is defined as the basename of the object.



Here is a question:
if common.o is shared by two modules intel_skl_int3472_discrete
and intel_skl_int3472_tps68470, what should KBUILD_MODNAME be?


I see some patch submissions relying on the assumption that
KBUILD_MODNAME is unique.
We cannot determine KBUILD_MODNAME correctly if an object is shared
by multiple modules.






BTW, this patch is not the way I suggested.
The Suggested-by should not have been there
(or at least Reported-by)


You argued "common.o is tiny", so I would vote for
making them inline functions, like


https://lore.kernel.org/linux-kbuild/20221119225650.1044591-2-alobakin@pm.me/T/#u








> Regards,
>
> Hans
>
>
>
>
>
> >
> > ...
> >
> >> +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> >> +
> >
> > Redundant blank line. You may put it to be last MODULE_*() in the file, if you
> > think it would be more visible.
> >
> >>  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Discrete Device Driver");
> >>  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
> >>  MODULE_LICENSE("GPL v2");
> >
> > ...
> >
> >> +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> >> +
> >>  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI TPS68470 Device Driver");
> >>  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
> >>  MODULE_LICENSE("GPL v2");
> >
> > Ditto. And the same to all your patches.
> >
>


-- 
Best Regards
Masahiro Yamada
