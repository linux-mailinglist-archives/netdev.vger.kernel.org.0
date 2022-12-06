Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7132B6448D6
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 17:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235504AbiLFQKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 11:10:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235271AbiLFQJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 11:09:41 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9663AC2F;
        Tue,  6 Dec 2022 08:04:35 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id s5so20867409edc.12;
        Tue, 06 Dec 2022 08:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t8cA4ACelgyjXGYdUQh+jD+jJuegWDTJ6AcOocRBXlg=;
        b=UDbZ7YkU9hRMLDz1egSCEnbQlgdWZjEVy636iYNE+34e/fSxF62gaDd6CTMdppFtCK
         gg/tmHGxjv6MmTRtOIK6cx2Jjb3mrtGU3frQXEfew2/+LTUEgbnyISdsKs3uGml2JOtZ
         JvYal2m3xNBsJGKirr1ul8T5Nqd523nKJZ5j/6tsiWtmmwa5Lq9hS9GDQVfeeHi8DuNO
         9AH2mDVYfYFz3XMKsNqvPsJgk2ntQaoPQjCS/0XXQ47EzhHk/ZzAcZeGVyZBpXi0/BKY
         ja42TGmlgxjL8R53NfB3B/0xZOOKq7jWt3JyWFWCklmO4Nc0rmdZcq3WlTtSguff+bFS
         +xvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t8cA4ACelgyjXGYdUQh+jD+jJuegWDTJ6AcOocRBXlg=;
        b=olay62LRaSe+dfFDCKnIqP9H0/J1TI00PjCUeh1sNY33HWirTT8uF8bilNfoJB6Kyf
         91Z6DtEM5ykYFgCIRLWlUMPpx9WqsUfLkP2rFmva2yXh6oVH6+O8tOLCruPVyRV8CguT
         HfikQ4Eb50GssVAztN7UFqC3H2iDyRHGlBGLUrtQcrW2TXB3Q1PZwDQWlz83LCeV15Wt
         YZXzoIEuigsjF4nnagax/gr90Qup2Al0YlFLZh4DZ4sJeJlIhCC5JM0LQGK2wjhmYJab
         WU0GJTtdQQzWThheH1gIkjREueXY5HRQ60Omy6gmd5cOcXuCOPwDsgzKBVTwAmVbzfz1
         tdcA==
X-Gm-Message-State: ANoB5pkht0eqnziw4oiM6deE8BgS4crbpgClWy/Tp45Q+uyxPhx6QTeY
        NU9jbCphdqVxIxbGOenbkSc=
X-Google-Smtp-Source: AA0mqf6eCz9WrlnsQ6nH/cJ10vu3pmDPK2/Tun57q7E62E++v7Ogms9pw0K/xifG+5+Clvkvi4W2KQ==
X-Received: by 2002:aa7:d1c5:0:b0:46b:a536:e8d0 with SMTP id g5-20020aa7d1c5000000b0046ba536e8d0mr26487265edp.261.1670342673471;
        Tue, 06 Dec 2022 08:04:33 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id gi20-20020a1709070c9400b0077d6f628e14sm7565992ejc.83.2022.12.06.08.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 08:04:33 -0800 (PST)
Date:   Tue, 6 Dec 2022 18:04:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?utf-8?B?bsOnIMOcTkFM?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [PATCH v4 net-next 0/9] dt-binding preparation for ocelot
 switches
Message-ID: <20221206160430.4kiyrzrumcc6dp2g@skbuf>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin,

On Fri, Dec 02, 2022 at 12:45:50PM -0800, Colin Foster wrote:
> Ocelot switches have the abilitiy to be used internally via
> memory-mapped IO or externally via SPI or PCIe. This brings up issues
> for documentation, where the same chip might be accessed internally in a
> switchdev manner, or externally in a DSA configuration. This patch set
> is perparation to bring DSA functionality to the VSC7512, utilizing as
> much as possible with an almost identical VSC7514 chip.
> 
> This patch set changed quite a bit from v2, so I'll omit the background
> of how those sets came to be. Rob offered a lot of very useful guidance.
> My thanks.
> 
> At the end of the day, with this patch set, there should be a framework
> to document Ocelot switches (and any switch) in scenarios where they can
> be controlled internally (ethernet-switch) or externally (dsa-switch).
> 
> ---

This looks like a very clean implementation of what I had in mind
(better than I could have done it). Sorry for not being able to help
with the json-schema bits and thanks to Rob for doing so.

Would you mind adding one more patch at the beginning of the series
which syncs the maintainers from the DSA (and now also ethernet-switch)
dt-bindings with the MAINTAINERS file? That would mean removing Vivien
(see commit 6ce3df596be2 ("MAINTAINERS: Move Vivien to CREDITS")) and
adding myself. This is in principle such that you don't carry around a
not-up-to-date list of maintainers when adding new schemas.

I don't know if we could do something about maintainer entries in
schemas not becoming out of date w.r.t. the MAINTAINERS file.
