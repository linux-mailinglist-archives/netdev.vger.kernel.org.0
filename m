Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4C3674EEA
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 09:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjATIE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 03:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjATIEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 03:04:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B8773EE7;
        Fri, 20 Jan 2023 00:04:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04536B82070;
        Fri, 20 Jan 2023 08:04:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C962BC433D2;
        Fri, 20 Jan 2023 08:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674201881;
        bh=ddZ781LlQNDNgJDsumMrpxwZeLDaEtSDv9QvaApUzp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jLY4RLPayUpA4+ykcD7mNqlzP1BnH2Dy/DJzQYURwXEBfqT6VzyheJu10hr1IVYIb
         85TbtBgYf8GQ+K2dTeYmBMMQwsoa4RyH5Pj6s1qVUciSJue9ZmBXKgO8mv0E6tU9aN
         WHrXJ7f1nOgrHtdizE3/rFnB3OPpJWobuTf/C9h146PD4XWNxfWsL7jzAo4t9DE50L
         0QXq1QRq9LZWGwwDYDi3I+OLy/m54tZnF8C7zxqUVRcsOW3bDQA/Za8OmLXpbdUGKC
         suCEVZKbikzCrl8ap+D/iMhvQSnOj2cIsHcfcFkzvDw5OE3pDgndn3muXhxYXe2/+j
         PG+c6DZUmzx4w==
Date:   Fri, 20 Jan 2023 13:34:37 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Rob Herring <robh@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Thierry Reding <thierry.reding@gmail.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>,
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
Subject: Re: [PATCH 7/7] usb: host: ohci-exynos: Convert to
 devm_of_phy_optional_get()
Message-ID: <Y8pLFZ/K3pNPx5hL@matsya>
References: <cover.1674036164.git.geert+renesas@glider.be>
 <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
 <CAL_JsqJS2JTZ1BxMbG_2zgzu5xtxMFPqjxc_vUjuZp3k1xUmaQ@mail.gmail.com>
 <CAMuHMdXGsmNjYy-ofmuHLkr8yaDEzy+SGnhtbmc_2ezbEKAMjw@mail.gmail.com>
 <CAL_JsqJWEzb_hxi0_sSj-5F0q4A9UcJEhwcSArWT6eAffpeqHA@mail.gmail.com>
 <CAMuHMdXFjJJq=XqBZmL+EC9x5DMmucyncKE5ExS89bb00sir1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXFjJJq=XqBZmL+EC9x5DMmucyncKE5ExS89bb00sir1g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-01-23, 08:56, Geert Uytterhoeven wrote:
> Hi Rob,
> 
> On Wed, Jan 18, 2023 at 8:49 PM Rob Herring <robh@kernel.org> wrote:
> > On Wed, Jan 18, 2023 at 12:28 PM Geert Uytterhoeven
> > <geert@linux-m68k.org> wrote:
> > > On Wed, Jan 18, 2023 at 6:30 PM Rob Herring <robh@kernel.org> wrote:
> > > > On Wed, Jan 18, 2023 at 4:15 AM Geert Uytterhoeven
> > > > <geert+renesas@glider.be> wrote:
> > > > > Use the new devm_of_phy_optional_get() helper instead of open-coding the
> > > > > same operation.
> > > > >
> > > > > This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
> > > > > handle NULL parameters fine.
> > > > >
> > > > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > > > ---
> > > > >  drivers/usb/host/ohci-exynos.c | 24 +++++++-----------------
> > > > >  1 file changed, 7 insertions(+), 17 deletions(-)
> > > > >
> > > > > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> > > > > index 8d7977fd5d3bd502..8dd9c3b2411c383f 100644
> > > > > --- a/drivers/usb/host/ohci-exynos.c
> > > > > +++ b/drivers/usb/host/ohci-exynos.c
> > > > > @@ -69,19 +69,12 @@ static int exynos_ohci_get_phy(struct device *dev,
> > > > >                         return -EINVAL;
> > > > >                 }
> > > > >
> > > > > -               phy = devm_of_phy_get(dev, child, NULL);
> > > > > +               phy = devm_of_phy_optional_get(dev, child, NULL);
> > > > >                 exynos_ohci->phy[phy_number] = phy;
> > > > >                 if (IS_ERR(phy)) {
> > > > > -                       ret = PTR_ERR(phy);
> > > > > -                       if (ret == -EPROBE_DEFER) {
> > > > > -                               of_node_put(child);
> > > > > -                               return ret;
> > > > > -                       } else if (ret != -ENOSYS && ret != -ENODEV) {
> > > > > -                               dev_err(dev,
> > > > > -                                       "Error retrieving usb2 phy: %d\n", ret);
> > > > > -                               of_node_put(child);
> > > > > -                               return ret;
> > > > > -                       }
> > > > > +                       of_node_put(child);
> > > > > +                       return dev_err_probe(dev, PTR_ERR(phy),
> > > > > +                                            "Error retrieving usb2 phy\n");
> > > >
> > > > Optional is really the only reason for the caller to decide whether to
> > > > print an error message or not. If we have both flavors of 'get', then
> > > > really the 'get' functions should print an error message.
> > >
> > > In case of a real error, both should print an error message, right?
> > >
> > > Anyway, I understand that's a three step operation:
> > >   1. Introduce and convert to the _optional variant,
> > >   2. Add error printing to callees.
> > >   3. Remove error printing from callers.
> >
> > I think you only need 2 out of 3 steps depending on the situation. In
> > this case, you can add error printing in the _optional variant when
> > you introduce it and then convert callers to it.
> >
> > Where we already have an optional variant, then you need steps 2 and 3.
> 
> Right, so the error printing can be done now, while introducing
> devm_of_phy_optional_get().
> 
> Vinod: Do you agree?

Ack.. IMO makes it better that way

> If yes, I can respin with that change.

ok

> If not, I'll have to respin anyway, as the bug in
> am65_cpsw_init_serdes_phy() has been fixed in the meantime.
> 
> Thanks!
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
> linux-phy mailing list
> linux-phy@lists.infradead.org
> https://lists.infradead.org/mailman/listinfo/linux-phy

-- 
~Vinod
