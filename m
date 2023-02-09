Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D87D69052F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBIKm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjBIKmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:42:43 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4905FF8
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 02:42:30 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id n1so529570ybm.11
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 02:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1EVNZNpF/Er877/te7k/r7KimgWui6kPYTMbzlbMpHE=;
        b=NoRufYnWd3sLfMds3pddswGHnqjpzO29628T+k+Q97BW963D2fJT2hsh+eLfD4RQRH
         zdt1oPrfGIR6Ose1yZAl+8pQgeUH06VeoxND49uyRtLk5wZaK6P1vWkHUPfwzBs82HZR
         oz2k/BMEaFgmS29Yh5uwqHaYMz9Lhz6PDpDDMeI348cBYuVGYWvMWT7QO/+7wp9T5Vuw
         22Lz60wzbBdJCYBR+gQPrDMAhySTtLLftil07FrKSjq7YegvR0bKStX2X/FTg/1VqIdH
         Sge2BQn9ZdQJjuaYgcGGeAH8hZsKUPivgELlTQNAPWs8P8uYFiU7J3aJu1bicHqUtpvb
         002g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1EVNZNpF/Er877/te7k/r7KimgWui6kPYTMbzlbMpHE=;
        b=8FAgaE+6Op3A15yyDffVH6GPe3ZjDhSSLYOT8kyZmGdD9RHYenu7k9IaTl5SgUA77Y
         OQPiZk4Ay1E3Si1sbYJJv9C06ouqGvIfOV8AdhRULy87KyDAK34ojYDkI5Qk1bLRDLby
         yrtF0BRXbcVILvrsu41vLEo2Vy2B6ZKBEi3oQ9p97mf4eCpGB+XOr2835bJ8slHuLU3w
         /lszFAi63dNpkZp7Wc56daLADiaLFRXDx8pe5ZK2HZnK53RplXieWbQpa8Sfyv4RdVlf
         +lLiGQaA9rxjzEFio01GZ0afAS6gRZHVWcSR1YMcEj5BUph02v5+g9FIV2X1Ciy/O8Ry
         yP0Q==
X-Gm-Message-State: AO0yUKULIs1HOYe6E5Zoy2OtqrmNiLnSM5bSaxfzhP8i3JamF9xIigzs
        aC+cB9qHOWLiF0EgyImri9BtqXNzghwrAsDo0H1ySw==
X-Google-Smtp-Source: AK7set/4egQ6ymaaXnifQxB1VP1BF0zfzUZPRKdac18DBhBo3kRtxaBrvl/7jPL1oolTNNR8WQJzGyOCYU7Jrhx58mc=
X-Received: by 2002:a5b:1c4:0:b0:8c9:2650:4ece with SMTP id
 f4-20020a5b01c4000000b008c926504ecemr420798ybp.210.1675939349691; Thu, 09 Feb
 2023 02:42:29 -0800 (PST)
MIME-Version: 1.0
References: <20230208173343.37582-1-andriy.shevchenko@linux.intel.com> <20230208173343.37582-17-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230208173343.37582-17-andriy.shevchenko@linux.intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 Feb 2023 11:42:18 +0100
Message-ID: <CACRpkdY+u4uQAXLggL=Shf7_dES_HRRtew+9Cxuipxi3nHRRCA@mail.gmail.com>
Subject: Re: [PATCH v4 16/18] gpiolib: Deduplicate forward declarations in consumer.h
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Devarsh Thakkar <devarsht@ti.com>,
        Michael Walle <michael@walle.cc>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dipen Patel <dipenp@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Lee Jones <lee@kernel.org>, linux-gpio@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-m68k@lists.linux-m68k.org,
        linuxppc-dev@lists.ozlabs.org, linux-sh@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, linux-arch@vger.kernel.org,
        devicetree@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Jonathan Corbet <corbet@lwn.net>, Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Janusz Krzysztofik <jmkrzyszt@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>,
        Mun Yew Tham <mun.yew.tham@intel.com>,
        Keerthy <j-keerthy@ti.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alexander Aring <alex.aring@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Qiang Zhao <qiang.zhao@nxp.com>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 8, 2023 at 6:34 PM Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:

> The struct fwnode_handle pointer is used in both branches of ifdeffery,
> no need to have a copy of the same in each of them, just make it global.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
