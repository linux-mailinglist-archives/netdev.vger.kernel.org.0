Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812436880F5
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 16:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbjBBPDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 10:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjBBPDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 10:03:40 -0500
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1BE1715E;
        Thu,  2 Feb 2023 07:03:15 -0800 (PST)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-163bd802238so2805495fac.1;
        Thu, 02 Feb 2023 07:03:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yOafWoNIBGU3Q76qlhkVuk+ht5BzMZtDb+TwP4LrI+s=;
        b=7SxN6CsChFi5CsO8BdujQhNA/maxiN0bWxxXhoWdm5A6m7yQlMHyBtpBPTDKt5RtZB
         GxO3XulvBXey/LiZakCjF5UgHjDQL3MxMhzeCDJl2+qgCwVoUXiC/l6HGEpuocw8pSKL
         ZRL2mkLBjDBw5MVj+5xB4bjZW2GzsTRu7foHfGBz0pzYWJhxaRoGuLeHu0voWnA+IOow
         2NwgNOi6wVerN4nl8x5yKvPRiof1UBDPtFJ4dSoCRAi5TmWcD0o+UpKUMFuhqvXfWPsY
         yRs7U0IzCyr04h+BGAgpJTnjOxp9P79qOBMp8NW7GNvVDSartGam4huphLKdEseQ5JvL
         nq+g==
X-Gm-Message-State: AO0yUKUUt45JuYS2f4r/EmiRbsZ9QORZ5bxUVV0fcioOWI4HZPkB21hb
        n4PsE5d14T9TNJRYd+uYFbsA3kcnGuW50Q==
X-Google-Smtp-Source: AK7set/jqRpSpKwOVgmd0hRVvLflEu/ZJ53kNj+Z0g73c5pb0/FJd/Mx0loSgB+vzVz/aKrqVxiwDg==
X-Received: by 2002:a05:6870:d184:b0:163:88f7:d947 with SMTP id a4-20020a056870d18400b0016388f7d947mr3037186oac.43.1675350169477;
        Thu, 02 Feb 2023 07:02:49 -0800 (PST)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id o4-20020a05620a0d4400b006ea7f9d8644sm14344458qkl.96.2023.02.02.07.02.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 07:02:49 -0800 (PST)
Received: by mail-yb1-f172.google.com with SMTP id 74so2238008ybl.12;
        Thu, 02 Feb 2023 07:02:49 -0800 (PST)
X-Received: by 2002:a25:fc1c:0:b0:80b:8602:f3fe with SMTP id
 v28-20020a25fc1c000000b0080b8602f3femr916791ybd.36.1675349832295; Thu, 02 Feb
 2023 06:57:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674584626.git.geert+renesas@glider.be>
In-Reply-To: <cover.1674584626.git.geert+renesas@glider.be>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 2 Feb 2023 15:57:00 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWhY9OtW2Pa+LmY0qOvbxLiuyNYEQr5WnPgO1xD=5M1AQ@mail.gmail.com>
Message-ID: <CAMuHMdWhY9OtW2Pa+LmY0qOvbxLiuyNYEQr5WnPgO1xD=5M1AQ@mail.gmail.com>
Subject: Re: [PATCH treewide v2 0/9] phy: Add devm_of_phy_optional_get() helper
To:     Vinod Koul <vkoul@kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Rob Herring <robh@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-phy@lists.infradead.org, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinod,

On Tue, Jan 24, 2023 at 7:37 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> While there exist several optional_get() PHY helper functions, there is
> no optional variant of devm_of_phy_get(), leading to several drivers
> implementing this theirselves, sometimes in buggy ways.
>
> Hence this series, after two cleanup patches, introduces a
> devm_of_phy_optional_get() helper(), and converts existing users of
> devm_of_phy_get() where appropriate.
>
> Changes compared to v1[1]:
>   - Incorporate "[PATCH v2 1/9] phy: Remove unused phy_optional_get()",
>     as it touches the same documentation,
>   - New patch "[PATCH v2 2/9] doc: phy: Document devm_of_phy_get()",
>   - Print an error message in case of failure, as requested by RobH,
>   - Update Documentation,
>   - Clarify removed checks for -ENODEV and -ENOSYS,
>   - Remove error printing in case of real failures from callers,
>   - Rebase am65-cpsw change on top of commit 854617f52ab42418 ("net:
>     ethernet: ti: am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY") in
>     net-next (next-20230123 and later),
>   - Add Reviewed-by, Acked-by.
>
> Most of this series been compile-tested only, but the new helper itself
> has been tested with a new user[2].

Are you happy with this?  This series (at least patch 3) is a dependency
for [2], and in [3] you said you could apply it and create an immutable
branch.

Thanks!

> [1] "[PATCH treewide 0/7] phy: Add devm_of_phy_optional_get() helper"
>     https://lore.kernel.org/r/cover.1674036164.git.geert+renesas@glider.be
> [2] "[PATCH 12/12] can: rcar_canfd: Add transceiver support"
>     https://lore.kernel.org/r/e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be

[3] https://lore.kernel.org/all/Y8kmG+jB%2Fs7stebA@matsya

>
> Geert Uytterhoeven (9):
>   phy: Remove unused phy_optional_get()
>   doc: phy: Document devm_of_phy_get()
>   phy: Add devm_of_phy_optional_get() helper
>   net: fman: memac: Convert to devm_of_phy_optional_get()
>   net: lan966x: Convert to devm_of_phy_optional_get()
>   net: ethernet: ti: am65-cpsw: Convert to devm_of_phy_optional_get()
>   PCI: tegra: Convert to devm_of_phy_optional_get()
>   usb: host: ehci-exynos: Convert to devm_of_phy_optional_get()
>   usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
