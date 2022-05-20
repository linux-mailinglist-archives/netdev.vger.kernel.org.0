Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4ED52E5AF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346233AbiETHCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346238AbiETHCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:02:22 -0400
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA0D6212B;
        Fri, 20 May 2022 00:02:19 -0700 (PDT)
Received: by mail-qt1-f171.google.com with SMTP id b9so161482qtx.11;
        Fri, 20 May 2022 00:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uBnYOzozPS0/gk3rG8TZQmfueqfKwe86yaRHQBbpuNM=;
        b=QOZFK5XdTPxyIxX28igOPjvbfFM1sXh1WPHrz6DWkcVKasAjCyvBF3S0RB8v4vRZyl
         QliavJ/C3iWgtmt35n7PBunpQelu2dwVilZ8fC52XuJ/RM1iXcnYJ3cCyyjR8gmJdyKK
         FKjCXQp+KtFqjzr189S4Q3kygoGQBPfmktmNy3kgjYJ6+dQrNX3J8rQ+CLPmUkCPHmHR
         oo9WyBlb4A4g9UaC0bC/hlCqZ/aT6dUBGcYz3SHFTDb3y3oLbAlTnHT9Z11kaOxvp3NZ
         2Z1CGkaJpgGAE8cDr6+X32QD/diW0t+Wqk3hlaMaIVYKcO4cZcI6YK+YtZaRi7XR0j5L
         mVpw==
X-Gm-Message-State: AOAM533hb2RQevCc/2FPAdo3F85m6qKCOjt2EBDB1vvozUBLciU/NLZK
        GgeFLIajG6N78RzJ/g5utPKuUXRBAPUqMw==
X-Google-Smtp-Source: ABdhPJxA1TF8DBGIXzFAp1HuqIe/vcBpkQAYbJoUgKOn6vwcaxx1V08YHqDKF1K+iEARoh7JpGWERQ==
X-Received: by 2002:a05:622a:138d:b0:2f3:b935:9d55 with SMTP id o13-20020a05622a138d00b002f3b9359d55mr6580978qtk.112.1653030138519;
        Fri, 20 May 2022 00:02:18 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id ey18-20020a05622a4c1200b002f3f24b6d12sm2400565qtb.29.2022.05.20.00.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 00:02:18 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id i187so10505637ybg.6;
        Fri, 20 May 2022 00:02:17 -0700 (PDT)
X-Received: by 2002:a25:e04d:0:b0:64d:6f23:b906 with SMTP id
 x74-20020a25e04d000000b0064d6f23b906mr8107235ybg.380.1653030137498; Fri, 20
 May 2022 00:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220513201243.2381133-1-vladimir.oltean@nxp.com>
 <CAGETcx9vjrh_ORhGq0g5oH5kUE8MbcyEW4Mv9i=S8m9PLzBkhA@mail.gmail.com>
 <20220519151529.qkhlsjfkh6mebpqw@skbuf> <CAGETcx_eiuKnyTgzxGBzgakV7reQOEdfpsvVjAsUXVmCSvSttQ@mail.gmail.com>
In-Reply-To: <CAGETcx_eiuKnyTgzxGBzgakV7reQOEdfpsvVjAsUXVmCSvSttQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 09:02:05 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUso+j5K8VYxTofg7Pw4jdH2xMMGBXGwBxpzRiQWX+ZNA@mail.gmail.com>
Message-ID: <CAMuHMdUso+j5K8VYxTofg7Pw4jdH2xMMGBXGwBxpzRiQWX+ZNA@mail.gmail.com>
Subject: Re: [RFC PATCH devicetree] of: property: mark "interrupts" as
 optional for fw_devlink
To:     Saravana Kannan <saravanak@google.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        =?UTF-8?B?QWx2aW4g4pS8w6FpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Android Kernel Team <kernel-team@android.com>
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

On Thu, May 19, 2022 at 10:00 PM Saravana Kannan <saravanak@google.com> wrote:
> There's still work to be done that might make this easier/cleaner in the future:
> 1. Adding a DT property that explicitly marks device A as not
> dependent on B (Rob was already open to this -- with additional
> context I don't want to type up here).
> 2. Adding kernel command line options that might allow people to say
> stuff like "Device A doesn't depend on Device B independent of what DT
> might say".

There are clearly cases where the hardware defines if the property
is optional or required, and a DT property would work.  However, in
general relaxing such dependencies involves a complex mix of hardware
capabilities, driver support, and system policies.
Examples:
  - A hardware block may support both DMA and PIO, or can require DMA,
  - DMA-capable devices can typically work without an IOMMU,
    unless all RAM lies outside the address space addressable by
    the DMA controller,
  - A driver may fall back to PIO if DMA is not available (yet),
    but doing so may not meet the required performance target,
  - Not using the IOMMU may violate anti-tampering policies.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
