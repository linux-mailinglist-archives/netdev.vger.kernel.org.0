Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 948AC6724EE
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 18:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230240AbjARRaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 12:30:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjARRaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 12:30:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59334B48A;
        Wed, 18 Jan 2023 09:30:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91137B81E10;
        Wed, 18 Jan 2023 17:30:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338BAC433A4;
        Wed, 18 Jan 2023 17:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674063001;
        bh=LJBBjaAlYSvJUenRlMga+U5BeXpvxpPKZDlIdLU45BM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hmf7+UL3leNPuzaxevidcCvupd2U7btIwH65IYNeVK7+1tInAv0y6fqv1vgPkzep7
         DyRue47yqkzKNVh0krE4rlL1/CHgs3zHDmDmimMHjaZDt33MsbXp1Hfu05ucqSSE+a
         CbDfENE2O3Fsh3QvctXD57v+Uctul0fERTTCuITLF4u2+kr3YJ746l1vQZa3cHPGSI
         F+2psrUUlGAgm4I9P0vps036wG9js74HMbiDXteMc0Li3hPAnx7wCQjY+/b1KCIifu
         mJxQ0xxn2v1XNmVHViwADBw/l7fyyG9erBtL+43vPEph8mMeigFsVQlHt47qPdCoS9
         PVISFo1zgYvRA==
Received: by mail-vs1-f51.google.com with SMTP id i185so36512278vsc.6;
        Wed, 18 Jan 2023 09:30:01 -0800 (PST)
X-Gm-Message-State: AFqh2kojPi1Ak0AqksCOmq/fH08kJOzZI38LRlC7OwdtGv1hBz2tzlA1
        SEB6iih48dEEIsi9ASvpVrGzn5NEflpt0OHWUw==
X-Google-Smtp-Source: AMrXdXvA04SHBWGhGf3XXxnkZl7P9uuv143vKfDpn1n+lFrctNTF4MekqF065Hz/TnnvGNkDVJvaFJeZyLyDD//XymY=
X-Received: by 2002:a67:eb86:0:b0:3b1:4b76:5b44 with SMTP id
 e6-20020a67eb86000000b003b14b765b44mr1025285vso.53.1674062999762; Wed, 18 Jan
 2023 09:29:59 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674036164.git.geert+renesas@glider.be> <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
In-Reply-To: <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 18 Jan 2023 11:29:48 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJS2JTZ1BxMbG_2zgzu5xtxMFPqjxc_vUjuZp3k1xUmaQ@mail.gmail.com>
Message-ID: <CAL_JsqJS2JTZ1BxMbG_2zgzu5xtxMFPqjxc_vUjuZp3k1xUmaQ@mail.gmail.com>
Subject: Re: [PATCH 7/7] usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Siddharth Vadapalli <s-vadapalli@ti.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 4:15 AM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
> Use the new devm_of_phy_optional_get() helper instead of open-coding the
> same operation.
>
> This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
> handle NULL parameters fine.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/usb/host/ohci-exynos.c | 24 +++++++-----------------
>  1 file changed, 7 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 8d7977fd5d3bd502..8dd9c3b2411c383f 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -69,19 +69,12 @@ static int exynos_ohci_get_phy(struct device *dev,
>                         return -EINVAL;
>                 }
>
> -               phy = devm_of_phy_get(dev, child, NULL);
> +               phy = devm_of_phy_optional_get(dev, child, NULL);
>                 exynos_ohci->phy[phy_number] = phy;
>                 if (IS_ERR(phy)) {
> -                       ret = PTR_ERR(phy);
> -                       if (ret == -EPROBE_DEFER) {
> -                               of_node_put(child);
> -                               return ret;
> -                       } else if (ret != -ENOSYS && ret != -ENODEV) {
> -                               dev_err(dev,
> -                                       "Error retrieving usb2 phy: %d\n", ret);
> -                               of_node_put(child);
> -                               return ret;
> -                       }
> +                       of_node_put(child);
> +                       return dev_err_probe(dev, PTR_ERR(phy),
> +                                            "Error retrieving usb2 phy\n");

Optional is really the only reason for the caller to decide whether to
print an error message or not. If we have both flavors of 'get', then
really the 'get' functions should print an error message.

Rob
