Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE4145B634
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241076AbhKXIHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhKXIHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:07:44 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5ACC061574;
        Wed, 24 Nov 2021 00:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=A8apBARRFPbiSEW1ceN6aynN1mbMSw2kt4pRYV7bzUs=;
        t=1637741075; x=1638950675; b=fOIugJ371/M3ZN3Jkyqas0ZROi7Mwh9OUvsSiN0uekx+Lw+
        hrnOMtvjWKlMDr4UfmJSTwTkJQvgZQyijM3/YUstkBGgYIRqYx9qbJdenr/q9j4wL6SvNdu4k1gR6
        mfdfeC7suQHGLHzOQE+mQHdaEABHb3cNkvYat3xVwnn/PNlJ/DLV+t1NGdIGZt9n88u4BnowfU97I
        Z0hgJ6vpeuLSHtHp2DVhEDVGSzt4J/4fmEiY9LQNggHWOU60PKGn+6UAMV4kBFDMK86WBcezP/hFX
        2r0Gi9h5YE7pNDQDrCeDqjaVyfnrzdjQ5KQLVwP1KgwPTxDaEYjiEGb0saU6Jl+Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mpnFW-0027Gb-B2;
        Wed, 24 Nov 2021 09:03:26 +0100
Message-ID: <05d4673a0343bfd83824d307e9cf8bf92e3814a6.camel@sipsolutions.net>
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}()
 helpers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
Date:   Wed, 24 Nov 2021 09:03:24 +0100
In-Reply-To: <20211123154922.600fd3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1637592133.git.geert+renesas@glider.be>
         <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
         <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
         <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
         <637a4183861a1f2cdab52b7652bfa7ed33fbcdd2.camel@sipsolutions.net>
         <20211123154922.600fd3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-11-23 at 15:49 -0800, Jakub Kicinski wrote:
> On Tue, 23 Nov 2021 17:24:15 +0100 Johannes Berg wrote:
> > > (*_replace_bits() seems to be useful, though)  
> > 
> > Indeed.
> > 
> > Also as I said in my other mail, the le32/be32/... variants are
> > tremendously useful, and they fundamentally cannot be expressed with the
> > FIELD_GET() or field_get() macros. IMHO this is a clear advantage to the
> 
> Can you elaborate?

Well, the way I see it, the only advantage of FIELD_GET() is that it
will auto-determine the type (based on the mask type.) This cannot work
if you need be/le conversions, because the be/le type annotations are
invisible to the compiler.

So obviously you could write a BE32_FIELD_GET(), but then really that's
equivalent to be32_get_bits() - note you you have to actually specify
the type in the macro name. I guess in theory you could make macros
where the type is an argument (like FIELD_GET_TYPE(be32, ...)), but I
don't see how that gains anything.

> > typed versions, and if you ask me we should get rid of the FIELD_GETand
> > FIELD_PREP entirely - difficult now, but at least let's not propagate
> > that?
> 
> I don't see why.

Just for being more regular, in the spirit of "there's exactly one
correct way of doing it" :)

johannes
