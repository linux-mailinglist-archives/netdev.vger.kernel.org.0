Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962B645C7C0
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 15:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351958AbhKXOpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 09:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354152AbhKXOpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 09:45:00 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEC2C22459D;
        Wed, 24 Nov 2021 06:09:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ehMa9pgWHBM7TnvPMQnjh4s1Rj7IHG2tDkzpNOpErAk=;
        t=1637762985; x=1638972585; b=MthxQG5X8zlcOYtgAwIU9XAMBQI61ts+APPLEFUMJz+6PiG
        zUIDfprGfp4uITF1NHPqp59IOvbY2qbQvKsmKrAmOSyiRTJpvAzSI8dI7IczyJlHDF7LVP9OPgfvr
        eJua/j9ZHIfCEKXrFs5QtXVPratkZb/y48R6jsbkq2eHfWNKOYqAkayzyCNoWrikwedZPxLKnZpJr
        GQw4lIzPBkRJ52WXlcSFsGmXXuplrTEHAqT43Fh6JprXcW/w9LbOp2ChgZP8eY2U6fJIU/s3AtWPD
        UbnXANwy5qujn3tf/p5fy/5XkPe4bNiFltzNVIlqVW+Px02LqlsM+PWowW2L7x2A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mpsw9-002JSq-Fw;
        Wed, 24 Nov 2021 15:07:49 +0100
Message-ID: <eea90adf2d51326f6d0bf0b97834063752a35c3f.camel@sipsolutions.net>
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
Date:   Wed, 24 Nov 2021 15:07:47 +0100
In-Reply-To: <20211124055935.416dc472@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1637592133.git.geert+renesas@glider.be>
         <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
         <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
         <20211122171739.03848154@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <CAMuHMdWAAGrQUZN18cnDTDUUhuPNTZTFkRMe2Sbf+s7CedPSxA@mail.gmail.com>
         <637a4183861a1f2cdab52b7652bfa7ed33fbcdd2.camel@sipsolutions.net>
         <20211123154922.600fd3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <05d4673a0343bfd83824d307e9cf8bf92e3814a6.camel@sipsolutions.net>
         <20211124055935.416dc472@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-11-24 at 05:59 -0800, Jakub Kicinski wrote:
> 
> FWIW I never found the be/le versions useful. Most of the time the data
> comes from bus accessors which swap or is unaligned so you have to do
> be/le_get_unaligned, which swaps. Plus if you access/set multiple
> fields you'd swap them one by one which seems wasteful.

Oh, we use them all the time in wifi!

I'm not sure I'm too concerned about wasteful - actually in wifi most of
the time it's little endian to start with, which matches the CPU for all
practical uses of wifi (**), and often we just access one field or so.
And anyway if we extract more than a single bit we need to swap anyway,
and I hope if it's just a single bit the compiler will optimize since
the one side is a constant? But whatever ...

(**) I had a fight with big-endian ARM a few years ago just to get wifi
tested on big-endian ...


> Right now it seems the uppercase macros are more prevalent.
> 

Not in my world ;-)

$ git grep FIELD_GET -- ... | wc -l
20
$ git grep le32_get_bits -- ... | wc -l
44
$ git grep le16_get_bits -- ... | wc -l
12
$ git grep u8_get_bits -- ... | wc -l
17

:-)

johannes
