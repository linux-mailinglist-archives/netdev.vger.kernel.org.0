Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF195957E4
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiHPKRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:17:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234316AbiHPKLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:11:15 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8989E5F109;
        Tue, 16 Aug 2022 01:53:30 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id x5so7626257qtv.9;
        Tue, 16 Aug 2022 01:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=YnCIkno40KJuX3QeZtwItBffPailmAuhu9f01rahfzw=;
        b=U+Xv3VUkbFZ75ATgYioKHUob55py8E0A8kpBjpKS5iy//nEaZbMprXx3p85fUAHykX
         Y06ZTFC/cze5VAe4+1s6hPaXtQrCDPlSTKV4wFA4TPjUBR0tP3iFKTaAL6kt3XT/C3C2
         fBrk2d/kIYDlZg1SrUwqoRC/YchA5SWC/3bbm5dEGPzCcsCq2bQk0wJ8zypR3Ax343Kh
         gHaR95PbSmdDuRgWlEYUzButDm/lxQA7hAQGAHLvu1tas1c9iU1uKVaQpIwNliugV37P
         zm1X4DXj0RuZc5vRssIL/DGXzRr9qfxD4XTKfT/6oA9JQW1m3aCU9ryKEoQnazGQMM58
         BvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=YnCIkno40KJuX3QeZtwItBffPailmAuhu9f01rahfzw=;
        b=kqy1gqvhI7wtOysotJtohIvqmCUUiI+KbKeB85urvqczfN/GOkceXSVo9wD3/Bj6d1
         /tn9eBaXHoHiCa8xL7IHiHKl+QQDdVHzUPgKJFDo4aegc93nct6GlBGYZLeyaHlo469M
         /+b5rBWAfzsR5oyoXHcE4FclDWSy386Dzxc9ZzVMOZRDLCTUe88YPjvUMGem2cbkO6n9
         FYBsirB9Lz3v/vECUJM0J8bZb4NQVx7lYynMpLGMafevmdjfhej2NQIGmQNc8v69IqFg
         8ZnRfV0zCQsJxZR/+vCbPduTQtzZ07CXGWZsmZ6ShJmHFoLJy5Aw+z4LStl6pWiwHUp+
         QXKA==
X-Gm-Message-State: ACgBeo0VNtis+jDJU0Yr7qtnlqZ0T2ZTks2GgpniNmpVuZGzCy8dLkiG
        8WlZm+78fp6OyVcUTNM0LOsMVsbmbtuZI2RtfJg=
X-Google-Smtp-Source: AA6agR69jEnG5Q0HBokBpcx/vkcvs7eeRrblCm1xMMS1Xgn0nvLpVip0jrGSheJsUrCS6jhxsdmujrIhlAyv9RZF0VY=
X-Received: by 2002:ac8:5786:0:b0:343:3051:170d with SMTP id
 v6-20020ac85786000000b003433051170dmr17083982qta.429.1660640009425; Tue, 16
 Aug 2022 01:53:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
 <20220815005553.1450359-9-colin.foster@in-advantage.com> <YvpV4cvwE0IQOax7@euler>
 <YvpZoIN+5htY9Z1o@shredder>
In-Reply-To: <YvpZoIN+5htY9Z1o@shredder>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 16 Aug 2022 11:52:53 +0300
Message-ID: <CAHp75VeH_Gx4t+FSqH4LrTHNcwqGxDxRUF26kj3A=CopS=XkgQ@mail.gmail.com>
Subject: Re: [PATCH v16 mfd 8/8] mfd: ocelot: add support for the vsc7512 chip
 via spi
To:     Ido Schimmel <idosch@idosch.org>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <ukleinek@debian.org>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
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
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 5:35 PM Ido Schimmel <idosch@idosch.org> wrote:
>
> On Mon, Aug 15, 2022 at 07:19:13AM -0700, Colin Foster wrote:
> > Something is going on that I don't fully understand with <asm/byteorder.h>.
> > I don't quite see how ocelot-core is throwing all sorts of errors in x86
> > builds now:
> >
> > https://patchwork.hopto.org/static/nipa/667471/12942993/build_allmodconfig_warn/stderr
> >
> > Snippet from there:
> >
> > /home/nipa/nipa/tests/patch/build_32bit/build_32bit.sh: line 21: ccache gcc: command not found
> > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > ../arch/x86/include/asm/bitops.h:66:1: warning: unreplaced symbol 'return'
> > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> > ../include/asm-generic/bitops/generic-non-atomic.h:29:9: warning: unreplaced symbol 'mask'
> > ../include/asm-generic/bitops/generic-non-atomic.h:30:9: warning: unreplaced symbol 'p'
> > ../include/asm-generic/bitops/generic-non-atomic.h:32:10: warning: unreplaced symbol 'p'
> > ../include/asm-generic/bitops/generic-non-atomic.h:32:16: warning: unreplaced symbol 'mask'
> > ../include/asm-generic/bitops/generic-non-atomic.h:27:1: warning: unreplaced symbol 'return'
> > ../drivers/mfd/ocelot-spi.c: note: in included file (through ../arch/x86/include/asm/bitops.h, ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ...):
> > ../include/asm-generic/bitops/instrumented-non-atomic.h:26:1: warning: unreplaced symbol 'return'
> >
> >
> > <asm/byteorder.h> was included in both drivers/mfd/ocelot-spi.c and
> > drivers/mfd/ocelot.h previously, though Andy pointed out there didn't
> > seem to be any users... and I didn't either. I'm sure there's something
> > I must be missing.
>
> I got similar errors in our internal CI yesterday. Fixed by compiling
> sparse from git:
> https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=0e1aae55e49cad7ea43848af5b58ff0f57e7af99
>
> The update is also available in the "testing" repo in case you are
> running Fedora 35 / 36:
> https://bodhi.fedoraproject.org/updates/FEDORA-2022-c58b53730f
> https://bodhi.fedoraproject.org/updates/FEDORA-2022-2bc333ccac

Debian still produces the same errors which makes sparse useless.

-- 
With Best Regards,
Andy Shevchenko
