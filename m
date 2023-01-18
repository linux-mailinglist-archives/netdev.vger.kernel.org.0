Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B608672417
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjARQuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjARQuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:50:17 -0500
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9FCB18AA5;
        Wed, 18 Jan 2023 08:50:15 -0800 (PST)
Received: by mail-qt1-f177.google.com with SMTP id q15so6419692qtn.0;
        Wed, 18 Jan 2023 08:50:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5eGZCXxPoQAmJ0txjytBJor7KBRzIjhRUq2JtcYKMyc=;
        b=zxXsA3PsAxNJlc/vHhsKADw+uOEVJ4Z11N/IrFWwKilJ3I33eNLfcHMo1END6YvOzX
         qYCQlz/B8QNTQvidg0T2BU6tDfUDm2D3CSk5K6w02sydoY03xZky0BJYvlgCyDY4txOC
         wKZLZzDListilZxOjSeUl1plHYnj3/pwWyJDkAUYlPvL09sr3S8jKKmkOZseBIUN0UxR
         45SjFw4NGnsCU0LhQ/OpicVOVf4N7nz5W/hoAcO72HfPRJIKHngiPrnAdfnf+oZWMP9x
         0TF3Rrofd3gcdCh/khFyh/zjeZwNwmOkZ1tjb1sKv/9nV1Pbohx/oiWbzH76kOjMN2YF
         Zh9g==
X-Gm-Message-State: AFqh2kqO5dBTXvKoebKOULBzgzHuiPQuDO6/E8hPt7DW8esiINDECMEF
        FQ5moY6X62NtsMv1ZysxraZLsBn0Hd9+BisU
X-Google-Smtp-Source: AMrXdXuQBIESpTUtyLs9kMzi3ikAcnU2clAWT40BpCtEkbtpDFvVXAxAbVSkyeAPwHxSUJviIHDMbw==
X-Received: by 2002:ac8:51ce:0:b0:3b6:3b81:9a99 with SMTP id d14-20020ac851ce000000b003b63b819a99mr9820213qtn.14.1674060614519;
        Wed, 18 Jan 2023 08:50:14 -0800 (PST)
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com. [209.85.128.181])
        by smtp.gmail.com with ESMTPSA id r3-20020ac87943000000b003a82562c90fsm3657280qtt.62.2023.01.18.08.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:50:13 -0800 (PST)
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-4e4a6af2d99so157036367b3.4;
        Wed, 18 Jan 2023 08:50:13 -0800 (PST)
X-Received: by 2002:a81:6e46:0:b0:37e:6806:a5f9 with SMTP id
 j67-20020a816e46000000b0037e6806a5f9mr952154ywc.47.1674060612772; Wed, 18 Jan
 2023 08:50:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674036164.git.geert+renesas@glider.be> <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
 <Y8gb8l18XzYOPhoD@rowland.harvard.edu>
In-Reply-To: <Y8gb8l18XzYOPhoD@rowland.harvard.edu>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 Jan 2023 17:50:00 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUsULA0PM26Y8WL2bGiBHGAGADS6eYLUp0CDVgm4N5kow@mail.gmail.com>
Message-ID: <CAMuHMdUsULA0PM26Y8WL2bGiBHGAGADS6eYLUp0CDVgm4N5kow@mail.gmail.com>
Subject: Re: [PATCH 7/7] usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
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
        Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
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
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alan,

On Wed, Jan 18, 2023 at 5:26 PM Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, Jan 18, 2023 at 11:15:20AM +0100, Geert Uytterhoeven wrote:
> > Use the new devm_of_phy_optional_get() helper instead of open-coding the
> > same operation.
> >
> > This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
> > handle NULL parameters fine.
>
> The patch ignores a possible -ENOSYS error return.  Is it known that
> this will never happen?

While some phy_*() dummies in include/linux/phy/phy.h do return -ENOSYS
if CONFIG_GENERIC_PHY is not enabled, devm_of_phy_optional_get()
returns NULL in that case, so I think this cannot happen.

> > --- a/drivers/usb/host/ohci-exynos.c
> > +++ b/drivers/usb/host/ohci-exynos.c
> > @@ -69,19 +69,12 @@ static int exynos_ohci_get_phy(struct device *dev,
> >                       return -EINVAL;
> >               }
> >
> > -             phy = devm_of_phy_get(dev, child, NULL);
> > +             phy = devm_of_phy_optional_get(dev, child, NULL);
> >               exynos_ohci->phy[phy_number] = phy;
> >               if (IS_ERR(phy)) {
> > -                     ret = PTR_ERR(phy);
> > -                     if (ret == -EPROBE_DEFER) {
> > -                             of_node_put(child);
> > -                             return ret;
> > -                     } else if (ret != -ENOSYS && ret != -ENODEV) {
> > -                             dev_err(dev,
> > -                                     "Error retrieving usb2 phy: %d\n", ret);
> > -                             of_node_put(child);
> > -                             return ret;
> > -                     }
> > +                     of_node_put(child);
> > +                     return dev_err_probe(dev, PTR_ERR(phy),
> > +                                          "Error retrieving usb2 phy\n");
> >               }
> >       }
> >

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
