Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81ED96891B0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 09:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbjBCIL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 03:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232545AbjBCIKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 03:10:52 -0500
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E507EBB9B;
        Fri,  3 Feb 2023 00:10:09 -0800 (PST)
Received: by mail-oi1-f174.google.com with SMTP id c15so3375919oic.8;
        Fri, 03 Feb 2023 00:10:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kDxWR290mL61G5r22X9+N8Kd9HuPTjlQvTYHZMCubL4=;
        b=3eDzzWTiVP1aYFzPvZd8gKqPSx+KLtHm0PKZeHp3NYuZJ+wTXr0R/tTlic1v+1wjQJ
         Bfxp+jWw9ENk3ZIW3W5zLK0hpYpBZndRhkl5yh1AqqjaNTzxFP8vhrlkt5uzwZvYLFLj
         rwd8pSc+ZwpDai3zuCpzTgSzaWguZ8gssHfNcW7m9uPkhnuQ5rkdH+3SZAX0S+sORfij
         gwERmBL1q08YRKqq2TxJcYK0x5ZnjiKYW/gWsWZBQc7qV277g13EkKh/nBToEADED7rD
         8T5zp7F8ug454zLx1jFQGF3MLyCMMpsoD3H90e+v7408nD/ZM9mI4o0l6EOVKwMVt07/
         dU/g==
X-Gm-Message-State: AO0yUKWiIn9oW1g7jpOEe0Cc3ANQyb9cWsWoH+VpAvvN09Kn/6nWdop2
        /4EyHH8/eBmAaBTpKRFcesTAIR6giUUjSQ==
X-Google-Smtp-Source: AK7set9OnnbUpKR2KW2u/fmuxsyJ48mxJX3thUsf4xqf7oPnWAZMhOZ987ucA0ujE5juIfy+gaYgWg==
X-Received: by 2002:a05:6808:10c1:b0:35a:7043:ee4d with SMTP id s1-20020a05680810c100b0035a7043ee4dmr5791990ois.0.1675411809101;
        Fri, 03 Feb 2023 00:10:09 -0800 (PST)
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com. [209.85.210.54])
        by smtp.gmail.com with ESMTPSA id bk30-20020a0568081a1e00b0037880fdb1f6sm584350oib.24.2023.02.03.00.10.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 00:10:08 -0800 (PST)
Received: by mail-ot1-f54.google.com with SMTP id n25-20020a9d7119000000b0068bd8c1e836so1148749otj.3;
        Fri, 03 Feb 2023 00:10:08 -0800 (PST)
X-Received: by 2002:a25:ada1:0:b0:839:c329:be37 with SMTP id
 z33-20020a25ada1000000b00839c329be37mr1030442ybi.89.1675411484019; Fri, 03
 Feb 2023 00:04:44 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674584626.git.geert+renesas@glider.be> <3d612c95031cf5c6d5af4ec35f40121288a2c1c6.1674584626.git.geert+renesas@glider.be>
 <Y9ybPmWub43JpMUb@matsya>
In-Reply-To: <Y9ybPmWub43JpMUb@matsya>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Feb 2023 09:04:32 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVJo3aRLh4BCSvOrX+4KMNC=WoQCHMzdiWOmdjSSESxbg@mail.gmail.com>
Message-ID: <CAMuHMdVJo3aRLh4BCSvOrX+4KMNC=WoQCHMzdiWOmdjSSESxbg@mail.gmail.com>
Subject: Re: [PATCH v2 6/9] net: ethernet: ti: am65-cpsw: Convert to devm_of_phy_optional_get()
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
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinod,

On Fri, Feb 3, 2023 at 6:27 AM Vinod Koul <vkoul@kernel.org> wrote:
> On 24-01-23, 19:37, Geert Uytterhoeven wrote:
> > Use the new devm_of_phy_optional_get() helper instead of open-coding the
> > same operation.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > v2:
> >   - Rebase on top of commit 854617f52ab42418 ("net: ethernet: ti:
> >     am65-cpsw: Handle -EPROBE_DEFER for Serdes PHY") in net-next
> >     (next-20230123 and later).
>
> I was trying to apply this on rc1, so ofcourse this fails for me? How do
> we resolve this?
>
> I can skip this patch, provide a tag for this to be pulled into -net
> tree

Thanks, that's one option.
The other option is to postpone this patch, and apply it after v6.3-rc1.

Thanks!

> > --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> > @@ -1460,11 +1460,9 @@ static int am65_cpsw_init_serdes_phy(struct device *dev, struct device_node *por
> >       struct phy *phy;
> >       int ret;
> >
> > -     phy = devm_of_phy_get(dev, port_np, name);
> > -     if (PTR_ERR(phy) == -ENODEV)
> > -             return 0;
> > -     if (IS_ERR(phy))
> > -             return PTR_ERR(phy);
> > +     phy = devm_of_phy_optional_get(dev, port_np, name);
> > +     if (IS_ERR_OR_NULL(phy))
> > +             return PTR_ERR_OR_ZERO(phy);
> >
> >       /* Serdes PHY exists. Store it. */
> >       port->slave.serdes_phy = phy;

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
