Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC5E45B674
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:24:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241315AbhKXI1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:27:31 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:62577 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241316AbhKXI13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:27:29 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637742260; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=DLx8xZfugkoYBeo1v25B565K1wJJHlGolp3uooimdG4=; b=bNsxTrQyq9uGwuB3f2LyEcxsvAp9kD/C4fNIuYqL7wdR0INGNqkdkYAL6AQiYP+HKysGkv73
 CYHsPEgeVXDeFd7bJYmMA7Oz/1YUg44l72wHEEI5ntB8TnM3GEkzY/SvktnbEJA3SoSt3f0S
 PcTzk1aHGKk317FKx2i3qMH1ytk=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 619df6b3e7d68470afb02450 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Nov 2021 08:24:19
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EBD19C4338F; Wed, 24 Nov 2021 08:24:18 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 02E23C4338F;
        Wed, 24 Nov 2021 08:24:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 02E23C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
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
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
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
Subject: Re: [PATCH 01/17] bitfield: Add non-constant field_{prep,get}() helpers
References: <cover.1637592133.git.geert+renesas@glider.be>
        <3a54a6703879d10f08cf0275a2a69297ebd2b1d4.1637592133.git.geert+renesas@glider.be>
        <01b44b38c087c151171f8d45a2090474c2559306.camel@sipsolutions.net>
        <CAMuHMdUnBgFpqhgjf5AA0LH9MZOFALeC=YinZ4Tv_V+Y9hkRSg@mail.gmail.com>
Date:   Wed, 24 Nov 2021 10:24:02 +0200
In-Reply-To: <CAMuHMdUnBgFpqhgjf5AA0LH9MZOFALeC=YinZ4Tv_V+Y9hkRSg@mail.gmail.com>
        (Geert Uytterhoeven's message of "Tue, 23 Nov 2021 09:30:14 +0100")
Message-ID: <87sfvm55ct.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Hi Johannes,
>
> On Mon, Nov 22, 2021 at 5:33 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Mon, 2021-11-22 at 16:53 +0100, Geert Uytterhoeven wrote:
>> > The existing FIELD_{GET,PREP}() macros are limited to compile-time
>> > constants.  However, it is very common to prepare or extract bitfield
>> > elements where the bitfield mask is not a compile-time constant.
>> >
>>
>> I'm not sure it's really a good idea to add a third API here?
>>
>> We have the upper-case (constant) versions, and already
>> {u32,...}_get_bits()/etc.
>
> These don't work for non-const masks.
>
>> Also, you're using __ffs(), which doesn't work for 64-bit on 32-bit
>> architectures (afaict), so that seems a bit awkward.
>
> That's a valid comment. Can be fixed by using a wrapper macro
> that checks if typeof(mask) == u64, and uses an __ffs64() version when
> needed.
>
>> Maybe we can make {u32,...}_get_bits() be doing compile-time only checks
>> if it is indeed a constant? The __field_overflow() usage is already only
>> done if __builtin_constant_p(v), so I guess we can do the same with
>> __bad_mask()?
>
> Are all compilers smart enough to replace the division by
> field_multiplier(field) by a shift?

It looks like the answer is no as few weeks back I received a comment
internally that a team is seeing a slow down with u32_get_bits():

"Time taken for executing both the macros/inline function (in terms of microseconds)
(out of 3 Trails)
FIELD_GET	: 32, 31, 32
u32_get_bits	: 6379, 6664, 6558"

Sadly I didn't realise to ask what compiler they were using. But I still
prefer {u32,...}_get_bits() over FIELD_GET(), they are just so much
cleaner to use.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
