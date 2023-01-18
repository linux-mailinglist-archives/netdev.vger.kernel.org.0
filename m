Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC9D6726E5
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 19:29:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjARS3B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 13:29:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjARS24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 13:28:56 -0500
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77FA7113E3;
        Wed, 18 Jan 2023 10:28:55 -0800 (PST)
Received: by mail-qt1-f177.google.com with SMTP id jr10so23232933qtb.7;
        Wed, 18 Jan 2023 10:28:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m6+hopJKlcYVjWue00VkVDFjPrjXwNY80RsgV+H7s3k=;
        b=3UCJo9oDRK+zvaNyNHHNbXjKGSAgrfcfUj/Uz4yPm56IaIlgxQv5el0QKqc4SGtvOv
         zzFLhzYYI9sGROEKG40rOBDkF4MnisI1A2z1m+38/AaD9lJH7Ku2b1/zYCabCJUpnNNu
         KuYIjCkU9+YqG6/k5a4+fT+DYd/JLD9YO3v+o5BE+RXtdViIR0o8SGzz7nLIeaXrjTWz
         QXfyMea8bzTPQ6K+zrYNDNTTmWUx9AgVrpaGu0/prCtwkp8nFYJe6NOGSiXCr6DfGkjW
         HYGd2YVo07u6dcqTTWIT9qHhIh3IAdFH7USLPwNrobdlv3PaVNFfoStoBFJiyFAkKLCr
         OcsA==
X-Gm-Message-State: AFqh2krIAzMz/4sIWdZPCboBDANEuWUVTgsNymi2JqAG8FKZzPfI6hAR
        D9qLGTIpmff1ScqRZrxaA619TuZyj1WTKLUk
X-Google-Smtp-Source: AMrXdXsTWIPihbbkeIVwRFkH1BG2PkiVfAKrtt5W2CMXq+ymezGSNRY6XyPDsA3E49/dpN5CuDoPbA==
X-Received: by 2002:ac8:738a:0:b0:3b6:4615:6d0e with SMTP id t10-20020ac8738a000000b003b646156d0emr6622972qtp.3.1674066534312;
        Wed, 18 Jan 2023 10:28:54 -0800 (PST)
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com. [209.85.219.179])
        by smtp.gmail.com with ESMTPSA id w25-20020ac86b19000000b003b63c08a888sm2977623qts.4.2023.01.18.10.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 10:28:53 -0800 (PST)
Received: by mail-yb1-f179.google.com with SMTP id 20so20137890ybl.0;
        Wed, 18 Jan 2023 10:28:53 -0800 (PST)
X-Received: by 2002:a25:d88c:0:b0:77a:b5f3:d0ac with SMTP id
 p134-20020a25d88c000000b0077ab5f3d0acmr833623ybg.202.1674066532773; Wed, 18
 Jan 2023 10:28:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674036164.git.geert+renesas@glider.be> <cd685d8e4d6754c384acfc1796065d539a2c3ea8.1674036164.git.geert+renesas@glider.be>
 <CAL_JsqJS2JTZ1BxMbG_2zgzu5xtxMFPqjxc_vUjuZp3k1xUmaQ@mail.gmail.com>
In-Reply-To: <CAL_JsqJS2JTZ1BxMbG_2zgzu5xtxMFPqjxc_vUjuZp3k1xUmaQ@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 18 Jan 2023 19:28:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXGsmNjYy-ofmuHLkr8yaDEzy+SGnhtbmc_2ezbEKAMjw@mail.gmail.com>
Message-ID: <CAMuHMdXGsmNjYy-ofmuHLkr8yaDEzy+SGnhtbmc_2ezbEKAMjw@mail.gmail.com>
Subject: Re: [PATCH 7/7] usb: host: ohci-exynos: Convert to devm_of_phy_optional_get()
To:     Rob Herring <robh@kernel.org>
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

On Wed, Jan 18, 2023 at 6:30 PM Rob Herring <robh@kernel.org> wrote:
> On Wed, Jan 18, 2023 at 4:15 AM Geert Uytterhoeven
> <geert+renesas@glider.be> wrote:
> > Use the new devm_of_phy_optional_get() helper instead of open-coding the
> > same operation.
> >
> > This lets us drop several checks for IS_ERR(), as phy_power_{on,off}()
> > handle NULL parameters fine.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  drivers/usb/host/ohci-exynos.c | 24 +++++++-----------------
> >  1 file changed, 7 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> > index 8d7977fd5d3bd502..8dd9c3b2411c383f 100644
> > --- a/drivers/usb/host/ohci-exynos.c
> > +++ b/drivers/usb/host/ohci-exynos.c
> > @@ -69,19 +69,12 @@ static int exynos_ohci_get_phy(struct device *dev,
> >                         return -EINVAL;
> >                 }
> >
> > -               phy = devm_of_phy_get(dev, child, NULL);
> > +               phy = devm_of_phy_optional_get(dev, child, NULL);
> >                 exynos_ohci->phy[phy_number] = phy;
> >                 if (IS_ERR(phy)) {
> > -                       ret = PTR_ERR(phy);
> > -                       if (ret == -EPROBE_DEFER) {
> > -                               of_node_put(child);
> > -                               return ret;
> > -                       } else if (ret != -ENOSYS && ret != -ENODEV) {
> > -                               dev_err(dev,
> > -                                       "Error retrieving usb2 phy: %d\n", ret);
> > -                               of_node_put(child);
> > -                               return ret;
> > -                       }
> > +                       of_node_put(child);
> > +                       return dev_err_probe(dev, PTR_ERR(phy),
> > +                                            "Error retrieving usb2 phy\n");
>
> Optional is really the only reason for the caller to decide whether to
> print an error message or not. If we have both flavors of 'get', then
> really the 'get' functions should print an error message.

In case of a real error, both should print an error message, right?

Anyway, I understand that's a three step operation:
  1. Introduce and convert to the _optional variant,
  2. Add error printing to callees.
  3. Remove error printing from callers.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
