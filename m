Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE9836880BB
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbjBBOyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232771AbjBBOxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:53:47 -0500
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8CF190399;
        Thu,  2 Feb 2023 06:53:21 -0800 (PST)
Received: by mail-qt1-f180.google.com with SMTP id m26so2034429qtp.9;
        Thu, 02 Feb 2023 06:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KVmz0ZGGG5hNzR9A7sThGYZm5Ftof8Kw2ogOSsC2SYs=;
        b=3Rc7w39PxaQXBYQp+Kp3jT/9Y7eDCKF5K54dHhUq6yDZyBVmyOrpYhJdHot5R0esYI
         7lJKq5QTM0C7a5/3Q7QQLWWUqvSBTsTJB4JZ2rOFDMdlTTdaU1J7w8SGLrSqS0cVQljh
         eKPpD9uk/XxZI/+JRcWq3hBLhcIVyPLeZWB8fDUush8JdT5V219Rg5833PGu8MydJv2S
         8pL9s2HzCK7BRr632Vw9sL28JoAM41WBHSDDSUkklUV4nihvNbG9Z3IYQ8bYN60Bla4X
         J3ejTFYalsNu3bbCnLM0XEax6A76JyF+SR1tFA4yrxtuB9ZOElnrvzMqXEiNvVZEYFJ5
         oZ/g==
X-Gm-Message-State: AO0yUKXtun/rOa0XIPGJIqeOqZ4IBmi9PTFuOhyi5rVeYr1EIox/XxqX
        1yB8a68oscze0QgoTLA0TCPvan3ZLV+FTA==
X-Google-Smtp-Source: AK7set9Q2amItF0Syp10S9qUJiZrSVkz4tHmvvby0gtZafYJAJ2Pp9oIPqk994eOfNn8jX1lUweVZA==
X-Received: by 2002:a05:622a:190a:b0:3b9:b808:9eb8 with SMTP id w10-20020a05622a190a00b003b9b8089eb8mr13271583qtc.58.1675349600667;
        Thu, 02 Feb 2023 06:53:20 -0800 (PST)
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com. [209.85.128.177])
        by smtp.gmail.com with ESMTPSA id a17-20020ac86111000000b003b0766cd169sm13942544qtm.2.2023.02.02.06.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Feb 2023 06:53:20 -0800 (PST)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-50660e2d2ffso29606307b3.1;
        Thu, 02 Feb 2023 06:53:19 -0800 (PST)
X-Received: by 2002:a0d:f106:0:b0:507:86ae:c733 with SMTP id
 a6-20020a0df106000000b0050786aec733mr850721ywf.358.1675349599638; Thu, 02 Feb
 2023 06:53:19 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674499048.git.geert+renesas@glider.be> <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be>
 <CAMuHMdXtiC-Oo01Y-vCbokjF=L+YXMN=TucgqCS4Vtcg5gt==g@mail.gmail.com> <20230202144000.2qvtnorgig52jfhw@pengutronix.de>
In-Reply-To: <20230202144000.2qvtnorgig52jfhw@pengutronix.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 2 Feb 2023 15:53:08 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUm+ExFCspjk6OO3pvZ-mW8dOiZe7bS2r-ys0S=CBAT-Q@mail.gmail.com>
Message-ID: <CAMuHMdUm+ExFCspjk6OO3pvZ-mW8dOiZe7bS2r-ys0S=CBAT-Q@mail.gmail.com>
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
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Thu, Feb 2, 2023 at 3:40 PM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> On 24.01.2023 19:41:03, Geert Uytterhoeven wrote:
> > On Mon, Jan 23, 2023 at 7:56 PM Geert Uytterhoeven
> > <geert+renesas@glider.be> wrote:
> > > Add support for CAN transceivers described as PHYs.
> > >
> > > While simple CAN transceivers can do without, this is needed for CAN
> > > transceivers like NXP TJR1443 that need a configuration step (like
> > > pulling standby or enable lines), and/or impose a bitrate limit.
> > >
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > ---
> > > This depends on "[PATCH 1/7] phy: Add devm_of_phy_optional_get() helper".
> > > https://lore.kernel.org/all/f53a1bcca637ceeafb04ce3540a605532d3bc34a.1674036164.git.geert+renesas@glider.be
> >
> > v2: "[PATCH v2 3/9] phy: Add devm_of_phy_optional_get() helper"
> >     https://lore.kernel.org/all/4cd0069bcff424ffc5c3a102397c02370b91985b.1674584626.git.geert+renesas@glider.be
> >
> > I'll keep you updated when/if this ends up on an immutable branch.
>
> Should I take the patches 1...11 for can-next/main?

That would be great, thanks!

I had hoped Vinod would have applied the dependency, and provided
an immutable branch, as originally planned.

Alternatively, I can send a v2 of 12/12 that does not rely on the
new helper, and convert it later.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
