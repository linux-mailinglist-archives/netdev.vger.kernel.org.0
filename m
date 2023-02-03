Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A06896A0
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 11:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233511AbjBCK0r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 05:26:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233397AbjBCKZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 05:25:00 -0500
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B124625290;
        Fri,  3 Feb 2023 02:24:31 -0800 (PST)
Received: by mail-qt1-f176.google.com with SMTP id g7so4878169qto.11;
        Fri, 03 Feb 2023 02:24:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nqgawi8X0VJ7ktaDq/HQw3QZiJnimJOm65jxzmqBcak=;
        b=FMg6jPIs7zJVYb4vV9/UcdK5rKil2GD/typeJyhfCOm17lqseO27ZkvVqJd2MDsZ47
         +cfzqg8rSPmGgHoYLxh1rIghVkn/u0udG2PmFRn5DNvodxejx2D3GWk/tYWRIW7lvyhM
         9YGSKkznPyWZPeVcKua6yj5ZPDA/XY+UeqJTB32U4dLk/kTdY+3Ll02YFJOmQgUOHl+h
         99LnW8QJoEY2/pSagreTxlHgL7mSykRl+z5LFEJJc8eC0fsCL3yXRwRWs+4L/EzxypcD
         zLo9ba+W2fKnlvAXpbZLcMUyoxdaWhtdnshswk6nv1oulwc/ionA1lOLfMSH3TFt0OPb
         QfQw==
X-Gm-Message-State: AO0yUKUk1Ka3byqOFb6XdKnWi6+v4tPGWSs7HJtGGGqWeoMppoIbk0F9
        S/RIxTqmzV46lq3dfUBn0DCznfGLIJs4iw==
X-Google-Smtp-Source: AK7set/ZQsUGUGT/49iEtKCNGLLIjtoxiW68cszRNfmZ16XEzBOnsOZ3qhT79jH9e01leNRgAuBHZQ==
X-Received: by 2002:a05:622a:414:b0:3b6:3508:2a3e with SMTP id n20-20020a05622a041400b003b635082a3emr19185851qtx.4.1675419861182;
        Fri, 03 Feb 2023 02:24:21 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id e18-20020ac86712000000b003b9a505627bsm1288741qtp.79.2023.02.03.02.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 02:24:20 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id x139so5630491ybe.13;
        Fri, 03 Feb 2023 02:24:20 -0800 (PST)
X-Received: by 2002:a25:ada1:0:b0:839:c329:be37 with SMTP id
 z33-20020a25ada1000000b00839c329be37mr1059112ybi.89.1675419860256; Fri, 03
 Feb 2023 02:24:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674499048.git.geert+renesas@glider.be> <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be>
 <CAMuHMdXtiC-Oo01Y-vCbokjF=L+YXMN=TucgqCS4Vtcg5gt==g@mail.gmail.com>
 <20230202144000.2qvtnorgig52jfhw@pengutronix.de> <CAMuHMdUm+ExFCspjk6OO3pvZ-mW8dOiZe7bS2r-ys0S=CBAT-Q@mail.gmail.com>
 <20230202150632.oo57ap7bdapsvrum@pengutronix.de>
In-Reply-To: <20230202150632.oo57ap7bdapsvrum@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 3 Feb 2023 11:24:08 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX0iHUvyFYSdQJFLOzatjgHDnHYDzVvWFukYpXKbq7RxA@mail.gmail.com>
Message-ID: <CAMuHMdX0iHUvyFYSdQJFLOzatjgHDnHYDzVvWFukYpXKbq7RxA@mail.gmail.com>
Subject: Re: [PATCH 12/12] can: rcar_canfd: Add transceiver support
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, Vinod <vkoul@kernel.org>
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

Hi Marc,

On Thu, Feb 2, 2023 at 4:06 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 02.02.2023 15:53:08, Geert Uytterhoeven wrote:
> > > > > This depends on "[PATCH 1/7] phy: Add devm_of_phy_optional_get() helper".
> > > > > https://lore.kernel.org/all/f53a1bcca637ceeafb04ce3540a605532d3bc34a.1674036164.git.geert+renesas@glider.be
> > > >
> > > > v2: "[PATCH v2 3/9] phy: Add devm_of_phy_optional_get() helper"
> > > >     https://lore.kernel.org/all/4cd0069bcff424ffc5c3a102397c02370b91985b.1674584626.git.geert+renesas@glider.be
> > > >
> > > > I'll keep you updated when/if this ends up on an immutable branch.
> > >
> > > Should I take the patches 1...11 for can-next/main?
> >
> > That would be great, thanks!
>
> Done.

Thank you!
Meanwhile, the dependency for 12/12 is now available as an immutable
branch, cfr. https://lore.kernel.org/all/Y9za4a8qyapi4CWD@matsya

Thanks again!


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
