Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09661537856
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiE3JNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbiE3JNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:13:04 -0400
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9C257997;
        Mon, 30 May 2022 02:13:02 -0700 (PDT)
Received: by mail-qk1-f174.google.com with SMTP id o68so3028366qkf.13;
        Mon, 30 May 2022 02:13:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CevRGTtrDTs4Z7bTQdrqHWG/lWL6b5bSowmXhMt2lks=;
        b=Gh4PquHJSV05mYTDDsQP76bO1MAnTJx2Q9AXD3F2RCz1bVegrYuXNOiIhFQlojjrVx
         tDEjXGYSmyf4pdw1Pt+nvRrIirBuv7w1poToOnVDELG912A4WH9QMQR3bz2lGDstnk0Y
         VDpozxLexcXXjQGVhojMsjMFhCiBwL+VgyDJdl6umZuYarIR3DvzPmgMR7eiVV+/ker9
         fsgxzZjD/Pe+busswmYjfbIH9KmpD8v6wFAwWNheiHLb9K2F0xH0ui9GApUMzggXBd7r
         6cPin+4B+28OjUkM0JJmMbgwp0D4xN57n6jKF/5V3wtqFr8gvg9aE8BKuDx2DZVII3kP
         3hTg==
X-Gm-Message-State: AOAM530snAlr3gqnuQ3dLiycErMHNldPfhMi5sRCQl7KxLpFB4RFO7In
        ix8JjftLJLGfM8IFvpbHEhbNuHuSi7a+eA==
X-Google-Smtp-Source: ABdhPJw8khA82V6rqgtUvHZvyJcvT+05F5uhWWJwKof6sBR4+S/NTAI6QUdQEI+v3gyW8647A61nVw==
X-Received: by 2002:a05:620a:440c:b0:6a0:4c1d:eeaa with SMTP id v12-20020a05620a440c00b006a04c1deeaamr35648311qkp.370.1653901981933;
        Mon, 30 May 2022 02:13:01 -0700 (PDT)
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com. [209.85.219.174])
        by smtp.gmail.com with ESMTPSA id 72-20020a370c4b000000b0069fc13ce1e1sm7639728qkm.18.2022.05.30.02.12.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 02:12:58 -0700 (PDT)
Received: by mail-yb1-f174.google.com with SMTP id r82so8100498ybc.13;
        Mon, 30 May 2022 02:12:57 -0700 (PDT)
X-Received: by 2002:a05:6902:905:b0:64a:2089:f487 with SMTP id
 bu5-20020a056902090500b0064a2089f487mr53259449ybb.202.1653901976605; Mon, 30
 May 2022 02:12:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com> <20220526081550.1089805-5-saravanak@google.com>
In-Reply-To: <20220526081550.1089805-5-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 30 May 2022 11:12:43 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXcHcuAn8UVS6RPsfenuCny4BgWNJFod41CFjdOF+w0sg@mail.gmail.com>
Message-ID: <CAMuHMdXcHcuAn8UVS6RPsfenuCny4BgWNJFod41CFjdOF+w0sg@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/9] Revert "driver core: Set default
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

On Thu, May 26, 2022 at 10:16 AM Saravana Kannan <saravanak@google.com> wrote:
> This reverts commit 11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61.

scripts/chdeckpatch.pl says:

    WARNING: Unknown commit id
'11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61', maybe rebased or not
pulled?

I assume this is your local copy of
https://lore.kernel.org/r/20220526034609.480766-3-saravanak@google.com?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
