Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEB653D95D
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 05:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243650AbiFEDTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jun 2022 23:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243599AbiFEDTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jun 2022 23:19:07 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F74A479
        for <netdev@vger.kernel.org>; Sat,  4 Jun 2022 20:19:05 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id l204so20178882ybf.10
        for <netdev@vger.kernel.org>; Sat, 04 Jun 2022 20:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UfT4MT7hJVtHg40L/hP1ZN+BqXhrFP6Eg8QB85TqDmI=;
        b=i4t+Zbfv9mgXoHmCp9WTiqZCYX0GPYXzZmsD7L8UxzBPLZkybag0506qJXluqZw/9W
         8o266yL6KiXkLkyDgqNuLuhJo8T+pJg8OYLe27e7FK62LjwxkXtDSdOJhS0pc3IxzEK5
         3GD2dGw+8hVLPviz3mfNjR5XGZaOpWX4m78WG0B6uXq+MhadcayD4wPCAe+mCs0Zvy8S
         4EEQcXrvjcBI9t8m7eTvR3JmMquehZ3UV7MeQzmcQjE83SWx2Ppbi+Lsf1ZuzNYM2zqv
         qlnyYJUZ1wh9prgSQgcuZ9+WXsoJ3byzi+kzLzwt6CuS+LIitH8zkGQSOkK3pLyH86Er
         Eghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UfT4MT7hJVtHg40L/hP1ZN+BqXhrFP6Eg8QB85TqDmI=;
        b=5NNK6I7ziaq7wxm/RgtqRUxzRyVYZO37gW3cJFSq/eHRhj7bPM1zu3Tfopus1GCYtI
         99ogOoR7DEIHaFMEyQ9ZnKH8hhUVnmY2pUO82uFLeQdIxcW8abso2h7KQnEgpBEObW1a
         ODMSiqdWg3Ft73oGCR8qaow+rmpwkmtcPAYHxAW0kSVBm/0CnefuWK29PuIGr3+8dAM6
         GIeuOMm2lKcxibtuuERZD3s8DMScgNMF67VOROhXiVooWZ6IirXEAqXW/U0MEeu/TPiA
         QkvjPf+565A2dgF429WVQ19YOApYrZ/ScFVHQ/I7LKFMpmkritypiHllSheIcPDosZzc
         1guQ==
X-Gm-Message-State: AOAM5321+14b9ci6ZRrKVYV1IAcg7JSBkoGlhJFeFx5k4zrZruk783jR
        kP5AG6D/urvhcGMgwa/bjnHjZvQk+SS7OM0X5JeO7A==
X-Google-Smtp-Source: ABdhPJxrTqtLCQjIW3xp8nX5d6NuEspl0eOAd6/G2L9YHazcgkJ4hRf6Qyt8EmRCHMgQo+I/rvstQNfNmIYyfaK+Hd4=
X-Received: by 2002:a25:d803:0:b0:663:3da5:9813 with SMTP id
 p3-20020a25d803000000b006633da59813mr5189333ybg.530.1654399144708; Sat, 04
 Jun 2022 20:19:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com>
 <20220526081550.1089805-5-saravanak@google.com> <CAMuHMdXcHcuAn8UVS6RPsfenuCny4BgWNJFod41CFjdOF+w0sg@mail.gmail.com>
In-Reply-To: <CAMuHMdXcHcuAn8UVS6RPsfenuCny4BgWNJFod41CFjdOF+w0sg@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Sat, 4 Jun 2022 20:18:28 -0700
Message-ID: <CAGETcx_uXXw_OtHO+_2DmZnHA3WCT5CeKbb_RWNqZtZSU1OB2g@mail.gmail.com>
Subject: Re: [RFC PATCH v1 4/9] Revert "driver core: Set default
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

On Mon, May 30, 2022 at 2:13 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi Saravana,
>
> On Thu, May 26, 2022 at 10:16 AM Saravana Kannan <saravanak@google.com> wrote:
> > This reverts commit 11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61.
>
> scripts/chdeckpatch.pl says:
>
>     WARNING: Unknown commit id
> '11f7e7ef553b6b93ac1aa74a3c2011b9cc8aeb61', maybe rebased or not
> pulled?
>
> I assume this is your local copy of
> https://lore.kernel.org/r/20220526034609.480766-3-saravanak@google.com?

I somehow missed all your replies and noticed it just now.

That commit should be based on driver-core-next.

-Saravana

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
