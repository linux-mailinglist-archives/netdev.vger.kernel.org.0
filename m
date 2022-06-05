Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA7953D97F
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 05:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348504AbiFEDsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 23:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348471AbiFEDsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 23:48:07 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517481DA78
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 20:48:05 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-30fa61b1a83so110245057b3.0
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 20:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ui3IhTvHG08TEOp9AndOEANRcK2QqiFOkb8b6B7ZUYA=;
        b=AddFdKx/oipuNEWUN4TnsoDh8nTD0u8HK2RqT51wdoG72syLlKDo/zEd+agic/30/e
         WYwjcFvzl4oj/XNn32X2/ylGcuwnyf42X2JMcTlsu4msdOH1kNmwbgm+VHgtTGInga2u
         6DJ1gMG/QM0Ak6DMaGBVtrkOzjVwCw8FnMs90R09fO4rE1yynJFOYVQdfXtEPH5OgrQZ
         Us0JNbDV/U+tD8Pxr2CorRPyvzghTnvPjhAjLF4Ig47UDWxYO4wVa36ySy0c0R4mhP15
         pfJp4rBVPuYHyH3f1GIkogzfn19KI8lMguaiWf9WMI8YXYJKW3RRmrJWUHuYm5hnlGsM
         J3ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ui3IhTvHG08TEOp9AndOEANRcK2QqiFOkb8b6B7ZUYA=;
        b=hlVPiqaxZq30P4+NpZD9MOfY5op52oRXeMUd0SXIen0lQ8i+zWCWErcrXqlOC/cRnQ
         JFYzJikxAcZScj7VAJcYuFpSgoVCNq0uQ3kvlzGBitxm0wdtiONhY7jskLJnroiJxf2f
         e6Eg09RKH53YLLB+HGRTMT7QTK5BOB+Io1oX3Fw8AAxHizH9QYF4h082bZCrFi/Jv8Rg
         Ouu6a4esMlGQIE+PQeCk4hLzBvyr+dNHjq1h+meuKeIg+BScfd1ctGivpGfCadxE6sxb
         C5bjtXMQIdb9kSBLzW0q+GCVAfhmTxKyJd1X/qeV11ag1yI+0NXVtWYYm1zPQnbqgl3s
         VrrQ==
X-Gm-Message-State: AOAM533AtnfXNoU1+p0nmZ6Pmk2vu9xBEu3Tpg0VHJZKmEm0nqaqd4k7
        t0zwU6mmsPkTsrLiB3a5KOsFFLoiEbPmc3JHcPduDg==
X-Google-Smtp-Source: ABdhPJwfIUzHGUOY3GZySier5uLjJethOaftbfXihz53N9j35hn71WjRuf110V4OoTkXUC32BWfTpBzZA8XoLj95YRY=
X-Received: by 2002:a0d:c984:0:b0:30c:c95c:21d0 with SMTP id
 l126-20020a0dc984000000b0030cc95c21d0mr20276334ywd.218.1654400884335; Sat, 04
 Jun 2022 20:48:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com> <CAMuHMdW+Dmi9g=Cw9g5vOa9iYRA+L_ujU9C1-j0eKE7u3EmcFQ@mail.gmail.com>
In-Reply-To: <CAMuHMdW+Dmi9g=Cw9g5vOa9iYRA+L_ujU9C1-j0eKE7u3EmcFQ@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Sat, 4 Jun 2022 20:47:28 -0700
Message-ID: <CAGETcx_TGdeZWZOMyP8m+KvCWcPgH9ov1iryq4XGNjJ3kF+BNg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/9] deferred_probe_timeout logic clean up
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
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

On Mon, May 30, 2022 at 2:38 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Saravana,
>
> On Thu, May 26, 2022 at 10:15 AM Saravana Kannan <saravanak@google.com> wrote:
> > This series is based on linux-next + these 2 small patches applies on top:
> > https://lore.kernel.org/lkml/20220526034609.480766-1-saravanak@google.com/
> >
> > A lot of the deferred_probe_timeout logic is redundant with
> > fw_devlink=on.  Also, enabling deferred_probe_timeout by default breaks
> > a few cases.
> >
> > This series tries to delete the redundant logic, simplify the frameworks
> > that use driver_deferred_probe_check_state(), enable
> > deferred_probe_timeout=10 by default, and fixes the nfsroot failure
> > case.
> >
> > Patches 1 to 3 are fairly straightforward and can probably be applied
> > right away.
> >
> > Patches 4 to 9 are related and are the complicated bits of this series.
> >
> > Patch 8 is where someone with more knowledge of the IP auto config code
> > can help rewrite the patch to limit the scope of the workaround by
> > running the work around only if IP auto config fails the first time
> > around. But it's also something that can be optimized in the future
> > because it's already limited to the case where IP auto config is enabled
> > using the kernel commandline.
>
> Thanks for your series!
>
> > Yoshihiro/Geert,
> >
> > If you can test this patch series and confirm that the NFS root case
> > works, I'd really appreciate that.
>
> On Salvator-XS, Micrel KSZ9031 Gigabit PHY probe is no longer delayed
> by 9s after applying the two earlier patches, and the same is true
> after applying this series on top.
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> I will do testing on more boards, but that may take a while, as we're
> in the middle of the merge window.

Thanks for testing. I missed your email until now. I sent out a v2
series a few days back and that's a much better solution than v1. If
you can test that series instead, that'd be nice.

-Saravana
