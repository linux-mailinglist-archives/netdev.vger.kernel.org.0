Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36967674EC3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 08:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjATH4u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 02:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjATH4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 02:56:49 -0500
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138DF73EE7;
        Thu, 19 Jan 2023 23:56:44 -0800 (PST)
Received: by mail-qt1-f169.google.com with SMTP id a25so3555807qto.10;
        Thu, 19 Jan 2023 23:56:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Twh/RMOkW9lPwocGUUWk5FJezMEMoAxY5/88HPIqIY=;
        b=EwUyQMHeOHqY2GKAdCsEkXJ2TZv/+ReqBKQSreh0RxjG484Rw2k8mlvcEfiAc1VBKA
         c6Sxq/Nt5E67PI9xPNUKr+fu2A4YqZGAdEt/l0s3EiAVWGMWr1fEyYKsbnVrFdjNpMmR
         UdEZRSGFZXsS3VhxAm3u1hOoPaYKBn71rhOgv77ls4708IRzfhcILzSjrleIWxzyuuVn
         SsNy4H8cBznPwN+dZajfz3oqz3Zo/EbfxT7oJ0RFGRpBtZyp6Tw/FRtNbwib5nxbV0xQ
         o/3GCAAIkDC/w9ap6pRX5a0yPUgxkQiZoB9UDSQJA2w5ZYm0U70mMnICDuHyu287O9aw
         Ezwg==
X-Gm-Message-State: AFqh2koqCQvI7uIliXlvNlVPc8Voe5jAU8z2F0dzebxesYzz848izQ3b
        UBAeiUIGtOay8F86y8ZPaO4Hbtv0cyIR2Q==
X-Google-Smtp-Source: AMrXdXt/BLKDHBvWbLEE8cp0teZsHzSzsAkhF0/bWgDgxdvI4+cOc2P+di7V32BYK20iSjYC3BWjxg==
X-Received: by 2002:ac8:5ed6:0:b0:3ab:9974:3a06 with SMTP id s22-20020ac85ed6000000b003ab99743a06mr16795498qtx.38.1674201402988;
        Thu, 19 Jan 2023 23:56:42 -0800 (PST)
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com. [209.85.128.169])
        by smtp.gmail.com with ESMTPSA id ca24-20020a05622a1f1800b003b697038179sm1016499qtb.35.2023.01.19.23.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jan 2023 23:56:42 -0800 (PST)
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-4d0f843c417so61481887b3.7;
        Thu, 19 Jan 2023 23:56:42 -0800 (PST)
X-Received: by 2002:a0d:db07:0:b0:500:8d0d:7feb with SMTP id
 d7-20020a0ddb07000000b005008d0d7febmr79917ywe.358.1674201401946; Thu, 19 Jan
 2023 23:56:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674036164.git.geert+renesas@glider.be> <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
 <CAL_JsqJS2JTZ1BxMbG_2zgzu5xtxMFPqjxc_vUjuZp3k1xUmaQ@mail.gmail.com>
 <CAMuHMdXGsmNjYy-ofmuHLkr8yaDEzy+SGnhtbmc_2ezbEKAMjw@mail.gmail.com> <CAL_JsqJWEzb_hxi0_sSj-5F0q4A9UcJEhwcSArWT6eAffpeqHA@mail.gmail.com>
In-Reply-To: <CAL_JsqJWEzb_hxi0_sSj-5F0q4A9UcJEhwcSArWT6eAffpeqHA@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 Jan 2023 08:56:29 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXFjJJq=XqBZmL+EC9x5DMmucyncKE5ExS89bb00sir1g@mail.gmail.com>
Message-ID: <CAMuHMdXFjJJq=XqBZmL+EC9x5DMmucyncKE5ExS89bb00sir1g@mail.gmail.com>
Subject: Re: [PATCH 7/7] usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()
To:     Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>
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
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On Wed, Jan 18, 2023 at 8:49 PM Rob Herring <robh@kernel.org> wrote:
> On Wed, Jan 18, 2023 at 12:28 PM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > On Wed, Jan 18, 2023 at 6:30 PM Rob Herring <robh@kernel.org> wrote:
> > > On Wed, Jan 18, 2023 at 4:15 AM Geert Uytterhoeven
> > > <geert+renesas@glider.be> wrote:
> > > > Use the new devm_of_phy_optional_get() helper instead of open-coding the
> > > > same operation.
> > > >
> > > > This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
> > > > handle NULL parameters fine.
> > > >
> > > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > > ---
> > > >  drivers/usb/host/ohci-exynos.c | 24 +++++++-----------------
> > > >  1 file changed, 7 insertions(+), 17 deletions(-)
> > > >
> > > > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> > > > index 8d7977fd5d3bd502..8dd9c3b2411c383f 100644
> > > > --- a/drivers/usb/host/ohci-exynos.c
> > > > +++ b/drivers/usb/host/ohci-exynos.c
> > > > @@ -69,19 +69,12 @@ static int exynos_ohci_get_phy(struct device *dev,
> > > >                         return -EINVAL;
> > > >                 }
> > > >
> > > > -               phy = devm_of_phy_get(dev, child, NULL);
> > > > +               phy = devm_of_phy_optional_get(dev, child, NULL);
> > > >                 exynos_ohci->phy[phy_number] = phy;
> > > >                 if (IS_ERR(phy)) {
> > > > -                       ret = PTR_ERR(phy);
> > > > -                       if (ret == -EPROBE_DEFER) {
> > > > -                               of_node_put(child);
> > > > -                               return ret;
> > > > -                       } else if (ret != -ENOSYS && ret != -ENODEV) {
> > > > -                               dev_err(dev,
> > > > -                                       "Error retrieving usb2 phy: %d\n", ret);
> > > > -                               of_node_put(child);
> > > > -                               return ret;
> > > > -                       }
> > > > +                       of_node_put(child);
> > > > +                       return dev_err_probe(dev, PTR_ERR(phy),
> > > > +                                            "Error retrieving usb2 phy\n");
> > >
> > > Optional is really the only reason for the caller to decide whether to
> > > print an error message or not. If we have both flavors of 'get', then
> > > really the 'get' functions should print an error message.
> >
> > In case of a real error, both should print an error message, right?
> >
> > Anyway, I understand that's a three step operation:
> >   1. Introduce and convert to the _optional variant,
> >   2. Add error printing to callees.
> >   3. Remove error printing from callers.
>
> I think you only need 2 out of 3 steps depending on the situation. In
> this case, you can add error printing in the _optional variant when
> you introduce it and then convert callers to it.
>
> Where we already have an optional variant, then you need steps 2 and 3.

Right, so the error printing can be done now, while introducing
devm_of_phy_optional_get().

Vinod: Do you agree?
If yes, I can respin with that change.
If not, I'll have to respin anyway, as the bug in
am65_cpsw_init_serdes_phy() has been fixed in the meantime.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
