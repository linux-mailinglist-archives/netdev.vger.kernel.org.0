Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2D057E016
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 12:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiGVKes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 06:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGVKeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 06:34:46 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DEAB504B;
        Fri, 22 Jul 2022 03:34:45 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id k11so5460754wrx.5;
        Fri, 22 Jul 2022 03:34:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nADJV/5h4/gXCaYOhbEKrLOB3utQ1DQ34j9M9pOUKE0=;
        b=VO1T3ebTHCu1EUWsSLeORLAl1p/Od8dWYZbdI0LL8n2lR8Pr3y2wzoMaS80ob4Wx/r
         111bAg4GE3yUwig36YYcJBSRM40eBmE/S8ymOgIiNsLg82MOTVBJZywaorkX4d47N8Jw
         Lo79U0rXodkieL0CMIl0lgVUiZ93w1nhe7gRxsf0UJN2ZOMsVi4tPbiBW+Xe2gffPc9/
         j4BFeFcpKzic0hPJqqjU2hRhj1ywtA6RCf2DjABovRO/WPevh+pjDbRCLNGQThPTIETi
         MAQo9etiinkoS6NC8wqE0CJc6pB808OyETkxraWxJbP30HQYkd/4LMEV5CIwB3gwB7ns
         AVNw==
X-Gm-Message-State: AJIora9tkpCf6jdxqEhVNVGXnal+cpaoShow1srbtQcfZzgv7PDkD5KU
        AgMynbh780JgXH9q/M2hTORNBvMVYVri0+hwcGI=
X-Google-Smtp-Source: AGRyM1sKbSRq+SAZTyfFGHE2wnRenI490IAH0OsYzAtZIRAO4ZCZyR6GjHaXYB2u+5KtBP8xla0cN+koqjKvDJwChw0=
X-Received: by 2002:a5d:620b:0:b0:21e:5252:311c with SMTP id
 y11-20020a5d620b000000b0021e5252311cmr2005942wru.604.1658486084189; Fri, 22
 Jul 2022 03:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220720112924.1096-1-harini.katakam@xilinx.com>
 <20220720112924.1096-3-harini.katakam@xilinx.com> <ba2a4652-31b0-e2c1-94cd-2552efef4f15@microchip.com>
In-Reply-To: <ba2a4652-31b0-e2c1-94cd-2552efef4f15@microchip.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Fri, 22 Jul 2022 16:04:33 +0530
Message-ID: <CAFcVEC+6uNZ0Sq+GQLxZdCW9+DtAh9e-yxrK--3VTGLsOz0_1Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: macb: Update tsu clk usage in runtime
 suspend/resume for Versal
To:     Claudiu Beznea <Claudiu.Beznea@microchip.com>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <Nicolas.Ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, edumazet@google.com,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        krzysztof.kozlowski+dt@linaro.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
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

Hi Claudiu,

On Fri, Jul 22, 2022 at 1:55 PM <Claudiu.Beznea@microchip.com> wrote:
>
> On 20.07.2022 14:29, Harini Katakam wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> >
> > On Versal TSU clock cannot be disabled irrespective of whether PTP is
> > used. Hence introduce a new Versal config structure with a "need tsu"
> > caps flag and check the same in runtime_suspend/resume before cutting
> > off clocks.
> >
> > More information on this for future reference:
> > This is an IP limitation on versions 1p11 and 1p12 when Qbv is enabled
> > (See designcfg1, bit 3). However it is better to rely on an SoC specific
> > check rather than the IP version because tsu clk property itself may not
> > represent actual HW tsu clock on some chip designs.
> >
> > Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > ---
> >  drivers/net/ethernet/cadence/macb.h      |  1 +
> >  drivers/net/ethernet/cadence/macb_main.c | 17 +++++++++++++++--
> >  2 files changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> > index 7ca077b65eaa..8bf67b44b466 100644
> > --- a/drivers/net/ethernet/cadence/macb.h
> > +++ b/drivers/net/ethernet/cadence/macb.h
> > @@ -725,6 +725,7 @@
> >  #define MACB_CAPS_MACB_IS_GEM                  0x80000000
> >  #define MACB_CAPS_PCS                          0x01000000
> >  #define MACB_CAPS_HIGH_SPEED                   0x02000000
> > +#define MACB_CAPS_NEED_TSUCLK                  0x00001000
>
> Can you keep this sorted by the bit position used?

Thanks for the review.
Sure, I'll sort these in a separate patch first in the same series.

>
> >
> >  /* LSO settings */
> >  #define MACB_LSO_UFO_ENABLE                    0x01
> > diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> > index 7eb7822cd184..8bbc46e8a9eb 100644
> > --- a/drivers/net/ethernet/cadence/macb_main.c
> > +++ b/drivers/net/ethernet/cadence/macb_main.c
> > @@ -4735,6 +4735,16 @@ static const struct macb_config zynqmp_config = {
> >         .usrio = &macb_default_usrio,
> >  };
> >
> > +static const struct macb_config versal_config = {
> > +       .caps = MACB_CAPS_GIGABIT_MODE_AVAILABLE | MACB_CAPS_JUMBO |
> > +               MACB_CAPS_GEM_HAS_PTP | MACB_CAPS_BD_RD_PREFETCH | MACB_CAPS_NEED_TSUCLK,
> > +       .dma_burst_length = 16,
> > +       .clk_init = macb_clk_init,
> > +       .init = init_reset_optional,
> > +       .jumbo_max_len = 10240,
> > +       .usrio = &macb_default_usrio,
> > +};
> > +
>
> Also, could you keep this not b/w zynq configs to have a bit of sort of these?
>
> Other than this:
>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Thanks.

Regards,
Harini
