Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F30598C7E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244789AbiHRT0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235563AbiHRT0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:26:51 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D0F2C9905;
        Thu, 18 Aug 2022 12:26:49 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id m17so1906709qvv.7;
        Thu, 18 Aug 2022 12:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=r6+aTYTA/zueI0bAQItUeqIaw/WOZ7KUz8BHSDQM0JI=;
        b=hjwL3PfAx5l+73/if0RsMV8JhFOUWiPjWPZV7JfcpDyOgrwEO6qnLAVifYsZxmLpwr
         xuLwj6/N6XL6bEzOSIcF/I4YbqTUTLEuDQNGV/8ZG7UFO278WDexoCNusFKfhM9g5u+d
         HKll/nLrg9ghy7IfUgjwlBchlL6xa7Y2e4csL3pFRxpDh5/4lHkUDAf01qG4JHGhRBfA
         yXnHrxaM5QfJetD7o5wLoyb3YSDxT9MPLqxy2TE0TIzTZcXzbddfsY7h96IsK8zBD1TH
         KnDbRcMbQwCL1d+rCUcuf9Un2T707UkpcrVz/F3DuCTdYXIpMd92LQ0P30ekAtM3YiRs
         /Dpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=r6+aTYTA/zueI0bAQItUeqIaw/WOZ7KUz8BHSDQM0JI=;
        b=27vpg65oVV3HRaXcU3J6pWwulHlQBDWWVHmNwUgzDdC0sDl0SBJXFX4WJkKpit9N9G
         2G5APTnrN8Xp9Sqmp6+TBhGpWs2wNmMz+Ho82DGvMW4sYxuBpMN6s3ug+pkg702ZG69A
         /kfgRMdWcp34STIiX3aKVwcQBRRdCobczz1sE9zF60SvmQiWZcS+4S46BsOIshwvbGLF
         b3V4qcSnxW0WxKIrDin0XmfQpnzZwpRLsHmYauuDnNPqGdL8C+yeoyUBucH9zM88zhXA
         EWA98hMKPXPs5deMLay3/Lru9PtYwMY/brfEM6OplUQrY/eU4buywHA9lux1bVxAPPt6
         XjEg==
X-Gm-Message-State: ACgBeo3jRYebpRUoKME1+hR4SAh0eUMvC1LgwYACiGTjBhJNdFrS8lT3
        cC/FpHvlOVMDFOCCn8dIZFdAsvbz6vDQlwbS0s0=
X-Google-Smtp-Source: AA6agR5DMBBXzjaqWp8cgfGJPitXBFHEU7EeWcBg1/HXMSYInFYaE9lLuKy1As26wuoh4o5XkAWC52YKGahjjkK7BnY=
X-Received: by 2002:a05:6214:d07:b0:476:c32f:f4f4 with SMTP id
 7-20020a0562140d0700b00476c32ff4f4mr3856603qvh.11.1660850808609; Thu, 18 Aug
 2022 12:26:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
 <20220815005553.1450359-9-colin.foster@in-advantage.com> <YvpV4cvwE0IQOax7@euler>
 <YvpZoIN+5htY9Z1o@shredder> <CAHp75VeH_Gx4t+FSqH4LrTHNcwqGxDxRUF26kj3A=CopS=XkgQ@mail.gmail.com>
 <Yvu1qvslHI9HIqKh@colin-ia-desktop>
In-Reply-To: <Yvu1qvslHI9HIqKh@colin-ia-desktop>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 18 Aug 2022 22:26:12 +0300
Message-ID: <CAHp75VdvcwivSkGe-CF94ohn3VxFq-vtjMSXfM4Q2ZX2MXskZQ@mail.gmail.com>
Subject: Re: [PATCH v16 mfd 8/8] mfd: ocelot: add support for the vsc7512 chip
 via spi
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 6:20 PM Colin Foster
<colin.foster@in-advantage.com> wrote:
>
> On Tue, Aug 16, 2022 at 11:52:53AM +0300, Andy Shevchenko wrote:
> > On Mon, Aug 15, 2022 at 5:35 PM Ido Schimmel <idosch@idosch.org> wrote:
> > >
> > > On Mon, Aug 15, 2022 at 07:19:13AM -0700, Colin Foster wrote:
> > > > Something is going on that I don't fully understand with <asm/byteorder.h>.
> > > > I don't quite see how ocelot-core is throwing all sorts of errors in x86
> > > > builds now:
> > > >
> > > > https://patchwork.hopto.org/static/nipa/667471/12942993/build_allmodconfig_warn/stderr
> > > >
> > > > Snippet from there:
> > > >
> > > > /home/nipa/nipa/tests/patch/build_32bit/build_32bit.sh: line 21: ccache gcc: command not found
> > > > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > > > ../arch/x86/include/asm/bitops.h:66:1: warning: unreplaced symbol 'return'
> > > > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > > > ../include/asm-generic/bitops/generic-non-atomic.h:29:9: warning: unreplaced symbol 'mask'
> > > > ../include/asm-generic/bitops/generic-non-atomic.h:30:9: warning: unreplaced symbol 'p'
> > > > ../include/asm-generic/bitops/generic-non-atomic.h:32:10: warning: unreplaced symbol 'p'
> > > > ../include/asm-generic/bitops/generic-non-atomic.h:32:16: warning: unreplaced symbol 'mask'
> > > > ../include/asm-generic/bitops/generic-non-atomic.h:27:1: warning: unreplaced symbol 'return'
> > > > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../arch/x86/include/asm/bitops.h, ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ...):
> > > > ../include/asm-generic/bitops/instrumented-non-atomic.h:26:1: warning: unreplaced symbol 'return'
> > > >
> > > >
> > > > <asm/byteorder.h> was included in both drivers/mfd/ocelot-spi.c and
> > > > drivers/mfd/ocelot.h previously, though Andy pointed out there didn't
> > > > seem to be any users... and I didn't either. I'm sure there's something
> > > > I must be missing.
> > >
> > > I got similar errors in our internal CI yesterday. Fixed by compiling
> > > sparse from git:
> > > https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=0e1aae55e49cad7ea43848af5b58ff0f57e7af99
> > >
> > > The update is also available in the "testing" repo in case you are
> > > running Fedora 35 / 36:
> > > https://bodhi.fedoraproject.org/updates/FEDORA-2022-c58b53730f
> > > https://bodhi.fedoraproject.org/updates/FEDORA-2022-2bc333ccac
> >
> > Debian still produces the same errors which makes sparse useless.
>
> I haven't jumped into this one yet. But everything seems to be compiling
> and running in ARM.
>
> Do you think this is a false positive / unrelated to this patch? Or do
> you think this is a true error that I did wrong? I haven't been around
> for too many releases, so I'm not sure if this is common after an -rc1.

It's a sparse issue and Debian maintainer for sparse is not updating
it for some reasons...

-- 
With Best Regards,
Andy Shevchenko
