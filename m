Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2B656A407
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbiGGNrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235044AbiGGNrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:47:07 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA04B1FCCF
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 06:47:06 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id e69so26007881ybh.2
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 06:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cb5BPO4Y+9G3ein06+iQjj8mgQS/6wAsLzGRU0S9TDs=;
        b=C5ExqJkULBLoSw11dpTvVl75U6NGIIk5Oq2fJRmtWkBps1PTAGcKm00bvNywN6iXoa
         8I8K6JXmyEZfiPj//h6Fpvarvsw7l6ooeemkQlZuRYne75Pwm4PXwOG25ZDvgTrhdinq
         DAIr0bzEmrP3K4w9Yd7KaXATLP+IApD38FdkiPdFAklsQLZGJATpFP7PIQ4H64tQF1hA
         JOIo5KTj3Wp9YHbZ26o0CdGFkFENNOcZSeKJuA/jTs+avfU33ZfNLDQhoCf3fHF05lFW
         d2lmoZ2o0o0Y1L/JH1CBYwVMrmuzYySaUav7qOXNqxhG187XiZ+XWfL5qbLrzvz/TiKU
         Z+3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cb5BPO4Y+9G3ein06+iQjj8mgQS/6wAsLzGRU0S9TDs=;
        b=b5sYDfAjDN5z11O7oargxLQDb2iIvwhk0s45UwWYM6BIC+vOgjL/7cTPMcGdibCucD
         f0B2sw7mgPbAVBfYB6B2gqHdj+eNk0vHtZgKGdA/3e/2EvRFKdgPf8nQ7HNOkdK37sR/
         dEj1NdD37/ZmaeyOTClLbIaOVvc/w7VK66UqU7nEYihbjNG/2WAXB/h7x3ErOrwg4QjH
         nrR5JioYVjx4idLyRjho97PpHSyO4EImdyUebLP82HN5g8HOBb3iH2gghNIR+41YAe4I
         U1sB3cfWYirR9i/AOa6g0W1IfnfxqwtycSow1LDfOZuk3CpS7D+jErGvgfuPJ+HFKIw0
         a+mg==
X-Gm-Message-State: AJIora/xS66TZ9sIZ9J4pn5iRZk+P0WnjCXhJHWys19pwg/ri+rKBg4W
        8zrfbO5mwBgUquRgVLe1ziu+i8nC9XIkp22MGgNP5g==
X-Google-Smtp-Source: AGRyM1uvQ0cQJty2FzAW4FeDdGQz6QaZTV3BooLcLf0wn4LKyRX+g6NzcH2vD+4rygvTxGUCIropcgNBlA+8Fh01ehE=
X-Received: by 2002:a25:6cc5:0:b0:66e:6606:74fe with SMTP id
 h188-20020a256cc5000000b0066e660674femr20004122ybc.291.1657201626136; Thu, 07
 Jul 2022 06:47:06 -0700 (PDT)
MIME-Version: 1.0
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk> <CACRpkda3tdo0q2xZGrAO2b6Pef-Pt2GV0VyVam1uFKotk4iXKA@mail.gmail.com>
In-Reply-To: <CACRpkda3tdo0q2xZGrAO2b6Pef-Pt2GV0VyVam1uFKotk4iXKA@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 7 Jul 2022 15:46:54 +0200
Message-ID: <CACRpkdZgdwvgx6j8LVDW+z0sHL8uzxqDUaNZxRv--jbKVhA0PQ@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 7, 2022 at 12:46 AM Linus Walleij <linus.walleij@linaro.org> wrote:

> Pulled in the patch set on top of net-next and tested on the
> D-Link DIR-685 with the RTL8366RB switch with no
> regressions, so:
> Tested-by: Linus Walleij <linus.walleij@linaro.org>
>
> The plan is to enhance the phylink handling in the RTL8366RB
> on top of Russell's patch in some time.

I developed a patch like this and tested it, it works great and the DSA
core now properly configures all the links (as expected).

I will send this out once Russell's patches are finalized and merged.

Yours,
Linus Walleij
