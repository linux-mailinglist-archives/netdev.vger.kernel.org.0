Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BB145B063
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 00:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhKWXmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 18:42:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhKWXmq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 18:42:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84B6760E73;
        Tue, 23 Nov 2021 23:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637710776;
        bh=3fGS3fJVzIqWTvzYXNuJF3rN5i5Y0f3ysPLe2vPfhDI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WXVdiIxPBgUOypvzOaF0fBxWKSEXocAxCezwcicOtDwk6Pl/fTaXOGMFHCv42qdgk
         06PQeQEcbXng65bGDATF0+nVmsTSMp8BBCz7A4wYgaytXG8ZHo0+iS0f7S69OsoeiT
         CVRnwU5b+gsiMMuCAoV/aJWp3H0X7Q+OEyW5V7OUfvjT4gFRHHk/0rx+Xw5MYP55kO
         wyExxdl4kXS5c/b+SJEjSmNNUVpkE8gJvF6MazigKp2hDmdacWiySDISmLItkvjDR0
         FRuVxD3h5Kk8WmmbDcNI0FAvOAtmm4e2xtxxdhiZX+UDhKAmiOT3wbvmk/YCskjguj
         L+N8zubU/ANCg==
Date:   Tue, 23 Nov 2021 15:39:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Paul Walmsley <paul@pwsan.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Tero Kristo <kristo@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Benoit Parrot <bparrot@ti.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Keerthy <j-keerthy@ti.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, openbmc@lists.ozlabs.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-pm@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}()
 helpers
Message-ID: <20211123153933.49ff8b72@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
References: <cover.1637592133.git.geert+renesas@glider.be>
        <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
        <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
        <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Nov 2021 09:36:22 +0100 Geert Uytterhoeven wrote:
> > > Also, you're using __ffs(), which doesn't work for 64-bit on 32-bit
> > > architectures (afaict), so that seems a bit awkward.
> > >
> > > Maybe we can make {u32,...}_get_bits() be doing compile-time only checks
> > > if it is indeed a constant? The __field_overflow() usage is already only
> > > done if __builtin_constant_p(v), so I guess we can do the same with
> > > __bad_mask()?  
> >
> > Either that or add decomposition macros. Are compilers still really bad
> > at passing small structs by value?  
> 
> Sorry, I don't get what you mean by adding decomposition macros.
> Can you please elaborate?

#define DECOMPOSE(_mask) \
  (struct bf){ .mask = _mask, .shf = __bf_shf(_mask), }

Then drivers can save or pass around the mask and shift params 
broken apart as a small struct.
